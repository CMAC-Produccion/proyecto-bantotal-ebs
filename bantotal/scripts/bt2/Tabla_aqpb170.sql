--drop table aqpb170
CREATE TABLE aqpb170 
( aqpb170cor number(10),
  aqpb170Pgfape date,
  aqpb170codcat number(10),
  aqpb170codcamp number(10),
  aqpb170tag varchar2(250),
  aqpb170inst number(10),
  aqpb170hora char(8),
  aqpb170user varchar2(10),
  aqpb170prg varchar2(20),
  aqpb170valor varchar2(255),
  aqpb170est varchar2(10),
  aqpb170aux1 varchar2(255),
  aqpb170aux2 varchar2(255),
  aqpb170aux3 varchar2(255)
 )tablespace BANTPROD_B;

-- Add comments to the table 
comment on table AQPB170
  is 'Tabla Log de Ejecuciones de Datos Complementario en Aprobacion';
-- Add comments to the columns 
comment on column AQPB170.aqpb170cor
  is 'Correlativo por fecha';
comment on column AQPB170.aqpb170pgfape
  is 'Fecha';
comment on column AQPB170.aqpb170codcat
  is 'Codigo de Categoria';
comment on column AQPB170.aqpb170codcamp
  is 'Codigo de Campo';
comment on column AQPB170.aqpb170tag
  is 'TAG - Nombre de la variable';
comment on column AQPB170.aqpb170inst
  is 'Instancia';
comment on column AQPB170.aqpb170hora
  is 'Hora ';
comment on column AQPB170.aqpb170user
  is 'Usuario';
comment on column AQPB170.aqpb170prg
  is 'Programa';  
comment on column AQPB170.aqpb170valor
  is 'Valor';
comment on column AQPB170.aqpb170est
  is 'Estado';
comment on column AQPB170.aqpb170aux1
  is 'Aux1';
comment on column AQPB170.aqpb170aux2
  is 'Aux2';
comment on column AQPB170.aqpb170aux3
  is 'Aux3';

-- Create/Recreate indexes 
create index aqpb170A2 on aqpb170(aqpb170inst,aqpb170pgfape)
  tablespace BANTPROD_B_IDX;
create index aqpb170A3 on aqpb170(aqpb170pgfape,aqpb170cor)
  tablespace BANTPROD_B_IDX;
create index aqpb170A4 on aqpb170(aqpb170inst,aqpb170codcat,aqpb170codcamp)
  tablespace BANTPROD_B_IDX;
create index aqpb170A5 on aqpb170(aqpb170prg)
  tablespace BANTPROD_B_IDX;
create index aqpb170A6 on aqpb170(aqpb170codcat,aqpb170codcamp)
  tablespace BANTPROD_B_IDX;

-- Create/Recreate primary, unique and foreign key constraints 
alter table aqpb170
  add primary key (aqpb170cor,aqpb170pgfape,aqpb170codcat,aqpb170codcamp,aqpb170inst,aqpb170hora)
  using index 
  tablespace BANTPROD_B_IDX;
  
-- Grant/Revoke object privileges 
create or replace public synonym aqpb170 for bantprod.aqpb170;

GRANT
  SELECT ON aqpb170 TO ROL_BANTPROD_CONS;
GRANT
  SELECT ON aqpb170 TO ROL_PRODUCCION;
GRANT
  SELECT ON BANTPROD.aqpb170 TO ROL_FUNCIONALES;  
GRANT
  SELECT ON BANTPROD.aqpb170 TO ROL_PARAMETRIZADORES;  
GRANT
  SELECT,INSERT,UPDATE,DELETE ON BANTPROD.aqpb170 TO ROL_SOPORTE_MESADEAYUDA; 
