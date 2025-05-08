CREATE OR REPLACE PROCEDURE "SP_CR_INS_BOVEDA_BT" IS
    -- *****************************************************************
    -- Nombre                     : SP_CR_INS_BOVEDA_BT
    -- Sistema                    : BANTOTAL
    -- Módulo                     : ADMINISTRATIVO
    -- Versión                    : 1.0
    -- Fecha de Creación          : 27/04/2021
    -- Autor de Creación          : EHIDALGOM
    -- Uso                        :
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 03/10/2024
    -- Autor de la Modificación   : EHIDALGOM/LCARPIO
    -- Descripción de Modificación: Diferencia de fechas en notifs o EECC por proceso offline
    -- Fecha de Modificación      : 26/03/2025
    -- Autor de la Modificación   : EHIDALGOM/LCARPIO/ACARDENAS
    -- Descripción de Modificación: Parametrización Carga Legal
    -- Fecha de Modificación      : 07/04/2025
    -- Autor de la Modificación   : EHIDALGOM/LCARPIO
    -- Descripción de Modificación: Operaciones monto cero y menores - Ro
    -- Fecha de Modificación      : 30/04/2025
    -- Autor de la Modificación   : EHIDALGOM/LCARPIO
    -- Descripción de Modificación: Insertar nuevas agencias RENIEC
    -- *****************************************************************
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  N_CONT1 NUMBER := 0;
  N_CONT2 NUMBER := 0;
  N_CONT3 NUMBER := 0;
  N_CONT4 NUMBER := 0;
  V_HOSTNAME varchar2(500);
  TYPE string_array IS TABLE OF VARCHAR2(1000);
  my_array_mails string_array := string_array('ehidalgom@cajaarequipa.pe', 'kcabrerac@cajaarequipa.pe', 'lcarpio@cajaarequipa.pe', 
                                        'jsanchez@cajaarequipa.pe', 'lchumbilla@cajaarequipa.pe','jcespedese@cajaarequipa.pe',
                                        'phuarza@cajaarequipa.pe','eaguilarf@cajaarequipa.pe','jmezacr@cajaarequipa.pe');
  my_array_mails_param string_array := string_array('ehidalgom@cajaarequipa.pe', 'kcabrerac@cajaarequipa.pe', 'lcarpio@cajaarequipa.pe', 
                                        'acardenas@cajaarequipa.pe');
  v_filas_insertadas1 NUMBER :=0;
  v_filas_insertadas2 NUMBER :=0;
  v_filas_eliminadas3 NUMBER :=0;
  v_filas_insertadas4 NUMBER :=0;
  C_FECHA  VARCHAR(100);
  v_email_body VARCHAR(4000) :='';
