create or replace package PQ_CR_SEGMNXCOMPORT is

  -- *****************************************************************
  -- Nombre                     : Proceso para Segmentacion por comportamiento - Afectacion
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 15/02/2023 14:23:03
  -- Autor de Creación          : MARIA POSTIGO
  -- Uso                        : Calculo de Afectacion
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : Docuemtno del cliente / Instancia
  -- Fecha de Modificación      : 17/07/2024
  -- Autor de la Modificación   : MPOSTIGOC
  -- Descripción de Modificación:  Se agrego la validacion de CIIU para calcular la afectacion del cliente
  -- *****************************************************************

  procedure sp_cr_Inicio(ln_instancia  in number,
                         ln_pais       in number,
                         ln_tdoc       in number,
                         lc_ndoc       in varchar2,
                         lc_usuario    in varchar2,
                         lc_afectacion out varchar2);
  --------------------------------------------------
  procedure sp_cr_iniciorp(ln_instancia  in number,
                           lc_usuario    in varchar2,
                           lc_afectacion out varchar2);
  --------------------------------------------------
  procedure sp_cr_inicioCRU(ln_sucusu     in number,
                            ln_PAIS       in number,
                            ln_PETDOC     in number,
                            lc_PENDOC     in varchar2,
                            lc_usuario    in varchar2,
                            lc_afectacion out varchar2);
  --------------------------------------------------
  procedure sp_ciiu_codigo(P_PAIS     in number,
                           P_PETDOC   in number,
                           P_PENDOC   in char,
                           lc_codciiu out number);
  ---------------------------------------------------
  procedure sp_cr_segmentoactual(ln_pais          in number,
                                 ln_tdoc          in number,
                                 lc_nrodoc        in varchar2,
                                 lc_SegmntoActual out number);
  ---------------------------------------------------
  procedure sp_cr_InsertLogAQPB158(ln_inst    in number,
                                   ln_pais    in number,
                                   ln_tdoc    in number,
                                   lc_ndoc    in varchar2,
                                   ln_suc     in number,
                                   lc_afec    in varchar2,
                                   ln_meval   in number,
                                   ln_ciuu    in number,
                                   lc_cven    in varchar2,
                                   lc_usuario in varchar2);
  ------------------------------------------------------
  procedure sp_cr_iniciAfecFAETur(ln_instancia  in number,
                                  lc_usuario    in varchar2,
                                  lc_afectacion out varchar2);
  ---------------------------------------------------------
  procedure sp_cr_InsertLogAQPB158A(ln_inst    in number,
                                    ln_pais    in number,
                                    ln_tdoc    in number,
                                    lc_ndoc    in varchar2,
                                    ln_suc     in number,
                                    lc_afec    in varchar2,
                                    lc_usuario in varchar2);

end PQ_CR_SEGMNXCOMPORT;
/

