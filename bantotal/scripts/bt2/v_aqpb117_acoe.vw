CREATE OR REPLACE FORCE VIEW V_AQPB117_ACOE AS
SELECT
AQPB117FECHA,
AQPB117HOR,
--AQPB117NUTAR,
AQPB117THD,
AQPB117PTO,
AQPB117PPC,
AQPB117PBCC,
AQPB117TEXT,
AQPB117PFROM,
AQPB117ASUN
--AQPB117CODERR,
--AQPB117MSJERR,
--AQPB117CANAL
 FROM AQPB117
 /* GOLDENGATE_DDL_REPLICATION */
;

