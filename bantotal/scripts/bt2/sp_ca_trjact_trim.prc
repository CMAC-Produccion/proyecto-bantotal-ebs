CREATE OR REPLACE PROCEDURE "SP_CA_TRJACT_TRIM" IS
  -- *****************************************************************
  -- NOMBRE                     : SP_CA_TRJACT_TRIM
  -- SISTEMA                    : BANTOTAL
  -- MÓDULO                     : CANALES
  -- VERSIÓN                    : 1.0
  -- FECHA DE CREACIÓN          : 09/01/2024
  -- AUTOR DE CREACIÓN          : ERIKA HIDALGO
  -- USO                        : OBTENER TRIMESTRALMENTE TARJETAS ACTIVAS EN USO
  -- ESTADO                     : ACTIVO
  -- PARÁMETROS DE ENTRADA      :
  -- FECHA DE MODIFICACIÓN      :
  -- AUTOR DE MODIFICACIÓN      :
  N_CONT     NUMBER := 0;
  V_HOSTNAME VARCHAR(100);
BEGIN
  SELECT HOST_NAME INTO V_HOSTNAME FROM V$INSTANCE;
  DELETE AQPB894;
  COMMIT;
  DELETE AQPB895;
  COMMIT;
  DELETE AQPB896;
  COMMIT;
  DELETE AQPB897;
  COMMIT;
  DELETE AQPB898;
  COMMIT;
  DELETE AQPB899;
  COMMIT;
  DELETE AQPB900;
  COMMIT;
  INSERT INTO AQPB894
    SELECT A.JAQL540NUTAR
      FROM JAQL540 A
     WHERE A.JAQL540FEINI BETWEEN TRUNC((ADD_MONTHS(SYSDATE, -3)), 'MM') AND
           TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, -1)));
  COMMIT;
  INSERT INTO AQPB895
    SELECT B.JAQL5NUTAR
      FROM JAQL005 B
     WHERE B.JAQL5FETRA BETWEEN TRUNC((ADD_MONTHS(SYSDATE, -3)), 'MM') AND
           TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, -1)));
  COMMIT;
  INSERT INTO AQPB896
    SELECT B.JAQL673NUTAR
      FROM JAQL673 B
     WHERE B.JAQL673FETRA BETWEEN TRUNC((ADD_MONTHS(SYSDATE, -3)), 'MM') AND
           TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, -1)));
  COMMIT;
  INSERT INTO AQPB897
    SELECT C.AQPB118NUTAR
      FROM AQPB118 C
     WHERE C.AQPB118FETRA BETWEEN TRUNC((ADD_MONTHS(SYSDATE, -3)), 'MM') AND
           TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, -1)));
  COMMIT;
  INSERT INTO AQPB898
    SELECT TXTORD
      FROM FSX016 A
     WHERE A.HFCON BETWEEN TRUNC((ADD_MONTHS(SYSDATE, -3)), 'MM') AND
           TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, -1)))
       AND TXTORD LIKE '426153%';
  COMMIT;
  INSERT INTO AQPB899
    SELECT D.JAQZ208NUTAR
      FROM JAQZ208 D
     WHERE D.JAQZ208FETRA BETWEEN TRUNC((ADD_MONTHS(SYSDATE, -3)), 'MM') AND
           TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, -1)));
  COMMIT;

  INSERT INTO AQPB900
    SELECT substr(TRIM(AQPB894NRO),1,20)
      FROM AQPB894
    UNION
    SELECT substr(TRIM(A.AQPB895NRO),1,20)
      FROM AQPB895 A
    UNION
    SELECT substr(TRIM(B.AQPB896NRO),1,20)
      FROM AQPB896 B
    UNION                                                    
    SELECT substr(TRIM(C.AQPB897NRO),1,20)
      FROM AQPB897 C
    UNION
    SELECT substr(TRIM(D.AQPB898NRO),1,20)
      FROM AQPB898 D
    UNION
    SELECT substr(TRIM(E.AQPB899NRO),1,20)
      FROM AQPB899 E;
  COMMIT;

  SELECT COUNT(AQPB900NRO)
    INTO N_CONT
    FROM AQPB900, Z0E478 B
   WHERE AQPB900NRO LIKE '426153%'
     AND LENGTH(TRIM(AQPB900NRO)) = 16
     AND TRIM(B.Z0E478NRO) = AQPB900NRO;

  SYS.SP_SY_ENVIAMAIL('Controlbantotal@cajaarequipa.pe',
                      'ehidalgom@cajaarequipa.pe', --J.CORREO,
                      'Extraccion de cantidad de tarjetas activas en uso' ||
                      ' - ' || SYS_CONTEXT('USERENV', 'DB_NAME'),
                      'BD=' || SYS_CONTEXT('USERENV', 'DB_NAME') || CHR(13) ||
                      'INSTANCIA=' ||
                      SYS_CONTEXT('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                      'HOSTNAME=' || V_HOSTNAME || CHR(13) ||
                      'Hora Actual en Servidor : ' ||
                      TO_CHAR(SYSDATE, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                      'Tarjetas activas en uso entre ' ||
                      TO_CHAR(TRUNC((ADD_MONTHS(SYSDATE, -3)), 'MM'),
                              'RRRR/MM/DD') || ' y ' ||
                      TO_CHAR(TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, -1))),
                              'RRRR/MM/DD') || ' es :' || N_CONT || CHR(13));
  SYS.SP_SY_ENVIAMAIL('Controlbantotal@cajaarequipa.pe',
                      'kcabrerac@cajaarequipa.pe', --J.CORREO,
                      'Extraccion de cantidad de tarjetas activas en uso' ||
                      ' - ' || SYS_CONTEXT('USERENV', 'DB_NAME'),
                      'BD=' || SYS_CONTEXT('USERENV', 'DB_NAME') || CHR(13) ||
                      'INSTANCIA=' ||
                      SYS_CONTEXT('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                      'HOSTNAME=' || V_HOSTNAME || CHR(13) ||
                      'Hora Actual en Servidor : ' ||
                      TO_CHAR(SYSDATE, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                      'Tarjetas activas en uso entre ' ||
                      TO_CHAR(TRUNC((ADD_MONTHS(SYSDATE, -3)), 'MM'),
                              'RRRR/MM/DD') || ' y ' ||
                      TO_CHAR(TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, -1))),
                              'RRRR/MM/DD') || ' es :' || N_CONT || CHR(13));
  SYS.SP_SY_ENVIAMAIL('Controlbantotal@cajaarequipa.pe',
                      'cpilares@cajaarequipa.pe', --J.CORREO,
                      'Extraccion de cantidad de tarjetas activas en uso' ||
                      ' - ' || SYS_CONTEXT('USERENV', 'DB_NAME'),
                      'BD=' || SYS_CONTEXT('USERENV', 'DB_NAME') || CHR(13) ||
                      'INSTANCIA=' ||
                      SYS_CONTEXT('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                      'HOSTNAME=' || V_HOSTNAME || CHR(13) ||
                      'Hora Actual en Servidor : ' ||
                      TO_CHAR(SYSDATE, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                      'Tarjetas activas en uso entre ' ||
                      TO_CHAR(TRUNC((ADD_MONTHS(SYSDATE, -3)), 'MM'),
                              'RRRR/MM/DD') || ' y ' ||
                      TO_CHAR(TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, -1))),
                              'RRRR/MM/DD') || ' es :' || N_CONT || CHR(13));
  SYS.SP_SY_ENVIAMAIL('Controlbantotal@cajaarequipa.pe',
                      'rbarreto@cajaarequipa.pe', --J.CORREO,
                      'Extraccion de cantidad de tarjetas activas en uso' ||
                      ' - ' || SYS_CONTEXT('USERENV', 'DB_NAME'),
                      'BD=' || SYS_CONTEXT('USERENV', 'DB_NAME') || CHR(13) ||
                      'INSTANCIA=' ||
                      SYS_CONTEXT('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                      'HOSTNAME=' || V_HOSTNAME || CHR(13) ||
                      'Hora Actual en Servidor : ' ||
                      TO_CHAR(SYSDATE, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                      'Tarjetas activas en uso entre ' ||
                      TO_CHAR(TRUNC((ADD_MONTHS(SYSDATE, -3)), 'MM'),
                              'RRRR/MM/DD') || ' y ' ||
                      TO_CHAR(TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, -1))),
                              'RRRR/MM/DD') || ' es :' || N_CONT || CHR(13));
  SYS.SP_SY_ENVIAMAIL('Controlbantotal@cajaarequipa.pe',
                      'ydaza@cajaarequipa.pe', --J.CORREO,
                      'Extraccion de cantidad de tarjetas activas en uso' ||
                      ' - ' || SYS_CONTEXT('USERENV', 'DB_NAME'),
                      'BD=' || SYS_CONTEXT('USERENV', 'DB_NAME') || CHR(13) ||
                      'INSTANCIA=' ||
                      SYS_CONTEXT('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                      'HOSTNAME=' || V_HOSTNAME || CHR(13) ||
                      'Hora Actual en Servidor : ' ||
                      TO_CHAR(SYSDATE, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                      'Tarjetas activas en uso entre ' ||
                      TO_CHAR(TRUNC((ADD_MONTHS(SYSDATE, -3)), 'MM'),
                              'RRRR/MM/DD') || ' y ' ||
                      TO_CHAR(TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, -1))),
                              'RRRR/MM/DD') || ' es :' || N_CONT || CHR(13));
  SYS.SP_SY_ENVIAMAIL('Controlbantotal@cajaarequipa.pe',
                      'lcarpio@cajaarequipa.pe', --J.CORREO,
                      'Extraccion de cantidad de tarjetas activas en uso' ||
                      ' - ' || SYS_CONTEXT('USERENV', 'DB_NAME'),
                      'BD=' || SYS_CONTEXT('USERENV', 'DB_NAME') || CHR(13) ||
                      'INSTANCIA=' ||
                      SYS_CONTEXT('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                      'HOSTNAME=' || V_HOSTNAME || CHR(13) ||
                      'Hora Actual en Servidor : ' ||
                      TO_CHAR(SYSDATE, 'HH24:MI:SS') || CHR(13) || CHR(13) ||
                      'Tarjetas activas en uso entre ' ||
                      TO_CHAR(TRUNC((ADD_MONTHS(SYSDATE, -3)), 'MM'),
                              'RRRR/MM/DD') || ' y ' ||
                      TO_CHAR(TRUNC(LAST_DAY(ADD_MONTHS(SYSDATE, -1))),
                              'RRRR/MM/DD') || ' es :' || N_CONT || CHR(13));
END SP_CA_TRJACT_TRIM;
 /* GOLDENGATE_DDL_REPLICATION */
/

