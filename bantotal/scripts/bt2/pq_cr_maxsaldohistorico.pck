create or replace package PQ_CR_MAXSALDOHISTORICO is

  -- Author  : MPOSTIGOC
  -- Created : 18/12/2017 12:08:49 p.m.
  -- Purpose : 
  procedure sp_cr_inicio(ln_Instancia in number, ln_MaxSaldHist out number);
  procedure sp_cr_VerificaExcepciones(ln_pgcod     in number,
                                      ln_modulo    in number,
                                      ln_sucursal  in number,
                                      ln_moneda    in number,
                                      ln_papel     in number,
                                      ln_cuenta    in number,
                                      ln_operac    in number,
                                      ln_suboper   in number,
                                      ln_tipoper   in number,
                                      lc_VerifExcp out Varchar2);

end PQ_CR_MAXSALDOHISTORICO;
/

create or replace package body PQ_CR_MAXSALDOHISTORICO is

  procedure sp_cr_inicio(ln_Instancia in number, ln_MaxSaldHist out number) is
  
    cursor NroCuentas is
      select p.ctnro
        from fsr008 p,
             (select distinct f.pepais, f.petdoc, f.pendoc
                from fsr008 f
               where f.ctnro in
                     (select s.sng001cta
                        from sng001 s
                       where s.sng001inst = ln_Instancia)
              union
              select distinct g.pepais, g.petdoc, g.rpndoc
                from fsr008 f, fsr002 g
               where f.ctnro in
                     (select s.sng001cta
                        from sng001 s
                       where s.sng001inst = ln_Instancia)
                 and f.pepais = g.pepais
                 and f.petdoc = g.petdoc
                 and f.pendoc = g.pendoc
                    -- and f.cttfir = 'T'
                 and g.rpccyg = 66
              union
              select distinct g.pepais, g.petdoc, g.pendoc
                from fsr008 f, fsr002 g
               where f.ctnro in
                     (select s.sng001cta
                        from sng001 s
                       where s.sng001inst = ln_Instancia)
                 and f.pepais = g.rppais
                 and f.petdoc = g.rptdoc
                 and f.pendoc = g.rpndoc
                    -- and f.cttfir = 'T'
                 and g.rpccyg = 66) b
       where p.pepais = b.pepais
         and p.petdoc = b.petdoc
         and p.pendoc = b.pendoc
         and p.cttfir = 'T';
  
    cursor Creditos(ln_NroCuenta number) is
      select q.pgcod  ln_pgcod,
             q.aomod  ln_modulo,
             q.aosuc  ln_sucursal,
             q.aomda  ln_moneda,
             q.aopap  ln_papel,
             q.aocta  ln_cuenta,
             q.aooper ln_operacion,
             q.aosbop ln_suboper,
             q.aotope ln_tipoper
        from fsd010 q
       where q.pgcod = 1
         and q.aocta = ln_NroCuenta
         and q.aomod in
             (select modulo
                from fst111
               where dscod = 50
                 and modulo not in (106, 107, 108, 109)) -- Excluye Consumo 106,109 Convenio 107 Prendario 108
         and q.aostat <> 99;
  
    ld_FchSist     date;
    ln_meses       number;
    ld_MesVerifica date;
    lc_VerifExcp   varchar2(2);
    ln_SaldoAux1   number := 0;
    ln_SaldoAux    number := 0;
    ln_Saldo       number := 0;
  
  begin
  
    begin
      -- Fecha del sistema
      select pgfape into ld_FchSist from fst017 where pgcod = 1;
    end;
  
    begin
      -- Nro de Meses
      select tp1nro3
        into ln_meses
        from FST198
       Where Tp1cod = 1
         and Tp1cod1 = 10871
         and Tp1corr1 = 7
         and tp1corr2 = 100
         and tp1corr3 = 1;
    Exception
      when others then
        null;
      
    end;
  
    while ln_meses > 0 loop
      ld_MesVerifica := last_day(ADD_MONTHS(ld_FchSist, - (ln_meses)));
      ln_SaldoAux    := 0;
      ln_SaldoAux1   := 0;
    
      for n in NroCuentas loop
      
        for c in Creditos(n.ctnro) loop
        
          PQ_CR_MAXSALDOHISTORICO.sp_cr_VerificaExcepciones(c.ln_pgcod,
                                                            c.ln_modulo,
                                                            c.ln_sucursal,
                                                            c.ln_moneda,
                                                            c.ln_papel,
                                                            c.ln_cuenta,
                                                            c.ln_operacion,
                                                            c.ln_suboper,
                                                            c.ln_tipoper,
                                                            lc_VerifExcp);
        
          if lc_VerifExcp = 'S' then
            begin
            
              select f.bcsdmn * -1
                into ln_SaldoAux1
                from fsh012 f
               where f.bcemp = c.ln_pgcod
                 and f.bcsuc = c.ln_sucursal
                 and (substr(f.bcrubr, 1, 4) in
                     (1411, 1413, 1414, 1415, 1416, 1421, 1423, 1424, 1425, 1426, 7111, 7112, 7113, 7114, 7121, 7122, 7123, 7124))
                 and f.bcmda = c.ln_moneda
                 and f.bcpap = c.ln_papel
                 and f.bccta = c.ln_cuenta
                 and f.bcoper = c.ln_operacion
                 and f.bcsbop = c.ln_suboper
                 and f.bctop = c.ln_tipoper
                 and f.bcfech = ld_MesVerifica;
            exception
              when others then
                ln_SaldoAux1 := 0;
            end;
          end if;
          ln_SaldoAux := ln_SaldoAux + ln_SaldoAux1;
        end loop;
      
      end loop;
      ln_meses := ln_meses - 1;
    
      if ln_SaldoAux > ln_Saldo then
        ln_Saldo := ln_SaldoAux;
      end if;
    
    end loop;
    ln_MaxSaldHist := ln_Saldo /*/ 2*/
     ;
  
  end sp_cr_inicio;
  --------------------------------------------------------------------
  procedure sp_cr_VerificaExcepciones(ln_pgcod     in number,
                                      ln_modulo    in number,
                                      ln_sucursal  in number,
                                      ln_moneda    in number,
                                      ln_papel     in number,
                                      ln_cuenta    in number,
                                      ln_operac    in number,
                                      ln_suboper   in number,
                                      ln_tipoper   in number,
                                      lc_VerifExcp out Varchar2) is
  
    FlgIncl      varchar2(2);
    ln_modul117  number;
    ln_cta117    number;
    ln_oper117   number;
    ln_sboper117 number;
    ln_sucur117  number;
    ln_mda117    number;
    ln_tipoer117 number;
  
  begin
  
    begin
    
      if ln_modulo = 116 then
      
        begin
        
          select f.r2mod,
                 f.r2cta,
                 f.r2oper,
                 f.r2sbop,
                 f.r2suc,
                 f.r2mda,
                 f.r2tope
            into ln_modul117,
                 ln_cta117,
                 ln_oper117,
                 ln_sboper117,
                 ln_sucur117,
                 ln_mda117,
                 ln_tipoer117
            from fsr011 f
           where f.r1cod = ln_pgcod
             and f.r1mod = ln_modulo
             and f.r1suc = ln_sucursal
             and f.r1mda = ln_moneda
             and f.r1pap = ln_papel
             and f.r1cta = ln_cuenta
             and f.r1oper = ln_operac
             and f.r1sbop = ln_suboper
             and f.r1tope = ln_tipoper
             and f.relcod = 46;
        
        end;
      
        begin
          Select 'N'
            into FlgIncl
            from fsr011 a, fsr011 b
           where a.relcod = 50
             and a.r1cod = ln_pgcod
             and a.r1mod = ln_modul117
             and a.r1suc = ln_sucur117
             and a.r1mda = ln_mda117
             and a.r1pap = 0
             and a.r1cta = ln_cta117
             and a.r1oper = ln_oper117
             and a.r1sbop = ln_sboper117
             and a.r1tope = ln_tipoer117
             and b.r2cta = a.r2cta
             and b.r2oper = a.r2oper
             and b.r2sbop = a.r2sbop
             and b.relcod in (2, 25)
             and a.r011co = 'S'
             and b.r011co = 'S'
             and rownum = 1;
        exception
          when no_data_found then
            -- ln_rcta := 0;
            FlgIncl := 'S';
          
        end;
      
      else
        if ln_modulo <> 116 then
        
          begin
            --créditos con garantía de plazo fijo o cts
          
            Select 'N'
              into FlgIncl
              from fsr011 a, fsr011 b
             where a.relcod = 50
               and a.r1cod = ln_pgcod
               and a.r1mod = ln_modulo
               and a.r1suc = ln_sucursal
               and a.r1mda = ln_moneda
               and a.r1pap = ln_papel
               and a.r1cta = ln_cuenta
               and a.r1oper = ln_operac
               and a.r1sbop = ln_suboper
               and a.r1tope = ln_tipoper
               and b.r2cta = a.r2cta
               and b.r2oper = a.r2oper
               and b.r2sbop = a.r2sbop
               and b.relcod in (2, 25)
               and a.r011co = 'S'
               and b.r011co = 'S'
               and rownum = 1;
          exception
            when no_data_found then
              -- ln_rcta := 0;
              FlgIncl := 'S';
          end;
        End If;
      
      end if;
    
    end;
  
    if FlgIncl = 'N' /*or ln_NRO_CUOTAS < 2*/
     then
      lc_VerifExcp := 'N';
    
    else
      lc_VerifExcp := 'S';
    end if;
  
  end sp_cr_VerificaExcepciones;
  --------------------------------------------------------------------  
end PQ_CR_MAXSALDOHISTORICO;
/

