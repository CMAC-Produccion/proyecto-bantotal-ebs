create or replace force view v_jaql357 as
select
a.jaql357fecli, a.jaql357fecre, jaql357horec, a.jaql357tipme,
decode(a.jaql357cam02,b.Z0E478NRO,substr(a.jaql357cam02,0,6)||'******'||substr(a.jaql357cam02,13,4),a.jaql357cam02) jaql357cam02,
decode(b.z0e478thd,null,null,'****'||substr(trim(b.z0e478thd),5,length(trim(b.z0e478thd))-4)) z0e478thd,
a.jaql357cam03, a.jaql357corre, a.jaql357cam42,
a.jaql357cam04, a.jaql357cam05, a.jaql357cam07, a.jaql357cam09, a.jaql357cam10, a.jaql357cam11, a.jaql357cam12, a.jaql357cam13, a.jaql357cam14,
a.jaql357cam22, a.jaql357cam23, a.jaql357cam24, a.jaql357cam25, a.jaql357cam26, a.jaql357cam27, a.jaql357cam28, a.jaql357cam29, a.jaql357cam30,
a.jaql357cam31, a.jaql357cal33, a.jaql357caf33, a.jaql357cam37, a.jaql357cam38, a.jaql357cam39, a.jaql357cam40, a.jaql357cam41, a.jaql357cam43,
a.jaql357cal44, a.jaql357cad44, a.jaql357cal48, a.jaql357cad48, a.jaql357cam49, a.jaql357cam50, a.jaql357cal63, a.jaql357cad63, a.jaql357cam90,
a.jaql357cl102, a.jaql357cd102, a.jaql357cl112, a.jaql357cd112, a.jaql357ca120, a.jaql357numlo, a.jaql357fecen, a.jaql357mtoen, a.jaql357codmo,
a.jaql357codes
from JAQL357 a left outer join Z0E478 b
  on a.jaql357cam02=b.Z0E478NRO;

