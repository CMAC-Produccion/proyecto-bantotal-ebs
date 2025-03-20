create or replace force view v_jaql638 as
select
a.jaql638fepro, a.jaql638seria, a.jaql638hopro, a.jaql638numrp, a.jaql638estad, a.jaql638cmp01, a.jaql638cmp02, a.jaql638cmp03,
a.jaql638cmp04, a.jaql638cmp05, a.jaql638cmp06,
decode(a.JAQL638CMP07,substr(b.Z0E478NRO,1,16),substr(a.JAQL638CMP07,0,6)||'******'||substr(a.JAQL638CMP07,13,4),a.JAQL638CMP07) JAQL638CMP07,
decode(b.z0e478thd,null,null,'****'||substr(trim(b.z0e478thd),5,length(trim(b.z0e478thd))-4)) z0e478thd,
a.jaql638cmp08, a.jaql638cmp09, a.jaql638cmp10, a.jaql638cmp11, a.jaql638cmp12, a.jaql638cmp13, a.jaql638cmp14, a.jaql638cmp15,
a.jaql638cmp16, a.jaql638cmp17, a.jaql638cmp18, a.jaql638cmp19, a.jaql638cmp20, a.jaql638cmp21, a.jaql638cmp22, a.jaql638cmp23,
a.jaql638cmp24, a.jaql638cmp25, a.jaql638cmp26, a.jaql638cmp27, a.jaql638cmp28, a.jaql638cmp29, a.jaql638cmp30, a.jaql638cmp31,
a.jaql638cmp32, a.jaql638cmp33, a.jaql638cmp34, a.jaql638cmp35, a.jaql638cmp36, a.jaql638cmp37, a.jaql638cmp38, a.jaql638cmp39,
a.jaql638cmp40, a.jaql638cmp41, a.jaql638cmp42, a.jaql638cmp43, a.jaql638cmp44, a.jaql638cmp45, a.jaql638cmp46, a.jaql638cmp47,
a.jaql638cmp48, a.jaql638cmp49, a.jaql638cmp50, a.jaql638cmp51, a.jaql638cmp52, a.jaql638cmp53, a.jaql638cmp54, a.jaql638cmp55,
a.jaql638cmp56, a.jaql638cmp57, a.jaql638cmp58, a.jaql638cmp59, a.jaql638cmp60, a.jaql638cmp61, a.jaql638cmp62, a.jaql638cmp63,
a.jaql638cmp64, a.jaql638cmp65, a.jaql638cmp66, a.jaql638cmp67, a.jaql638cmp68, a.jaql638cmp69, a.jaql638cmp70, a.jaql638cmp71,
a.jaql638cmp72, a.jaql638cmp73, a.jaql638cmp74, a.jaql638cmp75, a.jaql638cmp76, a.jaql638cmp77, a.jaql638cmp78, a.jaql638cmp79,
a.jaql638cmp80, a.jaql638cmp81, a.jaql638cmp82, a.jaql638cmp83, a.jaql638cmp84, a.jaql638cmp85, a.jaql638cmp86, a.jaql638cmp87,
a.jaql638cmp88, a.jaql638cmp89, a.jaql638cmp90, a.jaql638cmp91, a.jaql638cmp92, a.jaql638cmp93, a.jaql638cmp94, a.jaql638cmp95,
a.jaql638cmp96, a.jaql638cmp97, a.jaql638cmp98, a.jaql638cmp99, a.jaql638auxf1, a.jaql638auxf2, a.jaql638auxf3, a.jaql638auxv1,
a.jaql638auxv2, a.jaql638auxv3, a.jaql638auxn1, a.jaql638auxn2, a.jaql638auxn3
from JAQL638 a left outer join Z0E478 b
  on rpad(a.JAQL638CMP07,19,' ')=b.Z0E478NRO;

