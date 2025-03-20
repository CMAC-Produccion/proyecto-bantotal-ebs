CREATE OR REPLACE PROCEDURE SP_AH_LOG_PROC_TRANSF(P_ERRCOD OUT VARCHAR,
                                                  P_ERRMSG OUT VARCHAR) IS

  ln_ITSUC  NUMBER(3, 0);
  ln_ITMOD  NUMBER(3, 0);
  ln_ITTRAN NUMBER(3, 0);
  ln_ITNREL NUMBER(4, 0);
  ln_ITORD  NUMBER(2, 0);
  ---***
  ld_AQPB540FECHA  DATE;
  lv_AQPB540HORA   VARCHAR(8);
  lv_AQPB540CANAL  VARCHAR(30);
  lv_AQPB540TERMI  VARCHAR(30);
  lv_AQPB540TARJ   VARCHAR(20);
  lv_AQPB540ORICTA VARCHAR(30);
  ln_AQPB540ORIPAI NUMBER(3);
  ln_AQPB540ORITDO NUMBER(2);
  lv_AQPB540ORINDO VARCHAR(12);
  lv_AQPB540ORINOM VARCHAR(120);
  lv_AQPB540DESCTA VARCHAR(30);
  ln_AQPB540DESPAI NUMBER(3);
  ln_AQPB540DESTDO NUMBER(2);
  lv_AQPB540DESNDO VARCHAR(12);
  ln_AQPB540TRAMON NUMBER(18, 2);
  lv_AQPB540TRAEST VARCHAR(1);
  lv_AQPB540MOTEST VARCHAR(30);
  ---***
  ln_DESTMODULO NUMBER(3);
  ln_DESTCTA    NUMBER(9);
  ln_DESTMONEDA NUMBER(4);
  ln_DESTPAPEL  NUMBER(4);
  ln_DESTSUBO   NUMBER(3);
  ln_DESTITOPER NUMBER(9);
  ln_DESTITTOPE NUMBER(3);

  ln_ORGORD NUMBER(17, 2);
  ln_DESORD NUMBER(17, 2);
  ln_TDV    NUMBER(17, 2);
  lv_TDV    VARCHAR(65);

  lv_ITUING VARCHAR(10);
  lv_ITWING VARCHAR(10);
  ---***
  lv_ERRMSG VARCHAR(600);
  ---***
