create or replace package PQ_CR_POLITICAS_SEGM_RIESGOS is

  -- Author  : APACHECOH
  -- Created : 5/04/2023 12:04:41
  -- Purpose : 

  procedure sp_cr_obtener_calificacion(ve_tipo_documento   in number,
                                       ve_numero_documento in varchar,
                                       vo_calificacion     out varchar);
  procedure sp_cr_obtener_fecha_max;

end PQ_CR_POLITICAS_SEGM_RIESGOS;
/

create or replace package body PQ_CR_POLITICAS_SEGM_RIESGOS is

  procedure sp_cr_obtener_calificacion(ve_tipo_documento   in number,
                                       ve_numero_documento in varchar,
                                       vo_calificacion     out varchar) is
  
    vl_rpta char(1);
    vl_cant number;
  
    vl_flagvar number(2);
    vl_jaql640 varchar(20);
    vl_jaql639 varchar(20);
  
    vl_tabla                   varchar(20);
    vl_validacion              number;
    vl_tipo_credito_rcc        varchar(50);
    vl_tipo_credito            varchar(50);
    vl_tipo_credito2           varchar(50);
    vl_contador                number;
    vl_pymes_rcc               number;
    vl_consumo_hipotecario_rcc number;
  
    vl_califi        varchar2(10);
    vl_dtipocre      varchar2(50);
    vl_sol           number(10);
    vl_tdoc          number(5);
    vl_ndoc          char(12);
    vl_jaql639_p     varchar2(2);
    vl_jaql639_c     varchar2(2);
    vl_califi_p      varchar2(10);
    vl_califi_c      varchar2(10);
    vl_maxjaql639    date;
    vl_maxjaql640    date;
    fech_max_jaql641 date;
  begin
    vl_jaql640 := 'N';
    vl_jaql639 := 'N';
  
    --Se actualiza en el proceso de carga de riesgos
    /*begin
      PQ_CR_POLITICAS_SEGM_RIESGOS.sp_cr_obtener_fecha_max(); --Cambiado por Ede 14/04/2023
    exception
      when others then
        null;
    end;*/
  
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
  
    if (vl_dtipocre is null) then
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
      
      elsif (vl_consumo_hipotecario_rcc >= 1) and (vl_pymes_rcc >= 1) then
        vl_tipo_credito_rcc := 'PYME_CONSUMO_RCC';
      
      elsif vl_pymes_rcc = 0 and vl_consumo_hipotecario_rcc = 0 then
      
        --ruc      
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
        
        elsif (vl_consumo_hipotecario_rcc >= 1) and (vl_pymes_rcc >= 1) then
          vl_tipo_credito_rcc := 'PYME_CONSUMO_RCC';
        
        else
          vl_tipo_credito_rcc := 'NUEVO';
        
        end if;
        --end ruc
      
      else
        vl_tipo_credito_rcc := 'NUEVO';
      end if;
    
      vl_dtipocre := vl_tipo_credito_rcc;
    end if;
  
    /*begin
      PQ_CL_SEGUIMIENTO_CLIENTES.sp_cl_new_recurrente(ve_numero_documento,
                                                      vo_rpta => vl_rpta);
    
    exception
      when others then
        null;
    end;*/
    /*if vl_tipo_credito_rcc = 'PYME_CONSUMO_RCC' then
      begin
        SELECT MAX(JAQL640SEGMEN),
               COUNT(*)
          INTO vl_califi,
               vl_cant
          FROM JAQL640
         WHERE JAQL640PTDOC = ve_tipo_documento
           AND JAQL640PNDOC = ve_numero_documento
           --AND JAQL640TICRE = vl_tipo_credito_rcc
           AND JAQL640FEPRE = (SELECT MAX(JAQL640FEPRE) FROM JAQL640);
      exception
        when others then
          null;
      end;    
    else*/
    if vl_dtipocre = 'MICROEMPRESAS' or vl_dtipocre = 'MICROEMPRESA' or
       vl_dtipocre = 'PEQUEÑA EMPRESA' or vl_dtipocre = 'PYMES RCC' then
      vl_tipo_credito  := 'PYME';
      vl_tipo_credito2 := 'PYME';
    
    elsif vl_dtipocre = 'CONSUMO NO REVOLVENTE' or
          vl_dtipocre = 'CONSUMO REVOLVENTE' or
          vl_dtipocre = 'CONSUMO HIPOTECARIO RCC' then
      vl_tipo_credito  := 'CONSUMO';
      vl_tipo_credito2 := 'CONSUMO';
    
    elsif vl_dtipocre = 'PYME_CONSUMO_RCC' then
      vl_tipo_credito  := 'PYME';
      vl_tipo_credito2 := 'CONSUMO';
    
    else
      vl_tipo_credito := '';
    end if;
  
    --Obtener fecha de carga máxima
    begin
      SELECT to_date(TP1DESC, 'dd/mm/rrrr')
        into vl_maxjaql640
        FROM fst198
       where tp1cod = 1
         and tp1cod1 = 11169
         and tp1corr1 = 2
         and tp1corr2 = 1
         and tp1corr3 = 2;
    exception
      when others then
        null;
    end;
  
    begin
      SELECT MAX(JAQL640SEGMEN), COUNT(*)
        INTO vl_califi, vl_cant
        FROM (SELECT JAQL640SEGMEN,
                     CASE
                       WHEN JAQL640TICRE = 'CONSUMO NO REVOLVENTE' THEN
                        'CONSUMO'
                       ELSE
                        'PYME'
                     END AS TIPCRE
                FROM JAQL640
               WHERE JAQL640PTDOC = ve_tipo_documento
                 AND JAQL640PNDOC = rpad(ve_numero_documento, 12, ' ')
                 AND JAQL640FEPRE = vl_maxjaql640)
       WHERE TIPCRE = vl_tipo_credito
          or TIPCRE = vl_tipo_credito2;
    exception
      when others then
        vl_cant    := 0;
        vl_jaql640 := 'N';
    end;
  
    if vl_cant > 0 then
      vl_jaql640      := 'S';
      vo_calificacion := substr(vl_califi, 3, 10);
    else
      --Obtener fecha de carga máxima
      begin      
        SELECT to_date(TP1DESC, 'dd/mm/rrrr')
          into vl_maxjaql639
          FROM fst198
         where tp1cod = 1
           and tp1cod1 = 11169
           and tp1corr1 = 2
           and tp1corr2 = 1
           and tp1corr3 = 1;
      exception
        when others then
          null;
      end;
      --PERSONA NATURAL
      if ve_tipo_documento IN (21, 2, 5) or ve_tipo_documento is null then
        --PYME
        if vl_dtipocre = 'MICROEMPRESAS' or vl_dtipocre = 'MICROEMPRESA' or
           vl_dtipocre = 'PEQUEÑA EMPRESA' or vl_dtipocre = 'PYMES RCC' then
          begin
            SELECT MAX(JAQL639SEGMYP), 'S'
              INTO vl_califi, vl_jaql639_p
              FROM JAQL639
             WHERE JAQL639FEPRE = vl_maxjaql639
               AND --WHERE JAQL639NUIDE = ve_numero_documento);
                   JAQL639NUIDE = ve_numero_documento;
          
            vl_jaql639 := 'S';
          exception
            when others then
              vl_jaql639   := 'N';
              vl_jaql639_p := 'N';
          end;
          --CONSUMO
        elsif vl_dtipocre = 'CONSUMO NO REVOLVENTE' or
              vl_dtipocre = 'CONSUMO REVOLVENTE' or
              vl_dtipocre = 'CONSUMO HIPOTECARIO RCC' then
          begin
            SELECT MAX(JAQL639SEGCON), 'S'
              INTO vl_califi, vl_jaql639_c
              FROM JAQL639
             WHERE JAQL639FEPRE = vl_maxjaql639
                  --WHERE JAQL639NUIDE = ve_numero_documento);
               AND JAQL639NUIDE = ve_numero_documento;
          
            vl_jaql639 := 'S';
          exception
            when others then
              vl_jaql639   := 'N';
              vl_jaql639_c := 'N';
          end;
          --AMBOS TIPOS
        else
          begin
            SELECT MAX(JAQL639SEGMYP), MAX(JAQL639SEGCON)
              INTO vl_califi_p, vl_califi_c
              FROM JAQL639
             WHERE JAQL639FEPRE = vl_maxjaql639
                  --WHERE JAQL639NUIDE = ve_numero_documento);
               AND JAQL639NUIDE = ve_numero_documento;
          
            vl_jaql639   := 'S';
            vl_jaql639_p := 'S';
            vl_jaql639_c := 'S';
          exception
            when others then
              vl_jaql639   := 'N';
              vl_jaql639_p := 'N';
              vl_jaql639_c := 'N';
          end;
        end if;
      else
        --PERSONA JURIDICA
        if vl_dtipocre = 'MICROEMPRESAS' or vl_dtipocre = 'MICROEMPRESA' or
           vl_dtipocre = 'PEQUEÑA EMPRESA' or vl_dtipocre = 'PYMES RCC' then
          begin
            SELECT MAX(JAQL639SEGMYP), 'S'
              INTO vl_califi, vl_jaql639_p
              FROM JAQL639
             WHERE JAQL639FEPRE = vl_maxjaql639
               AND JAQL639NURUC = ve_numero_documento;
          
            vl_jaql639 := 'S';
          exception
            when others then
              vl_jaql639   := 'N';
              vl_jaql639_p := 'N';
          end;
          --CONSUMO
        elsif vl_dtipocre = 'CONSUMO NO REVOLVENTE' or
              vl_dtipocre = 'CONSUMO REVOLVENTE' or
              vl_dtipocre = 'CONSUMO HIPOTECARIO RCC' then
          begin
            SELECT MAX(JAQL639SEGCON), 'S'
              INTO vl_califi, vl_jaql639_c
              FROM JAQL639
             WHERE JAQL639FEPRE = vl_maxjaql639
               AND JAQL639NURUC = ve_numero_documento;
            vl_jaql639 := 'S';
          exception
            when others then
              vl_jaql639   := 'N';
              vl_jaql639_c := 'N';
          end;
          --AMBOS TIPOS
        else
          begin
            SELECT MAX(JAQL639SEGMYP), MAX(JAQL639SEGCON)
              INTO vl_califi_p, vl_califi_c
              FROM JAQL639
             WHERE JAQL639FEPRE = vl_maxjaql639
               AND JAQL639NURUC = ve_numero_documento;
            vl_jaql639   := 'S';
            vl_jaql639_c := 'S';
            vl_jaql639_p := 'S';
          exception
            when others then
              vl_jaql639   := 'N';
              vl_jaql639_p := 'N';
              vl_jaql639_c := 'N';
          end;
        end if;
      end if;
      if vl_jaql639 = 'N' then
        vo_calificacion := '';
      else
        if vl_jaql639_p = 'S' and vl_jaql639_c = 'S' then
          if vl_califi_p >= vl_califi_c then
            vo_calificacion := substr(vl_califi_p, 3, 10);
          else
            vo_calificacion := substr(vl_califi_c, 3, 10);
          end if;
        else
          vo_calificacion := substr(vl_califi, 3, 10);
        end if;
      end if;
    end if;
  end sp_cr_obtener_calificacion;

  procedure sp_cr_obtener_fecha_max is
    fecha_guia   date;
    fmax_jaql639 date;
    fmax_jaql640 date;
    fmax_jaql641 date;
    fjaql639     char(30);
    fjaql640     char(30);
    --1 Hacer un script que saque la fecha maxima de la  criesgos.jaql641
    --2 Compara con la fecha de la guia TP1CORR3 = 3 
    --3 si es igual no hago nada si es diferente actualizo la guía en el tp1corr3 y 
    --saco el maximo de jaqla639 y 640 y actualizar en la guia 
  begin
  
    begin
      select max(jaql641fecar)
        into fmax_jaql641
        from criesgos.jaql641
       where jaql641aradm = 'SCORE_CNS_MYPE.csv'
          or jaql641arseg = 'SCORE.txt';
    exception
      when others then
        null;
    end;
  
    begin
      SELECT to_date(TP1DESC, 'dd/mm/rrrr')
        into fecha_guia
        FROM fst198
       where tp1cod = 1
         and tp1cod1 = 11169
         and tp1corr1 = 2
         and tp1corr2 = 1
         and tp1corr3 = 3;
    exception
      when others then
        null;
    end;
  
    if (fecha_guia = fmax_jaql641) then
      --DBMS_OUTPUT.PUT_LINE('No se hace nada');
      return;
    else
      begin
        UPDATE fst198
           SET TP1DESC = TO_CHAR(fmax_jaql641, 'dd/mm/rrrr')
         WHERE tp1cod = 1
           and tp1cod1 = 11169
           and tp1corr1 = 2
           and tp1corr2 = 1
           and tp1corr3 = 3;
        commit;
      end;
    
      begin
        begin
          select max(jaql639fepre) into fmax_jaql639 from jaql639;
        exception
          when others then
            return;
        end;
      
        begin
          select max(jaql640fepre) into fmax_jaql640 from jaql640;
        exception
          when others then
            return;
        end;
      
        begin
          UPDATE fst198
             SET TP1DESC = TO_CHAR(fmax_jaql640, 'dd/mm/rrrr')
           WHERE tp1cod = 1
             and tp1cod1 = 11169
             and tp1corr1 = 2
             and tp1corr2 = 1
             and tp1corr3 = 2;
        
          UPDATE fst198
             SET TP1DESC = TO_CHAR(fmax_jaql639, 'dd/mm/rrrr')
           WHERE tp1cod = 1
             and tp1cod1 = 11169
             and tp1corr1 = 2
             and tp1corr2 = 1
             and tp1corr3 = 1;
          commit;
        exception
          when others then
            null;
        end;
      
      end;
    end if;
  
  end sp_cr_obtener_fecha_max;

end PQ_CR_POLITICAS_SEGM_RIESGOS;
/

