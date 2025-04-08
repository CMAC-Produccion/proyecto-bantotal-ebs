create or replace package PQ_CR_DATOS_APROBACION is
  -- *****************************************************************
  -- Nombre                     : PAQUETES PARA OBTENER DATOS EN APROBACION
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 29/08/2023 17:12:10
  -- Autor de Creación          : MARIA POSTIGO
  -- Uso                        : Devuelve valores
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :
  -- Fecha de Modificación      : 10.06.2024
  -- Autor de la Modificación   :  MPOSTIGOC
  -- Descripción de Modificación: Se modificó para considerar los ratios ejecutados en Evaluacion Propuesta. 
  -- Fecha de Modificación      : 31/03/2025
  -- Autor de la Modificación   :  MPOSTIGOC
  -- Descripción de Modificación: Se agrego el procedimiento sp_Cr_SegmentacionAnterior para obtener la segmentacion anterior.   
  -- *****************************************************************

  procedure sp_cr_RatioCR(ld_pgfape    in date,
                          ln_codcat    in number,
                          ln_codcamp   in number,
                          lc_TAG       in varchar2,
                          ln_instancia in number,
                          lc_user      in varchar2,
                          lc_prgm      in varchar2,
                          lc_valor     out varchar2);
  ---------------------------------------------------------------
  procedure sp_Cr_Segmento(ld_pgfape    in date,
                           ln_codcat    in number,
                           ln_codcamp   in number,
                           lc_TAG       in varchar2,
                           ln_Instancia in number,
                           lc_user      in varchar2,
                           lc_prgm      in varchar2,
                           lc_Segmento  out varchar2);
  --------------------------------------------------------------- 
  procedure sp_Cr_SegmentacionSol(ld_pgfape       in date,
                                  ln_codcat       in number,
                                  ln_codcamp      in number,
                                  lc_TAG          in varchar2,
                                  ln_instancia    in number,
                                  lc_user         in varchar2,
                                  lc_prgm         in varchar2,
                                  lc_Segmentacion out varchar2);
  ----------------------------------------------------------------
  procedure sp_Cr_SegmentacionAnterior(ln_instancia      in number,
                                       lc_SegmntAnterior out varchar2,
                                       lc_IndCambSegmnt  out varchar2);
  -----------------------------------------------------------
  procedure sp_cr_aval(ld_pgfape    in date,
                       ln_codcat    in number,
                       ln_codcamp   in number,
                       lc_TAG       in varchar2,
                       ln_instancia in number,
                       lc_user      in varchar2,
                       lc_prgm      in varchar2,
                       lc_Aval      out varchar2);
  ----------------------------------------------------------
  procedure sp_cr_CredVigentes(ld_pgfape     in date,
                               ln_codcat     in number,
                               ln_codcamp    in number,
                               lc_TAG        in varchar2,
                               ln_instancia  in number,
                               lc_user       in varchar2,
                               lc_prgm       in varchar2,
                               ln_NroCredVig out varchar2);
  ----------------------------------------------------------
  procedure sp_cr_RatioEnd(ld_pgfape    in date,
                           ln_codcat    in number,
                           ln_codcamp   in number,
                           lc_TAG       in varchar2,
                           ln_instancia in number,
                           lc_user      in varchar2,
                           lc_prgm      in varchar2,
                           ln_RatioEnd  out varchar2);
  --------------------------------------------------------
  procedure sp_Cr_RiesgCamb(ld_pgfape     in date,
                            ln_codcat     in number,
                            ln_codcamp    in number,
                            lc_TAG        in varchar2,
                            ln_instancia  in number,
                            lc_user       in varchar2,
                            lc_prgm       in varchar2,
                            lc_RiesgoCamb out varchar2);
  ----------------------------------------------------------
  procedure sp_Cr_TipoCred(ld_pgfape    in date,
                           ln_codcat    in number,
                           ln_codcamp   in number,
                           lc_TAG       in varchar2,
                           ln_instancia in number,
                           lc_user      in varchar2,
                           lc_prgm      in varchar2,
                           lc_TipoCred  out varchar2);
  -------------------------------------------------
  procedure sp_Cr_Sector(ld_pgfape    in date,
                         ln_codcat    in number,
                         ln_codcamp   in number,
                         lc_TAG       in varchar2,
                         ln_instancia in number,
                         lc_user      in varchar2,
                         lc_prgm      in varchar2,
                         lc_Sector    out varchar2);
  ---------------------------------------------------------------
  procedure sp_cr_CompraDeuda(ld_pgfape        in date,
                              ln_codcat        in number,
                              ln_codcamp       in number,
                              lc_TAG           in varchar2,
                              ln_instancia     in number,
                              lc_user          in varchar2,
                              lc_prgm          in varchar2,
                              ln_MntComprDeuda out number);
  ----------------------------------------------------
  procedure sp_Cr_DeudaIFIS(ld_pgfape       in date,
                            ln_codcat       in number,
                            ln_codcamp      in number,
                            lc_TAG          in varchar2,
                            ln_instancia    in number,
                            lc_user         in varchar2,
                            lc_prgm         in varchar2,
                            ln_MntDeudaIFIS out number);
  ----------------------------------------------------
  procedure sp_Cr_ResultNetExcntMns(ld_pgfape        in date,
                                    ln_codcat        in number,
                                    ln_codcamp       in number,
                                    lc_TAG           in varchar2,
                                    ln_instancia     in number,
                                    lc_user          in varchar2,
                                    lc_prgm          in varchar2,
                                    ln_RslNtoExcMens out varchar2);
  --------------------------------------------------------
  procedure sp_cr_RelCredDias(ld_pgfape      in date,
                              ln_codcat      in number,
                              ln_codcamp     in number,
                              lc_TAG         in varchar2,
                              ln_instancia   in number,
                              lc_user        in varchar2,
                              lc_prgm        in varchar2,
                              ln_RelCredDias out varchar2);
  ---------------------------------------------------------
  procedure sp_cr_Garantia(ld_pgfape    in date,
                           ln_codcat    in number,
                           ln_codcamp   in number,
                           lc_TAG       in varchar2,
                           ln_instancia in number,
                           lc_user      in varchar2,
                           lc_prgm      in varchar2,
                           lc_Garantias out varchar2);
  -------------------------------------------------------------
  procedure sp_cr_LogAQPB170(ld_pgfape  in date,
                             ln_codcat  in number,
                             ln_codcamp in number,
                             lc_TAG     in varchar2,
                             ln_inst    in number,
                             lc_user    in varchar2,
                             lc_prg     in varchar2,
                             lc_valor   in varchar2,
                             lc_aux1    in varchar2,
                             lc_aux2    in varchar2,
                             lc_au3     in varchar2);

