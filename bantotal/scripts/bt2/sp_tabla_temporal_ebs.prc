create or replace procedure sp_tabla_temporal_EBS(ld_fecha_ini in date, ld_fecha_fin in date) is
    -- *****************************************************************
    -- Nombre                       : sp_tabla_temporal_EBS
    -- Sistema                      : BANTOTAL
    -- Módulo                       : Crea tabla temporal AQPA470T para copiar de AQPA470 de fecha de proceso en XXBOL.AQPA470T
    -- Versión                      : 1.0
    -- Fecha de Creación            : 2024.04.05
    -- Autor de Creación            : DCASTRO
    -- Estado                       : Activo
    -- Acceso                       : Público
    -- Fecha de Modificación        : 2024.05.27
    -- Autor de Modificación        : DCASTRO - Se modificó link a ebs por @ERP
    -- *****************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  lc_sql varchar2(1000);
  lc_fecha_ini varchar2(10);
  lc_fecha_fin varchar2(10);
  ln_nro number;  
    
  begin


  lc_fecha_ini := to_char(ld_fecha_ini,'DD/MM/YYYY');
  lc_fecha_fin := to_char(ld_fecha_fin,'DD/MM/YYYY');        

  begin
    select count(1) into ln_nro from  user_tables where table_name='AQPA470T';
  exception when others then null;    
  end;

  if ln_nro>0 then
    begin
      lc_sql := ' DROP TABLE AQPA470T purge';
      EXECUTE IMMEDIATE lc_sql;
      commit;
    exception when others then null;
    end;
  end if;
    
  begin
  lc_sql := ' CREATE TABLE AQPA470T parallel (degree 4) nologging compress 
  TABLESPACE BANTPROD_B AS
  SELECT  a.* FROM  aqpa470 a 
      where a.aqpa470femi >= to_date(''' || lc_fecha_ini || ''',''DD/MM/YYYY'') 
        and a.aqpa470femi <= to_date(''' || lc_fecha_fin || ''',''DD/MM/YYYY'')
        ';
 
    EXECUTE IMMEDIATE lc_sql;
    commit;
  exception when others then null;
  end;
  
  ---aplicar estadisticas
   begin
            DBMS_STATS.gather_table_stats(ownname          => 'BANTPROD',  
                                          tabname          => 'AQPA470T',
                                          degree           => 10,
                                          granularity      => 'ALL',
                                          estimate_percent => dbms_stats.auto_sample_size,
                                          cascade          => TRUE);
  end;   

  ---eliminando registros de tabla temporal
  begin
         execute immediate 'begin sp_elimina_AQPA470T_EBS@ERP; end;';
  end;


  ---insertar registros en esquema xxbol
          insert into xxbol.aqpa470T@ERP
                (
                aqpa470tserie,
                 aqpa470tnro,
                 aqpa470tpgcod,
                 aqpa470tmod,
                 aqpa470tsucor,
                 aqpa470ttran,
                 aqpa470trel,
                 aqpa470tcon,
                 aqpa470tcord,
                 aqpa470tsubo,
                 aqpa470tind,
                 aqpa470trubro,
                 aqpa470tccos,
                 aqpa470tfemi,
                 aqpa470ttcomf,
                 aqpa470tseri,
                 aqpa470tnum,
                 aqpa470ttdocr,
                 aqpa470tnruc,
                 aqpa470trasoc,
                 aqpa470tfdref,
                 aqpa470tmtotal,
                 aqpa470tmtimp,
                 aqpa470tmtinf,
                 aqpa470timpt,
                 aqpa470tmone,
                 aqpa470ttcam,
                 aqpa470ttcomp,
                 aqpa470tsdref,
                 aqpa470tndref,
                 aqpa470tlest,
                 aqpa470tcsuna,
                 apaq470imdeb,
                 apaq470imhab,
                 aqpa470tmbim,
                 aqpa470tprvit,
                 aqpa470ttotal,
                 aqpa470tvvuig,
                 aqpa470tvvun,
                 aqpa470titem,
                 aqpa470tdesc,
                 aqpa470tcorr,
                 aqpa470tflag
                )
                select /*+parallel(a,20)*/
                        a.aqpa470serie, 
                        a.aqpa470nro, 
                        a.aqpa470pgcod, 
                        a.aqpa470mod, 
                        a.aqpa470sucor, 
                        a.aqpa470tran, 
                        a.aqpa470rel, 
                        a.aqpa470con, 
                        a.aqpa470cord, 
                        a.aqpa470subo, 
                        a.aqpa470ind, 
                        a.aqpa470rubro, 
                        a.aqpa470ccos, 
                        a.aqpa470femi, 
                        a.aqpa470tcomf, 
                        a.aqpa470seri, 
                        a.aqpa470num, 
                        a.aqpa470tdocr, 
                        a.aqpa470nruc, 
                        a.aqpa470rasoc, 
                        a.aqpa470fdref, 
                        a.aqpa470mtotal, 
                        a.aqpa470mtimp, 
                        a.aqpa470mtinf, 
                        a.aqpa470impt, 
                        a.aqpa470mone, 
                        a.aqpa470tcam, 
                        a.aqpa470tcomp, 
                        a.aqpa470sdref, 
                        a.aqpa470ndref, 
                        a.aqpa470lest, 
                        a.aqpa470csuna, 
                        a.apaq470imdeb, 
                        a.apaq470imhab, 
                        a.aqpa470mbim, 
                        a.aqpa470prvit, 
                        a.aqpa470total, 
                        a.aqpa470vvuig, 
                        a.aqpa470vvun, 
                        a.aqpa470item, 
                        a.aqpa470desc, 
                        a.aqpa470corr, 
                        a.aqpa470flag                 
                 from aqpa470T a; ---tabla temporal - data del mes de proceso
              
                commit;

                    

     begin
        lc_sql := ' alter table AQPA470T logging parallel (degree 1)';
        EXECUTE IMMEDIATE lc_sql;
        commit;
      exception when others then null;
      end; 
  
end sp_tabla_temporal_EBS;
/

