CREATE OR REPLACE TRIGGER TG_JAQY844_BI_01
BEFORE INSERT ON JAQY844
REFERENCING NEW AS NEW FOR EACH ROW
DECLARE valorSecuencia NUMBER := 0;
BEGIN
SELECT SQ_MP_JAQY844CORR2.NEXTVAL INTO valorSecuencia FROM DUAL;
:new.JAQY844CORR2  := valorSecuencia;
END;
/

