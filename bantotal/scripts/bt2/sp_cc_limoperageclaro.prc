CREATE OR REPLACE PROCEDURE "SP_CC_LIMOPERAGECLARO" IS
  N_CONT     NUMBER := 0;
  CORED      NUMBER(10);
  NUCTA      CHAR(30);
  COOPE      CHAR(20);
  FEOPE      DATE;
  NUINT      NUMBER(6);
  V_HOSTNAME VARCHAR(100);
  NUINTMAX      NUMBER(6);
  -- *****************************************************************
  -- NOMBRE                     : SP_CC_LIMOPERAGECLARO
  -- SISTEMA                    : BANTOTAL
  -- MÓDULO                     : CANALES
  -- VERSIÓN                    : 2.0
  -- FECHA DE CREACIÓN          : 6/07/2021
  -- AUTOR DE CREACIÓN          : ERIKA HIDALGO
  -- USO                        : Control del limite de operaciones Claro
  -- ESTADO                     : ACTIVO
  -- PARÁMETROS DE ENTRADA      :
  -- FECHA DE MODIFICACIÓN      : 09/01/2024
  -- AUTOR DE MODIFICACIÓN      : ERIKA HIDALGO
BEGIN
  SELECT HOST_NAME INTO V_HOSTNAME FROM V$INSTANCE;
  --LUIS CARPIO/ERIKA HIDALGO
  SELECT COUNT(9) INTO N_CONT FROM JAQL532 WHERE JAQL532NUINT > 700000;

  IF N_CONT > 0 THEN
    SELECT MAX(JAQL532NUINT) into NUINTMAX FROM JAQL532;
    SELECT JAQL532CORED,
           JAQL532NUCTA,
           JAQL532COOPE,
           JAQL532FEOPE,
           JAQL532NUINT
      INTO CORED, NUCTA, COOPE, FEOPE, NUINT
      FROM JAQL532
     WHERE JAQL532NUINT = /*700001*/NUINTMAX;

    EXECUTE IMMEDIATE 'create table operador.jaql532_' ||
                      TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) || ' as select * from jaql532 ' ||
                      'where jaql532nuint>700000';

    UPDATE JAQL532 SET JAQL532NUINT = 1 WHERE JAQL532NUINT > 700000;
    COMMIT;

    SYS.SP_SY_ENVIAMAIL('Controlbantotal@cajaarequipa.pe',
                         'ehidalgom@cajaarequipa.pe', --J.CORREO,
                         'Actualización Limite de operaciones en agentes Claro' ||
                         ' - ' || SYS_CONTEXT('USERENV', 'DB_NAME'),
                         'BD=' || SYS_CONTEXT('USERENV', 'DB_NAME') ||
                         CHR(13) || 'INSTANCIA=' ||
                         SYS_CONTEXT('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                         'HOSTNAME=' || V_HOSTNAME || CHR(13) ||
                         'Hora Actual en Servidor : ' ||
                         TO_CHAR(SYSDATE, 'HH24:MI:SS') || CHR(13) ||
                         CHR(13) ||
                         'Se actualizó jaql532 where jaql532nuint>700000.' ||
                         CHR(13) || CHR(13) || 'Registro JAQL532NUINT='||NUINTMAX||' : ' || CHR(13) || CHR(13) ||
                         'CORED: '||trim(CORED) || CHR(13) ||
                         'NUCTA: '||trim(NUCTA) || CHR(13) ||
                         'COOPE: '||trim(COOPE) || CHR(13) ||
                         'FEOPE: '||trim(FEOPE) || CHR(13) ||
                         'NUINT: '||trim(NUINT) || CHR(13) ||
                         CHR(13));
    SYS.SP_SY_ENVIAMAIL('Controlbantotal@cajaarequipa.pe',
                         'kcabrerac@cajaarequipa.pe', --J.CORREO,
                         'Actualización Limite de operaciones en agentes Claro' ||
                         ' - ' || SYS_CONTEXT('USERENV', 'DB_NAME'),
                         'BD=' || SYS_CONTEXT('USERENV', 'DB_NAME') ||
                         CHR(13) || 'INSTANCIA=' ||
                         SYS_CONTEXT('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                         'HOSTNAME=' || V_HOSTNAME || CHR(13) ||
                         'Hora Actual en Servidor : ' ||
                         TO_CHAR(SYSDATE, 'HH24:MI:SS') || CHR(13) ||
                         CHR(13) ||
                         'Se actualizó jaql532 where jaql532nuint>700000.' ||
                         CHR(13) || CHR(13) || 'Registro JAQL532NUINT='||NUINTMAX||' : ' || CHR(13) || CHR(13) ||
                         'CORED: '||trim(CORED) || CHR(13) ||
                         'NUCTA: '||trim(NUCTA) || CHR(13) ||
                         'COOPE: '||trim(COOPE) || CHR(13) ||
                         'FEOPE: '||trim(FEOPE) || CHR(13) ||
                         'NUINT: '||trim(NUINT) || CHR(13) ||
                         CHR(13));
   SYS.SP_SY_ENVIAMAIL('Controlbantotal@cajaarequipa.pe',
                         'lcarpio@cajaarequipa.pe', --J.CORREO,
                         'Actualización Limite de operaciones en agentes Claro' ||
                         ' - ' || SYS_CONTEXT('USERENV', 'DB_NAME'),
                         'BD=' || SYS_CONTEXT('USERENV', 'DB_NAME') ||
                         CHR(13) || 'INSTANCIA=' ||
                         SYS_CONTEXT('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                         'HOSTNAME=' || V_HOSTNAME || CHR(13) ||
                         'Hora Actual en Servidor : ' ||
                         TO_CHAR(SYSDATE, 'HH24:MI:SS') || CHR(13) ||
                         CHR(13) ||
                         'Se actualizó jaql532 where jaql532nuint>700000.' ||
                         CHR(13) || CHR(13) || 'Registro JAQL532NUINT='||NUINTMAX||' : ' || CHR(13) || CHR(13) ||
                         'CORED: '||trim(CORED) || CHR(13) ||
                         'NUCTA: '||trim(NUCTA) || CHR(13) ||
                         'COOPE: '||trim(COOPE) || CHR(13) ||
                         'FEOPE: '||trim(FEOPE) || CHR(13) ||
                         'NUINT: '||trim(NUINT) || CHR(13) ||
                         CHR(13));
    SYS.SP_SY_ENVIAMAIL('Controlbantotal@cajaarequipa.pe',
                         'jsanchez@cajaarequipa.pe', --J.CORREO,
                         'Actualización Limite de operaciones en agentes Claro' ||
                         ' - ' || SYS_CONTEXT('USERENV', 'DB_NAME'),
                         'BD=' || SYS_CONTEXT('USERENV', 'DB_NAME') ||
                         CHR(13) || 'INSTANCIA=' ||
                         SYS_CONTEXT('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                         'HOSTNAME=' || V_HOSTNAME || CHR(13) ||
                         'Hora Actual en Servidor : ' ||
                         TO_CHAR(SYSDATE, 'HH24:MI:SS') || CHR(13) ||
                         CHR(13) ||
                         'Se actualizó jaql532 where jaql532nuint>700000.' ||
                         CHR(13) || CHR(13) || 'Registro JAQL532NUINT='||NUINTMAX||' : ' || CHR(13) || CHR(13) ||
                         'CORED: '||trim(CORED) || CHR(13) ||
                         'NUCTA: '||trim(NUCTA) || CHR(13) ||
                         'COOPE: '||trim(COOPE) || CHR(13) ||
                         'FEOPE: '||trim(FEOPE) || CHR(13) ||
                         'NUINT: '||trim(NUINT) || CHR(13) ||
                         CHR(13));
  END IF;
END SP_CC_LIMOPERAGECLARO;
 /* GOLDENGATE_DDL_REPLICATION */
/

