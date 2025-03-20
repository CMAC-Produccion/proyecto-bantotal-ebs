create or replace procedure sp_tipo_cambio(FECHA  date,
                                           monori number,
                                           mondes number,
                                           tipo   number,
                                           tc     out number) is
begin
  TC := fn_tipo_cambio(fecha  => fecha,
                       monori => monori,
                       mondes => mondes,
                       tipo   => tipo);
end sp_tipo_cambio;
/

