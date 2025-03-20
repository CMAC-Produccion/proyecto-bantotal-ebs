create or replace package pq_cr_refinanciacion_hs is
  
  -- *****************************************************************
-- Nombre   : pq_cr_refinanciacion_hs
-- Sistema    : BANTOTAL
-- Módulo   : Activas
-- Versión    : 1.0
-- Fecha de Creación  : 15/03/2024
-- Autor de Creación  : HSUAREZ
-- Uso      : Uso
-- Estado   : Activo
-- Acceso   : Público
-- *****************************************************************
  procedure sp_nro_refinanciaciones(ve_instancia number,vo_refinanciaciones out number);
  PROCEDURE SP_CONTAR_REFINANCIADOS(VE_INSTANCIA NUMBER,
                                      VE_CTA NUMBER,
                                      VE_OPER NUMBER,
                                      VE_SBOP NUMBER,
                                      VE_R011MO NUMBER,
                                      VE_R011SU NUMBER,
                                      VE_R011TR NUMBER,
                                      VE_R011RE NUMBER,
                                      VE_R011FC DATE, 
                                      VAR_CORRELATIVO NUMBER,
                                      VAR_FECHA DATE,
                                      VAR_HORA VARCHAR2,                                     
                                      VO_CONTEO OUT NUMBER                  
                                     );
  PROCEDURE SP_VALIDAR_TRANSACCION(
                                      VE_MOD NUMBER,
                                      VE_TRN NUMBER,
                                      VO_VTRN out VARCHAR
                                    ); 
                                    
  PROCEDURE SP_VALIDAR_REFINANCIADOS(
                                      ve_instancia number,
                                      vo_refinanciaciones out number    
                                    );                                    
end pq_cr_refinanciacion_hs;
/

