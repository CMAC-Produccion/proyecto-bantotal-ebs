-- Create table
create table AQPA571
(
  aqpa571cod    NUMBER(4) not null,
  aqpa571suc    NUMBER(4) not null,
  aqpa571mda    NUMBER(4) not null,
  aqpa571pap    NUMBER(4) not null,
  aqpa571cta    NUMBER(9) not null,
  aqpa571oper   NUMBER(9) not null,
  aqpa571sbop   NUMBER(3) not null,
  aqpa571tope   NUMBER(3) not null,
  aqpa571mod    NUMBER(4) not null,
  aqpa571fech   DATE not null,
  aqpa571fpro   DATE,
  aqpa571mon    NUMBER(16,2),
  aqpa571tsuc   NUMBER(3),
  aqpa571tmod   NUMBER(3),
  aqpa571ttran  NUMBER(3),
  aqpa571tnrel  NUMBER(4),
  aqpa571rub    NUMBER(16),
  aqpa571usu    VARCHAR2(12),
  aqpa571psuc   NUMBER(4),
  aqpa571pmod   NUMBER(4),
  aqpa571ptran  NUMBER(4),
  aqpa571prel   NUMBER(4),
  aqpa571pfech  DATE,
  aqpa571dni    CHAR(12),
  aqpa571nom    CHAR(100),
  aqpa571age    CHAR(30),
  aqpa571fun    CHAR(10),
  aqpa571hora   CHAR(8),
  aqpa571codbt  NUMBER(4),
  aqpa571mdad   CHAR(30),
  aqpa571mtoa   NUMBER(16,2),
  aqpa571moti   CHAR(50),
  aqpa571tipop1 CHAR(10),
  aqpa571tipod1 CHAR(30),
  aqpa571ndoc1  CHAR(12),
  aqpa571apepa1 CHAR(30),
  aqpa571apema1 CHAR(30),
  aqpa571nom1   CHAR(30),
  aqpa571fnac1  DATE,
  aqpa571sexo1  CHAR(1),
  aqpa571dir1   CHAR(100),
  aqpa571depto1 CHAR(30),
  aqpa571prov1  CHAR(30),
  aqpa571dis1   CHAR(30),
  aqpa571tel1   NUMBER(10),
  aqpa571eciv1  CHAR(1),
  aqpa571corr1  CHAR(30),
  aqpa571tipop2 CHAR(10),
  aqpa571tipod2 CHAR(30),
  aqpa571ndoc2  CHAR(12),
  aqpa571apepa2 CHAR(30),
  aqpa571apema2 CHAR(30),
  aqpa571nom2   CHAR(30),
  aqpa571fnac2  DATE,
  aqpa571sexo2  CHAR(1),
  aqpa571dir2   CHAR(100),
  aqpa571depto2 CHAR(30),
  aqpa571prov2  CHAR(30),
  aqpa571dis2   CHAR(30),
  aqpa571tel2   NUMBER(10),
  aqpa571eciv2  CHAR(1),
  aqpa571corr2  CHAR(30),
  aqpa571tipop3 CHAR(10),
  aqpa571tipod3 CHAR(30),
  aqpa571ndoc3  CHAR(12),
  aqpa571apepa3 CHAR(30),
  aqpa571apema3 CHAR(30),
  aqpa571nom3   CHAR(30),
  aqpa571fnac3  DATE,
  aqpa571sexo3  CHAR(1),
  aqpa571dir3   CHAR(100),
  aqpa571depto3 CHAR(30),
  aqpa571prov3  CHAR(30),
  aqpa571dis3   CHAR(30),
  aqpa571tel3   NUMBER(10),
  aqpa571eciv3  CHAR(1),
  aqpa571corr3  CHAR(30),
  aqpa571au1    NUMBER(4),
  aqpa571au2    NUMBER(16,2),
  aqpa571au3    NUMBER(16,2),
  aqpa571au4    VARCHAR2(40),
  aqpa571au5    VARCHAR2(50),
  aqpa571au6    CHAR(20),
  aqpa571au7    DATE,
  aqpa571reg    CHAR(30),
  aqpa571fpag   CHAR(10),
  aqpa571nrov   CHAR(30)
)
tablespace BANTPROD_B;
-- Add comments to the table 
comment on table AQPA571
  is 'TABLA TEMPORAL REPORTE RETIRO SEGURO DIARIO';
