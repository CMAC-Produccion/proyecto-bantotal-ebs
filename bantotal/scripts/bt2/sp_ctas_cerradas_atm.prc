CREATE OR REPLACE PROCEDURE SP_CTAS_CERRADAS_ATM IS

  N_CONT1 NUMBER := 0;
  N_CONT2 NUMBER := 0;
  N_CONT3 NUMBER := 0;
  N_CONT4 NUMBER := 0;

BEGIN

  SELECT COUNT(*)
    INTO N_CONT1
    FROM Z0E479
   WHERE Z0E479EST <> 'BA'
     AND Z0E479MOD = 21
     AND (Z0E479SUC, Z0E479CTA, Z0E479SCT, Z0E479TOP, Z0E479MON) IN
         (SELECT SCSUC, SCCTA, SCSBOP, SCTOPE, SCMDA
            FROM FSD011
           WHERE PGCOD = 1
             AND SCMOD = 21
             AND SCSTAT = 99);

  SELECT COUNT(*)
    INTO N_CONT2
    FROM Z0E482
   WHERE Z0E482EST <> 'BA'
     AND Z0E482MOD = 21
     AND (Z0E482SUC, Z0E482CTA, Z0E482SCT, Z0E482TOP, Z0E482MON) IN
         (SELECT SCSUC, SCCTA, SCSBOP, SCTOPE, SCMDA
            FROM FSD011
           WHERE PGCOD = 1
             AND SCMOD = 21
             AND SCSTAT = 99);

  SELECT COUNT(*)
    INTO N_CONT3
    FROM Z0E479
   WHERE Z0E479EST <> 'BA'
     AND Z0E479MOD = 22
     AND (Z0E479SUC, Z0E479CTA, Z0E479OPE, Z0E479MON) NOT IN
         (SELECT SCSUC, SCCTA, SCOPER, SCMDA
            FROM FSD011
           WHERE PGCOD = 1
             AND SCMOD = 22);

  SELECT COUNT(*)
    INTO N_CONT4
    FROM Z0E482
   WHERE Z0E482EST <> 'BA'
     AND Z0E482MOD = 22
     AND (Z0E482SUC, Z0E482CTA, Z0E482OPE, Z0E482MON) NOT IN
         (SELECT SCSUC, SCCTA, SCOPER, SCMDA
            FROM FSD011
           WHERE PGCOD = 1
             AND SCMOD = 22);

  IF N_CONT1 <> 0 THEN
    EXECUTE IMMEDIATE 'create table operador.Z0E479_' ||
                      TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) || ' as select * from Z0E479 ' ||
                      'WHERE Z0E479EST<> ''BA'' AND Z0E479MOD=21 AND (Z0E479SUC, Z0E479CTA, Z0E479SCT, Z0E479TOP,Z0E479MON) IN (
SELECT SCSUC, SCCTA, SCSBOP, SCTOPE, SCMDA FROM FSD011 WHERE PGCOD=1 AND SCMOD=21 AND SCSTAT=99)';
  
    delete from z0e479
     where Z0E479EST <> 'BA'
       and Z0E479MOD = 21
       and (Z0E479SUC, Z0E479CTA, Z0E479SCT, Z0E479TOP, Z0E479MON) in
           (select SCSUC, SCCTA, SCSBOP, SCTOPE, scmda
              from fsd011
             where pgcod = 1
               and scmod = 21
               and scstat = 99);
    COMMIT;
  END IF;

  IF N_CONT2 <> 0 THEN
    EXECUTE IMMEDIATE 'create table operador.z0e482_' ||
                      TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) || ' as select * from z0e482 ' ||
                      'WHERE Z0E482EST<> ''BA'' AND Z0E482MOD=21 AND (Z0E482SUC, Z0E482CTA, Z0E482SCT, Z0E482TOP,Z0E482MON) IN (
		SELECT SCSUC, SCCTA, SCSBOP, SCTOPE, SCMDA FROM FSD011 WHERE PGCOD=1 AND SCMOD=21 AND SCSTAT=99)';
  
    delete from z0e482
     where Z0E482EST <> 'BA'
       and Z0E482MOD = 21
       and (Z0E482SUC, Z0E482CTA, Z0E482SCT, Z0E482TOP, Z0E482MON) in
           (select SCSUC, SCCTA, SCSBOP, SCTOPE, scmda
              from fsd011
             where pgcod = 1
               and scmod = 21
               and scstat = 99);
    COMMIT;
  END IF;

  IF N_CONT3 <> 0 THEN
    EXECUTE IMMEDIATE 'create table operador.Z0E479_' ||
                      TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) || ' as select * from Z0E479 ' ||
                      'WHERE Z0E479EST<> ''BA'' AND Z0E479MOD=22 AND (Z0E479SUC, Z0E479CTA, Z0E479OPE, Z0E479MON) NOT IN (
		SELECT SCSUC, SCCTA, SCOPER, SCMDA FROM FSD011 WHERE PGCOD=1 AND SCMOD=22 )';
  
    delete from z0e479
     where Z0E479EST <> 'BA'
       and Z0E479MOD = 22
       and (Z0E479SUC, Z0E479CTA, Z0E479ope, Z0E479MON) not in
           (select SCSUC, SCCTA, scoper, scmda
              from fsd011
             where pgcod = 1
               and scmod = 22);
    COMMIT;
  END IF;

  IF N_CONT4 <> 0 THEN
    EXECUTE IMMEDIATE 'create table operador.z0e482_' ||
                      TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) || ' as select * from z0e482 ' ||
                      'WHERE Z0E482EST<> ''BA'' AND Z0E482MOD=22 AND (Z0E482SUC, Z0E482CTA, Z0E482OPE, Z0E482MON) NOT IN (
		SELECT SCSUC, SCCTA, SCOPER, SCMDA FROM FSD011 WHERE PGCOD=1 AND SCMOD=22 )';
  
    delete from z0e482
     where Z0E482EST <> 'BA'
       and Z0E482MOD = 22
       and (Z0E482SUC, Z0E482CTA, Z0E482ope, Z0E482MON) not in
           (select SCSUC, SCCTA, scoper, scmda
              from fsd011
             where pgcod = 1
               and scmod = 22);
    COMMIT;
  END IF;

END SP_CTAS_CERRADAS_ATM;
/