create or replace package body pq_cr_refinanciacion_hs is
-- *****************************************************************
-- Nombre                       : pq_cr_refinanciacion_hs
-- Sistema                      : BANTOTAL
-- Módulo                       : Activas
-- Versión                      : 1.0
-- Fecha de Creación            : 15/03/2023
-- Autor de Creación            : Milton Cordova
-- Uso                          : Uso
-- Estado                       : Activo
-- Acceso                       : Público
-- Parámetros de Entrada        : ve_instancia, vo_refinanciaciones
-- Retorno                      : 
--------------------------------------------------------------------
-- Fecha de Modificación  : 
-- Autor de la Modificación : 
-- Descripción de Modificación  : 
-- *****************************************************************
    procedure sp_nro_refinanciaciones(ve_instancia number,vo_refinanciaciones out number) is
     VI_PGCOD XWF700.XWFEMPRESA%TYPE;
     VI_SUC XWF700.XWFSUCURSAL%TYPE;
     VI_MOD XWF700.XWFMODULO%TYPE;
     VI_MDA XWF700.XWFMONEDA%TYPE;
     VI_PAP XWF700.XWFPAPEL%TYPE;
     VI_CTA XWF700.XWFCUENTA%TYPE;
     VI_OPE XWF700.XWFOPERACION%TYPE;
     VI_SBO XWF700.XWFSUBOPE%TYPE;
     VI_TOP XWF700.XWFTIPOPE%TYPE;
     --VI_INSTANCIA_MAX number(9);
     VI_CONTEO number(9);
     VO_CONTEO number(9);
     VI_CTAV number(9);
     vi_opev number(9);
     VI_SBOPV NUMBER(3);
     VO_VTRANS VARCHAR(3);
     VI_CONTADOR NUMBER(3);
     
     VI_R011MOV FSR011.R011MO%TYPE;
     VI_R011SUV FSR011.R011SU%TYPE;
     VI_R011TRV FSR011.R011TR%TYPE;
     VI_R011REV FSR011.R011RE%TYPE;
     VI_R011FCV FSR011.R011FC%TYPE;
     VAR_CORRELATIVO NUMBER(17,0);
     VAR_CORRELATIVO2 NUMBER(17,0);
     VAR_FECHA DATE;
     VAR_HORA VARCHAR2(8);
     CURSOR CREDITOSREFINANCIADOS IS
     SELECT * FROM XWF700
     WHERE XWFPRCINS =  ve_instancia
     AND XWFCAR3<>'1'; 
        
    begin
           VI_CONTEO := 0;
           VO_CONTEO := 0;         
           VAR_FECHA := TO_DATE(SYSDATE, 'DD/MM/YYYY');
           VAR_HORA := TO_CHAR(SYSDATE, 'HH24:MI:SS');
           SELECT NVL(MAX(AQPC211COR), 0) + 1 INTO VAR_CORRELATIVO FROM AQPC211;
           --obtener la instancia en vuelo
           begin
               SELECT X.XWFEMPRESA,X.XWFSUCURSAL,X.XWFMODULO,X.XWFMONEDA,X.XWFPAPEL,X.XWFCUENTA,X.XWFOPERACION,X.XWFSUBOPE,X.XWFTIPOPE
                 INTO VI_PGCOD,VI_SUC,VI_MOD,VI_MDA,VI_PAP,VI_CTA,VI_OPE,VI_SBO,VI_TOP
               FROM XWF700 X
               WHERE X.XWFPRCINS = ve_instancia
                AND XWFCAR3 = '1';
           EXCEPTION
                WHEN OTHERS THEN
                  NULL;
           END;
           --INICIAR CONTADOR CON LA INSTANCIA EN VUELO QUE SE VA A REFINANCIAR
           BEGIN    
               SELECT NVL(MAX(AQPC211CO2), 0) + 1 INTO VAR_CORRELATIVO2 FROM AQPC211 
               WHERE AQPC211FEC = VAR_FECHA AND AQPC211HOR = VAR_HORA AND AQPC211INS = ve_instancia AND AQPC211COR = VAR_CORRELATIVO;
                   
               INSERT INTO AQPC211 (AQPC211COR,AQPC211CO2,AQPC211FEC,AQPC211HOR,AQPC211INS,AQPC211CTA,AQPC211OPE,AQPC211SBO,AQPC211MOD,AQPC211SUC,AQPC211TRN,AQPC211REL,AQPC211FCH)
               VALUES(VAR_CORRELATIVO,VAR_CORRELATIVO2,VAR_FECHA, VAR_HORA,VE_INSTANCIA,VI_CTA,VI_OPE,VI_SBO,0,0,0,0,VAR_FECHA);
               COMMIT;
            EXCEPTION
               WHEN OTHERS THEN
               NULL;
           END; 
           --OBTENER EL CREDITO CON LA CUENTA Y OPERACION, de la instancia anterior
           FOR I IN CREDITOSREFINANCIADOS LOOP
               --OBTENER LA CUENTA Y OPERACION DEL CREDITO REFINANCIADO VINCULADO
               VI_CONTADOR := 0;
               BEGIN
                    SELECT R2CTA,R2OPER,R2SBOP,R011MO,R011SU,R011TR,R011RE,R011FC
                      INTO VI_CTAV,VI_OPEV,VI_SBOPV,VI_R011MOV,VI_R011SUV,VI_R011TRV,VI_R011REV,VI_R011FCV
                      FROM FSR011
                     WHERE R1CTA  = I.XWFCUENTA
                       AND R1OPER = I.XWFOPERACION
                       AND R1SBOP = I.XWFSUBOPE
                       AND R1TOPE = I.XWFTIPOPE
                       AND RELCOD = 120 /*CODIGO PARA REFINANCIACIONES*/
                       AND R011CO = 'S'
                       AND R1MOD  IN (select modulo from fst111 where dscod=50 and modulo>99 and modulo<200);
                       
                       PQ_CR_REFINANCIACION_HS.SP_VALIDAR_TRANSACCION(VI_R011MOV,VI_R011TRV,VO_VTRANS);
                       IF VO_VTRANS = 'S' THEN
                         VI_CONTADOR := VI_CONTADOR + 1;
                         --crear tabla log
                         SELECT NVL(MAX(AQPC211CO2), 0) + 1 INTO VAR_CORRELATIVO2 FROM AQPC211 
                         WHERE AQPC211FEC = VAR_FECHA AND AQPC211HOR = VAR_HORA AND AQPC211INS = ve_instancia AND AQPC211COR = VAR_CORRELATIVO;
                         INSERT INTO AQPC211 (AQPC211COR,AQPC211CO2,AQPC211FEC,AQPC211HOR,AQPC211INS,AQPC211CTA,AQPC211OPE,AQPC211SBO,AQPC211MOD,AQPC211SUC,AQPC211TRN,AQPC211REL,AQPC211FCH)
                         VALUES(VAR_CORRELATIVO,VAR_CORRELATIVO2,VAR_FECHA, VAR_HORA,VE_INSTANCIA, I.XWFCUENTA,I.XWFOPERACION,I.XWFSUBOPE,VI_R011MOV,VI_R011SUV,VI_R011TRV,VI_R011REV,VI_R011FCV);
                        
                         COMMIT;
                         VO_VTRANS := 'N';
                       END IF;
                       
               EXCEPTION
                 WHEN OTHERS THEN
                     VI_CTAV:= 0;VI_OPEV:=0;
               END;
               --BUSCAR MAS REFINANCIACIONES POR CREDITO VINCULADO,  QUEDARSE CON EL CONTEO MAYOR.
               PQ_CR_REFINANCIACION_HS.SP_CONTAR_REFINANCIADOS
               (VE_INSTANCIA,VI_CTAV,VI_OPEV,VI_SBOPV,VI_R011MOV,VI_R011SUV,VI_R011TRV,VI_R011REV,VI_R011FCV,VAR_CORRELATIVO,VAR_FECHA,VAR_HORA,VO_CONTEO);
               
               IF VO_CONTEO > VI_CONTEO THEN
                  VI_CONTEO := VO_CONTEO;
               END IF;                
           END LOOP;
           vo_refinanciaciones := VI_CONTEO + 1 + VI_CONTADOR;
    EXCEPTION
           WHEN OTHERS THEN
           NULL;       
    end;
    PROCEDURE SP_CONTAR_REFINANCIADOS(VE_INSTANCIA NUMBER,
                                      VE_CTA NUMBER,
                                      VE_OPER NUMBER,
                                      VE_SBOP NUMBER,
                                      VE_R011MO NUMBER,
                                      VE_R011SU NUMBER,
                                      VE_R011TR NUMBER,
                                      VE_R011RE NUMBER,
                                      VE_R011FC DATE, 
                                      VAR_CORRELATIVO NUMBER,
                                      VAR_FECHA DATE,
                                      VAR_HORA VARCHAR2,                                
                                      VO_CONTEO OUT NUMBER                  
                                     ) IS
