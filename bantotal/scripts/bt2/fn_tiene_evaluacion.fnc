create or replace function fn_tiene_evaluacion (instancia in number) return char is
lc_eval char(3);

begin
  begin
     select 'S'
        into lc_eval
        from sng021 e
       where e.sng021sol = instancia
         and rownum = 1;
    exception
      when no_data_found then
          lc_eval := null;
      when others then
          lc_eval := 'x';
  end;
   return lc_eval;
end fn_tiene_evaluacion;
/

