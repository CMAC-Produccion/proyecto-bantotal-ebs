create or replace package PQ_CR_ACTUALIZ_DATOS_SERVICE is

 -- ***************************************************************************************************************************
  -- Nombre                     : Proceso de actualizacion datos en MISTI
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 30/01/2024 11:18:01
  -- Autor de Creación          : IGS_RCASTRO
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- *************************************************************************************************************************** 
  

  PROCEDURE SP_DATOS_CLIENTE(P_PEPAIS         NUMBER,
                             P_PETDOC         NUMBER,
                             P_PENDOC         VARCHAR2,
                             P_APEPATER       OUT VARCHAR2,
                             P_APEMATER       OUT VARCHAR2,
                             P_PRIMNOMBRE     OUT VARCHAR2,
                             P_SEGNDNOMBR     OUT VARCHAR2,
                             P_RAZSOCIAL      OUT VARCHAR2,
                             P_OCUPACION      OUT VARCHAR2,
                             P_SEGMMERCADO    OUT VARCHAR2,
                             P_CARGO          OUT VARCHAR2,
                             P_RUCEMPLEADOR   OUT VARCHAR2,
                             P_NOMESTABLECIM  OUT VARCHAR2,
                             P_UBICESTABLECIM OUT VARCHAR2,
                             P_TIPOACTIVID    OUT VARCHAR2,
                             P_ACTIVIDAD      OUT VARCHAR2,
                             P_FECHAINGNEGOC  OUT DATE,
                             P_INGRESOMENSUAL OUT NUMBER,
                             P_CODOCUPACION   OUT NUMBER,
                             P_CODSEGMENTO    OUT NUMBER,
                             P_CODCARGO       OUT NUMBER,
                             P_CODUBICESTABL  OUT NUMBER,
                             P_CODTIPOACTIV   OUT NUMBER,
                             P_CODACTIVID     OUT NUMBER);

end PQ_CR_ACTUALIZ_DATOS_SERVICE;
/