BEGIN
  C_FECHA := to_char(sysdate,'RRRR-MM-DD');
  SELECT HOST_NAME INTO V_HOSTNAME FROM V$INSTANCE;
  update FST746--LuisC 20240313
    set UBFECH=trunc(sysdate)
  where UBUSER in ('BOTPROREC','ROBOTADQUI','BOTJOYAD','BOTCAMTRA','BOTYAPLIN');
  commit;

  --LuisC 20240412
  UPDATE SEG002 F
     SET F.SEG002HRS = TO_CHAR(TO_DATE(SEG002HRI, 'hh24:mi:ss') +
                               DBMS_RANDOM.VALUE(5, 69) / 24 / 60,
                               'hh24:mi:ss')
   WHERE SEG002FCI = TRUNC(SYSDATE - 1)
     AND SEG002HRS IS NULL;
  commit;   
                
  update seg002 h
     set SEG002FCS = SEG002FCI,
         SEG002HRS = nvl((select min(i.seg002hri)
                           from seg002h i
                          where i.seg002pgc = 1
                            and i.seg002usu = h.seg002usu
                            and i.seg002fci = h.seg002fci
                            and i.seg002hri > h.seg002hri),
                         to_char(to_date(SEG002HRI, 'hh24:mi:ss') +
                                 dbms_random.value(5, 30) / 24 / 60,
                                 'hh24:mi:ss'))
   where SEG002FCI = trunc(sysdate - 1)
     and SEG002HRS = '        ';
                                                                
  UPDATE SEG002
     SET SEG002FCS = SEG002FCI + 1
   WHERE SEG002HRS < SEG002HRI
     AND SEG002FCI >= SEG002FCS
     AND SEG002FCI = TRUNC(SYSDATE - 1);
  commit;

  SELECT COUNT(1)
    INTO N_CONT3
    FROM FBC605 A
   WHERE A.BC604EMP = 1
     AND A.BC604FCH BETWEEN TRUNC(SYSDATE - 30) AND TRUNC(SYSDATE - 1)
     AND BC605NDOC = '99999999'; 

  IF N_CONT3>0 THEN
    UPDATE FBC605 A
       SET BC605NDOC = ' ', BC605PAIS = 0, BC605TDOC = 0
     WHERE A.BC604EMP = 1
       AND A.BC604FCH BETWEEN TRUNC(SYSDATE - 30) AND TRUNC(SYSDATE - 1)
       AND BC605NDOC = '99999999'; 
    COMMIT;

    sys.SP_SY_ENVIAMAIL('jobinsertabt@cajaarequipa.pe',
                        'ehidalgom@cajaarequipa.pe',
                        'Actualización RO FBC605 - ' ||
                        sys_context('USERENV', 'DB_NAME'),
                        'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                        'HOSTNAME=' || V_HOSTNAME || CHR(13) ||CHR(13) ||
                        'Se actualizaron: ' || n_cont3 || ' registros.' ||CHR(13));                                            
    sys.SP_SY_ENVIAMAIL('jobinsertabt@cajaarequipa.pe',
                        'kcabrerac@cajaarequipa.pe',
                        'Actualización RO FBC605 - ' ||
                        sys_context('USERENV', 'DB_NAME'),
                        'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                        'HOSTNAME=' || V_HOSTNAME || CHR(13) ||CHR(13) ||
                        'Se actualizaron: ' || n_cont3 || ' registros.' ||CHR(13));
    sys.SP_SY_ENVIAMAIL('jobinsertabt@cajaarequipa.pe',
                        'lcarpio@cajaarequipa.pe',
                        'Actualización RO FBC605 - ' ||
                        sys_context('USERENV', 'DB_NAME'),
                        'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                        'HOSTNAME=' || V_HOSTNAME || CHR(13) ||CHR(13) ||
                        'Se actualizaron: ' || n_cont3 || ' registros.' ||CHR(13));
  END IF;

  --LUIS CARPIO/ERIKA HIDALGO
  SELECT COUNT(9)
    INTO N_CONT1
    FROM FST001 L
   WHERE L.PGCOD = 1
     AND L.SUCURS < 800
     AND L.SUCURS NOT IN (SELECT TP1CORR3
                            FROM FST198 O
                           WHERE O.TP1COD = 1
                             AND O.TP1COD1 = 2014
                             AND O.TP1CORR1 = 3);


  SELECT COUNT(9)
    INTO N_CONT2
    FROM (SELECT *
            FROM FST198
           WHERE (TP1COD, TP1COD1, TP1CORR1, TP1CORR2, TP1CORR3) IN
                 (SELECT 1, 2014, 3, 1, L.SUCURS
                    FROM FST001 L
                   WHERE L.PGCOD = 1
                     AND L.SUCURS < 800
                     AND L.SUCURS NOT IN
                         (SELECT O.TP1CORR3
                            FROM FST198 O
                           WHERE O.TP1COD = 1
                             AND O.TP1COD1 = 2014
                             AND O.TP1CORR1 = 3)));

  IF N_CONT1 > 0 and N_CONT2 =0 THEN
    INSERT INTO FST198
      SELECT 1,             2014,             3,             1,             L.SUCURS,
             0,             0,             0,             'BOVEDA ' || L.SUCURS,             0,
             0,             0
        FROM FST001 L
       WHERE L.PGCOD = 1
         AND L.SUCURS < 800
         AND L.SUCURS NOT IN (SELECT O.TP1CORR3
                                FROM FST198 O
                               WHERE O.TP1COD = 1
                                 AND O.TP1COD1 = 2014
                                 AND O.TP1CORR1 = 3);
    commit;

    sys.SP_SY_ENVIAMAIL('jobinsertabt@cajaarequipa.pe',
                        'ehidalgom@cajaarequipa.pe',
                        'Inserta Bóveda Bantotal - ' ||
                        sys_context('USERENV', 'DB_NAME'),
                        'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                        'HOSTNAME=' || V_HOSTNAME || CHR(13) ||CHR(13) ||
                        'Se insertaron: ' || n_cont1 || ' registros.' ||
                        CHR(13) || CHR(13) ||
                        'SELECT 1, 2014, 3, 1, L.SUCURS, 0, 0, 0, ''BOVEDA '' || L.SUCURS, 0, 0, 0
                        FROM FST001 L
                       WHERE L.PGCOD = 1
                         AND L.SUCURS < 800
                         AND L.SUCURS NOT IN (SELECT O.TP1CORR3
                                              FROM FST198 O
                                             WHERE O.TP1COD = 1
                                               AND O.TP1COD1 = 2014
                                               AND O.TP1CORR1 = 3)' ||
                                            CHR(13));
                                            
    sys.SP_SY_ENVIAMAIL('jobinsertabt@cajaarequipa.pe',
                        'kcabrerac@cajaarequipa.pe',
                        'Inserta Bóveda Bantotal - ' ||
                        sys_context('USERENV', 'DB_NAME'),
                        'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                        'HOSTNAME=' || V_HOSTNAME || CHR(13) ||CHR(13) ||
                        'Se insertaron: ' || n_cont1 || ' registros.' ||
                        CHR(13) || CHR(13) ||
                        'SELECT 1, 2014, 3, 1, L.SUCURS, 0, 0, 0, ''BOVEDA '' || L.SUCURS, 0, 0, 0
                        FROM FST001 L
                       WHERE L.PGCOD = 1
                         AND L.SUCURS < 800
                         AND L.SUCURS NOT IN (SELECT O.TP1CORR3
                                              FROM FST198 O
                                             WHERE O.TP1COD = 1
                                               AND O.TP1COD1 = 2014
                                               AND O.TP1CORR1 = 3)' ||
                                            CHR(13));                                            
    sys.SP_SY_ENVIAMAIL('jobinsertabt@cajaarequipa.pe',
                        'lcarpio@cajaarequipa.pe',
                        'Inserta Bóveda Bantotal - ' ||
                        sys_context('USERENV', 'DB_NAME'),
                        'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                        'HOSTNAME=' || V_HOSTNAME || CHR(13) ||CHR(13) ||
                        'Se insertaron: ' || n_cont1 || ' registros.' ||
                        CHR(13) || CHR(13) ||
                        'SELECT 1, 2014, 3, 1, L.SUCURS, 0, 0, 0, ''BOVEDA '' || L.SUCURS, 0, 0, 0
                        FROM FST001 L
                       WHERE L.PGCOD = 1
                         AND L.SUCURS < 800
                         AND L.SUCURS NOT IN (SELECT O.TP1CORR3
                                              FROM FST198 O
                                             WHERE O.TP1COD = 1
                                               AND O.TP1COD1 = 2014
                                               AND O.TP1CORR1 = 3)' ||
                                            CHR(13));
    sys.SP_SY_ENVIAMAIL('jobinsertabt@cajaarequipa.pe',
                        'jsanchez@cajaarequipa.pe',
                        'Inserta Bóveda Bantotal - ' ||
                        sys_context('USERENV', 'DB_NAME'),
                        'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                        'HOSTNAME=' || V_HOSTNAME || CHR(13) ||CHR(13) ||
                        'Se insertaron: ' || n_cont1 || ' registros.' ||
                        CHR(13) || CHR(13) ||
                        'SELECT 1, 2014, 3, 1, L.SUCURS, 0, 0, 0, ''BOVEDA '' || L.SUCURS, 0, 0, 0
                        FROM FST001 L
                       WHERE L.PGCOD = 1
                         AND L.SUCURS < 800
                         AND L.SUCURS NOT IN (SELECT O.TP1CORR3
                                              FROM FST198 O
                                             WHERE O.TP1COD = 1
                                               AND O.TP1COD1 = 2014
                                               AND O.TP1CORR1 = 3)' ||
                                            CHR(13));

    sys.SP_SY_ENVIAMAIL('jobinsertabt@cajaarequipa.pe',
                        'rarma@cajaarequipa.pe',
                        'Inserta Bóveda Bantotal - ' ||
                        sys_context('USERENV', 'DB_NAME'),
                        'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                        'HOSTNAME=' || V_HOSTNAME || CHR(13) ||CHR(13) ||
                        'Se insertaron: ' || n_cont1 || ' registros.' ||
                        CHR(13) || CHR(13) ||
                        'SELECT 1, 2014, 3, 1, L.SUCURS, 0, 0, 0, ''BOVEDA '' || L.SUCURS, 0, 0, 0
                        FROM FST001 L
                       WHERE L.PGCOD = 1
                         AND L.SUCURS < 800
                         AND L.SUCURS NOT IN (SELECT O.TP1CORR3
                                              FROM FST198 O
                                             WHERE O.TP1COD = 1
                                               AND O.TP1COD1 = 2014
                                               AND O.TP1CORR1 = 3)' ||
                                            CHR(13));

  END IF;

