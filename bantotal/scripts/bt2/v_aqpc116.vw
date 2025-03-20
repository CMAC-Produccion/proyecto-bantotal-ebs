create or replace force view v_aqpc116 as
select
aqpc116serenv, aqpc116canenv, aqpc116fecenv, aqpc116horenv, aqpc116indice1, aqpc116indice2, aqpc116indice3, aqpc116indice4, aqpc116indice5,
aqpc116indice6, aqpc116indice7, aqpc116indice8, aqpc116indice9, aqpc116indice10,
decode(a.aqpc116indice11,b.Z0E478NRO,substr(a.aqpc116indice11,0,6)||'******'||substr(a.aqpc116indice11,13,4),a.aqpc116indice11) aqpc116indice11,
decode(b.z0e478thd,null,null,'****'||substr(trim(b.z0e478thd),5,length(trim(b.z0e478thd))-4)) z0e478thd,
aqpc116indice12, aqpc116indice13, aqpc116indice14, aqpc116indice15, aqpc116indice16, aqpc116indice17, aqpc116indice18, aqpc116indice19,
aqpc116indice20, aqpc116indice21, aqpc116indice22, aqpc116indice23,
aqpc116indice24,     aqpc116indice25, aqpc116indice26, aqpc116indice27, aqpc116indice28, aqpc116indice29, aqpc116indice30, aqpc116indice31,
aqpc116indice32, aqpc116indice33, aqpc116indice34, aqpc116indice35, aqpc116indice36, aqpc116indice37, aqpc116indice38, aqpc116indice39,
aqpc116indice40, aqpc116indice41, aqpc116indice42, aqpc116indice43, aqpc116indice44, aqpc116indice45, aqpc116indice46,
aqpc116indice47, aqpc116indice48, aqpc116indice49, aqpc116indice50,
aqpc116indice51, aqpc116indice52, aqpc116indice53, aqpc116indice54, aqpc116indice55, aqpc116indice56, aqpc116indice57, aqpc116indice58,
aqpc116indice59, aqpc116indice60, aqpc116indice61, aqpc116indice62, aqpc116indice63, aqpc116indice64, aqpc116indice65, aqpc116indice66,
aqpc116indice67,
aqpc116indice68, aqpc116indice69, aqpc116indice70, aqpc116indice71, aqpc116indice72, aqpc116indice73, aqpc116indice74, aqpc116indice75,
aqpc116indice76, aqpc116indice77, aqpc116indice78, aqpc116indice79, aqpc116indice80,
aqpc116indice81,aqpc116indice82, aqpc116indice83, aqpc116indice84, aqpc116indice85, aqpc116indice86, aqpc116indice87, aqpc116indice88, aqpc116indice89, aqpc116indice90, aqpc116indice91
from AQPC116 a left outer join Z0E478 b
  on a.aqpc116indice11=b.Z0E478NRO;

