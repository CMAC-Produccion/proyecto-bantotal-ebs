CREATE OR REPLACE PROCEDURE SP_BI_MATERIALIZED_VIEWS IS
  -- ---------------------------------------------------------------------------
  -- Nombre                   : SP_BI_MATERIALIZED_VIEWS
  -- Sistema                  : BANTOTAL
  -- Módulo                   : BANTOTAL
  -- Versión                  : 1.0
  -- Fecha de Creación        : 2025.03.19
  -- Autor de Creación        : Erika V. Hidalgo Málaga
  -- Uso                      : Creación de Vistas materializadas para BI
  -- Estado                   : Activo
  -- Acceso                   : Público
  -- Fecha de Modificación    : 
  -- Autor de Modificación    : 
  -- Descripción Modificación : 
  -- ---------------------------------------------------------------------------
  FECPRO_RRRRMMDD VARCHAR2(8) := to_char(sysdate-1,'RRRRMMDD');
BEGIN

--REFRESH VM_JAQZ205BI 25s
BEGIN
  DBMS_MVIEW.REFRESH('VM_JAQZ205BI');
  DBMS_MVIEW.REFRESH('VM_Z0E478CRM');
  DBMS_MVIEW.REFRESH('V_TARJETAS_BT',parallelism => 8);
  DBMS_MVIEW.REFRESH('VM_JAQL674BI',parallelism => 8);
  DBMS_MVIEW.REFRESH('VM_AQPA705');
  DBMS_MVIEW.REFRESH('VM_JAQZ205_208_BI',parallelism => 8);--2025.01.22
END;

begin
 execute immediate 'drop materialized view vm_jaqz208_bih';
exception when others then null;
end;

execute immediate 'create materialized view vm_jaqz208_bih tablespace bantprod_b
BUILD IMMEDIATE
REFRESH on demand
as
SELECT /*+ALL_ROWS PARALLEL(A,20) PARALLEL(B,20)*/
 A.JAQZ208SEINT,
 A.JAQZ208FETRA,
 A.JAQZ208HOTRA,
 A.JAQZ208CORES,
 A.JAQZ208FEITS,
 A.JAQZ208HOITS,
 DECODE(B.Z0E478THD, NULL, NULL, B.Z0E478THP) Z0E478THP,
 DECODE(B.Z0E478THD, NULL, NULL, B.Z0E478THT) Z0E478THT,
 DECODE(B.Z0E478THD, NULL, NULL, B.Z0E478THD) Z0E478THD,
 A.JAQZ208COTRA,
 A.JAQZ208FEFTS,
 A.JAQZ208HOFTS,
 A.JAQZ208SEFEC,
 A.JAQZ208SEHOR,
 A.JAQZ208SECRE,
 A.JAQZ208SECRS
  FROM JAQZ208H@BTHIST A
  LEFT OUTER JOIN Z0E478 B
    ON A.JAQZ208NUTAR = B.Z0E478NRO
 WHERE A.JAQZ208COTRA = ''100042''
   AND A.JAQZ208SECRS = ''00000''
   AND A.JAQZ208FETRA BETWEEN TRUNC(TRUNC(TO_DATE('''||FECPRO_RRRRMMDD||''',''YYYYMMDD''),''MM'')-1,''MM'') AND TRUNC(SYSDATE-1)';

begin
execute immediate 'drop materialized view vm_jaqz208_bi';
exception when others then null;
end;
execute immediate 'create materialized view vm_jaqz208_bi tablespace bantprod_b
BUILD IMMEDIATE
REFRESH on demand
as
select /*+all_rows parallel(a,20) parallel(b,20)*/
 a.jaqz208seint,
 a.jaqz208fetra,
 a.jaqz208hotra,
 a.jaqz208cores,
 a.jaqz208feits,
 a.jaqz208hoits,
 decode(b.z0e478thd, null, null, b.Z0E478THP) Z0E478THP,
 decode(b.z0e478thd, null, null, b.Z0E478THT) Z0E478THT,
 decode(b.z0e478thd, null, null, b.z0e478thd) z0e478thd,
 a.jaqz208cotra,
 a.jaqz208fefts,
 a.jaqz208hofts,
 a.jaqz208sefec,
 a.jaqz208sehor,
 a.jaqz208secre,
 a.jaqz208secrs
  from JAQZ208 a
  left outer join Z0E478 b
    on a.jaqz208nutar = b.Z0E478NRO
 where a.JAQZ208COTRA = ''100042''
   AND a.JAQZ208SECRS = ''00000''
   AND A.JAQZ208FETRA BETWEEN TRUNC(TRUNC(TO_DATE('''||FECPRO_RRRRMMDD||''',''YYYYMMDD''),''MM'')-1,''MM'') AND TRUNC(SYSDATE-1)';

execute immediate 'grant select on vm_jaqz208_bi to usrrepbi';
execute immediate 'grant select on vm_jaqz208_bih to usrrepbi';

execute immediate 'create or replace synonym usrrepbi.jaqz208 for bantprod.vm_jaqz208_bi';
execute immediate 'create or replace synonym usrrepbi.jaqz208h for bantprod.vm_jaqz208_bih';

--2025.03.17
begin
execute immediate 'drop materialized view VM_JAQZ208_BI2';
exception when others then null;
end;
execute immediate 'create materialized view BANTPROD.VM_JAQZ208_BI2 tablespace bantprod_b
BUILD IMMEDIATE
REFRESH on demand
as
select /*+all_rows parallel(a,20) parallel(b,20)*/
a.jaqz208seint,
a.jaqz208fetra,
a.jaqz208hotra,
a.jaqz208cores,
a.jaqz208feits,
a.jaqz208hoits,
decode(b.z0e478thd, null, null, b.Z0E478THP) Z0E478THP,
decode(b.z0e478thd, null, null, b.Z0E478THT) Z0E478THT,
decode(b.z0e478thd, null, null, b.z0e478thd) z0e478thd,
a.jaqz208cotra,
a.jaqz208fefts,
a.jaqz208hofts,
a.jaqz208sefec,
a.jaqz208sehor,
a.jaqz208secre,
a.jaqz208secrs,
a.JAQZ208CANAL, 
 a.JAQZ208DETALLE
  from JAQZ208 a
  left outer join Z0E478 b
    on a.jaqz208nutar = b.Z0E478NRO
where A.JAQZ208FETRA BETWEEN TRUNC(TRUNC(TO_DATE('''||FECPRO_RRRRMMDD||''',''YYYYMMDD''),''MM'')-1,''MM'') AND TRUNC(SYSDATE-1)';


execute immediate 'grant select on VM_JAQZ208_BI2 to KCHUQIPAL,USRREPBI,PROCEBI,USRPROCBI';
execute immediate 'create or replace synonym KCHUQIPAL.jaqz208_bi2 for bantprod.VM_JAQZ208_BI2';
execute immediate 'create or replace synonym usrrepbi.jaqz208_bi2 for bantprod.VM_JAQZ208_BI2';
execute immediate 'create or replace synonym PROCEBI.jaqz208_bi2 for bantprod.VM_JAQZ208_BI2';
execute immediate 'create or replace synonym USRPROCBI.jaqz208_bi2 for bantprod.VM_JAQZ208_BI2';

END SP_BI_MATERIALIZED_VIEWS;
/
