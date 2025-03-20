create or replace package PQ_CR_RTELINEASPLAZO is

  -- Author  : MPOSTIGOC
  -- Created : 12/09/2017 10:03:05 a.m.
  -- Purpose : Compara el plazo de la linea en su fecha de alta con respecto a su segmentacion
  --           contra la segmentacion  - plazo almacenada en una tabla historica JAQZ813 

  procedure sp_cr_inicio(lc_Usuario   in varchar2,
                         ln_pgcodt    in number,
                         ln_suct      in number,
                         ln_modt      in number,
                         ln_ttran     in number,
                         ln_relt      in number,
                         ln_ordt      in number,
                         ln_sbort     in number,
                         ln_plazo     out number,
                         ln_PlazoSist out number,
                         lc_pcancel   out varchar2);
  -------------------------------------------------------
  procedure sp_cr_VerTipoCred(ln_instancia in number, ln_plazo out number);
  ------------------------------------------------------------
  procedure sp_cr_ControlAntg(ln_Pgcod116  in number,
                              ln_ctnro116  in number,
                              ln_Itoper116 in number,
                              ln_Itsubo116 in number,
                              ln_Itsucd116 in number,
                              ln_Ittope116 in number,
                              ln_Modulo116 in number,
                              ln_Moneda116 in number,
                              ln_Papel116  in number,
                              ln_plazo     out number,
                              ln_PlazoSist out number,
                              lc_pcancel   out varchar2);
  -------------------------------------------------------------
  procedure sp_cr_ControlNuevo(ln_Pgcod116  in number,
                               ln_ctnro116  in number,
                               ln_Itoper116 in number,
                               ln_Itsubo116 in number,
                               ln_Itsucd116 in number,
                               ln_Ittope116 in number,
                               ln_Modulo116 in number,
                               ln_Moneda116 in number,
                               ln_Papel116  in number,
                               ln_plazo     out number,
                               ln_PlazoSist out number,
                               lc_pcancel   out varchar2);
  ----------------------------------------------------------------
  procedure sp_cr_InsertaAQPA351(lc_Usuario          in varchar2,
                                 ln_pgcodt           in number,
                                 ln_suct             in number,
                                 ln_modt             in number,
                                 ln_ttran            in number,
                                 ln_relt             in number,
                                 ln_ordt             in number,
                                 ln_sbort            in number,
                                 ln_Pgcod116         in number,
                                 ln_ctnro116         in number,
                                 ln_Itoper116        in number,
                                 ln_Itsubo116        in number,
                                 ln_Itsucd116        in number,
                                 ln_Ittope116        in number,
                                 ln_Modulo116        in number,
                                 ln_Moneda116        in number,
                                 ln_Papel116         in number,
                                 ln_pgcod117         in number,
                                 ln_modulo117        in number,
                                 ln_sucur117         in number,
                                 ln_moneda117        in number,
                                 ln_papel117         in number,
                                 ln_cuenta117        in number,
                                 ln_operac117        in number,
                                 ln_sboper117        in number,
                                 ln_tipoper117       in number,
                                 ld_FchDesembol      in date,
                                 ld_FchNuevPlazoLine in date,
                                 ln_plazo            in number,
                                 ln_PlazoSist        in number);

--------------------------------------------------------------------

end PQ_CR_RTELINEASPLAZO;
/

