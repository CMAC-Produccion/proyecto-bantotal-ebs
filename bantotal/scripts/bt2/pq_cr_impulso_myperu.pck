CREATE OR REPLACE PACKAGE PQ_CR_IMPULSO_MYPERU IS
   
   -- *****************************************************************
   -- NOMBRE                      : PQ_CR_IMPULSO_MYPERU
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 23/11/2023
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- *****************************************************************

   PROCEDURE SP_CR_REPORTE_ACTUALIZACION_SALDOS_GARANTIAS(P_CODIGO_REGION   IN  NUMBER,
                                                          P_CODIGO_ZONA     IN  NUMBER,
                                                          P_CODIGO_SUCURSAL IN  NUMBER,
                                                          P_FECHA_INICIO    IN  DATE,
                                                          P_FECHA_FIN       IN  DATE,
                                                          P_USUARIO_PROCESO IN  VARCHAR2);

END PQ_CR_IMPULSO_MYPERU;
/

CREATE OR REPLACE PACKAGE BODY PQ_CR_IMPULSO_MYPERU IS
   
   PROCEDURE SP_CR_REPORTE_ACTUALIZACION_SALDOS_GARANTIAS(P_CODIGO_REGION   IN  NUMBER,
                                                          P_CODIGO_ZONA     IN  NUMBER,
                                                          P_CODIGO_SUCURSAL IN  NUMBER,
                                                          P_FECHA_INICIO    IN  DATE,
                                                          P_FECHA_FIN       IN  DATE,
                                                          P_USUARIO_PROCESO IN  VARCHAR2) IS
   
   -- *****************************************************************
   -- NOMBRE                      : SP_CR_REPORTE_ACTUALIZACION_SALDOS_GARANTIAS
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 23/11/2023
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- USO                         : GENERA LA DATA PARA EL REPORTE DE ACTUALIZACION
   --                               DE SALDOS DE GARANTIAS
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   --------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   --
   -- *****************************************************************
   
   FECHA_PROCESO DATE;
   HORA_PROCESO  VARCHAR2(8);
   
   BEGIN
      BEGIN
         DELETE FROM AQPC755 WHERE AQPC755USUPRC = P_USUARIO_PROCESO;
         COMMIT;
      EXCEPTION
         WHEN OTHERS THEN
           NULL;
      END;
      BEGIN
         SELECT PGFAPE
         INTO FECHA_PROCESO
         FROM FST017
         WHERE PGCOD = 1;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      HORA_PROCESO := TO_CHAR(SYSDATE, 'HH24:MI:SS');
      BEGIN
         INSERT INTO AQPC755 (AQPC755CORR, AQPC755USUPRC, AQPC755INST, AQPC755EMPC, AQPC755SUCC, AQPC755MODC, AQPC755MDAC, AQPC755PAPC, 
                              AQPC755CTAC, AQPC755OPEC, AQPC755SBOC, AQPC755TOPC, AQPC755NSUCC, AQPC755SDOC, AQPC755ESTC, AQPC755NESTC, 
                              AQPC755EMPG, AQPC755SUCG, AQPC755MODG, AQPC755MDAG, AQPC755PAPG, AQPC755CTAG, AQPC755OPEG, AQPC755SBOG, 
                              AQPC755TOPG, AQPC755NSUCG, AQPC755SDOG, AQPC755MTOAG, AQPC755ESTG, AQPC755NESTG, AQPC755EST, AQPC755PCJ, 
                              AQPC755TIP, AQPC755ITEMP, AQPC755ITMOD, AQPC755ITSUC, AQPC755ITTRAN, AQPC755ITNREL, AQPC755ITFCON, AQPC755ITHOR,
                              AQPC755ITUCNF, AQPC755USUACT, AQPC755FECACT, AQPC755FCHPRC, AQPC755HORPRC)
           
         SELECT ROWNUM, P_USUARIO_PROCESO, A.AQPD201INS, A.AQPD201EMP, A.AQPD201SUC, A.AQPD201MOD, A.AQPD201MDA, A.AQPD201PAP, A.AQPD201CTA, 
                A.AQPD201OPE, A.AQPD201SBO, A.AQPD201TOP, F.SCNOM, ABS(C.SCSDO), C.SCSTAT, E.CENOM, 
                A.AQPD201EMPG, A.AQPD201SUCG, A.AQPD201MODG, A.AQPD201MDAG, A.AQPD201PAPG, A.AQPD201CTAG, A.AQPD201OPEG, A.AQPD201SBOG, 
                A.AQPD201TOPG, G.SCNOM, B.SCSDO, A.AQPD201MTOA, B.SCSTAT, D.CENOM, A.AQPD201EST, A.AQPD201PCJ, A.AQPD201TIP, A.AQPD201ITCOD, 
                A.AQPD201ITMOD, A.AQPD201ITSUC, A.AQPD201ITTRAN, A.AQPD201ITNREL, A.AQPD201ITFCON, A.AQPD201ITHOR, A.AQPD201ITUCNF, A.AQPD201USUACT, 
                A.AQPD201FECACT, FECHA_PROCESO, HORA_PROCESO
           FROM AQPD201 A
           JOIN FSD011 B
             ON A.AQPD201EMPG = B.PGCOD
            AND A.AQPD201SUCG = B.SCSUC
            AND A.AQPD201MODG = B.SCMOD
            AND A.AQPD201MDAG = B.SCMDA
            AND A.AQPD201PAPG = B.SCPAP
            AND A.AQPD201CTAG = B.SCCTA
            AND A.AQPD201OPEG = B.SCOPER
            AND A.AQPD201SBOG = B.SCSBOP
            AND A.AQPD201TOPG = B.SCTOPE
           JOIN FSD011 C
             ON A.AQPD201EMP = C.PGCOD
            AND A.AQPD201SUC = C.SCSUC
            AND A.AQPD201MOD = C.SCMOD
            AND A.AQPD201MDA = C.SCMDA
            AND A.AQPD201PAP = C.SCPAP
            AND A.AQPD201CTA = C.SCCTA
            AND A.AQPD201OPE = C.SCOPER
            AND A.AQPD201SBO = C.SCSBOP
            AND A.AQPD201TOP = C.SCTOPE
           LEFT JOIN FST026 D
             ON D.CECOD = B.SCSTAT
           LEFT JOIN FST026 E
             ON E.CECOD = C.SCSTAT
           LEFT JOIN FST001 F
             ON F.PGCOD  = A.AQPD201EMP
            AND F.SUCURS = A.AQPD201SUC
           LEFT JOIN FST001 G
             ON G.PGCOD  = A.AQPD201EMPG
            AND G.SUCURS = A.AQPD201SUCG
          WHERE B.SCSTAT <> 99
            AND A.AQPD201EST = 'C'
            AND A.AQPD201ITFCON BETWEEN P_FECHA_INICIO AND P_FECHA_FIN
            AND C.SCMOD IN (SELECT MODULO FROM FST111 WHERE DSCOD = 50)
            AND A.AQPD201SUCG IN
                (SELECT SUCURS
                   FROM REGSUC
                  WHERE REGCOD = DECODE(NVL(P_CODIGO_REGION, 0), 0, REGCOD, P_CODIGO_REGION)
                    AND CODZON = DECODE(NVL(P_CODIGO_ZONA, 0), 0, CODZON, P_CODIGO_ZONA)
                    AND SUCURS = DECODE(NVL(P_CODIGO_SUCURSAL, 0), 0, SUCURS, P_CODIGO_SUCURSAL));
         COMMIT;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END; 
   END SP_CR_REPORTE_ACTUALIZACION_SALDOS_GARANTIAS;

END PQ_CR_IMPULSO_MYPERU;
/

