create or replace function FN_AH_MODULO10(P_C_CODIGO VARCHAR2, P_C_FACTOR VARCHAR2)
    return number IS
  
    -- ****************************************************************
    -- Nombre                     : FN_AH_MODULO10
    -- Sistema                    : SORFY
    -- M�dulo                     : Ahorros
    -- Versi�n                    : 1.0
    -- Fecha de Creaci�n          : 07/08/2009
    -- Autor de Creaci�n          : Mersal� Araujo
    -- Uso                        : M�dulo 10 para d�gitos de chequeo
    -- Estado                     : Activo
    -- Acceso                     : P�blico
    -- Par�metros de Entrada      : P_C_CODIGO
    --                              P_C_FACTOR
    -- Par�metros de Salida       : 
    -- Fecha de Modificaci�n      : 
    -- Autor de Modificaci�n      : 
    -- Descripci�n de Modificaci�n: 
    -- ************************************************************************    
    lc_factor varchar2(50);
    lc_codigo varchar2(50);
    ln_digito number(2);
    --
    ln_long number;
    lc_suma varchar2(50);
    ln_suma number;
    ln_pos  number;
  
  BEGIN
  
    lc_factor := P_C_FACTOR;
    lc_codigo := P_C_CODIGO;
    --
    ln_long := length(lc_codigo);
    ln_pos  := 0;
    for i in 1 .. ln_long loop
      ln_pos  := ln_pos + 1;
      lc_suma := lc_suma ||
                 TO_CHAR((substr(lc_codigo, ln_pos, 1)) *
                         (substr(lc_factor, ln_pos, 1)));
    end loop;
  
    --
    ln_long := length(lc_suma);
    ln_suma := 0;
    ln_pos  := 0;
  
    for i in 1 .. ln_long loop
      ln_pos  := ln_pos + 1;
      ln_suma := ln_suma + to_number(substr(lc_suma, ln_pos, 1));
    end loop;
  
    -- M�dulo 10 de la Sumatoria.
    ln_digito := mod(ln_suma, 10);
  
    if ln_digito > 0 then
      ln_digito := 10 - ln_digito;
      --
      if ln_digito >= 10 then
        ln_digito := 0;
      end if;
    else
      ln_digito := 0;
    end if;
  
    return(ln_digito);
  
  end FN_AH_MODULO10;
/

