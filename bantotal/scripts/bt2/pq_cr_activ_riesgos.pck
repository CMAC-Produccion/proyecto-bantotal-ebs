create or replace package pq_cr_activ_riesgos is

  procedure sp_control(pn_ins in number, pc_flg out char);
  function fn_cod_activ(pn_pais in number,
                        pn_tdoc in number,
                        pc_ndoc in char) return number;
end pq_cr_activ_riesgos;
/

create or replace package body pq_cr_activ_riesgos is

  procedure sp_control(pn_ins in number, pc_flg out char) is
  
    cursor integrantes(cn_cta in number) is
      select a.pepais, a.petdoc, a.pendoc
        from fsr008 a
       where a.ctnro = cn_cta;
  
    ln_cta    number(9);
    ln_act    number(11);
    ln_riesgo number(5);
    lc_flg    char(1) := 'N';
  begin
  
    begin
      select a.sng001cta
        into ln_cta
        from sng001 a
       where a.sng001inst = pn_ins;
    exception
      when others then
        null;
    end;
  
    for i in integrantes(ln_cta) loop
      lc_flg    := 'N';
      ln_riesgo := 0;
      --ln_act    := 0;
    
      ln_act := pq_Cr_activ_riesgos.fn_cod_activ(i.pepais,
                                                 i.petdoc,
                                                 i.pendoc);
      begin
        select a.aqpa863ries
          into ln_riesgo
          from aqpa863 a
         where a.aqpa863ciiu = ln_act
           and a.aqpa863vige = 'S';
      exception
        when others then
          null;
      end;
    
      if nvl(ln_riesgo, 0) <> 0 then
        begin
          select 'S'
            into lc_flg
            from fst198 a
           where a.tp1cod = 1
             and a.tp1cod1 = 11141
             and a.tp1corr1 = 2
             and a.tp1corr2 = 1
             and a.tp1nro1 = ln_riesgo;
        exception
          when others then
            null;
        end;
      
        if nvl(lc_flg, 'N') = 'S' then
          exit;
        end if;
      end if;
    end loop;
  
    pc_flg := nvl(lc_flg, 'N');
  
  end sp_control;

  function fn_cod_activ(pn_pais in number,
                        pn_tdoc in number,
                        pc_ndoc in char) return number is
    ln_activi number;
  begin
    begin
      select xx.actcod1
        into ln_activi
        from sngc60 aa, fst750 xx
       where aa.sngc60pais = pn_pais
         and aa.sngc60tdoc = pn_tdoc
         and aa.sngc60ndoc = pc_ndoc
         and aa.sngc60corr = 0
         and aa.sngc60acte = xx.actcod1;
    exception
      when no_data_found then
        begin
        
          select xxx.actcod1
            into ln_activi
            from sngc11 cc, fst750 xxx
           where cc.sngc11pais = pn_pais
             and cc.sngc11tdoc = pn_tdoc
             and cc.sngc11ndoc = pc_ndoc
             and cc.sngc11act2 = xxx.actcod1;
        exception
          when no_data_found then
            begin
            
              select xxx.actcod1
                into ln_activi
                from fse001 cc, fst750 xxx
               where cc.d511pais = pn_pais
                 and cc.d511tdoc = pn_tdoc
                 and cc.d511ndoc = pc_ndoc
                 and cc.expnins = xxx.actcod1;
            exception
              when others then
                ln_activi := null;
            end;
        end;
      
      when too_many_rows then
        ln_activi := -1;
    end;
    return ln_activi;
  end fn_cod_activ;

end pq_cr_activ_riesgos;
/

