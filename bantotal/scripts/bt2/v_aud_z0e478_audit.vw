create or replace force view v_aud_z0e478_audit as
select
aud_old_z0e461cod, aud_new_z0e461cod, aud_old_z0e462cod, aud_new_z0e462cod, aud_old_z0e463cod, aud_new_z0e463cod, aud_old_z0e465cod,
aud_new_z0e465cod, aud_old_z0e466cod, aud_new_z0e466cod, aud_old_z0e468cod, aud_new_z0e468cod, aud_old_z0e469cod, aud_new_z0e469cod,
aud_old_z0e477cod, aud_new_z0e477cod, aud_old_z0e478adi, aud_new_z0e478adi, aud_old_z0e478aut, aud_new_z0e478aut, aud_old_z0e478can,
aud_new_z0e478can, aud_old_z0e478cdo, aud_new_z0e478cdo, aud_old_z0e478ceo, aud_new_z0e478ceo, aud_old_z0e478cli, aud_new_z0e478cli,
aud_old_z0e478csa, aud_new_z0e478csa, aud_old_z0e478ctd, aud_new_z0e478ctd, aud_old_z0e478cte, aud_new_z0e478cte, aud_old_z0e478ctt,
aud_new_z0e478ctt, aud_old_z0e478dcd, aud_new_z0e478dcd, aud_old_z0e478dmn, aud_new_z0e478dmn, aud_old_z0e478dmo, aud_new_z0e478dmo,
aud_old_z0e478dop, aud_new_z0e478dop, aud_old_z0e478dpa, aud_new_z0e478dpa, aud_old_z0e478dsc, aud_new_z0e478dsc, aud_old_z0e478dsu,
aud_new_z0e478dsu, aud_old_z0e478dto, aud_new_z0e478dto, aud_old_z0e478est, aud_new_z0e478est, aud_old_z0e478fah, aud_new_z0e478fah,
aud_old_z0e478fal, aud_new_z0e478fal, aud_old_z0e478fas, aud_new_z0e478fas, aud_old_z0e478fau, aud_new_z0e478fau, aud_old_z0e478fbj,
aud_new_z0e478fbj, aud_old_z0e478fbs, aud_new_z0e478fbs, aud_old_z0e478fep, aud_new_z0e478fep, aud_old_z0e478fmd, aud_new_z0e478fmd,
aud_old_z0e478fph, aud_new_z0e478fph, aud_old_z0e478frp, aud_new_z0e478frp, aud_old_z0e478fuh, aud_new_z0e478fuh, aud_old_z0e478fuu,
aud_new_z0e478fuu, aud_old_z0e478fvt, aud_new_z0e478fvt, aud_old_z0e478hba, aud_new_z0e478hba, aud_old_z0e478lex, aud_new_z0e478lex,
aud_old_z0e478lin, aud_new_z0e478lin, aud_old_z0e478nom, aud_new_z0e478nom, aud_old_z0e478nr1, aud_new_z0e478nr1, aud_old_z0e478nr2,
aud_new_z0e478nr2, substr(aud_old_z0e478nro,0,6)||'******'||substr(aud_old_z0e478nro,13,4) aud_old_z0e478nro,
substr(aud_new_z0e478nro,0,6)||'******'||substr(aud_new_z0e478nro,13,4) aud_new_z0e478nro, aud_old_z0e478pes, aud_new_z0e478pes,
aud_old_z0e478pgc, aud_new_z0e478pgc, aud_old_z0e478pla, aud_new_z0e478pla, aud_old_z0e478pls, aud_new_z0e478pls, aud_old_z0e478res,
aud_new_z0e478res, aud_old_z0e478sde, aud_new_z0e478sde, aud_old_z0e478seg, aud_new_z0e478seg, aud_old_z0e478suc, aud_new_z0e478suc,
aud_old_z0e478tcd, aud_new_z0e478tcd, aud_old_z0e478thd, aud_new_z0e478thd, aud_old_z0e478thp, aud_new_z0e478thp, aud_old_z0e478tht,
aud_new_z0e478tht, aud_old_z0e478tip, aud_new_z0e478tip, aud_old_z0e478tnv, aud_new_z0e478tnv, aud_old_z0e478tti, aud_new_z0e478tti,
aud_old_z0e478uau, aud_new_z0e478uau, aud_old_z0e478umd, aud_new_z0e478umd, aud_old_z0e478usr, aud_new_z0e478usr, aud_z0e478_guidkey,
aud_z0e478_uon, aud_z0e478_ut, aud_z0e478_ubr, aud_z0e478_ubc, aud_z0e478_ubt, aud_z0e478_ubu, aud_z0e478_uba, aud_z0e478_ubs,
aud_z0e478_ubp, aud_z0e478_ubm, aud_z0e478_uas
from AUD_Z0E478_AUDIT;

