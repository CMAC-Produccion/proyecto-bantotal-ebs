CREATE OR REPLACE PROCEDURE "MIGRA_THREAD"
( /* 
    @JJPM
    Parelelizador para bandejas, los thread son generados en la BNJ020,
    en función de ain_typ, si es cuenta se paraleliza en cuenta caso
    contrario se paraleliza x cuenta.
    Revisar el proceso de CONTROL y/o CARGA de Bandejas para poder 
    tener claro que TIPO de paralelización realizar.
    PARAMETRO:
    sql : SELECT CUENTA/DOCUMENTO FROM TABLA_BANDEJA
          WHERE [EMPRESA = :EMPRESA OR :EMPRESA = 0] AND 
                [BANDEJA = :BANDEJA OR :BANDEJA = 0] AND 
                [SUCURSAL/TIPO_DOCUMENTO = :SUCURSAL/TIPO_DOCUMENTO OR :SUCURSAL/TIPO_DOCUMENTO = 0]
          ORDER BY CUENTA/DOCUMENTO
  */
  ain_emp  IN NUMBER,  -- Empresa.
  ain_cod  IN NUMBER,  -- Codigo de Bandeja.
  ain_typ  IN NUMBER,  -- Tipo: 1: SUCURSAL + CUENTA, 2: TIPO DOCUMENTO + DOCUMENTO, 3: CUENTA, 4: SUCURSAL + RUBRO.
  ain_suc  IN NUMBER,  -- Surcursal/Tipo Documento, si ain_typ=3 ingresar 1 x defecto.
  ain_th   IN NUMBER,  -- Numero de Hilos.
  aiv_sql  IN VARCHAR2 -- SQL que contiene informacion de la tabla a paralelizar y como accesar a ella.
) is
  -- Declaramos cursor
  TYPE tc_bandeja IS REF CURSOR;
  lc_bandeja tc_bandeja;
  
  -- Variables de calculo del thread
  ln_tot NUMBER(9) := 0;
  ln_reg NUMBER(9) := 0;
  ln_cnt NUMBER(9) := 0;
  ln_thr NUMBER(3) := 0;
  
  -- Variables del PARSE del sql
  lv_table VARCHAR2(32767) := '';
  lv_where VARCHAR2(32767) := '';
  lv_order VARCHAR2(32767) := '';
  
  -- Variables de carga del valor del cursor
  lv_val VARCHAR2(25) := '';
  ln_aux NUMBER(25) := 1;  -- Inicia con cuenta 1
  ln_hil NUMBER(9) := 0;
  lc_error varchar2(500);
  
  -- Insert paralelizador
  lv_ins VARCHAR2(32767) := 'INSERT INTO BNJ021 VALUES(:1,:2,:3,:4,:5,:6,:7,:8)';
  ln_zero NUMBER(3) := 0;
  lv_void VARCHAR2(1) := '';
  ln_orden NUMBER(3) := 0;
  
  -- Delete Paralelizador
  lv_del VARCHAR2(32767) := 'DELETE BNJ021 WHERE bnjemp = :x AND bnjcod = :y AND bnjsucpar = :z';
BEGIN
     -- Abrir Cursor para lectura
     OPEN lc_bandeja FOR aiv_sql
     USING ain_suc;
     
     -- Obtener nombre tabla
     lv_table := migra_sql_parse(aiv_sql,'TABLE');
     
     -- Obtener where de SQL
     lv_where := migra_sql_parse(aiv_sql,'WHERE');
     lv_where := REGEXP_REPLACE(lv_where,':\w+',TO_CHAR(ain_suc),1,1,'i');
     
     -- Obtener total de registros de la bandeja
     ln_tot := migra_table_count(lv_table,lv_where);
     
     -- Numero de registros por cada thread
     ln_reg := ROUND(ln_tot/ain_th);         
     
     --Correlativo para BNJORDEN
     SELECT MAX(BNJORDEN) INTO ln_orden FROM BNJ021 WHERE bnjemp = ain_emp and bnjcod = ain_cod and bnjsucpar < ain_suc;
     IF ln_orden IS NULL THEN
        ln_orden := 0;
     END IF;
     
     -- Eliminamos hilos anteriores
     --DELETE BNJ020 WHERE bnjemp = ain_emp AND bnjcod = ain_cod;
     --DELETE BNJ021 WHERE bnjemp = ain_emp AND bnjcod = ain_cod AND bnjsucpar = ain_suc;     
     EXECUTE IMMEDIATE lv_del USING ain_emp,ain_cod,ain_suc;
     
     LOOP
          FETCH lc_bandeja INTO lv_val;
          EXIT WHEN lc_bandeja%NOTFOUND;

          ln_cnt := ln_cnt + 1;
          IF ln_cnt > ln_reg and TO_NUMBER(lv_val) <> ln_aux - 1 THEN                              
               ln_hil := ln_hil + 1;
               ln_orden := ln_orden + 1;
               CASE
                WHEN ain_typ = 2 OR ain_typ = 4 THEN                  
                  EXECUTE IMMEDIATE lv_ins USING ain_emp,ain_cod,ain_suc,ln_hil,ln_zero,LPAD(TO_CHAR(ln_aux),25,'0'),lv_val,ln_orden;
                ELSE                   
                  EXECUTE IMMEDIATE lv_ins USING ain_emp,ain_cod,ain_suc,ln_aux,TO_NUMBER(lv_val),lv_void,lv_void,ln_orden;
               END CASE;
               
               ln_aux := TO_NUMBER(lv_val) + 1;
               ln_cnt := 0;               
          END IF;
          commit;
     END LOOP;     
     
     IF ln_hil >= 1 THEN
       ln_hil := ln_hil + 1;
       ln_orden := ln_orden + 1;
       CASE
        WHEN ain_typ = 2 OR ain_typ = 4 THEN                
          EXECUTE IMMEDIATE lv_ins USING ain_emp,ain_cod,ain_suc,ln_hil,ln_zero,LPAD(TO_CHAR(ln_aux),25,'0'),lv_val,ln_orden;
        ELSE         
          EXECUTE IMMEDIATE lv_ins USING ain_emp,ain_cod,ain_suc,ln_aux,/*TO_NUMBER(lv_val)*/999999998,lv_void,lv_void,ln_orden;
       END CASE;      
       commit;
     END IF;
     
     close lc_bandeja;     
EXCEPTION
  WHEN OTHERS THEN       
       --lc_error := SQLERRM;--
       DBMS_OUTPUT.put_line(TO_CHAR(SQLCODE) || ' - ' || SQLERRM(SQLCODE));         
       IF lc_bandeja%ISOPEN THEN
          close lc_bandeja;
          rollback;
       END IF;
END;
/

