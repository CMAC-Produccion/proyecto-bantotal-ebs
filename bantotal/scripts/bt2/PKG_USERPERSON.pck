create or replace PACKAGE USRECOSISTEMAS.PKG_USERPERSON IS

type USR_CURSOR_USERPERSON IS REF CURSOR;

PROCEDURE USR_USERSUPPLIER_GETBYUSER(puserid IN number,cursorOut OUT USR_CURSOR_USERPERSON);
PROCEDURE USR_USERGROUP_GETBYUSER(puserid IN number,cursorOut OUT USR_CURSOR_USERPERSON);
PROCEDURE USR_USERSUPPLIER_INSERT(
puserid IN NUMBER,
pname IN VARCHAR2,
pcellphone IN VARCHAR2,
phomephone IN VARCHAR2,
pemail IN VARCHAR2,
pdocumenttypeid IN NUMBER,
pdocumentnumber IN VARCHAR2,
pcomments IN VARCHAR2,
paddress IN VARCHAR2,
pdepartment IN VARCHAR2,
pdistrict IN VARCHAR2,
pcity IN VARCHAR2,
pstatusid IN NUMBER,
pcreatedby IN NUMBER,
IDOUT out NUMBER);
PROCEDURE USR_USERGROUP_INSERT(
puserid IN NUMBER,
pname IN VARCHAR2,
pstatusid IN NUMBER,
pcreatedby IN NUMBER,
IDOUT out NUMBER);
PROCEDURE USR_USERSUPPLIER_PAGINATED(pusersupplierid in NUMBER, pname in VARCHAR2 ,puserid in NUMBER,prow IN NUMBER, ptotalRecord IN NUMBER,cursorOut OUT USR_CURSOR_USERPERSON);
PROCEDURE USR_USERSUPPLIER_GETBYCELLPHONE(pcellphone IN VARCHAR2,cursorOut OUT USR_CURSOR_USERPERSON);
PROCEDURE USR_USERSUPPLIER_DETAIL(pid in NUMBER,cursorOut OUT USR_CURSOR_USERPERSON);
PROCEDURE USR_USERSUPPLIER_UPDATE(
pid IN NUMBER,
pname IN VARCHAR2,
pcellphone IN VARCHAR2,
phomephone IN VARCHAR2,
pemail IN VARCHAR2,
pdocumenttypeid IN NUMBER,
pdocumentnumber IN VARCHAR2,
pcomments IN VARCHAR2,
paddress IN VARCHAR2,
pdepartment IN VARCHAR2,
pdistrict IN VARCHAR2,
pcity IN VARCHAR2,
pstatusid IN NUMBER,
pupdatedby IN NUMBER,
rowsOut out NUMBER);
PROCEDURE USR_USERSUPPLIER_UPDATE_STATUS(
pid IN NUMBER,
pstatusid IN NUMBER,
pupdatedby IN NUMBER,
rowsOut out NUMBER);
PROCEDURE USR_USERSUPPLIER_EXIST_NAME(pname in VARCHAR2,cursorOut OUT USR_CURSOR_USERPERSON);
PROCEDURE USR_USERPERSON_AUTOCOMPLETE(pname in VARCHAR2,prows in NUMBER,pisshopper IN NUMBER,pisvendor IN NUMBER,cursorOut OUT USR_CURSOR_USERPERSON);
PROCEDURE USR_USERPERSON_SEARCH_VENDOR(ptop IN NUMBER,ptextsearch IN VARCHAR2, puserid IN NUMBER, cursorOut OUT USR_CURSOR_USERPERSON);
PROCEDURE USR_USERPERSON_ADMIN_PAGINATED(ptypeuser in NUMBER, pnrodocument in VARCHAR2 ,pemail in VARCHAR2,prow IN NUMBER, ptotalRecord IN NUMBER,cursorOut OUT USR_CURSOR_USERPERSON);
PROCEDURE USR_USERPERSON_ADMIN_GETBYID(puserid in NUMBER,cursorOut OUT USR_CURSOR_USERPERSON);
PROCEDURE USR_USERROL_GET(pstatus IN number,cursorOut OUT USR_CURSOR_USERPERSON);
PROCEDURE USR_USERPERMISION_GETBYROLID(prolid IN number, pmoduleid IN number,cursorOut OUT USR_CURSOR_USERPERSON);
END PKG_USERPERSON;
/
create or replace PACKAGE BODY USRECOSISTEMAS.PKG_USERPERSON IS
PROCEDURE USR_USERSUPPLIER_GETBYUSER(puserid IN number,cursorOut OUT USR_CURSOR_USERPERSON)
IS
BEGIN
  OPEN cursorOut FOR
  SELECT
  id,
  userid,
  UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(name))) AS name,
  UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(cellphone))) AS cellphone,
  UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(homephone))) AS homephone,
  UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(email))) AS email,
  UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(documentnumber))) AS documentnumber,
  UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(comments))) AS comments,
  UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(address))) AS address,
  UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(department))) AS department,
  UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(district))) AS district,
  UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(city))) AS city,
  statusid,
  createdby,
  createddate,
  updatedby,
  updateddate
  FROM USERSUPPLIER 
  WHERE STATUSID = 1 and USERID=puserid
  ORDER BY Name ASC;
