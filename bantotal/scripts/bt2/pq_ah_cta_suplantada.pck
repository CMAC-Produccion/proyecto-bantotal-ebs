CREATE OR REPLACE PACKAGE PQ_AH_CTA_SUPLANTADA IS
  -- ***************************************************************************************
  -- Nombre                     : PROCEDURES PARA TRATAMIENTO DE CTAS SUPLANTADAS
  -- Sistema                    : BANTOTAL
  -- Módulo                     : PASIVAS
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2023.06.22
  -- Autor de Creación          : CVILLON
  -- Uso                        : PROCESAMIENTO DE EXCEL CARGADO x CTAs SUPLANTADAS
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2023.06.22
  -- Fecha de Modificación      : 2023.06.22
  -- ***************************************************************************************
  ---***

  PROCEDURE SP_AH_PROCESA_CTA_SUPLANTADA_BASE(P_CARCOD IN VARCHAR,
                                              P_ERRCOD OUT VARCHAR,
                                              P_ERRMSG OUT VARCHAR);

  PROCEDURE SP_AH_CANCELA_CTA_DOI(P_CARCOD IN VARCHAR,
                                  P_CREUSU IN VARCHAR,
                                  P_WRKSTA IN VARCHAR,
                                  P_ERRCOD OUT VARCHAR,
                                  P_ERRMSG OUT VARCHAR);

  PROCEDURE SP_AH_CANCELA_CTA_DOI_IND(P_CARCOD IN VARCHAR,
                                      P_NROREG IN NUMBER,
                                      P_PAIS   IN NUMBER,
                                      P_TDOC   IN NUMBER,
                                      P_NDOC   IN VARCHAR,
                                      P_CREUSU IN VARCHAR,
                                      P_WRKSTA IN VARCHAR,
                                      P_ERRCOD OUT VARCHAR,
                                      P_ERRMSG OUT VARCHAR);

  PROCEDURE SP_AH_PROCESA_CTA_SUPLANTADA(P_CARCOD IN VARCHAR,
                                         P_CREUSU IN VARCHAR,
                                         P_WRKSTA IN VARCHAR,
                                         P_ERRCOD OUT VARCHAR,
                                         P_ERRMSG OUT VARCHAR);

  PROCEDURE SP_AH_PROCESA_CTA_SUPLANTADA_IND(P_CARCOD IN VARCHAR,
                                             P_NROREG IN NUMBER,
                                             P_PGCOD  IN NUMBER,
                                             P_SCSUC  IN NUMBER,
                                             P_SCRUB  IN NUMBER,
                                             P_SCMDA  IN NUMBER,
                                             P_SCPAP  IN NUMBER,
                                             P_SCCTA  IN NUMBER,
                                             P_SCOPER IN NUMBER,
                                             P_SCSBOP IN NUMBER,
                                             P_SCTOPE IN NUMBER,
                                             P_SCMOD  IN NUMBER,
                                             P_ESTINS IN NUMBER,
                                             P_CREUSU IN VARCHAR,
                                             P_WRKSTA IN VARCHAR,
                                             P_ERRCOD OUT VARCHAR,
                                             P_ERRMSG OUT VARCHAR);

  PROCEDURE SP_AH_CANCELA_CTA_EXEC(P_PGCOD  IN NUMBER,
                                   P_SCSUC  IN NUMBER,
                                   P_SCRUB  IN NUMBER,
                                   P_SCMDA  IN NUMBER,
                                   P_SCPAP  IN NUMBER,
                                   P_SCCTA  IN NUMBER,
                                   P_SCOPER IN NUMBER,
                                   P_SCSBOP IN NUMBER,
                                   P_SCTOPE IN NUMBER,
                                   P_SCMOD  IN NUMBER,
                                   P_MOTCOD IN NUMBER, -- Motivo
                                   P_CVUSBJ IN VARCHAR, -- Usuario
                                   P_CVWSBJ IN VARCHAR, -- WorkStation
                                   P_ERRCOD OUT VARCHAR,
                                   P_ERRMSG OUT VARCHAR);

  PROCEDURE SP_AH_BLOQUEA_CTA_EXEC(P_PGCOD  IN NUMBER,
                                   P_SCSUC  IN NUMBER,
                                   P_SCRUB  IN NUMBER,
                                   P_SCMDA  IN NUMBER,
                                   P_SCPAP  IN NUMBER,
                                   P_SCCTA  IN NUMBER,
                                   P_SCOPER IN NUMBER,
                                   P_SCSBOP IN NUMBER,
                                   P_SCTOPE IN NUMBER,
                                   P_SCMOD  IN NUMBER,
                                   P_MOTCOD IN NUMBER, -- Motivo
                                   P_CVUSBJ IN VARCHAR, -- Usuario
                                   P_CVWSBJ IN VARCHAR, -- WorkStation
                                   P_ERRCOD OUT VARCHAR,
                                   P_ERRMSG OUT VARCHAR);

  PROCEDURE SP_AH_LOG_DOI_AQPB542(P_CARCOD IN VARCHAR,
                                  P_NROREG IN NUMBER,
                                  P_PAIS   IN NUMBER,
                                  P_TDOC   IN NUMBER,
                                  P_NDOC   IN VARCHAR,
                                  P_PROEST IN VARCHAR,
                                  P_PROMSG IN VARCHAR);

  PROCEDURE SP_AH_LOG_CTA_AQPB542(P_CARCOD IN VARCHAR,
                                  P_NROREG IN NUMBER,
                                  P_PGCOD  IN NUMBER,
                                  P_SCSUC  IN NUMBER,
                                  P_SCRUB  IN NUMBER,
                                  P_SCMDA  IN NUMBER,
                                  P_SCPAP  IN NUMBER,
                                  P_SCCTA  IN NUMBER,
                                  P_SCOPER IN NUMBER,
                                  P_SCSBOP IN NUMBER,
                                  P_SCTOPE IN NUMBER,
                                  P_SCMOD  IN NUMBER,
                                  P_PROEST IN VARCHAR,
                                  P_PROMSG IN VARCHAR);

