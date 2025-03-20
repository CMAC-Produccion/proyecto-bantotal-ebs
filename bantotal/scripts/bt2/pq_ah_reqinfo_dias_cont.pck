CREATE OR REPLACE PACKAGE PQ_AH_REQINFO_DIAS_CONT IS
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
  -- Modificado                 : CVILLON
  -- Fecha de Modificación      : 2023.07.11
  -- Modificado                 : CVILLON
  -- Fecha de Modificación      : 2023.10.26
  -- ***************************************************************************************
  ---*********
  PROCEDURE SP_AH_CALC_DIAHABIL(P_D_FECPRO IN DATE,
                                P_N_NUMDIA IN NUMBER,
                                p_d_diahab out date);

  PROCEDURE SP_AH_GEN_DIAS_ABSOLUCION(P_RECCOD IN VARCHAR,
                                      P_FECHOY IN DATE,
                                      P_DIAS   OUT NUMBER,
                                      P_ERRCOD OUT VARCHAR,
                                      P_ERRMSG OUT VARCHAR);

  PROCEDURE SP_AH_GEN_REC_EXTRA_DATA(P_RECCOD IN VARCHAR,
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

END PQ_AH_REQINFO_DIAS_CONT;
/

CREATE OR REPLACE PACKAGE BODY PQ_AH_REQINFO_DIAS_CONT IS

  -- ***************************************************************************************
  -- Nombre                     : PROCEDURES PARA LA NUEVA CONTABILIZACION DE LOS DIAS
  -- Sistema                    : BANTOTAL
  -- Módulo                     : PASIVAS
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2023.02.22
  -- Autor de Creación          : CVILLON
  -- Uso                        : CONTABILIZACION DE LOS DIAS EN RECLAMOS Y REQ DE INFO
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2023.02.14
  -- Modificado                 : CVILLON
  -- Fecha de Modificación      : 2023.07.11
  -- Modificado                 : CVILLON
  -- Fecha de Modificación      : 2023.10.26
  -- ***************************************************************************************
  ---*********
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
      SELECT j.JAQY290TIPSBS,
             j.JAQY290DIAHAB,
             j.JAQY290_RESR,
             j.JAQY290_RFCR
        INTO lv_tipsbs, ld_pdiahab, ln_recest, ld_recfcr
        FROM JAQY290_R j
       WHERE j.JAQY290_REMP = 1
         AND j.JAQY290_RCOD = P_RECCOD;
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
    --dbms_output.put_line('Dias de Absolución: ' || P_DIAS);
  
  EXCEPTION
    when others then
      P_ERRCOD := '010';
      P_ERRMSG := sqlcode || '->' || sqlerrm;
    
  END SP_AH_GEN_DIAS_ABSOLUCION;
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
      SELECT j.JAQY290_RFCR,
             j.JAQY290_ROPS,
             j.JAQY290TIPSBS,
             j.JAQY290_RESR,
             j.JAQY290DABSOL,
             j.JAQY290_RFCC
        INTO ld_fcr, lv_ops, lv_TipRecR, ln_recesr, ln_dabsol, ld_recfcc
        FROM JAQY290_R j
       WHERE j.JAQY290_REMP = 1
         AND j.JAQY290_RCOD = P_RECCOD;
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
        UPDATE JAQY290_R
           SET JAQY290TIPSBS = lv_TipRec,
               JAQY290DIAHAB = ld_pdiahab,
               JAQY290FAPROX = ld_qdiahab
         WHERE JAQY290_REMP = 1
           AND JAQY290_RCOD = P_RECCOD;
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
        UPDATE JAQY290_R
           SET JAQY290TIPSBS = lv_TipRec,
               JAQY290DIAHAB = ld_pdiahab,
               JAQY290FAPROX = ld_qdiahab
         WHERE JAQY290_REMP = 1
           AND JAQY290_RCOD = P_RECCOD;
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
        UPDATE JAQY290_R
           SET JAQY290DABSOL = ln_dabsol, JAQY290FCCCLI = ld_fcccli
         WHERE JAQY290_REMP = 1
           AND JAQY290_RCOD = P_RECCOD;
      ELSIF (lv_TipRec = 'S') THEN
        UPDATE JAQY290_R
           SET JAQY290DABSOL = ln_dabsol, JAQY290FCCCLI = ld_recfcc
         WHERE JAQY290_REMP = 1
           AND JAQY290_RCOD = P_RECCOD;
      END IF;
      ---***
      COMMIT;
      ---***
    ELSE
      ---***
      UPDATE JAQY290_R
         SET JAQY290DABSOL = 0
       WHERE JAQY290_REMP = 1
         AND JAQY290_RCOD = P_RECCOD;
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
    UPDATE JAQY290_R
       SET JAQY290FLAMP = P_D_NEWDIA
     WHERE JAQY290_REMP = 1
       AND JAQY290_RCOD = P_V_CODREC;
    ---***
    COMMIT;
    ---***
  exception
    when others then
      P_ERRCOD := sqlcode;
      P_ERRMSG := sqlerrm;
    
  END SP_AH_UPD_RECLAMO_AMP;

END PQ_AH_REQINFO_DIAS_CONT;
/

