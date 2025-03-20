CREATE OR REPLACE TRIGGER TG_UPD_TELEFONO
  after update on SNGC17
  for each row
DECLARE
  ca1 number(9);
  cursor base is
    select ctnro
      from fsr008
     where pgcod = 1
       and cttfir = 'T'
       and pepais = :new.sngc17pais
       and petdoc = :new.sngc17tdoc
       and pendoc = :new.sngc17ndoc;

BEGIN
  if :new.sngc17pais > 0 then
    for i in base loop
      ca1 := i.ctnro;
      SP_SNGC13_TEL(:new.sngc17pais ,
                    :new.sngc17tdoc,
                    :new.sngc17ndoc,
                    ca1,
                    :new.sngc17dcod,
                    :new.sngc17corr,
                    :new.sngc16ttel,1);
    end loop;
  end if;
  --Exception
  --When others then
  --  null;
END TG_UPD_TELEFONO;
/

