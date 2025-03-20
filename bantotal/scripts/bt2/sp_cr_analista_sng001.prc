CREATE OR REPLACE PROCEDURE SP_CR_ANALISTA_SNG001(CTA         NUMBER,
                                                  INSTANCIA   NUMBER,
                                                  ANALISTA    CHAR,
                                                  N_SNG001ORI NUMBER) IS
  N_CONT1 NUMBER := 0;
  N_CONT2 NUMBER := 0;
  N_CONT3 NUMBER := 0;
  N_CONT4 NUMBER := 0;  
BEGIN
  SELECT COUNT(*)
      INTO N_CONT3
      FROM SNG001 I
     WHERE I.SNG001INST =INSTANCIA;
  --LUIS CARPIO/ERIKA HIDALGO
  IF N_CONT3=0 THEN --Validación de que instancia no exista antes de insertar
    IF (N_SNG001ORI IN (0, 14, 4, 13)) THEN
      --LUIS CARPIO/ERIKA HIDALGO
      SELECT COUNT(*)
        INTO N_CONT1
        FROM SNG001 I
       WHERE I.SNG001CTA = CTA
         AND I.SNG001INST IN
             (SELECT MAX(SNG001INST) FROM SNG001 A WHERE A.SNG001CTA = CTA);

      SELECT COUNT(*)
        INTO N_CONT2
        FROM  WFWRKITEMS O WHERE O.WFINSPRCID = INSTANCIA;
        
      SELECT COUNT(*)
        INTO N_CONT4 
        FROM SNGAS2 SS WHERE SS.SNGAS2USR=rpad(ANALISTA,10,' ');  
      
      IF N_CONT4 = 1 THEN
        IF N_CONT2 > 0 THEN
          IF N_CONT1 = 1 THEN
            INSERT INTO SNG001
            (
              SNG001INST,        SNG001EMP,         SNG001CTA,         SNG001PAIS,         SNG001TDOC,         SNG001NDOC,         SNG001ORI,
              SNG229CORR,         SNG001SEG,         SNG001TPCR,         SNG009COD,         SNG001EVER,         SNG001PRE,         SNG001AGE,
              SNG001ASE,         SNG001USI,         SNG001FIN,
              SNG015COD,         SNG001USC,         SNG001EMC,         SNG001CMX,
              SNG014COD,         SNG017COD,         SNG017MTO,         SNG017CLI,         SNG017MCR,         SNG017CMO,         SNG017CEF,
              SNG017ANA,         SNG01ICUOT,         SNG01ISUAV,         SNG01IPMIO,         SNG01MEVAI,         SNG01MEVAF,         SNG01SCORI,
              SNG01STGAI,         SNG01SCORF,         SNG01STGAF,         SNG01CUEXM,         SNG01ICEXM,         SNG01SDOCF,         SNG01FDSMB,
              SNG001EJEC,         
              SNG001EVTC,         SNG001PZOS,         SNG001NGRP,         SNG001NCIC)
            SELECT
              INSTANCIA,          SNG001EMP,         SNG001CTA,         SNG001PAIS,         SNG001TDOC,          SNG001NDOC,        N_SNG001ORI,
              SNG229CORR,         SNG001SEG,         SNG001TPCR,        SNG009COD,          SNG001EVER,          SNG001PRE,          SNG001AGE,
      /*SNG001ASE*/ANALISTA,      /*SNG001USI*/ANALISTA,     (SELECT TRUNC(MIN(WFITEMINIT))  FROM WFWRKITEMS O WHERE O.WFINSPRCID = INSTANCIA),
              SNG015COD,          SNG001USC,         SNG001EMC,        SNG001CMX,
              SNG014COD,          SNG017COD,         SNG017MTO,        SNG017CLI,         SNG017MCR,          SNG017CMO,         SNG017CEF,
              SNG017ANA,          SNG01ICUOT,        SNG01ISUAV,       SNG01IPMIO,        SNG01MEVAI,         SNG01MEVAF,        SNG01SCORI,
              SNG01STGAI,         SNG01SCORF,        SNG01STGAF,       SNG01CUEXM,        SNG01ICEXM,          SNG01SDOCF,       SNG01FDSMB,
              /*SNG001EJEC*/ (SELECT SNGAS2COD FROM SNGAS2 SS WHERE SS.SNGAS2USR=RPAD(ANALISTA,10,' ')),
              SNG001EVTC,        SNG001PZOS,       SNG001NGRP,        SNG001NCIC
            FROM SNG001 I
               WHERE I.SNG001CTA = CTA
                 AND SNG001INST IN
                     (SELECT MAX(SNG001INST) FROM SNG001 I WHERE I.SNG001CTA = CTA);

            COMMIT;
            DBMS_OUTPUT.PUT_LINE('Se insertó SNG001, ' || N_CONT1 ||
                                 ' registro.');
          ELSE
            DBMS_OUTPUT.PUT_LINE('La cuenta:' || CTA || ' considera ' || N_CONT1 ||
                                 ' registro(s) en la SNG001.' || CHR(13) ||
                                 'No se realizó el Insert.');
          END IF;
        ELSE
          DBMS_OUTPUT.PUT_LINE('La instancia:' || INSTANCIA || ' considera ' || N_CONT2 ||
                                 ' registro(s) en la WFWRKITEMS.' || CHR(13) ||
                                 'No se realizó el Insert.');
        END IF;
      ELSE
          DBMS_OUTPUT.PUT_LINE('La ANALISTA:' || ANALISTA || ' considera ' || N_CONT4 ||
                                 ' registro(s) en la SNGAS2 para el campo SNG001EJEC del insert a la SNG001.' || CHR(13) ||
                                 'No se realizó el Insert.');
      END IF;  
    ELSE
       DBMS_OUTPUT.PUT_LINE('El valor N_SNG001ORI no es 0, 14, 4, 13.'|| CHR(13) ||
                             'No se realizó el Insert.');
    END IF;
  ELSE
    DBMS_OUTPUT.PUT_LINE('La instancia ingresada : ' || INSTANCIA || ' ya existe en la SNG001.' || CHR(13) ||
                               'No se realizó el Insert.');
  END IF;
insert into AQPB876 values (user,sysdate,'SP_CR_ANALISTA_SNG001',   CTA||'-'||INSTANCIA||'-'||ANALISTA||'-'||N_SNG001ORI);
commit;
END SP_CR_ANALISTA_SNG001;
/

