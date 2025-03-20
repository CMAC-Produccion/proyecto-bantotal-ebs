create or replace force view v_jaql402 as
select
--"PAN",
substr(PAN,0,6)||'******'||substr(PAN,13,4) "PAN",
"BIN",
"TRACKING",
"USEOFFSET",
"OFFSET",
"RETRIES",
"BATCH",
"DATEIN",
"DATELAST",
"DATEACT",
"WDDATE",
"TRACK2",
"BIRTHDATE",
"BPHONE"
from
card@cajero
;

