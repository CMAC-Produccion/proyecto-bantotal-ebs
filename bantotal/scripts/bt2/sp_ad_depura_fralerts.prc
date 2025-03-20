create or replace procedure SP_AD_DEPURA_FRALERTS is
  d_fecha       date;
  v_hora        varchar2(8);
  n_alid        number(6);
  n_nror        number(6);
  n_cont        number;
  v_maxhora     varchar2(8);
begin

  select trunc(sysdate),
         to_char(sysdate, 'HH24:MI:SS'),
         max(fraleid),
         count(*)
    into d_fecha, v_hora, n_alid, n_nror
    from fralerts;

    insert into jaqz471
        (jaqz471FECH, jaqz471HORA, jaqz471ALID, jaqz471NROR)
    values
        (d_fecha, v_hora, n_alid, n_nror);
    commit;


    MERGE INTO JAQZ470 INI
          USING (select * from  fralerts) DAC
    ON (INI.FRALEID = DAC.FRALEID and INI.FRALEUSER = DAC.FRALEUSER and INI.FRALETYPE = DAC.FRALETYPE 
         and INI.FRALEDATE = DAC.FRALEDATE)       --15.03.2023
    WHEN NOT MATCHED THEN
    INSERT (fraleid, fraletext, fralecall, fraleuser, fraletype, fraledate)
    VALUES (DAC.fraleid, DAC.fraletext, DAC.fralecall, DAC.fraleuser, DAC.fraletype, DAC.fraledate);
    COMMIT;


    delete from fralerts where fraleid<=n_alid and FRALETYPE = 'I' and upper(fraletext) not like '%EXCEP%';
    commit;
    delete from fralerts where fraleid<=n_alid and FRALETYPE = 'M';
    commit;
    delete from fralerts where fraleid<=n_alid and FRALETYPE = 'C';
    commit;
    delete from fralerts where fraleid<=n_alid and FRALETYPE = 'J';
    commit;


    execute immediate 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE';
    begin
      DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                    tabname          => 'FRALERTS',
                                    degree           => 8,
                                    granularity      => 'ALL',
                                    estimate_percent => 100,
                                    cascade          => TRUE);
    end;
end;
/

