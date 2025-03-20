CREATE OR REPLACE PROCEDURE SP_AH_PEP_NO_FAM(P_PAIS   IN NUMBER,
                                             P_TDOC   IN NUMBER,
                                             P_NDOC   IN VARCHAR,
                                             P_FECHOY IN DATE,
                                             P_RESCOD OUT NUMBER,
                                             P_RESMSG OUT VARCHAR,
                                             P_ERRCOD OUT VARCHAR,
                                             P_ERRMSG OUT VARCHAR) IS

  -- ***************************************************************************************
  -- Nombre                     : SP_AH_PEP_NO_FAM
  -- Sistema                    : BANTOTAL
  -- Módulo                     : OCUM
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2023.05.10
  -- Autor de Creación          : CVILLON
  -- Uso                        : PEP sin Familiares Registrados en BT
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2024.03.07
  -- Modificado                 : CVILLON
  -- Descripción                : Exceptua Directores y Colaboradores
  -- ***************************************************************************************

  ln_FAMBT NUMBER(3); -- Familiares Registrados en BT
  ln_FAMEX NUMBER(3); -- Familiares Registrados AQPB504A
  ln_FAM   NUMBER(3); -- Familiares Total
  ln_PEP   NUMBER(2); -- Es PEP
  ln_INF   NUMBER(2); -- Registro NO Caduca
  ---***
  ln_DIR NUMBER(2); -- Es Director
  ln_COL NUMBER(2); -- Es Colaborador
  ---***

  lc_NDOC CHAR(12);
  ld_FDES DATE;
  ld_FHAS DATE;

