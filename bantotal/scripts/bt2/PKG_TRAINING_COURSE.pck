create or replace package USRECOSISTEMAS.PKG_TRAINING_COURSE is

  -- Author  : JHONATAN
  -- Created : 03/08/2023 08:17:43
  -- Purpose : 
  
  type TRA_CURSOR_COURSE IS REF CURSOR;
  
  PROCEDURE TRA_TRAININGCOURSE_GETMOREVIEW(puserId IN number,cursorOut OUT TRA_CURSOR_COURSE);
  PROCEDURE TRA_TRAININGCOURSE_GETBYMODULE_PAGINATED(puserId IN number,pmoduleid IN number,prow IN NUMBER, ptotalRecord IN NUMBER,cursorOut OUT TRA_CURSOR_COURSE);
  PROCEDURE TRA_TRAININGCOURSE_GETBYSEARCH_PAGINATED(pteacherId IN number,pmoduleid IN number,plevel IN VARCHAR2,ptextsearch IN VARCHAR2,prow IN NUMBER, ptotalRecord IN NUMBER,cursorOut OUT TRA_CURSOR_COURSE);
  PROCEDURE TRA_TRAININGCOURSE_GETBYID(pid IN NUMBER,cursorOut OUT TRA_CURSOR_COURSE);
  PROCEDURE TRA_TRAININGCOURSE_INSERT(
  pteacherid IN NUMBER,
  pmoduleid IN NUMBER,
  pname IN VARCHAR2,
  pdescription IN VARCHAR2,
  porderview IN NUMBER,
  pisdefaultshowinhome IN NUMBER,
  palevel VARCHAR2,
  pvideoidentifier IN VARCHAR2,
  pvideourl IN VARCHAR2,
  pvideoduration IN NUMBER,
  pvideoimage IN VARCHAR2,
  pvideodurationinseconds IN NUMBER,
  pstatusid IN NUMBER,
  pcreatedby IN NUMBER,
  IDOUT out NUMBER);
  PROCEDURE TRA_TRAININGCOURSE_UPDATE(
  pid IN NUMBER,
  pteacherid IN NUMBER,
  pmoduleid IN NUMBER,
  pname IN VARCHAR2,
  pdescription IN VARCHAR2,
  porderview IN NUMBER,
  pisdefaultshowinhome IN NUMBER,
  palevel IN VARCHAR2,
  pvideoidentifier IN VARCHAR2,
  pvideourl IN VARCHAR2,
  pvideoduration IN NUMBER,
  pvideoimage IN VARCHAR2,
  pvideodurationinseconds IN NUMBER,
  pstatusid IN NUMBER,
  pupdatedby IN NUMBER,
  IDOUT out NUMBER);
  PROCEDURE TRA_TRAININGCOURSE_UPDATESTATUS(
  pid IN NUMBER,
  pstatusid IN NUMBER,
  pupdatedby IN NUMBER,
  IDOUT out NUMBER);
  PROCEDURE TRA_TRAININGCOURSE_GETTICKETS_BYUSER(puserId IN number,pquantityTickets OUT NUMBER);
  PROCEDURE TRA_TRAININGCOURSE_GETBYID(pid in number,puserId IN number,cursorOut OUT TRA_CURSOR_COURSE);
  PROCEDURE TRA_TRAININGCOURSE_SAVEPROGRESS(
    puserid IN NUMBER,
    ptrainingcourseid IN NUMBER,
    ptrainingcoursedetailid IN NUMBER,
    ptimeofprogress IN NUMBER,
    ptimeofremaining IN NUMBER,
    pstatusid  IN NUMBER,
    rowsOut out NUMBER);

end PKG_TRAINING_COURSE;

/
create or replace package body USRECOSISTEMAS.PKG_TRAINING_COURSE is

PROCEDURE TRA_TRAININGCOURSE_GETMOREVIEW(puserId IN number,cursorOut OUT TRA_CURSOR_COURSE)
IS
BEGIN
  OPEN cursorOut FOR
  WITH Course_More_View
