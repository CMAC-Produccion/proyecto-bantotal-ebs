create or replace package PQ_AH_CCI is

  -- Author  : MARAUJO
  -- Created : 10/08/2009 09:45:49 a.m.
  -- Purpose : Manejo c?digo de cuenta interbancario
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure SP_AH_CCI(Banco      number,
                      vScsuc     number,
                      vSccta     number,
                      vScsbop    number,
                      P_C_NUMCCI out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function FN_AH_MODULO10(P_C_CODIGO VARCHAR2, P_C_FACTOR VARCHAR2)
    return NUMBER;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_ah_valida_cci(P_C_CODCCI in varchar2) return boolean;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_ah_valida_cci(P_C_CODCCI varchar2, VALIDO out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --      
  procedure sp_ah_retorn_numcta(P_C_CODCCI in varchar2,
                                CUENTA     out varchar2);

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                     
  procedure sp_tarifario(vBanco  number,
                         vCofech date,
                         vTiper  number,
                         vComda  number,
                         vComto  number,
                         Tiptar  OUT varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                     
  procedure sp_comision(vPgCod   number,
                        vComod   number,
                        vCocod   number,
                        vCocta   number,
                        vCopap   number,
                        vComda   number,
                        vCofech  date,
                        vComto   number,
                        vCopzo   number,
                        vconver  number,
                        Comision OUT number);

  Function FN_AH_CCI(Banco   number,
                     vScsuc  number,
                     vSccta  number,
                     vScsbop number) return varchar2;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure SP_CR_CCI(Banco      number,
                      vScsuc     number,
                      vSccta     number,
                      vScoper   number,
                      P_C_CREDCCI out varchar2);
  
end PQ_AH_CCI;
/

create or replace package body PQ_AH_CCI is

  procedure SP_AH_CCI(Banco      number,
                      vScsuc     number,
                      vSccta     number,
                      vScsbop    number,
                      P_C_NUMCCI out varchar2) is
  
    lc_conins char(3);
    lvScsuc   number;
    lc_codage char(3);
    lc_extcta char(12);
    lc_dgenof char(1);
    lc_dgnuct char(1);
  
    ln_resp number;
  
  BEGIN
  
    lc_conins := lpad(to_char(Banco), 3, '0');
  
    begin
      select Tpcorr
        into lvScsuc
        from fst098
       Where PgCod = 1
         and Tpcod = 25000
         and Tpnro = vScsuc;
    exception
      when others then
        lvScsuc := vScsuc;
    end;
  
    lc_codage := lpad(to_char(lvScsuc), 3, '0');
    lc_extcta := lpad(to_char(vSccta), 9, '0') ||
                 lpad(to_char(vScsbop), 3, '0');
  
    lc_dgenof := to_char(fn_ah_modulo10(p_c_codigo => lc_conins || lc_codage,
                                        p_c_factor => '121212'));
  
    lc_dgnuct := to_char(fn_ah_modulo10(p_c_codigo => lc_extcta,
                                        p_c_factor => '121212121212'));
  
    P_C_NUMCCI := lc_conins || lc_codage || lc_extcta || lc_dgenof ||
                  lc_dgnuct;
  
    ln_resp := 0;
    select count(*)
      into ln_resp
      from fsd011
     where PGCOD = 1
       and SCMOD = 21
       and SCCTA = vSCCTA
       and SCSBOP = vSCSBOP;
  
    if ln_resp = 0 then
      P_C_NUMCCI := '';
    end if;
  
  END;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function FN_AH_MODULO10(P_C_CODIGO VARCHAR2, P_C_FACTOR VARCHAR2)
    return number IS
  
    lc_factor varchar2(50);
    lc_codigo varchar2(50);
    ln_digito number(2);
    --
    ln_long number;
    lc_suma varchar2(50);
    ln_suma number;
    ln_pos  number;
  
  BEGIN
  
    lc_factor := P_C_FACTOR;
    lc_codigo := P_C_CODIGO;
    --
    ln_long := length(lc_codigo);
    ln_pos  := 0;
    for i in 1 .. ln_long loop
      ln_pos  := ln_pos + 1;
      lc_suma := lc_suma ||
                 TO_CHAR((substr(lc_codigo, ln_pos, 1)) *
                         (substr(lc_factor, ln_pos, 1)));
    end loop;
  
    --
    ln_long := length(lc_suma);
    ln_suma := 0;
    ln_pos  := 0;
  
    for i in 1 .. ln_long loop
      ln_pos  := ln_pos + 1;
      ln_suma := ln_suma + to_number(substr(lc_suma, ln_pos, 1));
    end loop;
  
    -- M?dulo 10 de la Sumatoria.
    ln_digito := mod(ln_suma, 10);
  
    if ln_digito > 0 then
      ln_digito := 10 - ln_digito;
      --
      if ln_digito >= 10 then
        ln_digito := 0;
      end if;
    else
      ln_digito := 0;
    end if;
  
    return(ln_digito);
  
  end FN_AH_MODULO10;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  function fn_ah_valida_cci(P_C_CODCCI in varchar2) return boolean is
  
    lc_dgenof char(1);
    lc_dgnuct char(1);
    lc_insofi char(6);
    lc_nrocta char(12);
    lc_digcom char(2);
  begin
  
    if length(P_C_CODCCI) != 20 then
      return false;
    end if;
  
    lc_insofi := substr(P_C_CODCCI, 1, 6);
    lc_nrocta := substr(P_C_CODCCI, 7, 12);
    lc_digcom := substr(P_C_CODCCI, 19, 2);
  
    lc_dgenof := to_char(fn_ah_modulo10(p_c_codigo => lc_insofi,
                                        p_c_factor => '121212'));
  
    lc_dgnuct := to_char(fn_ah_modulo10(p_c_codigo => lc_nrocta,
                                        p_c_factor => '121212121212'));
  
    if (lc_digcom != (lc_dgenof || lc_dgnuct)) then
      return false;
    end if;
  
    return true;
  
  end fn_ah_valida_cci;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  

  procedure sp_ah_valida_cci(P_C_CODCCI varchar2, VALIDO out varchar2) is
  begin
    if pq_ah_cci.fn_ah_valida_cci(P_C_CODCCI) then
      VALIDO := 'S';
    else
      VALIDO := 'N';
    end if;
  exception
    when others then
      VALIDO := 'N';
  end sp_ah_valida_cci;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  

  procedure sp_ah_retorn_numcta(P_C_CODCCI in varchar2,
                                CUENTA     out varchar2) is
  
    ln_resp number;
    vSCMOD  number;
    vSCTOPE number;
    vSCMDA  number;
    vSCPAP  number;
    vSCCTA  number;
    vSCOPER number;
    vSCSBOP number;
  begin
  
    if P_C_CODCCI is null or length(P_C_CODCCI) != 20 then
      CUENTA := '';
      return;
    end if;
  
    if not pq_ah_cci.fn_ah_valida_cci(P_C_CODCCI) then
      CUENTA := '';
      return;
    end if;
  
    begin
      select lpad(b.bnj096cta, 9, '0') || lpad(b.bnj096mod, 3, '0') ||
             lpad(b.bnj096mda, 3, '0') || lpad(b.bnj096sub, 2, '0') ||
             lpad(b.bnj096top, 3, '0'),
             bnj096mod,
             bnj096top,
             bnj096mda,
             bnj096pap,
             bnj096cta,
             bnj096ope,
             bnj096sub
        into CUENTA,
             vSCMOD,
             vSCTOPE,
             vSCMDA,
             vSCPAP,
             vSCCTA,
             vSCOPER,
             vSCSBOP
        from bnj096 b
       where b.bnj096cci = P_C_CODCCI;
    exception
      when others then
      
        vSCMOD  := 21;
        vSCCTA  := substr(P_C_CODCCI, 7, 9);
        vSCSBOP := substr(P_C_CODCCI, 16, 3);
      
        begin
          select lpad(sccta, 9, '0') || lpad(scmod, 3, '0') ||
                 lpad(scmda, 3, '0') || lpad(scsbop, 2, '0') ||
                 lpad(sctope, 3, '0'),
                 sctope,
                 scmda,
                 scpap,
                 scoper
            into CUENTA, vSCTOPE, vSCMDA, vSCPAP, vSCOPER
            from fsd011
           where PGCOD = 1
             and SCMOD = vSCMOD
             and SCCTA = vSCCTA
             and SCSBOP = vSCSBOP;
        exception
          when others then
            CUENTA := '';
            return;
        end;
    end;
  
    ln_resp := 0;
  
    select count(*)
      into ln_resp
      from fsd011
     where PGCOD = 1
       and SCMOD = vSCMOD
       and SCTOPE = vSCTOPE
       and SCMDA = vSCMDA
       and SCPAP = vSCPAP
       and SCCTA = vSCCTA
       and SCOPER = vSCOPER
       and SCSBOP = vSCSBOP;
  
    if ln_resp = 0 then
      CUENTA := '';
    end if;
  
  end sp_ah_retorn_numcta;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    

  procedure sp_tarifario(vBanco  number,
                         vCofech date,
                         vTiper  number,
                         vComda  number,
                         vComto  number,
                         Tiptar  OUT varchar2) is
  
  begin
    select jaql705tita
      into Tiptar
      from (select trim(jaql705tita) jaql705tita
              from jaql705
             where jaql705banc = vBanco
               and jaql705fein <= vCofech
               and case
                     when vTiper = 1 then
                      jaql705au01
                     else
                      jaql705au02
                   end = 'S'
               and case
                     when vComda = 0 then
                      jaql705au04
                     else
                      jaql705au05
                   end = vComda
               and case
                     when vComda = 0 then
                      jaql705au07
                     else
                      jaql705au08
                   end >= vComto
             order by jaql705fein desc, jaql705au07)
     where rownum = 1;
  
  exception
    when no_data_found then
      begin
        select trim(tp1desc)
          into Tiptar
          from FST198
         Where Tp1cod = 1
           and Tp1cod1 = 10885
           and Tp1corr1 = 2
           and Tp1corr2 = 1
           and Tp1corr3 = 4;
      exception
        when no_data_found then
          Tiptar := 0;
      end;
    
  end;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  

  procedure sp_comision(vPgCod   number,
                        vComod   number,
                        vCocod   number,
                        vCocta   number,
                        vCopap   number,
                        vComda   number,
                        vCofech  date,
                        vComto   number,
                        vCopzo   number,
                        vconver  number,
                        Comision OUT number) is
  
    vCoimpP  number;
    vCotasaP number;
    vCominP  number;
    vComaxP  number;
    vmoneda  number;
    vtipoc number;
  
  begin
    If vconver = 1 then
       vmoneda := 0;
    else
       vmoneda := vComda;
    end if;
    
    begin
      select *
        into vCoimpP, vCotasaP, vCominP, vComaxP
        from (select CoimpP, CotasaP, CominP, ComaxP
                from fsp026
               Where PgCod = vPgcod
                 and Comod = vComod
                 and Cocod = vCocod
                 and Cocta = vCocta
                 and Copap = vCopap
                 and Comda = vmoneda
                 and Cofech <= vCofech
                 and Comto >= vComto
                 and Copzo >= vCopzo
               order by Cofech desc, Comto, Copzo)
       where rownum = 1;
    exception
      when others then
        Comision := 0;
        return;
    end;
  
    Comision := nvl(vCoimpP, 0) +
                (nvl(vComto, 0) * (nvl(vCotasaP, 0) / 100));
  
    Comision := round(Comision, 2);
  
    If Comision < vCominP then
      Comision := vCominP;
    End If;
  
    If Comision > vComaxP then
      Comision := vComaxP;
    End If;
    
    If vconver = 1 then
      vtipoc := fn_tipo_cambio(vCofech,vmoneda,vComda, 500);
      Comision := Comision/vtipoc;
    End If;
  
    /*    If vCoimpP > 0 then
      Comision := vCoimpP;
    Else
      Comision := vComto * (vCotasaP / 100);
    
      If Comision < vCominP then
        Comision := vCominP;
      End If;
    
      If Comision > vComaxP then
        Comision := vComaxP;
      End If;
    End If;*/
  end sp_comision;

  ------------------------------

  Function FN_AH_CCI(Banco   number,
                     vScsuc  number,
                     vSccta  number,
                     vScsbop number) return varchar2 is
  
    P_C_NUMCCI varchar2(20);
  
  begin
    SP_AH_CCI(Banco, vScsuc, vSccta, vScsbop, P_C_NUMCCI);
    return P_C_NUMCCI;
  end;
---------------------------------------------------------------------------------
procedure SP_CR_CCI(Banco      number,
                    vScsuc     number,
                    vSccta     number,
                    vScoper    number,
                    P_C_CREDCCI out varchar2) is
  
    lc_conins char(3);
    lvScsuc   number;
    lc_codage char(3);
    lc_opecred char(9);
    lc_dgenof char(1);
    lc_dgnuct char(1);
    lc_codcci char(3);
  
    ln_resp number;
  
  BEGIN
  
    lc_conins := lpad(to_char(Banco), 3, '0');
    --valor 901 : identificador cci de credito
    lc_codcci := '901';
    
    begin
      select Tpcorr
        into lvScsuc
        from fst098
       Where PgCod = 1
         and Tpcod = 25000
         and Tpnro = vScsuc;
    exception
      when others then
        lvScsuc := vScsuc;
    end;
  
    lc_codage := lpad(to_char(lvScsuc), 3, '0');
    lc_opecred := lpad(to_char(vScoper), 9, '0');
  
    lc_dgenof := to_char(fn_ah_modulo10(p_c_codigo => lc_conins || lc_codage,
                                        p_c_factor => '121212'));
  
    lc_dgnuct := to_char(fn_ah_modulo10(p_c_codigo => lc_codcci || lc_opecred,
                                        p_c_factor => '121212121212'));
  
    P_C_CREDCCI := lc_conins || lc_codage || lc_codcci || lc_opecred || lc_dgenof || lc_dgnuct;
  
    ln_resp := 0;
    
    select count(*)
      into ln_resp
      from fsd011
     where PGCOD = 1
       and SCCTA = vSCCTA
       and SCOPER = vScoper
       and SCPAP = 0
       and SCSTAT <> 99;
       
  
    if ln_resp = 0 then
      P_C_CREDCCI := '';
    end if;
  
  END;


end PQ_AH_CCI;
/

