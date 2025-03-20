create or replace package pq_cr_process_opini_riesgo is

    -- *****************************************************************
    -- Nombre                     : PAQUETES PARA OPINION DE RIESGOS CRM
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 11/11/2023 
    -- Autor de Creación          : IGS_RCASTRO
    -- Uso                        : Realiza cálculos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      :
    -- Fecha de Modificación      : 31/07/2024
    -- Autor de la Modificación   : Rcastro - igs
    -- Descripción de Modificación: Se modifica guia fst198 
    -- *****************************************************************
-----------------------------------------------------------------------

 
  PROCEDURE sp_upd_estados_cambio_fecha(fechaActual DATE);
  PROCEDURE sp_upd_aqpc813_cod_opi;
 
end pq_cr_process_opini_riesgo;
/

create or replace package body pq_cr_process_opini_riesgo is

 
  PROCEDURE sp_upd_estados_cambio_fecha(fechaActual DATE) IS
  v_count number(10);  
  v_fechpro date;
  v_estop   varchar2(2);
  BEGIN    
     BEGIN
       SELECT TP1NRO3 into v_count FROM fst198 where tp1cod = 1 and tp1cod1 = 11152 and TP1CORR1 = 53 and tp1corr2 = 1  AND TP1CORR3 = 1;  
     EXCEPTION 
       WHEN OTHERS THEN
         v_count := 0;
     END; 
     
     BEGIN
        v_fechpro := (fechaActual - v_count); 
     EXCEPTION 
       WHEN OTHERS THEN
         NULL;      
     END;     
     v_estop := 'T ';
     --v_estop := rpad(v_estop, 2, ' ');
     
     BEGIN
        UPDATE AQPC818 A SET
        AQPC818ESTAD = 'X',
        AQPC818ESTOP = 'X'
        WHERE A.AQPC818AUX3 = v_fechpro AND A.AQPC818ESTAD = 'H' AND AQPC818ESTOP <> v_estop; --(fechaActual - 1)
        COMMIT;
     EXCEPTION 
       WHEN OTHERS THEN
         NULL;
     END;
  END;
  
  PROCEDURE sp_upd_aqpc813_cod_opi is    
  CURSOR reg_aqpc183 IS 
  SELECT * FROM AQPC813;
  
  codOpinion number(10);
  
  BEGIN
     FOR reg IN reg_aqpc183 LOOP
        BEGIN
          SELECT A.AQPC156CODOPI INTO codOpinion FROM AQPC156 A WHERE 
          A.AQPC156INSTAN = REG.AQPC813INSTAN AND
          A.AQPC156ESTAD = 'H' AND
          ROWNUM = 1;
        EXCEPTION 
          WHEN OTHERS THEN
            codOpinion := 0;
        END;
        
        BEGIN
           UPDATE AQPC813 
           SET AQPC813AUX2 = codOpinion
           WHERE AQPC813INSTAN = REG.AQPC813INSTAN;
           COMMIT;
        EXCEPTION 
          WHEN OTHERS THEN
            NULL;
        END;
        
     END LOOP;
  END;  
            

end pq_cr_process_opini_riesgo;
/

