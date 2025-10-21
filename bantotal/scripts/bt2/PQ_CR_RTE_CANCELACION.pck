create or replace package PQ_CR_RTE_CANCELACION is

-- *****************************************************************
-- Nombre   : PQ_CR_RTE_CANCELACION
-- Sistema    : BANTOTAL
-- Módulo   : Activas
-- Versión    : 1.0
-- Fecha de Creación  : 17/09/2025
-- Autor de Creación  : MCORDOVA
-- Uso      : Uso
-- Estado   : Activo
-- Acceso   : Público
-- *****************************************************************
    PROCEDURE SP_CR_VALIDA(
    Ppgcod IN NUMBER,
    PItsuc IN NUMBER,
    PItmod IN NUMBER,
    PIttran IN NUMBER,
    PItnrel IN NUMBER,
    Pitord IN NUMBER,
    Pitsbor IN NUMBER,
    Pcancel OUT VARCHAR2);
    
END PQ_CR_RTE_CANCELACION;
/
create or replace package body PQ_CR_RTE_CANCELACION is
-- *****************************************************************
-- Nombre                       : PQ_CR_RTE_CANCELACION
-- Sistema                      : BANTOTAL
-- Módulo                       : Activas
-- Versión                      : 1.0
-- Fecha de Creación            : 17/09/2025
-- Autor de Creación            : Milton Cordova
-- Uso                          : Uso
-- Estado                       : Activo
-- Acceso                       : Público
-- Parámetros de Entrada        : Ppgcod, PItsuc, PItmod, PIttran, PItnrel, Pitord, Pitsbor
-- Retorno                      : Pcancel
--------------------------------------------------------------------
-- Fecha de Modificación  : 
-- Autor de la Modificación : 
-- Descripción de Modificación  : 
-- *****************************************************************
    PROCEDURE SP_CR_VALIDA(
    Ppgcod IN NUMBER,
    PItsuc IN NUMBER,
    PItmod IN NUMBER,
    PIttran IN NUMBER,
    PItnrel IN NUMBER,
    Pitord IN NUMBER,
    Pitsbor IN NUMBER,
    Pcancel OUT VARCHAR2) IS
    
    V_USU_DES CHAR(10);
    V_PGCOD NUMBER(3);
    V_MODULO NUMBER(3);
    V_ITTOPE NUMBER(3);
    V_ITSUCD NUMBER(3);
    V_MONEDA NUMBER(4);
    V_PAPEL NUMBER(4);
    V_CTNRO NUMBER(9);
    V_ITOPER NUMBER(9);
    V_ITSUBO NUMBER(3);
    V_CONT_UNICUOTA NUMBER(3);
    V_CONT_UNICUOTA_C NUMBER(3);
    V_CUENTA NUMBER(9);
    V_USU_CAN CHAR(10);
    
    X_PGCOD NUMBER(3);
    V_PPMOD NUMBER(3); 
    V_PPSUC NUMBER(3);
    V_PPMDA NUMBER(4); 
    V_PPPAP NUMBER(4); 
    V_PPCTA NUMBER(9);
    V_PPOPER NUMBER(9); 
    V_PPSBOP NUMBER(3); 
    V_PPTOPE NUMBER(3);
    V_D602CD NUMBER(3);
    V_D602MO NUMBER(3);
    V_D602SU NUMBER(3);
    V_D602TR NUMBER(3);
    V_D602RE NUMBER(4);
    V_D602CO CHAR(1);
    V_EXCEPTUA NUMBER(10);
    
    CURSOR C1(V_CUENTA NUMBER) IS
      SELECT T2.PGCOD, T2.AOMOD, T2.AOSUC, T2.AOMDA, 
      T2.AOPAP, T2.AOCTA, T2.AOOPER, T2.AOSBOP, T2.AOTOPE    
      FROM FSR008 T1 JOIN FSD010 T2 ON 
      T1.PGCOD = T2.PGCOD AND
      T1.CTNRO = T2.AOCTA
      WHERE 
      T2.AOSTAT = 99 AND -- CREDITO CANCELADO
      T1.CTTFIR = 'T' AND 
      T1.PENDOC = (SELECT PENDOC FROM FSR008 WHERE CTNRO = V_CUENTA AND CTTFIR = 'T' AND ROWNUM = 1) AND
      AOFE99 = (SELECT PGFAPE FROM FST017 WHERE PGCOD = 1);
      
    BEGIN
      Pcancel := 'N';
      BEGIN
        -- OBTIENE USUARIO DESEMBOLSO
        SELECT ITUING INTO V_USU_DES 
        FROM FSD015 WHERE ITSUC = PItsuc AND ITMOD = PItmod AND ITTRAN = PIttran AND ITNREL = PItnrel;
      EXCEPTION
        WHEN OTHERS THEN NULL;
      END;
      -- OBTIENE LLAVE DEL CREDITO
      BEGIN       
        SELECT PGCOD, MODULO, ITTOPE, ITSUCD, MONEDA, PAPEL, CTNRO, ITOPER, ITSUBO INTO
        V_PGCOD, V_MODULO, V_ITTOPE, V_ITSUCD, V_MONEDA, V_PAPEL, V_CTNRO, V_ITOPER, V_ITSUBO        
        FROM FSD016 WHERE ITSUC = PItsuc AND ITMOD = PItmod AND ITTRAN = PIttran AND ITNREL = PItnrel AND ITORD = Pitord;
      EXCEPTION
        WHEN OTHERS THEN NULL;   
      END;
      
      -- OBTIENE INSTANCIA EN VUELO - EXCEPTUAR RTE
      BEGIN
        SELECT COUNT(*) INTO V_EXCEPTUA FROM AQPC240 WHERE AQPC240INS =       
        (SELECT XWFPRCINS FROM XWF700 WHERE
        XWFEMPRESA = V_PGCOD AND XWFSUCURSAL = V_ITSUCD AND XWFMODULO = V_MODULO AND 
        XWFMONEDA = V_MONEDA AND XWFPAPEL = V_PAPEL AND XWFCUENTA = V_CTNRO AND 
        XWFOPERACION = V_ITOPER AND XWFSUBOPE = V_ITSUBO AND XWFTIPOPE = V_ITTOPE AND 
        XWFCAR3 = '1' AND ROWNUM = 1);
        
        IF V_EXCEPTUA >= 1 THEN -- SI INSTANCIA EXISTE EN GUIA, SE EXCEPTUA
          Pcancel := 'N';
          RETURN;
        END IF;
      EXCEPTION
        WHEN OTHERS THEN NULL;
      END;

      -- VALIDA SI CREDITO EN VUELO ES UNICUOTA
      BEGIN
        SELECT COUNT(*) INTO V_CONT_UNICUOTA FROM FSD601 WHERE
        PGCOD = V_PGCOD AND 
        PPMOD = V_MODULO AND 
        PPSUC = V_ITSUCD AND 
        PPMDA = V_MONEDA AND 
        PPPAP = V_PAPEL AND 
        PPCTA = V_CTNRO AND
        PPOPER = V_ITOPER AND 
        PPSBOP = V_ITSUBO AND
        PPTOPE = V_ITTOPE;
      EXCEPTION
        WHEN OTHERS THEN NULL;
      END;
      
      -- SOLO INGRESAN CREDITOS EN VUELO UNICUOTA
      IF V_CONT_UNICUOTA = 1 THEN        
        BEGIN
          -- VALIDA TODOS LOS CREDITOS CANCELADOS DEL CLIENTE
          FOR X IN C1(V_CTNRO)LOOP  
            BEGIN
              -- VALIDA SI CREDITO CANCELADO ES UNICUOTA
              SELECT COUNT(*) INTO V_CONT_UNICUOTA_C FROM FSD601 WHERE
              PGCOD = X.PGCOD AND 
              PPMOD = X.AOMOD AND 
              PPSUC = X.AOSUC AND 
              PPMDA = X.AOMDA AND 
              PPPAP = X.AOPAP AND 
              PPCTA = X.AOCTA AND
              PPOPER = X.AOOPER AND 
              PPSBOP = X.AOSBOP AND
              PPTOPE = X.AOTOPE;
            EXCEPTION
              WHEN OTHERS THEN NULL;
            END;
            
            If V_CONT_UNICUOTA_C = 1 THEN  -- INGRESA SI ES CREDITO UNICUOTA     
            BEGIN 
              -- OBTIENE TRANSACCION CANCELACION
              SELECT 
              PGCOD, PPMOD, PPSUC, PPMDA, PPPAP, PPCTA, 
              PPOPER, PPSBOP, PPTOPE, D602CD, D602MO, 
              D602SU, D602TR, D602RE, D602CO
              INTO
              X_PGCOD, V_PPMOD, V_PPSUC, V_PPMDA, V_PPPAP, V_PPCTA, 
              V_PPOPER, V_PPSBOP, V_PPTOPE, V_D602CD, V_D602MO, 
              V_D602SU, V_D602TR, V_D602RE, V_D602CO
              FROM FSD602 WHERE 
              PGCOD = X.PGCOD AND PPMOD = X.AOMOD AND PPSUC = X.AOSUC AND
              PPMDA = X.AOMDA AND PPPAP = X.AOPAP AND PPCTA = X.AOCTA AND
              PPOPER = X.AOOPER AND PPSBOP = X.AOSBOP AND PPTOPE = X.AOTOPE AND 
              PP1NUMP = (SELECT MAX(PP1NUMP)
              FROM FSD602 WHERE 
              PGCOD = X.PGCOD AND PPMOD = X.AOMOD AND PPSUC = X.AOSUC AND
              PPMDA = X.AOMDA AND PPPAP = X.AOPAP AND PPCTA = X.AOCTA AND
              PPOPER = X.AOOPER AND PPSBOP = X.AOSBOP AND PPTOPE = X.AOTOPE AND 
              PP1STAT = 'T' AND D602CO = 'S') AND 
              PPFPAG = (SELECT MAX(PPFPAG)
              FROM FSD602 WHERE 
              PGCOD = X.PGCOD AND PPMOD = X.AOMOD AND PPSUC = X.AOSUC AND
              PPMDA = X.AOMDA AND PPPAP = X.AOPAP AND PPCTA = X.AOCTA AND
              PPOPER = X.AOOPER AND PPSBOP = X.AOSBOP AND PPTOPE = X.AOTOPE AND 
              PP1STAT = 'T' AND D602CO = 'S'); 
            EXCEPTION
              WHEN OTHERS THEN NULL;
            END;
            BEGIN
              -- OBTIENE USUARIO CANCELACION
              SELECT ITUING INTO V_USU_CAN 
              FROM FSD015 WHERE 
              PGCOD = V_D602CD AND 
              ITSUC = V_D602SU AND 
              ITMOD = V_D602MO AND 
              ITTRAN = V_D602TR AND 
              ITNREL = V_D602RE;
            EXCEPTION
              WHEN OTHERS THEN NULL;
            END;
            BEGIN
              -- GRABA LOG CREDITO UNICUOTA CANCELADO               
              INSERT INTO AQPC239 VALUES(
              X_PGCOD,V_PPSUC,
              V_PPMOD,V_PPMDA,V_PPCTA,V_PPOPER,
              V_PPPAP,V_PPSBOP,V_PPTOPE,(SELECT PGFAPE FROM FST017 WHERE PGCOD = 1),V_USU_DES,
              V_USU_CAN,V_D602SU,V_D602MO,V_D602TR,
              V_D602RE,V_D602CO,'','',
              '','','');         
              COMMIT;
            EXCEPTION
              WHEN OTHERS THEN NULL;
            END;
            BEGIN
              -- VALIDA SI USUARIO DESEMBOLSO ES IGUAL A USUARIO CANCELACION
              IF V_USU_CAN = V_USU_DES THEN
                Pcancel := 'S';
              END IF;
            EXCEPTION
              WHEN OTHERS THEN NULL;
            END;
            END IF;
          END LOOP;
        EXCEPTION
          WHEN OTHERS THEN NULL;
        END;
      ELSE
        Pcancel := 'N';
      END IF;
    END SP_CR_VALIDA; 
                            
END PQ_CR_RTE_CANCELACION;



        
/
