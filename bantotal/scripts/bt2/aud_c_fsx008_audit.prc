CREATE OR REPLACE PROCEDURE AUD_C_FSX008_AUDIT AS
  cnt NUMBER;
BEGIN
  SELECT COUNT(*) INTO cnt FROM BANTPROD.AUD_FSX008_AUDIT;
  IF (cnt > 0) THEN
    INSERT INTO BANTPROD.AUD004
      (AUDMstTim,
       AUDMstId,
       AUDMstTbl,
       AUDMstKey,
       AUDMstTrn,
       AUDMstUsr,
       AUDMstWst,
       AUDMstPgm,
       AUDMstReq,
       AUDMstTyp,
       AUDMstCon,
       AUDMstApp,
       AUDMstSrv,
       AUDMstSes,
       AUDMstGrp,
       AUDMstLog,
       AUDMstCur,
       AUDMstSnt,
       AUDMstTic)
      SELECT AUD_FSX008_UOn,
             AUD_FSX008_GuidKey,
             'FSX008',
             CONCAT(CONCAT(CONCAT(CONCAT(CONCAT('|CTNRO=',
                                                RTRIM(COALESCE(AUD_old_CTNRO,
                                                               AUD_new_CTNRO))),
                                         CONCAT('|CTXREN=',
                                                RTRIM(COALESCE(AUD_old_CTXREN,
                                                               AUD_new_CTXREN)))),
                                  CONCAT('|PGCOD=',
                                         RTRIM(COALESCE(AUD_old_PGCOD,
                                                        AUD_new_PGCOD)))),
                           CONCAT('|TXCOD=',
                                  RTRIM(COALESCE(AUD_old_TXCOD, AUD_new_TXCOD)))),
                    '|'),
             AUD_FSX008_UBT,
             AUD_FSX008_UBU,
             AUD_FSX008_UBM,
             AUD_FSX008_UBP,
             AUD_FSX008_UBR,
             AUD_FSX008_UAs,
             AUD_FSX008_UBC,
             AUD_FSX008_UBA,
             AUD_FSX008_UBS,
             '',
             'BANTOTAL',
             '',
             '',
             '',
             AUD_FSX008_UT
        FROM BANTPROD.AUD_FSX008_AUDIT
       WHERE NOT EXISTS (SELECT *
                FROM BANTPROD.AUD004
               WHERE AUDMstTim = AUD_FSX008_UOn
                 AND AUDMstId = AUD_FSX008_GuidKey);
    INSERT INTO BANTPROD.AUD005
      SELECT AUD_FSX008_UOn,
             AUD_FSX008_GuidKey,
             'CTNRO',
             AUD_old_CTNRO,
             AUD_new_CTNRO
        FROM BANTPROD.AUD_FSX008_AUDIT
       WHERE NOT EXISTS (SELECT *
                FROM BANTPROD.AUD005
               WHERE AUDMstTim = AUD_FSX008_UOn
                 AND AUDMstId = AUD_FSX008_GuidKey
                 AND AUDMstFld = 'CTNRO');
    INSERT INTO BANTPROD.AUD005
      SELECT AUD_FSX008_UOn,
             AUD_FSX008_GuidKey,
             'CTXFCH',
             TO_CHAR(AUD_old_CTXFCH, 'YYYY-MM-DD'),
             TO_CHAR(AUD_new_CTXFCH, 'YYYY-MM-DD')
        FROM BANTPROD.AUD_FSX008_AUDIT
       WHERE NOT EXISTS (SELECT *
                FROM BANTPROD.AUD005
               WHERE AUDMstTim = AUD_FSX008_UOn
                 AND AUDMstId = AUD_FSX008_GuidKey
                 AND AUDMstFld = 'CTXFCH');
    INSERT INTO BANTPROD.AUD005
      SELECT AUD_FSX008_UOn,
             AUD_FSX008_GuidKey,
             'CTXREN',
             AUD_old_CTXREN,
             AUD_new_CTXREN
        FROM BANTPROD.AUD_FSX008_AUDIT
       WHERE NOT EXISTS (SELECT *
                FROM BANTPROD.AUD005
               WHERE AUDMstTim = AUD_FSX008_UOn
                 AND AUDMstId = AUD_FSX008_GuidKey
                 AND AUDMstFld = 'CTXREN');
    INSERT INTO BANTPROD.AUD005
      SELECT AUD_FSX008_UOn,
             AUD_FSX008_GuidKey,
             'CTXTXT',
             AUD_old_CTXTXT,
             AUD_new_CTXTXT
        FROM BANTPROD.AUD_FSX008_AUDIT
       WHERE NOT EXISTS (SELECT *
                FROM BANTPROD.AUD005
               WHERE AUDMstTim = AUD_FSX008_UOn
                 AND AUDMstId = AUD_FSX008_GuidKey
                 AND AUDMstFld = 'CTXTXT');
    INSERT INTO BANTPROD.AUD005
      SELECT AUD_FSX008_UOn,
             AUD_FSX008_GuidKey,
             'CTXUSU',
             AUD_old_CTXUSU,
             AUD_new_CTXUSU
        FROM BANTPROD.AUD_FSX008_AUDIT
       WHERE NOT EXISTS (SELECT *
                FROM BANTPROD.AUD005
               WHERE AUDMstTim = AUD_FSX008_UOn
                 AND AUDMstId = AUD_FSX008_GuidKey
                 AND AUDMstFld = 'CTXUSU');
    INSERT INTO BANTPROD.AUD005
      SELECT AUD_FSX008_UOn,
             AUD_FSX008_GuidKey,
             'PGCOD',
             AUD_old_PGCOD,
             AUD_new_PGCOD
        FROM BANTPROD.AUD_FSX008_AUDIT
       WHERE NOT EXISTS (SELECT *
                FROM BANTPROD.AUD005
               WHERE AUDMstTim = AUD_FSX008_UOn
                 AND AUDMstId = AUD_FSX008_GuidKey
                 AND AUDMstFld = 'PGCOD');
    INSERT INTO BANTPROD.AUD005
      SELECT AUD_FSX008_UOn,
             AUD_FSX008_GuidKey,
             'TXCOD',
             AUD_old_TXCOD,
             AUD_new_TXCOD
        FROM BANTPROD.AUD_FSX008_AUDIT
       WHERE NOT EXISTS (SELECT *
                FROM BANTPROD.AUD005
               WHERE AUDMstTim = AUD_FSX008_UOn
                 AND AUDMstId = AUD_FSX008_GuidKey
                 AND AUDMstFld = 'TXCOD');
    DELETE FROM AUD_FSX008_AUDIT
     WHERE EXISTS (SELECT *
              FROM BANTPROD.AUD004
             WHERE AUDMstTim = AUD_FSX008_UOn
               AND AUDMstId = AUD_FSX008_GuidKey);
    COMMIT;
  END IF;
END;
/

