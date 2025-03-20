CREATE OR REPLACE FORCE VIEW V_REMUSUA_ZMALLCO_CCO AS
SELECT
A.c_codusu,
A.c_codcma,
A.c_codage,
A.d_fecini,
A.n_diavig,
A.c_tipusu,
A.c_codest,
A.aufecins,
A.auusuins,
A.aufecmod,
A.auusumod,
A.c_numdoc
FROM RENIEC.REMUSUA A;

