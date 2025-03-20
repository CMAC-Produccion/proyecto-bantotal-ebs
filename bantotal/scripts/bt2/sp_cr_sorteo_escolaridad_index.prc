CREATE OR REPLACE PROCEDURE SP_CR_SORTEO_ESCOLARIDAD_INDEX IS
  -- *****************************************************************
  -- Nombre                     : PROCEDIMIENTO PARA REGISTRAR LOS GANADORES DIARIOS 
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 04/02/2025
  -- Autor de Creación          : MHUAMANIA
  -- Uso                        : 
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :
  --                            : MHUAMANI 04/03/2025 SE AÑADIÓ CANTIDAD DE GANADORES PARA FECHAS ESPECIALES
  -- *****************************************************************
  v_count        NUMBER;
  v_fecha_actual DATE;
  v_nro1         NUMBER;
  v_nro2         NUMBER;
  v_nro3         NUMBER;
  v_nro4         NUMBER;
  v_nro5         NUMBER;
  v_nro6         NUMBER;
  corteam        NUMBER;
  cortepm        NUMBER;
  --feches          VARCHAR2(30);
  v_total_numeros NUMBER;
  RG1AM           NUMBER;
  RG1PM           NUMBER;
  RG2AM           NUMBER;
  RG2PM           NUMBER;
  --*************************************************************
  -- Nombre                     : Función para generar un número aleatorio dentro de un rango
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Pasivas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 04/02/2025
  -- Autor de Creación          : MHUAMANIA
  -- Uso                        : Realiza cálculos
  --*************************************************************
  FUNCTION fn_cr_gen_num(p_am IN NUMBER, p_pm IN NUMBER) RETURN NUMBER IS
    v_num NUMBER;
  BEGIN
    v_num := TRUNC(DBMS_RANDOM.VALUE(p_am, p_pm));
    RETURN v_num;
  END fn_cr_gen_num;

