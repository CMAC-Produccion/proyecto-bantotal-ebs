create or replace package PQ_CR_VALIDAR_RNG_RPSC is


/* ************************************************************************************************************
     -- Nombre                     : PQ_CR_VALIDAR_RNG_RPSC
     -- Sistema                    : BANTOTAL
     -- Módulo                     : Activas
     -- Descripción                : Paquete para validar las reglas de negocio en Reprogramados sin capitalización. 
     -- Versión                    : 1.0
     -- Fecha de Creación          : 17/09/2024
     -- Autor de Creación          : HSUAREZ
     -- Estado                     : Activo
     -- Acceso                     : Público  
     -- Fecha de Modificacion      : 02/05/2025
     -- Autor de Modificacion      : CALARCONAP
     -- Descripcion Modificacion   : Se agrega reglas para normalizacion
     -- Fecha de Modificacion      : 28/10/2025
     -- Autor de Modificacion      : HSUAREZ
     -- Descripcion Modificacion   : Se agrega reglas para bloque c. excepcion	 
     -- Fecha de Modificacion      : 21/11/2025
     -- Autor de Modificacion      : RCASTRO
     -- Descripcion Modificacion   : Se agrega mensaje en caso espcial de aprob. admision y seguim.	      
 * *************************************************************************************************************/
  PROCEDURE SP_VALIDAR_RNG_GENERAL(
                                     VE_INSTANCIA IN NUMBER,
                                     VE_NRO IN NUMBER,
                                     VE_TIPO_REPROG IN NUMBER,
                                     VE_USUARIO IN VARCHAR,
                                     VO_MSG OUT VARCHAR
                                    );
 
  PROCEDURE SP_VALIDAR_REGLA_RPSC(
                                    VE_INSTANCIA IN NUMBER,
                                    VE_NRO IN NUMBER,
                                    VE_TIPO_REPROG IN NUMBER,
                                    VE_MEMO IN VARCHAR,
                                    VE_NOM_REGLA IN VARCHAR,                                    
                                    VE_USUARIO IN VARCHAR,
                                    VO_MSG OUT VARCHAR 
                                 );                                 
  PROCEDURE SP_BUSCAR_REGLA(
                            VE_MEMO IN VARCHAR,
                            VE_NOM_REGLA IN VARCHAR,
                            --
                            VO_SQL OUT VARCHAR,
                            VO_NRO_PARAMETROS OUT NUMBER,
                            VO_NOMBRE_VAR OUT VARCHAR,
                            VO_NUM_REGLA OUT NUMBER,
                            VO_MSG_REGLA OUT VARCHAR
                           ); 
  PROCEDURE SP_OBTENER_PARAMETROS(
                                    VE_PACKAGE       IN VARCHAR,
                                    VE_PROCEDIMIENTO IN VARCHAR,
                                    VE_CODIGO_PRC    IN NUMBER                                                                       
                                 );
                                 
  PROCEDURE SP_VALIDAR_RNG_CAJA(
                                  VE_INSTANCIA IN NUMBER,
                                  VE_NRO IN NUMBER,
                                  VE_TIPO_REPROG IN NUMBER,
                                  VE_USUARIO IN VARCHAR,
                                  VO_MSG OUT VARCHAR 
                               ); 
  PROCEDURE SP_REGISTRAR_AUTORIZANTE(--DATOS GENERALES DE LA REGLA
                                     VE_COD_REGLA IN NUMBER,
                                     VE_NOM_VAR IN VARCHAR,
                                     VE_MSG_REG IN VARCHAR,
                                     VE_TIPORPG IN NUMBER,
                                     --DATOS DEL CREDITO Y SOLICITANTE
                                     VE_INSTANCIA IN NUMBER,
                                     VE_USUARIO IN VARCHAR,
                                     VO_MENSAJE_ESP  OUT VARCHAR2,
                                     VO_COD_ERROR OUT VARCHAR,
                                     VO_MSG_ERROR OUT VARCHAR
                                 );
