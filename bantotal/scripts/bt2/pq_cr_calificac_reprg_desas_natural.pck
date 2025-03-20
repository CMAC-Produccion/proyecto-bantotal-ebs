create or replace package pq_cr_calificac_reprg_desas_natural is

  /* ************************************************************************************************************
     -- Nombre                     : pq_cr_calificac_reprg_desas_natural
     -- Sistema                    : BANTOTAL
     -- Módulo                     : ACTIVAS
     -- Descripción                : Validar calificación para reprog. desastre natural sin capitalización
     -- Versión                    : 1.0
     -- Fecha de Creación          : 4/07/2024 11:20:53
     -- Autor de Creación          : IGS_RCASTRO
     -- Estado                     : Activo
     -- Acceso                     : Público
     -- Fecha de Modificación      : 15/08/2024
     -- Autor de la Modificación   : Rcastro - Mcordova
     -- Descripción de Modificación: Se agrega controles de periodo de gracia y plazo máximo
  * *************************************************************************************************************/

  procedure SP_CR_CALIFIC_RCC(instancia in number, outRpsta out varchar2);
  
  procedure sp_cr_control_periodio_gracia_sin_CRM(ve_instancia in int,
                                                  ln_rpta      out varchar2,
                                                  PO_CodError  out varchar,
                                                  PO_MsgError  out varchar);
                                                  
  procedure sp_cr_control_productos_permitidos(ve_instancia in int,
                                                  ln_rpta      out varchar2,
                                                  PO_CodError  out varchar,
                                                  PO_MsgError  out varchar);  
  procedure sp_cr_valid_plazo_maximo(ve_instancia in int,
                                   ln_rpta      out varchar2,
                                   PO_CodError  out varchar,
                                   PO_MsgError  out varchar);                                                                                                 
end pq_cr_calificac_reprg_desas_natural;
/

