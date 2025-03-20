CREATE OR REPLACE PROCEDURE SP_CR_FBC605_TRAMITANTE IS
  N_CONT NUMBER;
BEGIN
  SELECT COUNT(1)
    INTO N_CONT
    FROM FBC605 A
   WHERE A.BC604MOD = 93
     AND A.BC604TRN = 150
     AND A.BC604FCH >= TRUNC(SYSDATE - 1, 'MM') --('01112020', 'ddmmyyyy')
     AND A.BC605TREG = 100
     AND A.BC604FCH <= TRUNC(SYSDATE - 1);

  IF N_CONT > 0 THEN

    EXECUTE IMMEDIATE 'create table operador.FBC605_' ||
                      TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) ||
                      ' as select * from FBC605 A where A.BC604MOD = 93
   AND A.BC604TRN = 150 AND A.BC604FCH >= TRUNC(SYSDATE,''MM'')-1 AND A.BC605TREG = 100 AND A.BC604FCH <= TRUNC(SYSDATE)';

    DELETE FROM FBC605 A
     WHERE A.BC604MOD = 93
       AND A.BC604TRN = 150
       AND A.BC604FCH >= TRUNC(SYSDATE - 1, 'MM')
       AND A.BC605TREG = 100
       AND A.BC604FCH <= TRUNC(SYSDATE - 1); ---X REGS

    COMMIT;
  END IF;
insert into AQPB876 values (user,sysdate,'SP_CR_FBC605_TRAMITANTE', '');
commit;                                                                                                                              
END SP_CR_FBC605_TRAMITANTE;
/

