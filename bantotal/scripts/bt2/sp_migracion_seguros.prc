CREATE OR REPLACE PROCEDURE SP_MIGRACION_SEGUROS(
FECHAINICIO     IN DATE,
FECHACHAR		IN Varchar2,
FECHAFIN        IN DATE,
FECHAEJECUCION  IN DATE,
HORAEJECUCION   IN Varchar2,
FECHAMIGRACION  IN DATE,
ESTADOMIGRACION IN Varchar2,
DescripcionError IN VARCHAR2)
IS

cursor cursortarjeta is SELECT
	vista."Producto",
    vista."Nro Afiliación",
    vista."Correlativo",
    vista."Numero de Tarjeta",
    vista."Empresa Cuenta AhorroN",
    vista."Modulo Cuenta ahorroN",
    vista."Sucursal Cuenta ahorroN",
    vista."Moneda Cuenta AhorroN",
    vista."Papel Cuenta AhorroN",
    vista."Cuenta Cuenta ahorroN",
    vista."Operacion Cuenta AhorroN",
    vista."Subcuenta Cuenta ahorroN",
    vista."Tipo de Operacion Cuenta AhorroN",
	vista."Fecha de asociación",
    vista."Usuario asociación",
    vista."Estado"
   from "TMP_SisDataTarjetaCta"@SISRETAIL vista WHERE vista."Fecha de asociación"=FECHACHAR;

numeroTarjeta Varchar2(100);
Auxhora varchar2(10);
AuxFechaEjecucion Date;
AuxFechaMigracion Date;
AuxEstadoMigracion varchar2(10);
AuxDescripcionError VARCHAR2(255);
AuxFechaInicio Date;
AuxFechaFin Date;
Auxfechacomparar Varchar2(255);
Auxfechaprueba Date;

BEGIN
Auxhora:= HORAEJECUCION;
AuxFechaEjecucion:=FECHAEJECUCION;
AuxFechaMigracion:=FECHAMIGRACION;
AuxEstadoMigracion:=ESTADOMIGRACION;
AuxDescripcionError:=DescripcionError;
AuxFechaInicio :=FECHAINICIO;
AuxFechaFin := FECHAFIN;

DELETE from jaqa60;
DELETE FROM jaqa61;
DELETE FROM jaqa62;
DELETE FROM jaqa63;
COMMIT;

--tabla jaqa60
insert into JAQA60(JAQA60PRO,JAQA60NRA,JAQA60NRP,JAQA60FAF,JAQA60TSE,JAQA60COS,JAQA60CCU,JAQA60IMP,JAQA60USV,JAQA60EST,JAQA60AOR,JAQA60FEV,JAQA60FER,JAQA60MOC,JAQA60COC,JAQA60RNA,JAQA60FIV,JAQA60FEA,JAQA60MTA,JAQA60MCO,JAQA60PAI,JAQA60TIP,JAQA60NDO,JAQA60CET,JAQA60DEP,JAQA60COP,JAQA60DEC,JAQA60COD,JAQA60FEE,JAQA60HOE,JAQA60FEM,JAQA60ESM)
select "Producto", "Nro Afiliación", "Nro Poliza", "Fecha de afiliación", "Tipo de seguro", "Codigo de seguro", "Cantidad de cuotas", "Importe", "Usuario Vendedor", "Estado",
"Nro Afiliacion Original que origino la renovacion",
"Fecha de Vencimiento",
"Fecha de Renovacion",
"Modo Cobro","Codigo Cobro", "Renovacion Automatica",
"Fecha de inicio de vigencia",
"Fecha de anulación", "Motivo de Anulación", "Modo de contratacion","Pais contratante", "Tipo de documento contratante", "Numero de documento contratante", "Contratante es titular","Descripcion Plan","Codigo Plan","Descripcion Costo","Codigo Costo",FECHAEJECUCION,'DSAD',FECHAMIGRACION,'A'
from "TMP_SisDataCertificados"@SISRETAIL
where "Fecha de afiliación" = FECHACHAR;

