create or replace package pq_cr_creditos_historicos is
  -- *****************************************************************
  -- Nombre                     : PAQUETE PARA OBTENER CLAVE DE DOCUMENTO Y SUCURSAL Y ESTADO DE CREDITO PARA SUS HISTORICOS
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2024.05.15
  -- Autor de Creación          : ENINAH
  -- Uso                        : 
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :
  -- Fecha de Modificación      : 
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 
  --
  -- *****************************************************************
  -----------------------------------------------------------------------

  procedure sp_cr_clave_doc(cuenta         in number,
                            estado         in number,
                            ve_pepais      out number,
                            ve_tipdoc      out number,
                            ve_numdoc      out varchar2,
                            ve_desc_estado out varchar2);

  procedure sp_cr_obtener_saldocap_suc(ve_cod           in number,
                                       ve_modulo        in number,
                                       ve_sucursal      in number,
                                       ve_moneda        in number,
                                       ve_papel         in number,
                                       ve_cuenta        in number,
                                       ve_operacion     in number,
                                       ve_subope        in number,
                                       ve_tipope        in number,
                                       vi_saldcap       out number,
                                       vi_desc_sucursal out varchar2);

end pq_cr_creditos_historicos;
/

create or replace package body pq_cr_creditos_historicos is
  -- *****************************************************************
  -- Nombre                     : PAQUETE PARA OBTENER CLAVE DE DOCUMENTO Y SUCURSAL Y ESTADO DE CREDITO PARA SUS HISTORICOS
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2024.05.15
  -- Autor de Creación          : ENINAH
  -- Uso                        : 
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :
  -- Fecha de Modificación      : 
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación: 
  --
  -- *****************************************************************
  -----------------------------------------------------------------------
  procedure sp_cr_clave_doc(cuenta         in number,
                            estado         in number,
                            ve_pepais      out number,
                            ve_tipdoc      out number,
                            ve_numdoc      out varchar2,
                            ve_desc_estado out varchar2) is
  
      -- *****************************************************************
    -- Nombre                     : sp_cr_clave_doc
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2024.05.15
    -- Autor de Creación          : eninah
    -- Uso                        : Extrae la clave de documento y la descripcion de la sucursal
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    --
    -- Retorno                    : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --
    -- *****************************************************************
  begin
  
    begin
      select pePAIS, PETDOC, PENDOC
        into ve_pepais, ve_tipdoc, ve_numdoc
        from fsr008
       where ctnro = cuenta
         AND TTCOD = 1
         and cttfir = 'T';
    exception
      when others then
        ve_pepais := 0;
        ve_tipdoc := 0;
        ve_numdoc := '';
    end;
  
    begin
      select CENOM into ve_desc_estado from fst026 f where CECOD = estado;
    exception
      when others then
        ve_desc_estado := '';
    end;
  
  end sp_cr_clave_doc;

  procedure sp_cr_obtener_saldocap_suc(ve_cod           in number,
                                       ve_modulo        in number,
                                       ve_sucursal      in number,
                                       ve_moneda        in number,
                                       ve_papel         in number,
                                       ve_cuenta        in number,
                                       ve_operacion     in number,
                                       ve_subope        in number,
                                       ve_tipope        in number,
                                       vi_saldcap       out number,
                                       vi_desc_sucursal out varchar2) is

      -- *****************************************************************
    -- Nombre                     : sp_cr_obtener_saldocap_suc
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2024.05.15
    -- Autor de Creación          : eninah
    -- Uso                        : Extrae el saldo Capital y la descripcion de la sucursal
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    --
    -- Retorno                    : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    --
    -- *****************************************************************                                    
  begin
  
    begin
      select SCSDO
        into vi_saldcap
        from fsd011 f
       where f.pgcod = ve_cod
         and f.scmod = ve_modulo
         and f.scsuc = ve_sucursal
         and f.scmda = ve_moneda
         and f.scpap = ve_papel
         and f.sccta = ve_cuenta
         and f.scoper = ve_operacion
         and f.scsbop = ve_subope
         and f.sctope = ve_tipope;
    exception
      when others then
        vi_saldcap := 0.00;
    end;
    
    if vi_saldcap < 0 then
      vi_saldcap := vi_saldcap * (-1);
    end if;
  
    begin
      select SCNOM
        into vi_desc_sucursal
        from FST001
       where PGCOD = 1
         AND SUCURS = ve_sucursal;
    exception
      when others then
        vi_desc_sucursal := '';
    end;
  
  end sp_cr_obtener_saldocap_suc;

end pq_cr_creditos_historicos;
/

