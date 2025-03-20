create or replace function fn_capital_apertura_dpf(P_PGCOD  in number,
                                   P_SCSUC  in number,
                                   P_SCMOD  in number,
                                   P_SCCTA  in number,
                                   P_SCOPER in number,
                                   P_SCPAP  in number,
                                   P_SCMDA  in number,
                                   P_SCSBOP in number,
                                   P_SCTOPE in number,
                                   P_SCSDO  in number
                                  ) return number
  is
    ln_capape fsd010.aoimp%type:=0;
  begin
       Select d010.aoimp
         Into ln_capape
         From fsd010 d010
        Where d010.pgcod  = P_PGCOD
          And d010.aomod  = P_SCMOD
          And d010.aosuc  = P_SCSUC
          And d010.aomda  = P_SCMDA
          And d010.aopap  = P_SCPAP
          And d010.aocta  = P_SCCTA
          And d010.aooper = P_SCOPER
          And d010.aotope = P_SCTOPE
          And d010.aosbop = (select min (a.aosbop)
                               From fsd010 a
                              Where a.pgcod  = d010.pgcod
                                And a.aomod  = d010.aomod
                                And a.aosuc  = d010.aosuc
                                And a.aomda  = d010.aomda
                                And a.aopap  = d010.aopap
                                And a.aocta  = d010.aocta
                                And a.aooper = d010.aooper
                                And a.aotope = d010.aotope
                                And a.aosbop < P_SCSBOP
                            );
         Return ln_capape;
  Exception When others then
            Return P_SCSDO;
  end fn_capital_apertura_dpf;
/