CREATE OR REPLACE PACKAGE BODY PQ_CR_CALIFICAC_REPRG_DESAS_NATURAL IS

  /* ************************************************************************************************************
     -- Nombre                     : pq_cr_calificac_reprg_desas_natural
     -- Sistema                    : BANTOTAL
     -- Módulo                     : ACTIVAS
     -- Descripción                : Validar calificación para reprog. desastre natural sin capitalización
     -- Versión                    : 1.0
     -- Fecha de Creación          : 4/07/2024 11:20:53
     -- Autor de Creación          : IGS_RCASTRO
     -- Estado                     : Activo
     -- Acceso                     : Público
     -- Fecha de Modificación      : 15/08/2024
     -- Autor de la Modificación   : Rcastro - Mcordova
     -- Descripción de Modificación: Se agrega controles de periodo de gracia y plazo máximo
  * *************************************************************************************************************/

  PROCEDURE SP_CR_CALIFIC_RCC(INSTANCIA IN NUMBER, OUTRPSTA OUT VARCHAR2) IS
    V_FECHA   DATE;
    V_TDOC_ID VARCHAR2(1);
  
    V_PEPAIS   NUMBER;
    V_PETDOC   NUMBER;
    P_NDOC     VARCHAR2(12);
    V_PETIPO   VARCHAR2(1);
    V_C_CODSBS VARCHAR2(10);
    V_TP1NRO2  NUMBER(9);
    v_fecTpnro NUMBER(10);
    V_DateFec  VARCHAR2(10);
    V_Count    NUMBER(1);
  BEGIN
    OUTRPSTA := 'S';
  
    BEGIN
      SELECT TPNRO
        INTO v_fecTpnro
        FROM FST098
       WHERE PGCOD = 1
         AND TPCOD = 7647
         AND TPCORR = 12;
    EXCEPTION
      WHEN OTHERS THEN
        v_fecTpnro := NULL;
    END;
    V_DateFec := TRIM(TO_CHAR(v_fecTpnro));
    V_FECHA   := TO_DATE(V_DateFec, 'DD/MM/RRRR');
  
    BEGIN
      SELECT D.SNG001PAIS, D.SNG001TDOC, D.SNG001NDOC
        INTO V_PEPAIS, V_PETDOC, P_NDOC
        FROM SNG001 D
       WHERE D.SNG001INST = INSTANCIA;
    EXCEPTION
      WHEN OTHERS THEN
        P_NDOC := '';
    END;
    P_NDOC := TRIM(P_NDOC); -- RPAD(P_NDOC, 12, ' '); --trim(P_NDOC);
  
    BEGIN
      SELECT PETIPO
        INTO V_PETIPO
        FROM FSD001
       WHERE PEPAIS = V_PEPAIS
         AND PETDOC = V_PETDOC
         AND PENDOC = RPAD(P_NDOC, 12, ' ')
         AND ROWNUM = 1;
    EXCEPTION
      WHEN OTHERS THEN
        V_PETIPO := '';
    END;
  
    BEGIN
      SELECT TP1NRO2
        INTO V_TP1NRO2
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11111
         AND TP1CORR1 = 1
         AND TP1CORR2 = 5
         AND TP1CORR3 > 0
         AND TP1NRO1 = V_PETDOC;
    EXCEPTION
      WHEN OTHERS THEN
        V_TDOC_ID := NULL;
    END;
  
    V_TDOC_ID := TRIM(TO_CHAR(V_TP1NRO2));
  
    V_C_CODSBS := null;
    IF V_PETIPO = 'F' THEN
      BEGIN
        SELECT C_CODSBS
          INTO V_C_CODSBS
          FROM CLDRCCI
         WHERE D_FECPRE = V_FECHA
           AND C_TDOCID = V_TDOC_ID
           AND C_DOCIDE = P_NDOC
           AND ROWNUM = 1;
      EXCEPTION
        WHEN OTHERS THEN
          V_C_CODSBS := null;
      END;
    ELSE
      IF V_PETIPO = 'J' THEN
        BEGIN
          SELECT C_CODSBS
            INTO V_C_CODSBS
            FROM CLDRCCI
           WHERE D_FECPRE = V_FECHA
             AND C_TDOCTR = V_TDOC_ID
             AND C_DOCTRI = P_NDOC
             AND ROWNUM = 1;
        EXCEPTION
          WHEN OTHERS THEN
            V_C_CODSBS := '';
        END;
      END IF;
    END IF;
  
    IF V_C_CODSBS IS NOT NULL THEN
      V_C_CODSBS := trim(V_C_CODSBS);
          
      V_Count    := 0;
      BEGIN      
        SELECT COUNT(1)
          INTO V_Count
          FROM CLDRCCS
         WHERE D_FECPRE = V_FECHA 
           AND C_CODSBS = V_C_CODSBS
           AND C_CODEMP = '00104'
           AND C_CALVIG NOT IN (0, 1) --SE VALIDA QUE SEA 0 - NORMAL Y 1 - CPP
           AND ROWNUM = 1;
      EXCEPTION
        WHEN OTHERS THEN
          V_Count := 0;
      END;
      V_Count := NVL(V_Count, 0);
    
      IF V_Count = 0 THEN      
        OUTRPSTA := 'S';
      ELSE
        OUTRPSTA := 'N';
      END IF;
    END IF;  
  END;
  
  
  procedure sp_cr_control_periodio_gracia_sin_CRM(ve_instancia in int,
                                                  ln_rpta      out varchar2,
                                                  PO_CodError  out varchar,
                                                  PO_MsgError  out varchar) is
    vi_pgcod        xwf700.xwfempresa%type;
    vi_aomod        xwf700.xwfmodulo%type;
    vi_aosuc        xwf700.xwfsucursal%type;
    vi_aomda        xwf700.xwfmoneda%type;
    vi_aopap        xwf700.xwfpapel%type;
    vi_aocta        xwf700.xwfcuenta%type;
    vi_aooper       xwf700.xwfoperacion%type;
    vi_aosbop       xwf700.xwfsubope%type;
    vi_aotope       xwf700.xwftipope%type;
    vi_fprpago      date;
    vi_fecactual    DATE;
    vi_periodi_guia number(9);
    vo_gracia       NUMBER(4,2);
    vo_monto        number(17,2);
  begin
    PO_CodError := '00000';  
    PO_MsgError := '';
    BEGIN
      select xwfempresa,
             xwfmodulo,
             xwfsucursal,
             xwfmoneda,
             xwfpapel,
             xwfcuenta,
             xwfoperacion,
             xwfsubope,
             xwftipope
        into vi_pgcod,
             vi_aomod,
             vi_aosuc,
             vi_aomda,
             vi_aopap,
             vi_aocta,
             vi_aooper,
             vi_aosbop,
             vi_aotope
        from xwf700
       where xwfprcins = ve_instancia
         and xwfcar3 = '1';
    exception
      when others then
        PO_CodError := '00100';
        PO_MsgError := 'Error al buscar en XWF700';
    END;
    BEGIN
      select x.XLLFPRIMPA, x.xllcapital
        into vi_fprpago, vo_monto
        from x054023 x
       where x.xllpgcod = vi_pgcod
         and x.xllaomod = vi_aomod
         and x.xllaosuc = vi_aosuc
         and x.xllaomda = vi_aomda
         and x.xllaopap = vi_aopap
         and x.xllaocta = vi_aocta
         and x.xllaooper = vi_aooper
         and x.xllaosbop = 609
         and x.xllaotop = vi_aotope;
    Exception
      when others then
        PO_CodError := '00101';
        PO_MsgError := 'Error al buscar en x054023';
        vo_monto := 0;
    END;
  
    BEGIN
      SELECT pgfape INTO vi_fecactual FROM FST017 WHERE PGCOD = 1;
    exception
      when others then
        null;      
    END;
  
    begin
      SELECT vi_fprpago - vi_fecactual into vo_gracia FROM DUAL;
    exception
      when others then
        null;      
    end;
  
    vo_gracia := nvl(vo_gracia, 0);
  
    --GUIA DE PERIODO DE GRACIA
    BEGIN
      select TP1NRO3
        into vi_periodi_guia
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11152
         and tp1corr1 = 110
         and --  for update 
             tp1corr2 = 3
         and tp1corr3 = 1;
    EXCEPTION
      WHEN OTHERS THEN
        vi_periodi_guia := 0;
    END;
    vi_periodi_guia := nvl(vi_periodi_guia, 0);    
    
    ln_rpta := 'S'; 
    --IF ln_habilitado > 0 THEN
    IF vo_gracia > vi_periodi_guia THEN
      ln_rpta := 'N';
    ELSE
      ln_rpta := 'S';
    END IF;
    --END IF;
  
  End;  

 procedure sp_cr_control_productos_permitidos(ve_instancia in int,
                                                  ln_rpta      out varchar2,
                                                  PO_CodError  out varchar,
                                                  PO_MsgError  out varchar) is
