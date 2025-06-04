create or replace package PQ_CR_CONSLEVALUACIONES is

  -- *****************************************************************
  -- Nombre                     : PQ_CR_CONSLEVALUACIONES
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 02/05/2025 15:31:19
  -- Autor de Creación          : MARIA POSTIGO
  -- Uso                        : Consolidado de Evaluaciones
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : Nro de Instancia
  -- Fecha de Modificación      : 15/05/2025
  -- Autor de la Modificación   : MPOSTIGOC
  -- Descripción de Modificación: Se agrego la visualizacion de Garantias, politicas y Ratios Financieros
  -- Fecha de Modificación      : 03/06/2025
  -- Autor de la Modificación   : MPOSTIGOC
  -- Descripción de Modificación: Se agrego validaciones de ejecucion
  -- *****************************************************************  

  procedure sp_Cr_Inicio(ln_Instancia in number);
  ---------------------------------------------------
  procedure sp_cr_Consolidado(ln_instancia in number, ln_ModEva in number);
  ------------------------------------------------------ 
  procedure sp_cr_LogAQPB195(ln_inst      in number,
                             ln_cta       in number,
                             lc_cliente   in varchar2,
                             lc_analst    in varchar2,
                             ln_insteval2 in number,
                             ld_fcheval2  in date,
                             ln_TipCamb2  in number,
                             ln_codgrup   in number,
                             lc_grupo     in varchar2,
                             lc_codconc   in varchar2,
                             lc_concpto   in varchar2,
                             ln_mnt2      in number);
  ----------------------------------------------------
  procedure sp_Cr_RatiosFinancieros(ln_instancia in number,
                                    ln_ModEva    in number);
  ---------------------------------------------------------
  procedure sp_cr_LogAQPB198(ln_inst      in number,
                             ln_insteval3 in number,
                             ld_fcheval3  in date,
                             ln_codgrup   in number,
                             lv_grupo     in varchar2,
                             lv_codconc   in varchar2,
                             lv_concpto   in varchar2,
                             ln_mnt3      in number);
  ----------------------------------------------------------
  procedure sp_Cr_Garantias(ln_Instancia in number);
  ----------------------------------------------------------
  procedure sp_Cr_LogAQPB197(ln_inst   in number,
                             ln_modg   in number,
                             lv_topeg  in varchar2,
                             ln_sucg   in number,
                             ln_ctag   in number,
                             ln_opeg   in number,
                             ln_sldmog in number,
                             lv_mda    in varchar2,
                             ln_mutilg in number,
                             ln_dispg  in number,
                             ln_prig   in number,
                             ln_porcg  in number);
  -------------------------------------------------------
  procedure sp_Cr_Politicas(ln_Instancia in number);
  -------------------------------------------------------
  procedure sp_cr_LogAQPB199(ln_inst     in number,
                             lv_codetapa in varchar2,
                             lv_detapa   in varchar2,
                             ln_nropol   in varchar2,
                             lv_despol   in varchar2,
                             lv_tipo     in varchar2);

