CREATE OR REPLACE TRIGGER TG_FSD015_INS_JAQL980A
  after update on FSD015
  for each row

DECLARE

  cursor modulos is
  select tp1nro1 Modulo, tp1nro2 Tran from fst198 where tp1cod =1 and tp1cod1= 10864 and tp1corr1 = 3;



BEGIN


  for i in modulos loop

      if i.modulo = :new.ITMOD and i.Tran = :new.ITTRAN  and :new.ITCONT = 'S' then

         insert into JAQL980A
            (
            JAQL980Acor,
            JAQL980Acod,
            JAQL980Asuc,
            JAQL980Amod,
            JAQL980Atran,
            JAQL980Anrel,
            JAQL980Afcon,
            JAQL980Auing,
            JAQL980Ahora,
            JAQL980Acont,
            JAQL980Acorr
            )
         values
            (SEQ_JAQL980A.NEXTVAL,
             :new.PGCOD,
             :new.ITSUC,
             :new.ITMOD,
             :new.ITTRAN,
             :new.ITNREL,
             :new.ITFCON,
             :new.ITUING,
             :new.ITHORA,
             :new.ITCONT,
             :new.ITCORR);

      end if;

  end loop;

exception
  when others then
    null;

END TG_FSD015_INS_JAQL980A;


--select * from JAQL980AA for update
/

