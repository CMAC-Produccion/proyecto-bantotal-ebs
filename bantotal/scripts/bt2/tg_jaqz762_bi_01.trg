CREATE OR REPLACE TRIGGER TG_JAQZ762_BI_01
BEFORE INSERT ON JAQZ762
REFERENCING NEW AS NEW FOR EACH ROW
DECLARE valorSecuencia NUMBER := 0;
BEGIN
SELECT SQ_MP_JAQZ762CORR2.NEXTVAL INTO valorSecuencia FROM DUAL;
:new.JAQZ762CORR2  := valorSecuencia;
END;
/

