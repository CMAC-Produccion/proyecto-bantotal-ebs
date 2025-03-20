CREATE OR REPLACE FORCE VIEW V_WFUSERS_ZMALLCO_CCO AS
SELECT
A.wfusrcod,
A.wfusrname,
A.wfusremail,
A.wfcalid,
A.wfusrprccal,
A.wfusracclev,
A.wfusrusub,
A.wfusrrsub,
A.wfusrout,
A.wfusrautbck,
A.wfusrsh,
A.wfusrexptime,
A.wfusrlstcon,
A.wfusrbloc,
A.wflngid,
A.wfusrrblreq,
A.wfusrinternal
FROM WFUSERS A;

