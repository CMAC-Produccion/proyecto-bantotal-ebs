create or replace package PQ_CR_QAUTOSEGUROS IS
 -------------------------------------------------------------------------------------------------------------------
  -- Author  : SMARQUEZ
  -- Created : 31/10/2017 10:15:27
  -- Purpose : Automatizacion de Query de Transferencia de Seguros Vida Caja y Familia Segura
  -- de Bantotal a SigRetail
  -- Public type declarations
  -- Autor       : Silvia Marquez
  -- Fecha Modif.: 26/01/2021
  -- Modificacion: Adicion de Afiliaciones que no se estan reportando a Sigretail
  -- Autor       : Silvia Marquez
  -- Fecha Modif.: 01/02/2021
  -- Modificacion: Adicion filtro para que no duplique los registros
  -- Autor       : Silvia Marquez
  -- Fecha Modif.: 28/09/2023
  -- Modificacion: Adicion de Columna para identificar tipo desembolso
  -- Autor       : Silvia Marquez
  -- Fecha Modif.: 07/12/2023
  -- Modificacion: Error en asignacion de variable para biometria
  --------------------------------------------------------------------------------------------------------------------
   -- Public function and procedure declarations
   PROCEDURE SP_INICIO (P_FECHA IN DATE,
                        P_USUARIO IN VARCHAR2,
                        P_MSG OUT VARCHAR2);
  --------------------------------------------------------------------------------------------------------------------
   PROCEDURE SP_CR_SEGUROSVC_ANT (P_FECHA IN DATE,
                                  P_USUARIO IN VARCHAR2);

  --------------------------------------------------------------------------------------------------------------------
   PROCEDURE SP_TRANSFERIR(P_FECHA IN DATE,P_DATO OUT NUMBER);

end PQ_CR_QAUTOSEGUROS;
/

create or replace package body PQ_CR_QAUTOSEGUROS is
-------------------------------------------------------------------------------------------------------------------
  -- Author  : SMARQUEZ
  -- Created : 31/10/2017 10:15:27
  -- Purpose : Automatizacion de Query de Transferencia de Seguros Vida Caja y Familia Segura
  -- de Bantotal a SigRetail
  -- Public type declarations
  -- Autor       : Silvia Marquez
  -- Fecha Modif.: 26/01/2021
  -- Modificacion: Adicion de Afiliaciones que no se estan reportando a Sigretail
  -- Autor       : Silvia Marquez
  -- Fecha Modif.: 01/02/2021
  -- Modificacion: Adicion filtro para que no duplique los registros
  -- Autor       : Silvia Marquez
  -- Fecha Modif.: 28/09/2023
  -- Modificacion: Adicion de Columna para identificar tipo desembolso
  -- Autor       : Silvia Marquez
  -- Fecha Modif.: 07/12/2023
  -- Modificacion: Error en asignacion de variable para biometria
  -- Autor       : Silvia Marquez
  -- Fecha Modif.: 24/01/2024
  -- Modificacion: Adicion de fecha en el log para registrar el error correcto
  -- Modificacion: 20240524 SMARQUEZ validacion de tipo de desembolso
  --------------------------------------------------------------------------------------------------------------------
 PROCEDURE SP_INICIO (P_FECHA IN DATE,
                      P_USUARIO IN VARCHAR2,
                      P_MSG OUT VARCHAR2) IS
  cursor resumen is
    select jaqz556tipo tipo , count(*) total
     from jaqz556 group by jaqz556tipo;

  FECHA DATE;
  USUARIO VARCHAR2(12);
  secuencia number;

  begin
    FECHA := P_FECHA;
    USUARIO := P_USUARIO;
     ------------PRUEBA------------------------------
--    delete JAQZ556;  --TABLA TEMPORAL
    Execute immediate ('truncate table jaqz556');
