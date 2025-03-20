CREATE OR REPLACE TRIGGER TG_INS_DIRECCION
  after insert on SNGC13
  for each row

DECLARE
  ca1 number(9);
  cursor base is
    select ctnro
      from fsr008
     where pgcod = 1
       and cttfir = 'T'
       and pepais = :new.sngc13pais
       and petdoc = :new.sngc13tdoc
       and pendoc = :new.sngc13ndoc;

BEGIN
  if :new.sngc13pais > 0 then
    for i in base loop
      ca1 := i.ctnro;
      SP_SNGC13_DIR(:new.sngc13pais,
                    :new.sngc13tdoc,
                    :new.sngc13ndoc,
                    ca1,
                    :new.docod,
                    :new.sngc13corr,
                    :new.sngc13pdoc,
                    :new.sngc12vivc,
                    :new.sngc01id,
                    :new.sngc02id,
                    :new.sngc03id,
                    :new.sngc04id,
                    :new.sngc05id,
                    :new.sngc06id,
                    :new.sngc13dsc2,
                    :new.sngc13dsc3,
                    :new.sngc13dsc1,
                    :new.sngc13dsc4,
                    :new.sngc13dsc5,
                    :new.sngc13dsc6,
                    :new.sngc13ugeo,
                    :new.sngc13dpto,
                    :new.sngc13prov,
                    :new.sngc13dist,
                    :new.sngc13cneg,
                    :new.sngc13ref,
                    :new.sngc13ref1,
                    :new.sngc13dir,
                    :new.sngc13rdes,
                    :new.sngc13arr,
                    :new.sngc13atel,
                    :new.sngc13fhab,
                    :new.sngc13est,
                    :new.sngc13dest,
                    :new.sngc13fdir,
                    :new.sngc13user,
                    :new.sngc13col,
                    :new.sngc13tas);
    end loop;
  end if;
  --Exception
  --When others then
  --  null;
END TG_INS_DIRECCION;

  --select * from JAQL977A for update
/

