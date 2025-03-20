CREATE OR REPLACE TRIGGER tg_update_JAQL060
  after update on JAQL060
  for each row

begin

  insert into hjaql060
  values
    (:new.jaql60fech,
     :new.jaql60hora,
     :old.jaql60pgco,
     :old.jaql60pais,
     :old.jaql60tdoc,
     :old.jaql60ndoc,
     :old.jaql60sucu,
     :old.jaql60sapf,
     :old.jaql60sact,
     :old.jaql60saah,
     :old.jaql60sato,
     :old.jaql60fata,
     :old.jaql60faan,
     :old.jaql60cali,
     :old.jaql60fech,
     :old.jaql60hora,
     :old.jaql60moti,
     :old.jaql60tipe);
exception
  when others then
    null;
end;
/

