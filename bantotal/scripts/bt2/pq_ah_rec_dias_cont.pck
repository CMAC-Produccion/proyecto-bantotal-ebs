CREATE OR REPLACE PACKAGE PQ_AH_REC_DIAS_CONT IS
  -- ***************************************************************************************
  -- Nombre                     : PROCEDURES PARA LA NUEVA CONTABILIZACION DE LOS DIAS
  -- Sistema                    : BANTOTAL
  -- Módulo                     : PASIVAS
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2023.02.14
  -- Autor de Creación          : CVILLON
  -- Uso                        : CONTABILIZACION DE LOS DIAS EN RECLAMOS Y REQ DE INFO
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2023.02.14
  -- Fecha de Modificación      : 2023.05.18
  -- Modificado                 : CVILLON
  -- Fecha de Modificación      : 2023.10.26
  -- ***************************************************************************************
  ---***
  PROCEDURE SP_AH_CALC_DIAHABIL(P_D_FECPRO IN DATE,
                                P_N_NUMDIA IN NUMBER,
                                p_d_diahab out date);
  PROCEDURE SP_AH_GEN_DIAS_ABSOLUCION(P_RECCOD IN VARCHAR,
                                      P_FECHOY IN DATE,
                                      P_DIAS   OUT NUMBER,
                                      P_ERRCOD OUT VARCHAR,
                                      P_ERRMSG OUT VARCHAR);
  PROCEDURE SP_AH_GEN_DIAS_SUSPENSION(P_RECCOD IN VARCHAR,
                                      P_FECHOY IN DATE,
                                      P_DIAS   OUT NUMBER,
                                      P_ERRCOD OUT VARCHAR,
                                      P_ERRMSG OUT VARCHAR);
  PROCEDURE SP_AH_GEN_REC_EXTRA_DATA(P_RECCOD IN VARCHAR,
                                     P_ERRCOD OUT VARCHAR,
                                     P_ERRMSG OUT VARCHAR);
  PROCEDURE SP_AH_GEN_SUSPENDER_REC(P_RECCOD IN VARCHAR,
                                    P_FECHOY IN DATE,
                                    P_USER   IN VARCHAR,
                                    P_ERRCOD OUT VARCHAR,
                                    P_ERRMSG OUT VARCHAR);
  PROCEDURE SP_AH_GEN_REANUDAR_REC(P_RECCOD IN VARCHAR,
                                   P_FECHOY IN DATE,
                                   P_USER   IN VARCHAR,
                                   P_ERRCOD OUT VARCHAR,
                                   P_ERRMSG OUT VARCHAR);
  PROCEDURE SP_AH_EMAIL_RECLAMO_SUSREA(P_FECHOY IN DATE,
                                       P_MODO   IN VARCHAR,
                                       P_ERRCOD OUT VARCHAR,
                                       P_ERRMSG OUT VARCHAR);
  PROCEDURE SP_AH_JOB_RECLAMO_REANUDA(P_FECHOY IN DATE,
                                      P_ERRCOD OUT VARCHAR,
                                      P_ERRMSG OUT VARCHAR);

  PROCEDURE SP_AH_CALC_AMPLIACION(P_D_FECPRO IN DATE,
                                  P_N_NUMDIA IN NUMBER,
                                  P_V_TIPAMP IN VARCHAR,
                                  P_D_NEWDIA OUT DATE);

  PROCEDURE SP_AH_UPD_RECLAMO_AMP(P_V_CODREC IN VARCHAR,
                                  P_D_FECPRO IN DATE,
                                  P_N_NUMDIA IN NUMBER,
                                  P_V_TIPAMP IN VARCHAR,
                                  P_D_NEWDIA OUT DATE,
                                  P_ERRCOD   OUT VARCHAR,
                                  P_ERRMSG   OUT VARCHAR);

---***
END PQ_AH_REC_DIAS_CONT;
/

