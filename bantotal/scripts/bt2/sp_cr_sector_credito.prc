create or replace procedure sp_cr_sector_credito( v_fecpro in date,
                                               v_pgcod  in number,
                                               v_Scmod  in number,
                                               v_Scsuc  in number,
                                               v_Scmda  in number,
                                               v_Scpap  in number,
                                               v_Sccta  in number,
                                               v_Scoper in number,
                                               v_Scsbop in number,
                                               v_Sctope in number,
                                               ln_sector out number) is
begin
          begin
            ln_sector := fn_sector_credito(v_fecpro,
                                           v_pgcod ,
                                           v_Scmod ,
                                           v_Scsuc ,
                                           v_Scmda ,
                                           v_Scpap ,
                                           v_Sccta ,
                                           v_Scoper,
                                           v_Scsbop,
                                           v_Sctope);

          end;

end SP_cr_sector_credito;
/

