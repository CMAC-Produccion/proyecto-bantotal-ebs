CREATE OR REPLACE FUNCTION "MIGRA_COUNT_TABLE" (aiv_table IN VARCHAR2)
RETURN PLS_INTEGER
/*
  @JJPM : Retorna numero de registro de una tabla.
*/
IS
  lv_query VARCHAR2 (32767) := 'SELECT COUNT(*) FROM ' || aiv_table;
  ln_return PLS_INTEGER;
BEGIN
  EXECUTE IMMEDIATE lv_query INTO ln_return;
  RETURN ln_return;
EXCEPTION
  WHEN OTHERS THEN
       RETURN 0;
END migra_count_table;
/

