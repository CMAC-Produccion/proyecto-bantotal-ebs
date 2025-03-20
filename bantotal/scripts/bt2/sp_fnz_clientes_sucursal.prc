create or replace procedure sp_fnz_clientes_sucursal(pd_fecha in date)
is
begin
  delete
  from jaqz101c c
  where c.jaqz101cfch = pd_fecha;
  commit;

  insert into jaqz101c
  select
  fch,
  suc,
  count(distinct cli)
  from
  (
    select
    h012.bcfech fch,
    h012.bcsuc suc,
    r008.pepais||r008.petdoc||r008.pendoc cli
    from fsh012 h012
    left join fsr008 r008
    on r008.pgcod = h012.bcemp
    and r008.ctnro = h012.bccta
    and r008.ttcod = 1
    and r008.cttfir= 'T'
    where h012.bcfech = pd_fecha
    and substr(h012.bcrubr,1,4) in (1411,1415,1414,1421,1425,1424,1416,1426)
    and h012.bccta <> 999999999
    and h012.bcprod <> 99
    and h012.bcmod not in (33,141)
  )
  group by fch, suc;
  commit;

end;
/

