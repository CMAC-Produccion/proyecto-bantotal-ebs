create or replace force view v_jaql540_saybar_precon as
select a.jaql540comsj, a.jaql540cotra, a.jaql540coing, a.jaql540cores, a.jaql540feini, a.jaql540hoini, a.jaql540fefin, a.jaql540hofin,
a.jaql540coter, a.jaql540cotrx, a.jaql540nutra, a.jaql540tmout, a.jaql540relac, a.jaql540trans, a.jaql540modul, a.jaql540paist,
substr(a.jaql540nutar,0,6)||'******'||substr(a.jaql540nutar,13,4) jaql540nutar,
decode(b.z0e478thd,null,null,'****'||substr(trim(b.z0e478thd),5,length(trim(b.z0e478thd))-4)) z0e478thd,
a.jaql540userc, a.jaql540coref, a.jaql540auxd2, a.jaql540auxv2, a.jaql540auxv1, a.jaql540auxn2, a.jaql540auxn1,
a.jaql540auxc2, a.jaql540auxc1, a.jaql540trama, a.jaql540fetra
 from JAQL540 a left outer join Z0E478 b
  on a.jaql540nutar=trim(b.Z0E478NRO);