--    delete JAQZ557;  -- TABLA RESUMEN
    Execute immediate ('truncate table jaqz557');
    COMMIT;
    SP_CR_SEGUROSVC_ANT (FECHA, USUARIO);
    For a in resumen loop
      case a.tipo
        when 1 then update jaqz557
                       set total = a.total
                    where descripcion ='1- CANCELADOS PLAN_III';
        when 2 then update jaqz557
                       set total = a.total
                    where descripcion ='2- CANCELADOS PLAN_III + VC PLAN 1,2,3';

        when 3 then update jaqz557
                       set total = a.total
                    where descripcion ='3- CANCELADOS PLAN_III + VC PLAN 1,2,3 + FAMILIA SEGURA';
        when 4 then update jaqz557
                       set total = a.total
                    where descripcion ='4- NUEVOS VC PLAN 1,2,3';
        when 5 then update jaqz557
                       set total = a.total
                    where descripcion ='5- NUEVOS VC PLAN 1,2,3  + FAMILIA SEGURA';
        when 6 then update jaqz557
                       set total = a.total
                    where descripcion ='6- AFILIACIONES DESPUES DE DESEMBOLSO VC PLAN 1,2,3';
        when 7 then update jaqz557
                       set total = a.total
                    where descripcion ='7- AFILIACIONES DESPUES DE DESEMBOLSO VC PLAN 1,2,3 + FAMILIA SEGURA';
        when 8 then update jaqz557
                       set total = a.total
                    where descripcion ='8- CREDITOS CANCELADOS PLAN_III, VC PLAN 1,2,3 Y ABM';

        end case;
        commit;
    end loop;
  END SP_INICIO;

  PROCEDURE SP_CR_SEGUROSVC_ANT (P_FECHA IN DATE,
                                P_USUARIO IN VARCHAR2) IS
  Cursor resagados(fecha in date)  is
    select C.SGCOD SEGURO, c.pp001imp prima , b.AOCTA cuenta, b.aooper operacion,
           a.pepais pais, a.petdoc  tdoc,a.PENDOC doc,
           b.pgcod emp,b.aomod modu, b.aosuc suc, b.aomda mda, b.aopap pap, b.aosbop sub, b.aotope tope,
           b.aofval fval, b.aostat stado, b.aoimp importe
      from fsr008 a,
           fsd010 b,
           fpp001 c
     where b.pgcod = 1
       and b.aomod in (select modulo from fst111 where dscod = 50)
       and b.aofval = fecha --'01/01/2021'
       and c.pgcod = b.pgcod
       and c.aomod = b.aomod
       and c.aosuc = b.aosuc
       and c.aomda = b.aomda
       and c.aopap = b.aopap
       and c.aocta = b.aocta
       and c.aooper = b.aooper
       and c.aosbop = b.aosbop
       and c.aotope = b.aotope
       and c.sgcod in (select tp1nro3
                           from fst198
                          where tp1cod = 1
                            and tp1cod1 = 10898 --for update
                            and tp1corr1 = 18
                            and tp1corr3=1
                            and tp1nro1 =1)
      and a.CTNRO = c.aocta
      and a.cttfir = 'T'
      and not exists ( select 1
                        from jaqz556
                       where idc = rpad(a.pendoc,11,' ')
                         and estado = 'N'
                         and nro_credito = SUBSTR(LPAD(b.aocta, 9, '0') || LPAD(b.aomod, 3, '0') || LPAD(b.aomda, 3, '0') || LPAD(b.aooper, 9, '0') || LPAD(b.aotOPE, 3, '0'), 1, 30) );
  cursor Actualiza is
  select * from jaqz556 where estado = 'N';

  err_code varchar2(500);
  err_msg varchar2(500);
  fecha date;
  secuencia number;
  contador number:=0;

   cuenta number;
   modulo number;
   moneda number;
   operacion number;
   tipoope number;
   tipodes char(20);
   fecha1 date;

  BEGIN
    fecha := P_FECHA;
   -- execute immediate ALTER SESSION SET NLS_LANGUAGE=ENGLISH;
   -- ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE;

  --(1A): Creditos con SEGURO VIDA CAJA pagos de cuotas o cancelados
   BEGIN
   insert /* +APPEND */ into JAQZ556(jaqz556cod,
                        item,
                        plan_seguro,
                        patcliente,
                        matcliente,
                        nombrecliente,
                        idc,
                        tip_idc,
                        email,
                        estadocivil,
                        sexo,
                        fecha_nac,
                        telefono,
                        ocupacion,
                        ubigeo_cliente,
                        direccion,
                        producto,
                        codigo_sucursal,
                        funcionario,
                        estado,
                        nro_credito,
                        moneda_cuenta,
                        fecha_cancelacion,
                        fecha_desembolso,
                        flag,
                        jaqz556tipo,
                        cred_falt,
                        importe_credito,
                        prima_mensual,
                        hora_desembolso,
                        fecha_afiliacion,
                        fecha_desafiliacion,
                        agencia_desafiliacion,
                        JAQZ556AU5,
                        JAQZ556AU8,
                        Jaqz556au1
                         )with DATA as
    (select  /*+PARALLEL(A,4,1)(S,4,1)(T,4,1)(F,4,1)(P,4,1)(D,4,1)*/
      DISTINCT '1' ITEM,
      3 PLAN_SEGURO,
      NVL(SUBSTR(P.PFAPE1, 1, 30),'-') PATCLIENTE,                   --APEPAT
      NVL(SUBSTR(P.PFAPE2, 1, 30),'-') MATCLIENTE,                   --APEMAT
      SUBSTR(trim(P.PFNOM1) || ' ' || trim(P.PFNOM2), 1, 30) NOMBRECLIENTE, --NOM1
      SUBSTR(F.PENDOC, 1, 11) IDC,                          --NUMDOC
      SUBSTR(F.PETDOC, 1, 3) TIP_IDC,                       --TIPO
      SUBSTR(FN_MAIL(F.CTNRO), 1, 50) EMAIL,                --MAIL
      SUBSTR((SELECT ECNOM FROM FST009 WHERE ECCOD = P.PFECIV), 1, 20) ESTADOCIVIL,       --ESTADOCIVIL
      SUBSTR(P.PFCANT, 1, 1) SEXO,                          --SEXO
      TO_CHAR(P.PFFNAC, 'DD/MM/YYYY') FECHA_NAC,            --FECNAC
      SUBSTR(FN_TELCLIE(TRIM(F.PENDOC)), 1, 50) TELEFONO,   --FONO
      (select SUBSTR(TRIM(sngc07dsc),1,50)
        from SNGC60 f1,
             sngc07 f7
       where f1.SNGC60Pais = P.PFPAIS
         and f1.SNGC60Tdoc = P.PFTDOC
         and f1.SNGC60Ndoc = P.PFNDOC
         and f1.sngc60corr = (select max(sngc60corr)from SNGC60  where SNGC60Pais = P.PFPAIS  and SNGC60Tdoc = P.PFTDOC and SNGC60Ndoc = P.PFNDOC )
         and f7.sngc07cod = f1.sngc60ocup) OCUPACION, --OCUPACION
      NVL(SUBSTR(D.SNGC13UGEO, 1, 8),'-') UBIGEO_CLIENTE,            --UBIGEO
      NVL(SUBSTR(D.SNGC13DIR, 1, 100),'-') DIRECCION,                --DIRECCION
      '0004' PRODUCTO,
      SUBSTR(A.AOSUC, 1, 3) CODIGO_SUCURSAL,                --AGENCIACOD
      FN_ANALISTA_CREDITO(A.AOMOD, A.AOSUC, A.AOMDA, A.AOPAP, A.AOCTA, A.AOOPER, A.AOSBOP, A.AOTOPE) FUNCIONARIO,
      SUBSTR((SELECT T.CENOM FROM FST026 T WHERE T.CECOD = A.AOSTAT), 1, 1) ESTADO,
      SUBSTR(LPAD(A.AOCTA, 9, '0') || LPAD(A.AOMOD, 3, '0') || LPAD(A.AOMDA, 3, '0') || LPAD(A.AOOPER, 9, '0') ||
             LPAD(A.AOTOPE, 3, '0'), 1, 30) NRO_CREDITO,    --NRO_CTA
      DECODE(A.AOMDA, '0', '001', '002') MONEDA_CUENTA,     --MONEDA
      NVL(TO_CHAR(A.AOFE99, 'DD/MM/YYYY'),'-') FECHA_CANCELACION,
      TO_CHAR(A.AOFVAL, 'DD/MM/YYYY') FECHA_DESEMBOLSO,     --FECHA_DESEMBOLSO_CRED
      0 FLAG,
      1 jaqz556tipo,
      Case
       when A.AOFVAL > (select nvl(Max(jaqy782fchdes),a.AOFVAL) from jaqy782 where jaqy782pgc = a.PGCOD and jaqy782mod = a.AOMOD and jaqy782suc = a.AOSUC and  jaqy782mda = a.AOMDA and jaqy782pap= a.AOPAP
          and jaqy782cta = a.AOCTA and jaqy782ope= a.AOOPER and jaqy782sbo = a.AOSBOP and jaqy782top = a.AOTOPE and jaqy782sgc = s.sgcod  and jaqy782est ='A') then 1
       when A.AOFVAL < (select nvl(Max(jaqy782fchdes),a.AOFVAL) from jaqy782 where jaqy782pgc = a.PGCOD and jaqy782mod = a.AOMOD and jaqy782suc = a.AOSUC and  jaqy782mda = a.AOMDA and jaqy782pap= a.AOPAP
          and jaqy782cta = a.AOCTA and jaqy782ope= a.AOOPER and jaqy782sbo = a.AOSBOP and jaqy782top = a.AOTOPE and jaqy782sgc = s.sgcod  and jaqy782est ='A') then 1
       when A.AOFVAL = (select nvl(Max(jaqy782fchdes),a.AOFVAL) from jaqy782 where jaqy782pgc = a.PGCOD and jaqy782mod = a.AOMOD and jaqy782suc = a.AOSUC and  jaqy782mda = a.AOMDA and jaqy782pap= a.AOPAP
          and jaqy782cta = a.AOCTA and jaqy782ope= a.AOOPER and jaqy782sbo = a.AOSBOP and jaqy782top = a.AOTOPE and jaqy782sgc = s.sgcod  and jaqy782est ='A') then 0
       end cred_falt,
      replace(to_char(A.AOIMP),',','.') importe_credito,
      replace(to_char(s.pp001imp),',','.') prima_mensual,
      (select substr(h1.hhora,1,6) from fsh015 h1,fsh016 h2 where h1.pgcod = h2.pgcod
          and h1.hcmod = h2.hcmod and h1.hsucor = h2.hsucor and h1.htran = h2.htran and h1.hnrel = h2.hnrel
          and h1.hfcon= P_FECHA and h2.hcmod =30 and h2.htran =951 and h2.hcord =10and h2.hmodul = a.AOMOD
          and h2.hsucor = a.AOSUC and h2.hmda = a.AOMDA and h2.hpap = 0 and h2.hcta = a.AOCTA and h2.hoper = a.AOOPER
          and h2.hsubop = a.AOSBOP and h2.htoper = a.AOTOPE) hora_desembolso,
      (select nvl(TO_CHAR(Max(jaqy782fchdes),'DD/MM/YYYY'),TO_CHAR(a.AOFVAL,'DD/MM/YYYY')) from jaqy782 where jaqy782pgc = a.PGCOD and jaqy782mod = a.AOMOD and jaqy782suc = a.AOSUC and  jaqy782mda = a.AOMDA and jaqy782pap= a.AOPAP
          and jaqy782cta = a.AOCTA and jaqy782ope= a.AOOPER and jaqy782sbo = a.AOSBOP and jaqy782top = a.AOTOPE and jaqy782sgc = s.sgcod  and jaqy782est ='A') fecha_afiliacion,
      (select decode(Max(jaqy782fchdes),null,'-') from jaqy782 where jaqy782pgc = a.PGCOD and jaqy782mod = a.AOMOD and jaqy782suc = a.AOSUC and  jaqy782mda = a.AOMDA and jaqy782pap= a.AOPAP
          and jaqy782cta = a.AOCTA and jaqy782ope= a.AOOPER and jaqy782sbo = a.AOSBOP and jaqy782top = a.AOTOPE and jaqy782sgc = s.sgcod  and jaqy782est ='D') fecha_desafiliacion,
       0 agencia_desafiliacion,
       P_USUARIO JAQZ556AU5,
       (select pgfape from fst017 where pgcod= 1) JAQZ556AU8,
       s.sgcod jaqz556au1
      FROM FSD010 A,   --SALDOS
           FPP001 S,   --SEGUROS
           XWF700 T,   --INSTANCIA
           FSR008 F,   --CUENTA DOCUMENTO
           FSD002 P,   --PERS ESTADO CIVIL
           SNGC13 D    --DIRECCION
     WHERE A.PGCOD = 1
       AND A.AOFE99 = P_FECHA--'19/06/2017'--TO_DATE('&DDMMRRRR', 'DDMMYYYY')
       AND A.AOSTAT = 99
       AND S.PGCOD = A.PGCOD
       AND S.AOMOD = A.AOMOD
       AND S.AOSUC = A.AOSUC
       AND S.AOMDA = A.AOMDA
       AND S.AOPAP = A.AOPAP
       AND S.AOCTA = A.AOCTA
       AND S.AOOPER = A.AOOPER
       AND S.AOSBOP = A.AOSBOP
       AND S.AOTOPE = A.AOTOPE
       AND S.SGCOD in (select tp1nro3
                         from fst198
                        where tp1cod = 1
                          and tp1cod1 = 10898
                          and tp1corr1 = 18
                          and tp1corr3=1
                          and tp1nro1 =2)--(116, 117, 118)
       and S.pp001imp > 0
       AND T.XWFEMPRESA = S.PGCOD
       AND T.XWFSUCURSAL = S.AOSUC
       AND T.XWFMODULO = S.AOMOD
       AND T.XWFMONEDA = S.AOMDA
       AND T.XWFPAPEL = S.AOPAP
       AND T.XWFCUENTA = S.AOCTA
       AND T.XWFOPERACION = S.AOOPER
       AND T.XWFSUBOPE = S.AOSBOP
       AND T.XWFTIPOPE = S.AOTOPE
       AND T.XWFCAR3 = '1'
       AND F.CTNRO = T.XWFCUENTA
       AND F.CTTFIR = 'T'
       AND P.PFPAIS = F.PEPAIS
       AND P.PFNDOC = F.PENDOC
       AND P.PFTDOC = F.PETDOC
       AND D.SNGC13PAIS = F.PEPAIS
       AND D.SNGC13TDOC = F.PETDOC
       AND D.SNGC13NDOC = F.PENDOC
       AND D.DOCOD = 1
       AND D.SNGC13EST = 'H'
       AND EXISTS(SELECT 1
                    FROM FSD611
                   WHERE PGCOD = T.XWFEMPRESA
                     AND PPMOD = T.XWFMODULO
                     AND PPSUC = T.XWFSUCURSAL
                     AND PPMDA = T.XWFMONEDA
                     AND pppap = T.XWFPAPEL
                     AND PPCTA = T.XWFCUENTA
                     AND PPOPER = T.XWFOPERACION
                     AND PPSBOP = T.XWFSUBOPE
                     AND PPTOPE = T.XWFTIPOPE ))
             select seq_jaqz556.nextval,
                    item,
                    plan_seguro,
                    patcliente,
                    matcliente,
                    nombrecliente,
                    idc,
                    tip_idc,
                    email,
                    estadocivil,
                    sexo,
                    fecha_nac,
                    telefono,
                    ocupacion,
                    ubigeo_cliente,
                    direccion,
                    producto,
                    codigo_sucursal,
                    funcionario,
                    estado,
                    nro_credito,
                    moneda_cuenta,
                    fecha_cancelacion,
                    fecha_desembolso,
                    flag,
                    jaqz556tipo,
                    cred_falt,
                    importe_credito,
                    prima_mensual,
                    hora_desembolso,
                    fecha_afiliacion,
                    fecha_desafiliacion,
                    agencia_desafiliacion,
                    JAQZ556AU5,
                    JAQZ556AU8,
                    jaqz556au1 from DATA;
   COMMIT;
      insert into JAQZ557 (descripcion,total) values ('1- CANCELADOS PLAN_III', (select count(*) from JAQZ556 where jaqz556tipo= 1));
   commit;
   EXCEPTION
    WHEN OTHERS THEN
      err_code := SQLCODE;
      err_msg := SUBSTR(SQLERRM, 1, 200)||' '||'JAQZ556TIPO'||' '|| '1';


      INSERT INTO JAQZ557LOG (jaqz557ecod  , jaqz557emsg,jaqz557fecha   )
      VALUES (err_code, err_msg, fecha);
      commit;
   END;
   ---******************************************* 1ra parte PLAN IV **********************---
   --(1B): Creditos con seguro vida caja pagos de cuotas o cancelados
   BEGIN
    insert  /* +APPEND */into JAQZ556(jaqz556cod,
                        item,
                        plan_seguro,
                        patcliente,
                        matcliente,
                        nombrecliente,
                        idc,
                        tip_idc,
                        email,
                        estadocivil,
                        sexo,
                        fecha_nac,
                        telefono,
                        ocupacion,
                        ubigeo_cliente,
                        direccion,
                        producto,
                        codigo_sucursal,
                        funcionario,
                        estado,
                        nro_credito,
                        moneda_cuenta,
                        fecha_cancelacion,
                        fecha_desembolso,
                        flag,
                        jaqz556tipo,
                        cred_falt,
                        importe_credito,
                        prima_mensual,
                        hora_desembolso,
                        fecha_afiliacion,
                        fecha_desafiliacion,
                        agencia_desafiliacion,
                        JAQZ556AU5,
                        JAQZ556AU8,
                        Jaqz556au1 )
      with DATA as
      (SELECT   /*+PARALLEL(A,4,1)(S,4,1)(T,4,1)(F,4,1)(P,4,1)(D,4,1)*/
          DISTINCT '1' ITEM,
          DECODE(s.sgcod,124,5, 126,5,127,5,125,6,128,6,129,6,4) PLAN_SEGURO,--  4 PLAN_SEGURO,
          NVL(SUBSTR(P.PFAPE1, 1, 30),'-') PATCLIENTE,                   --APEPAT
          NVL(SUBSTR(P.PFAPE2, 1, 30),'-') MATCLIENTE,                   --APEMAT
          SUBSTR(trim(P.PFNOM1) || ' ' || trim(P.PFNOM2), 1, 30) NOMBRECLIENTE, --NOM1
          SUBSTR(F.PENDOC, 1, 11) IDC,                            --NUMDOC
          SUBSTR(F.PETDOC, 1, 3) TIP_IDC,                          --TIPO
          SUBSTR(FN_MAIL(F.CTNRO), 1, 50) EMAIL,                --MAIL
          SUBSTR((SELECT ECNOM FROM FST009 WHERE ECCOD = P.PFECIV), 1, 20) ESTADOCIVIL,       --ESTADOCIVIL
          SUBSTR(P.PFCANT, 1, 1) SEXO,                          --SEXO
          TO_CHAR(P.PFFNAC, 'DD/MM/YYYY') FECHA_NAC,            --FECNAC
          SUBSTR(FN_TELCLIE(TRIM(F.PENDOC)), 1, 50) TELEFONO,   --FONO
          (select SUBSTR(TRIM(sngc07dsc),1,50)
            from SNGC60 f1,
                 sngc07 f7
           where f1.SNGC60Pais = P.PFPAIS
             and f1.SNGC60Tdoc = P.PFTDOC
             and f1.SNGC60Ndoc = P.PFNDOC
             and f1.sngc60corr = (select max(sngc60corr)from SNGC60  where SNGC60Pais = P.PFPAIS  and SNGC60Tdoc = P.PFTDOC and SNGC60Ndoc = P.PFNDOC )
             and f7.sngc07cod = f1.sngc60ocup) OCUPACION, --OCUPACION
          SUBSTR(D.SNGC13UGEO, 1, 8) UBIGEO_CLIENTE,            --UBIGEO
          SUBSTR(D.SNGC13DIR, 1, 100) DIRECCION,                --DIRECCION
          '0004' PRODUCTO,
          SUBSTR(A.AOSUC, 1, 3) CODIGO_SUCURSAL,                --AGENCIACOD
          FN_ANALISTA_CREDITO(A.AOMOD, A.AOSUC, A.AOMDA, A.AOPAP, A.AOCTA, A.AOOPER, A.AOSBOP, A.AOTOPE) FUNCIONARIO,
          SUBSTR((SELECT T.CENOM FROM FST026 T WHERE T.CECOD = A.AOSTAT), 1, 1) ESTADO,
          SUBSTR(LPAD(A.AOCTA, 9, '0') || LPAD(A.AOMOD, 3, '0') || LPAD(A.AOMDA, 3, '0') || LPAD(A.AOOPER, 9, '0') ||
                 LPAD(A.AOTOPE, 3, '0'), 1, 30) NRO_CREDITO,    --NRO_CTA
          DECODE(A.AOMDA, '0', '001', '002') MONEDA_CUENTA,     --MONEDA
          NVL(TO_CHAR(A.AOFE99, 'DD/MM/YYYY'),'-') FECHA_CANCELACION,    -- fecha cancelacion
          TO_CHAR(A.AOFVAL, 'DD/MM/YYYY') FECHA_DESEMBOLSO,     --FECHA_DESEMBOLSO_CRED
          0 FLAG,                                               --flag
          2 jaqz556tipo,                                         --tipo
          Case
           when A.AOFVAL > (select nvl(Max(jaqy782fchdes),a.AOFVAL) from jaqy782 where jaqy782pgc = a.PGCOD and jaqy782mod = a.AOMOD and jaqy782suc = a.AOSUC and  jaqy782mda = a.AOMDA and jaqy782pap= a.AOPAP
              and jaqy782cta = a.AOCTA and jaqy782ope= a.AOOPER and jaqy782sbo = a.AOSBOP and jaqy782top = a.AOTOPE and jaqy782sgc = s.sgcod  and jaqy782est ='A') then 1
           when A.AOFVAL < (select nvl(Max(jaqy782fchdes),a.AOFVAL) from jaqy782 where jaqy782pgc = a.PGCOD and jaqy782mod = a.AOMOD and jaqy782suc = a.AOSUC and  jaqy782mda = a.AOMDA and jaqy782pap= a.AOPAP
              and jaqy782cta = a.AOCTA and jaqy782ope= a.AOOPER and jaqy782sbo = a.AOSBOP and jaqy782top = a.AOTOPE and jaqy782sgc = s.sgcod  and jaqy782est ='A') then 1
           when A.AOFVAL = (select nvl(Max(jaqy782fchdes),a.AOFVAL) from jaqy782 where jaqy782pgc = a.PGCOD and jaqy782mod = a.AOMOD and jaqy782suc = a.AOSUC and  jaqy782mda = a.AOMDA and jaqy782pap= a.AOPAP
              and jaqy782cta = a.AOCTA and jaqy782ope= a.AOOPER and jaqy782sbo = a.AOSBOP and jaqy782top = a.AOTOPE and jaqy782sgc = s.sgcod  and jaqy782est ='A') then 0
           end  cred_falt,
          replace(to_char(A.AOIMP),',','.') importe_credito,
          replace(to_char(s.pp001imp),',','.') prima_mensual,
          (select substr(h1.hhora,1,6) from fsh015 h1,fsh016 h2 where h1.pgcod = h2.pgcod
              and h1.hcmod = h2.hcmod and h1.hsucor = h2.hsucor and h1.htran = h2.htran and h1.hnrel = h2.hnrel
              and h1.hfcon= P_FECHA and h2.hcmod =30 and h2.htran =951 and h2.hcord =10and h2.hmodul = a.AOMOD
              and h2.hsucor = a.AOSUC and h2.hmda = a.AOMDA and h2.hpap = 0 and h2.hcta = a.AOCTA and h2.hoper = a.AOOPER
              and h2.hsubop = a.AOSBOP and h2.htoper = a.AOTOPE) hora_desembolso,
          (select nvl(TO_CHAR(Max(jaqy782fchdes),'DD/MM/YYYY'),TO_CHAR(a.AOFVAL,'DD/MM/YYYY')) from jaqy782 where jaqy782pgc = a.PGCOD and jaqy782mod = a.AOMOD and jaqy782suc = a.AOSUC and  jaqy782mda = a.AOMDA and jaqy782pap= a.AOPAP
              and jaqy782cta = a.AOCTA and jaqy782ope= a.AOOPER and jaqy782sbo = a.AOSBOP and jaqy782top = a.AOTOPE and jaqy782sgc = s.sgcod  and jaqy782est ='A') fecha_afiliacion,
          (select decode(Max(jaqy782fchdes),null,'-') from jaqy782 where jaqy782pgc = a.PGCOD and jaqy782mod = a.AOMOD and jaqy782suc = a.AOSUC and  jaqy782mda = a.AOMDA and jaqy782pap= a.AOPAP
              and jaqy782cta = a.AOCTA and jaqy782ope= a.AOOPER and jaqy782sbo = a.AOSBOP and jaqy782top = a.AOTOPE and jaqy782sgc = s.sgcod  and jaqy782est ='D') fecha_desafiliacion,
           0 agencia_desafiliacion,
           P_USUARIO JAQZ556AU5,
          (select pgfape from fst017 where pgcod = 1) JAQZ556AU8,
           S.SGCOD Jaqz556au1
    FROM FSD010 A,   --SALDOS
         FPP001 S,   --SEGUROS
         XWF700 T,   --INSTANCIA
         FSR008 F,   --CUENTA DOCUMENTO
         FSD002 P,   --PERS ESTADO CIVIL
         SNGC13 D    --DIRECCION
     WHERE A.PGCOD = 1
       AND A.AOFE99 = P_FECHA--'19/06/2017'--TO_DATE('&DDMMRRRR', 'DDMMYYYY')
       AND A.AOSTAT = 99
       AND S.PGCOD = A.PGCOD
       AND S.AOMOD = A.AOMOD
       AND S.AOSUC = A.AOSUC
       AND S.AOMDA = A.AOMDA
       AND S.AOPAP = A.AOPAP
       AND S.AOCTA = A.AOCTA
       AND S.AOOPER = A.AOOPER
       AND S.AOSBOP = A.AOSBOP
       AND S.AOTOPE = A.AOTOPE
       AND S.SGCOD in (select tp1nro3
                         from fst198
                        where tp1cod = 1
                          and tp1cod1 = 10898 --for update
                          and tp1corr1 = 18
                          and tp1corr3=1
                          and tp1nro1 =1)---(120,121,122,124,125)sma.08032019
       and S.pp001imp > 0
       AND T.XWFEMPRESA = S.PGCOD
       AND T.XWFSUCURSAL = S.AOSUC
       AND T.XWFMODULO = S.AOMOD
       AND T.XWFMONEDA = S.AOMDA
       AND T.XWFPAPEL = S.AOPAP
       AND T.XWFCUENTA = S.AOCTA
       AND T.XWFOPERACION = S.AOOPER
       AND T.XWFSUBOPE = S.AOSBOP
       AND T.XWFTIPOPE = S.AOTOPE
       AND T.XWFCAR3 = '1'
       AND F.CTNRO = T.XWFCUENTA
       AND F.CTTFIR = 'T'
       AND P.PFPAIS = F.PEPAIS
       AND P.PFNDOC = F.PENDOC
       AND P.PFTDOC = F.PETDOC
       AND D.SNGC13PAIS = F.PEPAIS
       AND D.SNGC13TDOC = F.PETDOC
       AND D.SNGC13NDOC = F.PENDOC
       AND D.DOCOD = 1
       AND D.SNGC13EST = 'H'
       AND EXISTS(SELECT 1
                    FROM FSD611
                   WHERE PGCOD = T.XWFEMPRESA
                     AND PPMOD = T.XWFMODULO
                     AND PPSUC = T.XWFSUCURSAL
                     AND PPMDA = T.XWFMONEDA
                     AND pppap = T.XWFPAPEL
                     AND PPCTA = T.XWFCUENTA
                     AND PPOPER = T.XWFOPERACION
                     AND PPSBOP = T.XWFSUBOPE
                     AND PPTOPE = T.XWFTIPOPE ))
        select seq_jaqz556.nextval,
                item,
                plan_seguro,
                patcliente,
                matcliente,
                nombrecliente,
                idc,
                tip_idc,
                email,
                estadocivil,
                sexo,
                fecha_nac,
                telefono,
                ocupacion,
                ubigeo_cliente,
                direccion,
                producto,
                codigo_sucursal,
                funcionario,
                estado,
                nro_credito,
                moneda_cuenta,
                fecha_cancelacion,
                fecha_desembolso,
                flag,
                jaqz556tipo,
                cred_falt,
                importe_credito,
                prima_mensual,
                hora_desembolso,
                fecha_afiliacion,
                fecha_desafiliacion,
                agencia_desafiliacion,
                JAQZ556AU5,
                JAQZ556AU8,
                JAQZ556AU1  from DATA;
   COMMIT;
   --CANTIDAD CANCELADOS PLAN_III + PLAN_IV
   --insert into repsegvidd (descripcion,total) values ('2- CANCELADOS PLAN_III + PLAN_IV', (select count(*) from JAQZ556 where plan_seguro= 4));
   ---PRUEBA
   insert into JAQZ557 (descripcion,total) values ('2- CANCELADOS PLAN_III + PLAN_IV', (select count(*) from JAQZ556 where jaqz556tipo = 2));
   ----------
   commit;
   EXCEPTION
    WHEN OTHERS THEN
      err_code := SQLCODE;
      err_msg := SUBSTR(SQLERRM, 1, 200)||' '||'JAQZ556TIPO'||' '|| '2';


      INSERT INTO JAQZ557LOG (jaqz557ecod  , jaqz557emsg,jaqz557fecha   )
      VALUES (err_code, err_msg, fecha);
      commit;
   END;
   --(1C): Creditos con seguro vida caja pagos de cuotas o cancelados
   BEGIN
    insert /*+append*/ into JAQZ556(jaqz556cod,
                                    item,
                                    plan_seguro,
                                    patcliente,
                                    matcliente,
                                    nombrecliente,
                                    idc,
                                    tip_idc,
                                    email,
                                    estadocivil,
                                    sexo,
                                    fecha_nac,
                                    telefono,
                                    ocupacion,
                                    ubigeo_cliente,
                                    direccion,
                                    producto,
                                    codigo_sucursal,
                                    funcionario,
                                    estado,
                                    nro_credito,
                                    moneda_cuenta,
                                    fecha_cancelacion,
                                    fecha_desembolso,
                                    flag,
                                    jaqz556tipo,
                                    cred_falt,
                                    importe_credito,
                                    prima_mensual,
                                    hora_desembolso,
                                    fecha_afiliacion,
                                    fecha_desafiliacion,
                                    agencia_desafiliacion,
                                    JAQZ556AU5,
                                    JAQZ556AU8,
                                    JAQZ556AU1)with Data as
      (SELECT  /*+PARALLEL(A,4,1)(S,4,1)(T,4,1)(F,4,1)(P,4,1)(D,4,1)(F6,4,1)*/
      DISTINCT '1' ITEM,
      7 PLAN_SEGURO, --- sma codigo nuevo seguro
      NVL(SUBSTR(P.PFAPE1, 1, 30),'-') PATCLIENTE,                   --APEPAT
      NVL(SUBSTR(P.PFAPE2, 1, 30),'-') MATCLIENTE,                   --APEMAT
      SUBSTR(trim(P.PFNOM1) || ' ' || trim(P.PFNOM2), 1, 30) NOMBRECLIENTE, --NOM1
      SUBSTR(F.PENDOC, 1, 11) IDC,                            --NUMDOC
      SUBSTR(F.PETDOC, 1, 3) TIP_IDC,                          --TIPO
      SUBSTR(FN_MAIL(F.CTNRO), 1, 50) EMAIL,                --MAIL
      SUBSTR((SELECT ECNOM FROM FST009 WHERE ECCOD = P.PFECIV), 1, 20) ESTADOCIVIL,       --ESTADOCIVIL
      SUBSTR(P.PFCANT, 1, 1) SEXO,                          --SEXO
      TO_CHAR(P.PFFNAC, 'DD/MM/YYYY') FECHA_NAC,            --FECNAC
      SUBSTR(FN_TELCLIE(TRIM(F.PENDOC)), 1, 50) TELEFONO,   --FONO
      (select SUBSTR(TRIM(sngc07dsc),1,50)
        from SNGC60 f1,
             sngc07 f7
       where f1.SNGC60Pais = P.PFPAIS
         and f1.SNGC60Tdoc = P.PFTDOC
         and f1.SNGC60Ndoc = P.PFNDOC
         and f1.sngc60corr = (select max(sngc60corr)from SNGC60  where SNGC60Pais = P.PFPAIS  and SNGC60Tdoc = P.PFTDOC and SNGC60Ndoc = P.PFNDOC )
         and f7.sngc07cod = f1.sngc60ocup) OCUPACION, --OCUPACION
      SUBSTR(D.SNGC13UGEO, 1, 8) UBIGEO_CLIENTE,            --UBIGEO
      SUBSTR(D.SNGC13DIR, 1, 100) DIRECCION,                --DIRECCION
      '0011' PRODUCTO,
      SUBSTR(A.AOSUC, 1, 3) CODIGO_SUCURSAL,                --AGENCIACOD
      FN_ANALISTA_CREDITO(A.AOMOD, A.AOSUC, A.AOMDA, A.AOPAP, A.AOCTA, A.AOOPER, A.AOSBOP, A.AOTOPE) FUNCIONARIO,
      SUBSTR((SELECT T.CENOM FROM FST026 T WHERE T.CECOD = A.AOSTAT), 1, 1) ESTADO,
      SUBSTR(LPAD(A.AOCTA, 9, '0') || LPAD(A.AOMOD, 3, '0') || LPAD(A.AOMDA, 3, '0') || LPAD(A.AOOPER, 9, '0') ||
             LPAD(A.AOTOPE, 3, '0'), 1, 30) NRO_CREDITO,    --NRO_CTA
      DECODE(A.AOMDA, '0', '001', '002') MONEDA_CUENTA,     --MONEDA
      NVL(TO_CHAR(A.AOFE99, 'DD/MM/YYYY'),'-') FECHA_CANCELACION,
      TO_CHAR(A.AOFVAL, 'DD/MM/YYYY') FECHA_DESEMBOLSO,     --FECHA_DESEMBOLSO_CRED
      0 FLAG,
      3 jaqz556tipo,
      Case
       when A.AOFVAL > (select nvl(Max(jaqy782fchdes),a.AOFVAL) from jaqy782 where jaqy782pgc = a.PGCOD and jaqy782mod = a.AOMOD and jaqy782suc = a.AOSUC and  jaqy782mda = a.AOMDA and jaqy782pap= a.AOPAP
          and jaqy782cta = a.AOCTA and jaqy782ope= a.AOOPER and jaqy782sbo = a.AOSBOP and jaqy782top = a.AOTOPE and jaqy782sgc = s.sgcod  and jaqy782est ='A') then 1
       when A.AOFVAL < (select nvl(Max(jaqy782fchdes),a.AOFVAL) from jaqy782 where jaqy782pgc = a.PGCOD and jaqy782mod = a.AOMOD and jaqy782suc = a.AOSUC and  jaqy782mda = a.AOMDA and jaqy782pap= a.AOPAP
          and jaqy782cta = a.AOCTA and jaqy782ope= a.AOOPER and jaqy782sbo = a.AOSBOP and jaqy782top = a.AOTOPE and jaqy782sgc = s.sgcod  and jaqy782est ='A') then 1
       when A.AOFVAL = (select nvl(Max(jaqy782fchdes),a.AOFVAL) from jaqy782 where jaqy782pgc = a.PGCOD and jaqy782mod = a.AOMOD and jaqy782suc = a.AOSUC and  jaqy782mda = a.AOMDA and jaqy782pap= a.AOPAP
          and jaqy782cta = a.AOCTA and jaqy782ope= a.AOOPER and jaqy782sbo = a.AOSBOP and jaqy782top = a.AOTOPE and jaqy782sgc = s.sgcod  and jaqy782est ='A') then 0
       end  cred_falt,
      replace(to_char(A.AOIMP),',','.') importe_credito,
      replace(to_char(s.pp001imp),',','.') prima_mensual,
      (select substr(h1.hhora,1,6) from fsh015 h1,fsh016 h2 where h1.pgcod = h2.pgcod
          and h1.hcmod = h2.hcmod and h1.hsucor = h2.hsucor and h1.htran = h2.htran and h1.hnrel = h2.hnrel
          and h1.hfcon= P_FECHA and h2.hcmod =30 and h2.htran =951 and h2.hcord =10and h2.hmodul = a.AOMOD
          and h2.hsucor = a.AOSUC and h2.hmda = a.AOMDA and h2.hpap = 0 and h2.hcta = a.AOCTA and h2.hoper = a.AOOPER
          and h2.hsubop = a.AOSBOP and h2.htoper = a.AOTOPE) hora_desembolso,
      (select nvl(TO_CHAR(Max(jaqy782fchdes),'DD/MM/YYYY'),TO_CHAR(a.AOFVAL,'DD/MM/YYYY')) from jaqy782 where jaqy782pgc = a.PGCOD and jaqy782mod = a.AOMOD and jaqy782suc = a.AOSUC and  jaqy782mda = a.AOMDA and jaqy782pap= a.AOPAP
          and jaqy782cta = a.AOCTA and jaqy782ope= a.AOOPER and jaqy782sbo = a.AOSBOP and jaqy782top = a.AOTOPE and jaqy782sgc = s.sgcod  and jaqy782est ='A') fecha_afiliacion,
      (select decode(Max(jaqy782fchdes),null,'-') from jaqy782 where jaqy782pgc = a.PGCOD and jaqy782mod = a.AOMOD and jaqy782suc = a.AOSUC and  jaqy782mda = a.AOMDA and jaqy782pap= a.AOPAP
          and jaqy782cta = a.AOCTA and jaqy782ope= a.AOOPER and jaqy782sbo = a.AOSBOP and jaqy782top = a.AOTOPE and jaqy782sgc = s.sgcod  and jaqy782est ='D') fecha_desafiliacion,
       0 agencia_desafiliacion,
       P_USUARIO JAQZ556AU5,
       (select pgfape from fst017 where pgcod=1) JAQZ556AU8,
       s.sgcod JAQZ556AU1
    FROM FSD010 A,   --SALDOS
         FPP001 S,   --SEGUROS
         XWF700 T,   --INSTANCIA
         FSR008 F,   --CUENTA DOCUMENTO
         FSD002 P,   --PERS ESTADO CIVIL
         SNGC13 D,    --DIRECCION
         FSD611 F6
     WHERE A.PGCOD = 1
       AND A.AOFE99 = P_FECHA--'19/06/2017'--TO_DATE('&DDMMRRRR', 'DDMMYYYY')
       AND A.AOSTAT = 99
       AND S.PGCOD = A.PGCOD
       AND S.AOMOD = A.AOMOD
       AND S.AOSUC = A.AOSUC
       AND S.AOMDA = A.AOMDA
       AND S.AOPAP = A.AOPAP
       AND S.AOCTA = A.AOCTA
       AND S.AOOPER = A.AOOPER
       AND S.AOSBOP = A.AOSBOP
       AND S.AOTOPE = A.AOTOPE
       AND S.SGCOD in (select tp1nro3 ---SMA 13/11/2019 Seg. Asisteencia Médica
                         from fst198
                        where tp1cod = 1
                          and tp1cod1 = 10898
                          and tp1corr1 = 18
                          and tp1corr3= 2)
       and S.pp001imp > 0
       AND T.XWFEMPRESA = S.PGCOD
       AND T.XWFSUCURSAL = S.AOSUC
       AND T.XWFMODULO = S.AOMOD
       AND T.XWFMONEDA = S.AOMDA
       AND T.XWFPAPEL = S.AOPAP
       AND T.XWFCUENTA = S.AOCTA
       AND T.XWFOPERACION = S.AOOPER
       AND T.XWFSUBOPE = S.AOSBOP
       AND T.XWFTIPOPE = S.AOTOPE
       AND T.XWFCAR3 = '1'
       AND F.CTNRO = T.XWFCUENTA
       AND F.CTTFIR = 'T'
       AND P.PFPAIS = F.PEPAIS
       AND P.PFNDOC = F.PENDOC
       AND P.PFTDOC = F.PETDOC
       AND D.SNGC13PAIS = F.PEPAIS
       AND D.SNGC13TDOC = F.PETDOC
       AND D.SNGC13NDOC = F.PENDOC
       AND D.DOCOD = 1
       AND D.SNGC13EST = 'H'
       AND F6.PGCOD = T.XWFEMPRESA
       AND F6.PPMOD = T.XWFMODULO
       AND F6.PPSUC = T.XWFSUCURSAL
       AND F6.PPMDA = T.XWFMONEDA
       AND F6.pppap = T.XWFPAPEL
       AND F6.PPCTA = T.XWFCUENTA
       AND F6.PPOPER = T.XWFOPERACION
       AND F6.PPSBOP = T.XWFSUBOPE
       AND F6.PPTOPE = T.XWFTIPOPE
       AND F6.PPFPAG = (SELECT MIN(PPFPAG)
                         FROM  FSD611
                         WHERE PGCOD = F6.PGCOD
                           AND PPMOD = F6.PPMOD
                           AND PPSUC = F6.PPSUC
                           AND PPMDA = F6.PPMDA
                           AND pppap = F6.PPPAP
                           AND PPCTA = F6.PPCTA
                           AND PPOPER = F6.PPOPER
                           AND PPSBOP = F6.PPSBOP
                           AND PPTOPE = F6.PPTOPE))
                select seq_jaqz556.nextval,
                        item,
                        plan_seguro,
                        patcliente,
                        matcliente,
                        nombrecliente,
                        idc,
                        tip_idc,
                        email,
                        estadocivil,
                        sexo,
                        fecha_nac,
                        telefono,
                        ocupacion,
                        ubigeo_cliente,
                        direccion,
                        producto,
                        codigo_sucursal,
                        funcionario,
                        estado,
                        nro_credito,
                        moneda_cuenta,
                        fecha_cancelacion,
                        fecha_desembolso,
                        flag,
                        jaqz556tipo,
                        cred_falt,
                        importe_credito,
                        prima_mensual,
                        hora_desembolso,
                        fecha_afiliacion,
                        fecha_desafiliacion,
                        agencia_desafiliacion,
                        JAQZ556AU5,
                        JAQZ556AU8,
                        JAQZ556AU1  from DATA;
   COMMIT;
   --insert into repsegvidd (descripcion,total)
