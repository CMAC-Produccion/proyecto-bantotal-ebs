create or replace package PQ_CR_ENVIO_ALERTA_CNA is

  -- *****************************************************************
  -- NOMBRE                     : PAQUETE PARA ENVIAR POR CORREO LA ALERTA CNA
  -- SISTEMA                    : BANTOAL
  -- MODULO                     : CREDITOS - ACTIVAS
  -- VERSION                    : 1.0
  -- FECHA DE CREACION          : 27/11/2022
  -- AUTOR DE CREACION          : MAYCOL CHAVEZ CHUMAN
  -- USO                        : ENVIO DE ALERTA CNA CUANDO SE CANCELA UN PRESTAMO
  -- ESTADO                     : ACTIVO
  -- ACCESO                     : PUBLICO
  -- *****************************************************************

  PROCEDURE SP_CR_ENVIO_ALERTA(pPGCOD  IN NUMBER,
                               pITSUC  IN NUMBER,
                               pITMOD  IN NUMBER,
                               pITTRAN IN NUMBER,
                               pITNREL IN NUMBER,
                               pITORD  IN NUMBER,
                               pITFCON IN DATE,
                               pUSER   IN VARCHAR2);

end PQ_CR_ENVIO_ALERTA_CNA;
/

create or replace package body PQ_CR_ENVIO_ALERTA_CNA is

  PROCEDURE SP_CR_ENVIO_ALERTA(pPGCOD  IN NUMBER,
                               pITSUC  IN NUMBER,
                               pITMOD  IN NUMBER,
                               pITTRAN IN NUMBER,
                               pITNREL IN NUMBER,
                               pITORD  IN NUMBER,
                               pITFCON IN DATE,
                               pUSER   IN VARCHAR2) IS
    -- *****************************************************************
    -- NOMBRE                      : SP_CR_ENVIO_ALERTA
    -- SISTEMA                     : BANTOTAL
    -- MODULO                      : CREDITOS - ACTIVAS
    -- VERSION                     : 1.0
    -- FECHA DE CREACION           : 27/11/2022
    -- AUTOR DE CREACION           : MAYCOL CHAVEZ CHUMAN
    -- USO                         : ENVIO DE ALERTA CNA CUANDO SE CANCELA UN PRESTAMO
    -- ESTADO                      : ACTIVO
    -- ACCESO                      : PUBLICO
    --------------------------------------------------------------------
    -- FECHA DE MODIFICACION       : 
    -- AUTOR DE LA MODIFICACION    : 
    -- DESCRIPCION DE MODIFICACION : 
    --
    -- *****************************************************************
  
    -- VARIABLES --
    EMISOR   VARCHAR2(40) := 'notificaciones@cajaarequipa.pe';
    ASUNTO   VARCHAR2(100) := 'Alerta de Emisión de CNA con glosa de garantía';
    MENSAJE  LONG := ' ';
    GRTASC   LONG := ' ';
    DESTINO  VARCHAR2(250) := ' ';
    DESTCPY  VARCHAR2(250) := ' ';
    CODERR   VARCHAR2(5) := '0';
    MSGERR   VARCHAR2(250) := ' ';
    INST     NUMBER(10) := 0;
    PGCOD    NUMBER(3) := 0;
    MODULO   NUMBER(3) := 0;
    SUC      NUMBER(3) := 0;
    MDA      NUMBER(4) := 0;
    PAP      NUMBER(4) := 0;
    CTA      NUMBER(9) := 0;
    OPER     NUMBER(9) := 0;
    SBOP     NUMBER(3) := 0;
    TOPE     NUMBER(3) := 0;
    PGCODG   NUMBER(3) := 0;
    MODG     NUMBER(3) := 0;
    SUCG     NUMBER(3) := 0;
    MDAG     NUMBER(4) := 0;
    PAPG     NUMBER(4) := 0;
    CTAG     NUMBER(9) := 0;
    OPERG    NUMBER(9) := 0;
    SBOPG    NUMBER(3) := 0;
    TOPEG    NUMBER(3) := 0;
    FECHA    DATE := SYSDATE();
    HORA     VARCHAR2(9) := TO_CHAR(SYSDATE(), 'HH24:MI:SS');
    NOMTOPEG VARCHAR2(30) := ' ';
    NOMSUCG  VARCHAR2(30) := ' ';
    NOMREGG  VARCHAR2(20) := ' ';
    USUARIO  VARCHAR2(10) := ' ';
    NOMUSU   VARCHAR2(30) := ' ';
    INTEGR   LONG := ' ';
    EXSTGRTN VARCHAR2(1);
    NULO     NUMBER(3) := 0;
    ALERTA   NUMBER(9) := 0;
    DEPT     NUMBER(5) := 0;
    NOMCLI   VARCHAR2(30) := ' ';
    PAIS     NUMBER(3) := 0;
    TDOC     NUMBER(2) := 0;
    NDOC     VARCHAR2(12) := ' ';
    FILAS    NUMBER(9) := 0;
    CANT     NUMBER(9) := 0;
    DOMINIO  VARCHAR2(30) := ' ';
    -- OBTENER LISTA DE INTEGRANTES DE LA GARANTIA --
    CURSOR LST1 IS
      SELECT B.PENOM, B.PENDOC
        FROM FSR008 A, FSD001 B
       WHERE A.PEPAIS = B.PEPAIS
         AND A.PETDOC = B.PETDOC
         AND A.PENDOC = B.PENDOC
         AND A.PGCOD = pPGCOD
         AND A.CTNRO = CTAG;
    -- OBTENER LISTA DE DESTINARIOS --
    CURSOR LST2 IS
      SELECT TP1NRO1, TP1DESC
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 111154
         AND TP1CORR1 = 1
         AND TP1CORR2 = 0
         AND TP1CORR3 > 0;
    -- OBTENER LISTA DE DESTINARIOS COPIA --
    CURSOR LST3 IS
      SELECT TP1NRO1, TP1DESC
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 111154
         AND TP1CORR1 = 2
         AND TP1CORR2 = 0
         AND TP1CORR3 > 0;
    -- OBTENER LISTA DE GARANTIAS DEL CLIENTE --
    CURSOR LST4 IS
      SELECT SNG122PGC,
             SNG122MOD,
             SNG122SUC,
             SNG122MDA,
             SNG122PAP,
             SNG122CTA,
             SNG122OPER,
             SNG122SBOP,
             SNG122TOPE
        FROM SNG122
       WHERE SNG122INST = INST;
  BEGIN
    -- 1 = ACTIVADO / 0 = DESACTIVADO --
    BEGIN
      SELECT TPNRO
        INTO ALERTA
        FROM FST098
       WHERE PGCOD = 1
         AND TPCOD = 7753
         AND TPCORR = 2;
    EXCEPTION
      WHEN OTHERS THEN
        ALERTA := 0;
    END;
    IF ALERTA = 1 THEN
      -- OBTENER CREDITO Y INSTANCIA DEL CLIENTE --
      BEGIN
        SELECT B.PGCOD,
               B.MODULO,
               B.MONEDA,
               B.PAPEL,
               B.ITSUCD,
               B.CTNRO,
               B.ITOPER,
               B.ITSUBO,
               B.ITTOPE,
               C.XWFPRCINS
          INTO PGCOD, MODULO, MDA, PAP, SUC, CTA, OPER, SBOP, TOPE, INST
          FROM FSD015 A, FSD016 B, XWF700 C
         WHERE A.PGCOD = B.PGCOD
           AND A.ITSUC = B.ITSUC
           AND A.ITMOD = B.ITMOD
           AND A.ITTRAN = B.ITTRAN
           AND A.ITNREL = B.ITNREL
           AND B.PGCOD = C.XWFEMPRESA
           AND B.ITSUCD = C.XWFSUCURSAL
           AND B.MODULO = C.XWFMODULO
           AND B.MONEDA = C.XWFMONEDA
           AND B.PAPEL = C.XWFPAPEL
           AND B.CTNRO = C.XWFCUENTA
           AND B.ITOPER = C.XWFOPERACION
           AND B.ITSUBO = C.XWFSUBOPE
           AND B.ITTOPE = C.XWFTIPOPE
           AND C.XWFCAR3 = '1'
           AND A.PGCOD = pPGCOD
           AND A.ITSUC = pITSUC
           AND A.ITMOD = pITMOD
           AND A.ITTRAN = pITTRAN
           AND A.ITNREL = pITNREL
           AND B.ITORD = pITORD
           AND A.ITFCON = pITFCON
           AND C.XWFMONTO1 <> 0
           AND ROWNUM = 1;
        -- OBTENER DOCUMENTO DEL CLIENTE TITULAR --
        BEGIN
          SELECT PEPAIS, PETDOC, PENDOC
            INTO PAIS, TDOC, NDOC
            FROM FSR008
           WHERE PGCOD = PGCOD
             AND CTNRO = CTA
             AND CTTFIR = 'T';
          -- OBTENER NOMBRE CLIENTE TITULAR --
          BEGIN
            SELECT TRIM(PENOM)
              INTO NOMCLI
              FROM FSD001
             WHERE PEPAIS = PAIS
               AND PETDOC = TDOC
               AND PENDOC = NDOC;
          EXCEPTION
            WHEN OTHERS THEN
              NOMCLI := ' ';
          END;
        EXCEPTION
          WHEN OTHERS THEN
            NDOC := ' ';
        END;
        -- OBTENER ANALISTA ---
        BEGIN
          SELECT B.UBUSER, B.UBNOM
            INTO USUARIO, NOMUSU
            FROM SNG001 A, FST746 B
           WHERE A.SNG001ASE = B.UBUSER
             AND A.SNG001INST = INST;
        EXCEPTION
          WHEN OTHERS THEN
            USUARIO := ' ';
            NOMUSU  := ' ';
        END;
        -- OBTENER CANTIDAD DE FILAS --
        BEGIN
          SELECT COUNT(*) INTO FILAS FROM SNG122 WHERE SNG122INST = INST;
        EXCEPTION
          WHEN OTHERS THEN
            FILAS := 0;
        END;
      EXCEPTION
        WHEN OTHERS THEN
          -- GRABA LOG --
          CODERR := TO_CHAR(SQLCODE);
          MSGERR := SUBSTR(TRIM(SQLERRM), 11, 250);
          INSERT INTO AQPC277
          VALUES
            (pPGCOD,
             pITSUC,
             pITMOD,
             pITTRAN,
             pITNREL,
             pITORD,
             pITFCON,
             PAIS,
             TDOC,
             NDOC,
             NOMCLI,
             INST,
             PGCOD,
             MODULO,
             SUC,
             MDA,
             PAP,
             CTA,
             OPER,
             SBOP,
             TOPE,
             CANT,
             PGCODG,
             MODG,
             SUCG,
             MDAG,
             PAPG,
             CTAG,
             OPERG,
             SBOPG,
             TOPEG,
             pUSER,
             FECHA,
             HORA,
             EMISOR,
             DESTINO,
             DESTCPY,
             MENSAJE,
             ASUNTO,
             CODERR,
             MSGERR);
          COMMIT;
      END;
      -- VALIDAR SI EL CLIENTE TIENE UNA GARANTIA ASOCIADA --
      PQ_CR_VALI_CRED_CANC.SP_CR_VAL_TIPOPE_GR_2(PGCOD,
                                                 MODULO,
                                                 SUC,
                                                 MDA,
                                                 PAP,
                                                 CTA,
                                                 OPER,
                                                 SBOP,
                                                 TOPE,
                                                 EXSTGRTN,
                                                 NULO);
      IF EXSTGRTN = 'S' THEN
        -- OBTENER GARANTIA DEL CLIENTE --
        FOR J IN LST4 LOOP
          CANT   := CANT + 1;
          PGCODG := 0;
          MODG   := 0;
          SUCG   := 0;
          MDAG   := 0;
          PAPG   := 0;
          CTAG   := 0;
          OPERG  := 0;
          SBOPG  := 0;
          TOPEG  := 0;
        
          PGCODG := J.SNG122PGC;
          MODG   := J.SNG122MOD;
          SUCG   := J.SNG122SUC;
          MDAG   := J.SNG122MDA;
          PAPG   := J.SNG122PAP;
          CTAG   := J.SNG122CTA;
          OPERG  := J.SNG122OPER;
          SBOPG  := J.SNG122SBOP;
          TOPEG  := J.SNG122TOPE;
          -- OBTENER NOMBRE TIPO OPERACION GARANTIA --
          BEGIN
            SELECT TRIM(TONOM)
              INTO NOMTOPEG
              FROM FST004
             WHERE MODULO = MODG
               AND TOTOPE = TOPEG;
          EXCEPTION
            WHEN OTHERS THEN
              NOMTOPEG := ' ';
          END;
          -- OBTENER NOMBRE SUCURSAL GARANTIA --
          BEGIN
            SELECT TRIM(SCNOM)
              INTO NOMSUCG
              FROM FST001
             WHERE PGCOD = PGCODG
               AND SUCURS = SUCG;
          EXCEPTION
            WHEN OTHERS THEN
              NOMSUCG := ' ';
          END;
          -- OBTENER CODIGO DE REGION GARANTIA --
          BEGIN
            SELECT TO_NUMBER(SCDEPT)
              INTO DEPT
              FROM FST001
             WHERE SUCURS = SUCG;
            -- OBTENER NOMBRE REGION GARANTIA --
            BEGIN
              SELECT TRIM(DEPNOM)
                INTO NOMREGG
                FROM FST068
               WHERE DEPCOD = DEPT;
            EXCEPTION
              WHEN OTHERS THEN
                NOMREGG := ' ';
            END;
          EXCEPTION
            WHEN OTHERS THEN
              DEPT := 0;
          END;
          -- OBTENER INTEGRANTES DE LA GARANTIA --
          FOR X IN LST1 LOOP
            INTEGR := TRIM(INTEGR) || '<li>Cliente: ' || X.PENOM ||
                      '</li><li>DNI: ' || X.PENDOC || '</li>';
          END LOOP;
          -- OBTENER GARANTIAS ASOCIADAS --
          GRTASC := GRTASC || '<ul>
                               <li>Cuenta: ' || CTAG ||
                    '</li>
                               <li>Operacion: ' || OPERG ||
                    '</li>
                               <li>Tipo de Operación: ' ||
                    TOPEG || '' || ' - ' || '' || NOMTOPEG ||
                    '</li>
                               <li>Sucursal: ' ||
                    NOMSUCG || '</li>
                               <li>Región: ' || NOMREGG ||
                    '</li>
                               <li>Analista: ' ||
                    USUARIO || '' || ' - ' || '' || NOMUSU ||
                    '</li>
                             </ul>';
          -- ARMA MENSAJE --
          MENSAJE := '<html>
                        <head><style type="text/css"></style></head>
                        <body>
                          <p>Estimado.</p>
                          <p>Se realizó la emisión del Certificado de No Adeudo con glosa de garantía del crédito:</p>
                          <p>Cliente Titular: ' || NDOC ||
                     ' - ' || NOMCLI ||
                     '.</p>
                          <p>Cuenta: ' || CTA ||
                     ' y Operación: ' || OPER || '.</p>
                          <p>Datos de la garantía(s) asociada:</p>
                          ' || GRTASC || '
                          <p>Integrantes:</p>
                          <ul>
                            ' || INTEGR || '
                          </ul>
                        </body>
                      </html>';
          -- OBTENER CORREO DESTINATARIO --
          DESTINO := ' ';
          FOR I IN LST2 LOOP
            IF DESTINO = ' ' THEN
              -- OBTENER DOMINIO --
              DOMINIO := ' ';
              BEGIN
                SELECT TRIM(TP1DESC)
                  INTO DOMINIO
                  FROM FST198
                 WHERE TP1COD = 1
                   AND TP1COD1 = 111154
                   AND TP1CORR1 = 3
                   AND TP1CORR2 = 0
                   AND TP1CORR3 = I.TP1NRO1;
                DESTINO := TRIM(DESTINO) || TRIM(I.TP1DESC) || DOMINIO;
              EXCEPTION
                WHEN OTHERS THEN
                  DOMINIO := ' ';
              END;
            ELSE
              -- OBTENER DOMINIO --
              DOMINIO := ' ';
              BEGIN
                SELECT TRIM(TP1DESC)
                  INTO DOMINIO
                  FROM FST198
                 WHERE TP1COD = 1
                   AND TP1COD1 = 111154
                   AND TP1CORR1 = 3
                   AND TP1CORR2 = 0
                   AND TP1CORR3 = I.TP1NRO1;
                DESTINO := TRIM(DESTINO) || ';' || TRIM(I.TP1DESC) ||
                           DOMINIO;
              EXCEPTION
                WHEN OTHERS THEN
                  DOMINIO := ' ';
              END;
            END IF;
          END LOOP;
          -- OBTENER CORREO DESTINATARIO COPIA --
          DESTCPY := ' ';
          FOR E IN LST3 LOOP
            IF DESTCPY = ' ' THEN
              -- OBTENER DOMINIO --
              DOMINIO := ' ';
              BEGIN
                SELECT TRIM(TP1DESC)
                  INTO DOMINIO
                  FROM FST198
                 WHERE TP1COD = 1
                   AND TP1COD1 = 111154
                   AND TP1CORR1 = 3
                   AND TP1CORR2 = 0
                   AND TP1CORR3 = E.TP1NRO1;
                DESTCPY := TRIM(DESTCPY) || TRIM(E.TP1DESC) || DOMINIO;
              EXCEPTION
                WHEN OTHERS THEN
                  DOMINIO := ' ';
              END;
            ELSE
              -- OBTENER DOMINIO --
              DOMINIO := ' ';
              BEGIN
                SELECT TRIM(TP1DESC)
                  INTO DOMINIO
                  FROM FST198
                 WHERE TP1COD = 1
                   AND TP1COD1 = 111154
                   AND TP1CORR1 = 3
                   AND TP1CORR2 = 0
                   AND TP1CORR3 = E.TP1NRO1;
                DESTCPY := TRIM(DESTCPY) || ';' || TRIM(E.TP1DESC) ||
                           DOMINIO;
              EXCEPTION
                WHEN OTHERS THEN
                  DOMINIO := ' ';
              END;
            END IF;
          END LOOP;
          -- GRABA LOG --
          INSERT INTO AQPC277
          VALUES
            (pPGCOD,
             pITSUC,
             pITMOD,
             pITTRAN,
             pITNREL,
             pITORD,
             pITFCON,
             PAIS,
             TDOC,
             NDOC,
             NOMCLI,
             INST,
             PGCOD,
             MODULO,
             SUC,
             MDA,
             PAP,
             CTA,
             OPER,
             SBOP,
             TOPE,
             CANT,
             PGCODG,
             MODG,
             SUCG,
             MDAG,
             PAPG,
             CTAG,
             OPERG,
             SBOPG,
             TOPEG,
             pUSER,
             FECHA,
             HORA,
             EMISOR,
             DESTINO,
             DESTCPY,
             MENSAJE,
             ASUNTO,
             CODERR,
             MSGERR);
          COMMIT;
          IF CANT = FILAS THEN
            -- ENVIA CORREO --
            PQ_AH_PLANILLAS.P_SENDMAILATTACH(p_DestinatariosPara => DESTINO,
                                             p_DestinatariosCC   => DESTCPY,
                                             p_DestinatariosBcc  => ' ',
                                             p_Mensaje           => MENSAJE,
                                             p_Remitente         => EMISOR,
                                             p_Asunto            => ASUNTO,
                                             p_TipoMensaje       => 'HTML',
                                             p_Directorio        => ' ',
                                             p_ArchivosAdjuntos  => ' ',
                                             p_c_coderr          => CODERR,
                                             p_c_deserr          => MSGERR);
            IF MSGERR IS NOT NULL THEN
              -- ACTUALIZA LOG --
              UPDATE AQPC277
                 SET AQPC277CODERR = CODERR, AQPC277MSGERR = MSGERR
               WHERE AQPC277ITCOD = pPGCOD
                 AND AQPC277ITSUC = pITSUC
                 AND AQPC277ITMOD = pITMOD
                 AND AQPC277ITTRAN = pITTRAN
                 AND AQPC277ITNREL = pITNREL
                 AND AQPC277ITORD = pITORD
                 AND AQPC277ITFCON = pITFCON;
              COMMIT;
            ELSE
              -- ACTUALIZA LOG --
              CODERR := '00000';
              MSGERR := 'OK';
              UPDATE AQPC277
                 SET AQPC277CODERR = CODERR, AQPC277MSGERR = MSGERR
               WHERE AQPC277ITCOD = pPGCOD
                 AND AQPC277ITSUC = pITSUC
                 AND AQPC277ITMOD = pITMOD
                 AND AQPC277ITTRAN = pITTRAN
                 AND AQPC277ITNREL = pITNREL
                 AND AQPC277ITORD = pITORD
                 AND AQPC277ITFCON = pITFCON;
              COMMIT;
            END IF;
          END IF;
        END LOOP;
      ELSE
        -- GRABA LOG --
        BEGIN
          CODERR := '00001';
          MSGERR := 'EL CLIENTE NO TIENE UNA GARANTIA ASOCIADA';
          INSERT INTO AQPC277
          VALUES
            (pPGCOD,
             pITSUC,
             pITMOD,
             pITTRAN,
             pITNREL,
             pITORD,
             pITFCON,
             PAIS,
             TDOC,
             NDOC,
             NOMCLI,
             INST,
             PGCOD,
             MODULO,
             SUC,
             MDA,
             PAP,
             CTA,
             OPER,
             SBOP,
             TOPE,
             CANT,
             PGCODG,
             MODG,
             SUCG,
             MDAG,
             PAPG,
             CTAG,
             OPERG,
             SBOPG,
             TOPEG,
             pUSER,
             FECHA,
             HORA,
             EMISOR,
             DESTINO,
             DESTCPY,
             MENSAJE,
             ASUNTO,
             CODERR,
             MSGERR);
          COMMIT;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      END IF;
    ELSE
      BEGIN
        -- GRABA LOG --
        CODERR := '00001';
        MSGERR := 'ESTA DESACTIVADO LA ALERTA CNA';
        INSERT INTO AQPC277
        VALUES
          (pPGCOD,
           pITSUC,
           pITMOD,
           pITTRAN,
           pITNREL,
           pITORD,
           pITFCON,
           PAIS,
           TDOC,
           NDOC,
           NOMCLI,
           INST,
           PGCOD,
           MODULO,
           SUC,
           MDA,
           PAP,
           CTA,
           OPER,
           SBOP,
           TOPE,
           CANT,
           PGCODG,
           MODG,
           SUCG,
           MDAG,
           PAPG,
           CTAG,
           OPERG,
           SBOPG,
           TOPEG,
           pUSER,
           FECHA,
           HORA,
           EMISOR,
           DESTINO,
           DESTCPY,
           MENSAJE,
           ASUNTO,
           CODERR,
           MSGERR);
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      -- GRABA LOG --
      CODERR := TO_CHAR(SQLCODE);
      MSGERR := SUBSTR(TRIM(SQLERRM), 11, 250);
      INSERT INTO AQPC277
      VALUES
        (pPGCOD,
         pITSUC,
         pITMOD,
         pITTRAN,
         pITNREL,
         pITORD,
         pITFCON,
         PAIS,
         TDOC,
         NDOC,
         NOMCLI,
         INST,
         PGCOD,
         MODULO,
         SUC,
         MDA,
         PAP,
         CTA,
         OPER,
         SBOP,
         TOPE,
         CANT,
         PGCODG,
         MODG,
         SUCG,
         MDAG,
         PAPG,
         CTAG,
         OPERG,
         SBOPG,
         TOPEG,
         pUSER,
         FECHA,
         HORA,
         EMISOR,
         DESTINO,
         DESTCPY,
         MENSAJE,
         ASUNTO,
         CODERR,
         MSGERR);
      COMMIT;
  END;

end PQ_CR_ENVIO_ALERTA_CNA;
/

