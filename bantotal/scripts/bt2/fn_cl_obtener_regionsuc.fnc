CREATE OR REPLACE FUNCTION "FN_CL_OBTENER_REGIONSUC" (
                                               P_pgcod in number,
                                               P_codsuc in number 
                                             ) return varchar2 is
  v_nomregion varchar2(100);
  v_codregion number;
  begin
    begin

    SELECT b.Tp1nro1 into v_codregion 
    FROM Fst198 b
    WHERE b.Tp1cod   = P_pgcod
    AND   b.Tp1cod1  = 11110
    AND   b.Tp1corr1 = 5 
    AND   b.Tp1corr2 = 2 --sucursales
    AND   b.Tp1nro3 = P_codsuc; 

    SELECT c.Tp1desc into v_nomregion
    FROM Fst198 c
    WHERE c.Tp1cod   = P_pgcod
    AND   c.Tp1cod1  = 11110
    AND   c.Tp1corr1 = 5 
    AND   c.Tp1corr2 = 3 --regiones
    AND   c.Tp1corr3 = v_codregion; 

	exception
      when no_data_found then
        v_nomregion := NULL;
      end;
  return v_nomregion;
end;
/

