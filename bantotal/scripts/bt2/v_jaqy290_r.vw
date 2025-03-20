create or replace force view v_jaqy290_r as
select
jaqy290_remp, jaqy290_rcod, jaqy290_rage, jaqy290_rani, jaqy290_rtri, jaqy290_rcor, jaqy290_rpac, jaqy290_rtdc, jaqy290_rndc,
jaqy290_rusr, jaqy290_rfcr, jaqy290_rusp, jaqy290_rfcp, jaqy290_rusc, jaqy290_rfcc, jaqy290_rops, jaqy290_rmot, jaqy290_resr,
jaqy290_rflc, jaqy290_rfld, jaqy290_rcmr, jaqy290_rcms, jaqy290_rest, jaqy290_rvir, jaqy290_repr,
--jaqy290_rnum,
case
  when jaqy290_rnum like '4261%' then
       trim(substr(trim(jaqy290_rnum),0,6)||'******'||substr(trim(jaqy290_rnum),13,4)||substr(trim(jaqy290_rnum),17,27))
  else jaqy290_rnum
  end jaqy290_rnum,
jaqy290_rdoc, jaqy290_rprc, jaqy290_rmen, jaqy290_rvrp, jaqy290_rtap, jaqy290_rpaa, jaqy290_rtda, jaqy290_rnda, jaqy290_rtrc,
jaqy290_rdir, jaqy290_rref, jaqy290_rubg, jaqy290_rweb, jaqy290_redt, jaqy290_reml, jaqy290_rtlf, jaqy290_ract, jaqy290_rcar,
jaqy290_rcel, jaqy290_rfda, jaqy290_rusa, jaqy290_rara, jaqy290_raga, jaqy290_rfra, jaqy290_rrra, jaqy290_rdaa, jaqy290_rcra,
jaqy290_rhcr, jaqy290_rapp, jaqy290_rapm, jaqy290_rnom, jaqy290_rnoj, jaqy290_rhor, jaqy290_rdlc, jaqy290_rubc
from JAQY290_R
;

