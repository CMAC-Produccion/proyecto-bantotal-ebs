create or replace package USRECOSISTEMAS.PKG_USERCUSTOMER is

  type USR_CURSOR_USERCUSTOMER IS REF CURSOR;
  
  PROCEDURE USR_USERCUSTOMER_PAGINATED(psearch in VARCHAR2 ,puserid in NUMBER,prow IN NUMBER, ptotalRecord IN NUMBER,cursorOut OUT USR_CURSOR_USERCUSTOMER);
  PROCEDURE USR_USERCUSTOMER_GETBYID(pid in NUMBER,cursorOut OUT USR_CURSOR_USERCUSTOMER);
  PROCEDURE USR_USERCUSTOMER_INSERT(
  puserid IN NUMBER,
  pfirstname IN VARCHAR2,
  plastname IN VARCHAR2,
  pcellphone IN VARCHAR2,
  pemail IN VARCHAR2,
  pdocumenttypeid IN NUMBER,
  pdocumentnumber IN VARCHAR2,
  pcommentary IN VARCHAR2,
  pstatusid IN NUMBER,
  pcreatedby IN NUMBER,
  IDOUT out NUMBER);
  PROCEDURE USR_USERCUSTOMER_UPDATE(
  pid IN NUMBER,
  pfirstname IN VARCHAR2,
  plastname IN VARCHAR2,
  pcellphone IN VARCHAR2,
  pemail IN VARCHAR2,
  pdocumenttypeid IN NUMBER,
  pdocumentnumber IN VARCHAR2,
  pcommentary IN VARCHAR2,
  pstatusid IN NUMBER,
  pupdatedby IN NUMBER,
  rowsOut out NUMBER);
  PROCEDURE USR_USERCUSTOMER_UPDATESTATUS(
  pid IN NUMBER,
  pstatusid IN NUMBER,
  pupdatedby IN NUMBER,
  rowsOut out NUMBER); 
  PROCEDURE USR_USERCUSTOMER_EXIST_NAME(pname in VARCHAR2,puserid in NUMBER,cursorOut OUT USR_CURSOR_USERCUSTOMER);
PROCEDURE USR_USERCUSTOMER_GETBYCELLPHONE(pcellphone IN VARCHAR2,puserid IN NUMBER,cursorOut OUT USR_CURSOR_USERCUSTOMER);
PROCEDURE SEC_EXIST_EMAIL_USERCUSTOMER(pemail IN VARCHAR2, puserid IN NUMBER,cursorEmailOut OUT USR_CURSOR_USERCUSTOMER);
PROCEDURE SEC_EXIST_DOCNUMBER_USERCUSTOMER(pdocnumber IN VARCHAR2, puserid IN NUMBER,cursordocNumberlOut OUT USR_CURSOR_USERCUSTOMER);

end PKG_USERCUSTOMER;
/
create or replace PACKAGE BODY USRECOSISTEMAS.PKG_USERCUSTOMER IS
PROCEDURE USR_USERCUSTOMER_PAGINATED(
    psearch IN VARCHAR2,
    puserid IN NUMBER,
    prow IN NUMBER,
    ptotalRecord IN NUMBER,
    cursorOut OUT USR_CURSOR_USERCUSTOMER)
