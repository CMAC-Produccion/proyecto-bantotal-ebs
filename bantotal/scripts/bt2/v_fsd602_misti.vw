create or replace force view v_fsd602_misti as
select
a.pgcod,
a.ppmod,
a.ppsuc,
a.ppmda,
a.pppap,
a.ppcta,
a.ppoper,
a.ppsbop,
a.pptope,
a.ppfpag,
a.pptipo,
a.pp1nump,
a.pp1fech,
a.pp1cap,
a.pp1int,
a.pp1intmex,
a.pp1intm,
a.pp1intmmex,
a.pp1icap,
a.pp1iint,
a.pp1iintm,
--a.pp1salcap,
--a.pp1salint,
--a.pp1salade,
--a.pp1salmor,
a.pp1stat,
a.pp1salintm,
--a.--pp1salmorm,
a.pp1saladem,
a.d602cd,
a.d602mo,
a.d602su,
a.d602tr,
a.d602re,
a.d602fc,
a.d602or,
a.d602sb,
a.d602co
from FSD602 a
;

