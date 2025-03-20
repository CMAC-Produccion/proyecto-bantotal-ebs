CREATE OR REPLACE PROCEDURE SP_FSH012_TOT (
 /* 
    @DLYA
    Total x Rubro del Historico de Saldos. Usado para cuadre de FSD011.
 */
 ain_emp IN NUMBER,   -- Empresa
 ain_fec IN VARCHAR2, -- Fecha 
 ain_rub IN NUMBER,   -- Rubro
 ain_mda IN NUMBER,   -- Moneda
 ain_pos IN NUMBER    -- Columna a Actualizar
)
is
    l_saldo NUMBER(17,2);
    l_upd   VARCHAR2(300);
    l_fec   DATE;
BEGIN
    l_fec := TO_DATE(ain_fec,'dd/mm/yyyy');    
    
    BEGIN
    SELECT sum(bcsdmo) INTO l_saldo
    FROM fsh012 
    WHERE bcemp  = ain_emp and
          bcfech = l_fec and
          bcrubr = ain_rub and
          bcmda  = ain_mda;    
    EXCEPTION
        WHEN no_data_found THEN
          l_saldo := 0;
    END;
    
    IF l_saldo != 0 THEN
       l_upd := 'UPDATE bnj500 SET ' || 'bnj500i' || trim(to_char(ain_pos, '00')) || '1 = :IMP WHERE bnj500rub = :RUB AND bnj500mda = :MDA';
       EXECUTE IMMEDIATE l_upd USING l_saldo, ain_rub, ain_mda;
       COMMIT;
    END IF;    
    
END;
/

