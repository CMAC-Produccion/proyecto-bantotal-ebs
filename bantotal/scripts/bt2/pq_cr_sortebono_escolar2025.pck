CREATE OR REPLACE PACKAGE PQ_CR_SORTEBONO_ESCOLAR2025 IS

  -- *****************************************************************
  -- Nombre                     : PQ_CR_SORTEBONO_ESCOLAR2025
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 3/02/2025 15:52:01
  -- Autor de Creación          : IGS_RCASTRO
  -- Uso                        : 
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      : 
  --
  -- Retorno                    : 
  -- Fecha de Modificación      : 25/02/2025
  -- Autor de la Modificación   : IGS_RCASTRO
  -- Descripción de Modificación: Se modifico el proceso de registro de desembolso
  -- Fecha de Modificación      : 03/03/2025
  -- Autor de la Modificación   : MPOSTIGOC
  -- Descripción de Modificación: Se modifico el mensaje que se mostrará en el voucher de desembolso.
  -- *****************************************************************    

  PROCEDURE SP_CONTROLES_DESEM_APLICA_SORTEO(PPGCOD    NUMBER,
                                             PITSUC    NUMBER,
                                             PITMOD    NUMBER,
                                             PITTRAN   NUMBER,
                                             PITNREL   NUMBER,
                                             PITORD    NUMBER,
                                             FECHATRX  DATE,
                                             ITHORA    VARCHAR2,
                                             USUINGTRX VARCHAR2,
                                             APLICABON OUT VARCHAR2,
                                             P_mensaje OUT VARCHAR2);

  PROCEDURE SP_REGIST_DESEMBOL_VALID(PPGCOD          NUMBER,
                                     PITSUC          NUMBER,
                                     PITMOD          NUMBER,
                                     PITTRAN         NUMBER,
                                     PITNREL         NUMBER,
                                     PITORD          NUMBER,
                                     FECHATRX        DATE,
                                     ITHORA          VARCHAR2,
                                     USUINGTRX       VARCHAR2,
                                     P_CODREG        NUMBER,
                                     P_NOMREG        VARCHAR2,
                                     P_AQPC844APLICA VARCHAR2,
                                     P_CORRELATIVO   OUT NUMBER);

  PROCEDURE SP_VAL_BONOXREG_DISPON(P_PITSUC    NUMBER,
                                   P_CODREG    OUT NUMBER,
                                   P_NOMREG    OUT VARCHAR2,
                                   P_FLGDISPON OUT VARCHAR2);

  PROCEDURE SP_VAL_GANADORES_AQPC844(PPGCOD    NUMBER,
                                     PITSUC    NUMBER,
                                     PITMOD    NUMBER,
                                     PITTRAN   NUMBER,
                                     PITNREL   NUMBER,
                                     FECHATRX  DATE,
                                     FLGCUMPLE out VARCHAR2,
                                     MGSRPTA   out VARCHAR2);

  PROCEDURE SP_ACTUALIZAR_RPTA(PPGCOD    NUMBER,
                               PITSUC    NUMBER,
                               PITMOD    NUMBER,
                               PITTRAN   NUMBER,
                               PITNREL   NUMBER,
                               FECHATRX  DATE,
                               FLGCUMPLE VARCHAR2,
                               MGSRPTA   VARCHAR2);

END PQ_CR_SORTEBONO_ESCOLAR2025;
/

