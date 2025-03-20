create or replace package pq_cl_actualiza_datos is

  -- Author  : YLOZADA
  -- Created : 17/10/2017 09:25:02 a.m.
  -- Purpose : 
  
  -- Public type declarations

  -- Public function and procedure declarations
  Procedure sp_cl_jobs;    
  procedure sp_cl_datos(P_C_DIGITO1 IN VARCHAR2,
                        P_C_DIGITO2 IN VARCHAR2,            
                        P_C_DIGITO3 IN VARCHAR2,            
                        P_C_DIGITO4 IN VARCHAR2,            
                        P_C_DIGITO5 IN VARCHAR2,            
                        P_C_DIGITO6 IN VARCHAR2,                                                                                                                                                            
                        ln_ini      in number
                        ); 
  procedure sp_ah_carga_data;                        
  procedure sp_ah_afilia_jaqz173;  
  FUNCTION fn_mg_verifica_tarea(pi_vc2_nomjob IN VARCHAR2,
                                pi_vc2_nomusr IN VARCHAR2
                                ) return number;
end pq_cl_actualiza_datos;
/

create or replace package body pq_cl_actualiza_datos is

  procedure sp_cl_jobs  is
  -- ****************************************************************
  -- Nombre                     : sp_cl_jobs
  -- Sistema                    : SORFY
  -- Modulo                     : Personas
  -- Version                    : 1.0
  -- Fecha de Creacion          : 17/10/2017
  -- Autor de Creacion          : YLOZADA
  -- Uso                        : GENERACION DE JOBS PARA ACTUALIZAR DATOS
  -- Estado                     : Activo
  -- Acceso                     : Publico
  -- Parametros de Entrada      : 
  -- Parametros de Salida       : 
  -- Fecha de modificacion      :
  -- Autor de Modificacion      :
  -- Descripcion de Modificacion:
  -- ****************************************************************    
  --lc_coderr varchar2(2000);
 
  cursor c_job is  
    select distinct
           jaqz183di5 C_DIGITO5,
           jaqz183di6 C_DIGITO6,
           jaqz183di3 C_DIGITO3,
           jaqz183di4 C_DIGITO4,      
           jaqz183di1 C_DIGITO1,
           jaqz183di2 C_DIGITO2        
    from jaqz183;--140  
    
  cursor c_trigger(lc_estado in varchar2) is  
   select 'alter trigger '||user||'.'||trim(c_descri)||' '||lc_estado sentencia
    from crdtcap ;
                                   
  lc_variable   varchar2(4000);
  ln_job        number:= 0;
  ln_ini number:=0;
  lc_hostname varchar2(64);
  lc_msgerr   varchar2(300);
  NUM_JOB_PENDIENTES number(10);


  begin 
  execute immediate ('delete from tab_jobs where c_codage=''CTSUPD''');    
  execute immediate ('truncate table jaqz183');                 
  execute immediate ('truncate table crdtcap');                   
  --
  -- Obtenemos el HOST
  --
  begin
    select host_name
      into lc_hostname
      from v$instance;
  end;
  
  -- cargamos los datos a la tabla de jobs
     pq_cl_actualiza_datos.sp_ah_carga_data;    
     
  --Desabilitamos los trigguers
    insert into crdtcap (c_descri)
    select TRIGGER_NAME from user_triggers where table_name in ('FSX001','FSX008','FSR006','FSR005','SNGC17','SNGC13')
    and status='ENABLED' and triggering_event in ('INSERT','UPDATE') and TRIGGER_NAME not like 'T_AUD_%';    
    commit;
    
    lc_variable :='';
    for i in c_trigger('disable') loop
      lc_variable := i.sentencia;
       execute immediate (lc_variable);    
    End loop;  
     
  --
  -- Barridos de jobs
  --  
  for job in c_job loop
       ln_ini := ln_ini + 1;  
       lc_variable := ' begin '||'  pq_cl_actualiza_datos.sp_cl_datos('||''''  ||job.C_DIGITO1|| ''''||','||''''|| job.C_DIGITO2 ||''''||','||''''|| job.C_DIGITO3 ||''''||','||''''|| job.C_DIGITO4 ||''''||','||''''|| job.C_DIGITO5 ||''''||','||''''|| job.C_DIGITO6 ||''''||','||ln_ini||');'|| ' End; ';
       ln_job := ln_job +1;
      -- dbms_output.put_line (lc_variable);
         
       dbms_scheduler.create_job(
         job_name=> 'ACTUALIZA_DATOS'||LPAD(TO_CHAR(ln_job),5,'0'),
         job_type=> 'PLSQL_BLOCK',
         job_action=> lc_variable,
         start_date => sysdate+1/(24*180),
         enabled => true, 
         auto_drop=> TRUE,
         
         comments => 'ACTUALIZA DATA'
         );

