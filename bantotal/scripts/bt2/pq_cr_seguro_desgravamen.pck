CREATE OR REPLACE PACKAGE PQ_CR_SEGURO_DESGRAVAMEN IS
  -- *********************************************************************************
  -- Nombre                     : PAQUETE PARA SEGUROS DESGRAVAMEN
  -- Sistema                    : BANTOTAL
  -- M¿dulo                     : PASIVAS
  -- Versi¿n                    : 1.0
  -- Fecha de Creaci¿n          : 2015.03.30
  -- Autor de Creaci¿n          : YYAMPI
  -- Uso                        : FUNCIONES Y PROCEDIMIENTOS PARA REPORTES
  -- Estado                     : Activo
  -- Acceso                     : P¿blico
  -- Fecha de Modificacion      : 30/04/2024
  -- Autor                      : Silvia MArquez
  -- Modificacion               : TAsa para tasa Convenio
  -- Modificacion               : SMARQUEZ 05/09/2024 nuevas condiciones desgravamen
  -- *********************************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  Procedure SP_REPORTE_PAGOS(PA_USUARIO VARCHAR2,
                             PA_NROIP   VARCHAR2,
                             PA_REGION  NUMBER,
                             PA_AGENCIA NUMBER,
                             PA_FECINI  varchar2,
                             PA_FECFIN  varchar2);
  ---------------------------------------------------------------------------------------------
  procedure SP_CR_CONSUCURSAL(PA_USUARIO VARCHAR2,
                              PA_NROIP   VARCHAR2,
                              PA_REGION  NUMBER,
                              PA_AGENCIA NUMBER,
                              PA_FECINI  varchar2,
                              PA_FECFIN  varchar2);
  --------------------------------------------------------------------------------------------------
  procedure SP_CR_SINSUCURSAL(PA_USUARIO VARCHAR2,
                              PA_NROIP   VARCHAR2,
                              PA_REGION  NUMBER,
                              PA_FECINI  varchar2,
                              PA_FECFIN  varchar2);
  -----------------------------------------------------------------------------------------
  procedure SP_CR_SINREGION(PA_USUARIO VARCHAR2,
                            PA_NROIP   VARCHAR2,
                            PA_FECINI  varchar2,
                            PA_FECFIN  varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  --function FN_TASA_DESGRAVAMEN(PA_COMOD number, PA_CUENTA number, PA_MONTO number, PA_COMDA NUMBER ) return number;
  function FN_TASA_DESGRAVAMEN(PA_PGCOD  number,
                               PA_AOMOD  number,
                               PA_AOSUC  number,
                               PA_AOMDA  number,
                               PA_AOPAP  number,
                               PA_AOCTA  number,
                               PA_AOOPER number,
                               PA_AOSBOP number,
                               PA_AOTOPE number,
                               PA_MONTO  number) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  FUNCTION FN_FECHA_APERTURA RETURN varchar;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_TASA_DESGRAVAMEN(PA_PGCOD  number,
                                PA_AOMOD  number,
                                PA_AOSUC  number,
                                PA_AOMDA  number,
                                PA_AOPAP  number,
                                PA_AOCTA  number,
                                PA_AOOPER number,
                                PA_AOSBOP number,
                                PA_AOTOPE number,
                                PA_MONTO  number,
                                PA_TASA   out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  Procedure sp_MONTO_PRIMA(pa_pgcod  number,
                           pa_ppmod  number,
                           pa_ppsuc  number,
                           pa_ppmda  number,
                           pa_pppap  number,
                           pa_ppcta  number,
                           pa_ppoper number,
                           pa_ppsbop number,
                           pa_pptope number,
                           PA_monto  out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  FUNCTION fn_MONTO_PRIMA(pa_pgcod  number,
                          pa_ppmod  number,
                          pa_ppsuc  number,
                          pa_ppmda  number,
                          pa_pppap  number,
                          pa_ppcta  number,
                          pa_ppoper number,
                          pa_ppsbop number,
                          pa_pptope number) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function FN_COD_COMISION(PA_PGCOD  number,
                           PA_AOMOD  number,
                           PA_AOSUC  number,
                           PA_AOMDA  number,
                           PA_AOPAP  number,
                           PA_AOCTA  number,
                           PA_AOOPER number,
                           PA_AOSBOP number,
                           PA_AOTOPE number) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function Fn_Periodo(pa_aoperiod number) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function Fn_Monto(pa_monto number, pa_ppmda number) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_Permanencia(pa_ppcta     in number,
                           pp_fecpro    in date,
                           pa_indicador out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_TASA_DESGRA_APP(PA_MONTO  IN NUMBER,
                               PA_CODSEG IN NUMBER,
                               PA_TIPSEG IN VARCHAR2,
                               TASA     OUT NUMBER );
   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
END PQ_CR_SEGURO_DESGRAVAMEN;
/

CREATE OR REPLACE PACKAGE BODY PQ_CR_SEGURO_DESGRAVAMEN IS
  -- *********************************************************************************
  -- Nombre                     : PAQUETE PARA SEGUROS DESGRAVAMEN
  -- Sistema                    : BANTOTAL
  -- M¿dulo                     : PASIVAS
  -- Versi¿n                    : 1.0
  -- Fecha de Creacion          : 2015.03.30
  -- Autor de Creacion          : YYAMPI
  -- Uso                        : FUNCIONES Y PROCEDIMIENTOS PARA REPORTES
  -- Estado                     : Activo
  -- Acceso                     : P¿blico
  -- Fecha de Modificacion      : 30/04/2024
  -- Autor                      : Silvia MArquez
  -- Modificacion               : TAsa para tasa Convenio
  -- Modificacion               : SMARQUEZ 05/09/2024 nuevas condiciones desgravamen
  -- *********************************************************************************
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  Procedure SP_REPORTE_PAGOS(PA_USUARIO VARCHAR2,
                             PA_NROIP   VARCHAR2,
                             PA_REGION  NUMBER,
                             PA_AGENCIA NUMBER,
                             PA_FECINI  varchar2,
                             PA_FECFIN  varchar2) IS

  begin

    if PA_REGION <> 0 and PA_AGENCIA <> 0 then
      --- Por Sucursal
      pq_cr_seguro_desgravamen.sp_cr_consucursal(PA_USUARIO,
                                                 PA_NROIP,
                                                 PA_REGION,
                                                 PA_AGENCIA,
                                                 PA_FECINI,
                                                 PA_FECFIN);

    end if;
    if PA_REGION <> 0 and PA_AGENCIA = 0 then
      --- Por Region
      pq_cr_seguro_desgravamen.SP_CR_SINSUCURSAL(PA_USUARIO,
                                                 PA_NROIP,
                                                 PA_REGION,
                                                 PA_FECINI,
                                                 PA_FECFIN);

    end if;

    if PA_REGION = 0 and PA_AGENCIA = 0 then
      --- Por todo
      pq_cr_seguro_desgravamen.SP_CR_SINREGION(PA_USUARIO,
                                               PA_NROIP,
                                               PA_FECINI,
                                               PA_FECFIN);

    end if;

  END;
  ------------------------------------------------------------------------------------------
  procedure SP_CR_CONSUCURSAL(PA_USUARIO VARCHAR2,
                              PA_NROIP   VARCHAR2,
                              PA_REGION  NUMBER,
                              PA_AGENCIA NUMBER,
                              PA_FECINI  varchar2,
                              PA_FECFIN  varchar2) is
    coor number := 0;

    CURSOR PAGO(P_REGION NUMBER, P_AGENCIA NUMBER, P_FECINI varchar2, P_FECFIN varchar2) IS
      select distinct upper(v.regnom) region,
                      n.scnom agencia,
                      lpad(g.aocta, 9, '0') || lpad(g.aomda, 3, '0') ||
                      lpad(g.aooper, 9, '0') credito,
                      p.penom cliente,
                      (select m.tdnom
                         from fst014 m
                        where m.tdocum = p.petdoc) petdoc,
                      p.pendoc,
                      (select q.pffnac
                         from fsd002 q
                        where q.pfpais = p.pepais
                          and q.pftdoc = p.petdoc
                          and q.pfndoc = p.pendoc) fec_nacimiento,
                      fn_analista_credito(g.aomod,
                                          g.aosuc,
                                          g.aomda,
                                          g.aopap,
                                          g.aocta,
                                          g.aooper,
                                          g.aosbop,
                                          g.aotope) analista,
                      (case
                        when k.scgru = 2 then
                         'MICROEMPRESAS'
                        when k.scgru = 3 and substr(k.scrub, 11, 3) = '015' then
                         'CONSUMO REVOLVENTE'
                        when k.scgru = 3 and substr(k.scrub, 11, 3) <> '015' then
                         'CONSUMO NO REVOLVENTE'
                        when k.scgru = 4 then
                         'HIPOTECARIO'
                        when k.scgru = 10 then
                         'GRANDES EMPRESAS'
                        when k.scgru = 12 then
                         'MEDIANA EMPRESA'
                        when k.scgru = 13 then
                         'PEQUEÑA EMPRESA'
                        when k.scgru in (5, 6, 7, 8, 9, 10) then
                         'CORPORATIVO'
                      END) tipo_credito,
                      (select u.mosign
                         from FST005 u
                        where u.moneda = g.aomda) moneda,
                      g.aoimp mto_desembolsado,
                      -1 * (k.scsdo) scsdo,
                      g.aofval fecha_desembolso,
                      g.aoperiod periodo,
                      --FN_TASA_DESGRAVAMEN(PA_COMOD => g.aomod,PA_CUENTA => g.aocta, PA_MONTO => g.aoimp, PA_COMDA => g.aomda)   tasa ,
                      pq_cr_seguro_desgravamen.fn_tasa_desgravamen(g.pgcod,
                                                                   g.aomod,
                                                                   g.aosuc,
                                                                   g.aomda,
                                                                   g.aopap,
                                                                   g.aocta,
                                                                   g.aooper,
                                                                   g.aosbop,
                                                                   g.aotope,
                                                                   g.aoimp) tasa,
                      to_char(e.pp1fech, 'mm') mes,
                      e.pp1fech fecha_pago,
                      j.itimp1 pago_prima --,
      -- (select s.trnom from fst034 s where s.pgcod = 1 and s.trmod = j.itmod and s.trnro = j.ittran) tran , j.*
        from fsd601 d,
             fsd602 e,
             fsd611 f,
             fpp001 t,
             fsd010 g,
             fsd016 j,
             FST811 w,
             fst001 n,
             fst810 v,
             fsr008 a,
             fsd001 p,
             fsd011 k
       where g.pgcod = k.pgcod
         and g.aomod = k.scmod
         and g.aosuc = k.scsuc
         and g.aomda = k.scmda
         and g.aopap = k.scpap
         and g.aocta = k.sccta
         and g.aooper = k.scoper
         and g.aosbop = k.scsbop
         and g.aotope = k.sctope
         and p.pepais = a.pepais
         and p.petdoc = a.petdoc
         and p.pendoc = a.pendoc
         and a.pgcod = g.pgcod
         and a.ctnro = g.aocta
         and a.cttfir = 'T'
         and a.ttcod = 1
         and w.pgcod = v.pgcod
         and w.regcod = v.regcod
         and w.pgcod = n.pgcod
         and w.oficod = n.sucurs
         and v.regcod < 100
         and n.sucurs = g.aosuc
         and t.pgcod = d.pgcod
         and t.aomod = d.ppmod
         and d.ppsuc = t.aosuc
         and d.ppmda = t.aomda
         and d.pppap = t.aopap
         and d.ppcta = t.aocta
         and d.ppoper = t.aooper
         and d.ppsbop = t.aosbop
         and d.pptope = t.aotope
         and e.pgcod = d.pgcod
         and e.ppmod = d.ppmod
         and e.ppsuc = d.ppsuc
         and e.ppmda = d.ppmda
         and e.pppap = d.pppap
         and e.ppcta = d.ppcta
         and e.ppoper = d.ppoper
         and e.ppsbop = d.ppsbop
         and e.pptope = d.pptope
         and e.ppfpag = d.ppfpag
         and f.pgcod = d.pgcod
         and f.ppmod = d.ppmod
         and f.ppsuc = d.ppsuc
         and f.ppmda = d.ppmda
         and f.pppap = d.pppap
         and f.ppcta = d.ppcta
         and f.ppoper = d.ppoper
         and f.ppsbop = d.ppsbop
         and f.pptope = d.pptope
         and f.ppfpag = d.ppfpag
         and g.pgcod = d.pgcod
         and g.aomod = d.ppmod
         and g.aosuc = d.ppsuc
         and g.aomda = d.ppmda
         and g.aopap = d.pppap
         and g.aocta = d.ppcta
         and g.aooper = d.ppoper
         and g.aosbop = d.ppsbop
         and g.aotope = d.pptope
         and j.pgcod = e.d602cd
         and j.itmod = e.d602mo
         and j.itsuc = e.d602su
         and j.ittran = e.d602tr
         and j.itnrel = e.d602re
            --and j.ctnro in (2056, 9807,  5323,  29625, 214  , 1099,  3110,  10005, 9142)
         and j.rubro in (2514020000005, 2524020000005)
            --and j.itfval = d.d601fc
         and e.pp1fech between to_date(P_FECINI, 'DD/MM/RR') and
             to_date(P_FECFIN, 'DD/MM/RR')
         and t.sgcod in (select i.tp1imp1
                           from fst198 i
                          where i.tp1cod1 = 10898
                            and i.tp1corr1 = 8)
         and w.regcod = decode(P_REGION, 0, w.regcod, P_REGION)
         and n.sucurs = decode(P_AGENCIA, 0, n.sucurs, P_AGENCIA);

    CURSOR PAGOH(P_REGION NUMBER, P_AGENCIA NUMBER, P_FECINI varchar2, P_FECFIN varchar2) IS
      select distinct upper(v.regnom) region,
                      n.scnom agencia,
                      lpad(g.aocta, 9, '0') || lpad(g.aomda, 3, '0') ||
                      lpad(g.aooper, 9, '0') credito,
                      p.penom cliente,
                      (select m.tdnom
                         from fst014 m
                        where m.tdocum = p.petdoc) petdoc,
                      p.pendoc,
                      (select q.pffnac
                         from fsd002 q
                        where q.pfpais = p.pepais
                          and q.pftdoc = p.petdoc
                          and q.pfndoc = p.pendoc) fec_nacimiento,
                      fn_analista_credito(g.aomod,
                                          g.aosuc,
                                          g.aomda,
                                          g.aopap,
                                          g.aocta,
                                          g.aooper,
                                          g.aosbop,
                                          g.aotope) analista,
                      (case
                        when k.scgru = 2 then
                         'MICROEMPRESAS'
                        when k.scgru = 3 and substr(k.scrub, 11, 3) = '015' then
                         'CONSUMO REVOLVENTE'
                        when k.scgru = 3 and substr(k.scrub, 11, 3) <> '015' then
                         'CONSUMO NO REVOLVENTE'
                        when k.scgru = 4 then
                         'HIPOTECARIO'
                        when k.scgru = 10 then
                         'GRANDES EMPRESAS'
                        when k.scgru = 12 then
                         'MEDIANA EMPRESA'
                        when k.scgru = 13 then
                         'PEQUEÑA EMPRESA'
                        when k.scgru in (5, 6, 7, 8, 9, 10) then
                         'CORPORATIVO'
                      END) tipo_credito,
                      (select u.mosign
                         from FST005 u
                        where u.moneda = g.aomda) moneda,
                      g.aoimp mto_desembolsado,
                      -1 * (k.scsdo) scsdo,
                      g.aofval fecha_desembolso,
                      g.aoperiod periodo,
                      --FN_TASA_DESGRAVAMEN(PA_COMOD => g.aomod,PA_CUENTA => g.aocta, PA_MONTO => g.aoimp ,PA_COMDA => g.aomda)   tasa ,
                      pq_cr_seguro_desgravamen.fn_tasa_desgravamen(g.pgcod,
                                                                   g.aomod,
                                                                   g.aosuc,
                                                                   g.aomda,
                                                                   g.aopap,
                                                                   g.aocta,
                                                                   g.aooper,
                                                                   g.aosbop,
                                                                   g.aotope,
                                                                   g.aoimp) tasa,
                      to_char(e.pp1fech, 'mm') mes,
                      e.pp1fech fecha_pago,
                      j.hcimp1 pago_prima --,
      -- (select s.trnom from fst034 s where s.pgcod = 1 and s.trmod = j.itmod and s.trnro = j.ittran) tran , j.*
        from fsd601 d,
             fsd602 e,
             fsd611 f,
             fpp001 t,
             fsd010 g,
             fsh016 j,
             FST811 w,
             fst001 n,
             fst810 v,
             fsr008 a,
             fsd001 p,
             fsd011 k
       where g.pgcod = k.pgcod
         and g.aomod = k.scmod
         and g.aosuc = k.scsuc
         and g.aomda = k.scmda
         and g.aopap = k.scpap
         and g.aocta = k.sccta
         and g.aooper = k.scoper
         and g.aosbop = k.scsbop
         and g.aotope = k.sctope
         and p.pepais = a.pepais
         and p.petdoc = a.petdoc
         and p.pendoc = a.pendoc
         and a.pgcod = g.pgcod
         and a.ctnro = g.aocta
         and a.cttfir = 'T'
         and a.ttcod = 1
         and w.pgcod = v.pgcod
         and w.regcod = v.regcod
         and w.pgcod = n.pgcod
         and w.oficod = n.sucurs
         and v.regcod < 100
         and n.sucurs = g.aosuc
         and t.pgcod = d.pgcod
         and t.aomod = d.ppmod
         and d.ppsuc = t.aosuc
         and d.ppmda = t.aomda
         and d.pppap = t.aopap
         and d.ppcta = t.aocta
         and d.ppoper = t.aooper
         and d.ppsbop = t.aosbop
         and d.pptope = t.aotope
         and e.pgcod = d.pgcod
         and e.ppmod = d.ppmod
         and e.ppsuc = d.ppsuc
         and e.ppmda = d.ppmda
         and e.pppap = d.pppap
         and e.ppcta = d.ppcta
         and e.ppoper = d.ppoper
         and e.ppsbop = d.ppsbop
         and e.pptope = d.pptope
         and e.ppfpag = d.ppfpag
         and f.pgcod = d.pgcod
         and f.ppmod = d.ppmod
         and f.ppsuc = d.ppsuc
         and f.ppmda = d.ppmda
         and f.pppap = d.pppap
         and f.ppcta = d.ppcta
         and f.ppoper = d.ppoper
         and f.ppsbop = d.ppsbop
         and f.pptope = d.pptope
         and f.ppfpag = d.ppfpag
         and g.pgcod = d.pgcod
         and g.aomod = d.ppmod
         and g.aosuc = d.ppsuc
         and g.aomda = d.ppmda
         and g.aopap = d.pppap
         and g.aocta = d.ppcta
         and g.aooper = d.ppoper
         and g.aosbop = d.ppsbop
         and g.aotope = d.pptope
         AND j.hfcon = e.d602fc
         and j.pgcod = e.d602cd
         and j.hcmod = e.d602mo
         and j.hsucor = e.d602su
         and j.htran = e.d602tr
         and j.hnrel = e.d602re
            --and j.ctnro in (2056, 9807,  5323,  29625, 214  , 1099,  3110,  10005, 9142)
         and j.hrubro in (2514020000005, 2524020000005)
            --and j.itfval = d.d601fc
            --and e.pp1fech between to_date(P_FECINI,'DD/MM/RR') and to_date(P_FECFIN,'DD/MM/RR')
         and j.hfcon between to_date(P_FECINI, 'DD/MM/RR') and
             to_date(P_FECFIN, 'DD/MM/RR')
         and t.sgcod in (select i.tp1imp1
                           from fst198 i
                          where i.tp1cod1 = 10898
                            and i.tp1corr1 = 8)
         and w.regcod = decode(P_REGION, 0, w.regcod, P_REGION)
         and n.sucurs = decode(P_AGENCIA, 0, n.sucurs, P_AGENCIA);

  BEGIN

    delete jaqy959 T
     WHERE T.JAQY959NIP = PA_NROIP
       AND T.JAQY959USU = PA_USUARIO;
    COMMIT;

    if PA_FECFIN = FN_FECHA_APERTURA THEN
      /*ACTUAL*/

      FOR P in PAGO(PA_REGION, PA_AGENCIA, PA_FECINI, PA_FECFIN) LOOP
        coor := coor + 1;

        insert into JAQY959
          (JAQY959NIP,
           JAQY959USU,
           JAQY959COR,
           JAQY959REG,
           JAQY959SUC,
           JAQY959CRE,
           JAQY959CLI,
           JAQY959TDO,
           JAQY959NDO,
           JAQY959FEN,
           JAQY959ANA,
           JAQY959TCR,
           JAQY959MON,
           JAQY959MTD,
           JAQY959SDO,
           JAQY959FED,
           JAQY959PER,
           JAQY959TAS,
           JAQY959MES,
           JAQY959FPG,
           JAQY959PPR)
        values
          (PA_NROIP,
           PA_USUARIO,
           coor,
           p.region,
           p.agencia,
           p.credito,
           p.cliente,
           p.petdoc,
           p.pendoc,
           p.fec_nacimiento,
           p.analista,
           p.tipo_credito,
           p.moneda,
           p.mto_desembolsado,
           p.scsdo,
           p.fecha_desembolso,
           p.periodo,
           p.tasa,
           p.mes,
           p.fecha_pago,
           p.pago_prima);

      END LOOP;
      commit;
    end if;

    /*HISTORICO*/

    FOR P in PAGOH(PA_REGION, PA_AGENCIA, PA_FECINI, PA_FECFIN) LOOP
      coor := coor + 1;

      insert into JAQY959
        (JAQY959NIP,
         JAQY959USU,
         JAQY959COR,
         JAQY959REG,
         JAQY959SUC,
         JAQY959CRE,
         JAQY959CLI,
         JAQY959TDO,
         JAQY959NDO,
         JAQY959FEN,
         JAQY959ANA,
         JAQY959TCR,
         JAQY959MON,
         JAQY959MTD,
         JAQY959SDO,
         JAQY959FED,
         JAQY959PER,
         JAQY959TAS,
         JAQY959MES,
         JAQY959FPG,
         JAQY959PPR)
      values
        (PA_NROIP,
         PA_USUARIO,
         coor,
         p.region,
         p.agencia,
         p.credito,
         p.cliente,
         p.petdoc,
         p.pendoc,
         p.fec_nacimiento,
         p.analista,
         p.tipo_credito,
         p.moneda,
         p.mto_desembolsado,
         p.scsdo,
         p.fecha_desembolso,
         p.periodo,
         p.tasa,
         p.mes,
         p.fecha_pago,
         p.pago_prima);

    END LOOP;

    commit;

  end SP_CR_CONSUCURSAL;
  ------------------------------------------------------------------------------------------------
  procedure SP_CR_SINSUCURSAL(PA_USUARIO VARCHAR2,
                              PA_NROIP   VARCHAR2,
                              PA_REGION  NUMBER,
                              PA_FECINI  varchar2,
                              PA_FECFIN  varchar2) is
    coor number := 0;

    CURSOR PAGO(P_REGION NUMBER, P_FECINI varchar2, P_FECFIN varchar2) IS
      select distinct upper(v.regnom) region,
                      n.scnom agencia,
                      lpad(g.aocta, 9, '0') || lpad(g.aomda, 3, '0') ||
                      lpad(g.aooper, 9, '0') credito,
                      p.penom cliente,
                      (select m.tdnom
                         from fst014 m
                        where m.tdocum = p.petdoc) petdoc,
                      p.pendoc,
                      (select q.pffnac
                         from fsd002 q
                        where q.pfpais = p.pepais
                          and q.pftdoc = p.petdoc
                          and q.pfndoc = p.pendoc) fec_nacimiento,
                      fn_analista_credito(g.aomod,
                                          g.aosuc,
                                          g.aomda,
                                          g.aopap,
                                          g.aocta,
                                          g.aooper,
                                          g.aosbop,
                                          g.aotope) analista,
                      (case
                        when k.scgru = 2 then
                         'MICROEMPRESAS'
                        when k.scgru = 3 and substr(k.scrub, 11, 3) = '015' then
                         'CONSUMO REVOLVENTE'
                        when k.scgru = 3 and substr(k.scrub, 11, 3) <> '015' then
                         'CONSUMO NO REVOLVENTE'
                        when k.scgru = 4 then
                         'HIPOTECARIO'
                        when k.scgru = 10 then
                         'GRANDES EMPRESAS'
                        when k.scgru = 12 then
                         'MEDIANA EMPRESA'
                        when k.scgru = 13 then
                         'PEQUEÑA EMPRESA'
                        when k.scgru in (5, 6, 7, 8, 9, 10) then
                         'CORPORATIVO'
                      END) tipo_credito,
                      (select u.mosign
                         from FST005 u
                        where u.moneda = g.aomda) moneda,
                      g.aoimp mto_desembolsado,
                      -1 * (k.scsdo) scsdo,
                      g.aofval fecha_desembolso,
                      g.aoperiod periodo,
                      --FN_TASA_DESGRAVAMEN(PA_COMOD => g.aomod,PA_CUENTA => g.aocta, PA_MONTO => g.aoimp, PA_COMDA => g.aomda)   tasa ,
                      pq_cr_seguro_desgravamen.fn_tasa_desgravamen(g.pgcod,
                                                                   g.aomod,
                                                                   g.aosuc,
                                                                   g.aomda,
                                                                   g.aopap,
                                                                   g.aocta,
                                                                   g.aooper,
                                                                   g.aosbop,
                                                                   g.aotope,
                                                                   g.aoimp) tasa,
                      to_char(e.pp1fech, 'mm') mes,
                      e.pp1fech fecha_pago,
                      j.itimp1 pago_prima --,
      -- (select s.trnom from fst034 s where s.pgcod = 1 and s.trmod = j.itmod and s.trnro = j.ittran) tran , j.*
        from fsd601 d,
             fsd602 e,
             fsd611 f,
             fpp001 t,
             fsd010 g,
             fsd016 j,
             FST811 w,
             fst001 n,
             fst810 v,
             fsr008 a,
             fsd001 p,
             fsd011 k
       where g.pgcod = k.pgcod
         and g.aomod = k.scmod
         and g.aosuc = k.scsuc
         and g.aomda = k.scmda
         and g.aopap = k.scpap
         and g.aocta = k.sccta
         and g.aooper = k.scoper
         and g.aosbop = k.scsbop
         and g.aotope = k.sctope
         and p.pepais = a.pepais
         and p.petdoc = a.petdoc
         and p.pendoc = a.pendoc
         and a.pgcod = g.pgcod
         and a.ctnro = g.aocta
         and a.cttfir = 'T'
         and a.ttcod = 1
         and w.pgcod = v.pgcod
         and w.regcod = v.regcod
         and w.pgcod = n.pgcod
         and w.oficod = n.sucurs
         and v.regcod < 100
         and n.sucurs = g.aosuc
         and t.pgcod = d.pgcod
         and t.aomod = d.ppmod
         and d.ppsuc = t.aosuc
         and d.ppmda = t.aomda
         and d.pppap = t.aopap
         and d.ppcta = t.aocta
         and d.ppoper = t.aooper
         and d.ppsbop = t.aosbop
         and d.pptope = t.aotope
         and e.pgcod = d.pgcod
         and e.ppmod = d.ppmod
         and e.ppsuc = d.ppsuc
         and e.ppmda = d.ppmda
         and e.pppap = d.pppap
         and e.ppcta = d.ppcta
         and e.ppoper = d.ppoper
         and e.ppsbop = d.ppsbop
         and e.pptope = d.pptope
         and e.ppfpag = d.ppfpag
         and f.pgcod = d.pgcod
         and f.ppmod = d.ppmod
         and f.ppsuc = d.ppsuc
         and f.ppmda = d.ppmda
         and f.pppap = d.pppap
         and f.ppcta = d.ppcta
         and f.ppoper = d.ppoper
         and f.ppsbop = d.ppsbop
         and f.pptope = d.pptope
         and f.ppfpag = d.ppfpag
         and g.pgcod = d.pgcod
         and g.aomod = d.ppmod
         and g.aosuc = d.ppsuc
         and g.aomda = d.ppmda
         and g.aopap = d.pppap
         and g.aocta = d.ppcta
         and g.aooper = d.ppoper
         and g.aosbop = d.ppsbop
         and g.aotope = d.pptope
         and j.pgcod = e.d602cd
         and j.itmod = e.d602mo
         and j.itsuc = e.d602su
         and j.ittran = e.d602tr
         and j.itnrel = e.d602re
            --and j.ctnro in (2056, 9807,  5323,  29625, 214  , 1099,  3110,  10005, 9142)
         and j.rubro in (2514020000005, 2524020000005)
            --and j.itfval = d.d601fc
         and e.pp1fech between to_date(P_FECINI, 'DD/MM/RR') and
             to_date(P_FECFIN, 'DD/MM/RR')
         and t.sgcod in (select i.tp1imp1
                           from fst198 i
                          where i.tp1cod1 = 10898
                            and i.tp1corr1 = 8)
         and w.regcod = decode(P_REGION, 0, w.regcod, P_REGION)
         and n.sucurs in (select OfiCod
                            from fst811 -- mpostigoc 20160505
                           Where Pgcod = 1
                             and RegCod = P_REGION);
    --   and n.sucurs = decode(P_AGENCIA, 0, n.sucurs, P_AGENCIA);

    CURSOR PAGOH(P_REGION NUMBER, P_FECINI varchar2, P_FECFIN varchar2) IS
      select distinct upper(v.regnom) region,
                      n.scnom agencia,
                      lpad(g.aocta, 9, '0') || lpad(g.aomda, 3, '0') ||
                      lpad(g.aooper, 9, '0') credito,
                      p.penom cliente,
                      (select m.tdnom
                         from fst014 m
                        where m.tdocum = p.petdoc) petdoc,
                      p.pendoc,
                      (select q.pffnac
                         from fsd002 q
                        where q.pfpais = p.pepais
                          and q.pftdoc = p.petdoc
                          and q.pfndoc = p.pendoc) fec_nacimiento,
                      fn_analista_credito(g.aomod,
                                          g.aosuc,
                                          g.aomda,
                                          g.aopap,
                                          g.aocta,
                                          g.aooper,
                                          g.aosbop,
                                          g.aotope) analista,
                      (case
                        when k.scgru = 2 then
                         'MICROEMPRESAS'
                        when k.scgru = 3 and substr(k.scrub, 11, 3) = '015' then
                         'CONSUMO REVOLVENTE'
                        when k.scgru = 3 and substr(k.scrub, 11, 3) <> '015' then
                         'CONSUMO NO REVOLVENTE'
                        when k.scgru = 4 then
                         'HIPOTECARIO'
                        when k.scgru = 10 then
                         'GRANDES EMPRESAS'
                        when k.scgru = 12 then
                         'MEDIANA EMPRESA'
                        when k.scgru = 13 then
                         'PEQUEÑA EMPRESA'
                        when k.scgru in (5, 6, 7, 8, 9, 10) then
                         'CORPORATIVO'
                      END) tipo_credito,
                      (select u.mosign
                         from FST005 u
                        where u.moneda = g.aomda) moneda,
                      g.aoimp mto_desembolsado,
                      -1 * (k.scsdo) scsdo,
                      g.aofval fecha_desembolso,
                      g.aoperiod periodo,
                      --FN_TASA_DESGRAVAMEN(PA_COMOD => g.aomod,PA_CUENTA => g.aocta, PA_MONTO => g.aoimp ,PA_COMDA => g.aomda)   tasa ,
                      pq_cr_seguro_desgravamen.fn_tasa_desgravamen(g.pgcod,
                                                                   g.aomod,
                                                                   g.aosuc,
                                                                   g.aomda,
                                                                   g.aopap,
                                                                   g.aocta,
                                                                   g.aooper,
                                                                   g.aosbop,
                                                                   g.aotope,
                                                                   g.aoimp) tasa,
                      to_char(e.pp1fech, 'mm') mes,
                      e.pp1fech fecha_pago,
                      j.hcimp1 pago_prima --,
      -- (select s.trnom from fst034 s where s.pgcod = 1 and s.trmod = j.itmod and s.trnro = j.ittran) tran , j.*
        from fsd601 d,
             fsd602 e,
             fsd611 f,
             fpp001 t,
             fsd010 g,
             fsh016 j,
             FST811 w,
             fst001 n,
             fst810 v,
             fsr008 a,
             fsd001 p,
             fsd011 k
       where g.pgcod = k.pgcod
         and g.aomod = k.scmod
         and g.aosuc = k.scsuc
         and g.aomda = k.scmda
         and g.aopap = k.scpap
         and g.aocta = k.sccta
         and g.aooper = k.scoper
         and g.aosbop = k.scsbop
         and g.aotope = k.sctope
         and p.pepais = a.pepais
         and p.petdoc = a.petdoc
         and p.pendoc = a.pendoc
         and a.pgcod = g.pgcod
         and a.ctnro = g.aocta
         and a.cttfir = 'T'
         and a.ttcod = 1
         and w.pgcod = v.pgcod
         and w.regcod = v.regcod
         and w.pgcod = n.pgcod
         and w.oficod = n.sucurs
         and v.regcod < 100
         and n.sucurs = g.aosuc
         and t.pgcod = d.pgcod
         and t.aomod = d.ppmod
         and d.ppsuc = t.aosuc
         and d.ppmda = t.aomda
         and d.pppap = t.aopap
         and d.ppcta = t.aocta
         and d.ppoper = t.aooper
         and d.ppsbop = t.aosbop
         and d.pptope = t.aotope
         and e.pgcod = d.pgcod
         and e.ppmod = d.ppmod
         and e.ppsuc = d.ppsuc
         and e.ppmda = d.ppmda
         and e.pppap = d.pppap
         and e.ppcta = d.ppcta
         and e.ppoper = d.ppoper
         and e.ppsbop = d.ppsbop
         and e.pptope = d.pptope
         and e.ppfpag = d.ppfpag
         and f.pgcod = d.pgcod
         and f.ppmod = d.ppmod
         and f.ppsuc = d.ppsuc
         and f.ppmda = d.ppmda
         and f.pppap = d.pppap
         and f.ppcta = d.ppcta
         and f.ppoper = d.ppoper
         and f.ppsbop = d.ppsbop
         and f.pptope = d.pptope
         and f.ppfpag = d.ppfpag
         and g.pgcod = d.pgcod
         and g.aomod = d.ppmod
         and g.aosuc = d.ppsuc
         and g.aomda = d.ppmda
         and g.aopap = d.pppap
         and g.aocta = d.ppcta
         and g.aooper = d.ppoper
         and g.aosbop = d.ppsbop
         and g.aotope = d.pptope
         AND j.hfcon = e.d602fc
         and j.pgcod = e.d602cd
         and j.hcmod = e.d602mo
         and j.hsucor = e.d602su
         and j.htran = e.d602tr
         and j.hnrel = e.d602re
            --and j.ctnro in (2056, 9807,  5323,  29625, 214  , 1099,  3110,  10005, 9142)
         and j.hrubro in (2514020000005, 2524020000005)
            --and j.itfval = d.d601fc
            --and e.pp1fech between to_date(P_FECINI,'DD/MM/RR') and to_date(P_FECFIN,'DD/MM/RR')
         and j.hfcon between to_date(P_FECINI, 'DD/MM/RR') and
             to_date(P_FECFIN, 'DD/MM/RR')
         and t.sgcod in (select i.tp1imp1
                           from fst198 i
                          where i.tp1cod1 = 10898
                            and i.tp1corr1 = 8)
         and w.regcod = decode(P_REGION, 0, w.regcod, P_REGION)
         and n.sucurs in (select OfiCod
                            from fst811 -- mpostigoc 20160505
                           Where Pgcod = 1
                             and RegCod = P_REGION) ;

  BEGIN

    delete jaqy959 T
     WHERE T.JAQY959NIP = PA_NROIP
       AND T.JAQY959USU = PA_USUARIO;
    COMMIT;

    if PA_FECFIN = FN_FECHA_APERTURA THEN
      /*ACTUAL*/

      FOR P in PAGO(PA_REGION, PA_FECINI, PA_FECFIN) LOOP
        coor := coor + 1;

        insert into JAQY959
          (JAQY959NIP,
           JAQY959USU,
           JAQY959COR,
           JAQY959REG,
           JAQY959SUC,
           JAQY959CRE,
           JAQY959CLI,
           JAQY959TDO,
           JAQY959NDO,
           JAQY959FEN,
           JAQY959ANA,
           JAQY959TCR,
           JAQY959MON,
           JAQY959MTD,
           JAQY959SDO,
           JAQY959FED,
           JAQY959PER,
           JAQY959TAS,
           JAQY959MES,
           JAQY959FPG,
           JAQY959PPR)
        values
          (PA_NROIP,
           PA_USUARIO,
           coor,
           p.region,
           p.agencia,
           p.credito,
           p.cliente,
           p.petdoc,
           p.pendoc,
           p.fec_nacimiento,
           p.analista,
           p.tipo_credito,
           p.moneda,
           p.mto_desembolsado,
           p.scsdo,
           p.fecha_desembolso,
           p.periodo,
           p.tasa,
           p.mes,
           p.fecha_pago,
           p.pago_prima);

      END LOOP;
      commit;
    end if;

    /*HISTORICO*/

    FOR P in PAGOH(PA_REGION, PA_FECINI, PA_FECFIN) LOOP
      coor := coor + 1;

      insert into JAQY959
        (JAQY959NIP,
         JAQY959USU,
         JAQY959COR,
         JAQY959REG,
         JAQY959SUC,
         JAQY959CRE,
         JAQY959CLI,
         JAQY959TDO,
         JAQY959NDO,
         JAQY959FEN,
         JAQY959ANA,
         JAQY959TCR,
         JAQY959MON,
         JAQY959MTD,
         JAQY959SDO,
         JAQY959FED,
         JAQY959PER,
         JAQY959TAS,
         JAQY959MES,
         JAQY959FPG,
         JAQY959PPR)
      values
        (PA_NROIP,
         PA_USUARIO,
         coor,
         p.region,
         p.agencia,
         p.credito,
         p.cliente,
         p.petdoc,
         p.pendoc,
         p.fec_nacimiento,
         p.analista,
         p.tipo_credito,
         p.moneda,
         p.mto_desembolsado,
         p.scsdo,
         p.fecha_desembolso,
         p.periodo,
         p.tasa,
         p.mes,
         p.fecha_pago,
         p.pago_prima);

    END LOOP;

    commit;

  end SP_CR_SINSUCURSAL;

  ------------------------------------------------------------------------------------------------
  procedure SP_CR_SINREGION(PA_USUARIO VARCHAR2,
                            PA_NROIP   VARCHAR2,
                            PA_FECINI  varchar2,
                            PA_FECFIN  varchar2) is
    coor number := 0;

    CURSOR PAGO(P_FECINI varchar2, P_FECFIN varchar2) IS
      select distinct upper(v.regnom) region,
                      n.scnom agencia,
                      lpad(g.aocta, 9, '0') || lpad(g.aomda, 3, '0') ||
                      lpad(g.aooper, 9, '0') credito,
                      p.penom cliente,
                      (select m.tdnom
                         from fst014 m
                        where m.tdocum = p.petdoc) petdoc,
                      p.pendoc,
                      (select q.pffnac
                         from fsd002 q
                        where q.pfpais = p.pepais
                          and q.pftdoc = p.petdoc
                          and q.pfndoc = p.pendoc) fec_nacimiento,
                      fn_analista_credito(g.aomod,
                                          g.aosuc,
                                          g.aomda,
                                          g.aopap,
                                          g.aocta,
                                          g.aooper,
                                          g.aosbop,
                                          g.aotope) analista,
                      (case
                        when k.scgru = 2 then
                         'MICROEMPRESAS'
                        when k.scgru = 3 and substr(k.scrub, 11, 3) = '015' then
                         'CONSUMO REVOLVENTE'
                        when k.scgru = 3 and substr(k.scrub, 11, 3) <> '015' then
                         'CONSUMO NO REVOLVENTE'
                        when k.scgru = 4 then
                         'HIPOTECARIO'
                        when k.scgru = 10 then
                         'GRANDES EMPRESAS'
                        when k.scgru = 12 then
                         'MEDIANA EMPRESA'
                        when k.scgru = 13 then
                         'PEQUEÑA EMPRESA'
                        when k.scgru in (5, 6, 7, 8, 9, 10) then
                         'CORPORATIVO'
                      END) tipo_credito,
                      (select u.mosign
                         from FST005 u
                        where u.moneda = g.aomda) moneda,
                      g.aoimp mto_desembolsado,
                      -1 * (k.scsdo) scsdo,
                      g.aofval fecha_desembolso,
                      g.aoperiod periodo,
                      --FN_TASA_DESGRAVAMEN(PA_COMOD => g.aomod,PA_CUENTA => g.aocta, PA_MONTO => g.aoimp, PA_COMDA => g.aomda)   tasa ,
                      pq_cr_seguro_desgravamen.fn_tasa_desgravamen(g.pgcod,
                                                                   g.aomod,
                                                                   g.aosuc,
                                                                   g.aomda,
                                                                   g.aopap,
                                                                   g.aocta,
                                                                   g.aooper,
                                                                   g.aosbop,
                                                                   g.aotope,
                                                                   g.aoimp) tasa,
                      to_char(e.pp1fech, 'mm') mes,
                      e.pp1fech fecha_pago,
                      j.itimp1 pago_prima --,
      -- (select s.trnom from fst034 s where s.pgcod = 1 and s.trmod = j.itmod and s.trnro = j.ittran) tran , j.*
        from fsd601 d,
             fsd602 e,
             fsd611 f,
             fpp001 t,
             fsd010 g,
             fsd016 j,
             FST811 w,
             fst001 n,
             fst810 v,
             fsr008 a,
             fsd001 p,
             fsd011 k
       where g.pgcod = k.pgcod
         and g.aomod = k.scmod
         and g.aosuc = k.scsuc
         and g.aomda = k.scmda
         and g.aopap = k.scpap
         and g.aocta = k.sccta
         and g.aooper = k.scoper
         and g.aosbop = k.scsbop
         and g.aotope = k.sctope
         and p.pepais = a.pepais
         and p.petdoc = a.petdoc
         and p.pendoc = a.pendoc
         and a.pgcod = g.pgcod
         and a.ctnro = g.aocta
         and a.cttfir = 'T'
         and a.ttcod = 1
         and w.pgcod = v.pgcod
         and w.regcod = v.regcod
         and w.pgcod = n.pgcod
         and w.oficod = n.sucurs
         and v.regcod < 100
         and n.sucurs = g.aosuc
         and t.pgcod = d.pgcod
         and t.aomod = d.ppmod
         and d.ppsuc = t.aosuc
         and d.ppmda = t.aomda
         and d.pppap = t.aopap
         and d.ppcta = t.aocta
         and d.ppoper = t.aooper
         and d.ppsbop = t.aosbop
         and d.pptope = t.aotope
         and e.pgcod = d.pgcod
         and e.ppmod = d.ppmod
         and e.ppsuc = d.ppsuc
         and e.ppmda = d.ppmda
         and e.pppap = d.pppap
         and e.ppcta = d.ppcta
         and e.ppoper = d.ppoper
         and e.ppsbop = d.ppsbop
         and e.pptope = d.pptope
         and e.ppfpag = d.ppfpag
         and f.pgcod = d.pgcod
         and f.ppmod = d.ppmod
         and f.ppsuc = d.ppsuc
         and f.ppmda = d.ppmda
         and f.pppap = d.pppap
         and f.ppcta = d.ppcta
         and f.ppoper = d.ppoper
         and f.ppsbop = d.ppsbop
         and f.pptope = d.pptope
         and f.ppfpag = d.ppfpag
         and g.pgcod = d.pgcod
         and g.aomod = d.ppmod
         and g.aosuc = d.ppsuc
         and g.aomda = d.ppmda
         and g.aopap = d.pppap
         and g.aocta = d.ppcta
         and g.aooper = d.ppoper
         and g.aosbop = d.ppsbop
         and g.aotope = d.pptope
         and j.pgcod = e.d602cd
         and j.itmod = e.d602mo
         and j.itsuc = e.d602su
         and j.ittran = e.d602tr
         and j.itnrel = e.d602re
            --and j.ctnro in (2056, 9807,  5323,  29625, 214  , 1099,  3110,  10005, 9142)
         and j.rubro in (2514020000005, 2524020000005)
            --and j.itfval = d.d601fc
         and e.pp1fech between to_date(P_FECINI, 'DD/MM/RR') and
             to_date(P_FECFIN, 'DD/MM/RR')
         and t.sgcod in (select i.tp1imp1
                           from fst198 i
                          where i.tp1cod1 = 10898
                            and i.tp1corr1 = 8)
         and n.sucurs in
             (select OfiCod
                from fst811 -- mpostigoc 20160505
               Where Pgcod = 1
                 and RegCod in (select RegCod
                                   from fst810 f -- mpostigoc 270416
                                  where Pgcod = 1
                                    and RegCod < 100));
    --   and n.sucurs = decode(P_AGENCIA, 0, n.sucurs, P_AGENCIA);

    CURSOR PAGOH(P_FECINI varchar2, P_FECFIN varchar2) IS
      select distinct upper(v.regnom) region,
                      n.scnom agencia,
                      lpad(g.aocta, 9, '0') || lpad(g.aomda, 3, '0') ||
                      lpad(g.aooper, 9, '0') credito,
                      p.penom cliente,
                      (select m.tdnom
                         from fst014 m
                        where m.tdocum = p.petdoc) petdoc,
                      p.pendoc,
                      (select q.pffnac
                         from fsd002 q
                        where q.pfpais = p.pepais
                          and q.pftdoc = p.petdoc
                          and q.pfndoc = p.pendoc) fec_nacimiento,
                      fn_analista_credito(g.aomod,
                                          g.aosuc,
                                          g.aomda,
                                          g.aopap,
                                          g.aocta,
                                          g.aooper,
                                          g.aosbop,
                                          g.aotope) analista,
                      (case
                        when k.scgru = 2 then
                         'MICROEMPRESAS'
                        when k.scgru = 3 and substr(k.scrub, 11, 3) = '015' then
                         'CONSUMO REVOLVENTE'
                        when k.scgru = 3 and substr(k.scrub, 11, 3) <> '015' then
                         'CONSUMO NO REVOLVENTE'
                        when k.scgru = 4 then
                         'HIPOTECARIO'
                        when k.scgru = 10 then
                         'GRANDES EMPRESAS'
                        when k.scgru = 12 then
                         'MEDIANA EMPRESA'
                        when k.scgru = 13 then
                         'PEQUEÑA EMPRESA'
                        when k.scgru in (5, 6, 7, 8, 9, 10) then
                         'CORPORATIVO'
                      END) tipo_credito,
                      (select u.mosign
                         from FST005 u
                        where u.moneda = g.aomda) moneda,
                      g.aoimp mto_desembolsado,
                      -1 * (k.scsdo) scsdo,
                      g.aofval fecha_desembolso,
                      g.aoperiod periodo,
                      --FN_TASA_DESGRAVAMEN(PA_COMOD => g.aomod,PA_CUENTA => g.aocta, PA_MONTO => g.aoimp ,PA_COMDA => g.aomda)   tasa ,
                      pq_cr_seguro_desgravamen.fn_tasa_desgravamen(g.pgcod,
                                                                   g.aomod,
                                                                   g.aosuc,
                                                                   g.aomda,
                                                                   g.aopap,
                                                                   g.aocta,
                                                                   g.aooper,
                                                                   g.aosbop,
                                                                   g.aotope,
                                                                   g.aoimp) tasa,
                      to_char(e.pp1fech, 'mm') mes,
                      e.pp1fech fecha_pago,
                      j.hcimp1 pago_prima --,
      -- (select s.trnom from fst034 s where s.pgcod = 1 and s.trmod = j.itmod and s.trnro = j.ittran) tran , j.*
        from fsd601 d,
             fsd602 e,
             fsd611 f,
             fpp001 t,
             fsd010 g,
             fsh016 j,
             FST811 w,
             fst001 n,
             fst810 v,
             fsr008 a,
             fsd001 p,
             fsd011 k
       where g.pgcod = k.pgcod
         and g.aomod = k.scmod
         and g.aosuc = k.scsuc
         and g.aomda = k.scmda
         and g.aopap = k.scpap
         and g.aocta = k.sccta
         and g.aooper = k.scoper
         and g.aosbop = k.scsbop
         and g.aotope = k.sctope
         and p.pepais = a.pepais
         and p.petdoc = a.petdoc
         and p.pendoc = a.pendoc
         and a.pgcod = g.pgcod
         and a.ctnro = g.aocta
         and a.cttfir = 'T'
         and a.ttcod = 1
         and w.pgcod = v.pgcod
         and w.regcod = v.regcod
         and w.pgcod = n.pgcod
         and w.oficod = n.sucurs
         and v.regcod < 100
         and n.sucurs = g.aosuc
         and t.pgcod = d.pgcod
         and t.aomod = d.ppmod
         and d.ppsuc = t.aosuc
         and d.ppmda = t.aomda
         and d.pppap = t.aopap
         and d.ppcta = t.aocta
         and d.ppoper = t.aooper
         and d.ppsbop = t.aosbop
         and d.pptope = t.aotope
         and e.pgcod = d.pgcod
         and e.ppmod = d.ppmod
         and e.ppsuc = d.ppsuc
         and e.ppmda = d.ppmda
         and e.pppap = d.pppap
         and e.ppcta = d.ppcta
         and e.ppoper = d.ppoper
         and e.ppsbop = d.ppsbop
         and e.pptope = d.pptope
         and e.ppfpag = d.ppfpag
         and f.pgcod = d.pgcod
         and f.ppmod = d.ppmod
         and f.ppsuc = d.ppsuc
         and f.ppmda = d.ppmda
         and f.pppap = d.pppap
         and f.ppcta = d.ppcta
         and f.ppoper = d.ppoper
         and f.ppsbop = d.ppsbop
         and f.pptope = d.pptope
         and f.ppfpag = d.ppfpag
         and g.pgcod = d.pgcod
         and g.aomod = d.ppmod
         and g.aosuc = d.ppsuc
         and g.aomda = d.ppmda
         and g.aopap = d.pppap
         and g.aocta = d.ppcta
         and g.aooper = d.ppoper
         and g.aosbop = d.ppsbop
         and g.aotope = d.pptope
         AND j.hfcon = e.d602fc
         and j.pgcod = e.d602cd
         and j.hcmod = e.d602mo
         and j.hsucor = e.d602su
         and j.htran = e.d602tr
         and j.hnrel = e.d602re
            --and j.ctnro in (2056, 9807,  5323,  29625, 214  , 1099,  3110,  10005, 9142)
         and j.hrubro in (2514020000005, 2524020000005)
            --and j.itfval = d.d601fc
            --and e.pp1fech between to_date(P_FECINI,'DD/MM/RR') and to_date(P_FECFIN,'DD/MM/RR')
         and j.hfcon between to_date(P_FECINI, 'DD/MM/RR') and
             to_date(P_FECFIN, 'DD/MM/RR')
         and t.sgcod in (select i.tp1imp1
                           from fst198 i
                          where i.tp1cod1 = 10898
                            and i.tp1corr1 = 8)
           and n.sucurs in
             (select OfiCod
                from fst811 -- mpostigoc 20160505
               Where Pgcod = 1
                 and RegCod in (select RegCod
                                   from fst810 f -- mpostigoc 20160505
                                  where Pgcod = 1
                                    and RegCod < 100));

  BEGIN

    delete jaqy959 T
     WHERE T.JAQY959NIP = PA_NROIP
       AND T.JAQY959USU = PA_USUARIO;
    COMMIT;

    if PA_FECFIN = FN_FECHA_APERTURA THEN
      /*ACTUAL*/

      FOR P in PAGO(PA_FECINI, PA_FECFIN) LOOP
        coor := coor + 1;

        insert into JAQY959
          (JAQY959NIP,
           JAQY959USU,
           JAQY959COR,
           JAQY959REG,
           JAQY959SUC,
           JAQY959CRE,
           JAQY959CLI,
           JAQY959TDO,
           JAQY959NDO,
           JAQY959FEN,
           JAQY959ANA,
           JAQY959TCR,
           JAQY959MON,
           JAQY959MTD,
           JAQY959SDO,
           JAQY959FED,
           JAQY959PER,
           JAQY959TAS,
           JAQY959MES,
           JAQY959FPG,
           JAQY959PPR)
        values
          (PA_NROIP,
           PA_USUARIO,
           coor,
           p.region,
           p.agencia,
           p.credito,
           p.cliente,
           p.petdoc,
           p.pendoc,
           p.fec_nacimiento,
           p.analista,
           p.tipo_credito,
           p.moneda,
           p.mto_desembolsado,
           p.scsdo,
           p.fecha_desembolso,
           p.periodo,
           p.tasa,
           p.mes,
           p.fecha_pago,
           p.pago_prima);

      END LOOP;
      commit;
    end if;

    /*HISTORICO*/

    FOR P in PAGOH( PA_FECINI, PA_FECFIN) LOOP
      coor := coor + 1;

      insert into JAQY959
        (JAQY959NIP,
         JAQY959USU,
         JAQY959COR,
         JAQY959REG,
         JAQY959SUC,
         JAQY959CRE,
         JAQY959CLI,
         JAQY959TDO,
         JAQY959NDO,
         JAQY959FEN,
         JAQY959ANA,
         JAQY959TCR,
         JAQY959MON,
         JAQY959MTD,
         JAQY959SDO,
         JAQY959FED,
         JAQY959PER,
         JAQY959TAS,
         JAQY959MES,
         JAQY959FPG,
         JAQY959PPR)
      values
        (PA_NROIP,
         PA_USUARIO,
         coor,
         p.region,
         p.agencia,
         p.credito,
         p.cliente,
         p.petdoc,
         p.pendoc,
         p.fec_nacimiento,
         p.analista,
         p.tipo_credito,
         p.moneda,
         p.mto_desembolsado,
         p.scsdo,
         p.fecha_desembolso,
         p.periodo,
         p.tasa,
         p.mes,
         p.fecha_pago,
         p.pago_prima);

    END LOOP;

    commit;

  end SP_CR_SINREGION;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function FN_TASA_DESGRAVAMEN(PA_PGCOD  number,
                               PA_AOMOD  number,
                               PA_AOSUC  number,
                               PA_AOMDA  number,
                               PA_AOPAP  number,
                               PA_AOCTA  number,
                               PA_AOOPER number,
                               PA_AOSBOP number,
                               PA_AOTOPE number,
                               PA_MONTO  number) return number IS
    --PA_COMOD number, PA_CUENTA number, PA_MONTO number, PA_COMDA NUMBER ) return number IS

    TASA NUMBER(17, 6);

  BEGIN

    begin
      select z.cotasap
        INTO TASA
        from FSP026 z
       where z.pgcod = 1
         and z.comod = PA_AOMOD
         AND Z.COMDA = PA_AOMDA
         and z.cocod in
             (pq_cr_seguro_desgravamen.fn_cod_comision(pa_pgcod,
                                                       pa_aomod,
                                                       pa_aosuc,
                                                       pa_aomda,
                                                       pa_aopap,
                                                       pa_aocta,
                                                       pa_aooper,
                                                       pa_aosbop,
                                                       pa_aotope))
         and z.cocta = pa_aocta
         and z.comto in (SELECT min(case
                                      when PA_MONTO <= s.comto then
                                       s.comto
                                    end) t1
                           FROM FSP026 s
                          WHERE 1 = s.pgcod
                            and s.COMOD = PA_AOMOD
                            AND s.COMDA = PA_AOMDA
                            AND s.COCOD in
                                (pq_cr_seguro_desgravamen.fn_cod_comision(pa_pgcod,
                                                                          pa_aomod,
                                                                          pa_aosuc,
                                                                          pa_aomda,
                                                                          pa_aopap,
                                                                          pa_aocta,
                                                                          pa_aooper,
                                                                          pa_aosbop,
                                                                          pa_aotope))
                            and s.cocta = pa_aocta);

    exception
      when others then
        begin

          select z.cotasap
            INTO TASA
            from FSP026 z
           where z.pgcod = 1
             and z.comod = PA_AOMOD
             AND Z.COMDA = PA_AOMDA
             and z.cocod in
                 (pq_cr_seguro_desgravamen.fn_cod_comision(pa_pgcod,
                                                           pa_aomod,
                                                           pa_aosuc,
                                                           pa_aomda,
                                                           pa_aopap,
                                                           pa_aocta,
                                                           pa_aooper,
                                                           pa_aosbop,
                                                           pa_aotope))
             and z.cocta = 0
             and z.comto in (SELECT min(case
                                          when PA_MONTO <= s.comto then
                                           s.comto
                                        end) t1
                               FROM FSP026 s
                              WHERE 1 = s.pgcod
                                and s.COMOD = PA_AOMOD
                                AND s.COMDA = PA_AOMDA
                                AND s.COCOD in
                                    (pq_cr_seguro_desgravamen.fn_cod_comision(pa_pgcod,
                                                                              pa_aomod,
                                                                              pa_aosuc,
                                                                              pa_aomda,
                                                                              pa_aopap,
                                                                              pa_aocta,
                                                                              pa_aooper,
                                                                              pa_aosbop,
                                                                              pa_aotope))
                                and s.cocta = 0);
        exception
          when others then
            return 0;
        end;
    end;

    RETURN TASA;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;

  END;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  FUNCTION FN_FECHA_APERTURA RETURN varchar IS
    FECAPE DATE;
  BEGIN
    select T.PGFAPE INTO FECAPE from FST017 T WHERE T.PGCOD = 1;
    return to_char(FECAPE, 'dd/mm/rr');
  EXCEPTION
    WHEN OTHERS THEN
      RETURN SYSDATE;
  END;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_TASA_DESGRAVAMEN(PA_PGCOD  number,
                                PA_AOMOD  number,
                                PA_AOSUC  number,
                                PA_AOMDA  number,
                                PA_AOPAP  number,
                                PA_AOCTA  number,
                                PA_AOOPER number,
                                PA_AOSBOP number,
                                PA_AOTOPE number,
                                PA_MONTO  number,
                                PA_TASA   out number) is

    TASA NUMBER(17, 6);
    pd_fecha  date;
    pn_tipcam number(17,6);
    monto     number(17,2);
    tipseg    char(1);
    codigo    number;
    pais      number;
    tdoc      number;
    ndoc      char(12);
    edad      number;
  BEGIN

    begin
      select z.cotasap
        INTO TASA
        from FSP026 z
       where z.pgcod = 1
         and z.comod = PA_AOMOD
         AND Z.COMDA = PA_AOMDA
         and z.cocod in
             (pq_cr_seguro_desgravamen.fn_cod_comision(pa_pgcod,
                                                       pa_aomod,
                                                       pa_aosuc,
                                                       pa_aomda,
                                                       pa_aopap,
                                                       pa_aocta,
                                                       pa_aooper,
                                                       pa_aosbop,
                                                       pa_aotope))
         and z.cocta = pa_aocta
         and z.comto in (SELECT min(case
                                      when PA_MONTO <= s.comto then
                                       s.comto
                                    end) t1
                           FROM FSP026 s
                          WHERE 1 = s.pgcod
                            and s.COMOD = PA_AOMOD
                            AND s.COMDA = PA_AOMDA
                            AND s.COCOD in
                                (pq_cr_seguro_desgravamen.fn_cod_comision(pa_pgcod,
                                                                          pa_aomod,
                                                                          pa_aosuc,
                                                                          pa_aomda,
                                                                          pa_aopap,
                                                                          pa_aocta,
                                                                          pa_aooper,
                                                                          pa_aosbop,
                                                                          pa_aotope))
                            and s.cocta = pa_aocta);

    exception
      when others then
        begin

          select z.cotasap
            INTO TASA
            from FSP026 z
           where z.pgcod = 1
             and z.comod = PA_AOMOD
             AND Z.COMDA = PA_AOMDA
             and z.cocod in
                 (pq_cr_seguro_desgravamen.fn_cod_comision(pa_pgcod,
                                                           pa_aomod,
                                                           pa_aosuc,
                                                           pa_aomda,
                                                           pa_aopap,
                                                           pa_aocta,
                                                           pa_aooper,
                                                           pa_aosbop,
                                                           pa_aotope))
             and z.cocta = 0
             and z.comto in (SELECT min(case
                                          when PA_MONTO <= s.comto then
                                           s.comto
                                        end) t1
                               FROM FSP026 s
                              WHERE 1 = s.pgcod
                                and s.COMOD = PA_AOMOD
                                AND s.COMDA = PA_AOMDA
                                AND s.COCOD in
                                    (pq_cr_seguro_desgravamen.fn_cod_comision(pa_pgcod,
                                                                              pa_aomod,
                                                                              pa_aosuc,
                                                                              pa_aomda,
                                                                              pa_aopap,
                                                                              pa_aocta,
                                                                              pa_aooper,
                                                                              pa_aosbop,
                                                                              pa_aotope))
                                and s.cocta = 0);
        exception
          when others then
            TASA := 0;
        end;
    end;
    ---------------ACtualizacion Nuevas condiciones SMA 09/2024---------------------------------

    Begin
          select 'B', a.sgcod
            into tipseg, codigo
            from fpp001 a
           where a.pgcod = PA_PGCOD
             and a.aomod = PA_AOMOD
             and a.aosuc = PA_AOSUC
             and a.aomda = PA_AOMDA
             and a.aopap = PA_AOPAP
             and a.aocta = PA_AOCTA
             and a.aooper = PA_AOOPER
             and a.aosbop = PA_AOSBOP
             and a.aotope = PA_AOTOPE
             and a.sgcod in (select sgcod
                               from fst300
                              where sgsn02 = '5'
                                and sgtxt like '%Basico%'
                                and sgcod >= 350 )
             and rownum = 1;
        exception
          when no_data_found then
            Begin
              select 'D', a.sgcod
                into tipseg, codigo
                from fpp001 a
               where a.pgcod = PA_PGCOD
                 and a.aomod = PA_AOMOD
                 and a.aosuc = PA_AOSUC
                 and a.aomda = PA_AOMDA
                 and a.aopap = PA_AOPAP
                 and a.aocta = PA_AOCTA
                 and a.aooper = PA_AOOPER
                 and a.aosbop = PA_AOSBOP
                 and a.aotope = PA_AOTOPE
                 and a.sgcod in (select sgcod
                                   from fst300
                                  where sgsn02 = '5'
                                    and sgtxt like '%Devol%'
                                    and sgcod >= 350 )
                 and rownum = 1;
             exception
               when no_data_found then
                  tipseg:='B';
             end;
        end;

    if tipseg = 'D' then --seguro Devolución
      Begin
        select pepais, petdoc, pendoc
          into pais,tdoc,ndoc
          from fsr008 where ctnro = PA_AOCTA and ttcod = 1 and cttfir ='T';
      exception
        when no_data_found then
          ndoc := '0';
      end;
      if tdoc = 9 then
         select PFPAI1, PFTDO1, PFNDO1
           into pais, tdoc, ndoc
           from fsr003
          where PJPAIS = pais
            and PJTDOC = tdoc
            and PJNDOC = ndoc
            and VICOD = 7;
      end if;
      Begin
        select (trunc(months_between(sysdate,pffnac)/12,0))
          into edad
          from fsd002 where pfpais = pais and pftdoc = tdoc and pfndoc = ndoc;
      exception
        when no_data_found then
          edad:= 0;
      end;
      if edad >= 18 and edad <= 60 then
        tasa := 1.75;
      elsif edad >= 61 and edad <= 70 then
        tasa := 3.50;
      elsif edad >= 71 and edad <= 80 then
        tasa := 8.30;
      end if;


    else --seguro Básico
      if tasa  = 0 or tasa = 0.05 then
        pd_fecha  := last_day(add_months(sysdate,-1));
        pn_tipcam := fn_tipo_cambio_fijo(pd_fecha);
        if PA_AOMOD = 107 then
          Begin
            select 0.075
              into tasa
              from fpp001 a
             where a.pgcod = PA_PGCOD
               and a.aomod = PA_AOMOD
               and a.aosuc = PA_AOSUC
               and a.aomda = PA_AOMDA
               and a.aopap = PA_AOPAP
               and a.aocta = PA_AOCTA
               and a.aooper = PA_AOOPER
               and a.aosbop = PA_AOSBOP
               and a.aotope = PA_AOTOPE
               and a.sgcod in (select sgcod
                                 from fst300
                                where sgsn02 = '5'
                                  and sgtxt like '%Basico%'
                                  and sgcod >= 350 )
               and rownum = 1;
          exception
            when no_data_found then
              Begin
                select PP001PORC
                  into tasa
                  from fpp001 a
                 where a.pgcod = PA_PGCOD
                   and a.aomod = PA_AOMOD
                   and a.aosuc = PA_AOSUC
                   and a.aomda = PA_AOMDA
                   and a.aopap = PA_AOPAP
                   and a.aocta = PA_AOCTA
                   and a.aooper = PA_AOOPER
                   and a.aosbop = PA_AOSBOP
                   and a.aotope = PA_AOTOPE
                   and a.sgcod  in (select sgcod
                                     from fst300
                                    where sgsn02 = '5'
                                      and sgtxt not like '%Basico%'
                                      and sgcod >= 350 )
                  and rownum = 1;
               exception
                 when no_data_Found then
                   tasa:= 0.075;
               end;
          end;
        else
          if pa_aomda = 0 then ---soles
            if pa_monto <= 20000 then
              tasa := 0.17;
            elsif  pa_monto >= 20001 and  pa_monto <= 50000 then
              tasa := 0.13;
            elsif  pa_monto >= 50001 and  pa_monto <= 100000 then
              tasa := 0.1;
            elsif pa_monto >= 100001 then
              tasa := 0.075;
            end if;
          else -- dolares
          --  monto := pa_monto/pn_tipcam;
            if pa_monto <= 7000 then
              tasa := 0.17;
            elsif  pa_monto >= 7001 and  pa_monto <= 18000 then
              tasa := 0.13;
            elsif  pa_monto >= 18001 and  pa_monto <= 35000 then
              tasa := 0.1;
            elsif pa_monto >= 35001 then
              tasa := 0.075;
            end if;
          end if;
        end if;
      end if;
    end if;
    PA_tasa := TASA;
  EXCEPTION
    WHEN OTHERS THEN
      PA_TASA := 0;

  END;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_MONTO_PRIMA(pa_pgcod  number,
                           pa_ppmod  number,
                           pa_ppsuc  number,
                           pa_ppmda  number,
                           pa_pppap  number,
                           pa_ppcta  number,
                           pa_ppoper number,
                           pa_ppsbop number,
                           pa_pptope number,
                           PA_monto  out number) IS

    cursor cronograma is
      select *
        from fsd601
       where pgcod = pa_pgcod
         and ppmod = pa_ppmod
         and ppsuc = pa_ppsuc
         and ppmda = pa_ppmda
         and pppap = pa_pppap
         and ppcta = pa_ppcta
         and ppoper = pa_ppoper
         and ppsbop = pa_ppsbop
         and pptope = pa_pptope;

    ln_mtodes   number := 0;
    ln_monto    number := 0;
    ln_montoI   number := 0;
    ln_salcap   number := 0;
    ln_tasa     number;
    ln_mda      number;
    ln_periodo  number;
    ln_tipper   number;
    ln_contador number := 0;
    ln_factor   number;
    ln_cuota    number;
    ln_cociente number;
    ln_residuo  number;
    ln_num      number;
    ln_pergra   number := 0;
    ln_valor    number := 0;
    ld_fecval   date;
    ld_feccuo   date;

  BEGIN
    begin
      select aoimp, f.aomda, f.aoperiod, f.aofval
        into ln_mtodes, ln_mda, ln_periodo, ld_fecval
        from FSD010 f
       where f.pgcod = pa_pgcod
         and f.aomod = pa_ppmod
         and f.aosuc = pa_ppsuc
         and f.aomda = pa_ppmda
         and f.aopap = pa_pppap
         and f.aocta = pa_ppcta
         and f.aooper = pa_ppoper
         and f.aosbop = pa_ppsbop
         and f.aotope = pa_pptope;
    exception
      when others then
        ln_mtodes := 0;
    end;

    ln_tasa := pq_cr_seguro_desgravamen.fn_tasa_desgravamen(pa_pgcod  => pa_pgcod,
                                                            pa_aomod  => pa_ppmod,
                                                            pa_aosuc  => pa_ppsuc,
                                                            pa_aomda  => pa_ppmda,
                                                            pa_aopap  => pa_pppap,
                                                            pa_aocta  => pa_ppcta,
                                                            pa_aooper => pa_ppoper,
                                                            pa_aosbop => pa_ppsbop,
                                                            pa_aotope => pa_pptope,
                                                            pa_monto  => ln_mtodes);

    ln_tasa := ln_tasa / 100;

    ln_tipper := pq_cr_seguro_desgravamen.fn_periodo(pa_aoperiod => ln_periodo);

    --determinar dias gracia
    begin
      select min(ppfpag)
        into ld_feccuo
        from fsd601
       where pgcod = pa_pgcod
         and ppmod = pa_ppmod
         and ppsuc = pa_ppsuc
         and ppmda = pa_ppmda
         and pppap = pa_pppap
         and ppcta = pa_ppcta
         and ppoper = pa_ppoper
         and ppsbop = pa_ppsbop
         and pptope = pa_pptope;
    exception
      when others then
        ld_feccuo := null;
    end;

    case
      when ln_tipper = 1 then
        ln_cuota  := 30;
        ln_pergra := 1;
        ln_factor := 1;
      when ln_tipper = 2 then
        ln_cuota  := 4;
        ln_pergra := 7;
        ln_factor := 1;
      when ln_tipper = 3 then
        ln_cuota  := 2;
        ln_pergra := 15;
        ln_factor := 1;
      when ln_tipper = 4 then
        ln_tasa   := ln_tasa * 1;
        ln_pergra := 30;
        ln_factor := 1;
        ln_valor  := (ld_feccuo - ld_fecval) / ln_pergra;
        case
          when ln_valor >= 2 then
            ln_valor := 2;
          when ln_valor >= 1 then
            ln_valor := 1;
          else
            ln_valor := 0;
        end case;
      when ln_tipper = 5 then
        ln_tasa   := ln_tasa * 1;
        ln_pergra := 45;
        ln_factor := 1;
        ln_valor  := (ld_feccuo - ld_fecval) / ln_pergra;
        if ln_valor > 1 then
          ln_valor := 1;
        else
          ln_valor := 0;
        end if;

      when ln_tipper = 6 then
        ln_tasa   := ln_tasa * 1;
        ln_pergra := 60;
        ln_factor := 2;
        ln_valor  := (ld_feccuo - ld_fecval) / ln_pergra;
        if ln_valor > 1 then
          ln_valor := 1;
        else
          ln_valor := 0;
        end if;
      when ln_tipper = 7 then
        ln_tasa   := ln_tasa * 1;
        ln_pergra := 90;
        ln_factor := 3;
        ln_valor  := (ld_feccuo - ld_fecval) / ln_pergra;
        if ln_valor > 1 then
          ln_valor := 1;
        else
          ln_valor := 0;
        end if;
      when ln_tipper = 8 then
        ln_tasa   := ln_tasa * 1;
        ln_pergra := 120;
        ln_factor := 4;
      when ln_tipper = 9 then
        ln_tasa   := ln_tasa * 1;
        ln_pergra := 180;
        ln_factor := 6;
    end case;

    ---------------

    Case
      when ln_tipper in (4) then
        --obtiene monto tasa
        ln_monto  := round(ln_mtodes * ln_tasa, 2) * ln_valor;
        ln_salcap := ln_mtodes;
        ln_monto  := pq_cr_seguro_desgravamen.fn_monto(ln_monto, pa_ppmda);
        for i in cronograma loop

          ln_salcap := ln_salcap - i.ppcap;
          if ln_salcap > 0 then
            ln_montoI := round(ln_salcap * ln_tasa, 2);

            ln_montoI := pq_cr_seguro_desgravamen.fn_monto(ln_montoI,
                                                           pa_ppmda);

            ln_monto := ln_monto + ln_montoI;
          end if;

        end loop;

      when ln_tipper in (6, 7, 8, 9) then
        --obtiene monto tasa
        ln_monto  := round(ln_mtodes * ln_tasa, 2);
        ln_monto  := pq_cr_seguro_desgravamen.fn_monto(ln_monto, pa_ppmda);
        ln_monto  := ln_monto * (ln_factor + ln_valor);
        ln_salcap := ln_mtodes;

        for i in cronograma loop

          ln_salcap := ln_salcap - i.ppcap;
          if ln_salcap > 0 then
            ln_montoI := round(ln_salcap * ln_tasa, 2);
            ln_montoI := pq_cr_seguro_desgravamen.fn_monto(ln_montoI,
                                                           pa_ppmda);
            /*if pa_ppmda = 0 then
               if ln_montoI < 1 then --- 1 soles
                   ln_montoI := 1;
               end if;
            else
               if ln_montoI < 0.35 then  --0.35 dolares
                   ln_montoI := 0.35;
               end if;
            end if;*/
            ln_montoI := ln_montoI * ln_factor;
            ln_monto  := ln_monto + ln_montoI;
          end if;
          ln_contador := ln_contador + 1;
        end loop;

      when ln_tipper in (1, 2, 3) then
        --obtiene monto tasa
        ln_contador := ln_contador + 1;

        ln_monto  := round(ln_mtodes * ln_tasa, 2);
        ln_monto  := pq_cr_seguro_desgravamen.fn_monto(ln_monto, pa_ppmda);
        ln_monto  := ln_monto * ln_factor;
        ln_salcap := ln_mtodes;
        ln_num    := ln_contador + ln_cuota;
        for i in cronograma loop

          ln_contador := ln_contador + 1;
          ln_salcap   := ln_salcap - i.ppcap;

          if ln_contador = ln_num then
            if ln_salcap > 0 then
              ln_montoI := round(ln_salcap * ln_tasa, 2);
              ln_montoI := pq_cr_seguro_desgravamen.fn_monto(ln_montoI,
                                                             pa_ppmda);
              /*if pa_ppmda = 0 then
                 if ln_montoI < 1 then --- 1 soles
                     ln_montoI := 1;
                 end if;
              else
                 if ln_montoI < 0.35 then  --0.35 dolares
                     ln_montoI := 0.35;
                 end if;
              end if;*/
              ln_montoI := ln_montoI * ln_factor;
              ln_monto  := ln_monto + ln_montoI;
            end if;
            ln_num := ln_contador + ln_cuota;
          end if;
        end loop;
      when ln_tipper in (5) then
        --obtiene monto tasa
        ln_contador := ln_contador + 1;
        if ln_contador = 1 then
          ln_factor := 2;
        end if;
        ln_monto  := round(ln_mtodes * ln_tasa, 2);
        ln_monto  := pq_cr_seguro_desgravamen.fn_monto(ln_monto, pa_ppmda);
        ln_monto  := ln_monto * ln_factor;
        ln_salcap := ln_mtodes;

        for i in cronograma loop
          ln_contador := ln_contador + 1;

          ln_cociente := trunc(ln_contador / 2); --obtener entero
          ln_residuo  := ln_contador - (ln_cociente * 2);
          if ln_residuo = 1 then
            ln_factor := 2;
          else
            ln_factor := 1;
          end if;

          ln_salcap := ln_salcap - i.ppcap;
          if ln_salcap > 0 then
            ln_montoI := round(ln_salcap * ln_tasa, 2);
            ln_montoI := pq_cr_seguro_desgravamen.fn_monto(ln_montoI,
                                                           pa_ppmda);
            /*if pa_ppmda = 0 then
               if ln_montoI < 1 then --- 1 soles
                   ln_montoI := 1;
               end if;
            else
               if ln_montoI < 0.35 then  --0.35 dolares
                   ln_montoI := 0.35;
               end if;
            end if;*/
            ln_montoI := ln_montoI * ln_factor;
            ln_monto  := ln_monto + ln_montoI;
          end if;
        end loop;

    End case;

    PA_MONTO := ln_monto;

  EXCEPTION
    WHEN OTHERS THEN
      PA_MONTO := 0;

  END;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  FUNCTION fn_MONTO_PRIMA(pa_pgcod  number,
                          pa_ppmod  number,
                          pa_ppsuc  number,
                          pa_ppmda  number,
                          pa_pppap  number,
                          pa_ppcta  number,
                          pa_ppoper number,
                          pa_ppsbop number,
                          pa_pptope number) return number IS

    cursor cronograma is
      select *
        from fsd601
       where pgcod = pa_pgcod
         and ppmod = pa_ppmod
         and ppsuc = pa_ppsuc
         and ppmda = pa_ppmda
         and pppap = pa_pppap
         and ppcta = pa_ppcta
         and ppoper = pa_ppoper
         and ppsbop = pa_ppsbop
         and pptope = pa_pptope;

    ln_mtodes   number := 0;
    ln_monto    number := 0;
    ln_montoI   number := 0;
    ln_salcap   number := 0;
    ln_tasa     number;
    ln_mda      number;
    ln_periodo  number;
    ln_tipper   number;
    ln_contador number := 0;
    ln_factor   number;
    ln_cuota    number;
    ln_cociente number;
    ln_residuo  number;
    ln_num      number;
    ln_valor    number := 0;
    ln_pergra   number := 0;
    ld_fecval   date;
    ld_feccuo   date;

  BEGIN
    begin
      select aoimp, f.aomda, f.aoperiod, f.aofval
        into ln_mtodes, ln_mda, ln_periodo, ld_fecval --smarquez 17102019
        from FSD010 f
       where f.pgcod = pa_pgcod
         and f.aomod = pa_ppmod
         and f.aosuc = pa_ppsuc
         and f.aomda = pa_ppmda
         and f.aopap = pa_pppap
         and f.aocta = pa_ppcta
         and f.aooper = pa_ppoper
         and f.aosbop = pa_ppsbop
         and f.aotope = pa_pptope;
    exception
      when others then
        ln_mtodes := 0;
    end;

    --obtiene tasa
    ln_tasa := pq_cr_seguro_desgravamen.fn_tasa_desgravamen(pa_pgcod  => pa_pgcod,
                                                            pa_aomod  => pa_ppmod,
                                                            pa_aosuc  => pa_ppsuc,
                                                            pa_aomda  => pa_ppmda,
                                                            pa_aopap  => pa_pppap,
                                                            pa_aocta  => pa_ppcta,
                                                            pa_aooper => pa_ppoper,
                                                            pa_aosbop => pa_ppsbop,
                                                            pa_aotope => pa_pptope,
                                                            pa_monto  => ln_mtodes);
    ln_tasa := ln_tasa / 100;

    ln_tipper := pq_cr_seguro_desgravamen.fn_periodo(pa_aoperiod => ln_periodo);

    begin
      select min(ppfpag)
        into ld_feccuo
        from fsd601
       where pgcod = pa_pgcod
         and ppmod = pa_ppmod
         and ppsuc = pa_ppsuc
         and ppmda = pa_ppmda
         and pppap = pa_pppap
         and ppcta = pa_ppcta
         and ppoper = pa_ppoper
         and ppsbop = pa_ppsbop
         and pptope = pa_pptope;
    exception
      when others then
        ld_feccuo := null;
    end;

    case
      when ln_tipper = 1 then
        ln_cuota  := 30;
        ln_pergra := 1;
        ln_factor := 1;
      when ln_tipper = 2 then
        ln_cuota  := 4;
        ln_pergra := 7;
        ln_factor := 1;
      when ln_tipper = 3 then
        ln_cuota  := 2;
        ln_pergra := 15;
        ln_factor := 1;
      when ln_tipper = 4 then
        ln_tasa   := ln_tasa * 1;
        ln_pergra := 30;
        ln_factor := 1;
        ln_valor  := (ld_feccuo - ld_fecval) / ln_pergra;
        case
          when ln_valor >= 2 then
            ln_valor := 2;
          when ln_valor >= 1 then
            ln_valor := 1;
          else
            ln_valor := 0;
        end case;
      when ln_tipper = 5 then
        ln_tasa   := ln_tasa * 1;
        ln_pergra := 45;
        ln_factor := 1;
        ln_valor  := (ld_feccuo - ld_fecval) / ln_pergra;
        if ln_valor > 1 then
          ln_valor := 1;
        else
          ln_valor := 0;
        end if;

      when ln_tipper = 6 then
        ln_tasa   := ln_tasa * 1;
        ln_pergra := 60;
        ln_factor := 2;
        ln_valor  := (ld_feccuo - ld_fecval) / ln_pergra;
        if ln_valor > 1 then
          ln_valor := 1;
        else
          ln_valor := 0;
        end if;
      when ln_tipper = 7 then
        ln_tasa   := ln_tasa * 1;
        ln_pergra := 90;
        ln_factor := 3;
        ln_valor  := (ld_feccuo - ld_fecval) / ln_pergra;
        if ln_valor > 1 then
          ln_valor := 1;
        else
          ln_valor := 0;
        end if;
      when ln_tipper = 8 then
        ln_tasa   := ln_tasa * 1;
        ln_pergra := 120;
        ln_factor := 4;
      when ln_tipper = 9 then
        ln_tasa   := ln_tasa * 1;
        ln_pergra := 180;
        ln_factor := 6;
    end case;

    ---------------;

    Case
      when ln_tipper in (4) then
        --obtiene monto tasa
        ln_monto  := round(ln_mtodes * ln_tasa, 2) * ln_valor;
        ln_salcap := ln_mtodes;
        ln_monto  := pq_cr_seguro_desgravamen.fn_monto(ln_monto, pa_ppmda);
        for i in cronograma loop

          ln_salcap := ln_salcap - i.ppcap;
          if ln_salcap > 0 then
            ln_montoI := round(ln_salcap * ln_tasa, 2);

            ln_montoI := pq_cr_seguro_desgravamen.fn_monto(ln_montoI,
                                                           pa_ppmda);

            ln_monto := ln_monto + ln_montoI;
          end if;

        end loop;

      when ln_tipper in (6, 7, 8, 9) then
        --obtiene monto tasa
        ln_monto  := round(ln_mtodes * ln_tasa, 2);
        ln_monto  := pq_cr_seguro_desgravamen.fn_monto(ln_monto, pa_ppmda);
        ln_monto  := ln_monto * (ln_factor + ln_valor);
        ln_salcap := ln_mtodes;

        for i in cronograma loop

          ln_salcap := ln_salcap - i.ppcap;
          if ln_salcap > 0 then
            ln_montoI := round(ln_salcap * ln_tasa, 2);
            ln_montoI := pq_cr_seguro_desgravamen.fn_monto(ln_montoI,
                                                           pa_ppmda);
            /*if pa_ppmda = 0 then
               if ln_montoI < 1 then --- 1 soles
                   ln_montoI := 1;
               end if;
            else
               if ln_montoI < 0.35 then  --0.35 dolares
                   ln_montoI := 0.35;
               end if;
            end if;*/
            ln_montoI := ln_montoI * ln_factor;
            ln_monto  := ln_monto + ln_montoI;
          end if;
          ln_contador := ln_contador + 1;
        end loop;

      when ln_tipper in (1, 2, 3) then
        --obtiene monto tasa
        ln_contador := ln_contador + 1;

        ln_monto  := round(ln_mtodes * ln_tasa, 2);
        ln_monto  := pq_cr_seguro_desgravamen.fn_monto(ln_monto, pa_ppmda);
        ln_monto  := ln_monto * ln_factor;
        ln_salcap := ln_mtodes;
        ln_num    := ln_contador + ln_cuota;
        for i in cronograma loop

          ln_contador := ln_contador + 1;
          ln_salcap   := ln_salcap - i.ppcap;

          if ln_contador = ln_num then
            if ln_salcap > 0 then
              ln_montoI := round(ln_salcap * ln_tasa, 2);
              ln_montoI := pq_cr_seguro_desgravamen.fn_monto(ln_montoI,
                                                             pa_ppmda);
              /*if pa_ppmda = 0 then
                 if ln_montoI < 1 then --- 1 soles
                     ln_montoI := 1;
                 end if;
              else
                 if ln_montoI < 0.35 then  --0.35 dolares
                     ln_montoI := 0.35;
                 end if;
              end if;*/
              ln_montoI := ln_montoI * ln_factor;
              ln_monto  := ln_monto + ln_montoI;
            end if;
            ln_num := ln_contador + ln_cuota;
          end if;
        end loop;
      when ln_tipper in (5) then
        --obtiene monto tasa
        ln_contador := ln_contador + 1;
        if ln_contador = 1 then
          ln_factor := 2;
        end if;
        ln_monto  := round(ln_mtodes * ln_tasa, 2);
        ln_monto  := pq_cr_seguro_desgravamen.fn_monto(ln_monto, pa_ppmda);
        ln_monto  := ln_monto * ln_factor;
        ln_salcap := ln_mtodes;

        for i in cronograma loop
          ln_contador := ln_contador + 1;

          ln_cociente := trunc(ln_contador / 2); --obtener entero
          ln_residuo  := ln_contador - (ln_cociente * 2);
          if ln_residuo = 1 then
            ln_factor := 2;
          else
            ln_factor := 1;
          end if;

          ln_salcap := ln_salcap - i.ppcap;
          if ln_salcap > 0 then
            ln_montoI := round(ln_salcap * ln_tasa, 2);
            ln_montoI := pq_cr_seguro_desgravamen.fn_monto(ln_montoI,
                                                           pa_ppmda);
            /*if pa_ppmda = 0 then
               if ln_montoI < 1 then --- 1 soles
                   ln_montoI := 1;
               end if;
            else
               if ln_montoI < 0.35 then  --0.35 dolares
                   ln_montoI := 0.35;
               end if;
            end if;*/
            ln_montoI := ln_montoI * ln_factor;
            ln_monto  := ln_monto + ln_montoI;
          end if;
        end loop;

    End case;

    return ln_monto;

  EXCEPTION
    WHEN OTHERS THEN
      return 0;

  END;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function FN_COD_COMISION(PA_PGCOD  number,
                           PA_AOMOD  number,
                           PA_AOSUC  number,
                           PA_AOMDA  number,
                           PA_AOPAP  number,
                           PA_AOCTA  number,
                           PA_AOOPER number,
                           PA_AOSBOP number,
                           PA_AOTOPE number) return number IS

    ln_comision NUMBER;
    ln_sgcod    NUMBER;

  BEGIN

    begin
      select sgcod
        into ln_sgcod
        from fpp001
       where PGCOD = PA_PGCOD
         and AOMOD = PA_AOMOD
         and AOSUC = PA_AOSUC
         and AOMDA = PA_AOMDA
         and AOPAP = PA_AOPAP
         and AOCTA = PA_AOCTA
         and AOOPER = PA_AOOPER
         and AOSBOP = PA_AOSBOP
         and AOTOPE = PA_AOTOPE
         and SGCOD in (select tp1imp1
                         from fst198 f
                        where f.tp1cod = 1
                          and f.tp1cod1 = 10898
                          and f.tp1corr1 = 8);
    exception
      when others then
        ln_sgcod := 0;
    end;

    begin
      select sgcd03 into ln_comision from fst300 where sgcod = ln_sgcod;
    exception
      when no_Data_found then
        ln_comision := 0;
    end;

    RETURN ln_comision;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;

  END;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function Fn_Periodo(pa_aoperiod number) return number IS

    lc_periodo varchar2(20);
    ln_numero  number;

  begin

    case
      when pa_aoperiod = 1 then
        lc_periodo := 'DIARIO';
        ln_numero  := 1;
      when pa_aoperiod = 7 then
        lc_periodo := 'SEMANAL';
        ln_numero  := 2;
      when pa_aoperiod >= 10 and pa_aoperiod <= 20 then
        lc_periodo := 'QUINCENAL'; --15
        ln_numero  := 3;
      when pa_aoperiod >= 25 and pa_aoperiod <= 35 then
        lc_periodo := 'MENSUAL'; --30
        ln_numero  := 4;
      when pa_aoperiod >= 40 and pa_aoperiod <= 50 then
        lc_periodo := 'MESYMEDIO'; --45
        ln_numero  := 5;
      when pa_aoperiod >= 55 and pa_aoperiod <= 65 then
        lc_periodo := 'BIMENSUAL'; --60
        ln_numero  := 6;
      when pa_aoperiod >= 85 and pa_aoperiod <= 95 then
        lc_periodo := 'TRIMESTRAL'; --90
        ln_numero  := 7;
      when pa_aoperiod >= 115 and pa_aoperiod <= 125 then
        lc_periodo := 'CUATRIMESTRE'; --120
        ln_numero  := 8;
      when pa_aoperiod >= 175 and pa_aoperiod <= 185 then
        lc_periodo := 'SEMESTRAL'; --180
        ln_numero  := 9;
      else
        ln_numero := 4; --caso contrario toma calculo mensual
    End case;

    return ln_numero;

  End Fn_Periodo;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function Fn_Monto(pa_monto number, pa_ppmda number) return number IS

    ln_montoI number;

  begin
    ln_montoI := pa_monto;

    if pa_ppmda = 0 then
      if ln_montoI < 1 then
        --- 1 soles
        ln_montoI := 1;
      end if;
    else
      if ln_montoI < 0.35 then
        --0.35 dolares
        ln_montoI := 0.35;
      end if;
    end if;

    return ln_montoI;

  End Fn_Monto;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_Permanencia(pa_ppcta     in number,
                           pp_fecpro    in date,
                           pa_indicador out varchar2) IS

    cursor creditos(plazo in number) is
      select *
        from fsd010 f, fst111 g
       where f.pgcod = 1
         and f.aomod = g.modulo
         and g.dscod = 50
         and f.aomod not in (108, 141)
         and f.aofval >= pp_fecpro - plazo
         and f.aocta = pa_ppcta
       order by aofval;

    ld_aofval date;
    ld_aofe99 date;

    ln_plazo      number;
    ln_dias       number;
    ln_diferencia number;
    ln_contador   number := -999;

    ln_cont      number := 0;
    ln_calculo   number := 0;
    lc_indcre    char(1) := 'N';
    lc_indicador varchar2(1);

  begin

    begin
      select tp1nro1, tp1nro2
        into ln_plazo, ln_dias
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 10898
         and tp1corr1 = 15;
    end;

    begin

      For i in creditos(ln_plazo) loop
        lc_indcre := 'S';
        if ln_cont = 0 then
          ld_aofval := i.aofval;
          ld_aofe99 := i.aofe99;
          --to_date('0001.01.01','yyyy.mm.dd')
        else
          if ld_aofe99 < ld_aofval and
             ld_aofe99 > to_date('0001.01.01', 'yyyy.mm.dd') then
            --ln_calculo := i.aofval - ld_aofval;
            ln_calculo := ld_aofval - ld_aofe99 + 1;
          end if;
          if ld_aofval < i.aofval then
            ld_aofval := i.aofval;
          end if;

          if ld_aofe99 < ld_aofval and
             ld_aofe99 > to_date('0001.01.01', 'yyyy.mm.dd') then
            --ln_calculo := i.aofval - ld_aofval;
            ln_calculo := ld_aofval - ld_aofe99 + 1;
          end if;

          if ld_aofe99 < i.aofe99 then
            ld_aofe99 := i.aofe99;
          end if;

          if ln_contador < ln_calculo then
            ln_contador := ln_calculo;
          end if;
          if ln_contador > 180 then
            exit;
          end if;

        end if;
        ln_cont := ln_cont + 1;

      end loop;

    end;

    --si lc_indcre = N no existen creditos
    --si calculo  = 0 tiene creditos que no superan los 180 dias entre desembolso y cancelacion
    --si lc_indcre = S tiene creditos con antiguedad
    --si calculo  > 180 posee creditos cuya cancelacion y siguiente desembolso excede 180.

    if lc_indcre = 'N' then
      lc_indicador := 'N'; --no existen creditos en periodo 2 años
    else
      if ln_calculo <= 180 then
        lc_indicador := 'S'; --cumple permanencia
      else
        lc_indicador := 'N'; --No cumple permanencia
      end if;
    end if;

    pa_indicador := lc_indicador;

  End sp_Permanencia;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_TASA_DESGRA_APP(PA_MONTO  IN NUMBER,
                               PA_CODSEG IN NUMBER,
                               PA_TIPSEG IN VARCHAR2,
                               TASA     OUT NUMBER)IS
  BEGIN
    IF PA_TIPSEG = 'BASICO' THEN
        if pa_monto <= 20000 then
              tasa := 0.17;
        elsif  pa_monto >= 20001 and  pa_monto <= 50000 then
          tasa := 0.13;
        elsif  pa_monto >= 50001 and  pa_monto <= 100000 then
          tasa := 0.1;
        elsif pa_monto >= 100001 then
          tasa := 0.075;
        end if;
    ELSE
      tasa := 1.75;
    END IF;
  END sp_TASA_DESGRA_APP;
END PQ_CR_SEGURO_DESGRAVAMEN;
/

