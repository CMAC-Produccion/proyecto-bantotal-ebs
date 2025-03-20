CREATE OR REPLACE FUNCTION "FN_CL_OBTENER_PROVINCIAREP" (
                                               P_pgcod in number,
                                               P_pais in number,
                                               P_sucursal in number --NUMBER(3) 
                                             ) return varchar2 is
  v_provnom varchar2(60);
  v_depcod number(5);
  v_loccod number(5);
  begin
    begin
    select TO_NUMBER(scciud), TO_NUMBER(scdept)
    into v_loccod, v_depcod
    from fst001 b
    where b.Pgcod  = P_pgcod
      and b.sucurs = P_sucursal;
                    
    select LOCNOM 
    into v_provnom
    from fst070 a
    where a.Pais = P_pais
    and a.DepCod = v_depcod
    and a.loccod = v_loccod;
    exception
      when no_data_found then
        v_provnom := NULL;
      end;
  return v_provnom;
end;
/

