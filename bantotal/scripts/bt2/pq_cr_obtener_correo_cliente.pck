create or replace package "PQ_CR_OBTENER_CORREO_CLIENTE" is
  -- *****************************************************************
  -- Nombre                     : PAQUETES PARA OBTENER EL CORREO DE LOS CIENTES
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2022.05.09
  -- Autor de Creación          : EDUARDO COLLADO
  -- Uso                        : Obtiene correo del cliente
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2024.01.19
  -- Autor de la Modificación   : APACHECOH
  -- Descripción de Modificación: Se agregó procedimiento split_ten
  -- *****************************************************************

  PROCEDURE sp_pr_obtener_correo_cliente(dni    in varchar2,
                                         correo out varchar2);

  PROCEDURE sp_pr_split_two(vi_str   in varchar2,
                            vi_delim in varchar2,
                            vo_str_1 out varchar2,
                            vo_str_2 out varchar2);

  PROCEDURE sp_pr_split_five(vi_str   in varchar2,
                             vi_delim in varchar2,
                             vi_cant  in number,
                             vo_str_1 out varchar2,
                             vo_str_2 out varchar2,
                             vo_str_3 out varchar2,
                             vo_str_4 out varchar2,
                             vo_str_5 out varchar2);
                             
  PROCEDURE sp_pr_split_ten(vi_str   in varchar2,
                            vi_delim in varchar2,
                            vi_cant  in number,
                            vo_str_1 out varchar2,
                            vo_str_2 out varchar2,
                            vo_str_3 out varchar2,
                            vo_str_4 out varchar2,
                            vo_str_5 out varchar2,
                            vo_str_6 out varchar2,
                            vo_str_7 out varchar2,
                            vo_str_8 out varchar2,
                            vo_str_9 out varchar2,
                            vo_str_10 out varchar2,
                            vo_str_11 out varchar2,
                            vo_str_12 out varchar2,
                            vo_str_13 out varchar2,
                            vo_str_14 out varchar2,
                            vo_str_15 out varchar2);

end pq_cr_obtener_correo_cliente;
 /* GOLDENGATE_DDL_REPLICATION */
/

