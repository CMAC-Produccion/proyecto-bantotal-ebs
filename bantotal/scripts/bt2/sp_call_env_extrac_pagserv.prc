create or replace procedure sp_call_env_extrac_pagserv(p_n_codesv   number,
                                                       p_n_codtsv   number,
                                                       p_c_user     char,
                                                       p_d_fecha    date,
                                                       p_c_msgerr  out varchar2) is

  -- *****************************************************************
  -- Nombre                     : sp_call_env_extrac_pagserv
  -- Sistema                    : BANTOTAL
  -- Módulo                     : BELE
  -- Versión                    : 1.0
  -- Fecha de Creación          : 20/01/2014
  -- Autor de Creación          : Chernandez.
  -- Uso                        : Call envio extracto
  -- Estado                     : Activo
  -- Acceso                     :
  -- Parámetros de Entrada      :
  -- Retorno                    :
  -- Fecha de Modificación      :
  -- Autor de la Modificación   :
  -- Descripción de Modificación:
  -- *****************************************************************

begin
  PQ_ENV_EXTRAC_PAGSERV.sp_enviar_correo(p_n_codesv   => p_n_codesv,
                                         p_n_codtsv   => p_n_codtsv,
                                         p_c_user   => p_c_user,
                                         p_d_fecha => p_d_fecha,
                                         p_c_msgerr => p_c_msgerr);
end sp_call_env_extrac_pagserv;
/