cursor GUIA is 
select * from fst198 where tp1cod1 = 11153 and tp1corr1 = 25;                                                 
begin
  ln_rpta := 'N';
  FOR I IN GUIA LOOP
    BEGIN
      IF ln_rpta = 'N' THEN
        BEGIN
          select 'S' INTO ln_rpta from xwf700 
          where xwfprcins = ve_instancia and xwfmodulo = I.TP1NRO1 and xwftipope = I.TP1NRO2 and XWFCAR3 = '1';   
        EXCEPTION 
          WHEN NO_DATA_FOUND THEN
          ln_rpta:= 'N';
          PO_CodError := '0';
          PO_MsgError := '0';
        END;
      END IF;
    END;
  END LOOP;
end; 

procedure sp_cr_valid_plazo_maximo(ve_instancia in int,
                                   ln_rpta      out varchar2,
                                   PO_CodError  out varchar,
                                   PO_MsgError  out varchar) is
vi_pgcod        xwf700.xwfempresa%type;
vi_aomod        xwf700.xwfmodulo%type;
vi_aosuc        xwf700.xwfsucursal%type;
vi_aomda        xwf700.xwfmoneda%type;
vi_aopap        xwf700.xwfpapel%type;
vi_aocta        xwf700.xwfcuenta%type;
vi_aooper       xwf700.xwfoperacion%type;
vi_aosbop       xwf700.xwfsubope%type;
vi_aotope       xwf700.xwftipope%type;  
v_Plzo601       number(6);           
V_AQPA822PLZMAX number(6);                    
begin
    PO_CodError := '00000';  
    PO_MsgError := '';
    BEGIN
      select xwfempresa,
             xwfmodulo,
             xwfsucursal,
             xwfmoneda,
             xwfpapel,
             xwfcuenta,
             xwfoperacion,
             xwfsubope,
             xwftipope
        into vi_pgcod,
             vi_aomod,
             vi_aosuc,
             vi_aomda,
             vi_aopap,
             vi_aocta,
             vi_aooper,
             vi_aosbop,
             vi_aotope
        from xwf700
       where xwfprcins = ve_instancia
         and xwfcar3 = '1';
    exception
      when others then
        PO_CodError := '00100';
        PO_MsgError := 'Error al buscar en XWF700';
    END;
    
    v_Plzo601 := 0; 
    BEGIN
      select 
       sum(p.PPPZO)
        into v_Plzo601
        from fsd601 p
       where p.pgcod = vi_pgcod
         and p.ppmod = vi_aomod
         and p.ppsuc = vi_aosuc
         and p.ppmda = vi_aomda
         and p.pppap = vi_aopap             
         and p.ppcta = vi_aocta
         and p.ppoper = vi_aooper
         and p.ppsbop = 609--pn_sbop
         and p.pptope = vi_aotope;         
         --and p.d601co = 'S';
   exception
      when others then 
        v_Plzo601 := 0;        
    END;
    
    v_Plzo601 := nvl(v_Plzo601, 0);
    
    V_AQPA822PLZMAX := 0;
    BEGIN
      select AQPA822PLZMAX INTO V_AQPA822PLZMAX FROM AQPA822 WHERE 
      AQPA822EMP = vi_pgcod AND
      AQPA822MOD = vi_aomod AND
      AQPA822TOP = vi_aotope AND
      AQPA822MDA = vi_aomda AND
      AQPA822EST = 'A';
    exception
      when others then
        V_AQPA822PLZMAX := 0;
    END;
    V_AQPA822PLZMAX := nvl(V_AQPA822PLZMAX, 0);
    
    IF v_Plzo601 < V_AQPA822PLZMAX THEN
       ln_rpta := 'S';
    ELSE 
       ln_rpta := 'N';
    END IF;    
end;                                                                                  
                                               
END PQ_CR_CALIFICAC_REPRG_DESAS_NATURAL;
/

