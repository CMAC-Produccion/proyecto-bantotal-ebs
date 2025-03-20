CREATE OR REPLACE PROCEDURE SP_CR_CAMBIA_FECHA_FPP028(P28TOP NUMBER) IS
  N_CONT1 NUMBER := 0;
  N_CONT2 NUMBER := 0;

BEGIN
  SELECT COUNT(*)
    INTO N_CONT1
    FROM FPP028
   WHERE PP028MOD = 116
     AND PP017PAR = 253
     AND PP028TOP = P28TOP;

  SELECT COUNT(*)
    INTO N_CONT2
    FROM FPP028
   WHERE PP028MOD = 116
     AND PP017PAR = 408
     AND PP028TOP = P28TOP;

  IF N_CONT1 > 0 THEN
    IF N_CONT1 = N_CONT2 THEN
      IF N_CONT1 in (1,2) THEN
        EXECUTE IMMEDIATE 'create table operador.FPP028_' ||
                          TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                          SUBSTR(USER, 1, 3) || ' as select * from FPP028 ' ||
                          'where PP028MOD = 116
   AND PP017PAR = 253
   AND PP028TOP = ' || P28TOP;
      
        UPDATE FPP028
           SET PP028DEFC = 'N'
         WHERE PP028MOD = 116
           AND PP017PAR = 253
           AND PP028TOP = P28TOP;
      
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Se actualizó la tabla FPP028 where PP017PAR = 253, ' ||
                             N_CONT1 || ' registros.');
      
        EXECUTE IMMEDIATE 'create table operador.FPP028_' ||
                          TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                          SUBSTR(USER, 1, 3) || ' as select * from FPP028 ' ||
                          'where PP028MOD = 116
   AND PP017PAR = 408
   AND PP028TOP = ' || P28TOP;
      
        UPDATE FPP028
           SET PP028DEFC = 'S'
         WHERE PP028MOD = 116
           AND PP017PAR = 408
           AND PP028TOP = P28TOP;
      
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Se actualizó la tabla FPP028 where PP017PAR = 408, ' ||
                             N_CONT2 || ' registros.');
      ELSE
        DBMS_OUTPUT.PUT_LINE('No se realizó el Update. El nro de registros es distinto de 1 o 2.');
      END IF;
    
    ELSE
      DBMS_OUTPUT.PUT_LINE('No se realizaron los Updates. El nro de registros a actualizar para cada update es distinto.');
    END IF;
  
  ELSE
    DBMS_OUTPUT.PUT_LINE('No se realizó el Update porque el script considera 0 registros.');
  END IF;

  insert into AQPB876
  values
    (user, sysdate, 'SP_CR_CAMBIA_FECHA_FPP028', P28TOP);
  commit;
END SP_CR_CAMBIA_FECHA_FPP028;
/

