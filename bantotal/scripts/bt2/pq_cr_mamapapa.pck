create or replace package PQ_CR_MAMAPAPA is
  -- *****************************************************************
  -- Nombre                     : PQ_CR_TIPOPAGO
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          :
  -- Autor de Creación          : EFUENTES
  -- Uso                        : Campaña Mamá y Papá 2022
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  --
  -- *****************************************************************
  Procedure SP_CR_REPROGRAMADO_EXT(pn_pais in number,
                                   pn_tdoc in number,
                                   pn_ndoc in varchar2,
                                   pc_flag out varchar2);
  ---------------------------------------------------------
  procedure sp_cr_verfpagoprinc(ln_instancia in number,
                                lc_verfpago  out varchar2);

end PQ_CR_MAMAPAPA;
/

create or replace package body PQ_CR_MAMAPAPA is
  -- *****************************************************************
  Procedure SP_CR_REPROGRAMADO_EXT(pn_pais in number,
                                   pn_tdoc in number,
                                   pn_ndoc in varchar2,
                                   pc_flag out varchar2) is
    lc_coderr varchar2(400);
    ld_fecrcc date;
    ln_cont   number := 0;
    lv_tdoc   varchar2(5);
    lv_codsbs varchar2(20);
  BEGIN
    begin
      select to_date(tpnro, 'ddmmrrrr')
        into ld_fecrcc
        from FST098
       Where Pgcod = 1
         and Tpcod = 7647
         and Tpcorr = 12;
    exception
      when others then
        lc_coderr := sqlerrm;
    end;
  
    lv_tdoc := PQ_CR_CTR_FAE_REACTIVA.FN_EQUIVALENCIADOC(pn_tdoc);
    begin
      select c_codsbs
        into lv_codsbs
        from cldrcci
       where d_fecpre = ld_fecrcc
         and c_tdocid = lv_tdoc
         and c_docide = trim(pn_ndoc) offset 0 rows fetch next 1 rows only;
    exception
      when others then
        lc_coderr := sqlerrm;
    end;
  
    BEGIN
      select count(distinct c.c_codemp)
        INTO ln_cont
        from cldrccs c
       where c.d_fecpre = ld_fecrcc
         and c.c_codsbs = lv_codsbs
         and c.c_cuenta like '81_937%'
         and c.c_codemp <> '00104';
    EXCEPTION
      when others then
        lc_coderr := sqlerrm;
        ln_cont   := 0;
        null;
    END;
    if ln_cont > 0 then
      pc_flag := 'S'; --si tiene reprogramado
    else
      pc_flag := 'N'; --no tiene reprogramado
    end if;
  end SP_CR_REPROGRAMADO_EXT;

  -- *****************************************************************
  -- mpostigoc
  -- valida si se pagaron min 3 cuotas (en guia de proceso) del ultimo credito consumo desembolsado.

  procedure sp_cr_verfpagoprinc(ln_instancia in number,
                                lc_verfpago  out varchar2) is
  
    cursor lista_CredCnsmPrinc(ld_FchMaxDesmb date) is
      select f.pgcod,
             f.aomod,
             f.aosuc,
             f.aomda,
             f.aopap,
             f.aocta,
             f.aooper,
             f.aosbop,
             f.aotope
        from fsd010 f
       where f.pgcod = 1
         and f.aomod in (select t.modulo from fst111 t where t.dscod = 50)
         and f.aocta = (select s.sng001cta
                          from sng001 s
                         where s.sng001inst = ln_instancia)
         and f.aopap = 0
         and f.aofval = ld_FchMaxDesmb
         and f.aostat <> 99;
  
    -- ln_TieneCredPrinc number;
    ln_NroCuotPagadas number;
    ln_CuotPagPrinc   number;
    ln_modulo         number;
    ln_tipooper       number;
    lc_EsCamp         number;
    ln_TieneDesemb    number;
    ld_FchMaxDesmb    date;
    ln_ModEval        number;
    ln_InstAux        number;
  
  begin
    lc_verfpago := 'S';
  
    begin
      select x.xwfmodulo, x.xwftipope
        into ln_modulo, ln_tipooper
        from xwf700 x
       where x.xwfprcins = ln_instancia
         and x.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
    begin
      select count(*)
        into lc_EsCamp
        from fst198 h
       where h.tp1cod = 1
         and h.tp1cod1 = 10899
         and h.tp1corr1 = 751
         and h.tp1corr2 = 4
         and h.tp1corr3 > 0
         and h.tp1nro2 = ln_modulo
         and h.tp1nro3 = ln_tipooper;
    exception
      when others then
        lc_EsCamp := 0;
    end;
  
    begin
      select f.tp1nro3
        into ln_NroCuotPagadas
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 10899
         and f.tp1corr1 = 751
         and f.tp1corr2 = 5;
    exception
      when others then
        ln_NroCuotPagadas := 3;
    end;
  
    if lc_EsCamp > 0 then
    
      begin
        select count(*)
          into ln_TieneDesemb
          from fsd010 f
         where f.pgcod = 1
           and f.aostat = 0
           and f.aomod in
               (select t.modulo from fst111 t where t.dscod = 50)
           and f.aocta = (select s.sng001cta
                            from sng001 s
                           where s.sng001inst = ln_instancia)
           and f.aopap = 0
           and f.aostat <> 99;
      exception
        when others then
          ln_TieneDesemb := 0;
      end;
    
      if ln_TieneDesemb > 0 then
      
        begin
          select max(f.aofval)
            into ld_FchMaxDesmb
            from fsd010 f
           where f.pgcod = 1
             and f.aostat = 0
             and f.aomod in
                 (select t.modulo from fst111 t where t.dscod = 50)
             and f.aocta = (select s.sng001cta
                              from sng001 s
                             where s.sng001inst = ln_instancia)
             and f.aopap = 0
             and f.aostat <> 99;
        exception
          when others then
            null;
        end;
        for l in lista_CredCnsmPrinc(ld_FchMaxDesmb) loop
        
          ln_InstAux := fn_instancia_credito(v_Scmod  => l.aomod,
                                             v_Scsuc  => l.aosuc,
                                             v_Scmda  => l.aomda,
                                             v_Scpap  => l.aopap,
                                             v_Sccta  => l.aocta,
                                             v_Scoper => l.aooper,
                                             v_Scsbop => l.aosbop,
                                             v_Sctope => l.aotope);
        
          begin
            select s.sng021tmod
              into ln_ModEval
              from sng021 s
             where s.sng021sol = ln_InstAux;
          exception
            when others then
              ln_ModEval := 99;
          end;
        
          if ln_ModEval = 14 then
          
            begin
              select count(*)
                into ln_CuotPagPrinc
                from fsd602 f
               where f.pgcod = l.pgcod
                 and f.ppmod = l.aomod
                 and f.ppsuc = l.aosuc
                 and f.ppmda = l.aomda
                 and f.pppap = l.aopap
                 and f.ppcta = l.aocta
                 and f.ppoper = l.aooper
                 and f.ppsbop = l.aosbop
                 and f.pptope = l.aotope
                 and f.pp1stat = 'T'
                 and f.d602co = 'S';
            exception
              when others then
                ln_CuotPagPrinc := 0;
            end;
          
            if ln_CuotPagPrinc >= ln_NroCuotPagadas then
              lc_verfpago := 'S';
            else
              lc_verfpago := 'N';
            end if;
          end if;
        end loop;
      end if;
    end if;
  end sp_cr_verfpagoprinc;

end PQ_CR_MAMAPAPA;
/

