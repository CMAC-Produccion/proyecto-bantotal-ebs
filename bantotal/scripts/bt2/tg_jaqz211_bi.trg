CREATE OR REPLACE TRIGGER TG_JAQZ211_BI
  BEFORE INSERT ON JAQZ211
  FOR EACH ROW
BEGIN
  SELECT JAQZ211CORR.NEXTVAL INTO :new.JAQZ211CORR FROM DUAL;
END;
/

