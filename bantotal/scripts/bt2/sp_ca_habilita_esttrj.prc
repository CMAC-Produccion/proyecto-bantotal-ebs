CREATE OR REPLACE PROCEDURE SP_CA_HABILITA_ESTTRJ(N_NROTRJ CHAR) IS
  N_CONT NUMBER;
BEGIN
  --LUIS CARPIO/ERIKA HIDALGO
  SELECT COUNT(1) INTO N_CONT FROM Z0E478 WHERE Z0E478NRO = N_NROTRJ;
  IF N_CONT > 0 THEN
    EXECUTE IMMEDIATE 'create table operador.Z0E478_' ||
                      TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) ||
                      ' as select * from Z0E478 where Z0E478NRO='''||N_NROTRJ||'''';
    EXECUTE IMMEDIATE 'create table operador.Z0E479_' ||
                      TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) ||
                      ' as select * from Z0E479 where Z0E478NRO='''||N_NROTRJ||'''';
    EXECUTE IMMEDIATE 'create table operador.Z0E481_' ||
                      TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) ||
                      ' as select * from Z0E481 where Z0E481NRO='''||N_NROTRJ||'''';
    EXECUTE IMMEDIATE 'create table operador.Z0E482_' ||
                      TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) ||
                      ' as select * from Z0E482 where Z0E481NRO='''||N_NROTRJ||'''';
    EXECUTE IMMEDIATE 'create table operador.FTD10_' ||
                      TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) ||
                      ' as select * from FTD10 where TD10TAR='''||N_NROTRJ||'''';
    EXECUTE IMMEDIATE 'create table operador.JAQY252_' ||
                      TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) ||
                      ' as select * from JAQY252 where JAQY252NUTAR='''||N_NROTRJ||'''';
    UPDATE Z0E478
       SET Z0E463COD = 1, Z0E478EST = 'AC'
     WHERE Z0E478NRO = N_NROTRJ;
    UPDATE Z0E479 SET Z0E479EST = 'AC' WHERE Z0E478NRO = N_NROTRJ;
    UPDATE Z0E481
       SET Z0E463COD = 1, Z0E481EST = 'AC'
     WHERE Z0E481NRO = N_NROTRJ;
    UPDATE Z0E482 SET Z0E482EST = 'AC' WHERE Z0E481NRO = N_NROTRJ;
    UPDATE FTD10 SET TD10EST = 'ACTIVA' WHERE TD10TAR = N_NROTRJ;
    UPDATE JAQY252 SET JAQY252NUINT = 0 WHERE JAQY252NUTAR = N_NROTRJ;
    dbms_output.put_line('Se actualizaron las tablas Z0E478, Z0E479, Z0E481, Z0E482, FTD10, JAQY252 para la tarjeta '||N_NROTRJ||'.');
    commit;
  ELSE
    dbms_output.put_line('No existe la tarjeta '||N_NROTRJ|| ' en la tabla Z0E478.');
  END IF;
insert into AQPB876 values (user,sysdate,'SP_CA_HABILITA_ESTTRJ',  N_NROTRJ);
commit;
END SP_CA_HABILITA_ESTTRJ;
/

