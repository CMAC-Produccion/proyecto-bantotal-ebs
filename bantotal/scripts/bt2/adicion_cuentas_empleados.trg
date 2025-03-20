CREATE OR REPLACE TRIGGER "ADICION_CUENTAS_EMPLEADOS"
  after insert on fsd008
  
  for each row
declare
  -- local variables here
  CTACLI   NUMBER(9);
  cantidad number;
  estrab   number;
begin
  CTACLI := :new.ctnro;
  --inicilaizamos vasriable para ver si es trabajador
  estrab := 0;
  --verificamos si algun documento de la cuenta esta en tabla de trabajadores 
select count(*) into estrab from fsr008 where pgcod=1 and ctnro=CTACLI 
         and pendoc in (select pfndoc from fsd002 where pfebco='S');

  if estrab > 0 then
    -- si es trabajador
    select count(*)
      into cantidad
      from fsr008
     where pgcod = 1
       and ctnro = CTACLI;
    if cantidad = 1 then
      --filtramos que la cuenta tenga un solo integrante
      begin
        insert into fsd009
          (TGCOD, GRNRO, PGCOD, CTNRO, GRINCOD, GRPORC)
        values
          (4, 22001, 1, CTACLI, 1, 0.000);
      exception
        when others then
          null;
      end;
    else
      delete from fsd009
       where tgcod = 4
         and grnro = 22001
         and PGCOD = 1
         and ctnro = CTACLI;
    end if;
  else
    delete from fsd009
     where tgcod = 4
       and grnro = 22001
       and PGCOD = 1
       and ctnro = CTACLI;
  end if;
end TG_FSR008_CONTROL_CUENTAS;
/

