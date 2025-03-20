CREATE OR REPLACE PROCEDURE "SP_CA_UPD_Z0E478_482" IS

  -- *****************************************************************
  -- NOMBRE                     : SP_CA_UPD_Z0E478_482
  -- SISTEMA                    : BANTOTAL
  -- MÓDULO                     : DEPURACIÓN BANTOTAL
  -- VERSIÓN                    : 1.0
  -- FECHA DE CREACIÓN          : 2024/08/05
  -- AUTOR DE CREACIÓN          : ERIKA HIDALGO/LUIS CARPIO
  -- USO                        : DEPURACIÓN BANTOTAL
  -- ESTADO                     : ACTIVO
  -- PARÁMETROS DE ENTRADA      :
  -- FECHA DE MODIFICACIÓN      :
  -- AUTOR DE MODIFICACIÓN      :
  N_CONT  NUMBER := 0;
  V_ERROR VARCHAR2(4000);
BEGIN

  SELECT COUNT(1)
    INTO N_CONT
    FROM Z0E479
   WHERE Z0E479MOD = 21
     AND Z0E479TOP = 2
     AND Z0E480COD = 3;

  IF N_CONT > 0 THEN

    EXECUTE IMMEDIATE 'create table operador.z0e479_' ||
                      TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) ||
                      ' parallel (degree 4) nologging compress as select * from z0e479 A ' ||
                      'where A.Z0E479MOD=21 and A.Z0E479TOP=2 and A.Z0E480COD=3';
    UPDATE Z0E479
       SET Z0E480COD = 1
     WHERE Z0E479MOD = 21
       AND Z0E479TOP = 2
       AND Z0E480COD = 3; --1382
    COMMIT;

    EXECUTE IMMEDIATE 'create table operador.z0e482_' ||
                      TO_CHAR(SYSTIMESTAMP, 'RRMMDD_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) ||
                      ' parallel (degree 4) nologging compress as select * from z0e482 A ' ||
                      'where A.Z0E482MOD=21 and A.Z0E482TOP=2 and A.Z0E480COD=3';

    UPDATE Z0E482
       SET Z0E480COD = 1
     WHERE Z0E482MOD = 21
       AND Z0E482TOP = 2
       AND Z0E480COD = 3; --1382
    COMMIT;

    SYS.SP_SY_ENVIAMAIL('Controlbantotal@cajaarequipa.pe',
                        'ehidalgom@cajaarequipa.pe',
                        'Se depuró z0e479 & z0e482',
                        'BD=' || SYS_CONTEXT('USERENV', 'DB_NAME') ||
                        CHR(13) || 'INSTANCIA=' ||
                        SYS_CONTEXT('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                        'Hora Actual en Servidor : ' ||
                        TO_CHAR(SYSDATE, 'HH24:MI:SS') || CHR(13));

    SYS.SP_SY_ENVIAMAIL('Controlbantotal@cajaarequipa.pe',
                        'kcabrerac@cajaarequipa.pe',
                        'Se depuró z0e479 & z0e482',
                        'BD=' || SYS_CONTEXT('USERENV', 'DB_NAME') ||
                        CHR(13) || 'INSTANCIA=' ||
                        SYS_CONTEXT('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                        'Hora Actual en Servidor : ' ||
                        TO_CHAR(SYSDATE, 'HH24:MI:SS') || CHR(13));

    SYS.SP_SY_ENVIAMAIL('Controlbantotal@cajaarequipa.pe',
                        'lcarpio@cajaarequipa.pe',
                        'Se depuró z0e479 & z0e482',
                        'BD=' || SYS_CONTEXT('USERENV', 'DB_NAME') ||
                        CHR(13) || 'INSTANCIA=' ||
                        SYS_CONTEXT('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                        'Hora Actual en Servidor : ' ||
                        TO_CHAR(SYSDATE, 'HH24:MI:SS') || CHR(13));
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    V_ERROR := 'ORA-' || SQLCODE || '-' || SQLERRM;
    SYS.SP_SY_ENVIAMAIL('ehidalgom@cajaarequipa.pe',
                        'ehidalgom@cajaarequipa.pe',
                        'Revisar SP_CA_UPD_Z0E478_482',
                        'BD=' || SYS_CONTEXT('USERENV', 'DB_NAME') ||
                        CHR(13) || 'INSTANCIA=' ||
                        SYS_CONTEXT('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                        'Hora Actual en Servidor : ' ||
                        TO_CHAR(SYSDATE, 'HH24:MI:SS') || CHR(13) ||
                        V_ERROR || CHR(13));
    SYS.SP_SY_ENVIAMAIL('kcabrerac@cajaarequipa.pe',
                        'kcabrerac@cajaarequipa.pe',
                        'Revisar SP_CA_UPD_Z0E478_482',
                        'BD=' || SYS_CONTEXT('USERENV', 'DB_NAME') ||
                        CHR(13) || 'INSTANCIA=' ||
                        SYS_CONTEXT('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                        'Hora Actual en Servidor : ' ||
                        TO_CHAR(SYSDATE, 'HH24:MI:SS') || CHR(13) ||
                        V_ERROR || CHR(13));
END SP_CA_UPD_Z0E478_482;
 /* GOLDENGATE_DDL_REPLICATION */
/