-- *****************************************************************
-- Nombre                       : SP_CONTAR_REFINANCIADOS
-- Sistema                      : BANTOTAL
-- Módulo                       : Activas
-- Versión                      : 1.0
-- Fecha de Creación            : 15/03/2023
-- Autor de Creación            : HSUAREZ
-- Uso                          : Uso
-- Estado                       : Activo
-- Acceso                       : Público
-- Parámetros de Entrada        : 
-- Retorno                      : 
--------------------------------------------------------------------
-- Fecha de Modificación  : 
-- Autor de la Modificación : 
-- Descripción de Modificación  : 
-- *****************************************************************
    vi_ctav NUMBER(9);
    vi_opev number(9);
    VI_SBOPV NUMBER(3);
    
    vi_ctav2 NUMBER(9);
    vi_opev2 number(9);
    VI_SBOPV2 NUMBER(3);
    
    VI_R011MOV FSR011.R011MO%TYPE;
    VI_R011SUV FSR011.R011SU%TYPE;
    VI_R011TRV FSR011.R011TR%TYPE;
    VI_R011REV FSR011.R011RE%TYPE;
    VI_R011FCV FSR011.R011FC%TYPE;
    
    VI_R011MOV2 FSR011.R011MO%TYPE;
    VI_R011SUV2 FSR011.R011SU%TYPE;
    VI_R011TRV2 FSR011.R011TR%TYPE;
    VI_R011REV2 FSR011.R011RE%TYPE;
    VI_R011FCV2 FSR011.R011FC%TYPE;
    VI_CONTADOR NUMBER(3);
    VO_VTRANS varchar(3);
    VAR_CORRELATIVO2 NUMBER(17,0);
    CURSOR LISTA_TRANSACCIONES IS
    SELECT * FROM FST198
           WHERE TP1COD   = 1
             AND TP1COD1  = 11163
             and tp1corr1 = 1
             and tp1corr2 = 0
             and tp1corr3 > 0
             and tp1nro1  = 1;
    
    BEGIN
    VO_CONTEO := 0;
            
    VI_CTAV   := VE_CTA;
    vi_opev   := VE_OPER;
    VI_SBOPV  := VE_SBOP;
                 
    VI_R011MOV := VE_R011MO;
    VI_R011SUV := VE_R011SU;
    VI_R011TRV := VE_R011TR;
    VI_R011REV := VE_R011RE;
    VI_R011FCV := VE_R011FC;
             
    vi_ctav2:= vi_ctav; 
    vi_opev2:= vi_opev;
    VI_CONTADOR := 0;        
        WHILE VI_CTAV2 > 0 AND VI_OPEV2 > 0 LOOP
           BEGIN
             vi_ctav2 := 0;
             vi_opev2 := 0;
             VI_SBOPV2:= 0;
             FOR X IN LISTA_TRANSACCIONES LOOP
               BEGIN
               SELECT R2CTA, R2OPER,R2SBOP,R011MO,R011SU,R011TR,R011RE,R011FC
                 INTO VI_CTAV2, VI_OPEV2,VI_SBOPV2,VI_R011MOV2,VI_R011SUV2,VI_R011TRV2,VI_R011REV2,VI_R011FCV2
                 from fsr011 r
                WHERE R1CTA = VI_CTAV
                  AND R1OPER = VI_OPEV
                  AND R1SBOP = VI_SBOPV
                  AND RELCOD = 120 /*CODIGO PARA REFINANCIACIONES*/                
                  AND R011MO = X.TP1NRO2
                  AND R011TR = X.TP1NRO3
                  AND R011CO = 'S'
                  AND R1MOD  IN (select modulo from fst111 where dscod=50 and modulo>99 and modulo<200);
                  EXIT;
               EXCEPTION
                 WHEN OTHERS THEN
                   --FOR Y IN LISTA_TRANSACCIONES LOOP
                   BEGIN
                    SELECT R2CTA, R2OPER,R2SBOP,R011MO,R011SU,R011TR,R011RE,R011FC
                      INTO VI_CTAV2, VI_OPEV2,VI_SBOPV2,VI_R011MOV2,VI_R011SUV2,VI_R011TRV2,VI_R011REV2,VI_R011FCV2
                      from fsr011 r
                    WHERE R1CTA = VI_CTAV
                      AND R1OPER = VI_OPEV
                      AND R1SBOP = (SELECT MAX(R1SBOP) FROM FSR011 WHERE  R1CTA = VI_CTAV AND R1OPER =  VI_OPEV AND R1SBOP < VI_SBOPV AND RELCOD = 120 AND R011CO = 'S' AND R1MOD  IN (select modulo from fst111 where dscod=50 and modulo>99 and modulo<200) AND R011MO=X.TP1NRO2 AND R011TR=X.TP1NRO3)
                      AND RELCOD = 120 /*CODIGO PARA REFINANCIACIONES*/                
                      AND R011MO = X.TP1NRO2
                      AND R011TR = X.TP1NRO3
                      AND R011CO = 'S'
                      AND R1MOD  IN (select modulo from fst111 where dscod=50 and modulo>99 and modulo<200);  
                   EXCEPTION
                     when others then
                      exit;   
                   END;    
                   --END LOOP;   
               END;
             END LOOP;     
              
             BEGIN  
             IF VI_R011MOV<> VI_R011MOV2 OR VI_R011SUV<>VI_R011SUV2 OR VI_R011TRV<>VI_R011TRV2 OR VI_R011REV<>VI_R011REV2 OR VI_R011FCV<>VI_R011FCV2 THEN 
                PQ_CR_REFINANCIACION_HS.SP_VALIDAR_TRANSACCION(VI_R011MOV,VI_R011TRV,VO_VTRANS);
                IF VO_VTRANS = 'S' THEN
                   VI_CONTADOR := VI_CONTADOR + 1;
                   --crear tabla log
                   SELECT NVL(MAX(AQPC211CO2), 0) + 1 INTO VAR_CORRELATIVO2 FROM AQPC211 
                   WHERE AQPC211FEC = VAR_FECHA AND AQPC211HOR = VAR_HORA AND AQPC211INS = ve_instancia AND AQPC211COR = VAR_CORRELATIVO;
                   INSERT INTO AQPC211 (AQPC211COR,AQPC211CO2,AQPC211FEC,AQPC211HOR,AQPC211INS,AQPC211CTA,AQPC211OPE,AQPC211SBO,AQPC211MOD,AQPC211SUC,AQPC211TRN,AQPC211REL,AQPC211FCH)
                   VALUES(VAR_CORRELATIVO,VAR_CORRELATIVO2,VAR_FECHA, VAR_HORA,VE_INSTANCIA,VI_CTAV,VI_OPEV,VI_SBOPV,VI_R011MOV2,VI_R011SUV2,VI_R011TRV2,VI_R011REV2,VI_R011FCV2);
                   COMMIT;
                   VO_VTRANS := 'N';
                END IF;
             END IF;  
             
             VI_CTAV   := VI_CTAV2;
             vi_opev   := VI_OPEV2;
             VI_SBOPV  := VI_SBOPV2;
             VI_R011MOV := VI_R011MOV2;
             VI_R011SUV := VI_R011SUV2;
             VI_R011TRV := VI_R011TRV2;
             VI_R011REV := VI_R011REV2;
             VI_R011FCV := VI_R011FCV2;
             EXCEPTION
                 when others then
                  exit;   
               END;
           EXCEPTION
                 WHEN OTHERS THEN
                     VI_CTAV:= 0;VI_OPEV:=0;VI_SBOPV:=0; 
           END;
        END LOOP;
        VO_CONTEO := VI_CONTADOR ;
    END; 
    
    
    PROCEDURE SP_VALIDAR_TRANSACCION(
                                      VE_MOD NUMBER,
                                      VE_TRN NUMBER,
                                      VO_VTRN  out VARCHAR
                                    )  IS
