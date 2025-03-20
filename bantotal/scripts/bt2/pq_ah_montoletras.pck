CREATE OR REPLACE PACKAGE PQ_AH_MONTOLETRAS IS
    FUNCTION NUMERO_A_LETRAS(NUMERO IN NUMBER) RETURN VARCHAR2;
    PROCEDURE SP_AH_MONTOLETRAS(P_N_MONTOT IN NUMBER,
                                P_C_MONLET OUT VARCHAR2
                                );
END PQ_AH_MONTOLETRAS;
/

CREATE OR REPLACE PACKAGE BODY PQ_AH_MONTOLETRAS IS

    -- DEFINICION FUNCION LOCAL
    FUNCTION NUMERO_MENOR_MIL(NUMERO IN NUMBER) RETURN VARCHAR2;

    -- IMPLEMENTACION
    FUNCTION NUMERO_A_LETRAS(NUMERO IN NUMBER) RETURN VARCHAR2 IS

        FUERA_DE_RANGO EXCEPTION;

        MILLARES_DE_MILLON NUMBER;
        MILLONES NUMBER;
        MILLARES NUMBER;
        CENTENAS NUMBER;
        CENTIMOS NUMBER;

        EN_LETRAS VARCHAR2(200);
        ENTERO NUMBER;

        AUX VARCHAR2(15);
    BEGIN

        IF NUMERO < 0 OR NUMERO > 999999999999.99 THEN
            RAISE FUERA_DE_RANGO;
        END IF;

        ENTERO := TRUNC(NUMERO);

        MILLARES_DE_MILLON := TRUNC(ENTERO / 1000000000);

        MILLONES := TRUNC((ENTERO MOD 1000000000) / 1000000);

        MILLARES := TRUNC((ENTERO MOD 1000000) / 1000);

        CENTENAS := ENTERO MOD 1000;

        CENTIMOS := (ROUND(NUMERO,2) * 100) MOD 100;


        -- MILLARES DE MILLON
        IF MILLARES_DE_MILLON = 1 THEN
            IF MILLONES = 0 THEN
                EN_LETRAS := 'MIL MILLONES ';
            ELSE
                EN_LETRAS := 'MIL ';
            END IF;
        ELSIF MILLARES_DE_MILLON > 1 THEN

            EN_LETRAS := NUMERO_MENOR_MIL(MILLARES_DE_MILLON);

            IF MILLONES = 0 THEN
                EN_LETRAS := EN_LETRAS || 'MIL MILLONES ';
            ELSE
                EN_LETRAS := EN_LETRAS || 'MIL ';
            END IF;
        END IF;

        -- MILLONES
        IF MILLONES = 1 AND  MILLARES_DE_MILLON = 0 THEN
            EN_LETRAS := 'UN MILLÓN ';
        ELSIF MILLONES > 0 THEN
            EN_LETRAS := EN_LETRAS || NUMERO_MENOR_MIL(MILLONES) || 'MILLONES ';
        END IF;

        -- MILLARES
        IF MILLARES = 1 AND MILLARES_DE_MILLON = 0 AND MILLONES = 0 THEN
            EN_LETRAS := 'MIL ';
        ELSIF MILLARES > 0 THEN
            EN_LETRAS := EN_LETRAS || NUMERO_MENOR_MIL(MILLARES) || 'MIL ';
        END IF;

        -- CENTENAS
        IF CENTENAS > 0 OR (ENTERO = 0 AND CENTIMOS = 0) THEN
            EN_LETRAS := EN_LETRAS || NUMERO_MENOR_MIL(CENTENAS);
        END IF;

        IF CENTIMOS > 0 THEN
            IF CENTIMOS = 1 THEN
                AUX := 'CÉNTIMO';
            ELSE
                AUX := 'CÉNTIMOS';
            END IF;
            IF ENTERO > 0 THEN
                EN_LETRAS := EN_LETRAS || 'CON ' /*|| REPLACE(NUMERO_MENOR_MIL(CENTIMOS),'UNO ','UN ')*/ || CENTIMOS||'/100'; --AUX;
            ELSE
                --EN_LETRAS := EN_LETRAS || REPLACE(NUMERO_MENOR_MIL(CENTIMOS),'UNO','UN') || CENTIMOS||'/100';--AUX;
                 EN_LETRAS := EN_LETRAS || 'CON ' /*|| REPLACE(NUMERO_MENOR_MIL(CENTIMOS),'UNO ','UN ')*/ || CENTIMOS||'/100'; --AUX;
            END IF;
        ELSE
            EN_LETRAS := EN_LETRAS || 'CON '|| rpad(to_char(CENTIMOS),2,'0')||'/100'; --AUX;  
        END IF;

        RETURN(EN_LETRAS);


    EXCEPTION
        WHEN FUERA_DE_RANGO THEN
            RETURN('ERROR: ENTRADA FUERA DE RANGO');
        WHEN OTHERS THEN
            RAISE;
    END;

    FUNCTION NUMERO_MENOR_MIL(NUMERO IN NUMBER) RETURN VARCHAR2 IS


        FUERA_DE_RANGO EXCEPTION;
        NO_ENTERO EXCEPTION;

        CENTENAS NUMBER;
        DECENAS NUMBER;
        UNIDADES NUMBER;

        EN_LETRAS VARCHAR2(100);
        UNIR VARCHAR2(2);

    BEGIN

        IF TRUNC(NUMERO) <> NUMERO THEN
            RAISE NO_ENTERO;
        END IF;

        IF NUMERO < 0 OR NUMERO > 999 THEN
            RAISE FUERA_DE_RANGO;
        END IF;


        IF NUMERO = 100 THEN
            RETURN ('CIEN ');
        ELSIF NUMERO = 0 THEN
            RETURN ('CERO ');
        ELSIF NUMERO = 1 THEN
            RETURN ('UNO ');
        ELSE
            CENTENAS := TRUNC(NUMERO / 100);
            DECENAS  := TRUNC((NUMERO MOD 100)/10);
            UNIDADES := NUMERO MOD 10;
            UNIR := 'Y ';

            -- CENTENAS
            IF CENTENAS = 1 THEN
                EN_LETRAS := 'CIENTO ';
            ELSIF CENTENAS = 2 THEN
                EN_LETRAS := 'DOSCIENTOS ';
            ELSIF CENTENAS = 3 THEN
                EN_LETRAS := 'TRESCIENTOS ';
            ELSIF CENTENAS = 4 THEN
                EN_LETRAS := 'CUATROCIENTOS ';
            ELSIF CENTENAS = 5 THEN
                EN_LETRAS := 'QUINIENTOS ';
            ELSIF CENTENAS = 6 THEN
                EN_LETRAS := 'SEISCIENTOS ';
            ELSIF CENTENAS = 7 THEN
                EN_LETRAS := 'SETECIENTOS ';
            ELSIF CENTENAS = 8 THEN
                EN_LETRAS := 'OCHOCIENTOS ';
            ELSIF CENTENAS = 9 THEN
                EN_LETRAS := 'NOVECIENTOS ';
            END IF;



            -- DECENAS
            IF DECENAS = 3 THEN
                EN_LETRAS := EN_LETRAS || 'TREINTA ';
            ELSIF DECENAS = 4 THEN
                EN_LETRAS := EN_LETRAS || 'CUARENTA ';
            ELSIF DECENAS = 5 THEN
                EN_LETRAS := EN_LETRAS || 'CINCUENTA ';
            ELSIF DECENAS = 6 THEN
                EN_LETRAS := EN_LETRAS || 'SESENTA ';
            ELSIF DECENAS = 7 THEN
                EN_LETRAS := EN_LETRAS || 'SETENTA ';
            ELSIF DECENAS = 8 THEN
                EN_LETRAS := EN_LETRAS || 'OCHENTA ';
            ELSIF DECENAS = 9 THEN
                EN_LETRAS := EN_LETRAS || 'NOVENTA ';
            ELSIF DECENAS = 1 THEN
                IF UNIDADES < 6 THEN
                    IF UNIDADES = 0 THEN
                        EN_LETRAS := EN_LETRAS || 'DIEZ ';
                    ELSIF UNIDADES = 1 THEN
                        EN_LETRAS := EN_LETRAS || 'ONCE ';
                    ELSIF UNIDADES = 2 THEN
                        EN_LETRAS := EN_LETRAS || 'DOCE ';
                    ELSIF UNIDADES = 3 THEN
                        EN_LETRAS := EN_LETRAS || 'TRECE ';
                    ELSIF UNIDADES = 4 THEN
                        EN_LETRAS := EN_LETRAS || 'CATORCE ';
                    ELSIF UNIDADES = 5 THEN
                        EN_LETRAS := EN_LETRAS || 'QUINCE ';
                    END IF;
                    UNIDADES := 0;
                ELSE
                    EN_LETRAS := EN_LETRAS || 'DIECI';
                    UNIR := NULL;
                END IF;
            ELSIF DECENAS = 2 THEN
                IF UNIDADES = 0 THEN
                    EN_LETRAS := EN_LETRAS || 'VEINTE ';
                ELSE
                    EN_LETRAS := EN_LETRAS || 'VEINTI';
                END IF;
                UNIR := NULL;
            ELSIF DECENAS = 0 THEN
                UNIR := NULL;
            END IF;

            -- UNIDADES
            IF UNIDADES = 1 THEN
                EN_LETRAS := EN_LETRAS || UNIR || 'UNO ';
            ELSIF UNIDADES = 2 THEN
                EN_LETRAS := EN_LETRAS || UNIR || 'DOS ';
            ELSIF UNIDADES = 3 THEN
                EN_LETRAS := EN_LETRAS || UNIR || 'TRES ';
            ELSIF UNIDADES = 4 THEN
                EN_LETRAS := EN_LETRAS || UNIR || 'CUATRO ';
            ELSIF UNIDADES = 5 THEN
                EN_LETRAS := EN_LETRAS || UNIR || 'CINCO ';
            ELSIF UNIDADES = 6 THEN
                EN_LETRAS := EN_LETRAS || UNIR || 'SEIS ';
            ELSIF UNIDADES = 7 THEN
                EN_LETRAS := EN_LETRAS || UNIR || 'SIETE ';
            ELSIF UNIDADES = 8 THEN
                EN_LETRAS := EN_LETRAS || UNIR || 'OCHO ';
            ELSIF UNIDADES = 9 THEN
                EN_LETRAS := EN_LETRAS || UNIR || 'NUEVE ';
            END IF;
        END IF;

        RETURN(EN_LETRAS);

    EXCEPTION
        WHEN NO_ENTERO THEN
            RETURN('ERROR: ENTRADA NO ES UN NÚMERO ENTERO');
        WHEN FUERA_DE_RANGO THEN
            RETURN('ERROR: ENTRADA FUERA DE RANGO');
        WHEN OTHERS THEN
            RAISE;

    END;
    PROCEDURE SP_AH_MONTOLETRAS(P_N_MONTOT IN NUMBER,
                                P_C_MONLET OUT VARCHAR2
                                ) IS
    BEGIN
      P_C_MONLET := pq_ah_montoletras.numero_a_letras(numero => P_N_MONTOT);
    EXCEPTION
    WHEN OTHERS THEN        
      P_C_MONLET := NULL;
    END SP_AH_MONTOLETRAS;                                
END PQ_AH_MONTOLETRAS;
/

