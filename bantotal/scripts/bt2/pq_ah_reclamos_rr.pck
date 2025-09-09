CREATE OR REPLACE PACKAGE PQ_AH_RECLAMOS_RR IS
  -- ***************************************************************************************
  -- Nombre                     : PQ_AH_RECLAMOS_RR
  -- Sistema                    : BANTOTAL
  -- Módulo                     : RECLAMOS
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2023.11.15
  -- Autor de Creación          : CVILLON
  -- Uso                        : GENRACION DE REPORTES RR
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2025.06.23
  -- Modificado                 : CVILLON
  -- Descripción                : Tiempo Promedio de Absolución (Redondeo)
  -- ***************************************************************************************
  ---*********
  PROCEDURE SP_AH_REP_RR1_GENERA_BASE(P_CREUSR IN VARCHAR,
                                      P_FECINI IN DATE,
                                      P_FECFIN IN DATE,
                                      P_ERRCOD OUT VARCHAR,
                                      P_ERRMSG OUT VARCHAR);

  PROCEDURE SP_AH_REP_RR1_GENERA_REPORTE(P_CREUSR IN VARCHAR,
                                         P_ERRCOD OUT VARCHAR,
                                         P_ERRMSG OUT VARCHAR);

  PROCEDURE SP_AH_REP_RR1_REC_ABSUELTO_LINEA_TPA(P_FECINI       IN DATE,
                                                 P_FECFIN       IN DATE,
                                                 P_CANOPEC      IN NUMBER,
                                                 P_RECOPSC      IN NUMBER,
                                                 P_CANING       IN NUMBER,
                                                 P_UGPRREC      IN NUMBER,
                                                 P_RECMTVC      IN NUMBER,
                                                 P_RECSMTC      IN NUMBER,
                                                 P_BANSEG       IN NUMBER,
                                                 P_CANRESC      IN NUMBER,
                                                 P_TPA_NO_RECON OUT NUMBER,
                                                 P_TPA_SI_RECON OUT NUMBER,
                                                 P_ERRCOD       OUT VARCHAR,
                                                 P_ERRMSG       OUT VARCHAR);

  PROCEDURE SP_AH_REP_RR1_REC_ABSUELTO_RANGO_LINEA_P(P_FECINI          IN DATE,
                                                     P_FECFIN          IN DATE,
                                                     P_CANOPEC         IN NUMBER,
                                                     P_RECOPSC         IN NUMBER,
                                                     P_CANING          IN NUMBER,
                                                     P_UGPRREC         IN NUMBER,
                                                     P_RECMTVC         IN NUMBER,
                                                     P_RECSMTC         IN NUMBER,
                                                     P_BANSEG          IN NUMBER,
                                                     P_CANRESC         IN NUMBER,
                                                     P_RANINI          IN NUMBER,
                                                     P_RANFIN          IN NUMBER,
                                                     P_AFAVOR          IN VARCHAR,
                                                     P_QTY_NO_RECON_SP OUT NUMBER,
                                                     P_QTY_NO_RECON_CP OUT NUMBER,
                                                     P_QTY_SI_RECON_SP OUT NUMBER,
                                                     P_QTY_SI_RECON_CP OUT NUMBER,
                                                     P_ERRCOD          OUT VARCHAR,
                                                     P_ERRMSG          OUT VARCHAR);

  PROCEDURE SP_AH_REP_RR1_RECIBIDOS_PERIODO(P_FECINI  IN DATE,
                                            P_FECFIN  IN DATE,
                                            P_CANOPEC IN NUMBER,
                                            P_RECOPSC IN NUMBER,
                                            P_CANING  IN NUMBER,
                                            P_UGPRREC IN NUMBER,
                                            P_RECMTVC IN NUMBER,
                                            P_RECSMTC IN NUMBER,
                                            P_BANSEG  IN NUMBER,
                                            P_RECQTY  OUT NUMBER,
                                            P_ERRCOD  OUT VARCHAR,
                                            P_ERRMSG  OUT VARCHAR);

  PROCEDURE SP_AH_REP_RR1_RECIBIDOS_PERIODO_R(P_FECINI    IN DATE,
                                              P_FECFIN    IN DATE,
                                              P_CANOPEC   IN NUMBER,
                                              P_RECOPSC   IN NUMBER,
                                              P_CANING    IN NUMBER,
                                              P_UGPRREC   IN NUMBER,
                                              P_RECMTVC   IN NUMBER,
                                              P_RECSMTC   IN NUMBER,
                                              P_BANSEG    IN NUMBER,
                                              P_CANRESC   IN NUMBER,
                                              P_RECQTY_NR OUT NUMBER,
                                              P_RECQTY_SR OUT NUMBER,
                                              P_ERRCOD    OUT VARCHAR,
                                              P_ERRMSG    OUT VARCHAR);

  PROCEDURE SP_AH_REP_RR1_REC_TRAMITE_RANGO_LINEA_P(P_FECINI          IN DATE,
                                                    P_FECFIN          IN DATE,
                                                    P_CANOPEC         IN NUMBER,
                                                    P_RECOPSC         IN NUMBER,
                                                    P_CANING          IN NUMBER,
                                                    P_UGPRREC         IN NUMBER,
                                                    P_RECMTVC         IN NUMBER,
                                                    P_RECSMTC         IN NUMBER,
                                                    P_BANSEG          IN NUMBER,
                                                    P_CANRESC         IN NUMBER,
                                                    P_RANINI          IN NUMBER,
                                                    P_RANFIN          IN NUMBER,
                                                    P_QTY_NO_RECON_SP OUT NUMBER,
                                                    P_QTY_NO_RECON_CP OUT NUMBER,
                                                    P_QTY_SI_RECON_SP OUT NUMBER,
                                                    P_QTY_SI_RECON_CP OUT NUMBER,
                                                    P_ERRCOD          OUT VARCHAR,
                                                    P_ERRMSG          OUT VARCHAR);

  PROCEDURE SP_AH_REP_RR1_REC_TRAMITE_TOTAL_LINEA(P_FECINI    IN DATE,
                                                  P_FECFIN    IN DATE,
                                                  P_CANOPEC   IN NUMBER,
                                                  P_RECOPSC   IN NUMBER,
                                                  P_CANING    IN NUMBER,
                                                  P_UGPRREC   IN NUMBER,
                                                  P_RECMTVC   IN NUMBER,
                                                  P_RECSMTC   IN NUMBER,
                                                  P_BANSEG    IN NUMBER,
                                                  P_CANRESC   IN NUMBER,
                                                  P_RECQTY_NR OUT NUMBER,
                                                  P_RECQTY_SR OUT NUMBER,
                                                  P_ERRCOD    OUT VARCHAR,
                                                  P_ERRMSG    OUT VARCHAR);

  PROCEDURE SP_AH_REP_RR1_GENERA_REPORTE_TEST(P_CREUSR IN VARCHAR,
                                              P_ERRCOD OUT VARCHAR,
                                              P_ERRMSG OUT VARCHAR);

  PROCEDURE SP_AH_REP_ESTADISTICA_F(P_CREUSR IN VARCHAR,
                                    P_FECINI IN DATE,
                                    P_FECFIN IN DATE,
                                    P_ERRCOD OUT VARCHAR,
                                    P_ERRMSG OUT VARCHAR);

  PROCEDURE SP_AH_REP_ESTADISTICA(P_CREUSR IN VARCHAR,
                                  P_FECINI IN DATE,
                                  P_FECFIN IN DATE,
                                  P_ERRCOD OUT VARCHAR,
                                  P_ERRMSG OUT VARCHAR);

  PROCEDURE SP_AH_REP_ESTADISTICA_TRA(P_FECINI IN DATE,
                                      P_FECFIN IN DATE,
                                      P_TRA    OUT NUMBER,
                                      P_ERRCOD OUT VARCHAR,
                                      P_ERRMSG OUT VARCHAR);

  PROCEDURE SP_AH_REP_ESTADISTICA_TPA(P_FECINI IN DATE,
                                      P_FECFIN IN DATE,
                                      P_TPAV   OUT NUMBER,
                                      P_TPAR   OUT NUMBER,
                                      P_ERRCOD OUT VARCHAR,
                                      P_ERRMSG OUT VARCHAR);

  PROCEDURE SP_AH_REP_ESTADISTICA_TRRP(P_FECINI IN DATE,
                                       P_FECFIN IN DATE,
                                       P_TRRP   OUT NUMBER,
                                       P_ERRCOD OUT VARCHAR,
                                       P_ERRMSG OUT VARCHAR);

  PROCEDURE SP_AH_REP_ESTADISTICA_TOTTRA(P_FECINI IN DATE,
                                         P_FECFIN IN DATE,
                                         P_TRT    OUT NUMBER,
                                         P_ERRCOD OUT VARCHAR,
                                         P_ERRMSG OUT VARCHAR);

  PROCEDURE SP_AH_REP_RR3_GENERA_BASE(P_CREUSR IN VARCHAR,
                                      P_FECINI IN DATE,
                                      P_FECFIN IN DATE,
                                      P_ERRCOD OUT VARCHAR,
                                      P_ERRMSG OUT VARCHAR);

  PROCEDURE SP_AH_REP_RR2_GENERA_REP(P_CREUSR IN VARCHAR,
                                     P_FECINI IN DATE,
                                     P_FECFIN IN DATE,
                                     P_ERRCOD OUT VARCHAR,
                                     P_ERRMSG OUT VARCHAR);

