create or replace package USRECOSISTEMAS.PKG_TRANING_SURVEY is

  PROCEDURE TRA_TRAININGSURVEY_INSERT(
    puserid IN NUMBER,
    ptrainingcourseid IN NUMBER,
    pnpsi IN NUMBER,
    pcomments IN VARCHAR2,
    pstatusid  IN NUMBER,
    pcreatedby IN NUMBER,
    IDOUT out NUMBER);

end PKG_TRANING_SURVEY;

/
create or replace package body USRECOSISTEMAS.PKG_TRANING_SURVEY is

PROCEDURE TRA_TRAININGSURVEY_INSERT(
    puserid IN NUMBER,
    ptrainingcourseid IN NUMBER,
    pnpsi IN NUMBER,
    pcomments IN VARCHAR2,
    pstatusid  IN NUMBER,
    pcreatedby IN NUMBER,
    IDOUT out NUMBER)
AS
psurveyId NUMBER :=0;
pStatusCourseComplete NUMBER:=3;
BEGIN
  select nvl((select NVL(id,0) from trainingsurvey ts where ts.status=1 and ts.userid=puserid and ts.trainingcourseid=ptrainingcourseid), 0)  into psurveyId from dual;
  
  if psurveyId > 0 THEN
    IDOUT := -1;
  else
    insert into trainingsurvey(userid,trainingcourseid,npsi,comments,status,createdby)
    values(puserid,ptrainingcourseid,pnpsi,pcomments,pstatusid,pcreatedby)
    returning ID into IDOUT;
    COMMIT;
    
    update trainingusercourse set coursestatus=pStatusCourseComplete,updatedby=pcreatedby,updateddate=sysdate where userid=puserid and trainingcourseid=ptrainingcourseid;
    
    commit;
    
    update trainingcourse set orderview=orderview+1 where id=ptrainingcourseid;
    
    commit;
  end if;
 
END TRA_TRAININGSURVEY_INSERT;

end PKG_TRANING_SURVEY;
/