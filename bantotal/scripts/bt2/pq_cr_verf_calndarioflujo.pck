create or replace package PQ_CR_VERF_CALNDARIOFLUJO is

  -- Author  : MPOSTIGOC
  -- Created : 11/09/2023 15:02:23
  -- Purpose : 

  procedure sp_cr_inicio(ln_Instancia in number, lc_CredFlujo out varchar2);
  --------------------------------------------------
  procedure sp_cr_flujocaja(ln_emp10  in number,
                            ln_mod10  in number,
                            ln_suc10  in number,
                            ln_mda10  in number,
                            ln_pap10  in number,
                            ln_cta10  in number,
                            ln_oper10 in number,
                            ln_sbop10 in number,
                            ln_tope10 in number,
                            ln_flagFC out varchar2);
  --------------------------------------------------------------------------------
  procedure sp_cr_logAQPB171(ln_inst  in number,
                             ld_fch   in date,
                             ld_fini  in date,
                             ld_ffin  in date,
                             ln_pais  in number,
                             ln_tdoc  in number,
                             lc_ndoc  in varchar2,
                             ln_pgcod in number,
                             ln_mod   in number,
                             ln_suc   in number,
                             ln_mda   in number,
                             ln_pap   in number,
                             ln_cta   in number,
                             ln_ope   in number,
                             ln_sbop  in number,
                             ln_tope  in number,
                             lc_fc    in varchar2);

end PQ_CR_VERF_CALNDARIOFLUJO;
/

