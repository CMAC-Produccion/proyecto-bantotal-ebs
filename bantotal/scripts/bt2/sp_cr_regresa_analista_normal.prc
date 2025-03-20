CREATE OR REPLACE PROCEDURE SP_CR_REGRESA_ANALISTA_NORMAL(LN_INS NUMBER) IS
  CURSOR CREDITOS(CD_FEC IN DATE) IS
--    SELECT *
     SELECT /*+index(B JAQZ6972)*/*
      FROM JAQM80 A, JAQZ697 B
     WHERE A.JAQM80SO = LN_INS --COLOCAR LA INSTANCIA
       AND A.JAQM80PA = B.JAQZ697PAI
       AND A.JAQM80TD = B.JAQZ697TDO
       AND A.JAQM80ND = B.JAQZ697NDO
       AND A.JAQM80FC = B.JAQZ697FAN
       AND B.JAQZ697AU5 = 'G'
       AND B.JAQZ697FEP = CD_FEC;
  LN_ID  NUMBER(10);
  LD_FEC DATE;
  N_CONT NUMBER;
BEGIN

  BEGIN
    SELECT MAX(A.JAQZ697FEP) INTO LD_FEC FROM JAQZ697 A;
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

  FOR I IN CREDITOS(LD_FEC) LOOP
    SELECT COUNT(*)
      INTO N_CONT
      FROM WFWRKITEMS A
     WHERE A.WFINSPRCID = I.JAQM80SO
       AND A.WFITEMSTSACT = 1;
    IF N_CONT <> 0 THEN
      BEGIN
        SELECT A.WFITEMID
          INTO LN_ID
          FROM WFWRKITEMS A
         WHERE A.WFINSPRCID = I.JAQM80SO
           AND A.WFITEMSTSACT = 1;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    
      EXECUTE IMMEDIATE 'create table operador.wfworklist_' ||
                        TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                        SUBSTR(USER, 1, 3) ||
                        ' as select * from wfworklist ' ||
                        'where wfwrklstitemid =' || LN_ID;
    
      DELETE FROM WFWORKLIST C WHERE C.WFWRKLSTITEMID = LN_ID;
      COMMIT;
    
      EXECUTE IMMEDIATE 'create table operador.wfwrkitems_' ||
                        TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                        SUBSTR(USER, 1, 3) ||
                        ' as select * from wfwrkitems ' ||
                        'where wfinsprcid =' || I.JAQM80SO ||
                        ' and wfitemstsact=1';
    
      UPDATE WFWRKITEMS A
         SET WFSTSCOD = 'B', WFITEMSTSACT = 0, WFITEMEND = SYSDATE
       WHERE A.WFINSPRCID = I.JAQM80SO
         AND A.WFITEMSTSACT = 1;
      COMMIT;
    
      EXECUTE IMMEDIATE 'create table operador.wfinstprc_' ||
                        TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                        SUBSTR(USER, 1, 3) ||
                        ' as select * from wfinstprc ' ||
                        'where wfinsprcid =' || I.JAQM80SO;
    
      UPDATE WFINSTPRC B
         SET WFINSPRCSTA = 'B', WFINSPRCOSTA = 0, WFINSPRCEND = SYSDATE
       WHERE B.WFINSPRCID = I.JAQM80SO;
      COMMIT;
    
      EXECUTE IMMEDIATE 'create table operador.aqpa868_' ||
                        TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                        SUBSTR(USER, 1, 3) || ' as select * from aqpa868 ' ||
                        'where aqpa868id =' || I.JAQM80ID;
    
      DELETE FROM AQPA868 A WHERE A.AQPA868ID = I.JAQM80ID;
      COMMIT;
    
      EXECUTE IMMEDIATE 'create table operador.jaqz697_' ||
                        TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                        SUBSTR(USER, 1, 3) ||
                        ' as select * from jaqz697 a ' ||
                        'where a.jaqz697fep = to_date(''' ||
                        TO_CHAR(I.JAQZ697FEP, 'YYYYMMDD') ||
                        ''',''YYYYMMDD'')';
    
      UPDATE JAQZ697 A
         SET A.JAQZ697AU5 = 'N', A.JAQZ697FAN = NULL
       WHERE A.JAQZ697FEP = I.JAQZ697FEP
         AND A.JAQZ697PAI = I.JAQZ697PAI
         AND A.JAQZ697TDO = I.JAQZ697TDO
         AND A.JAQZ697NDO = I.JAQZ697NDO
         AND A.JAQZ697AU5 <>'H';--29.11 indicado por Cinthya Liz Hernandez 
      COMMIT;
    
      EXECUTE IMMEDIATE 'create table operador.jaqm80_' ||
                        TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                        SUBSTR(USER, 1, 3) || ' as select * from jaqm80 ' ||
                        'where jaqm80so =' || I.JAQM80SO;
    
      DELETE FROM JAQM80 A WHERE A.JAQM80SO = I.JAQM80SO;
      COMMIT;
    ELSE
      DBMS_OUTPUT.PUT_LINE('La solicitud: ' || I.JAQM80SO || ' considera ' ||
                           N_CONT || ' registro(s) en la WFWRKITEMS.' ||
                           CHR(13) || 'No se realizó el proceso.');
    END IF;
  END LOOP;
  COMMIT;
  insert into AQPB876 values (user,sysdate,'SP_CR_REGRESA_ANALISTA_NORMAL',   LN_INS);
  commit;
END SP_CR_REGRESA_ANALISTA_NORMAL;
/

