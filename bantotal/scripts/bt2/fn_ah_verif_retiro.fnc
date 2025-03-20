create or replace function FN_AH_VERIF_RETIRO(P_CUENTA NUMBER,
                                              P_FECHA DATE)
-- **********************************************************************************
  -- Nombre                     : SP_AH_CAMREMCTS
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Pasivas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 13/02/2014
  -- Autor de Creación          : SMARQUEZ
  -- Uso                        : ACCESOS TEMPORALES
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : Cuenta,FECHA 
  -- Descripción                : verifica si en la fecha introducida se realizo 
  --                              un retiro
  -- **********************************************************************************                                                  
    return number IS
    VFECHA DATE;
    VTODAY DATE;
    CUENTA NUMBER;
    VERIFICA NUMBER;
    
BEGIN
    VFECHA := P_FECHA;
    CUENTA := P_CUENTA;
       
    SELECT PGFAPE INTO VTODAY FROM FST017 WHERE PGCOD = 1;
    
    IF VFECHA <> VTODAY THEN
       BEGIN
         SELECT 1
           INTO VERIFICA         
            FROM FSH016 
           WHERE HCTA = CUENTA
             AND HCODMO = 1
             AND HMODUL = 21
             AND HTOPER = 2
             AND HFVCO = VFECHA
             AND ROWNUM = 1;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             VERIFICA := 0;
       END;       
    ELSE
       BEGIN
          SELECT 1
            INTO VERIFICA            
            FROM FSD016 
           WHERE CTNRO = CUENTA   
             AND MODULO = 21
             AND ITTOPE = 2
             AND ITDBHA = 1 
             AND ITFVAL = VFECHA;           
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             VERIFICA := 0;
       END;     
    END IF;

  RETURN VERIFICA;

END FN_AH_VERIF_RETIRO;
/

