create or replace package PQ_AH_BLOQUEO_CTAS is

  -- Author  : MARAUJO
  -- Created : 25/09/2020 10:05:15 a. m.
  -- Purpose : BLOQUEO CTAS

  Procedure SP_AH_REGISTRA(P_N_PGCOD  IN number,
                           P_N_SCSUC  IN number,
                           P_N_SCMOD  IN number,
                           P_N_SCMDA  IN number,
                           P_N_SCPAP  IN number,
                           P_N_SCCTA  IN number,
                           P_N_SCOPER IN number,
                           P_N_SCSBOP IN number,
                           P_N_SCTOPE IN number,
                           P_C_ESIB   IN varchar2,
                           P_C_ESCM   IN varchar2,
                           P_C_ESVT   IN varchar2,
                           P_C_ESCC   IN varchar2,
                           P_C_ESAT   IN varchar2,
                           P_C_USER   IN varchar2,
                           P_D_FECH   IN date,
                           P_C_MODO   IN varchar2,
                           P_C_RPTA   OUT varchar2);

  Procedure SP_AH_IDENTIFICA(P_N_PGCOD  IN number,
                             P_N_SCSUC  IN number,
                             P_N_SCMOD  IN number,
                             P_N_SCMDA  IN number,
                             P_N_SCPAP  IN number,
                             P_N_SCCTA  IN number,
                             P_N_SCOPER IN number,
                             P_N_SCSBOP IN number,
                             P_N_SCTOPE IN number,
                             P_N_CANAL  IN number,
                             P_C_RPTA   OUT varchar2);

end PQ_AH_BLOQUEO_CTAS;
/

create or replace package body PQ_AH_BLOQUEO_CTAS is

  Procedure SP_AH_REGISTRA(P_N_PGCOD  IN number,
                           P_N_SCSUC  IN number,
                           P_N_SCMOD  IN number,
                           P_N_SCMDA  IN number,
                           P_N_SCPAP  IN number,
                           P_N_SCCTA  IN number,
                           P_N_SCOPER IN number,
                           P_N_SCSBOP IN number,
                           P_N_SCTOPE IN number,
                           P_C_ESIB   IN varchar2,
                           P_C_ESCM   IN varchar2,
                           P_C_ESVT   IN varchar2,
                           P_C_ESCC   IN varchar2,
                           P_C_ESAT   IN varchar2,
                           P_C_USER   IN varchar2,
                           P_D_FECH   IN date,
                           P_C_MODO   IN varchar2,
                           P_C_RPTA   OUT varchar2) is
  
    v_hora char(8) := to_char(sysdate, 'hh24:mi:ss');
  
  begin
    P_C_RPTA := 'OK';
  
    If P_C_MODO = 'INS' then
      insert into jaql746
        (jaql746pgco,
         jaql746scsu,
         jaql746scmo,
         jaql746scmd,
         jaql746scpa,
         jaql746scct,
         jaql746scop,
         jaql746scsb,
         jaql746scto,
         jaql746esib,
         jaql746escm,
         jaql746esvt,
         jaql746escc,
         jaql746esat,
         jaql746user,
         jaql746fech,
         jaql746hora)
      values
        (P_N_PGCOD,
         P_N_SCSUC,
         P_N_SCMOD,
         P_N_SCMDA,
         P_N_SCPAP,
         P_N_SCCTA,
         P_N_SCOPER,
         P_N_SCSBOP,
         P_N_SCTOPE,
         P_C_ESIB,
         P_C_ESCM,
         P_C_ESVT,
         P_C_ESCC,
         P_C_ESAT,
         P_C_USER,
         P_D_FECH,
         v_hora);
    Else
      update jaql746
         set jaql746esib = P_C_ESIB,
             jaql746escm = P_C_ESCM,
             jaql746esvt = P_C_ESVT,
             jaql746escc = P_C_ESCC,
             jaql746esat = P_C_ESAT,
             jaql746user = P_C_USER,
             jaql746fech = P_D_FECH,
             jaql746hora = v_HORA
       where jaql746pgco = P_N_PGCOD
         and jaql746scsu = P_N_SCSUC
         and jaql746scmo = P_N_SCMOD
         and jaql746scmd = P_N_SCMDA
         and jaql746scpa = P_N_SCPAP
         and jaql746scct = P_N_SCCTA
         and jaql746scop = P_N_SCOPER
         and jaql746scsb = P_N_SCSBOP
         and jaql746scto = P_N_SCTOPE;
    End If;
  
    commit;
  exception
    when others then
      P_C_RPTA := sqlerrm; --'Error al grabar el cambio';
  end;

  -----------------------------------------------------

  Procedure SP_AH_IDENTIFICA(P_N_PGCOD  IN number,
                             P_N_SCSUC  IN number,
                             P_N_SCMOD  IN number,
                             P_N_SCMDA  IN number,
                             P_N_SCPAP  IN number,
                             P_N_SCCTA  IN number,
                             P_N_SCOPER IN number,
                             P_N_SCSBOP IN number,
                             P_N_SCTOPE IN number,
                             P_N_CANAL  IN number,
                             P_C_RPTA   OUT varchar2) is
  
  begin
  
    select case
             when P_N_CANAL < 700 then
              jaql746esvt
             when P_N_CANAL = 901 then
              jaql746esib
             when P_N_CANAL = 902 then
              jaql746escc
             when P_N_CANAL = 903 then
              jaql746esat
             when P_N_CANAL = 907 then
              jaql746escm
             else
              'N'
           end
      into P_C_RPTA
      from jaql746
     where jaql746pgco = P_N_PGCOD
       and jaql746scsu = P_N_SCSUC
       and jaql746scmo = P_N_SCMOD
       and jaql746scmd = P_N_SCMDA
       and jaql746scpa = P_N_SCPAP
       and jaql746scct = P_N_SCCTA
       and jaql746scop = P_N_SCOPER
       and jaql746scsb = P_N_SCSBOP
       and jaql746scto = P_N_SCTOPE;
       
  exception
    when no_data_found then
      P_C_RPTA := 'N';
    when too_many_rows then
      P_C_RPTA := 'S';
    when others then
      P_C_RPTA := 'X';
  end;
end PQ_AH_BLOQUEO_CTAS;
/