END USR_USERSUPPLIER_GETBYUSER;

PROCEDURE USR_USERGROUP_GETBYUSER(puserid IN number,cursorOut OUT USR_CURSOR_USERPERSON)
IS
BEGIN
  OPEN cursorOut FOR
  SELECT * FROM USERGROUP WHERE STATUSID = 1 and USERID=puserid
  ORDER BY Name ASC;
END USR_USERGROUP_GETBYUSER;

PROCEDURE USR_USERSUPPLIER_INSERT( 
puserid IN NUMBER,
pname IN VARCHAR2,
pcellphone IN VARCHAR2,
phomephone IN VARCHAR2,
pemail IN VARCHAR2,
pdocumenttypeid IN NUMBER,
pdocumentnumber IN VARCHAR2,
pcomments IN VARCHAR2,
paddress IN VARCHAR2,
pdepartment IN VARCHAR2,
pdistrict IN VARCHAR2,
pcity IN VARCHAR2,
pstatusid IN NUMBER,
pcreatedby IN NUMBER,
IDOUT out NUMBER)
IS 

BEGIN
 
    INSERT INTO USERSUPPLIER (
USERID
,NAME
,CELLPHONE
,HOMEPHONE
,EMAIL
,DOCUMENTTYPEID
,DOCUMENTNUMBER
,COMMENTS
,ADDRESS
,DEPARTMENT
,DISTRICT
,CITY
,STATUSID
,CREATEDBY
,CREATEDDATE
)  
VALUES 
(
puserid
,UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(pname)))
,UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(NVL(pcellphone,' '))))
,UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(NVL(phomephone,' '))))
,UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(NVL(pemail,' '))))
,pdocumenttypeid
,UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(NVL(pdocumentnumber,' '))))
,UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(NVL(pcomments,' '))))
,UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(NVL(paddress,' '))))
,UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(NVL(pdepartment,' '))))
,UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(NVL(pdistrict,' '))))
,UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(NVL(pcity,' '))))
,pstatusid
,pcreatedby 
,SYSDATE)
  returning ID into IDOUT;
COMMIT; 
EXCEPTION
  WHEN OTHERS THEN
  ROLLBACK;
    RAISE;

END USR_USERSUPPLIER_INSERT;


PROCEDURE USR_USERGROUP_INSERT( 
puserid IN NUMBER,
pname IN VARCHAR2,
pstatusid IN NUMBER,
pcreatedby IN NUMBER,
IDOUT out NUMBER)
IS 

BEGIN
 
    INSERT INTO USERGROUP (
USERID
,NAME
,STATUSID
,CREATEDBY
,CREATEDDATE
)  
VALUES 
(
puserid
,pname
,pstatusid
,pcreatedby 
,SYSDATE)
  returning ID into IDOUT;
COMMIT; 
EXCEPTION
  WHEN OTHERS THEN
  ROLLBACK;
    RAISE;

END USR_USERGROUP_INSERT;

PROCEDURE USR_USERSUPPLIER_PAGINATED(pusersupplierid in NUMBER, pname in VARCHAR2 ,puserid in NUMBER,prow IN NUMBER, ptotalRecord IN NUMBER,cursorOut OUT USR_CURSOR_USERPERSON)
IS
BEGIN
 OPEN cursorOut FOR
 WITH UserSupplier_GetAll
 as
 (
 select id,
 name,
 row_number() over(order by createddate desc) as NroRow from
 (select 
    pr.id,
    UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(pr.name))) as name,
    pr.createddate
    from usersupplier pr 
    where lower(UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(pr.name)))) like lower(concat('%',pname)) and (pusersupplierid <= 0 or pr.id = pusersupplierid) and pr.userid = puserid and pr.statusid = 1))
    select id,name,NroRow,(select count(*) from UserSupplier_GetAll) as TotalRow from UserSupplier_GetAll where NroRow>=((pRow-1)*pTotalRecord)+1 and NroRow<=(pRow*pTotalRecord) order by name,nrorow;
END USR_USERSUPPLIER_PAGINATED;

