alter table jaql977 add
(
  jaql977suc NUMBER(3),
  jaql977mod NUMBER(3),
  jaql977tra NUMBER(3),
  jaql977rel NUMBER(4),
  jaql977fco DATE
);
-- Add comments to the columns
comment on column jaql977.jaql977suc is 'Sucursal de la transaccion';
comment on column jaql977.jaql977mod is 'Modulo de la transaccion';
comment on column jaql977.jaql977tra is 'Transaccion de la transaccion';
comment on column jaql977.jaql977rel is 'Relacion de la transaccion';
comment on column jaql977.jaql977fco is 'Fecha de la contabilizacion';
