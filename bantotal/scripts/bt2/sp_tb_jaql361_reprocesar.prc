create or replace procedure SP_TB_JAQL361_REPROCESAR (lcfeproc in varchar2)
IS
BEGIN
  delete from JAQL361
  where fecdeposito = lcfeproc/*'20180305'*/;--fecha del proceso
  commit;
END SP_TB_JAQL361_REPROCESAR;
/

