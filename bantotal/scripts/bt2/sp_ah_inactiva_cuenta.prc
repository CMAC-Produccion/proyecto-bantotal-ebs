create or replace procedure SP_AH_INACTIVA_CUENTA(P_PgCod      number,
                                                  P_Scsuc      number,
                                                  P_Scrub      number,
                                                  P_Scmda      number,
                                                  P_Scpap      number,
                                                  P_Sccta      number,
                                                  P_Scoper     number,
                                                  P_Scsbop     number,
                                                  P_Sctope     number,
                                                  P_Scmod      number,
                                                  P_Scrub_rel  number,
                                                  P_Scstat_new number,
                                                  P_Scfcon     date,
                                                  P_Error      OUT number) is

begin

  P_Error := 0;
  If P_Scrub_rel = 0 then
    P_Error := 99;
  Else
    update fsd011
       set scrub = P_Scrub_rel, scstat = P_Scstat_new, scfcon = P_Scfcon
     Where PgCod = P_Pgcod
       and Scsuc = P_Scsuc
       and Scrub = P_Scrub
       and Scmda = P_ScMda
       and Scpap = P_Scpap
       and Sccta = P_Sccta
       and Scoper = P_Scoper
       and Scsbop = P_Scsbop
       and Sctope = P_Sctope
       and Scmod = P_ScMod;
  End If;
exception
  when others then
    P_Error := sqlcode;
end SP_AH_INACTIVA_CUENTA;
/

