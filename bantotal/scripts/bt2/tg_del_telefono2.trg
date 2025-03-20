CREATE OR REPLACE TRIGGER TG_DEL_TELEFONO2
  after delete on fsr005
  for each row
DECLARE
  ca1 number(9);
  cursor base is
    select ctnro
      from fsr008
     where pgcod = 1
       and cttfir = 'T'
       and pepais = :old.pepais
       and petdoc = :old.petdoc
       and pendoc = :old.pendoc;

BEGIN
  if :old.pepais > 0 then
    for i in base loop
      ca1 := i.ctnro;
      SP_SNGC13_TEL2(:old.pepais ,
                    :old.petdoc,
                    :old.pendoc,
                    ca1,
                    :old.docod,
                    :old.doordp,
                    :old.dotelfp,
                    :old.dotlexp,
                    :old.dofaxp,0);
    end loop;
  end if;
  --Exception
  --When others then
  --  null;
END TG_DEL_TELEFONO2;
/