BEGIN

  FOR XROW IN (SELECT *
                 FROM AQPB539
                WHERE AQPB539PROEST = 'N'
                ORDER BY AQPB539CRETIM,
                         AQPB539CREUSU,
                         AQPB539ITSUC,
                         AQPB539ITMOD,
                         AQPB539ITTRAN,
                         AQPB539ITNREL,
                         AQPB539ITORD) LOOP
  
    ---***
    ld_AQPB540FECHA  := NULL;
    lv_AQPB540HORA   := NULL;
    lv_AQPB540CANAL  := NULL;
    lv_AQPB540TERMI  := NULL;
    lv_AQPB540TARJ   := NULL;
    lv_AQPB540ORICTA := NULL;
    ln_AQPB540ORIPAI := NULL;
    ln_AQPB540ORITDO := NULL;
    lv_AQPB540ORINDO := NULL;
    lv_AQPB540ORINOM := NULL;
    lv_AQPB540DESCTA := NULL;
    ln_AQPB540DESPAI := NULL;
    ln_AQPB540DESTDO := NULL;
    lv_AQPB540DESNDO := NULL;
    ln_AQPB540TRAMON := NULL;
    lv_AQPB540TRAEST := NULL;
    lv_AQPB540MOTEST := NULL;
    ---***
    ln_ORGORD := 0;
    ln_DESORD := 0;
    ln_TDV    := 0;
    lv_TDV    := NULL;
    lv_ITUING := NULL;
    lv_ITWING := NULL;
    ---***
    -- Ordinal Origen (Si no esta en la GUIA se salta al sgte registro)
    -- Ordinal Destino
    BEGIN
      SELECT TP1IMP1, TP1IMP2, TP1IMP3
        INTO ln_ORGORD, ln_DESORD, ln_TDV
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11146
         AND TP1CORR1 = 1
         AND TP1CORR2 = 60
         AND TP1NRO1 = XROW.AQPB539ITMOD
         AND TP1NRO2 = XROW.AQPB539ITTRAN
         AND TP1NRO3 = 1
         AND TP1IMP1 = XROW.AQPB539ITORD;
    exception
      when others then
        CONTINUE;
    END;
  
    --- TRX 50/599 Transferencias entre CTAs de CAQP
    IF (XROW.AQPB539ITMOD = 50 AND XROW.AQPB539ITTRAN = 599 AND
       XROW.AQPB539ITORD = ln_ORGORD) THEN
      --dbms_output.put_line('TRX 50/599');
      lv_AQPB540CANAL := 'VENTANILLA';
    
      ---***
      UPDATE AQPB539
         SET AQPB539PROEST = 'P'
       WHERE AQPB539PGCOD = XROW.AQPB539PGCOD
         AND AQPB539ITSUC = XROW.AQPB539ITSUC
         AND AQPB539ITMOD = XROW.AQPB539ITMOD
         AND AQPB539ITTRAN = XROW.AQPB539ITTRAN
         AND AQPB539ITNREL = XROW.AQPB539ITNREL
         AND AQPB539CREUSU = XROW.AQPB539CREUSU
         AND TRUNC(AQPB539CRETIM) = TRUNC(XROW.AQPB539CRETIM);
      ---***
      COMMIT;
      ---***
    
      BEGIN
        SELECT ITFCON,
               TRIM(ITHORA),
               TRIM(ITCONT),
               TRIM(ITUING),
               TRIM(ITWING)
          INTO ld_AQPB540FECHA,
               lv_AQPB540HORA,
               lv_AQPB540TRAEST,
               lv_ITUING,
               lv_ITWING
          FROM FSD015
         WHERE PGCOD = XROW.AQPB539PGCOD
           AND ITSUC = XROW.AQPB539ITSUC
           AND ITMOD = XROW.AQPB539ITMOD
           AND ITTRAN = XROW.AQPB539ITTRAN
           AND ITNREL = XROW.AQPB539ITNREL
           AND ROWNUM = 1;
      exception
        when others then
          lv_ERRMSG := 'ERR_FSD015(' || sqlcode || ') -> ' || sqlerrm;
          UPDATE AQPB539
             SET AQPB539PROERR = lv_ERRMSG
           WHERE AQPB539PGCOD = XROW.AQPB539PGCOD
             AND AQPB539ITSUC = XROW.AQPB539ITSUC
             AND AQPB539ITMOD = XROW.AQPB539ITMOD
             AND AQPB539ITTRAN = XROW.AQPB539ITTRAN
             AND AQPB539ITNREL = XROW.AQPB539ITNREL
             AND AQPB539CREUSU = XROW.AQPB539CREUSU
             AND TRUNC(AQPB539CRETIM) = TRUNC(XROW.AQPB539CRETIM);
          ---***
          COMMIT;
          ---***
          CONTINUE;
          ---***
      END;
    
      ---*** DESTINO
      BEGIN
        SELECT AQPB539MODULO,
               AQPB539CTNRO,
               AQPB539MONEDA,
               AQPB539ITSUBO,
               AQPB539ITOPER,
               AQPB539ITTOPE
          INTO ln_DESTMODULO,
               ln_DESTCTA,
               ln_DESTMONEDA,
               ln_DESTSUBO,
               ln_DESTITOPER,
               ln_DESTITTOPE
          FROM AQPB539
         WHERE AQPB539PGCOD = XROW.AQPB539PGCOD
           AND AQPB539ITSUC = XROW.AQPB539ITSUC
           AND AQPB539ITMOD = XROW.AQPB539ITMOD
           AND AQPB539ITTRAN = XROW.AQPB539ITTRAN
           AND AQPB539ITNREL = XROW.AQPB539ITNREL
           AND AQPB539ITORD = ln_DESORD
           AND AQPB539CREUSU = XROW.AQPB539CREUSU
           AND TRUNC(AQPB539CRETIM) = TRUNC(XROW.AQPB539CRETIM);
      exception
        when others then
          lv_ERRMSG := 'ERR_AQPB539(' || sqlcode || ') -> ' || sqlerrm;
          UPDATE AQPB539
             SET AQPB539PROERR = lv_ERRMSG
           WHERE AQPB539PGCOD = XROW.AQPB539PGCOD
             AND AQPB539ITSUC = XROW.AQPB539ITSUC
             AND AQPB539ITMOD = XROW.AQPB539ITMOD
             AND AQPB539ITTRAN = XROW.AQPB539ITTRAN
             AND AQPB539ITNREL = XROW.AQPB539ITNREL
             AND AQPB539CREUSU = XROW.AQPB539CREUSU
             AND TRUNC(AQPB539CRETIM) = TRUNC(XROW.AQPB539CRETIM);
          ---***
          COMMIT;
          ---***
          CONTINUE;
          ---***
      END;
      ---***
      BEGIN
        SELECT PEPAIS, PETDOC, PENDOC
          INTO ln_AQPB540DESPAI, ln_AQPB540DESTDO, lv_AQPB540DESNDO
          FROM FSR008
         WHERE PGCOD = 1
           AND CTNRO = ln_DESTCTA
           AND CTTFIR = 'T'
           AND ROWNUM = 1;
      exception
        when others then
          lv_ERRMSG := 'ERR_FSR008_DES(' || sqlcode || ') -> ' || sqlerrm;
          UPDATE AQPB539
             SET AQPB539PROERR = lv_ERRMSG
           WHERE AQPB539PGCOD = XROW.AQPB539PGCOD
             AND AQPB539ITSUC = XROW.AQPB539ITSUC
             AND AQPB539ITMOD = XROW.AQPB539ITMOD
             AND AQPB539ITTRAN = XROW.AQPB539ITTRAN
             AND AQPB539ITNREL = XROW.AQPB539ITNREL
             AND AQPB539CREUSU = XROW.AQPB539CREUSU
             AND TRUNC(AQPB539CRETIM) = TRUNC(XROW.AQPB539CRETIM);
          ---***
          COMMIT;
          ---***
          CONTINUE;
          ---***
      END;
      ---***
      ---***
      CASE
        WHEN ln_DESTMODULO = 21 THEN
          lv_AQPB540DESCTA := lpad(ln_DESTCTA, 9, '0') ||
                              lpad(ln_DESTMODULO, 3, '0') ||
                              lpad(ln_DESTMONEDA, 3, '0') ||
                              lpad(ln_DESTSUBO, 2, '0') ||
                              lpad(ln_DESTITTOPE, 3, '0');
        WHEN ln_DESTMODULO = 22 THEN
          lv_AQPB540DESCTA := lpad(ln_DESTCTA, 9, '0') ||
                              lpad(ln_DESTMODULO, 3, '0') ||
                              lpad(ln_DESTMONEDA, 3, '0') ||
                              lpad(ln_DESTITOPER, 9, '0') ||
                              lpad(ln_DESTITTOPE, 3, '0');
        ELSE
          lv_AQPB540DESCTA := lpad(ln_DESTCTA, 9, '0') ||
                              lpad(ln_DESTMONEDA, 3, '0') ||
                              lpad(ln_DESTITOPER, 9, '0');
      END CASE;
    
      ---***
      BEGIN
        SELECT PEPAIS, PETDOC, PENDOC
          INTO ln_AQPB540ORIPAI, ln_AQPB540ORITDO, lv_AQPB540ORINDO
          FROM FSR008
         WHERE PGCOD = 1
           AND CTNRO = XROW.AQPB539CTNRO
           AND CTTFIR = 'T'
           AND ROWNUM = 1;
      exception
        when others then
          lv_ERRMSG := 'ERR_FSR008_ORI(' || sqlcode || ') -> ' || sqlerrm;
          UPDATE AQPB539
             SET AQPB539PROERR = lv_ERRMSG
           WHERE AQPB539PGCOD = XROW.AQPB539PGCOD
             AND AQPB539ITSUC = XROW.AQPB539ITSUC
             AND AQPB539ITMOD = XROW.AQPB539ITMOD
             AND AQPB539ITTRAN = XROW.AQPB539ITTRAN
             AND AQPB539ITNREL = XROW.AQPB539ITNREL
             AND AQPB539CREUSU = XROW.AQPB539CREUSU
             AND TRUNC(AQPB539CRETIM) = TRUNC(XROW.AQPB539CRETIM);
          ---***
          COMMIT;
          ---***
          CONTINUE;
          ---***
      END;
      ---***
      BEGIN
        SELECT TRIM(PENOM)
          INTO lv_AQPB540ORINOM
          FROM FSD001
         WHERE PEPAIS = ln_AQPB540ORIPAI
           AND PETDOC = ln_AQPB540ORITDO
           AND PENDOC = lv_AQPB540ORINDO;
      exception
        when others then
          lv_AQPB540ORINOM := '-';
      END;
      ---***
    
      CASE
        WHEN XROW.AQPB539MODULO = 21 THEN
          lv_AQPB540ORICTA := lpad(XROW.AQPB539CTNRO, 9, '0') ||
                              lpad(XROW.AQPB539MODULO, 3, '0') ||
                              lpad(XROW.AQPB539MONEDA, 3, '0') ||
                              lpad(XROW.AQPB539ITSUBO, 2, '0') ||
                              lpad(XROW.AQPB539ITTOPE, 3, '0');
        WHEN XROW.AQPB539MODULO = 22 THEN
          lv_AQPB540ORICTA := lpad(XROW.AQPB539CTNRO, 9, '0') ||
                              lpad(XROW.AQPB539MODULO, 3, '0') ||
                              lpad(XROW.AQPB539MONEDA, 3, '0') ||
                              lpad(XROW.AQPB539ITOPER, 9, '0') ||
                              lpad(XROW.AQPB539ITTOPE, 3, '0');
        ELSE
          lv_AQPB540ORICTA := lpad(XROW.AQPB539CTNRO, 9, '0') ||
                              lpad(XROW.AQPB539MONEDA, 3, '0') ||
                              lpad(XROW.AQPB539ITOPER, 9, '0');
      END CASE;
      ---***
      ln_AQPB540TRAMON := XROW.AQPB539ITIMP1;
      ---***
      lv_AQPB540TERMI := TRIM(lv_ITUING) || '_' || TRIM(lv_ITWING);
      ---*** TDV
      IF (ln_TDV = 1) THEN
        BEGIN
          SELECT TRIM(TXTORD)
            INTO lv_TDV
            FROM FSX016
           WHERE PGCOD = XROW.AQPB539PGCOD
             AND HFCON = XROW.AQPB539ITFVAL
             AND HSUCOR = XROW.AQPB539ITSUC
             AND HCMOD = XROW.AQPB539ITMOD
             AND HTRAN = XROW.AQPB539ITTRAN
             AND HNREL = XROW.AQPB539ITNREL
             AND TXCOD = 601;
          ---***
          lv_AQPB540TARJ := TRIM(lv_TDV);
          ---***
        exception
          when others then
            lv_AQPB540TARJ := '-';
        END;
      END IF;
      ---***
      INSERT INTO AQPB540
        (AQPB540CRETIM,
         AQPB540CREUSU,
         AQPB540PGCOD,
         AQPB540ITSUC,
         AQPB540ITMOD,
         AQPB540ITTRAN,
         AQPB540ITNREL,
         AQPB540FECHA,
         AQPB540HORA,
         AQPB540CANAL,
         AQPB540TERMI,
         AQPB540TARJ,
         AQPB540ORICTA,
         AQPB540ORIPAI,
         AQPB540ORITDO,
         AQPB540ORINDO,
         AQPB540ORINOM,
         AQPB540DESCTA,
         AQPB540DESPAI,
         AQPB540DESTDO,
         AQPB540DESNDO,
         AQPB540TRAMON,
         AQPB540TRAEST,
         AQPB540MOTEST)
      VALUES
        (SYSDATE,
         XROW.AQPB539CREUSU,
         XROW.AQPB539PGCOD,
         XROW.AQPB539ITSUC,
         XROW.AQPB539ITMOD,
         XROW.AQPB539ITTRAN,
         XROW.AQPB539ITNREL,
         ld_AQPB540FECHA,
         lv_AQPB540HORA,
         lv_AQPB540CANAL,
         lv_AQPB540TERMI,
         lv_AQPB540TARJ,
         lv_AQPB540ORICTA,
         ln_AQPB540ORIPAI,
         ln_AQPB540ORITDO,
         lv_AQPB540ORINDO,
         lv_AQPB540ORINOM,
         lv_AQPB540DESCTA,
         ln_AQPB540DESPAI,
         ln_AQPB540DESTDO,
         lv_AQPB540DESNDO,
         ln_AQPB540TRAMON,
         lv_AQPB540TRAEST,
         lv_AQPB540MOTEST);
      ---***
      COMMIT;
      ---***
    
    END IF;
  
    --- TRX 18/25 Transferencias Diferidas (25 Otro Titular, 30 Mismo Titular)
    IF (XROW.AQPB539ITMOD = 18 AND XROW.AQPB539ITTRAN IN (25, 30) AND
       XROW.AQPB539ITORD = ln_ORGORD) THEN
      --dbms_output.put_line('TRX 18/25');
      lv_AQPB540CANAL := 'VENTANILLA';
    
      ---***
      UPDATE AQPB539
         SET AQPB539PROEST = 'P'
       WHERE AQPB539PGCOD = XROW.AQPB539PGCOD
         AND AQPB539ITSUC = XROW.AQPB539ITSUC
         AND AQPB539ITMOD = XROW.AQPB539ITMOD
         AND AQPB539ITTRAN = XROW.AQPB539ITTRAN
         AND AQPB539ITNREL = XROW.AQPB539ITNREL
         AND AQPB539CREUSU = XROW.AQPB539CREUSU
         AND TRUNC(AQPB539CRETIM) = TRUNC(XROW.AQPB539CRETIM);
      ---***
      COMMIT;
      ---***
    
      BEGIN
        SELECT ITFCON,
               TRIM(ITHORA),
               TRIM(ITCONT),
               TRIM(ITUING),
               TRIM(ITWING)
          INTO ld_AQPB540FECHA,
               lv_AQPB540HORA,
               lv_AQPB540TRAEST,
               lv_ITUING,
               lv_ITWING
          FROM FSD015
         WHERE PGCOD = XROW.AQPB539PGCOD
           AND ITSUC = XROW.AQPB539ITSUC
           AND ITMOD = XROW.AQPB539ITMOD
           AND ITTRAN = XROW.AQPB539ITTRAN
           AND ITNREL = XROW.AQPB539ITNREL
           AND ROWNUM = 1;
      exception
        when others then
          lv_ERRMSG := 'ERR_FSD015(' || sqlcode || ') -> ' || sqlerrm;
          UPDATE AQPB539
             SET AQPB539PROERR = lv_ERRMSG
           WHERE AQPB539PGCOD = XROW.AQPB539PGCOD
             AND AQPB539ITSUC = XROW.AQPB539ITSUC
             AND AQPB539ITMOD = XROW.AQPB539ITMOD
             AND AQPB539ITTRAN = XROW.AQPB539ITTRAN
             AND AQPB539ITNREL = XROW.AQPB539ITNREL
             AND AQPB539CREUSU = XROW.AQPB539CREUSU
             AND TRUNC(AQPB539CRETIM) = TRUNC(XROW.AQPB539CRETIM);
          ---***
          COMMIT;
          ---***
          CONTINUE;
          ---***
      END;
      ---*** DESTINO
      BEGIN
        SELECT SE115PABEN, SE115TDBEN, TRIM(SE115NDBEN), TRIM(SE115CCIDS)
          INTO ln_AQPB540DESPAI,
               ln_AQPB540DESTDO,
               lv_AQPB540DESNDO,
               lv_AQPB540DESCTA
          FROM FSE115
         WHERE SE115CD = XROW.AQPB539PGCOD
           AND SE115SU = XROW.AQPB539ITSUC
           AND SE115MD = XROW.AQPB539ITMOD
           AND SE115TR = XROW.AQPB539ITTRAN
           AND SE115RE = XROW.AQPB539ITNREL
           AND SE115FC = XROW.AQPB539ITFVAL;
      exception
        when others then
          lv_ERRMSG := 'ERR_FSE115(' || sqlcode || ') -> ' || sqlerrm;
          UPDATE AQPB539
             SET AQPB539PROERR = lv_ERRMSG
           WHERE AQPB539PGCOD = XROW.AQPB539PGCOD
             AND AQPB539ITSUC = XROW.AQPB539ITSUC
             AND AQPB539ITMOD = XROW.AQPB539ITMOD
             AND AQPB539ITTRAN = XROW.AQPB539ITTRAN
             AND AQPB539ITNREL = XROW.AQPB539ITNREL
             AND AQPB539CREUSU = XROW.AQPB539CREUSU
             AND TRUNC(AQPB539CRETIM) = TRUNC(XROW.AQPB539CRETIM);
          ---***
          COMMIT;
          ---***
          CONTINUE;
          ---***
      END;
      ---***
      ---*** CTA Origen
      CASE
        WHEN XROW.AQPB539MODULO = 21 THEN
          lv_AQPB540ORICTA := lpad(XROW.AQPB539CTNRO, 9, '0') ||
                              lpad(XROW.AQPB539MODULO, 3, '0') ||
                              lpad(XROW.AQPB539MONEDA, 3, '0') ||
                              lpad(XROW.AQPB539ITSUBO, 2, '0') ||
                              lpad(XROW.AQPB539ITTOPE, 3, '0');
        WHEN XROW.AQPB539MODULO = 22 THEN
          lv_AQPB540ORICTA := lpad(XROW.AQPB539CTNRO, 9, '0') ||
                              lpad(XROW.AQPB539MODULO, 3, '0') ||
                              lpad(XROW.AQPB539MONEDA, 3, '0') ||
                              lpad(XROW.AQPB539ITOPER, 9, '0') ||
                              lpad(XROW.AQPB539ITTOPE, 3, '0');
        ELSE
          lv_AQPB540ORICTA := lpad(XROW.AQPB539CTNRO, 9, '0') ||
                              lpad(XROW.AQPB539MONEDA, 3, '0') ||
                              lpad(XROW.AQPB539ITOPER, 9, '0');
        
      END CASE;
      ---***
      BEGIN
        SELECT PEPAIS, PETDOC, PENDOC
          INTO ln_AQPB540ORIPAI, ln_AQPB540ORITDO, lv_AQPB540ORINDO
          FROM FSR008
         WHERE PGCOD = 1
           AND CTNRO = XROW.AQPB539CTNRO
           AND CTTFIR = 'T'
           AND ROWNUM = 1;
      exception
        when others then
          lv_ERRMSG := 'ERR_FSR008_ORI(' || sqlcode || ') -> ' || sqlerrm;
          UPDATE AQPB539
             SET AQPB539PROERR = lv_ERRMSG
           WHERE AQPB539PGCOD = XROW.AQPB539PGCOD
             AND AQPB539ITSUC = XROW.AQPB539ITSUC
             AND AQPB539ITMOD = XROW.AQPB539ITMOD
             AND AQPB539ITTRAN = XROW.AQPB539ITTRAN
             AND AQPB539ITNREL = XROW.AQPB539ITNREL
             AND AQPB539CREUSU = XROW.AQPB539CREUSU
             AND TRUNC(AQPB539CRETIM) = TRUNC(XROW.AQPB539CRETIM);
          ---***
          COMMIT;
          ---***
          CONTINUE;
          ---***
      END;
      ---***
      BEGIN
        SELECT TRIM(PENOM)
          INTO lv_AQPB540ORINOM
          FROM FSD001
         WHERE PEPAIS = ln_AQPB540ORIPAI
           AND PETDOC = ln_AQPB540ORITDO
           AND PENDOC = lv_AQPB540ORINDO;
      exception
        when others then
          lv_AQPB540ORINOM := '-';
      END;
      ---***
      ln_AQPB540TRAMON := XROW.AQPB539ITIMP1;
      ---***
      lv_AQPB540TERMI := TRIM(lv_ITUING) || '_' || TRIM(lv_ITWING);
      ---*** TDV
      IF (ln_TDV = 1) THEN
        BEGIN
          SELECT TRIM(TXTORD)
            INTO lv_TDV
            FROM FSX016
           WHERE PGCOD = XROW.AQPB539PGCOD
             AND HFCON = XROW.AQPB539ITFVAL
             AND HSUCOR = XROW.AQPB539ITSUC
             AND HCMOD = XROW.AQPB539ITMOD
             AND HTRAN = XROW.AQPB539ITTRAN
             AND HNREL = XROW.AQPB539ITNREL
             AND TXCOD = 601;
          ---***
          lv_AQPB540TARJ := TRIM(lv_TDV);
          ---***
        exception
          when others then
            lv_AQPB540TARJ := '-';
        END;
      END IF;
      ---***
      INSERT INTO AQPB540
        (AQPB540CRETIM,
         AQPB540CREUSU,
         AQPB540PGCOD,
         AQPB540ITSUC,
         AQPB540ITMOD,
         AQPB540ITTRAN,
         AQPB540ITNREL,
         AQPB540FECHA,
         AQPB540HORA,
         AQPB540CANAL,
         AQPB540TERMI,
         AQPB540TARJ,
         AQPB540ORICTA,
         AQPB540ORIPAI,
         AQPB540ORITDO,
         AQPB540ORINDO,
         AQPB540ORINOM,
         AQPB540DESCTA,
         AQPB540DESPAI,
         AQPB540DESTDO,
         AQPB540DESNDO,
         AQPB540TRAMON,
         AQPB540TRAEST,
         AQPB540MOTEST)
      VALUES
        (SYSDATE,
         XROW.AQPB539CREUSU,
         XROW.AQPB539PGCOD,
         XROW.AQPB539ITSUC,
         XROW.AQPB539ITMOD,
         XROW.AQPB539ITTRAN,
         XROW.AQPB539ITNREL,
         ld_AQPB540FECHA,
         lv_AQPB540HORA,
         lv_AQPB540CANAL,
         lv_AQPB540TERMI,
         lv_AQPB540TARJ,
         lv_AQPB540ORICTA,
         ln_AQPB540ORIPAI,
         ln_AQPB540ORITDO,
         lv_AQPB540ORINDO,
         lv_AQPB540ORINOM,
         lv_AQPB540DESCTA,
         ln_AQPB540DESPAI,
         ln_AQPB540DESTDO,
         lv_AQPB540DESNDO,
         ln_AQPB540TRAMON,
         lv_AQPB540TRAEST,
         lv_AQPB540MOTEST);
      ---***
      COMMIT;
      ---***
    END IF;
  
    --- TRX 18/125 Transferencias en Linea
    IF (XROW.AQPB539ITMOD = 18 AND XROW.AQPB539ITTRAN = 125 AND
       XROW.AQPB539ITORD = ln_ORGORD) THEN
      --dbms_output.put_line('TRX 18/125');
      lv_AQPB540CANAL := 'VENTANILLA';
    
      ---***
      UPDATE AQPB539
         SET AQPB539PROEST = 'P'
       WHERE AQPB539PGCOD = XROW.AQPB539PGCOD
         AND AQPB539ITSUC = XROW.AQPB539ITSUC
         AND AQPB539ITMOD = XROW.AQPB539ITMOD
         AND AQPB539ITTRAN = XROW.AQPB539ITTRAN
         AND AQPB539ITNREL = XROW.AQPB539ITNREL
         AND AQPB539CREUSU = XROW.AQPB539CREUSU
         AND TRUNC(AQPB539CRETIM) = TRUNC(XROW.AQPB539CRETIM);
      ---***
      COMMIT;
      ---***
      BEGIN
        SELECT ITFCON,
               TRIM(ITHORA),
               TRIM(ITCONT),
               TRIM(ITUING),
               TRIM(ITWING)
          INTO ld_AQPB540FECHA,
               lv_AQPB540HORA,
               lv_AQPB540TRAEST,
               lv_ITUING,
               lv_ITWING
          FROM FSD015
         WHERE PGCOD = XROW.AQPB539PGCOD
           AND ITSUC = XROW.AQPB539ITSUC
           AND ITMOD = XROW.AQPB539ITMOD
           AND ITTRAN = XROW.AQPB539ITTRAN
           AND ITNREL = XROW.AQPB539ITNREL
           AND ROWNUM = 1;
      exception
        when others then
          lv_ERRMSG := 'ERR_FSD015(' || sqlcode || ') -> ' || sqlerrm;
          UPDATE AQPB539
             SET AQPB539PROERR = lv_ERRMSG
           WHERE AQPB539PGCOD = XROW.AQPB539PGCOD
             AND AQPB539ITSUC = XROW.AQPB539ITSUC
             AND AQPB539ITMOD = XROW.AQPB539ITMOD
             AND AQPB539ITTRAN = XROW.AQPB539ITTRAN
             AND AQPB539ITNREL = XROW.AQPB539ITNREL
             AND AQPB539CREUSU = XROW.AQPB539CREUSU
             AND TRUNC(AQPB539CRETIM) = TRUNC(XROW.AQPB539CRETIM);
          ---***
          COMMIT;
          ---***
          CONTINUE;
          ---***
      END;
      ---*** DESTINO
      BEGIN
        SELECT JAQL706PABE,
               JAQL706TDBE,
               TRIM(JAQL706NDBE),
               TRIM(JAQL706CCID)
          INTO ln_AQPB540DESPAI,
               ln_AQPB540DESTDO,
               lv_AQPB540DESNDO,
               lv_AQPB540DESCTA
          FROM JAQL706
         WHERE JAQL706ITCD = XROW.AQPB539PGCOD
           AND JAQL706ITFC = XROW.AQPB539ITFVAL
           AND JAQL706ITSU = XROW.AQPB539ITSUC
           AND JAQL706ITMO = XROW.AQPB539ITMOD
           AND JAQL706ITTR = XROW.AQPB539ITTRAN
           AND JAQL706ITRE = XROW.AQPB539ITNREL
           AND JAQL706PGCO = XROW.AQPB539PGCOD
           AND JAQL706SCCT = XROW.AQPB539CTNRO
           AND ROWNUM = 1;
      exception
        when others then
          lv_ERRMSG := 'ERR_JAQL706(' || sqlcode || ') -> ' || sqlerrm;
          UPDATE AQPB539
             SET AQPB539PROERR = lv_ERRMSG
           WHERE AQPB539PGCOD = XROW.AQPB539PGCOD
             AND AQPB539ITSUC = XROW.AQPB539ITSUC
             AND AQPB539ITMOD = XROW.AQPB539ITMOD
             AND AQPB539ITTRAN = XROW.AQPB539ITTRAN
             AND AQPB539ITNREL = XROW.AQPB539ITNREL
             AND AQPB539CREUSU = XROW.AQPB539CREUSU
             AND TRUNC(AQPB539CRETIM) = TRUNC(XROW.AQPB539CRETIM);
          ---***
          COMMIT;
          ---***
          CONTINUE;
          ---***
      END;
      ---***
      ---*** CTA Origen
      CASE
        WHEN XROW.AQPB539MODULO = 21 THEN
          lv_AQPB540ORICTA := lpad(XROW.AQPB539CTNRO, 9, '0') ||
                              lpad(XROW.AQPB539MODULO, 3, '0') ||
                              lpad(XROW.AQPB539MONEDA, 3, '0') ||
                              lpad(XROW.AQPB539ITSUBO, 2, '0') ||
                              lpad(XROW.AQPB539ITTOPE, 3, '0');
        WHEN XROW.AQPB539MODULO = 22 THEN
          lv_AQPB540ORICTA := lpad(XROW.AQPB539CTNRO, 9, '0') ||
                              lpad(XROW.AQPB539MODULO, 3, '0') ||
                              lpad(XROW.AQPB539MONEDA, 3, '0') ||
                              lpad(XROW.AQPB539ITOPER, 9, '0') ||
                              lpad(XROW.AQPB539ITTOPE, 3, '0');
        ELSE
          lv_AQPB540ORICTA := lpad(XROW.AQPB539CTNRO, 9, '0') ||
                              lpad(XROW.AQPB539MONEDA, 3, '0') ||
                              lpad(XROW.AQPB539ITOPER, 9, '0');
      END CASE;
      ---***
      BEGIN
        SELECT PEPAIS, PETDOC, PENDOC
          INTO ln_AQPB540ORIPAI, ln_AQPB540ORITDO, lv_AQPB540ORINDO
          FROM FSR008
         WHERE PGCOD = 1
           AND CTNRO = XROW.AQPB539CTNRO
           AND CTTFIR = 'T'
           AND ROWNUM = 1;
      exception
        when others then
          lv_ERRMSG := 'ERR_FSR008_ORI(' || sqlcode || ') -> ' || sqlerrm;
          UPDATE AQPB539
             SET AQPB539PROERR = lv_ERRMSG
           WHERE AQPB539PGCOD = XROW.AQPB539PGCOD
             AND AQPB539ITSUC = XROW.AQPB539ITSUC
             AND AQPB539ITMOD = XROW.AQPB539ITMOD
             AND AQPB539ITTRAN = XROW.AQPB539ITTRAN
             AND AQPB539ITNREL = XROW.AQPB539ITNREL
             AND AQPB539CREUSU = XROW.AQPB539CREUSU
             AND TRUNC(AQPB539CRETIM) = TRUNC(XROW.AQPB539CRETIM);
          ---***
          COMMIT;
          ---***
          CONTINUE;
          ---***
      END;
      ---***
      BEGIN
        SELECT TRIM(PENOM)
          INTO lv_AQPB540ORINOM
          FROM FSD001
         WHERE PEPAIS = ln_AQPB540ORIPAI
           AND PETDOC = ln_AQPB540ORITDO
           AND PENDOC = lv_AQPB540ORINDO;
      exception
        when others then
          lv_AQPB540ORINOM := '-';
      END;
      ---***
      ln_AQPB540TRAMON := XROW.AQPB539ITIMP1;
      ---***
      lv_AQPB540TERMI := TRIM(lv_ITUING) || '_' || TRIM(lv_ITWING);
      ---*** TDV
      IF (ln_TDV = 1) THEN
        BEGIN
          SELECT TRIM(TXTORD)
            INTO lv_TDV
            FROM FSX016
           WHERE PGCOD = XROW.AQPB539PGCOD
             AND HFCON = XROW.AQPB539ITFVAL
             AND HSUCOR = XROW.AQPB539ITSUC
             AND HCMOD = XROW.AQPB539ITMOD
             AND HTRAN = XROW.AQPB539ITTRAN
             AND HNREL = XROW.AQPB539ITNREL
             AND TXCOD = 601;
          ---***
          lv_AQPB540TARJ := TRIM(lv_TDV);
          ---***
        exception
          when others then
            lv_AQPB540TARJ := '-';
        END;
      END IF;
      ---***
      INSERT INTO AQPB540
        (AQPB540CRETIM,
         AQPB540CREUSU,
         AQPB540PGCOD,
         AQPB540ITSUC,
         AQPB540ITMOD,
         AQPB540ITTRAN,
         AQPB540ITNREL,
         AQPB540FECHA,
         AQPB540HORA,
         AQPB540CANAL,
         AQPB540TERMI,
         AQPB540TARJ,
         AQPB540ORICTA,
         AQPB540ORIPAI,
         AQPB540ORITDO,
         AQPB540ORINDO,
         AQPB540ORINOM,
         AQPB540DESCTA,
         AQPB540DESPAI,
         AQPB540DESTDO,
         AQPB540DESNDO,
         AQPB540TRAMON,
         AQPB540TRAEST,
         AQPB540MOTEST)
      VALUES
        (SYSDATE,
         XROW.AQPB539CREUSU,
         XROW.AQPB539PGCOD,
         XROW.AQPB539ITSUC,
         XROW.AQPB539ITMOD,
         XROW.AQPB539ITTRAN,
         XROW.AQPB539ITNREL,
         ld_AQPB540FECHA,
         lv_AQPB540HORA,
         lv_AQPB540CANAL,
         lv_AQPB540TERMI,
         lv_AQPB540TARJ,
         lv_AQPB540ORICTA,
         ln_AQPB540ORIPAI,
         ln_AQPB540ORITDO,
         lv_AQPB540ORINDO,
         lv_AQPB540ORINOM,
         lv_AQPB540DESCTA,
         ln_AQPB540DESPAI,
         ln_AQPB540DESTDO,
         lv_AQPB540DESNDO,
         ln_AQPB540TRAMON,
         lv_AQPB540TRAEST,
         lv_AQPB540MOTEST);
      ---***
      COMMIT;
      ---***
    END IF;
  END LOOP;

exception
  when others then
    P_ERRCOD := '001';
    P_ERRMSG := '(ERROR SP_AH_LOG_PROC_TRANSF)::(' || sqlcode || ') -> ' ||
                sqlerrm;
  
END SP_AH_LOG_PROC_TRANSF;
/

