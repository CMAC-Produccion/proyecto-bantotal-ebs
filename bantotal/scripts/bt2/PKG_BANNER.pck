create or replace package USRECOSISTEMAS.PKG_BANNER is

  -- Author  : JHONATAN
  -- Created : 7/11/2023 12:03:16
  -- Purpose : 
  
  type BAN_CURSOR_BANNER IS REF CURSOR;
  
  PROCEDURE BAN_BANNER_GETALL_BYSECTION(
    pSection IN VARCHAR2,
    cursorOutBannerSection OUT BAN_CURSOR_BANNER,
    cursorOutBannerDetail OUT BAN_CURSOR_BANNER    
    );
    
    PROCEDURE BAN_BANNER_UPDATE(
pid IN NUMBER,
pbannerSectionID IN NUMBER,
pname IN VARCHAR2,
ptype IN NUMBER,
presourcedesktop IN VARCHAR2,
presourcemobile IN VARCHAR2,
plinkredirect IN VARCHAR2,
psort  IN NUMBER,
pstatusid IN NUMBER,
pupdatedby IN NUMBER,
IDOUT out NUMBER);

PROCEDURE BAN_BANNER_INSERT(
pbannerSectionID IN NUMBER,
pname IN VARCHAR2,
ptype IN NUMBER,
presourcedesktop IN VARCHAR2,
presourcemobile IN VARCHAR2,
plinkredirect IN VARCHAR2,
psort  IN NUMBER,
pstatusid IN NUMBER,
pcreatedby IN NUMBER,
IDOUT out NUMBER);

PROCEDURE BAN_BANNER_UPDATESTATUS(pid IN NUMBER, pstatusid IN NUMBER,pupdatedby IN NUMBER ,IDOUT out NUMBER);

end PKG_BANNER;

/
create or replace package body USRECOSISTEMAS.PKG_BANNER is

PROCEDURE BAN_BANNER_GETALL_BYSECTION(pSection IN VARCHAR2,
    cursorOutBannerSection OUT BAN_CURSOR_BANNER,
    cursorOutBannerDetail OUT BAN_CURSOR_BANNER)
IS
BEGIN
    OPEN cursorOutBannerSection FOR
    SELECT bs.id,bs.type,bs.name,bs.description,bs.sort FROM BannerSection bs
    WHERE (pSection IS NULL OR pSection = '' OR pSection = 'ALL' OR bs.type = pSection) order by bs.id,bs.sort;
    
    OPEN cursorOutBannerDetail FOR
    SELECT d.* FROM BannerDetail d
    INNER JOIN BannerSection p ON p.id = d.bannersectionid
    WHERE (pSection IS NULL OR pSection = '' OR pSection = 'ALL' OR p.type = pSection) and d.status=1;
    
END BAN_BANNER_GETALL_BYSECTION;

PROCEDURE BAN_BANNER_UPDATE(
pid IN NUMBER,
pbannerSectionID IN NUMBER,
pname IN VARCHAR2,
ptype IN NUMBER,
presourcedesktop IN VARCHAR2,
presourcemobile IN VARCHAR2,
plinkredirect IN VARCHAR2,
psort  IN NUMBER,
pstatusid IN NUMBER,
pupdatedby IN NUMBER,
IDOUT out NUMBER)
IS

BEGIN
 UPDATE BannerDetail
 SET
 BannerSectionID = pbannerSectionID
,Name = pname
,Type = ptype
,ResourceDesktop = presourcedesktop
,ResourceMobile = presourcemobile
,LinkRedirect= plinkredirect
,Sort = psort
,Status = pstatusid
,updatedby = pupdatedby
,updateddate = SYSDATE
WHERE ID = pid;

 IDOUT := SQL%rowcount;

COMMIT;


END BAN_BANNER_UPDATE;

PROCEDURE BAN_BANNER_INSERT(
pbannerSectionID IN NUMBER,
pname IN VARCHAR2,
ptype IN NUMBER,
presourcedesktop IN VARCHAR2,
presourcemobile IN VARCHAR2,
plinkredirect IN VARCHAR2,
psort  IN NUMBER,
pstatusid IN NUMBER,
pcreatedby IN NUMBER,
IDOUT out NUMBER)
IS

BEGIN
  INSERT INTO BannerDetail (
BannerSectionID,
Name,
Type,
ResourceDesktop,
ResourceMobile,
LinkRedirect,
Sort,
Status,
CreatedBy,
CreatedDate
)
VALUES
(pbannerSectionID,
pname,
ptype,
presourcedesktop,
presourcemobile,
plinkredirect,
psort,
pstatusid,
pcreatedby,
sysdate
)
  returning ID into IDOUT;
COMMIT;
END BAN_BANNER_INSERT;

PROCEDURE BAN_BANNER_UPDATESTATUS(pid IN NUMBER, pstatusid IN NUMBER,pupdatedby IN NUMBER ,IDOUT out NUMBER)
IS
BEGIN
 UPDATE BannerDetail SET STATUS = pstatusid, UPDATEDBY = pupdatedby, UPDATEDDATE = sysdate WHERE ID = pid;
  IDOUT := SQL%rowcount;
 COMMIT;
END BAN_BANNER_UPDATESTATUS;

end PKG_BANNER;

/