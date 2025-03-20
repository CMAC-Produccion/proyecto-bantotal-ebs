CREATE OR REPLACE PROCEDURE SP_AD_GRT_PRV(PV_OBJECT VARCHAR2,
                                          PV_SCHEMA VARCHAR2,
                                          PV_PRIV   VARCHAR2) IS
  -- *****************************************************************
  -- NOMBRE                     : SP_AD_GRT_PRV
  -- SISTEMA                    : BANTOTAL
  -- MÓDULO                     : ADMINISTRACION
  -- VERSIÓN                    : 1.0
  -- USO                        : ADMINISTRAR PRIVILEGIOS
  -- ESTADO                     : ACTIVO
  -- PARÁMETROS DE ENTRADA      : PV_OBJECT : OBJETO, PV_SCHEMA : ESQUEMA AL QUE SE OTORGA, PV_PRIV : PRIVILEGIO
  -- AUTOR                      : ERIKA HIDALGO
  LV_QRY VARCHAR2(3000);
  LV_ERR VARCHAR2(3000);
BEGIN
  LV_QRY := 'GRANT ' || PV_PRIV || ' ON ' || PV_OBJECT || ' TO ' ||
            PV_SCHEMA;
  EXECUTE IMMEDIATE LV_QRY;
  insert into systabrep.PRIVGRTRVK values (user,sysdate,'GRANT',LV_QRY);
  commit;
EXCEPTION
  WHEN OTHERS THEN
    LV_ERR := TO_CHAR(LV_QRY || ' : ' || SQLCODE || ' - ' || SQLERRM);
    dbms_output.put_line(LV_ERR);
END;
/