--       values ('3- CANCELADOS PLAN_III + PLAN_IV + FAMILIA SEGURA', (select count(*) from JAQZ556 where plan_seguro in (1,2,3) and producto =  '0005'));
   ---PRUEBA
   insert into JAQZ557 (descripcion,total) values ('3- CANCELADOS PLAN_III + PLAN_IV + FAMILIA SEGURA', (select count(*) from JAQZ556 where jaqz556tipo = 3));
   ----------
   commit;
   EXCEPTION
    WHEN OTHERS THEN
      err_code := SQLCODE;
      err_msg := SUBSTR(SQLERRM, 1, 200)||' '||'JAQZ556TIPO'||' '|| '3';

       INSERT INTO JAQZ557LOG (jaqz557ecod  , jaqz557emsg,jaqz557fecha   )
      VALUES (err_code, err_msg, fecha);
      commit;
  END;
   ---******************************************* 2DA PARTE **********************************************---
   ----------------------------(2A): Creditos nuevos con seguro vida PLAN IV
   BEGIN
   insert /* +APPEND */into JAQZ556 (jaqz556cod,
                        item,
                        plan_seguro,
                        patcliente,
                        matcliente,
                        nombrecliente,
                        idc,
                        tip_idc,
                        email,
                        estadocivil,
                        sexo,
                        fecha_nac,
                        telefono,
                        ocupacion,
                        ubigeo_cliente,
                        direccion,
                        producto,
                        codigo_sucursal,
                        funcionario,
                        estado,
                        nro_credito,
                        moneda_cuenta,
                        fecha_cancelacion,
                        fecha_desembolso,
                        flag,
                        jaqz556tipo,
                        cred_falt,
                        importe_credito,
                        prima_mensual,
                        hora_desembolso,
                        fecha_afiliacion,
                        fecha_desafiliacion,
                        agencia_desafiliacion,
                        JAQZ556AU5,
                        JAQZ556AU8,
                        JAQZ556AU1)with DATA as
    (SELECT /*+PARALLEL(A,4,1)(S,4,1)(B,4,1)(T,4,1)(Q,4,1)(F6,4,1)(F,4,1)(P,4,1)(D,4,1)*/
           DISTINCT '1' ITEM,
           DECODE(s.sgcod,124,5, 126,5,127,5,125,6,128,6,129,6,4) PLAN_SEGURO,--- 4 PLAN_SEGURO,
           NVL(SUBSTR(P.PFAPE1, 1, 30),'-') PATCLIENTE,                         --APEPAT
           NVL(SUBSTR(P.PFAPE2, 1, 30),'-') MATCLIENTE,                         --APEMAT
           SUBSTR(trim(P.PFNOM1) || ' ' || trim(P.PFNOM2), 1, 30) NOMBRECLIENTE, --NOM1
           SUBSTR(F.PENDOC, 1, 11) IDC,                                  --NUMDOC
           SUBSTR(F.PETDOC, 1, 3) TIP_IDC,                                --TIPO
           SUBSTR(FN_MAIL(F.CTNRO), 1, 50) EMAIL,                      --MAIL
           SUBSTR((SELECT ECNOM FROM FST009 WHERE ECCOD = P.PFECIV), 1, 20) ESTADOCIVIL, --ESTADOCIVIL
           SUBSTR(P.PFCANT, 1, 1) SEXO,                                --SEXO
           TO_CHAR(P.PFFNAC, 'DD/MM/YYYY') FECHA_NAC,                  --FECNAC
           SUBSTR(FN_TELCLIE(TRIM(F.PENDOC)), 1, 50) TELEFONO,         --FONO
            (select SUBSTR(TRIM(sngc07dsc),1,50)
              from SNGC60 f1,
                   sngc07 f7
             where f1.SNGC60Pais = P.PFPAIS
               and f1.SNGC60Tdoc = P.PFTDOC
               and f1.SNGC60Ndoc = P.PFNDOC
               and f1.sngc60corr = (select max(sngc60corr)from SNGC60  where SNGC60Pais = P.PFPAIS  and SNGC60Tdoc = P.PFTDOC and SNGC60Ndoc = P.PFNDOC )
               and f7.sngc07cod = f1.sngc60ocup) OCUPACION,           --OCUPACION
           SUBSTR(D.SNGC13UGEO, 1, 8) UBIGEO_CLIENTE,                  --UBIGEO
           SUBSTR(D.SNGC13DIR, 1, 100) DIRECCION,                      --DIRECCION
           '0004' PRODUCTO,
           SUBSTR(A.AOSUC, 1, 3) codigo_sucursal,                      --AGENCIACOD
           fn_usu_captador(q.jaqm251cta, q.jaqm251ope, q.JAQM251PGC, q.JAQM251MOD, q.JAQM251SUC, q.JAQM251MDA, q.JAQM251PAP, q.JAQM251SBO,
                           q.JAQM251TOP) FUNCIONARIO,
           SUBSTR((SELECT T.CENOM FROM FST026 T WHERE T.CECOD = A.AOSTAT), 1, 1) ESTADO, --ESTADO_CREDITO
           SUBSTR(LPAD(A.AOCTA, 9, '0') || LPAD(A.AOMOD, 3, '0') || LPAD(A.AOMDA, 3, '0') || LPAD(A.AOOPER, 9, '0') ||
                  LPAD(A.AOTOPE, 3, '0'), 1, 30) NRO_CREDITO,          --NRO_CTA
           DECODE(A.AOMDA, '0', '001', '002') MONEDA_CUENTA,           --MONEDA
           ' ' FECHA_CANCELACION,
           TO_CHAR(A.AOFVAL, 'DD/MM/YYYY') FECHA_DESEMBOLSO,
           0 FLAG,
           4 jaqz556tipo,
           Case
           when A.AOFVAL > q.jaqm251fec then 1
           when A.AOFVAL < q.jaqm251fec then 1
           when A.AOFVAL = q.jaqm251fec then 0
           end  cred_falt,
           replace(to_char(A.AOIMP),',','.') importe_credito,
            replace(to_char(s.pp001imp),',','.') prima_mensual,
            (select substr(h1.hhora,1,6) from fsh015 h1,fsh016 h2 where h1.pgcod = h2.pgcod
                and h1.hcmod = h2.hcmod and h1.hsucor = h2.hsucor and h1.htran = h2.htran and h1.hnrel = h2.hnrel
                and h1.hfcon= P_FECHA and h2.hcmod =30 and h2.htran =951 and h2.hcord =10and h2.hmodul = a.AOMOD
                and h2.hsucor = a.AOSUC and h2.hmda = a.AOMDA and h2.hpap = 0 and h2.hcta = a.AOCTA and h2.hoper = a.AOOPER
                and h2.hsubop = a.AOSBOP and h2.htoper = a.AOTOPE) hora_desembolso,
            TO_CHAR(A.AOFVAL,'DD/MM/YYYY') fecha_afiliacion,---sma 22102018 q.jaqm251fec
            (select decode(Max(jaqy782fchdes),null,'-') from jaqy782 where jaqy782pgc = a.PGCOD and jaqy782mod = a.AOMOD and jaqy782suc = a.AOSUC and  jaqy782mda = a.AOMDA and jaqy782pap= a.AOPAP
                and jaqy782cta = a.AOCTA and jaqy782ope= a.AOOPER and jaqy782sbo = a.AOSBOP and jaqy782top = a.AOTOPE and jaqy782sgc = s.sgcod  and jaqy782est ='D') fecha_desafiliacion,
             0 agencia_desafiliacion,
             P_USUARIO JAQZ556AU5,
             (select pgfape from fst017 where pgcod=1) JAQZ556AU8,
             s.sgcod JAQZ556AU1
        FROM FSD010 A, --SALDOS
             FPP001 S,  --SEGUROS
             FSD011 B, --CRE. VIG.
             XWF700 T, --INSTANCIA
             jaqm251 Q, --TABLA SEGUROS DESPUES DE DESEMBOLSO
             FSD611 F6  , --TABLA calendario seguros
             FSR008 F, --CUENTA DOCUMENTO
             FSD002 P, --PERS ESTADO CIVIL
             SNGC13 D --DIRECCION
       WHERE A.PGCOD = 1
         AND A.AOFVAL = P_FECHA--'19/06/2017'--TO_DATE('&DDMMRRRR', 'DDMMYYYY')
         AND S.PGCOD = A.PGCOD
         AND S.AOMOD = A.AOMOD
         AND S.AOSUC = A.AOSUC
         AND S.AOMDA = A.AOMDA
         AND S.AOPAP = A.AOPAP
         AND S.AOCTA = A.AOCTA
         AND S.AOOPER = A.AOOPER
         AND S.AOSBOP = A.AOSBOP
         AND S.AOTOPE = A.AOTOPE
         AND S.SGCOD in (select tp1nro3
                         from fst198
                        where tp1cod = 1
                          and tp1cod1 = 10898 --for update
                          and tp1corr1 = 18
                          and tp1corr3=1
                          and tp1nro1 =1)---(120,121,122,124,125)sma.08032019
         and S.pp001imp > 0
        AND B.PGCOD = S.PGCOD
         AND B.SCMOD = S.AOMOD
         AND B.SCSUC = S.AOSUC
         AND B.SCMDA = S.AOMDA
         AND B.SCPAP = S.AOPAP
         AND B.SCCTA = S.AOCTA
         AND B.SCOPER = S.AOOPER
         AND B.SCSBOP = S.AOSBOP
         AND B.SCTOPE = S.AOTOPE
         AND T.XWFEMPRESA = B.PGCOD
         AND T.XWFSUCURSAL = B.SCSUC
         AND T.XWFMODULO = B.SCMOD
         AND T.XWFMONEDA = B.SCMDA
         AND T.XWFPAPEL = B.SCPAP
         AND T.XWFCUENTA =  B.SCCTA
         AND T.XWFOPERACION = B.SCOPER
         AND T.XWFSUBOPE = B.SCSBOP
         AND T.XWFTIPOPE = B.SCTOPE
         AND T.XWFCAR3 = '1'
         AND Q.JAQM251PGC = T.XWFEMPRESA
         AND Q.JAQM251MOD = T.XWFMODULO
         AND Q.JAQM251SUC = T.XWFSUCURSAL
         AND Q.JAQM251MDA = T.XWFMONEDA
         AND Q.JAQM251PAP = T.XWFPAPEL
         AND Q.JAQM251CTA = T.XWFCUENTA
         AND Q.JAQM251OPE = T.XWFOPERACION
         AND Q.JAQM251SBO = T.XWFSUBOPE
         AND Q.JAQM251TOP = T.XWFTIPOPE
         AND Q.JAQM251FEC < A.AOFVAL
         AND F6.PGCOD = Q.JAQM251PGC
         AND F6.PPMOD = Q.JAQM251MOD
         AND F6.PPSUC = Q.JAQM251SUC
         AND F6.PPMDA = Q.JAQM251MDA
         AND F6.pppap = Q.JAQM251PAP
         AND F6.PPCTA = Q.JAQM251CTA
         AND F6.PPOPER = Q.JAQM251OPE
         AND F6.PPSBOP = Q.JAQM251SBO
         AND F6.PPTOPE = Q.JAQM251TOP
         AND F6.PPFPAG = (SELECT MIN(PPFPAG)
                           FROM  FSD611
                           WHERE PGCOD = F6.PGCOD
                             AND PPMOD = F6.PPMOD
                             AND PPSUC = F6.PPSUC
                             AND PPMDA = F6.PPMDA
                             AND pppap = F6.PPPAP
                             AND PPCTA = F6.PPCTA
                             AND PPOPER = F6.PPOPER
                             AND PPSBOP = F6.PPSBOP
                             AND PPTOPE = F6.PPTOPE)
         AND F.CTNRO = F6.PPCTA
         AND F.CTTFIR = 'T'
         AND F.TTCOD = 1
         AND P.PFPAIS = F.PEPAIS
         AND P.PFTDOC = F.PETDOC
         AND P.PFNDOC = F.PENDOC
         AND D.SNGC13PAIS = P.PFPAIS
         AND D.SNGC13TDOC = P.PFTDOC
         AND D.SNGC13NDOC = P.PFNDOC
         AND D.DOCOD = 1
         AND D.SNGC13EST = 'H')
      select seq_jaqz556.nextval,
             item,
              plan_seguro,
              patcliente,
              matcliente,
              nombrecliente,
              idc,
              tip_idc,
              email,
              estadocivil,
              sexo,
              fecha_nac,
              telefono,
              ocupacion,
              ubigeo_cliente,
              direccion,
              producto,
              codigo_sucursal,
              funcionario,
              estado,
              nro_credito,
              moneda_cuenta,
              fecha_cancelacion,
              fecha_desembolso,
              flag,
              jaqz556tipo,
              cred_falt,
              importe_credito,
              prima_mensual,
              hora_desembolso,
              fecha_afiliacion,
              fecha_desafiliacion,
              agencia_desafiliacion,
              JAQZ556AU5,
              JAQZ556AU8,
              JAQZ556AU1  from DATA;

     commit;
