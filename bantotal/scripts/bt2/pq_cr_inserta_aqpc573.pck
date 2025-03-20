create or replace package pq_cr_inserta_aqpc573 is

  -- *****************************************************************
  -- Nombre                     : PAQUETES PARA INSERTAR EL SCORE DE RIESGOS EN LA CRU
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2022.10.26
  -- Autor de Creación          : EDUARDO COLLADO
  -- Uso                        : Obtiene correo del cliente
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2024.01.15
  -- Autor de la Modificación   : APACHECOH
  -- Descripción de Modificación: Se agregó un campo a la tabla aqpc573
  -- *****************************************************************
  
  procedure sp_cr_log_scorecliente(ve_tipo_documento       in number,
                                   ve_numero_documento_dos in varchar,
                                   ve_sucursal             in number,
                                   ve_usuario_consulta     in varchar,
                                   ve_fecha                in date);

  --procedure sp_cl_score_cliente(vi_ndoc in varchar2, vo_score out char);
  procedure sp_cl_new_recurrente(vi_ndoc in char, vo_rpta out char);

  procedure sp_cl_ultevaluacion(vi_instancia in number,
                                vi_tdoc      in number,
                                vi_ndoc      in varchar,
                                vo_nsol      out number,
                                vo_tdoc      out varchar2,
                                vo_ndoc      out char,
                                vo_destcre   out varchar2);

end pq_cr_inserta_aqpc573;
/

