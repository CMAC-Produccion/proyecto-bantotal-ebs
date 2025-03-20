CREATE OR REPLACE PROCEDURE sp_cr_ctrlextorno_cuenta_2(pn_emp  in number,
                                                       pn_mod  in number,
                                                       pn_suc  in number,
                                                       pn_mda  in number,
                                                       pn_pap  in number,
                                                       pn_cta  in number,
                                                       pn_ope  in number,
                                                       pn_sbo  in number,
                                                       pn_top  in number,
                                                       pd_fec  in date,
                                                       pn_cor  in number,
                                                       pn_rpta out number) IS
  contador  numeric(5);
  contadorh numeric(5);
  fechamin  date;
  corremin  numeric(9);
begin
  pn_rpta := 0;
  select count(*)
    into contador
    from fsd016 a
   inner join fsd015 b
      on a.pgcod = b.pgcod
     and a.itsuc = b.itsuc
     and a.itmod = b.itmod
     and a.ittran = b.ittran
     and a.itnrel = b.itnrel
   inner join fsd011 x --- Se agregó jrodriguej 09.06.2021
      on x.PGCOD = a.PGCOD
     and x.SCMOD = a.modulo
     and x.SCSUC = a.itsucd
     and x.SCMDA = a.moneda
     and x.SCPAP = a.papel
     and x.SCCTA = a.ctnro
     and x.SCOPER = a.itoper
     and x.SCSBOP = a.itsubo
     and x.SCTOPE = a.ittope
   where a.pgcod = pn_emp
     and a.itmod = 98
     and a.ittran in (570, 571, 579) --- se agregó 579 jrodriguej 13.02.2021, 
        --and a.modulo = pn_mod
        --and a.itsucd = pn_suc
     and a.modulo in (417, 418) --- Se agregó jrodriguej 09.06.2021
     and a.moneda = pn_mda
     and a.papel = pn_pap
     and a.ctnro = pn_cta
     and a.itoper = pn_ope
     and a.itsubo = pn_sbo
        --and a.ittope = pn_top
     and b.itcorr = 0
     and b.itcont = 'S';

  select count(*)
    into contadorh
    from fsh016 a
   inner join fsh015 b
      on a.pgcod = b.pgcod
     and a.hcmod = b.hcmod
     and a.hsucor = b.hsucor
     and a.htran = b.htran
     and a.hnrel = b.hnrel
     and a.hfcon = b.hfcon
   inner join fsd011 x --- Se agregó jrodriguej 09.06.2021
      on x.PGCOD = a.PGCOD
     and x.SCMOD = a.HMODUL
     and x.SCSUC = a.HSUCUR
     and x.SCMDA = a.HMDA
     and x.SCPAP = a.HPAP
     and x.SCCTA = a.HCTA
     and x.SCOPER = a.HOPER
     and x.SCSBOP = a.HSUBOP
     and x.SCTOPE = a.HTOPER
   where a.pgcod = pn_emp
     and a.hcmod = 98
     and a.htran in (570, 571, 579) --- se agregó 579 jrodriguej 13.02.2021
        --and a.hmodul = pn_mod
        --and a.hsucur = pn_suc
     and a.HMODUL in (417, 418) --- Se agregó jrodriguej 09.06.2021
     and a.hmda = pn_mda
     and a.hpap = pn_pap
     and a.hcta = pn_cta
     and a.hoper = pn_ope
     and a.hsubop = pn_sbo
        --and a.htoper = pn_top
     and b.hccorr = 0;
  pn_rpta := contador + contadorh;
  
  if pn_rpta > 0 then
    --chernandez 10/07/2020
    begin
      select ld_reprog, ld_corr
        into fechamin, corremin
        from (select *
                from (select AQPB002FEP ld_reprog, AQPB002COR ld_corr
                        from aqpb002 a
                       where a.aqpb002emp = pn_emp
                         and a.aqpb002mod = pn_mod
                         and a.aqpb002suc = pn_suc
                         and a.aqpb002mda = pn_mda
                         and a.aqpb002pap = pn_pap
                         and a.aqpb002cta = pn_cta
                         and a.aqpb002ope = pn_ope
                         and a.aqpb002sbo = pn_sbo
                         and a.aqpb002top = pn_top
                         and a.aqpb002pro10 = 'S'
                         and a.aqpb002pro11 = 'S'
                         and a.aqpb002pro601 = 'S'
                         and a.aqpb002pro611 = 'S'
                         and a.aqpb002est = 'C'
                         and nvl(a.aqpb002revr, 'N') = 'N'
                         and exists (select *
                                from fsd010
                               where pgcod = a.aqpb002emp
                                 and aomod = a.aqpb002mod
                                 and aosuc = a.aqpb002suc
                                 and aomda = a.aqpb002mda
                                 and aopap = a.aqpb002pap
                                 and aocta = a.aqpb002cta
                                 and aooper = a.aqpb002ope
                                 and aosbop = a.aqpb002sbo
                                 and aotope = a.aqpb002top
                                 and aostat <> 99)
                      --- JAQZ698
                      union
                      select j.jaqz698fep, j.jaqz698cor
                        from jaqz698 j
                       where j.jaqz698emp = pn_emp
                         and j.jaqz698mod = pn_mod
                         and j.jaqz698suc = pn_suc
                         and j.jaqz698mda = pn_mda
                         and j.jaqz698pap = pn_pap
                         and j.jaqz698cta = pn_cta
                         and j.jaqz698ope = pn_ope
                         and j.jaqz698sbo = pn_sbo
                         and j.jaqz698top = pn_top
                         and j.jaqz698est = 'C'
                         and exists (select *
                                from fsd010
                               where pgcod = j.jaqz698emp
                                 and aomod = j.jaqz698mod
                                 and aosuc = j.jaqz698suc
                                 and aomda = j.jaqz698mda
                                 and aopap = j.jaqz698pap
                                 and aocta = j.jaqz698cta
                                 and aooper = j.jaqz698ope
                                 and aosbop = j.jaqz698sbo
                                 and aotope = j.jaqz698top
                                 and aostat <> 99)
                      -- AQPB088
                      union
                      select k.aqpb088fep, k.aqpb088cor
                        from aqpb088 k
                       where k.aqpb088emp = pn_emp
                         and k.aqpb088mod = pn_mod
                         and k.aqpb088suc = pn_suc
                         and k.aqpb088mda = pn_mda
                         and k.aqpb088pap = pn_pap
                         and k.aqpb088cta = pn_cta
                         and k.aqpb088ope = pn_ope
                         and k.aqpb088sbo = pn_sbo
                         and k.aqpb088top = pn_top
                         and k.aqpb088est = 'C'
                         and exists (select *
                                from fsd010
                               where pgcod = k.aqpb088emp
                                 and aomod = k.aqpb088mod
                                 and aosuc = k.aqpb088suc
                                 and aomda = k.aqpb088mda
                                 and aopap = k.aqpb088pap
                                 and aocta = k.aqpb088cta
                                 and aooper = k.aqpb088ope
                                 and aosbop = k.aqpb088sbo
                                 and aotope = k.aqpb088top
                                 and aostat <> 99)
                      
                      ) b
               order by b.ld_reprog, b.ld_corr)
       where rownum = 1;
      --apachecoh 2023.05.12 
      if pd_fec >= fechamin then
        pn_rpta := 0;
      end if;
    exception
      when others then
        null;
    end;
  
  end if;

END sp_cr_ctrlextorno_cuenta_2;
/

