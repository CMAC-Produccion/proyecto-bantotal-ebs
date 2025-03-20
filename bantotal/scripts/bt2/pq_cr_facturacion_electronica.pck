create or replace package PQ_CR_FACTURACION_ELECTRONICA is

  /**************************************************************************************************************
  -- Nombre                     : PQ_CR_FACTURACION_ELECTRONICA                                               
  -- Sistema                    : Bantotal                                                                    
  -- Módulo                     : Activas                                                                     
  -- Versión                    : 1.0                                                                         
  -- Fecha de Creación          : 23/09/2022                                                                  
  -- Autor de Creación          : Maycol Chavez Chuman                                                        
  ***************************************************************************************************************
  -- Fecha de Modificación      :                                                                             
  -- Autor de la Modificación   :                                                                             
  -- Descripción de Modificación:                                                                             
  **************************************************************************************************************/

  PROCEDURE SP_CR_MNT_EMP_RECAUDADORAS(pInModo IN VARCHAR2, pInRuc IN VARCHAR2, pInRzs IN VARCHAR2, pInEst IN VARCHAR2, pInUsuIngr IN VARCHAR2, 
                                       pInFchIngr IN DATE, pInHorIngr IN VARCHAR2, pOutRes OUT VARCHAR2);
                                      
  PROCEDURE SP_CR_GUARDA_CMPRB_EST_DIF;
  
  PROCEDURE SP_CR_ACTUALIZA_EST_MASIVO;

end  PQ_CR_FACTURACION_ELECTRONICA;
/

