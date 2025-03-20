create or replace function fn_tasa_opeact(P_PGCOD in number,
                                          P_SCMOD in number,
                                          P_SCSUC in number,
                                          P_SCMDA in number,
                                          P_SCPAP in number,
                                          P_SCCTA in number,
                                          P_SCOPE in number,
                                          P_SCSBO in number,
                                          P_SCTOP in number
                                         ) return number
is
  ln_tea fsd010.aotasa%type;
begin
     Select d010.aotasa
       Into ln_tea
       From fsd010 d010
      Where d010.pgcod = P_PGCOD
        And d010.aomod = P_SCMOD
        And d010.aosuc = P_SCSUC
        And d010.aomda = P_SCMDA
        And d010.aopap = P_SCPAP
        And d010.aocta = P_SCCTA
        And d010.aooper= P_SCOPE
        And d010.aosbop= P_SCSBO
        And d010.aotope= P_SCTOP;

    Return ln_tea;

Exception When Others Then
          Return 0;
end fn_tasa_opeact;
/