-- *****************************************************************
-- Nombre                       : SP_VALIDAR_TRANSACCION
-- Sistema                      : BANTOTAL
-- Módulo                       : Activas
-- Versión                      : 1.0
-- Fecha de Creación            : 15/03/2023
-- Autor de Creación            : HSUAREZ
-- Uso                          : Uso
-- Estado                       : Activo
-- Acceso                       : Público
-- Parámetros de Entrada        : 
-- Retorno                      : 
--------------------------------------------------------------------
-- Fecha de Modificación  : 
-- Autor de la Modificación : 
-- Descripción de Modificación  : 
-- *****************************************************************                                    
    vi_contador number;                                    
    BEGIN
         BEGIN
           SELECT count(*)
           into vi_contador
           FROM FST198
           WHERE TP1COD   = 1
             AND TP1COD1  = 11163
             and tp1corr1 = 1
             and tp1corr2 = 0
             and tp1corr3 > 0
             and tp1nro1  = 1
             and tp1nro2  = ve_mod
             and tp1nro3  = ve_trn;
         EXCEPTION
           WHEN OTHERS THEN
             VI_CONTADOR := 0;   
         END;    
         IF VI_CONTADOR > 0 THEN
            VO_VTRN := 'S';
         ELSE
            VO_VTRN := 'N';
         END IF;  
    END;  
    PROCEDURE SP_VALIDAR_REFINANCIADOS(
                                      ve_instancia number,
                                      vo_refinanciaciones out number    
                                    )IS
    
    CURSOR LISTAR_CUENTAS( 
                           VI_PAIS NUMBER,
                           VI_PETDOC NUMBER,
                           VI_PENDOC CHAR
                         )IS
 -- *****************************************************************
