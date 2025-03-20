create or replace force view v_jaqy252 as
select /*jaqy252nutar, */
substr(a.jaqy252nutar,0,6)||'******'||substr(a.jaqy252nutar,13,4) jaqy252nutar,
jaqy252feint,
jaqy252hoint,
jaqy252nuint,
jaqy252nucan,
jaqy252usint
 from jaqy252 a;

