create or replace procedure SP_AH_REP_VERIFICACION_PASIVAS(P_CREUSR in VARCHAR
, P_TIPPRO in VARCHAR
, P_TIPMND in VARCHAR
, P_AGECOD in NUMBER
, P_FECINI in DATE
, P_FECFIN in DATE
, P_ERRCOD out VARCHAR
, P_ERRMSG out VARCHAR) as

---***
lc_sysdate DATE := SYSDATE;
---***
ps_Cod varchar2(100);
ps_Tipo varchar2(100);

ln_AGECODINI NUMBER;
ln_AGECODFIN NUMBER;
ln_MNDINI NUMBER;
ln_MNDFIN NUMBER;
---***

BEGIN
--dbms_output.put_line('SP_AH_REP_VERIFICACION_PASIVAS.INIT ...');
---***
DELETE FROM AQPB509 WHERE AQPB509CREUSR = TRIM(P_CREUSR);
COMMIT;
--dbms_output.put_line('SP_AH_REP_VERIFICACION_PASIVAS.DELETE AQPB509 USER: '||P_CREUSR);

---*** OTRAS CONDICIONES (AGENCIA y MONEDA)
IF(P_AGECOD = 0) THEN -- TODAS LAS AGENCIAS
   ln_AGECODINI := 1;
   ln_AGECODFIN := 9999999;
ELSE -- SOLO LA AGENCIA SELECCIONADA
   ln_AGECODINI := P_AGECOD;
   ln_AGECODFIN := P_AGECOD;
END IF;

IF(P_TIPMND = '000') THEN -- TODAS LAS MONEDAS
   ln_MNDINI := 0;
   ln_MNDFIN := 9999999;
ELSIF (P_TIPMND = '001') THEN -- SOLES
   ln_MNDINI := 0;
   ln_MNDFIN := 0;
ELSIF (P_TIPMND = '002') THEN -- DOLARES
   ln_MNDINI := 101;
   ln_MNDFIN := 101;
ELSE
   ln_MNDINI := 0;
   ln_MNDFIN := 9999999;
END IF;
---***

