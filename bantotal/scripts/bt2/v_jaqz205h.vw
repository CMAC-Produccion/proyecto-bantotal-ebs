create or replace force view v_jaqz205h as
select
a.jaqz205hid,
decode(a.jaqz205hnutar,b.Z0E478NRO,substr(a.jaqz205hnutar,0,6)||'******'||substr(a.jaqz205hnutar,13,4),a.jaqz205hnutar) jaqz205hnutar,
decode(b.z0e478thd,null,null,'****'||substr(trim(b.z0e478thd),5,length(trim(b.z0e478thd))-4)) z0e478thd,
a.jaqz205hhabil,
a.jaqz205husafi,
a.jaqz205hfeafi,
a.jaqz205hhoafi,
a.jaqz205husdes,
a.jaqz205hsudes,
a.jaqz205hfedes,
a.jaqz205hhodes,
a.jaqz205htitar,
a.jaqz205hfeult,
a.jaqz205hhoult,
a.jaqz205hcelul,
a.jaqz205hemail,
a.jaqz205hseseg,
a.jaqz205hurlpu,
a.jaqz205hesurl,
a.jaqz205hestok,
a.jaqz205htipafi,
a.jaqz205himei,
a.jaqz205haux1,
a.jaqz205haux2,
a.jaqz205haux3,
a.jaqz205haux4,
a.jaqz205haux5
from JAQZ205H a left outer join Z0E478 b
  on a.JAQZ205Hnutar=b.Z0E478NRO;

