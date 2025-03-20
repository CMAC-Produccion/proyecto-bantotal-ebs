create or replace procedure sp_ah_consu_adenda(P_N_PGCOD  IN NUMBER,
                                               P_N_SCMOD  IN NUMBER,
                                               P_N_SCSUC  IN NUMBER,
                                               P_N_SCMDA  IN NUMBER,
                                               P_N_SCPAP  IN NUMBER,
                                               P_N_SCCTA  IN NUMBER,
                                               P_N_SCOPER IN NUMBER,
                                               P_N_SCSBOP IN NUMBER,
                                               P_N_SCTOPE IN NUMBER,
                                               p_c_indade out varchar2
                                               )  is
begin
      Select decode(a.aqpa126est,'A','S','R','N','N')
        into p_c_indade 
        from AQPA126 a
       where a.AQPA126PGC = P_N_PGCOD  
         and a.AQPA126MOD = P_N_SCMOD
         and a.AQPA126SUC = P_N_SCSUC
         and a.AQPA126MDA = P_N_SCMDA
         and a.AQPA126PAP = P_N_SCPAP
         and a.AQPA126CTA = P_N_SCCTA 
         and a.AQPA126OPE = P_N_SCOPER
         and a.AQPA126SBO = P_N_SCSBOP
         and a.AQPA126TPO = P_N_SCTOPE;  
Exception         
When others then
   p_c_indade := 'N';
end sp_ah_consu_adenda;
/

