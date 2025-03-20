create or replace package PQ_CR_VERF_RELAC_CRU is

  -- *****************************************************************
  -- Nombre                     :  Procedimiento que verifica las relaciones del cliente en el CRU
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 6/09/2024 10:26:27
  -- Autor de Creación          : MARIA POSTIGO
  -- Uso                        : Procedimiento que verifica las relaciones del cliente en el CRU 
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :
  -- Fecha de Modificación      : 
  -- Autor de la Modificación   : 
  -- Descripción de Modificación:   
  -- *****************************************************************

  -- Public type declarations

  procedure sp_Cr_Verf_RelaCRU(ln_instancia in number,
                               ln_NroRelac  out number);

end PQ_CR_VERF_RELAC_CRU;
/

create or replace package body PQ_CR_VERF_RELAC_CRU is

  procedure sp_Cr_Verf_RelaCRU(ln_instancia in number,
                               ln_NroRelac  out number) is
  
    ln_tdoc        number;
    lc_ndoc        varchar2(12);
    ln_NroConsulta number := 0;
    ln_Experian    number;
    ln_EstExp      number;
    ln_Sentinel    number;
    ln_EstSentinel number;
    ln_Equifax     number;
    ln_EstEqui     number;
  
  begin
  
    begin
      select s.sng001tdoc, s.sng001ndoc
        into ln_tdoc, lc_ndoc
        from sng001 s
       where s.sng001inst = ln_instancia;
    exception
      when others then
        null;
    end;
  
    begin
      select max(l.aqpa011lnucon)
        into ln_NroConsulta
        from AQPA011L L
       where L.aqpa011ltdoc = ln_tdoc
         and L.aqpa011lndoc = lc_ndoc
         and L.aqpa011lestad = 1;
    exception
      when others then
        ln_NroConsulta := 0;
    end;
  
    if ln_NroConsulta > 0 then
    
      begin
        SP_CR_CODIGO_EXP_SEN(P_TDOC     => ln_tdoc,
                             P_NDOC     => lc_ndoc,
                             P_CODI     => ln_NroConsulta,
                             P_EXPERIAN => ln_Experian,
                             P_ESTEXP   => ln_EstExp,
                             P_SENTINEL => ln_Sentinel,
                             P_ESTSEN   => ln_EstSentinel,
                             P_EQUIFAX  => ln_Equifax,
                             P_ESTEQUI  => ln_EstEqui);
      end;
    
      -- 'Representante_legal' 33, 'Relacion Comercial' 38
    
      If ln_EstExp = 1 or ln_EstSentinel = 1 then
        --Experian  
      
        begin
          select count(*)
            into ln_NroRelac
            from JAQL602
           Where JAQL546Serial = ln_Experian
             and JAQL602Tidet in ('33');
        exception
          when others then
            ln_NroRelac := 0;
        end;
      
      Else
        If ln_EstEqui = 1 then
          -- Equifax
        
          begin
            select count(*)
              into ln_NroRelac
              from AQPB515F
             Where AQPB515FSERIAL = ln_Equifax
               and AQPB515FTIDET in ('33');
          exception
            when others then
              ln_NroRelac := 0;
          end;
        
        End If;
      End If;
    end if;
  
    ln_NroRelac := nvl(ln_NroRelac, 0);
  
  end sp_Cr_Verf_RelaCRU;

end PQ_CR_VERF_RELAC_CRU;
/

