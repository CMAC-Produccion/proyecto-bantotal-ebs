CREATE OR REPLACE PACKAGE PQ_CR_DATOS_SEGMENTACION IS

  -----------------------------------------------------------------------------------------
  -- NOMBRE                      : PQ_CR_DATOS_SEGMENTACION
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 16/10/2024
  -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
  -- ESTADO                      : ACTIVO
  -- ACCESO                      : PUBLICO
  -----------------------------------------------------------------------------------------
  -- FECHA DE MODIFICACION       : 26/05/2025
  -- AUTOR DE LA MODIFICACION    : MAYCOL CHAVEZ CHUMAN
  -- DESCRIPCION DE MODIFICACION : SE AGREGARON LOS PROCEDIMIENTOS: 
  --                               - SP_CR_ENVIAR_EMAIL
  --                               - SP_CR_OBTENER_MONTO_MAX
  --                               SE MODIFICO EL PROCEDIMIENTO:
  --                               - SP_CR_GRABAR_LOG_SEGMENTACION
  -----------------------------------------------------------------------------------------

  -----------------------------------------------------------------------------------------
  PROCEDURE SP_CR_VALIDAR_ETAPA_CREDITO(P_INSTANCIA    IN NUMBER,
                                        P_ITEM_ETAPA   OUT NUMBER,
                                        P_CODIGO_ETAPA OUT NUMBER,
                                        P_NOMBRE_ETAPA OUT VARCHAR2);

  -----------------------------------------------------------------------------------------                                   
  PROCEDURE SP_CR_VALIDAR_SALDO_SBS(P_INSTANCIA        IN NUMBER,
                                    P_INCREMENTO_SALDO OUT VARCHAR2);

  -----------------------------------------------------------------------------------------
  PROCEDURE SP_CR_OBTENER_CALIFICACION(P_INSTANCIA        IN NUMBER,
                                       P_FECHA_RCC        OUT DATE,
                                       P_CALIF_NORMAL     OUT NUMBER,
                                       P_CALIF_CPP        OUT NUMBER,
                                       P_CALIF_DEFICIENTE OUT NUMBER,
                                       P_CALIF_DUDOSO     OUT NUMBER,
                                       P_CALIF_PERDIDA    OUT NUMBER);

  -----------------------------------------------------------------------------------------                                  
  PROCEDURE SP_CR_VALIDAR_IMPORTE_EXCEPTION(P_INSTANCIA     IN NUMBER,
                                            P_IMPORTE       OUT NUMBER,
                                            P_EXCEPCION     OUT VARCHAR2,
                                            P_CODIGO_ERROR  OUT VARCHAR2,
                                            P_MENSAJE_ERROR OUT VARCHAR2);

  -----------------------------------------------------------------------------------------
  PROCEDURE SP_CR_GRABAR_LOG_SEGMENTACION(P_USUARIO_REGISTRO  IN VARCHAR2,
                                          P_INSTANCIA         IN VARCHAR2,
                                          P_EMPRESA           IN VARCHAR2,
                                          P_MODULO            IN NUMBER,
                                          P_SUCURSAL          IN NUMBER,
                                          P_MONEDA            IN NUMBER,
                                          P_PAPEL             IN NUMBER,
                                          P_CUENTA            IN NUMBER,
                                          P_OPERACION         IN NUMBER,
                                          P_SUBOPERACION      IN NUMBER,
                                          P_TIPO_OPERACION    IN NUMBER,
                                          P_ITEM_ETAPA        IN NUMBER,
                                          P_CODIGO_ETAPA      IN NUMBER,
                                          P_NOMBRE_ETAPA      IN VARCHAR2,
                                          P_TIPO_SEGMENTO     IN NUMBER,
                                          P_COD_SEGM_ANTERIOR IN NUMBER,
                                          P_NOM_SEGM_ANTERIOR IN VARCHAR2,
                                          P_COD_SEGM_ACTUAL   IN NUMBER,
                                          P_NOM_SEGM_ACTUAL   IN VARCHAR2,
                                          P_MONTO_PROPUESTO   IN NUMBER,
                                          P_MONTO_APROBADO    IN NUMBER,
                                          P_TOPE_SEGMENTO     IN NUMBER,
                                          P_TOPE_MAXIMO_SEG   IN NUMBER,
                                          P_PORCENTAJE_SEG    IN NUMBER,
                                          P_PROMEDIO_DIAS     IN NUMBER,
                                          P_FECHA_RCC         IN DATE,
                                          P_CALIF_NORMAL      IN NUMBER,
                                          P_CALIF_CPP         IN NUMBER,
                                          P_CALIF_DEFICIENTE  IN NUMBER,
                                          P_CALIF_DUDOSO      IN NUMBER,
                                          P_CALIF_PERDIDA     IN NUMBER,
                                          P_ESTADO            IN VARCHAR2,
                                          P_COMENTARIO        IN VARCHAR2,
                                          P_CODERROR          OUT VARCHAR2,
                                          P_MSGERROR          OUT VARCHAR2);

  ----------------------------------------------------------------------------------------------------
  PROCEDURE SP_CR_ENVIAR_EMAIL(P_INSTANCIA IN NUMBER,
                               P_TIPOMSG   IN VARCHAR2);

  /*===================================================================================================*/
  PROCEDURE SP_CR_OBTENER_MONTO_MAX(P_INSTANCIA IN NUMBER,
                                    P_MONTO_MAX OUT NUMBER);

  /*===================================================================================================*/
  PROCEDURE SP_CR_OBTENER_TIPO_SOLI(P_INSTANCIA IN NUMBER,
                                    P_TIPO_SOLI OUT VARCHAR2);

