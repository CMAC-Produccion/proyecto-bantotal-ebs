CREATE OR REPLACE TRIGGER TG_DEL_CORREO
  after delete on FSX001
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
      if :old.txcod=0 then
      SP_SNGC13_MAIL(:old.pepais,
                    :old.petdoc,
                    :old.pendoc,
                    ca1,
                    :old.txcod,
                    :old.pexren,
                    :old.pextxt,
                    :old.pexusu,
                    :old.pexfch,0);
      end if;    
    end loop;
  end if;
  --Exception
  --When others then
  --  null;
END TG_DEL_CORREO;
/

