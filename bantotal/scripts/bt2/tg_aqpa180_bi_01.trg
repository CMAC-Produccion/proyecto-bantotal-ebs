CREATE OR REPLACE TRIGGER TG_AQPA180_BI_01
before insert
on AQPA180
for each row
  declare ln_valor numeric;
begin
  select count(1) + 1 into ln_valor from aqpa180;
  :new.aqpa180id := ln_valor ;
end;
/

