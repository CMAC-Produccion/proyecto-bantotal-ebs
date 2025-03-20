create or replace package PQ_CR_ACUERDOSDEPAGO is
  -- Author  : KVALENCIAC
  -- Created : 18/10/2021
  -- Purpose : Proceso para verificar si tiene un acuerdo vigente o en procesos de creación
  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure sp_tiene_acuerdo(pn_cod   in number,
                             pn_mod   in number,
                             pn_suc   in number,
                             pn_mda   in number,
                             pn_pap   in number,
                             pn_cta   in number,
                             pn_ope   in number,
                             pn_sbo   in number,
                             pn_top   in number,
                             pv_rpta out varchar2);                                                                                          
end PQ_CR_ACUERDOSDEPAGO;
/

create or replace package body pq_cr_acuerdosdepago is

 procedure sp_tiene_acuerdo(pn_cod   in number,
                             pn_mod   in number,
                             pn_suc   in number,
                             pn_mda   in number,
                             pn_pap   in number,
                             pn_cta   in number,
                             pn_ope   in number,
                             pn_sbo   in number,
                             pn_top   in number,
                             pv_rpta out varchar2) is  
  begin
    begin
       select AQPA806EST
        into pv_rpta
        from aqpa806 
       where AQPA806PGC = pn_cod
         and AQPA806MOD = pn_mod
         and AQPA806SUC = pn_suc
         and AQPA806MDA = pn_mda
         and AQPA806PAP = pn_pap
         and AQPA806CTA = pn_cta
         and AQPA806OPE = pn_ope
         and AQPA806SBO = pn_sbo
         and AQPA806TPO = pn_top
         and ( AQPA806EST = 'S' Or AQPA806EST = 'P');
     exception
      when others then
         pv_rpta := '';
    end;
end  sp_tiene_acuerdo;
                             
end pq_cr_acuerdosdepago;
/

