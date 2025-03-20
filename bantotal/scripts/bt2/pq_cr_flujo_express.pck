CREATE OR REPLACE PACKAGE PQ_CR_FLUJO_EXPRESS IS

   -- *****************************************************************
   -- NOMBRE                      : PQ_CR_FLUJO_EXPRESS
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 05/06/2023
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- *****************************************************************

   PROCEDURE SP_CR_MNT_AQPC266(P_MODE  IN CHAR,
                               P_DNI   IN CHAR,
                               P_CTA   IN NUMBER,
                               P_MOD   IN NUMBER,
                               P_TOPE  IN NUMBER,
                               P_FCH   IN DATE,
                               P_CORR  IN NUMBER,
                               P_PAIS  NUMBER,
                               P_TPDOC NUMBER,
                               P_CODSG IN NUMBER,
                               P_EST   IN CHAR,
                               P_USU   IN CHAR,
                               P_FREG  IN DATE,
                               P_HREG  IN CHAR,
                               P_AUX1  IN NUMBER,
                               P_AUX2  IN NUMBER,
                               P_AUX3  IN CHAR,
                               P_AUX4  IN CHAR);

   PROCEDURE SP_CR_TIENE_SEGURO_VIDA_CAJA(pPais IN NUMBER,
                                          pTdoc IN NUMBER,
                                          pNdoc IN VARCHAR2,
                                          pRes  OUT NUMBER);

   PROCEDURE SP_CR_EXISTE_REGISTRO_AQPC266(P_DNI IN CHAR, P_RES OUT CHAR);

   PROCEDURE SP_CR_VALIDAR_LINEAS(P_FECHA IN DATE,
                                  P_CORR  IN NUMBER,
                                  P_RES   OUT VARCHAR2);

END PQ_CR_FLUJO_EXPRESS;
/

