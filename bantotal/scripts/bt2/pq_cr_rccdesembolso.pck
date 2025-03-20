create or replace package PQ_CR_RCCDESEMBOLSO is

  -- Author  : MPOSTIGOC
  -- Created : 21/11/2018 10:42:13 a. m.
  -- Purpose : 

  -- Public type declarations

  procedure sp_cr_DeudaRCCDesemb(ln_Instancia      in number,
                                 ln_DeudaRCCDesemb out number);
  -------------------------------------------------------                                 
  procedure sp_cr_DeudaRCCActual(ln_Instancia   in number,
                                 ln_DeudaRCCAct out number);
  ---------------------------------------------------
  procedure sp_cr_CompFchEvalu(ln_Instancia in number,
                               lc_EvaluDife out varchar2);

end PQ_CR_RCCDESEMBOLSO;
/

create or replace package body PQ_CR_RCCDESEMBOLSO is

  procedure sp_cr_DeudaRCCDesemb(ln_Instancia      in number,
                                 ln_DeudaRCCDesemb out number) is
  
    cursor Lista_CredRCC(ln_CodSBS varchar2, ld_FchRCCDesemb date) is
    
      select s.n_salcap ln_DeudaRCCDesemb, s.c_cuenta ln_RubroRCC
        from cldrccs s
       where s.c_codsbs = ln_CodSBS
         and s.d_fecpre = ld_FchRCCDesemb;
  
    ln_pais             number;
    ln_tdoc             number;
    lc_ndoc             varchar2(12);
    ld_FchUltCredDesemb date;
    ld_FchRCCDesemb     date;
    ln_CodSBS           varchar2(10);
    lc_subcuenta        varchar2(10);
    lc_subcuenta2       varchar2(10);
    lc_subcuenta3       varchar2(10);
  
  begin
  
    ln_DeudaRCCDesemb := 0;
  
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_pais, ln_tdoc, lc_ndoc
        from sng001 s
       where s.sng001inst = ln_Instancia;
    exception
      when others then
        null;
    end;
  
    begin
    
      select max(g.AOFVAL)
        into ld_FchUltCredDesemb
        from fsd010 g
       where g.PGCOD = 1
         and g.AOMOD in (select modulo
                           from fst111
                          where dscod = 50
                            and modulo not in (108, 116, 141))
         and g.AOMDA in (0, 101)
         and g.AOPAP = 0
         and g.AOCTA in (select ctnro
                           from fsr008 f
                          where f.pgcod = 1
                            and f.pepais = ln_pais
                            and f.petdoc = ln_tdoc
                            and f.pendoc = lc_ndoc
                            and f.cttfir = 'T');
    exception
      when others then
        null;
    end;
  
    if ld_FchUltCredDesemb is not null then
    
      begin
        -- A solictud de Jorge Yañez, se pide cambiar la fecha del RCC mas 2 meses
        -- 28/05/2019 MPOSTIGOC
        SELECT add_months(LAST_DAY(ld_FchUltCredDesemb), +2)
          into ld_FchRCCDesemb
          FROM DUAL;
      end;
    
      if ln_tdoc <> 9 then
      
        begin
          select c.c_codsbs
            into ln_CodSBS
            from cldrcci c
           where c.c_docide = trim(lc_ndoc)
             and c.d_fecpre = ld_FchRCCDesemb;
        exception
          when others then
            null;
        end;
      
      else
        if ln_tdoc = 9 then
          begin
            select c.c_codsbs
              into ln_CodSBS
              from cldrcci c
             where c.c_doctri = trim(lc_ndoc)
               and c.d_fecpre = ld_FchRCCDesemb;
          exception
            when others then
              null;
          end;
        
        end if;
      
      end if;
    
      if ln_CodSBS is null then
      
        begin
          select last_day(add_months(ld_FchUltCredDesemb, -1))
            into ld_FchRCCDesemb
            from dual;
        end;
      
        begin
          select c.c_codsbs
            into ln_CodSBS
            from cldrcci c
           where c.c_docide = trim(lc_ndoc)
             and c.d_fecpre = ld_FchRCCDesemb;
        exception
          when others then
            null;
        end;
      
      end if;
    
      if ln_CodSBS is not null then
      
        for l in Lista_CredRCC(ln_CodSBS, ld_FchRCCDesemb) loop
        
          lc_subcuenta  := SUBSTR(l.ln_rubrorcc, 1, 4);
          lc_subcuenta2 := SUBSTR(l.ln_rubrorcc, 1, 6);
          lc_subcuenta3 := SUBSTR(l.ln_rubrorcc, 7, 2);
        
          If (lc_subcuenta = '1411') Or (lc_subcuenta = '1413') Or
             (lc_subcuenta = '1414') Or (lc_subcuenta = '1415') Or
             (lc_subcuenta = '1416') Or (lc_subcuenta = '1421') Or
             (lc_subcuenta = '1423') Or (lc_subcuenta = '1424') Or
             (lc_subcuenta = '1425') Or (lc_subcuenta = '1426') Or
             (lc_subcuenta = '8113') Or (lc_subcuenta = '8123') Or
             (lc_subcuenta = '7112') Or (lc_subcuenta = '7122') OR
             (lc_subcuenta2 = '811302') Or (lc_subcuenta2 = '812302') then
          
            ln_DeudaRCCDesemb := ln_DeudaRCCDesemb + l.ln_deudarccdesemb;
          
          end if;
        end loop;
      
        ln_DeudaRCCDesemb := nvl(ln_DeudaRCCDesemb, 0);
      
      else
        ln_DeudaRCCDesemb := 0;
      end if;
    else
      ln_DeudaRCCDesemb := 0;
    end if;
  end sp_cr_DeudaRCCDesemb;
  -----------------------------------------------------
  procedure sp_cr_DeudaRCCActual(ln_Instancia   in number,
                                 ln_DeudaRCCAct out number) is
  
    cursor Lista_CredRCC(ln_CodSBS varchar2, ld_FchRCCDesemb date) is
    
      select s.n_salcap ln_DeudaRCCAct, s.c_cuenta ln_RubroRCC
        from cldrccs s
       where s.c_codsbs = ln_CodSBS
         and s.d_fecpre = ld_FchRCCDesemb;
  
    ln_pais         number;
    ln_tdoc         number;
    lc_ndoc         varchar2(12);
    ld_FchRCCDesemb date;
    ln_CodSBS       varchar2(10);
    lc_subcuenta    varchar2(10);
    lc_subcuenta2   varchar2(10);
    lc_subcuenta3   varchar2(10);
    ld_FchRCC       date;
  
  begin
  
    ln_DeudaRCCAct := 0;
  
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_pais, ln_tdoc, lc_ndoc
        from sng001 s
       where s.sng001inst = ln_Instancia;
    exception
      when others then
        null;
    end;
  
    begin
      select to_date(Tpnro, 'DD/MM/YYYY')
        into ld_FchRCC
        from FST098
       Where Pgcod = 1
         and Tpcod = 7647
         and Tpcorr = 12;
    end;
  
    if ln_tdoc <> 9 then
    
      begin
        select c.c_codsbs
          into ln_CodSBS
          from cldrcci c
         where c.c_docide = trim(lc_ndoc)
           and c.d_fecpre = ld_FchRCC;
      exception
        when others then
          null;
      end;
    
    else
      if ln_tdoc = 9 then
        begin
          select c.c_codsbs
            into ln_CodSBS
            from cldrcci c
           where c.c_doctri = trim(lc_ndoc)
             and c.d_fecpre = ld_FchRCC;
        exception
          when others then
            null;
        end;
      
      end if;
    
    end if;
  
    if ln_CodSBS is not null then
    
      for l in Lista_CredRCC(ln_CodSBS, ld_FchRCC) loop
      
        lc_subcuenta  := SUBSTR(l.ln_rubrorcc, 1, 4);
        lc_subcuenta2 := SUBSTR(l.ln_rubrorcc, 1, 6);
        lc_subcuenta3 := SUBSTR(l.ln_rubrorcc, 7, 2);
      
        If (lc_subcuenta = '1411') Or (lc_subcuenta = '1413') Or
           (lc_subcuenta = '1414') Or (lc_subcuenta = '1415') Or
           (lc_subcuenta = '1416') Or (lc_subcuenta = '1421') Or
           (lc_subcuenta = '1423') Or (lc_subcuenta = '1424') Or
           (lc_subcuenta = '1425') Or (lc_subcuenta = '1426') Or
           (lc_subcuenta = '8113') Or (lc_subcuenta = '8123') Or
           (lc_subcuenta = '7112') Or (lc_subcuenta = '7122') OR
           (lc_subcuenta2 = '811302') Or (lc_subcuenta2 = '812302') then
        
          ln_DeudaRCCAct := ln_DeudaRCCAct + l.ln_DeudaRCCAct;
        
        end if;
      end loop;
    
      ln_DeudaRCCAct := nvl(ln_DeudaRCCAct, 0);
    
    else
      ln_DeudaRCCAct := 0;
    end if;
  
  end sp_cr_DeudaRCCActual;
  -------------------------------------------------------  
  procedure sp_cr_CompFchEvalu(ln_Instancia in number,
                               lc_EvaluDife out varchar2) is
  
    cursor lista_UltCredDeseb(ln_pais             number,
                              ln_tdoc             number,
                              lc_ndoc             varchar2,
                              ld_FchUltCredDesemb date) is
      select G.PGCOD  ln_pgcod,
             G.AOMOD  ln_modulo,
             G.AOSUC  ln_sucursal,
             G.AOMDA  ln_moneda,
             G.AOPAP  ln_papel,
             G.AOCTA  ln_cuenta,
             G.AOOPER ln_operacion,
             G.AOSBOP ln_suboper,
             G.AOTOPE ln_tipoper
        from fsd010 g
       where g.PGCOD = 1
         and (g.AOMOD in (select modulo
                            from fst111
                           where dscod = 50
                             and modulo not in (108, 116, 141)) or
             g.aomod = 117)
         and g.AOMDA in (0, 101)
         and g.AOPAP = 0
         and g.AOCTA in (select ctnro
                           from fsr008 f
                          where f.pgcod = 1
                            and f.pepais = ln_pais
                            and f.petdoc = ln_tdoc
                            and f.pendoc = lc_ndoc
                            and f.cttfir = 'T')
         and g.AOFVAL = ld_FchUltCredDesemb;
  
    ln_pais             number;
    ln_tdoc             number;
    lc_ndoc             varchar2(12);
    ld_FchUltCredDesemb date;
    ln_NroInst          number;
    ln_NroEvalAux       number := 0;
    ln_NroEval          number := 0;
    ld_FechEvalDesemb   date;
    ld_FchEvalVuelo     date;
    ln_NroInstAux       number;
    ld_FchFalsa         DATE;
  
  begin
  
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_pais, ln_tdoc, lc_ndoc
        from sng001 s
       where s.sng001inst = ln_Instancia;
    exception
      when others then
        null;
    end;
  
    begin
    
      select max(g.AOFVAL)
        into ld_FchUltCredDesemb
        from fsd010 g
       where g.PGCOD = 1
         and (g.AOMOD in (select modulo
                            from fst111
                           where dscod = 50
                             and modulo not in (108, 116, 141)) or
             g.aomod = 117)
         and g.AOMDA in (0, 101)
         and g.AOPAP = 0
         and g.AOCTA in (select ctnro
                           from fsr008 f
                          where f.pgcod = 1
                            and f.pepais = ln_pais
                            and f.petdoc = ln_tdoc
                            and f.pendoc = lc_ndoc
                            and f.cttfir = 'T');
    exception
      when others then
        null;
    end;
  
    for l in lista_UltCredDeseb(ln_pais,
                                ln_tdoc,
                                lc_ndoc,
                                ld_FchUltCredDesemb) loop
    
      ln_NroInstAux := fn_instancia_credito(v_Scmod  => l.ln_modulo,
                                            v_Scsuc  => l.ln_sucursal,
                                            v_Scmda  => l.ln_moneda,
                                            v_Scpap  => l.ln_papel,
                                            v_Sccta  => l.ln_cuenta,
                                            v_Scoper => l.ln_operacion,
                                            v_Scsbop => l.ln_suboper,
                                            v_Sctope => l.ln_tipoper);
      begin
        select s.sng021eval
          into ln_NroEvalAux
          from sng021 s
         where s.sng021sol = ln_NroInstAux;
      exception
        when others then
          null;
      end;
    
      if ln_NroEval < ln_NroEvalAux then
        ln_NroEval := ln_NroEvalAux;
        ln_NroInst := ln_NroInstAux;
      end if;
    
    end loop;
  
    begin
      select s.sng120fpag
        into ld_FechEvalDesemb
        from sng120 s
       where s.sng120ins = ln_NroInst
         and s.sng120tsk = 'EVALUACION';
    exception
      when others then
        null;
    end;
  
    if ld_FechEvalDesemb is null then
      -- MPOSTIGOC 22.07.2020
      begin
        select s.sng021fec
          into ld_FechEvalDesemb
          from SNG021 s
         where s.sng021sol = ln_NroInst;
      exception
        when others then
          null;
      end;
    
    end if;
  
    begin
      select s.sng120fpag
        into ld_FchEvalVuelo
        from sng120 s
       where s.sng120ins = ln_Instancia
         and s.sng120tsk = 'EVALUACION';
    exception
      when others then
        null;
      
    end;
  
    ld_FchFalsa := to_date('01/01/1900', 'DD/MM/YYYY');
  
    if (ld_FechEvalDesemb > ld_FchFalsa) and
       (ld_FchEvalVuelo <> ld_FchFalsa) then
    
      if ld_FechEvalDesemb <> ld_FchEvalVuelo then
        lc_EvaluDife := 'S';
      else
        lc_EvaluDife := 'N';
      end if;
    else
      lc_EvaluDife := 'S'; -- MPOSTIGOC 22.07.2020
    end if;
  
  end sp_cr_CompFchEvalu;
  -----------------------------------------------------
end PQ_CR_RCCDESEMBOLSO;
/

