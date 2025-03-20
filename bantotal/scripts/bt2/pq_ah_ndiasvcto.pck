create or replace package PQ_AH_NDIASVCTO is
-- ------------------------------------------------------------------------------------------------
  -- NOMBRE                : PQ_AH_NDIASVCTO
  -- SISTEMA               : BANTOTAL
  -- M¿DULO                : ACTIVAS
  -- VERSI¿N               : 1.0
  -- FECHA DE CREACION     : 19/03/14
  -- AUTOR DE CREACION     : SILVIA PATRICIA MARQUEZ AVENDAÑO
  -- APLICACION            : REALIZA LA INSERCION EN TABLA JAQY664 PARA SU POSTERIOR DESPLIEGUE
  -- ESTADO                : ACTIVO
  -- ACCESO                : PUBLICO
   --------------------------------------------------------------------------------------------------
  -- Modificacion          : Smarquez 18/03/2015
  -- ------------------------------------------------------------------------------------------------
PROCEDURE LLENA_TABLA (P_SUCURSAL IN NUMBER,
                       P_DIAS     IN NUMBER,
                       P_ACCION   IN NUMBER,
                       P_USUARIO  IN VARCHAR2);
----------------------------------------------------------------------------------------------------
PROCEDURE CTS_GARANTIA(P_SUCURSAL IN NUMBER,
                       P_DIAS     IN NUMBER,
                       P_ACCION   IN NUMBER,
                       P_USUARIO  IN VARCHAR2);

----------------------------------------------------------------------------------------------------
Function fn_moneda (v_moneda in number) return varchar2;
----------------------------------------------------------------------------------------------------
function fn_tipo_TitularAvalConyuge (dnicre in char,
                                      tipdoc in number,
                                      dniaho in char) return varchar2;
---------------------------------------------------------------------------------------------------
END PQ_AH_NDIASVCTO;
/

create or replace package body PQ_AH_NDIASVCTO is
-- ------------------------------------------------------------------------------------------------
  -- NOMBRE                : PQ_AH_NDIASVCTO
  -- SISTEMA               : BANTOTAL
  -- M¿DULO                : ACTIVAS
  -- VERSI¿N               : 1.0
  -- FECHA DE CREACION     : 19/03/14
  -- AUTOR DE CREACION     : SILVIA PATRICIA MARQUEZ AVENDAÑO
  -- APLICACION            : REALIZA LA INSERCION EN TABLA JAQY664 PARA SU POSTERIOR DESPLIEGUE
  -- ESTADO                : ACTIVO
  -- ACCESO                : PUBLICO
   --------------------------------------------------------------------------------------------------
  -- Modificacion          : Smarquez 18/03/2015
  -- ------------------------------------------------------------------------------------------------
PROCEDURE LLENA_TABLA (P_SUCURSAL IN NUMBER,
                       P_DIAS     IN NUMBER,
                       P_ACCION   IN NUMBER,
                       P_USUARIO  IN VARCHAR2) is

