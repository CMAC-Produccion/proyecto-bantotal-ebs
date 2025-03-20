CREATE OR REPLACE FUNCTION "FN_CL_OBTENER_DEPARTAMENTOREP" (
                                               P_pgcod in number,
                                               P_pais in number,
                                               P_sucursal in number 
                                             ) return varchar2 is
  v_depnom varchar2(30);
  begin
    begin
    select DEPNOM 
    into v_depnom
    from fst068 a 
    where a.Pais = P_pais
    and a.depcod in (select scdept 
                  from fst001 x
                  where x.Pgcod  = P_pgcod
                    and x.sucurs = P_sucursal );
    exception
      when no_data_found then
        v_depnom := NULL;
      end;
  return v_depnom;
end;
/