BEGIN
  -- Verificar si ya se insertaron datos hoy
  select pgfape into v_fecha_actual from fst017 where pgcod = 1;

  SELECT COUNT(*)
    INTO v_count
    FROM AQPD758
   WHERE TRUNC(AQPD758fechag) = v_fecha_actual;
  -- ya se hizo el sorteo para el día
  IF v_count > 0 THEN
    RAISE_APPLICATION_ERROR(-20001,
                            'Ya se han generado números para el día de hoy.');
  END IF;
  /*
    SELECT TP1DESC
      into feches
      FROM FST198
     WHERE TP1COD = 1
       AND TP1COD1 = 11181
       and TP1CORR1 = 3;
    -- Determinar cuántos números se deben generar
    IF v_fecha_actual = TO_DATE(feches, 'DD/MM/YYYY') THEN
      v_total_numeros := 6; --poenr guia
    ELSE
      v_total_numeros := 2;
    END IF;
  */
  --VALIDAR FECHAS
  --MHUAMANIA 04/03/2025
  BEGIN
    SELECT TP1NRO1
      into v_total_numeros
      FROM FST198
     WHERE TP1COD = 1
       AND TP1COD1 = 11181
       and TP1CORR1 = 5
       AND TP1DESC = v_fecha_actual;
  EXCEPTION
    WHEN OTHERS THEN
      v_total_numeros := 0;
  END;

  SELECT TP1NRO1, TP1NRO2
    INTO RG1AM, RG1PM
    FROM FST198
   WHERE TP1COD = 1
     AND TP1COD1 = 11181
     AND TP1CORR1 = 4
     AND TP1CORR3 = 1;
  SELECT TP1NRO1, TP1NRO2
    INTO RG2AM, RG2PM
    FROM FST198
   WHERE TP1COD = 1
     AND TP1COD1 = 11181
     AND TP1CORR1 = 4
     AND TP1CORR3 = 2;

  -- Verificar si los cortes son válidos antes de generar números
  IF corteam = 0 OR cortepm = 0 THEN
    RAISE_APPLICATION_ERROR(-20002,
                            'Error: No hay datos disponibles para el sorteo.');
  END IF;

    LOOP
      v_nro1 := fn_cr_gen_num(RG1AM, RG1PM);
      v_nro2 := fn_cr_gen_num(RG2AM, RG2PM);
      EXIT WHEN v_nro1 <> v_nro2; -- se queda con los numeros
    END LOOP;

  -- ACÁ EL CAMBIO PARA LA GUIA
  /*
  SELECT TP1DESC
    into fechaespe
    FROM FST198
   WHERE TP1COD = 1
     AND TP1COD1 = 11181
     and TP1CORR1 = 5;
  IF v_fecha_actual = TO_DATE(fechaespe, 'DD/MM/YYYY') THEN
    v_total_numeros := 6; --poenr guia
  ELSE
    v_total_numeros := 2;
  END IF;
  
  */

  -- Asegurar que no se repitan los números entre los rangos
  IF v_total_numeros = 4 THEN
    LOOP
      v_nro3 := fn_cr_gen_num(RG1AM, RG1PM);
      EXIT WHEN v_nro3 <> v_nro1 AND v_nro3 <> v_nro2;
    END LOOP;
  
    LOOP
      v_nro4 := fn_cr_gen_num(RG2AM, RG2PM);
      EXIT WHEN v_nro4 <> v_nro1 AND v_nro4 <> v_nro2 AND v_nro4 <> v_nro3;
    END LOOP;
  ELSE
    v_nro5 := NULL;
    v_nro6 := NULL;
  END IF;

  IF v_total_numeros = 5 THEN
    LOOP
      v_nro3 := fn_cr_gen_num(RG1AM, RG1PM);
      EXIT WHEN v_nro3 <> v_nro1 AND v_nro3 <> v_nro2;
    END LOOP;
  
    LOOP
      v_nro4 := fn_cr_gen_num(RG2AM, RG2PM);
      EXIT WHEN v_nro4 <> v_nro1 AND v_nro4 <> v_nro2 AND v_nro4 <> v_nro3;
    END LOOP;
  
    LOOP
      v_nro5 := fn_cr_gen_num(RG1AM, RG1PM);
      EXIT WHEN v_nro5 <> v_nro1 AND v_nro5 <> v_nro2 AND v_nro5 <> v_nro3 AND v_nro5 <> v_nro4;
    END LOOP;
  ELSE
    v_nro6 := NULL;
  END IF;
  /*
    IF v_total_numeros = 6 THEN
      LOOP
        v_nro3 := fn_cr_gen_num(RG1AM, RG1PM);
        EXIT WHEN v_nro3 <> v_nro1 AND v_nro3 <> v_nro2;
      END LOOP;
    
      LOOP
        v_nro4 := fn_cr_gen_num(RG1AM, RG1PM);
        EXIT WHEN v_nro4 <> v_nro1 AND v_nro4 <> v_nro2 AND v_nro4 <> v_nro3;
      END LOOP;
    
      LOOP
        v_nro5 := fn_cr_gen_num(RG2AM, RG2PM);
        EXIT WHEN v_nro5 <> v_nro1 AND v_nro5 <> v_nro2 AND v_nro5 <> v_nro3 AND v_nro5 <> v_nro4;
      END LOOP;
    
      LOOP
        v_nro6 := fn_cr_gen_num(RG2AM, RG2PM);
        EXIT WHEN v_nro6 <> v_nro1 AND v_nro6 <> v_nro2 AND v_nro6 <> v_nro3 AND v_nro6 <> v_nro4 AND v_nro6 <> v_nro5;
      END LOOP;
    ELSE
      v_nro3 := NULL;
      v_nro4 := NULL;
      v_nro5 := NULL;
      v_nro6 := NULL;
    END IF;
  */
  -- Insertar los números generados en la tabla
  INSERT INTO AQPD758
    (AQPD758fechag,
     AQPD758nro1,
     AQPD758nro2,
     AQPD758nro3,
     AQPD758nro4,
     AQPD758nro5,
     AQPD758nro6)
  VALUES
    (v_fecha_actual, v_nro1, v_nro2, v_nro3, v_nro4, v_nro5, v_nro6);

  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END SP_CR_SORTEO_ESCOLARIDAD_INDEX;
/

