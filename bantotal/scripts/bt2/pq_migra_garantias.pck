CREATE OR REPLACE PACKAGE pq_migra_garantias IS
  --                               :lllosa  2012.04.20 se agrego procesa datos garantias
  --                               :lllosa  2012.05.30 se cambio forma de realizar commit
  --                               :ylozada 2012.05.30 se cambio cantidad de datos para commit
  --                               :lllosa  2012.05.31 se agrega codigo para proceso de jobs

  procedure sp_jobs_procesa_datos /*(p_c_error out varchar2)*/;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_datos_adicionales_BNJ200(P_N_DIGITO1 IN number,
                                        P_N_DIGITO2 IN number,
                                        P_N_DIGITO3 IN number,                                        
                                        ln_nro      in number,  
                                        ln_nro1     in number,
                                        ln_nro2     in number,   
                                        ln_nro3     in number,
                                        ln_nro4     in number,   
                                        ln_nro6     in number,
                                        ln_nro7     in number,   
                                        ln_nro8     in number,                                                                                                                                                                    
                                        ln_init     in number
                                        );
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_jobs_datos_garantias /*(p_c_error out varchar2)*/;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
end pq_migra_garantias;
/

CREATE OR REPLACE PACKAGE BODY pq_migra_garantias  IS

  /***************************************************************/
  /**************************************************************/
  
  procedure sp_jobs_procesa_datos /*(p_c_error out varchar2)*/ is
  
  --CURSOR c_job IS            
    /*select \*+PARALLEL(T,2,1)*\
           min(to_number(t.c_numcta)) n_numini, 
           max(to_number(t.c_numcta)) n_numfin,
           \*min(t.n_ctabtt) n_numini, 
           max(t.n_ctabtt) n_numfin,*\
           t.n_sucurs
      from btctaprd t
     where c_indpro in ('G','V') 
  group by n_sucurs ;    */     
  
    
    
  --ld_fecini DATE;
  ln_max      number;
  ln_ini      number:=0;  
  lc_variable varchar2(4000);
  ln_job      number:= 0;   
  i           number; 
  ln_inc      number;
  ln_fin      number;
  NUM_JOB_PENDIENTES NUMBER;
  BEGIN
  
    execute immediate ('truncate table migra2.tdinvgar');
    --execute immediate ('truncate table LOG_ERROR_BANDEJA');
    
    select max(n_ctabtt), 
           trunc(max(n_ctabtt)/100) 
      into ln_max, ln_inc
      from btctaprd t
      where c_indpro in ('G','V');
      
    i:=0;
    INSERT INTO Tab_jobs (c_codage,n_Numer1,c_detjob)
      VALUES('GPD',ln_max,TO_CHAR(ln_inc));
      COMMIT;
    while i <= ln_max loop
      ln_ini := i+1;
      i:= i+ ln_inc;
      ln_fin := i;
      lc_variable := ' begin '||'  pq_migra_garantias.sp_procesa_datos('||ln_ini||','||ln_fin||','||ln_ini||');'|| ' End; ';           
      ln_job := ln_job +1;
      --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
      -- INSERTA TABLA CONTROL
      dbms_scheduler.create_job(
       job_name=> 'DAT_GRTIA_P_'||ln_ini||LPAD(TO_CHAR(ln_job),5,'0'),
       job_type=> 'PLSQL_BLOCK',
       job_action=> lc_variable,
       start_date => sysdate+1/(24*2600),
       enabled => true, 
       auto_drop=> TRUE,
       comments => 'PROCESA DATOS DE GARANTIAS '||ln_ini
       );
       COMMIT;
      INSERT INTO Tab_jobs (c_codage,n_Numer1,c_detjob)
      VALUES('GPD',ln_ini,lc_variable);
      COMMIT;
    end loop;
    
    
    --ld_fecini := sysdate;
    /*for job in c_job loop
         ln_init := ln_init + 1;  
         lc_variable := ' begin '||'  pq_migra_garantias.sp_procesa_datos('||job.n_sucurs||','||job.n_numini||','||job.n_numfin||','||ln_init||');'|| ' End; ';           
         ln_job := ln_job +1;
         DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180),null,false,1,false);
        -- INSERTA TABLA CONTROL

        INSERT INTO Tab_jobs (n_Numer1,c_detjob)
        VALUES(ln_init,lc_variable);
        COMMIT;        
    end loop;*/
  EXCEPTION
  WHEN OTHERS THEN
      lc_variable:=  sqlerrm;
      INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
      VALUES (0,'BATCH_DAT_GAR',lc_variable, TRUNC(SYSDATE));
      COMMIT;
  end sp_jobs_procesa_datos ;

  /***************************************************************/
  /**************************************************************/    
  procedure sp_datos_adicionales_BNJ200(P_N_DIGITO1 IN number,
                                        P_N_DIGITO2 IN number,
                                        P_N_DIGITO3 IN number,                                        
                                        ln_nro      in number,   
                                        ln_nro1     in number,
                                        ln_nro2     in number,   
                                        ln_nro3     in number,
                                        ln_nro4     in number,   
                                        ln_nro6     in number,
                                        ln_nro7     in number,   
                                        ln_nro8     in number,                                                    
                                        ln_init     in number
                                        ) is
                                        
   -- 2016.02.08 DCASTRO Se modifico formato de valores numericos para insertar correctamente valor.
                                        
  cursor c_garantias is
    select /*+PARALLEL(TDINVGAR,2,1)*/
           N_CODRPC||'*#*'||N_ASIINI||'*#*'||N_ASIFIN||'*#*'||N_CODRPD||'*#*'||C_OBSCMA||'*#*'||
           to_char(D_FECTOC,'rrrr.mm.dd')||'*#*'||N_VALASI||'*#*'||C_CODNOT||'*#*'||to_char(D_FECUES,'rrrr.mm.dd')||'*#*'||C_USUDES||'*#*'||
           to_char(D_FOBDES,'rrrr.mm.dd')||'*#*'||C_INDGAC||'*#*'||to_char(D_FECMIN,'rrrr.mm.dd')||'*#*'||C_RUBSAL||'*#*'||/*N_SALDO */ to_char(N_SALDO,'999999999.99' ) ||'*#*'||
           N_CODTSP||'*#*'||N_CODPAT||'*#*'||to_char(D_FECCON,'rrrr.mm.dd')||'*#*'||N_CODMON||'*#*'||/*N_VALCOM*/to_char(N_VALCOM,'999999999.99' )||'*#*'||
           C_OBSERV||'*#*'||C_ANOFAB||'*#*'||C_DESREF||'*#*'||C_DIRCON||'*#*'||C_INDFAB||'*#*'||
           C_INDPRH||'*#*'||C_INDART||'*#*'||C_INDNUE||'*#*'||C_NUMERO||'*#*'||N_ARECOM||'*#*'||
           /*N_ARECON*/to_char(N_ARECON,'999999999.99' )||'*#*'||/*N_AREEXC*/ to_char(N_AREEXC,'999999999.99' )||'*#*'||/*N_ARETEC*/to_char(N_ARETEC,'999999999.99' )||'*#*'||/*N_ARETER*/to_char(N_ARETER,'999999999.99' )||'*#*'||N_CODUBI||'*#*'||
           C_NUMSTA||'*#*'||C_NUMSTA1||'*#*'||N_CODPER||'*#*'||/*N_VALTER*/to_char(N_VALTER,'999999999.99' )||'*#*'||/*N_VALREC*/to_char(N_VALREC,'999999999.99' )||'*#*'||
           N_CODGNE||'*#*'||N_CODTIE||'*#*'||N_NUMPIS||'*#*'||N_NUMSOT||'*#*'||N_CODZON||'*#*'||
           N_CODSED||'*#*'||/*N_VALCON*/to_char(N_VALCON,'999999999.99' )||'*#*'||to_char(D_FECTAS,'rrrr.mm.dd')||'*#*'||to_char(D_FECREM,'rrrr.mm.dd')||'*#*'||to_char(D_FECESC,'rrrr.mm.dd')||'*#*'||
           to_char(D_FECREP,'rrrr.mm.dd')||'*#*'||to_char(D_FECINS,'rrrr.mm.dd')||'*#*'||to_char(D_FECBLO,'rrrr.mm.dd')||'*#*'||to_char(D_FECORP,'rrrr.mm.dd')||'*#*'||to_char(D_FECSUB,'rrrr.mm.dd')||'*#*'||
           to_char(D_FECCLI,'rrrr.mm.dd')||'*#*'||N_CODRRP||'*#*'||N_CODTCO||'*#*'||N_CODTDO||'*#*'||N_CODNOT||'*#*'||
           N_CODMOT||'*#*'||C_NUMASI||'*#*'||C_RAZPER||'*#*'||to_char(D_FECASI,'rrrr.mm.dd')||'*#*'||N_OBSREP||'*#*'||
           C_NUMPAR||'*#*'||C_NUMPOL||'*#*'||to_char(D_FECINP,'rrrr.mm.dd')||'*#*'||to_char(D_FECFIP,'rrrr.mm.dd')||'*#*'||N_CODCIA||'*#*'||
           N_TIPSEG||'*#*'||C_ESTREG||'*#*'||C_DESSIN||'*#*'||to_char(D_FECSIN,'rrrr.mm.dd')||'*#*'||C_DESPAT||'*#*'||
           C_ANOCON||'*#*'||N_CODCLA||'*#*'||N_CODMAR||'*#*'||N_CODMOD||'*#*'||N_CODUSO||'*#*'||
           C_COLOR ||'*#*'||C_MARCA ||'*#*'||C_MODELO||'*#*'||C_NUMCHA||'*#*'||C_NUMCTA||'*#*'||
           C_NUMFAC||'*#*'||C_NUMMOT||'*#*'||C_NUMPLA||'*#*'||C_NUMSER||'*#*'||C_TARPRO||'*#*'||
           N_ANOFAB||'*#*'||N_CODPRO||'*#*'||N_NUMASI||'*#*'||N_TIPVEH||'*#*'||/*N_VALREP*/to_char(N_VALREP,'999999999.99' )||'*#*'||
           C_INDPRE||'*#*'||N_MONEDA||'*#*'                                            C_CADENA,--97
           N_SUCURS,
           N_PAPEL ,
           N_CTABTT,
           N_OPERAC,
           N_SUBOPE,
           N_MODULO,
           N_TOTOPE,
           N_MONEDA,
           N_SALDO
      from TDINVGAR --where n_ctabtt=22625;
     where n_sucurs = P_N_DIGITO1 
       and n_moneda = P_N_DIGITO2 
       and n_totope = P_N_DIGITO3;   
     
      
  ln_cont   number(10):=0;     
  ln_ini    number(10):=1;
  ln_pos    number(10):=1;
  lc_valor  varchar2(400);
  ln_cadena number(10);
  ln_cdat   number(4);
  ln_ctd    number(4);
  ln_clp    number(4);
  ln_indcam number(1):= 0;
  lb_ok     boolean := true;
  lc_error  varchar2(300);
  ln_modulo number;
  lc_indins CHAR(1):= 'N';
  ln_cuenta number:=0;
  ln_cont1 number(10);
  ln_cont2 number(10);
