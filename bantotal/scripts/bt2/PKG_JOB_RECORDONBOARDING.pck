create or replace PACKAGE USRECOSISTEMAS.PKG_JOB_RECORDONBOARDING is

type JOB_CURSOR IS REF CURSOR;

PROCEDURE JOB_USERPERSON_GETLASTDAY_TOINSTRUCTION(cursorOut OUT JOB_CURSOR,rowLimit IN NUMBER);
PROCEDURE JOB_USERPERSON_GETSEVENDAY_TOREFORCE(cursorOut OUT JOB_CURSOR,rowLimit IN NUMBER);
PROCEDURE JOB_USERPERSON_GETONEMONTH_TOBENEFITS(cursorOut OUT JOB_CURSOR,rowLimit IN NUMBER);
PROCEDURE JOB_USERPERSON_GETTWOMONTH_TOINCENTIVES(cursorOut OUT JOB_CURSOR,rowLimit IN NUMBER);
PROCEDURE JOB_USERPERSON_GETTHREEMONTH_TOLASTRECORDATION(cursorOut OUT JOB_CURSOR,rowLimit IN NUMBER);
PROCEDURE JOB_USERPERSON_GETWITHOUTSTORE_TOMERGE(cursorOut OUT JOB_CURSOR,rowLimit IN NUMBER);
PROCEDURE JOB_USERPERSON_GETWITHOUTPRODUCT_TOMERGE(cursorOut OUT JOB_CURSOR,rowLimit IN NUMBER);
PROCEDURE JOB_USERPERSON_GETWITHOUTREVENUE_TOMERGE(cursorOut OUT JOB_CURSOR,rowLimit IN NUMBER);
PROCEDURE JOB_USERJOBRECORDONBOARDING_INSERTXML(puserjobs IN XMLTYPE,rowsOut OUT NUMBER);

END PKG_JOB_RECORDONBOARDING;

/
create or replace PACKAGE BODY USRECOSISTEMAS.PKG_JOB_RECORDONBOARDING is

PROCEDURE JOB_USERPERSON_GETLASTDAY_TOINSTRUCTION(cursorOut OUT JOB_CURSOR,rowLimit IN NUMBER)
AS
BEGIN
    OPEN cursorOut FOR
    SELECT 
        up.id,
        up.firstname,
        up.lastname,
        up.moduleid,
        up.email,
        up.createddate
    FROM USERPERSON up
    WHERE up.statusid = 1
  AND up.createddate >= TRUNC(SYSDATE - 1)
  AND up.createddate < TRUNC(SYSDATE)
      AND up.id NOT IN (
          SELECT ujro.userid
          FROM UserJobRecorOnboarding ujro
          WHERE ujro.processorigin = 'ONBOARD_INSTRUCTION'
      )
    ORDER BY up.createddate ASC
    FETCH FIRST rowLimit ROWS ONLY;
END JOB_USERPERSON_GETLASTDAY_TOINSTRUCTION;
PROCEDURE JOB_USERPERSON_GETSEVENDAY_TOREFORCE(cursorOut OUT JOB_CURSOR,rowLimit IN NUMBER)
AS
BEGIN
  OPEN cursorOut FOR
  SELECT up.id,
       up.firstname,
       up.lastname,
       up.moduleid,
       up.email,
       up.createddate,
       ut.latest_token_date
FROM userperson up
LEFT JOIN (
    SELECT userid, MAX(createddate) AS latest_token_date
    FROM usertoken
    GROUP BY userid
) ut ON up.id = ut.userid
LEFT JOIN userselectmodulelogin usml
  ON up.id = usml.userid
  AND usml.createddate >= ut.latest_token_date + INTERVAL '7' DAY
LEFT JOIN UserJobRecorOnboarding ujro
  ON up.id = ujro.userid
  AND ujro.processorigin = 'ONBOARD_REFORCE'
WHERE ut.latest_token_date = TRUNC(SYSDATE) - INTERVAL '7' DAY
  AND ujro.userid IS NULL and up.statusid=1
ORDER BY up.createddate ASC
    FETCH FIRST rowLimit ROWS ONLY;
END JOB_USERPERSON_GETSEVENDAY_TOREFORCE;
PROCEDURE JOB_USERPERSON_GETONEMONTH_TOBENEFITS(cursorOut OUT JOB_CURSOR,rowLimit IN NUMBER)
AS
BEGIN
  OPEN cursorOut FOR
  SELECT up.id,
       up.firstname,
       up.lastname,
       up.moduleid,
       up.email,
       up.createddate,
       ut.latest_token_date