CREATE OR REPLACE PACKAGE BODY PQ_CR_ACTUALIZ_DATOS_SERVICE IS

  PROCEDURE SP_DATOS_CLIENTE(P_PEPAIS         NUMBER,
                             P_PETDOC         NUMBER,
                             P_PENDOC         VARCHAR2,
                             P_APEPATER       OUT VARCHAR2,
                             P_APEMATER       OUT VARCHAR2,
                             P_PRIMNOMBRE     OUT VARCHAR2,
                             P_SEGNDNOMBR     OUT VARCHAR2,
                             P_RAZSOCIAL      OUT VARCHAR2,
                             P_OCUPACION      OUT VARCHAR2,
                             P_SEGMMERCADO    OUT VARCHAR2,
                             P_CARGO          OUT VARCHAR2,
                             P_RUCEMPLEADOR   OUT VARCHAR2,
                             P_NOMESTABLECIM  OUT VARCHAR2,
                             P_UBICESTABLECIM OUT VARCHAR2,
                             P_TIPOACTIVID    OUT VARCHAR2,
                             P_ACTIVIDAD      OUT VARCHAR2,
                             P_FECHAINGNEGOC  OUT DATE,
                             P_INGRESOMENSUAL OUT NUMBER,
                             P_CODOCUPACION   OUT NUMBER,
                             P_CODSEGMENTO    OUT NUMBER,
                             P_CODCARGO       OUT NUMBER,
                             P_CODUBICESTABL  OUT NUMBER,
                             P_CODTIPOACTIV   OUT NUMBER,
                             P_CODACTIVID     OUT NUMBER) IS
    V_DATO        NUMBER(1);
    V_TIPOPERSONA VARCHAR2(1);
    V_PEXING      NUMBER(18, 2);
  
    V_SNGC60TIPA NUMBER(15);
    V_SNGC60ACTE NUMBER(11);
    V_SNGC60OCUP NUMBER(5);
    V_SNGC60NOME VARCHAR2(50);
    V_SNGC60FINE DATE;
    V_SNGC60FINI DATE;
    V_SNGC60UBIC NUMBER(6);
    V_SNGC60VCOD NUMBER(2);
    V_SNGC60RUTE VARCHAR(12);
    V_EMPNOM     VARCHAR2(70);
    V_CODSEGME   NUMBER(2);
    V_PJSEGMENTO NUMBER(3);
  
  BEGIN
    BEGIN
      SELECT PETIPO
        INTO V_TIPOPERSONA
        FROM FSD001
       WHERE PEPAIS = P_PEPAIS
         AND PETDOC = P_PETDOC
         AND PENDOC = RPAD(P_PENDOC, 12, ' ');
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      --INGRESO MENSUAL
      SELECT PEXING
        INTO V_PEXING
        FROM FSE101
       WHERE PEPAIS = P_PEPAIS
         AND PETDOC = P_PETDOC
         AND PENDOC = RPAD(P_PENDOC, 12, ' ')
         AND PEXING <> 0;
    EXCEPTION
      WHEN OTHERS THEN
        V_PEXING := 0;
    END;
    V_PEXING         := NVL(V_PEXING, 0);
    P_INGRESOMENSUAL := V_PEXING;
  
    V_SNGC60TIPA := 0;
    V_SNGC60ACTE := 0;
    IF V_TIPOPERSONA = 'F' THEN
      BEGIN
        SELECT SNGC60TIPA,
               SNGC60ACTE,
               SNGC60OCUP,
               SNGC60NOME,
               SNGC60FINE,
               SNGC60FINI,
               SNGC60UBIC,
               SNGC60VCOD,
               SNGC60RUTE
          INTO V_SNGC60TIPA,
               V_SNGC60ACTE,
               V_SNGC60OCUP,
               V_SNGC60NOME,
               V_SNGC60FINE,
               V_SNGC60FINI,
               V_SNGC60UBIC,
               V_SNGC60VCOD,
               V_SNGC60RUTE
          FROM SNGC60
         WHERE SNGC60PAIS = P_PEPAIS
           AND SNGC60TDOC = P_PETDOC
           AND SNGC60NDOC = RPAD(P_PENDOC, 12, ' ')
           AND SNGC60CORR = 0;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      V_SNGC60TIPA := NVL(V_SNGC60TIPA, 0);
      V_SNGC60ACTE := NVL(V_SNGC60ACTE, 0);
      V_SNGC60VCOD := NVL(V_SNGC60VCOD, 0);
      V_SNGC60OCUP := NVL(V_SNGC60OCUP, 0);
      V_SNGC60UBIC := NVL(V_SNGC60UBIC, 0);
    
      IF V_SNGC60RUTE IS NOT NULL THEN
        BEGIN
          SELECT PJRAZS
            INTO V_EMPNOM
            FROM FSD003
           WHERE PJNDOC = RPAD(V_SNGC60RUTE, 12, ' ');
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      END IF;
    
      BEGIN
        --APELLIDOS Y NOMBRES
        SELECT PFAPE1, PFAPE2, PFNOM1, PFNOM2
          INTO P_APEPATER, P_APEMATER, P_PRIMNOMBRE, P_SEGNDNOMBR
          FROM FSD002
         WHERE PFPAIS = P_PEPAIS
           AND PFTDOC = P_PETDOC
           AND PFNDOC = RPAD(P_PENDOC, 12, ' ');
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    
      BEGIN
        --OCUPACION
        SELECT SNGC07DSC, SEGCOD
          INTO P_OCUPACION, V_CODSEGME
          FROM SNGC07
         WHERE SNGC07COD = V_SNGC60OCUP;
      EXCEPTION
        WHEN OTHERS THEN
          V_CODSEGME := 0;
      END;
      P_CODOCUPACION := V_SNGC60OCUP;
      V_CODSEGME := NVL(V_CODSEGME, 0);
      P_CODSEGMENTO := V_CODSEGME;
    
      P_SEGMMERCADO := '';
      CASE
        WHEN V_CODSEGME = 1 THEN
          P_SEGMMERCADO := 'INDEPENDIENTE';
        WHEN V_CODSEGME = 2 THEN
          P_SEGMMERCADO := 'DEPENDIENTE';
        WHEN V_CODSEGME = 3 THEN
          P_SEGMMERCADO := 'OTROS';
        ELSE 
          P_SEGMMERCADO := '';
      END CASE;
    
      --CARGO
      IF V_SNGC60OCUP = 1 THEN
      BEGIN
        SELECT VINOM
          INTO P_CARGO
          FROM FST020
         WHERE VICOD = V_SNGC60VCOD
           AND VIINTE = 'S';
      EXCEPTION
        WHEN OTHERS THEN
          P_CARGO := ' ';
      END;
      P_CODCARGO := V_SNGC60VCOD;
      END IF;
      P_CODCARGO := NVL(P_CODCARGO, 0);
    
      --RUC EMPLEADOR
      P_RUCEMPLEADOR := V_SNGC60RUTE;
    
      --NOMB ESTABLECIMIENTO
      IF (V_SNGC60OCUP = 4) OR (V_SNGC60OCUP = 5) OR (V_SNGC60OCUP = 6) THEN
        P_NOMESTABLECIM := V_SNGC60NOME;
        P_FECHAINGNEGOC := V_SNGC60FINI;
      END IF;
    
      IF (V_SNGC60OCUP = 1) OR (V_SNGC60OCUP = 2) THEN
        P_NOMESTABLECIM := V_EMPNOM;
        P_FECHAINGNEGOC := V_SNGC60FINE;
      END IF;
    
      --UBICACI ESTABLECIM
      IF V_SNGC60UBIC > 10 THEN
        V_SNGC60UBIC := 1;
      END IF;
    
      BEGIN
        SELECT SNGC08DSC
          INTO P_UBICESTABLECIM
          FROM SNGC08
         WHERE SNGC08COD = V_SNGC60UBIC;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      P_CODUBICESTABL := V_SNGC60UBIC;
    
    ELSE
      --PERSONAR JURIDICA
    
      BEGIN
        --RAZON SOCIAL
        SELECT SNGC11TPA2
          INTO V_SNGC60TIPA
          FROM SNGC11
         WHERE SNGC11PAIS = P_PEPAIS
           AND SNGC11TDOC = P_PETDOC
           AND SNGC11NDOC = RPAD(P_PENDOC, 12, ' ');
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      V_SNGC60TIPA := NVL(V_SNGC60TIPA, 0);
    
      BEGIN
        --COD ACTIVIDAD
        SELECT EXPNINS
          INTO V_SNGC60ACTE
          FROM FSE001
         WHERE D511PAIS = P_PEPAIS
           AND D511TDOC = P_PETDOC
           AND D511NDOC = RPAD(P_PENDOC, 12, ' ');
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      V_SNGC60ACTE := NVL(V_SNGC60ACTE, 0);
    
      BEGIN
        --RAZON SOCIAL
        SELECT PJRAZS, PJSEGMENTO
          INTO P_RAZSOCIAL, V_PJSEGMENTO
          FROM FSD003
         WHERE PJPAIS = P_PEPAIS
           AND PJTDOC = P_PETDOC
           AND PJNDOC = RPAD(P_PENDOC, 12, ' ');
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      V_PJSEGMENTO  := NVL(V_PJSEGMENTO, 0);
      P_OCUPACION   := ''; -- NO TIENE PARA RUC
      P_SEGMMERCADO := '';
      CASE
        WHEN V_PJSEGMENTO = 1 THEN
          P_SEGMMERCADO := 'INDEPENDIENTE';
        WHEN V_PJSEGMENTO = 2 THEN
          P_SEGMMERCADO := 'DEPENDIENTE';
      ELSE 
          P_SEGMMERCADO := '';
      END CASE;
    
    END IF;
  
    --DESCRIP TIPO ACTIVIDAD
    BEGIN
      SELECT ACTNOM3
        INTO P_TIPOACTIVID
        FROM FST752
       WHERE ACTCOD3 = V_SNGC60TIPA;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    P_CODTIPOACTIV := V_SNGC60TIPA;
    
    --DESCRIP ACTIVIDAD
    BEGIN
      SELECT ACTNOM1
        INTO P_ACTIVIDAD
        FROM FST750
       WHERE ACTCOD1 = V_SNGC60ACTE;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    P_CODACTIVID := V_SNGC60ACTE;
  
  END;

END PQ_CR_ACTUALIZ_DATOS_SERVICE;
/

