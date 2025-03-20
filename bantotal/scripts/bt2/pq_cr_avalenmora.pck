create or replace package PQ_CR_AVALENMORA is

  -- Author  : MPOSTIGOC
  -- Created : 09/05/2018 12:38:04 p.m.
  -- Purpose : Politica 42 Avalados en Mora
  -- Modificado : 25/07/2018
  -- Usuario Modificado: MPOSTIGOC  
  -- Modificacion: Solo se consideran creditos Vigentes, y se verifica si la instancia a la que se esta 
  --               avalando se encuentra desembolsada
  ----------------------------------------------------------

  procedure sp_cr_VerifAvalRefi(ln_Instancia   in number,
                                lc_VerfAvalRef out varchar2);
  --------------------------------------------------------------
  procedure sp_cr_PromdMoraMaxAval(ln_Instancia        in number,
                                   ln_MaxPromdMoraAval out number,
                                   ln_MoraMaxAval      out number);
  ----------------------------------------------------------------
  procedure sp_promedio_mora(pn_pai      in number,
                             pn_tdo      in number,
                             pc_ndo      char,
                             pd_fecpro   date,
                             ln_promedio out number,
                             pn_moramax  out number);

end PQ_CR_AVALENMORA;
/

create or replace package body PQ_CR_AVALENMORA is

  procedure sp_cr_VerifAvalRefi(ln_Instancia   in number,
                                lc_VerfAvalRef out varchar2) is
  
    cursor lista_InstanciasAvaladas is
      select distinct sng001inst ln_InstAvalada
        from sng003
       where sng003cta in (select distinct f.ctnro
                             from sng001 s, fsr008 f
                            where s.sng001pais = f.pepais
                              and s.sng001tdoc = f.petdoc
                              and s.sng001ndoc = f.pendoc
                              and s.sng001inst = ln_Instancia);
  
    cursor Lista_AllIntegrantes(ln_InstanciaAvalada number) is
      select distinct (trim(f.pendoc)) ln_doc, f.petdoc, f.pepais
        from fsr008 f
       where f.ctnro in
             (select distinct sng001cta
                from sng001
               where sng001inst in (ln_InstanciaAvalada))
      union
      select distinct (trim(g.rpndoc)) ln_doc, g.petdoc, g.pepais
        from fsr008 f, fsr002 g
       where f.ctnro in
             (select distinct sng001cta
                from sng001
               where sng001inst in (ln_InstanciaAvalada))
         and f.pepais = g.pepais
         and f.petdoc = g.petdoc
         and f.pendoc = g.pendoc
         and g.rpccyg = 66
      union
      select distinct (trim(g.pendoc)) ln_doc, g.petdoc, g.pepais
        from fsr008 f, fsr002 g
       where f.ctnro in
             (select distinct sng001cta
                from sng001
               where sng001inst in (ln_InstanciaAvalada))
         and f.pepais = g.rppais
         and f.petdoc = g.rptdoc
         and f.pendoc = g.rpndoc
         and g.rpccyg = 66;
  
    /*  cursor Lista_AllIntegrantes is
    
    select distinct (trim(f.pendoc)) ln_doc, f.petdoc, f.pepais
      from fsr008 f
     where f.ctnro in
           (select distinct sng001cta
              from sng001
             where sng001inst in
                   (select sng001inst
                      from sng003
                     where sng003cta in
                           (select s.sng001cta
                              from sng001 s
                             where sng001inst = ln_Instancia)))
    union
    select distinct (trim(g.rpndoc)) ln_doc, g.petdoc, g.pepais
      from fsr008 f, fsr002 g
     where f.ctnro in
           (select distinct sng001cta
              from sng001
             where sng001inst in
                   (select sng001inst
                      from sng003
                     where sng003cta in
                           (select s.sng001cta
                              from sng001 s
                             where sng001inst = ln_Instancia)))
       and f.pepais = g.pepais
       and f.petdoc = g.petdoc
       and f.pendoc = g.pendoc
       and g.rpccyg = 66
    union
    select distinct (trim(g.pendoc)) ln_doc, g.petdoc, g.pepais
      from fsr008 f, fsr002 g
     where f.ctnro in
           (select distinct sng001cta
              from sng001
             where sng001inst in
                   (select sng001inst
                      from sng003
                     where sng003cta in
                           (select s.sng001cta
                              from sng001 s
                             where sng001inst = ln_Instancia)))
       and f.pepais = g.rppais
       and f.petdoc = g.rptdoc
       and f.pendoc = g.rpndoc
       and g.rpccyg = 66;*/
  
    cursor Cred_Vigentes(ln_pais    in number,
                         ln_petdoc  in number,
                         lc_numdoc  in char,
                         ld_FchSist date) is
    
      select d10.pgcod    ln_pgcod10,
             d10.aomod    ln_mod10,
             d10.aosuc    ln_suc10,
             d10.aomda    ln_mda10,
             d10.aopap    ln_pap10,
             d10.aocta    ln_cta10,
             d10.aooper   ln_oper10,
             d10.aosbop   ln_sbop10,
             d10.aotope   ln_tope10,
             d10.aoperiod ln_peri10,
             d10.aostat   lC_EstCredito
      
        from fsd010 d10
       where Pgcod = 1
         and Aocta in (select Ctnro
                         from fsr008
                        where pepais = ln_pais
                          and Petdoc = ln_petdoc
                          and pendoc = lc_numdoc)
         and (Aomod in (select modulo
                          from fst111
                         where dscod = 50
                           and modulo not in (108, 141)) or Aomod = 117)
         and Aostat <> 99
         and aofvto >= ld_FchSist;
  
    ld_FchSist       date;
    lc_FlagInsDesemb number := 0;
  
  begin
  
    begin
      select pgfape into ld_FchSist from fst017 where pgcod = 1;
    end;
  
    lc_VerfAvalRef := 'N';
  
    for p in lista_InstanciasAvaladas loop
    
      begin
        -- Verifica si la Instancia Avalada se encuentra desembolsada
        select count(*)
          into lc_FlagInsDesemb
          from xwf700 x, fsd010 f
         where x.xwfempresa = f.PGCOD
           and x.xwfsucursal = f.AOSUC
           and x.xwfmodulo = f.AOMOD
           and x.xwfmoneda = f.AOMDA
           and x.xwfpapel = f.AOPAP
           and x.xwfcuenta = f.AOCTA
           and x.xwfoperacion = f.AOOPER
           and x.xwfsubope = f.AOSBOP
           and x.xwftipope = f.AOTOPE
           and x.xwfcar3 = '1'
           and f.aostat <> 99 -- mpostigoc 02/08/18
           and x.xwfprcins = p.ln_instavalada;
      exception
        when others then
          lc_FlagInsDesemb := 0;
      end;
    
      if lc_FlagInsDesemb > 0 then
      
        for l in Lista_AllIntegrantes(p.ln_instavalada) loop
        
          for cr in Cred_Vigentes(l.pepais, l.petdoc, l.ln_doc, ld_FchSist) loop
          
            if cr.lC_EstCredito = 61 then
              lc_VerfAvalRef := 'S';
              exit;
            
            else
              lc_VerfAvalRef := 'N';
            end if;
          end loop;
        
          if lc_VerfAvalRef = 'S' then
            exit;
          else
            lc_VerfAvalRef := 'N';
          end if;
        
        end loop;
      end if;
    end loop;
  
  end sp_cr_VerifAvalRefi;

  -----------------------------------------------------------------------
  procedure sp_cr_PromdMoraMaxAval(ln_Instancia        in number,
                                   ln_MaxPromdMoraAval out number,
                                   ln_MoraMaxAval      out number) is
  
    cursor lista_InstanciasAvaladas is
      select distinct sng001inst ln_InstAvalada
        from sng003
       where sng003cta in (select distinct f.ctnro
                             from sng001 s, fsr008 f
                            where s.sng001pais = f.pepais
                              and s.sng001tdoc = f.petdoc
                              and s.sng001ndoc = f.pendoc
                              and s.sng001inst = ln_Instancia);
  
    cursor Lista_AllIntegrantes(ln_InstanciaAvalada number) is
      select distinct (trim(f.pendoc)) ln_doc, f.petdoc, f.pepais
        from fsr008 f
       where f.ctnro in
             (select distinct sng001cta
                from sng001
               where sng001inst in (ln_InstanciaAvalada))
      union
      select distinct (trim(g.rpndoc)) ln_doc, g.petdoc, g.pepais
        from fsr008 f, fsr002 g
       where f.ctnro in
             (select distinct sng001cta
                from sng001
               where sng001inst in (ln_InstanciaAvalada))
         and f.pepais = g.pepais
         and f.petdoc = g.petdoc
         and f.pendoc = g.pendoc
         and g.rpccyg = 66
      union
      select distinct (trim(g.pendoc)) ln_doc, g.petdoc, g.pepais
        from fsr008 f, fsr002 g
       where f.ctnro in
             (select distinct sng001cta
                from sng001
               where sng001inst in (ln_InstanciaAvalada))
         and f.pepais = g.rppais
         and f.petdoc = g.rptdoc
         and f.pendoc = g.rpndoc
         and g.rpccyg = 66;
    -- mpostigoc 25/07/2018
    /*   select distinct (trim(f.pendoc)) ln_doc, f.petdoc, f.pepais
      from fsr008 f
     where f.ctnro in
           (select distinct sng001cta
              from sng001
             where sng001inst in
                   (select sng001inst
                      from sng003
                     where sng003cta in
                           (select s.sng001cta
                              from sng001 s
                             where sng001inst = ln_Instancia)))
    union
    select distinct (trim(g.rpndoc)) ln_doc, g.petdoc, g.pepais
      from fsr008 f, fsr002 g
     where f.ctnro in
           (select distinct sng001cta
              from sng001
             where sng001inst in
                   (select sng001inst
                      from sng003
                     where sng003cta in
                           (select s.sng001cta
                              from sng001 s
                             where sng001inst = ln_Instancia)))
       and f.pepais = g.pepais
       and f.petdoc = g.petdoc
       and f.pendoc = g.pendoc
       and g.rpccyg = 66
    union
    select distinct (trim(g.pendoc)) ln_doc, g.petdoc, g.pepais
      from fsr008 f, fsr002 g
     where f.ctnro in
           (select distinct sng001cta
              from sng001
             where sng001inst in
                   (select sng001inst
                      from sng003
                     where sng003cta in
                           (select s.sng001cta
                              from sng001 s
                             where sng001inst = ln_Instancia)))
       and f.pepais = g.rppais
       and f.petdoc = g.rptdoc
       and f.pendoc = g.rpndoc
       and g.rpccyg = 66;*/
  
    ld_FchSist       date;
    pn_moramaxAux    number := 0;
    ln_promedioaux   number := 0;
    lc_FlagInsDesemb number := 0;
  
  begin
    begin
      select pgfape into ld_FchSist from fst017 where pgcod = 1;
    end;
    ln_MaxPromdMoraAval := 0;
    ln_MoraMaxAval      := 0;
  
    for p in lista_InstanciasAvaladas loop
    
      begin
        -- Verifica si la Instancia Avalada se encuentra desembolsada
        select count(*)
          into lc_FlagInsDesemb
          from xwf700 x, fsd010 f
         where x.xwfempresa = f.PGCOD
           and x.xwfsucursal = f.AOSUC
           and x.xwfmodulo = f.AOMOD
           and x.xwfmoneda = f.AOMDA
           and x.xwfpapel = f.AOPAP
           and x.xwfcuenta = f.AOCTA
           and x.xwfoperacion = f.AOOPER
           and x.xwfsubope = f.AOSBOP
           and x.xwftipope = f.AOTOPE
           and x.xwfcar3 = '1'
           and f.aostat <> 99 -- mpostigoc 02/08/18
           and x.xwfprcins = p.ln_instavalada;
      exception
        when others then
          lc_FlagInsDesemb := 0;
      end;
    
      if lc_FlagInsDesemb > 0 then
      
        for l in Lista_AllIntegrantes(p.ln_instavalada) loop
        
          PQ_CR_AVALENMORA.sp_promedio_mora(pn_pai      => L.PEPAIS,
                                            pn_tdo      => l.petdoc,
                                            pc_ndo      => l.ln_doc,
                                            pd_fecpro   => ld_FchSist,
                                            ln_promedio => ln_promedioaux,
                                            pn_moramax  => pn_moramaxAux);
        
          if ln_MaxPromdMoraAval < ln_promedioaux then
            ln_MaxPromdMoraAval := ln_promedioaux;
          end if;
        
          if ln_MoraMaxAval < pn_moramaxAux then
            ln_MoraMaxAval := pn_moramaxAux;
          end if;
        
        end loop;
      end if;
    end loop;
  
  end sp_cr_PromdMoraMaxAval;

  -----------------------------------------------------------------------
  procedure sp_promedio_mora(pn_pai      in number,
                             pn_tdo      in number,
                             pc_ndo      char,
                             pd_fecpro   date,
                             ln_promedio out number,
                             pn_moramax  out number) is
  
    cursor clientes is
      select distinct A.CTNRO --a.pepais, a.petdoc, a.pendoc  mod@abr 20170821
        from fsr008 a
       where ctnro in (select ctnro
                         from fsr008 a
                        where a.pepais = pn_pai
                          and a.petdoc = pn_tdo
                          and a.pendoc = pc_ndo);
  
    cursor creditos(ln_cta in number, --mod@abr 20170821                   
                    ld_fec in date) is
      select *
        from (select distinct B.PGCOD,
                              b.aomod,
                              b.aosuc,
                              b.aomda,
                              b.aopap,
                              b.aocta,
                              b.aooper,
                              b.aosbop,
                              b.aotope,
                              b.aofval,
                              b.aofvto,
                              b.aostat,
                              a.pepais,
                              a.petdoc,
                              a.pendoc,
                              (case
                                when aostat <> 99 then
                                 aofvto
                                else
                                 pq_cr_relcrediticia.Fn_DiaPago(b.PGCOD,
                                                                AOMOD,
                                                                AOSUC,
                                                                AOMDA,
                                                                AOPAP,
                                                                AOCTA,
                                                                AOOPER,
                                                                AOSBOP,
                                                                AOTOPE,
                                                                aostat,
                                                                aofe99)
                              end) FEUSO,
                              
                              pq_cr_relcrediticia.Fn_DiaPago(b.PGCOD,
                                                             AOMOD,
                                                             AOSUC,
                                                             AOMDA,
                                                             AOPAP,
                                                             AOCTA,
                                                             AOOPER,
                                                             AOSBOP,
                                                             AOTOPE,
                                                             aostat,
                                                             aofe99) fecpago
                from fsd010 b, fsr008 a
               where b.pgcod = 1
                 and b.aocta = ln_cta
                 and b.pgcod = a.pgcod
                 and b.aocta = a.ctnro
                 and a.cttfir = 'T'
                 and aomod in (select modulo
                                 from fst111
                                where dscod = 50
                                  and modulo not in (200, 33, 108))
                    
                 and aotope <> 550
                 and aostat <> 99) -- mpostigoc 25/07/18
       where (fecpago >= ld_fec or
             fecpago = to_date('01/01/0001', 'DD/MM/YYYY'))
       order by aofval desc;
  
    ln_contCuotas number(18);
    ln_dia        number(18);
  
    ln_contCuoTot number(18);
    ln_diaTot     number(18);
    ln_nromeses   number(5);
  
    ld_fecorte date;
  
    ln_moramax    number(10);
    ln_sw         number(1) := 0; --mod@abr 20170822
    lc_VerifExcp  varchar2(2); -- mpostigoc 20171102
    ln_periodoaux number; -- mpostigoc 20171106
    ln_periodo    number; -- mpostigoc 20171106
  begin
  
    begin
      ln_contCuoTot := 0;
      ln_diaTot     := 0;
    
      begin
        select tp1nro1
          into ln_nromeses
          from fst198
         where tp1cod = 1
           and tp1cod1 = 10899
           and tp1corr1 = 27
           and tp1corr2 = 1
           and tp1corr3 = 1;
      exception
        when others then
          ln_nromeses := 0;
      end;
      ld_fecorte := to_date(to_char(add_months(pd_fecpro, -ln_nromeses),
                                    'yyyymm') || '01',
                            'yyyymmdd');
    
      ln_moramax := 0;
      pn_moramax := 0;
    
      for j in clientes loop
        for i in creditos(j.ctnro, ld_fecorte) loop
        
          if (i.fecpago is null or
             i.fecpago = to_date('0001.01.01', 'yyyy.mm.dd')) and
             i.aostat = 99 then
            ln_sw := 1;
          end if;
        
          pq_cr_ampliaciones.sp_cr_VerificaExcepciones(ln_pgcod     => I.PGCOD,
                                                       ln_modulo    => I.AOMOD,
                                                       ln_sucursal  => I.AOSUC,
                                                       ln_moneda    => I.AOMDA,
                                                       ln_papel     => I.AOPAP,
                                                       ln_cuenta    => I.AOCTA,
                                                       ln_operac    => I.AOOPER,
                                                       ln_suboper   => I.AOSBOP,
                                                       ln_tipoper   => I.AOTOPE,
                                                       lc_VerifExcp => lc_VerifExcp);
        
          if lc_VerifExcp <> 'N' then
            if ln_sw = 0 then
            
              begin
              
                begin
                  -- MPOSTIGOC 20171106
                  -- Periodo            
                  select a.aoperiod
                    into ln_periodoaux
                    from fsd010 a
                   where a.pgcod = i.pgcod
                     and a.aomod = i.aomod
                     and a.aosuc = i.aosuc
                     and a.aomda = i.aomda
                     and a.aopap = i.aopap
                     and a.aocta = i.aocta
                     and a.aooper = i.aooper
                     and a.aosbop = i.aosbop
                     and a.aotope = i.aotope;
                exception
                  when others then
                    ln_periodoaux := 0;
                end;
              
                --Mensualizamos el periodo
                ln_periodo := ln_periodoaux / 30;
              
              end;
            
              pq_cr_ampliaciones.sp_calculaCuotas_new(i.pgcod,
                                                      i.aomod,
                                                      i.aosuc,
                                                      i.aomda,
                                                      i.aopap,
                                                      i.aocta,
                                                      i.aooper,
                                                      i.aosbop,
                                                      i.aotope,
                                                      pd_fecpro,
                                                      ld_fecorte,
                                                      i.aostat,
                                                      ln_periodo, -- mpostigoc 2017/11/06
                                                      ln_contCuotas,
                                                      ln_dia,
                                                      ln_moramax);
              ln_diaTot     := ln_diaTot + ln_dia;
              ln_contCuoTot := ln_contCuoTot + ln_contCuotas;
              --mora maxima
              if ln_moramax > pn_moramax then
                pn_moramax := ln_moramax;
              end if;
              --mora maxima
            end if;
          
          end if;
        end loop;
      end loop;
    end;
  
    if ln_contCuoTot = 0 then
      --dbms_output.put_line (i.pepais||'-'||i.petdoc||'-'||i.pendoc);
      ln_promedio := 0;
    else
      ln_promedio := round((ln_diaTot / ln_contCuoTot), 2);
    end if;
  
  end sp_promedio_mora;
  -----------------------------------------------------------------------  
end PQ_CR_AVALENMORA;
/

