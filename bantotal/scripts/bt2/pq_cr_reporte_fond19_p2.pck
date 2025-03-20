create or replace package pq_cr_reporte_fond19_p2 is
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Obtener cod. SBS y clasificación SBS: NORMAL, CPP, DEFICIENTE, DUDOSO, PERDIDA
  procedure sp_obtener_calf(pn_tdoc in number,
                            pn_ndoc in number,
                            pn_fech in date,
                            
                            pn_calif0 out aqpb065.aqpb065cnom%type,
                            pn_calif1 out aqpb065.aqpb065ccpp%type,
                            pn_calif2 out aqpb065.aqpb065cdef%type,
                            pn_calif3 out aqpb065.aqpb065cdud%type,
                            pn_calif4 out aqpb065.aqpb065cper%type,
                            pn_csbs   out aqpb065.aqpb065csbs%type);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Obtener nombre o razon social según tipo de documento
  function fn_obtener_nombre(p_pais in number,
                             p_tdoc in number,
                             p_ndoc in char) return char;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_tipo_credito_sbs_vig(pn_cod   in number,
                                    pn_mod   in number,
                                    pn_suc   in number,
                                    pn_mda   in number,
                                    pn_pap   in number,
                                    pn_cta   in number,
                                    pn_ope   in number,
                                    pn_sbo   in number,
                                    pn_top   in number,
                                    pn_fecha in date,
                                    --pn_ufech in date,
                                    pn_usuario in char,
                                    
                                    pn_ntipo out char,
                                    pn_nconc out char);
   -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_tipo_credito_sbs_vig2(pn_cod   in number,
                                    pn_mod   in number,
                                    pn_suc   in number,
                                    pn_mda   in number,
                                    pn_pap   in number,
                                    pn_cta   in number,
                                    pn_ope   in number,
                                    pn_sbo   in number,
                                    pn_top   in number,
                                    pn_fecha in date,
                                    pn_stat  in number,
                                    pn_fecan in date,
                                    --pn_ufech in date,
                                    pn_usuario in char,
                                    
                                    pn_ntipo out char,
                                    pn_nconc out char);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_tipo_credito_fst004(pn_cod   in number,
                                    pn_mod   in number,
                                    pn_suc   in number,
                                    pn_mda   in number,
                                    pn_pap   in number,
                                    pn_cta   in number,
                                    pn_ope   in number,
                                    pn_sbo   in number,
                                    pn_top   in number,
                                    pn_fecha in date,
                                    --pn_ufech in date,
                                    pn_usuario in char,
                                    pn_nconc out char);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Fecha del último pago
  function fn_fecha_upago(pn_cod   in number,
                          pn_mod   in number,
                          pn_suc   in number,
                          pn_mda   in number,
                          pn_pap   in number,
                          pn_cta   in number,
                          pn_ope   in number,
                          pn_sbo   in number,
                          pn_top   in number,
                          pn_fecha in date) return date;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                                       
  procedure sp_obtener_actuales(pn_cod   in number,
                                pn_mod   in number,
                                pn_suc   in number,
                                pn_mda   in number,
                                pn_pap   in number,
                                pn_cta   in number,
                                pn_ope   in number,
                                pn_sbo   in number,
                                pn_top   in number,
                                pn_fecha in date,
                                pn_fini  out date,
                                pn_ffin  out date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                                                                                                      
  /*
  procedure sp_cuotas_pendien_pag(pn_cod    in number,
                           pn_mod    in number,
                           pn_suc    in number,
                           pn_mda    in number,
                           pn_pap    in number,
                           pn_cta    in number,
                           pn_ope    in number,
                           pn_sbo    in number,
                           pn_top    in number,
                           pn_fec    in date,
                           pn_ncuopa out number); 
  */
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_obtener_sald_insol2(pn_cod   in number,
                                   pn_mod   in number,
                                   pn_suc   in number,
                                   pn_mda   in number,
                                   pn_pap   in number,
                                   pn_cta   in number,
                                   pn_ope   in number,
                                   pn_sbo   in number,
                                   pn_top   in number,
                                   pn_fecha in date,
                                   pn_indi  in number,
                                   pn_stat  in number,
                                   pn_sald  out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                    
  procedure sp_obtener_tasa_actual(pn_cod   in number,
                                   pn_mod   in number,
                                   pn_suc   in number,
                                   pn_mda   in number,
                                   pn_pap   in number,
                                   pn_cta   in number,
                                   pn_ope   in number,
                                   pn_sbo   in number,
                                   pn_top   in number,
                                   pn_fecha in date,
                                   pn_tasa  out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_obtener_tcredito(pn_cod     in number,
                                pn_mod     in number,
                                pn_suc     in number,
                                pn_mda     in number,
                                pn_pap     in number,
                                pn_cta     in number,
                                pn_ope     in number,
                                pn_sbo     in number,
                                pn_top     in number,
                                pn_fecha   in date,
                                pn_usuario in char,
                                pn_tip     out char);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_obtener_tcredito2(pn_cod     in number,
                                pn_mod     in number,
                                pn_suc     in number,
                                pn_mda     in number,
                                pn_pap     in number,
                                pn_cta     in number,
                                pn_ope     in number,
                                pn_sbo     in number,
                                pn_top     in number,
                                pn_fecha   in date,
                                pn_stat    in number,
                                pn_fecan   in date,
                                pn_usuario in char,
                                pn_tip     out char);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_fecha_ncuotas(pn_cod    in number,
                             pn_mod    in number,
                             pn_suc    in number,
                             pn_mda    in number,
                             pn_pap    in number,
                             pn_cta    in number,
                             pn_ope    in number,
                             pn_sbo    in number,
                             pn_top    in number,
                             pn_fecha  in date,
                             pn_ncuopp out number, -- Nro cuota
                             pn_ncuopa out number); -- Cuotas ya pagadas  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_fecha_ncuotas2(pn_cod    in number,
                             pn_mod    in number,
                             pn_suc    in number,
                             pn_mda    in number,
                             pn_pap    in number,
                             pn_cta    in number,
                             pn_ope    in number,
                             pn_sbo    in number,
                             pn_top    in number,
                             pn_fecha  in date,
                             pn_fcovid in date,
                             pn_ncuopp out number, -- Nro cuota
                             pn_ncuopa out number); -- Cuotas ya pagadas     
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                                        
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_obtener_iniciales(pn_cod      in number,
                                 pn_mod      in number,
                                 pn_suc      in number,
                                 pn_mda      in number,
                                 pn_pap      in number,
                                 pn_cta      in number,
                                 pn_ope      in number,
                                 pn_sbo      in number,
                                 pn_top      in number,
                                 pn_tasa_ini out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  function fn_obtener_sdocap(pn_cod     in number,
                             pn_mod     in number,
                             pn_suc     in number,
                             pn_mda     in number,
                             pn_pap     in number,
                             pn_cta     in number,
                             pn_ope     in number,
                             pn_sbo     in number,
                             pn_top     in number,
                             pn_fecha   in date,
                             pn_usuario in char) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  function fn_obtener_pgracia3(pn_cod   in number,
                               pn_mod   in number,
                               pn_suc   in number,
                               pn_mda   in number,
                               pn_pap   in number,
                               pn_cta   in number,
                               pn_ope   in number,
                               pn_sbo   in number,
                               pn_top   in number,
                               pn_fecha in date) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                
  procedure sp_siguiente_creditoPK(pn_cod   in number,
                                pn_mod   in number,
                                pn_suc   in number,
                                pn_mda   in number,
                                pn_pap   in number,
                                pn_cta   in number,
                                pn_ope   in number,
                                pn_sbo   in number,
                                pn_top   in number,
                                pn_fecha in date,
                                pn_fec_rep  out date,
                                pn_cor_rep  out number);  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                                                
  function fn_max_frep(pn_cod   in number,
                          pn_mod   in number,
                          pn_suc   in number,
                          pn_mda   in number,
                          pn_pap   in number,
                          pn_cta   in number,
                          pn_ope   in number,
                          pn_sbo   in number,
                          pn_top   in number,
                          pn_fecha in date) return date; 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

end pq_cr_reporte_fond19_p2;
/

create or replace package body pq_cr_reporte_fond19_p2 is
  -- Obtener Fecha de vencimiento de última cuota impaga

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_obtener_calf(pn_tdoc in number,
                            pn_ndoc in number,
                            pn_fech in date,
                            
                            pn_calif0 out aqpb065.aqpb065cnom%type,
                            pn_calif1 out aqpb065.aqpb065ccpp%type,
                            pn_calif2 out aqpb065.aqpb065cdef%type,
                            pn_calif3 out aqpb065.aqpb065cdud%type,
                            pn_calif4 out aqpb065.aqpb065cper%type,
                            pn_csbs   out aqpb065.aqpb065csbs%type) is
  
    lc_fecha     date;
    lc_fecha_pro date;
    lc_fecha_rcc date;
    lc_nro_mes   number(3);
  
  begin
    pn_csbs := '0';
    --select t.pgfape into lc_fecha from fst017 t where t.pgcod=1;
    -- 1. Nro meses RCC
    begin
      select x.tp1nro1
        into lc_nro_mes
        from fst198 x
       where x.TP1COD = 1
         and x.TP1COD1 = 11144
         and x.TP1CORR1 = 10
         and x.tp1corr2 = 2
         and x.tp1corr3 = 4;
    exception
      when others then
        lc_nro_mes := 1;
    end;
  
    -- 2. Fecha RCC
    select to_date(t.tpnro, 'DDMMYY')
      into lc_fecha_rcc
      from fst098 t
     where t.pgcod = 1
       and t.tpcod = 7647
       and t.tpcorr = 12;
  
    if pn_fech <= lc_fecha_rcc then
      lc_fecha_pro := last_day(add_months(trunc(pn_fech), -1 * lc_nro_mes));
    else
      lc_fecha_pro := lc_fecha_rcc;
    end if;
  
    /*
    if pn_fech > lc_fecha_rcc then
    
      lc_fecha_pro := lc_fecha_rcc;
    else
      lc_fecha_pro := last_day(add_months(trunc(lc_fecha_rcc), -1));
    end if;
    */
    -- 8. Código de cliente SBS (dato del BT)
  
    -- Verificar tipo de documento
    if pn_tdoc = 21 then
    
      begin
        select trim(t.c_codsbs),
               t.n_calif0,
               t.n_calif1,
               t.n_calif2,
               t.n_calif3,
               t.n_calif4
          into pn_csbs,
               pn_calif0,
               pn_calif1,
               pn_calif2,
               pn_calif3,
               pn_calif4
          from cldrcci t
         where t.d_fecpre = lc_fecha_pro
           and t.c_tdocid =
               pq_cr_reporte_fondos_p3.FN_EQUIVALENCIADOC(pn_tdoc)
           and t.c_docide = lpad(trim(to_char(pn_ndoc)), 8, '0');
      exception
        when too_many_rows then
          begin
            select trim(t.c_codsbs),
                   t.n_calif0,
                   t.n_calif1,
                   t.n_calif2,
                   t.n_calif3,
                   t.n_calif4
              into pn_csbs,
                   pn_calif0,
                   pn_calif1,
                   pn_calif2,
                   pn_calif3,
                   pn_calif4
              from cldrcci t
             where t.d_fecpre = lc_fecha_pro
               and t.c_tdocid =
                   pq_cr_reporte_fondos_p3.FN_EQUIVALENCIADOC(pn_tdoc)
               and t.c_docide = lpad(trim(to_char(pn_ndoc)), 8, '0')
               and t.c_person = 1
               and rownum = 1;
          exception
            when others then
              pn_csbs   := '0';
              pn_calif0 := 100;
              pn_calif1 := 0;
              pn_calif2 := 0;
              pn_calif3 := 0;
              pn_calif4 := 0;
          end;
          --when no_data_found then
        --  ln_item := 0;
        --when others then
        --  null;
        --end;
      
        --exception
        when others then
          pn_csbs   := '0';
          pn_calif0 := 100;
          pn_calif1 := 0;
          pn_calif2 := 0;
          pn_calif3 := 0;
          pn_calif4 := 0;
      end;
      if pn_csbs = '0' then
        begin
            for i in 1 .. 18 loop
                begin
                  select trim(t.c_codsbs)
                         into pn_csbs
                         from cldrcci t
                         where t.d_fecpre = add_months(lc_fecha_pro,-i)
                         and t.c_tdocid = (select tp1nro2
                                   from fst198
                                  where tp1cod = 1
                                    and tp1cod1 = 11111
                                    and tp1corr1 = 1
                                    and tp1corr2 = 5
                                    and tp1nro1 = pn_tdoc
                                    and rownum = 1)
                              and t.c_docide = trim(pn_ndoc)
                              and t.c_person = 1
                              and rownum = 1;
                exception 
                  when others then
                    pn_csbs   := '0';
                end;
                EXIT WHEN pn_csbs <> '0';                    
            end loop;
          exception 
            when others then 
              pn_csbs   := '0';
          end;
      end if;
    
    else
    
      begin
        select trim(t.c_codsbs),
               t.n_calif0,
               t.n_calif1,
               t.n_calif2,
               t.n_calif3,
               t.n_calif4
          into pn_csbs,
               pn_calif0,
               pn_calif1,
               pn_calif2,
               pn_calif3,
               pn_calif4
          from cldrcci t
         where t.d_fecpre = lc_fecha_pro
           and t.c_tdoctr =
               pq_cr_reporte_fondos_p3.FN_EQUIVALENCIADOC(pn_tdoc)
           and t.c_doctri = trim(pn_ndoc);
      exception
        when too_many_rows then
          begin
            select trim(t.c_codsbs),
                   t.n_calif0,
                   t.n_calif1,
                   t.n_calif2,
                   t.n_calif3,
                   t.n_calif4
              into pn_csbs,
                   pn_calif0,
                   pn_calif1,
                   pn_calif2,
                   pn_calif3,
                   pn_calif4
              from cldrcci t
             where t.d_fecpre = lc_fecha_pro
               and t.c_tdoctr =
                   pq_cr_reporte_fondos_p3.FN_EQUIVALENCIADOC(pn_tdoc)
               and t.c_doctri = trim(pn_ndoc)
               and t.c_person = 1
               and rownum = 1;
          exception
            when others then
              pn_csbs   := '0';
              pn_calif0 := 100;
              pn_calif1 := 0;
              pn_calif2 := 0;
              pn_calif3 := 0;
              pn_calif4 := 0;
          end;
          --when no_data_found then
        --  ln_item := 0;
        --when others then
        --  null;
        --end;
      
        --exception
        when others then
          pn_csbs   := '0';
          pn_calif0 := 100;
          pn_calif1 := 0;
          pn_calif2 := 0;
          pn_calif3 := 0;
          pn_calif4 := 0;
      end;
      if pn_csbs = '0' then
        begin
            for i in 1 .. 18 loop
                begin
                  select trim(t.c_codsbs)
                         into pn_csbs
                         from cldrcci t
                         where t.d_fecpre = add_months(lc_fecha_pro,-i)
                         and t.c_tdocid = (select tp1nro2
                                   from fst198
                                  where tp1cod = 1
                                    and tp1cod1 = 11111
                                    and tp1corr1 = 1
                                    and tp1corr2 = 5
                                    and tp1nro1 = pn_tdoc
                                    and rownum = 1)
                              and t.c_docide = trim(pn_ndoc)
                              and t.c_person = 1
                              and rownum = 1;
                exception 
                  when others then
                    pn_csbs   := '0';
                end;
                EXIT WHEN pn_csbs <> '0';                    
            end loop;
          exception 
            when others then 
              pn_csbs   := '0';
          end;
      end if;
    
    end if;
  
  end sp_obtener_calf;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_obtener_nombre(p_pais in number,
                             p_tdoc in number,
                             p_ndoc in char) return char is
  
    lc_razon char(100);
    respc    char(100);
  
  begin
    begin
    
      if p_tdoc = 21 then
        -- -- -- -- -- -- -- -- -- --
        begin
          select concat(trim(s.pfape1),
                        concat(' ',
                               concat(trim(s.pfape2),
                                      concat(' ',
                                             concat(trim(s.pfnom1),
                                                    concat(' ', s.pfnom2))))))
            into lc_razon
            from fsd002 s
           where s.pfpais = p_pais
             and s.pftdoc = p_tdoc
             and s.pfndoc = p_ndoc;
        exception
          when others then
            lc_razon := '';
        end;
        -- -- -- -- -- -- -- -- -- --
      else
        -- -- -- -- -- -- -- -- -- --
        begin
          select trim(y.pjrazs)
            into lc_razon
            from fsd003 y
           where y.pjpais = p_pais
             and y.pjtdoc = p_tdoc
             and y.pjndoc = p_ndoc;
        exception
          when others then
            lc_razon := '';
        end;
        -- -- -- -- -- -- -- -- -- --
      end if;
    
      respc := lc_razon;
    
    exception
      when others then
      
        respc := '';
      
    end;
  
    return respc;
  
  end fn_obtener_nombre;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_tipo_credito_sbs_vig(pn_cod   in number,
                                    pn_mod   in number,
                                    pn_suc   in number,
                                    pn_mda   in number,
                                    pn_pap   in number,
                                    pn_cta   in number,
                                    pn_ope   in number,
                                    pn_sbo   in number,
                                    pn_top   in number,
                                    pn_fecha in date,
                                    --pn_ufech in date,
                                    pn_usuario in char,
                                    
                                    pn_ntipo out char,
                                    pn_nconc out char) is
  
    lx_fecha date;
    --lx_conce     char(25);
    lx_fecha_ant date;
    pn_ufech     date;
    lx_anio      number(5);
  
  begin
  
    -- 1. Obtención de Fecha actual
  
    select t.pgfape into lx_fecha from fst017 t where t.pgcod = 1;
  
    -- 2. Obtención última fecha de pago
    begin
      -- Call the function
      pn_ufech := pq_cr_reporte_fond19_p2.fn_fecha_upago(pn_cod   => pn_cod,
                                                         pn_mod   => pn_mod,
                                                         pn_suc   => pn_suc,
                                                         pn_mda   => pn_mda,
                                                         pn_pap   => pn_pap,
                                                         pn_cta   => pn_cta,
                                                         pn_ope   => pn_ope,
                                                         pn_sbo   => pn_sbo,
                                                         pn_top   => pn_top,
                                                         pn_fecha => pn_fecha);
    exception
      when others then
        pn_ufech := null;
    end;
  
    -- 3. Otención de último fin de mes anterior a la última fecha de pago
    if pn_ufech is not null then
      lx_fecha_ant := last_day(add_months(trunc(pn_ufech), -1));
    end if;
  
    -- 4. Obtención del tipo de crédito SBS
    begin
    
      if lx_fecha <> pn_fecha then
      
        begin
          -- 1ro. Buscar con la fecha de corte
          select g.tipo, g.nconcepto
            into pn_ntipo, pn_nconc
          
            from (select --t.aqpb070agpo tipo,
                   case
                     when t.aqpb070agpo = 2 then
                      'MIC' --'MICROEMPRESAS'
                     when t.aqpb070agpo = 3 and
                          substr(t.aqpb070arubr, 11, 3) = '015' then
                      'CRE' --'CONSUMO REVOLVENTE'
                     when t.aqpb070agpo = 3 and
                          substr(t.aqpb070arubr, 11, 3) <> '015' then
                      'CNR' --'CONSUMO NO REVOLVENTE'
                     when t.aqpb070agpo = 4 then
                      'HIP' --'HIPOTECARIO'
                   --when t.aqpb070agpo = 12 then
                   -- 'MEDIANA EMPRESA'
                     when t.aqpb070agpo = 13 then
                      'PEQ' --'PEQUEÑA EMPRESA'
                   --when t.aqpb070agpo = 11 then
                   -- 'GRANDES EMPRESAS'
                   --when t.aqpb070agpo in (5, 6, 7, 8, 9, 10) then
                   -- 'CORPORATIVO'
                     else
                      ' '
                   END tipo,
                   case
                     when t.aqpb070agpo = 2 then
                      'MICROEMPRESAS'
                     when t.aqpb070agpo = 3 and
                          substr(t.aqpb070arubr, 11, 3) = '015' then
                      'CONSUMO REVOLVENTE'
                     when t.aqpb070agpo = 3 and
                          substr(t.aqpb070arubr, 11, 3) <> '015' then
                      'CONSUMO NO REVOLVENTE'
                     when t.aqpb070agpo = 4 then
                      'HIPOTECARIO'
                   --when t.aqpb070agpo = 12 then
                   -- 'MEDIANA EMPRESA'
                     when t.aqpb070agpo = 13 then
                      'PEQUEÑA EMPRESA'
                   --when t.aqpb070agpo = 11 then
                   -- 'GRANDES EMPRESAS'
                   --when t.aqpb070agpo in (5, 6, 7, 8, 9, 10) then
                   -- 'CORPORATIVO'
                     else
                      ' '
                   END nconcepto
                  
                    from aqpb070a t --- fsd011
                   where t.aqpb070ausur = pn_usuario
                     and t.aqpb070aemp = pn_cod
                     and t.aqpb070amod = pn_mod
                     --and t.aqpb070asuc = pn_suc
                     and t.aqpb070amda = pn_mda
                     and t.aqpb070apap = pn_pap
                     and t.aqpb070acta = pn_cta
                     and t.aqpb070aoper = pn_ope
                     --and t.bcsbop = pn_sbo
                     and t.aqpb070atop = pn_top
                     and t.aqpb070afech = pn_fecha
                  ---order by t.bcfech desc
                  
                  ) g
           where rownum = 1;
        
        exception
          when others then
            if lx_fecha_ant is null then
              lx_fecha_ant := pn_fecha;
            end if;
            begin
            
              select extract(year from lx_fecha_ant) as anio
                into lx_anio
                from dual;
            
              select --substr(f.harub, 5, 2) scgru
               case
                 when substr(f.harub, 5, 2) = 2 then
                  'MIC' --'MICROEMPRESAS'
                 when substr(f.harub, 5, 2) = 3 and
                      substr(f.harub, 11, 3) = '015' then
                  'CRE' --'CONSUMO REVOLVENTE'
                 when substr(f.harub, 5, 2) = 3 and
                      substr(f.harub, 11, 3) <> '015' then
                  'CNR' --'CONSUMO NO REVOLVENTE'
                 when substr(f.harub, 5, 2) = 4 then
                  'HIP' --'HIPOTECARIO'
               --when substr(f.harub, 5, 2) = 12 then
               -- 'MEDIANA EMPRESA'
                 when substr(f.harub, 5, 2) = 13 then
                  'PEQ' -- 'PEQUEÑA EMPRESA'
               --when substr(f.harub, 5, 2) = 11 then
               -- 'GRANDES EMPRESAS'
               --when substr(f.harub, 5, 2) in (5, 6, 7, 8, 9, 10) then
               -- 'CORPORATIVO'
                 else
                  ' '
               END,
               case
                 when substr(f.harub, 5, 2) = 2 then
                  'MICROEMPRESAS'
                 when substr(f.harub, 5, 2) = 3 and
                      substr(f.harub, 11, 3) = '015' then
                  'CONSUMO REVOLVENTE'
                 when substr(f.harub, 5, 2) = 3 and
                      substr(f.harub, 11, 3) <> '015' then
                  'CONSUMO NO REVOLVENTE'
                 when substr(f.harub, 5, 2) = 4 then
                  'HIPOTECARIO'
               --when substr(f.harub, 5, 2) = 12 then
               -- 'MEDIANA EMPRESA'
                 when substr(f.harub, 5, 2) = 13 then
                  'PEQUEÑA EMPRESA'
               --when substr(f.harub, 5, 2) = 11 then
               -- 'GRANDES EMPRESAS'
               --when substr(f.harub, 5, 2) in (5, 6, 7, 8, 9, 10) then
               -- 'CORPORATIVO'
                 else
                  ' '
               END
                into pn_ntipo, pn_nconc
              
                from fsh014 f
               where f.pgcod = pn_cod
                 and f.HAMOD = pn_mod
                 and f.HACTA = pn_cta
                 and f.HAMDA = pn_mda
                 and f.HAPAP = pn_pap
                 and f.HASUC = pn_suc
                 and f.HAOPER = pn_ope
                 and f.HASBOP = pn_sbo
                 --and f.HATOPE = pn_top
                 and f.HAANIO = lx_anio
                 and rownum = 1;
            
            exception
              when no_data_found then
                begin
            
                  select extract(year from add_months(lx_fecha_ant,-12)) as anio
                    into lx_anio
                    from dual;
                
                  select --substr(f.harub, 5, 2) scgru
                   case
                     when substr(f.harub, 5, 2) = 2 then
                      'MIC' --'MICROEMPRESAS'
                     when substr(f.harub, 5, 2) = 3 and
                          substr(f.harub, 11, 3) = '015' then
                      'CRE' --'CONSUMO REVOLVENTE'
                     when substr(f.harub, 5, 2) = 3 and
                          substr(f.harub, 11, 3) <> '015' then
                      'CNR' --'CONSUMO NO REVOLVENTE'
                     when substr(f.harub, 5, 2) = 4 then
                      'HIP' --'HIPOTECARIO'
                   
                     when substr(f.harub, 5, 2) = 13 then
                      'PEQ' -- 'PEQUEÑA EMPRESA'
                   
                     else
                      ' '
                   END,
                   case
                     when substr(f.harub, 5, 2) = 2 then
                      'MICROEMPRESAS'
                     when substr(f.harub, 5, 2) = 3 and
                          substr(f.harub, 11, 3) = '015' then
                      'CONSUMO REVOLVENTE'
                     when substr(f.harub, 5, 2) = 3 and
                          substr(f.harub, 11, 3) <> '015' then
                      'CONSUMO NO REVOLVENTE'
                     when substr(f.harub, 5, 2) = 4 then
                      'HIPOTECARIO'
                  
                     when substr(f.harub, 5, 2) = 13 then
                      'PEQUEÑA EMPRESA'
                   
                     else
                      ' '
                   END
                    into pn_ntipo, pn_nconc
                  
                    from fsh014 f
                   where f.pgcod = pn_cod
                     and f.HAMOD = pn_mod
                     and f.HACTA = pn_cta
                     and f.HAMDA = pn_mda
                     and f.HAPAP = pn_pap
                     and f.HASUC = pn_suc
                     and f.HAOPER = pn_ope
                     and f.HASBOP = pn_sbo
                     --and f.HATOPE = pn_top
                     and f.HAANIO = lx_anio
                     and rownum = 1;
                
                exception
                  when no_data_found then
                    begin
                
                      select extract(year from add_months(lx_fecha_ant,-24)) as anio
                        into lx_anio
                        from dual;
                    
                      select --substr(f.harub, 5, 2) scgru
                       case
                         when substr(f.harub, 5, 2) = 2 then
                          'MIC' --'MICROEMPRESAS'
                         when substr(f.harub, 5, 2) = 3 and
                              substr(f.harub, 11, 3) = '015' then
                          'CRE' --'CONSUMO REVOLVENTE'
                         when substr(f.harub, 5, 2) = 3 and
                              substr(f.harub, 11, 3) <> '015' then
                          'CNR' --'CONSUMO NO REVOLVENTE'
                         when substr(f.harub, 5, 2) = 4 then
                          'HIP' --'HIPOTECARIO'
                       
                         when substr(f.harub, 5, 2) = 13 then
                          'PEQ' -- 'PEQUEÑA EMPRESA'
                       
                         else
                          ' '
                       END,
                       case
                         when substr(f.harub, 5, 2) = 2 then
                          'MICROEMPRESAS'
                         when substr(f.harub, 5, 2) = 3 and
                              substr(f.harub, 11, 3) = '015' then
                          'CONSUMO REVOLVENTE'
                         when substr(f.harub, 5, 2) = 3 and
                              substr(f.harub, 11, 3) <> '015' then
                          'CONSUMO NO REVOLVENTE'
                         when substr(f.harub, 5, 2) = 4 then
                          'HIPOTECARIO'
                      
                         when substr(f.harub, 5, 2) = 13 then
                          'PEQUEÑA EMPRESA'
                       
                         else
                          ' '
                       END
                        into pn_ntipo, pn_nconc
                      
                        from fsh014 f
                       where f.pgcod = pn_cod
                         and f.HAMOD = pn_mod
                         and f.HACTA = pn_cta
                         and f.HAMDA = pn_mda
                         and f.HAPAP = pn_pap
                         and f.HASUC = pn_suc
                         and f.HAOPER = pn_ope
                         and f.HASBOP = pn_sbo
                         --and f.HATOPE = pn_top
                         and f.HAANIO = lx_anio
                         and  rownum = 1;
                    
                    exception
                      when others then
                      
                        pn_ntipo := null;
                        pn_nconc := null;
                      
                    end;
                  when others then
                  
                    pn_ntipo := null;
                    pn_nconc := null;
                  
                end;
              when others then
              
                pn_ntipo := null;
                pn_nconc := null;
              
            end;
          
        end;
      
      else
        begin
          -- 1ro. Buscar en la tabla fsd011
          select --t.scgru
           case
             when t.scgru = 2 then
              'MIC' --'MICROEMPRESAS'
             when t.scgru = 3 and substr(t.scrub, 11, 3) = '015' then
              'CRE' --'CONSUMO REVOLVENTE'
             when t.scgru = 3 and substr(t.scrub, 11, 3) <> '015' then
              'CNR' --'CONSUMO NO REVOLVENTE'
             when t.scgru = 4 then
              'HIP' --'HIPOTECARIO'
           --when t.scgru = 12 then
           -- 'MEDIANA EMPRESA'
             when t.scgru = 13 then
              'PEQ' --'PEQUEÑA EMPRESA'
           --when t.scgru = 11 then
           -- 'GRANDES EMPRESAS'
           --when t.scgru in (5, 6, 7, 8, 9, 10) then
           -- 'CORPORATIVO'
             else
              ' '
           END scgru,
           case
             when t.scgru = 2 then
              'MICROEMPRESAS'
             when t.scgru = 3 and substr(t.scrub, 11, 3) = '015' then
              'CONSUMO REVOLVENTE'
             when t.scgru = 3 and substr(t.scrub, 11, 3) <> '015' then
              'CONSUMO NO REVOLVENTE'
             when t.scgru = 4 then
              'HIPOTECARIO'
           --when t.scgru = 12 then
           -- 'MEDIANA EMPRESA'
             when t.scgru = 13 then
              'PEQUEÑA EMPRESA'
           --when t.scgru = 11 then
           -- 'GRANDES EMPRESAS'
           --when t.scgru in (5, 6, 7, 8, 9, 10) then
           -- 'CORPORATIVO'
             else
              ' '
           END
            into pn_ntipo, pn_nconc
            from fsd011 t
           where t.pgcod = pn_cod
             and t.scmod = pn_mod
             --and t.scsuc = pn_suc
             and t.scmda = pn_mda
             and t.scpap = pn_pap
             and t.sccta = pn_cta
             and t.scoper = pn_ope
             --and t.scsbop = pn_sbo
             and t.sctope = pn_top
             and rownum = 1;
        
        exception
          when others then
            if lx_fecha_ant is null then
              lx_fecha_ant := pn_fecha;
            end if;
            begin
            
              select extract(year from lx_fecha_ant) as anio
                into lx_anio
                from dual;
            
              select --substr(f.harub, 5, 2) scgru
               case
                 when substr(f.harub, 5, 2) = 2 then
                  'MIC' --'MICROEMPRESAS'
                 when substr(f.harub, 5, 2) = 3 and
                      substr(f.harub, 11, 3) = '015' then
                  'CRE' --'CONSUMO REVOLVENTE'
                 when substr(f.harub, 5, 2) = 3 and
                      substr(f.harub, 11, 3) <> '015' then
                  'CNR' --'CONSUMO NO REVOLVENTE'
                 when substr(f.harub, 5, 2) = 4 then
                  'HIP' --'HIPOTECARIO'
               --when substr(f.harub, 5, 2) = 12 then
               -- 'MEDIANA EMPRESA'
                 when substr(f.harub, 5, 2) = 13 then
                  'PEQ' -- 'PEQUEÑA EMPRESA'
               --when substr(f.harub, 5, 2) = 11 then
               -- 'GRANDES EMPRESAS'
               --when substr(f.harub, 5, 2) in (5, 6, 7, 8, 9, 10) then
               -- 'CORPORATIVO'
                 else
                  ' '
               END scgru,
               case
                 when substr(f.harub, 5, 2) = 2 then
                  'MICROEMPRESAS'
                 when substr(f.harub, 5, 2) = 3 and
                      substr(f.harub, 11, 3) = '015' then
                  'CONSUMO REVOLVENTE'
                 when substr(f.harub, 5, 2) = 3 and
                      substr(f.harub, 11, 3) <> '015' then
                  'CONSUMO NO REVOLVENTE'
                 when substr(f.harub, 5, 2) = 4 then
                  'HIPOTECARIO'
               --when substr(f.harub, 5, 2) = 12 then
               -- 'MEDIANA EMPRESA'
                 when substr(f.harub, 5, 2) = 13 then
                  'PEQUEÑA EMPRESA'
               --when substr(f.harub, 5, 2) = 11 then
               -- 'GRANDES EMPRESAS'
               --when substr(f.harub, 5, 2) in (5, 6, 7, 8, 9, 10) then
               -- 'CORPORATIVO'
                 else
                  ' '
               END
                into pn_ntipo, pn_nconc
              
                from fsh014 f
               where f.pgcod = pn_cod
                 and f.HAMOD = pn_mod
                 and f.HACTA = pn_cta
                 and f.HAMDA = pn_mda
                 and f.HAPAP = pn_pap
                 and f.HASUC = pn_suc
                 and f.HAOPER = pn_ope
                 and f.HASBOP = pn_sbo
                 --and f.HATOPE = pn_top
                 and f.HAANIO = lx_anio
                 and rownum = 1;
            
            exception
              when no_data_found then
                begin
            
                  select extract(year from add_months(lx_fecha_ant,-12)) as anio
                    into lx_anio
                    from dual;
                
                  select --substr(f.harub, 5, 2) scgru
                   case
                     when substr(f.harub, 5, 2) = 2 then
                      'MIC' --'MICROEMPRESAS'
                     when substr(f.harub, 5, 2) = 3 and
                          substr(f.harub, 11, 3) = '015' then
                      'CRE' --'CONSUMO REVOLVENTE'
                     when substr(f.harub, 5, 2) = 3 and
                          substr(f.harub, 11, 3) <> '015' then
                      'CNR' --'CONSUMO NO REVOLVENTE'
                     when substr(f.harub, 5, 2) = 4 then
                      'HIP' --'HIPOTECARIO'
                   
                     when substr(f.harub, 5, 2) = 13 then
                      'PEQ' -- 'PEQUEÑA EMPRESA'
                   
                     else
                      ' '
                   END,
                   case
                     when substr(f.harub, 5, 2) = 2 then
                      'MICROEMPRESAS'
                     when substr(f.harub, 5, 2) = 3 and
                          substr(f.harub, 11, 3) = '015' then
                      'CONSUMO REVOLVENTE'
                     when substr(f.harub, 5, 2) = 3 and
                          substr(f.harub, 11, 3) <> '015' then
                      'CONSUMO NO REVOLVENTE'
                     when substr(f.harub, 5, 2) = 4 then
                      'HIPOTECARIO'
                  
                     when substr(f.harub, 5, 2) = 13 then
                      'PEQUEÑA EMPRESA'
                   
                     else
                      ' '
                   END
                    into pn_ntipo, pn_nconc
                  
                    from fsh014 f
                   where f.pgcod = pn_cod
                     and f.HAMOD = pn_mod
                     and f.HACTA = pn_cta
                     and f.HAMDA = pn_mda
                     and f.HAPAP = pn_pap
                     and f.HASUC = pn_suc
                     and f.HAOPER = pn_ope
                     and f.HASBOP = pn_sbo
                     --and f.HATOPE = pn_top
                     and f.HAANIO = lx_anio
                     and rownum = 1;
                
                exception
                  when no_data_found then
                    begin
                
                      select extract(year from add_months(lx_fecha_ant,-24)) as anio
                        into lx_anio
                        from dual;
                    
                      select --substr(f.harub, 5, 2) scgru
                       case
                         when substr(f.harub, 5, 2) = 2 then
                          'MIC' --'MICROEMPRESAS'
                         when substr(f.harub, 5, 2) = 3 and
                              substr(f.harub, 11, 3) = '015' then
                          'CRE' --'CONSUMO REVOLVENTE'
                         when substr(f.harub, 5, 2) = 3 and
                              substr(f.harub, 11, 3) <> '015' then
                          'CNR' --'CONSUMO NO REVOLVENTE'
                         when substr(f.harub, 5, 2) = 4 then
                          'HIP' --'HIPOTECARIO'
                       
                         when substr(f.harub, 5, 2) = 13 then
                          'PEQ' -- 'PEQUEÑA EMPRESA'
                       
                         else
                          ' '
                       END,
                       case
                         when substr(f.harub, 5, 2) = 2 then
                          'MICROEMPRESAS'
                         when substr(f.harub, 5, 2) = 3 and
                              substr(f.harub, 11, 3) = '015' then
                          'CONSUMO REVOLVENTE'
                         when substr(f.harub, 5, 2) = 3 and
                              substr(f.harub, 11, 3) <> '015' then
                          'CONSUMO NO REVOLVENTE'
                         when substr(f.harub, 5, 2) = 4 then
                          'HIPOTECARIO'
                      
                         when substr(f.harub, 5, 2) = 13 then
                          'PEQUEÑA EMPRESA'
                       
                         else
                          ' '
                       END
                        into pn_ntipo, pn_nconc
                      
                        from fsh014 f
                       where f.pgcod = pn_cod
                         and f.HAMOD = pn_mod
                         and f.HACTA = pn_cta
                         and f.HAMDA = pn_mda
                         and f.HAPAP = pn_pap
                         and f.HASUC = pn_suc
                         and f.HAOPER = pn_ope
                         and f.HASBOP = pn_sbo
                         --and f.HATOPE = pn_top
                         and f.HAANIO = lx_anio
                         and  rownum = 1;
                    
                    exception
                      when others then
                      
                        pn_ntipo := null;
                        pn_nconc := null;
                      
                    end;
                  when others then
                  
                    pn_ntipo := null;
                    pn_nconc := null;
                  
                end;            
              
            
              when others then
              
                pn_ntipo := null;
                pn_nconc := null;
              
            end;
          
        end;
      
      end if;
    
    exception
      when others then
        pn_ntipo := null;
        pn_nconc := null;
      
    end;
  
    ---pn_nconc := lx_conce;
  
  end sp_tipo_credito_sbs_vig;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_tipo_credito_sbs_vig2(pn_cod   in number,
                                    pn_mod   in number,
                                    pn_suc   in number,
                                    pn_mda   in number,
                                    pn_pap   in number,
                                    pn_cta   in number,
                                    pn_ope   in number,
                                    pn_sbo   in number,
                                    pn_top   in number,
                                    pn_fecha in date,
                                    pn_stat  in number,
                                    pn_fecan in date,
                                    --pn_ufech in date,
                                    pn_usuario in char,
                                    
                                    pn_ntipo out char,
                                    pn_nconc out char) is
  
    lx_fecha date;
    --lx_conce     char(25);
    lx_fecha_ant date;
    pn_ufech     date;
    lx_anio      number(5);
    lx_fecha_dant date;
  
  begin
  
    -- 1. Obtención de Fecha actual
  
    select t.pgfape into lx_fecha from fst017 t where t.pgcod = 1;
  
    -- 2. Obtención última fecha de pago
    begin
      -- Call the function
      pn_ufech := pq_cr_reporte_fond19_p2.fn_fecha_upago(pn_cod   => pn_cod,
                                                         pn_mod   => pn_mod,
                                                         pn_suc   => pn_suc,
                                                         pn_mda   => pn_mda,
                                                         pn_pap   => pn_pap,
                                                         pn_cta   => pn_cta,
                                                         pn_ope   => pn_ope,
                                                         pn_sbo   => pn_sbo,
                                                         pn_top   => pn_top,
                                                         pn_fecha => pn_fecha);
    exception
      when others then
        pn_ufech := null;
    end;
  
    -- 3. Otención de último fin de mes anterior a la última fecha de pago
    if pn_ufech is not null then
      lx_fecha_ant := last_day(add_months(trunc(pn_ufech), -1));
    end if;
  
    -- 4. Obtención del tipo de crédito SBS
    begin
    if pn_stat = 99 then
      begin
        select pn_fecan - 1 into lx_fecha_dant from dual;
        exception when others then
          lx_fecha_dant := null;
      end;
      if (lx_fecha_dant is null) then
         
        pn_ntipo := null;
        pn_nconc := null;
      else
      begin
          -- 1ro. Buscar con la fecha de corte
          select g.tipo, g.nconcepto
            into pn_ntipo, pn_nconc
          
            from (select --t.aqpb070agpo tipo,
                   case
                     when t.bcgpo = 2 then
                      'MIC' --'MICROEMPRESAS'
                     when t.bcgpo = 3 and
                          substr(t.bcrubr, 11, 3) = '015' then
                      'CRE' --'CONSUMO REVOLVENTE'
                     when t.bcgpo = 3 and
                          substr(t.bcrubr, 11, 3) <> '015' then
                      'CNR' --'CONSUMO NO REVOLVENTE'
                     when t.bcgpo = 4 then
                      'HIP' --'HIPOTECARIO'
                   --when t.aqpb070agpo = 12 then
                   -- 'MEDIANA EMPRESA'
                     when t.bcgpo = 13 then
                      'PEQ' --'PEQUEÑA EMPRESA'
                   --when t.aqpb070agpo = 11 then
                   -- 'GRANDES EMPRESAS'
                   --when t.aqpb070agpo in (5, 6, 7, 8, 9, 10) then
                   -- 'CORPORATIVO'
                     else
                      ' '
                   END tipo,
                   case
                     when t.bcgpo = 2 then
                      'MICROEMPRESAS'
                     when t.bcgpo = 3 and
                          substr(t.bcrubr, 11, 3) = '015' then
                      'CONSUMO REVOLVENTE'
                     when t.bcgpo = 3 and
                          substr(t.bcrubr, 11, 3) <> '015' then
                      'CONSUMO NO REVOLVENTE'
                     when t.bcgpo = 4 then
                      'HIPOTECARIO'
                   --when t.aqpb070agpo = 12 then
                   -- 'MEDIANA EMPRESA'
                     when t.bcgpo = 13 then
                      'PEQUEÑA EMPRESA'
                   --when t.aqpb070agpo = 11 then
                   -- 'GRANDES EMPRESAS'
                   --when t.aqpb070agpo in (5, 6, 7, 8, 9, 10) then
                   -- 'CORPORATIVO'
                     else
                      ' '
                   END nconcepto
                  
                    from fsh012 t --- fsd011
                   where t.bcemp = pn_cod
                     and t.bcmod = pn_mod                     
                     and t.bcmda = pn_mda
                     and t.bcpap = pn_pap
                     and t.bccta = pn_cta
                     and t.bcoper = pn_ope
                    
                     and t.bctop = pn_top
                     and t.bcfech = lx_fecha_dant
                  ---order by t.bcfech desc
                  
                  ) g
           where rownum = 1;
        
        exception
          when others then
                pn_ntipo := null;
                pn_nconc := null;

        end;
     
      end if;
    else
      if lx_fecha <> pn_fecha then
      
        begin
          -- 1ro. Buscar con la fecha de corte
          select g.tipo, g.nconcepto
            into pn_ntipo, pn_nconc
          
            from (select --t.aqpb070agpo tipo,
                   case
                     when t.aqpb070agpo = 2 then
                      'MIC' --'MICROEMPRESAS'
                     when t.aqpb070agpo = 3 and
                          substr(t.aqpb070arubr, 11, 3) = '015' then
                      'CRE' --'CONSUMO REVOLVENTE'
                     when t.aqpb070agpo = 3 and
                          substr(t.aqpb070arubr, 11, 3) <> '015' then
                      'CNR' --'CONSUMO NO REVOLVENTE'
                     when t.aqpb070agpo = 4 then
                      'HIP' --'HIPOTECARIO'
                   --when t.aqpb070agpo = 12 then
                   -- 'MEDIANA EMPRESA'
                     when t.aqpb070agpo = 13 then
                      'PEQ' --'PEQUEÑA EMPRESA'
                   --when t.aqpb070agpo = 11 then
                   -- 'GRANDES EMPRESAS'
                   --when t.aqpb070agpo in (5, 6, 7, 8, 9, 10) then
                   -- 'CORPORATIVO'
                     else
                      ' '
                   END tipo,
                   case
                     when t.aqpb070agpo = 2 then
                      'MICROEMPRESAS'
                     when t.aqpb070agpo = 3 and
                          substr(t.aqpb070arubr, 11, 3) = '015' then
                      'CONSUMO REVOLVENTE'
                     when t.aqpb070agpo = 3 and
                          substr(t.aqpb070arubr, 11, 3) <> '015' then
                      'CONSUMO NO REVOLVENTE'
                     when t.aqpb070agpo = 4 then
                      'HIPOTECARIO'
                   --when t.aqpb070agpo = 12 then
                   -- 'MEDIANA EMPRESA'
                     when t.aqpb070agpo = 13 then
                      'PEQUEÑA EMPRESA'
                   --when t.aqpb070agpo = 11 then
                   -- 'GRANDES EMPRESAS'
                   --when t.aqpb070agpo in (5, 6, 7, 8, 9, 10) then
                   -- 'CORPORATIVO'
                     else
                      ' '
                   END nconcepto
                  
                    from aqpb070a t --- fsd011
                   where t.aqpb070ausur = pn_usuario
                     and t.aqpb070aemp = pn_cod
                     and t.aqpb070amod = pn_mod
                     --and t.aqpb070asuc = pn_suc
                     and t.aqpb070amda = pn_mda
                     and t.aqpb070apap = pn_pap
                     and t.aqpb070acta = pn_cta
                     and t.aqpb070aoper = pn_ope
                     --and t.bcsbop = pn_sbo
                     and t.aqpb070atop = pn_top
                     and t.aqpb070afech = pn_fecha
                  ---order by t.bcfech desc
                  
                  ) g
           where rownum = 1;
        
        exception
          when others then
          
            begin
            
              select extract(year from lx_fecha_ant) as anio
                into lx_anio
                from dual;
            
              select --substr(f.harub, 5, 2) scgru
               case
                 when substr(f.harub, 5, 2) = 2 then
                  'MIC' --'MICROEMPRESAS'
                 when substr(f.harub, 5, 2) = 3 and
                      substr(f.harub, 11, 3) = '015' then
                  'CRE' --'CONSUMO REVOLVENTE'
                 when substr(f.harub, 5, 2) = 3 and
                      substr(f.harub, 11, 3) <> '015' then
                  'CNR' --'CONSUMO NO REVOLVENTE'
                 when substr(f.harub, 5, 2) = 4 then
                  'HIP' --'HIPOTECARIO'
               --when substr(f.harub, 5, 2) = 12 then
               -- 'MEDIANA EMPRESA'
                 when substr(f.harub, 5, 2) = 13 then
                  'PEQ' -- 'PEQUEÑA EMPRESA'
               --when substr(f.harub, 5, 2) = 11 then
               -- 'GRANDES EMPRESAS'
               --when substr(f.harub, 5, 2) in (5, 6, 7, 8, 9, 10) then
               -- 'CORPORATIVO'
                 else
                  ' '
               END,
               case
                 when substr(f.harub, 5, 2) = 2 then
                  'MICROEMPRESAS'
                 when substr(f.harub, 5, 2) = 3 and
                      substr(f.harub, 11, 3) = '015' then
                  'CONSUMO REVOLVENTE'
                 when substr(f.harub, 5, 2) = 3 and
                      substr(f.harub, 11, 3) <> '015' then
                  'CONSUMO NO REVOLVENTE'
                 when substr(f.harub, 5, 2) = 4 then
                  'HIPOTECARIO'
               --when substr(f.harub, 5, 2) = 12 then
               -- 'MEDIANA EMPRESA'
                 when substr(f.harub, 5, 2) = 13 then
                  'PEQUEÑA EMPRESA'
               --when substr(f.harub, 5, 2) = 11 then
               -- 'GRANDES EMPRESAS'
               --when substr(f.harub, 5, 2) in (5, 6, 7, 8, 9, 10) then
               -- 'CORPORATIVO'
                 else
                  ' '
               END
                into pn_ntipo, pn_nconc
              
                from fsh014 f
               where f.pgcod = pn_cod
                 and f.HAMOD = pn_mod
                 and f.HACTA = pn_cta
                 and f.HAMDA = pn_mda
                 and f.HAPAP = pn_pap
                 and f.HASUC = pn_suc
                 and f.HAOPER = pn_ope
                 and f.HASBOP = pn_sbo
                 and f.HATOPE = pn_top
                 and f.HAANIO = lx_anio;
            
            exception
              when others then
              
                pn_ntipo := null;
                pn_nconc := null;
              
            end;
          
        end;
      
      else
        begin
          -- 1ro. Buscar en la tabla fsd011
          select --t.scgru
           case
             when t.scgru = 2 then
              'MIC' --'MICROEMPRESAS'
             when t.scgru = 3 and substr(t.scrub, 11, 3) = '015' then
              'CRE' --'CONSUMO REVOLVENTE'
             when t.scgru = 3 and substr(t.scrub, 11, 3) <> '015' then
              'CNR' --'CONSUMO NO REVOLVENTE'
             when t.scgru = 4 then
              'HIP' --'HIPOTECARIO'
           --when t.scgru = 12 then
           -- 'MEDIANA EMPRESA'
             when t.scgru = 13 then
              'PEQ' --'PEQUEÑA EMPRESA'
           --when t.scgru = 11 then
           -- 'GRANDES EMPRESAS'
           --when t.scgru in (5, 6, 7, 8, 9, 10) then
           -- 'CORPORATIVO'
             else
              ' '
           END scgru,
           case
             when t.scgru = 2 then
              'MICROEMPRESAS'
             when t.scgru = 3 and substr(t.scrub, 11, 3) = '015' then
              'CONSUMO REVOLVENTE'
             when t.scgru = 3 and substr(t.scrub, 11, 3) <> '015' then
              'CONSUMO NO REVOLVENTE'
             when t.scgru = 4 then
              'HIPOTECARIO'
           --when t.scgru = 12 then
           -- 'MEDIANA EMPRESA'
             when t.scgru = 13 then
              'PEQUEÑA EMPRESA'
           --when t.scgru = 11 then
           -- 'GRANDES EMPRESAS'
           --when t.scgru in (5, 6, 7, 8, 9, 10) then
           -- 'CORPORATIVO'
             else
              ' '
           END
            into pn_ntipo, pn_nconc
            from fsd011 t
           where t.pgcod = pn_cod
             and t.scmod = pn_mod
             --and t.scsuc = pn_suc
             and t.scmda = pn_mda
             and t.scpap = pn_pap
             and t.sccta = pn_cta
             and t.scoper = pn_ope
             --and t.scsbop = pn_sbo
             and t.sctope = pn_top
             and rownum = 1;
        
        exception
          when others then
          
            begin
            
              select extract(year from lx_fecha_ant) as anio
                into lx_anio
                from dual;
            
              select --substr(f.harub, 5, 2) scgru
               case
                 when substr(f.harub, 5, 2) = 2 then
                  'MIC' --'MICROEMPRESAS'
                 when substr(f.harub, 5, 2) = 3 and
                      substr(f.harub, 11, 3) = '015' then
                  'CRE' --'CONSUMO REVOLVENTE'
                 when substr(f.harub, 5, 2) = 3 and
                      substr(f.harub, 11, 3) <> '015' then
                  'CNR' --'CONSUMO NO REVOLVENTE'
                 when substr(f.harub, 5, 2) = 4 then
                  'HIP' --'HIPOTECARIO'
               --when substr(f.harub, 5, 2) = 12 then
               -- 'MEDIANA EMPRESA'
                 when substr(f.harub, 5, 2) = 13 then
                  'PEQ' -- 'PEQUEÑA EMPRESA'
               --when substr(f.harub, 5, 2) = 11 then
               -- 'GRANDES EMPRESAS'
               --when substr(f.harub, 5, 2) in (5, 6, 7, 8, 9, 10) then
               -- 'CORPORATIVO'
                 else
                  ' '
               END scgru,
               case
                 when substr(f.harub, 5, 2) = 2 then
                  'MICROEMPRESAS'
                 when substr(f.harub, 5, 2) = 3 and
                      substr(f.harub, 11, 3) = '015' then
                  'CONSUMO REVOLVENTE'
                 when substr(f.harub, 5, 2) = 3 and
                      substr(f.harub, 11, 3) <> '015' then
                  'CONSUMO NO REVOLVENTE'
                 when substr(f.harub, 5, 2) = 4 then
                  'HIPOTECARIO'
               --when substr(f.harub, 5, 2) = 12 then
               -- 'MEDIANA EMPRESA'
                 when substr(f.harub, 5, 2) = 13 then
                  'PEQUEÑA EMPRESA'
               --when substr(f.harub, 5, 2) = 11 then
               -- 'GRANDES EMPRESAS'
               --when substr(f.harub, 5, 2) in (5, 6, 7, 8, 9, 10) then
               -- 'CORPORATIVO'
                 else
                  ' '
               END
                into pn_ntipo, pn_nconc
              
                from fsh014 f
               where f.pgcod = pn_cod
                 and f.HAMOD = pn_mod
                 and f.HACTA = pn_cta
                 and f.HAMDA = pn_mda
                 and f.HAPAP = pn_pap
                 and f.HASUC = pn_suc
                 and f.HAOPER = pn_ope
                 and f.HASBOP = pn_sbo
                 and f.HATOPE = pn_top
                 and f.HAANIO = lx_anio;
            
            exception
              when others then
              
                pn_ntipo := null;
                pn_nconc := null;
              
            end;
          
        end;
      
      end if;
    end if;
    exception
      when others then
        pn_ntipo := null;
        pn_nconc := null;
      
    end;
  
    ---pn_nconc := lx_conce;
  
  end sp_tipo_credito_sbs_vig2;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_tipo_credito_fst004(pn_cod   in number,
                                    pn_mod   in number,
                                    pn_suc   in number,
                                    pn_mda   in number,
                                    pn_pap   in number,
                                    pn_cta   in number,
                                    pn_ope   in number,
                                    pn_sbo   in number,
                                    pn_top   in number,
                                    pn_fecha in date,
                                    --pn_ufech in date,
                                    pn_usuario in char,
                                    pn_nconc out char) is
  
    
  
  begin
  
    begin
      select tonom into pn_nconc from fst004 where modulo = pn_mod and totope = pn_top;
    end;
  
  end sp_tipo_credito_fst004;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  

  function fn_fecha_upago(pn_cod   in number,
                          pn_mod   in number,
                          pn_suc   in number,
                          pn_mda   in number,
                          pn_pap   in number,
                          pn_cta   in number,
                          pn_ope   in number,
                          pn_sbo   in number,
                          pn_top   in number,
                          pn_fecha in date) return date is
  
    lx_fpago date;
  
  begin
  
    begin
    
      SELECT
      
       max(t.d602fc)
        into lx_fpago
        FROM FSD602 t
       where t.pgcod = pn_cod
         and t.ppmod = pn_mod
         and t.ppsuc = pn_suc
         and t.ppmda = pn_mda
         and t.pppap = pn_pap
         and t.ppcta = pn_cta
         and t.ppoper = pn_ope
         and t.ppsbop = pn_sbo
         and t.pptope = pn_top
         and t.pp1stat = 'T'
         and t.d602co = 'S'
         and t.d602fc <= pn_fecha;
    exception
      when others then
        lx_fpago := null;
    end;
  
    return lx_fpago;
  
  end fn_fecha_upago;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
 
  procedure sp_obtener_actuales(pn_cod   in number,
                                pn_mod   in number,
                                pn_suc   in number,
                                pn_mda   in number,
                                pn_pap   in number,
                                pn_cta   in number,
                                pn_ope   in number,
                                pn_sbo   in number,
                                pn_top   in number,
                                pn_fecha in date,
                                pn_fini  out date,
                                pn_ffin  out date) is
  
    --lx_fdes date;
    lx_contar  number(3);
    lx_fec_sig date;
    lx_nro_sig number(9);
  
  begin
  
    --- fecha de reprogramación
    /*
    begin
    
      select max(x.jaqa400fec)
        into pn_fini
        from jaqa400 x
       where x.jaqa400emp = pn_cod
         and x.jaqa400mod = pn_mod
         and x.jaqa400suc = pn_suc
         and x.jaqa400mda = pn_mda
         and x.jaqa400pap = pn_pap
         and x.jaqa400cta = pn_cta
         and x.jaqa400ope = pn_ope
         -- and x.jaqa400sbo = pn_sbo
         and x.jaqa400top = pn_top
         and x.jaqa400fec <= pn_fecha
         --and x.jaqa400ac1 in ('U', 'C') -- jrodriguej 14.07.2021
         and x.jaqa400est in ('C', 'V');
    
    exception
      when others then
      
        pn_fini := null;
      
    end;
    */    
    
    begin
      -- Call the function
      pn_fini := pq_cr_reporte_fond19_p2.fn_max_frep(pn_cod => pn_cod,
                                                     pn_mod => pn_mod,
                                                     pn_suc => pn_suc,
                                                     pn_mda => pn_mda,
                                                     pn_pap => pn_pap,
                                                     pn_cta => pn_cta,
                                                     pn_ope => pn_ope,
                                                     pn_sbo => pn_sbo,
                                                     pn_top => pn_top,
                                                     pn_fecha => pn_fecha);
    exception
      when others then
      
        pn_fini := null;                                                     
    end;
    
  
    -- Verificar si luego de la fecha de reprog. hay otra reprogramación
    begin
      -- Call the procedure
      pq_cr_reporte_fond19_p2.sp_siguiente_creditopk(pn_cod     => pn_cod,
                                                     pn_mod     => pn_mod,
                                                     pn_suc     => pn_suc,
                                                     pn_mda     => pn_mda,
                                                     pn_pap     => pn_pap,
                                                     pn_cta     => pn_cta,
                                                     pn_ope     => pn_ope,
                                                     pn_sbo     => pn_sbo,
                                                     pn_top     => pn_top,
                                                     pn_fecha   => pn_fecha,
                                                     pn_fec_rep => lx_fec_sig,
                                                     pn_cor_rep => lx_nro_sig);
    exception
      when others then
        lx_fec_sig := null;
        lx_nro_sig := 0;
    end;
  
    --- fecha de vencimiento
  
    if lx_fec_sig is not null then
    
      begin
      
        select max(x.ppfvto)
          into pn_ffin
          from aqpb088_601c x
         where x.pgcod = pn_cod
           and x.ppmod = pn_mod
           --and x.ppsuc = pn_suc
           and x.ppmda = pn_mda
           and x.pppap = pn_pap
           and x.ppcta = pn_cta
           and x.ppoper = pn_ope
           --and x.ppsbop = pn_sbo
           and x.pptope = pn_top
           and x.fec = lx_fec_sig
           and x.cor = lx_nro_sig;
      
      exception
        when others then
        
          pn_ffin := null;
        
      end;
    else
      begin
      
        select /*+FSD60103*/ max(x.ppfvto)
          into pn_ffin
          from fsd601 x
         where x.pgcod = pn_cod
           and x.ppmod = pn_mod
           --and x.ppsuc = pn_suc
           and x.ppmda = pn_mda
           and x.pppap = pn_pap
           and x.ppcta = pn_cta
           and x.ppoper = pn_ope
           --and x.ppsbop = pn_sbo
           and x.pptope = pn_top;
      
      exception
        when others then
        
          pn_ffin := null;
        
      end;
    
    end if;
  
  end sp_obtener_actuales;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --          
  procedure sp_obtener_sald_insol2(pn_cod   in number,
                                   pn_mod   in number,
                                   pn_suc   in number,
                                   pn_mda   in number,
                                   pn_pap   in number,
                                   pn_cta   in number,
                                   pn_ope   in number,
                                   pn_sbo   in number,
                                   pn_top   in number,
                                   pn_fecha in date,
                                   pn_indi  in number,
                                   pn_stat  in number,
                                   pn_sald  out number) -- saldo insoluto
   is
    -- Saldo insoluto = monto_cofide - sumatorio de pagos
    -- pn_indi = 1 -----> REACTIVA
    -- pn_indi = 2 -----> FAE
    -- pn_indi = 3 -----> CRECER
  
    lx_mcof number(10, 2);
    lx_scap number(17, 2);
    lx_fdes date;
    lc_canc char(1);
    lx_fdia date;
    lx_mext number(17, 2);
  
  begin
  
    select x.pgfape into lx_fdia from fst017 x where x.pgcod = 1;
    --validar estado de credito y trx para determinar si es 30/360
    lc_canc := 'N';
  
    begin
    
      select 'S'
        into lc_canc
        from fsd602 t
       where t.pgcod = pn_cod
         and t.ppmod = pn_mod
            --and t.ppsuc = pn_suc --  jrodriguej 28.06.2021
         and t.ppsuc in (select p.sucurs
                           from fst001 p
                          where p.pgcod = 1
                            and p.sucurs < 800)
         and t.ppmda = pn_mda
         and t.pppap = pn_pap
         and t.ppcta = pn_cta
         and t.ppoper = pn_ope
            -- and t.ppsbop = pn_sbo
            -- and t.pptope = pn_top
         and t.pp1stat in ('P', 'T')
         and t.pp1cap > 0
         and (t.d602mo, t.d602tr) in
             (select x.tp1nro1, x.tp1nro2
                from fst198 x
               where x.TP1COD = 1
                 and x.TP1COD1 = 11144
                 and x.TP1CORR1 = 1
                 and x.tp1corr2 = 4 --flag determina si trx se pertenece a cancelacion
                 and x.tp1corr3 > 0)
         and t.d602fc >= lx_fdes
         and t.d602fc <= pn_fecha
         and t.d602co = 'S';
    
    exception
      when others then
        lc_canc := 'N';
    end;
  
    if lc_canc = 'S' then
      pn_sald := 0;
    
    else
      -- a) monto COFIDE
      case
        when pn_indi = 4 then
          -- COVID19
        
          begin
          
            select x.aqpb095bfdes, x.aqpb095bmon
              into lx_fdes, lx_mcof
              from aqpb095b x
             where x.aqpb095bcod = pn_cod
               --and x.aqpb095bmod = pn_mod
                  --and x.aqpb095bsuc = pn_suc
               and x.aqpb095bmda = pn_mda
               and x.aqpb095bpap = pn_pap
               and x.aqpb095bcta = pn_cta
               and x.aqpb095bope = pn_ope
                  -- and x.aqpb065bsbo = pn_sbo
                  -- and x.aqpb065btop = pn_top
               and x.aqpb095bfec <= pn_fecha
               and x.aqpb095best <> 'D';
          
          exception
            when too_many_rows then
            
              begin
              
                select f.aqpb095bfdes, f.aqpb095bmon
                  into lx_fdes, lx_mcof
                  from (select x.aqpb095bfdes, x.aqpb095bmon
                          from aqpb095b x
                         where x.aqpb095bcod = pn_cod
                           --and x.aqpb095bmod = pn_mod
                              --and x.aqpb095bsuc = pn_suc
                           and x.aqpb095bmda = pn_mda
                           and x.aqpb095bpap = pn_pap
                           and x.aqpb095bcta = pn_cta
                           and x.aqpb095bope = pn_ope
                              -- and x.aqpb065bsbo = pn_sbo
                              -- and x.aqpb065btop = pn_top
                           and x.aqpb095bfec <= pn_fecha
                           and x.aqpb095best <> 'D'
                         order by x.aqpb095bfec desc) f
                 where rownum = 1;
              
              exception
                when others then
                  lx_fdes := null;
                  lx_mcof := 0;
              end;
            
            when others then
              lx_fdes := null;
          end;
        
      end case;
    
      --- b) Sumatoria de pagos
      --- Capital
      if lx_mcof <> 0 and pn_fecha >= lx_fdes then
        begin
        
          select nvl(sum(t.pp1cap), 0) --, nvl(sum(t.pp1int), 0)
            into lx_scap
          
            from fsd602 t
           where t.pgcod = pn_cod
             and t.ppmod = pn_mod
                --and t.ppsuc = pn_suc
             and t.ppmda = pn_mda
             and t.pppap = pn_pap
             and t.ppcta = pn_cta
             and t.ppoper = pn_ope
                -- and t.ppsbop = pn_sbo
                -- and t.pptope = pn_top
             and t.pp1stat in ('P', 'T')
             and t.pp1cap > 0
             and (t.d602mo, t.d602tr) in
                 (select x.tp1nro1, x.tp1nro2
                    from fst198 x
                   where x.TP1COD = 1
                     and x.TP1COD1 = 11144
                     and x.TP1CORR1 = 1
                     and x.tp1corr2 = 3
                     and x.tp1corr3 > 0)
             and t.d602fc >= lx_fdes
             and t.d602fc <= pn_fecha
             and t.d602co = 'S';
        
        exception
          when others then
            lx_scap := 0;
        end;
      
        if lx_fdia <> pn_fecha then
        
          begin
            select nvl(x.HCIMP1, 0) --,  x.* 
              into lx_mext
              from fsh016 x, fsh015 t
             where x.PGCOD = t.pgcod
               and x.HCMOD = t.hcmod
               and x.HSUCOR = t.hsucor
               and x.HTRAN = t.htran
               and x.HNREL = t.hnrel
               and x.HFCON = t.hfcon
               and x.PGCOD = pn_cod
               and x.HMODUL = pn_mod
               and x.HSUCUR = pn_suc
               and x.HMDA = pn_mda
               and x.HPAP = pn_pap
               and x.HCTA = pn_cta
               and x.HOPER = pn_ope
               and x.HSUBOP = pn_sbo
               and x.HTOPER = pn_top
               and --- HRUBRO: 1411, 1421, 1414, 1424, 1415,1425,1416, 1426
                   substr(x.HRUBRO, 1, 4) in
                   (1411, 1421, 1414, 1424, 1415, 1425, 1416, 1426)
               and x.HFCON > pn_fecha
               and x.HFVAL <= pn_fecha
               and (x.HCMOD, x.HTRAN) in
                   (select f.tp1nro1 + 500, f.tp1nro2 --obtener trx extornos
                      from fst198 f
                     where f.TP1COD = 1
                       and f.TP1COD1 = 11144
                       and f.TP1CORR1 = 1
                       and f.tp1corr2 = 3
                       and f.tp1corr3 > 0);
          exception
            when others then
              lx_mext := 0;
          end;
        
        else
          lx_mext := 0;
        end if;
      
        lx_scap := lx_scap + lx_mext;
      
      else
        lx_scap := 0;
      end if;
    
      if lx_mcof is null then
        lx_mcof := 0;
      end if;
    
      --- c) Resultado
      pn_sald := lx_mcof - lx_scap;
    
      if pn_sald < 0 then
        pn_sald := 0;
      end if;
    
    end if;
  
    -- Verificación de estado del crédito
    if pn_stat = 99 then
      pn_sald := 0;
    end if;
  
  end sp_obtener_sald_insol2;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_obtener_tasa_actual(pn_cod   in number,
                                   pn_mod   in number,
                                   pn_suc   in number,
                                   pn_mda   in number,
                                   pn_pap   in number,
                                   pn_cta   in number,
                                   pn_ope   in number,
                                   pn_sbo   in number,
                                   pn_top   in number,
                                   pn_fecha in date,
                                   pn_tasa  out number) is
  
    lx_fec_sig date;
    lx_nro_sig number(9);
  
  begin
  
    -- Verificar si luego de la fecha de reprog. hay otra reprogramación
    begin
      -- Call the procedure
      pq_cr_reporte_fond19_p2.sp_siguiente_creditopk(pn_cod     => pn_cod,
                                                     pn_mod     => pn_mod,
                                                     pn_suc     => pn_suc,
                                                     pn_mda     => pn_mda,
                                                     pn_pap     => pn_pap,
                                                     pn_cta     => pn_cta,
                                                     pn_ope     => pn_ope,
                                                     pn_sbo     => pn_sbo,
                                                     pn_top     => pn_top,
                                                     pn_fecha   => pn_fecha,
                                                     pn_fec_rep => lx_fec_sig,
                                                     pn_cor_rep => lx_nro_sig);
    exception
      when others then
        lx_fec_sig := null;
        lx_nro_sig := 0;
    end;
  
    -- Obtención de Tasa
    if lx_fec_sig is not null then
    
      begin
      
        select f1.evtasa
          into pn_tasa
          from aqpb088_012c f1
         where f1.pgcod = pn_cod
           and f1.aomod = pn_mod
           and f1.aosuc = pn_suc
           and f1.aomda = pn_mda
           and f1.aopap = pn_pap
           and f1.aocta = pn_cta
           and f1.aooper = pn_ope
           and f1.aosbop = pn_sbo
           and f1.aotope = pn_top
           and f1.evtipo = 3
           and f1.d012co = 'S'
           and f1.fec = lx_fec_sig
           and f1.cor = lx_nro_sig
           and f1.evcorr in (select max(f2.evcorr)
                               from aqpb088_012c f2
                              where f2.pgcod = f1.pgcod
                                and f2.aomod = f1.aomod
                                and f2.aosuc = f1.aosuc
                                and f2.aomda = f1.aomda
                                and f2.aopap = f1.aopap
                                and f2.aocta = f1.aocta
                                and f2.aooper = f1.aooper
                                and f2.aosbop = f1.aosbop
                                and f2.aotope = f1.aotope
                                and f2.evtipo = 3
                                and f2.d012co = 'S'
                                and f2.fec = f1.fec
                                and f2.cor = f1.cor
                                and f2.evfval < pn_fecha --lx_fec_sig --pn_fecha
                             );
      
      exception
        when others then
          ---lx_fdes := null;
        
          begin
          
            SELECT t.aotasa
              into pn_tasa
              FROM aqpb088_010c t
             where t.pgcod = pn_cod
               and t.aomod = pn_mod
               and t.aosuc = pn_suc
               and t.aomda = pn_mda
               and t.aopap = pn_pap
               and t.aocta = pn_cta
               and t.aooper = pn_ope
               and t.aosbop = pn_sbo
               and t.aotope = pn_top
               and t.fec = lx_fec_sig
               and t.cor = lx_nro_sig;
          
          exception
            when others then
              pn_tasa := 0;
          end;
        
      end;
    
    else
    
      begin
      
        select f1.evtasa
          into pn_tasa
          from fsd012 f1
         where f1.pgcod = pn_cod
           and f1.aomod = pn_mod
           and f1.aosuc = pn_suc
           and f1.aomda = pn_mda
           and f1.aopap = pn_pap
           and f1.aocta = pn_cta
           and f1.aooper = pn_ope
           and f1.aosbop = pn_sbo
           and f1.aotope = pn_top
           and f1.evtipo = 3
           and f1.d012co = 'S'
           and f1.evcorr in (select max(f2.evcorr)
                               from fsd012 f2
                              where f2.pgcod = f1.pgcod
                                and f2.aomod = f1.aomod
                                and f2.aosuc = f1.aosuc
                                and f2.aomda = f1.aomda
                                and f2.aopap = f1.aopap
                                and f2.aocta = f1.aocta
                                and f2.aooper = f1.aooper
                                and f2.aosbop = f1.aosbop
                                and f2.aotope = f1.aotope
                                and f2.evtipo = 3
                                and f2.d012co = 'S'
                                and f2.evfval < pn_fecha);
      
      exception
        when others then
          ---lx_fdes := null;
        
          begin
          
            SELECT t.aotasa
              into pn_tasa
              FROM fsd010 t
             where t.pgcod = pn_cod
               and t.aomod = pn_mod
               and t.aosuc = pn_suc
               and t.aomda = pn_mda
               and t.aopap = pn_pap
               and t.aocta = pn_cta
               and t.aooper = pn_ope
               and t.aosbop = pn_sbo
               and t.aotope = pn_top;
          
          exception
            when others then
              pn_tasa := 0;
          end;
        
      end;
    
    end if;
  
  end sp_obtener_tasa_actual;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_obtener_tcredito(pn_cod     in number,
                                pn_mod     in number,
                                pn_suc     in number,
                                pn_mda     in number,
                                pn_pap     in number,
                                pn_cta     in number,
                                pn_ope     in number,
                                pn_sbo     in number,
                                pn_top     in number,
                                pn_fecha   in date,
                                pn_usuario in char,
                                pn_tip     out char) is
  
    lx_fecha     date;
    lc_rub1      number(3);
    lc_rub2      number(3);
    lx_fecha_ant date;
    pn_ufech     date;
    lx_anio      number(5);
  
  begin
  
    begin
      select f.pgfape into lx_fecha from fst017 f where f.pgcod = 1;
    exception
      when others then
        lx_fecha := null;
    end;
  
    --- Evaluación
    pn_tip := '';
    if pn_mod = 112 then
      begin
        --vehiculares: mod 112          
        pn_tip := 'VEH';
      end;
    else
    
      begin
      
        -- 2. Obtención última fecha de pago
        begin
          -- Call the function
          pn_ufech := pq_cr_reporte_fondos_p3.fn_fecha_upago(pn_cod   => pn_cod,
                                                             pn_mod   => pn_mod,
                                                             pn_suc   => pn_suc,
                                                             pn_mda   => pn_mda,
                                                             pn_pap   => pn_pap,
                                                             pn_cta   => pn_cta,
                                                             pn_ope   => pn_ope,
                                                             pn_sbo   => pn_sbo,
                                                             pn_top   => pn_top,
                                                             pn_fecha => pn_fecha);
        exception
          when others then
            pn_ufech := null;
        end;
      
        -- 3. Otención de último fin de mes anterior a la última fecha de pago
        if pn_ufech is not null then
          lx_fecha_ant := last_day(add_months(trunc(pn_ufech), -1));
        end if;
      
        if lx_fecha = pn_fecha then
        
          begin
          
            -- 1ro. Buscar en la tabla fsd011
            select distinct t.scgru
              into lc_rub1
              from fsd011 t
             where t.pgcod = pn_cod
               and t.scmod = pn_mod
               --and t.scsuc = pn_suc
               and t.scmda = pn_mda
               and t.scpap = pn_pap
               and t.sccta = pn_cta
               and t.scoper = pn_ope
                  --and t.scsbop = pn_sbo
               and t.sctope = pn_top
               and rownum = 1;
          
          exception
            when others then
             if lx_fecha_ant is null then
               lx_fecha_ant := pn_fecha;
             end if;
              begin
              
                select extract(year from lx_fecha_ant) as anio
                  into lx_anio
                  from dual;
              
                select to_number(substr(f.harub, 5, 2))
                  into lc_rub1
                  from fsh014 f
                 where f.pgcod = pn_cod
                   and f.HAMOD = pn_mod
                   and f.HACTA = pn_cta
                   and f.HAMDA = pn_mda
                   and f.HAPAP = pn_pap
                   and f.HASUC = pn_suc
                   and f.HAOPER = pn_ope
                   and f.HASBOP = pn_sbo
                   --and f.HATOPE = pn_top
                   and f.HAANIO = lx_anio
                   and rownum = 1;
              
              exception
                when no_data_found then
                  begin
                    select extract(year from add_months(lx_fecha_ant,-12)) as anio
                      into lx_anio
                      from dual;
                  
                    select to_number(substr(f.harub, 5, 2))
                      into lc_rub1
                      from fsh014 f
                     where f.pgcod = pn_cod
                       and f.HAMOD = pn_mod
                       and f.HACTA = pn_cta
                       and f.HAMDA = pn_mda
                       and f.HAPAP = pn_pap
                       and f.HASUC = pn_suc
                       and f.HAOPER = pn_ope
                       and f.HASBOP = pn_sbo
                       --and f.HATOPE = pn_top
                       and f.HAANIO = lx_anio
                       and rownum = 1;
                  exception
                    when no_data_found then
                      begin
                        select extract(year from add_months(lx_fecha_ant,-24)) as anio
                          into lx_anio
                          from dual;
                      
                        select to_number(substr(f.harub, 5, 2))
                          into lc_rub1
                          from fsh014 f
                         where f.pgcod = pn_cod
                           and f.HAMOD = pn_mod
                           and f.HACTA = pn_cta
                           and f.HAMDA = pn_mda
                           and f.HAPAP = pn_pap
                           and f.HASUC = pn_suc
                           and f.HAOPER = pn_ope
                           and f.HASBOP = pn_sbo
                           --and f.HATOPE = pn_top
                           and f.HAANIO = lx_anio
                           and rownum = 1;
                      exception
                        when others then                
                             lc_rub1 := null;
                      end;
                    when others then                
                         lc_rub1 := null;
                  end;
                
                when others then
                
                  lc_rub1 := null;
                
              end;
            
          end;
        
        else
        
          begin
          
            select g.tipo
              into lc_rub1
              from (select distinct t.aqpb070agpo tipo
                      from aqpb070a t --- fsd011
                     where t.aqpb070ausur = pn_usuario
                       and t.aqpb070aemp = pn_cod
                       and t.aqpb070amod = pn_mod
                       --and t.aqpb070asuc = pn_suc
                       and t.aqpb070amda = pn_mda
                       and t.aqpb070apap = pn_pap
                       and t.aqpb070acta = pn_cta
                       and t.aqpb070aoper = pn_ope
                          --and t.bcsbop = pn_sbo
                       and t.aqpb070atop = pn_top
                       and t.aqpb070afech = pn_fecha
                       and t.aqpb070asdmn <> 0) g;
          
          exception            
            when others then
              if lx_fecha_ant is null then
                lx_fecha_ant := pn_fecha;
              end if;
              begin
              
                select extract(year from lx_fecha_ant) as anio
                  into lx_anio
                  from dual;
              
                select to_number(substr(f.harub, 5, 2))
                  into lc_rub1
                  from fsh014 f
                 where f.pgcod = pn_cod
                   and f.HAMOD = pn_mod
                   and f.HACTA = pn_cta
                   and f.HAMDA = pn_mda
                   and f.HAPAP = pn_pap
                   and f.HASUC = pn_suc
                   and f.HAOPER = pn_ope
                   and f.HASBOP = pn_sbo
                   --and f.HATOPE = pn_top
                   and f.HAANIO = lx_anio
                   and rownum = 1;
              
              exception
                when no_data_found then
                  begin
                    select extract(year from add_months(lx_fecha_ant,-12)) as anio
                      into lx_anio
                      from dual;
                  
                    select to_number(substr(f.harub, 5, 2))
                      into lc_rub1
                      from fsh014 f
                     where f.pgcod = pn_cod
                       and f.HAMOD = pn_mod
                       and f.HACTA = pn_cta
                       and f.HAMDA = pn_mda
                       and f.HAPAP = pn_pap
                       and f.HASUC = pn_suc
                       and f.HAOPER = pn_ope
                       and f.HASBOP = pn_sbo
                       --and f.HATOPE = pn_top
                       and f.HAANIO = lx_anio
                       and rownum = 1;
                  exception
                    when no_data_found then
                      begin
                        select extract(year from add_months(lx_fecha_ant,-24)) as anio
                          into lx_anio
                          from dual;
                      
                        select to_number(substr(f.harub, 5, 2))
                          into lc_rub1
                          from fsh014 f
                         where f.pgcod = pn_cod
                           and f.HAMOD = pn_mod
                           and f.HACTA = pn_cta
                           and f.HAMDA = pn_mda
                           and f.HAPAP = pn_pap
                           and f.HASUC = pn_suc
                           and f.HAOPER = pn_ope
                           and f.HASBOP = pn_sbo
                           --and f.HATOPE = pn_top
                           and f.HAANIO = lx_anio
                           and rownum = 1;
                      exception
                        when others then                
                             lc_rub1 := null;
                      end;
                    when others then                
                         lc_rub1 := null;
                  end;
                when others then
                
                  lc_rub1 := null;
                
              end;
            
          end;
        
        end if;
      
        ---
        --pn_tip := '';
        if lc_rub1 is not null then
          begin
            case
              when lc_rub1 in (2, 12, 11, 13) then
                -- 2: MicroEmpresas, 12: Mediana Empresa, 11: Grandes Empresas, 13: Pequeña Empresa
                pn_tip := 'MYP';
              
              when lc_rub1 = 3 then
                -- Créditos de consumo y personales
                pn_tip := 'CCP';
              
              when lc_rub1 = 4 then
                -- Hipotecario
                pn_tip := 'HIP';
              
              else
              
                pn_tip := '';
              
            end case;
          exception
            when others then
            
              pn_tip := '';
            
          end;
        end if;
      
      end;
    end if;
  
    ---
  
  end sp_obtener_tcredito;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_obtener_tcredito2(pn_cod     in number,
                                pn_mod     in number,
                                pn_suc     in number,
                                pn_mda     in number,
                                pn_pap     in number,
                                pn_cta     in number,
                                pn_ope     in number,
                                pn_sbo     in number,
                                pn_top     in number,
                                pn_fecha   in date,
                                pn_stat    in number,
                                pn_fecan   in date,
                                pn_usuario in char,
                                pn_tip     out char) is
  
    lx_fecha     date;
    lc_rub1      number(3);
    lc_rub2      number(3);
    lx_fecha_ant date;
    lx_fecha_dant date;
    pn_ufech     date;
    lx_anio      number(5);
  
  begin
  
    begin
      select f.pgfape into lx_fecha from fst017 f where f.pgcod = 1;
    exception
      when others then
        lx_fecha := null;
    end;
  
    --- Evaluación
    pn_tip := '';
    if pn_mod = 112 then
      begin
        --vehiculares: mod 112          
        pn_tip := 'VEH';
      end;
    else
      if pn_stat = 99 then
        begin
        select pn_fecan - 1 into lx_fecha_dant from dual;
        exception when others then
          lx_fecha_dant := null;
        end;
        if (lx_fecha_dant is null) then
          lc_rub1 := '';
        else
        begin
          select g.tipo
              into lc_rub1
              from (select distinct t.bcgpo tipo
                      from fsh012 t --- fsd011
                     where t.bcemp = pn_cod
                       and t.bcmod = pn_mod
                       
                       and t.bcmda = pn_mda
                       and t.bcpap = pn_pap
                       and t.bccta = pn_cta
                       and t.bcoper = pn_ope
                        
                       and t.bctop = pn_top
                       and t.bcfech = lx_fecha_dant
                       and t.bcsdmn <> 0) g;
        exception when others then
          lc_rub1 := '';
        end; 
        end if;
         if lc_rub1 is not null then
          begin
            case
              when lc_rub1 in (2, 12, 11, 13) then
                -- 2: MicroEmpresas, 12: Mediana Empresa, 11: Grandes Empresas, 13: Pequeña Empresa
                pn_tip := 'MYP';
              
              when lc_rub1 = 3 then
                -- Créditos de consumo y personales
                pn_tip := 'CCP';
              
              when lc_rub1 = 4 then
                -- Hipotecario
                pn_tip := 'HIP';
              
              else
              
                pn_tip := '';
              
            end case;
          exception
            when others then
            
              pn_tip := '';
            
          end;
        end if;
      
      else
      begin
      
        -- 2. Obtención última fecha de pago
        begin
          -- Call the function
          pn_ufech := pq_cr_reporte_fondos_p3.fn_fecha_upago(pn_cod   => pn_cod,
                                                             pn_mod   => pn_mod,
                                                             pn_suc   => pn_suc,
                                                             pn_mda   => pn_mda,
                                                             pn_pap   => pn_pap,
                                                             pn_cta   => pn_cta,
                                                             pn_ope   => pn_ope,
                                                             pn_sbo   => pn_sbo,
                                                             pn_top   => pn_top,
                                                             pn_fecha => pn_fecha);
        exception
          when others then
            pn_ufech := null;
        end;
      
        -- 3. Otención de último fin de mes anterior a la última fecha de pago
        if pn_ufech is not null then
          lx_fecha_ant := last_day(add_months(trunc(pn_ufech), -1));
        end if;
      
        if lx_fecha = pn_fecha then
        
          begin
          
            -- 1ro. Buscar en la tabla fsd011
            select distinct t.scgru
              into lc_rub1
              from fsd011 t
             where t.pgcod = pn_cod
               and t.scmod = pn_mod
               --and t.scsuc = pn_suc
               and t.scmda = pn_mda
               and t.scpap = pn_pap
               and t.sccta = pn_cta
               and t.scoper = pn_ope
                  --and t.scsbop = pn_sbo
               and t.sctope = pn_top
               and rownum = 1;
          
          exception
            when others then
            
              begin
              
                select extract(year from lx_fecha_ant) as anio
                  into lx_anio
                  from dual;
              
                select to_number(substr(f.harub, 5, 2))
                  into lc_rub1
                  from fsh014 f
                 where f.pgcod = pn_cod
                   and f.HAMOD = pn_mod
                   and f.HACTA = pn_cta
                   and f.HAMDA = pn_mda
                   and f.HAPAP = pn_pap
                   and f.HASUC = pn_suc
                   and f.HAOPER = pn_ope
                   and f.HASBOP = pn_sbo
                   and f.HATOPE = pn_top
                   and f.HAANIO = lx_anio;
              
              exception
                when others then
                
                  lc_rub1 := null;
                
              end;
            
          end;
        
        else
        
          begin
          
            select g.tipo
              into lc_rub1
              from (select distinct t.aqpb070agpo tipo
                      from aqpb070a t --- fsd011
                     where t.aqpb070ausur = pn_usuario
                       and t.aqpb070aemp = pn_cod
                       and t.aqpb070amod = pn_mod
                       --and t.aqpb070asuc = pn_suc
                       and t.aqpb070amda = pn_mda
                       and t.aqpb070apap = pn_pap
                       and t.aqpb070acta = pn_cta
                       and t.aqpb070aoper = pn_ope
                          --and t.bcsbop = pn_sbo
                       and t.aqpb070atop = pn_top
                       and t.aqpb070afech = pn_fecha
                       and t.aqpb070asdmn <> 0) g;
          
          exception
            when others then
            
              begin
              
                select extract(year from lx_fecha_ant) as anio
                  into lx_anio
                  from dual;
              
                select to_number(substr(f.harub, 5, 2))
                  into lc_rub1
                  from fsh014 f
                 where f.pgcod = pn_cod
                   and f.HAMOD = pn_mod
                   and f.HACTA = pn_cta
                   and f.HAMDA = pn_mda
                   and f.HAPAP = pn_pap
                   and f.HASUC = pn_suc
                   and f.HAOPER = pn_ope
                   and f.HASBOP = pn_sbo
                   and f.HATOPE = pn_top
                   and f.HAANIO = lx_anio;
              
              exception
                when others then
                
                  lc_rub1 := null;
                
              end;
            
          end;
        
        end if;
      
        ---
        --pn_tip := '';
        if lc_rub1 is not null then
          begin
            case
              when lc_rub1 in (2, 12, 11, 13) then
                -- 2: MicroEmpresas, 12: Mediana Empresa, 11: Grandes Empresas, 13: Pequeña Empresa
                pn_tip := 'MYP';
              
              when lc_rub1 = 3 then
                -- Créditos de consumo y personales
                pn_tip := 'CCP';
              
              when lc_rub1 = 4 then
                -- Hipotecario
                pn_tip := 'HIP';
              
              else
              
                pn_tip := '';
              
            end case;
          exception
            when others then
            
              pn_tip := '';
            
          end;
        end if;
      
      end;
      end if;
    end if;
  
    ---
  
  end sp_obtener_tcredito2;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
  -- Número de cuotas pendientes de pago
  procedure sp_fecha_ncuotas(pn_cod    in number,
                             pn_mod    in number,
                             pn_suc    in number,
                             pn_mda    in number,
                             pn_pap    in number,
                             pn_cta    in number,
                             pn_ope    in number,
                             pn_sbo    in number,
                             pn_top    in number,
                             pn_fecha  in date,
                             pn_ncuopp out number, -- Nro cuotas
                             pn_ncuopa out number) -- Cuotas ya pagadas
   is
  
    --lx_ncuop number;
    lx_frep    date;
    lx_fec_sig date;
    lx_nro_sig number(9);
  
  begin
  
    --- fecha de reprogramación
    /*
    begin
    
      select max(x.jaqa400fec)
        into lx_frep
        from jaqa400 x
       where x.jaqa400emp = pn_cod
         and x.jaqa400mod = pn_mod
         and x.jaqa400suc = pn_suc
         and x.jaqa400mda = pn_mda
         and x.jaqa400pap = pn_pap
         and x.jaqa400cta = pn_cta
         and x.jaqa400ope = pn_ope
         and
            --x.jaqa400sbo = pn_sbo
             x.jaqa400top = pn_top
         and x.jaqa400fec <= pn_fecha
         and x.jaqa400est in ('C', 'V');
    
    exception
      when others then
        lx_frep := null;
    end;
    */
    
    begin
      -- Call the function
      lx_frep := pq_cr_reporte_fond19_p2.fn_max_frep(pn_cod => pn_cod,
                                                     pn_mod => pn_mod,
                                                     pn_suc => pn_suc,
                                                     pn_mda => pn_mda,
                                                     pn_pap => pn_pap,
                                                     pn_cta => pn_cta,
                                                     pn_ope => pn_ope,
                                                     pn_sbo => pn_sbo,
                                                     pn_top => pn_top,
                                                     pn_fecha => pn_fecha);
    exception
      when others then
      
        lx_frep := null;                                                     
    end;    
  
    -- Verificar si luego de la fecha de reprog. hay otra reprogramación
    begin
      -- Call the procedure
      pq_cr_reporte_fond19_p2.sp_siguiente_creditopk(pn_cod     => pn_cod,
                                                     pn_mod     => pn_mod,
                                                     pn_suc     => pn_suc,
                                                     pn_mda     => pn_mda,
                                                     pn_pap     => pn_pap,
                                                     pn_cta     => pn_cta,
                                                     pn_ope     => pn_ope,
                                                     pn_sbo     => pn_sbo,
                                                     pn_top     => pn_top,
                                                     pn_fecha   => pn_fecha,
                                                     pn_fec_rep => lx_fec_sig,
                                                     pn_cor_rep => lx_nro_sig);
    exception
      when others then
        lx_fec_sig := null;
        lx_nro_sig := 0;
    end;
  
    if lx_fec_sig is not null then
    
      begin
        --->>>>>>>>>>>>>>>>>>>
      
        ---  Nro cuotas
        begin
        
          SELECT
          
           count(*)
            into pn_ncuopp
            FROM aqpb088_601c t
           where t.pgcod = pn_cod
             and t.ppmod = pn_mod
             --and t.ppsuc = pn_suc
             and t.ppmda = pn_mda
             and t.pppap = pn_pap
             and t.ppcta = pn_cta
             and t.ppoper = pn_ope
             --and t.ppsbop = pn_sbo
             and t.pptope = pn_top
             and t.ppfpag >= lx_frep -- --lx_frep
             and (t.ppcap + t.ppint) > 0
             and t.d601co = 'S'
             and t.fec = lx_fec_sig
             and t.cor = lx_nro_sig;
        exception
          when others then
            pn_ncuopp := 0;
        end;
      
        -- Cuotas ya pagadas
        begin
        
          SELECT
          
           count(*)
            into pn_ncuopa
            FROM aqpb088_602c t
           where t.pgcod = pn_cod
             and t.ppmod = pn_mod
             --and t.ppsuc = pn_suc
             and t.ppmda = pn_mda
             and t.pppap = pn_pap
             and t.ppcta = pn_cta
             and t.ppoper = pn_ope
             --and t.ppsbop = pn_sbo
             and t.pptope = pn_top
             and t.ppfpag >= lx_frep -- lx_fec_sig
             and t.pp1stat = 'T'
             and t.d602fc <= pn_fecha
             and t.d602co = 'S'
             and t.fec = lx_fec_sig
             and t.cor = lx_nro_sig;
        exception
          when others then
            pn_ncuopa := 0;
        end;
      
        ---<<<<<<<<<<<<<<<<<<<
      end;
    
    else
    
      begin
        --->>>>>>>>>>>>>>>>>>>
      
        if lx_frep is not null then
          ---  Nro cuotas
          begin
          
            SELECT
            
             count(*)
              into pn_ncuopp
              FROM FSD601 t
             where t.pgcod = pn_cod
               and t.ppmod = pn_mod
               --and t.ppsuc = pn_suc
               and t.ppmda = pn_mda
               and t.pppap = pn_pap
               and t.ppcta = pn_cta
               and t.ppoper = pn_ope
               and t.ppsbop = pn_sbo
               and t.pptope = pn_top
               and t.ppfpag >= lx_frep
               and (t.ppcap + t.ppint) > 0
               and t.d601co = 'S';
          exception
            when others then
              pn_ncuopp := 0;
          end;
        
          -- Cuotas ya pagadas
          begin
          
            SELECT
            
             count(*)
              into pn_ncuopa
              FROM FSD602 t
             where t.pgcod = pn_cod
               and t.ppmod = pn_mod
               --and t.ppsuc = pn_suc
               and t.ppmda = pn_mda
               and t.pppap = pn_pap
               and t.ppcta = pn_cta
               and t.ppoper = pn_ope
               and t.ppsbop = pn_sbo
               and t.pptope = pn_top
               and t.ppfpag >= lx_frep
               and t.pp1stat = 'T'
               and t.d602fc <= pn_fecha
               and t.d602co = 'S';
          exception
            when others then
              pn_ncuopa := 0;
          end;
        
        else
        
          pn_ncuopp := 0;
          pn_ncuopa := 0;
        
        end if;
      
        ---<<<<<<<<<<<<<<<<<<<
      end;
    end if;
  
  end sp_fecha_ncuotas;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
  -- Número de cuotas pendientes de pago con fecha inicio progrma covid pasado como parametro
  procedure sp_fecha_ncuotas2(pn_cod    in number,
                             pn_mod    in number,
                             pn_suc    in number,
                             pn_mda    in number,
                             pn_pap    in number,
                             pn_cta    in number,
                             pn_ope    in number,
                             pn_sbo    in number,
                             pn_top    in number,
                             pn_fecha  in date,
                             pn_fcovid in date,
                             pn_ncuopp out number, -- Nro cuotas
                             pn_ncuopa out number) -- Cuotas ya pagadas
   is
  
    --lx_ncuop number;
    lx_frep    date;
    lx_frep2    date;
    lx_fec_sig date;
    lx_nro_sig number(9);
  
  begin
  
    --- fecha de reprogramación
    /*
    begin
    
      select max(x.jaqa400fec)
        into lx_frep
        from jaqa400 x
       where x.jaqa400emp = pn_cod
         and x.jaqa400mod = pn_mod
         and x.jaqa400suc = pn_suc
         and x.jaqa400mda = pn_mda
         and x.jaqa400pap = pn_pap
         and x.jaqa400cta = pn_cta
         and x.jaqa400ope = pn_ope
         and
            --x.jaqa400sbo = pn_sbo
             x.jaqa400top = pn_top
         and x.jaqa400fec <= pn_fecha
         and x.jaqa400est in ('C', 'V');
    
    exception
      when others then
        lx_frep := null;
    end;
    */
    
    begin
      -- Call the function
      lx_frep2 := pq_cr_reporte_fond19_p2.fn_max_frep(pn_cod => pn_cod,
                                                     pn_mod => pn_mod,
                                                     pn_suc => pn_suc,
                                                     pn_mda => pn_mda,
                                                     pn_pap => pn_pap,
                                                     pn_cta => pn_cta,
                                                     pn_ope => pn_ope,
                                                     pn_sbo => pn_sbo,
                                                     pn_top => pn_top,
                                                     pn_fecha => pn_fecha);
    exception
      when others then
      
        lx_frep2 := null;                                                     
    end;   
    if pn_fcovid = to_date('01/01/0001','DD/MM/YYYY') then
      lx_frep := lx_frep2;
    else
      lx_frep := nvl(pn_fcovid,lx_frep2);
    end if;
    
    
    -- Verificar si luego de la fecha de reprog. hay otra reprogramación
    begin
      -- Call the procedure
      pq_cr_reporte_fond19_p2.sp_siguiente_creditopk(pn_cod     => pn_cod,
                                                     pn_mod     => pn_mod,
                                                     pn_suc     => pn_suc,
                                                     pn_mda     => pn_mda,
                                                     pn_pap     => pn_pap,
                                                     pn_cta     => pn_cta,
                                                     pn_ope     => pn_ope,
                                                     pn_sbo     => pn_sbo,
                                                     pn_top     => pn_top,
                                                     pn_fecha   => pn_fecha,
                                                     pn_fec_rep => lx_fec_sig,
                                                     pn_cor_rep => lx_nro_sig);
    exception
      when others then
        lx_fec_sig := null;
        lx_nro_sig := 0;
    end;
  
    if lx_fec_sig is not null then
    
      begin
        --->>>>>>>>>>>>>>>>>>>
      
        ---  Nro cuotas
        begin
        
          SELECT
          
           count(*)
            into pn_ncuopp
            FROM aqpb088_601c t
           where t.pgcod = pn_cod
             and t.ppmod = pn_mod
             --and t.ppsuc = pn_suc
             and t.ppmda = pn_mda
             and t.pppap = pn_pap
             and t.ppcta = pn_cta
             and t.ppoper = pn_ope
             --and t.ppsbop = pn_sbo
             and t.pptope = pn_top
             and t.ppfpag >= lx_frep -- --lx_frep
             and (t.ppcap + t.ppint) > 0
             and t.d601co = 'S'
             and t.fec = lx_fec_sig
             and t.cor = lx_nro_sig;
        exception
          when others then
            pn_ncuopp := 0;
        end;
      
        -- Cuotas ya pagadas
        begin
        
          SELECT
          
           count(*)
            into pn_ncuopa
            FROM aqpb088_602c t
           where t.pgcod = pn_cod
             and t.ppmod = pn_mod
             --and t.ppsuc = pn_suc
             and t.ppmda = pn_mda
             and t.pppap = pn_pap
             and t.ppcta = pn_cta
             and t.ppoper = pn_ope
             --and t.ppsbop = pn_sbo
             and t.pptope = pn_top
             and t.ppfpag >= lx_frep -- lx_fec_sig
             and t.pp1stat = 'T'
             and t.d602fc <= pn_fecha
             and t.d602co = 'S'
             and t.fec = lx_fec_sig
             and t.cor = lx_nro_sig;
        exception
          when others then
            pn_ncuopa := 0;
        end;
      
        ---<<<<<<<<<<<<<<<<<<<
      end;
    
    else
    
      begin
        --->>>>>>>>>>>>>>>>>>>
      
        if lx_frep is not null then
          ---  Nro cuotas
          begin
          
            SELECT
            
             count(*)
              into pn_ncuopp
              FROM FSD601 t
             where t.pgcod = pn_cod
               and t.ppmod = pn_mod
               --and t.ppsuc = pn_suc
               and t.ppmda = pn_mda
               and t.pppap = pn_pap
               and t.ppcta = pn_cta
               and t.ppoper = pn_ope
               and t.ppsbop = pn_sbo
               and t.pptope = pn_top
               and t.ppfpag >= lx_frep
               and (t.ppcap + t.ppint) > 0
               and t.d601co = 'S';
          exception
            when others then
              pn_ncuopp := 0;
          end;
        
          -- Cuotas ya pagadas
          begin
          
            SELECT
            
             count(*)
              into pn_ncuopa
              FROM FSD602 t
             where t.pgcod = pn_cod
               and t.ppmod = pn_mod
               --and t.ppsuc = pn_suc
               and t.ppmda = pn_mda
               and t.pppap = pn_pap
               and t.ppcta = pn_cta
               and t.ppoper = pn_ope
               and t.ppsbop = pn_sbo
               and t.pptope = pn_top
               and t.ppfpag >= lx_frep
               and t.pp1stat = 'T'
               and t.d602fc <= pn_fecha
               and t.d602co = 'S';
          exception
            when others then
              pn_ncuopa := 0;
          end;
        
        else
        
          pn_ncuopp := 0;
          pn_ncuopa := 0;
        
        end if;
      
        ---<<<<<<<<<<<<<<<<<<<
      end;
    end if;
  
  end sp_fecha_ncuotas2;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
  procedure sp_obtener_iniciales(pn_cod      in number,
                                 pn_mod      in number,
                                 pn_suc      in number,
                                 pn_mda      in number,
                                 pn_pap      in number,
                                 pn_cta      in number,
                                 pn_ope      in number,
                                 pn_sbo      in number,
                                 pn_top      in number,
                                 pn_tasa_ini out number) is
  
    --lx_fdes date;
  
  begin
  
    begin
    
      SELECT
      
       t.aotasa
        into pn_tasa_ini
        FROM fsd010 t
       where t.pgcod = pn_cod
         and t.aomod = pn_mod
         --and t.aosuc = pn_suc
         and t.aomda = pn_mda
         and t.aopap = pn_pap
         and t.aocta = pn_cta
         and t.aooper = pn_ope
         and t.aosbop = 0
         and t.aotope = pn_top
      ;
    
    exception
      when others then
        ---lx_fdes := null;
      
        begin
        
          SELECT t.aotasa
            into pn_tasa_ini
            FROM fsd010 t
           where t.pgcod = pn_cod
             and t.aomod = pn_mod
             and t.aosuc = pn_suc
             and t.aomda = pn_mda
             and t.aopap = pn_pap
             and t.aocta = pn_cta
             and t.aooper = pn_ope
             and t.aosbop = pn_sbo
             and t.aotope = pn_top;
        
        exception
          when others then
            pn_tasa_ini := 0;
        end;
      
    end;
  
  end sp_obtener_iniciales;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  function fn_obtener_sdocap(pn_cod     in number,
                             pn_mod     in number,
                             pn_suc     in number,
                             pn_mda     in number,
                             pn_pap     in number,
                             pn_cta     in number,
                             pn_ope     in number,
                             pn_sbo     in number,
                             pn_top     in number,
                             pn_fecha   in date,
                             pn_usuario in char) return number is
    --- Obtener saldo capital
  
    -- lx_imp   number(17, 2);
    -- lx_sdo   number(17, 2);
    lc_sdo_cap number(17, 2);
    lx_fecha   date;
  
  begin
  
    select t.pgfape into lx_fecha from fst017 t where t.pgcod = 1;
    --Fórmula: FSD010(AOIMP) + FSD011(SCSDO)
  
    -- 2. Obtención de la transacción
    if lx_fecha = pn_fecha then
      begin
      
        --select (t.scsdo * -1)
        select (sum(t.scsdo)) * -1
          into lc_sdo_cap
          from FSD011 t
         where t.pgcod = pn_cod
           and t.scmod = pn_mod
           --and t.scsuc = pn_suc
           and t.scmda = pn_mda
           and t.scpap = pn_pap
           and t.sccta = pn_cta
           and t.scoper = pn_ope
           --and t.scsbop = pn_sbo
           and t.sctope = pn_top;
      exception
        when others then
          lc_sdo_cap := 0;
      end;
    else
    
      begin
      
        select (sum(t.aqpb070asdmn)) * -1 --(t.bcsdmn * -1)
          into lc_sdo_cap
          from aqpb070a t -- FSH012
         where t.aqpb070ausur = pn_usuario
           and t.aqpb070aemp = pn_cod
           and t.aqpb070amod = pn_mod
           --and t.aqpb070asuc = pn_suc
           and t.aqpb070amda = pn_mda
           and t.aqpb070apap = pn_pap
           and t.aqpb070acta = pn_cta
           and t.aqpb070aoper = pn_ope
              --and t.aqpb070asbop = pn_sbo
           and t.aqpb070atop = pn_top
           and t.aqpb070afech = pn_fecha;
      
      exception
        when others then
          lc_sdo_cap := 0;
      end;
    
    end if;
  
    if lc_sdo_cap < 0 then
      lc_sdo_cap := 0;
    end if;
  
    return lc_sdo_cap;
  
  end fn_obtener_sdocap;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
  function fn_obtener_pgracia3(pn_cod   in number,
                               pn_mod   in number,
                               pn_suc   in number,
                               pn_mda   in number,
                               pn_pap   in number,
                               pn_cta   in number,
                               pn_ope   in number,
                               pn_sbo   in number,
                               pn_top   in number,
                               pn_fecha in date) return number is
  
    lx_ope1  number(3);
    lx_ope2  number(5);
    lx_resp  number(8);
    lx_fpri  date;
    lx_fvlor date;
    lx_peri  number(5);
    lx_frep  date;
  
    lx_fec_sig date;
    lx_nro_sig number(9);
  
  begin
    -- (fprig - frep - period) / period
    -- fprig  : primera cuota del cronograma vigente del crédito cuyo saldo e interés sea mayor a 0 y fecha de pago del cronograma sea mayor igual a la fecha de reprogramación 
    -- frep   : fecha de reprogramación ¿ 
    -- period : periodo FSD010 del crédito reprogramado
    -- 
  
    begin
    
      --- fecha de reprogramación
      /*
      begin
      
        select max(x.jaqa400fec)
          into lx_frep
          from jaqa400 x
         where x.jaqa400emp = pn_cod
           and x.jaqa400mod = pn_mod
           and x.jaqa400suc = pn_suc
           and x.jaqa400mda = pn_mda
           and x.jaqa400pap = pn_pap
           and x.jaqa400cta = pn_cta
           and x.jaqa400ope = pn_ope
           and
              --x.jaqa400sbo = pn_sbo
               x.jaqa400top = pn_top
           and x.jaqa400fec <= pn_fecha
           and x.jaqa400est in ('C', 'V');
      
      exception
        when others then
          lx_frep := null;
      end;
    */
    
    begin
      -- Call the function
      lx_frep := pq_cr_reporte_fond19_p2.fn_max_frep(pn_cod => pn_cod,
                                                     pn_mod => pn_mod,
                                                     pn_suc => pn_suc,
                                                     pn_mda => pn_mda,
                                                     pn_pap => pn_pap,
                                                     pn_cta => pn_cta,
                                                     pn_ope => pn_ope,
                                                     pn_sbo => pn_sbo,
                                                     pn_top => pn_top,
                                                     pn_fecha => pn_fecha);
    exception
      when others then
        lx_frep := null;                                                     
    end;      
    
      -- Verificar si luego de la fecha de reprog. hay otra reprogramación
      begin
        -- Call the procedure
        pq_cr_reporte_fond19_p2.sp_siguiente_creditopk(pn_cod     => pn_cod,
                                                       pn_mod     => pn_mod,
                                                       pn_suc     => pn_suc,
                                                       pn_mda     => pn_mda,
                                                       pn_pap     => pn_pap,
                                                       pn_cta     => pn_cta,
                                                       pn_ope     => pn_ope,
                                                       pn_sbo     => pn_sbo,
                                                       pn_top     => pn_top,
                                                       pn_fecha   => pn_fecha,
                                                       pn_fec_rep => lx_fec_sig,
                                                       pn_cor_rep => lx_nro_sig);
      exception
        when others then
          lx_fec_sig := null;
          lx_nro_sig := 0;
      end;
    
      --- primera cuota del cronograma vigente del crédito cuyo saldo e interés sea mayor a 0 y fecha de pago del cronograma sea mayor igual a la fecha de reprogramación 
      if lx_fec_sig is not null then
      
        begin
          select min(x.ppfpag) -- fprig
            into lx_fpri
            from aqpb088_601c x
           where x.pgcod = pn_cod
             and x.ppmod = pn_mod
             --and x.ppsuc = pn_suc
             and x.ppmda = pn_mda
             and x.pppap = pn_pap
             and x.ppcta = pn_cta
             and x.ppoper = pn_ope
             --and x.ppsbop = pn_sbo
             and x.pptope = pn_top
             and x.ppfpag >= lx_frep -- mcandia 15.07.2021
             and x.d601co = 'S'
             and x.fec = lx_fec_sig
             and x.cor = lx_nro_sig
             /*
             and not exists (select 'X'
                    from aqpb088_602c y
                   where y.pgcod = x.pgcod
                     and y.ppmod = x.ppmod
                     and y.ppsuc = x.ppsuc
                     and y.ppmda = x.ppmda
                     and y.pppap = x.pppap
                     and y.ppcta = x.ppcta
                     and y.ppoper = x.ppoper
                     and y.ppsbop = x.ppsbop
                     and y.pptope = x.pptope
                     and y.ppfpag = x.ppfpag
                     and y.pp1stat = 'T'
                     and y.d602co = 'S'
                     and y.fec = lx_fec_sig
                     and y.cor = lx_nro_sig)
               */
               ;
        
        exception
          when others then
            lx_fpri := null;
        end;
      
      else
      
        begin
          
         --- se considera la fecha del primer pago sin verificar el estado de cancelación
          select min(x.ppfpag) -- fprig
            into lx_fpri
            from fsd601 x
           where x.pgcod = pn_cod
             and x.ppmod = pn_mod
             --and x.ppsuc = pn_suc
             and x.ppmda = pn_mda
             and x.pppap = pn_pap
             and x.ppcta = pn_cta
             and x.ppoper = pn_ope
             and x.ppsbop = pn_sbo
             and x.pptope = pn_top
             and x.ppfpag >= lx_frep -- mcandia 15.07.2021
             and x.d601co = 'S'
             /*
             and not exists (select 'X'
                    from fsd602 y
                   where y.pgcod = x.pgcod
                     and y.ppmod = x.ppmod
                     and y.ppsuc = x.ppsuc
                     and y.ppmda = x.ppmda
                     and y.pppap = x.pppap
                     and y.ppcta = x.ppcta
                     and y.ppoper = x.ppoper
                     and y.ppsbop = x.ppsbop
                     and y.pptope = x.pptope
                     and y.ppfpag = x.ppfpag
                     and y.pp1stat = 'T'
                     and y.d602co = 'S')
               */
                     ;
        
        exception
          when others then
            lx_fpri := null;
        end;
      
      end if;
    
      --- periodo FSD010 del crédito reprogramado
      if lx_fec_sig is not null then
      
        begin
        
          select x.aoperiod
            into lx_peri
            from aqpb088_010c x
           where x.pgcod = pn_cod
             and x.aomod = pn_mod
             --and x.aosuc = pn_suc
             and x.aomda = pn_mda
             and x.aopap = pn_pap
             and x.aocta = pn_cta
             and x.aooper = pn_ope
             --and x.aosbop = pn_sbo
             and x.aotope = pn_top
             and x.fec = lx_fec_sig
             and x.cor = lx_nro_sig;
        
        exception
          when others then
            lx_peri := 0;
        end;
      
      else
      
        begin
        
          select x.aoperiod
            into lx_peri
            from fsd010 x
           where x.pgcod = pn_cod
             and x.aomod = pn_mod
             and x.aosuc = pn_suc
             and x.aomda = pn_mda
             and x.aopap = pn_pap
             and x.aocta = pn_cta
             and x.aooper = pn_ope
             and x.aosbop = pn_sbo
             and x.aotope = pn_top;
        
        exception
          when others then
            lx_peri := 0;
        end;
      
      end if;
    
      -- formula: (primer pago - fecha de rep¿rogramacio - periodo)/periodo
      if lx_fpri is not null and lx_frep is not null then
      
        if lx_peri = 0 then
          lx_resp := 0;
        else
          lx_resp := (lx_fpri - lx_frep - lx_peri) / lx_peri;
        end if;
      
        --- jrodriguej 16.05.2021
        if lx_resp <= 0 then
          lx_resp := 0;
        end if;
      
      end if;
    
    exception
      when others then
        lx_resp := 0;
    end;
  
    return lx_resp;
  
  end fn_obtener_pgracia3;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_siguiente_creditoPK(pn_cod     in number,
                                   pn_mod     in number,
                                   pn_suc     in number,
                                   pn_mda     in number,
                                   pn_pap     in number,
                                   pn_cta     in number,
                                   pn_ope     in number,
                                   pn_sbo     in number,
                                   pn_top     in number,
                                   pn_fecha   in date,
                                   pn_fec_rep out date,
                                   pn_cor_rep out number) is
  
    lx_contar number(3);
  begin
  
    begin
      select count(*)
        into lx_contar
        from jaqa400 x
       where x.jaqa400emp = pn_cod
         and x.jaqa400mod = pn_mod
         and x.jaqa400suc = pn_suc
         and x.jaqa400mda = pn_mda
         and x.jaqa400pap = pn_pap
         and x.jaqa400cta = pn_cta
         and x.jaqa400ope = pn_ope
            -- and x.jaqa400sbo = pn_sbo
         and x.jaqa400top = pn_top
         and x.jaqa400fec > pn_fecha
         --and x.jaqa400ac1 in ('U', 'C') -- jrodriguej 14.07.2021
         and x.jaqa400est in ('C');
    
    exception
      when others then
      
        lx_contar := 0;
      
    end;
  
    if lx_contar > 0 then
    
      begin
        select f.aqpb088fep, f.aqpb088cor
          into pn_fec_rep, pn_cor_rep
          from (select x.aqpb088fep, x.aqpb088cor
                  from aqpb088 x
                 where x.aqpb088emp = pn_cod
                   and x.aqpb088mod = pn_mod
                   --and x.aqpb088suc = pn_suc
                   and x.aqpb088mda = pn_mda
                   and x.aqpb088pap = pn_pap
                   and x.aqpb088cta = pn_cta
                   and x.aqpb088ope = pn_ope
                   and
                      --x.aqpb088sbo = and
                       x.aqpb088top = pn_top
                   and x.aqpb088est in ('C', 'V')
                   and x.aqpb088fep > pn_fecha
                 order by x.aqpb088fep, x.aqpb088cor) f
         where rownum = 1;
      exception
        when others then
          pn_fec_rep := null;
          pn_cor_rep := 0;
      end;
    
    end if;
  
  end sp_siguiente_creditoPK;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                 
  function fn_max_frep(pn_cod   in number,
                          pn_mod   in number,
                          pn_suc   in number,
                          pn_mda   in number,
                          pn_pap   in number,
                          pn_cta   in number,
                          pn_ope   in number,
                          pn_sbo   in number,
                          pn_top   in number,
                          pn_fecha in date) return date is
  --- máxima fecha de reprogramacion
  
    lx_fini date;
  
  begin
  
    --- fecha de reprogramación
    begin
    
      select max(x.jaqa400fec)
        into lx_fini
        from jaqa400 x
       where x.jaqa400emp = pn_cod
         --and x.jaqa400mod = pn_mod
         --and x.jaqa400suc = pn_suc
         --and x.jaqa400mda = pn_mda
         --and x.jaqa400pap = pn_pap
         and x.jaqa400cta = pn_cta
         and x.jaqa400ope = pn_ope
         -- and x.jaqa400sbo = pn_sbo
         --and x.jaqa400top = pn_top
         and x.jaqa400fec <= pn_fecha
         --and x.jaqa400ac1 in ('U', 'C') -- jrodriguej 14.07.2021
         and x.jaqa400est in ('C');
       if lx_fini is null then
         begin
          select max(x.aqpb090fec)
          into lx_fini
          from aqpb090 x
           where x.aqpb090fec <= pn_fecha
             and x.aqpb090cta = pn_cta
             and x.aqpb090oper = pn_ope
             and x.aqpb090ext = 'NO';
         exception 
          when others then 
            lx_fini := null;
         end;
       end if;
    exception
      when no_data_found then
        begin
          select max(x.aqpb090fec)
          into lx_fini
          from aqpb090 x
           where x.aqpb090fec <= pn_fecha
             and x.aqpb090cta = pn_cta
             and x.aqpb090oper = pn_ope
             and x.aqpb090ext = 'NO';
        exception 
          when others then 
            lx_fini := null;
        end;
      when others then
      
        lx_fini := null;
      
    end;
  
    return lx_fini;
  
  end fn_max_frep;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  
end pq_cr_reporte_fond19_p2;
/

