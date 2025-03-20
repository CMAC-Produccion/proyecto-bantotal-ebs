CREATE OR REPLACE PROCEDURE sp_opca_transacciones_uba(
                           P_C_TIPROL in varchar2,
                           P_C_TIPREP in varchar2,
                           P_C_CODTRX in varchar2,
                           P_D_FECINI in varchar2,
                           P_D_FECFIN in varchar2,
                           P_C_CODUSU in varchar2,
                           p_c_coderr out varchar2,
                           p_c_msgerr out varchar2 )

AS
ld_fecini date :=null;
ld_fecfin date :=null;
   BEGIN
      ld_fecini := to_date(trim(P_D_FECINI),'dd/mm/yy');
      ld_fecfin := to_date(trim(P_D_FECFIN),'dd/mm/yy');
      pq_reps_operaciones_canales.sp_oc_transacciones_autor_uba(p_c_tiprol, p_c_tiprep, p_c_codtrx, ld_fecini, ld_fecfin, p_c_codusu, p_c_coderr, p_c_msgerr);
   END;
/

