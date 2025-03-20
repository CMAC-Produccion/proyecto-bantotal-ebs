create or replace package PQ_CR_REPORTE25 is

  -- *****************************************************************
  -- Nombre                     : paquete para cargar informacion para el reporte25 
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 22/10/2021
  -- Autor de Creación          : YYAMPI
  -- Uso                        : paquete de rutinas generar informacion para el reporte25
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha Modificacion         : 15/12/2021 yyampi se cambio para que el tipo de cambio se obtenga de la tabla de tipos de cambios FsH005
  --                              15/12/2021 yyampi se modifico para creditos castigados condonados que no tiene registro en el maestro de castigos 
  --                              16/12/2021 yyampi se agrego las guias de proceso en los grupos
  --                              14/10/2024 yyampi se optimizo el tiempo de proceso sp_cr_castigos, sp_cr_pagos_castigos, sp_cr_condonaciones, sp_cr_pagos_castigos_ext, sp_cr_venta
  --                              03/03/2025 mhuamania se hizo el manejo de errores al eliminar tabla aqpb811
  -- *****************************************************************

  procedure sp_cr_carga(pd_fecha  date,
                        pn_tipcam number,
                        pv_flag   out varchar2);

  procedure sp_cr_castigos(pd_fecha  date,
                           pn_tipcam number,
                           pv_flag   out varchar2);

  procedure sp_cr_pagos_castigos(pd_fecha  date,
                                 pn_tipcam number,
                                 pv_flag   out varchar2);

  procedure sp_cr_condonaciones(pd_fecha  date,
                                pn_tipcam number,
                                pv_flag   out varchar2);

  procedure sp_cr_pagos_castigos_ext(pd_fecha  date,
                                     pn_tipcam number,
                                     pv_flag   out varchar2);

  procedure sp_cr_venta(pd_fecha  date,
                        pn_tipcam number,
                        pv_flag   out varchar2);

  function sp_cr_tipSBS(pn_tipsbs number
                        
                        ) return varchar2;

  procedure sp_cr_generaR25(pd_fecha  date,
                            pn_tipcam number,
                            pv_flag   out varchar2);

  procedure sp_cr_generaR25_Venta(pd_fecha  date,
                                  pn_tipcam number,
                                  pv_flag   out varchar2);

  procedure sp_cr_generaR25_Castigo(pd_fecha  date,
                                    pn_tipcam number,
                                    pv_flag   out varchar2);

  procedure sp_cr_generaR25_Condonado(pd_fecha  date,
                                      pn_tipcam number,
                                      pv_flag   out varchar2);

  FUNCTION FN_CR_REPORTE25_TIPCRE25(BNJ096SUC IN NUMBER,
                                    BNJ096MDA IN NUMBER,
                                    BNJ096PAP IN NUMBER,
                                    BNJ096CTA IN NUMBER,
                                    BNJ096OPE IN NUMBER,
                                    BNJ096SUB IN NUMBER,
                                    BNJ096MOD IN NUMBER,
                                    BNJ096TOP IN NUMBER) RETURN NUMBER;

  FUNCTION FN_CR_REPORTE25_CODSBS(BNJ096SUC IN NUMBER,
                                  BNJ096MDA IN NUMBER,
                                  BNJ096PAP IN NUMBER,
                                  BNJ096CTA IN NUMBER,
                                  BNJ096OPE IN NUMBER,
                                  BNJ096SUB IN NUMBER,
                                  BNJ096MOD IN NUMBER,
                                  BNJ096TOP IN NUMBER) RETURN VARCHAR;

  PROCEDURE SP_tipSBS(pn_cta     in number,
                      pn_ope     in number,
                      pn_mod     in number,
                      pc_sbs     in varchar2,
                      cod_tipsbs OUT varchar2);

  FUNCTION FN_CR_REPORTE25_TIPCRE2(BNJ096SUC IN NUMBER,
                                   BNJ096MDA IN NUMBER,
                                   BNJ096PAP IN NUMBER,
                                   BNJ096CTA IN NUMBER,
                                   BNJ096OPE IN NUMBER,
                                   BNJ096SUB IN NUMBER,
                                   BNJ096MOD IN NUMBER,
                                   BNJ096TOP IN NUMBER) RETURN NUMBER;

end PQ_CR_REPORTE25;
/

