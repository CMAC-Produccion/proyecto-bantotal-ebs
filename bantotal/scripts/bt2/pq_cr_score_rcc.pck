create or replace package PQ_CR_SCORE_RCC is

  -- Author  : MPOSTIGOC
  -- Created : 4/08/2023 18:28:46
  -- Purpose : Paquete que devuelve el SCORE RCC
  -- Fecha de Modificación      : 16/01/2024
  -- Autor de la Modificación   : MPOSTIGOC
  -- Descripción de Modificación: Se agrego un procedimiento que devuelve el nuevo score MEMO16
  -- Fecha de Modificación      : 15/04/2024
  -- Autor de la Modificación   : APACHECOH
  -- Descripción de Modificación: Se agrego un procedimiento que realiza el calculo del score segun fecha enviada
  -- Fecha de Modificación      : 07/05/2024
  -- Autor de la Modificación   : MPOSTIGOC
  -- Descripción de Modificación: Se agrego validaciones para obtener el segmento cuando haya mas de 1 reg en la tabla JAQL640
  -- Fecha de Modificación      : 04/02/2025
  -- Autor de la Modificación   : MPOSTIGOC
  -- Descripción de Modificación: Se cambio el rango de extraccion para la variable de Score de 1 a 2 espacios.

  -- *****************************************************************

  procedure sp_cr_score(vi_instancia in number,
                        vi_usuario   in varchar2,
                        vl_score2    out varchar2);
  ----------------------------------------------------------------                        
  procedure sp_cr_scoreflujo(ln_instancia  in number,
                             lc_usuario    in varchar2,
                             lc_score      out varchar2,
                             lc_scoreabr   out varchar2,
                             ln_probal     out number,
                             lc_SegmRiesgo out varchar2,
                             ln_PDCal      out number,
                             lc_NewScore   out varchar2);
  -----------------------------------------------------------------
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
                           ld_fchscore   out date /*,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   lc_scoreabr   out varchar2,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   lc_NewScore   out Varchar2*/);
  -------------------------------------------------------------------
  procedure sp_cr_scoreDNI_II(ln_inst       in number,
                              ln_tdoc       in number,
                              lc_ndoc       in varchar2,
                              lc_prgm       in varchar2,
                              lc_user       in varchar2,
                              lc_score      out varchar2,
                              ln_probal     out number,
                              lc_SegmRiesgo out varchar2,
                              ln_PDCal      out number,
                              lc_tabla      out varchar2,
                              ld_fchscore   out date,
                              lc_scoreabr   out varchar2,
                              lc_NewScore   out Varchar2);
  -------------------------------------------------------------------
  --apachecoh 2024.04.15
  procedure sp_cr_scoreDNI_III(ln_inst       in number,
                               ln_tdoc       in number,
                               lc_ndoc       in varchar2,
                               lc_prgm       in varchar2,
                               lc_user       in varchar2,
                               ld_fecha      in date,
                               lc_score      out varchar2,
                               ln_probal     out number,
                               lc_SegmRiesgo out varchar2,
                               ln_PDCal      out number,
                               lc_tabla      out varchar2,
                               ld_fchscore   out date,
                               lc_scoreabr   out varchar2,
                               lc_NewScore   out varchar2);
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
                             ld_f640     in date,
                             lc_scoreabr in varchar2,
                             lc_NewScore in varchar2);

end PQ_CR_SCORE_RCC;
/