BEGIN
  ---***
  ln_FAMBT := 0;
  ln_FAMEX := 0;
  ln_FAM   := 0;
  ln_PEP   := 0;
  ln_INF   := 0;
  ---***
  P_RESCOD := 0; -- (0 NO es PEP, 1 es PEP, 2 es PEP y NO tiene FAM Registrados)
  P_RESMSG := '';
  P_ERRCOD := '000';
  P_ERRMSG := '';
  ---***
  lc_NDOC := TRIM(P_NDOC);
  ---***

  ---*** Si es DIRECTOR, Ya no es necesario Validar
  SELECT COUNT(*)
    INTO ln_DIR
    FROM AQPA301
   WHERE AQPA301CARG = 1
     AND AQPA301EST = 'S'
     AND AQPA301PAIS = P_PAIS
     AND AQPA301TDOC = P_TDOC
     AND AQPA301NDOC = lc_NDOC;

  ---*** Si es COLABORADOR, Ya no es necesario Validar
  SELECT COUNT(*)
    INTO ln_COL
    FROM FSD002
   WHERE PFPAIS = P_PAIS
     AND PFTDOC = P_TDOC
     AND PFNDOC = lc_NDOC
     AND PFEBCO = 'S';

  ---***
  IF ((ln_DIR + ln_COL) > 0) THEN
    P_RESCOD := 0;
    P_RESMSG := 'Es DIRECTOR/COLABORADOR: ' || P_PAIS || '-' || P_TDOC || '-' ||
                P_NDOC;
    P_ERRCOD := '000';
    P_ERRMSG := '';
    RETURN;
  END IF;
  ---***

  ---*** DETERMINAR SI CLIENTE ES PEP (GUIA DE LISTAS DE PEP)
  FOR XROW IN (SELECT *
                 FROM FST198
                WHERE TP1COD = 1
                  AND TP1COD1 = 11146
                  AND TP1CORR2 = 56) LOOP
  
    FOR YROW IN (SELECT *
                   FROM FSD201
                  WHERE TLIS = XROW.TP1NRO1
                    AND LNPAIS = P_PAIS
                    AND LNTDOC = P_TDOC
                    AND LNNDOC = lc_NDOC) LOOP
    
      ld_FDES := YROW.LNMOFDES;
      ld_FHAS := YROW.LNMOFHAS;
    
      --dbms_output.put_line('ld_FDES: '||ld_FDES);
      --dbms_output.put_line('ld_FHAS: '||ld_FHAS);
    
      /*
      INSERT INTO CV_PEP(P_SP,P_CTA,P_FECHOY,P_RESCOD,P_RESMSG,P_ERRCOD,P_ERRMSG)
      VALUES('SP_AH_PEP_NO_FAM(3)', 3, ld_FDES, P_RESCOD, P_RESMSG, P_ERRCOD, P_ERRMSG);
      COMMIT;
      
      INSERT INTO CV_PEP(P_SP,P_CTA,P_FECHOY,P_RESCOD,P_RESMSG,P_ERRCOD,P_ERRMSG)
      VALUES('SP_AH_PEP_NO_FAM(4)', 4, ld_FHAS, P_RESCOD, P_RESMSG, P_ERRCOD, P_ERRMSG);
      COMMIT;
      */
    
      IF (ld_FDES IS NOT NULL) THEN
        --dbms_output.put_line('Registro PEP encontrado, Verificar Vigencia ...');
      
        IF (ld_FHAS = TO_DATE('01/01/0001', 'dd/mm/yyyy') OR
           ld_FHAS IS NULL) THEN
          ln_INF := 1;
          /*
          INSERT INTO CV_PEP(P_SP,P_CTA,P_FECHOY,P_RESCOD,P_RESMSG,P_ERRCOD,P_ERRMSG)
          VALUES('SP_AH_PEP_NO_FAM(5)', 5, ld_FHAS, P_RESCOD, P_RESMSG, P_ERRCOD, P_ERRMSG);
          COMMIT;
          */
        
          --dbms_output.put_line('ln_INF: '||ln_INF);
        END IF;
      
        IF (ln_INF = 1) THEN
          -- Registro NO Caduca
          IF (P_FECHOY >= ld_FDES) THEN
            ln_PEP := 1;
            --dbms_output.put_line('ln_PEP: '||ln_PEP);
          END IF;
        ELSE
          IF (P_FECHOY >= ld_FDES AND P_FECHOY <= ld_FHAS) THEN
            ln_PEP := 1;
            --dbms_output.put_line('ln_PEP: '||ln_PEP);
          END IF;
        END IF;
      ELSE
        P_RESCOD := 0;
        P_RESMSG := 'NO es PEP: ' || P_PAIS || '-' || P_TDOC || '-' ||
                    P_NDOC;
        P_ERRCOD := '000';
        P_ERRMSG := '';
      END IF;
      ---***
      ---*** SI ES PEP, Contar familiares registrados
      /*
      INSERT INTO CV_PEP(P_SP,P_CTA,P_FECHOY,P_RESCOD,P_RESMSG,P_ERRCOD,P_ERRMSG)
      VALUES('SP_AH_PEP_NO_FAM(2)', 2, P_FECHOY, P_RESCOD, P_RESMSG, P_ERRCOD, P_ERRMSG);
      COMMIT;
      */
    
      IF (ln_PEP = 1) THEN
        SELECT COUNT(*)
          INTO ln_FAMBT
          FROM FSR002
         WHERE (PEPAIS = P_PAIS AND PETDOC = P_TDOC AND PENDOC = lc_NDOC)
            OR (RPPAIS = P_PAIS AND RPTDOC = P_TDOC AND RPNDOC = lc_NDOC);
      
        IF (ln_FAMBT = 0) THEN
          SELECT COUNT(*)
            INTO ln_FAMEX
            FROM AQPB504A
           WHERE AQPB504APEPAIS = P_PAIS
             AND AQPB504APETDOC = P_TDOC
             AND AQPB504APENDOC = lc_NDOC;
        END IF;
        ---***
        ln_FAM := ln_FAMBT + ln_FAMEX;
        --dbms_output.put_line('ln_FAM: '||ln_FAM);
        ---***
        IF (ln_FAM = 0) THEN
          P_RESCOD := 2;
          P_RESMSG := 'PEP -> No tiene Familiares registrados: ' || P_PAIS || '-' ||
                      P_TDOC || '-' || P_NDOC;
          P_ERRCOD := '000';
          P_ERRMSG := '';
          RETURN;
        ELSE
          P_RESCOD := 1;
          P_RESMSG := 'PEP -> Si tiene Familiares registrados: ' || P_PAIS || '-' ||
                      P_TDOC || '-' || P_NDOC;
          P_ERRCOD := '000';
          P_ERRMSG := '';
        END IF;
      ELSE
        P_RESCOD := 0;
        P_RESMSG := 'NO es PEP: ' || P_PAIS || '-' || P_TDOC || '-' ||
                    P_NDOC;
        P_ERRCOD := '000';
        P_ERRMSG := '';
      END IF;
      ---***
    END LOOP;
  END LOOP;
  ---***
exception
  when others then
    P_ERRCOD := '101';
    P_ERRMSG := '(ERROR SP_AH_PEP_NO_FAM)::(' || sqlcode || ') -> ' ||
                sqlerrm;
  
END SP_AH_PEP_NO_FAM;
/

