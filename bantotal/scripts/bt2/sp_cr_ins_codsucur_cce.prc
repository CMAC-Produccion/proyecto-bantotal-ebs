CREATE OR REPLACE PROCEDURE "SP_CR_INS_CODSUCUR_CCE" IS
  N_CONT1    NUMBER := 0;
  N_CONT2    NUMBER := 0;  
  V_HOSTNAME varchar2(500);
  -- *****************************************************************
  -- Nombre                     : SP_CR_INS_CODSUCUR_CCE
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Agencias Bantotal
  -- Versión                    : 1.0
  -- Fecha de Creación          : 27/04/2021
  -- Autor de Creación          : ERIKA HIDALGO/LUIS CARPIO
  -- Uso                        : alerta para ingresar sucursales nuevas
  -- Estado                     : Activo
  -- Parámetros de Entrada      :
  -- Fecha de Modificación      : 14/11/2023
  -- Autor de Modificación      : ERIKA HIDALGO/LUIS CARPIO

BEGIN
  SELECT HOST_NAME INTO V_HOSTNAME FROM V$INSTANCE;
  --LUIS CARPIO/ERIKA HIDALGO
  SELECT COUNT(9)
    INTO N_CONT1
    FROM (SELECT 1, 25000, O.SUCURS, O.SUCURS, O.SCNOM, 0
            FROM FST001 O
           WHERE O.PGCOD = 1
             AND O.SUCURS IN (SELECT O.SUCURS
                                FROM FST001 O
                               WHERE O.PGCOD = 1
                                 AND O.SUCURS < 800
                              MINUS
                              SELECT TPNRO
                                FROM FST098
                               WHERE PGCOD = 1
                                 AND TPCOD = 25000));
  SELECT COUNT(9)
    INTO N_CONT2
  FROM FST098
   WHERE (PGCOD, TPCOD, TPCORR) IN
         (SELECT PGCOD, TPCOD, TPCORR
            FROM (SELECT 1        PGCOD,
                         25000    TPCOD,
                         O.SUCURS TPCORR,
                         O.SUCURS,
                         O.SCNOM,
                         0
                    FROM FST001 O
                   WHERE O.PGCOD = 1
                     AND O.SUCURS IN (SELECT O.SUCURS
                                        FROM FST001 O
                                       WHERE O.PGCOD = 1
                                         AND O.SUCURS < 800
                                      MINUS
                                      SELECT TPNRO
                                        FROM FST098
                                       WHERE PGCOD = 1
                                         AND TPCOD = 25000)));
                                 
  IF N_CONT1 > 0 and N_CONT2=0 THEN
    INSERT INTO fst098
      SELECT 1, 25000, O.SUCURS, O.SUCURS, O.SCNOM, 0
        FROM FST001 O
       WHERE O.PGCOD = 1
         AND O.SUCURS IN (SELECT O.SUCURS
                            FROM FST001 O
                           WHERE O.PGCOD = 1
                             AND O.SUCURS < 800
                          MINUS
                          SELECT TPNRO
                            FROM FST098
                           WHERE PGCOD = 1
                             AND TPCOD = 25000);
    commit;
  
    sys.SP_SY_ENVIAMAIL('jobinsertabt@cajaarequipa.pe',
                         'ehidalgom@cajaarequipa.pe',
                         'Inserta códigos para sucursal CCE - ' ||
                         sys_context('USERENV', 'DB_NAME'),
                         'BD=' || sys_context('USERENV', 'DB_NAME') ||
                         CHR(13) || 'HOSTNAME=' || V_HOSTNAME || CHR(13) ||
                         CHR(13) || 'Se insertaron: ' || n_cont1 ||
                         ' registros.' || CHR(13) || CHR(13) ||
                         'SELECT 1,25000,O.SUCURS,O.SUCURS,O.SCNOM,0 FROM FST001 O WHERE O.PGCOD=1 AND O.SUCURS IN (
                        SELECT O.SUCURS FROM FST001 O WHERE O.PGCOD=1 AND O.SUCURS<800
                        MINUS
                        SELECT TPNRO FROM  FST098  WHERE PGCOD=1 AND TPCOD=25000)' ||
                         CHR(13)); 
    sys.SP_SY_ENVIAMAIL('jobinsertabt@cajaarequipa.pe',
                         'kcabrerac@cajaarequipa.pe',
                         'Inserta códigos para sucursal CCE - ' ||
                         sys_context('USERENV', 'DB_NAME'),
                         'BD=' || sys_context('USERENV', 'DB_NAME') ||
                         CHR(13) || 'HOSTNAME=' || V_HOSTNAME || CHR(13) ||
                         CHR(13) || 'Se insertaron: ' || n_cont1 ||
                         ' registros.' || CHR(13) || CHR(13) ||
                         'SELECT 1,25000,O.SUCURS,O.SUCURS,O.SCNOM,0 FROM FST001 O WHERE O.PGCOD=1 AND O.SUCURS IN (
                        SELECT O.SUCURS FROM FST001 O WHERE O.PGCOD=1 AND O.SUCURS<800
                        MINUS
                        SELECT TPNRO FROM  FST098  WHERE PGCOD=1 AND TPCOD=25000)' ||
                         CHR(13));                          
        sys.SP_SY_ENVIAMAIL('jobinsertabt@cajaarequipa.pe',
                            'lcarpio@cajaarequipa.pe',
                            'Inserta códigos para sucursal CCE - ' ||
                            sys_context('USERENV', 'DB_NAME'),
                            'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                            'HOSTNAME=' || V_HOSTNAME || CHR(13) ||CHR(13) ||
                            'Se insertaron: ' || n_cont1 || ' registros.' ||
                            CHR(13) || CHR(13) ||
                            'SELECT 1,25000,O.SUCURS,O.SUCURS,O.SCNOM,0 FROM FST001 O WHERE O.PGCOD=1 AND O.SUCURS IN (
                            SELECT O.SUCURS FROM FST001 O WHERE O.PGCOD=1 AND O.SUCURS<800
                            MINUS
                            SELECT TPNRO FROM  FST098  WHERE PGCOD=1 AND TPCOD=25000)' ||
                                                CHR(13));
        sys.SP_SY_ENVIAMAIL('jobinsertabt@cajaarequipa.pe',
                            'jsanchez@cajaarequipa.pe',
                            'Inserta códigos para sucursal CCE - ' ||
                            sys_context('USERENV', 'DB_NAME'),
                            'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                            'HOSTNAME=' || V_HOSTNAME || CHR(13) ||CHR(13) ||
                            'Se insertaron: ' || n_cont1 || ' registros.' ||
                            CHR(13) || CHR(13) ||
                            'SELECT 1,25000,O.SUCURS,O.SUCURS,O.SCNOM,0 FROM FST001 O WHERE O.PGCOD=1 AND O.SUCURS IN (
                            SELECT O.SUCURS FROM FST001 O WHERE O.PGCOD=1 AND O.SUCURS<800
                            MINUS
                            SELECT TPNRO FROM  FST098  WHERE PGCOD=1 AND TPCOD=25000)' ||
                                                CHR(13));
        sys.SP_SY_ENVIAMAIL('jobinsertabt@cajaarequipa.pe',
                            'rarma@cajaarequipa.pe',
                            'Inserta códigos para sucursal CCE - ' ||
                            sys_context('USERENV', 'DB_NAME'),
                            'BD=' || sys_context('USERENV', 'DB_NAME') || CHR(13) ||
                            'HOSTNAME=' || V_HOSTNAME || CHR(13) ||CHR(13) ||
                            'Se insertaron: ' || n_cont1 || ' registros.' ||
                            CHR(13) || CHR(13) ||
                            'SELECT 1,25000,O.SUCURS,O.SUCURS,O.SCNOM,0 FROM FST001 O WHERE O.PGCOD=1 AND O.SUCURS IN (
                            SELECT O.SUCURS FROM FST001 O WHERE O.PGCOD=1 AND O.SUCURS<800
                            MINUS
                            SELECT TPNRO FROM  FST098  WHERE PGCOD=1 AND TPCOD=25000)' ||
                                                CHR(13));
  
  END IF;
