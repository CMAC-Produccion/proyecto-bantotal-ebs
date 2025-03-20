CREATE OR REPLACE PROCEDURE SP_CR_REVIVE_SOLICITUD(P_WFINSPRCID NUMBER, --INSTANCIA CREDITO
                                                   P_WFITEMID   NUMBER --ID
                                                   --                                              P_WFINSPRCSTA CHAR,--'U'
                                                   --                                              P_WFINSPRCOSTA NUMBER,--1
                                                   --                                              P_WFSTSCOD CHAR,'P' O 'R'
                                                   --                                              P_WFITEMSTSACT NUMBER--1
                                                   ) IS

  N_CONT1    NUMBER := 0;
  N_CONT2    NUMBER := 0;
  C_WFSTSCOD CHAR := '';
  N_TASK     NUMBER := 0;
BEGIN
  --LUIS CARPIO/ERIKA HIDALGO
  SELECT COUNT(*)
    INTO N_CONT1
    FROM WFINSTPRC C
   WHERE C.WFINSPRCID = P_WFINSPRCID;

  SELECT COUNT(*)
    INTO N_CONT2
    FROM WFWRKITEMS R
   WHERE R.WFINSPRCID = P_WFINSPRCID
     AND WFITEMID = P_WFITEMID;

  SELECT R.WFTASKCOD
    INTO N_TASK
    FROM WFWRKITEMS R
   WHERE R.WFINSPRCID = P_WFINSPRCID
     AND WFITEMID = P_WFITEMID;

  IF N_TASK < 55 THEN
    C_WFSTSCOD := 'P';
  ELSE
    IF N_TASK = 55 THEN
      C_WFSTSCOD := 'R';
    ELSE
      C_WFSTSCOD := '-';
    END IF;
  END IF;

  IF N_CONT1 = 1 AND N_CONT2 = 1 AND C_WFSTSCOD <> '-' THEN
    EXECUTE IMMEDIATE 'create table operador.wfinstprc_' ||
                      TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) || ' as select * from wfinstprc ' ||
                      'where wfinsprcid = ' || P_WFINSPRCID;
    EXECUTE IMMEDIATE 'create table operador.wfwrkitems_' ||
                      TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) || ' as select * from wfwrkitems ' ||
                      'where wfinsprcid = ' || P_WFINSPRCID ||
                      ' and wfitemid=' || P_WFITEMID;
    EXECUTE IMMEDIATE 'create table operador.WFWORKLIST_' ||
                      TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) || ' as select * from WFWORKLIST ' ||
                      'where WFWRKLSTITEMID = ' || P_WFITEMID;
  
    UPDATE WFINSTPRC C
       SET C.WFINSPRCSTA = 'U', C.WFINSPRCOSTA = 1
     WHERE C.WFINSPRCID = P_WFINSPRCID; -- 1 REGISTRO
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('SE ACTUALIZO wfinstprc, ' || N_CONT1 ||
                         ' registro.');
  
    --27.08.2020
    IF N_TASK = 55 THEN
      UPDATE WFWRKITEMS R
         SET R.WFSTSCOD     = C_WFSTSCOD /*'P' O 'R'*/,
             R.WFITEMSTSACT = 1,
             WFITEMROLCOD   = -1,
             WFITEMEND      = to_date('01-01-0001', 'dd-mm-yyyy'),
             WFITEMPRVSTA   = ' ',
             WFITEMUSRCOD   = null
       WHERE R.WFINSPRCID = P_WFINSPRCID
         AND WFITEMID = P_WFITEMID; --1 REGISTRO
      COMMIT;
      DBMS_OUTPUT.PUT_LINE('SE ACTUALIZO wfwrkitems, ' || N_CONT2 ||
                           ' registro.');
    
      /*DELETE FROM WFWORKLIST K WHERE K.WFWRKLSTITEMID = P_WFITEMID;
      INSERT INTO WFWORKLIST
        SELECT P_WFITEMID, A.WFUSRCOD, 11
          FROM WFROLES1 A
         WHERE WFROLCOD = 11;
      COMMIT;*/
    
      DELETE FROM WFWORKLIST K WHERE K.WFWRKLSTITEMID = P_WFITEMID;
      
      begin
        INSERT INTO WFWORKLIST
          SELECT P_WFITEMID, w.wfitemusrcod, -1
            FROM wfwrkitems w
           where w.wfitemid = P_WFITEMID
             and w.wfinsprcid = P_WFINSPRCID;
      exception
        when others then
          begin
            INSERT INTO WFWORKLIST
              SELECT P_WFITEMID, A.WFUSRCOD, 11
                FROM WFROLES1 A
               WHERE WFROLCOD = 11;
          end;
        
      end;
    
      COMMIT;
    
      DBMS_OUTPUT.PUT_LINE('SE ELIMINÓ E INSERTO WFWORKLIST para P_WFITEMID:' ||
                           P_WFITEMID);
    ELSE
      UPDATE WFWRKITEMS R
         SET R.WFSTSCOD     = C_WFSTSCOD /*'P' O 'R'*/,
             R.WFITEMSTSACT = 1,
             WFITEMEND      = to_date('01-01-0001', 'dd-mm-yyyy')
       WHERE R.WFINSPRCID = P_WFINSPRCID
         AND WFITEMID = P_WFITEMID; --1 REGISTRO
      COMMIT;
      DBMS_OUTPUT.PUT_LINE('SE ACTUALIZO wfwrkitems, ' || N_CONT2 ||
                           ' registro.');
    
      DELETE FROM WFWORKLIST K WHERE K.WFWRKLSTITEMID = P_WFITEMID;
      INSERT INTO WFWORKLIST
        SELECT w.wfitemid, w.wfitemusrcod, -1
          FROM wfwrkitems w
         where w.wfitemid = P_WFITEMID
           and w.wfinsprcid = P_WFINSPRCID;
      COMMIT;
    
      DBMS_OUTPUT.PUT_LINE('SE ELIMINÓ E INSERTO WFWORKLIST para P_WFITEMID:' ||
                           P_WFITEMID);
    
    END IF;
  
  ELSE
    IF N_CONT1 <> 1 THEN
      DBMS_OUTPUT.PUT_LINE('La instancia de crédito:' || P_WFINSPRCID ||
                           ' considera ' || N_CONT1 ||
                           ' registro(s) para el update a la WFINSTPRC.' ||
                           CHR(13) || 'No se realizó el Update.');
    END IF;
    IF N_CONT2 <> 1 THEN
      DBMS_OUTPUT.PUT_LINE('La instancia de crédito:' || P_WFINSPRCID ||
                           ' El id:' || P_WFITEMID || ' consideran ' ||
                           N_CONT2 ||
                           ' registro(s) para el update a la WFWRKITEMS.' ||
                           CHR(13) || 'No se realizó el Update.');
    END IF;
    IF C_WFSTSCOD = '-' THEN
      DBMS_OUTPUT.PUT_LINE('La instancia de crédito:' || P_WFINSPRCID ||
                           ' y El id:' || P_WFITEMID ||
                           ' consideran TASK=' || N_TASK ||
                           ' que no es <= 55 en la WFWRKITEMS.' || CHR(13) ||
                           'No se realizó el Update.');
    END IF;
  END IF;

  insert into AQPB876
  values
    (user,
     sysdate,
     'SP_CR_REVIVE_SOLICITUD',
     P_WFINSPRCID || '-' || P_WFITEMID);
  commit;

END SP_CR_REVIVE_SOLICITUD;
/

