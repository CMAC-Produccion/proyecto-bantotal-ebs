CREATE OR REPLACE FUNCTION "MIGRA_TABLE_COUNT" (aiv_table IN VARCHAR2,aiv_where IN VARCHAR2)
RETURN PLS_INTEGER
/*
  @JJPM : Retorna numero de registro de una tabla.
*/
IS
  lv_query VARCHAR2 (32767) := '';
  ln_return PLS_INTEGER := 0;  
BEGIN
  lv_query := 'SELECT COUNT(*) FROM ' || aiv_table;
  IF LENGTH(aiv_where) > 0 THEN lv_query := lv_query || ' WHERE ' || aiv_where; END IF;  
  
  EXECUTE IMMEDIATE lv_query INTO ln_return;
  RETURN ln_return;
EXCEPTION
  WHEN OTHERS THEN
       RETURN 0;
END migra_table_count;
/

