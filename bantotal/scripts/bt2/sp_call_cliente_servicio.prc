create or replace procedure sp_call_cliente_servicio(p_n_codesv number,p_n_codtsv number,p_opcion number) is

  -- *****************************************************************
  -- Nombre                     : sp_call_cliente_servicio
  -- Sistema                    : BANTOTAL
  -- Módulo                     : BELE
  -- Versión                    : 1.0
  -- Fecha de Creación          : 20/01/2014
  -- Autor de Creación          : Chernandez.
  -- Uso                        : Call relacionar cliente con servicio
  -- Estado                     : Activo
  -- Acceso                     :
  -- Parámetros de Entrada      :
  -- Retorno                    :
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  -- *****************************************************************

begin
    pq_act_cli_servicios.sp_op_cliente_servicio(p_n_codesv => p_n_codesv,p_n_codtsv => p_n_codtsv,p_opcion =>p_opcion);
end sp_call_cliente_servicio;
/

