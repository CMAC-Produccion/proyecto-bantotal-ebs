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
 * *************************************************************************************************************/
  PROCEDURE SP_VALIDAR_RNG_GENERAL(
                                     VE_INSTANCIA IN NUMBER,
                                     VE_NRO IN NUMBER,
                                     VE_TIPO_REPROG IN NUMBER,
                                     VE_USUARIO IN VARCHAR,
                                     VO_MSG OUT VARCHAR
                                    );
  PROCEDURE SP_VALIDAR_RNG_CAJA(
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
 * *************************************************************************************************************/
  PROCEDURE SP_VALIDAR_RNG_GENERAL(
                                   VE_INSTANCIA IN NUMBER,
                                   VE_NRO IN NUMBER,
                                   VE_TIPO_REPROG IN NUMBER,
                                   VE_USUARIO IN VARCHAR,
                                   VO_MSG OUT VARCHAR
                                  ) IS
  CURSOR LISTADO_REGLAS_MEMO_17_CASO01 IS-- REGLAS PARA CREDITOS ENTRE DIC2022 AL JUN2023
  SELECT *
    FROM AQPC780
   WHERE AQPC780MEMO = 'MEMO17-2024'
     AND AQPC780TPREPR = 10
     AND AQPC780GRPREG = 'CREDITOS ENTRE DIC2022 AL JUN2023'; 
  CURSOR LISTADO_REGLAS_MEMO_17_CASO02 IS-- REGLAS PARA CREDITOS ENTRE DIC2022 AL JUN2023
  SELECT *
    FROM AQPC780
   WHERE AQPC780MEMO = 'MEMO17-2024'
     AND AQPC780TPREPR = 10
     AND AQPC780GRPREG = 'CREDITOS FUERA DE DIC2022 AL JUN2023';
  CURSOR LISTADO_REGLAS_CAMBIO_FECHA(VCI_N_INSTANCE IN NUMBER) IS
  SELECT A.*
    FROM AQPC780 A, JAQA400 J
   WHERE A.AQPC780MEMO = 'CAMBIO_FECHA'
     AND A.AQPC780TPREPR = 10
     AND A.AQPC780GRPREG = 'CAMBIO_FECHA'
     AND A.AQPC780NUMRGL = J.JAQA400AN1
     AND A.AQPC780ESTADO = 'S'
     AND J.JAQA400AI1  = VCI_N_INSTANCE
     AND J.JAQA400FEC  = (SELECT PGFAPE FROM FST017 WHERE PGCOD=1);
     
  VE_MSG VARCHAR(300);
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
       FOR Y IN LISTADO_REGLAS_CAMBIO_FECHA(VE_INSTANCIA) LOOP
          BEGIN      
               PQ_CR_VALIDAR_RNG_RPSC.SP_VALIDAR_REGLA_RPSC(
                                            VE_INSTANCIA,VE_NRO,VE_TIPO_REPROG,Y.AQPC780MEMO,Y.AQPC780NOMRGL,VE_USUARIO,VE_MSG 
                                          );
               ----OBTENER LOS MENSAJES BLOQUEANTE EN CASO HUBIERA Y ALMACENARLOS EN LA VARIABLE GENERAL.
               If LENGTH(TRIM(VE_MSG)) > 0 THEN
                 IF LENGTH(TRIM(VO_MSG)) > 0   AND
                        LENGTH(TRIM(VO_MSG)) < 800 THEN
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
  PROCEDURE SP_VALIDAR_RNG_CAJA(
                                  VE_INSTANCIA IN NUMBER,
                                  VE_NRO IN NUMBER,
                                  VE_TIPO_REPROG IN NUMBER,
                                  VE_USUARIO IN VARCHAR,
                                  VO_MSG OUT VARCHAR 
                               ) IS
  BEGIN
       NULL;
  EXCEPTION
  WHEN OTHERS THEN
    NULL;  
  END SP_VALIDAR_RNG_CAJA;
  
  
  PROCEDURE SP_VALIDAR_REGLA_RPSC(
                                    VE_INSTANCIA IN NUMBER,
                                    VE_NRO IN NUMBER,
                                    VE_TIPO_REPROG IN NUMBER,
                                    VE_MEMO IN VARCHAR,
                                    VE_NOM_REGLA IN VARCHAR,                                    
                                    VE_USUARIO IN VARCHAR,
                                    VO_MSG OUT VARCHAR 
                                 ) IS
  VO_SQL VARCHAR(500);
  VO_NRO_PARAMETROS NUMBER(3);
  VO_NOMBRE_VAR VARCHAR(40);
  VO_NUM_REGLA NUMBER(5);
  VI_NUM_REGLA NUMBER(5);
  VO_MSG_REGLA VARCHAR(300);
  VI_MSG_REGLA VARCHAR(300);
  VE_MENSAJE VARCHAR(300);
  VO_RPTA_DESACTIVA_REG VARCHAR(10);
  VO_EXCEPCION VARCHAR(10);
  VI_SQL VARCHAR(500);
  VI_NOMBRE_VAR VARCHAR(40);
  VI_VALOR_VAR VARCHAR(20);
  VI_COD_ERROR VARCHAR(5);
  VI_VALOR_MSG VARCHAR(150);
  BEGIN
        VO_MSG := '';
        --ENCONTRAR REGLA Y OBTENER LOS DATOS PARA EJECUTAR VALIDACIÓN
        BEGIN
          PQ_CR_VALIDAR_RNG_RPSC.SP_BUSCAR_REGLA(
                                                  VE_MEMO,
                                                  VE_NOM_REGLA,
                                                  --
                                                  VO_SQL,
                                                  VO_NRO_PARAMETROS,
                                                  VO_NOMBRE_VAR,
                                                  VO_NUM_REGLA,
                                                  VO_MSG_REGLA
                                                );
          VI_NOMBRE_VAR := VO_NOMBRE_VAR;
          VI_NUM_REGLA  := VO_NUM_REGLA;
          VI_MSG_REGLA  := VO_MSG_REGLA;
        EXCEPTION
          WHEN OTHERS THEN
            NULL; --LOG DE QUE NO SE ENCONTRO LA REGLA.                                                                                               
        END;
        --
        DBMS_OUTPUT.put_line('SQL:'||VO_SQL);
        --VALIDAR SI EXISTE REGLA
        IF TRIM(VO_SQL) IS NOT NULL OR TRIM(VO_SQL) <> '' THEN
            
            --EJECUTAR PROCEDIMIENTO VALIDAR REGLA
              --VE_NOMBRE_VAR,VI_VALOR_VAR,VI_MSG_REGLA,
              --VALIDAR SI ESTA EXCEPTUADO
            BEGIN
                -- Construcción de la sentencia SQL dinámica
                VI_SQL := VO_SQL;--'BEGIN TUPA_PROCEDIMIENTO(:1, :2); END;';
                -- Ejecución del procedimiento almacenado utilizando EXECUTE IMMEDIATE
                EXECUTE IMMEDIATE VI_SQL USING IN VE_INSTANCIA,IN VE_USUARIO, OUT VI_VALOR_VAR,OUT VI_COD_ERROR, OUT VI_VALOR_MSG;
               
                -- Mostrar o hacer algo con los resultados
                DBMS_OUTPUT.PUT_LINE('Valor 1: ' || TO_CHAR(VE_INSTANCIA));
                DBMS_OUTPUT.PUT_LINE('Valor 2: ' || VE_USUARIO);
                DBMS_OUTPUT.PUT_LINE('Valor 3: ' || VI_VALOR_VAR);
                DBMS_OUTPUT.PUT_LINE('Valor 4: ' || VI_COD_ERROR);
                DBMS_OUTPUT.PUT_LINE('Valor 5: ' || VI_VALOR_MSG);
            EXCEPTION
              WHEN OTHERS THEN
                NULL;  --LOG DE QUE ALGUN ERROR SE GENERO POR MALA CONSTRUCCIÓN DE LA REGLA.
                DBMS_OUTPUT.put_line(SUBSTR(SQLERRM,1,150));
            END;
            BEGIN  
              PQ_CR_VALIDAR_RNG_REPROG.SP_REGLAS_LOGS_EXCEPTION(VE_NRO,                                  
                                                                VE_INSTANCIA,
                                                                VI_NOMBRE_VAR,--'NRO_RPROG',
                                                                (VI_VALOR_VAR||VI_VALOR_MSG),
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
               IF LENGTH(TRIM(VO_MSG)) > 0   AND
                  LENGTH(TRIM(VO_MSG)) < 301 THEN
                  VO_MSG := VO_MSG || ';' || VI_MSG_REGLA;
                ELSE
                  VO_MSG := VI_MSG_REGLA;
                END IF;
            END IF;
            
        END IF;
  
  
  EXCEPTION
    WHEN OTHERS THEN 
      NULL;
  END;  
  
  PROCEDURE SP_BUSCAR_REGLA(
                            VE_MEMO IN VARCHAR,
                            VE_NOM_REGLA IN VARCHAR,
                            --
                            VO_SQL OUT VARCHAR,
                            VO_NRO_PARAMETROS OUT NUMBER,
                            VO_NOMBRE_VAR OUT VARCHAR,
                            VO_NUM_REGLA OUT NUMBER,
                            VO_MSG_REGLA OUT VARCHAR
                           ) IS
  BEGIN
    SELECT AQPC780CONSQL,AQPC780NUMPAR,AQPC780NOMVAR,AQPC780NUMRGL,AQPC780MGBLOQ
      INTO VO_SQL,VO_NRO_PARAMETROS,VO_NOMBRE_VAR,VO_NUM_REGLA,VO_MSG_REGLA
      FROM AQPC780
     WHERE AQPC780MEMO   = VE_MEMO
       AND AQPC780NOMRGL = VE_NOM_REGLA
       AND AQPC780ESTADO = 'S';
  EXCEPTION 
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('ERR-002'||'-'||VE_MEMO||'-'||VE_NOM_REGLA);
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
  END;    
  
  PROCEDURE SP_OBTENER_PARAMETROS(
                                    VE_PACKAGE       IN VARCHAR,
                                    VE_PROCEDIMIENTO IN VARCHAR,
                                    VE_CODIGO_PRC    IN NUMBER                                                                       
                                 )
  IS 
  -- Declaración de variables generales
  v_sql VARCHAR2(1000);
  v_parameter_name VARCHAR2(30);
  v_data_type VARCHAR2(30);
  v_parameter_mode VARCHAR2(10);
  
  --borrar esto
  -- Variables para el primer procedimiento

  v_INSTANCIA1 NUMBER := 123; -- Reemplazar con el valor real
  v_FLAG VARCHAR2(50);
  v_CODMSG VARCHAR2(50);
  v_DESMSG VARCHAR2(255);
  -- Variables para el segundo procedimiento
  v_procedure_name2 VARCHAR2(50) := 'SP_VALIDAR_LISTA_BI';
  v_VE_INSTANCIA NUMBER := 456; -- Reemplazar con el valor real
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
                        AND PACKAGE_NAME= VE_PACKAGE
                      ORDER BY position)
        LOOP
          v_parameter_name := param.argument_name;
          v_data_type := param.data_type;
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
        
        FOR i IN 1..v_parameters2.COUNT LOOP
          DBMS_OUTPUT.PUT_LINE(v_parameters2(i));
        END LOOP;
        v_parameters2.DELETE;
    /*   
        -- Agregar parámetros para el primer procedimiento
        v_parameters('VE_INSTANCIA') := TO_CHAR(v_INSTANCIA1);
        v_parameters('VO_RPTAC') := NULL;
        v_parameters('v_CODMSG') := NULL;
        v_parameters('v_DESMSG') := NULL;

        -- Ejecución del primer procedimiento
        v_sql := 'BEGIN ' || v_procedure_name1 || '(';

        -- Obtener información sobre los parámetros del primer procedimiento
        FOR param IN (SELECT AQPC782NOMVAR argument_name,AQPC782TPDATO data_type,AQPC782TPINPT in_out
                      FROM AQPC782
                      WHERE AQPC782CORRAS = VE_CODIGO_PRC
                      ORDER BY AQPC782ORDEN)
        LOOP
          v_parameter_name := param.argument_name;
          v_data_type := param.data_type;
          v_parameter_mode := param.in_out;

          IF v_parameter_mode = 'I' THEN
            v_sql := v_sql || ':' || v_parameter_name || ', ';
            EXECUTE IMMEDIATE 'BEGIN :1 := ' || v_parameters(v_parameter_name) || '; END;' USING IN OUT v_parameters(v_parameter_name);
          ELSIF v_parameter_mode = 'O' THEN
            v_sql := v_sql || ':' || v_parameter_name || ' OUT, ';

            IF v_data_type = 'V' THEN
              EXECUTE IMMEDIATE 'BEGIN :1 := NULL; END;' USING OUT v_parameters(v_parameter_name);
            ELSIF v_data_type = 'N' THEN
              EXECUTE IMMEDIATE 'BEGIN :1 := NULL; END;' USING OUT v_parameters(v_parameter_name);
            END IF;
          END IF;
        END LOOP;

        v_sql := RTRIM(v_sql, ', ') || '); END;';
        EXECUTE IMMEDIATE v_sql USING v_parameters;

        -- Mostrar o hacer algo con los resultados del primer procedimiento
        DBMS_OUTPUT.PUT_LINE('Resultado del primer procedimiento:');
        DBMS_OUTPUT.PUT_LINE('FLAG: ' || v_parameters('v_FLAG'));
        DBMS_OUTPUT.PUT_LINE('CODMSG: ' || v_parameters('v_CODMSG'));
        DBMS_OUTPUT.PUT_LINE('DESMSG: ' || v_parameters('v_DESMSG'));

        -- Limpiar parámetros para el segundo procedimiento
        v_parameters.DELETE;

        -- Agregar parámetros para el segundo procedimiento
        v_parameters('v_VE_INSTANCIA') := TO_CHAR(v_VE_INSTANCIA);
        v_parameters('v_VE_NRO_RPG') := NULL;
        v_parameters('v_VE_CARGO_APROB') := NULL;
        v_parameters('v_VE_APROBADOR') := NULL;
        v_parameters('v_VE_RPTA') := NULL;
        */
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM) ;
  END;                                 
    
                         
end PQ_CR_VALIDAR_RNG_RPSC;
/

