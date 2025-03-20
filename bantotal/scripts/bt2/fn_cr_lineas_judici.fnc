create or replace function fn_cr_lineas_judici(pn_ins in number) return  char is
lc_rub7 number(5) ;
lc_existe char(1);
begin
  lc_rub7 := 0;
  begin
         select count(*)
           into lc_rub7
           from jaqz098 a
          where a.instancia = pn_ins
            and a.rub_1 in ('9');
  exception
          when no_data_found then
               lc_rub7 := 0;
  end;
  

  
  if lc_rub7 >= 1  then
     lc_existe := 'N';
     else
               lc_existe := 'S';
  end if;
  
  return lc_existe;
end fn_cr_lineas_judici;
/

