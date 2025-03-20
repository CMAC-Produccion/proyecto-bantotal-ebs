CREATE OR REPLACE FORCE VIEW V_X9996D AS
SELECT
a.x9996acnco, a.x9996dfesv, a.x9996dhosv, a.x9996drqsv, a.x9996dfecl, a.x9996dhocl,
case
  when a.X9996Drqcl like '4261%' then
       trim(substr(trim(a.X9996Drqcl),0,6)||'******'||substr(trim(a.X9996Drqcl),13,4)||substr(trim(a.X9996Drqcl),17,50))
  when substr(a.X9996Drqcl,14,4) like '4261%' then
       trim(substr(trim(a.X9996Drqcl),0,20)||'******'||substr(trim(a.X9996Drqcl),27,4)||substr(trim(a.X9996Drqcl),32,50))
  else a.X9996Drqcl
  end X9996Drqcl,
decode(b.z0e478thd,null,null,'****'||substr(trim(b.z0e478thd),5,length(trim(b.z0e478thd))-4)) z0e478thd,
a.x9996bopco, a.x9996cvart, a.x9996drqus, a.x9996drqws, a.x9996ddpgc, a.x9996ddsuc, a.x9996ddmod, a.x9996ddmda, a.x9996ddpap,
a.x9996ddcta, a.x9996ddope, a.x9996ddsbo, a.x9996ddtop, a.x9996dcpgc, a.x9996dcsuc, a.x9996dcmod, a.x9996dcmda, a.x9996dcpap,
a.x9996dccta, a.x9996dcope, a.x9996dcsbo, a.x9996dctop, a.x9996dimpo, a.x9996dimp2, a.x9996dmdao, a.x9996dcotz, a.x9996grsco,
a.x9996drpgc, a.x9996drsuc, a.x9996drmod, a.x9996drtrn, a.x9996drrel, a.x9996drmnc, a.x9996drsdo, a.x9996drsdd
from X9996D a left outer join Z0E478 b
  on (substr(trim(a.X9996DRQCL),0,16) = trim(b.Z0E478NRO));

