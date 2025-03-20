CREATE OR REPLACE TRIGGER TG_UPD_CORREO
  after update on FSX001
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
      if :new.txcod=0 then
      SP_SNGC13_MAIL(:new.pepais,
                    :new.petdoc,
                    :new.pendoc,
                    ca1,
                    :new.txcod,
                    :new.pexren,
                    :new.pextxt,
                    :new.pexusu,
                    :new.pexfch,1);
      end if;
   end loop;
  end if;
  --Exception
  --When others then
  --  null;
END TG_UPD_CORREO;
/

