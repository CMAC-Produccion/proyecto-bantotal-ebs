create or replace package pq_cr_score_riesgo is
  procedure sp_cl_soloscore_cliente(vi_instancia in number,
                                    vi_usuario   in varchar2,
                                    --vi_documento        in varchar2,
                                    vo_score            out varchar2,
                                    vo_validacion_score out varchar2);
  procedure sp_cl_soloscore_cliente_antiguo(vi_instancia in number,
                                            vi_usuario   in varchar2,
                                            --vi_documento in varchar2,
                                            vo_score            out varchar2,
                                            vo_validacion_score out varchar2);
  procedure sp_cl_solicitud_cre(vi_instancia in number,
                                vo_nsol      out number,
                                vo_tdoc      out varchar2,
                                vo_ndoc      out char,
                                vo_destcre   out varchar2);
  procedure sp_log_scorecliente(vi_instancia in number,
                                vi_tdoc      in number,
                                vi_ndoc      in char,
                                vi_destcre   in varchar2,
                                vi_score     in varchar2,
                                vi_tabla     in varchar2,
                                vi_usr       in varchar2);

end pq_cr_score_riesgo;
/

create or replace package body pq_cr_score_riesgo is

  procedure sp_cl_soloscore_cliente(vi_instancia in number,
                                    vi_usuario   in varchar2,
                                    --vi_documento        in varchar2,
                                    vo_score            out varchar2,
                                    vo_validacion_score out varchar2) is
  
    ve_tipo_documento   number(5);
    ve_numero_documento varchar2(12);
    ln_inst             number(10);
    lc_prgm             varchar2(50);
    lc_score            varchar2(50);
    ln_probal           number(9, 7);
    lc_segmriesgo       varchar2(50);
    ln_pdcal            number(5, 5);
    lc_tabla            varchar2(50);
    ld_fchscore         date;
  
  begin
    vo_validacion_score := 'N';
    vo_score            := '';
  
    begin
      select s.sng001inst, s.sng001tdoc, trim(s.sng001ndoc)
        into ln_inst, ve_tipo_documento, ve_numero_documento
        from sng001 s
       where s.sng001inst = vi_instancia;
    exception
      when others then
        null;
    end;
    lc_prgm := 'RAQPC567';
  
    begin
      -- Call the procedure
      pq_cr_score_rcc.sp_cr_scoredni(ln_inst       => vi_instancia,
                                     ln_tdoc       => ve_tipo_documento,
                                     lc_ndoc       => ve_numero_documento,
                                     lc_prgm       => lc_prgm,
                                     lc_user       => vi_usuario,
                                     lc_score      => lc_score,
                                     ln_probal     => ln_probal,
                                     lc_segmriesgo => lc_segmriesgo,
                                     ln_pdcal      => ln_pdcal,
                                     lc_tabla      => lc_tabla,
                                     ld_fchscore   => ld_fchscore);
    exception
      when others then
        null;
    end;
  
    if lc_score is null or lc_score = 'SIN SCORE' or lc_score = '' then
      vo_score            := 'SIN SCORE';
      vo_validacion_score := 'N';
    else
      vo_score := substr(lc_score, 8, 1);
      if (vo_score = 'F' or vo_score = 'G' or vo_score = 'H' or
         vo_score = 'I' or vo_score = 'J' or vo_score = 'K' or
         vo_score = 'L') then
        vo_validacion_score := 'S';
      else
        vo_validacion_score := 'N';
      end if;
    end if;
  
  end sp_cl_soloscore_cliente;

  /*procedure sp_cl_soloscore_cliente(vi_instancia in number,
                                    vi_usuario   in varchar2,
                                    --vi_documento        in varchar2,
                                    vo_score            out varchar2,
                                    vo_validacion_score out varchar2) is
  
    vl_sol       number(10);
    vl_tdoc      number(5);
    vl_ndoc      char(12);
    vl_vcharndoc varchar2(12);
    --vl_score char(1);
    vl_scoremicro              char(50); --char(1);
    vl_scorecons               char(50); --char(1);
    vl_cant                    number;
    vl_dtipocre                varchar2(30);
    vl_tabla                   varchar2(10);
    vl_validacion              number;
    vl_sql                     varchar2(500);
    contador_jaql639_dni       number;
    vi_usuario_trim            varchar2(50);
    descripcion_tipo_credito   varchar2(100);
    ve_inst                    number(10);
    ve_tip_doc                 number(2);
    ve_numero_documento        char(12);
    vl_pymes_rcc               number;
    vl_consumo_hipotecario_rcc number;
    vl_tipo_credito_rcc        varchar(500);
    vl_rpta                    char(1);
    vl_score                   varchar2(50);
    vl_PRDEF                   number;
    vl_fecha_consulta_tabla    date;
    vl_riesgo_letra            varchar(50);
    vl_flagvar                 number(2);
    vl_jaql640                 varchar(20);
    ve_numero_documento2       varchar(12);
    ve_tipo_documento          number;
    vl_PDCNS                   number;
    vl_PDMY                    number;
    vl_riesgo_letra_639rimy    varchar(50);
    vl_riesgo_letra_639RICNS   varchar(50);
    vl_jaql639dni              varchar(20);
    vl_jaql639ruc              varchar(20);
    vl_jaql639                 varchar(20);
    ve_numero_documento_ruc    varchar(11);
    vl_score_regla639          varchar(50);
    vl_cliente                 varchar(100);
    jaql639rimy_dni            varchar(50);
    jaql639ricns_dni           varchar(50);
    jaql639pdmy_dni            number;
    jaql639pdcns_dni           number;
    jaql639rimy_ruc            varchar(50);
    jaql639ricns_ruc           varchar(50);
    jaql639pdmy_ruc            number;
    jaql639pdcns_ruc           number;
    vl_score2                  varchar2(50);
  
    cursor cur_tipo_credito is
    select *
      from fst198
     where tp1cod = 1
       and tp1cod1 = 610020
       and tp1corr1 = 1
       and tp1corr2 > 0;
  
  BEGIN
    vo_validacion_score := 'N';
    vl_validacion       := 0;
    vo_score            := '';
    begin
      select s.sng001inst, s.sng001tdoc, s.sng001ndoc
        into ve_inst, ve_tipo_documento, ve_numero_documento
        from sng001 s
       where s.sng001inst = vi_instancia;
    exception
      when others then
        null;
    end;
  
    begin
      PQ_CL_SEGUIMIENTO_CLIENTES.sp_cl_ultevaluacion(ve_inst,
                                                     ve_tipo_documento,
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
         where c_codsbs = (select c_codsbs
                             from (select *
                                     from cldrcci
                                    where c_docide = ve_numero_documento
                                    order by d_fecpre desc)
                            where rownum = 1)
           and d_fecpre = (select to_date(Tpnro, 'DD/MM/YYYY')
                             from FST098
                            Where Pgcod = 1
                              and Tpcod = 7647
                              and Tpcorr = 12)
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
         where c_codsbs = (select c_codsbs
                             from (select *
                                     from cldrcci
                                    where c_docide = ve_numero_documento
                                    order by d_fecpre desc)
                            where rownum = 1)
           and d_fecpre = (select to_date(Tpnro, 'DD/MM/YYYY')
                             from FST098
                            Where Pgcod = 1
                              and Tpcod = 7647
                              and Tpcorr = 12)
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
           where c_codsbs = (select c_codsbs
                               from (select *
                                       from cldrcci
                                      where c_doctri = ve_numero_documento
                                      order by d_fecpre desc)
                              where rownum = 1)
             and d_fecpre = (select to_date(Tpnro, 'DD/MM/YYYY')
                               from FST098
                              Where Pgcod = 1
                                and Tpcod = 7647
                                and Tpcorr = 12)
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
           where c_codsbs = (select c_codsbs
                               from (select *
                                       from cldrcci
                                      where c_doctri = ve_numero_documento
                                      order by d_fecpre desc)
                              where rownum = 1)
             and d_fecpre = (select to_date(Tpnro, 'DD/MM/YYYY')
                               from FST098
                              Where Pgcod = 1
                                and Tpcod = 7647
                                and Tpcorr = 12)
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
                                                      vo_rpta => vl_rpta);
    
    exception
      when others then
        null;
    end;
  
    BEGIN
    
      --if vl_rpta = 'R' or vl_rpta = 'V' then
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
                  WHERE
                 --JAQL640TICRE LIKE vl_dtipocre || '%'
                 --AND
                  JAQL640PTDOC = vl_tdoc
               AND JAQL640PNDOC = vl_ndoc
                 --and JAQL640FEPRE = ve_fecha
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
        DBMS_OUTPUT.put_line('Recurrente encontrado tabla recurrentes JAQL640'); --ecollado
        vl_jaql640 := 'S';
        vo_score   := 'S';
      elsif (vl_cant = 0) then
        --si no esta en la tabla de recurrente lo busca en nuevos
        vl_vcharndoc         := TRIM(vl_ndoc);
        ve_numero_documento2 := trim(ve_numero_documento);
        IF ve_tipo_documento IN (21, 2, 5) or ve_tipo_documento is null THEN
          BEGIN
            --- Aqui se esta modificando el orden de las variables By Ede
            SELECT substr(JAQL639RIMY, 8, 1),
                   substr(JAQL639RICNS, 8, 1),
                   jaql639PDCNS,
                   jaql639PDMY,
                   JAQL639FEPRE,
                   JAQL639RIMY,
                   JAQL639RICNS
              into vl_scoremicro,
                   vl_scorecons,
                   vl_PDCNS,
                   vl_PDMY,
                   vl_fecha_consulta_tabla,
                   vl_riesgo_letra_639rimy,
                   vl_riesgo_letra_639RICNS
              FROM (SELECT *
                      FROM jaql639
                     WHERE JAQL639NUIDE = ve_numero_documento2 --rpad(ve_numero_documento,12,' ')--trim(ve_numero_documento)--vl_vcharndoc
                    --and JAQL639FEPRE = ve_fecha
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
                     WHERE JAQL639NURUC = ve_numero_documento_ruc --ve_numero_documento2--rpad(ve_numero_documento,11,' ')--trim(ve_numero_documento)--vl_vcharndoc
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
        --APACHECOH 2023.03.31
        if vl_PDCNS >= vl_PDMY then
          vl_score_regla639 := vl_riesgo_letra_639RICNS;
          vl_score          := vl_scorecons;
        else
          vl_score_regla639 := vl_riesgo_letra_639rimy;
          vl_score          := vl_scoremicro;
        end if;
      end if;
      DBMS_OUTPUT.put_line('Recurrente encontrado tabla nuevo jaql639'); --ecollado
    
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
        vo_score := 'S';
      ELSE
        vo_score := 'N';
      END IF;
      --else
      --vo_score := 'N';
      --end IF;
      --end if;
    
      IF vl_rpta = 'N' THEN
        vl_vcharndoc := TRIM(vl_ndoc);
        IF ve_tipo_documento IN (21, 2, 5) or ve_tipo_documento is null THEN
          ve_numero_documento2 := trim(ve_numero_documento);
          BEGIN
            --SELECT substr(JAQL639RIMY, 8, 1), substr(JAQL639RICNS, 8, 1)
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
                     WHERE JAQL639NUIDE = ve_numero_documento2 ---rpad(ve_numero_documento,12,' ')--trim(ve_numero_documento)--vl_vcharndoc
                    --and JAQL639FEPRE = ve_fecha
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
            --SELECT substr(JAQL639RIMY, 8, 1), substr(JAQL639RICNS, 8, 1)
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
                     WHERE JAQL639NURUC = ve_numero_documento_ruc --ve_numero_documento2--rpad(ve_numero_documento,11,' ')--trim(ve_numero_documento)--vl_vcharndoc
                    --and JAQL639FEPRE = ve_fecha
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
      
        if vl_PDCNS >= vl_PDMY then
          vl_score_regla639 := vl_riesgo_letra_639RICNS;
          vl_score          := vl_scorecons;
        else
          vl_score_regla639 := vl_riesgo_letra_639rimy;
          vl_score          := vl_scoremicro;
        end if;
        --end if;
      
        DBMS_OUTPUT.put_line('Cliente nuevo encontrado tabla nuevos jaql639');
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
          vo_score := 'S';
        ELSE
          vo_score := 'N';
        END IF;
      END IF;
    end;
  
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
      --inconcistencia en el tipo de dato
      --APACHECOH 2023.03.31
      if vl_PDCNS >= vl_PDMY then
        vl_score_regla639 := vl_riesgo_letra_639RICNS;
        vl_score          := vl_scorecons;
      else
        vl_score_regla639 := vl_riesgo_letra_639rimy;
        vl_score          := vl_scoremicro;
      end if;
      --end if;
    
      DBMS_OUTPUT.put_line('Cliente nuevo encontrado tabla nuevos jaql639');
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
        vo_score := 'S';
      ELSE
        vo_score := 'N';
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
      if vl_jaql639dni = 'S' then
        begin
          ve_numero_documento2 := trim(ve_numero_documento);
          SELECT JAQL639RIMY, JAQL639RICNS, JAQL639PDMY, JAQL639PDCNS
            into jaql639rimy_dni,
                 jaql639ricns_dni,
                 jaql639pdmy_dni,
                 jaql639pdcns_dni
            FROM (SELECT *
                    FROM jaql639
                   WHERE JAQL639NUIDE = ve_numero_documento2
                   ORDER BY JAQL639FEPRE DESC)
           WHERE ROWNUM = 1;
        exception
          when others then
            null;
        END;
        vl_score2 := trim(vl_score);
      Else
        begin
          ve_numero_documento_ruc := trim(ve_numero_documento);
          SELECT JAQL639RIMY, JAQL639RICNS, JAQL639PDMY, JAQL639PDCNS
            into jaql639rimy_ruc,
                 jaql639ricns_ruc,
                 jaql639pdmy_ruc,
                 jaql639pdcns_ruc
            FROM (SELECT *
                    FROM jaql639
                   WHERE JAQL639NURUC = ve_numero_documento_ruc --ve_numero_documento2--rpad(ve_numero_documento,11,' ')--ve_numero_documento
                  --and JAQL639FEPRE = ve_fecha
                   ORDER BY JAQL639FEPRE DESC)
           WHERE ROWNUM = 1;
        exception
          when others then
            null;
        END;
        vl_score2 := trim(vl_score);
      End if;
    End if;
  
    vl_score2 := trim(vl_score);
  
    if vl_score2 is null or vl_score2 = 'SIN SCORE' then
      vl_score            := 'SIN SCORE';
      vl_score2           := 'SIN SCORE';
      vo_validacion_score := 'N';
    end if;
    ve_numero_documento2 := trim(ve_numero_documento);
  
    vo_score := vl_score2;
  
    if LENGTH(vo_score) = 8 then
      vo_score := substr(vl_score2, 8, 1);
    else
      vo_score := vl_score2;
    end if;
  
    if (vo_score = 'F' or vo_score = 'G' or vo_score = 'H' or
       vo_score = 'I' or vo_score = 'J' or vo_score = 'K' or
       vo_score = 'L' or vo_score is null) and (vl_validacion = 0) then
      vo_validacion_score := 'S';
    Else
      vo_validacion_score := 'N';
    End if;
  
  end sp_cl_soloscore_cliente;
  */

  procedure sp_cl_soloscore_cliente_antiguo(vi_instancia in number,
                                            vi_usuario   in varchar2,
                                            --vi_documento        in varchar2,
                                            vo_score            out varchar2,
                                            vo_validacion_score out varchar2) is
  
    vl_sol       number(10);
    vl_tdoc      number(5);
    vl_ndoc      char(12);
    vl_vcharndoc varchar2(12);
    --vl_score char(1);
    vl_scoremicro            char(1);
    vl_scorecons             char(1);
    vl_cant                  number;
    vl_dtipocre              varchar2(30);
    vl_tabla                 varchar2(10);
    vl_validacion            number;
    vl_sql                   varchar2(500);
    contador_jaql639_dni     number;
    vi_usuario_trim          varchar2(50);
    descripcion_tipo_credito varchar2(100);
  
    cursor cur_tipo_credito is
      select *
        from fst198
       where tp1cod = 1
         and tp1cod1 = 610020
         and tp1corr1 = 1
         and tp1corr2 > 0;
  
  BEGIN
    vo_validacion_score := 'N';
    vl_validacion       := 0;
    vo_score            := '';
  
    begin
      PQ_CL_SEGUIMIENTO_CLIENTES.sp_cl_solicitud_cre(vi_instancia,
                                                     vo_nsol      => vl_sol,
                                                     vo_tdoc      => vl_tdoc,
                                                     vo_ndoc      => vl_ndoc,
                                                     vo_destcre   => vl_dtipocre);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    IF vl_sol = 0 THEN
      ------jaql639 
      /*
      select count(*) into contador_jaql639_dni from jaql639 where  JAQL639NUIDE = vi_documento;
      
      IF contador_jaql639_dni >= 1 THEN
        BEGIN
          SELECT substr(JAQL639RIMY, 8, 1),
                 substr(JAQL639RICNS, 8, 1),
                 'JAQL639'
            into vl_scoremicro, vl_scorecons, vl_tabla
            FROM (SELECT *
                    FROM jaql639
                   WHERE JAQL639NUIDE = vl_vcharndoc
                     AND JAQL639RICNS <> 'SIN SCORE'
                   ORDER BY JAQL639FEPRE DESC)
           WHERE ROWNUM = 1;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      
      ELSE
        BEGIN
          SELECT substr(JAQL639RIMY, 8, 1),
                 substr(JAQL639RICNS, 8, 1),
                 'JAQL639'
            into vl_scoremicro, vl_scorecons, vl_tabla
            FROM (SELECT *
                    FROM jaql639
                   WHERE JAQL639NURUC = vl_vcharndoc
                     AND JAQL639RICNS <> 'SIN SCORE'
                   ORDER BY JAQL639FEPRE DESC)
           WHERE ROWNUM = 1;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      END IF;
      
      IF vl_dtipocre = 'MICROEMPRESA' or vl_dtipocre = 'MICROEMPRESAS' or
         vl_dtipocre = 'PEQUEÑA EMPRESA' then
        vo_score := vl_scoremicro;
      END IF;
      IF vl_dtipocre = 'CONSUMO NO REVOLVENTE' or
         vl_dtipocre = 'CONSUMO REVOLVENTE' then
        vo_score := vl_scorecons;
      END IF;
      
      if (vo_score = 'F' or vo_score = 'G' or vo_score = 'H' or
         vo_score = 'I' or vo_score = 'J' or vo_score = 'K' or
         vo_score = 'L' or vo_score is null) and (vl_validacion = 0) then
        vo_validacion_score := 'S';
      Else
        vo_validacion_score := 'N';
      End if;
      
      PQ_CL_SEGUIMIENTO_CLIENTES.sp_log_scorecliente(vl_sol,
                                                     vl_tdoc,
                                                     vl_ndoc,
                                                     vl_dtipocre,
                                                     vo_score,
                                                     vl_tabla,
                                                     vi_usuario);
                                                     */
    
      --------jaql639  
    
      --vo_score := '';
      --vo_validacion_score := 'N';
      RETURN;
    END IF;
    --vl_dtipocre:='CONSUMO NO REVOLVENTE';
  
    begin
      vi_usuario_trim := trim(vi_usuario);
      select count(*)
        into vl_validacion
        from jaqz086
       where jaqz086tndoc =
             (select (select pendoc
                        from fsr008
                       where pgcod = 1
                         and ctnro = sng001cta
                         and cttfir = 'T'
                         and rownum = '1')
                from sng001
               where sng001inst = vi_instancia)
         and jaqz086usr = vi_usuario_trim --'KTORRICO'--vi_usuario--'KTORRICO'--vi_usuario--'KTORRICO'--vi_usuario CAMBIAR ecollado
         and jaqz086calf in (select tp1nro1
                               from Fst198
                              where Tp1cod = 1 -- //valor fijo
                                and Tp1cod1 = 10823
                                and Tp1corr1 = 56
                                and Tp1corr2 = 1);
    
    exception
      when others then
        vl_validacion := 0;
    end;
  
    if vl_dtipocre = 'MICROEMPRESA' or vl_dtipocre = 'PEQUEÑA EMPRESA' or
       vl_dtipocre = 'MICROEMPRESAS' then
      vl_sql := 'S';
    else
      vl_sql := 'N';
    End if;
  
    begin
      if vl_sql = 'S' then
        for l in cur_tipo_credito loop
          descripcion_tipo_credito := trim(l.tp1desc);
          begin
            SELECT MAX(substr(JAQL640RIESG, 8, 1)), COUNT(*), 'JAQL640'
              into vo_score, vl_cant, vl_tabla
              FROM (SELECT *
                       FROM jaql640
                      WHERE -- (
                      JAQL640TICRE LIKE descripcion_tipo_credito || '%'
                     --) 
                   AND JAQL640PTDOC = vl_tdoc
                   AND JAQL640PNDOC = vl_ndoc
                      ORDER BY JAQL640FEPRE DESC)
             WHERE ROWNUM = 1;
          exception
            when others then
              null;
          end;
          if vl_cant > 0 then
            exit;
          end if;
        End loop;
      else
        begin
          SELECT MAX(substr(JAQL640RIESG, 8, 1)), COUNT(*), 'JAQL640'
            into vo_score, vl_cant, vl_tabla
            FROM (SELECT *
                    FROM jaql640
                   WHERE JAQL640TICRE LIKE vl_dtipocre || '%'
                        
                     AND JAQL640PTDOC = vl_tdoc
                     AND JAQL640PNDOC = vl_ndoc
                   ORDER BY JAQL640FEPRE DESC)
           WHERE ROWNUM = 1;
        exception
          when others then
            null;
        end;
      
      end if;
    
    exception
      when others then
        null;
    end;
  
    IF (vl_cant = 0) then
      --si no esta en la tabla de recurrente lo busca en nuevos
      vl_vcharndoc := trim(vl_ndoc);
      IF vl_tdoc IN (21, 2, 5) THEN
        /* SELECT substr(JAQL639RIMY,8,1),substr(JAQL639RICNS,8,1),'JAQL639'
        into vl_scoremicro, vl_scorecons , vl_tabla
        FROM jaql639
        WHERE TRIM(JAQL639NUIDE) = TRIM(vl_ndoc);*/
        BEGIN
          SELECT substr(JAQL639RIMY, 8, 1),
                 substr(JAQL639RICNS, 8, 1),
                 'JAQL639'
            into vl_scoremicro, vl_scorecons, vl_tabla
            FROM (SELECT *
                    FROM jaql639
                   WHERE JAQL639NUIDE = vl_vcharndoc
                     AND JAQL639RICNS <> 'SIN SCORE'
                   ORDER BY JAQL639FEPRE DESC)
           WHERE ROWNUM = 1;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      
      ELSE
        /* SELECT substr(JAQL639RIMY,8,1),substr(JAQL639RICNS,8,1),'JAQL639'
        into vl_scoremicro, vl_scorecons , vl_tabla
        FROM jaql639
        WHERE JAQL639NURUC = vl_ndoc;*/
        BEGIN
          SELECT substr(JAQL639RIMY, 8, 1),
                 substr(JAQL639RICNS, 8, 1),
                 'JAQL639'
            into vl_scoremicro, vl_scorecons, vl_tabla
            FROM (SELECT *
                    FROM jaql639
                   WHERE JAQL639NURUC = vl_vcharndoc
                     AND JAQL639RICNS <> 'SIN SCORE'
                   ORDER BY JAQL639FEPRE DESC)
           WHERE ROWNUM = 1;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      END IF;
      IF vl_dtipocre = 'MICROEMPRESA' or vl_dtipocre = 'MICROEMPRESAS' or
         vl_dtipocre = 'PEQUEÑA EMPRESA' then
        --micro
        vo_score := vl_scoremicro;
      END IF;
      IF vl_dtipocre = 'CONSUMO NO REVOLVENTE' or
         vl_dtipocre = 'CONSUMO REVOLVENTE' then
        --consumo
        vo_score := vl_scorecons;
      END IF;
    END IF;
  
    --vo_score := 'A';
    --if (vl_cant != 0) then
    if (vo_score = 'F' or vo_score = 'G' or vo_score = 'H' or
       vo_score = 'I' or vo_score = 'J' or vo_score = 'K' or
       vo_score = 'L' or vo_score is null) and (vl_validacion = 0) then
      vo_validacion_score := 'S';
    Else
      vo_validacion_score := 'N';
    End if;
    --End if;
  
    -- DBMS_OUTPUT.put_line('sU SCORE ES:' || vo_score ||' dE LA TABLA:'||vl_tabla);
  
    begin
      PQ_CL_SEGUIMIENTO_CLIENTES.sp_log_scorecliente(vl_sol,
                                                     vl_tdoc,
                                                     vl_ndoc,
                                                     vl_dtipocre,
                                                     vo_score,
                                                     vl_tabla,
                                                     vi_usuario);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
  end sp_cl_soloscore_cliente_antiguo;

  procedure sp_cl_solicitud_cre(vi_instancia in number,
                                vo_nsol      out number,
                                vo_tdoc      out varchar2,
                                vo_ndoc      out char,
                                vo_destcre   out varchar2) is
  
    --  vl_ndoc varchar2(12);
    vl_cant number(5);
  begin
  
    BEGIN
      SELECT SNG001INST,
             SNG001TDOC,
             SNG001NDOC,
             upper(trim(substr(WFATTSVAL, instr(WFATTSVAL, ';') + 1))),
             1
        INTO vo_nsol, vo_tdoc, vo_ndoc, vo_destcre, vl_cant
        FROM sng001, wfattsvalues
       where SNG001INST = WFINSPRCID
         AND WFATTSID = 'TIPO_CREDITO'
         AND SNG001INST = vi_instancia;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    IF vl_cant IS NULL THEN
      --  DBMS_OUTPUT.put_line('Debe insertar Nro isntancia VALIDA' );
      vo_nsol := 0;
      --               return;
    END IF;
  
  end sp_cl_solicitud_cre;

  procedure sp_log_scorecliente(vi_instancia in number,
                                vi_tdoc      in number,
                                vi_ndoc      in char,
                                vi_destcre   in varchar2,
                                vi_score     in varchar2,
                                vi_tabla     in varchar2,
                                vi_usr       in varchar2) is
    err_code NUMBER;
    err_msg  VARCHAR2(1000);
  BEGIN
    BEGIN
      INSERT INTO AQPB766
        (AQPB766NSOL,
         AQPB766TDOC,
         AQPB766NDOC,
         AQPB766TCRE,
         AQPB766SCOR,
         AQPB766TABL,
         AQPB766USRP,
         AQPB766FPRC,
         AQPB766HORA)
      VALUES
        (vi_instancia,
         vi_tdoc,
         vi_ndoc,
         vi_destcre,
         vi_score,
         vi_tabla,
         vi_usr,
         trunc(sysdate),
         to_char(sysdate, 'HH24:MI:SS'));
      --   DBMS_OUTPUT.put_line('Filas insertadas: ' || SQL%ROWCOUNT);
      commit;
    EXCEPTION
      WHEN OTHERS THEN
        err_code := SQLCODE;
        err_msg  := SUBSTR(SQLERRM, 1, 500);
        -- DBMS_OUTPUT.put_line(err_msg);
    END;
  end sp_log_scorecliente;

end pq_cr_score_riesgo;
/

