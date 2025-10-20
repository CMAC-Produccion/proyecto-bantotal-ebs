create or replace package PQ_CR_JAQL975_LogReporte is
    -- *****************************************************************
    -- Nombre                     : paquete para almacenar el log de reportes
    -- Sistema                    : BANTOTAL
    -- M¿dulo                     : Creditos - Activas
    -- Versi¿n                    : 1.0
    -- Fecha de Creaci¿n          : 2015.11.10
    -- Autor de Creaci¿n          : DCASTRO
    -- Uso                        : Realiza Calculos
    -- Estado                     : Activo
    -- Acceso                     : P¿blico
    -- Par¿metros de Entrada      : P_D_FECPRO (FECHA De PROCESO)
    --                              
    -- Retorno                    : 
    -- Fecha de Modificaci¿n      : 
    -- Autor de la Modificaci¿n   : DCASTRO
    -- Descripci¿n de Modificaci¿n: se modifico fn_Cr_analista
    -- Fecha de Modificacion      : 22/09/2025
    -- Autor de la Modificaci¿n   : MCHAVEZ
    -- Descripci¿n de Modificaci¿n: se agrego el procedimiento:
    --                              - SP_CR_GRABAR_HISTORICO
    --                              - PQ_CR_CONTADOR_INI
    -- *****************************************************************

 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  
 procedure pr_cr_contador_ini(pn_numcor out number );
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure fn_cr_inserta(pc_nomrep in varchar2,
                         pc_codusu in varchar2,
                         pd_fecpro in date,
                         pc_horini in varchar2,
                         pc_horfin in varchar2           
                        ) ;  
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 procedure pr_cr_contador(pn_numcor out number );
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 PROCEDURE SP_CR_GRABAR_HISTORICO;

