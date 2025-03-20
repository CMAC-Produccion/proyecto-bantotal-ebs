CREATE OR REPLACE FORCE VIEW JAQL100 AS
SELECT "REGFCHPAG",
       "REGNROREC",
       "REGIDPAGBT",
       "REGCIACOD",
       "CIADES",
       "REGCPAGCOD",
       "NOMALU",
       "REGPRDOCOD",
       "REGSPDOCOD",
       "REGTIPMONCOD",
       "REGMONTO",
       "MORA",
       "COMISION",
       "SPDONOM",
       "CIAFAX",
       "XSPDONOM",
       decode("SPDONOM", 'LIBRE', trunc(sysdate), to_date("SPDONOM", 'dd/mm/yyyy')) subpe
  from JAQL100@cole;

