/*Script generado automaticamente por SGR 02/04/2025 17:42 */

CREATE TABLE JAQA1A 
   (	
  JAQA1ANCA NUMBER(4,0) NOT NULL ENABLE, 
	JAQA1ACTA NUMBER(9,0) NOT NULL ENABLE, 
	JAQA1ACOR NUMBER(9,0) NOT NULL ENABLE, 
	JAQA1AFEC DATE, 
	JAQA1AHOR CHAR(10), 
	JAQA1AUSU CHAR(10), 
	JAQA1AINS NUMBER(10,0), 
	JAQA1ACOD VARCHAR2(30), 
	JAQA1ANDO CHAR(12), 
	JAQA1ACCO NUMBER(4,0), 
	JAQA1AFVE DATE, 
	JAQA1ACES VARCHAR2(10), 
	JAQA1AIM1 NUMBER(17,2), 
	JAQA1AIM2 NUMBER(17,2), 
	JAQA1AIM3 NUMBER(17,2), 
	JAQA1ANU1 NUMBER(9,0), 
	JAQA1ANU2 NUMBER(9,0), 
	JAQA1ANU3 NUMBER(9,0), 
	JAQA1ADA1 DATE, 
	JAQA1ADA2 DATE, 
	JAQA1ADA3 DATE, 
	JAQA1AVA1 VARCHAR2(255), 
	JAQA1AVA2 VARCHAR2(255), 
	JAQA1AVA3 VARCHAR2(255), 
	JAQA1AVA4 VARCHAR2(255)
  )
  tablespace BANTPROD_B;


ALTER TABLE JAQA1A 
ADD PRIMARY KEY (JAQA1ANCA, JAQA1ACTA, JAQA1ACOR) USING INDEX TABLESPACE BANTPROD_B_IDX;

-- Create/Recreate indexes 
create index JAQA1AA3 on JAQA1A (JAQA1ACOR)
  tablespace BANTPROD_B_IDX;
create index JAQA1AA4 on JAQA1A (JAQA1AINS)
  tablespace BANTPROD_B_IDX;
create index JAQA1AA5 on JAQA1A (JAQA1ACTA)
  tablespace BANTPROD_B_IDX;    

-- Add comments to the table 
comment on table JAQA1A
  is 'Tabla Temporal para guardar condición laboral';
-- Add comments to the columns 
comment on column JAQA1A.JAQA1ANCA is 'Numero de Cartera'; 
comment on column JAQA1A.JAQA1ACTA is 'Cuenta';
comment on column JAQA1A.JAQA1ACOR is 'Correlativo';
comment on column JAQA1A.JAQA1AFEC is 'Fecha Ingreso';
comment on column JAQA1A.JAQA1AHOR is 'Hora Ingreso';
comment on column JAQA1A.JAQA1AUSU is 'Usuario Ingreso';
comment on column JAQA1A.JAQA1AINS is 'Instancia';
comment on column JAQA1A.JAQA1ACOD is 'Codigo de Trabajador';
comment on column JAQA1A.JAQA1ANDO is 'Numero de Documento';
comment on column JAQA1A.JAQA1ACCO is 'Codigo de Condicion Laboral';
comment on column JAQA1A.JAQA1AFVE is 'Fecha de Vencimiento';
comment on column JAQA1A.JAQA1ACES is 'Codigo ESSALUD';
comment on column JAQA1A.JAQA1AIM1 is 'Auxiliar Importe 1';
comment on column JAQA1A.JAQA1AIM2 is 'Auxiliar Importe 2';
comment on column JAQA1A.JAQA1AIM3 is 'Auxiliar Importe 3';
comment on column JAQA1A.JAQA1ANU1 is 'Auxiliar Numerico 1';
comment on column JAQA1A.JAQA1ANU2 is 'Auxiliar Numerico 2';
comment on column JAQA1A.JAQA1ANU3 is 'Auxiliar Numerico 3';
comment on column JAQA1A.JAQA1ADA1 is 'Auxiliar Fecha 1';
comment on column JAQA1A.JAQA1ADA2 is 'Auxiliar Fecha 2';
comment on column JAQA1A.JAQA1ADA3 is 'Auxiliar Fecha 3';
comment on column JAQA1A.JAQA1AVA1 is 'Auxiliar Varchar 1';
comment on column JAQA1A.JAQA1AVA2 is 'Auxiliar Varchar 2';
comment on column JAQA1A.JAQA1AVA3 is 'Auxiliar Varchar 3';
comment on column JAQA1A.JAQA1AVA4 is 'Auxiliar Varchar 4';

  
-- Create/Recreate primary, unique and foreign key constraints 
CREATE OR REPLACE PUBLIC SYNONYM JAQA1A FOR BANTPROD.JAQA1A;

GRANT SELECT ON BANTPROD.JAQA1A TO ROL_PRODUCCION;
GRANT SELECT ON BANTPROD.JAQA1A TO ROL_BANTPROD_CONS;
GRANT SELECT ON BANTPROD.JAQA1A TO ROL_FUNCIONALES;
GRANT SELECT ON BANTPROD.JAQA1A TO ROL_PARAMETRIZADORES;
GRANT SELECT,INSERT,UPDATE,DELETE ON BANTPROD.JAQA1A TO ROL_SOPORTE_MESADEAYUDA;  

