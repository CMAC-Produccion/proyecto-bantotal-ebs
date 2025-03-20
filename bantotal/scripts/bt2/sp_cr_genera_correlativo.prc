create or replace procedure sp_cr_genera_correlativo(pn_codigo number,
                                                     pn_vuelta out number,
                                                     pn_correl out number) is

begin
  select tp1nro1, tp1nro2
    into pn_vuelta, pn_correl
    from fst198
   where tp1cod = 1
     and tp1cod1 = 11105
     and tp1corr1 = 29
     and tp1corr2 = 1
     and tp1corr3 = pn_codigo;

  --select SQ_CR_AQPA026.NEXTVAL into pn_correlativo from dual;

  if pn_correl = 999999999 then
    pn_vuelta := pn_vuelta + 1;
    pn_correl := 1;
    update fst198
       set tp1nro1 = pn_vuelta, tp1nro2 = pn_correl
     where tp1cod = 1
       and tp1cod1 = 11105
       and tp1corr1 = 29
       and tp1corr2 = 1
       and tp1corr3 = pn_codigo;
  else
    pn_correl := pn_correl + 1;
    update fst198
       set tp1nro2 = pn_correl
     where tp1cod = 1
       and tp1cod1 = 11105
       and tp1corr1 = 29
       and tp1corr2 = 1
       and tp1corr3 = pn_codigo;
  end if;
  commit;
EXCEPTION
  WHEN others THEN
    null;
end sp_cr_genera_correlativo;
/

