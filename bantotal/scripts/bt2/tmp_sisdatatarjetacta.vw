create or replace force view tmp_sisdatatarjetacta as
select "Producto","Nro Afiliación","Correlativo","Numero de Tarjeta","Empresa Cuenta AhorroN","Modulo Cuenta ahorroN","Sucursal Cuenta ahorroN","Moneda Cuenta AhorroN","Papel Cuenta AhorroN","Cuenta Cuenta ahorroN","Operacion Cuenta AhorroN","Subcuenta Cuenta ahorroN","Tipo de Operacion Cuenta AhorroN","Fecha de asociación","Usuario asociación","Estado" from "TMP_SisDataTarjetaCta"@SISRETAIL;

