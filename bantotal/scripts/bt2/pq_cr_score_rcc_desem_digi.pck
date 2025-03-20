create or replace package PQ_CR_SCORE_RCC_DESEM_DIGI is
  -- *****************************************************************
    -- Nombre                     : PAQUETE PARA SCORE DE CLIENTE - COPIA DE PQ_CR_SCORE_RCC
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 03/01/2023
    -- Autor de Creación          : IGS_RCASTRO
    -- Uso                        : Devuelve el score del cliente
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de Modificación      : 
    -- *****************************************************************

  procedure sp_cr_scoreDNI(ln_inst       in number,
                           ln_tdoc       in number,
                           lc_ndoc       in varchar2,
                           lc_prgm       in varchar2,
                           lc_user       in varchar2,
                           lc_score      out varchar2,
                           ln_probal     out number,
                           lc_SegmRiesgo out varchar2,
                           ln_PDCal      out number,
                           lc_tabla      out varchar2,
                           ld_fchscore   out date);
  -------------------------------------------------------------------
  procedure sp_cr_logAQPB166(ln_inst     in number,
                             ln_tdoc     in number,
                             lc_ndoc     in varchar2,
                             lc_user     in varchar2,
                             ld_fec      in date,
                             lc_prgm     in varchar2,
                             lc_score    in varchar2,
                             ln_probal   in number,
                             lc_segmrisk in varchar2,
                             ln_pdcal    in number,
                             lc_tabla    in varchar2,
                             ld_f639     in date,
                             ld_f640     in date);

end PQ_CR_SCORE_RCC_DESEM_DIGI;
/

