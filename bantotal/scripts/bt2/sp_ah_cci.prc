create or replace procedure sp_ah_cci(P_N_SCMOD  IN NUMBER,
                                      P_N_SCSUC  IN NUMBER,
                                      P_N_SCMDA  IN NUMBER,
                                      P_N_SCPAP  IN NUMBER,
                                      P_N_SCCTA  IN NUMBER,
                                      P_N_SCOPER IN NUMBER,
                                      P_N_SCSBOP IN NUMBER,
                                      P_N_SCTOPE IN NUMBER,
                                      p_c_numcci out varchar2             
                                      ) is
begin
  Select a.bnj096cci
    into p_c_numcci
    from bnj096 a 
   where a.BNJ096SUC = P_N_SCSUC 
     and a.BNJ096MDA = P_N_SCMDA  
     and a.BNJ096PAP = P_N_SCPAP  
     and a.BNJ096CTA = P_N_SCCTA  
     and a.BNJ096OPE = P_N_SCOPER 
     and a.BNJ096SUB = P_N_SCSBOP 
     and a.BNJ096MOD = P_N_SCMOD 
     and a.BNJ096TOP = P_N_SCTOPE;      
exception
When no_data_found then
  pq_ah_cci.sp_ah_cci(banco      => 803,
                      vscsuc     => P_N_SCSUC,
                      vsccta     => P_N_SCCTA,
                      vscsbop    => P_N_SCSBOP,
                      p_c_numcci => p_c_numcci
                      );    
when others then                      
  p_c_numcci := Null;
end sp_ah_cci;
/

