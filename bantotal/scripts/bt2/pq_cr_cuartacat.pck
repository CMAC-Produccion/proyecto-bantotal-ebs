create or replace package PQ_CR_CUARTACAT is

  -- Author  : MCANDIA
  -- Created : 17/07/2019 03:11:03 p.m.
  -- Purpose : 

  Procedure sp_cr_verifica_dscto_sign(ln_instancia  in number,
                                      lc_dscto_sign out VARCHAR2);

  Procedure sp_cr_eval_categoria(ln_instancia in number,
                                 lc_eval_cat  out VARCHAR2);

  Procedure sp_cr_Sng023(ln_eval    in number,
                         ln_SalS    in number,
                         ln_SalUSD  in number,
                         ln_DescS   in number,
                         ln_DescUSD in number,
                         Flag_S     out VARCHAR2);

  Procedure sp_cr_limpia415(ln_instancia in number);

end PQ_CR_CUARTACAT;
/

create or replace package body PQ_CR_CUARTACAT is

  Procedure sp_cr_verifica_dscto_sign(ln_instancia  in number,
                                      lc_dscto_sign out VARCHAR2) is
  
    ln_eval       number(10);
    ld_fechacorte date;
    ln_tipmod     number(4);
    ld_fecEval    date;
  
  begin
  
    begin
      select TO_DATE(fst198.tp1desc, 'dd/mm/yyyy')
        into ld_fechacorte
        from fst198
       where fst198.tp1cod = 1
         and fst198.tp1cod1 = 11132
         and fst198.tp1corr1 = 2
         and fst198.tp1corr2 = 1
         and fst198.tp1corr3 = 1;
    exception
      when no_data_found then
        ld_fechacorte := null;
    end;
  
    begin
      select sng021.sng021eval, sng021.sng021tmod
        into ln_eval, ln_tipmod
        from sng021
       where sng021.sng021sol = ln_instancia;
    exception
      when no_data_found then
        ln_eval   := 0;
        ln_tipmod := 0;
    end;
  
    if ln_tipmod <> 13 then
      begin
        select sng120.SNG120FVal
          into ld_fecEval
          from sng120
         where SNG120Ins = ln_instancia
           and SNG120Tsk = 'EVALUACION'
           and rownum = 1
         order by SNG120FPag;
      exception
        when no_data_found then
          ld_fecEval := null;
      end;
    end if;
  
    if ld_fecEval >= ld_fechacorte then
      begin
        select 'S'
          into lc_dscto_sign
          from sng023
         where sng023.sng021eval = ln_eval
           and sng023.sng026cod in (5, 505, 6, 506)
           and sng023.sng023mto < 0.00;
      exception
        when no_data_found then
          lc_dscto_sign := 'N';
      end;
    end if;
  
  end sp_cr_verifica_dscto_sign;

  Procedure sp_cr_eval_categoria(ln_instancia in number,
                                 lc_eval_cat  out VARCHAR2) is
  
    Flag_Integra character;
    Flag_415     character;
  
    cursor documentos is
      select distinct (trim(f.pendoc)) lc_doc,
                      s.sng001cta ln_cta,
                      'T' lc_rel
        from fsr008 f, sng001 s
       where f.Cttfir = 'T'
         and s.sng001cta = f.ctnro
         and s.sng001inst = ln_instancia
      
      union
      select distinct (trim(g.rpndoc)) lc_doc,
                      s.sng001cta ln_cta,
                      'C' lc_rel
        from fsr008 f, fsr002 g, sng001 s
       where s.sng001cta = f.ctnro
         and s.sng001inst = ln_instancia
         and f.Cttfir = 'T'
         and f.pepais = g.pepais
         and f.petdoc = g.petdoc
         and f.pendoc = g.pendoc
         and g.rpccyg = 66
      union
      select distinct (trim(g.pendoc)) lc_doc,
                      s.sng001cta ln_cta,
                      'C' lc_rel
        from fsr008 f, fsr002 g, sng001 s
       where s.sng001cta = f.ctnro
         and s.sng001inst = ln_instancia
         and f.Cttfir = 'T'
         and f.pepais = g.rppais
         and f.petdoc = g.rptdoc
         and f.pendoc = g.rpndoc
         and g.rpccyg = 66;
  
    ln_SalS       number(3);
    ln_SalUSD     number(3);
    ln_DescS      number(3);
    ln_DescUSD    number(3);
    ln_eval       number(10);
    ld_fechacorte date;
    ln_tipmod     number(4);
    ld_fecEval    date;
  
  begin
  
    lc_eval_cat := 'S';
  
    begin
      select TO_DATE(fst198.tp1desc, 'dd/mm/yyyy')
        into ld_fechacorte
        from fst198
       where fst198.tp1cod = 1
         and fst198.tp1cod1 = 11132
         and fst198.tp1corr1 = 2
         and fst198.tp1corr2 = 1
         and fst198.tp1corr3 = 1;
    exception
      when no_data_found then
        ld_fechacorte := null;
    end;
  
    begin
      select sng021.sng021eval, sng021.sng021tmod
        into ln_eval, ln_tipmod
        from sng021
       where sng021.sng021sol = ln_instancia;
    exception
      when no_data_found then
        ln_eval   := 0;
        ln_tipmod := 0;
    end;
  
    if ln_tipmod <> 13 then
      begin
        select sng120.SNG120FVal
          into ld_fecEval
          from sng120
         where SNG120Ins = ln_instancia
           and SNG120Tsk = 'EVALUACION'
           and rownum = 1
         order by SNG120FPag;
      exception
        when no_data_found then
          ld_fecEval := null;
      end;
    end if;
  
    if ld_fecEval >= ld_fechacorte then
      for i in documentos loop
      
        begin
          select 'S'
            into Flag_Integra
            from fsr008 f
           where f.ctnro = i.ln_cta
             and trim(f.pendoc) = trim(i.lc_doc);
        exception
          when no_data_found then
            Flag_Integra := 'N';
          
        end;
      
        if Flag_Integra = 'S' then
        
          begin
            select 'S'
              into Flag_415
              from aqpa415
             where aqpa415ins = ln_instancia
               and trim(aqpa415doc) = trim(i.lc_doc)
               and aqpa415aux4 = '1';
          exception
            when no_data_found then
              Flag_415 := 'N';
          end;
        
          if Flag_415 = 'N' then
            if i.lc_rel = 'T' then
              if lc_eval_cat <> 'N' then
              
                ln_SalS    := 1;
                ln_SalUSD  := 501;
                ln_DescS   := 5;
                ln_DescUSD := 505;
              
                PQ_CR_CUARTACAT.sp_cr_Sng023(ln_eval,
                                             ln_SalS,
                                             ln_SalUSD,
                                             ln_DescS,
                                             ln_DescUSD,
                                             lc_eval_cat);
              end if;
            else
            
              if lc_eval_cat <> 'N' then
                ln_SalS    := 2;
                ln_SalUSD  := 502;
                ln_DescS   := 6;
                ln_DescUSD := 506;
              
                PQ_CR_CUARTACAT.sp_cr_Sng023(ln_eval,
                                             ln_SalS,
                                             ln_SalUSD,
                                             ln_DescS,
                                             ln_DescUSD,
                                             lc_eval_cat);
              end if;
            end if;
          end if;
        end if;
      end loop;
    end if;
  
  end sp_cr_eval_categoria;

  Procedure sp_cr_Sng023(ln_eval    in number,
                         ln_SalS    in number,
                         ln_SalUSD  in number,
                         ln_DescS   in number,
                         ln_DescUSD in number,
                         Flag_S     out VARCHAR2) is
  
    ln_montoSalS   number(17, 2);
    ln_montoSalUSD number(17, 2);
  
  begin
  
    begin
      select sng023.sng023mto
        into ln_montoSalS
        from sng023
       where sng023.sng021eval = ln_eval
         and sng023.sng026cod = ln_SalS;
    exception
      when no_data_found then
        ln_montoSalS := 0.00;
    end;
  
    begin
      select sng023.sng023mto
        into ln_montoSalUSD
        from sng023
       where sng023.sng021eval = ln_eval
         and sng023.sng026cod = ln_SalUSD;
    exception
      when no_data_found then
        ln_montoSalUSD := 0.00;
    end;
  
    if ln_montoSalS <> 0.00 then
    
      begin
        select 'S'
          into Flag_S
          from sng023
         where sng023.sng021eval = ln_eval
           and sng023.sng026cod = ln_DescS
           and sng023.sng023mto <> 0.00;
      exception
        when no_data_found then
          Flag_S := 'N';
      end;
    end if;
  
    if ln_montoSalUSD <> 0.00 then
    
      begin
        select 'S'
          into Flag_S
          from sng023
         where sng023.sng021eval = ln_eval
           and sng023.sng026cod = ln_DescUSD
           and sng023.sng023mto <> 0.00;
      exception
        when no_data_found then
          Flag_S := 'N';
      end;
    end if;
  
  end sp_cr_Sng023;

  Procedure sp_cr_limpia415(ln_instancia in number) is
  
  begin
    delete from aqpa415 where aqpa415ins = ln_instancia;
    commit;
  end sp_cr_limpia415;

end PQ_CR_CUARTACAT;
/

