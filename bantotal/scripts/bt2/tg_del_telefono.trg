CREATE OR REPLACE TRIGGER TG_DEL_TELEFONO
  after delete on SNGC17
  for each row
DECLARE
  ca1 number(9);
  cursor base is
    select ctnro
      from fsr008
     where pgcod = 1
       and cttfir = 'T'
       and pepais = :old.sngc17pais
       and petdoc = :old.sngc17tdoc
       and pendoc = :old.sngc17ndoc;

BEGIN
  if :old.sngc17pais > 0 then
    for i in base loop
      ca1 := i.ctnro;
      SP_SNGC13_TEL(:old.sngc17pais ,
                    :old.sngc17tdoc,
                    :old.sngc17ndoc,
                    ca1,
                    :old.sngc17dcod,
                    :old.sngc17corr,
                    :old.sngc16ttel,0);
    end loop;
  end if;
  --Exception
  --When others then
  --  null;
END TG_DEL_TELEFONO;
/

