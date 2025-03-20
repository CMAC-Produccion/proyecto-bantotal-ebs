create or replace procedure sp_cr_Instancia(ln_Scmod     in number,
                                            ln_Scsuc     in number,
                                            ln_Scmda     in number,
                                            ln_Scpap     in number,
                                            ln_Sccta     in number,
                                            ln_Scoper    in number,
                                            ln_Scsbop    in number,
                                            ln_Sctope    in number,
                                            ln_instancia out number) is
begin
  ln_instancia := fn_instancia_credito(v_Scmod  => ln_Scmod,
                                       v_Scsuc  => ln_Scsuc,
                                       v_Scmda  => ln_Scmda,
                                       v_Scpap  => ln_Scpap,
                                       v_Sccta  => ln_Sccta,
                                       v_Scoper => ln_Scoper,
                                       v_Scsbop => ln_Scsbop,
                                       v_Sctope => ln_Sctope);

end sp_cr_Instancia;
/