--Luis C. Diferencia de fechas en notifs o EECC por proceso offline

  SELECT COUNT(1) 
    INTO N_CONT4 
    FROM  FST034
     WHERE TRHABT = 'S'
       AND PGCOD = 1
       AND TRMOD IN (66, 140, 490, 489, 493, 488, 486, 487, 181)
       AND (TRMOD, TRNRO) NOT IN (SELECT TP1CORR2, TP1CORR3
                                    FROM FST198
                                   WHERE TP1COD = 1
                                     AND TP1COD1 = 10822
                                     AND TP1CORR1 = 4);

  IF N_CONT4>0 THEN
    INSERT INTO FST198
      SELECT 1, 10822, 4, TRMOD, TRNRO, 2, 0, 0, TRNOM, 0, 0, 0
        FROM FST034
       WHERE TRHABT = 'S'
         AND PGCOD = 1
         AND TRMOD IN (66, 140, 490, 489, 493, 488, 486, 487, 181)
         AND (TRMOD, TRNRO) NOT IN (SELECT TP1CORR2, TP1CORR3
                                      FROM FST198
                                     WHERE TP1COD = 1
                                       AND TP1COD1 = 10822
                                       AND TP1CORR1 = 4);
    COMMIT;

    FOR i in 1..my_array_mails.COUNT LOOP
      sys.SP_SY_ENVIAMAIL('actualiza@cajaarequipa.pe',
                            my_array_mails(i),--'ehidalgom@cajaarequipa.pe',
                            'Inserción Diferencia de fechas en notifs o EECC por proceso offline - ' ||
                            sys_context('USERENV', 'DB_NAME'),
                            'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                            'HOSTNAME=' || V_HOSTNAME || CHR(13) ||CHR(13) ||
                            'Se insertaron: ' || N_CONT4 || ' registros.' ||CHR(13));                                            
    END LOOP;
  END IF;


