CREATE OR REPLACE PACKAGE PQ_CR_CREDITOS_COMPART IS

   ----------------------------------------------------------------------------------------------------
   -- NOMBRE                      : PQ_CR_CREDITOS_COMPART
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 22/10/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   ----------------------------------------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 26/11/2024
   -- AUTOR DE LA MODIFICACION    : MAYCOL CHAVEZ CHUMAN
   -- DESCRIPCION DE MODIFICACION : SE MODIFICO EL PROCEDIMIENTO:
   --                               - SP_CR_OBTENER_ETAPACRED
   --                               - SP_CR_GRABAR_DETALLE
   ----------------------------------------------------------------------------------------------------
   
   ----------------------------------------------------------------------------------------------------
   PROCEDURE SP_CR_GRABAR_CABECERA(P_USUARIO   IN  VARCHAR2,
                                   P_FECREG    IN  DATE,
                                   P_HORAREG   IN  VARCHAR2,
                                   P_PAISDOC   IN  NUMBER,
                                   P_TIPDOC    IN  NUMBER,
                                   P_NRODOC    IN  VARCHAR2,
                                   P_NOMCLI    IN  VARCHAR2,
                                   P_INSTANCIA IN  NUMBER,
                                   P_EMPRESA   IN  NUMBER,
                                   P_SUCURSAL  IN  NUMBER,
                                   P_MODULO    IN  NUMBER,
                                   P_MONEDA    IN  NUMBER,
                                   P_PAPEL     IN  NUMBER,
                                   P_CUENTA    IN  NUMBER,
                                   P_OPERACION IN  NUMBER,
                                   P_SUBOPER   IN  NUMBER,
                                   P_TIPOPER   IN  NUMBER,
                                   P_MNTOSOL   IN  NUMBER,
                                   P_ANALISTA  IN  VARCHAR2,
                                   P_ETPCRD    IN  NUMBER);
                                 
   ----------------------------------------------------------------------------------------------------
   PROCEDURE SP_CR_GRABAR_DETALLE(P_USUARIO   IN  VARCHAR2,
                                  P_NROCRD    IN  VARCHAR2,
                                  P_FECREG    IN  DATE,
                                  P_HORAREG   IN  VARCHAR2,
                                  P_NRODOC    IN  VARCHAR2,
                                  P_NOMCLI    IN  VARCHAR2,
                                  P_INSTANCIA IN  NUMBER,
                                  P_NOMSUC    IN  VARCHAR2,
                                  P_TASA      IN  NUMBER,
                                  P_MNTOCRG   IN  NUMBER,
                                  P_MNTOCAN   IN  NUMBER,
                                  P_CODASE    IN  VARCHAR2,
                                  P_LISTADO   IN  VARCHAR2,
                                  P_COMENT    IN  VARCHAR2,
                                  P_FECRG     IN  DATE,
                                  P_CODSBS    IN  VARCHAR2);
   
   ----------------------------------------------------------------------------------------------------
   PROCEDURE SP_CR_ACTUALIZAR_CABEC(P_USUARIO IN  VARCHAR2,
                                    P_FECREG  IN DATE,
                                    P_HORAREG IN VARCHAR2,
                                    P_NRODOC  IN  VARCHAR2,
                                    P_CODERR  OUT VARCHAR2,
                                    P_MSGERR  OUT VARCHAR2);
   
   ----------------------------------------------------------------------------------------------------
   PROCEDURE SP_CR_SOLI_ENVUELO(P_INSTANCIA IN  NUMBER,
                                P_EMPRESA   IN  NUMBER,
                                P_SUCURSAL  IN  NUMBER,
                                P_MODULO    IN  NUMBER,
                                P_MONEDA    IN  NUMBER,
                                P_PAPEL     IN  NUMBER,
                                P_CUENTA    IN  NUMBER,
                                P_OPERACION IN  NUMBER,
                                P_SUBOPER   IN  NUMBER,
                                P_TIPOPER   IN  NUMBER,
                                P_ENVUELO   OUT VARCHAR2);
   
   ----------------------------------------------------------------------------------------------------
   PROCEDURE SP_CR_OBTENER_SIGNOMDA(P_MONEDA IN  NUMBER,
                                    P_SIGMDA OUT VARCHAR2);
   ----------------------------------------------------------------------------------------------------
   PROCEDURE SP_CR_OBTENER_NOMCLI(P_PAISDOC IN  NUMBER,
                                  P_TIPDOC  IN  NUMBER,
                                  P_NRODOC  IN  VARCHAR2,
                                  P_NOMCLI  OUT VARCHAR2);
   
   ----------------------------------------------------------------------------------------------------
   PROCEDURE SP_CR_OBTENER_ETAPACRED(P_INSTANCIA IN  NUMBER,
                                     P_ETPCRD    OUT NUMBER,
                                     P_NOMETPCRD OUT VARCHAR2);
                                     
   ----------------------------------------------------------------------------------------------------                                  
   PROCEDURE SP_CR_VALIDAR_DISPONIBLE(P_NROCRD IN  VARCHAR2,
                                      P_ESTADO OUT VARCHAR2);
                                      
   ----------------------------------------------------------------------------------------------------                                   
   PROCEDURE SP_CR_OBTENER_MTOCAN(P_NROCRD IN  VARCHAR2,
                                  P_FECREG IN  DATE,
                                  P_HORAREG IN VARCHAR2,
                                  P_USUREG  IN VARCHAR2,
                                  P_MTOCAN OUT NUMBER);                                   
                        
   
