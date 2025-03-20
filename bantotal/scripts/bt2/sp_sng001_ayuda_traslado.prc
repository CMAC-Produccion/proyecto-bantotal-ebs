CREATE OR REPLACE PROCEDURE SP_SNG001_AYUDA_TRASLADO(P_INST  NUMBER,P_ASE CHAR) IS
  N_CONT NUMBER := 0;
BEGIN
  SELECT COUNT(1)
    INTO N_CONT
    FROM SNG001
   WHERE SNG001INST=P_INST;

  IF N_CONT = 1 THEN

    EXECUTE IMMEDIATE 'create table operador.SNG001_' ||
                      TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) ||
                      ' as select * from SNG001 where SNG001INST=' ||
                      P_INST ;


UPDATE SNG001
SET SNG001ASE=P_ASE
WHERE SNG001INST=P_INST;--1 REGISTRO
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Se actualizó ' || N_CONT ||
                         ' registro(s) en la tabla SNG001 para SNG001INST:' ||
                         P_INST );
  ELSE
    DBMS_OUTPUT.PUT_LINE('El SNG001INST:' || P_INST ||
                          ' considera ' ||
                         N_CONT || ' registro(s) en la SNG001.' ||
                         CHR(13) || 'No se realizó el Update.');
  END IF;

  insert into AQPB876
  values
    (user,
     sysdate,
     'SP_SNG001_AYUDA_TRASLADO',
     P_INST || '-' ||
     P_ASE );
  commit;
END SP_SNG001_AYUDA_TRASLADO;
/

