create or replace package pq_cr_flujo_sin_credito is

  -- Author  : RMONTESR
  -- Created : 17/09/2021 11:20:42
  -- Purpose : Resolutor política en la etapa de Evaluación el cual controla el campo Flujo sin crédito del Panel de Evaluación por Flujo
  
  PROCEDURE sp_cr_flujo(pn_instancia number, pv_resp out varchar2);

end pq_cr_flujo_sin_credito;
/

create or replace package body pq_cr_flujo_sin_credito is

  PROCEDURE sp_cr_flujo(pn_instancia number, pv_resp out varchar2) is
    lv_evalflujo varchar2(1);
    ln_conta number;
  begin
    pv_resp := 'N';
    begin
      pq_cr_ratio_evalflujo.sp_cr_verfevalflujo(pn_instancia,lv_evalflujo);
     exception
       when others then null;
    end;
    if lv_evalflujo = 'S' then
      begin
        select count(*) into ln_conta from aqpa410 a
        where a.aqpa410inst = pn_instancia
        and a.aqpa410esta = 'S'
        and a.aqpa410flujo > 0;
        exception
            when others then
            ln_conta := 0;
      end;
      if ln_conta > 0 then
        pv_resp := 'N';
      else
        pv_resp := 'S';
      end if;
    else
      pv_resp := 'N';
    end if;
  end sp_cr_flujo;
  
end pq_cr_flujo_sin_credito;
/

