create or replace force view tmp_sisdatacuotas as
select "Producto","Nro Afiliaci�n","Numero de pago","Fecha esperada de pago","Monto a pagar","Estado","Fecha Cobro" from "TMP_SisDataCuotas"@SISRETAIL;

