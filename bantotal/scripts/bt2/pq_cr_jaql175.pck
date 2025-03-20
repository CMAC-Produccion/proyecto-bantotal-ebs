create or replace package PQ_CR_JAQL175 is

  -- Author  : DCASTRO
  -- Created : 05/07/2021 
  -- Purpose : 

----------------------------------------------------
  procedure sp_saldo_credito(pn_pgcod   in number, 
                             pn_cta     in number,
                             pn_mon     in number,
                             pn_pap     in number, 
                             pn_ope     in number,
                             pn_sope    in number,                                                           
                             pn_mod     in number,
                             pn_stat    in number,                             
                             ln_capital out number,
                             ln_Interes out number,
                             ln_Mora    out number,
                             ln_Honpro  out number,
                             ln_Gastos  out number,
                             ln_Total   out number);
----------------------------------------------------
  procedure sp_Rubros_guia(pn_Pgcod  in number,
                           pn_moneda in number,
                           ln_RelInt out number,
                           ln_RubMor out number,
                           ln_RubGas out number);

----------------------------------------------------
  procedure sp_Interes_devengado(pn_Rubro    in number,
                                 pn_Relacion in number,
                                 pn_pgcod    in number, 
                                 pn_cta      in number,
                                 pn_ope      in number,
                                 pn_sope     in number,
                                 ln_Interes  out number);
----------------------------------------------------
  procedure sp_Busca_Rubro(pn_Rubro    in number,
                           pn_Relacion in number,
                           ln_RubCon out number);
                                 
----------------------------------------------------
  procedure sp_Mora(pn_pgcod  in number, 
                    pn_cta    in number,
                    pn_ope    in number,
                    pn_sope   in number,
                    pn_RubMor in number,
                    ln_Mora   out number);

----------------------------------------------------
  procedure sp_Gastos(pn_pgcod   in number, 
                      pn_cta     in number,
                      pn_ope     in number,
                      pn_sope    in number,
                      pn_RubGas  in number,                    
                      ln_Gastos  out number);

----------------------------------------------------


----------------------------------------------------
end PQ_CR_JAQL175;
/

create or replace package body PQ_CR_JAQL175 is
  procedure sp_saldo_credito(pn_pgcod   in number, 
                             pn_cta     in number,
                             pn_mon     in number,
                             pn_pap     in number, 
                             pn_ope     in number,
                             pn_sope    in number,                                                           
                             pn_mod     in number,
                             pn_stat    in number,                             
                             ln_capital out number,
                             ln_Interes out number,
                             ln_Mora    out number,
                             ln_Honpro  out number,
                             ln_Gastos  out number,
                             ln_Total   out number) is
  ln_Rubro   number(16);
  
  ln_RelInt  number(3);
  ln_RubMor  number(16);
  ln_RubGas  number(16);
  
  begin
    ln_Honpro := 0;
    PQ_CR_JAQL175.sp_Rubros_guia(pn_pgcod, 
                                 pn_mon,
                                 ln_RelInt,
                                 ln_RubMor,
                                 ln_RubGas); 
    
    begin
      select Scsdo * -1, Scrub
      into ln_capital, ln_Rubro
      from FSD011 b 
      where b.Pgcod = pn_pgcod
      and b.Sccta   = pn_cta
      and b.Scmda   = pn_mon
      and b.Scpap   = pn_pap
      and b.Scoper  = pn_ope
      and b.Scsbop  = pn_sope
      and b.Scmod   = pn_mod
      and b.Scstat  = pn_stat;
    exception when others then
      --null;
      ln_capital := 0;
      ln_Rubro := 0000000000000000;
    end;
    
    PQ_CR_JAQL175.sp_Interes_devengado(ln_Rubro,
                                       ln_RelInt,
                                       pn_pgcod,
                                       pn_cta,
                                       pn_ope,
                                       pn_sope,
                                       ln_Interes);
                                       
    PQ_CR_JAQL175.sp_Mora(pn_pgcod,
                          pn_cta,
                          pn_ope,
                          pn_sope,
                          ln_RubMor,
                          ln_Mora);
                          
    PQ_CR_JAQL175.sp_Gastos(pn_pgcod,
                            pn_cta,
                            pn_ope,
                            pn_sope,
                            ln_RubGas,
                            ln_Gastos);
                            
    ln_Total := ln_capital + ln_Interes + ln_Mora + ln_Honpro + ln_Gastos;
                                          
  end sp_saldo_credito;