cursor llenat(v_fecha in date) is
   select distinct  j64.jaql964ren as Region_cre,
                    j64.jaql964nom as sucursal_cre,
                    jaql964usu as Analista_cre,
                    j64.jaql964tit as Titular_cre,
                    j64.jaql964doc as Numero_doc,
                    decode(J64.JAQL964MDA, 0, 'NUEVOS SOLES', 'DOLARES') as Mda_Credito,
                    cre.scsuc as CodSuc_cre,
                    cre.scmda as Mda_cre,
                    cre.scpap as papel_cre,
                    cre.sccta as Cuenta_Credito,
                    cre.scoper as Operacion_Cred,
                    cre.scsbop as Sub_Cred,
                    cre.sctope as Tip_Oper_Cred,
                    cre.scmod as Mod_Cred,
                    cre.scsdo as Saldo_Cred,
                    pq_cr_creditos.fn_cuotas_pagadas(cre.pgcod,
                                                     cre.scmod,
                                                     cre.scsuc,
                                                     cre.scmda,
                                                     cre.scpap,
                                                     cre.sccta,
                                                     cre.scoper,
                                                     cre.scsbop,
                                                     cre.sctope,
                                                     v_fecha) as Nro_Cuota_atrasada,
                    (pq_cr_creditos.fn_monto_atrasado(cre.pgcod,
                                                      cre.scmod,
                                                      cre.scsuc,
                                                      cre.scmda,
                                                      cre.scpap,
                                                      cre.sccta,
                                                      cre.scoper,
                                                      cre.scsbop,
                                                      cre.sctope,
                                                      v_fecha) + (j64.jaql964gas + j64.jaql964mor))as Total_deuda,
                    j64.jaql964dia as dia_atraso,
                    fr8.pendoc as DNI_AHORRO ,
                    (fn_tipo_TitularAvalConyuge(j64.jaql964doc,
                                                j64.jaql964tid,
                                                fr8.pendoc))as Rel_Credito,
                   (select scnom  from fst001 where sucurs = aa.aosuc)  as Sucursal_Aho,
                    fn_moneda(aa.AOmda)as Moneda_Ahorro,
                    aa.AOsuc as suc_aho,
                    aa.aomda as mda_aho,
                    aa.aopap as pap_aho,
                    aa.aocta as cta_aho,
                    aa.aooper as ope_aho,
                    aa.aosbop as sub_aho,
                    aa.aotope as top_aho,
                    aa.aomod as mod_aho,
                    aa.aoimp as saldo_aho,
                    aa.cenom as estado_aho,
                    PQ_CR_CREDITOS.fn_facultad_cta(aa.pgcod,
                                                   aa.aosuc,
                                                   aa.aomda,
                                                   aa.aopap,
                                                   aa.aocta,
                                                   aa.aooper,
                                                   aa.aosbop,
                                                   aa.aotope,
                                                   aa.aomod) as facultad_aho,
                   (select depnom from FST068 where depcod = s13.sngc13dpto) as departamento,
                   (select concat((select (trim(fst071dsc)|| ' - ') from FST071 where fst071dpt = s13.sngc13prov and fst071loc= s13.sngc13prov and fst071col = s13.sngc13dist),(select trim(locnom)from FST070 where depcod = s13.sngc13dpto and loccod = s13.sngc13prov)) from dual) as DistritoProvincia,
                   s13.sngc13dir as direccion
  from fsd011 cre,
       jaql964 j64,
       fsr008 fr8,
       SNG122 s22,
       FSR011 f11,
       SNGC13 s13,
       (SELECT a.PGCOD,
               AOSUC,
               AOMDA,
               AOPAP,
               AOCTA,
               AOOPER,
               AOSBOP,
               AOTOPE,
               AOMOD,
               AOFVAL,
               AOFVTO,
               AOPZO,
               AOIMP,
               AOSTAT,
               e.cenom,
               p.tonom
          from fsd010 a, fst026 e, fst004 p
         where a.pgcod = 1
           and a.aomod = 22 --in (21,
           and a.aostat = 80 --in( 80,85)--considera solo vigentes
           and a.aostat = e.cecod
           and a.aomod = p.modulo
           and a.aotope = p.totope ) aa
 where cre.pgcod = 1
   and cre.scrub in (select rubro
                       from fsd014
                      where pcimpu = 'S'
                        and pcnivc in (select modulo
                                         from fst111
                                        where dscod = 50
                                          and modulo not in (33, 120, 141, 144, 200))
                     )
   and cre.scsdo <> 0
   AND J64.JAQL964MOD <>108
   and j64.jaql964suc = cre.scsuc
   and j64.jaql964cta = cre.sccta
   and j64.jaql964mod = cre.scmod
   and j64.jaql964mda = cre.scmda
   and j64.jaql964ope = cre.scoper
   and j64.jaql964sob = cre.scsbop
   and j64.jaql964top = cre.sctope
   and j64.jaql964dia >= P_DIAS--15 ----PARAMETRO
   and s22.sng122inst = j64.jaql964ins
   and f11.R2cod = s22.sng122pgc
   and f11.R2mod = s22.sng122mod
   and f11.R2suc = s22.sng122suc
   and f11.R2mda = s22.sng122mda
   and f11.R2pap = s22.sng122pap
   and f11.R2cta = s22.sng122cta
   and f11.R2oper = s22.sng122oper
   and f11.R2sbop = s22.sng122sbop
   and f11.R2tope = s22.sng122tope
   and f11.Relcod = 2
   and f11.R011co='S'
   and fr8.pgcod = 1
   and fr8.pepais = 604
   and fr8.cttfir = 'T'
   and fr8.petdoc = j64.jaql964tid
   and fr8.pendoc = j64.jaql964doc
   and s13.sngc13pais = fr8.pepais
   and s13.sngc13tdoc = fr8.petdoc
   and s13.sngc13ndoc = fr8.pendoc
   and s13.sngc13est = 'H'
   and s13.sngc13corr = 1
   and s13.docod = 1
   and aa.pgcod = f11.r1cod
   and aa.aosuc = f11.r1suc
   and aa.aomda = f11.r1mda
   and aa.aopap = f11.r1pap
   and aa.aocta = f11.r1cta
   and aa.aooper = f11.r1oper
   and aa.aosbop = f11.r1sbop
   and aa.aotope = f11.r1tope
   and aa.aomod = f11.r1mod
   AND PQ_CR_CREDITOS.fn_facultad_cta(aa.pgcod,
                                      aa.aosuc,
                                      aa.aomda,
                                      aa.aopap,
                                      aa.aocta,
                                      aa.aooper,
                                      aa.aosbop,
                                      aa.aotope,
                                      aa.aomod) <> 'MANCOMUNADA'
  AND NOT EXISTS (SELECT 1
                    FROM JAQY666 j6
                   WHERE j6.jaqy666suc = j64.jaql964suc
                     and j6.jaqy666cta = j64.jaql964cta
                     and j6.jaqy666mda = j64.jaql964mda
                     and j6.jaqy666mod = j64.jaql964mod
                     and j6.jaqy666ope = j64.jaql964ope
                     and j6.jaqy666sop = j64.jaql964sob
                     and j6.jaqy666top = j64.jaql964top
                     and j6.jaqy666est = 'S'
                     and v_fecha BETWEEN j6.jaqy666fini and j6.jaqy666ffin);

CURSOR LLENAT_SUCURSAL (v_fecha in date) is
   select distinct  j64.jaql964ren as Region_cre,
                    j64.jaql964nom as sucursal_cre,
                    jaql964usu as Analista_cre,
                    j64.jaql964tit as Titular_cre,
                    j64.jaql964doc as Numero_doc,
                    decode(J64.JAQL964MDA, 0, 'NUEVOS SOLES', 'DOLARES') as Mda_Credito,
                    cre.scsuc as CodSuc_cre,
                    cre.scmda as Mda_cre,
                    cre.scpap as papel_cre,
                    cre.sccta as Cuenta_Credito,
                    cre.scoper as Operacion_Cred,
                    cre.scsbop as Sub_Cred,
                    cre.sctope as Tip_Oper_Cred,
                    cre.scmod as Mod_Cred,
                    cre.scsdo as Saldo_Cred,
                    pq_cr_creditos.fn_cuotas_pagadas(cre.pgcod,
                                                     cre.scmod,
                                                     cre.scsuc,
                                                     cre.scmda,
                                                     cre.scpap,
                                                     cre.sccta,
                                                     cre.scoper,
                                                     cre.scsbop,
                                                     cre.sctope,
                                                     v_fecha) as Nro_Cuota_atrasada,
                    (pq_cr_creditos.fn_monto_atrasado(cre.pgcod,
                                                      cre.scmod,
                                                      cre.scsuc,
                                                      cre.scmda,
                                                      cre.scpap,
                                                      cre.sccta,
                                                      cre.scoper,
                                                      cre.scsbop,
                                                      cre.sctope,
                                                      v_fecha) + (j64.jaql964gas + j64.jaql964mor))as Total_deuda,
                    j64.jaql964dia as dia_atraso,
                    fr8.pendoc as DNI_AHORRO ,
                    (fn_tipo_TitularAvalConyuge(j64.jaql964doc,
                                                j64.jaql964tid,
                                                fr8.pendoc))as Rel_Credito,
                    (select scnom  from fst001 where sucurs = aa.aosuc)  as Sucursal_Aho,
                    fn_moneda(aa.AOmda)as Moneda_Ahorro,
                    aa.AOsuc as suc_aho,
                    aa.aomda as mda_aho,
                    aa.aopap as pap_aho,
                    aa.aocta as cta_aho,
                    aa.aooper as ope_aho,
                    aa.aosbop as sub_aho,
                    aa.aotope as top_aho,
                    aa.aomod as mod_aho,
                    aa.aoimp as saldo_aho,
                    aa.cenom as estado_aho,
                    PQ_CR_CREDITOS.fn_facultad_cta(aa.pgcod,
                                                   aa.aosuc,
                                                   aa.aomda,
                                                   aa.aopap,
                                                   aa.aocta,
                                                   aa.aooper,
                                                   aa.aosbop,
                                                   aa.aotope,
                                                   aa.aomod) as facultad_aho,
                   (select depnom from FST068 where depcod = s13.sngc13dpto ) as departamento,
                   (select concat((select (trim(fst071dsc)|| ' - ') from FST071 where fst071dpt = s13.sngc13prov and fst071loc= s13.sngc13prov and fst071col = s13.sngc13dist),(select trim(locnom)from FST070 where depcod = s13.sngc13dpto and loccod = s13.sngc13prov)) from dual) as DistritoProvincia,
                   s13.sngc13dir as direccion
  from fsd011 cre,
       jaql964 j64,
       fsr008 fr8,
       SNG122 s22,
       FSR011 f11,
       SNGC13 S13,
       (SELECT a.PGCOD,
               AOSUC,
               AOMDA,
               AOPAP,
               AOCTA,
               AOOPER,
               AOSBOP,
               AOTOPE,
               AOMOD,
               AOFVAL,
               AOFVTO,
               AOPZO,
               AOIMP,
               AOSTAT,
               e.cenom,
               p.tonom
          from fsd010 a, fst026 e, fst004 p
         where a.pgcod = 1
           and a.aomod = 22 --in (21,
           and a.aostat = 80 --in( 80,85)--considera solo vigentes
           and a.aostat = e.cecod
           and a.aomod = p.modulo
           and a.aotope = p.totope ) aa
 where cre.pgcod = 1
   and cre.scrub in (select rubro
                       from fsd014
                      where pcimpu = 'S'
                        and pcnivc in (select modulo
                                         from fst111
                                        where dscod = 50
                                          and modulo not in (33, 120, 141, 144, 200))
                     )
   and cre.scsdo <> 0
  -- and cre.sctope = 550--<>
   and j64.jaql964suc = cre.scsuc
   and j64.jaql964cta = cre.sccta
   and j64.jaql964mod = cre.scmod
   and j64.jaql964mda = cre.scmda
   and j64.jaql964ope = cre.scoper
   and j64.jaql964sob = cre.scsbop
   and j64.jaql964top = cre.sctope
   AND j64.jaql964mod <> 108
   and j64.jaql964suc = P_SUCURSAL
   and j64.jaql964dia >= P_DIAS--15 ----PARAMETRO
   and s22.sng122inst = j64.jaql964ins
   and f11.R2cod = s22.sng122pgc
   and f11.R2mod = s22.sng122mod
   and f11.R2suc = s22.sng122suc
   and f11.R2mda = s22.sng122mda
   and f11.R2pap = s22.sng122pap
   and f11.R2cta = s22.sng122cta
   and f11.R2oper = s22.sng122oper
   and f11.R2sbop = s22.sng122sbop
   and f11.R2tope = s22.sng122tope
   and f11.Relcod = 2
   and f11.R011co='S'
   and fr8.pgcod = 1
   and fr8.pepais = 604
   and fr8.cttfir = 'T'
   and fr8.petdoc = j64.jaql964tid
   and fr8.pendoc = j64.jaql964doc
   AND S13.SNGC13PAIS = FR8.PEPAIS
   AND S13.SNGC13TDOC = FR8.PETDOC
   AND S13.SNGC13NDOC = FR8.PENDOC
   and s13.sngc13corr = 1
   and s13.docod = 1
   and s13.sngc13est = 'H'
   and aa.pgcod = f11.r1cod
   and aa.aosuc = f11.r1suc
   and aa.aomda = f11.r1mda
   and aa.aopap = f11.r1pap
   and aa.aocta = f11.r1cta
   and aa.aooper = f11.r1oper
   and aa.aosbop = f11.r1sbop
   and aa.aotope = f11.r1tope
   and aa.aomod = f11.r1mod
   AND PQ_CR_CREDITOS.fn_facultad_cta(aa.pgcod,
                                      aa.aosuc,
                                      aa.aomda,
                                      aa.aopap,
                                      aa.aocta,
                                      aa.aooper,
                                      aa.aosbop,
                                      aa.aotope,
                                      aa.aomod) <> 'MANCOMUNADA'
   AND NOT EXISTS (SELECT 1
                    FROM JAQY666 j6
                   WHERE j6.jaqy666suc = j64.jaql964suc
                     and j6.jaqy666cta = j64.jaql964cta
                     and j6.jaqy666mda = j64.jaql964mda
                     and j6.jaqy666mod = j64.jaql964mod
                     and j6.jaqy666ope = j64.jaql964ope
                     and j6.jaqy666sop = j64.jaql964sob
                     and j6.jaqy666top = j64.jaql964top
                     and j6.jaqy666est = 'S'
                     and v_fecha BETWEEN j6.jaqy666fini and j6.jaqy666ffin);
  fecha date;
  V_nrocuota number;
begin

    select pgfape
      into fecha
      from fst017
     where pgcod = 1;

    CASE P_ACCION
    WHEN 1 THEN
          DELETE JAQY664
           WHERE JAQY664AUX3 = P_USUARIO;
          if P_SUCURSAL = 0 then
              for I in llenat(fecha) loop
                bEGIN
                  V_nrocuota := I.Nro_Cuota_atrasada + 1;
                  insert into jaqy664 (JAQY664REG,
                                      JAQY664SUC,
                                      JAQY664ANA,
                                      JAQY664TIT,
                                      JAQY664NROD,
                                      JAQY664MDAC,
                                      JAQY664SUCC,
                                      JAQY664CMDA,
                                      JAQY664PAPC,
                                      JAQY664CTAC,
                                      JAQY664OPEC,
                                      JAQY664SUBOC,
                                      JAQY664TOPEC,
                                      JAQY664MODC,
                                      JAQY664SALC,
                                      JAQY664NCA,
                                      JAQY664TOTD,
                                      JAQY664DIAM,
                                      JAQY664DNIA,
                                      JAQY664RELA,
                                      JAQY664SUCAL,
                                      JAQY664MDAL,
                                      JAQY664SUCA,
                                      JAQY664MDAA,
                                      JAQY664PAPA,
                                      JAQY664CTAA,
                                      JAQY664OPEA,
                                      JAQY664SUBOA,
                                      JAQY664TOPEA,
                                      JAQY664MODA,
                                      JAQY664SALA,
                                      JAQY664EST,
                                      JAQY664TIPO,
                                      JAQY664AUX3,
                                      JAQY664AUX5,
                                      JAQY664AUX6,
                                      JAQY664AUX7)
                            values (I.Region_cre,
                                    I.sucursal_cre,
                                    I.Analista_cre,
                                    I.Titular_cre,
                                    I.Numero_doc,
                                    I.Mda_Credito,
                                    I.CodSuc_cre,
                                    I.Mda_cre,
                                    I.papel_cre,
                                    I.Cuenta_Credito,
                                    I.Operacion_Cred,
                                    I.Sub_Cred,
                                    I.Tip_Oper_Cred,
                                    I.Mod_Cred,
                                    I.Saldo_Cred,
                                    V_nrocuota, ---I.Nro_Cuota_atrasada,
                                    I.Total_deuda,
                                    I.dia_atraso,
                                    I.DNI_AHORRO ,
                                    I.Rel_Credito,
                                    I.Sucursal_Aho,
                                    I.Moneda_Ahorro,
                                    I.suc_aho,
                                    I.mda_aho,
                                    I.pap_aho,
                                    I.cta_aho,
                                    I.ope_aho,
                                    I.sub_aho,
                                    I.top_aho,
                                    I.mod_aho,
                                    I.saldo_aho,
                                    I.estado_aho,
                                    I.facultad_aho,
                                    P_USUARIO,
                                    I.DEPARTAMENTO,
                                    I.DISTRITOPROVINCIA,
                                    I.DIRECCION);
                 EXCEPTION
                   WHEN DUP_VAL_ON_INDEX THEN
                     NULL;
                END;

              end loop;
              COMMIT;
          else
              for h in LLENAT_SUCURSAL(fecha) loop
                  V_nrocuota := h.Nro_Cuota_atrasada + 1;
                  insert into jaqy664 (JAQY664REG,
                                      JAQY664SUC,
                                      JAQY664ANA,
                                      JAQY664TIT,
                                      JAQY664NROD,
                                      JAQY664MDAC,
                                      JAQY664SUCC,
                                      JAQY664CMDA,
                                      JAQY664PAPC,
                                      JAQY664CTAC,
                                      JAQY664OPEC,
                                      JAQY664SUBOC,
                                      JAQY664TOPEC,
                                      JAQY664MODC,
                                      JAQY664SALC,
                                      JAQY664NCA,
                                      JAQY664TOTD,
                                      JAQY664DIAM,
                                      JAQY664DNIA,
                                      JAQY664RELA,
                                      JAQY664SUCAL,
                                      JAQY664MDAL,
                                      JAQY664SUCA,
                                      JAQY664MDAA,
                                      JAQY664PAPA,
                                      JAQY664CTAA,
                                      JAQY664OPEA,
                                      JAQY664SUBOA,
                                      JAQY664TOPEA,
                                      JAQY664MODA,
                                      JAQY664SALA,
                                      JAQY664EST,
                                      JAQY664TIPO,
                                      JAQY664AUX3,
                                      JAQY664AUX5,
                                      JAQY664AUX6,
                                      JAQY664AUX7)
                            values (h.Region_cre,
                                    h.sucursal_cre,
                                    h.Analista_cre,
                                    h.Titular_cre,
                                    h.Numero_doc,
                                    h.Mda_Credito,
                                    h.CodSuc_cre,
                                    h.Mda_cre,
                                    h.papel_cre,
                                    h.Cuenta_Credito,
                                    h.Operacion_Cred,
                                    h.Sub_Cred,
                                    h.Tip_Oper_Cred,
                                    h.Mod_Cred,
                                    h.Saldo_Cred,
                                    V_nrocuota,---h.Nro_Cuota_atrasada,
                                    h.Total_deuda,
                                    h.dia_atraso,
                                    h.DNI_AHORRO ,
                                    h.Rel_Credito,
                                    h.Sucursal_Aho,
                                    h.Moneda_Ahorro,
                                    h.suc_aho,
                                    h.mda_aho,
                                    h.pap_aho,
                                    h.cta_aho,
                                    h.ope_aho,
                                    h.sub_aho,
                                    h.top_aho,
                                    h.mod_aho,
                                    h.saldo_aho,
                                    h.estado_aho,
                                    h.facultad_aho,
                                    P_USUARIO,
                                    h.DEPARTAMENTO,
                                    h.DISTRITOPROVINCIA,
                                    h.DIRECCION);


              end loop;
              COMMIT;
           end if;
    WHEN 2 THEN
        DELETE JAQY664
         WHERE JAQY664AUX3 = P_USUARIO;
        COMMIT;
    END CASE;
end llena_tabla;
------------------------------------------------------------------------------------------------------------------
PROCEDURE CTS_GARANTIA(P_SUCURSAL IN NUMBER,
                       P_DIAS     IN NUMBER,
                       P_ACCION   IN NUMBER,
                       P_USUARIO  IN VARCHAR2)IS
   cursor region  is
        select f10.regcod, f11.oficod
          from fst810 f10,
               fst811 f11
         where f10.regcod < 100
           and f11.pgcod = 1
           and f11.regcod = f10.regcod;

 CURSOR llenat(v_region in number,v_sucursal in number,v_fecha in date) is
   select distinct  j64.jaql964ren as Region_cre,
                    j64.jaql964nom as sucursal_cre,
                    jaql964usu as Analista_cre,
                    j64.jaql964tit as Titular_cre,
                    j64.jaql964doc as Numero_doc,
                    decode(J64.JAQL964MDA, 0, 'NUEVOS SOLES', 'DOLARES') as Mda_Credito,
                    cre.scsuc as CodSuc_cre,
                    cre.scmda as Mda_cre,
                    cre.scpap as papel_cre,
                    cre.sccta as Cuenta_Credito,
                    cre.scoper as Operacion_Cred,
                    cre.scsbop as Sub_Cred,
                    cre.sctope as Tip_Oper_Cred,
                    cre.scmod as Mod_Cred,
                    cre.scsdo as Saldo_Cred,
                    pq_cr_creditos.fn_cuotas_pagadas(cre.pgcod,
                                                     cre.scmod,
                                                     cre.scsuc,
                                                     cre.scmda,
                                                     cre.scpap,
                                                     cre.sccta,
                                                     cre.scoper,
                                                     cre.scsbop,
                                                     cre.sctope,
                                                     v_fecha) as Nro_Cuota_atrasada,--
                    (pq_cr_creditos.fn_monto_atrasado(cre.pgcod,
                                                      cre.scmod,
                                                      cre.scsuc,
                                                      cre.scmda,
                                                      cre.scpap,
                                                      cre.sccta,
                                                      cre.scoper,
                                                      cre.scsbop,
                                                      cre.sctope,
                                                      v_fecha) + (j64.jaql964gas + j64.jaql964mor))as Total_deuda,--v_fecha to_date('10/06/2016','dd/mm/yyyy')
                    j64.jaql964dia as dia_atraso,
                    (select r.pendoc
                       from fsr011 f,
                            fsd011 s,
                            fsr008 r
                      where f.relcod = 25
                        and f.r2cta = fsr.r2cta--777677 ---
                        and f.r2oper = fsr.r2oper --893619 --
                        and f.r1rub in (select rubro from fsr014 where rrcod=200 and rubro not like '84%')
                        and s.pgcod = f.r1cod
                        and s.scsuc = f.r1suc
                        and s.scmda = f.r1mda
                        and s.scpap = f.r1pap
                        and s.sccta = f.r1cta
                        and s.scsbop = f.r1sbop
                        and s.scmod = f.r1mod
                        and s.sctope = f.r1tope
                        and r.pgcod = s.pgcod
                        and r.ctnro = s.sccta
                        and r.cttfir = 'T') as DNI_AHORRO ,
                    (fn_tipo_TitularAvalConyuge(j64.jaql964doc,
                                                j64.jaql964tid,
                                                (select r.pendoc
                                                   from fsr011 f,
                                                        fsd011 s,
                                                        fsr008 r
                                                  where f.relcod = 25
                                                    and f.r2cta = fsr.r2cta--777677 ---
                                                    and f.r2oper = fsr.r2oper --893619 --
                                                    and f.r1rub in (select rubro from fsr014 where rrcod=200 and rubro not like '84%')
                                                    and s.pgcod = f.r1cod
                                                    and s.scsuc = f.r1suc
                                                    and s.scmda = f.r1mda
                                                    and s.scpap = f.r1pap
                                                    and s.sccta = f.r1cta
                                                    and s.scsbop = f.r1sbop
                                                    and s.scmod = f.r1mod
                                                    and s.sctope = f.r1tope
                                                    and r.pgcod = s.pgcod
                                                    and r.ctnro = s.sccta
                                                    and r.cttfir = 'T')))as Rel_Credito,
                    (select scnom
                      from fst001
                     where sucurs = (select r1suc
                                       from fsr011
                                      where relcod = 25
                                        and r2cta = fsr.r2cta--777677
                                        and r2oper = fsr.r2oper --893619
                                        and r1rub in (select rubro from fsr014 where rrcod=200 and rubro not like '84%'))) as Sucursal_Aho,
                   decode((select r1mda
                                       from fsr011
                                      where relcod = 25
                                        and r2cta = fsr.r2cta--777677
                                        and r2oper = fsr.r2oper --893619
                                        and r1rub in (select rubro from fsr014 where rrcod=200 and rubro not like '84%')),0, 'SOLES','DOLARES')as Moneda_Ahorro,
                   (select r1suc
                                       from fsr011
                                      where relcod = 25
                                        and r2cta = fsr.r2cta--777677
                                        and r2oper = fsr.r2oper --893619
                                        and r1rub in (select rubro from fsr014 where rrcod=200 and rubro not like '84%')) suc_aho,
                    (select r1mda
                                       from fsr011
                                      where relcod = 25
                                        and r2cta = fsr.r2cta--777677
                                        and r2oper = fsr.r2oper --893619
                                        and r1rub in (select rubro from fsr014 where rrcod=200 and rubro not like '84%')) as mda_aho,
                    0 as pap_aho,
                    (select r1cta
                                       from fsr011
                                      where relcod = 25
                                        and r2cta = fsr.r2cta--777677
                                        and r2oper = fsr.r2oper --893619
                                        and r1rub in (select rubro from fsr014 where rrcod=200 and rubro not like '84%')) as cta_aho,
                    0 as ope_aho,
                    (select r1sbop
                                       from fsr011
                                      where relcod = 25
                                        and r2cta = fsr.r2cta--777677
                                        and r2oper = fsr.r2oper --893619
                                        and r1rub in (select rubro from fsr014 where rrcod=200 and rubro not like '84%')) as sub_aho,
                    (select r1tope
                                       from fsr011
                                      where relcod = 25
                                        and r2cta = fsr.r2cta--777677
                                        and r2oper = fsr.r2oper --893619
                                        and r1rub in (select rubro from fsr014 where rrcod=200 and rubro not like '84%')) as top_aho,
                    21 as mod_aho,
                    (select s.scsdo
                       from fsr011 f,
                            fsd011 s
                      where f.relcod = 25
                        and f.r2cta = fsr.r2cta--777677 ---
                        and f.r2oper = fsr.r2oper --893619 --
                        and f.r1rub in (select rubro from fsr014 where rrcod=200 and rubro not like '84%')
                        and s.pgcod = f.r1cod
                        and s.scsuc = f.r1suc
                        and s.scmda = f.r1mda
                        and s.scpap = f.r1pap
                        and s.sccta = f.r1cta
                        and s.scsbop = f.r1sbop
                        and s.scmod = f.r1mod
                        and s.sctope = f.r1tope) as saldo_aho,
                    'AFECTADA EN GARANTIAS'estado_aho,
                   'INDIVIDUAL' as facultad_aho,
                  (select depnom from FST068 where depcod = (select s13.sngc13dpto
                                                               from fsr011 f,
                                                                    fsd011 s,
                                                                    fsr008 r,
                                                                    SNGC13 s13
                                                              where f.relcod = 25
                                                                and f.r2cta = fsr.r2cta--777677 ---
                                                                and f.r2oper = fsr.r2oper --893619 --
                                                                and f.r1rub in (select rubro from fsr014 where rrcod=200 and rubro not like '84%')
                                                                and s.pgcod = f.r1cod
                                                                and s.scsuc = f.r1suc
                                                                and s.scmda = f.r1mda
                                                                and s.scpap = f.r1pap
                                                                and s.sccta = f.r1cta
                                                                and s.scsbop = f.r1sbop
                                                                and s.scmod = f.r1mod
                                                                and s.sctope = f.r1tope
                                                                and r.pgcod = s.pgcod
                                                                and r.ctnro = s.sccta
                                                                and r.cttfir = 'T'
                                                                and s13.sngc13pais = r.pepais
                                                                and s13.sngc13tdoc = r.petdoc
                                                                and s13.sngc13ndoc = r.pendoc
                                                                and s13.sngc13est = 'H'
                                                                and s13.sngc13corr = 1
                                                                and s13.docod = 1)) as departamento,
                  (select trim(f71.fst071dsc)|| ' - '|| trim(f70.locnom)
                           from fsr011 f,
                                fsd011 s,
                                fsr008 r,
                                SNGC13 s13,
                                FST071 f71,
                                fst070 f70
                          where f.relcod = 25
                            and f.r2cta = fsr.r2cta--777677 ---
                            and f.r2oper = fsr.r2oper --893619 --
                            and f.r1rub in (select rubro from fsr014 where rrcod=200 and rubro not like '84%')
                            and s.pgcod = f.r1cod
                            and s.scsuc = f.r1suc
                            and s.scmda = f.r1mda
                            and s.scpap = f.r1pap
                            and s.sccta = f.r1cta
                            and s.scsbop = f.r1sbop
                            and s.scmod = f.r1mod
                            and s.sctope = f.r1tope
                            and r.pgcod = s.pgcod
                            and r.ctnro = s.sccta
                            and r.cttfir = 'T'
                            and s13.sngc13pais = r.pepais
                            and s13.sngc13tdoc = r.petdoc
                            and s13.sngc13ndoc = r.pendoc
                            and s13.sngc13est = 'H'
                            and s13.sngc13corr = 1
                            and s13.docod = 1
                            and f71.fst071pai = 604
                            and f71.fst071dpt = s13.sngc13dpto  --and fst071loc= s13.sngc13prov and fst071col = s13.sngc13dist
                            and f71.fst071loc = s13.sngc13prov
                            and f71.fst071col = s13.sngc13dist
                            and f70.depcod = s13.sngc13dpto
                            and f70.loccod = s13.sngc13prov )as DistritoProvincia,

                   (select s13.sngc13dir
                       from fsr011 f,
                            fsd011 s,
                            fsr008 r,
                            SNGC13 s13
                      where f.relcod = 25
                        and f.r2cta = fsr.r2cta--777677 ---
                        and f.r2oper = fsr.r2oper --893619 --
                        and f.r1rub in (select rubro from fsr014 where rrcod=200 and rubro not like '84%')
                        and s.pgcod = f.r1cod
                        and s.scsuc = f.r1suc
                        and s.scmda = f.r1mda
                        and s.scpap = f.r1pap
                        and s.sccta = f.r1cta
                        and s.scsbop = f.r1sbop
                        and s.scmod = f.r1mod
                        and s.sctope = f.r1tope
                        and r.pgcod = s.pgcod
                        and r.ctnro = s.sccta
                        and r.cttfir = 'T'
                        and s13.sngc13pais = r.pepais
                        and s13.sngc13tdoc = r.petdoc
                        and s13.sngc13ndoc = r.pendoc
                        and s13.sngc13est = 'H'
                        and s13.sngc13corr = 1
                        and s13.docod = 1) as direccion

from
       jaql964 j64,
       fsd011 cre,
       fsr011 fsr
 where j64.jaql964reg = v_region ---12 --region obtner
   and j64.jaql964suc = v_sucursal
   and j64.jaql964est = 0
   and j64.jaql964dia >= P_DIAS
   AND J64.JAQL964MOD <> 108 --PGCOD, SCMOD, SCMDA, SCPAP, SCCTA, SCSUC, SCOPER, SCSBOP, SCTOPE
   and cre.pgcod = 1
   and cre.scmod = j64.jaql964mod
   and cre.scmda = j64.jaql964mda
   and cre.scpap = 0
   and cre.sccta = j64.jaql964cta
   and cre.scsuc = j64.jaql964suc
   and cre.scoper = j64.jaql964ope
   and cre.scsbop = j64.jaql964sob
   and cre.sctope = j64.jaql964top
   and cre.scsdo <> 0
-- and cre.scrub in (select rubro
--                       from fsd014
--                      where pcimpu = 'S'
--                        and pcnivc in (select modulo
--                                         from fst111
--                                        where dscod = 50
--                                          and modulo not in (33, 120, 141, 144, 200))
--                     )
   and fsr.r1cod = 1
   and fsr.r1mod = cre.scmod
   and fsr.r1suc = cre.scsuc
   and fsr.r1mda = cre.scmda
   and fsr.r1pap = cre.scpap
   and fsr.r1cta = cre.sccta --j64.jaql964cta
   and fsr.r1oper = cre.scoper--j64.jaql964ope
   and fsr.r1sbop = cre.scsbop
   and fsr.r1tope = cre.sctope
   and fsr.relcod = 50
   and fsr.r2mod = 70
   and fsr.r2tope =  85;

CURSOR LLENAT_SUCURSAL (v_region in number,v_fecha in date) is
  select distinct  j64.jaql964ren as Region_cre,
                    j64.jaql964nom as sucursal_cre,
                    jaql964usu as Analista_cre,
                    j64.jaql964tit as Titular_cre,
                    j64.jaql964doc as Numero_doc,
                    decode(J64.JAQL964MDA, 0, 'NUEVOS SOLES', 'DOLARES') as Mda_Credito,
                    cre.scsuc as CodSuc_cre,
                    cre.scmda as Mda_cre,
                    cre.scpap as papel_cre,
                    cre.sccta as Cuenta_Credito,
                    cre.scoper as Operacion_Cred,
                    cre.scsbop as Sub_Cred,
                    cre.sctope as Tip_Oper_Cred,
                    cre.scmod as Mod_Cred,
                    cre.scsdo as Saldo_Cred,
                    pq_cr_creditos.fn_cuotas_pagadas(cre.pgcod,
                                                     cre.scmod,
                                                     cre.scsuc,
                                                     cre.scmda,
                                                     cre.scpap,
                                                     cre.sccta,
                                                     cre.scoper,
                                                     cre.scsbop,
                                                     cre.sctope,
                                                     v_fecha) as Nro_Cuota_atrasada,--
                    (pq_cr_creditos.fn_monto_atrasado(cre.pgcod,
                                                      cre.scmod,
                                                      cre.scsuc,
                                                      cre.scmda,
                                                      cre.scpap,
                                                      cre.sccta,
                                                      cre.scoper,
                                                      cre.scsbop,
                                                      cre.sctope,
                                                      v_fecha) + (j64.jaql964gas + j64.jaql964mor))as Total_deuda,--v_fecha to_date('10/06/2016','dd/mm/yyyy')
                    j64.jaql964dia as dia_atraso,
                    (select r.pendoc
                       from fsr011 f,
                            fsd011 s,
                            fsr008 r
                      where f.relcod = 25
                        and f.r2cta = fsr.r2cta--777677 ---
                        and f.r2oper = fsr.r2oper --893619 --
                        and f.r1rub in (select rubro from fsr014 where rrcod=200 and rubro not like '84%')
                        and s.pgcod = f.r1cod
                        and s.scsuc = f.r1suc
                        and s.scmda = f.r1mda
                        and s.scpap = f.r1pap
                        and s.sccta = f.r1cta
                        and s.scsbop = f.r1sbop
                        and s.scmod = f.r1mod
                        and s.sctope = f.r1tope
                        and r.pgcod = s.pgcod
                        and r.ctnro = s.sccta
                        and r.cttfir = 'T') as DNI_AHORRO ,
                    (fn_tipo_TitularAvalConyuge(j64.jaql964doc,
                                                j64.jaql964tid,
                                                (select r.pendoc
                                                   from fsr011 f,
                                                        fsd011 s,
                                                        fsr008 r
                                                  where f.relcod = 25
                                                    and f.r2cta = fsr.r2cta--777677 ---
                                                    and f.r2oper = fsr.r2oper --893619 --
                                                    and f.r1rub in (select rubro from fsr014 where rrcod=200 and rubro not like '84%')
                                                    and s.pgcod = f.r1cod
                                                    and s.scsuc = f.r1suc
                                                    and s.scmda = f.r1mda
                                                    and s.scpap = f.r1pap
                                                    and s.sccta = f.r1cta
                                                    and s.scsbop = f.r1sbop
                                                    and s.scmod = f.r1mod
                                                    and s.sctope = f.r1tope
                                                    and r.pgcod = s.pgcod
                                                    and r.ctnro = s.sccta
                                                    and r.cttfir = 'T')))as Rel_Credito,
                    (select scnom
                      from fst001
                     where sucurs = (select r1suc
                                       from fsr011
                                      where relcod = 25
                                        and r2cta = fsr.r2cta--777677
                                        and r2oper = fsr.r2oper --893619
                                        and r1rub in (select rubro from fsr014 where rrcod=200 and rubro not like '84%'))) as Sucursal_Aho,
                   decode((select r1mda
                                       from fsr011
                                      where relcod = 25
                                        and r2cta = fsr.r2cta--777677
                                        and r2oper = fsr.r2oper --893619
                                        and r1rub in (select rubro from fsr014 where rrcod=200 and rubro not like '84%')),0, 'SOLES','DOLARES')as Moneda_Ahorro,
                   (select r1suc
                                       from fsr011
                                      where relcod = 25
                                        and r2cta = fsr.r2cta--777677
                                        and r2oper = fsr.r2oper --893619
                                        and r1rub in (select rubro from fsr014 where rrcod=200 and rubro not like '84%')) suc_aho,
                    (select r1mda
                                       from fsr011
                                      where relcod = 25
                                        and r2cta = fsr.r2cta--777677
                                        and r2oper = fsr.r2oper --893619
                                        and r1rub in (select rubro from fsr014 where rrcod=200 and rubro not like '84%')) as mda_aho,
                    0 as pap_aho,
                    (select r1cta
                                       from fsr011
                                      where relcod = 25
                                        and r2cta = fsr.r2cta--777677
                                        and r2oper = fsr.r2oper --893619
                                        and r1rub in (select rubro from fsr014 where rrcod=200 and rubro not like '84%')) as cta_aho,
                    0 as ope_aho,
                    (select r1sbop
                                       from fsr011
                                      where relcod = 25
                                        and r2cta = fsr.r2cta--777677
                                        and r2oper = fsr.r2oper --893619
                                        and r1rub in (select rubro from fsr014 where rrcod=200 and rubro not like '84%')) as sub_aho,
                    (select r1tope
                                       from fsr011
                                      where relcod = 25
                                        and r2cta = fsr.r2cta--777677
                                        and r2oper = fsr.r2oper --893619
                                        and r1rub in (select rubro from fsr014 where rrcod=200 and rubro not like '84%')) as top_aho,
                    21 as mod_aho,
                    (select s.scsdo
                       from fsr011 f,
                            fsd011 s
                      where f.relcod = 25
                        and f.r2cta = fsr.r2cta--777677 ---
                        and f.r2oper = fsr.r2oper --893619 --
                        and f.r1rub in (select rubro from fsr014 where rrcod=200 and rubro not like '84%')
                        and s.pgcod = f.r1cod
                        and s.scsuc = f.r1suc
                        and s.scmda = f.r1mda
                        and s.scpap = f.r1pap
                        and s.sccta = f.r1cta
                        and s.scsbop = f.r1sbop
                        and s.scmod = f.r1mod
                        and s.sctope = f.r1tope) as saldo_aho,
                    'AFECTADA EN GARANTIAS'estado_aho,
                   'INDIVIDUAL' as facultad_aho,
                  (select depnom from FST068 where depcod = (select s13.sngc13dpto
                                                               from fsr011 f,
                                                                    fsd011 s,
                                                                    fsr008 r,
                                                                    SNGC13 s13
                                                              where f.relcod = 25
                                                                and f.r2cta = fsr.r2cta--777677 ---
                                                                and f.r2oper = fsr.r2oper --893619 --
                                                                and f.r1rub in (select rubro from fsr014 where rrcod=200 and rubro not like '84%')
                                                                and s.pgcod = f.r1cod
                                                                and s.scsuc = f.r1suc
                                                                and s.scmda = f.r1mda
                                                                and s.scpap = f.r1pap
                                                                and s.sccta = f.r1cta
                                                                and s.scsbop = f.r1sbop
                                                                and s.scmod = f.r1mod
                                                                and s.sctope = f.r1tope
                                                                and r.pgcod = s.pgcod
                                                                and r.ctnro = s.sccta
                                                                and r.cttfir = 'T'
                                                                and s13.sngc13pais = r.pepais
                                                                and s13.sngc13tdoc = r.petdoc
                                                                and s13.sngc13ndoc = r.pendoc
                                                                and s13.sngc13est = 'H'
                                                                and s13.sngc13corr = 1
                                                                and s13.docod = 1)) as departamento,
                  (select trim(f71.fst071dsc)|| ' - '|| trim(f70.locnom)
                           from fsr011 f,
                                fsd011 s,
                                fsr008 r,
                                SNGC13 s13,
                                FST071 f71,
                                fst070 f70
                          where f.relcod = 25
                            and f.r2cta = fsr.r2cta--777677 ---
                            and f.r2oper = fsr.r2oper --893619 --
                            and f.r1rub in (select rubro from fsr014 where rrcod=200 and rubro not like '84%')
                            and s.pgcod = f.r1cod
                            and s.scsuc = f.r1suc
                            and s.scmda = f.r1mda
                            and s.scpap = f.r1pap
                            and s.sccta = f.r1cta
                            and s.scsbop = f.r1sbop
                            and s.scmod = f.r1mod
                            and s.sctope = f.r1tope
                            and r.pgcod = s.pgcod
                            and r.ctnro = s.sccta
                            and r.cttfir = 'T'
                            and s13.sngc13pais = r.pepais
                            and s13.sngc13tdoc = r.petdoc
                            and s13.sngc13ndoc = r.pendoc
                            and s13.sngc13est = 'H'
                            and s13.sngc13corr = 1
                            and s13.docod = 1
                            and f71.fst071pai = 604
                            and f71.fst071dpt = s13.sngc13dpto  --and fst071loc= s13.sngc13prov and fst071col = s13.sngc13dist
                            and f71.fst071loc = s13.sngc13prov
                            and f71.fst071col = s13.sngc13dist
                            and f70.depcod = s13.sngc13dpto
                            and f70.loccod = s13.sngc13prov )as DistritoProvincia,

                   (select s13.sngc13dir
                       from fsr011 f,
                            fsd011 s,
                            fsr008 r,
                            SNGC13 s13
                      where f.relcod = 25
                        and f.r2cta = fsr.r2cta--777677 ---
                        and f.r2oper = fsr.r2oper --893619 --
                        and f.r1rub in (select rubro from fsr014 where rrcod=200 and rubro not like '84%')
                        and s.pgcod = f.r1cod
                        and s.scsuc = f.r1suc
                        and s.scmda = f.r1mda
                        and s.scpap = f.r1pap
                        and s.sccta = f.r1cta
                        and s.scsbop = f.r1sbop
                        and s.scmod = f.r1mod
                        and s.sctope = f.r1tope
                        and r.pgcod = s.pgcod
                        and r.ctnro = s.sccta
                        and r.cttfir = 'T'
                        and s13.sngc13pais = r.pepais
                        and s13.sngc13tdoc = r.petdoc
                        and s13.sngc13ndoc = r.pendoc
                        and s13.sngc13est = 'H'
                        and s13.sngc13corr = 1
                        and s13.docod = 1) as direccion

from
       jaql964 j64,
       fsd011 cre,
       fsr011 fsr
 where j64.jaql964reg = v_region ---12 --region obtner
   and j64.jaql964suc = P_SUCURSAL
   and j64.jaql964est in (select distinct jaql964est from jaql964 )
   and j64.jaql964dia >= P_DIAS
   AND J64.JAQL964MOD <> 108 --PGCOD, SCMOD, SCMDA, SCPAP, SCCTA, SCSUC, SCOPER, SCSBOP, SCTOPE
   and cre.pgcod = 1
   and cre.scmod = j64.jaql964mod
   and cre.scmda = j64.jaql964mda
   and cre.scpap = 0
   and cre.sccta = j64.jaql964cta
   and cre.scsuc = j64.jaql964suc
   and cre.scoper = j64.jaql964ope
   and cre.scsbop = j64.jaql964sob
   and cre.sctope = j64.jaql964top
   and cre.scsdo <> 0
  /* and cre.scrub in (select rubro
                       from fsd014
                      where pcimpu = 'S'
                        and pcnivc in (select modulo
                                         from fst111
                                        where dscod = 50
                                          and modulo not in (33, 120, 141, 144, 200))
                     ) */
   and fsr.r1cod = 1
   and fsr.r1mod = cre.scmod
   and fsr.r1suc = cre.scsuc
   and fsr.r1mda = cre.scmda
   and fsr.r1pap = cre.scpap
   and fsr.r1cta = cre.sccta --j64.jaql964cta
   and fsr.r1oper = cre.scoper--j64.jaql964ope
   and fsr.r1sbop = cre.scsbop
   and fsr.r1tope = cre.sctope
   and fsr.relcod = 50
   and fsr.r2mod = 70
   and fsr.r2tope =  85;
  fecha date;
  V_nrocuota number;
  vregcod number;
begin

    select pgfape
      into fecha
      from fst017
     where pgcod = 1;

    CASE P_ACCION
    WHEN 1 THEN
          DELETE JAQY664
           WHERE JAQY664AUX3 = P_USUARIO;---RPAD(P_USUARIO,10,' ');
          commit;
          if P_SUCURSAL = 0 then
            For reg in region loop
              for I in llenat(reg.regcod, reg.oficod,fecha) loop
                bEGIN
                  V_nrocuota := I.Nro_Cuota_atrasada + 1;
                  insert into jaqy664 (JAQY664REG,
                                      JAQY664SUC,
                                      JAQY664ANA,
                                      JAQY664TIT,
                                      JAQY664NROD,
                                      JAQY664MDAC,
                                      JAQY664SUCC,
                                      JAQY664CMDA,
                                      JAQY664PAPC,
                                      JAQY664CTAC,
                                      JAQY664OPEC,
                                      JAQY664SUBOC,
                                      JAQY664TOPEC,
                                      JAQY664MODC,
                                      JAQY664SALC,
                                      JAQY664NCA,
                                      JAQY664TOTD,
                                      JAQY664DIAM,
                                      JAQY664DNIA,
                                      JAQY664RELA,
                                      JAQY664SUCAL,
                                      JAQY664MDAL,
                                      JAQY664SUCA,
                                      JAQY664MDAA,
                                      JAQY664PAPA,
                                      JAQY664CTAA,
                                      JAQY664OPEA,
                                      JAQY664SUBOA,
                                      JAQY664TOPEA,
                                      JAQY664MODA,
                                      JAQY664SALA,
                                      JAQY664EST,
                                      JAQY664TIPO,
                                      JAQY664AUX3,
                                      JAQY664AUX5,
                                      JAQY664AUX6,
                                      JAQY664AUX7)
                            values (I.Region_cre,
                                    I.sucursal_cre,
                                    I.Analista_cre,
                                    I.Titular_cre,
                                    I.Numero_doc,
                                    I.Mda_Credito,
                                    I.CodSuc_cre,
                                    I.Mda_cre,
                                    I.papel_cre,
                                    I.Cuenta_Credito,
                                    I.Operacion_Cred,
                                    I.Sub_Cred,
                                    I.Tip_Oper_Cred,
                                    I.Mod_Cred,
                                    I.Saldo_Cred,
                                    V_nrocuota, ---I.Nro_Cuota_atrasada,
                                    I.Total_deuda,
                                    I.dia_atraso,
                                    I.DNI_AHORRO ,
                                    I.Rel_Credito,
                                    I.Sucursal_Aho,
                                    I.Moneda_Ahorro,
                                    I.suc_aho,
                                    I.mda_aho,
                                    I.pap_aho,
                                    I.cta_aho,
                                    I.ope_aho,
                                    I.sub_aho,
                                    I.top_aho,
                                    I.mod_aho,
                                    I.saldo_aho,
                                    I.estado_aho,
                                    I.facultad_aho,
                                    P_USUARIO,
                                    I.DEPARTAMENTO,
                                    I.DISTRITOPROVINCIA,
                                    I.DIRECCION);
                 EXCEPTION
                   WHEN DUP_VAL_ON_INDEX THEN
                     NULL;
                END;

              end loop;
              COMMIT;
            end loop;
          else
              select f10.regcod
                into vregcod
                from fst810 f10,
                     fst811 f11
               where f10.regcod < 100
                 and f11.pgcod = 1
                 and f11.regcod = f10.regcod
                 and f11.oficod = P_SUCURSAL;

              for h in LLENAT_SUCURSAL(vregcod,fecha) loop
                  V_nrocuota := h.Nro_Cuota_atrasada + 1;
                  insert into jaqy664 (JAQY664REG,
                                      JAQY664SUC,
                                      JAQY664ANA,
                                      JAQY664TIT,
                                      JAQY664NROD,
                                      JAQY664MDAC,
                                      JAQY664SUCC,
                                      JAQY664CMDA,
                                      JAQY664PAPC,
                                      JAQY664CTAC,
                                      JAQY664OPEC,
                                      JAQY664SUBOC,
                                      JAQY664TOPEC,
                                      JAQY664MODC,
                                      JAQY664SALC,
                                      JAQY664NCA,
                                      JAQY664TOTD,
                                      JAQY664DIAM,
                                      JAQY664DNIA,
                                      JAQY664RELA,
                                      JAQY664SUCAL,
                                      JAQY664MDAL,
                                      JAQY664SUCA,
                                      JAQY664MDAA,
                                      JAQY664PAPA,
                                      JAQY664CTAA,
                                      JAQY664OPEA,
                                      JAQY664SUBOA,
                                      JAQY664TOPEA,
                                      JAQY664MODA,
                                      JAQY664SALA,
                                      JAQY664EST,
                                      JAQY664TIPO,
                                      JAQY664AUX3,
                                      JAQY664AUX5,
                                      JAQY664AUX6,
                                      JAQY664AUX7)
                            values (h.Region_cre,
                                    h.sucursal_cre,
                                    h.Analista_cre,
                                    h.Titular_cre,
                                    h.Numero_doc,
                                    h.Mda_Credito,
                                    h.CodSuc_cre,
                                    h.Mda_cre,
                                    h.papel_cre,
                                    h.Cuenta_Credito,
                                    h.Operacion_Cred,
                                    h.Sub_Cred,
                                    h.Tip_Oper_Cred,
                                    h.Mod_Cred,
                                    h.Saldo_Cred,
                                    V_nrocuota,---h.Nro_Cuota_atrasada,
                                    h.Total_deuda,
                                    h.dia_atraso,
                                    h.DNI_AHORRO ,
                                    h.Rel_Credito,
                                    h.Sucursal_Aho,
                                    h.Moneda_Ahorro,
                                    h.suc_aho,
                                    h.mda_aho,
                                    h.pap_aho,
                                    h.cta_aho,
                                    h.ope_aho,
                                    h.sub_aho,
                                    h.top_aho,
                                    h.mod_aho,
                                    h.saldo_aho,
                                    h.estado_aho,
                                    h.facultad_aho,
                                    P_USUARIO,
                                    h.DEPARTAMENTO,
                                    h.DISTRITOPROVINCIA,
                                    h.DIRECCION);


              end loop;
              COMMIT;
           end if;
    WHEN 2 THEN
        /*DELETE JAQY664
         WHERE JAQY664AUX3 = P_USUARIO;
        COMMIT;*/
        null;
    END CASE;
end CTS_GARANTIA;

------------------------------------------------------------------------------------------------------------------
Function fn_moneda (v_moneda in number) return varchar2 is
resultado varchar2(15);
Begin
 if v_moneda = 0 then
    resultado := 'NUEVOS SOLES';
 else
    RESULTADO := 'DOLARES';
 end if ;
 Return Resultado;
end fn_moneda;



function fn_tipo_TitularAvalConyuge (dnicre in char,
                                     tipdoc in number,
                                     dniaho in char)return varchar2 is
respuesta varchar2(12);
v_conyuge varchar2(12);

begin
  if dnicre = dniaho then
     respuesta := 'TITULAR';

  else
      begin
        select rpndoc
          into v_conyuge
          from fsr002
         where rpccyg = 66
           and pepais = 604
           and petdoc = tipdoc
           and pendoc = dnicre;
      exception
      when No_data_found then
           begin
               select pendoc
                  into v_conyuge
                 from fsr002
                where rpccyg = 66
                  and rppais = 604
                  and rpndoc = dnicre;
            exception
            when no_data_found then
               v_conyuge := 'No es';
            end;
      end;
      if dniaho = v_conyuge then
         respuesta := 'CONYUGE';
      else
         respuesta := 'AVAL';
      end if;
  end if;
  return respuesta;
end fn_tipo_TitularAvalConyuge ;


END PQ_AH_NDIASVCTO;
/

