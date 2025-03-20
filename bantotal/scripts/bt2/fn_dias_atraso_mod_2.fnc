create or replace function fn_dias_atraso_mod_2(
                                           v_Pgfape in date, --fecha de proceso
                                           v_Pgcod  in number,
                                           v_Scmod  in number,
                                           v_Scsuc  in number,
                                           v_Scmda  in number,
                                           v_Scpap  in number,
                                           v_Sccta  in number,
                                           v_Scoper in number,
                                           v_Scsbop in number,
                                           v_Sctope in number,
                                           v_Scstat in number
                                         ) return number is

    ln_diatr number;
  begin

        if v_Scstat in (64,33) then -- judicial y castigados
           begin
               select v_Pgfape - c.aofval
                 into ln_diatr
                 from fsd010 c
                 where  c.pgcod  = v_Pgcod
                    and c.aomod  = v_Scmod
                    and c.aosuc  = v_Scsuc
                    and c.aomda  = v_Scmda
                    and c.aopap  = v_Scpap
                    and c.aocta  = v_Sccta
                    and c.aooper = v_Scoper
                    and c.aosbop = v_Scsbop
                    and c.aotope = v_Sctope;
           exception
              when no_data_found then
                  ln_diatr := null;
           end;
        else

            begin
              --vigente y refinanciado
              SELECT (v_Pgfape - min(a.Ppfpag))
                     into ln_diatr
              FROM FSD601 a left join FSD602 b
              on
                    b.Pgcod  = a.Pgcod
                and b.Ppmod  = a.Ppmod
                and b.Ppsuc  = a.Ppsuc
                and b.Ppmda  = a.Ppmda
                and b.Pppap  = a.Pppap
                and b.Ppcta  = a.Ppcta
                and b.Ppoper = a.Ppoper
                and b.Ppsbop = a.Ppsbop
                and b.Pptope = a.Pptope
                and b.Ppfpag = a.Ppfpag
                and b.Pptipo = a.Pptipo
                and b.Pp1stat = 'T'
                and b.D602co  = 'S'
                and b.pp1fech<= v_Pgfape
              where
                    a.Pgcod  = v_Pgcod
                and a.Ppmod  = v_Scmod
                and a.Ppsuc  = v_Scsuc
                and a.Ppmda  = v_Scmda
                and a.Pppap  = v_Scpap
                and a.Ppcta  = v_Sccta
                and a.Ppoper = v_Scoper
                and a.Ppsbop = v_Scsbop
                and a.Pptope = v_Sctope
                and a.Ppfpag <= v_Pgfape
                and a.D601co = 'S'
                --and b.pptipo  <> 'K'
                and (a.ppcap + a.ppint ) > 0
                and b.D602co is null;
          exception
            when no_data_found then

            Begin
                 select (v_Pgfape - min(d.Ppfpag))
                 into ln_diatr
                 from fsd601 d
                 where     d.Pgcod  = v_Pgcod
                and d.Ppmod  = v_Scmod
                and d.Ppsuc  = v_Scsuc
                and d.Ppmda  = v_Scmda
                and d.Pppap  = v_Scpap
                and d.Ppcta  = v_Sccta
                and d.Ppoper = v_Scoper
                and d.Ppsbop = v_Scsbop
                and d.Pptope = v_Sctope
                and d.Ppfpag <= v_Pgfape
                and (d.ppcap + d.ppint ) > 0;
            exception
            when no_data_found then
                 ln_diatr := null;
            End;

          end;
      end if;
    --end;

  return(NVL(ln_diatr,0));
end;
/

