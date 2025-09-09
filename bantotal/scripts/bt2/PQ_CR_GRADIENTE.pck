CREATE OR REPLACE PACKAGE PQ_CR_GRADIENTE IS

  -- ====================================================================================================
  -- NOMBRE                      : PQ_CR_GRADIENTE
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 02/08/2025
  -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
  -- ESTADO                      : ACTIVO
  -- ACCESO                      : PUBLICO
  -- ====================================================================================================
  -- FECHA DE MODIFICACION       : 
  -- AUTOR DE LA MODIFICACION    : 
  -- DESCRIPCION DE MODIFICACION : 
  -- ====================================================================================================

  PROCEDURE SP_CR_GRDNT_CRONOGR1(PI_INSTANCIA IN NUMBER,
                                 PO_RESULTADO OUT VARCHAR2);

  PROCEDURE SP_CR_GRDNT_CRONOGR2(PI_INSTANCIA IN NUMBER,
                                 PI_USUARIO   IN VARCHAR2,
                                 PO_RESULTADO OUT VARCHAR2,
                                 PO_COD_ERROR OUT VARCHAR2,
                                 PO_MSG_ERROR OUT VARCHAR2);

  procedure sp_cr_control_periodio_gracia_sin_CRM(ve_instancia in NUMBER,
                                                  ve_usuario   in varchar2,
                                                  ln_rpta      out varchar2,
                                                  PO_CodError  out varchar2,
                                                  PO_MsgError  out varchar2);
