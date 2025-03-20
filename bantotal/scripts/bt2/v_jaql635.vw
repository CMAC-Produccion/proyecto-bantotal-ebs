create or replace force view v_jaql635 as
select
n_serenv,
c_canenv,
d_fecenv,
c_horenv,
/*substr(c_trmenv,0,37)||substr(c_trmenv,38,6)||'******'||substr(c_trmenv,50,4)||
substr(c_trmenv,54,127) ||substr(c_trmenv,181,6)||'******'||substr(c_trmenv,193,4)||
substr(c_trmenv,197,583)||substr(c_trmenv,780,6)||'******'||substr(c_trmenv,792,4000) c_trmenv,*/
bantprod.FN_CC_REPLACE_TRAMA_JAQL540(C_TRMENV) C_TRMENV,
c_obsenv,
c_auxvc1,
c_auxvc2,
c_auxvc3,
n_auxnu1,
n_auxnu2,
n_auxnu3,
d_auxda1,
d_auxda2,
d_auxda3
from JAQL635;

