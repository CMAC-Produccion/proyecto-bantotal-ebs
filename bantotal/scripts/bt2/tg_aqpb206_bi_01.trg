CREATE OR REPLACE TRIGGER "TG_AQPB206_BI_01" BEFORE INSERT ON AQPB206 FOR EACH ROW BEGIN SELECT   SQ_AR_AQPB206IDL.NEXTVAL INTO :new.AQPB206IDL FROM DUAL; END;
/

