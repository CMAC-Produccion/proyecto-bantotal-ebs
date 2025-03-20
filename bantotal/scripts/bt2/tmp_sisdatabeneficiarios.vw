create or replace force view tmp_sisdatabeneficiarios as
select "Producto","Nro afiliación","Correlativo","Nombres y Apellidos","Tipo de Documento","Numero de documento","Nacionalidad","Pais","Fecha de nacimiento","Sexo","Telefono","Parentesco","Enfermedad(S/N)","Descripción Enfermedad","Porcentaje Asignado","Usuario ingreso","Fecha de Ingreso","Tipo de beneficiario","Correo" from "TMP_SisDataBeneficiarios"@SISRETAIL;

