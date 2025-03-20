create or replace procedure sp_sector_credito(
                                               v_fecpro in date,
                                               v_pgcod  in number,
                                               v_Scmod  in number,
                                               v_Scsuc  in number,
                                               v_Scmda  in number,
                                               v_Scpap  in number,
                                               v_Sccta  in number,
                                               v_Scoper in number,
                                               v_Scsbop in number,
                                               v_Sctope in number,
                                               pn_sector out number) is

    ln_sector jaql101.jaql101scl%type;
    ln_instancia number(10);

  begin

  begin
            select   JAQL101Scl
                     into ln_sector
            from
            (
                  select   JAQL101Scl

                    from   JAQL101
                   where   JAQL101Pgc =  v_pgcod
                       and JAQL101Mod =  v_Scmod
                       and JAQL101Suc =  v_Scsuc
                       and JAQL101Mon =  v_Scmda
                       and JAQL101Pap =  v_Scpap
                       and JAQL101Cta =  v_Sccta
                       and JAQL101Ope =  v_Scoper
                       and JAQL101Sop =  v_Scsbop
                       and JAQL101Top =  v_Sctope
                       and JAQL101Fch <= v_fecpro
                order by JAQL101Fch desc, JAQL101COR desc
            ) where rownum = 1;
  exception
    when no_data_found then
        begin

      --entontrar instancia
       select
            max(xw2.xwfprcins) xwfprcins
            into ln_instancia
       from xwf700 xw2
       where
               /*xw2.xwfsucursal  =  v_Scsuc
           and */xw2.xwfmoneda    =  v_Scmda
           and xw2.xwfpapel     =  v_Scpap
           and xw2.xwfcuenta    =  v_Sccta
           and xw2.xwfoperacion =  v_Scoper
           and xw2.xwfsubope    =  v_Scsbop
           --and xw2.xwfmodulo    =  (case v_Scmod when 116 then 117 else v_Scmod end)
           and (xw2.xwfmodulo    =  v_Scmod
                or xw2.xwfmodulo    =  (case v_Scmod when 116 then 117 else v_Scmod end)
               )
           and xw2.xwftipope    =  v_Sctope;
           --and xw2.xwfcar3      = '1';

        if ln_instancia is null then
           --select /*+index_ss(xw2) parallel(rel,2,1)*/
           select /*+index_ss(xw2)*/ --27.10.2014
                max(xw2.xwfprcins) xwfprcins
                into ln_instancia
           from xwf700 xw2,
                Fsr011 rel
           where
                   /*xw2.xwfsucursal  =  rel.r2suc
               and */xw2.xwfmoneda    =  rel.r2mda
               and xw2.xwfpapel     =  rel.r2pap
               and xw2.xwfcuenta    =  rel.r2cta
               and xw2.xwfoperacion =  rel.r2oper
               and xw2.xwfsubope    =  rel.r2sbop
               --and xw2.xwfmodulo    =  (case v_Scmod when 116 then 117 else rel.r2mod end)
               and (xw2.xwfmodulo    =  v_Scmod
                    or xw2.xwfmodulo    =  (case v_Scmod when 116 then 117 else v_Scmod end)
                   )
               and xw2.xwftipope    =  rel.r2tope
               --and xw2.xwfcar3      = '1'
               and rel.r1mod        = v_Scmod
               --and rel.r1suc        = v_Scsuc
               and rel.r1mda        = v_Scmda
               and rel.r1pap        = v_Scpap
               and rel.r1cta        = v_Sccta
               and rel.r1oper       = v_Scoper
               and rel.r1sbop       = v_Scsbop
               and rel.r1tope       = v_Sctope;
         end if;

         select
                trim(wv.WFAttSVal)
               into ln_sector
         from wfattsvalues wv
         where
              WFINSPRCID = ln_instancia
          and WFAttSId   = 'SECTOR';
        exception
        when others then
             ln_sector := null;
        end;
   end;
   pn_sector := ln_sector;

end;
/