---Adiciona carga legal Parametrización
  BEGIN
---inserto nuevas sucursales
    INSERT INTO FST198
      SELECT 1,
             10821,
             1,
             1,
             (SELECT MAX(TP1CORR3)
                FROM FST198 A
               WHERE TP1COD = 1
                 AND TP1COD1 = 10821
                 AND TP1CORR1 = 1) + ROWNUM,
             X.SUCURS,
             0,
             0,
             X.TP1DESC,
             0,
             0,
             0
        FROM (SELECT SUCURS, TP1DESC
                FROM FST198 A, FST001 B
               WHERE TP1COD = 1
                 AND TP1COD1 = 10821
                 AND TP1CORR1 = 1
                 AND TP1NRO1 = 1
                 AND A.TP1COD = 1
                 AND (B.SUCURS < 800 OR B.SUCURS = 904)
              MINUS
              SELECT TP1NRO1, TP1DESC
                FROM FST198 A
               WHERE TP1COD = 1
                 AND TP1COD1 = 10821
                 AND TP1CORR1 = 1) X;
    v_filas_insertadas1 := SQL%ROWCOUNT;
    commit;
  END;

  BEGIN
    --inserto nuevos usuarios
    INSERT INTO FST198
    SELECT 1,
           10821,
           1,
           1,
           (SELECT MAX(TP1CORR3)
              FROM FST198 A
             WHERE TP1COD = 1
               AND TP1COD1 = 10821
               AND TP1CORR1 = 1) + ROWNUM,
           X.SUCURS,
           0,
           0,
           X.CAMPO,
           0,
           0,
           0
      FROM (SELECT B.SUCURS, RPAD(TRIM(A.UBUSER), 10, ' ') || '/L' CAMPO
              FROM PRFU00 A, FST001 B
             WHERE A.PGCOD = 1
               AND PRFGCOD = 'ALEG00'
               AND A.PGCOD = B.PGCOD
               AND (SUCURS < 800 OR SUCURS = 904)
            MINUS
            SELECT TP1NRO1, TRIM(TP1DESC)
              FROM FST198
             WHERE TP1COD = 1
               AND TP1COD1 = 10821
               AND TP1CORR1 = 1) X;
    v_filas_insertadas2 := SQL%ROWCOUNT;
    commit;
  END;

  BEGIN
    --depuro usuarios
    DELETE FROM FST198 A
     WHERE TP1COD = 1
       AND TP1COD1 = 10821
       AND TP1CORR1 = 1
       AND TP1CORR2 = 1
       AND (TP1NRO1, TRIM(TP1DESC)) IN
           (SELECT TP1NRO1, TRIM(TP1DESC) CAMPO
              FROM FST198
             WHERE TP1COD = 1
               AND TP1COD1 = 10821
               AND TP1CORR1 = 1
            MINUS
            SELECT B.SUCURS, RPAD(TRIM(A.UBUSER), 10, ' ') || '/L'
              FROM PRFU00 A, FST001 B
             WHERE A.PGCOD = 1
               AND PRFGCOD = 'ALEG00'
               AND A.PGCOD = B.PGCOD
               AND (SUCURS < 800 OR SUCURS = 904));
    v_filas_eliminadas3 := SQL%ROWCOUNT;
    commit;
  END;

  DECLARE
    CA1      NUMBER(17, 0);
    VA1      NUMBER(17, 0);
    CANTIDAD NUMBER(17, 0);

    CURSOR BASE IS
      SELECT *
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 10821
         AND TP1CORR1 = 1
       ORDER BY TP1CORR3;
  BEGIN
    CANTIDAD := 1;
    VA1      := 0;
    FOR I IN BASE LOOP
      CA1 := I.TP1CORR3;
      IF CA1 <> CANTIDAD THEN
        UPDATE FST198
           SET TP1CORR3 = CANTIDAD
         WHERE TP1COD = 1
           AND TP1COD1 = 10821
           AND TP1CORR1 = 1
           AND TP1CORR2 = 1
           AND TP1CORR3 = CA1;
        COMMIT;
        VA1 := VA1 + 1;
      END IF;
      CANTIDAD := CANTIDAD + 1;
    END LOOP;
    v_filas_insertadas4 := VA1;
  END;

  IF V_FILAS_INSERTADAS1 > 0 or V_FILAS_INSERTADAS2 > 0 or V_FILAS_ELIMINADAS3 > 0 or V_FILAS_INSERTADAS4 > 0 THEN
     IF v_filas_insertadas1>0 then
        v_email_body:= v_email_body || 'Se inserto '||v_filas_insertadas1||' registros en agencias.' ||CHR(13);
     END IF;
     IF v_filas_insertadas2>0 then
        v_email_body:= v_email_body || 'Se inserto '||v_filas_insertadas2||' registros por usuarios.' ||CHR(13);
     END IF;
     IF v_filas_eliminadas3>0 then
        v_email_body:= v_email_body || 'Se elimino '||v_filas_eliminadas3||' registros de usuarios.' ||CHR(13);
     END IF;
     IF v_filas_insertadas4>0 then
        v_email_body:= v_email_body || 'Se reenumero '||v_filas_insertadas4||' alertas.' ||CHR(13);
     END IF;

     FOR i in 1..my_array_mails_param.COUNT LOOP
        sys.SP_SY_ENVIAMAIL('adicionaparametrizacion@cajaarequipa.pe',
                              my_array_mails_param(i),--'ehidalgom@cajaarequipa.pe',
                              'Parametriza1: Adiciona carga legal - ' ||
                              sys_context('USERENV', 'DB_NAME')||' - '||C_FECHA,
                              'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                              'HOSTNAME=' || V_HOSTNAME || CHR(13) ||CHR(13) ||
                              /*'Se inserto '||v_filas_insertadas1||' registros en agencias.' ||CHR(13) ||
                              'Se inserto '||v_filas_insertadas2||' registros por usuarios.' ||CHR(13) ||
                              'Se elimino '||v_filas_eliminadas3||' registros de usuarios.' ||CHR(13) ||
                              'Se reenumero '||v_filas_insertadas4||' alertas.' ||CHR(13)*/v_email_body);
     END LOOP;
  END IF;

