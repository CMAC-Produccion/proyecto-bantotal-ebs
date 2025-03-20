create or replace force view cehtica as
select 602 paridad,
       'Dolar Compra' descripcion,
       1 codigomoneda,
       tccpa factorconversion,
       tcfch fecha
  from fsd120
 where tcmda = 101
   and TcCod = 500
union all
select 604 paridad,
       'Dolar Compra' descripcion,
       1 codigomoneda,
       tcvta factorconversion,
       tcfch fecha
  from fsd120
 where tcmda = 101
   and TcCod = 500;