as
(
select tc.id,tc.name,tm.name as trainingmodulename,tcd.videoimage,tc.orderview,
case when (select tuc1.id from trainingusercourse tuc1 where tuc1.userid=puserId and tuc1.trainingcourseid=tc.id and tuc1.coursestatus=3)>0 then to_number(1) else to_number(0) end as IsCourseComplete
from trainingcourse tc inner join trainingmodule tm on tc.trainingmoduleid=tm.id
inner join trainingcoursedetail tcd on tc.id=tcd.trainingcourseid and tc.status=1
where tc.orderview>0
order by tc.orderview desc)
select distinct id,name,trainingmodulename,videoimage,IsCourseComplete,orderview from Course_More_View where rownum<=4 order by orderview desc;
END TRA_TRAININGCOURSE_GETMOREVIEW;

PROCEDURE TRA_TRAININGCOURSE_GETBYMODULE_PAGINATED(puserId IN number,pmoduleid IN number,prow IN NUMBER, ptotalRecord IN NUMBER,cursorOut OUT TRA_CURSOR_COURSE)
IS
BEGIN
  OPEN cursorOut FOR
  select * from
  (select distinct tc.id,tc.name,tm.id as trainingmoduleid,
  tm.name as trainingmodulename,tcd.videoimage,
  case when (select tuc.id from trainingusercourse tuc where tuc.userid=puserId and tuc.trainingcourseid=tc.id and tuc.coursestatus=3)>0 then to_number(1) else to_number(0) end as IsCourseComplete,
  row_number() over (order by tc.orderview asc) as NroRow,
  (select count(*) from trainingcourse tct inner join trainingmodule tmt on tct.trainingmoduleid=tmt.id and tct.trainingmoduleid=pmoduleid and tct.status=1) as TotalRow
  from trainingcourse tc inner join trainingmodule tm on tc.trainingmoduleid=tm.id and tc.trainingmoduleid=pmoduleid
  inner join trainingteacher tt on tc.trainingteacherid=tt.id inner join trainingcoursedetail tcd
  on tc.id=tcd.trainingcourseid and tc.status=1) where NroRow>=((pRow-1)*pTotalRecord)+1 and NroRow<=(pRow*pTotalRecord)
  order by nrorow;
END TRA_TRAININGCOURSE_GETBYMODULE_PAGINATED;

PROCEDURE TRA_TRAININGCOURSE_GETBYSEARCH_PAGINATED(pteacherId IN number,pmoduleid IN number,plevel IN VARCHAR2,ptextsearch IN VARCHAR2,prow IN NUMBER, ptotalRecord IN NUMBER,cursorOut OUT TRA_CURSOR_COURSE)
IS
BEGIN
  OPEN cursorOut FOR
  select * from
  (select tc.id, tc.trainingteacherid, 
tt.firstname as trainingteacherfirstname,
tt.lastname as trainingteacherlastname,
tc.trainingmoduleid,
tm.name as modulename,
tc.name,
tc.description,
tc.orderview,
tc.isdefaultshowinhome,
tc.status,
tc.alevel,
tc.createddate,
tcd.id as trainingcoursedetailid,
tcd.videoidentifier,
tcd.videourl,
tcd.videoduration,
tcd.videoimage,
tcd.videodurationinseconds,
row_number() over (order by tc.createddate desc) as NroRow,
(select count(*) from trainingcourse tct 
inner join trainingcoursedetail tcd1 on tct.id=tcd1.trainingcourseid 
inner join trainingteacher tt1 on tct.trainingteacherid=tt1.id 
inner join trainingmodule tm1 on tct.trainingmoduleid=tm1.id
where tct.status=1 
AND (tt1.id = case when pteacherId>0 then pteacherId else tt1.id end)
AND (tm1.id = case when pmoduleid>0 then pmoduleid else tm1.id end) 
AND UPPER(tct.alevel) LIKE UPPER('%'||plevel||'%')
AND UPPER(tct.name) LIKE UPPER('%'||ptextsearch||'%')
  ) as TotalRow
from trainingcourse tc
inner join trainingcoursedetail tcd on tc.id=tcd.trainingcourseid 
inner join trainingteacher tt on tc.trainingteacherid=tt.id 
inner join trainingmodule tm on tc.trainingmoduleid=tm.id
where tc.status=1
AND (tt.id = case when pteacherId>0 then pteacherId else tt.id end)
AND (tm.id = case when pmoduleid>0 then pmoduleid else tm.id end) 
AND UPPER(tc.alevel) LIKE UPPER('%'||plevel||'%')
AND UPPER(tc.name) LIKE UPPER('%'||ptextsearch||'%')) where NroRow>=((pRow-1)*pTotalRecord)+1 and NroRow<=(pRow*pTotalRecord)
order by nrorow;
END TRA_TRAININGCOURSE_GETBYSEARCH_PAGINATED;

