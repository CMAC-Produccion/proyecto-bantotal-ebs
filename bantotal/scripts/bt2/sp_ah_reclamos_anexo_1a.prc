CREATE OR REPLACE PROCEDURE SP_AH_RECLAMOS_ANEXO_1A(P_CREUSR IN VARCHAR,
                                                    P_FCRINI IN DATE,
                                                    P_FCRFIN IN DATE,
                                                    P_FCCINI IN DATE,
                                                    P_FCCFIN IN DATE,
                                                    P_ERRCOD OUT VARCHAR,
                                                    P_ERRMSG OUT VARCHAR) IS
  -- ***************************************************************************************
  -- Nombre                     : SP_AH_RECLAMOS_ANEXO_1A
  -- Sistema                    : BANTOTAL
  -- Módulo                     : RECLAMOS
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2023.10.03
  -- Autor de Creación          : CVILLON
  -- Uso                        : ANEXO 1A
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2025.08.26
  -- Modificado                 : CVILLON
  -- Desc                       : Ajustes Nuevo Detalle Completo
  -- ***************************************************************************************

  ---*********
  lc_CREUSR CHAR(10);
  ---*********
BEGIN
  ---***
  lc_CREUSR := TRIM(P_CREUSR);
  P_ERRCOD  := '000';
  P_ERRMSG  := '';
  ---***
  DELETE FROM AQPB546 WHERE AQPB546CREUSR = lc_CREUSR;
  COMMIT;
  ---***
  ---***
  --INSERT INTO TEST_AQPB546 VALUES (P_FCRINI, P_FCRFIN, P_FCCINI, P_FCCFIN, P_ERRCOD, P_ERRMSG, SYSDATE);
  --COMMIT;
  ---***

  ---********* INI -> FOR LOOP RECLAMOS 'NORMALES' (NO de BANCA de SEGUROS)
  FOR XROW IN (SELECT j.JAQL420EMP AS X_AQPB546RECEMP,
                      j.JAQL420COD AS X_AQPB546RECCOD,
                      j.JAQL420PAC AS X_AQPB546RECPAI,
                      j.JAQL420TDC AS X_AQPB546RECTDO,
                      j.JAQL420NDC AS X_AQPB546RECNDO,
                      CASE
                        WHEN j.JAQL420TDC = 21 THEN
                         (SELECT (TRIM(PFAPE1) || ' ' || TRIM(PFAPE2) || ', ' ||
                                 TRIM(PFNOM1) || ' ' || TRIM(PFNOM2))
                            FROM FSD002
                           WHERE PFPAIS = j.JAQL420PAC
                             AND PFTDOC = j.JAQL420TDC
                             AND PFNDOC = j.JAQL420NDC)
                        ELSE
                         (SELECT TRIM(PENOM)
                            FROM FSD001
                           WHERE PEPAIS = j.JAQL420PAC
                             AND PETDOC = j.JAQL420TDC
                             AND PENDOC = j.JAQL420NDC)
                      END AS X_AQPB546CLINOM,
                      (j.JAQL420PAC || j.JAQL420TDC || j.JAQL420NDC) AS X_AQPB546CLICOD,
                      j.JAQL420FCR AS X_AQPB546RECFCR,
                      j.JAQL420CANING AS X_AQPB546CANING,
                      j.JAQL420CANIND AS X_AQPB546CANIND,
                      j422c.JAQL422CDES AS X_AQPB546CANOPE,
                      a546a.AQPB546AFECCOM AS X_AQPB546AMPFCM,
                      fcanresamp.TP1DESC AS X_AQPB546AMPCRP,
                      j.JAQL420FCC AS X_AQPB546RECFCC,
                      fcanresrec.TP1DESC AS X_AQPB546RECCRP,
                      ---*** UBIGEO INEI
                      /*
                      , CASE j.JAQL420CANING
                          WHEN 5 THEN NULL
                          ELSE j.JAQL420UGPRPR
                          END AS X_AQPB546UGPRPR
                        */
                      j.JAQL420UGPRPR AS X_AQPB546UGPRPR,
                      ---***
                      j.JAQL420OPS       AS X_AQPB546REOPSC,
                      j421.JAQL421DES    AS X_AQPB546REOPSD,
                      j.JAQL420MOT       AS X_AQPB546REMTVC,
                      j422.JAQL422DES    AS X_AQPB546REMTVD,
                      a545m.AQPB545MSCOD AS X_AQPB546RESUBC,
                      a545f.AQPB545FNOM  AS X_AQPB546RESUBD,
                      j.JAQL420CMRCLB    AS X_AQPB546CMRCLB,
                      j.JAQL420FLD       AS X_AQPB546RERESO,
                      j.JAQL420RECRES    AS X_AQPB546RECRES,
                      --j.JAQL420MPS AS X_AQPB546RECMPS,
                      j.JAQL420MONREC AS X_AQPB546RECMPS,
                      a545j.AQPB545JNOM AS X_AQPB546PROCAJ,
                      j.JAQL420ESR AS X_AQPB546RECESR,
                      CASE j.JAQL420ESR
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
                      END AS X_AQPB546RECESD,
                      (SELECT AQPB545BRCOD
                         FROM AQPB545B
                        WHERE AQPB545BEMP = j.JAQL420EMP
                          AND AQPB545BCOD = j.JAQL420COD
                          AND AQPB545BREMP = j.JAQL420EMP
                          AND AQPB545BRTIP = 'REC') AS X_AQPB546RECPRE,
                      CASE JAQL420TIPPRO
                        WHEN 'S' THEN
                         'SI'
                        ELSE
                         'NO'
                      END AS X_AQPB546BANSEG,
                      NULL AS X_AQPB546REOBSC,
                      NULL AS X_AQPB546REOBSD,
                      NULL AS X_AQPB546RMTBSC,
                      NULL AS X_AQPB546RMTBSD,
                      NULL AS X_AQPB546RSMBSC,
                      NULL AS X_AQPB546RSMBSD
               
                 FROM JAQL420 j
                 JOIN JAQL422C j422c
                   ON (j.JAQL420CAN = j422c.JAQL422CCOD AND
                      JAQL422CEST = 'S')
                 JOIN JAQL422 j422
                   ON (j.JAQL420MOT = j422.JAQL422COD AND JAQL422EST = 'S')
                 LEFT JOIN JAQL421 j421
                   ON (j.JAQL420OPS = j421.JAQL421COD AND JAQL421EST = 'S')
                 LEFT JOIN AQPB546A a546a
                   ON (j.JAQL420EMP = a546a.AQPB546ARECEMP AND
                      j.JAQL420COD = a546a.AQPB546ARECCOD AND
                      a546a.AQPB546AESTAMP = 'V' AND
                      a546a.AQPB546ARECTIP = 'REC')
                 LEFT JOIN AQPB545M a545m
                   ON (j.JAQL420EMP = a545m.AQPB545MREMP AND
                      j.JAQL420COD = a545m.AQPB545MRCOD)
                 LEFT JOIN AQPB545F a545f
                   ON (a545m.AQPB545MSCOD = a545f.AQPB545FCOD AND
                      a545f.AQPB545FEST = 'S')
                 JOIN AQPB545J a545j
                   ON (j.JAQL420EMP = a545j.AQPB545JEMP AND
                      j.JAQL420COD = a545j.AQPB545JREC)
               
                 JOIN FST198 fcanresrec
                   ON (j.JAQL420VRP = fcanresrec.TP1CORR3 AND
                      fcanresrec.TP1COD = 1 AND fcanresrec.TP1COD1 = 10871 AND
                      fcanresrec.TP1CORR1 = 3 AND fcanresrec.TP1CORR2 = 4 AND
                      fcanresrec.TP1NRO1 = 1)
               
                 LEFT JOIN FST198 fcanresamp
                   ON (a546a.AQPB546ACANAMP = fcanresamp.TP1CORR3 AND
                      fcanresamp.TP1COD = 1 AND fcanresamp.TP1COD1 = 10871 AND
                      fcanresamp.TP1CORR1 = 3 AND fcanresamp.TP1CORR2 = 4 AND
                      fcanresamp.TP1NRO1 = 1)
               
                WHERE j.JAQL420EMP = 1
                  AND JAQL420TRC = 1
                  AND j.JAQL420TIPPRO IN ('A', 'C')
                  AND j.JAQL420FCR BETWEEN P_FCRINI AND P_FCRFIN
                  AND j.JAQL420FCC BETWEEN P_FCCINI AND P_FCCFIN)
  
   LOOP
  
    INSERT INTO AQPB546
      (AQPB546CREUSR,
       AQPB546RECEMP,
       AQPB546RECCOD,
       AQPB546RECPAI,
       AQPB546RECTDO,
       AQPB546RECNDO,
       AQPB546CLINOM,
       AQPB546CLICOD,
       AQPB546RECFCR,
       AQPB546CANING,
       AQPB546CANIND,
       AQPB546CANOPE,
       AQPB546AMPFCM,
       AQPB546AMPCRP,
       AQPB546RECFCC,
       AQPB546RECCRP,
       AQPB546UGPRPR,
       AQPB546REOPSC,
       AQPB546REOPSD,
       AQPB546REMTVC,
       AQPB546REMTVD,
       AQPB546RESUBC,
       AQPB546RESUBD,
       AQPB546RECCMR,
       AQPB546RERESO,
       AQPB546RECRES,
       AQPB546RECMPS,
       AQPB546PROCAJ,
       AQPB546RECESR,
       AQPB546RECESD,
       AQPB546RECPRE,
       AQPB546BANSEG,
       AQPB546REOBSC,
       AQPB546REOBSD,
       AQPB546RMTBSC,
       AQPB546RMTBSD,
       AQPB546RSMBSC,
       AQPB546RSMBSD,
       AQPB546CRETIM,
       AQPB546CMRCLB)
    
    VALUES
      (lc_CREUSR,
       XROW.X_AQPB546RECEMP,
       XROW.X_AQPB546RECCOD,
       XROW.X_AQPB546RECPAI,
       XROW.X_AQPB546RECTDO,
       XROW.X_AQPB546RECNDO,
       XROW.X_AQPB546CLINOM,
       XROW.X_AQPB546CLICOD,
       XROW.X_AQPB546RECFCR,
       XROW.X_AQPB546CANING,
       XROW.X_AQPB546CANIND,
       XROW.X_AQPB546CANOPE,
       XROW.X_AQPB546AMPFCM,
       XROW.X_AQPB546AMPCRP,
       XROW.X_AQPB546RECFCC,
       XROW.X_AQPB546RECCRP,
       XROW.X_AQPB546UGPRPR,
       XROW.X_AQPB546REOPSC,
       XROW.X_AQPB546REOPSD,
       XROW.X_AQPB546REMTVC,
       XROW.X_AQPB546REMTVD,
       XROW.X_AQPB546RESUBC,
       XROW.X_AQPB546RESUBD,
       NULL,
       XROW.X_AQPB546RERESO,
       XROW.X_AQPB546RECRES,
       XROW.X_AQPB546RECMPS,
       XROW.X_AQPB546PROCAJ,
       XROW.X_AQPB546RECESR,
       XROW.X_AQPB546RECESD,
       XROW.X_AQPB546RECPRE,
       XROW.X_AQPB546BANSEG,
       XROW.X_AQPB546REOBSC,
       XROW.X_AQPB546REOBSD,
       XROW.X_AQPB546RMTBSC,
       XROW.X_AQPB546RMTBSD,
       XROW.X_AQPB546RSMBSC,
       XROW.X_AQPB546RSMBSD,
       SYSDATE,
       XROW.X_AQPB546CMRCLB);
  
  --DBMS_OUTPUT.PUT_LINE('X_AQPB546RECCOD:= '||XROW.X_AQPB546RECCOD);
  
  END LOOP;
  ---***
  ---********* FIN -> FOR LOOP RECLAMOS 'NORMALES' (NO de BANCA de SEGUROS)

  ---********* INI -> FOR LOOP RECLAMOS de BANCA de SEGUROS
  FOR XROW IN (SELECT j.JAQL420EMP AS X_AQPB546RECEMP,
                      j.JAQL420COD AS X_AQPB546RECCOD,
                      j.JAQL420PAC AS X_AQPB546RECPAI,
                      j.JAQL420TDC AS X_AQPB546RECTDO,
                      j.JAQL420NDC AS X_AQPB546RECNDO,
                      CASE
                        WHEN j.JAQL420TDC = 21 THEN
                         (SELECT (TRIM(PFAPE1) || ' ' || TRIM(PFAPE2) || ', ' ||
                                 TRIM(PFNOM1) || ' ' || TRIM(PFNOM2))
                            FROM FSD002
                           WHERE PFPAIS = j.JAQL420PAC
                             AND PFTDOC = j.JAQL420TDC
                             AND PFNDOC = j.JAQL420NDC)
                        ELSE
                         (SELECT TRIM(PENOM)
                            FROM FSD001
                           WHERE PEPAIS = j.JAQL420PAC
                             AND PETDOC = j.JAQL420TDC
                             AND PENDOC = j.JAQL420NDC)
                      END AS X_AQPB546CLINOM,
                      (j.JAQL420PAC || j.JAQL420TDC || j.JAQL420NDC) AS X_AQPB546CLICOD,
                      j.JAQL420FCR AS X_AQPB546RECFCR,
                      j.JAQL420CANING AS X_AQPB546CANING,
                      j.JAQL420CANIND AS X_AQPB546CANIND,
                      j422c.JAQL422CDES AS X_AQPB546CANOPE,
                      a546a.AQPB546AFECCOM AS X_AQPB546AMPFCM,
                      fcanresamp.TP1DESC AS X_AQPB546AMPCRP,
                      j.JAQL420FCC AS X_AQPB546RECFCC,
                      fcanresrec.TP1DESC AS X_AQPB546RECCRP,
                      ---*** UBIGEO INEI
                      /*
                      , CASE j.JAQL420CANING
                          WHEN 5 THEN NULL
                          ELSE j.JAQL420UGPRPR
                          END AS X_AQPB546UGPRPR
                        */
                      j.JAQL420UGPRPR AS X_AQPB546UGPRPR,
                      ---***
                      ---***
                      NULL AS X_AQPB546REOPSC,
                      'Banca-Seguros(seguros vendidos en los canales del sistema financiero)' AS X_AQPB546REOPSD,
                      j.JAQL420MOT AS X_AQPB546REMTVC,
                      j422.JAQL422DES AS X_AQPB546REMTVD,
                      a545m.AQPB545MSCOD AS X_AQPB546RESUBC,
                      a545f.AQPB545FNOM AS X_AQPB546RESUBD,
                      ---***
                      ---***
                      j.JAQL420CMRCLB AS X_AQPB546CMRCLB,
                      j.JAQL420FLD    AS X_AQPB546RERESO,
                      j.JAQL420RECRES AS X_AQPB546RECRES,
                      --j.JAQL420MPS AS X_AQPB546RECMPS,
                      j.JAQL420MONREC AS X_AQPB546RECMPS,
                      a545j.AQPB545JNOM AS X_AQPB546PROCAJ,
                      j.JAQL420ESR AS X_AQPB546RECESR,
                      CASE j.JAQL420ESR
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
                      END AS X_AQPB546RECESD,
                      (SELECT AQPB545BRCOD
                         FROM AQPB545B
                        WHERE AQPB545BEMP = j.JAQL420EMP
                          AND AQPB545BCOD = j.JAQL420COD
                          AND AQPB545BREMP = j.JAQL420EMP
                          AND AQPB545BRTIP = 'REC') AS X_AQPB546RECPRE,
                      CASE JAQL420TIPPRO
                        WHEN 'S' THEN
                         'SI'
                        ELSE
                         'NO'
                      END AS X_AQPB546BANSEG,
                      a545d.AQPB545DSEGCOD AS X_AQPB546REOBSC,
                      --a545c.AQPB545CNOM AS X_AQPB546REOBSD,
                      --'Banca-Seguros(seguros vendidos en los canales del sistema financiero)' AS X_AQPB546REOBSD,
                      p.AQPB545POPSNOM AS X_AQPB546REOBSD,
                      --j.JAQL420MOT AS X_AQPB546RMTBSC,
                      p.AQPB545PMOTSBS AS X_AQPB546RMTBSC,
                      
                      --a545e.AQPB545ENOM AS X_AQPB546RMTBSD,
                      --j422.JAQL422DES    AS X_AQPB546RMTBSD,
                      p.AQPB545PMOTNOM AS X_AQPB546RMTBSD,
                      
                      --a545m.AQPB545MSCOD AS X_AQPB546RSMBSC,
                      p.AQPB545PSMOSBS AS X_AQPB546RSMBSC,
                      
                      --a545f.AQPB545FNOM  AS X_AQPB546RSMBSD
                      p.AQPB545PSMONOM AS X_AQPB546RSMBSD
               
                 FROM JAQL420 j
                 JOIN JAQL422C j422c
                   ON (j.JAQL420CAN = j422c.JAQL422CCOD AND
                      JAQL422CEST = 'S')
                 JOIN JAQL422 j422
                   ON (j.JAQL420MOT = j422.JAQL422COD AND JAQL422EST = 'S')
               --LEFT JOIN AQPB545E a545e
               --  ON (j.JAQL420MOT = a545e.AQPB545ECOD AND
               --     AQPB545EEST = 'S')
                 LEFT JOIN AQPB545D a545d
                   ON (j.JAQL420EMP = a545d.AQPB545DPGCOD AND
                      j.JAQL420COD = a545d.AQPB545DRECCOD AND
                      a545d.AQPB545DRECTIP = 'REC')
               --LEFT JOIN AQPB545C a545c
               --  ON (a545d.AQPB545DSEGCOD = a545c.AQPB545CCOD)
               ---***
                 LEFT JOIN AQPB545P p
                   ON (j.JAQL420EMP = p.AQPB545PEMPCOD AND
                      j.JAQL420COD = p.AQPB545PRECCOD)
               ---***
                 LEFT JOIN AQPB546A a546a
                   ON (j.JAQL420EMP = a546a.AQPB546ARECEMP AND
                      j.JAQL420COD = a546a.AQPB546ARECCOD AND
                      a546a.AQPB546AESTAMP = 'V' AND
                      a546a.AQPB546ARECTIP = 'REC')
                 LEFT JOIN AQPB545M a545m
                   ON (j.JAQL420EMP = a545m.AQPB545MREMP AND
                      j.JAQL420COD = a545m.AQPB545MRCOD)
                 LEFT JOIN AQPB545F a545f
                   ON (a545m.AQPB545MSCOD = a545f.AQPB545FCOD AND
                      a545f.AQPB545FEST = 'S')
                 JOIN AQPB545J a545j
                   ON (j.JAQL420EMP = a545j.AQPB545JEMP AND
                      j.JAQL420COD = a545j.AQPB545JREC)
               
                 JOIN FST198 fcanresrec
                   ON (j.JAQL420VRP = fcanresrec.TP1CORR3 AND
                      fcanresrec.TP1COD = 1 AND fcanresrec.TP1COD1 = 10871 AND
                      fcanresrec.TP1CORR1 = 3 AND fcanresrec.TP1CORR2 = 4 AND
                      fcanresrec.TP1NRO1 = 1)
               
                 LEFT JOIN FST198 fcanresamp
                   ON (a546a.AQPB546ACANAMP = fcanresamp.TP1CORR3 AND
                      fcanresamp.TP1COD = 1 AND fcanresamp.TP1COD1 = 10871 AND
                      fcanresamp.TP1CORR1 = 3 AND fcanresamp.TP1CORR2 = 4 AND
                      fcanresamp.TP1NRO1 = 1)
               
                WHERE j.JAQL420EMP = 1
                  AND JAQL420TRC = 1
                  AND j.JAQL420TIPPRO = 'S'
                  AND j.JAQL420FCR BETWEEN P_FCRINI AND P_FCRFIN
                  AND j.JAQL420FCC BETWEEN P_FCCINI AND P_FCCFIN)
  
   LOOP
  
    INSERT INTO AQPB546
      (AQPB546CREUSR,
       AQPB546RECEMP,
       AQPB546RECCOD,
       AQPB546RECPAI,
       AQPB546RECTDO,
       AQPB546RECNDO,
       AQPB546CLINOM,
       AQPB546CLICOD,
       AQPB546RECFCR,
       AQPB546CANING,
       AQPB546CANIND,
       AQPB546CANOPE,
       AQPB546AMPFCM,
       AQPB546AMPCRP,
       AQPB546RECFCC,
       AQPB546RECCRP,
       AQPB546UGPRPR,
       AQPB546REOPSC,
       AQPB546REOPSD,
       AQPB546REMTVC,
       AQPB546REMTVD,
       AQPB546RESUBC,
       AQPB546RESUBD,
       AQPB546RECCMR,
       AQPB546RERESO,
       AQPB546RECRES,
       AQPB546RECMPS,
       AQPB546PROCAJ,
       AQPB546RECESR,
       AQPB546RECESD,
       AQPB546RECPRE,
       AQPB546BANSEG,
       AQPB546REOBSC,
       AQPB546REOBSD,
       AQPB546RMTBSC,
       AQPB546RMTBSD,
       AQPB546RSMBSC,
       AQPB546RSMBSD,
       AQPB546CRETIM,
       AQPB546CMRCLB)
    
    VALUES
      (lc_CREUSR,
       XROW.X_AQPB546RECEMP,
       XROW.X_AQPB546RECCOD,
       XROW.X_AQPB546RECPAI,
       XROW.X_AQPB546RECTDO,
       XROW.X_AQPB546RECNDO,
       XROW.X_AQPB546CLINOM,
       XROW.X_AQPB546CLICOD,
       XROW.X_AQPB546RECFCR,
       XROW.X_AQPB546CANING,
       XROW.X_AQPB546CANIND,
       XROW.X_AQPB546CANOPE,
       XROW.X_AQPB546AMPFCM,
       XROW.X_AQPB546AMPCRP,
       XROW.X_AQPB546RECFCC,
       XROW.X_AQPB546RECCRP,
       XROW.X_AQPB546UGPRPR,
       XROW.X_AQPB546REOPSC,
       XROW.X_AQPB546REOPSD,
       XROW.X_AQPB546REMTVC,
       XROW.X_AQPB546REMTVD,
       XROW.X_AQPB546RESUBC,
       XROW.X_AQPB546RESUBD,
       NULL,
       XROW.X_AQPB546RERESO,
       XROW.X_AQPB546RECRES,
       XROW.X_AQPB546RECMPS,
       XROW.X_AQPB546PROCAJ,
       XROW.X_AQPB546RECESR,
       XROW.X_AQPB546RECESD,
       XROW.X_AQPB546RECPRE,
       XROW.X_AQPB546BANSEG,
       XROW.X_AQPB546REOBSC,
       XROW.X_AQPB546REOBSD,
       XROW.X_AQPB546RMTBSC,
       XROW.X_AQPB546RMTBSD,
       XROW.X_AQPB546RSMBSC,
       XROW.X_AQPB546RSMBSD,
       SYSDATE,
       XROW.X_AQPB546CMRCLB);
  
  --DBMS_OUTPUT.PUT_LINE('X_AQPB546RECCOD:= '||XROW.X_AQPB546RECCOD);
  
  END LOOP;
  ---********* FIN -> FOR LOOP RECLAMOS de BANCA de SEGUROS

  ---***
  COMMIT;
  ---***
EXCEPTION
  WHEN OTHERS THEN
    P_ERRCOD := '001';
    P_ERRMSG := sqlcode || '->' || sqlerrm;
END SP_AH_RECLAMOS_ANEXO_1A;
/
