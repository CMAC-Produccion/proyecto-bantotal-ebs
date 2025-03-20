create or replace function fn_usuario_nombre(
                                               v_ubuser in varchar2
                                             ) return varchar2 is

    ln_nombre varchar2(50);
  begin

    begin

      SELECT ubnom
             into  ln_nombre
      FROM  FST746
      WHERE  ubuser = v_ubuser;

    exception
      when no_data_found then
        ln_nombre := null;
      end;

  return ln_nombre;
end;
/

