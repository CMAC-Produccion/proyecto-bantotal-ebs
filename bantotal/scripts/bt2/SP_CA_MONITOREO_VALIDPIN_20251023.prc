create or replace procedure "SP_CA_MONITOREO_VALIDPIN" is
  -- *****************************************************************
  -- NOMBRE                     : SP_CA_MONITOREO_VALIDPIN
  -- SISTEMA                    : BANTOTAL
  -- MÓDULO                     : CANALES
  -- VERSIÓN                    : 2.0
  -- FECHA DE CREACIÓN          : 7/10/2020
  -- AUTOR DE CREACIÓN          : ERIKA HIDALGO/LUIS CARPIO
  -- USO                        : MONITOREO VALIDACION PIN
  -- ESTADO                     : ACTIVO
  -- FECHA DE MODIFICACIÓN      : ERIKA HIDALGO
  -- AUTOR DE MODIFICACIÓN      : 23/10/2025
  -- *****************************************************************
  N_CONT     NUMBER;
  V_HOSTNAME VARCHAR(100);
BEGIN
  SELECT HOST_NAME INTO V_HOSTNAME FROM V$INSTANCE;
  SELECT COUNT(*)
    INTO N_CONT
    FROM JAQY252 A
   WHERE JAQY252FEINT = TRUNC(SYSDATE)
     AND JAQY252NUINT > 0
     AND A.JAQY252HOINT >= TO_CHAR(SYSDATE - 1 / 24 / 12, 'hh24:mi:ss');
  IF N_CONT > 20 THEN --20251023 LCARPIO
    SYS.SP_SY_ENVIAMAIL('alertacanales@cajaarequipa.pe',
                        'ehidalgom@cajaarequipa.pe',
                        'Revisar Validador de PIN - ' ||
                        SYS_CONTEXT('USERENV', 'DB_NAME'),
                        'BD=' || SYS_CONTEXT('USERENV', 'DB_NAME') ||
                        CHR(13) || 'INSTANCIA=' ||
                        SYS_CONTEXT('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                        'HOSTNAME=' || V_HOSTNAME || CHR(13) ||
                        'Hora Actual en Servidor : ' ||
                        TO_CHAR(SYSDATE, 'HH24:MI:SS') || CHR(13) ||
                        CHR(13) || 'Revisar Validador de PIN.');
    SYS.SP_SY_ENVIAMAIL('alertacanales@cajaarequipa.pe',
                        'kcabrerac@cajaarequipa.pe',
                        'Revisar Validador de PIN - ' ||
                        SYS_CONTEXT('USERENV', 'DB_NAME'),
                        'BD=' || SYS_CONTEXT('USERENV', 'DB_NAME') ||
                        CHR(13) || 'INSTANCIA=' ||
                        SYS_CONTEXT('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                        'HOSTNAME=' || V_HOSTNAME || CHR(13) ||
                        'Hora Actual en Servidor : ' ||
                        TO_CHAR(SYSDATE, 'HH24:MI:SS') || CHR(13) ||
                        CHR(13) || 'Revisar Validador de PIN.');
    SYS.SP_SY_ENVIAMAIL('alertacanales@cajaarequipa.pe',
                        'lcarpio@cajaarequipa.pe',
                        'Revisar Validador de PIN - ' ||
                        SYS_CONTEXT('USERENV', 'DB_NAME'),
                        'BD=' || SYS_CONTEXT('USERENV', 'DB_NAME') ||
                        CHR(13) || 'INSTANCIA=' ||
                        SYS_CONTEXT('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                        'HOSTNAME=' || V_HOSTNAME || CHR(13) ||
                        'Hora Actual en Servidor : ' ||
                        TO_CHAR(SYSDATE, 'HH24:MI:SS') || CHR(13) ||
                        CHR(13) || 'Revisar Validador de PIN.');
    SYS.SP_SY_ENVIAMAIL('alertacanales@cajaarequipa.pe',
                        'hlaqui@cajaarequipa.pe',
                        'Revisar Validador de PIN - ' ||
                        SYS_CONTEXT('USERENV', 'DB_NAME'),
                        'BD=' || SYS_CONTEXT('USERENV', 'DB_NAME') ||
                        CHR(13) || 'INSTANCIA=' ||
                        SYS_CONTEXT('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                        'HOSTNAME=' || V_HOSTNAME || CHR(13) ||
                        'Hora Actual en Servidor : ' ||
                        TO_CHAR(SYSDATE, 'HH24:MI:SS') || CHR(13) ||
                        CHR(13) || 'Revisar Validador de PIN.');
    SYS.SP_SY_ENVIAMAIL('alertacanales@cajaarequipa.pe',
                        'rbarreto@cajaarequipa.pe',
                        'Revisar Validador de PIN - ' ||
                        SYS_CONTEXT('USERENV', 'DB_NAME'),
                        'BD=' || SYS_CONTEXT('USERENV', 'DB_NAME') ||
                        CHR(13) || 'INSTANCIA=' ||
                        SYS_CONTEXT('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                        'HOSTNAME=' || V_HOSTNAME || CHR(13) ||
                        'Hora Actual en Servidor : ' ||
                        TO_CHAR(SYSDATE, 'HH24:MI:SS') || CHR(13) ||
                        CHR(13) || 'Revisar Validador de PIN.');   
    SYS.SP_SY_ENVIAMAIL('alertacanales@cajaarequipa.pe',
                        'rfeliciano@cajaarequipa.pe',
                        'Revisar Validador de PIN - ' ||
                        SYS_CONTEXT('USERENV', 'DB_NAME'),
                        'BD=' || SYS_CONTEXT('USERENV', 'DB_NAME') ||
                        CHR(13) || 'INSTANCIA=' ||
                        SYS_CONTEXT('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                        'HOSTNAME=' || V_HOSTNAME || CHR(13) ||
                        'Hora Actual en Servidor : ' ||
                        TO_CHAR(SYSDATE, 'HH24:MI:SS') || CHR(13) ||
                        CHR(13) || 'Revisar Validador de PIN.');      
    SYS.SP_SY_ENVIAMAIL('alertacanales@cajaarequipa.pe',
                        'rmanriqueg@cajaarequipa.pe',
                        'Revisar Validador de PIN - ' ||
                        SYS_CONTEXT('USERENV', 'DB_NAME'),
                        'BD=' || SYS_CONTEXT('USERENV', 'DB_NAME') ||
                        CHR(13) || 'INSTANCIA=' ||
                        SYS_CONTEXT('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                        'HOSTNAME=' || V_HOSTNAME || CHR(13) ||
                        'Hora Actual en Servidor : ' ||
                        TO_CHAR(SYSDATE, 'HH24:MI:SS') || CHR(13) ||
                        CHR(13) || 'Revisar Validador de PIN.');      
    SYS.SP_SY_ENVIAMAIL('alertacanales@cajaarequipa.pe',
                        'aaguilara@cajaarequipa.pe',
                        'Revisar Validador de PIN - ' ||
                        SYS_CONTEXT('USERENV', 'DB_NAME'),
                        'BD=' || SYS_CONTEXT('USERENV', 'DB_NAME') ||
                        CHR(13) || 'INSTANCIA=' ||
                        SYS_CONTEXT('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                        'HOSTNAME=' || V_HOSTNAME || CHR(13) ||
                        'Hora Actual en Servidor : ' ||
                        TO_CHAR(SYSDATE, 'HH24:MI:SS') || CHR(13) ||
                        CHR(13) || 'Revisar Validador de PIN.');      

    SYS.SP_SY_ENVIAMAIL('alertacanales@cajaarequipa.pe',
                        'phuarza@cajaarequipa.pe',
                        'Revisar Validador de PIN - ' ||
                        SYS_CONTEXT('USERENV', 'DB_NAME'),
                        'BD=' || SYS_CONTEXT('USERENV', 'DB_NAME') ||
                        CHR(13) || 'INSTANCIA=' ||
                        SYS_CONTEXT('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                        'HOSTNAME=' || V_HOSTNAME || CHR(13) ||
                        'Hora Actual en Servidor : ' ||
                        TO_CHAR(SYSDATE, 'HH24:MI:SS') || CHR(13) ||
                        CHR(13) || 'Revisar Validador de PIN.');
    SYS.SP_SY_ENVIAMAIL('alertacanales@cajaarequipa.pe',
                        'eaguilarf@cajaarequipa.pe',
                        'Revisar Validador de PIN - ' ||
                        SYS_CONTEXT('USERENV', 'DB_NAME'),
                        'BD=' || SYS_CONTEXT('USERENV', 'DB_NAME') ||
                        CHR(13) || 'INSTANCIA=' ||
                        SYS_CONTEXT('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                        'HOSTNAME=' || V_HOSTNAME || CHR(13) ||
                        'Hora Actual en Servidor : ' ||
                        TO_CHAR(SYSDATE, 'HH24:MI:SS') || CHR(13) ||
                        CHR(13) || 'Revisar Validador de PIN.');
    SYS.SP_SY_ENVIAMAIL('alertacanales@cajaarequipa.pe',
                        'ydaza@cajaarequipa.pe',
                        'Revisar Validador de PIN - ' ||
                        SYS_CONTEXT('USERENV', 'DB_NAME'),
                        'BD=' || SYS_CONTEXT('USERENV', 'DB_NAME') ||
                        CHR(13) || 'INSTANCIA=' ||
                        SYS_CONTEXT('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                        'HOSTNAME=' || V_HOSTNAME || CHR(13) ||
                        'Hora Actual en Servidor : ' ||
                        TO_CHAR(SYSDATE, 'HH24:MI:SS') || CHR(13) ||
                        CHR(13) || 'Revisar Validador de PIN.');                                             
    SYS.SP_SY_ENVIAMAIL('alertacanales@cajaarequipa.pe',
                        'cpilares@cajaarequipa.pe',
                        'Revisar Validador de PIN - ' ||
                        SYS_CONTEXT('USERENV', 'DB_NAME'),
                        'BD=' || SYS_CONTEXT('USERENV', 'DB_NAME') ||
                        CHR(13) || 'INSTANCIA=' ||
                        SYS_CONTEXT('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                        'HOSTNAME=' || V_HOSTNAME || CHR(13) ||
                        'Hora Actual en Servidor : ' ||
                        TO_CHAR(SYSDATE, 'HH24:MI:SS') || CHR(13) ||
                        CHR(13) || 'Revisar Validador de PIN.');
    SYS.SP_SY_ENVIAMAIL('alertacanales@cajaarequipa.pe',
                        'lchumbilla@cajaarequipa.pe',
                        'Revisar Validador de PIN - ' ||
                        SYS_CONTEXT('USERENV', 'DB_NAME'),
                        'BD=' || SYS_CONTEXT('USERENV', 'DB_NAME') ||
                        CHR(13) || 'INSTANCIA=' ||
                        SYS_CONTEXT('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                        'HOSTNAME=' || V_HOSTNAME || CHR(13) ||
                        'Hora Actual en Servidor : ' ||
                        TO_CHAR(SYSDATE, 'HH24:MI:SS') || CHR(13) ||
                        CHR(13) || 'Revisar Validador de PIN.');
    SYS.SP_SY_ENVIAMAIL('alertacanales@cajaarequipa.pe',
                        'jcespedese@cajaarequipa.pe',
                        'Revisar Validador de PIN - ' ||
                        SYS_CONTEXT('USERENV', 'DB_NAME'),
                        'BD=' || SYS_CONTEXT('USERENV', 'DB_NAME') ||
                        CHR(13) || 'INSTANCIA=' ||
                        SYS_CONTEXT('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                        'HOSTNAME=' || V_HOSTNAME || CHR(13) ||
                        'Hora Actual en Servidor : ' ||
                        TO_CHAR(SYSDATE, 'HH24:MI:SS') || CHR(13) ||
                        CHR(13) || 'Revisar Validador de PIN.');
    SYS.SP_SY_ENVIAMAIL('alertacanales@cajaarequipa.pe',
                        'jsanchez@cajaarequipa.pe',
                        'Revisar Validador de PIN - ' ||
                        SYS_CONTEXT('USERENV', 'DB_NAME'),
                        'BD=' || SYS_CONTEXT('USERENV', 'DB_NAME') ||
                        CHR(13) || 'INSTANCIA=' ||
                        SYS_CONTEXT('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                        'HOSTNAME=' || V_HOSTNAME || CHR(13) ||
                        'Hora Actual en Servidor : ' ||
                        TO_CHAR(SYSDATE, 'HH24:MI:SS') || CHR(13) ||
                        CHR(13) || 'Revisar Validador de PIN.');
    SYS.SP_SY_ENVIAMAIL('alertacanales@cajaarequipa.pe',
                        'jmezacr@cajaarequipa.pe',
                        'Revisar Validador de PIN - ' ||
                        SYS_CONTEXT('USERENV', 'DB_NAME'),
                        'BD=' || SYS_CONTEXT('USERENV', 'DB_NAME') ||
                        CHR(13) || 'INSTANCIA=' ||
                        SYS_CONTEXT('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                        'HOSTNAME=' || V_HOSTNAME || CHR(13) ||
                        'Hora Actual en Servidor : ' ||
                        TO_CHAR(SYSDATE, 'HH24:MI:SS') || CHR(13) ||
                        CHR(13) || 'Revisar Validador de PIN.');
    SYS.SP_SY_ENVIAMAIL('alertacanales@cajaarequipa.pe',
                        'jescobedoc@cajaarequipa.pe',
                        'Revisar Validador de PIN - ' ||
                        SYS_CONTEXT('USERENV', 'DB_NAME'),
                        'BD=' || SYS_CONTEXT('USERENV', 'DB_NAME') ||
                        CHR(13) || 'INSTANCIA=' ||
                        SYS_CONTEXT('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                        'HOSTNAME=' || V_HOSTNAME || CHR(13) ||
                        'Hora Actual en Servidor : ' ||
                        TO_CHAR(SYSDATE, 'HH24:MI:SS') || CHR(13) ||
                        CHR(13) || 'Revisar Validador de PIN.');
  END IF;
END;
 /* GOLDENGATE_DDL_REPLICATION */
/
