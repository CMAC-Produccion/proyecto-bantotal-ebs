CREATE OR REPLACE PROCEDURE SP_AH_REQINFO_ANEXO_1B(P_CREUSR IN VARCHAR,
                                                   P_FCRINI IN DATE,
                                                   P_FCRFIN IN DATE,
                                                   P_FCCINI IN DATE,
                                                   P_FCCFIN IN DATE,
                                                   P_ERRCOD OUT VARCHAR,
                                                   P_ERRMSG OUT VARCHAR) IS

  ---*********
  lc_CREUSR CHAR(10);
  ---*********
BEGIN
  ---***
  lc_CREUSR := TRIM(P_CREUSR);
  P_ERRCOD  := '000';
  P_ERRMSG  := '';
  ---***
  DELETE FROM AQPB547 WHERE AQPB547CREUSR = lc_CREUSR;
  COMMIT;
  ---***
  ---***
  --INSERT INTO TEST_AQPB546 VALUES (P_FCRINI, P_FCRFIN, P_FCCINI, P_FCCFIN, P_ERRCOD, P_ERRMSG, SYSDATE);
  --COMMIT;
  ---***

  ---********* INI -> FOR LOOP RECLAMOS 'NORMALES' (NO de BANCA de SEGUROS)
  FOR XROW IN (SELECT j.JAQY290_REMP AS X_AQPB547RECEMP,
                      j.JAQY290_RCOD AS X_AQPB547RECCOD,
                      j.JAQY290_RPAC AS X_AQPB547RECPAI,
                      j.JAQY290_RTDC AS X_AQPB547RECTDO,
                      j.JAQY290_RNDC AS X_AQPB547RECNDO,
                      CASE
                        WHEN j.JAQY290_RTDC = 21 THEN
                         (SELECT (TRIM(PFAPE1) || ' ' || TRIM(PFAPE2) || ', ' ||
                                 TRIM(PFNOM1) || ' ' || TRIM(PFNOM2))
                            FROM FSD002
                           WHERE PFPAIS = j.JAQY290_RPAC
                             AND PFTDOC = j.JAQY290_RTDC
                             AND PFNDOC = j.JAQY290_RNDC)
                        ELSE
                         (SELECT TRIM(PENOM)
                            FROM FSD001
                           WHERE PEPAIS = j.JAQY290_RPAC
                             AND PETDOC = j.JAQY290_RTDC
                             AND PENDOC = j.JAQY290_RNDC)
                      END AS X_AQPB547CLINOM,
                      (j.JAQY290_RPAC || j.JAQY290_RTDC || j.JAQY290_RNDC) AS X_AQPB547CLICOD,
                      j.JAQY290_RFCR AS X_AQPB547RECFCR,
                      NULL AS X_AQPB547AMPFCM,
                      NULL AS X_AQPB547AMPCRP,
                      j.JAQY290_RFCC AS X_AQPB547RECFCC,
                      j.JAQY290CANING AS X_AQPB547CANING,
                      j.JAQY290CANIND AS X_AQPB547CANIND,
                      NULL AS X_AQPB547CANOPE,
                      fcanresrec.TP1DESC AS X_AQPB547RECCRP,
                      ---*** UBIGEO INEI
                      /*
                      CASE j.JAQY290CANING
                        WHEN 5 THEN
                         NULL
                        ELSE
                         j.JAQY290UGPRPR
                      END AS X_AQPB547UGPRPR,
                      */
                      j.JAQY290UGPRPR AS X_AQPB547UGPRPR,
                      ---***
                      j.JAQY290_ROPS AS X_AQPB547REOPSC,
                      j421.JAQL421DES AS X_AQPB547REOPSD,
                      j.JAQY290_RMOT AS X_AQPB547REMTVC,
                      j294.JAQY294DES AS X_AQPB547REMTVD,
                      NULL AS X_AQPB547RESUBC,
                      NULL AS X_AQPB547RESUBD,
                      j.JAQY290_RCMR AS X_AQPB547RECCMR,
                      NULL AS X_AQPB547RERESO,
                      j.JAQY290REQRES AS X_AQPB547RECRES,
                      NULL AS X_AQPB547RECMPS,
                      NULL AS X_AQPB547PROCAJ,
                      j.JAQY290_RESR AS X_AQPB547RECESR,
                      CASE j.JAQY290_RESR
                        WHEN 1 THEN
                         'RECIBIDO'
                        WHEN 2 THEN
                         'PENDIENTE'
                        WHEN 3 THEN
                         'ATENDIDO'
                        WHEN 4 THEN
                         'ANULADO'
                        ELSE
                         '-'
                      END AS X_AQPB547RECESD,
                      NULL AS X_AQPB547RECPRE,
                      CASE JAQY290TIPPRO
                        WHEN 'S' THEN
                         'SI'
                        ELSE
                         'NO'
                      END AS X_AQPB547BANSEG,
                      NULL AS X_AQPB547REOBSC,
                      NULL AS X_AQPB547REOBSD,
                      NULL AS X_AQPB547RMTBSC,
                      NULL AS X_AQPB547RMTBSD,
                      NULL AS X_AQPB547RSMBSC,
                      NULL AS X_AQPB547RSMBSD
               
                 FROM JAQY290_R j
                 JOIN JAQY294 j294
                   ON (j.JAQY290_RMOT = j294.JAQY294COD AND JAQY294EST = 'S')
                 LEFT JOIN JAQL421 j421
                   ON (j.JAQY290_ROPS = j421.JAQL421COD AND JAQL421EST = 'S')
               /*
                 JOIN FST198 fcanresrec
                   ON (j.JAQY290_RVRP = fcanresrec.TP1CORR3 AND
                      fcanresrec.TP1COD = 1 AND fcanresrec.TP1COD1 = 10871 AND
                      fcanresrec.TP1CORR1 = 3 AND fcanresrec.TP1CORR2 = 4 AND
                      fcanresrec.TP1NRO1 = 1)
               */
                 JOIN FST198 fcanresrec
                   ON (j.JAQY290_RVRP = fcanresrec.TP1CORR3 AND
                      fcanresrec.TP1COD = 1 AND fcanresrec.TP1COD1 = 10871 AND
                      fcanresrec.TP1CORR1 = 6 AND fcanresrec.TP1CORR2 = 4 AND
                      fcanresrec.TP1CORR3 <> 2 AND fcanresrec.TP1NRO1 = 1)
               
                WHERE j.JAQY290_REMP = 1
                  AND j.JAQY290TIPPRO IN ('A', 'C')
                  AND j.JAQY290_RFCR BETWEEN P_FCRINI AND P_FCRFIN
                  AND j.JAQY290_RFCC BETWEEN P_FCCINI AND P_FCCFIN)
  
   LOOP
  
    INSERT INTO AQPB547
      (AQPB547CREUSR,
       AQPB547RECEMP,
       AQPB547RECCOD,
       AQPB547RECPAI,
       AQPB547RECTDO,
       AQPB547RECNDO,
       AQPB547CLINOM,
       AQPB547CLICOD,
       AQPB547RECFCR,
       AQPB547CANING,
       AQPB547CANIND,
       AQPB547CANOPE,
       AQPB547AMPFCM,
       AQPB547AMPCRP,
       AQPB547RECFCC,
       AQPB547RECCRP,
       AQPB547UGPRPR,
       AQPB547REOPSC,
       AQPB547REOPSD,
       AQPB547REMTVC,
       AQPB547REMTVD,
       AQPB547RESUBC,
       AQPB547RESUBD,
       AQPB547RECCMR,
       AQPB547RERESO,
       AQPB547RECRES,
       AQPB547RECMPS,
       AQPB547PROCAJ,
       AQPB547RECESR,
       AQPB547RECESD,
       AQPB547RECPRE,
       AQPB547BANSEG,
       AQPB547REOBSC,
       AQPB547REOBSD,
       AQPB547RMTBSC,
       AQPB547RMTBSD,
       AQPB547RSMBSC,
       AQPB547RSMBSD,
       AQPB547CRETIM)
    
    VALUES
      (lc_CREUSR,
       XROW.X_AQPB547RECEMP,
       XROW.X_AQPB547RECCOD,
       XROW.X_AQPB547RECPAI,
       XROW.X_AQPB547RECTDO,
       XROW.X_AQPB547RECNDO,
       XROW.X_AQPB547CLINOM,
       XROW.X_AQPB547CLICOD,
       XROW.X_AQPB547RECFCR,
       XROW.X_AQPB547CANING,
       XROW.X_AQPB547CANIND,
       XROW.X_AQPB547CANOPE,
       XROW.X_AQPB547AMPFCM,
       XROW.X_AQPB547AMPCRP,
       XROW.X_AQPB547RECFCC,
       XROW.X_AQPB547RECCRP,
       XROW.X_AQPB547UGPRPR,
       XROW.X_AQPB547REOPSC,
       XROW.X_AQPB547REOPSD,
       XROW.X_AQPB547REMTVC,
       XROW.X_AQPB547REMTVD,
       XROW.X_AQPB547RESUBC,
       XROW.X_AQPB547RESUBD,
       XROW.X_AQPB547RECCMR,
       XROW.X_AQPB547RERESO,
       XROW.X_AQPB547RECRES,
       XROW.X_AQPB547RECMPS,
       XROW.X_AQPB547PROCAJ,
       XROW.X_AQPB547RECESR,
       XROW.X_AQPB547RECESD,
       XROW.X_AQPB547RECPRE,
       XROW.X_AQPB547BANSEG,
       XROW.X_AQPB547REOBSC,
       XROW.X_AQPB547REOBSD,
       XROW.X_AQPB547RMTBSC,
       XROW.X_AQPB547RMTBSD,
       XROW.X_AQPB547RSMBSC,
       XROW.X_AQPB547RSMBSD,
       SYSDATE);
  
  --DBMS_OUTPUT.PUT_LINE('X_AQPB546RECCOD:= '||XROW.X_AQPB546RECCOD);
  
  END LOOP;
  ---***
  ---********* FIN -> FOR LOOP RECLAMOS 'NORMALES' (NO de BANCA de SEGUROS)

  ---********* INI -> FOR LOOP RECLAMOS de BANCA de SEGUROS
  FOR XROW IN (SELECT j.JAQY290_REMP AS X_AQPB547RECEMP,
                      j.JAQY290_RCOD AS X_AQPB547RECCOD,
                      j.JAQY290_RPAC AS X_AQPB547RECPAI,
                      j.JAQY290_RTDC AS X_AQPB547RECTDO,
                      j.JAQY290_RNDC AS X_AQPB547RECNDO,
                      CASE
                        WHEN j.JAQY290_RTDC = 21 THEN
                         (SELECT (TRIM(PFAPE1) || ' ' || TRIM(PFAPE2) || ', ' ||
                                 TRIM(PFNOM1) || ' ' || TRIM(PFNOM2))
                            FROM FSD002
                           WHERE PFPAIS = j.JAQY290_RPAC
                             AND PFTDOC = j.JAQY290_RTDC
                             AND PFNDOC = j.JAQY290_RNDC)
                        ELSE
                         (SELECT TRIM(PENOM)
                            FROM FSD001
                           WHERE PEPAIS = j.JAQY290_RPAC
                             AND PETDOC = j.JAQY290_RTDC
                             AND PENDOC = j.JAQY290_RNDC)
                      END AS X_AQPB547CLINOM,
                      (j.JAQY290_RPAC || j.JAQY290_RTDC || j.JAQY290_RNDC) AS X_AQPB547CLICOD,
                      j.JAQY290_RFCR AS X_AQPB547RECFCR,
                      NULL AS X_AQPB547AMPFCM,
                      NULL AS X_AQPB547AMPCRP,
                      j.JAQY290_RFCC AS X_AQPB547RECFCC,
                      j.JAQY290CANING AS X_AQPB547CANING,
                      j.JAQY290CANIND AS X_AQPB547CANIND,
                      NULL AS X_AQPB547CANOPE,
                      fcanresrec.TP1DESC AS X_AQPB547RECCRP,
                      ---*** UBIGEO INEI
                      /*
                      CASE j.JAQY290CANING
                        WHEN 5 THEN
                         NULL
                        ELSE
                         j.JAQY290UGPRPR
                      END AS X_AQPB547UGPRPR,
                      */
                      j.JAQY290UGPRPR AS X_AQPB547UGPRPR,
                      ---***
                      a545d.AQPB545DSEGCOD AS X_AQPB547REOPSC,
                      a545c.AQPB545CNOM AS X_AQPB547REOPSD,
                      j.JAQY290_RMOT AS X_AQPB547REMTVC,
                      j294.JAQY294DES AS X_AQPB547REMTVD,
                      NULL AS X_AQPB547RESUBC,
                      NULL AS X_AQPB547RESUBD,
                      j.JAQY290_RCMR AS X_AQPB547RECCMR,
                      NULL AS X_AQPB547RERESO,
                      j.JAQY290REQRES AS X_AQPB547RECRES,
                      NULL AS X_AQPB547RECMPS,
                      NULL AS X_AQPB547PROCAJ,
                      j.JAQY290_RESR AS X_AQPB547RECESR,
                      CASE j.JAQY290_RESR
                        WHEN 1 THEN
                         'RECIBIDO'
                        WHEN 2 THEN
                         'PENDIENTE'
                        WHEN 3 THEN
                         'ATENDIDO'
                        WHEN 4 THEN
                         'ANULADO'
                        ELSE
                         '-'
                      END AS X_AQPB547RECESD,
                      NULL AS X_AQPB547RECPRE,
                      CASE JAQY290TIPPRO
                        WHEN 'S' THEN
                         'SI'
                        ELSE
                         'NO'
                      END AS X_AQPB547BANSEG,
                      a545d.AQPB545DSEGCOD AS X_AQPB547REOBSC,
                      a545c.AQPB545CNOM AS X_AQPB547REOBSD,
                      NULL AS X_AQPB547RMTBSC,
                      NULL AS X_AQPB547RMTBSD,
                      NULL AS X_AQPB547RSMBSC,
                      NULL AS X_AQPB547RSMBSD
               
                 FROM JAQY290_R j
                 JOIN JAQY294 j294
                   ON (j.JAQY290_RMOT = j294.JAQY294COD AND JAQY294EST = 'S')
                 LEFT JOIN JAQL421 j421
                   ON (j.JAQY290_ROPS = j421.JAQL421COD AND JAQL421EST = 'S')
                 LEFT JOIN AQPB545D a545d
                   ON (j.JAQY290_REMP = a545d.AQPB545DPGCOD AND
                      j.JAQY290_RCOD = a545d.AQPB545DRECCOD AND
                      a545d.AQPB545DRECTIP = 'REQ')
                 LEFT JOIN AQPB545C a545c
                   ON (a545d.AQPB545DSEGCOD = a545c.AQPB545CCOD)
               
               /*
               JOIN FST198 fcanresrec
                 ON (j.JAQY290_RVRP = fcanresrec.TP1CORR3 AND
                    fcanresrec.TP1COD = 1 AND fcanresrec.TP1COD1 = 10871 AND
                    fcanresrec.TP1CORR1 = 3 AND fcanresrec.TP1CORR2 = 4 AND
                    fcanresrec.TP1NRO1 = 1)
                */
               
                 JOIN FST198 fcanresrec
                   ON (j.JAQY290_RVRP = fcanresrec.TP1CORR3 AND
                      fcanresrec.TP1COD = 1 AND fcanresrec.TP1COD1 = 10871 AND
                      fcanresrec.TP1CORR1 = 6 AND fcanresrec.TP1CORR2 = 4 AND
                      fcanresrec.TP1CORR3 <> 2 AND fcanresrec.TP1NRO1 = 1)
               
                WHERE j.JAQY290_REMP = 1
                  AND j.JAQY290TIPPRO = 'S'
                  AND j.JAQY290_RFCR BETWEEN P_FCRINI AND P_FCRFIN
                  AND j.JAQY290_RFCC BETWEEN P_FCCINI AND P_FCCFIN)
  
   LOOP
  
    INSERT INTO AQPB547
      (AQPB547CREUSR,
       AQPB547RECEMP,
       AQPB547RECCOD,
       AQPB547RECPAI,
       AQPB547RECTDO,
       AQPB547RECNDO,
       AQPB547CLINOM,
       AQPB547CLICOD,
       AQPB547RECFCR,
       AQPB547CANING,
       AQPB547CANIND,
       AQPB547CANOPE,
       AQPB547AMPFCM,
       AQPB547AMPCRP,
       AQPB547RECFCC,
       AQPB547RECCRP,
       AQPB547UGPRPR,
       AQPB547REOPSC,
       AQPB547REOPSD,
       AQPB547REMTVC,
       AQPB547REMTVD,
       AQPB547RESUBC,
       AQPB547RESUBD,
       AQPB547RECCMR,
       AQPB547RERESO,
       AQPB547RECRES,
       AQPB547RECMPS,
       AQPB547PROCAJ,
       AQPB547RECESR,
       AQPB547RECESD,
       AQPB547RECPRE,
       AQPB547BANSEG,
       AQPB547REOBSC,
       AQPB547REOBSD,
       AQPB547RMTBSC,
       AQPB547RMTBSD,
       AQPB547RSMBSC,
       AQPB547RSMBSD,
       AQPB547CRETIM)
    
    VALUES
      (lc_CREUSR,
       XROW.X_AQPB547RECEMP,
       XROW.X_AQPB547RECCOD,
       XROW.X_AQPB547RECPAI,
       XROW.X_AQPB547RECTDO,
       XROW.X_AQPB547RECNDO,
       XROW.X_AQPB547CLINOM,
       XROW.X_AQPB547CLICOD,
       XROW.X_AQPB547RECFCR,
       XROW.X_AQPB547CANING,
       XROW.X_AQPB547CANIND,
       XROW.X_AQPB547CANOPE,
       XROW.X_AQPB547AMPFCM,
       XROW.X_AQPB547AMPCRP,
       XROW.X_AQPB547RECFCC,
       XROW.X_AQPB547RECCRP,
       XROW.X_AQPB547UGPRPR,
       XROW.X_AQPB547REOPSC,
       XROW.X_AQPB547REOPSD,
       XROW.X_AQPB547REMTVC,
       XROW.X_AQPB547REMTVD,
       XROW.X_AQPB547RESUBC,
       XROW.X_AQPB547RESUBD,
       XROW.X_AQPB547RECCMR,
       XROW.X_AQPB547RERESO,
       XROW.X_AQPB547RECRES,
       XROW.X_AQPB547RECMPS,
       XROW.X_AQPB547PROCAJ,
       XROW.X_AQPB547RECESR,
       XROW.X_AQPB547RECESD,
       XROW.X_AQPB547RECPRE,
       XROW.X_AQPB547BANSEG,
       XROW.X_AQPB547REOBSC,
       XROW.X_AQPB547REOBSD,
       XROW.X_AQPB547RMTBSC,
       XROW.X_AQPB547RMTBSD,
       XROW.X_AQPB547RSMBSC,
       XROW.X_AQPB547RSMBSD,
       SYSDATE);
  
  --DBMS_OUTPUT.PUT_LINE('X_AQPB547RECCOD:= '||XROW.X_AQPB547RECCOD);
  
  END LOOP;
  ---********* FIN -> FOR LOOP RECLAMOS de BANCA de SEGUROS

  ---***
  COMMIT;
  ---***
EXCEPTION
  WHEN OTHERS THEN
    P_ERRCOD := '001';
    P_ERRMSG := sqlcode || '->' || sqlerrm;
END SP_AH_REQINFO_ANEXO_1B;
/

