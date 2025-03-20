create or replace procedure sp_cuotas_atrasadas(pn_cta in number, pn_oper in number, pd_fecpro in date,
                            ln_numcuotas out number) is


ln_empC number;
ln_modC number;
ln_sucC number;
ln_mdaC number;
ln_papC number;
ln_ctaC number;
ln_opeC number;
ln_sboC number;
ln_topC number;
ln_maxfecha date;

begin
    begin
        select a.pgcod,
               a.aomod,
               a.aosuc,
               a.aomda,
               a.aopap,
               a.aocta,
               a.aooper,
               a.aosbop,
               a.aotope
          into ln_empC,
               ln_modC,
               ln_sucC,
               ln_mdaC,
               ln_papC,
               ln_ctaC,
               ln_opeC,
               ln_sboC,
               ln_topC
           from fsd010 a
          where a.aocta = pn_cta
            and a.aooper = pn_oper
            and a.aomod in (select modulo from fst111 where dscod = 50)
            and a.aosbop = (select max(aa.aosbop)
                                   from fsd010 aa
                                   where aa.aocta  = a.aocta
                                     and aa.aooper = a.aooper
                                     and aa.aomod in (select modulo from fst111 where dscod = 50))
            and a.aofval = (select max(aa.aofval)
                                   from fsd010 aa
                                   where aa.aocta  = a.aocta
                                     and aa.aooper = a.aooper
                                     and aa.aomod in (select modulo from fst111 where dscod = 50))
            and aomod not in(200,33,65) and aotope <> 550;


            exception
                  when no_data_found then
                       ln_empC := null;
                       ln_modC := null;
                       ln_sucC := null;
                       ln_mdaC := null;
                       ln_papC := null;
                       ln_ctaC := null;
                       ln_opeC := null;
                       ln_sboC := null;
                       ln_topC := null;
                 when too_many_rows then
                    begin
                        select a.pgcod,
                               a.aomod,
                               a.aosuc,
                               a.aomda,
                               a.aopap,
                               a.aocta,
                               a.aooper,
                               a.aosbop,
                               a.aotope
                          into ln_empC,
                               ln_modC,
                               ln_sucC,
                               ln_mdaC,
                               ln_papC,
                               ln_ctaC,
                               ln_opeC,
                               ln_sboC,
                               ln_topC
                           from fsd010 a
                          where a.aocta = pn_cta
                            and a.aooper = pn_oper
                            and a.aomod in (select modulo from fst111 where dscod = 50)
                            and a.aosbop = (select max(aa.aosbop)
                                                   from fsd010 aa
                                                   where aa.aocta  = a.aocta
                                                     and aa.aooper = a.aooper
                                                     and aa.aomod in (select modulo from fst111 where dscod = 50))
                            and a.aofval = (select max(aa.aofval)
                                                   from fsd010 aa
                                                   where aa.aocta  = a.aocta
                                                     and aa.aooper = a.aooper
                                                     and aa.aomod in (select modulo from fst111 where dscod = 50))
                            and aomod not in(200,33,65) and aotope <> 550
                            and rownum = 1;



                            exception
                                  when no_data_found then
                                       ln_empC := null;
                                       ln_modC := null;
                                       ln_sucC := null;
                                       ln_mdaC := null;
                                       ln_papC := null;
                                       ln_ctaC := null;
                                       ln_opeC := null;
                                       ln_sboC := null;
                                       ln_topC := null;
                            end;

            end;

            begin

            select max(o.ppfpag)
               into ln_maxfecha
               from fsd602 o
              where o.pgcod   = ln_empC
                and o.ppmod   = ln_modC
                and o.ppsuc   = ln_sucC
                and o.ppmda   = ln_mdaC
                and o.pppap   = ln_papC
                and o.ppcta   = ln_ctaC
                and o.ppoper  = ln_opeC
                and o.ppsbop  = ln_sboC
                and o.pptope  = ln_topC
                and o.pp1stat = 'T'
                and o.d602co  = 'S'
                and (d602mo,d602tr) not in ( select 300,390 from dual)
                and (d602mo,d602tr) not in ( select 300,406 from dual)
                and (d602mo,d602tr) not in ( select 300,400 from dual)
                and (d602mo,d602tr) not in ( select 30,350 from dual)
                and (d602mo,d602tr) not in ( select 30,351 from dual)
                and (o.pp1cap+o.pp1int)<>0;
          exception
              when no_data_found then
                 ln_maxfecha := null;
              when too_many_rows then
                    begin

                    select max(o.ppfpag)
                    into ln_maxfecha
                    from fsd602 o
                    where o.pgcod   = ln_empC
                    and o.ppmod   = ln_modC
                    and o.ppsuc   = ln_sucC
                    and o.ppmda   = ln_mdaC
                    and o.pppap   = ln_papC
                    and o.ppcta   = ln_ctaC
                    and o.ppoper  = ln_opeC
                    and o.ppsbop  = ln_sboC
                    and o.pptope  = ln_topC
                    and o.pp1stat = 'T'
                    and o.d602co  = 'S'
                    and (d602mo,d602tr) not in ( select 300,390 from dual)
                    and (d602mo,d602tr) not in ( select 300,406 from dual)
                    and (d602mo,d602tr) not in ( select 300,400 from dual)
                    and (d602mo,d602tr) not in ( select 30,350 from dual)
                    and (d602mo,d602tr) not in ( select 30,351 from dual)
                    and (o.pp1cap+o.pp1int)<>0
                    and rownum = 1;
                    exception
                    when no_data_found then
                     ln_maxfecha := null;
                    end;
          end;

          begin

          select count (*)
               into ln_numcuotas
               from fsd601 p
              where p.pgcod   = ln_empC
                and p.ppmod   = ln_modC
                and p.ppsuc   = ln_sucC
                and p.ppmda   = ln_mdaC
                and p.pppap   = ln_papC
                and p.ppcta   = ln_ctaC
                and p.ppoper  = ln_opeC
                and p.ppsbop  = ln_sboC
                and p.pptope  = ln_topC
                and p.ppfpag  > ln_maxfecha
                and p.ppfpag  <= pd_fecpro;
          exception
              when no_data_found then
                 ln_numcuotas := null;

          end;


end sp_cuotas_atrasadas;
/

