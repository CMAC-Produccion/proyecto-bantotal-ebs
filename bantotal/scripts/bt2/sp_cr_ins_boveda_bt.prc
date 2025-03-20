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

BEGIN
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

END SP_CR_INS_BOVEDA_BT;
 /* GOLDENGATE_DDL_REPLICATION */
/

