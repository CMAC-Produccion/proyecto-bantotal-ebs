CREATE OR REPLACE TRIGGER TG_UPD_TELEFONO2
  after update on fsr005
  for each row
DECLARE
  ca1 number(9);
  cursor base is
    select ctnro
      from fsr008
     where pgcod = 1
       and cttfir = 'T'
       and pepais = :new.pepais
       and petdoc = :new.petdoc
       and pendoc = :new.pendoc;

BEGIN
  if :new.pepais > 0 then
    for i in base loop
      ca1 := i.ctnro;
      SP_SNGC13_TEL2(:new.pepais ,
                    :new.petdoc,
                    :new.pendoc,
                    ca1,
                    :new.docod,
                    :new.doordp,
                    :new.dotelfp,
                    :new.dotlexp,
                    :new.dofaxp,1);
    end loop;
  end if;
  --Exception
  --When others then
  --  null;
END TG_UPD_TELEFONO2;
/

