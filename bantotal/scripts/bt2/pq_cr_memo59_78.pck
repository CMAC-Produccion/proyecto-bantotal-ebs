create or replace package PQ_CR_MEMO59_78 is
  -- *****************************************************************
  -- Nombre                     : PAQUETES PARA OBTENER INFORMACION DE LOS PRENDARIOS
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 19/02/2024 11:39:07
  -- Autor de Creación          : MPOSTIGOC MARIA POSTIGO
  -- Uso                        : Controles para los Memos 59-78 2024
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :
  -- Fecha de Modificación      : 04/07/2024
  -- Autor de la Modificación   : MPOSTIGOC 
  -- Descripción de Modificación: Se modifico el procedimiento sp_cr_Amortizcn_MEMO78 para devolver el periodo del credito
  -- Fecha de Modificación      : 31/07/2024
  -- Autor de la Modificación   : MPOSTIGOC 
  -- Descripción de Modificación: Se agrego excepciones
  -- Fecha de Modificación      : 16/09/2024
  -- Autor de la Modificación   : MPOSTIGOC 
  -- Descripción de Modificación: Se agrego el procedimiento sp_cr_NroCuoPagUDV, el rpocedimiento devuelve las cuotas pagadas del ultimo
  --                              credito desembolsado.
  -- *****************************************************************
  -----------------------------------------------------------------------

  -- Public type declarations
  procedure sp_cr_MesesUDV_MEMO059(ln_instancia in number,
                                   ln_MesesUDV  out number);
  ---------------------------------------------------------------------------
  procedure sp_cr_NroCuoPagUDV_MEMO059(ln_instancia in number,
                                       ln_CuoPagUDV out number);
  ------------------------------------------------------------------------
  procedure sp_cr_Amortizcn_MEMO78(ln_instancia  in number,
                                   ln_porcamortz out number,
                                   ln_Periodo    out number);
  ---------------------------------------------------------------------
  procedure sp_cr_NroCuoPagUDV(ln_instancia in number,
                               ln_CuoPagUDV out number);

end PQ_CR_MEMO59_78;
/

