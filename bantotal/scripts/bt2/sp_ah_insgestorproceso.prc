create or replace procedure SP_AH_INSGESTORPROCESO(P_REGISTROS IN NUMBER,P_TIPO IN VARCHAR)  IS
   -- *****************************************************************
    -- Nombre                     : SP_AH_INSGESTORPROCESO
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Ahorros - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : Tania Apaza
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    --
    -- Retorno                    : 
    -- Fecha de Modificación      : 21/11/2023
    -- Autor de la Modificación   : Tania Apaza
    -- Descripción de Modificación: Mejoras a proceso
    --
    -- *****************************************************************
  v_token     VARCHAR2(10);
  v_inbifecha TIMESTAMP;
 
BEGIN
  SELECT TO_CHAR(SYSDATE, 'YYYYMMDDHH24') INTO v_token FROM dual;
  SELECT SYSTIMESTAMP into v_inbifecha FROM DUAL;

  INSERT INTO CRM_GESTORPROCESO
  (TOKENPROCESO, TIPO, INBI_FECHA, INBI_REGISTROS)
  VALUES(v_token, P_TIPO, v_inbifecha, P_REGISTROS);
  commit;
END SP_AH_INSGESTORPROCESO;
/

