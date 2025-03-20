create or replace procedure SP_AH_HORA_MAS(P_N_NUMSEC IN NUMBER,
                                           p_c_hora out varchar2
                                           ) is
                                         
begin
  p_c_hora := to_char(sysdate + (1/(24*60*60))*P_N_NUMSEC,'HH24:mi:ss');
end SP_AH_HORA_MAS;
/

