create or replace procedure SP_CR_CALIFIC_RCC_IMPULSA(instancia in number,
                                                      VAL_NORM  OUT number,
                                                      DSC_NORM  OUT varchar2,
                                                      VAL_CPP   OUT NUMBER,
                                                      DSC_CPP   OUT VARCHAR2,
                                                      VAL_DEFC  OUT NUMBER,
                                                      DSC_DEFC  OUT VARCHAR2,
                                                      VAL_DUDS  OUT NUMBER,
                                                      DSC_DUDS  OUT VARCHAR2,
                                                      VAL_PERP  OUT NUMBER,
                                                      DSC_PERP  OUT VARCHAR2) is
/* ************************************************************************************************************
     -- Nombre                     : SP_CR_CALIFIC_RCC_IMPULSA
     -- Sistema                    : BANTOTAL
     -- Módulo                     : ACTIVAS
     -- Descripción                : RP - Calificación en el RCC - Impulsa Perú
     -- Versión                    : 1.0
     -- Fecha de Creación          : 04/03/2024
     -- Autor de Creación          : IGS_RCASTRO
     -- Estado                     : Activo
     -- Acceso                     : Público
     -- Fecha de Modificación      : 
     -- Autor de la Modificación   : 
     -- Descripción de Modificación: 
     
  * *************************************************************************************************************/                                                        

  V_FECHA   DATE;
  V_CALIF0    NUMBER(5, 2);
  V_CALIF1    NUMBER(5, 2);
  V_CALIF2    NUMBER(5, 2);
  V_CALIF3    NUMBER(5, 2);
  V_CALIF4    NUMBER(5, 2);
  V_FLAG      VARCHAR2(1);
  V_TDOC_ID   VARCHAR2(1);
  
  V_PEPAIS NUMBER;
  V_PETDOC NUMBER;
  P_NDOC  VARCHAR2(12);  
begin
  BEGIN
    SELECT TO_DATE(TRIM(TO_CHAR(TPNRO)), 'DD/MM/RRRR')
      INTO V_FECHA
      FROM FST098
     WHERE PGCOD = 1
       AND TPCOD = 7647
       AND TPCORR = 12;
  EXCEPTION
    WHEN OTHERS THEN
      V_FECHA := NULL;
  END;
  
  BEGIN
    SELECT D.SNG001PAIS,
    D.SNG001TDOC,
    D.SNG001NDOC INTO
    V_PEPAIS,
    V_PETDOC,
    P_NDOC     
    FROM SNG001 D WHERE 
    D.SNG001INST = instancia;
  EXCEPTION
    WHEN OTHERS THEN
      P_NDOC := '';
  END;   
  P_NDOC := trim(P_NDOC);     

  BEGIN
    SELECT TRIM(TO_CHAR(TP1NRO2))
      INTO V_TDOC_ID
      FROM FST198
     WHERE TP1COD = 1
       AND TP1COD1 = 11111
       AND TP1CORR1 = 1
       AND TP1CORR2 = 5
       AND TP1CORR3 > 0
       AND TP1NRO1 = V_PETDOC;
  EXCEPTION
    WHEN OTHERS THEN
      V_TDOC_ID := NULL;
  END;
    
  BEGIN
    SELECT 'S',
           NVL(N_CALIF0, 0),
           NVL(N_CALIF1, 0),
           NVL(N_CALIF2, 0),
           NVL(N_CALIF3, 0),
           NVL(N_CALIF4, 0)
      INTO V_FLAG, V_CALIF0, V_CALIF1, V_CALIF2, V_CALIF3, V_CALIF4
      FROM CLDRCCI
     WHERE D_FECPRE = V_FECHA
       AND C_TDOCID = V_TDOC_ID
       AND C_DOCIDE = P_NDOC
       AND ROWNUM = 1;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      V_FLAG := 'N';
      BEGIN
        SELECT 'S',
               NVL(N_CALIF0, 0),
               NVL(N_CALIF1, 0),
               NVL(N_CALIF2, 0),
               NVL(N_CALIF3, 0),
               NVL(N_CALIF4, 0)
          INTO V_FLAG, V_CALIF0, V_CALIF1, V_CALIF2, V_CALIF3, V_CALIF4
          FROM CLDRCCI
         WHERE D_FECPRE = V_FECHA
           AND C_TDOCTR = V_TDOC_ID
           AND C_DOCTRI = P_NDOC
           AND ROWNUM = 1;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          V_FLAG := 'N';
        WHEN OTHERS THEN
          V_FLAG := NULL;
      END;
    WHEN OTHERS THEN
      V_FLAG := NULL;
  END;
  
  IF V_FLAG = 'N' OR (V_CALIF0 + V_CALIF1 + V_CALIF2 + V_CALIF3 + V_CALIF4) = 0 THEN
     V_CALIF0 := 100;
     DSC_NORM := 'NORMAL';
  END IF; 
       
  V_CALIF0 := nvl(V_CALIF0, 0);
  V_CALIF1 := nvl(V_CALIF1, 0);
  V_CALIF2 := nvl(V_CALIF2, 0);
  V_CALIF3 := nvl(V_CALIF3, 0);
  V_CALIF4 := nvl(V_CALIF4, 0);  
  
  
  VAL_NORM := V_CALIF0;
  DSC_NORM := 'NORMAL';
  VAL_CPP  := V_CALIF1;
  DSC_CPP  := 'CPP';
  VAL_DEFC := V_CALIF2;
  DSC_DEFC := 'DEFICIENTE';
  VAL_DUDS := V_CALIF3;
  DSC_DUDS := 'DUDOSA';
  VAL_PERP := V_CALIF4;
  DSC_PERP := 'PERDIDA';    

end SP_CR_CALIFIC_RCC_IMPULSA;
/

