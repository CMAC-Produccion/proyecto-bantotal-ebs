create or replace package PQ_CR_VERFCNTRL_ACTFINAN is
  -- *****************************************************************
  -- Nombre                     : Paquete que valida y extrae la actividad economica del cliente
  -- Sistema                    : BANTOTAL
  -- M�dulo                     : Cr�ditos - Activas
  -- Versi�n                    : 1.0
  -- Fecha de Creaci�n          : 03/06/2024 12:43:31
  -- Autor de Creaci�n          : MPOSTIGOC
  -- Uso                        : Obtiene Valores y realiza validaciones
  -- Estado                     : Activo
  -- Acceso                     : P�blico
  -- Par�metros de Entrada      :
  -- Fecha de Modificaci�n      : 
  -- Autor de la Modificaci�n   : 
  -- Descripci�n de Modificaci�n: 
  -- *****************************************************************

  -- Public type declarations
  procedure sp_cr_Inicio(ln_instancia    in number,
                         ln_CodAct       out number,
                         lc_ActFinanciar out varchar2);

end PQ_CR_VERFCNTRL_ACTFINAN;
/

create or replace package body PQ_CR_VERFCNTRL_ACTFINAN is

  procedure sp_cr_Inicio(ln_instancia    in number,
                         ln_CodAct       out number,
                         lc_ActFinanciar out varchar2) is
  
    ln_pais    number;
    ln_tdoc    number;
    lc_ndoc    varchar2(12);
    ln_EstGuia number;
  
  begin
  
    lc_ActFinanciar := 'N';
  
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_pais, ln_tdoc, lc_ndoc
        from sng001 s
       where s.sng001inst = ln_instancia;
    exception
      when others then
        null;
    end;
  
    if ln_tdoc = 9 then
      begin
        select f.EXPNINS
          into ln_CodAct
          from fse001 f
         Where f.D511Pais = ln_pais
           and f.D511Tdoc = ln_tdoc
           and f.D511Ndoc = lc_ndoc;
      exception
        when others then
          ln_CodAct := 0;
      end;
    
    else
    
      begin
        select SNGC60Acte
          into ln_CodAct
          from sngc60
         Where SNGC60Pais = ln_pais
           and SNGC60Tdoc = ln_tdoc
           and SNGC60Ndoc = lc_ndoc;
      exception
        when others then
          ln_CodAct := 0;
        
      end;
    
    end if;
  
    if ln_CodAct > 0 then
      begin
        select count(*)
          into ln_EstGuia
          from fst198 f
         Where f.tp1cod = 1
           and f.Tp1cod1 = 10892
           and f.Tp1corr1 = 6
           and f.Tp1corr2 = 1
           and f.tp1nro1 = ln_CodAct;
      exception
        when others then
          ln_EstGuia := 0;
      end;
    
      if ln_EstGuia > 0 then
        lc_ActFinanciar := 'S';
      else
        lc_ActFinanciar := 'N';
      end if;
    end if;
  
  end sp_cr_Inicio;

end PQ_CR_VERFCNTRL_ACTFINAN;
/

