CREATE OR REPLACE PROCEDURE SP_AH_CAMREMCTS(P_SUCURSAL    IN NUMBER,
                                            P_FECHAINICIO IN VARCHAR2,
                                            P_FECHAFIN    IN VARCHAR2,
                                            P_USUARIO     IN VARCHAR2) IS
-- **********************************************************************************
  -- Nombre                     : SP_AH_CAMREMCTS
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Pasivas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 10/02/2014
  -- Autor de Creación          : SMARQUEZ
  -- Uso                        : ACCESOS TEMPORALES
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :SUCURSAL,FECHA INICIAL Y FINAL , USUARIO
  -- Descripción de Modificación: USO DE TABLA TEMPORALE PARA ALMACENAR DATOS
  -- DE CAMBIOS REALIZADOS DE MANERA MANUAL PARA COBRAR MAS DE LO DISPONIBLE.
  -- Y LUEGO IMPRIMIR DESDE GENEXUS
  -- **********************************************************************************

  TYPE REG_CTSDINAMICA IS RECORD
 (
  CTSPEMP1  NUMBER(3),
  CTSTEMP1  NUMBER(2),
  CTSNEMP1  CHAR(12),
  CTSPEMP2  NUMBER(3),
  CTSTEMP2  NUMBER(2),
  CTSNEMP2  CHAR(12),
  CTSCTAE2  NUMBER(9),
  CTSFECRG  DATE,
  CTSHORRG  CHAR(8),
  CTSUSURG  CHAR(10),
  CTSSUCRG  NUMBER(3),
  CTSIMPRM  NUMBER(17,2)
   );
  TYPE TAB_CTSDINAMICA IS TABLE OF REG_CTSDINAMICA INDEX BY BINARY_INTEGER;

  CTSDINAMICA TAB_CTSDINAMICA;

  CURSOR CUENTA (SUCUR in  NUMBER,FECHAINI in  DATE,FECHAFIN  in DATE) IS
      SELECT DISTINCT CTSCTAE2
        FROM CTS001
       WHERE CTSFECRG BETWEEN FECHAINI AND FECHAFIN
         AND CTSSUCRG =SUCUR;
         
  CURSOR CUENTA1 (FECHAINI1 in  DATE,FECHAFIN1  in DATE) IS
      SELECT DISTINCT CTSCTAE2
        FROM CTS001
       WHERE CTSFECRG BETWEEN FECHAINI1 AND FECHAFIN1;        


  CURSOR CTS (NUMCTA in  NUMBER,FECHAUNO in  DATE,FECHADOS  in DATE) IS
       SELECT CTSPEMP1,
              CTSTEMP1,
              CTSNEMP1, --empleador
              CTSPEMP2,
              CTSTEMP2,
              CTSNEMP2, --cliente
              CTSCTAE2, --cuenta
              CTSFECRG, --FECHA
              CTSHORRG, --HORA
              CTSUSURG, --USUARIO
              CTSSUCRG,
              CTSIMPRM --MONTO REMUNERACION
         FROM CTS001
        WHERE CTSCTAE2 = NUMCTA
          AND CTSIMPRM <> 0
        --  AND CTSFECRG BETWEEN FECHAUNO AND FECHADOS
        ORDER BY CTSFECRG ASC;
         VCTS CTS%ROWTYPE;

  V_SUC NUMBER;
  VFECHA1 DATE;
  VFECHA2 DATE;
  VREG  NUMBER;
  VREG1 NUMBER;
  MONTO_INICIAL NUMBER;
  FECHA_CAMBIO DATE;




  /*TYPE T_CTS001 is TABLE of CTS%ROWTYPE INDEX BY PLS_INTEGER;
  R_CTS001   T_CTS001;*/

  I NUMBER := 0;
  CONT_REG NUMBER := 0;
  NOM_SUC VARCHAR2(30);
  NOM_CLI VARCHAR2(30);
  NOM_EMP VARCHAR2(30);
  USUARIO VARCHAR2(12);
  VERIF   NUMBER := 0;
  CONTROL NUMBER := 0;
  TSUC NUMBER := 0;
  INICIOCONT NUMBER := 0;
  
