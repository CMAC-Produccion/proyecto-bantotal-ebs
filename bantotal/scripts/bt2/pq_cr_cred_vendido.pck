create or replace package PQ_CR_CRED_VENDIDO is
  -- *****************************************************************
  -- Nombre                     : PQ_CR_CRED_VENDIDO
  -- Sistema                    : BANTOTAL
  -- M�dulo                     : Cr�ditos - Activas
  -- Versi�n                    : 1.0
  -- Fecha de Creaci�n          : 2019.08.09
  -- Autor de Creaci�n          : DCASTRO
  -- Uso                        : paquete que evalua instancia
  -- Estado                     : Activo
  -- Acceso                     : P�blico
  -- Fecha de Modificaci�n      : 
  -- Autor de la Modificaci�n   : 
  -- Descripci�n de Modificaci�n: 
  -- *****************************************************************

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_Vendida(pn_instancia in number, pc_char out char);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_Vendido(pn_pais   in number,
                          pn_petdoc in number,
                          pc_pendoc in char,
                          pc_char   out char);

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

end PQ_CR_CRED_VENDIDO;
/

create or replace package body PQ_CR_CRED_VENDIDO is
  -- *****************************************************************
  -- Nombre                     : PQ_CR_CRED_VENDIDO
  -- Sistema                    : BANTOTAL
  -- M�dulo                     : Cr�ditos - Activas
  -- Versi�n                    : 1.0
  -- Fecha de Creaci�n          : 2019.08.09
  -- Autor de Creaci�n          : DCASTRO
  -- Uso                        : paquete que evalua instancia
  -- Estado                     : Activo
  -- Acceso                     : P�blico
  -- Fecha de Modificaci�n      : 
  -- Autor de la Modificaci�n   : 
  -- Descripci�n de Modificaci�n: 
  -- *****************************************************************

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_Vendida(pn_instancia in number, pc_char out char) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_Vendida
    -- Sistema                    : BANTOTAL
    -- M�dulo                     : Cr�ditos - Activas
    -- Versi�n                    : 1.0
    -- Fecha de Creaci�n          : 2019.08.09
    -- Autor de Creaci�n          : DCASTRO
    -- Uso                        : retorna S si titular representativo tiene credito en estado 65 vendido
    -- Estado                     : Activo
    -- Acceso                     : P�blico
    -- Fecha de Modificaci�n      : 
    -- Autor de la Modificaci�n   : 
    -- Descripci�n de Modificaci�n: 
    -- *****************************************************************
  
    cursor cuentas(ln_pais   in number,
                   ln_petdoc in number,
                   ln_pendoc in char) is
      select ctnro
        from fsr008 f
       where f.pepais = ln_pais
         and f.petdoc = ln_petdoc
         and f.pendoc = ln_pendoc
         and f.ttcod = 1
         and f.cttfir = 'T';
  
    ln_pais     number;
    ln_petdoc   number;
    lc_pendoc   char(12);
    lc_char     char(1);
    ln_cantidad number;
  
  begin
  
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_pais, ln_petdoc, lc_pendoc
        from sng001 s
       where s.sng001inst = pn_instancia;
    end;
  
    for i in cuentas(ln_pais, ln_petdoc, lc_pendoc) loop
      begin
        select count(*)
          into ln_cantidad
          from fsd011 f
         where f.pgcod = 1
           and f.scmod = 65
           and f.sccta = i.ctnro;
      end;
    
      if nvl(ln_cantidad, 0) > 0 then
        lc_char := 'S';
        exit;
      else
        lc_char := 'N';
      end if;
    
    end loop;
  
    pc_char := lc_char;
  
  end sp_cr_Vendida;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  Procedure sp_cr_Vendido(pn_pais   in number,
                          pn_petdoc in number,
                          pc_pendoc in char,
                          pc_char   out char) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_Vendida
    -- Sistema                    : BANTOTAL
    -- M�dulo                     : Cr�ditos - Activas
    -- Versi�n                    : 1.0
    -- Fecha de Creaci�n          : 2019.08.09
    -- Autor de Creaci�n          : DCASTRO
    -- Uso                        : retorna S si titular representativo tiene credito en estado 65 vendido
    -- Estado                     : Activo
    -- Acceso                     : P�blico
    -- Fecha de Modificaci�n      : 
    -- Autor de la Modificaci�n   : 
    -- Descripci�n de Modificaci�n: 
    -- *****************************************************************
  
    cursor cuentas(ln_pais   in number,
                   ln_petdoc in number,
                   ln_pendoc in char) is
      select ctnro
        from fsr008 f
       where f.pepais = ln_pais
         and f.petdoc = ln_petdoc
         and f.pendoc = ln_pendoc
         and f.ttcod = 1
         and f.cttfir = 'T';
  
    ln_pais     number;
    ln_petdoc   number;
    lc_pendoc   char(12);
    lc_char     char(1);
    ln_cantidad number;
  
  begin
  
    for i in cuentas(pn_pais, pn_petdoc, pc_pendoc) loop
      begin
        select count(*)
          into ln_cantidad
          from fsd011 f
         where f.pgcod = 1
           and f.scmod = 65
           and f.sccta = i.ctnro;
      end;
    
      if nvl(ln_cantidad, 0) > 0 then
        lc_char := 'S';
        exit;
      else
        lc_char := 'N';
      end if;
    
    end loop;
  
    pc_char := lc_char;
  
  end sp_cr_Vendido;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

end PQ_CR_CRED_VENDIDO;
/