create or replace package body PQ_CR_RTELINEASPLAZO is

  procedure sp_cr_inicio(lc_Usuario   in varchar2,
                         ln_pgcodt    in number,
                         ln_suct      in number,
                         ln_modt      in number,
                         ln_ttran     in number,
                         ln_relt      in number,
                         ln_ordt      in number,
                         ln_sbort     in number,
                         ln_plazo     out number,
                         ln_PlazoSist out number,
                         lc_pcancel   out varchar2) is
  
    ln_Pgcod116   number;
    ln_ctnro116   number;
    ln_Itoper116  number;
    ln_Itsubo116  number;
    ln_Itsucd116  number;
    ln_Ittope116  number;
    ln_Modulo116  number;
    ln_Moneda116  number;
    ln_Papel116   number;
    ln_pgcod117   number;
    ln_modulo117  number;
    ln_sucur117   number;
    ln_moneda117  number;
    ln_papel117   number;
    ln_cuenta117  number;
    ln_operac117  number;
    ln_sboper117  number;
    ln_tipoper117 number;
    --ln_instancia117     number;
    ld_FchNuevPlazoLine date;
    ld_FchDesembol      date;
  
  begin
  
    begin
      -- Extrae los dtos del credito de la Transaccion
      select PgCod,
             Ctnro,
             Itoper,
             Itsubo,
             Itsucd,
             Ittope,
             Modulo,
             Moneda,
             Papel
        into ln_Pgcod116,
             ln_ctnro116,
             ln_Itoper116,
             ln_Itsubo116,
             ln_Itsucd116,
             ln_Ittope116,
             ln_Modulo116,
             ln_Moneda116,
             ln_Papel116
        from FSD016
       Where PgCod = ln_pgcodt
         and Itsuc = ln_suct
         and Itmod = ln_modt
         and Ittran = ln_ttran
         and Itnrel = ln_relt
         and Itord = ln_ordt
         and Itsbor = ln_sbort;
    exception
      when others then
        null;
      
    end;
  
    if ln_Modulo116 = 116 then
    
      begin
        -- clave del credito principal
        select r2cod,
               r2mod,
               r2suc,
               r2mda,
               r2pap,
               r2cta,
               r2oper,
               r2sbop,
               r2tope
          into ln_pgcod117,
               ln_modulo117,
               ln_sucur117,
               ln_moneda117,
               ln_papel117,
               ln_cuenta117,
               ln_operac117,
               ln_sboper117,
               ln_tipoper117
          from fsr011
         where relcod = 46
           and r1cod = ln_Pgcod116
           and r1mod = ln_Modulo116
           and r1suc = ln_Itsucd116
           and r1mda = ln_Moneda116
           and r1pap = ln_Papel116
           and r1cta = ln_ctnro116
           and r1oper = ln_Itoper116
           and r1sbop = ln_Itsubo116
           and r1tope = ln_Ittope116;
      exception
        when no_data_found then
          begin
            select r2cod,
                   r2mod,
                   r2suc,
                   r2mda,
                   r2pap,
                   r2cta,
                   r2oper,
                   r2sbop,
                   r2tope
              into ln_pgcod117,
                   ln_modulo117,
                   ln_sucur117,
                   ln_moneda117,
                   ln_papel117,
                   ln_cuenta117,
                   ln_operac117,
                   ln_sboper117,
                   ln_tipoper117
              from fsr011
             where relcod = 46
               and r1cod = ln_Pgcod116
               and r1mod = ln_Modulo116
               and r1suc = ln_Itsucd116
               and r1mda = ln_Moneda116
               and r1pap = ln_Papel116
               and r1cta = ln_ctnro116
               and r2oper = ln_Itoper116
               and r1sbop = ln_Itsubo116
               and r1tope = ln_Ittope116;
          exception
            when others then
              null;
          end;
        
        when others then
          null;
      end;
    
    else
      if ln_Modulo116 = 117 then
        ln_pgcod117   := ln_Pgcod116;
        ln_modulo117  := ln_Modulo116;
        ln_sucur117   := ln_Itsucd116;
        ln_moneda117  := ln_Moneda116;
        ln_papel117   := ln_Papel116;
        ln_cuenta117  := ln_ctnro116;
        ln_operac117  := ln_Itoper116;
        ln_sboper117  := ln_Itsubo116;
        ln_tipoper117 := ln_Ittope116;
      end if;
    end if;
  
    if ln_cuenta117 is not null then
      begin
        -- Fecha de Inicio del nuevo control de Plazo
        select to_date(a.tp1nro1 || '/' || a.tp1nro2 || '/' || a.tp1nro3,
                       'DD/MM/YYYY')
          into ld_FchNuevPlazoLine
          from fst198 a
         where a.tp1cod = 1
           and a.tp1cod1 = 10899
           and a.tp1corr1 = 13
           and a.tp1corr2 = 22
           and a.tp1corr3 = 1;
      end;
    
      begin
        -- Fecha de Desembolso
        select f.aofval
          into ld_FchDesembol
          from fsd010 f
         where f.pgcod = ln_pgcod117
           and f.aomod = ln_modulo117
           and f.aosuc = ln_sucur117
           and f.aomda = ln_moneda117
           and f.aopap = ln_papel117
           and f.aocta = ln_cuenta117
           and f.aooper = ln_operac117
           and f.aosbop = ln_sboper117
           and f.aotope = ln_tipoper117;
      end;
    
      if ld_FchDesembol < ld_FchNuevPlazoLine then
        pq_cr_rtelineasplazo.sp_cr_ControlAntg(ln_Pgcod116,
                                               ln_ctnro116,
                                               ln_Itoper116,
                                               ln_Itsubo116,
                                               ln_Itsucd116,
                                               ln_Ittope116,
                                               ln_Modulo116,
                                               ln_Moneda116,
                                               ln_Papel116,
                                               ln_plazo,
                                               ln_PlazoSist,
                                               lc_pcancel);
      
      else
        if ld_FchDesembol >= ld_FchNuevPlazoLine then
          pq_cr_rtelineasplazo.sp_cr_ControlNuevo(ln_Pgcod116,
                                                  ln_ctnro116,
                                                  ln_Itoper116,
                                                  ln_Itsubo116,
                                                  ln_Itsucd116,
                                                  ln_Ittope116,
                                                  ln_Modulo116,
                                                  ln_Moneda116,
                                                  ln_Papel116,
                                                  ln_plazo,
                                                  ln_PlazoSist,
                                                  lc_pcancel);
        end if;
      end if;
    
    else
      lc_pcancel := 'N';
    end if;
  
    begin
      pq_cr_rtelineasplazo.sp_cr_InsertaAQPA351(lc_Usuario,
                                                ln_pgcodt,
                                                ln_suct,
                                                ln_modt,
                                                ln_ttran,
                                                ln_relt,
                                                ln_ordt,
                                                ln_sbort,
                                                ln_Pgcod116,
                                                ln_ctnro116,
                                                ln_Itoper116,
                                                ln_Itsubo116,
                                                ln_Itsucd116,
                                                ln_Ittope116,
                                                ln_Modulo116,
                                                ln_Moneda116,
                                                ln_Papel116,
                                                ln_pgcod117,
                                                ln_modulo117,
                                                ln_sucur117,
                                                ln_moneda117,
                                                ln_papel117,
                                                ln_cuenta117,
                                                ln_operac117,
                                                ln_sboper117,
                                                ln_tipoper117,
                                                ld_FchDesembol,
                                                ld_FchNuevPlazoLine,
                                                ln_plazo,
                                                ln_PlazoSist);
    end;
  
  end sp_cr_inicio;
  ----------------------------------------------------
  procedure sp_cr_ControlAntg(ln_Pgcod116  in number,
                              ln_ctnro116  in number,
                              ln_Itoper116 in number,
                              ln_Itsubo116 in number,
                              ln_Itsucd116 in number,
                              ln_Ittope116 in number,
                              ln_Modulo116 in number,
                              ln_Moneda116 in number,
                              ln_Papel116  in number,
                              ln_plazo     out number,
                              ln_PlazoSist out number,
                              lc_pcancel   out varchar2) is
  
    ln_pgcod117        number;
    ln_modulo117       number;
    ln_sucur117        number;
    ln_moneda117       number;
    ln_papel117        number;
    ln_cuenta117       number;
    ln_operac117       number;
    ln_sboper117       number;
    ln_tipoper117      number;
    ln_instancia117    number;
    lc_FlagGuia        varchar2(1);
    pn_trn             number;
    ln_ctaX            number;
    lc_FlagGuiaAdic    varchar2(1) := 'N';
    lc_FlagGuiaAdicPrf varchar2(1) := 'N';
  
  begin
    begin
      -- Verifica si es una adicional   
      select 'S'
        into lc_FlagGuiaAdic
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and a.tp1corr1 = 13
         and a.tp1corr2 = 19
         and a.tp1nro2 = 117
         and a.tp1nro3 = ln_Ittope116;
    exception
      when others then
        lc_FlagGuiaAdic := 'N';
    end;
  
    if lc_FlagGuiaAdic = 'S' then
    
      begin
        -- Verifica si es una adicional Preferencial
        select 'S'
          into lc_FlagGuiaAdicPrf
          from fst198 a
         where a.tp1cod = 1
           and a.tp1cod1 = 10899
           and a.tp1corr1 = 13
           and a.tp1corr2 = 20
           and a.tp1nro2 = 117
           and a.tp1nro3 = ln_Ittope116;
      exception
        when others then
          lc_FlagGuiaAdicPrf := 'N';
      end;
    
      if lc_FlagGuiaAdicPrf = 'S' then
      
        begin
        
          select a.tp1nro3
            into ln_PlazoSist
            from fst198 a
           where a.tp1cod = 1
             and a.tp1cod1 = 10899
             and a.tp1corr1 = 13
             and a.tp1corr2 = 21
             and a.tp1corr3 = 2;
        end;
      
      else
        if lc_FlagGuiaAdicPrf = 'N' then
          begin
          
            select a.tp1nro3
              into ln_PlazoSist
              from fst198 a
             where a.tp1cod = 1
               and a.tp1cod1 = 10899
               and a.tp1corr1 = 13
               and a.tp1corr2 = 21
               and a.tp1corr3 = 1;
          end;
        
        end if;
      end if;
    
    else
      if lc_FlagGuiaAdic = 'N' then
      
        if ln_Modulo116 = 116 then
        
          begin
            -- clave del credito princiapl
            select r2cod,
                   r2mod,
                   r2suc,
                   r2mda,
                   r2pap,
                   r2cta,
                   r2oper,
                   r2sbop,
                   r2tope
              into ln_pgcod117,
                   ln_modulo117,
                   ln_sucur117,
                   ln_moneda117,
                   ln_papel117,
                   ln_cuenta117,
                   ln_operac117,
                   ln_sboper117,
                   ln_tipoper117
              from fsr011
             where relcod = 46
               and r1cod = ln_Pgcod116
               and r1mod = ln_Modulo116
               and r1suc = ln_Itsucd116
               and r1mda = ln_Moneda116
               and r1pap = ln_Papel116
               and r1cta = ln_ctnro116
               and r1oper = ln_Itoper116
               and r1sbop = ln_Itsubo116
               and r1tope = ln_Ittope116;
          exception
            when no_data_found then
              begin
                select r2cod,
                       r2mod,
                       r2suc,
                       r2mda,
                       r2pap,
                       r2cta,
                       r2oper,
                       r2sbop,
                       r2tope
                  into ln_pgcod117,
                       ln_modulo117,
                       ln_sucur117,
                       ln_moneda117,
                       ln_papel117,
                       ln_cuenta117,
                       ln_operac117,
                       ln_sboper117,
                       ln_tipoper117
                  from fsr011
                 where relcod = 46
                   and r1cod = ln_Pgcod116
                   and r1mod = ln_Modulo116
                   and r1suc = ln_Itsucd116
                   and r1mda = ln_Moneda116
                   and r1pap = ln_Papel116
                   and r1cta = ln_ctnro116
                   and r2oper = ln_Itoper116
                   and r1sbop = ln_Itsubo116
                   and r1tope = ln_Ittope116;
              exception
                when others then
                  null;
              end;
            
            when others then
              null;
          end;
        
        else
          if ln_Modulo116 = 117 then
            ln_pgcod117   := ln_Pgcod116;
            ln_modulo117  := ln_Modulo116;
            ln_sucur117   := ln_Itsucd116;
            ln_moneda117  := ln_Moneda116;
            ln_papel117   := ln_Papel116;
            ln_cuenta117  := ln_ctnro116;
            ln_operac117  := ln_Itoper116;
            ln_sboper117  := ln_Itsubo116;
            ln_tipoper117 := ln_Ittope116;
          end if;
        end if;
      
        begin
          select 'S'
            into lc_FlagGuia
            from fst198 a
           where a.tp1cod = 1
             and a.tp1cod1 = 10899
             and a.tp1corr1 = 13
             and a.tp1corr2 = 18
             and a.tp1nro2 = ln_modulo117
             and a.tp1nro3 = ln_tipoper117;
        exception
          when others then
            lc_FlagGuia := 'N';
          
        end;
      
        if lc_FlagGuia = 'S' then
        
          begin
            -- instancia del credito 117
            select xwfprcins
              into ln_instancia117
              from xwf700
             where xwfempresa = ln_pgcod117
               and xwfmodulo = ln_modulo117
               and xwfsucursal = ln_sucur117
               and xwfmoneda = ln_moneda117
               and xwfpapel = ln_papel117
               and xwfcuenta = ln_cuenta117
               and xwfoperacion = ln_operac117
               and xwfsubope = ln_sboper117
               and xwftipope = ln_tipoper117
               and xwfcar3 = '1';
          exception
            when others then
              null;
          end;
        
          pq_cr_rtelineasplazo.sp_cr_VerTipoCred(ln_instancia117,
                                                 ln_PlazoSist);
        
        else
        
          if lc_FlagGuia = 'N' then
            -- Extraemos el plazo del Preseteo
            -- mpostigoc 09/01/2018
          
            begin
              select f.pp028maxn
                into ln_PlazoSist
                from fpp028 f
               where f.pp017par = 103
                 and f.pp028mod = 116
                 and f.pp028top = ln_tipoper117
                 and f.pp028mda = ln_moneda117; -- plazo
            exception
              when others then
                null;
            end;
          
          end if;
        
        end if;
      
      end if;
    end if;
  
    ----- Verifica Plazo de la Linea que se esta procesando
  
    begin
      select max(Ittran)
        into pn_trn
        from FSD016 f
       where f.PgCod = ln_Pgcod116
         and f.Ctnro = ln_ctnro116
         and f.Itoper = ln_Itoper116
         and f.Itsubo = ln_Itsubo116
         and f.Itsucd = ln_Itsucd116
         and f.Ittope = ln_Ittope116
         and f.Modulo = ln_Modulo116
         and f.Moneda = ln_Moneda116
         and f.Papel = ln_Papel116;
    exception
      when others then
        null;
      
    end;
  
    if pn_trn = 50 then
      begin
        select ((a.xllcantcuo * a.xllperiodo) / 30)
          into ln_plazo
          from x054023 a
         where a.xllpgcod = ln_Pgcod116
           and a.xllaomod = ln_Modulo116
           and a.xllaosuc = ln_Itsucd116
           and a.xllaomda = ln_Moneda116
           and a.xllaopap = ln_Papel116
           and a.xllaocta = ln_ctnro116
           and a.xllaooper = ln_Itoper116
           and a.xllaosbop = ln_Itsubo116
           and a.xllaotop = ln_Ittope116;
      exception
        when others then
          ln_plazo := 0;
      end;
    else
      ln_ctaX := 999999999;
      begin
        select ((a.xllcantcuo * a.xllperiodo) / 30)
          into ln_plazo
          from x054023 a
         where a.xllpgcod = ln_Pgcod116
           and a.xllaomod = ln_Modulo116
           and a.xllaosuc = ln_Itsucd116
           and a.xllaomda = ln_Moneda116
           and a.xllaopap = ln_Papel116
           and a.xllaocta = ln_ctaX
           and a.xllaooper = ln_Itoper116
           and a.xllaosbop = ln_Itsubo116
           and a.xllaotop = ln_Ittope116;
      exception
        when no_data_found then
        
          begin
            select ((a.xllcantcuo * a.xllperiodo) / 30)
              into ln_plazo
              from x054023 a
             where a.xllpgcod = ln_Pgcod116
               and a.xllaomod = ln_Modulo116
               and a.xllaosuc = ln_Itsucd116
               and a.xllaomda = ln_Moneda116
               and a.xllaopap = ln_Papel116
               and a.xllaocta = ln_ctnro116
               and a.xllaooper = ln_Itoper116
               and a.xllaosbop = ln_Itsubo116
               and a.xllaotop = ln_Ittope116;
          exception
            when others then
              ln_plazo := 0;
          end;
        when others then
          ln_plazo := 0;
      end;
    end if;
  
    if ln_plazo > ln_PlazoSist then
      lc_pcancel := 'S';
    else
      lc_pcancel := 'N';
    end if;
  
  end sp_cr_ControlAntg;
  --------------------------------------------------
  procedure sp_cr_ControlNuevo(ln_Pgcod116  in number,
                               ln_ctnro116  in number,
                               ln_Itoper116 in number,
                               ln_Itsubo116 in number,
                               ln_Itsucd116 in number,
                               ln_Ittope116 in number,
                               ln_Modulo116 in number,
                               ln_Moneda116 in number,
                               ln_Papel116  in number,
                               ln_plazo     out number,
                               ln_PlazoSist out number,
                               lc_pcancel   out varchar2) is
  
    ln_pgcod117   number;
    ln_modulo117  number;
    ln_sucur117   number;
    ln_moneda117  number;
    ln_papel117   number;
    ln_cuenta117  number;
    ln_operac117  number;
    ln_sboper117  number;
    ln_tipoper117 number;
    --ln_instancia117     number;
    --ld_FchNuevPlazoLine date;
    --ld_FchDesembol      date;
    lc_FlagGuia     varchar2(1);
    pn_trn          number;
    ln_ctaX         number;
    lc_FlagGuiaAdic varchar2(1) := 'N';
    --lc_FlagGuiaAdicPrf varchar2(1) := 'N';
  
  begin
    begin
      -- Verifica si es una adicional   
      select 'S'
        into lc_FlagGuiaAdic
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and a.tp1corr1 = 13
         and a.tp1corr2 = 23
         and a.tp1corr3 > 1
         and a.tp1nro2 = 117
         and a.tp1nro3 = ln_Ittope116;
    
    exception
      when others then
        lc_FlagGuiaAdic := 'N';
    end;
  
    if lc_FlagGuiaAdic = 'S' then
      begin
        select a.tp1imp1
          into ln_PlazoSist
          from fst198 a
         where a.tp1cod = 1
           and a.tp1cod1 = 10899
           and a.tp1corr1 = 13
           and a.tp1corr2 = 23
           and a.tp1corr3 > 1
           and a.tp1nro2 = 117
           and a.tp1nro3 = ln_Ittope116;
      exception
        when others then
          ln_PlazoSist := 0;
      end;
    
    else
      if lc_FlagGuiaAdic = 'N' then
      
        if ln_Modulo116 = 116 then
        
          begin
            -- clave del credito princiapl
            select r2cod,
                   r2mod,
                   r2suc,
                   r2mda,
                   r2pap,
                   r2cta,
                   r2oper,
                   r2sbop,
                   r2tope
              into ln_pgcod117,
                   ln_modulo117,
                   ln_sucur117,
                   ln_moneda117,
                   ln_papel117,
                   ln_cuenta117,
                   ln_operac117,
                   ln_sboper117,
                   ln_tipoper117
              from fsr011
             where relcod = 46
               and r1cod = ln_Pgcod116
               and r1mod = ln_Modulo116
               and r1suc = ln_Itsucd116
               and r1mda = ln_Moneda116
               and r1pap = ln_Papel116
               and r1cta = ln_ctnro116
               and r1oper = ln_Itoper116
               and r1sbop = ln_Itsubo116
               and r1tope = ln_Ittope116;
          exception
            when no_data_found then
              begin
                select r2cod,
                       r2mod,
                       r2suc,
                       r2mda,
                       r2pap,
                       r2cta,
                       r2oper,
                       r2sbop,
                       r2tope
                  into ln_pgcod117,
                       ln_modulo117,
                       ln_sucur117,
                       ln_moneda117,
                       ln_papel117,
                       ln_cuenta117,
                       ln_operac117,
                       ln_sboper117,
                       ln_tipoper117
                  from fsr011
                 where relcod = 46
                   and r1cod = ln_Pgcod116
                   and r1mod = ln_Modulo116
                   and r1suc = ln_Itsucd116
                   and r1mda = ln_Moneda116
                   and r1pap = ln_Papel116
                   and r1cta = ln_ctnro116
                   and r2oper = ln_Itoper116
                   and r1sbop = ln_Itsubo116
                   and r1tope = ln_Ittope116;
              exception
                when others then
                  null;
              end;
            
            when others then
              null;
          end;
        
        else
          if ln_Modulo116 = 117 then
            --ln_pgcod117   := ln_Pgcod116;
            ln_modulo117 := ln_Modulo116;
            -- ln_sucur117   := ln_Itsucd116;
            ln_moneda117 := ln_Moneda116;
            --ln_papel117   := ln_Papel116;
            -- ln_cuenta117  := ln_ctnro116;
            -- ln_operac117  := ln_Itoper116;
            --  ln_sboper117  := ln_Itsubo116;
            ln_tipoper117 := ln_Ittope116;
          end if;
        end if;
      
        begin
          select 'S'
            into lc_FlagGuia
            from fst198 a
           where a.tp1cod = 1
             and a.tp1cod1 = 10899
             and a.tp1corr1 = 13
             and a.tp1corr2 = 24
             and a.tp1corr3 > 0
             and a.tp1nro2 = ln_modulo117
             and a.tp1nro3 = ln_tipoper117;
        exception
          when others then
            lc_FlagGuia := 'N';
          
        end;
      
        if lc_FlagGuia = 'S' then
        
          begin
            select f.pp028maxn
              into ln_PlazoSist
              from fpp028 f
             where f.pp017par = 103
               and f.pp028mod = 116
               and f.pp028top = ln_tipoper117
               and f.pp028mda = ln_moneda117; -- plazo
          exception
            when others then
              null;
          end;
        
        end if;
      
      end if;
    end if;
  
    ----- Verifica Plazo de la Linea que se esta procesando
  
    begin
      select max(Ittran)
        into pn_trn
        from FSD016 f
       where f.PgCod = ln_Pgcod116
         and f.Ctnro = ln_ctnro116
         and f.Itoper = ln_Itoper116
         and f.Itsubo = ln_Itsubo116
         and f.Itsucd = ln_Itsucd116
         and f.Ittope = ln_Ittope116
         and f.Modulo = ln_Modulo116
         and f.Moneda = ln_Moneda116
         and f.Papel = ln_Papel116;
    exception
      when others then
        null;
      
    end;
  
    if pn_trn = 50 then
      begin
        select ((a.xllcantcuo * a.xllperiodo) / 30)
          into ln_plazo
          from x054023 a
         where a.xllpgcod = ln_Pgcod116
           and a.xllaomod = ln_Modulo116
           and a.xllaosuc = ln_Itsucd116
           and a.xllaomda = ln_Moneda116
           and a.xllaopap = ln_Papel116
           and a.xllaocta = ln_ctnro116
           and a.xllaooper = ln_Itoper116
           and a.xllaosbop = ln_Itsubo116
           and a.xllaotop = ln_Ittope116;
      exception
        when others then
          ln_plazo := 0;
      end;
    else
      ln_ctaX := 999999999;
      begin
        select ((a.xllcantcuo * a.xllperiodo) / 30)
          into ln_plazo
          from x054023 a
         where a.xllpgcod = ln_Pgcod116
           and a.xllaomod = ln_Modulo116
           and a.xllaosuc = ln_Itsucd116
           and a.xllaomda = ln_Moneda116
           and a.xllaopap = ln_Papel116
           and a.xllaocta = ln_ctaX
           and a.xllaooper = ln_Itoper116
           and a.xllaosbop = ln_Itsubo116
           and a.xllaotop = ln_Ittope116;
      exception
        when no_data_found then
        
          begin
            select ((a.xllcantcuo * a.xllperiodo) / 30)
              into ln_plazo
              from x054023 a
             where a.xllpgcod = ln_Pgcod116
               and a.xllaomod = ln_Modulo116
               and a.xllaosuc = ln_Itsucd116
               and a.xllaomda = ln_Moneda116
               and a.xllaopap = ln_Papel116
               and a.xllaocta = ln_ctnro116
               and a.xllaooper = ln_Itoper116
               and a.xllaosbop = ln_Itsubo116
               and a.xllaotop = ln_Ittope116;
          exception
            when others then
              ln_plazo := 0;
          end;
        when others then
          ln_plazo := 0;
      end;
    end if;
  
    if ln_PlazoSist is not null then
    
      if ln_plazo > ln_PlazoSist then
        lc_pcancel := 'S';
      else
        lc_pcancel := 'N';
      end if;
    else
      lc_pcancel := 'N';
    end if;
  
  end sp_cr_ControlNuevo;
  --------------------------------------------------
  procedure sp_cr_VerTipoCred(ln_instancia in number, ln_plazo out number) is
  
    ln_tope10     number;
    ln_mda10      number;
    LN_TIPOCRED   number;
    lc_FlagSegmnt varchar2(2);
  begin
    -- Tipo de Credito en el flujo
    begin
      select to_number(REGEXP_REPLACE((UPPER(replace(w.wfattsval, ';', ''))),
                                      '([A-Z])',
                                      ''))
        into LN_TIPOCRED
        from wfattsvalues w
       where w.wfinsprcid = ln_instancia
         and w.wfattsid = 'TIPO_CREDITO';
    exception
      when others then
        null;
    end;
  
    begin
      select 'S'
        into lc_FlagSegmnt
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and a.tp1corr1 = 13
         and a.tp1corr2 = 17
         and a.tp1nro3 = LN_TIPOCRED;
    exception
      when others then
        lc_FlagSegmnt := 'N';
    end;
  
    begin
      select x.xwftipope, x.xwfmoneda
        into ln_tope10, ln_mda10
        from xwf700 x
       where xwfprcins = ln_instancia
         and xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
    if lc_FlagSegmnt = 'S' then
      /* -- mpostigoc 23/11/2017
      
      begin
        select f.pp028maxn
          into ln_plazo
          from fpp028 f
         where f.pp017par = 103
           and f.pp028mod = 116
           and f.pp028top = ln_tope10
           and f.pp028mda = ln_mda10; -- plazo
      exception
        when others then
          null;
      end;*/ -- mpostigoc 30/11/18
    
      begin
        select a.aqpa35028maxn
          into ln_plazo
          from aqpa350 a
         where a.aqpa35010prd = 1
           and a.aqpa35017par = 103
           and a.aqpa35028emp = 1
           and a.aqpa35028mod = 116
           and a.aqpa35028top = ln_tope10
           and a.aqpa35028mda = ln_mda10;
      exception
        when others then
          null;
      end;
    
    else
      if lc_FlagSegmnt = 'N' then
      
        begin
          select a.tp1nro2
            into ln_plazo
            from fst198 a
           where a.tp1cod = 1
             and a.tp1cod1 = 10899
             and a.tp1corr1 = 13
             and a.tp1corr2 = 17
             and a.tp1corr3 = 4;
        end;
      
      end if;
    end if;
  end sp_cr_VerTipoCred;
  -------------------------------------------------------------
  procedure sp_cr_InsertaAQPA351(lc_Usuario          in varchar2,
                                 ln_pgcodt           in number,
                                 ln_suct             in number,
                                 ln_modt             in number,
                                 ln_ttran            in number,
                                 ln_relt             in number,
                                 ln_ordt             in number,
                                 ln_sbort            in number,
                                 ln_Pgcod116         in number,
                                 ln_ctnro116         in number,
                                 ln_Itoper116        in number,
                                 ln_Itsubo116        in number,
                                 ln_Itsucd116        in number,
                                 ln_Ittope116        in number,
                                 ln_Modulo116        in number,
                                 ln_Moneda116        in number,
                                 ln_Papel116         in number,
                                 ln_pgcod117         in number,
                                 ln_modulo117        in number,
                                 ln_sucur117         in number,
                                 ln_moneda117        in number,
                                 ln_papel117         in number,
                                 ln_cuenta117        in number,
                                 ln_operac117        in number,
                                 ln_sboper117        in number,
                                 ln_tipoper117       in number,
                                 ld_FchDesembol      in date,
                                 ld_FchNuevPlazoLine in date,
                                 ln_plazo            in number,
                                 ln_PlazoSist        in number) is
  
    ld_FchSist date;
    lc_hora    character(8);
  
  begin
  
    begin
      select pgfape into ld_FchSist from fst017 where pgcod = 1;
    end;
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    end;
  
    begin
      insert into aqpa351
        (aqpa351fproc,
         aqpa351hora,
         aqpa351user,
         aqpa351pgcodt,
         aqpa351suct,
         aqpa351modt,
         aqpa351ttran,
         aqpa351relt,
         aqpa351ordt,
         aqpa351sbort,
         AQPA351PgCod,
         aqpa351ctnro,
         aqpa351itoper,
         aqpa351itsubo,
         aqpa351itsucd,
         aqpa351ittope,
         aqpa351modulo,
         aqpa351moneda,
         aqpa351papel,
         aqpa351pgcod17,
         aqpa351mod17,
         aqpa351suc17,
         aqpa351mda17,
         aqpa351pap17,
         aqpa351cta17,
         aqpa351oper17,
         aqpa351subo17,
         aqpa351tope17,
         aqpa351fdes,
         aqpa351fchnplz,
         aqpa351plzing,
         aqpa351plzperm)
      values
        (ld_FchSist,
         lc_hora,
         lc_Usuario,
         ln_pgcodt,
         ln_suct,
         ln_modt,
         ln_ttran,
         ln_relt,
         ln_ordt,
         ln_sbort,
         ln_Pgcod116,
         ln_ctnro116,
         ln_Itoper116,
         ln_Itsubo116,
         ln_Itsucd116,
         ln_Ittope116,
         ln_Modulo116,
         ln_Moneda116,
         ln_Papel116,
         ln_pgcod117,
         ln_modulo117,
         ln_sucur117,
         ln_moneda117,
         ln_papel117,
         ln_cuenta117,
         ln_operac117,
         ln_sboper117,
         ln_tipoper117,
         ld_FchDesembol,
         ld_FchNuevPlazoLine,
         ln_plazo,
         ln_PlazoSist);
    
      commit;
    end;
  
  end sp_cr_InsertaAQPA351;
  -------------------------------------------------------------- 
end PQ_CR_RTELINEASPLAZO;
/

