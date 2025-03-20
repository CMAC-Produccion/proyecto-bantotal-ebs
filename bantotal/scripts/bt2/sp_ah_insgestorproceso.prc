create or replace procedure SP_AH_INSGESTORPROCESO(P_REGISTROS IN NUMBER,P_TIPO IN VARCHAR)  IS
   -- *****************************************************************
    -- Nombre                     : SP_AH_INSGESTORPROCESO
    -- Sistema                    : BANTOTAL
    -- M�dulo                     : Ahorros - Activas
    -- Versi�n                    : 1.0
    -- Fecha de Creaci�n          : 
    -- Autor de Creaci�n          : Tania Apaza
    -- Uso                        : 
    -- Estado                     : Activo
    -- Acceso                     : P�blico
    -- Par�metros de Entrada      : 
    --
    -- Retorno                    : 
    -- Fecha de Modificaci�n      : 21/11/2023
    -- Autor de la Modificaci�n   : Tania Apaza
    -- Descripci�n de Modificaci�n: Mejoras a proceso
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

