create or replace force view v_aqpc586 as
(
select t1.pftdoc TIPO_DOC,
       t1.pfndoc DOCUMENTO,
       trim(t1.pfape1) || ' ' || trim(t1.pfape2) || ', ' || trim(pfnom1) || ' ' ||
       trim(pfnom2) APELLIDOS_NOMBRES,
       nvl(to_char(t2.jaqy684motc), 'NO PRESENTA REGISTRO') MOTIVO,
       nvl(t2.jaqy684desc, 'NO PRESENTA REGISTRO') DESCRIPCION,
       jaqy684com COMENTARIO
  from fsd002 t1
  left join jaqy684 t2
    on t1.pfpais = t2.jaqy684pais
   and t1.pftdoc = t2.jaqy684tdoc
   and t1.pfndoc = rpad(t2.jaqy684ndoc, 12)
 where t1.pftdoc in (2, 3, 4, 5, 6, 10, 21)
);