begin   
   
   update tab_jobs g
     set g.d_fecini = sysdate
   where g.n_numer1 =  ln_init
     and g.c_codage = 'GDA';   
   
   for i in c_garantias loop
   ln_cuenta := ln_cuenta + 1; 
       ln_cadena := length(i.c_cadena);
       ln_cont := 0;
       lb_ok := true;
       ln_ini := 1;
       ln_pos := 1;
       lc_indins := 'N';
       ln_cont1 := 0;
       ln_cont2 := 0;
       ln_modulo:=null;
       
       while ln_ini <= ln_cadena loop --96
       
             ln_cdat := null;       
             ln_ctd  := null;
             ln_clp  := null;
             ln_modulo := null;
             
             begin
               select instr(i.c_cadena,'*#*',ln_ini,1)
                 into ln_ini
                 from dual; 
             exception
             when others then
                  null;    
             end;  
                         
             lc_valor := substr(i.c_cadena,ln_pos,(ln_ini-ln_pos)); 
             ln_ini   := ln_ini + 3;
             ln_pos   := ln_ini;
             
             ln_cont  := ln_cont + 1;  -- cont mi indica en q campo de la cadena estoy
             
             begin
                   select 1
                     into ln_indcam
                    from tmp_atributos x   
                    where x.orden = ln_cont
                      and rownum = 1; 
             exception
             when others then
               ln_indcam := 0;   
             end;
             
             if lc_valor is not null and ln_indcam = 1 then
               ln_indcam := 0;               
               begin
                  select a.PPG010CDAT,                       
                         a.PPG014CTD,
                         a.PPG021CLP
                    into ln_cdat,
                         ln_ctd,
                         ln_clp
                    from tmp_atributos  a
                   where a.orden = ln_cont;
               exception
               when too_many_rows then
                    begin
                      select a.PPG010CDAT,                       
                             a.PPG014CTD,
                             a.PPG021CLP
                        into ln_cdat,
                             ln_ctd,
                             ln_clp
                        from tmp_atributos a
                       where a.orden     = ln_cont
                         and a.modulo    = i.n_modulo
                         and a.operacion = i.n_totope;  
                    exception
                    when too_many_rows then
                        lc_error := sqlerrm||'-'||'CAMPO NO MAPEADO';
                        --insertar a una tabla generica de excepciones (dato y la bandeja)
                        insert into LOG_ERROR_BANDEJA
                          (n_nro,c_codbdj,c_deserr,d_fecerr)
                        values
                          (ln_nro,'BNJ200',ln_cont ||'-'||i.N_CTABTT || ' : ' || lc_error,sysdate);
                        commit;   
                        --EXIT;                      
                    when others then  
                        lc_error := sqlerrm;
                        --insertar a una tabla generica de excepciones (dato y la bandeja)
                        insert into LOG_ERROR_BANDEJA
                          (n_nro,c_codbdj,c_deserr,d_fecerr)
                        values
                          (ln_nro,'BNJ200',ln_cont ||'-'||i.N_CTABTT || ' : ' || lc_error,sysdate);
                        commit;                                           
                        --EXIT;
                    end;
               when no_data_found then     
                  lc_error := sqlerrm||'-'||'CAMPO NO ENCONTRADO EN MAPEO';
                  --insertar a una tabla generica de excepciones (dato y la bandeja)
                  insert into LOG_ERROR_BANDEJA
                    (n_nro,c_codbdj,c_deserr,d_fecerr)
                  values
                    (ln_nro,'BNJ200',ln_cont ||'-'||i.N_CTABTT || ' : ' || lc_error,sysdate);
                  commit;    
                  --EXIT;                  
               end;
               --
               -- DETERMINAMOS EL MODULO CORRECTO
               --
               BEGIN
               
                select distinct 
                       d.modulo
                  into ln_modulo
                  from ppg011 a,
                       ppg010 b,
                       ppg014 c,
                       fst004 d
                 where a.ppg011cdat = b.ppg010cdat 
                   and b.ppg010tdat = c.ppg014ctd
                   and a.ppg011mod  = d.modulo
                   and a.ppg011top  = d.totope
                   and ppg011mod    = i.n_modulo
                   and ppg011top    = i.n_totope
                   and ppg010cdat   = ln_cdat
                   and ppg011mda    = i.n_moneda
                   and c.ppg014ctd  = ln_ctd;     
                   
                   if ln_modulo = 70 then                   
                      ln_cont1:= ln_cont1 + 1;
                   elsif ln_modulo = 470 then
                      ln_cont2:= ln_cont2 + 1;
                   end if;
                              
               
               EXCEPTION               
               WHEN too_many_rows THEN
                  lc_error := 'ERROR EXISTE MAS DE UN MODULO PARA UN ATRIBUTO';
                  insert into LOG_ERROR_BANDEJA
                    (n_nro,c_codbdj,c_deserr,d_fecerr)
                  values
                    (ln_nro1,'BNJ200',ln_cont ||'-'||i.N_CTABTT || ' : ' || lc_error,sysdate);
                  commit;                 
               WHEN no_data_found THEN
                 BEGIN                 
                     select distinct 
                           d.modulo
                      into ln_modulo
                      from ppg011 a,
                           ppg010 b,
                           ppg014 c,
                           fst004 d
                     where a.ppg011cdat = b.ppg010cdat 
                       and b.ppg010tdat = c.ppg014ctd
                       and a.ppg011mod  = d.modulo
                       and a.ppg011top  = d.totope
                       and ppg011mod    = 470
                       and ppg011top    = i.n_totope
                       and ppg010cdat   = ln_cdat
                       and ppg011mda    = i.n_moneda
                       and c.ppg014ctd  = ln_ctd;     
                       
                       if ln_modulo = 70 then                   
                          ln_cont1:= ln_cont1 + 1;
                       elsif ln_modulo = 470 then
                          ln_cont2:= ln_cont2 + 1;
                       end if;                                  
                 
                 EXCEPTION
                 WHEN OTHERS THEN
                    ln_modulo := null;
                 END;
               WHEN OTHERS THEN
                  lc_error := sqlerrm;
                  insert into LOG_ERROR_BANDEJA
                    (n_nro,c_codbdj,c_deserr,d_fecerr)
                  values
                    (ln_nro1,'BNJ200',ln_cont ||'-'||i.N_CTABTT || ' : ' || lc_error,sysdate);
                  commit;  
               END;
               -- FIN
               
               if ln_modulo = 70 and ln_cont1 = 1 then                  
                  ln_cont1:= ln_cont1 + 1;                
                  
                 begin
                    insert into BANDEJAS.bnj200(BNJ200PGC,
                                       BNJ200MOD,
                                       BNJ200SUC,
                                       BNJ200MDA,
                                       BNJ200PAP,
                                       BNJ200CTA,
                                       BNJ200OPE,
                                       BNJ200SBO,
                                       BNJ200TOP,
                                       BNJ200COR,
                                       BNJ200FRM,
                                       BNJ200TCO,
                                       BNJ200AU3
                                      )
                               values(1,
                                      ln_modulo,--i.N_MODULO,--ln_modulo,
                                      i.N_SUCURS,
                                      i.N_MONEDA,
                                      i.N_PAPEL,
                                      i.N_CTABTT,
                                      i.N_OPERAC,
                                      i.N_SUBOPE,
                                      i.N_TOTOPE,
                                      0,
                                      0,
                                      'P',
                                      i.n_saldo
                                      );                     
                  exception
                  when others then
                    lc_error := sqlerrm;
                    --insertar a una tabla generica de excepciones (dato y la bandeja)
                    insert into LOG_ERROR_BANDEJA
                      (n_nro,c_codbdj,c_deserr,d_fecerr)
                    values
                      (ln_nro,'BNJ200',i.N_CTABTT || ' : ' || lc_error,sysdate);
                    commit;                  
                  end;   
                end if;  
                
                
                if  ln_modulo = 470 and ln_cont2 = 1 then
                    ln_cont2:= ln_cont2 + 1;                
                 begin
                    insert into BANDEJAS.bnj200(BNJ200PGC,
                                       BNJ200MOD,
                                       BNJ200SUC,
                                       BNJ200MDA,
                                       BNJ200PAP,
                                       BNJ200CTA,
                                       BNJ200OPE,
                                       BNJ200SBO,
                                       BNJ200TOP,
                                       BNJ200COR,
                                       BNJ200FRM,
                                       BNJ200TCO,
                                       BNJ200AU3
                                      )
                               values(1,
                                      ln_modulo,
                                      i.N_SUCURS,
                                      i.N_MONEDA,
                                      i.N_PAPEL,
                                      i.N_CTABTT,
                                      i.N_OPERAC,
                                      i.N_SUBOPE,
                                      i.N_TOTOPE,
                                      0,
                                      0,
                                      'P',
                                      i.n_saldo
                                      );                     
                  exception
                  when others then
                    lc_error := sqlerrm;
                    --insertar a una tabla generica de excepciones (dato y la bandeja)
                    insert into LOG_ERROR_BANDEJA
                      (n_nro,c_codbdj,c_deserr,d_fecerr)
                    values
                      (ln_nro,'BNJ200',i.N_CTABTT || ' : ' || lc_error,sysdate);
                    commit;                  
                  end;   
               end if;                
                
                
                --
                -- MAPEAMOS LA BANDEJA DONDE SE VA A INSERTAR
                --                         
                case
                when ln_cont in (23,24,36,62,63,66,67,81,82,83,84,86,87,88,89,90) and ln_modulo is not null then-- TEXTO
                  begin
                    insert into BANDEJAS.bnj201(BNJ201COD, 
                                       BNJ201MOD,
                                       BNJ201SUC, 
                                       BNJ201MDA, 
                                       BNJ201PAP, 
                                       BNJ201CTA, 
                                       BNJ201OPE, 
                                       BNJ201SBO, 
                                       BNJ201TOP, 
                                       BNJ201COR, 
                                       BNJ201FRM, 
                                       BNJ201CDAT,
                                       BNJ201DATO
                                      )
                               values(1,
                                      ln_modulo,
                                      i.N_SUCURS,
                                      i.N_MONEDA,
                                      i.N_PAPEL,
                                      i.N_CTABTT,
                                      i.N_OPERAC,
                                      i.N_SUBOPE,
                                      i.N_TOTOPE,
                                      0,
                                      0,
                                      ln_cdat,--ATRIBUTO DE TABLA DE MAPEOS
                                      substr(lc_valor,1,50) -- ES CADENA CONVERTIR DEPENDIENDO DE LA BANDEJA EN LA QUE CAIGA
                                      );                     
                  exception
                  when others then
                    lc_error := sqlerrm;
                    --insertar a una tabla generica de excepciones (dato y la bandeja)
                    insert into LOG_ERROR_BANDEJA
                      (n_nro,c_codbdj,c_deserr,d_fecerr)
                    values
                      (ln_nro1,'BNJ201',ln_cont ||'-'||i.N_CTABTT || ' : ' || lc_error,sysdate);
                    commit;                  
                  end;
                when ln_cont in (48,49,50,51,52,53,54,55,56,64,68,69,74) and ln_modulo is not null then -- FECHA
                  begin
                    insert into BANDEJAS.bnj202(BNJ202COD, 
                                       BNJ202MOD,
                                       BNJ202SUC, 
                                       BNJ202MDA, 
                                       BNJ202PAP, 
                                       BNJ202CTA, 
                                       BNJ202OPE, 
                                       BNJ202SBO, 
                                       BNJ202TOP, 
                                       BNJ202COR, 
                                       BNJ202FRM, 
                                       BNJ202CDAT,
                                       BNJ202DATO
                                      )
                               values(1,
                                      ln_modulo,
                                      i.N_SUCURS,
                                      i.N_MONEDA,
                                      i.N_PAPEL,
                                      i.N_CTABTT,
                                      i.N_OPERAC,
                                      i.N_SUBOPE,
                                      i.N_TOTOPE,
                                      0,
                                      0,
                                      ln_cdat,--ATRIBUTO DE TABLA DE MAPEOS
                                      to_date(trim(lc_valor),'rrrr.mm.dd') -- ES CADENA CONVERTIR DEPENDIENDO DE LA BANDEJA EN LA QUE CAIGA
                                      );                     
                  exception
                  when others then
                    lc_error := sqlerrm;
                    --insertar a una tabla generica de excepciones (dato y la bandeja)
                    insert into LOG_ERROR_BANDEJA
                      (n_nro,c_codbdj,c_deserr,d_fecerr)
                    values
                      (ln_nro2,'BNJ202',ln_cont ||'-'||i.N_CTABTT || ' : ' || lc_error,sysdate);
                    commit;                  
                  end;                
                when ln_cont in (22,43,44,76,78,79,93) and ln_modulo is not null then -- NUMERICO
                  begin
                    insert into BANDEJAS.bnj203(BNJ203COD, 
                                       BNJ203MOD,
                                       BNJ203SUC, 
                                       BNJ203MDA, 
                                       BNJ203PAP, 
                                       BNJ203CTA, 
                                       BNJ203OPE, 
                                       BNJ203SBO, 
                                       BNJ203TOP, 
                                       BNJ203COR, 
                                       BNJ203FRM, 
                                       BNJ203CDAT,
                                       BNJ203DATO
                                      )
                               values(1,
                                      ln_modulo,
                                      i.N_SUCURS,
                                      i.N_MONEDA,
                                      i.N_PAPEL,
                                      i.N_CTABTT,
                                      i.N_OPERAC,
                                      i.N_SUBOPE,
                                      i.N_TOTOPE,
                                      0,
                                      0,
                                      ln_cdat,--ATRIBUTO DE TABLA DE MAPEOS
                                      to_number(trim(lc_valor)) -- ES CADENA CONVERTIR DEPENDIENDO DE LA BANDEJA EN LA QUE CAIGA
                                      );                     
                  exception
                  when others then
                    lc_error := sqlerrm;
                    --insertar a una tabla generica de excepciones (dato y la bandeja)
                    insert into LOG_ERROR_BANDEJA
                      (n_nro,c_codbdj,c_deserr,d_fecerr)
                    values
                      (ln_nro3,'BNJ203',ln_cont ||'-'||i.N_CTABTT || ' : ' || lc_error,sysdate);
                    commit;                  
                  end;  
                when ln_cont in (20,30,31,32,33,34,39,40,47,95) and ln_modulo is not null  then -- TIPO IMPORTE
                  begin
                    insert into BANDEJAS.bnj204(BNJ204COD, 
                                       BNJ204MOD,
                                       BNJ204SUC, 
                                       BNJ204MDA, 
                                       BNJ204PAP, 
                                       BNJ204CTA, 
                                       BNJ204OPE, 
                                       BNJ204SBO, 
                                       BNJ204TOP, 
                                       BNJ204COR, 
                                       BNJ204FRM, 
                                       BNJ204CDAT,
                                       BNJ204DATO
                                      )
                               values(1,
                                      ln_modulo,
                                      i.N_SUCURS,
                                      i.N_MONEDA,
                                      i.N_PAPEL,
                                      i.N_CTABTT,
                                      i.N_OPERAC,
                                      i.N_SUBOPE,
                                      i.N_TOTOPE,
                                      0,
                                      0,
                                      ln_cdat,--ATRIBUTO DE TABLA DE MAPEOS
                                      to_number(trim(lc_valor),'999999999.99') -- ES CADENA CONVERTIR DEPENDIENDO DE LA BANDEJA EN LA QUE CAIGA
                                      );                     
                  exception
                  when others then
                    lc_error := sqlerrm;
                    --insertar a una tabla generica de excepciones (dato y la bandeja)
                    insert into LOG_ERROR_BANDEJA
                      (n_nro,c_codbdj,c_deserr,d_fecerr)
                    values
                      (ln_nro4,'BNJ204',ln_cont ||'-'||i.N_CTABTT || ' : ' || lc_error,sysdate);
                    commit;                  
                  end; 
                when ln_cont in (21,73,75) and ln_modulo is not null  then -- TIPO COMENTARIO
                  begin
                    insert into BANDEJAS.bnj206(BNJ206COD, 
                                       BNJ206MOD,
                                       BNJ206SUC, 
                                       BNJ206MDA, 
                                       BNJ206PAP, 
                                       BNJ206CTA, 
                                       BNJ206OPE, 
                                       BNJ206SBO, 
                                       BNJ206TOP, 
                                       BNJ206COR, 
                                       BNJ206FRM, 
                                       BNJ206CDAT,
                                       BNJ206DATO
                                      )
                               values(1,
                                      ln_modulo,
                                      i.N_SUCURS,
                                      i.N_MONEDA,
                                      i.N_PAPEL,
                                      i.N_CTABTT,
                                      i.N_OPERAC,
                                      i.N_SUBOPE,
                                      i.N_TOTOPE,
                                      0,
                                      0,
                                      ln_cdat,--ATRIBUTO DE TABLA DE MAPEOS
                                      substr(trim(lc_valor),1,500) -- ES CADENA CONVERTIR DEPENDIENDO DE LA BANDEJA EN LA QUE CAIGA
                                      );                     
                  exception
                  when others then
                    lc_error := sqlerrm;
                    --insertar a una tabla generica de excepciones (dato y la bandeja)
                    insert into LOG_ERROR_BANDEJA
                      (n_nro,c_codbdj,c_deserr,d_fecerr)
                    values
                      (ln_nro6,'BNJ206',ln_cont ||'-'||i.N_CTABTT || ' : ' || lc_error,sysdate);
                    commit;                  
                  end; 
                when ln_cont in (12,25,26,27,28,72,96) and ln_modulo is not null  then -- TIPO BOOLEANO
                  begin
                    insert into BANDEJAS.bnj207(BNJ207COD, 
                                       BNJ207MOD,
                                       BNJ207SUC, 
                                       BNJ207MDA, 
                                       BNJ207PAP, 
                                       BNJ207CTA, 
                                       BNJ207OPE, 
                                       BNJ207SBO, 
                                       BNJ207TOP, 
                                       BNJ207COR, 
                                       BNJ207FRM, 
                                       BNJ207CDAT,
                                       BNJ207DATO
                                      )
                               values(1,
                                      ln_modulo,
                                      i.N_SUCURS,
                                      i.N_MONEDA,
                                      i.N_PAPEL,
                                      i.N_CTABTT,
                                      i.N_OPERAC,
                                      i.N_SUBOPE,
                                      i.N_TOTOPE,
                                      0,
                                      0,
                                      ln_cdat,--ATRIBUTO DE TABLA DE MAPEOS
                                      case                -- ES CADENA CONVERTIR DEPENDIENDO DE LA BANDEJA EN LA QUE CAIGA
                                      when trim(lc_valor) = 'S' then
                                        'S'--1
                                      when trim(lc_valor) = 'N' then
                                        'N'--0
                                      when trim(lc_valor) = '1' then  
                                        'S'--1
                                      when trim(lc_valor) = '0' then
                                        'N'--0
                                      else
                                        null
                                      end
                                      );                     
                  exception
                  when others then
                    lc_error := sqlerrm;
                    --insertar a una tabla generica de excepciones (dato y la bandeja)
                    insert into LOG_ERROR_BANDEJA
                      (n_nro,c_codbdj,c_deserr,d_fecerr)
                    values
                      (ln_nro7,'BNJ207',ln_cont ||'-'||i.N_CTABTT || ' : ' || lc_error,sysdate);
                    commit;                  
                  end;
                when ln_cont in (16,35,38,41,42,45,46,57,58,59,61,65,70,71,75,77,80,92,94) and ln_modulo is not null  then -- TIPO POP UP
                  begin
                    insert into BANDEJAS.bnj208(BNJ208PGC, 
                                       BNJ208MOD,
                                       BNJ208SUC, 
                                       BNJ208MDA, 
                                       BNJ208PAP, 
                                       BNJ208CTA, 
                                       BNJ208OPE, 
                                       BNJ208SBO, 
                                       BNJ208TOP, 
                                       BNJ208CORR, 
                                       BNJ208FRM, 
                                       BNJ208CDAT,
                                       BNJ208CPU, 
                                       BNJ208CIP 
                                      )
                               values(1,
                                      ln_modulo,
                                      i.N_SUCURS,
                                      i.N_MONEDA,
                                      i.N_PAPEL,
                                      i.N_CTABTT,
                                      i.N_OPERAC,
                                      i.N_SUBOPE,
                                      i.N_TOTOPE,
                                      0,
                                      0,
                                      ln_cdat,--ATRIBUTO DE TABLA DE MAPEOS
                                      ln_clp,
                                      to_number(trim(lc_valor)) -- ES CADENA CONVERTIR DEPENDIENDO DE LA BANDEJA EN LA QUE CAIGA
                                      );                     
                  exception
                  when others then
                    lc_error := sqlerrm;
                    --insertar a una tabla generica de excepciones (dato y la bandeja)
                    insert into LOG_ERROR_BANDEJA
                      (n_nro,c_codbdj,c_deserr,d_fecerr)
                    values
                      (ln_nro8,'BNJ208',ln_cont ||'-'||i.N_CTABTT || ' : ' || lc_error,sysdate);
                    commit;                  
                  end;   
                when ln_cont in (23,24,36,62,63,66,67,81,82,83,84,86,87,88,89,90,48,49,50,51,52,53,54,55,56,64,68,69,74,22,43,44,76,78,79,93,20,30,31,32,33,34,39,40,47,95,21,73,75,12,25,26,27,28,72,96,16,35,38,41,42,45,46,57,58,59,61,65,70,71,75,77,80,92,94) and ln_modulo is null then                                                                        
                    begin
                       insert into LOG_ERROR_BANDEJA
                            (n_nro,c_codbdj,c_deserr,d_fecerr)
                          values
                            (ln_nro4,'BNJ209',i.N_CTABTT||'-'||i.N_OPERAC||'-'||i.N_TOTOPE||'-'||ln_cdat,sysdate);
                          commit;                                                                                 
                    exception
                    when others then
                      null;   
                    end;                   
                else
                  null;
                end case;                                                                                
             end if;             
       end loop;
            
               
        if mod(ln_cuenta,10000) = 0 then
           commit;
        end if;                           
   end loop;
   commit;
    
   update tab_jobs g
     set g.d_fecfin = sysdate
   where g.n_numer1 =  ln_init
     and g.c_codage = 'GDA';
   commit;
  exception
  when others then
      lc_error := sqlerrm;
      update tab_jobs g
       set g.c_inderr = 'S',
           g.c_deserr = lc_error
     where g.n_numer1 = ln_init
       and g.c_codage = 'GDA';
    commit;
    return;   
  end; 
  procedure sp_jobs_datos_garantias/* (p_c_error out varchar2)*/ is
  
  CURSOR c_job IS            
    select /*+PARALLEL(T,2,1)*/
           n_sucurs N_DIGITO1, 
           n_moneda N_DIGITO2, 
           n_totope N_DIGITO3
      from tdinvgar t
  group by n_sucurs, 
           n_moneda, 
           n_totope;             
             
  ld_fecini DATE;
  ln_nro    log_carga_bandeja.n_nro%type;
  ln_nro1   log_carga_bandeja.n_nro%type;
  ln_nro2   log_carga_bandeja.n_nro%type;
  ln_nro3   log_carga_bandeja.n_nro%type;
  ln_nro4   log_carga_bandeja.n_nro%type;
  ln_nro6   log_carga_bandeja.n_nro%type;
  ln_nro7   log_carga_bandeja.n_nro%type;   
  ln_nro8   log_carga_bandeja.n_nro%type;           
  ln_init number:=0;  
  lc_variable   varchar2(4000);
  ln_job        number:= 0;   
  NUM_JOB_PENDIENTES NUMBER; 
  BEGIN
    -- EPERAR A QUE TERMINE EL ANTERIOR PROCESO 
    NUM_JOB_PENDIENTES := FN_MG_VERIFICA_TAREA(
               pi_vc2_nomjob => 'DAT_GARANTIAS',
               pi_vc2_nomusr => USER
               );

    WHILE NUM_JOB_PENDIENTES >0 LOOP
  
               NUM_JOB_PENDIENTES := FN_MG_VERIFICA_TAREA(
                 pi_vc2_nomjob => 'DAT_GARANTIAS',
                 pi_vc2_nomusr => USER
                 );
    end loop;    
    
    NUM_JOB_PENDIENTES := FN_MG_VERIFICA_TAREA(
               pi_vc2_nomjob => 'DAT_GRTIA_P_',
               pi_vc2_nomusr => USER
               );

    WHILE NUM_JOB_PENDIENTES >0 LOOP
  
               NUM_JOB_PENDIENTES := FN_MG_VERIFICA_TAREA(
                 pi_vc2_nomjob => 'DAT_GRTIA_P_',
                 pi_vc2_nomusr => USER
                 );
    end loop;     
  
  