FROM userperson up
LEFT JOIN (
    SELECT userid, MAX(createddate) AS latest_token_date
    FROM usertoken
    GROUP BY userid
) ut ON up.id = ut.userid
LEFT JOIN userselectmodulelogin usml
  ON up.id = usml.userid
  AND usml.createddate >= ut.latest_token_date + INTERVAL '30' DAY
LEFT JOIN UserJobRecorOnboarding ujro
  ON up.id = ujro.userid
  AND ujro.processorigin = 'ONBOARD_BENEFITS'
WHERE ut.latest_token_date = TRUNC(SYSDATE) - INTERVAL '30' DAY
  AND ujro.userid IS NULL and up.statusid=1
ORDER BY up.createddate ASC
 FETCH FIRST rowLimit ROWS ONLY;
END JOB_USERPERSON_GETONEMONTH_TOBENEFITS;
PROCEDURE JOB_USERPERSON_GETTWOMONTH_TOINCENTIVES(cursorOut OUT JOB_CURSOR,rowLimit IN NUMBER)
AS
BEGIN
  OPEN cursorOut FOR
  SELECT up.id,
       up.firstname,
       up.lastname,
       up.moduleid,
       up.email,
       up.createddate,
       ut.latest_token_date
FROM userperson up
LEFT JOIN (
    SELECT userid, MAX(createddate) AS latest_token_date
    FROM usertoken
    GROUP BY userid
) ut ON up.id = ut.userid
LEFT JOIN userselectmodulelogin usml
  ON up.id = usml.userid
  AND usml.createddate >= ut.latest_token_date + INTERVAL '60' DAY
LEFT JOIN UserJobRecorOnboarding ujro
  ON up.id = ujro.userid
  AND ujro.processorigin = 'ONBOARD_INCENTIVES'
WHERE ut.latest_token_date = TRUNC(SYSDATE) - INTERVAL '60' DAY
  AND ujro.userid IS NULL and up.statusid=1
ORDER BY up.createddate ASC
FETCH FIRST rowLimit ROWS ONLY;  
END JOB_USERPERSON_GETTWOMONTH_TOINCENTIVES;
PROCEDURE JOB_USERPERSON_GETTHREEMONTH_TOLASTRECORDATION(cursorOut OUT JOB_CURSOR,rowLimit IN NUMBER)
AS
BEGIN
  OPEN cursorOut FOR
  SELECT up.id,
       up.firstname,
       up.lastname,
       up.moduleid,
       up.email,
       up.createddate,
       ut.latest_token_date
FROM userperson up
LEFT JOIN (
    SELECT userid, MAX(createddate) AS latest_token_date
    FROM usertoken
    GROUP BY userid
) ut ON up.id = ut.userid
LEFT JOIN userselectmodulelogin usml
  ON up.id = usml.userid
  AND usml.createddate >= ut.latest_token_date + INTERVAL '90' DAY
LEFT JOIN UserJobRecorOnboarding ujro
  ON up.id = ujro.userid
  AND ujro.processorigin = 'ONBOARD_LASTRECORDATION'
WHERE ut.latest_token_date = TRUNC(SYSDATE) - INTERVAL '90' DAY
  AND ujro.userid IS NULL and up.statusid=1
