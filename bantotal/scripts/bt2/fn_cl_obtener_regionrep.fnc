CREATE OR REPLACE FUNCTION "FN_CL_OBTENER_REGIONREP" (
                                               P_pgcod in number,
                                               P_usuario in varchar2--CHAR(10) 
                                             ) return varchar2 is
  v_nomregion varchar2(100);
  begin
    begin
      SELECT DISTINCT 
      c.TP1DESC into v_nomregion
      FROM FST046 A
      INNER JOIN FST198 b
      ON a.UBSUC = b.TP1NRO3
      INNER JOIN FST198 c
      ON b.TP1NRO1 = c.TP1CORR3
      WHERE b.Tp1cod = P_pgcod AND b.TP1COD1=11110 AND b.TP1CORR1=5 and b.TP1CORR2=2 and a.UBUSER = rpad(P_usuario, 10, ' ')  --user , sucursales 
      and c.Tp1cod = P_pgcod and c.TP1COD1=11110 AND c.TP1CORR1=5 and c.TP1CORR2=3;
    exception
      when no_data_found then
        v_nomregion := NULL;
      end;
  return v_nomregion;
end;
/

