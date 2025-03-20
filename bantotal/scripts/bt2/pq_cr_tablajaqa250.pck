create or replace package pq_cr_tablaJAQA250 is
  procedure sp_cr_flujocaja(ln_emp10  in number,
                            ln_mod10  in number,
                            ln_suc10  in number,
                            ln_mda10  in number,
                            ln_pap10  in number,
                            ln_cta10  in number,
                            ln_oper10 in number,
                            ln_sbop10 in number,
                            ln_tope10 in number,
                            ln_flagFC out char);
  Procedure Sp_carga;
  Procedure Sp_carga_JAQA250(pd_fecpro in date);
  --Procedure Sp_carga_AQPA867;
end pq_cr_tablaJAQA250;
/

create or replace package body pq_Cr_tablaJAQA250 is

  procedure sp_cr_flujocaja(ln_emp10  in number,
                            ln_mod10  in number,
                            ln_suc10  in number,
                            ln_mda10  in number,
                            ln_pap10  in number,
                            ln_cta10  in number,
                            ln_oper10 in number,
                            ln_sbop10 in number,
                            ln_tope10 in number,
                            ln_flagFC out char) is
  
    ln_fc           number(17, 2);
    ln_nroflujo     number;
    lc_tienecalen   VARCHAR2(2);
    lc_tieneseguros varchar2(2);
    ld_fecamort     date; --mod@abr 17032020
    lc_Amort        char(1) := 'N'; --mod@abr 17032020
    ld_MaxFch602    date;
  
  begin
  
    begin
      -- verifica si tiene calendario de pago 05/07/2017 mpostigoc
    
      select 'S'
        into lc_tienecalen
        from fsd601 f
       where f.pgcod = ln_emp10
         and f.ppmod = ln_mod10
         and f.ppsuc = ln_suc10
         and f.ppmda = ln_mda10
         and f.pppap = ln_pap10
         and f.ppcta = ln_cta10
         and f.ppoper = ln_oper10
         and f.ppsbop = ln_sbop10
         and f.pptope = ln_tope10
         and rownum = 1;
    exception
      when others then
        lc_tienecalen := 'N';
    end;
  
    begin
      -- Verifica si tiene calendario de Seguros 05/07/2017 mpostigoc
      select 'S'
        into lc_tieneseguros
        from fsd611 f
       where f.pgcod = ln_emp10
         and f.ppmod = ln_mod10
         and f.ppsuc = ln_suc10
         and f.ppmda = ln_mda10
         and f.pppap = ln_pap10
         and f.ppcta = ln_cta10
         and f.ppoper = ln_oper10
         and f.ppsbop = ln_sbop10
         and f.pptope = ln_tope10
         and rownum = 1;
    exception
      when others then
        lc_tieneseguros := 'N';
    end;
  
    -- Verificamos la ultima fecha de la fsd602
    begin
      select max(f.ppfpag)
        into ld_MaxFch602
        from fsd602 f
       where f.pgcod = ln_emp10
         and f.ppmod = ln_mod10
         and f.ppsuc = ln_suc10
         and f.ppmda = ln_mda10
         and f.pppap = ln_pap10
         and f.ppcta = ln_cta10
         and f.ppoper = ln_oper10
         and f.ppsbop = ln_sbop10
         and f.pptope = ln_tope10
         and f.d602co = 'S';
    exception
      when others then
        null;
    end;
  
    --mod@abr 17032020
    ----excluir amortizaciones 
    begin
      select max(a.evfval)
        into ld_fecamort
        from fsd012 a
       where a.pgcod = ln_emp10
         and a.aomod = ln_mod10
         and a.aosuc = ln_suc10
         and a.aomda = ln_mda10
         and a.aopap = ln_pap10
         and a.aocta = ln_cta10
         and a.aooper = ln_oper10
         and a.aosbop = ln_sbop10
         and a.aotope = ln_tope10
         and a.evtipo in (31, 50);
    exception
      when others then
        null;
    end;
  
    if ld_fecamort is not null then
      lc_Amort := 'S';
    else
      lc_Amort := 'N';
    end if;
    --mod@abr 17032020
  
    if lc_Amort = 'S' then
      --mod@abr 17032020
      if lc_tienecalen = 'S' and lc_tieneseguros = 'S' then
        --05/07/2017 mpostigoc
      
        begin
        
          select max(f.ppcap + f.ppint + s.ppimp11 + s.ppimp12 + s.ppimp13 +
                     s.ppimp14 + s.ppimp15) -
                 min(f.ppcap + f.ppint + s.ppimp11 + s.ppimp12 + s.ppimp13 +
                     s.ppimp14 + s.ppimp15)
            into ln_fc
            from fsd601 f, fsd611 s
           where f.pgcod = ln_emp10
             and f.ppmod = ln_mod10
             and f.ppsuc = ln_suc10
             and f.ppmda = ln_mda10
             and f.pppap = ln_pap10
             and f.ppcta = ln_cta10
             and f.ppoper = ln_oper10
             and f.ppsbop = ln_sbop10
             and f.pptope = ln_tope10
             and f.pgcod = s.pgcod
             and f.ppmod = s.ppmod
             and f.ppsuc = s.ppsuc
             and f.ppmda = s.ppmda
             and f.pppap = s.pppap
             and f.ppcta = s.ppcta
             and f.ppoper = s.ppoper
             and f.ppsbop = s.ppsbop
             and f.pptope = s.pptope
             and f.ppfpag = s.ppfpag
             and f.ppfpag > ld_fecamort --mod@abr 17032020
          ;
        exception
          when others then
            null;
          
        end;
      
      else
        if lc_tienecalen = 'S' and lc_tieneseguros = 'N' then
          --05/07/2017 mpostigoc
        
          begin
          
            select max(f.ppcap + f.ppint) - min(f.ppcap + f.ppint)
              into ln_fc
              from fsd601 f
             where f.pgcod = ln_emp10
               and f.ppmod = ln_mod10
               and f.ppsuc = ln_suc10
               and f.ppmda = ln_mda10
               and f.pppap = ln_pap10
               and f.ppcta = ln_cta10
               and f.ppoper = ln_oper10
               and f.ppsbop = ln_sbop10
               and f.pptope = ln_tope10
               and f.ppfpag > ld_fecamort --mod@abr 17032020
            ;
          exception
            when others then
              null;
            
          end;
        
        end if;
      end if;
    else
      if lc_tienecalen = 'S' and lc_tieneseguros = 'S' then
        --mpostigoc
      
        if ld_MaxFch602 is not null then
          begin
            select max(f.ppcap + f.ppint + s.ppimp11 + s.ppimp12 +
                       s.ppimp13 + s.ppimp14 + s.ppimp15) -
                   min(f.ppcap + f.ppint + s.ppimp11 + s.ppimp12 +
                       s.ppimp13 + s.ppimp14 + s.ppimp15)
              into ln_fc
              from fsd601 f, fsd611 s
             where f.pgcod = ln_emp10
               and f.ppmod = ln_mod10
               and f.ppsuc = ln_suc10
               and f.ppmda = ln_mda10
               and f.pppap = ln_pap10
               and f.ppcta = ln_cta10
               and f.ppoper = ln_oper10
               and f.ppsbop = ln_sbop10
               and f.pptope = ln_tope10
               and f.pgcod = s.pgcod
               and f.ppmod = s.ppmod
               and f.ppsuc = s.ppsuc
               and f.ppmda = s.ppmda
               and f.pppap = s.pppap
               and f.ppcta = s.ppcta
               and f.ppoper = s.ppoper
               and f.ppsbop = s.ppsbop
               and f.pptope = s.pptope
               and f.ppfpag = s.ppfpag
               and f.ppfpag > ld_MaxFch602;
          exception
            when others then
              null;
            
          end;
        else
          begin
            select max(f.ppcap + f.ppint + s.ppimp11 + s.ppimp12 +
                       s.ppimp13 + s.ppimp14 + s.ppimp15) -
                   min(f.ppcap + f.ppint + s.ppimp11 + s.ppimp12 +
                       s.ppimp13 + s.ppimp14 + s.ppimp15)
              into ln_fc
              from fsd601 f, fsd611 s
             where f.pgcod = ln_emp10
               and f.ppmod = ln_mod10
               and f.ppsuc = ln_suc10
               and f.ppmda = ln_mda10
               and f.pppap = ln_pap10
               and f.ppcta = ln_cta10
               and f.ppoper = ln_oper10
               and f.ppsbop = ln_sbop10
               and f.pptope = ln_tope10
               and f.pgcod = s.pgcod
               and f.ppmod = s.ppmod
               and f.ppsuc = s.ppsuc
               and f.ppmda = s.ppmda
               and f.pppap = s.pppap
               and f.ppcta = s.ppcta
               and f.ppoper = s.ppoper
               and f.ppsbop = s.ppsbop
               and f.pptope = s.pptope
               and f.ppfpag = s.ppfpag;
          exception
            when others then
              null;
            
          end;
        end if;
      
      else
        if lc_tienecalen = 'S' and lc_tieneseguros = 'N' then
          --mpostigoc
        
          if ld_MaxFch602 is not null then
          
            begin
            
              select max(f.ppcap + f.ppint) - min(f.ppcap + f.ppint)
                into ln_fc
                from fsd601 f
               where f.pgcod = ln_emp10
                 and f.ppmod = ln_mod10
                 and f.ppsuc = ln_suc10
                 and f.ppmda = ln_mda10
                 and f.pppap = ln_pap10
                 and f.ppcta = ln_cta10
                 and f.ppoper = ln_oper10
                 and f.ppsbop = ln_sbop10
                 and f.pptope = ln_tope10
                 and f.ppfpag > ld_MaxFch602;
            exception
              when others then
                null;
            end;
          else
            begin
            
              select max(f.ppcap + f.ppint) - min(f.ppcap + f.ppint)
                into ln_fc
                from fsd601 f
               where f.pgcod = ln_emp10
                 and f.ppmod = ln_mod10
                 and f.ppsuc = ln_suc10
                 and f.ppmda = ln_mda10
                 and f.pppap = ln_pap10
                 and f.ppcta = ln_cta10
                 and f.ppoper = ln_oper10
                 and f.ppsbop = ln_sbop10
                 and f.pptope = ln_tope10;
            exception
              when others then
                null;
              
            end;
          
          end if;
        
        end if;
      end if;
    end if;
  
    begin
    
      select tp1nro1
        into ln_nroflujo
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and tp1corr1 = 13
         and tp1corr2 = 3;
    end;
  
    if ln_fc is not null then
    
      if ln_fc <= ln_nroflujo then
        ln_flagFC := 'N';
      else
        ln_flagFC := 'S';
      END IF;
    
    else
      if ln_fc is null then
        ln_flagFC := 'N';
      
      end if;
    
    end if;
  end sp_cr_flujocaja;

  Procedure Sp_carga is
  
    cursor creditos is
      select *
        from aqpb002 a
       where a.aqpb002est = 'C'
         and a.aqpb002fep =
             (select min(b.aqpb002fep)
                from aqpb002 b
               where b.aqpb002emp = a.aqpb002emp
                 and b.aqpb002mod = a.aqpb002mod
                 and b.aqpb002suc = a.aqpb002suc
                 and b.aqpb002mda = a.aqpb002mda
                 and b.aqpb002pap = a.aqpb002pap
                 and b.aqpb002cta = a.aqpb002cta
                 and b.aqpb002ope = a.aqpb002ope
                 and b.aqpb002sbo = a.aqpb002sbo
                 and b.aqpb002top = a.aqpb002top);
    ld_fecpxv date;
    ln_cont   number(10);
    ln_perio  number(5);
    ln_mto    number(17, 2);
    ln_seg    number(17, 2);
    ln_cuo1   number(17, 2);
    ln_cuota  number(17, 2);
    lc_pago   char(1) := 'N';
    lc_flujo  char(1) := 'N';
    lc_ind    char(1) := 'S';
    lc_mot    char(1) := 'N';
  begin
    for i in creditos loop
    
      begin
        select 'S'
          into lc_pago
          from fsd602 a
         where a.pgcod = i.aqpb002emp
           and a.ppmod = i.aqpb002mod
           and a.ppsuc = i.aqpb002suc
           and a.ppmda = i.aqpb002mda
           and a.pppap = i.aqpb002pap
           and a.ppcta = i.aqpb002cta
           and a.ppoper = i.aqpb002ope
           and a.ppsbop = i.aqpb002sbo
           and a.pptope = i.aqpb002top
           and a.pp1fech >= i.aqpb002fep
           and a.d602co = 'S';
      exception
        when others then
          null;
      end;
    
      pq_Cr_tablaJAQA250.sp_cr_flujocaja(ln_emp10  => i.aqpb002emp,
                                         ln_mod10  => i.aqpb002mod,
                                         ln_suc10  => i.aqpb002suc,
                                         ln_mda10  => i.aqpb002mda,
                                         ln_pap10  => i.aqpb002pap,
                                         ln_cta10  => i.aqpb002cta,
                                         ln_oper10 => i.aqpb002ope,
                                         ln_sbop10 => i.aqpb002sbo,
                                         ln_tope10 => i.aqpb002top,
                                         ln_flagFC => lc_flujo);
    
      if lc_pago = 'S' or lc_flujo = 'S' then
        lc_ind := 'N';
      end if;
    
      if lc_pago = 'S' then
        lc_mot := 'P';
      end if;
    
      if lc_flujo = 'S' then
        lc_mot := 'F';
      end if;
    
      begin
        select min(n.ppfpag)
          into ld_fecpxv
          from fsd601 n
         where n.pgcod = i.aqpb002emp
           and n.ppcta = i.aqpb002cta
           and n.ppmda = i.aqpb002mda
           and n.ppsuc = i.aqpb002suc
           and n.pppap = i.aqpb002pap
           and n.ppoper = i.aqpb002ope
           and n.ppsbop = i.aqpb002sbo
           and n.pptope = i.aqpb002top
           and n.ppmod = i.aqpb002mod
           and n.d601co = 'S'
           and (n.ppcap + n.ppint) <> 0
           and not exists
        
         (select ppmod, ppcta, ppoper, pptope, ppfpag
                  from fsd602 o
                 where o.pgcod = n.pgcod
                   and o.ppmod = n.ppmod
                   and o.ppsuc = n.ppsuc
                   and o.ppmda = n.ppmda
                   and o.pppap = n.pppap
                   and o.ppcta = n.ppcta
                   and o.ppoper = n.ppoper
                   and o.ppsbop = n.ppsbop
                   and o.pptope = n.pptope
                   and o.ppfpag = n.ppfpag
                      --and o.pp1fech <= pd_fecpro
                   and o.pp1stat = 'T'
                   and o.d602co = 'S'
                   and (o.pp1cap + o.pp1int) <> 0);
      exception
        when others then
          null;
      end;
    
      begin
      
        select count(*)
          into ln_cont
          from fsd601 n
         where n.pgcod = i.aqpb002emp
           and n.ppcta = i.aqpb002cta
           and n.ppmda = i.aqpb002mda
           and n.ppsuc = i.aqpb002suc
           and n.pppap = i.aqpb002pap
           and n.ppoper = i.aqpb002ope
           and n.ppsbop = i.aqpb002sbo
           and n.pptope = i.aqpb002top
           and n.ppmod = i.aqpb002mod
           and n.d601co = 'S'
           and (n.ppcap + n.ppint) <> 0
           and not exists
        
         (select ppmod, ppcta, ppoper, pptope, ppfpag
                  from fsd602 o
                 where o.pgcod = n.pgcod
                   and o.ppmod = n.ppmod
                   and o.ppsuc = n.ppsuc
                   and o.ppmda = n.ppmda
                   and o.pppap = n.pppap
                   and o.ppcta = n.ppcta
                   and o.ppoper = n.ppoper
                   and o.ppsbop = n.ppsbop
                   and o.pptope = n.pptope
                   and o.ppfpag = n.ppfpag
                      --and o.pp1fech <= pd_fecpro
                   and o.pp1stat = 'T'
                   and o.d602co = 'S'
                   and (o.pp1cap + o.pp1int) <> 0);
      exception
        when others then
          null;
      end;
    
      begin
        select a.aoperiod
          into ln_perio
          from fsd010 a
         where a.pgcod = i.aqpb002emp
           and a.aomod = i.aqpb002mod
           and a.aosuc = i.aqpb002suc
           and a.aomda = i.aqpb002mda
           and a.aopap = i.aqpb002pap
           and a.aocta = i.aqpb002cta
           and a.aooper = i.aqpb002ope
           and a.aosbop = i.aqpb002sbo
           and a.aotope = i.aqpb002top;
      exception
        when others then
          null;
      end;
    
      begin
        select a.scsdo * -1
          into ln_mto
          from fsd011 a
         where a.pgcod = i.aqpb002emp
           and a.scmod = i.aqpb002mod
           and a.scsuc = i.aqpb002suc
           and a.scmda = i.aqpb002mda
           and a.scpap = i.aqpb002pap
           and a.sccta = i.aqpb002cta
           and a.scoper = i.aqpb002ope
           and a.scsbop = i.aqpb002sbo
           and a.sctope = i.aqpb002top;
      exception
        when others then
          null;
      end;
    
      begin
      
        select n.ppcap + n.ppint
          into ln_cuo1
          from fsd601 n
         where n.pgcod = i.aqpb002emp
           and n.ppcta = i.aqpb002cta
           and n.ppmda = i.aqpb002mda
           and n.ppsuc = i.aqpb002suc
           and n.pppap = i.aqpb002pap
           and n.ppoper = i.aqpb002ope
           and n.ppsbop = i.aqpb002sbo
           and n.pptope = i.aqpb002top
           and n.ppmod = i.aqpb002mod
           and n.d601co = 'S'
           and (n.ppcap + n.ppint) <> 0
           and n.ppfpag = ld_fecpxv;
      exception
        when others then
          null;
      end;
    
      begin
      
        select (b.ppimp11 + b.ppimp12 + b.ppimp13 + b.ppimp14 + b.ppimp15)
          into ln_seg
          from fsd601 n, fsd611 b
         where n.pgcod = i.aqpb002emp
           and n.ppcta = i.aqpb002cta
           and n.ppmda = i.aqpb002mda
           and n.ppsuc = i.aqpb002suc
           and n.pppap = i.aqpb002pap
           and n.ppoper = i.aqpb002ope
           and n.ppsbop = i.aqpb002sbo
           and n.pptope = i.aqpb002top
           and n.ppmod = i.aqpb002mod
           and n.d601co = 'S'
           and (n.ppcap + n.ppint) <> 0
           and n.ppfpag = ld_fecpxv
           and n.pgcod = b.pgcod
           and n.ppcta = b.ppcta
           and n.ppmda = b.ppmda
           and n.ppsuc = b.ppsuc
           and n.pppap = b.pppap
           and n.ppoper = b.ppoper
           and n.ppsbop = b.ppsbop
           and n.pptope = b.pptope
           and n.ppmod = b.ppmod
           and n.ppfpag = b.ppfpag;
      exception
        when others then
          null;
      end;
    
      ln_cuota := nvl(ln_cuo1, 0) + nvl(ln_seg, 0);
    
      insert into aqpa865
        (AQPA865emp,
         AQPA865mod,
         AQPA865suc,
         AQPA865mda,
         AQPA865pap,
         AQPA865cta,
         AQPA865ope,
         AQPA865sbo,
         AQPA865tpo,
         AQPA865fre,
         AQPA865fpg,
         AQPA865est,
         AQPA865ccu,
         AQPA865pcu,
         AQPA865scr,
         AQPA865vcu,
         aqpa865ind,
         aqpa865in1)
      values
        (i.aqpb002emp,
         i.aqpb002mod,
         i.aqpb002suc,
         i.aqpb002mda,
         i.aqpb002pap,
         i.aqpb002cta,
         i.aqpb002ope,
         i.aqpb002sbo,
         i.aqpb002top,
         i.aqpb002fep,
         ld_fecpxv,
         'N',
         ln_cont,
         ln_perio,
         ln_mto,
         ln_cuota,
         lc_ind,
         lc_mot);
      commit;
    end loop;
    commit;
  end Sp_carga;

  Procedure Sp_carga_JAQA250(pd_fecpro in date) is
  
    cursor creditos is
      select a.aqpa865aemp aqpb002emp,
             a.aqpa865amod aqpb002mod,
             a.aqpa865asuc aqpb002suc,
             a.aqpa865amda aqpb002mda,
             a.aqpa865apap aqpb002pap,
             a.aqpa865acta aqpb002cta,
             a.aqpa865aope aqpb002ope,
             a.aqpa865asbo aqpb002sbo,
             a.aqpa865atpo aqpb002top,
             a.aqpa865afre aqpb002fep
        from aqpa865_aux a;
    ld_fecpxv date;
    ln_cont   number(10);
    ln_perio  number(5);
    ln_mto    number(17, 2);
    ln_seg    number(17, 2);
    ln_cuo1   number(17, 2);
    ln_cuota  number(17, 2);
    lc_pago   char(1) := 'N';
    lc_flujo  char(1) := 'N';
    --lc_ind    char(1) := 'S';
    --lc_mot    char(1) := 'N';
    ld_fecval date;
    --lc_existe char(1) := 'N';
    ln_estado   number(2);
    ln_contador number(10);
    lc_fpp      char(1) := 'N';
  begin
    execute immediate ('truncate table aqpa865_aux');
    insert into aqpa865_aux
      (aqpa865aemp,
       aqpa865amod,
       aqpa865asuc,
       aqpa865amda,
       aqpa865apap,
       aqpa865acta,
       aqpa865aope,
       aqpa865asbo,
       aqpa865atpo,
       aqpa865afre)
      select a.aqpb002emp,
             a.aqpb002mod,
             a.aqpb002suc,
             a.aqpb002mda,
             a.aqpb002pap,
             a.aqpb002cta,
             a.aqpb002ope,
             a.aqpb002sbo,
             a.aqpb002top,
             a.aqpb002fep
        from aqpb002 a
       where a.aqpb002est = 'C'
         and a.aqpb002mod <> 108
         and nvl(a.aqpb002revr, 'N') = 'N'
         and nvl(a.aqpb002ind, 'N') = 'N'
         and a.aqpb002fep = pd_fecpro
      /*(select min(b.aqpb002fep)
       from aqpb002 b
      where b.aqpb002emp = a.aqpb002emp
        and b.aqpb002mod = a.aqpb002mod
        and b.aqpb002suc = a.aqpb002suc
        and b.aqpb002mda = a.aqpb002mda
        and b.aqpb002pap = a.aqpb002pap
        and b.aqpb002cta = a.aqpb002cta
        and b.aqpb002ope = a.aqpb002ope
        and b.aqpb002sbo = a.aqpb002sbo
        and b.aqpb002top = a.aqpb002top)*/
      ;
    commit;
  
    for i in creditos loop
      ld_fecpxv   := null;
      ln_cont     := 0;
      ln_perio    := null;
      ln_mto      := 0;
      ln_seg      := 0;
      ln_cuo1     := 0;
      ln_cuota    := 0;
      ld_fecval   := null;
      ln_estado   := null;
      ln_contador := 0;
      lc_pago     := 'N';
      lc_flujo    := 'N';
      lc_fpp      := 'N';
    
      begin
        select 'S'
          into lc_pago
          from fsd602 a
         where a.pgcod = i.aqpb002emp
           and a.ppmod = i.aqpb002mod
           and a.ppsuc = i.aqpb002suc
           and a.ppmda = i.aqpb002mda
           and a.pppap = i.aqpb002pap
           and a.ppcta = i.aqpb002cta
           and a.ppoper = i.aqpb002ope
           and a.ppsbop = i.aqpb002sbo
           and a.pptope = i.aqpb002top
           and a.pp1fech >= i.aqpb002fep
           and a.d602co = 'S';
      exception
        when others then
          null;
      end;
    
      pq_Cr_tablaJAQA250.sp_cr_flujocaja(ln_emp10  => i.aqpb002emp,
                                         ln_mod10  => i.aqpb002mod,
                                         ln_suc10  => i.aqpb002suc,
                                         ln_mda10  => i.aqpb002mda,
                                         ln_pap10  => i.aqpb002pap,
                                         ln_cta10  => i.aqpb002cta,
                                         ln_oper10 => i.aqpb002ope,
                                         ln_sbop10 => i.aqpb002sbo,
                                         ln_tope10 => i.aqpb002top,
                                         ln_flagFC => lc_flujo);
    
      begin
        select 'S'
          into lc_fpp
          from fpp002 a
         where a.pgcod = i.aqpb002emp
           and a.ppmod = i.aqpb002mod
           and a.ppsuc = i.aqpb002suc
           and a.ppmda = i.aqpb002mda
           and a.pppap = i.aqpb002pap
           and a.ppcta = i.aqpb002cta
           and a.ppoper = i.aqpb002ope
           and a.ppsbop = i.aqpb002sbo
           and a.pptope = i.aqpb002top
           and rownum = 1;
      
      exception
        when others then
          lc_fpp := 'N';
      end;
      --if lc_pago = 'S' or lc_flujo = 'S' then
      --lc_ind := 'N';
      --end if;
    
      --if lc_pago = 'S' then
      --lc_mot := 'P';
      --end if;
    
      --if lc_flujo = 'S' then
      --lc_mot := 'F';
      --end if;
    
      --if lc_ind = 'S' then
    
      /* begin
        select 'S'
          into lc_existe
          from jaqa250 a
         where a.jaqa250emp = i.aqpb002emp
           and a.jaqa250mod = i.aqpb002mod
           and a.jaqa250suc = i.aqpb002suc
           and a.jaqa250mda = i.aqpb002mda
           and a.jaqa250pap = i.aqpb002pap
           and a.jaqa250cta = i.aqpb002cta
           and a.jaqa250ope = i.aqpb002ope
           and a.jaqa250sbo = i.aqpb002sbo
           and a.jaqa250tpo = i.aqpb002top
           and rownum = 1;
      exception
        when others then
          null;
      end;
      
      if nvl(lc_existe, 'N') = 'N' then*/
      begin
        select count(*)
          into ln_contador
          from fsd601 a
         where a.pgcod = i.aqpb002emp
           and a.ppmod = i.aqpb002mod
           and a.ppsuc = i.aqpb002suc
           and a.ppmda = i.aqpb002mda
           and a.pppap = i.aqpb002pap
           and a.ppcta = i.aqpb002cta
           and a.ppoper = i.aqpb002ope
           and a.ppsbop = i.aqpb002sbo
           and a.pptope = i.aqpb002top
           and a.d601co = 'S';
      exception
        when others then
          null;
      end;
    
      begin
        select a.aoperiod, a.aostat
          into ln_perio, ln_estado
          from fsd010 a
         where a.pgcod = i.aqpb002emp
           and a.aomod = i.aqpb002mod
           and a.aosuc = i.aqpb002suc
           and a.aomda = i.aqpb002mda
           and a.aopap = i.aqpb002pap
           and a.aocta = i.aqpb002cta
           and a.aooper = i.aqpb002ope
           and a.aosbop = i.aqpb002sbo
           and a.aotope = i.aqpb002top;
      exception
        when others then
          null;
      end;
    
      if nvl(ln_estado, 99) <> 99 and nvl(ln_contador, 0) > 1 and
         nvl(lc_pago, 'N') = 'N' and nvl(lc_flujo, 'N') = 'N' and
         nvl(ln_estado, 33) <> 33 and nvl(lc_fpp, 'N') = 'N' then
      
        begin
          select min(n.ppfpag)
            into ld_fecpxv
            from fsd601 n
           where n.pgcod = i.aqpb002emp
             and n.ppcta = i.aqpb002cta
             and n.ppmda = i.aqpb002mda
             and n.ppsuc = i.aqpb002suc
             and n.pppap = i.aqpb002pap
             and n.ppoper = i.aqpb002ope
             and n.ppsbop = i.aqpb002sbo
             and n.pptope = i.aqpb002top
             and n.ppmod = i.aqpb002mod
             and n.d601co = 'S'
             and (n.ppcap + n.ppint) <> 0
             and not exists
          
           (select ppmod, ppcta, ppoper, pptope, ppfpag
                    from fsd602 o
                   where o.pgcod = n.pgcod
                     and o.ppmod = n.ppmod
                     and o.ppsuc = n.ppsuc
                     and o.ppmda = n.ppmda
                     and o.pppap = n.pppap
                     and o.ppcta = n.ppcta
                     and o.ppoper = n.ppoper
                     and o.ppsbop = n.ppsbop
                     and o.pptope = n.pptope
                     and o.ppfpag = n.ppfpag
                        --and o.pp1fech <= pd_fecpro
                     and o.pp1stat = 'T'
                     and o.d602co = 'S'
                     and (o.pp1cap + o.pp1int) <> 0);
        exception
          when others then
            null;
        end;
      
        begin
        
          select count(*)
            into ln_cont
            from fsd601 n
           where n.pgcod = i.aqpb002emp
             and n.ppcta = i.aqpb002cta
             and n.ppmda = i.aqpb002mda
             and n.ppsuc = i.aqpb002suc
             and n.pppap = i.aqpb002pap
             and n.ppoper = i.aqpb002ope
             and n.ppsbop = i.aqpb002sbo
             and n.pptope = i.aqpb002top
             and n.ppmod = i.aqpb002mod
             and n.d601co = 'S'
             and (n.ppcap + n.ppint) <> 0
             and n.ppfpag >= ld_fecpxv;
        exception
          when others then
            null;
        end;
      
        if nvl(ln_cont, 0) > 1 then
        
          begin
            select n.ppfval, n.ppcap + n.ppint
              into ld_fecval, ln_cuo1
              from fsd601 n
             where n.pgcod = i.aqpb002emp
               and n.ppcta = i.aqpb002cta
               and n.ppmda = i.aqpb002mda
               and n.ppsuc = i.aqpb002suc
               and n.pppap = i.aqpb002pap
               and n.ppoper = i.aqpb002ope
               and n.ppsbop = i.aqpb002sbo
               and n.pptope = i.aqpb002top
               and n.ppmod = i.aqpb002mod
               and n.d601co = 'S'
               and (n.ppcap + n.ppint) <> 0
               and n.ppfpag = ld_fecpxv;
          exception
            when others then
              null;
          end;
        
          begin
            select a.scsdo * -1
              into ln_mto
              from fsd011 a
             where a.pgcod = i.aqpb002emp
               and a.scmod = i.aqpb002mod
               and a.scsuc = i.aqpb002suc
               and a.scmda = i.aqpb002mda
               and a.scpap = i.aqpb002pap
               and a.sccta = i.aqpb002cta
               and a.scoper = i.aqpb002ope
               and a.scsbop = i.aqpb002sbo
               and a.sctope = i.aqpb002top;
          exception
            when others then
              null;
          end;
        
          begin
          
            select (b.ppimp11 + b.ppimp12 + b.ppimp13 + b.ppimp14 +
                   b.ppimp15)
              into ln_seg
              from /*fsd601 n, */ fsd611 b
             where b.pgcod = i.aqpb002emp
               and b.ppcta = i.aqpb002cta
               and b.ppmda = i.aqpb002mda
               and b.ppsuc = i.aqpb002suc
               and b.pppap = i.aqpb002pap
               and b.ppoper = i.aqpb002ope
               and b.ppsbop = i.aqpb002sbo
               and b.pptope = i.aqpb002top
               and b.ppmod = i.aqpb002mod
               and b.ppfpag = ld_fecpxv;
          exception
            when others then
              null;
          end;
        
          ln_cuota := nvl(ln_cuo1, 0) + nvl(ln_seg, 0);
        
          insert into jaqa250
            (jaqa250emp,
             jaqa250mod,
             jaqa250suc,
             jaqa250mda,
             jaqa250pap,
             jaqa250cta,
             jaqa250ope,
             jaqa250sbo,
             jaqa250tpo,
             jaqa250fre,
             jaqa250fpg,
             jaqa250est,
             jaqa250ccu,
             jaqa250pcu,
             jaqa250scr,
             jaqa250vcu)
          values
            (i.aqpb002emp,
             i.aqpb002mod,
             i.aqpb002suc,
             i.aqpb002mda,
             i.aqpb002pap,
             i.aqpb002cta,
             i.aqpb002ope,
             i.aqpb002sbo,
             i.aqpb002top,
             ld_fecval, --i.aqpb002fep,
             ld_fecpxv,
             'N',
             ln_cont,
             ln_perio,
             ln_mto,
             ln_cuota);
          commit;
        end if;
      end if;
    end loop;
    commit;
  end Sp_carga_JAQA250;

