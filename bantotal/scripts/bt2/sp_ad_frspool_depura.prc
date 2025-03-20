CREATE OR REPLACE PROCEDURE SP_AD_FRSPOOL_DEPURA IS
  -- *****************************************************************
  -- NOMBRE                     : SP_AD_FRSPOOL_DEPURA
  -- SISTEMA                    : BANTOTAL
  -- MÓDULO                     : ADMINISTRACION
  -- VERSIÓN                    : 1.0
  -- FECHA DE CREACIÓN          : 09/01/2024
  -- AUTOR DE CREACIÓN          : ERIKA HIDALGO
  -- USO                        : DEPURACIÓN FRSPOOL
  -- ESTADO                     : ACTIVO
  -- PARÁMETROS DE ENTRADA      :
  -- FECHA DE MODIFICACIÓN      :
  -- AUTOR DE MODIFICACIÓN      :
  N_CONT NUMBER := 0;
BEGIN
  SELECT COUNT(1)
    INTO N_CONT
    FROM FRSPOOL
   WHERE FRSFILDAT < TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, -2))) + 1 and FRSFOLID<>30;

  IF N_CONT > 0 THEN

    EXECUTE IMMEDIATE 'create table operador.FRSPOOL_' ||
                      TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) ||
                      ' compress as select * from FRSPOOL where FRSFILDAT<=trunc(last_day(add_months(sysdate,-2))) + 1 and FRSFOLID<>30';

    DELETE FRSPOOL
     WHERE FRSFILDAT <= TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, -2))) + 1 and FRSFOLID<>30;
    COMMIT;
  END IF;

  INSERT INTO AQPB876
  VALUES
    (USER,
     SYSDATE,
     'SP_AD_FRSPOOL_DEPURA',
     to_char(TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, -2)))+1,'RRRR/MM/DD'));
  COMMIT;
END SP_AD_FRSPOOL_DEPURA;
/

