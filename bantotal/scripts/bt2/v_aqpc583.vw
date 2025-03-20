create or replace force view v_aqpc583 as
(
select t1.pftdoc TIPO_DOC,
       t1.pfndoc DOCUMENTO,
       trim(t1.pfape1) || ' ' || trim(t1.pfape2) || ', ' || trim(pfnom1) || ' ' ||
       trim(pfnom2) APELLIDOS_NOMBRES,
       nvl(t3.tlisde, 'NO PRESENTA REGISTRO') NOM_LISTA_NEGRA,
       t2.lnmoobs DESC_LISTA_NEGRA,
       t2.lnmotdes FUENTE_LISTA_NEGRA,
       t2.tlis COD_LISTA_NEGRA
  from fsd002 t1
  left join fsd201 t2
    on t1.pfpais = t2.lnpais
   and t1.pftdoc = t2.lntdoc
   and t1.pfndoc = rpad(t2.lnndoc, 12)
  left join fst501 t3
    on t2.tlis = t3.tlis
 where t1.pftdoc in (2, 3, 4, 5, 6, 10, 21)
);