/*Procedure Sp_carga_AQPA867 is
  
    cursor creditos is
      select a.aqpa865aemp aqpb002emp,
             a.aqpa865amod aqpb002mod,
             a.aqpa865asuc aqpb002suc,
             a.aqpa865amda aqpb002mda,
             a.aqpa865apap aqpb002pap,
             a.aqpa865acta aqpb002cta,
             a.aqpa865aope aqpb002ope,
             a.aqpa865asbo aqpb002sbo,
             a.aqpa865atpo aqpb002top,
             a.aqpa865afre aqpb002fep
        from aqpa865_aux a;
    ld_fecpxv date;
    ln_cont   number(10);
    ln_perio  number(5);
    ln_mto    number(17, 2);
    ln_seg    number(17, 2);
    ln_cuo1   number(17, 2);
    ln_cuota  number(17, 2);
    --lc_pago   char(1) := 'N';
    --lc_flujo  char(1) := 'N';
    --lc_ind    char(1) := 'S';
    --lc_mot    char(1) := 'N';
    ld_fecval date;
    --lc_existe char(1) := 'N';
    ln_estado number(2);
    ln_contador number(10);
  begin
  
    execute immediate ('truncate table aqpa865_aux');
    insert into aqpa865_aux
      (aqpa865aemp,
       aqpa865amod,
       aqpa865asuc,
       aqpa865amda,
       aqpa865apap,
       aqpa865acta,
       aqpa865aope,
       aqpa865asbo,
       aqpa865atpo,
       aqpa865afre)
      select a.aqpb002emp,
             a.aqpb002mod,
             a.aqpb002suc,
             a.aqpb002mda,
             a.aqpb002pap,
             a.aqpb002cta,
             a.aqpb002ope,
             a.aqpb002sbo,
             a.aqpb002top,
             a.aqpb002fep
        from aqpb002 a
       where a.aqpb002est = 'C'
         and a.aqpb002mod <>108
         and a.aqpb002fep =
             (select min(b.aqpb002fep)
                from aqpb002 b
               where b.aqpb002emp = a.aqpb002emp
                 and b.aqpb002mod = a.aqpb002mod
                 and b.aqpb002suc = a.aqpb002suc
                 and b.aqpb002mda = a.aqpb002mda
                 and b.aqpb002pap = a.aqpb002pap
                 and b.aqpb002cta = a.aqpb002cta
                 and b.aqpb002ope = a.aqpb002ope
                 and b.aqpb002sbo = a.aqpb002sbo
                 and b.aqpb002top = a.aqpb002top);
    commit;
  
    for i in creditos loop
      ld_fecpxv := null;
      ln_cont   := 0;
      ln_perio  := null;
      ln_mto    := 0;
      ln_seg    := 0;
      ln_cuo1   := 0;
      ln_cuota  := 0;
      ld_fecval := null;
      ln_estado := null;
      ln_contador := 0;
      
      
      \*begin
        select 'S'
          into lc_pago
          from fsd602 a
         where a.pgcod = i.aqpb002emp
           and a.ppmod = i.aqpb002mod
           and a.ppsuc = i.aqpb002suc
           and a.ppmda = i.aqpb002mda
           and a.pppap = i.aqpb002pap
           and a.ppcta = i.aqpb002cta
           and a.ppoper = i.aqpb002ope
           and a.ppsbop = i.aqpb002sbo
           and a.pptope = i.aqpb002top
           and a.pp1fech >= i.aqpb002fep
           and a.d602co = 'S';
      exception
        when others then
          null;
      end;
      
      pq_Cr_tablaJAQA250.sp_cr_flujocaja(ln_emp10  => i.aqpb002emp,
                                         ln_mod10  => i.aqpb002mod,
                                         ln_suc10  => i.aqpb002suc,
                                         ln_mda10  => i.aqpb002mda,
                                         ln_pap10  => i.aqpb002pap,
                                         ln_cta10  => i.aqpb002cta,
                                         ln_oper10 => i.aqpb002ope,
                                         ln_sbop10 => i.aqpb002sbo,
                                         ln_tope10 => i.aqpb002top,
                                         ln_flagFC => lc_flujo);
      
      if lc_pago = 'S' or lc_flujo = 'S' then
        lc_ind := 'N';
      end if;
      
      if lc_pago = 'S' then
        lc_mot := 'P';
      end if;
      
      if lc_flujo = 'S' then
        lc_mot := 'F';
      end if;
      
      if lc_ind = 'S' then*\
      \* begin
        select 'S'
          into lc_existe
          from jaqa250 a
         where a.jaqa250emp = i.aqpb002emp
           and a.jaqa250mod = i.aqpb002mod
           and a.jaqa250suc = i.aqpb002suc
           and a.jaqa250mda = i.aqpb002mda
           and a.jaqa250pap = i.aqpb002pap
           and a.jaqa250cta = i.aqpb002cta
           and a.jaqa250ope = i.aqpb002ope
           and a.jaqa250sbo = i.aqpb002sbo
           and a.jaqa250tpo = i.aqpb002top
           and rownum = 1;
      exception
        when others then
          null;
      end;
      
      if nvl(lc_existe, 'N') = 'N' then*\
      
      begin
          select count(*)
            into ln_contador
            from fsd601 a 
           where a.pgcod  = i.jaqa250emp
             and a.ppmod  = i.jaqa250mod
             and a.ppsuc  = i.jaqa250suc
             and a.ppmda  = i.jaqa250mda
             and a.pppap  = i.jaqa250pap
             and a.ppcta  = i.jaqa250cta
             and a.ppoper = i.jaqa250ope
             and a.ppsbop = i.jaqa250sbo
             and a.pptope = i.jaqa250tpo
             and a.d601co = 'S';
       exception
       when others then null;
       end;
      
      begin
        select a.aoperiod, a.aostat
          into ln_perio, ln_estado
          from fsd010 a
         where a.pgcod = i.aqpb002emp
           and a.aomod = i.aqpb002mod
           and a.aosuc = i.aqpb002suc
           and a.aomda = i.aqpb002mda
           and a.aopap = i.aqpb002pap
           and a.aocta = i.aqpb002cta
           and a.aooper = i.aqpb002ope
           and a.aosbop = i.aqpb002sbo
           and a.aotope = i.aqpb002top;
      exception
        when others then
          null;
      end;
    
      if nvl(ln_estado, 99) <> 99 and nvl(ln_contador,0) > 1 then
      
        begin
          select min(n.ppfpag)
            into ld_fecpxv
            from fsd601 n
           where n.pgcod = i.aqpb002emp
             and n.ppcta = i.aqpb002cta
             and n.ppmda = i.aqpb002mda
             and n.ppsuc = i.aqpb002suc
             and n.pppap = i.aqpb002pap
             and n.ppoper = i.aqpb002ope
             and n.ppsbop = i.aqpb002sbo
             and n.pptope = i.aqpb002top
             and n.ppmod = i.aqpb002mod
             and n.d601co = 'S'
             and (n.ppcap + n.ppint) <> 0
             and not exists
          
           (select ppmod, ppcta, ppoper, pptope, ppfpag
                    from fsd602 o
                   where o.pgcod = n.pgcod
                     and o.ppmod = n.ppmod
                     and o.ppsuc = n.ppsuc
                     and o.ppmda = n.ppmda
                     and o.pppap = n.pppap
                     and o.ppcta = n.ppcta
                     and o.ppoper = n.ppoper
                     and o.ppsbop = n.ppsbop
                     and o.pptope = n.pptope
                     and o.ppfpag = n.ppfpag
                        --and o.pp1fech <= pd_fecpro
                     and o.pp1stat = 'T'
                     and o.d602co = 'S'
                     and (o.pp1cap + o.pp1int) <> 0);
        exception
          when others then
            null;
        end;
        
        begin
        
          select count(*)
            into ln_cont
            from fsd601 n
           where n.pgcod = i.aqpb002emp
             and n.ppcta = i.aqpb002cta
             and n.ppmda = i.aqpb002mda
             and n.ppsuc = i.aqpb002suc
             and n.pppap = i.aqpb002pap
             and n.ppoper = i.aqpb002ope
             and n.ppsbop = i.aqpb002sbo
             and n.pptope = i.aqpb002top
             and n.ppmod = i.aqpb002mod
             and n.d601co = 'S'
             and (n.ppcap + n.ppint) <> 0
             and n.ppfpag >= ld_fecpxv;
        exception
          when others then
            null;
        end;
        
        
        if nvl(ln_cont,0) > 1 then
      
              begin
                select n.ppfval, n.ppcap + n.ppint
                  into ld_fecval, ln_cuo1
                  from fsd601 n
                 where n.pgcod = i.aqpb002emp
                   and n.ppcta = i.aqpb002cta
                   and n.ppmda = i.aqpb002mda
                   and n.ppsuc = i.aqpb002suc
                   and n.pppap = i.aqpb002pap
                   and n.ppoper = i.aqpb002ope
                   and n.ppsbop = i.aqpb002sbo
                   and n.pptope = i.aqpb002top
                   and n.ppmod = i.aqpb002mod
                   and n.d601co = 'S'
                   and (n.ppcap + n.ppint) <> 0
                   and n.ppfpag = ld_fecpxv;
              exception
                when others then
                  null;
              end;
            
              
            
              begin
                select a.scsdo * -1
                  into ln_mto
                  from fsd011 a
                 where a.pgcod = i.aqpb002emp
                   and a.scmod = i.aqpb002mod
                   and a.scsuc = i.aqpb002suc
                   and a.scmda = i.aqpb002mda
                   and a.scpap = i.aqpb002pap
                   and a.sccta = i.aqpb002cta
                   and a.scoper = i.aqpb002ope
                   and a.scsbop = i.aqpb002sbo
                   and a.sctope = i.aqpb002top;
              exception
                when others then
                  null;
              end;
            
              begin
              
                select (b.ppimp11 + b.ppimp12 + b.ppimp13 + b.ppimp14 + b.ppimp15)
                  into ln_seg
                  from \*fsd601 n, *\ fsd611 b
                 where b.pgcod = i.aqpb002emp
                   and b.ppcta = i.aqpb002cta
                   and b.ppmda = i.aqpb002mda
                   and b.ppsuc = i.aqpb002suc
                   and b.pppap = i.aqpb002pap
                   and b.ppoper = i.aqpb002ope
                   and b.ppsbop = i.aqpb002sbo
                   and b.pptope = i.aqpb002top
                   and b.ppmod = i.aqpb002mod
                   and b.ppfpag = ld_fecpxv;
              exception
                when others then
                  null;
              end;
            
              ln_cuota := nvl(ln_cuo1, 0) + nvl(ln_seg, 0);
            
              insert into AQPA867
                (AQPA867emp,
                 AQPA867mod,
                 AQPA867suc,
                 AQPA867mda,
                 AQPA867pap,
                 AQPA867cta,
                 AQPA867ope,
                 AQPA867sbo,
                 AQPA867tpo,
                 AQPA867fre,
                 AQPA867fpg,
                 AQPA867est,
                 AQPA867ccu,
                 AQPA867pcu,
                 AQPA867scr,
                 AQPA867vcu)
              values
                (i.aqpb002emp,
                 i.aqpb002mod,
                 i.aqpb002suc,
                 i.aqpb002mda,
                 i.aqpb002pap,
                 i.aqpb002cta,
                 i.aqpb002ope,
                 i.aqpb002sbo,
                 i.aqpb002top,
                 ld_fecval, --i.aqpb002fep,
                 ld_fecpxv,
                 'N',
                 ln_cont,
                 ln_perio,
                 ln_mto,
                 ln_cuota);
              commit;
          end if;
      end if;
    end loop;
    commit;
  end Sp_carga_AQPA867;*/

end;
/