end PQ_CR_CONSLEVALUACIONES;
/
create or replace package body PQ_CR_CONSLEVALUACIONES is

  procedure sp_Cr_Inicio(ln_Instancia in number) is
  
    ln_ModEva      number(5) := 0;
    ln_Habilitado  number(5) := 0;
    ln_RegConsEva  number := 0;
    ln_RegRatFinan number := 0;
  
  begin
  
    begin
      update aqpb195 a
         set a.aqpb195est = 'I'
       where a.aqpb195inst = ln_Instancia
         and a.aqpb195est = 'H';
      commit;
    end;
  
    begin
      update aqpb197 a
         set a.aqpb197est = 'I'
       where a.aqpb197inst = ln_Instancia
         and a.aqpb197est = 'H';
      commit;
    end;
  
    begin
      update aqpb198 a
         set a.aqpb198est = 'I'
       where a.aqpb198inst = ln_Instancia
         and a.aqpb198est = 'H';
      commit;
    end;
    begin
      update aqpb199 a
         set a.aqpb199est = 'I'
       where a.aqpb199inst = ln_Instancia
         and a.aqpb199est = 'H';
      commit;
    end;
  
    begin
      select s.sng021tmod
        into ln_ModEva
        from sng021 s
       where s.sng021sol = ln_Instancia;
    exception
      when others then
        ln_ModEva := 0;
    end;
  
    begin
      select count(*)
        into ln_Habilitado
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 10899
         and f.tp1corr1 = 149
         and f.tp1corr2 = 0
         and f.tp1corr3 in (1, 2)
         and f.tp1nro3 = ln_ModEva
         and f.tp1imp1 = 1;
    exception
      when others then
        ln_Habilitado := 0;
    end;
  
    if ln_Habilitado = 1 then
    
      PQ_CR_CONSLEVALUACIONES.sp_cr_Consolidado(ln_instancia => ln_Instancia,
                                                ln_ModEva    => ln_ModEva);
    
      PQ_CR_CONSLEVALUACIONES.sp_Cr_RatiosFinancieros(ln_instancia => ln_Instancia,
                                                      ln_ModEva    => ln_ModEva);
    
      PQ_CR_CONSLEVALUACIONES.sp_Cr_Garantias(ln_Instancia => ln_Instancia);
    
      PQ_CR_CONSLEVALUACIONES.sp_Cr_Politicas(ln_Instancia => ln_Instancia);
    
      begin
        select count(*)
          into ln_RegConsEva
          from aqpb195 a
         where a.aqpb195inst = ln_Instancia
           and a.aqpb195est = 'H';
      exception
        when others then
          ln_RegConsEva := 0;
      end;
    
      if ln_RegConsEva = 0 then
      
        PQ_CR_CONSLEVALUACIONES.sp_cr_Consolidado(ln_instancia => ln_Instancia,
                                                  ln_ModEva    => ln_ModEva);
      
        PQ_CR_CONSLEVALUACIONES.sp_Cr_RatiosFinancieros(ln_instancia => ln_Instancia,
                                                        ln_ModEva    => ln_ModEva);
      
      end if;
    
    end if;
  
  end sp_Cr_Inicio;
  -----------------------------------------------------------
  procedure sp_cr_Consolidado(ln_instancia in number, ln_ModEva in number) is
  
    cursor Evaluaciones(ln_pais number, ln_tdoc number, lc_ndoc varchar2) is
      select *
        from sng021 a
       inner join xwf070 x
          on a.sng021sol = x.xwfprcin
       where x.xwfcont = 'S'
         and a.sng021pdoc = ln_pais
         and a.sng021tdoc = ln_tdoc
         and a.sng021ndoc = rpad(lc_ndoc, 12, ' ')
         and a.sng021tmod = ln_ModEva
       order by a.sng021fec desc;
  
    cursor grupos is
      select f.tp1nro3 grupo, f.tp1desc descgrupo
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 10899
         and f.tp1corr1 = 149
         and f.tp1corr2 = 0
         and f.tp1corr3 > 2
         and f.tp1nro2 = ln_ModEva;
  
    cursor campos(ln_Grupo number) is
      select f.tp1nro2 CodSoles, f.tp1nro3 CodDolar, f.tp1desC Concepto
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 10899
         and f.tp1corr1 = 149
         and f.tp1corr2 = ln_Grupo
         and f.tp1nro1 = ln_ModEva
       order by f.tp1corr3;
  
    cursor analisis_Horz is
      select a.aqpb195cor,
             a.aqpb195inst,
             a.aqpb195codgrup,
             a.aqpb195codconc,
             a.aqpb195mnt1,
             a.aqpb195mnt2,
             a.aqpb195mnt3
        from aqpb195 a
       where a.aqpb195inst = ln_instancia
         and a.aqpb195est = 'H'
       order by a.aqpb195cor;
  
    ln_cuenta      number;
    ln_pais        number;
    ln_tdoc        number;
    lc_Ndoc        number;
    ln_NroEva      number;
    x              number := 2;
    ln_MntSoles    number(17, 2) := 0.00;
    ln_MntDolar    number(17, 2) := 0.00;
    ln_MntTotal    number(17, 2) := 0.00;
    ln_TipoCamb    number(10, 6) := 1;
    lc_NombCli     varchar2(50);
    lc_Analista    varchar2(10);
    ld_FchEval     date;
    ln_VarH1       number(17, 2) := 0.00;
    ln_VarH2       number(17, 2) := 0.00;
    ln_PorH1       number(17, 2);
    ln_PorH2       number(17, 2);
    ln_MntVerAct1  number(17, 2) := 0.00;
    ln_MntVerAct2  number(17, 2) := 0.00;
    ln_MntVerAct3  number(17, 2) := 0.00;
    ln_MntVerPasv1 number(17, 2) := 0.00;
    ln_MntVerPasv2 number(17, 2) := 0.00;
    ln_MntVerPasv3 number(17, 2) := 0.00;
    ln_MntVerGan1  number(17, 2) := 0.00;
    ln_MntVerGan2  number(17, 2) := 0.00;
    ln_MntVerGan3  number(17, 2) := 0.00;
    ln_PorV1       number(17) := 0;
    ln_PorV2       number(17) := 0;
    ln_PorV3       number(17) := 0;
  
  begin
  
    begin
      select s.sng001cta,
             s.sng001pais,
             s.sng001tdoc,
             s.sng001ndoc,
             s.sng001ase
        into ln_cuenta, ln_pais, ln_tdoc, lc_Ndoc, lc_Analista
        from sng001 s
       where s.sng001inst = ln_instancia;
    exception
      when others then
        ln_cuenta := 0;
        ln_pais   := 0;
        ln_tdoc   := 0;
        lc_Ndoc   := null;
    end;
  
    begin
      select f.penom
        into lc_NombCli
        from fsd001 f
       where f.pepais = ln_pais
         and f.petdoc = ln_tdoc
         and f.pendoc = rpad(lc_Ndoc, 12, ' ');
    exception
      when others then
        lc_NombCli := null;
    end;
  
    begin
      select s.sng120tcbi
        into ln_TipoCamb
        from sng120 s
       where s.sng120ins = ln_instancia
         and s.sng120tsk = 'EVALUACION';
    exception
      when others then
        ln_TipoCamb := 1;
    end;
  
    for e in evaluaciones(ln_pais, ln_tdoc, lc_Ndoc) loop
    
      begin
        select s.sng120tcbi
          into ln_TipoCamb
          from sng120 s
         where s.sng120ins = e.sng021sol
           and s.sng120tsk = 'EVALUACION';
      exception
        when others then
          ln_TipoCamb := 1;
      end;
    
      if x = 1 then
      
        update aqpb195 a
           set a.aqpb195insteval1 = e.sng021sol,
               a.aqpb195fcheval1  = e.sng021fec,
               a.aqpb195tcambeva1 = ln_TipoCamb
         where a.aqpb195inst = ln_instancia
           and a.aqpb195est = 'H';
      
      end if;
    
      for g in grupos loop
        for c in campos(g.grupo) loop
          ln_MntSoles := 0;
          ln_MntDolar := 0;
          ln_MntTotal := 0;
        
          begin
            select s.sng023mto
              into ln_MntSoles
              from sng023 s
             where s.sng021eval = e.sng021eval
               and s.sng026cod = c.codsoles;
          exception
            when others then
              ln_MntSoles := 0;
          end;
        
          begin
            select s.sng023mto
              into ln_MntDolar
              from sng023 s
             where s.sng021eval = e.sng021eval
               and s.sng026cod = c.coddolar;
          exception
            when others then
              ln_MntDolar := 0;
          end;
        
          ln_MntSoles := nvl(ln_MntSoles, 0);
          ln_MntDolar := nvl(ln_MntDolar, 0);
          ln_MntTotal := ln_MntSoles + (ln_MntDolar * ln_TipoCamb);
        
          if x = 2 then
          
            pq_Cr_conslevaluaciones.sp_cr_LogAQPB195(ln_inst      => ln_instancia,
                                                     ln_cta       => ln_cuenta,
                                                     lc_cliente   => lc_NombCli,
                                                     lc_analst    => lc_Analista,
                                                     ln_insteval2 => e.sng021sol,
                                                     ld_fcheval2  => e.sng021fec,
                                                     ln_TipCamb2  => ln_TipoCamb,
                                                     ln_codgrup   => g.grupo,
                                                     lc_grupo     => g.descgrupo,
                                                     lc_codconc   => c.codsoles || '-' ||
                                                                     c.coddolar,
                                                     lc_concpto   => c.concepto,
                                                     ln_mnt2      => ln_MntTotal);
          
          end if;
        
          if x = 1 then
          
            update aqpb195 a
               set a.aqpb195mnt1 = ln_MntTotal
             where a.aqpb195inst = ln_instancia
               and a.aqpb195codgrup = g.grupo
               and a.aqpb195codconc = c.codsoles || '-' || c.coddolar
               and a.aqpb195est = 'H';
          
          end if;
        
        end loop;
        commit;
      end loop;
      x := x - 1;
    end loop;
  
    -- Solicitud en Proceso  
    begin
      select s.sng021eval, s.sng021fec
        into ln_NroEva, ld_FchEval
        from sng021 s
       where s.sng021sol = ln_instancia;
    exception
      when others then
        ln_NroEva := 0;
    end;
  
    begin
      select s.sng120tcbi
        into ln_TipoCamb
        from sng120 s
       where s.sng120ins = ln_instancia
         and s.sng120tsk = 'EVALUACION';
    exception
      when others then
        ln_TipoCamb := 1;
    end;
  
    begin
      update aqpb195 a
         set a.aqpb195insteval3 = ln_instancia,
             a.aqpb195fcheval3  = ld_FchEval,
             a.aqpb195tcambeva3 = ln_TipoCamb
       where a.aqpb195inst = ln_instancia
         and a.aqpb195est = 'H';
    end;
  
    for g in grupos loop
      for c in campos(g.grupo) loop
        ln_MntSoles := 0;
        ln_MntDolar := 0;
        ln_MntTotal := 0;
      
        begin
          select s.sng023mto
            into ln_MntSoles
            from sng023 s
           where s.sng021eval = ln_NroEva
             and s.sng026cod = c.codsoles;
        exception
          when others then
            ln_MntSoles := 0;
        end;
      
        begin
          select s.sng023mto
            into ln_MntDolar
            from sng023 s
           where s.sng021eval = ln_NroEva
             and s.sng026cod = c.coddolar;
        exception
          when others then
            ln_MntDolar := 0;
        end;
      
        ln_MntSoles := nvl(ln_MntSoles, 0);
        ln_MntDolar := nvl(ln_MntDolar, 0);
        ln_MntTotal := ln_MntSoles + (ln_MntDolar * ln_TipoCamb);
      
        update aqpb195 a
           set a.aqpb195mnt3 = ln_MntTotal
         where a.aqpb195inst = ln_instancia
           and a.aqpb195codgrup = g.grupo
           and a.aqpb195codconc = c.codsoles || '-' || c.coddolar
           and a.aqpb195est = 'H';
      
      end loop;
      commit;
    end loop;
  
    --  Vertical Activos
    begin
      select a.aqpb195mnt1
        into ln_MntVerAct1
        from aqpb195 a
       where a.aqpb195inst = ln_instancia
         and a.aqpb195codconc = '52-552'
         and a.aqpb195est = 'H';
    exception
      when others then
        ln_MntVerAct1 := 0.00;
    end;
  
    begin
      select a.aqpb195mnt2
        into ln_MntVerAct2
        from aqpb195 a
       where a.aqpb195inst = ln_instancia
         and a.aqpb195codconc = '52-552'
         and a.aqpb195est = 'H';
    exception
      when others then
        ln_MntVerAct2 := 0.00;
    end;
  
    begin
      select a.aqpb195mnt3
        into ln_MntVerAct3
        from aqpb195 a
       where a.aqpb195inst = ln_instancia
         and a.aqpb195codconc = '52-552'
         and a.aqpb195est = 'H';
    exception
      when others then
        ln_MntVerAct3 := 0.00;
    end;
  
    -- Vertical Pasivos
    begin
      select a.aqpb195mnt1
        into ln_MntVerPasv1
        from aqpb195 a
       where a.aqpb195inst = ln_instancia
         and a.aqpb195codconc = '71-571'
         and a.aqpb195est = 'H';
    exception
      when others then
        ln_MntVerPasv1 := 0.00;
    end;
    begin
      select a.aqpb195mnt2
        into ln_MntVerPasv2
        from aqpb195 a
       where a.aqpb195inst = ln_instancia
         and a.aqpb195codconc = '71-571'
         and a.aqpb195est = 'H';
    exception
      when others then
        ln_MntVerPasv2 := 0.00;
    end;
    begin
      select a.aqpb195mnt3
        into ln_MntVerPasv3
        from aqpb195 a
       where a.aqpb195inst = ln_instancia
         and a.aqpb195codconc = '71-571'
         and a.aqpb195est = 'H';
    exception
      when others then
        ln_MntVerPasv3 := 0.00;
    end;
  
    -- Vertical Ganancias
    begin
      select a.aqpb195mnt1
        into ln_MntVerGan1
        from aqpb195 a
       where a.aqpb195inst = ln_instancia
         and a.aqpb195codconc = '73-573'
         and a.aqpb195est = 'H';
    exception
      when others then
        ln_MntVerGan1 := 0.00;
    end;
    begin
      select a.aqpb195mnt2
        into ln_MntVerGan2
        from aqpb195 a
       where a.aqpb195inst = ln_instancia
         and a.aqpb195codconc = '73-573'
         and a.aqpb195est = 'H';
    exception
      when others then
        ln_MntVerGan2 := 0.00;
    end;
  
    begin
      select a.aqpb195mnt3
        into ln_MntVerGan3
        from aqpb195 a
       where a.aqpb195inst = ln_instancia
         and a.aqpb195codconc = '73-573'
         and a.aqpb195est = 'H';
    exception
      when others then
        ln_MntVerGan3 := 0.00;
    end;
  
    ---- Calcula Analisis Horizontal y Analisis Vertical
    for h in analisis_Horz loop
    
      ln_VarH1 := 0.00;
      ln_VarH2 := 0.00;
      ln_PorH1 := null;
      ln_PorH2 := null;
      ln_PorV1 := 0;
      ln_PorV2 := 0;
      ln_PorV3 := 0;
    
      ln_VarH1 := nvl(h.aqpb195mnt2, 0) - nvl(h.aqpb195mnt1, 0);
      ln_VarH2 := nvl(h.aqpb195mnt3, 0) - nvl(h.aqpb195mnt2, 0);
    
      if nvl(h.aqpb195mnt2, 0) > 0 and nvl(h.aqpb195mnt1, 0) > 0 then
        ln_PorH1 := ((nvl(h.aqpb195mnt2, 0) / nvl(h.aqpb195mnt1, 0)) * 100) - 100;
      end if;
    
      if nvl(h.aqpb195mnt3, 0) > 0 and nvl(h.aqpb195mnt2, 0) > 0 then
        ln_PorH2 := ((nvl(h.aqpb195mnt3, 0) / nvl(h.aqpb195mnt2, 0)) * 100) - 100;
      end if;
    
      ln_MntVerAct1 := nvl(ln_MntVerAct1, 0);
      ln_MntVerAct2 := nvl(ln_MntVerAct2, 0);
      ln_MntVerAct3 := nvl(ln_MntVerAct3, 0);
    
      ln_MntVerPasv1 := nvl(ln_MntVerPasv1, 0);
      ln_MntVerPasv2 := nvl(ln_MntVerPasv2, 0);
      ln_MntVerPasv3 := nvl(ln_MntVerPasv3, 0);
    
      ln_MntVerGan1 := nvl(ln_MntVerGan1, 0);
      ln_MntVerGan2 := nvl(ln_MntVerGan2, 0);
      ln_MntVerGan3 := nvl(ln_MntVerGan3, 0);
    
      if h.aqpb195codgrup = 1 and ln_MntVerAct1 > 0 then
        ln_PorV1 := (nvl(h.aqpb195mnt1, 0) / ln_MntVerAct1) * 100;
      end if;
      if h.aqpb195codgrup = 1 and ln_MntVerAct2 > 0 then
        ln_PorV2 := (nvl(h.aqpb195mnt2, 0) / ln_MntVerAct2) * 100;
      end if;
      if h.aqpb195codgrup = 1 and ln_MntVerAct3 > 0 then
        ln_PorV3 := (nvl(h.aqpb195mnt3, 0) / ln_MntVerAct3) * 100;
      end if;
      if h.aqpb195codgrup = 2 and ln_MntVerPasv1 > 0 then
        ln_PorV1 := (nvl(h.aqpb195mnt1, 0) / ln_MntVerPasv1) * 100;
      end if;
      if h.aqpb195codgrup = 2 and ln_MntVerPasv2 > 0 then
        ln_PorV2 := (nvl(h.aqpb195mnt2, 0) / ln_MntVerPasv2) * 100;
      end if;
      if h.aqpb195codgrup = 2 and ln_MntVerPasv3 > 0 then
        ln_PorV3 := (nvl(h.aqpb195mnt3, 0) / ln_MntVerPasv3) * 100;
      end if;
      if h.aqpb195codgrup = 3 and ln_MntVerGan1 > 0 then
        ln_PorV1 := (nvl(h.aqpb195mnt1, 0) / ln_MntVerGan1) * 100;
      end if;
      if h.aqpb195codgrup = 3 and ln_MntVerGan2 > 0 then
        ln_PorV2 := (nvl(h.aqpb195mnt2, 0) / ln_MntVerGan2) * 100;
      end if;
      if h.aqpb195codgrup = 3 and ln_MntVerGan3 > 0 then
        ln_PorV3 := (nvl(h.aqpb195mnt3, 0) / ln_MntVerGan3) * 100;
      end if;
    
      update aqpb195 a
         set a.aqpb195varhorz1  = ln_VarH1,
             a.aqpb195varhorz2  = ln_VarH2,
             a.aqpb195porchorz1 = ln_PorH1,
             a.aqpb195porchorz2 = ln_PorH2,
             a.aqpb195porcvert1 = ln_PorV1,
             a.aqpb195porcvert2 = ln_PorV2,
             a.aqpb195porcvert3 = ln_PorV3
       where a.aqpb195inst = h.aqpb195inst
         and a.aqpb195codgrup = h.aqpb195codgrup
         and a.aqpb195codconc = h.aqpb195codconc
         and a.aqpb195est = 'H'
         and a.aqpb195cor = h.aqpb195cor;
    
    end loop;
    commit;
  
  end sp_cr_Consolidado;
  -----------------------------------------------------------
  procedure sp_cr_LogAQPB195(ln_inst      in number,
                             ln_cta       in number,
                             lc_cliente   in varchar2,
                             lc_analst    in varchar2,
                             ln_insteval2 in number,
                             ld_fcheval2  in date,
                             ln_TipCamb2  in number,
                             ln_codgrup   in number,
                             lc_grupo     in varchar2,
                             lc_codconc   in varchar2,
                             lc_concpto   in varchar2,
                             ln_mnt2      in number) is
  
    lc_hora  varchar2(10) := '00:00:00';
    ld_fecha date;
    ln_cor   number := 0;
  
  begin
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    exception
      when others then
        lc_hora := '00:00:00';
    end;
  
    begin
      select f.pgfape into ld_fecha from fst017 f where f.pgcod = 1;
    exception
      when others then
        ld_fecha := null;
    end;
  
    begin
      select max(a.aqpb195cor)
        into ln_cor
        from aqpb195 a
       where a.aqpb195inst = ln_inst
         and a.aqpb195est = 'H';
    exception
      when others then
        ln_cor := 0;
    end;
  
    ln_cor := nvl(ln_cor, 0);
  
    begin
      insert into aqpb195
        (aqpb195cor,
         aqpb195inst,
         aqpb195fecha,
         aqpb195hora,
         aqpb195cta,
         aqpb195cliente,
         aqpb195analst,
         aqpb195insteval2,
         aqpb195fcheval2,
         aqpb195tcambeva2,
         aqpb195codgrup,
         aqpb195grupo,
         aqpb195codconc,
         aqpb195concpto,
         aqpb195mnt2,
         aqpb195est)
      values
        (ln_cor + 1,
         ln_inst,
         ld_fecha,
         lc_hora,
         ln_cta,
         lc_cliente,
         lc_analst,
         ln_insteval2,
         ld_fcheval2,
         ln_TipCamb2,
         ln_codgrup,
         lc_grupo,
         lc_codconc,
         lc_concpto,
         ln_mnt2,
         'H');
    exception
      when others then
        null;
    end;
    commit;
  end;
  -----------------------------------------------------------
  procedure sp_Cr_RatiosFinancieros(ln_instancia in number,
                                    ln_ModEva    in number) is
  
    cursor grupos is
      select f.tp1nro3 grupo, f.tp1desc descgrupo
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 10899
         and f.tp1corr1 = 151
         and f.tp1corr2 = 0
         and f.tp1corr3 > 2
         and f.tp1nro2 = ln_ModEva;
  
    cursor campos(ln_Grupo number) is
      select f.tp1nro2 CodConcep, f.tp1desC Concepto
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 10899
         and f.tp1corr1 = 151
         and f.tp1corr2 = ln_Grupo
         and f.tp1nro1 = ln_ModEva
       order by f.tp1corr3;
  
    ln_NroEval   number;
    x            number := 2;
    ln_MntConcep number(17, 2) := 0.00;
    ld_FchEval   date;
    ln_Inst3     number;
    ln_Inst2     number;
    ln_Inst1     number;
  
  begin
  
    begin
      select distinct (a.aqpb195insteval3)
        into ln_Inst3
        from aqpb195 a
       where a.aqpb195inst = ln_instancia
         and a.aqpb195est = 'H';
    exception
      when others then
        ln_Inst3 := 0;
    end;
  
    begin
      select distinct (a.aqpb195insteval2)
        into ln_Inst2
        from aqpb195 a
       where a.aqpb195inst = ln_instancia
         and a.aqpb195est = 'H';
    exception
      when others then
        ln_Inst2 := 0;
    end;
    begin
      select distinct (a.aqpb195insteval1)
        into ln_Inst1
        from aqpb195 a
       where a.aqpb195inst = ln_instancia
         and a.aqpb195est = 'H';
    exception
      when others then
        ln_Inst1 := 0;
    end;
  
    for g in grupos loop
      for c in campos(g.grupo) loop
      
        ln_MntConcep := 0;
      
        begin
          select s.sng021eval, s.sng021fec
            into ln_NroEval, ld_FchEval
            from sng021 s
           where s.sng021sol = ln_Inst3;
        exception
          when others then
            ln_NroEval := 0;
        end;
      
        begin
          select s.sng023mto
            into ln_MntConcep
            from sng023 s
           where s.sng021eval = ln_NroEval
             and s.sng026cod = c.codconcep;
        exception
          when others then
            ln_MntConcep := 0;
        end;
      
        ln_MntConcep := nvl(ln_MntConcep, 0);
      
        if x = 2 then
        
          pq_Cr_conslevaluaciones.sp_cr_LogAQPB198(ln_inst      => ln_instancia,
                                                   ln_insteval3 => ln_Inst3,
                                                   ld_fcheval3  => ld_FchEval,
                                                   ln_codgrup   => g.grupo,
                                                   lv_grupo     => g.descgrupo,
                                                   lv_codconc   => c.codconcep,
                                                   lv_concpto   => c.concepto,
                                                   ln_mnt3      => ln_MntConcep);
        
        end if;
      end loop;
      commit;
    end loop;
    x := x - 1;
  
    if x = 1 and ln_Inst2 > 0 then
      -- 2da instancia
      for g in grupos loop
        for c in campos(g.grupo) loop
          ln_MntConcep := 0;
        
          begin
            select s.sng021eval, s.sng021fec
              into ln_NroEval, ld_FchEval
              from sng021 s
             where s.sng021sol = ln_Inst2;
          exception
            when others then
              ln_NroEval := 0;
          end;
        
          begin
            select s.sng023mto
              into ln_MntConcep
              from sng023 s
             where s.sng021eval = ln_NroEval
               and s.sng026cod = c.codconcep;
          exception
            when others then
              ln_MntConcep := 0;
          end;
        
          ln_MntConcep := nvl(ln_MntConcep, 0);
        
          if x = 1 then
          
            update aqpb198 a
               set a.aqpb198mnt2      = ln_MntConcep,
                   a.aqpb198insteval2 = ln_Inst2,
                   a.aqpb198fcheval2  = ld_FchEval
             where a.aqpb198inst = ln_instancia
               and a.aqpb198codgrup = g.grupo
               and a.aqpb198codconc = c.codconcep
               and a.aqpb198est = 'H';
          
          end if;
        
        end loop;
        commit;
      end loop;
    end if;
    x := x - 1;
  
    if x = 0 and ln_Inst1 > 0 then
    
      for g in grupos loop
        for c in campos(g.grupo) loop
          ln_MntConcep := 0;
        
          begin
            select s.sng021eval, s.sng021fec
              into ln_NroEval, ld_FchEval
              from sng021 s
             where s.sng021sol = ln_Inst1;
          exception
            when others then
              ln_NroEval := 0;
          end;
        
          begin
            select s.sng023mto
              into ln_MntConcep
              from sng023 s
             where s.sng021eval = ln_NroEval
               and s.sng026cod = c.codconcep;
          exception
            when others then
              ln_MntConcep := 0;
          end;
        
          ln_MntConcep := nvl(ln_MntConcep, 0);
        
          if x = 0 then
          
            update aqpb198 a
               set a.aqpb198mnt1      = ln_MntConcep,
                   a.aqpb198insteval1 = ln_Inst1,
                   a.aqpb198fcheval1  = ld_FchEval
             where a.aqpb198inst = ln_instancia
               and a.aqpb198codgrup = g.grupo
               and a.aqpb198codconc = c.codconcep
               and a.aqpb198est = 'H';
          
          end if;
        
        end loop;
        commit;
      end loop;
    end if;
  
  end sp_Cr_RatiosFinancieros;
  ----------------------------------------------------------
  procedure sp_cr_LogAQPB198(ln_inst      in number,
                             ln_insteval3 in number,
                             ld_fcheval3  in date,
                             ln_codgrup   in number,
                             lv_grupo     in varchar2,
                             lv_codconc   in varchar2,
                             lv_concpto   in varchar2,
                             ln_mnt3      in number) is
    lc_hora  varchar2(10) := '00:00:00';
    ld_fecha date;
    ln_cor   number := 0;
  
  begin
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    exception
      when others then
        lc_hora := '00:00:00';
    end;
  
    begin
      select f.pgfape into ld_fecha from fst017 f where f.pgcod = 1;
    exception
      when others then
        ld_fecha := null;
    end;
  
    begin
      select max(a.aqpb198cor)
        into ln_cor
        from aqpb198 a
       where a.aqpb198inst = ln_inst
         and a.aqpb198est = 'H';
    exception
      when others then
        ln_cor := 0;
    end;
  
    ln_cor := nvl(ln_cor, 0);
  
    begin
      insert into aqpb198
        (aqpb198cor,
         aqpb198inst,
         aqpb198fecha,
         aqpb198hora,
         aqpb198insteval3,
         aqpb198fcheval3,
         aqpb198codgrup,
         aqpb198grupo,
         aqpb198codconc,
         aqpb198concpto,
         aqpb198mnt3,
         aqpb198est)
      values
        (ln_cor + 1,
         ln_inst,
         ld_fecha,
         lc_hora,
         ln_insteval3,
         ld_fcheval3,
         ln_codgrup,
         lv_grupo,
         lv_codconc,
         lv_concpto,
         ln_mnt3,
         'H');
    exception
      when others then
        null;
    end;
    commit;
  
  end sp_cr_LogAQPB198;
  -----------------------------------------------------------
  procedure sp_Cr_Garantias(ln_Instancia in number) is
  
    cursor garantias is
      select s.sng122inst,
             s.sng122mod,
             s.sng122tope,
             s.sng122suc,
             s.sng122cta,
             s.sng122oper,
             s.sng122sdog,
             s.sng122mda,
             s.sng122mtou,
             s.sng122mtod,
             s.sng122pri,
             s.sng122poco
        from sng122 s
       where s.sng122inst = ln_Instancia;
  
    lc_Moneda varchar2(5);
    lc_Tope   varchar2(50);
  
  begin
  
    for g in garantias loop
    
      begin
        select f.mosign
          into lc_Moneda
          from fst005 f
         where f.moneda = g.sng122mda;
      exception
        when others then
          lc_Moneda := null;
      end;
    
      begin
        select f.totope || ' - ' || f.tonom
          into lc_Tope
          from fst004 f
         where f.modulo = g.sng122mod
           and f.totope = g.sng122tope;
      exception
        when others then
          lc_Tope := null;
      end;
    
      PQ_CR_CONSLEVALUACIONES.sp_Cr_LogAQPB197(ln_inst   => ln_Instancia,
                                               ln_modg   => g.sng122mod,
                                               lv_topeg  => lc_Tope,
                                               ln_sucg   => g.sng122suc,
                                               ln_ctag   => g.sng122cta,
                                               ln_opeg   => g.sng122oper,
                                               ln_sldmog => g.sng122sdog,
                                               lv_mda    => lc_Moneda,
                                               ln_mutilg => g.sng122mtou,
                                               ln_dispg  => g.sng122mtod,
                                               ln_prig   => g.sng122pri,
                                               ln_porcg  => g.sng122poco);
    
    end loop;
    commit;
  
  end sp_Cr_Garantias;
  -----------------------------------------------------------
  procedure sp_Cr_LogAQPB197(ln_inst   in number,
                             ln_modg   in number,
                             lv_topeg  in varchar2,
                             ln_sucg   in number,
                             ln_ctag   in number,
                             ln_opeg   in number,
                             ln_sldmog in number,
                             lv_mda    in varchar2,
                             ln_mutilg in number,
                             ln_dispg  in number,
                             ln_prig   in number,
                             ln_porcg  in number) is
  
    lc_hora  varchar2(10) := '00:00:00';
    ld_fecha date;
    ln_cor   number := 0;
  
  begin
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    exception
      when others then
        lc_hora := '00:00:00';
    end;
  
    begin
      select f.pgfape into ld_fecha from fst017 f where f.pgcod = 1;
    exception
      when others then
        ld_fecha := null;
    end;
  
    begin
      select max(a.aqpb197cor)
        into ln_cor
        from aqpb197 a
       where a.aqpb197inst = ln_inst
         and a.aqpb197est = 'H';
    exception
      when others then
        ln_cor := 0;
    end;
  
    ln_cor := nvl(ln_cor, 0);
  
    begin
      insert into aqpb197
        (aqpb197cor,
         aqpb197fch,
         aqpb197hora,
         aqpb197inst,
         aqpb197modg,
         aqpb197topeg,
         aqpb197sucg,
         aqpb197ctag,
         aqpb197opeg,
         aqpb197sldmog,
         aqpb197mda,
         aqpb197mutilg,
         aqpb197dispg,
         aqpb197prig,
         aqpb197porcg,
         aqpb197est)
      values
        (ln_cor + 1,
         ld_fecha,
         lc_hora,
         ln_inst,
         ln_modg,
         lv_topeg,
         ln_sucg,
         ln_ctag,
         ln_opeg,
         ln_sldmog,
         lv_mda,
         ln_mutilg,
         ln_dispg,
         ln_prig,
         ln_porcg,
         'H');
    exception
      when others then
        null;
    end;
    commit;
  
  end sp_Cr_LogAQPB197;

  -----------------------------------------------------------
  procedure sp_Cr_Politicas(ln_Instancia in number) is
  
    cursor bloqueantes is
      select J.JAQY596INST,
             j.jaqy596etap,
             j.jaqy596poli,
             'Bloqueante' lc_TiPol,
             j.jaqy596menp
        from jaqy596 j
       where j.jaqy596inst = ln_Instancia;
  
    cursor Etapas is
      select f.pae51eva ln_Etapa, max(f.pae70nro) ln_MaxNro
        from fpae70 f
       where f.pae70ins = ln_Instancia
       group by f.pae51eva;
  
    cursor bloque_excep(Etapa number, ln_Nro number) is
      select distinct f.pae73pol,
                      f.pae51eva,
                      f.pae73tip,
                      DBMS_LOB.substr(f.pae73mns) lv_DescPol
        from fpae73 f
       where f.pae51eva = Etapa
         and f.pae70nro = ln_Nro
         and f.pae73tip = 'E';
  
    lv_DescEtapa varchar2(25);
  
  begin
  
    for b in bloqueantes loop
    
      if b.jaqy596etap = 1 then
        lv_DescEtapa := 'Solicitud';
      else
        if b.jaqy596etap = 2 then
          lv_DescEtapa := 'Evaluacion/Propuesta';
        else
          if b.jaqy596etap = 3 then
            lv_DescEtapa := 'Aprobacion';
          else
            if b.jaqy596etap = 4 then
              lv_DescEtapa := 'Desembolso';
            end if;
          end if;
        end if;
      end if;
    
      pq_Cr_conslevaluaciones.sp_cr_LogAQPB199(ln_inst     => ln_Instancia,
                                               lv_codetapa => b.jaqy596etap,
                                               lv_detapa   => lv_DescEtapa,
                                               ln_nropol   => b.jaqy596poli,
                                               lv_despol   => b.jaqy596menp,
                                               lv_tipo     => b.lc_tipol);
    end loop;
  
    for t in Etapas loop
      for e in bloque_excep(t.ln_etapa, t.ln_maxnro) loop
      
        if e.pae51eva = 1 then
          lv_DescEtapa := 'Solicitud';
        else
          if e.pae51eva = 2 then
            lv_DescEtapa := 'Evaluación/Propuesta';
          else
            if e.pae51eva = 3 then
              lv_DescEtapa := 'Aprobación';
            else
              if e.pae51eva = 4 then
                lv_DescEtapa := 'Desembolso';
              end if;
            end if;
          end if;
        end if;
      
        pq_Cr_conslevaluaciones.sp_cr_LogAQPB199(ln_inst     => ln_Instancia,
                                                 lv_codetapa => e.pae51eva,
                                                 lv_detapa   => lv_DescEtapa,
                                                 ln_nropol   => e.pae73pol,
                                                 lv_despol   => e.lv_descpol,
                                                 lv_tipo     => 'Bloqueante/Excepción');
      
      end loop;
    end loop;
  
  end sp_Cr_Politicas;
  ----------------------------------------------------------
  procedure sp_cr_LogAQPB199(ln_inst     in number,
                             lv_codetapa in varchar2,
                             lv_detapa   in varchar2,
                             ln_nropol   in varchar2,
                             lv_despol   in varchar2,
                             lv_tipo     in varchar2) is
  
    lc_hora  varchar2(10) := '00:00:00';
    ld_fecha date;
    ln_cor   number := 0;
  
  begin
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    exception
      when others then
        lc_hora := '00:00:00';
    end;
  
    begin
      select f.pgfape into ld_fecha from fst017 f where f.pgcod = 1;
    exception
      when others then
        ld_fecha := null;
    end;
  
    begin
      select max(a.aqpb199cor)
        into ln_cor
        from aqpb199 a
       where a.aqpb199inst = ln_inst
         and a.aqpb199est = 'H';
    exception
      when others then
        ln_cor := 0;
    end;
  
    ln_cor := nvl(ln_cor, 0);
  
    begin
    
      begin
        insert into aqpb199
          (aqpb199cor,
           aqpb199inst,
           aqpb199fecha,
           aqpb199hora,
           aqpb199codetapa,
           aqpb199detapa,
           aqpb199nropol,
           aqpb199despol,
           aqpb199tipo,
           aqpb199est)
        values
          (ln_cor + 1,
           ln_inst,
           ld_fecha,
           lc_hora,
           lv_codetapa,
           lv_detapa,
           ln_nropol,
           lv_despol,
           lv_tipo,
           'H');
      exception
        when others then
          null;
      end;
      commit;
    end;
  
  end sp_cr_LogAQPB199;
  -----------------------------------------------------------
end PQ_CR_CONSLEVALUACIONES;
/