create or replace package body PQ_CR_SCORE_RCC_DESEM_DIGI is
  
  ---------------------------------------------------------------
  procedure sp_cr_scoreDNI(ln_inst       in number,
                           ln_tdoc       in number,
                           lc_ndoc       in varchar2,
                           lc_prgm       in varchar2,
                           lc_user       in varchar2,
                           lc_score      out varchar2,
                           ln_probal     out number,
                           lc_SegmRiesgo out varchar2,
                           ln_PDCal      out number,
                           lc_tabla      out varchar2,
                           ld_fchscore   out date) is
    PRAGMA AUTONOMOUS_TRANSACTION;
    ln_fchsist       date;
    ln_MaxFch640     date;
    ln_MaxFch639     date;
    ln_probalauxcns  number;
    ln_probalauxpym  number;
    lc_scorecns      varchar2(10);
    lc_scorepym      varchar2(10);
    ln_PDCalcns      number;
    ln_PDCalpym      number;
    lc_SegmRiesgocns varchar2(10);
    lc_SegmRiesgopym varchar2(10);
  
  begin
  
    if lc_prgm = 'RAQPD052' then
      BEGIN
      update aqpb166 a
         set a.aqpb166est = 'I'
       where a.aqpb166inst = ln_inst
         and a.aqpb166est = 'H';
          commit;
      EXCEPTION 
        WHEN OTHERS THEN
          NULL;
      END;
    else
      BEGIN
      update aqpb166 a
         set a.aqpb166est = 'I'
       where a.aqpb166tdoc = ln_tdoc
         and a.aqpb166ndoc = lc_ndoc
         and a.aqpb166est = 'H';
           commit;  
            EXCEPTION 
        WHEN OTHERS THEN
          NULL;
       END;     
    end if;

  
    begin
      select f.pgfape into ln_fchsist from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      SELECT to_date(TP1DESC, 'dd/mm/rrrr')
          into ln_MaxFch640
          FROM fst198
         where tp1cod = 1
           and tp1cod1 = 11169
           and tp1corr1 = 2
           and tp1corr2 = 1
           and tp1corr3 = 2; --JAQL640
    exception
      when others then
        null;
    end;
  
    begin
      SELECT to_date(TP1DESC, 'dd/mm/rrrr')
          into ln_MaxFch639
          FROM fst198
         where tp1cod = 1
           and tp1cod1 = 11169
           and tp1corr1 = 2
           and tp1corr2 = 1
           and tp1corr3 = 1; --JAQL639
    exception
      when others then
        null;
    end;
  
    begin
      select j.jaql640prdef,
             j.jaql640riesg,
             j.jaql640segmen,
             j.jaql640pdcal
        into ln_probal, lc_score, lc_SegmRiesgo, ln_PDCal
        from jaql640 j
       where j.jaql640ptdoc = ln_tdoc
         and j.jaql640pndoc = RPAD(lc_ndoc, 12, ' ')
         and j.jaql640fepre = ln_MaxFch640;
    exception
      when others then
        lc_score      := 'SIN SCORE';
        ln_probal     := null;
        lc_SegmRiesgo := null;
        ln_PDCal      := null;
        lc_tabla      := null;
    end;
  
    if ln_probal > 0 then
      lc_tabla := 'JAQL640';
    end if;
  
    if lc_score = 'SIN SCORE' and ln_tdoc in (21, 2, 5) then
    
      begin
        select j.jaql639pdcns,
               j.jaql639pdmy,
               j.jaql639ricns,
               j.jaql639rimy,
               j.jaql639calmyp,
               j.jaql639calcns,
               j.jaql639segmyp,
               j.jaql639segcon
          into ln_probalauxcns,
               ln_probalauxpym,
               lc_scorecns,
               lc_scorepym,
               ln_PDCalcns,
               ln_PDCalpym,
               lc_SegmRiesgocns,
               lc_SegmRiesgopym
          from jaql639 j
         where j.jaql639nuide = lc_ndoc
           and j.jaql639fepre = ln_MaxFch639;
      exception
        when others then
          lc_score := 'SIN SCORE';
      end;
    
      if ln_probalauxcns > 0 and ln_probalauxpym > 0 then
        if ln_probalauxcns < ln_probalauxpym then
        
          ln_probal     := ln_probalauxcns;
          lc_score      := lc_scorecns;
          lc_SegmRiesgo := lc_SegmRiesgocns;
          ln_PDCal      := ln_PDCalcns;
          lc_tabla      := 'JAQL639';
        
        else
          if ln_probalauxcns >= ln_probalauxpym then
          
            ln_probal     := ln_probalauxpym;
            lc_score      := lc_scorepym;
            lc_SegmRiesgo := lc_SegmRiesgopym;
            ln_PDCal      := ln_PDCalpym;
            lc_tabla      := 'JAQL639';
          end if;
        end if;
      else
        lc_score      := 'SIN SCORE';
        ln_probal     := null;
        lc_SegmRiesgo := null;
        ln_PDCal      := null;
        lc_tabla      := null;
      
      end if;
    
    else
      if lc_score = 'SIN SCORE' and ln_tdoc not in (21, 2, 5) then
        begin
          select j.jaql639pdcns,
                 j.jaql639pdmy,
                 j.jaql639ricns,
                 j.jaql639rimy,
                 j.jaql639calmyp,
                 j.jaql639calcns,
                 j.jaql639segmyp,
                 j.jaql639segcon
            into ln_probalauxcns,
                 ln_probalauxpym,
                 lc_scorecns,
                 lc_scorepym,
                 ln_PDCalcns,
                 ln_PDCalpym,
                 lc_SegmRiesgocns,
                 lc_SegmRiesgopym
            from jaql639 j
           where j.jaql639nuruc = lc_ndoc
             and j.jaql639fepre = ln_MaxFch639;
        exception
          when others then
            null;
        end;
      
        if ln_probalauxcns > 0 and ln_probalauxpym > 0 then
          if ln_probalauxcns < ln_probalauxpym then
          
            ln_probal     := ln_probalauxcns;
            lc_score      := lc_scorecns;
            lc_SegmRiesgo := lc_SegmRiesgocns;
            ln_PDCal      := ln_PDCalcns;
            lc_tabla      := 'JAQL639';
          
          else
            if ln_probalauxcns >= ln_probalauxpym then
            
              ln_probal     := ln_probalauxpym;
              lc_score      := lc_scorepym;
              lc_SegmRiesgo := lc_SegmRiesgopym;
              ln_PDCal      := ln_PDCalpym;
              lc_tabla      := 'JAQL639';
            
            end if;
          end if;
        else
          lc_score      := 'SIN SCORE';
          ln_probal     := null;
          lc_SegmRiesgo := null;
          ln_PDCal      := null;
          lc_tabla      := null;
        
        end if;
      
      end if;
    end if;
  
    if lc_tabla = 'JAQL640' then
      ld_fchscore := ln_MaxFch640;
    else
      if lc_tabla = 'JAQL639' then
        ld_fchscore := ln_MaxFch639;
      end if;
    end if;
  
    begin
      PQ_CR_SCORE_RCC_DESEM_DIGI.sp_cr_logAQPB166(ln_inst,
                                       ln_tdoc,
                                       trim(lc_ndoc),
                                       lc_user,
                                       ln_fchsist,
                                       lc_prgm,
                                       lc_score,
                                       ln_probal,
                                       lc_SegmRiesgo,
                                       ln_pdcal,
                                       lc_tabla,
                                       ln_MaxFch639,
                                       ln_MaxFch640);
    end;
  end;
  ------------------------------------------------------------------------------
  procedure sp_cr_logAQPB166(ln_inst     in number,
                             ln_tdoc     in number,
                             lc_ndoc     in varchar2,
                             lc_user     in varchar2,
                             ld_fec      in date,
                             lc_prgm     in varchar2,
                             lc_score    in varchar2,
                             ln_probal   in number,
                             lc_segmrisk in varchar2,
                             ln_pdcal    in number,
                             lc_tabla    in varchar2,
                             ld_f639     in date,
                             ld_f640     in date) is
    PRAGMA AUTONOMOUS_TRANSACTION;
    ln_corr number;
    lc_hora char(8) := '00:00:00';
  
  begin
  
    begin
      select max(a.aqpb166corr)
        into ln_corr
        from aqpb166 a
       where a.aqpb166tdoc = ln_tdoc
         and a.aqpb166ndoc = lc_ndoc;
    exception
      when others then
        ln_corr := 0;
    end;
    ln_corr := nvl(ln_corr, 0);
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    end;
  
    begin
      insert into aqpb166
        (aqpb166corr,
         aqpb166inst,
         aqpb166tdoc,
         aqpb166ndoc,
         aqpb166user,
         aqpb166fec,
         aqpb166hora,
         aqpb166prgm,
         aqpb166score,
         aqpb166probal,
         aqpb166segmrisk,
         aqpb166pdcal,
         aqpb166tabla,
         aqpb166f639,
         aqpb166f640,
         aqpb166est)
      values
        (ln_corr + 1,
         ln_inst,
         ln_tdoc,
         lc_ndoc,
         lc_user,
         ld_fec,
         lc_hora,
         lc_prgm,
         lc_score,
         ln_probal,
         lc_segmrisk,
         ln_pdcal,
         lc_tabla,
         ld_f639,
         ld_f640,
         'H');
         commit;
    exception
      when others then
        null;
    end;
  
 
  
  end sp_cr_logAQPB166;

end PQ_CR_SCORE_RCC_DESEM_DIGI;
/

