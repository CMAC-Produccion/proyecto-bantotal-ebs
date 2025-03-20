CREATE OR REPLACE TRIGGER TG_JAQZ601_B_I
before insert on JAQZ601
for each row
begin
select SQ_RH_INCVAC.nextval into :new.ID from dual;
end;
/

