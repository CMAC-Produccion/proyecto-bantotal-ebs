CREATE OR REPLACE PROCEDURE SP_CR_VALIDAR_SCORE_CLIENTE(P_INSTANCIA     IN NUMBER,
                                                        P_SCORE_CLIENTE OUT VARCHAR2) IS

   -- *****************************************************************
   -- NOMBRE                      : SP_CR_VALIDAR_SCORE_CLIENTE
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 25/01/2023
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- USO                         : VALIDAR SCORE DEL CLIENTE
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 19/04/2024
   -- AUTOR DE LA MODIFICACION    : MAYCOL CHAVEZ CHUMAN
   -- DESCRIPCION DE MODIFICACION : SE MODIFICÓ LA LECTURA DE LA TABLA AQPB888
   --                               QUE OBTIENE EL SCORE DEL CLIENTE.
   -- *****************************************************************
       
   EXISTE_AGENCIA VARCHAR2(1);
   DOCUMENTO      VARCHAR2(12);
   SCORE_CLIENTE  VARCHAR2(1);
   
   PAIS_DOCUMENTO   NUMBER(3);
   TIPO_DOCUMENTO   NUMBER(2);
   REFINANCIADOS    NUMBER(9);
   CONTADOR         NUMBER(9);
   MONTO_SOLICITADO NUMBER(17, 2);
   MONTO_GUIA       NUMBER(17, 2);
     
   CURSOR LISTA_CLIENTES IS 
      SELECT A.CTNRO
        FROM FSR008 A
       WHERE A.PEPAIS = PAIS_DOCUMENTO 
         AND A.PETDOC = TIPO_DOCUMENTO
         AND A.PENDOC = DOCUMENTO 
         AND A.TTCOD  = 1 
         AND A.CTTFIR = 'T';
BEGIN
   EXISTE_AGENCIA := 'N';
   BEGIN
      SELECT 'S', A.XWFMONTO1, B.PEPAIS, B.PETDOC, TRIM(B.PENDOC)
        INTO EXISTE_AGENCIA, MONTO_SOLICITADO, PAIS_DOCUMENTO,
             TIPO_DOCUMENTO, DOCUMENTO
        FROM XWF700 A
        JOIN FSR008 B
          ON B.CTNRO  = A.XWFCUENTA 
         AND B.TTCOD  = 1 
         AND B.CTTFIR = 'T'
       WHERE A.XWFPRCINS   = P_INSTANCIA
         AND A.XWFCAR3     = '1'
         AND A.XWFSUCURSAL = (SELECT A1.TP1NRO3
                                FROM FST198 A1
                               WHERE A1.TP1COD   = 1
                                 AND A1.TP1COD1  = 111154
                                 AND A1.TP1CORR1 = 1
                                 AND A1.TP1CORR2 = 1
                                 AND A1.TP1CORR3 > 0
                                 AND A1.TP1NRO1  = 1
                                 AND A1.TP1NRO3  = A.XWFSUCURSAL);
             
   EXCEPTION
      WHEN OTHERS THEN
         NULL;
   END;
   
   P_SCORE_CLIENTE := NULL;
   IF EXISTE_AGENCIA = 'S' THEN
      REFINANCIADOS := NULL;
      BEGIN
         PQ_CR_REFINANCIACION_HS.SP_VALIDAR_REFINANCIADOS(VE_INSTANCIA        => P_INSTANCIA, 
                                                          VO_REFINANCIACIONES => REFINANCIADOS);
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
      CONTADOR := 0;
      FOR J1 IN LISTA_CLIENTES LOOP
         BEGIN
            SELECT COUNT(*)
              INTO CONTADOR
              FROM FSD011 A
             WHERE A.PGCOD = 1 
               AND A.SCCTA = J1.CTNRO 
               AND A.SCMOD = (SELECT TP1NRO3 
                                FROM FST198 A1
                               WHERE A1.TP1COD   = 1 
                                 AND A1.TP1COD1  = 111154 
                                 AND A1.TP1CORR1 = 1 
                                 AND A1.TP1CORR2 = 2 
                                 AND A1.TP1CORR3 > 0 
                                 AND A1.TP1NRO1  = 1 
                                 AND A1.TP1NRO3  = A.SCMOD) 
               AND A.SCSTAT <> 99 
               AND A.SCSDO  <> 0;
         EXCEPTION 
            WHEN OTHERS THEN
               NULL;
         END;
         
         EXIT WHEN CONTADOR > 0;
      END LOOP;
      
      IF REFINANCIADOS > 1 OR CONTADOR > 0 THEN
         P_SCORE_CLIENTE := NULL;
      ELSE
         SCORE_CLIENTE    := NULL;
         BEGIN
            SELECT A.AQPB888SCORE
              INTO SCORE_CLIENTE
              FROM AQPB888 A
             WHERE A.AQPB888PERIOD = (SELECT MAX(A1.AQPB888PERIOD) 
                                        FROM AQPB888 A1
                                       WHERE A1.AQPB888PENDOC = DOCUMENTO 
                                         AND A1.AQPB888PETDOC = TO_CHAR(TIPO_DOCUMENTO))
               AND A.AQPB888PENDOC = DOCUMENTO
               AND A.AQPB888PETDOC = TO_CHAR(TIPO_DOCUMENTO);
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
         
         IF SCORE_CLIENTE = 'D' OR SCORE_CLIENTE = 'E' THEN
            MONTO_GUIA := 0;
            BEGIN
               SELECT A.TPIMP
                 INTO MONTO_GUIA
                 FROM FST098 A
                WHERE A.PGCOD  = 1
                  AND A.TPCOD  = 7753
                  AND A.TPCORR = 3
                  AND A.TPNRO  = 1;
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
            
            IF MONTO_GUIA > 0 THEN
               IF MONTO_SOLICITADO < MONTO_GUIA THEN
                  P_SCORE_CLIENTE := '1';
               END IF;
            END IF;
         ELSE
            IF SCORE_CLIENTE = 'F' OR SCORE_CLIENTE = 'G' THEN
               P_SCORE_CLIENTE := '2';
            END IF;
         END IF;
      END IF;
   END IF;      
END SP_CR_VALIDAR_SCORE_CLIENTE;
/

