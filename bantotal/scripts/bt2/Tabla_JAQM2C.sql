
--DROP TABLE JAQM2C;

CREATE TABLE JAQM2C 
( JAQM2CCOD NUMBER(9,0) NOT NULL ENABLE, 
  JAQM2CCCA NUMBER(9,0) NOT NULL ENABLE, 
  JAQM2CDES VARCHAR2(250), 
  JAQM2CPRG CHAR(20), 
  JAQM2CTAG VARCHAR2(250), 
  JAQM2CVIS CHAR(1), 
  JAQM2CAN1 NUMBER(9,0), 
  JAQM2CAN2 NUMBER(9,0), 
  JAQM2CAN3 NUMBER(9,0), 
  JAQM2CAF1 DATE, 
  JAQM2CAF2 DATE, 
  JAQM2CAF3 DATE, 
  JAQM2CAI1 NUMBER(17,2), 
  JAQM2CAI2 NUMBER(17,2), 
  JAQM2CAI3 NUMBER(17,2), 
  JAQM2CAC1 CHAR(250), 
  JAQM2CAC2 CHAR(250), 
  JAQM2CAC3 CHAR(250)
)tablespace BANTPROD_B;

-- Add comments to the table 
comment on table JAQM2C
  is 'Tabla de datos complementarios';
-- Add comments to the columns 
comment on column JAQM2C.jaqm2ccod
  is 'Codigo del campo';
comment on column JAQM2C.jaqm2ccca
  is 'Codigo de categoria';
comment on column JAQM2C.jaqm2cdes
  is 'Descripcion del campo';
comment on column JAQM2C.jaqm2cprg
  is 'Programa que resuelve el valor';
comment on column JAQM2C.jaqm2ctag
  is 'Tag del campo';
comment on column JAQM2C.jaqm2cvis
  is 'Visible/No Visible';
comment on column JAQM2C.jaqm2can1
  is 'Auxiliar Numerico 1';
comment on column JAQM2C.jaqm2can2
  is 'Auxiliar Numerico 2';
comment on column JAQM2C.jaqm2can3
  is 'Auxiliar Numerico 3';
comment on column JAQM2C.jaqm2caf1
  is 'Auxiliar Fecha 1';
comment on column JAQM2C.jaqm2caf2
  is 'Auxiliar Fecha 2';
comment on column JAQM2C.jaqm2caf3
  is 'Auxiliar Fecha 3';
comment on column JAQM2C.jaqm2cai1
  is 'Auxiliar Importe 1';
comment on column JAQM2C.jaqm2cai2
  is 'Auxiliar Importe 2';
comment on column JAQM2C.jaqm2cai3
  is 'Auxiliar Importe 3';
comment on column JAQM2C.jaqm2cac1
  is 'Auxiliar Character 1';
comment on column JAQM2C.jaqm2cac2
  is 'Auxiliar Character 2';
comment on column JAQM2C.jaqm2cac3
  is 'Auxiliar Character 3';

   
-- Create/Recreate indexes 
CREATE INDEX JAQM2CA2 ON JAQM2C (JAQM2CCOD, JAQM2CPRG, JAQM2CTAG) 
  tablespace BANTPROD_B_IDX;
 CREATE INDEX JAQM2CA3 ON JAQM2C (JAQM2CCCA, JAQM2CPRG)
  tablespace BANTPROD_B_IDX;
 CREATE INDEX JAQM2CA4 ON JAQM2C (JAQM2CPRG, JAQM2CTAG) 
  tablespace BANTPROD_B_IDX;

-- Create/Recreate primary, unique and foreign key constraints 
alter table JAQM2C
  add primary key (JAQM2CCOD, JAQM2CCCA)
  using index 
  tablespace BANTPROD_B_IDX;
  
  
-- Grant/Revoke object privileges 
create or replace public synonym JAQM2C for bantprod.JAQM2C;

GRANT
  SELECT ON JAQM2C TO ROL_BANTPROD_CONS;
GRANT
  SELECT ON JAQM2C TO ROL_PRODUCCION;
GRANT
  SELECT ON BANTPROD.JAQM2C TO ROL_FUNCIONALES;  