------------------------------------------         
end PQ_CR_JAQL975_LogReporte;
/
CREATE OR REPLACE PACKAGE BODY PQ_CR_JAQL975_LOGREPORTE IS
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  
  PROCEDURE PR_CR_CONTADOR_INI(PN_NUMCOR OUT NUMBER ) IS
    
    -- *****************************************************************
    -- NOMBRE                     : PR_CR_CONTADOR
    -- SISTEMA                    : BANTOTAL
    -- M¿DULO                     : CREDITOS - ACTIVAS
    -- VERSI¿N                    : 1.0
    -- FECHA DE CREACI¿N          : 2016.04.28
    -- AUTOR DE CREACI¿N          : DCASTRO
    -- USO                        : RETORNA MAXIMO CORRELATIVO REPORTE
    -- ESTADO                     : ACTIVO
    -- ACCESO                     : PUBLICO
    -- PAR¿METROS DE ENTRADA      :
    --                              
    -- RETORNO                    : 
    -- FECHA DE MODIFICACI¿N      : 24/09/2025
    -- AUTOR DE LA MODIFICACI¿N   : MCHAVEZ
    -- DESCRIPCI¿N DE MODIFICACI¿N: SE AGREGO EL NVL PARA RETORNAR 0 EN CASO DE NULL
    --
    -- *****************************************************************
    LN_NUMCOR NUMBER;
    
  BEGIN
  
   BEGIN 
    SELECT NVL(MAX(JAQL975COR), 0)
      INTO LN_NUMCOR
      FROM JAQL975;
   END;
  
   PN_NUMCOR := LN_NUMCOR;                     
      
  END PR_CR_CONTADOR_INI;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 PROCEDURE FN_CR_INSERTA(PC_NOMREP IN VARCHAR2,
                         PC_CODUSU IN VARCHAR2,
                         PD_FECPRO IN DATE,
                         PC_HORINI IN VARCHAR2,
                         PC_HORFIN IN VARCHAR2           
                        ) IS

    -- *****************************************************************
    -- NOMBRE                     : FN_CR_INSERTA
    -- SISTEMA                    : BANTOTAL
    -- M¿DULO                     : CREDITOS - ACTIVAS
    -- VERSI¿N                    : 1.0
    -- FECHA DE CREACI¿N          : 2016.07.25
    -- AUTOR DE CREACI¿N          : DCASTRO
    -- USO                        : INSERTA EN TABLA JAQL975 
    -- ESTADO                     : ACTIVO
    -- ACCESO                     : PUBLICO
    -- PAR¿METROS DE ENTRADA      :
    --                              
    -- RETORNO                    : 
    -- FECHA DE MODIFICACI¿N      : 
    -- AUTOR DE LA MODIFICACI¿N   : 
    -- DESCRIPCI¿N DE MODIFICACI¿N: 
    --
    -- *****************************************************************

 LN_NUMCOR NUMBER;
 PC_CODERR VARCHAR2(1000);
 PC_MSGERR VARCHAR2(1000);
 
 BEGIN
 
    PQ_CR_JAQL975_LOGREPORTE.PR_CR_CONTADOR(LN_NUMCOR);
    
    INSERT INTO JAQL975(JAQL975COR, JAQL975NOM, JAQL975USR, JAQL975FEC, JAQL975HIN, JAQL975HFI)    
    VALUES(LN_NUMCOR + 1, PC_NOMREP, PC_CODUSU, PD_FECPRO, PC_HORINI, PC_HORFIN );        
 
    COMMIT;
 EXCEPTION WHEN OTHERS THEN
   PC_CODERR := SQLCODE;
   PC_MSGERR := SQLERRM;      
 END FN_CR_INSERTA;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 PROCEDURE PR_CR_CONTADOR(PN_NUMCOR OUT NUMBER ) IS
    
    -- *****************************************************************
    -- NOMBRE                     : PR_CR_CONTADOR
    -- SISTEMA                    : BANTOTAL
    -- M¿DULO                     : CREDITOS - ACTIVAS
    -- VERSI¿N                    : 1.0
    -- FECHA DE CREACI¿N          : 2016.07.25
    -- AUTOR DE CREACI¿N          : DCASTRO
    -- USO                        : RETORNA MAXIMO CORRELATIVO POR FECHA PARA GENRAR REPORTE 
    -- ESTADO                     : ACTIVO
    -- ACCESO                     : PUBLICO
    -- PAR¿METROS DE ENTRADA      :
    --                              
    -- RETORNO                    : 
    -- FECHA DE MODIFICACI¿N      : 
    -- AUTOR DE LA MODIFICACI¿N   : 
    -- DESCRIPCI¿N DE MODIFICACI¿N: 
    --
    -- *****************************************************************
    LN_NUMCOR NUMBER;
    LD_FECHA DATE;
  BEGIN
  
    
    BEGIN
        SELECT PGFAPE INTO LD_FECHA FROM FST017 WHERE PGCOD = 1;
    
    END;
    
    
     BEGIN 
      SELECT MAX(JAQL975COR) 
        INTO LN_NUMCOR
        FROM JAQL975
       WHERE JAQL975FEC = LD_FECHA;
     EXCEPTION WHEN NO_DATA_FOUND THEN
       LN_NUMCOR := 0;          
     END;
    
     IF LN_NUMCOR IS NULL THEN
        LN_NUMCOR := 0;
     END IF;
     PN_NUMCOR := LN_NUMCOR;                     
      
  END PR_CR_CONTADOR;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  PROCEDURE SP_CR_GRABAR_HISTORICO IS
  -- ====================================================================================================
  -- NOMBRE                      : SP_CR_GRABAR_HISTORICO
  -- SISTEMA                     : BANTOTAL
  -- MODULO                      : CREDITOS - ACTIVAS
  -- VERSION                     : 1.0
  -- FECHA DE CREACION           : 18/09/2025
  -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
  -- USO                         : GRABAR EN LA TABLA HISTORICO LOS DATOS DE LA TABLA JAQL975
  -- PARAMETROS                  :
  -- ESTADO                      : ACTIVO
  -- ACCESO                      : PUBLICO
  -- ====================================================================================================
  -- FECHA DE MODIFICACION       : 
  -- AUTOR DE LA MODIFICACION    : 
  -- DESCRIPCION DE MODIFICACION : 
  -- ====================================================================================================
  
    PE_FECHA    DATE;
    PE_MES      NUMBER;
    PE_ANIO     NUMBER;
    SR_MES      CHAR(2);
    SR_ANIO     CHAR(4);
    SR_MES_SIG  CHAR(2);
    SR_ANIO_SIG CHAR(4);
    SR_MES_ACT  CHAR(2);
    SR_ANIO_ACT CHAR(4);
    STR_SQL     VARCHAR2(1000);
    PC_FECHA    DATE;
    
  BEGIN
     BEGIN
      SELECT A.PGFCIE
        INTO PC_FECHA
        FROM FST017 A
       WHERE A.PGCOD = 1;
     EXCEPTION
      WHEN OTHERS THEN
        NULL;
     END;
      
     PE_FECHA := PC_FECHA;
     IF (LAST_DAY(PE_FECHA) - PE_FECHA) = 0 THEN
        PE_FECHA := PE_FECHA - 1;
      
        PE_MES  := EXTRACT(MONTH FROM PE_FECHA);
        PE_ANIO := EXTRACT(YEAR FROM PE_FECHA);
    
        SR_MES_ACT  := LPAD(TO_CHAR(PE_MES), 2, '0');
        SR_ANIO_ACT := TO_CHAR(PE_ANIO);
    
        PE_MES := PE_MES + 1;
    
        IF PE_MES = 13 THEN
          SR_MES      := LPAD(TO_CHAR(1), 2, '0');
          SR_MES_SIG  := LPAD(TO_CHAR(2), 2, '0');
          SR_ANIO     := TO_CHAR(PE_ANIO + 1);
          SR_ANIO_SIG := TO_CHAR(PE_ANIO + 1);
        ELSIF PE_MES = 12 THEN
          SR_MES      := LPAD(TO_CHAR(PE_MES), 2, '0');
          SR_MES_SIG  := LPAD(TO_CHAR(1), 2, '0');
          SR_ANIO     := TO_CHAR(PE_ANIO);
          SR_ANIO_SIG := TO_CHAR(PE_ANIO + 1);
        ELSE
          SR_MES      := LPAD(TO_CHAR(TO_CHAR(PE_MES)), 2, '0');
          SR_MES_SIG  := LPAD(TO_CHAR(PE_MES + 1), 2, '0');
          SR_ANIO     := TO_CHAR(PE_ANIO);
          SR_ANIO_SIG := TO_CHAR(PE_ANIO);
        END IF;
      
      BEGIN
        STR_SQL := 'ALTER TABLE JAQL975H ADD PARTITION JAQL975H_' || SR_ANIO || '' ||
                   SR_MES || ' VALUES LESS THAN (TO_DATE(''' || SR_ANIO_SIG || '-' ||
                   SR_MES_SIG || '-01'',''YYYY-MM-DD''))';   
        EXECUTE IMMEDIATE STR_SQL;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      
      BEGIN
        STR_SQL := 'ALTER TABLE JAQL975H TRUNCATE PARTITION (JAQL975H_' ||
                   SR_ANIO_ACT || '' || SR_MES_ACT || ')';   
        EXECUTE IMMEDIATE STR_SQL;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
    
    -- GRABAR HISTORICO --
      BEGIN
        INSERT INTO JAQL975H
          (JAQL975HCOR,
           JAQL975HNOM,
           JAQL975HUSR,
           JAQL975HFEC,
           JAQL975HHIN,
           JAQL975HHFI)
          SELECT A.JAQL975COR,
                 A.JAQL975NOM,
                 A.JAQL975USR,
                 A.JAQL975FEC,
                 A.JAQL975HIN,
                 A.JAQL975HFI
            FROM JAQL975 A;
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      
      -- BORRAR DATA TABLA ORIGINAL JAQL975 --
      BEGIN
        STR_SQL := 'TRUNCATE TABLE JAQL975 DROP STORAGE';   
        EXECUTE IMMEDIATE STR_SQL;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
  END SP_CR_GRABAR_HISTORICO;
 
----------------------------------------------------------------------------------------
END PQ_CR_JAQL975_LOGREPORTE;
/
