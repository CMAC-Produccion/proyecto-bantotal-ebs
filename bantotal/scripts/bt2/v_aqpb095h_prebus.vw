create or replace force view v_aqpb095h_prebus as
select
a.AQPB095HUSUR,
a.AQPB095HCTA,
a.AQPB095HOPE,
a.AQPB095HSDOI,
a.AQPB095HFPROC,
a.AQPB095HMHONR
from AQPB095H a;

