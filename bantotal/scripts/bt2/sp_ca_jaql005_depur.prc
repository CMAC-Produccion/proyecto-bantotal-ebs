CREATE OR REPLACE PROCEDURE SP_CA_JAQL005_DEPUR(P_FECHA DATE) IS
  l_varchar_date varchar2(1000);
  l_date         date;
  n_partition_position number;
  c_partition_name varchar2(1000) := null;
  cursor c_part is
   SELECT high_value, partition_position,partition_name
    FROM dba_tab_partitions
   WHERE table_owner='BANTPROD' and table_name='JAQL005';
  CURSOR C_IDX IS
    SELECT INDEX_NAME INDICE
      FROM DBA_INDEXES
     WHERE TABLE_NAME = 'JAQL005'
       AND TABLE_OWNER = 'BANTPROD';
  CURSOR C_PARTIDX IS
    SELECT partition_name,partition_position
      FROM dba_tab_partitions
   WHERE table_owner='BANTPROD' and table_name='JAQL005' and partition_position<5 order by 2;
begin
  for i in c_part loop
    l_varchar_date := i.high_value;
    execute immediate 'SELECT ' || l_varchar_date || ' FROM dual' INTO l_date;
    if trunc(l_date,'MM')= trunc(add_months(sysdate,-3),'MM') then
      c_partition_name := i.partition_name;
      dbms_output.put_line(l_date);
      dbms_output.put_line(i.partition_name);
      dbms_output.put_line(i.partition_position);
      continue;
    end if;
  end loop;

  IF(C_PARTITION_NAME IS NOT NULL) THEN
    --1RA ITERACIÓN
    UPDATE JAQL005 A
       SET A.JAQL5COTRA = '999999'
     WHERE A.JAQL5FETRA < P_FECHA;
    COMMIT;
    --2DA ITERACIÓN
    UPDATE JAQL005 A
       SET A.JAQL5COTRA = '888888'
     WHERE A.JAQL5FETRA < P_FECHA;
    COMMIT;
    --3RA ITERACIÓN
    UPDATE JAQL005 A
       SET A.JAQL5COTRA = '777777'
     WHERE A.JAQL5FETRA < P_FECHA;
    COMMIT;
    --DEPURACIÓN
    execute immediate 'ALTER TABLE JAQL005 DROP PARTITION '||c_partition_name;
    COMMIT;

    BEGIN
      DBMS_STATS.GATHER_TABLE_STATS(OWNNAME          => 'BANTPROD',
                                    TABNAME          => 'JAQL005',
                                    DEGREE           => 12,
                                    GRANULARITY      => 'ALL',
                                    ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE,
                                    CASCADE          => TRUE);
    END;

    FOR I IN C_IDX LOOP
      FOR J IN C_PARTIDX LOOP
        EXECUTE IMMEDIATE 'alter index ' || I.INDICE || ' rebuild partition '||J.partition_name||' online COMPUTE STATISTICS';
      END LOOP;
    END LOOP;
    --LOG
    INSERT INTO AQPB884 VALUES (USER, SYSDATE, 'SP_CA_JAQL005_DEPUR');
    COMMIT;
  end if;
END SP_CA_JAQL005_DEPUR;
/