-------Operaciones monto cero y menores - Ro

  UPDATE FBC604 A
     SET BC604MDA  =
         (SELECT HMDA
            FROM FSH016 H
           WHERE H.PGCOD = 1
             AND H.HCMOD = BC604MOD
             AND HTRAN = BC604TRN
             AND HSUCOR = A.BC604SUC
             AND HNREL = A.BC604NREL
             AND HFCON = A.BC604FCH
             AND H.HCORD = A.BC604ORD),
         BC604IMP1 =
         (SELECT ROUND(HCIMP1 *
                       DECODE(HMDA,
                              0,
                              1 / ((SELECT MAX(TCCPA)
                                      FROM FSD120
                                     WHERE TCFCH >= TRUNC(SYSDATE - 1, 'MM')
                                       AND TCFCH <= TRUNC(LAST_DAY(SYSDATE - 1))
                                       AND TCCOD = 999)),
                              1),
                       2)
            FROM FSH016 H
           WHERE H.PGCOD = 1
             AND H.HCMOD = BC604MOD
             AND HTRAN = BC604TRN
             AND HSUCOR = A.BC604SUC
             AND HNREL = A.BC604NREL
             AND HFCON = A.BC604FCH
             AND H.HCORD = A.BC604ORD),
         BC604TTRN  = 3,
         BC604IMPMO =
         (SELECT HCIMP1
            FROM FSH016 H
           WHERE H.PGCOD = 1
             AND H.HCMOD = BC604MOD
             AND HTRAN = BC604TRN
             AND HSUCOR = A.BC604SUC
             AND HNREL = A.BC604NREL
             AND HFCON = A.BC604FCH
             AND H.HCORD = A.BC604ORD)
   WHERE A.BC604EMP = 1
     AND BC604FCH = TRUNC(SYSDATE - 1)
     AND BC604IMP1 = 0;
  COMMIT;

  UPDATE FBC604 Y
     SET BC604TTRN = 1
   WHERE Y.BC604EMP = 1
     AND Y.BC604FCH = TRUNC(SYSDATE - 1)
     AND BC604MOD = 18
     AND BC604IMP1 < 2500
     AND BC604TTRN = 3;
  COMMIT;
--Insertar nuevas agencias RENIEC
  INSERT INTO RENIEC.SYTAGEN
  SELECT 1, SUCURS, SCNOM, SCCALL, 'S'
    FROM FST001
   WHERE SUCURS < 500
     AND SUCURS NOT IN (SELECT C_CODAGE FROM RENIEC.SYTAGEN);
  COMMIT;

END SP_CR_INS_BOVEDA_BT;
 /* GOLDENGATE_DDL_REPLICATION */
/
