create or replace package PQ_MIGRA_MICRO_CRED_ACT_CDK is

  -- Author  : YLOZADA
  -- Created : 03/12/2015 10:01:25 a.m.
  -- Purpose : 
  Procedure sp_lanza_activas;          
  Procedure sp_job_evaluaciones;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  Procedure sp_migra_evaluaciones(P_C_DIGITO1 IN VARCHAR2,
                                  P_C_DIGITO2 IN VARCHAR2,
                                  p_n_ini      in number
                                 ); 
  Procedure sp_cr_sng001;
  Procedure sp_cr_sng003;
  Procedure sp_cr_xwf700;
  Procedure sp_cr_x054021;
  Procedure sp_cr_x054023;
  --Procedure sp_cr_sng410;
  --Procedure sp_cr_sng122;
  Procedure sp_cr_snge03;         
  Procedure sp_genera_valor(P_N_VALOR OUT NUMBER);
                                 

end PQ_MIGRA_MICRO_CRED_ACT_CDK;
/
create or replace package body PQ_MIGRA_MICRO_CRED_ACT_CDK is
  Procedure sp_lanza_activas is 
  lc_variable VARCHAR2(2000);
  ln_job NUMBER(10):= 0;    
  begin
    begin
        lc_variable :=NULL;
        lc_variable := ' begin pq_migra_micro_cred_act.sp_cr_sng001; End; ';
        ln_job := ln_job +1;


       dbms_scheduler.create_job(
             job_name=> 'SNG001'||LPAD(TO_CHAR(ln_job),5,'0'),
             job_type=> 'PLSQL_BLOCK',
             job_action=> lc_variable,
             start_date => sysdate+1/(24*180),
             enabled => true,
             auto_drop=> TRUE,
             comments => 'MIGRANDO SP_SNG001'
             );

        COMMIT;
    end; 
    begin
        lc_variable :=NULL;
        lc_variable := ' begin pq_migra_micro_cred_act.sp_cr_sng003; End; ';
        ln_job := ln_job +1;


       dbms_scheduler.create_job(
             job_name=> 'SNG003'||LPAD(TO_CHAR(ln_job),5,'0'),
             job_type=> 'PLSQL_BLOCK',
             job_action=> lc_variable,
             start_date => sysdate+1/(24*180),
             enabled => true,
             auto_drop=> TRUE,
             comments => 'MIGRANDO SP_SNG003'
             );

        COMMIT;
    end; 
    begin
        lc_variable :=NULL;
        lc_variable := ' begin pq_migra_micro_cred_act.sp_cr_xwf700; End; ';
        ln_job := ln_job +1;


       dbms_scheduler.create_job(
             job_name=> 'XWF700'||LPAD(TO_CHAR(ln_job),5,'0'),
             job_type=> 'PLSQL_BLOCK',
             job_action=> lc_variable,
             start_date => sysdate+1/(24*180),
             enabled => true,
             auto_drop=> TRUE,
             comments => 'MIGRANDO SP_XWF700'
             );

        COMMIT;
    end; 
    /*
    begin
        lc_variable :=NULL;
        lc_variable := ' begin pq_migra_micro_cred_act.sp_cr_x054021; End; ';
        ln_job := ln_job +1;


       dbms_scheduler.create_job(
             job_name=> 'X054021'||LPAD(TO_CHAR(ln_job),5,'0'),
             job_type=> 'PLSQL_BLOCK',
             job_action=> lc_variable,
             start_date => sysdate+1/(24*180),
             enabled => true,
             auto_drop=> TRUE,
             comments => 'MIGRANDO SP_X054021'
             );

        COMMIT;
    end; 
    */
    begin
        lc_variable :=NULL;
        lc_variable := ' begin pq_migra_micro_cred_act.sp_cr_x054023; End; ';
        ln_job := ln_job +1;


       dbms_scheduler.create_job(
             job_name=> 'X054023'||LPAD(TO_CHAR(ln_job),5,'0'),
             job_type=> 'PLSQL_BLOCK',
             job_action=> lc_variable,
             start_date => sysdate+1/(24*180),
             enabled => true,
             auto_drop=> TRUE,
             comments => 'MIGRANDO SP_X054023'
             );

        COMMIT;
    end; 
    /*
    begin
        lc_variable :=NULL;
        lc_variable := ' begin pq_migra_micro_cred_act.sp_cr_sng410; End; ';
        ln_job := ln_job +1;


       dbms_scheduler.create_job(
             job_name=> 'SNG410'||LPAD(TO_CHAR(ln_job),5,'0'),
             job_type=> 'PLSQL_BLOCK',
             job_action=> lc_variable,
             start_date => sysdate+1/(24*180),
             enabled => true,
             auto_drop=> TRUE,
             comments => 'MIGRANDO SP_SNG410'
             );

        COMMIT;
    end; 
    begin
        lc_variable :=NULL;
        lc_variable := ' begin pq_migra_micro_cred_act.sp_cr_sng122; End; ';
        ln_job := ln_job +1;


       dbms_scheduler.create_job(
             job_name=> 'SNG122'||LPAD(TO_CHAR(ln_job),5,'0'),
             job_type=> 'PLSQL_BLOCK',
             job_action=> lc_variable,
             start_date => sysdate+1/(24*180),
             enabled => true,
             auto_drop=> TRUE,
             comments => 'MIGRANDO SP_SNG122'
             );

        COMMIT;
    end; 
    */
    /*
    begin
        lc_variable :=NULL;
        lc_variable := ' begin pq_migra_micro_cred_act.sp_cr_snge03; End; ';
        ln_job := ln_job +1;


       dbms_scheduler.create_job(
             job_name=> 'SNGE03'||LPAD(TO_CHAR(ln_job),5,'0'),
             job_type=> 'PLSQL_BLOCK',
             job_action=> lc_variable,
             start_date => sysdate+1/(24*180),
             enabled => true,
             auto_drop=> TRUE,
             comments => 'MIGRANDO SP_SNGE03'
             );

        COMMIT;
    end;                         
    */
    --proceso de llenado de evaluaciones (lanza jobs)
    begin
      -- Call the procedure
      pq_migra_micro_cred_act.sp_job_evaluaciones;
    end;
    
  End sp_lanza_activas;  
  
  Procedure sp_job_evaluaciones is
       cursor c_job is