create or replace package body PQ_CR_VERF_CALNDARIOFLUJO is

  procedure sp_cr_inicio(ln_Instancia in number, lc_CredFlujo out varchar2) is
  
    cursor creditos_canc(ld_fchini date, ld_fchfin date) is
      select *
        from fsd010 f
       where f.pgcod = 1
         and (f.aomod in
             (select g.modulo
                 from fst111 g
                where g.dscod = 50
                  and g.modulo not in (29, 33, 108, 116, 142, 144, 200)) or
             f.aomod = 117)
         and f.aocta in (select h.ctnro
                           from fsr008 h, sng001 s
                          where h.pepais = s.sng001pais
                            and h.petdoc = s.sng001tdoc
                            and h.pendoc = s.sng001ndoc
                            and h.pgcod = 1
                            and s.sng001inst = ln_Instancia)
         and f.aofe99 between ld_fchini and ld_fchfin
         and f.aostat = 99;
  
    cursor creditos_vig is
      select *
        from fsd010 f
       where f.pgcod = 1
         and (f.aomod in
             (select g.modulo
                 from fst111 g
                where g.dscod = 50
                  and g.modulo not in (29, 33, 108, 116, 142, 144, 200)) or
             f.aomod = 117)
         and f.aocta in (select h.ctnro
                           from fsr008 h, sng001 s
                          where h.pepais = s.sng001pais
                            and h.petdoc = s.sng001tdoc
                            and h.pendoc = s.sng001ndoc
                            and h.pgcod = 1
                            and s.sng001inst = ln_Instancia)
         and f.aostat <> 99;
  
    ld_fchini date;
    ld_fchfin date;
    ln_pais   number;
    ln_tdoc   number;
    lc_ndoc   varchar2(12);
  
  begin
    lc_CredFlujo := 'N';
  
    begin
      update aqpb171 a
         set a.aqpb171est = 'I'
       where a.aqpb171inst = ln_Instancia;
      commit;
    end;
  
    begin
      select add_months(f.pgfape, -12)
        into ld_fchini
        from fst017 f
       where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select f.pgfape into ld_fchfin from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_pais, ln_tdoc, lc_ndoc
        from sng001 s
       where s.sng001inst = ln_Instancia;
    exception
      when others then
        null;
    end;
  
    for c in creditos_vig loop
    
      PQ_CR_VERF_CALNDARIOFLUJO.sp_cr_flujocaja(ln_emp10  => c.pgcod,
                                                ln_mod10  => c.aomod,
                                                ln_suc10  => c.aosuc,
                                                ln_mda10  => c.aomda,
                                                ln_pap10  => c.aopap,
                                                ln_cta10  => c.aocta,
                                                ln_oper10 => c.aooper,
                                                ln_sbop10 => c.aosbop,
                                                ln_tope10 => c.aotope,
                                                ln_flagFC => lc_CredFlujo);
    
      pq_Cr_verf_calndarioflujo.sp_cr_logAQPB171(ln_inst  => ln_Instancia,
                                                 ld_fch   => ld_fchfin,
                                                 ld_fini  => ld_fchini,
                                                 ld_ffin  => ld_fchfin,
                                                 ln_pais  => ln_pais,
                                                 ln_tdoc  => ln_tdoc,
                                                 lc_ndoc  => lc_ndoc,
                                                 ln_pgcod => c.pgcod,
                                                 ln_mod   => c.aomod,
                                                 ln_suc   => c.aosuc,
                                                 ln_mda   => c.aomda,
                                                 ln_pap   => c.aopap,
                                                 ln_cta   => c.aocta,
                                                 ln_ope   => c.aooper,
                                                 ln_sbop  => c.aosbop,
                                                 ln_tope  => c.aotope,
                                                 lc_fc    => lc_CredFlujo);
    
      if lc_CredFlujo = 'S' then
        exit;
      end if;
    end loop;
  
    if lc_CredFlujo = 'N' then
      for c in creditos_canc(ld_fchini, ld_fchfin) loop
      
        PQ_CR_VERF_CALNDARIOFLUJO.sp_cr_flujocaja(ln_emp10  => c.pgcod,
                                                  ln_mod10  => c.aomod,
                                                  ln_suc10  => c.aosuc,
                                                  ln_mda10  => c.aomda,
                                                  ln_pap10  => c.aopap,
                                                  ln_cta10  => c.aocta,
                                                  ln_oper10 => c.aooper,
                                                  ln_sbop10 => c.aosbop,
                                                  ln_tope10 => c.aotope,
                                                  ln_flagFC => lc_CredFlujo);
      
        pq_Cr_verf_calndarioflujo.sp_cr_logAQPB171(ln_inst  => ln_Instancia,
                                                   ld_fch   => ld_fchfin,
                                                   ld_fini  => ld_fchini,
                                                   ld_ffin  => ld_fchfin,
                                                   ln_pais  => ln_pais,
                                                   ln_tdoc  => ln_tdoc,
                                                   lc_ndoc  => lc_ndoc,
                                                   ln_pgcod => c.pgcod,
                                                   ln_mod   => c.aomod,
                                                   ln_suc   => c.aosuc,
                                                   ln_mda   => c.aomda,
                                                   ln_pap   => c.aopap,
                                                   ln_cta   => c.aocta,
                                                   ln_ope   => c.aooper,
                                                   ln_sbop  => c.aosbop,
                                                   ln_tope  => c.aotope,
                                                   lc_fc    => lc_CredFlujo);
      
        if lc_CredFlujo = 'S' then
          exit;
        end if;
      end loop;
    end if;
  end;

  --------------------------------------------------
  procedure sp_cr_flujocaja(ln_emp10  in number,
                            ln_mod10  in number,
                            ln_suc10  in number,
                            ln_mda10  in number,
                            ln_pap10  in number,
                            ln_cta10  in number,
                            ln_oper10 in number,
                            ln_sbop10 in number,
                            ln_tope10 in number,
                            ln_flagFC out varchar2) is
  
    ln_fc           number(17, 2);
    ln_nroflujo     number;
    lc_tienecalen   VARCHAR2(2);
    lc_tieneseguros varchar2(2);
    ln_MaxFchTx     date;
  
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
  
    if lc_tienecalen = 'S' and lc_tieneseguros = 'S' then
      --05/07/2017 mpostigoc
    
      if ln_mod10 <> 116 then
      
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
             and f.ppfpag = s.ppfpag;
        exception
          when others then
            null;
          
        end;
      
      else
        begin
          select max(f.d602fc)
            into ln_MaxFchTx
            from fsd602 f
           where f.pgcod = 1
             and f.ppmod = ln_mod10
             and f.ppsuc = ln_suc10
             and f.ppmda = ln_mda10
             and f.pppap = ln_pap10
             and f.ppcta = ln_cta10
             and f.ppoper = ln_oper10
             and f.ppsbop = ln_sbop10
             and f.pptope = ln_tope10
             and f.d602mo = 116
             and f.d602tr in (50, 60);
        exception
          when others then
            null;
        end;
      
        if ln_MaxFchTx is not null then
        
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
               and f.ppfpag > ln_MaxFchTx
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
              ln_fc := 0;
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
              ln_fc := 0;
          end;
        
        end if;
      end if;
    
    else
      if lc_tienecalen = 'S' and lc_tieneseguros = 'N' then
        --05/07/2017 mpostigoc
      
        if ln_mod10 <> 116 then
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
        
        else
          begin
            select max(f.d602fc)
              into ln_MaxFchTx
              from fsd602 f
             where f.pgcod = 1
               and f.ppmod = ln_mod10
               and f.ppsuc = ln_suc10
               and f.ppmda = ln_mda10
               and f.pppap = ln_pap10
               and f.ppcta = ln_cta10
               and f.ppoper = ln_oper10
               and f.ppsbop = ln_sbop10
               and f.pptope = ln_tope10
               and f.d602mo = 116
               and f.d602tr in (50, 60);
          exception
            when others then
              null;
          end;
        
          if ln_MaxFchTx is not null then
          
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
                 and f.ppfpag > ln_MaxFchTx;
            exception
              when others then
                ln_fc := 0;
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
                ln_fc := 0;
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
    exception
      when others then
        null;
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

  --------------------------------------------------------------------
  procedure sp_cr_logAQPB171(ln_inst  in number,
                             ld_fch   in date,
                             ld_fini  in date,
                             ld_ffin  in date,
                             ln_pais  in number,
                             ln_tdoc  in number,
                             lc_ndoc  in varchar2,
                             ln_pgcod in number,
                             ln_mod   in number,
                             ln_suc   in number,
                             ln_mda   in number,
                             ln_pap   in number,
                             ln_cta   in number,
                             ln_ope   in number,
                             ln_sbop  in number,
                             ln_tope  in number,
                             lc_fc    in varchar2) is
  
    ln_corr number := 0;
    lc_hora varchar2(8) := '00:00:00';
  
  begin
    begin
      select max(a.aqpb171corr)
        into ln_corr
        from aqpb171 a
       where a.aqpb171inst = ln_inst;
    exception
      when others then
        ln_corr := 0;
    end;
    ln_corr := nvl(ln_corr, 0);
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    exception
      when others then
        null;
    end;
  
    begin
      insert into aqpb171
        (aqpb171corr,
         aqpb171inst,
         aqpb171fch,
         aqpb171fini,
         aqpb171ffin,
         aqpb171hora,
         aqpb171pais,
         aqpb171tdoc,
         aqpb171ndoc,
         aqpb171pgcod,
         aqpb171mod,
         aqpb171suc,
         aqpb171mda,
         aqpb171pap,
         aqpb171cta,
         aqpb171ope,
         aqpb171sbop,
         aqpb171tope,
         aqpb171fc,
         aqpb171est)
      values
        (ln_corr + 1,
         ln_inst,
         ld_fch,
         ld_fini,
         ld_ffin,
         lc_hora,
         ln_pais,
         ln_tdoc,
         lc_ndoc,
         ln_pgcod,
         ln_mod,
         ln_suc,
         ln_mda,
         ln_pap,
         ln_cta,
         ln_ope,
         ln_sbop,
         ln_tope,
         lc_fc,
         'H');
    exception
      when others then
        null;
    end;
    commit;
  
  end sp_cr_logAQPB171;
  -------------------------------------------------------------------------
end PQ_CR_VERF_CALNDARIOFLUJO;
/

