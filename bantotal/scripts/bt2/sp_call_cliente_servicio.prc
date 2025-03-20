create or replace procedure sp_call_cliente_servicio(p_n_codesv number,p_n_codtsv number,p_opcion number) is

  -- *****************************************************************
  -- Nombre                     : sp_call_cliente_servicio
  -- Sistema                    : BANTOTAL
  -- M�dulo                     : BELE
  -- Versi�n                    : 1.0
  -- Fecha de Creaci�n          : 20/01/2014
  -- Autor de Creaci�n          : Chernandez.
  -- Uso                        : Call relacionar cliente con servicio
  -- Estado                     : Activo
  -- Acceso                     :
  -- Par�metros de Entrada      :
  -- Retorno                    :
  -- Fecha de Modificaci�n      :
  -- Autor de la Modificaci�n   :
  -- Descripci�n de Modificaci�n:
  -- *****************************************************************

begin
    pq_act_cli_servicios.sp_op_cliente_servicio(p_n_codesv => p_n_codesv,p_n_codtsv => p_n_codtsv,p_opcion =>p_opcion);
end sp_call_cliente_servicio;
/

