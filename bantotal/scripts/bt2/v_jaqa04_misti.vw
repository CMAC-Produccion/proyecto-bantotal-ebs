create or replace force view v_jaqa04_misti as
select
a.jaqa04regi,
a.jaqa04zona,
a.jaqa04agen,
a.jaqa04fein,
a.jaqa04cbrt,
a.jaqa04mvsa,
a.jaqa04vsbr,
a.jaqa04ncto,
a.jaqa04ncli,
a.jaqa04mvcl,
a.jaqa04vcbr,
a.jaqa04pjat,
a.jaqa04catr,
a.jaqa04mvmo,
a.jaqa04vmsb,
a.jaqa04pjmt,
a.jaqa04scmt,
-- a.jaqa04sjud,
a.jaqa04vmcb,
a.jaqa04vmcl,
a.jaqa04vmpa,
a.jaqa04vmat,
a.jaqa04vdcb,
a.jaqa04vdcl,
a.jaqa04vdpa,
a.jaqa04vdat,
a.jaqa04vmju,
a.jaqa04mcju,
a.jaqa04num1,
a.jaqa04num2,
a.jaqa04num3,
a.jaqa04imp1,
a.jaqa04imp2,
a.jaqa04imp3,
a.jaqa04cha1,
a.jaqa04cha2,
a.jaqa04cha3,
a.jaqa04fec1,
a.jaqa04fec2,
a.jaqa04fec3,
a.jaqa04imp8,
a.jaqa04imp7,
a.jaqa04imp6,
a.jaqa04imp5,
a.jaqa04imp4,
a.jaqa04cmnc,
a.jaqa04cmcb
from JAQA04 a
;