create or replace package body PQ_CR_MEMO59_78 is

  --MEMO059
  procedure sp_cr_MesesUDV_MEMO059(ln_instancia in number,
                                   ln_MesesUDV  out number) is
    --Aplica luego de 6 meses de otorgado el ultimo crédito vigente 
  
    ln_pais         number;
    ln_tdoc         number;
    lc_ndoc         varchar2(12);
    ln_TipSol       number;
    ln_CredVig      number := 0;
    ld_FchMaxDesVig date;
    ld_FchAux       date;
    ld_FchSist      date;
  
  begin
  
    ln_MesesUDV := 0;
  
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc, s.sng001ori
        into ln_pais, ln_tdoc, lc_ndoc, ln_TipSol
        from sng001 s
       where s.sng001inst = ln_instancia;
    exception
      when others then
        null;
    end;
  
    begin
      select f.pgfape into ld_FchSist from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select count(*)
        into ln_CredVig
        from fsd010 f
       where f.pgcod = 1
         and f.aomod in
             (select s.modulo
                from fst111 s
               where s.dscod = 50
                 and s.modulo not in (29, 33, 108, 116, 120, 142, 144, 200))
         and f.aomda in (0, 101)
         and f.aocta in (select r.ctnro
                           from fsr008 r
                          where r.pepais = ln_pais
                            and r.petdoc = ln_tdoc
                            and r.pendoc = rpad(lc_ndoc, 12, ' ')
                            and r.cttfir = 'T')
         and f.aostat <> 99;
    exception
      when others then
        ln_CredVig := 0;
    end;
  
    if ln_TipSol = 0 and ln_CredVig = 0 then
      -- Nuevo
      ln_MesesUDV := 999;
    
    else
      if ln_CredVig > 0 then
        -- Adicional y Ampliacion
        begin
          select max(f.aofval)
            into ld_FchMaxDesVig
            from fsd010 f
           where f.pgcod = 1
             and f.aomod in
                 (select s.modulo
                    from fst111 s
                   where s.dscod = 50
                     and s.modulo not in
                         (29, 33, 108, 116, 120, 142, 144, 200))
             and f.aomda in (0, 101)
             and f.aocta in (select r.ctnro
                               from fsr008 r
                              where r.pepais = ln_pais
                                and r.petdoc = ln_tdoc
                                and r.pendoc = rpad(lc_ndoc, 12, ' ')
                                and r.cttfir = 'T')
             and f.aostat <> 99;
        exception
          when others then
            null;
        end;
      
        ld_FchAux := TO_DATE('01/07/2013', 'DD/MM/YYYY');
      
        if ld_FchMaxDesVig is not null and ld_FchMaxDesVig > ld_FchAux then
          ln_MesesUDV := MONTHS_BETWEEN(ld_FchSist, ld_FchMaxDesVig);
        end if;
      
      end if;
    end if;
  end;
  ---------------------------------------------------------------
  -- Nro de Cuotas del ultimo credito pagado para:
  --Deberá cumplir con Avance de pagos:  6 cuotas (cliente recurrente)o 8 cuotas (cliente nuevo)

  procedure sp_cr_NroCuoPagUDV_MEMO059(ln_instancia in number,
                                       ln_CuoPagUDV out number) is
  
    cursor creditos(ld_FchMaxDesVig date) is
    -- Adicional
      select *
        from fsd010 f
       where f.pgcod = 1
         and f.aomod in
             (select s.modulo
                from fst111 s
               where s.dscod = 50
                 and s.modulo not in (29, 33, 108, 116, 120, 142, 144, 200))
         and f.aomda in (0, 101)
         and f.aocta in (select r.ctnro
                           from fsr008 r, sng001 n
                          where r.pepais = n.sng001pais
                            and r.petdoc = n.sng001tdoc
                            and r.pendoc = n.sng001ndoc
                            and r.cttfir = 'T'
                            and n.sng001inst = ln_instancia)
         and f.aostat <> 99
         and f.aofval = ld_FchMaxDesVig;
  
    cursor CredCancelados(ld_FIni date, ld_FFin date) is
    -- Adicional
      select *
        from fsd010 f
       where f.pgcod = 1
         and f.aomod in
             (select s.modulo
                from fst111 s
               where s.dscod = 50
                 and s.modulo not in (29, 33, 108, 116, 120, 142, 144, 200))
         and f.aomda in (0, 101)
         and f.aocta in (select r.ctnro
                           from fsr008 r, sng001 n
                          where r.pepais = n.sng001pais
                            and r.petdoc = n.sng001tdoc
                            and r.pendoc = n.sng001ndoc
                            and r.cttfir = 'T'
                            and n.sng001inst = ln_instancia)
         and f.aostat = 99
         and f.aofe99 between ld_FIni and ld_FFin
       order by f.aofe99 desc;
  
    ln_pais         number;
    ln_tdoc         number;
    lc_ndoc         varchar2(12);
    ln_TipSol       number;
    ln_CredVig      number := 0;
    ln_pgcod        number;
    ln_suc          number;
    ln_mod          number;
    ln_mda          number;
    ln_pap          number;
    ln_cta          number;
    ln_ope          number;
    ln_sbop         number;
    ln_tope         number;
    ld_FchMinDesVig date;
    ln_CuoPagUDVAux number := 0;
    ld_FchSist      date;
    ld_FIni         date;
    ln_CuoPagCCAux  number;
  
  begin
  
    ln_CuoPagUDV := 0;
  
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc, s.sng001ori
        into ln_pais, ln_tdoc, lc_ndoc, ln_TipSol
        from sng001 s
       where s.sng001inst = ln_instancia;
    exception
      when others then
        null;
    end;
  
    begin
      select f.pgfape into ld_FchSist from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select count(*)
        into ln_CredVig
        from fsd010 f
       where f.pgcod = 1
         and f.aomod in
             (select s.modulo
                from fst111 s
               where s.dscod = 50
                 and s.modulo not in (29, 33, 108, 116, 120, 142, 144, 200))
         and f.aomda in (0, 101)
         and f.aocta in (select r.ctnro
                           from fsr008 r
                          where r.pepais = ln_pais
                            and r.petdoc = ln_tdoc
                            and r.pendoc = rpad(lc_ndoc, 12, ' ')
                            and r.cttfir = 'T')
         and f.aostat <> 99;
    exception
      when others then
        ln_CredVig := 0;
    end;
  
    if ln_TipSol = 0 and ln_CredVig = 0 then
      -- Nuevo
      ln_CuoPagUDV := 999;
    
    else
      if ln_TipSol = 4 and ln_CredVig > 0 then
        -- Ampliacion
        begin
          select x.xwfempresa,
                 x.xwfsucursal,
                 x.xwfmodulo,
                 x.xwfmoneda,
                 x.xwfpapel,
                 x.xwfcuenta,
                 x.xwfoperacion,
                 x.xwfsubope,
                 x.xwftipope
            into ln_pgcod,
                 ln_suc,
                 ln_mod,
                 ln_mda,
                 ln_pap,
                 ln_cta,
                 ln_ope,
                 ln_sbop,
                 ln_tope
            from xwf700 x
           where x.xwfprcins = ln_instancia
             and x.xwfcar3 <> '1';
        exception
          when others then
            null;
        end;
      
        begin
          select count(*)
            into ln_CuoPagUDV
            from fsd602 f
           where f.pgcod = ln_pgcod
             and f.ppmod = ln_mod
             and f.ppsuc = ln_suc
             and f.ppmda = ln_mda
             and f.pppap = ln_pap
             and f.ppcta = ln_cta
             and f.ppoper = ln_ope
             and f.ppsbop = ln_sbop
             and f.pptope = ln_tope
             and f.pp1stat = 'T'
             and f.d602co = 'S';
        exception
          when others then
            ln_CuoPagUDV := 0;
        end;
      else
        if ln_TipSol <> 4 and ln_CredVig > 0 then
          -- Adicional
          begin
            select min(f.aofval)
              into ld_FchMinDesVig
              from fsd010 f
             where f.pgcod = 1
               and f.aomod in
                   (select s.modulo
                      from fst111 s
                     where s.dscod = 50
                       and s.modulo not in
                           (29, 33, 108, 116, 120, 142, 144, 200)) ----9
               and f.aomda in (0, 101)
               and f.aocta in (select r.ctnro
                                 from fsr008 r
                                where r.pepais = ln_pais
                                  and r.petdoc = ln_tdoc
                                  and r.pendoc = rpad(lc_ndoc, 12, ' ')
                                  and r.cttfir = 'T')
               and f.aostat <> 99;
          exception
            when others then
              null;
          end;
        
          for c in creditos(ld_FchMinDesVig) loop
          
            begin
              select count(*)
                into ln_CuoPagUDVAux
                from fsd602 f
               where f.pgcod = c.pgcod
                 and f.ppmod = c.aomod
                 and f.ppsuc = c.aosuc
                 and f.ppmda = c.aomda
                 and f.pppap = c.aopap
                 and f.ppcta = c.aocta
                 and f.ppoper = c.aooper
                 and f.ppsbop = c.aosbop
                 and f.pptope = c.aotope
                 and f.pp1stat = 'T'
                 and f.d602co = 'S';
            exception
              when others then
                ln_CuoPagUDVAux := 0;
            end;
          
            if ln_CuoPagUDVAux > ln_CuoPagUDV then
              ln_CuoPagUDV := ln_CuoPagUDVAux;
            end if;
          
          end loop;
        
          if ln_CuoPagUDV <= 6 then
            --  Identificamos los créditos cancelados considerando el rango de fecha: Fecha del sistema y 60 días hacia atrás.
            ld_FIni := ld_FchSist - 60;
            --  Consideramos desde el último crédito cancelado hacia atrás, por cada crédito se considera el nro. de cuotas canceladas.
            for cc in CredCancelados(ld_FIni, ld_FchSist) loop
            
              begin
                select count(*)
                  into ln_CuoPagCCAux
                  from fsd602 f
                 where f.pgcod = cc.pgcod
                   and f.ppmod = cc.aomod
                   and f.ppsuc = cc.aosuc
                   and f.ppmda = cc.aomda
                   and f.pppap = cc.aopap
                   and f.ppcta = cc.aocta
                   and f.ppoper = cc.aooper
                   and f.ppsbop = cc.aosbop
                   and f.pptope = cc.aotope
                   and f.pp1stat = 'T'
                   and f.d602co = 'S';
              exception
                when others then
                  ln_CuoPagCCAux := 0;
              end;
            
              ln_CuoPagUDV := nvl(ln_CuoPagUDV, 0) + nvl(ln_CuoPagCCAux, 0);
            
              if ln_CuoPagUDV > 6 then
                return;
              end if;
            end loop;
          
            --  Se considera los créditos hasta obtener mínimo 6 cuotas entre las cuotas avanzadas y las cuotas canceladas.
          
          end if;
        end if;
      
      end if;
    end if;
  end sp_cr_NroCuoPagUDV_MEMO059;
  ------------------------------------------
  procedure sp_cr_Amortizcn_MEMO78(ln_instancia  in number,
                                   ln_porcamortz out number,
                                   ln_Periodo    out number) is
  
    cursor creditos(ld_FchMaxDesVig date) is
    -- Adicional
      select *
        from fsd010 f
       where f.pgcod = 1
         and f.aomod in
             (select s.modulo
                from fst111 s
               where s.dscod = 50
                 and s.modulo not in (29, 33, 108, 116, 120, 142, 144, 200))
         and f.aomda in (0, 101)
         and f.aocta in (select r.ctnro
                           from fsr008 r, sng001 n
                          where r.pepais = n.sng001pais
                            and r.petdoc = n.sng001tdoc
                            and r.pendoc = n.sng001ndoc
                            and r.cttfir = 'T'
                            and n.sng001inst = ln_instancia)
         and f.aostat <> 99
         and f.aofval = ld_FchMaxDesVig;
  
    ln_pais          number;
    ln_tdoc          number;
    lc_ndoc          varchar2(12);
    ln_TipSol        number;
    ln_CredVig       number := 0;
    ln_CapDesmbls    number(17, 2) := 0.00;
    ln_CapPagad      number(17, 2) := 0.00;
    ld_FchSist       date;
    ld_FchMaxDesVig  date;
    ln_CuoPagUDVAux  number := 0;
    ln_porcamortzAux number := 0;
    -- ln_Periodo       number := 0;
  
  begin
  
    ln_porcamortz := 0;
  
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc, s.sng001ori
        into ln_pais, ln_tdoc, lc_ndoc, ln_TipSol
        from sng001 s
       where s.sng001inst = ln_instancia;
    exception
      when others then
        null;
    end;
  
    begin
      select f.pgfape into ld_FchSist from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select count(*)
        into ln_CredVig
        from fsd010 f
       where f.pgcod = 1
         and f.aomod in
             (select s.modulo
                from fst111 s
               where s.dscod = 50
                 and s.modulo not in (29, 33, 108, 116, 120, 142, 144, 200)) -----9
         and f.aomda in (0, 101)
         and f.aocta in (select r.ctnro
                           from fsr008 r
                          where r.pepais = ln_pais
                            and r.petdoc = ln_tdoc
                            and r.pendoc = rpad(lc_ndoc, 12, ' ')
                            and r.cttfir = 'T')
         and f.aostat <> 99;
    exception
      when others then
        ln_CredVig := 0;
    end;
  
    if ln_TipSol = 0 and ln_CredVig = 0 then
      -- Nuevo
      ln_porcamortz := 999;
    
    else
      if ln_TipSol = 4 then
      
        begin
          select sum(f.pp1cap)
            into ln_CapPagad
            from xwf700 x, fsd602 f
           where x.xwfempresa = f.pgcod
             and x.xwfsucursal = f.ppsuc
             and x.xwfmodulo = f.ppmod
             and x.xwfmoneda = f.ppmda
             and x.xwfpapel = f.pppap
             and x.xwfcuenta = f.ppcta
             and x.xwfoperacion = f.ppoper
             and x.xwfsubope = f.ppsbop
             and x.xwftipope = f.pptope
             and x.xwfprcins = ln_instancia
             and x.xwfcar3 <> '1'
             and f.d602co = 'S';
        exception
          when others then
            null;
        end;
      
        begin
          select f.aoimp
            into ln_CapDesmbls
            from xwf700 x, fsd010 f
           where x.xwfempresa = f.pgcod
             and x.xwfsucursal = f.aosuc
             and x.xwfmodulo = f.aomod
             and x.xwfmoneda = f.aomda
             and x.xwfpapel = f.aopap
             and x.xwfcuenta = f.aocta
             and x.xwfoperacion = f.aooper
             and x.xwfsubope = f.aosbop
             and x.xwftipope = f.aotope
             and x.xwfprcins = ln_instancia
             and x.xwfcar3 <> '1';
        exception
          when others then
            null;
        end;
      
        if ln_CapDesmbls > 0 and ln_CapPagad > 0 then
          begin
            select (ln_CapPagad * 100) / ln_CapDesmbls
              into ln_porcamortz
              from dual;
          exception
            when others then
              ln_porcamortz := 0;
          end;
        else
          ln_porcamortz := 0;
        end if;
      
        begin
          select f.xllperiodo
            into ln_Periodo
            from xwf700 x, x054023 f
           where x.xwfempresa = f.xllpgcod
             and x.xwfsucursal = f.xllaosuc
             and x.xwfmodulo = f.xllaomod
             and x.xwfmoneda = f.xllaomda
             and x.xwfpapel = f.xllaopap
             and x.xwfcuenta = f.xllaocta
             and x.xwfoperacion = f.xllaooper
             and x.xwfsubope = f.xllaosbop
             and x.xwftipope = f.xllaotop
             and x.xwfprcins = ln_instancia
             and x.xwfcar3 <> '1';
        exception
          when others then
            null;
        end;
      
      else
        if ln_TipSol <> 4 then
          -- Adicional
          begin
            select max(f.aofval)
              into ld_FchMaxDesVig
              from fsd010 f
             where f.pgcod = 1
               and f.aomod in
                   (select s.modulo
                      from fst111 s
                     where s.dscod = 50
                       and s.modulo not in
                           (29, 33, 108, 116, 120, 142, 144, 200)) ----
               and f.aomda in (0, 101)
               and f.aocta in (select r.ctnro
                                 from fsr008 r
                                where r.pepais = ln_pais
                                  and r.petdoc = ln_tdoc
                                  and r.pendoc = rpad(lc_ndoc, 12, ' ')
                                  and r.cttfir = 'T')
               and f.aostat <> 99;
          exception
            when others then
              null;
          end;
        
          for c in creditos(ld_FchMaxDesVig) loop
            --mpostigoc 31.07.2024 se agrego excepcion
            begin
              select x.xllperiodo
                into ln_Periodo
                from x054023 x
               where x.xllpgcod = c.pgcod
                 and x.xllaomod = c.aomod
                 and x.xllaosuc = c.aosuc
                 and x.xllaomda = c.aomda
                 and x.xllaopap = c.aopap
                 and x.xllaocta = c.aocta
                 and x.xllaooper = c.aooper
                 and x.xllaosbop = c.aosbop
                 and x.xllaotop = c.aotope;
            exception
              when others then
                null;
            end;
          
            begin
              select sum(f.pp1cap)
                into ln_CapPagad
                from fsd602 f
               where f.pgcod = c.pgcod
                 and f.ppmod = c.aomod
                 and f.ppsuc = c.aosuc
                 and f.ppmda = c.aomda
                 and f.pppap = c.aopap
                 and f.ppcta = c.aocta
                 and f.ppoper = c.aooper
                 and f.ppsbop = c.aosbop
                 and f.pptope = c.aotope
                 and f.d602co = 'S';
            exception
              when others then
                ln_CuoPagUDVAux := 0;
            end;
          
            if c.aoimp > 0 and ln_CapPagad > 0 then
              begin
                select (ln_CapPagad * 100) / c.aoimp
                  into ln_porcamortzAux
                  from dual;
              exception
                when others then
                  ln_porcamortzAux := 0;
              end;
            else
              ln_porcamortzAux := 0;
            end if;
          
            if ln_porcamortz = 0 and ln_porcamortzAux > 0 then
              ln_porcamortz := ln_porcamortzAux;
            else
              if ln_porcamortzAux < ln_porcamortz then
                ln_porcamortz := ln_porcamortzAux;
              end if;
            end if;
          end loop;
        
        end if;
      end if;
    end if;
  end sp_cr_Amortizcn_MEMO78;

  ----------------------------------------------------------------------
  procedure sp_cr_NroCuoPagUDV(ln_instancia in number,
                               ln_CuoPagUDV out number) is
  
    cursor creditos(ld_FchMaxDesVig date) is
    -- Adicional
      select *
        from fsd010 f
       where f.pgcod = 1
         and f.aomod in
             (select s.modulo
                from fst111 s
               where s.dscod = 50
                 and s.modulo not in (29, 33, 108, 116, 120, 142, 144, 200))
         and f.aomda in (0, 101)
         and f.aocta in (select r.ctnro
                           from fsr008 r, sng001 n
                          where r.pepais = n.sng001pais
                            and r.petdoc = n.sng001tdoc
                            and r.pendoc = n.sng001ndoc
                            and r.cttfir = 'T'
                            and n.sng001inst = ln_instancia)
         and f.aostat <> 99
         and f.aofval = ld_FchMaxDesVig;
  
    cursor pagos(ln_pgcod number,
                 ln_mod   number,
                 ln_suc   number,
                 ln_mda   number,
                 ln_pap   number,
                 ln_cta   number,
                 ln_ope   number,
                 ln_sbop  number,
                 ln_tope  number) is
    
      select f.d602cd,
             f.d602mo,
             f.d602su,
             f.d602tr,
             f.d602re,
             f.d602fc,
             f.d602or,
             f.d602sb,
             f.d602co
        from fsd602 f
       where f.pgcod = ln_pgcod --c.pgcod
         and f.ppmod = ln_mod --c.aomod
         and f.ppsuc = ln_suc --c.aosuc
         and f.ppmda = ln_mda --c.aomda
         and f.pppap = ln_pap --c.aopap
         and f.ppcta = ln_cta --c.aocta
         and f.ppoper = ln_ope --c.aooper
         and f.ppsbop = ln_sbop --c.aosbop
         and f.pptope = ln_tope --c.aotope
         and f.pp1stat = 'T'
         and f.d602co = 'S'
         and f.pp1cap > 0
      minus
      select distinct g.d012cd,
                      g.d012mo,
                      g.d012su,
                      g.d012tr,
                      g.d012re,
                      g.d012fc,
                      g.d012or,
                      g.d012sb,
                      g.d012co
        from fsd012 g
       where g.pgcod = ln_pgcod --c.pgcod
         and g.aomod = ln_mod --c.aomod
         and g.aosuc = ln_suc --c.aosuc
         and g.aomda = ln_mda --c.aomda
         and g.aopap = ln_pap --c.aopap
         and g.aocta = ln_cta --c.aocta
         and g.aooper = ln_ope --c.aooper
         and g.aosbop = ln_sbop --c.aosbop
         and g.aotope = ln_tope --c.aotope
         and g.evtipo in (31, 50)
         and g.d012co = 'S';
  
    ln_pais         number;
    ln_tdoc         number;
    lc_ndoc         varchar2(12);
    ln_TipSol       number;
    ln_CredVig      number := 0;
    ln_pgcod        number;
    ln_suc          number;
    ln_mod          number;
    ln_mda          number;
    ln_pap          number;
    ln_cta          number;
    ln_ope          number;
    ln_sbop         number;
    ln_tope         number;
    ld_FchMinDesVig date;
    ln_CuoPagUDVAux number := 0;
    ld_FchSist      date;
    ln_CupPagTx     number := 0;
    --ld_FIni         date;
    --ln_CuoPagCCAux  number;
  
  begin
  
    ln_CuoPagUDV := 0;
  
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc, s.sng001ori
        into ln_pais, ln_tdoc, lc_ndoc, ln_TipSol
        from sng001 s
       where s.sng001inst = ln_instancia;
    exception
      when others then
        null;
    end;
  
    begin
      select f.pgfape into ld_FchSist from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select count(*)
        into ln_CredVig
        from fsd010 f
       where f.pgcod = 1
         and f.aomod in
             (select s.modulo
                from fst111 s
               where s.dscod = 50
                 and s.modulo not in (29, 33, 108, 116, 120, 142, 144, 200))
         and f.aomda in (0, 101)
         and f.aocta in (select r.ctnro
                           from fsr008 r
                          where r.pepais = ln_pais
                            and r.petdoc = ln_tdoc
                            and r.pendoc = rpad(lc_ndoc, 12, ' ')
                            and r.cttfir = 'T')
         and f.aostat <> 99;
    exception
      when others then
        ln_CredVig := 0;
    end;
  
    if ln_TipSol = 0 and ln_CredVig = 0 then
      -- Nuevo
      ln_CuoPagUDV := 999;
    
    else
      if ln_TipSol = 4 and ln_CredVig > 0 then
        -- Ampliacion
        begin
          select x.xwfempresa,
                 x.xwfsucursal,
                 x.xwfmodulo,
                 x.xwfmoneda,
                 x.xwfpapel,
                 x.xwfcuenta,
                 x.xwfoperacion,
                 x.xwfsubope,
                 x.xwftipope
            into ln_pgcod,
                 ln_suc,
                 ln_mod,
                 ln_mda,
                 ln_pap,
                 ln_cta,
                 ln_ope,
                 ln_sbop,
                 ln_tope
            from xwf700 x
           where x.xwfprcins = ln_instancia
             and x.xwfcar3 <> '1';
        exception
          when others then
            null;
        end;
      
        begin
          select count(*)
            into ln_CuoPagUDV
            from fsd602 f
           where f.pgcod = ln_pgcod
             and f.ppmod = ln_mod
             and f.ppsuc = ln_suc
             and f.ppmda = ln_mda
             and f.pppap = ln_pap
             and f.ppcta = ln_cta
             and f.ppoper = ln_ope
             and f.ppsbop = ln_sbop
             and f.pptope = ln_tope
             and f.pp1stat = 'T'
             and f.d602co = 'S';
        exception
          when others then
            ln_CuoPagUDV := 0;
        end;
      else
        if ln_TipSol <> 4 and ln_CredVig > 0 then
          -- Adicional
          begin
            select max(f.aofval)
              into ld_FchMinDesVig
              from fsd010 f
             where f.pgcod = 1
               and f.aomod in
                   (select s.modulo
                      from fst111 s
                     where s.dscod = 50
                       and s.modulo not in
                           (29, 33, 108, 116, 120, 142, 144, 200)) ----9
               and f.aomda in (0, 101)
               and f.aocta in (select r.ctnro
                                 from fsr008 r
                                where r.pepais = ln_pais
                                  and r.petdoc = ln_tdoc
                                  and r.pendoc = rpad(lc_ndoc, 12, ' ')
                                  and r.cttfir = 'T')
               and f.aostat <> 99;
          exception
            when others then
              null;
          end;
        
          for c in creditos(ld_FchMinDesVig) loop
            for p in pagos(c.pgcod, c.aomod, c.aosuc, c.aomda, c.aopap, c.aocta, c.aooper, c.aosbop, c.aotope) loop
              begin
                select count(*)
                  into ln_CupPagTx
                  from fsd602 f
                 where f.d602cd = p.d602cd
                   and f.d602mo = p.d602mo
                   and f.d602su = p.d602su
                   and f.d602tr = p.d602tr
                   and f.d602re = p.d602re
                   and f.d602fc = p.d602fc
                   and f.d602or = p.d602or
                   and f.d602co = 'S';
              exception
                when others then
                  null;
                
              end;
            
              ln_CuoPagUDVAux := nvl(ln_CuoPagUDVAux, 0) +
                                 nvl(ln_CupPagTx, 0);
            end loop;
          
            if ln_CuoPagUDVAux > ln_CuoPagUDV then
              ln_CuoPagUDV := ln_CuoPagUDVAux;
            end if;
          
          end loop;
        
        end if;
      
      end if;
    end if;
  end sp_cr_NroCuoPagUDV;

end PQ_CR_MEMO59_78;
/

