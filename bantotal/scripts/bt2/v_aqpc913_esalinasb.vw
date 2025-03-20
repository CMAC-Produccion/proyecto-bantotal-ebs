CREATE OR REPLACE FORCE VIEW V_AQPC913_ESALINASB AS
SELECT

aqpc913id,
aqpc913trama,
aqpc913fecreg,
aqpc913horreg,
aqpc913tipdis,
--aqpc913imei,
aqpc913tiping,
--aqpc913clave,
--aqpc913bloqt,
--aqpc913nrotar,
aqpc913paidoc,
aqpc913tipdoc,
aqpc913numdoc,
aqpc913nomcli,
--aqpc913so,
--aqpc913modelo,
--aqpc913deviceid,
aqpc913lat,
aqpc913long,
aqpc913codprc
from bantprod.AQPC913
;

