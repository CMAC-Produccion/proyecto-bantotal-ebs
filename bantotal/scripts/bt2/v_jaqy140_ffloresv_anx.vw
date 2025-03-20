create or replace force view v_jaqy140_ffloresv_anx as
select
jaqy140corr,
jaqy140pais,
jaqy140tdoc,
jaqy140tcamb,
jaqy140inst,
jaqy140fec,
jaqy140capcaja,
jaqy140sldext,
jaqy140resnet,
jaqy140ratio,
jaqy140ind,
jaqy140est,
jaqy140hora,
jaqy140user,
jaqy140ccontg,
jaqy140cpoten,
jaqy140tarea,
jaqy140indme,
jaqy140instcrd,
jaqy140evalme
from JAQY140
 /* GOLDENGATE_DDL_REPLICATION */;