IS
BEGIN
    OPEN cursorOut FOR
    WITH UserCustomer_GetAll AS (
        SELECT
            pr.id,
            pr.userid,
            (UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(pr.firstname))) || ' ' || 
             UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(pr.lastname)))) AS FullName,
            UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(pr.firstname))) AS firstname,
            UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(pr.lastname))) AS lastname,
            UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(pr.cellphone))) AS cellphone,
            UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(pr.email))) AS email,
            pr.documenttypeid,
            UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(pr.documentnumber))) AS documentnumber,
            UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(pr.commentary))) AS commentary,
            pr.statusid,
            pr.createddate,
            ROW_NUMBER() OVER (ORDER BY pr.createddate DESC) AS NroRow
        FROM
            usercustomer pr
        WHERE
            pr.userid = puserid AND
            pr.statusid = 1 AND
            (
            LOWER(UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(pr.firstname)))) LIKE LOWER('%' || psearch) OR
            LOWER(UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(pr.lastname)))) LIKE LOWER('%' || psearch) OR
            LOWER((UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(pr.firstname))) || ' ' || 
             UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(pr.lastname))))) LIKE LOWER('%' || psearch) OR
            LOWER(UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(pr.email)))) LIKE LOWER('%' || psearch) OR
            LOWER(UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(pr.documentnumber)))) LIKE LOWER('%' || psearch) OR
            LOWER(UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(pr.commentary)))) LIKE LOWER('%' || psearch))
    )
    SELECT
        id,
        userid,
        fullname,
        firstname,
        lastname,
        cellphone,
        email,
        documenttypeid,
        documentnumber,
        commentary,
        statusid,
        createddate,
        NroRow,
        (SELECT count(*) FROM UserCustomer_GetAll) AS TotalRow
    FROM
        UserCustomer_GetAll
    WHERE
        NroRow >= ((pRow - 1) * pTotalRecord) + 1 AND
        NroRow <= (pRow * pTotalRecord)
    ORDER BY
        createddate DESC, NroRow;
END USR_USERCUSTOMER_PAGINATED;


PROCEDURE USR_USERCUSTOMER_GETBYID(pid in NUMBER,cursorOut OUT USR_CURSOR_USERCUSTOMER)
IS
BEGIN
  OPEN cursorOut FOR
  select
    pr.id,
    pr.userid,
    UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(pr.firstname))) as firstname,
    UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(pr.lastname))) as lastname,
    UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(pr.cellphone))) as cellphone,
    UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(pr.email))) as email,
    pr.documenttypeid,
    UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(pr.documentnumber))) as documentnumber,
    UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(pr.commentary))) as commentary,
    pr.statusid,
    pr.createddate,
    CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM revenue r 
            WHERE r.usercustomerid = pr.id 
            AND r.statusid = 1 
            AND r.typeincometransaction = 2 
            AND (r.unitprice > 0 AND NOT EXISTS (
                SELECT 1 
                FROM revenuecredit rc 
                WHERE rc.revenueid = r.id 
                AND rc.amount = r.unitprice
            ))
        ) THEN 1 
        ELSE 0 
    END AS hasDebt
    from usercustomer pr
    where pr.id=pid;
END USR_USERCUSTOMER_GETBYID;
PROCEDURE USR_USERCUSTOMER_INSERT(
  puserid IN NUMBER,
  pfirstname IN VARCHAR2,
  plastname IN VARCHAR2,
  pcellphone IN VARCHAR2,
  pemail IN VARCHAR2,
  pdocumenttypeid IN NUMBER,
  pdocumentnumber IN VARCHAR2,
  pcommentary IN VARCHAR2,
  pstatusid IN NUMBER,
  pcreatedby IN NUMBER,
  IDOUT out NUMBER)
IS
BEGIN
  INSERT INTO USERCUSTOMER (
   USERID
  ,FIRSTNAME
  ,LASTNAME
  ,CELLPHONE
  ,EMAIL
  ,DOCUMENTTYPEID
  ,DOCUMENTNUMBER
  ,COMMENTARY
  ,STATUSID
  ,CREATEDBY
  ,CREATEDDATE
  )  
  VALUES 
  (
   puserid
  ,UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(pfirstname)))
  ,UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(plastname)))
  ,UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(pcellphone)))
  ,UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(pemail)))
  ,pdocumenttypeid
  ,UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(pdocumentnumber)))
  ,UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(NVL(pcommentary, ' '))))
  ,pstatusid
  ,pcreatedby 
  ,SYSDATE)
  returning ID into IDOUT;
  COMMIT; 
  EXCEPTION
  WHEN OTHERS THEN
  ROLLBACK;
  RAISE;
END USR_USERCUSTOMER_INSERT;
PROCEDURE USR_USERCUSTOMER_UPDATE(
  pid IN NUMBER,
  pfirstname IN VARCHAR2,
  plastname IN VARCHAR2,
  pcellphone IN VARCHAR2,
  pemail IN VARCHAR2,
  pdocumenttypeid IN NUMBER,
  pdocumentnumber IN VARCHAR2,
  pcommentary IN VARCHAR2,
  pstatusid IN NUMBER,
  pupdatedby IN NUMBER,
  rowsOut out NUMBER)
