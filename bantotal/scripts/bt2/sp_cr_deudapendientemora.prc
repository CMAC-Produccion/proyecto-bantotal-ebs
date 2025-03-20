create or replace procedure sp_cr_deudaPendienteMora(ve_empresa        in number,
                                                     ve_modulo         in number,
                                                     ve_sucursal       in number,
                                                     ve_moneda         in number,
                                                     ve_papel          in number,
                                                     ve_cuenta         in number,
                                                     ve_operacion      in number,
                                                     ve_sub_operacion  in number,
                                                     ve_tipo_operacion in number,
                                                     vs_respuesta      out varchar,
                                                     vs_monto          out number) is

  deudaPendienteMora number;
  cantidad_registros number;
begin
  begin
    select count(*)
      into cantidad_registros
      from aqpb999
     where aqpb999est = 'C'
       and aqpb999ehab = 'H'
       and aqpb999emp = ve_empresa
       and aqpb999mod = ve_modulo
       and aqpb999suc = ve_sucursal
       and aqpb999mda = ve_moneda
       and aqpb999pap = ve_papel
       and aqpb999cta = ve_cuenta
       and aqpb999ope = ve_operacion
       and aqpb999sbo = ve_sub_operacion
       and aqpb999top = ve_tipo_operacion;
  exception
    when others then
      null;
  end;
  if cantidad_registros > 0 then
    begin
      select sum(aqpb999mora + AQPB999icv)
        into deudaPendienteMora
        from aqpb999
       where aqpb999est = 'C'
         and aqpb999ehab = 'H'
         and aqpb999emp = ve_empresa
         and aqpb999mod = ve_modulo
         and aqpb999suc = ve_sucursal
         and aqpb999mda = ve_moneda
         and aqpb999pap = ve_papel
         and aqpb999cta = ve_cuenta
         and aqpb999ope = ve_operacion
         and aqpb999sbo = ve_sub_operacion
         and aqpb999top = ve_tipo_operacion;
      vs_respuesta := 'S';
      vs_monto     := deudaPendienteMora;
    exception
      when others then
        null;
    end;
  
  else
    vs_respuesta := 'N';
    vs_monto     := 0;
  end if;

end sp_cr_deudaPendienteMora;
/

