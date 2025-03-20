CREATE OR REPLACE TRIGGER "TG_FSR008_CONTROL_CUENTAS"
  after insert on fsr008

for each row
declare
  -- local variables here
  CTACLI   NUMBER(9);
  cantidad number;
  begin
    CTACLI := :new.ctnro;

    select count(*)
      into cantidad
      from JAQN002
    where jaqn002usr not in (select tp1desc from fst198 where tp1cod1 = 10807  and tp1corr1 = 47)
        and jaqn002pai = :new.pepais
        and jaqn002tdo = :new.petdoc
        and jaqn002ndo = :new.pendoc;
   if cantidad > 0 then
     begin
        insert into fst056
          select 1, jaqn002usr, CTACLI
            from JAQN002
           where jaqn002pai = :new.pepais
             and jaqn002tdo = :new.petdoc
             and jaqn002ndo = :new.pendoc;
      exception
        when others then
          null;
      end;
   end if;
end TG_FSR008_CONTROL_CUENTAS;
/

