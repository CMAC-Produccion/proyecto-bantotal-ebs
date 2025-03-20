create or replace force view v_aqpc585 as
(
select t1.pftdoc TIPO_DOC_POSTULANTE,
       t1.pfndoc DOC_POSTULANTE,
       trim(t1.pfape1) || ' ' || trim(t1.pfape2) || ', ' || trim(t1.pfnom1) || ' ' ||
       trim(t1.pfnom2) APE_NOM_POSTULANTE,
       TIPO_DOC_TRABAJADOR_CAJA,
       DOC_TRABAJADOR_CAJA,
       APE_NOM_TRABAJADOR_CAJA,
       nvl(PARENTESCO,'SIN PARENTESCO') PARENTESCO
from (
select r.pftdoc TIPO_DOC_POSTULANTE,
       r.pfndoc DOC_POSTULANTE,
       trim(r.pfape1) || ' ' || trim(r.pfape2) || ', ' || trim(r.pfnom1) || ' ' ||
       trim(r.pfnom2) APE_NOM_POSTULANTE,
       v.pftdoc TIPO_DOC_TRABAJADOR_CAJA,
       v.pfndoc DOC_TRABAJADOR_CAJA,
       trim(v.pfape1) || ' ' || trim(v.pfape2) || ', ' || trim(v.pfnom1) || ' ' ||
       trim(v.pfnom2) APE_NOM_TRABAJADOR_CAJA,
       d.vinom PARENTESCO
  from fsr002 f
 inner join fsd002 r
    on r.pfndoc = f.pendoc
   and f.pepais = r.pfpais
   and f.petdoc = r.pftdoc
 inner join fst020 d
    on d.vicod = f.rpccyg
 inner join fsd002 v
    on v.pfndoc = f.rpndoc
   and f.pepais = v.pfpais
   and f.petdoc = v.pftdoc
 where v.pfebco = 'S'
   and r.pftdoc in (2, 3, 4, 5, 6, 10, 21)
) m2
right join fsd002 t1
   on  t1.pftdoc = m2.TIPO_DOC_POSTULANTE
   and t1.pfndoc = rpad(m2.DOC_POSTULANTE, 12)
where t1.pftdoc in (2, 3, 4, 5, 6, 10, 21)
);

