create or replace force view jaql823a as
select pgcod as ncodemp,sucurs as ncodage,scnom as cnomage,sccall as cdesdir,scnro as ncodnro,
       scciud as ccodciu,scdept as ccoddep
  from fst001
where sucurs <=500;

