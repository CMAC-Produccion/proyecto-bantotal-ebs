CREATE OR REPLACE PROCEDURE T_COPY_FST101_AUDIT AS
BEGIN
  INSERT INTO AUD004
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
    SELECT T_FST101_UpdatedOn,
           T_FST101_GuidKey,
           'FST101',
           CONCAT(CONCAT(CONCAT('|PBCOD=',
                                RTRIM(COALESCE(T_old_PBCOD, T_new_PBCOD))),
                         CONCAT('|PBNSEC=',
                                RTRIM(COALESCE(T_old_PBNSEC, T_new_PBNSEC)))),
                  '|'),
           T_FST101_UpdatedByTransaction,
           T_FST101_UpdatedByUser,
           T_FST101_UpdatedByMachine,
           T_FST101_UpdatedByProgram,
           T_FST101_UpdatedByRequest,
           T_FST101_UpdatedAs,
           T_FST101_UpdatedByConnection,
           T_FST101_UpdatedByApplication,
           T_FST101_UpdatedByServer,
           '',
           'TEST',
           '',
           '',
           '',
           T_FST101_UpdatedTime
      FROM T_FST101_Audit
     WHERE NOT EXISTS (SELECT *
              FROM AUD004
             WHERE AUDMstTim = T_FST101_UpdatedOn
               AND AUDMstId = T_FST101_GuidKey);
  INSERT INTO AUD005
    SELECT T_FST101_UpdatedOn,
           T_FST101_GuidKey,
           'PBCOD',
           T_old_PBCOD,
           T_new_PBCOD
      FROM T_FST101_Audit
     WHERE NOT EXISTS (SELECT *
              FROM AUD005
             WHERE AUDMstTim = T_FST101_UpdatedOn
               AND AUDMstId = T_FST101_GuidKey
               AND AUDMstFld = 'PBCOD');
  INSERT INTO AUD005
    SELECT T_FST101_UpdatedOn,
           T_FST101_GuidKey,
           'PBCPAR',
           T_old_PBCPAR,
           T_new_PBCPAR
      FROM T_FST101_Audit
     WHERE NOT EXISTS (SELECT *
              FROM AUD005
             WHERE AUDMstTim = T_FST101_UpdatedOn
               AND AUDMstId = T_FST101_GuidKey
               AND AUDMstFld = 'PBCPAR');
  INSERT INTO AUD005
    SELECT T_FST101_UpdatedOn,
           T_FST101_GuidKey,
           'PBDESC',
           T_old_PBDESC,
           T_new_PBDESC
      FROM T_FST101_Audit
     WHERE NOT EXISTS (SELECT *
              FROM AUD005
             WHERE AUDMstTim = T_FST101_UpdatedOn
               AND AUDMstId = T_FST101_GuidKey
               AND AUDMstFld = 'PBDESC');
  INSERT INTO AUD005
    SELECT T_FST101_UpdatedOn,
           T_FST101_GuidKey,
           'PBEJEC',
           T_old_PBEJEC,
           T_new_PBEJEC
      FROM T_FST101_Audit
     WHERE NOT EXISTS (SELECT *
              FROM AUD005
             WHERE AUDMstTim = T_FST101_UpdatedOn
               AND AUDMstId = T_FST101_GuidKey
               AND AUDMstFld = 'PBEJEC');
  INSERT INTO AUD005
    SELECT T_FST101_UpdatedOn,
           T_FST101_GuidKey,
           'PBEST',
           T_old_PBEST,
           T_new_PBEST
      FROM T_FST101_Audit
     WHERE NOT EXISTS (SELECT *
              FROM AUD005
             WHERE AUDMstTim = T_FST101_UpdatedOn
               AND AUDMstId = T_FST101_GuidKey
               AND AUDMstFld = 'PBEST');
  INSERT INTO AUD005
    SELECT T_FST101_UpdatedOn,
           T_FST101_GuidKey,
           'PBEXCP',
           T_old_PBEXCP,
           T_new_PBEXCP
      FROM T_FST101_Audit
     WHERE NOT EXISTS (SELECT *
              FROM AUD005
             WHERE AUDMstTim = T_FST101_UpdatedOn
               AND AUDMstId = T_FST101_GuidKey
               AND AUDMstFld = 'PBEXCP');
  INSERT INTO AUD005
    SELECT T_FST101_UpdatedOn,
           T_FST101_GuidKey,
           'PBFFIN',
           T_old_PBFFIN,
           T_new_PBFFIN
      FROM T_FST101_Audit
     WHERE NOT EXISTS (SELECT *
              FROM AUD005
             WHERE AUDMstTim = T_FST101_UpdatedOn
               AND AUDMstId = T_FST101_GuidKey
               AND AUDMstFld = 'PBFFIN');
  INSERT INTO AUD005
    SELECT T_FST101_UpdatedOn,
           T_FST101_GuidKey,
           'PBFINI',
           T_old_PBFINI,
           T_new_PBFINI
      FROM T_FST101_Audit
     WHERE NOT EXISTS (SELECT *
              FROM AUD005
             WHERE AUDMstTim = T_FST101_UpdatedOn
               AND AUDMstId = T_FST101_GuidKey
               AND AUDMstFld = 'PBFINI');
  INSERT INTO AUD005
    SELECT T_FST101_UpdatedOn,
           T_FST101_GuidKey,
           'PBHFIN',
           T_old_PBHFIN,
           T_new_PBHFIN
      FROM T_FST101_Audit
     WHERE NOT EXISTS (SELECT *
              FROM AUD005
             WHERE AUDMstTim = T_FST101_UpdatedOn
               AND AUDMstId = T_FST101_GuidKey
               AND AUDMstFld = 'PBHFIN');
  INSERT INTO AUD005
    SELECT T_FST101_UpdatedOn,
           T_FST101_GuidKey,
           'PBHINI',
           T_old_PBHINI,
           T_new_PBHINI
      FROM T_FST101_Audit
     WHERE NOT EXISTS (SELECT *
              FROM AUD005
             WHERE AUDMstTim = T_FST101_UpdatedOn
               AND AUDMstId = T_FST101_GuidKey
               AND AUDMstFld = 'PBHINI');
  INSERT INTO AUD005
    SELECT T_FST101_UpdatedOn,
           T_FST101_GuidKey,
           'PBNSEC',
           T_old_PBNSEC,
           T_new_PBNSEC
      FROM T_FST101_Audit
     WHERE NOT EXISTS (SELECT *
              FROM AUD005
             WHERE AUDMstTim = T_FST101_UpdatedOn
               AND AUDMstId = T_FST101_GuidKey
               AND AUDMstFld = 'PBNSEC');
  INSERT INTO AUD005
    SELECT T_FST101_UpdatedOn,
           T_FST101_GuidKey,
           'PBPARM',
           T_old_PBPARM,
           T_new_PBPARM
      FROM T_FST101_Audit
     WHERE NOT EXISTS (SELECT *
              FROM AUD005
             WHERE AUDMstTim = T_FST101_UpdatedOn
               AND AUDMstId = T_FST101_GuidKey
               AND AUDMstFld = 'PBPARM');
  INSERT INTO AUD005
    SELECT T_FST101_UpdatedOn,
           T_FST101_GuidKey,
           'PBPER',
           T_old_PBPER,
           T_new_PBPER
      FROM T_FST101_Audit
     WHERE NOT EXISTS (SELECT *
              FROM AUD005
             WHERE AUDMstTim = T_FST101_UpdatedOn
               AND AUDMstId = T_FST101_GuidKey
               AND AUDMstFld = 'PBPER');
  INSERT INTO AUD005
    SELECT T_FST101_UpdatedOn,
           T_FST101_GuidKey,
           'PBPROC',
           T_old_PBPROC,
           T_new_PBPROC
      FROM T_FST101_Audit
     WHERE NOT EXISTS (SELECT *
              FROM AUD005
             WHERE AUDMstTim = T_FST101_UpdatedOn
               AND AUDMstId = T_FST101_GuidKey
               AND AUDMstFld = 'PBPROC');
  INSERT INTO AUD005
    SELECT T_FST101_UpdatedOn,
           T_FST101_GuidKey,
           'PBRET',
           T_old_PBRET,
           T_new_PBRET
      FROM T_FST101_Audit
     WHERE NOT EXISTS (SELECT *
              FROM AUD005
             WHERE AUDMstTim = T_FST101_UpdatedOn
               AND AUDMstId = T_FST101_GuidKey
               AND AUDMstFld = 'PBRET');
  COMMIT;
END;
/

