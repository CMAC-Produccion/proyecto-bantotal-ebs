create or replace package pq_cr_resol_ingrneto is

 -- *****************************************************************
    -- Nombre                     : pq_cr_resol_ingrneto
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : RCASTRO
    -- Uso                        : Cuotas/Ingreso Neto
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
  
  
  Procedure sp_cr_Eva_IngNeto(pn_instancia in number, pn_MtoIng out number);  
  
end pq_cr_resol_ingrneto;
/

create or replace package body pq_cr_resol_ingrneto is

Procedure sp_cr_Eva_IngNeto(pn_instancia in number, pn_MtoIng out number) is
    /*}
    INGRESO CONSUM SOLES 
    sum(case when sng026cod in (5, 6, 7, 8) then sng023mto * -1 else sng023mto end)
    
    SNG023 where sng021eval = (select SNG021EVAL from sng021 where sng021sol=@INSTANCIA) AND SNG026COD IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)
    group by sng021eval
    
    INGRESO CONSUM DÓLAR
    sum(case when sng026cod in (505, 506, 507, 508) then sng023mto * -1 else sng023mto end)
    
    SNG023 where sng021eval  = (select SNG021EVAL from sng021 where sng021sol=@INSTANCIA) AND SNG026COD IN (501, 502, 503, 504, 505, 506, 507, 508, 509, 510, 511, 512)
    group by sng021eval
    
    TIPO_CAMBIO_EVAL
    case when SNG120TCBI = 0 THEN 1 else SNG120TCBI end
    SNG120 WHERE SNG120TSK = 'EVALUACION' AND SNG120INS = @INSTANCIA   
    
    */
  
    ln_IngEgreSol number(17, 2);
    ln_IngEgreDol number(17, 2);
  
  Begin
  
    begin
      select sum(case
                   when sng026cod in (5, 6, 7, 8) then
                    sng023mto * -1
                   else
                    sng023mto
                 end)
        into ln_IngEgreSol
        from SNG023 s, sng021 t
       where s.sng021eval = t.SNG021EVAL
         and t.sng021sol = pn_instancia
         AND s.SNG026COD IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)
       group by s.sng021eval;
    exception
      when others then
        ln_IngEgreSol := 0;
    end;
  
    begin
      select sum(case
                   when sng026cod in (5, 6, 7, 8) then
                    sng023mto * -1
                   else
                    sng023mto
                 end) * u.SNG120TCBI
        into ln_IngEgreDol
        from SNG023 s, sng021 t, sng120 u
       where s.sng021eval = t.SNG021EVAL
         and t.sng021sol = pn_instancia
         AND s.SNG026COD IN
             (501, 502, 503, 504, 505, 506, 507, 508, 509, 510, 511, 512) --antes estaba con estos valores (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12) pero estos conceptos son soles
         and u.SNG120TSK = 'EVALUACION'
         and t.sng021sol = SNG120INS
       group by t.sng021eval, u.SNG120TCBI;
    exception
      when others then
        ln_IngEgreDol := 0;
    end;
  
    pn_MtoIng := ln_IngEgreSol + ln_IngEgreDol;
  
  end sp_cr_Eva_IngNeto;

end pq_cr_resol_ingrneto;
/

