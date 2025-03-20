create or replace procedure SP_RIESGO_UNICO_BT(P_PERANO in number, P_PERMES in number) is
begin  
pq_riesgo_unico_bt.SP_CR_RIESGO_UNICO(P_PERANO,P_PERMES);
end SP_RIESGO_UNICO_BT;
/