--      if UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101') then      
IF SYS.FN_BD_ISRAC='TRUE' THEN
         begin        
            dbms_scheduler.set_attribute('ACTUALIZA_DATOS'||LPAD(TO_CHAR(ln_job),5,'0'),'instance_id',1);
         end; 
      else
         begin
            dbms_scheduler.set_attribute('ACTUALIZA_DATOS'||LPAD(TO_CHAR(ln_job),5,'0'),'instance_id',2);
         end; 
      end if;
      
      ---- INSERTA TABLA CONTROL

      INSERT INTO Tab_jobs (c_codage,n_Numer1,c_detjob)
      VALUES('CTSUPD',ln_ini,lc_variable);
      COMMIT;        
  commit;
  end loop;
  
  NUM_JOB_PENDIENTES := FN_MG_VERIFICA_TAREA(pi_vc2_nomjob => 'ACTUALIZA_DATOS',--
                                             pi_vc2_nomusr => USER
                                            );
  --ESPERAMOS QUE TERMINEN LOS SCHEDULERS
  WHILE NUM_JOB_PENDIENTES >0 LOOP

         NUM_JOB_PENDIENTES := FN_MG_VERIFICA_TAREA(pi_vc2_nomjob => 'ACTUALIZA_DATOS',
                                                    pi_vc2_nomusr => USER
                                                   );
  END LOOP;  
     
  IF NUM_JOB_PENDIENTES = 0 THEN  
    --habilitamos los triggers
      lc_variable :='';
      for i in c_trigger('enable') loop
        lc_variable := i.sentencia;
         execute immediate (lc_variable);    
      End loop;          
    --Terminando los SCHEDULERS afiliamos
     pq_cl_actualiza_datos.sp_ah_afilia_jaqz173;       
     commit; 
  END IF;  
  
  exception
  when others then
       lc_msgerr := 'Error Query de extracción'||'-'||sqlerrm;
       insert into log_error_bandeja(n_nro,c_codbdj,c_deserr,d_fecerr) values(99,'CTSUPD',lc_msgerr,TRUNC(sysdate));                             
       commit;
       return;
  end sp_cl_jobs;
  
  procedure sp_cl_datos(P_C_DIGITO1 IN VARCHAR2,
                        P_C_DIGITO2 IN VARCHAR2,            
                        P_C_DIGITO3 IN VARCHAR2,            
                        P_C_DIGITO4 IN VARCHAR2,            
                        P_C_DIGITO5 IN VARCHAR2,            
                        P_C_DIGITO6 IN VARCHAR2,                                                                                                                                                            
                        ln_ini      in number
                        ) is
  -- ****************************************************************
  -- Nombre                     : sp_cl_datos
  -- Sistema                    : BANTOTAL
  -- Modulo                     : Personas
  -- Version                    : 1.0
  -- Fecha de Creacion          : 17/10/2017
  -- Autor de Creacion          : YLOZADA
  -- Uso                        : Copia los datos de dirección legal mail y celular a los campos de dirección de correspondencia(de persona y de cuenta cliente)
  -- Estado                     : Activo
  -- Acceso                     : Publico
  -- Parametros de Entrada      : 
  -- Parametros de Salida       : 
  -- Fecha de modificacion      :
  -- Autor de Modificacion      :
  -- Descripcion de Modificacion:
  -- ****************************************************************  
  lc_dir  char(1):='N'; 
  ln_corr NUMBER(9):=0;
  --lc_coderr varchar2(400);
  lc_msgerr varchar2(300);

  
 cursor c_personas is
  select a.jaqz183pai pepais,
         a.jaqz183tpo petdoc,
         a.jaqz183num pendoc,      
         a.jaqz183tip tipo
    from JAQZ183 a
   where jaqz183di5 =    P_C_DIGITO5 
     and jaqz183di6 =    P_C_DIGITO6 
     and jaqz183di3 =    P_C_DIGITO3 
     and jaqz183di4 =    P_C_DIGITO4
     and jaqz183di1 =    P_C_DIGITO1 
     and jaqz183di2 =    P_C_DIGITO2
     ;    

  cursor base(ln_pepais in number,ln_petdoc in number,lc_pendoc in char) is
    select b.ctnro
      from fsr008 b
     where b.pgcod  = 1
       and b.cttfir = 'T'
       and b.pepais = ln_pepais
       and b.petdoc = ln_petdoc
       and b.pendoc = lc_pendoc;
  begin
  -- inicio de job
  update tab_jobs g
     set g.d_fecini = sysdate
   where g.n_numer1 =  ln_ini
     and g.c_codage = 'CTSUPD';
  commit;  
  
  --
  for i in c_personas loop
  if i.tipo = 'C' then  
    begin
      select 'S', A.SNGC13CORR
        into lc_dir, ln_corr
        from sngc13 a 
       where a.sngc13pais = I.pepais  
         and a.sngc13tdoc = I.petdoc 
         and a.sngc13ndoc = I.pendoc 
         and a.docod      = 2
         and a.sngc13est  = 'H';
    exception
    When no_data_found then  
      begin   
        select 'N',NVL(max(a.sngc13corr),0)
          into lc_dir,ln_corr
          from sngc13 a 
         where a.sngc13pais = I.pepais  
           and a.sngc13tdoc = I.petdoc 
           and a.sngc13ndoc = I.pendoc 
           and a.docod      = 2;
      exception
      when others then 
           lc_dir := 'N';
           ln_corr := 0;
      end;
    when others then     
         lc_dir := 'N';
         ln_corr := 0;
    end;
    
    IF lc_dir ='N' then
           begin
              ---INSERTAMOS LA DIRECCION DE CORRESPONDENCIA
              insert into sngc13 
                select sngc13pais,
                       sngc13tdoc,
                       sngc13ndoc,
                       2,     
                       ln_corr + 1,
                       sngc13pdoc,
                       sngc12vivc,
                       sngc01id  ,
                       sngc02id  ,
                       sngc03id  ,
                       sngc04id  ,
                       sngc05id  ,
                       sngc06id  ,
                       sngc13dsc2,
                       sngc13dsc3,
                       sngc13dsc1,
                       sngc13dsc4,
                       sngc13dsc5,
                       sngc13dsc6,
                       sngc13ugeo,
                       sngc13dpto,
                       sngc13prov,
                       sngc13dist,
                       sngc13cneg,
                       sngc13ref ,
                       sngc13ref1,
                       sngc13dir ,
                       sngc13rdes,
                       sngc13arr ,
                       sngc13atel,
                       sngc13fhab,
                       sngc13est ,
                       sngc13dest,
                       nvl(sngc13fdir,to_date(trunc(sysdate),'dd/mm/rrrr')),
                       sngc13user,
                       sngc13col ,
                       sngc13tas         
                  from sngc13 a 
                 where a.sngc13pais = I.pepais  
                   and a.sngc13tdoc = I.petdoc 
                   and a.sngc13ndoc = I.pendoc 
                   and a.docod      = 1
                   and a.sngc13est  = 'H';           
                   
              insert into jaqz184 
                select sngc13pais,
                       sngc13tdoc,
                       sngc13ndoc,
                       1,     
                       ln_corr + 1,
                       sngc13pdoc,
                       sngc12vivc,
                       sngc01id  ,
                       sngc02id  ,
                       sngc03id  ,
                       sngc04id  ,
                       sngc05id  ,
                       sngc06id  ,
                       sngc13dsc2,
                       sngc13dsc3,
                       sngc13dsc1,
                       sngc13dsc4,
                       sngc13dsc5,
                       sngc13dsc6,
                       sngc13ugeo,
                       sngc13dpto,
                       sngc13prov,
                       sngc13dist,
                       sngc13cneg,
                       sngc13ref ,
                       sngc13ref1,
                       sngc13dir ,
                       sngc13rdes,
                       sngc13arr ,
                       sngc13atel,
                       sngc13fhab,
                       sngc13est ,
                       sngc13dest,
                       nvl(sngc13fdir,to_date(trunc(sysdate),'dd/mm/rrrr')),
                       sngc13user,
                       sngc13col ,
                       sngc13tas,
                       sysdate         
                  from sngc13 a 
                 where a.sngc13pais = I.pepais  
                   and a.sngc13tdoc = I.petdoc 
                   and a.sngc13ndoc = I.pendoc 
                   and a.docod      = 1
                   and a.sngc13est  = 'H';                       
           exception
           when dup_val_on_index then
              lc_msgerr := 'Cliente presenta 2 direcciones legales vigentes';
              insert into log_error_bandeja(n_nro,c_codbdj,c_deserr,d_fecerr) values(ln_ini,'SNGC13','003-'||i.pepais||'-'||i.petdoc||'-'||i.pendoc||' - '||lc_msgerr,TRUNC(sysdate));               
           when others then
              rollback;
              lc_msgerr := sqlerrm;
                update tab_jobs g
                  set g.c_inderr = 'S',
                      g.c_deserr = '001-'||lc_msgerr||'-'||i.pepais||'-'||i.petdoc||'-'||i.pendoc
                where g.n_numer1 = ln_ini
                  and g.c_codage = 'CTSUPD';
              commit;
              return;               
           end;
                 
        For j in base(I.pepais,I.petdoc,I.pendoc) loop        
           begin      
              insert into sngc13
                  SELECT 0,
                         0,
                         j.ctnro,
                         2,
                         ln_corr + 1,
                         sngc13pdoc,
                         sngc12vivc,
                         sngc01id,
                         sngc02id,
                         sngc03id,
                         sngc04id,
                         sngc05id,
                         sngc06id,
                         sngc13dsc2,
                         sngc13dsc3,
                         sngc13dsc1,
                         sngc13dsc4,
                         sngc13dsc5,
                         sngc13dsc6,
                         sngc13ugeo,
                         sngc13dpto,
                         sngc13prov,
                         sngc13dist,
                         sngc13cneg,
                         sngc13ref,
                         sngc13ref1,
                         sngc13dir,
                         sngc13rdes,
                         sngc13arr,
                         sngc13atel,
                         sngc13fhab,
                         sngc13est,
                         sngc13dest,
                         nvl(sngc13fdir,to_date(trunc(sysdate),'dd/mm/rrrr')),
                         sngc13user,
                         sngc13col,
                         sngc13tas
                    from sngc13 a
                   where a.sngc13pais = I.pepais
                     and a.sngc13tdoc = I.petdoc
                     and a.sngc13ndoc = I.pendoc
                     and a.docod      = 1
                     and a.sngc13est  = 'H';    
                     
              insert into jaqz184
                  SELECT 0,
                         0,
                         j.ctnro,
                         1,
                         ln_corr + 1,
                         sngc13pdoc,
                         sngc12vivc,
                         sngc01id,
                         sngc02id,
                         sngc03id,
                         sngc04id,
                         sngc05id,
                         sngc06id,
                         sngc13dsc2,
                         sngc13dsc3,
                         sngc13dsc1,
                         sngc13dsc4,
                         sngc13dsc5,
                         sngc13dsc6,
                         sngc13ugeo,
                         sngc13dpto,
                         sngc13prov,
                         sngc13dist,
                         sngc13cneg,
                         sngc13ref,
                         sngc13ref1,
                         sngc13dir,
                         sngc13rdes,
                         sngc13arr,
                         sngc13atel,
                         sngc13fhab,
                         sngc13est,
                         sngc13dest,
                         nvl(sngc13fdir,to_date(trunc(sysdate),'dd/mm/rrrr')),
                         sngc13user,
                         sngc13col,
                         sngc13tas,
                         sysdate
                    from sngc13 a
                   where a.sngc13pais = I.pepais
                     and a.sngc13tdoc = I.petdoc
                     and a.sngc13ndoc = I.pendoc
                     and a.docod      = 1
                     and a.sngc13est  = 'H';                       
           exception
           when dup_val_on_index then
              lc_msgerr := 'cuenta cliente presenta 2 direcciones legales vigentes';             
              insert into log_error_bandeja(n_nro,c_codbdj,c_deserr,d_fecerr) values(ln_ini,'SNGC13','002-'||i.pepais||'-'||i.petdoc||'-'||i.pendoc||' - '||lc_msgerr,TRUNC(sysdate));                             
           when others then
              rollback;
              lc_msgerr := sqlerrm;
                update tab_jobs g
                  set g.c_inderr = 'S',
                      g.c_deserr = '00z-'||lc_msgerr||'-'||i.pepais||'-'||i.petdoc||'-'||i.pendoc
                where g.n_numer1 = ln_ini
                  and g.c_codage = 'CTSUPD';
              commit;
              return;               
           end;                                                        
        End Loop;   
    End If;  
    --- REGISTRAMOS EL CELULAR DE CORRESPONDENCIA  
       ln_corr := 0;
           begin
              select NVL(max(x.sngc17corr),0)
                into ln_corr
                from sngc17 x 
               where x.sngc17pais = I.pepais    
                 and x.sngc17ndoc = I.pendoc
                 and x.sngc17tdoc = I.petdoc
                 and x.sngc17dcod = 1
                 and x.sngc16ttel <> 2;
           Exception
           when others then
               ln_corr := 99;
           end;   
                      
           if ln_corr > 0 then
             begin
                 insert into fsr005 
                 select pepais, 
                        petdoc, 
                        pendoc, 
                        2,  
                        99, 
                        dotelfp,
                        '',
                        'Correspondencia' 
                  from fsr005 x 
                 where x.pepais = I.pepais    
                   and x.petdoc = I.petdoc
                   and x.pendoc = I.pendoc
                   and x.docod  = 1
                   and x.doordp = ln_corr;    
                   
                 insert into jaqz184a 
                 select pepais, 
                        petdoc, 
                        pendoc, 
                        1,  
                        ln_corr, 
                        dotelfp,
                        x.dotlexp,
                        x.dofaxp,
                        sysdate 
                  from fsr005 x 
                 where x.pepais = I.pepais    
                   and x.petdoc = I.petdoc
                   and x.pendoc = I.pendoc
                   and x.docod  = 1
                   and x.doordp = ln_corr;                    
             exception
             when dup_val_on_index then
              lc_msgerr := 'celular de correspondencia ya existe';             
              insert into log_error_bandeja(n_nro,c_codbdj,c_deserr,d_fecerr) values(ln_ini,'FSR005','007-'||i.pepais||'-'||i.petdoc||'-'||i.pendoc||' - '||lc_msgerr,TRUNC(sysdate));                                            
             when others then
                rollback;
                lc_msgerr := sqlerrm;
                  update tab_jobs g
                    set g.c_inderr = 'S',
                        g.c_deserr = '007-'||lc_msgerr||'-'||i.pepais||'-'||i.petdoc||'-'||i.pendoc
                  where g.n_numer1 = ln_ini
                    and g.c_codage = 'CTSUPD';
                commit;
                return;  
             end;     
             begin            
                insert into sngc17
                select sngc17pais, 
                       sngc17ndoc,
                       sngc17tdoc,
                       2,
                       99,
                       sngc16ttel                                                      
                  from sngc17 x 
                 where x.sngc17pais = I.pepais    
                   and x.sngc17ndoc = I.pendoc
                   and x.sngc17tdoc = I.petdoc
                   and x.sngc17dcod = 1
                   and x.sngc17corr = ln_corr; 
                   
                insert into jaqz184b
                select sngc17pais, 
                       sngc17ndoc,
                       sngc17tdoc,
                       1,
                       ln_corr,
                       sngc16ttel,
                       sysdate                                                      
                  from sngc17 x 
                 where x.sngc17pais = I.pepais    
                   and x.sngc17ndoc = I.pendoc
                   and x.sngc17tdoc = I.petdoc
                   and x.sngc17dcod = 1
                   and x.sngc17corr = ln_corr;                    
             exception
             when dup_val_on_index then
              lc_msgerr := 'celular de correspondencia ya existe';             
              insert into log_error_bandeja(n_nro,c_codbdj,c_deserr,d_fecerr) values(ln_ini,'SNGC17','008-'||i.pepais||'-'||i.petdoc||'-'||i.pendoc||' - '||lc_msgerr,TRUNC(sysdate));                                                           
             when others then
                rollback;
                lc_msgerr := sqlerrm;
                  update tab_jobs g
                    set g.c_inderr = 'S',
                        g.c_deserr = '008-'||lc_msgerr||'-'||i.pepais||'-'||i.petdoc||'-'||i.pendoc
                  where g.n_numer1 = ln_ini
                    and g.c_codage = 'CTSUPD';
                commit;
                return;  
             end;   
                               
                For j in base(I.pepais,I.petdoc,I.pendoc) loop       
                  begin                
                     insert into sngc17
                       select 0, 
                              j.ctnro, 
                              0, 
                              2,
                              99, 
                              sngc16ttel
                         from sngc17 x
                        where x.sngc17pais = I.pepais   
                          and x.sngc17tdoc = I.petdoc
                          and x.sngc17ndoc = I.pendoc
                          and x.sngc17dcod = 1
                          and x.sngc17corr = ln_corr;
                          
                     insert into jaqz184b
                       select 0, 
                              j.ctnro, 
                              0, 
                              1,
                              ln_corr, 
                              sngc16ttel,
                              sysdate
                         from sngc17 x
                        where x.sngc17pais = I.pepais   
                          and x.sngc17tdoc = I.petdoc
                          and x.sngc17ndoc = I.pendoc
                          and x.sngc17dcod = 1
                          and x.sngc17corr = ln_corr;                          
                   exception
                   when dup_val_on_index then
                    lc_msgerr := 'celular de correspondencia ya existe';             
                    insert into log_error_bandeja(n_nro,c_codbdj,c_deserr,d_fecerr) values(ln_ini,'SNGC17','009-'||i.pepais||'-'||i.petdoc||'-'||i.pendoc||' - '||lc_msgerr,TRUNC(sysdate));                                                                 
                   when others then
                      rollback;
                      lc_msgerr := sqlerrm;
                        update tab_jobs g
                          set g.c_inderr = 'S',
                              g.c_deserr = '009-'||lc_msgerr||'-'||i.pepais||'-'||i.petdoc||'-'||i.pendoc
                        where g.n_numer1 = ln_ini
                          and g.c_codage = 'CTSUPD';
                      commit;
                      return;  
                   end;      
                   begin                                
                        insert into fsr006
                          select 1,
                                 j.ctnro,
                                 2,
                                 99,
                                 b.dotelfp,
                                 '',
                                 'Correspondencia' 
                            from fsr005 b
                           where b.pepais = I.pepais 
                             and b.petdoc = I.petdoc
                             and b.pendoc = I.pendoc
                             and b.docod  = 1
                             and b.doordp = ln_corr;   
                             
                        insert into jaqz184c
                          select 1,
                                 j.ctnro,
                                 1,
                                 ln_corr,
                                 b.dotelfp,
                                 b.dotlexp,
                                 b.dofaxp,
                                 sysdate 
                            from fsr005 b
                           where b.pepais = I.pepais 
                             and b.petdoc = I.petdoc
                             and b.pendoc = I.pendoc
                             and b.docod  = 1
                             and b.doordp = ln_corr;                               
                   exception
                   when dup_val_on_index then
                    lc_msgerr := 'celular de correspondencia ya existe';             
                    insert into log_error_bandeja(n_nro,c_codbdj,c_deserr,d_fecerr) values(ln_ini,'FSR006','010-'||i.pepais||'-'||i.petdoc||'-'||i.pendoc||' - '||lc_msgerr,TRUNC(sysdate));                                                                 
                   when others then
                      rollback;
                      lc_msgerr := sqlerrm;
                        update tab_jobs g
                          set g.c_inderr = 'S',
                              g.c_deserr = '010-'||lc_msgerr||'-'||i.pepais||'-'||i.petdoc||'-'||i.pendoc
                        where g.n_numer1 = ln_ini
                          and g.c_codage = 'CTSUPD';
                      commit;
                      return;  
                   end;                                                                                 
                End loop;                 
           End If;     
       --End If;   
  end if;
  
  if i.tipo = 'M' then       

       ---ACTUALIZAMOS EL MAIL DE CORRESPONDENCIA
       begin
          select NVL(max(x.pexren),0)
            into ln_corr
            from fsx001 x 
           where x.pepais = I.pepais    
             and x.petdoc = I.petdoc
             and x.pendoc = I.pendoc
             and x.txcod = 0;
       Exception
       when others then
         ln_corr := 99;
       end;    
       
       if ln_corr > 0 then  
          begin
            update fsx001 x  
               set x.Pextxt = substr(SubStr(Pextxt,1,(Instr(Pextxt,'\')-1))||'\Correspondencia',1,65),
                   x.pexren = 99
             where x.pepais = I.pepais    
               and x.petdoc = I.petdoc
               and x.pendoc = I.pendoc
               and x.txcod  = 0
               and x.pexren = ln_corr;   
               
              insert into jaqz184d
              Select x.*,sysdate 
                from fsx001 x
               where x.pepais = I.pepais    
                 and x.petdoc = I.petdoc
                 and x.pendoc = I.pendoc
                 and x.txcod  = 0
                 and x.pexren = ln_corr;                
           exception
           when others then
              rollback;
              lc_msgerr := sqlerrm;
                update tab_jobs g
                  set g.c_inderr = 'S',
                      g.c_deserr = '011-'||lc_msgerr||'-'||i.pepais||'-'||i.petdoc||'-'||i.pendoc
                where g.n_numer1 = ln_ini
                  and g.c_codage = 'CTSUPD';
              commit;
              return;  
           end;                 
          For j in base(I.pepais,I.petdoc,I.pendoc) loop             
             begin
                update fsx008 x
                   set x.ctxtxt = Substr(SubStr(ctxtxt,1,(Instr(ctxtxt,'\')-1))||'\Correspondencia',1,65),
                       x.ctxren = 99
                 where x.pgcod  = 1
                   and x.ctnro  = j.ctnro
                   and x.txcod  = 0
                   and x.ctxren = ln_corr;
                   
                  insert into jaqz184e
                  Select x.*,sysdate 
                    from fsx008 x         
                   where x.pgcod  = 1
                     and x.ctnro  = j.ctnro
                     and x.txcod  = 0
                     and x.ctxren = ln_corr;                            
             exception
             when others then
                rollback;
                lc_msgerr := sqlerrm;
                  update tab_jobs g
                    set g.c_inderr = 'S',
                        g.c_deserr = '012-'||lc_msgerr||'-'||i.pepais||'-'||i.petdoc||'-'||i.pendoc
                  where g.n_numer1 = ln_ini
                    and g.c_codage = 'CTSUPD';
                commit;
                return;  
             end;                   
          End loop;                 
       End if;

  end if;      
  end loop;    
  

  -- 
  update tab_jobs g
     set g.d_fecfin = sysdate
   where g.n_numer1 =  ln_ini
     and g.c_codage = 'CTSUPD';
  commit;
  Exception
  when others then
    rollback;
    lc_msgerr := sqlerrm;
      update tab_jobs g
        set g.c_inderr = 'S',
            g.c_deserr = lc_msgerr
      where g.n_numer1 = ln_ini
        and g.c_codage = 'CTSUPD';
    commit;
    return;             
  end sp_cl_datos;  
        
  procedure sp_ah_carga_data is
    lc_msgerr varchar2(300);
  begin
      insert into jaqz183
      Select qq.pepais,
             qq.petdoc,
             qq.pendoc,
             qq.tipo,
             SUBSTR(TRIM(qq.pendoc),-1,1),       
             SUBSTR(TRIM(qq.pendoc),-2,1),      
             SUBSTR(LPAD(qq.petdoc,2,'0'),-1,1),  
             SUBSTR(LPAD(qq.petdoc,2,'0'),-2,1),  
             SUBSTR(qq.pepais,-1,1),              
             SUBSTR(qq.pepais,-2,1)              
          from (
                 (
                  select distinct 
                         a.pepais, 
                         a.petdoc, 
                         a.pendoc,
                         'C' tipo
                    from fsr008  a,
                         fsr005  b,
                         sngc17  c,
                         fsd011  y       
                   where a.pepais = b.pepais
                     and a.petdoc = b.petdoc
                     and a.pendoc = b.pendoc
                     and b.pepais = c.sngc17pais
                     and b.petdoc = c.sngc17tdoc
                     and b.pendoc = c.sngc17ndoc
                     and b.docod  = c.sngc17dcod
                     and b.doordp = c.sngc17corr
                     and c.sngc16ttel <> 2
                     and c.sngc16ttel <> 0
                     and b.docod  = 1
                     and b.doordp <> 99
                     and a.pgcod = y.pgcod
                     and a.ctnro = y.sccta
                     and y.scstat <> 99
                     and y.scpap = 0
                     and y.scoper = 0
                     and y.sctope = 2
                     and y.scmod  = 21
                     and a.ttcod = 1
                     and a.pgcod = 1
                     and a.cttfir = 'T'--tienen algun celular registrado  
                  minus 
                  select distinct
                         a.pepais,
                         a.petdoc,
                         a.pendoc,
                         'C' tipo
                    from fsr008  a,
                         fsr005  b,
                         sngc17  c,                   
                         fsd011  y              
                   where a.pepais = b.pepais
                     and a.petdoc = b.petdoc
                     and a.pendoc = b.pendoc
                     and b.pepais = c.sngc17pais
                     and b.petdoc = c.sngc17tdoc
                     and b.pendoc = c.sngc17ndoc
                     and b.docod  = c.sngc17dcod
                     and b.doordp = c.sngc17corr
                     and b.docod  = 2
                     and b.doordp = 99
                     and a.pgcod = y.pgcod
                     and a.ctnro = y.sccta
                     and y.scstat <> 99
                     and y.scpap = 0
                     and y.scoper = 0
                     and y.sctope = 2
                     and y.scmod  = 21
                     and a.ttcod = 1
                     and a.pgcod = 1
                     and a.cttfir = 'T'--tienen celular de correspondencia
                 ) -- 7699 no tienen celular de correspondencia pero tiennen almenos un celular ¿para que lo sea
                                   
                     
                   union all  

                  ( 
                  select distinct
                         c.pepais, 
                         c.petdoc, 
                         c.pendoc,
                         'M' tipo 
                    from fsr008  c,
                         fsx001  d,
                         fsd011  x                               
                   where c.pepais = d.pepais
                     and c.petdoc = d.petdoc
                     and c.pendoc = d.pendoc
                     and d.txcod  = 0
                     and d.pexren <> 99
                     and case
                           when REGEXP_LIKE(substr(d.pextxt,1,instr(d.pextxt,'\')-1),
                                                  '^[a-z0-9._-]+@[a-z0-9.-]+\.[a-z]{2,6}$',
                                                  'i') then
                                  'S'
                           else
                                  'N'
                           end = 'S'                    
                     and c.pgcod = x.pgcod
                     and c.ctnro = x.sccta
                     and x.scstat <> 99
                     and x.scpap = 0
                     and x.scoper = 0
                     and x.sctope = 2
                     and x.scmod  = 21
                     and c.ttcod = 1
                     and c.pgcod = 1
                     and c.cttfir = 'T'--tienen alemnos un mail que no es de correspondencia             
                  minus  
                  select distinct
                         c.pepais, 
                         c.petdoc, 
                         c.pendoc,
                         'M' tipo
                    from fsr008  c,
                         fsx001  d,
                         fsd011  x           
                   where c.pepais = d.pepais
                     and c.petdoc = d.petdoc
                     and c.pendoc = d.pendoc
                     and d.txcod  = 0
                     and d.pexren = 99
                     and case
                           when REGEXP_LIKE(substr(d.pextxt,1,instr(d.pextxt,'\')-1),
                                                  '^[a-z0-9._-]+@[a-z0-9.-]+\.[a-z]{2,6}$',
                                                  'i') then
                                  'S'
                           else
                                  'N'
                           end = 'S'                    
                     and c.pgcod = x.pgcod
                     and c.ctnro = x.sccta
                     and x.scstat <> 99
                     and x.scpap = 0
                     and x.scoper = 0
                     and x.sctope = 2
                     and x.scmod  = 21
                     and c.ttcod = 1
                     and c.pgcod = 1
                     and c.cttfir = 'T'-- tienen mail de correspondencia             
                  )-- no tiennen mail de correspondencia pero tienne almenos 1 mail para que lo sea                        
               ) qq ; 
               commit;  
  exception 
  when others then     
       lc_msgerr := 'Error Query de extracción'||'-'||sqlerrm;
       insert into log_error_bandeja(n_nro,c_codbdj,c_deserr,d_fecerr) values(99,'CTSUPD',lc_msgerr,TRUNC(sysdate));                             
       commit;
       return;
  end sp_ah_carga_data;    
  
  procedure sp_ah_afilia_jaqz173 is   
  lc_msgerr varchar2(300);     
    
  begin     
    --PRIMERO AFILIAMOS LOS QUE TENGAN MAIL DE CORRESPONDENCIA
    begin
              MERGE INTO JAQZ173 D
              USING (                  
                      Select distinct
                             c.pepais pepais,
                             c.petdoc petdoc,
                             c.pendoc pendoc,
                             1        servicio,-- 1 Afiliacion comunicacion CTS
                             1        medio,   -- 1 mail 2 sms   
                             0        dpt,       
                             0        prv,       
                             0        dis,
                             null     dir,
                             0        tte,
                             null     tel,                 
                             substr(c.pextxt,1,instr(c.pextxt,'\')-1) dato,
                             'A' est,
                             trunc(sysdate) fec,
                             to_char(sysdate,'HH24:mi:ss') hor,
                             'BANTOTAL' usr,
                             '904' age
                        from fsd011 a,
                             fsr008 b,
                             fsx001 c
                       where a.pgcod = b.pgcod
                         and a.sccta = b.ctnro
                         and b.ttcod = 1
                         and b.pgcod = 1
                         and b.cttfir = 'T'                                                  
                         and a.scpap = 0
                         and a.scoper = 0                         
                         and a.scmod = 21       
                         and a.sctope = 2
                         and a.scstat <> 99
                         and b.pepais = c.pepais
                         and b.petdoc = c.petdoc
                         and b.pendoc = c.pendoc
                         and c.txcod  = 0
                         and c.pexren = 99
                         and case
                             when REGEXP_LIKE(substr(c.pextxt,1,instr(c.pextxt,'\')-1),
                                                    '^[a-z0-9._-]+@[a-z0-9.-]+\.[a-z]{2,6}$',
                                                    'i') then
                                    'S'
                             else
                                    'N'
                             end = 'S'                            
                                
                    ) S            
             ON (   D.JAQZ173PAI = S.pepais
                AND D.JAQZ173TPO = S.petdoc
                AND D.JAQZ173NUM = S.pendoc
                AND D.JAQZ173SER = S.servicio
                )
            WHEN MATCHED THEN
               UPDATE SET D.JAQZ173MAI = decode(D.JAQZ173MED,1,S.Dato,D.JAQZ173MAI) 
            WHEN NOT MATCHED THEN                
              INSERT
                (D.JAQZ173PAI,
                 D.JAQZ173TPO,
                 D.JAQZ173NUM,
                 D.JAQZ173SER,
                 D.JAQZ173MED,
                 D.JAQZ173DPT,
                 D.JAQZ173PRV,
                 D.JAQZ173DIS,
                 D.JAQZ173DIR,
                 D.JAQZ173TTE,
                 D.JAQZ173TEL,
                 D.JAQZ173MAI,
                 D.JAQZ173EST,
                 D.JAQZ173FEC,
                 D.JAQZ173HOR,
                 D.JAQZ173USR,
                 D.JAQZ173AGE
                 )
              VALUES
                (S.pepais,
                 S.petdoc,
                 S.pendoc,
                 S.servicio,
                 S.medio,
                 S.dpt,
                 S.prv,
                 S.dis,
                 S.dir,
                 S.tte,                
                 S.tel,
                 S.dato,
                 S.est,                     
                 S.fec,
                 S.hor,
                 S.usr,
                 S.age
                 );          
    exception
    when others then  
       lc_msgerr := 'CTSMAIL - '|| sqlerrm;
       insert into log_error_bandeja(n_nro,c_codbdj,c_deserr,d_fecerr) values(99,'JAQZ173',lc_msgerr,TRUNC(sysdate));                              
       commit;
       return;      
    end;
    commit;
    
    --AFILIAMOS A LOS QUE TIENEN CELULAR DE CORRESPONDENCIA
    begin
              MERGE INTO JAQZ173 D
              USING (                  
                      Select distinct
                             a.pepais pepais,
                             a.petdoc petdoc,
                             a.pendoc pendoc,
                             1        servicio,-- 1 Afiliacion comunicacion CTS
                             2        medio,   -- 1 mail 2 sms   
                             0        dpt,       
                             0        prv,       
                             0        dis,
                             null     dir,
                             trim(c.sngc16ttel)  tte,
                             trim(b.dotelfp)     tel,                 
                             null dato,
                             'A' est,
                             trunc(sysdate) fec,
                             to_char(sysdate,'HH24:mi:ss') hor,
                             'BANTOTAL' usr,
                             '904' age
                       from fsr008  a,
                            fsr005  b,
                            sngc17  c,
                            fsd011  y       
                      where a.pepais = b.pepais
                        and a.petdoc = b.petdoc
                        and a.pendoc = b.pendoc
                        and b.pepais = c.sngc17pais
                        and b.petdoc = c.sngc17tdoc
                        and b.pendoc = c.sngc17ndoc
                        and b.docod  = c.sngc17dcod
                        and b.doordp = c.sngc17corr
                        and c.sngc16ttel <> 2
                        and c.sngc16ttel <> 0
                        and b.docod  = 2
                        and b.doordp = 99
                        and a.pgcod = y.pgcod
                        and a.ctnro = y.sccta
                        and y.scstat <> 99
                        and y.scpap = 0
                        and y.scoper = 0
                        and y.sctope = 2
                        and y.scmod  = 21
                        and a.ttcod = 1
                        and a.pgcod = 1
                        and a.cttfir = 'T'                          
                        and length(trim(b.dotelfp)) = 9
                        and case
                            when REGEXP_LIKE(trim(b.dotelfp), '[^0-9]') then
                             'N'
                            else
                             'S'
                            end = 'S'                          
                    ) S            
             ON (   D.JAQZ173PAI = S.pepais
                AND D.JAQZ173TPO = S.petdoc
                AND D.JAQZ173NUM = S.pendoc
                AND D.JAQZ173SER = S.servicio
                )
            WHEN MATCHED THEN
               UPDATE SET D.JAQZ173TEL = decode(D.JAQZ173MED,2,S.tel,D.JAQZ173TEL) 
            WHEN NOT MATCHED THEN                
              INSERT
                (D.JAQZ173PAI,
                 D.JAQZ173TPO,
                 D.JAQZ173NUM,
                 D.JAQZ173SER,
                 D.JAQZ173MED,
                 D.JAQZ173DPT,
                 D.JAQZ173PRV,
                 D.JAQZ173DIS,
                 D.JAQZ173DIR,
                 D.JAQZ173TTE,
                 D.JAQZ173TEL,
                 D.JAQZ173MAI,
                 D.JAQZ173EST,
                 D.JAQZ173FEC,
                 D.JAQZ173HOR,
                 D.JAQZ173USR,
                 D.JAQZ173AGE
                 )
              VALUES
                (S.pepais,
                 S.petdoc,
                 S.pendoc,
                 S.servicio,
                 S.medio,
                 S.dpt,
                 S.prv,
                 S.dis,
                 S.dir,
                 S.tte,                
                 S.tel,
                 S.dato,
                 S.est,                     
                 S.fec,
                 S.hor,
                 S.usr,
                 S.age
                 );         
    exception
    when others then  
       lc_msgerr := 'CTSSMS - '|| sqlerrm;
       insert into log_error_bandeja(n_nro,c_codbdj,c_deserr,d_fecerr) values(99,'JAQZ173',lc_msgerr,TRUNC(sysdate));                              
       commit;
       return;            
    end; 
    commit;   
    
    --AFILIAMOS A ICHANNEL LOS SMS
    begin
              MERGE INTO /*CLIENTES_AFILIADOS@ICHANNEL*/ichannelalert.CLIENTES_AFILIADOS D
              USING (                  
                     Select 'S' || lpad(to_char(a.jaqz173pai), 3, '0') ||
                            lpad(to_char(a.jaqz173tpo), 2, '0') ||
                            lpad(trim(a.jaqz173num), 12, '0') CODIGO_CLIENTE,                                
                            trim(c.pfape1) || ' ' || trim(c.pfape2) || ' , ' || trim(c.pfnom1) || ' ' ||
                            trim(c.pfnom2) NOMBRE_CLIENTE,
                            '' MAIL_CLIENTE,
                            to_number(trim(a.jaqz173tel)) CELULAR_CLIENTE,
                            c.Pfcant SEXO_CLIENTE,
                            'S' ENVIAR_CELULAR,
                            'N' ENVIAR_MAIL
                       from jaqz173 a, fsd002 c
                      where a.jaqz173pai = c.pfpais
                        and a.jaqz173tpo = c.pftdoc
                        and a.jaqz173num = c.pfndoc
                        and a.jaqz173ser = 1
                        and a.jaqz173med = 2
                        and a.jaqz173est = 'A'   
                        and length(trim(a.jaqz173tel)) = 9
                        and case
                            when REGEXP_LIKE(trim(a.jaqz173tel), '[^0-9]') then
                             'N'
                            else
                             'S'
                            end = 'S'                          

                    ) S            
             ON (   D.CODIGO_CLIENTE = S.CODIGO_CLIENTE
                )
            WHEN MATCHED THEN
                  UPDATE SET D.CELULAR_CLIENTE = S.CELULAR_CLIENTE                     
            WHEN NOT MATCHED THEN                
              INSERT
                (D.CODIGO_CLIENTE,
                 D.NOMBRE_CLIENTE,
                 D.MAIL_CLIENTE,
                 D.CELULAR_CLIENTE,
                 D.SEXO_CLIENTE,
                 D.ENVIAR_CELULAR,
                 D.ENVIAR_MAIL
                 )
              VALUES
                (S.CODIGO_CLIENTE,
                 S.NOMBRE_CLIENTE,
                 S.MAIL_CLIENTE,
                 S.CELULAR_CLIENTE,
                 S.SEXO_CLIENTE,
                 S.ENVIAR_CELULAR,
                 S.ENVIAR_MAIL
                 );         
    exception
    when others then  
       lc_msgerr := 'CTSSMS - '|| sqlerrm;
       insert into log_error_bandeja(n_nro,c_codbdj,c_deserr,d_fecerr) values(99,'ICHANNEL',lc_msgerr,TRUNC(sysdate));                              
       commit;
       return;            
    end; 
    commit;       

  exception
  when others then                                                                                                                                            
       lc_msgerr := sqlerrm;
       insert into log_error_bandeja(n_nro,c_codbdj,c_deserr,d_fecerr) values(99,'JAQZ173',lc_msgerr,TRUNC(sysdate));                              
   COMMIT;    
   return;   
  end;                   
  FUNCTION fn_mg_verifica_tarea(pi_vc2_nomjob IN VARCHAR2
                                ,pi_vc2_nomusr IN VARCHAR2)
   RETURN NUMBER IS

   num_job NUMBER(10);

  BEGIN

   SELECT COUNT(1)
     INTO num_job
     FROM dba_scheduler_jobs job
    WHERE owner = pi_vc2_nomusr
      AND job.job_name LIKE pi_vc2_nomjob || '%';

   RETURN num_job;

  END fn_mg_verifica_tarea;  
end pq_cl_actualiza_datos;
/