IF(P_TIPPRO IN ('000', '002')) THEN
   INSERT INTO AQPB509(
   SELECT DISTINCT creusr, PRODUCTO, Nro_Cuenta, codigo, mydate, COD_AGE, AGENCIA, FECHA_APERTURA,
                TIPO_OPERACION, TIPO_CUENTA, MOSIGN, TITULAR, TIP_DOCUM,
                NRO_DOCUM, MTO_APERTURA, TASA, XOPERADOR, ESTADO, SECTOR,
                TIPO_CONTRATACION, DEPARTAMENTO, PROVINCIA, DISTRITO, DIRECCION,
                TELEFONOS, CORREO, ACTIVIDAD_CIIU, TIPO_APERTURA,
                PGCOD, AOSUC, AOMOD, AOMDA, AOPAP, AOCTA, AOOPER, AOSBOP,
                AOTOPE, AOFVAL, HCMOD, HSUCOR, HTRAN, HNREL, HFCON, HCORD, HCSUBO
   FROM
   (SELECT
       P_CREUSR creusr,
       trim(t_003.mdnom) Producto,
       lpad(d_010.aocta,9,'0') ||
       lpad(d_010.aomod,3,'0') ||
       lpad(d_010.aomda,3,'0') ||
       lpad(d_010.aosbop,2,'0') ||
       lpad(d_010.aotope,3,'0') Nro_Cuenta,
       ROWNUM codigo,
       lc_sysdate mydate,
       d_010.aosuc Cod_Age,
       FN_AH_AGENCIAV(d_010.pgcod, d_010.aosuc) Agencia,
       d_010.aofval Fecha_Apertura,

       trim(t_004.tonom) Tipo_Operacion,

       FN_AH_TIPO_CTAV(d_010.pgcod, d_010.aosuc, d_010.aomda,
                   d_010.aopap, d_010.aocta, d_010.aooper,
                   d_010.aosbop, d_010.aotope, d_010.aomod) Tipo_Cuenta,
       t_005.mosign,
       FN_AH_NOMBRE_APELLIDOV(r_008.pepais, r_008.petdoc, r_008.pendoc, 0) Titular,
       t_014.tdnom Tip_Docum,
       r_008.pendoc Nro_Docum,
       d_010.aoimp Mto_Apertura,

       FN_AH_TASA_AHORROSV(d_010.pgcod, d_010.aosuc, d_010.aocta,
                       d_010.aomda, d_010.aopap, d_010.aooper,
                       d_010.aosbop, d_010.aotope, d_010.aomod) Tasa,
       '          ' xOperador,
       trim(t_026.cenom) Estado,
       (select trim(t_104.secnom)
          from fsd008 d_008
         inner join fst104 t_104
            on t_104.seccod = d_008.seccod
         where d_008.pgcod = d_010.pgcod
           and d_008.ctnro = d_010.aocta) Sector,
       case
          when d_010.aotope = 12 then
             'Digital'
          else
             'Normal'
       end Tipo_Contratacion,

       FN_AH_DIRECCIONV(r_008.pepais, r_008.petdoc, r_008.pendoc, 1, 2) Departamento,
       FN_AH_DIRECCIONV(r_008.pepais, r_008.petdoc, r_008.pendoc, 1, 3) Provincia,
       FN_AH_DIRECCIONV(r_008.pepais, r_008.petdoc, r_008.pendoc, 1, 4) Distrito,
       FN_AH_DIRECCIONV(r_008.pepais, r_008.petdoc, r_008.pendoc, 1, 1) Direccion,
       FN_AH_TELEFONOV(r_008.pepais, r_008.petdoc, r_008.pendoc, 3, 1) Telefonos,
       FN_AH_CORREOV(d_010.pgcod, d_010.aocta) Correo,

       (select trim(t_750.actnom1)
          from fsd008 d_008
         inner join fst750 t_750
            on t_750.actcod1 = d_008.ctnroi
         where d_008.pgcod = d_010.pgcod
           and d_008.ctnro = d_010.aocta) Actividad_CIIU,
       ' ' Tipo_Apertura,
       d_010.pgcod,
       d_010.aosuc,
       d_010.aomod,
       d_010.aomda,
       d_010.aopap,
       d_010.aocta,
       d_010.aooper,
       d_010.aosbop,
       d_010.aotope,
       d_010.aofval,
       0 hcmod,
       0 hsucor,
       0 htran,
       0 hnrel,
       to_date('01/01/1901','dd/mm/yyyy') hfcon,
       0 hcord,
       0 hcsubo
  from fsd010 d_010,
       fst003 t_003,
       fst004 t_004,
       fst005 t_005,
       fst014 t_014,
       fst026 t_026,
       fsr008 r_008
  where
    d_010.pgcod = 1
    AND d_010.aomod = 22
    AND d_010.aosbop = 0
    AND d_010.aosuc  BETWEEN ln_AGECODINI AND ln_AGECODFIN
    AND d_010.aofval BETWEEN P_FECINI AND P_FECFIN
    AND d_010.aomda  BETWEEN ln_MNDINI AND ln_MNDFIN
    AND d_010.aomod = t_003.modulo
    AND d_010.aomod = t_004.modulo
    AND d_010.aotope = t_004.totope
    AND d_010.aomda = t_005.moneda
    AND r_008.petdoc = t_014.tdocum
    AND d_010.aostat = t_026.cecod
    AND d_010.pgcod = r_008.pgcod
    AND d_010.aocta = r_008.ctnro
    AND r_008.cttfir = 'T'));

   update AQPB509 x1
   set (x1.AQPB509OPERAD, x1.AQPB509HCMOD, x1.AQPB509HSUCOR, x1.AQPB509HTRAN,
        x1.AQPB509HNREL, x1.AQPB509HFCON, x1.AQPB509HCORD, x1.AQPB509HCSUBO) = (select distinct h_015.husing, h_016.hcmod, h_016.hsucor, h_016.htran,
                                                                    h_016.hnrel, h_016.hfcon, h_016.hcord, h_016.hcsubo
                                                    from fsh016 h_016
                                                   inner join fsh015 h_015
                                                      on h_015.pgcod  = h_016.pgcod
                                                     and h_015.hcmod  = h_016.hcmod
                                                     and h_015.hsucor = h_016.hsucor
                                                     and h_015.htran  = h_016.htran
                                                     and h_015.hnrel  = h_016.hnrel
                                                     and h_015.hfcon  = h_016.hfcon
                                                   where
                                                     x1.AQPB509CREUSR = P_CREUSR
                                                     and h_016.pgcod  = x1.AQPB509pgcod
                                                     and h_016.hsucur = x1.AQPB509aosuc
                                                     and h_016.hmodul = x1.AQPB509aomod
                                                     and h_016.hmda   = x1.AQPB509aomda
                                                     and h_016.hpap   = x1.AQPB509aopap
                                                     and h_016.hcta   = x1.AQPB509aocta
                                                     and h_016.hoper  = x1.AQPB509aooper
                                                     and h_016.hsubop = x1.AQPB509aosbop
                                                     and h_016.htoper = x1.AQPB509aotope
                                                     and h_016.hfval  = x1.AQPB509aofval
                                                     and h_015.hccorr <> 99
                                                     and h_015.hcmod <> 99
                                                     and rownum = 1);
