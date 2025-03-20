create or replace package PQ_CR_RIESGO_EVENTO is

-- *****************************************************************
    -- Nombre                     : paquete para calcular Eventos de Riesgos 
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Riesgos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 12/06/2022
    -- Autor de Creación          : YYAMPI
    -- Uso                        : paquete de rutinas para eventos de admision y seguimiento de riesgos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 
    -- *****************************************************************
  procedure sp_cr_eventos_id(
                          pn_pgpais number,
                          pn_tipdoc number,
                          pv_numdoc char,
                          pv_result out varchar);
                                
   procedure sp_cr_eventos_desc(
                                pn_pgpais number,
                                pn_tipdoc number,
                                pv_numdoc char,
                                pv_result out varchar) ;               

end PQ_CR_RIESGO_EVENTO;
/

create or replace package body PQ_CR_RIESGO_EVENTO is

  procedure sp_cr_eventos_id(
                                pn_pgpais number,
                                pn_tipdoc number,
                                pv_numdoc char,
                                pv_result out varchar) is                                              
-- *****************************************************************
    -- Nombre                     : sp_cr_eventos_id
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 12/06/2022
    -- Autor de Creación          : YYAMPI
    -- Uso                        : Retorna S/N  si hay evento de riesgo registrado
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 
    -- *****************************************************************

    ld_fecrcc date; --fecha de ultima carga RCC
    lv_evento varchar(2) := ''; --Tipo de persona (F/J)
    ln_tipdocSBS number(9) := 0; --Tipo documento SBS
    lv_codSBS varchar(10) :='';  --codigoSBS 
    --pn_result number;  --resultado
    ln_meseva number; --meses de evaluacion 
    ld_fecrcci date; --fecha de inicio carga RCC
    
begin
  pv_result := 'N'; 
  --pv_result := 'S';
  
          
      /*obtener si hay evento de evento registrado */
      begin 
        select decode(count(t.aqpb624cor),0,'N','S') into lv_evento 
        from AQPB624 t , fst198 g
        where t.aqpb624pais = pn_pgpais
              and t.aqpb624tdoc = pn_tipdoc
              and t.aqpb624ndoc = pv_numdoc
              and t.aqpb624est = 'A' --registro activo
              and g.tp1cod = 1
              and g.tp1cod1 = 11162
              and g.tp1corr1 = 2
              and g.tp1corr2 = 0
              and t.aqpb624tipe = g.tp1desc;
      exception when others then 
        lv_evento := 'N';
       DBMS_OUTPUT.put_line(SQLERRM);                        
      end;
     
   pv_result := lv_evento;  
        
            
   exception
    WHEN OTHERS THEN
     pv_result :='N'; 
     --pv_result :='S'; 
  
end sp_cr_eventos_id;

--------------------------------------------------------------------------

  procedure sp_cr_eventos_desc(
                                pn_pgpais number,
                                pn_tipdoc number,
                                pv_numdoc char,
                                pv_result out varchar) is                                              
-- *****************************************************************
    -- Nombre                     : sp_cr_eventos_desc
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 12/06/2022
    -- Autor de Creación          : YYAMPI
    -- Uso                        : Retorna descripcion si hay evento de riesgo registrado
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 
    -- *****************************************************************

    ld_fecrcc date; --fecha de ultima carga RCC
    lv_evento varchar(30) := ''; --Tipo de persona (F/J)
    ln_tipdocSBS number(9) := 0; --Tipo documento SBS
    lv_codSBS varchar(10) :='';  --codigoSBS 
    --pn_result number;  --resultado
    ln_meseva number; --meses de evaluacion 
    ld_fecrcci date; --fecha de inicio carga RCC
    
begin
  pv_result := ''; 
  --pv_result := 'S';
  
          
      /*obtener el ultimo si hay evento de evento registrado */
      begin 
        select mensaje into lv_evento from  (
          select substr(t.aqpb624dese,1,20)||'-'||to_char(t.aqpb624freg,'rrrrmmdd') mensaje  
          from AQPB624 t , fst198 g
          where t.aqpb624pais = pn_pgpais
                and t.aqpb624tdoc = pn_tipdoc
                and t.aqpb624ndoc = pv_numdoc
                and t.aqpb624est = 'A' --registro activo
                and g.tp1cod = 1
                and g.tp1cod1 = 11162
                and g.tp1corr1 = 2
                and g.tp1corr2 = 0
                and t.aqpb624tipe = g.tp1desc
                order by t.aqpb624cor desc, t.aqpb624freg desc) 
           where rownum = 1 ;
      exception when others then 
        lv_evento := '';
       DBMS_OUTPUT.put_line(SQLERRM);                        
      end;
      
    pv_result := lv_evento;      
            
   exception
    WHEN OTHERS THEN
     pv_result :=''; 
     --pv_result :='S'; 
  
end sp_cr_eventos_desc;

-------------------------------------------------------------------------------------------------
  

---------------------------------------------------------------------------------------------


end PQ_CR_RIESGO_EVENTO;
/

