CREATE OR REPLACE TRIGGER "AN$21270BTSIO00ID" BEFORE INSERT ON BTSIO00 FOR EACH ROW BEGIN SELECT   BTSIO00Id.NEXTVAL INTO :new.BTSIO00Id FROM DUAL; END;
/

