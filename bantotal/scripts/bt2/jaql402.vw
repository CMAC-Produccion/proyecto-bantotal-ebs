create or replace force view jaql402 as
select
"PAN",
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
card@cajero;

