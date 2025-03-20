CREATE OR REPLACE TRIGGER TG_AQPB836_AD_03
  after delete on aqpb836
  referencing old as old new as new
  for each row
declare
  v_accion char(1);
  d_hora   char(15);
  d_fecha  date;
begin

  begin
    select 'D',
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
      (:old.aqpb836emp,
       :old.aqpb836mod,
       :old.aqpb836suc,
       :old.aqpb836mda,
       :old.aqpb836pap,
       :old.aqpb836cta,
       :old.aqpb836oper,
       :old.aqpb836sbop,
       :old.aqpb836top,
       :old.aqpb836fec,
       :old.aqpb836tip,
       :old.aqpb836sbtip,
       :old.aqpb836sdmo,
       :old.aqpb836aplext,
       :old.aqpb836fecbi,
       d_fecha,
       d_hora,
       v_accion);
  
  exception
    when others then
      null;
    
  end;

end TG_AQPC581_BI_03;
/