PROCEDURE USR_USERSUPPLIER_GETBYCELLPHONE(pcellphone IN VARCHAR2,cursorOut OUT USR_CURSOR_USERPERSON)
IS
BEGIN
  OPEN cursorOut FOR
  SELECT * FROM USERSUPPLIER WHERE STATUSID = 1 and UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(CELLPHONE)))=pcellphone
  ORDER BY Name ASC;
END USR_USERSUPPLIER_GETBYCELLPHONE;

PROCEDURE USR_USERSUPPLIER_DETAIL(pid in NUMBER,cursorOut OUT USR_CURSOR_USERPERSON)
IS
BEGIN
 OPEN cursorOut FOR
select 
us.id,
UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(us.name))) as name,
NVL(UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(us.cellphone))),'-') as cellphone,
NVL(UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(us.homePhone))),'-') as homePhone,
NVL(UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(us.email))),'-') as email,
NVL(UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(us.documentnumber))),'-') as documentnumber,
NVL(us.documenttypeid,0) as documentTypeId,
NVL(param1.value1,'-') as typeDoc,
NVL(UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(us.address))),'-') as address,
NVL(UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(us.district))),'-')as district,
NVL(UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(us.department))),'-')as department,
NVL(UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(us.city))),'-') as city,
NVL(UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(us.comments))),'-') as comments
from usersupplier us left join mastertabledetail param1
on us.documenttypeid = param1.idparameter and param1.mastertableid = 9
where us.id = pid and us.statusid = 1;

END USR_USERSUPPLIER_DETAIL;

PROCEDURE USR_USERSUPPLIER_UPDATE(
pid IN NUMBER,
pname IN VARCHAR2,
pcellphone IN VARCHAR2,
phomephone IN VARCHAR2,
pemail IN VARCHAR2,
pdocumenttypeid IN NUMBER,
pdocumentnumber IN VARCHAR2,
pcomments IN VARCHAR2,
paddress IN VARCHAR2,
pdepartment IN VARCHAR2,
pdistrict IN VARCHAR2,
pcity IN VARCHAR2,
pstatusid IN NUMBER,
pupdatedby IN NUMBER,
rowsOut out NUMBER)
IS
BEGIN
  UPDATE usersupplier SET 
  name=UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(pname))),
  cellphone=UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(NVL(pcellphone, ' ')))),
  homephone=UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(NVL(phomephone, ' ')))),
  email=UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(NVL(pemail, ' ')))),
  documenttypeid=pdocumenttypeid,
  documentnumber=UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(NVL(pdocumentnumber, ' ')))),
  comments=UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(NVL(pcomments, ' ')))),
  address=UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(NVL(paddress, ' ')))),
  department=UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(NVL(pdepartment, ' ')))),
  district=UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(NVL(pdistrict, ' ')))),
  city=UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(NVL(pcity, ' ')))),
  statusid = pstatusid,
  UPDATEDBY = pupdatedby, 
  UPDATEDDATE = sysdate WHERE ID = pid;
rowsOut := SQL%rowcount; 
 COMMIT;
END USR_USERSUPPLIER_UPDATE;

PROCEDURE USR_USERSUPPLIER_UPDATE_STATUS(
pid IN NUMBER,
pstatusid IN NUMBER,
pupdatedby IN NUMBER,
rowsOut out NUMBER)
IS
BEGIN
  UPDATE usersupplier SET 
  statusid = pstatusid,
  UPDATEDBY = pupdatedby, 
  UPDATEDDATE = sysdate WHERE ID = pid;
rowsOut := SQL%rowcount; 
 COMMIT;
END USR_USERSUPPLIER_UPDATE_STATUS;

PROCEDURE USR_USERSUPPLIER_EXIST_NAME(pname in VARCHAR2,cursorOut OUT USR_CURSOR_USERPERSON)
IS
BEGIN
 OPEN cursorOut FOR
select count(1) from usersupplier where lower(UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_DECODE(UTL_RAW.CAST_TO_RAW(name)))) = lower(pname) and statusid = 1;
END USR_USERSUPPLIER_EXIST_NAME;

PROCEDURE USR_USERPERSON_AUTOCOMPLETE(pname in VARCHAR2,prows in NUMBER,pisshopper IN NUMBER,pisvendor IN NUMBER,cursorOut OUT USR_CURSOR_USERPERSON)
  IS
BEGIN
 OPEN cursorOut FOR
 select id,firstname,lastname from userperson
 where (lower(firstname) like lower(concat('%',pname)) or lower(lastname) like lower(concat('%',pname))) and statusid = 1 and isshopper=pisshopper and isvendor=pisvendor
 ORDER BY id
 OFFSET 0 ROWS FETCH NEXT prows ROWS ONLY;
