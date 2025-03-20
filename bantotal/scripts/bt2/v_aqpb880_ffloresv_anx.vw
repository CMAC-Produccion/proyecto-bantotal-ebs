create or replace force view v_aqpb880_ffloresv_anx as
select
aqpb880fpr,
ri105cod,
ri105suc,
ri105mod,
ri105rub,
ri105mda,
ri105pap,
ri105cta,
ri105oper,
ri105sbop,
ri105tope,
ri105imp,
ri105coef,
ri105prev,
ri105cat,
ri105aux1,
ri105aux2,
ri105aux3,
ri105aux4,
ri105aux5,
ri105aux6,
ri105aux7,
ri105aux8
from AQPB880
 /* GOLDENGATE_DDL_REPLICATION */;