--CANTIDAD NUEVOS PLAN_IV
  --  insert into repsegvidd (descripcion,total) values ('4- NUEVOS PLAN_IV', (select count(*) from JAQZ556));
    insert into JAQZ557(descripcion,total) values ('4- NUEVOS PLAN_IV', (select count(*) from JAQZ556 where jaqz556tipo = 4));
    commit;
    EXCEPTION
    WHEN OTHERS THEN
        err_code := SQLCODE;
        err_msg := SUBSTR(SQLERRM, 1, 200)||' '||'JAQZ556TIPO'||' '|| '4';


         INSERT INTO JAQZ557LOG (jaqz557ecod  , jaqz557emsg,jaqz557fecha   )
         VALUES (err_code, err_msg, fecha);
        commit;
    END;
    ------------------------------------------------------------------------------------------------------------
    --------------(2B): Creditos nuevos con seguro familia segura
    BEGIN
    insert  /* +APPEND */ into JAQZ556 (jaqz556cod,
                        item,
                        plan_seguro,
                        patcliente,
                        matcliente,
                        nombrecliente,
                        idc,
                        tip_idc,
                        email,
                        estadocivil,
                        sexo,
                        fecha_nac,
                        telefono,
                        ocupacion,
                        ubigeo_cliente,
                        direccion,
                        producto,
                        codigo_sucursal,
                        funcionario,
                        estado,
                        nro_credito,
                        moneda_cuenta,
                        fecha_cancelacion,
                        fecha_desembolso,
                        flag,
                        jaqz556tipo,
                        cred_falt,
                        importe_credito,
                        prima_mensual,
                        hora_desembolso,
                        fecha_afiliacion,
                        fecha_desafiliacion,
                        agencia_desafiliacion,
                        JAQZ556AU5,
                        JAQZ556AU8,
                        JAQZ556AU1 )with DATA as
     (SELECT /*+PARALLEL(A,4,1)(S,4,1)(B,4,1)(T,4,1)(Q,4,1)(F6,4,1)(F,4,1)(P,4,1)(D,4,1)*/
             DISTINCT '1' ITEM,
             7 PLAN_SEGURO, --adicion nuevo codigo de Seg. AsisMedica
             NVL(SUBSTR(P.PFAPE1, 1, 30),'-') PATCLIENTE,                         --APEPAT
             NVL(SUBSTR(P.PFAPE2, 1, 30),'-') MATCLIENTE,                         --APEMAT
             SUBSTR(trim(P.PFNOM1) || ' ' || trim(P.PFNOM2), 1, 30) NOMBRECLIENTE, --NOM1
             SUBSTR(F.PENDOC, 1, 11) IDC,                                  --NUMDOC
             SUBSTR(F.PETDOC, 1, 3) TIP_IDC,                                --TIPO
             SUBSTR(FN_MAIL(F.CTNRO), 1, 50) EMAIL,                      --MAIL
             SUBSTR((SELECT ECNOM FROM FST009 WHERE ECCOD = P.PFECIV), 1, 20) ESTADOCIVIL, --ESTADOCIVIL
             SUBSTR(P.PFCANT, 1, 1) SEXO,                                --SEXO
             TO_CHAR(P.PFFNAC, 'DD/MM/YYYY') FECHA_NAC,                  --FECNAC
             SUBSTR(FN_TELCLIE(TRIM(F.PENDOC)), 1, 50) TELEFONO,         --FONO
             (select SUBSTR(TRIM(sngc07dsc),1,50)
                      from SNGC60 f1,
                           sngc07 f7
                     where f1.SNGC60Pais = P.PFPAIS
                       and f1.SNGC60Tdoc = P.PFTDOC
                       and f1.SNGC60Ndoc = P.PFNDOC
                       and f1.sngc60corr = (select max(sngc60corr)from SNGC60  where SNGC60Pais = P.PFPAIS  and SNGC60Tdoc = P.PFTDOC and SNGC60Ndoc = P.PFNDOC )
                       and f7.sngc07cod = f1.sngc60ocup) OCUPACION,      --OCUPACION
             SUBSTR(D.SNGC13UGEO, 1, 8) UBIGEO_CLIENTE,                  --UBIGEO
             SUBSTR(D.SNGC13DIR, 1, 100) DIRECCION,                      --DIRECCION
             '0011' PRODUCTO,
             SUBSTR(A.AOSUC, 1, 3) codigo_sucursal,                               --AGENCIACOD
             fn_usu_captador(q.jaqm251cta, q.jaqm251ope, q.JAQM251PGC, q.JAQM251MOD, q.JAQM251SUC, q.JAQM251MDA, q.JAQM251PAP, q.JAQM251SBO,
                             q.JAQM251TOP) FUNCIONARIO,
             SUBSTR((SELECT T.CENOM FROM FST026 T WHERE T.CECOD = A.AOSTAT), 1, 1) ESTADO, --ESTADO_CREDITO
             SUBSTR(LPAD(A.AOCTA, 9, '0') || LPAD(A.AOMOD, 3, '0') || LPAD(A.AOMDA, 3, '0') || LPAD(A.AOOPER, 9, '0') ||
                    LPAD(A.AOTOPE, 3, '0'), 1, 30) NRO_CREDITO,          --NRO_CTA
             DECODE(A.AOMDA, '0', '001', '002') MONEDA_CUENTA,           --MONEDA
             ' ' FECHA_CANCELACION,
             TO_CHAR(A.AOFVAL, 'DD/MM/YYYY') FECHA_DESEMBOLSO,
             0 FLAG,
             5 JAQZ556TIPO,
             Case
             when A.AOFVAL > (select nvl(Max(jaqy782fchdes),a.AOFVAL) from jaqy782 where jaqy782pgc = a.PGCOD and jaqy782mod = a.AOMOD and jaqy782suc = a.AOSUC and  jaqy782mda = a.AOMDA and jaqy782pap= a.AOPAP
                and jaqy782cta = a.AOCTA and jaqy782ope= a.AOOPER and jaqy782sbo = a.AOSBOP and jaqy782top = a.AOTOPE and jaqy782sgc = s.sgcod  and jaqy782est ='A') then 1
             when A.AOFVAL < (select nvl(Max(jaqy782fchdes),a.AOFVAL) from jaqy782 where jaqy782pgc = a.PGCOD and jaqy782mod = a.AOMOD and jaqy782suc = a.AOSUC and  jaqy782mda = a.AOMDA and jaqy782pap= a.AOPAP
                and jaqy782cta = a.AOCTA and jaqy782ope= a.AOOPER and jaqy782sbo = a.AOSBOP and jaqy782top = a.AOTOPE and jaqy782sgc = s.sgcod  and jaqy782est ='A') then 1
             when A.AOFVAL = (select nvl(Max(jaqy782fchdes),a.AOFVAL) from jaqy782 where jaqy782pgc = a.PGCOD and jaqy782mod = a.AOMOD and jaqy782suc = a.AOSUC and  jaqy782mda = a.AOMDA and jaqy782pap= a.AOPAP
                and jaqy782cta = a.AOCTA and jaqy782ope= a.AOOPER and jaqy782sbo = a.AOSBOP and jaqy782top = a.AOTOPE and jaqy782sgc = s.sgcod  and jaqy782est ='A') then 0
             end  cred_falt,
             replace(to_char(A.AOIMP),',','.') importe_credito,
             replace(to_char(s.pp001imp),',','.') prima_mensual,
              (select substr(h1.hhora,1,6) from fsh015 h1,fsh016 h2 where h1.pgcod = h2.pgcod
                  and h1.hcmod = h2.hcmod and h1.hsucor = h2.hsucor and h1.htran = h2.htran and h1.hnrel = h2.hnrel
                  and h1.hfcon= P_FECHA and h2.hcmod =30 and h2.htran =951 and h2.hcord =10and h2.hmodul = a.AOMOD
                  and h2.hsucor = a.AOSUC and h2.hmda = a.AOMDA and h2.hpap = 0 and h2.hcta = a.AOCTA and h2.hoper = a.AOOPER
                  and h2.hsubop = a.AOSBOP and h2.htoper = a.AOTOPE) hora_desembolso,
              (select nvl(TO_CHAR(Max(jaqy782fchdes),'DD/MM/YYYY'),TO_CHAR(a.AOFVAL,'DD/MM/YYYY')) from jaqy782 where jaqy782pgc = a.PGCOD and jaqy782mod = a.AOMOD and jaqy782suc = a.AOSUC and  jaqy782mda = a.AOMDA and jaqy782pap= a.AOPAP
                  and jaqy782cta = a.AOCTA and jaqy782ope= a.AOOPER and jaqy782sbo = a.AOSBOP and jaqy782top = a.AOTOPE and jaqy782sgc = s.sgcod  and jaqy782est ='A') fecha_afiliacion,
              (select decode(Max(jaqy782fchdes),null,'-') from jaqy782 where jaqy782pgc = a.PGCOD and jaqy782mod = a.AOMOD and jaqy782suc = a.AOSUC and  jaqy782mda = a.AOMDA and jaqy782pap= a.AOPAP
                  and jaqy782cta = a.AOCTA and jaqy782ope= a.AOOPER and jaqy782sbo = a.AOSBOP and jaqy782top = a.AOTOPE and jaqy782sgc = s.sgcod  and jaqy782est ='D') fecha_desafiliacion,
               0 agencia_desafiliacion,
               P_USUARIO JAQZ556AU5,
               (select pgfape from fst017 where pgcod=1) JAQZ556AU8,
               s.sgcod JAQZ556AU1
        FROM FSD010 A, --SALDOS
             FPP001 S,  --SEGUROS
             FSD011 B, --CRE. VIG.
             XWF700 T, --INSTANCIA
             jaqm251 Q,
             FSD611 F6  , --TABLA SEGUROS DESPUES DE DESEMBOLSO
             FSR008 F, --CUENTA DOCUMENTO
             FSD002 P, --PERS ESTADO CIVIL
             SNGC13 D
       WHERE A.PGCOD = 1
         AND A.AOFVAL = P_FECHA--'19/06/2017'--TO_DATE('&DDMMRRRR', 'DDMMYYYY')
         AND S.PGCOD = A.PGCOD
         AND S.AOMOD = A.AOMOD
         AND S.AOSUC = A.AOSUC
         AND S.AOMDA = A.AOMDA
         AND S.AOPAP = A.AOPAP
         AND S.AOCTA = A.AOCTA
         AND S.AOOPER = A.AOOPER
         AND S.AOSBOP = A.AOSBOP
         AND S.AOTOPE = A.AOTOPE
         AND S.SGCOD in (select tp1nro3
                           from fst198
                          Where Tp1cod    = 1
                            and Tp1cod1   = 10898
                            and Tp1corr1  = 18
                            and Tp1corr3 = 2)
         and S.pp001imp > 0
         AND B.PGCOD = S.PGCOD
         AND B.SCMOD = S.AOMOD
         AND B.SCSUC = S.AOSUC
         AND B.SCMDA = S.AOMDA
         AND B.SCPAP = S.AOPAP
         AND B.SCCTA = S.AOCTA
         AND B.SCOPER = S.AOOPER
         AND B.SCSBOP = S.AOSBOP
         AND B.SCTOPE = S.AOTOPE
         AND T.XWFEMPRESA = B.PGCOD
         AND T.XWFSUCURSAL = B.SCSUC
         AND T.XWFMODULO = B.SCMOD
         AND T.XWFMONEDA = B.SCMDA
         AND T.XWFPAPEL = B.SCPAP
         AND T.XWFCUENTA =  B.SCCTA
         AND T.XWFOPERACION = B.SCOPER
         AND T.XWFSUBOPE = B.SCSBOP
         AND T.XWFTIPOPE = B.SCTOPE
         AND T.XWFCAR3 = '1'
         AND Q.JAQM251PGC = T.XWFEMPRESA
         AND Q.JAQM251MOD = T.XWFMODULO
         AND Q.JAQM251SUC = T.XWFSUCURSAL
         AND Q.JAQM251MDA = T.XWFMONEDA
         AND Q.JAQM251PAP = T.XWFPAPEL
         AND Q.JAQM251CTA = T.XWFCUENTA
         AND Q.JAQM251OPE = T.XWFOPERACION
         AND Q.JAQM251SBO = T.XWFSUBOPE
         AND Q.JAQM251TOP = T.XWFTIPOPE
         AND Q.JAQM251FEC < A.AOFVAL
         AND F6.PGCOD = Q.JAQM251PGC
         AND F6.PPMOD = Q.JAQM251MOD
         AND F6.PPSUC = Q.JAQM251SUC
         AND F6.PPMDA = Q.JAQM251MDA
         AND F6.pppap = Q.JAQM251PAP
         AND F6.PPCTA = Q.JAQM251CTA
         AND F6.PPOPER = Q.JAQM251OPE
         AND F6.PPSBOP = Q.JAQM251SBO
         AND F6.PPTOPE = Q.JAQM251TOP
         AND F6.PPFPAG = (SELECT MIN(PPFPAG)
                           FROM  FSD611
                           WHERE PGCOD = F6.PGCOD
                             AND PPMOD = F6.PPMOD
                             AND PPSUC = F6.PPSUC
                             AND PPMDA = F6.PPMDA
                             AND pppap = F6.PPPAP
                             AND PPCTA = F6.PPCTA
                             AND PPOPER = F6.PPOPER
                             AND PPSBOP = F6.PPSBOP
                             AND PPTOPE = F6.PPTOPE)
         AND F.CTNRO = F6.PPCTA
         AND F.CTTFIR = 'T'
         AND F.TTCOD = 1
         AND P.PFPAIS = F.PEPAIS
         AND P.PFTDOC = F.PETDOC
         AND P.PFNDOC = F.PENDOC
         AND D.SNGC13PAIS = P.PFPAIS
         AND D.SNGC13TDOC = P.PFTDOC
         AND D.SNGC13NDOC = P.PFNDOC
         AND D.DOCOD = 1
         AND D.SNGC13EST = 'H')
         select seq_jaqz556.nextval,
                        item,
                        plan_seguro,
                        patcliente,
                        matcliente,
                        nombrecliente,
                        idc,
                        tip_idc,
                        email,
                        estadocivil,
                        sexo,
                        fecha_nac,
                        telefono,
                        ocupacion,
                        ubigeo_cliente,
                        direccion,
                        producto,
                        codigo_sucursal,
                        funcionario,
                        estado,
                        nro_credito,
                        moneda_cuenta,
                        fecha_cancelacion,
                        fecha_desembolso,
                        flag,
                        jaqz556tipo,
                        cred_falt,
                        importe_credito,
                        prima_mensual,
                        hora_desembolso,
                        fecha_afiliacion,
                        fecha_desafiliacion,
                        agencia_desafiliacion,
                        JAQZ556AU5,
                        JAQZ556AU8,
                        JAQZ556AU1  FROM  DATA;
     commit;
    --CANTIDAD NUEVOS PLAN_IV  + FAMILIA SEGURA
