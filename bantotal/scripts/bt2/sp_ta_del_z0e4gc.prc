CREATE OR REPLACE PROCEDURE SP_TA_DEL_Z0E4GC IS
  N_CONT1 NUMBER := 0;
BEGIN
  --LUIS CARPIO/ERIKA HIDALGO
  SELECT COUNT(9)
    INTO N_CONT1
    FROM Z0E4GC
   WHERE Z0E4GCEST = 'ZE'
     AND Z0E4GCAPL = 3
     AND Z0E4GCIMD = 0;

  IF N_CONT1 > 0 THEN
    EXECUTE IMMEDIATE 'create table operador.z0e4gc_' ||
                      TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) ||
                      ' as select * from z0e4gc where z0e4gcest=''ZE'' and z0e4gcapl=3 and z0e4gcimd=0';

    DELETE FROM Z0E4GC
     WHERE Z0E4GCEST = 'ZE'
       AND Z0E4GCAPL = 3
       AND Z0E4GCIMD = 0;
    COMMIT;
  END IF;
END SP_TA_DEL_Z0E4GC;
/

