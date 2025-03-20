CREATE OR REPLACE TYPE "TYPE_REPRO_DATOS"
as object (
	  v_flag  char(2),
      v_nrep  number(6),
      v_fech  date,
      v_tabla varchar2(20),
      v_peri  number(6),
      v_ncuo  number(6),
      v_fpri  date,
      v_fult  date
)
/