--    insert into repsegvidd (descripcion,total) values ('5- NUEVOS PLAN_IV  + FAMILIA SEGURA', (select count(*) from JAQZ556));
    insert into JAQZ557 (descripcion,total) values ('5- NUEVOS PLAN_IV  + FAMILIA SEGURA', (select count(*) from JAQZ556 WHERE JAQZ556TIPO = 5));
    commit;
    EXCEPTION
    WHEN OTHERS THEN
      err_code := SQLCODE;
      err_msg := SUBSTR(SQLERRM, 1, 200)||' '||'JAQZ556TIPO'||' '|| '5';

       INSERT INTO JAQZ557LOG (jaqz557ecod  , jaqz557emsg,jaqz557fecha   )
      VALUES (err_code, err_msg, fecha);
      commit;
     END;
    --**********************************************************************

    --(2C): Insertar afiliaciones despues de desembolso seguro vida  PLAN IV
    BEGIN
    insert /* +APPEND */ into JAQZ556 (jaqz556COD,
                        item,
                        plan_seguro,
                        patcliente,
                        matcliente,
                        nombrecliente,
                        idc,
                        tip_idc,
                        email,
                        estadocivil,
                        sexo,
                        fecha_nac,
                        telefono,
                        ocupacion,
                        ubigeo_cliente,
                        direccion,
                        producto,
                        codigo_sucursal,
                        funcionario,
                        estado,
                        nro_credito,
                        moneda_cuenta,
                        fecha_cancelacion,
                        fecha_desembolso,
                        flag,
                        jaqz556tipo,
                        cred_falt,
                        importe_credito,
                        prima_mensual,
                        hora_desembolso,
                        fecha_afiliacion,
                        fecha_desafiliacion,
                        agencia_desafiliacion,
                        JAQZ556AU5,
                        JAQZ556AU8,
                        JAQZ556AU1) WITH DATA AS
         (SELECT  /*+PARALLEL(A,4,1)(S,4,1)(B,4,1)(T,4,1)(Q,4,1)(F6,4,1)(F,4,1)(P,4,1)(D,4,1)*/
        DISTINCT '1' ITEM,
         DECODE(s.sgcod,124,5, 126,5,127,5,125,6,128,6,129,6,4) PLAN_SEGURO, ---4  PLAN_SEGURO,
         NVL(SUBSTR(P.PFAPE1, 1, 30),'-') PATCLIENTE,                         --APEPAT
         NVL(SUBSTR(P.PFAPE2, 1, 30),'-') MATCLIENTE,                         --APEMAT
         SUBSTR(trim(P.PFNOM1) || ' ' || trim(P.PFNOM2), 1, 30) NOMBRECLIENTE, --NOM1
         SUBSTR(F.PENDOC, 1, 11) IDC,                                  --NUMDOC
         SUBSTR(F.PETDOC, 1, 3) TIP_IDC,                                --TIPO
         SUBSTR(FN_MAIL(F.CTNRO), 1, 50) EMAIL,                      --MAIL
         SUBSTR((SELECT ECNOM FROM FST009 WHERE ECCOD = P.PFECIV), 1, 20) ESTADOCIVIL, --ESTADOCIVIL
         SUBSTR(P.PFCANT, 1, 1) SEXO,                                --SEXO
         TO_CHAR(P.PFFNAC, 'DD/MM/YYYY') FECHA_NAC,                  --FECNAC
         SUBSTR(FN_TELCLIE(TRIM(F.PENDOC)), 1, 50) TELEFONO,         --FONO
          (select SUBSTR(TRIM(sngc07dsc),1,50)
              from SNGC60 f1,
                   sngc07 f7
             where f1.SNGC60Pais = P.PFPAIS
               and f1.SNGC60Tdoc = P.PFTDOC
               and f1.SNGC60Ndoc = P.PFNDOC
               and f1.sngc60corr = (select max(sngc60corr)from SNGC60  where SNGC60Pais = P.PFPAIS  and SNGC60Tdoc = P.PFTDOC and SNGC60Ndoc = P.PFNDOC )
               and f7.sngc07cod = f1.sngc60ocup) OCUPACION, --OCUPACION
         SUBSTR(D.SNGC13UGEO, 1, 8) UBIGEO_CLIENTE,                  --UBIGEO
         SUBSTR(D.SNGC13DIR, 1, 100) DIRECCION,                      --DIRECCION
         '0004' PRODUCTO,
         SUBSTR(A.AOSUC, 1, 3) codigo_sucursal,                               --AGENCIACOD
         CASE
           WHEN Q.JAQM251UCA = '          ' THEN
                FN_ANALISTA_CREDITO(A.AOMOD, A.AOSUC, A.AOMDA, A.AOPAP, A.AOCTA, A.AOOPER, A.AOSBOP, A.AOTOPE)
           ELSE fn_usu_captador(q.jaqm251cta, q.jaqm251ope, q.JAQM251PGC, q.JAQM251MOD, q.JAQM251SUC, q.JAQM251MDA, q.JAQM251PAP,
                                q.JAQM251SBO, q.JAQM251TOP)
         END FUNCIONARIO,
         SUBSTR((SELECT T.CENOM FROM FST026 T WHERE T.CECOD = A.AOSTAT), 1, 1) ESTADO, --ESTADO_CREDITO
         SUBSTR(LPAD(A.AOCTA, 9, '0') || LPAD(A.AOMOD, 3, '0') || LPAD(A.AOMDA, 3, '0') || LPAD(A.AOOPER, 9, '0') ||
                LPAD(A.AOTOPE, 3, '0'), 1, 30) NRO_CREDITO,          --NRO_CTA
         DECODE(A.AOMDA, '0', '001', '002') MONEDA_CUENTA,           --MONEDA
         ' ' FECHA_CANCELACION,
         TO_CHAR(A.AOFVAL, 'DD/MM/YYYY') FECHA_DESEMBOLSO,       --FECHA_AFILIACION,
         0 FLAG,
         6 JAQZ556TIPO,
         Case
         when A.AOFVAL > q.jaqm251fec then 1
         when A.AOFVAL < q.jaqm251fec then 1
         when A.AOFVAL = q.jaqm251fec then 0
         end  cred_falt,
         replace(to_char(A.AOIMP),',','.') importe_credito,
         replace(to_char(s.pp001imp),',','.') prima_mensual,
          (select substr(h1.hhora,1,6) from fsh015 h1,fsh016 h2 where h1.pgcod = h2.pgcod
              and h1.hcmod = h2.hcmod and h1.hsucor = h2.hsucor and h1.htran = h2.htran and h1.hnrel = h2.hnrel
              and h1.hfcon= P_FECHA and h2.hcmod =30 and h2.htran =951 and h2.hcord =10and h2.hmodul = a.AOMOD
              and h2.hsucor = a.AOSUC and h2.hmda = a.AOMDA and h2.hpap = 0 and h2.hcta = a.AOCTA and h2.hoper = a.AOOPER
              and h2.hsubop = a.AOSBOP and h2.htoper = a.AOTOPE) hora_desembolso,
          TO_CHAR(A.AOFVAL,'DD/MM/YYYY') fecha_afiliacion,--sma 22102018 q.jaqm251fec
          (select decode(Max(jaqy782fchdes),null,p_fecha) from jaqy782 where jaqy782pgc = a.PGCOD and jaqy782mod = a.AOMOD and jaqy782suc = a.AOSUC and  jaqy782mda = a.AOMDA and jaqy782pap= a.AOPAP
              and jaqy782cta = a.AOCTA and jaqy782ope= a.AOOPER and jaqy782sbo = a.AOSBOP and jaqy782top = a.AOTOPE and jaqy782sgc = s.sgcod  and jaqy782est ='D') fecha_desafiliacion,
           0 agencia_desafiliacion,
           P_USUARIO JAQZ556AU5,
          (select pgfape from fst017 where pgcod=1) JAQZ556AU8,
          s.sgcod JAQZ556AU1
    FROM FSD010 A, --SALDOS
         FPP001 S,  --SEGUROS
         FSD011 B, --CRE. VIG.
         XWF700 T, --INSTANCIA
         jaqm251 Q,
         FSD611 F6  , --TABLA SEGUROS DESPUES DE DESEMBOLSO
         FSR008 F, --CUENTA DOCUMENTO
         FSD002 P, --PERS ESTADO CIVIL
         SNGC13 D
   WHERE /*A.PGCOD = 1
     AND A.AOFVAL = P_FECHA--'19/06/2017'--TO_DATE('&DDMMRRRR', 'DDMMYYYY')
     AND*/ S.PGCOD = A.PGCOD
     AND S.AOMOD = A.AOMOD
     AND S.AOSUC = A.AOSUC
     AND S.AOMDA = A.AOMDA
     AND S.AOPAP = A.AOPAP
     AND S.AOCTA = A.AOCTA
     AND S.AOOPER = A.AOOPER
     AND S.AOSBOP = A.AOSBOP
     AND S.AOTOPE = A.AOTOPE
     AND S.SGCOD in (select tp1nro3
                       from fst198
                      where tp1cod = 1
                        and tp1cod1 = 10898 --for update
                        and tp1corr1 = 18
                        and tp1corr3=1
                        and tp1nro1 =1)---(120,121,122,124,125)sma.08032019
     and S.pp001imp > 0
     AND B.PGCOD = S.PGCOD
     AND B.SCMOD = S.AOMOD
     AND B.SCSUC = S.AOSUC
     AND B.SCMDA = S.AOMDA
     AND B.SCPAP = S.AOPAP
     AND B.SCCTA = S.AOCTA
     AND B.SCOPER = S.AOOPER
     AND B.SCSBOP = S.AOSBOP
     AND B.SCTOPE = S.AOTOPE
     AND T.XWFEMPRESA = B.PGCOD
     AND T.XWFSUCURSAL = B.SCSUC
     AND T.XWFMODULO = B.SCMOD
     AND T.XWFMONEDA = B.SCMDA
     AND T.XWFPAPEL = B.SCPAP
     AND T.XWFCUENTA =  B.SCCTA
     AND T.XWFOPERACION = B.SCOPER
     AND T.XWFSUBOPE = B.SCSBOP
     AND T.XWFTIPOPE = B.SCTOPE
     AND T.XWFCAR3 = '1'
     AND Q.JAQM251PGC = T.XWFEMPRESA
     AND Q.JAQM251MOD = T.XWFMODULO
     AND Q.JAQM251SUC = T.XWFSUCURSAL
     AND Q.JAQM251MDA = T.XWFMONEDA
     AND Q.JAQM251PAP = T.XWFPAPEL
     AND Q.JAQM251CTA = T.XWFCUENTA
     AND Q.JAQM251OPE = T.XWFOPERACION
     AND Q.JAQM251SBO = T.XWFSUBOPE
     AND Q.JAQM251TOP = T.XWFTIPOPE
     AND Q.JAQM251FEC = P_FECHA
     AND Q.JAQM251FEC >= A.AOFVAL
     AND F6.PGCOD = Q.JAQM251PGC
     AND F6.PPMOD = Q.JAQM251MOD
     AND F6.PPSUC = Q.JAQM251SUC
     AND F6.PPMDA = Q.JAQM251MDA
     AND F6.pppap = Q.JAQM251PAP
     AND F6.PPCTA = Q.JAQM251CTA
     AND F6.PPOPER = Q.JAQM251OPE
     AND F6.PPSBOP = Q.JAQM251SBO
     AND F6.PPTOPE = Q.JAQM251TOP
     AND F6.PPFPAG = (SELECT MIN(PPFPAG)
                       FROM  FSD611
                       WHERE PGCOD = F6.PGCOD
                         AND PPMOD = F6.PPMOD
                         AND PPSUC = F6.PPSUC
                         AND PPMDA = F6.PPMDA
                         AND pppap = F6.PPPAP
                         AND PPCTA = F6.PPCTA
                         AND PPOPER = F6.PPOPER
                         AND PPSBOP = F6.PPSBOP
                         AND PPTOPE = F6.PPTOPE)
     AND F.CTNRO = F6.PPCTA---Q.JAQM251CTA
     AND F.CTTFIR = 'T'
     AND F.TTCOD = 1
     AND P.PFPAIS = F.PEPAIS
     AND P.PFNDOC = F.PENDOC
     AND P.PFTDOC = F.PETDOC
     AND D.SNGC13PAIS = P.PFPAIS
     AND D.SNGC13TDOC = P.PFTDOC
     AND D.SNGC13NDOC = P.PFNDOC
     AND D.DOCOD = 1
     AND D.SNGC13EST = 'H')
     SELECT SEQ_jaqz556.nextval,
            item,
            plan_seguro,
            patcliente,
            matcliente,
            nombrecliente,
            idc,
            tip_idc,
            email,
            estadocivil,
            sexo,
            fecha_nac,
            telefono,
            ocupacion,
            ubigeo_cliente,
            direccion,
            producto,
            codigo_sucursal,
            funcionario,
            estado,
            nro_credito,
            moneda_cuenta,
            fecha_cancelacion,
            fecha_desembolso,
            flag,
            jaqz556tipo,
            cred_falt,
            importe_credito,
            prima_mensual,
            hora_desembolso,
            fecha_afiliacion,
            fecha_desafiliacion,
            agencia_desafiliacion,
            JAQZ556AU5,
            JAQZ556AU8,
            JAQZ556AU1 FROM DATA;
     commit;
    --AFILIACIONES DESPUES DE DESEMBOLSO PLAN_IV
