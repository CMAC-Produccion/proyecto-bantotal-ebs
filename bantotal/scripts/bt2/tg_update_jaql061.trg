CREATE OR REPLACE TRIGGER tg_update_JAQL061
  after update on jaql061
  for each row

begin

  insert into hjaql061
    (HJAQL61PGCO,
     HJAQL61PAIS,
     HJAQL61TDOC,
     HJAQL61NDOC,
     HJAQL61USER,
     HJAQL61FECH,
     HJAQL61ESTA,
     HJAQL61FEIN,
     HJAQL61HOIN)
  values
    (:old.JAQL61PGCO,
     :old.JAQL61PAIS,
     :old.JAQL61TDOC,
     :old.JAQL61NDOC,
     :old.JAQL61USER,
     :old.JAQL61FECH,
     :old.JAQL61ESTA,
     :new.JAQL61FECH,
     to_char(sysdate,'HH24:mi:ss'));
exception
  when others then
    null;
end;
/

