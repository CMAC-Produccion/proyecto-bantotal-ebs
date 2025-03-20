create or replace procedure sp_cr_inscreconv_sincodinst is
begin
--Luis C.
--Erika H. job 7am
insert into fpp102
  select (select wfattsval
            from wfattsvalues k
           where k.WFATTSID = 'ID_CONVENIO'
             and k.WFINSPRCID = p.xwfprcins),
         p.xwfempresa,
         p.xwfmodulo,
         p.xwfsucursal,
         p.xwfmoneda,
         p.xwfpapel,
         p.xwfcuenta,
         p.xwfoperacion,
         p.xwfsubope,
         p.xwftipope,
         'S',
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         'S',
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null
    from xwf700 p
   where p.xwfempresa = 1
     and (p.xwfcuenta, p.xwfoperacion, p.xwfsubope) in
         (select SCCTA, SCOPER, SCSBOP
            from fsd011 k
           where k.PGCOD = 1
             and k.SCMOD = 107
             and scstat < 99
          minus
          select PP102CTA, PP102OPE, PP102SBO
            from fpp102
           where PP102COD = 1
             and PP102MOD = 107)
     and (select wfattsval
            from wfattsvalues k
           where k.WFATTSID = 'ID_CONVENIO'
             and k.WFINSPRCID = p.xwfprcins) is not null;
commit;

--2023.03.23 LuisC : Lineamiento | Rating de Nuevas Agencias

Insert into FST098
  select 1,
         7698,
         rownum + (select max(TPCORR)
                     from fst098
                    where pgcod = 1
                      and tpcod = 7698),
         sucurs,
         'Nivel de Riesgo Bajo',
         1
    from (select SUCURS
            from fst001 l
           where l.pgcod = 1
             and l.sucurs < 800
          minus
          select TPNRO
            from fst098 u
           where u.PGCOD = 1
             and u.TPCOD = 7698);

commit;


end sp_cr_inscreconv_sincodinst;
/