end PQ_CR_VALIDAR_RNG_RPSC;
/
create or replace package body PQ_CR_VALIDAR_RNG_RPSC is

  /* ************************************************************************************************************
      -- Nombre                     : PQ_CR_VALIDAR_RNG_RPSC
      -- Sistema                    : BANTOTAL
      -- Módulo                     : Activas
      -- Descripción                : Paquete para validar las reglas de negocio en Reprogramados sin capitalización. 
      -- Versión                    : 1.0
      -- Fecha de Creación          : 17/09/2024
      -- Autor de Creación          : HSUAREZ
      -- Estado                     : Activo
      -- Acceso                     : Público  
      -- Fecha de Modificacion      : 02/05/2025
      -- Autor de Modificacion      : CALARCONAP
      -- Descripcion Modificacion   : Se agrega reglas para normalizacion
  * *************************************************************************************************************/
  PROCEDURE SP_VALIDAR_RNG_GENERAL(VE_INSTANCIA   IN NUMBER,
                                   VE_NRO         IN NUMBER,
                                   VE_TIPO_REPROG IN NUMBER,
                                   VE_USUARIO     IN VARCHAR,
                                   VO_MSG         OUT VARCHAR) IS
  
    CURSOR LISTADO_REGLAS_MEMO_17_CASO01 IS -- REGLAS PARA CREDITOS ENTRE DIC2022 AL JUN2023
      SELECT *
        FROM AQPC780
       WHERE AQPC780MEMO = 'MEMO17-2024'
         AND AQPC780TPREPR = 10
         AND AQPC780GRPREG = 'CREDITOS ENTRE DIC2022 AL JUN2023';
  
    CURSOR LISTADO_REGLAS_MEMO_17_CASO02 IS -- REGLAS PARA CREDITOS ENTRE DIC2022 AL JUN2023
      SELECT *
        FROM AQPC780
       WHERE AQPC780MEMO = 'MEMO17-2024'
         AND AQPC780TPREPR = 10
         AND AQPC780GRPREG = 'CREDITOS FUERA DE DIC2022 AL JUN2023';
  
    CURSOR LISTADO_REGLAS_CAMBIO_FECHA(VCI_N_INSTANCE IN NUMBER, VCI_N_TPREPR IN NUMBER ) IS
      SELECT A.*
        FROM AQPC780 A, JAQA400 J
       WHERE A.AQPC780MEMO IN ('CAMBIO_FECHA','NORMALIZACION','DESASTRE_NATURAL','GENERAL')
         AND A.AQPC780TPREPR = VCI_N_TPREPR --10(Cambio fecha), 11(Normalizacion), 12(Desastre Natural)
         AND A.AQPC780GRPREG IN ('CAMBIO_FECHA','NORMALIZACION','DESASTRE_NATURAL','GENERAL')
         AND A.AQPC780NUMRGL = J.JAQA400AN1
         AND A.AQPC780ESTADO = 'S'
         AND J.JAQA400AI1 = VCI_N_INSTANCE
         AND J.JAQA400FEC = (SELECT PGFAPE FROM FST017 WHERE PGCOD = 1)
      UNION ALL   
      SELECT A.*
        FROM AQPC780 A, JAQA400 J
       WHERE A.AQPC780MEMO IN ('GENERAL')
         --AND A.AQPC780TPREPR = VCI_N_TPREPR --10(Cambio fecha) o 11(Normalizacion)
         AND A.AQPC780GRPREG IN ('GENERAL')
         AND A.AQPC780ESTADO = 'S'
         AND J.JAQA400AI1 = VCI_N_INSTANCE
         AND J.JAQA400FEC = (SELECT PGFAPE FROM FST017 WHERE PGCOD = 1)  
         ;        
  
    VE_MSG VARCHAR(300);
    VE_USERING VARCHAR2(10);
    VIO_COD_ERROR VARCHAR2(5):='';
    VIO_MSG_ERROR VARCHAR2(300):='';
    VO_MSG_REG_ESPC VARCHAR2(300):='';
    
  BEGIN
    --REGLAS PARA MEMO 17
    ----REGLAS PARA CREDITOS ENTRE DIC2022 AL JUN2023
    /*
    FOR X IN LISTADO_REGLAS_MEMO_17_CASO01 LOOP
       BEGIN      
            PQ_CR_VALIDAR_RNG_RPSC.SP_VALIDAR_REGLA_RPSC(
                                                         VE_INSTANCIA,VE_NRO,VE_TIPO_REPROG,X.AQPC780MEMO,X.AQPC780NOMRGL,VE_USUARIO,VE_MSG 
                                                        );
            ----OBTENER LOS MENSAJES BLOQUEANTE EN CASO HUBIERA Y ALMACENARLOS EN LA VARIABLE GENERAL.
            IF LENGTH(TRIM(VE_MSG)) > 0   AND
                   LENGTH(TRIM(VE_MSG)) < 800 THEN
                   VO_MSG := VO_MSG || ';' || VE_MSG;
                 ELSE
                   VO_MSG := VE_MSG;
            END IF;                 
       EXCEPTION
         WHEN OTHERS THEN
           NULL;
       END;              
    END LOOP;   
    ----REGLAS PARA CREDITOS FUERA DEL RANGO ENTRE DIC2022 AL JUN2023
    FOR Y IN LISTADO_REGLAS_MEMO_17_CASO01 LOOP
       BEGIN      
            PQ_CR_VALIDAR_RNG_RPSC.SP_VALIDAR_REGLA_RPSC(
                                         VE_INSTANCIA,VE_NRO,VE_TIPO_REPROG,Y.AQPC780MEMO,Y.AQPC780NOMRGL,VE_USUARIO,VE_MSG 
                                       );
            ----OBTENER LOS MENSAJES BLOQUEANTE EN CASO HUBIERA Y ALMACENARLOS EN LA VARIABLE GENERAL.
            IF LENGTH(TRIM(VE_MSG)) > 0   AND
                   LENGTH(TRIM(VE_MSG)) < 800 THEN
                   VO_MSG := VO_MSG || ';' || VE_MSG;
                 ELSE
                   VO_MSG := VE_MSG;
            END IF;                 
       EXCEPTION
         WHEN OTHERS THEN
           NULL;
       END;              
    END LOOP;
    */
    -----REGLAS DE CAMBIO DE FECHA REPROGRAMADOS SIN CRM.  
    VE_USERING := TRIM(VE_USUARIO);        
    BEGIN
      DELETE FROM aqpb955 A WHERE (A.AQPB955USR = rpad(VE_USERING, 10, ' ') or A.AQPB955USR = VE_USERING);
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    
    FOR Y IN LISTADO_REGLAS_CAMBIO_FECHA(VE_INSTANCIA, VE_TIPO_REPROG) LOOP
      BEGIN
        PQ_CR_VALIDAR_RNG_RPSC.SP_VALIDAR_REGLA_RPSC(VE_INSTANCIA,
                                                     VE_NRO,
                                                     VE_TIPO_REPROG,
                                                     Y.AQPC780MEMO,
                                                     Y.AQPC780NOMRGL,
                                                     VE_USUARIO,
                                                     VE_MSG);
        ----OBTENER LOS MENSAJES BLOQUEANTE EN CASO HUBIERA Y ALMACENARLOS EN LA VARIABLE GENERAL.
        If LENGTH(TRIM(VE_MSG)) > 0 THEN
         --24/10/2025
         PQ_CR_VALIDAR_RNG_RPSC.SP_REGISTRAR_AUTORIZANTE(--DATOS GENERALES DE LA REGLA
                                                         Y.AQPC780CORR,
                                                         Y.AQPC780NOMVAR,
                                                         Y.AQPC780MGBLOQ,
                                                         Y.AQPC780TPREPR,
                                                         --DATOS DEL CREDITO Y SOLICITANTE
                                                         VE_INSTANCIA,
                                                         VE_USUARIO,
                                                         VO_MSG_REG_ESPC, 
                                                         VIO_COD_ERROR,
                                                         VIO_MSG_ERROR
                                                        );
         --        
          IF TRIM(VO_MSG_REG_ESPC) IS NOT NULL AND  LENGTH(TRIM(VO_MSG_REG_ESPC))  > 0 THEN
             VE_MSG := VO_MSG_REG_ESPC;
          END IF;
          
          IF LENGTH(TRIM(VO_MSG)) > 0 AND LENGTH(TRIM(VO_MSG)) < 800 THEN
            VO_MSG := VO_MSG || ';' || VE_MSG;
          ELSE
            VO_MSG := VE_MSG;
          END IF;                           
        END IF;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END SP_VALIDAR_RNG_GENERAL;

  PROCEDURE SP_VALIDAR_REGLA_RPSC(VE_INSTANCIA   IN NUMBER,
                                  VE_NRO         IN NUMBER,
                                  VE_TIPO_REPROG IN NUMBER,
                                  VE_MEMO        IN VARCHAR,
                                  VE_NOM_REGLA   IN VARCHAR,
                                  VE_USUARIO     IN VARCHAR,
                                  VO_MSG         OUT VARCHAR) IS
    VO_SQL                VARCHAR(500);
    VO_NRO_PARAMETROS     NUMBER(3);
    VO_NOMBRE_VAR         VARCHAR(40);
    VO_NUM_REGLA          NUMBER(5);
    VI_NUM_REGLA          NUMBER(5);
    VO_MSG_REGLA          VARCHAR(300);
    VI_MSG_REGLA          VARCHAR(300);
    VE_MENSAJE            VARCHAR(300);
    VO_RPTA_DESACTIVA_REG VARCHAR(10);
    VO_EXCEPCION          VARCHAR(10);
    VI_SQL                VARCHAR(500);
    VI_NOMBRE_VAR         VARCHAR(40);
    VI_VALOR_VAR          VARCHAR(20);
    VI_COD_ERROR          VARCHAR(5);
    VI_VALOR_MSG          VARCHAR(150);
  BEGIN
    VO_MSG := '';
    --ENCONTRAR REGLA Y OBTENER LOS DATOS PARA EJECUTAR VALIDACIÓN
    BEGIN
      PQ_CR_VALIDAR_RNG_RPSC.SP_BUSCAR_REGLA(VE_MEMO,
                                             VE_NOM_REGLA,
                                             --
                                             VO_SQL,
                                             VO_NRO_PARAMETROS,
                                             VO_NOMBRE_VAR,
                                             VO_NUM_REGLA,
                                             VO_MSG_REGLA);
      VI_NOMBRE_VAR := VO_NOMBRE_VAR;
      VI_NUM_REGLA  := VO_NUM_REGLA;
      VI_MSG_REGLA  := VO_MSG_REGLA;
    EXCEPTION
      WHEN OTHERS THEN
        NULL; --LOG DE QUE NO SE ENCONTRO LA REGLA.                                                                                               
    END;
    --
    DBMS_OUTPUT.put_line('SQL:' || VO_SQL);
    --VALIDAR SI EXISTE REGLA
    IF TRIM(VO_SQL) IS NOT NULL OR TRIM(VO_SQL) <> '' THEN
    
      --EJECUTAR PROCEDIMIENTO VALIDAR REGLA
      --VE_NOMBRE_VAR,VI_VALOR_VAR,VI_MSG_REGLA,
      --VALIDAR SI ESTA EXCEPTUADO
      BEGIN
        -- Construcción de la sentencia SQL dinámica
        VI_SQL := VO_SQL; --'BEGIN TUPA_PROCEDIMIENTO(:1, :2); END;';
        -- Ejecución del procedimiento almacenado utilizando EXECUTE IMMEDIATE
        EXECUTE IMMEDIATE VI_SQL
          USING IN VE_INSTANCIA, IN VE_USUARIO, OUT VI_VALOR_VAR, OUT VI_COD_ERROR, OUT VI_VALOR_MSG;
      
        -- Mostrar o hacer algo con los resultados
        DBMS_OUTPUT.PUT_LINE('Valor 1: ' || TO_CHAR(VE_INSTANCIA));
        DBMS_OUTPUT.PUT_LINE('Valor 2: ' || VE_USUARIO);
        DBMS_OUTPUT.PUT_LINE('Valor 3: ' || VI_VALOR_VAR);
        DBMS_OUTPUT.PUT_LINE('Valor 4: ' || VI_COD_ERROR);
        DBMS_OUTPUT.PUT_LINE('Valor 5: ' || VI_VALOR_MSG);
      EXCEPTION
        WHEN OTHERS THEN
          NULL; --LOG DE QUE ALGUN ERROR SE GENERO POR MALA CONSTRUCCIÓN DE LA REGLA.
          DBMS_OUTPUT.put_line(SUBSTR(SQLERRM, 1, 150));
      END;
      BEGIN
        PQ_CR_VALIDAR_RNG_REPROG.SP_REGLAS_LOGS_EXCEPTION(VE_NRO,
                                                          VE_INSTANCIA,
                                                          VI_NOMBRE_VAR, --'NRO_RPROG',
                                                          (VI_VALOR_VAR ||
                                                          VI_VALOR_MSG),
                                                          VI_NUM_REGLA,
                                                          VO_RPTA_DESACTIVA_REG,
                                                          VO_EXCEPCION);
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      IF VI_VALOR_VAR = 'N' or VO_RPTA_DESACTIVA_REG = 'S' or
         VO_EXCEPCION = 'S' THEN
        --VE_MENSAJE:= '';
        NULL;
      ELSE
        IF LENGTH(TRIM(VO_MSG)) > 0 AND LENGTH(TRIM(VO_MSG)) < 301 THEN
          VO_MSG := VO_MSG || ';' || VI_MSG_REGLA;
        ELSE
          VO_MSG := VI_MSG_REGLA;
        END IF;
      END IF;
    
    END IF;
  
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END SP_VALIDAR_REGLA_RPSC;

  PROCEDURE SP_BUSCAR_REGLA(VE_MEMO      IN VARCHAR,
                            VE_NOM_REGLA IN VARCHAR,
                            --
                            VO_SQL            OUT VARCHAR,
                            VO_NRO_PARAMETROS OUT NUMBER,
                            VO_NOMBRE_VAR     OUT VARCHAR,
                            VO_NUM_REGLA      OUT NUMBER,
                            VO_MSG_REGLA      OUT VARCHAR) IS
  BEGIN
    SELECT AQPC780CONSQL,
           AQPC780NUMPAR,
           AQPC780NOMVAR,
           AQPC780NUMRGL,
           AQPC780MGBLOQ
      INTO VO_SQL,
           VO_NRO_PARAMETROS,
           VO_NOMBRE_VAR,
           VO_NUM_REGLA,
           VO_MSG_REGLA
      FROM AQPC780
     WHERE AQPC780MEMO = VE_MEMO
       AND AQPC780NOMRGL = VE_NOM_REGLA
       AND AQPC780ESTADO = 'S';
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('ERR-002' || '-' || VE_MEMO || '-' || VE_NOM_REGLA);
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
    
  end SP_BUSCAR_REGLA;

  PROCEDURE SP_OBTENER_PARAMETROS(VE_PACKAGE       IN VARCHAR,
                                  VE_PROCEDIMIENTO IN VARCHAR,
                                  VE_CODIGO_PRC    IN NUMBER) IS
    -- Declaración de variables generales
    v_sql            VARCHAR2(1000);
    v_parameter_name VARCHAR2(30);
    v_data_type      VARCHAR2(30);
    v_parameter_mode VARCHAR2(10);
  
    --borrar esto
    -- Variables para el primer procedimiento
  
    v_INSTANCIA1 NUMBER := 123; -- Reemplazar con el valor real
    v_FLAG       VARCHAR2(50);
    v_CODMSG     VARCHAR2(50);
    v_DESMSG     VARCHAR2(255);
    -- Variables para el segundo procedimiento
    v_procedure_name2 VARCHAR2(50) := 'SP_VALIDAR_LISTA_BI';
    v_VE_INSTANCIA    NUMBER := 456; -- Reemplazar con el valor real
    --hasta aca se borra 
    -- Tabla de asociación entre nombres de parámetros y valores
    TYPE param_table IS TABLE OF VARCHAR2(4000) INDEX BY VARCHAR2(30);
    v_parameters2 param_table;
  BEGIN
    -- Construir la sentencia SQL para el segundo procedimiento
    v_sql := 'BEGIN ' || v_procedure_name2 || '(';
  
    -- Obtener información sobre los parámetros del segundo procedimiento
    FOR param IN (SELECT argument_name, data_type, in_out
                    FROM all_arguments
                   WHERE object_name = UPPER(VE_PROCEDIMIENTO)
                     AND PACKAGE_NAME = VE_PACKAGE
                   ORDER BY position) LOOP
      v_parameter_name := param.argument_name;
      v_data_type      := param.data_type;
      v_parameter_mode := param.in_out;
    
      v_sql := v_sql || v_parameter_name || ' => :' || v_parameter_name || ', ';
    
      -- Inicializar las variables de salida
      IF v_parameter_mode = 'O' THEN
        IF v_data_type = 'V' THEN
          v_parameters2(v_parameter_name) := NULL;
        ELSIF v_data_type = 'N' THEN
          v_parameters2(v_parameter_name) := NULL;
        END IF;
      END IF;
    END LOOP;
  
    v_sql := RTRIM(v_sql, ', ') || '); END;';
  
    -- Ejecutar la sentencia SQL dinámicamente
    --EXECUTE IMMEDIATE v_sql USING v_VE_INSTANCIA, v_parameters2;
  
    -- Mostrar o hacer algo con los resultados del segundo procedimiento
    DBMS_OUTPUT.PUT_LINE('Resultado del segundo procedimiento:');
  
    FOR i IN 1 .. v_parameters2.COUNT LOOP
      DBMS_OUTPUT.PUT_LINE(v_parameters2(i));
    END LOOP;
    v_parameters2.DELETE;
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
  END SP_OBTENER_PARAMETROS;

  PROCEDURE SP_REGISTRAR_AUTORIZANTE(--DATOS GENERALES DE LA REGLA
                                     VE_COD_REGLA IN NUMBER,
                                     VE_NOM_VAR IN VARCHAR,
                                     VE_MSG_REG IN VARCHAR,
                                     VE_TIPORPG IN NUMBER,
                                     --DATOS DEL CREDITO Y SOLICITANTE
                                     VE_INSTANCIA IN NUMBER,
                                     VE_USUARIO IN VARCHAR, 
                                     VO_MENSAJE_ESP  OUT VARCHAR2,                                    
                                     VO_COD_ERROR OUT VARCHAR,
                                     VO_MSG_ERROR OUT VARCHAR                                     
                                 )
  IS
  --VARIABLES
  VI_TMP_PERFIL VARCHAR2(20) :='';
  VI_TMP_CARGO  NUMBER(5)    :=0;
  VI_TMP_USER   VARCHAR2(10) :='';
  VI_NOM_VAR    VARCHAR2(20) :='';
  VI_MSG_REG    VARCHAR2(300):='';
  VII_CTA       NUMBER(9)    :=0;
  VII_OPE       NUMBER(9)    :=0;
  VII_CODPRO    NUMBER(5)    :=0;
  VII_CODMTDO   NUMBER(9)    :=0;
  VII_NOMMTDO   VARCHAR2(100):='';
  VIO_CODCARGO  NUMBER(5)    :='';
  VIO_PERFIL    VARCHAR2(20) :='';
  VIO_USUARIO   VARCHAR2(10) :='';
  VIO_MSG_REGLA VARCHAR2(300):='';
  
  --
  VI_SQL        VARCHAR2(300):='';
  --CURSORES LISTADO
  CURSOR LISTADO_AUTORIZANTES(VI_COD_REGLA IN NUMBER, VI_TIPORPG IN NUMBER) IS
  SELECT *
    FROM AQPC849 A
   WHERE A.AQPC849CODVARI =  VI_COD_REGLA
     AND A.AQPC849TPRG    =  VI_TIPORPG
     AND A.AQPC849EST     =  'S'
     AND A.AQPC849REQ     =  'S';
  CURSOR LISTADO_AUTORIZANTES_EXCEPCIONAL(VI_COD_PROC IN NUMBER) IS
  SELECT *
    FROM AQPD160 A
   WHERE A.AQPD160CORR = VI_COD_PROC;
  
  BEGIN
        ---SI EL AUTORIZANTE ESTA EN EL LISTADO_AUTORIZANTES SE OBTIENE el CARGO/PERFIL
        FOR X IN LISTADO_AUTORIZANTES(VE_COD_REGLA,VE_TIPORPG) LOOP 
            VI_TMP_CARGO   := X.AQPC849CCARG;
            VI_TMP_PERFIL  := X.AQPC849PCARG;
            --
            VII_CODPRO     := X.AQPC849CODPROC;
            VII_CODMTDO    := X.AQPC849CODFUNC;
            VII_NOMMTDO    := X.AQPC849NOMFUNC;
            VI_NOM_VAR     := VE_NOM_VAR;
            VI_MSG_REG     := VE_MSG_REG;
            --SI EL AUTORIZADOR NO ESTA ESPECIFICADO SU CARGO O PERFIL
            ----SE GESTIONA POR LISTADO_AUTORIZANTES EXCEPCIONAL ES DECIR PROCESO QUE DETERMINA EL AUTORIZADOR
            IF TRIM(VI_TMP_CARGO) IS NULL AND TRIM(VI_TMP_PERFIL) IS NULL THEN
               FOR Y IN LISTADO_AUTORIZANTES_EXCEPCIONAL(X.AQPC849CODPROC) LOOP
                    --EJECUTAR PROCEDIMIENTO VALIDAR REGLA
                    --VE_NOMBRE_VAR,VI_VALOR_VAR,VI_MSG_REGLA,
                    --VALIDAR SI ESTA EXCEPTUADO
                    BEGIN
                        -- Construcción de la sentencia SQL dinámica
                        VI_SQL := Y.AQPD160CONSQL;
                        --
                        BEGIN
                          SELECT XWFCUENTA,XWFOPERACION INTO VII_CTA,VII_OPE FROM XWF700 WHERE XWFPRCINS=VE_INSTANCIA AND XWFCAR3='1';
                        EXCEPTION
                          WHEN OTHERS THEN
                            NULL;  
                        END;
                        -- Ejecución del procedimiento almacenado utilizando EXECUTE IMMEDIATE
                        EXECUTE IMMEDIATE VI_SQL USING IN VE_INSTANCIA,IN VII_CTA,IN VII_OPE,IN VII_CODPRO,IN VII_CODMTDO,IN VII_NOMMTDO,OUT VIO_CODCARGO,OUT VIO_PERFIL,OUT VIO_USUARIO,OUT VIO_MSG_REGLA, OUT VO_COD_ERROR, OUT VO_MSG_ERROR;
                        -- Mostrar o hacer algo con los resultados
                        VI_TMP_CARGO   := VIO_CODCARGO;
                        VI_TMP_PERFIL  := VIO_PERFIL;
                        VI_NOM_VAR     := Y.AQPD160NOMVAR;
                        VI_MSG_REG     := VIO_MSG_REGLA;--Y.AQPD160MGBLOQ; --ACA ROMARIO
                    EXCEPTION
                      WHEN OTHERS THEN
                        NULL;  --LOG DE QUE ALGUN ERROR SE GENERO POR MALA CONSTRUCCIÓN DE LA REGLA.
                        DBMS_OUTPUT.put_line(SUBSTR(SQLERRM,1,150));
                        VO_MSG_ERROR := SUBSTR(SQLERRM,1,150);
                    END;    
               END LOOP;
            END IF;
            --GRABAR BLOQUEANTE.
            IF TRIM(VI_TMP_CARGO) IS NOT NULL and VI_TMP_CARGO <> 0 THEN
              BEGIN
                PQ_CR_VALIDAR_RNG_REPROG.SP_GRABAR_LISTA_EXCEPCION ( VI_NOM_VAR, --variable de la regla que salto.
                                                                     VI_MSG_REG, --Mensaje Bloqueante que salto 
                                                                     91, --Fijo 
                                                                     ve_Instancia, --Instancia del crédito evaluado
                                                                     TO_CHAR(VI_TMP_CARGO),
                                                                     VI_TMP_PERFIL,
                                                                     VE_USUARIO); -- Usuario que lo esta gestionando              
              EXCEPTION 
                WHEN OTHERS THEN
                  NULL;
              END;
            ELSE
               VO_MENSAJE_ESP := VI_MSG_REG;
            END IF;
                        
        END LOOP;
        
        
        
  END;   
  
  PROCEDURE SP_VALIDAR_RNG_CAJA(VE_INSTANCIA   IN NUMBER,
                                VE_NRO         IN NUMBER,
                                VE_TIPO_REPROG IN NUMBER,
                                VE_USUARIO     IN VARCHAR,
                                VO_MSG         OUT VARCHAR) IS
  BEGIN
    NULL;
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END SP_VALIDAR_RNG_CAJA;

end PQ_CR_VALIDAR_RNG_RPSC;
/
