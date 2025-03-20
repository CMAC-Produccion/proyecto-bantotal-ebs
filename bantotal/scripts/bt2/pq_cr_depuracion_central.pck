create or replace package PQ_CR_DEPURACION_CENTRAL is

  -- Author  : MCANDIA
  -- Created : 08/06/2018 11:49:00 A.M
  -- Purpose : DEPURACION TABLA JAQL716 A FECHA ESPECIFICADA

  -- Public type declarations
  Procedure SP_CR_DEPURA_JAQL716(fech_dep in date);

end PQ_CR_DEPURACION_CENTRAL;
/

create or replace package body PQ_CR_DEPURACION_CENTRAL is

  procedure SP_CR_DEPURA_JAQL716(fech_dep date) is
  
    ld_fecdep       date;
    lc_dat_ddmmyyyy VARCHAR2(8);
    lc_NombreTabla  varchar(30);
    lc_Tabla        varchar(10);
    lc_campo        varchar(15);
    lc_Comando      varchar(250);
    ld_fecha        date;
    lc_usuario      varchar2(50);
    ln_corr         number := 0;
  
  begin
  
    ld_fecdep       := fech_dep;
    lc_dat_ddmmyyyy := TO_CHAR(ld_fecdep, 'DDMMYYYY');
  
    begin
    
      lc_Tabla       := 'jaql716';
      lc_campo       := 'jaql716fech';
      lc_NombreTabla := trim(lc_Tabla) || '_' ||
                        TO_CHAR(fech_dep, 'ddmmyyyy');
    
      lc_Comando := 'create table ' || 'OPERADOR.' || trim(lc_Tabla) || '_' ||
                    lc_dat_ddmmyyyy ||
                    ' parallel (degree 4) nologging as select a.* from jaql716 a where a.jaql716fech <= to_date(''' ||
                    lc_dat_ddmmyyyy || ''',''DDMMYYYY'')';
    
      execute immediate lc_Comando;
    end;
  
    begin
    
      select to_date(SysDate) fecha, user
        into ld_fecha, lc_usuario
        from dual;
    exception
      when no_data_found then
        ld_fecha   := null;
        lc_usuario := null;
      
        dbms_output.put_line('[' || ld_fecha || ']');
    end;
  
    begin
      select max(a.JAQZ885COR)
        into ln_corr
        from jaqz885 a
       ORDER BY a.JAQZ885COR DESC;
    exception
      when others then
        ln_corr := 0;
    end;
  
    if ln_corr is null then
      ln_corr := 1;
    else
      ln_corr := ln_corr + 1;
    end if;
  
    insert into jaqz885
      (jaqz885cor, jaqz885fep, jaqz885usu, jaqz885fed, JAQZ885AUX4)
    values
      (ln_corr, ld_fecha, lc_usuario, fech_dep, lc_NombreTabla);
  
    commit;
  
    delete from jaql716 w where w.jaql716fech <= fech_dep;
    commit;
  
    begin
      DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD', -- 'DESA310318',
                                    tabname          => 'JAQL716',
                                    degree           => 8,
                                    granularity      => 'ALL',
                                    estimate_percent => 100,
                                    cascade          => TRUE);
    end;
  
  end SP_CR_DEPURA_JAQL716;

end PQ_CR_DEPURACION_CENTRAL;
/

