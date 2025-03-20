create or replace procedure sp_cr_compra_deuda_conv(p_instancia in number,
                                                    p_indicador out varchar2)
is

ln_cantidad number :=0;

begin

  --PYME
  begin
    select count(*)
      into ln_cantidad
      from jaqy327 j, fst198 f
     where j.jaqy327inst =  p_instancia
       and j.jaqy327esta = 'S'
       and j.jaqy327chek = '0'
       and nvl(j.jaqy327aux4, '0') = '1'
         and f.tp1cod = 1
         and f.tp1cod1 = 10899
         and f.tp1corr1 = 600
         and f.tp1corr3 > 1
         and substr(j.jaqy327rubr, 1,10) = trim(f.tp1desc);
  exception
    when others then
      ln_cantidad := 0;
  end;

  if nvl(ln_cantidad,0) = 0 then
    --CONSUMO
   begin
      select count(*)
        into ln_cantidad
        from jaqz862 j, fst198 f
       where j.jaqz862inst = p_instancia
         and j.jaqz862esta = 'S'
         and j.jaqz862chek = '0'
         and nvl(j.jaqz862aux4, '0') = '1'
         and f.tp1cod = 1
         and f.tp1cod1 = 10899
         and f.tp1corr1 = 600
         and f.tp1corr3 > 1
         and substr(j.jaqz862rubr, 1,10) = trim(f.tp1desc);
      exception when others then
        ln_cantidad := 0;
    end;

    null;
  end if;

  if nvl(ln_cantidad,0) <> 0 then
     p_indicador := 'S';
  else
     p_indicador := 'N';
  end if;

end sp_cr_compra_deuda_conv;
/

