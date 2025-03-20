create or replace procedure SP_CR_NIVEL_RIESGO(PC_CODUSU in char, PC_INDICADOR out varchar2) is
 -- *****************************************************************
  -- Nombre                     : SP_CR_NIVEL_RIESGO
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2024.07.31
  -- Uso                        : PROCEDIMIENTO RETORNA NIVEL DE RIESGO DEL ANALISTA
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Autor de la Modificación   : DCASTRO
  -- Descripción de Modificación: 
  -- Fecha de Modificación      : 
  -- *****************************************************************

  ------------------------------------------------------------------------------  
  
    pc_nivelAna varchar2(30):= null;
    lc_indicador char(1);
    
BEGIN
    lc_indicador := 'N';  
    BEGIN
      SELECT UPPER(substr(a.AQPB883RAT, 3, 11)) 
        into pc_nivelAna
        FROM AQPB883 a
       WHERE AQPB883ANA = UPPER(TRIM(PC_CODUSU))
         AND AQPB883FEC =
             (SELECT MAX(AQPB883FEC)
                FROM AQPB883
               WHERE AQPB883ANA = UPPER(TRIM(PC_CODUSU)))
         and rownum < 2;
    EXCEPTION
      WHEN OTHERS THEN
            pc_nivelAna := '';
    END;
    
    begin
      select 'S'
        into lc_indicador
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 10943
         and f.tp1corr1 = 40
         and f.tp1corr2 = 1
         and f.tp1corr3 > 0
         and trim(f.tp1desc) = trim(pc_nivelAna);
     exception when others then
        lc_indicador := 'N';
     end;
    
     PC_INDICADOR := lc_indicador;
     
end SP_CR_NIVEL_RIESGO;
/