BEGIN

   V_SUC    := P_SUCURSAL;
   VFECHA1  := TO_DATE(P_FECHAINICIO,'DD/MM/RRRR');
   VFECHA2  := TO_DATE(P_FECHAFIN,'DD/MM/RRRR');
   USUARIO  := P_USUARIO;

   if V_SUC <> 0 THEN
     SELECT SCNOM
       INTO NOM_SUC
       FROM FST001
      WHERE SUCURS = V_SUC;
      TSUC := 1;
   ELSE
     NOM_SUC := 'TODAS';
     TSUC := 2;
   END IF;   

   SELECT f.TPNRO --- Adicionar en la GUIA de proceso
     INTO CONTROL
     FROM FST098 F
    WHERE f.TPCOD = 7645
      AND F.TPCORR = 1;
      
   CASE TSUC 
   WHEN 1 THEN
     FOR REG IN CUENTA(V_SUC, VFECHA1,VFECHA2)LOOP
         VREG := REG.CTSCTAE2;
         I := 0;
         BEGIN
           SELECT COUNT(*)
             INTO CONT_REG
             FROM CTS001
            WHERE CTSCTAE2 = VREG
              AND CTSIMPRM <> 0;
              --AND CTSFECRG BETWEEN VFECHA1 AND VFECHA2;
           IF CONT_REG >= 2 THEN
              FOR VCTS IN CTS(VREG,VFECHA1,VFECHA2) LOOP

                I := I + 1;
                CTSDINAMICA(I).CTSPEMP1 := VCTS.CTSPEMP1;
                CTSDINAMICA(I).CTSTEMP1 := VCTS.CTSTEMP1;
                CTSDINAMICA(I).CTSNEMP1 := VCTS.CTSNEMP1;
                CTSDINAMICA(I).CTSPEMP2 := VCTS.CTSPEMP2;
                CTSDINAMICA(I).CTSTEMP2 := VCTS.CTSTEMP2;
                CTSDINAMICA(I).CTSNEMP2 := VCTS.CTSNEMP2;
                CTSDINAMICA(I).CTSCTAE2 := VCTS.CTSCTAE2;
                CTSDINAMICA(I).CTSFECRG := TRUNC(VCTS.CTSFECRG);
                CTSDINAMICA(I).CTSHORRG := VCTS.CTSHORRG;
                CTSDINAMICA(I).CTSUSURG := VCTS.CTSUSURG;
                CTSDINAMICA(I).CTSSUCRG := VCTS.CTSSUCRG;
                CTSDINAMICA(I).CTSIMPRM := VCTS.CTSIMPRM;

              END LOOP;

              MONTO_INICIAL := 0;
              FECHA_CAMBIO := NULL;

              FOR J IN CTSDINAMICA.FIRST .. CTSDINAMICA.LAST LOOP
                 IF J = CTSDINAMICA.FIRST THEN
                      MONTO_INICIAL := CTSDINAMICA(J).CTSIMPRM;
                      FECHA_CAMBIO  := CTSDINAMICA(J).CTSFECRG;
                      VERIF := 0;
                 ELSE
                   IF  CTSDINAMICA(J).CTSIMPRM >= MONTO_INICIAL THEN
                       MONTO_INICIAL := CTSDINAMICA(J).CTSIMPRM;
                       FECHA_CAMBIO  := CTSDINAMICA(J).CTSFECRG;
                   ELSE
                      IF CONTROL = 1 THEN
                        IF FECHA_CAMBIO = CTSDINAMICA(J).CTSFECRG THEN
                           VERIF := FN_AH_VERIF_RETIRO(p_cuenta => VREG,
                                                       p_fecha => FECHA_CAMBIO);
                           EXIT WHEN VERIF = 1;
                        ELSE
                           VERIF := 0;
                        END IF;
                      ELSE
                         IF CTSDINAMICA(J).CTSFECRG >= VFECHA1 THEN                                                                            
                            INICIOCONT := J;
                            VERIF := 1;    
                            EXIT;                          
                         END IF;
                      END IF;
                   END IF;
                 END IF;
              END LOOP;
              IF VERIF = 1 THEN
                 FOR k IN INICIOCONT .. CTSDINAMICA.LAST LOOP
                    BEGIN
                     SELECT PENOM
                       INTO NOM_CLI
                       FROM FSD001
                      WHERE PEPAIS = CTSDINAMICA(k).CTSPEMP1
                        AND PETDOC = CTSDINAMICA(k).CTSTEMP1
                        AND PENDOC = CTSDINAMICA(k).CTSNEMP1;
                     SELECT PENOM
                       INTO NOM_EMP
                       FROM FSD001
                      WHERE PEPAIS = CTSDINAMICA(k).CTSPEMP2
                        AND PETDOC = CTSDINAMICA(k).CTSTEMP2
                        AND PENDOC = CTSDINAMICA(k).CTSNEMP2;
                    EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                        NULL;
                    END;
                    INSERT INTO JAQY652
                      (JAQY652COD,
                       JAQY652AGE,
                       JAQY652CLI,
                       JAQY652DIR,
                       JAQY652DIS,
                       JAQY652PRO,
                       JAQY652DEP,
                       JAQY652TEL,
                       JAQY652NCT,
                       JAQY652USU,
                       JAQY652TIP)
                    VALUES
                      (SEQ_PR_CTSREM.NEXTVAL,
                       NOM_SUC,
                       NOM_CLI,
                       NOM_EMP,
                       CTSDINAMICA(K).CTSCTAE2,
                       TO_CHAR(CTSDINAMICA(K).CTSFECRG,'DD/MM/RRRR')||' '||CTSDINAMICA(K).CTSHORRG,
                       CTSDINAMICA(K).CTSUSURG,
                       CTSDINAMICA(K).CTSSUCRG,
                       CTSDINAMICA(K).CTSIMPRM,
                       USUARIO,
                       55);
                       COMMIT;
                       CTSDINAMICA.DELETE(K);
                 END LOOP;
              ELSE
               CTSDINAMICA.DELETE;
              END IF;
           END IF;
       EXCEPTION
          WHEN OTHERS THEN
            NULL;
       END;
     END LOOP;
   WHEN 2 THEN
      FOR REG1 IN CUENTA1( VFECHA1,VFECHA2)LOOP
         VREG1 := REG1.CTSCTAE2;
         I := 0;
         BEGIN
           SELECT COUNT(*)
             INTO CONT_REG
             FROM CTS001
            WHERE CTSCTAE2 = VREG1
              AND CTSIMPRM <> 0;
              --AND CTSFECRG BETWEEN VFECHA1 AND VFECHA2;
           IF CONT_REG >= 2 THEN
              FOR VCTS IN CTS(VREG1,VFECHA1,VFECHA2) LOOP

                I := I + 1;
                CTSDINAMICA(I).CTSPEMP1 := VCTS.CTSPEMP1;
                CTSDINAMICA(I).CTSTEMP1 := VCTS.CTSTEMP1;
                CTSDINAMICA(I).CTSNEMP1 := VCTS.CTSNEMP1;
                CTSDINAMICA(I).CTSPEMP2 := VCTS.CTSPEMP2;
                CTSDINAMICA(I).CTSTEMP2 := VCTS.CTSTEMP2;
                CTSDINAMICA(I).CTSNEMP2 := VCTS.CTSNEMP2;
                CTSDINAMICA(I).CTSCTAE2 := VCTS.CTSCTAE2;
                CTSDINAMICA(I).CTSFECRG := TRUNC(VCTS.CTSFECRG);
                CTSDINAMICA(I).CTSHORRG := VCTS.CTSHORRG;
                CTSDINAMICA(I).CTSUSURG := VCTS.CTSUSURG;
                CTSDINAMICA(I).CTSSUCRG := VCTS.CTSSUCRG;
                CTSDINAMICA(I).CTSIMPRM := VCTS.CTSIMPRM;

              END LOOP;

              MONTO_INICIAL := 0;
              FECHA_CAMBIO := NULL;

              FOR J IN CTSDINAMICA.FIRST .. CTSDINAMICA.LAST LOOP
                 IF J = CTSDINAMICA.FIRST THEN
                      MONTO_INICIAL := CTSDINAMICA(J).CTSIMPRM;
                      FECHA_CAMBIO  := CTSDINAMICA(J).CTSFECRG;
                      VERIF := 0;
                 ELSE
                   IF  CTSDINAMICA(J).CTSIMPRM >= MONTO_INICIAL THEN
                       MONTO_INICIAL := CTSDINAMICA(J).CTSIMPRM;
                       FECHA_CAMBIO  := CTSDINAMICA(J).CTSFECRG;
                   ELSE
                      IF CONTROL = 1 THEN
                        IF CTSDINAMICA(J).CTSFECRG <= VFECHA1 THEN
                           VERIF := FN_AH_VERIF_RETIRO(p_cuenta => VREG1,
                                                       p_fecha => FECHA_CAMBIO);
                           EXIT WHEN VERIF = 1;
                        ELSE
                           VERIF := 0;
                        END IF;
                      ELSE---
                         IF CTSDINAMICA(J).CTSFECRG >= VFECHA1 THEN                                                                            
                            INICIOCONT := J;
                            VERIF := 1;    
                            EXIT;                          
                         END IF;
                      END IF;
                   END IF;
                 END IF;
              END LOOP;
              IF VERIF = 1 THEN
                 FOR k IN INICIOCONT .. CTSDINAMICA.LAST LOOP
                    BEGIN
                     SELECT PENOM
                       INTO NOM_CLI
                       FROM FSD001
                      WHERE PEPAIS = CTSDINAMICA(k).CTSPEMP1
                        AND PETDOC = CTSDINAMICA(k).CTSTEMP1
                        AND PENDOC = CTSDINAMICA(k).CTSNEMP1;
                     SELECT PENOM
                       INTO NOM_EMP
                       FROM FSD001
                      WHERE PEPAIS = CTSDINAMICA(k).CTSPEMP2
                        AND PETDOC = CTSDINAMICA(k).CTSTEMP2
                        AND PENDOC = CTSDINAMICA(k).CTSNEMP2;
                    EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                        NULL;
                    END;
                    INSERT INTO JAQY652
                      (JAQY652COD,
                       JAQY652AGE,
                       JAQY652CLI,
                       JAQY652DIR,
                       JAQY652DIS,
                       JAQY652PRO,
                       JAQY652DEP,
                       JAQY652TEL,
                       JAQY652NCT,
                       JAQY652USU,
                       JAQY652TIP)
                    VALUES
                      (SEQ_PR_CTSREM.NEXTVAL,
                       NOM_SUC,
                       NOM_CLI,
                       NOM_EMP,
                       CTSDINAMICA(K).CTSCTAE2,
                       TO_CHAR(CTSDINAMICA(K).CTSFECRG,'DD/MM/RRRR')||' '||CTSDINAMICA(K).CTSHORRG,
                       CTSDINAMICA(K).CTSUSURG,
                       CTSDINAMICA(K).CTSSUCRG,
                       CTSDINAMICA(K).CTSIMPRM,
                       USUARIO,
                       55);
                       COMMIT;
                       CTSDINAMICA.DELETE(K);
                 END LOOP;
              ELSE
               CTSDINAMICA.DELETE;
              END IF;
           END IF;
       EXCEPTION
          WHEN OTHERS THEN
            NULL;
       END;
     END LOOP;
   END CASE;  

END SP_AH_CAMREMCTS;
/