create or replace package body PQ_CR_REPORTE25 is

  procedure sp_cr_carga(pd_fecha  date,
                        pn_tipcam number,
                        pv_flag   out varchar2) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_carga
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 22/10/2021
    -- Autor de Creación          : YYAMPI
    -- Uso                        : Carga toda la informacion para el reporte 25
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 15/12/2021 yyampi se cambio para que el tipo de cambio se obtenga de la tabla de tipos de cambios FsH005
    -- *****************************************************************
  
    pv_flagCAS  VARCHAR2(40) := 'S'; --MSG ERROR CASTIGO 
    pv_flagPCAS VARCHAR2(40) := 'S'; --MSG ERROR PAGOS
    pv_flagCCAS VARCHAR2(40) := 'S'; --MSG ERROR CONDONADOS 
    pv_flagECAS VARCHAR2(40) := 'S'; --MSG ERROR EXTORNOS
    pv_flagVCAS VARCHAR2(40) := 'S'; --MSG ERROR VENTA
    ln_tipcam   NUMBER(14, 8);
  
  begin
  
    /*borrar la tabla*/
    begin
    delete from aqpb811;
    exception
      when others then
        rollback;
    end;
   -- EXECUTE IMMEDIATE 'TRUNCATE TABLE aqpb811' ;
    
    /*obtener tipo de cambio segun fecha ingresada*/
    begin
      select e.cotcbi
        INTO ln_tipcam
        FROM FsH005 e
       WHERE e.MONEDA = 101
         AND e.COFDES in (pd_fecha);
    exception
      when others then
        ln_tipcam := 0;
    end;
  
    /*insertar data*/
  
    sp_cr_castigos(pd_fecha  => pd_fecha,
                   pn_tipcam => ln_tipcam,
                   pv_flag   => pv_flagCAS);
    sp_cr_pagos_castigos(pd_fecha  => pd_fecha,
                         pn_tipcam => ln_tipcam,
                         pv_flag   => pv_flagPCAS);
    sp_cr_condonaciones(pd_fecha  => pd_fecha,
                        pn_tipcam => ln_tipcam,
                        pv_flag   => pv_flagCCAS);
    sp_cr_pagos_castigos_ext(pd_fecha  => pd_fecha,
                             pn_tipcam => ln_tipcam,
                             pv_flag   => pv_flagECAS);
    sp_cr_venta(pd_fecha  => pd_fecha,
                pn_tipcam => ln_tipcam,
                pv_flag   => pv_flagVCAS);
    pv_flag := 'S';
    COMMIT;
  
  exception
    WHEN OTHERS THEN
      pv_flag := 'ERROR CARGA: ' || pv_flagCAS || '-' || pv_flagPCAS || '-' ||
                 pv_flagCCAS || '-' || pv_flagECAS || '-' || pv_flagVCAS;
      ROLLBACK;
    
  end sp_cr_carga;

  --------------------------------------------------------------------------

  procedure sp_cr_castigos(pd_fecha  date,
                           pn_tipcam number,
                           pv_flag   OUT varchar2) IS
    -- *****************************************************************
    -- Nombre                     : sp_cr_castigos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 22/10/2021
    -- Autor de Creación          : YYAMPI
    -- Uso                        : Carga toda la informacion de castigo para el reporte 25
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 14/10/2024 yyampi se optimizo el tiempo de proceso
    -- *****************************************************************
  
    lv_ano    varchar(4) := '';
    lv_mes    varchar(2) := '';
    lv_dia    varchar(2) := '01';
    ld_fecini date;
  BEGIN
  
    lv_ano := to_char(pd_fecha, 'RRRR');
    lv_mes := lpad(to_char(pd_fecha, 'MM'), 2, '0');
  
    ld_fecini := to_date(lv_dia || lv_mes || lv_ano, 'DDMMRRRR');
  
    insert into AQPB811
      (AQPB811FEC,
       AQPB811CSU,
       AQPB811SUC,
       AQPB811MDA,
       AQPB811TDOC,
       AQPB811NDOC,
       AQPB811TITU,
       AQPB811CTA,
       AQPB811OPE,
       AQPB811SUB,
       AQPB811IMP,
       AQPB811MODT,
       AQPB811SUCT,
       AQPB811TRAT,
       AQPB811TRAN,
       AQPB811RELT,
       AQPB811FET,
       AQPB811FEV,
       AQPB811HOR,
       AQPB811ESC,
       AQPB811UST,
       AQPB811TIS,
       AQPB811SBN,
       AQPB811GRU,
       AQPB811MMN)
    
      select /*+ all_rows*/
      /*to_date('2021.09.30','rrrr.mm.dd')*/
       pd_fecha AQPB811FEC,
       b.hsucur AQPB811CSU,
       (select g.scnom
          from fst001 g
         where g.pgcod = 1
           and g.sucurs = b.HSUCUR) AQPB811SUC,
       --b.hrubro rubro,
       b.hmda   AQPB811MDA,
       c.petdoc AQPB811TDOC,
       d.pendoc AQPB811NDOC,
       d.penom  AQPB811TITU,
       b.hcta   AQPB811CTA,
       b.hoper  AQPB811OPE,
       b.hsubop AQPB811SUB,
       --  b.hcafgt ,
       b.hcimp1 AQPB811IMP,
       a.hcmod  AQPB811MODT,
       a.hsucor AQPB811SUT,
       a.htran  AQPB811TRAT,
       z.trnom  AQPB811TRAN,
       a.hnrel  AQPB811RELT,
       --  b.hcodmo modo,
       a.hfcon  AQPB811FET,
       a.hfvc   AQPB811FEV,
       a.hhora  AQPB811HOR,
       a.hccorr AQPB811ESC,
       a.husing AQPB811UST,
       --2 AQPB811TIS,
       /*FN_CR_REPORTE25_TIPCRE(BNJ096SUC => B.HSUCUR,
       BNJ096MDA => B.HMDA,
       BNJ096PAP => B.HPAP,
       BNJ096CTA => B.HCTA,
       BNJ096OPE => B.HOPER,
       BNJ096SUB => B.HCSUBO,
       BNJ096MOD => B.HMODUL,
       BNJ096TOP => B.HTOPER)*/
       substr(b.hrubro, 5, 2) * 1 AQPB811TIS,
       sp_cr_tipsbs(pn_tipsbs => substr(b.hrubro, 5, 2) * 1) AQPB811SBN,
       '1. CASTIGADO' AQPB811GRU,
       decode(b.hmda, 0, 1, pn_tipcam) * b.hcimp1 AQPB811MMN
        from fsh015 /*_r25*/ a,
             fsh016 /*_r25*/ b,
             fsr008 c,
             fsd001 d,
             fst034 z --, fst001 g
       where a.pgcod = b.pgcod
         and a.hcmod = b.hcmod
         and a.hsucor = b.hsucor
         and a.htran = b.htran
         and a.hnrel = b.hnrel
         and a.hfcon = b.hfcon
         and a.pgcod = 1
         and b.PGCOD = 1
            -- and b.hmda = 0  ---moneda
            --and b.hmodul = 33
         and b.hcord = 10 --ordinal donde se encuentra el codigo del credito      
         and a.hfvc >= ld_fecini --to_date('01052021', 'ddmmrrrr')
         and a.hfvc <= pd_fecha --to_date('31052021', 'ddmmrrrr')      
         and b.hcta = c.ctnro
         and c.PEPAIS = d.PEPAIS
         and c.PETDOC = d.PETDOC
         and c.pendoc = d.pendoc
         and c.cttfir = 'T'
         and c.TTCOD = 1
         and b.pgcod = z.pgcod
         and b.hcmod = z.trmod
         and b.htran = z.trnro
            --and b.hcmod = 98
            --and b.htran = 310
         and (a.hcmod, a.htran) in -- transaccion de castigo  --cambio 14/10/2024 
             (select t.tp1nro1, t.tp1nro2
                from fst198 t
               where t.tp1cod = 1
                 and t.tp1cod1 = 11150
                 and t.tp1corr1 = 2
                 and t.tp1corr2 = 1
                 and t.tp1nro3 = 1)
      
      union
      
      select /*+ all_rows */
      distinct pd_fecha AQPB811FEC,
               b.hsucur AQPB811CSU,
               (select g.scnom
                  from fst001 g
                 where g.pgcod = 1
                   and g.sucurs = b.HSUCUR) AQPB811SUC,
               --b.hrubro rubro,
               b.hmda   AQPB811MDA,
               c.petdoc AQPB811TDOC,
               d.pendoc AQPB811NDOC,
               d.penom  AQPB811TITU,
               b.hcta   AQPB811CTA,
               b.hoper  AQPB811OPE,
               b.hsubop AQPB811SUB,
               --  b.hcafgt ,
               /*b.hcimp1*/
               0        AQPB811IMP,
               a.hcmod  AQPB811MODT,
               a.hsucor AQPB811SUT,
               a.htran  AQPB811TRAT,
               z.trnom  AQPB811TRAN,
               a.hnrel  AQPB811RELT,
               --  b.hcodmo modo,
               a.hfcon  AQPB811FET,
               a.hfvc   AQPB811FEV,
               a.hhora  AQPB811HOR,
               a.hccorr AQPB811ESC,
               a.husing AQPB811UST,
               --2 AQPB811TIS,
               FN_CR_REPORTE25_TIPCRE(BNJ096SUC => B.HSUCUR,
                                      BNJ096MDA => B.HMDA,
                                      BNJ096PAP => B.HPAP,
                                      BNJ096CTA => B.HCTA,
                                      BNJ096OPE => B.HOPER,
                                      BNJ096SUB => B.HCSUBO,
                                      BNJ096MOD => B.HMODUL,
                                      BNJ096TOP => B.HTOPER) AQPB811TIS,
               sp_cr_tipsbs(pn_tipsbs => FN_CR_REPORTE25_TIPCRE(BNJ096SUC => B.HSUCUR,
                                                                BNJ096MDA => B.HMDA,
                                                                BNJ096PAP => B.HPAP,
                                                                BNJ096CTA => B.HCTA,
                                                                BNJ096OPE => B.HOPER,
                                                                BNJ096SUB => B.HCSUBO,
                                                                BNJ096MOD => B.HMODUL,
                                                                BNJ096TOP => B.HTOPER)) AQPB811SBN,
               '1. CASTIGADO' AQPB811GRU,
               0 AQPB811MMN
        from fsh015 a, fsh016 b, fsr008 c, fsd001 d, fst034 z --, fst001 g
       where a.pgcod = b.pgcod
         and a.hcmod = b.hcmod
         and a.hsucor = b.hsucor
         and a.htran = b.htran
         and a.hnrel = b.hnrel
         and a.hfcon = b.hfcon
         and a.pgcod = 1
         and b.PGCOD = 1
            -- and b.hmda = 0  ---moneda
            -- and b.hmodul = 33    
            --and b.hmodul = 451   
         and a.hfvc >= ld_fecini --to_date('01092021', 'ddmmrrrr')
         and a.hfvc <= pd_fecha --to_date('30092021', 'ddmmrrrr')
         and substr(b.hrubro, 1, 4) in (8113, 8123, 8119, 8129, 9300)
         and b.hcta = c.ctnro
         and c.PEPAIS = d.PEPAIS
         and c.PETDOC = d.PETDOC
         and c.pendoc = d.pendoc
         and c.cttfir = 'T'
         and c.TTCOD = 1
         and b.pgcod = z.pgcod
         and b.hcmod = z.trmod
         and b.htran = z.trnro
            --and b.hcmod = 98
            --and b.HTRAN = 311
         and (a.hcmod, a.htran) in --  cambio 14/10/2024
             (select t.tp1nro1, t.tp1nro2
                from fst198 t
               where t.tp1cod = 1
                 and t.tp1cod1 = 11150
                 and t.tp1corr1 = 2
                 and t.tp1corr2 = 1
                 and t.tp1nro3 = 2);
  
  exception
    when others then
      pv_flag := 'CASTIGO ERROR:' || SQLERRM;
    
  END;

  ---------------------------------------------------------------------------------------------               
  procedure sp_cr_pagos_castigos(pd_fecha  date,
                                 pn_tipcam number,
                                 pv_flag   out varchar2) IS
  
    -- *****************************************************************
    -- Nombre                     : sp_cr_pagos_castigos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 22/10/2021
    -- Autor de Creación          : YYAMPI
    -- Uso                        : Carga toda la informacion de pagos de castigos para el reporte 25
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 14/10/2024 yyampi se optimizo el tiempo de proceso
    -- *****************************************************************
  
    lv_ano    varchar(4) := '';
    lv_mes    varchar(2) := '';
    lv_dia    varchar(2) := '01';
    ld_fecini date;
  
  BEGIN
  
    lv_ano    := to_char(pd_fecha, 'RRRR');
    lv_mes    := lpad(to_char(pd_fecha, 'MM'), 2, '0');
    ld_fecini := to_date(lv_dia || lv_mes || lv_ano, 'DDMMRRRR');
  
    insert into AQPB811
      (AQPB811FEC,
       AQPB811CSU,
       AQPB811SUC,
       AQPB811MDA,
       AQPB811TDOC,
       AQPB811NDOC,
       AQPB811TITU,
       AQPB811CTA,
       AQPB811OPE,
       AQPB811SUB,
       AQPB811IMP,
       AQPB811MODT,
       AQPB811SUCT,
       AQPB811TRAT,
       AQPB811TRAN,
       AQPB811RELT,
       AQPB811FET,
       AQPB811FEV,
       AQPB811HOR,
       AQPB811ESC,
       AQPB811UST,
       AQPB811TIS,
       AQPB811SBN,
       AQPB811GRU,
       AQPB811MMN)
    
      select /*+ all_rows*/
      /*to_date('2021.09.30','rrrr.mm.dd')*/
      distinct pd_fecha AQPB811FEC,
               b.hsucur AQPB811CSU,
               (select g.scnom
                  from fst001 g
                 where g.pgcod = 1
                   and g.sucurs = b.HSUCUR) AQPB811SUC,
               --b.hrubro rubro,
               b.hmda   AQPB811MDA,
               c.petdoc AQPB811TDOC,
               d.pendoc AQPB811NDOC,
               d.penom  AQPB811TITU,
               b.hcta   AQPB811CTA,
               b.hoper  AQPB811OPE,
               b.hsubop AQPB811SUB,
               --  b.hcafgt ,
               b.hcimp1 AQPB811IMP,
               a.hcmod  AQPB811MODT,
               a.hsucor AQPB811SUT,
               a.htran  AQPB811TRAT,
               z.trnom  AQPB811TRAN,
               a.hnrel  AQPB811RELT,
               --  b.hcodmo modo,
               a.hfcon  AQPB811FET,
               a.hfvc   AQPB811FEV,
               a.hhora  AQPB811HOR,
               a.hccorr AQPB811ESC,
               a.husing AQPB811UST,
               --2 AQPB811TIS,
               '' /*FN_CR_REPORTE25_TIPCRE(BNJ096SUC => B.HSUCUR,
                                                                                                                                              BNJ096MDA => B.HMDA,
                                                                                                                                              BNJ096PAP => B.HPAP,
                                                                                                                                              BNJ096CTA => B.HCTA,
                                                                                                                                              BNJ096OPE => B.HOPER,
                                                                                                                                              BNJ096SUB => B.HCSUBO,
                                                                                                                                              BNJ096MOD => B.HMODUL,
                                                                                                                                              BNJ096TOP => B.HTOPER)*/ AQPB811TIS,
               '' /*sp_cr_tipsbs(pn_tipsbs => FN_CR_REPORTE25_TIPCRE(BNJ096SUC => B.HSUCUR,
                                                                                                                                                                        BNJ096MDA => B.HMDA,
                                                                                                                                                                        BNJ096PAP => B.HPAP,
                                                                                                                                                                        BNJ096CTA => B.HCTA,
                                                                                                                                                                        BNJ096OPE => B.HOPER,
                                                                                                                                                                        BNJ096SUB => B.HCSUBO,
                                                                                                                                                                        BNJ096MOD => B.HMODUL,
                                                                                                                                                                        BNJ096TOP => B.HTOPER))*/ AQPB811SBN,
               '2. PAGO CASTIGADO' AQPB811GRU,
               decode(b.hmda, 0, 1, pn_tipcam) * b.hcimp1 AQPB811MMN
        from fsh015 /*_r25*/ a,
             fsh016 /*_r25*/ b,
             fsr008 c,
             fsd001 d,
             fst034 z --, fst001 g
       where a.pgcod = b.pgcod
         and a.hcmod = b.hcmod
         and a.hsucor = b.hsucor
         and a.htran = b.htran
         and a.hnrel = b.hnrel
         and a.hfcon = b.hfcon
         and a.pgcod = 1
         and b.PGCOD = 1
            -- and b.hmda = 0  ---moneda
         and b.hmodul = 33
         and a.hfvc >= ld_fecini --to_date('01052021', 'ddmmrrrr')
         and a.hfvc <= pd_fecha --to_date('31052021', 'ddmmrrrr')      
         and b.hcta = c.ctnro
         and c.PEPAIS = d.PEPAIS
         and c.PETDOC = d.PETDOC
         and c.pendoc = d.pendoc
         and c.cttfir = 'T'
         and c.TTCOD = 1
         and b.pgcod = z.pgcod
         and b.hcmod = z.trmod
         and b.htran = z.trnro
            --and b.hcmod = 30
            --and b.htran in (407,408) 
         and (a.hcmod, a.htran) in --  cambio 14/10/2024
             (select t.tp1nro1, t.tp1nro2
                from fst198 t
               where t.tp1cod = 1
                 and t.tp1cod1 = 11150
                 and t.tp1corr1 = 2
                 and t.tp1corr2 = 2
                 and t.tp1nro3 = 1);
  
  exception
    when others then
      pv_flag := 'PAG CAS ERROR:' || SQLERRM;
    
  END;

  ---------------------------------------------------------------------------------------------
  procedure sp_cr_condonaciones(pd_fecha  date,
                                pn_tipcam number,
                                pv_flag   out varchar2
                                
                                ) IS
    -- *****************************************************************
    -- Nombre                     : sp_cr_condonaciones
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 22/10/2021
    -- Autor de Creación          : YYAMPI
    -- Uso                        : Carga toda la informacion de condonaciones para el reporte 25
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 15/12/2021 yyampi se modifico para creditos castigados condonados que no tiene registro en el maestro de castigos 
    --                            : 14/10/2024 yyampi se optimizo el tiempo de proceso  
    -- *****************************************************************
    lv_ano    varchar(4) := '';
    lv_mes    varchar(2) := '';
    lv_dia    varchar(2) := '01';
    ld_fecini date;
  
  BEGIN
  
    lv_ano    := to_char(pd_fecha, 'RRRR');
    lv_mes    := lpad(to_char(pd_fecha, 'MM'), 2, '0');
    ld_fecini := to_date(lv_dia || lv_mes || lv_ano, 'DDMMRRRR');
  
    insert into AQPB811
      (AQPB811FEC,
       AQPB811CSU,
       AQPB811SUC,
       AQPB811MDA,
       AQPB811TDOC,
       AQPB811NDOC,
       AQPB811TITU,
       AQPB811CTA,
       AQPB811OPE,
       AQPB811SUB,
       AQPB811IMP,
       AQPB811MODT,
       AQPB811SUCT,
       AQPB811TRAT,
       AQPB811TRAN,
       AQPB811RELT,
       AQPB811FET,
       AQPB811FEV,
       AQPB811HOR,
       AQPB811ESC,
       AQPB811UST,
       AQPB811TIS,
       AQPB811SBN,
       AQPB811GRU,
       AQPB811MMN)
    
    /*condonados no castigados*/
    
      select /*+ all_rows*/
      /*to_date('2021.09.30','rrrr.mm.dd')*/
       pd_fecha AQPB811FEC,
       b.hsucur AQPB811CSU,
       (select g.scnom
          from fst001 g
         where g.pgcod = 1
           and g.sucurs = b.HSUCUR) AQPB811SUC,
       --b.hrubro rubro,
       b.hmda   AQPB811MDA,
       c.petdoc AQPB811TDOC,
       d.pendoc AQPB811NDOC,
       d.penom  AQPB811TITU,
       b.hcta   AQPB811CTA,
       b.hoper  AQPB811OPE,
       b.hsubop AQPB811SUB,
       --  b.hcafgt ,
       b.hcimp1 AQPB811IMP,
       a.hcmod  AQPB811MODT,
       a.hsucor AQPB811SUT,
       a.htran  AQPB811TRAT,
       z.trnom  AQPB811TRAN,
       a.hnrel  AQPB811RELT,
       --  b.hcodmo modo,
       a.hfcon  AQPB811FET,
       a.hfvc   AQPB811FEV,
       a.hhora  AQPB811HOR,
       a.hccorr AQPB811ESC,
       a.husing AQPB811UST,
       --2 AQPB811TIS,
       /*FN_CR_REPORTE25_TIPCRE(BNJ096SUC => B.HSUCUR,
       BNJ096MDA => B.HMDA,
       BNJ096PAP => B.HPAP,
       BNJ096CTA => B.HCTA,
       BNJ096OPE => B.HOPER,
       BNJ096SUB => B.HCSUBO,
       BNJ096MOD => B.HMODUL,
       BNJ096TOP => B.HTOPER)*/
       substr(b.hrubro, 5, 2) * 1 AQPB811TIS,
       pq_cr_reporte25.sp_cr_tipsbs(pn_tipsbs => substr(b.hrubro, 5, 2) * 1) AQPB811SBN,
       '3. CONDONADO' AQPB811GRU,
       decode(b.hmda, 0, 1, pn_tipcam) * b.hcimp1 AQPB811MMN
        from fsh015 /*_r25*/ a,
             fsh016 /*_r25*/ b,
             fsr008 c,
             fsd001 d,
             fst034 z
       where a.pgcod = b.pgcod
         and a.hcmod = b.hcmod
         and a.hsucor = b.hsucor
         and a.htran = b.htran
         and a.hnrel = b.hnrel
         and a.hfcon = b.hfcon
         and a.pgcod = 1
         and b.PGCOD = 1
         and a.hccorr = 0 --mov vigentes
         and b.hcord in (5, 10) --ordinales
            --and b.hmda = 0   ---moneda
            --and b.hrubro in (8119220100001,8119220100003,8119220100004,8119220100005,8119220100006)
            ----cuando la moneda cambia a 101 , reemplazar el 3er digito de cada rubro por 2
         and a.hfvc >= ld_fecini /*to_date('01092021', 'ddmmrrrr')*/
         and a.hfvc <= pd_fecha /*to_date('30092021', 'ddmmrrrr')*/
         and b.hcta = c.ctnro
         and c.PEPAIS = d.PEPAIS
         and c.PETDOC = d.PETDOC
         and c.pendoc = d.pendoc
         and c.cttfir = 'T'
         and b.pgcod = z.pgcod
         and b.hcmod = z.trmod
         and b.htran = z.trnro
            --and b.hcmod = 300
            --and b.htran in (210, 402 )
         and (a.hcmod, a.htran) in (select t.tp1nro1, t.tp1nro2 --  cambio 14/10/2024
                                      from fst198 t
                                     where t.tp1cod = 1
                                       and t.tp1cod1 = 11150
                                       and t.tp1corr1 = 2
                                       and t.tp1corr2 = 4
                                       and t.tp1nro3 in (1, 2) --no castigado
                                    )
      union
      
      /*condonados castigados*/
      select /*+ all_rows*/
      /*to_date('2021.09.30','rrrr.mm.dd')*/
      distinct pd_fecha AQPB811FEC,
               b.hsucur AQPB811CSU,
               (select g.scnom
                  from fst001 g
                 where g.pgcod = 1
                   and g.sucurs = b.HSUCUR) AQPB811SUC,
               --b.hrubro rubro,
               b.hmda   AQPB811MDA,
               c.petdoc AQPB811TDOC,
               d.pendoc AQPB811NDOC,
               d.penom  AQPB811TITU,
               b.hcta   AQPB811CTA,
               b.hoper  AQPB811OPE,
               b.hsubop AQPB811SUB,
               --  b.hcafgt ,
               b.hcimp1 AQPB811IMP,
               a.hcmod  AQPB811MODT,
               a.hsucor AQPB811SUT,
               a.htran  AQPB811TRAT,
               z.trnom  AQPB811TRAN,
               a.hnrel  AQPB811RELT,
               --  b.hcodmo modo,
               a.hfcon  AQPB811FET,
               a.hfvc   AQPB811FEV,
               a.hhora  AQPB811HOR,
               a.hccorr AQPB811ESC,
               a.husing AQPB811UST,
               --2 AQPB811TIS,
               /*FN_CR_REPORTE25_TIPCRE(BNJ096SUC => B.HSUCUR,
               BNJ096MDA => B.HMDA,
               BNJ096PAP => B.HPAP,
               BNJ096CTA => B.HCTA,
               BNJ096OPE => B.HOPER,
               BNJ096SUB => B.HCSUBO,
               BNJ096MOD => B.HMODUL,
               BNJ096TOP => B.HTOPER) */
               (case
                 when h.hrubro is not null then
                  substr(h.hrubro, 5, 2) * 1
                 else
                  FN_CR_REPORTE25_TIPCRE(BNJ096SUC => B.HSUCUR,
                                         BNJ096MDA => B.HMDA,
                                         BNJ096PAP => B.HPAP,
                                         BNJ096CTA => B.HCTA,
                                         BNJ096OPE => B.HOPER,
                                         BNJ096SUB => B.HCSUBO,
                                         BNJ096MOD => B.HMODUL,
                                         BNJ096TOP => B.HTOPER)
               end) AQPB811TIS,
               
               pq_cr_reporte25.sp_cr_tipsbs(pn_tipsbs => (case
                                                           when h.hrubro is not null then
                                                            substr(h.hrubro, 5, 2) * 1
                                                           else
                                                            FN_CR_REPORTE25_TIPCRE(BNJ096SUC => B.HSUCUR,
                                                                                   BNJ096MDA => B.HMDA,
                                                                                   BNJ096PAP => B.HPAP,
                                                                                   BNJ096CTA => B.HCTA,
                                                                                   BNJ096OPE => B.HOPER,
                                                                                   BNJ096SUB => B.HCSUBO,
                                                                                   BNJ096MOD => B.HMODUL,
                                                                                   BNJ096TOP => B.HTOPER)
                                                         end)) AQPB811SBN,
               '3. CONDONADO' AQPB811GRU,
               decode(b.hmda, 0, 1, pn_tipcam) * b.hcimp1 AQPB811MMN
      --,h.hrubro rubcas, 
      --e.jaql175fca, e.jaql175its, e.jaql175itm, e.jaql175itt, e.jaql175itr --, e.*        
        from fsh015 /*_r25*/  a,
             fsh016 /*_r25*/  b,
             fsr008  c,
             fsd001  d,
             fst034  z,
             jaql175 /*_r25*/ e,
             jaql174 /*_r25*/ f,
             fsh016 /*_r25*/  h
       where a.pgcod = b.pgcod
         and a.hcmod = b.hcmod
         and a.hsucor = b.hsucor
         and a.htran = b.htran
         and a.hnrel = b.hnrel
         and a.hfcon = b.hfcon
         and a.pgcod = 1
         and b.PGCOD = 1
         and a.hccorr = 0 --mov vigentes
         and b.hcord in (5) --ordinales
            --and b.hmda = 0   ---moneda
            --and b.hrubro in (8119220100001,8119220100003,8119220100004,8119220100005,8119220100006)
            ----cuando la moneda cambia a 101 , reemplazar el 3er digito de cada rubro por 2
         and a.hfvc >= ld_fecini --to_date('01092021', 'ddmmrrrr')
         and a.hfvc <= pd_fecha --to_date('30092021', 'ddmmrrrr')      
         and b.hcta = c.ctnro
         and c.PEPAIS = d.PEPAIS
         and c.PETDOC = d.PETDOC
         and c.pendoc = d.pendoc
         and c.cttfir = 'T'
         and b.pgcod = z.pgcod
         and b.hcmod = z.trmod
         and b.htran = z.trnro
         and e.jaql174nro = f.jaql174nro(+) --cambio 15/12/2021
         and e.jaql175itc(+) = 'S' --cambio 15/12/2021
         and b.hcta = e.jaql175cta(+) --cambio 15/12/2021 
         and b.hoper = e.jaql175ope(+) --cambio 15/12/2021
         and e.jaql175fca = h.hfcon(+)
         and e.jaql175its = h.hsucor(+)
         and e.jaql175itm = h.hcmod(+)
         and e.jaql175itt = h.htran(+)
         and e.jaql175itr = h.hnrel(+)
         and h.hcord(+) = 10
            --and h.hmodul = 33
            --and b.hcmod = 300
            --and b.htran in (407)
         and (a.hcmod, a.htran) in (select t.tp1nro1, t.tp1nro2 --  cambio 14/10/2024
                                      from fst198 t
                                     where t.tp1cod = 1
                                       and t.tp1cod1 = 11150
                                       and t.tp1corr1 = 2
                                       and t.tp1corr2 = 4
                                       and t.tp1nro3 in (3) --castigado
                                    );
  
  exception
    when others then
      pv_flag := 'CONDO ERROR:' || SQLERRM;
    
  END;

  ---------------------------------------------------------------------------------------------
  procedure sp_cr_pagos_castigos_ext(pd_fecha  date,
                                     pn_tipcam number,
                                     pv_flag   out varchar2) IS
  
    -- *****************************************************************
    -- Nombre                     : sp_cr_pagos_castigos_ext
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 22/10/2021
    -- Autor de Creación          : YYAMPI
    -- Uso                        : Carga toda la informacion de extornos para el reporte 25
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 14/10/2024 yyampi se optimizo el tiempo de proceso  
    -- *****************************************************************
  
    lv_ano    varchar(4) := '';
    lv_mes    varchar(2) := '';
    lv_dia    varchar(2) := '01';
    ld_fecini date;
  
  BEGIN
  
    lv_ano    := to_char(pd_fecha, 'RRRR');
    lv_mes    := lpad(to_char(pd_fecha, 'MM'), 2, '0');
    ld_fecini := to_date(lv_dia || lv_mes || lv_ano, 'DDMMRRRR');
  
    insert into AQPB811
      (AQPB811FEC,
       AQPB811CSU,
       AQPB811SUC,
       AQPB811MDA,
       AQPB811TDOC,
       AQPB811NDOC,
       AQPB811TITU,
       AQPB811CTA,
       AQPB811OPE,
       AQPB811SUB,
       AQPB811IMP,
       AQPB811MODT,
       AQPB811SUCT,
       AQPB811TRAT,
       AQPB811TRAN,
       AQPB811RELT,
       AQPB811FET,
       AQPB811FEV,
       AQPB811HOR,
       AQPB811ESC,
       AQPB811UST,
       AQPB811TIS,
       AQPB811SBN,
       AQPB811GRU,
       AQPB811MMN,
       AQPB811FVAL,
       AQPB811HORD,
       AQPB811MODU)
      select /*+ all_rows*/
      /*to_date('2021.09.30','rrrr.mm.dd')*/
      DISTINCT pd_fecha AQPB811FEC,
               b.hsucur AQPB811CSU,
               (select g.scnom
                  from fst001 g
                 where g.pgcod = 1
                   and g.sucurs = b.HSUCUR) AQPB811SUC,
               --b.hrubro rubro,
               b.hmda   AQPB811MDA,
               c.petdoc AQPB811TDOC,
               d.pendoc AQPB811NDOC,
               d.penom  AQPB811TITU,
               b.hcta   AQPB811CTA,
               b.hoper  AQPB811OPE,
               b.hsubop AQPB811SUB,
               --  b.hcafgt ,
               b.hcimp1 AQPB811IMP,
               a.hcmod  AQPB811MODT,
               a.hsucor AQPB811SUT,
               a.htran  AQPB811TRAT,
               z.trnom  AQPB811TRAN,
               a.hnrel  AQPB811RELT,
               --  b.hcodmo modo,
               a.hfcon  AQPB811FET,
               a.hfvc   AQPB811FEV,
               a.hhora  AQPB811HOR,
               a.hccorr AQPB811ESC,
               a.husing AQPB811UST,
               --2 AQPB811TIS,
               FN_CR_REPORTE25_TIPCRE(BNJ096SUC => B.HSUCUR,
                                      BNJ096MDA => B.HMDA,
                                      BNJ096PAP => B.HPAP,
                                      BNJ096CTA => B.HCTA,
                                      BNJ096OPE => B.HOPER,
                                      BNJ096SUB => B.HCSUBO,
                                      BNJ096MOD => B.HMODUL,
                                      BNJ096TOP => B.HTOPER) AQPB811TIS,
               PQ_CR_REPORTE25.sp_cr_tipsbs(pn_tipsbs => FN_CR_REPORTE25_TIPCRE(BNJ096SUC => B.HSUCUR,
                                                                                BNJ096MDA => B.HMDA,
                                                                                BNJ096PAP => B.HPAP,
                                                                                BNJ096CTA => B.HCTA,
                                                                                BNJ096OPE => B.HOPER,
                                                                                BNJ096SUB => B.HCSUBO,
                                                                                BNJ096MOD => B.HMODUL,
                                                                                BNJ096TOP => B.HTOPER)) AQPB811SBN,
               '4. EXTORNADO' AQPB811GRU,
               decode(b.hmda, 0, 1, pn_tipcam) * b.hcimp1 AQPB811MMN,
               B.HFVAL,
               --decode(B.HMODUL,33,'',B.HFVAL) FECHA_VAL,
               B.HCORD,
               B.HMODUL
        from fsh015 /*_r25*/ a,
             fsh016 /*_r25*/ b,
             fsr008 c,
             fsd001 d,
             fst034 z
       where a.pgcod = b.pgcod
         and a.hcmod = b.hcmod
         and a.hsucor = b.hsucor
         and a.htran = b.htran
         and a.hnrel = b.hnrel
         and a.hfcon = b.hfcon
         and b.hfvco = a.hfvc
         and a.pgcod = 1
         and b.PGCOD = 1
            --and b.hmda = 0   ---moneda
            --and b.hrubro in (8119220100001,8119220100003,8119220100004,8119220100005,8119220100006)
            ----cuando la moneda cambia a 101 , reemplazar el 3er digito de cada rubro por 2
         and a.hfvc >= ld_fecini --to_date('01092021', 'ddmmrrrr')
         and a.hfvc <= pd_fecha --to_date('30092021', 'ddmmrrrr')      
         and b.hcta = c.ctnro
         and c.PEPAIS = d.PEPAIS
         and c.PETDOC = d.PETDOC
         and c.pendoc = d.pendoc
         and c.cttfir = 'T'
         and b.pgcod = z.pgcod
         and (b.hcmod - 500) = z.trmod
         and b.htran = z.trnro
         and b.hmodul in (select K.MODULO from FST111 K WHERE K.DSCOD = 50) --(33,200,305)
            --and b.hcmod in (530,800)
            --and b.HTRAN in (407, 210, 407)
         and (a.hcmod, a.htran) in (select t.tp1nro1, t.tp1nro2 --  cambio 14/10/2024
                                      from fst198 t
                                     where t.tp1cod = 1
                                       and t.tp1cod1 = 11150
                                       and t.tp1corr1 = 2
                                       and t.tp1corr2 = 5 /*and t.tp1nro3 =1*/ -- extornos castigado
                                    )
      
      ;
    ---------------------------------------------------------
  
  exception
    when others then
      pv_flag := 'EXTORNO ERROR:' || SQLERRM;
    
  END;
  ---------------------------------------------------------------------------------------------  
  procedure sp_cr_venta(pd_fecha  date,
                        pn_tipcam number,
                        pv_flag   out varchar2) IS
  
    -- *****************************************************************
    -- Nombre                     : sp_cr_venta
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 22/10/2021
    -- Autor de Creación          : YYAMPI
    -- Uso                        : Carga toda la informacion de venta para el reporte 25
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 14/10/2024 yyampi se optimizo el tiempo de proceso  
    -- *****************************************************************                           
  
    lv_ano    varchar(4) := '';
    lv_mes    varchar(2) := '';
    lv_dia    varchar(2) := '01';
    ld_fecini date;
  BEGIN
  
    lv_ano := to_char(pd_fecha, 'RRRR');
    lv_mes := lpad(to_char(pd_fecha, 'MM'), 2, '0');
  
    ld_fecini := to_date(lv_dia || lv_mes || lv_ano, 'DDMMRRRR');
  
    insert into AQPB811
      (AQPB811FEC,
       AQPB811CSU,
       AQPB811SUC,
       AQPB811MDA,
       AQPB811TDOC,
       AQPB811NDOC,
       AQPB811TITU,
       AQPB811CTA,
       AQPB811OPE,
       AQPB811SUB,
       AQPB811IMP,
       AQPB811MODT,
       AQPB811SUCT,
       AQPB811TRAT,
       AQPB811TRAN,
       AQPB811RELT,
       AQPB811FET,
       AQPB811FEV,
       AQPB811HOR,
       AQPB811ESC,
       AQPB811UST,
       AQPB811TIS,
       AQPB811SBN,
       AQPB811GRU,
       AQPB811MMN,
       AQPB811ESTC)
    
      select /*+ all_rows*/
      /*to_date('2021.09.30','rrrr.mm.dd')*/
       pd_fecha AQPB811FEC,
       b.hsucur AQPB811CSU,
       (select g.scnom
          from fst001 g
         where g.pgcod = 1
           and g.sucurs = b.HSUCUR) AQPB811SUC,
       --b.hrubro rubro,
       b.hmda   AQPB811MDA,
       c.petdoc AQPB811TDOC,
       d.pendoc AQPB811NDOC,
       d.penom  AQPB811TITU,
       b.hcta   AQPB811CTA,
       b.hoper  AQPB811OPE,
       b.hsubop AQPB811SUB,
       --  b.hcafgt ,
       b.hcimp1 AQPB811IMP,
       a.hcmod  AQPB811MODT,
       a.hsucor AQPB811SUT,
       a.htran  AQPB811TRAT,
       z.trnom  AQPB811TRAN,
       a.hnrel  AQPB811RELT,
       --  b.hcodmo modo,
       a.hfcon  AQPB811FET,
       a.hfvc   AQPB811FEV,
       a.hhora  AQPB811HOR,
       a.hccorr AQPB811ESC,
       a.husing AQPB811UST,
       --2 AQPB811TIS,
       FN_CR_REPORTE25_TIPCRE(BNJ096SUC => B.HSUCUR,
                              BNJ096MDA => B.HMDA,
                              BNJ096PAP => B.HPAP,
                              BNJ096CTA => B.HCTA,
                              BNJ096OPE => B.HOPER,
                              BNJ096SUB => B.HCSUBO,
                              BNJ096MOD => B.HMODUL,
                              BNJ096TOP => B.HTOPER) AQPB811TIS,
       sp_cr_tipsbs(pn_tipsbs => FN_CR_REPORTE25_TIPCRE(BNJ096SUC => B.HSUCUR,
                                                        BNJ096MDA => B.HMDA,
                                                        BNJ096PAP => B.HPAP,
                                                        BNJ096CTA => B.HCTA,
                                                        BNJ096OPE => B.HOPER,
                                                        BNJ096SUB => B.HCSUBO,
                                                        BNJ096MOD => B.HMODUL,
                                                        BNJ096TOP => B.HTOPER)) AQPB811SBN,
       '5. VENTA' AQPB811GRU,
       decode(b.hmda, 0, 1, pn_tipcam) * b.hcimp1 AQPB811MMN,
       CASE
         WHEN SUBSTR(B.HRUBRO, 1, 4) IN (1411, 1421) THEN
          '1. Vigente'
         WHEN SUBSTR(B.HRUBRO, 1, 4) IN (1414, 1424) THEN
          '2. Refinanciada y reestructurada'
         WHEN SUBSTR(B.HRUBRO, 1, 4) IN (1415, 1425) THEN
          '3. Vencida'
         WHEN SUBSTR(B.HRUBRO, 1, 4) IN (1416, 1426) THEN
          '4. Cobranza Judicial'
         WHEN SUBSTR(B.HRUBRO, 1, 4) IN (8113, 8123, 8119, 8129) THEN
          '5. Castigada'
       END AQPB811ESTC
      
        from fsh015 /*_r25*/ a,
             fsh016 /*_r25*/ b,
             fsr008 c,
             fsd001 d,
             fst034 z --, fst001 g
       where a.pgcod = b.pgcod
         and a.hcmod = b.hcmod
         and a.hsucor = b.hsucor
         and a.htran = b.htran
         and a.hnrel = b.hnrel
         and a.hfcon = b.hfcon
         and a.pgcod = 1
         and b.PGCOD = 1
            -- and b.hmda = 0  ---moneda
            --and b.hmodul = 33      
         and a.hfvc >= ld_fecini --to_date('01052021', 'ddmmrrrr')
         and a.hfvc <= pd_fecha --to_date('31052021', 'ddmmrrrr')      
         and b.hcta = c.ctnro
         and c.PEPAIS = d.PEPAIS
         and c.PETDOC = d.PETDOC
         and c.pendoc = d.pendoc
         and c.cttfir = 'T'
         and c.TTCOD = 1
         and b.pgcod = z.pgcod
         and b.hcmod = z.trmod
         and b.htran = z.trnro
            --and b.hcmod = 98
            --and b.htran in (314, 313) -- transacciones de venta
         and b.hmodul in (select h.modulo from fst111 h where h.dscod = 50)
         and (a.hcmod, a.htran) in (select t.tp1nro1, t.tp1nro2 --  cambio 14/10/2024
                                      from fst198 t
                                     where t.tp1cod = 1
                                       and t.tp1cod1 = 11150
                                       and t.tp1corr1 = 2
                                       and t.tp1corr2 = 3
                                       and t.tp1nro3 = 1 -- venta
                                    );
  
  exception
    when others then
      pv_flag := 'VENTA ERROR:' || SQLERRM;
    
  END;

  -------------------------------------------------------------------------------------------------

  function sp_cr_tipSBS(pn_tipsbs number
                        
                        ) return varchar2 is
  
    -- *****************************************************************
    -- Nombre                     : sp_cr_tipSBS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 22/10/2021
    -- Autor de Creación          : YYAMPI
    -- Uso                        : devuelve informacion del tipo SBS 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 
    -- ***************************************************************** 
  
    lc_prod varchar2(50) := '';
  begin
  
    CASE
      WHEN pn_tipsbs = 2 THEN
        lc_prod := 'MICROEMPRESA';
      WHEN pn_tipsbs = 3 THEN
        lc_prod := 'CONSUMO';
      WHEN pn_tipsbs = 4 THEN
        lc_prod := 'HIPOTECARIO';
      WHEN pn_tipsbs = 11 THEN
        lc_prod := 'GRANDES EMPRESAS';
      WHEN pn_tipsbs = 12 THEN
        lc_prod := 'MEDIANAS EMPRESAS';
      WHEN pn_tipsbs = 13 THEN
        lc_prod := 'PEQUEÑAS EMPRESAS';
      WHEN pn_tipsbs in (5, 6, 7, 8, 9, 10) THEN
        lc_prod := 'CORPORATIVOS';
      ELSE
        lc_prod := 'OTRO';
    END CASE;
  
    RETURN lc_prod;
  
  EXCEPTION
    WHEN OTHERS THEN
    
      RETURN '';
    
  end;

  -------------------------------------------------------------------------------------------------

  procedure sp_cr_generaR25(pd_fecha  date,
                            pn_tipcam number,
                            pv_flag   out varchar2) IS
    -- *****************************************************************
    -- Nombre                     : sp_cr_generaR25
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 22/10/2021
    -- Autor de Creación          : YYAMPI
    -- Uso                        : genera informacion consolidada para el formato para el reporte 25
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 
    -- *****************************************************************                            
    lv_ano    varchar(4) := '';
    lv_mes    varchar(2) := '';
    lv_dia    varchar(2) := '01';
    ld_fecini date;
    pv_flagV  varchar2(100) := 'S';
    pv_flagC  varchar2(100) := 'S';
    pv_flagO  varchar2(100) := 'S';
  
  BEGIN
  
    lv_ano := to_char(pd_fecha, 'RRRR');
    lv_mes := lpad(to_char(pd_fecha, 'MM'), 2, '0');
  
    ld_fecini := to_date(lv_dia || lv_mes || lv_ano, 'DDMMRRRR');
  
    /*borrado de la tabla*/
    delete from aqpb813;
  
    /*carga de la tabla*/
    sp_cr_generaR25_Venta(pd_fecha  => pd_fecha,
                          pn_tipcam => pn_tipcam,
                          pv_flag   => pv_flagV);
  
    sp_cr_generaR25_Castigo(pd_fecha  => pd_fecha,
                            pn_tipcam => pn_tipcam,
                            pv_flag   => pv_flagC);
  
    sp_cr_generaR25_Condonado(pd_fecha  => pd_fecha,
                              pn_tipcam => pn_tipcam,
                              pv_flag   => pv_flagO);
  
    pv_flag := 'S';
    commit;
  exception
    when others then
      pv_flag := 'R25 ERROR:' || sqlerrm; --pv_flagV||'-'||pv_flagC; 
      rollback;
    
  END;

  -------------------------------------------------------------------------------------------------

  procedure sp_cr_generaR25_Venta(pd_fecha  date,
                                  pn_tipcam number,
                                  pv_flag   out varchar2) IS
    -- *****************************************************************
    -- Nombre                     : sp_cr_generaR25_Venta
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 22/10/2021
    -- Autor de Creación          : YYAMPI
    -- Uso                        : genera informacion consolidada  de venta para el formato para el reporte 25
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 
    -- *****************************************************************                             
    lv_ano    varchar(4) := '';
    lv_mes    varchar(2) := '';
    lv_dia    varchar(2) := '01';
    ld_fecini date;
  
  BEGIN
  
    lv_ano := to_char(pd_fecha, 'RRRR');
    lv_mes := lpad(to_char(pd_fecha, 'MM'), 2, '0');
  
    ld_fecini := to_date(lv_dia || lv_mes || lv_ano, 'DDMMRRRR');
  
    insert into aqpb813
      (aqpb813fec,
       aqpb813gru,
       aqpb813sgr,
       aqpb813cor,
       aqpb813gem,
       aqpb813mem,
       aqpb813pem,
       aqpb813mcm,
       aqpb813con,
       aqpb813hip,
       aqpb813tmn,
       aqpb813imp,
       aqpb813imd)
    
      select distinct pd_fecha,
                      'venta',
                      a.tp1desc,
                      b.COR,
                      b.GEM,
                      b.MEM,
                      b.PEM,
                      b.MIC,
                      b.CON,
                      b.HIP,
                      b.AQPB811MMN,
                      b.AQPB811IMP,
                      b.AQPB811IMD
        from (select *
                from fst198 t
               where t.tp1cod = 1
                 AND T.TP1COD1 = 11150
                 and t.tp1corr1 = 1
                 and t.tp1corr2 = 1
                 and t.tp1corr1 = 1) a,
             (select C.AQPB811ESTC,
                     SUM(CASE
                           WHEN C.AQPB811TIS in (5, 6, 7, 8, 9, 10) then
                            C.AQPB811MMN
                         END) COR,
                     SUM(CASE
                           WHEN C.AQPB811TIS in (11) then
                            C.AQPB811MMN
                         END) GEM,
                     SUM(CASE
                           WHEN C.AQPB811TIS in (12) then
                            C.AQPB811MMN
                         END) MEM,
                     SUM(CASE
                           WHEN C.AQPB811TIS in (13, 0) then
                            C.AQPB811MMN
                         END) PEM,
                     SUM(CASE
                           WHEN C.AQPB811TIS in (2) then
                            C.AQPB811MMN
                         END) MIC,
                     SUM(CASE
                           WHEN C.AQPB811TIS in (3) then
                            C.AQPB811MMN
                         END) CON,
                     SUM(CASE
                           WHEN C.AQPB811TIS in (4) then
                            C.AQPB811MMN
                         END) HIP,
                     SUM(C.AQPB811MMN) AQPB811MMN,
                     SUM(decode(c.aqpb811mda, 0, C.AQPB811IMP, 0)) AQPB811IMP,
                     SUM(decode(c.aqpb811mda, 101, C.AQPB811IMP, 0)) AQPB811IMD
                from AQPB811 c
               where C.AQPB811FEC = pd_fecha
                 and c.aqpb811gru = '5. VENTA'
               GROUP BY C.AQPB811ESTC) b
       where substr(a.tp1desc, 1, 1) = substr(b.AQPB811ESTC(+), 1, 1)
       order by 1, 2, 3;
    commit;
  exception
    when others then
      pv_flag := ' R25 VENTA ERROR:' || SQLERRM;
    
  END;

  -------------------------------------------------------------------------------------------------

  procedure sp_cr_generaR25_Castigo(pd_fecha  date,
                                    pn_tipcam number,
                                    pv_flag   out varchar2) IS
  
    -- *****************************************************************
    -- Nombre                     : sp_cr_generaR25_Castigo
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 22/10/2021
    -- Autor de Creación          : YYAMPI
    -- Uso                        : genera informacion consolidada de castigo para el formato para el reporte 25
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 16/12/2021 yyampi se agrego las guias de proceso en los grupos
    -- *****************************************************************                              
    lv_ano     varchar(4) := '';
    lv_mes     varchar(2) := '';
    lv_dia     varchar(2) := '01';
    ld_fecini  date;
    ld_fecmesa date;
  
  BEGIN
  
    lv_ano := to_char(pd_fecha, 'RRRR');
    lv_mes := lpad(to_char(pd_fecha, 'MM'), 2, '0');
  
    ld_fecini := to_date(lv_dia || lv_mes || lv_ano, 'DDMMRRRR');
  
    ld_fecmesa := add_months(pd_fecha, -1);
  
    insert into aqpb813
      (aqpb813fec,
       aqpb813gru,
       aqpb813sgr,
       aqpb813cor,
       aqpb813gem,
       aqpb813mem,
       aqpb813pem,
       aqpb813mcm,
       aqpb813con,
       aqpb813hip,
       aqpb813tmn,
       aqpb813imp,
       aqpb813imd)
    
      select pd_fecha,
             'castigos',
             a.tp1desc,
             b.COR,
             b.GEM,
             b.MEM,
             b.PEM,
             b.MIC,
             b.CON,
             b.HIP,
             b.AQPB811MMN,
             b.AQPB811IMP,
             b.AQPB811IMD
        from (select *
                from fst198 t
               where t.tp1cod = 1
                 AND T.TP1COD1 = 11150
                 and t.tp1corr1 = 1
                 and t.tp1corr2 = 2) a,
             ((select 2 codigo,
                      C.AQPB811ESTC,
                      SUM(CASE
                            WHEN C.AQPB811TIS in (5, 6, 7, 8, 9, 10) then
                             C.AQPB811MMN
                          END) COR,
                      SUM(CASE
                            WHEN C.AQPB811TIS in (11) then
                             C.AQPB811MMN
                          END) GEM,
                      SUM(CASE
                            WHEN C.AQPB811TIS in (12) then
                             C.AQPB811MMN
                          END) MEM,
                      SUM(CASE
                            WHEN C.AQPB811TIS in (13) then
                             C.AQPB811MMN
                          END) PEM,
                      SUM(CASE
                            WHEN C.AQPB811TIS in (2, 0) then
                             C.AQPB811MMN
                          END) MIC,
                      SUM(CASE
                            WHEN C.AQPB811TIS in (3) then
                             C.AQPB811MMN
                          END) CON,
                      SUM(CASE
                            WHEN C.AQPB811TIS in (4) then
                             C.AQPB811MMN
                          END) HIP,
                      SUM(C.AQPB811MMN) AQPB811MMN,
                      SUM(decode(c.aqpb811mda, 0, C.AQPB811IMP, 0)) AQPB811IMP,
                      SUM(decode(c.aqpb811mda, 101, C.AQPB811IMP, 0)) AQPB811IMD
                 from AQPB811 c
                where C.AQPB811FEC = pd_fecha
                  and c.aqpb811gru = '1. CASTIGADO'
                GROUP BY C.AQPB811ESTC) --cas
              union (select 3 codigo,
                            C.AQPB811ESTC,
                            SUM(CASE
                                  WHEN C.AQPB811TIS in (5, 6, 7, 8, 9, 10) then
                                   C.AQPB811MMN
                                END) COR,
                            SUM(CASE
                                  WHEN C.AQPB811TIS in (11) then
                                   C.AQPB811MMN
                                END) GEM,
                            SUM(CASE
                                  WHEN C.AQPB811TIS in (12) then
                                   C.AQPB811MMN
                                END) MEM,
                            SUM(CASE
                                  WHEN C.AQPB811TIS in (13) then
                                   C.AQPB811MMN
                                END) PEM,
                            SUM(CASE
                                  WHEN C.AQPB811TIS in (2, 0) then
                                   C.AQPB811MMN
                                END) MIC,
                            SUM(CASE
                                  WHEN C.AQPB811TIS in (3) then
                                   C.AQPB811MMN
                                END) CON,
                            SUM(CASE
                                  WHEN C.AQPB811TIS in (4) then
                                   C.AQPB811MMN
                                END) HIP,
                            SUM(C.AQPB811MMN) AQPB811MMN,
                            SUM(decode(c.aqpb811mda, 0, C.AQPB811IMP, 0)) AQPB811IMP,
                            SUM(decode(c.aqpb811mda, 101, C.AQPB811IMP, 0)) AQPB811IMD
                       from AQPB811 c
                      where C.AQPB811FEC = pd_fecha
                        and c.aqpb811esc = 0
                        and c.aqpb811gru = '2. PAGO CASTIGADO'
                     
                      GROUP BY C.AQPB811ESTC) --PAGO 
              union (select 4 codigo,
                            C.AQPB811ESTC,
                            SUM(CASE
                                  WHEN C.AQPB811TIS in (5, 6, 7, 8, 9, 10) then
                                   C.AQPB811MMN
                                END) COR,
                            SUM(CASE
                                  WHEN C.AQPB811TIS in (11) then
                                   C.AQPB811MMN
                                END) GEM,
                            SUM(CASE
                                  WHEN C.AQPB811TIS in (12) then
                                   C.AQPB811MMN
                                END) MEM,
                            SUM(CASE
                                  WHEN C.AQPB811TIS in (13) then
                                   C.AQPB811MMN
                                END) PEM,
                            SUM(CASE
                                  WHEN C.AQPB811TIS in (2, 0) then
                                   C.AQPB811MMN
                                END) MIC,
                            SUM(CASE
                                  WHEN C.AQPB811TIS in (3) then
                                   C.AQPB811MMN
                                END) CON,
                            SUM(CASE
                                  WHEN C.AQPB811TIS in (4) then
                                   C.AQPB811MMN
                                END) HIP,
                            SUM(C.AQPB811MMN) AQPB811MMN,
                            SUM(decode(c.aqpb811mda, 0, C.AQPB811IMP, 0)) AQPB811IMP,
                            SUM(decode(c.aqpb811mda, 101, C.AQPB811IMP, 0)) AQPB811IMD
                       from AQPB811 c
                      where C.AQPB811FEC = pd_fecha
                        and c.aqpb811esc = 0
                        and c.aqpb811gru = '3. CONDONADO'
                           --AND C.AQPB811MODT = 300 AND C.AQPB811TRAT = 407 
                        and (C.AQPB811MODT, C.AQPB811TRAT) in
                            (select t.tp1nro1, t.tp1nro2
                               from fst198 t
                              where t.tp1cod = 1
                                and t.tp1cod1 = 11150
                                and t.tp1corr1 = 2
                                and t.TP1CORR2 = 4
                                and t.tp1imp1 = 1 -- condonados castigados         
                             ) -- 16/12/2021 se puso guia de proceso
                     
                      GROUP BY C.AQPB811ESTC) --CONDONADO
              union (select 5 codigo,
                            C.AQPB811ESTC,
                            SUM(CASE
                                  WHEN C.AQPB811TIS in (5, 6, 7, 8, 9, 10) then
                                   C.AQPB811MMN
                                END) COR,
                            SUM(CASE
                                  WHEN C.AQPB811TIS in (11) then
                                   C.AQPB811MMN
                                END) GEM,
                            SUM(CASE
                                  WHEN C.AQPB811TIS in (12) then
                                   C.AQPB811MMN
                                END) MEM,
                            SUM(CASE
                                  WHEN C.AQPB811TIS in (13) then
                                   C.AQPB811MMN
                                END) PEM,
                            SUM(CASE
                                  WHEN C.AQPB811TIS in (2, 0) then
                                   C.AQPB811MMN
                                END) MIC,
                            SUM(CASE
                                  WHEN C.AQPB811TIS in (3) then
                                   C.AQPB811MMN
                                END) CON,
                            SUM(CASE
                                  WHEN C.AQPB811TIS in (4) then
                                   C.AQPB811MMN
                                END) HIP,
                            SUM(C.AQPB811MMN) AQPB811MMN,
                            SUM(decode(c.aqpb811mda, 0, C.AQPB811IMP, 0)) AQPB811IMP,
                            SUM(decode(c.aqpb811mda, 101, C.AQPB811IMP, 0)) AQPB811IMD
                       from AQPB811 c
                      where C.AQPB811FEC = pd_fecha
                           --and c.aqpb811modt= 530 and c.aqpb811trat = 407  
                        and (c.aqpb811modt, c.aqpb811trat) in
                            (select t.tp1nro1, t.tp1nro2
                               from fst198 t
                              where t.tp1cod = 1
                                and t.tp1cod1 = 11150
                                and t.tp1corr1 = 2
                                and t.TP1CORR2 = 5
                                and t.tp1imp1 = 1
                                and t.tp1imp2 = 0) -- 16/12/2021 yyampi se puso guia de proceso
                           
                        and c.aqpb811gru = '4. EXTORNADO'
                        AND TO_CHAR(C.AQPB811FEC, 'RRRR') =
                            TO_CHAR(C.AQPB811FVAL, 'RRRR')
                        AND (TO_CHAR(C.AQPB811FEC, 'MM') * 1 -
                            TO_CHAR(C.AQPB811FVAL, 'MM') * 1) = 1 -- EXTORNO FECHA VALOR DEL MES ANTERIOR   
                      GROUP BY C.AQPB811ESTC) union
              (select 6 codigo,
                      C.AQPB811ESTC,
                      SUM(CASE
                            WHEN C.AQPB811TIS in (5, 6, 7, 8, 9, 10) then
                             C.AQPB811MMN
                          END) COR,
                      SUM(CASE
                            WHEN C.AQPB811TIS in (11) then
                             C.AQPB811MMN
                          END) GEM,
                      SUM(CASE
                            WHEN C.AQPB811TIS in (12) then
                             C.AQPB811MMN
                          END) MEM,
                      SUM(CASE
                            WHEN C.AQPB811TIS in (13) then
                             C.AQPB811MMN
                          END) PEM,
                      SUM(CASE
                            WHEN C.AQPB811TIS in (2, 0) then
                             C.AQPB811MMN
                          END) MIC,
                      SUM(CASE
                            WHEN C.AQPB811TIS in (3) then
                             C.AQPB811MMN
                          END) CON,
                      SUM(CASE
                            WHEN C.AQPB811TIS in (4) then
                             C.AQPB811MMN
                          END) HIP,
                      SUM(C.AQPB811MMN) AQPB811MMN,
                      SUM(decode(c.aqpb811mda, 0, C.AQPB811IMP, 0)) AQPB811IMP,
                      SUM(decode(c.aqpb811mda, 101, C.AQPB811IMP, 0)) AQPB811IMD
                 from AQPB811 c
                where C.AQPB811FEC = pd_fecha
                  and c.aqpb811gru = '5. VENTA'
                  and (c.aqpb811modt, c.aqpb811trat) in
                      (select t.tp1nro1, t.tp1nro2
                         from fst198 t
                        where t.tp1cod = 1
                          and t.tp1cod1 = 11150
                          and t.tp1corr1 = 2
                          and t.TP1CORR2 = 3
                          and t.tp1imp1 = 1 --transaccion de tipo castigo
                       ) -- 16/12/2021 yyampi se agrego la guia de transaccion de venta castigos 
               
                GROUP BY C.AQPB811ESTC) --VENTA
              union (select /*+ ALL_ROWS */
                      1 codigo,
                      '' AQPB811ESTC,
                      0 COR,
                      0 GEM,
                      0 MEM,
                      0 PEM,
                      0 MIC,
                      0 CON,
                      0 HIP,
                      SUM(-1 * C.drsdmn) AQPB811MMN,
                      SUM(decode(c.drmda, 0, -1 * drsdor, 0)) AQPB811IMP,
                      SUM(decode(c.drmda, 101, -1 * C.drsdor, 0)) AQPB811IMD
                       from fsh031 /*_r25*/ C
                      where drfch = ld_fecmesa
                        and drmod = 33) --SALDO INI
              UNION (select /*+ ALL_ROWS */
                      8 codigo,
                      '' AQPB811ESTC,
                      0 COR,
                      0 GEM,
                      0 MEM,
                      0 PEM,
                      0 MIC,
                      0 CON,
                      0 HIP,
                      SUM(-1 * C.drsdmn) AQPB811MMN,
                      SUM(decode(c.drmda, 0, -1 * drsdor, 0)) AQPB811IMP,
                      SUM(decode(c.drmda, 101, -1 * C.drsdor, 0)) AQPB811IMD
                       from fsh031 /*_r25*/ C
                      where drfch in pd_fecha
                        and drmod = 33) --SALDO FIN
              UNION (select /*+ ALL_ROWS */
                      7 codigo,
                      '' AQPB811ESTC,
                      0 COR,
                      0 GEM,
                      0 MEM,
                      0 PEM,
                      0 MIC,
                      0 CON,
                      0 HIP,
                      -1 *
                      SUM(decode(c.drmda, 101, -1 * C.drsdor, 0) *
                          (select tipcami - tipcamf
                             from (select max(case
                                                when e.COFDES = pd_fecha then
                                                 e.cotcbi
                                              end) tipcamf,
                                          max(case
                                                when e.COFDES = ld_fecmesa then
                                                 e.cotcbi
                                              end) tipcami
                                     FROM FsH005 e
                                    WHERE e.MONEDA = 101
                                      AND e.COFDES in (ld_fecmesa, pd_fecha)))) AQPB811MMN,
                      0 AQPB811IMP,
                      0 AQPB811IMD
                       from fsh031 /*_r25*/ C
                      where drfch = ld_fecmesa
                        and drmod = 33) --EXPRESION
             
             ) b
       where a.tp1corr3 = b.codigo(+)
       order by 1, 2, 3;
  
    commit;
  
  exception
    when others then
      pv_flag := ' R25 Castigo ERROR:' || SQLERRM;
    
  END;

  -------------------------------------------------------------------------------------------------

  procedure sp_cr_generaR25_Condonado(pd_fecha  date,
                                      pn_tipcam number,
                                      pv_flag   out varchar2) IS
  
    -- *****************************************************************
    -- Nombre                     : sp_cr_generaR25_Condonado
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 22/10/2021
    -- Autor de Creación          : YYAMPI
    -- Uso                        : genera informacion consolidada de condonado para el formato para el reporte 25
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 16/12/2021 yyampi se agrego las guias de proceso en los grupos
    -- *****************************************************************
  
    lv_ano     varchar(4) := '';
    lv_mes     varchar(2) := '';
    lv_dia     varchar(2) := '01';
    ld_fecini  date;
    ld_fecmesa date;
  
  BEGIN
  
    lv_ano := to_char(pd_fecha, 'RRRR');
    lv_mes := lpad(to_char(pd_fecha, 'MM'), 2, '0');
  
    ld_fecini  := to_date(lv_dia || lv_mes || lv_ano, 'DDMMRRRR');
    ld_fecmesa := add_months(pd_fecha, -1);
  
    insert into aqpb813
      (aqpb813fec,
       aqpb813gru,
       aqpb813sgr,
       aqpb813cor,
       aqpb813gem,
       aqpb813mem,
       aqpb813pem,
       aqpb813mcm,
       aqpb813con,
       aqpb813hip,
       aqpb813tmn,
       aqpb813imp,
       aqpb813imd)
    
      select pd_fecha,
             'condonados',
             a.tp1desc,
             b.COR,
             b.GEM,
             b.MEM,
             b.PEM,
             b.MIC,
             b.CON,
             b.HIP,
             b.AQPB811MMN,
             b.AQPB811IMP,
             b.AQPB811IMD
        from (select *
                from fst198 t
               where t.tp1cod = 1
                 AND T.TP1COD1 = 11150
                 and t.tp1corr1 = 1
                 and t.tp1corr2 = 3) a,
             (
             
              (select 4 codigo,
                      C.AQPB811ESTC,
                      SUM(CASE
                            WHEN C.AQPB811TIS in (5, 6, 7, 8, 9, 10) then
                             C.AQPB811MMN
                          END) COR,
                      SUM(CASE
                            WHEN C.AQPB811TIS in (11) then
                             C.AQPB811MMN
                          END) GEM,
                      SUM(CASE
                            WHEN C.AQPB811TIS in (12) then
                             C.AQPB811MMN
                          END) MEM,
                      SUM(CASE
                            WHEN C.AQPB811TIS in (13) then
                             C.AQPB811MMN
                          END) PEM,
                      SUM(CASE
                            WHEN C.AQPB811TIS in (2, 0) then
                             C.AQPB811MMN
                          END) MIC,
                      SUM(CASE
                            WHEN C.AQPB811TIS in (3) then
                             C.AQPB811MMN
                          END) CON,
                      SUM(CASE
                            WHEN C.AQPB811TIS in (4) then
                             C.AQPB811MMN
                          END) HIP,
                      SUM(C.AQPB811MMN) AQPB811MMN,
                      SUM(decode(c.aqpb811mda, 0, C.AQPB811IMP, 0)) AQPB811IMP,
                      SUM(decode(c.aqpb811mda, 101, C.AQPB811IMP, 0)) AQPB811IMD
                 from AQPB811 c
                where C.AQPB811FEC = pd_fecha
                  and c.aqpb811gru = '3. CONDONADO'
                     --AND C.AQPB811MODT = 300 
                  AND C.AQPB811ESC = 0 --AND C.AQPB811TRAT <> 407 
                  AND (C.AQPB811MODT, C.AQPB811TRAT) IN
                      (select t.tp1nro1, t.tp1nro2
                         from fst198 t
                        where t.tp1cod = 1
                          and t.tp1cod1 = 11150
                          and t.tp1corr1 = 2
                          and t.tp1corr2 = 4
                          and t.tp1nro3 in (1, 2, 3)) --16/12/2021 YYAMPI SE AGREGO LA GUIA DE CONDONADOS
                GROUP BY C.AQPB811ESTC) --CONDONADO
              union (select 5 codigo,
                            C.AQPB811ESTC,
                            SUM(CASE
                                  WHEN C.AQPB811TIS in (5, 6, 7, 8, 9, 10) then
                                   C.AQPB811MMN
                                END) COR,
                            SUM(CASE
                                  WHEN C.AQPB811TIS in (11) then
                                   C.AQPB811MMN
                                END) GEM,
                            SUM(CASE
                                  WHEN C.AQPB811TIS in (12) then
                                   C.AQPB811MMN
                                END) MEM,
                            SUM(CASE
                                  WHEN C.AQPB811TIS in (13) then
                                   C.AQPB811MMN
                                END) PEM,
                            SUM(CASE
                                  WHEN C.AQPB811TIS in (2, 0) then
                                   C.AQPB811MMN
                                END) MIC,
                            SUM(CASE
                                  WHEN C.AQPB811TIS in (3) then
                                   C.AQPB811MMN
                                END) CON,
                            SUM(CASE
                                  WHEN C.AQPB811TIS in (4) then
                                   C.AQPB811MMN
                                END) HIP,
                            SUM(C.AQPB811MMN) AQPB811MMN,
                            SUM(decode(c.aqpb811mda, 0, C.AQPB811IMP, 0)) AQPB811IMP,
                            SUM(decode(c.aqpb811mda, 101, C.AQPB811IMP, 0)) AQPB811IMD
                       from AQPB811 c
                      where C.AQPB811FEC = pd_fecha /*and c.aqpb811trat <> 407*/ --cambio 16/12/2021       
                        AND (C.AQPB811MODT, C.AQPB811TRAT) IN
                            (select t.tp1nro1, t.tp1nro2
                               from fst198 t
                              where t.tp1cod = 1
                                and t.tp1cod1 = 11150
                                and t.tp1corr1 = 2
                                and t.tp1corr2 = 5
                                and t.tp1imp2 = 1 --el imp2 indica condonacion
                             ) --16/12/2021 YYAMPI SE AGREGO LA GUIA DE CONDONADOS         
                        and c.aqpb811gru = '4. EXTORNADO'
                        AND TO_CHAR(C.AQPB811FEC, 'RRRR') =
                            TO_CHAR(C.AQPB811FVAL, 'RRRR')
                        AND (TO_CHAR(C.AQPB811FEC, 'MM') * 1 -
                            TO_CHAR(C.AQPB811FVAL, 'MM') * 1) = 1 -- EXTORNO FECHA VALOR DEL MES ANTERIOR    
                      GROUP BY C.AQPB811ESTC) -- EXTORNADO
             
              union (select /*+ ALL_ROWS */
                      1 codigo,
                      '' AQPB811ESTC,
                      0 COR,
                      0 GEM,
                      0 MEM,
                      0 PEM,
                      0 MIC,
                      0 CON,
                      0 HIP,
                      SUM(-1 * C.drsdmn) AQPB811MMN,
                      SUM(decode(c.drmda, 0, -1 * drsdor, 0)) AQPB811IMP,
                      SUM(decode(c.drmda, 101, -1 * C.drsdor, 0)) AQPB811IMD
                       from fsh031 /*_r25*/ C
                      where drfch = ld_fecmesa
                        and drmod = 305) --saldo inicial
              UNION (select /*+ ALL_ROWS */
                      8 codigo,
                      '' AQPB811ESTC,
                      0 COR,
                      0 GEM,
                      0 MEM,
                      0 PEM,
                      0 MIC,
                      0 CON,
                      0 HIP,
                      SUM(-1 * C.drsdmn) AQPB811MMN,
                      SUM(decode(c.drmda, 0, -1 * drsdor, 0)) AQPB811IMP,
                      SUM(decode(c.drmda, 101, -1 * C.drsdor, 0)) AQPB811IMD
                       from fsh031 /*_r25*/ C
                      where drfch = pd_fecha
                        and drmod = 305) --saldo final
              UNION (select /*+ ALL_ROWS */
                      7 codigo,
                      '' AQPB811ESTC,
                      0 COR,
                      0 GEM,
                      0 MEM,
                      0 PEM,
                      0 MIC,
                      0 CON,
                      0 HIP,
                      -1 *
                      SUM(decode(c.drmda, 101, -1 * C.drsdor, 0) *
                          (select tipcami - tipcamf
                             from (select max(case
                                                when e.COFDES = pd_fecha then
                                                 e.cotcbi
                                              end) tipcamf,
                                          max(case
                                                when e.COFDES = ld_fecmesa then
                                                 e.cotcbi
                                              end) tipcami
                                     FROM FsH005 e
                                    WHERE e.MONEDA = 101
                                      AND e.COFDES in (ld_fecmesa, pd_fecha)))) AQPB811MMN,
                      0 AQPB811IMP,
                      0 AQPB811IMD
                       from fsh031 /*_r25*/ C
                      where drfch = ld_fecmesa
                        and drmod = 305) --EXPRESION
             
             ) b
       where a.tp1corr3 = b.codigo(+)
       order by 1, 2, 3;
    commit;
  exception
    when others then
      pv_flag := ' R25 CONDO ERROR:' || SQLERRM;
    
  END;

  -------------------------------------------------------------------------------------------------

  FUNCTION FN_CR_REPORTE25_TIPCRE25(BNJ096SUC IN NUMBER,
                                    BNJ096MDA IN NUMBER,
                                    BNJ096PAP IN NUMBER,
                                    BNJ096CTA IN NUMBER,
                                    BNJ096OPE IN NUMBER,
                                    BNJ096SUB IN NUMBER,
                                    BNJ096MOD IN NUMBER,
                                    BNJ096TOP IN NUMBER) RETURN NUMBER IS
  
    -- *****************************************************************
    -- Nombre                     : FN_CR_REPORTE25_TIPCRE
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 22/10/2021
    -- Autor de Creación          : YYAMPI
    -- Uso                        : devuelve el tipo de credito
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 
    -- *****************************************************************
  
    p_c_pas     char(1);
    p_c_tcr     jaql114.jaql114tcrd%type;
    p_n_j096sub number(3);
    p_n_j096TOp number(3);
    p_n_j096suc number(3);
    p_n_j096Cta number(9);
    p_n_j096Ope number(9);
    p_n_j096Mda number(4);
    p_n_j096mod number(3);
    p_n_j096Pap number(4);
  
    ld_fecrcc    date;
    lc_ndoc      char(12);
    lc_ndoc2     varchar2(12);
    ln_tdoc      number(2);
    ln_pais      number(3);
    lc_codsbs    varchar2(10);
    cod_tipsbs   char(2);
    ln_tipdocSBS number(9);
    ln_petipo    char(1);
    P_N_GPO      NUMBER(2);
  
  BEGIN
  
    lc_codsbs := null;
  
    begin
    
      /*fecha de ultima carga del RCC */
      select to_date(Tpnro, 'dd.mm.yyyy')
        into ld_fecrcc
        from fst098
       where Pgcod = 1
         and Tpcod = 7647
         and Tpcorr = 12;
    
      select pepais, petdoc, pendoc, trim(pendoc) pendoc2
        into ln_pais, ln_tdoc, lc_ndoc, lc_ndoc2
        from fsr008
       where ctnro = BNJ096CTA
         and cttfir = 'T';
    
      ----------------------------------------------------------
    
      /*obtener tipo de persona (Juridica o natural) */
      begin
        select t.petipo
          into ln_petipo
          from fsd001 t
         where t.pepais = ln_pais
           and t.petdoc = ln_tdoc
           and t.pendoc = lc_ndoc;
      exception
        when others then
          DBMS_OUTPUT.put_line(SQLERRM);
      end;
    
      /*Calculo de tipo de documento SBS*/
      begin
        select t.tp1corr3
          into ln_tipdocSBS
          from FST198 t
         where t.tp1cod = 1
           and t.tp1cod1 = 11111
           and t.tp1corr1 = 1
           and t.tp1corr2 = 3
           and t.tp1nro1 = ln_tdoc;
      exception
        when others then
          DBMS_OUTPUT.put_line(SQLERRM);
      end;
    
      /*Obtencion del codigo SBS*/
      begin
        if ln_petipo = 'F' then
          select c.c_codsbs
            into lc_codsbs
            from CLDRCCI /*_rep25*/ c
           Where D_FECPRE = ld_fecrcc
             and C_TDOCID = ln_tipdocSBS
             and C_DOCIDE = lc_ndoc2;
        else
          if ln_petipo = 'J' then
            select c.c_codsbs
              into lc_codsbs
              from CLDRCCI /*_rep25*/ c
             Where D_FECPRE = ld_fecrcc
               and C_TDOCTR = ln_tipdocSBS
               and C_DOCTRI = lc_ndoc2;
          else
            lc_codsbs := null;
          end if;
        end if;
      exception
        when others then
          DBMS_OUTPUT.put_line(SQLERRM);
      end;
    
      ----------------------------------------------------------
      /* 
      begin
      select c_codsbs
      into lc_codsbs
      from cldrcci
      where d_fecpre = ld_fecrcc
      and c_docide = lc_ndoc;
      exception
      when no_data_found then
           select c_codsbs
           into lc_codsbs
           from cldrcci
           where d_fecpre = ld_fecrcc
           and c_doctri = lc_ndoc;
      end;*/
    
      if lc_codsbs is not null then
        PQ_CR_REPORTE25.SP_tipSBS(BNJ096CTA,
                                  BNJ096OPE,
                                  BNJ096MOD,
                                  lc_codsbs,
                                  cod_tipsbs);
      end if;
    
    exception
      when others then
        cod_tipsbs := null;
    end;
  
    if cod_tipsbs <> 99 and cod_tipsbs is not null then
    
      P_N_GPO := 0;
    
      if cod_tipsbs = '10' then
        P_N_GPO := 2;
      else
        if cod_tipsbs = '09' then
          P_N_GPO := 13;
        else
          if cod_tipsbs = '11' or cod_tipsbs = '12' then
            P_N_GPO := 3;
          else
            if cod_tipsbs = '13' then
              P_N_GPO := 4;
            else
              if cod_tipsbs = '08' then
                P_N_GPO := 12;
              else
                P_N_GPO := 0;
              end if;
            end if;
          end if;
        end if;
      end if;
    
    else
    
      P_N_GPO := 0;
    
      p_n_j096sub := BNJ096SUB;
      p_n_j096TOp := BNJ096TOP;
      p_n_j096suc := BNJ096SUC;
      p_n_j096Cta := BNJ096CTA;
      p_n_j096Ope := BNJ096OPE;
      p_n_j096Mda := BNJ096MDA;
      p_n_j096mod := BNJ096MOD;
      p_n_j096Pap := BNJ096PAP;
    
      begin
        select t.jaql114tcrd
          into p_c_tcr
          from fsr011 r
         inner join jaql114 t
            on r.R1COD = t.jaql114emp
           and r.R1SUC = t.jaql114suc
           and r.R1CTA = t.jaql114cta
           and r.R1OPER = t.jaql114oper
           and r.R1MDA = t.jaql114mda
           and r.R1MOD = t.jaql114mod
           and r.R1SBOP = t.jaql114sbop
           and r.R1TOPE = t.jaql114top
           and r.R1PAP = t.jaql114pap
         where RELCOD = 33
           and R2COD = 1
           and R2SUC = p_n_j096suc
           and R2CTA = p_n_j096Cta
           and R2OPER = p_n_j096Ope
           and R2MDA = p_n_j096Mda
           and R2MOD = p_n_j096mod
           and R2SBOP = p_n_j096sub
           and R2TOPE = p_n_j096TOp
           and R2PAP = p_n_j096Pap
           and rownum = 1;
      exception
        when no_data_found then
          p_c_tcr := null;
        when others then
          p_c_tcr := null;
      end;
    
      if (p_c_tcr is not null) then
      
        if substr(trim(p_c_tcr), 1, 3) = 'MIC' then
          P_N_GPO := 2;
        else
          if substr(trim(p_c_tcr), 1, 3) = 'PEQ' then
            P_N_GPO := 13;
          else
            if substr(trim(p_c_tcr), 1, 3) = 'CON' then
              P_N_GPO := 3;
            else
              if substr(trim(p_c_tcr), 1, 3) = 'HIP' then
                P_N_GPO := 4;
              else
                if substr(trim(p_c_tcr), 1, 3) = 'MED' then
                  P_N_GPO := 12;
                else
                  P_N_GPO := 0;
                end if;
              end if;
            end if;
          end if;
        end if;
      
      else
      
        begin
          select bnj096pas
            into p_c_pas
            from bnj096
           where bnj096suc = p_n_j096suc
             and bnj096Cta = p_n_j096Cta
             and bnj096Ope = p_n_j096Ope
             and bnj096Mda = p_n_j096Mda
             and bnj096mod = p_n_j096mod
             and bnj096sub = p_n_j096sub
             and bnj096TOp = p_n_j096TOp
             and bnj096Pap = p_n_j096Pap
             and rownum = 1;
        exception
          when no_data_found then
            p_c_pas := null;
          when others then
            p_c_pas := null;
        end;
      
        if (p_c_pas is not null) then
        
          if (p_c_pas = 1) then
            P_N_GPO := 9;
          end if;
          if (p_c_pas = 2) then
            P_N_GPO := 3;
          end if;
          if (p_c_pas = 7) then
            P_N_GPO := 3;
          end if;
          if (p_c_pas = 3) then
            P_N_GPO := 2;
          end if;
          if (p_c_pas = 4) then
            P_N_GPO := 4;
          end if;
          if (p_c_pas = 8) then
            P_N_GPO := 12;
          end if;
          if (p_c_pas = 6) then
            P_N_GPO := 11;
          end if;
          if (p_c_pas = 5) then
            P_N_GPO := 13;
          end if;
        
        else
          P_N_GPO := 0;
        end if;
      end if;
    
    end if;
  
    return P_N_GPO;
  
  EXCEPTION
  
    WHEN OTHERS THEN
      P_N_GPO := 0;
  END;

  ----------------------------------------------------------------------------------------------

  FUNCTION FN_CR_REPORTE25_CODSBS(BNJ096SUC IN NUMBER,
                                  BNJ096MDA IN NUMBER,
                                  BNJ096PAP IN NUMBER,
                                  BNJ096CTA IN NUMBER,
                                  BNJ096OPE IN NUMBER,
                                  BNJ096SUB IN NUMBER,
                                  BNJ096MOD IN NUMBER,
                                  BNJ096TOP IN NUMBER) RETURN VARCHAR IS
  
    -- *****************************************************************
    -- Nombre                     : FN_CR_REPORTE25_CODSBS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 22/10/2021
    -- Autor de Creación          : YYAMPI
    -- Uso                        : devuelve el tipo SBS segun RCC 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 
    -- *****************************************************************
  
    p_c_pas     char(1);
    p_c_tcr     jaql114.jaql114tcrd%type;
    p_n_j096sub number(3);
    p_n_j096TOp number(3);
    p_n_j096suc number(3);
    p_n_j096Cta number(9);
    p_n_j096Ope number(9);
    p_n_j096Mda number(4);
    p_n_j096mod number(3);
    p_n_j096Pap number(4);
  
    ld_fecrcc    date;
    lc_ndoc      char(12);
    lc_ndoc2     varchar2(12);
    ln_tdoc      number(2);
    ln_pais      number(3);
    lc_codsbs    varchar2(10);
    cod_tipsbs   char(2);
    ln_tipdocSBS number(9);
    ln_petipo    char(1);
    P_N_GPO      NUMBER(2);
  
  BEGIN
  
    lc_codsbs := null;
  
    --begin
  
    /*fecha de ultima carga del RCC */
    select to_date(Tpnro, 'dd.mm.yyyy')
      into ld_fecrcc
      from fst098
     where Pgcod = 1
       and Tpcod = 7647
       and Tpcorr = 12;
  
    ld_fecrcc := to_date('2021.07.31', 'rrrr.mm.dd');
  
    select pepais, petdoc, pendoc, trim(pendoc) pendoc2
      into ln_pais, ln_tdoc, lc_ndoc, lc_ndoc2
      from fsr008
     where ctnro = BNJ096CTA
       and cttfir = 'T';
  
    ----------------------------------------------------------
  
    /*obtener tipo de persona (Juridica o natural) */
    begin
      select t.petipo
        into ln_petipo
        from fsd001 t
       where t.pepais = ln_pais
         and t.petdoc = ln_tdoc
         and t.pendoc = lc_ndoc;
    exception
      when others then
        DBMS_OUTPUT.put_line(SQLERRM);
    end;
  
    /*Calculo de tipo de documento SBS*/
    begin
      select t.tp1corr3
        into ln_tipdocSBS
        from FST198 t
       where t.tp1cod = 1
         and t.tp1cod1 = 11111
         and t.tp1corr1 = 1
         and t.tp1corr2 = 3
         and t.tp1nro1 = ln_tdoc;
    exception
      when others then
        DBMS_OUTPUT.put_line(SQLERRM);
    end;
  
    /*Obtencion del codigo SBS*/
    begin
      if ln_petipo = 'F' then
        select c.c_codsbs
          into lc_codsbs
          from CLDRCCI c
         Where D_FECPRE = ld_fecrcc
           and C_TDOCID = ln_tipdocSBS
           and C_DOCIDE = lc_ndoc2;
      else
        if ln_petipo = 'J' then
          select c.c_codsbs
            into lc_codsbs
            from CLDRCCI c
           Where D_FECPRE = ld_fecrcc
             and C_TDOCTR = ln_tipdocSBS
             and C_DOCTRI = lc_ndoc2;
        else
          lc_codsbs := null;
        end if;
      end if;
    exception
      when others then
        DBMS_OUTPUT.put_line(SQLERRM);
    end;
  
    RETURN lc_codsbs;
    -- END;  
  
  EXCEPTION
  
    WHEN OTHERS THEN
      RETURN '';
  END;

  ----------------------------------------------------------------------------------------------

  PROCEDURE SP_tipSBS(pn_cta     in number,
                      pn_ope     in number,
                      pn_mod     in number,
                      pc_sbs     in varchar2,
                      cod_tipsbs OUT varchar2) is
  
    -- *****************************************************************
    -- Nombre                     : SP_tipSBS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 22/10/2021
    -- Autor de Creación          : YYAMPI
    -- Uso                        : devuelve el tipo SBS texto
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 
    -- *****************************************************************
  
    lc_tipsbs   char(30);
    lc_codsbs   char(2);
    ld_fecrcc   date;
    ln_TipoDni  number(2);
    ln_TipoRuc  number(2);
    ln_TipoCex  number(2);
    lc_C_TDOCID char(1);
    cod_sbs     VARCHAR2(10);
    ln_rubtmp   number(4);
  
  begin
  
    ln_TipoDni := 21;
    ln_TipoRuc := 9;
    ln_TipoCex := 2;
    lc_codsbs  := null;
  
    begin
      select to_date(Tpnro, 'dd.mm.yyyy')
        into ld_fecrcc
        from fst098
       where Pgcod = 1
         and Tpcod = 7647
         and Tpcorr = 12;
    end;
  
    begin
      select distinct a.c_cretip
        into lc_codsbs
        from cldrccs /*_rep25*/ a
       where a.c_codsbs = pc_sbs
         and a.d_fecpre = ld_fecrcc;
    exception
      when no_data_found then
        lc_codsbs := null;
      when too_many_rows then
        begin
          select distinct a.c_cretip
            into lc_codsbs
            from cldrccs /*_rep25*/ a
           where a.c_codsbs = pc_sbs
             and a.d_fecpre = ld_fecrcc
             and substr(a.c_cuenta, 1, 4) in
                 (select jaqz109rub from jaqz109)
             and a.c_codemp = '00104';
        exception
          when too_many_rows then
            begin
              select substr(a.jaqy953rub, 1, 4)
                into ln_rubtmp
                from jaqy953 /*_rep25*/ a
               where a.jaqy953cta = pn_cta
                 and a.jaqy953ope = pn_ope;
            end;
          
            begin
              select distinct a.c_cretip
                into lc_codsbs
                from cldrccs /*_rep25*/ a
               where a.c_codsbs = pc_sbs
                 and a.d_fecpre = ld_fecrcc
                 and a.c_codemp = '00104'
                 and substr(a.c_cuenta, 1, 4) = to_char(ln_rubtmp)
                 and rownum = 1;
            exception
              when too_many_rows then
                lc_codsbs := null;
            end;
          
          when no_data_found then
            lc_codsbs := null;
        end;
    end;
  
    cod_tipsbs := lc_codsbs;
  
    if lc_codsbs is null then
      cod_tipsbs := '99';
    end if;
  
  end sp_tipSBS;

  ----------------------------------------------------------------------------------------------

  FUNCTION FN_CR_REPORTE25_TIPCRE2(BNJ096SUC IN NUMBER,
                                   BNJ096MDA IN NUMBER,
                                   BNJ096PAP IN NUMBER,
                                   BNJ096CTA IN NUMBER,
                                   BNJ096OPE IN NUMBER,
                                   BNJ096SUB IN NUMBER,
                                   BNJ096MOD IN NUMBER,
                                   BNJ096TOP IN NUMBER) RETURN NUMBER IS
    -- *****************************************************************
    -- Nombre                     : FN_CR_REPORTE25_TIPCRE2
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 22/10/2021
    -- Autor de Creación          : YYAMPI
    -- Uso                        : devuelve el tipo de credito
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 
    -- *****************************************************************
  
    p_c_pas     char(1);
    p_c_tcr     jaql114.jaql114tcrd%type;
    p_n_j096sub number(3);
    p_n_j096TOp number(3);
    p_n_j096suc number(3);
    p_n_j096Cta number(9);
    p_n_j096Ope number(9);
    p_n_j096Mda number(4);
    p_n_j096mod number(3);
    p_n_j096Pap number(4);
  
    ld_fecrcc  date;
    lc_ndoc    varchar2(12);
    lc_codsbs  varchar2(10);
    cod_tipsbs char(2);
  
    P_N_GPO NUMBER(2);
  
  BEGIN
  
    lc_codsbs := null;
  
    begin
    
      select to_date(Tpnro, 'dd.mm.yyyy')
        into ld_fecrcc
        from fst098
       where Pgcod = 1
         and Tpcod = 7647
         and Tpcorr = 12;
    
      --ld_fecrcc := to_date('2021.07.31','rrrr.mm.dd') ;
    
      select trim(pendoc)
        into lc_ndoc
        from fsr008
       where ctnro = BNJ096CTA
         and cttfir = 'T';
    
      begin
        select c_codsbs
          into lc_codsbs
          from cldrcci /*_rep25*/
         where d_fecpre = ld_fecrcc
           and c_docide = lc_ndoc;
      exception
        when no_data_found then
          select c_codsbs
            into lc_codsbs
            from cldrcci /*_rep25*/
           where d_fecpre = ld_fecrcc
             and c_doctri = lc_ndoc;
      end;
    
      if lc_codsbs is not null then
        pq_cr_reporte25.SP_tipSBS(BNJ096CTA,
                                  BNJ096OPE,
                                  BNJ096MOD,
                                  lc_codsbs,
                                  cod_tipsbs);
      end if;
    
    exception
      when others then
        cod_tipsbs := null;
    end;
  
    if cod_tipsbs <> 99 and cod_tipsbs is not null then
    
      P_N_GPO := 0;
    
      if cod_tipsbs = '10' then
        P_N_GPO := 2;
      else
        if cod_tipsbs = '09' then
          P_N_GPO := 13;
        else
          if cod_tipsbs = '11' or cod_tipsbs = '12' then
            P_N_GPO := 3;
          else
            if cod_tipsbs = '13' then
              P_N_GPO := 4;
            else
              if cod_tipsbs = '08' then
                P_N_GPO := 12;
              else
                P_N_GPO := 0;
              end if;
            end if;
          end if;
        end if;
      end if;
    
    else
    
      P_N_GPO := 0;
    
      p_n_j096sub := BNJ096SUB;
      p_n_j096TOp := BNJ096TOP;
      p_n_j096suc := BNJ096SUC;
      p_n_j096Cta := BNJ096CTA;
      p_n_j096Ope := BNJ096OPE;
      p_n_j096Mda := BNJ096MDA;
      p_n_j096mod := BNJ096MOD;
      p_n_j096Pap := BNJ096PAP;
    
      begin
        select t.jaql114tcrd
          into p_c_tcr
          from fsr011 r
         inner join jaql114 t
            on r.R1COD = t.jaql114emp
           and r.R1SUC = t.jaql114suc
           and r.R1CTA = t.jaql114cta
           and r.R1OPER = t.jaql114oper
           and r.R1MDA = t.jaql114mda
           and r.R1MOD = t.jaql114mod
           and r.R1SBOP = t.jaql114sbop
           and r.R1TOPE = t.jaql114top
           and r.R1PAP = t.jaql114pap
         where RELCOD = 33
           and R2COD = 1
           and R2SUC = p_n_j096suc
           and R2CTA = p_n_j096Cta
           and R2OPER = p_n_j096Ope
           and R2MDA = p_n_j096Mda
           and R2MOD = p_n_j096mod
           and R2SBOP = p_n_j096sub
           and R2TOPE = p_n_j096TOp
           and R2PAP = p_n_j096Pap
           and rownum = 1;
      exception
        when no_data_found then
          p_c_tcr := null;
        when others then
          p_c_tcr := null;
      end;
    
      if (p_c_tcr is not null) then
      
        if substr(trim(p_c_tcr), 1, 3) = 'MIC' then
          P_N_GPO := 2;
        else
          if substr(trim(p_c_tcr), 1, 3) = 'PEQ' then
            P_N_GPO := 13;
          else
            if substr(trim(p_c_tcr), 1, 3) = 'CON' then
              P_N_GPO := 3;
            else
              if substr(trim(p_c_tcr), 1, 3) = 'HIP' then
                P_N_GPO := 4;
              else
                if substr(trim(p_c_tcr), 1, 3) = 'MED' then
                  P_N_GPO := 12;
                else
                  P_N_GPO := 0;
                end if;
              end if;
            end if;
          end if;
        end if;
      
      else
      
        begin
          select bnj096pas
            into p_c_pas
            from bnj096
           where bnj096suc = p_n_j096suc
             and bnj096Cta = p_n_j096Cta
             and bnj096Ope = p_n_j096Ope
             and bnj096Mda = p_n_j096Mda
             and bnj096mod = p_n_j096mod
             and bnj096sub = p_n_j096sub
             and bnj096TOp = p_n_j096TOp
             and bnj096Pap = p_n_j096Pap
             and rownum = 1;
        exception
          when no_data_found then
            p_c_pas := null;
          when others then
            p_c_pas := null;
        end;
      
        if (p_c_pas is not null) then
        
          if (p_c_pas = 1) then
            P_N_GPO := 9;
          end if;
          if (p_c_pas = 2) then
            P_N_GPO := 3;
          end if;
          if (p_c_pas = 7) then
            P_N_GPO := 3;
          end if;
          if (p_c_pas = 3) then
            P_N_GPO := 2;
          end if;
          if (p_c_pas = 4) then
            P_N_GPO := 4;
          end if;
          if (p_c_pas = 8) then
            P_N_GPO := 12;
          end if;
          if (p_c_pas = 6) then
            P_N_GPO := 11;
          end if;
          if (p_c_pas = 5) then
            P_N_GPO := 13;
          end if;
        
        else
          P_N_GPO := 0;
        end if;
      end if;
    
    end if;
  
    return P_N_GPO;
  
  EXCEPTION
  
    WHEN OTHERS THEN
      P_N_GPO := 0;
  END;

----------------------------------------------------------------------------------------------
end PQ_CR_REPORTE25;
/

