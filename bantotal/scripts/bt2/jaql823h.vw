create or replace force view jaql823h as
select z0e478nro as cnumtar,z0e479suc as ncodage,z0e479cta as ncodcta,z0e479sct as ncodsct,z0e479mod as ncodmod,z0e479mon as ncodmon,
       z0e479pap as ncodpap,z0e479top as ntipope,z0e479ope as ncodope,z0e479est as ccodest,z0e479fmd as dfecmod,z0e479fau as dfecaut,
       case when Z0e480cod = 3 then 1 else 0 end as nctapri
  from z0e479;

