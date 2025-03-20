CREATE OR REPLACE PROCEDURE "SP_MIGRAR_JAQL507" AS

  ld_fecsis date;
  p_c_msgerr VARCHAR2(1000);

  cursor c1 is select * from jaql507;

begin

    --//
    begin
      select pgfape into ld_fecsis from fst017 where pgcod = 1;
    exception
      when others then
        null;
    end;
    --//


  For i in c1 loop
	begin

    insert into jaql507H
      (Jaql507hcoent,
       Jaql507hcotse,
       Jaql507hnrcon,
       Jaql507hpefac,
       Jaql507hfadoc,
       Jaql507hfepro,
       Jaql507hhopro,
       Jaql507hnrdoc,
       Jaql507hclien,
       Jaql507hcomon,
       Jaql507hmocob,
       Jaql507hfefac,
       Jaql507hfeven,
       Jaql507hesreg,
       Jaql507htext1,
       Jaql507hauxc3,
       Jaql507hauxn1,
       Jaql507hauxn2,
       Jaql507hauxn3,
       Jaql507hauxd1,
       Jaql507hauxd2,
       Jaql507hauxd3,
       Jaql507hauxn4,
       Jaql507hauxn5,
       Jaql507htipdo)
      values (i.Jaql507coent,
              i.Jaql507cotse,
              i.Jaql507nrcon,
              i.Jaql507pefac,
              i.Jaql507fadoc,
              i.Jaql507fepro,
              i.Jaql507hopro,
              i.Jaql507nrdoc,
              i.Jaql507clien,
              i.Jaql507comon,
              i.Jaql507mocob,
              i.Jaql507fefac,
              i.Jaql507feven,
              i.Jaql507esreg,
              i.Jaql507text1,
              i.Jaql507auxc3,
              i.Jaql507auxn1,
              i.Jaql507auxn2,
              i.Jaql507auxn3,
              i.Jaql507auxd1,
              i.Jaql507auxd2,
              i.Jaql507auxd3,
              i.Jaql507auxn4,
              i.Jaql507auxn5,
              i.Jaql507tipdo);
    commit;

    exception
  		when others then
		  p_c_msgerr:= sqlerrm;

      insert into jaql507ERR values (i.JAQL507COENT,
                                      i.JAQL507COTSE,
                                      i.JAQL507NRCON,
                                      i.JAQL507PEFAC,
                                      i.JAQL507FADOC,
                                      i.JAQL507FEPRO,
                                      i.JAQL507HOPRO,
                                      i.JAQL507NRDOC,
                                      i.JAQL507CLIEN,
                                      i.JAQL507COMON,
                                      i.JAQL507MOCOB,
                                      i.JAQL507FEFAC,
                                      i.JAQL507FEVEN,
                                      i.JAQL507ESREG,
                                      i.JAQL507TEXT1,
                                      i.JAQL507AUXC3,
                                      i.JAQL507AUXN1,
                                      i.JAQL507AUXN2,
                                      i.JAQL507AUXN3,
                                      i.JAQL507AUXD1,
                                      i.JAQL507AUXD2,
                                      i.JAQL507AUXD3,
                                      i.JAQL507AUXN4,
                                      i.JAQL507AUXN5,
                                      i.JAQL507TIPDO,
                                      p_c_msgerr);
      commit;
/*
       sys.sp_sy_enviamail('ehidalgom@cajaarequipa.pe','ehidalgom@cajaarequipa.pe',
                   'ERROR en inserción a jaql507H del procedimiento sp_migrar_jaql507',
                   'BD='||sys_context('USERENV', 'DB_NAME')||CHR(13)||'INSTANCIA='||
                   sys_context('USERENV', 'INSTANCE_NAME')||CHR(13)||CHR(13)||
                   'Revisar tabla jaql507ERR'||CHR(13)||'ERROR: '||p_c_msgerr);
    sys.sp_sy_enviamail('kcabrerac@cajaarequipa.pe','kcabrerac@cajaarequipa.pe',
                   'ERROR en inserción a jaql507H del procedimiento sp_migrar_jaql507',
                   'BD='||sys_context('USERENV', 'DB_NAME')||CHR(13)||'INSTANCIA='||
                   sys_context('USERENV', 'INSTANCE_NAME')||CHR(13)||CHR(13)||
                   'Revisar tabla jaql507ERR'||CHR(13)||'ERROR: '||p_c_msgerr);*/

   End;
   end loop;


    execute immediate 'truncate table JAQL507';

    begin
      DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',
                                    tabname          => 'JAQL507',
                                    degree           => 8,
                                    granularity      => 'ALL',
                                    estimate_percent => dbms_stats.auto_sample_size,
                                    cascade          => TRUE);
    end;

exception
  when others then
    dbms_output.put_line('ERROR : ' || sqlerrm);
    p_c_msgerr:='ERROR : ' || sqlerrm;/*
    sys.sp_sy_enviamail('ehidalgom@cajaarequipa.pe','ehidalgom@cajaarequipa.pe',
                   'ERROR en ejecución del procedimiento sp_migrar_jaql507',
                   'BD='||sys_context('USERENV', 'DB_NAME')||CHR(13)||'INSTANCIA='||
                   sys_context('USERENV', 'INSTANCE_NAME')||CHR(13)||CHR(13)||
                   'ERROR en ejecución del procedimiento sp_migrar_jaql507'||CHR(13)||
                   p_c_msgerr);
    sys.sp_sy_enviamail('kcabrerac@cajaarequipa.pe','kcabrerac@cajaarequipa.pe',
                   'ERROR en ejecución del procedimiento sp_migrar_jaql507',
                   'BD='||sys_context('USERENV', 'DB_NAME')||CHR(13)||'INSTANCIA='||
                   sys_context('USERENV', 'INSTANCE_NAME')||CHR(13)||CHR(13)||
                   'ERROR en ejecución del procedimiento sp_migrar_jaql507'||CHR(13)||
                   p_c_msgerr);*/
end sp_migrar_jaql507;
 /* GOLDENGATE_DDL_REPLICATION */
/