CREATE OR REPLACE PACKAGE BODY PQ_CR_SORTEBONO_ESCOLAR2025 IS

  PROCEDURE SP_CONTROLES_DESEM_APLICA_SORTEO(PPGCOD    NUMBER,
                                             PITSUC    NUMBER,
                                             PITMOD    NUMBER,
                                             PITTRAN   NUMBER,
                                             PITNREL   NUMBER,
                                             PITORD    NUMBER,
                                             FECHATRX  DATE,
                                             ITHORA    VARCHAR2,
                                             USUINGTRX VARCHAR2,
                                             APLICABON OUT VARCHAR2,
                                             P_mensaje OUT VARCHAR2) IS
    VAR_APLICA      VARCHAR2(1);
    P_CORRELATIVO   NUMBER(10);
    ES_BONO         VARCHAR2(1) := 'N';
    V_CODREG        NUMBER(4);
    V_NOMREG        VARCHAR2(50);
    V_FLGDISPONIBLE VARCHAR2(1);
    V_HORASIST      VARCHAR2(10);
    V_CANTBONXDIA   NUMBER(9);
    V_CUMPLE        VARCHAR2(1);
    V_FEC6GANAD     VARCHAR2(30);
    V_FEC6          DATE;
  BEGIN
    --VALIDAR QUE EL CLIENTE APLICA 
    BEGIN
      -- Call the procedure
      PQ_CR_SORTEO_PYME2020.sp_Cr_ValidEnLinea(ln_pgcodt  => PPGCOD,
                                               ln_suct    => PITSUC,
                                               ln_modt    => PITMOD,
                                               ln_ttran   => PITTRAN,
                                               ln_relt    => PITNREL,
                                               ln_ordt    => PITORD,
                                               lv_PCancel => VAR_APLICA);
    
    EXCEPTION
      WHEN OTHERS THEN
        VAR_APLICA := 'N';
    END;
  
    VAR_APLICA := NVL(VAR_APLICA, 'N');
  
    IF VAR_APLICA = 'S' THEN
      --S aplica todas las condiciones          
      BEGIN
        PQ_CR_SORTEBONO_ESCOLAR2025.SP_VAL_BONOXREG_DISPON(P_PITSUC    => PITSUC,
                                                           P_CODREG    => V_CODREG,
                                                           P_NOMREG    => V_NOMREG,
                                                           P_FLGDISPON => V_FLGDISPONIBLE);
      END;
    
      IF V_FLGDISPONIBLE = 'S' THEN
        --Si hay bonos disponible para la region de la trx
        PQ_CR_SORTEBONO_ESCOLAR2025.SP_REGIST_DESEMBOL_VALID(PPGCOD,
                                                             PITSUC,
                                                             PITMOD,
                                                             PITTRAN,
                                                             PITNREL,
                                                             PITORD,
                                                             FECHATRX,
                                                             ITHORA,
                                                             USUINGTRX,
                                                             V_CODREG,
                                                             V_NOMREG,
                                                             VAR_APLICA,
                                                             P_CORRELATIVO);
      
        --VALIDAR CORRELATIVO SI ES GANADOR
        V_HORASIST := to_char(SYSDATE, 'HH24:MI:SS');
        --IF V_HORASIST <= '12:59:59' THEN
        BEGIN
          select 'S'
            into ES_BONO
            from aqpd758
           WHERE AQPD758FECHAG = FECHATRX
             AND (P_CORRELATIVO IN (AQPD758nro1,
                                    AQPD758nro3,
                                    AQPD758nro4,
                                    AQPD758nro2,
                                    AQPD758nro5,
                                    AQPD758nro6));
        EXCEPTION
          WHEN OTHERS THEN
            ES_BONO := 'N';
        END;
        /*ELSE 
        IF V_HORASIST > '12:59:59' THEN 
          BEGIN
            select 'S'
              into ES_BONO
              from aqpd758
             WHERE AQPD758FECHAG = FECHATRX
               AND (P_CORRELATIVO IN
                   (AQPD758nro2, AQPD758nro5, AQPD758nro6));
          EXCEPTION
            WHEN OTHERS THEN
              ES_BONO := 'N';
          END;
        END IF;*/
      
        --END IF;
        ES_BONO := NVL(ES_BONO, 'N');
      
        --ACTUALIZAR CAMPO BONO
        IF ES_BONO = 'S' THEN
          V_CUMPLE := 'S';
        ELSE
          IF ES_BONO = 'N' THEN
            --validamos hora para elegir al primer trx despues de las 12:59 o 18:30          
            IF (V_HORASIST >= '12:59:59') OR (V_HORASIST >= '18:30:00') THEN
              BEGIN
                SELECT COUNT(1)
                  INTO V_CANTBONXDIA
                  FROM AQPC844
                 WHERE AQPC844FECARGA = FECHATRX
                   AND AQPC844ESBONO = 'S';
              EXCEPTION
                WHEN OTHERS THEN
                  NULL;
              END;
              V_CANTBONXDIA := NVL(V_CANTBONXDIA, 0);
            
              BEGIN
                select TP1DESC
                  INTO V_FEC6GANAD
                  from fst198 f
                 where f.TP1COD = 1
                   AND f.tp1cod1 = 11181
                   and f.tp1corr1 = 3
                   and tp1corr2 = 1;
              EXCEPTION
                WHEN OTHERS THEN
                  NULL;
              END;
            
              V_FEC6GANAD := TRIM(V_FEC6GANAD);
              BEGIN
                SELECT TO_DATE(V_FEC6GANAD, 'DD/MM/YYYY')
                  INTO V_FEC6
                  FROM dual;
              EXCEPTION
                WHEN OTHERS THEN
                  NULL;
              END;
            
              IF FECHATRX = V_FEC6 AND V_CANTBONXDIA <= 6 THEN
                IF V_CANTBONXDIA < 3 AND (V_HORASIST >= '12:59:59') THEN
                  V_CUMPLE := 'S';
                  CASE
                    WHEN V_CANTBONXDIA = 0 THEN
                      BEGIN
                        UPDATE AQPD758
                           SET AQPD758NRO1 = P_CORRELATIVO
                         WHERE AQPD758FECHAG = FECHATRX;
                        COMMIT;
                      EXCEPTION
                        WHEN OTHERS THEN
                          null;
                      END;
                    WHEN V_CANTBONXDIA = 1 THEN
                      BEGIN
                        UPDATE AQPD758
                           SET AQPD758NRO3 = P_CORRELATIVO
                         WHERE AQPD758FECHAG = FECHATRX;
                        COMMIT;
                      EXCEPTION
                        WHEN OTHERS THEN
                          null;
                      END;
                    WHEN V_CANTBONXDIA = 2 THEN
                      BEGIN
                        UPDATE AQPD758
                           SET AQPD758NRO4 = P_CORRELATIVO
                         WHERE AQPD758FECHAG = FECHATRX;
                        COMMIT;
                      EXCEPTION
                        WHEN OTHERS THEN
                          null;
                      END;
                  END CASE;
                ELSE
                  IF V_CANTBONXDIA < 6 AND (V_HORASIST >= '18:30:00') THEN
                    V_CUMPLE := 'S';
                    CASE
                      WHEN V_CANTBONXDIA = 3 THEN
                        BEGIN
                          UPDATE AQPD758
                             SET AQPD758NRO2 = P_CORRELATIVO
                           WHERE AQPD758FECHAG = FECHATRX;
                          COMMIT;
                        EXCEPTION
                          WHEN OTHERS THEN
                            null;
                        END;
                      WHEN V_CANTBONXDIA = 4 THEN
                        BEGIN
                          UPDATE AQPD758
                             SET AQPD758NRO5 = P_CORRELATIVO
                           WHERE AQPD758FECHAG = FECHATRX;
                          COMMIT;
                        EXCEPTION
                          WHEN OTHERS THEN
                            null;
                        END;
                      WHEN V_CANTBONXDIA = 5 THEN
                        BEGIN
                          UPDATE AQPD758
                             SET AQPD758NRO6 = P_CORRELATIVO
                           WHERE AQPD758FECHAG = FECHATRX;
                          COMMIT;
                        EXCEPTION
                          WHEN OTHERS THEN
                            null;
                        END;
                    END CASE;
                  
                  END IF;
                END IF;
              ELSE
                IF V_CANTBONXDIA = 0 AND (V_HORASIST >= '12:59:59') THEN
                  V_CUMPLE := 'S';
                
                  --actualizar cupon gandor
                  BEGIN
                    UPDATE AQPD758
                       SET AQPD758NRO1 = P_CORRELATIVO
                     WHERE AQPD758FECHAG = FECHATRX;
                    COMMIT;
                  EXCEPTION
                    WHEN OTHERS THEN
                      null;
                  END;
                ELSE
                  IF V_CANTBONXDIA = 1 AND (V_HORASIST >= '18:30:00') THEN
                    V_CUMPLE := 'S';
                  
                    BEGIN
                      UPDATE AQPD758
                         SET AQPD758NRO2 = P_CORRELATIVO
                       WHERE AQPD758FECHAG = FECHATRX;
                      COMMIT;
                    EXCEPTION
                      WHEN OTHERS THEN
                        null;
                    END;
                  END IF;
                END IF;
              END IF;
            END IF;
          END IF;
        END if;
      
        IF V_CUMPLE = 'S' THEN
          BEGIN
            UPDATE AQPC844
               SET AQPC844ESBONO = V_CUMPLE
             WHERE AQPC844FECARGA = FECHATRX
               AND AQPC844ITPGCOD = PPGCOD
               AND AQPC844ITSUC = PITSUC
               AND AQPC844ITMOD = PITMOD
               AND AQPC844ITTRAN = PITTRAN
               AND AQPC844ITNREL = PITNREL
               AND AQPC844ITFCON = FECHATRX;
            COMMIT;
          EXCEPTION
            WHEN OTHERS THEN
              null;
          END;
        
          --ACTUALIZAR COUNT GANADORES POR REGION
          BEGIN
            UPDATE fst198 F
               SET F.TP1NRO2 = F.TP1NRO2 + 1
             WHERE f.TP1COD = 1
               AND f.tp1cod1 = 11181
               AND f.TP1CORR1 = 1
               AND f.TP1CORR2 = 1
               AND F.TP1CORR3 = V_CODREG;
            COMMIT;
          EXCEPTION
            WHEN OTHERS THEN
              null;
          End;
        
          P_mensaje := 'Ganaste tu BONO de ESCOLARIDAD de S/500'; --'Felicitaciones, ganaste el bono de escolaridad 2025 por 500 soles. Consulta en ventanilla.';
          APLICABON := 'S';
        ELSE
          P_mensaje := '';
          APLICABON := 'N';
        END IF;
      
      END IF;
    END IF;
  END;

  ---------------------------------------------------------------------------------------------------------------------------

  PROCEDURE SP_REGIST_DESEMBOL_VALID(PPGCOD          NUMBER,
                                     PITSUC          NUMBER,
                                     PITMOD          NUMBER,
                                     PITTRAN         NUMBER,
                                     PITNREL         NUMBER,
                                     PITORD          NUMBER,
                                     FECHATRX        DATE,
                                     ITHORA          VARCHAR2,
                                     USUINGTRX       VARCHAR2,
                                     P_CODREG        NUMBER,
                                     P_NOMREG        VARCHAR2,
                                     P_AQPC844APLICA VARCHAR2,
                                     P_CORRELATIVO   OUT NUMBER) IS
    V_EMP      NUMBER(3);
    V_MODU     NUMBER(4);
    V_SUC      NUMBER(4);
    V_MDA      NUMBER(4);
    V_PAP      NUMBER(4);
    V_CTA      NUMBER(9);
    V_OPER     NUMBER(9);
    V_SBOP     NUMBER(4);
    V_TOPE     NUMBER(4);
    NOMAGENCIA VARCHAR2(30);
    FECHSIST   DATE;
    -- P_CORRELATIVO NUMBER(10);   
    V_Existe VARCHAR2(1);
  
  BEGIN
  
    BEGIN
      SELECT PGFAPE INTO FECHSIST FROM FST017 WHERE PGCOD = PPGCOD;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    BEGIN
      SELECT PGCOD,
             ITSUCD,
             MODULO,
             MONEDA,
             PAPEL,
             CTNRO,
             ITOPER,
             ITSUBO,
             ITTOPE
        INTO V_EMP,
             V_SUC,
             V_MODU,
             V_MDA,
             V_PAP,
             V_CTA,
             V_OPER,
             V_SBOP,
             V_TOPE
        FROM FSD016
       WHERE PGCOD = PPGCOD
         AND ITSUC = PITSUC
         AND ITMOD = PITMOD
         AND ITTRAN = PITTRAN
         AND ITNREL = PITNREL
         AND ITORD = PITORD;
    EXCEPTION
      WHEN OTHERS THEN
        V_EMP  := 0;
        V_MODU := 0;
        V_SUC  := 0;
        V_MDA  := 0;
        V_PAP  := 0;
        V_CTA  := 0;
        V_OPER := 0;
        V_SBOP := 0;
        V_TOPE := 0;
    END;
  
    V_CTA  := NVL(V_CTA, 0);
    V_OPER := NVL(V_OPER, 0);
  
    IF V_CTA > 0 AND V_OPER > 0 THEN
    
      --NOMBRE AGENCIA
      BEGIN
        SELECT SCNOM
          INTO NOMAGENCIA
          FROM FST001
         WHERE PGCOD = V_EMP
           AND SUCURS = V_SUC;
      EXCEPTION
        WHEN OTHERS THEN
          NOMAGENCIA := '';
      END;
    
      --CORRELATIVO 
      V_Existe := 'S';
    
      WHILE (V_Existe = 'S') LOOP
        P_CORRELATIVO := 0;
        BEGIN
          SELECT MAX(F.AQPC844CORR)
            INTO P_CORRELATIVO
            FROM AQPC844 F
           WHERE AQPC844FECARGA = FECHSIST;
        EXCEPTION
          WHEN OTHERS THEN
            P_CORRELATIVO := 0;
        END;
        P_CORRELATIVO := NVL(P_CORRELATIVO, 0);
      
        P_CORRELATIVO := P_CORRELATIVO + 1;
      
        -- Validar si existe
        V_Existe := 'N';
        BEGIN
          SELECT 'S'
            INTO V_Existe
            FROM AQPC844 F
           WHERE F.AQPC844CORR = P_CORRELATIVO
             AND AQPC844FECARGA = FECHSIST;
        EXCEPTION
          WHEN OTHERS THEN
            V_Existe := 'N';
        END;
      
      END LOOP; --    
    
      --INSERCION
      BEGIN
        INSERT INTO AQPC844
          (AQPC844CORR,
           AQPC844FECARGA,
           AQPC844HORSIS,
           AQPC844ITPGCOD,
           AQPC844ITSUC,
           AQPC844ITMOD,
           AQPC844ITTRAN,
           AQPC844ITNREL,
           AQPC844ITFCON,
           AQPC844HORAT,
           AQPC844AGENCIT,
           AQPC844OPERADT,
           AQPC844EMP,
           AQPC844MODU,
           AQPC844SUC,
           AQPC844MDA,
           AQPC844PAP,
           AQPC844CTA,
           AQPC844OPER,
           AQPC844SBOP,
           AQPC844TOPE,
           AQPC844APLICA,
           AQPC844ESBONO,
           AQPC844CODREG,
           AQPC844REGION)
        VALUES
          (P_CORRELATIVO,
           FECHSIST,
           ITHORA,
           PPGCOD,
           PITSUC,
           PITMOD,
           PITTRAN,
           PITNREL,
           FECHATRX,
           ITHORA,
           NOMAGENCIA,
           USUINGTRX,
           V_EMP,
           V_MODU,
           V_SUC,
           V_MDA,
           V_PAP,
           V_CTA,
           V_OPER,
           V_SBOP,
           V_TOPE,
           P_AQPC844APLICA,
           'N',
           P_CODREG,
           P_NOMREG);
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          INSERT INTO AQPC844
            (AQPC844CORR,
             AQPC844FECARGA,
             AQPC844HORSIS,
             AQPC844ITPGCOD,
             AQPC844ITSUC,
             AQPC844ITMOD,
             AQPC844ITTRAN,
             AQPC844ITNREL,
             AQPC844ITFCON,
             AQPC844HORAT,
             AQPC844AGENCIT,
             AQPC844OPERADT,
             AQPC844EMP,
             AQPC844MODU,
             AQPC844SUC,
             AQPC844MDA,
             AQPC844PAP,
             AQPC844CTA,
             AQPC844OPER,
             AQPC844SBOP,
             AQPC844TOPE,
             AQPC844APLICA,
             AQPC844ESBONO,
             AQPC844CODREG,
             AQPC844REGION)
          VALUES
            (P_CORRELATIVO + 1,
             FECHSIST,
             ITHORA,
             PPGCOD,
             PITSUC,
             PITMOD,
             PITTRAN,
             PITNREL,
             FECHATRX,
             ITHORA,
             NOMAGENCIA,
             USUINGTRX,
             V_EMP,
             V_MODU,
             V_SUC,
             V_MDA,
             V_PAP,
             V_CTA,
             V_OPER,
             V_SBOP,
             V_TOPE,
             P_AQPC844APLICA,
             'N',
             P_CODREG,
             P_NOMREG);
          COMMIT;
      END;
    END IF;
  END;

  ---------------------------------------------------------------------------------------------------------------------------  

  PROCEDURE SP_VAL_BONOXREG_DISPON(P_PITSUC    NUMBER,
                                   P_CODREG    OUT NUMBER,
                                   P_NOMREG    OUT VARCHAR2,
                                   P_FLGDISPON OUT VARCHAR2) IS
  
  BEGIN
    --COD Y REGION
    BEGIN
      SELECT REGCOD, REGNOM
        INTO P_CODREG, P_NOMREG
        FROM REGSUC
       WHERE SUCURS = P_PITSUC;
    EXCEPTION
      WHEN OTHERS THEN
        P_CODREG := 0;
    END;
    P_CODREG := NVL(P_CODREG, 0);
  
    P_FLGDISPON := 'N';
    BEGIN
      select 'S'
        INTO P_FLGDISPON
        from fst198 f
       where f.TP1COD = 1
         AND f.tp1cod1 = 11181
         AND f.TP1CORR1 = 1
         AND f.TP1CORR2 = 1
         AND TP1CORR3 = P_CODREG
         AND TP1NRO1 > TP1NRO2;
    EXCEPTION
      WHEN OTHERS THEN
        P_FLGDISPON := 'N';
    END;
    P_FLGDISPON := NVL(P_FLGDISPON, 'N');
  END;

  --------------------------------------------------------------------------------------------------------------------------- 

  PROCEDURE SP_VAL_GANADORES_AQPC844(PPGCOD    NUMBER,
                                     PITSUC    NUMBER,
                                     PITMOD    NUMBER,
                                     PITTRAN   NUMBER,
                                     PITNREL   NUMBER,
                                     FECHATRX  DATE,
                                     FLGCUMPLE out VARCHAR2,
                                     MGSRPTA   out VARCHAR2) IS
  
  BEGIN
    FLGCUMPLE := 'N';
    BEGIN
      SELECT 'S'
        INTO FLGCUMPLE
        FROM AQPC844
       WHERE AQPC844FECARGA = FECHATRX
         AND AQPC844ITPGCOD = PPGCOD
         AND AQPC844ITSUC = PITSUC
         AND AQPC844ITMOD = PITMOD
         AND AQPC844ITTRAN = PITTRAN
         AND AQPC844ITNREL = PITNREL
         AND AQPC844ITFCON = FECHATRX
         AND AQPC844APLICA = 'S'
         AND AQPC844ESBONO = 'S';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    FLGCUMPLE := NVL(FLGCUMPLE, 'N');
  
    IF FLGCUMPLE = 'S' THEN
      MGSRPTA := 'Ganaste tu BONO de ESCOLARIDAD de S/500';
    ELSE
      IF FLGCUMPLE = 'N' THEN
        MGSRPTA := 'Camp. listos para el cole 2025';
      END IF;
    END IF;
  END;

  PROCEDURE SP_ACTUALIZAR_RPTA(PPGCOD    NUMBER,
                               PITSUC    NUMBER,
                               PITMOD    NUMBER,
                               PITTRAN   NUMBER,
                               PITNREL   NUMBER,
                               FECHATRX  DATE,
                               FLGCUMPLE VARCHAR2,
                               MGSRPTA   VARCHAR2) IS
  BEGIN
    BEGIN
      UPDATE AQPC844
         SET AQPC844AUX1 = FLGCUMPLE
       WHERE AQPC844FECARGA = FECHATRX
         AND AQPC844ITPGCOD = PPGCOD
         AND AQPC844ITSUC = PITSUC
         AND AQPC844ITMOD = PITMOD
         AND AQPC844ITTRAN = PITTRAN
         AND AQPC844ITNREL = PITNREL
         AND AQPC844ITFCON = FECHATRX;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        null;
    END;
  END;

END PQ_CR_SORTEBONO_ESCOLAR2025;
/

