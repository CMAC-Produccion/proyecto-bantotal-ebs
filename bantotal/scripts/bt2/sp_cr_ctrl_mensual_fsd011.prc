CREATE OR REPLACE PROCEDURE "SP_CR_CTRL_MENSUAL_FSD011" IS
  N_CONT NUMBER := 0;
  LC_ERR VARCHAR2(1000);
BEGIN
  SELECT COUNT(*)
    INTO N_CONT
    FROM FSD011
   WHERE PGCOD = 1
     AND SCMOD = 442
     AND SCSDO = 0
     AND (SCCTA, SCOPER, SCRUB, SCSUC) IN
         (SELECT HCTA, HOPER, A.HRUBRO, HSUCUR
            FROM FSH016 A
           WHERE A.PGCOD = 1
             AND A.HSUCOR = 11
             AND A.HCMOD = 98
             AND A.HTRAN = 450
             AND A.HFCON = TRUNC(SYSDATE - 1)
             AND A.HMODUL = 442
             AND A.HCORD = 15);

  IF N_CONT > 0 THEN
    EXECUTE IMMEDIATE 'create table operador.fsd011_' ||
                      TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) || ' as select * from fsd011 ' ||
                      ' where pgcod = 1
   and scmod = 442
   and scsdo = 0
   and (sccta, scoper, scrub, scsuc) in
       (select hcta, hoper, a.hrubro, hsucur
          from fsh016 a
         where a.pgcod = 1
           and a.hsucor = 11
           and a.hcmod = 98
           and a.htran = 450
           and a.hfcon = trunc(sysdate - 1)
           and a.hmodul = 442
           and a.hcord = 15)';

    DELETE FROM FSD011
     WHERE PGCOD = 1
       AND SCMOD = 442
       AND SCSDO = 0
       AND (SCCTA, SCOPER, SCRUB, SCSUC) IN
           (SELECT HCTA, HOPER, A.HRUBRO, HSUCUR
              FROM FSH016 A
             WHERE A.PGCOD = 1
               AND A.HSUCOR = 11
               AND A.HCMOD = 98
               AND A.HTRAN = 450
               AND A.HFCON = TRUNC(SYSDATE - 1)
               AND A.HMODUL = 442
               AND A.HCORD = 15);

    COMMIT;
  END IF;
exception when others then
    LC_ERR := TO_CHAR('ERROR SP_CR_CTRL_MENSUAL_FSD011: '||SQLCODE||' - '||SQLERRM);
    sys.sp_sy_enviamail('ehidalgom@cajaarequipa.pe','ehidalgom@cajaarequipa.pe',
                          'BD='||sys_context('USERENV', 'DB_NAME') || ' - ' ||
                          'INSTANCE='||sys_context('USERENV', 'INSTANCE_NAME') || ' - ' ||
                          'ERROR SP_CR_CTRL_MENSUAL_FSD011',
                          'USER=' || USER || CHR(13) ||
                          'HOST=' || UPPER(SYS_CONTEXT('USERENV', 'TERMINAL')) || CHR(13) ||
                          'IP=' || SYS_CONTEXT('USERENV','IP_ADDRESS') || CHR(13) ||
                          'OSUSER=' || UPPER(SYS_CONTEXT('USERENV', 'OS_USER')) || CHR(13) ||
                          LC_ERR);
    sys.sp_sy_enviamail('kcabrerac@cajaarequipa.pe','kcabrerac@cajaarequipa.pe',
                          'BD='||sys_context('USERENV', 'DB_NAME') || ' - ' ||
                          'INSTANCE='||sys_context('USERENV', 'INSTANCE_NAME') || ' - ' ||
                          'ERROR SP_CR_CTRL_MENSUAL_FSD011',
                          'USER=' || USER || CHR(13) ||
                          'HOST=' || UPPER(SYS_CONTEXT('USERENV', 'TERMINAL')) || CHR(13) ||
                          'IP=' || SYS_CONTEXT('USERENV','IP_ADDRESS') || CHR(13) ||
                          'OSUSER=' || UPPER(SYS_CONTEXT('USERENV', 'OS_USER')) || CHR(13) ||
                          LC_ERR);
END SP_CR_CTRL_MENSUAL_FSD011;
 /* GOLDENGATE_DDL_REPLICATION */
/

