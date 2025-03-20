CREATE OR REPLACE PROCEDURE SP_AH_CRUCE_ONU_OFAC_CTA_M(P_MOD    IN NUMBER,
                                                       P_SUC    IN NUMBER,
                                                       P_MDA    IN NUMBER,
                                                       P_PAP    IN NUMBER,
                                                       P_CTA    IN NUMBER,
                                                       P_OPER   IN NUMBER,
                                                       P_SOPE   IN NUMBER,
                                                       P_TOPE   IN NUMBER,
                                                       P_GUITRX IN NUMBER,
                                                       P_MONTRX IN NUMBER,
                                                       P_FECTRX IN DATE,
                                                       P_RESULT OUT VARCHAR,
                                                       P_RESMSG OUT VARCHAR,
                                                       P_ERRCOD OUT VARCHAR,
                                                       P_ERRMSG OUT VARCHAR) IS

  ln_instancia NUMBER(10);
  ln_cta_aval  NUMBER(9);

BEGIN
  ---*** REVISAMOS CUENTA PRINCIPAL
  --dbms_output.PUT_LINE('EVALUAMOS CTA PRINCIPAL: ' || P_CTA);
  ---***
  SP_AH_CRUCE_ONU_OFAC_CTA(P_MOD, P_SUC, P_MDA, P_PAP, P_CTA, P_OPER, P_SOPE, P_TOPE, P_GUITRX, P_MONTRX, P_FECTRX,
                           P_RESULT,
                           P_RESMSG,
                           P_ERRCOD,
                           P_ERRMSG);
  ---***
  --dbms_output.PUT_LINE('EVALUAMOS CTA PRINCIPAL RESULTADO: '||P_RESULT);
  --dbms_output.PUT_LINE('EVALUAMOS CTA PRINCIPAL RESULTADO MSG: '||P_RESMSG);
  ---***
  ---*** MATCH DE BLOQUEO o AHORROS --> NO es Necesario Revisar MAS
  IF (P_RESULT IN ('ONUB', 'OFAB') OR (P_MOD IN (21, 22, 122))) THEN
    --dbms_output.PUT_LINE('NO es Necesario Revisar MAS: ' || P_RESULT);
    RETURN;
  ELSE
    ---*** CREDITO REVISAR AVAL
    ---*** Conseguir CTA AVAL, SI Existe
    --dbms_output.PUT_LINE('CREDITO REVISAR AVAL');
    SELECT fn_instancia_credito(P_MOD,
                                P_SUC,
                                P_MDA,
                                P_PAP,
                                P_CTA,
                                P_OPER,
                                P_SOPE,
                                P_TOPE)
      INTO ln_instancia
      FROM DUAL;
    --dbms_output.PUT_LINE('ln_instancia: ' || ln_instancia);
    IF ((ln_instancia IS NOT NULL) AND (ln_instancia > 0)) THEN
      begin
        SELECT sng003cta
          INTO ln_cta_aval
          FROM sng003
         WHERE sng001inst = ln_instancia;
      exception
        when others then
          ln_cta_aval := 0;
      end;
      --dbms_output.PUT_LINE('ln_cta_aval: ' || ln_cta_aval);
      IF ((ln_cta_aval IS NOT NULL) AND (ln_cta_aval > 0)) THEN
        --dbms_output.PUT_LINE('EVALUAMOS CTA AVAL: ' || ln_cta_aval);
        ---***
        SP_AH_CRUCE_ONU_OFAC_CTA(P_MOD, P_SUC, P_MDA, P_PAP, ln_cta_aval, P_OPER, P_SOPE, P_TOPE, P_GUITRX, P_MONTRX, P_FECTRX,
                                 P_RESULT,
                                 P_RESMSG,
                                 P_ERRCOD,
                                 P_ERRMSG);
        ---***
        P_RESMSG := 'AVAL: ' || P_RESMSG;
        --dbms_output.PUT_LINE('EVALUAMOS CTA AVAL RESULTADO: ' || P_RESULT);
        --dbms_output.PUT_LINE('EVALUAMOS CTA AVAL RESULTADO MSG: ' || P_RESMSG);

      END IF;
    END IF;

  END IF;
  ---***
END SP_AH_CRUCE_ONU_OFAC_CTA_M;
/

