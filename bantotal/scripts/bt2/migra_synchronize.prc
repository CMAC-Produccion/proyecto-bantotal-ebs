CREATE OR REPLACE PROCEDURE "MIGRA_SYNCHRONIZE"
( /*
    @JJPM
    Sincroniza tablas. Mas adelante se incluira el dblink para tablas remotas.
    PARAMETRO:
              schema_name        : Schema de origen
              table_name         : Tabla Origen
              remote_schema_name : Schema Remoto
              remote_table_name  : Tabla Remota
              perform_commit     : True mas de un commit despues de realizar cambios. Por Defecto FALSE
  */
  schema_name         IN VARCHAR2,
  table_name          IN VARCHAR2,
  remote_schema_name  IN VARCHAR2,
  remote_table_name   IN VARCHAR2,
  perform_commit      IN BOOLEAN DEFAULT FALSE
) is
  -- Variables de soporte
  consistent      BOOLEAN;
  scan_info       DBMS_COMPARISON.COMPARISON_TYPE;
  comparison_name VARCHAR2(30);
  scan_id         NUMBER(9);
  yes_not         VARCHAR2(3); -- perform_commit

BEGIN
     -- Creamos definición de la comparación
     comparison_name := 'COMPARE_'||table_name;
     DBMS_COMPARISON.CREATE_COMPARISON(
          comparison_name => comparison_name,
          schema_name => schema_name,
          object_name => table_name,
          dblink_name => null,
          remote_schema_name => remote_schema_name,
          remote_object_name => remote_table_name);

     -- Realizamos la comparación
     consistent := DBMS_COMPARISON.COMPARE(
          comparison_name => comparison_name,
          scan_info => scan_info,
          perform_row_dif => TRUE);
     scan_id := scan_info.scan_id;

     If perform_commit = TRUE Then
        yes_not := 'YES';
     Else
         yes_not := 'NOT';
     End If;

     DBMS_OUTPUT.PUT_LINE('DATOS DE SINCRONIZACION:');
     DBMS_OUTPUT.PUT_LINE('--- REALIZA COMMIT           -> '||yes_not);
     DBMS_OUTPUT.PUT_LINE('--- NOMBRE DE SCHEMA ORIGEN  -> '||schema_name);
     DBMS_OUTPUT.PUT_LINE('--- NOMBRE DE TABLA ORIGEN   -> '||table_name);
     DBMS_OUTPUT.PUT_LINE('--- NOMBRE DE SCHEMA DESTINO -> '||remote_schema_name);
     DBMS_OUTPUT.PUT_LINE('--- NOMBRE DE TABLA DESTINO  -> '||remote_table_name);
     DBMS_OUTPUT.PUT_LINE('--- DATOS DE LA COMPARACION:');
     DBMS_OUTPUT.PUT_LINE('------- NOMBRE DE COMPARACION    -> '||comparison_name);
     DBMS_OUTPUT.PUT_LINE('------- NUMERO DE COMPARACION    -> '||scan_id);

     If consistent = TRUE Then
        DBMS_OUTPUT.PUT_LINE('------- EXISTE DIFERENCIAS       -> NOT');
     Else
        DBMS_OUTPUT.PUT_LINE('------- EXISTE DIFERENCIAS       -> YES :');

        -- Sincronizamos datos de tabla remota
        DBMS_COMPARISON.CONVERGE(
             comparison_name => comparison_name,
             scan_id => scan_id,
             scan_info => scan_info,
             converge_options => DBMS_COMPARISON.CMP_CONVERGE_LOCAL_WINS,
             perform_commit => perform_commit);
        DBMS_OUTPUT.PUT_LINE('----------- FILAS LOCALES COMBINADAS      -> '||scan_info.loc_rows_merged);
        DBMS_OUTPUT.PUT_LINE('----------- FILAS REMOTAS COMBINADAS      -> '||scan_info.rmt_rows_merged);
        DBMS_OUTPUT.PUT_LINE('----------- FILAS LOCALES ELIMINADAS      -> '||scan_info.loc_rows_deleted);
        DBMS_OUTPUT.PUT_LINE('----------- FILAS REMOTAS ELIMINADAS      -> '||scan_info.rmt_rows_deleted);
     End If;

     DBMS_COMPARISON.DROP_COMPARISON(
          comparison_name => comparison_name);

EXCEPTION
  WHEN OTHERS THEN
       DBMS_COMPARISON.DROP_COMPARISON(
             comparison_name => comparison_name);
       DBMS_OUTPUT.put_line(SQLERRM(SQLCODE));
END;
/