PROCEDURE TRA_TRAININGCOURSE_GETBYID(pid IN number,cursorOut OUT TRA_CURSOR_COURSE)
IS
BEGIN
OPEN cursorOut FOR
select tc.id, tc.trainingteacherid, 
tt.firstname as trainingteacherfirstname,
tt.lastname as trainingteacherlastname,
tc.trainingmoduleid,
tm.name as modulename,
tc.name,
tc.description,
tc.orderview,
tc.isdefaultshowinhome,
tc.status,
tc.alevel,
tc.createddate,
tcd.id as trainingcoursedetailid,
tcd.videoidentifier,
tcd.videourl,
tcd.videoduration,
tcd.videoimage,
tcd.videodurationinseconds
from trainingcourse tc
inner join trainingcoursedetail tcd on tc.id=tcd.trainingcourseid 
inner join trainingteacher tt on tc.trainingteacherid=tt.id 
inner join trainingmodule tm on tc.trainingmoduleid=tm.id
where tc.status=1 and tc.id=pid;
END TRA_TRAININGCOURSE_GETBYID;

PROCEDURE TRA_TRAININGCOURSE_INSERT(
  pteacherid IN NUMBER,
  pmoduleid IN NUMBER,
  pname IN VARCHAR2,
  pdescription IN VARCHAR2,
  porderview IN NUMBER,
  pisdefaultshowinhome IN NUMBER,
  palevel VARCHAR2,
  pvideoidentifier IN VARCHAR2,
  pvideourl IN VARCHAR2,
  pvideoduration IN NUMBER,
  pvideoimage IN VARCHAR2,
  pvideodurationinseconds IN NUMBER,
  pstatusid IN NUMBER,
  pcreatedby IN NUMBER,
  IDOUT out NUMBER)
IS
BEGIN
 INSERT INTO TRAININGCOURSE (
TRAININGTEACHERID
,TRAININGMODULEID
,NAME
,DESCRIPTION
,ORDERVIEW
,ISDEFAULTSHOWINHOME
,ALEVEL
,STATUS
,CREATEDBY
,CREATEDDATE
)
VALUES
(
pteacherid
,pmoduleid
,pname
,pdescription
,porderview
,pisdefaultshowinhome
,palevel
,pstatusid
,pcreatedby
,SYSDATE
)
returning ID into IDOUT;

IF(SQL%rowcount > 0)
  THEN

INSERT INTO TRAININGCOURSEDETAIL (
TRAININGCOURSEID
,VIDEOIDENTIFIER
,VIDEOURL
,VIDEODURATION
,VIDEOIMAGE
,VIDEODURATIONINSECONDS
,STATUS
,CREATEDBY
,CREATEDDATE)
VALUES(
IDOUT,
pvideoidentifier,
pvideourl,
pvideoduration,
pvideoimage,
pvideodurationinseconds,
pstatusid,
pcreatedby,
SYSDATE);

END IF;

COMMIT;
EXCEPTION
  WHEN OTHERS THEN
  ROLLBACK;
    RAISE;
END TRA_TRAININGCOURSE_INSERT;

PROCEDURE TRA_TRAININGCOURSE_UPDATE(
  pid IN NUMBER,
  pteacherid IN NUMBER,
  pmoduleid IN NUMBER,
  pname IN VARCHAR2,
  pdescription IN VARCHAR2,
  porderview IN NUMBER,
  pisdefaultshowinhome IN NUMBER,
  palevel IN VARCHAR2,
  pvideoidentifier IN VARCHAR2,
  pvideourl IN VARCHAR2,
  pvideoduration IN NUMBER,
  pvideoimage IN VARCHAR2,
  pvideodurationinseconds IN NUMBER,
  pstatusid IN NUMBER,
  pupdatedby IN NUMBER,
  IDOUT out NUMBER)
AS
ptrainingCourseDetailId NUMBER:=0;
BEGIN
  
    select nvl((select nvl(tcd.id,0) from trainingcoursedetail tcd inner join trainingcourse tc on tcd.trainingcourseid=tc.id
    where rownum=1 and tc.status=1 and tc.id=pid and tcd.status=1),0) into ptrainingCourseDetailId from dual;
    
  UPDATE TRAININGCOURSE
 SET
 TRAININGTEACHERID = pteacherid