---***
END PQ_AH_CTA_SUPLANTADA;
---***
/

CREATE OR REPLACE PACKAGE BODY PQ_AH_CTA_SUPLANTADA IS
  -- ***************************************************************************************
  -- Nombre                     : PROCEDURES PARA TRATAMIENTO DE CTAS SUPLANTADAS
  -- Sistema                    : BANTOTAL
  -- Módulo                     : PASIVAS
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2023.06.22
  -- Autor de Creación          : CVILLON
  -- Uso                        : PROCESAMIENTO DE EXCEL CARGADO x CTAs SUPLANTADAS
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2023.06.22
  -- Fecha de Modificación      : 2023.06.27
  -- ***************************************************************************************
  ---***
  ---*********
  PROCEDURE SP_AH_PROCESA_CTA_SUPLANTADA_BASE(P_CARCOD IN VARCHAR,
                                              P_ERRCOD OUT VARCHAR,
                                              P_ERRMSG OUT VARCHAR) AS
    ---***
    lv_TIPO   VARCHAR(3);
    lv_CREUSU VARCHAR(10);
    lv_WRKSTA VARCHAR(10);
    lv_ERRCOD VARCHAR(3);
    lv_ERRMSG VARCHAR(50);
    ---***
  BEGIN
    ---***
    P_ERRCOD := '000';
    ---*** CONSULTA A LA CABECERA
    SELECT AQPB542ATIPO, AQPB542ACREUSU, AQPB542AWRKSTA
      INTO lv_TIPO, lv_CREUSU, lv_WRKSTA
      FROM AQPB542A
     WHERE AQPB542ACODIGO = P_CARCOD;
    ---***
  
    IF (lv_TIPO = 'DOI') THEN
      SP_AH_CANCELA_CTA_DOI(P_CARCOD,
                            lv_CREUSU,
                            lv_WRKSTA,
                            P_ERRCOD,
                            P_ERRMSG);
    ELSIF (lv_TIPO = 'CTA') THEN
      SP_AH_PROCESA_CTA_SUPLANTADA(P_CARCOD,
                                   lv_CREUSU,
                                   lv_WRKSTA,
                                   P_ERRCOD,
                                   P_ERRMSG);
    ELSE
      P_ERRCOD := 'P01';
      P_ERRMSG := 'NO es un TIPO de Proceso Válido';
      RETURN;
    END IF;
  
  END SP_AH_PROCESA_CTA_SUPLANTADA_BASE;

  PROCEDURE SP_AH_CANCELA_CTA_DOI(P_CARCOD IN VARCHAR,
                                  P_CREUSU IN VARCHAR,
                                  P_WRKSTA IN VARCHAR,
                                  P_ERRCOD OUT VARCHAR,
                                  P_ERRMSG OUT VARCHAR) AS
  
    ---***
    ln_AQPB542PAIS NUMBER(3);
    ln_AQPB542TDOC NUMBER(2);
    lv_AQPB542NDOC VARCHAR(12);
    ---***
  BEGIN
    ---***
    P_ERRCOD := '000';
  
    ln_AQPB542PAIS := 0;
    ln_AQPB542TDOC := 0;
    lv_AQPB542NDOC := '0';
    ---***
    FOR XROW IN (SELECT * FROM AQPB542 WHERE AQPB542CODIGO = P_CARCOD) LOOP
      BEGIN
        --dbms_output.put_line('P_CARCOD: '||P_CARCOD);
        --dbms_output.put_line('XROW.AQPB542PAIS: '||XROW.AQPB542PAIS);
        --dbms_output.put_line('XROW.AQPB542TDOC: '||XROW.AQPB542TDOC);
        --dbms_output.put_line('XROW.AQPB542NDOC: '||XROW.AQPB542NDOC);
      
        IF (XROW.AQPB542PAIS <> ln_AQPB542PAIS OR
           XROW.AQPB542TDOC <> ln_AQPB542TDOC OR
           XROW.AQPB542NDOC <> lv_AQPB542NDOC) THEN
          SP_AH_CANCELA_CTA_DOI_IND(P_CARCOD,
                                    XROW.AQPB542NROREG,
                                    XROW.AQPB542PAIS,
                                    XROW.AQPB542TDOC,
                                    XROW.AQPB542NDOC,
                                    P_CREUSU,
                                    P_WRKSTA,
                                    P_ERRCOD,
                                    P_ERRMSG);
        END IF;
      
        ln_AQPB542PAIS := XROW.AQPB542PAIS;
        ln_AQPB542TDOC := XROW.AQPB542TDOC;
        lv_AQPB542NDOC := XROW.AQPB542NDOC;
      
        IF (P_ERRCOD = '000') THEN
          SP_AH_PROCESA_CTA_SUPLANTADA(P_CARCOD,
                                       P_CREUSU,
                                       P_WRKSTA,
                                       P_ERRCOD,
                                       P_ERRMSG);
          IF (P_ERRCOD = '000') THEN
            ---***
            COMMIT;
            ---***
          END IF;
        
        ELSE
          ---***LOG
          SP_AH_LOG_DOI_AQPB542(P_CARCOD,
                                XROW.AQPB542NROREG,
                                XROW.AQPB542PAIS,
                                XROW.AQPB542TDOC,
                                XROW.AQPB542NDOC,
                                'E',
                                P_ERRCOD || ' -> ' || P_ERRMSG);
        
        END IF;
        ---***
        ---***
      EXCEPTION
        when others then
          P_ERRCOD := 'B01';
          P_ERRMSG := sqlcode || '->' || sqlerrm;
          CONTINUE;
      END;
    END LOOP;
    ---***
  EXCEPTION
    when others then
      P_ERRCOD := '101';
      P_ERRMSG := sqlcode || '->' || sqlerrm;
      RETURN;
  END SP_AH_CANCELA_CTA_DOI;
  ---***

  PROCEDURE SP_AH_CANCELA_CTA_DOI_IND(P_CARCOD IN VARCHAR,
                                      P_NROREG IN NUMBER,
                                      P_PAIS   IN NUMBER,
                                      P_TDOC   IN NUMBER,
                                      P_NDOC   IN VARCHAR,
                                      P_CREUSU IN VARCHAR,
                                      P_WRKSTA IN VARCHAR,
                                      P_ERRCOD OUT VARCHAR,
                                      P_ERRMSG OUT VARCHAR) AS
  
    ---***
    lc_NDOC CHAR(12);
    ---***
  
  BEGIN
    P_ERRCOD := '000';
    lc_NDOC  := TRIM(P_NDOC);
    ---*** ELIMINAR DATA TABLA FSR005
    FOR DROW IN (SELECT *
                   FROM FSR005
                  WHERE PEPAIS = P_PAIS
                    AND PETDOC = P_TDOC
                    AND PENDOC = lc_NDOC) LOOP
      ---*** LOG
      INSERT INTO AQPB542B
        (AQPB542BCARCOD,
         AQPB542BPEPAIS,
         AQPB542BPETDOC,
         AQPB542BPENDOC,
         AQPB542BDOCOD,
         AQPB542BDOORDP,
         AQPB542BDOTELF,
         AQPB542BDOTLEX,
         AQPB542BDOFAXP,
         AQPB542BCRETIM)
      VALUES
        (P_CARCOD,
         DROW.PEPAIS,
         DROW.PETDOC,
         DROW.PENDOC,
         DROW.DOCOD,
         DROW.DOORDP,
         DROW.DOTELFP,
         DROW.DOTLEXP,
         DROW.DOFAXP,
         SYSDATE);
      ---*** DELETE
      DELETE FROM FSR005
       WHERE PEPAIS = DROW.PEPAIS
         AND PETDOC = DROW.PETDOC
         AND PENDOC = DROW.PENDOC
         AND DOCOD = DROW.DOCOD
         AND DOORDP = DROW.DOORDP;
      ---***
    END LOOP;
    ---***
    ---*** ELIMINAR DATA TABLA FSX001
    FOR DROW IN (SELECT *
                   FROM FSX001
                  WHERE PEPAIS = P_PAIS
                    AND PETDOC = P_TDOC
                    AND PENDOC = lc_NDOC) LOOP
      ---*** LOG
      INSERT INTO AQPB542C
        (AQPB542CCARCOD,
         AQPB542CPEPAIS,
         AQPB542CPETDOC,
         AQPB542CPENDOC,
         AQPB542CTXCOD,
         AQPB542CPEXREN,
         AQPB542CPEXTXT,
         AQPB542CPEXUSU,
         AQPB542CPEXFCH,
         AQPB542CCRETIM)
      VALUES
        (P_CARCOD,
         DROW.PEPAIS,
         DROW.PETDOC,
         DROW.PENDOC,
         DROW.TXCOD,
         DROW.PEXREN,
         DROW.PEXTXT,
         DROW.PEXUSU,
         DROW.PEXFCH,
         SYSDATE);
      ---*** DELETE
      DELETE FROM FSX001
       WHERE PEPAIS = DROW.PEPAIS
         AND PETDOC = DROW.PETDOC
         AND PENDOC = DROW.PENDOC
         AND TXCOD = DROW.TXCOD
         AND PEXREN = DROW.PEXREN;
      ---***
    END LOOP;
    ---***
    SP_AH_LOG_DOI_AQPB542(P_CARCOD,
                          P_NROREG,
                          P_PAIS,
                          P_TDOC,
                          P_NDOC,
                          'P',
                          NULL);
  
    ---***
  
  EXCEPTION
    when others then
      P_ERRCOD := '102';
      P_ERRMSG := sqlcode || '->' || sqlerrm;
      RETURN;
  END SP_AH_CANCELA_CTA_DOI_IND;

  PROCEDURE SP_AH_PROCESA_CTA_SUPLANTADA(P_CARCOD IN VARCHAR,
                                         P_CREUSU IN VARCHAR,
                                         P_WRKSTA IN VARCHAR,
                                         P_ERRCOD OUT VARCHAR,
                                         P_ERRMSG OUT VARCHAR) AS
  
  BEGIN
    ---***
    P_ERRCOD := '000';
    ---***
    FOR XROW IN (SELECT * FROM AQPB542 WHERE AQPB542CODIGO = P_CARCOD) LOOP
      BEGIN
        --dbms_output.put_line('P_CARCOD: '||P_CARCOD);
        --dbms_output.put_line('XROW.AQPB542PAIS: '||XROW.AQPB542PAIS);
        --dbms_output.put_line('XROW.AQPB542TDOC: '||XROW.AQPB542TDOC);
        --dbms_output.put_line('XROW.AQPB542NDOC: '||XROW.AQPB542NDOC);
        SP_AH_PROCESA_CTA_SUPLANTADA_IND(XROW.AQPB542CODIGO,
                                         XROW.AQPB542NROREG,
                                         XROW.AQPB542PGCOD,
                                         XROW.AQPB542SCSUC,
                                         XROW.AQPB542SCRUB,
                                         XROW.AQPB542SCMDA,
                                         XROW.AQPB542SCPAP,
                                         XROW.AQPB542SCCTA,
                                         XROW.AQPB542SCOPER,
                                         XROW.AQPB542SCSBOP,
                                         XROW.AQPB542SCTOPE,
                                         XROW.AQPB542SCMOD,
                                         XROW.AQPB542ESTINS,
                                         P_CREUSU,
                                         P_WRKSTA,
                                         P_ERRCOD,
                                         P_ERRMSG);
      
        IF (P_ERRCOD = '000') THEN
          ---***
          COMMIT;
          ---***
        END IF;
      EXCEPTION
        when others then
          P_ERRCOD := 'B02';
          P_ERRMSG := sqlcode || '->' || sqlerrm;
          CONTINUE;
      END;
    END LOOP;
    ---***
  EXCEPTION
    when others then
      P_ERRCOD := 'S01';
      P_ERRMSG := sqlcode || '->' || sqlerrm;
      RETURN;
  END SP_AH_PROCESA_CTA_SUPLANTADA;

  PROCEDURE SP_AH_PROCESA_CTA_SUPLANTADA_IND(P_CARCOD IN VARCHAR,
                                             P_NROREG IN NUMBER,
                                             P_PGCOD  IN NUMBER,
                                             P_SCSUC  IN NUMBER,
                                             P_SCRUB  IN NUMBER,
                                             P_SCMDA  IN NUMBER,
                                             P_SCPAP  IN NUMBER,
                                             P_SCCTA  IN NUMBER,
                                             P_SCOPER IN NUMBER,
                                             P_SCSBOP IN NUMBER,
                                             P_SCTOPE IN NUMBER,
                                             P_SCMOD  IN NUMBER,
                                             P_ESTINS IN NUMBER,
                                             P_CREUSU IN VARCHAR,
                                             P_WRKSTA IN VARCHAR,
                                             P_ERRCOD OUT VARCHAR,
                                             P_ERRMSG OUT VARCHAR) AS
  
    ln_INS NUMBER(3);
  
  BEGIN
    ---***
    ln_INS   := 0;
    P_ERRCOD := '000';
    ---***
  
    SELECT COUNT(*)
      INTO ln_INS
      FROM FST198
     WHERE TP1COD = 1
       AND TP1COD1 = 11146
       AND TP1CORR1 = 1
       AND TP1CORR2 = 61
       AND TP1CORR3 = P_ESTINS;
  
    IF (ln_INS > 0) THEN
      ---*** CANCELACION
      IF (P_ESTINS = 31) THEN
        SP_AH_CANCELA_CTA_EXEC(P_PGCOD,
                               P_SCSUC,
                               P_SCRUB,
                               P_SCMDA,
                               P_SCPAP,
                               P_SCCTA,
                               P_SCOPER,
                               P_SCSBOP,
                               P_SCTOPE,
                               P_SCMOD,
                               P_ESTINS,
                               P_CREUSU,
                               P_WRKSTA,
                               P_ERRCOD,
                               P_ERRMSG);
        ---*** BLOQUEO TOTAL
      ELSIF (P_ESTINS IN (32, 33)) THEN
        SP_AH_BLOQUEA_CTA_EXEC(P_PGCOD,
                               P_SCSUC,
                               P_SCRUB,
                               P_SCMDA,
                               P_SCPAP,
                               P_SCCTA,
                               P_SCOPER,
                               P_SCSBOP,
                               P_SCTOPE,
                               P_SCMOD,
                               P_ESTINS,
                               P_CREUSU,
                               P_WRKSTA,
                               P_ERRCOD,
                               P_ERRMSG);
      END IF;
    
      ---***
      IF (P_ERRCOD <> '000') THEN
        SP_AH_LOG_CTA_AQPB542(P_CARCOD,
                              P_NROREG,
                              P_PGCOD,
                              P_SCSUC,
                              P_SCRUB,
                              P_SCMDA,
                              P_SCPAP,
                              P_SCCTA,
                              P_SCOPER,
                              P_SCSBOP,
                              P_SCTOPE,
                              P_SCMOD,
                              'E',
                              P_ERRCOD || ' -> ' || P_ERRMSG);
      
        RETURN;
      ELSIF (P_ERRCOD = '000') THEN
        SP_AH_LOG_CTA_AQPB542(P_CARCOD,
                              P_NROREG,
                              P_PGCOD,
                              P_SCSUC,
                              P_SCRUB,
                              P_SCMDA,
                              P_SCPAP,
                              P_SCCTA,
                              P_SCOPER,
                              P_SCSBOP,
                              P_SCTOPE,
                              P_SCMOD,
                              'P',
                              NULL);
      END IF;
    
      ---***
    ELSE
      P_ERRCOD := '203';
      P_ERRMSG := 'ESTADO NO permitido para la Instruccion';
    
      SP_AH_LOG_CTA_AQPB542(P_CARCOD,
                            P_NROREG,
                            P_PGCOD,
                            P_SCSUC,
                            P_SCRUB,
                            P_SCMDA,
                            P_SCPAP,
                            P_SCCTA,
                            P_SCOPER,
                            P_SCSBOP,
                            P_SCTOPE,
                            P_SCMOD,
                            'E',
                            P_ERRCOD || ' -> ' || P_ERRMSG);
      RETURN;
    END IF;
    ---***
  EXCEPTION
    when others then
      P_ERRCOD := '202';
      P_ERRMSG := sqlcode || '->' || sqlerrm;
    
      SP_AH_LOG_CTA_AQPB542(P_CARCOD,
                            P_NROREG,
                            P_PGCOD,
                            P_SCSUC,
                            P_SCRUB,
                            P_SCMDA,
                            P_SCPAP,
                            P_SCCTA,
                            P_SCOPER,
                            P_SCSBOP,
                            P_SCTOPE,
                            P_SCMOD,
                            'E',
                            P_ERRCOD || ' -> ' || P_ERRMSG);
      RETURN;
    
  END SP_AH_PROCESA_CTA_SUPLANTADA_IND;

  PROCEDURE SP_AH_CANCELA_CTA_EXEC(P_PGCOD  IN NUMBER,
                                   P_SCSUC  IN NUMBER,
                                   P_SCRUB  IN NUMBER,
                                   P_SCMDA  IN NUMBER,
                                   P_SCPAP  IN NUMBER,
                                   P_SCCTA  IN NUMBER,
                                   P_SCOPER IN NUMBER,
                                   P_SCSBOP IN NUMBER,
                                   P_SCTOPE IN NUMBER,
                                   P_SCMOD  IN NUMBER,
                                   P_MOTCOD IN NUMBER,
                                   P_CVUSBJ IN VARCHAR,
                                   P_CVWSBJ IN VARCHAR,
                                   P_ERRCOD OUT VARCHAR,
                                   P_ERRMSG OUT VARCHAR) AS
  
    ---***
    ln_SALDO   NUMBER(17, 2);
    ln_SCSTAT  NUMBER(2);
    ln_CBIEREL NUMBER(5);
    ld_FECHOY  DATE;
    lv_MOTTXT  VARCHAR(30);
    ---***
  BEGIN
    ---***
    P_ERRCOD := '000';
    ---***
    SELECT PGFAPE INTO ld_FECHOY FROM FST017 WHERE PGCOD = 1;
    ---***
    ---*** PASO1: VERIFICAR QUE LA CTA TIENE SALDO 0.00 y No esta INACTIVA
    BEGIN
      SELECT SCSDO, SCSTAT
        INTO ln_SALDO, ln_SCSTAT
        FROM FSD011
       WHERE PGCOD = P_PGCOD
         AND SCSUC = P_SCSUC
         AND SCRUB = P_SCRUB
         AND SCMDA = P_SCMDA
         AND SCPAP = P_SCPAP
         AND SCCTA = P_SCCTA
         AND SCOPER = P_SCOPER
         AND SCSBOP = P_SCSBOP
         AND SCTOPE = P_SCTOPE
         AND SCMOD = P_SCMOD
         AND ROWNUM = 1
       ORDER BY SCFULM DESC;
    
    EXCEPTION
      when others then
        P_ERRCOD := 'E01';
        P_ERRMSG := sqlcode || '->' || sqlerrm;
        RETURN;
    END;
  
    IF (ln_SALDO <> 0) THEN
      P_ERRCOD := 'C01';
      P_ERRMSG := 'NO se puede CANCELAR la CTA por tener SALDO';
      RETURN;
    END IF;
    IF (ln_SCSTAT = 81) THEN
      P_ERRCOD := 'C02';
      P_ERRMSG := 'NO se puede CANCELAR la CTA por estar INACTIVA';
      RETURN;
    END IF;
    IF (ln_SCSTAT = 99) THEN
      P_ERRCOD := 'C02';
      P_ERRMSG := 'La CTA se encuentra CANCELADA';
      RETURN;
    END IF;
    ---***
    ---*** PASO3: GUARDAR EL ESTADO ANTERIOR EN EL FSD450 (y el MOTIVO)
    --CBIEEMP, CBIEMOD, CBIESUC, CBIEMDA, CBIEPAP, CBIECTA, CBIEOPE, CBIESUB, CBIETOP, CBIEFEC, CBIEREL
    BEGIN
      SELECT TRIM(TP1DESC)
        INTO lv_MOTTXT
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11146
         AND TP1CORR1 = 1
         AND TP1CORR2 = 61
         AND TP1CORR3 = P_MOTCOD;
    EXCEPTION
      when others then
        P_ERRCOD := 'E03';
        P_ERRMSG := sqlcode || '->' || sqlerrm;
        RETURN;
    END;
  
    BEGIN
      -- Obtenemos el siguiente CBIEREL
      SELECT COALESCE(MAX(CBIEREL), 0)
        INTO ln_CBIEREL
        FROM FSD450
       WHERE CBIEEMP = P_PGCOD
         AND CBIEMOD = P_SCMOD
         AND CBIESUC = P_SCSUC
         AND CBIEMDA = P_SCMDA
         AND CBIEPAP = P_SCPAP
         AND CBIECTA = P_SCCTA
         AND CBIEOPE = P_SCOPER
         AND CBIESUB = P_SCSBOP
         AND CBIETOP = P_SCTOPE;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        ln_CBIEREL := 0;
      when others then
        P_ERRCOD := 'E04';
        P_ERRMSG := sqlcode || '->' || sqlerrm;
        RETURN;
    END;
    --***
    ln_CBIEREL := ln_CBIEREL + 1;
    ---***
    BEGIN
      INSERT INTO FSD450
        (CBIEEMP,
         CBIEMOD,
         CBIESUC,
         CBIEMDA,
         CBIEPAP,
         CBIECTA,
         CBIEOPE,
         CBIESUB,
         CBIETOP,
         CBIEFEC,
         CBIEREL,
         CBIEANT,
         CBIETXT1,
         CBIETXT2,
         CBIETXT3,
         PGCOD,
         HCMOD,
         HSUCOR,
         HTRAN,
         HNREL,
         HFCONT,
         HCORD,
         HCSUBO,
         EXCOD)
      VALUES
        (P_PGCOD,
         P_SCMOD,
         P_SCSUC,
         P_SCMDA,
         P_SCPAP,
         P_SCCTA,
         P_SCOPER,
         P_SCSBOP,
         P_SCTOPE,
         ld_FECHOY,
         ln_CBIEREL,
         ln_SCSTAT,
         lv_MOTTXT,
         lv_MOTTXT,
         null,
         P_PGCOD,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null);
    EXCEPTION
      when others then
        P_ERRCOD := 'E05';
        P_ERRMSG := sqlcode || '->' || sqlerrm;
        RETURN;
    END;
    --***
    ---*** PASO4: ACTUALIZAR USUARIO Y TERMINAL EN LA TABLA FSE013
    /*
    SELECT * FROM FSE013
    P_CVUSBJ   IN VARCHAR, --Usuario
    P_CVWSBJ   IN VARCHAR, --WorkStation
    */
    BEGIN
    
      UPDATE FSE013
         SET CVFCBJ = ld_FECHOY, CVUSBJ = P_CVUSBJ, CVWSBJ = P_CVWSBJ
       WHERE PGCOD = P_PGCOD
         AND CVMOD = P_SCMOD
         AND CVMDA = P_SCMDA
         AND CVPAP = P_SCPAP
         AND CVCTA = P_SCCTA
         AND CVSUC = P_SCSUC
         AND CVOPER = P_SCOPER
         AND CVSBOP = P_SCSBOP
         AND CVTOPE = P_SCTOPE;
    
    EXCEPTION
      when others then
        P_ERRCOD := 'E06';
        P_ERRMSG := sqlcode || '->' || sqlerrm;
    END;
    --***
  
    --SELECT * FROM FSE113 
    ---*** PASO5: GRABAR MOTIVO EN LA TABLA FSE113
    BEGIN
    
      UPDATE FSE113
         SET CV1AUX5 = P_MOTCOD, CV1AUX6 = P_CVUSBJ, CV1AUX7 = ld_FECHOY
       WHERE PGCOD = P_PGCOD
         AND CV1MOD = P_SCMOD
         AND CV1MDA = P_SCMDA
         AND CV1PAP = P_SCPAP
         AND CV1CTA = P_SCCTA
         AND CV1SUC = P_SCSUC
         AND CV1OPER = P_SCOPER
         AND CV1SBOP = P_SCSBOP
         AND CV1TOPE = P_SCTOPE;
    
    EXCEPTION
      when others then
        P_ERRCOD := 'E07';
        P_ERRMSG := sqlcode || '->' || sqlerrm;
    END;
    --***
    ---*** PASO FINAL: ACTUALIZAMOS LA FSD011 -> ESTADO 99 
    BEGIN
      UPDATE FSD011
         SET SCSTAT = 99
       WHERE PGCOD = P_PGCOD
         AND SCSUC = P_SCSUC
         AND SCRUB = P_SCRUB
         AND SCMDA = P_SCMDA
         AND SCPAP = P_SCPAP
         AND SCCTA = P_SCCTA
         AND SCOPER = P_SCOPER
         AND SCSBOP = P_SCSBOP
         AND SCTOPE = P_SCTOPE
         AND SCMOD = P_SCMOD;
    EXCEPTION
      when others then
        P_ERRCOD := 'E02';
        P_ERRMSG := sqlcode || '->' || sqlerrm;
        RETURN;
    END;
  
  EXCEPTION
    when others then
      P_ERRCOD := 'E08';
      P_ERRMSG := sqlcode || '->' || sqlerrm;
      RETURN;
    
  END SP_AH_CANCELA_CTA_EXEC;

  PROCEDURE SP_AH_BLOQUEA_CTA_EXEC(P_PGCOD  IN NUMBER,
                                   P_SCSUC  IN NUMBER,
                                   P_SCRUB  IN NUMBER,
                                   P_SCMDA  IN NUMBER,
                                   P_SCPAP  IN NUMBER,
                                   P_SCCTA  IN NUMBER,
                                   P_SCOPER IN NUMBER,
                                   P_SCSBOP IN NUMBER,
                                   P_SCTOPE IN NUMBER,
                                   P_SCMOD  IN NUMBER,
                                   P_MOTCOD IN NUMBER,
                                   P_CVUSBJ IN VARCHAR,
                                   P_CVWSBJ IN VARCHAR,
                                   P_ERRCOD OUT VARCHAR,
                                   P_ERRMSG OUT VARCHAR) AS
  
    ---***
    ln_SALDO   NUMBER(17, 2);
    ln_SCSTAT  NUMBER(2);
    ln_CBIEREL NUMBER(5);
    ld_FECHOY  DATE;
    lv_MOTTXT  VARCHAR(30);
    ---***
  BEGIN
    ---***
    P_ERRCOD := '000';
    ---***
    SELECT PGFAPE INTO ld_FECHOY FROM FST017 WHERE PGCOD = 1;
    ---***
    ---*** PASO1: VERIFICAR QUE LA CTA No esta INACTIVA
    BEGIN
      SELECT SCSDO, SCSTAT
        INTO ln_SALDO, ln_SCSTAT
        FROM FSD011
       WHERE PGCOD = P_PGCOD
         AND SCSUC = P_SCSUC
         AND SCRUB = P_SCRUB
         AND SCMDA = P_SCMDA
         AND SCPAP = P_SCPAP
         AND SCCTA = P_SCCTA
         AND SCOPER = P_SCOPER
         AND SCSBOP = P_SCSBOP
         AND SCTOPE = P_SCTOPE
         AND SCMOD = P_SCMOD
         AND ROWNUM = 1
       ORDER BY SCFULM DESC;
    
    EXCEPTION
      when others then
        P_ERRCOD := 'E01';
        P_ERRMSG := sqlcode || '->' || sqlerrm;
        RETURN;
    END;
    IF (ln_SCSTAT = 81) THEN
      P_ERRCOD := 'B01';
      P_ERRMSG := 'NO se puede BLOQUEAR la CTA por estar INACTIVA';
      RETURN;
    END IF;
    IF (ln_SCSTAT = 99) THEN
      P_ERRCOD := 'B02';
      P_ERRMSG := 'La CTA se encuentra CANCELADA';
      RETURN;
    END IF;
    ---***
    ---*** PASO3: GUARDAR EL ESTADO ANTERIOR EN EL FSD450 (y el MOTIVO)
    --CBIEEMP, CBIEMOD, CBIESUC, CBIEMDA, CBIEPAP, CBIECTA, CBIEOPE, CBIESUB, CBIETOP, CBIEFEC, CBIEREL
    BEGIN
      SELECT TRIM(TP1DESC)
        INTO lv_MOTTXT
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11146
         AND TP1CORR1 = 1
         AND TP1CORR2 = 61
         AND TP1CORR3 = P_MOTCOD;
    EXCEPTION
      when others then
        P_ERRCOD := 'E03';
        P_ERRMSG := sqlcode || '->' || sqlerrm;
        RETURN;
    END;
  
    BEGIN
      -- Obtenemos el siguiente CBIEREL
      SELECT COALESCE(MAX(CBIEREL), 0)
        INTO ln_CBIEREL
        FROM FSD450
       WHERE CBIEEMP = P_PGCOD
         AND CBIEMOD = P_SCMOD
         AND CBIESUC = P_SCSUC
         AND CBIEMDA = P_SCMDA
         AND CBIEPAP = P_SCPAP
         AND CBIECTA = P_SCCTA
         AND CBIEOPE = P_SCOPER
         AND CBIESUB = P_SCSBOP
         AND CBIETOP = P_SCTOPE;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        ln_CBIEREL := 0;
      when others then
        P_ERRCOD := 'E04';
        P_ERRMSG := sqlcode || '->' || sqlerrm;
        RETURN;
    END;
    --***
    ln_CBIEREL := ln_CBIEREL + 1;
    ---***
    BEGIN
      INSERT INTO FSD450
        (CBIEEMP,
         CBIEMOD,
         CBIESUC,
         CBIEMDA,
         CBIEPAP,
         CBIECTA,
         CBIEOPE,
         CBIESUB,
         CBIETOP,
         CBIEFEC,
         CBIEREL,
         CBIEANT,
         CBIETXT1,
         CBIETXT2,
         CBIETXT3,
         PGCOD,
         HCMOD,
         HSUCOR,
         HTRAN,
         HNREL,
         HFCONT,
         HCORD,
         HCSUBO,
         EXCOD)
      VALUES
        (P_PGCOD,
         P_SCMOD,
         P_SCSUC,
         P_SCMDA,
         P_SCPAP,
         P_SCCTA,
         P_SCOPER,
         P_SCSBOP,
         P_SCTOPE,
         ld_FECHOY,
         ln_CBIEREL,
         ln_SCSTAT,
         lv_MOTTXT,
         lv_MOTTXT,
         null,
         P_PGCOD,
         null,
         null,
         null,
         null,
         null,
         null,
         null,
         null);
    EXCEPTION
      when others then
        P_ERRCOD := 'E05';
        P_ERRMSG := sqlcode || '->' || sqlerrm;
        RETURN;
    END;
    --***
    ---********* PASO FINAL: ACTUALIZAMOS LA FSD011 -> ESTADO 6 (BLOQUEO TOTAL)
    BEGIN
      UPDATE FSD011
         SET SCSTAT = 6
       WHERE PGCOD = P_PGCOD
         AND SCSUC = P_SCSUC
         AND SCRUB = P_SCRUB
         AND SCMDA = P_SCMDA
         AND SCPAP = P_SCPAP
         AND SCCTA = P_SCCTA
         AND SCOPER = P_SCOPER
         AND SCSBOP = P_SCSBOP
         AND SCTOPE = P_SCTOPE
         AND SCMOD = P_SCMOD;
    EXCEPTION
      when others then
        P_ERRCOD := 'E02';
        P_ERRMSG := sqlcode || '->' || sqlerrm;
        RETURN;
    END;
    ---*********    
  
  EXCEPTION
    when others then
      P_ERRCOD := 'E08';
      P_ERRMSG := sqlcode || '->' || sqlerrm;
      RETURN;
  END SP_AH_BLOQUEA_CTA_EXEC;

  PROCEDURE SP_AH_LOG_DOI_AQPB542(P_CARCOD IN VARCHAR,
                                  P_NROREG IN NUMBER,
                                  P_PAIS   IN NUMBER,
                                  P_TDOC   IN NUMBER,
                                  P_NDOC   IN VARCHAR,
                                  P_PROEST IN VARCHAR,
                                  P_PROMSG IN VARCHAR) AS
  
    ---*** 
    lc_NDOC CHAR(12);
    ---***
  BEGIN
  
    ---***
    lc_NDOC := P_NDOC;
    ---***  
  
    UPDATE AQPB542
       SET AQPB542PROEST = P_PROEST, AQPB542PROMSG = P_PROMSG
     WHERE AQPB542CODIGO = P_CARCOD
       AND AQPB542NROREG = P_NROREG
       AND AQPB542PAIS = P_PAIS
       AND AQPB542TDOC = P_TDOC
       AND AQPB542NDOC = lc_NDOC;
    ---***
    COMMIT;
    ---***
  END SP_AH_LOG_DOI_AQPB542;

  PROCEDURE SP_AH_LOG_CTA_AQPB542(P_CARCOD IN VARCHAR,
                                  P_NROREG IN NUMBER,
                                  P_PGCOD  IN NUMBER,
                                  P_SCSUC  IN NUMBER,
                                  P_SCRUB  IN NUMBER,
                                  P_SCMDA  IN NUMBER,
                                  P_SCPAP  IN NUMBER,
                                  P_SCCTA  IN NUMBER,
                                  P_SCOPER IN NUMBER,
                                  P_SCSBOP IN NUMBER,
                                  P_SCTOPE IN NUMBER,
                                  P_SCMOD  IN NUMBER,
                                  P_PROEST IN VARCHAR,
                                  P_PROMSG IN VARCHAR) AS
  BEGIN
    UPDATE AQPB542
       SET AQPB542PROEST = P_PROEST, AQPB542PROMSG = P_PROMSG
     WHERE AQPB542CODIGO = P_CARCOD
       AND AQPB542NROREG = P_NROREG
       AND AQPB542PGCOD = P_PGCOD
       AND AQPB542SCSUC = P_SCSUC
       AND AQPB542SCRUB = P_SCRUB
       AND AQPB542SCMDA = P_SCMDA
       AND AQPB542SCPAP = P_SCPAP
       AND AQPB542SCCTA = P_SCCTA
       AND AQPB542SCOPER = P_SCOPER
       AND AQPB542SCSBOP = P_SCSBOP
       AND AQPB542SCTOPE = P_SCTOPE
       AND AQPB542SCMOD = P_SCMOD;
    ---***
    COMMIT;
    ---***
  END SP_AH_LOG_CTA_AQPB542;

END PQ_AH_CTA_SUPLANTADA;
/