CREATE OR REPLACE PACKAGE BODY PQ_AH_REC_DIAS_CONT IS
  -- ***************************************************************************************
  -- Nombre                     : PROCEDURES PARA LA NUEVA CONTABILIZACION DE LOS DIAS
  -- Sistema                    : BANTOTAL
  -- Módulo                     : PASIVAS
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2023.02.14
  -- Autor de Creación          : CVILLON
  -- Uso                        : CONTABILIZACION DE LOS DIAS EN RECLAMOS Y REQ DE INFO
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2023.02.14
  -- Fecha de Modificación      : 2023.05.18
  -- Modificado                 : CVILLON
  -- Fecha de Modificación      : 2023.10.26
  -- ***************************************************************************************
  ---***

  PROCEDURE SP_AH_CALC_DIAHABIL(P_D_FECPRO IN DATE,
                                P_N_NUMDIA IN NUMBER,
                                p_d_diahab out date) is
    ln_codcal number(3);
    ln_cont   number(9) := 0;
    cursor c_dias(ln_codcal in number) is
      SELECT f.*
        from FST028 f
       WHERE f.calcod = ln_codcal
         AND f.fhabil = 'S'
         AND f.ffecha > P_D_FECPRO
       ORDER BY FFECHA;
  begin
    ---***
    p_d_diahab := null;
    ln_codcal  := 999;
    ---***
    for i in c_dias(ln_codcal) loop
      ln_cont    := ln_cont + 1;
      p_d_diahab := i.ffecha;
      IF (ln_cont = P_N_NUMDIA) THEN
        RETURN;
        --exit;
      ELSE
        p_d_diahab := null;
      END IF;
    end loop;
  
  EXCEPTION
    when others then
      p_d_diahab := null;
      --P_ERRCOD := '040';
    --P_ERRMSG := sqlcode||'->'||sqlerrm;
  
  END SP_AH_CALC_DIAHABIL;
  ---*********
  ---*********
  PROCEDURE SP_AH_GEN_DIAS_ABSOLUCION(P_RECCOD IN VARCHAR,
                                      P_FECHOY IN DATE,
                                      P_DIAS   OUT NUMBER,
                                      P_ERRCOD OUT VARCHAR,
                                      P_ERRMSG OUT VARCHAR) AS
  
    lv_tipsbs  VARCHAR(1); -- Tipo SBS (Varios o Seguro)
    ld_recfcr  DATE; -- Reclamo FEC Recepcion
    ld_pdiahab DATE; -- Primer dia Habil
    ln_recest  number(3); -- Estado del Reclamo (1,2,3,4)
    ln_dabsol  number(3); -- Dias de Absolucion
    ln_dsuspe  number(3); -- Dias de Suspension
    lv_errcod  VARCHAR(3); -- ERRCOD
    lv_errmsg  VARCHAR(160); -- ERRMSG
    ---***
    ld_fcccli DATE; -- Fecha Respuesta Valida para Cliente
    ---***
  
  BEGIN
    BEGIN
      SELECT j.JAQL420TIPSBS, j.JAQL420DIAHAB, j.JAQL420ESR, j.JAQL420FCR
        INTO lv_tipsbs, ld_pdiahab, ln_recest, ld_recfcr
        FROM JAQL420 j
       WHERE j.JAQL420EMP = 1
         AND j.JAQL420COD = P_RECCOD;
    EXCEPTION
      when others then
        P_ERRCOD := '100';
        P_ERRMSG := sqlcode || '->' || sqlerrm;
        RETURN;
    END;
  
    IF (lv_tipsbs = 'V') THEN
      -- NO TIPO SEGUROS -- DIAS HABILES (DESDE 1er DIA HABIL)
      ---***
      SELECT f.ffecha
        INTO ld_fcccli
        FROM FST028 f
       WHERE f.calcod = 999
         AND f.fhabil = 'S'
         AND f.ffecha >= P_FECHOY
         AND ROWNUM = 1
       ORDER BY f.ffecha;
      ---***
      SELECT COUNT(*)
        INTO P_DIAS
        FROM FST028 f
       WHERE f.calcod = 999
         AND f.fhabil = 'S'
         AND f.ffecha BETWEEN ld_pdiahab AND ld_fcccli;
    ELSIF (lv_tipsbs = 'S') THEN
      ---***
      -- ES TIPO SEGUROS -- DIAS CALENDARIO (DESDE 1er DIA HABIL)
      SELECT (P_FECHOY - ld_pdiahab) INTO P_DIAS FROM dual;
      ---***
      P_DIAS := P_DIAS + 1;
      IF (P_DIAS < 0) THEN
        P_DIAS := 0;
      END IF;
    ELSE
      -- Es de los Antiguos, Desde Fecha de Recepcion
      SELECT (P_FECHOY - ld_recfcr) INTO P_DIAS FROM dual;
      P_DIAS := P_DIAS + 1;
      IF (P_DIAS < 0) THEN
        P_DIAS := 0;
      END IF;
    END IF;
    ---***
    ---***
    SP_AH_GEN_DIAS_SUSPENSION(P_RECCOD,
                              P_FECHOY,
                              ln_dsuspe,
                              lv_errcod,
                              lv_errmsg);
    ---***
    P_DIAS := P_DIAS - ln_dsuspe;
    ---***
    --dbms_output.put_line('Dias de Absolución: ' || P_DIAS);
  
  EXCEPTION
    when others then
      P_ERRCOD := '010';
      P_ERRMSG := sqlcode || '->' || sqlerrm;
    
  END SP_AH_GEN_DIAS_ABSOLUCION;
  ---*********
  ---*********
  PROCEDURE SP_AH_GEN_DIAS_SUSPENSION(P_RECCOD IN VARCHAR,
                                      P_FECHOY IN DATE,
                                      P_DIAS   OUT NUMBER,
                                      P_ERRCOD OUT VARCHAR,
                                      P_ERRMSG OUT VARCHAR) AS
  
    lv_tipsbs  VARCHAR(1); -- Tipo SBS (Varios o Seguro)
    ld_pdiahab DATE; -- Primer dia Habil
    ln_recest  number(3); -- Estado del Reclamo (1,2,3,4)
    ln_dsuspen number(3); -- Dias de Absolucion
  
    lv_susest VARCHAR(1); -- Estado de Suspension (I, S, R)
    ld_susfec DATE; -- Fecha de Suspension
    ld_reafec DATE; -- Fecha de Reanudacion
    ln_susdia NUMBER(3); -- Dias Suspendido
  
  BEGIN
  
    P_DIAS := 0;
    BEGIN
      SELECT j.JAQL420TIPSBS,
             j.JAQL420DIAHAB,
             j.JAQL420ESR,
             j.JAQL420SUSEST,
             j.JAQL420SUSFEC,
             j.JAQL420REAFEC,
             j.JAQL420SUSDIA
        INTO lv_tipsbs,
             ld_pdiahab,
             ln_recest,
             lv_susest,
             ld_susfec,
             ld_reafec,
             ln_susdia
        FROM JAQL420 j
       WHERE j.JAQL420EMP = 1
         AND j.JAQL420COD = P_RECCOD;
    EXCEPTION
      when others then
        P_ERRCOD := '101';
        P_ERRMSG := sqlcode || '->' || sqlerrm;
        RETURN;
    END;
    ---***
    IF (lv_susest = 'I') THEN
      P_DIAS := 0;
    END IF;
    ---***
    IF (lv_susest = 'S') THEN
      SELECT COUNT(*)
        INTO P_DIAS
        FROM FST028 f
       WHERE f.calcod = 999
         AND f.fhabil = 'S'
         AND f.ffecha BETWEEN ld_susfec AND P_FECHOY;
      IF (P_DIAS > 0) THEN
        P_DIAS := P_DIAS - 1;
      END IF;
    END IF;
    ---***
    IF (lv_susest = 'R') THEN
      P_DIAS := ln_susdia;
    END IF;
    ---***
    --dbms_output.put_line('Dias de Suspensión: ' || P_DIAS);
  
  EXCEPTION
    when others then
      P_ERRCOD := '020';
      P_ERRMSG := sqlcode || '->' || sqlerrm;
    
  END SP_AH_GEN_DIAS_SUSPENSION;
  ---*********
  ---*********
  PROCEDURE SP_AH_GEN_REC_EXTRA_DATA(P_RECCOD IN VARCHAR,
                                     P_ERRCOD OUT VARCHAR,
                                     P_ERRMSG OUT VARCHAR) AS
    ---***
    lv_nvavig  VARCHAR(10);
    ld_nvavig  DATE;
    ld_fcr     DATE;
    lv_ops     VARCHAR(10);
    ld_pdiahab DATE;
    ld_qdiahab DATE;
    ln_TipRec  NUMBER(3);
    lv_TipRec  VARCHAR(1);
    lv_TipRecR VARCHAR(1);
    ln_recesr  NUMBER(3);
    ln_plzabs  NUMBER(3);
    ln_dabsol  NUMBER(3);
    ld_recfcc  DATE;
    ---***
    ld_fcccli DATE; -- Fecha Respuesta Valida para Cliente
    ---***
  
  BEGIN
    ----dbms_output.put_line('SP_CR_MARCAR_CREDITO');
    --savepoint SP_AH_GEN_REC_EXTRA_DATA;
    P_ERRCOD   := '000';
    P_ERRMSG   := '';
    lv_TipRec  := 'V';
    lv_TipRecR := '';
    ln_plzabs  := 0;
    ln_dabsol  := 0;
    ---***
    ---*** GUIA - SBS FECHA DE VIGENCIA DE LA NVA DISPOSICION
    BEGIN
      SELECT TRIM(TP1DESC)
        INTO lv_nvavig
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11146
         AND TP1CORR1 = 1
         AND TP1CORR2 = 52
         AND TP1CORR3 = 1;
      ld_nvavig := TO_DATE(lv_nvavig, 'yyyy.mm.dd');
    EXCEPTION
      when others then
        ld_nvavig := TO_DATE('2023.02.28', 'yyyy.mm.dd');
    END;
    ---***
    ---*** GUIA SBS - DIAS PARA ABSOLVER/RESOLVER 
    BEGIN
      SELECT TP1NRO1
        INTO ln_plzabs
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11146
         AND TP1CORR1 = 1
         AND TP1CORR2 = 51
         AND TP1CORR3 = 1;
    EXCEPTION
      when others then
        P_ERRCOD := '102';
        P_ERRMSG := sqlcode || '->' || sqlerrm;
        RETURN;
    END;
  
    BEGIN
      SELECT j.JAQL420FCR,
             j.JAQL420OPS,
             j.JAQL420TIPSBS,
             j.JAQL420ESR,
             j.JAQL420DABSOL,
             j.JAQL420FCC
        INTO ld_fcr, lv_ops, lv_TipRecR, ln_recesr, ln_dabsol, ld_recfcc
        FROM JAQL420 j
       WHERE j.JAQL420EMP = 1
         AND j.JAQL420COD = P_RECCOD;
    EXCEPTION
      when others then
        P_ERRCOD := '103';
        P_ERRMSG := sqlcode || '->' || sqlerrm;
        RETURN;
    END;
    ---***
    IF (ld_fcr >= ld_nvavig) THEN
      IF ((lv_TipRecR IS NULL) OR (lv_TipRecR NOT IN ('V', 'S'))) THEN
        -- No Fue Grabado con Anterioridad
        SELECT COUNT(*)
          INTO ln_TipRec
          FROM FST198
         WHERE TP1COD = 1
           AND TP1COD1 = 11146
           AND TP1CORR1 = 1
           AND TP1CORR2 = 50
           AND TP1NRO1 = TO_NUMBER(TRIM(lv_ops), '999');
      
        --dbms_output.put_line('Fecha de Reclamo: ' || ld_fcr);
        --dbms_output.put_line('Tipo de Reclamo: ' || lv_ops);
      
        ---*** CALC 1er DIA HABIL LUEGO DE REGISTRO DE RECLAMO
        SP_AH_CALC_DIAHABIL(ld_fcr, 1, ld_pdiahab);
        --dbms_output.put_line('1er Dia Habil: ' || ld_pdiahab);
        ---***
        ---*** CALC 15 DIAS HABILES (Fecha Resp. Aproximada)
        IF (ln_TipRec > 0) THEN
          -- ES TIPO SEGUROS -- DIAS CALENDARIO (DESDE 1er DIA HABIL)
          lv_TipRec  := 'S';
          ld_qdiahab := ld_pdiahab + (ln_plzabs - 1);
          --dbms_output.put_line('Tipo Seguro, Dias Calendario ...');
        ELSE
          -- NO TIPO SEGUROS -- DIAS HABILES (DESDE 1er DIA HABIL)
          SP_AH_CALC_DIAHABIL(ld_pdiahab, ln_plzabs - 1, ld_qdiahab);
          --dbms_output.put_line('Tipo Normal, Dias Habiles ...');
        END IF;
        --dbms_output.put_line('Fecha Resp APROX: ' || ld_qdiahab);
        ---***
        UPDATE JAQL420
           SET JAQL420TIPSBS = lv_TipRec,
               JAQL420DIAHAB = ld_pdiahab,
               JAQL420FAPROX = ld_qdiahab,
               JAQL420SUSEST = 'I',
               JAQL420SUSDIA = 0
         WHERE JAQL420EMP = 1
           AND JAQL420COD = P_RECCOD;
        ---***
        COMMIT;
        ---***
      ELSE
        ---***
        -- YA fue Gravado Antes, pero puede ser cambiado 
        -- de Tipo por un Error en el Registro Original
        SELECT COUNT(*)
          INTO ln_TipRec
          FROM FST198
         WHERE TP1COD = 1
           AND TP1COD1 = 11146
           AND TP1CORR1 = 1
           AND TP1CORR2 = 50
           AND TP1NRO1 = TO_NUMBER(TRIM(lv_ops), '999');
        ---
        SP_AH_CALC_DIAHABIL(ld_fcr, 1, ld_pdiahab);
        ---
        IF (ln_TipRec > 0) THEN
          -- ES TIPO SEGUROS -- DIAS CALENDARIO (DESDE 1er DIA HABIL)
          lv_TipRec  := 'S';
          ld_qdiahab := ld_pdiahab + (ln_plzabs - 1);
        ELSE
          -- NO TIPO SEGUROS -- DIAS HABILES (DESDE 1er DIA HABIL)
          SP_AH_CALC_DIAHABIL(ld_pdiahab, ln_plzabs - 1, ld_qdiahab);
        END IF;
        ---***
        UPDATE JAQL420
           SET JAQL420TIPSBS = lv_TipRec,
               JAQL420DIAHAB = ld_pdiahab,
               JAQL420FAPROX = ld_qdiahab
         WHERE JAQL420EMP = 1
           AND JAQL420COD = P_RECCOD;
        ---***
        COMMIT;
        ---***
      END IF;
    END IF;
  
    IF (ln_recesr IN (3, 4)) THEN
      -- Estado Respondido o Anulado
      ---***
      SP_AH_GEN_DIAS_ABSOLUCION(P_RECCOD,
                                ld_recfcc,
                                ln_dabsol,
                                P_ERRCOD,
                                P_ERRMSG);
    
      ---***
      SELECT f.ffecha
        INTO ld_fcccli
        FROM FST028 f
       WHERE f.calcod = 999
         AND f.fhabil = 'S'
         AND f.ffecha >= ld_recfcc
         AND ROWNUM = 1
       ORDER BY f.ffecha;
      ---***                          
      IF (lv_TipRec = 'V') THEN
        UPDATE JAQL420
           SET JAQL420DABSOL = ln_dabsol, JAQL420FCCCLI = ld_fcccli
         WHERE JAQL420EMP = 1
           AND JAQL420COD = P_RECCOD;
      ELSIF (lv_TipRec = 'S') THEN
        UPDATE JAQL420
           SET JAQL420DABSOL = ln_dabsol, JAQL420FCCCLI = ld_recfcc
         WHERE JAQL420EMP = 1
           AND JAQL420COD = P_RECCOD;
      END IF;
      ---***
      COMMIT;
      ---***
    ELSE
      ---***
      UPDATE JAQL420
         SET JAQL420DABSOL = 0
       WHERE JAQL420EMP = 1
         AND JAQL420COD = P_RECCOD;
      ---***
      COMMIT;
      ---***
    END IF;
    ---***
  EXCEPTION
    when others then
      P_ERRCOD := '030';
      P_ERRMSG := sqlcode || '->' || sqlerrm;
    
    ---***    
  END SP_AH_GEN_REC_EXTRA_DATA;
  ---*********
  ---*********
  PROCEDURE SP_AH_GEN_SUSPENDER_REC(P_RECCOD IN VARCHAR,
                                    P_FECHOY IN DATE,
                                    P_USER   IN VARCHAR,
                                    P_ERRCOD OUT VARCHAR,
                                    P_ERRMSG OUT VARCHAR) AS
  
    ld_susflm DATE; -- Fecha Limite de Suspension
    ln_recest NUMBER(3); -- Estado del Reclamo
    lv_susest VARCHAR(1); -- Estado de la Suspension
  
  BEGIN
    BEGIN
      SELECT j.JAQL420ESR, j.JAQL420SUSEST
        INTO ln_recest, lv_susest
        FROM JAQL420 j
       WHERE j.JAQL420EMP = 1
         AND j.JAQL420COD = P_RECCOD;
    EXCEPTION
      when others then
        P_ERRCOD := '104';
        P_ERRMSG := sqlcode || '->' || sqlerrm;
        RETURN;
    END;
  
    IF (ln_recest = 2) THEN
      -- Si esta en estado 'En Proceso'
      IF (lv_susest = 'S') THEN
        P_ERRCOD := '001';
        P_ERRMSG := 'Este Reclamo YA se encuentra Suspendido';
        RETURN;
      END IF;
      IF (lv_susest = 'R') THEN
        P_ERRCOD := '002';
        P_ERRMSG := 'Este Reclamo YA fue Suspendido y Reanudado';
        RETURN;
      END IF;
      IF (lv_susest = 'I') THEN
        ---***
        SP_AH_CALC_DIAHABIL(P_FECHOY, 2, ld_susflm);
        ---***
        UPDATE JAQL420
           SET JAQL420SUSEST = 'S',
               JAQL420SUSFEC = P_FECHOY,
               JAQL420SUSFLM = ld_susflm,
               JAQL420SUSDIA = 0,
               JAQL420SUSUSU = P_USER
         WHERE JAQL420EMP = 1
           AND JAQL420COD = P_RECCOD;
        COMMIT;
        ---***
        P_ERRCOD := '000';
        P_ERRMSG := 'Reclamo Suspendido Correctamente.';
        RETURN;
      END IF;
    ELSE
      P_ERRCOD := '003';
      P_ERRMSG := 'Para Suspender, el Reclamo debe ser guardado primero en estado -> En Proceso';
      RETURN;
    END IF;
  
  END SP_AH_GEN_SUSPENDER_REC;
  ---*********
  ---*********
  PROCEDURE SP_AH_GEN_REANUDAR_REC(P_RECCOD IN VARCHAR,
                                   P_FECHOY IN DATE,
                                   P_USER   IN VARCHAR,
                                   P_ERRCOD OUT VARCHAR,
                                   P_ERRMSG OUT VARCHAR) AS
  
    ld_susflm DATE; -- Fecha Limite de Suspension
    ln_recest NUMBER(3); -- Estado del Reclamo
    lv_susest VARCHAR(1); -- Estado de la Suspension
    ld_susfec DATE; -- Fecha de Suspension
    ln_susdia NUMBER(3); --Dias Suspendido
  
  BEGIN
    --***
    ln_susdia := 0;
    --***
    BEGIN
      SELECT j.JAQL420ESR, j.JAQL420SUSEST, j.JAQL420SUSFEC
        INTO ln_recest, lv_susest, ld_susfec
        FROM JAQL420 j
       WHERE j.JAQL420EMP = 1
         AND j.JAQL420COD = P_RECCOD;
    EXCEPTION
      when others then
        P_ERRCOD := '105';
        P_ERRMSG := sqlcode || '->' || sqlerrm;
        RETURN;
    END;
  
    IF (ln_recest = 2) THEN
      -- Si esta en estado 'En Proceso'
      IF (lv_susest = 'I') THEN
        P_ERRCOD := '001';
        P_ERRMSG := 'Este Reclamo NO se encuentra Suspendido';
        RETURN;
      END IF;
      IF (lv_susest = 'R') THEN
        P_ERRCOD := '002';
        P_ERRMSG := 'Este Reclamo YA fue Suspendido y Reanudado';
        RETURN;
      END IF;
      IF (lv_susest = 'S') THEN
        ---***
        SELECT COUNT(*)
          INTO ln_susdia
          FROM FST028 f
         WHERE f.calcod = 999
           AND f.fhabil = 'S'
           AND f.ffecha BETWEEN ld_susfec AND P_FECHOY;
        IF (ln_susdia > 0) THEN
          ln_susdia := ln_susdia - 1;
        END IF;
        ---***
        UPDATE JAQL420
           SET JAQL420SUSEST = 'R',
               JAQL420REAFEC = P_FECHOY,
               JAQL420SUSDIA = ln_susdia,
               JAQL420REAUSU = P_USER
         WHERE JAQL420EMP = 1
           AND JAQL420COD = P_RECCOD;
        COMMIT;
        ---***
        P_ERRCOD := '000';
        P_ERRMSG := 'Reclamo Reanudado Correctamente.';
        RETURN;
      END IF;
    ELSE
      P_ERRCOD := '003';
      P_ERRMSG := 'Para Reanudar, el Reclamo debe estar en estado -> En Proceso';
      RETURN;
    END IF;
  
  END SP_AH_GEN_REANUDAR_REC;
  ---*********
  PROCEDURE SP_AH_EMAIL_RECLAMO_SUSREA(P_FECHOY IN DATE,
                                       P_MODO   IN VARCHAR,
                                       P_ERRCOD OUT VARCHAR,
                                       P_ERRMSG OUT VARCHAR) IS
  
    --P_MODO(S: Correo de Suspendidos, R: Correo de Reanudados)
  
    ll_mensaje   CLOB;
    lv_mensaje   VARCHAR2(32767);
    lv_remitente VARCHAR2(30);
    lv_asunto    VARCHAR2(90);
    lv_destinos  VARCHAR2(32767) := '';
    lv_contacto  VARCHAR2(200);
    ln_corcar    NUMBER(10) := 0;
    lv_direccion VARCHAR2(200);
    ---***
    lc_asunto    VARCHAR(30);
    lc_remitente VARCHAR(30);
    ln_qtyrec    NUMBER(3);
    ---***
  
  BEGIN
    ---***
    P_ERRCOD  := '000';
    P_ERRMSG  := '';
    ln_qtyrec := 0;
    ---***
    IF (P_MODO = 'S') THEN
      SELECT COUNT(*)
        INTO ln_qtyrec
        FROM JAQL420 j
       WHERE j.JAQL420EMP = 1
         AND j.JAQL420SUSFEC = P_FECHOY
         AND j.JAQL420SUSEST = 'S';
    ELSE
      SELECT COUNT(*)
        INTO ln_qtyrec
        FROM JAQL420 j
       WHERE j.JAQL420EMP = 1
         AND j.JAQL420REAFEC = P_FECHOY
         AND j.JAQL420SUSEST = 'R';
    END IF;
    ---***
    --SELECT * FROM fst198 WHERE tp1cod1 = 11146 AND tp1corr1 = 1 AND tp1corr2 = 51
    ---*** ASUNTO
    ---***
    IF (ln_qtyrec > 0) THEN
      ---***
      IF (P_MODO = 'S') THEN
        SELECT tp1desc
          INTO lc_asunto
          FROM fst198
         WHERE tp1cod1 = 11146
           AND tp1corr1 = 1
           AND tp1corr2 = 51
           AND tp1corr3 = 2;
      ELSE
        SELECT tp1desc
          INTO lc_asunto
          FROM fst198
         WHERE tp1cod1 = 11146
           AND tp1corr1 = 1
           AND tp1corr2 = 51
           AND tp1corr3 = 3;
      END IF;
      lv_asunto := TRIM(lc_asunto);
      ---*** REMITENTE
      BEGIN
        SELECT TRIM(tp1desc)
          INTO lc_remitente
          FROM fst198
         WHERE tp1cod1 = 11146
           AND tp1corr1 = 1
           AND tp1corr2 = 51
           AND tp1corr3 = 4;
      EXCEPTION
        when others then
          P_ERRCOD := '106';
          P_ERRMSG := sqlcode || '->' || sqlerrm;
          RETURN;
      END;
    
      lv_remitente := TRIM(lc_remitente) || '@cajaarequipa.pe';
      --lv_remitente := 'cvillon@cajaarequipa.pe';
      ----dbms_output.put_line('lv_remitente: '||lv_remitente);
      ---*** DESTINOS
      lv_destinos := NULL;
      --lv_destinos := 'cvillon@cajaarequipa.pe';
      FOR XDEST IN (SELECT TRIM(tp1desc) AS DESTINATARIO
                      FROM fst198
                     WHERE tp1cod1 = 11146
                       AND tp1corr1 = 1
                       AND tp1corr2 = 51
                       AND tp1corr3 > 4) LOOP
        ---***
        XDEST.DESTINATARIO := TRIM(XDEST.DESTINATARIO) ||
                              '@cajaarequipa.pe';
        ---***
        IF (lv_destinos IS NULL) THEN
          lv_destinos := TRIM(XDEST.DESTINATARIO);
          --lv_destinos := 'cvillon@cajaarequipa.pe';
          --dbms_output.put_line('lv_destinos if: ' || lv_destinos);
        ELSE
          lv_destinos := TRIM(XDEST.DESTINATARIO) || ';' ||
                         TRIM(lv_destinos);
          --dbms_output.put_line('lv_destinos else: ' || lv_destinos);
        END IF;
      END LOOP;
      ---***
      dbms_lob.createtemporary(ll_mensaje, TRUE);
      ---***
      ---***
      IF (P_MODO = 'S') THEN
        lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Los Siguientes Reclamos fueron SUSPENDIDOS el dia de Hoy ...' ||
                      '<p "font-family: Arial, sans-serif; font-size: 14px;">********************************************************************************</p>' ||
                      '<table border = 1>' || '<tbody>' || '<tr>' ||
                      '<td><strong>Fecha de Recepción</strong></td>' ||
                      '<td><strong>Reclamo</strong></td>' ||
                      '<td><strong>Usuario que Suspendió</strong></td>' ||
                      '</tr>';
        FOR XROW IN (SELECT *
                       FROM JAQL420 j
                      WHERE j.JAQL420EMP = 1
                        AND j.JAQL420SUSFEC = P_FECHOY
                        AND j.JAQL420SUSEST = 'S') LOOP
          /*
          lv_mensaje := lv_mensaje ||
                        '<p "font-family: Arial, sans-serif; font-size: 14px;">Fecha de Reclamo: ' ||
                        XROW.JAQL420FCR || '</p>' ||
                        '<p "font-family: Arial, sans-serif; font-size: 14px;">Reclamo: ' ||
                        XROW.JAQL420COD || '</p>' ||
                        '<p "font-family: Arial, sans-serif; font-size: 14px;">Usuario que Suspendió: ' ||
                        XROW.JAQL420SUSUSU || '</p>' ||
                        '<p "font-family: Arial, sans-serif; font-size: 14px;">--------------------------------------------------------------------------------</p>';
            */
          lv_mensaje := lv_mensaje || '<tbody>' || '<tr>' || '<td>' ||
                        XROW.JAQL420FCR || '</td>' || '<td>' ||
                        XROW.JAQL420COD || '</td>' || '<td>' ||
                        XROW.JAQL420SUSUSU || '</td>' || '</tr>';
        
        END LOOP;
        lv_mensaje := lv_mensaje || '</tbody>' || '</table>';
      ELSE
        lv_mensaje := '<p "font-family: Arial, sans-serif; font-size: 14px;">Los Siguientes Reclamos fueron REANUDADOS el dia de Hoy ...' ||
                      '<p "font-family: Arial, sans-serif; font-size: 14px;">********************************************************************************</p>' ||
                      '<table border = 1>' || '<tbody>' || '<tr>' ||
                      '<td><strong>Fecha de Recepción</strong></td>' ||
                      '<td><strong>Reclamo</strong></td>' ||
                      '<td><strong>Usuario que Reanudó</strong></td>' ||
                      '</tr>';
        FOR XROW IN (SELECT *
                       FROM JAQL420 j
                      WHERE j.JAQL420EMP = 1
                        AND j.JAQL420REAFEC = P_FECHOY
                        AND j.JAQL420SUSEST = 'R') LOOP
          /*
          lv_mensaje := lv_mensaje ||
                        '<p "font-family: Arial, sans-serif; font-size: 14px;">Fecha de Reclamo: ' ||
                        XROW.JAQL420FCR || '</p>' ||
                        '<p "font-family: Arial, sans-serif; font-size: 14px;">Reclamo: ' ||
                        XROW.JAQL420COD || '</p>' ||
                        '<p "font-family: Arial, sans-serif; font-size: 14px;">Usuario que Suspendió: ' ||
                        XROW.JAQL420SUSUSU || '</p>' ||
                        '<p "font-family: Arial, sans-serif; font-size: 14px;">--------------------------------------------------------------------------------</p>';
            */
          lv_mensaje := lv_mensaje || '<tbody>' || '<tr>' || '<td>' ||
                        XROW.JAQL420FCR || '</td>' || '<td>' ||
                        XROW.JAQL420COD || '</td>' || '<td>' ||
                        XROW.JAQL420SUSUSU || '</td>' || '</tr>';
        
        END LOOP;
        lv_mensaje := lv_mensaje || '</tbody>' || '</table>';
      END IF;
    
      lv_mensaje := pq_ah_email_trx.fn_ah_replace_tildes(lv_mensaje);
      dbms_lob.writeappend(ll_mensaje, length(lv_mensaje), lv_mensaje);
    
      if trim(lv_destinos) is not null then
        begin
          -- Call the procedure
          pq_ah_planillas.p_sendmailattach(p_destinatariospara => lv_destinos,
                                           p_destinatarioscc   => '',
                                           p_destinatariosbcc  => '',
                                           p_mensaje           => ll_mensaje,
                                           p_remitente         => lv_remitente,
                                           p_asunto            => lv_asunto,
                                           p_tipomensaje       => 'HTML',
                                           p_directorio        => '',
                                           p_archivosadjuntos  => '',
                                           p_c_coderr          => P_ERRCOD,
                                           p_c_deserr          => P_ERRMSG);
        exception
          when others then
            P_ERRCOD := '00x';
            P_ERRMSG := sqlerrm;
        end;
      else
        P_ERRCOD := '00y';
        P_ERRMSG := 'No existe cuenta de correo asociada';
      end if;
    
      dbms_lob.freetemporary(ll_mensaje);
      ---***
    ELSE
      P_ERRCOD := '000';
      P_ERRMSG := 'No Hay INFO para Enviar por Email';
    END IF;
    ---***
  exception
    when others then
      P_ERRCOD := sqlcode;
      P_ERRMSG := sqlerrm;
      ---***
    ----dbms_output.put_line('p_c_coderr: '||p_c_coderr);
    ----dbms_output.put_line('p_c_deserr: '||p_c_deserr);
    ---***
  
  END SP_AH_EMAIL_RECLAMO_SUSREA;

  PROCEDURE SP_AH_JOB_RECLAMO_REANUDA(P_FECHOY IN DATE,
                                      P_ERRCOD OUT VARCHAR,
                                      P_ERRMSG OUT VARCHAR) IS
    ---***                                     
    ln_susdia NUMBER(3);
    ---***
  BEGIN
    ---***
    ln_susdia := 0;
    ---***  
    FOR XROW IN (SELECT *
                   FROM JAQL420 j
                  WHERE j.JAQL420EMP = 1
                    AND j.JAQL420SUSFLM = P_FECHOY
                    AND j.JAQL420SUSEST = 'S') LOOP
    
      ---***
      SELECT COUNT(*)
        INTO ln_susdia
        FROM FST028 f
       WHERE f.calcod = 999
         AND f.fhabil = 'S'
         AND f.ffecha BETWEEN XROW.JAQL420SUSFEC AND P_FECHOY;
      IF (ln_susdia > 0) THEN
        ln_susdia := ln_susdia - 1;
      END IF;
      ---***
      UPDATE JAQL420
         SET JAQL420SUSEST = 'R',
             JAQL420REAFEC = P_FECHOY,
             JAQL420SUSDIA = ln_susdia,
             JAQL420REAUSU = 'BTJOB'
       WHERE JAQL420EMP = 1
         AND JAQL420COD = XROW.JAQL420COD;
    END LOOP;
    ---***
    COMMIT;
    ---***
  END SP_AH_JOB_RECLAMO_REANUDA;

  PROCEDURE SP_AH_CALC_AMPLIACION(P_D_FECPRO IN DATE,
                                  P_N_NUMDIA IN NUMBER,
                                  P_V_TIPAMP IN VARCHAR,
                                  P_D_NEWDIA OUT DATE) AS
  
  BEGIN
  
    IF (P_V_TIPAMP = 'H') THEN
      SP_AH_CALC_DIAHABIL(P_D_FECPRO, P_N_NUMDIA, P_D_NEWDIA);
    END IF;
  
    IF (P_V_TIPAMP = 'C') THEN
      P_D_NEWDIA := P_D_FECPRO + P_N_NUMDIA;
    END IF;
  
  END SP_AH_CALC_AMPLIACION;

  PROCEDURE SP_AH_UPD_RECLAMO_AMP(P_V_CODREC IN VARCHAR,
                                  P_D_FECPRO IN DATE,
                                  P_N_NUMDIA IN NUMBER,
                                  P_V_TIPAMP IN VARCHAR,
                                  P_D_NEWDIA OUT DATE,
                                  P_ERRCOD   OUT VARCHAR,
                                  P_ERRMSG   OUT VARCHAR) AS
  
  BEGIN
  
    P_ERRCOD := '000';
    P_ERRMSG := '';
  
    SP_AH_CALC_AMPLIACION(P_D_FECPRO, P_N_NUMDIA, P_V_TIPAMP, P_D_NEWDIA);
  
    ---***
    UPDATE JAQL420
       SET JAQL420FLAMP = P_D_NEWDIA
     WHERE JAQL420EMP = 1
       AND JAQL420COD = P_V_CODREC;
    ---***
    COMMIT;
    ---***
  exception
    when others then
      P_ERRCOD := sqlcode;
      P_ERRMSG := sqlerrm;
    
  END SP_AH_UPD_RECLAMO_AMP;

---*********
END PQ_AH_REC_DIAS_CONT;
/