--sucursales de entidades nuevas cce 14.11.2023
  SELECT COUNT(9)
    INTO N_CONT1
    FROM TRANSFINTBANPR.TABAGENCIA
     WHERE TEMOACT = 'A'
       AND (TECBANC, TECOFIC) IN
           (SELECT TECBANC, TECOFIC
              FROM TRANSFINTBANPR.TABAGENCIA
             WHERE TECBANC IN (SELECT TRIM(ID_BANCO)
                                 FROM TRANSFINTBANPR.TRF_BANCO
                                WHERE BANCO_ETRAN = 1)
            MINUS
            SELECT LPAD(TO_CHAR(BANCO), 3, '0'), LPAD(TO_CHAR(SUCBCO), 3, '0')
              FROM FST092);
  IF N_CONT1>0 THEN
    INSERT INTO FST092
      SELECT TECBANC * 1, TECOFIC * 1, SUBSTR(TENOFIC, 1, 30), ID_DIST
        FROM TRANSFINTBANPR.TABAGENCIA
       WHERE TEMOACT = 'A'
         AND (TECBANC, TECOFIC) IN
             (SELECT TECBANC, TECOFIC
                FROM TRANSFINTBANPR.TABAGENCIA
               WHERE TECBANC IN (SELECT TRIM(ID_BANCO)
                                   FROM TRANSFINTBANPR.TRF_BANCO
                                  WHERE BANCO_ETRAN = 1)
              MINUS
              SELECT LPAD(TO_CHAR(BANCO), 3, '0'), LPAD(TO_CHAR(SUCBCO), 3, '0')
                FROM FST092);
    COMMIT;
    sys.SP_SY_ENVIAMAIL('jobinsertabt@cajaarequipa.pe',
                         'ehidalgom@cajaarequipa.pe',
                         'Inserta sucursales de entidades nuevas CCE - ' ||
                         sys_context('USERENV', 'DB_NAME'),
                         'BD=' || sys_context('USERENV', 'DB_NAME') ||
                         CHR(13) || 'HOSTNAME=' || V_HOSTNAME || CHR(13) ||
                         CHR(13) || 'Se insertaron: ' || n_cont1 ||
                         ' registros en FST092.' || CHR(13) || CHR(13)); 
    sys.SP_SY_ENVIAMAIL('jobinsertabt@cajaarequipa.pe',
                         'kcabrerac@cajaarequipa.pe',
                         'Inserta sucursales de entidades nuevas CCE - ' ||
                         sys_context('USERENV', 'DB_NAME'),
                         'BD=' || sys_context('USERENV', 'DB_NAME') ||
                         CHR(13) || 'HOSTNAME=' || V_HOSTNAME || CHR(13) ||
                         CHR(13) || 'Se insertaron: ' || n_cont1 ||
                         ' registros en FST092.' || CHR(13) || CHR(13)); 
    sys.SP_SY_ENVIAMAIL('jobinsertabt@cajaarequipa.pe',
                         'lcarpio@cajaarequipa.pe',
                         'Inserta sucursales de entidades nuevas CCE - ' ||
                         sys_context('USERENV', 'DB_NAME'),
                         'BD=' || sys_context('USERENV', 'DB_NAME') ||
                         CHR(13) || 'HOSTNAME=' || V_HOSTNAME || CHR(13) ||
                         CHR(13) || 'Se insertaron: ' || n_cont1 ||
                         ' registros en FST092.' || CHR(13) || CHR(13)); 
    sys.SP_SY_ENVIAMAIL('jobinsertabt@cajaarequipa.pe',
                         'jsanchez@cajaarequipa.pe',
                         'Inserta sucursales de entidades nuevas CCE - ' ||
                         sys_context('USERENV', 'DB_NAME'),
                         'BD=' || sys_context('USERENV', 'DB_NAME') ||
                         CHR(13) || 'HOSTNAME=' || V_HOSTNAME || CHR(13) ||
                         CHR(13) || 'Se insertaron: ' || n_cont1 ||
                         ' registros en FST092.' || CHR(13) || CHR(13)); 
  END IF;              

  select COUNT(9)
    INTO N_CONT2
      FROM FST092
     WHERE (BANCO, SUCBCO) NOT IN (SELECT BANCO, SUCBCO FROM FST091);              
  IF N_CONT2>0 THEN
    INSERT INTO FST091
      SELECT 0, 0, 500, BANCO, SUCBCO
        FROM FST092
       WHERE (BANCO, SUCBCO) NOT IN (SELECT BANCO, SUCBCO FROM FST091);
    COMMIT;
    sys.SP_SY_ENVIAMAIL('jobinsertabt@cajaarequipa.pe',
                         'ehidalgom@cajaarequipa.pe',
                         'Inserta sucursales de entidades nuevas CCE - ' ||
                         sys_context('USERENV', 'DB_NAME'),
                         'BD=' || sys_context('USERENV', 'DB_NAME') ||
                         CHR(13) || 'HOSTNAME=' || V_HOSTNAME || CHR(13) ||
                         CHR(13) || 'Se insertaron: ' || n_cont1 ||
                         ' registros en FST091.' || CHR(13) || CHR(13)); 
    sys.SP_SY_ENVIAMAIL('jobinsertabt@cajaarequipa.pe',
                         'kcabrerac@cajaarequipa.pe',
                         'Inserta sucursales de entidades nuevas CCE - ' ||
                         sys_context('USERENV', 'DB_NAME'),
                         'BD=' || sys_context('USERENV', 'DB_NAME') ||
                         CHR(13) || 'HOSTNAME=' || V_HOSTNAME || CHR(13) ||
                         CHR(13) || 'Se insertaron: ' || n_cont1 ||
                         ' registros en FST091.' || CHR(13) || CHR(13)); 
    sys.SP_SY_ENVIAMAIL('jobinsertabt@cajaarequipa.pe',
                         'lcarpio@cajaarequipa.pe',
                         'Inserta sucursales de entidades nuevas CCE - ' ||
                         sys_context('USERENV', 'DB_NAME'),
                         'BD=' || sys_context('USERENV', 'DB_NAME') ||
                         CHR(13) || 'HOSTNAME=' || V_HOSTNAME || CHR(13) ||
                         CHR(13) || 'Se insertaron: ' || n_cont1 ||
                         ' registros en FST091.' || CHR(13) || CHR(13)); 
    sys.SP_SY_ENVIAMAIL('jobinsertabt@cajaarequipa.pe',
                         'jsanchez@cajaarequipa.pe',
                         'Inserta sucursales de entidades nuevas CCE - ' ||
                         sys_context('USERENV', 'DB_NAME'),
                         'BD=' || sys_context('USERENV', 'DB_NAME') ||
                         CHR(13) || 'HOSTNAME=' || V_HOSTNAME || CHR(13) ||
                         CHR(13) || 'Se insertaron: ' || n_cont1 ||
                         ' registros en FST091.' || CHR(13) || CHR(13)); 
  END IF;

END SP_CR_INS_CODSUCUR_CCE;
 /* GOLDENGATE_DDL_REPLICATION */
/

