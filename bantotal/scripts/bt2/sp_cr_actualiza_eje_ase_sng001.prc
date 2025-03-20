CREATE OR REPLACE PROCEDURE SP_CR_ACTUALIZA_EJE_ASE_SNG001(N_SNG001INST NUMBER,
                                                           N_SNG001EJEC NUMBER,
                                                           C_SNG001ASE  CHAR) IS
  N_CONT NUMBER;
BEGIN
  --LUIS CARPIO/ERIKA HIDALGO
  SELECT COUNT(1) INTO N_CONT FROM SNG001 WHERE SNG001INST = N_SNG001INST;
  IF N_CONT = 1 THEN
    EXECUTE IMMEDIATE 'create table operador.SNG001_' ||
                      TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) ||
                      ' as select * from SNG001 where SNG001INST=' ||
                      N_SNG001INST;
    UPDATE SNG001
       SET SNG001EJEC = N_SNG001EJEC, SNG001ASE = C_SNG001ASE
     WHERE SNG001INST = N_SNG001INST;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Se actualizó ' || N_CONT ||
                         ' registro(s) en SNG001 para SNG001INST:' ||
                         N_SNG001INST);
  ELSE
    DBMS_OUTPUT.PUT_LINE('No existen registros en la tabla SNG001 para SNG001INST:' ||
                         N_SNG001INST);
  END IF;
insert into AQPB876 values (user,sysdate,'SP_CR_ACTUALIZA_EJE_ASE_SNG001',  N_SNG001INST||'-'||N_SNG001EJEC||'-'||C_SNG001ASE);
commit;
END SP_CR_ACTUALIZA_EJE_ASE_SNG001;
/

