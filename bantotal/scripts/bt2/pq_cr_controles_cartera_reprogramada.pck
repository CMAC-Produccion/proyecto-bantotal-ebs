create or replace package pq_cr_controles_cartera_reprogramada is

  -- *****************************************************************
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2024.05.28
  -- Autor de Creación          : Edehilton Nina Hurtado
  -- Uso                        : Valida si el cliente tiene Cartera reprogramada
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2024.06.05
  -- Autor de la Modificación   : ENINAH
  -- Fecha de Modificación      : 2024.06.24
  -- Autor de la Modificación   : ENINAH
  -- Descripción de Modificación: Se cambió el mensaje de la bloqueante.
  -- *****************************************************************

  procedure sp_cr_cliente_validar_cartera(vi_pgcod   in number,
                                          vi_hcsuc   in number,
                                          vi_hcmod   in number,
                                          vi_htran   in number,
                                          vi_hnrel   in number,
                                          vo_control out varchar2,
                                          vo_messa   out varchar2);

  procedure sp_cr_cliente_validar_instancia(vi_instancia in number,
                                            vo_control   out varchar2,
                                            vo_messa     out varchar2);

end pq_cr_controles_cartera_reprogramada;
/

create or replace package body pq_cr_controles_cartera_reprogramada is

  procedure sp_cr_cliente_validar_cartera(vi_pgcod   in number,
                                          vi_hcsuc   in number,
                                          vi_hcmod   in number,
                                          vi_htran   in number,
                                          vi_hnrel   in number,
                                          vo_control out varchar2,
                                          vo_messa   out varchar2) is
  
    -- *****************************************************************
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2024.05.28
    -- Autor de Creación          : Edehilton Nina Hurtado
    -- Uso                        : Valida si el cliente tiene Cartera reprogramada
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : vi_pgcod ( Empresa )
    --                              vi_hcmod ( Modulo )
    --                              vi_hcsuc ( Sucursal )
    --                              vi_htran ( Transaccion )
    --                              vi_hnrel ( Relacion )
    -- Parámetros de Salida       : vo_control ( Cancelado )
    --                              vo_messa ( Mensaje )
    -- Fecha de Modificación      : 2024.06.05
    -- Autor de la Modificación   : ENINAH
    -- Fecha de Modificación      : 2024.06.12
    -- Autor de la Modificación   : ENINAH
    -- Descripción de Modificación: Se cambió el mensaje de la bloqueante.
    -- *****************************************************************
    ln_flag       number := 0;
    ln_flag_2     number := 0;
    ln_sccta      number := 0;
    ln_scoper     number := 0;
    fecha_sistema date;
    --vo_control    varchar2(2);
    --vo_messa      varchar2(50);
  
  begin
  
    -- buscar cliente a partir de la trasaccion
    begin
      select ctnro, itoper
        into ln_sccta, ln_scoper
        from fsd016 f
       where f.pgcod = vi_pgcod
         and f.itsuc = vi_hcsuc
         and f.itmod = vi_hcmod
         and f.ittran = vi_htran
         and f.itnrel = vi_hnrel
         and f.itord = 10
         and f.ctnro > 0
         and rownum = 1;
    exception
      when others then
        null;
    end;
  
    -- buscar la fecha actual del sistema
    begin
      select pgfape into fecha_sistema from fst017 f where f.pgcod = 1;
    exception
      when others then
        fecha_sistema := '01/01/0001';
    end;
  
    --Validar si el crédito se encuentra en la tabla. 
    begin
      select count(*)
        into ln_flag
        from aqpd603 a
       where a.aqpd603cta = ln_sccta
         and a.aqpd603oper = ln_scoper;
      --and a.aqpd603sta = 'S'
      --and a.aqpd603fecv > fecha_sistema;
    exception
      when others then
        null;
    end;
  
    -- Devolver Control
    if ln_flag > 0 then
      vo_control := 'S';
      vo_messa   := 'Crédito no está sujeto a Refinanciacion, Memo 225, Sinceramiento.';
      begin
        select count(*)
          into ln_flag_2
          from aqpd603 a
         where a.aqpd603cta = ln_sccta
           and a.aqpd603oper = ln_scoper
           and a.aqpd603sta = 'S'
           and a.aqpd603fecv >= fecha_sistema;
      exception
        when others then
          null;
      end;
    
      if ln_flag_2 > 0 then
        vo_control := 'N';
        vo_messa   := '';
      end if;
    else
      vo_control := 'N';
      vo_messa   := '';
    end if;
  
  end sp_cr_cliente_validar_cartera;

  procedure sp_cr_cliente_validar_instancia(vi_instancia in number,
                                            vo_control   out varchar2,
                                            vo_messa     out varchar2) is
  
    -- *****************************************************************
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2024.05.28
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : Valida si la instancia tiene Cartera reprogramada
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : vi_instancia ( Instancia )
    -- Parámetros de Salida       : vo_control ( Cancelado )
    --                              vo_messa ( Mensaje )
    -- Fecha de Modificación      : --
    -- Autor de la Modificación   : --
    -- Descripción de Modificación: --
    -- *****************************************************************
    ln_flag       number := 0;
    ln_flag_2     number := 0;
    ln_sccta      number := 0;
    ln_scoper     number := 0;
    fecha_sistema date;
  
  begin
  
    -- buscar cliente a partir de la trasaccion
    begin
      select x.xwfcuenta, x.xwfoperacion
        into ln_sccta, ln_scoper
        from xwf700 x
       where x.xwfprcins = vi_instancia
         and x.xwfcar3 = '1'
         and rownum = 1;
    exception
      when others then
        null;
    end;
  
    -- buscar la fecha actual del sistema
    begin
      select pgfape into fecha_sistema from fst017 f where f.pgcod = 1;
    exception
      when others then
        fecha_sistema := '01/01/0001';
    end;
  
    --Validar si el crédito se encuentra en la tabla. 
    begin
      select count(*)
        into ln_flag
        from aqpd603 a
       where a.aqpd603cta = ln_sccta
         and a.aqpd603oper = ln_scoper;
    exception
      when others then
        null;
    end;
  
    -- Devolver Control
    if ln_flag > 0 then
      vo_control := 'S';
      vo_messa   := 'Crédito no está sujeto a Reprogramación, Memo 225, Sinceramiento.';
      begin
        select count(*)
          into ln_flag_2
          from aqpd603 a
         where a.aqpd603cta = ln_sccta
           and a.aqpd603oper = ln_scoper
           and a.aqpd603sta = 'S'
           and a.aqpd603fecv >= fecha_sistema;
      exception
        when others then
          null;
      end;
    
      if ln_flag_2 > 0 then
        vo_control := 'N';
        vo_messa   := '';
      end if;
    else
      vo_control := 'N';
      vo_messa   := '';
    end if;
  
  end sp_cr_cliente_validar_instancia;

end pq_cr_controles_cartera_reprogramada;
/

