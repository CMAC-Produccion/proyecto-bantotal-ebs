CREATE OR REPLACE PROCEDURE migracion(
                           p_c_codopc in varchar2,
                           p_d_fecpro in date,
                           p_c_coderr out varchar2,
                           p_c_msgerr out varchar2)
AS
   BEGIN
      DELETE FROM jaql534;
      commit;
      if p_c_codopc = '001' then
             pq_ah_migracion_canales.SP_AH_MIGRAR_ATMS(p_d_fecpro, p_c_coderr, p_c_msgerr);
      else
             pq_ah_migracion_canales.SP_AH_MIGRAR_RAPICAJAS(p_d_fecpro, p_c_coderr, p_c_msgerr);
      end if;
   END;
/

