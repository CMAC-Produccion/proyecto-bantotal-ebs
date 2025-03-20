create or replace force view v_rnpe06_dw as
select
a.rnpe06emp,
a.rnpe06fch,
a.rnpe06inf,
a.rnpe06pai,
a.rnpe06tdc,
a.rnpe06ndc,
a.rnpe06cta,
--a.rnpe06id1,
--a.rnpe06id2,
--a.rnpe06id3,
--a.rnpe06ciu,
a.rnpe06ims,
a.rnpe06imn,
a.rnpe06ime
from RNPE06 a
;

