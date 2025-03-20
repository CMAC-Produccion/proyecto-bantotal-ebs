create or replace package PQ_CR_OCURRENCIAS is

  -- Author  : ABERNEDO
  -- Created : 19/09/2014 10:28:28 a.m.
  -- Purpose : Prodimientos para la generacion del Reporte de Ocurrencias
  
  Procedure SP_instancia_credito(v_Scmod  in number,v_Scsuc  in number,v_Scmda  in number,
                               v_Scpap  in number,v_Sccta  in number,v_Scoper in number,
                               v_Scsbop in number,v_Sctope in number,ln_instancia out sng001.sng001inst%type);
  Procedure SP_analista_credito(v_Scmod  in number,v_Scsuc  in number,v_Scmda  in number,
                              v_Scpap  in number,v_Sccta  in number,v_Scoper in number,
                              v_Scsbop in number,v_Sctope in number,lc_analista out varchar2);   
  Procedure Sp_cod_activ (pn_pais in number, pn_tdoc in number,pc_ndoc in varchar2,pc_actividad out varchar2 );
  Procedure SP_cuotas_pagadas (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                             pn_pap in number, pn_cta in number, pn_oper in number,
                             pn_sbop in number,pn_top in number, pd_fecpro in date,
                             ln_numcuotas out number );   
  Procedure Sp_dias_atraso(v_Pgfape in date,v_Pgcod  in number,v_Scmod  in number,v_Scsuc  in number,
                         v_Scmda  in number,v_Scpap  in number,v_Sccta  in number,v_Scoper in number,
                         v_Scsbop in number,v_Sctope in number,v_Scstat in number,v_fecven in date,
                         ln_diatr out number);   
                     
  Procedure sp_TipCre (pn_cta in number,pc_es out varchar2);                                                                                                                            

end PQ_CR_OCURRENCIAS;
/

create or replace package body PQ_CR_OCURRENCIAS is

Procedure SP_instancia_credito(v_Scmod  in number,
                               v_Scsuc  in number,
                               v_Scmda  in number,
                               v_Scpap  in number,
                               v_Sccta  in number,
                               v_Scoper in number,
                               v_Scsbop in number,
                               v_Sctope in number,
                               ln_instancia out sng001.sng001inst%type
                               )is

  begin

       ln_instancia := fn_instancia_credito(v_Scmod,v_Scsuc,v_Scmda,v_Scpap,v_Sccta,v_Scoper,
                                                    v_Scsbop,v_Sctope);
       
       
end SP_instancia_credito;

Procedure SP_analista_credito(v_Scmod  in number,
                              v_Scsuc  in number,
                              v_Scmda  in number,
                              v_Scpap  in number,
                              v_Sccta  in number,
                              v_Scoper in number,
                              v_Scsbop in number,
                              v_Sctope in number,
                              lc_analista out varchar2
                              ) is
  begin                             
    lc_analista := fn_analista_credito(v_Scmod,v_Scsuc,v_Scmda,v_Scpap,v_Sccta,v_Scoper,v_Scsbop,v_Sctope);
   
end SP_analista_credito;

Procedure Sp_dias_atraso(v_Pgfape in date, --fecha de proceso
                         v_Pgcod  in number,
                         v_Scmod  in number,
                         v_Scsuc  in number,
                         v_Scmda  in number,
                         v_Scpap  in number,
                         v_Sccta  in number,
                         v_Scoper in number,
                         v_Scsbop in number,
                         v_Sctope in number,
                         v_Scstat in number,
                         v_fecven in date,
                         ln_diatr out number)is

   begin

       ln_diatr := fn_dias_atraso(v_Pgfape,v_Pgcod,v_Scmod,v_Scsuc,v_Scmda,v_Scpap,v_Sccta,v_Scoper,v_Scsbop,
                                  v_Sctope,v_Scstat,v_fecven);
       
       
end Sp_dias_atraso;

Procedure Sp_cod_activ (pn_pais in number, pn_tdoc in number,pc_ndoc in varchar2,pc_actividad out varchar2 )  is


begin
  begin
  select xx.actnom1
    into pc_actividad
    from sngc60 aa, fst750 xx
   where aa.sngc60pais = pn_pais
     and aa.sngc60tdoc = pn_tdoc
     and aa.sngc60ndoc = pc_ndoc
     and aa.sngc60corr = 0
     and aa.sngc60acte = xx.actcod1;
  exception
      when no_data_found then
           begin
           
                  select xxx.actnom1
                    into pc_actividad
                    from sngc11 cc, fst750 xxx
                   where cc.sngc11pais = pn_pais
                     and cc.sngc11tdoc = pn_tdoc
                     and cc.sngc11ndoc = pc_ndoc
                     and cc.sngc11act2 = xxx.actcod1;
           exception
               when no_data_found then
                    begin
                        
                        select xxx.actnom1
                        into pc_actividad
                        from fse001 cc, fst750 xxx
                       where cc.d511pais = pn_pais
                         and cc.d511tdoc = pn_tdoc
                         and cc.d511ndoc = pc_ndoc
                         and cc.expnins = xxx.actcod1;
                    exception
                         when others then 
                              pc_actividad := null;
                    end;
           end;
         
      when too_many_rows then
         pc_actividad := null;
  end;
end Sp_cod_activ;


Procedure SP_cuotas_pagadas (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                             pn_pap in number, pn_cta in number, pn_oper in number,
                             pn_sbop in number,pn_top in number, pd_fecpro in date,
                             ln_numcuotas out number ) is

begin
  begin
    select /*+ parallel(o,2,1)*/
            sum(count(*))
       into ln_numcuotas
       from fsd602 o
      where o.pgcod   = pn_emp
        and o.ppmod   = pn_mod
        and o.ppsuc   = pn_suc
        and o.ppmda   = pn_mda
        and o.pppap   = pn_pap
        and o.ppcta   = pn_cta
        and o.ppoper  = pn_oper
        and o.ppsbop  = pn_sbop
        and o.pptope  = pn_top
        and o.pp1fech  <= pd_fecpro
        and o.pp1stat = 'T'
        and o.d602co  = 'S'
        and (o.pp1cap+o.pp1int)<>0
      group by o.PGCOD,
           o.PPMOD,
           o.PPSUC,
           o.PPMDA,
           o.PPPAP,
           o.PPCTA,
           o.PPOPER,
           o.PPSBOP,
           o.PPTOPE,
           o.PPFPAG;
  exception
      when no_data_found then
         ln_numcuotas := null;
      when too_many_rows then
         ln_numcuotas := -1;
      when others then
         ln_numcuotas := -0;
  end;
  
end SP_cuotas_pagadas;


Procedure sp_TipCre (pn_cta in number,pc_es out varchar2)is

ln_count number;

begin

     begin

         select count(*)
           into ln_count
           from fsd010
          where aocta = pn_cta
            and aomod in (select modulo from fst111 where dscod = 50);
     exception
            when others then
                 ln_count := 0;
     end;
     
     if ln_count > 1 then
        pc_es := 'RECURRENTE';
        
        else
              pc_es := 'NUEVO';      
     
     end IF;
     

end sp_TipCre;

end PQ_CR_OCURRENCIAS;
/

