CREATE OR REPLACE PROCEDURE SP_CR_CODSECTOR_FSD008(CTA NUMBER, SECTOR NUMBER) IS
  N_CONT1   NUMBER := 0;
  N_CONT2   NUMBER := 0;
  N_CONT3   NUMBER := 0;
  LC_PENDOC CHAR(12);
BEGIN
  --LUIS CARPIO/ERIKA HIDALGO
  SELECT COUNT(*)
    INTO N_CONT1
    FROM FSR008 A
   WHERE A.PGCOD = 1
     AND A.CTNRO = CTA
     AND A.CTTFIR = 'T';
  IF N_CONT1 = 1 THEN
    /*SELECT PENDOC
      INTO LC_PENDOC
      FROM FSR008 A
     WHERE A.PGCOD = 1
       AND A.CTNRO = CTA
       AND A.CTTFIR = 'T';*/

    /*SELECT COUNT(*)
      INTO N_CONT2
      FROM FSD003 B
     WHERE B.PJPAIS = 604
       AND B.PJTDOC = 9
       AND B.PJNDOC = LC_PENDOC;*/

    --IF N_CONT2 = 1 THEN
      SELECT COUNT(*)
        INTO N_CONT3
        FROM FSD008 A
       WHERE A.PGCOD = 1
         AND A.CTNRO = CTA;
--         AND A.SECCOD = 1;--comentado 26.04.2021

      IF N_CONT3 = 1 THEN
        EXECUTE IMMEDIATE 'create table operador.FSD008_' ||
                          TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                          SUBSTR(USER, 1, 3) || ' as select * from FSD008 ' ||
                          'where pgcod = 1 and ctnro = ' || CTA /*||
                          ' and seccod=1';*/;--comentado 26.04.2021

        UPDATE FSD008
           SET SECCOD = SECTOR
         WHERE PGCOD = 1
           AND CTNRO = CTA;
           --AND SECCOD = 1; 

        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Se actualizó FSD008, ' || N_CONT1 ||
                             ' registro.');
      ELSE
        DBMS_OUTPUT.PUT_LINE('La cuenta:' || CTA || ' considera ' ||
                             N_CONT3 ||
                             ' registro(s) para el update a FSD008.' ||
                             CHR(13) || 'No se realizó el Update.');
      END IF;
    /*ELSE
      DBMS_OUTPUT.PUT_LINE('La cuenta:' || CTA ||
                           ' con número de documento ' || LC_PENDOC ||
                           ' no existe en la FSD003.'|| CHR(13) ||
                         'No se realizó el Update.');
    END IF;*/
  ELSE
    DBMS_OUTPUT.PUT_LINE('La cuenta:' || CTA ||
                         ' no es del tipo T en la FSR008.' || CHR(13) ||
                         'No se realizó el Update.');
  END IF;
insert into AQPB876 values (user,sysdate,'SP_CR_CODSECTOR_FSD008',   CTA||'-'||SECTOR);
commit;
END SP_CR_CODSECTOR_FSD008;
/