-- Nombre                       : LISTAR_CUENTAS
-- Sistema                      : BANTOTAL
-- Módulo                       : Activas
-- Versión                      : 1.0
-- Fecha de Creación            : 15/03/2023
-- Autor de Creación            : Milton Cordova
-- Uso                          : Uso
-- Estado                       : Activo
-- Acceso                       : Público
-- Parámetros de Entrada        : 
-- Retorno                      : 
--------------------------------------------------------------------
-- Fecha de Modificación  : 
-- Autor de la Modificación : 
-- Descripción de Modificación  : 
-- *****************************************************************                        
    SELECT * FROM
    FSR008
    WHERE PEPAIS = VI_PAIS
      AND PETDOC = VI_PETDOC
      AND PENDOC = VI_PENDOC
      AND TTCOD  = 1
      AND CTTFIR = 'T';
      
    CURSOR LISTAR_CRD_CTA(
                          VI_CTNRO NUMBER
                         )IS
    SELECT * FROM 
    FSD010 F 
    WHERE F.PGCOD = 1
      AND F.AOCTA = VI_CTNRO
      AND F.AOMOD IN (SELECT MODULO FROM FST111 WHERE DSCOD=50 AND MODULO>100 AND MODULO<200)
      AND F.AOSTAT<>99;
    
    CURSOR VALIDAR_CREDITOS(V_EMP NUMBER,
                           V_SUC NUMBER,
                           V_MOD NUMBER,
                           V_MDA NUMBER,
                           V_PAP NUMBER,
                           V_CTA NUMBER,
                           V_OPE NUMBER,
                           V_SBO NUMBER,
                           V_TOP NUMBER) IS
     SELECT * FROM XWF700 X
     WHERE X.XWFEMPRESA   = V_EMP
       AND X.XWFSUCURSAL  = V_SUC 
       AND X.XWFMODULO    = V_MOD
       AND X.XWFMONEDA    = V_MDA
       AND X.XWFPAPEL     = V_PAP
       AND X.XWFCUENTA    = V_CTA
       AND X.XWFOPERACION = V_OPE
       AND X.XWFSUBOPE    = V_SBO
       AND X.XWFTIPOPE    = V_TOP
       AND XWFCAR3='1';
    --VI_NREFINANCIADO number(9);
    VI_PAIS   fsr008.pepais%type;
    VI_PTDOC  fsr008.petdoc%type;
    VI_PENDOC fsr008.pendoc%type;
    VI_CTA    fsr008.ctnro%type;
    vi_cantidad number(9);
    BEGIN
         --Obtener la cuenta 
         BEGIN
           SELECT X.XWFCUENTA INTO VI_CTA FROM XWF700 X
           WHERE X.XWFPRCINS = VE_INSTANCIA
             AND X.XWFCAR3 = '1';
         EXCEPTION
           WHEN OTHERS THEN
             NULL;
         END;
         --Obtener el DNI
         BEGIN
           SELECT X.PEPAIS,X.PETDOC,X.PENDOC INTO VI_PAIS,VI_PTDOC,VI_PENDOC FROM FSR008 X
           WHERE X.CTNRO  = VI_CTA
             AND X.TTCOD  = 1
             AND X.CTTFIR = 'T'; 
         EXCEPTION
           WHEN OTHERS THEN
             NULL;
         END;
             --VI_NREFINANCIADO := 0;
             FOR X IN LISTAR_CUENTAS(VI_PAIS,VI_PTDOC,VI_PENDOC) LOOP
                 FOR Y IN LISTAR_CRD_CTA(X.CTNRO) LOOP
                     FOR Z IN VALIDAR_CREDITOS(Y.PGCOD,Y.AOSUC,Y.AOMOD,Y.AOMDA,Y.AOPAP,Y.AOCTA,Y.AOOPER,Y.AOSBOP,Y.AOTOPE) LOOP
                         --Obtener las cuentas asociadas del DNI
                         vi_cantidad := 0;
                         BEGIN
                             select count(*)
                               INTO vi_cantidad
                               from sng001
                              where sng001ori = 3
                                and sng001inst = Z.XWFPRCINS;
                         EXCEPTION
                           WHEN OTHERS THEN
                             NULL;
                         END;
                         vo_refinanciaciones := nvl(vo_refinanciaciones,0) + nvl(vi_cantidad,0);
                     END LOOP;
                 END LOOP;
             END LOOP;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;       
    END;                                                                      
end pq_cr_refinanciacion_hs;
/

