CREATE OR REPLACE TRIGGER TG_JAQL517_UPD_AUDIT
  BEFORE UPDATE ON JAQL517
  FOR EACH ROW
BEGIN
  UPDATE seal_log SET  HORA_FIN = to_char(sysdate, 'hh:mi:ss') WHERE COTRA=:new.JAQL517COTRA;
END TG_JAQL517_UPD_AUDIT;
/

