CREATE OR REPLACE PROCEDURE SP_CR_UPD_SEGMCTACLI_FSD008 (ln_seg NUMBER,ln_cta number) IS
  N_CONT NUMBER;
BEGIN
  --LUIS CARPIO/ERIKA HIDALGO
  IF(ln_seg in (1,2) ) then
    SELECT COUNT(*) INTO N_CONT FROM fsd008 A where pgcod=1 and ctnro=ln_cta;

    IF (N_CONT = 1) THEN

      EXECUTE IMMEDIATE 'create table operador.fsd008_' ||
                        TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                        SUBSTR(USER, 1, 3) || ' as select * from fsd008 ' ||
                        'where pgcod=1 and ctnro=' || ln_cta;
      update fsd008
      set CTSEGM= ln_seg
      where pgcod=1 and ctnro=ln_cta;--1 registro


      COMMIT;
      DBMS_OUTPUT.PUT_LINE('Se procesó cuenta cliente:' || ln_cta);
    ELSE
      DBMS_OUTPUT.PUT_LINE('La cuenta :' || ln_cta || ' considera ' ||
                           N_CONT || ' registro(s) en la tabla fsd008.' ||
                           CHR(13) || 'No se realizó el update.');
    END IF;
  else
     DBMS_OUTPUT.PUT_LINE('La variable ln_seg (campo fsd008) no es 1 ni 2. Revisar.'||
                           CHR(13) || 'No se realizó el update.');
  end if;
  insert into AQPB876 values (user,sysdate,'SP_CR_UPD_SEGMCTACLI_FSD008',ln_seg||'-'||ln_cta);
  commit;
END SP_CR_UPD_SEGMCTACLI_FSD008;
/

