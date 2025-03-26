alter table aqpa147h add
(
  aqpa147hsuc NUMBER(3),
  aqpa147hmod NUMBER(3),
  aqpa147htra NUMBER(3),
  aqpa147hrel NUMBER(4),
  aqpa147hfco DATE
);
-- Add comments to the columns
comment on column aqpa147h.aqpa147hsuc is 'Sucursal de la transaccion';
comment on column aqpa147h.aqpa147hmod is 'Modulo de la transaccion';
comment on column aqpa147h.aqpa147htra is 'Transaccion de la transaccion';
comment on column aqpa147h.aqpa147hrel is 'Relacion de la transaccion';
comment on column aqpa147h.aqpa147hfco is 'Fecha de la contabilizacion';
