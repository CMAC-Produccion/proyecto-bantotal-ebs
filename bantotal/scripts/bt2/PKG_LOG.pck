create or replace package USRECOSISTEMAS.PKG_LOG is

  TYPE CURSOR_LOG IS REF CURSOR;
  PROCEDURE LOG_AUDITHTTP_INSERT(
  papplicationname IN VARCHAR2,
  phttpstatuscode IN NUMBER,
  pschema IN VARCHAR2,
  phostport IN VARCHAR2,
  ppath IN VARCHAR2,
  pmethod IN VARCHAR2,
  prequestheader IN CLOB,
  prequestbody IN CLOB,
  presponseheader IN CLOB,
  presponsebody IN CLOB,
  ptraceidentifier IN VARCHAR2,
  pipaddress IN VARCHAR2,
  pduration IN INTERVAL DAY TO SECOND,
  pcreateddate IN DATE,
  IDOUT out NUMBER);
  PROCEDURE LOG_LOGHTTP_INSERT(
  papplicationname IN VARCHAR2,
  pcategory IN NUMBER,
  pcategorydescription IN VARCHAR2,
  phttpstatuscode IN NUMBER,
  pmessageuser IN CLOB,
  pexceptionmessage IN CLOB,
  pinnerexceptionmessage IN CLOB,
  ppath IN CLOB,
  pmethod IN VARCHAR2,
  phost IN VARCHAR2,
  pport IN VARCHAR2,
  phostport IN VARCHAR2,
  psource IN VARCHAR2,
  ptraceidentifier IN VARCHAR2,
  pcontenttype IN VARCHAR2,
  pipaddress IN VARCHAR2,
  prequestheader IN CLOB,
  prequestbody IN CLOB,
  pstacktrace IN CLOB,
  pcreateduser IN VARCHAR2,
  pcreateddate IN DATE,
  IDOUT out NUMBER);
  PROCEDURE LOG_AUDITHTTP_DELETE(rowsCount out NUMBER);
  PROCEDURE LOG_LOGHTTP_DELETE(rowsCount out NUMBER);
  PROCEDURE LOG_AUDITENDPOINT_DELETE(rowsCount out NUMBER);
  PROCEDURE LOG_LOGDB_DELETE(rowsCount out NUMBER);
  PROCEDURE LOG_LOGJOB_DELETE(rowsCount out NUMBER);
  PROCEDURE LOG_LOGJOB_INSERT(
  pjobname IN VARCHAR2,
  pstate IN VARCHAR2,
  ptraceidentifier IN VARCHAR2,
  pduration IN INTERVAL DAY TO SECOND,
  pexception IN CLOB,
  pinnerexception IN CLOB,
  pstacktrace IN CLOB,
  pdata IN CLOB,
  pmessage IN CLOB,
  pcreateddate IN DATE,
  IDOUT out NUMBER);
  PROCEDURE LOG_GETERRORINFO;
  PROCEDURE LOG_AUDITENDPOINT_INSERT(
  phttpstatuscode IN NUMBER,
  pretry IN NUMBER,
  pschema IN VARCHAR2,
  phostport IN VARCHAR2,
  ppath IN VARCHAR2,
  pmethod IN VARCHAR2,
  ptraceidentifier IN VARCHAR2,
  pduration IN INTERVAL DAY TO SECOND,
  prequestheader IN CLOB,
  prequestbody IN CLOB,
  presponseheader IN CLOB,
  presponsebody IN CLOB,
  pcreateddate IN DATE,
  IDOUT out NUMBER);
end PKG_LOG;

/
create or replace PACKAGE BODY USRECOSISTEMAS.PKG_LOG IS

PROCEDURE LOG_AUDITHTTP_INSERT(
  papplicationname IN VARCHAR2,
  phttpstatuscode IN NUMBER,
  pschema IN VARCHAR2,
  phostport IN VARCHAR2,
  ppath IN VARCHAR2,
  pmethod IN VARCHAR2,
  prequestheader IN CLOB,
  prequestbody IN CLOB,
  presponseheader IN CLOB,
  presponsebody IN CLOB,
  ptraceidentifier IN VARCHAR2,
  pipaddress IN VARCHAR2,
  pduration IN INTERVAL DAY TO SECOND,
  pcreateddate IN DATE,
  IDOUT out NUMBER)
  IS
BEGIN
  INSERT INTO AuditHttp (
  ApplicationName
 ,HttpStatusCode
 ,Schema
 ,HostPort
 ,Path
 ,Method
 ,RequestHeader
 ,RequestBody
 ,ResponseHeader
 ,ResponseBody
 ,TraceIdentifier
 ,IpAddress
 ,Duration
 ,CreatedDate
)  
VALUES
(
 papplicationname
,phttpstatuscode
,pschema
,phostport
,ppath
,pmethod
,prequestheader
,prequestbody
,presponseheader
,presponsebody
,ptraceidentifier
,pipaddress
,pduration
,pcreateddate
)
returning ID into IDOUT;
COMMIT; 
END LOG_AUDITHTTP_INSERT;