CREATE OR REPLACE PACKAGE BODY PQ_CR_FLUJO_EXPRESS IS

   PROCEDURE SP_CR_MNT_AQPC266(P_MODE  IN CHAR,
                               P_DNI   IN CHAR,
                               P_CTA   IN NUMBER,
                               P_MOD   IN NUMBER,
                               P_TOPE  IN NUMBER,
                               P_FCH   IN DATE,
                               P_CORR  IN NUMBER,
                               P_PAIS  IN NUMBER,
                               P_TPDOC IN NUMBER,
                               P_CODSG IN NUMBER,
                               P_EST   IN CHAR,
                               P_USU   IN CHAR,
                               P_FREG  IN DATE,
                               P_HREG  IN CHAR,
                               P_AUX1  IN NUMBER,
                               P_AUX2  IN NUMBER,
                               P_AUX3  IN CHAR,
                               P_AUX4  IN CHAR) IS
   
      -- *****************************************************************
      -- NOMBRE                      : SP_CR_MNT_AQPC266
      -- SISTEMA                     : BANTOTAL
      -- MODULO                      : CREDITOS - ACTIVAS
      -- VERSION                     : 1.0
      -- FECHA DE CREACION           : 05/06/2023
      -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
      -- USO                         : MANTENEDOR DE LA TABLA AQPC266
      -- ESTADO                      : ACTIVO
      -- ACCESO                      : PUBLICO
      --------------------------------------------------------------------
      -- FECHA DE MODIFICACION       : 
      -- AUTOR DE LA MODIFICACION    : 
      -- DESCRIPCION DE MODIFICACION : 
      --
      -- *****************************************************************
   
   BEGIN
      CASE
         WHEN P_MODE = 'INS' THEN
            BEGIN
               INSERT INTO AQPC266
                  (AQPC266DNI,
                   AQPC266CTA,
                   AQPC266MOD,
                   AQPC266TOPE,
                   AQPC266FCH,
                   AQPC266CORR,
                   AQPC266PAIS,
                   AQPC266TPDOC,
                   AQPC266CODSG,
                   AQPC266EST,
                   AQPC266USU,
                   AQPC266FREG,
                   AQPC266HREG,
                   AQPC266AUX1,
                   AQPC266AUX2,
                   AQPC266AUX3,
                   AQPC266AUX4)
               VALUES
                  (P_DNI,
                   P_CTA,
                   P_MOD,
                   P_TOPE,
                   P_FCH,
                   P_CORR,
                   P_PAIS,
                   P_TPDOC,
                   P_CODSG,
                   P_EST,
                   P_USU,
                   P_FREG,
                   P_HREG,
                   P_AUX1,
                   P_AUX2,
                   P_AUX3,
                   P_AUX4);
               COMMIT;
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
         WHEN P_MODE = 'DEL' THEN
            BEGIN
               DELETE FROM AQPC266
                WHERE AQPC266CTA = P_CTA
                  AND AQPC266DNI = P_DNI
                  AND AQPC266CODSG = P_CODSG;
               COMMIT;
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
         ELSE
            NULL;
      END CASE;
   END SP_CR_MNT_AQPC266;

   PROCEDURE SP_CR_TIENE_SEGURO_VIDA_CAJA(pPais IN NUMBER,
                                          pTdoc IN NUMBER,
                                          pNdoc IN VARCHAR2,
                                          pRes  OUT NUMBER) IS
   
      -- *****************************************************************
      -- NOMBRE                      : SP_CR_TIENE_SEGURO_VIDA_CAJA
      -- SISTEMA                     : BANTOTAL
      -- MODULO                      : CREDITOS - ACTIVAS
      -- VERSION                     : 1.0
      -- FECHA DE CREACION           : 05/06/2023
      -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
      -- USO                         : VALIDA SI TIENE UN SEGURO VIDA CAJA EL CLIENTE
      -- ESTADO                      : ACTIVO
      -- ACCESO                      : PUBLICO
      --------------------------------------------------------------------
      -- FECHA DE MODIFICACION       : 
      -- AUTOR DE LA MODIFICACION    : 
      -- DESCRIPCION DE MODIFICACION : 
      --
      -- *****************************************************************
   
      Cont1 NUMBER(5) := 0;
      Cont2 NUMBER(5) := 0;
      SegAh CHAR(25) := 'VIDA CAJA AHORROS%';
      Flag  CHAR(1) := 'N';
      CURSOR c1 IS
         SELECT CTNRO
           FROM FSR008
          WHERE PEPAIS = pPais
            AND PETDOC = pTdoc
            AND PENDOC = RPAD(pNdoc, 12)
            AND CTTFIR = 'T';
   BEGIN
      FOR X IN c1 LOOP
         BEGIN
            SELECT COUNT(*)
              INTO Cont1
              FROM FSD010 A1
              JOIN FPP001 B1
                ON A1.PGCOD = B1.PGCOD
               AND A1.AOMOD = B1.AOMOD
               AND A1.AOSUC = B1.AOSUC
               AND A1.AOMDA = B1.AOMDA
               AND A1.AOPAP = B1.AOPAP
               AND A1.AOCTA = B1.AOCTA
               AND A1.AOOPER = B1.AOOPER
               AND A1.AOSBOP = B1.AOSBOP
               AND A1.AOTOPE = B1.AOTOPE
             WHERE A1.AOMOD IN (SELECT MODULO FROM FST111 WHERE DSCOD = 50)
               AND A1.AOSTAT <> 99
               AND A1.AOCTA = X.CTNRO
               AND B1.SGCOD IN
                   (SELECT TP1NRO3
                      FROM FST198
                     WHERE TP1COD = 1
                       AND TP1COD1 = 10898
                       AND TP1CORR1 = 18
                       AND TP1CORR3 = 1
                       AND TP1NRO3 IN (122, 124, 125));
         
            pQ_CR_CREDITOS_ALERTAS.SP_CR_TIENE_SEGURO(pPais,
                                                      pTdoc,
                                                      pNdoc,
                                                      SegAh,
                                                      Flag);
            IF Flag = 'S' THEN
               Cont2 := Cont2 + 1;
            END IF;
         
            pRes := Cont1 + Cont2;
         EXCEPTION
            WHEN OTHERS THEN
               pRes := 0;
         END;
         EXIT WHEN pRes > 0;
      END LOOP;
   END SP_CR_TIENE_SEGURO_VIDA_CAJA;

   PROCEDURE SP_CR_EXISTE_REGISTRO_AQPC266(P_DNI IN CHAR, P_RES OUT CHAR) IS
   
      -- *****************************************************************
      -- NOMBRE                      : SP_CR_EXISTE_REGISTRO_AQPC266
      -- SISTEMA                     : BANTOTAL
      -- MODULO                      : CREDITOS - ACTIVAS
      -- VERSION                     : 1.0
      -- FECHA DE CREACION           : 05/06/2023
      -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
      -- USO                         : VALIDA SI YA SE REGISTRO 1 SEGURO VIDA CAJA
      -- ESTADO                      : ACTIVO
      -- ACCESO                      : PUBLICO
      --------------------------------------------------------------------
      -- FECHA DE MODIFICACION       : 
      -- AUTOR DE LA MODIFICACION    : 
      -- DESCRIPCION DE MODIFICACION : 
      --
      -- *****************************************************************
   
      V_EXISTE CHAR(1) := 'N';
   BEGIN
      SELECT 'S' INTO V_EXISTE FROM AQPC266 WHERE AQPC266DNI = P_DNI;
      IF V_EXISTE = 'S' THEN
         P_RES := 'S';
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         P_RES := 'N';
   END SP_CR_EXISTE_REGISTRO_AQPC266;

   PROCEDURE SP_CR_VALIDAR_LINEAS(P_FECHA IN DATE,
                                  P_CORR  IN NUMBER,
                                  P_RES   OUT VARCHAR2) IS
   
      -- *****************************************************************
      -- NOMBRE                      : SP_CR_VALIDAR_LINEAS
      -- SISTEMA                     : BANTOTAL
      -- MODULO                      : CREDITOS - ACTIVAS
      -- VERSION                     : 1.0
      -- FECHA DE CREACION           : 05/06/2023
      -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
      -- USO                         : VALIDA LINEAS MODULO 117
      -- ESTADO                      : ACTIVO
      -- ACCESO                      : PUBLICO
      --------------------------------------------------------------------
      -- FECHA DE MODIFICACION       : 
      -- AUTOR DE LA MODIFICACION    : 
      -- DESCRIPCION DE MODIFICACION : 
      --
      -- *****************************************************************
   
      V_EXISTE VARCHAR2(1);
   BEGIN
      SELECT 'S'
        INTO V_EXISTE
        FROM JAQZ697
       WHERE JAQZ697FEP = P_FECHA
         AND JAQZ697COR = P_CORR
         AND JAQZ697MOD = 117;
      P_RES := V_EXISTE;
   EXCEPTION
      WHEN OTHERS THEN
         V_EXISTE := 'N';
         P_RES    := V_EXISTE;
   END SP_CR_VALIDAR_LINEAS;

end PQ_CR_FLUJO_EXPRESS;
/

