CREATE OR REPLACE TRIGGER TG_AQPB836_AU_02
  after update on aqpb836
  for each row
declare
  v_accion char(1);
  d_hora   char(15);
  d_fecha  date;
begin

  begin
    select 'U',
           TO_CHAR(systimestamp, 'HH24:MI:SS.FF3'),
           TO_CHAR(systimestamp, 'DD/MM/YYYY')
      into v_accion, d_hora, d_fecha
      from DUAL;
  exception
    when others then
      null;
  end;

  begin
    insert into aqpc580
      (aqpc580emp,
       aqpc580mod,
       aqpc580suc,
       aqpc580mda,
       aqpc580pap,
       aqpc580cta,
       aqpc580oper,
       aqpc580sbop,
       aqpc580top,
       aqpc580fec,
       aqpc580tip,
       aqpc580sbtip,
       aqpc580sdmo,
       aqpc580aplext,
       aqpc580fecbi,
       aqpc580feccar,
       aqpc580horcar,
       aqpc580accion)
    values
      (:new.aqpb836emp,
       :new.aqpb836mod,
       :new.aqpb836suc,
       :new.aqpb836mda,
       :new.aqpb836pap,
       :new.aqpb836cta,
       :new.aqpb836oper,
       :new.aqpb836sbop,
       :new.aqpb836top,
       :new.aqpb836fec,
       :new.aqpb836tip,
       :new.aqpb836sbtip,
       :new.aqpb836sdmo,
       :new.aqpb836aplext,
       :new.aqpb836fecbi,
       d_fecha,
       d_hora,
       v_accion);
  exception
    when others then
      null;
  end;

end TG_AQPC581_BI_02;
/

