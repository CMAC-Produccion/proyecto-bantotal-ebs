create or replace package USRECOSISTEMAS.PKG_TRAINING_CERTIFICATE is

  -- Author  : JHONATAN
  -- Created : 9/08/2023 15:40:43
  -- Purpose : 
  
  type TRA_CURSOR_TRAININGCERTIFICATE IS REF CURSOR;
  
  PROCEDURE TRA_TRAININGUSERCERTIFICATE_INSERT(
    puserid IN NUMBER,
    ptrainingcourseid IN NUMBER,
    pcertificatedate IN DATE,
    pfileurl IN VARCHAR2,
    pstatusid  IN NUMBER,
    IDOUT out NUMBER);
    
  PROCEDURE TRA_TRAININGCERTIFICATE_GETBYID(pid in number,cursorOut OUT TRA_CURSOR_TRAININGCERTIFICATE);
  
  PROCEDURE TRA_TRAININGUSERCERTIFICATE_GETBYUSERANDCOURSEID(pcourseId in number,puserid in number,cursorOut OUT TRA_CURSOR_TRAININGCERTIFICATE);

end PKG_TRAINING_CERTIFICATE;

/
create or replace package body USRECOSISTEMAS.PKG_TRAINING_CERTIFICATE is

PROCEDURE TRA_TRAININGUSERCERTIFICATE_INSERT(
    puserid IN NUMBER,
    ptrainingcourseid IN NUMBER,
    pcertificatedate IN DATE,
    pfileurl IN VARCHAR2,
    pstatusid  IN NUMBER,
    IDOUT out NUMBER)
AS
pTrainingUserCertificateId NUMBER :=0;
BEGIN
  select nvl((select NVL(id,0) from trainingusercertificate ts where ts.status=1 and ts.userid=puserid and ts.trainingcourseid=ptrainingcourseid), 0)  into pTrainingUserCertificateId from dual;
  
  if pTrainingUserCertificateId > 0 THEN
    IDOUT := -1;
  else
    insert into trainingusercertificate(userid,trainingcourseid,certificatedate,fileurl,status,createdby)
    values(puserid,ptrainingcourseid,pcertificatedate,pfileurl,pstatusid,puserid)
    returning ID into IDOUT;
    COMMIT;
  end if;
 
END TRA_TRAININGUSERCERTIFICATE_INSERT;

PROCEDURE TRA_TRAININGCERTIFICATE_GETBYID(pid in number,cursorOut OUT TRA_CURSOR_TRAININGCERTIFICATE)
AS
BEGIN
  OPEN cursorOut FOR
    select tc.id,
    tc.name,
    tc.description,
    tc.content,
    tc.filename
    from trainingcertificate tc 
    where tc.id=pid and tc.status=1;
END TRA_TRAININGCERTIFICATE_GETBYID;

PROCEDURE TRA_TRAININGUSERCERTIFICATE_GETBYUSERANDCOURSEID(pcourseId in number,puserid in number,cursorOut OUT TRA_CURSOR_TRAININGCERTIFICATE)
AS
BEGIN
  OPEN cursorOut FOR
    select tc.id,
    tc.trainingcourseid,
    tc.userid,
    tc.content,
    tc.fileurl,
    tc.certificatedate
    from trainingusercertificate tc 
    where tc.trainingcourseid=pcourseId and tc.status=1 and tc.userid=puserid;
END TRA_TRAININGUSERCERTIFICATE_GETBYUSERANDCOURSEID;
  
end PKG_TRAINING_CERTIFICATE;
/