END PQ_AH_RECLAMOS_RR;
/* GOLDENGATE_DDL_REPLICATION */
/
CREATE OR REPLACE PACKAGE BODY PQ_AH_RECLAMOS_RR IS
  -- ***************************************************************************************
  -- Nombre                     : PQ_AH_RECLAMOS_RR
  -- Sistema                    : BANTOTAL
  -- Módulo                     : RECLAMOS
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2023.11.15
  -- Autor de Creación          : CVILLON
  -- Uso                        : GENRACION DE REPORTES RR
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2025.06.23
  -- Modificado                 : CVILLON
  -- Descripción                : Tiempo Promedio de Absolución (Redondeo)
  -- ***************************************************************************************
  ---*********
  PROCEDURE SP_AH_REP_RR1_GENERA_BASE(P_CREUSR IN VARCHAR,
                                      P_FECINI IN DATE,
                                      P_FECFIN IN DATE,
                                      P_ERRCOD OUT VARCHAR,
                                      P_ERRMSG OUT VARCHAR) IS
  
    lv_RR1KEYE VARCHAR(50);
    lv_RR1KEYG VARCHAR(50);
    ln_CANOPE  NUMBER(9);
    ln_CANING  NUMBER(9);
    lv_UGPRRE  VARCHAR(20);
    ln_SEGCOD  NUMBER(9);
    ln_RECOPS  NUMBER(9);
    ln_RECMTV  NUMBER(9);
    ln_RECSMT  NUMBER(9);
    ln_EXISTE  NUMBER(9);
  
    ln_CANOPEC NUMBER(9);
    ln_RECOPSC NUMBER(9);
    ln_UGPRREC NUMBER(9);
    ln_RECMTVC NUMBER(9);
    ln_RECSMTC NUMBER(9);
  
    ln_REITER  NUMBER(1);
    ln_BANSEG  NUMBER(1);
    ln_CANRESS NUMBER(9);
    ln_CANRESC NUMBER(9);
  
  BEGIN
    ---***
    P_ERRCOD := '000';
    P_ERRMSG := NULL;
    ---***
    DELETE FROM AQPB548 WHERE AQPB548CREUSR = P_CREUSR;
    COMMIT;
    ---***
    --RECLAMOS RECIBIDOS EN EL PERIODO
    --RECLAMOS RESPONDIDOS EN EL PERIODO
    --RECLAMOS QUE ESTABAN EN TRAMITE EN EL PERIODO
    --RECLAMOS QUE AUN ESTAN EN TRAMITE DE ANTES DEL PERIODO
    FOR XREC IN (SELECT *
                   FROM JAQL420
                  WHERE JAQL420TRC = 1
                    AND JAQL420ESR IN (1, 2, 3)
                    AND JAQL420FCR <= P_FECFIN
                    AND JAQL420OPS <> ' '
                    AND JAQL420COD NOT IN
                        (SELECT AQPB545BCOD
                           FROM AQPB545B
                          WHERE AQPB545BRTIP = 'REI')
                    AND ((JAQL420FCR BETWEEN P_FECINI AND P_FECFIN) OR
                        (JAQL420ESR = 3 AND JAQL420FCCCLI BETWEEN P_FECINI AND
                        P_FECFIN) OR
                        (JAQL420ESR = 3 AND JAQL420FCR < P_FECINI AND
                        JAQL420FCCCLI > P_FECFIN) OR
                        (JAQL420ESR IN (1, 2) AND JAQL420FCR < P_FECINI))) LOOP
    
      ---***
      ln_EXISTE  := 0;
      lv_RR1KEYE := '000';
      lv_RR1KEYG := '000';
      ln_CANOPE  := NULL;
      ln_CANING  := NULL;
      lv_UGPRRE  := NULL;
      ln_SEGCOD  := NULL;
      ln_RECOPS  := NULL;
      ln_RECMTV  := NULL;
      ln_RECSMT  := NULL;
    
      ln_CANOPEC := NULL;
      ln_RECOPSC := NULL;
      ln_UGPRREC := NULL;
      ln_RECMTVC := NULL;
      ln_RECSMTC := NULL;
    
      ---***
      ---*** KEY DEL RECLAMO
      -- Canal de Operacion
      ln_CANOPEC := XREC.JAQL420CAN;
      BEGIN
        SELECT JAQL422CSBS
          INTO ln_CANOPE
          FROM JAQL422C
         WHERE JAQL422CCOD = XREC.JAQL420CAN;
      EXCEPTION
        WHEN OTHERS THEN
          ln_CANOPE := 0;
      END;
      -- Canal de Ingreso
      ln_CANING := XREC.JAQL420CANING;
      -- Canal de Respuesta
      ln_CANRESC := XREC.JAQL420VRP;
    
      BEGIN
        SELECT TP1NRO2
          INTO ln_CANRESS
          FROM FST198
         WHERE TP1COD = 1
           AND TP1COD1 = 10871
           AND TP1CORR1 = 3
           AND TP1CORR2 = 4
           AND TP1NRO1 = 1
           AND TP1CORR3 = ln_CANRESC;
      EXCEPTION
        WHEN OTHERS THEN
          ln_CANRESS := 0;
      END;
    
      -- UBIGEO Presentacion
      ln_UGPRREC := XREC.JAQL420UGPRPR;
      lv_UGPRRE  := LPAD(TO_CHAR(XREC.JAQL420UGPRPR), 4, '0');
    
      ln_BANSEG := 0;
      IF (XREC.JAQL420TIPPRO = 'S') THEN
        ln_BANSEG := 1;
      END IF;
      --*** OPS
      BEGIN
        ln_RECOPSC := XREC.JAQL420OPS;
      EXCEPTION
        WHEN OTHERS THEN
          ln_RECOPSC := 0;
      END;
      --***
      BEGIN
        SELECT JAQL421SBS
          INTO ln_RECOPS
          FROM JAQL421
         WHERE JAQL421COD = XREC.JAQL420OPS;
      EXCEPTION
        WHEN OTHERS THEN
          ln_RECOPS := 0;
      END;
      -- Motivo
      ln_RECMTVC := XREC.JAQL420MOT;
      BEGIN
        SELECT JAQL422SBS
          INTO ln_RECMTV
          FROM JAQL422
         WHERE JAQL422COD = XREC.JAQL420MOT;
      EXCEPTION
        WHEN OTHERS THEN
          ln_RECMTV := 0;
      END;
      ---***
    
      -- SUB MOTIVO
      BEGIN
        SELECT AQPB545MSSBS, AQPB545MSCOD
          INTO ln_RECSMT, ln_RECSMTC
          FROM AQPB545M
         WHERE AQPB545MREMP = 1
           AND AQPB545MRCOD = XREC.JAQL420COD;
      EXCEPTION
        WHEN OTHERS THEN
          ln_RECSMT  := 0;
          ln_RECSMTC := 0;
      END;
      ---***
      ---*** RR1 KEY
      -- canal de operación
      -- operación-servicio-producto
      -- canal de ingreso del reclamo
      -- ubicación geográfica de presentación del reclamo
      -- motivo del reclamo
      -- submotivo
      -- Key General no contiene 'Reiteracion' pero si contiene Canal de Respuesta
      -- No es Necesario Incluir BancaSeguros porque la OPS Nos lo Indica
      lv_RR1KEYG := TRIM(TO_CHAR(ln_CANOPE)) || '-' ||
                    TRIM(TO_CHAR(ln_RECOPS)) || '-' ||
                    TRIM(TO_CHAR(ln_CANING)) || '-' || TRIM(lv_UGPRRE) || '-' ||
                    TRIM(TO_CHAR(ln_RECMTV)) || '-' ||
                    TRIM(TO_CHAR(ln_RECSMT)) || '-' ||
                    TRIM(TO_CHAR(ln_CANRESS));
    
      ---***
      SELECT COUNT(*)
        INTO ln_EXISTE
        FROM AQPB548
       WHERE AQPB548CREUSR = P_CREUSR
         AND AQPB548RR1KEYG = lv_RR1KEYG;
      --DBMS_OUTPUT.PUT_LINE('RECLAMO:= ' || XREC.JAQL420COD);
      --DBMS_OUTPUT.PUT_LINE('ln_EXISTE:= ' || ln_EXISTE);
    
      IF (ln_EXISTE = 0) THEN
        INSERT INTO AQPB548
          (AQPB548CREUSR,
           AQPB548CRETIM,
           AQPB548FECINI,
           AQPB548FECFIN,
           AQPB548RR1KEYE,
           AQPB548RR1KEYG,
           AQPB548CANOPES,
           AQPB548RECOPSS,
           AQPB548CANINGS,
           AQPB548UGPRRES,
           AQPB548RECMTVS,
           AQPB548RECSMTS,
           AQPB548REITER,
           AQPB548BANSEG,
           AQPB548CANRESS,
           AQPB548CANOPEC,
           AQPB548RECOPSC,
           AQPB548UGPRREC,
           AQPB548RECMTVC,
           AQPB548RECSMTC,
           AQPB548CANRESC)
        VALUES
          (P_CREUSR,
           SYSDATE,
           P_FECINI,
           P_FECFIN,
           lv_RR1KEYG || '1',
           lv_RR1KEYG,
           ln_CANOPE,
           ln_RECOPS,
           ln_CANING,
           lv_UGPRRE,
           ln_RECMTV,
           ln_RECSMT,
           1,
           ln_BANSEG,
           ln_CANRESS,
           ln_CANOPEC,
           ln_RECOPSC,
           ln_UGPRREC,
           ln_RECMTVC,
           ln_RECSMTC,
           ln_CANRESC);
      
        INSERT INTO AQPB548
          (AQPB548CREUSR,
           AQPB548CRETIM,
           AQPB548FECINI,
           AQPB548FECFIN,
           AQPB548RR1KEYE,
           AQPB548RR1KEYG,
           AQPB548CANOPES,
           AQPB548RECOPSS,
           AQPB548CANINGS,
           AQPB548UGPRRES,
           AQPB548RECMTVS,
           AQPB548RECSMTS,
           AQPB548REITER,
           AQPB548BANSEG,
           AQPB548CANRESS,
           AQPB548CANOPEC,
           AQPB548RECOPSC,
           AQPB548UGPRREC,
           AQPB548RECMTVC,
           AQPB548RECSMTC,
           AQPB548CANRESC)
        VALUES
          (P_CREUSR,
           SYSDATE,
           P_FECINI,
           P_FECFIN,
           lv_RR1KEYG || '2',
           lv_RR1KEYG,
           ln_CANOPE,
           ln_RECOPS,
           ln_CANING,
           lv_UGPRRE,
           ln_RECMTV,
           ln_RECSMT,
           2,
           ln_BANSEG,
           ln_CANRESS,
           ln_CANOPEC,
           ln_RECOPSC,
           ln_UGPRREC,
           ln_RECMTVC,
           ln_RECSMTC,
           ln_CANRESC);
      END IF;
      ---***
    ---***
    END LOOP;
    ---***
    COMMIT;
    ---***
  EXCEPTION
    WHEN OTHERS THEN
      ---***
      P_ERRCOD := '001';
      P_ERRMSG := sqlcode || ' ->>> ' || sqlerrm;
      ROLLBACK;
      ---***
  END SP_AH_REP_RR1_GENERA_BASE;

  PROCEDURE SP_AH_REP_RR1_GENERA_REPORTE(P_CREUSR IN VARCHAR,
                                         P_ERRCOD OUT VARCHAR,
                                         P_ERRMSG OUT VARCHAR) IS
  
    ---*** Columnas
    ln_QTYRECPER NUMBER(9); -- Cantidad de Reclamos del Periodo
    ---
    ln_TR1A15_NR_TL NUMBER(9);
    ln_TR1A15_NR_SP NUMBER(9);
    ln_TR1A15_NR_CP NUMBER(9);
  
    ln_TR1A15_SR_TL NUMBER(9);
    ln_TR1A15_SR_SP NUMBER(9);
    ln_TR1A15_SR_CP NUMBER(9);
    ---
    ln_TRM15C_NR_TL NUMBER(9);
    ln_TRM15C_NR_SP NUMBER(9);
    ln_TRM15C_NR_CP NUMBER(9);
  
    ln_TRM15C_SR_TL NUMBER(9);
    ln_TRM15C_SR_SP NUMBER(9);
    ln_TRM15C_SR_CP NUMBER(9);
    ---
  
    ln_TRM15S NUMBER(9);
    ln_TRTOTA NUMBER(9);
  
    ln_RTOTAL_NR_LN NUMBER(9);
    ln_RTOTAL_SR_LN NUMBER(9);
    ln_TIMPRO_NR_LN NUMBER(9, 2);
    ln_TIMPRO_SR_LN NUMBER(9, 2);
  
    ln_AE_QTY_NR_SP_1 NUMBER(9);
    ln_AE_QTY_NR_CP_1 NUMBER(9);
    ln_AE_QTY_SR_SP_1 NUMBER(9);
    ln_AE_QTY_SR_CP_1 NUMBER(9);
  
    ln_AE_QTY_NR_SP_2 NUMBER(9);
    ln_AE_QTY_NR_CP_2 NUMBER(9);
    ln_AE_QTY_SR_SP_2 NUMBER(9);
    ln_AE_QTY_SR_CP_2 NUMBER(9);
  
    ln_AE_QTY_NR_SP_3 NUMBER(9);
    ln_AE_QTY_NR_CP_3 NUMBER(9);
    ln_AE_QTY_SR_SP_3 NUMBER(9);
    ln_AE_QTY_SR_CP_3 NUMBER(9);
  
    ln_AE_QTY_NR_SP_4 NUMBER(9);
    ln_AE_QTY_NR_CP_4 NUMBER(9);
    ln_AE_QTY_SR_SP_4 NUMBER(9);
    ln_AE_QTY_SR_CP_4 NUMBER(9);
  
    ln_AE_QTY_NR_SP_5 NUMBER(9);
    ln_AE_QTY_NR_CP_5 NUMBER(9);
    ln_AE_QTY_SR_SP_5 NUMBER(9);
    ln_AE_QTY_SR_CP_5 NUMBER(9);
  
    ln_AE_QTY_NR_TL NUMBER(9);
    ln_AE_QTY_SR_TL NUMBER(9);
  
    ln_AU_QTY_NR_SP_1 NUMBER(9);
    ln_AU_QTY_NR_CP_1 NUMBER(9);
    ln_AU_QTY_SR_SP_1 NUMBER(9);
    ln_AU_QTY_SR_CP_1 NUMBER(9);
  
    ln_AU_QTY_NR_SP_2 NUMBER(9);
    ln_AU_QTY_NR_CP_2 NUMBER(9);
    ln_AU_QTY_SR_SP_2 NUMBER(9);
    ln_AU_QTY_SR_CP_2 NUMBER(9);
  
    ln_AU_QTY_NR_SP_3 NUMBER(9);
    ln_AU_QTY_NR_CP_3 NUMBER(9);
    ln_AU_QTY_SR_SP_3 NUMBER(9);
    ln_AU_QTY_SR_CP_3 NUMBER(9);
  
    ln_AU_QTY_NR_SP_4 NUMBER(9);
    ln_AU_QTY_NR_CP_4 NUMBER(9);
    ln_AU_QTY_SR_SP_4 NUMBER(9);
    ln_AU_QTY_SR_CP_4 NUMBER(9);
  
    ln_AU_QTY_NR_SP_5 NUMBER(9);
    ln_AU_QTY_NR_CP_5 NUMBER(9);
    ln_AU_QTY_SR_SP_5 NUMBER(9);
    ln_AU_QTY_SR_CP_5 NUMBER(9);
  
    ln_AU_QTY_NR_TL NUMBER(9);
    ln_AU_QTY_SR_TL NUMBER(9);
  
    ln_TPA_NO_RECON NUMBER(9, 2);
    ln_TPA_SI_RECON NUMBER(9, 2);
    ---***
    ln_RECQTY_NR NUMBER(9);
    ln_RECQTY_SR NUMBER(9);
  
    lv_ERRCOD VARCHAR(3);
    lv_ERRMSG VARCHAR(600);
    ---***
  
  BEGIN
  
    P_ERRCOD := '000';
    P_ERRMSG := '';
    ---*** Columnas
    ln_QTYRECPER := 0;
    ---
    ln_TR1A15_NR_SP := 0;
    ln_TR1A15_NR_CP := 0;
    ln_TR1A15_SR_SP := 0;
    ln_TR1A15_SR_CP := 0;
    ---
    ln_TRM15C_NR_SP := 0;
    ln_TRM15C_NR_CP := 0;
    ln_TRM15C_SR_SP := 0;
    ln_TRM15C_SR_CP := 0;
    ---
    ln_AE_QTY_NR_SP_1 := 0;
    ln_AE_QTY_NR_CP_1 := 0;
    ln_AE_QTY_SR_SP_1 := 0;
    ln_AE_QTY_SR_CP_1 := 0;
  
    ln_AE_QTY_NR_SP_2 := 0;
    ln_AE_QTY_NR_CP_2 := 0;
    ln_AE_QTY_SR_SP_2 := 0;
    ln_AE_QTY_SR_CP_2 := 0;
  
    ln_AE_QTY_NR_SP_3 := 0;
    ln_AE_QTY_NR_CP_3 := 0;
    ln_AE_QTY_SR_SP_3 := 0;
    ln_AE_QTY_SR_CP_3 := 0;
  
    ln_AE_QTY_NR_SP_4 := 0;
    ln_AE_QTY_NR_CP_4 := 0;
    ln_AE_QTY_SR_SP_4 := 0;
    ln_AE_QTY_SR_CP_4 := 0;
  
    ln_AE_QTY_NR_SP_5 := 0;
    ln_AE_QTY_NR_CP_5 := 0;
    ln_AE_QTY_SR_SP_5 := 0;
    ln_AE_QTY_SR_CP_5 := 0;
  
    ln_AE_QTY_NR_TL := 0;
    ln_AE_QTY_SR_TL := 0;
  
    ln_AU_QTY_NR_SP_1 := 0;
    ln_AU_QTY_NR_CP_1 := 0;
    ln_AU_QTY_SR_SP_1 := 0;
    ln_AU_QTY_SR_CP_1 := 0;
  
    ln_AU_QTY_NR_SP_2 := 0;
    ln_AU_QTY_NR_CP_2 := 0;
    ln_AU_QTY_SR_SP_2 := 0;
    ln_AU_QTY_SR_CP_2 := 0;
  
    ln_AU_QTY_NR_SP_3 := 0;
    ln_AU_QTY_NR_CP_3 := 0;
    ln_AU_QTY_SR_SP_3 := 0;
    ln_AU_QTY_SR_CP_3 := 0;
  
    ln_AU_QTY_NR_SP_4 := 0;
    ln_AU_QTY_NR_CP_4 := 0;
    ln_AU_QTY_SR_SP_4 := 0;
    ln_AU_QTY_SR_CP_4 := 0;
  
    ln_AU_QTY_NR_SP_5 := 0;
    ln_AU_QTY_NR_CP_5 := 0;
    ln_AU_QTY_SR_SP_5 := 0;
    ln_AU_QTY_SR_CP_5 := 0;
  
    ln_AU_QTY_NR_TL := 0;
    ln_AU_QTY_SR_TL := 0;
  
    ln_RTOTAL_NR_LN := 0;
    ln_RTOTAL_SR_LN := 0;
    ln_TIMPRO_NR_LN := 0;
    ln_TIMPRO_SR_LN := 0;
  
    ln_TPA_NO_RECON := 0;
    ln_TPA_SI_RECON := 0;
    ---***
    ln_RECQTY_NR := 0; -- No Reconsideracion
    ln_RECQTY_SR := 0; -- Si Reconsideracion
  
    lv_ERRCOD := '000';
    lv_ERRMSG := '';
    ---***
  
    ---***
    DELETE FROM AQPB548A WHERE AQPB548ACREUSR = P_CREUSR;
    COMMIT;
    ---***
    FOR XROW IN (SELECT *
                   FROM AQPB548
                  WHERE AQPB548CREUSR = P_CREUSR
                    AND AQPB548REITER = 1
                  ORDER BY AQPB548RECOPSS, AQPB548RECMTVS, AQPB548UGPRRES)
    
     LOOP
      --DBMS_OUTPUT.PUT_LINE('*************************************************');
      --DBMS_OUTPUT.PUT_LINE('AQPB548RR1KEYE:= ' || XROW.AQPB548RR1KEYE);
      --DBMS_OUTPUT.PUT_LINE('XROW.AQPB548FECINI:= ' || XROW.AQPB548FECINI);
      --DBMS_OUTPUT.PUT_LINE('XROW.AQPB548FECFIN:= ' || XROW.AQPB548FECFIN);
      --DBMS_OUTPUT.PUT_LINE('XROW.AQPB548CANOPEC:= ' || XROW.AQPB548CANOPEC);
      --DBMS_OUTPUT.PUT_LINE('XROW.AQPB548RECOPSC:= ' || XROW.AQPB548RECOPSC);
      --DBMS_OUTPUT.PUT_LINE('XROW.AQPB548CANINGS:= ' || XROW.AQPB548CANINGS);
      --DBMS_OUTPUT.PUT_LINE('XROW.AQPB548UGPRREC:= ' || XROW.AQPB548UGPRREC);
      --DBMS_OUTPUT.PUT_LINE('XROW.AQPB548RECMTVC:= ' || XROW.AQPB548RECMTVC);
      --DBMS_OUTPUT.PUT_LINE('XROW.AQPB548RECSMTC:= ' || XROW.AQPB548RECSMTC);
      ---***
      ln_RECQTY_NR := 0;
      ln_RECQTY_SR := 0;
      lv_ERRCOD    := '000';
      lv_ERRMSG    := '';
    
      ln_TR1A15_NR_TL := 0;
      ln_TR1A15_NR_SP := 0;
      ln_TR1A15_NR_CP := 0;
      ln_TRM15C_NR_CP := 0;
      ln_TRM15C_NR_SP := 0;
    
      ln_TR1A15_SR_TL := 0;
      ln_TR1A15_SR_SP := 0;
      ln_TR1A15_SR_CP := 0;
      ln_TRM15C_SR_CP := 0;
      ln_TRM15C_SR_SP := 0;
    
      ln_RTOTAL_NR_LN := 0;
      ln_RTOTAL_SR_LN := 0;
      ln_TIMPRO_NR_LN := 0;
      ln_TIMPRO_SR_LN := 0;
    
      PQ_AH_RECLAMOS_RR.SP_AH_REP_RR1_RECIBIDOS_PERIODO_R(XROW.AQPB548FECINI,
                                                          XROW.AQPB548FECFIN,
                                                          XROW.AQPB548CANOPEC,
                                                          XROW.AQPB548RECOPSC,
                                                          XROW.AQPB548CANINGS,
                                                          XROW.AQPB548UGPRREC,
                                                          XROW.AQPB548RECMTVC,
                                                          XROW.AQPB548RECSMTC,
                                                          XROW.AQPB548BANSEG,
                                                          XROW.AQPB548CANRESC,
                                                          ln_RECQTY_NR,
                                                          ln_RECQTY_SR,
                                                          lv_ERRCOD,
                                                          lv_ERRMSG);
    
      PQ_AH_RECLAMOS_RR.SP_AH_REP_RR1_REC_TRAMITE_RANGO_LINEA_P(XROW.AQPB548FECINI,
                                                                XROW.AQPB548FECFIN,
                                                                XROW.AQPB548CANOPEC,
                                                                XROW.AQPB548RECOPSC,
                                                                XROW.AQPB548CANINGS,
                                                                XROW.AQPB548UGPRREC,
                                                                XROW.AQPB548RECMTVC,
                                                                XROW.AQPB548RECSMTC,
                                                                XROW.AQPB548BANSEG,
                                                                XROW.AQPB548CANRESC,
                                                                0,
                                                                15,
                                                                ln_TR1A15_NR_SP,
                                                                ln_TR1A15_NR_CP,
                                                                ln_TR1A15_SR_SP,
                                                                ln_TR1A15_SR_CP,
                                                                lv_ERRCOD,
                                                                lv_ERRMSG);
    
      PQ_AH_RECLAMOS_RR.SP_AH_REP_RR1_REC_TRAMITE_RANGO_LINEA_P(XROW.AQPB548FECINI,
                                                                XROW.AQPB548FECFIN,
                                                                XROW.AQPB548CANOPEC,
                                                                XROW.AQPB548RECOPSC,
                                                                XROW.AQPB548CANINGS,
                                                                XROW.AQPB548UGPRREC,
                                                                XROW.AQPB548RECMTVC,
                                                                XROW.AQPB548RECSMTC,
                                                                XROW.AQPB548BANSEG,
                                                                XROW.AQPB548CANRESC,
                                                                16,
                                                                999,
                                                                ln_TRM15C_NR_SP,
                                                                ln_TRM15C_NR_CP,
                                                                ln_TRM15C_SR_SP,
                                                                ln_TRM15C_SR_CP,
                                                                lv_ERRCOD,
                                                                lv_ERRMSG);
    
      ln_TR1A15_NR_TL := ln_TR1A15_NR_SP + ln_TR1A15_NR_CP +
                         ln_TRM15C_NR_CP + ln_TRM15C_NR_SP;
      ln_TR1A15_SR_TL := ln_TR1A15_SR_SP + ln_TR1A15_SR_CP +
                         ln_TRM15C_SR_CP + ln_TRM15C_SR_SP;
    
      --- A FAVOR DE LA EMPRESA
      ---***
      ln_AE_QTY_NR_SP_1 := 0;
      ln_AE_QTY_NR_CP_1 := 0;
      ln_AE_QTY_SR_SP_1 := 0;
      ln_AE_QTY_SR_CP_1 := 0;
      ---***
      PQ_AH_RECLAMOS_RR.SP_AH_REP_RR1_REC_ABSUELTO_RANGO_LINEA_P(XROW.AQPB548FECINI,
                                                                 XROW.AQPB548FECFIN,
                                                                 XROW.AQPB548CANOPEC,
                                                                 XROW.AQPB548RECOPSC,
                                                                 XROW.AQPB548CANINGS,
                                                                 XROW.AQPB548UGPRREC,
                                                                 XROW.AQPB548RECMTVC,
                                                                 XROW.AQPB548RECSMTC,
                                                                 XROW.AQPB548BANSEG,
                                                                 XROW.AQPB548CANRESC,
                                                                 0,
                                                                 2,
                                                                 'C',
                                                                 ln_AE_QTY_NR_SP_1,
                                                                 ln_AE_QTY_NR_CP_1,
                                                                 ln_AE_QTY_SR_SP_1,
                                                                 ln_AE_QTY_SR_CP_1,
                                                                 lv_ERRCOD,
                                                                 lv_ERRMSG);
    
      ---***
      ln_AE_QTY_NR_SP_2 := 0;
      ln_AE_QTY_NR_CP_2 := 0;
      ln_AE_QTY_SR_SP_2 := 0;
      ln_AE_QTY_SR_CP_2 := 0;
      ---*** 
      PQ_AH_RECLAMOS_RR.SP_AH_REP_RR1_REC_ABSUELTO_RANGO_LINEA_P(XROW.AQPB548FECINI,
                                                                 XROW.AQPB548FECFIN,
                                                                 XROW.AQPB548CANOPEC,
                                                                 XROW.AQPB548RECOPSC,
                                                                 XROW.AQPB548CANINGS,
                                                                 XROW.AQPB548UGPRREC,
                                                                 XROW.AQPB548RECMTVC,
                                                                 XROW.AQPB548RECSMTC,
                                                                 XROW.AQPB548BANSEG,
                                                                 XROW.AQPB548CANRESC,
                                                                 3,
                                                                 7,
                                                                 'C',
                                                                 ln_AE_QTY_NR_SP_2,
                                                                 ln_AE_QTY_NR_CP_2,
                                                                 ln_AE_QTY_SR_SP_2,
                                                                 ln_AE_QTY_SR_CP_2,
                                                                 lv_ERRCOD,
                                                                 lv_ERRMSG);
    
      PQ_AH_RECLAMOS_RR.SP_AH_REP_RR1_REC_ABSUELTO_RANGO_LINEA_P(XROW.AQPB548FECINI,
                                                                 XROW.AQPB548FECFIN,
                                                                 XROW.AQPB548CANOPEC,
                                                                 XROW.AQPB548RECOPSC,
                                                                 XROW.AQPB548CANINGS,
                                                                 XROW.AQPB548UGPRREC,
                                                                 XROW.AQPB548RECMTVC,
                                                                 XROW.AQPB548RECSMTC,
                                                                 XROW.AQPB548BANSEG,
                                                                 XROW.AQPB548CANRESC,
                                                                 8,
                                                                 15,
                                                                 'C',
                                                                 ln_AE_QTY_NR_SP_3,
                                                                 ln_AE_QTY_NR_CP_3,
                                                                 ln_AE_QTY_SR_SP_3,
                                                                 ln_AE_QTY_SR_CP_3,
                                                                 lv_ERRCOD,
                                                                 lv_ERRMSG);
    
      ---***
      ln_AE_QTY_NR_SP_4 := 0;
      ln_AE_QTY_NR_CP_4 := 0;
      ln_AE_QTY_SR_SP_4 := 0;
      ln_AE_QTY_SR_CP_4 := 0;
      ---***
      PQ_AH_RECLAMOS_RR.SP_AH_REP_RR1_REC_ABSUELTO_RANGO_LINEA_P(XROW.AQPB548FECINI,
                                                                 XROW.AQPB548FECFIN,
                                                                 XROW.AQPB548CANOPEC,
                                                                 XROW.AQPB548RECOPSC,
                                                                 XROW.AQPB548CANINGS,
                                                                 XROW.AQPB548UGPRREC,
                                                                 XROW.AQPB548RECMTVC,
                                                                 XROW.AQPB548RECSMTC,
                                                                 XROW.AQPB548BANSEG,
                                                                 XROW.AQPB548CANRESC,
                                                                 16,
                                                                 30,
                                                                 'C',
                                                                 ln_AE_QTY_NR_SP_4,
                                                                 ln_AE_QTY_NR_CP_4,
                                                                 ln_AE_QTY_SR_SP_4,
                                                                 ln_AE_QTY_SR_CP_4,
                                                                 lv_ERRCOD,
                                                                 lv_ERRMSG);
      ---***
      ln_AE_QTY_NR_SP_5 := 0;
      ln_AE_QTY_NR_CP_5 := 0;
      ln_AE_QTY_SR_SP_5 := 0;
      ln_AE_QTY_SR_CP_5 := 0;
      ---***                                                           
      PQ_AH_RECLAMOS_RR.SP_AH_REP_RR1_REC_ABSUELTO_RANGO_LINEA_P(XROW.AQPB548FECINI,
                                                                 XROW.AQPB548FECFIN,
                                                                 XROW.AQPB548CANOPEC,
                                                                 XROW.AQPB548RECOPSC,
                                                                 XROW.AQPB548CANINGS,
                                                                 XROW.AQPB548UGPRREC,
                                                                 XROW.AQPB548RECMTVC,
                                                                 XROW.AQPB548RECSMTC,
                                                                 XROW.AQPB548BANSEG,
                                                                 XROW.AQPB548CANRESC,
                                                                 31,
                                                                 999,
                                                                 'C',
                                                                 ln_AE_QTY_NR_SP_5,
                                                                 ln_AE_QTY_NR_CP_5,
                                                                 ln_AE_QTY_SR_SP_5,
                                                                 ln_AE_QTY_SR_CP_5,
                                                                 lv_ERRCOD,
                                                                 lv_ERRMSG);
    
      ln_AE_QTY_NR_TL := ln_AE_QTY_NR_SP_1 + ln_AE_QTY_NR_SP_2 +
                         ln_AE_QTY_NR_SP_3 + ln_AE_QTY_NR_CP_4 +
                         ln_AE_QTY_NR_CP_5 + ln_AE_QTY_NR_SP_4 +
                         ln_AE_QTY_NR_SP_5;
    
      ln_AE_QTY_SR_TL := ln_AE_QTY_SR_SP_1 + ln_AE_QTY_SR_SP_2 +
                         ln_AE_QTY_SR_SP_3 + ln_AE_QTY_SR_CP_4 +
                         ln_AE_QTY_SR_CP_5 + ln_AE_QTY_SR_SP_4 +
                         ln_AE_QTY_SR_SP_5;
    
      --- A FAVOR DEL USUARIO
      PQ_AH_RECLAMOS_RR.SP_AH_REP_RR1_REC_ABSUELTO_RANGO_LINEA_P(XROW.AQPB548FECINI,
                                                                 XROW.AQPB548FECFIN,
                                                                 XROW.AQPB548CANOPEC,
                                                                 XROW.AQPB548RECOPSC,
                                                                 XROW.AQPB548CANINGS,
                                                                 XROW.AQPB548UGPRREC,
                                                                 XROW.AQPB548RECMTVC,
                                                                 XROW.AQPB548RECSMTC,
                                                                 XROW.AQPB548BANSEG,
                                                                 XROW.AQPB548CANRESC,
                                                                 0,
                                                                 2,
                                                                 'U',
                                                                 ln_AU_QTY_NR_SP_1,
                                                                 ln_AU_QTY_NR_CP_1,
                                                                 ln_AU_QTY_SR_SP_1,
                                                                 ln_AU_QTY_SR_CP_1,
                                                                 lv_ERRCOD,
                                                                 lv_ERRMSG);
    
      PQ_AH_RECLAMOS_RR.SP_AH_REP_RR1_REC_ABSUELTO_RANGO_LINEA_P(XROW.AQPB548FECINI,
                                                                 XROW.AQPB548FECFIN,
                                                                 XROW.AQPB548CANOPEC,
                                                                 XROW.AQPB548RECOPSC,
                                                                 XROW.AQPB548CANINGS,
                                                                 XROW.AQPB548UGPRREC,
                                                                 XROW.AQPB548RECMTVC,
                                                                 XROW.AQPB548RECSMTC,
                                                                 XROW.AQPB548BANSEG,
                                                                 XROW.AQPB548CANRESC,
                                                                 3,
                                                                 7,
                                                                 'U',
                                                                 ln_AU_QTY_NR_SP_2,
                                                                 ln_AU_QTY_NR_CP_2,
                                                                 ln_AU_QTY_SR_SP_2,
                                                                 ln_AU_QTY_SR_CP_2,
                                                                 lv_ERRCOD,
                                                                 lv_ERRMSG);
    
      PQ_AH_RECLAMOS_RR.SP_AH_REP_RR1_REC_ABSUELTO_RANGO_LINEA_P(XROW.AQPB548FECINI,
                                                                 XROW.AQPB548FECFIN,
                                                                 XROW.AQPB548CANOPEC,
                                                                 XROW.AQPB548RECOPSC,
                                                                 XROW.AQPB548CANINGS,
                                                                 XROW.AQPB548UGPRREC,
                                                                 XROW.AQPB548RECMTVC,
                                                                 XROW.AQPB548RECSMTC,
                                                                 XROW.AQPB548BANSEG,
                                                                 XROW.AQPB548CANRESC,
                                                                 8,
                                                                 15,
                                                                 'U',
                                                                 ln_AU_QTY_NR_SP_3,
                                                                 ln_AU_QTY_NR_CP_3,
                                                                 ln_AU_QTY_SR_SP_3,
                                                                 ln_AU_QTY_SR_CP_3,
                                                                 lv_ERRCOD,
                                                                 lv_ERRMSG);
      ---***
      ln_AU_QTY_NR_SP_4 := 0;
      ln_AU_QTY_NR_CP_4 := 0;
      ln_AU_QTY_SR_SP_4 := 0;
      ln_AU_QTY_SR_CP_4 := 0;
      ---***
      PQ_AH_RECLAMOS_RR.SP_AH_REP_RR1_REC_ABSUELTO_RANGO_LINEA_P(XROW.AQPB548FECINI,
                                                                 XROW.AQPB548FECFIN,
                                                                 XROW.AQPB548CANOPEC,
                                                                 XROW.AQPB548RECOPSC,
                                                                 XROW.AQPB548CANINGS,
                                                                 XROW.AQPB548UGPRREC,
                                                                 XROW.AQPB548RECMTVC,
                                                                 XROW.AQPB548RECSMTC,
                                                                 XROW.AQPB548BANSEG,
                                                                 XROW.AQPB548CANRESC,
                                                                 16,
                                                                 30,
                                                                 'U',
                                                                 ln_AU_QTY_NR_SP_4,
                                                                 ln_AU_QTY_NR_CP_4,
                                                                 ln_AU_QTY_SR_SP_4,
                                                                 ln_AU_QTY_SR_CP_4,
                                                                 lv_ERRCOD,
                                                                 lv_ERRMSG);
      ---***
      ln_AU_QTY_NR_SP_5 := 0;
      ln_AU_QTY_NR_CP_5 := 0;
      ln_AU_QTY_SR_SP_5 := 0;
      ln_AU_QTY_SR_CP_5 := 0;
      ---***
      PQ_AH_RECLAMOS_RR.SP_AH_REP_RR1_REC_ABSUELTO_RANGO_LINEA_P(XROW.AQPB548FECINI,
                                                                 XROW.AQPB548FECFIN,
                                                                 XROW.AQPB548CANOPEC,
                                                                 XROW.AQPB548RECOPSC,
                                                                 XROW.AQPB548CANINGS,
                                                                 XROW.AQPB548UGPRREC,
                                                                 XROW.AQPB548RECMTVC,
                                                                 XROW.AQPB548RECSMTC,
                                                                 XROW.AQPB548BANSEG,
                                                                 XROW.AQPB548CANRESC,
                                                                 31,
                                                                 999,
                                                                 'U',
                                                                 ln_AU_QTY_NR_SP_5,
                                                                 ln_AU_QTY_NR_CP_5,
                                                                 ln_AU_QTY_SR_SP_5,
                                                                 ln_AU_QTY_SR_CP_5,
                                                                 lv_ERRCOD,
                                                                 lv_ERRMSG);
    
      PQ_AH_RECLAMOS_RR.SP_AH_REP_RR1_REC_ABSUELTO_LINEA_TPA(XROW.AQPB548FECINI,
                                                             XROW.AQPB548FECFIN,
                                                             XROW.AQPB548CANOPEC,
                                                             XROW.AQPB548RECOPSC,
                                                             XROW.AQPB548CANINGS,
                                                             XROW.AQPB548UGPRREC,
                                                             XROW.AQPB548RECMTVC,
                                                             XROW.AQPB548RECSMTC,
                                                             XROW.AQPB548BANSEG,
                                                             XROW.AQPB548CANRESC,
                                                             ln_TPA_NO_RECON,
                                                             ln_TPA_SI_RECON,
                                                             lv_ERRCOD,
                                                             lv_ERRMSG);
    
      ln_AU_QTY_NR_TL := ln_AU_QTY_NR_SP_1 + ln_AU_QTY_NR_SP_2 +
                         ln_AU_QTY_NR_SP_3 + ln_AU_QTY_NR_CP_4 +
                         ln_AU_QTY_NR_CP_5 + ln_AU_QTY_NR_SP_4 +
                         ln_AU_QTY_NR_SP_5;
    
      ln_AU_QTY_SR_TL := ln_AU_QTY_SR_SP_1 + ln_AU_QTY_SR_SP_2 +
                         ln_AU_QTY_SR_SP_3 + ln_AU_QTY_SR_CP_4 +
                         ln_AU_QTY_SR_CP_5 + ln_AU_QTY_SR_SP_4 +
                         ln_AU_QTY_SR_SP_5;
    
      ln_RTOTAL_NR_LN := ln_AE_QTY_NR_TL + ln_AU_QTY_NR_TL;
      ln_RTOTAL_SR_LN := ln_AE_QTY_SR_TL + ln_AU_QTY_SR_TL;
    
      ---*** NO RECONSIDERACION
      INSERT INTO AQPB548A
        (AQPB548ACREUSR,
         AQPB548ACRETIM,
         AQPB548AFECINI,
         AQPB548AFECFIN,
         AQPB548ACANOPE,
         AQPB548ARECOPS,
         AQPB548ACANING,
         AQPB548AUGPRRE,
         AQPB548ARECMTV,
         AQPB548ARECSMT,
         AQPB548ARECPER,
         AQPB548AREITER,
         AQPB548ABANSEG,
         AQPB548ATR1A15,
         AQPB548ATRM15C,
         AQPB548ATRM15S,
         AQPB548ATRTOTA,
         AQPB548ACANRES,
         AQPB548AEMP001,
         AQPB548AEMP002,
         AQPB548AEMP003,
         AQPB548AEMP004,
         AQPB548AEMP005,
         AQPB548AEMP006,
         AQPB548AEMP007,
         AQPB548AEMP008,
         AQPB548AUSU001,
         AQPB548AUSU002,
         AQPB548AUSU003,
         AQPB548AUSU004,
         AQPB548AUSU005,
         AQPB548AUSU006,
         AQPB548AUSU007,
         AQPB548AUSU008,
         AQPB548ARTOTAL,
         AQPB548ATIMPRO)
      VALUES
        (XROW.AQPB548CREUSR,
         SYSDATE,
         XROW.AQPB548FECINI,
         XROW.AQPB548FECFIN,
         XROW.AQPB548CANOPES,
         XROW.AQPB548RECOPSS,
         XROW.AQPB548CANINGS,
         XROW.AQPB548UGPRRES,
         XROW.AQPB548RECMTVS,
         XROW.AQPB548RECSMTS,
         ln_RECQTY_NR,
         XROW.AQPB548REITER,
         XROW.AQPB548BANSEG,
         (ln_TR1A15_NR_SP + ln_TR1A15_NR_CP),
         ln_TRM15C_NR_CP,
         ln_TRM15C_NR_SP,
         ln_TR1A15_NR_TL,
         XROW.AQPB548CANRESS,
         ln_AE_QTY_NR_SP_1,
         ln_AE_QTY_NR_SP_2,
         ln_AE_QTY_NR_SP_3,
         ln_AE_QTY_NR_CP_4,
         ln_AE_QTY_NR_CP_5,
         ln_AE_QTY_NR_SP_4,
         ln_AE_QTY_NR_SP_5,
         ln_AE_QTY_NR_TL,
         ln_AU_QTY_NR_SP_1,
         ln_AU_QTY_NR_SP_2,
         ln_AU_QTY_NR_SP_3,
         ln_AU_QTY_NR_CP_4,
         ln_AU_QTY_NR_CP_5,
         ln_AU_QTY_NR_SP_4,
         ln_AU_QTY_NR_SP_5,
         ln_AU_QTY_NR_TL,
         ln_RTOTAL_NR_LN,
         ln_TPA_NO_RECON);
    
      ---*** SI RECONSIDERACION
      INSERT INTO AQPB548A
        (AQPB548ACREUSR,
         AQPB548ACRETIM,
         AQPB548AFECINI,
         AQPB548AFECFIN,
         AQPB548ACANOPE,
         AQPB548ARECOPS,
         AQPB548ACANING,
         AQPB548AUGPRRE,
         AQPB548ARECMTV,
         AQPB548ARECSMT,
         AQPB548ARECPER,
         AQPB548AREITER,
         AQPB548ABANSEG,
         AQPB548ATR1A15,
         AQPB548ATRM15C,
         AQPB548ATRM15S,
         AQPB548ATRTOTA,
         AQPB548ACANRES,
         AQPB548AEMP001,
         AQPB548AEMP002,
         AQPB548AEMP003,
         AQPB548AEMP004,
         AQPB548AEMP005,
         AQPB548AEMP006,
         AQPB548AEMP007,
         AQPB548AEMP008,
         AQPB548AUSU001,
         AQPB548AUSU002,
         AQPB548AUSU003,
         AQPB548AUSU004,
         AQPB548AUSU005,
         AQPB548AUSU006,
         AQPB548AUSU007,
         AQPB548AUSU008,
         AQPB548ARTOTAL,
         AQPB548ATIMPRO)
      VALUES
        (XROW.AQPB548CREUSR,
         SYSDATE,
         XROW.AQPB548FECINI,
         XROW.AQPB548FECFIN,
         XROW.AQPB548CANOPES,
         XROW.AQPB548RECOPSS,
         XROW.AQPB548CANINGS,
         XROW.AQPB548UGPRRES,
         XROW.AQPB548RECMTVS,
         XROW.AQPB548RECSMTS,
         ln_RECQTY_SR,
         2,
         XROW.AQPB548BANSEG,
         (ln_TR1A15_SR_SP + ln_TR1A15_SR_CP),
         ln_TRM15C_SR_CP,
         ln_TRM15C_SR_SP,
         ln_TR1A15_SR_TL,
         XROW.AQPB548CANRESS,
         ln_AE_QTY_SR_SP_1,
         ln_AE_QTY_SR_SP_2,
         ln_AE_QTY_SR_SP_3,
         ln_AE_QTY_SR_CP_4,
         ln_AE_QTY_SR_CP_5,
         ln_AE_QTY_SR_SP_4,
         ln_AE_QTY_SR_SP_5,
         ln_AE_QTY_SR_TL,
         ln_AU_QTY_SR_SP_1,
         ln_AU_QTY_SR_SP_2,
         ln_AU_QTY_SR_SP_3,
         ln_AU_QTY_SR_CP_4,
         ln_AU_QTY_SR_CP_5,
         ln_AU_QTY_SR_SP_4,
         ln_AU_QTY_SR_SP_5,
         ln_AU_QTY_SR_TL,
         ln_RTOTAL_SR_LN,
         ln_TPA_SI_RECON);
    
    END LOOP;
    ---***
    COMMIT;
    ---***
  
  EXCEPTION
    WHEN OTHERS THEN
      ---***
      P_ERRCOD := '001';
      P_ERRMSG := sqlcode || ' ->>> ' || sqlerrm;
      ROLLBACK;
      ---***
  END SP_AH_REP_RR1_GENERA_REPORTE;

  PROCEDURE SP_AH_REP_RR1_REC_ABSUELTO_LINEA_TPA(P_FECINI       IN DATE,
                                                 P_FECFIN       IN DATE,
                                                 P_CANOPEC      IN NUMBER,
                                                 P_RECOPSC      IN NUMBER,
                                                 P_CANING       IN NUMBER,
                                                 P_UGPRREC      IN NUMBER,
                                                 P_RECMTVC      IN NUMBER,
                                                 P_RECSMTC      IN NUMBER,
                                                 P_BANSEG       IN NUMBER,
                                                 P_CANRESC      IN NUMBER,
                                                 P_TPA_NO_RECON OUT NUMBER,
                                                 P_TPA_SI_RECON OUT NUMBER,
                                                 P_ERRCOD       OUT VARCHAR,
                                                 P_ERRMSG       OUT VARCHAR) IS
  
    ---***
    ln_DABSOL_NR NUMBER(9);
    ln_DABSOL_SR NUMBER(9);
    ln_QTY_NR    NUMBER(9);
    ln_QTY_SR    NUMBER(9);
  
    ln_TPA_NO_RECON NUMBER(9, 2);
    ln_TPA_SI_RECON NUMBER(9, 2);
  
    lv_RECOPSC VARCHAR(10);
  
  BEGIN
    ---***
    P_TPA_NO_RECON := 0;
    P_TPA_SI_RECON := 0;
    ---***
  
    ---********* OPS
    BEGIN
      lv_RECOPSC := TRIM(TO_CHAR(P_RECOPSC));
    EXCEPTION
      WHEN OTHERS THEN
        lv_RECOPSC := '';
    END;
    ---*********
  
    -- Reclamos Normales y BS
    IF (P_RECSMTC = 0) THEN
      -- No tiene SubMotivo
      SELECT SUM(j.JAQL420DABSOL), COUNT(*)
        INTO ln_DABSOL_NR, ln_QTY_NR
        FROM JAQL420 j
       WHERE j.JAQL420TRC = 1
         AND j.JAQL420ESR IN (1, 2, 3)
         AND j.JAQL420FCR <= P_FECFIN
         AND JAQL420COD NOT IN
             (SELECT AQPB545BCOD FROM AQPB545B WHERE AQPB545BRTIP = 'REI')
         AND (((j.JAQL420ESR = 3 AND j.JAQL420FCR BETWEEN P_FECINI AND
             P_FECFIN) OR (JAQL420ESR = 3 AND j.JAQL420FCR < P_FECINI AND
             JAQL420FCCCLI BETWEEN P_FECINI AND P_FECFIN)) AND
             (j.JAQL420CAN = P_CANOPEC AND j.JAQL420OPS = lv_RECOPSC AND
             j.JAQL420CANING = P_CANING AND j.JAQL420UGPRPR = P_UGPRREC AND
             j.JAQL420MOT = P_RECMTVC AND j.JAQL420VRP = P_CANRESC AND
             (j.JAQL420COD NOT IN
             (SELECT AQPB545BCOD
                   FROM AQPB545B
                  WHERE AQPB545BEMP = j.JAQL420EMP))));
    
      ln_TPA_NO_RECON := ln_DABSOL_NR / ln_QTY_NR;
    
      SELECT SUM(j.JAQL420DABSOL), COUNT(*)
        INTO ln_DABSOL_SR, ln_QTY_SR
        FROM JAQL420 j
        JOIN AQPB545B b
          ON (j.JAQL420EMP = b.AQPB545BEMP AND j.JAQL420COD = b.AQPB545BCOD)
       WHERE j.JAQL420TRC = 1
         AND j.JAQL420ESR IN (1, 2, 3)
         AND j.JAQL420FCR <= P_FECFIN
         AND JAQL420COD NOT IN
             (SELECT AQPB545BCOD FROM AQPB545B WHERE AQPB545BRTIP = 'REI')
         AND (((j.JAQL420ESR = 3 AND j.JAQL420FCR BETWEEN P_FECINI AND
             P_FECFIN) OR (JAQL420ESR = 3 AND j.JAQL420FCR < P_FECINI AND
             JAQL420FCCCLI BETWEEN P_FECINI AND P_FECFIN)) AND
             (j.JAQL420CAN = P_CANOPEC AND j.JAQL420OPS = lv_RECOPSC AND
             j.JAQL420CANING = P_CANING AND j.JAQL420UGPRPR = P_UGPRREC AND
             j.JAQL420MOT = P_RECMTVC AND j.JAQL420VRP = P_CANRESC));
    
      ln_TPA_SI_RECON := ln_DABSOL_SR / ln_QTY_SR;
      ---*********
      P_TPA_NO_RECON := ln_TPA_NO_RECON;
      P_TPA_SI_RECON := ln_TPA_SI_RECON;
      ---*********
      IF (P_TPA_NO_RECON = 0) THEN
        P_TPA_NO_RECON := 1;
      END IF;
      IF (P_TPA_SI_RECON = 0) THEN
        P_TPA_SI_RECON := 1;
      END IF;
      ---*********
    
    END IF;
  
    IF (P_RECSMTC > 0) THEN
      -- Tiene SubMotivo
    
      SELECT SUM(j.JAQL420DABSOL), COUNT(*)
        INTO ln_DABSOL_NR, ln_QTY_NR
        FROM JAQL420 j
        JOIN AQPB545M m
          ON (j.JAQL420EMP = m.AQPB545MREMP AND
             j.JAQL420COD = m.AQPB545MRCOD)
       WHERE j.JAQL420TRC = 1
         AND j.JAQL420ESR IN (1, 2, 3)
         AND j.JAQL420FCR <= P_FECFIN
         AND JAQL420COD NOT IN
             (SELECT AQPB545BCOD FROM AQPB545B WHERE AQPB545BRTIP = 'REI')
         AND (((j.JAQL420ESR = 3 AND j.JAQL420FCR BETWEEN P_FECINI AND
             P_FECFIN) OR (JAQL420ESR = 3 AND j.JAQL420FCR < P_FECINI AND
             JAQL420FCCCLI BETWEEN P_FECINI AND P_FECFIN)) AND
             (j.JAQL420CAN = P_CANOPEC AND j.JAQL420OPS = lv_RECOPSC AND
             j.JAQL420CANING = P_CANING AND j.JAQL420UGPRPR = P_UGPRREC AND
             j.JAQL420MOT = P_RECMTVC AND m.AQPB545MSCOD = P_RECSMTC AND
             j.JAQL420VRP = P_CANRESC AND
             (j.JAQL420COD NOT IN
             (SELECT AQPB545BCOD
                   FROM AQPB545B
                  WHERE AQPB545BEMP = j.JAQL420EMP))));
    
      ln_TPA_NO_RECON := ln_DABSOL_NR / ln_QTY_NR;
    
      SELECT SUM(j.JAQL420DABSOL), COUNT(*)
        INTO ln_DABSOL_SR, ln_QTY_SR
        FROM JAQL420 j
        JOIN AQPB545B b
          ON (j.JAQL420EMP = b.AQPB545BEMP AND j.JAQL420COD = b.AQPB545BCOD)
        JOIN AQPB545M m
          ON (j.JAQL420EMP = m.AQPB545MREMP AND
             j.JAQL420COD = m.AQPB545MRCOD)
       WHERE j.JAQL420TRC = 1
         AND j.JAQL420ESR IN (1, 2, 3)
         AND j.JAQL420FCR <= P_FECFIN
         AND JAQL420COD NOT IN
             (SELECT AQPB545BCOD FROM AQPB545B WHERE AQPB545BRTIP = 'REI')
         AND (((j.JAQL420ESR = 3 AND j.JAQL420FCR BETWEEN P_FECINI AND
             P_FECFIN) OR (JAQL420ESR = 3 AND j.JAQL420FCR < P_FECINI AND
             JAQL420FCCCLI BETWEEN P_FECINI AND P_FECFIN)) AND
             (j.JAQL420CAN = P_CANOPEC AND j.JAQL420OPS = lv_RECOPSC AND
             j.JAQL420CANING = P_CANING AND j.JAQL420UGPRPR = P_UGPRREC AND
             j.JAQL420MOT = P_RECMTVC AND m.AQPB545MSCOD = P_RECSMTC AND
             j.JAQL420VRP = P_CANRESC));
    
      ln_TPA_SI_RECON := ln_DABSOL_SR / ln_QTY_SR;
      ---*********
      P_TPA_NO_RECON := ln_TPA_NO_RECON;
      P_TPA_SI_RECON := ln_TPA_SI_RECON;
      ---*********
      IF (P_TPA_NO_RECON = 0) THEN
        P_TPA_NO_RECON := 1;
      END IF;
      IF (P_TPA_SI_RECON = 0) THEN
        P_TPA_SI_RECON := 1;
      END IF;
      ---*********
    
    END IF;
  
  EXCEPTION
    WHEN OTHERS THEN
      ---***
      P_TPA_NO_RECON := 0;
      P_TPA_SI_RECON := 0;
    
      P_ERRCOD := '001';
      P_ERRMSG := sqlcode || ' ->>> ' || sqlerrm;
      ---***
  END SP_AH_REP_RR1_REC_ABSUELTO_LINEA_TPA;

  PROCEDURE SP_AH_REP_RR1_REC_ABSUELTO_RANGO_LINEA_P(P_FECINI          IN DATE,
                                                     P_FECFIN          IN DATE,
                                                     P_CANOPEC         IN NUMBER,
                                                     P_RECOPSC         IN NUMBER,
                                                     P_CANING          IN NUMBER,
                                                     P_UGPRREC         IN NUMBER,
                                                     P_RECMTVC         IN NUMBER,
                                                     P_RECSMTC         IN NUMBER,
                                                     P_BANSEG          IN NUMBER,
                                                     P_CANRESC         IN NUMBER,
                                                     P_RANINI          IN NUMBER,
                                                     P_RANFIN          IN NUMBER,
                                                     P_AFAVOR          IN VARCHAR,
                                                     P_QTY_NO_RECON_SP OUT NUMBER,
                                                     P_QTY_NO_RECON_CP OUT NUMBER,
                                                     P_QTY_SI_RECON_SP OUT NUMBER,
                                                     P_QTY_SI_RECON_CP OUT NUMBER,
                                                     P_ERRCOD          OUT VARCHAR,
                                                     P_ERRMSG          OUT VARCHAR) IS
  
    ---***
    ln_QTY_TOTAL      NUMBER(9);
    ln_QTY_NO_RECONSI NUMBER(9);
    ln_QTY_SI_RECONSI NUMBER(9);
  
    ln_QTY_NO_RECON_SP NUMBER(9);
    ln_QTY_NO_RECON_CP NUMBER(9);
    ln_QTY_SI_RECON_SP NUMBER(9);
    ln_QTY_SI_RECON_CP NUMBER(9);
  
    lc_AFAVOR CHAR(1);
  
    lv_RECOPSC VARCHAR(10);
  
  BEGIN
    ---***
    lc_AFAVOR := TRIM(P_AFAVOR);
  
    P_QTY_NO_RECON_SP := 0;
    P_QTY_NO_RECON_CP := 0;
    P_QTY_SI_RECON_SP := 0;
    P_QTY_SI_RECON_CP := 0;
  
    ln_QTY_NO_RECON_SP := 0;
    ln_QTY_NO_RECON_CP := 0;
    ln_QTY_SI_RECON_SP := 0;
    ln_QTY_SI_RECON_CP := 0;
    ---***
  
    ---********* OPS
    BEGIN
      lv_RECOPSC := TRIM(TO_CHAR(P_RECOPSC));
    EXCEPTION
      WHEN OTHERS THEN
        lv_RECOPSC := '';
    END;
    ---*********
  
    -- Reclamos Normales y BS
    IF (P_RECSMTC = 0) THEN
      -- No tiene SubMotivo
      SELECT COUNT(*)
        INTO ln_QTY_TOTAL
        FROM JAQL420 j
       WHERE j.JAQL420TRC = 1
         AND j.JAQL420ESR = 3
         AND j.JAQL420FCR <= P_FECFIN
         AND j.JAQL420FLD = lc_AFAVOR
         AND j.JAQL420FCCCLI BETWEEN P_FECINI AND P_FECFIN
         AND j.JAQL420CAN = P_CANOPEC
         AND j.JAQL420OPS = lv_RECOPSC
         AND j.JAQL420CANING = P_CANING
         AND j.JAQL420UGPRPR = P_UGPRREC
         AND j.JAQL420MOT = P_RECMTVC
         AND j.JAQL420VRP = P_CANRESC
         AND j.JAQL420DABSOL BETWEEN P_RANINI AND P_RANFIN
         AND j.JAQL420COD NOT IN
             (SELECT AQPB545MRCOD
                FROM AQPB545M
               WHERE AQPB545MREMP = j.JAQL420EMP
                 AND AQPB545MRCOD = j.JAQL420COD)
         AND j.JAQL420COD NOT IN
             (SELECT AQPB545BCOD FROM AQPB545B WHERE AQPB545BRTIP = 'REI');
    
      SELECT COUNT(*)
        INTO ln_QTY_SI_RECONSI
        FROM JAQL420 j
        JOIN AQPB545B b
          ON (j.JAQL420EMP = b.AQPB545BEMP AND j.JAQL420COD = b.AQPB545BCOD AND
             b.AQPB545BRTIP = 'REC')
       WHERE j.JAQL420TRC = 1
         AND j.JAQL420ESR = 3
         AND j.JAQL420FCR <= P_FECFIN
         AND j.JAQL420FLD = lc_AFAVOR
         AND j.JAQL420FCCCLI BETWEEN P_FECINI AND P_FECFIN
         AND j.JAQL420CAN = P_CANOPEC
         AND j.JAQL420OPS = lv_RECOPSC
         AND j.JAQL420CANING = P_CANING
         AND j.JAQL420UGPRPR = P_UGPRREC
         AND j.JAQL420MOT = P_RECMTVC
         AND j.JAQL420VRP = P_CANRESC
         AND j.JAQL420DABSOL BETWEEN P_RANINI AND P_RANFIN
         AND j.JAQL420COD NOT IN
             (SELECT AQPB545MRCOD
                FROM AQPB545M
               WHERE AQPB545MREMP = j.JAQL420EMP
                 AND AQPB545MRCOD = j.JAQL420COD)
         AND j.JAQL420COD NOT IN
             (SELECT AQPB545BCOD FROM AQPB545B WHERE AQPB545BRTIP = 'REI');
    
      SELECT COUNT(*)
        INTO ln_QTY_SI_RECON_CP
        FROM JAQL420 j
        JOIN AQPB546A a
          ON (j.JAQL420EMP = a.AQPB546ARECEMP AND
             j.JAQL420COD = a.AQPB546ARECCOD AND a.AQPB546ARECTIP = 'REC' AND
             a.AQPB546AESTAMP = 'V' AND
             (a.AQPB546AFECCOM <= P_FECFIN AND
             a.AQPB546AFECCOM <> TO_DATE('01/01/0001', 'dd/MM/yyyy')))
        JOIN AQPB545B b
          ON (j.JAQL420EMP = b.AQPB545BEMP AND j.JAQL420COD = b.AQPB545BCOD AND
             b.AQPB545BRTIP = 'REC')
       WHERE j.JAQL420TRC = 1
         AND j.JAQL420ESR = 3
         AND j.JAQL420FCR <= P_FECFIN
         AND j.JAQL420FLD = lc_AFAVOR
         AND j.JAQL420FCCCLI BETWEEN P_FECINI AND P_FECFIN
         AND j.JAQL420CAN = P_CANOPEC
         AND j.JAQL420OPS = lv_RECOPSC
         AND j.JAQL420CANING = P_CANING
         AND j.JAQL420UGPRPR = P_UGPRREC
         AND j.JAQL420MOT = P_RECMTVC
         AND j.JAQL420VRP = P_CANRESC
         AND j.JAQL420DABSOL BETWEEN P_RANINI AND P_RANFIN
         AND j.JAQL420COD NOT IN
             (SELECT AQPB545MRCOD
                FROM AQPB545M
               WHERE AQPB545MREMP = j.JAQL420EMP
                 AND AQPB545MRCOD = j.JAQL420COD)
         AND j.JAQL420COD NOT IN
             (SELECT AQPB545BCOD FROM AQPB545B WHERE AQPB545BRTIP = 'REI');
    
      SELECT COUNT(*)
        INTO ln_QTY_NO_RECON_CP
        FROM JAQL420 j
        JOIN AQPB546A a
          ON (j.JAQL420EMP = a.AQPB546ARECEMP AND
             j.JAQL420COD = a.AQPB546ARECCOD AND a.AQPB546ARECTIP = 'REC' AND
             a.AQPB546AESTAMP = 'V' AND
             (a.AQPB546AFECCOM <= P_FECFIN AND
             a.AQPB546AFECCOM <> TO_DATE('01/01/0001', 'dd/MM/yyyy')))
       WHERE j.JAQL420ESR = 3
         AND j.JAQL420FCR <= P_FECFIN
         AND j.JAQL420FLD = lc_AFAVOR
         AND j.JAQL420FCCCLI BETWEEN P_FECINI AND P_FECFIN
         AND j.JAQL420CAN = P_CANOPEC
         AND j.JAQL420OPS = lv_RECOPSC
         AND j.JAQL420CANING = P_CANING
         AND j.JAQL420UGPRPR = P_UGPRREC
         AND j.JAQL420MOT = P_RECMTVC
         AND j.JAQL420VRP = P_CANRESC
         AND j.JAQL420DABSOL BETWEEN P_RANINI AND P_RANFIN
         AND j.JAQL420COD NOT IN
             (SELECT AQPB545MRCOD
                FROM AQPB545M
               WHERE AQPB545MREMP = j.JAQL420EMP
                 AND AQPB545MRCOD = j.JAQL420COD)
         AND j.JAQL420COD NOT IN
             (SELECT AQPB545BCOD
                FROM AQPB545B
               WHERE AQPB545BRTIP IN ('REI', 'REC'));
    
      ---*** Reconsideracion y Sin Prorroga :=
      ---*** Reconsidereracion - Reconsideracion Con Prorroga
      ln_QTY_SI_RECON_SP := ln_QTY_SI_RECONSI - ln_QTY_SI_RECON_CP;
      ---*** Sin Reconsideracion :=
      ----*** Total - Con Reconsideracion
      ln_QTY_NO_RECONSI := ln_QTY_TOTAL - ln_QTY_SI_RECONSI;
      ---*** Sin Reconsideracion y Sin Prorroga :=
      ---*** Sin Reconsideracion - Sin Reconsideracion con Prorroga
      ln_QTY_NO_RECON_SP := ln_QTY_NO_RECONSI - ln_QTY_NO_RECON_CP;
      ---*********
      P_QTY_NO_RECON_SP := ln_QTY_NO_RECON_SP;
      P_QTY_NO_RECON_CP := ln_QTY_NO_RECON_CP;
      P_QTY_SI_RECON_SP := ln_QTY_SI_RECON_SP;
      P_QTY_SI_RECON_CP := ln_QTY_SI_RECON_CP;
      ---*********
    
    END IF;
  
    IF (P_RECSMTC > 0) THEN
      -- Tiene SubMotivo
      SELECT COUNT(*)
        INTO ln_QTY_TOTAL
        FROM JAQL420 j
        JOIN AQPB545M m
          ON (j.JAQL420EMP = m.AQPB545MREMP AND
             j.JAQL420COD = m.AQPB545MRCOD)
       WHERE j.JAQL420TRC = 1
         AND j.JAQL420ESR = 3
         AND j.JAQL420FCR <= P_FECFIN
         AND j.JAQL420FLD = lc_AFAVOR
         AND j.JAQL420FCCCLI BETWEEN P_FECINI AND P_FECFIN
         AND j.JAQL420CAN = P_CANOPEC
         AND j.JAQL420OPS = lv_RECOPSC
         AND j.JAQL420CANING = P_CANING
         AND j.JAQL420UGPRPR = P_UGPRREC
         AND j.JAQL420MOT = P_RECMTVC
         AND m.AQPB545MSCOD = P_RECSMTC
         AND j.JAQL420VRP = P_CANRESC
         AND j.JAQL420DABSOL BETWEEN P_RANINI AND P_RANFIN
         AND JAQL420COD NOT IN
             (SELECT AQPB545BCOD FROM AQPB545B WHERE AQPB545BRTIP = 'REI');
    
      SELECT COUNT(*)
        INTO ln_QTY_SI_RECONSI
        FROM JAQL420 j
        JOIN AQPB545B b
          ON (j.JAQL420EMP = b.AQPB545BEMP AND j.JAQL420COD = b.AQPB545BCOD AND
             b.AQPB545BRTIP = 'REC')
        JOIN AQPB545M m
          ON (j.JAQL420EMP = m.AQPB545MREMP AND
             j.JAQL420COD = m.AQPB545MRCOD)
       WHERE j.JAQL420TRC = 1
         AND j.JAQL420ESR = 3
         AND j.JAQL420FCR <= P_FECFIN
         AND j.JAQL420FLD = lc_AFAVOR
         AND j.JAQL420FCCCLI BETWEEN P_FECINI AND P_FECFIN
         AND j.JAQL420CAN = P_CANOPEC
         AND j.JAQL420OPS = lv_RECOPSC
         AND j.JAQL420CANING = P_CANING
         AND j.JAQL420UGPRPR = P_UGPRREC
         AND j.JAQL420MOT = P_RECMTVC
         AND m.AQPB545MSCOD = P_RECSMTC
         AND j.JAQL420VRP = P_CANRESC
         AND j.JAQL420DABSOL BETWEEN P_RANINI AND P_RANFIN
         AND JAQL420COD NOT IN
             (SELECT AQPB545BCOD FROM AQPB545B WHERE AQPB545BRTIP = 'REI');
    
      SELECT COUNT(*)
        INTO ln_QTY_SI_RECON_CP
        FROM JAQL420 j
        JOIN AQPB546A a
          ON (j.JAQL420EMP = a.AQPB546ARECEMP AND
             j.JAQL420COD = a.AQPB546ARECCOD AND a.AQPB546ARECTIP = 'REC' AND
             a.AQPB546AESTAMP = 'V' AND
             (a.AQPB546AFECCOM <= P_FECFIN AND
             a.AQPB546AFECCOM <> TO_DATE('01/01/0001', 'dd/MM/yyyy')))
        JOIN AQPB545B b
          ON (j.JAQL420EMP = b.AQPB545BEMP AND j.JAQL420COD = b.AQPB545BCOD AND
             b.AQPB545BRTIP = 'REC')
        JOIN AQPB545M m
          ON (j.JAQL420EMP = m.AQPB545MREMP AND
             j.JAQL420COD = m.AQPB545MRCOD)
       WHERE j.JAQL420TRC = 1
         AND j.JAQL420ESR = 3
         AND j.JAQL420FCR <= P_FECFIN
         AND j.JAQL420FLD = lc_AFAVOR
         AND j.JAQL420FCCCLI BETWEEN P_FECINI AND P_FECFIN
         AND j.JAQL420CAN = P_CANOPEC
         AND j.JAQL420OPS = lv_RECOPSC
         AND j.JAQL420CANING = P_CANING
         AND j.JAQL420UGPRPR = P_UGPRREC
         AND j.JAQL420MOT = P_RECMTVC
         AND m.AQPB545MSCOD = P_RECSMTC
         AND j.JAQL420VRP = P_CANRESC
         AND j.JAQL420DABSOL BETWEEN P_RANINI AND P_RANFIN
         AND JAQL420COD NOT IN
             (SELECT AQPB545BCOD FROM AQPB545B WHERE AQPB545BRTIP = 'REI');
    
      SELECT COUNT(*)
        INTO ln_QTY_NO_RECON_CP
        FROM JAQL420 j
        JOIN AQPB546A a
          ON (j.JAQL420EMP = a.AQPB546ARECEMP AND
             j.JAQL420COD = a.AQPB546ARECCOD AND a.AQPB546ARECTIP = 'REC' AND
             a.AQPB546AESTAMP = 'V' AND
             (a.AQPB546AFECCOM <= P_FECFIN AND
             a.AQPB546AFECCOM <> TO_DATE('01/01/0001', 'dd/MM/yyyy')))
        JOIN AQPB545M m
          ON (j.JAQL420EMP = m.AQPB545MREMP AND
             j.JAQL420COD = m.AQPB545MRCOD)
       WHERE j.JAQL420TRC = 1
         AND j.JAQL420ESR = 3
         AND j.JAQL420FCR <= P_FECFIN
         AND j.JAQL420FLD = lc_AFAVOR
         AND j.JAQL420FCCCLI BETWEEN P_FECINI AND P_FECFIN
         AND j.JAQL420CAN = P_CANOPEC
         AND j.JAQL420OPS = lv_RECOPSC
         AND j.JAQL420CANING = P_CANING
         AND j.JAQL420UGPRPR = P_UGPRREC
         AND j.JAQL420MOT = P_RECMTVC
         AND m.AQPB545MSCOD = P_RECSMTC
         AND j.JAQL420VRP = P_CANRESC
         AND j.JAQL420DABSOL BETWEEN P_RANINI AND P_RANFIN
         AND j.JAQL420COD NOT IN
             (SELECT AQPB545BCOD
                FROM AQPB545B
               WHERE AQPB545BRTIP IN ('REI', 'REC'));
    
      ---*** Reconsideracion y Sin Prorroga :=
      ---*** Reconsidereracion - Reconsideracion Con Prorroga
      ln_QTY_SI_RECON_SP := ln_QTY_SI_RECONSI - ln_QTY_SI_RECON_CP;
      ---*** Sin Reconsideracion :=
      ----*** Total - Con Reconsideracion
      ln_QTY_NO_RECONSI := ln_QTY_TOTAL - ln_QTY_SI_RECONSI;
      ---*** Sin Reconsideracion y Sin Prorroga :=
      ---*** Sin Reconsideracion - Sin Reconsideracion con Prorroga
      ln_QTY_NO_RECON_SP := ln_QTY_NO_RECONSI - ln_QTY_NO_RECON_CP;
    
      ---*********
      P_QTY_NO_RECON_SP := ln_QTY_NO_RECON_SP;
      P_QTY_NO_RECON_CP := ln_QTY_NO_RECON_CP;
      P_QTY_SI_RECON_SP := ln_QTY_SI_RECON_SP;
      P_QTY_SI_RECON_CP := ln_QTY_SI_RECON_CP;
      ---*********
    
    END IF;
  
  EXCEPTION
    WHEN OTHERS THEN
      ---***
      P_QTY_NO_RECON_SP := 0;
      P_QTY_NO_RECON_CP := 0;
      P_QTY_SI_RECON_SP := 0;
      P_QTY_SI_RECON_CP := 0;
    
      P_ERRCOD := '001';
      P_ERRMSG := sqlcode || ' ->>> ' || sqlerrm;
      ---***
  END SP_AH_REP_RR1_REC_ABSUELTO_RANGO_LINEA_P;

  PROCEDURE SP_AH_REP_RR1_RECIBIDOS_PERIODO(P_FECINI  IN DATE,
                                            P_FECFIN  IN DATE,
                                            P_CANOPEC IN NUMBER,
                                            P_RECOPSC IN NUMBER,
                                            P_CANING  IN NUMBER,
                                            P_UGPRREC IN NUMBER,
                                            P_RECMTVC IN NUMBER,
                                            P_RECSMTC IN NUMBER,
                                            P_BANSEG  IN NUMBER,
                                            P_RECQTY  OUT NUMBER,
                                            P_ERRCOD  OUT VARCHAR,
                                            P_ERRMSG  OUT VARCHAR) IS
  
  BEGIN
    ---***
    P_RECQTY := 0;
    ---***
    IF (P_RECSMTC = 0) THEN
      SELECT COUNT(*)
        INTO P_RECQTY
        FROM JAQL420 j
       WHERE j.JAQL420TRC = 1
         AND j.JAQL420ESR IN (1, 2, 3)
         AND JAQL420COD NOT IN
             (SELECT AQPB545BCOD FROM AQPB545B WHERE AQPB545BRTIP = 'REI')
         AND (((j.JAQL420FCR BETWEEN P_FECINI AND P_FECFIN) OR
             (j.JAQL420ESR = 3 AND j.JAQL420FCCCLI BETWEEN P_FECINI AND
             P_FECFIN) OR (j.JAQL420ESR = 3 AND j.JAQL420FCR < P_FECINI AND
             j.JAQL420FCCCLI > P_FECFIN) OR
             (j.JAQL420ESR IN (1, 2) AND j.JAQL420FCR < P_FECINI)) AND
             (j.JAQL420CAN = P_CANOPEC AND j.JAQL420OPS = P_RECOPSC AND
             j.JAQL420CANING = P_CANING AND j.JAQL420UGPRPR = P_UGPRREC AND
             j.JAQL420MOT = P_RECMTVC));
    END IF;
  
    IF (P_RECSMTC > 0) THEN
      SELECT COUNT(*)
        INTO P_RECQTY
        FROM JAQL420 j
        LEFT JOIN AQPB545M m
          ON (j.JAQL420EMP = m.AQPB545MREMP AND
             j.JAQL420COD = m.AQPB545MRCOD)
       WHERE j.JAQL420TRC = 1
         AND j.JAQL420ESR IN (1, 2, 3)
         AND JAQL420COD NOT IN
             (SELECT AQPB545BCOD FROM AQPB545B WHERE AQPB545BRTIP = 'REI')
         AND (((j.JAQL420FCR BETWEEN P_FECINI AND P_FECFIN) OR
             (j.JAQL420ESR = 3 AND j.JAQL420FCCCLI BETWEEN P_FECINI AND
             P_FECFIN) OR (j.JAQL420ESR = 3 AND j.JAQL420FCR < P_FECINI AND
             j.JAQL420FCCCLI > P_FECFIN) OR
             (j.JAQL420ESR IN (1, 2) AND j.JAQL420FCR < P_FECINI)) AND
             (j.JAQL420CAN = P_CANOPEC AND j.JAQL420OPS = P_RECOPSC AND
             j.JAQL420CANING = P_CANING AND j.JAQL420UGPRPR = P_UGPRREC AND
             j.JAQL420MOT = P_RECMTVC AND m.AQPB545MSCOD = P_RECSMTC));
    END IF;
  
  EXCEPTION
    WHEN OTHERS THEN
      ---***
      P_RECQTY := 0;
      P_ERRCOD := '001';
      P_ERRMSG := sqlcode || ' ->>> ' || sqlerrm;
      ---***
  END SP_AH_REP_RR1_RECIBIDOS_PERIODO;

  PROCEDURE SP_AH_REP_RR1_RECIBIDOS_PERIODO_R(P_FECINI    IN DATE,
                                              P_FECFIN    IN DATE,
                                              P_CANOPEC   IN NUMBER,
                                              P_RECOPSC   IN NUMBER,
                                              P_CANING    IN NUMBER,
                                              P_UGPRREC   IN NUMBER,
                                              P_RECMTVC   IN NUMBER,
                                              P_RECSMTC   IN NUMBER,
                                              P_BANSEG    IN NUMBER,
                                              P_CANRESC   IN NUMBER,
                                              P_RECQTY_NR OUT NUMBER,
                                              P_RECQTY_SR OUT NUMBER,
                                              P_ERRCOD    OUT VARCHAR,
                                              P_ERRMSG    OUT VARCHAR) IS
  
    ---***
    ln_QTY_TOTAL      NUMBER(9);
    ln_QTY_NO_RECONSI NUMBER(9);
    ln_QTY_SI_RECONSI NUMBER(9);
    lv_RECOPSC        VARCHAR(10);
    ---***
  
  BEGIN
    ---***
    P_RECQTY_NR := 0;
    P_RECQTY_SR := 0;
  
    ---********* OPS
    BEGIN
      lv_RECOPSC := TRIM(TO_CHAR(P_RECOPSC));
    EXCEPTION
      WHEN OTHERS THEN
        lv_RECOPSC := '';
    END;
    ---*********
    ---***
    -- Reclamos Normales y BS
    IF (P_RECSMTC = 0) THEN
      -- No tiene SubMotivo
      SELECT COUNT(*)
        INTO ln_QTY_TOTAL
        FROM JAQL420 j
       WHERE j.JAQL420TRC = 1
         AND j.JAQL420ESR IN (1, 2, 3)
         AND j.JAQL420FCR <= P_FECFIN
         AND JAQL420COD NOT IN
             (SELECT AQPB545BCOD FROM AQPB545B WHERE AQPB545BRTIP = 'REI')
         AND j.JAQL420COD NOT IN
             (SELECT AQPB545MRCOD
                FROM AQPB545M
               WHERE AQPB545MREMP = j.JAQL420EMP
                 AND AQPB545MRCOD = j.JAQL420COD)
         AND (((j.JAQL420FCR BETWEEN P_FECINI AND P_FECFIN) OR
             (j.JAQL420ESR = 3 AND j.JAQL420FCCCLI BETWEEN P_FECINI AND
             P_FECFIN) OR (j.JAQL420ESR = 3 AND j.JAQL420FCR < P_FECINI AND
             j.JAQL420FCCCLI > P_FECFIN) OR
             (j.JAQL420ESR IN (1, 2) AND j.JAQL420FCR < P_FECINI)) AND
             (j.JAQL420CAN = P_CANOPEC AND j.JAQL420OPS = lv_RECOPSC AND
             j.JAQL420CANING = P_CANING AND j.JAQL420UGPRPR = P_UGPRREC AND
             j.JAQL420MOT = P_RECMTVC AND j.JAQL420VRP = P_CANRESC));
    
      SELECT COUNT(*)
        INTO ln_QTY_SI_RECONSI
        FROM JAQL420 j
        JOIN AQPB545B b
          ON (j.JAQL420EMP = b.AQPB545BEMP AND j.JAQL420COD = b.AQPB545BCOD AND
             b.AQPB545BRTIP = 'REC')
       WHERE j.JAQL420TRC = 1
         AND j.JAQL420ESR IN (1, 2, 3)
         AND j.JAQL420FCR <= P_FECFIN
         AND JAQL420COD NOT IN
             (SELECT AQPB545BCOD FROM AQPB545B WHERE AQPB545BRTIP = 'REI')
         AND j.JAQL420COD NOT IN
             (SELECT AQPB545MRCOD
                FROM AQPB545M
               WHERE AQPB545MREMP = j.JAQL420EMP
                 AND AQPB545MRCOD = j.JAQL420COD)
         AND (((j.JAQL420FCR BETWEEN P_FECINI AND P_FECFIN) OR
             (j.JAQL420ESR = 3 AND j.JAQL420FCCCLI BETWEEN P_FECINI AND
             P_FECFIN) OR (j.JAQL420ESR = 3 AND j.JAQL420FCR < P_FECINI AND
             j.JAQL420FCCCLI > P_FECFIN) OR
             (j.JAQL420ESR IN (1, 2) AND j.JAQL420FCR < P_FECINI)) AND
             (j.JAQL420CAN = P_CANOPEC AND j.JAQL420OPS = lv_RECOPSC AND
             j.JAQL420CANING = P_CANING AND j.JAQL420UGPRPR = P_UGPRREC AND
             j.JAQL420MOT = P_RECMTVC AND j.JAQL420VRP = P_CANRESC));
    
      ln_QTY_NO_RECONSI := ln_QTY_TOTAL - ln_QTY_SI_RECONSI;
      P_RECQTY_NR       := ln_QTY_NO_RECONSI;
      P_RECQTY_SR       := ln_QTY_SI_RECONSI;
    
    END IF;
  
    IF (P_RECSMTC > 0) THEN
      -- Tiene SubMotivo
      SELECT COUNT(*)
        INTO ln_QTY_TOTAL
        FROM JAQL420 j
        JOIN AQPB545M m
          ON (j.JAQL420EMP = m.AQPB545MREMP AND
             j.JAQL420COD = m.AQPB545MRCOD)
       WHERE j.JAQL420TRC = 1
         AND j.JAQL420ESR IN (1, 2, 3)
         AND j.JAQL420FCR <= P_FECFIN
         AND JAQL420COD NOT IN
             (SELECT AQPB545BCOD FROM AQPB545B WHERE AQPB545BRTIP = 'REI')
         AND (((j.JAQL420FCR BETWEEN P_FECINI AND P_FECFIN) OR
             (j.JAQL420ESR = 3 AND j.JAQL420FCCCLI BETWEEN P_FECINI AND
             P_FECFIN) OR (j.JAQL420ESR = 3 AND j.JAQL420FCR < P_FECINI AND
             j.JAQL420FCCCLI > P_FECFIN) OR
             (j.JAQL420ESR IN (1, 2) AND j.JAQL420FCR < P_FECINI)) AND
             (j.JAQL420CAN = P_CANOPEC AND j.JAQL420OPS = lv_RECOPSC AND
             j.JAQL420CANING = P_CANING AND j.JAQL420UGPRPR = P_UGPRREC AND
             j.JAQL420MOT = P_RECMTVC AND m.AQPB545MSCOD = P_RECSMTC AND
             j.JAQL420VRP = P_CANRESC));
    
      SELECT COUNT(*)
        INTO ln_QTY_SI_RECONSI
        FROM JAQL420 j
        JOIN AQPB545M m
          ON (j.JAQL420EMP = m.AQPB545MREMP AND
             j.JAQL420COD = m.AQPB545MRCOD)
        JOIN AQPB545B b
          ON (j.JAQL420EMP = b.AQPB545BEMP AND j.JAQL420COD = b.AQPB545BCOD AND
             b.AQPB545BRTIP = 'REC')
       WHERE j.JAQL420TRC = 1
         AND j.JAQL420ESR IN (1, 2, 3)
         AND j.JAQL420FCR <= P_FECFIN
         AND JAQL420COD NOT IN
             (SELECT AQPB545BCOD FROM AQPB545B WHERE AQPB545BRTIP = 'REI')
         AND (((j.JAQL420FCR BETWEEN P_FECINI AND P_FECFIN) OR
             (j.JAQL420ESR = 3 AND j.JAQL420FCCCLI BETWEEN P_FECINI AND
             P_FECFIN) OR (j.JAQL420ESR = 3 AND j.JAQL420FCR < P_FECINI AND
             j.JAQL420FCCCLI > P_FECFIN) OR
             (j.JAQL420ESR IN (1, 2) AND j.JAQL420FCR < P_FECINI)) AND
             (j.JAQL420CAN = P_CANOPEC AND j.JAQL420OPS = lv_RECOPSC AND
             j.JAQL420CANING = P_CANING AND j.JAQL420UGPRPR = P_UGPRREC AND
             j.JAQL420MOT = P_RECMTVC AND m.AQPB545MSCOD = P_RECSMTC AND
             j.JAQL420VRP = P_CANRESC));
    
      ln_QTY_NO_RECONSI := ln_QTY_TOTAL - ln_QTY_SI_RECONSI;
      P_RECQTY_NR       := ln_QTY_NO_RECONSI;
      P_RECQTY_SR       := ln_QTY_SI_RECONSI;
    
    END IF;
  
  EXCEPTION
    WHEN OTHERS THEN
      ---***
      P_RECQTY_NR := 0;
      P_RECQTY_SR := 0;
      P_ERRCOD    := '001';
      P_ERRMSG    := sqlcode || ' ->>> ' || sqlerrm;
      ---***
  END SP_AH_REP_RR1_RECIBIDOS_PERIODO_R;

  PROCEDURE SP_AH_REP_RR1_REC_TRAMITE_RANGO_LINEA_P(P_FECINI          IN DATE,
                                                    P_FECFIN          IN DATE,
                                                    P_CANOPEC         IN NUMBER,
                                                    P_RECOPSC         IN NUMBER,
                                                    P_CANING          IN NUMBER,
                                                    P_UGPRREC         IN NUMBER,
                                                    P_RECMTVC         IN NUMBER,
                                                    P_RECSMTC         IN NUMBER,
                                                    P_BANSEG          IN NUMBER,
                                                    P_CANRESC         IN NUMBER,
                                                    P_RANINI          IN NUMBER,
                                                    P_RANFIN          IN NUMBER,
                                                    P_QTY_NO_RECON_SP OUT NUMBER,
                                                    P_QTY_NO_RECON_CP OUT NUMBER,
                                                    P_QTY_SI_RECON_SP OUT NUMBER,
                                                    P_QTY_SI_RECON_CP OUT NUMBER,
                                                    P_ERRCOD          OUT VARCHAR,
                                                    P_ERRMSG          OUT VARCHAR) IS
  
    ---***
    ln_QTY_TOTAL      NUMBER(9);
    ln_QTY_NO_RECONSI NUMBER(9);
    ln_QTY_SI_RECONSI NUMBER(9);
  
    ln_QTY_NO_RECON_SP NUMBER(9);
    ln_QTY_NO_RECON_CP NUMBER(9);
    ln_QTY_SI_RECON_SP NUMBER(9);
    ln_QTY_SI_RECON_CP NUMBER(9);
  
    lv_RECOPSC VARCHAR(10);
  
  BEGIN
    ---***
    P_QTY_NO_RECON_SP := 0;
    P_QTY_NO_RECON_CP := 0;
    P_QTY_SI_RECON_SP := 0;
    P_QTY_SI_RECON_CP := 0;
    ---***
  
    ---********* OPS
    BEGIN
      lv_RECOPSC := TRIM(TO_CHAR(P_RECOPSC));
    EXCEPTION
      WHEN OTHERS THEN
        lv_RECOPSC := '';
    END;
    ---*********
  
    -- Reclamos Normales y BS
    IF (P_RECSMTC = 0) THEN
      -- No tiene SubMotivo
      SELECT COUNT(*)
        INTO ln_QTY_TOTAL
        FROM JAQL420 j
       WHERE j.JAQL420TRC = 1
         AND j.JAQL420ESR IN (1, 2, 3)
         AND j.JAQL420FCR <= P_FECFIN
         AND j.JAQL420CAN = P_CANOPEC
         AND j.JAQL420OPS = lv_RECOPSC
         AND j.JAQL420CANING = P_CANING
         AND j.JAQL420UGPRPR = P_UGPRREC
         AND j.JAQL420MOT = P_RECMTVC
         AND j.JAQL420VRP = P_CANRESC
         AND FN_AH_DIAS_REC_ABSOLUCION(j.JAQL420COD, P_FECFIN) BETWEEN
             P_RANINI AND P_RANFIN
         AND j.JAQL420COD NOT IN
             (SELECT AQPB545MRCOD
                FROM AQPB545M
               WHERE AQPB545MREMP = j.JAQL420EMP
                 AND AQPB545MRCOD = j.JAQL420COD)
         AND JAQL420COD NOT IN
             (SELECT AQPB545BCOD FROM AQPB545B WHERE AQPB545BRTIP = 'REI')
         AND ((j.JAQL420ESR IN (1, 2) AND j.JAQL420FCR BETWEEN P_FECINI AND
             P_FECFIN) OR
             (j.JAQL420ESR = 3 AND j.JAQL420FCCCLI > P_FECFIN) OR
             (j.JAQL420ESR IN (1, 2) AND j.JAQL420FCR < P_FECINI));
    
      SELECT COUNT(*)
        INTO ln_QTY_SI_RECONSI
        FROM JAQL420 j
        JOIN AQPB545B b
          ON (j.JAQL420EMP = b.AQPB545BEMP AND j.JAQL420COD = b.AQPB545BCOD)
       WHERE j.JAQL420TRC = 1
         AND j.JAQL420ESR IN (1, 2, 3)
         AND j.JAQL420FCR <= P_FECFIN
         AND j.JAQL420CAN = P_CANOPEC
         AND j.JAQL420OPS = lv_RECOPSC
         AND j.JAQL420CANING = P_CANING
         AND j.JAQL420UGPRPR = P_UGPRREC
         AND j.JAQL420MOT = P_RECMTVC
         AND j.JAQL420VRP = P_CANRESC
         AND FN_AH_DIAS_REC_ABSOLUCION(j.JAQL420COD, P_FECFIN) BETWEEN
             P_RANINI AND P_RANFIN
         AND j.JAQL420COD NOT IN
             (SELECT AQPB545MRCOD
                FROM AQPB545M
               WHERE AQPB545MREMP = j.JAQL420EMP
                 AND AQPB545MRCOD = j.JAQL420COD)
         AND JAQL420COD NOT IN
             (SELECT AQPB545BCOD FROM AQPB545B WHERE AQPB545BRTIP = 'REI')
         AND ((j.JAQL420ESR IN (1, 2) AND j.JAQL420FCR BETWEEN P_FECINI AND
             P_FECFIN) OR
             (j.JAQL420ESR = 3 AND j.JAQL420FCCCLI > P_FECFIN) OR
             (j.JAQL420ESR IN (1, 2) AND j.JAQL420FCR < P_FECINI));
    
      SELECT COUNT(*)
        INTO ln_QTY_SI_RECON_CP
        FROM JAQL420 j
        JOIN AQPB546A a
          ON (j.JAQL420EMP = a.AQPB546ARECEMP AND
             j.JAQL420COD = a.AQPB546ARECCOD AND a.AQPB546ARECTIP = 'REC' AND
             a.AQPB546AESTAMP = 'V' AND
             (a.AQPB546AFECCOM <= P_FECFIN AND
             a.AQPB546AFECCOM <> TO_DATE('01/01/0001', 'dd/MM/yyyy')))
        JOIN AQPB545B b
          ON (j.JAQL420EMP = b.AQPB545BEMP AND j.JAQL420COD = b.AQPB545BCOD)
       WHERE j.JAQL420TRC = 1
         AND j.JAQL420ESR IN (1, 2, 3)
         AND j.JAQL420FCR <= P_FECFIN
         AND j.JAQL420CAN = P_CANOPEC
         AND j.JAQL420OPS = lv_RECOPSC
         AND j.JAQL420CANING = P_CANING
         AND j.JAQL420UGPRPR = P_UGPRREC
         AND j.JAQL420MOT = P_RECMTVC
         AND j.JAQL420VRP = P_CANRESC
         AND FN_AH_DIAS_REC_ABSOLUCION(j.JAQL420COD, P_FECFIN) BETWEEN
             P_RANINI AND P_RANFIN
         AND j.JAQL420COD NOT IN
             (SELECT AQPB545MRCOD
                FROM AQPB545M
               WHERE AQPB545MREMP = j.JAQL420EMP
                 AND AQPB545MRCOD = j.JAQL420COD)
         AND JAQL420COD NOT IN
             (SELECT AQPB545BCOD FROM AQPB545B WHERE AQPB545BRTIP = 'REI')
         AND ((j.JAQL420ESR IN (1, 2) AND j.JAQL420FCR BETWEEN P_FECINI AND
             P_FECFIN) OR
             (j.JAQL420ESR = 3 AND j.JAQL420FCCCLI > P_FECFIN) OR
             (j.JAQL420ESR IN (1, 2) AND j.JAQL420FCR < P_FECINI));
    
      SELECT COUNT(*)
        INTO ln_QTY_NO_RECON_CP
        FROM JAQL420 j
        JOIN AQPB546A a
          ON (j.JAQL420EMP = a.AQPB546ARECEMP AND
             j.JAQL420COD = a.AQPB546ARECCOD AND a.AQPB546ARECTIP = 'REC' AND
             a.AQPB546AESTAMP = 'V' AND
             (a.AQPB546AFECCOM <= P_FECFIN AND
             a.AQPB546AFECCOM <> TO_DATE('01/01/0001', 'dd/MM/yyyy')))
       WHERE j.JAQL420TRC = 1
         AND j.JAQL420ESR IN (1, 2, 3)
         AND j.JAQL420FCR <= P_FECFIN
         AND j.JAQL420CAN = P_CANOPEC
         AND j.JAQL420OPS = lv_RECOPSC
         AND j.JAQL420CANING = P_CANING
         AND j.JAQL420UGPRPR = P_UGPRREC
         AND j.JAQL420MOT = P_RECMTVC
         AND j.JAQL420VRP = P_CANRESC
         AND FN_AH_DIAS_REC_ABSOLUCION(j.JAQL420COD, P_FECFIN) BETWEEN
             P_RANINI AND P_RANFIN
         AND j.JAQL420COD NOT IN
             (SELECT AQPB545MRCOD
                FROM AQPB545M
               WHERE AQPB545MREMP = j.JAQL420EMP
                 AND AQPB545MRCOD = j.JAQL420COD)
         AND JAQL420COD NOT IN
             (SELECT AQPB545BCOD
                FROM AQPB545B
               WHERE AQPB545BRTIP IN ('REI', 'REC'))
         AND ((j.JAQL420ESR IN (1, 2) AND j.JAQL420FCR BETWEEN P_FECINI AND
             P_FECFIN) OR
             (j.JAQL420ESR = 3 AND j.JAQL420FCCCLI > P_FECFIN) OR
             (j.JAQL420ESR IN (1, 2) AND j.JAQL420FCR < P_FECINI));
      ---*** Reconsideracion y Sin Prorroga :=
      ---*** Reconsidereracion - Reconsideracion Con Prorroga
      ln_QTY_SI_RECON_SP := ln_QTY_SI_RECONSI - ln_QTY_SI_RECON_CP;
      ---*** Sin Reconsideracion :=
      ----*** Total - Con Reconsideracion
      ln_QTY_NO_RECONSI := ln_QTY_TOTAL - ln_QTY_SI_RECONSI;
      ---*** Sin Reconsideracion y Sin Prorroga :=
      ---*** Sin Reconsideracion - Sin Reconsideracion con Prorroga
      ln_QTY_NO_RECON_SP := ln_QTY_NO_RECONSI - ln_QTY_NO_RECON_CP;
      ---*********
      P_QTY_NO_RECON_SP := ln_QTY_NO_RECON_SP;
      P_QTY_NO_RECON_CP := ln_QTY_NO_RECON_CP;
      P_QTY_SI_RECON_SP := ln_QTY_SI_RECON_SP;
      P_QTY_SI_RECON_CP := ln_QTY_SI_RECON_CP;
      ---*********
    
    END IF;
  
    IF (P_RECSMTC > 0) THEN
      -- Tiene SubMotivo
      SELECT COUNT(*)
        INTO ln_QTY_TOTAL
        FROM JAQL420 j
        JOIN AQPB545M m
          ON (j.JAQL420EMP = m.AQPB545MREMP AND
             j.JAQL420COD = m.AQPB545MRCOD)
       WHERE j.JAQL420TRC = 1
         AND j.JAQL420ESR IN (1, 2, 3)
         AND j.JAQL420FCR <= P_FECFIN
         AND j.JAQL420CAN = P_CANOPEC
         AND j.JAQL420OPS = lv_RECOPSC
         AND j.JAQL420CANING = P_CANING
         AND j.JAQL420UGPRPR = P_UGPRREC
         AND j.JAQL420MOT = P_RECMTVC
         AND m.AQPB545MSCOD = P_RECSMTC
         AND j.JAQL420VRP = P_CANRESC
         AND FN_AH_DIAS_REC_ABSOLUCION(j.JAQL420COD, P_FECFIN) BETWEEN
             P_RANINI AND P_RANFIN
         AND JAQL420COD NOT IN
             (SELECT AQPB545BCOD FROM AQPB545B WHERE AQPB545BRTIP = 'REI')
         AND ((j.JAQL420ESR IN (1, 2) AND j.JAQL420FCR BETWEEN P_FECINI AND
             P_FECFIN) OR
             (j.JAQL420ESR = 3 AND j.JAQL420FCCCLI > P_FECFIN) OR
             (j.JAQL420ESR IN (1, 2) AND j.JAQL420FCR < P_FECINI));
    
      SELECT COUNT(*)
        INTO ln_QTY_SI_RECONSI
        FROM JAQL420 j
        JOIN AQPB545B b
          ON (j.JAQL420EMP = b.AQPB545BEMP AND j.JAQL420COD = b.AQPB545BCOD)
        JOIN AQPB545M m
          ON (j.JAQL420EMP = m.AQPB545MREMP AND
             j.JAQL420COD = m.AQPB545MRCOD)
       WHERE j.JAQL420TRC = 1
         AND j.JAQL420ESR IN (1, 2, 3)
         AND j.JAQL420FCR <= P_FECFIN
         AND j.JAQL420CAN = P_CANOPEC
         AND j.JAQL420OPS = lv_RECOPSC
         AND j.JAQL420CANING = P_CANING
         AND j.JAQL420UGPRPR = P_UGPRREC
         AND j.JAQL420MOT = P_RECMTVC
         AND m.AQPB545MSCOD = P_RECSMTC
         AND j.JAQL420VRP = P_CANRESC
         AND FN_AH_DIAS_REC_ABSOLUCION(j.JAQL420COD, P_FECFIN) BETWEEN
             P_RANINI AND P_RANFIN
         AND JAQL420COD NOT IN
             (SELECT AQPB545BCOD FROM AQPB545B WHERE AQPB545BRTIP = 'REI')
         AND ((j.JAQL420ESR IN (1, 2) AND j.JAQL420FCR BETWEEN P_FECINI AND
             P_FECFIN) OR
             (j.JAQL420ESR = 3 AND j.JAQL420FCCCLI > P_FECFIN) OR
             (j.JAQL420ESR IN (1, 2) AND j.JAQL420FCR < P_FECINI));
    
      SELECT COUNT(*)
        INTO ln_QTY_SI_RECON_CP
        FROM JAQL420 j
        JOIN AQPB546A a
          ON (j.JAQL420EMP = a.AQPB546ARECEMP AND
             j.JAQL420COD = a.AQPB546ARECCOD AND a.AQPB546ARECTIP = 'REC' AND
             a.AQPB546AESTAMP = 'V' AND
             (a.AQPB546AFECCOM <= P_FECFIN AND
             a.AQPB546AFECCOM <> TO_DATE('01/01/0001', 'dd/MM/yyyy')))
        JOIN AQPB545B b
          ON (j.JAQL420EMP = b.AQPB545BEMP AND j.JAQL420COD = b.AQPB545BCOD)
        JOIN AQPB545M m
          ON (j.JAQL420EMP = m.AQPB545MREMP AND
             j.JAQL420COD = m.AQPB545MRCOD)
       WHERE j.JAQL420TRC = 1
         AND j.JAQL420ESR IN (1, 2, 3)
         AND j.JAQL420FCR <= P_FECFIN
         AND j.JAQL420CAN = P_CANOPEC
         AND j.JAQL420OPS = lv_RECOPSC
         AND j.JAQL420CANING = P_CANING
         AND j.JAQL420UGPRPR = P_UGPRREC
         AND j.JAQL420MOT = P_RECMTVC
         AND m.AQPB545MSCOD = P_RECSMTC
         AND j.JAQL420VRP = P_CANRESC
         AND FN_AH_DIAS_REC_ABSOLUCION(j.JAQL420COD, P_FECFIN) BETWEEN
             P_RANINI AND P_RANFIN
         AND JAQL420COD NOT IN
             (SELECT AQPB545BCOD FROM AQPB545B WHERE AQPB545BRTIP = 'REI')
         AND ((j.JAQL420ESR IN (1, 2) AND j.JAQL420FCR BETWEEN P_FECINI AND
             P_FECFIN) OR
             (j.JAQL420ESR = 3 AND j.JAQL420FCCCLI > P_FECFIN) OR
             (j.JAQL420ESR IN (1, 2) AND j.JAQL420FCR < P_FECINI));
    
      SELECT COUNT(*)
        INTO ln_QTY_NO_RECON_CP
        FROM JAQL420 j
        JOIN AQPB546A a
          ON (j.JAQL420EMP = a.AQPB546ARECEMP AND
             j.JAQL420COD = a.AQPB546ARECCOD AND a.AQPB546ARECTIP = 'REC' AND
             a.AQPB546AESTAMP = 'V' AND
             (a.AQPB546AFECCOM <= P_FECFIN AND
             a.AQPB546AFECCOM <> TO_DATE('01/01/0001', 'dd/MM/yyyy')))
        JOIN AQPB545M m
          ON (j.JAQL420EMP = m.AQPB545MREMP AND
             j.JAQL420COD = m.AQPB545MRCOD)
       WHERE j.JAQL420TRC = 1
         AND j.JAQL420ESR IN (1, 2, 3)
         AND j.JAQL420FCR <= P_FECFIN
         AND j.JAQL420CAN = P_CANOPEC
         AND j.JAQL420OPS = lv_RECOPSC
         AND j.JAQL420CANING = P_CANING
         AND j.JAQL420UGPRPR = P_UGPRREC
         AND j.JAQL420MOT = P_RECMTVC
         AND m.AQPB545MSCOD = P_RECSMTC
         AND j.JAQL420VRP = P_CANRESC
         AND FN_AH_DIAS_REC_ABSOLUCION(j.JAQL420COD, P_FECFIN) BETWEEN
             P_RANINI AND P_RANFIN
         AND JAQL420COD NOT IN
             (SELECT AQPB545BCOD
                FROM AQPB545B
               WHERE AQPB545BRTIP IN ('REI', 'REC'))
         AND ((j.JAQL420ESR IN (1, 2) AND j.JAQL420FCR BETWEEN P_FECINI AND
             P_FECFIN) OR
             (j.JAQL420ESR = 3 AND j.JAQL420FCCCLI > P_FECFIN) OR
             (j.JAQL420ESR IN (1, 2) AND j.JAQL420FCR < P_FECINI));
    
      ---*** Reconsideracion y Sin Prorroga :=
      ---*** Reconsidereracion - Reconsideracion Con Prorroga
      ln_QTY_SI_RECON_SP := ln_QTY_SI_RECONSI - ln_QTY_SI_RECON_CP;
      ---*** Sin Reconsideracion :=
      ----*** Total - Con Reconsideracion
      ln_QTY_NO_RECONSI := ln_QTY_TOTAL - ln_QTY_SI_RECONSI;
      ---*** Sin Reconsideracion y Sin Prorroga :=
      ---*** Sin Reconsideracion - Sin Reconsideracion con Prorroga
      ln_QTY_NO_RECON_SP := ln_QTY_NO_RECONSI - ln_QTY_NO_RECON_CP;
      ---*********
      P_QTY_NO_RECON_SP := ln_QTY_NO_RECON_SP;
      P_QTY_NO_RECON_CP := ln_QTY_NO_RECON_CP;
      P_QTY_SI_RECON_SP := ln_QTY_SI_RECON_SP;
      P_QTY_SI_RECON_CP := ln_QTY_SI_RECON_CP;
      ---*********
    
    END IF;
  
  EXCEPTION
    WHEN OTHERS THEN
      ---***
      P_QTY_NO_RECON_SP := 0;
      P_QTY_NO_RECON_CP := 0;
      P_QTY_SI_RECON_SP := 0;
      P_QTY_SI_RECON_CP := 0;
    
      P_ERRCOD := '001';
      P_ERRMSG := sqlcode || ' ->>> ' || sqlerrm;
      ---***
  END SP_AH_REP_RR1_REC_TRAMITE_RANGO_LINEA_P;

  PROCEDURE SP_AH_REP_RR1_REC_TRAMITE_TOTAL_LINEA(P_FECINI    IN DATE,
                                                  P_FECFIN    IN DATE,
                                                  P_CANOPEC   IN NUMBER,
                                                  P_RECOPSC   IN NUMBER,
                                                  P_CANING    IN NUMBER,
                                                  P_UGPRREC   IN NUMBER,
                                                  P_RECMTVC   IN NUMBER,
                                                  P_RECSMTC   IN NUMBER,
                                                  P_BANSEG    IN NUMBER,
                                                  P_CANRESC   IN NUMBER,
                                                  P_RECQTY_NR OUT NUMBER,
                                                  P_RECQTY_SR OUT NUMBER,
                                                  P_ERRCOD    OUT VARCHAR,
                                                  P_ERRMSG    OUT VARCHAR) IS
  
    ---***
    ln_QTY_TOTAL      NUMBER(9);
    ln_QTY_NO_RECONSI NUMBER(9);
    ln_QTY_SI_RECONSI NUMBER(9);
  
  BEGIN
    ---***
    P_RECQTY_NR := 0;
    P_RECQTY_SR := 0;
    ---***
    -- Reclamos Normales y BS
    IF (P_RECSMTC = 0) THEN
      -- No tiene SubMotivo
      SELECT COUNT(*)
        INTO ln_QTY_TOTAL
        FROM JAQL420 j
       WHERE j.JAQL420TRC = 1
         AND j.JAQL420ESR IN (1, 2, 3)
         AND j.JAQL420FCR <= P_FECFIN
         AND JAQL420COD NOT IN
             (SELECT AQPB545BCOD FROM AQPB545B WHERE AQPB545BRTIP = 'REI')
         AND (((j.JAQL420ESR IN (1, 2) AND j.JAQL420FCR BETWEEN P_FECINI AND
             P_FECFIN) OR (j.JAQL420ESR = 3 AND j.JAQL420FCR < P_FECINI AND
             j.JAQL420FCCCLI > P_FECFIN) OR
             (j.JAQL420ESR IN (1, 2) AND j.JAQL420FCR < P_FECINI)) AND
             (j.JAQL420CAN = P_CANOPEC AND j.JAQL420OPS = P_RECOPSC AND
             j.JAQL420CANING = P_CANING AND j.JAQL420UGPRPR = P_UGPRREC AND
             j.JAQL420MOT = P_RECMTVC AND j.JAQL420VRP = P_CANRESC));
    
      SELECT COUNT(*)
        INTO ln_QTY_SI_RECONSI
        FROM JAQL420 j
        JOIN AQPB545B b
          ON (j.JAQL420EMP = b.AQPB545BEMP AND j.JAQL420COD = b.AQPB545BCOD)
       WHERE j.JAQL420TRC = 1
         AND j.JAQL420ESR IN (1, 2, 3)
         AND j.JAQL420FCR <= P_FECFIN
         AND JAQL420COD NOT IN
             (SELECT AQPB545BCOD FROM AQPB545B WHERE AQPB545BRTIP = 'REI')
         AND (((j.JAQL420ESR IN (1, 2) AND j.JAQL420FCR BETWEEN P_FECINI AND
             P_FECFIN) OR (j.JAQL420ESR = 3 AND j.JAQL420FCR < P_FECINI AND
             j.JAQL420FCCCLI > P_FECFIN) OR
             (j.JAQL420ESR IN (1, 2) AND j.JAQL420FCR < P_FECINI)) AND
             (j.JAQL420CAN = P_CANOPEC AND j.JAQL420OPS = P_RECOPSC AND
             j.JAQL420CANING = P_CANING AND j.JAQL420UGPRPR = P_UGPRREC AND
             j.JAQL420MOT = P_RECMTVC AND j.JAQL420VRP = P_CANRESC));
    
      ln_QTY_NO_RECONSI := ln_QTY_TOTAL - ln_QTY_SI_RECONSI;
      P_RECQTY_NR       := ln_QTY_NO_RECONSI;
      P_RECQTY_SR       := ln_QTY_SI_RECONSI;
    
    END IF;
  
    IF (P_RECSMTC > 0) THEN
      -- Tiene SubMotivo
      SELECT COUNT(*)
        INTO ln_QTY_TOTAL
        FROM JAQL420 j
        LEFT JOIN AQPB545M m
          ON (j.JAQL420EMP = m.AQPB545MREMP AND
             j.JAQL420COD = m.AQPB545MRCOD)
       WHERE j.JAQL420TRC = 1
         AND j.JAQL420ESR IN (1, 2, 3)
         AND j.JAQL420FCR <= P_FECFIN
         AND JAQL420COD NOT IN
             (SELECT AQPB545BCOD FROM AQPB545B WHERE AQPB545BRTIP = 'REI')
         AND (((j.JAQL420ESR IN (1, 2) AND j.JAQL420FCR BETWEEN P_FECINI AND
             P_FECFIN) OR (j.JAQL420ESR = 3 AND j.JAQL420FCR < P_FECINI AND
             j.JAQL420FCCCLI > P_FECFIN) OR
             (j.JAQL420ESR IN (1, 2) AND j.JAQL420FCR < P_FECINI)) AND
             (j.JAQL420CAN = P_CANOPEC AND j.JAQL420OPS = P_RECOPSC AND
             j.JAQL420CANING = P_CANING AND j.JAQL420UGPRPR = P_UGPRREC AND
             j.JAQL420MOT = P_RECMTVC AND m.AQPB545MSCOD = P_RECSMTC AND
             j.JAQL420VRP = P_CANRESC));
    
      SELECT COUNT(*)
        INTO ln_QTY_SI_RECONSI
        FROM JAQL420 j
        JOIN AQPB545B b
          ON (j.JAQL420EMP = b.AQPB545BEMP AND j.JAQL420COD = b.AQPB545BCOD)
        LEFT JOIN AQPB545M m
          ON (j.JAQL420EMP = m.AQPB545MREMP AND
             j.JAQL420COD = m.AQPB545MRCOD)
       WHERE j.JAQL420TRC = 1
         AND j.JAQL420ESR IN (1, 2, 3)
         AND j.JAQL420FCR <= P_FECFIN
         AND JAQL420COD NOT IN
             (SELECT AQPB545BCOD FROM AQPB545B WHERE AQPB545BRTIP = 'REI')
         AND (((j.JAQL420ESR IN (1, 2) AND j.JAQL420FCR BETWEEN P_FECINI AND
             P_FECFIN) OR (j.JAQL420ESR = 3 AND j.JAQL420FCR < P_FECINI AND
             j.JAQL420FCCCLI > P_FECFIN) OR
             (j.JAQL420ESR IN (1, 2) AND j.JAQL420FCR < P_FECINI)) AND
             (j.JAQL420CAN = P_CANOPEC AND j.JAQL420OPS = P_RECOPSC AND
             j.JAQL420CANING = P_CANING AND j.JAQL420UGPRPR = P_UGPRREC AND
             j.JAQL420MOT = P_RECMTVC AND m.AQPB545MSCOD = P_RECSMTC AND
             j.JAQL420VRP = P_CANRESC));
    
      ln_QTY_NO_RECONSI := ln_QTY_TOTAL - ln_QTY_SI_RECONSI;
      P_RECQTY_NR       := ln_QTY_NO_RECONSI;
      P_RECQTY_SR       := ln_QTY_SI_RECONSI;
    
    END IF;
  
  EXCEPTION
    WHEN OTHERS THEN
      ---***
      P_RECQTY_NR := 0;
      P_RECQTY_SR := 0;
      P_ERRCOD    := '001';
      P_ERRMSG    := sqlcode || ' ->>> ' || sqlerrm;
      ---***
  END SP_AH_REP_RR1_REC_TRAMITE_TOTAL_LINEA;

  PROCEDURE SP_AH_REP_RR1_GENERA_REPORTE_TEST(P_CREUSR IN VARCHAR,
                                              P_ERRCOD OUT VARCHAR,
                                              P_ERRMSG OUT VARCHAR) IS
  
    ln_QTYRECPER NUMBER(9); -- Cantidad de Reclamos del Periodo
    ln_RECQTY_NR NUMBER(9); -- Cantidad de Reclamos del Periodo SIN Reconsideracion
    ln_RECQTY_SR NUMBER(9); -- Cantidad de Reclamos del Periodo CON Reconsideracion
    lv_ERRCOD    VARCHAR(3);
    lv_ERRMSG    VARCHAR(600);
  
  BEGIN
  
    P_ERRCOD := '000';
    P_ERRMSG := '';
  
    ln_QTYRECPER := 0;
    ln_RECQTY_NR := 0;
    ln_RECQTY_SR := 0;
  
    lv_ERRCOD := '000';
    lv_ERRMSG := '';
  
    FOR XROW IN (SELECT *
                   FROM AQPB548
                  WHERE AQPB548CREUSR = P_CREUSR
                  ORDER BY AQPB548RECOPSS, AQPB548RECMTVS, AQPB548UGPRRES)
    
     LOOP
      --DBMS_OUTPUT.PUT_LINE('*************************************************');
      --DBMS_OUTPUT.PUT_LINE('AQPB548RR1KEYE:= ' || XROW.AQPB548RR1KEYE);
      --DBMS_OUTPUT.PUT_LINE('XROW.AQPB548FECINI:= ' || XROW.AQPB548FECINI);
      --DBMS_OUTPUT.PUT_LINE('XROW.AQPB548FECFIN:= ' || XROW.AQPB548FECFIN);
      --DBMS_OUTPUT.PUT_LINE('XROW.AQPB548CANOPEC:= ' || XROW.AQPB548CANOPEC);
      --DBMS_OUTPUT.PUT_LINE('XROW.AQPB548RECOPSC:= ' || XROW.AQPB548RECOPSC);
      --DBMS_OUTPUT.PUT_LINE('XROW.AQPB548CANINGS:= ' || XROW.AQPB548CANINGS);
      --DBMS_OUTPUT.PUT_LINE('XROW.AQPB548UGPRREC:= ' || XROW.AQPB548UGPRREC);
      --DBMS_OUTPUT.PUT_LINE('XROW.AQPB548RECMTVC:= ' || XROW.AQPB548RECMTVC);
      --DBMS_OUTPUT.PUT_LINE('XROW.AQPB548RECSMTC:= ' || XROW.AQPB548RECSMTC);
    
      /*
      SP_AH_REP_RR1_RECIBIDOS_PERIODO(XROW.AQPB548FECINI
      , XROW.AQPB548FECFIN
      , XROW.AQPB548CANOPEC
      , XROW.AQPB548RECOPSC
      , XROW.AQPB548CANINGS
      , XROW.AQPB548UGPRREC
      , XROW.AQPB548RECMTVC
      , XROW.AQPB548RECSMTC
      , XROW.AQPB548BANSEG
      , ln_QTYRECPER
      , lv_ERRCOD
      , lv_ERRMSG);
      
      
      --DBMS_OUTPUT.PUT_LINE('ln_QTYRECPER:= '||ln_QTYRECPER);
      --DBMS_OUTPUT.PUT_LINE('lv_ERRCOD:= '||lv_ERRCOD);
      --DBMS_OUTPUT.PUT_LINE('lv_ERRMSG:= '||lv_ERRMSG);
      --DBMS_OUTPUT.PUT_LINE('*************************************************');
      */
      /*
      SP_AH_REP_RR1_RECIBIDOS_PERIODO_R(XROW.AQPB548FECINI
      , XROW.AQPB548FECFIN
      , XROW.AQPB548CANOPEC
      , XROW.AQPB548RECOPSC
      , XROW.AQPB548CANINGS
      , XROW.AQPB548UGPRREC
      , XROW.AQPB548RECMTVC
      , XROW.AQPB548RECSMTC
      , XROW.AQPB548BANSEG
      , XROW.AQPB548CANRESC
      , ln_RECQTY_NR
      , ln_RECQTY_SR
      , lv_ERRCOD
      , lv_ERRMSG);
      
      IF(XROW.AQPB548REITER = 1) THEN
         --DBMS_OUTPUT.PUT_LINE('ln_RECQTY_NR:= '||ln_RECQTY_NR);
      END IF;
      IF(XROW.AQPB548REITER = 2) THEN
         --DBMS_OUTPUT.PUT_LINE('ln_RECQTY_SR:= '||ln_RECQTY_SR);
      END IF;
      */
    
      /*
      PQ_AH_RECLAMOS_RR.SP_AH_REP_RR1_REC_TRAMITE_RANGO_LINEA(XROW.AQPB548FECINI,
                                            XROW.AQPB548FECFIN,
                                            XROW.AQPB548CANOPEC,
                                            XROW.AQPB548RECOPSC,
                                            XROW.AQPB548CANINGS,
                                            XROW.AQPB548UGPRREC,
                                            XROW.AQPB548RECMTVC,
                                            XROW.AQPB548RECSMTC,
                                            XROW.AQPB548BANSEG,
                                            XROW.AQPB548CANRESC,
                                            15,
                                            9999,
                                            ln_RECQTY_NR,
                                            ln_RECQTY_SR,
                                            lv_ERRCOD,
                                            lv_ERRMSG);
                                            */
    
      IF (XROW.AQPB548REITER = 1) THEN
        DBMS_OUTPUT.PUT_LINE('ln_RECQTY_NR:= ' || ln_RECQTY_NR);
      END IF;
      IF (XROW.AQPB548REITER = 2) THEN
        DBMS_OUTPUT.PUT_LINE('ln_RECQTY_SR:= ' || ln_RECQTY_SR);
      END IF;
      --DBMS_OUTPUT.PUT_LINE('lv_ERRCOD:= ' || lv_ERRCOD);
    --DBMS_OUTPUT.PUT_LINE('lv_ERRMSG:= ' || lv_ERRMSG);
    --DBMS_OUTPUT.PUT_LINE('*************************************************');
    
    END LOOP;
  
  EXCEPTION
    WHEN OTHERS THEN
      ---***
      P_ERRCOD := '001';
      P_ERRMSG := sqlcode || ' ->>> ' || sqlerrm;
      ---***
  END SP_AH_REP_RR1_GENERA_REPORTE_TEST;

  -- REPORTE DE ESTADISTICA
  PROCEDURE SP_AH_REP_ESTADISTICA_F(P_CREUSR IN VARCHAR,
                                    P_FECINI IN DATE,
                                    P_FECFIN IN DATE,
                                    P_ERRCOD OUT VARCHAR,
                                    P_ERRMSG OUT VARCHAR) IS
  
    ---***
    ln_TOP10_OPS NUMBER(9);
    ln_TOP4_MOT  NUMBER(9);
    ln_OPSC_OLD  NUMBER(9);
    ---***
    ln_OTROS_FE     NUMBER(9);
    ln_OTROS_V_FE   NUMBER(9);
    ln_OTROS_S_FE   NUMBER(9);
    ln_OTROS_FU     NUMBER(9);
    ln_OTROS_V_FU   NUMBER(9);
    ln_OTROS_S_FU   NUMBER(9);
    ln_OTROS        NUMBER(9);
    ln_OTROS_V      NUMBER(9);
    ln_OTROS_S      NUMBER(9);
    ln_OTROS_TA     NUMBER(9);
    ln_OTROS_V_TA   NUMBER(9);
    ln_OTROS_S_TA   NUMBER(9);
    ln_AQPB549BTPAV NUMBER(9, 2);
    ln_AQPB549BTPAR NUMBER(9);
  
    ln_QTYRAFE     NUMBER(9);
    ln_QTYRAFU     NUMBER(9);
    ln_TPAR        NUMBER(9);
    ln_QTYTOT_FE   NUMBER(9);
    ln_QTYTOT_FU   NUMBER(9);
    ln_OTROS_FE_DA NUMBER(9);
    ln_OTROS_FU_DA NUMBER(9);
    ---***
    ln_OTROS_OP    NUMBER(9);
    ln_OTROS_TA_OP NUMBER(9);
    ln_OTROS_FE_OP NUMBER(9);
    ln_OTROS_FU_OP NUMBER(9);
    ln_OTROST_FE   NUMBER(9);
    ln_OTROST_FU   NUMBER(9);
    ---*********
    ln_OTROS_RECQTY NUMBER(9); -- (OTROS) Cantidad de Reclamos Recibidos en el Periodo
    ln_OTROS_DABSUM NUMBER(9); -- (OTROS) SUMA de los Dias de Absolucion
    ln_OTROS_TPAV   NUMBER(9, 2); -- (OTROS) Tiempo Promedio de Atencion (2 Decimales)
    ln_OTROS_TPAR   NUMBER(9); -- (OTROS) Tiempo Promedio de Atencion (Redondeado)
    ---***
  BEGIN
    ---***
    P_ERRCOD     := '000';
    P_ERRMSG     := '';
    ln_TOP10_OPS := 0;
    ln_TOP4_MOT  := 0;
    ln_OPSC_OLD  := 0;
    ---***
    DELETE FROM AQPB549B WHERE AQPB549BCREUSU = P_CREUSR;
    COMMIT;
    ---***
    ln_TOP10_OPS := 0;
    ln_TOP4_MOT  := 0;
    ---***
    FOR XROW IN (SELECT *
                   FROM AQPB549A
                  WHERE AQPB549ACREUSU = P_CREUSR
                  ORDER BY AQPB549AOPSQ DESC,
                           AQPB549AOPSC,
                           AQPB549AQTYL DESC) LOOP
    
      ---*** VERIFICAR SI HAY 3 DEL MISMO OPS DEBEMOS INSERTAR 'OTROS' y SALTAR AL SIGUIENTE
      ---*** SALTAR AL SIGUIENTE ->>> FLAG IGNORAR HASTA PASAR A OTRA OPS
      IF (XROW.AQPB549AOPSC <> ln_OPSC_OLD) THEN
        ln_TOP10_OPS   := ln_TOP10_OPS + 1;
        ln_TOP4_MOT    := 0;
        ln_OTROS_FE    := 0;
        ln_OTROS_V_FE  := 0;
        ln_OTROS_S_FE  := 0;
        ln_OTROS_FU    := 0;
        ln_OTROS_V_FU  := 0;
        ln_OTROS_S_FU  := 0;
        ln_OTROS       := 0;
        ln_OTROS_V     := 0;
        ln_OTROS_S     := 0;
        ln_OTROS_TA    := 0;
        ln_OTROS_V_TA  := 0;
        ln_OTROS_S_TA  := 0;
        ln_OTROS_TPAV  := 0;
        ln_OTROS_TPAR  := 0;
        ln_OTROS_FE_DA := 0;
        ln_OTROS_FU_DA := 0;
        ---***
        EXIT WHEN(ln_TOP10_OPS = 11);
        ---***
      END IF;
    
      IF (XROW.AQPB549AOPSC = ln_OPSC_OLD) THEN
        ln_TOP4_MOT := ln_TOP4_MOT + 1;
      END IF;
      ---***
      IF (ln_TOP4_MOT < 3) THEN
        INSERT INTO AQPB549B
          (AQPB549BCREUSU,
           AQPB549BCRETIM,
           AQPB549BROWN,
           AQPB549BOPST,
           AQPB549BOPSC,
           AQPB549BOPSD,
           AQPB549BOPSQ,
           AQPB549BMOTC,
           AQPB549BMOTD,
           AQPB549BMOTQ,
           AQPB549BSMOC,
           AQPB549BSMOD,
           AQPB549BQTYL,
           AQPB549BTABL,
           AQPB549BRAFE,
           AQPB549BRAFU,
           AQPB549BTPAV,
           AQPB549BTPAR)
        VALUES
          (P_CREUSR,
           SYSDATE,
           ln_TOP10_OPS,
           XROW.AQPB549AOPST,
           XROW.AQPB549AOPSC,
           XROW.AQPB549AOPSD,
           XROW.AQPB549AOPSQ,
           XROW.AQPB549AMOTC,
           XROW.AQPB549AMOTD,
           XROW.AQPB549AMOTQ,
           XROW.AQPB549ASMOC,
           XROW.AQPB549ASMOD,
           XROW.AQPB549AQTYL,
           XROW.AQPB549ATABL,
           XROW.AQPB549ARAFE,
           XROW.AQPB549ARAFU,
           XROW.AQPB549ATPAV,
           XROW.AQPB549ATPAR);
      ELSE
        -- INSERTAR 'OTROS' MOTIVO
        ---***
        SELECT COALESCE(SUM(AQPB549BQTYL), 0),
               COALESCE(SUM(AQPB549BTABL), 0),
               COALESCE(SUM(AQPB549BRAFE), 0),
               COALESCE(SUM(AQPB549BRAFU), 0)
          INTO ln_OTROS_OP, ln_OTROS_TA_OP, ln_OTROS_FE_OP, ln_OTROS_FU_OP
          FROM AQPB549B
         WHERE AQPB549BCREUSU = P_CREUSR
           AND AQPB549BOPSC = XROW.AQPB549AOPSC;
        ---***
        SELECT COUNT(*), SUM(JAQL420DABSOL)
          INTO ln_OTROST_FE, ln_OTROS_FE_DA
          FROM JAQL420 j
         WHERE j.JAQL420TRC = 1
           AND j.JAQL420EMP = 1
           AND j.JAQL420ESR = 3
           AND j.JAQL420OPS <> ' '
           AND j.JAQL420FCR <= P_FECFIN
           AND j.JAQL420TIPSBS IN ('V', 'S')
           AND j.JAQL420FCCCLI BETWEEN P_FECINI AND P_FECFIN
           AND JAQL420OPS = XROW.AQPB549AOPSC
           AND JAQL420FLD = 'C'
           AND JAQL420COD NOT IN
               (SELECT AQPB545BCOD FROM AQPB545B WHERE AQPB545BRTIP = 'REI');
      
        SELECT COUNT(*), SUM(JAQL420DABSOL)
          INTO ln_OTROST_FU, ln_OTROS_FU_DA
          FROM JAQL420 j
         WHERE j.JAQL420TRC = 1
           AND j.JAQL420EMP = 1
           AND j.JAQL420ESR = 3
           AND j.JAQL420OPS <> ' '
           AND j.JAQL420FCR <= P_FECFIN
           AND j.JAQL420TIPSBS IN ('V', 'S')
           AND j.JAQL420FCCCLI BETWEEN P_FECINI AND P_FECFIN
           AND JAQL420OPS = XROW.AQPB549AOPSC
           AND JAQL420FLD = 'U'
           AND JAQL420COD NOT IN
               (SELECT AQPB545BCOD FROM AQPB545B WHERE AQPB545BRTIP = 'REI');
        ---*********
        ln_OTROS := ABS((ln_OTROST_FE + ln_OTROST_FU) -
                        (ln_OTROS_FE_OP + ln_OTROS_FU_OP));
      
        ln_OTROS_FE := ABS(ln_OTROST_FE - ln_OTROS_FE_OP);
        ln_OTROS_FU := ABS(ln_OTROST_FU - ln_OTROS_FU_OP);
      
        ---*********
        IF (ln_OTROS >= 0) THEN
          ---***
          ln_OTROS_TA   := ln_OTROS_FE_DA + ln_OTROS_FU_DA;
          ln_OTROS_TPAV := ln_OTROS_TA / (ln_OTROST_FE + ln_OTROST_FU);
          ln_OTROS_TPAR := ROUND(ln_OTROS_TPAV);
          ---***
          BEGIN
            INSERT INTO AQPB549B
              (AQPB549BCREUSU,
               AQPB549BCRETIM,
               AQPB549BROWN,
               AQPB549BOPST,
               AQPB549BOPSC,
               AQPB549BOPSD,
               AQPB549BOPSQ,
               AQPB549BMOTC,
               AQPB549BMOTD,
               AQPB549BMOTQ,
               AQPB549BSMOC,
               AQPB549BSMOD,
               AQPB549BQTYL,
               AQPB549BTABL,
               AQPB549BRAFE,
               AQPB549BRAFU,
               AQPB549BTPAV,
               AQPB549BTPAR)
            VALUES
              (P_CREUSR,
               SYSDATE,
               ln_TOP10_OPS,
               XROW.AQPB549AOPST,
               XROW.AQPB549AOPSC,
               XROW.AQPB549AOPSD,
               XROW.AQPB549AOPSQ,
               0,
               'OTROS',
               0,
               0,
               '-',
               0,
               0,
               ln_OTROS_FE,
               ln_OTROS_FU,
               ln_OTROS_TPAV,
               ln_OTROS_TPAR);
          EXCEPTION
            WHEN OTHERS THEN
              ---***
              CONTINUE;
              ---***
          END;
        
        END IF;
        ---*********
      END IF;
      ---***
      ln_OPSC_OLD := XROW.AQPB549AOPSC;
      ---***
    END LOOP;
    ---*** AGREGAR OPS 'OTROS'
    ---***
    ln_TOP4_MOT := 0;
    ---***
    FOR OROW IN (SELECT a.AQPB549AMOTC,
                        a.AQPB549AMOTD,
                        a.AQPB549ASMOC,
                        a.AQPB549ASMOD,
                        COALESCE(SUM(a.AQPB549AQTYL), 0) AS QTY,
                        COALESCE(SUM(a.AQPB549ATABL), 0) AS TABL,
                        COALESCE(SUM(a.AQPB549ARAFE), 0) AS RAFE,
                        COALESCE(SUM(a.AQPB549ARAFU), 0) AS RAFU
                   FROM AQPB549A a
                  WHERE a.AQPB549AOPSC NOT IN
                        (SELECT AQPB549BOPSC
                           FROM AQPB549B
                          WHERE AQPB549BCREUSU = P_CREUSR)
                  GROUP BY a.AQPB549AMOTC,
                           a.AQPB549AMOTD,
                           a.AQPB549ASMOC,
                           a.AQPB549ASMOD
                  ORDER BY QTY DESC) LOOP
    
      ---*********
      IF (OROW.QTY > 0) THEN
        ---***
        ln_TOP4_MOT     := ln_TOP4_MOT + 1;
        ln_AQPB549BTPAV := OROW.TABL / OROW.QTY;
        ln_AQPB549BTPAR := ROUND(OROW.TABL / OROW.QTY);
        ---***
        INSERT INTO AQPB549B
          (AQPB549BCREUSU,
           AQPB549BCRETIM,
           AQPB549BROWN,
           AQPB549BOPST,
           AQPB549BOPSC,
           AQPB549BOPSD,
           AQPB549BOPSQ,
           AQPB549BMOTC,
           AQPB549BMOTD,
           AQPB549BMOTQ,
           AQPB549BSMOC,
           AQPB549BSMOD,
           AQPB549BQTYL,
           AQPB549BTABL,
           AQPB549BRAFE,
           AQPB549BRAFU,
           AQPB549BTPAV,
           AQPB549BTPAR)
        VALUES
          (P_CREUSR,
           SYSDATE,
           11,
           'O',
           0,
           'OTROS',
           OROW.QTY,
           OROW.AQPB549AMOTC,
           OROW.AQPB549AMOTD,
           OROW.QTY,
           OROW.AQPB549ASMOC,
           OROW.AQPB549ASMOD,
           OROW.QTY,
           OROW.TABL,
           OROW.RAFE,
           OROW.RAFU,
           ln_AQPB549BTPAV,
           ln_AQPB549BTPAR);
      END IF;
      ---*********
      ---***
      EXIT WHEN(ln_TOP4_MOT = 3);
      ---***
    END LOOP;
    ---***
    ---*** INSERTAR OPS: Otros, MOT: Otros
    /*
    SELECT COALESCE(SUM(AQPB549AQTYL), 0),
           COALESCE(SUM(AQPB549ATABL), 0),
           COALESCE(SUM(AQPB549ARAFE), 0),
           COALESCE(SUM(AQPB549ARAFU), 0)
      INTO ln_OTROS, ln_OTROS_TA, ln_OTROS_FE, ln_OTROS_FU
      FROM AQPB549A
     WHERE AQPB549ACREUSU = P_CREUSR
       AND AQPB549AOPSC NOT IN
           (SELECT AQPB549BOPSC
              FROM AQPB549B
             WHERE AQPB549BCREUSU = P_CREUSR)
       AND AQPB549AMOTC NOT IN
           (SELECT AQPB549BMOTC
              FROM AQPB549B
             WHERE AQPB549BCREUSU = P_CREUSR
               AND AQPB549BOPSC = 0);
    */
    ---*********
    ---***IF (ln_OTROS > 0) THEN
    /*
    SELECT SUM(AQPB549BRAFE), SUM(AQPB549BTPAR)
      INTO ln_QTYRAFE, ln_TPAR
      FROM AQPB549B
     WHERE AQPB549BCREUSU = P_CREUSR;
    
    SELECT SUM(AQPB549BRAFU)
      INTO ln_QTYRAFU
      FROM AQPB549B
     WHERE AQPB549BCREUSU = P_CREUSR;
    
    SELECT COUNT(*)
      INTO ln_QTYTOT_FE
      FROM JAQL420
     WHERE JAQL420TRC = 1
       AND JAQL420EMP = 1
       AND JAQL420OPS <> ' '
       AND JAQL420FCR <= P_FECFIN
       AND JAQL420FCCCLI BETWEEN P_FECINI AND P_FECFIN
       AND JAQL420ESR = 3
       AND JAQL420COD NOT IN
           (SELECT AQPB545BCOD FROM AQPB545B WHERE AQPB545BRTIP = 'REI')
       AND JAQL420FLD = 'C';
    
    SELECT COUNT(*)
      INTO ln_QTYTOT_FU
      FROM JAQL420
     WHERE JAQL420TRC = 1
       AND JAQL420EMP = 1
       AND JAQL420OPS <> ' '
       AND JAQL420FCR <= P_FECFIN
       AND JAQL420FCCCLI BETWEEN P_FECINI AND P_FECFIN
       AND JAQL420ESR = 3
       AND JAQL420COD NOT IN
           (SELECT AQPB545BCOD FROM AQPB545B WHERE AQPB545BRTIP = 'REI')
       AND JAQL420FLD = 'U';
    */
    /*
    SELECT COUNT(*)
      INTO ln_OTROS
      FROM JAQL420
     WHERE JAQL420TRC = 1
       AND JAQL420EMP = 1
       AND JAQL420OPS <> ' '
       AND JAQL420FCR <= P_FECFIN
       AND JAQL420FCCCLI BETWEEN P_FECINI AND P_FECFIN
       AND JAQL420ESR = 3
       AND JAQL420COD NOT IN
           (SELECT AQPB545BCOD FROM AQPB545B WHERE AQPB545BRTIP = 'REI')
       AND JAQL420OPS NOT IN (SELECT AQPB549BOPSC FROM AQPB549B)
       AND JAQL420MOT NOT IN
           (SELECT b.AQPB549BMOTC
              FROM AQPB549B b
             WHERE AQPB549BCREUSU = P_CREUSR);
    SELECT COUNT(*)
      INTO ln_QTYTOT_FE
      FROM JAQL420
     WHERE JAQL420TRC = 1
       AND JAQL420EMP = 1
       AND JAQL420OPS <> ' '
       AND JAQL420FCR <= P_FECFIN
       AND JAQL420FCCCLI BETWEEN P_FECINI AND P_FECFIN
       AND JAQL420ESR = 3
       AND JAQL420FLD = 'C'
       AND JAQL420COD NOT IN
           (SELECT AQPB545BCOD FROM AQPB545B WHERE AQPB545BRTIP = 'REI')
       AND JAQL420OPS NOT IN (SELECT AQPB549BOPSC FROM AQPB549B)
       AND JAQL420MOT NOT IN
           (SELECT b.AQPB549BMOTC
              FROM AQPB549B b
             WHERE AQPB549BCREUSU = P_CREUSR);
    
    /*
    ln_OTROS    := (ln_QTYTOT_FE + ln_QTYTOT_FU) -
                   (ln_QTYRAFE + ln_QTYRAFU);
    */
  
    --ln_OTROS_FE := ln_QTYTOT_FE - ln_QTYRAFE;
    --ln_OTROS_FU := ln_QTYTOT_FU - ln_QTYRAFU;
  
    /*
    ln_OTROS_FE := ln_QTYTOT_FE;
    ln_OTROS_FU := ln_OTROS - ln_QTYTOT_FE;
    ---***
    
    SELECT COUNT(*), COALESCE(SUM(JAQL420DABSOL), 0)
      INTO ln_OTROS_RECQTY, ln_OTROS_DABSUM
      FROM JAQL420
     WHERE JAQL420TRC = 1
       AND JAQL420EMP = 1
       AND JAQL420OPS <> ' '
       AND JAQL420FCR <= P_FECFIN
       AND JAQL420FCCCLI BETWEEN P_FECINI AND P_FECFIN
       AND JAQL420ESR = 3
       AND JAQL420COD NOT IN
           (SELECT AQPB545BCOD FROM AQPB545B WHERE AQPB545BRTIP = 'REI')
       AND JAQL420OPS NOT IN (SELECT AQPB549BOPSC FROM AQPB549B)
       AND JAQL420MOT NOT IN
           (SELECT b.AQPB549BMOTC
              FROM AQPB549B b
             WHERE AQPB549BCREUSU = P_CREUSR);
       ---***
       ---***      
    
    --ln_OTROS_TPAV := ln_TPAR / ln_QTYRAFE;
    --ln_OTROS_TPAR := ROUND(ln_OTROS_TPAV);
    ---***
    ln_OTROS_TPAV := 0;
    ln_OTROS_TPAR := 0;
    ---***
    IF (ln_OTROS_RECQTY > 0) THEN
      ---***
      ln_OTROS_TPAV := ln_OTROS_DABSUM / ln_OTROS_RECQTY;
      --ln_OTROS_TPAR := FLOOR(ln_OTROS_TPAV);
      IF (ln_OTROS_TPAV = 0) THEN
        ln_OTROS_TPAV := 1;
      END IF;
      IF (ln_OTROS_TPAR = 0) THEN
        ln_OTROS_TPAR := 1;
      END IF;
      ln_OTROS_TPAR := ROUND(ln_OTROS_TPAV);
    END IF;
    ---***
    ---***
    */
  
    SELECT SUM(AQPB549ARAFE),
           SUM(AQPB549ARAFU),
           SUM(AQPB549ATPAV),
           SUM(AQPB549ATPAR)
      INTO ln_OTROS_FE, ln_OTROS_FU, ln_OTROS_TPAV, ln_OTROS_TPAR
      FROM AQPB549A
     WHERE AQPB549AOPSC NOT IN (SELECT AQPB549BOPSC FROM AQPB549B)
       AND AQPB549AMOTC || AQPB549ASMOC NOT IN
           (SELECT AQPB549BMOTC || AQPB549BSMOC
              FROM AQPB549B
             WHERE AQPB549BOPSC = 0);
  
    ln_OTROS := ln_OTROS_FE + ln_OTROS_FU;
  
    IF (ln_OTROS > 0) THEN
      ln_OTROS_TPAV := ln_OTROS_TPAV / ln_OTROS;
      ln_OTROS_TPAR := ROUND(ln_OTROS_TPAV);
    END IF;
  
    INSERT INTO AQPB549B
      (AQPB549BCREUSU,
       AQPB549BCRETIM,
       AQPB549BROWN,
       AQPB549BOPST,
       AQPB549BOPSC,
       AQPB549BOPSD,
       AQPB549BOPSQ,
       AQPB549BMOTC,
       AQPB549BMOTD,
       AQPB549BMOTQ,
       AQPB549BSMOC,
       AQPB549BSMOD,
       AQPB549BQTYL,
       AQPB549BTABL,
       AQPB549BRAFE,
       AQPB549BRAFU,
       AQPB549BTPAV,
       AQPB549BTPAR)
    VALUES
      (P_CREUSR,
       SYSDATE,
       11,
       'O',
       0,
       'OTROS',
       ln_OTROS,
       0,
       'OTROS',
       0,
       0,
       '-',
       0,
       0,
       ln_OTROS_FE,
       ln_OTROS_FU,
       ln_OTROS_TPAV,
       ln_OTROS_TPAR);
    ---***END IF;
    ---*********
    ---***
    COMMIT;
    ---***
  
  EXCEPTION
    WHEN OTHERS THEN
      ---***
      P_ERRCOD := '001';
      P_ERRMSG := sqlcode || ' ->>> ' || sqlerrm;
      ---***
  END SP_AH_REP_ESTADISTICA_F;

  -- REPORTE DE ESTADISTICA
  PROCEDURE SP_AH_REP_ESTADISTICA(P_CREUSR IN VARCHAR,
                                  P_FECINI IN DATE,
                                  P_FECFIN IN DATE,
                                  P_ERRCOD OUT VARCHAR,
                                  P_ERRMSG OUT VARCHAR) IS
    ---***
    ln_TOP10_OPS  NUMBER(9);
    lv_JAQL421DES VARCHAR(500);
    lv_JAQL422DES VARCHAR(500);
    ln_JAQL422SBS NUMBER(3);
  
    ln_QTY_AUSU     NUMBER(9);
    ln_QTY_AEMP     NUMBER(9);
    ln_AQPB549ATPAV NUMBER(9, 2);
    ln_AQPB549ATPAR NUMBER(9);
    ---***
  
  BEGIN
    ---***
    P_ERRCOD := '000';
    P_ERRMSG := '';
    ---***
    DELETE FROM AQPB549 WHERE AQPB549CREUSU = P_CREUSR;
    DELETE FROM AQPB549A WHERE AQPB549ACREUSU = P_CREUSR;
    COMMIT;
    ---***
    ---*** RECLAMOS 
    FOR XROW IN (SELECT j.JAQL420TIPSBS, j.JAQL420OPS, COUNT(*) AS QTY
                   FROM JAQL420 j
                  WHERE j.JAQL420TRC = 1
                    AND j.JAQL420EMP = 1
                    AND j.JAQL420ESR = 3
                    AND j.JAQL420TIPSBS IN ('V', 'S')
                    AND j.JAQL420OPS <> ' '
                    AND j.JAQL420FCR <= P_FECFIN
                    AND j.JAQL420FCCCLI BETWEEN P_FECINI AND P_FECFIN
                    AND JAQL420COD NOT IN
                        (SELECT AQPB545BCOD
                           FROM AQPB545B
                          WHERE AQPB545BRTIP = 'REI')
                  GROUP BY j.JAQL420TIPSBS, j.JAQL420OPS
                  ORDER BY QTY DESC) LOOP
    
      ---*** BASE (1)
      INSERT INTO AQPB549
        (AQPB549CREUSU,
         AQPB549CRETIM,
         AQPB549TIPSBS,
         AQPB549OPS,
         AQPB549QTY)
      VALUES
        (P_CREUSR, SYSDATE, XROW.JAQL420TIPSBS, XROW.JAQL420OPS, XROW.QTY);
    END LOOP;
    ---***
    COMMIT;
    ---***
    FOR XROW IN (SELECT *
                   FROM AQPB549
                  WHERE AQPB549CREUSU = P_CREUSR
                  ORDER BY AQPB549QTY DESC) LOOP
      ---*** IF (Normal o Banca de Seguros)
      ---*** Si Reclamo Normal: V (INI)
      IF (XROW.AQPB549TIPSBS IN ('V', 'S')) THEN
        SELECT TRIM(JAQL421DES)
          INTO lv_JAQL421DES
          FROM JAQL421
         WHERE JAQL421COD = XROW.AQPB549OPS;
      
        ---*** RECORRIENDO LOS MOTIVOS DE LA OPS EN ORDEN DE FRECUENCIA
        FOR YROW IN (SELECT j.JAQL420TIPSBS,
                            j.JAQL420OPS,
                            j.JAQL420MOT,
                            COUNT(*) AS QTY
                       FROM JAQL420 j
                      WHERE j.JAQL420TRC = 1
                        AND j.JAQL420EMP = 1
                        AND j.JAQL420OPS <> ' '
                        AND j.JAQL420FCR <= P_FECFIN
                        AND j.JAQL420OPS = XROW.AQPB549OPS
                        AND j.JAQL420ESR = 3
                        AND j.JAQL420TIPSBS IN ('V', 'S')
                        AND j.JAQL420FCCCLI BETWEEN P_FECINI AND P_FECFIN
                        AND j.JAQL420COD NOT IN
                            (SELECT AQPB545BCOD
                               FROM AQPB545B
                              WHERE AQPB545BRTIP = 'REI')
                      GROUP BY j.JAQL420TIPSBS, j.JAQL420OPS, j.JAQL420MOT
                      ORDER BY COUNT(*) DESC) LOOP
        
          SELECT JAQL422SBS, JAQL422DES
            INTO ln_JAQL422SBS, lv_JAQL422DES
            FROM JAQL422
           WHERE JAQL422COD = YROW.JAQL420MOT;
          ---***
          ---*** SUBMOTIVOS DE UN MOTIVO
          ---*** Linea sin Submotivo
          --SELECT * FROM AQPB545M
          FOR SROW IN (SELECT COUNT(*) AS QTY_LINE,
                              COALESCE(SUM(j.JAQL420DABSOL), 0) AS TAB_LINE
                         FROM JAQL420 j
                        WHERE j.JAQL420TRC = 1
                          AND j.JAQL420EMP = 1
                          AND j.JAQL420OPS <> ' '
                          AND j.JAQL420FCR <= P_FECFIN
                          AND j.JAQL420OPS = YROW.JAQL420OPS
                          AND j.JAQL420MOT = YROW.JAQL420MOT
                          AND j.JAQL420ESR = 3
                          AND j.JAQL420TIPSBS IN ('V', 'S')
                          AND j.JAQL420FCCCLI BETWEEN P_FECINI AND P_FECFIN
                          AND j.JAQL420COD NOT IN
                              (SELECT AQPB545BCOD
                                 FROM AQPB545B
                                WHERE AQPB545BRTIP = 'REI')
                          AND j.JAQL420COD NOT IN
                              (SELECT AQPB545MRCOD
                                 FROM AQPB545M
                                WHERE AQPB545MREMP = 1)) LOOP
            IF (SROW.QTY_LINE > 0) THEN
              SELECT COUNT(*)
                INTO ln_QTY_AEMP
                FROM JAQL420 j
               WHERE j.JAQL420TRC = 1
                 AND j.JAQL420EMP = 1
                 AND j.JAQL420OPS <> ' '
                 AND j.JAQL420FCR <= P_FECFIN
                 AND j.JAQL420OPS = YROW.JAQL420OPS
                 AND j.JAQL420MOT = YROW.JAQL420MOT
                 AND j.JAQL420ESR = 3
                 AND j.JAQL420TIPSBS IN ('V', 'S')
                 AND j.JAQL420FCCCLI BETWEEN P_FECINI AND P_FECFIN
                 AND j.JAQL420COD NOT IN
                     (SELECT AQPB545BCOD
                        FROM AQPB545B
                       WHERE AQPB545BRTIP = 'REI')
                 AND j.JAQL420COD NOT IN
                     (SELECT AQPB545MRCOD
                        FROM AQPB545M
                       WHERE AQPB545MREMP = 1)
                 AND j.JAQL420FLD = 'C';
              ---***
              ln_QTY_AUSU     := SROW.QTY_LINE - ln_QTY_AEMP;
              ln_AQPB549ATPAV := SROW.TAB_LINE / SROW.QTY_LINE;
              ln_AQPB549ATPAR := ROUND(ln_AQPB549ATPAV);
              ---***
            
              --DBMS_OUTPUT.PUT_LINE('SIN SUBMOTIVOS (INI) *********');
              --DBMS_OUTPUT.PUT_LINE('XROW.AQPB549OPS:= ' || XROW.AQPB549OPS);
              --DBMS_OUTPUT.PUT_LINE('YROW.JAQL420MOT:= ' || YROW.JAQL420MOT);
              --DBMS_OUTPUT.PUT_LINE('SIN SUBMOTIVOS (FIN) *********');
            
              INSERT INTO AQPB549A
                (AQPB549ACREUSU,
                 AQPB549ACRETIM,
                 AQPB549AOPST,
                 AQPB549AOPSC,
                 AQPB549AOPSD,
                 AQPB549AOPSQ,
                 AQPB549AMOTC,
                 AQPB549AMOTD,
                 AQPB549AMOTQ,
                 AQPB549ASMOC,
                 AQPB549ASMOD,
                 AQPB549AQTYL,
                 AQPB549ATABL,
                 AQPB549ARAFE,
                 AQPB549ARAFU,
                 AQPB549ATPAV,
                 AQPB549ATPAR)
              VALUES
                (P_CREUSR,
                 SYSDATE,
                 XROW.AQPB549TIPSBS,
                 XROW.AQPB549OPS,
                 lv_JAQL421DES,
                 XROW.AQPB549QTY,
                 YROW.JAQL420MOT,
                 lv_JAQL422DES,
                 YROW.QTY,
                 0,
                 '-',
                 SROW.QTY_LINE,
                 SROW.TAB_LINE,
                 ln_QTY_AEMP,
                 ln_QTY_AUSU,
                 ln_AQPB549ATPAV,
                 ln_AQPB549ATPAR);
            END IF;
          
          END LOOP;
        
          ---*** Linea con Submotivo
          FOR SROW IN (SELECT f.AQPB545FCOD,
                              f.AQPB545FNOM,
                              COUNT(*) AS QTY_LINE,
                              COALESCE(SUM(j.JAQL420DABSOL), 0) AS TAB_LINE
                         FROM JAQL420 j
                         JOIN AQPB545M m
                           ON (j.JAQL420EMP = m.AQPB545MREMP AND
                              j.JAQL420COD = m.AQPB545MRCOD)
                         JOIN AQPB545F f
                           ON (m.AQPB545MSCOD = f.AQPB545FCOD)
                        WHERE j.JAQL420TRC = 1
                          AND j.JAQL420EMP = 1
                          AND j.JAQL420OPS <> ' '
                          AND j.JAQL420FCR <= P_FECFIN
                          AND j.JAQL420OPS = YROW.JAQL420OPS
                          AND j.JAQL420MOT = YROW.JAQL420MOT
                          AND j.JAQL420ESR = 3
                          AND j.JAQL420TIPSBS IN ('V', 'S')
                          AND j.JAQL420FCCCLI BETWEEN P_FECINI AND P_FECFIN
                          AND j.JAQL420COD NOT IN
                              (SELECT AQPB545BCOD
                                 FROM AQPB545B
                                WHERE AQPB545BRTIP = 'REI')
                        GROUP BY j.JAQL420OPS,
                                 j.JAQL420MOT,
                                 f.AQPB545FCOD,
                                 f.AQPB545FNOM)
          
           LOOP
            IF (SROW.QTY_LINE > 0) THEN
              SELECT COUNT(*)
                INTO ln_QTY_AEMP
                FROM JAQL420 j
                JOIN AQPB545M m
                  ON (j.JAQL420EMP = m.AQPB545MREMP AND
                     j.JAQL420COD = m.AQPB545MRCOD)
                JOIN AQPB545F f
                  ON (m.AQPB545MSCOD = f.AQPB545FCOD)
               WHERE j.JAQL420TRC = 1
                 AND j.JAQL420EMP = 1
                 AND j.JAQL420OPS <> ' '
                 AND j.JAQL420FCR <= P_FECFIN
                 AND j.JAQL420OPS = YROW.JAQL420OPS
                 AND j.JAQL420MOT = YROW.JAQL420MOT
                 AND m.AQPB545MSCOD = SROW.AQPB545FCOD
                 AND j.JAQL420ESR = 3
                 AND j.JAQL420TIPSBS IN ('V', 'S')
                 AND j.JAQL420FCCCLI BETWEEN P_FECINI AND P_FECFIN
                 AND j.JAQL420COD NOT IN
                     (SELECT AQPB545BCOD
                        FROM AQPB545B
                       WHERE AQPB545BRTIP = 'REI')
                 AND j.JAQL420FLD = 'C';
              ---***
              ln_QTY_AUSU     := SROW.QTY_LINE - ln_QTY_AEMP;
              ln_AQPB549ATPAV := SROW.TAB_LINE / SROW.QTY_LINE;
              ln_AQPB549ATPAR := ROUND(ln_AQPB549ATPAV);
              ---***
            
              --DBMS_OUTPUT.PUT_LINE('SUBMOTIVOS (INI) *********');
              --DBMS_OUTPUT.PUT_LINE('XROW.AQPB549OPS:= ' || XROW.AQPB549OPS);
              --DBMS_OUTPUT.PUT_LINE('YROW.JAQL420MOT:= ' || YROW.JAQL420MOT);
              --DBMS_OUTPUT.PUT_LINE('SROW.AQPB545FCOD:= ' ||SROW.AQPB545FCOD);
              --DBMS_OUTPUT.PUT_LINE('SUBMOTIVOS (FIN) *********');
            
              INSERT INTO AQPB549A
                (AQPB549ACREUSU,
                 AQPB549ACRETIM,
                 AQPB549AOPST,
                 AQPB549AOPSC,
                 AQPB549AOPSD,
                 AQPB549AOPSQ,
                 AQPB549AMOTC,
                 AQPB549AMOTD,
                 AQPB549AMOTQ,
                 AQPB549ASMOC,
                 AQPB549ASMOD,
                 AQPB549AQTYL,
                 AQPB549ATABL,
                 AQPB549ARAFE,
                 AQPB549ARAFU,
                 AQPB549ATPAV,
                 AQPB549ATPAR)
              VALUES
                (P_CREUSR,
                 SYSDATE,
                 XROW.AQPB549TIPSBS,
                 XROW.AQPB549OPS,
                 lv_JAQL421DES,
                 XROW.AQPB549QTY,
                 YROW.JAQL420MOT,
                 lv_JAQL422DES,
                 YROW.QTY,
                 SROW.AQPB545FCOD,
                 SROW.AQPB545FNOM,
                 SROW.QTY_LINE,
                 SROW.TAB_LINE,
                 ln_QTY_AEMP,
                 ln_QTY_AUSU,
                 ln_AQPB549ATPAV,
                 ln_AQPB549ATPAR);
            END IF;
          END LOOP;
        END LOOP;
      END IF;
      ---*** Si Reclamo: V (FIN)
    ---***
    
    END LOOP;
    ---***
    COMMIT;
    ---***
    ---***
  EXCEPTION
    WHEN OTHERS THEN
      ---***
      P_ERRCOD := '001';
      P_ERRMSG := sqlcode || ' ->>> ' || sqlerrm;
      ---***
  END SP_AH_REP_ESTADISTICA;

  --TOTAL RECLAMOS RECIBIDOS EN EL PERIODO
  PROCEDURE SP_AH_REP_ESTADISTICA_TRRP(P_FECINI IN DATE,
                                       P_FECFIN IN DATE,
                                       P_TRRP   OUT NUMBER,
                                       P_ERRCOD OUT VARCHAR,
                                       P_ERRMSG OUT VARCHAR) IS
  
  BEGIN
    ---***
    P_ERRCOD := '000';
    P_ERRMSG := '';
    ---***
    SELECT COUNT(*)
      INTO P_TRRP
      FROM JAQL420
     WHERE JAQL420TRC = 1
       AND JAQL420EMP = 1
       AND JAQL420FCR BETWEEN P_FECINI AND P_FECFIN
       AND JAQL420OPS <> ' '
       AND JAQL420ESR <> 4
       AND JAQL420COD NOT IN
           (SELECT AQPB545BCOD FROM AQPB545B WHERE AQPB545BRTIP = 'REI');
  
  EXCEPTION
    WHEN OTHERS THEN
      ---***
      P_TRRP   := 0;
      P_ERRCOD := '001';
      P_ERRMSG := sqlcode || ' ->>> ' || sqlerrm;
      ---***
  END SP_AH_REP_ESTADISTICA_TRRP;

  --TOTAL RECLAMOS EN TRAMITE
  PROCEDURE SP_AH_REP_ESTADISTICA_TOTTRA(P_FECINI IN DATE,
                                         P_FECFIN IN DATE,
                                         P_TRT    OUT NUMBER,
                                         P_ERRCOD OUT VARCHAR,
                                         P_ERRMSG OUT VARCHAR) IS
  
  BEGIN
    ---***
    P_ERRCOD := '000';
    P_ERRMSG := '';
    ---***
    SELECT COUNT(*)
      INTO P_TRT
      FROM JAQL420
     WHERE JAQL420TRC = 1
       AND JAQL420EMP = 1
       AND JAQL420ESR <> 4
       AND JAQL420OPS <> ' '
       AND JAQL420COD NOT IN
           (SELECT AQPB545BCOD FROM AQPB545B WHERE AQPB545BRTIP = 'REI')
       AND ((JAQL420FCR <= P_FECFIN AND JAQL420ESR IN (1, 2)) OR
           (JAQL420FCR <= P_FECFIN AND JAQL420ESR = 3 AND
           JAQL420FCCCLI > P_FECFIN));
  
  EXCEPTION
    WHEN OTHERS THEN
      ---***
      P_TRT    := 0;
      P_ERRCOD := '001';
      P_ERRMSG := sqlcode || ' ->>> ' || sqlerrm;
      ---***
  END SP_AH_REP_ESTADISTICA_TOTTRA;

  --TOTAL RECLAMOS ATENDIDOS
  PROCEDURE SP_AH_REP_ESTADISTICA_TRA(P_FECINI IN DATE,
                                      P_FECFIN IN DATE,
                                      P_TRA    OUT NUMBER,
                                      P_ERRCOD OUT VARCHAR,
                                      P_ERRMSG OUT VARCHAR) IS
  
  BEGIN
    ---***
    P_ERRCOD := '000';
    P_ERRMSG := '';
    ---***
    SELECT COUNT(*)
      INTO P_TRA
      FROM JAQL420
     WHERE JAQL420TRC = 1
       AND JAQL420EMP = 1
       AND JAQL420FCCCLI BETWEEN P_FECINI AND P_FECFIN
       AND JAQL420ESR = 3
       AND JAQL420OPS <> ' '
       AND JAQL420COD NOT IN
           (SELECT AQPB545BCOD FROM AQPB545B WHERE AQPB545BRTIP = 'REI');
  
  EXCEPTION
    WHEN OTHERS THEN
      ---***
      P_TRA    := 0;
      P_ERRCOD := '001';
      P_ERRMSG := sqlcode || ' ->>> ' || sqlerrm;
      ---***
  END SP_AH_REP_ESTADISTICA_TRA;

  --TIEMPO PROMEDIO DE ATENCIÓN (Sin Seguros) 
  PROCEDURE SP_AH_REP_ESTADISTICA_TPA(P_FECINI IN DATE,
                                      P_FECFIN IN DATE,
                                      P_TPAV   OUT NUMBER,
                                      P_TPAR   OUT NUMBER,
                                      P_ERRCOD OUT VARCHAR,
                                      P_ERRMSG OUT VARCHAR) IS
  
    ln_RECQTY NUMBER(9); -- Cantidad de Reclamos Recibidos en el Periodo
    ln_DABSUM NUMBER(9); -- SUMA de los Dias de Absolucion
    ln_TPAV   NUMBER(9, 2); -- Tiempo Promedio de Atencion (2 Decimales)
    ln_TPAR   NUMBER(9); -- Tiempo Promedio de Atencion (Redondeado)
  
  BEGIN
    ---***
    P_ERRCOD := '000';
    P_ERRMSG := '';
    ---***
    SELECT COUNT(*), COALESCE(SUM(JAQL420DABSOL), 0)
      INTO ln_RECQTY, ln_DABSUM
      FROM JAQL420
     WHERE JAQL420TRC = 1
       AND JAQL420EMP = 1
       AND JAQL420FCCCLI BETWEEN P_FECINI AND P_FECFIN
       AND JAQL420ESR = 3
       AND JAQL420TIPSBS = 'V'
       AND JAQL420OPS <> ' '
       AND JAQL420COD NOT IN
           (SELECT AQPB545BCOD FROM AQPB545B WHERE AQPB545BRTIP = 'REI');
    ---***         
    ---***
    ln_TPAV := ln_DABSUM / ln_RECQTY;
    --ln_TPAR := FLOOR(ln_TPAV);
    --ln_TPAR := ROUND(ln_TPAV);
    ln_TPAR := CEIL(ln_TPAV);
    P_TPAV  := ln_TPAV;
    P_TPAR  := ln_TPAR;
    IF (P_TPAV = 0) THEN
      P_TPAV := 1;
    END IF;
    IF (P_TPAR = 0) THEN
      P_TPAR := 1;
    END IF;
    ---***
  EXCEPTION
    WHEN OTHERS THEN
      ---***
      P_TPAV   := 0;
      P_TPAR   := 0;
      P_ERRCOD := '001';
      P_ERRMSG := sqlcode || ' ->>> ' || sqlerrm;
      ---***
  END SP_AH_REP_ESTADISTICA_TPA;

  PROCEDURE SP_AH_REP_RR3_GENERA_BASE(P_CREUSR IN VARCHAR,
                                      P_FECINI IN DATE,
                                      P_FECFIN IN DATE,
                                      P_ERRCOD OUT VARCHAR,
                                      P_ERRMSG OUT VARCHAR) IS
  
    ---***
    ln_INC        NUMBER(9);
    ln_OPS        NUMBER(9);
    ln_CANAL      NUMBER(9);
    ln_EXISTE     NUMBER(9);
    ln_HCTA       NUMBER(9);
    lc_TIPDOC     CHAR(1);
    ln_PETDOC     NUMBER(2);
    lc_PENDOC     CHAR(12);
    lv_RUCINI     VARCHAR(2);
    ln_AQPB550PNQ NUMBER(9);
    ln_AQPB550PJQ NUMBER(9);
    ln_AQPB550QTY NUMBER(9);
    ln_RUBRO      NUMBER(9);
    lv_RUBRO      VARCHAR(30);
    lv_RUBRO_OPS  VARCHAR(2);
    ---***
    ln_TARJ NUMBER(9);
    ---***
  BEGIN
    ---***
    P_ERRCOD := '000';
    P_ERRMSG := '';
    ---***
    --DELETE FROM AQPB550 WHERE AQPB550CREUSU = P_CREUSR;
    --COMMIT;
    ---***  
    FOR TROW IN (SELECT *
                   FROM FSH015 f15
                  WHERE f15.PGCOD = 1
                    AND f15.HFCON BETWEEN P_FECINI AND P_FECFIN
                 --AND f15.HSUCOR IN (2,11,904) 
                 --AND f15.HCMOD IN (18,50,10)
                 --AND f15.HTRAN IN (25,30,501,406)
                 ) LOOP
      ---***
      ln_OPS   := 0;
      ln_CANAL := 0;
      ---***
      ---*** SI NO HAY MAPEO ->> VALORES x DEFECTO
      ---*** SI NO HAY MAPEO ->> IGNORAMOS la TRX
      BEGIN
        SELECT TP1NRO3, TP1IMP1, TP1IMP2
          INTO ln_CANAL, ln_OPS, ln_INC
          FROM FST198
         WHERE TP1COD = 1
           AND TP1COD1 = 11146
           AND TP1CORR1 = 1
           AND TP1CORR2 = 65
           AND TP1NRO1 = TROW.HCMOD
           AND TP1NRO2 = TROW.HTRAN;
      EXCEPTION
        WHEN OTHERS THEN
          ln_CANAL := 1;
          ln_OPS   := 1;
          ln_INC   := 0;
      END;
    
      ---*** NO CONSIDERAR ESTAS TRX
      IF (ln_INC = 0) THEN
        CONTINUE;
      END IF;
      ---***
    
      ---*** SI ln_OPS == 0, DEBEMOS IR AL ASIENTO CON LOS ORDINALES DE OTRA GUIA, PARA DEFINIR QUE OPS ES
      IF (ln_OPS = 0 AND ln_INC = 1) THEN
        ---*** VALOR x DEFECTO
        ln_OPS := 104;
        ---***
        IF (TROW.HCMOD = 50 AND TROW.HTRAN = 501) THEN
          SELECT COUNT(*)
            INTO ln_TARJ
            FROM FSX016
           WHERE PGCOD = TROW.PGCOD
             AND HFCON = TROW.HFCON
             AND HSUCOR = TROW.HSUCOR
             AND HCMOD = TROW.HCMOD
             AND HTRAN = TROW.HTRAN
             AND HNREL = TROW.HNREL
             AND HCORD = 0;
          ---***
          IF (ln_TARJ = 0) THEN
            ln_OPS := 1;
          ELSE
            ln_OPS := 6;
          END IF;
          ---***
        END IF;
      
        IF (TROW.HCMOD = 10 AND TROW.HTRAN = 406) THEN
          --DBMS_OUTPUT.PUT_LINE('10/406 (INI)... ');
          BEGIN
            SELECT HRUBRO
              INTO ln_RUBRO
              FROM FSH016
             WHERE PGCOD = TROW.PGCOD
               AND HCMOD = TROW.HCMOD
               AND HSUCOR = TROW.HSUCOR
               AND HTRAN = TROW.HTRAN
               AND HNREL = TROW.HNREL
               AND HFCON = TROW.HFCON
               AND HCORD = 10;
          EXCEPTION
            WHEN OTHERS THEN
              ln_RUBRO := 0;
              ln_OPS   := 97;
          END;
          IF (ln_RUBRO <> 0) THEN
            lv_RUBRO     := TRIM(TO_CHAR(ln_RUBRO));
            lv_RUBRO_OPS := SUBSTR(lv_RUBRO, 5, 2);
            --DBMS_OUTPUT.PUT_LINE('lv_RUBRO:= ' || lv_RUBRO);
            --DBMS_OUTPUT.PUT_LINE('lv_RUBRO_OPS:= ' || lv_RUBRO_OPS);
          
            IF (lv_RUBRO_OPS = '02') THEN
              ln_OPS := 97;
            ELSE
              ln_OPS := 9;
            END IF;
          END IF;
          --DBMS_OUTPUT.PUT_LINE('10/406 (FIN)... ');
          --DBMS_OUTPUT.PUT_LINE('ln_OPS:= ' || ln_OPS);
        END IF;
      END IF;
    
      SELECT COUNT(*)
        INTO ln_EXISTE
        FROM AQPB550
       WHERE AQPB550CREUSU = P_CREUSR
         AND AQPB550OPS = ln_OPS
         AND AQPB550CAN = ln_CANAL;
    
      IF (ln_EXISTE = 1) THEN
        ---*** YA EXISTE, SOLO QUEDA DEFINIR SI ES PERSONA NATURAL o JURIDICA y AGREGAR ESE VALOR
        -- UPDATE
        ---***
        --DBMS_OUTPUT.PUT_LINE('YA EXISTE UPDATE ...');
        --***
        ln_AQPB550PNQ := 0;
        ln_AQPB550PJQ := 0;
        ln_AQPB550QTY := 0;
      
        --SELECT * FROM FSH016
        BEGIN
          SELECT HCTA
            INTO ln_HCTA
            FROM FSH016
           WHERE PGCOD = TROW.PGCOD
             AND HCMOD = TROW.HCMOD
             AND HSUCOR = TROW.HSUCOR
             AND HTRAN = TROW.HTRAN
             AND HNREL = TROW.HNREL
             AND HFCON = TROW.HFCON
             AND HCORD = 10
             AND ROWNUM = 1;
        EXCEPTION
          WHEN OTHERS THEN
            ln_HCTA := 0;
        END;
        ---***
        --SELECT * FROM FSR008
        IF (ln_HCTA > 0) THEN
          BEGIN
            SELECT PETDOC, PENDOC
              INTO ln_PETDOC, lc_PENDOC
              FROM FSR008
             WHERE PGCOD = 1
               AND CTNRO = ln_HCTA
               AND CTTFIR = 'T'
               AND ROWNUM = 1;
          EXCEPTION
            WHEN OTHERS THEN
              ln_PETDOC := 0;
              lc_TIPDOC := 'F';
          END;
        ELSE
          ln_PETDOC := 0;
          lc_TIPDOC := 'F';
        END IF;
        ---***
        ---***
        IF (ln_PETDOC <> 0) THEN
          SELECT TDTVAL
            INTO lc_TIPDOC
            FROM FST014
           WHERE TDOCUM = ln_PETDOC;
        END IF;
        ---***
        IF (lc_TIPDOC = 'F') THEN
          ln_AQPB550PNQ := 1;
          ln_AQPB550PJQ := 0;
        END IF;
        IF (lc_TIPDOC = 'J') THEN
          ln_AQPB550PNQ := 0;
          ln_AQPB550PJQ := 1;
        END IF;
        IF (lc_TIPDOC = 'A') THEN
          lv_RUCINI := SUBSTR(TRIM(lc_PENDOC), 1, 2);
          IF (ln_PETDOC = 9 AND lv_RUCINI = '20') THEN
            ln_AQPB550PNQ := 0;
            ln_AQPB550PJQ := 1;
          ELSE
            ln_AQPB550PNQ := 1;
            ln_AQPB550PJQ := 0;
          END IF;
        END IF;
        ---***
        ln_AQPB550QTY := 1;
        ---***
        UPDATE AQPB550
           SET AQPB550PNQ = AQPB550PNQ + ln_AQPB550PNQ,
               AQPB550PJQ = AQPB550PJQ + ln_AQPB550PJQ,
               AQPB550QTY = AQPB550QTY + ln_AQPB550QTY
         WHERE AQPB550CREUSU = P_CREUSR
           AND AQPB550OPS = ln_OPS
           AND AQPB550CAN = ln_CANAL;
        ---***
      ELSE
        ---*** NO EXISTE, INSERTAR CON LOS CALCULOS INICIALES
        ---***
        --DBMS_OUTPUT.PUT_LINE('NEWPI INSERT ...');
        --***
        ln_AQPB550PNQ := 0;
        ln_AQPB550PJQ := 0;
        ln_AQPB550QTY := 0;
        --SELECT * FROM FSH016
        BEGIN
          SELECT HCTA
            INTO ln_HCTA
            FROM FSH016
           WHERE PGCOD = TROW.PGCOD
             AND HCMOD = TROW.HCMOD
             AND HSUCOR = TROW.HSUCOR
             AND HTRAN = TROW.HTRAN
             AND HNREL = TROW.HNREL
             AND HFCON = TROW.HFCON
             AND HCORD = 10
             AND ROWNUM = 1;
        EXCEPTION
          WHEN OTHERS THEN
            ln_HCTA := 0;
        END;
        ---***
        --SELECT * FROM FSR008
        IF (ln_HCTA > 0) THEN
          BEGIN
            SELECT PETDOC, PENDOC
              INTO ln_PETDOC, lc_PENDOC
              FROM FSR008
             WHERE PGCOD = 1
               AND CTNRO = ln_HCTA
               AND CTTFIR = 'T'
               AND ROWNUM = 1;
          EXCEPTION
            WHEN OTHERS THEN
              ln_PETDOC := 0;
              lc_TIPDOC := 'F';
          END;
        ELSE
          ln_PETDOC := 0;
          lc_TIPDOC := 'F';
        END IF;
        ---***
        IF (ln_PETDOC <> 0) THEN
          SELECT TDTVAL
            INTO lc_TIPDOC
            FROM FST014
           WHERE TDOCUM = ln_PETDOC;
        END IF;
        ---***
        IF (lc_TIPDOC = 'F') THEN
          ln_AQPB550PNQ := 1;
          ln_AQPB550PJQ := 0;
        END IF;
        IF (lc_TIPDOC = 'J') THEN
          ln_AQPB550PNQ := 0;
          ln_AQPB550PJQ := 1;
        END IF;
        IF (lc_TIPDOC = 'A') THEN
          lv_RUCINI := SUBSTR(TRIM(lc_PENDOC), 1, 2);
          ---***
          ----DBMS_OUTPUT.PUT_LINE('lv_RUCINI:= ' || lv_RUCINI);
          ---***
          IF (ln_PETDOC = 9 AND lv_RUCINI = '20') THEN
            ln_AQPB550PNQ := 0;
            ln_AQPB550PJQ := 1;
          ELSE
            ln_AQPB550PNQ := 1;
            ln_AQPB550PJQ := 0;
          END IF;
        END IF;
        ln_AQPB550QTY := 1;
        ---***
        INSERT INTO AQPB550
          (AQPB550CREUSU,
           AQPB550CRETIM,
           AQPB550OPS,
           AQPB550CAN,
           AQPB550PNQ,
           AQPB550PJQ,
           AQPB550QTY)
        VALUES
          (P_CREUSR,
           SYSDATE,
           ln_OPS,
           ln_CANAL,
           ln_AQPB550PNQ,
           ln_AQPB550PJQ,
           ln_AQPB550QTY);
        ---***
      END IF;
    
    ---***
    --DBMS_OUTPUT.PUT_LINE('ln_OPS:= ' || ln_OPS);
    --DBMS_OUTPUT.PUT_LINE('ln_CANAL:= ' || ln_CANAL);
    --DBMS_OUTPUT.PUT_LINE('ln_AQPB550PNQ:= ' || ln_AQPB550PNQ);
    --DBMS_OUTPUT.PUT_LINE('ln_AQPB550PJQ:= ' || ln_AQPB550PJQ);
    --DBMS_OUTPUT.PUT_LINE('ln_AQPB550QTY:= ' || ln_AQPB550QTY);
    ---***
    
    END LOOP;
    ---***
    COMMIT;
    ---***
  EXCEPTION
    WHEN OTHERS THEN
      ---***
      P_ERRCOD := '001';
      P_ERRMSG := sqlcode || ' ->>> ' || sqlerrm;
      ---***
  END SP_AH_REP_RR3_GENERA_BASE;

  PROCEDURE SP_AH_REP_RR2_GENERA_REP(P_CREUSR IN VARCHAR,
                                     P_FECINI IN DATE,
                                     P_FECFIN IN DATE,
                                     P_ERRCOD OUT VARCHAR,
                                     P_ERRMSG OUT VARCHAR) IS
  
    ---***
    ln_SEQ    NUMBER(9);
    ln_CAN    NUMBER(3);
    lv_OPS    VARCHAR(10);
    ln_MOT    NUMBER(3);
    lv_OPSESP VARCHAR(150);
    lv_MOTESP VARCHAR(150);
    ln_SEQ2   NUMBER(9);
    ---***                                      
  
  BEGIN
    ---***
    P_ERRCOD := '000';
    P_ERRMSG := NULL;
    ln_SEQ   := 0;
    ln_SEQ2  := 0;
    ---***
    DELETE FROM AQPD306 WHERE AQPD306CREUSR = P_CREUSR;
    DELETE FROM AQPD306A WHERE AQPD306ACREUSR = P_CREUSR;
    COMMIT;
    ---***
    --RECLAMOS RECIBIDOS EN EL PERIODO
    --RECLAMOS RESPONDIDOS EN EL PERIODO
    --RECLAMOS QUE ESTABAN EN TRAMITE EN EL PERIODO
    --RECLAMOS QUE AUN ESTAN EN TRAMITE DE ANTES DEL PERIODO
    FOR XREC IN (SELECT *
                   FROM JAQL420
                  WHERE JAQL420TRC = 1
                    AND JAQL420ESR IN (1, 2, 3)
                    AND (JAQL420OPS = '237' OR JAQL420MOT = 261)
                    AND (JAQL420FCR BETWEEN P_FECINI AND P_FECFIN))
    
     LOOP
    
      ---***
      ln_SEQ := ln_SEQ + 1;
      ---*** CAN
      BEGIN
        SELECT JAQL422CSBS
          INTO ln_CAN
          FROM JAQL422C
         WHERE JAQL422CCOD = XREC.JAQL420CAN;
      exception
        when others then
          ln_CAN := 0;
      END;
      ---*** OPS
      BEGIN
        SELECT JAQL421SBS
          INTO lv_OPS
          FROM JAQL421
         WHERE JAQL421COD = XREC.JAQL420OPS;
      exception
        when others then
          lv_OPS := '0';
      END;
    
      IF (lv_OPS = '999' AND XREC.JAQL420OPSESP IS NULL) THEN
        lv_OPSESP := 'OPS CAQP';
      ELSE
        lv_OPSESP := XREC.JAQL420OPSESP;
      END IF;
      ---***
      ---*** MOT
      BEGIN
        SELECT JAQL422SBS
          INTO ln_MOT
          FROM JAQL422
         WHERE JAQL422COD = XREC.JAQL420MOT;
      exception
        when others then
          ln_MOT := 0;
      END;
    
      IF (ln_MOT = 999 AND XREC.JAQL420MOTESP IS NULL) THEN
        lv_MOTESP := 'MOT CAQP';
      ELSE
        lv_MOTESP := XREC.JAQL420MOTESP;
      END IF;
      ---***
      INSERT INTO AQPD306
        (AQPD306CREUSR,
         AQPD306CRESEQ,
         AQPD306CRETIM,
         AQPD306FECINI,
         AQPD306FECFIN,
         AQPD306RECCOD,
         AQPD306CANOPE,
         AQPD306OPSTIP,
         AQPD306OPSOTR,
         AQPD306MOTTIP,
         AQPD306MOTOTR)
      VALUES
        (P_CREUSR,
         ln_SEQ,
         SYSDATE,
         P_FECINI,
         P_FECFIN,
         XREC.JAQL420COD,
         ln_CAN,
         lv_OPS,
         lv_OPSESP,
         ln_MOT,
         lv_MOTESP);
    END LOOP;
    ---***
    COMMIT;
    ---***
    FOR XROW IN (SELECT AQPD306CANOPE,
                        AQPD306OPSTIP,
                        AQPD306OPSOTR,
                        AQPD306MOTTIP,
                        AQPD306MOTOTR,
                        COUNT(*) AS CANTIDAD
                   FROM AQPD306
                  WHERE AQPD306CREUSR = P_CREUSR
                  GROUP BY AQPD306CANOPE,
                           AQPD306OPSTIP,
                           AQPD306OPSOTR,
                           AQPD306MOTTIP,
                           AQPD306MOTOTR) LOOP
      ---***
      ln_SEQ2 := ln_SEQ2 + 1;
      ---***
      INSERT INTO AQPD306A
        (AQPD306ACREUSR,
         AQPD306ACRESEQ,
         AQPD306ACRETIM,
         AQPD306AFECINI,
         AQPD306AFECFIN,
         AQPD306ACANOPS,
         AQPD306AOPSTIP,
         AQPD306AOPSOTR,
         AQPD306ACANMOT,
         AQPD306AMOTTIP,
         AQPD306AMOTOTR,
         AQPD306ALINQTY)
      VALUES
        (P_CREUSR,
         ln_SEQ2,
         SYSDATE,
         P_FECINI,
         P_FECFIN,
         XROW.AQPD306CANOPE,
         XROW.AQPD306OPSTIP,
         XROW.AQPD306OPSOTR,
         XROW.AQPD306CANOPE,
         XROW.AQPD306MOTTIP,
         XROW.AQPD306MOTOTR,
         XROW.CANTIDAD);
    END LOOP;
    ---***
    COMMIT;
    ---***
  EXCEPTION
    WHEN OTHERS THEN
      ---***
      P_ERRCOD := '001';
      P_ERRMSG := sqlcode || ' ->>> ' || sqlerrm;
      ROLLBACK;
      ---***
  END SP_AH_REP_RR2_GENERA_REP;

END PQ_AH_RECLAMOS_RR;
/* GOLDENGATE_DDL_REPLICATION */
/