create or replace package body PQ_CR_SEGMNXCOMPORT is

  procedure sp_cr_Inicio(ln_instancia  in number,
                         ln_pais       in number,
                         ln_tdoc       in number,
                         lc_ndoc       in varchar2,
                         lc_usuario    in varchar2,
                         lc_afectacion out varchar2) is
  
    ln_inst   number;
    ln_SucUsu number;
  
  begin
  
    ln_inst := nvl(ln_instancia, 0);
  
    if ln_inst > 500 then
    
      begin
        -- Call the procedure
        pq_cr_segmnxcomport.sp_cr_iniciorp(ln_inst,
                                           lc_usuario,
                                           lc_afectacion);
      end;
    
    else
    
      begin
        select f.ubsuc
          into ln_SucUsu
          from fst046 f
         where f.pgcod = 1
           and f.ubuser = RPAD(lc_usuario, 10, ' ');
      exception
        when others then
          ln_SucUsu := 999;
      end;
    
      pq_Cr_segmnxcomport.sp_cr_inicioCRU(ln_SucUsu,
                                          ln_pais,
                                          ln_tdoc,
                                          lc_ndoc,
                                          lc_usuario,
                                          lc_afectacion);
    
    end if;
  
  end sp_cr_Inicio;

  ------------------------------------------------------
  procedure sp_cr_iniciorp(ln_instancia  in number,
                           lc_usuario    in varchar2,
                           lc_afectacion out varchar2) is
  
    cursor cuentas(ln_pais number, ln_tdoc number, lc_ndoc varchar2) is
    
      select f.ctnro
        from fsr008 f
       where f.pepais = ln_pais
         and f.petdoc = ln_tdoc
         and f.pendoc = rpad(lc_ndoc, 12, ' ')
         and f.cttfir = 'T';
  
    ln_pais        number;
    ln_tdoc        number;
    lc_ndoc        varchar2(12);
    ln_sucursal    number;
    ln_credvencido number;
    --ln_depto number;
    lc_afectAux      varchar2(30);
    ld_FchCorte      date;
    ln_ModEval       number;
    ln_codCIUU       number;
    ln_afectespecial number;
    ln_paiscy        number;
    ln_tdoccy        number;
    lc_ndoccy        varchar2(12);
    lc_credvencido   varchar2(5);
    lc_SegmntoActual number;
  
  begin
  
    lc_afectacion := 'NINGUNA';
  
    begin
      update aqpb158 a
         set a.aqpb158est = 'I'
       where a.aqpb158inst = ln_instancia;
    exception
      when others then
        null;
    end;
  
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_pais, ln_tdoc, lc_ndoc
        from sng001 s
       where s.sng001inst = ln_instancia;
    exception
      when others then
        null;
    end;
  
    begin
      select x.xwfsucursal
        into ln_sucursal
        from xwf700 x
       where x.xwfprcins = ln_instancia
         and x.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
    /* begin
          select to_number(f.scdept) into ln_depto from fst001 f where  f.sucurs= ln_sucursal;
      end;
      
      begin
    select  from fst068 s where s.pais= 604 and s.depcod=  ln_depto ; --departamento
      end;*/
  
    begin
      select to_date(f.tp1nro1, 'DD/MM/YYYY')
        into ld_FchCorte
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 10823
         and f.tp1corr1 = 55
         and f.tp1corr2 = 4
         and f.tp1corr3 = 1;
    exception
      when others then
        null;
    end;
  
    if ld_FchCorte is null then
      ld_FchCorte := '30/11/2022';
    end if;
  
    begin
      select trim(f.tp1desc)
        into lc_afectAux
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 10823
         and f.tp1corr1 = 55
         and f.tp1corr2 = 3
         and f.tp1nro1 = ln_sucursal;
    exception
      when others then
        lc_afectAux := 'NINGUNA';
    end;
  
    begin
      begin
        select s.sng021tmod
          into ln_ModEval
          from sng021 s
         where s.sng021sol = ln_instancia;
      exception
        when others then
          null;
      end;
    
      ln_ModEval := nvl(ln_ModEval, 0);
    
      if ln_ModEval = 0 then
        pq_cr_rte_verificasegmento.sp_cr_SegmntoActual(ln_Instancia,
                                                       lc_SegmntoActual);
      
        if lc_SegmntoActual = 1 then
          ln_ModEval := 13;
        else
          if lc_SegmntoActual = 2 then
            ln_ModEval := 14;
          end if;
        end if;
      end if;
    
    end;
  
    begin
      --- Datos del Cnyuge
      select f.rppais, f.rptdoc, f.rpndoc
        into ln_paiscy, ln_tdoccy, lc_ndoccy
        from fsr002 f
       where f.pepais = ln_pais
         and f.petdoc = ln_tdoc
         and f.pendoc = lc_ndoc
         and f.rpccyg = 66;
    exception
      when no_data_found then
        begin
          select f.rppais, f.rptdoc, f.rpndoc
            into ln_paiscy, ln_tdoccy, lc_ndoccy
            from fsr002 f
           where f.rppais = ln_pais
             and f.rptdoc = ln_tdoc
             and f.rpndoc = lc_ndoc
             and f.rpccyg = 66;
        exception
          when others then
            null;
        end;
      when others then
        null;
      
    end;
  
    for c in cuentas(ln_pais, ln_tdoc, lc_ndoc) loop
    
      begin
        select count(*)
          into ln_credvencido
          from fsh012 f
         where f.bcemp = 1
           and f.bcmda in (0, 101)
           and f.bcpap = 0
           and f.bccta = c.ctnro
           and (f.bcmod in
               (select s.modulo from fst111 s where s.dscod = 50) or
               f.bcmod = 117)
           and f.bcfech = ld_FchCorte
           and REGEXP_LIKE(f.bcrubr, '^14.5');
      exception
        when others then
          null;
      end;
    
      if ln_credvencido = 0 then
        lc_afectacion := lc_afectAux;
      
        if lc_afectacion in ('MEDIA BAJA', 'BAJA') and ln_ModEval = 13 then
        
          pq_cr_segmnxcomport.sp_ciiu_codigo(P_PAIS     => ln_pais,
                                             P_PETDOC   => ln_tdoc,
                                             P_PENDOC   => lc_ndoc,
                                             lc_codciiu => ln_codCIUU);
        
          begin
            select count(*)
              into ln_afectespecial
              from fst198 f
             where f.tp1cod = 1
               and f.tp1cod1 = 10823
               and f.tp1corr1 = 55
               and f.tp1corr2 = 5
               and f.tp1nro2 = ln_codCIUU
               and f.tp1desc = rpad(lc_afectacion, 30, ' ');
          exception
            when others then
              ln_afectespecial := 0;
          end;
        
          if ln_afectespecial = 0 then
            lc_afectacion := 'NINGUNA';
          end if;
        
        else
          if lc_afectacion in ('MEDIA BAJA', 'BAJA') and ln_ModEval = 14 then
            lc_afectacion := 'NINGUNA';
          end if;
        end if;
      
      else
        if ln_credvencido > 0 then
          lc_afectacion := 'NINGUNA';
          exit;
        end if;
      end if;
    
    end loop;
  
    if ln_paiscy > 0 and ln_credvencido = 0 then
    
      for c in cuentas(ln_paiscy, ln_tdoccy, lc_ndoccy) loop
      
        begin
          select count(*)
            into ln_credvencido
            from fsh012 f
           where f.bcemp = 1
             and f.bcmda in (0, 101)
             and f.bcpap = 0
             and f.bccta = c.ctnro
             and (f.bcmod in
                 (select s.modulo from fst111 s where s.dscod = 50) or
                 f.bcmod = 117)
             and f.bcfech = ld_FchCorte
             and REGEXP_LIKE(f.bcrubr, '^14.5');
        exception
          when others then
            null;
        end;
      
        if ln_credvencido = 0 then
          lc_afectacion := lc_afectAux;
        
          if lc_afectacion in ('MEDIA BAJA', 'BAJA') and ln_ModEval = 13 then
          
            pq_cr_segmnxcomport.sp_ciiu_codigo(P_PAIS     => ln_pais,
                                               P_PETDOC   => ln_tdoc,
                                               P_PENDOC   => lc_ndoc,
                                               lc_codciiu => ln_codCIUU);
          
            begin
              select count(*)
                into ln_afectespecial
                from fst198 f
               where f.tp1cod = 1
                 and f.tp1cod1 = 10823
                 and f.tp1corr1 = 55
                 and f.tp1corr2 = 5
                 and f.tp1nro2 = ln_codCIUU
                 and f.tp1desc = rpad(lc_afectacion, 30, ' ');
            exception
              when others then
                ln_afectespecial := 0;
            end;
          
            if ln_afectespecial = 0 then
              lc_afectacion := 'NINGUNA';
            end if;
          
          else
            if lc_afectacion in ('MEDIA BAJA', 'BAJA') and ln_ModEval = 14 then
              lc_afectacion := 'NINGUNA';
            end if;
          end if;
        
        else
          if ln_credvencido > 0 then
            lc_afectacion := 'NINGUNA';
            exit;
          end if;
        end if;
      end loop;
    end if;
    if ln_credvencido = 0 then
      lc_credvencido := 'N';
    else
      lc_credvencido := 'S';
    end if;
  
    begin
    
      PQ_CR_SEGMNXCOMPORT.sp_cr_InsertLogAQPB158(ln_inst    => ln_instancia,
                                                 ln_pais    => ln_pais,
                                                 ln_tdoc    => ln_tdoc,
                                                 lc_ndoc    => lc_ndoc,
                                                 ln_suc     => ln_sucursal,
                                                 lc_afec    => lc_afectacion,
                                                 ln_meval   => ln_ModEval,
                                                 ln_ciuu    => ln_codCIUU,
                                                 lc_cven    => lc_credvencido,
                                                 lc_usuario => lc_usuario);
    end;
  
  end sp_cr_iniciorp;
  ----------------------------------------------------
  procedure sp_cr_inicioCRU(ln_sucusu     in number,
                            ln_PAIS       in number,
                            ln_PETDOC     in number,
                            lc_PENDOC     in varchar2,
                            lc_usuario    in varchar2,
                            lc_afectacion out varchar2) is
  
    cursor creditos(ln_PAIS number, ln_PETDOC number, lc_PENDOC varchar2) is
      select *
        from fsd010 f
       where f.pgcod = 1
         and (f.aomod in (select s.modulo from fst111 s where s.dscod = 50) or
             f.aomod = 117)
         and f.aomda in (0, 101)
         and f.aopap = 0
         and f.aocta in (select r.ctnro
                           from fsr008 r
                          where r.pgcod = 1
                            and r.pepais = ln_PAIS
                            and r.petdoc = ln_PETDOC
                            and r.pendoc = rpad(lc_PENDOC, 12, ' ')
                            and r.cttfir = 'T')
         and f.aostat <> 99
       order by f.aofval;
  
    ld_FchCorte       date;
    lc_afectAux       varchar2(30);
    lc_SegmntoActual  number;
    ln_ModEval        number;
    ln_paiscy         number;
    ln_tdoccy         number;
    lc_ndoccy         varchar2(12);
    lc_credvencido    varchar2(5) := 'N';
    ln_codAfecAux     number;
    ln_credvencido    number;
    ln_afectespecial  number;
    ln_codCIUU        number;
    ln_codAfec        number := 99;
    ln_codAfecTit     number := 99;
    ln_codAfecAux1    NUMBER := 99;
    ln_codAfecCy      number := 99;
    ln_suctit         number;
    ln_vencidtit      number;
    ln_succny         number;
    ln_vencidcny      number;
    ln_sucursal       number;
    ln_TienCredVigTit number := 0;
    ln_TienCredVigCy  number := 0;
  
  begin
  
    begin
      select to_date(f.tp1nro1, 'DD/MM/YYYY')
        into ld_FchCorte
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 10823
         and f.tp1corr1 = 55
         and f.tp1corr2 = 4
         and f.tp1corr3 = 1;
    exception
      when others then
        null;
    end;
  
    begin
      update aqpb158 a
         set a.aqpb158est = 'I'
       where a.aqpb158pais = ln_PAIS
         and a.aqpb158tdoc = ln_PETDOC
         and a.aqpb158ndoc = lc_PENDOC;
    exception
      when others then
        null;
    end;
  
    if ld_FchCorte is null then
      ld_FchCorte := '30/11/2022';
    end if;
  
    begin
      --- Datos del Cnyuge
      select f.rppais, f.rptdoc, f.rpndoc
        into ln_paiscy, ln_tdoccy, lc_ndoccy
        from fsr002 f
       where f.pepais = ln_PAIS
         and f.petdoc = ln_PETDOC
         and f.pendoc = lc_PENDOC
         and f.rpccyg = 66;
    exception
      when no_data_found then
        begin
          select f.rppais, f.rptdoc, f.rpndoc
            into ln_paiscy, ln_tdoccy, lc_ndoccy
            from fsr002 f
           where f.rppais = ln_PAIS
             and f.rptdoc = ln_PETDOC
             and f.rpndoc = lc_PENDOC
             and f.rpccyg = 66;
        exception
          when others then
            null;
        end;
      when others then
        null;
      
    end;
  
    begin
    
      select count(*)
        into ln_TienCredVigTit
        from fsd010 f
       where f.pgcod = 1
         and (f.aomod in (select s.modulo from fst111 s where s.dscod = 50) or
             f.aomod = 117)
         and f.aomda in (0, 101)
         and f.aopap = 0
         and f.aocta in (select r.ctnro
                           from fsr008 r
                          where r.pgcod = 1
                            and r.pepais = ln_PAIS
                            and r.petdoc = ln_PETDOC
                            and r.pendoc = rpad(lc_PENDOC, 12, ' ')
                            and r.cttfir = 'T')
         and f.aostat <> 99;
    exception
      when others then
        ln_TienCredVigTit := 0;
      
    end;
  
    begin
      select count(*)
        into ln_TienCredVigCy
        from fsd010 f
       where f.pgcod = 1
         and (f.aomod in (select s.modulo from fst111 s where s.dscod = 50) or
             f.aomod = 117)
         and f.aomda in (0, 101)
         and f.aopap = 0
         and f.aocta in (select r.ctnro
                           from fsr008 r
                          where r.pgcod = 1
                            and r.pepais = ln_paiscy
                            and r.petdoc = ln_tdoccy
                            and r.pendoc = rpad(lc_ndoccy, 12, ' ')
                            and r.cttfir = 'T')
         and f.aostat <> 99;
    exception
      when others then
        ln_TienCredVigCy := 0;
      
    end;
  
    if ln_TienCredVigCy > 0 or ln_TienCredVigTit > 0 then
    
      for c in creditos(ln_PAIS, ln_PETDOC, lc_PENDOC) loop
      
        begin
          select trim(f.tp1desc), f.tp1nro3
            into lc_afectAux, ln_codAfecAux
            from fst198 f
           where f.tp1cod = 1
             and f.tp1cod1 = 10823
             and f.tp1corr1 = 55
             and f.tp1corr2 = 3
             and f.tp1nro1 = c.aosuc;
        exception
          when others then
            lc_afectAux := 'NINGUNA';
        end;
      
        pq_cr_segmnxcomport.sp_cr_segmentoactual(ln_PAIS,
                                                 ln_PETDOC,
                                                 lc_PENDOC,
                                                 lc_SegmntoActual);
      
        if lc_SegmntoActual = 1 then
          ln_ModEval := 13;
        else
          if lc_SegmntoActual = 2 then
            ln_ModEval := 14;
          end if;
        end if;
      
        begin
          select count(*)
            into ln_credvencido
            from fsh012 f
           where f.bcemp = c.pgcod
             and f.bcsuc = c.aosuc
             and f.bcmod = c.aomod
             and f.bcmda = c.aomda
             and f.bcpap = c.aopap
             and f.bccta = c.aocta
             and f.bcoper = c.aooper
             and f.bcsbop = c.aosbop
             and f.bctop = c.aotope
             and f.bcfech = ld_FchCorte
             and REGEXP_LIKE(f.bcrubr, '^14.5');
        exception
          when others then
            ln_credvencido := 0;
        end;
      
        if ln_credvencido = 0 then
          lc_afectacion := lc_afectAux;
        
          if lc_afectacion in ('MEDIA BAJA', 'BAJA') and ln_ModEval = 13 then
          
            pq_cr_segmnxcomport.sp_ciiu_codigo(P_PAIS     => ln_PAIS,
                                               P_PETDOC   => ln_PETDOC,
                                               P_PENDOC   => lc_PENDOC,
                                               lc_codciiu => ln_codCIUU);
          
            begin
              select count(*)
                into ln_afectespecial
                from fst198 f
               where f.tp1cod = 1
                 and f.tp1cod1 = 10823
                 and f.tp1corr1 = 55
                 and f.tp1corr2 = 5
                 and f.tp1nro2 = ln_codCIUU
                 and f.tp1desc = rpad(lc_afectacion, 30, ' ');
            exception
              when others then
                ln_afectespecial := 0;
            end;
          
            if ln_afectespecial = 0 then
              lc_afectacion := 'NINGUNA';
              ln_codAfecAux := 99;
            end if;
          
          else
            if lc_afectacion in ('MEDIA BAJA', 'BAJA') and ln_ModEval = 14 then
              lc_afectacion := 'NINGUNA';
            end if;
          
          end if;
        
        else
          if ln_credvencido > 0 then
            lc_afectacion := 'NINGUNA';
            ln_codAfecAux := 99;
            exit;
          end if;
        
        end if;
      
        ln_codAfecAux1 := ln_codAfecAux;
      
        if ln_codAfecTit > ln_codAfecAux1 then
          ln_codAfecTit := ln_codAfecAux1;
          ln_suctit     := c.aosuc;
          ln_vencidtit  := ln_credvencido;
        end if;
      
      end loop;
    
      if ln_paiscy > 0 then
      
        for c in creditos(ln_paiscy, ln_tdoccy, lc_ndoccy) loop
        
          begin
            select trim(f.tp1desc), f.tp1nro3
              into lc_afectAux, ln_codAfecAux
              from fst198 f
             where f.tp1cod = 1
               and f.tp1cod1 = 10823
               and f.tp1corr1 = 55
               and f.tp1corr2 = 3
               and f.tp1nro1 = c.aosuc;
          exception
            when others then
              lc_afectAux := 'NINGUNA';
          end;
        
          pq_cr_segmnxcomport.sp_cr_segmentoactual(ln_PAIS,
                                                   ln_PETDOC,
                                                   lc_PENDOC,
                                                   lc_SegmntoActual);
        
          if lc_SegmntoActual = 1 then
            ln_ModEval := 13;
          else
            if lc_SegmntoActual = 2 then
              ln_ModEval := 14;
            end if;
          end if;
        
          begin
            select count(*)
              into ln_credvencido
              from fsh012 f
             where f.bcemp = c.pgcod
               and f.bcsuc = c.aosuc
               and f.bcmod = c.aomod
               and f.bcmda = c.aomda
               and f.bcpap = c.aopap
               and f.bccta = c.aocta
               and f.bcoper = c.aooper
               and f.bcsbop = c.aosbop
               and f.bctop = c.aotope
               and f.bcfech = ld_FchCorte
               and REGEXP_LIKE(f.bcrubr, '^14.5');
          exception
            when others then
              ln_credvencido := 0;
          end;
        
          if ln_credvencido = 0 then
            lc_afectacion := lc_afectAux;
          
            if lc_afectacion in ('MEDIA BAJA', 'BAJA') and ln_ModEval = 13 then
            
              pq_cr_segmnxcomport.sp_ciiu_codigo(P_PAIS     => ln_PAIS,
                                                 P_PETDOC   => ln_PETDOC,
                                                 P_PENDOC   => lc_PENDOC,
                                                 lc_codciiu => ln_codCIUU);
            
              begin
                select count(*)
                  into ln_afectespecial
                  from fst198 f
                 where f.tp1cod = 1
                   and f.tp1cod1 = 10823
                   and f.tp1corr1 = 55
                   and f.tp1corr2 = 5
                   and f.tp1nro2 = ln_codCIUU
                   and f.tp1desc = rpad(lc_afectacion, 30, ' ');
              exception
                when others then
                  ln_afectespecial := 0;
              end;
            
              if ln_afectespecial = 0 then
                lc_afectacion := 'NINGUNA';
                ln_codAfecAux := 99;
              end if;
            
            else
              if lc_afectacion in ('MEDIA BAJA', 'BAJA') and
                 ln_ModEval = 14 then
                lc_afectacion := 'NINGUNA';
              end if;
            end if;
          
          else
            if ln_credvencido > 0 then
              lc_afectacion := 'NINGUNA';
              ln_codAfecAux := 99;
              exit;
            end if;
          
          end if;
        
          ln_codAfecAux1 := ln_codAfecAux;
        
          if ln_codAfecCy > ln_codAfecAux1 then
            ln_codAfecCy := ln_codAfecAux1;
            ln_succny    := c.aosuc;
            ln_vencidcny := ln_credvencido;
          end if;
        
        end loop;
      
      end if;
    
      if ln_codAfecTit <= ln_codAfecCy then
        ln_codAfec     := ln_codAfecTit;
        ln_sucursal    := ln_suctit;
        ln_credvencido := ln_vencidtit;
      else
        ln_codAfec     := ln_codAfecCy;
        ln_sucursal    := ln_succny;
        ln_credvencido := ln_vencidcny;
      end if;
    
      if ln_codAfec = 1 then
        lc_afectacion := 'ALTA';
      else
        if ln_codAfec = 2 then
          lc_afectacion := 'MEDIA ALTA';
        else
          if ln_codAfec = 3 then
            lc_afectacion := 'MEDIA BAJA';
          else
            if ln_codAfec = 4 then
              lc_afectacion := 'BAJA';
            else
              lc_afectacion := 'NINGUNA';
            end if;
          end if;
        end if;
      end if;
    
      if ln_credvencido = 0 then
        lc_credvencido := 'N';
      else
        lc_credvencido := 'S';
      end if;
    
    else
      if ln_TienCredVigTit = 0 and ln_TienCredVigCy = 0 then
      
        begin
          select trim(f.tp1desc), f.tp1nro3
            into lc_afectAux, ln_codAfecAux
            from fst198 f
           where f.tp1cod = 1
             and f.tp1cod1 = 10823
             and f.tp1corr1 = 55
             and f.tp1corr2 = 3
             and f.tp1nro1 = ln_sucusu;
        exception
          when others then
            lc_afectAux := 'NINGUNA';
        end;
      
        ln_sucursal   := ln_sucusu;
        lc_afectacion := lc_afectAux;
      
        pq_cr_segmnxcomport.sp_cr_segmentoactual(ln_PAIS,
                                                 ln_PETDOC,
                                                 lc_PENDOC,
                                                 lc_SegmntoActual);
      
        if lc_SegmntoActual = 1 then
          ln_ModEval := 13;
        else
          if lc_SegmntoActual = 2 then
            ln_ModEval := 14;
          end if;
        end if;
      
        --INC7250 MPOSTIGOC 17.07.2024
        if lc_afectacion in ('MEDIA BAJA', 'BAJA') and ln_ModEval = 13 then
        
          pq_cr_segmnxcomport.sp_ciiu_codigo(P_PAIS     => ln_PAIS,
                                             P_PETDOC   => ln_PETDOC,
                                             P_PENDOC   => lc_PENDOC,
                                             lc_codciiu => ln_codCIUU);
        
          begin
            select count(*)
              into ln_afectespecial
              from fst198 f
             where f.tp1cod = 1
               and f.tp1cod1 = 10823
               and f.tp1corr1 = 55
               and f.tp1corr2 = 5
               and f.tp1nro2 = ln_codCIUU
               and f.tp1desc = rpad(lc_afectacion, 30, ' ');
          exception
            when others then
              ln_afectespecial := 0;
          end;
        
          if ln_afectespecial = 0 then
            lc_afectacion := 'NINGUNA';
            ln_codAfecAux := 99;
          end if;
        
        else
          if lc_afectacion in ('MEDIA BAJA', 'BAJA') and ln_ModEval = 14 then
            lc_afectacion := 'NINGUNA';
          end if;
        
        end if;
      
      end if;
    end if;
  
    /*begin
    
      PQ_CR_SEGMNXCOMPORT.sp_cr_InsertLogAQPB158(ln_inst    => 0,
                                                 ln_pais    => ln_pais,
                                                 ln_tdoc    => ln_PETDOC,
                                                 lc_ndoc    => lc_PENDOC,
                                                 ln_suc     => ln_sucursal,
                                                 lc_afec    => lc_afectacion,
                                                 ln_meval   => ln_ModEval,
                                                 ln_ciuu    => ln_codCIUU,
                                                 lc_cven    => lc_credvencido,
                                                 lc_usuario => lc_usuario);
    end;*/
  
  end sp_cr_inicioCRU;
  ----------------------------------------------------
  procedure sp_ciiu_codigo(P_PAIS     in number,
                           P_PETDOC   in number,
                           P_PENDOC   in char,
                           lc_codciiu out number) is
    -- lc_codciiu NUMBER; --varchar2(4);
    lv_petipo varchar2(1);
  Begin
  
    lv_petipo := pq_client_ciiu.fn_petipo(P_PAIS, P_PETDOC, P_PENDOC);
  
    If lv_petipo = 'F' Then
      Begin
        Select c60.sngc60acte --
          Into lc_codciiu
          From sngc60 c60
         Where c60.sngc60pais = P_PAIS
           And c60.sngc60tdoc = P_PETDOC
           And c60.sngc60ndoc = P_PENDOC
           And c60.sngc60corr = 0;
      Exception
        when others then
          lc_codciiu := 0;
      End;
    End If;
  
    If lv_petipo = 'J' Then
      Begin
        Select e001.expnins --
          Into lc_codciiu
          From fse001 e001
         Where e001.d511pais = P_PAIS
           And e001.d511tdoc = P_PETDOC
           And e001.d511ndoc = P_PENDOC;
      Exception
        when others then
          lc_codciiu := 0;
      End;
    End If;
  
    /* begin
        select f.actcod2, f.actcod1
          into p_ciuu4, p_ciuu6
          from fst750 f
         where f.actcod1 = lc_codciiu;
      exception
        when others then
        
          --- 15.01.2021 jrodriguej
          begin
            if lc_codciiu <> 0 then
              p_ciuu4 := 0;
              p_ciuu6 := lc_codciiu;
            end if;
          
          exception
            when others then
              p_ciuu4 := 0;
              p_ciuu6 := 0;
            
          end;
          --- 15.01.2021 jrodriguej
        ---p_ciuu4 := 0;
        ---p_ciuu6 := 0;
      end;
    */
    --Return TRIM(TO_CHAR(lc_codciiu));
  
  end sp_ciiu_codigo;
  --------------------------------------------
  procedure sp_cr_segmentoactual(ln_pais          in number,
                                 ln_tdoc          in number,
                                 lc_nrodoc        in varchar2,
                                 lc_SegmntoActual out number) is
  begin
    if ln_tdoc <> 9 then
    
      begin
        select to_number(trim(b.segcod))
          into lc_SegmntoActual
          from sngc60 a, sngc07 b
         where a.sngc60pais = ln_pais
           and a.sngc60tdoc = ln_tdoc
           and a.sngc60ndoc = rpad(lc_nrodoc, 12, ' ')
           and a.sngc60ocup = b.sngc07cod;
      exception
        when too_many_rows then
          begin
            select to_number(trim(b.segcod))
              into lc_SegmntoActual
              from sngc60 a, sngc07 b
             where a.sngc60pais = ln_pais
               and a.sngc60tdoc = ln_tdoc
               and a.sngc60ndoc = rpad(lc_nrodoc, 12, ' ')
               and a.sngc60ocup = b.sngc07cod
               and a.sngc60corr =
                   (select min(a.sngc60corr)
                      from sngc60 a, sngc07 b
                     where a.sngc60pais = ln_pais
                       and a.sngc60tdoc = ln_tdoc
                       and a.sngc60ndoc = rpad(lc_nrodoc, 12, ' ')
                       and a.sngc60ocup = b.sngc07cod);
          end;
        when others then
          null;
        
      end;
    
    else
      if ln_tdoc = 9 then
        lc_SegmntoActual := 1;
      end if;
    end if;
  
  end sp_cr_segmentoactual;
  --------------------------------------------
  procedure sp_cr_InsertLogAQPB158(ln_inst    in number,
                                   ln_pais    in number,
                                   ln_tdoc    in number,
                                   lc_ndoc    in varchar2,
                                   ln_suc     in number,
                                   lc_afec    in varchar2,
                                   ln_meval   in number,
                                   ln_ciuu    in number,
                                   lc_cven    in varchar2,
                                   lc_usuario in varchar2) is
  
    ln_corr number;
    ld_fech date;
    lc_hora char(8);
    lc_est  varchar2(5) := 'H';
  
  begin
  
    begin
      select f.pgfape into ld_fech from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select count(*)
        into ln_corr
        from aqpb158 a
       where a.aqpb158inst = ln_inst
         and a.aqpb158fech = ld_fech;
    exception
      when others then
        ln_corr := 0;
    end;
  
    ln_corr := nvl(ln_corr, 0);
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    end;
  
    begin
    
      insert into aqpb158
        (aqpb158corr,
         aqpb158inst,
         aqpb158fech,
         aqpb158hora,
         aqpb158pais,
         aqpb158tdoc,
         aqpb158ndoc,
         aqpb158suc,
         aqpb158afec,
         aqpb158meval,
         aqpb158ciuu,
         aqpb158cven,
         aqpb158est,
         aqpb158usu)
      values
        (ln_corr + 1,
         ln_inst,
         ld_fech,
         lc_hora,
         ln_pais,
         ln_tdoc,
         lc_ndoc,
         ln_suc,
         lc_afec,
         ln_meval,
         ln_ciuu,
         lc_cven,
         lc_est,
         lc_usuario);
      commit;
    
    end;
  
  end sp_cr_InsertLogAQPB158;
  ------------------------------------------------------
  procedure sp_cr_iniciAfecFAETur(ln_instancia  in number,
                                  lc_usuario    in varchar2,
                                  lc_afectacion out varchar2) is
  
    /* cursor cuentas(ln_pais number, ln_tdoc number, lc_ndoc varchar2) is
    
    select f.ctnro
      from fsr008 f
     where f.pepais = ln_pais
       and f.petdoc = ln_tdoc
       and f.pendoc = rpad(lc_ndoc, 12, ' ')
       and f.cttfir = 'T';*/
  
    ln_pais     number;
    ln_tdoc     number;
    lc_ndoc     varchar2(12);
    ln_sucursal number;
    --ln_credvencido number;
    --ln_depto number;
    --lc_afectAux      varchar2(30);
    --ld_FchCorte      date;
    --ln_ModEval       number;
    --ln_codCIUU       number;
    --ln_afectespecial number;
    --ln_paiscy        number;
    --ln_tdoccy        number;
    --lc_ndoccy        varchar2(12);
    --lc_credvencido   varchar2(5);
    --lc_SegmntoActual number;
  
  begin
  
    lc_afectacion := 'NINGUNA';
  
    begin
      update aqpb158a a
         set a.aqpb158aest = 'I'
       where a.aqpb158ainst = ln_instancia;
    exception
      when others then
        null;
    end;
  
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_pais, ln_tdoc, lc_ndoc
        from sng001 s
       where s.sng001inst = ln_instancia;
    exception
      when others then
        null;
    end;
  
    begin
      select x.xwfsucursal
        into ln_sucursal
        from xwf700 x
       where x.xwfprcins = ln_instancia
         and x.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
    /*begin
        select to_date(f.tp1nro1, 'DD/MM/YYYY')
          into ld_FchCorte
          from fst198 f
         where f.tp1cod = 1
           and f.tp1cod1 = 10823
           and f.tp1corr1 = 55
           and f.tp1corr2 = 4
           and f.tp1corr3 = 1;
      exception
        when others then
          null;
      end;
    
      if ld_FchCorte is null then
        ld_FchCorte := '30/11/2022';
      end if;
    */
    begin
      select trim(f.tp1desc)
        into lc_afectacion
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 10823
         and f.tp1corr1 = 55
         and f.tp1corr2 = 6
         and f.tp1nro1 = ln_sucursal;
    exception
      when others then
        lc_afectacion := 'NINGUNA';
    end;
  
    /* begin
    begin
      select s.sng021tmod
        into ln_ModEval
        from sng021 s
       where s.sng021sol = ln_instancia;
    exception
      when others then
        null;
    end;*/
  
    /*  ln_ModEval := nvl(ln_ModEval, 0);
    
      if ln_ModEval = 0 then
        pq_cr_rte_verificasegmento.sp_cr_SegmntoActual(ln_Instancia,
                                                       lc_SegmntoActual);
      
        if lc_SegmntoActual = 1 then
          ln_ModEval := 13;
        else
          if lc_SegmntoActual = 2 then
            ln_ModEval := 14;
          end if;
        end if;
      end if;
    
    end;*/
  
    /*  begin
      --- Datos del Cnyuge
      select f.rppais, f.rptdoc, f.rpndoc
        into ln_paiscy, ln_tdoccy, lc_ndoccy
        from fsr002 f
       where f.pepais = ln_pais
         and f.petdoc = ln_tdoc
         and f.pendoc = lc_ndoc
         and f.rpccyg = 66;
    exception
      when no_data_found then
        begin
          select f.rppais, f.rptdoc, f.rpndoc
            into ln_paiscy, ln_tdoccy, lc_ndoccy
            from fsr002 f
           where f.rppais = ln_pais
             and f.rptdoc = ln_tdoc
             and f.rpndoc = lc_ndoc
             and f.rpccyg = 66;
        exception
          when others then
            null;
        end;
      when others then
        null;
      
    end;*/
    /*
    for c in cuentas(ln_pais, ln_tdoc, lc_ndoc) loop
    
      begin
        select count(*)
          into ln_credvencido
          from fsh012 f
         where f.bcemp = 1
           and f.bcmda in (0, 101)
           and f.bcpap = 0
           and f.bccta = c.ctnro
           and (f.bcmod in
               (select s.modulo from fst111 s where s.dscod = 50) or
               f.bcmod = 117)
           and f.bcfech = ld_FchCorte
           and REGEXP_LIKE(f.bcrubr, '^14.5');
      end;
    
      if ln_credvencido = 0 then
        lc_afectacion := lc_afectAux;
      
        if lc_afectacion in ('MEDIA BAJA', 'BAJA') and ln_ModEval = 13 then
        
          pq_cr_segmnxcomport.sp_ciiu_codigo(P_PAIS     => ln_pais,
                                             P_PETDOC   => ln_tdoc,
                                             P_PENDOC   => lc_ndoc,
                                             lc_codciiu => ln_codCIUU);
        
          begin
            select count(*)
              into ln_afectespecial
              from fst198 f
             where f.tp1cod = 1
               and f.tp1cod1 = 10823
               and f.tp1corr1 = 55
               and f.tp1corr2 = 5
               and f.tp1nro2 = ln_codCIUU
               and f.tp1desc = rpad(lc_afectacion, 30, ' ');
          exception
            when others then
              ln_afectespecial := 0;
          end;
        
          if ln_afectespecial = 0 then
            lc_afectacion := 'NINGUNA';
          end if;
        
        else
          if lc_afectacion in ('MEDIA BAJA', 'BAJA') and ln_ModEval = 14 then
            lc_afectacion := 'NINGUNA';
          end if;
        end if;
      
      else
        if ln_credvencido > 0 then
          lc_afectacion := 'NINGUNA';
          exit;
        end if;
      end if;
    
    end loop;
    
    if ln_paiscy > 0 and ln_credvencido = 0 then
    
      for c in cuentas(ln_paiscy, ln_tdoccy, lc_ndoccy) loop
      
        begin
          select count(*)
            into ln_credvencido
            from fsh012 f
           where f.bcemp = 1
             and f.bcmda in (0, 101)
             and f.bcpap = 0
             and f.bccta = c.ctnro
             and (f.bcmod in
                 (select s.modulo from fst111 s where s.dscod = 50) or
                 f.bcmod = 117)
             and f.bcfech = ld_FchCorte
             and REGEXP_LIKE(f.bcrubr, '^14.5');
        end;
      
        if ln_credvencido = 0 then
          lc_afectacion := lc_afectAux;
        
          if lc_afectacion in ('MEDIA BAJA', 'BAJA') and ln_ModEval = 13 then
          
            pq_cr_segmnxcomport.sp_ciiu_codigo(P_PAIS     => ln_pais,
                                               P_PETDOC   => ln_tdoc,
                                               P_PENDOC   => lc_ndoc,
                                               lc_codciiu => ln_codCIUU);
          
            begin
              select count(*)
                into ln_afectespecial
                from fst198 f
               where f.tp1cod = 1
                 and f.tp1cod1 = 10823
                 and f.tp1corr1 = 55
                 and f.tp1corr2 = 5
                 and f.tp1nro2 = ln_codCIUU
                 and f.tp1desc = rpad(lc_afectacion, 30, ' ');
            exception
              when others then
                ln_afectespecial := 0;
            end;
          
            if ln_afectespecial = 0 then
              lc_afectacion := 'NINGUNA';
            end if;
          
          else
            if lc_afectacion in ('MEDIA BAJA', 'BAJA') and ln_ModEval = 14 then
              lc_afectacion := 'NINGUNA';
            end if;
          end if;
        
        else
          if ln_credvencido > 0 then
            lc_afectacion := 'NINGUNA';
            exit;
          end if;
        end if;
      end loop;
    end if;
    if ln_credvencido = 0 then
      lc_credvencido := 'N';
    else
      lc_credvencido := 'S';
    end if;*/
  
    begin
    
      PQ_CR_SEGMNXCOMPORT.sp_cr_InsertLogAQPB158A(ln_inst => ln_instancia,
                                                  ln_pais => ln_pais,
                                                  ln_tdoc => ln_tdoc,
                                                  lc_ndoc => lc_ndoc,
                                                  ln_suc  => ln_sucursal,
                                                  lc_afec => lc_afectacion,
                                                  -- ln_meval   => ln_ModEval,
                                                  -- ln_ciuu    => ln_codCIUU,
                                                  -- lc_cven    => lc_credvencido,
                                                  lc_usuario => lc_usuario);
    end;
  
  end sp_cr_iniciAfecFAETur;
  --------------------------------------------
  procedure sp_cr_InsertLogAQPB158A(ln_inst in number,
                                    ln_pais in number,
                                    ln_tdoc in number,
                                    lc_ndoc in varchar2,
                                    ln_suc  in number,
                                    lc_afec in varchar2,
                                    -- ln_meval   in number,
                                    -- ln_ciuu    in number,
                                    -- lc_cven    in varchar2,
                                    lc_usuario in varchar2) is
  
    ln_corr number;
    ld_fech date;
    lc_hora char(8);
    lc_est  varchar2(5) := 'H';
  
  begin
  
    begin
      select f.pgfape into ld_fech from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select count(*)
        into ln_corr
        from aqpb158a a
       where a.aqpb158ainst = ln_inst
         and a.aqpb158afech = ld_fech;
    exception
      when others then
        ln_corr := 0;
    end;
  
    ln_corr := nvl(ln_corr, 0);
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    end;
  
    begin
    
      insert into aqpb158a
        (aqpb158acorr,
         aqpb158ainst,
         aqpb158afech,
         aqpb158ahora,
         aqpb158apais,
         aqpb158atdoc,
         aqpb158andoc,
         aqpb158asuc,
         aqpb158aafec,
         aqpb158aest,
         aqpb158ausu)
      values
        (ln_corr + 1,
         ln_inst,
         ld_fech,
         lc_hora,
         ln_pais,
         ln_tdoc,
         lc_ndoc,
         ln_suc,
         lc_afec,
         lc_est,
         lc_usuario);
      commit;
    
    end;
  
  end sp_cr_InsertLogAQPB158A;

---------------------------------------------------------------------------------

end PQ_CR_SEGMNXCOMPORT;
/