-- Add comments to the columns 
comment on column AQPA571.aqpa571cod
  is 'CODIGO';
comment on column AQPA571.aqpa571suc
  is 'SUCURSAL';
comment on column AQPA571.aqpa571mda
  is 'MONEDA';
comment on column AQPA571.aqpa571pap
  is 'PAPEL';
comment on column AQPA571.aqpa571cta
  is 'CUENTA';
comment on column AQPA571.aqpa571oper
  is 'OPERACION';
comment on column AQPA571.aqpa571sbop
  is 'SUBOPERACION';
comment on column AQPA571.aqpa571tope
  is 'TIPO OPERACION';
comment on column AQPA571.aqpa571mod
  is 'MODULO';
comment on column AQPA571.aqpa571fech
  is 'FECHA';
comment on column AQPA571.aqpa571fpro
  is 'FECHA PROCESO';
comment on column AQPA571.aqpa571mon
  is 'MONTO PRIMA';
comment on column AQPA571.aqpa571tsuc
  is 'TRAN SUC';
comment on column AQPA571.aqpa571tmod
  is 'TRAN MOD';
comment on column AQPA571.aqpa571ttran
  is 'TRAN TRAN';
comment on column AQPA571.aqpa571tnrel
  is 'TRAN REL';
comment on column AQPA571.aqpa571rub
  is 'RUBRO';
comment on column AQPA571.aqpa571usu
  is 'USUARIO';
comment on column AQPA571.aqpa571psuc
  is 'PROCESO SUCURSAL';
comment on column AQPA571.aqpa571pmod
  is 'PROCESO MODULO';
comment on column AQPA571.aqpa571ptran
  is 'PROCESO TRANSACCION';
comment on column AQPA571.aqpa571prel
  is 'PROCESO RELACION';
comment on column AQPA571.aqpa571pfech
  is 'PROCESO FECHA';
comment on column AQPA571.aqpa571dni
  is 'DNI';
comment on column AQPA571.aqpa571nom
  is 'NOMBRE';
comment on column AQPA571.aqpa571age
  is 'AGENCIA';
comment on column AQPA571.aqpa571fun
  is 'FUNCIONARIO';
comment on column AQPA571.aqpa571hora
  is 'HORA';
comment on column AQPA571.aqpa571codbt
  is 'CODGO BT';
comment on column AQPA571.aqpa571mdad
  is 'MONEDA DESEMBOLSO';
comment on column AQPA571.aqpa571mtoa
  is 'MONTO A';
comment on column AQPA571.aqpa571moti
  is 'MONTO';
comment on column AQPA571.aqpa571tipop1
  is 'TIPO PERSONA 1';
comment on column AQPA571.aqpa571tipod1
  is 'TIPO DOCUMENTO 1';
comment on column AQPA571.aqpa571ndoc1
  is 'NRO DOCUMENTO 1';
comment on column AQPA571.aqpa571apepa1
  is 'APELLIDO PATERNO 1';
comment on column AQPA571.aqpa571apema1
  is 'APELLIDO MATERNO 1';
comment on column AQPA571.aqpa571nom1
  is 'NOMBRES 1';
comment on column AQPA571.aqpa571fnac1
  is 'FECHA NACIMIENTO 1';
comment on column AQPA571.aqpa571sexo1
  is 'SEXO1';
comment on column AQPA571.aqpa571dir1
  is 'DIRECCION 1';
comment on column AQPA571.aqpa571depto1
  is 'DEPARTAMENTO 1';
comment on column AQPA571.aqpa571prov1
  is 'PROVINCIA 1';
comment on column AQPA571.aqpa571dis1
  is 'DISRITO 1';
comment on column AQPA571.aqpa571tel1
  is 'TELEFONO 1';
comment on column AQPA571.aqpa571eciv1
  is 'ESTADO CIVIL 1';
comment on column AQPA571.aqpa571corr1
  is 'CORRELATIVO1';
comment on column AQPA571.aqpa571tipop2
  is 'TIPO PERSONA 2';
comment on column AQPA571.aqpa571tipod2
  is 'TIPO DOCUMENTO 2';
comment on column AQPA571.aqpa571ndoc2
  is 'NRO DOCUMENTO 2';