PROCEDURE LOG_LOGHTTP_INSERT(
  papplicationname IN VARCHAR2,
  pcategory IN NUMBER,
  pcategorydescription IN VARCHAR2,
  phttpstatuscode IN NUMBER,
  pmessageuser IN CLOB,
  pexceptionmessage IN CLOB,
  pinnerexceptionmessage IN CLOB,
  ppath IN CLOB,
  pmethod IN VARCHAR2,
  phost IN VARCHAR2,
  pport IN VARCHAR2,
  phostport IN VARCHAR2,
  psource IN VARCHAR2,
  ptraceidentifier IN VARCHAR2,
  pcontenttype IN VARCHAR2,
  pipaddress IN VARCHAR2,
  prequestheader IN CLOB,
  prequestbody IN CLOB,
  pstacktrace IN CLOB,
  pcreateduser IN VARCHAR2,
  pcreateddate IN DATE,
  IDOUT out NUMBER)
  IS
BEGIN
  INSERT INTO LogHttp (
  ApplicationName
 ,Category
 ,CategoryDescription
 ,HttpStatusCode
 ,MessageUser
 ,ExceptionMessage
 ,InnerExceptionMessage
 ,Path
 ,Method
 ,Host
 ,Port
 ,HostPort
 ,Source
 ,TraceIdentifier
 ,ContentType
 ,IpAddress
 ,RequestHeader
 ,RequestBody
 ,StackTrace
 ,CreatedUser
 ,CreatedDate
)  
VALUES
(
 papplicationname,
  pcategory,
  pcategorydescription,
  phttpstatuscode,
  pmessageuser,
  pexceptionmessage,
  pinnerexceptionmessage,
  ppath,
  pmethod,
  phost,
  pport,
  phostport,
  psource,
  ptraceidentifier,
  pcontenttype,
  pipaddress,
  prequestheader,
  prequestbody,
  pstacktrace,
  pcreateduser,
  pcreateddate
)
returning ID into IDOUT;
COMMIT;  
END LOG_LOGHTTP_INSERT;
PROCEDURE LOG_AUDITHTTP_DELETE(rowsCount out NUMBER)
IS
 v_DaysOld   NUMBER:=7;
 v_CutOff    DATE;
BEGIN
    --SELECT TO_NUMBER(value2) INTO v_DaysOld
    --FROM mastertabledetail
    --WHERE mastertableid = 41 AND idparameter = 1;

    v_CutOff := TRUNC(SYSDATE - v_DaysOld);

    DELETE FROM AuditHttp
    WHERE TRUNC(CreatedDate) < v_CutOff;

    commit;

    rowsCount := SQL%ROWCOUNT;

  EXCEPTION
    WHEN OTHERS THEN
      rowsCount := -1;
      RAISE;
END LOG_AUDITHTTP_DELETE;
PROCEDURE LOG_LOGHTTP_DELETE(rowsCount out NUMBER)
IS
 v_DaysOld   NUMBER:=7;
 v_CutOff    DATE;
BEGIN
    --SELECT TO_NUMBER(value2) INTO v_DaysOld
    --FROM mastertabledetail
    --WHERE mastertableid = 41 AND idparameter = 1;

    v_CutOff := TRUNC(SYSDATE - v_DaysOld);

    DELETE FROM LogHttp
    WHERE TRUNC(CreatedDate) < v_CutOff;

    commit;

    rowsCount := SQL%ROWCOUNT;

  EXCEPTION
    WHEN OTHERS THEN
      rowsCount := -1;
      RAISE;
END LOG_LOGHTTP_DELETE;
PROCEDURE LOG_AUDITENDPOINT_DELETE(rowsCount out NUMBER)
IS
 v_DaysOld   NUMBER:=7;
 v_CutOff    DATE;
BEGIN
    --SELECT TO_NUMBER(value2) INTO v_DaysOld
    --FROM mastertabledetail
    --WHERE mastertableid = 41 AND idparameter = 1;

    v_CutOff := TRUNC(SYSDATE - v_DaysOld);

    DELETE FROM AuditEndpoint
    WHERE TRUNC(CreatedDate) < v_CutOff;

    commit;

    rowsCount := SQL%ROWCOUNT;

  EXCEPTION
    WHEN OTHERS THEN
      rowsCount := -1;
      RAISE;
END LOG_AUDITENDPOINT_DELETE;
PROCEDURE LOG_LOGDB_DELETE(rowsCount out NUMBER)
IS
 v_DaysOld   NUMBER:=7;
 v_CutOff    DATE;