END USR_USERPERSON_AUTOCOMPLETE;
PROCEDURE USR_USERPERSON_SEARCH_VENDOR(ptop IN NUMBER,ptextsearch IN VARCHAR2, puserid IN NUMBER, cursorOut OUT USR_CURSOR_USERPERSON)
IS
BEGIN
  OPEN cursorOut FOR
select
    pr.id,
    pr.firstname,
    pr.lastname,
    pr.cellphone,
    pr.email,
    pr.documenttypeid,
    pr.documentnumber
  FROM userperson pr   
  WHERE 
   1=1 and
    (lower(pr.firstname) like lower(concat('%',ptextsearch)) or 
    lower(pr.lastname) like lower(concat('%',ptextsearch)) 
    )
      and (puserid <= 0 or pr.id = puserid) 
   and pr.isvendor = 1 and rownum<=ptop;
END USR_USERPERSON_SEARCH_VENDOR;
PROCEDURE USR_USERPERSON_ADMIN_PAGINATED(ptypeuser in NUMBER, pnrodocument in VARCHAR2 ,pemail in VARCHAR2,prow IN NUMBER, ptotalRecord IN NUMBER,cursorOut OUT USR_CURSOR_USERPERSON)
IS
BEGIN
  OPEN cursorOut FOR
 WITH UserPerson_GetAll
 as
 (
 select id,firstname,lastname,documenttypeid,documentnumber,documenttype,email,cellphone,isshopper,isvendor,profile,createddate, row_number() over(order by createddate desc) as NroRow from
 (select 
    pr.id,
    pr.firstname,
    pr.lastname,
    pr.documenttypeid,
    pr.documentnumber,
    mtd.value1 as documenttype,
    pr.email,
    pr.cellphone,
    pr.isshopper,
    pr.isvendor,
    pr.createddate,
    pr.owncodereferral,
    (case when pr.isvendor=1 then 'Vendedor' else 'Comprador' end) as profile
    from userperson pr
    inner join mastertabledetail mtd on pr.documenttypeid=mtd.idparameter and mtd.mastertableid=9 
    where 
    ((lower(pr.documentnumber) like '%'||lower(pnrodocument)||'%') and
    (lower(pr.email) like '%'||lower(pemail)||'%')) 
    and (pr.isvendor = case when ptypeuser=1 then 1 else pr.isvendor end)
    and (pr.isshopper = case when ptypeuser=2 then 1 else pr.isshopper end)
    and pr.statusid = 1 and pr.isadmin=0))
    select id,firstname,lastname,documenttypeid,documentnumber,documenttype,email,cellphone,isshopper,isvendor,profile,createddate,NroRow,(select count(*) from UserPerson_GetAll) as TotalRow from UserPerson_GetAll where NroRow>=((pRow-1)*pTotalRecord)+1 and NroRow<=(pRow*pTotalRecord) order by nrorow;
END USR_USERPERSON_ADMIN_PAGINATED;
PROCEDURE USR_USERPERSON_ADMIN_GETBYID(puserid in NUMBER,cursorOut OUT USR_CURSOR_USERPERSON)
IS
BEGIN
  OPEN cursorOut FOR
  select 
    pr.id,
    pr.firstname,
    pr.lastname,
    pr.documenttypeid,
    pr.documentnumber,
    mtd.value1 as documenttype,
    pr.email,
    pr.cellphone,
    pr.isshopper,
    pr.isvendor,
    pr.createddate,
    pr.owncodereferral,
    (case when pr.isvendor=1 then 'Vendedor' else 'Comprador' end) as profile
    from userperson pr
    inner join mastertabledetail mtd on pr.documenttypeid=mtd.idparameter and mtd.mastertableid=9 
    where pr.id=puserid;
END USR_USERPERSON_ADMIN_GETBYID;
PROCEDURE USR_USERROL_GET(pstatus in NUMBER,cursorOut OUT USR_CURSOR_USERPERSON)
IS
BEGIN
  OPEN cursorOut FOR
  select 
    pr.id,
    pr.name,
    pr.description,
    pr.statusid
    from role pr
    where pr.statusid=pstatus;
END USR_USERROL_GET;
PROCEDURE USR_USERPERMISION_GETBYROLID(prolid IN number, pmoduleid IN number,cursorOut OUT USR_CURSOR_USERPERSON)
IS
BEGIN
  OPEN cursorOut FOR
  select 
    p.id,
    rp.rolid,
    p.moduleid,
    p.name,
    p.ordervalue,
    p.statusid
    from role r inner join rolepermission rp on r.id = rp.rolid
    inner join permissions p on p.id = rp.permissionid
    where rp.rolid = prolid and p.moduleid = pmoduleid and r.statusid=1 and rp.statusid= 1;
END USR_USERPERMISION_GETBYROLID; 
END PKG_USERPERSON;
/