GRANT
  SELECT ON BANTPROD.JAQM2C TO ROL_PARAMETRIZADORES;  
GRANT
  SELECT,INSERT,UPDATE,DELETE ON BANTPROD.JAQM2C TO ROL_SOPORTE_MESADEAYUDA;   
  

--DROP TABLE JAQM3C;

CREATE TABLE JAQM3C 
( JAQM3CCOD NUMBER(9,0) NOT NULL ENABLE, 
  JAQM3CDES VARCHAR2(250), 
  JAQM3CVIS CHAR(1), 
  JAQM3CPRG CHAR(20), 
  JAQM3CORD NUMBER(2,0), 
  JAQM3CAN1 NUMBER(9,0), 
  JAQM3CAN2 NUMBER(9,0), 
  JAQM3CAN3 NUMBER(9,0), 
  JAQM3CFE1 DATE, 
  JAQM3CFE2 DATE, 
  JAQM3CFE3 DATE, 
  JAQM3CAI1 NUMBER(17,2), 
  JAQM3CAI2 NUMBER(17,2), 
  JAQM3CAI3 NUMBER(17,2), 
  JAQM3CAC1 CHAR(250), 
  JAQM3CAC2 CHAR(250), 
  JAQM3CAC3 CHAR(250)
)tablespace BANTPROD_B;

-- Add comments to the table 
comment on table JAQM3C
  is 'Tabla de categorias de datos complementarios';
-- Add comments to the columns 
comment on column JAQM3C.jaqm3ccod
  is 'Codigo del campo';
comment on column JAQM3C.jaqm3cdes
  is 'Descripcion del campo';
comment on column JAQM3C.jaqm3cvis
  is 'Visible/No Visible';
comment on column JAQM3C.jaqm3cprg
  is 'Programa';
comment on column JAQM3C.jaqm3cord
  is 'Orden';
comment on column JAQM3C.jaqm3can1
  is 'Auxiliar Numerico 1';
comment on column JAQM3C.jaqm3can2
  is 'Auxiliar Numerico 2';
comment on column JAQM3C.jaqm3can3
  is 'Auxiliar Numerico 3';
comment on column JAQM3C.jaqm3cfe1
  is 'Auxiliar Fecha 1';
comment on column JAQM3C.jaqm3cfe2
  is 'Auxiliar Fecha 2';
comment on column JAQM3C.jaqm3cfe3
  is 'Auxiliar Fecha 3';
comment on column JAQM3C.jaqm3cai1
  is 'Auxiliar Importe 1';
comment on column JAQM3C.jaqm3cai2
  is 'Auxiliar Importe 2';
comment on column JAQM3C.jaqm3cai3
  is 'Auxiliar Importe 3';
comment on column JAQM3C.jaqm3cac1
  is 'Auxiliar Character 1';
comment on column JAQM3C.jaqm3cac2
  is 'Auxiliar Character 2';
comment on column JAQM3C.jaqm3cac3
  is 'Auxiliar Character 3';

 
  -- Create/Recreate indexes 
 CREATE INDEX JAQM3CA2 ON JAQM3C (JAQM3CCOD, JAQM3CPRG) 
  tablespace BANTPROD_B_IDX;
-- Create/Recreate primary, unique and foreign key constraints 
alter table JAQM3C
  add PRIMARY KEY (JAQM3CCOD)
  using index 
  tablespace BANTPROD_B_IDX;
  
-- Grant/Revoke object privileges 
create or replace public synonym JAQM3C for bantprod.JAQM3C;

GRANT
  SELECT ON JAQM3C TO ROL_BANTPROD_CONS;
GRANT
  SELECT ON JAQM3C TO ROL_PRODUCCION;
GRANT
  SELECT ON BANTPROD.JAQM3C TO ROL_FUNCIONALES;  
GRANT
  SELECT ON BANTPROD.JAQM3C TO ROL_PARAMETRIZADORES;  
GRANT
  SELECT,INSERT,UPDATE,DELETE ON BANTPROD.JAQM3C  TO ROL_SOPORTE_MESADEAYUDA;     
