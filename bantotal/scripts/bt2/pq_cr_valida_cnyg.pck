create or replace package PQ_CR_VALIDA_CNYG is

  -- *****************************************************************
  -- Nombre                     : Procedimiento para la validacion de vinculacion conyugal o conviviente
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 5/03/2024 17:05:37
  -- Autor de Creación          : MPOSTIGOC
  -- Uso                        : Control en el Flujo de Creditos
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :
  --
  --
  --
  -- *****************************************************************
  ----------------------------------------------------------------
  -- Public type declarations

  procedure sp_cr_ValidaCNYG(ln_instancia     in number,
                             ln_BloqVinculado out varchar2);

end PQ_CR_VALIDA_CNYG;
/

create or replace package body PQ_CR_VALIDA_CNYG is

  procedure sp_cr_ValidaCNYG(ln_instancia     in number,
                             ln_BloqVinculado out varchar2) is
  
    ln_pais         number;
    ln_tdoc         number;
    lc_ndoc         varchar2(12);
    ln_EstVinculado number;
  
  begin
  
    ln_BloqVinculado := 'N';
  
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_pais, ln_tdoc, lc_ndoc
        from sng001 s, fsd002 f
       where s.sng001pais = f.pfpais
         and s.sng001tdoc = f.pftdoc
         and s.sng001ndoc = f.pfndoc
         and s.sng001inst = ln_instancia
         and f.pfeciv in ('1', '3');
    exception
      when others then
        null;
    end;
  
    if ln_pais > 0 then
    
      begin
        select count(*)
          into ln_EstVinculado
          from fsr002 f
         where f.pepais = ln_pais
           and f.petdoc = ln_tdoc
           and f.pendoc = lc_ndoc
           and f.rpccyg in (66, 91);
      exception
        when others then
          null;
      end;
    
      if ln_EstVinculado > 0 then
        ln_BloqVinculado := 'N';
      else
        ln_BloqVinculado := 'S';
      end if;
    
    end if;
  
  end sp_cr_ValidaCNYG;

end PQ_CR_VALIDA_CNYG;
/

