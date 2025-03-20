CREATE OR REPLACE TRIGGER TG_JAQL420_BI_01
BEFORE INSERT ON JAQL420 
FOR EACH ROW
  ---***
  DECLARE
  ---***
  P_ERRCOD   VARCHAR(3);
  P_ERRMSG   VARCHAR(160);
  lv_nvavig  VARCHAR(10);
  ld_nvavig  DATE;
  ld_fcr     DATE;
  lv_ops     VARCHAR(10);
  ld_pdiahab DATE;
  ld_qdiahab DATE;
  ln_TipRec  NUMBER(3);
  lv_TipRec  VARCHAR(1);
  lv_TipRecR VARCHAR(1);
  ln_plzabs  NUMBER(3);
  ---***
  
  BEGIN
    ---***
    P_ERRCOD   := '000';
    P_ERRMSG   := '';
    lv_TipRec  := 'V';
    lv_TipRecR := '';
    ln_plzabs  := 0;
    ---***
    ---*** GUIA - SBS FECHA DE VIGENCIA DE LA NVA DISPOSICION
    BEGIN  
      SELECT TRIM(TP1DESC) INTO lv_nvavig FROM FST198 WHERE TP1COD = 1
      AND TP1COD1 = 11146 
      AND TP1CORR1 = 1
      AND TP1CORR2 = 52
      AND TP1CORR3 = 1; 
      ld_nvavig := TO_DATE(lv_nvavig, 'yyyy.mm.dd');
    EXCEPTION
      when others then
        ld_nvavig := TO_DATE('2023.02.28', 'yyyy.mm.dd');
    END;
    ---***
    ---*** GUIA - SBS DIAS PARA ABSOLVER/RESOLVER 
    BEGIN
      SELECT TP1NRO1
        INTO ln_plzabs
        FROM FST198
       WHERE TP1COD = 1
         AND TP1COD1 = 11146
         AND TP1CORR1 = 1
         AND TP1CORR2 = 51
         AND TP1CORR3 = 1;
    EXCEPTION
      when others then
        P_ERRCOD := 'T02';
        P_ERRMSG := sqlcode || '->' || sqlerrm;
        RETURN;
    END;    
    ---***
    ld_fcr     := :new.JAQL420FCR;
    lv_ops     := :new.JAQL420OPS;
    lv_TipRecR := :new.JAQL420TIPSBS;
    ---***
    IF(ld_fcr >= ld_nvavig) THEN
      IF ((lv_TipRecR IS NULL) OR (lv_TipRecR NOT IN ('V', 'S'))) THEN
        -- No Fue Grabado con Anterioridad
        SELECT COUNT(*)
          INTO ln_TipRec
          FROM FST198
         WHERE TP1COD = 1
           AND TP1COD1 = 11146
           AND TP1CORR1 = 1
           AND TP1CORR2 = 50
           AND TP1NRO1 = TO_NUMBER(TRIM(lv_ops), '999');
           
        ---*** CALC 1er DIA HABIL LUEGO DE REGISTRO DE RECLAMO
        SP_AH_CALC_DIAHABIL(ld_fcr, 1, ld_pdiahab);
        ---*** CALC 15 DIAS HABILES (Fecha Resp. Aproximada)
        IF (ln_TipRec > 0) THEN
          -- ES TIPO SEGUROS -- DIAS CALENDARIO (DESDE 1er DIA HABIL)
          lv_TipRec  := 'S';
          ld_qdiahab := ld_pdiahab + (ln_plzabs - 1);
        ELSE
          -- NO TIPO SEGUROS -- DIAS HABILES (DESDE 1er DIA HABIL)
          SP_AH_CALC_DIAHABIL(ld_pdiahab, ln_plzabs - 1, ld_qdiahab);
        END IF;
        ---***
        :new.JAQL420TIPSBS := lv_TipRec;
        :new.JAQL420DIAHAB := ld_pdiahab;
        :new.JAQL420FAPROX := ld_qdiahab;
        :new.JAQL420DABSOL := 0;
        :new.JAQL420SUSEST := 'I';
        :new.JAQL420SUSDIA := 0;
        :new.JAQL420CRETIM := SYSDATE;
        ---***
      END IF;
    END IF;  
END TG_JAQL420_BI_01;
/

