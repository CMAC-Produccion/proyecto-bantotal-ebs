CREATE OR REPLACE PROCEDURE sp_opca_mensajesporatm(
                           P_N_CODMSJ in number,
                           P_C_CODTER in varchar2,
                           P_C_CODTRX in varchar2,
                           P_D_FECINI in date,
                           P_D_FECFIN in date,
                           P_N_TIPMSJ in number,
                           P_C_CODUSU in varchar2,
                           p_c_coderr out varchar2,
                           p_c_msgerr out varchar2 )
AS
ld_fecini date :=null;
ld_fecfin date :=null;
   BEGIN
      /*ld_fecini := to_date(trim(P_D_FECINI),'dd/mm/yyyy');
      ld_fecfin := to_date(trim(P_D_FECFIN),'dd/mm/yyyy');*/
      pq_reps_operaciones_canales.sp_oc_mensajes_por_atm(p_n_codmsj, p_c_codter, p_c_codtrx, P_D_FECINI, P_D_FECFIN, p_n_tipmsj, p_c_codusu, p_c_coderr, p_c_msgerr);
   END;
/

