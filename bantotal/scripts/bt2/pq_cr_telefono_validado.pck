CREATE OR REPLACE PACKAGE PQ_CR_TELEFONO_VALIDADO IS
   
   -- *****************************************************************
   -- NOMBRE                      : PQ_CR_TELEFONO_VALIDADO
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 14/02/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- *****************************************************************

   PROCEDURE SP_CR_OBTENER_TELEFONO(P_PAIS_DOCUMENTO   IN  NUMBER,
                                    P_TIPO_DOCUMENTO   IN  NUMBER,
                                    P_DOCUMENTO        IN  VARCHAR2,
                                    P_CODIGO_DOMICILIO IN  NUMBER,
                                    P_OUT_TELEFONO     OUT VARCHAR2);

END PQ_CR_TELEFONO_VALIDADO;
/

CREATE OR REPLACE PACKAGE BODY PQ_CR_TELEFONO_VALIDADO IS
   
   PROCEDURE SP_CR_OBTENER_TELEFONO(P_PAIS_DOCUMENTO   IN  NUMBER,
                                    P_TIPO_DOCUMENTO   IN  NUMBER,
                                    P_DOCUMENTO        IN  VARCHAR2,
                                    P_CODIGO_DOMICILIO IN  NUMBER,
                                    P_OUT_TELEFONO     OUT VARCHAR2) IS
   
   -- *****************************************************************
   -- NOMBRE                      : SP_CR_OBTENER_TELEFONO
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 13/02/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- USO                         : RETORNA EL NRO. DE TELEFONO
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- *****************************************************************
   
      TELEFONO VARCHAR2(20);
   BEGIN
      BEGIN
         SELECT A.JAQN2ATELF
           INTO TELEFONO
           FROM (SELECT TRIM(X.JAQN2ATELF) JAQN2ATELF, Y.JAQN3AFVEC
                   FROM JAQN2A X, JAQN3A Y
                  WHERE X.JAQN2APAI  = Y.JAQN3APAI
                    AND X.JAQN2ATDOC = Y.JAQN3ATDOC
                    AND X.JAQN2ANDOC = Y.JAQN3ANDOC
                    AND X.JAQN2ACOR  = Y.JAQN3ACOR
                    AND X.JAQN2AFEG  = Y.JAQN3AFEG
                    AND X.JAQN2ATIPV = Y.JAQN3ATIPV
                    AND Y.JAQN3AVIG  = 'S'
                    AND X.JAQN2APAI  = P_PAIS_DOCUMENTO
                    AND X.JAQN2ATDOC = P_TIPO_DOCUMENTO
                    AND X.JAQN2ANDOC = RPAD(P_DOCUMENTO, 12, ' ')
                    AND X.JAQN2AEST  = 'VALIDADO'
                    AND TRIM(X.JAQN2ATELF) IS NOT NULL
                    AND EXISTS
                  (SELECT 1
                           FROM FSR005 Z
                          WHERE Z.PEPAIS = X.JAQN2APAI
                            AND Z.PETDOC = X.JAQN2ATDOC
                            AND Z.PENDOC = X.JAQN2ANDOC
                            AND TRIM(Z.DOTELFP) = TRIM(X.JAQN2ATELF))
                 
                  ORDER BY 2 DESC) A
          WHERE ROWNUM = 1;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            BEGIN
               SELECT DOTELFP
                 INTO TELEFONO
                 FROM FSR005
                WHERE PEPAIS = P_PAIS_DOCUMENTO
                  AND PETDOC = P_TIPO_DOCUMENTO
                  AND PENDOC = RPAD(P_DOCUMENTO, 12, ' ')
                  AND DOCOD  = P_CODIGO_DOMICILIO
                  AND DOORDP = 1;
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
         WHEN OTHERS THEN
            NULL;
      END;
      P_OUT_TELEFONO := TRIM(TELEFONO);
   END SP_CR_OBTENER_TELEFONO;

END PQ_CR_TELEFONO_VALIDADO;
/

