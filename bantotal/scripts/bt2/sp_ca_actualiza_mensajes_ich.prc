CREATE OR REPLACE PROCEDURE SP_CA_ACTUALIZA_MENSAJES_ICH IS
  FECHA_HORA VARCHAR2(100);
BEGIN
  FECHA_HORA := TO_CHAR(SYSDATE, 'YYYYMMDD_HH24MI');
  EXECUTE IMMEDIATE 'create table operador.mensajes_' || FECHA_HORA ||
                    ' as select * from ichannelalert.mensajes 
                      where trunc(FECHA_HORA_INSERCION)<trunc(sysdate) and ESTADO=''E''';
  UPDATE ICHANNELALERT.MENSAJES
     SET ESTADO = 'TF'
   WHERE TRUNC(FECHA_HORA_INSERCION) < TRUNC(SYSDATE)
     AND ESTADO = 'E';
  COMMIT;
END;
/

