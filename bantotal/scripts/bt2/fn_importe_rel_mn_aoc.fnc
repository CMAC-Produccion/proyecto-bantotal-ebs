create or replace function fn_importe_rel_mn_aoc(P_PGCOD in number,
                                                   P_SCMOD in number,
                                                   P_SCSUC in number,
                                                   P_SCMDA in number,
                                                   P_SCPAP in number,
                                                   P_SCCTA in number,
                                                   P_SCOPE in number,
                                                   P_SCSBO in number,
                                                   P_SCTOP in number,
                                                   P_RUBRO in number,
                                                   P_FECHA in date,
                                                   P_RELAC in number
                                                  ) return number
is
  ln_importe fsd011.scsdo%type;
begin
     /*Select nvl(h012.bcsdmn,0)
       Into ln_importe
       From fsr014 r014 join fsh012_prv h012 on h012.bcemp  = P_PGCOD
                                        and h012.bcsuc  = P_SCSUC
                                        and h012.bcrubr = r014.rrrubr
                                        and h012.bcmda  = P_SCMDA
                                        and h012.bcpap  = P_SCPAP
                                        and h012.bccta  = P_SCCTA
                                        and h012.bcoper = P_SCOPE
                                        and h012.bcsbop = P_SCSBO
                                        --and h012.bctop  = P_SCTOP
                                        and h012.bcfech = P_FECHA
                                        --and h012.bcmod  = P_SCMOD
      Where r014.rubro = P_RUBRO
        And r014.rrcod = P_RELAC;*/

     Select nvl(d11.scsdo,0)
       Into ln_importe
       From fsr014 r014 join fsd011 d11 on d11.pgcod   = P_PGCOD
                                        and d11.scsuc  = P_SCSUC
                                        and d11.scrub  = r014.rrrubr
                                        and d11.scmda  = P_SCMDA
                                        and d11.scpap  = P_SCPAP
                                        and d11.sccta  = P_SCCTA
                                        and d11.scoper = P_SCOPE
                                        and d11.scsbop = P_SCSBO
                                        --and h012.bctop  = P_SCTOP
                                        --and h012.bcfech = P_FECHA
                                        --and h012.bcmod  = P_SCMOD
      Where r014.rubro = P_RUBRO
        And r014.rrcod = P_RELAC;

    Return ln_importe;
Exception When others then
          Return 0;
end fn_importe_rel_mn_aoc;
/

