create or replace force view tmp_sisdatatarjetacta as
select "Producto","Nro Afiliaci�n","Correlativo","Numero de Tarjeta","Empresa Cuenta AhorroN","Modulo Cuenta ahorroN","Sucursal Cuenta ahorroN","Moneda Cuenta AhorroN","Papel Cuenta AhorroN","Cuenta Cuenta ahorroN","Operacion Cuenta AhorroN","Subcuenta Cuenta ahorroN","Tipo de Operacion Cuenta AhorroN","Fecha de asociaci�n","Usuario asociaci�n","Estado" from "TMP_SisDataTarjetaCta"@SISRETAIL;

