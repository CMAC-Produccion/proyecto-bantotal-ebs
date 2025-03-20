create or replace package PQ_CR_UPD_GASFAM is
  -- *****************************************************************
  -- Nombre                     :  Procedimiento para actualizar Gastos Familiares 
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 12/09/2024 12:03:00
  -- Autor de Creación          : MARIA POSTIGO
  -- Uso                        : Procedimiento para actualizar Gastos Familiares
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :
  -- Fecha de Modificación      : 03/10/2024
  -- Autor de la Modificación   : Maria Postigo
  -- Descripción de Modificación: Se agrego la validacion para que solo se actualice gastos familiares cuando este en tarea de Evaluacion.
  -- *****************************************************************

  procedure sp_Cr_UpdGastFaml(ln_Instancia in number);

end PQ_CR_UPD_GASFAM;
/

create or replace package body PQ_CR_UPD_GASFAM is

  procedure sp_Cr_UpdGastFaml(ln_Instancia in number) is
  
    ln_GastFamSolAux number(17, 2) := 0.00;
    ln_GastFamSol    number(17, 2) := 0.00;
    ln_GastFamDolAux number(17, 2) := 0.00;
    ln_GastFamDol    number(17, 2) := 0.00;
    ln_NroEva        number;
    ln_TareActiva    number := 0;
  
  begin
  
    begin
      select w.wftaskcod
        into ln_TareActiva
        from wfwrkitems w
       where w.wfinsprcid = ln_Instancia
         and w.wfitemstsact = 1;
    exception
      when others then
        ln_TareActiva := 0;
    end;
  
    if ln_TareActiva = 7 then
      begin
        select s.sng021eval
          into ln_NroEva
          from sng021 s
         where s.sng021sol = ln_Instancia;
      exception
        when others then
          null;
      end;
    
      -- Soles
      begin
        select sum(s.sng023mto)
          into ln_GastFamSolAux
          from sng023 s
         where s.sng021eval = ln_NroEva
           and s.sng026cod in (13, 14, 15, 16, 17, 18, 19, 20);
      exception
        when others then
          ln_GastFamSolAux := 0.00;
      end;
    
      begin
        select sum(s.sng023mto)
          into ln_GastFamSol
          from sng023 s
         where s.sng021eval = ln_NroEva
           and s.sng026cod = 54;
      exception
        when others then
          ln_GastFamSol := 0.00;
      end;
    
      -- Dolares 
      begin
        select sum(s.sng023mto)
          into ln_GastFamDolAux
          from sng023 s
         where s.sng021eval = ln_NroEva
           and s.sng026cod in (513, 514, 515, 516, 517, 518, 519, 520);
      exception
        when others then
          ln_GastFamDolAux := 0.00;
      end;
    
      begin
        select sum(s.sng023mto)
          into ln_GastFamDol
          from sng023 s
         where s.sng021eval = ln_NroEva
           and s.sng026cod = 554;
      exception
        when others then
          ln_GastFamDol := 0.00;
      end;
    
      if ln_GastFamSol <> ln_GastFamSolAux then
        begin
          update sng023 s
             set s.sng023mto = ln_GastFamSolAux
           where s.sng021eval = ln_NroEva
             and s.sng026cod = 54;
        
        end;
      end if;
    
      if ln_GastFamDol <> ln_GastFamDolAux then
        begin
          update sng023 s
             set s.sng023mto = ln_GastFamDolAux
           where s.sng021eval = ln_NroEva
             and s.sng026cod = 554;
        end;
      end if;
    
      commit;
    end if;
  end sp_Cr_UpdGastFaml;
  ----------------------------------------------------------
end PQ_CR_UPD_GASFAM;
/

