create or replace package pq_cr_exoner_mora_impulsa is
  /* ************************************************************************************************************
     -- Nombre                     : PQ_CR_EXONER_MORA_IMPULSA
     -- Sistema                    : BANTOTAL
     -- Módulo                     : ACTIVAS
     -- Descripción                : Exoneración de mora para créditos de impulsa
     -- Versión                    : 1.0
     -- Fecha de Creación          : 5/02/2024 11:26:57
     -- Autor de Creación          : IGS_RCASTRO
     -- Estado                     : Activo
     -- Acceso                     : Público
     -- Fecha de Modificación      : 
     -- Autor de la Modificación   : 
     -- Descripción de Modificación:   
  * *************************************************************************************************************/
  PROCEDURE SP_VAL_EXONER_MORA_IMPULSA(P_INSTANCIA NUMBER,
                                       P_USUARIOEJ VARCHAR2,
                                       P_FLGRPTA   OUT VARCHAR2);
  PROCEDURE SP_OBTENER_CREDITO(P_INSTANCIA IN NUMBER,
                               V_PGCOD     OUT NUMBER,
                               V_SCMOD     OUT NUMBER,
                               V_SCSUC     OUT NUMBER,
                               V_SCMDA     OUT NUMBER,
                               V_SCPAP     OUT NUMBER,
                               V_SCCTA     OUT NUMBER,
                               V_SCOPER    OUT NUMBER,
                               V_SCSBOP    OUT NUMBER,
                               V_SCTOPE    OUT NUMBER);
  PROCEDURE SP_VALID_CRED_117_VIG(P_INSTANCIA NUMBER,
                                  p_PGCOD_117     number, 
                                  P_SCMOD_117     NUMBER,
                                  P_SCSUC_117     NUMBER,
                                  P_SCMDA_117     NUMBER,
                                  P_SCPAP_117     NUMBER,  
                                  P_SCCTA_117     NUMBER,
                                  P_SCOPER_117    NUMBER,
                                  P_SCSBOP_117    NUMBER,
                                  P_SCTOPE_117    NUMBER,    
  
                                  P_PGCOD     OUT NUMBER,
                                  P_SCMOD     OUT NUMBER,
                                  P_SCSUC     OUT NUMBER,
                                  P_SCMDA     OUT NUMBER,
                                  P_SCPAP     OUT NUMBER,
                                  P_SCCTA     OUT NUMBER,
                                  P_SCOPER    OUT NUMBER,
                                  P_SCSBOP    OUT NUMBER,
                                  P_SCTOPE    OUT NUMBER);

  PROCEDURE SP_VALI_EXIST_AQPB252(V_PGCOD  NUMBER,
                                  V_SCMOD  NUMBER,
                                  V_SCSUC  NUMBER,
                                  V_SCMDA  NUMBER,
                                  V_SCPAP  NUMBER,
                                  V_SCCTA  NUMBER,
                                  V_SCOPER NUMBER,
                                  V_SCSBOP NUMBER,
                                  V_SCTOPE NUMBER,
                                  FLGOK    OUT VARCHAR2);

end pq_cr_exoner_mora_impulsa;
/

