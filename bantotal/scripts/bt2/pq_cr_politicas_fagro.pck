create or replace package PQ_CR_POLITICAS_FAGRO is

  -- *****************************************************************
  -- Nombre                       : PQ_CR_POLITICAS_FAGRO
  -- Sistema                      : BANTOTAL
  -- Módulo                       : Créditos
  -- Versión                      : 1.0
  -- Fecha de Creación            : 17/04/2021
  -- Autor de Creación            : jrodriguej
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Descripción                  : Paquete para procesar los RTE's de los créditos de FONDOS FAE AGRO
  -- Fecha de Modificación        : 
  -- Autor de Modificación        : 
  -- Descripción de Modificación  : 
  -- *****************************************************************

  ----------------------------------------------------------------
  procedure sp_dias_fvalor_fpago(pn_ins in number, pn_resp out number);
  ----------------------------------------------------------------
  procedure sp_linea_faeagro_vig(pn_ins in number, pn_resp out varchar2);
  ----------------------------------------------------------------  
  procedure sp_primpa_faeagro( --pn_ins in number, 
                              pn_emp  in number,
                              pn_suc  in number,
                              pn_mod  in number,
                              pn_tran in number,
                              pn_nrel in number,
                              pn_ord  in number,
                              pn_resp out varchar2);
  ----------------------------------------------------------------  
  procedure sp_cant_dias_dif( --pn_ins in number, 
                             pn_emp  in number,
                             pn_suc  in number,
                             pn_mod  in number,
                             pn_tran in number,
                             pn_nrel in number,
                             pn_ord  in number,
                             pn_resp out number);
  ----------------------------------------------------------------  
  procedure sp_es_reactiva_pol(pn_ins in number, pn_resp out varchar2);
  ---------------------------------------------------------------- 
  procedure sp_plazo_max_vig(pn_emp  in number,
                             pn_suc  in number,
                             pn_mod  in number,
                             pn_tran in number,
                             pn_nrel in number,
                             pn_ord  in number,
                             pn_resp out varchar2);
  ----------------------------------------------------------------     
  procedure sp_insertar_AQPB092;
  ----------------------------------------------------------------    
  procedure sp_actualizar_AQPB092(pn_cod     in NUMBER,
                                  pn_suc     in NUMBER,
                                  pn_mod     in NUMBER,
                                  pn_tran    in NUMBER,
                                  pn_rel     in NUMBER,
                                  pn_fecha   in date,
                                  pn_usuario in varchar2,
                                  pn_flag    out varchar2);
  ----------------------------------------------------------------
  procedure sp_nrovuelo_faeagro(pn_ins in number, pn_resp out number);
  ---------------------------------------------------------------- 
  procedure sp_nrovuelo_fag(pn_ins in number, pn_resp out varchar2);
  ----------------------------------------------------------------       
  procedure sp_es_fae_1_2(pn_ins in number, pn_resp out varchar2);
  ----------------------------------------------------------------    
  procedure sp_primpa_faeagro2(pn_ins  in number,
                               pn_usur in varchar2,
                               pn_resp out varchar2);
  ----------------------------------------------------------------                                     
  procedure sp_cant_dias_dif2(pn_ins  in number,
                              pn_usur in varchar2,
                              pn_resp out varchar2);
  ----------------------------------------------------------------  
  procedure sp_plazo_max_vig2(pn_ins  in number,
                              pn_usur in varchar2,
                              pn_resp out varchar2);
  ---------------------------------------------------------------- 
  procedure sp_DIAS_FVALOR_FPAGO2(pn_ins  in number,
                                  pn_usur in varchar2,
                                  pn_resp out number);

  -----------------------------------------------------------------------
  procedure sp_DIAS_FVTO_FPAGO2(pn_ins  in number,
                                pn_usur in varchar2,
                                pn_resp out number);
end PQ_CR_POLITICAS_FAGRO;
/

