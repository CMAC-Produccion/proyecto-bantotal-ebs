CREATE OR REPLACE PROCEDURE SP_CR_ACTUALIZA_SEGM_SNG001 (LN_INS NUMBER,ln_seg number) IS
  N_CONT NUMBER;
BEGIN
  --LUIS CARPIO/ERIKA HIDALGO
  IF(ln_seg in (1,2) ) then
    SELECT COUNT(*) INTO N_CONT FROM sng001 A WHERE A.sng001inst = LN_INS;

    IF (N_CONT = 1) THEN

      EXECUTE IMMEDIATE 'create table operador.sng001_' ||
                        TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                        SUBSTR(USER, 1, 3) || ' as select * from sng001 ' ||
                        'where sng001inst =' || LN_INS;

      UPDATE sng001
         SET sng001seg = ln_seg
       WHERE sng001inst = LN_INS;

      COMMIT;
      DBMS_OUTPUT.PUT_LINE('Se procesó instancia:' || LN_INS);
    ELSE
      DBMS_OUTPUT.PUT_LINE('La Instancia :' || LN_INS || ' considera ' ||
                           N_CONT || ' registro(s) en la tabla sng001.' ||
                           CHR(13) || 'No se realizó el update.');
    END IF;
  else
     DBMS_OUTPUT.PUT_LINE('La variable ln_seg (campo sng001seg) no es 1 ni 2. Revisar.'||
                           CHR(13) || 'No se realizó el update.');
  end if;
insert into AQPB876 values (user,sysdate,'SP_CR_ACTUALIZA_SEGM_SNG001',   LN_INS||'-'||ln_seg);
commit;
END SP_CR_ACTUALIZA_SEGM_SNG001;
/