ORDER BY up.createddate ASC
FETCH FIRST rowLimit ROWS ONLY;
END JOB_USERPERSON_GETTHREEMONTH_TOLASTRECORDATION;
PROCEDURE JOB_USERPERSON_GETWITHOUTSTORE_TOMERGE(cursorOut OUT JOB_CURSOR, rowLimit IN NUMBER)
AS
BEGIN
  OPEN cursorOut FOR
  SELECT *
  FROM (
    SELECT up.id,
           up.firstname,
           up.lastname,
           up.moduleid,
           up.email,
           up.createddate,
           ujro.createddate AS sentlastprocess
    FROM userperson up
    INNER JOIN UserJobRecorOnboarding ujro
      ON up.id = ujro.userid
      AND ujro.processorigin = 'ONBOARD_REFORCE'
      LEFT JOIN UserJobRecorOnboarding ujro2
  ON up.id = ujro2.userid
  AND ujro2.processorigin = 'ONBOARD_WITHOUTSTOREMERGE'
    WHERE TRUNC(SYSDATE) = TRUNC(ujro.createddate) + INTERVAL '1' DAY
      AND NOT EXISTS (
          SELECT 1
          FROM store s
          WHERE s.userid = up.id
      ) AND ujro2.userid IS NULL and up.statusid=1
      
    UNION ALL
    
    SELECT up.id,
           up.firstname,
           up.lastname,
           up.moduleid,
           up.email,
           up.createddate,
           ujro.createddate AS sentlastprocess
    FROM userperson up
    INNER JOIN UserJobRecorOnboarding ujro
      ON up.id = ujro.userid
      AND ujro.processorigin = 'ONBOARD_BENEFITS'
      LEFT JOIN UserJobRecorOnboarding ujro2
  ON up.id = ujro2.userid
  AND ujro2.processorigin = 'ONBOARD_WITHOUTSTOREMERGE'
    WHERE TRUNC(SYSDATE) = TRUNC(ujro.createddate) + INTERVAL '1' DAY
      AND NOT EXISTS (
          SELECT 1
          FROM store s
          WHERE s.userid = up.id
      ) AND ujro2.userid IS NULL and up.statusid=1
      
     UNION ALL
     
     SELECT up.id,
           up.firstname,
           up.lastname,
           up.moduleid,
           up.email,
           up.createddate,
           ujro.createddate AS sentlastprocess
    FROM userperson up
    INNER JOIN UserJobRecorOnboarding ujro
      ON up.id = ujro.userid
      AND ujro.processorigin = 'ONBOARD_INCENTIVES'
      LEFT JOIN UserJobRecorOnboarding ujro2
  ON up.id = ujro2.userid
  AND ujro2.processorigin = 'ONBOARD_WITHOUTSTOREMERGE'
    WHERE TRUNC(SYSDATE) = TRUNC(ujro.createddate) + INTERVAL '1' DAY
      AND NOT EXISTS (
          SELECT 1
          FROM store s
          WHERE s.userid = up.id
      ) AND ujro2.userid IS NULL and up.statusid=1
      
      UNION ALL
     
     SELECT up.id,
           up.firstname,
           up.lastname,
           up.moduleid,
           up.email,
           up.createddate,
           ujro.createddate AS sentlastprocess
    FROM userperson up
    INNER JOIN UserJobRecorOnboarding ujro
      ON up.id = ujro.userid
      AND ujro.processorigin = 'ONBOARD_LASTRECORDATION'
      LEFT JOIN UserJobRecorOnboarding ujro2
  ON up.id = ujro2.userid
  AND ujro2.processorigin = 'ONBOARD_WITHOUTSTOREMERGE'
    WHERE TRUNC(SYSDATE) = TRUNC(ujro.createddate) + INTERVAL '1' DAY
      AND NOT EXISTS (
          SELECT 1
          FROM store s
          WHERE s.userid = up.id
      )  AND ujro2.userid IS NULL and up.statusid=1
  )
  ORDER BY createddate ASC
  FETCH FIRST rowLimit ROWS ONLY;
