create or replace function fn_evaluacion (pn_instancia in number, pn_codigo in number, pn_tipo in number)
                       return number is

ln_valor number;
begin

  begin
    select distinct f.sng023mto
           into ln_valor
          from sng021 e, sng023 f
         where e.sng021sol = pn_instancia
           and e.sng021tmod = pn_tipo
           and e.sng021eval = f.sng021eval
           and f.sng026cod = pn_codigo
           and rownum = 1

       ;
  exception
      when no_data_found then
         ln_valor := null;
      when too_many_rows then
         ln_valor := null;
  end;

   return ln_valor;
end fn_evaluacion;
/

