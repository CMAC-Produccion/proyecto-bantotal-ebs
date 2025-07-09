create or replace package PQ_CR_REPORTE_GARANTIAS_REALES is

  -- **************************************************************************************
  -- NOMBRE                      : PQ_CR_REPORTE_GARANTIAS_REALES
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 30/05/2025 12:15:16
  -- AUTOR DE CREACION           : JALVAROH
  -- ESTADO                      : ACTIVO
  -- ACCESO                      : PUBLICO
  -- Purpose                     : REPORTE EXCEL, GARANTIAS REALES INSCRITAS EN ESTADO NORMAL
  -----------------------------------------------------------------------------------------
  -- FECHA DE MODIFICACION       : 
  -- AUTOR DE LA MODIFICACION    : 
  -- DESCRIPCION DE MODIFICACION : 
  -- ************************************************************************************** 

  PROCEDURE SP_CR_LISTA_GARANTIA(VI_FECHA    IN DATE,
                                 VI_USUARIO  IN VARCHAR2,
                                 VO_CODERROR OUT VARCHAR2,
                                 VO_MSGERROR OUT VARCHAR2);

  --------------------------------------------------------------------------
  PROCEDURE SP_CR_DATOS_TITULAR(VI_CUENTA       IN NUMBER,
                                VI_NOM_TITULAR  OUT VARCHAR2,
                                VI_NDOC_TITULAR OUT CHAR);
  --------------------------------------------------------------------------
  PROCEDURE SP_CR_DATOS_INTEGRANTES(VI_CUENTA           IN NUMBER,
                                    VI_NOM_INTEGRANTES  OUT VARCHAR2,
                                    VI_NDOC_INTEGRANTES OUT VARCHAR2);

  ---------------------------------------------------------------------------
  PROCEDURE SP_CR_CREAR_REPORTE_EXCEL(VO_NOMBRE_ARCH OUT VARCHAR2);
  --------------------------------------------------------------------------
  procedure sp_cr_config_mail(p_c_de         in varchar2,
                              p_c_recipiente in varchar2,
                              subject        in varchar2,
                              fecha_proceso  in date,
                              v_header       in varchar2,
                              rawdata        in clob);
  --------------------------------------------------------------------------

  procedure sp_cr_mail_root(p_c_de         in varchar2,
                            p_c_recipiente in varchar2,
                            subject        in varchar2,
                            fecha_proceso  in date,
                            c_smtp_server  in varchar2,
                            port           in NUMBER,
                            host           in varchar2,
                            v_header       in varchar2,
                            rawdata        in clob);
  ------------------------------------------------------------------------------
  FUNCTION FN_OBTENER_PPG008Desc(VI_ppg000pgc IN NUMBER,
                                 VI_ppg000suc IN NUMBER,
                                 VI_ppg000mda IN NUMBER,
                                 VI_ppg000pap IN NUMBER,
                                 VI_ppg000cta IN NUMBER,
                                 VI_ppg000ope IN NUMBER,
                                 VI_ppg000sbo IN NUMBER,
                                 VI_ppg000top IN NUMBER,
                                 VI_cdat      IN NUMBER) RETURN CHAR;
  -------------------------------------------------------------------------
  FUNCTION FN_OBTENER_PPG001DATO(VI_ppg000pgc IN NUMBER,
                                 VI_ppg000suc IN NUMBER,
                                 VI_ppg000mda IN NUMBER,
                                 VI_ppg000pap IN NUMBER,
                                 VI_ppg000cta IN NUMBER,
                                 VI_ppg000ope IN NUMBER,
                                 VI_ppg000sbo IN NUMBER,
                                 VI_ppg000top IN NUMBER,
                                 VI_cdat      IN NUMBER) RETURN CHAR;
  ---------------------------------------------------------------------------

  FUNCTION FN_OBTENER_PPG002Dato(VI_ppg000pgc IN NUMBER,
                                 VI_ppg000suc IN NUMBER,
                                 VI_ppg000mda IN NUMBER,
                                 VI_ppg000pap IN NUMBER,
                                 VI_ppg000cta IN NUMBER,
                                 VI_ppg000ope IN NUMBER,
                                 VI_ppg000sbo IN NUMBER,
                                 VI_ppg000top IN NUMBER,
                                 VI_cdat      IN NUMBER) RETURN DATE;
  -----------------------------------------------------------------------------

  PROCEDURE SP_CR_INSERT_AQPD719(VI_AQPD719COD   IN NUMBER,
                                 VI_AQPD719SUC   IN NUMBER,
                                 VI_AQPD719MOD   IN NUMBER,
                                 VI_AQPD719MDA   IN NUMBER,
                                 VI_AQPD719PAP   IN NUMBER,
                                 VI_AQPD719CTA   IN NUMBER,
                                 VI_AQPD719OPER  IN NUMBER,
                                 VI_AQPD719SBOP  IN NUMBER,
                                 VI_AQPD719TOPE  IN NUMBER,
                                 VI_AQPD719TITR  IN VARCHAR2,
                                 VI_AQPD719NDOC  IN CHAR,
                                 VI_AQPD719INTEG IN VARCHAR2,
                                 VI_AQPD719NDOCG IN VARCHAR2,
                                 VI_AQPD719OFIR  IN CHAR,
                                 VI_AQPD719NPRE  IN CHAR,
                                 VI_AQPD719RINSC IN CHAR,
                                 VI_AQPD719FINSC IN DATE,
                                 VI_AQPD719TREG  IN CHAR,
                                 VI_AQPD719TCOB  IN CHAR,
                                 VI_AQPD719TAST  IN CHAR,
                                 VI_AQPD719ASTG  IN CHAR,
                                 VI_AQPD719FESC  IN DATE,
                                 VI_AQPD719FAST  IN DATE,
                                 VI_AQPD719NTITU IN CHAR,
                                 VI_AQPD719FCHA  IN DATE,
                                 VI_AQPD719HRAA  IN VARCHAR2,
                                 VI_AQPD719USUA  IN VARCHAR2);
  ----------------------------------------------------------------------
  PROCEDURE SP_CR_FECHA_MAXIMA(VI_FECHA OUT DATE);

