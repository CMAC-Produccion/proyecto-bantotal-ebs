create or replace function fn_sector_credito_bt(--v_fecpro in date,
                                             v_pgcod  in number,
                                             --v_Scmod  in number,
                                             --v_Scsuc  in number,
                                             --v_Scmda  in number,
                                             --v_Scpap  in number,
                                             v_Sccta  in number,
                                             v_Scoper in number,
                                             --v_Scsbop in number,
                                             --v_Sctope in number,
                                             v_instancia in number
                                            ) return number is

    ln_sector jaql101.jaql101scl%type;
    --ln_instancia number(10);

begin

  begin
      select distinct JAQL101Scl
       into ln_sector
        from jaql101 a
       where a.jaql101pgc = v_pgcod
         and a.jaql101cta = v_Sccta
         and a.jaql101ope = v_Scoper
         and a.jaql101fch = (select max(j.jaql101fch)
                               from JAQL101 j
                              where JAQL101Pgc = v_pgcod
                                and JAQL101Cta = v_Sccta
                                and JAQL101Ope = v_Scoper
                             );

  exception
    when no_data_found then
        begin

           select trim(wv.WFAttSVal)
             into ln_sector
             from wfattsvalues wv
            where WFINSPRCID = v_instancia
              and WFAttSId   = 'SECTOR';
        exception
          when others then
               ln_sector := null;
        end;
    when too_many_rows then
               ln_sector := null;
   end;

  return ln_sector;
end fn_sector_credito_bt;
/

