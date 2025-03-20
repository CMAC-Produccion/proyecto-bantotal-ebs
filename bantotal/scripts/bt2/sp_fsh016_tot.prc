CREATE OR REPLACE PROCEDURE SP_FSH016_TOT (
 /* 
    @DLYA
    Total x Rubro del Historico de Movimientos. Usado para cuadre de FSD011.
 */
 ain_emp IN NUMBER,   -- Empresa
 ain_fec IN VARCHAR2, -- Fecha en DD/MM/YYYY
 ain_rub IN NUMBER,   -- Rubro
 ain_mda IN NUMBER,   -- Moneda
 ain_pos IN NUMBER    -- Columna a Actualizar
)
is
    l_saldo NUMBER(17,2);
    l_upd   VARCHAR2(300);    
    l_pap   PLS_INTEGER := 0;
    l_fec   DATE;
BEGIN
        
    l_fec := TO_DATE(ain_fec,'dd/mm/yyyy');    

    BEGIN
    
      SELECT sum(hcimp1 * ((hcodmo * 2) - 3)) INTO l_saldo
      FROM fsh016      
      WHERE pgcod  = ain_emp and
            hfvco  = l_fec and
            hrubro = ain_rub and
            hmda = ain_mda and
            hpap = l_pap;
    EXCEPTION
        WHEN no_data_found THEN
          l_saldo := 0;       
    END;
    
    IF l_saldo != 0 THEN
       l_upd := 'UPDATE bnj500 SET ' || 'bnj500i' || trim(to_char(ain_pos, '00')) || '2 = :IMP WHERE bnj500rub = :RUB and bnj500mda = :MDA';
       EXECUTE IMMEDIATE l_upd USING l_saldo, ain_rub, ain_mda;
       COMMIT;
    END IF;    
    
END;
/

