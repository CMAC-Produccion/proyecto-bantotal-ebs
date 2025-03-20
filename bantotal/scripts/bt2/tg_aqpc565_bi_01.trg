CREATE OR REPLACE TRIGGER TG_AQPC565_BI_01
  BEFORE INSERT ON AQPC565
  REFERENCING NEW AS NEW
  FOR EACH ROW
DECLARE
  valorSecuencia NUMBER := 0;
  corr2          number;
  --cod_proint     number;
BEGIN
  SELECT SEQ_CR_AQPC565.NEXTVAL INTO valorSecuencia FROM DUAL;
  :new.AQPC565CORR := valorSecuencia;

  SELECT max(aqpc565corr2)
    into corr2
    FROM AQPC565
   where AQPC565IDCPE = :new.AQPC565IDCPE;
  :new.AQPC565CORR2 := NVL(corr2, 0) + 1;

END;
/