END PQ_CR_GRADIENTE;
/
CREATE OR REPLACE PACKAGE BODY PQ_CR_GRADIENTE IS

  PROCEDURE SP_CR_GRDNT_CRONOGR1(PI_INSTANCIA IN NUMBER,
                                 PO_RESULTADO OUT VARCHAR2) IS
  
    -- ====================================================================================================
    -- NOMBRE                      : SP_CR_GRDNT_CRONOGR1
    -- SISTEMA                     : BANTOTAL
    -- MODULO                      : CREDITOS - ACTIVAS
    -- VERSION                     : 1.0
    -- FECHA DE CREACION           : 02/08/2025
    -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
    -- USO                         : RETORNA EL PORCENTAJE DE CUOTAS GRADIENTES
    -- PARAMETROS                  : - PI_INSTANCIA | NUMBER(10)
    --                               - PO_RESULTADO | VARCHAR2(30)
    -- ESTADO                      : ACTIVO
    -- ACCESO                      : PUBLICO
    -- ====================================================================================================
    -- FECHA DE MODIFICACION       : 
    -- AUTOR DE LA MODIFICACION    : 
    -- DESCRIPCION DE MODIFICACION : 
    -- ====================================================================================================
  
    V_EMPRESA     NUMBER(3) := 0;
    V_SUCURSAL    NUMBER(3) := 0;
    V_MODULO      NUMBER(3) := 0;
    V_MONEDA      NUMBER(4) := 0;
    V_PAPEL       NUMBER(4) := 0;
    V_CUENTA      NUMBER(9) := 0;
    V_OPERACION   NUMBER(9) := 0;
    V_SBOPERACION NUMBER(3) := 0;
    V_TOPERACION  NUMBER(3) := 0;
    V_MONTO_MAX   NUMBER(17, 2) := 0;
    V_PORCENTAJE  NUMBER(10, 2) := 0;
    V_VARIACION   NUMBER(17, 2) := 0;
  
  BEGIN
    BEGIN
      SELECT A.TPIMP
        INTO V_VARIACION
        FROM FST098 A
       WHERE A.PGCOD = 1
         AND A.TPCOD = 7753
         AND A.TPCORR = 20
         AND A.TPNRO = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      SELECT A.XWFEMPRESA,
             A.XWFSUCURSAL,
             A.XWFMODULO,
             A.XWFMONEDA,
             A.XWFPAPEL,
             A.XWFCUENTA,
             A.XWFOPERACION,
             A.XWFSUBOPE,
             A.XWFTIPOPE
        INTO V_EMPRESA,
             V_SUCURSAL,
             V_MODULO,
             V_MONEDA,
             V_PAPEL,
             V_CUENTA,
             V_OPERACION,
             V_SBOPERACION,
             V_TOPERACION
        FROM XWF700 A
       WHERE A.XWFPRCINS = PI_INSTANCIA
         AND A.XWFCAR3 = '1';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      SELECT MAX(A.PPCAP + NVL(A.PPINT, 0) +
                 NVL((SELECT NVL(T1.PPIMP11, 0) + NVL(T1.PPIMP12, 0) +
                            NVL(T1.PPIMP13, 0) + NVL(T1.PPIMP14, 0) +
                            NVL(T1.PPIMP15, 0) + NVL(T1.PPIMP16, 0) +
                            NVL(T1.PPIMP17, 0) + NVL(T1.PPIMP18, 0) +
                            NVL(T1.PPIMP19, 0) + NVL(T1.PPIMP20, 0)
                       FROM FSD611 T1
                      WHERE T1.PGCOD = A.PGCOD
                        AND T1.PPMOD = A.PPMOD
                        AND T1.PPSUC = A.PPSUC
                        AND T1.PPMDA = A.PPMDA
                        AND T1.PPPAP = A.PPPAP
                        AND T1.PPCTA = A.PPCTA
                        AND T1.PPOPER = A.PPOPER
                        AND T1.PPSBOP = A.PPSBOP
                        AND T1.PPTOPE = A.PPTOPE
                        AND T1.PPFPAG = A.PPFPAG),
                     0))
        INTO V_MONTO_MAX
        FROM FSD601 A
       WHERE A.PGCOD = V_EMPRESA
         AND A.PPMOD = V_MODULO
         AND A.PPSUC = V_SUCURSAL
         AND A.PPMDA = V_MONEDA
         AND A.PPPAP = V_PAPEL
         AND A.PPCTA = V_CUENTA
         AND A.PPOPER = V_OPERACION
         AND A.PPSBOP = V_SBOPERACION
         AND A.PPTOPE = V_TOPERACION
         AND A.PPTIPO = 'M';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      SELECT ROUND((COUNT(CASE
                            WHEN A.PPCAP + NVL(A.PPINT, 0) + V_VARIACION +
                                 NVL(T1.PPIMP11, 0) + NVL(T1.PPIMP12, 0) +
                                 NVL(T1.PPIMP13, 0) + NVL(T1.PPIMP14, 0) +
                                 NVL(T1.PPIMP15, 0) + NVL(T1.PPIMP16, 0) +
                                 NVL(T1.PPIMP17, 0) + NVL(T1.PPIMP18, 0) +
                                 NVL(T1.PPIMP19, 0) + NVL(T1.PPIMP20, 0) < V_MONTO_MAX THEN
                             1
                          END) / COUNT(1)) * 100,
                   2)
        INTO V_PORCENTAJE
        FROM FSD601 A
        LEFT JOIN FSD611 T1
          ON T1.PGCOD = A.PGCOD
         AND T1.PPMOD = A.PPMOD
         AND T1.PPSUC = A.PPSUC
         AND T1.PPMDA = A.PPMDA
         AND T1.PPPAP = A.PPPAP
         AND T1.PPCTA = A.PPCTA
         AND T1.PPOPER = A.PPOPER
         AND T1.PPSBOP = A.PPSBOP
         AND T1.PPTOPE = A.PPTOPE
         AND T1.PPFPAG = A.PPFPAG
       WHERE A.PGCOD = V_EMPRESA
         AND A.PPMOD = V_MODULO
         AND A.PPSUC = V_SUCURSAL
         AND A.PPMDA = V_MONEDA
         AND A.PPPAP = V_PAPEL
         AND A.PPCTA = V_CUENTA
         AND A.PPOPER = V_OPERACION
         AND A.PPSBOP = V_SBOPERACION
         AND A.PPTOPE = V_TOPERACION
         AND A.PPTIPO = 'M'
       ORDER BY A.PPFPAG ASC;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    PO_RESULTADO := TO_CHAR(V_PORCENTAJE);
  
  END SP_CR_GRDNT_CRONOGR1;

  PROCEDURE SP_CR_GRDNT_CRONOGR2(PI_INSTANCIA IN NUMBER,
                                 PI_USUARIO   IN VARCHAR2,
                                 PO_RESULTADO OUT VARCHAR2,
                                 PO_COD_ERROR OUT VARCHAR2,
                                 PO_MSG_ERROR OUT VARCHAR2) IS
  
    -- ====================================================================================================
    -- NOMBRE                      : SP_CR_GRDNT_CRONOGR2
    -- SISTEMA                     : BANTOTAL
    -- MODULO                      : CREDITOS - ACTIVAS
    -- VERSION                     : 1.0
    -- FECHA DE CREACION           : 02/08/2025
    -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
    -- USO                         : RETORNA 'S' O 'N' SI LA GRADIENTE SUPERA EL 25% DEL CRONOGRAMA
    -- PARAMETROS                  : - PI_INSTANCIA | NUMBER(10)
    --                               - PI_USUARIO   | VARCHAR2(10)
    --                               - PO_RESULTADO | VARCHAR2(1)
    --                               - PO_COD_ERROR | VARCHAR2(5)
    --                               - PO_MSG_ERROR | VARCHAR2(255)
    -- ESTADO                      : ACTIVO
    -- ACCESO                      : PUBLICO
    -- ====================================================================================================
    -- FECHA DE MODIFICACION       : 
    -- AUTOR DE LA MODIFICACION    : 
    -- DESCRIPCION DE MODIFICACION : 
    -- ====================================================================================================
  
    V_EMPRESA    NUMBER(3) := 0;
    V_SUCURSAL   NUMBER(3) := 0;
    V_MODULO     NUMBER(3) := 0;
    V_MONEDA     NUMBER(4) := 0;
    V_PAPEL      NUMBER(4) := 0;
    V_CUENTA     NUMBER(9) := 0;
    V_OPERACION  NUMBER(9) := 0;
    V_TOPERACION NUMBER(3) := 0;
    V_MONTO_MAX  NUMBER(17, 2) := 0;
    V_VARIACION  NUMBER(17, 2) := 0;
    V_PORCENTAJE NUMBER(10, 2) := 0;
  
  BEGIN
    BEGIN
      SELECT A.TPIMP
        INTO V_VARIACION
        FROM FST098 A
       WHERE A.PGCOD = 1
         AND A.TPCOD = 7753
         AND A.TPCORR = 20
         AND A.TPNRO = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      SELECT A.XWFEMPRESA,
             A.XWFSUCURSAL,
             A.XWFMODULO,
             A.XWFMONEDA,
             A.XWFPAPEL,
             A.XWFCUENTA,
             A.XWFOPERACION,
             A.XWFTIPOPE
        INTO V_EMPRESA,
             V_SUCURSAL,
             V_MODULO,
             V_MONEDA,
             V_PAPEL,
             V_CUENTA,
             V_OPERACION,
             V_TOPERACION
        FROM XWF700 A
       WHERE A.XWFPRCINS = PI_INSTANCIA
         AND A.XWFCAR3 = '1';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      SELECT MAX(A.PPCAP + NVL(A.PPINT, 0) +
                 NVL((SELECT NVL(T1.PPIMP11, 0) + NVL(T1.PPIMP12, 0) +
                            NVL(T1.PPIMP13, 0) + NVL(T1.PPIMP14, 0) +
                            NVL(T1.PPIMP15, 0) + NVL(T1.PPIMP16, 0) +
                            NVL(T1.PPIMP17, 0) + NVL(T1.PPIMP18, 0) +
                            NVL(T1.PPIMP19, 0) + NVL(T1.PPIMP20, 0)
                       FROM FSD611 T1
                      WHERE T1.PGCOD = A.PGCOD
                        AND T1.PPMOD = A.PPMOD
                        AND T1.PPSUC = A.PPSUC
                        AND T1.PPMDA = A.PPMDA
                        AND T1.PPPAP = A.PPPAP
                        AND T1.PPCTA = A.PPCTA
                        AND T1.PPOPER = A.PPOPER
                        AND T1.PPSBOP = A.PPSBOP
                        AND T1.PPTOPE = A.PPTOPE
                        AND T1.PPFPAG = A.PPFPAG),
                     0))
        INTO V_MONTO_MAX
        FROM FSD601 A
       WHERE A.PGCOD = V_EMPRESA
         AND A.PPMOD = V_MODULO
         AND A.PPSUC = V_SUCURSAL
         AND A.PPMDA = V_MONEDA
         AND A.PPPAP = V_PAPEL
         AND A.PPCTA = V_CUENTA
         AND A.PPOPER = V_OPERACION
         AND A.PPSBOP = 609
         AND A.PPTOPE = V_TOPERACION
         AND A.PPTIPO = 'M';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      SELECT ROUND((COUNT(CASE
                            WHEN A.PPCAP + NVL(A.PPINT, 0) + V_VARIACION +
                                 NVL(T1.PPIMP11, 0) + NVL(T1.PPIMP12, 0) +
                                 NVL(T1.PPIMP13, 0) + NVL(T1.PPIMP14, 0) +
                                 NVL(T1.PPIMP15, 0) + NVL(T1.PPIMP16, 0) +
                                 NVL(T1.PPIMP17, 0) + NVL(T1.PPIMP18, 0) +
                                 NVL(T1.PPIMP19, 0) + NVL(T1.PPIMP20, 0) < V_MONTO_MAX THEN
                             1
                          END) / COUNT(1)) * 100,
                   2)
        INTO V_PORCENTAJE
        FROM FSD601 A
        LEFT JOIN FSD611 T1
          ON T1.PGCOD = A.PGCOD
         AND T1.PPMOD = A.PPMOD
         AND T1.PPSUC = A.PPSUC
         AND T1.PPMDA = A.PPMDA
         AND T1.PPPAP = A.PPPAP
         AND T1.PPCTA = A.PPCTA
         AND T1.PPOPER = A.PPOPER
         AND T1.PPSBOP = A.PPSBOP
         AND T1.PPTOPE = A.PPTOPE
         AND T1.PPFPAG = A.PPFPAG
       WHERE A.PGCOD = V_EMPRESA
         AND A.PPMOD = V_MODULO
         AND A.PPSUC = V_SUCURSAL
         AND A.PPMDA = V_MONEDA
         AND A.PPPAP = V_PAPEL
         AND A.PPCTA = V_CUENTA
         AND A.PPOPER = V_OPERACION
         AND A.PPSBOP = 609
         AND A.PPTOPE = V_TOPERACION
         AND A.PPTIPO = 'M'
       ORDER BY A.PPFPAG ASC;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    IF V_PORCENTAJE > 25 THEN
      PO_RESULTADO := 'S';
    ELSE
      PO_RESULTADO := 'N';
    END IF;
  
  END SP_CR_GRDNT_CRONOGR2;
  -- ====================================================================================================
  -- NOMBRE                      : SP_CR_GRDNT_CRONOGR2
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 02/08/2025
  -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
  -- USO                         : RETORNA 'S' O 'N' 
  -- PARAMETROS                  : - ve_instancia | NUMBER(10)
  --                               - ve_usuario   | VARCHAR2(10)
  --                               - ln_rpta      | VARCHAR2(1)
  --                               - PO_CodError | VARCHAR2(5)
  --                               - PO_MsgError | VARCHAR2(255)
  -- ESTADO                      : ACTIVO
  -- ACCESO                      : PUBLICO
  -- ====================================================================================================
  -- FECHA DE MODIFICACION       : 
  -- AUTOR DE LA MODIFICACION    : 
  -- DESCRIPCION DE MODIFICACION : 
  -- ====================================================================================================
  procedure sp_cr_control_periodio_gracia_sin_CRM(ve_instancia in number,
                                                  ve_usuario   in varchar2,
                                                  ln_rpta      out varchar2,
                                                  PO_CodError  out varchar2,
                                                  PO_MsgError  out varchar2) is
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
    vi_periodi_guia number(10);
    vo_gracia       NUMBER(10);
    vo_monto        number(18,2);
  begin
    PO_CodError := '0000';
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
        PO_CodError := '0100';
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
        PO_CodError := '0101';
        PO_MsgError := 'Error al buscar en x054023';
        vo_monto    := 0;
    END;
  
    BEGIN
      SELECT pgfape INTO vi_fecactual FROM FST017 WHERE PGCOD = 1;
    exception
      when others then
        null;
    END;
  
    /*begin
      SELECT (vi_fprpago - vi_fecactual) into vo_gracia FROM DUAL;
    exception
      when others then
        null;      
    end;*/
    vo_gracia := vi_fprpago - vi_fecactual;
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
  
    ln_rpta := 'N';
    IF vo_gracia > vi_periodi_guia THEN
      ln_rpta := 'S';
    ELSE
      ln_rpta := 'N';
    END IF;
  End;

END PQ_CR_GRADIENTE;
/
