create or replace package PQ_CR_CAPITALTRABAJO is

  -- Author  : MPOSTIGOC
  -- Created : 7/03/2019 9:17:56 a. m.
  -- Purpose : 

  procedure sp_cr_MontMaxCapTrabVig(ln_Instancia      in number,
                                    ln_MontMaxCapTrab out number);

end PQ_CR_CAPITALTRABAJO;
/

create or replace package body PQ_CR_CAPITALTRABAJO is

  procedure sp_cr_MontMaxCapTrabVig(ln_Instancia      in number,
                                    ln_MontMaxCapTrab out number) is
  
    cursor lista_CredCapTrab(ln_pais   number,
                             ln_tdoc   number,
                             lc_numdoc varchar2) is
      select F.PGCOD  ln_pgcod,
             F.AOMOD  ln_mod,
             F.AOSUC  ln_suc,
             F.AOMDA  ln_mda,
             F.AOPAP  ln_pap,
             F.AOCTA  ln_cuenta,
             F.AOOPER ln_operacion,
             F.AOSBOP ln_suboper,
             F.AOTOPE ln_tope,
             F.AOFVAL ln_fchdesemb,
             F.AOIMP  ln_MontDesemb,
             F.AOSTAT ln_estado
      
        from fsd010 f
       where f.pgcod = 1
         and f.aocta in (select r.ctnro
                           from fsr008 r
                          where r.pgcod = 1
                            and r.pepais = ln_pais
                            and r.petdoc = ln_tdoc
                            and r.pendoc = lc_numdoc
                            and r.cttfir = 'T')
         and f.aomod = 101
         and f.aostat <> 99;
  
    ln_pais           number := 0;
    ln_tdoc           number := 0;
    lc_numdoc         varchar2(12);
    ln_MontCapTrabAux number(17, 2) := 0;
    ld_FchSist        date;
    ln_tipocambio     number := 0;
  
  begin
  
    ln_MontMaxCapTrab := 0;
  
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_pais, ln_tdoc, lc_numdoc
        from sng001 s
       where s.sng001inst = ln_Instancia;
    exception
      when others then
        NULL;
    end;
  
    begin
      select f.pgfape into ld_FchSist from fst017 f where f.pgcod = 1;
    end;
  
    ln_tipocambio := fn_tipo_cambio(FECHA  => ld_FchSist,
                                    MONORI => 0,
                                    MONDES => 0,
                                    TIPO   => 0);
  
    for l in lista_CredCapTrab(ln_pais, ln_tdoc, lc_numdoc) loop
    
      if l.ln_mda = 0 then
        ln_MontCapTrabAux := l.ln_montdesemb;
      
      else
        if l.ln_mda = 101 then
          ln_MontCapTrabAux := l.ln_montdesemb * ln_tipocambio;
        
        end if;
      end if;
    
      if ln_MontMaxCapTrab < ln_MontCapTrabAux then
        ln_MontMaxCapTrab := ln_MontCapTrabAux;
      end if;
    
    end loop;
  end sp_cr_MontMaxCapTrabVig;

end PQ_CR_CAPITALTRABAJO;
/