--    insert into repsegvidd (descripcion,total) values ('6- AFILIACIONES DESPUES DE DESEMBOLSO PLAN_IV', (select count(*) from JAQZ556));
    insert into JAQZ557 (descripcion,total) values ('6- AFILIACIONES DESPUES DE DESEMBOLSO PLAN_IV', (select count(*) from JAQZ556 WHERE JAQZ556TIPO = 6));
    commit;
    EXCEPTION
    WHEN OTHERS THEN
      err_code := SQLCODE;
      err_msg := SUBSTR(SQLERRM, 1, 200)||' '||'JAQZ556TIPO'||' '|| '6';

       INSERT INTO JAQZ557LOG (jaqz557ecod  , jaqz557emsg,jaqz557fecha   )
      VALUES (err_code, err_msg, fecha);
      commit;
    END;
    --***********************************************************************
    --(2D): Insertar afiliaciones despues de desembolso familia segura
    BEGIN
     insert  /* +APPEND */ into JAQZ556(jaqz556cod ,
                          item,
                          plan_seguro,
                          patcliente,
                          matcliente,
                          nombrecliente,
                          idc,
                          tip_idc,
                          email,
                          estadocivil,
                          sexo,
                          fecha_nac,
                          telefono,
                          ocupacion,
                          ubigeo_cliente,
                          direccion,
                          producto,
                          codigo_sucursal,
                          funcionario,
                          estado,
                          nro_credito,
                          moneda_cuenta,
                          fecha_cancelacion,
                          fecha_desembolso,
                          flag,
                          jaqz556tipo,
                          cred_falt,
                          importe_credito,
                          prima_mensual,
                          hora_desembolso,
                          fecha_afiliacion,
                          fecha_desafiliacion,
                          agencia_desafiliacion,
                          JAQZ556AU5,
                          JAQZ556AU8,
                          JAQZ556AU1 ) WITH DATA AS
     (SELECT /*+PARALLEL(A,4,1)(S,4,1)(B,4,1)(T,4,1)(Q,4,1)(F6,4,1)(F,4,1)(P,4,1)(D,4,1)*/
           DISTINCT '1' ITEM,
           7 PLAN_SEGURO, --adicion nuevo codigo de seguro
           SUBSTR(P.PFAPE1, 1, 30) PATCLIENTE,                         --APEPAT
           SUBSTR(P.PFAPE2, 1, 30) MATCLIENTE,                         --APEMAT
           SUBSTR(TRIM(P.PFNOM1) || ' ' || TRIM(P.PFNOM2), 1, 30) NOMBRECLIENTE, --NOM1
           SUBSTR(F.PENDOC, 1, 11) IDC,                                --NUMDOC
           SUBSTR(F.PETDOC, 1, 3) TIP_IDC,                             --TIPO
           SUBSTR(FN_MAIL(F.CTNRO), 1, 50) EMAIL,                      --MAIL
           SUBSTR((SELECT ECNOM FROM FST009 WHERE ECCOD = P.PFECIV), 1, 20) ESTADOCIVIL, --ESTADOCIVIL
           SUBSTR(P.PFCANT, 1, 1) SEXO,                                --SEXO
           TO_CHAR(P.PFFNAC, 'DD/MM/YYYY') FECHA_NAC,                  --FECNAC
           SUBSTR(FN_TELCLIE(TRIM(F.PENDOC)), 1, 50) TELEFONO,         --FONO
           (select SUBSTR(TRIM(sngc07dsc),1,50)
                    from SNGC60 f1,
                         sngc07 f7
                   where f1.SNGC60Pais = P.PFPAIS
                     and f1.SNGC60Tdoc = P.PFTDOC
                     and f1.SNGC60Ndoc = P.PFNDOC
                     and f1.sngc60corr = (select max(sngc60corr)from SNGC60  where SNGC60Pais = P.PFPAIS  and SNGC60Tdoc = P.PFTDOC and SNGC60Ndoc = P.PFNDOC )
                     and f7.sngc07cod = f1.sngc60ocup) OCUPACION,      --OCUPACION
           SUBSTR(D.SNGC13UGEO, 1, 8) UBIGEO_CLIENTE,                  --UBIGEO
           SUBSTR(D.SNGC13DIR, 1, 100) DIRECCION,                      --DIRECCION
           '0011' PRODUCTO,
           SUBSTR(A.AOSUC, 1, 3) codigo_sucursal,                               --AGENCIACOD
           CASE
               WHEN Q.JAQM251UCA = '          ' THEN
                    FN_ANALISTA_CREDITO(A.AOMOD, A.AOSUC, A.AOMDA, A.AOPAP, A.AOCTA, A.AOOPER, A.AOSBOP, A.AOTOPE)
               ELSE fn_usu_captador(q.jaqm251cta, q.jaqm251ope, q.JAQM251PGC, q.JAQM251MOD, q.JAQM251SUC, q.JAQM251MDA, q.JAQM251PAP,
                    q.JAQM251SBO, q.JAQM251TOP)
           END FUNCIONARIO,
           SUBSTR((SELECT T.CENOM FROM FST026 T WHERE T.CECOD = A.AOSTAT), 1, 1) ESTADO, --ESTADO_CREDITO
           SUBSTR(LPAD(A.AOCTA, 9, '0') || LPAD(A.AOMOD, 3, '0') || LPAD(A.AOMDA, 3, '0') || LPAD(A.AOOPER, 9, '0') ||
                  LPAD(A.AOTOPE, 3, '0'), 1, 30) NRO_CREDITO, --NRO_CTA
           DECODE(A.AOMDA, '0', '001', '002') MONEDA_CUENTA, --MONEDA
           ' ' FECHA_CANCELACION,
           TO_CHAR(a.aofval, 'DD/MM/YYYY') FECHA_DESEMBOLSO, --FECHA_AFILIACION,
           0 FLAG,
           7 JAQZ556TIPO,
           Case
           when A.AOFVAL > q.jaqm251fec then 1
           when A.AOFVAL < q.jaqm251fec then 1
           when A.AOFVAL = q.jaqm251fec then 0
           end  cred_falt,
            replace(to_char(A.AOIMP),',','.') importe_credito,
            replace(to_char(s.pp001imp),',','.') prima_mensual,
            (select substr(h1.hhora,1,6) from fsh015 h1,fsh016 h2 where h1.pgcod = h2.pgcod
                and h1.hcmod = h2.hcmod and h1.hsucor = h2.hsucor and h1.htran = h2.htran and h1.hnrel = h2.hnrel
                and h1.hfcon= P_FECHA and h2.hcmod =30 and h2.htran =951 and h2.hcord =10and h2.hmodul = a.AOMOD
                and h2.hsucor = a.AOSUC and h2.hmda = a.AOMDA and h2.hpap = 0 and h2.hcta = a.AOCTA and h2.hoper = a.AOOPER
                and h2.hsubop = a.AOSBOP and h2.htoper = a.AOTOPE) hora_desembolso,
            TO_CHAR(A.AOFVAL,'DD/MM/YYYY') fecha_afiliacion,--sma 22102018 q.jaqm251fec
            (select decode(Max(jaqy782fchdes),null,p_fecha) from jaqy782 where jaqy782pgc = a.PGCOD and jaqy782mod = a.AOMOD and jaqy782suc = a.AOSUC and  jaqy782mda = a.AOMDA and jaqy782pap= a.AOPAP
                and jaqy782cta = a.AOCTA and jaqy782ope= a.AOOPER and jaqy782sbo = a.AOSBOP and jaqy782top = a.AOTOPE and jaqy782sgc = s.sgcod  and jaqy782est ='D') fecha_desafiliacion,
             0 agencia_desafiliacion,
             P_USUARIO JAQZ556AU5,
             (select pgfape from fst017 where pgcod=1) JAQZ556AU8,
             s.sgcod JAQZ556AU1
      FROM FSD010 A, --SALDOS
           FPP001 S,  --SEGUROS
           FSD011 B, --CRE. VIG.
           XWF700 T, --INSTANCIA
           jaqm251 Q,
           FSD611 F6  , --TABLA SEGUROS DESPUES DE DESEMBOLSO
           FSR008 F, --CUENTA DOCUMENTO
           FSD002 P, --PERS ESTADO CIVIL
           SNGC13 D
     WHERE S.PGCOD = A.PGCOD
       AND S.AOMOD = A.AOMOD
       AND S.AOSUC = A.AOSUC
       AND S.AOMDA = A.AOMDA
       AND S.AOPAP = A.AOPAP
       AND S.AOCTA = A.AOCTA
       AND S.AOOPER = A.AOOPER
       AND S.AOSBOP = A.AOSBOP
       AND S.AOTOPE = A.AOTOPE
       AND S.SGCOD in (select tp1nro3
                         from fst198
                        Where Tp1cod    = 1
                          and Tp1cod1   = 10898
                          and Tp1corr1  = 18
                          and Tp1corr3 = 2)
       and S.pp001imp > 0
       AND B.PGCOD = S.PGCOD
       AND B.SCMOD = S.AOMOD
       AND B.SCSUC = S.AOSUC
       AND B.SCMDA = S.AOMDA
       AND B.SCPAP = S.AOPAP
       AND B.SCCTA = S.AOCTA
       AND B.SCOPER = S.AOOPER
       AND B.SCSBOP = S.AOSBOP
       AND B.SCTOPE = S.AOTOPE
       AND T.XWFEMPRESA = B.PGCOD
       AND T.XWFSUCURSAL = B.SCSUC
       AND T.XWFMODULO = B.SCMOD
       AND T.XWFMONEDA = B.SCMDA
       AND T.XWFPAPEL = B.SCPAP
       AND T.XWFCUENTA =  B.SCCTA
       AND T.XWFOPERACION = B.SCOPER
       AND T.XWFSUBOPE = B.SCSBOP
       AND T.XWFTIPOPE = B.SCTOPE
       AND T.XWFCAR3 = '1'
       AND Q.JAQM251PGC = T.XWFEMPRESA
       AND Q.JAQM251MOD = T.XWFMODULO
       AND Q.JAQM251SUC = T.XWFSUCURSAL
       AND Q.JAQM251MDA = T.XWFMONEDA
       AND Q.JAQM251PAP = T.XWFPAPEL
       AND Q.JAQM251CTA = T.XWFCUENTA
       AND Q.JAQM251OPE = T.XWFOPERACION
       AND Q.JAQM251SBO = T.XWFSUBOPE
       AND Q.JAQM251TOP = T.XWFTIPOPE
       AND Q.JAQM251FEC = P_FECHA
       AND Q.JAQM251FEC >= A.AOFVAL
       AND F6.PGCOD = Q.JAQM251PGC
       AND F6.PPMOD = Q.JAQM251MOD
       AND F6.PPSUC = Q.JAQM251SUC
       AND F6.PPMDA = Q.JAQM251MDA
       AND F6.pppap = Q.JAQM251PAP
       AND F6.PPCTA = Q.JAQM251CTA
       AND F6.PPOPER = Q.JAQM251OPE
       AND F6.PPSBOP = Q.JAQM251SBO
       AND F6.PPTOPE = Q.JAQM251TOP
       AND F6.PPFPAG = (SELECT MIN(PPFPAG)
                         FROM  FSD611
                         WHERE PGCOD = F6.PGCOD
                           AND PPMOD = F6.PPMOD
                           AND PPSUC = F6.PPSUC
                           AND PPMDA = F6.PPMDA
                           AND pppap = F6.PPPAP
                           AND PPCTA = F6.PPCTA
                           AND PPOPER = F6.PPOPER
                           AND PPSBOP = F6.PPSBOP
                           AND PPTOPE = F6.PPTOPE)
       AND F.CTNRO = F6.PPCTA---Q.JAQM251CTA
       AND F.CTTFIR = 'T'
       AND F.TTCOD = 1
       AND P.PFPAIS = F.PEPAIS
       AND P.PFNDOC = F.PENDOC
       AND P.PFTDOC = F.PETDOC
       AND D.SNGC13PAIS = P.PFPAIS
       AND D.SNGC13TDOC = P.PFTDOC
       AND D.SNGC13NDOC = P.PFNDOC
       AND D.DOCOD = 1
       AND D.SNGC13EST = 'H')
       SELECT SEQ_jaqz556.Nextval,
            item,
            plan_seguro,
            patcliente,
            matcliente,
            nombrecliente,
            idc,
            tip_idc,
            email,
            estadocivil,
            sexo,
            fecha_nac,
            telefono,
            ocupacion,
            ubigeo_cliente,
            direccion,
            producto,
            codigo_sucursal,
            funcionario,
            estado,
            nro_credito,
            moneda_cuenta,
            fecha_cancelacion,
            fecha_desembolso,
            flag,
            jaqz556tipo,
            cred_falt,
            importe_credito,
            prima_mensual,
            hora_desembolso,
            fecha_afiliacion,
            fecha_desafiliacion,
            agencia_desafiliacion,
            JAQZ556AU5,
            JAQZ556AU8,
            JAQZ556AU1 FROM DATA;
     commit;
    --AFILIACIONES DESPUES DE DESEMBOLSO PLAN_IV + FAMILIA SEGURA
   -- insert into repsegvidd (descripcion,total)  values ('7- AFILIACIONES DESPUES DE DESEMBOLSO PLAN_IV + FAMILIA SEGURA', (select count(*) from JAQZ556 where PRODUCTO= '0005' ));
    insert into JAQZ557 (descripcion,total)  values ('7- AFILIACIONES DESPUES DE DESEMBOLSO PLAN_IV + FAMILIA SEGURA', (select count(*) from JAQZ556 where JAQZ556TIPO = 7));
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
      err_code := SQLCODE;
      err_msg := SUBSTR(SQLERRM, 1, 200)||' '||'JAQZ556TIPO'||' '|| '7';


      INSERT INTO JAQZ557LOG (jaqz557ecod  , jaqz557emsg,jaqz557fecha   )
      VALUES (err_code, err_msg, fecha);
      commit;
    END;
    --------------------------------------------------------------------
  --(2E): Insertar afiliaciones del nuevo ABM
    /*   delete  JAQZ568;--- tmpsegabm ;
       commit;
       insert into JAQZ568(jaqz568credito, jaqy782pgc, jaqy782mod, jaqy782suc, jaqy782mda, jaqy782pap, jaqy782cta, jaqy782ope, jaqy782sbo, jaqy782top, jaqy782sgc,
        jaqy782fchdes, jaqy782fchsis, jaqy782hrasis,jaqy782upr, jaqy782est, jaqy782uca  )
       select substr(lpad(tp.jaqy782cta, 9, '0') ||
                     lpad(tp.jaqy782mod, 3, '0') ||
                     lpad(tp.jaqy782mda, 3, '0') ||
                     lpad(tp.jaqy782ope, 9, '0') ||
                     lpad(tp.jaqy782top, 3, '0'),
                     1,
                     30) credito,
              tp.*
         from jaqy782 tp,
              (select dp.jaqy782pgc,
                      dp.jaqy782mod,
                      dp.jaqy782suc,
                      dp.jaqy782mda,
                      dp.jaqy782pap,
                      dp.jaqy782cta,
                      dp.jaqy782ope,
                      dp.jaqy782sbo,
                      dp.jaqy782top,
                      max(dp.jaqy782hrasis) jaqy782hrasis
                 from jaqy782 dp
                where dp.jaqy782fchsis = P_FECHA --to_date('&DDMMRRRR', 'DDMMYYYY')
                  and dp.jaqy782est = 'A'
                group by dp.jaqy782pgc,
                         dp.jaqy782mod,
                         dp.jaqy782suc,
                         dp.jaqy782mda,
                         dp.jaqy782pap,
                         dp.jaqy782cta,
                         dp.jaqy782ope,
                         dp.jaqy782sbo,
                         dp.jaqy782top) dp
        where dp.jaqy782pgc = tp.jaqy782pgc
          and dp.jaqy782mod = tp.jaqy782mod
          and dp.jaqy782suc = tp.jaqy782suc
          and dp.jaqy782mda = tp.jaqy782mda
          and dp.jaqy782pap = tp.jaqy782pap
          and dp.jaqy782cta = tp.jaqy782cta
          and dp.jaqy782ope = tp.jaqy782ope
          and dp.jaqy782sbo = tp.jaqy782sbo
          and dp.jaqy782top = tp.jaqy782top
          and dp.jaqy782hrasis = tp.jaqy782hrasis;
          commit;
       delete JAQZ568 a
        where a.JAQZ568credito in
              (select b.credito
                 from JAQZ568 a,
                      (select substr(lpad(tp.jaqy782cta, 9, '0') ||
                                     lpad(tp.jaqy782mod, 3, '0') ||
                                     lpad(tp.jaqy782mda, 3, '0') ||
                                     lpad(tp.jaqy782ope, 9, '0') ||
                                     lpad(tp.jaqy782top, 3, '0'),
                                     1,
                                     30) credito,
                              tp.*
                         from jaqy782 tp,
                              (select dp.jaqy782pgc,
                                      dp.jaqy782mod,
                                      dp.jaqy782suc,
                                      dp.jaqy782mda,
                                      dp.jaqy782pap,
                                      dp.jaqy782cta,
                                      dp.jaqy782ope,
                                      dp.jaqy782sbo,
                                      dp.jaqy782top,
                                      max(dp.jaqy782hrasis) jaqy782hrasis
                                 from jaqy782 dp
                                where dp.jaqy782fchsis = P_FECHA --- to_date('DDMMRRRR', 'DDMMYYYY')
                                  and dp.jaqy782est = 'D'
                                group by dp.jaqy782pgc,
                                         dp.jaqy782mod,
                                         dp.jaqy782suc,
                                         dp.jaqy782mda,
                                         dp.jaqy782pap,
                                         dp.jaqy782cta,
                                         dp.jaqy782ope,
                                         dp.jaqy782sbo,
                                         dp.jaqy782top) dp
                        where dp.jaqy782pgc = tp.jaqy782pgc
                          and dp.jaqy782mod = tp.jaqy782mod
                          and dp.jaqy782suc = tp.jaqy782suc
                          and dp.jaqy782mda = tp.jaqy782mda
                          and dp.jaqy782pap = tp.jaqy782pap
                          and dp.jaqy782cta = tp.jaqy782cta
                          and dp.jaqy782ope = tp.jaqy782ope
                          and dp.jaqy782sbo = tp.jaqy782sbo
                          and dp.jaqy782top = tp.jaqy782top
                          and dp.jaqy782hrasis = tp.jaqy782hrasis) b
                where a.JAQZ568credito = b.credito
                  and b.jaqy782hrasis > a.jaqy782hrasis
                  and a.jaqy782fchsis = b.jaqy782fchsis);
       COMMIT;
       delete JAQZ568 a
        where a.JAQZ568credito in
              (select nro_creditoh from jaqz556h where jaqz556htipoh = 8);
        */
       ----------------------------------------------------------------------------------------
       BEGIN
       Insert  /* +APPEND */into JAQZ556(jaqz556cod ,
                          item,
                          plan_seguro,
                          patcliente,
                          matcliente,
                          nombrecliente,
                          idc,
                          tip_idc,
                          email,
                          estadocivil,
                          sexo,
                          fecha_nac,
                          telefono,
                          ocupacion,
                          ubigeo_cliente,
                          direccion,
                          producto,
                          codigo_sucursal,
                          funcionario,
                          estado,
                          nro_credito,
                          moneda_cuenta,
                          fecha_cancelacion,
                          fecha_desembolso,
                          flag,
                          jaqz556tipo,
                          cred_falt,
                          importe_credito,
                          prima_mensual,
                          hora_desembolso,
                          fecha_afiliacion,
                          fecha_desafiliacion,
                          agencia_desafiliacion,
                          JAQZ556AU5,
                          JAQZ556AU8,
                          JAQZ556AU1) WITH DATA AS
        (select /*+PARALLEL (a,4,1)(d10,4,1)(d611,4,1)(f,4,1)(p,4,1)(d,4,1)*/
                   DISTINCT '1' ITEM,
                   case when a.jaqy782sgc in (116, 117, 118) then 3
                        when a.jaqy782sgc in (120,121,122 ) then 4
                        when a.jaqy782sgc in (124,126,127) then 5
                        when a.jaqy782sgc in (125,128,129) then 6
                        when a.jaqy782sgc in (select tp1nro3
                                                from fst198
                                               where tp1cod = 1
                                                 and tp1cod1 = 10898
                                                 and tp1corr1 = 18
                                                 and tp1corr3 = 2 ) then 7
                   else 1
                   end PLAN_SEGURO,
                   substr(p.pfape1, 1, 30) PATCLIENTE,                         --APEPAT
                   substr(p.pfape2, 1, 30) MATCLIENTE,                         --APEMAT
                   substr(trim(p.pfnom1) || ' ' || trim(p.pfnom2), 1, 30) NOMBRECLIENTE, --NOM1
                   substr(f.pendoc, 1, 11) IDC,                                --NUMDOC
                   substr(f.petdoc, 1, 3) TIP_IDC,                             --TIPO
                   substr(fn_mail(f.ctnro), 1, 50) EMAIL,                      --MAIL
                   substr((select ecnom from fst009 where eccod = p.pfeciv), 1, 20) ESTADOCIVIL, --ESTADOCIVIL
                   substr(p.pfcant, 1, 1) SEXO,                                --SEXO
                   to_char(p.pffnac, 'DD/MM/YYYY') FECHA_NAC,                  --FECNAC
                   substr(fn_telclie(trim(f.pendoc)), 1, 50) TELEFONO,         --FONO
                  (select SUBSTR(TRIM(sngc07dsc),1,50)
                        from SNGC60 f1,
                             sngc07 f7
                       where f1.SNGC60Pais = P.PFPAIS
                         and f1.SNGC60Tdoc = P.PFTDOC
                         and f1.SNGC60Ndoc = P.PFNDOC
                         and f1.sngc60corr = (select max(sngc60corr)from SNGC60  where SNGC60Pais = P.PFPAIS  and SNGC60Tdoc = P.PFTDOC and SNGC60Ndoc = P.PFNDOC )
                         and f7.sngc07cod = f1.sngc60ocup) OCUPACION,      --OCUPACION
                   substr(d.sngc13ugeo, 1, 8) UBIGEO_CLIENTE,                  --UBIGEO
                   substr(d.sngc13dir, 1, 100) DIRECCION,                      --DIRECCION
                   case when a.jaqy782sgc in (116, 117, 118) then '0003'
                        when a.jaqy782sgc in (select tp1nro3
                                                 from fst198
                                                where tp1cod = 1
                                                  and tp1cod1 = 10898 --for update
                                                  and tp1corr1 = 18
                                                  and tp1corr3=1
                                                  and tp1nro1 =1)---(120,121,122,124,125)sma.08032019
                           then '0004'
                        when a.jaqy782sgc in (select tp1nro3
                                                from fst198
                                               where tp1cod = 1
                                                 and tp1cod1 = 10898
                                                 and tp1corr1 = 18
                                                 and tp1corr3 = 2 ) then '0011'
                   end  PRODUCTO,
                   substr(a.jaqy782suc, 1, 3) CODIGO_SUCURSAL,                 --AGENCIACOD
                   case when a.jaqy782uca = '          ' then a.jaqy782upr
                        when a.jaqy782uca is null then a.jaqy782upr
                        else a.jaqy782uca
                   end FUNCIONARIO,
                   substr((select est.cenom from fst026 est where est.cecod = d10.aostat), 1, 1)  ESTADO,        --estado_credito
                   substr(lpad(a.jaqy782cta, 9, '0') || lpad(a.jaqy782mod, 3, '0') || lpad(a.jaqy782mda, 3, '0') || lpad(a.jaqy782ope, 9, '0') ||
                          lpad(a.jaqy782top, 3, '0'), 1, 30) NRO_CREDITO,     --nro_cta
                   decode(a.jaqy782mda, '0', '001', '002') MONEDA_CUENTA,     --moneda
                   ' ' FECHA_CANCELACION,
                   to_char(a.jaqy782fchdes, 'dd/mm/yyyy') FECHA_DESEMBOLSO,   --fecha_desembolso_cred
                   1 flag,
                   8 JAQZ556TIPO,
                   Case
                   when a.jaqy782fchdes >  (select Max(jaqy782fchsis)from jaqy782 where jaqy782pgc = d10.PGCOD and jaqy782mod = d10.AOMOD and jaqy782suc = d10.AOSUC and  jaqy782mda = d10.AOMDA and jaqy782pap= d10.AOPAP
                      and jaqy782cta = d10.AOCTA and jaqy782ope= d10.AOOPER and jaqy782sbo = d10.AOSBOP and jaqy782top = d10.AOTOPE and jaqy782sgc = a.jaqy782sgc  and jaqy782est ='A') then 1
                   when a.jaqy782fchdes <  (select Max(jaqy782fchsis)from jaqy782 where jaqy782pgc = d10.PGCOD and jaqy782mod = d10.AOMOD and jaqy782suc = d10.AOSUC and  jaqy782mda = d10.AOMDA and jaqy782pap= d10.AOPAP
                      and jaqy782cta = d10.AOCTA and jaqy782ope= d10.AOOPER and jaqy782sbo = d10.AOSBOP and jaqy782top = d10.AOTOPE and jaqy782sgc = a.jaqy782sgc  and jaqy782est ='A') then 1
                   when a.jaqy782fchdes =  (select Max(jaqy782fchsis)from jaqy782 where jaqy782pgc = d10.PGCOD and jaqy782mod = d10.AOMOD and jaqy782suc = d10.AOSUC and  jaqy782mda = d10.AOMDA and jaqy782pap= d10.AOPAP
                      and jaqy782cta = d10.AOCTA and jaqy782ope= d10.AOOPER and jaqy782sbo = d10.AOSBOP and jaqy782top = d10.AOTOPE and jaqy782sgc = a.jaqy782sgc  and jaqy782est ='A') then 0
                   end  cred_falt,
                  replace(to_char(d10.AOIMP),',','.') importe_credito,
                  (select replace(to_char(pp001imp),',','.') from fpp001 where pgcod = 1 and aomod = a.jaqy782mod and aosuc = a.jaqy782suc and aomda = a.jaqy782mda
                      and aopap = a.jaqy782pap and aocta = a.jaqy782cta and aooper= a.jaqy782ope and aosbop = a.jaqy782sbo and aotope = a.jaqy782top
                      and sgcod = a.jaqy782sgc)prima_mensual,
                  (select substr(h1.hhora,1,6) from fsh015 h1,fsh016 h2 where h1.pgcod = h2.pgcod
                      and h1.hcmod = h2.hcmod and h1.hsucor = h2.hsucor and h1.htran = h2.htran and h1.hnrel = h2.hnrel
                      and h1.hfcon= P_FECHA and h2.hcmod =30 and h2.htran =951 and h2.hcord =10and h2.hmodul = d10.AOMOD
                      and h2.hsucor = d10.AOSUC and h2.hmda = d10.AOMDA and h2.hpap = 0 and h2.hcta = d10.AOCTA and h2.hoper = d10.AOOPER
                      and h2.hsubop = d10.AOSBOP and h2.htoper = d10.AOTOPE) hora_desembolso,
                  (select TO_CHAR(Max(jaqy782fchsis),'DD/MM/YYYY')  from jaqy782 where jaqy782pgc = d10.PGCOD and jaqy782mod = d10.AOMOD and jaqy782suc = d10.AOSUC and  jaqy782mda = d10.AOMDA and jaqy782pap= d10.AOPAP
                      and jaqy782cta = d10.AOCTA and jaqy782ope= d10.AOOPER and jaqy782sbo = d10.AOSBOP and jaqy782top = d10.AOTOPE and jaqy782sgc = a.jaqy782sgc  and jaqy782est ='A') fecha_afiliacion,
                  (select Max(jaqy782fchsis) from jaqy782 where jaqy782pgc = d10.PGCOD and jaqy782mod = d10.AOMOD and jaqy782suc = d10.AOSUC and  jaqy782mda = d10.AOMDA and jaqy782pap= d10.AOPAP
                      and jaqy782cta = d10.AOCTA and jaqy782ope= d10.AOOPER and jaqy782sbo = d10.AOSBOP and jaqy782top = d10.AOTOPE and jaqy782sgc = a.jaqy782sgc  and jaqy782est ='D') fecha_desafiliacion,
                   0 agencia_desafiliacion,
                   P_USUARIO JAQZ556AU5,
                   (select pgfape from fst017 where pgcod=1) JAQZ556AU8,
                   a.jaqy782sgc JAQZ556AU1
              from jaqy782 a,
                   fsd010 d10,
                   fpp001 fp,
                   fsd611 d611,
                   fsr008 f,
                   fsd002 p,
                   sngc13 d
             where a.jaqy782pgc = d10.pgcod
               and a.jaqy782mod = d10.aomod
               and a.jaqy782suc = d10.aosuc
               and a.jaqy782mda = d10.aomda
               and a.jaqy782pap = d10.aopap
               and a.jaqy782cta = d10.aocta
               and a.jaqy782ope = d10.aooper
               and a.jaqy782sbo = d10.aosbop
               and a.jaqy782top = d10.aotope
               and a.jaqy782fchsis = P_FECHA
               and a.jaqy782est = 'A'
               and a.jaqy782ctrl ='S'
               and fp.pgcod = a.jaqy782pgc
               and fp.aomod = a.jaqy782mod
               and fp.aosuc = a.jaqy782suc
               and fp.aomda = a.jaqy782mda
               and fp.aopap = a.jaqy782pap
               and fp.aocta = a.jaqy782cta
               and fp.aooper = a.jaqy782ope
               and fp.aosbop = a.jaqy782sbo
               and fp.aotope = a.jaqy782top
               and fp.sgcod  = a.jaqy782sgc
               and d611.pgcod = fp.pgcod
               and d611.ppmod = fp.aomod
               and d611.ppsuc = fp.aosuc
               and d611.ppmda = fp.aomda
               and d611.pppap = fp.aopap
               and d611.ppcta = fp.aocta
               and d611.ppoper = fp.aooper
               and d611.ppsbop = fp.aosbop
               and d611.pptope = fp.aotope
               and d611.ppfpag = (select min(ppfpag)from fsd611 where pgcod = d611.pgcod
                                                                   and ppmod = d611.ppmod
                                                                   and ppsuc = d611.ppsuc
                                                                   and ppmda = d611.ppmda
                                                                   and pppap = d611.pppap
                                                                   and ppcta = d611.ppcta
                                                                   and ppoper = d611.ppoper
                                                                   and ppsbop = d611.ppsbop
                                                                   and pptope = d611.pptope)
               and f.ctnro = d611.ppcta
               AND F.CTTFIR = 'T'
               AND F.TTCOD = 1
               AND P.PFPAIS = F.PEPAIS
               AND P.PFNDOC = F.PENDOC
               AND P.PFTDOC = F.PETDOC
               AND D.SNGC13PAIS = P.PFPAIS
               AND D.SNGC13TDOC = P.PFTDOC
               AND D.SNGC13NDOC = P.PFNDOC
               AND D.DOCOD = 1
               AND D.SNGC13EST = 'H')
               SELECT SEQ_jaqz556.Nextval,
                      item,
                      plan_seguro,
                      patcliente,
                      matcliente,
                      nombrecliente,
                      idc,
                      tip_idc,
                      email,
                      estadocivil,
                      sexo,
                      fecha_nac,
                      telefono,
                      ocupacion,
                      ubigeo_cliente,
                      direccion,
                      producto,
                      codigo_sucursal,
                      funcionario,
                      estado,
                      nro_credito,
                      moneda_cuenta,
                      fecha_cancelacion,
                      fecha_desembolso,
                      flag,
                      jaqz556tipo,
                      cred_falt,
                      importe_credito,
                      prima_mensual,
                      hora_desembolso,
                      fecha_afiliacion,
                      fecha_desafiliacion,
                      agencia_desafiliacion,
                      JAQZ556AU5,
                      JAQZ556AU8,
                      JAQZ556AU1 FROM DATA;
                     COMMIT;
            --(2F): Borra los registros antiguos y actualiza el estado flag a 0
          delete from JAQZ556 a
           where a.nro_credito in
                 (select b.nro_credito
                    from JAQZ556 b
                   where b.nro_credito in
                         (select c.nro_credito from JAQZ556 c where c.flag = 1)
                   group by b.nro_credito
                  having count(b.nro_credito) > 1)
             and a.flag = 0;

          update JAQZ556 a set a.flag=0 where a.flag=1;
          commit;

          --CANTIDAD CREDITOS CANCELADOS PLAN_III Y IV, CREDITOS NUEVOS PLAN_IV Y CREDITOS DEL ABM
          --   insert into repsegvidd (descripcion,total)
          --        values ('8- CREDITOS CANDELADOS PLAN_III y IV, NUEVOS PLAN_IV Y ABM', (select count(*) from JAQZ556));
          insert into JAQZ557 (descripcion,total)
                 values ('8- CREDITOS CANDELADOS PLAN_III y IV, NUEVOS PLAN_IV Y ABM', (select count(*) from JAQZ556 WHERE JAQZ556TIPO =8));
          COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          err_code := SQLCODE;
          err_msg := SUBSTR(SQLERRM, 1, 200)||' '||'JAQZ556TIPO'||' '|| '8';

           INSERT INTO JAQZ557LOG (jaqz557ecod  , jaqz557emsg,jaqz557fecha   )
           VALUES (err_code, err_msg, fecha);
          commit;
      END;
  ---------------------SMA 26012021------------------------------
    Begin
      FOR X IN resagados(fecha) LOOP
       begin
          select seq_jaqz556.nextval
            into secuencia
            from dual;
          dbms_output.put_line(x.cuenta ||' '|| x.operacion);
       insert into JAQZ556 (jaqz556cod,
                            item,
                            plan_seguro,
                            patcliente,
                            matcliente,
                            nombrecliente,
                            idc,
                            tip_idc,
                            email,
                            estadocivil,
                            sexo,
                            fecha_nac,
                            telefono,
                            ocupacion,
                            ubigeo_cliente,
                            direccion,
                            producto,
                            codigo_sucursal,
                            funcionario,
                            estado,
                            nro_credito,
                            moneda_cuenta,
                            fecha_cancelacion,
                            fecha_desembolso,
                            flag,
                            jaqz556tipo,
                            cred_falt,
                            importe_credito,
                            prima_mensual,
                            hora_desembolso,
                            fecha_afiliacion,
                            fecha_desafiliacion,
                            agencia_desafiliacion,
                            JAQZ556AU5,
                            JAQZ556AU8,
                            JAQZ556AU1,
                            jaqz556au9)
              SELECT   secuencia,
               '1' ITEM,
               DECODE(x.seguro,124,5, 126,5,127,5,125,6,128,6,129,6,4) PLAN_SEGURO,--- 4 PLAN_SEGURO,
               NVL(SUBSTR(P.PFAPE1, 1, 30),'-') PATCLIENTE,                         --APEPAT
               NVL(SUBSTR(P.PFAPE2, 1, 30),'-') MATCLIENTE,                         --APEMAT
               SUBSTR(trim(P.PFNOM1) || ' ' || trim(P.PFNOM2), 1, 30) NOMBRECLIENTE, --NOM1
               SUBSTR(x.DOC, 1, 11) IDC,                                  --NUMDOC
               SUBSTR(x.TDOC, 1, 3) TIP_IDC,                                --TIPO
    --           SUBSTR(FN_MAIL(x.cuenta), 1, 50) EMAIL,                      --MAIL
               ' ' EMAIL,                      --MAIL
               SUBSTR((SELECT ECNOM FROM FST009 WHERE ECCOD = P.PFECIV), 1, 20) ESTADOCIVIL, --ESTADOCIVIL
               SUBSTR(P.PFCANT, 1, 1) SEXO,                                --SEXO
               TO_CHAR(P.PFFNAC, 'DD/MM/YYYY') FECHA_NAC,                  --FECNAC
               (select jaql964tel from jaql964 where jaql964cta =x.cuenta and   jaql964ope= x.operacion) TELEFONO,         --FONO
                (select SUBSTR(TRIM(sngc07dsc),1,50)
                  from SNGC60 f1,
                       sngc07 f7
                 where f1.SNGC60Pais = P.PFPAIS
                   and f1.SNGC60Tdoc = P.PFTDOC
                   and f1.SNGC60Ndoc = P.PFNDOC
                   and f1.sngc60corr = (select max(sngc60corr)from SNGC60  where SNGC60Pais = P.PFPAIS  and SNGC60Tdoc = P.PFTDOC and SNGC60Ndoc = P.PFNDOC )
                   and f7.sngc07cod = f1.sngc60ocup) OCUPACION,           --OCUPACION
               SUBSTR(D.SNGC13UGEO, 1, 8) UBIGEO_CLIENTE,                  --UBIGEO
               SUBSTR(D.SNGC13DIR, 1, 100) DIRECCION,                      --DIRECCION
               '0004' PRODUCTO,
               SUBSTR(x.suc, 1, 3) codigo_sucursal,                      --AGENCIACOD
              --- (select jaql964usu from jaql964 where jaql964cta = x.cuenta and   jaql964ope = x.operacion) FUNCIONARIO,
               FN_ANALISTA_CREDITO(x.modu, x.SUC, x.MDA, x.PAP, x.cuenta, x.operacion, x.Sub, x.TOPE) FUNCIONARIO,
               SUBSTR((SELECT T.CENOM FROM FST026 T WHERE T.CECOD = x.STAdo), 1, 1) ESTADO, --ESTADO_CREDITO
               SUBSTR(LPAD(x.cuenta, 9, '0') || LPAD(x.modu, 3, '0') || LPAD(x.mda, 3, '0') || LPAD(x.operacion, 9, '0') ||
                      LPAD(x.TOPE, 3, '0'), 1, 30) NRO_CREDITO,          --NRO_CTA
               DECODE(x.MDA, '0', '001', '002') MONEDA_CUENTA,           --MONEDA
               ' ' FECHA_CANCELACION,
               TO_CHAR(x.FVAL, 'DD/MM/YYYY') FECHA_DESEMBOLSO,
               0 FLAG,
               4 jaqz556tipo,
               0 cred_falt,
               replace(to_char(x.importe),',','.') importe_credito,
               replace(to_char(x.prima),',','.') prima_mensual,
                (select substr(h1.hhora,1,6)
                   from fsh015 h1, fsh016 h2
                  where h1.pgcod = h2.pgcod
                    and h1.hcmod = h2.hcmod
                    and h1.hsucor = h2.hsucor
                    and h1.htran = h2.htran
                    and h1.hnrel = h2.hnrel
                    and h1.hfcon= x.fval --P_FECHA
                    and h2.hcmod = 30
                    and h2.htran = 951
                    and h2.hcord = 10
                    and h2.hmodul = x.modu
                    and h2.hsucor = x.SUC
                    and h2.hmda = x.MDA
                    and h2.hpap = 0
                    and h2.hcta = x.cuenta
                    and h2.hoper = x.operacion
                    and h2.hsubop = x.sub
                    and h2.htoper = x.tope) hora_desembolso,
                TO_CHAR(x.FVAL,'DD/MM/YYYY') fecha_afiliacion,---sma 22102018 q.jaqm251fec
                null  fecha_desafiliacion,
                 0 agencia_desafiliacion,
                 'MASIVO' JAQZ556AU5,
                 (select pgfape from fst017 where pgcod=1) JAQZ556AU8,
                 x.seguro JAQZ556AU1,
                 'R'
            FROM FSD002 P, --PERS ESTADO CIVIL
                 SNGC13 D --DIRECCION
           WHERE P.PFPAIS = x.PAIS
             AND P.PFTDOC = x.TDOC
             AND P.PFNDOC = x.DOC
             AND D.SNGC13PAIS = P.PFPAIS
             AND D.SNGC13TDOC = P.PFTDOC
             AND D.SNGC13NDOC = P.PFNDOC
             AND D.DOCOD = 1
             AND D.SNGC13EST = 'H';
             commit;
          exception
            when dup_val_on_index then
              null;
          end;
          contador := contador + 1;
       end loop ;
    Exception
      WHEN OTHERS THEN
          err_code := SQLCODE;
          err_msg := SUBSTR(SQLERRM, 1, 200)||' '||'JAQZ556TIPO'||' '|| '8';

         INSERT INTO JAQZ557LOG (jaqz557ecod  , jaqz557emsg,jaqz557fecha   )
         VALUES (err_code, err_msg, fecha);
          commit;
    End;
    for u in actualiza loop
      cuenta := to_number(substr(u.nro_credito,1,9));
      modulo := to_number(substr(u.nro_credito,10,3));
      moneda := to_number(substr(u.nro_credito,14,3));
      operacion := to_number(substr(u.nro_credito,16,9));
      tipoope := to_number(substr(u.nro_credito,25,3));
      fecha1 := to_date(u.FECHA_DESEMBOLSO,'DD/MM/YYYY');
            
      BEGIN
       select 'Ventanilla'
         into tipodes
         from jaqy782 
        where jaqy782pgc = 1 
          and jaqy782mod = modulo        
          and jaqy782mda = moneda
          and jaqy782pap = 0
          and jaqy782cta = cuenta
          and jaqy782ope = operacion          
          and jaqy782fchdes = fecha1
          and jaqy782est ='A'
          and JAQY782HRASIS = (select max(JAQY782HRASIS)  
                                 from jaqy782
                                 where jaqy782pgc = 1    
                                   and jaqy782mod = modulo       
                                   and jaqy782mda = moneda
                                   and jaqy782pap = 0
                                   and jaqy782cta = cuenta
                                   and jaqy782ope = operacion
                                   and jaqy782fchdes = fecha1
                                   and jaqy782est ='A');
       exception
         when no_data_found then
           Begin
           select 'Biometria'
             into tipodes
             from jaqm1a
            where jaqm1atem = 1
              and jaqm1atfc = fecha1
              and jaqm1atmo = 30
              and jaqm1attr in (951, 360)
              and jaqm1amod = modulo
              and jaqm1amda = moneda
              and jaqm1apap = 0
              and jaqm1acta = cuenta
              and jaqm1aope = operacion
              and jaqm1aest = 'P';
          exception
            when no_Data_found then
              Begin
                select 'Aplicativo'
                  into tipodes
                  from  fsd016 a, fsd015 b
                 where a.pgcod = 1
                   and a.itmod =489
                   and a.ittran in (951,360)
                   and a.ctnro = cuenta
                   and a.itoper =  operacion
                   and a.modulo = modulo
                   and a.ITTOPE = tipoope
                   and b.PGCOD = a.pgcod
                   and b.ITSUC = a.itsuc
                   and b.ITMOD = a.ITMOD
                   and b.ITtran = a.ITTRAN
                   and b.ITNREL = a.ITNREL
                   and b.ITCORR = 0
                   and b.ITCONT = 'S';
              exception
                when no_data_found then
                  begin
                      select 'Aplicativo'
                        into tipodes
                        from fsh016 a, fsh015 b
                       where a.pgcod = 1
                         and a.hcmod =489
                         and a.htran in (951,360)
                         and a.hfcon = fecha1
                         and a.hcta = cuenta
                         and a.hoper = operacion
                         and a.hmodul = modulo
                         and a.htoper = tipoope
                         and b.PGCOD = a.pgcod
                         and b.hSUCor = a.hsucor
                         and b.hcMOD = a.hcMOD
                         and b.htran = a.hTRAN
                         and b.hNREL = a.hNREL
                         and b.hfcon = a.hfcon
                         and b.hcCORR = 0;
                  exception  
                     when no_Data_found then
                        tipodes := 'Ventanilla';
                  end;
              end;
         end;
      end;
      update jaqz556
         set jaqz556au3 = tipodes
       where jaqz556cod = u.jaqz556cod;
       commit;

    end loop;

    END SP_CR_SEGUROSVC_ANT;
  -------------------------------------------------------------------------------------------------------------------
  PROCEDURE SP_TRANSFERIR(P_FECHA IN DATE, P_DATO OUT NUMBER) IS
  CURSOR datos IS
    SELECT /*+parallel(jaqz556,4,1)*/* FROM jaqz556;

  CONTADOR NUMBER;-- := 0;
  err_code varchar2(500);
  err_msg varchar2(500);
  verifica number:= 0;
  fechauno date;
  analista varchar2(20);
  estadocivil varchar2(20);
  fecha date;
  bEGIN
    select count(*)
    INTO CONTADOR
    from "CMAC_CargaDiaria"@sisretail;--sisretop;  PRUEBASSSSSSS  jaqz556prueba;---
    commit;
    bEGIN
      select distinct 1
        into verifica
        from jaqz556h
       where trunc(Fecha_proceso) = p_fecha;
    exception
      when no_data_found then null;
    END;