COMMIT;
insert into JAQA61(JAQA61PRO,JAQA61NRA,JAQA61TIP,JAQA61NRD,JAQA61COR,JAQA61NYA,JAQA61NAC,JAQA61PAI,JAQA61FEC,JAQA61SEX,JAQA61TEL,JAQA61PAR,JAQA61ENF,JAQA61DES,JAQA61POR,JAQA61USI,JAQA61FEI,JAQA61TIB,JAQA61CRE,JAQA61FEE,JAQA61HOE,JAQA61FEM,JAQA61ESM)
select vista."Producto", vista."Nro afiliación",vista."Tipo de Documento",vista."Numero de documento",vista."Correlativo",vista."Nombres y Apellidos",vista."Nacionalidad",vista."Pais", vista."Fecha de nacimiento",vista."Sexo",vista."Telefono",
vista."Parentesco",vista."Enfermedad(S/N)",vista."Descripción Enfermedad",vista."Porcentaje Asignado",vista."Usuario ingreso",vista."Fecha de Ingreso",vista."Tipo de beneficiario",vista."Correo" ,
FECHAEJECUCION,HORAEJECUCION,FECHAMIGRACION,ESTADOMIGRACION
from  "TMP_SisDataBeneficiarios"@SISRETAIL vista
WHERE vista."Fecha de Ingreso"= FECHACHAR;

commit;

for r in cursortarjeta loop
   INSERT
    INTO JAQA62
      (
         JAQA62PRO,
          JAQA62NRA,
          JAQA62COR,
          JAQA62NRT,
          JAQA62ECA,
          JAQA62MCA,
          JAQA62SCA,
          JAQA62MOC,
          JAQA62PCA,
          JAQA62CCA,
          JAQA62OCA,
          JAQA62SCC,
          JAQA62TOC,
           JAQA62FEA,
          JAQA62USA,
          JAQA62EST,
          JAQA62FEE,
          JAQA62HOE,
          JAQA62FEM,
          JAQA62ESM,
          JAQA62ERD
      )values( r."Producto",
      r."Nro Afiliación",
      r."Correlativo",
       numeroTarjeta,
       r."Empresa Cuenta AhorroN",
    r."Modulo Cuenta ahorroN",
    r."Sucursal Cuenta ahorroN",
    r."Moneda Cuenta AhorroN",
    r."Papel Cuenta AhorroN",
    r."Cuenta Cuenta ahorroN",
    r."Operacion Cuenta AhorroN",
    r."Subcuenta Cuenta ahorroN",
    r."Tipo de Operacion Cuenta AhorroN",
    r."Fecha de asociación",
    r."Usuario asociación",
    r."Estado",
    AuxFechaEjecucion,
    Auxhora,
    AuxFechaMigracion,
    AuxEstadoMigracion,
    AuxDescripcionError
    );
end loop;

	COMMIT;
 	insert into JAQA63(JAQA63PRO,JAQA63NRA,JAQA63NRP,JAQA63FEC,JAQA63MON,JAQA63EST,JAQA63FEA,JAQA63FEE,JAQA63HOE,JAQA63FEM,JAQA63ESM,JAQA63ERD)
	select vista."Producto", vista."Nro Afiliación",vista."Numero de pago",vista."Fecha esperada de pago",vista."Monto a pagar",vista."Estado",vista."Fecha Cobro",
	FECHAEJECUCION,HORAEJECUCION,FECHAMIGRACION,ESTADOMIGRACION,DescripcionError
	from  "TMP_SisDataCuotas"@SISRETAIL vista INNER JOIN JAQA62 tf ON
	vista."Producto" = tf.JAQA62PRO AND  vista."Nro Afiliación" = tf.JAQA62NRA;
	COMMIT;


END SP_MIGRACION_SEGUROS;
/

