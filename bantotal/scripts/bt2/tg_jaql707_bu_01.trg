CREATE OR REPLACE TRIGGER TG_JAQL707_BU_01
  before update on JAQL707
  for each row

  -- Author  : MARAUJO
  -- Created : 25/05/2018 05:06:42 p.m.
  -- Purpose : Registro de abonos de AFP

declare
  -- local variables here
begin
  if :new.jaql707itco = 'S' and (:old.jaql707nobe like '%AFP%' or :old.jaql707nobe like '%HA-FONDO%'
    or :old.jaql707nobe like '%IN%-%FONDO%' or :old.jaql707nobe like '%PR%-%FONDO%' or :old.jaql707nobe like 'RI') then
    sp_ah_abono_afp(p_numcci => :old.jaql707ccid,
                    p_mtodep => :old.jaql707impo,
                    p_fecdep => :old.jaql707fech);
  end if;

end TG_JAQL707_BI_01;
/

