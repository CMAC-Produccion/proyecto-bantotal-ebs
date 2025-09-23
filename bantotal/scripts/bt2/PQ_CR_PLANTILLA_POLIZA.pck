create or replace package PQ_CR_PLANTILLA_POLIZA is

-- *****************************************************************
-- Nombre   : PQ_CR_PLANTILLAS_POLIZAS
-- Sistema    : BANTOTAL
-- Módulo   : Activas
-- Versión    : 1.0
-- Fecha de Creación  : 09/09/2025
-- Autor de Creación  : MCORDOVA
-- Uso      : Uso
-- Estado   : Activo
-- Acceso   : Público
-- *****************************************************************
  procedure OBTIENE_TIPO_CREDITO(
                pn_emp in number,
                pn_mod in number,
                pn_suc in number,
                pn_mda in number,
                pn_pap in number,
                pn_cta in number,
                pn_ope in number,
                pn_sbo in number,
                pn_top in number,
                pn_var out varchar2);     
end PQ_CR_PLANTILLA_POLIZA;
/
create or replace package body PQ_CR_PLANTILLA_POLIZA is
  procedure OBTIENE_TIPO_CREDITO(
                          pn_emp in number,
                          pn_mod in number,
                          pn_suc in number,
                          pn_mda in number,
                          pn_pap in number,
                          pn_cta in number,
                          pn_ope in number,
                          pn_sbo in number,
                          pn_top in number,
                          pn_var out varchar2) IS
  ln_grupo number(10);
  BEGIN
    ln_grupo := PQ_CR_TRAMDESGRA.Fn_tipoSBS_Des(
                          pn_emp,
                          pn_mod,
                          pn_suc,
                          pn_mda,
                          pn_pap,
                          pn_cta,
                          pn_ope,
                          pn_sbo,
                          pn_top);
    case
    when ln_grupo in (2, 12, 13) then
      pn_var := 'PYME';
    when ln_grupo = 3 then
      pn_var := 'CONSUMO';
    when ln_grupo = 4 then
      pn_var := 'HIPOTECARIO';
    end case;
  END OBTIENE_TIPO_CREDITO;                          
end PQ_CR_PLANTILLA_POLIZA;
/
