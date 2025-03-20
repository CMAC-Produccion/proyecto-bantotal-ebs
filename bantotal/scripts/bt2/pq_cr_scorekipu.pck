create or replace package PQ_CR_SCOREKIPU is

    -- Nombre                     : Obtiene el score del cliente que ingresa su Número de documento
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 18/01/2024 17:45:12
    -- Autor de Creación          : MPOSTIGOC
    -- Uso                        : Realiza cálculos
    -- Estado                     : Activo
    -- Acceso                     : Público



  procedure sp_cr_scoreKIPU(ln_tdoc       in number,
                            lc_ndoc       in varchar2,
                            lc_score      out varchar2,
                            ln_probal     out number,
                            lc_SegmRiesgo out varchar2,
                            ln_PDCal      out number,
                            lc_tabla      out varchar2,
                            ld_fchscore   out date,
                            lc_scoreabr   out varchar2,
                            lc_NewScore   OUT VARCHAR2);

end PQ_CR_SCOREKIPU;
/

create or replace package body PQ_CR_SCOREKIPU is

  procedure sp_cr_scoreKIPU(ln_tdoc       in number,
                            lc_ndoc       in varchar2,
                            lc_score      out varchar2,
                            ln_probal     out number,
                            lc_SegmRiesgo out varchar2,
                            ln_PDCal      out number,
                            lc_tabla      out varchar2,
                            ld_fchscore   out date,
                            lc_scoreabr   out varchar2,
                            lc_NewScore   OUT VARCHAR2) is
  
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
    ln_GrupoSco      number;
  
  begin
  
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
  
    if ln_probal > 0 then
    
      lc_scoreabr := substr(lc_score, -1);
    
      begin
        select f.tp1nro3
          into ln_GrupoSco
          from fst198 f
         where f.tp1cod = 1
           and f.tp1cod1 = 10899
           and f.tp1corr1 = 129
           and f.tp1corr2 = 1
           and f.tp1desc = RPAD(lc_scoreabr, 30, ' ');
      exception
        when others then
          ln_GrupoSco := 999;
      end;
    
      if ln_GrupoSco < 999 then
        begin
          select f.tp1desc
            into lc_NewScore
            from fst198 f
           where f.tp1cod = 1
             and f.tp1cod1 = 10899
             and f.tp1corr1 = 129
             and f.tp1corr2 = 2
             and f.tp1nro3 = ln_GrupoSco;
        exception
          when others then
            lc_NewScore := 'SIN SCORE';
        end;
      end if;
    
    end if;
  
    if ln_probal is null then
      lc_NewScore := 'SIN SCORE';
    end if;
  
  end sp_cr_scoreKIPU;
end PQ_CR_SCOREKIPU;
/