END JOB_USERPERSON_GETWITHOUTSTORE_TOMERGE;
PROCEDURE JOB_USERPERSON_GETWITHOUTPRODUCT_TOMERGE(cursorOut OUT JOB_CURSOR,rowLimit IN NUMBER)
AS
BEGIN
  OPEN cursorOut FOR
  SELECT *
  FROM (
     SELECT up.id,
           up.firstname,
           up.lastname,
           up.moduleid,
           up.email,
           up.createddate,
           ujro.createddate AS sentlastprocess
    FROM userperson up
    INNER JOIN UserJobRecorOnboarding ujro
      ON up.id = ujro.userid
      AND ujro.processorigin = 'ONBOARD_REFORCE'
      LEFT JOIN UserJobRecorOnboarding ujro2
  ON up.id = ujro2.userid
  AND ujro2.processorigin = 'ONBOARD_WITHOUTPRODUCTMERGE'
    WHERE TRUNC(SYSDATE) = TRUNC(ujro.createddate) + INTERVAL '1' DAY
      AND NOT EXISTS (
          SELECT 1
          FROM storeproduct stopro
          inner join store sto on stopro.storeid=sto.id
          WHERE sto.userid = up.id and stopro.statusid=1
      ) AND ujro2.userid IS NULL and up.statusid=1 and up.moduleid=1
      
      UNION ALL
      
      SELECT up.id,
           up.firstname,
           up.lastname,
           up.moduleid,
           up.email,
           up.createddate,
           ujro.createddate AS sentlastprocess
    FROM userperson up
    INNER JOIN UserJobRecorOnboarding ujro
      ON up.id = ujro.userid
      AND ujro.processorigin = 'ONBOARD_BENEFITS'
      LEFT JOIN UserJobRecorOnboarding ujro2
  ON up.id = ujro2.userid
  AND ujro2.processorigin = 'ONBOARD_WITHOUTPRODUCTMERGE'
    WHERE TRUNC(SYSDATE) = TRUNC(ujro.createddate) + INTERVAL '1' DAY
      AND NOT EXISTS (
          SELECT 1
          FROM storeproduct stopro
          inner join store sto on stopro.storeid=sto.id
          WHERE sto.userid = up.id and stopro.statusid=1
      ) AND ujro2.userid IS NULL and up.statusid=1 and up.moduleid=1
      
      UNION ALL
      
      SELECT up.id,
           up.firstname,
           up.lastname,
           up.moduleid,
           up.email,
           up.createddate,
           ujro.createddate AS sentlastprocess
    FROM userperson up
    INNER JOIN UserJobRecorOnboarding ujro
      ON up.id = ujro.userid
      AND ujro.processorigin = 'ONBOARD_INCENTIVES'
      LEFT JOIN UserJobRecorOnboarding ujro2
  ON up.id = ujro2.userid
  AND ujro2.processorigin = 'ONBOARD_WITHOUTPRODUCTMERGE'
    WHERE TRUNC(SYSDATE) = TRUNC(ujro.createddate) + INTERVAL '1' DAY
      AND NOT EXISTS (
          SELECT 1
          FROM storeproduct stopro
          inner join store sto on stopro.storeid=sto.id
          WHERE sto.userid = up.id and stopro.statusid=1
      ) AND ujro2.userid IS NULL and up.statusid=1 and up.moduleid=1
      
      UNION ALL
      
      SELECT up.id,
           up.firstname,
           up.lastname,
           up.moduleid,
           up.email,
           up.createddate,
           ujro.createddate AS sentlastprocess
    FROM userperson up
    INNER JOIN UserJobRecorOnboarding ujro
      ON up.id = ujro.userid
      AND ujro.processorigin = 'ONBOARD_LASTRECORDATION'
      LEFT JOIN UserJobRecorOnboarding ujro2
  ON up.id = ujro2.userid
  AND ujro2.processorigin = 'ONBOARD_WITHOUTPRODUCTMERGE'
    WHERE TRUNC(SYSDATE) = TRUNC(ujro.createddate) + INTERVAL '1' DAY
      AND NOT EXISTS (
          SELECT 1
          FROM storeproduct stopro
          inner join store sto on stopro.storeid=sto.id
          WHERE sto.userid = up.id and stopro.statusid=1
      ) AND ujro2.userid IS NULL and up.statusid=1 and up.moduleid=1
  )
  ORDER BY createddate ASC
  FETCH FIRST rowLimit ROWS ONLY;
