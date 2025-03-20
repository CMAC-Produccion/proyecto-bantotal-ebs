create or replace procedure sp_call_reporte_estad_tarj(p_pgcod          number,
                                                       p_fecini         date,
                                                       p_fecfin         date,
                                                       --p_td10suc2       number,
                                                       p_estado_tarjeta char,
                                                       --p_estado_bin     char,
                                                       p_c_msgerr out varchar2) is

  -- *****************************************************************
  -- Nombre                     : sp_call_reporte_estadistico_tarjetas
  -- Sistema                    : BANTOTAL
  -- Módulo                     : TARJETAS DEBITO
  -- Versión                    : 1.0
  -- Fecha de Creación          : 11/08/2014
  -- Autor de Creación          : Chernandez.
  -- Uso                        : Call Reporte Estadistico Tarjetas
  -- Estado                     : Activo
  -- Acceso                     :
  -- Parámetros de Entrada      :
  -- Retorno                    :
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  -- *****************************************************************
begin
pq_reporte_tarjetas.ejecutarReporte(p_pgcod   => p_pgcod,
                                         p_fecini   => p_fecini,
                                         p_fecfin   => p_fecfin,
                                         --p_td10suc2 => p_td10suc2,
                                         p_estado_tarjeta => p_estado_tarjeta,
                                         --p_estado_bin => p_estado_bin
                                         p_c_msgerr => p_c_msgerr);
end sp_call_reporte_estad_tarj;
/