create or replace package body PQ_CR_POLITICAS_FAGRO is

  -- *****************************************************************
  -- Nombre                       : PQ_CR_POLITICAS_FAGRO
  -- Sistema                      : BANTOTAL
  -- Módulo                       : Créditos
  -- Versión                      : 1.0
  -- Fecha de Creación            : 17/04/2021
  -- Autor de Creación            : jrodriguej
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Descripción                  : Paquete para procesar los RTE's de los créditos de FONDOS FAE AGRO
  -- Fecha de Modificación        : 
  -- Autor de Modificación        : 
  -- Descripción de Modificación  : 
  -- *****************************************************************

  -----------------------------------------------------------------------
  procedure sp_dias_fvalor_fpago(pn_ins in number, pn_resp out number) is
  
    ln_cta  number(9);
    ln_pais number(3);
    ln_tdoc number(2);
    ln_ndoc char(12);
  
  begin
  
    begin
      select distinct x.xwfcuenta
        into ln_cta
        from xwf700 x
       where x.xwfempresa = 1
         and x.xwfprcins = pn_ins
         and x.xwfmodulo = 117
         and x.xwftipope = 20 --160
         and x.xwfcar3 = '1';
    exception
    
      when too_many_rows then
        select x.xwfcuenta
          into ln_cta
          from xwf700 x
         where x.xwfempresa = 1
           and x.xwfprcins = pn_ins
           and x.xwfmodulo = 117
           and x.xwftipope = 20 --160
           and x.xwfcar3 = '1'
           and rownum = 1;
      
      when others then
        ln_cta := 0;
    end;
  
    begin
      select x.pepais, x.petdoc, x.pendoc
        into ln_pais, ln_tdoc, ln_ndoc
        from fsr008 x
       where x.pgcod = 1
         and x.ctnro = ln_cta
         and x.ttcod = 1
         and x.cttfir = 'T';
    exception
      when others then
        ln_pais := null;
        ln_tdoc := null;
        ln_ndoc := null;
    end;
  
    begin
      select x.aqpb092mont
        into pn_resp
        from aqpb092 x
       where x.aqpb092pais = ln_pais
         and x.aqpb092tdoc = ln_tdoc
         and x.aqpb092ndoc = ln_ndoc
         and x.aqpb092est = 'H'
         and x.aqpb092fcar =
             (select max(f.aqpb092fcar)
                from aqpb092 f
               where f.aqpb092pais = x.aqpb092pais
                 and f.aqpb092tdoc = x.aqpb092tdoc
                 and f.aqpb092ndoc = x.aqpb092ndoc);
    exception
      when others then
        pn_resp := 0;
    end;
  
  exception
    when others then
      pn_resp := 0;
    
  end sp_dias_fvalor_fpago;
  -----------------------------------------------------------------------
  procedure sp_linea_faeagro_vig(pn_ins in number, pn_resp out varchar2) is
  
    ln_cta  number(9);
    ln_pais number(3);
    ln_tdoc number(2);
    ln_ndoc char(12);
    ln_flag char(1);
    lb_cont number(1);
  
    --- Instancia, Datos personales, verificar créditos desembolsados en FSD010 con modúlo 117 y tipo de ope 160,créditos vigentes
    cursor creditos(lx_pais number,
                    lx_tdoc number,
                    lx_ndoc char,
                    lx_inst number) is
      select x.sng001inst
        from sng001 x, xwf700 s
       where x.sng001pais = lx_pais
         and x.sng001tdoc = lx_tdoc
         and x.sng001ndoc = lx_ndoc
         and x.sng001inst = s.xwfprcins
         and s.xwfcar3 = '1'
         and s.xwfmodulo = 117
         and s.xwftipope = 20 --160
         and s.xwfprcins <> lx_inst;
  
  begin
  
    begin
      select distinct x.xwfcuenta
        into ln_cta
        from xwf700 x
       where x.xwfempresa = 1
         and x.xwfprcins = pn_ins
         and x.xwfmodulo = 117
         and x.xwftipope = 20 --160
         and x.xwfcar3 = '1';
    exception
      when too_many_rows then
        select x.xwfcuenta
          into ln_cta
          from xwf700 x
         where x.xwfempresa = 1
           and x.xwfprcins = pn_ins
           and x.xwfmodulo = 117
           and x.xwftipope = 20 --160
           and x.xwfcar3 = '1'
           and rownum = 1;
      when others then
        ln_cta := 0;
    end;
  
    begin
      select x.pepais, x.petdoc, x.pendoc
        into ln_pais, ln_tdoc, ln_ndoc
        from fsr008 x
       where x.pgcod = 1
         and x.ctnro = ln_cta
         and x.ttcod = 1
         and x.cttfir = 'T';
    exception
      when others then
        ln_pais := null;
        ln_tdoc := null;
        ln_ndoc := null;
    end;
  
    ln_flag := 'N';
  
    begin
      select count(*)
        into lb_cont
        from fsd010 x
       where x.pgcod = 1
         and x.aomod = 117
         and x.aotope = 20
         and x.aostat <> 99
         and x.aocta in (select h.ctnro
                           from sng001 s, fsr008 h
                          where s.sng001emp = h.pgcod
                            and s.sng001pais = h.pepais
                            and s.sng001tdoc = h.petdoc
                            and s.sng001ndoc = h.pendoc
                            and s.sng001inst = pn_ins);
    exception
      when others then
        lb_cont := 0;
    end;
  
    ln_flag := 'N';
  
    if lb_cont = 0 then
    
      for j in creditos(ln_pais, ln_tdoc, ln_ndoc, pn_ins) loop
      
        begin
          select count(*)
            into lb_cont
            from wfwrkitems w
           where w.wfinsprcid = j.sng001inst
             and w.wfitemstsact = 1;
        exception
          when others then
            lb_cont := 0;
        end;
      
        if lb_cont > 0 then
          ln_flag := 'S';
        end if;
      
        if ln_flag = 'S' then
          exit;
        end if;
      end loop;
    
    end if;
  
    if lb_cont > 0 then
      ln_flag := 'S';
    end if;
  
    pn_resp := ln_flag;
  
    -- else
    --   ln_flag := 'S';
    -- end if;
  
  exception
    when others then
    
      pn_resp := 'N';
    
  end sp_linea_faeagro_vig;

  -----------------------------------------------------------------------
  procedure sp_primpa_faeagro( --pn_ins in number,         
                              pn_emp  in number,
                              pn_suc  in number,
                              pn_mod  in number,
                              pn_tran in number,
                              pn_nrel in number,
                              pn_ord  in number,
                              pn_resp out varchar2) is
  
    ln_fmin date;
  
    ln_emp  number(3);
    ln_suc  number(3);
    ln_mod  number(3);
    ln_mda  number(4);
    ln_pap  number(4);
    ln_cta  number(9);
    ln_ope  number(9);
    ln_sbop number(3);
    ln_top  number(3);
  
    ln_flag varchar(1);
    lx_fpzo date;
  
    lx_fec    date;
    lx_ctaAux number(9);
  
    lp_oper number(9);
    lp_mda  number(4);
    lp_pap  number(4);
    lp_subo number(3);
    lp_ord  number(2);
    lp_mod  number(3);
    lp_cta  number(9);
    lp_tope number(3);
    lp_sucd number(3);
  
  begin
  
    --- =====================
    select to_date(t.tp1nro1, 'DDMMYY')
      into lx_fpzo
      from fst198 t
     where t.tp1cod = 1
       and t.tp1cod1 = 11144
       and t.tp1corr1 = 10
       and t.tp1corr2 = 1
       and t.tp1corr3 = 1;
  
    ---********
    select x.pgfape into lx_fec from fst017 x where x.pgcod = 1;
  
    begin
      select x.itoper,
             x.moneda,
             x.papel,
             x.itsubo,
             x.itord,
             x.modulo,
             x.ctnro,
             x.ittope,
             x.itsucd
        into lp_oper,
             lp_mda,
             lp_pap,
             lp_subo,
             lp_ord,
             lp_mod,
             lp_cta,
             lp_tope,
             lp_sucd
        from fsd016 x
       where x.pgcod = pn_emp
         and x.itsuc = pn_suc
         and x.itmod = pn_mod
         and x.ittran = pn_tran
         and x.itnrel = pn_nrel
         and x.itord = pn_ord;
    exception
      when others then
        lp_oper := null;
        lp_mda  := null;
        lp_pap  := null;
        lp_subo := null;
        lp_ord  := null;
        lp_mod  := null;
        lp_cta  := null;
        lp_tope := null;
        lp_sucd := null;
    end;
  
    ---****    
    lx_ctaAux := 999999999;
  
    ln_emp  := pn_emp;
    ln_mod  := lp_mod;
    ln_suc  := lp_sucd;
    ln_mda  := lp_mda;
    ln_pap  := lp_pap;
    ln_cta  := lp_cta;
    ln_ope  := lp_oper;
    ln_sbop := lp_subo;
    ln_top  := lp_tope;
  
    if ln_emp is not null then
    
      if ln_mod = 116 and pn_tran = 50 then
        begin
          select f.xllfprimpa
            into ln_fmin
            from x054023 f
           where f.xllpgcod = ln_emp
             and f.xllaomod = 116
             and f.xllaosuc = ln_suc
             and f.xllaomda = ln_mda
             and f.xllaopap = ln_pap
             and f.xllaocta = ln_cta
             and f.xllaooper = ln_ope
             and f.xllaosbop = ln_sbop
             and f.xllaotop = 20;
        exception
          when others then
            ln_fmin := null;
        end;
      
      end if;
    
      if ln_mod = 116 and pn_tran = 60 then
        begin
        
          select min(x.ppfpag)
            into ln_fmin
            from fsd601 x
           where x.pgcod = ln_emp
             and x.ppmod = 116
             and x.ppsuc = ln_suc
             and x.ppmda = ln_mda
             and x.pppap = ln_pap
             and x.ppcta = lx_ctaAux
             and x.ppoper = ln_ope
             and x.ppsbop = ln_sbop
             and x.pptope = 20
             and x.d601co = 'X';
        exception
          when others then
            ln_fmin := null;
        end;
      end if;
    
      --- Validación
      if ln_fmin > lx_fpzo then
        ln_flag := 'S';
      else
        ln_flag := 'N';
      end if;
    
    else
      ln_flag := 'E';
    
    end if;
  
    pn_resp := ln_flag;
  
  exception
    when others then
    
      pn_resp := 'E';
    
  end sp_primpa_faeagro;
  -----------------------------------------------------------------------
  procedure sp_cant_dias_dif( --pn_ins in number, 
                             pn_emp  in number,
                             pn_suc  in number,
                             pn_mod  in number,
                             pn_tran in number,
                             pn_nrel in number,
                             pn_ord  in number,
                             pn_resp out number) is
  
    ln_emp  number(3);
    ln_suc  number(3);
    ln_mod  number(3);
    ln_mda  number(4);
    ln_pap  number(4);
    ln_cta  number(9);
    ln_ope  number(9);
    ln_sbop number(3);
    ln_top  number(3);
  
    ln_fmin date;
    ln_fmax date;
    ln_diff number;
  
    lx_fec    date;
    lx_ctaAux number(9);
  
    lp_oper number(9);
    lp_mda  number(4);
    lp_pap  number(4);
    lp_subo number(3);
    lp_ord  number(2);
    lp_mod  number(3);
    lp_cta  number(9);
    lp_tope number(3);
    lp_sucd number(3);
  
  begin
  
    ---********
    select x.pgfape into lx_fec from fst017 x where x.pgcod = 1;
  
    begin
      select x.itoper,
             x.moneda,
             x.papel,
             x.itsubo,
             x.itord,
             x.modulo,
             x.ctnro,
             x.ittope,
             x.itsucd
        into lp_oper,
             lp_mda,
             lp_pap,
             lp_subo,
             lp_ord,
             lp_mod,
             lp_cta,
             lp_tope,
             lp_sucd
        from fsd016 x
       where x.pgcod = pn_emp
         and x.itsuc = pn_suc
         and x.itmod = pn_mod
         and x.ittran = pn_tran
         and x.itnrel = pn_nrel
         and x.itord = pn_ord;
    exception
      when others then
        lp_oper := null;
        lp_mda  := null;
        lp_pap  := null;
        lp_subo := null;
        lp_ord  := null;
        lp_mod  := null;
        lp_cta  := null;
        lp_tope := null;
        lp_sucd := null;
    end;
  
    ---****    
    lx_ctaAux := 999999999;
  
    ln_emp  := pn_emp;
    ln_mod  := lp_mod;
    ln_suc  := lp_sucd;
    ln_mda  := lp_mda;
    ln_pap  := lp_pap;
    ln_cta  := lp_cta;
    ln_ope  := lp_oper;
    ln_sbop := lp_subo;
    ln_top  := lp_tope;
  
    if ln_emp is not null then
    
      if ln_mod = 116 and pn_tran = 50 then
      
        begin
          select ADD_MONTHS(f.xllfprimpa, (f.xllcantcuo - 1)), f.xllfprimpa
            into ln_fmax, ln_fmin
            from x054023 f
           where f.xllpgcod = ln_emp
             and f.xllaomod = 116
             and f.xllaosuc = ln_suc
             and f.xllaomda = ln_mda
             and f.xllaopap = ln_pap
             and f.xllaocta = ln_cta
             and f.xllaooper = ln_ope
             and f.xllaosbop = ln_sbop
             and f.xllaotop = 20;
        exception
          when others then
            ln_fmax := null;
            ln_fmin := null;
        end;
      
      end if;
    
      if ln_mod = 116 and pn_tran = 60 then
      
        begin
          select min(x.ppfpag), max(x.ppfpag)
            into ln_fmin, ln_fmax
            from fsd601 x
           where x.pgcod = ln_emp
             and x.ppmod = 116
             and x.ppsuc = ln_suc
             and x.ppmda = ln_mda
             and x.pppap = ln_pap
             and x.ppcta = lx_ctaAux
             and x.ppoper = ln_ope
             and x.ppsbop = ln_sbop
             and x.pptope = 20
             and x.d601co = 'X';
        exception
          when others then
            ln_fmin := null;
            ln_fmax := null;
        end;
      
      end if;
    
      if ln_fmax is null or ln_fmin is null then
        ln_diff := 0;
      else
        ln_diff := ln_fmax - ln_fmin;
      end if;
    
    else
      ln_diff := 0;
    end if;
  
    pn_resp := ln_diff;
  
  exception
    when others then
      pn_resp := 0;
    
  end sp_cant_dias_dif;
  -----------------------------------------------------------------------
  procedure sp_es_reactiva_pol(pn_ins in number, pn_resp out varchar2) is
  
    lx_reac number;
    lx_crec number;
    lx_fae1 number;
    lx_fae2 number;
    pn_flag char(1);
  
    ln_emp  number(3);
    ln_suc  number(3);
    ln_mod  number(3);
    ln_mda  number(4);
    ln_pap  number(4);
    ln_cta  number(9);
    ln_ope  number(9);
    ln_sbop number(3);
    ln_top  number(3);
  
  begin
  
    begin
    
      select x.xwfempresa,
             x.xwfsucursal,
             x.xwfmodulo,
             x.xwfmoneda,
             x.xwfpapel,
             x.xwfcuenta,
             x.xwfoperacion,
             x.xwfsubope,
             x.xwftipope
        into ln_emp,
             ln_suc,
             ln_mod,
             ln_mda,
             ln_pap,
             ln_cta,
             ln_ope,
             ln_sbop,
             ln_top
        from xwf700 x
       where x.xwfempresa = 1
         and x.xwfprcins = pn_ins
            --and x.xwfmodulo = 117
            --and x.xwftipope = 160
         and x.xwfcar3 = '1';
    exception
      when others then
      
        ln_emp  := null;
        ln_suc  := null;
        ln_mod  := null;
        ln_mda  := null;
        ln_pap  := null;
        ln_cta  := null;
        ln_ope  := null;
        ln_sbop := null;
        ln_top  := null;
      
    end;
  
    if ln_emp is not null then
    
      begin
        select count(*)
          into lx_reac
          from aqpb065b x
         where x.aqpb065bcod = ln_emp
              --and x.aqpb065bmod = ln_mod
              --and x.aqpb065bsuc = ln_suc
              --and x.aqpb065bmda = ln_mda
              --and x.aqpb065bpap = ln_pap
              --and x.aqpb065bcta = ln_cta
           and x.aqpb065bcta in
              
               (select h.ctnro
                  from sng001 s, fsr008 h
                 where s.sng001pais = h.pepais
                   and s.sng001tdoc = h.petdoc
                   and s.sng001ndoc = h.pendoc
                   and s.sng001inst = pn_ins)
              
              --and x.aqpb065bope = ln_ope
              --and x.aqpb065bsbo = ln_sbop
              --and x.aqpb065btop = ln_top
           and x.aqpb065best <> 'D';
      exception
        when others then
          lx_reac := 0;
      end;
    
      begin
        select count(*)
          into lx_crec
          from aqpb073b x
         where x.aqpb073bcod = ln_emp
              --and x.aqpb073bmod = ln_mod
              --and x.aqpb073bsuc = ln_suc
              --and x.aqpb073bmda = ln_mda
              --and x.aqpb073bpap = ln_pap
              --and x.aqpb073bcta = ln_cta
           and x.aqpb073bcta in
               (select h.ctnro
                  from sng001 s, fsr008 h
                 where s.sng001pais = h.pepais
                   and s.sng001tdoc = h.petdoc
                   and s.sng001ndoc = h.pendoc
                   and s.sng001inst = pn_ins)
              --and x.aqpb073bope = ln_ope
              --and x.aqpb073bsbo = ln_sbop
              --and x.aqpb073btop = ln_top
           and x.aqpb073best <> 'D';
      exception
        when others then
          lx_crec := 0;
      end;
    
      begin
        select count(*)
          into lx_fae1
          from aqpb067b x
         where x.aqpb067bcod = ln_emp
              --and x.aqpb067bmod = ln_mod
              --and x.aqpb067bsuc = ln_suc
              --and x.aqpb067bmda = ln_mda
              --and x.aqpb067bpap = ln_pap
              --and x.aqpb067bcta = ln_cta
           and x.aqpb067bcta in
               (select h.ctnro
                  from sng001 s, fsr008 h
                 where s.sng001pais = h.pepais
                   and s.sng001tdoc = h.petdoc
                   and s.sng001ndoc = h.pendoc
                   and s.sng001inst = pn_ins)
              --and x.aqpb067bope = ln_ope
              --and x.aqpb067bsbo = ln_sbop
              --and x.aqpb067btop = ln_top
           and (x.aqpb067bmod <> 101 or x.aqpb067btop <> 354)
           and x.aqpb067best <> 'D';
      exception
        when others then
          lx_fae1 := 0;
      end;
    
      begin
        select count(*)
          into lx_fae2
          from aqpb067b x
         where x.aqpb067bcod = ln_emp
              --and x.aqpb067bmod = ln_mod
              --and x.aqpb067bsuc = ln_suc
              --and x.aqpb067bmda = ln_mda
              --and x.aqpb067bpap = ln_pap
              --and x.aqpb067bcta = ln_cta
           and x.aqpb067bcta in
               (select h.ctnro
                  from sng001 s, fsr008 h
                 where s.sng001pais = h.pepais
                   and s.sng001tdoc = h.petdoc
                   and s.sng001ndoc = h.pendoc
                   and s.sng001inst = pn_ins)
              --and x.aqpb067bope = ln_ope
              --and x.aqpb067bsbo = ln_sbop
              --and x.aqpb067btop = ln_top
           and x.aqpb067bmod = 101
           and x.aqpb067btop = 354
           and x.aqpb067best <> 'D';
      exception
        when others then
          lx_fae2 := 0;
      end;
    
      -- Verificación de Flag
      -- pn_flag
      if lx_reac >= 1 and lx_crec = 0 and lx_fae1 = 0 and lx_fae2 = 0 then
        pn_flag := 'R';
      elsif lx_reac = 0 and lx_crec >= 1 and lx_fae1 = 0 and lx_fae2 = 0 then
        pn_flag := 'C';
      elsif lx_reac = 0 and lx_crec = 0 and lx_fae1 >= 1 and lx_fae2 = 0 then
        pn_flag := 'F';
      elsif lx_reac = 0 and lx_crec = 0 and lx_fae1 = 0 and lx_fae2 >= 1 then
        pn_flag := 'G';
      else
        pn_flag := 'N';
      end if;
    
      pn_resp := pn_flag;
    
    else
      pn_resp := 'N';
    end if;
  
  end sp_es_reactiva_pol;
  -----------------------------------------------------------------------
  procedure sp_plazo_max_vig(pn_emp  in number,
                             pn_suc  in number,
                             pn_mod  in number,
                             pn_tran in number,
                             pn_nrel in number,
                             pn_ord  in number,
                             --pn_ins in number, 
                             pn_resp out varchar2) is
  
    lx_reac number;
    lx_crec number;
    lx_fae1 number;
    lx_fae2 number;
    pn_flag char(1);
  
    ln_emp  number(3);
    ln_suc  number(3);
    ln_mod  number(3);
    ln_mda  number(4);
    ln_pap  number(4);
    ln_cta  number(9);
    ln_ope  number(9);
    ln_sbop number(3);
    ln_top  number(3);
  
    lx_fvto date;
    lx_fpzo date;
    lx_diff number(9);
  
    lx_fec    date;
    lx_ctaAux number(9);
  
    lp_oper number(9);
    lp_mda  number(4);
    lp_pap  number(4);
    lp_subo number(3);
    lp_ord  number(2);
    lp_mod  number(3);
    lp_cta  number(9);
    lp_tope number(3);
    lp_sucd number(3);
  
  begin
  
    select to_date(t.tp1nro1, 'DDMMYY')
      into lx_fpzo
      from fst198 t
     where t.tp1cod = 1
       and t.tp1cod1 = 11144
       and t.tp1corr1 = 10
       and t.tp1corr2 = 1
       and t.tp1corr3 = 1;
  
    ---********
    select x.pgfape into lx_fec from fst017 x where x.pgcod = 1;
  
    begin
      select x.itoper,
             x.moneda,
             x.papel,
             x.itsubo,
             x.itord,
             x.modulo,
             x.ctnro,
             x.ittope,
             x.itsucd
        into lp_oper,
             lp_mda,
             lp_pap,
             lp_subo,
             lp_ord,
             lp_mod,
             lp_cta,
             lp_tope,
             lp_sucd
        from fsd016 x
       where x.pgcod = pn_emp
         and x.itsuc = pn_suc
         and x.itmod = pn_mod
         and x.ittran = pn_tran
         and x.itnrel = pn_nrel
         and x.itord = pn_ord;
    exception
      when others then
        lp_oper := null;
        lp_mda  := null;
        lp_pap  := null;
        lp_subo := null;
        lp_ord  := null;
        lp_mod  := null;
        lp_cta  := null;
        lp_tope := null;
        lp_sucd := null;
    end;
  
    ---****
    --&ppctaAux = 999999999
    lx_ctaAux := 999999999;
  
    ln_emp  := pn_emp;
    ln_mod  := lp_mod;
    ln_suc  := lp_sucd;
    ln_mda  := lp_mda;
    ln_pap  := lp_pap;
    ln_cta  := lp_cta;
    ln_ope  := lp_oper;
    ln_sbop := lp_subo;
    ln_top  := lp_tope;
  
    pn_resp := 'N';
  
    if ln_emp is not null then
    
      begin
      
        if ln_mod = 116 and pn_tran = 50 then
        
          begin
            select ADD_MONTHS(f.xllfprimpa, (f.xllcantcuo - 1))
              into lx_fvto
              from x054023 f
             where f.xllpgcod = ln_emp
               and f.xllaomod = 116
               and f.xllaosuc = ln_suc
               and f.xllaomda = ln_mda
               and f.xllaopap = ln_pap
               and f.xllaocta = ln_cta
               and f.xllaooper = ln_ope
               and f.xllaosbop = ln_sbop
               and f.xllaotop = 20;
          exception
            when others then
              lx_fvto := null;
          end;
        
        end if;
      
        if ln_mod = 116 and pn_tran = 60 then
        
          begin
            select max(x.ppfpag)
              into lx_fvto
              from fsd601 x
             where x.pgcod = ln_emp
               and x.ppmod = 116
               and x.ppsuc = ln_suc
               and x.ppmda = ln_mda
               and x.pppap = ln_pap
               and x.ppcta = lx_ctaAux
               and x.ppoper = ln_ope
               and x.ppsbop = ln_sbop
               and x.pptope = 20
               and x.d601co = 'X';
          exception
            when others then
              lx_fvto := null;
          end;
        
        end if;
      
        if lx_fvto > lx_fpzo then
          pn_resp := 'S';
        end if;
      
      exception
        when others then
          pn_resp := 'N';
      end;
    
    end if;
  
  exception
    when others then
      pn_resp := 'N';
    
  end sp_plazo_max_vig;
  -----------------------------------------------------------------------    
  procedure sp_insertar_AQPB092 is
  
    lx_fecha date;
  
    ln_emp  number(3);
    ln_suc  number(3);
    ln_mod  number(3);
    ln_mda  number(4);
    ln_pap  number(4);
    ln_cta  number(9);
    ln_ope  number(9);
    ln_sbop number(3);
    ln_top  number(3);
  
    cursor lista_creditos(ln_fecha date) is
      select b.aqpb091fcar,
             b.aqpb091pais,
             b.aqpb091tdoc,
             b.aqpb091ndoc,
             b.aqpb091tasa,
             b.aqpb091mont,
             b.aqpb091pzo,
             b.aqpb091pgra,
             b.aqpb091frec,
             b.aqpb091pgar,
             b.aqpb091fvig
        from aqpb091 b
       where b.aqpb091fcar = ln_fecha;
  
  begin
  
    --select x.pgfape into lx_fecha from fst017_scre0204 x where x.pgcod = 1;
    select max(x.aqpb091fcar) into lx_fecha from aqpb091 x;
  
    for j in lista_creditos(lx_fecha) loop
    
      begin
      
        --- Actualizar AQPB092
        update aqpb092 x
           set x.aqpb092est = 'I'
         where x.aqpb092pais = j.aqpb091pais
           and x.aqpb092tdoc = j.aqpb091tdoc
           and x.aqpb092ndoc = j.aqpb091ndoc
           and x.aqpb092est <> 'I';
        commit;
      
        --- Obtener XWF700 
      
        insert into aqpb092
          (aqpb092fcar,
           aqpb092pais,
           aqpb092tdoc,
           aqpb092ndoc,
           aqpb092tasa,
           aqpb092mont,
           aqpb092pzo,
           aqpb092pgra,
           aqpb092frec,
           aqpb092pgar,
           aqpb092fvig,
           aqpb092est,
           aqpb092fins,
           aqpb092fhor)
        values
          (j.aqpb091fcar,
           j.aqpb091pais,
           j.aqpb091tdoc,
           j.aqpb091ndoc,
           j.aqpb091tasa,
           j.aqpb091mont,
           j.aqpb091pzo,
           j.aqpb091pgra,
           j.aqpb091frec,
           j.aqpb091pgar,
           j.aqpb091fvig,
           'H',
           to_char(sysdate, 'DD/MM/YYYY'),
           to_char(sysdate, 'HH24:MI:SS'));
        commit;
      
      exception
        when others then
          null;
      end;
    
    end loop;
  
  end sp_insertar_AQPB092;
  -----------------------------------------------------------------------    
  procedure sp_actualizar_AQPB092(pn_cod     in NUMBER,
                                  pn_suc     in NUMBER,
                                  pn_mod     in NUMBER,
                                  pn_tran    in NUMBER,
                                  pn_rel     in NUMBER,
                                  pn_fecha   in date,
                                  pn_usuario in varchar2,
                                  pn_flag    out varchar2) is
  
    lx_fecha date;
  
    ln_emp  number(3);
    ln_suc  number(3);
    ln_mod  number(3);
    ln_mda  number(4);
    ln_pap  number(4);
    ln_cta  number(9);
    ln_ope  number(9);
    ln_sbop number(3);
    ln_top  number(3);
  
    ln_pais  number(3);
    ln_tdoc  number(2);
    ln_ndoc  char(12);
    ln_aoimp number(17, 2);
    ln_inst  number(10);
  
  begin
  
    select x.pgfape into lx_fecha from fst017 x where x.pgcod = 1;
  
    --- Obtener clave de crédito
    if pn_fecha = lx_fecha then
    
      begin
        select distinct x.pgcod,
                        x.itsucd,
                        x.modulo,
                        x.moneda,
                        x.papel,
                        x.ctnro,
                        x.itoper,
                        x.itsubo,
                        x.ittope
          into ln_emp,
               ln_suc,
               ln_mod,
               ln_mda,
               ln_pap,
               ln_cta,
               ln_ope,
               ln_sbop,
               ln_top
          from fsd016 x
         where x.pgcod = pn_cod
           and x.itsuc = pn_suc
           and x.itmod = pn_mod
           and x.ittran = pn_tran
           and x.itnrel = pn_rel
           and x.modulo = 117
           and x.ittope = 20; --160;
      exception
        when others then
        
          ln_emp  := null;
          ln_suc  := null;
          ln_mod  := null;
          ln_mda  := null;
          ln_pap  := null;
          ln_cta  := null;
          ln_ope  := null;
          ln_sbop := null;
          ln_top  := null;
        
      end;
    
    end if;
  
    pn_flag := 'N';
  
    if ln_emp is not null then
    
      --- Obtener pais, tdoc, ndoc
      begin
        select j.pepais, j.petdoc, j.pendoc
          into ln_pais, ln_tdoc, ln_ndoc
          from fsr008 j
         where j.pgcod = 1
           and j.ctnro = ln_cta
           and j.ttcod = 1
           and j.cttfir = 'T';
      exception
        when others then
          ln_pais := null;
          ln_tdoc := null;
          ln_ndoc := null;
      end;
    
      begin
        select x.aoimp
          into ln_aoimp
          from fsd010 x
         where x.pgcod = ln_emp
           and x.aomod = ln_mod
           and x.aosuc = ln_suc
           and x.aomda = ln_mda
           and x.aopap = ln_pap
           and x.aocta = ln_cta
           and x.aooper = ln_ope
           and x.aosbop = ln_sbop
           and x.aotope = ln_top
           and x.aostat <> 99;
      exception
        when others then
          ln_aoimp := 0;
      end;
    
      begin
        select distinct x.xwfprcins
          into ln_inst
          from xwf700 x
         where x.xwfempresa = ln_emp
           and x.xwfmodulo = ln_mod
           and x.xwfsucursal = ln_suc
           and x.xwfmoneda = ln_mda
           and x.xwfpapel = ln_pap
           and x.xwfcuenta = ln_cta
           and x.xwfoperacion = ln_ope
           and x.xwfsubope = ln_sbop
           and x.xwftipope = ln_top
           and x.xwfcar3 = '1';
      exception
        when too_many_rows then
          select x.xwfprcins
            into ln_inst
            from xwf700 x
           where x.xwfempresa = ln_emp
             and x.xwfmodulo = ln_mod
             and x.xwfsucursal = ln_suc
             and x.xwfmoneda = ln_mda
             and x.xwfpapel = ln_pap
             and x.xwfcuenta = ln_cta
             and x.xwfoperacion = ln_ope
             and x.xwfsubope = ln_sbop
             and x.xwftipope = ln_top
             and x.xwfcar3 = '1'
             and rownum = 1;
        when others then
          ln_inst := 0;
      end;
    
      update aqpb092 x
         set x.aqpb092pgcod  = pn_cod,
             x.aqpb092hcmod  = pn_mod,
             x.aqpb092hsucor = pn_suc,
             x.aqpb092htran  = pn_tran,
             x.aqpb092hnrel  = pn_rel,
             x.aqpb092hfcon  = pn_fecha,
             x.aqpb092crcod  = ln_emp,
             x.aqpb092crmod  = ln_mod,
             x.aqpb092crsuc  = ln_suc,
             x.aqpb092crmda  = ln_mda,
             x.aqpb092crpap  = ln_pap,
             x.aqpb092crcta  = ln_cta,
             x.aqpb092croper = ln_ope,
             x.aqpb092crsbop = ln_sbop,
             x.aqpb092crtope = ln_top,
             x.aqpb092usu    = pn_usuario,
             x.aqpb092aoimp  = ln_aoimp,
             x.aqpb092prcins = ln_inst,
             x.aqpb092fupd   = to_char(sysdate, 'DD/MM/YYYY'),
             x.aqpb092fhupd  = to_char(sysdate, 'HH24:MI:SS')
       where x.aqpb092pais = ln_pais
         and x.aqpb092tdoc = ln_tdoc
         and x.aqpb092ndoc = ln_ndoc
         and x.aqpb092est = 'H';
      commit;
    
      pn_flag := 'S';
    
    end if;
  
  end sp_actualizar_AQPB092;
  -----------------------------------------------------------------------
  procedure sp_nrovuelo_faeagro(pn_ins in number, pn_resp out number) is
    -- Devuelve cantidad de solicitudes en vuelo de FAE AGRO
  
    ln_cta  number(9);
    ln_pais number(3);
    ln_tdoc number(2);
    ln_ndoc char(12);
    ln_flag char(1);
    lb_cont number(1);
    lb_cant number(3);
  
    --- Instancia, Datos personales, verificar créditos desembolsados en FSD010 con modúlo 117 y tipo de ope 160,créditos vigentes
    --- VALIDAR SI TIENE CREDITOS DESEMBOLSADOS O EN PROCESO
  
  begin
  
    pn_resp := 0;
  
    begin
      select count(*)
        into lb_cant
        from wfwrkitems w, xwf700 x
       where w.wfinsprcid = x.xwfprcins
         and x.xwfmodulo = 117
         and x.xwftipope = 20
         and x.xwfempresa = 1
         and x.xwfcar3 = '1'
         and w.wfitemstsact = 1
         and x.xwfcuenta in (select h.ctnro
                               from sng001 s, fsr008 h
                              where s.sng001pais = h.pepais
                                and s.sng001tdoc = h.petdoc
                                and s.sng001ndoc = h.pendoc
                                and s.sng001inst = pn_ins)
         and w.wfinsprcid <> pn_ins
         and w.wfiteminit >= to_date('2021.01.01', 'yyyy.mm.dd');
    
    exception
      when others then
        pn_resp := 0;
    end;
  
    pn_resp := lb_cant;
  
  exception
    when others then
    
      pn_resp := 0;
    
  end sp_nrovuelo_faeagro;
  -----------------------------------------------------------------------
  procedure sp_nrovuelo_fag(pn_ins in number, pn_resp out varchar2) is
    -- Devuelve cantidad de solicitudes en vuelo de FAE AGRO
  
    ln_cta  number(9);
    ln_pais number(3);
    ln_tdoc number(2);
    ln_ndoc char(12);
    ln_flag char(1);
    lb_cont number(1);
    lb_cant number(3);
    lb_flag varchar2(1);
  
    --- Instancia, Datos personales, verificar créditos desembolsados en FSD010 con modúlo 117 y tipo de ope 160,créditos vigentes
    --- VALIDAR SI TIENE CREDITOS DESEMBOLSADOS O EN PROCESO
  
  begin
  
    pn_resp := 'N';
    --lb_flag := 'N';
  
    begin
      select count(*)
        into lb_cant
        from wfwrkitems w, xwf700 x
       where w.wfinsprcid = x.xwfprcins
         and x.xwfmodulo = 117
         and x.xwftipope = 20
         and x.xwfempresa = 1
         and x.xwfcar3 = '1'
         and w.wfitemstsact = 1
         and x.xwfcuenta in (select h.ctnro
                               from sng001 s, fsr008 h
                              where s.sng001pais = h.pepais
                                and s.sng001tdoc = h.petdoc
                                and s.sng001ndoc = h.pendoc
                                and s.sng001inst = pn_ins)
         and w.wfinsprcid <> pn_ins
         and w.wfiteminit >= to_date('2021.01.01', 'yyyy.mm.dd');
    
    exception
      when others then
        lb_flag := 0;
    end;
  
    if lb_flag > 0 then
      pn_resp := 'S';
    end if;
  
    --pn_resp := lb_cant;
  
  exception
    when others then
    
      pn_resp := 'N';
    
  end sp_nrovuelo_fag;
  -----------------------------------------------------------------------  

  procedure sp_es_fae_1_2(pn_ins in number, pn_resp out varchar2) is
  
    lx_reac number;
    lx_crec number;
    lx_fae1 number;
    lx_fae2 number;
    lx_fae3 number;
    pn_flag char(1);
  
    ln_emp  number(3);
    ln_suc  number(3);
    ln_mod  number(3);
    ln_mda  number(4);
    ln_pap  number(4);
    ln_cta  number(9);
    ln_ope  number(9);
    ln_sbop number(3);
    ln_top  number(3);
  
  begin
  
    begin
    
      select x.xwfempresa,
             x.xwfsucursal,
             x.xwfmodulo,
             x.xwfmoneda,
             x.xwfpapel,
             x.xwfcuenta,
             x.xwfoperacion,
             x.xwfsubope,
             x.xwftipope
        into ln_emp,
             ln_suc,
             ln_mod,
             ln_mda,
             ln_pap,
             ln_cta,
             ln_ope,
             ln_sbop,
             ln_top
        from xwf700 x
       where x.xwfempresa = 1
         and x.xwfprcins = pn_ins
         and x.xwfcar3 = '1';
    exception
      when too_many_rows then
        select x.xwfempresa,
               x.xwfsucursal,
               x.xwfmodulo,
               x.xwfmoneda,
               x.xwfpapel,
               x.xwfcuenta,
               x.xwfoperacion,
               x.xwfsubope,
               x.xwftipope
          into ln_emp,
               ln_suc,
               ln_mod,
               ln_mda,
               ln_pap,
               ln_cta,
               ln_ope,
               ln_sbop,
               ln_top
          from xwf700 x
         where x.xwfempresa = 1
           and x.xwfprcins = pn_ins
           and x.xwfcar3 = '1'
           and rownum = 1;
      when others then
      
        ln_emp  := null;
        ln_suc  := null;
        ln_mod  := null;
        ln_mda  := null;
        ln_pap  := null;
        ln_cta  := null;
        ln_ope  := null;
        ln_sbop := null;
        ln_top  := null;
      
    end;
  
    if ln_emp is not null then
    
      begin
        select count(*)
          into lx_fae1
          from aqpb067b x
         where x.aqpb067bcod = ln_emp
           and x.aqpb067bcta in
               (select h.ctnro
                  from sng001 s, fsr008 h
                 where s.sng001pais = h.pepais
                   and s.sng001tdoc = h.petdoc
                   and s.sng001ndoc = h.pendoc
                   and s.sng001inst = pn_ins)
           and (x.aqpb067bmod <> 101 or x.aqpb067btop <> 354)
           and x.aqpb067best <> 'D';
      exception
        when others then
          lx_fae1 := 0;
      end;
    
      begin
        select count(*)
          into lx_fae2
          from aqpb067b x
         where x.aqpb067bcod = ln_emp
           and x.aqpb067bcta in
               (select h.ctnro
                  from sng001 s, fsr008 h
                 where s.sng001pais = h.pepais
                   and s.sng001tdoc = h.petdoc
                   and s.sng001ndoc = h.pendoc
                   and s.sng001inst = pn_ins)
           and x.aqpb067bmod = 101
           and x.aqpb067btop = 354
           and x.aqpb067best <> 'D';
      exception
        when others then
          lx_fae2 := 0;
      end;
    
      begin
      
        select count(*)
          into lx_fae3
          from fsd010 t
         where t.pgcod = 1
           and t.aomod = 101
           and t.aotope = 354
           and t.aocta in (select h.ctnro
                             from sng001 s, fsr008 h
                            where s.sng001pais = h.pepais
                              and s.sng001tdoc = h.petdoc
                              and s.sng001ndoc = h.pendoc
                              and s.sng001inst = pn_ins)
           and t.aostat <> 99;
      
      exception
        when others then
          lx_fae3 := 0;
        
      end;
    
      -- Verificación de Flag
      -- pn_flag
      if lx_fae1 >= 1 or lx_fae2 >= 1 or lx_fae3 >= 1 then
        pn_flag := 'S';
      else
        pn_flag := 'N';
      end if;
    
      pn_resp := pn_flag;
    
    else
      pn_resp := 'N';
    end if;
  
  end sp_es_fae_1_2;
  -----------------------------------------------------------------------
  procedure sp_primpa_faeagro2(pn_ins  in number,
                               pn_usur in varchar2,
                               pn_resp out varchar2) is
  
    ln_fmin date;
  
    ln_emp  number(3);
    ln_suc  number(3);
    ln_mod  number(3);
    ln_mda  number(4);
    ln_pap  number(4);
    ln_cta  number(9);
    ln_ope  number(9);
    ln_sbop number(3);
    ln_top  number(3);
  
    ln_flag varchar(1);
    lx_fpzo date;
  
    lx_fec    date;
    lx_ctaAux number(9);
  
    lp_oper number(9);
    lp_mda  number(4);
    lp_pap  number(4);
    lp_subo number(3);
    lp_ord  number(2);
    lp_mod  number(3);
    lp_cta  number(9);
    lp_tope number(3);
    lp_sucd number(3);
  
    lz_suc number(3);
    lz_cta number(9);
  
    pn_emp  number(3);
    pn_suc  number(3);
    pn_mod  number(3);
    pn_tran number(3);
    pn_nrel number(4);
    pn_ord  number(2);
  
    ln_trx    number;
    ln_cant   number;
    lc_coderr varchar2(100);
    lc_msgerr varchar2(1000);
  
  begin
  
    --- =====================
    select to_date(t.tp1nro1, 'DDMMYY')
      into lx_fpzo
      from fst198 t
     where t.tp1cod = 1
       and t.tp1cod1 = 11144
       and t.tp1corr1 = 10
       and t.tp1corr2 = 1
       and t.tp1corr3 = 1;
  
    ---********
    -- Obteniendo sucursal
    begin
      select x.ubsuc
        into lz_suc
        from fst046 x
       where TRIM(x.ubuser) = TRIM(pn_usur);
    exception
      when others then
        lz_suc := null;
    end;
  
    -- Obteniendo cuenta
    begin
      select distinct x.xwfcuenta
        into lz_cta
        from xwf700 x
       where x.xwfprcins = pn_ins
         and x.xwfcar3 = '1';
    exception
      when too_many_rows then
        select x.xwfcuenta
          into lz_cta
          from xwf700 x
         where x.xwfprcins = pn_ins
           and x.xwfcar3 = '1'
           and rownum = 1;
      when others then
        lz_cta := 0;
    end;
  
    -- existe transaccion
    begin
      select count(*)
        into ln_cant
        from fsd011 f
       where f.pgcod = 1
         and f.sccta = lz_cta
         and f.scmod = 116
         and f.sctope = 20
         and f.scstat <> 99;
    exception
      when others then
        ln_cant := 0;
    end;
  
    if ln_cant > 0 then
      ln_trx := 60;
    else
      ln_trx := 50;
    end if;
  
    -- Obtener transacción
    begin
      select distinct x.pgcod,
                      x.itsuc,
                      x.itmod,
                      x.ittran,
                      x.itnrel,
                      x.itord
        into pn_emp, pn_suc, pn_mod, pn_tran, pn_nrel, pn_ord
        from fsd016 x
       where x.pgcod = 1
         and x.itsuc = lz_suc
         and x.itmod = 116
         and x.ittran = ln_trx --in (60, 50)
         and x.itnrel = (select max(f.itnrel)
                           from fsd016 f
                          where f.pgcod = 1
                            and f.itsuc = lz_suc
                            and f.itmod = 116
                            and f.ittran = ln_trx -- in (50, 60)
                            and f.ctnro = lz_cta)
         and x.ctnro = lz_cta
         and x.itord in (10);
    
    exception
      when others then
        lc_coderr := sqlcode;
        lc_msgerr := sqlerrm;
        pn_resp   := 'E';
        pn_emp    := null;
        pn_suc    := null;
        pn_mod    := null;
        pn_tran   := null;
        pn_nrel   := null;
        pn_ord    := null;
    end;
  
    begin
      select x.itoper,
             x.moneda,
             x.papel,
             x.itsubo,
             x.itord,
             x.modulo,
             x.ctnro,
             x.ittope,
             x.itsucd
        into lp_oper,
             lp_mda,
             lp_pap,
             lp_subo,
             lp_ord,
             lp_mod,
             lp_cta,
             lp_tope,
             lp_sucd
        from fsd016 x
       where x.pgcod = pn_emp
         and x.itsuc = pn_suc
         and x.itmod = pn_mod
         and x.ittran = pn_tran
         and x.itnrel = pn_nrel
         and x.itord = pn_ord;
    exception
      when others then
        lp_oper := null;
        lp_mda  := null;
        lp_pap  := null;
        lp_subo := null;
        lp_ord  := null;
        lp_mod  := null;
        lp_cta  := null;
        lp_tope := null;
        lp_sucd := null;
    end;
  
    ---****    
    lx_ctaAux := 999999999;
  
    ln_emp  := pn_emp;
    ln_mod  := lp_mod;
    ln_suc  := lp_sucd;
    ln_mda  := lp_mda;
    ln_pap  := lp_pap;
    ln_cta  := lp_cta;
    ln_ope  := lp_oper;
    ln_sbop := lp_subo;
    ln_top  := lp_tope;
  
    if ln_emp is not null then
    
      if ln_mod = 116 and pn_tran = 50 then
      
        begin
          select f.xllfprimpa
            into ln_fmin
            from x054023 f
           where f.xllpgcod = ln_emp
             and f.xllaomod = 116
             and f.xllaosuc = ln_suc
             and f.xllaomda = ln_mda
             and f.xllaopap = ln_pap
             and f.xllaocta = ln_cta
             and f.xllaooper = ln_ope
             and f.xllaosbop = ln_sbop
             and f.xllaotop = 20;
        exception
          when others then
            ln_fmin := null;
        end;
      
      end if;
    
      if ln_mod = 116 and pn_tran = 60 then
      
        begin
          select min(x.ppfpag)
            into ln_fmin
            from fsd601 x
           where x.pgcod = ln_emp
             and x.ppmod = 116
             and x.ppsuc = ln_suc
             and x.ppmda = ln_mda
             and x.pppap = ln_pap
             and x.ppcta = lx_ctaAux
             and x.ppoper = ln_ope
             and x.ppsbop = ln_sbop
             and x.pptope = 20
             and x.d601co = 'X';
        exception
          when others then
            ln_fmin := null;
        end;
      
      end if;
    
      --- Validación
      if ln_fmin > lx_fpzo then
        ln_flag := 'S';
      else
        ln_flag := 'N';
      end if;
    
    else
      ln_flag := 'E';
    
    end if;
  
    pn_resp := ln_flag;
  
  exception
    when others then
    
      pn_resp := 'E';
    
  end sp_primpa_faeagro2;
  -----------------------------------------------------------------------  
  procedure sp_cant_dias_dif2(pn_ins  in number,
                              pn_usur in varchar2,
                              pn_resp out varchar2) is
  
    ln_emp  number(3);
    ln_suc  number(3);
    ln_mod  number(3);
    ln_mda  number(4);
    ln_pap  number(4);
    ln_cta  number(9);
    ln_ope  number(9);
    ln_sbop number(3);
    ln_top  number(3);
  
    ln_fmin date;
    ln_fmax date;
    ln_diff number;
  
    lx_fec    date;
    lx_ctaAux number(9);
  
    lp_oper number(9);
    lp_mda  number(4);
    lp_pap  number(4);
    lp_subo number(3);
    lp_ord  number(2);
    lp_mod  number(3);
    lp_cta  number(9);
    lp_tope number(3);
    lp_sucd number(3);
  
    lz_suc number(3);
    lz_cta number(9);
  
    pn_emp  number(3);
    pn_suc  number(3);
    pn_mod  number(3);
    pn_tran number(3);
    pn_nrel number(4);
    pn_ord  number(2);
  
    ln_trx    number;
    ln_cant   number;
    lc_coderr varchar2(100);
    lc_msgerr varchar2(1000);
  
  begin
  
    ---********
    select x.pgfape into lx_fec from fst017 x where x.pgcod = 1;
  
    ---********
    -- Obteniendo sucursal
    begin
      select x.ubsuc
        into lz_suc
        from fst046 x
       where TRIM(x.ubuser) = TRIM(pn_usur);
    exception
      when others then
        lz_suc := null;
    end;
  
    -- Obteniendo cuenta
    begin
      select distinct x.xwfcuenta
        into lz_cta
        from xwf700 x
       where x.xwfprcins = pn_ins
         and x.xwfcar3 = '1';
    exception
      when too_many_rows then
        select x.xwfcuenta
          into lz_cta
          from xwf700 x
         where x.xwfprcins = pn_ins
           and x.xwfcar3 = '1'
           and rownum = 1;
      when others then
        lz_cta := 0;
    end;
  
    -- existe transaccion
    begin
      select count(*)
        into ln_cant
        from fsd011 f
       where f.pgcod = 1
         and f.sccta = lz_cta
         and f.scmod = 116
         and f.sctope = 20
         and f.scstat <> 99;
    exception
      when others then
        ln_cant := 0;
    end;
  
    if ln_cant > 0 then
      ln_trx := 60;
    else
      ln_trx := 50;
    end if;
  
    -- Obtener transacción
    begin
      select distinct x.pgcod,
                      x.itsuc,
                      x.itmod,
                      x.ittran,
                      x.itnrel,
                      x.itord
        into pn_emp, pn_suc, pn_mod, pn_tran, pn_nrel, pn_ord
        from fsd016 x
       where x.pgcod = 1
         and x.itsuc = lz_suc
         and x.itmod = 116
         and x.ittran = ln_trx --in (60, 50)
         and x.itnrel = (select max(f.itnrel)
                           from fsd016 f
                          where f.pgcod = 1
                            and f.itsuc = lz_suc
                            and f.itmod = 116
                            and f.ittran = ln_trx -- in (50, 60)
                            and f.ctnro = lz_cta)
         and x.ctnro = lz_cta
         and x.itord in (10);
    exception
      when others then
        lc_coderr := sqlcode;
        lc_msgerr := sqlerrm;
        pn_resp   := 0;
        pn_emp    := null;
        pn_suc    := null;
        pn_mod    := null;
        pn_tran   := null;
        pn_nrel   := null;
        pn_ord    := null;
    end;
  
    begin
      select x.itoper,
             x.moneda,
             x.papel,
             x.itsubo,
             x.itord,
             x.modulo,
             x.ctnro,
             x.ittope,
             x.itsucd
        into lp_oper,
             lp_mda,
             lp_pap,
             lp_subo,
             lp_ord,
             lp_mod,
             lp_cta,
             lp_tope,
             lp_sucd
        from fsd016 x
       where x.pgcod = pn_emp
         and x.itsuc = pn_suc
         and x.itmod = pn_mod
         and x.ittran = pn_tran
         and x.itnrel = pn_nrel
         and x.itord = pn_ord;
    exception
      when others then
        lp_oper := null;
        lp_mda  := null;
        lp_pap  := null;
        lp_subo := null;
        lp_ord  := null;
        lp_mod  := null;
        lp_cta  := null;
        lp_tope := null;
        lp_sucd := null;
    end;
  
    ---****    
    lx_ctaAux := 999999999;
  
    ln_emp  := pn_emp;
    ln_mod  := lp_mod;
    ln_suc  := lp_sucd;
    ln_mda  := lp_mda;
    ln_pap  := lp_pap;
    ln_cta  := lp_cta;
    ln_ope  := lp_oper;
    ln_sbop := lp_subo;
    ln_top  := lp_tope;
  
    if ln_emp is not null then
    
      if ln_mod = 116 and pn_tran = 50 then
      
        begin
          select ADD_MONTHS(f.xllfprimpa, (f.xllcantcuo - 1)), f.xllfprimpa
            into ln_fmax, ln_fmin
            from x054023 f
           where f.xllpgcod = ln_emp
             and f.xllaomod = 116
             and f.xllaosuc = ln_suc
             and f.xllaomda = ln_mda
             and f.xllaopap = ln_pap
             and f.xllaocta = ln_cta
             and f.xllaooper = ln_ope
             and f.xllaosbop = ln_sbop
             and f.xllaotop = 20;
        exception
          when others then
            ln_fmax := null;
            ln_fmin := null;
        end;
      
      end if;
    
      if ln_mod = 116 and pn_tran = 60 then
      
        begin
          select max(x.ppfpag), min(x.ppfpag)
            into ln_fmax, ln_fmin
            from fsd601 x
           where x.pgcod = ln_emp
             and x.ppmod = 116
             and x.ppsuc = ln_suc
             and x.ppmda = ln_mda
             and x.pppap = ln_pap
             and x.ppcta = lx_ctaAux
             and x.ppoper = ln_ope
             and x.ppsbop = ln_sbop
             and x.pptope = 20
             and x.d601co = 'X';
        exception
          when others then
            ln_fmax := null;
            ln_fmin := null;
        end;
      
      end if;
    
      if ln_fmax is null or ln_fmin is null then
        ln_diff := 0;
      else
        ln_diff := ln_fmax - ln_fmin;
      end if;
    
    else
      ln_diff := 0;
    end if;
  
    pn_resp := ln_diff;
  
  exception
    when others then
      pn_resp := 0;
    
  end sp_cant_dias_dif2;
  -----------------------------------------------------------------------  
  procedure sp_plazo_max_vig2(pn_ins  in number,
                              pn_usur in varchar2,
                              pn_resp out varchar2) is
  
    lx_reac number;
    lx_crec number;
    lx_fae1 number;
    lx_fae2 number;
    pn_flag char(1);
  
    ln_emp  number(3);
    ln_suc  number(3);
    ln_mod  number(3);
    ln_mda  number(4);
    ln_pap  number(4);
    ln_cta  number(9);
    ln_ope  number(9);
    ln_sbop number(3);
    ln_top  number(3);
  
    lx_fvto date;
    lx_fpzo date;
    lx_diff number(9);
  
    lx_fec    date;
    lx_ctaAux number(9);
  
    lp_oper number(9);
    lp_mda  number(4);
    lp_pap  number(4);
    lp_subo number(3);
    lp_ord  number(2);
    lp_mod  number(3);
    lp_cta  number(9);
    lp_tope number(3);
    lp_sucd number(3);
  
    lz_suc number(3);
    lz_cta number(9);
  
    pn_emp  number(3);
    pn_suc  number(3);
    pn_mod  number(3);
    pn_tran number(3);
    pn_nrel number(4);
    pn_ord  number(2);
  
    ln_trx    number;
    ln_cant   number;
    lc_coderr varchar2(100);
    lc_msgerr varchar2(1000);
  
  begin
  
    select to_date(t.tp1nro1, 'DDMMYY')
      into lx_fpzo
      from fst198 t
     where t.tp1cod = 1
       and t.tp1cod1 = 11144
       and t.tp1corr1 = 10
       and t.tp1corr2 = 1
       and t.tp1corr3 = 1;
  
    ---********
    select x.pgfape into lx_fec from fst017 x where x.pgcod = 1;
  
    ---********
    -- Obteniendo sucursal
    begin
      select x.ubsuc
        into lz_suc
        from fst046 x
       where TRIM(x.ubuser) = TRIM(pn_usur);
    exception
      when others then
        lz_suc := null;
    end;
  
    -- Obteniendo cuenta
    begin
      select distinct x.xwfcuenta
        into lz_cta
        from xwf700 x
       where x.xwfprcins = pn_ins
         and x.xwfcar3 = '1';
    exception
      when too_many_rows then
        select x.xwfcuenta
          into lz_cta
          from xwf700 x
         where x.xwfprcins = pn_ins
           and x.xwfcar3 = '1'
           and rownum = 1;
      when others then
        lz_cta := 0;
    end;
  
    -- existe transaccion
    begin
      select count(*)
        into ln_cant
        from fsd011 f
       where f.pgcod = 1
         and f.sccta = lz_cta
         and f.scmod = 116
         and f.sctope = 20
         and f.scstat <> 99; -- mpostigoc 11.05.2021
    exception
      when others then
        ln_cant := 0;
    end;
  
    if ln_cant > 0 then
      ln_trx := 60;
    else
      ln_trx := 50;
    end if;
    -- Obtener transacción
    begin
      select distinct x.pgcod,
                      x.itsuc,
                      x.itmod,
                      x.ittran,
                      x.itnrel,
                      x.itord
        into pn_emp, pn_suc, pn_mod, pn_tran, pn_nrel, pn_ord
        from fsd016 x
       where x.pgcod = 1
         and x.itsuc = lz_suc
         and x.itmod = 116
         and x.ittran = ln_trx --in (60/*,50*/)
         and x.itnrel = (select max(f.itnrel)
                           from fsd016 f
                          where f.pgcod = 1
                            and f.itsuc = lz_suc
                            and f.itmod = 116
                            and f.ittran = ln_trx --in (60/*,50*/)
                            and f.ctnro = lz_cta)
         and x.ctnro = lz_cta
         and x.itord in (10);
    exception
      when others then
        lc_coderr := sqlcode;
        lc_msgerr := sqlerrm;
        pn_resp   := 'N';
        pn_emp    := null;
        pn_suc    := null;
        pn_mod    := null;
        pn_tran   := null;
        pn_nrel   := null;
        pn_ord    := null;
    end;
  
    begin
      select x.itoper,
             x.moneda,
             x.papel,
             x.itsubo,
             x.itord,
             x.modulo,
             x.ctnro,
             x.ittope,
             x.itsucd
        into lp_oper,
             lp_mda,
             lp_pap,
             lp_subo,
             lp_ord,
             lp_mod,
             lp_cta,
             lp_tope,
             lp_sucd
        from fsd016 x
       where x.pgcod = pn_emp
         and x.itsuc = pn_suc
         and x.itmod = pn_mod
         and x.ittran = pn_tran
         and x.itnrel = pn_nrel
         and x.itord = pn_ord;
    exception
      when others then
        lp_oper := null;
        lp_mda  := null;
        lp_pap  := null;
        lp_subo := null;
        lp_ord  := null;
        lp_mod  := null;
        lp_cta  := null;
        lp_tope := null;
        lp_sucd := null;
    end;
  
    ---****
    --&ppctaAux = 999999999
    lx_ctaAux := 999999999;
  
    ln_emp  := pn_emp;
    ln_mod  := lp_mod;
    ln_suc  := lp_sucd;
    ln_mda  := lp_mda;
    ln_pap  := lp_pap;
    ln_cta  := lp_cta;
    ln_ope  := lp_oper;
    ln_sbop := lp_subo;
    ln_top  := lp_tope;
  
    pn_resp := 'N';
  
    if ln_emp is not null then
    
      begin
      
        if ln_mod = 116 and pn_tran = 50 then
        
          begin
            select ADD_MONTHS(f.xllfprimpa, (f.xllcantcuo - 1))
              into lx_fvto
              from x054023 f
             where f.xllpgcod = ln_emp
               and f.xllaomod = 116
               and f.xllaosuc = ln_suc
               and f.xllaomda = ln_mda
               and f.xllaopap = ln_pap
               and f.xllaocta = ln_cta
               and f.xllaooper = ln_ope
               and f.xllaosbop = ln_sbop
               and f.xllaotop = 20;
          exception
            when others then
              lx_fvto := null;
          end;
        
        end if;
      
        if ln_mod = 116 and pn_tran = 60 then
        
          begin
            select max(x.ppfpag)
              into lx_fvto
              from fsd601 x
             where x.pgcod = ln_emp
               and x.ppmod = 116
               and x.ppsuc = ln_suc
               and x.ppmda = ln_mda
               and x.pppap = ln_pap
               and x.ppcta = lx_ctaAux
               and x.ppoper = ln_ope
               and x.ppsbop = ln_sbop
               and x.pptope = 20
               and x.d601co = 'X';
          exception
            when others then
              lx_fvto := null;
          end;
        
        end if;
      
        if lx_fvto > lx_fpzo then
          pn_resp := 'S';
        end if;
      
      exception
        when others then
          pn_resp := 'N';
      end;
    
    end if;
  
  exception
    when others then
      pn_resp := 'N';
    
  end sp_plazo_max_vig2;
  -----------------------------------------------------------------------
  procedure sp_DIAS_FVALOR_FPAGO2(pn_ins  in number,
                                  pn_usur in varchar2,
                                  pn_resp out number) is
  
    lx_reac number;
    lx_crec number;
    lx_fae1 number;
    lx_fae2 number;
    pn_flag char(1);
  
    ln_emp  number(3);
    ln_suc  number(3);
    ln_mod  number(3);
    ln_mda  number(4);
    ln_pap  number(4);
    ln_cta  number(9);
    ln_ope  number(9);
    ln_sbop number(3);
    ln_top  number(3);
  
    lx_fvto date;
    lx_fpzo date;
    lx_diff number(9);
  
    lx_fec    date;
    lx_ctaAux number(9);
  
    lp_oper number(9);
    lp_mda  number(4);
    lp_pap  number(4);
    lp_subo number(3);
    lp_ord  number(2);
    lp_mod  number(3);
    lp_cta  number(9);
    lp_tope number(3);
    lp_sucd number(3);
  
    lz_suc number(3);
    lz_cta number(9);
  
    pn_emp   number(3);
    pn_suc   number(3);
    pn_mod   number(3);
    pn_tran  number(3);
    pn_nrel  number(4);
    pn_ord   number(2);
    pn_resul number(5);
  
    ln_trx    number;
    ln_cant   number;
    lc_coderr varchar2(100);
    lc_msgerr varchar2(1000);
  
  begin
  
    select to_date(t.tp1nro1, 'DDMMYY')
      into lx_fpzo
      from fst198 t
     where t.tp1cod = 1
       and t.tp1cod1 = 11144
       and t.tp1corr1 = 10
       and t.tp1corr2 = 1
       and t.tp1corr3 = 1;
  
    ---********
    select x.pgfape into lx_fec from fst017 x where x.pgcod = 1;
  
    ---********
    -- Obteniendo sucursal
    begin
      select x.ubsuc
        into lz_suc
        from fst046 x
       where TRIM(x.ubuser) = TRIM(pn_usur);
    exception
      when others then
        lz_suc := null;
    end;
  
    -- Obteniendo cuenta
    begin
      select distinct x.xwfcuenta
        into lz_cta
        from xwf700 x
       where x.xwfprcins = pn_ins
         and x.xwfcar3 = '1';
    exception
      when too_many_rows then
        select x.xwfcuenta
          into lz_cta
          from xwf700 x
         where x.xwfprcins = pn_ins
           and x.xwfcar3 = '1'
           and rownum = 1;
      when others then
        lz_cta := 0;
    end;
  
    -- existe transaccion
    begin
      select count(*)
        into ln_cant
        from fsd011 f
       where f.pgcod = 1
         and f.sccta = lz_cta
         and f.scmod = 116
         and f.sctope = 20
         and f.scstat <> 99; -- mpostigoc 11.05.2021
    exception
      when others then
        ln_cant := 0;
    end;
  
    if ln_cant > 0 then
      ln_trx := 60;
    else
      ln_trx := 50;
    end if;
  
    -- Obtener transacción
    begin
      select distinct x.pgcod,
                      x.itsuc,
                      x.itmod,
                      x.ittran,
                      x.itnrel,
                      x.itord
        into pn_emp, pn_suc, pn_mod, pn_tran, pn_nrel, pn_ord
        from fsd016 x
       where x.pgcod = 1
         and x.itsuc = lz_suc
         and x.itmod = 116
         and x.ittran = ln_trx --in (60, 50)
         and x.itnrel = (select max(f.itnrel)
                           from fsd016 f
                          where f.pgcod = 1
                            and f.itsuc = lz_suc
                            and f.itmod = 116
                            and f.ittran = ln_trx -- in (50, 60)
                            and f.ctnro = lz_cta)
         and x.ctnro = lz_cta
         and x.itord in (10);
    exception
      when others then
        lc_coderr := sqlcode;
        lc_msgerr := sqlerrm;
        pn_resp   := 0;
        pn_emp    := null;
        pn_suc    := null;
        pn_mod    := null;
        pn_tran   := null;
        pn_nrel   := null;
        pn_ord    := null;
    end;
  
    begin
      select x.itoper,
             x.moneda,
             x.papel,
             x.itsubo,
             x.itord,
             x.modulo,
             x.ctnro,
             x.ittope,
             x.itsucd
        into lp_oper,
             lp_mda,
             lp_pap,
             lp_subo,
             lp_ord,
             lp_mod,
             lp_cta,
             lp_tope,
             lp_sucd
        from fsd016 x
       where x.pgcod = pn_emp
         and x.itsuc = pn_suc
         and x.itmod = pn_mod
         and x.ittran = pn_tran
         and x.itnrel = pn_nrel
         and x.itord = pn_ord;
    exception
      when others then
        lp_oper := null;
        lp_mda  := null;
        lp_pap  := null;
        lp_subo := null;
        lp_ord  := null;
        lp_mod  := null;
        lp_cta  := null;
        lp_tope := null;
        lp_sucd := null;
    end;
    ---****
    --&ppctaAux = 999999999
    lx_ctaAux := 999999999;
  
    ln_emp  := pn_emp;
    ln_mod  := lp_mod;
    ln_suc  := lp_sucd;
    ln_mda  := lp_mda;
    ln_pap  := lp_pap;
    ln_cta  := lp_cta;
    ln_ope  := lp_oper;
    ln_sbop := lp_subo;
    ln_top  := lp_tope;
  
    pn_resp := 0;
  
    if ln_emp is not null then
    
      begin
      
        if ln_mod = 116 and pn_tran = 50 then
        
          begin
            select f.xllfprimpa
              into lx_fvto
              from x054023 f
             where f.xllpgcod = ln_emp
               and f.xllaomod = 116
               and f.xllaosuc = ln_suc
               and f.xllaomda = ln_mda
               and f.xllaopap = ln_pap
               and f.xllaocta = ln_cta
               and f.xllaooper = ln_ope
               and f.xllaosbop = ln_sbop
               and f.xllaotop = 20;
          exception
            when others then
              lx_fvto := null;
          end;
        
        end if;
      
        if ln_mod = 116 and pn_tran = 60 then
        
          begin
            select min(x.ppfpag)
              into lx_fvto
              from fsd601 x
             where x.pgcod = ln_emp
               and x.ppmod = 116
               and x.ppsuc = ln_suc
               and x.ppmda = ln_mda
               and x.pppap = ln_pap
               and x.ppcta = lx_ctaAux
               and x.ppoper = ln_ope
               and x.ppsbop = ln_sbop
               and x.pptope = 20
               and x.d601co = 'X';
          exception
            when others then
              lx_fvto := null;
          end;
        
        end if;
      
        pn_resul := lx_fvto - lx_fec;
        if pn_resul <= 0 then
          pn_resul := 0;
        end if;
      
        pn_resp := pn_resul;
      
      exception
        when others then
          pn_resp := 0;
      end;
    
    end if;
  
  exception
    when others then
      pn_resp := 0;
    
  end sp_DIAS_FVALOR_FPAGO2;

  -----------------------------------------------------------------------    
  -----------------------------------------------------------------------
  procedure sp_DIAS_FVTO_FPAGO2(pn_ins  in number,
                                pn_usur in varchar2,
                                pn_resp out number) is
  
    lx_reac number;
    lx_crec number;
    lx_fae1 number;
    lx_fae2 number;
    pn_flag char(1);
  
    ln_emp  number(3);
    ln_suc  number(3);
    ln_mod  number(3);
    ln_mda  number(4);
    ln_pap  number(4);
    ln_cta  number(9);
    ln_ope  number(9);
    ln_sbop number(3);
    ln_top  number(3);
  
    lx_fvto date;
    lx_fpzo date;
    lx_diff number(9);
  
    lx_fec    date;
    lx_ctaAux number(9);
  
    lp_oper number(9);
    lp_mda  number(4);
    lp_pap  number(4);
    lp_subo number(3);
    lp_ord  number(2);
    lp_mod  number(3);
    lp_cta  number(9);
    lp_tope number(3);
    lp_sucd number(3);
  
    lz_suc number(3);
    lz_cta number(9);
  
    pn_emp   number(3);
    pn_suc   number(3);
    pn_mod   number(3);
    pn_tran  number(3);
    pn_nrel  number(4);
    pn_ord   number(2);
    pn_resul number(5);
  
    ln_trx    number;
    ln_cant   number;
    lc_coderr varchar2(100);
    lc_msgerr varchar2(1000);
  
  begin
  
    select to_date(t.tp1nro1, 'DDMMYY')
      into lx_fpzo
      from fst198 t
     where t.tp1cod = 1
       and t.tp1cod1 = 11144
       and t.tp1corr1 = 10
       and t.tp1corr2 = 1
       and t.tp1corr3 = 1;
  
    ---********
    select x.pgfape into lx_fec from fst017 x where x.pgcod = 1;
  
    ---********
    -- Obteniendo sucursal
    begin
      select x.ubsuc
        into lz_suc
        from fst046 x
       where TRIM(x.ubuser) = TRIM(pn_usur);
    exception
      when others then
        lz_suc := null;
    end;
  
    -- Obteniendo cuenta
    begin
      select distinct x.xwfcuenta
        into lz_cta
        from xwf700 x
       where x.xwfprcins = pn_ins
         and x.xwfcar3 = '1';
    exception
      when too_many_rows then
        select x.xwfcuenta
          into lz_cta
          from xwf700 x
         where x.xwfprcins = pn_ins
           and x.xwfcar3 = '1'
           and rownum = 1;
      when others then
        lz_cta := 0;
    end;
  
    -- existe transaccion
    begin
      select count(*)
        into ln_cant
        from fsd011 f
       where f.pgcod = 1
         and f.sccta = lz_cta
         and f.scmod = 116
         and f.sctope = 20
         and f.scstat <> 99; -- mpostigoc 11.05.2021
    exception
      when others then
        ln_cant := 0;
    end;
  
    if ln_cant > 0 then
      ln_trx := 60;
    else
      ln_trx := 50;
    end if;
  
    -- Obtener transacción
    begin
      select distinct x.pgcod,
                      x.itsuc,
                      x.itmod,
                      x.ittran,
                      x.itnrel,
                      x.itord
        into pn_emp, pn_suc, pn_mod, pn_tran, pn_nrel, pn_ord
        from fsd016 x
       where x.pgcod = 1
         and x.itsuc = lz_suc
         and x.itmod = 116
         and x.ittran = ln_trx --in (60, 50)
         and x.itnrel = (select max(f.itnrel)
                           from fsd016 f
                          where f.pgcod = 1
                            and f.itsuc = lz_suc
                            and f.itmod = 116
                            and f.ittran = ln_trx -- in (50, 60)
                            and f.ctnro = lz_cta)
         and x.ctnro = lz_cta
         and x.itord in (10);
    exception
      when others then
        lc_coderr := sqlcode;
        lc_msgerr := sqlerrm;
        pn_resp   := 0;
        pn_emp    := null;
        pn_suc    := null;
        pn_mod    := null;
        pn_tran   := null;
        pn_nrel   := null;
        pn_ord    := null;
    end;
  
    begin
      select x.itoper,
             x.moneda,
             x.papel,
             x.itsubo,
             x.itord,
             x.modulo,
             x.ctnro,
             x.ittope,
             x.itsucd
        into lp_oper,
             lp_mda,
             lp_pap,
             lp_subo,
             lp_ord,
             lp_mod,
             lp_cta,
             lp_tope,
             lp_sucd
        from fsd016 x
       where x.pgcod = pn_emp
         and x.itsuc = pn_suc
         and x.itmod = pn_mod
         and x.ittran = pn_tran
         and x.itnrel = pn_nrel
         and x.itord = pn_ord;
    exception
      when others then
        lp_oper := null;
        lp_mda  := null;
        lp_pap  := null;
        lp_subo := null;
        lp_ord  := null;
        lp_mod  := null;
        lp_cta  := null;
        lp_tope := null;
        lp_sucd := null;
    end;
  
    ---****
    --&ppctaAux = 999999999
    lx_ctaAux := 999999999;
  
    ln_emp  := pn_emp;
    ln_mod  := lp_mod;
    ln_suc  := lp_sucd;
    ln_mda  := lp_mda;
    ln_pap  := lp_pap;
    ln_cta  := lp_cta;
    ln_ope  := lp_oper;
    ln_sbop := lp_subo;
    ln_top  := lp_tope;
  
    pn_resp := 0;
  
    if ln_emp is not null then
    
      begin
      
        if ln_mod = 116 and pn_tran = 50 then
        
          begin
            select ADD_MONTHS(f.xllfprimpa, (f.xllcantcuo - 1))
              into lx_fvto
              from x054023 f
             where f.xllpgcod = ln_emp
               and f.xllaomod = 116
               and f.xllaosuc = ln_suc
               and f.xllaomda = ln_mda
               and f.xllaopap = ln_pap
               and f.xllaocta = ln_cta
               and f.xllaooper = ln_ope
               and f.xllaosbop = ln_sbop
               and f.xllaotop = 20;
          exception
            when others then
              lx_fvto := null;
          end;
        
        end if;
      
        if ln_mod = 116 and pn_tran = 60 then
        
          begin
            select max(x.ppfpag)
              into lx_fvto
              from fsd601 x
             where x.pgcod = ln_emp
               and x.ppmod = 116
               and x.ppsuc = ln_suc
               and x.ppmda = ln_mda
               and x.pppap = ln_pap
               and x.ppcta = lx_ctaAux
               and x.ppoper = ln_ope
               and x.ppsbop = ln_sbop
               and x.pptope = 20
               and x.d601co = 'X';
          exception
            when others then
              lx_fvto := null;
          end;
        
        end if;
      
        pn_resul := lx_fvto - lx_fec;
        if pn_resul <= 0 then
          pn_resul := 0;
        end if;
      
        pn_resp := pn_resul;
      
      exception
        when others then
          pn_resp := 0;
      end;
    
    end if;
  
  exception
    when others then
      pn_resp := 0;
    
  end sp_DIAS_FVTO_FPAGO2;

-----------------------------------------------------------------------    

end PQ_CR_POLITICAS_FAGRO;
/