---***
commit;
---***
FOR c_Det IN
  (SELECT x1.rowid, x1.AQPB509pgcod, x1.AQPB509hsucor, x1.AQPB509hcmod, x1.AQPB509htran, x1.AQPB509hnrel, x1.AQPB509hfcon
   FROM AQPB509 x1 WHERE x1.AQPB509CREUSR = P_CREUSR)
   loop
      begin
         SP_OP_USO_BIOMETRIA_CDIGITAL(c_Det.AQPB509pgcod, c_Det.AQPB509hsucor, c_Det.AQPB509hcmod,
                                               c_Det.AQPB509htran, c_Det.AQPB509hnrel, c_Det.AQPB509hfcon,
                                               ps_Cod, ps_Tipo);
         update AQPB509 x1
            set x1.AQPB509TIPAPE = trim(ps_Tipo)
          where x1.rowid = c_Det.rowid;
          commit;
      end;
   end loop;

   ---***
   COMMIT;
   ---***
   END IF;
   ---***

IF(P_TIPPRO IN ('000', '001')) THEN
INSERT INTO AQPB509(
SELECT DISTINCT creusr, PRODUCTO, Nro_Cuenta, codigo, mydate, COD_AGE, AGENCIA, FECHA_APERTURA,
                TIPO_OPERACION, TIPO_CUENTA, MOSIGN, TITULAR, TIP_DOCUM,
                NRO_DOCUM, MTO_APERTURA, TASA, OPERADOR, ESTADO, SECTOR,
                TIPO_CONTRATACION, DEPARTAMENTO, PROVINCIA, DISTRITO, DIRECCION,
                TELEFONOS, CORREO, ACTIVIDAD_CIIU, TIPO_APERTURA,
                PGCOD, AOSUC, AOMOD, AOMDA, AOPAP, AOCTA, AOOPER, AOSBOP,
                AOTOPE, AOFVAL, HCMOD, HSUCOR, HTRAN, HNREL, HFCON, HCORD, HCSUBO

FROM
(select P_CREUSR creusr,
        trim(t_003.mdnom) Producto,
        lpad(d_011.sccta,9,'0') ||
        lpad(d_011.scmod,3,'0') ||
        lpad(d_011.scmda,3,'0') ||
        lpad(d_011.scsbop,2,'0') ||
        lpad(d_011.sctope,3,'0') Nro_Cuenta,
        ROWNUM codigo,
        lc_sysdate mydate,
        d_011.scsuc Cod_Age,
        FN_AH_AGENCIAV(d_011.pgcod, d_011.scsuc) Agencia,
        d_011.scfval Fecha_Apertura,
        trim(t_004.tonom) Tipo_Operacion,

       FN_AH_TIPO_CTAV(d_011.pgcod, d_011.scsuc, d_011.scmda,
                   d_011.scpap, d_011.sccta, d_011.scoper,
                   d_011.scsbop, d_011.sctope, d_011.scmod) Tipo_Cuenta,

       t_005.mosign,
       FN_AH_NOMBRE_APELLIDOV(r_008.pepais, r_008.petdoc, r_008.pendoc, 0) Titular,
       t_014.tdnom Tip_Docum,
       r_008.pendoc Nro_Docum,
       0 Mto_Apertura,

       FN_AH_TASA_AHORROSV(d_011.pgcod, d_011.scsuc, d_011.sccta,
                       d_011.scmda, d_011.scpap, d_011.scoper,
                       d_011.scsbop, d_011.sctope, d_011.scmod) Tasa,

       (select e_113.cv1aux6
          from fse113 e_113
         where e_113.pgcod   = d_011.pgcod
           and e_113.cv1mod  = d_011.scmod
           and e_113.cv1mda  = d_011.scmda
           and e_113.cv1pap  = d_011.scpap
           and e_113.cv1cta  = d_011.sccta
           and e_113.cv1suc  = d_011.scsuc
           and e_113.cv1oper = d_011.scoper
           and e_113.cv1sbop = d_011.scsbop
           and e_113.cv1tope = d_011.sctope) Operador,
       trim(t_026.cenom) Estado,
       (select trim(t_104.secnom)
          from fsd008 d_008
         inner join fst104 t_104
            on t_104.seccod = d_008.seccod
         where d_008.pgcod = d_011.pgcod
           and d_008.ctnro = d_011.sccta) Sector,
       case
          when d_011.sctope = 12 then
             'Digital'
          else
             'Normal'
       end Tipo_Contratacion,
       FN_AH_DIRECCIONV(r_008.pepais, r_008.petdoc, r_008.pendoc, 1, 2) Departamento,
       FN_AH_DIRECCIONV(r_008.pepais, r_008.petdoc, r_008.pendoc, 1, 3) Provincia,
       FN_AH_DIRECCIONV(r_008.pepais, r_008.petdoc, r_008.pendoc, 1, 4) Distrito,
       FN_AH_DIRECCIONV(r_008.pepais, r_008.petdoc, r_008.pendoc, 1, 1) Direccion,
       FN_AH_TELEFONOV(r_008.pepais, r_008.petdoc, r_008.pendoc, 3, 1) Telefonos,
       FN_AH_CORREOV(d_011.pgcod, d_011.sccta) Correo,
       (select trim(t_750.actnom1)
          from fsd008 d_008
         inner join fst750 t_750
            on t_750.actcod1 = d_008.ctnroi
         where d_008.pgcod = d_011.pgcod
           and d_008.ctnro = d_011.sccta) Actividad_CIIU,
      'Contratación Normal' Tipo_Apertura

      , 0 AS PGCOD, 0 AS AOSUC, 0 AS AOMOD, 0 AS AOMDA
      , 0 AS AOPAP, 0 AS AOCTA, 0 AS AOOPER, 0 AS AOSBOP
      , 0 AS AOTOPE, NULL AS AOFVAL,
      0 hcmod,
      0 hsucor,
      0 htran,
      0 hnrel,
      to_date('01/01/1901','dd/mm/yyyy') hfcon,
      0 hcord,
      0 hcsubo

  from
       fsd011 d_011,
       fst003 t_003,
       fst004 t_004,
       fst005 t_005,
       fst014 t_014,
       fst026 t_026,
       fsr008 r_008

    WHERE d_011.pgcod = 1
    AND d_011.scmod = 21
    AND d_011.scsuc BETWEEN ln_AGECODINI AND ln_AGECODFIN
    AND d_011.scfval BETWEEN P_FECINI AND P_FECFIN
    AND d_011.scmda  BETWEEN ln_MNDINI AND ln_MNDFIN
    AND d_011.scmod = t_003.modulo
    AND d_011.scmod = t_004.modulo
    AND d_011.sctope = t_004.totope
    AND d_011.scmda = t_005.moneda
    AND r_008.petdoc = t_014.tdocum
    AND d_011.scstat = t_026.cecod
    AND d_011.pgcod = r_008.pgcod
    AND d_011.sccta = r_008.ctnro
    AND r_008.cttfir = 'T'));

   ---***
   COMMIT;
   ---***
   END IF;
   ---***
---***
P_ERRCOD := '000';
P_ERRMSG := 'PROCESO TERMINADO SATISFACTORIAMENTE!!!';
---***
exception
  when others then
    ---***
    P_ERRCOD := '002';
    P_ERRMSG := 'OCURRIO UN ERROR AL GENERAR EL REPORTE (SP)';
    --P_ERRMSG := 'OCURRIO UN ERROR : '||SQLCODE||' :ERROR: '||SQLERRM;
END;
/

