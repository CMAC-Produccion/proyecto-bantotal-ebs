CREATE OR REPLACE FORCE VIEW V_FSD008_ZMALLCO_CCO AS
SELECT
A.pgcod,
A.ctnro,
A.ctnom,
A.ctresi,
A.ctejct,
A.ctccli,
A.ctfalt,
A.ctrcor,
A.ctcorp,
A.seccod,
A.ctifin,
A.ctngte,
A.ctcbcu,
A.ctnroi,
A.ctcrie,
A.ctempl,
A.ctprov,
A.ctfbaj,
A.ctfcnf,
A.ctimab,
A.ctsegm
FROM FSD008 A;