end PQ_CR_DATOS_APROBACION;
/
create or replace package body PQ_CR_DATOS_APROBACION is
  -- *****************************************************************
  -- Nombre                     : PAQUETES PARA OBTENER DATOS EN APROBACION
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 29/08/2023 17:12:10
  -- Autor de Creación          : MARIA POSTIGO
  -- Uso                        : Devuelve valores
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :
  --
  --
  --
  -- *****************************************************************

  procedure sp_cr_RatioCR(ld_pgfape    in date,
                          ln_codcat    in number,
                          ln_codcamp   in number,
                          lc_TAG       in varchar2,
                          ln_instancia in number,
                          lc_user      in varchar2,
                          lc_prgm      in varchar2,
                          lc_valor     out varchar2) is
  
    /*ln_pais        number;
    ln_tdoc        number;
    lc_ndoc        varchar2(12);
    ln_TipoCamb    number(14, 8);
    ln_CapCaja     number(17, 2);
    ln_DeudaIFIS   number(17, 2);
    ln_ResultNeto  number(17, 2);*/
    ln_Ratio   number(10, 6);
    ln_ModEval number;
    --ln_ExcdMensual number;
  
  begin
  
    begin
      update aqpb170 a
         set a.aqpb170est = 'I'
       where a.aqpb170inst = ln_instancia
         and a.aqpb170codcat = ln_codcat
         and a.aqpb170codcamp = ln_codcamp;
      commit;
    end;
  
    /* begin
      select SNG001PAIS, SNG001TDOC, SNG001NDOC
        into ln_pais, ln_tdoc, lc_ndoc
        from SNG001
       Where SNG001Inst = ln_instancia;
    exception
      when others then
        null;
    end;
    
    begin
      select SNG120TCbi
        into ln_TipoCamb
        from sng120
       where SNG120Ins = ln_instancia
         and SNG120Tsk = 'EVALUACION';
    exception
      when others then
        null;
    end;*/
  
    begin
      select s.sng021tmod
        into ln_ModEval
        from sng021 s
       where s.sng021sol = ln_instancia;
    exception
      when others then
        ln_ModEval := 0;
    end;
  
    if ln_ModEval = 13 then
      /* begin
        pq_cr_resolutor_cappago.sp_InicioRatio(ln_Pepais     => ln_pais,
                                               ln_Petdoc     => ln_tdoc,
                                               ln_Pendoc     => lc_ndoc,
                                               tipocambio    => ln_TipoCamb,
                                               Instancia     => ln_instancia,
                                               pd_fecpro     => ld_pgfape,
                                               lc_prgm       => 'RJAQY139',
                                               lc_Usuario    => lc_user,
                                               ln_captotcaja => ln_CapCaja,
                                               saldo_externo => ln_DeudaIFIS,
                                               ResultNeto    => ln_ResultNeto,
                                               ln_captotal   => ln_Ratio);
      exception
        when others then
          null;
      end;*/
      begin
        select j.jaqy140ratio
          into ln_Ratio
          from jaqy140 j
         where j.jaqy140inst = ln_instancia
           and j.jaqy140est = 'H'
           and j.jaqy140tarea = 7;
      exception
        when others then
          ln_Ratio := 0;
      end;
    
    else
      if ln_ModEval = 14 then
        /*begin
          pq_cr_ratio_cuocnsm.sp_CalculoRatio(ln_Pepais        => ln_pais,
                                              ln_Petdoc        => ln_tdoc,
                                              ln_Pendoc        => lc_ndoc,
                                              tipocambio       => ln_TipoCamb,
                                              Instancia        => ln_instancia,
                                              pd_fecpro        => ld_pgfape,
                                              lc_prgm          => 'RJAQZ821',
                                              ln_Usuario       => lc_user,
                                              ln_captotcaja    => ln_CapCaja,
                                              saldo_externo    => ln_DeudaIFIS,
                                              ln_ExcdntMensual => ln_ExcdMensual,
                                              ln_RatioConsumo  => ln_Ratio);
        end;*/
      
        begin
          select j.jaqz821ratio
            into ln_Ratio
            from jaqz821 j
           where j.jaqz821inst = ln_instancia
             and j.jaqz821est = 'H'
             and j.jaqz821tarea = 7;
        exception
          when others then
            ln_Ratio := 0;
        end;
      
      end if;
    end if;
  
    lc_valor := ln_Ratio * 100;
  
    begin
      -- Call the procedure
      pq_cr_datos_aprobacion.sp_cr_logaqpb170(ld_pgfape,
                                              ln_codcat,
                                              ln_codcamp,
                                              lc_TAG,
                                              ln_instancia,
                                              lc_user,
                                              lc_prgm,
                                              lc_valor,
                                              '',
                                              '',
                                              '');
    exception
      when others then
        null;
    end;
  
  end sp_cr_RatioCR;
  -------------------------------------------------------
  procedure sp_Cr_Segmento(ld_pgfape    in date,
                           ln_codcat    in number,
                           ln_codcamp   in number,
                           lc_TAG       in varchar2,
                           ln_Instancia in number,
                           lc_user      in varchar2,
                           lc_prgm      in varchar2,
                           lc_Segmento  out varchar2) is
  
    ln_SegmntoActual number;
  
  begin
  
    begin
      update aqpb170 a
         set a.aqpb170est = 'I'
       where a.aqpb170inst = ln_instancia
         and a.aqpb170codcat = ln_codcat
         and a.aqpb170codcamp = ln_codcamp;
      commit;
    end;
  
    lc_Segmento := 'Otros';
    pq_cr_rte_verificasegmento.sp_cr_SegmntoActual(ln_Instancia,
                                                   ln_SegmntoActual);
  
    if ln_SegmntoActual = 1 then
      lc_Segmento := 'Independiente';
    else
      if ln_SegmntoActual = 2 then
        lc_Segmento := 'Dependiente';
      end if;
    end if;
  
    begin
      -- Call the procedure
      pq_cr_datos_aprobacion.sp_cr_logaqpb170(ld_pgfape,
                                              ln_codcat,
                                              ln_codcamp,
                                              lc_TAG,
                                              ln_instancia,
                                              lc_user,
                                              lc_prgm,
                                              lc_Segmento,
                                              '',
                                              '',
                                              '');
    exception
      when others then
        null;
    end;
  
  end sp_Cr_Segmento;
  -------------------------------------------------------
  procedure sp_Cr_SegmentacionSol(ld_pgfape       in date,
                                  ln_codcat       in number,
                                  ln_codcamp      in number,
                                  lc_TAG          in varchar2,
                                  ln_instancia    in number,
                                  lc_user         in varchar2,
                                  lc_prgm         in varchar2,
                                  lc_Segmentacion out varchar2) is
  
    ln_SegmntoActual number;
    ln_modulo        number;
    lc_SegmntcnAnt   varchar2(250);
    lc_IndCambSeg    varchar2(25) := 'NO';
    ln_TuvoCambSegm  number;
  
  begin
  
    begin
      update aqpb170 a
         set a.aqpb170est = 'I'
       where a.aqpb170inst = ln_instancia
         and a.aqpb170codcat = ln_codcat
         and a.aqpb170codcamp = ln_codcamp;
      commit;
    end;
  
    begin
      select count(*)
        into ln_TuvoCambSegm
        from jaqz870 j
       where j.jaqz870inst = ln_instancia
         and j.jaqz870esta = 'S';
    exception
      when others then
        null;
    end;
  
    if ln_TuvoCambSegm > 0 then
    
      lc_IndCambSeg := 'SI';
    
      begin
        select j.jaqz870segi, j.jaqz870segf
          into lc_Segmentacion, lc_SegmntcnAnt
          from jaqz870 j
         where j.jaqz870inst = ln_instancia
           and j.jaqz870esta = 'S';
      EXCEPTION
        when others then
          lc_Segmentacion := null;
          lc_SegmntcnAnt  := null;
      end;
    
    else
      if ln_TuvoCambSegm = 0 then
        begin
          select x.xwfmodulo
            into ln_modulo
            from xwf700 x
           where x.xwfprcins = ln_Instancia
             and x.xwfcar3 = '1';
        exception
          when others then
            ln_modulo := 0;
        end;
      
        pq_cr_rte_verificasegmento.sp_cr_SegmntoActual(ln_Instancia,
                                                       ln_SegmntoActual);
        --380 pyme
        --486 consumo
      
        if ln_SegmntoActual = 1 and ln_modulo <> 103 then
        
          begin
            select trim(REPLACE((REPLACE((REPLACE((REGEXP_REPLACE(p.pae71val,
                                                                  '[0-9]',
                                                                  '')),
                                                  ':',
                                                  '')),
                                         '/',
                                         '')),
                                '.',
                                ''))
              into lc_Segmentacion
              from fpae70 r, fpae71 p
             where r.pae51eva = p.pae51eva
               and r.pae70nro = p.pae70nro
               and r.pae70ins = ln_instancia
               and p.pae71ite = 486 --380(antiguo) 486 (nuevo) pyme 
               and r.pae51eva = 1
               and r.pae70nro = (select max(d.pae70nro)
                                   from fpae70 d
                                  where d.pae70ins = r.pae70ins
                                    and d.pae51eva = 1);
          exception
            when others then
              lc_Segmentacion := null;
          end;
        else
          if ln_SegmntoActual = 1 and ln_modulo = 103 then
          
            begin
              select trim(REPLACE((REPLACE((REPLACE((REGEXP_REPLACE(p.pae71val,
                                                                    '[0-9]',
                                                                    '')),
                                                    ':',
                                                    '')),
                                           '/',
                                           '')),
                                  '.',
                                  ''))
                into lc_Segmentacion
                from fpae70 r, fpae71 p
               where r.pae51eva = p.pae51eva
                 and r.pae70nro = p.pae70nro
                 and r.pae70ins = ln_instancia
                 and p.pae71ite = 338 -- micro 
                 and r.pae51eva = 1
                 and r.pae70nro = (select max(d.pae70nro)
                                     from fpae70 d
                                    where d.pae70ins = r.pae70ins
                                      and d.pae51eva = 1);
            exception
              when others then
                lc_Segmentacion := null;
            end;
          else
            if ln_SegmntoActual = 2 then
            
              begin
                select trim(REPLACE((REPLACE((REPLACE((REGEXP_REPLACE(p.pae71val,
                                                                      '[0-9]',
                                                                      '')),
                                                      ':',
                                                      '')),
                                             '/',
                                             '')),
                                    '.',
                                    ''))
                  into lc_Segmentacion
                  from fpae70 r, fpae71 p
                 where r.pae51eva = p.pae51eva
                   and r.pae70nro = p.pae70nro
                   and r.pae70ins = ln_instancia
                   and p.pae71ite = 446 -- Consumo
                   and r.pae51eva = 1
                   and r.pae70nro = (select max(d.pae70nro)
                                       from fpae70 d
                                      where d.pae70ins = r.pae70ins
                                        and d.pae51eva = 1);
              exception
                when others then
                  lc_Segmentacion := null;
              end;
            end if;
          end if;
        end if;
      end if;
    end if;
  
    /* begin
      -- Call the procedure
      pq_cr_seg_excep.sp_cr_segmentacion(instancia    => ln_Instancia,
                                         modulo       => ln_modulo,
                                         segmento     => ln_SegmntoActual,
                                         segmentacion => lc_Segmentacion);
    end;*/
  
    if lc_SegmntcnAnt is null then
      lc_SegmntcnAnt := lc_Segmentacion;
    end if;
  
    begin
      -- Call the procedure
      pq_cr_datos_aprobacion.sp_cr_logaqpb170(ld_pgfape,
                                              ln_codcat,
                                              ln_codcamp,
                                              lc_TAG,
                                              ln_instancia,
                                              lc_user,
                                              lc_prgm,
                                              lc_Segmentacion,
                                              lc_SegmntcnAnt,
                                              lc_IndCambSeg,
                                              '');
    exception
      when others then
        null;
    end;
  
  end sp_Cr_SegmentacionSol;
  --------------------------------------------------------
  procedure sp_Cr_SegmentacionAnterior(ln_instancia      in number,
                                       lc_SegmntAnterior out varchar2,
                                       lc_IndCambSegmnt  out varchar2) is
  
  begin
  
    begin
      select a.aqpb170aux1, a.aqpb170aux2
        into lc_SegmntAnterior, lc_IndCambSegmnt
        from aqpb170 a
       where a.aqpb170tag = 'SEGMENTACION'
         and a.aqpb170inst = ln_instancia
         and a.aqpb170est = 'H';
    exception
      when others then
        lc_SegmntAnterior := null;
        lc_IndCambSegmnt  := null;
    end;
  
    if lc_IndCambSegmnt is null then
      lc_IndCambSegmnt := 'NO';
    end if;
  
  end sp_Cr_SegmentacionAnterior;
  --------------------------------------------------------
  procedure sp_cr_aval(ld_pgfape    in date,
                       ln_codcat    in number,
                       ln_codcamp   in number,
                       lc_TAG       in varchar2,
                       ln_instancia in number,
                       lc_user      in varchar2,
                       lc_prgm      in varchar2,
                       lc_Aval      out varchar2) is
    ln_NroAval number;
  begin
  
    begin
      update aqpb170 a
         set a.aqpb170est = 'I'
       where a.aqpb170inst = ln_instancia
         and a.aqpb170codcat = ln_codcat
         and a.aqpb170codcamp = ln_codcamp;
      commit;
    end;
  
    -- Aval 
    begin
      select count(*)
        into ln_NroAval
        from sng003 s
       where s.sng001inst = ln_instancia;
    exception
      when others then
        null;
    end;
  
    if ln_NroAval > 0 then
      lc_Aval := 'SI';
    else
      lc_Aval := 'NO';
    end if;
  
    begin
      -- Call the procedure
      pq_cr_datos_aprobacion.sp_cr_logaqpb170(ld_pgfape,
                                              ln_codcat,
                                              ln_codcamp,
                                              lc_TAG,
                                              ln_instancia,
                                              lc_user,
                                              lc_prgm,
                                              lc_Aval,
                                              '',
                                              '',
                                              '');
    exception
      when others then
        null;
    end;
  
  end sp_cr_aval;
  -----------------------------------------------
  procedure sp_cr_CredVigentes(ld_pgfape     in date,
                               ln_codcat     in number,
                               ln_codcamp    in number,
                               lc_TAG        in varchar2,
                               ln_instancia  in number,
                               lc_user       in varchar2,
                               lc_prgm       in varchar2,
                               ln_NroCredVig out varchar2) is
  
  begin
  
    begin
      update aqpb170 a
         set a.aqpb170est = 'I'
       where a.aqpb170inst = ln_instancia
         and a.aqpb170codcat = ln_codcat
         and a.aqpb170codcamp = ln_codcamp;
      commit;
    end;
  
    -- Creditos Vigentes en Caja
    begin
      select count(*)
        into ln_NroCredVig
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
    exception
      when others then
        ln_NroCredVig := 0;
    end;
  
    begin
      -- Call the procedure
      pq_cr_datos_aprobacion.sp_cr_logaqpb170(ld_pgfape,
                                              ln_codcat,
                                              ln_codcamp,
                                              lc_TAG,
                                              ln_instancia,
                                              lc_user,
                                              lc_prgm,
                                              ln_NroCredVig,
                                              '',
                                              '',
                                              '');
    exception
      when others then
        null;
    end;
  
  end sp_cr_CredVigentes;
  ------------------------------------------
  procedure sp_cr_RatioEnd(ld_pgfape    in date,
                           ln_codcat    in number,
                           ln_codcamp   in number,
                           lc_TAG       in varchar2,
                           ln_instancia in number,
                           lc_user      in varchar2,
                           lc_prgm      in varchar2,
                           ln_RatioEnd  out varchar2) is
  
    /*  ln_pais       number;
    ln_tdoc       number;
    lc_ndoc       varchar2(12);
    ln_TipoCamb   number(14, 8);
    ln_captotcaja number(17, 2) := 0.00;*/
    -- ld_FchSist date;
  
  begin
  
    /* begin
      select f.pgfape into ld_FchSist from fst017 f where f.pgcod = 1;
    exception
      when others then
        ld_FchSist := null;
    end;*/
  
    begin
      update aqpb170 a
         set a.aqpb170est = 'I'
       where a.aqpb170inst = ln_instancia
         and a.aqpb170codcat = ln_codcat
         and a.aqpb170codcamp = ln_codcamp;
      commit;
    end;
  
    /*begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_pais, ln_tdoc, lc_ndoc
        from sng001 s
       where s.sng001inst = ln_instancia;
    exception
      when others then
        null;
    end;
    
    begin
      select SNG120TCbi
        into ln_TipoCamb
        from sng120
       where SNG120Ins = ln_instancia
         and SNG120Tsk = 'EVALUACION';
    exception
      when others then
        null;
    end;*/
  
    -- Ratio Endeudamiento
    begin
      -- Call the procedure
      /* pq_cr_saldopyme.sp_cuentasratio(ln_pepais     => ln_pais,
      ln_petdoc     => ln_tdoc,
      ln_pendoc     => lc_ndoc,
      tipocambio    => ln_TipoCamb,
      instancia     => ln_instancia,
      pd_fecpro     => ld_FchSist,
      lc_prgm       => 'RJAQZ811',
      ln_captotcaja => ln_captotcaja);*/
    
      begin
        select j.jaqy147ratio * 100
          into ln_RatioEnd
          from jaqy147 j
         where j.jaqy147inst = ln_instancia
           and j.jaqy147est = 'H'
           and j.jaqy147tarea = 7;
      exception
        when others then
          ln_RatioEnd := null;
      end;
    end;
    ln_RatioEnd := nvl(ln_RatioEnd, 0);
  
    begin
      -- Call the procedure
      pq_cr_datos_aprobacion.sp_cr_logaqpb170(ld_pgfape,
                                              ln_codcat,
                                              ln_codcamp,
                                              lc_TAG,
                                              ln_instancia,
                                              lc_user,
                                              lc_prgm,
                                              ln_RatioEnd,
                                              '',
                                              '',
                                              '');
    exception
      when others then
        null;
    end;
  
  end sp_cr_RatioEnd;
  ----------------------------------------------
  procedure sp_Cr_RiesgCamb(ld_pgfape     in date,
                            ln_codcat     in number,
                            ln_codcamp    in number,
                            lc_TAG        in varchar2,
                            ln_instancia  in number,
                            lc_user       in varchar2,
                            lc_prgm       in varchar2,
                            lc_RiesgoCamb out varchar2) is
  
    lc_RiesgoAux varchar2(5);
  
  begin
  
    begin
      update aqpb170 a
         set a.aqpb170est = 'I'
       where a.aqpb170inst = ln_instancia
         and a.aqpb170codcat = ln_codcat
         and a.aqpb170codcamp = ln_codcamp;
      commit;
    end;
  
    --Riesgo Cambiario
    begin
      select trim(w.wfattsval)
        into lc_RiesgoAux
        from wfattsvalues w
       where w.wfinsprcid = ln_instancia
         and w.wfattsid = 'RIESGO_CAMBIARIO';
    exception
      when others then
        lc_RiesgoAux := null;
    end;
  
    if lc_RiesgoAux = 'N' then
      lc_RiesgoCamb := 'NO';
    
    else
      if lc_RiesgoAux = 'S' then
        lc_RiesgoCamb := 'SI';
      
      end if;
    end if;
    begin
      -- Call the procedure
      pq_cr_datos_aprobacion.sp_cr_logaqpb170(ld_pgfape,
                                              ln_codcat,
                                              ln_codcamp,
                                              lc_TAG,
                                              ln_instancia,
                                              lc_user,
                                              lc_prgm,
                                              lc_RiesgoCamb,
                                              '',
                                              '',
                                              '');
    exception
      when others then
        null;
    end;
  
  end sp_Cr_RiesgCamb;
  -----------------------------------------                                   
  procedure sp_Cr_TipoCred(ld_pgfape    in date,
                           ln_codcat    in number,
                           ln_codcamp   in number,
                           lc_TAG       in varchar2,
                           ln_instancia in number,
                           lc_user      in varchar2,
                           lc_prgm      in varchar2,
                           lc_TipoCred  out varchar2) is
  
    ln_70nro   number;
    ln_val     number;
    lc_valchar varchar2(5);
  
  begin
  
    begin
      update aqpb170 a
         set a.aqpb170est = 'I'
       where a.aqpb170inst = ln_instancia
         and a.aqpb170codcat = ln_codcat
         and a.aqpb170codcamp = ln_codcamp;
      commit;
    end;
  
    -- TIPO_CREDITO
    /*  begin
      select trim(w.wfattsval)
        into lc_tipocred
        from wfattsvalues w
       where w.wfinsprcid = ln_instancia
         and w.wfattsid = 'TIPO_CREDITO';
    exception
      when others then
        null;
    end;*/
  
    -- if lc_TipoCred is null then
  
    begin
      select max(f.pae70nro)
        into ln_70nro
        from fpae70 f
       where f.pae70ins = ln_instancia
         and f.pae51eva = 2;
    exception
      when others then
        ln_70nro := 0;
    end;
  
    if ln_70nro > 0 then
    
      begin
        select to_number(f.pae71val)
          into ln_val
          from fpae71 f
         where f.pae51eva = 2
           and f.pae70nro = ln_70nro
           and f.pae71ite = 101;
      exception
        when others then
          ln_val := null;
      end;
    
      if ln_val < 10 then
        lc_valchar := '0' || to_char(ln_val) || '%';
      else
        lc_valchar := to_char(ln_val) || '%';
      end if;
    
      begin
        select distinct (f.rng50ret)
          into lc_TipoCred
          from frng50 f
         where f.rng49cod = 1510
           and f.rng50ret like lc_valchar;
      exception
        when others then
          lc_TipoCred := 'Sin Información';
      end;
    else
      lc_TipoCred := 'Sin Información';
    end if;
  
    begin
      -- Call the procedure
      pq_cr_datos_aprobacion.sp_cr_logaqpb170(ld_pgfape,
                                              ln_codcat,
                                              ln_codcamp,
                                              lc_TAG,
                                              ln_instancia,
                                              lc_user,
                                              lc_prgm,
                                              lc_TipoCred,
                                              '',
                                              '',
                                              '');
    exception
      when others then
        null;
    end;
  
  end sp_Cr_TipoCred;
  ---------------------------------------------------
  procedure sp_Cr_Sector(ld_pgfape    in date,
                         ln_codcat    in number,
                         ln_codcamp   in number,
                         lc_TAG       in varchar2,
                         ln_instancia in number,
                         lc_user      in varchar2,
                         lc_prgm      in varchar2,
                         lc_Sector    out varchar2) is
  
    ln_70nro number;
    -- ln_val   number;
  begin
  
    begin
      update aqpb170 a
         set a.aqpb170est = 'I'
       where a.aqpb170inst = ln_instancia
         and a.aqpb170codcat = ln_codcat
         and a.aqpb170codcamp = ln_codcamp;
      commit;
    end;
  
    --Sector
    /*   begin
      select trim(w.wfattsval)
        into lc_Sector
        from wfattsvalues w
       where w.wfinsprcid = ln_instancia
         and w.wfattsid = 'SECTOR';
    exception
      when others then
        null;
    end;*/
  
    begin
      select max(f.pae70nro)
        into ln_70nro
        from fpae70 f
       where f.pae70ins = ln_instancia
         and f.pae51eva = 2;
    exception
      when others then
        ln_70nro := null;
    end;
  
    begin
      select to_number(f.pae71val)
        into lc_Sector
        from fpae71 f
       where f.pae51eva = 2
         and f.pae70nro = ln_70nro
         and f.pae71ite = 132;
    exception
      when others then
        null;
    end;
  
    begin
      -- Call the procedure
      pq_cr_datos_aprobacion.sp_cr_logaqpb170(ld_pgfape,
                                              ln_codcat,
                                              ln_codcamp,
                                              lc_TAG,
                                              ln_instancia,
                                              lc_user,
                                              lc_prgm,
                                              lc_Sector,
                                              '',
                                              '',
                                              '');
    exception
      when others then
        null;
    end;
  end sp_Cr_Sector;
  ------------------------------------------------
  procedure sp_cr_CompraDeuda(ld_pgfape        in date,
                              ln_codcat        in number,
                              ln_codcamp       in number,
                              lc_TAG           in varchar2,
                              ln_instancia     in number,
                              lc_user          in varchar2,
                              lc_prgm          in varchar2,
                              ln_MntComprDeuda out number) is
    ln_SegmntoActual number;
  
  begin
  
    begin
      update aqpb170 a
         set a.aqpb170est = 'I'
       where a.aqpb170inst = ln_instancia
         and a.aqpb170codcat = ln_codcat
         and a.aqpb170codcamp = ln_codcamp;
      commit;
    end;
  
    -- Compra de Deuda
    pq_cr_rte_verificasegmento.sp_cr_SegmntoActual(ln_Instancia,
                                                   ln_SegmntoActual);
    if ln_SegmntoActual = 1 then
    
      begin
        select sum(j.jaqy327sdeu)
          into ln_MntComprDeuda
          from jaqy327 j
         where j.jaqy327inst = ln_instancia
           and j.jaqy327esta = 'S'
           and j.jaqy327aux4 = '1';
      exception
        when others then
          ln_MntComprDeuda := 0;
      end;
    
      ln_MntComprDeuda := nvl(ln_MntComprDeuda, 0);
    
    else
      if ln_SegmntoActual = 2 then
      
        begin
          select sum(j.jaqz862sdeu)
            into ln_MntComprDeuda
            from jaqz862 j
           where j.jaqz862inst = ln_instancia
             and j.jaqz862esta = 'S'
             and j.jaqz862aux4 = '1';
        exception
          when others then
            ln_MntComprDeuda := null;
        end;
      
        ln_MntComprDeuda := nvl(ln_MntComprDeuda, 0);
      
      end if;
    
    end if;
  
    begin
      -- Call the procedure
      pq_cr_datos_aprobacion.sp_cr_logaqpb170(ld_pgfape,
                                              ln_codcat,
                                              ln_codcamp,
                                              lc_TAG,
                                              ln_instancia,
                                              lc_user,
                                              lc_prgm,
                                              ln_MntComprDeuda,
                                              '',
                                              '',
                                              '');
    exception
      when others then
        null;
    end;
  end sp_Cr_CompraDeuda;
  -----------------------------------------------------------
  procedure sp_Cr_DeudaIFIS(ld_pgfape       in date,
                            ln_codcat       in number,
                            ln_codcamp      in number,
                            lc_TAG          in varchar2,
                            ln_instancia    in number,
                            lc_user         in varchar2,
                            lc_prgm         in varchar2,
                            ln_MntDeudaIFIS out number) is
  
    ln_SegmntoActual number;
  
  begin
    ln_MntDeudaIFIS := 0;
  
    begin
      update aqpb170 a
         set a.aqpb170est = 'I'
       where a.aqpb170inst = ln_instancia
         and a.aqpb170codcat = ln_codcat
         and a.aqpb170codcamp = ln_codcamp;
      commit;
    end;
  
    pq_cr_rte_verificasegmento.sp_cr_SegmntoActual(ln_Instancia,
                                                   ln_SegmntoActual);
    if ln_SegmntoActual = 1 then
    
      begin
        select sum(j.jaqy327sdeu)
          into ln_MntDeudaIFIS
          from jaqy327 j
         where j.jaqy327inst = ln_instancia
           and j.jaqy327esta = 'S'
           and j.jaqy327chek = '1';
      exception
        when others then
          ln_MntDeudaIFIS := 0;
      end;
    
      ln_MntDeudaIFIS := nvl(ln_MntDeudaIFIS, 0);
    
    else
      if ln_SegmntoActual = 2 then
        begin
          select sum(j.jaqz862sdeu)
            into ln_MntDeudaIFIS
            from jaqz862 j
           where j.jaqz862inst = ln_instancia
             and j.jaqz862esta = 'S'
             and j.jaqz862chek = '1';
        exception
          when others then
            ln_MntDeudaIFIS := 0;
        end;
      
        ln_MntDeudaIFIS := nvl(ln_MntDeudaIFIS, 0);
      
      end if;
    end if;
  
    begin
      -- Call the procedure
      pq_cr_datos_aprobacion.sp_cr_logaqpb170(ld_pgfape,
                                              ln_codcat,
                                              ln_codcamp,
                                              lc_TAG,
                                              ln_instancia,
                                              lc_user,
                                              lc_prgm,
                                              ln_MntDeudaIFIS,
                                              '',
                                              '',
                                              '');
    exception
      when others then
        null;
    end;
  
  end sp_Cr_DeudaIFIS;
  --------------------------------------------------------
  procedure sp_Cr_ResultNetExcntMns(ld_pgfape        in date,
                                    ln_codcat        in number,
                                    ln_codcamp       in number,
                                    lc_TAG           in varchar2,
                                    ln_instancia     in number,
                                    lc_user          in varchar2,
                                    lc_prgm          in varchar2,
                                    ln_RslNtoExcMens out varchar2) is
  
    ln_NroEval     number;
    ln_Tmod        number;
    ln_ExcdMensSol number(17, 2) := 0;
    ln_ExcdMensDol number(17, 2) := 0;
    ln_ResNetSol   number(17, 2) := 0;
    ln_ResNetDol   number(17, 2) := 0;
  
  begin
  
    begin
      update aqpb170 a
         set a.aqpb170est = 'I'
       where a.aqpb170inst = ln_instancia
         and a.aqpb170codcat = ln_codcat
         and a.aqpb170codcamp = ln_codcamp;
      commit;
    end;
  
    begin
      select s.sng021eval, s.sng021tmod
        into ln_NroEval, ln_Tmod
        from sng021 s
       where s.sng021sol = ln_instancia;
    exception
      when others then
        ln_NroEval := 0;
        ln_Tmod    := 0;
    end;
  
    if ln_Tmod = 13 then
      begin
        select d.sng023mto
          into ln_ResNetSol
          from sng023 d
         where d.sng021eval = ln_NroEval
           and d.sng026cod = 40;
      exception
        when others then
          ln_ResNetSol := 0;
      end;
    
      begin
        select d.sng023mto *
               fn_tipo_cambio_fijo(P_FECHA => (select f.pgfape
                                                 from fst017 f
                                                where f.pgcod = 1))
          into ln_ResNetDol
          from sng023 d
         where d.sng021eval = ln_NroEval
           and d.sng026cod = 540;
      exception
        when others then
          ln_ResNetDol := 0;
      end;
      ln_RslNtoExcMens := nvl(ln_ResNetSol, 0) + nvl(ln_ResNetDol, 0);
    
    else
      if ln_Tmod = 14 then
      
        begin
          select d.sng023mto
            into ln_ExcdMensSol
            from sng023 d
           where d.sng021eval = ln_NroEval
             and d.sng026cod = 27;
        exception
          when others then
            ln_ExcdMensSol := 0;
        end;
      
        begin
          select d.sng023mto *
                 fn_tipo_cambio_fijo(P_FECHA => (select f.pgfape
                                                   from fst017 f
                                                  where f.pgcod = 1))
            into ln_ExcdMensDol
            from sng023 d
           where d.sng021eval = ln_NroEval
             and d.sng026cod = 527;
        exception
          when others then
            ln_ExcdMensDol := 0;
        end;
        ln_RslNtoExcMens := nvl(ln_ExcdMensSol, 0) + nvl(ln_ExcdMensDol, 0);
      end if;
    end if;
  
    begin
      -- Call the procedure
      pq_cr_datos_aprobacion.sp_cr_logaqpb170(ld_pgfape,
                                              ln_codcat,
                                              ln_codcamp,
                                              lc_TAG,
                                              ln_instancia,
                                              lc_user,
                                              lc_prgm,
                                              ln_RslNtoExcMens,
                                              '',
                                              '',
                                              '');
    exception
      when others then
        null;
    end;
  
  end sp_Cr_ResultNetExcntMns;
  ---------------------------------------------------------
  procedure sp_cr_RelCredDias(ld_pgfape      in date,
                              ln_codcat      in number,
                              ln_codcamp     in number,
                              lc_TAG         in varchar2,
                              ln_instancia   in number,
                              lc_user        in varchar2,
                              lc_prgm        in varchar2,
                              ln_RelCredDias out varchar2) is
  
    ln_pais    number;
    ln_tdoc    number;
    lc_ndoc    varchar2(12);
    ld_FchSist date;
  
  begin
  
    begin
      update aqpb170 a
         set a.aqpb170est = 'I'
       where a.aqpb170inst = ln_instancia
         and a.aqpb170codcat = ln_codcat
         and a.aqpb170codcamp = ln_codcamp;
      commit;
    end;
  
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_pais, ln_tdoc, lc_ndoc
        from sng001 s
       where s.sng001inst = ln_instancia;
    exception
      when others then
        ln_pais := 0;
        ln_tdoc := 0;
        lc_ndoc := null;
    end;
  
    begin
      select f.pgfape into ld_FchSist from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    Pq_Cr_Relcrediticia_a.Sp_cr_ReCalcula(pn_pais     => ln_pais,
                                          pn_tdo      => ln_tdoc,
                                          pc_ndo      => lc_ndoc,
                                          pd_fecpro   => ld_FchSist,
                                          ln_contador => ln_RelCredDias);
  
    ln_RelCredDias := nvl(ln_RelCredDias, 0);
  
    ln_RelCredDias := ln_RelCredDias || ' dias.';
  
    begin
      -- Call the procedure
      pq_cr_datos_aprobacion.sp_cr_logaqpb170(ld_pgfape,
                                              ln_codcat,
                                              ln_codcamp,
                                              lc_TAG,
                                              ln_instancia,
                                              lc_user,
                                              lc_prgm,
                                              ln_RelCredDias,
                                              '',
                                              '',
                                              '');
    exception
      when others then
        null;
    end;
  
  end sp_cr_RelCredDias;
  ---------------------------------------------------------
  procedure sp_cr_Garantia(ld_pgfape    in date,
                           ln_codcat    in number,
                           ln_codcamp   in number,
                           lc_TAG       in varchar2,
                           ln_instancia in number,
                           lc_user      in varchar2,
                           lc_prgm      in varchar2,
                           lc_Garantias out varchar2) is
  
    cursor garantias is
      select distinct f.modulo, f.totope, f.tonom
        from sng122 s, fst004 f
       where s.sng122mod = f.modulo
         and s.sng122tope = f.totope
         and s.sng122inst = ln_instancia;
  
    lc_GarAux    varchar2(50);
    cont         number := 0;
    lc_separador varchar2(5);
  
  begin
  
    lc_Garantias := null;
  
    begin
      update aqpb170 a
         set a.aqpb170est = 'I'
       where a.aqpb170inst = ln_instancia
         and a.aqpb170codcat = ln_codcat
         and a.aqpb170codcamp = ln_codcamp;
      commit;
    end;
  
    --- Garantia  
  
    for g in garantias loop
    
      if cont > 0 then
        lc_separador := ',';
      end if;
    
      lc_GarAux    := lc_separador || to_char(g.modulo) || '/' ||
                      to_char(g.totope) || '-' || trim(g.tonom);
      lc_Garantias := lc_Garantias || trim(lc_GarAux);
      cont         := cont + 1;
    
    end loop;
  
    if lc_Garantias is null then
    
      lc_Garantias := 'No Registra Garantias Asociadas';
    
    end if;
  
    begin
      -- Call the procedure
      pq_cr_datos_aprobacion.sp_cr_logaqpb170(ld_pgfape,
                                              ln_codcat,
                                              ln_codcamp,
                                              lc_TAG,
                                              ln_instancia,
                                              lc_user,
                                              lc_prgm,
                                              lc_Garantias,
                                              '',
                                              '',
                                              '');
    exception
      when others then
        null;
    end;
  
  end sp_cr_Garantia;
  -------------------------------------------------------
  procedure sp_cr_LogAQPB170(ld_pgfape  in date,
                             ln_codcat  in number,
                             ln_codcamp in number,
                             lc_TAG     in varchar2,
                             ln_inst    in number,
                             lc_user    in varchar2,
                             lc_prg     in varchar2,
                             lc_valor   in varchar2,
                             lc_aux1    in varchar2,
                             lc_aux2    in varchar2,
                             lc_au3     in varchar2) is
  
    ln_cor  number := 0;
    lc_hora char(8) := '00:00:00';
  
  begin
  
    begin
      select max(a.aqpb170cor)
        into ln_cor
        from aqpb170 a
       where a.aqpb170inst = ln_inst
         and a.aqpb170pgfape = ld_pgfape;
    exception
      when others then
        ln_cor := 0;
    end;
  
    ln_cor := nvl(ln_cor, 0);
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    exception
      when others then
        null;
    end;
  
    begin
      insert into aqpb170
        (aqpb170cor,
         aqpb170pgfape,
         aqpb170codcat,
         aqpb170codcamp,
         aqpb170tag,
         aqpb170inst,
         aqpb170hora,
         aqpb170user,
         aqpb170prg,
         aqpb170valor,
         aqpb170est,
         aqpb170aux1,
         aqpb170aux2,
         aqpb170aux3)
      values
        (ln_cor + 1,
         ld_pgfape,
         ln_codcat,
         ln_codcamp,
         lc_TAG,
         ln_inst,
         lc_hora,
         lc_user,
         lc_prg,
         lc_valor,
         'H',
         lc_aux1,
         lc_aux2,
         lc_au3);
    exception
      when others then
        null;
    end;
  
    commit;
  
  end sp_cr_LogAQPB170;
end PQ_CR_DATOS_APROBACION;
/