create or replace package body PQ_CR_FACTURACION_ELECTRONICA is
  
  /**************************************************************************************************************
  -- Nombre                     : SP_CR_MNT_EMP_RECAUDADORAS                                                  
  -- Sistema                    : Bantotal                                                                    
  -- Módulo                     : Activas                                                                     
  -- Descripción                : Mantenedor de Empresas Recaudadoras                                    
  -- Versión                    : 1.0                                                                         
  -- Fecha de Creación          : 23/09/2022                                                                  
  -- Autor de Creación          : Maycol Chavez Chuman                                                        
  ***************************************************************************************************************
  -- Fecha de Modificación      :                                                                             
  -- Autor de la Modificación   :                                                                             
  -- Descripción de Modificación:                                                                             
  **************************************************************************************************************/
  
  PROCEDURE SP_CR_MNT_EMP_RECAUDADORAS(
  pInModo    IN VARCHAR2, 
  pInRuc     IN VARCHAR2, 
  pInRzs     IN VARCHAR2, 
  pInEst     IN VARCHAR2, 
  pInUsuIngr IN VARCHAR2, 
  pInFchIngr IN DATE, 
  pInHorIngr IN VARCHAR2,
  pOutRes   OUT VARCHAR2) IS
  vEstado VARCHAR2(1) := NULL;
  BEGIN
    IF pInModo = 'SEL' THEN
      BEGIN
        SELECT AQPC262EST
        INTO vEstado
        FROM AQPC262
        WHERE AQPC262RUC = pInRuc;
        pOutRes := vEstado;
      EXCEPTION
        WHEN OTHERS THEN
          pOutRes := 'X';
      END;
    ELSIF pInModo = 'INS' THEN
      BEGIN
        INSERT INTO AQPC262 VALUES(pInRuc, pInRzs, pInEst, pInUsuIngr, pInFchIngr, pInHorIngr);
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
             NULL;
        END;
    ELSIF pInModo = 'UPD' THEN
      BEGIN
        UPDATE AQPC262 SET AQPC262EST = pInEst WHERE AQPC262RUC = pInRuc;
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
        END;  
    END IF;
  END SP_CR_MNT_EMP_RECAUDADORAS;
  
  /**************************************************************************************************************
  -- Nombre                     : SP_CR_GUARDA_CMPRB_EST_DIF                                                  
  -- Sistema                    : Bantotal                                                                    
  -- Módulo                     : Activas                                                                     
  -- Descripción                : Guardar los Comprobantes con Estado Diferentes                                    
  -- Versión                    : 1.0                                                                         
  -- Fecha de Creación          : 23/09/2022                                                                  
  -- Autor de Creación          : Maycol Chavez Chuman                                                        
  ***************************************************************************************************************
  -- Fecha de Modificación      :                                                                             
  -- Autor de la Modificación   :                                                                             
  -- Descripción de Modificación:                                                                             
  **************************************************************************************************************/
  
  PROCEDURE SP_CR_GUARDA_CMPRB_EST_DIF IS
  --------------- CURSOR ---------------
  CURSOR LISTA IS SELECT * FROM AQPC270; 
  --------------- VARIABLES ---------------
  CONT1  NUMBER(9)    := 0;
  CONT2  NUMBER(9)    := 0;
  SERIE  CHAR(4)      := ' ';
  CORR   NUMBER(9)    := 0;
  EST270 VARCHAR2(20) := ' ';
  EST465 VARCHAR2(1)  := ' ';
  EST466 VARCHAR2(1)  := ' ';
  FCHSYS DATE         := TO_DATE(TO_CHAR(SYSDATE, 'DD/MM/YYYY'), 'DD/MM/YYYY');
  BEGIN
    BEGIN
      DELETE FROM AQPC272;
      COMMIT;
      DELETE FROM AQPC273;
      COMMIT;
    END;
    FOR X IN LISTA LOOP
      BEGIN
        SELECT AQPC270ESUN
        INTO EST270
        FROM AQPC270
        WHERE AQPC270NRCP = X.AQPC270NRCP AND 
        AQPC270FEMI = (SELECT MAX(AQPC270FEMI) FROM AQPC270 WHERE AQPC270NRCP = X.AQPC270NRCP) AND
        AQPC270FENV = (SELECT MAX(AQPC270FENV) FROM AQPC270 WHERE AQPC270NRCP = X.AQPC270NRCP);
      END;
      SERIE := SUBSTR(X.AQPC270NRCP, 1, 4);
      CORR  := SUBSTR(X.AQPC270NRCP, 6, 9);
      CASE
        WHEN (SERIE = 'BS01' OR SERIE = 'FM01' OR SERIE = 'FT01' OR
              SERIE = 'BF01' OR SERIE = 'FH01' OR SERIE = 'FN01' OR
              SERIE = 'FF01' OR SERIE = 'BO01' OR SERIE = 'FS01') THEN
          BEGIN
            SELECT AQPA465EST 
            INTO EST465
            FROM AQPA465
            WHERE AQPA465SERIE = SERIE AND AQPA465CORR = CORR;
            CASE 
              WHEN (EST270 = 'Aceptado' OR EST270 = 'Aceptado con Obs.') THEN
                IF EST465 <> 'A' THEN
                  CONT1 := CONT1 + 1;
                  BEGIN
                    INSERT INTO AQPC272 VALUES
                    (X.AQPC270TPCP, X.AQPC270NRCP, X.AQPC270FEMI, X.AQPC270FENV, EST465, 'A', X.AQPC270TDOC, X.AQPC270NRDC,
                     X.AQPC270RZS, X.AQPC270MDSC, X.AQPC270MTCI, X.AQPC270MDA, X.AQPC270NDCR, X.AQPC270IDCL,
                     X.AQPC270IDRS, X.AQPC270OBS, X.AQPC270ETRM, X.AQPC270ESUN, X.AQPC270ECOR, X.AQPC270EPDF,
                     X.AQPC270NRIN, X.AQPC270TINT, X.AQPC270SEMI, X.AQPC270SUC, X.AQPC270PEMI, X.AQPC270GRVD,
                     X.AQPC270INFT, X.AQPC270EXND, X.AQPC270GRTA, X.AQPC270EXPR, 'AQPA465');
                     COMMIT;
                  END;
                END IF;
              WHEN EST270 = 'Excepción' THEN
                IF EST465 <> 'E' OR EST465 <> 'R' THEN
                  CONT2 := CONT2 + 1;
                  BEGIN
                    INSERT INTO AQPC272 VALUES
                    (X.AQPC270TPCP, X.AQPC270NRCP, X.AQPC270FEMI, X.AQPC270FENV, EST465, 'E', X.AQPC270TDOC, X.AQPC270NRDC,
                     X.AQPC270RZS, X.AQPC270MDSC, X.AQPC270MTCI, X.AQPC270MDA, X.AQPC270NDCR, X.AQPC270IDCL,
                     X.AQPC270IDRS, X.AQPC270OBS, X.AQPC270ETRM, X.AQPC270ESUN, X.AQPC270ECOR, X.AQPC270EPDF,
                     X.AQPC270NRIN, X.AQPC270TINT, X.AQPC270SEMI, X.AQPC270SUC, X.AQPC270PEMI, X.AQPC270GRVD,
                     X.AQPC270INFT, X.AQPC270EXND, X.AQPC270GRTA, X.AQPC270EXPR, 'AQPA465');
                     COMMIT;
                  END;
                END IF;
              ELSE
                NULL;
            END CASE;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              NULL;
          END;
        WHEN (SERIE = 'BC01' OR SERIE = 'FC01' OR SERIE = 'FG01') THEN
          BEGIN
            SELECT AQPA466EST 
            INTO EST466
            FROM AQPA466
            WHERE AQPA466SERIE = SERIE AND AQPA466CORR = CORR;
            CASE 
              WHEN (EST270 = 'Aceptado' OR EST270 = 'Aceptado con Obs.') THEN
                IF EST466 <> 'A' THEN
                  CONT1 := CONT1 + 1;
                  BEGIN
                    INSERT INTO AQPC272 VALUES
                    (X.AQPC270TPCP, X.AQPC270NRCP, X.AQPC270FEMI, X.AQPC270FENV, EST466, 'A', X.AQPC270TDOC, X.AQPC270NRDC,
                     X.AQPC270RZS, X.AQPC270MDSC, X.AQPC270MTCI, X.AQPC270MDA, X.AQPC270NDCR, X.AQPC270IDCL,
                     X.AQPC270IDRS, X.AQPC270OBS, X.AQPC270ETRM, X.AQPC270ESUN, X.AQPC270ECOR, X.AQPC270EPDF,
                     X.AQPC270NRIN, X.AQPC270TINT, X.AQPC270SEMI, X.AQPC270SUC, X.AQPC270PEMI, X.AQPC270GRVD,
                     X.AQPC270INFT, X.AQPC270EXND, X.AQPC270GRTA, X.AQPC270EXPR, 'AQPA466');
                     COMMIT;
                  END;
                END IF;
              WHEN EST270 = 'Excepción' THEN
                IF (EST466 <> 'E' OR EST466 <> 'R') THEN
                  CONT2 := CONT2 + 1;
                  BEGIN
                    INSERT INTO AQPC272 VALUES
                    (X.AQPC270TPCP, X.AQPC270NRCP, X.AQPC270FEMI, X.AQPC270FENV, EST466, 'E', X.AQPC270TDOC, X.AQPC270NRDC,
                     X.AQPC270RZS, X.AQPC270MDSC, X.AQPC270MTCI, X.AQPC270MDA, X.AQPC270NDCR, X.AQPC270IDCL,
                     X.AQPC270IDRS, X.AQPC270OBS, X.AQPC270ETRM, X.AQPC270ESUN, X.AQPC270ECOR, X.AQPC270EPDF,
                     X.AQPC270NRIN, X.AQPC270TINT, X.AQPC270SEMI, X.AQPC270SUC, X.AQPC270PEMI, X.AQPC270GRVD,
                     X.AQPC270INFT, X.AQPC270EXND, X.AQPC270GRTA, X.AQPC270EXPR, 'AQPA466');
                     COMMIT;
                  END;
                END IF;
            END CASE;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              NULL;
          END;
        ELSE
          NULL;
      END CASE;
    END LOOP;
    BEGIN
      INSERT INTO AQPC273 VALUES(FCHSYS, CONT1, CONT2);
      COMMIT;
    END;
  END SP_CR_GUARDA_CMPRB_EST_DIF;
  
  /**************************************************************************************************************
  -- Nombre                     : SP_CR_ACTUALIZA_EST_MASIVO                                                  
  -- Sistema                    : Bantotal                                                                    
  -- Módulo                     : Activas                                                                     
  -- Descripción                : Actualiza el Estado Masivamente                                   
  -- Versión                    : 1.0                                                                         
  -- Fecha de Creación          : 23/09/2022                                                                  
  -- Autor de Creación          : Maycol Chavez Chuman                                                        
  ***************************************************************************************************************
  -- Fecha de Modificación      :                                                                             
  -- Autor de la Modificación   :                                                                             
  -- Descripción de Modificación:                                                                             
  **************************************************************************************************************/
    
  PROCEDURE SP_CR_ACTUALIZA_EST_MASIVO IS
  --------------- CURSOR ---------------
  CURSOR LISTA IS SELECT * FROM AQPC272;
  --------------- VARIABLES ---------------
  TABLA  VARCHAR2(7) := ' ';
  SERIE  CHAR(4)     := ' ';
  CORR   NUMBER(9)   := 0;
  EST272 CHAR(1)     := ' ';
  BEGIN
    FOR X IN LISTA LOOP
      TABLA  := X.AQPC272TBL;
      EST272 := X.AQPC272EST2;
      SERIE  := SUBSTR(X.AQPC272NRCP, 1, 4);
      CORR   := SUBSTR(X.AQPC272NRCP, 6, 9);
      CASE
        WHEN TABLA = 'AQPA465' THEN
          BEGIN
            UPDATE AQPA465 SET AQPA465EST = EST272 WHERE AQPA465SERIE = SERIE AND AQPA465CORR = CORR;
            COMMIT;
            DELETE FROM AQPC273;
            COMMIT;
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
        WHEN TABLA = 'AQPA466' THEN
          BEGIN
            UPDATE AQPA466 SET AQPA466EST = EST272 WHERE AQPA466SERIE = SERIE AND AQPA466CORR = CORR;
            COMMIT;
            DELETE FROM AQPC273;
            COMMIT;
          EXCEPTION
            WHEN OTHERS THEN
              NULL;
          END;
        ELSE
          NULL;
      END CASE;
    END LOOP;
  END SP_CR_ACTUALIZA_EST_MASIVO;
      
end PQ_CR_FACTURACION_ELECTRONICA;
/

