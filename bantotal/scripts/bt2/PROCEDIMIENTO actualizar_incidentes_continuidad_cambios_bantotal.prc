/*
El siguiente Script debe ejecutarse en la base de datos de Bantotal.

Para ejecutarlo se debe tener un DBLINK que permita consultar a las tablas en la base de datos de CONTINUIDAD. 
En el script del procedimiento se está colocando el DBLINK @GESCON para acceder a las tablas de CONTINUIDAD. 

@GESCON es el DBLINK que se ha estado usando para conectar a la base de datos de CONTINUIDAD en QA. 
Para producción crear un DBLINK para acceder a CONTINUIDAD en Producción, preferentemente también llamarlo @GESCON 
para no modificar el script del procedimiento, en caso se cree con otro nombre reemplazar las ocurrencias en el archivo.
*/


CREATE OR REPLACE PROCEDURE actualizar_incidentes_cambios_bantotal IS
  -- Author  : Microdata
  -- Created : 21/07/2025
  -- Purpose : Proceso de actualización de estado para el sistema de Continuida del negocio
  CURSOR trabajadores IS
    SELECT a.cod_usuario,
           a.estado AS estado_actual,
           a.cod_sucursal,
           t.estado AS estado_temporal,
           t.codsucursal AS sucursal_temporal,
           t.sucursal AS nombre_sucursal_temporal
      FROM admi_trab_bant@GESCON a
      JOIN V_AQPD170 t
        ON UPPER(TRIM(a.cod_usuario)) = UPPER(TRIM(t.ubuser));

  v_responsable              VARCHAR2(50);
  v_id_agencia_nueva         NUMBER;
  v_formato_agencia_id_nueva NUMBER;
  v_tiene_responsabilidad    NUMBER;

BEGIN
  FOR reg IN trabajadores LOOP
    v_responsable := LOWER(TRIM(reg.cod_usuario));
    DBMS_OUTPUT.PUT_LINE('--- Procesando trabajador: ' || reg.cod_usuario);

    -- 1. CAMBIO DE ESTADO DE ACTIVO A CESADO
    IF UPPER(TRIM(reg.estado_temporal)) = 'CESADO' THEN
      DBMS_OUTPUT.PUT_LINE('→ Cambio de estado ACTIVO → CESADO');

      UPDATE INDI_INCI_FORM_INCI_AGEN_R6D52@GESCON
         SET is_deleted = 1
       WHERE TRIM(LOWER(responsable)) = v_responsable;

      UPDATE INDI_INCI_FORM_INCI_AGEN_R835E@GESCON
         SET is_deleted = 1
       WHERE TRIM(LOWER(responsable)) = v_responsable;

      UPDATE INDI_INCI_FORM_INCI_RESP_EDIC@GESCON
         SET is_deleted = 1
       WHERE TRIM(LOWER(responsable)) = v_responsable;

      UPDATE INDI_INCI_FORM_INCI_RESP_REGI@GESCON
         SET is_deleted = 1
       WHERE TRIM(LOWER(responsable)) = v_responsable;

    ELSE
      -- Verificar si es responsable en al menos una agencia
      SELECT COUNT(*) INTO v_tiene_responsabilidad
        FROM INDI_INCI_FORM_INCI_AGEN_R6D52@GESCON
       WHERE TRIM(LOWER(responsable)) = v_responsable
         AND IS_DELETED = 0;

      IF v_tiene_responsabilidad > 0 THEN
        DBMS_OUTPUT.PUT_LINE('→ Trabajador es responsable, eliminando de agencias anteriores');

        -- Eliminarlo de todas las agencias donde sea responsable
        UPDATE INDI_INCI_FORM_INCI_AGEN_R6D52@GESCON
           SET IS_DELETED = 1
         WHERE TRIM(LOWER(responsable)) = v_responsable
           AND IS_DELETED = 0;

        -- Verificar si la nueva agencia existe
        BEGIN
          SELECT id INTO v_id_agencia_nueva
            FROM ADMINISTRACION_AGENCIA@GESCON
           WHERE codigo = reg.sucursal_temporal
             AND ROWNUM = 1;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            v_id_agencia_nueva := NULL;
        END;

        IF v_id_agencia_nueva IS NOT NULL THEN
          -- Buscar si tiene un formato de incidente activo en esa agencia
          BEGIN
            SELECT id INTO v_formato_agencia_id_nueva
              FROM INDI_INCI_FORM_INCI_AGEN@GESCON
             WHERE AGENCIA_ID = v_id_agencia_nueva
               AND IS_DELETED = 0
               AND FORMATO_INCIDENTE_ID IN (
                   SELECT ID
                     FROM INDI_INCI_FORM_INCI@GESCON
                    WHERE DEPARTAMENTO_ADM_ID = 47
                      AND ES_VERSION_ACTUAL = 1
               )
               AND ROWNUM = 1;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              v_formato_agencia_id_nueva := NULL;
          END;

          IF v_formato_agencia_id_nueva IS NOT NULL THEN
            -- Insertar nuevo responsable si no existe
            SELECT COUNT(*) INTO v_tiene_responsabilidad
              FROM INDI_INCI_FORM_INCI_AGEN_R6D52@GESCON
             WHERE FORMATO_INCIDENTE_AGENCIA_ID = v_formato_agencia_id_nueva
               AND TRIM(LOWER(responsable)) = v_responsable
               AND IS_DELETED = 0;

            IF v_tiene_responsabilidad = 0 THEN
              INSERT INTO INDI_INCI_FORM_INCI_AGEN_R6D52@GESCON (
                  IS_DELETED, FECHA_CREACION, FECHA_EDICION,
                  RESPONSABLE, FORMATO_INCIDENTE_AGENCIA_ID
              ) VALUES (
                  0, SYSDATE, SYSDATE,
                  v_responsable, v_formato_agencia_id_nueva
              );
              DBMS_OUTPUT.PUT_LINE('   → Responsable transferido a nueva agencia');
            ELSE
              DBMS_OUTPUT.PUT_LINE('   → Ya era responsable en nueva agencia');
            END IF;

          ELSE
            DBMS_OUTPUT.PUT_LINE('   → No se encontró incidencia en nueva agencia. No se transfiere.');
          END IF;

        ELSE
          DBMS_OUTPUT.PUT_LINE('   → Nueva agencia no existe');
        END IF;
      END IF;
    END IF;

    -- 2. ACTUALIZACIÓN FINAL DE CAMPOS SI HAY DIFERENCIAS
    IF reg.cod_sucursal != reg.sucursal_temporal
       OR reg.estado_actual != reg.estado_temporal THEN

      UPDATE admi_trab_bant@GESCON
         SET cod_sucursal = reg.sucursal_temporal,
             sucursal     = reg.nombre_sucursal_temporal,
             estado       = reg.estado_temporal,
             fecha_creacion = SYSDATE
       WHERE UPPER(TRIM(cod_usuario)) = UPPER(TRIM(reg.cod_usuario));

      DBMS_OUTPUT.PUT_LINE('→ Actualizado admi_trab_bant con nueva agencia y estado');
    END IF;

  END LOOP;

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('--- Procedimiento completado ---');

END actualizar_incidentes_cambios_bantotal;
/
