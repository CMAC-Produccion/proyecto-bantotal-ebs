create or replace package USRECOSISTEMAS.PKG_ARROBA is

  TYPE CURSOR_ARROBA IS REF CURSOR;
  PROCEDURE ARR_ARROBAMAILQUEUE_GETALLPENDING(cursorOut OUT CURSOR_ARROBA);
  PROCEDURE ARR_ARROBAMAILQUEUE_INSERT(
  papporigin IN VARCHAR2,
  pprocessorigin IN VARCHAR2,
  pmailfrom IN VARCHAR2,
  pmailfromalias IN VARCHAR2,
  pmailsubject IN VARCHAR2,
  pmailto IN VARCHAR2,
  pmailcc IN VARCHAR2,
  pmailbcc IN VARCHAR2,
  pmailbodyhtml IN CLOB,
  pstatusid IN NUMBER,
  pcreatedby IN NUMBER,
  IDOUT out NUMBER);
  PROCEDURE ARR_ARROBAMAILQUEUE_INSERTXML(parrobaqueues IN XMLTYPE,rowsOut OUT NUMBER);
  PROCEDURE ARR_ARROBAMAILQUEUE_UPDATEXML(parrobaqueues IN XMLTYPE,rowsOut OUT NUMBER);
end PKG_ARROBA;

/
create or replace PACKAGE BODY USRECOSISTEMAS.PKG_ARROBA IS

PROCEDURE ARR_ARROBAMAILQUEUE_GETALLPENDING(cursorOut OUT CURSOR_ARROBA)
IS
BEGIN
  OPEN cursorOut FOR
    SELECT * FROM (
      SELECT *
      FROM ArrobaMailQueue
      WHERE STATUSID = 1 
        AND SendStatus IN ('N', 'E') 
        AND MailRetry < 3
      ORDER BY CreatedDate ASC
    ) WHERE ROWNUM <= 50;
END ARR_ARROBAMAILQUEUE_GETALLPENDING;
PROCEDURE ARR_ARROBAMAILQUEUE_INSERT(
  papporigin IN VARCHAR2,
  pprocessorigin IN VARCHAR2,
  pmailfrom IN VARCHAR2,
  pmailfromalias IN VARCHAR2,
  pmailsubject IN VARCHAR2,
  pmailto IN VARCHAR2,
  pmailcc IN VARCHAR2,
  pmailbcc IN VARCHAR2,
  pmailbodyhtml IN CLOB,
  pstatusid IN NUMBER,
  pcreatedby IN NUMBER,
  IDOUT out NUMBER)
IS
BEGIN
  INSERT INTO ARROBAMAILQUEUE (
  APPORIGIN
 ,PROCESSORIGIN
 ,MAILFROM
 ,MAILFROMALIAS
 ,MAILSUBJECT
 ,MAILTO
 ,MAILCC
 ,MAILBCC
 ,MAILBODYHTML
 ,SENDSTATUS
 ,MAILRETRY
 ,STATUSID
 ,CREATEDBY
 ,CREATEDDATE
)  
VALUES
(
 papporigin
,pprocessorigin
,pmailfrom
,pmailfromalias
,pmailsubject
,pmailto
,pmailcc
,pmailbcc
,pmailbodyhtml
,'N'
,0
,pstatusid
,pcreatedby
,SYSDATE
)
returning ID into IDOUT;
COMMIT; 
END ARR_ARROBAMAILQUEUE_INSERT;
PROCEDURE ARR_ARROBAMAILQUEUE_INSERTXML(parrobaqueues IN XMLTYPE,rowsOut OUT NUMBER)
  IS
    rows_updated NUMBER := 0;

    CURSOR c_arrobamailqueues IS
        SELECT x.apporigin, x.processorigin, x.mailfrom, x.mailfromalias, x.mailsubject, x.mailto, x.mailcc, x.mailbcc, x.mailbodyhtml, x.userid 
        FROM XMLTABLE('/arrobamailqueues/arrobamailqueue' PASSING parrobaqueues
            COLUMNS 
                apporigin VARCHAR2(500) PATH 'apporigin',
                processorigin VARCHAR2(200) PATH 'processorigin',
                mailfrom VARCHAR2(100) PATH 'mailfrom',
                mailfromalias VARCHAR2(100) PATH 'mailfromalias',
                mailsubject VARCHAR2(500) PATH 'mailsubject',
                mailto VARCHAR2(500) PATH 'mailto',
                mailcc VARCHAR2(500) PATH 'mailcc',
                mailbcc VARCHAR2(500) PATH 'mailbcc',
                mailbodyhtml CLOB PATH 'mailbodyhtml',
                userid  NUMBER PATH 'userid'
        ) x;

BEGIN
    FOR cat IN c_arrobamailqueues LOOP
        INSERT INTO ARROBAMAILQUEUE (
  APPORIGIN
 ,PROCESSORIGIN
 ,MAILFROM
 ,MAILFROMALIAS
 ,MAILSUBJECT
 ,MAILTO
 ,MAILCC
 ,MAILBCC
 ,MAILBODYHTML
 ,SENDSTATUS
 ,MAILRETRY
 ,STATUSID
 ,CREATEDBY
 ,CREATEDDATE
 ,USERID
)  
VALUES
(
 cat.apporigin
,cat.processorigin
,cat.mailfrom
,cat.mailfromalias
,cat.mailsubject
,cat.mailto
,cat.mailcc
,cat.mailbcc
,cat.mailbodyhtml
,'N'
,0
,1
,99
 ,SYSDATE
 ,cat.userid
 );
        rows_updated := rows_updated + SQL%ROWCOUNT;
    END LOOP;
    rowsOut := rows_updated;
    commit;
END ARR_ARROBAMAILQUEUE_INSERTXML;
PROCEDURE ARR_ARROBAMAILQUEUE_UPDATEXML(parrobaqueues IN XMLTYPE,rowsOut OUT NUMBER)
IS
    rows_updated NUMBER := 0;

    CURSOR c_arrobamailqueues IS
        SELECT x.id, x.sendStatus, x.mailRetry, x.jsonResponseExternalProvider 
        FROM XMLTABLE('/arrobamailqueues/arrobamailqueue' PASSING parrobaqueues
            COLUMNS 
                id NUMBER PATH 'id',
                sendstatus VARCHAR2(1) PATH 'sendStatus',
                mailretry  NUMBER PATH 'mailRetry',
                jsonResponseExternalProvider VARCHAR(4000) PATH 'jsonResponseExternalProvider'
        ) x;

BEGIN
    FOR cat IN c_arrobamailqueues LOOP
        UPDATE arrobamailqueue SET sendstatus = cat.sendstatus, mailretry=cat.mailretry,jsonResponseExternalProvider=cat.jsonResponseExternalProvider, updatedby=99, updateddate = sysdate, senddate=sysdate 
        WHERE id = cat.id;
        rows_updated := rows_updated + SQL%ROWCOUNT;
    END LOOP;
    rowsOut := rows_updated;
    commit;  
END ARR_ARROBAMAILQUEUE_UPDATEXML;

END PKG_ARROBA;
/