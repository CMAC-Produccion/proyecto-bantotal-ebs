CREATE OR REPLACE TRIGGER "AN$11343SNGCARTCORR"    BEFORE INSERT ON SNGCART FOR EACH ROW BEGIN SELECT   SNGCartCorr.NEXTVAL INTO :new.SNGCartCorr FROM DUAL; END;
/

