CREATE OR REPLACE TRIGGER TG_AQPD006_BI_01
before insert on AQPD006
For each row
  DECLARE
  begin
    select SQ_CN_AQPD006.NEXTVAL into :new.AQPD006CORR from dual;
    select to_char(sysdate, 'HH24:MI:SS') into :new.AQPD006HOACT from dual;
    select 'N' into :new.AQPD006EST from dual;
end;
/

