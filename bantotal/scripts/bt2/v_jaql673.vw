create or replace force view v_jaql673 as
select
a.jaql673fetra, a.jaql673hotra, a.jaql673seint, a.jaql673coing, a.jaql673cores, a.jaql673feits, a.jaql673hoits, a.jaql673fefts, a.jaql673hofts,
a.jaql673texti,
decode(a.jaql673nutar,b.Z0E478NRO,substr(a.jaql673nutar,0,6)||'******'||substr(a.jaql673nutar,13,4),a.jaql673nutar) jaql673nutar,
decode(b.z0e478thd,null,null,'****'||substr(trim(b.z0e478thd),5,length(trim(b.z0e478thd))-4)) z0e478thd,
a.jaql673comen, a.jaql673seiso, a.jaql673cotra, a.jaql673fehot, a.jaql673feneg, a.jaql673honeg, a.jaql673inadq, a.jaql673inemi, a.jaql673cored,
a.jaql673nuele, a.jaql673cisot, a.jaql673cisoc, a.jaql673secan, a.jaql673seope, a.jaql673sevar, a.jaql673sefec, a.jaql673sehor, a.jaql673secre,
a.jaql673secrs, a.jaql673gineg, a.jaql673coaut, a.jaql673texto, a.jaql673tiout, a.jaql673tidtr, a.jaql673coire, a.jaql673aux1, a.jaql673aux2,
a.jaql673aux3, a.jaql673aux4, a.jaql673aux5, a.jaql673aux6, a.jaql673aux7, a.jaql673aux8, a.jaql673aux9, a.jaql673aux10, a.jaql673aux11,
a.jaql673aux12, a.jaql673aux13, a.jaql673aux14, a.jaql673aux15, a.jaql673aux16, a.jaql673aux17, a.jaql673aux18
 from JAQL673 a left outer join Z0E478 b
  on a.jaql673nutar=b.Z0E478NRO;

