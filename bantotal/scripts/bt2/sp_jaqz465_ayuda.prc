CREATE OR REPLACE PROCEDURE SP_JAQZ465_AYUDA(P_DINIU NUMBER,
                                             P_SIT  CHAR,
                                             P_DINIA  NUMBER,
                                             P_FLAG CHAR ---se agrego flag memo reprogramacion
                                             ) IS
  N_CONT NUMBER := 0;
  lc_variable varchar2(1000);
BEGIN
  SELECT COUNT(1)
    INTO N_CONT
    FROM JAQZ465
   WHERE JAQZ465SIT = P_SIT
     AND JAQZ465DINI = P_DINIA
     AND jaqz465rep = P_FLAG ---se agrego flag memo reprogramacion
		 AND JAQZ465EST = 'S';

  IF N_CONT = 1 THEN


  EXECUTE IMMEDIATE 'create table operador.JAQZ465_' ||
                      TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                      SUBSTR(USER, 1, 3) ||
                      ' as select * from JAQZ465 where JAQZ465SIT=''' ||
                      P_SIT || ''' and JAQZ465DINI ='||
                      P_DINIA || ' and JAQZ465REP ='''||
                      P_FLAG ||
                       ''' AND JAQZ465EST = ''S''';   ---se agrego flag memo reprogramacion

    UPDATE JAQZ465
       SET JAQZ465DINI = P_DINIU
     WHERE JAQZ465SIT = P_SIT
       AND JAQZ465DINI = P_DINIA
       AND jaqz465rep = P_FLAG  ---se agrego flag memo reprogramacion
			 AND JAQZ465EST = 'S';
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Se actualizó ' || N_CONT ||
                         ' registro(s) en la tabla JAQZ465 para JAQZ465SIT:' ||
                         P_SIT || ' , JAQZ465DINI:' || P_DINIA ||
                          ' , jaqz465rep:' || P_FLAG ||
                          ' AND JAQZ465EST = ''S''');
  ELSE
    DBMS_OUTPUT.PUT_LINE('El JAQZ465SIT:' || P_SIT ||
                         ' , JAQZ465DINI:' || P_DINIA ||
                         ' , jaqz465rep:' || P_FLAG ||
												 ' considera ' ||
                         N_CONT || ' registro(s) en la JAQZ465.' ||
                         CHR(13) || 'No se realizó el Update.');
  END IF;

  insert into AQPB876
  values
    (user,
     sysdate,
     'SP_JAQZ465_AYUDA',
     P_DINIU || '-' || P_SIT || '-' ||
     P_DINIA 
     || '-' || P_FLAG
     );
  commit;
END SP_JAQZ465_AYUDA;
/

