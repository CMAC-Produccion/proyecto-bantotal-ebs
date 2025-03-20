create or replace package PQ_CR_HONRACIONES_MTO is

  -- *****************************************************************
  -- Nombre                       : PQ_CR_HONRACIONES_UTILIDADES
  -- Sistema                      : BANTOTAL
  -- Módulo                       : Créditos
  -- Versión                      : 1.0
  -- Fecha de Creación            : 22/04/2024
  -- Autor de Creación            : Alexander Acuña :)
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Descripción                  : Paquete para el mantenimiento de honraciones 
  -- Fecha de Modificación        : 16/01/2025
  -- Autor de la Modificación     : jalvaroh
  -- Descripción de Modificación  : se modifico obtencion del ultimo pago 
  -- *****************************************************************

  -- Registro de información en plantilla
  procedure sp_eliminar_detalle_honracion(p_corr in number,
                                          p_cod  in number,
                                          p_mod  in number,
                                          p_suc  in number,
                                          p_mda  in number,
                                          p_pap  in number,
                                          p_cta  in number,
                                          p_oper in number,
                                          p_sbop in number,
                                          p_top  in number,
                                          o_flag out number,
                                          o_msg  out varchar2);

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure sp_verificar_credito_honramiento(p_cod  in number,
                                             p_mod  in number,
                                             p_suc  in number,
                                             p_mda  in number,
                                             p_pap  in number,
                                             p_cta  in number,
                                             p_oper in number,
                                             p_sbop in number,
                                             p_top  in number,
                                             o_flag out number,
                                             o_msg  out varchar2);

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_verificar_credito_pagos(p_cod  in number,
                                       p_mod  in number,
                                       p_suc  in number,
                                       p_mda  in number,
                                       p_pap  in number,
                                       p_cta  in number,
                                       p_oper in number,
                                       p_sbop in number,
                                       p_top  in number,
                                       o_flag out number,
                                       o_msg  out varchar2,
                                       o_fec  out date);
end PQ_CR_HONRACIONES_MTO;
/