BEGIN
    --SELECT TO_NUMBER(value2) INTO v_DaysOld
    --FROM mastertabledetail
    --WHERE mastertableid = 41 AND idparameter = 1;

    v_CutOff := TRUNC(SYSDATE - v_DaysOld);

    DELETE FROM LogDB
    WHERE TRUNC(CreatedDate) < v_CutOff;

    commit;

    rowsCount := SQL%ROWCOUNT;

  EXCEPTION
    WHEN OTHERS THEN
      rowsCount := -1;
      RAISE;
END LOG_LOGDB_DELETE;
PROCEDURE LOG_LOGJOB_DELETE(rowsCount out NUMBER)
IS
 v_DaysOld   NUMBER:=7;
 v_CutOff    DATE;
BEGIN
    --SELECT TO_NUMBER(value2) INTO v_DaysOld
    --FROM mastertabledetail
    --WHERE mastertableid = 41 AND idparameter = 1;

    v_CutOff := TRUNC(SYSDATE - v_DaysOld);

    DELETE FROM LogJob
    WHERE TRUNC(CreatedDate) < v_CutOff;

    commit;

    rowsCount := SQL%ROWCOUNT;

  EXCEPTION
    WHEN OTHERS THEN
      rowsCount := -1;
      RAISE;
END LOG_LOGJOB_DELETE;
PROCEDURE LOG_LOGJOB_INSERT(
  pjobname IN VARCHAR2,
  pstate IN VARCHAR2,
  ptraceidentifier IN VARCHAR2,
  pduration IN INTERVAL DAY TO SECOND,
  pexception IN CLOB,
  pinnerexception IN CLOB,
  pstacktrace IN CLOB,
  pdata IN CLOB,
  pmessage IN CLOB,
  pcreateddate IN DATE,
  IDOUT out NUMBER)
IS
BEGIN
Insert into LogJob(NameJob,StateJob,TraceIdentifier,Duration,Exception,InnerException,StackTrace,Data,Message,CreatedDate)
values(pjobname,pstate,ptraceidentifier,pduration,pexception,pinnerexception,pstacktrace,pdata,pmessage,pcreateddate)
returning ID into IDOUT;
COMMIT;   
END LOG_LOGJOB_INSERT;
PROCEDURE LOG_GETERRORINFO
IS
    v_error_procedure VARCHAR2(200);
    v_error_state NUMBER;
    v_error_number NUMBER;
    v_error_message VARCHAR2(1000);
    v_IdLogDB NUMBER;
    v_message VARCHAR2(200);
BEGIN
    v_error_procedure := SUBSTR(DBMS_UTILITY.format_error_backtrace, 1, 200);
    v_error_state := SQLCODE;
    v_error_number := SQLCODE;
    v_error_message := SQLERRM;

    INSERT INTO LogDB(
        ErrorNumber, 
        ErrorSeverity, 
        ErrorState, 
        ErrorProcedure, 
        ErrorLine,
        ErrorMessage, 
        CreatedDate
    )
    VALUES (
        v_error_number, 
        5,
        v_error_state, 
        v_error_procedure, 
        NULL,
        v_error_message, 
        SYSDATE
    )
    RETURNING ID INTO v_IdLogDB;

    commit;

    v_message := 'Error en ejecutar ' || v_error_procedure || ' verificar query para más detalles. Select * from LogDB where IdLogDB = ' || TO_CHAR(v_IdLogDB);

    RAISE_APPLICATION_ERROR(-20001, v_message);

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Error al registrar información de error: ' || SQLERRM);
END LOG_GETERRORINFO;
PROCEDURE LOG_AUDITENDPOINT_INSERT(
  phttpstatuscode IN NUMBER,
  pretry IN NUMBER,
  pschema IN VARCHAR2,
  phostport IN VARCHAR2,
  ppath IN VARCHAR2,
  pmethod IN VARCHAR2,
  ptraceidentifier IN VARCHAR2,
  pduration IN INTERVAL DAY TO SECOND,
  prequestheader IN CLOB,
  prequestbody IN CLOB,
  presponseheader IN CLOB,
  presponsebody IN CLOB,
  pcreateddate IN DATE,
  IDOUT out NUMBER)
IS
BEGIN
INSERT INTO AuditEndPoint (
  HttpStatusCode
 ,Retry
 ,Schema
 ,HostPort
 ,Path
 ,Method
 ,TraceIdentifier
 ,Duration
 ,RequestHeader
 ,RequestBody
 ,ResponseHeader
 ,ResponseBody
 ,CreatedDate
)  
VALUES
(
 phttpstatuscode
,pretry
,pschema
,phostport
,ppath
,pmethod
,ptraceidentifier
,pduration
,prequestheader
,prequestbody
,presponseheader
,presponsebody
,pcreateddate
)
returning ID into IDOUT;
COMMIT; 
END LOG_AUDITENDPOINT_INSERT;
END PKG_LOG;
/