/*
    IF CONTADOR <> 0  THEN --sma03062019
      P_DATO := 1; --
    ELSE*/
    if verifica = 0 then
      For i in datos loop
        /* begin
              insert into JAQZ556PRUEBA
              (ITEM,PLAN_SEGURO, PATCLIENTE,MATCLIENTE,NOMBRECLIENTE,IDC,TIP_IDC,EMAIL,
               ESTADOCIVIL,SEXO,FECHA_NAC,TELEFONO,OCUPACION,UBIGEO_CLIENTE,DIRECCION,PRODUCTO,CODIGO_SUCURSAL,
               FUNCIONARIO,ESTADO_CREDITO,NRO_CREDITO,MONEDA_CUENTA,FECHA_CANCELACION,FECHA_DESEMBOLSO,CRED_FALT,
               FECHA_AFILIACION,COSTO_SEGURO,IMPORTE_CREDITO,PRIMA_MENSUAL,NRO_CREDITO_ANTERIOR,HORA_DESEMBOLSO)
                VALUES
              (i.ITEM,I.PLAN_SEGURO,i.PATCLIENTE, i.MATCLIENTE ,i.NOMBRECLIENTE,i.IDC,i.TIP_IDC,i.EMAIL,
               i.ESTADOCIVIL,i.SEXO,i.FECHA_NAC,i.TELEFONO,i.OCUPACION,i.UBIGEO_CLIENTE,i.DIRECCION,i.PRODUCTO,i.CODIGO_SUCURSAL,
               i.FUNCIONARIO,i.ESTADO,i.NRO_CREDITO,i.MONEDA_CUENTA,i.FECHA_CANCELACION,i.FECHA_DESEMBOLSO,i.cred_falt,
               i.fecha_afiliacion,null,i.importe_credito,i.prima_mensual,null,i.hora_desembolso);
           */
           if  i.FUNCIONARIO  is null then
             analista := 'Sin/Analista';
           else
             analista := i.FUNCIONARIO;
           end iF;
           if i.ESTADOCIVIL is null then
              EstadoCivil := 'Soltero';
           else
              EstadoCivil := i.ESTADOCIVIL;
           end if;
           BEGIN
            INSERT INTO "CMAC_CargaDiaria"@sisretail--sisretop
            ("ITEM","PLAN_SEGURO", "PATCLIENTE","MATCLIENTE","NOMBRECLIENTE","IDC","TIP_IDC","EMAIL",
             "ESTADOCIVIL","SEXO","FECHA_NAC","TELEFONO","OCUPACION","UBIGEO_CLIENTE","DIRECCION","PRODUCTO","CODIGO_SUCURSAL",
             "FUNCIONARIO","ESTADO_CREDITO","NRO_CREDITO","MONEDA_CUENTA","FECHA_CANCELACION","FECHA_DESEMBOLSO","CRED_FALT",
             "FECHA_AFILIACION","COSTO_SEGURO","IMPORTE_CREDITO","PRIMA_MENSUAL","NRO_CREDITO_ANTERIOR","HORA_DESEMBOLSO")
            VALUES
              (i.ITEM,I.PLAN_SEGURO,i.PATCLIENTE, i.MATCLIENTE ,i.NOMBRECLIENTE,i.IDC,i.TIP_IDC,i.EMAIL,
              EstadoCivil,i.SEXO,i.FECHA_NAC,i.TELEFONO,i.OCUPACION,i.UBIGEO_CLIENTE,i.DIRECCION,i.PRODUCTO,i.CODIGO_SUCURSAL,
               analista,i.ESTADO,i.NRO_CREDITO,i.MONEDA_CUENTA,i.FECHA_CANCELACION,i.FECHA_DESEMBOLSO,i.cred_falt,
               i.fecha_afiliacion,null,i.importe_credito,i.prima_mensual,i.jaqz556au3,i.hora_desembolso);

            COMMIT;
           EXCEPTION
             WHEN OTHERS THEN
                err_code := SQLCODE||'Error';
                
                err_msg := SUBSTR(SQLERRM, 1, 200)||i.NRO_CREDITO||'tipo'||i.jaqz556tipo;
                fecha := trunc(sysdate);
                 INSERT INTO JAQZ557LOG (jaqz557ecod  , jaqz557emsg, jaqz557fecha)
                 VALUES (err_code, err_msg, fecha);

               COMMIT;

           END;
           BEGIN
            select pgfape into fechauno from fst017 where pgcod=1;
            insert into JAQZ556H
              (jaqz556hcod, ITEMH,PLAN_SEGUROH, PATCLIENTEH,MATCLIENTEH,NOMBRECLIENTEH,IDCH,TIP_IDCH,EMAILH,
               ESTADOCIVILH,SEXOH,FECHA_NACH,TELEFONOH,OCUPACIONH,UBIGEO_CLIENTEH,DIRECCIONH,PRODUCTOH,CODIGO_SUCURSALH,
               FUNCIONARIOH,ESTADOH,NRO_CREDITOH,MONEDA_CUENTAH,FECHA_CANCELACIONH,FECHA_DESEMBOLSOH,CRED_FALTH,
               FECHA_AFILIACIONH,COSTO_SEGUROH,IMPORTE_CREDITOH,PRIMA_MENSUALH,NRO_CREDITO_ANATERIORH,HORA_DESEMBOLSOH,
               USUARIO,FECHA_PROCESO,jaqz556htipoh,jaqz556h12,jaqz556h14  )
            VALUES
              (seq_jaqz556h.nextval,i.ITEM,I.PLAN_SEGURO,i.PATCLIENTE, i.MATCLIENTE ,i.NOMBRECLIENTE,i.IDC,i.TIP_IDC,i.EMAIL,
               ESTADOCIVIL,i.SEXO,i.FECHA_NAC,i.TELEFONO,i.OCUPACION,i.UBIGEO_CLIENTE,i.DIRECCION,i.PRODUCTO,i.CODIGO_SUCURSAL,
               analista,i.ESTADO,i.NRO_CREDITO,i.MONEDA_CUENTA,i.FECHA_CANCELACION,i.FECHA_DESEMBOLSO,i.cred_falt,
               i.fecha_afiliacion,null,i.importe_credito,i.prima_mensual,i.jaqz556au3,i.hora_desembolso,trim(i.jaqz556au5), P_FECHA,--fechauno,
               i.jaqz556tipo, fechauno,i.JAQZ556AU1);
            COMMIT;
           EXCEPTION
             WHEN OTHERS THEN
                err_code := SQLCODE||'Error';
                err_msg := SUBSTR(SQLERRM, 1, 200)||i.NRO_CREDITO||'tipo'||i.jaqz556tipo||' '||'H';
                fecha := sysdate;
                 INSERT INTO JAQZ557LOG (jaqz557ecod  , jaqz557emsg,jaqz557fecha   )
                 VALUES (err_code, err_msg, fecha);
               COMMIT;
           END;
      end loop;
       P_DATO := 2;
    ELSE
      P_DATO := 2;
    END IF;
  END  SP_TRANSFERIR;
end PQ_CR_QAUTOSEGUROS;
/

