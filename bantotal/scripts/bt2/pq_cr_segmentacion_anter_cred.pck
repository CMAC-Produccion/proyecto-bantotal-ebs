create or replace package PQ_CR_SEGMENTACION_ANTER_CRED is
  -- *****************************************************************
  -- Nombre                     : PQ_CR_SEGMENTACION_ANTER_CRED
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 16/10/2024
  -- Autor de Creación          : JALVAROH
  -- Uso                        : RETORNA LA SEGMENTCION DE ULTIMO CREDITO VIGENTE
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 
  -- *****************************************************************
  PROCEDURE sp_cr_buscar_cred_ultimo_vi(vi_n_insta in number,
                                        vo_v__segm out varchar2, -- salida
                                        p_n_coderr out number, -- salida 
                                        p_c_msgerr out varchar2 -- salida  
                                        );
  PROCEDURE sp_cr_obtener_monto_max_sgr(instancia       in number,
                                        usuario         in varchar2,
                                        VEO_N_MAX_VALUE out number,
                                        VEO_COD_ERROR   out number,
                                        VEO_MSG_ERROR   out varchar2);

end PQ_CR_SEGMENTACION_ANTER_CRED;
/

create or replace package body PQ_CR_SEGMENTACION_ANTER_CRED is

  PROCEDURE sp_cr_buscar_cred_ultimo_vi(vi_n_insta in number,
                                        vo_v__segm out varchar2, -- salida
                                        p_n_coderr out number, -- salida 
                                        p_c_msgerr out varchar2 -- salida  
                                        ) IS
  
    -- *****************************************************************
    -- Nombre                     : sp_cr_buscar_cred_ultimo_vi
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 16/10/2024
    -- Autor de Creación          : JALVAROH
    -- Uso                        : BUSCA EL ULTIMO CREDITO VIGENTE Y RETORNA SU SEGMENTACION
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 24/10/2024
    -- Autor de la Modificación   : CALARCONAP
    -- Descripción de Modificación: SE AGREGO EXCEPCIONES
    -- *****************************************************************
    ------------------- VARIABLES --------------------------------------
    VII_N_CTA               xwf700.xwfcuenta%type;
    VII_N_PAIS              fsr008.PEPAIS%type;
    VII_N_PTDOC             fsr008.PETDOC%type;
    VII_C_NDOC              fsr008.PENDOC%type;
    VCI_N_PAIS              fsr008.PEPAIS%type;
    VCI_N_PETDOC            fsr008.PETDOC%type;
    VCI_C_DOC               fsr008.PENDOC%type;
    VII_N_PGCOD             fsd010.pgcod%type;
    VII_N_MOD               fsd010.aomod%type;
    VII_N_SUC               fsd010.aosuc%type;
    VII_N_MDA               fsd010.aomda%type;
    VII_N_PAP               fsd010.aopap%type;
    VII_N_OPE               fsd010.aooper%type;
    VII_N_SBO               fsd010.aosbop%type;
    VII_N_TOP               fsd010.aotope%type;
    VII_N_INST_ULTCRDDESEM  number;
    VII_N_NEVA              number;
    VII_N_COD_ITEM          number;
    VII_D_FECHA_DESEMBOLSO  date;
    VII_N_CUENTAA           number;
    VII_D_FECHA_DESEMBOLSOA date;
  
    CURSOR LISTA_CUENTAS(VCI_N_PAIS   IN NUMBER,
                         VCI_N_PETDOC IN NUMBER,
                         VCI_C_DOC    IN CHARACTER) IS
      SELECT *
        FROM FSR008
       WHERE PEPAIS = VCI_N_PAIS
         AND PETDOC = VCI_N_PETDOC
         AND PENDOC = VCI_C_DOC
         AND TTCOD = 1
         AND CTTFIR = 'T'; --OBTENGO TODAS LAS CUENTAS DONDE ES TITULAR
  
  BEGIN
  
    ------------------OBTENER LA CUENTA------------------------------------------------------------
    BEGIN
      select xwfcuenta
        INTO VII_N_CTA
        from xwf700
       where xwfprcins = vi_n_insta
         and xwfcar3 = '1';
    EXCEPTION
      WHEN OTHERS THEN
        p_n_coderr := sqlcode; --0001;
        p_c_msgerr := sqlerrm; --'Error al momento de obtener cuenta';
    END;
  
    ----------------OBTENER LA CLAVE DEL DOCUMENTO-------------------------------------------------
  
    BEGIN
      select PEPAIS, PETDOC, PENDOC
        INTO VII_N_PAIS, VII_N_PTDOC, VII_C_NDOC
        from fsr008
       where ctnro = VII_N_CTA
         and ttcod = 1
         anD cttfir = 'T'; --OBTENGO LA CLVE DEL DOCUMENTO.  
    EXCEPTION
      WHEN OTHERS THEN
        p_n_coderr := 0002;
        p_c_msgerr := 'Error al obtener la clave del documento';
    END;
  
    --------------------- obtener fecha y la clave de los ultimos creditos desembolsado -----------------
  
    BEGIN
      VII_D_FECHA_DESEMBOLSOA := to_date('01/01/1900', 'DD/MM/RRRR');
      VII_N_CUENTAA           := 0;
      --OBTENER LA FECHA y cuenta DEL ULTIMO DESEMBOLSO
      FOR X IN LISTA_CUENTAS(VII_N_PAIS, VII_N_PTDOC, VII_C_NDOC) LOOP
        BEGIN
          select MAX(AOFVAL) FECHA_DESEMBOLSO
            INTO VII_D_FECHA_DESEMBOLSO
            from fsd010
           where PGCOD = 1
             AND AOMOD IN (SELECT MODULO
                             FROM FST111
                            WHERE DSCOD = 50
                              AND MODULO > 99
                              AND MODULO < 200)
             AND aocta in (X.CTNRO); --OBTENER LA FECHA DEL ULTIMO DESEMBOLSO
        EXCEPTION
          WHEN OTHERS THEN
            p_n_coderr := 0003;
            p_c_msgerr := 'Error al obtener la fecha del ultimo desembolso';
        END;
        IF VII_D_FECHA_DESEMBOLSO > VII_D_FECHA_DESEMBOLSOA THEN
          VII_D_FECHA_DESEMBOLSOA := VII_D_FECHA_DESEMBOLSO;
          VII_N_CUENTAA           := X.CTNRO;
        END IF;
      END LOOP;
      ---------------- obtener la clave del ultimo credito desembolsado.--------------------------------
      BEGIN
        select PGCOD,
               AOMOD,
               AOSUC,
               AOMDA,
               AOPAP,
               AOCTA,
               AOOPER,
               AOSBOP,
               AOTOPE
          INTO VII_N_PGCOD,
               VII_N_MOD,
               VII_N_SUC,
               VII_N_MDA,
               VII_N_PAP,
               VII_N_CTA,
               VII_N_OPE,
               VII_N_SBO,
               VII_N_TOP
          from fsd010
         where PGCOD = 1
           AND AOMOD IN (SELECT MODULO
                           FROM FST111
                          WHERE DSCOD = 50
                            AND MODULO > 99
                            AND MODULO < 200)
           AND aocta = VII_N_CUENTAA
           AND AOFVAL = VII_D_FECHA_DESEMBOLSOA;
      EXCEPTION
        WHEN OTHERS THEN
          p_n_coderr := 0004;
          p_c_msgerr := 'Error al obtener la clave del ultimo credito desembolsado';
      END;
      ---------------------------------------------------------------------------------------------------------   
      ---obtener LA INSTANCIA DEL ultimo credito desembolsado del cliente.
      BEGIN
        SELECT XWFPRCINS
          INTO VII_N_INST_ULTCRDDESEM
          FROM XWF700 X
         WHERE X.XWFEMPRESA = VII_N_PGCOd
           AND X.XWFSUCURSAL = VII_N_SUC
           AND X.XWFMODULO = VII_N_MOD
           AND X.XWFMONEDA = VII_N_MDA
           AND X.XWFPAPEL = VII_N_PAP
           AND X.XWFCUENTA = VII_N_CTA
           AND X.XWFOPERACION = VII_N_OPE
           AND X.XWFSUBOPE = VII_N_SBO
           AND X.XWFTIPOPE = VII_N_TOP
           AND XWFCAR3 = '1';
      EXCEPTION
        WHEN OTHERS THEN
          p_n_coderr := 0005;
          p_c_msgerr := 'Error al obtener la instancia del ultimo credito desembolsado';
      END;
      ----------------------------------------------------------------------------------- 
    
      --OBTENER maximo correlativo de ejecucion de la tarea para obtener la EVALUACION MAXIMA
      BEGIN
        SELECT max(PAE70NRO)
          INTO VII_N_NEVA
          FROM FPAE70 f
         WHERE PAE70INS = VII_N_INST_ULTCRDDESEM
           and f.pae51eva = 1; ---se agrego la tarea de solicitud
      EXCEPTION
        WHEN OTHERS THEN
          p_n_coderr := 0006;
          p_c_msgerr := 'Error al obtener el numero de evaluacion maxima';
      END;
    EXCEPTION
      WHEN OTHERS THEN
        p_n_coderr := 0007;
        p_c_msgerr := 'Error al obtener fecha y la clave de los ultimos creditos desembolsado';
    END;
    ------------------------------------------------------------------------------------------------
    ------------- OBTENEMOS EL NUMERO DEL MODULO ---------------------------------------------------
  
    BEGIN
      SELECT SNG021TMOD
        INTO VII_N_COD_ITEM
        FROM SNG021
       WHERE SNG021SOL = VII_N_INST_ULTCRDDESEM;
    EXCEPTION
      WHEN OTHERS THEN
        p_n_coderr := 0008;
        p_c_msgerr := 'Error al momento de obtener el numero de modulo';
    END;
    ------------------------------------------------------------------------------------------------
    ---OBTENER LA SEGMENTACION DEL ULTIMO CREDITO DESEMBOLSADO.
  
    IF VII_N_COD_ITEM = 13 and VII_N_MOD <> 103 THEN
      BEGIN
        SELECT REGEXP_SUBSTR(PAE71VAL, '^(.*):', 1, 1, NULL, 1) SEGMENTACION
          INTO vo_v__segm
          FROM FPAE71 F
         WHERE PAE51EVA = 1
           AND PAE71ITE = 486
           AND F.PAE70NRO = VII_N_NEVA; -- PYME
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      IF vo_v__segm IS NULL THEN
        BEGIN
          SELECT REGEXP_SUBSTR(PAE71VAL, '^(.*):', 1, 1, NULL, 1) SEGMENTACION
            INTO vo_v__segm
            FROM FPAE71 F
           WHERE PAE51EVA = 1
             AND PAE71ITE = 380
             AND F.PAE70NRO = VII_N_NEVA; -- PYME
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      END IF;
    ELSIF VII_N_COD_ITEM = 13 and VII_N_MOD = 103 THEN
      BEGIN
        SELECT REGEXP_SUBSTR(PAE71VAL, '^(.*):', 1, 1, NULL, 1) SEGMENTACION
          INTO vo_v__segm
          FROM FPAE71 F
         WHERE PAE51EVA = 1
           AND PAE71ITE = 486
           AND F.PAE70NRO = VII_N_NEVA; -- PYME
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      IF vo_v__segm IS NULL THEN
        BEGIN
          SELECT f.pae71val -- REGEXP_SUBSTR(PAE71VAL, '^(.*):', 1, 1, NULL, 1) SEGMENTACION
            INTO vo_v__segm
            FROM FPAE71 F
           WHERE PAE51EVA = 1
             AND PAE71ITE = 338
             AND F.PAE70NRO = VII_N_NEVA; -- PYME
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      END IF;
    ELSIF VII_N_COD_ITEM = 14 THEN
    
      BEGIN
        SELECT f.pae71val --REGEXP_SUBSTR(PAE71VAL, '^(.*):', 1, 1, NULL, 1) SEGMENTACION
          INTO vo_v__segm
          FROM FPAE71 F
         WHERE PAE51EVA = 1
           AND PAE71ITE = 446
           AND F.PAE70NRO = VII_N_NEVA; -- PYME
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    
    end if;
    p_n_coderr := 0000;
    p_c_msgerr := 'EXITO EN LA BUSQUEDA';
  EXCEPTION
    WHEN OTHERS THEN
      p_n_coderr := 0009;
      p_c_msgerr := 'Error al buscar del crédito ultimo vigente';
    
  END sp_cr_buscar_cred_ultimo_vi;

  procedure sp_cr_obtener_monto_max_sgr(instancia       in number,
                                        usuario         in varchar2,
                                        VEO_N_MAX_VALUE out number,
                                        VEO_COD_ERROR   out number,
                                        VEO_MSG_ERROR   out varchar2) is
  
    -- **************************************************************************************
    -- NOMBRE                      : sp_cr_obtener_monto_max_sgr
    -- SISTEMA                     : BANTOTAL
    -- MODULO                      : CREDITOS - ACTIVAS
    -- VERSION                     : 1.0
    -- FECHA DE CREACION           : 16/10/2024
    -- AUTOR DE CREACION           : ENINAH
    -- USO                         : RETORNA EL MONTO MAXIMO SIN GARANTIA REAL
    -- ESTADO                  : ACTIVO
    -- ACCESO                      : PUBLICO
    -----------------------------------------------------------------------------------------
    -- FECHA DE MODIFICACION       : 
    -- AUTOR DE LA MODIFICACION    : 
    -- DESCRIPCION DE MODIFICACION : 
    -- **************************************************************************************
  
    --VARIABLES INTERNAS PARA OBTENER INFORMACIONES DE LOS CREDITOS.
    VII_N_CTA          NUMBER(9);
    VII_N_ANNO         NUMBER(4);
    VII_N_PAIS         NUMBER(3);
    VII_N_PTDOC        NUMBER(2);
    VII_C_NDOC         CHAR(12);
    VII_N_INSTANCE_CRD NUMBER(10);
    VIO_N_SALDO_CRD    NUMBER(17, 2);
    VIO_V_MTO_SGR      VARCHAR(2);
    -- Variables para obtener los importes de un crédito por año.
    VII_N_MTO01 NUMBER(17, 2) := 0;
    VII_N_MTO02 NUMBER(17, 2) := 0;
    VII_N_MTO03 NUMBER(17, 2) := 0;
    VII_N_MTO04 NUMBER(17, 2) := 0;
    VII_N_MTO05 NUMBER(17, 2) := 0;
    VII_N_MTO06 NUMBER(17, 2) := 0;
    VII_N_MTO07 NUMBER(17, 2) := 0;
    VII_N_MTO08 NUMBER(17, 2) := 0;
    VII_N_MTO09 NUMBER(17, 2) := 0;
    VII_N_MTO10 NUMBER(17, 2) := 0;
    VII_N_MTO11 NUMBER(17, 2) := 0;
    VII_N_MTO12 NUMBER(17, 2) := 0;
  
    -- Variables para obtener los importes totales de todos los créditos por año.
    VII_N_SMTO01 NUMBER(17, 2) := 0;
    VII_N_SMTO02 NUMBER(17, 2) := 0;
    VII_N_SMTO03 NUMBER(17, 2) := 0;
    VII_N_SMTO04 NUMBER(17, 2) := 0;
    VII_N_SMTO05 NUMBER(17, 2) := 0;
    VII_N_SMTO06 NUMBER(17, 2) := 0;
    VII_N_SMTO07 NUMBER(17, 2) := 0;
    VII_N_SMTO08 NUMBER(17, 2) := 0;
    VII_N_SMTO09 NUMBER(17, 2) := 0;
    VII_N_SMTO10 NUMBER(17, 2) := 0;
    VII_N_SMTO11 NUMBER(17, 2) := 0;
    VII_N_SMTO12 NUMBER(17, 2) := 0;
  
    --Variables para detectar la fecha y hora del sistema
    fecha_reg DATE;
    hora_reg  VARCHAR2(8);
  
    --Nombre de mes
    nombre_mes VARCHAR2(20);
  
    -- Tipos de datos para las colecciones
    TYPE VII_N_ARRAY IS TABLE OF NUMBER; -- Tabla dimensional para los 12 meses
    TYPE VII_N_2D_ARRAY IS TABLE OF VII_N_ARRAY; -- Tabla bidimensional para combinar los meses con años (ventana de 5 años)
  
    -- Inicialización de las colecciones
    VII_N_SMTOXANNO VII_N_2D_ARRAY := VII_N_2D_ARRAY(); -- Inicializa la colección bidimensional
    VII_N_SMTO      VII_N_ARRAY := VII_N_ARRAY(); -- Inicializa la colección unidimensional
  
    -- Variables auxiliares
    VII_N_MAX_VALUE   NUMBER := 0;
    VII_N_MAX_ANNO    NUMBER := 0;
    VII_N_MAX_MES     NUMBER := 0;
    VII_N_CONT_ANNO   NUMBER := 5;
    VII_MONTO_CREDITO NUMBER(17, 2) := 0;
    CURSOR LISTA_CUENTAS(VCI_N_PAIS   IN NUMBER,
                         VCI_N_PETDOC IN NUMBER,
                         VCI_C_DOC    IN CHARACTER) IS
      SELECT *
        FROM FSR008
       WHERE PEPAIS = VCI_N_PAIS
         AND PETDOC = VCI_N_PETDOC
         AND PENDOC = VCI_C_DOC
         AND TTCOD = 1
         AND CTTFIR = 'T'; --OBTENGO TODAS LAS CUENTAS DONDE ES TITULAR
    CURSOR LISTA_CREDITOS(VCI_N_CUENTA IN NUMBER) IS
      SELECT PGCOD,
             AOMOD,
             AOSUC,
             AOMDA,
             AOPAP,
             AOCTA,
             AOOPER,
             AOSBOP,
             AOTOPE
        FROM fsd010
       WHERE PGCOD = 1
         AND AOMOD IN (SELECT MODULO
                         FROM FST111
                        WHERE DSCOD = 50
                          AND MODULO > 99
                          AND MODULO < 200)
         AND aocta IN (VCI_N_CUENTA); --OBTENER LA FECHA DEL ULTIMO DESEMBOLSO
  
    CURSOR SALDOS_CREDITO_X_ANNO(VCI_N_EMP  IN NUMBER,
                                 VCI_N_MOD  IN NUMBER,
                                 VCI_N_CTA  IN NUMBER,
                                 VCI_N_MDA  IN NUMBER,
                                 VCI_N_PAP  IN NUMBER,
                                 VCI_N_SUC  IN NUMBER,
                                 VCI_N_OPE  IN NUMBER,
                                 VCI_N_SBO  IN NUMBER,
                                 VCI_N_TOP  IN NUMBER,
                                 VCI_N_ANNO IN NUMBER) IS
      SELECT SUM(NVL(ABS(F.HASD01), 0)) ENERO,
             SUM(NVL(ABS(F.HASD02), 0)) FEBRERO,
             SUM(NVL(ABS(F.HASD03), 0)) MARZO,
             SUM(NVL(ABS(F.HASD04), 0)) ABRIL,
             SUM(NVL(ABS(F.HASD05), 0)) MAYO,
             SUM(NVL(ABS(F.HASD06), 0)) JUNIO,
             SUM(NVL(ABS(F.HASD07), 0)) JULIO,
             SUM(NVL(ABS(F.HASD08), 0)) AGOSTO,
             SUM(NVL(ABS(F.HASD09), 0)) SETIEMBRE,
             SUM(NVL(ABS(F.HASD10), 0)) OCTUBRE,
             SUM(NVL(ABS(F.HASD11), 0)) NOVIEMBRE,
             SUM(NVL(ABS(F.HASD12), 0)) DICIEMBRE
        FROM FSH014 F
       WHERE F.PGCOD = VCI_N_EMP
         AND F.HAMOD = VCI_N_MOD
         AND F.HACTA = VCI_N_CTA
         AND F.HAMDA = VCI_N_MDA
         AND F.HAPAP = VCI_N_PAP
         AND F.HASUC = VCI_N_SUC
         AND F.HAOPER = VCI_N_OPE
         AND F.HASBOP = VCI_N_SBO
         AND F.HATOPE = VCI_N_TOP
         AND F.HAANIO = VCI_N_ANNO;
  begin
    -- BEGIN  PRINCIPAL 
  
    --OBTENER LA CUENTA
    BEGIN
      select xwfcuenta
        INTO VII_N_CTA
        from xwf700
       where xwfprcins = instancia --Se busca por la instancia
         and xwfcar3 = '1';
    EXCEPTION
      WHEN OTHERS THEN
        VEO_COD_ERROR := '0001';
        VEO_MSG_ERROR := 'NO SE ENCONTRÓ LA INSTANCIA';
    END;
    --OBTENER LA CLAVE DEL DOCUMENTO
    BEGIN
      SELECT PEPAIS, PETDOC, PENDOC
        INTO VII_N_PAIS, VII_N_PTDOC, VII_C_NDOC
        from fsr008
       where ctnro = VII_N_CTA
         and ttcod = 1
         anD cttfir = 'T'; --OBTENGO LA CLVE DEL DOCUMENTO.  
    EXCEPTION
      WHEN OTHERS THEN
        VEO_COD_ERROR := '0002';
        VEO_MSG_ERROR := 'NO SE ENCONTRO CLAVE DE DOCUMENTO';
    END;
    BEGIN
      --OBTENER EL AÑO ACTUAL DEL SISTEMA
      BEGIN
        SELECT EXTRACT(YEAR FROM PGFAPE)
          INTO VII_N_ANNO
          FROM FST017
         WHERE PGCOD = 1;
      EXCEPTION
        WHEN OTHERS THEN
          VEO_COD_ERROR := '0003';
          VEO_MSG_ERROR := 'ERROR AL OBTENER EL AÑO DEL SISTEMA';
      END;
      --RECORRER Y OBTENER LOS DATOS DE UN AÑO X AÑO.
      BEGIN
        FOR J IN 1 .. VII_N_CONT_ANNO LOOP
          begin
            --OBTENER TODOS LAS CUENTAS DEL CLIENTE
            FOR X IN LISTA_CUENTAS(VII_N_PAIS, VII_N_PTDOC, VII_C_NDOC) LOOP
              BEGIN
                --OBTENER TODOS LOS CREDITOS ASOCIADA A LA CUENTA 
                FOR Y IN LISTA_CREDITOS(X.CTNRO) LOOP
                  --DBMS_OUTPUT.PUT_LINE('CREDITO - - :'||Y.AOCTA||'-'||Y.AOOPER||'-'||Y.AOSBOP||'-'||Y.AOTOPE);
                  BEGIN
                    --OBTENER LA INSTANCIA DEL CREDITO ITERADO.
                    BEGIN
                      SELECT XWFPRCINS
                        INTO VII_N_INSTANCE_CRD
                        FROM XWF700 W
                       WHERE W.XWFEMPRESA = Y.PGCOD
                         AND W.XWFSUCURSAL = Y.AOSUC
                         AND W.XWFMODULO = Y.AOMOD
                         AND W.XWFMONEDA = Y.AOMDA
                         AND W.XWFPAPEL = Y.AOPAP
                         AND W.XWFCUENTA = Y.AOCTA
                         AND W.XWFOPERACION = Y.AOOPER
                         AND W.XWFSUBOPE = Y.AOSBOP
                         AND W.XWFTIPOPE = Y.AOTOPE
                         AND W.XWFCAR3 = '1';
                    EXCEPTION
                      WHEN OTHERS THEN
                        NULL;
                    END;
                    --VALIDAMOS SI ES MONTO SIN GARANTIA REAL,PARA CONSIDERAR EN LA SUMA.
                    sp_cr_corresponde_garantia(VII_N_INSTANCE_CRD,
                                               VIO_N_SALDO_CRD,
                                               VIO_V_MTO_SGR);
                    --SI TIENE GARANTIA NO REAL, SE SUMA AL SALDO CASO CONTRARIO NO SE INCLUYE.                           
                    IF VIO_V_MTO_SGR = 'S' THEN
                      --OBTENER LOS SALDOS DEL CREDITO.
                      FOR Z IN SALDOS_CREDITO_X_ANNO(Y.PGCOD, Y.AOMOD, Y.AOCTA, Y.AOMDA, Y.AOPAP, Y.AOSUC, Y.AOOPER, Y.AOSBOP, Y.AOTOPE, VII_N_ANNO - (J - 1)) LOOP
                        VII_N_MTO01 := Z.ENERO;
                        VII_N_MTO02 := Z.FEBRERO;
                        VII_N_MTO03 := Z.MARZO;
                        VII_N_MTO04 := Z.ABRIL;
                        VII_N_MTO05 := Z.MAYO;
                        VII_N_MTO06 := Z.JUNIO;
                        VII_N_MTO07 := Z.JULIO;
                        VII_N_MTO08 := Z.AGOSTO;
                        VII_N_MTO09 := Z.SETIEMBRE;
                        VII_N_MTO10 := Z.OCTUBRE;
                        VII_N_MTO11 := Z.NOVIEMBRE;
                        VII_N_MTO12 := Z.DICIEMBRE;
                      END LOOP;
                      --SUMAR A LA DEL RESTO DE CREDITOS A ITERAR DEL MISMO AÑO
                      VII_N_SMTO01 := NVL(VII_N_SMTO01, 0) +
                                      NVL(VII_N_MTO01, 0);
                      VII_N_SMTO02 := NVL(VII_N_SMTO02, 0) +
                                      NVL(VII_N_MTO02, 0);
                      VII_N_SMTO03 := NVL(VII_N_SMTO03, 0) +
                                      NVL(VII_N_MTO03, 0);
                      VII_N_SMTO04 := NVL(VII_N_SMTO04, 0) +
                                      NVL(VII_N_MTO04, 0);
                      VII_N_SMTO05 := NVL(VII_N_SMTO05, 0) +
                                      NVL(VII_N_MTO05, 0);
                      VII_N_SMTO06 := NVL(VII_N_SMTO06, 0) +
                                      NVL(VII_N_MTO06, 0);
                      VII_N_SMTO07 := NVL(VII_N_SMTO07, 0) +
                                      NVL(VII_N_MTO07, 0);
                      VII_N_SMTO08 := NVL(VII_N_SMTO08, 0) +
                                      NVL(VII_N_MTO08, 0);
                      VII_N_SMTO09 := NVL(VII_N_SMTO09, 0) +
                                      NVL(VII_N_MTO09, 0);
                      VII_N_SMTO10 := NVL(VII_N_SMTO10, 0) +
                                      NVL(VII_N_MTO10, 0);
                      VII_N_SMTO11 := NVL(VII_N_SMTO11, 0) +
                                      NVL(VII_N_MTO11, 0);
                      VII_N_SMTO12 := NVL(VII_N_SMTO12, 0) +
                                      NVL(VII_N_MTO12, 0);
                    END IF;
                  EXCEPTION
                    WHEN OTHERS THEN
                      NULL;
                  END;
                END LOOP; --fin de creditos
              EXCEPTION
                WHEN OTHERS THEN
                  NULL;
              END;
            END LOOP; -- fin de cuentas
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
          --FINALIZACION DE ITERACIÓN DE TODOS LOS CREDITOS. DEL AÑO ITERADO
          -- Después de procesar los créditos, almacenamos en la colección
          VII_N_SMTO := VII_N_ARRAY(VII_N_SMTO01,
                                    VII_N_SMTO02,
                                    VII_N_SMTO03,
                                    VII_N_SMTO04,
                                    VII_N_SMTO05,
                                    VII_N_SMTO06,
                                    VII_N_SMTO07,
                                    VII_N_SMTO08,
                                    VII_N_SMTO09,
                                    VII_N_SMTO10,
                                    VII_N_SMTO11,
                                    VII_N_SMTO12);
          --ALMACENAR los datos en la colección BIDIMENSIONAL.
          VII_N_SMTOXANNO.EXTEND; -- Extendemos la colección para permitir un nuevo elemento
          VII_N_SMTOXANNO(VII_N_SMTOXANNO.COUNT) := VII_N_SMTO; ---Agregamos los registros.
        
          --REINICIAMOS LOS VALORES
          -- Reiniciamos las variables para el siguiente año
          VII_N_SMTO01 := 0;
          VII_N_SMTO02 := 0;
          VII_N_SMTO03 := 0;
          VII_N_SMTO04 := 0;
          VII_N_SMTO05 := 0;
          VII_N_SMTO06 := 0;
          VII_N_SMTO07 := 0;
          VII_N_SMTO08 := 0;
          VII_N_SMTO09 := 0;
          VII_N_SMTO10 := 0;
          VII_N_SMTO11 := 0;
          VII_N_SMTO12 := 0;
        END LOOP; --fin de años.   
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    
      BEGIN
        --Ahora validamos el valor máximo en la colección bidimensional que sera el Monto Máximo.
        FOR i IN 1 .. VII_N_SMTOXANNO.COUNT LOOP
          FOR j IN 1 .. VII_N_SMTOXANNO(i).COUNT LOOP
            IF VII_N_SMTOXANNO(i) (j) > VII_N_MAX_VALUE THEN
              VII_N_MAX_VALUE := VII_N_SMTOXANNO(i) (j);
              VII_N_MAX_ANNO  := i;
              VII_N_MAX_MES   := j;
            END IF;
          END LOOP;
        END LOOP;
      
        --DBMS_OUTPUT.PUT_LINE('Monto Maximo encontrado en: -------------------------------');
        --DBMS_OUTPUT.PUT_LINE('Año ' || VII_N_MAX_ANNO || ', Mes ' ||
        --                    VII_N_MAX_MES || ': ' || VII_N_MAX_VALUE);
        --DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
      
        -- Obtengo el nombre del Maximo Mes  
        nombre_mes := TO_CHAR(TO_DATE(VII_N_MAX_MES, 'MM'), 'MONTH');
      
        -- Obtengo la fecha
        fecha_reg := TRUNC(SYSDATE);
        hora_reg  := TO_CHAR(SYSDATE, 'HH24:MI:SS');
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    
      --TABLA 1
      Begin
        insert into AQPD701
          (AQPD701INS,
           AQPD701PAIS,
           AQPD701TDOC,
           AQPD701NDOC,
           AQPD701FECHC,
           AQPD701HORAC,
           AQPD701ANNOIM,
           AQPD701MESIM,
           AQPD701IMPMX,
           AQPD701USER)
        VALUES
          (instancia,
           VII_N_PAIS,
           VII_N_PTDOC,
           VII_C_NDOC,
           fecha_reg,
           hora_reg,
           VII_N_MAX_ANNO,
           nombre_mes,
           VII_N_MAX_VALUE,
           usuario);
        commit;
        --VEO_N_MAX_VALUE := VII_N_MAX_VALUE;
        VEO_COD_ERROR := '0000';
        VEO_MSG_ERROR := 'OK';
      exception
        when others then
          --VEO_N_MAX_VALUE := 0;
          VEO_COD_ERROR := '0010';
          VEO_MSG_ERROR := 'ERROR AL INGRESAR LOS DATOS TABLA AQPD701';
      End;
    
      -- Opcional: imprimir los elementos para verificar
      FOR i IN 1 .. VII_N_SMTOXANNO.COUNT LOOP
        -- FOR j IN 1 .. VII_N_SMTOXANNO(i).COUNT LOOP
        --   --DBMS_OUTPUT.PUT_LINE('Año ' || i || ', Mes ' || j || ': ' ||
        --   --                     VII_N_SMTOXANNO(i) (j));
        -- END LOOP;
        --AQUI TABLA2
        begin
          insert into aqpd702
            (aqpd702ins,
             aqpd702pais,
             aqpd702tdoc,
             aqpd702ndoc,
             aqpd702user,
             aqpd702fechc,
             aqpd702horac,
             aqpd702annoc,
             aqpd702mes1,
             aqpd702mes2,
             aqpd702mes3,
             aqpd702mes4,
             aqpd702mes5,
             aqpd702mes6,
             aqpd702mes7,
             aqpd702mes8,
             aqpd702mes9,
             aqpd702mes10,
             aqpd702mes11,
             aqpd702mes12)
          values
            (instancia,
             VII_N_PAIS,
             VII_N_PTDOC,
             VII_C_NDOC,
             usuario,
             fecha_reg,
             hora_reg,
             VII_N_MAX_ANNO,
             VII_N_SMTOXANNO(i) (1),
             VII_N_SMTOXANNO(i) (2),
             VII_N_SMTOXANNO(i) (3),
             VII_N_SMTOXANNO(i) (4),
             VII_N_SMTOXANNO(i) (5),
             VII_N_SMTOXANNO(i) (6),
             VII_N_SMTOXANNO(i) (7),
             VII_N_SMTOXANNO(i) (8),
             VII_N_SMTOXANNO(i) (9),
             VII_N_SMTOXANNO(i) (10),
             VII_N_SMTOXANNO(i) (11),
             VII_N_SMTOXANNO(i) (12));
          commit;
          --VEO_N_MAX_VALUE := VII_N_MAX_VALUE;
          VEO_COD_ERROR := '0000';
          VEO_MSG_ERROR := 'OK';
        exception
          when others then
            --VEO_N_MAX_VALUE := 0;
            VEO_COD_ERROR := '0011';
            VEO_MSG_ERROR := 'ERROR AL INGRESAR LOS DATOS TABLA AQPD702';
            --DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 1, 250));
        end;
        --insert into( anno -> i, VII_N_SMTOXANNO(i) (1));,VII_N_SMTOXANNO(i) (2));)
      END LOOP;
    
      --ADICIONAL NECESARIO, LOG DE INFORMACIÓN.
      --CREAR UNA TABLA QUE ALMACENE LA INFORMACIÓN DE LOS CREDITOS CON SUS IMPORTES DEL MES QUE SE CONSIDERO PARA EL IMPORTE TOTAL DEL MES Y AÑO SELECCIONADO.
      ----CAMPOS QUE DEBE TENER: INSTANCIA CONSULTADA,PAIS DEL CLIENTE, TIPO DE DOCUMENTO DEL CLIENTE, DOCUMENTO DEL CLIENTE,
      ----FECHA DE CONSULTA (FECHA Y HORA), AÑO DEL IMPORTE MAXIMO, MES DEL IMPORTE MAXIMO, IMPORTE MAXIMO,
      ----USUARIO QUE CONSULTO (ENVIADO POR PARAMETRO), 
      --CREAR OTRA TABLA QUE ALMACENE LA MATRIZ QUE CONTIENE LOS AÑOS Y MONTOS POR MES, 
      ----CAMPOS QUE DEBE TENER: INSTANCIA CONSULTADA,PAIS DEL CLIENTE, TIPO DE DOCUMENTO DEL CLIENTE, DOCUMENTO DEL CLIENTE,
      ----USUARIO QUE CONSULTO(ENVIADO POR PARAMETRO), 
      ----FECHA DE CONSULTA (FECHA Y HORA),AÑO CONSULTA(I) <- EUIVALENCIA 2024..., MES 1, MES 2, MES 3, MES 4, MES 5, MES 6, MES 7, MES 8, MES 9, MES 10, MES 11, MES 12
    
      --CREAR OTRA TABLA QUE ALMACENE LOS CREDITOS QUE ESTAN INVOLUCRADOS CON EL MONTO MAXIMO, 
      --AYUDA ADICIONAL USADA.
      BEGIN
        --OBTENER TODOS LAS CUENTAS DEL CLIENTE
        FOR X IN LISTA_CUENTAS(VII_N_PAIS, VII_N_PTDOC, VII_C_NDOC) LOOP
          BEGIN
            --OBTENER TODOS LOS CREDITOS ASOCIADA A LA CUENTA 
            FOR Y IN LISTA_CREDITOS(X.CTNRO) LOOP
              --DBMS_OUTPUT.PUT_LINE('CREDITO - - :'||Y.AOCTA||'-'||Y.AOOPER||'-'||Y.AOSBOP||'-'||Y.AOTOPE);
              BEGIN
                --OBTENER LA INSTANCIA DEL CREDITO ITERADO.
                BEGIN
                  SELECT XWFPRCINS
                    INTO VII_N_INSTANCE_CRD
                    FROM XWF700 W
                   WHERE W.XWFEMPRESA = Y.PGCOD
                     AND W.XWFSUCURSAL = Y.AOSUC
                     AND W.XWFMODULO = Y.AOMOD
                     AND W.XWFMONEDA = Y.AOMDA
                     AND W.XWFPAPEL = Y.AOPAP
                     AND W.XWFCUENTA = Y.AOCTA
                     AND W.XWFOPERACION = Y.AOOPER
                     AND W.XWFSUBOPE = Y.AOSBOP
                     AND W.XWFTIPOPE = Y.AOTOPE;
                EXCEPTION
                  WHEN OTHERS THEN
                    NULL;
                END;
                --VALIDAMOS SI ES MONTO SIN GARANTIA REAL,PARA CONSIDERAR EN LA SUMA.
                sp_cr_corresponde_garantia(VII_N_INSTANCE_CRD,
                                           VIO_N_SALDO_CRD,
                                           VIO_V_MTO_SGR);
                --SI TIENE GARANTIA NO REAL, SE SUMA AL SALDO CASO CONTRARIO NO SE INCLUYE.                           
                IF VIO_V_MTO_SGR = 'S' THEN
                  --REALIZAR LA CONVERSION DEL VII_N_MAX_ANNO A AÑÑO CORRESPONDIENTE SALE 1 CONVERTIR A 2024
                  --OBTENER LOS SALDOS DEL CREDITO.
                  FOR Z IN SALDOS_CREDITO_X_ANNO(Y.PGCOD, Y.AOMOD, Y.AOCTA, Y.AOMDA, Y.AOPAP, Y.AOSUC, Y.AOOPER, Y.AOSBOP, Y.AOTOPE, 2024) LOOP
                    --ALMACENAR EN TABLA LOS CREDITOS QUE CUMPLEN CON LOS SALDOS DEL MES Y AÑO MAXIMO
                    IF VII_N_MAX_MES = 1 THEN
                      --GUARDAR EN UNA VARIABLE EL MONTO DEL MES QUE CORRESPONDE
                      --MONTO_CREDITO    
                      VII_MONTO_CREDITO := Z.ENERO;
                    END IF;
                    IF VII_N_MAX_MES = 2 THEN
                      --GUARDAR EN UNA VARIABLE EL MONTO DEL MES QUE CORRESPONDE
                      --MONTO_CREDITO    
                      VII_MONTO_CREDITO := Z.FEBRERO;
                    END IF;
                    -- REPLICAR PARA LOS DEMAS MESES
                  
                    --AQUI GUARDAR LOS DATOS
                    --DATOS A GUARDAR
                    -- INSTANCIA,FECHA DE CONSULTA, HORA DE CONSULTA,USUARIO DE CONSULTA,
                    -- Y.PGCOD,Y.AOMOD,Y.AOCTA,Y.AOMDA,Y.AOPAP,Y.AOSUC,Y.AOOPER,Y.AOSBOP,Y.AOTOPE,AÑO, MES,
                    -- MONTO_CREDITO 
                    /*   DBMS_OUTPUT.PUT_LINE('Y.PGCOD ' || Y.PGCOD ||
                    '- Y.AOMOD ' || Y.AOMOD ||
                    '- Y.AOCTA ' || Y.AOCTA ||
                    '- Y.AOMDA ' || Y.AOMDA ||
                    '- Y.AOPAP ' || Y.AOPAP ||
                    '- Y.AOSUC ' || Y.AOSUC ||
                    '- Y.AOOPER ' || Y.AOOPER ||
                    '- Y.AOSBOP ' || Y.AOSBOP ||
                    '- Y.AOTOPE ' || Y.AOTOPE ||
                    '- AÑO ' || VII_N_MAX_ANNO ||
                    '- MES ' || VII_N_MAX_MES ||
                    '- MONTO_CREDITO ' ||
                    VII_MONTO_CREDITO); */
                  
                    begin
                      insert into aqpd751
                        (AQPD751inst,
                         AQPD751fec,
                         AQPD751hor,
                         AQPD751pais,
                         AQPD751tdoc,
                         AQPD751ndoc,
                         AQPD751cod,
                         AQPD751aomod,
                         AQPD751aocta,
                         AQPD751omda,
                         AQPD751opap,
                         AQPD751aosuc,
                         AQPD751aooper,
                         AQPD751aosbop,
                         AQPD751aotope,
                         AQPD751anno,
                         AQPD751mes,
                         AQPD751monto)
                      values
                        (instancia,
                         fecha_reg,
                         hora_reg,
                         VII_N_PAIS,
                         VII_N_PTDOC,
                         VII_C_NDOC,
                         Y.PGCOD,
                         Y.AOMOD,
                         Y.AOCTA,
                         Y.AOMDA,
                         Y.AOPAP,
                         Y.AOSUC,
                         Y.AOOPER,
                         Y.AOSBOP,
                         Y.AOTOPE,
                         VII_N_MAX_ANNO,
                         nombre_mes,
                         VII_MONTO_CREDITO);
                      commit;
                      --VEO_N_MAX_VALUE := VII_N_MAX_VALUE;
                      VEO_COD_ERROR := '0000';
                      VEO_MSG_ERROR := 'OK';
                    exception
                      when others then
                        VEO_COD_ERROR := '0013';
                        VEO_MSG_ERROR := 'ERROR AL INGRESAR LOS DATOS TABLA AQPD751';
                    end;
                  END LOOP; --FIN SALDOS
                END IF;
              EXCEPTION
                WHEN OTHERS THEN
                  NULL;
              END;
            END LOOP; --FIN CREDITOS
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
        END LOOP; --FIN CUENTAS 
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END; --FIN DE AYUDA ADICIONAL USADA.
    
    END; --FIN DEL BEGIN
    VEO_N_MAX_VALUE := VII_N_MAX_VALUE;
  
  end sp_cr_obtener_monto_max_sgr;

end PQ_CR_SEGMENTACION_ANTER_CRED;
/