create or replace package body pq_cr_inserta_aqpc573 is
      
  /*procedure sp_cr_log_scorecliente(ve_tipo_documento       in number,
                                   ve_numero_documento_dos in varchar,
                                   ve_sucursal             in number,
                                   ve_usuario_consulta     in varchar,
                                   ve_fecha                in date) is
  
    vl_rpta             char(1);
    vl_score            varchar2(50);
    vl_score2           varchar2(50);
    vl_scoremicro       char(50);
    vl_scorecons        char(50);
    vl_cant             number;
    ve_numero_documento varchar(50);
    --vl_ntipocre number(4);
    vl_dtipocre   varchar2(30);
    vl_sol        NUMBER(10);
    vl_tdoc       number(5);
    vl_ndoc       char(12);
    vl_vcharndoc  varchar(12);
    habilitar     number(5);
    vl_flagvar    number(2);
    vo_score      varchar(500);
    vl_jaql640    varchar(20);
    vl_jaql639    varchar(20);
    vl_PRDEF      number;
    vl_jaql639dni varchar(20);
    vl_jaql639ruc varchar(20);
  
    jaql639rimy_dni  varchar(50);
    jaql639ricns_dni varchar(50);
    jaql639pdmy_dni  number;
    jaql639pdcns_dni number;
  
    jaql639rimy_ruc  varchar(50);
    jaql639ricns_ruc varchar(50);
    jaql639pdmy_ruc  number;
    jaql639pdcns_ruc number;
  
    vl_PDCNS number;
    vl_PDMY  number;
    --vl_JAQL640RIESG varchar(75);
    --vl_JAQL639RIESG varchar(75);
    vl_tabla                   varchar(20);
    vl_validacion              number;
    vl_fecha_consulta_tabla    date;
    vl_riesgo_letra            varchar(50);
    vl_riesgo_letra_639rimy    varchar(50);
    vl_riesgo_letra_639RICNS   varchar(50);
    vl_score_regla639          varchar(50);
    vl_puntaje                 number;
    vl_cliente                 varchar(100);
    vl_tipo_credito_rcc        varchar(500);
    vl_contador                number;
    vl_pymes_rcc               number;
    vl_consumo_hipotecario_rcc number;
    ve_numero_documento2       varchar(12);
    ve_numero_documento_ruc    varchar(11);
    -- vic_ndoc char(12);
  
  begin
    vl_jaql640    := 'N';
    vl_jaql639    := 'N';
    vl_jaql639dni := 'N';
    vl_jaql639ruc := 'N';
    --calculo _score
  
    -- vic_ndoc:=  vi_ndoc;
    ve_numero_documento := trim(ve_numero_documento_dos);
  
    begin
      SELECT TP1NRO1
       INTO habilitar
       FROM fst198
      where tp1cod = 1
      and tp1cod1 = 10899
        and tp1corr1 = 6000
        AND TP1CORR2 = 10;
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
  
    --DBMS_OUTPUT.put_line('tipo documento: ' ||vl_tdoc );
    --DBMS_OUTPUT.put_line('Destcre: ' ||vl_dtipocre );
  
    IF (habilitar = 2) THEN
      -- SI HABILITADO ES (2), ESTA HABILITADO EL CONTROL          
      BEGIN
      
        if vl_rpta = 'R' or vl_rpta = 'V' then
          --SCORE DE SEGUIMIENTO PARA RECURRENTES ()
          begin
            --            SELECT MAX(substr(JAQL640RIESG, 8, 1)), COUNT(*), max(JAQL640PRDEF)
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
          --if vl_score in ('A','B','C','D','E','F') and vl_cant > 0 then --apachecoh 2022.09.27 se puso en guia
          if -- vl_flagvar > 0
          --and
           vl_cant > 0 then
            DBMS_OUTPUT.put_line('Recurrente encontrado tabla recurrentes JAQL640'); --ecollado
            vl_jaql640 := 'S';
            vo_score   := 'S';
          elsif (vl_cant = 0) then
            --si no esta en la tabla de recurrente lo busca en nuevos
            vl_vcharndoc         := TRIM(vl_ndoc);
            ve_numero_documento2 := trim(ve_numero_documento);
            IF ve_tipo_documento IN (21, 2, 5) or ve_tipo_documento is null THEN
              BEGIN
                --SELECT substr(JAQL639RIMY, 8, 1),
                --     substr(JAQL639RICNS, 8, 1),
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
                         WHERE JAQL639NURUC = ve_numero_documento_ruc --ve_numero_documento2--rpad(ve_numero_documento,11,' ')--trim(ve_numero_documento)--vl_vcharndoc
                        --and JAQL639FEPRE = ve_fecha
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
            IF vl_dtipocre = 'MICROEMPRESAS' or
               vl_dtipocre = 'MICROEMPRESA' or
               vl_dtipocre = 'PEQUEÑA EMPRESA' or vl_dtipocre = 'PYMES RCC'
            --vl_dtipocre = 'CORPORATIVOS' or vl_dtipocre = 'GRAN EMPRESA' or  
            --vl_dtipocre = 'PEQUEÑA EMPRESA' or vl_dtipocre = 'MEDIANA EMPRESA' or vl_dtipocre is null 
             then
              --micro
              vl_score_regla639 := vl_riesgo_letra_639rimy;
              vl_score          := vl_scoremicro;
              --vl_PRDEF := vl_PDCNS;
            END IF;
            IF vl_dtipocre = 'CONSUMO NO REVOLVENTE' or
               vl_dtipocre = 'CONSUMO REVOLVENTE' or
               vl_dtipocre = 'CONSUMO HIPOTECARIO RCC'
            --or
            --vl_dtipocre = 'HIPOTECARIO VIVIENDA' or vl_dtipocre is null 
             then
              --consumo
              vl_score_regla639 := vl_riesgo_letra_639RICNS;
              vl_score          := vl_scorecons;
              --vl_PRDEF := vl_PDMY;
            END IF;
          
            --APACHECOH 2023.03.31
            --if vl_dtipocre = 'PYME_CONSUMO_RCC' then
            if vl_PDCNS >= vl_PDMY then
              vl_score_regla639 := vl_riesgo_letra_639RICNS;
              vl_score          := vl_scorecons;
            else
              vl_score_regla639 := vl_riesgo_letra_639rimy;
              vl_score          := vl_scoremicro;
            end if;
            --end if;  
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
          IF vl_dtipocre = 'MICROEMPRESAS' or vl_dtipocre = 'MICROEMPRESA' or
             vl_dtipocre = 'PEQUEÑA EMPRESA' or vl_dtipocre = 'PYMES RCC'
          --vl_dtipocre = 'CORPORATIVOS' or vl_dtipocre = 'GRAN EMPRESA' or  
          --vl_dtipocre = 'PEQUEÑA EMPRESA' or vl_dtipocre = 'MEDIANA EMPRESA' or vl_dtipocre is null 
           then
            --micro
            vl_score_regla639 := vl_riesgo_letra_639rimy;
            vl_score          := vl_scoremicro;
            --vl_PRDEF := vl_PDCNS;
          END IF;
          IF vl_dtipocre = 'CONSUMO NO REVOLVENTE' or
             vl_dtipocre = 'CONSUMO REVOLVENTE' --or
             or vl_dtipocre = 'CONSUMO HIPOTECARIO RCC'
          --vl_dtipocre = 'HIPOTECARIO VIVIENDA' or vl_dtipocre is null 
           then
            --consumo
            vl_score_regla639 := vl_riesgo_letra_639RICNS;
            vl_score          := vl_scorecons;
            --vl_PRDEF := vl_PDMY;
          END IF;
        
          --APACHECOH 2023.03.31
          --if vl_dtipocre = 'PYME_CONSUMO_RCC' then
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
            --IF vl_score in ('A','B','C','D','E','F') then
            vo_score := 'S';
            --DBMS_OUTPUT.put_line('10');
          ELSE
            vo_score := 'N';
            -- DBMS_OUTPUT.put_line('11');
          END IF;
        END IF;
      
        --IF vl_rpta = 'V' THEN
        --SI ES VACIO
        --vo_score := 'S'; --cambiado a S en caso inexistente
        --END IF;
        -- DBMS_OUTPUT.put_line(vo_score);
      END;
    ELSE
      BEGIN
        vo_score := 'S';
        DBMS_OUTPUT.put_line('Control desahabilitado');
      END;
    END IF;
    --
    --ecollado 27/10/22
    --score null ruc
    if vl_score is null then
      ------
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
                 WHERE JAQL639NURUC = ve_numero_documento_ruc --rpad(ve_numero_documento,11,' ')--trim(ve_numero_documento)--vl_vcharndoc
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
    
      IF vl_dtipocre = 'MICROEMPRESAS' or vl_dtipocre = 'MICROEMPRESA' or
         vl_dtipocre = 'PEQUEÑA EMPRESA' or vl_dtipocre = 'PYMES RCC'
      --vl_dtipocre = 'CORPORATIVOS' or vl_dtipocre = 'GRAN EMPRESA' or  
      --vl_dtipocre = 'PEQUEÑA EMPRESA' or vl_dtipocre = 'MEDIANA EMPRESA' or vl_dtipocre is null 
       then
        --micro
        vl_score_regla639 := vl_riesgo_letra_639rimy;
        vl_score          := vl_scoremicro;
        --vl_PRDEF := vl_PDCNS;
      END IF;
      IF vl_dtipocre = 'CONSUMO NO REVOLVENTE' or
         vl_dtipocre = 'CONSUMO REVOLVENTE' --or
         or vl_dtipocre = 'CONSUMO HIPOTECARIO RCC'
      --vl_dtipocre = 'HIPOTECARIO VIVIENDA' or vl_dtipocre is null 
       then
        --consumo
        vl_score_regla639 := vl_riesgo_letra_639RICNS;
        vl_score          := vl_scorecons;
        --vl_PRDEF := vl_PDMY;
      END IF;
    
      --APACHECOH 2023.03.31
      --if vl_dtipocre = 'PYME_CONSUMO_RCC' then
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
      --vl_puntaje : = ( ln( (1-jaql640prdef)/jaql640prdef ) )   * 77 / ln(2.3) + 350
    Else
      if vl_jaql640 = 'N' and vl_jaql639 = 'S' then
        vl_tabla := 'JAQL639';
      else
        vl_tabla := '';
      end if;
      --vl_tabla := 'JAQL639';
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
                   WHERE JAQL639NUIDE = ve_numero_documento2 --rpad(ve_numero_documento,12,' ')--ve_numero_documento
                  --and JAQL639FEPRE = ve_fecha
                   ORDER BY JAQL639FEPRE DESC)
           WHERE ROWNUM = 1;
        exception
          when others then
            null;
        END;
        vl_score2 := trim(vl_score);
        If vl_score2 = jaql639rimy_dni then
          vl_PRDEF := jaql639pdmy_dni;
        Else
          vl_PRDEF := jaql639pdcns_dni;
        End if;
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
        If vl_score2 = jaql639rimy_ruc then
          vl_PRDEF := jaql639pdmy_ruc;
        Else
          vl_PRDEF := jaql639pdcns_ruc;
        End if;
      End if;
    End if;
  
    begin
      select count(*)
        into vl_validacion
        from aqpc573
       where aqpc573tidoc = ve_tipo_documento
         and aqpc573nudoc = ve_numero_documento
         and aqpc573ussuc = ve_sucursal
         and aqpc573uscon = ve_usuario_consulta
      --and aqpc573fepre = ve_fecha
      ;
    exception
      when others then
        null;
    end;
  
    if vl_validacion >= 1 then
      ve_numero_documento2 := trim(ve_numero_documento);
      --if length(trim(ve_numero_documento))<= 12 then
      --ve_numero_documento_ruc := trim(ve_numero_documento);        
      --end if;
    
      begin
        update aqpc573
           set aqpc573estad = 'N'
         where aqpc573tidoc = ve_tipo_documento
           and aqpc573nudoc = ve_numero_documento2
              --and aqpc573ussuc = ve_sucursal
           and aqpc573uscon = ve_usuario_consulta
        --and aqpc573fepre = ve_fecha
        ;
        commit;
      exception
        when others then
          null;
      end;
    
    End if;
  
    --vl_jaql640:= 'S';
    --vl_jaql639:= 'N';
    --vl_PRDEF := 0.0301600;
    --vl_prdef := 0.08880;
    --vl_prdef := 1;
    --vl_prdef := 0.9808700;
    --vl_prdef := 0.92277;
  
    If vl_jaql640 = 'S' and vl_jaql639 = 'N' and
       (vl_prdef != 0 and vl_prdef != 1 and vl_prdef != 1000) then
      vl_puntaje := TRUNC((ln((1 - vl_PRDEF) / vl_PRDEF)) * 77 / ln(2.3) + 350);
    Elsif vl_jaql640 = 'N' and vl_jaql639 = 'S' and
          (vl_prdef != 0 and vl_prdef != 1 and vl_prdef != 1000) then
      vl_puntaje := TRUNC((ln((1 - vl_PRDEF) / vl_PRDEF)) * 91 / ln(1.7) + 190);
    End if;
  
    if vl_PRDEF = 1 then
      vl_puntaje := 0;
    Elsif vl_PRDEF = 0 then
      vl_puntaje := 982;
    End if;
  
    if vl_puntaje < 122 then
      vl_puntaje := 122;
    Elsif vl_puntaje > 982 then
      vl_puntaje := 982;
    End if;
  
    vl_score2 := trim(vl_score);
  
    if vl_score2 is null or vl_score2 = 'SIN SCORE' then
      vl_score   := 'SIN SCORE';
      vl_score2  := 'SIN SCORE';
      vl_puntaje := 0;
    end if;
    ve_numero_documento2 := trim(ve_numero_documento);
  
    begin
      insert into aqpc573
      values
        (ve_tipo_documento,
         ve_numero_documento2,
         'S', --estado activa S/N
         vl_cliente, -- cliente actualizar *
         vl_puntaje, --actualizar->puntaje *
         vl_tabla, --tabla
         vl_fecha_consulta_tabla, --fecha consulta tablas jaql639,jaql640
         vl_score2, -- Riesgo-> JAQL640RIESG // JAQL639RICNS o JAQL639RIMY
         vl_dtipocre, --tipo_credito
         vl_PRDEF, -- JAQL640PRDEF // JAQL639PDCNS o JAQL639PDMY
         ve_sucursal,
         ve_usuario_consulta,
         ve_fecha,
         (select to_char(sysdate, 'HH24:MI:SS') from dual));
      commit;
    exception
      when others then
        null;
    end;
  
  end sp_cr_log_scorecliente;
  */
  -------------
  
  
    -- ***************************************************************** 
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2023.08.07
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : Obtiene correo del cliente
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : ve_tipo_documento number
    --                            : ve_numero_documento varchar2
    --                            : ve_sucursal number
    --                            : ve_usuario_consulta varchar2
    --                            : ve_fecha date
    --
    -- Retorno                    : Graba en tabla AQPC573
    -- *****************************************************************
  procedure sp_cr_log_scorecliente(ve_tipo_documento       in number,
                                   ve_numero_documento_dos in varchar,
                                   ve_sucursal             in number,
                                   ve_usuario_consulta     in varchar,
                                   ve_fecha                in date) is
  
    
    ve_numero_documento varchar2(12);
    vl_rpta             char(1);
    vl_cant             number;
    vl_validacion       number;
    vl_puntaje          number;
    vl_fecha_riesg      date;
    vl_score            varchar2(50);
    vl_cliente          varchar2(50);
    vl_dtipocre         varchar2(50);    
    vl_jaql640          varchar2(5);
    vl_jaql639          varchar2(5);
    
    ln_inst             number(10);
    lc_prgm             varchar2(50);
    lc_score            varchar2(50);
    lc_scoreabr         varchar2(50);
    ln_probal           number(9,7);
    lc_segmriesgo       varchar2(50);
    ln_pdcal            number(5,5);
    lc_tabla            varchar2(50);
    ld_fchscore         date; 
    lc_agrupriesgo      varchar2(50);   
      
  begin
    vl_jaql640    := 'N';
    vl_jaql639    := 'N';
    
    ve_numero_documento := trim(ve_numero_documento_dos);
    lc_prgm := 'CRU';
    
    begin
      -- Call the procedure
      pq_cr_score_rcc.sp_cr_scoredni_ii(ln_inst => ln_inst,
                                     ln_tdoc => ve_tipo_documento,
                                     lc_ndoc => ve_numero_documento_dos,
                                     lc_prgm => lc_prgm,
                                     lc_user => ve_usuario_consulta,
                                     lc_score => lc_score,
                                     ln_probal => ln_probal,
                                     lc_segmriesgo => lc_segmriesgo,
                                     ln_pdcal => ln_pdcal,
                                     lc_tabla => lc_tabla,
                                     ld_fchscore => ld_fchscore,
                                     lc_scoreabr => lc_scoreabr,
                                     lc_NewScore => lc_agrupriesgo);
    end;    
    
    begin
      select count(*)
        into vl_validacion
        from aqpc573
       where aqpc573tidoc = ve_tipo_documento
         and aqpc573nudoc = ve_numero_documento
         --and aqpc573ussuc = ve_sucursal
         and aqpc573uscon = ve_usuario_consulta;
    exception
      when others then
        null;
    end;
  
    If vl_validacion >= 1 then
      begin
        update aqpc573
           set aqpc573estad = 'N'
         where aqpc573tidoc = ve_tipo_documento
           and aqpc573nudoc = ve_numero_documento
           and aqpc573uscon = ve_usuario_consulta;
        commit;
      exception
        when others then
          null;
      end;    
    End if;
       
    vl_cliente := 'NUEVO';    
    vl_fecha_riesg := null;
    
    If lc_tabla = 'JAQL640' and
       (ln_probal != 0 and ln_probal != 1 and ln_probal != 1000) then       
      vl_puntaje := TRUNC((ln((1 - ln_probal) / ln_probal)) * 77 / ln(2.3) + 350);      
      vl_cliente := 'CAJA AREQUIPA'; 
      /*begin
           SELECT TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, -1))) into vl_fecha_riesg FROM dual;
      exception when others then
            vl_fecha_riesg := null;
      end; */     
           
    Elsif lc_tabla = 'JAQL639' and
          (ln_probal != 0 and ln_probal != 1 and ln_probal != 1000) then          
      vl_puntaje := TRUNC((ln((1 - ln_probal) / ln_probal)) * 91 / ln(1.7) + 190);   
      
      /*begin        
           SELECT TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, -2))) into vl_fecha_riesg FROM dual;
      exception when others then        
           vl_fecha_riesg := null;
      end;*/
      
    End if;
  
    If ln_probal = 1 then
      vl_puntaje := 0;
    Elsif ln_probal = 0 then
      vl_puntaje := 982;
    End if;
  
    If vl_puntaje < 122 then
      vl_puntaje := 122;
    Elsif vl_puntaje > 982 then
      vl_puntaje := 982;
    End if;  
     
    If lc_score = 'SIN SCORE' then    
        vl_puntaje := 0.00;
    End if;
    
    vl_dtipocre := '--';
    
    begin
      insert into aqpc573(
      AQPC573TIDOC, AQPC573NUDOC, AQPC573ESTAD, AQPC573TIPCL, AQPC573PUNTJ, AQPC573TABLA, AQPC573FEPRE, AQPC573RIESG, AQPC573TICRE, AQPC573PRDEF, AQPC573USSUC, AQPC573USCON, AQPC573FECON, AQPC573HOCON, AQPC573AGRUP
      )
      values
        (ve_tipo_documento,
         ve_numero_documento,
         'S', --estado activa S/N
         vl_cliente, -- cliente actualizar *
         vl_puntaje, --actualizar->puntaje *
         lc_tabla, --tabla
         ld_fchscore, --fecha consulta tablas jaql639,jaql640
         lc_scoreabr, -- Riesgo-> JAQL640RIESG // JAQL639RICNS o JAQL639RIMY
         vl_dtipocre, --tipo_credito
         ln_probal, -- JAQL640PRDEF // JAQL639CALMYP o JAQL639CALCNS
         ve_sucursal,
         ve_usuario_consulta,
         ve_fecha,
         (select to_char(sysdate, 'HH24:MI:SS') from dual),
         lc_agrupriesgo --apachecoh 2024.01.16
         );
      commit;
    exception
      when others then
        null;
    end;
  
  end sp_cr_log_scorecliente;
  
  procedure sp_cl_new_recurrente(vi_ndoc in char, vo_rpta out char) is
  
    vl_new     number := 0;
    vl_sol     NUMBER(10);
    vl_tdoc    number(5);
    vl_ndoc    char(12);
    vl_destcre varchar2(30);
  begin
  
    begin
      PQ_CL_SEGUIMIENTO_CLIENTES.sp_cl_ultevaluacion(0,
                                                     0,
                                                     vi_ndoc,
                                                     vo_nsol    => vl_sol,
                                                     vo_tdoc    => vl_tdoc,
                                                     vo_ndoc    => vl_ndoc,
                                                     vo_destcre => vl_destcre);
    exception
      when others then
        null;
    end;
  
    begin
      SELECT COUNT(*)
        into vl_new
        FROM FSD010 a, FSR008 b
       WHERE AOCTA = CTNRO
         AND a.pgcod = b.pgcod
         AND aomod in (select h.modulo from fst111 h where h.dscod = 50)
         AND CTTFIR = 'T'
         AND TTCOD = 1
         AND PENDOC = vi_ndoc;
    exception
      when others then
        null;
    end;
  
    -- DBMS_OUTPUT.put_line('Tiene creditos:' || vl_new);
  
    if vl_new > 0 AND LENGTH(vl_destcre) > 0 then
      -- DBMS_OUTPUT.put_line('Es recuerrente');
      vo_rpta := 'R';
    elsif vl_new = 0 AND LENGTH(vl_destcre) > 0 THEN
      --  DBMS_OUTPUT.put_line('Es nuevo');
      vo_rpta := 'N';
    else
      vo_rpta := 'V';
      --DBMS_OUTPUT.put_line('Cliente vacio o nulo');
    end if;
    DBMS_OUTPUT.put_line(vo_rpta);
  end sp_cl_new_recurrente;

  procedure sp_cl_ultevaluacion(vi_instancia in number,
                                vi_tdoc      in number,
                                vi_ndoc      in varchar,
                                vo_nsol      out number,
                                vo_tdoc      out varchar2,
                                vo_ndoc      out char,
                                vo_destcre   out varchar2) is
  
    vl_ndoc  char(12);
    err_code NUMBER;
    err_msg  VARCHAR2(1500);
  begin
    vl_ndoc := vi_ndoc;
    IF (vi_instancia > 0) THEN
      BEGIN
        SELECT SNG021NDOC
          INTO vl_ndoc
          FROM SNG021
         WHERE SNG021SOL = vi_instancia;
      EXCEPTION
        WHEN OTHERS THEN
          null;
      END;
      -- sacamos la ultima evaluacion registrada
      BEGIN
        SELECT SNG021SOL,
               SNG021TDOC,
               SNG021NDOC,
               CASE
                 WHEN SNG021TMOD = 13 THEN
                  'MICROEMPRESAS'
                 WHEN SNG021TMOD = 14 THEN
                  'CONSUMO NO REVOLVENTE'
               END
          INTO vo_nsol, vo_tdoc, vo_ndoc, vo_destcre
          FROM (SELECT *
                  FROM SNG021
                --        WHERE TRIM(SNG021NDOC) = vl_ndoc
                 WHERE SNG021NDOC = vl_ndoc
                 ORDER BY SNG021FEC DESC)
         WHERE ROWNUM = 1;
      EXCEPTION
        WHEN OTHERS THEN
          vo_nsol  := 0;
          err_code := SQLCODE;
          err_msg  := SUBSTR(SQLERRM, 1, 500);
          --DBMS_OUTPUT.put_line('ERROR: ' || err_code || '-' || err_msg );
      
      END;
    ELSIF ( /*vi_tdoc > 0 AND*/
           length(vl_ndoc) > 0) THEN
      BEGIN
        SELECT SNG021SOL,
               SNG021TDOC,
               SNG021NDOC,
               CASE
                 WHEN SNG021TMOD = 13 THEN
                  'MICROEMPRESAS'
                 WHEN SNG021TMOD = 14 THEN
                  'CONSUMO NO REVOLVENTE'
               END
          INTO vo_nsol, vo_tdoc, vo_ndoc, vo_destcre
          FROM (SELECT *
                  FROM SNG021
                 WHERE SNG021NDOC = vl_ndoc
                 ORDER BY SNG021FEC DESC)
         WHERE ROWNUM = 1;
      
        --     DBMS_OUTPUT.put_line('1');
      EXCEPTION
        WHEN OTHERS THEN
          vo_nsol  := 0;
          err_code := SQLCODE;
          err_msg  := SUBSTR(SQLERRM, 1, 500);
          --DBMS_OUTPUT.put_line('ERROR: ' || err_code || '-' || err_msg );
      END;
    ELSE
      DBMS_OUTPUT.put_line('Debe isnertar Nro isntancia o Nro documento:');
    END IF;
  
  end sp_cl_ultevaluacion;

end pq_cr_inserta_aqpc573;
/