IS
BEGIN
  UPDATE USERCUSTOMER SET 
  FIRSTNAME=UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(NVL(pfirstname, ' ')))),
  LASTNAME=UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(NVL(plastname, ' ')))),
  CELLPHONE=UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(NVL(pcellphone, ' ')))),
  EMAIL=UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(NVL(pemail, ' ')))),
  DOCUMENTTYPEID=pdocumenttypeid,
  DOCUMENTNUMBER=UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(NVL(pdocumentnumber, ' ')))),
  COMMENTARY=UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(NVL(pcommentary, ' ')))),
  STATUSID = pstatusid,
  UPDATEDBY = pupdatedby, 
  UPDATEDDATE = sysdate WHERE ID = pid;
  rowsOut := SQL%rowcount; 
 COMMIT;
END USR_USERCUSTOMER_UPDATE;
PROCEDURE USR_USERCUSTOMER_UPDATESTATUS(
  pid IN NUMBER,
  pstatusid IN NUMBER,
  pupdatedby IN NUMBER,
  rowsOut out NUMBER)
IS
BEGIN
  UPDATE USERCUSTOMER SET 
  STATUSID = pstatusid,
  UPDATEDBY = pupdatedby, 
  UPDATEDDATE = sysdate WHERE ID = pid;
  rowsOut := SQL%rowcount; 
 COMMIT;
END USR_USERCUSTOMER_UPDATESTATUS;
PROCEDURE USR_USERCUSTOMER_EXIST_NAME(pname in VARCHAR2, puserid in NUMBER,cursorOut OUT USR_CURSOR_USERCUSTOMER)
IS
BEGIN 
 OPEN cursorOut FOR 
select count(1) from UserCustomer where lower(UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(firstname))) || ' ' || 
UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(lastname)))) = lower(pname)
and userid = puserid
and statusid = 1;
END USR_USERCUSTOMER_EXIST_NAME;
PROCEDURE USR_USERCUSTOMER_GETBYCELLPHONE(pcellphone IN VARCHAR2, puserid in NUMBER,cursorOut OUT USR_CURSOR_USERCUSTOMER)
IS 
BEGIN
  OPEN cursorOut FOR
  SELECT  
    id,
    userid,
    UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(firstname))) as firstname,
    UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(lastname))) as lastname,
    UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(cellphone))) as cellphone,
    UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(email))) as email,
    documenttypeid,
    UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(documentnumber))) as documentnumber,
    UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(commentary))) as commentary,
    statusid,
    createddate
  FROM USERCUSTOMER 
  WHERE USERID = puserid AND  STATUSID = 1 and 
  UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(CELLPHONE)))=pcellphone
  ORDER BY FIRSTNAME ASC;
END USR_USERCUSTOMER_GETBYCELLPHONE;
PROCEDURE SEC_EXIST_EMAIL_USERCUSTOMER(pemail in VARCHAR2, puserid IN NUMBER, cursorEmailOut OUT USR_CURSOR_USERCUSTOMER)
IS
BEGIN 
    OPEN cursorEmailOut FOR
    SELECT COUNT(1) from USERCUSTOMER WHERE trim(UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(EMAIL)))) = trim(pemail) AND USERID = puserid;
END SEC_EXIST_EMAIL_USERCUSTOMER;

PROCEDURE SEC_EXIST_DOCNUMBER_USERCUSTOMER(pdocnumber in VARCHAR2, puserid IN NUMBER, cursordocNumberlOut OUT USR_CURSOR_USERCUSTOMER)
IS
BEGIN
    OPEN cursordocNumberlOut FOR 
    SELECT COUNT(1) from USERCUSTOMER WHERE trim(DOCUMENTNUMBER) = trim(UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(pdocnumber)))) AND USERID = puserid;
END SEC_EXIST_DOCNUMBER_USERCUSTOMER;

END PKG_USERCUSTOMER;
/