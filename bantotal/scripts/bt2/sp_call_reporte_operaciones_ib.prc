create or replace procedure sp_call_reporte_operaciones_IB(p_pgcod          number,
                                                       p_fecini         date,
                                                       p_fecfin         date,
                                                       p_modo     number,
                                                       --p_rango    number,
                                                       p_usuario varchar2,
                                                       p_c_msgerr out varchar2) is

  -- *****************************************************************
  -- Nombre                     : sp_call_reporte_operaciones_IB
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Internet Banking
  -- Versión                    : 1.0
  -- Fecha de Creación          : 01/09/2014
  -- Autor de Creación          : Chernandez.
  -- Uso                        : Call Reporte Operaciones IB
  -- Estado                     : Activo
  -- Acceso                     :
  -- Parámetros de Entrada      :
  -- Retorno                    :
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  -- *****************************************************************
begin
pq_reporte_tarjetas.ejecutarRptIBanking (p_pgcod   => p_pgcod,
                                         p_fecini   => p_fecini,
                                         p_fecfin   => p_fecfin,
                                         p_modo => p_modo,
                                         --p_rango => p_rango,
                                         p_usuario => p_usuario,
                                         p_c_msgerr => p_c_msgerr);
end sp_call_reporte_operaciones_IB;
/

