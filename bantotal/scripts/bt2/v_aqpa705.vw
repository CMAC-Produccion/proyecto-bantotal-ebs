create or replace force view v_aqpa705 as
select
a.aqpa705corr, a.aqpa705seint,
--a.aqpa705nutar,
substr(a.aqpa705nutar,0,6)||'******'||substr(a.aqpa705nutar,13,4) aqpa705nutar,
a.aqpa705pdoc, a.aqpa705tdoc, a.aqpa705ndoc, a.aqpa705tipope, a.aqpa705fectra, a.aqpa705hortra, a.aqpa705ctcod, a.aqpa705ctmod, a.aqpa705ctsuc,
a.aqpa705cttra, a.aqpa705ctrel, a.aqpa705ctfec, a.aqpa705ctaori, a.aqpa705ctades, a.aqpa705monope, a.aqpa705mdaope, a.aqpa705comope, a.aqpa705auxv1,
a.aqpa705auxv2, a.aqpa705auxv3, a.aqpa705auxv4, a.aqpa705auxv5, a.aqpa705auxn1, a.aqpa705auxn2, a.aqpa705auxn3, a.aqpa705auxn4, a.aqpa705auxn5,
a.aqpa705correo, a.aqpa705archiv, a.aqpa705canal ,a.aqpa705coderr,a.aqpa705msgerr
from AQPA705 a
;