,TRAININGMODULEID = pmoduleid
,NAME = pname
,DESCRIPTION = pdescription
,ORDERVIEW = porderview
,ISDEFAULTSHOWINHOME= pisdefaultshowinhome
,ALEVEL = palevel
,STATUS = pstatusid
,updatedby = pupdatedby
,updateddate = SYSDATE
WHERE ID = pid;

 IDOUT := SQL%rowcount;
 
 UPDATE TRAININGCOURSEDETAIL
 SET
 VIDEOIDENTIFIER = pvideoidentifier
,VIDEOURL = pvideourl
,VIDEODURATION = pvideoduration
,VIDEOIMAGE = pvideoimage
,VIDEODURATIONINSECONDS= pvideodurationinseconds
,STATUS = pstatusid
,updatedby = pupdatedby
,updateddate = SYSDATE
WHERE ID = ptrainingCourseDetailId;

 IDOUT := SQL%rowcount; 
 
 COMMIT;
END TRA_TRAININGCOURSE_UPDATE;

PROCEDURE TRA_TRAININGCOURSE_UPDATESTATUS(
  pid IN NUMBER,
  pstatusid IN NUMBER,
  pupdatedby IN NUMBER,
  IDOUT out NUMBER)
IS
BEGIN
  UPDATE TRAININGCOURSE
 SET
STATUS = pstatusid
,updatedby = pupdatedby
,updateddate = SYSDATE
WHERE ID = pid;

 IDOUT := SQL%rowcount;
 COMMIT;
END TRA_TRAININGCOURSE_UPDATESTATUS;

PROCEDURE TRA_TRAININGCOURSE_GETTICKETS_BYUSER(puserId IN number,pquantityTickets OUT NUMBER)
IS
BEGIN
  SELECT NVL(count(*),0) INTO pquantityTickets FROM trainingcourse tc inner join trainingusercourse tuc on tc.id=tuc.trainingcourseid and tuc.coursestatus=3 and tuc.userid=puserId;
END TRA_TRAININGCOURSE_GETTICKETS_BYUSER;


PROCEDURE TRA_TRAININGCOURSE_GETBYID(pid in number,puserId IN number,cursorOut OUT TRA_CURSOR_COURSE)
AS
ptrainingCourseDetailId NUMBER :=0;
ptimeOfProgress NUMBER :=0;
ptimeOfRemaining NUMBER :=0;
BEGIN
  
    select nvl((select nvl(tcd.id,0) from trainingcoursedetail tcd inner join trainingcourse tc on tcd.trainingcourseid=tc.id
    where rownum=1 and tc.status=1 and tc.id=pid and tcd.status=1),0) into ptrainingCourseDetailId from dual;
  
    select nvl((select nvl(tucd1.timeofprogress,0) from trainingusercoursedetail tucd1 where rownum=1 and tucd1.trainingcoursedetailid=ptrainingCourseDetailId and tucd1.userid=puserId and status=1),0) into ptimeOfProgress from dual;
    select nvl((select nvl(tucd1.timeofremaining,0) from trainingusercoursedetail tucd1 where rownum=1 and tucd1.trainingcoursedetailid=ptrainingCourseDetailId and tucd1.userid=puserId and status=1),0) into ptimeOfRemaining from dual;
    
    OPEN cursorOut FOR
    select tc.id,
    tc.name,
    tc.description,
    tc.alevel,
    nvl(tuc1.coursestatus,0) as coursestatus,
    tt.id as TrainingteacherId,
    tt.firstname as trainingTeacherFirstName,
    tt.lastname as trainingTeacherLastName,
    tt.speciality as trainingTeacherSpeciality,
    tt.experience as trainingTeacherExperience,
    tt.image as trainingTeacherImage,
    tm.name as trainingModuleName,
    tm.id as trainingModuleID, 
    tcd.videoimage,
    tcd.videoidentifier,
    tcd.videourl,
    tcd.videoduration,
    tcd.VideoDurationInSeconds,
    tcd.id as trainingCourseDetailId,
    nvl(ptimeOfProgress,0) as timeofprogress,
    nvl(ptimeOfRemaining,0) as timeofremaining,
    case when (select tuc.id from trainingusercourse tuc where tuc.userid=puserId and tuc.trainingcourseid=tc.id and tuc.coursestatus=3)>0 then to_number(1) else to_number(0) end as IsCourseComplete,
      case when (select tuc.id from trainingusercourse tuc where tuc.userid=puserId and tuc.trainingcourseid=tc.id and tuc.coursestatus=2)>0 then to_number(1) else to_number(0) end as IsViewCourseComplete
    from trainingcourse tc inner join trainingteacher tt on tc.trainingteacherid=tt.id
    inner join trainingmodule tm on tc.trainingmoduleid=tm.id
    inner join trainingcoursedetail tcd on tc.id=tcd.trainingcourseid
    left join trainingusercoursedetail tucd on tcd.id=tucd.trainingcoursedetailid and tucd.userid=puserId
    left join trainingusercourse tuc1 on tuc1.trainingcourseid=tc.id and tuc1.userid=puserId
    where tc.id=pid and tc.status=1;

