create or replace package PQ_CR_REPROGCONV is

Procedure Sp_verifica(pn_emp    in number,
                                      pn_mod    in number,
                                      pn_suc    in number,
                                      pn_mda    in number,
                                      pn_pap    in number,
                                      pn_cta    in number,
                                      pn_ope    in number,
                                      pn_sbo    in number,
                                      pn_top    in number,
                                      lc_cambia out char,
                                      fec_pag out date);

end PQ_CR_REPROGCONV;
/

create or replace package body PQ_CR_REPROGCONV is

Procedure Sp_verifica(pn_emp    in number,
                                      pn_mod    in number,
                                      pn_suc    in number,
                                      pn_mda    in number,
                                      pn_pap    in number,
                                      pn_cta    in number,
                                      pn_ope    in number,
                                      pn_sbo    in number,
                                      pn_top    in number,
                                      lc_cambia out char,
                                      fec_pag out date) is

begin
  lc_cambia := 'N';
  begin
    select 'S', a.jaqz519afpp
      into lc_cambia, fec_pag
      from jaqz519a a
     where a.JAQZ519AEMP = pn_emp
       and a.JAQZ519AMOD = pn_mod
       and a.JAQZ519ASUC = pn_suc
       and a.JAQZ519AMDA = pn_mda
       and a.JAQZ519APAP = pn_pap
       and a.JAQZ519ACTA = pn_cta
       and a.JAQZ519AOPE = pn_ope
       and a.JAQZ519ASBO = pn_sbo
       and a.JAQZ519ATOP = pn_top
       and a.JAQZ519APRO10 = 'S'
       and a.JAQZ519APRO11 = 'S'
       and a.JAQZ519APRO601 = 'S'
       and a.JAQZ519APRO611 = 'S'
       and a.JAQZ519AIND In ('S','P')
       and trim(a.JAQZ519AREVR) is null
       and rownum = 1;
  exception
    when others then
      lc_cambia := 'N'; 
      fec_pag := null;
  end;
end;
end PQ_CR_REPROGCONV;
/

