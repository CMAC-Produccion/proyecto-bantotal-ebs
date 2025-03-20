CREATE OR REPLACE FUNCTION "MIGRA_SQL_PARSE" (aiv_sql IN VARCHAR2, aiv_type IN VARCHAR2)
RETURN VARCHAR2
/*
  @JJPM : Parsing SQL.
  aiv_type :
           TABLE : Retorna el nombre de la tabla del SQL.
           WHERE : Retorna todo el WHERE del SQL.
           ORDER : Retorna la columna del ORDER del SQL.
*/
IS
  lv_return VARCHAR2(32767);
  ln_pattern PLS_INTEGER := 0;
BEGIN
  CASE TRIM(aiv_type)
       WHEN 'TABLE' THEN ln_pattern := 4;
       WHEN 'WHERE' THEN ln_pattern := 6;
       WHEN 'ORDER' THEN ln_pattern := 8;
  END CASE;
  lv_return := REGEXP_SUBSTR(aiv_sql,'(SELECT\s+)(.*)(\s+FROM\s+)(.*)(\s+WHERE\s+)(.*)(\s+ORDER BY\s+)(.*)',1,1,'i',ln_pattern);
  RETURN lv_return;
EXCEPTION
  WHEN OTHERS THEN
       RETURN '0';
END migra_sql_parse;
/

