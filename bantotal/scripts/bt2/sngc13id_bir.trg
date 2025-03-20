CREATE OR REPLACE TRIGGER sngc13id_bir
before insert on sngc13_aux
for each row

begin
  select sngc13id_seq.nextval
  into   :new.sngc13id
  from   dual;
end;
/

