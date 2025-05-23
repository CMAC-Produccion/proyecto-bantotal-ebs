create or replace force view v_aqpb118 as
select
aqpb118fetra,
aqpb118hotra,
aqpb118seint,
aqpb118coing,
aqpb118cores,
aqpb118feits,
aqpb118hoits,
aqpb118fefts,
aqpb118hofts,
aqpb118texti,
--aqpb118nutar, ---
substr(a.aqpb118nutar,0,6)||'******'||substr(a.aqpb118nutar,13,4) aqpb118nutar,
decode(b.z0e478thd,null,null,'****'||substr(trim(b.z0e478thd),5,length(trim(b.z0e478thd))-4)) z0e478thd,
aqpb118comen,
aqpb118descme,
aqpb118seiso,
aqpb118cotra,
aqpb118destra,
aqpb118fehot,
aqpb118feneg,
aqpb118honeg,
aqpb118inadq,
aqpb118inemi,
aqpb118cored,
aqpb118nuele,
aqpb118cisot,
aqpb118cisoc,
aqpb118secan,
aqpb118seope,
aqpb118sevar,
aqpb118sefec,
aqpb118sehor,
aqpb118secre,
aqpb118secrs,
aqpb118gineg,
aqpb118coaut,
aqpb118texto,
aqpb118tiout,
aqpb118tidtr,
aqpb118coire,
aqpb118aux1,
aqpb118aux2,
aqpb118aux3,
aqpb118aux4,
aqpb118aux5,
aqpb118aux6,
aqpb118aux7,
aqpb118aux8,
aqpb118aux9,
aqpb118aux10,
aqpb118aux11,
aqpb118aux12,
aqpb118aux13,
aqpb118aux14,
aqpb118aux15,
aqpb118aux16,
aqpb118aux17,
aqpb118aux18
from AQPB118 a left outer join Z0E478 b
  on a.aqpb118nutar=b.Z0E478NRO
;