CREATE OR REPLACE PACKAGE BODY PQ_CR_EXONER_MORA_IMPULSA IS

  PROCEDURE SP_VAL_EXONER_MORA_IMPULSA(P_INSTANCIA NUMBER,
                                       P_USUARIOEJ VARCHAR2,
                                       P_FLGRPTA   OUT VARCHAR2) IS
    -- *****************************************************************
    -- Nombre                     : SP_VAL_EXONER_MORA_IMPULSA
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2024.02.05
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Valida el exoneracion de mora de cred. impulsa
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************                                        
    V_PGCOD          NUMBER(3);
    V_SCMOD          NUMBER(4);
    V_SCSUC          NUMBER(4);
    V_SCMDA          NUMBER(4);
    V_SCPAP          NUMBER(4);
    V_SCCTA          NUMBER(9);
    V_SCOPER         NUMBER(9);
    V_SCSBOP         NUMBER(3);
    V_SCTOPE         NUMBER(3);
    V_FLGEXISTE      VARCHAR2(1);
    V_FECHAGUIA      DATE;
    V_AUXTP1DESC     VARCHAR2(30);
    V_FECHAACTUAL    DATE;
    V_CORRELATIVO835 NUMBER(10);
    FLGOK            VARCHAR2(1);
  
    X_PGCOD  NUMBER(3);
    X_SCMOD  NUMBER(4);
    X_SCSUC  NUMBER(4);
    X_SCMDA  NUMBER(4);
    X_SCPAP  NUMBER(4);
    X_SCCTA  NUMBER(9);
    X_SCOPER NUMBER(9);
    X_SCSBOP NUMBER(3);
    X_SCTOPE NUMBER(3);
    V_NRODIAS NUMBER(7,2);
  
    CURSOR LIST_CREDITOS(LN_INSTANCIA NUMBER) IS
      SELECT *
        FROM JAQY800
       WHERE JAQY800PGCD = 1
         AND JAQY800INS = LN_INSTANCIA;
  
  BEGIN
    P_FLGRPTA := 'N';     
    BEGIN
      PQ_CR_EXONER_MORA_IMPULSA.SP_OBTENER_CREDITO(P_INSTANCIA => P_INSTANCIA,
                                                   V_PGCOD     => V_PGCOD,
                                                   V_SCMOD     => V_SCMOD,
                                                   V_SCSUC     => V_SCSUC,
                                                   V_SCMDA     => V_SCMDA,
                                                   V_SCPAP     => V_SCPAP,
                                                   V_SCCTA     => V_SCCTA,
                                                   V_SCOPER    => V_SCOPER,
                                                   V_SCSBOP    => V_SCSBOP,
                                                   V_SCTOPE    => V_SCTOPE);
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    --VALIDAR SI CORRESPONDE AL MOD. Y TOPE 
    BEGIN
      SELECT 'S'
        INTO V_FLGEXISTE
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11152
         AND TP1CORR1 = 130
         AND TP1CORR2 = 1
         AND TP1CORR3 > 0
         AND TP1NRO2 = V_SCMOD
         AND TP1NRO3 = V_SCTOPE;
    EXCEPTION
      WHEN OTHERS THEN
        V_FLGEXISTE := 'N';
    END;
    V_FLGEXISTE := NVL(V_FLGEXISTE, 'N');
  
    IF V_FLGEXISTE = 'S' THEN
      --OBTENER FECHA DE GUIA
      BEGIN
        SELECT TRIM(TP1DESC)
          INTO V_AUXTP1DESC
          FROM FST198
         WHERE TP1COD = 1
           AND TP1COD1 = 11152
           AND TP1CORR1 = 130
           AND TP1CORR2 = 2
           AND TP1CORR3 = 1;
      EXCEPTION
        WHEN OTHERS THEN
          V_AUXTP1DESC := '';
      END;
      
      --OBTENER nro dias a sumar
      BEGIN
        SELECT TP1NRO3
          INTO V_NRODIAS
          FROM FST198
         WHERE TP1COD = 1
           AND TP1COD1 = 11152
           AND TP1CORR1 = 130
           AND TP1CORR2 = 2
           AND TP1CORR3 = 2;
      EXCEPTION
        WHEN OTHERS THEN
          V_NRODIAS := 0;
      END;      
      V_NRODIAS := NVL(V_NRODIAS, 0);
      
    
      BEGIN
        V_FECHAGUIA := TO_DATE(V_AUXTP1DESC, 'dd/MM/rrrr');
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    
      BEGIN
        SELECT PGFAPE INTO V_FECHAACTUAL FROM FST017 WHERE PGCOD = 1;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    
      FOR NFILA IN LIST_CREDITOS(P_INSTANCIA) LOOP
      
        V_PGCOD  := NFILA.JAQY800PGCD;
        V_SCMOD  := NFILA.JAQY800MOD;
        V_SCSUC  := NFILA.JAQY800SUC;
        V_SCMDA  := NFILA.JAQY800MDA;
        V_SCPAP  := NFILA.JAQY800PAP;
        V_SCCTA  := NFILA.JAQY800CTA;
        V_SCOPER := NFILA.JAQY800OPE;
        V_SCSBOP := NFILA.JAQY800SBOP;
        V_SCTOPE := NFILA.JAQY800TOPE;
      
        --VALIDAMOS SI ES 117 
        IF NFILA.JAQY800MOD = 117 THEN
          PQ_CR_EXONER_MORA_IMPULSA.SP_VALID_CRED_117_VIG(P_INSTANCIA,
                                                          V_PGCOD ,           
                                                          V_SCMOD ,
                                                          V_SCSUC ,
                                                          V_SCMDA ,
                                                          V_SCPAP ,
                                                          V_SCCTA ,
                                                          V_SCOPER,
                                                          V_SCSBOP,
                                                          V_SCTOPE,  
                                                                                     
                                                          X_PGCOD,
                                                          X_SCMOD,
                                                          X_SCSUC,
                                                          X_SCMDA,
                                                          X_SCPAP,
                                                          X_SCCTA,
                                                          X_SCOPER,
                                                          X_SCSBOP,
                                                          X_SCTOPE);
        
          V_PGCOD  := X_PGCOD;
          V_SCMOD  := X_SCMOD;
          V_SCSUC  := X_SCSUC;
          V_SCMDA  := X_SCMDA;
          V_SCPAP  := X_SCPAP;
          V_SCCTA  := X_SCCTA;
          V_SCOPER := X_SCOPER;
          V_SCSBOP := X_SCSBOP;
          V_SCTOPE := X_SCTOPE;
        END IF;
      
        IF V_SCCTA <> 0 AND V_SCOPER <> 0 THEN
          --ANTES DE INSERTAR VALIDAR SI EXISTE                    
          BEGIN
            PQ_CR_EXONER_MORA_IMPULSA.SP_VALI_EXIST_AQPB252(V_PGCOD,
                                                            V_SCMOD,
                                                            V_SCSUC,
                                                            V_SCMDA,
                                                            V_SCPAP,
                                                            V_SCCTA,
                                                            V_SCOPER,
                                                            V_SCSBOP,
                                                            V_SCTOPE,
                                                            FLGOK);
          
          END;
        
          --INSERTAR CRED. 
          P_FLGRPTA := 'N';
          BEGIN
            INSERT INTO AQPB252
              (AQPB252EMP,
               AQPB252MOD,
               AQPB252SUC,
               AQPB252MDA,
               AQPB252PAP,
               AQPB252CTA,
               AQPB252OPER,
               AQPB252SBOP,
               AQPB252TOP,
               AQPB252FINI,
               AQPB252FFIN,
               AQPB252EST,
               AQPB252IND)
            VALUES
              (V_PGCOD,
               V_SCMOD,
               V_SCSUC,
               V_SCMDA,
               V_SCPAP,
               V_SCCTA,
               V_SCOPER,
               V_SCSBOP,
               V_SCTOPE,
               V_FECHAGUIA,
               V_FECHAACTUAL + V_NRODIAS,
               'S',
               '3');
            COMMIT;
          
            P_FLGRPTA := 'S';
          
          EXCEPTION
            WHEN OTHERS THEN
              P_FLGRPTA := 'N';
          END;
        
          IF P_FLGRPTA = 'S' THEN
            BEGIN
              SELECT MAX(AQPC835COR)
                INTO V_CORRELATIVO835
                FROM AQPC835
               WHERE AQPC835FEPRO = V_FECHAACTUAL;
            EXCEPTION
              WHEN OTHERS THEN
                NULL;
            END;
            V_CORRELATIVO835 := nvl(V_CORRELATIVO835, 0);            
          
            BEGIN
              INSERT INTO AQPC835
                (AQPC835FEPRO,
                 AQPC835COR,
                 AQPC835COD,
                 AQPC835MOD,
                 AQPC835SUC,
                 AQPC835MDA,
                 AQPC835PAP,
                 AQPC835CTA,
                 AQPC835OPER,
                 AQPC835SBOP,
                 AQPC835TOPE,
                 AQPC835USUREJ,
                 AQPC835FECR,
                 AQPC835HORA,
                 AQPC835INST,
                 AQPC835FINI,
                 AQPC835FFIN)
              VALUES
                (V_FECHAACTUAL,
                 V_CORRELATIVO835 + 1,
                 V_PGCOD,
                 V_SCMOD,
                 V_SCSUC,
                 V_SCMDA,
                 V_SCPAP,
                 V_SCCTA,
                 V_SCOPER,
                 V_SCSBOP,
                 V_SCTOPE,
                 P_USUARIOEJ,
                 V_FECHAACTUAL,
                 TO_CHAR(SYSDATE, 'HH24:MI:SS'),
                 P_INSTANCIA,
                 V_FECHAGUIA,
                 V_FECHAACTUAL + V_NRODIAS);
              COMMIT;
            EXCEPTION
              WHEN OTHERS THEN
                NULL;
            END;
          END IF;
        END IF;
      
      END LOOP;
    ELSE
      P_FLGRPTA := 'N';
    END IF;
  END;

  PROCEDURE SP_OBTENER_CREDITO(P_INSTANCIA IN NUMBER,
                               V_PGCOD     OUT NUMBER,
                               V_SCMOD     OUT NUMBER,
                               V_SCSUC     OUT NUMBER,
                               V_SCMDA     OUT NUMBER,
                               V_SCPAP     OUT NUMBER,
                               V_SCCTA     OUT NUMBER,
                               V_SCOPER    OUT NUMBER,
                               V_SCSBOP    OUT NUMBER,
                               V_SCTOPE    OUT NUMBER) IS
    -- *****************************************************************
    -- Nombre                     : SP_OBTENER_CREDITO
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2024.2.05
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Devuelve credito por instancia
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************                                
  BEGIN
    BEGIN
      SELECT W.XWFEMPRESA,
             W.XWFSUCURSAL,
             W.XWFMODULO,
             W.XWFMONEDA,
             W.XWFPAPEL,
             W.XWFCUENTA,
             W.XWFOPERACION,
             W.XWFSUBOPE,
             W.XWFTIPOPE
        INTO V_PGCOD,
             V_SCSUC,
             V_SCMOD,
             V_SCMDA,
             V_SCPAP,
             V_SCCTA,
             V_SCOPER,
             V_SCSBOP,
             V_SCTOPE
        FROM XWF700 W
       WHERE W.XWFPRCINS = P_INSTANCIA
         AND W.XWFCAR3 = '1';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  END;

  PROCEDURE SP_VALID_CRED_117_VIG(P_INSTANCIA     NUMBER,
                                  p_PGCOD_117     number, 
                                  P_SCMOD_117     NUMBER,
                                  P_SCSUC_117     NUMBER,
                                  P_SCMDA_117     NUMBER,
                                  P_SCPAP_117     NUMBER,  
                                  P_SCCTA_117     NUMBER,
                                  P_SCOPER_117    NUMBER,
                                  P_SCSBOP_117    NUMBER,
                                  P_SCTOPE_117    NUMBER,
  
                                  P_PGCOD     OUT NUMBER,
                                  P_SCMOD     OUT NUMBER,
                                  P_SCSUC     OUT NUMBER,
                                  P_SCMDA     OUT NUMBER,
                                  P_SCPAP     OUT NUMBER,
                                  P_SCCTA     OUT NUMBER,
                                  P_SCOPER    OUT NUMBER,
                                  P_SCSBOP    OUT NUMBER,
                                  P_SCTOPE    OUT NUMBER) IS 
    -- *****************************************************************
    -- Nombre                     : SP_VALID_CRED_117_VIG
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2024.2.05
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Validar credito con mod. 117
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************                                    
  BEGIN
 
    BEGIN
      SELECT A.R1COD,
             A.R1MOD,
             A.R1CTA,
             A.R1OPER,
             A.R1MDA,
             A.R1PAP,
             A.R1SUC,
             A.R1SBOP,
             A.R1TOPE
        INTO P_PGCOD,
             P_SCMOD,
             P_SCCTA,
             P_SCOPER,
             P_SCMDA, 
             P_SCPAP,                                       
             P_SCSUC,                    
             P_SCSBOP,
             P_SCTOPE
        FROM FSR011 A, FSD010 F10
       WHERE A.R2COD  = p_PGCOD_117 
         AND A.R2MOD  = P_SCMOD_117 
         AND A.R2SUC  = P_SCSUC_117 
         AND A.R2MDA  = P_SCMDA_117 
         AND A.R2PAP  = P_SCPAP_117 
         AND A.R2CTA  = P_SCCTA_117 
         AND A.R2OPER = P_SCOPER_117
         AND A.R2SBOP = P_SCSBOP_117
         AND A.R2TOPE = P_SCTOPE_117
         AND F10.PGCOD = A.R1COD
         AND F10.AOMOD = A.R1MOD
         AND F10.AOSUC = A.R1SUC
         AND F10.AOMDA = A.R1MDA
         AND F10.AOPAP = A.R1PAP
         AND F10.AOCTA = A.R1CTA
         AND F10.AOOPER = A.R1OPER
         AND F10.AOSBOP = A.R1SBOP
         AND F10.AOTOPE = A.R1TOPE
         AND A.RELCOD = 46
         AND F10.AOSTAT = 0
         AND ROWNUM = 1;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  END;

  PROCEDURE SP_VALI_EXIST_AQPB252(V_PGCOD  NUMBER,
                                  V_SCMOD  NUMBER,
                                  V_SCSUC  NUMBER,
                                  V_SCMDA  NUMBER,
                                  V_SCPAP  NUMBER,
                                  V_SCCTA  NUMBER,
                                  V_SCOPER NUMBER,
                                  V_SCSBOP NUMBER,
                                  V_SCTOPE NUMBER,
                                  FLGOK    OUT VARCHAR2) IS
    -- *****************************************************************
    -- Nombre                     : SP_VALI_EXIST_AQPB252
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2024.2.05
    -- Autor de Creación          : Romario Castro - IGS
    -- Uso                        : Valida existencia de cred. en aqpb252
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : --
    -- Parámetros de Salida       : --
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************                                   
    FLGEXISTEE VARCHAR(1);
  BEGIN
    BEGIN
      SELECT 'S'
        INTO FLGEXISTEE
        FROM AQPB252
       WHERE AQPB252EMP = V_PGCOD
         AND AQPB252MOD = V_SCMOD
         AND AQPB252SUC = V_SCSUC
         AND AQPB252MDA = V_SCMDA
         AND AQPB252PAP = V_SCPAP
         AND AQPB252CTA = V_SCCTA
         AND AQPB252OPER = V_SCOPER
         AND AQPB252SBOP = V_SCSBOP
         AND AQPB252TOP = V_SCTOPE;
    EXCEPTION
      WHEN OTHERS THEN
        FLGEXISTEE := 'N';
    END;
    FLGEXISTEE := NVL(FLGEXISTEE, 'N');
  
    --SI EXISTE ACTUALIZAR AQPB252EMP  + 1
    IF FLGEXISTEE = 'S' THEN
      BEGIN
        UPDATE AQPB252
           SET AQPB252EMP = AQPB252EMP + 1
         WHERE --AQPB252EMP = V_PGCOD AND
           AQPB252MOD = V_SCMOD
           AND AQPB252SUC = V_SCSUC
           AND AQPB252MDA = V_SCMDA
           AND AQPB252PAP = V_SCPAP
           AND AQPB252CTA = V_SCCTA
           AND AQPB252OPER = V_SCOPER
           AND AQPB252SBOP = V_SCSBOP
           AND AQPB252TOP = V_SCTOPE;
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
  
  END;

END PQ_CR_EXONER_MORA_IMPULSA;
/

