CREATE OR REPLACE PROCEDURE "SP_GA_USUARIOS_CESADOS_SUCUR_CARGO" IS
  CURSOR C1 IS
    SELECT N.UBUSER USUARIO, N.UBSUC, M.PRFGCOD
      FROM FST046 N
      JOIN PRFU00 M
        ON N.UBUSER = M.UBUSER
     WHERE M.PRFGCOD = 'CESADO'
       AND N.UBSUC <> 904
       AND N.UBSUC <> 905;
  V_ERROR VARCHAR2(4000);
  -- *****************************************************************
  -- NOMBRE                     : SP_GA_USUARIOS_CESADOS_SUCUR_CARGO
  -- SISTEMA                    : BANTOTAL
  -- MÓDULO                     : GESTIÓN DE USUARIOS BANTOTAL
  -- VERSIÓN                    : 1.0
  -- FECHA DE CREACIÓN          : 21/11/2023
  -- AUTOR DE CREACIÓN          : ROBERTO ZEGARRA
  -- USO                        : ACTUALIZACIÓN DE SUCURSAL Y DESHABILITACIÓN DE CARGO BANTOTAL
  -- ESTADO                     : ACTIVO
  -- PARÁMETROS DE ENTRADA      :
  -- FECHA DE MODIFICACIÓN      :
  -- AUTOR DE MODIFICACIÓN      :
BEGIN
  FOR I IN C1 LOOP
--    dbms_output.put_line(I.USUARIO);
    UPDATE FST046 A
       SET A.UBSUC = 904
     WHERE A.UBUSER = I.USUARIO
       AND A.PGCOD = 1;
    UPDATE SNGAS2 B
       SET B.SNGAS2INH = 'S'
     WHERE B.SNGAS2USR = I.USUARIO
       AND B.SNGAS2PGC = 1;
    UPDATE SNGU02 C
       SET C.SNGU02INH = 'S'
     WHERE C.SNGU02USR = I.USUARIO
       AND C.SNGU02PGC = 1;
    COMMIT;
  END LOOP;
EXCEPTION
  WHEN OTHERS THEN
    V_ERROR := 'ORA-' || SQLCODE || '-' || SQLERRM;
    SYS.SP_SY_ENVIAMAIL('ehidalgom@cajaarequipa.pe',
                        'ehidalgom@cajaarequipa.pe',
                        'Revisar SP_GA_USUARIOS_CESADOS_SUCUR_CARGO',
                        'BD=' || SYS_CONTEXT('USERENV', 'DB_NAME') ||
                        CHR(13) || 'INSTANCIA=' ||
                        SYS_CONTEXT('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                        'Hora Actual en Servidor : ' ||
                        TO_CHAR(SYSDATE, 'HH24:MI:SS') || CHR(13) ||
                        V_ERROR || CHR(13));
    SYS.SP_SY_ENVIAMAIL('kcabrerac@cajaarequipa.pe',
                        'kcabrerac@cajaarequipa.pe',
                        'Revisar SP_GA_USUARIOS_CESADOS_SUCUR_CARGO',
                        'BD=' || SYS_CONTEXT('USERENV', 'DB_NAME') ||
                        CHR(13) || 'INSTANCIA=' ||
                        SYS_CONTEXT('USERENV', 'INSTANCE_NAME') || CHR(13) ||
                        'Hora Actual en Servidor : ' ||
                        TO_CHAR(SYSDATE, 'HH24:MI:SS') || CHR(13) ||
                        V_ERROR || CHR(13));
END SP_GA_USUARIOS_CESADOS_SUCUR_CARGO;
 /* GOLDENGATE_DDL_REPLICATION */
/

