create or replace package pq_cr_ret_actriesgo is
  procedure sp_cr_activ(pn_ins in number, pn_risk out number);
end pq_cr_ret_actriesgo;
/

create or replace package body pq_cr_ret_actriesgo is

  procedure sp_cr_activ(pn_ins in number, pn_risk out number) is
  
    ln_pai    number(3);
    ln_tdo    number(2);
    ln_ndo    char(12);
    ln_act    number(11);
    ln_riesgo number(5);
  
  begin
  
    begin
      select a.sng001pais, a.sng001tdoc, a.sng001ndoc
        into ln_pai, ln_tdo, ln_ndo
        from sng001 a
       where a.sng001inst = pn_ins;
    exception
      when others then
        null;
    end;
  
    ln_act := pq_Cr_activ_riesgos.fn_cod_activ(ln_pai, ln_tdo, ln_ndo);
    begin
      select a.aqpa863ries
        into ln_riesgo
        from aqpa863 a
       where a.aqpa863ciiu = ln_act
         and a.aqpa863vige = 'S';
    exception
      when others then
        null;
    end;
  
    pn_risk := ln_riesgo;
  end sp_cr_activ;

end pq_cr_ret_actriesgo;
/