--    execute immediate ('truncate table tab_jobs');
    execute immediate ('truncate table BANDEJAS.BNJ200');
    execute immediate ('truncate table BANDEJAS.BNJ201');
    execute immediate ('truncate table BANDEJAS.BNJ202');
    execute immediate ('truncate table BANDEJAS.BNJ203');
    execute immediate ('truncate table BANDEJAS.BNJ204');
    execute immediate ('truncate table BANDEJAS.BNJ205');
    execute immediate ('truncate table BANDEJAS.BNJ206');
    execute immediate ('truncate table BANDEJAS.BNJ207');    
    execute immediate ('truncate table BANDEJAS.BNJ208');  
--    execute immediate ('truncate table LOG_ERROR_BANDEJA');
      
    ld_fecini := sysdate;
    insert into LOG_CARGA_BANDEJA
      (n_nro, c_codbdj, c_cptbdj, d_fecini)
    values
      (seq_nro_ejecucion.NEXTVAL,
       'BNJ200',
       'Almacena informacion relativa a datos adicionales de garantias',
       ld_fecini);
    commit;
    select seq_nro_ejecucion.nextval into ln_nro from dual;
    
    insert into LOG_CARGA_BANDEJA
      (n_nro, c_codbdj, c_cptbdj, d_fecini)
    values
      (seq_nro_ejecucion.NEXTVAL,
       'BNJ201',
       'Almacena informacion relativa a datos adicionales de garantias TEXTO',
       ld_fecini);
    commit;
    select seq_nro_ejecucion.nextval into ln_nro1 from dual;    
    
    insert into LOG_CARGA_BANDEJA
      (n_nro, c_codbdj, c_cptbdj, d_fecini)
    values
      (seq_nro_ejecucion.NEXTVAL,
       'BNJ202',
       'Almacena informacion relativa a datos adicionales de garantias FECHA',
       ld_fecini);
    commit;
    select seq_nro_ejecucion.nextval into ln_nro2 from dual;    

    insert into LOG_CARGA_BANDEJA
      (n_nro, c_codbdj, c_cptbdj, d_fecini)
    values
      (seq_nro_ejecucion.NEXTVAL,
       'BNJ203',
       'Almacena informacion relativa a datos adicionales de garantias NUMERICO',
       ld_fecini);
    commit;
    select seq_nro_ejecucion.nextval into ln_nro3 from dual;    

    insert into LOG_CARGA_BANDEJA
      (n_nro, c_codbdj, c_cptbdj, d_fecini)
    values
      (seq_nro_ejecucion.NEXTVAL,
       'BNJ204',
       'Almacena informacion relativa a datos adicionales de garantias IMPORTE',
       ld_fecini);
    commit;
    select seq_nro_ejecucion.nextval into ln_nro4 from dual;    

    insert into LOG_CARGA_BANDEJA
      (n_nro, c_codbdj, c_cptbdj, d_fecini)
    values
      (seq_nro_ejecucion.NEXTVAL,
       'BNJ206',
       'Almacena informacion relativa a datos adicionales de garantias COMENTARIO',
       ld_fecini);
    commit;
    select seq_nro_ejecucion.nextval into ln_nro6 from dual;    

    insert into LOG_CARGA_BANDEJA
      (n_nro, c_codbdj, c_cptbdj, d_fecini)
    values
      (seq_nro_ejecucion.NEXTVAL,
       'BNJ207',
       'Almacena informacion relativa a datos adicionales de garantias BOOLEANO',
       ld_fecini);
    commit;
    select seq_nro_ejecucion.nextval into ln_nro7 from dual;    

    insert into LOG_CARGA_BANDEJA
      (n_nro, c_codbdj, c_cptbdj, d_fecini)
    values
      (seq_nro_ejecucion.NEXTVAL,
       'BNJ208',
       'Almacena informacion relativa a datos adicionales de garantias POP UP',
       ld_fecini);
    commit;
    select seq_nro_ejecucion.nextval into ln_nro8 from dual;    
         
      for job in c_job loop
           ln_init := ln_init + 1;  
           lc_variable := ' begin '||'  pq_migra_garantias.sp_datos_adicionales_BNJ200('||job.N_DIGITO1||','||job.N_DIGITO2||','||job.N_DIGITO3||','||ln_nro||','||ln_nro1||','||ln_nro2||','||ln_nro3||','||ln_nro4||','||ln_nro6||','||ln_nro7||','||ln_nro8||','||ln_init||');'|| ' End; ';           
           ln_job := ln_job +1;
           --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
          -- INSERTA TABLA CONTROL
          dbms_scheduler.create_job(
           job_name=> 'BAN_GRTIA_P_'||ln_init||LPAD(TO_CHAR(ln_job),5,'0'),
           job_type=> 'PLSQL_BLOCK',
           job_action=> lc_variable,
           start_date => sysdate+1/(24*180),
           enabled => true, 
           auto_drop=> TRUE,
           comments => 'LLENA BANDEJAS DE GARANTIAS '||ln_init
           );
           COMMIT;
          INSERT INTO Tab_jobs (c_codage,n_Numer1,c_detjob)
          VALUES('GDA',ln_init,lc_variable);
          COMMIT;        
      end loop;
  EXCEPTION
  WHEN OTHERS THEN
      lc_variable:=  sqlerrm;
      INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
      VALUES (0,'BATCH_DAT_GAR',lc_variable, TRUNC(SYSDATE));
      COMMIT;
  end sp_jobs_datos_garantias ;

end pq_migra_garantias;
/

