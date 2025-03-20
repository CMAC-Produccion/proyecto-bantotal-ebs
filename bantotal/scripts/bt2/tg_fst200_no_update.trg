create or replace trigger "TG_FST200_NO_UPDATE"
  before update on "BANTPROD"."FST200"
  for each row
begin
  IF USER NOT IN ('EHIDALGO','KCABRERAC','C##EHIDALGO','C##KCABRERAC') THEN
    if (:new.pgcod = 1 and :new.opgcod = 2850) then
      raise_application_error(-20001, 'No se debe habilitar DEBUG (FST200), salvo previa autorización.');
    end if;
  END IF;
end TG_FST200_NO_UPDATE;
 /* GOLDENGATE_DDL_REPLICATION */
/