END PQ_CR_DATOS_SEGMENTACION;
/
CREATE OR REPLACE PACKAGE BODY PQ_CR_DATOS_SEGMENTACION IS

  PROCEDURE SP_CR_VALIDAR_ETAPA_CREDITO(P_INSTANCIA    IN NUMBER,
                                        P_ITEM_ETAPA   OUT NUMBER,
                                        P_CODIGO_ETAPA OUT NUMBER,
                                        P_NOMBRE_ETAPA OUT VARCHAR2) IS
  
    -- *****************************************************************
    -- NOMBRE                      : SP_CR_VALIDAR_ETAPA_CREDITO
    -- SISTEMA                     : BANTOTAL
    -- MODULO                      : CREDITOS - ACTIVAS
    -- VERSION                     : 1.0
    -- FECHA DE CREACION           : 16/10/2024
    -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
    -- PARAMETROS                  : - P_INSTANCIA   : NUMBER(10)
    --                               - P_ITEM_ETAPA  : NUMBER(10)
    --                               - P_CODIGO_ETAPA: NUMBER(4)
    --                               - P_NOMBRE_ETAPA: VARCHAR2(50)
    -- USO                         : VALIDA LA ETAPA EN LA QUE SE ENCUENTRA
    --                               EL CREDITO
    -- ESTADO                      : ACTIVO
    -- ACCESO                      : PUBLICO
    --------------------------------------------------------------------
    -- FECHA DE MODIFICACION       : 
    -- AUTOR DE LA MODIFICACION    : 
    -- DESCRIPCION DE MODIFICACION : 
    --
    -- *****************************************************************
  
    ITEM_ETAPA   NUMBER(10);
    CODIGO_ETAPA NUMBER(4);
    NOMBRE_ETAPA VARCHAR2(50);
  BEGIN
    ITEM_ETAPA   := 0;
    CODIGO_ETAPA := 0;
    BEGIN
      SELECT A1.WFITEMID, A1.WFTASKCOD, TRIM(B1.WFTASKNAME)
        INTO ITEM_ETAPA, CODIGO_ETAPA, NOMBRE_ETAPA
        FROM WFWRKITEMS A1, WFTASK B1
       WHERE A1.WFINSPRCID = P_INSTANCIA
         AND A1.WFITEMSTSACT = 1
         AND A1.WFITEMID = (SELECT MAX(A2.WFITEMID)
                              FROM WFWRKITEMS A2
                             WHERE A2.WFINSPRCID = A1.WFINSPRCID
                               AND A2.WFITEMSTSACT = 1)
         AND A1.WFTASKCOD < (SELECT A3.TPIMP
                               FROM FST098 A3
                              WHERE A3.PGCOD = 1
                                AND A3.TPCOD = 7753
                                AND A3.TPCORR = 13
                                AND A3.TPNRO = 1)
         AND B1.WFPRCID = 2
         AND B1.WFTASKCOD = A1.WFTASKCOD;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    P_ITEM_ETAPA   := ITEM_ETAPA;
    P_CODIGO_ETAPA := CODIGO_ETAPA;
    P_NOMBRE_ETAPA := NOMBRE_ETAPA;
  
  END SP_CR_VALIDAR_ETAPA_CREDITO;

  /*==================================================================================================================*/
  PROCEDURE SP_CR_VALIDAR_SALDO_SBS(P_INSTANCIA        IN NUMBER,
                                    P_INCREMENTO_SALDO OUT VARCHAR2) IS
  
    -- *****************************************************************
    -- NOMBRE                      : SP_CR_VALIDAR_SALDO_SBS
    -- SISTEMA                     : BANTOTAL
    -- MODULO                      : CREDITOS - ACTIVAS
    -- VERSION                     : 1.0
    -- FECHA DE CREACION           : 16/10/2024
    -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
    -- PARAMETROS                  : - P_INSTANCIA        : NUMBER(10)
    --                               - P_INCREMENTO_SALDO : VARCHAR2(2)
    -- USO                         : VALIDA SI TIENE UN INCREMENTO DE SALDO
    -- ESTADO                      : ACTIVO
    -- ACCESO                      : PUBLICO
    --------------------------------------------------------------------
    -- FECHA DE MODIFICACION       : 
    -- AUTOR DE LA MODIFICACION    : 
    -- DESCRIPCION DE MODIFICACION : 
    --
    -- *****************************************************************
  
    PAIS_DOCUMENTO   NUMBER(3);
    TIPO_DOCUMENTO   NUMBER(2);
    NRO_DOCUMENTO    VARCHAR2(12);
    INCREMENTO_SALDO VARCHAR2(1);
  BEGIN
    PAIS_DOCUMENTO := 0;
    TIPO_DOCUMENTO := 0;
    NRO_DOCUMENTO  := NULL;
    BEGIN
      SELECT A1.SNG001PAIS, A1.SNG001TDOC, A1.SNG001NDOC
        INTO PAIS_DOCUMENTO, TIPO_DOCUMENTO, NRO_DOCUMENTO
        FROM SNG001 A1
       WHERE A1.SNG001INST = P_INSTANCIA;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    INCREMENTO_SALDO := NULL;
    BEGIN
      PQ_CR_CALCULO_SALDOS.SP_OBTENER_SALDO_SBS(PN_PAIS   => PAIS_DOCUMENTO,
                                                PN_TIPDOC => TIPO_DOCUMENTO,
                                                PC_NUMDOC => NRO_DOCUMENTO,
                                                VO_RPTA   => INCREMENTO_SALDO);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    P_INCREMENTO_SALDO := INCREMENTO_SALDO;
  END SP_CR_VALIDAR_SALDO_SBS;

  /*==================================================================================================================*/
  PROCEDURE SP_CR_OBTENER_CALIFICACION(P_INSTANCIA        IN NUMBER,
                                       P_FECHA_RCC        OUT DATE,
                                       P_CALIF_NORMAL     OUT NUMBER,
                                       P_CALIF_CPP        OUT NUMBER,
                                       P_CALIF_DEFICIENTE OUT NUMBER,
                                       P_CALIF_DUDOSO     OUT NUMBER,
                                       P_CALIF_PERDIDA    OUT NUMBER) IS
  
    -- *****************************************************************
    -- NOMBRE                      : SP_CR_OBTENER_CALIFICACION
    -- SISTEMA                     : BANTOTAL
    -- MODULO                      : CREDITOS - ACTIVAS
    -- VERSION                     : 1.0
    -- FECHA DE CREACION           : 16/10/2024
    -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
    -- PARAMETROS                  : - P_INSTANCIA        : NUMBER(10)
    --                               - P_FECHA_RCC        : DATE
    --                               - P_CALIF_NORMAL     : NUMBER(5, 2)
    --                               - P_CALIF_CPP        : NUMBER(5, 2)
    --                               - P_CALIF_DEFICIENTE : NUMBER(5, 2)
    --                               - P_CALIF_DUDOSO     : NUMBER(5, 2)
    --                               - P_CALIF_PERDIDA    : NUMBER(5, 2)
    -- USO                         : OBTIENE LA CALIFICACION DEL CLIENTE
    -- ESTADO                      : ACTIVO
    -- ACCESO                      : PUBLICO
    --------------------------------------------------------------------
    -- FECHA DE MODIFICACION       : 
    -- AUTOR DE LA MODIFICACION    : 
    -- DESCRIPCION DE MODIFICACION : 
    --
    -- *****************************************************************
  
    CUENTA_CREDITO   NUMBER(9);
    PAIS_DOCUMENTO   NUMBER(3);
    TIPO_DOCUMENTO   NUMBER(2);
    CALIF_NORMAL     NUMBER(5, 2);
    CALIF_CPP        NUMBER(5, 2);
    CALIF_DEFICIENTE NUMBER(5, 2);
    CALIF_DUDOSO     NUMBER(5, 2);
    CALIF_PERDIDA    NUMBER(5, 2);
    NRO_DOCUMENTO    VARCHAR2(12);
    FECHA_RCC        DATE;
  BEGIN
    CUENTA_CREDITO := 0;
    BEGIN
      SELECT A1.XWFCUENTA
        INTO CUENTA_CREDITO
        FROM XWF700 A1
       WHERE A1.XWFPRCINS = P_INSTANCIA
         AND A1.XWFCAR3 = '1';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    PAIS_DOCUMENTO := 0;
    TIPO_DOCUMENTO := 0;
    NRO_DOCUMENTO  := NULL;
    BEGIN
      SELECT A1.PEPAIS, A1.PETDOC, TRIM(A1.PENDOC)
        INTO PAIS_DOCUMENTO, TIPO_DOCUMENTO, NRO_DOCUMENTO
        FROM FSR008 A1
       WHERE A1.PGCOD = 1
         AND A1.CTNRO = CUENTA_CREDITO
         AND A1.CTTFIR = 'T';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    FECHA_RCC := NULL;
    BEGIN
      SELECT TO_DATE(A1.TPNRO, 'DD/MM/RRRR')
        INTO FECHA_RCC
        FROM FST098 A1
       WHERE A1.PGCOD = 1
         AND A1.TPCOD = 7647
         AND A1.TPCORR = 12;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    CALIF_NORMAL     := 0;
    CALIF_CPP        := 0;
    CALIF_DEFICIENTE := 0;
    CALIF_DUDOSO     := 0;
    CALIF_PERDIDA    := 0;
    BEGIN
      SELECT A1.N_CALIF0,
             A1.N_CALIF1,
             A1.N_CALIF2,
             A1.N_CALIF3,
             A1.N_CALIF4
        INTO CALIF_NORMAL,
             CALIF_CPP,
             CALIF_DEFICIENTE,
             CALIF_DUDOSO,
             CALIF_PERDIDA
        FROM CLDRCCI A1
       WHERE A1.D_FECPRE = FECHA_RCC
         AND A1.C_TDOCID =
             (SELECT TRIM(TO_CHAR(A3.TP1NRO2))
                FROM FST198 A3
               WHERE A3.TP1COD = 1
                 AND A3.TP1COD1 = 11111
                 AND A3.TP1CORR1 = 1
                 AND A3.TP1CORR2 = 5
                 AND A3.TP1CORR3 > 0
                 AND A3.TP1NRO1 = TIPO_DOCUMENTO)
         AND A1.C_DOCIDE = NRO_DOCUMENTO
         AND ROWNUM = 1;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        BEGIN
          SELECT A1.N_CALIF0,
                 A1.N_CALIF1,
                 A1.N_CALIF2,
                 A1.N_CALIF3,
                 A1.N_CALIF4
            INTO CALIF_NORMAL,
                 CALIF_CPP,
                 CALIF_DEFICIENTE,
                 CALIF_DUDOSO,
                 CALIF_PERDIDA
            FROM CLDRCCI A1
           WHERE A1.D_FECPRE = FECHA_RCC
             AND A1.C_TDOCTR =
                 (SELECT TRIM(TO_CHAR(A3.TP1NRO2))
                    FROM FST198 A3
                   WHERE A3.TP1COD = 1
                     AND A3.TP1COD1 = 11111
                     AND A3.TP1CORR1 = 1
                     AND A3.TP1CORR2 = 5
                     AND A3.TP1CORR3 > 0
                     AND A3.TP1NRO1 = TIPO_DOCUMENTO)
             AND A1.C_DOCTRI = NRO_DOCUMENTO
             AND ROWNUM = 1;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      WHEN OTHERS THEN
        NULL;
    END;
  
    P_FECHA_RCC        := FECHA_RCC;
    P_CALIF_NORMAL     := CALIF_NORMAL;
    P_CALIF_CPP        := CALIF_CPP;
    P_CALIF_DEFICIENTE := CALIF_DEFICIENTE;
    P_CALIF_DUDOSO     := CALIF_DUDOSO;
    P_CALIF_PERDIDA    := CALIF_PERDIDA;
  
  END SP_CR_OBTENER_CALIFICACION;

  /*==================================================================================================================*/
  PROCEDURE SP_CR_VALIDAR_IMPORTE_EXCEPTION(P_INSTANCIA     IN NUMBER,
                                            P_IMPORTE       OUT NUMBER,
                                            P_EXCEPCION     OUT VARCHAR2,
                                            P_CODIGO_ERROR  OUT VARCHAR2,
                                            P_MENSAJE_ERROR OUT VARCHAR2) IS
  
    -- *****************************************************************
    -- NOMBRE                      : SP_CR_VALIDAR_IMPORTE_EXCEPTION
    -- SISTEMA                     : BANTOTAL
    -- MODULO                      : CREDITOS - ACTIVAS
    -- VERSION                     : 1.0
    -- FECHA DE CREACION           : 16/10/2024
    -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
    -- PARAMETROS                  : - P_INSTANCIA     : NUMBER(10)
    --                               - P_IMPORTE       : NUMBER(17, 2)
    --                               - P_EXCEPCION     : VARCHAR2(1)
    --                               - P_CODIGO_ERROR  : VARCHAR2(5)
    --                               - P_MENSAJE_ERROR : VARCHAR2(255)
    -- USO                         : VALIDA SI EL MONTO PROPUESTO EXISTE EN LA TABLA LOG
    -- ESTADO                      : ACTIVO
    -- ACCESO                      : PUBLICO
    --------------------------------------------------------------------
    -- FECHA DE MODIFICACION       : 12/05/2025
    -- AUTOR DE LA MODIFICACION    : ENINAH 
    -- DESCRIPCION DE MODIFICACION : Se está modificando las variables finales que devuelve.
    --
    -- *****************************************************************
  
    MONTO_PROPUESTO    NUMBER(17, 2);
    EXCEPCION          VARCHAR2(1);
    CODIGO_ERROR       VARCHAR2(5);
    MENSAJE_ERROR      VARCHAR2(255);
    VI_PAIS            number(3);
    VI_TDOC            number(2);
    VI_NDOC            char(12);
    VE_DESTINO         varchar2(60);
    VI_NUEVO_IMP_LIMIT number(17, 2);
    VI_CAMPAÑA         NUMBER(9);
    VI_DESTINOS_C      char(30);
    VI_SEGMENTO        number(5);
    vi_monto           number(17, 2);
    v_fecha            DATE;
    v_hora             VARCHAR2(8);
    --*****************************************Maycol*********************************  
  BEGIN
    CODIGO_ERROR    := '00000';
    MENSAJE_ERROR   := NULL;
    MONTO_PROPUESTO := 0;
    EXCEPCION       := 'N';
  
    BEGIN
      SELECT A1.AQPC791MTOPRO, 'S'
        INTO MONTO_PROPUESTO, EXCEPCION
        FROM AQPC791 A1
       WHERE A1.AQPC791INST = P_INSTANCIA;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    P_IMPORTE       := MONTO_PROPUESTO;
    P_EXCEPCION     := EXCEPCION;
    P_CODIGO_ERROR  := CODIGO_ERROR;
    P_MENSAJE_ERROR := MENSAJE_ERROR;
    --***************************************************************************************
  
    --************************Edehilton******************************************************
    -- Obtengo la clave del documento
    Begin
      select SNG001PAIS, SNG001TDOC, SNG001NDOC
        into VI_PAIS, VI_TDOC, VI_NDOC
        from sng001
       where sng001inst = P_INSTANCIA;
    exception
      when others then
        null;
    end;
  
    -- Obtengo el destino 
    Begin
      PQ_CR_REPROGRAMACIONES.sp_cr_resolutorF(ln_Pepais    => VI_PAIS,
                                              ln_Petdoc    => VI_TDOC,
                                              ln_Pendoc    => VI_NDOC,
                                              ln_instancia => P_INSTANCIA,
                                              ln_Destino   => VE_DESTINO);
    exception
      when others then
        null;
    end;
  
    VE_DESTINO    := TRIM(VE_DESTINO);
    VI_DESTINOS_C := RPAD(substr(VE_DESTINO, 1, 30), 30, ' ');
    -- Obtengo el segmento evaluado
    begin
      select AQPA074SEGM
        into VI_SEGMENTO
        from aqpa074
       where aqpa074inst = P_INSTANCIA
         and aqpa074insta = P_INSTANCIA;
    exception
      when others then
        null;
    end;
  
    -- ***** Nueva Guía de Campañas parametrizables ***************--------
    VI_CAMPAÑA := 0;
    begin
      SELECT TP1NRO3
        INTO VI_CAMPAÑA
        from fst198
       Where Tp1cod = 1
         AND Tp1cod1 = 10823
         AND Tp1corr1 = 10
         AND TP1CORR2 = 1
         AND TP1DESC = VI_DESTINOS_C;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    end;
  
    -- ***** Nueva Guía de Segmentos Pametrizable**************------
    begin
      SELECT TP1IMP2
        INTO VI_NUEVO_IMP_LIMIT
        FROM Fst198
       Where Tp1cod = 1
         AND Tp1cod1 = 10823
         AND Tp1corr1 = 4
         AND Tp1corr2 = 1
         AND Tp1corr3 > 0
         AND Tp1nro1 = VI_SEGMENTO
         AND TP1NRO2 = VI_CAMPAÑA
         AND Tp1nro3 = 0;
    exception
      when others then
        null;
    end;
  
    begin
      select XWFMONTO1
        into vi_monto
        from xwf700
       where XWFPRCINS = P_INSTANCIA;
    exception
      when others then
        null;
    end;
    -- Obtener la fecha (sin la hora)
    v_fecha := TRUNC(SYSDATE);
    -- Obtener la hora como cadena (HH24:MI:SS)
    v_hora := TO_CHAR(SYSDATE, 'HH24:MI:SS');
  
    if VI_CAMPAÑA > 0 and VI_NUEVO_IMP_LIMIT > 0 then
      P_IMPORTE       := VI_NUEVO_IMP_LIMIT;
      P_EXCEPCION     := 'S';
      P_CODIGO_ERROR  := CODIGO_ERROR;
      P_MENSAJE_ERROR := MENSAJE_ERROR;
    
      begin
        insert into AQPD169
          (AQPD169INST,
           AQPD169FECH,
           AQPD169HOR,
           AQPD169MONTO,
           AQPD169IMPMAX,
           AQPD169SEG,
           AQPD169CAMP)
        values
          (P_INSTANCIA,
           v_fecha,
           v_hora,
           vi_monto,
           VI_NUEVO_IMP_LIMIT,
           VI_SEGMENTO,
           VI_CAMPAÑA);
        commit;
      exception
        when others then
          null;
      end;
    end if;
  
  END SP_CR_VALIDAR_IMPORTE_EXCEPTION;

  /*==================================================================================================================*/
  PROCEDURE SP_CR_GRABAR_LOG_SEGMENTACION(P_USUARIO_REGISTRO  IN VARCHAR2,
                                          P_INSTANCIA         IN VARCHAR2,
                                          P_EMPRESA           IN VARCHAR2,
                                          P_MODULO            IN NUMBER,
                                          P_SUCURSAL          IN NUMBER,
                                          P_MONEDA            IN NUMBER,
                                          P_PAPEL             IN NUMBER,
                                          P_CUENTA            IN NUMBER,
                                          P_OPERACION         IN NUMBER,
                                          P_SUBOPERACION      IN NUMBER,
                                          P_TIPO_OPERACION    IN NUMBER,
                                          P_ITEM_ETAPA        IN NUMBER,
                                          P_CODIGO_ETAPA      IN NUMBER,
                                          P_NOMBRE_ETAPA      IN VARCHAR2,
                                          P_TIPO_SEGMENTO     IN NUMBER,
                                          P_COD_SEGM_ANTERIOR IN NUMBER,
                                          P_NOM_SEGM_ANTERIOR IN VARCHAR2,
                                          P_COD_SEGM_ACTUAL   IN NUMBER,
                                          P_NOM_SEGM_ACTUAL   IN VARCHAR2,
                                          P_MONTO_PROPUESTO   IN NUMBER,
                                          P_MONTO_APROBADO    IN NUMBER,
                                          P_TOPE_SEGMENTO     IN NUMBER,
                                          P_TOPE_MAXIMO_SEG   IN NUMBER,
                                          P_PORCENTAJE_SEG    IN NUMBER,
                                          P_PROMEDIO_DIAS     IN NUMBER,
                                          P_FECHA_RCC         IN DATE,
                                          P_CALIF_NORMAL      IN NUMBER,
                                          P_CALIF_CPP         IN NUMBER,
                                          P_CALIF_DEFICIENTE  IN NUMBER,
                                          P_CALIF_DUDOSO      IN NUMBER,
                                          P_CALIF_PERDIDA     IN NUMBER,
                                          P_ESTADO            IN VARCHAR2,
                                          P_COMENTARIO        IN VARCHAR2,
                                          P_CODERROR          OUT VARCHAR2,
                                          P_MSGERROR          OUT VARCHAR2) IS
  
    -- *****************************************************************
    -- NOMBRE                      : SP_CR_GRABAR_LOG_SEGMENTACION
    -- SISTEMA                     : BANTOTAL
    -- MODULO                      : CREDITOS - ACTIVAS
    -- VERSION                     : 1.0
    -- FECHA DE CREACION           : 16/10/2024
    -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
    -- PARAMETROS                  : - P_USUARIO_REGISTRO  : VARCHAR2(10)
    --                               - P_INSTANCIA         : NUMBER(10)
    --                               - P_EMPRESA           : NUMBER(3)
    --                               - P_MODULO            : NUMBER(3)
    --                               - P_SUCURSAL          : NUMBER(3)
    --                               - P_MONEDA            : NUMBER(4)
    --                               - P_PAPEL             : NUMBER(4)
    --                               - P_CUENTA            : NUMBER(9)
    --                               - P_OPERACION         : NUMBER(9)
    --                               - P_SUBOPER           : NUMBER(3)
    --                               - P_TIPO_OPER         : NUMBER(3)
    --                               - P_ITEM_ETAPA        : NUMBER(10)
    --                               - P_CODIGO_ETAPA      : NUMBER(4)
    --                               - P_NOMBRE_ETAPA      : VARCHAR2(50)
    --                               - P_TIPO_SEGMENTO     : NUMBER(2)
    --                               - P_COD_SEGM_ANTERIOR : NUMBER(5)
    --                               - P_NOM_SEGM_ANTERIOR : VARCHAR2(40)
    --                               - P_COD_SEGM_ACTUAL   : NUMBER(5)
    --                               - P_NOM_SEGM_ACTUAL   : VARCHAR2(40)
    --                               - P_MONTO_PROPUESTO   : NUMBER(17, 2)
    --                               - P_MONTO_APROBADO    : NUMBER(17, 2)
    --                               - P_TOPE_SEGMENTO     : NUMBER(17, 2)
    --                               - P_TOPE_MAXIMO_SEG   : NUMBER(17, 2)
    --                               - P_PORCENTAJE_SEG    : NUMBER(17, 2)
    --                               - P_PROMEDIO_DIAS     : NUMBER(9, 2)
    --                               - P_FECHA_RCC         : DATE
    --                               - P_CLASIF_NORMAL     : NUMBER(5, 2)
    --                               - P_CLASIF_CPP        : NUMBER(5, 2)
    --                               - P_CALIF_DEFICIENTE  : NUMBER(5, 2)
    --                               - P_CALIF_DUDOSO      : NUMBER(5, 2)
    --                               - P_CALIF_PERDIDA     : NUMBER(5, 2)
    --                               - P_ESTADO            : VARCHAR2(1)
    --                               - P_COMENTARIO        : VARCHAR2(400)
    --                               - P_CODERROR          : VARCHAR2(1)
    --                               - P_MSGERROR          : VARCHAR2(1)
    -- USO                         : GRABA EL MONTO APROBADO DE LA SEGMENTACION
    -- ESTADO                      : ACTIVO
    -- ACCESO                      : PUBLICO
    --------------------------------------------------------------------
    -- FECHA DE MODIFICACION       : 30/05/2025
    -- AUTOR DE LA MODIFICACION    : MAYCOL CHAVEZ CHUMAN
    -- DESCRIPCION DE MODIFICACION : SE AGREGARON LOS PARAMETROS P_MONTO_APROBADO Y
    --                               P_COMENTARIO
    -- *****************************************************************
  
    FECHA_SISTEMA  DATE := NULL;
    PAIS_DOCUMENTO NUMBER(3) := NULL;
    TIPO_DOCUMENTO NUMBER(2) := NULL;
    CORRELATIVO    NUMBER(17) := NULL;
    NRO_DOCUMENTO  VARCHAR2(12) := NULL;
    V_EXSTREG      VARCHAR2(1) := 'N';
    V_CODERROR     VARCHAR2(5) := '00000';
    V_MSGERROR     VARCHAR2(255) := NULL;
  BEGIN
    BEGIN
      SELECT 'S'
        INTO V_EXSTREG
        FROM AQPC791 A1
       WHERE A1.AQPC791INST = P_INSTANCIA
         AND A1.AQPC791ESTADO = P_ESTADO;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        BEGIN
          SELECT A1.PGFAPE
            INTO FECHA_SISTEMA
            FROM FST017 A1
           WHERE A1.PGCOD = 1;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      
        BEGIN
          SELECT NVL(MAX(A1.AQPC791CORR), 0) + 1
            INTO CORRELATIVO
            FROM AQPC791 A1
           WHERE A1.AQPC791FHREG = FECHA_SISTEMA;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      
        BEGIN
          SELECT A1.PEPAIS, A1.PETDOC, A1.PENDOC
            INTO PAIS_DOCUMENTO, TIPO_DOCUMENTO, NRO_DOCUMENTO
            FROM FSR008 A1
           WHERE A1.PGCOD = 1
             AND A1.CTNRO = P_CUENTA
             AND A1.CTTFIR = 'T';
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      
        BEGIN
          INSERT INTO AQPC791
            (AQPC791CORR,
             AQPC791FHREG,
             AQPC791HOREG,
             AQPC791USREG,
             AQPC791INST,
             AQPC791EMP,
             AQPC791MOD,
             AQPC791SUC,
             AQPC791MDA,
             AQPC791PAP,
             AQPC791CTA,
             AQPC791OPER,
             AQPC791SBOP,
             AQPC791TOPE,
             AQPC791PAIS,
             AQPC791TDOC,
             AQPC791NDOC,
             AQPC791ITMETP,
             AQPC791CODETP,
             AQPC791NOMETP,
             AQPC791TIPSEG,
             AQPC791CSEGAN,
             AQPC791NSEGAN,
             AQPC791CSEGAC,
             AQPC791NSEGAC,
             AQPC791MTOPRO,
             AQPC791TOPSEG,
             AQPC791MAXSEG,
             AQPC791PRJSEG,
             AQPC791PRMDIA,
             AQPC791FHRCC,
             AQPC791NORMAL,
             AQPC791CPP,
             AQPC791DEFI,
             AQPC791DUDOSO,
             AQPC791PERDID,
             AQPC791ESTADO,
             AQPC791MTOAPR,
             AQPC791COMT)
          VALUES
            (CORRELATIVO,
             FECHA_SISTEMA,
             TO_CHAR(SYSDATE, 'HH24:MI:SS'),
             P_USUARIO_REGISTRO,
             P_INSTANCIA,
             P_EMPRESA,
             P_MODULO,
             P_SUCURSAL,
             P_MONEDA,
             P_PAPEL,
             P_CUENTA,
             P_OPERACION,
             P_SUBOPERACION,
             P_TIPO_OPERACION,
             PAIS_DOCUMENTO,
             TIPO_DOCUMENTO,
             NRO_DOCUMENTO,
             P_ITEM_ETAPA,
             P_CODIGO_ETAPA,
             P_NOMBRE_ETAPA,
             P_TIPO_SEGMENTO,
             P_COD_SEGM_ANTERIOR,
             P_NOM_SEGM_ANTERIOR,
             P_COD_SEGM_ACTUAL,
             P_NOM_SEGM_ACTUAL,
             P_MONTO_PROPUESTO,
             P_TOPE_SEGMENTO,
             P_TOPE_MAXIMO_SEG,
             P_PORCENTAJE_SEG,
             P_PROMEDIO_DIAS,
             P_FECHA_RCC,
             P_CALIF_NORMAL,
             P_CALIF_CPP,
             P_CALIF_DEFICIENTE,
             P_CALIF_DUDOSO,
             P_CALIF_PERDIDA,
             P_ESTADO,
             P_MONTO_APROBADO,
             P_COMENTARIO);
          COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      WHEN OTHERS THEN
        NULL;
    END;
  
    IF V_EXSTREG = 'S' THEN
      CASE
        WHEN P_ESTADO = 'A' THEN
          V_CODERROR := '90001';
          V_MSGERROR := 'La solicitud ' || P_INSTANCIA ||
                        ' ya se encuentra aprobada';
        WHEN P_ESTADO = 'R' THEN
          V_CODERROR := '90002';
          V_MSGERROR := 'La solicitud ' || P_INSTANCIA ||
                        ' ya se encuentra rechazada. Generar una nueva solicitud';
        ELSE
          NULL;
      END CASE;
    END IF;
  
    P_CODERROR := V_CODERROR;
    P_MSGERROR := V_MSGERROR;
  
  END SP_CR_GRABAR_LOG_SEGMENTACION;

  ----------------------------------------------------------------------------------------------------
  PROCEDURE SP_CR_ENVIAR_EMAIL(P_INSTANCIA IN NUMBER,
                               P_TIPOMSG   IN VARCHAR2) IS
  
    ----------------------------------------------------------------------------------------------------
    -- NOMBRE                      : SP_CR_ENVIAR_EMAIL
    -- SISTEMA                     : BANTOTAL
    -- MODULO                      : CREDITOS - ACTIVAS
    -- VERSION                     : 1.0
    -- FECHA DE CREACION           : 26/05/2025
    -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
    -- USO                         : ENVIA CORREOS 
    -- PARAMETROS                  : P_INSTANCIA | NUMBER(10)
    --                               P_TIPOMSG   | VARCHAR2(2)
    -- ESTADO                      : ACTIVO
    -- ACCESO                      : PUBLICO
    ----------------------------------------------------------------------------------------------------
    -- FECHA DE MODIFICACION       : 
    -- AUTOR DE LA MODIFICACION    : 
    -- DESCRIPCION DE MODIFICACION : 
    ----------------------------------------------------------------------------------------------------
  
    V_MENSAJE     CLOB := NULL;
    V_ASUNTO      VARCHAR2(100)  := NULL;
    V_CORREO_PARA VARCHAR2(4000) := NULL;
    V_CUENTA      NUMBER(9) := NULL;
    V_OPERACION   NUMBER(9) := NULL;
    V_SUCURSAL    NUMBER(3) := NULL;
    V_MTOAPROB    VARCHAR2(30) := NULL;
    V_CODERROR    VARCHAR2(5) := NULL;
    V_MSGERROR    VARCHAR2(4000) := NULL;
    V_CORREO_ANLCRED VARCHAR2(40) := NULL;
    V_CORREO_ANLSEN  VARCHAR2(40) := NULL;
    V_COD_ANLSENI    VARCHAR2(10) := NULL;
    V_CORREO_GRTAGEN VARCHAR2(40) := NULL;
    V_COD_GRTAGEN    VARCHAR2(10) := NULL;
  BEGIN
    BEGIN
      SELECT A1.XWFCUENTA, A1.XWFOPERACION, A1.XWFSUCURSAL
        INTO V_CUENTA, V_OPERACION, V_SUCURSAL
        FROM XWF700 A1
       WHERE A1.XWFPRCINS = P_INSTANCIA
         AND A1.XWFCAR3 = '1';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      SELECT TRIM(TO_CHAR(A1.AQPC791MTOPRO, '999G999G999D99', 'NLS_NUMERIC_CHARACTERS = ''.,'''))
        INTO V_MTOAPROB
        FROM AQPC791 A1
       WHERE A1.AQPC791INST = P_INSTANCIA;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    
    -- OBTENER CORREO ANALISTA CREDITOS --
    BEGIN
      SELECT TRIM(C.WFUSREMAIL)|| ';', B.SNG057JEF
        INTO V_CORREO_ANLCRED, V_COD_ANLSENI
        FROM SNG001 A, SNG057 B, WFUSERS C
       WHERE A.SNG001INST = P_INSTANCIA
         AND B.SNG055EMP  = A.SNG001EMP
         AND B.SNG057USR  = A.SNG001ASE
         AND B.SNG055CAR  = 200
         AND C.WFUSRCOD   = RPAD(A.SNG001ASE, 30, ' ')
         AND ROWNUM       = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    
    -- OBTENER CORREO ANALISTA SENIOR --
    BEGIN
      SELECT TRIM(B.WFUSREMAIL)||';', A.SNG057JEF
        INTO V_CORREO_ANLSEN, V_COD_GRTAGEN
        FROM SNG057 A , WFUSERS B
       WHERE A.SNG055EMP = 1
         AND A.SNG057USR = RPAD(V_COD_ANLSENI, 10, ' ')
         AND A.SNG055CAR = 201
         AND B.WFUSRCOD  = RPAD(A.SNG057USR, 30, ' ')
         AND ROWNUM      = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    
    -- OBTENER CORREO GERENTE AGENCIA --
    BEGIN
      SELECT TRIM(B.WFUSREMAIL)||';'
        INTO V_CORREO_GRTAGEN
        FROM SNG057 A , WFUSERS B
       WHERE A.SNG055EMP = 1
         AND A.SNG057USR = RPAD(V_COD_GRTAGEN, 10, ' ')
         AND A.SNG055CAR = 202
         AND B.WFUSRCOD  = RPAD(A.SNG057USR, 30, ' ')
         AND ROWNUM      = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    
    BEGIN
      CASE
        WHEN P_TIPOMSG = '1' THEN
          V_ASUNTO  := 'Aprobacion de bloqueante con excepcion 406';
          V_MENSAJE := '<html>' ||
                       '<head><style type="text/css"></style></head>' ||
                       '<body>' || '<p>Estimad@,</p>' ||
                       '<p>Se aprobo la gestión para la cuenta: ' ||
                       V_CUENTA || ' Operación ' || V_OPERACION ||
                       ', el monto consolidado hasta ' || V_MTOAPROB ||
                       '</p>' || '</body>
                            </html>';
        WHEN P_TIPOMSG = '2' THEN
          V_ASUNTO  := 'Rechazado de bloqueante con excepcion 406';
          V_MENSAJE := '<html>' ||
                       '<head><style type="text/css"></style></head>' ||
                       '<body>' || '<p>Estimad@,</p>' ||
                       '<p>Se rechazo la gestión para la cuenta: ' ||
                       V_CUENTA || ' Operación ' || V_OPERACION ||
                       ', el monto consolidado hasta ' || V_MTOAPROB ||
                       '</p>' || '</body>
                            </html>';
      END CASE;
      
      V_CORREO_PARA := V_CORREO_ANLCRED || V_CORREO_ANLSEN || V_CORREO_GRTAGEN;
      V_CORREO_PARA := SUBSTR(TRIM(V_CORREO_PARA), 1, LENGTH(TRIM(V_CORREO_PARA)) - 1);
      
      PQ_AH_PLANILLAS.P_SENDMAILATTACH(p_DestinatariosPara => V_CORREO_PARA, -- VARCHAR2(4000)
                                       p_DestinatariosCC   => '', -- VARCHAR2(4000)
                                       p_DestinatariosBcc  => '', -- VARCHAR2(4000)
                                       p_Mensaje           => V_MENSAJE, -- CLOB
                                       p_Remitente         => 'notificaciones@cajaarequipa.pe', -- VARCHAR2(100)
                                       p_Asunto            => V_ASUNTO, -- VARCHAR2(100)
                                       p_TipoMensaje       => 'HTML',
                                       p_Directorio        => '',
                                       p_ArchivosAdjuntos  => '',
                                       p_c_coderr          => V_CODERROR, -- VARCHAR2(5)
                                       p_c_deserr          => V_MSGERROR -- VARCHAR2(4000)
                                       );
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  END SP_CR_ENVIAR_EMAIL;

  /*===================================================================================================*/
  PROCEDURE SP_CR_OBTENER_MONTO_MAX(P_INSTANCIA IN NUMBER,
                                    P_MONTO_MAX OUT NUMBER) IS
  
    -- ====================================================================================================
    -- NOMBRE                      : NOMBRE_PROCEDIMIENTO
    -- SISTEMA                     : BANTOTAL
    -- MODULO                      : CREDITOS - ACTIVAS
    -- VERSION                     : 1.0
    -- FECHA DE CREACION           : 26/05/2025
    -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
    -- USO                         : RETORNA EL MONTO MAXIMO DE TODOS LOS CREDITOS DEL CLIENTE
    -- PARAMETROS                  : - P_INSTANCIA | NUMBER(10)
    --                               - P_MONTO_MAX | NUMBER(17, 2)
    -- ESTADO                      : ACTIVO
    -- ACCESO                      : PUBLICO
    -- ====================================================================================================
    -- FECHA DE MODIFICACION       : 
    -- AUTOR DE LA MODIFICACION    : 
    -- DESCRIPCION DE MODIFICACION : 
    -- ====================================================================================================
  
    V_MONTO_MAX NUMBER(17, 2) := NULL;
  
  BEGIN
    BEGIN
      SELECT NVL(MAX(D.AOIMP), 0)
        INTO V_MONTO_MAX
        FROM XWF700 A, FSR008 B, FSR008 C, FSD010 D
       WHERE A.XWFPRCINS = P_INSTANCIA
         AND A.XWFCAR3 = '1'
         AND B.PGCOD = A.XWFEMPRESA
         AND B.CTNRO = A.XWFCUENTA
         AND B.CTTFIR = 'T'
         AND C.PEPAIS = B.PEPAIS
         AND C.PETDOC = B.PETDOC
         AND C.PENDOC = B.PENDOC
         AND C.CTTFIR = 'T'
         AND D.PGCOD = C.PGCOD
         AND D.AOCTA = C.CTNRO
         AND D.AOMOD IN (SELECT T1.MODULO
                           FROM FST111 T1
                          WHERE T1.DSCOD = 50
                            AND T1.MODULO = D.AOMOD);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    P_MONTO_MAX := V_MONTO_MAX;
  
  END SP_CR_OBTENER_MONTO_MAX;

  /*===================================================================================================*/
  PROCEDURE SP_CR_OBTENER_TIPO_SOLI(P_INSTANCIA IN NUMBER,
                                    P_TIPO_SOLI OUT VARCHAR2) IS
    -- ====================================================================================================
    -- NOMBRE                      : NOMBRE_PROCEDIMIENTO
    -- SISTEMA                     : BANTOTAL
    -- MODULO                      : CREDITOS - ACTIVAS
    -- VERSION                     : 1.0
    -- FECHA DE CREACION           : 26/05/2025
    -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
    -- USO                         : RETORNA LA DESCRIPCION DEL TIPO DE SOLICITUD
    -- PARAMETROS                  : - P_INSTANCIA | NUMBER(10)   | INSTANCIA
    --                               - P_TIPO_SOLI | VARCHAR2(50) | DESCRIPCION TIPO SOLICITUD
    -- ESTADO                      : ACTIVO
    -- ACCESO                      : PUBLICO
    -- ====================================================================================================
    -- FECHA DE MODIFICACION       : 
    -- AUTOR DE LA MODIFICACION    : 
    -- DESCRIPCION DE MODIFICACION : 
    -- ====================================================================================================
  
    V_TIPO_SOLI VARCHAR2(100) := NULL;
  BEGIN
    BEGIN
      SELECT TRIM(C.SNG036LTTX)
        INTO V_TIPO_SOLI
        FROM SNG001 A, SNGP06 B, SNG036 c
       WHERE A.SNG001INST = P_INSTANCIA
         AND B.SNGP09COD = 8
         AND B.SNGP06COD = A.SNG001ORI
         AND C.SNG036LTCO = B.SNGP06LTCO;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    P_TIPO_SOLI := V_TIPO_SOLI;
  
  END SP_CR_OBTENER_TIPO_SOLI;

END PQ_CR_DATOS_SEGMENTACION;
/