create or replace package body PQ_CR_SCORE_RCC is

  --------------------
  procedure sp_cr_score(vi_instancia in number,
                        vi_usuario   in varchar2,
                        vl_score2    out varchar2) is
  
    ve_tipo_documento        number;
    vl_rpta                  char(1);
    vl_score                 varchar2(50);
    vo_score                 varchar2(15);
    vl_scoremicro            char(50);
    vl_scorecons             char(50);
    vl_cant                  number;
    ve_numero_documento      varchar2(12);
    vl_dtipocre              varchar2(30);
    vl_sol                   NUMBER(10);
    vl_tdoc                  number(5);
    vl_ndoc                  char(12);
    vl_vcharndoc             varchar(12);
    habilitar                number(5);
    vl_flagvar               number(2);
    vl_jaql640               varchar(20);
    vl_jaql639               varchar(20);
    vl_PRDEF                 number;
    vl_jaql639dni            varchar(20);
    vl_jaql639ruc            varchar(20);
    vl_PDCNS                 number;
    vl_PDMY                  number;
    vl_tabla                 varchar(20);
    vl_fecha_consulta_tabla  date;
    vl_riesgo_letra          varchar(50);
    vl_riesgo_letra_639rimy  varchar(50);
    vl_riesgo_letra_639RICNS varchar(50);
    vl_score_regla639        varchar(50);
    vl_puntaje               number;
    vl_cliente               varchar(100);
    vl_tipo_credito_rcc      varchar(500);
  
    vl_pymes_rcc               number;
    vl_consumo_hipotecario_rcc number;
    ve_numero_documento2       varchar(12);
    ve_numero_documento_ruc    varchar(11);
    ve_numero_documento_dos    varchar(12);
    ld_fchRCC                  date;
  
  begin
    vl_jaql640    := 'N';
    vl_jaql639    := 'N';
    vl_jaql639dni := 'N';
    vl_jaql639ruc := 'N';
  
    begin
      select s.sng001tdoc, s.sng001ndoc
        into ve_tipo_documento, ve_numero_documento_dos
        from sng001 s
       where s.sng001inst = vi_instancia;
    exception
      when others then
        null;
    end;
  
    ve_numero_documento := trim(ve_numero_documento_dos);
  
    begin
      select to_date(Tpnro, 'DD/MM/YYYY')
        into ld_fchRCC
        from FST098
       Where Pgcod = 1
         and Tpcod = 7647
         and Tpcorr = 12;
    exception
      when others then
        null;
    end;
  
    begin
      SELECT TP1NRO1
        INTO habilitar
        FROM fst198
       where tp1cod = 1
         and tp1cod1 = 7164380
         and tp1corr1 = 1
         AND TP1CORR2 = 0;
    exception
      when others then
        null;
    end;
  
    begin
      PQ_CL_SEGUIMIENTO_CLIENTES.sp_cl_ultevaluacion(0,
                                                     0,
                                                     ve_numero_documento,
                                                     vo_nsol             => vl_sol,
                                                     vo_tdoc             => vl_tdoc,
                                                     vo_ndoc             => vl_ndoc,
                                                     vo_destcre          => vl_dtipocre);
    
    exception
      when others then
        null;
    end;
  
    IF (vl_dtipocre is null) THEN
    
      begin
        select count(*)
          into vl_pymes_rcc
          from cldrccs
         where c_codsbs = (select c.c_codsbs
                             from cldrcci c
                            where c_docide = ve_numero_documento
                              and d_fecpre = ld_fchRCC)
              
           and d_fecpre = ld_fchRCC
           and c_cretip in
               ('01', '02', '03', '04', '05', '06', '07', '08', '09', '10');
      exception
        when others then
          null;
      end;
    
      begin
        select count(*)
          into vl_consumo_hipotecario_rcc
          from cldrccs
         where c_codsbs = (select c.c_codsbs
                             from cldrcci c
                            where c_docide = ve_numero_documento
                              and d_fecpre = ld_fchRCC)
           and d_fecpre = ld_fchRCC
           and c_cretip in ('11', '12', '13');
      
      exception
        when others then
          null;
      end;
    
      if (vl_pymes_rcc >= 1) and (vl_consumo_hipotecario_rcc = 0) then
        vl_tipo_credito_rcc := 'PYMES RCC';
      
      elsif (vl_consumo_hipotecario_rcc >= 1) and (vl_pymes_rcc = 0) then
        vl_tipo_credito_rcc := 'CONSUMO HIPOTECARIO RCC';
      
      elsif vl_pymes_rcc = 0 and vl_consumo_hipotecario_rcc = 0 then
      
        ----ruc
      
        begin
          select count(*)
            into vl_pymes_rcc
            from cldrccs
           where c_codsbs = (select c.c_codsbs
                               from cldrcci c
                              where c_doctri = ve_numero_documento
                                and d_fecpre = ld_fchRCC)
             and d_fecpre = ld_fchRCC
             and c_cretip in ('01',
                              '02',
                              '03',
                              '04',
                              '05',
                              '06',
                              '07',
                              '08',
                              '09',
                              '10');
        
        exception
          when others then
            null;
        end;
      
        begin
          select count(*)
            into vl_consumo_hipotecario_rcc
            from cldrccs
           where c_codsbs = (select c.c_codsbs
                               from cldrcci c
                              where c_doctri = ve_numero_documento
                                and d_fecpre = ld_fchRCC)
             and d_fecpre = ld_fchRCC
             and c_cretip in ('11', '12', '13');
        
        exception
          when others then
            null;
        end;
      
        if (vl_pymes_rcc >= 1) and (vl_consumo_hipotecario_rcc = 0) then
          vl_tipo_credito_rcc := 'PYMES RCC';
        
        elsif (vl_consumo_hipotecario_rcc >= 1) and (vl_pymes_rcc = 0) then
          vl_tipo_credito_rcc := 'CONSUMO HIPOTECARIO RCC';
        
        else
          vl_tipo_credito_rcc := 'PYME_CONSUMO_RCC';
        
        end if;
      
        -----end ruc
      else
        vl_tipo_credito_rcc := 'PYME_CONSUMO_RCC';
      end if;
    
      vl_dtipocre := vl_tipo_credito_rcc;
    END IF;
  
    begin
    
      PQ_CL_SEGUIMIENTO_CLIENTES.sp_cl_new_recurrente(ve_numero_documento,
                                                      vl_rpta);
    
    exception
      when others then
        null;
    end;
  
    IF (habilitar = 2) THEN
      -- SI HABILITADO ES (2), ESTA HABILITADO EL CONTROL          
    
      BEGIN
      
        if vl_rpta = 'R' or vl_rpta = 'V' then
          --SCORE DE SEGUIMIENTO PARA RECURRENTES ()
          begin
          
            SELECT MAX(JAQL640RIESG),
                   COUNT(*),
                   max(JAQL640PRDEF),
                   max(JAQL640FEPRE),
                   MAX(substr(JAQL640RIESG, 8, 1))
              into vl_score,
                   vl_cant,
                   vl_PRDEF,
                   vl_fecha_consulta_tabla,
                   vl_riesgo_letra
              FROM (SELECT *
                      FROM jaql640
                     WHERE JAQL640PTDOC = vl_tdoc
                       AND JAQL640PNDOC = vl_ndoc
                     ORDER BY JAQL640FEPRE DESC)
             WHERE ROWNUM = 1;
          exception
            when others then
              null;
          end;
        
          BEGIN
            SELECT count(*)
              into vl_flagvar
              FROM fst198
             where tp1cod = 1
               and tp1cod1 = 11161
               and tp1corr1 = 5
               and tp1corr2 = 4
               and tp1corr3 > 0
               and tp1desc = rpad(vl_riesgo_letra, 30, ' ');
          exception
            when others then
              null;
          END;
        
          if vl_cant > 0 then
            -- DBMS_OUTPUT.put_line('Recurrente encontrado tabla recurrentes JAQL640'); --ecollado
            vl_jaql640 := 'S';
            vo_score   := 'S';
          elsif (vl_cant = 0) then
            --si no esta en la tabla de recurrente lo busca en nuevos
            vl_vcharndoc         := TRIM(vl_ndoc);
            ve_numero_documento2 := trim(ve_numero_documento);
          
            IF ve_tipo_documento IN (21, 2, 5) or ve_tipo_documento is null THEN
            
              BEGIN
                SELECT JAQL639RIMY,
                       JAQL639RICNS,
                       jaql639PDCNS,
                       jaql639PDMY,
                       JAQL639FEPRE,
                       substr(JAQL639RIMY, 8, 1),
                       substr(JAQL639RICNS, 8, 1)
                  into vl_scoremicro,
                       vl_scorecons,
                       vl_PDCNS,
                       vl_PDMY,
                       vl_fecha_consulta_tabla,
                       vl_riesgo_letra_639rimy,
                       vl_riesgo_letra_639RICNS
                  FROM (SELECT *
                          FROM jaql639
                         WHERE JAQL639NUIDE = ve_numero_documento2
                         ORDER BY JAQL639FEPRE DESC)
                 WHERE ROWNUM = 1;
                vl_jaql639dni := 'S';
                vl_jaql639    := 'S';
              EXCEPTION
                WHEN OTHERS THEN
                  vl_jaql639 := 'N';
                  NULL;
              END;
            ELSE
              BEGIN
                -- SELECT substr(JAQL639RIMY, 8, 1),
                --       substr(JAQL639RICNS, 8, 1),
                ve_numero_documento_ruc := trim(ve_numero_documento);
                SELECT JAQL639RIMY,
                       JAQL639RICNS,
                       jaql639PDCNS,
                       jaql639PDMY,
                       JAQL639FEPRE,
                       substr(JAQL639RIMY, 8, 1),
                       substr(JAQL639RICNS, 8, 1)
                  into vl_scoremicro,
                       vl_scorecons,
                       vl_PDCNS,
                       vl_PDMY,
                       vl_fecha_consulta_tabla,
                       vl_riesgo_letra_639rimy,
                       vl_riesgo_letra_639RICNS
                  FROM (SELECT *
                          FROM jaql639
                         WHERE JAQL639NURUC = ve_numero_documento_ruc
                         ORDER BY JAQL639FEPRE DESC)
                 WHERE ROWNUM = 1;
                vl_jaql639ruc := 'S';
                vl_jaql639    := 'S';
              EXCEPTION
                WHEN OTHERS THEN
                  vl_jaql639 := 'N';
                  NULL;
              END;
            END IF;
          
            if vl_PDCNS >= vl_PDMY then
              vl_score_regla639 := vl_riesgo_letra_639RICNS;
              vl_score          := vl_scorecons;
            else
              vl_score_regla639 := vl_riesgo_letra_639rimy;
              vl_score          := vl_scoremicro;
            end if;
            --end if;  
            --  DBMS_OUTPUT.put_line('Recurrente encontrado tabla nuevo jaql639'); --ecollado
          
            BEGIN
              SELECT count(*)
                into vl_flagvar
                FROM fst198
               where tp1cod = 1
                 and tp1cod1 = 11161
                 and tp1corr1 = 5
                 and tp1corr2 = 4
                 and tp1corr3 > 0
                 and tp1desc = rpad(vl_score_regla639, 30, ' ');
            exception
              when others then
                null;
            END;
            IF vl_flagvar > 0 then
              --IF vl_score in ('A','B','C','D','E','F') then --apachecoh 2022.09.27 se puso en guia
              vo_score := 'S';
              -- DBMS_OUTPUT.put_line('5');
            ELSE
              vo_score := 'N';
              -- DBMS_OUTPUT.put_line('6');
            END IF;
          else
            vo_score := 'N';
            --DBMS_OUTPUT.put_line('7');
          end IF;
        end if;
      
        IF vl_rpta = 'N' THEN
          vl_vcharndoc := TRIM(vl_ndoc);
          IF ve_tipo_documento IN (21, 2, 5) or ve_tipo_documento is null THEN
            ve_numero_documento2 := trim(ve_numero_documento);
            BEGIN
              SELECT JAQL639RIMY,
                     JAQL639RICNS,
                     JAQL639FEPRE,
                     substr(JAQL639RIMY, 8, 1),
                     substr(JAQL639RICNS, 8, 1)
                into vl_scoremicro,
                     vl_scorecons,
                     vl_fecha_consulta_tabla,
                     vl_riesgo_letra_639rimy,
                     vl_riesgo_letra_639RICNS
                FROM (SELECT *
                        FROM jaql639
                       WHERE JAQL639NUIDE = ve_numero_documento2
                       ORDER BY JAQL639FEPRE DESC)
               WHERE ROWNUM = 1;
              vl_jaql639dni := 'S';
              vl_jaql639    := 'S';
            EXCEPTION
              WHEN OTHERS THEN
                NULL;
                vl_jaql639 := 'N';
            END;
          ELSE
            BEGIN
              ve_numero_documento_ruc := trim(ve_numero_documento);
              SELECT JAQL639RIMY,
                     JAQL639RICNS,
                     JAQL639FEPRE,
                     substr(JAQL639RIMY, 8, 1),
                     substr(JAQL639RICNS, 8, 1)
                into vl_scoremicro,
                     vl_scorecons,
                     vl_fecha_consulta_tabla,
                     vl_riesgo_letra_639rimy,
                     vl_riesgo_letra_639RICNS
                FROM (SELECT *
                        FROM jaql639
                       WHERE JAQL639NURUC = ve_numero_documento_ruc
                       ORDER BY JAQL639FEPRE DESC)
               WHERE ROWNUM = 1;
              vl_jaql639    := 'S';
              vl_jaql639ruc := 'S';
            EXCEPTION
              WHEN OTHERS THEN
                vl_jaql639 := 'N';
                NULL;
            END;
          
          END IF;
        
          --APACHECOH 2023.03.31
          if vl_PDCNS >= vl_PDMY then
            vl_score_regla639 := vl_riesgo_letra_639RICNS;
            vl_score          := vl_scorecons;
          else
            vl_score_regla639 := vl_riesgo_letra_639rimy;
            vl_score          := vl_scoremicro;
          end if;
        
          --  DBMS_OUTPUT.put_line('Cliente nuevo encontrado tabla nuevos jaql639');
          BEGIN
            SELECT count(*)
              into vl_flagvar
              FROM fst198
             where tp1cod = 1
               and tp1cod1 = 11161
               and tp1corr1 = 5
               and tp1corr2 = 4
               and tp1corr3 > 0
               and tp1desc = rpad(vl_score_regla639, 30, ' ');
          exception
            when others then
              null;
          END;
          IF vl_flagvar > 0 then
            --IF vl_score in ('A','B','C','D','E','F') then
            vo_score := 'S';
            --DBMS_OUTPUT.put_line('10');
          ELSE
            vo_score := 'N';
            -- DBMS_OUTPUT.put_line('11');
          END IF;
        END IF;
      END;
    ELSE
      BEGIN
        vo_score := 'S';
        -- DBMS_OUTPUT.put_line('Control desahabilitado');
      END;
    END IF;
  
    if vl_score is null then
      ------
      BEGIN
        ve_numero_documento_ruc := trim(ve_numero_documento);
      
        SELECT JAQL639RIMY,
               JAQL639RICNS,
               JAQL639FEPRE,
               substr(JAQL639RIMY, 8, 1),
               substr(JAQL639RICNS, 8, 1)
          into vl_scoremicro,
               vl_scorecons,
               vl_fecha_consulta_tabla,
               vl_riesgo_letra_639rimy,
               vl_riesgo_letra_639RICNS
          FROM (SELECT *
                  FROM jaql639
                 WHERE JAQL639NURUC = ve_numero_documento_ruc
                 ORDER BY JAQL639FEPRE DESC)
         WHERE ROWNUM = 1;
        vl_jaql639    := 'S';
        vl_jaql639ruc := 'S';
      EXCEPTION
        WHEN OTHERS THEN
          vl_jaql639 := 'N';
          NULL;
      END;
    
      if vl_PDCNS >= vl_PDMY then
        vl_score_regla639 := vl_riesgo_letra_639RICNS;
        vl_score          := vl_scorecons;
      else
        vl_score_regla639 := vl_riesgo_letra_639rimy;
        vl_score          := vl_scoremicro;
      end if;
      --end if;
    
      --  DBMS_OUTPUT.put_line('Cliente nuevo encontrado tabla nuevos jaql639');
      BEGIN
        SELECT count(*)
          into vl_flagvar
          FROM fst198
         where tp1cod = 1
           and tp1cod1 = 11161
           and tp1corr1 = 5
           and tp1corr2 = 4
           and tp1corr3 > 0
           and tp1desc = rpad(vl_score_regla639, 30, ' ');
      exception
        when others then
          null;
      END;
    
      IF vl_flagvar > 0 then
        --IF vl_score in ('A','B','C','D','E','F') then
        vo_score := 'S';
        --DBMS_OUTPUT.put_line('10');
      ELSE
        vo_score := 'N';
        -- DBMS_OUTPUT.put_line('11');
      END IF;
    
      --------
    end if;
  
    If vl_jaql640 = 'S' and vl_jaql639 = 'N' then
      vl_tabla   := 'JAQL640';
      vl_cliente := 'CLIENTE DE CAJA AREQUIPA';
    
    Else
      if vl_jaql640 = 'N' and vl_jaql639 = 'S' then
        vl_tabla := 'JAQL639';
      else
        vl_tabla := '';
      end if;
      vl_cliente := 'CLIENTE NUEVO';
    
    End if;
  
    vl_score2 := trim(vl_score);
    vl_score2 := substr(vl_score2, -1);
  
    if vl_score2 is null or vl_score2 = 'SIN SCORE' then
      vl_score   := 'SIN SCORE';
      vl_score2  := 'SIN SCORE';
      vl_puntaje := 0;
    end if;
    ve_numero_documento2 := trim(ve_numero_documento);
  
    PQ_CL_SEGUIMIENTO_CLIENTES.sp_log_scorecliente(vl_sol,
                                                   vl_tdoc,
                                                   vl_ndoc,
                                                   vl_dtipocre,
                                                   vl_score2,
                                                   vl_tabla,
                                                   vi_usuario);
  
  end sp_cr_score;
  --------------------------------------------------------------------
  procedure sp_cr_scoreflujo(ln_instancia  in number,
                             lc_usuario    in varchar2,
                             lc_score      out varchar2,
                             lc_scoreabr   out varchar2,
                             ln_probal     out number,
                             lc_SegmRiesgo out varchar2,
                             ln_PDCal      out number,
                             lc_NewScore   out varchar2) is
  
    ln_activo   number;
    ln_tdoc     number;
    lc_ndoc     varchar2(12);
    lc_prgm     VARCHAR2(15);
    lc_tabla    varchar2(15);
    ld_fchscore date;
  
  begin
  
    begin
      select count(*)
        into ln_activo
        from wfwrkitems w
       where w.wfinsprcid = ln_instancia
         and w.wfitemstsact = '1';
    exception
      when others then
        null;
    end;
  
    if ln_activo > 0 then
    
      begin
        select s.sng001tdoc, s.sng001ndoc
          into ln_tdoc, lc_ndoc
          from sng001 s
         where s.sng001inst = ln_instancia;
      exception
        when others then
          null;
      end;
    
      lc_prgm := 'RAQPD052';
    
      pq_cr_score_rcc.sp_cr_scoreDNI_II(ln_instancia,
                                        ln_tdoc,
                                        trim(lc_ndoc),
                                        lc_prgm,
                                        lc_usuario,
                                        lc_score,
                                        ln_probal,
                                        lc_SegmRiesgo,
                                        ln_PDCal,
                                        lc_tabla,
                                        ld_fchscore,
                                        lc_scoreabr,
                                        lc_NewScore);
    
    end if;
  
  end sp_cr_scoreflujo;
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
                           ld_fchscore   out date /*,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 lc_scoreabr   out varchar2,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 lc_NewScore   out Varchar2*/) is
  
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
    ln_GrupoSco      number;
    lc_scoreabr      varchar2(10);
    lc_NewScore      Varchar2(30);
  
  begin
  
    if lc_prgm = 'RAQPD052' then
    
      update aqpb166 a
         set a.aqpb166est = 'I'
       where a.aqpb166inst = ln_inst
         and a.aqpb166est = 'H';
    
    else
      update aqpb166 a
         set a.aqpb166est = 'I'
       where a.aqpb166tdoc = ln_tdoc
         and a.aqpb166ndoc = lc_ndoc
         and a.aqpb166est = 'H';
    end if;
    commit;
  
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
    
      if lc_score = 'SIN SCORE' then
      
        begin
          select max(j.jaql640riesg)
            into lc_score
            from jaql640 j
           where j.jaql640ptdoc = ln_tdoc
             and j.jaql640pndoc = RPAD(lc_ndoc, 12, ' ')
             and j.jaql640fepre = ln_MaxFch640;
        exception
          when others then
            null;
        end;
      
        if lc_score is not null then
          begin
            select j.jaql640prdef,
                   j.jaql640riesg,
                   j.jaql640segmen,
                   j.jaql640pdcal
              into ln_probal, lc_score, lc_SegmRiesgo, ln_PDCal
              from jaql640 j
             where j.jaql640ptdoc = ln_tdoc
               and j.jaql640pndoc = RPAD(lc_ndoc, 12, ' ')
               and j.jaql640fepre = ln_MaxFch640
               and j.jaql640riesg = lc_score
               and rownum = 1;
          exception
            when others then
              lc_score      := 'SIN SCORE';
              ln_probal     := null;
              lc_SegmRiesgo := null;
              ln_PDCal      := null;
              lc_tabla      := null;
          end;
        
        else
          lc_score      := 'SIN SCORE';
          ln_probal     := null;
          lc_SegmRiesgo := null;
          ln_PDCal      := null;
          lc_tabla      := null;
        
        end if;
      
      end if;
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
           and f.tp1corr1 = 128
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
             and f.tp1corr1 = 128
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
  
    if lc_score = 'SIN SCORE' then
      lc_scoreabr := 'SS';
    end if;
  
    begin
      pq_Cr_score_rcc.sp_cr_logAQPB166(ln_inst,
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
                                       ln_MaxFch640,
                                       lc_scoreabr,
                                       lc_NewScore);
    end;
  end;
  ---------------------------------------------------------------
  procedure sp_cr_scoreDNI_II(ln_inst       in number,
                              ln_tdoc       in number,
                              lc_ndoc       in varchar2,
                              lc_prgm       in varchar2,
                              lc_user       in varchar2,
                              lc_score      out varchar2,
                              ln_probal     out number,
                              lc_SegmRiesgo out varchar2,
                              ln_PDCal      out number,
                              lc_tabla      out varchar2,
                              ld_fchscore   out date,
                              lc_scoreabr   out varchar2,
                              lc_NewScore   out Varchar2) is
  
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
    ln_GrupoSco      number;
  
  begin
  
    if lc_prgm = 'RAQPD052' then
    
      update aqpb166 a
         set a.aqpb166est = 'I'
       where a.aqpb166inst = ln_inst
         and a.aqpb166est = 'H';
    
    else
      update aqpb166 a
         set a.aqpb166est = 'I'
       where a.aqpb166tdoc = ln_tdoc
         and a.aqpb166ndoc = lc_ndoc
         and a.aqpb166est = 'H';
    end if;
    commit;
  
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
    
      if lc_score = 'SIN SCORE' then
      
        begin
          select max(j.jaql640riesg)
            into lc_score
            from jaql640 j
           where j.jaql640ptdoc = ln_tdoc
             and j.jaql640pndoc = RPAD(lc_ndoc, 12, ' ')
             and j.jaql640fepre = ln_MaxFch640;
        exception
          when others then
            null;
        end;
      
        if lc_score is not null then
          begin
            select j.jaql640prdef,
                   j.jaql640riesg,
                   j.jaql640segmen,
                   j.jaql640pdcal
              into ln_probal, lc_score, lc_SegmRiesgo, ln_PDCal
              from jaql640 j
             where j.jaql640ptdoc = ln_tdoc
               and j.jaql640pndoc = RPAD(lc_ndoc, 12, ' ')
               and j.jaql640fepre = ln_MaxFch640
               and j.jaql640riesg = lc_score
               and rownum = 1;
          exception
            when others then
              lc_score      := 'SIN SCORE';
              ln_probal     := null;
              lc_SegmRiesgo := null;
              ln_PDCal      := null;
              lc_tabla      := null;
          end;
        
        else
          lc_score      := 'SIN SCORE';
          ln_probal     := null;
          lc_SegmRiesgo := null;
          ln_PDCal      := null;
          lc_tabla      := null;
        
        end if;
      
      end if;
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
    
      lc_scoreabr := trim(substr(lc_score, -2));
    
      begin
        select f.tp1nro3
          into ln_GrupoSco
          from fst198 f
         where f.tp1cod = 1
           and f.tp1cod1 = 10899
           and f.tp1corr1 = 128
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
             and f.tp1corr1 = 128
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
  
    if lc_score = 'SIN SCORE' then
      lc_scoreabr := 'SS';
    end if;
  
    begin
      pq_Cr_score_rcc.sp_cr_logAQPB166(ln_inst,
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
                                       ln_MaxFch640,
                                       lc_scoreabr,
                                       lc_NewScore);
    end;
  end sp_cr_scoreDNI_II;
  ---------------------------------------------------------------
  procedure sp_cr_scoreDNI_III(ln_inst       in number,
                               ln_tdoc       in number,
                               lc_ndoc       in varchar2,
                               lc_prgm       in varchar2,
                               lc_user       in varchar2,
                               ld_fecha      in date,
                               lc_score      out varchar2,
                               ln_probal     out number,
                               lc_SegmRiesgo out varchar2,
                               ln_PDCal      out number,
                               lc_tabla      out varchar2,
                               ld_fchscore   out date,
                               lc_scoreabr   out varchar2,
                               lc_NewScore   out Varchar2) is
  
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
    ln_GrupoSco      number;
  
  begin
  
    if lc_prgm = 'RAQPD052' then
      update aqpb166 a
         set a.aqpb166est = 'I'
       where a.aqpb166inst = ln_inst
         and a.aqpb166est = 'H';
    else
      update aqpb166 a
         set a.aqpb166est = 'I'
       where a.aqpb166tdoc = ln_tdoc
         and a.aqpb166ndoc = lc_ndoc
         and a.aqpb166est = 'H';
    end if;
    commit;
  
    begin
      select f.pgfape into ln_fchsist from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    --apachecoh 2024.04.15 Se cambio como obtener la fecha
    ln_MaxFch640 := LAST_DAY(ADD_MONTHS(ld_fecha, -1));
    ln_MaxFch639 := LAST_DAY(ADD_MONTHS(ld_fecha, -2));
  
    /*begin
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
    end;*/
  
    begin
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
    
      if lc_score = 'SIN SCORE' then
      
        begin
          select max(j.jaql640riesg)
            into lc_score
            from jaql640 j
           where j.jaql640ptdoc = ln_tdoc
             and j.jaql640pndoc = RPAD(lc_ndoc, 12, ' ')
             and j.jaql640fepre = ln_MaxFch640;
        exception
          when others then
            null;
        end;
      
        if lc_score is not null then
          begin
            select j.jaql640prdef,
                   j.jaql640riesg,
                   j.jaql640segmen,
                   j.jaql640pdcal
              into ln_probal, lc_score, lc_SegmRiesgo, ln_PDCal
              from jaql640 j
             where j.jaql640ptdoc = ln_tdoc
               and j.jaql640pndoc = RPAD(lc_ndoc, 12, ' ')
               and j.jaql640fepre = ln_MaxFch640
               and j.jaql640riesg = lc_score
               and rownum = 1;
          exception
            when others then
              lc_score      := 'SIN SCORE';
              ln_probal     := null;
              lc_SegmRiesgo := null;
              ln_PDCal      := null;
              lc_tabla      := null;
          end;
        
        else
          lc_score      := 'SIN SCORE';
          ln_probal     := null;
          lc_SegmRiesgo := null;
          ln_PDCal      := null;
          lc_tabla      := null;
        
        end if;
      
      end if;
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
    
      lc_scoreabr := trim(substr(lc_score, -2));
    
      begin
        select f.tp1nro3
          into ln_GrupoSco
          from fst198 f
         where f.tp1cod = 1
           and f.tp1cod1 = 10899
           and f.tp1corr1 = 128
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
             and f.tp1corr1 = 128
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
  
    if lc_score = 'SIN SCORE' then
      lc_scoreabr := 'SS';
    end if;
  
    begin
      pq_Cr_score_rcc.sp_cr_logAQPB166(ln_inst,
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
                                       ln_MaxFch640,
                                       lc_scoreabr,
                                       lc_NewScore);
    end;
  end sp_cr_scoreDNI_III;
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
                             ld_f640     in date,
                             lc_scoreabr in varchar2,
                             lc_NewScore in varchar2) is
  
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
         aqpb166est,
         AQPB166SCORA,
         AQPB166NSCOR)
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
         'H',
         lc_scoreabr,
         lc_NewScore);
    exception
      when others then
        null;
    end;
  
    commit;
  
  end sp_cr_logAQPB166;

end PQ_CR_SCORE_RCC;
/