END TRA_TRAININGCOURSE_GETBYID;

PROCEDURE TRA_TRAININGCOURSE_SAVEPROGRESS(
    puserid IN NUMBER,
    ptrainingcourseid IN NUMBER,
    ptrainingcoursedetailid IN NUMBER,
    ptimeofprogress IN NUMBER,
    ptimeofremaining IN NUMBER,
    pstatusid  IN NUMBER,
    rowsOut out NUMBER)
AS
pTrainingUserCourseId NUMBER:=0;
pTrainingUserCourseDetailId NUMBER :=0;
pTrainingUserCourseIdComplete NUMBER:=0;

pStatusCourseRegister NUMBER:=1;
pStatusCourseViewComplete NUMBER:=2;
pStatusCourseComplete NUMBER:=3;

pCourseVideoTime NUMBER:=0;
BEGIN
  
  select nvl((select NVL(id,0) from trainingusercourse ts where ts.status=1 and ts.userid=puserid and ts.trainingcourseid=ptrainingcourseid), 0)  into pTrainingUserCourseId from dual;
  
  if pTrainingUserCourseId = 0 THEN
  
    select nvl((select NVL(ts.videodurationinseconds,0) from trainingcoursedetail ts where ts.status=1 and ts.id=ptrainingcoursedetailid), 0)  into pCourseVideoTime from dual;
  
    insert into trainingusercourse(userid,trainingcourseid,coursestatus,status,createdby)
    values(puserid,ptrainingcourseid,pStatusCourseRegister,pstatusid,puserid);
    commit;
    
    insert into trainingusercoursedetail(userid,trainingcoursedetailid,timeofprogress,timeofremaining,status,createdby)
    values(puserid,ptrainingcoursedetailid,ptimeofprogress,pCourseVideoTime,pstatusid,puserid);
    
    commit;
    
    rowsOut := 1;
  else
     select nvl((select NVL(ts.id,0) from trainingusercourse ts where ts.status=1 and ts.userid=puserid and ts.trainingcourseid=ptrainingcourseid and ts.coursestatus=pStatusCourseComplete), 0)  into pTrainingUserCourseIdComplete from dual;
     
     if  pTrainingUserCourseIdComplete = 0 then
     select nvl((select NVL(id,0) from trainingusercoursedetail ts where ts.status=1 and ts.userid=puserid and ts.trainingcoursedetailid=ptrainingcoursedetailid and rownum=1), 0)  into pTrainingUserCourseDetailId from dual;
     
     if pTrainingUserCourseDetailId > 0 THEN
       
       update trainingusercoursedetail set status=0 where userid=puserid and trainingcoursedetailid=ptrainingcoursedetailid;
       commit;
     
       insert into trainingusercoursedetail(userid,trainingcoursedetailid,timeofprogress,timeofremaining,status,createdby)
       values(puserid,ptrainingcoursedetailid,ptimeofprogress,ptimeofremaining,pstatusid,puserid);
       commit;
       
       if ptimeofremaining = 0 then
         update trainingusercourse set coursestatus=pStatusCourseViewComplete,updatedby=puserid,updateddate=sysdate
         where userid=puserid and trainingcourseid=ptrainingcourseid;
         
         commit;
       end if;
     end if;
     end if;
  
     
    rowsOut := 1;
  end if;
END TRA_TRAININGCOURSE_SAVEPROGRESS;
  
end PKG_TRAINING_COURSE;
/