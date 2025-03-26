-- Create table
create table AQPC336
(
  aqpc336idl NUMBER(9) not null,
  aqpc336fpr DATE,
  aqpc336hpr CHAR(8),
  aqpc336tar CHAR(19),
  aqpc336pai NUMBER(3),
  aqpc336tdo NUMBER(2),
  aqpc336ndo CHAR(12),
  aqpc336cbl NUMBER(5),
  aqpc336usr CHAR(10),
  aqpc336mre VARCHAR2(100)
)
tablespace BANTPROD_B;

-- Add comments to the table
comment on table AQPC336 is 'Log bloqueos de tarjetas de débito sin cuentas asociadas';

-- Add comments to the columns
comment on column AQPC336.aqpc336idl is 'Id / Correlativo';
comment on column AQPC336.aqpc336fpr is 'Fecha de proceso';
comment on column AQPC336.aqpc336hpr is 'Hora de proceso';
comment on column AQPC336.aqpc336tar is 'Número de tarjeta';
comment on column AQPC336.aqpc336pai is 'Pais del documento';
comment on column AQPC336.aqpc336tdo is 'Tipo del documento';
comment on column AQPC336.aqpc336ndo is 'Número del documento';
comment on column AQPC336.aqpc336cbl is 'Motivo del bloqueo';
comment on column AQPC336.aqpc336usr is 'Usuario que ejecutó el proceso';
comment on column AQPC336.aqpc336mre is 'Respuesta del proceso';

-- Create/Recreate primary, unique and foreign key constraints
alter table AQPC336
  add primary key (AQPC336IDL)
  using index
  tablespace BANTPROD_B_IDX;

-- Grant/Revoke object privileges
grant select on BANTPROD.AQPC336 to ROL_BANTPROD_CONS;
grant select on BANTPROD.AQPC336 to ROL_PRODUCCION;
grant select on BANTPROD.AQPC336 to ROL_FUNCIONALES;
grant select on BANTPROD.AQPC336 to ROL_PARAMETRIZADORES;
grant select, insert, update, delete on BANTPROD.AQPC336 to ROL_SOPORTE_MESADEAYUDA;

create or replace public synonym AQPC336 for BANTPROD.AQPC336;
