CREATE OR REPLACE FORCE VIEW V_WFWRKITEMS_FFLORESV_ANX AS
SELECT
wfitemid,
wfinsprcid,
wfitemrolcod,
wfiteminit,
wfitemend,
wfstscod,
wfitemstsact,
wfitemwrn,
wfitemdln,
wfitemwrntime,
wfitemdlntime,
wfitemprcurn,
wfitemprvsta,
wfitemprvtask,
wfitempty,
wfprcid
/*,wfitemusrname,
wfitemusrout*/
FROM WFWRKITEMS
 /* GOLDENGATE_DDL_REPLICATION */;

