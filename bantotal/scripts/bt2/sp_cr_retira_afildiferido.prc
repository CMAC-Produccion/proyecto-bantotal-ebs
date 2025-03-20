CREATE OR REPLACE PROCEDURE SP_CR_RETIRA_AFILDIFERIDO(CTA    NUMBER,
                                                      OPER   NUMBER,
                                                      MODU  NUMBER,
                                                      SUBOPE NUMBER,
                                                      RELCO number) IS--30.06.2020
  N_CONT NUMBER := 0;
BEGIN
  --Luis Carpio/Erika Hidalgo
  IF (RELCO IN (121,131)) THEN
    SELECT COUNT(*)
      INTO N_CONT
      FROM FSR011
     WHERE R1CTA = CTA
       AND R1OPER = OPER
       AND R1MOD = MODU--01032021
       AND R1SBOP = SUBOPE
       AND RELCOD = RELCO;

    IF N_CONT = 1 THEN
      EXECUTE IMMEDIATE 'create table operador.fsr011_' ||
                        TO_CHAR(SYSTIMESTAMP, 'DDMMRR_HH24MISSFF3') ||
                        SUBSTR(USER, 1, 3) || ' as select * from fsr011 ' ||
                        'where r1cta = ' || CTA || ' and r1oper = ' || OPER ||
                        ' and R1MOD = ' || MODU || 
                        ' and r1sbop = ' || SUBOPE || ' and relcod =' || RELCO;

      UPDATE FSR011 YY
         SET YY.R011CO = 'N'
       WHERE YY.R1CTA = CTA
         AND YY.R1OPER = OPER
         AND YY.R1MOD = MODU
         AND YY.R1SBOP = SUBOPE
         AND YY.RELCOD = RELCO; -- 1 REGISTRO
      COMMIT;
      dbms_output.put_line('SE ACTUALIZO ' || n_cont || ' registro.');
    ELSE
      dbms_output.put_line('La Cuenta:' || CTA || ' La Operacion:' || OPER || ' El Módulo:' || MODU ||
                           ' La Suboperacion:' || SUBOPE || ' La Relacion:' || RELCO||' considera ' || n_cont ||
                           ' registro(s).' || CHR(13) ||
                           'No se realizó el Update.');
    END IF;
  ELSE
      dbms_output.put_line('Valor RELCOD no es 121 o 131. Revisar');
  END IF;
  insert into AQPB876 values (user,sysdate,'SP_CR_RETIRA_AFILDIFERIDO',   CTA||'-'||OPER||'-'||MODU||'-'||SUBOPE||'-'||RELCO);
  commit;
END SP_CR_RETIRA_AFILDIFERIDO;
/

