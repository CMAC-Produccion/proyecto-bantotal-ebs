alter table aqpa147 add
(
  aqpa147suc NUMBER(3),
  aqpa147mod NUMBER(3),
  aqpa147tra NUMBER(3),
  aqpa147rel NUMBER(4),
  aqpa147fco DATE
);
-- Add comments to the columns
comment on column aqpa147.aqpa147suc is 'Sucursal de la transaccion';
comment on column aqpa147.aqpa147mod is 'Modulo de la transaccion';
comment on column aqpa147.aqpa147tra is 'Transaccion de la transaccion';
comment on column aqpa147.aqpa147rel is 'Relacion de la transaccion';
comment on column aqpa147.aqpa147fco is 'Fecha de la contabilizacion';