END JOB_USERPERSON_GETWITHOUTPRODUCT_TOMERGE;
PROCEDURE JOB_USERPERSON_GETWITHOUTREVENUE_TOMERGE(cursorOut OUT JOB_CURSOR,rowLimit IN NUMBER)
AS
BEGIN
  OPEN cursorOut FOR
  SELECT *
  FROM (
      SELECT up.id,
           up.firstname,
           up.lastname,
           up.moduleid,
           up.email,
           up.createddate,
           ujro.createddate AS sentlastprocess
    FROM userperson up
    INNER JOIN UserJobRecorOnboarding ujro
      ON up.id = ujro.userid
      AND ujro.processorigin = 'ONBOARD_REFORCE'
      LEFT JOIN UserJobRecorOnboarding ujro2
  ON up.id = ujro2.userid
  AND ujro2.processorigin = 'ONBOARD_WITHOUTRENUEVEMERGE'
    WHERE TRUNC(SYSDATE) = TRUNC(ujro.createddate) + INTERVAL '1' DAY
      AND NOT EXISTS (
          SELECT 1
          FROM revenue rev
          inner join store sto on rev.storeid=sto.id
          WHERE sto.userid = up.id and sto.statusid=1
      ) AND ujro2.userid IS NULL and up.statusid=1 and up.moduleid=2
      
      UNION ALL
      
      SELECT up.id,
           up.firstname,
           up.lastname,
           up.moduleid,
           up.email,
           up.createddate,
           ujro.createddate AS sentlastprocess
    FROM userperson up
    INNER JOIN UserJobRecorOnboarding ujro
      ON up.id = ujro.userid
      AND ujro.processorigin = 'ONBOARD_BENEFITS'
      LEFT JOIN UserJobRecorOnboarding ujro2
  ON up.id = ujro2.userid
  AND ujro2.processorigin = 'ONBOARD_WITHOUTRENUEVEMERGE'
    WHERE TRUNC(SYSDATE) = TRUNC(ujro.createddate) + INTERVAL '1' DAY
      AND NOT EXISTS (
          SELECT 1
          FROM revenue rev
          inner join store sto on rev.storeid=sto.id
          WHERE sto.userid = up.id and sto.statusid=1
      ) AND ujro2.userid IS NULL and up.statusid=1 and up.moduleid=2
      
      UNION ALL
      
      SELECT up.id,
           up.firstname,
           up.lastname,
           up.moduleid,
           up.email,
           up.createddate,
           ujro.createddate AS sentlastprocess
    FROM userperson up
    INNER JOIN UserJobRecorOnboarding ujro
      ON up.id = ujro.userid
      AND ujro.processorigin = 'ONBOARD_INCENTIVES'
      LEFT JOIN UserJobRecorOnboarding ujro2
  ON up.id = ujro2.userid
  AND ujro2.processorigin = 'ONBOARD_WITHOUTRENUEVEMERGE'
    WHERE TRUNC(SYSDATE) = TRUNC(ujro.createddate) + INTERVAL '1' DAY
      AND NOT EXISTS (
          SELECT 1
          FROM revenue rev
          inner join store sto on rev.storeid=sto.id
          WHERE sto.userid = up.id and sto.statusid=1
      ) AND ujro2.userid IS NULL and up.statusid=1 and up.moduleid=2
      
      UNION ALL
      
      SELECT up.id,
           up.firstname,
           up.lastname,
           up.moduleid,
           up.email,
           up.createddate,
           ujro.createddate AS sentlastprocess
    FROM userperson up
    INNER JOIN UserJobRecorOnboarding ujro
      ON up.id = ujro.userid
      AND ujro.processorigin = 'ONBOARD_LASTRECORDATION'
      LEFT JOIN UserJobRecorOnboarding ujro2
  ON up.id = ujro2.userid
  AND ujro2.processorigin = 'ONBOARD_WITHOUTRENUEVEMERGE'
    WHERE TRUNC(SYSDATE) = TRUNC(ujro.createddate) + INTERVAL '1' DAY
      AND NOT EXISTS (
          SELECT 1
          FROM revenue rev
          inner join store sto on rev.storeid=sto.id
          WHERE sto.userid = up.id and sto.statusid=1
      ) AND ujro2.userid IS NULL and up.statusid=1 and up.moduleid=2
  )
  ORDER BY createddate ASC
  FETCH FIRST rowLimit ROWS ONLY;
END JOB_USERPERSON_GETWITHOUTREVENUE_TOMERGE;
PROCEDURE JOB_USERJOBRECORDONBOARDING_INSERTXML(puserjobs IN XMLTYPE,rowsOut OUT NUMBER)
IS
    rows_updated NUMBER := 0;

    CURSOR c_useronboardings IS
        SELECT x.userid, x.moduleid, x.processorigin
        FROM XMLTABLE('/useronboardings/useronboarding' PASSING puserjobs
            COLUMNS 
                userid NUMBER PATH 'userid',
                moduleid NUMBER PATH 'moduleid',
                processorigin VARCHAR2(100) PATH 'processorigin'
        ) x;

BEGIN
    FOR cat IN c_useronboardings LOOP
        INSERT INTO UserJobRecorOnboarding (
  USERID
 ,MODULEID
 ,PROCESSORIGIN
 ,STATUSID
 ,CREATEDBY
 ,CREATEDDATE
)  
VALUES
(
 cat.userid
,cat.moduleid
,cat.processorigin
,1
,99
 ,SYSDATE
 );
        rows_updated := rows_updated + SQL%ROWCOUNT;
    END LOOP;
    rowsOut := rows_updated;
    commit;
  
END JOB_USERJOBRECORDONBOARDING_INSERTXML;

END PKG_JOB_RECORDONBOARDING;

/