end PQ_CR_REPORTE_GARANTIAS_REALES;
/
create or replace package body PQ_CR_REPORTE_GARANTIAS_REALES is

  -- **************************************************************************************
  -- NOMBRE                      : PQ_CR_REPORTE_GARANTIAS_REALES
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 30/05/2025 12:15:16
  -- AUTOR DE CREACION           : JALVAROH
  -- ESTADO                      : ACTIVO
  -- ACCESO                      : PUBLICO
  -- Purpose                     : REPORTE EXCEL, GARANTIAS REALES INSCRITAS EN ESTADO NORMAL
  -----------------------------------------------------------------------------------------
  -- FECHA DE MODIFICACION       : 
  -- AUTOR DE LA MODIFICACION    : 
  -- DESCRIPCION DE MODIFICACION : 
  -- ************************************************************************************** 

  PROCEDURE SP_CR_LISTA_GARANTIA(VI_FECHA    IN DATE,
                                 VI_USUARIO  IN VARCHAR2,
                                 VO_CODERROR OUT VARCHAR2,
                                 VO_MSGERROR OUT VARCHAR2)
  
   IS
    cursor lista_garantias is
      select a.PGCOD,
             a.SCSUC,
             a.SCMDA,
             a.SCPAP,
             a.SCCTA,
             a.SCOPER,
             a.SCSBOP,
             a.SCTOPE,
             a.SCMOD
        from fsd011 a
       where a.PGCOD = 1
         and a.scmod = 70
         and a.scstat = 0
         and a.sctope in (SELECT TP1NRO2
                            FROM fst198
                           WHERE TP1COD1 = 10846
                             AND TP1CORR1 = 80
                             AND TP1CORR2 = 1)
         and a.scstat = 0;
  
    cursor lista_garantias2(ln_operacion in number, ln_cuenta in number) is
      select x.xwfempresa,
             x.xwfmodulo,
             x.xwfmoneda,
             x.xwfpapel,
             x.xwfcuenta,
             x.xwfsucursal,
             x.xwfoperacion,
             x.xwfsubope,
             x.xwftipope
        from sng122 s
       inner join xwf700 x
          on x.xwfprcins = s.sng122inst
       where s.sng122oper = ln_operacion
         and s.SNG122CTA = ln_cuenta --se agregó cta
         and x.xwfcar3 = '1';
  
    ln_existe       number;
    ln_xwfprcins    number;
    ln_xwfempresa   number;
    ln_xwfmodulo    number;
    ln_xwfmoneda    number;
    ln_xwfpapel     number;
    ln_xwfcuenta    number;
    ln_xwfsucursal  number;
    ln_xwfoperacion number;
    ln_xwfsubope    number;
    ln_xwftipope    number;
    -------- salida de procedimiento --------
    ln_ppg000frm number;
    --------- VARIABLES DE LAS FUNCIONES-----
  
    VI_AQPD719OFIR      CHAR(50);
    VI_AQPD719NPRE      CHAR(50);
    VI_AQPD719RINSC     CHAR(50);
    VI_AQPD719FINSC     DATE;
    VI_AQPD719TREG      CHAR(50);
    VI_AQPD719TCOB      CHAR(50);
    VI_AQPD719TAST      CHAR(50);
    VI_AQPD719ASTG      CHAR(50);
    VI_AQPD719FESC      DATE;
    VI_AQPD719FAST      DATE;
    VI_AQPD719NTITU     CHAR(50);
    VI_HORA             VARCHAR2(10);
    VI_NOM_TITULAR      VARCHAR2(150);
    VI_NDOC_TITULAR     CHAR(12);
    VI_NOM_INTEGRANTES  VARCHAR2(450);
    VI_NDOC_INTEGRANTES VARCHAR2(450);
    VI_NOMBRE_ARCH      VARCHAR2(150);
    v_EXISTE_AQPD719    NUMBER := 0;
  
  BEGIN
  
    BEGIN
      SELECT 1
        INTO v_EXISTE_AQPD719
        FROM AQPD719 a
       WHERE a.aqpd719fcha = VI_FECHA
         AND ROWNUM = 1;
    EXCEPTION
      WHEN OTHERS THEN
        v_EXISTE_AQPD719 := NULL;
      
    END;
  
    IF v_EXISTE_AQPD719 = 1 THEN
      DELETE FROM AQPD719 WHERE AQPD719FCHA = VI_FECHA;
      COMMIT;
    END IF;
  
    VI_HORA := TO_CHAR(SYSDATE, 'HH24:MI:SS');
  
    BEGIN
    
      for f in lista_garantias loop
        BEGIN
          select /*+all_rows */ /*+parallel(a,4,@2)*/
          /*+parallel(b,4,@2)*/
           1
            into ln_existe
            from fsr011 b, fsd010 s
           where b.r2cod = f.pgcod
             and b.r2suc = f.SCSUC
             and b.r2mda = f.SCMDA
             and b.r2pap = f.SCPAP
             and b.r2cta = f.SCCTA
             and b.r2oper = f.SCOPER
             and b.r2sbop = f.SCSBOP
             and b.r2tope = f.SCTOPE
             and b.r2mod = f.SCMOD
             and s.pgcod = b.r1cod
             and s.aomod = b.r1mod
             and s.aosuc = b.r1suc
             and s.aomda = b.r1mda
             and s.aopap = b.r1pap
             and s.aocta = b.r1cta
             and s.aooper = b.r1oper
             and s.aosbop = b.r1sbop
             and s.aotope = b.r1tope
             and b.relcod = 50
             and s.aostat <> 99
             and b.r011co = 'S'
             and rownum = 1;
        EXCEPTION
          when others then
            ln_existe := 0;
        END;
        if (ln_existe = 0) then
          begin
            select 1
              into ln_existe
              from sng122 s
             inner join xwf700 x
                on x.xwfprcins = s.sng122inst
             inner join WFWRKITEMS w
                on w.WFINSPRCID = x.xwfprcins
             where s.sng122pgc = f.pgcod
               and s.sng122mod = f.SCMOD
               and s.sng122suc = f.SCSUC
               and s.sng122mda = f.SCMDA
               and s.sng122pap = f.SCPAP
               and s.sng122cta = f.SCCTA
               and s.sng122oper = f.SCOPER
               and s.sng122sbop = f.SCSBOP
               and s.sng122tope = f.SCTOPE
               and x.xwfcar3 = '1'
               and w.wftaskcod in (7, 11, 55)
               and w.WFITEMSTSACT = 1
               and rownum = 1;
          EXCEPTION
            when no_data_found then
              ln_existe := 0;
          end;
        end if;
        if (ln_existe = 0) then
          for k in lista_garantias2(f.SCOPER, f.SCCTA) loop
            begin
              select 1
                into ln_existe
                from fsd011 d
               where d.pgcod = k.xwfempresa
                 and d.scmod = k.xwfmodulo
                 and d.scmda = k.xwfmoneda
                 and d.scpap = k.xwfpapel
                 and d.sccta = k.xwfcuenta
                 and d.scsuc = k.xwfsucursal
                 and d.scoper = k.xwfoperacion
                 and d.scsbop = k.xwfsubope
                 and d.sctope = k.xwftipope
                    --and d.scmod <> 65
                 and d.scstat <> 99;
            EXCEPTION
              when no_data_found then
                ln_existe := 0;
            end;
            -- dbms_output.put_line('Garantías:-'||f.pgcod||'-'||f.SCSUC||'-'||f.SCMOD||'-'||f.SCMDA||'-'||f.SCPAP||'-'||f.SCCTA||'-'||f.SCOPER||'-'||f.SCSBOP||'-'||f.SCTOPE);
            -- dbms_output.put_line('ln_existe:-'||ln_existe||'-'||k.xwfempresa||'-'||k.xwfmodulo||'-'||k.xwfmoneda||'-'||k.xwfpapel||'-'|| k.xwfcuenta||'-'||k.xwfsucursal||'-'||k.xwfoperacion||'-'||k.xwfsubope||'-'||k.xwftipope);
            if (ln_existe = 1) then
              exit;
            end if;
          end loop;
        end if;
        if (ln_existe = 0) then
          begin
            select 1
              into ln_existe
              from sng122 s
             inner join xwf700 x
                on x.xwfprcins = s.sng122inst
               and x.xwfcar3 = '1'
             inner join WFWRKITEMS w
                on w.WFINSPRCID = x.xwfprcins
             where s.sng122pgc = f.pgcod
               and s.sng122mod = f.SCMOD
               and s.sng122suc = f.SCSUC
               and s.sng122mda = f.SCMDA
               and s.sng122pap = f.SCPAP
               and s.sng122cta = f.SCCTA
               and s.sng122oper = f.SCOPER
               and s.sng122sbop = f.SCSBOP
               and s.sng122tope = f.SCTOPE
               and w.wftaskcod in (7, 11, 55)
               and w.WFITEMSTSACT = 1
               and rownum = 1;
          EXCEPTION
            when no_data_found then
              ln_existe := 0;
          end;
        end if;
      
        if (ln_existe = 0) then
          /*  dbms_output.put_line('Garantías:-' || f.pgcod || '-' || f.SCSUC || '-' ||
          f.SCMOD || '-' || f.SCMDA || '-' || f.SCPAP || '-' ||
          f.SCCTA || '-' || f.SCOPER || '-' ||
          f.SCSBOP || '-' || f.SCTOPE); */
        
          PQ_CR_REPORTE_GARANTIAS_REALES.SP_CR_DATOS_TITULAR(VI_CUENTA       => f.SCCTA,
                                                             VI_NOM_TITULAR  => VI_NOM_TITULAR,
                                                             VI_NDOC_TITULAR => VI_NDOC_TITULAR);
        
          PQ_CR_REPORTE_GARANTIAS_REALES.SP_CR_DATOS_INTEGRANTES(VI_CUENTA           => f.SCCTA,
                                                                 VI_NOM_INTEGRANTES  => VI_NOM_INTEGRANTES,
                                                                 VI_NDOC_INTEGRANTES => VI_NDOC_INTEGRANTES);
        
          VI_AQPD719OFIR := PQ_CR_REPORTE_GARANTIAS_REALES.FN_OBTENER_PPG008Desc(VI_ppg000pgc => f.pgcod,
                                                                                 VI_ppg000suc => f.SCSUC,
                                                                                 VI_ppg000mda => f.SCMDA,
                                                                                 VI_ppg000pap => f.SCPAP,
                                                                                 VI_ppg000cta => f.SCCTA,
                                                                                 VI_ppg000ope => f.SCOPER,
                                                                                 VI_ppg000sbo => f.SCSBOP,
                                                                                 VI_ppg000top => f.SCTOPE,
                                                                                 VI_cdat      => 69);
        
          VI_AQPD719NPRE := PQ_CR_REPORTE_GARANTIAS_REALES.FN_OBTENER_PPG001DATO(VI_ppg000pgc => f.pgcod,
                                                                                 VI_ppg000suc => f.SCSUC,
                                                                                 VI_ppg000mda => f.SCMDA,
                                                                                 VI_ppg000pap => f.SCPAP,
                                                                                 VI_ppg000cta => f.SCCTA,
                                                                                 VI_ppg000ope => f.SCOPER,
                                                                                 VI_ppg000sbo => f.SCSBOP,
                                                                                 VI_ppg000top => f.SCTOPE,
                                                                                 VI_cdat      => 129);
        
          VI_AQPD719RINSC := PQ_CR_REPORTE_GARANTIAS_REALES.FN_OBTENER_PPG008Desc(VI_ppg000pgc => f.pgcod,
                                                                                  VI_ppg000suc => f.SCSUC,
                                                                                  VI_ppg000mda => f.SCMDA,
                                                                                  VI_ppg000pap => f.SCPAP,
                                                                                  VI_ppg000cta => f.SCCTA,
                                                                                  VI_ppg000ope => f.SCOPER,
                                                                                  VI_ppg000sbo => f.SCSBOP,
                                                                                  VI_ppg000top => f.SCTOPE,
                                                                                  VI_cdat      => 149);
        
          VI_AQPD719FINSC := PQ_CR_REPORTE_GARANTIAS_REALES.FN_OBTENER_PPG002Dato(VI_ppg000pgc => f.pgcod,
                                                                                  VI_ppg000suc => f.SCSUC,
                                                                                  VI_ppg000mda => f.SCMDA,
                                                                                  VI_ppg000pap => f.SCPAP,
                                                                                  VI_ppg000cta => f.SCCTA,
                                                                                  VI_ppg000ope => f.SCOPER,
                                                                                  VI_ppg000sbo => f.SCSBOP,
                                                                                  VI_ppg000top => f.SCTOPE,
                                                                                  VI_cdat      => 95);
        
          VI_AQPD719TREG := PQ_CR_REPORTE_GARANTIAS_REALES.FN_OBTENER_PPG008Desc(VI_ppg000pgc => f.pgcod,
                                                                                 VI_ppg000suc => f.SCSUC,
                                                                                 VI_ppg000mda => f.SCMDA,
                                                                                 VI_ppg000pap => f.SCPAP,
                                                                                 VI_ppg000cta => f.SCCTA,
                                                                                 VI_ppg000ope => f.SCOPER,
                                                                                 VI_ppg000sbo => f.SCSBOP,
                                                                                 VI_ppg000top => f.SCTOPE,
                                                                                 VI_cdat      => 106);
        
          VI_AQPD719TCOB := PQ_CR_REPORTE_GARANTIAS_REALES.FN_OBTENER_PPG008Desc(VI_ppg000pgc => f.pgcod,
                                                                                 VI_ppg000suc => f.SCSUC,
                                                                                 VI_ppg000mda => f.SCMDA,
                                                                                 VI_ppg000pap => f.SCPAP,
                                                                                 VI_ppg000cta => f.SCCTA,
                                                                                 VI_ppg000ope => f.SCOPER,
                                                                                 VI_ppg000sbo => f.SCSBOP,
                                                                                 VI_ppg000top => f.SCTOPE,
                                                                                 VI_cdat      => 108);
        
          VI_AQPD719TAST := PQ_CR_REPORTE_GARANTIAS_REALES.FN_OBTENER_PPG008Desc(VI_ppg000pgc => f.pgcod,
                                                                                 VI_ppg000suc => f.SCSUC,
                                                                                 VI_ppg000mda => f.SCMDA,
                                                                                 VI_ppg000pap => f.SCPAP,
                                                                                 VI_ppg000cta => f.SCCTA,
                                                                                 VI_ppg000ope => f.SCOPER,
                                                                                 VI_ppg000sbo => f.SCSBOP,
                                                                                 VI_ppg000top => f.SCTOPE,
                                                                                 VI_cdat      => 107);
        
          VI_AQPD719ASTG := PQ_CR_REPORTE_GARANTIAS_REALES.FN_OBTENER_PPG001DATO(VI_ppg000pgc => f.pgcod,
                                                                                 VI_ppg000suc => f.SCSUC,
                                                                                 VI_ppg000mda => f.SCMDA,
                                                                                 VI_ppg000pap => f.SCPAP,
                                                                                 VI_ppg000cta => f.SCCTA,
                                                                                 VI_ppg000ope => f.SCOPER,
                                                                                 VI_ppg000sbo => f.SCSBOP,
                                                                                 VI_ppg000top => f.SCTOPE,
                                                                                 VI_cdat      => 142);
        
          VI_AQPD719FESC := PQ_CR_REPORTE_GARANTIAS_REALES.FN_OBTENER_PPG002Dato(VI_ppg000pgc => f.pgcod,
                                                                                 VI_ppg000suc => f.SCSUC,
                                                                                 VI_ppg000mda => f.SCMDA,
                                                                                 VI_ppg000pap => f.SCPAP,
                                                                                 VI_ppg000cta => f.SCCTA,
                                                                                 VI_ppg000ope => f.SCOPER,
                                                                                 VI_ppg000sbo => f.SCSBOP,
                                                                                 VI_ppg000top => f.SCTOPE,
                                                                                 VI_cdat      => 93);
        
          VI_AQPD719FAST := PQ_CR_REPORTE_GARANTIAS_REALES.FN_OBTENER_PPG002Dato(VI_ppg000pgc => f.pgcod,
                                                                                 VI_ppg000suc => f.SCSUC,
                                                                                 VI_ppg000mda => f.SCMDA,
                                                                                 VI_ppg000pap => f.SCPAP,
                                                                                 VI_ppg000cta => f.SCCTA,
                                                                                 VI_ppg000ope => f.SCOPER,
                                                                                 VI_ppg000sbo => f.SCSBOP,
                                                                                 VI_ppg000top => f.SCTOPE,
                                                                                 VI_cdat      => 127);
        
          VI_AQPD719NTITU := PQ_CR_REPORTE_GARANTIAS_REALES.FN_OBTENER_PPG001DATO(VI_ppg000pgc => f.pgcod,
                                                                                  VI_ppg000suc => f.SCSUC,
                                                                                  VI_ppg000mda => f.SCMDA,
                                                                                  VI_ppg000pap => f.SCPAP,
                                                                                  VI_ppg000cta => f.SCCTA,
                                                                                  VI_ppg000ope => f.SCOPER,
                                                                                  VI_ppg000sbo => f.SCSBOP,
                                                                                  VI_ppg000top => f.SCTOPE,
                                                                                  VI_cdat      => 159);
        
          BEGIN
          
            PQ_CR_REPORTE_GARANTIAS_REALES.SP_CR_INSERT_AQPD719(VI_AQPD719COD   => f.pgcod,
                                                                VI_AQPD719SUC   => f.SCSUC,
                                                                VI_AQPD719MOD   => f.SCMOD,
                                                                VI_AQPD719MDA   => f.SCMDA,
                                                                VI_AQPD719PAP   => f.SCPAP,
                                                                VI_AQPD719CTA   => f.SCCTA,
                                                                VI_AQPD719OPER  => f.SCOPER,
                                                                VI_AQPD719SBOP  => f.SCSBOP,
                                                                VI_AQPD719TOPE  => f.SCTOPE,
                                                                VI_AQPD719TITR  => VI_NOM_TITULAR,
                                                                VI_AQPD719NDOC  => TRIM(VI_NDOC_TITULAR),
                                                                VI_AQPD719INTEG => VI_NOM_INTEGRANTES,
                                                                VI_AQPD719NDOCG => VI_NDOC_INTEGRANTES,
                                                                VI_AQPD719OFIR  => TRIM(VI_AQPD719OFIR),
                                                                VI_AQPD719NPRE  => TRIM(VI_AQPD719NPRE),
                                                                VI_AQPD719RINSC => TRIM(VI_AQPD719RINSC),
                                                                VI_AQPD719FINSC => VI_AQPD719FINSC,
                                                                VI_AQPD719TREG  => TRIM(VI_AQPD719TREG),
                                                                VI_AQPD719TCOB  => tRIM(VI_AQPD719TCOB),
                                                                VI_AQPD719TAST  => TRIM(VI_AQPD719TAST),
                                                                VI_AQPD719ASTG  => TRIM(VI_AQPD719ASTG),
                                                                VI_AQPD719FESC  => VI_AQPD719FESC,
                                                                VI_AQPD719FAST  => VI_AQPD719FAST,
                                                                VI_AQPD719NTITU => TRIM(VI_AQPD719NTITU),
                                                                VI_AQPD719FCHA  => VI_FECHA,
                                                                VI_AQPD719HRAA  => VI_HORA,
                                                                VI_AQPD719USUA  => VI_USUARIO);
          
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
            
          END;
        
        ELSE
        
          VI_AQPD719OFIR  := NULL;
          VI_AQPD719NPRE  := NULL;
          VI_AQPD719RINSC := NULL;
          VI_AQPD719FINSC := NULL;
          VI_AQPD719TREG  := NULL;
          VI_AQPD719TCOB  := NULL;
          VI_AQPD719TAST  := NULL;
          VI_AQPD719ASTG  := NULL;
          VI_AQPD719FESC  := NULL;
          VI_AQPD719FAST  := NULL;
          VI_AQPD719NTITU := NULL;
        
        end if;
      end loop;
    
      BEGIN
      
        PQ_CR_REPORTE_GARANTIAS_REALES.SP_CR_CREAR_REPORTE_EXCEL(VO_NOMBRE_ARCH => VI_NOMBRE_ARCH);
      
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
        
      END;
    END;
  
  END SP_CR_LISTA_GARANTIA;

  PROCEDURE SP_CR_DATOS_TITULAR(VI_CUENTA       IN NUMBER,
                                VI_NOM_TITULAR  OUT VARCHAR2,
                                VI_NDOC_TITULAR OUT CHAR) IS
  
  BEGIN
  
    BEGIN
      SELECT PENDOC
        INTO VI_NDOC_TITULAR
        FROM fsr008 F
       WHERE F.ctnro = VI_CUENTA
         AND F.CTTFIR = 'T';
    EXCEPTION
      WHEN OTHERS THEN
        VI_NDOC_TITULAR := NULL;
      
    END;
  
    BEGIN
      SELECT PENOM
        INTO VI_NOM_TITULAR
        FROM fsd001
       WHERE pendoc = VI_NDOC_TITULAR;
    EXCEPTION
      WHEN OTHERS THEN
        VI_NDOC_TITULAR := NULL;
      
    END;
  
  END SP_CR_DATOS_TITULAR;

  PROCEDURE SP_CR_DATOS_INTEGRANTES(VI_CUENTA           IN NUMBER,
                                    VI_NOM_INTEGRANTES  OUT VARCHAR2,
                                    VI_NDOC_INTEGRANTES OUT VARCHAR2) IS
    -- Variables locales
    CURSOR C_DOCS IS
      SELECT PENDOC
        FROM fsr008 F
       WHERE F.ctnro = VI_CUENTA
         AND F.CTTFIR <> 'T';
  
    V_DOC VARCHAR2(450);
    V_NOM VARCHAR2(450);
  BEGIN
    -- Inicializa las variables de salida
    VI_NDOC_INTEGRANTES := '';
    VI_NOM_INTEGRANTES  := '';
  
    -- Recorre los documentos
    FOR R_DOC IN C_DOCS LOOP
      V_DOC := R_DOC.PENDOC;
    
      -- Concatenar documento con ;
      IF VI_NDOC_INTEGRANTES IS NOT NULL THEN
        VI_NDOC_INTEGRANTES := TRIM(VI_NDOC_INTEGRANTES) || '; ';
      END IF;
      VI_NDOC_INTEGRANTES := TRIM(V_DOC);
    
      -- Buscar nombre correspondiente
      BEGIN
        SELECT PENOM INTO V_NOM FROM fsd001 WHERE pendoc = V_DOC;
      
        -- Concatenar nombre con ;
        IF VI_NOM_INTEGRANTES IS NOT NULL THEN
          VI_NOM_INTEGRANTES := TRIM(VI_NOM_INTEGRANTES) || '; ';
        END IF;
        VI_NOM_INTEGRANTES := TRIM(V_NOM);
      
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          NULL; -- Si no encuentra nombre, simplemente continúa
        WHEN OTHERS THEN
          NULL; -- Manejo general de errores
      END;
    END LOOP;
  END SP_CR_DATOS_INTEGRANTES;

  PROCEDURE SP_CR_CREAR_REPORTE_EXCEL(VO_NOMBRE_ARCH OUT VARCHAR2) IS
  
    cursor correos is
      select *
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10881
         and a.tp1corr1 = 7
         and a.tp1corr2 = 2
         and a.tp1corr3 > 0; -- destinatarios principales
  
    cursor datos_reporte is
      SELECT a.aqpd719cod,
             a.aqpd719suc,
             a.aqpd719mod,
             a.aqpd719mda,
             a.aqpd719pap,
             a.aqpd719cta,
             a.aqpd719oper,
             a.aqpd719sbop,
             a.aqpd719tope,
             a.AQPD719TITR,
             a.AQPD719NDOC,
             a.AQPD719INTEG,
             a.AQPD719NDOCG,
             a.AQPD719OFIR,
             a.AQPD719NPRE,
             a.AQPD719RINSC,
             a.AQPD719FINSC,
             a.AQPD719TREG,
             a.AQPD719TCOB,
             a.AQPD719TAST,
             a.AQPD719ASTG,
             a.AQPD719FESC,
             a.AQPD719FAST,
             a.AQPD719NTITU
        FROM aqpd719 a
       WHERE a.aqpd719fcha =
             (SELECT Pgfape FROM Fst017 S WHERE S.PGCOD = 1);
  
    v_wstring     clob;
    v_header      varchar2(10000);
    subject       varchar2(1000);
    remitente     varchar2(100);
    contador      number := 0;
    data          varchar2(32000);
    fecha_proceso date;
    v_hora_actual VARCHAR2(8); -- Formato HH24:MI:SS
    flag_data     char(1);
    NOM_USERS     CHAR(30);
    titulo_excel  varchar2(500);
  
  BEGIN
  
    -- sacamos fecha 
    BEGIN
      SELECT Pgfape INTO fecha_proceso FROM FST017 q WHERE q.pgcod = 1;
      v_hora_actual := TO_CHAR(SYSDATE, 'HH24:MI:SS');
    EXCEPTION
      WHEN OTHERS THEN
        fecha_proceso := NULL;
    END;
  
    -- Validar si existen datos
    BEGIN
      SELECT 'S' INTO flag_data FROM aqpd719 WHERE rownum = 1;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        flag_data := 'N';
    END;
  
    IF flag_data = 'N' THEN
      VO_NOMBRE_ARCH := NULL;
      RETURN; -- No hay datos, salimos
    END IF;
  
    -- Obtener remitente
    BEGIN
      remitente := 'notificaciones@cajaarequipa.pe';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        remitente := 'notificaciones@cajaarequipa.pe'; -- Valor por defecto si no existe
    END;
  
    FOR corr IN correos LOOP
      -- Construir cuerpo del archivo
      v_wstring := NULL;
      contador  := 0;
    
      BEGIN
        SELECT UBNOM
          INTO NOM_USERS
          FROM fst746
         WHERE UBUSER = UPPER(RPAD(corr.tp1desc, 10, ' '));
      
      EXCEPTION
        WHEN OTHERS THEN
          NOM_USERS := NULL;
      END;
    
      -- Reemplaza la sección donde construyes los datos (líneas del FOR r IN datos_reporte LOOP)
    
      FOR r IN datos_reporte LOOP
        contador := contador + 1;
      
        -- DATOS CORREGIDOS CON MANEJO DE NULLS - Usa NVL y TRIM para evitar valores vacíos
        data := contador || chr(9) || -- NRO               
                NVL(TRIM(r.aqpd719cod), ' ') || chr(9) || -- CODIGO  
                NVL(TRIM(r.aqpd719suc), ' ') || chr(9) || -- SUCURSAL
                NVL(TRIM(r.aqpd719mod), ' ') || chr(9) || -- MODULO
                NVL(TRIM(r.aqpd719mda), ' ') || chr(9) || -- MONEDA
                NVL(TRIM(r.aqpd719pap), ' ') || chr(9) || -- PAPEL
                NVL(TRIM(r.aqpd719cta), ' ') || chr(9) || -- CUENTA
                NVL(TRIM(r.aqpd719oper), ' ') || chr(9) || -- OPERACION
                NVL(TRIM(r.aqpd719sbop), ' ') || chr(9) || -- SUBOPERACION
                NVL(TRIM(r.aqpd719tope), ' ') || chr(9) || -- TOPE
                NVL(TRIM(r.AQPD719TITR), ' ') || chr(9) || -- TITULAR              
                '="' || NVL(TRIM(REPLACE(r.AQPD719NDOC, CHR(9), '')), ' ') || '"' ||
                chr(9) || -- DOCUMENTO
                NVL(TRIM(r.AQPD719INTEG), ' ') || chr(9) || -- INTEGRANTES
                '="' || NVL(TRIM(r.AQPD719NDOCG), ' ') || '"' || chr(9) || -- DOC. INTEGRANTES
                NVL(TRIM(REPLACE(r.AQPD719OFIR, CHR(9), '')), ' ') || chr(9) || -- OFICINA REGISTRAL
                '="' || NVL(TRIM(REPLACE(r.AQPD719NPRE, CHR(9), '')), ' ') || '"' ||
                chr(9) || -- Nro. Partid/Cod Predio
                NVL(TRIM(REPLACE(r.AQPD719RINSC, CHR(9), '')), ' ') || chr(9) || -- RANGO INSCRIPCION
               
               -- FECHA INS. RRPP
                CASE
                  WHEN r.AQPD719FINSC = TO_DATE('01/01/0001', 'DD/MM/YYYY') THEN
                   ' '
                  ELSE
                   NVL(TO_CHAR(r.AQPD719FINSC, 'DD/MM/YYYY'), ' ')
                END || chr(9) ||
               
                NVL(TRIM(REPLACE(r.AQPD719TREG, CHR(9), '')), ' ') || chr(9) || -- TIPO REGISTRO
                NVL(TRIM(REPLACE(r.AQPD719TCOB, CHR(9), '')), ' ') || chr(9) || -- TIPO COBERTURA
                NVL(TRIM(REPLACE(r.AQPD719TAST, CHR(9), '')), ' ') || chr(9) || -- TIPO ASIENTO
                '="' || NVL(TRIM(REPLACE(r.AQPD719ASTG, CHR(9), '')), ' ') || '"' ||
                chr(9) || -- ASIENTO GRAVAMEN
               
               -- FECHA ESCRITURA
                CASE
                  WHEN r.AQPD719FESC = TO_DATE('01/01/0001', 'DD/MM/YYYY') THEN
                   ' '
                  ELSE
                   NVL(TO_CHAR(r.AQPD719FESC, 'DD/MM/YYYY'), ' ')
                END || chr(9) ||
               
               -- FECHA ASIENTO
                CASE
                  WHEN r.AQPD719FAST = TO_DATE('01/01/0001', 'DD/MM/YYYY') THEN
                   ' '
                  ELSE
                   NVL(TO_CHAR(r.AQPD719FAST, 'DD/MM/YYYY'), ' ')
                END || chr(9) ||
               
                '="' || NVL(TRIM(REPLACE(r.AQPD719NTITU, CHR(9), '')), ' ') || '"' ||
                chr(9) || -- NRO. TITULO
                utl_tcp.crlf;
      
        v_wstring := v_wstring || to_clob(data);
      END LOOP;
    
      -- Cabecera del correo con archivo adjunto
      v_header := 'MIME-Version: 1.0' || utl_tcp.crlf ||
                  'Content-Type: multipart/mixed;' || utl_tcp.crlf ||
                  ' boundary=-----SECBOUND' || utl_tcp.crlf || utl_tcp.crlf ||
                  '-------SECBOUND' || utl_tcp.crlf ||
                  'Content-Type: text/plain;' || utl_tcp.crlf ||
                  'Content-Transfer_Encoding: 8bit' || utl_tcp.crlf ||
                  utl_tcp.crlf || 'Estimad@ ' || TRIM(NOM_USERS) || ',' ||
                  CHR(13) || CHR(13) ||
                  'Se adjunta el reporte de garantias reales inscritas.' ||
                  CHR(13) || utl_tcp.crlf || '-------SECBOUND' ||
                  utl_tcp.crlf ||
                  'Content-Type: application/vnd.ms-excel; charset=windows-1252' ||
                  utl_tcp.crlf || ' name=Reporte_' ||
                  TO_CHAR(fecha_proceso, 'DD-MM-YYYY') || '.xls' ||
                  utl_tcp.crlf || 'Content-Transfer_Encoding: 8bit' ||
                  utl_tcp.crlf || 'Content-Disposition: attachment;' ||
                  utl_tcp.crlf || ' filename=Reporte_' ||
                  TO_CHAR(fecha_proceso, 'DD-MM-YYYY') || '.xls' ||
                  utl_tcp.crlf || utl_tcp.crlf;
    
      -- **TÍTULO CON FECHA Y HORA EN LA PARTE SUPERIOR**
      v_header := v_header || 'REPORTE DE GARANTIAS REALES INSCRITAS - ' ||
                  TO_CHAR(fecha_proceso, 'DD/MM/YYYY - ') || v_hora_actual ||
                  utl_tcp.crlf || utl_tcp.crlf;
    
      -- Agregar nombres de columnas
      v_header := v_header || 'NRO' || chr(9) || 'CODIGO' || chr(9) ||
                  'SUCURSAL' || chr(9) || 'MODULO' || chr(9) || 'MONEDA' ||
                  chr(9) || 'PAPEL' || chr(9) || 'CUENTA' || chr(9) ||
                  'OPERACION' || chr(9) || 'SUBOPERACION' || chr(9) ||
                  'TOPE' || chr(9) || 'TITULAR' || chr(9) || 'DOCUMENTO' ||
                  chr(9) || 'INTEGRANTES' || chr(9) || 'DOC. INTEGRANTES' ||
                  chr(9) || 'OFICINA REGISTRAL' || chr(9) ||
                  'Nro. Partid/Cod Predio' || chr(9) || 'RANGO INSCRIPCION' ||
                  chr(9) || 'FECHA INS. RRPP' || chr(9) || 'TIPO REGISTRO' ||
                  chr(9) || 'TIPO COBERTURA' || chr(9) || 'TIPO ASIENTO' ||
                  chr(9) || 'ASIENTO GRAVAMEN' || chr(9) ||
                  'FECHA ESCRITURA' || chr(9) || 'FECHA ASIENTO' || chr(9) ||
                  'NRO. TITULO';
    
      -- Enviar correo
      IF v_wstring IS NOT NULL THEN
        PQ_CR_REPORTE_GARANTIAS_REALES.sp_cr_config_mail(remitente, -- de
                                                         corr.TP1DESC, -- para
                                                         'Reporte Garantias Reales - ' ||
                                                         TO_CHAR(fecha_proceso,
                                                                 'YYYY/MM/DD'), -- asunto
                                                         fecha_proceso,
                                                         v_header,
                                                         v_wstring);
      END IF;
    END LOOP;
  
    -- Nombre del archivo final
    VO_NOMBRE_ARCH := 'Reporte_' || TO_CHAR(fecha_proceso, 'DD-MM-YYYY') ||
                      '.xls';
  
  END SP_CR_CREAR_REPORTE_EXCEL;

  procedure sp_cr_config_mail( ------------------------
                              p_c_de         in varchar2, -- De    
                              p_c_recipiente in varchar2, -- Para
                              subject        in varchar2, -- Subject                         
                              fecha_proceso  in date, -- Fecha de proceso                          
                              v_header       in varchar2, -- Cabecera
                              rawdata        in clob -- Detalle Excel
                              ) is
    --Cursor
    cursor c_host is
      select *
        from fst198
       Where Tp1cod = 1
         and Tp1cod1 = 10825
         and Tp1corr1 = 61
         and Tp1corr2 = 7;
    -- Variables
    c_smtp_server VARCHAR2(30);
    port          number;
    host          VARCHAR2(100);
    -- 
    lc_hostname varchar2(64);
    lv_smtp     varchar2(30);
    lv_host     varchar2(30);
    ln_port     number(9);
  begin
  
    begin
      select host_name into lc_hostname from v$instance;
    exception
      WHEN NO_DATA_FOUND then
        lc_hostname := '';
    end;
  
    For i in c_host loop
      lv_host := upper(TRIM(substr(i.tp1desc, 1, instr(i.tp1desc, '/') - 1)));
      lv_smtp := TRIM(substr(i.tp1desc,
                             instr(i.tp1desc, '/') + 1,
                             length(trim(i.tp1desc))));
      ln_port := i.tp1nro3;
    
      if upper(lc_hostname) = lv_host then
      
        Exit;
      End if;
    End loop;
  
    c_smtp_server := lv_smtp; --'10.0.200.68';
    port          := ln_port; --2530;
  
    host := lv_host;
  
    PQ_CR_REPORTE_GARANTIAS_REALES.sp_cr_mail_root(p_c_de, --de
                                                   p_c_recipiente, --para
                                                   subject, --subject
                                                   fecha_proceso, --fecha de procesamiento
                                                   -------------------------
                                                   c_smtp_server, -- ip del servidor
                                                   port, -- puerto del servidor
                                                   host, -- host del servidor
                                                   -------------------------                            
                                                   v_header, -- Cabecera
                                                   rawdata -- Detalle Excel
                                                   );
  end sp_cr_config_mail;

  procedure sp_cr_mail_root(p_c_de         in varchar2, -- De
                            p_c_recipiente in varchar2, -- Para
                            subject        in varchar2, -- Subject
                            fecha_proceso  in date, -- Fecha de Proceso
                            --------------------
                            c_smtp_server in varchar2, -- Ip
                            port          in NUMBER, -- Puerto
                            host          in varchar2, -- Host
                            --------------------                            
                            v_header in varchar2, -- Cabecera
                            rawdata  in clob -- Detalle Excel
                            ) is
  
    v_wstring   varchar2(32000);
    auxiliar    varchar2(32000);
    v_From      VARCHAR2(80);
    v_Recipient VARCHAR2(80);
  
    v_Subject  VARCHAR2(80);
    V_Conexion utl_smtp.Connection;
    v_clob     CLOB;
    msg        varchar2(32767);
    p_c_msgerr VARCHAR2(1000);
    vhost_name VARCHAR2(100);
    v_found    number;
    l_n_offset NUMBER := 630;
    v_TP1DESC  CHAR(30);
  
  begin
    v_clob := 'Number' || ',' || 'Name' || UTL_TCP.crlf;
  
    BEGIN
    
      SELECT HOST_NAME INTO VHOST_NAME FROM V$INSTANCE;
    
    EXCEPTION
      WHEN OTHERS THEN
        VHOST_NAME := NULL;
    END;
  
    BEGIN
    
      select TP1DESC
        into v_TP1DESC
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10881
         and a.tp1corr1 = 7
         and a.tp1corr2 = 1
         and a.tp1corr3 = 1;
    
    EXCEPTION
      WHEN OTHERS THEN
        VHOST_NAME := NULL;
    END;
  
    v_From      := p_c_de;
    v_Recipient := trim(p_c_recipiente) || trim(v_TP1DESC);
    v_Subject   := subject;
  
    SELECT count(*)
      into v_found
      FROM systabrep.hostnames
     where habilitado = 'S'
       and upper(host_name) = UPPER(vhost_name);
  
    if v_found = 1 then
      V_Conexion := UTL_SMTP.OPEN_CONNECTION(c_smtp_server, port);
      msg        := 'Date: ' ||
                    to_char(sysdate, 'Dy, DD Mon YYYY hh24:mi:ss') ||
                    utl_tcp.crlf || 'From: ' || v_From || utl_tcp.crlf ||
                    'Subject: ' || v_Subject || utl_tcp.crlf || 'To: ' ||
                    v_Recipient || utl_tcp.crlf;
    
      --Se negocia la transaccion con el servidor SMTP
      utl_smtp.Helo(V_Conexion, c_smtp_server);
      utl_smtp.Mail(V_Conexion, v_From);
      utl_smtp.Rcpt(V_Conexion, v_Recipient);
    
      UTL_SMTP.OPEN_DATA(V_Conexion);
    
      --Se escribe la cabecera
      UTL_SMTP.WRITE_DATA(V_Conexion, msg);
      --Se escribe el contenido del mensaje 
      utl_smtp.write_data(V_Conexion, v_header || utl_tcp.crlf);
      FOR loop_att IN 0 .. TRUNC(DBMS_LOB.getlength(rawdata) / l_n_offset) LOOP
        auxiliar := DBMS_LOB.substr(rawdata,
                                    l_n_offset,
                                    loop_att * l_n_offset + 1);
        UTL_SMTP.write_data(V_Conexion, auxiliar);
      END LOOP;
    
      utl_smtp.write_data(V_Conexion, utl_tcp.crlf);
      utl_smtp.write_data(V_Conexion, utl_tcp.crlf);
      utl_smtp.write_data(V_Conexion, '-------SECBOUND--'); -- End MIME mail
      utl_smtp.write_data(V_Conexion, utl_tcp.crlf);
      --Cerramos la conexion
      UTL_SMTP.close_data(V_Conexion);
      UTL_SMTP.quit(V_Conexion);
    end if;
  
  EXCEPTION
    WHEN utl_smtp.Transient_Error OR utl_smtp.Permanent_Error THEN
      p_c_msgerr := 'Unable to send mail: ' || sqlerrm;
      raise_application_error(-20000,
                              'Unable to send mail: ' || p_c_msgerr);
    
  end sp_cr_mail_root;

  FUNCTION FN_OBTENER_PPG008Desc(VI_ppg000pgc IN NUMBER,
                                 VI_ppg000suc IN NUMBER,
                                 VI_ppg000mda IN NUMBER,
                                 VI_ppg000pap IN NUMBER,
                                 VI_ppg000cta IN NUMBER,
                                 VI_ppg000ope IN NUMBER,
                                 VI_ppg000sbo IN NUMBER,
                                 VI_ppg000top IN NUMBER,
                                 VI_cdat      IN NUMBER) RETURN CHAR IS
  
    VI_PPG008Desc CHAR(50);
  
  BEGIN
  
    BEGIN
      SELECT PPG008DESC
        INTO VI_PPG008Desc
        FROM ppg000 p
       INNER JOIN ppg008 a
          ON a.ppg008pgc = p.ppg000pgc
         AND a.PPG008MOD = p.ppg000mod
         AND a.PPG008SUC = p.ppg000suc
         AND a.PPG008MDA = p.ppg000mda
         AND a.PPG008PAP = p.ppg000pap
         AND a.PPG008CTA = p.ppg000cta
         AND a.PPG008OPE = p.ppg000ope
         AND a.PPG008SBO = p.ppg000sbo
         AND a.PPG008TOP = p.ppg000top
         AND a.ppg008frm = p.ppg000frm
         AND a.ppg008cdat = VI_cdat
       WHERE p.ppg000pgc = VI_ppg000pgc
         AND p.ppg000suc = VI_ppg000suc
         AND p.ppg000mda = VI_ppg000mda
         AND p.ppg000pap = VI_ppg000pap
         AND p.ppg000cta = VI_ppg000cta
         AND p.ppg000ope = VI_ppg000ope
         AND p.ppg000sbo = VI_ppg000sbo
         AND p.ppg000top = VI_ppg000top
         AND p.ppg000tco = 'S';
    
    EXCEPTION
      WHEN OTHERS THEN
      
        NULL;
    END;
  
    RETURN TRIM(VI_PPG008Desc);
  
  END FN_OBTENER_PPG008Desc;

  FUNCTION FN_OBTENER_PPG001DATO(VI_ppg000pgc IN NUMBER,
                                 VI_ppg000suc IN NUMBER,
                                 VI_ppg000mda IN NUMBER,
                                 VI_ppg000pap IN NUMBER,
                                 VI_ppg000cta IN NUMBER,
                                 VI_ppg000ope IN NUMBER,
                                 VI_ppg000sbo IN NUMBER,
                                 VI_ppg000top IN NUMBER,
                                 VI_cdat      IN NUMBER) RETURN CHAR IS
  
    VI_PPG001DATO CHAR(50);
  
  BEGIN
  
    BEGIN
      SELECT PPG001DATO
        INTO VI_PPG001DATO
        FROM ppg000 p
       INNER JOIN ppg001 a
          ON a.ppg001cod = p.ppg000pgc
         AND a.ppg001mod = p.ppg000mod
         AND a.ppg001suc = p.ppg000suc
         AND a.ppg001mda = p.ppg000mda
         AND a.ppg001pap = p.ppg000pap
         AND a.ppg001cta = p.ppg000cta
         AND a.ppg001ope = p.ppg000ope
         AND a.ppg001sbo = p.ppg000sbo
         AND a.ppg001top = p.ppg000top
         AND a.ppg001frm = p.ppg000frm
         AND a.ppg001cdat = VI_cdat
       WHERE p.ppg000pgc = VI_ppg000pgc
         AND p.ppg000suc = VI_ppg000suc
         AND p.ppg000mda = VI_ppg000mda
         AND p.ppg000pap = VI_ppg000pap
         AND p.ppg000cta = VI_ppg000cta
         AND p.ppg000ope = VI_ppg000ope
         AND p.ppg000sbo = VI_ppg000sbo
         AND p.ppg000top = VI_ppg000top
         AND p.ppg000tco = 'S';
    
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    RETURN TRIM(VI_PPG001DATO);
  
  END FN_OBTENER_PPG001DATO;

  FUNCTION FN_OBTENER_PPG002Dato(VI_ppg000pgc IN NUMBER,
                                 VI_ppg000suc IN NUMBER,
                                 VI_ppg000mda IN NUMBER,
                                 VI_ppg000pap IN NUMBER,
                                 VI_ppg000cta IN NUMBER,
                                 VI_ppg000ope IN NUMBER,
                                 VI_ppg000sbo IN NUMBER,
                                 VI_ppg000top IN NUMBER,
                                 VI_cdat      IN NUMBER) RETURN DATE IS
  
    VI_PPG002DATO DATE;
  
  BEGIN
  
    BEGIN
      SELECT PPG002DATO
        INTO VI_PPG002DATO
        FROM ppg000 p
       INNER JOIN ppg002 a
          ON a.ppg002cod = p.ppg000pgc
         AND a.ppg002mod = p.ppg000mod
         AND a.ppg002suc = p.ppg000suc
         AND a.ppg002mda = p.ppg000mda
         AND a.ppg002pap = p.ppg000pap
         AND a.ppg002cta = p.ppg000cta
         AND a.ppg002ope = p.ppg000ope
         AND a.ppg002sbo = p.ppg000sbo
         AND a.ppg002top = p.ppg000top
         AND a.ppg002frm = p.ppg000frm
         AND a.ppg002cdat = VI_cdat
       WHERE p.ppg000pgc = VI_ppg000pgc
         AND p.ppg000suc = VI_ppg000suc
         AND p.ppg000mda = VI_ppg000mda
         AND p.ppg000pap = VI_ppg000pap
         AND p.ppg000cta = VI_ppg000cta
         AND p.ppg000ope = VI_ppg000ope
         AND p.ppg000sbo = VI_ppg000sbo
         AND p.ppg000top = VI_ppg000top
         AND p.ppg000tco = 'S';
    
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    RETURN VI_PPG002DATO;
  
  END FN_OBTENER_PPG002Dato;

  PROCEDURE SP_CR_INSERT_AQPD719(VI_AQPD719COD   IN NUMBER,
                                 VI_AQPD719SUC   IN NUMBER,
                                 VI_AQPD719MOD   IN NUMBER,
                                 VI_AQPD719MDA   IN NUMBER,
                                 VI_AQPD719PAP   IN NUMBER,
                                 VI_AQPD719CTA   IN NUMBER,
                                 VI_AQPD719OPER  IN NUMBER,
                                 VI_AQPD719SBOP  IN NUMBER,
                                 VI_AQPD719TOPE  IN NUMBER,
                                 VI_AQPD719TITR  IN VARCHAR2,
                                 VI_AQPD719NDOC  IN CHAR,
                                 VI_AQPD719INTEG IN VARCHAR2,
                                 VI_AQPD719NDOCG IN VARCHAR2,
                                 VI_AQPD719OFIR  IN CHAR,
                                 VI_AQPD719NPRE  IN CHAR,
                                 VI_AQPD719RINSC IN CHAR,
                                 VI_AQPD719FINSC IN DATE,
                                 VI_AQPD719TREG  IN CHAR,
                                 VI_AQPD719TCOB  IN CHAR,
                                 VI_AQPD719TAST  IN CHAR,
                                 VI_AQPD719ASTG  IN CHAR,
                                 VI_AQPD719FESC  IN DATE,
                                 VI_AQPD719FAST  IN DATE,
                                 VI_AQPD719NTITU IN CHAR,
                                 VI_AQPD719FCHA  IN DATE,
                                 VI_AQPD719HRAA  IN VARCHAR2,
                                 VI_AQPD719USUA  IN VARCHAR2) IS
  
  BEGIN
  
    INSERT INTO AQPD719
      (AQPD719COD,
       AQPD719SUC,
       AQPD719MOD,
       AQPD719MDA,
       AQPD719PAP,
       AQPD719CTA,
       AQPD719OPER,
       AQPD719SBOP,
       AQPD719TOPE,
       AQPD719TITR,
       AQPD719NDOC,
       AQPD719INTEG,
       AQPD719NDOCG,
       AQPD719OFIR,
       AQPD719NPRE,
       AQPD719RINSC,
       AQPD719FINSC,
       AQPD719TREG,
       AQPD719TCOB,
       AQPD719TAST,
       AQPD719ASTG,
       AQPD719FESC,
       AQPD719FAST,
       AQPD719NTITU,
       AQPD719FCHA,
       AQPD719HRAA,
       AQPD719USUA)
    VALUES
      (VI_AQPD719COD,
       VI_AQPD719SUC,
       VI_AQPD719MOD,
       VI_AQPD719MDA,
       VI_AQPD719PAP,
       VI_AQPD719CTA,
       VI_AQPD719OPER,
       VI_AQPD719SBOP,
       VI_AQPD719TOPE,
       VI_AQPD719TITR,
       VI_AQPD719NDOC,
       VI_AQPD719INTEG,
       VI_AQPD719NDOCG,
       VI_AQPD719OFIR,
       VI_AQPD719NPRE,
       VI_AQPD719RINSC,
       VI_AQPD719FINSC,
       VI_AQPD719TREG,
       VI_AQPD719TCOB,
       VI_AQPD719TAST,
       VI_AQPD719ASTG,
       VI_AQPD719FESC,
       VI_AQPD719FAST,
       VI_AQPD719NTITU,
       VI_AQPD719FCHA,
       VI_AQPD719HRAA,
       VI_AQPD719USUA);
  
    COMMIT;
    -- DBMS_OUTPUT.PUT_LINE('Registro insertado exitosamente en AQPD719.');
  EXCEPTION
    WHEN OTHERS THEN
      -- Manejo de errores
      ROLLBACK;
      --  DBMS_OUTPUT.PUT_LINE('Error al insertar el registro: ' || SQLERRM);
  
  END SP_CR_INSERT_AQPD719;

  PROCEDURE SP_CR_FECHA_MAXIMA(VI_FECHA OUT DATE) IS
  
  BEGIN
    BEGIN
      SELECT MAX(AQPD719FCHA) INTO VI_FECHA FROM AQPD719;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
  END SP_CR_FECHA_MAXIMA;

end PQ_CR_REPORTE_GARANTIAS_REALES;
/
