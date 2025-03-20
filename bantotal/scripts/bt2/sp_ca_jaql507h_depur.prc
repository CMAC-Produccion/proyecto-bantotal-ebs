CREATE OR REPLACE PROCEDURE SP_CA_JAQL507H_DEPUR(P_FECHA DATE) IS
  l_varchar_date varchar2(1000);
  l_date         date;
  n_partition_position number;
  c_partition_name varchar2(1000) := null;
  cursor c_part is
  SELECT high_value, partition_position,partition_name
    FROM dba_tab_partitions
   WHERE table_owner='BANTPROD' and table_name='JAQL507H';
begin
  for i in c_part loop
    l_varchar_date := i.high_value;
    execute immediate 'SELECT ' || l_varchar_date || ' FROM dual' INTO l_date;
    if trunc(l_date,'MM')= trunc(add_months(sysdate,-5),'MM') then
      c_partition_name := i.partition_name;
      dbms_output.put_line(l_date);
      dbms_output.put_line(i.partition_name);
      dbms_output.put_line(i.partition_position);
      EXIT;
    end if;
  end loop;

  IF(C_PARTITION_NAME IS NOT NULL) THEN
    --1RA ITERACIÓN
    UPDATE JAQL507H A
       SET A.JAQL507HNRCON = '99999999999999999999'
     WHERE A.JAQL507HFEPRO < P_FECHA;
    COMMIT;
    --2DA ITERACIÓN
    UPDATE JAQL507H A
       SET A.JAQL507HNRCON = '88888888888888888888'
     WHERE A.JAQL507HFEPRO < P_FECHA;
    COMMIT;
    --3RA ITERACIÓN
    UPDATE JAQL507H A
       SET A.JAQL507HNRCON = '77777777777777777777'
     WHERE A.JAQL507HFEPRO < P_FECHA;
    COMMIT;
    --DEPURACIÓN
    execute immediate 'ALTER TABLE JAQL507H DROP PARTITION '||c_partition_name;
    COMMIT;

    BEGIN
      DBMS_STATS.GATHER_TABLE_STATS(OWNNAME          => 'BANTPROD',
                                    TABNAME          => 'JAQL507H',
                                    DEGREE           => 12,
                                    GRANULARITY      => 'ALL',
                                    ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE,
                                    CASCADE          => TRUE);
    END;

    --LOG
    INSERT INTO AQPB884 VALUES (USER, SYSDATE, 'SP_CA_JAQL507H_DEPUR');
    COMMIT;
  end if;
END SP_CA_JAQL507H_DEPUR;
/