create or replace package body pq_cr_obtener_correo_cliente is

  Procedure sp_pr_obtener_correo_cliente(dni    in varchar2,
                                         correo out varchar2)
  -- ***************************************************************** 
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.05.09
    -- Autor de Creación          : EDUARDO COLLADO
    -- Uso                        : Obtiene correo del cliente
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : DNI varchar2
    -- Retorno                    : Correo varchar2
    -- Fecha Modificacion         : 2024.11.26
    -- Usuario Modificacion       : CALARONAP
    -- Modificacion               : Se agrega RPAD en DNI para optimizar filtrado
    -- *****************************************************************
   is
  BEGIN
    correo := '';
    BEGIN
      SELECT distinct lower(substr(a.pextxt, 1, INSTR(a.pextxt, '\', 1) - 1))
        INTO correo
        from fsx001 a
       where pendoc = RPAD(dni, 12, ' ')
         and pextxt like '%@%'
         and rownum = 1;
    EXCEPTION
      WHEN OTHERS THEN
        correo := '';
    END;
  
  end sp_pr_obtener_correo_cliente;

  Procedure sp_pr_split_two(vi_str   in varchar2,
                            vi_delim in varchar2,
                            vo_str_1 out varchar2,
                            vo_str_2 out varchar2)
  -- ***************************************************************** 
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.05.31
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : Divide una oracion en dos
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : vi_str - oracion 
    --                            : vi_delim - delimitador 
    -- Retorno                    : vo_str_1 - oracion pt1
    --                            : vo_str_2 - oracion pt2
    -- *****************************************************************
   is
    lv_str   varchar2(150);
    lv_str_1 varchar2(100) := '';
    lv_str_2 varchar2(100) := '';
    ln_mitad number := 0;
    ln_nume  number := 0;
    ln_cont  number := 0;
  BEGIN
    BEGIN
      lv_str  := vi_str;
      lv_str  := concat(lv_str, vi_delim);
      ln_nume := instr(lv_str, vi_delim, 1, 1);
    
      WHILE (ln_nume != 0) LOOP
        begin
          ln_cont := ln_cont + 1;
          lv_str  := substr(lv_str, ln_nume + 1, length(lv_str));
          ln_nume := instr(lv_str, vi_delim, 1, 1);
        exception
          when others then
            null;
        end;
      END LOOP;
    
      ln_mitad := round(ln_cont / 2);
      lv_str   := vi_str;
      lv_str   := concat(lv_str, vi_delim);
      ln_cont  := 0;
      ln_nume  := instr(lv_str, vi_delim, 1, 1);
    
      WHILE (ln_nume != 0) LOOP
        begin
          ln_cont := ln_cont + 1;
          IF ln_cont <= ln_mitad THEN
            lv_str_1 := concat(lv_str_1, substr(lv_str, 1, ln_nume));
            lv_str_1 := concat(lv_str_1, vi_delim);
          ELSE
            lv_str_2 := concat(lv_str_2, substr(lv_str, 1, ln_nume));
            lv_str_2 := concat(lv_str_2, vi_delim);
          END IF;
          lv_str  := substr(lv_str, ln_nume + 1, length(lv_str));
          ln_nume := instr(lv_str, vi_delim, 1, 1);
        exception
          when others then
            null;
        end;
      END LOOP;
    EXCEPTION
      WHEN OTHERS THEN
        null;
    END;
    vo_str_1 := lv_str_1;
    vo_str_2 := lv_str_2;
  
  END sp_pr_split_two;

  Procedure sp_pr_split_five(vi_str   in varchar2,
                             vi_delim in varchar2,
                             vi_cant  in number,
                             vo_str_1 out varchar2,
                             vo_str_2 out varchar2,
                             vo_str_3 out varchar2,
                             vo_str_4 out varchar2,
                             vo_str_5 out varchar2)
  -- ***************************************************************** 
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2022.05.31
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : Divide una oracion en cinco
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : vi_str - oracion 
    --                            : vi_delim - delimitador 
    -- Retorno                    : vo_str_1 - oracion pt1
    --                            : vo_str_2 - oracion pt2
    --                            : vo_str_3 - oracion pt3
    --                            : vo_str_4 - oracion pt4
    --                            : vo_str_5 - oracion pt5
    -- *****************************************************************
   is
    lv_str_1 varchar2(100) := '';
    lv_str_2 varchar2(100) := '';
    lv_str_3 varchar2(100) := '';
    lv_str_4 varchar2(100) := '';
    lv_str_5 varchar2(100) := '';
    ln_nume  number := 0;
    ln_cont  number := 0;
  BEGIN
    BEGIN
      vo_str_1 := '';
      vo_str_2 := '';
      vo_str_3 := '';
      vo_str_4 := '';
      vo_str_5 := '';
    
      BEGIN
        ln_cont := REGEXP_COUNT(vi_str, '[^' || vi_delim || ']+');
      
        if ln_cont >= 1 then
          lv_str_1 := substr(vi_str, 1, INSTR(vi_str, vi_delim) - 1);
          vo_str_1 := substr(lv_str_1, 1, vi_cant);
        end if;
      
        if ln_cont >= 2 then
          lv_str_2 := substr(vi_str,
                             INSTR(vi_str, vi_delim) + 1,
                             INSTR(vi_str, vi_delim, 1, 2) -
                             INSTR(vi_str, vi_delim) - 1);
          vo_str_2 := substr(lv_str_2, 1, vi_cant);
        end if;
      
        if ln_cont >= 3 then
          lv_str_3 := substr(vi_str,
                             INSTR(vi_str, vi_delim, 1, 2) + 1,
                             INSTR(vi_str, vi_delim, 1, 3) -
                             INSTR(vi_str, vi_delim, 1, 2) - 1);
          vo_str_3 := substr(lv_str_3, 1, vi_cant);
        end if;
      
        if ln_cont >= 4 then
          lv_str_4 := substr(vi_str,
                             INSTR(vi_str, vi_delim, 1, 3) + 1,
                             INSTR(vi_str, vi_delim, 1, 4) -
                             INSTR(vi_str, vi_delim, 1, 3) - 1);
          vo_str_4 := substr(lv_str_4, 1, vi_cant);
        end if;
      
        if ln_cont >= 5 then
          lv_str_5 := substr(vi_str, INSTR(vi_str, vi_delim, 1, 4) + 1);
          vo_str_5 := substr(lv_str_5, 1, vi_cant);
        end if;
      
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    
    END;
  END sp_pr_split_five;
  
  Procedure sp_pr_split_ten(vi_str   in varchar2,
                             vi_delim in varchar2,
                             vi_cant  in number,
                             vo_str_1 out varchar2,
                             vo_str_2 out varchar2,
                             vo_str_3 out varchar2,
                             vo_str_4 out varchar2,
                             vo_str_5 out varchar2,
                             vo_str_6 out varchar2,
                             vo_str_7 out varchar2,
                             vo_str_8 out varchar2,
                             vo_str_9 out varchar2,
                             vo_str_10 out varchar2,
                             vo_str_11 out varchar2,
                             vo_str_12 out varchar2,
                             vo_str_13 out varchar2,
                             vo_str_14 out varchar2,
                             vo_str_15 out varchar2)
  -- ***************************************************************** 
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2024.01.19
    -- Autor de Creación          : Alonso Pacheco Huachaca
    -- Uso                        : Divide una oracion en diez
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : vi_str - oracion 
    --                            : vi_delim - delimitador 
    -- Retorno                    : vo_str_1 - oracion pt1
    --                            : vo_str_2 - oracion pt2
    --                            : vo_str_3 - oracion pt3
    --                            : vo_str_4 - oracion pt4
    --                            : vo_str_5 - oracion pt5
    --                            : vo_str_6 - oracion pt6
    --                            : vo_str_7 - oracion pt7
    --                            : vo_str_8 - oracion pt8
    --                            : vo_str_9 - oracion pt9
    --                            : vo_str_10 - oracion pt10
    --                            : vo_str_11 - oracion pt11
    --                            : vo_str_12 - oracion pt12
    --                            : vo_str_13 - oracion pt13
    --                            : vo_str_14 - oracion pt14
    --                            : vo_str_15 - oracion pt15
    -- *****************************************************************
   is
    lv_str_1 varchar2(100) := '';
    lv_str_2 varchar2(100) := '';
    lv_str_3 varchar2(100) := '';
    lv_str_4 varchar2(100) := '';
    lv_str_5 varchar2(100) := '';
    lv_str_6 varchar2(100) := '';
    lv_str_7 varchar2(100) := '';
    lv_str_8 varchar2(100) := '';
    lv_str_9 varchar2(100) := '';
    lv_str_10 varchar2(100) := '';
    lv_str_11 varchar2(100) := '';
    lv_str_12 varchar2(100) := '';
    lv_str_13 varchar2(100) := '';
    lv_str_14 varchar2(100) := '';    
    lv_str_15 varchar2(100) := '';
    ln_nume  number := 0;
    ln_cont  number := 0;
  BEGIN
    BEGIN
      vo_str_1 := '';
      vo_str_2 := '';
      vo_str_3 := '';
      vo_str_4 := '';
      vo_str_5 := '';
      vo_str_6 := '';
      vo_str_7 := '';
      vo_str_8 := '';
      vo_str_9 := '';
      vo_str_10 := '';
      vo_str_11 := '';
      vo_str_12 := '';
      vo_str_13 := '';
      vo_str_14 := '';
      vo_str_15 := '';
    
      BEGIN
        ln_cont := REGEXP_COUNT(vi_str, '[^' || vi_delim || ']+');
      
        if ln_cont >= 1 then
          lv_str_1 := substr(vi_str, 1, INSTR(vi_str, vi_delim) - 1);
          vo_str_1 := substr(lv_str_1, 1, vi_cant);
        end if;
      
        if ln_cont >= 2 then
          lv_str_2 := substr(vi_str,
                             INSTR(vi_str, vi_delim) + 1,
                             INSTR(vi_str, vi_delim, 1, 2) -
                             INSTR(vi_str, vi_delim) - 1);
          vo_str_2 := substr(lv_str_2, 1, vi_cant);
        end if;
      
        if ln_cont >= 3 then
          lv_str_3 := substr(vi_str,
                             INSTR(vi_str, vi_delim, 1, 2) + 1,
                             INSTR(vi_str, vi_delim, 1, 3) -
                             INSTR(vi_str, vi_delim, 1, 2) - 1);
          vo_str_3 := substr(lv_str_3, 1, vi_cant);
        end if;
      
        if ln_cont >= 4 then
          lv_str_4 := substr(vi_str,
                             INSTR(vi_str, vi_delim, 1, 3) + 1,
                             INSTR(vi_str, vi_delim, 1, 4) -
                             INSTR(vi_str, vi_delim, 1, 3) - 1);
          vo_str_4 := substr(lv_str_4, 1, vi_cant);
        end if;
        
        if ln_cont >= 5 then
          lv_str_5 := substr(vi_str,
                             INSTR(vi_str, vi_delim, 1, 4) + 1,
                             INSTR(vi_str, vi_delim, 1, 5) -
                             INSTR(vi_str, vi_delim, 1, 4) - 1);
          vo_str_5 := substr(lv_str_5, 1, vi_cant);
        end if;
        
        if ln_cont >= 6 then
          lv_str_6 := substr(vi_str,
                             INSTR(vi_str, vi_delim, 1, 5) + 1,
                             INSTR(vi_str, vi_delim, 1, 6) -
                             INSTR(vi_str, vi_delim, 1, 5) - 1);
          vo_str_6 := substr(lv_str_6, 1, vi_cant);
        end if;
        
        if ln_cont >= 7 then
          lv_str_7 := substr(vi_str,
                             INSTR(vi_str, vi_delim, 1, 6) + 1,
                             INSTR(vi_str, vi_delim, 1, 7) -
                             INSTR(vi_str, vi_delim, 1, 6) - 1);
          vo_str_7 := substr(lv_str_7, 1, vi_cant);
        end if;
        
        if ln_cont >= 8 then
          lv_str_8 := substr(vi_str,
                             INSTR(vi_str, vi_delim, 1, 7) + 1,
                             INSTR(vi_str, vi_delim, 1, 8) -
                             INSTR(vi_str, vi_delim, 1, 7) - 1);
          vo_str_8 := substr(lv_str_8, 1, vi_cant);
        end if;
        
        if ln_cont >= 9 then
          lv_str_9 := substr(vi_str,
                             INSTR(vi_str, vi_delim, 1, 8) + 1,
                             INSTR(vi_str, vi_delim, 1, 9) -
                             INSTR(vi_str, vi_delim, 1, 8) - 1);
          vo_str_9 := substr(lv_str_9, 1, vi_cant);
        end if;
        
        if ln_cont >= 10 then
          lv_str_10 := substr(vi_str,
                             INSTR(vi_str, vi_delim, 1, 9) + 1,
                             INSTR(vi_str, vi_delim, 1, 10) -
                             INSTR(vi_str, vi_delim, 1, 9) - 1);
          vo_str_10 := substr(lv_str_10, 1, vi_cant);
        end if;
        
        if ln_cont >= 11 then
          lv_str_11 := substr(vi_str,
                             INSTR(vi_str, vi_delim, 1, 10) + 1,
                             INSTR(vi_str, vi_delim, 1, 11) -
                             INSTR(vi_str, vi_delim, 1, 10) - 1);
          vo_str_11 := substr(lv_str_11, 1, vi_cant);
        end if;
        
        if ln_cont >= 12 then
          lv_str_12 := substr(vi_str,
                             INSTR(vi_str, vi_delim, 1, 11) + 1,
                             INSTR(vi_str, vi_delim, 1, 12) -
                             INSTR(vi_str, vi_delim, 1, 11) - 1);
          vo_str_12 := substr(lv_str_12, 1, vi_cant);
        end if;
        
        if ln_cont >= 13 then
          lv_str_13 := substr(vi_str,
                             INSTR(vi_str, vi_delim, 1, 12) + 1,
                             INSTR(vi_str, vi_delim, 1, 13) -
                             INSTR(vi_str, vi_delim, 1, 12) - 1);
          vo_str_13 := substr(lv_str_13, 1, vi_cant);
        end if;
        
        if ln_cont >= 14 then
          lv_str_14 := substr(vi_str,
                             INSTR(vi_str, vi_delim, 1, 13) + 1,
                             INSTR(vi_str, vi_delim, 1, 14) -
                             INSTR(vi_str, vi_delim, 1, 13) - 1);
          vo_str_14 := substr(lv_str_14, 1, vi_cant);
        end if;
        
      
        if ln_cont >= 15 then
          lv_str_15 := substr(vi_str, INSTR(vi_str, vi_delim, 1, 15) + 1);
          vo_str_15 := substr(lv_str_15, 1, vi_cant);
        end if;
      
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    
    END;
  END sp_pr_split_ten;
  
end pq_cr_obtener_correo_cliente;
/

