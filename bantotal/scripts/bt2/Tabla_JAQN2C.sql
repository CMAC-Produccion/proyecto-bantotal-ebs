--select * from jaqn2c;
--crea tabla JAQN2C

CREATE TABLE JAQN2C 
   (  
  JAQN2CFEC DATE NOT NULL ENABLE, 
  JAQN2CNCA NUMBER(4,0) NOT NULL ENABLE, 
  JAQN2CUSU CHAR(10) NOT NULL ENABLE, 
  JAQN2CNNC CHAR(50), 
  JAQN2CWKS CHAR(12), 
  JAQN2CHOR CHAR(10), 
  JAQN2CAI1 NUMBER(17,2), 
  JAQN2CAI2 NUMBER(17,2), 
  JAQN2CAI3 NUMBER(17,2), 
  JAQN2CAN1 NUMBER(9,0), 
  JAQN2CAN2 NUMBER(9,0), 
  JAQN2CAN3 NUMBER(9,0), 
  JAQN2CAC1 CHAR(200), 
  JAQN2CAC2 CHAR(200), 
  JAQN2CAC3 CHAR(200), 
  JAQN2CAF1 DATE, 
  JAQN2CAF2 DATE, 
  JAQN2CAF3 DATE, 
  JAQN2CAT1 VARCHAR2(255), 
  JAQN2CAT2 VARCHAR2(255), 
  JAQN2CAT3 VARCHAR2(255)
)
tablespace BANTPROD_B;



-- Add comments to the table 
comment on table JAQN2C is 'Tabla que guarda log de alertas de vencimiento de convenio';
-- Add comments to the columns 
comment on column JAQN2C.JAQN2CFEC is 'Fecha Ingreso';
comment on column JAQN2C.JAQN2CNCA is 'Numero de Cartera';
comment on column JAQN2C.JAQN2CUSU is 'Usuario de Ingreso';
comment on column JAQN2C.JAQN2CNNC is 'Nombre de Cartera';
comment on column JAQN2C.JAQN2CWKS is 'Workstation Ingreso';
comment on column JAQN2C.JAQN2CHOR is 'Hora Ingreso';
comment on column JAQN2C.JAQN2CAI1 is 'Auxiliar Importe 1';
comment on column JAQN2C.JAQN2CAI2 is 'Auxiliar Importe 2';
comment on column JAQN2C.JAQN2CAI3 is 'Auxiliar Importe 3';
comment on column JAQN2C.JAQN2CAN1 is 'Auxiliar Numerico 1';
comment on column JAQN2C.JAQN2CAN2 is 'Auxiliar Numerico 2';
comment on column JAQN2C.JAQN2CAN3 is 'Auxiliar Numerico 3';
comment on column JAQN2C.JAQN2CAC1 is 'Auxiliar Caracter 1';
comment on column JAQN2C.JAQN2CAC2 is 'Auxiliar Caracter 2';
comment on column JAQN2C.JAQN2CAC3 is 'Auxiliar Caracter 3';
comment on column JAQN2C.JAQN2CAF1 is 'Auxiliar Fecha 1';
comment on column JAQN2C.JAQN2CAF2 is 'Auxiliar Fecha 2';
comment on column JAQN2C.JAQN2CAF3 is 'Auxiliar Fecha 3';
comment on column JAQN2C.JAQN2CAT1 is 'Auxiliar Texto 1';
comment on column JAQN2C.JAQN2CAT2 is 'Auxiliar Texto 2';
comment on column JAQN2C.JAQN2CAT3 is 'Auxiliar Texto 3';


ALTER TABLE JAQN2C 
ADD PRIMARY KEY (JAQN2CFEC, JAQN2CNCA, JAQN2CUSU) USING INDEX TABLESPACE BANTPROD_B_IDX;


CREATE OR REPLACE PUBLIC SYNONYM JAQN2C FOR BANTPROD.JAQN2C;

GRANT SELECT ON BANTPROD.JAQN2C TO ROL_PRODUCCION;
GRANT SELECT ON BANTPROD.JAQN2C TO ROL_BANTPROD_CONS;
GRANT SELECT ON BANTPROD.JAQN2C TO ROL_FUNCIONALES;
GRANT SELECT ON BANTPROD.JAQN2C TO ROL_PARAMETRIZADORES;
GRANT SELECT,INSERT,UPDATE,DELETE ON BANTPROD.JAQN2C TO ROL_SOPORTE_MESADEAYUDA;  
  