/*        SELECT \*+PARALLEL(T,2,1)*\
             SUBSTR(N_NROIST, -1, 1)             C_DIGITO1,
             SUBSTR(N_NROIST, -2, 1)             C_DIGITO2
        FROM bandejas.btevacre T
    GROUP BY SUBSTR(N_NROIST, -1, 1),
             SUBSTR(N_NROIST, -2, 1); */
             select 0 C_DIGITO1,
                    0 C_DIGITO2
              from dual;
   
           
  lc_variable   varchar2(4000);
  ln_job        number:= 0;
  ln_ini number:=0;             
  lc_error varchar2(400);
  begin         
    for job in c_job loop
         ln_ini := ln_ini + 1;  
         lc_variable := ' begin '||'  pq_migra_micro_cred_act.sp_migra_evaluaciones('||job.C_DIGITO1||','||job.C_DIGITO2||','||ln_ini||');'|| ' End; ';
         ln_job := ln_job +1;
         --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
         dbms_scheduler.create_job(
         job_name=> 'EVAL'||LPAD(TO_CHAR(ln_job),5,'0'),
         job_type=> 'PLSQL_BLOCK',
         job_action=> lc_variable,
         start_date => sysdate+1/(24*180),
         enabled => true, 
         auto_drop=> TRUE,
         comments => 'MIGRANDO EVALUACIONES'
         );
         COMMIT;
        -- INSERTA TABLA CONTROL

        INSERT INTO Tab_jobs (n_Numer1,c_detjob)
        VALUES(ln_ini,lc_variable);
        COMMIT;        
    commit;
    end loop;
    
  exception
  when others then
    LC_ERROR:= SQLERRM;
    INSERT INTO LOG_ERROR_BANDEJA (N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
    VALUES(111,'EVALC',lc_variable||'-'||LC_ERROR,SYSDATE);
    COMMIT;

  end sp_job_evaluaciones;
  
Procedure sp_migra_evaluaciones(P_C_DIGITO1 IN VARCHAR2,
                                 P_C_DIGITO2 IN VARCHAR2,
                                 p_n_ini      in number
                                 ) is
                              
 
  cursor c_eval is
  select n_codpai,n_tipdoc,n_numdoc,d_feceva,c_usuario,n_nroist, decode(n_tipeva,3,14,13) n_tipeva,decode(n_tipeva,3,3,1) c_codeva,d_estfin,n_tipcam,  
         --TOTALES
         nvl(NS_CAJBANCO,0)+nvl(NS_CTSXCOBC,0)+nvl(NS_MERCADER,0)+nvl(NS_GASPGANT,0)+nvl(NS_EXIRECIB,0)+nvl(NS_OTROACTV,0)+nvl(NS_MAQEQUIP,0)+nvl(NS_INMUEBLE,0)+nvl(NS_OTROBIEN,0) TOTAL_ACTIVO_S,
         nvl(NS_CTAXPAGB,0)+nvl(NS_TRBXPAGA,0)+nvl(NS_OTCTAXPA,0)+nvl(NS_CTAXPAGBL,0)+nvl(NS_BENSOCTRB,0)+nvl(NS_OTRBENTRB,0)+nvl(NS_CTAXPAGC,0) TOTAL_PASIVO_S,
         nvl(ND_CAJBANCO,0)+nvl(ND_CTSXCOBC,0)+nvl(ND_MERCADER,0)+nvl(ND_GASPGANT,0)+nvl(ND_EXIRECIB,0)+nvl(ND_OTROACTV,0)+nvl(ND_MAQEQUIP,0)+nvl(ND_INMUEBLE,0)+nvl(ND_OTROBIEN,0) TOTAL_ACTIVO_D,
         nvl(ND_CTAXPAGB,0)+nvl(ND_TRBXPAGA,0)+nvl(ND_OTCTAXPA,0)+nvl(ND_CTAXPAGBL,0)+nvl(ND_BENSOCTRB,0)+nvl(ND_OTRBENTRB,0)+nvl(ND_CTAXPAGC,0) TOTAL_PASIVO_D,         
    case
       when n_tipeva in (1,2) then
            '0'/*NS_VENTAS*/||'*#*'||'0'||'*#*'||NS_RESEJER||'*#*'||NS_CAJBANCO||'*#*'||NS_CTSXCOBC||'*#*'||
            NS_MERCADER||'*#*'||NS_GASPGANT||'*#*'||NS_EXIRECIB||'*#*'||NS_OTROACTV||'*#*'||'0'||'*#*'||
            NS_MAQEQUIP||'*#*'||NS_INMUEBLE||'*#*'||NS_OTROBIEN||'*#*'||'0'||'*#*'||'0'||'*#*'||
            NS_OTRING||'*#*'||NS_GASFAM||'*#*'||NS_CTAXPAGB||'*#*'||NS_TRBXPAGA||'*#*'||NS_OTCTAXPA||'*#*'||
            '0'||'*#*'||NS_CTAXPAGBL||'*#*'||NS_BENSOCTRB||'*#*'||NS_RESERVAS||'*#*'||NS_OTRBENTRB||'*#*'||
            '0'||'*#*'||'0'||'*#*'||NS_CAPITAL||'*#*'||NS_RESACUM||'*#*'||NS_RESEJER||'*#*'||
            NS_OTRRESU||'*#*'||'0'||'*#*'||'0'||'*#*'||'0'||'*#*'||NS_VENTAS||'*#*'||
            NS_CTOVTAS||'*#*'||'0'||'*#*'||NS_GASVTAS||'*#*'||NS_GASADM||'*#*'||'0'||'*#*'||
            NS_GASFIN||'*#*'||NS_INGFIN||'*#*'||NS_GASDIVE||'*#*'||'0'||'*#*'||NS_IMPUEST||'*#*'||
            '0'||'*#*'||NS_CTAXPAGC||'*#*'||                       
            --
            '0'||'*#*'||ND_CAJBANCO||'*#*'||ND_CTSXCOBC||'*#*'||ND_MERCADER||'*#*'||ND_GASPGANT||'*#*'||
            ND_EXIRECIB||'*#*'||ND_OTROACTV||'*#*'||'0'||'*#*'||ND_MAQEQUIP||'*#*'||ND_INMUEBLE||'*#*'||
            ND_OTROBIEN||'*#*'||'0'||'*#*'||'0'||'*#*'||ND_OTRING||'*#*'||ND_GASFAM||'*#*'||
            ND_CTAXPAGB||'*#*'||ND_TRBXPAGA||'*#*'||ND_OTCTAXPA||'*#*'||'0'||'*#*'||ND_CTAXPAGBL||'*#*'||
            ND_BENSOCTRB||'*#*'||ND_RESERVAS||'*#*'||ND_OTRBENTRB||'*#*'||'0'||'*#*'||'0'||'*#*'||
            ND_CAPITAL||'*#*'||ND_RESACUM||'*#*'||ND_RESEJER||'*#*'||ND_OTRRESU||'*#*'||'0'||'*#*'||
            '0'||'*#*'||ND_VENTAS||'*#*'||ND_CTOVTAS||'*#*'||'0'||'*#*'||ND_GASVTAS||'*#*'||
            ND_GASADM||'*#*'||'0'||'*#*'||ND_GASFIN||'*#*'||ND_INGFIN||'*#*'||ND_GASDIVE||'*#*'||
            '0'||'*#*'||ND_IMPUEST||'*#*'||'0'||'*#*'||ND_CTAXPAGC||'*#*'                        
       when n_tipeva in (3) then
            NS_SALBTOTI||'*#*'||NS_SALBTOCY||'*#*'||NS_SALBTOCOM||'*#*'||NS_SALBTOOTR||'*#*'||NS_APORTIT||'*#*'||
            NS_APORCYG||'*#*'||NS_APORCOM||'*#*'||'0'||'*#*'||'0'||'*#*'||'0'||'*#*'||
            '0'||'*#*'||NS_OTRINNET/*'0'*/||'*#*'||NS_GASALIM||'*#*'||NS_GASALQU||'*#*'||NS_GASTRANS||'*#*'||
            NS_GASEDUCA||'*#*'||NS_GASSERV||'*#*'||NS_APOFAMIL||'*#*'||NS_OTRGASTO||'*#*'||NS_IMPREVIS||'*#*'||
            '0'||'*#*'||'0'||'*#*'||'0'||'*#*'||'0'||'*#*'||'0'||'*#*'||
            NS_DEUBCO||'*#*'||'0'||'*#*'||'0'||'*#*'||'0'||'*#*'||'0'||'*#*'||
            '0'||'*#*'||
            --
            ND_SALBTOTI||'*#*'||ND_SALBTOCY||'*#*'||ND_SALBTOCOM||'*#*'||ND_SALBTOOTR||'*#*'||ND_APORTIT||'*#*'||
            ND_APORCYG||'*#*'||ND_APORCOM||'*#*'||'0'||'*#*'||'0'||'*#*'||'0'||'*#*'||
            '0'||'*#*'||ND_OTRINNET/*'0'*/||'*#*'||ND_GASALIM||'*#*'||ND_GASALQU||'*#*'||ND_GASTRANS||'*#*'||
            ND_GASEDUCA||'*#*'||ND_GASSERV||'*#*'||ND_APOFAMIL||'*#*'||ND_OTRGASTO||'*#*'||ND_IMPREVIS||'*#*'||
            '0'||'*#*'||'0'||'*#*'||'0'||'*#*'||ND_DEUBCO||'*#*'||'0'||'*#*'||
            '0'||'*#*'--||Ns_OtrInnet||'*#*'||Nd_OtrInnet||'*#*'
    end c_cadena  
   from bandejas.btevacre; --where c_codper ='0000089625';
 -- where SUBSTR(N_NROIST, -1, 1) = P_C_DIGITO1    
--    AND SUBSTR(N_NROIST, -2, 1) = P_C_DIGITO2;
 
  --ln_nro    log_carga_bandeja.n_nro%type;
  lc_msgerr varchar2(400);
  lc_error  varchar2(300);           
    
  ln_cont   number(10):=0;     
  ln_pos    number(10):=1;
  lc_valor  varchar2(400);
  ln_cadena number(10);
  ln_cdat   number(4);
  ln_ctd    number(4);
  ln_indcam number(1):= 0;
  ln_ini    number(10):=1;
  ln_monto number(15,2):=0;
  Ln_cuenta number := 0;      
  LN_CORREL number(10) := 0;         
  ld_fecpro date;              
  begin
  
    -- inicio de job
  update tab_jobs g
     set g.d_fecini = sysdate
   where g.n_numer1 =  p_n_ini;
  commit;  
  
  begin
    select a.pgfape into ld_fecpro from fst017 a where a.pgcod=1 ;
    end;
  for i in c_eval loop
           
     -- insertamos cabecera sng021
     
    begin
      -- Call the procedure
      pq_migra_micro_cred_act.sp_genera_valor(p_n_valor => LN_CORREL);
    end;     
     
     begin
         insert into sng021
           (SNG021EVAL,
            SNG021PDOC,
            SNG021TDOC,
            SNG021NDOC,
            SNG021FEC,
            SNG021USU,
            SNG021SOL,
            SNG021TMOD)
         values
           (LN_CORREL,--sq_cr_eval.NEXTVAL,
            i.n_codpai,
            i.n_tipdoc,
            i.n_numdoc,--to_char(to_number(trim(i.n_numdoc))),
            i.d_feceva,
            i.c_usuario,
            i.n_nroist,
            i.n_tipeva);
     Ln_cuenta := Ln_cuenta + 1;      
     if mod(Ln_cuenta,10000) = 0 then
        commit;
        Ln_cuenta := 0;
     end if;                                
     exception
     when others then
      lc_error := sqlerrm;            
      --select sq_cr_eval.currval into ln_nro from dual;
      
        insert into LOG_ERROR_BANDEJA
          (n_nro,c_codbdj,c_deserr,d_fecerr)
        values
          (LN_CORREL/*ln_nro*/,'sng021',i.n_nroist || ' : ' || lc_error,sysdate);
        commit;         
     end;        
     --select sq_cr_eval.currval into ln_nro from dual;

     begin
              insert into sng120
                (SNG120INS,
                 SNG120TSK,
                 SNG120MOD,
                 SNG120TOP,
                 SNG120MDA,
                 SNG120PAP,
                 SNG120PZO,
                 SNG120CUO,
                 SNG120PER,
                 SNG120CLIQ,
                 SNG120MTO,
                 SNG120MCR,
                 SNG120FVAL,
                 SNG120FPAG,
                 SNG120FVTO,
                 SNG120VCUO,
                 SNG120TTAS,
                 SNG120CLTA,
                 SNG120TASA,
                 SNG120PLUS,
                 SNG120TCBI)
              values
                (i.n_nroist,
                 'EVALUACION',
                 0,
                 0,
                 0,
                 0,
                 0,
                 0,
                 0,
                 NULL,
                 0,
                 0,
                 i.d_feceva,
                 i.d_feceva,
                 i.d_estfin,
                 0,
                 0,
                 0,
                 0,
                 0,
                 i.n_tipcam --0  tipo de cambio
                 );
     Ln_cuenta := Ln_cuenta + 1;      
     if mod(Ln_cuenta,10000) = 0 then
        commit;
        Ln_cuenta := 0;
     end if;                                
     exception
     when others then
      lc_error := sqlerrm;            
      --select sq_cr_eval.currval into ln_nro from dual;      
        insert into LOG_ERROR_BANDEJA
          (n_nro,c_codbdj,c_deserr,d_fecerr)
        values
          (LN_CORREL/*ln_nro*/,'sng120',i.n_nroist || ' : ' || lc_error,sysdate);
        commit;                                                                        
     end;
     
     begin
               
               insert into wfattsvalues
                 (WFINSPRCID, WFATTSID, WFATTSVAL)
               values
                 (i.n_nroist, 'MODEVAL', i.n_tipeva);
     Ln_cuenta := Ln_cuenta + 1;      
     if mod(Ln_cuenta,10000) = 0 then
        commit;
        Ln_cuenta := 0;
     end if;                                             
                                       
     exception
     when others then
      lc_error := sqlerrm;            
      --select sq_cr_eval.currval into ln_nro from dual;      
        insert into LOG_ERROR_BANDEJA
          (n_nro, c_codbdj, c_deserr, d_fecerr)
        values
          (LN_CORREL/*ln_nro*/, 'swfatt', i.n_nroist || ' : ' || lc_error, sysdate);
        commit;
     end;     
     
     /* se agrego para que se muestre */
     begin
               
               insert into wfwrkitems 
                 (--wfitemid     ,
                  wfinsprcid   ,
                  wfitemusrcod ,
                  wfitemrolcod ,
                  wftaskcod    ,
                  wfiteminit   ,
                  wfitemend    ,
                  wfstscod     ,
                  wfitemstsact ,
                  wfitemwrn    ,
                  wfitemdln    ,
                  wfitemwrntime,
                  wfitemdlntime,
                  wfitemprcurn ,
                  wfitemprvsta ,
                  wfitemprvtask,
                  wfitempty    ,
                  wfprcid      
                 )
               values
                 (--WFITEMID.nextval, 
                 i.n_nroist, 
                 i.c_usuario,
                 -1, 
                 7,
                 i.d_feceva,
                 i.d_feceva,
                 'C',
                 0,
                 'N',
                 'N',
                 i.d_feceva,
                 i.d_feceva,
                 0,
                 'P',
                 3,
                 2,
                 1
                 );
     Ln_cuenta := Ln_cuenta + 1;      
     if mod(Ln_cuenta,10000) = 0 then
        commit;
        Ln_cuenta := 0;
     end if;                                             
                                       
     exception
     when others then
      lc_error := sqlerrm;            
      --select sq_cr_eval.currval into ln_nro from dual;      
        insert into LOG_ERROR_BANDEJA
          (n_nro, c_codbdj, c_deserr, d_fecerr)
        values
          (LN_CORREL/*ln_nro*/, 'wfwrkitems', i.n_nroist || ' : ' || lc_error, sysdate);
        commit;
     end;       
     /*--------------- fin-----------------------------*/
     
     begin      
       ln_cadena := length(i.c_cadena);
       ln_cont := 0;
       ln_ini := 1;
       ln_pos := 1;

             while ln_ini <= ln_cadena loop --96       
             ln_cdat := null;       
             ln_ctd  := null;
             ln_monto:=0;
             begin
               select instr(i.c_cadena,'*#*',ln_ini,1)
                 into ln_ini
                 from dual; 
             exception
             when others then
                  null;    
             end;  
                         
             lc_valor := substr(i.c_cadena,ln_pos,(ln_ini-ln_pos)); 
             if lc_valor is null then
                lc_valor := 0;
             end if;
             ln_ini   := ln_ini + 3;
             ln_pos   := ln_ini;
             
             ln_cont  := ln_cont + 1;  -- cont mi indica en q campo de la cadena estoy
             
             begin
                   select 1
                     into ln_indcam
                    from bandejas.tmp_map_evaluaciones x   
                    where x.n_orden = ln_cont
                      and x.n_tipeva = i.c_codeva
                      and rownum = 1;
             exception
             when others then
               ln_indcam := 0;   
             end;
                    
               begin
                  select a.sng026cod                       
                    into ln_cdat
                    from bandejas.tmp_map_evaluaciones  a                    
                   where a.n_orden = ln_cont
                     and a.n_tipeva = i.c_codeva;
               exception
               when others then
                lc_error := sqlerrm;            
                  insert into LOG_ERROR_BANDEJA
                    (n_nro,c_codbdj,c_deserr,d_fecerr)
                  values
                    (LN_CORREL/*ln_nro*/,'tmp_eval',i.n_nroist || ' : ' || lc_error,sysdate);
                  commit;               
               end;             

                --
                -- MAPEAMOS EL CAMPO QUE VAMOS A INSERTAR
                --  
             if lc_valor is not null and ln_indcam = 1 then
                ln_indcam := 0;                         
                ln_monto  := to_number(trim(REPLACE(lc_valor,',','.')),'9999999999.99');                                                
                
                if ln_cdat = '66' and ln_monto = 0 then --soles
                ln_monto  := to_number(trim(REPLACE(i.TOTAL_ACTIVO_S,',','.')),'9999999999.99') - 
                             to_number(trim(REPLACE(i.TOTAL_PASIVO_S,',','.')),'9999999999.99');    
                elsif ln_cdat = '566' and ln_monto = 0 then --dolares
                ln_monto  := to_number(trim(REPLACE(i.TOTAL_ACTIVO_D,',','.')),'9999999999.99') - 
                             to_number(trim(REPLACE(i.TOTAL_PASIVO_D,',','.')),'9999999999.99');    
                end if;                
              if ln_cdat not in ('26','526') then 
                begin
                
                  insert into sng023
                    (SNG021EVAL, SNG026COD, SNG023MTO)
                  values
                    (LN_CORREL/*ln_nro*/, ln_cdat, ln_monto);
                    
                     Ln_cuenta := Ln_cuenta + 1;      
                     if mod(Ln_cuenta,10000) = 0 then
                        commit;
                        Ln_cuenta := 0;
                     end if;                                                   
                exception
                when others then
                lc_error := sqlerrm;                      
                        insert into LOG_ERROR_BANDEJA
                          (n_nro,c_codbdj,c_deserr,d_fecerr)
                        values
                          (LN_CORREL/*ln_nro*/,'sng023',i.n_nroist||'-'||ln_cdat || ' : ' || lc_error,sysdate);
                        commit;                                            
                end; 
              else
              
                begin
                
                  insert into sng028
                    (SNG021EVAL,
                     SNG026COD,
                     SNG028LIN,
                     SNG028MTO2,
                     SNG028CON1,
                     SNG028CON3)
                  values
                    (LN_CORREL/*ln_nro*/,
                     '36',
                     case when ln_cdat = '26' then 1 else 2 end,
                     ln_monto,
                     'Mensual',
                     case when ln_cdat = '26' then 'Soles' else 'Dolares' end);
                     
                     
               Ln_cuenta := Ln_cuenta + 1;      
               if mod(Ln_cuenta,10000) = 0 then
                  commit;
                  Ln_cuenta := 0;
               end if;                                                   
               exception
               when others then
                lc_error := sqlerrm;                      
                  insert into LOG_ERROR_BANDEJA
                    (n_nro,c_codbdj,c_deserr,d_fecerr)
                  values
                    (LN_CORREL/*ln_nro*/,'sng028',i.n_nroist||'-'||ln_cdat || ' : ' || lc_error,sysdate);
                  commit;                                            
               end;              
              end if;
            end if;                                                  
       end loop;     
     exception
     when others then
     lc_error := sqlerrm;                      
      insert into LOG_ERROR_BANDEJA
        (n_nro, c_codbdj, c_deserr, d_fecerr)
      values
        (LN_CORREL/*ln_nro*/, 'sng023', i.n_nroist || ' : ' || lc_error, sysdate);
      commit;    
     end;
  end loop;
  commit;
  update tab_jobs g
     set g.d_fecfin = sysdate
   where g.n_numer1 =  p_n_ini;
  commit;
  
  exception
  when others then
  lc_msgerr := sqlerrm;
      update tab_jobs g
       set g.c_inderr = 'S',
           g.c_deserr = lc_msgerr
     where g.n_numer1 = p_n_ini;
  commit;
  return;  
  end sp_migra_evaluaciones;  
  
  Procedure sp_cr_sng001 is 
  begin
    insert into sng001
      (SNG001INST,
       SNG001EMP,
       SNG001CTA,
       SNG001PAIS,
       SNG001TDOC,
       SNG001NDOC,
       SNG001ORI,
       SNG001SEG,
       SNG001AGE,
       SNG001ASE,
       SNG001USI,
       SNG001FIN,
       SNG015COD,
       SNG001USC,
       SNG001EMC,
       SNG014COD,
       SNG01ICUOT,
       SNG001EJEC,
       SNG001NGRP,
       SNG001EVer)
      select SNG001INST,
             SNG001EMP,
             SNG001CTA,
             SNG001PAIS,
             SNG001TDOC,
             SNG001NDOC,
             SNG001ORI,
             b.ctsegm,--SNG001SEG,
             SNG001AGE,
             SNG001ASE,
             SNG001USI,
             SNG001FIN,
             SNG015COD,
             SNG001USC,
             SNG001EMC,
             SNG014COD,
             SNG01ICUOT,
             SNG001EJEC,
             SNG001NGRP,
             SNG001EVer
        from bandejas.sng001_tmp a,
             fsd008     b
       where a.sng001emp = b.pgcod
         and a.sng001cta = b.ctnro;
        commit;
  exception
  when others then
    null;    
  End sp_cr_sng001;
  
  Procedure sp_cr_sng003 is 
  begin
      insert into sng003
      (SNG001INST,
       SNG003PGC,
       SNG003CTA,
       SNG003COR,
       SNG003TPO
      )
      select SNG001INST,
             SNG003PGC,
             SNG003CTA,
             SNG003COR,
             SNG003TPO
        from bandejas.sng003_tmp;
        commit;        
  exception
  when others then
    null;   
  End sp_cr_sng003;
  Procedure sp_cr_xwf700 is 
  begin
      insert into xwf700
      (XWFEMPRESA,
       XWFSUCURSAL,
       XWFMODULO,
       XWFMONEDA,
       XWFPAPEL,
       XWFCUENTA,
       XWFOPERACION,
       XWFSUBOPE,
       XWFTIPOPE,
       XWFPRCINS,
       XWFMONTO1,
       XWFMONTO2,
       XWFPLAZO1,
       XWFPLAZO2,
       XWFCAR1,
       XWFCAR2,
       XWFFEC1,
       XWFEMP1,
       XWFCTA1,
       XWFCAR3    
      )
      select XWFEMPRESA,
             XWFSUCURSAL,
             XWFMODULO,
             XWFMONEDA,
             XWFPAPEL,
             XWFCUENTA,
             XWFOPERACION,
             XWFSUBOPE,
             XWFTIPOPE,
             XWFPRCINS,
             XWFMONTO1,
             XWFMONTO2,
             XWFPLAZO1,
             XWFPLAZO2,
             XWFCAR1,
             XWFCAR2,
             XWFFEC1,
             XWFEMP1,
             XWFCTA1,
             XWFCAR3    
        from bandejas.xwf700_tmp;
        commit;        
  exception
  when others then
    null;  
  End sp_cr_xwf700;
  Procedure sp_cr_x054021 is 
  begin
  insert into x054021
      (PGCOD,     
       XLLOAOMOD ,
       XLLOAOSUC, 
       XLLOAOMDA,  
       XLLOAOPAP,
       XLLOAOCTA, 
       XLLOAOOPER,
       XLLOAOSBOP,
       XLLOAOTOPE,
       XLLOUSTS,
       XLLOTXTCOD,
       XLLOTXTLIN,
       XLLOTEXTO, 
       XLLOTXTFCH, 
       XLLOTXTUSU,
       XLLOTXTWS
      )
      select PGCOD,     
             XLLOAOMOD, 
             XLLOAOSUC, 
             XLLOAOMDA,  
             XLLOAOPAP,
             XLLOAOCTA,
             XLLOAOOPER,
             XLLOAOSBOP,
             XLLOAOTOPE, 
             XLLOUSTS,
             XLLOTXTCOD,
             XLLOTXTLIN,
             XLLOTEXTO, 
             XLLOTXTFCH, 
             XLLOTXTUSU,
             XLLOTXTWS
        from bandejas.x054021_tmp;
        commit;        
  exception
  when others then
    null;  
  End sp_cr_x054021;
  Procedure sp_cr_x054023 is 
  begin
  insert into x054023
      (XLLPGCOD ,
       XLLAOMOD ,
       XLLAOSUC ,
       XLLAOMDA ,
       XLLAOPAP,
       XLLAOCTA ,
       XLLAOOPER ,
       XLLAOSBOP ,
       XLLAOTOP ,
       XLLFVALOR,
       XLLCAPITAL ,
       XLLFPRIMPA ,
       XLLCANTCUO ,
       XLLPERIODO ,
       XLLTIPOPRE ,
       XLLTIPODIA ,
       XLLTIPOTAS, 
       XLLTASAP ,
       XLLGRADPER ,
       XLLGRADPOR,
       xlltipoano 
      )
      select XLLPGCOD ,
             XLLAOMOD ,
             XLLAOSUC ,
             XLLAOMDA ,
             XLLAOPAP,
             XLLAOCTA ,
             XLLAOOPER ,
             XLLAOSBOP ,
             XLLAOTOP ,
             XLLFVALOR,
             XLLCAPITAL ,
             XLLFPRIMPA ,
             XLLCANTCUO ,
             XLLPERIODO ,
             XLLTIPOPRE ,
             XLLTIPODIA ,
             XLLTIPOTAS, 
             XLLTASAP ,
             XLLGRADPER ,
             XLLGRADPOR,
             xlltipoano 
        from bandejas.x054023_tmp;
        commit;        
  exception
  when others then
    null;
  End sp_cr_x054023;
  /*
  Procedure sp_cr_sng410 is 
  begin
     insert into sng410
          (SNG410CORR,
           SNG400COD,
           SNG410MOD,
           SNG410SUC,
           SNG410MDA,
           SNG410PAP,
           SNG410CTA,
           SNG410OP,
           SNG410SBOP,
           SNG410TOP,
           SNG400EVTO,
           SNG410INST,
           SNG410ASE,
           SNG410FECG
          )
          select SNG410CORR,
                 SNG400COD,
                 SNG410MOD,
                 SNG410SUC,
                 SNG410MDA,
                 SNG410PAP,
                 SNG410CTA,
                 SNG410OP,
                 SNG410SBOP,
                 SNG410TOP,
                 SNG400EVTO,
                 SNG410INST,
                 SNG410ASE,
                 SNG410FECG
            from sng410_tmp;
  exception
  when others then
    null;
  End sp_cr_sng410;
  */
  /*
  Procedure sp_cr_sng122 is 
  begin
     insert into sng122
          (SNG122INST,
           SNG122CORR,
           SNG122PGC,
           SNG122MOD,
           SNG122SUC,
           SNG122MDA,
           SNG122PAP,
           SNG122CTA,
           SNG122OPER,
           SNG122SBOP,
           SNG122TOPE,
           SNG122PRI,
           SNG122TIPO,
           SNG122SDOG,
           SNG122MTOU,
           SNG122FAPE,
           SNG122MTOD,
           SNG122POCO,
           SNG122TCBI,
           SNG122AUXC        
          )
          select SNG122INST,
                 SNG122CORR,
                 SNG122PGC,
                 SNG122MOD,
                 SNG122SUC,
                 SNG122MDA,
                 SNG122PAP,
                 SNG122CTA,
                 SNG122OPER,
                 SNG122SBOP,
                 SNG122TOPE,
                 SNG122PRI,
                 SNG122TIPO,
                 SNG122SDOG,
                 SNG122MTOU,
                 SNG122FAPE,
                 SNG122MTOD,
                 SNG122POCO,
                 SNG122TCBI,
                 SNG122AUXC        
            from sng122_tmp;
  exception
  when others then
    null;
  End sp_cr_sng122; 
  */ 
  Procedure sp_cr_snge03 is 
  begin
     insert into snge03
          (SNGE03INST,
           SNGE03TALL,
           SNGE03NIVR,
           SNGE03CUOI,
           SNGE03MtoI,
           SNGE03GReg,
           SNGE03SOAT,
           SNGE03STAT
          )
          select SNGE03INST,
                 SNGE03TALL,
                 SNGE03NIVR,
                 SNGE03CUOI,
                 SNGE03MtoI,
                 SNGE03GReg,
                 SNGE03SOAT,
                 SNGE03STAT  
            from bandejas.snge03_tmp;
  End sp_cr_snge03;

  Procedure sp_genera_valor(P_N_VALOR OUT NUMBER) IS
  LN_CORREL number(10);  
  BEGIN
    begin
     select SNG059NUM
       INTO LN_CORREL
       from sng059
      where SNG059COD = 10
        for update of SNG059NUM;
      exception
        when no_data_found then
          LN_CORREL := 0;
      end;

      -- Actualización.
      LN_CORREL := LN_CORREL + 1;
     UPDATE sng059 
        SET SNG059NUM = LN_CORREL 
      WHERE SNG059COD = 10;

      -- Grabación.
      commit;    
  P_N_VALOR := LN_CORREL;    
  END;
end PQ_MIGRA_MICRO_CRED_ACT_CDK;
/
