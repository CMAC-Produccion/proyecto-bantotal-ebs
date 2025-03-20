create or replace package PQ_AH_MIGRACION_CANALES is

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure SP_AH_MIGRAR_ATMS(p_d_fecpro in date,
                              p_c_coderr out varchar2,
                              p_c_msgerr out varchar2);

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure SP_AH_MIGRAR_RAPICAJAS(p_d_fecpro in date,
                                   p_c_coderr out varchar2,
                                   p_c_msgerr out varchar2);
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

end PQ_AH_MIGRACION_CANALES;
/

