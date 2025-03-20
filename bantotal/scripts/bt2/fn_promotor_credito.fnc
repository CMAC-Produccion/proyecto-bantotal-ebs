create or replace function fn_promotor_credito(
                                               v_Scmod  in number,
                                               v_Scsuc  in number,
                                               v_Scmda  in number,
                                               v_Scpap  in number,
                                               v_Sccta  in number,
                                               v_Scoper in number,
                                               v_Scsbop in number,
                                               v_Sctope in number
                                             ) return varchar2 is

    lc_promotor varchar2(50);
    ln_instancia number(10);
    ln_lote fpp175.pp174cod%type;

  begin

       ln_instancia := fn_instancia_credito(v_Scmod ,
                                           v_Scsuc ,
                                           v_Scmda ,
                                           v_Scpap ,
                                           v_Sccta ,
                                           v_Scoper,
                                           v_Scsbop,
                                           v_Sctope);

      begin
        select sng001usc
          into lc_promotor
         from  sng001
        where  sng001inst =  ln_instancia
           and sng015cod  =  1;
        exception
          when no_data_found then
               lc_promotor := null;
      end;

  return lc_promotor;
end;
/