END PQ_CR_CREDITOS_COMPART;
/

CREATE OR REPLACE PACKAGE BODY PQ_CR_CREDITOS_COMPART IS

   ----------------------------------------------------------------------------------------------------
   PROCEDURE SP_CR_GRABAR_CABECERA(P_USUARIO   IN  VARCHAR2,
                                   P_FECREG    IN  DATE,
                                   P_HORAREG   IN  VARCHAR2,
                                   P_PAISDOC   IN  NUMBER,
                                   P_TIPDOC    IN  NUMBER,
                                   P_NRODOC    IN  VARCHAR2,
                                   P_NOMCLI    IN  VARCHAR2,
                                   P_INSTANCIA IN  NUMBER,
                                   P_EMPRESA   IN  NUMBER,
                                   P_SUCURSAL  IN  NUMBER,
                                   P_MODULO    IN  NUMBER,
                                   P_MONEDA    IN  NUMBER,
                                   P_PAPEL     IN  NUMBER,
                                   P_CUENTA    IN  NUMBER,
                                   P_OPERACION IN  NUMBER,
                                   P_SUBOPER   IN  NUMBER,
                                   P_TIPOPER   IN  NUMBER,
                                   P_MNTOSOL   IN  NUMBER,
                                   P_ANALISTA  IN  VARCHAR2,
                                   P_ETPCRD    IN  NUMBER) IS
   
   ----------------------------------------------------------------------------------------------------
   -- NOMBRE                      : SP_CR_GRABAR_CABECERA
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 22/10/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- USO                         : GRABA LA CABECERA DE LOS CREDITOS BT
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   ----------------------------------------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   ----------------------------------------------------------------------------------------------------
   
      V_FECSYS DATE := NULL;
   BEGIN
      BEGIN 
         SELECT A1.PGFAPE
           INTO V_FECSYS
           FROM FST017 A1
          WHERE A1.PGCOD = 1;
      EXCEPTION
         WHEN OTHERS THEN
      	  NULL;
      END;
      
      BEGIN
         INSERT INTO AQPD402(AQPD402FREG,
                             AQPD402UREG,
                             AQPD402HREG,
                             AQPD402PAIS,
                             AQPD402TDOC,
                             AQPD402NDOC,
                             AQPD402NCLI,
                             AQPD402INST,
                             AQPD402EMP,
                             AQPD402SUC,
                             AQPD402MOD,
                             AQPD402MDA,
                             AQPD402PAP,
                             AQPD402CTA,
                             AQPD402OPER,
                             AQPD402SBOP,
                             AQPD402TPOP,
                             AQPD402MSOL,
                             AQPD402ANLS,
                             AQPD402ETCR,
                             AQPD402EST)
         VALUES(P_FECREG,
                P_USUARIO,
                P_HORAREG,
                P_PAISDOC,
                P_TIPDOC,
                P_NRODOC,
                P_NOMCLI,
                P_INSTANCIA,
                P_EMPRESA,
                P_SUCURSAL,
                P_MODULO,
                P_MONEDA,
                P_PAPEL,
                P_CUENTA,
                P_OPERACION,
                P_SUBOPER,
                P_TIPOPER,
                P_MNTOSOL,
                P_ANALISTA,
                P_ETPCRD,
                'P');
         COMMIT;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;   
      END;
   END SP_CR_GRABAR_CABECERA;
   
   ----------------------------------------------------------------------------------------------------
   PROCEDURE SP_CR_GRABAR_DETALLE(P_USUARIO   IN  VARCHAR2,
                                  P_NROCRD    IN  VARCHAR2,
                                  P_FECREG    IN  DATE,
                                  P_HORAREG   IN  VARCHAR2,
                                  P_NRODOC    IN  VARCHAR2,
                                  P_NOMCLI    IN  VARCHAR2,
                                  P_INSTANCIA IN  NUMBER,
                                  P_NOMSUC    IN  VARCHAR2,
                                  P_TASA      IN  NUMBER,
                                  P_MNTOCRG   IN  NUMBER,
                                  P_MNTOCAN   IN  NUMBER,
                                  P_CODASE    IN  VARCHAR2,
                                  P_LISTADO   IN  VARCHAR2,
                                  P_COMENT    IN  VARCHAR2,
                                  P_FECRG     IN  DATE,
                                  P_CODSBS    IN  VARCHAR2) IS
   
   ----------------------------------------------------------------------------------------------------
   -- NOMBRE                      : SP_CR_GRABAR_DETALLE
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 22/10/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- USO                         : GRABA EL DETALLE DE LOS CREDITOS DE OTRAS ENTIDADES
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   ----------------------------------------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 26/11/2024
   -- AUTOR DE LA MODIFICACION    : MAYCOL CHAVEZ CHUMAN
   -- DESCRIPCION DE MODIFICACION : SE AGREGO LOS SIGUIENTES PARAMETROS PARA EL INSERT:
   --                               - P_FECRG  | FECHA CARGA
   --                               - P_CODSBS | CODIGO SBS
   ----------------------------------------------------------------------------------------------------
   
   BEGIN
      BEGIN
         DELETE FROM AQPD403 A1
           WHERE A1.AQPD403NCRD = P_NROCRD
             AND A1.AQPD403FREG = P_FECREG
             AND A1.AQPD403UREG = P_USUARIO
             AND A1.AQPD403HREG = P_HORAREG;
         COMMIT;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
         
      BEGIN
         INSERT INTO AQPD403(AQPD403FREG,
                             AQPD403UREG,
                             AQPD403HREG,
                             AQPD403NDOC,
                             AQPD403NCLI,
                             AQPD403INST,
                             AQPD403NCRD,
                             AQPD403NSUC,
                             AQPD403TASA,
                             AQPD403MCRG,
                             AQPD403MCAN,
                             AQPD403ANLS,
                             AQPD403LIST,
                             AQPD403COMT,
                             AQPD403FECRG,
                             AQPD403CSBS)
         VALUES(P_FECREG,
                P_USUARIO,
                P_HORAREG,
                P_NRODOC,
                P_NOMCLI,
                P_INSTANCIA,
                P_NROCRD,
                P_NOMSUC,
                P_TASA,
                P_MNTOCRG,
                P_MNTOCAN,
                P_CODASE,
                P_LISTADO,
                P_COMENT,
                P_FECRG,
                P_CODSBS);
         COMMIT;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
        
   END SP_CR_GRABAR_DETALLE;
   
   ----------------------------------------------------------------------------------------------------
   PROCEDURE SP_CR_ACTUALIZAR_CABEC(P_USUARIO IN  VARCHAR2,
                                    P_FECREG  IN DATE,
                                    P_HORAREG IN VARCHAR2,
                                    P_NRODOC  IN  VARCHAR2,
                                    P_CODERR  OUT VARCHAR2,
                                    P_MSGERR  OUT VARCHAR2) IS
                                    
   ----------------------------------------------------------------------------------------------------
   -- NOMBRE                      : SP_CR_ACTUALIZAR_CABEC
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 22/10/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- USO                         : ACTUALIZA LA CABECERA DE LOS CREDITOS BT
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   ----------------------------------------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   ----------------------------------------------------------------------------------------------------                                  
                                    
      
      V_CONTA NUMBER(9) := 0;
      V_CONTB NUMBER(9) := 0;
      V_CODERR VARCHAR2(5) := '00000';
      V_MSGERR VARCHAR2(255) := 'Se grabó satisfactoriamente';
   BEGIN

      BEGIN
         SELECT COUNT(*)
           INTO V_CONTA
           FROM AQPB837 A1
          WHERE A1.AQPB837FEC = (SELECT TO_DATE(A2.TP1DESC, 'DD/MM/RRRR')
                                   FROM FST198 A2
                                  WHERE A2.TP1COD   = 1
                                    AND A2.TP1COD1  = 10847
                                    AND A2.TP1CORR1 = 906
                                    AND A2.TP1CORR2 =  1)
            AND A1.AQPB837NDOC = RPAD(P_NRODOC, 12, ' ');
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
      BEGIN
         SELECT COUNT(*)
           INTO V_CONTB
           FROM AQPD403 A1
          WHERE A1.AQPD403FREG = P_FECREG
            AND A1.AQPD403UREG = P_USUARIO
            AND A1.AQPD403HREG = P_HORAREG
            AND A1.AQPD403NDOC = P_NRODOC;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
      IF V_CONTA = V_CONTB THEN
         BEGIN
            UPDATE AQPD402 A1
               SET A1.AQPD402EST = 'S'
              WHERE A1.AQPD402FREG = P_FECREG
                AND A1.AQPD402UREG = P_USUARIO
                AND A1.AQPD402HREG = P_HORAREG
                AND A1.AQPD402EST  = 'P';
            COMMIT;
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
      ELSE
         V_CODERR := '90001';
         V_MSGERR := 'Completar el guardado de créditos de otras entidades';
      END IF;
      
      P_CODERR := V_CODERR;
      P_MSGERR := V_MSGERR;
      
   END SP_CR_ACTUALIZAR_CABEC;
   
   ---------------------------------------------------------------------------------------------------- 
   PROCEDURE SP_CR_SOLI_ENVUELO(P_INSTANCIA IN  NUMBER,
                                P_EMPRESA   IN  NUMBER,
                                P_SUCURSAL  IN  NUMBER,
                                P_MODULO    IN  NUMBER,
                                P_MONEDA    IN  NUMBER,
                                P_PAPEL     IN  NUMBER,
                                P_CUENTA    IN  NUMBER,
                                P_OPERACION IN  NUMBER,
                                P_SUBOPER   IN  NUMBER,
                                P_TIPOPER   IN  NUMBER,
                                P_ENVUELO   OUT VARCHAR2) IS
   
   ----------------------------------------------------------------------------------------------------
   -- NOMBRE                      : SP_CR_SOLI_ENVUELO
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 22/10/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- USO                         : VALIDA SI LA SOLICITUD SE ENCUENTRA EN VUELO
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   ----------------------------------------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   ----------------------------------------------------------------------------------------------------
                                
      V_ENVUELO VARCHAR2(1) := 'S';  
      V_CONT1    NUMBER(9)  := 0;
      V_CONT2    NUMBER(9)  := 0;             
   BEGIN
      BEGIN
         SELECT COUNT(1)
           INTO V_CONT1
           FROM FSD010 A2
          WHERE A2.PGCOD  = P_EMPRESA
            AND A2.AOMOD  = P_MODULO
            AND A2.AOSUC  = P_SUCURSAL
            AND A2.AOMDA  = P_MONEDA
            AND A2.AOPAP  = P_PAPEL
            AND A2.AOCTA  = P_CUENTA
            AND A2.AOOPER = P_OPERACION
            AND A2.AOSBOP = P_SUBOPER
            AND A2.AOTOPE = P_TIPOPER;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
      IF V_CONT1 = 0 THEN
         BEGIN
            SELECT COUNT(1)
              INTO V_CONT2
              FROM WFWRKITEMS A1
             WHERE A1.WFINSPRCID   = P_INSTANCIA
               AND A1.WFTASKCOD    = 55
               AND A1.WFITEMSTSACT = 1;
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
         
         IF V_CONT2 = 0 THEN
            V_ENVUELO := 'N';
         END IF;
      ELSE
         V_ENVUELO := 'N';
      END IF;
      
      P_ENVUELO := V_ENVUELO;
      
   END SP_CR_SOLI_ENVUELO;
   
   ----------------------------------------------------------------------------------------------------
   PROCEDURE SP_CR_OBTENER_SIGNOMDA(P_MONEDA IN  NUMBER,
                                    P_SIGMDA OUT VARCHAR2) IS
   
   ----------------------------------------------------------------------------------------------------
   -- NOMBRE                      : SP_CR_OBTENER_SIGNOMDA
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 22/10/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- USO                         : RETORNA EL SIGNO DE LA MONEDA
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   ----------------------------------------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   ----------------------------------------------------------------------------------------------------
                                    
      V_SIGMDA VARCHAR2(4) := NULL;                                 
   BEGIN
      BEGIN
         SELECT TRIM(A1.MOSIGN)
           INTO V_SIGMDA
           FROM FST005 A1
          WHERE A1.MONEDA = P_MONEDA;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
      P_SIGMDA := V_SIGMDA;
      
   END SP_CR_OBTENER_SIGNOMDA;
   
   ----------------------------------------------------------------------------------------------------
   PROCEDURE SP_CR_OBTENER_NOMCLI(P_PAISDOC IN  NUMBER,
                                  P_TIPDOC  IN  NUMBER,
                                  P_NRODOC  IN  VARCHAR2,
                                  P_NOMCLI  OUT VARCHAR2) IS
   ----------------------------------------------------------------------------------------------------
   -- NOMBRE                      : SP_CR_OBTENER_NOMCLI
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 22/10/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- USO                         : RETORNA EL NOMBRE DEL CLIENTE
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   ----------------------------------------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   ----------------------------------------------------------------------------------------------------
                                  
      V_NOMCLI VARCHAR2(35);                               
   BEGIN
      BEGIN
         SELECT TRIM(A1.PFAPE1) || ' ' || 
                TRIM(A1.PFAPE2) || ' ' ||
                TRIM(A1.PFNOM1) || ' ' || 
                TRIM(A1.PFNOM2)
           INTO V_NOMCLI
           FROM FSD002 A1
          WHERE A1.PFPAIS = P_PAISDOC
            AND A1.PFTDOC = P_TIPDOC
            AND A1.PFNDOC = RPAD(P_NRODOC, 12, ' ');
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
      P_NOMCLI := V_NOMCLI;
      
   END SP_CR_OBTENER_NOMCLI;
   
   ----------------------------------------------------------------------------------------------------
   PROCEDURE SP_CR_OBTENER_ETAPACRED(P_INSTANCIA IN  NUMBER,
                                     P_ETPCRD    OUT NUMBER,
                                     P_NOMETPCRD OUT VARCHAR2) IS
   
   ----------------------------------------------------------------------------------------------------
   -- NOMBRE                      : SP_CR_OBTENER_ETAPACRED
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 22/10/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- USO                         : RETORNA EL NOMBRE DE LA ETAPA DEL CREDITO
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   ----------------------------------------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 26/11/2024
   -- AUTOR DE LA MODIFICACION    : MAYCOL CHAVEZ CHUMAN
   -- DESCRIPCION DE MODIFICACION : SE AGREGO PARA QUE RETORNE LA ETAPA DEL CREDITO
   ----------------------------------------------------------------------------------------------------
      
      V_ETPCRD    NUMBER(4)    := 0;                              
      V_NOMETPCRD VARCHAR2(25) := NULL;                               
   BEGIN
      BEGIN
         SELECT A1.WFTASKCOD,
                SUBSTR(TRIM(B1.WFTASKNAME), 1, 25)
           INTO V_ETPCRD,
                V_NOMETPCRD
           FROM WFWRKITEMS A1, WFTASK B1
          WHERE A1.WFINSPRCID = P_INSTANCIA
            AND A1.WFTASKCOD  = (SELECT MAX(A2.WFTASKCOD)
                                   FROM WFWRKITEMS A2
                                  WHERE A2.WFINSPRCID = P_INSTANCIA)
            AND B1.WFPRCID   = 2
            AND B1.WFTASKCOD = A1.WFTASKCOD;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;   
      END;
      
      P_ETPCRD    := V_ETPCRD;
      P_NOMETPCRD := V_NOMETPCRD;
      
   END SP_CR_OBTENER_ETAPACRED;
   
   ----------------------------------------------------------------------------------------------------
   PROCEDURE SP_CR_VALIDAR_DISPONIBLE(P_NROCRD IN  VARCHAR2,
                                      P_ESTADO OUT VARCHAR2) IS
   
   ----------------------------------------------------------------------------------------------------
   -- NOMBRE                      : SP_CR_VALIDAR_DISPONIBLE
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 22/10/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- USO                         : VALIDA SI EL NRO. DEL CREDITO DE OTRAS ENTIDADES
   --                             : SE ENCUENTRA DISPONIBLE
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   ----------------------------------------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   ----------------------------------------------------------------------------------------------------                                   
                                      
      V_CONTADOR NUMBER(9) := 0;
      V_ESTADO   VARCHAR2(20) := NULL;                                  
   BEGIN
      BEGIN
         SELECT COUNT(*)
           INTO V_CONTADOR
           FROM AQPD402 A1, AQPD403 B1
          WHERE A1.AQPD402FREG = B1.AQPD403FREG
            AND A1.AQPD402UREG = B1.AQPD403UREG
            AND A1.AQPD402HREG = B1.AQPD403HREG
            AND B1.AQPD403NCRD = P_NROCRD
            AND A1.AQPD402EST  = 'S'
            AND EXISTS (SELECT 1
                           FROM FSD010 A2
                          WHERE A2.PGCOD  = A1.AQPD402EMP
                            AND A2.AOMOD  = A1.AQPD402MOD
                            AND A2.AOSUC  = A1.AQPD402SUC
                            AND A2.AOMDA  = A1.AQPD402MDA
                            AND A2.AOPAP  = A1.AQPD402PAP
                            AND A2.AOCTA  = A1.AQPD402CTA
                            AND A2.AOOPER = A1.AQPD402OPER
                            AND A2.AOSBOP = A1.AQPD402SBOP
                            AND A2.AOTOPE = A1.AQPD402TPOP);
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
      IF V_CONTADOR > 0 THEN
         V_ESTADO := 'No Disponible';
      Else
         V_ESTADO := 'Disponible';
      END IF;
      
      P_ESTADO := V_ESTADO;
      
   END SP_CR_VALIDAR_DISPONIBLE;
   
   PROCEDURE SP_CR_OBTENER_MTOCAN(P_NROCRD IN  VARCHAR2,
                                  P_FECREG IN  DATE,
                                  P_HORAREG IN VARCHAR2,
                                  P_USUREG  IN VARCHAR2,
                                  P_MTOCAN OUT NUMBER) IS
   ----------------------------------------------------------------------------------------------------
   -- NOMBRE                      : SP_CR_OBTENER_MTOCAN
   -- SISTEMA                     : BANTOTAL
   -- MODULO                      : CREDITOS - ACTIVAS
   -- VERSION                     : 1.0
   -- FECHA DE CREACION           : 22/10/2024
   -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
   -- USO                         : RETORNA EL MONTO CANCELADO
   -- ESTADO                      : ACTIVO
   -- ACCESO                      : PUBLICO
   ----------------------------------------------------------------------------------------------------
   -- FECHA DE MODIFICACION       : 
   -- AUTOR DE LA MODIFICACION    : 
   -- DESCRIPCION DE MODIFICACION : 
   ----------------------------------------------------------------------------------------------------                               
                                  
      V_MTOCAN NUMBER(17, 2) := 0;                                   
   BEGIN
      BEGIN
         SELECT A1.AQPD403MCAN
           INTO V_MTOCAN
           FROM AQPD403 A1
          WHERE A1.AQPD403NCRD = P_NROCRD
            AND A1.AQPD403FREG = P_FECREG
            AND A1.AQPD403UREG = P_USUREG
            AND A1.AQPD403HREG = P_HORAREG;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      
      P_MTOCAN := V_MTOCAN;
      
   END SP_CR_OBTENER_MTOCAN;

END PQ_CR_CREDITOS_COMPART;
/