create or replace package body PQ_CR_HONRACIONES_MTO is

  procedure sp_eliminar_detalle_honracion(p_corr in number,
                                          p_cod  in number,
                                          p_mod  in number,
                                          p_suc  in number,
                                          p_mda  in number,
                                          p_pap  in number,
                                          p_cta  in number,
                                          p_oper in number,
                                          p_sbop in number,
                                          p_top  in number,
                                          o_flag out number,
                                          o_msg  out varchar2) is
    -- *****************************************************************
    -- Nombre                     : sp_eliminar_detalle_honracion
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Crédito
    -- Versión                    : 1.0
    -- Fecha de Creación          : 24.04.2024
    -- Autor de Creación          : ALEXANDER ACUÑA
    -- Uso                        : Permite anular el crédito en honramiento
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : p_corr (Correlativo)
    --                              p_cod (Código)
    --                              p_mod (Módulo)
    --                              p_suc (Sucursal)
    --                              p_mda (Moneda)
    --                              p_pap (Papel)
    --                              p_cta (Cuenta)
    --                              p_oper (Operación)
    --                              p_sbop (Sub Operación)
    --                              p_top  (Tipo de operación)
    -- Retorno                    : o_flag (Flag de salida)
    --                              o_msg (Mensaje de salida)                  
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --
    -- ******************************************************************
  
    vi_est aqpb433.aqpb433est%type;
  begin
    select aqpb433est
      into vi_est
      from aqpb433
     where aqpb433cor = p_corr
       and aqpb433cod = p_cod
       and aqpb433mod = p_mod
       and aqpb433suc = p_suc
       and aqpb433mda = p_mda
       and aqpb433pap = p_pap
       and aqpb433cta = p_cta
       and aqpb433ope = p_oper
       and aqpb433sbo = p_sbop
       and aqpb433top = p_top;
  
    --- Eliminamos detalle
    if vi_est = 'I' then
      -- Actualizamos estado anulado --
      update aqpb433
         set aqpb433est = 'A'
       where aqpb433cor = p_corr
         and aqpb433cod = p_cod
         and aqpb433mod = p_mod
         and aqpb433suc = p_suc
         and aqpb433mda = p_mda
         and aqpb433pap = p_pap
         and aqpb433cta = p_cta
         and aqpb433ope = p_oper
         and aqpb433sbo = p_sbop
         and aqpb433top = p_top;
      o_flag := SQL%ROWCOUNT;
      o_msg  := 'Se anularon ' || o_flag || ' registros.';
      commit;
    else
      o_flag := -1;
      o_msg  := 'El registro no se encuentra en estado INGRESADO';
    end if;
  
  exception
    when others then
      o_flag := 999;
      o_msg  := 'No se pudo eliminar el registro';
      rollback;
  end sp_eliminar_detalle_honracion;

  procedure sp_verificar_credito_honramiento(p_cod  in number,
                                             p_mod  in number,
                                             p_suc  in number,
                                             p_mda  in number,
                                             p_pap  in number,
                                             p_cta  in number,
                                             p_oper in number,
                                             p_sbop in number,
                                             p_top  in number,
                                             o_flag out number,
                                             o_msg  out varchar2) is
    -- *****************************************************************
    -- Nombre                     : sp_verificar_credito_honramiento
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Crédito
    -- Versión                    : 1.0
    -- Fecha de Creación          : 24.04.2024
    -- Autor de Creación          : ALEXANDER ACUÑA
    -- Uso                        : Verifica si un crédito esta en proceso de honramiento
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : p_corr (Correlativo)
    --                              p_cod (Código)
    --                              p_mod (Módulo)
    --                              p_suc (Sucursal)
    --                              p_mda (Moneda)
    --                              p_pap (Papel)
    --                              p_cta (Cuenta)
    --                              p_oper (Operación)
    --                              p_sbop (Sub Operación)
    --                              p_top  (Tipo de operación)
    -- Retorno                    : o_flag (Flag de salida)
    --                              o_msg (Mensaje de salida)                  
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --
    -- ******************************************************************
    vi_est aqpb433.aqpb433est%type;
  begin
    o_flag := 0;
    select aqpb433est
      into vi_est
      from aqpb433 a
     where a.aqpb433cod = p_cod
       and a.aqpb433mod = p_mod
       and a.aqpb433suc = p_suc
       and a.aqpb433mda = p_mda
       and a.aqpb433pap = p_pap
       and a.aqpb433cta = p_cta
       and a.aqpb433ope = p_oper
       and a.aqpb433sbo = p_sbop
       and a.aqpb433top = p_top
       and a.aqpb433est = 'I';
    o_flag := 1;
    o_msg  := 'Crédito está en proceso de Honramiento, comunicarse con Procesos Centrales';
  
  exception
    when NO_DATA_FOUND then
      o_flag := 0;
      o_msg  := 'Crédito no esta en proceso de honramiento';
    when others then
      o_flag := 999;
      o_msg  := 'No se pudo eliminar el registro';
  end sp_verificar_credito_honramiento;

  procedure sp_verificar_credito_pagos(p_cod  in number,
                                       p_mod  in number,
                                       p_suc  in number,
                                       p_mda  in number,
                                       p_pap  in number,
                                       p_cta  in number,
                                       p_oper in number,
                                       p_sbop in number,
                                       p_top  in number,
                                       o_flag out number,
                                       o_msg  out varchar2,
                                       o_fec  out date) is
    -- *****************************************************************
    -- Nombre                     : sp_verificar_credito_pagos
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Crédito
    -- Versión                    : 1.0
    -- Fecha de Creación          : 25.04.2024
    -- Autor de Creación          : ALEXANDER ACUÑA
    -- Uso                        : Verifica si un crédito esta en proceso de honramiento
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : p_corr (Correlativo)
    --                              p_cod (Código)
    --                              p_mod (Módulo)
    --                              p_suc (Sucursal)
    --                              p_mda (Moneda)
    --                              p_pap (Papel)
    --                              p_cta (Cuenta)
    --                              p_oper (Operación)
    --                              p_sbop (Sub Operación)
    --                              p_top  (Tipo de operación)
    -- Retorno                    : o_flag (Flag de salida)
    --                              o_msg (Mensaje de salida)  
    --                              o_fec (Fecha último pago de crédito en honramiento en los últimos 60 dias)                
    -- Fecha de Modificación      : 16/01/2025
    -- Autor de la Modificación   : jalvaroh
    -- Descripción de Modificación: se modifico obtencion del ultimo pago 
    --
    -- ******************************************************************
    vi_limit_date  DATE;
    vi_system_date DATE;
  begin
    -- Verificamos pagos de hoy
    begin
      -- INDICES APLICADOS: 
      -- fsd016 -> FSD01612
      -- fsd015 -> FSD01502
      -- fst198 -> SYS_C00514414
      select h.itfcon
        into o_fec
        from fsd016 d
       inner join fsd015 h
          on d.pgcod = h.pgcod
         and d.itsuc = h.itsuc
         and d.itmod = h.itmod
         and d.ittran = h.ittran
         and d.itnrel = h.itnrel
      
       where d.pgcod = p_cod
         and d.ctnro = p_cta
         and d.modulo = p_mod
         and d.moneda = p_mda
         and d.papel = p_pap
         and d.itoper = p_oper
         and d.itsubo = p_sbop
         and d.ittope = p_top
         and h.itcont = 'S'
         and (d.itmod, d.ittran) in (
                                     --Verificamos guia de pagos a validar en honramientos
                                     select tp1nro1, tp1nro2
                                       from fst198
                                      where tp1cod = 1
                                        and tp1cod1 = 11172
                                        and tp1corr1 = 22
                                        and tp1corr2 = 1
                                        and tp1corr3 > 0)
       order by h.itcont desc
       fetch first 1 row only;
    exception
      when no_data_found then
        o_flag := 0;
    end;
  
    if o_fec is not null then
      o_flag := 1;
      o_msg  := 'Crédito con pagos.';
    else
    
      -- Obtenemos fecha actual
    
      select pgfape into vi_system_date from fst017 where pgcod = 1;
    
      select j.jaqm35tfec
        into vi_limit_date
        from jaqm35 j
       where j.jaqm35pgco = p_cod
         and j.jaqm35mod = p_mod
         and
            /*
            j.jaqm35suc  = p_suc and
            */
             j.jaqm35mda = p_mda
         and j.jaqm35pap = p_pap
         and j.jaqm35cta = p_cta
         and j.jaqm35oper = p_oper
         and j.jaqm35sbop = p_sbop
         and j.jaqm35tope = p_top;
    
      --Verificamos pagos historicos
      begin
        -- INDICES APLICADOS: 
        -- fsh016 -> FSH01610.
        -- fst198 -> Índice SYS_C00514414.
      
        -- inicio jalvaroh 16/01/2025
      
        select JAQY711FPAG
          into o_fec
          from jaqy711
         where JAQY711COD = p_cod
           and JAQY711MDA = p_mda
           and JAQY711PAP = p_pap
           and JAQY711CTA = p_cta
           and JAQY711OPE = p_oper
           and JAQY711SBO = p_sbop
           and JAQY711FPAG between vi_limit_date and vi_system_date
           and (JAQY711TMOD, JAQY711TTRAN) in
               (select tp1nro1, tp1nro2
                  from fst198
                 where tp1cod = 1
                   and tp1cod1 = 11172
                   and tp1corr1 = 22
                   and tp1corr2 = 1
                   and tp1corr3 > 0)
         order by JAQY711FPAG desc
         fetch first 1 row only;
      
        -- fin jalvaroh 16/01/2025          
      
        /*          
          select d.hfcon
          into o_fec
          from fsh016 d
          where
              d.pgcod = p_cod
          and d.hcta = p_cta
          and d.hmda = p_mda
          and d.hoper = p_oper
          and d.hpap = p_pap
          and d.hsubop = p_sbop
          and d.hfcon between vi_limit_date and vi_system_date
          
          and (d.hcmod,d.htran) in (
            select tp1nro1, tp1nro2 from fst198 where 
                   tp1cod = 1 and
                   tp1cod1= 11172 and
                   tp1corr1 = 22 and 
                   tp1corr2=1 and 
                   tp1corr3 > 0 
          ) order by hfcon desc
          fetch first 1 row only;
          
        */
      exception
        when no_data_found then
          o_flag := 0;
      end;
    
      if o_fec is not null then
        o_flag := 1;
        o_msg  := 'Crédito con pagos';
      else
        o_msg := 'Crédito no tiene pagos';
      end if;
    end if;
  
  exception
    when no_data_found then
      o_flag := 0;
      o_msg  := 'Crédito no tiene pagos';
    when others then
      o_flag := 0; -- Indicador de error
      o_msg  := 'Error al verificar el crédito y los pagos: ' || SQLERRM;
  end sp_verificar_credito_pagos;
end PQ_CR_HONRACIONES_MTO;
/

