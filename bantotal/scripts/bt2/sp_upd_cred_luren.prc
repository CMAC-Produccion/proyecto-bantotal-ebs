create or replace procedure sp_upd_cred_luren is
--
--script actualiza el estado a los creditos refinanciados Luren
--
  cursor c_refi is
    select *
      from fsd011
     where pgcod = 1
       and sctope = 500
       and scrub like '14_4%'
       and scstat = 0;
begin
  for i in c_refi loop
    update fsd011
       set scstat = 61
     where pgcod  = i.pgcod
       and scmod  = i.scmod
       and scsuc  = i.scsuc
       and scmda  = i.scmda
       and scpap  = i.scpap
       and sccta  = i.sccta
       and scoper = i.scoper
       and scsbop = i.scsbop
       and sctope = i.sctope;

    update fsd010
       set aostat = 61
     where pgcod  = i.pgcod
       and aomod  = i.scmod
       and aosuc  = i.scsuc
       and aomda  = i.scmda
       and aopap  = i.scpap
       and aocta  = i.sccta
       and aooper = i.scoper
       and aosbop = i.scsbop
       and aotope = i.sctope;
  end loop;
end;
/

