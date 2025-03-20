CREATE OR REPLACE PROCEDURE SP_AU_SEG002(USUARIO    IN VARCHAR2, -- RUBRO
                                         FECHA      IN DATE,
                                         HORA       IN VARCHAR2,
                                         HORAF      IN VARCHAR2,
                                         FECHAORI   IN DATE,
                                         TIPOCIERRE IN VARCHAR2) IS
  PRAGMA AUTONOMOUS_TRANSACTION;
  -- *****************************************************************
  -- Nombre                     : SP_AU_SEG002
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Sesión Usuarios
  -- Versión                    : 1.0
  -- Fecha de Creación          : 14/11/2023
  -- Autor de Creación          : LUIS CARPIO
  -- Uso                        : Corrección de fecha y hora de salida de sesión
  -- Estado                     : Activo
  -- Parámetros de Entrada      :
  -- Fecha de Modificación      :
  -- Autor de Modificación      :
BEGIN
  --GRABA FECHA, HORA DE SALIDA Y AUXILIAR DE CARACTERES DEPENDIENDO DE TIPOCIERRE
  IF TRIM(TIPOCIERRE) IS NULL THEN
    UPDATE SEG002 R
       SET R.SEG002FCS = FECHA,
           R.SEG002HRS = TO_CHAR(TO_DATE(HORAF, 'hh24:rr:ss') -
                                 1 / 24 / 15 / 60,
                                 'hh24:rr:ss'),
           R.SEG002AU1   = 'A'
     WHERE R.SEG002PGC = 1
       AND R.SEG002USU = USUARIO
       AND R.SEG002FCI = FECHA
       AND R.SEG002HRI = HORA
       AND TRIM(SEG002HRS) IS NULL;
    COMMIT;
  ELSE
    UPDATE SEG002 R
       SET R.SEG002FCS = FECHA,
           R.SEG002HRS = TO_CHAR(TO_DATE(HORAF, 'hh24:rr:ss') -
                                 1 / 24 / 15 / 60,
                                 'hh24:rr:ss')
     WHERE R.SEG002PGC = 1
       AND R.SEG002USU = USUARIO
       AND R.SEG002FCI = FECHA
       AND R.SEG002HRI = HORA
       AND TRIM(SEG002HRS) IS NULL;
    COMMIT;
  END IF;
END SP_AU_SEG002;
/

