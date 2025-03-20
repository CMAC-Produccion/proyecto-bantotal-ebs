CREATE OR REPLACE PACKAGE PQ_CR_CREDITOS_REPROGRAMADOS IS

   PROCEDURE SP_CR_VALIDAR_UNILATERAL(P_EMPRESA              IN  NUMBER,
                                      P_SUCURSAL_TRANSACCION IN  NUMBER,
                                      P_MODULO_TRANSACCION   IN  NUMBER,
                                      P_NRO_TRANSACCION      IN  NUMBER,
                                      P_NRO_RELACION         IN  NUMBER,
                                      P_ORDINAL              IN  NUMBER,
                                      P_USUARIO              IN  VARCHAR2,
                                      P_RESPUESTA            OUT VARCHAR2);

   PROCEDURE SP_CR_REPORTE_CAMBIO_ESTADO(P_USUARIO      IN VARCHAR2,
                                         P_SUCURSAL     IN NUMBER,
                                         P_FECHA_INICIO IN DATE,
                                         P_FECHA_FIN    IN DATE);

END PQ_CR_CREDITOS_REPROGRAMADOS;
/

CREATE OR REPLACE PACKAGE BODY PQ_CR_CREDITOS_REPROGRAMADOS IS

  PROCEDURE SP_CR_VALIDAR_UNILATERAL(P_EMPRESA              IN  NUMBER,
                                     P_SUCURSAL_TRANSACCION IN  NUMBER,
                                     P_MODULO_TRANSACCION   IN  NUMBER,
                                     P_NRO_TRANSACCION      IN  NUMBER,
                                     P_NRO_RELACION         IN  NUMBER,
                                     P_ORDINAL              IN  NUMBER,
                                     P_USUARIO              IN  VARCHAR2,
                                     P_RESPUESTA            OUT VARCHAR2) IS
      
      V_CODIGO_ERROR                  NUMBER(5);
      V_MENSAJE_ERROR                 VARCHAR2(250);
      V_EMPRESA                       NUMBER(3);
      V_MODULO                        NUMBER(3);
      V_SUCURSAL                      NUMBER(3);
      V_MONEDA                        NUMBER(4);
      V_PAPEL                         NUMBER(4);
      V_CUENTA                        NUMBER(9);
      V_OPERACION                     NUMBER(9);
      V_SUBOPERACION                  NUMBER(3);
      V_TIPO_OPERACION                NUMBER(3);
      V_FECHA_REPROGRAMACION_JAQA400  DATE;
      V_ESTADO_REPROGRAMACION_JAQA400 VARCHAR2(1);
      V_FECHA_REPROGRAMACION_JAQZ698  DATE;
      V_ESTADO_REPROGRAMACION_JAQZ698 VARCHAR2(1);
      V_CODIGO_GERENTE                VARCHAR2(30);
      V_NOMBRE_GERENTE                VARCHAR2(30);
      V_CODIGO_ANALISTA               VARCHAR2(30);
      V_NOMBRE_ANALISTA               VARCHAR2(30);
      V_MENSAJE_ALERTA                LONG;
      V_FECHA_APERTURA                DATE;
      V_HORA_SISTEMA                  VARCHAR2(8);
      V_ENVIAR_EMAIL                  NUMBER(9);
      V_CORREO_GERENTE                VARCHAR2(40);
      V_CORREO_ANALISTA               VARCHAR2(40);
      V_NOMBRE_CLIENTE                VARCHAR2(35);
      V_NOMBRE_MODULO                 VARCHAR2(30);
      V_NOMBRE_TIPO_OPERACION         VARCHAR2(30);
      V_NOMBRE_SUCURSAL               VARCHAR2(30);
      V_EMISOR                        VARCHAR2(40);
      V_ASUNTO                        VARCHAR2(100);
      V_CUERPO_MENSAJE                LONG;
      V_CODIGO_ERROR_ENVIO            VARCHAR2(5);
      V_MENSAJE_ERROR_ENVIO           VARCHAR2(250);
      V_SQLERRM                       VARCHAR2(250);  
      V_SQLCODE                       NUMBER(10);
      
   BEGIN
      BEGIN
         SELECT PGFAPE, TRIM(TO_CHAR(SYSDATE, 'HH24:MI:SS'))
         INTO V_FECHA_APERTURA, V_HORA_SISTEMA
         FROM FST017
         WHERE PGCOD = P_EMPRESA;
      EXCEPTION
         WHEN OTHERS THEN
            V_FECHA_APERTURA := NULL;
            V_HORA_SISTEMA   := NULL;
      END;
      V_CODIGO_ERROR  := 0;
      V_MENSAJE_ERROR := 'Ok';
      BEGIN
         SELECT PGCOD, MODULO, ITSUCD, MONEDA, PAPEL, CTNRO, ITOPER,
                ITSUBO, ITTOPE
           INTO V_EMPRESA, V_MODULO, V_SUCURSAL,
                V_MONEDA, V_PAPEL, V_CUENTA, V_OPERACION, V_SUBOPERACION,
                V_TIPO_OPERACION
           FROM FSD016
          WHERE PGCOD  = P_EMPRESA
            AND ITSUC  = P_SUCURSAL_TRANSACCION
            AND ITMOD  = P_MODULO_TRANSACCION
            AND ITTRAN = P_NRO_TRANSACCION
            AND ITNREL = P_NRO_RELACION
            AND ITORD  = P_ORDINAL;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            V_CODIGO_ERROR  := 1;
            V_MENSAJE_ERROR := 'La Transacción y Módulo '||P_NRO_TRANSACCION||'/'||P_MODULO_TRANSACCION||' con Nro. de Relación '||P_NRO_RELACION||' no existe';
         WHEN OTHERS THEN
            V_CODIGO_ERROR  := 99;
            V_MENSAJE_ERROR := TRIM(REPLACE(TRIM(SQLERRM), 'ORA'||SQLCODE||': ', ''));
      END;
      IF V_CODIGO_ERROR = 0 THEN
         BEGIN
            SELECT JAQA400FEC, TRIM(JAQA400AC1)
              INTO V_FECHA_REPROGRAMACION_JAQA400, V_ESTADO_REPROGRAMACION_JAQA400
              FROM JAQA400
             WHERE JAQA400EMP = V_EMPRESA
               AND JAQA400MOD = V_MODULO
               AND JAQA400SUC = V_SUCURSAL
               AND JAQA400MDA = V_MONEDA
               AND JAQA400PAP = V_PAPEL
               AND JAQA400CTA = V_CUENTA
               AND JAQA400OPE = V_OPERACION
               AND JAQA400SBO = V_SUBOPERACION
               AND JAQA400TOP = V_TIPO_OPERACION
               AND JAQA400EST = 'C'
               AND JAQA400FEC = (SELECT MAX(JAQA400FEC)
                                   FROM JAQA400
                                  WHERE JAQA400EMP = V_EMPRESA
                                    AND JAQA400MOD = V_MODULO
                                    AND JAQA400SUC = V_SUCURSAL
                                    AND JAQA400MDA = V_MONEDA
                                    AND JAQA400PAP = V_PAPEL
                                    AND JAQA400CTA = V_CUENTA
                                    AND JAQA400OPE = V_OPERACION
                                    AND JAQA400SBO = V_SUBOPERACION
                                    AND JAQA400TOP = V_TIPO_OPERACION
                                    AND JAQA400EST = 'C');
         EXCEPTION
            WHEN OTHERS THEN
               V_FECHA_REPROGRAMACION_JAQA400  := NULL;
               V_ESTADO_REPROGRAMACION_JAQA400 := NULL;
         END;
         BEGIN
            SELECT JAQZ698FEP, TRIM(TO_CHAR(JAQZ698NU2))
              INTO V_FECHA_REPROGRAMACION_JAQZ698, V_ESTADO_REPROGRAMACION_JAQZ698
              FROM JAQZ698
             WHERE JAQZ698EMP = V_EMPRESA
               AND JAQZ698MOD = V_MODULO
               AND JAQZ698SUC = V_SUCURSAL
               AND JAQZ698MDA = V_MONEDA
               AND JAQZ698PAP = V_PAPEL
               AND JAQZ698CTA = V_CUENTA
               AND JAQZ698OPE = V_OPERACION
               AND JAQZ698SBO = V_SUBOPERACION
               AND JAQZ698TOP = V_TIPO_OPERACION
               AND JAQZ698EST = 'C'
               AND JAQZ698FEP = (SELECT MAX(JAQZ698FEP)
                                   FROM JAQZ698
                                  WHERE JAQZ698EMP = V_EMPRESA
                                    AND JAQZ698MOD = V_MODULO
                                    AND JAQZ698SUC = V_SUCURSAL
                                    AND JAQZ698MDA = V_MONEDA
                                    AND JAQZ698PAP = V_PAPEL
                                    AND JAQZ698CTA = V_CUENTA
                                    AND JAQZ698OPE = V_OPERACION
                                    AND JAQZ698SBO = V_SUBOPERACION
                                    AND JAQZ698TOP = V_TIPO_OPERACION
                                    AND JAQZ698EST = 'C');
         EXCEPTION
            WHEN OTHERS THEN
               V_FECHA_REPROGRAMACION_JAQZ698  := NULL;
               V_ESTADO_REPROGRAMACION_JAQZ698 := NULL;
         END;
      END IF;
      BEGIN
         SELECT TRIM(C.UBUSER), TRIM(C.UBNOM)
           INTO V_CODIGO_GERENTE, V_NOMBRE_GERENTE
           FROM SNG057 A, FST046 B, FST746 C
          WHERE A.SNG057USR = B.UBUSER
            AND A.SNG055CAR = 202
            AND B.UBSUC     = V_SUCURSAL
            AND C.UBUSER    = B.UBUSER
            AND ROWNUM      = 1;
      EXCEPTION
         WHEN OTHERS THEN
            V_CODIGO_GERENTE := NULL;
            V_NOMBRE_GERENTE := NULL;
      END;
      BEGIN
         SELECT TRIM(C.UBUSER), TRIM(C.UBNOM)
           INTO V_CODIGO_ANALISTA, V_NOMBRE_ANALISTA
           FROM XWF700 A, SNG001 B, FST746 C
          WHERE A.XWFEMPRESA   = V_EMPRESA
            AND A.XWFSUCURSAL  = V_MODULO
            AND A.XWFMODULO    = V_SUCURSAL
            AND A.XWFMONEDA    = V_MONEDA
            AND A.XWFPAPEL     = V_PAPEL
            AND A.XWFCUENTA    = V_CUENTA
            AND A.XWFOPERACION = V_OPERACION
            AND A.XWFSUBOPE    = V_SUBOPERACION
            AND A.XWFTIPOPE    = V_TIPO_OPERACION
            AND A.XWFCAR3      = '1'
            AND B.SNG001INST   = A.XWFPRCINS
            AND C.UBUSER       = B.SNG001ASE
            AND ROWNUM         = 1;
      EXCEPTION
         WHEN OTHERS THEN
            V_CODIGO_ANALISTA := NULL;
            V_NOMBRE_ANALISTA := NULL;
      END;
      BEGIN
         SELECT TRIM(AQPC714DMSG)
           INTO V_MENSAJE_ALERTA
           FROM AQPC714
          WHERE AQPC714CMSG = 1;
      EXCEPTION
         WHEN OTHERS THEN
            V_MENSAJE_ALERTA := NULL;
      END;
      IF V_MENSAJE_ALERTA IS NOT NULL THEN
         V_MENSAJE_ALERTA := REPLACE(REPLACE(V_MENSAJE_ALERTA, '<GERENTE>', V_NOMBRE_GERENTE), '<ANALISTA>', V_NOMBRE_ANALISTA);
      END IF;
      CASE
         WHEN V_FECHA_REPROGRAMACION_JAQA400 IS NULL AND V_FECHA_REPROGRAMACION_JAQZ698 IS NULL THEN
            V_CODIGO_ERROR  := 1;
            V_MENSAJE_ERROR := 'La fecha de reprogramación de la tabla JAQA400 y JAQZ698 se encuentran vacios';
            BEGIN
                  INSERT INTO AQPC297
                     (AQPC297ITCOD,
                      AQPC297ITSUC,
                      AQPC297ITMOD,
                      AQPC297ITTRAN,
                      AQPC297ITNREL,
                      AQPC297ITORD,
                      AQPC297EMP,
                      AQPC297MOD,
                      AQPC297SUC,
                      AQPC297MDA,
                      AQPC297PAP,
                      AQPC297CTA,
                      AQPC297OPER,
                      AQPC297SBOP,
                      AQPC297TOPE,
                      AQPC297ESTRPG,
                      AQPC297FECRP1,
                      AQPC297FECRP2,
                      AQPC297MSG,
                      AQPC297FPRC,
                      AQPC297HPRC,
                      AQPC297UPRC,
                      AQPC297EST,
                      AQPC297CODERR,
                      AQPC297MSGERR)
                  VALUES
                     (P_EMPRESA,
                      P_SUCURSAL_TRANSACCION,
                      P_MODULO_TRANSACCION,
                      P_NRO_TRANSACCION,
                      P_NRO_RELACION,
                      P_ORDINAL,
                      V_EMPRESA,
                      V_MODULO,
                      V_SUCURSAL,
                      V_MONEDA,
                      V_PAPEL,
                      V_CUENTA,
                      V_OPERACION,
                      V_SUBOPERACION,
                      V_TIPO_OPERACION,
                      NULL,
                      V_FECHA_REPROGRAMACION_JAQZ698,
                      V_FECHA_REPROGRAMACION_JAQA400,
                      NULL,
                      V_FECHA_APERTURA,
                      V_HORA_SISTEMA,
                      P_USUARIO,
                      '1',
                      V_CODIGO_ERROR,
                      V_MENSAJE_ERROR);
                  COMMIT;
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
         WHEN V_FECHA_REPROGRAMACION_JAQA400 > V_FECHA_REPROGRAMACION_JAQZ698 OR V_FECHA_REPROGRAMACION_JAQA400 IS NOT NULL AND 
              V_FECHA_REPROGRAMACION_JAQZ698 IS NULL THEN
            IF V_ESTADO_REPROGRAMACION_JAQA400 = 'U' THEN
               BEGIN
                  INSERT INTO AQPC297
                     (AQPC297ITCOD,
                      AQPC297ITSUC,
                      AQPC297ITMOD,
                      AQPC297ITTRAN,
                      AQPC297ITNREL,
                      AQPC297ITORD,
                      AQPC297EMP,
                      AQPC297MOD,
                      AQPC297SUC,
                      AQPC297MDA,
                      AQPC297PAP,
                      AQPC297CTA,
                      AQPC297OPER,
                      AQPC297SBOP,
                      AQPC297TOPE,
                      AQPC297ESTRPG,
                      AQPC297NESTRP,
                      AQPC297FECRP1,
                      AQPC297FECRP2,
                      AQPC297MSG,
                      AQPC297FPRC,
                      AQPC297HPRC,
                      AQPC297UPRC,
                      AQPC297EST,
                      AQPC297CODERR,
                      AQPC297MSGERR)
                  VALUES
                     (P_EMPRESA,
                      P_SUCURSAL_TRANSACCION,
                      P_MODULO_TRANSACCION,
                      P_NRO_TRANSACCION,
                      P_NRO_RELACION,
                      P_ORDINAL,
                      V_EMPRESA,
                      V_MODULO,
                      V_SUCURSAL,
                      V_MONEDA,
                      V_PAPEL,
                      V_CUENTA,
                      V_OPERACION,
                      V_SUBOPERACION,
                      V_TIPO_OPERACION,
                      V_ESTADO_REPROGRAMACION_JAQA400,
                      'Reprogramación Individual',
                      V_FECHA_REPROGRAMACION_JAQZ698,
                      V_FECHA_REPROGRAMACION_JAQA400,
                      V_MENSAJE_ALERTA,
                      V_FECHA_APERTURA,
                      V_HORA_SISTEMA,
                      P_USUARIO,
                      '1',
                      V_CODIGO_ERROR,
                      V_MENSAJE_ERROR);
                  COMMIT;
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
               BEGIN
                  SELECT TPNRO
                    INTO V_ENVIAR_EMAIL
                    FROM FST098
                   WHERE PGCOD  = 1
                     AND TPCOD  = 7753
                     AND TPCORR = 6;
               EXCEPTION
                  WHEN OTHERS THEN
                     V_ENVIAR_EMAIL := 0;
               END;
               IF V_ENVIAR_EMAIL = 1 THEN
                  BEGIN
                     SELECT TRIM(C.WFUSREMAIL)
                       INTO V_CORREO_GERENTE
                       FROM SNG057 A, FST046 B, WFUSERS C
                      WHERE A.SNG057USR = B.UBUSER
                        AND A.SNG057USR = RPAD(V_CODIGO_GERENTE, 10, ' ')
                        AND A.SNG055CAR = 202
                        AND B.UBSUC     = V_SUCURSAL
                        AND C.WFUSRCOD  = RPAD(V_CODIGO_GERENTE, 30, ' ')
                        AND ROWNUM      = 1;
                  EXCEPTION
                     WHEN OTHERS THEN
                        V_CORREO_GERENTE := NULL;
                  END;
                  BEGIN
                     SELECT TRIM(WFUSREMAIL)
                       INTO V_CORREO_ANALISTA
                       FROM WFUSERS
                      WHERE WFUSRCOD = RPAD(V_CODIGO_ANALISTA, 30, ' ')
                        AND ROWNUM   = 1;
                  EXCEPTION
                     WHEN OTHERS THEN
                        V_CORREO_ANALISTA := NULL;
                  END;
                  BEGIN
                     SELECT TRIM(CTNOM)
                     INTO V_NOMBRE_CLIENTE
                     FROM FSD008
                     WHERE PGCOD = 1 AND CTNRO = V_CUENTA;
                  EXCEPTION
                     WHEN OTHERS THEN
                        V_NOMBRE_CLIENTE := NULL;
                  END;
                  BEGIN
                     SELECT TRIM(MDNOM)
                     INTO V_NOMBRE_MODULO
                     FROM FST003
                     WHERE MODULO = V_MODULO;
                  EXCEPTION
                     WHEN OTHERS THEN
                        V_NOMBRE_MODULO := NULL;
                  END;
                  BEGIN
                     SELECT TRIM(TONOM)
                       INTO V_NOMBRE_TIPO_OPERACION
                       FROM FST004
                      WHERE MODULO = V_MODULO
                        AND TOTOPE = V_TIPO_OPERACION;
                  EXCEPTION
                     WHEN OTHERS THEN
                        V_NOMBRE_TIPO_OPERACION := NULL;
                  END;
                  BEGIN
                     SELECT TRIM(SCNOM)
                       INTO V_NOMBRE_SUCURSAL
                       FROM FST001
                      WHERE PGCOD  = V_EMPRESA
                        AND SUCURS = V_SUCURSAL;
                  EXCEPTION
                     WHEN OTHERS THEN
                        V_NOMBRE_SUCURSAL := NULL;
                  END;
                  V_ASUNTO         := 'Reprogramación Unilateral';
                  V_EMISOR         := 'notificaciones@cajaarequipa.pe';
                  V_CUERPO_MENSAJE := '<html>
                                          <head><style type="text/css"></style></head>
                                          <body>
                                            <p>'||V_MENSAJE_ALERTA||'</p>
                                            <ul>
                                              <li>Cliente: '||V_NOMBRE_CLIENTE||'</li>
                                              <li>Cuenta: '||V_CUENTA||'</li>
                                              <li>Operación: '||V_OPERACION||'</li>
                                              <li>Sucursal: '||V_SUCURSAL||''||' - '||''||V_NOMBRE_SUCURSAL||'</li>
                                              <li>Módulo: '||V_MODULO||''||' - '||''||V_NOMBRE_MODULO||'</li>
                                              <li>Tipo de Operación: '||V_TIPO_OPERACION||''||' - '||''||V_NOMBRE_TIPO_OPERACION||'</li>
                                            </ul>
                                          </body>
                                        </html>';
                  BEGIN
                     PQ_AH_PLANILLAS.P_SENDMAILATTACH(p_DestinatariosPara => V_CORREO_GERENTE, 
                                                   p_DestinatariosCC => V_CORREO_ANALISTA, 
                                                   p_DestinatariosBcc => ' ', 
                                                   p_Mensaje => V_CUERPO_MENSAJE, 
                                                   p_Remitente => V_EMISOR, 
                                                   p_Asunto => V_ASUNTO, 
                                                   p_TipoMensaje => 'HTML', 
                                                   p_Directorio => ' ', 
                                                   p_ArchivosAdjuntos => ' ',
                                                   p_c_coderr => V_CODIGO_ERROR_ENVIO, 
                                                   p_c_deserr => V_MENSAJE_ERROR_ENVIO);
                     BEGIN
                        UPDATE AQPC297
                           SET AQPC297CERREN = V_CODIGO_ERROR_ENVIO,
                               AQPC297MERREN = V_MENSAJE_ERROR_ENVIO
                         WHERE AQPC297ITCOD  = P_EMPRESA
                           AND AQPC297ITSUC  = P_SUCURSAL_TRANSACCION
                           AND AQPC297ITMOD  = P_MODULO_TRANSACCION
                           AND AQPC297ITTRAN = P_NRO_RELACION
                           AND AQPC297ITNREL = P_NRO_RELACION;
                        COMMIT;
                     EXCEPTION
                        WHEN OTHERS THEN
                           NULL;
                     END;
                  EXCEPTION
                     WHEN OTHERS THEN
                        V_SQLERRM := TRIM(SQLERRM);
                        V_SQLCODE := SQLCODE;
                        BEGIN
                           UPDATE AQPC297
                              SET AQPC297CERREN = '1',
                                  AQPC297MERREN = TRIM(REPLACE(V_SQLERRM, 'ORA' || V_SQLCODE || ': ', ''))
                            WHERE AQPC297ITCOD  = P_EMPRESA
                              AND AQPC297ITSUC  = P_SUCURSAL_TRANSACCION
                              AND AQPC297ITMOD  = P_MODULO_TRANSACCION
                              AND AQPC297ITTRAN = P_NRO_RELACION
                              AND AQPC297ITNREL = P_NRO_RELACION;
                           COMMIT;
                        EXCEPTION
                           WHEN OTHERS THEN
                              NULL;
                        END;
                  END;
               END IF;
            ELSE
               V_CODIGO_ERROR  := 1;
               V_MENSAJE_ERROR := 'El estado de la reprogramación no es unilateral';
               BEGIN
                  INSERT INTO AQPC297
                     (AQPC297ITCOD,
                      AQPC297ITSUC,
                      AQPC297ITMOD,
                      AQPC297ITTRAN,
                      AQPC297ITNREL,
                      AQPC297ITORD,
                      AQPC297EMP,
                      AQPC297MOD,
                      AQPC297SUC,
                      AQPC297MDA,
                      AQPC297PAP,
                      AQPC297CTA,
                      AQPC297OPER,
                      AQPC297SBOP,
                      AQPC297TOPE,
                      AQPC297ESTRPG,
                      AQPC297NESTRP,
                      AQPC297FECRP1,
                      AQPC297FECRP2,
                      AQPC297MSG,
                      AQPC297FPRC,
                      AQPC297HPRC,
                      AQPC297UPRC,
                      AQPC297EST,
                      AQPC297CODERR,
                      AQPC297MSGERR)
                  VALUES
                     (P_EMPRESA,
                      P_SUCURSAL_TRANSACCION,
                      P_MODULO_TRANSACCION,
                      P_NRO_TRANSACCION,
                      P_NRO_RELACION,
                      P_ORDINAL,
                      V_EMPRESA,
                      V_MODULO,
                      V_SUCURSAL,
                      V_MONEDA,
                      V_PAPEL,
                      V_CUENTA,
                      V_OPERACION,
                      V_SUBOPERACION,
                      V_TIPO_OPERACION,
                      V_ESTADO_REPROGRAMACION_JAQA400,
                      NULL,
                      V_FECHA_REPROGRAMACION_JAQZ698,
                      V_FECHA_REPROGRAMACION_JAQA400,
                      NULL,
                      V_FECHA_APERTURA,
                      V_HORA_SISTEMA,
                      P_USUARIO,
                      '1',
                      V_CODIGO_ERROR,
                      V_MENSAJE_ERROR);
                  COMMIT;
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;          
            END IF;
         WHEN V_FECHA_REPROGRAMACION_JAQZ698 > V_FECHA_REPROGRAMACION_JAQA400 OR V_FECHA_REPROGRAMACION_JAQZ698 IS NOT NULL AND 
              V_FECHA_REPROGRAMACION_JAQA400 IS NULL THEN
            IF V_ESTADO_REPROGRAMACION_JAQZ698 <> '2' THEN
               BEGIN
                  INSERT INTO AQPC297
                     (AQPC297ITCOD,
                      AQPC297ITSUC,
                      AQPC297ITMOD,
                      AQPC297ITTRAN,
                      AQPC297ITNREL,
                      AQPC297ITORD,
                      AQPC297EMP,
                      AQPC297MOD,
                      AQPC297SUC,
                      AQPC297MDA,
                      AQPC297PAP,
                      AQPC297CTA,
                      AQPC297OPER,
                      AQPC297SBOP,
                      AQPC297TOPE,
                      AQPC297ESTRPG,
                      AQPC297NESTRP,
                      AQPC297FECRP1,
                      AQPC297FECRP2,
                      AQPC297MSG,
                      AQPC297FPRC,
                      AQPC297HPRC,
                      AQPC297UPRC,
                      AQPC297EST,
                      AQPC297CODERR,
                      AQPC297MSGERR)
                  VALUES
                     (P_EMPRESA,
                      P_SUCURSAL_TRANSACCION,
                      P_MODULO_TRANSACCION,
                      P_NRO_TRANSACCION,
                      P_NRO_RELACION,
                      P_ORDINAL,
                      V_EMPRESA,
                      V_MODULO,
                      V_SUCURSAL,
                      V_MONEDA,
                      V_PAPEL,
                      V_CUENTA,
                      V_OPERACION,
                      V_SUBOPERACION,
                      V_TIPO_OPERACION,
                      V_ESTADO_REPROGRAMACION_JAQZ698,
                      'Reprogramación Masiva',
                      V_FECHA_REPROGRAMACION_JAQZ698,
                      V_FECHA_REPROGRAMACION_JAQA400,
                      V_MENSAJE_ALERTA,
                      V_FECHA_APERTURA,
                      V_HORA_SISTEMA,
                      P_USUARIO,
                      '1',
                      V_CODIGO_ERROR,
                      V_MENSAJE_ERROR);
                  COMMIT;
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
               BEGIN
                  SELECT TPNRO
                    INTO V_ENVIAR_EMAIL
                    FROM FST098
                   WHERE PGCOD  = 1
                     AND TPCOD  = 7753
                     AND TPCORR = 6;
               EXCEPTION
                  WHEN OTHERS THEN
                     V_ENVIAR_EMAIL := 0;
               END;
               IF V_ENVIAR_EMAIL = 1 THEN
                  BEGIN
                     SELECT TRIM(C.WFUSREMAIL)
                       INTO V_CORREO_GERENTE
                       FROM SNG057 A, FST046 B, WFUSERS C
                      WHERE A.SNG057USR = B.UBUSER
                        AND A.SNG057USR = RPAD(V_CODIGO_GERENTE, 10, ' ')
                        AND A.SNG055CAR = 202
                        AND B.UBSUC     = V_SUCURSAL
                        AND C.WFUSRCOD  = RPAD(V_CODIGO_GERENTE, 30, ' ')
                        AND ROWNUM      = 1;
                  EXCEPTION
                     WHEN OTHERS THEN
                        V_CORREO_GERENTE := NULL;
                  END;
                  BEGIN
                     SELECT TRIM(WFUSREMAIL)
                       INTO V_CORREO_ANALISTA
                       FROM WFUSERS
                      WHERE WFUSRCOD = RPAD(V_CODIGO_ANALISTA, 30, ' ')
                        AND ROWNUM   = 1;
                  EXCEPTION
                     WHEN OTHERS THEN
                        V_CORREO_ANALISTA := NULL;
                  END;
                  BEGIN
                     SELECT TRIM(CTNOM)
                     INTO V_NOMBRE_CLIENTE
                     FROM FSD008
                     WHERE PGCOD = 1 AND CTNRO = V_CUENTA;
                  EXCEPTION
                     WHEN OTHERS THEN
                        V_NOMBRE_CLIENTE := NULL;
                  END;
                  BEGIN
                     SELECT TRIM(MDNOM)
                     INTO V_NOMBRE_MODULO
                     FROM FST003
                     WHERE MODULO = V_MODULO;
                  EXCEPTION
                     WHEN OTHERS THEN
                        V_NOMBRE_MODULO := NULL;
                  END;
                  BEGIN
                     SELECT TRIM(TONOM)
                       INTO V_NOMBRE_TIPO_OPERACION
                       FROM FST004
                      WHERE MODULO = V_MODULO
                        AND TOTOPE = V_TIPO_OPERACION;
                  EXCEPTION
                     WHEN OTHERS THEN
                        V_NOMBRE_TIPO_OPERACION := NULL;
                  END;
                  BEGIN
                     SELECT TRIM(SCNOM)
                       INTO V_NOMBRE_SUCURSAL
                       FROM FST001
                      WHERE PGCOD  = V_EMPRESA
                        AND SUCURS = V_SUCURSAL;
                  EXCEPTION
                     WHEN OTHERS THEN
                        V_NOMBRE_SUCURSAL := NULL;
                  END;
                  V_ASUNTO         := 'Reprogramación Unilateral';
                  V_EMISOR         := 'notificaciones@cajaarequipa.pe';
                  V_CUERPO_MENSAJE := '<html>
                                          <head><style type="text/css"></style></head>
                                          <body>
                                            <p>'||V_MENSAJE_ALERTA||'</p>
                                            <ul>
                                              <li>Cliente: '||V_NOMBRE_CLIENTE||'</li>
                                              <li>Cuenta: '||V_CUENTA||'</li>
                                              <li>Operación: '||V_OPERACION||'</li>
                                              <li>Sucursal: '||V_SUCURSAL||''||' - '||''||V_NOMBRE_SUCURSAL||'</li>
                                              <li>Módulo: '||V_MODULO||''||' - '||''||V_NOMBRE_MODULO||'</li>
                                              <li>Tipo de Operación: '||V_TIPO_OPERACION||''||' - '||''||V_NOMBRE_TIPO_OPERACION||'</li>
                                            </ul>
                                          </body>
                                        </html>';
                  BEGIN
                     PQ_AH_PLANILLAS.P_SENDMAILATTACH(p_DestinatariosPara => V_CORREO_GERENTE, 
                                                   p_DestinatariosCC => V_CORREO_ANALISTA, 
                                                   p_DestinatariosBcc => ' ', 
                                                   p_Mensaje => V_CUERPO_MENSAJE, 
                                                   p_Remitente => V_EMISOR, 
                                                   p_Asunto => V_ASUNTO, 
                                                   p_TipoMensaje => 'HTML', 
                                                   p_Directorio => ' ', 
                                                   p_ArchivosAdjuntos => ' ',
                                                   p_c_coderr => V_CODIGO_ERROR_ENVIO, 
                                                   p_c_deserr => V_MENSAJE_ERROR_ENVIO);
                     BEGIN
                        UPDATE AQPC297
                           SET AQPC297CERREN = V_CODIGO_ERROR_ENVIO,
                               AQPC297MERREN = V_MENSAJE_ERROR_ENVIO
                         WHERE AQPC297ITCOD  = P_EMPRESA
                           AND AQPC297ITSUC  = P_SUCURSAL_TRANSACCION
                           AND AQPC297ITMOD  = P_MODULO_TRANSACCION
                           AND AQPC297ITTRAN = P_NRO_RELACION
                           AND AQPC297ITNREL = P_NRO_RELACION;
                        COMMIT;
                     EXCEPTION
                        WHEN OTHERS THEN
                           NULL;
                     END;
                  EXCEPTION
                     WHEN OTHERS THEN
                        V_SQLERRM := TRIM(SQLERRM);
                        V_SQLCODE := SQLCODE;
                        BEGIN
                           UPDATE AQPC297
                              SET AQPC297CERREN = '1',
                                  AQPC297MERREN = TRIM(REPLACE(V_SQLERRM, 'ORA' || V_SQLCODE || ': ', ''))
                            WHERE AQPC297ITCOD  = P_EMPRESA
                              AND AQPC297ITSUC  = P_SUCURSAL_TRANSACCION
                              AND AQPC297ITMOD  = P_MODULO_TRANSACCION
                              AND AQPC297ITTRAN = P_NRO_RELACION
                              AND AQPC297ITNREL = P_NRO_RELACION;
                           COMMIT;
                        EXCEPTION
                           WHEN OTHERS THEN
                              NULL;
                        END;
                  END;
               END IF;
            ELSE
               V_CODIGO_ERROR  := 1;
               V_MENSAJE_ERROR := 'El estado de la reprogramación no es unilateral';
               BEGIN
                  INSERT INTO AQPC297
                     (AQPC297ITCOD,
                      AQPC297ITSUC,
                      AQPC297ITMOD,
                      AQPC297ITTRAN,
                      AQPC297ITNREL,
                      AQPC297ITORD,
                      AQPC297EMP,
                      AQPC297MOD,
                      AQPC297SUC,
                      AQPC297MDA,
                      AQPC297PAP,
                      AQPC297CTA,
                      AQPC297OPER,
                      AQPC297SBOP,
                      AQPC297TOPE,
                      AQPC297ESTRPG,
                      AQPC297NESTRP,
                      AQPC297FECRP1,
                      AQPC297FECRP2,
                      AQPC297MSG,
                      AQPC297FPRC,
                      AQPC297HPRC,
                      AQPC297UPRC,
                      AQPC297EST,
                      AQPC297CODERR,
                      AQPC297MSGERR)
                  VALUES
                     (P_EMPRESA,
                      P_SUCURSAL_TRANSACCION,
                      P_MODULO_TRANSACCION,
                      P_NRO_TRANSACCION,
                      P_NRO_RELACION,
                      P_ORDINAL,
                      V_EMPRESA,
                      V_MODULO,
                      V_SUCURSAL,
                      V_MONEDA,
                      V_PAPEL,
                      V_CUENTA,
                      V_OPERACION,
                      V_SUBOPERACION,
                      V_TIPO_OPERACION,
                      V_ESTADO_REPROGRAMACION_JAQZ698,
                      NULL,
                      V_FECHA_REPROGRAMACION_JAQZ698,
                      V_FECHA_REPROGRAMACION_JAQA400,
                      NULL,
                      V_FECHA_APERTURA,
                      V_HORA_SISTEMA,
                      P_USUARIO,
                      '1',
                      V_CODIGO_ERROR,
                      V_MENSAJE_ERROR);
                  COMMIT;
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;  
            END IF;
         ELSE
            NULL;
      END CASE;
   END SP_CR_VALIDAR_UNILATERAL;

   PROCEDURE SP_CR_REPORTE_CAMBIO_ESTADO(P_USUARIO      IN VARCHAR2,
                                         P_SUCURSAL     IN NUMBER,
                                         P_FECHA_INICIO IN DATE,
                                         P_FECHA_FIN    IN DATE) IS
      
      V_FECHA_APERTURA               DATE;
      V_HORA_SISTEMA                 VARCHAR2(8);
      V_CODIGO_REGION_OPERADOR       NUMBER(3);
      V_CODIGO_ZONA_OPERADOR         NUMBER(2);
      V_CODIGO_SUCURSAL_OPERADOR     NUMBER(3);
      V_NOMBRE_REGION_OPERADOR       VARCHAR2(40);
      V_NOMBRE_ZONA_OPERADOR         VARCHAR2(50);
      V_NOMBRE_SUCURSAL_OPERADOR     VARCHAR2(30);
      V_NOMBRE_OPERADOR              VARCHAR2(30);
      V_CODIGO_REGION_CREDITO        NUMBER(3);
      V_CODIGO_ZONA_CREDITO          NUMBER(2);
      V_CODIGO_SUCURSAL_CREDITO      NUMBER(3);
      V_NOMBRE_REGION_CREDITO        VARCHAR2(40);
      V_NOMBRE_ZONA_CREDITO          VARCHAR2(50);
      V_NOMBRE_SUCURSAL_CREDITO      VARCHAR2(30);
      V_NOMBRE_CLIENTE               VARCHAR2(100);
      V_CODIGO_ASESOR                VARCHAR2(10);
      V_NOMBRE_ASESOR                VARCHAR2(30);
      V_SIGNO_MONEDA                 VARCHAR2(4);
      V_NOMBRE_MODULO                VARCHAR2(30);
      V_NOMBRE_TIPO_OPERACION        VARCHAR2(30);
      V_PAIS_CLIENTE                 NUMBER(3);
      V_TIPO_DOCUMENTO_CLIENTE       NUMBER(2);
      V_NRO_DOCUMENTO_CLIENTE        VARCHAR2(12);
      V_CORRELATIVO                  NUMBER(10);
      V_SALDO_CAPITAL_ACTUAL         NUMBER(17, 2);
      V_SALDO_CAPITAL_REPROGRAMACION NUMBER(17, 2);
      V_CODIGO_REGION_FILTRO         NUMBER(3);
      V_NOMBRE_REGION_FILTRO         VARCHAR2(40);
      V_CODIGO_ZONA_FILTRO           NUMBER(2);
      V_NOMBRE_ZONA_FILTRO           VARCHAR2(50);
      V_NOMBRE_SUCURSAL_FILTRO       VARCHAR2(30);
      
      CURSOR CURSOR_1 IS
         SELECT *
           FROM AQPB556
          WHERE AQPB556EST  = 'A'
            AND AQPB556EHAB = 'H'
            AND AQPB556SUC  = P_SUCURSAL
            AND (TRUNC(AQPB556FECCP) BETWEEN P_FECHA_INICIO AND P_FECHA_FIN OR P_FECHA_INICIO IS NULL AND P_FECHA_FIN IS NULL)
            ORDER BY AQPB556FECCP ASC;
   
      CURSOR CURSOR_2 IS
         SELECT *
           FROM JAQZ698
          WHERE JAQZ698EST = 'C'
            AND JAQZ698NU2 = 2
            AND JAQZ698SUC = P_SUCURSAL
            AND (JAQZ698FA3 BETWEEN P_FECHA_INICIO AND P_FECHA_FIN OR P_FECHA_INICIO IS NULL AND P_FECHA_FIN IS NULL)
            ORDER BY JAQZ698FA3 ASC;
   BEGIN
      BEGIN
         DELETE FROM AQPC752 WHERE AQPC752USER = P_USUARIO;
         COMMIT;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      BEGIN
         SELECT PGFAPE
         INTO V_FECHA_APERTURA
         FROM FST017
         WHERE PGCOD = 1;
      EXCEPTION
         WHEN OTHERS THEN
            V_FECHA_APERTURA := NULL;
      END;
      BEGIN
         SELECT REGCOD, TRIM(REGNOM), CODZON, TRIM(DESZON), TRIM(SCNOM)
           INTO V_CODIGO_REGION_FILTRO,
                V_NOMBRE_REGION_FILTRO,
                V_CODIGO_ZONA_FILTRO,
                V_NOMBRE_ZONA_FILTRO,
                V_NOMBRE_SUCURSAL_FILTRO
           FROM REGSUC
          WHERE SUCURS = P_SUCURSAL;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      V_CORRELATIVO := 0;
      FOR I IN CURSOR_1 LOOP
         V_HORA_SISTEMA := NULL;
         V_HORA_SISTEMA := TO_CHAR(SYSDATE(), 'HH24:MI:SS');
         BEGIN
            SELECT B.REGCOD,
                   TRIM(B.REGNOM),
                   B.CODZON,
                   TRIM(B.DESZON),
                   B.SUCURS,
                   TRIM(B.SCNOM)
              INTO V_CODIGO_REGION_OPERADOR,
                   V_NOMBRE_REGION_OPERADOR,
                   V_CODIGO_ZONA_OPERADOR,
                   V_NOMBRE_ZONA_OPERADOR,
                   V_CODIGO_SUCURSAL_OPERADOR,
                   V_NOMBRE_SUCURSAL_OPERADOR
              FROM FST046 A, REGSUC B
             WHERE A.UBUSER = RPAD(I.AQPB556PUSRR, 10, ' ')
               AND B.SUCURS = A.UBSUC;
         EXCEPTION
            WHEN OTHERS THEN
               V_CODIGO_REGION_OPERADOR   := 0;
               V_CODIGO_ZONA_OPERADOR     := 0;
               V_CODIGO_SUCURSAL_OPERADOR := 0;
               V_NOMBRE_REGION_OPERADOR   := NULL;
               V_NOMBRE_ZONA_OPERADOR     := NULL;
               V_NOMBRE_SUCURSAL_OPERADOR := NULL;
         END;
         BEGIN
            SELECT INITCAP(TRIM(UBNOM))
              INTO V_NOMBRE_OPERADOR
              FROM FST746
             WHERE UBUSER = RPAD(I.AQPB556PUSRR, 10, ' ');
         EXCEPTION
            WHEN OTHERS THEN
               V_NOMBRE_OPERADOR := NULL;
         END;
         BEGIN
            SELECT REGCOD,
                   TRIM(REGNOM),
                   CODZON,
                   TRIM(DESZON),
                   SUCURS,
                   TRIM(SCNOM)
              INTO V_CODIGO_REGION_CREDITO,
                   V_NOMBRE_REGION_CREDITO,
                   V_CODIGO_ZONA_CREDITO,
                   V_NOMBRE_ZONA_CREDITO,
                   V_CODIGO_SUCURSAL_CREDITO,
                   V_NOMBRE_SUCURSAL_CREDITO
              FROM REGSUC
             WHERE SUCURS = I.AQPB556SUC;
         EXCEPTION
            WHEN OTHERS THEN
               V_CODIGO_REGION_CREDITO   := 0;
               V_CODIGO_ZONA_CREDITO     := 0;
               V_CODIGO_SUCURSAL_CREDITO := 0;
               V_NOMBRE_REGION_CREDITO   := NULL;
               V_NOMBRE_ZONA_CREDITO     := NULL;
               V_NOMBRE_SUCURSAL_CREDITO := NULL;
         END;
         BEGIN
            SELECT INITCAP((TRIM(PFAPE1) || ' ' || TRIM(PFAPE2) || ' ' ||
                           TRIM(PFNOM1) || ' ' || TRIM(PFNOM2)))
              INTO V_NOMBRE_CLIENTE
              FROM FSD002
             WHERE PFPAIS = I.AQPB556PAIS
               AND PFTDOC = I.AQPB556PTDC
               AND PFNDOC = RPAD(I.AQPB556DNI, 12, ' ');
         EXCEPTION
            WHEN OTHERS THEN
               V_NOMBRE_CLIENTE := NULL;
               BEGIN
                  SELECT INITCAP(TRIM(PJRAZS))
                    INTO V_NOMBRE_CLIENTE
                    FROM FSD003
                   WHERE PJPAIS = I.AQPB556PAIS
                     AND PJTDOC = I.AQPB556PTDC
                     AND PJNDOC = RPAD(I.AQPB556DNI, 12, ' ');
               EXCEPTION
                  WHEN OTHERS THEN
                     V_NOMBRE_CLIENTE := NULL;
               END;
         END;
         BEGIN
            SELECT A.SNG001ASE, INITCAP(TRIM(B.UBNOM))
              INTO V_CODIGO_ASESOR, V_NOMBRE_ASESOR
              FROM SNG001 A, FST746 B
             WHERE A.SNG001INST = I.AQPB556INST
               AND B.UBUSER     = A.SNG001ASE;
         EXCEPTION
            WHEN OTHERS THEN
               V_CODIGO_ASESOR := 0;
               V_NOMBRE_ASESOR := NULL;
         END;
         BEGIN
            SELECT TRIM(MOSIGN)
            INTO V_SIGNO_MONEDA
            FROM FST005
            WHERE MONEDA = I.AQPB556MDA;
         EXCEPTION
            WHEN OTHERS THEN
               V_SIGNO_MONEDA := NULL;
         END;
         BEGIN
            SELECT INITCAP(TRIM(MDNOM))
            INTO V_NOMBRE_MODULO
            FROM FST003
            WHERE MODULO = I.AQPB556MOD;
         EXCEPTION
            WHEN OTHERS THEN
               V_NOMBRE_MODULO := NULL;
         END;
         BEGIN
            SELECT TRIM(TONOM)
              INTO V_NOMBRE_TIPO_OPERACION
              FROM FST004
             WHERE MODULO = I.AQPB556MOD
               AND TOTOPE = I.AQPB556TOP;
         EXCEPTION
            WHEN OTHERS THEN
               V_NOMBRE_TIPO_OPERACION := NULL;
         END;
         BEGIN
            SELECT ABS(SCSDO)
              INTO V_SALDO_CAPITAL_ACTUAL
              FROM FSD011
             WHERE PGCOD  = I.AQPB556EMP
               AND SCMOD  = I.AQPB556MOD
               AND SCMDA  = I.AQPB556MDA
               AND SCPAP  = I.AQPB556PAP
               AND SCCTA  = I.AQPB556CTA
               AND SCSUC  = I.AQPB556SUC
               AND SCOPER = I.AQPB556OPER
               AND SCSBOP = I.AQPB556SBOP
               AND SCTOPE = I.AQPB556TOP
               AND SCSTAT <> 99;
         EXCEPTION
            WHEN OTHERS THEN
               V_SALDO_CAPITAL_ACTUAL := 0;
         END;
         V_CORRELATIVO := V_CORRELATIVO + 1;
         BEGIN
            INSERT INTO AQPC752
               (AQPC752USER,
                AQPC752FECHA,
                AQPC752HORA,
                AQPC752CORR,
                AQPC752REGCRD,
                AQPC752NRGCRD,
                AQPC752ZONCRD,
                AQPC752NZNCRD,
                AQPC752SUCCRD,
                AQPC752NSCCRD,
                AQPC752REGOPR,
                AQPC752NRGOPR,
                AQPC752ZONOPR,
                AQPC752NZNOPR,
                AQPC752SUCOPR,
                AQPC752NSCOPR,
                AQPC752OPERAD,
                AQPC752NOMOPR,
                AQPC752REGFIL,
                AQPC752NRGFIL,
                AQPC752ZONFIL,
                AQPC752NZNFIL,
                AQPC752SUCFIL,
                AQPC752NSCFIL,
                AQPC752FCHINI,
                AQPC752FCHFIN,
                AQPC752COD,
                AQPC752MOD,
                AQPC752SUC,
                AQPC752MDA,
                AQPC752PAP,
                AQPC752CTA,
                AQPC752OPER,
                AQPC752SBOP,
                AQPC752TOPE,
                AQPC752SGNMDA,
                AQPC752NOMMOD,
                AQPC752NOMTOP,
                AQPC752FHRPR,
                AQPC752HRRPR,
                AQPC752PAIS,
                AQPC752TDOC,
                AQPC752NDOC,
                AQPC752NOMCLI,
                AQPC752ESTADO,
                AQPC752NOMEST,
                AQPC752SDOACT,
                AQPC752SDORPR,
                AQPC752CODASE,
                AQPC752NOMASE)
            VALUES
               (P_USUARIO,
                V_FECHA_APERTURA,
                V_HORA_SISTEMA,
                V_CORRELATIVO,
                V_CODIGO_REGION_CREDITO,
                V_NOMBRE_REGION_CREDITO,
                V_CODIGO_ZONA_CREDITO,
                V_NOMBRE_ZONA_CREDITO,
                V_CODIGO_SUCURSAL_CREDITO,
                V_NOMBRE_SUCURSAL_CREDITO,
                V_CODIGO_REGION_OPERADOR,
                V_NOMBRE_REGION_OPERADOR,
                V_CODIGO_ZONA_OPERADOR,
                V_NOMBRE_ZONA_OPERADOR,
                V_CODIGO_SUCURSAL_OPERADOR,
                V_NOMBRE_SUCURSAL_OPERADOR,
                TRIM(I.AQPB556PUSRR),
                V_NOMBRE_OPERADOR,
                V_CODIGO_REGION_FILTRO,
                V_NOMBRE_REGION_FILTRO,
                V_CODIGO_ZONA_FILTRO,
                V_NOMBRE_ZONA_FILTRO,
                P_SUCURSAL,
                V_NOMBRE_SUCURSAL_FILTRO,
                P_FECHA_INICIO,
                P_FECHA_FIN,
                I.AQPB556EMP,
                I.AQPB556MOD,
                I.AQPB556SUC,
                I.AQPB556MDA,
                I.AQPB556PAP,
                I.AQPB556CTA,
                I.AQPB556OPER,
                I.AQPB556SBOP,
                I.AQPB556TOP,
                V_SIGNO_MONEDA,
                V_NOMBRE_MODULO,
                V_NOMBRE_TIPO_OPERACION,
                TRUNC(I.AQPB556FECCP),
                TRIM(TO_CHAR(I.AQPB556FECCP, 'HH24:MI:SS')),
                I.AQPB556PAIS,
                I.AQPB556PTDC,
                I.AQPB556DNI,
                V_NOMBRE_CLIENTE,
                TRIM(I.AQPB556EST),
                'Consensuado',
                V_SALDO_CAPITAL_ACTUAL,
                ABS(I.AQPB556SCAP),
                V_CODIGO_ASESOR,
                V_NOMBRE_ASESOR);
            COMMIT;
         EXCEPTION
            WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE(SQLERRM);
         END;
      END LOOP;
      
      FOR J IN CURSOR_2 LOOP
         V_HORA_SISTEMA := NULL;
         V_HORA_SISTEMA := TO_CHAR(SYSDATE(), 'HH24:MI:SS');
         BEGIN
            SELECT B.REGCOD,
                   TRIM(B.REGNOM),
                   B.CODZON,
                   TRIM(B.DESZON),
                   B.SUCURS,
                   TRIM(B.SCNOM)
              INTO V_CODIGO_REGION_OPERADOR,
                   V_NOMBRE_REGION_OPERADOR,
                   V_CODIGO_ZONA_OPERADOR,
                   V_NOMBRE_ZONA_OPERADOR,
                   V_CODIGO_SUCURSAL_OPERADOR,
                   V_NOMBRE_SUCURSAL_OPERADOR
              FROM FST046 A, REGSUC B
             WHERE A.UBUSER = RPAD(J.JAQZ698CA2, 10, ' ')
               AND B.SUCURS = A.UBSUC;
         EXCEPTION
            WHEN OTHERS THEN
               V_CODIGO_REGION_OPERADOR   := 0;
               V_CODIGO_ZONA_OPERADOR     := 0;
               V_CODIGO_SUCURSAL_OPERADOR := 0;
               V_NOMBRE_REGION_OPERADOR   := NULL;
               V_NOMBRE_ZONA_OPERADOR     := NULL;
               V_NOMBRE_SUCURSAL_OPERADOR := NULL;
         END;
         BEGIN
            SELECT TRIM(UBNOM)
              INTO V_NOMBRE_OPERADOR
              FROM FST746
             WHERE UBUSER = RPAD(TRIM(J.JAQZ698CA2), 10, ' ');
         EXCEPTION
            WHEN OTHERS THEN
               V_NOMBRE_OPERADOR := NULL;
         END;
         BEGIN
            SELECT REGCOD,
                   TRIM(REGNOM),
                   CODZON,
                   TRIM(DESZON),
                   SUCURS,
                   TRIM(SCNOM)
              INTO V_CODIGO_REGION_CREDITO,
                   V_NOMBRE_REGION_CREDITO,
                   V_CODIGO_ZONA_CREDITO,
                   V_NOMBRE_ZONA_CREDITO,
                   V_CODIGO_SUCURSAL_CREDITO,
                   V_NOMBRE_SUCURSAL_CREDITO
              FROM REGSUC
             WHERE SUCURS = J.JAQZ698SUC;
         EXCEPTION
            WHEN OTHERS THEN
               V_CODIGO_REGION_CREDITO   := 0;
               V_CODIGO_ZONA_CREDITO     := 0;
               V_CODIGO_SUCURSAL_CREDITO := 0;
               V_NOMBRE_REGION_CREDITO   := NULL;
               V_NOMBRE_ZONA_CREDITO     := NULL;
               V_NOMBRE_SUCURSAL_CREDITO := NULL;
         END;         
         BEGIN
            SELECT PEPAIS, PETDOC, PENDOC
              INTO V_PAIS_CLIENTE,
                   V_TIPO_DOCUMENTO_CLIENTE,
                   V_NRO_DOCUMENTO_CLIENTE
              FROM FSR008
             WHERE PGCOD  = 1
               AND CTNRO  = J.JAQZ698CTA
               AND CTTFIR = 'T';
         EXCEPTION
            WHEN OTHERS THEN
               V_PAIS_CLIENTE           := 0;
               V_TIPO_DOCUMENTO_CLIENTE := 0;
               V_NRO_DOCUMENTO_CLIENTE  := NULL;
         END;
         BEGIN
            SELECT (TRIM(PFAPE1) || ' ' || TRIM(PFAPE2) || ' ' ||
                    TRIM(PFNOM1) || ' ' || TRIM(PFNOM2))
              INTO V_NOMBRE_CLIENTE
              FROM FSD002
             WHERE PFPAIS = V_PAIS_CLIENTE
               AND PFTDOC = V_TIPO_DOCUMENTO_CLIENTE
               AND PFNDOC = RPAD(V_NRO_DOCUMENTO_CLIENTE, 12, ' ');
         EXCEPTION
            WHEN OTHERS THEN
               V_NOMBRE_CLIENTE := NULL;
               BEGIN
                  SELECT TRIM(PJRAZS)
                    INTO V_NOMBRE_CLIENTE
                    FROM FSD003
                   WHERE PJPAIS = V_PAIS_CLIENTE
                     AND PJTDOC = V_TIPO_DOCUMENTO_CLIENTE
                     AND PJNDOC = RPAD(V_NRO_DOCUMENTO_CLIENTE, 12, ' ');
               EXCEPTION
                  WHEN OTHERS THEN
                     V_NOMBRE_CLIENTE := NULL;
               END;
         END;
         BEGIN
            SELECT TRIM(MOSIGN)
            INTO V_SIGNO_MONEDA
            FROM FST005
            WHERE MONEDA = J.JAQZ698MDA;
         EXCEPTION
            WHEN OTHERS THEN
               V_SIGNO_MONEDA := NULL;
         END;
         BEGIN
            SELECT TRIM(MDNOM)
            INTO V_NOMBRE_MODULO
            FROM FST003
            WHERE MODULO = J.JAQZ698MOD;
         EXCEPTION
            WHEN OTHERS THEN
               V_NOMBRE_MODULO := NULL;
         END;
         BEGIN
            SELECT TRIM(TONOM)
              INTO V_NOMBRE_TIPO_OPERACION
              FROM FST004
             WHERE MODULO = J.JAQZ698MOD
               AND TOTOPE = J.JAQZ698TOP;
         EXCEPTION
            WHEN OTHERS THEN
               V_NOMBRE_TIPO_OPERACION := NULL;
         END;
         BEGIN
            SELECT ABS(SCSDO)
              INTO V_SALDO_CAPITAL_ACTUAL
              FROM FSD011
             WHERE PGCOD  = J.JAQZ698EMP
               AND SCMOD  = J.JAQZ698MOD
               AND SCMDA  = J.JAQZ698MDA
               AND SCPAP  = J.JAQZ698PAP
               AND SCCTA  = J.JAQZ698CTA
               AND SCSUC  = J.JAQZ698SUC
               AND SCOPER = J.JAQZ698OPE
               AND SCSBOP = J.JAQZ698SBO
               AND SCTOPE = J.JAQZ698TOP
               AND SCSTAT <> 99;
         EXCEPTION
            WHEN OTHERS THEN
               V_SALDO_CAPITAL_ACTUAL := 0;
         END;
         BEGIN
            SELECT ABS(SCSDO)
              INTO V_SALDO_CAPITAL_REPROGRAMACION
              FROM JAQZ520_011C
             WHERE PGCOD  = J.JAQZ698EMP
               AND SCMOD  = J.JAQZ698MOD
               AND SCMDA  = J.JAQZ698MDA
               AND SCPAP  = J.JAQZ698PAP
               AND SCCTA  = J.JAQZ698CTA
               AND SCSUC  = J.JAQZ698SUC
               AND SCOPER = J.JAQZ698OPE
               AND SCSBOP = J.JAQZ698SBO
               AND SCTOPE = J.JAQZ698TOP
               AND SCSTAT <> 99;
         EXCEPTION
            WHEN OTHERS THEN
               V_SALDO_CAPITAL_REPROGRAMACION := 0;
         END;
         BEGIN
            SELECT A.SNG001ASE, TRIM(B.UBNOM)
              INTO V_CODIGO_ASESOR, V_NOMBRE_ASESOR
              FROM SNG001 A, FST746 B
             WHERE A.SNG001INST = J.JAQZ698INST
               AND B.UBUSER     = A.SNG001ASE;
         EXCEPTION
            WHEN OTHERS THEN
               V_CODIGO_ASESOR := 0;
               V_NOMBRE_ASESOR := NULL;
         END;
         V_CORRELATIVO := V_CORRELATIVO + 1;
         BEGIN
            INSERT INTO AQPC752
               (AQPC752USER,
                AQPC752FECHA,
                AQPC752HORA,
                AQPC752CORR,
                AQPC752REGCRD,
                AQPC752NRGCRD,
                AQPC752ZONCRD,
                AQPC752NZNCRD,
                AQPC752SUCCRD,
                AQPC752NSCCRD,
                AQPC752REGOPR,
                AQPC752NRGOPR,
                AQPC752ZONOPR,
                AQPC752NZNOPR,
                AQPC752SUCOPR,
                AQPC752NSCOPR,
                AQPC752OPERAD,
                AQPC752NOMOPR,
                AQPC752REGFIL,
                AQPC752NRGFIL,
                AQPC752ZONFIL,
                AQPC752NZNFIL,
                AQPC752SUCFIL,
                AQPC752NSCFIL,
                AQPC752FCHINI,
                AQPC752FCHFIN,
                AQPC752COD,
                AQPC752MOD,
                AQPC752SUC,
                AQPC752MDA,
                AQPC752PAP,
                AQPC752CTA,
                AQPC752OPER,
                AQPC752SBOP,
                AQPC752TOPE,
                AQPC752SGNMDA,
                AQPC752NOMMOD,
                AQPC752NOMTOP,
                AQPC752FHRPR,
                AQPC752HRRPR,
                AQPC752PAIS,
                AQPC752TDOC,
                AQPC752NDOC,
                AQPC752NOMCLI,
                AQPC752ESTADO,
                AQPC752NOMEST,
                AQPC752SDOACT,
                AQPC752SDORPR,
                AQPC752CODASE,
                AQPC752NOMASE)
            VALUES
               (P_USUARIO,
                V_FECHA_APERTURA,
                V_HORA_SISTEMA,
                V_CORRELATIVO,
                V_CODIGO_REGION_CREDITO,
                V_NOMBRE_REGION_CREDITO,
                V_CODIGO_ZONA_CREDITO,
                V_NOMBRE_ZONA_CREDITO,
                V_CODIGO_SUCURSAL_CREDITO,
                V_NOMBRE_SUCURSAL_CREDITO,
                V_CODIGO_REGION_OPERADOR,
                V_NOMBRE_REGION_OPERADOR,
                V_CODIGO_ZONA_OPERADOR,
                V_NOMBRE_ZONA_OPERADOR,
                V_CODIGO_SUCURSAL_OPERADOR,
                V_NOMBRE_SUCURSAL_OPERADOR,
                TRIM(J.JAQZ698CA2),
                V_NOMBRE_OPERADOR,
                V_CODIGO_REGION_FILTRO,
                V_NOMBRE_REGION_FILTRO,
                V_CODIGO_ZONA_FILTRO,
                V_NOMBRE_ZONA_FILTRO,
                P_SUCURSAL,
                V_NOMBRE_SUCURSAL_FILTRO,
                P_FECHA_INICIO,
                P_FECHA_FIN,
                J.JAQZ698EMP,
                J.JAQZ698MOD,
                J.JAQZ698SUC,
                J.JAQZ698MDA,
                J.JAQZ698PAP,
                J.JAQZ698CTA,
                J.JAQZ698OPE,
                J.JAQZ698SBO,
                J.JAQZ698TOP,
                V_SIGNO_MONEDA,
                V_NOMBRE_MODULO,
                V_NOMBRE_TIPO_OPERACION,
                J.JAQZ698FA3,
                TRIM(J.JAQZ698CA1),
                V_PAIS_CLIENTE,
                V_TIPO_DOCUMENTO_CLIENTE,
                V_NRO_DOCUMENTO_CLIENTE,
                V_NOMBRE_CLIENTE,
                TRIM(TO_CHAR(J.JAQZ698NU2)),
                'Consensuado',
                V_SALDO_CAPITAL_ACTUAL,
                V_SALDO_CAPITAL_REPROGRAMACION,
                V_CODIGO_ASESOR,
                V_NOMBRE_ASESOR);
            COMMIT;
         EXCEPTION
            WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE(SQLERRM);
         END;
      END LOOP;
   END SP_CR_REPORTE_CAMBIO_ESTADO;

END PQ_CR_CREDITOS_REPROGRAMADOS;
/

