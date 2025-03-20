CREATE OR REPLACE PACKAGE pq_datos_personas IS
  FUNCTION fn_pais_documento(p_c_codper VARCHAR2,
                             p_c_tipper VARCHAR2,
                             p_c_tipdoc VARCHAR2) RETURN NUMBER;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  FUNCTION fn_tipo_documento(p_c_codper VARCHAR2) RETURN NUMBER;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  FUNCTION fn_es_inst_financiera(p_c_codper VARCHAR2) RETURN CHAR;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_ap_patmat_nom_priseg(lc_codper in varchar2,
                                    lc_apepat out varchar2,
                                    lc_apemat out varchar2,
                                    lc_prinom out varchar2,
                                    lc_segnom out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_apnom_padres_apnom_conyu(lc_codper in varchar2,
                                        lc_apepad out varchar2,
                                        lc_apemad out varchar2,
                                        lc_nompad out varchar2,
                                        lc_nommad out varchar2,
                                        lc_apecyg out varchar2,
                                        lc_nomcyg out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  FUNCTION fn_indicador_trabajador(lc_codper IN VARCHAR2) RETURN CHAR;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_fecha_inicio_trabajador(lc_codper in varchar2) return date;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_sexo(lc_codper in varchar2) return char;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_ultima_agedep(lc_codper in varchar2) return varchar2;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_ultima_agecre(lc_codper in varchar2) return varchar2;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  FUNCTION fn_estado_civil(lc_codper IN VARCHAR2) RETURN CHAR;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_lugar_nacimiento(lc_codper in varchar2) return char;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_pais_nacimiento(lc_codper in varchar2) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_nivel_educacion(lc_codper in varchar2) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_profesion(lc_codper in varchar2) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_ocupacion(lc_codper in varchar2) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  --function fn_vinculo(lc_codper in varchar2) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_cantidad_hijos(lc_codper in varchar2) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  function fn_conyugue(lc_codper in varchar2) return varchar2;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  function fn_fec_fallecido(lc_codper in varchar2) return date;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
  function fn_nat_juridica(lc_codper in varchar2) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  function fn_fecha_inscripcion(lc_codper in varchar2) return date;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  function fn_nro_de_registro(lc_codper in varchar2) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  FUNCTION fn_tipo_ins_financiera(p_c_codper IN VARCHAR2) RETURN number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  FUNCTION fn_ciudad_ubigeo(p_c_ubgdir IN VARCHAR2) RETURN char;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE sp_direccion_negocio(p_c_codper in varchar2,
                                 lc_desdir  out varchar2,
                                 ln_numero  out varchar2,
                                 lc_desdep  out varchar2,
                                 lc_despis  out varchar2,
                                 lc_codubi  out varchar2,
                                 lc_desref  out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE fn_relacion(p_c_codper in varchar2,
                        p_c_codfam in varchar2,
                        p_c_codref in varchar2,
                        lc_tipdoc1 out varchar2,
                        lc_tipdoc2 out varchar2,
                        lc_numdoc1 out varchar2,
                        lc_numdoc2 out varchar2,
                        ln_vinculo out number,
                        ln_bienes  out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE fn_rel_per_juridica(p_c_codpju in varchar2,
                                p_c_codper in varchar2,
                                p_c_codtrj in varchar2,
                                lc_tipdoc1 out varchar2,
                                lc_tipdoc2 out varchar2,
                                lc_numdoc1 out varchar2,
                                lc_numdoc2 out varchar2,
                                ln_vinculo out number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  FUNCTION fn_es_residente(p_c_codper IN VARCHAR2) return char;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  FUNCTION fn_ejecutivo_cta(p_c_codper IN VARCHAR2) RETURN number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  FUNCTION fn_fecha_alta(p_c_codper IN VARCHAR2) RETURN date;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  FUNCTION fn_cod_sector(p_c_codper IN VARCHAR2) RETURN number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 /* FUNCTION fn_es_proveedor(p_c_codper IN VARCHAR2) RETURN char;*/
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  FUNCTION fn_sucursal_cta(p_c_codper IN VARCHAR2) RETURN number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  FUNCTION fn_act_economica(p_c_codper IN VARCHAR2) RETURN number;

END pq_datos_personas;
/