-------------------------------------------------------------------
  procedure sp_Rubros_guia(pn_Pgcod  in number,
                           pn_moneda in number,
                           ln_RelInt out number,
                           ln_RubMor out number,
                           ln_RubGas out number) is
  
  CURSOR LST_RUBROS (n_Pgcod IN NUMBER, n_Tp1cod1 IN NUMBER) IS
    SELECT Tp1nro1, Tp1corr2, Tp1corr3,  Tp1desc
    FROM FST198 A
    Where A.Tp1cod = n_Pgcod
    AND A.Tp1cod1  = n_Tp1cod1
    AND A.Tp1corr1 = 3;

  ln_Tp1cod1 number(9);
  begin
    ln_Tp1cod1 := 10850;
    FOR i IN LST_RUBROS(pn_Pgcod, ln_Tp1cod1) LOOP
      begin
        if i.Tp1corr2 = 1 and i.Tp1corr3 = 4 then 
          ln_RelInt := i.Tp1nro1; --Rel.Interés
        elsif i.Tp1corr2 = 2 then 
          if i.Tp1corr3 = pn_moneda then             
            ln_RubMor := to_number(Trim(i.Tp1desc)); --Rubro Mora            
          end if;
        elsif i.Tp1corr2 = 3 then 
          If i.Tp1corr3 = pn_moneda then
            ln_RubGas := to_number(Trim(i.Tp1desc)); --Rubro Gastos
          End If;
        end if;
      exception when others then
        null;
      end;
    END LOOP;
  end sp_Rubros_guia;
 
-------------------------------------------------------------------
  procedure sp_Interes_devengado(pn_Rubro    in number,
                                 pn_Relacion in number,
                                 pn_pgcod    in number, 
                                 pn_cta      in number,
                                 pn_ope      in number,
                                 pn_sope     in number,
                                 ln_Interes  out number) is
  ln_RubCon number(16);
  
  begin
    begin 
      sp_Busca_Rubro(pn_Rubro, pn_Relacion, ln_RubCon);
    exception when others then
      null;
    end;
    
    begin
      select Scsdo * -1
        into ln_Interes
      from  FSD011 d
      Where d.Pgcod  = pn_pgcod
        and d.Scrub  = ln_RubCon
        and d.Sccta  = pn_cta
        and d.Scoper = pn_ope
        and d.Scsbop = pn_sope;
    exception when others then
      ln_Interes := 0;
      --null;
    end;
  end sp_Interes_devengado; 
  
-------------------------------------------------------------------
  procedure sp_Busca_Rubro(pn_Rubro    in number,
                           pn_Relacion in number,
                           ln_RubCon out number) is
  begin
    begin
      select c.Rrrubr
        into ln_RubCon
      from FSR014 c
      Where c.Rubro = pn_Rubro
      and c.Rrcod = pn_Relacion; 
      
    exception when others then
      ln_RubCon := 0000000000000000;
    end;
  end sp_Busca_Rubro;
  
-------------------------------------------------------------------  
  procedure sp_Mora(pn_pgcod  in number, 
                    pn_cta    in number,
                    pn_ope    in number,
                    pn_sope   in number,
                    pn_RubMor in number,
                    ln_Mora   out number) is
  begin
    begin
      
      select Scsdo * -1
        into ln_Mora
      from FSD011 e
      Where e.Pgcod =  pn_pgcod
      and e.Scrub   =  pn_RubMor 
      and e.Sccta   =  pn_cta
      and e.Scoper  =  pn_ope
      and e.Scsbop  =  pn_sope;
      
    exception when others then
      ln_Mora := 0;
    end;
  end sp_Mora; 
  
-------------------------------------------------------------------  
  procedure sp_Gastos(pn_pgcod   in number, 
                      pn_cta     in number,
                      pn_ope     in number,
                      pn_sope    in number,
                      pn_RubGas  in number,                    
                      ln_Gastos  out number) is
  begin
    begin
      select Scsdo * -1
        into ln_Gastos
      from FSD011 f
      Where f.Pgcod = pn_pgcod
      and f.Scrub   = pn_RubGas
      and f.Sccta   = pn_cta
      and f.Scoper  = pn_ope
      and f.Scsbop  = pn_sope;
    
    exception when others then
      ln_Gastos := 0;
    end;
  end sp_Gastos; 
  

end PQ_CR_JAQL175;
/