comment on column AQPA571.aqpa571apepa2
  is 'APELLIDO PATERNO 2';
comment on column AQPA571.aqpa571apema2
  is 'APELLIDO MATERNO 2';
comment on column AQPA571.aqpa571nom2
  is 'NOMBRES 2';
comment on column AQPA571.aqpa571fnac2
  is 'FECHA NACIMIENTO 2';
comment on column AQPA571.aqpa571sexo2
  is 'SEXO2';
comment on column AQPA571.aqpa571dir2
  is 'DIRECCION 2';
comment on column AQPA571.aqpa571depto2
  is 'DEPARTAMENTO 2';
comment on column AQPA571.aqpa571prov2
  is 'PROVINCIA 2';
comment on column AQPA571.aqpa571dis2
  is 'DISRITO 2';
comment on column AQPA571.aqpa571tel2
  is 'TELEFONO 2';
comment on column AQPA571.aqpa571eciv2
  is 'ESTADO CIVIL 2';
comment on column AQPA571.aqpa571corr2
  is 'CORRELATIVO2';
comment on column AQPA571.aqpa571tipop3
  is 'TIPO PERSONA 3';
comment on column AQPA571.aqpa571tipod3
  is 'TIPO DOCUMENTO 3';
comment on column AQPA571.aqpa571ndoc3
  is 'NRO DOCUMENTO 3';
comment on column AQPA571.aqpa571apepa3
  is 'APELLIDO PATERNO 3';
comment on column AQPA571.aqpa571apema3
  is 'APELLIDO MATERNO 3';
comment on column AQPA571.aqpa571nom3
  is 'NOMBRES 3';
comment on column AQPA571.aqpa571fnac3
  is 'FECHA NACIMIENTO 3';
comment on column AQPA571.aqpa571sexo3
  is 'SEXO3';
comment on column AQPA571.aqpa571dir3
  is 'DIRECCION 3';
comment on column AQPA571.aqpa571depto3
  is 'DEPARTAMENTO 3';
comment on column AQPA571.aqpa571prov3
  is 'PROVINCIA 3';
comment on column AQPA571.aqpa571dis3
  is 'DISRITO 3';
comment on column AQPA571.aqpa571tel3
  is 'TELEFONO 3';
comment on column AQPA571.aqpa571eciv3
  is 'ESTADO CIVIL 3';
comment on column AQPA571.aqpa571corr3
  is 'CORRELATIVO3';
comment on column AQPA571.aqpa571au1
  is 'AUXILIAR 1';
comment on column AQPA571.aqpa571au2
  is 'AUXILIAR 2';
comment on column AQPA571.aqpa571au3
  is 'AUXILIAR 3';
comment on column AQPA571.aqpa571au4
  is 'AUXILIAR 4';
comment on column AQPA571.aqpa571au5
  is 'AUXILIAR 5';
comment on column AQPA571.aqpa571au6
  is 'AUXILIAR 6';
comment on column AQPA571.aqpa571au7
  is 'AUXILIAR 7';
comment on column AQPA571.aqpa571reg
  is 'REGION';
comment on column AQPA571.aqpa571fpag
  is 'FORMA PAGO';
comment on column AQPA571.aqpa571nrov
  is 'NRO VOUCHER';
-- Create/Recreate primary, unique and foreign key constraints 
alter table AQPA571
  add primary key (AQPA571COD, AQPA571SUC, AQPA571MDA, AQPA571PAP, AQPA571CTA, AQPA571OPER, AQPA571SBOP, AQPA571TOPE, AQPA571MOD, AQPA571FECH)
  using index 
  tablespace BANTPROD_B_IDX;



-- Grant/Revoke object privileges 

create or replace public synonym AQPA571 for bantprod.AQPA571 ;
   
GRANT SELECT ON BANTPROD.AQPA571 TO ROL_BANTPROD_CONS;
GRANT SELECT ON BANTPROD.AQPA571 TO ROL_PRODUCCION;
GRANT SELECT ON BANTPROD.AQPA571 TO ROL_FUNCIONALES;
GRANT SELECT ON BANTPROD.AQPA571 TO ROL_PARAMETRIZADORES;

GRANT SELECT,INSERT,UPDATE,DELETE ON BANTPROD.AQPA571  TO ROL_SOPORTE_MESADEAYUDA;

