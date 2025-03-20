CREATE OR REPLACE FORCE VIEW V_FJAPR1_FFLORESV_ANX AS
SELECT
japr1tdoc,
japr1pdoc,
japr1cat1,
japr1cat2,
japr1cat3,
japr1cat4,
japr1cat5,
japr1cat6,
japr1catac,
japr1fsfin,
japr1finst,
japr1finf,
japr1tinf,
japr1tsfin,
japr1tinst,
japr1tact
FROM FJAPR1
 /* GOLDENGATE_DDL_REPLICATION */;

