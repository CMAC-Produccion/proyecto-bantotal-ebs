create or replace force view v_z0e4gc as
select
a.z0e4gcapl, a.z0e4gcban, a.z0e4gccor, a.z0e4gcco2, a.z0e4gcter, substr(a.z0e4gctar,0,6)||'******'||substr(a.z0e4gctar,13,4) z0e4gctar,
a.z0e4gcfec, a.z0e4gchor, a.z0e4gcesm, a.z0e4gcorj, a.z0e4gcfne, a.z0e4gctop, a.z0e4gcdpg, a.z0e4gcdsu, a.z0e4gcdmd, a.z0e4gcdmo,
a.z0e4gcdpa, a.z0e4gcdct, a.z0e4gcdsc, a.z0e4gcdto, a.z0e4gcdop, a.z0e4gccpg, a.z0e4gcsu, a.z0e4gccmd, a.z0e4gccmo, a.z0e4gccpa,
a.z0e4gccct, a.z0e4gccsc, a.z0e4gccto, a.z0e4gccop, a.z0e4gcimd, a.z0e4gcimc, a.z0e4gcsdd, a.z0e4gccot, a.z0e4gcmda, a.z0e4gcemp,
a.z0e4gcsuc, a.z0e4gcmod, a.z0e4gctrn, a.z0e4gcrel, a.z0e4gcest, a.z0e4gctxt, a.z0e4gcmnc, a.z0e4gccnl, a.z0e4gcope, a.z0e4gcvar,
a.z0e4gcfsv, a.z0e4gchsv, a.z0e4gcrsv, a.z0e4gcnsb, a.z0e4gcori, a.z0e4gctdd, a.z0e4gcnse, a.z0e4gcred, a.z0e4gcfim
from Z0E4GC a;

