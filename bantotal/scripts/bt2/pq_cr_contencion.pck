create or replace package pq_cr_contencion is
   -- *****************************************************************
    -- Nombre                     : pq_cr_contencion
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.10.15
    -- Autor de Creación          : DCASTRO 
    -- Uso                        : OBTENER CARTERA CONTENIDA POR ANALISTAS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 20190625
    -- Autor de la Modificación   : DCASTRO 
    -- Descripción de Modificación: SE modifico sp_cr_retencion
    -- *****************************************************************

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
procedure sp_cr_contencion_insert( pn_sucurs in number, pd_Fecpro in date);
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
procedure sp_cr_valor_contencion(pd_Fecpro in date, pc_analista in char, pn_sucurs in number, pn_basecon out number, pn_porcentaje out number);
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
procedure sp_cr_job_carga(pd_fecpro in date); 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure sp_cr_contencion( pd_Fecpro in date );
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure sp_cr_job_contencion(pd_fecpro in date);
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure sp_cr_retencion( pd_Fecpro in date );
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure sp_cr_job_retencion(pd_fecpro in date);
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
procedure sp_cr_valor_retencion(pd_Fecpro in date, pc_analista in char, pn_sucurs in number, pn_baseret out number, pn_retenidos out number, pn_porcentaje out number);
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

end pq_cr_contencion;
/

create or replace package body pq_cr_contencion is
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

procedure sp_cr_contencion_insert(pn_sucurs in number, pd_Fecpro in date ) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_contencion
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.10.25
    -- Autor de Creación          : 
    -- Uso                        : OBTIENE CARTERA CONTENIDA
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************


 begin
   null;
  /*  insert into JAQZ451
    
    select 
         pd_Fecpro,
         i.jaql114fech,
         rs.sucurs,  
         \*rs.regnom "Region", 
         rs.deszon "Zona",
         rs.scnom "Sucursal",*\
         nvl(f.JAQL114ASE,i.JAQL114ASE) "Analista",
         \*d1.penom "Cliente",*\
         \*decode(JAQL114MDA,0,'Soles','Dolares') "Moneda",*\
         i.JAQL114CTA "Cuenta",  
         i.JAQL114OPER "Operacion",  
         i.JAQL114sdmn "Saldo MN Cierre Mes", 
         f.JAQL114sdmn "Saldo MN Actual",    
         \*decode(JAQL114MDA,0,
                           pq_act_montos.deuda_vencida_capital(pd_fecpro,i.JAQL114EMP,i.JAQL114MOD,i.JAQL114SUC,i.JAQL114MDA,i.JAQL114PAP,i.JAQL114CTA,i.JAQL114OPER,i.JAQL114SBOP,i.JAQL114TOP),
                           pq_act_montos.deuda_vencida_capital(pd_fecpro,i.JAQL114EMP,i.JAQL114MOD,i.JAQL114SUC,i.JAQL114MDA,i.JAQL114PAP,i.JAQL114CTA,i.JAQL114OPER,i.JAQL114SBOP,i.JAQL114TOP)*pq_act_montos.fn_tipo_cambio_fijo(trunc(sysdate))
                ) "Deuda Capital",
         decode(JAQL114MDA,0,
                           pq_act_montos.deuda_vencida_interes(pd_fecpro,i.JAQL114EMP,i.JAQL114MOD,i.JAQL114SUC,i.JAQL114MDA,i.JAQL114PAP,i.JAQL114CTA,i.JAQL114OPER,i.JAQL114SBOP,i.JAQL114TOP),
                           pq_act_montos.deuda_vencida_interes(pd_fecpro,i.JAQL114EMP,i.JAQL114MOD,i.JAQL114SUC,i.JAQL114MDA,i.JAQL114PAP,i.JAQL114CTA,i.JAQL114OPER,i.JAQL114SBOP,i.JAQL114TOP)*pq_act_montos.fn_tipo_cambio_fijo(trunc(sysdate))
                ) "Deuda Interes",             
         (case when f.JAQL114DATR>0 then pd_fecpro-f.JAQL114DATR end) "Fecha Vencimiento",      
         *\i.JAQL114DATR "Dias Atraso Mes Ant",
         f.JAQL114DATR "Dias Atraso"--,
         \*(case 
              when f.JAQL114DATR>30 then 'No Contenido'       
              when NVL(f.JAQL114DATR,0)<i.JAQL114DATR +to_char(\*to_date('&rrrrmmdd_f','rrrrmmdd')*\pd_fecpro,'dd')
                       and not exists (
                                        select 1
                                          from jaql166 j                                                                      
                                          where j.jaql166pgcod = 1 
                                            and j.jaql166scfvl between last_day(ADD_MONTHS(\*to_date('&rrrrmmdd_f','rrrrmmdd')*\pd_fecpro,-1))+1 and \*to_date('&rrrrmmdd_f','rrrrmmdd')*\pd_fecpro
                                            and j.jaql166nrpag = 0   
                                            and j.jaql166scmod in (33,65)
                                            and j.jaql166sccta = i.JAQL114CTA 
                                            and j.jaql166scope = i.JAQL114OPER
                                      )                 
                   then 'Contenido'         
              when nvl(f.JAQL114DATR,0)<=30 
                   and not exists (
                                    select 1
                                      from jaql166 j                                                                      
                                      where j.jaql166pgcod = 1 
                                        and j.jaql166scfvl between last_day(ADD_MONTHS(\*to_date('&rrrrmmdd_f','rrrrmmdd')*\pd_fecpro,-1))+1 and \*to_date('&rrrrmmdd_f','rrrrmmdd')*\pd_fecpro
                                        and j.jaql166nrpag = 0   
                                        and j.jaql166scmod in (33,65)
                                        and j.jaql166sccta = i.JAQL114CTA 
                                        and j.jaql166scope = i.JAQL114OPER
                                  )               
                then 'Pendiente'                            
         end)"Condicion"*\
               
    from (
          select 
                jaql114fech,
                JAQL114EMP,  
                JAQL114MOD,  
                JAQL114SUC,  
                JAQL114MDA,  
                JAQL114PAP,  
                JAQL114CTA,  
                JAQL114OPER,  
                JAQL114SBOP,
                JAQL114TOP,  
                JAQL114ASE,
                JAQL114DATR,
                sum(JAQL114sdmn)JAQL114sdmn
            from jaql114 j
           where j.jaql114fech = last_day(ADD_MONTHS(\*to_date('&rrrrmmdd_f','rrrrmmdd')*\pd_fecpro,-1))
             and substr(j.jaql114rubr,1,4) in (1411,1414,1415,1416,1421,1424,1425,1426)
             and j.jaql114cta <> 999999999
             and j.jaql114stat <> 99
             and j.jaql114mod not in (33,141)
             and j.jaql114suc = pn_sucurs
             and (case
                      when to_char(last_day(\*to_date('&rrrrmmdd_f','rrrrmmdd')*\pd_fecpro),'dd')='28'
                           and j.JAQL114DATR>=3
                           and j.JAQL114DATR<=30 -->MODIFICADO    
                      then 1     
                      when to_char(last_day(\*to_date('&rrrrmmdd_f','rrrrmmdd')*\pd_fecpro),'dd')='29'
                           and j.JAQL114DATR>=2
                           and j.JAQL114DATR<=30 -->MODIFICADO   
                      then 1     
                      when to_char(last_day(\*to_date('&rrrrmmdd_f','rrrrmmdd')*\pd_fecpro),'dd')='30'
                           and j.JAQL114DATR>=1
                           and j.JAQL114DATR<=30 -->MODIFICADO  
                      then 1     
                      when to_char(last_day(\*to_date('&rrrrmmdd_f','rrrrmmdd')*\pd_fecpro),'dd')='31'
                           and (
                                   (
                                    j.JAQL114DATR=0 and 
                                    pq_act_montos.fn_fecha_pagcuo(
                                                              last_day(ADD_MONTHS(\*to_date('&rrrrmmdd_f','rrrrmmdd')*\pd_fecpro,-1)),
                                                              j.JAQL114EMP,  
                                                              j.JAQL114MOD,  
                                                              j.JAQL114SUC,  
                                                              j.JAQL114MDA,  
                                                              j.JAQL114PAP,  
                                                              j.JAQL114CTA,
                                                              j.JAQL114OPER,  
                                                              j.JAQL114SBOP,  
                                                              j.JAQL114TOP                        
                                                            )= last_day(ADD_MONTHS(\*to_date('&rrrrmmdd_f','rrrrmmdd')*\pd_fecpro,-1))                      
                                   )
                                   or 
                                   (j.JAQL114DATR>=1 and j.JAQL114DATR<=30)-->MODIFICADO
                               )
                      then 1     
                 end)=1                     
          group by 
                jaql114fech,
                JAQL114EMP,  
                JAQL114MOD,  
                JAQL114SUC,  
                JAQL114MDA,  
                JAQL114PAP,  
                JAQL114CTA,  
                JAQL114OPER,  
                JAQL114SBOP,
                JAQL114TOP,
                JAQL114ASE,
                JAQL114DATR        
         ) i
         left join 
         (
         
          select 
                JAQL114SUC,  
                JAQL114ASE,
                JAQL114CTA,  
                JAQL114OPER,  
                JAQL114DATR,
                sum(JAQL114sdmn)JAQL114sdmn
            from jaql114 j
           where j.jaql114fech = last_day(\*to_date('&rrrrmmdd_f','rrrrmmdd')*\pd_fecpro)
             and substr(j.jaql114rubr,1,4) in (1411,1414,1415,1416,1421,1424,1425,1426)
             and j.jaql114cta <> 999999999
             and j.jaql114stat <> 99
             and j.jaql114mod not in (33,141)
             and j.jaql114suc = pn_sucurs
        group by 
                JAQL114SUC,  
                JAQL114ASE,
                JAQL114CTA,  
                JAQL114OPER,  
                JAQL114DATR              
                
         )f
         on i.JAQL114CTA = f.JAQL114CTA
        and i.JAQL114OPER= f.JAQL114OPER
        left join regsuc rs
        on rs.sucurs = nvl(f.JAQL114SUC,i.JAQL114SUC)
        inner join fsr008 r8
         on r8.pgcod = 1
        and r8.ctnro = i.JAQL114CTA
        and r8.ttcod = 1
        and r8.cttfir='T'
        inner join fsd001 d1
         on d1.pepais = r8.pepais
        and d1.petdoc = r8.petdoc
        and d1.pendoc = r8.pendoc;*/
    
  
  
  end  sp_cr_contencion_insert ;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

procedure sp_cr_valor_contencion(pd_Fecpro in date, pc_analista in char, pn_sucurs in number, pn_basecon out number, pn_porcentaje out number) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_contencion
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.10.25
    -- Autor de Creación          : 
    -- Uso                        : RETORNA BASE CONTENIDA y PORCENTAJE de COTNENCION
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************

 ln_contenido number:= 0;
 ln_NoContenido number:= 0;
 lc_analista varchar2(10);
 ln_saldofin number := 0;
 ln_saldoact number := 0;

 begin

      --lc_analista := rpad(pc_analista, 10, ' ');
      lc_analista := trim(pc_analista);

       pn_basecon := 0;
       pn_porcentaje := 0;

       begin
           select sum(nvl(j.jaqz451sfm,0)) SaldoFinMes, sum(nvl(j.jaqz451sac,0)) SaldoActual
             into ln_saldofin,ln_saldoact
             from jaqz451 j 
            where jaqz451fpro = pd_fecpro
              and j.jaqz451ana = lc_analista 
              and j.jaqz451age = pn_sucurs;
       exception when no_Data_found then
            ln_saldofin := 0;         
            ln_saldoact := 0;            
       end;     


       begin
        select sum( j.jaqz451sfm) SaldoActual
          into ln_contenido
          from jaqz451 j 
          where jaqz451fpro = pd_fecpro
           and j.jaqz451ana = lc_analista 
           and j.jaqz451age = pn_sucurs
           and j.jaqz451dia <= 30;
       exception when no_Data_found then
            ln_contenido := 0;         
       end;     

 
       pn_basecon := nvl(ln_saldofin,0);
      

      if pn_basecon <> 0 then
            pn_porcentaje := round(ln_contenido * 100/ pn_basecon,2);
      end if;


 end sp_cr_valor_contencion;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure sp_cr_job_carga(pd_fecpro in date) is

ln_ini number;
lc_variable varchar2(1000);
ln_job number:=0;
lc_fecpro char(10);
ld_finmes date;
lc_hostname varchar2(64);
  cursor sucursal is 
   select * from fst001 where pgcod =1  and   sucurs < 800 or sucurs >= 900;

begin

  --elimina informacion de la fecha de proceso
  delete from JAQZ451 j where j.jaqz451fpro = pd_fecpro;
  commit;
  
  
  begin
    select host_name
      into lc_hostname
      from v$instance;
  end;
  lc_fecpro := to_char(pd_fecpro,'RRRR.MM.DD');  
  
 
    for i in sucursal loop    
          ln_ini := i.sucurs;
          lc_variable := 'begin '||'  pq_cr_contencion.sp_cr_contencion_insert('||ln_ini||',TO_DATE('''||lc_fecpro||''',''RRRR.MM.DD'') );'||' End;';
          ln_job := ln_job +1;
--          if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then             
--          if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
IF SYS.FN_BD_ISRAC='TRUE' THEN
           DBMS_JOB.SUBMIT(job => ln_job, 
                        what => lc_variable,
                        next_date => sysdate+1/(24*60),
                        interval => null,
                        no_parse => false,
                        instance => 2,
                        force => false
                        );
          else
            DBMS_JOB.SUBMIT(job => ln_job, 
                        what => lc_variable,
                        next_date => sysdate+1/(24*60),
                        interval => null,
                        no_parse => false,
                        force => false
                        );
          end if;
          INSERT INTO Tab_jobs (c_Codage,n_Numer1,c_detjob)
          VALUES('PRD',ln_ini,lc_variable);
          COMMIT;

    end loop;          
    
  
end sp_cr_job_carga;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

procedure sp_cr_contencion( pd_Fecpro in date ) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_contencion
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.10.25
    -- Autor de Creación          : 
    -- Uso                        : OBTIENE CARTERA CONTENIDA
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************


  cursor contenidos is   
      select a.jaqz452afpro , a.jaqz452asuc, a.jaqz452aana, a.jaqz452acond, count(*) cantidad, 
       sum(a.jaqz452asdfm) sdo_contenido 
        from JAQZ452A a 
        where a.jaqz452afpro = pd_Fecpro
        and upper(jaqz452acond)= 'CONTENIDO'
        group by a.jaqz452afpro , a.jaqz452asuc, a.jaqz452aana, a.jaqz452acond ;

ln_cantidad number :=0;

begin
  
     delete from JAQZ452 a where a.jaqz452fpro = pd_Fecpro;
     commit;

    begin  
      select count(*) 
       into ln_cantidad
       from JAQZ452A a 
      where a.jaqz452afpro = pd_Fecpro;
     exception when others then
        ln_cantidad := 0;
    end;

    --insertar 
    insert into  JAQZ452 ( jaqz452fpro, jaqz452fech, jaqz452age, jaqz452ana, jaqz452cli, jaqz452con, jaqz452base   )
    select a.jaqz452afpro , a.jaqz452afpro , a.jaqz452asuc, a.jaqz452aana, a.jaqz452asuc, 0,  sum(a.jaqz452asdfm) 
      from JAQZ452A a 
      where a.jaqz452afpro = pd_Fecpro
      and a.jaqz452aage is not null
    group by a.jaqz452afpro , a.jaqz452asuc, a.jaqz452aana;
     commit;  

    for i  in contenidos loop
        
        --actualiza    
          update JAQZ452 a 
             set a.jaqz452con = i.sdo_contenido  
          where a.jaqz452fpro =  i.jaqz452afpro
            and a.jaqz452age  =  i.jaqz452asuc
            and a.jaqz452ana  =  i.jaqz452aana;
     commit;
    end loop;   


 
  end  sp_cr_contencion ;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure sp_cr_job_contencion(pd_fecpro in date) is

ln_ini number;
lc_variable varchar2(1000);
ln_job number:=0;
lc_fecpro char(10);
ld_finmes date;
lc_hostname varchar2(64);
  cursor sucursal is 
   select * from fst001 where pgcod =1  and   sucurs < 800 or sucurs >= 900;

begin
  begin
    select host_name
      into lc_hostname
      from v$instance;
  end;
  
  --elimina informacion de la fecha de proceso
  delete from JAQZ451 j where j.jaqz451fpro = pd_fecpro;
  commit;
  
  
  lc_fecpro := to_char(pd_fecpro,'RRRR.MM.DD');  
  
 
    for i in sucursal loop    
          ln_ini := i.sucurs;
          lc_variable := 'begin '||'  pq_cr_contencion.sp_cr_contencion('||ln_ini||',TO_DATE('''||lc_fecpro||''',''RRRR.MM.DD'') );'||' End;';
          ln_job := ln_job +1;
--          if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then             
--          if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
IF SYS.FN_BD_ISRAC='TRUE' THEN
           DBMS_JOB.SUBMIT(job => ln_job, 
                        what => lc_variable,
                        next_date => sysdate+1/(24*60),
                        interval => null,
                        no_parse => false,
                        instance => 2,
                        force => false
                        );
          else
            DBMS_JOB.SUBMIT(job => ln_job, 
                        what => lc_variable,
                        next_date => sysdate+1/(24*60),
                        interval => null,
                        no_parse => false,
                        force => false
                        );
          end if;
          INSERT INTO Tab_jobs (c_Codage,n_Numer1,c_detjob)
          VALUES('PRD',ln_ini,lc_variable);
          COMMIT;

    end loop;          
    
  
end sp_cr_job_contencion;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

procedure sp_cr_retencion( pd_Fecpro in date ) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_retencion
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.11.14
    -- Autor de Creación          : 
    -- Uso                        : OBTIENE RETENCION DE CLIENTES
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************



cursor retenidos is
      select a.jaqz451afpro,  a.jaqz451aest , b.jaqz451csuc, b.jaqz451cana ,count(distinct a.jaqz451accli) cantidad 
      from JAQZ451A a , JAQZ451C b --6659
      where a.jaqz451afpro = b.jaqz451cfpro
      and a.jaqz451accli = b.jaqz451cccli
      and a.jaqz451afpro = pd_Fecpro
      and b.jaqz451cfpro = pd_Fecpro
      and a.jaqz451aest = 'RETENIDO'
    group by a.jaqz451afpro, a.jaqz451aest , b.jaqz451csuc, b.jaqz451cana;


ln_num number :=0;

begin
  
    delete  from JAQZ451  a where  a.jaqz451fpro = pd_Fecpro;
    commit;

    begin
         
        select count(*)
          into ln_num
          from JAQZ451B a 
         where a.jaqz451bfpro = pd_Fecpro; 
    exception when others then
       ln_num := 0;          
    end;   
          
    if ln_num <> 0 then 

      --insertando base
       insert into JAQZ451 j (jaqz451fpro, jaqz451fech, jaqz451age, jaqz451ana, jaqz451cta, jaqz451ope,   jaqz451base , jaqz451ret ) 
        select a.jaqz451bfpro, a.jaqz451bfpro, a.jaqz451bsuc, a.jaqz451bana, a.jaqz451bsuc, a.jaqz451bsuc, count(distinct a.jaqz451bccli), 0
          from JAQZ451B a 
          where a.jaqz451bfpro = pd_Fecpro
          and a.jaqz451bsuc is not null
        group by a.jaqz451bfpro,   a.jaqz451bsuc, a.jaqz451bana; 
        
        commit;
                 
      --actualizando retencion
      for i in retenidos loop
          
          --actualiza    
          update JAQZ451 a 
             set  a.jaqz451ret = i.cantidad  
          where a.jaqz451fpro =  i.jaqz451afpro
            and a.jaqz451age  =  i.jaqz451csuc
            and a.jaqz451ana  =  i.jaqz451cana;
          
          commit;
      
      end loop;
      
    end if;          


end  sp_cr_retencion ;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
procedure sp_cr_job_retencion(pd_fecpro in date) is

ln_ini number;
lc_variable varchar2(1000);
ln_job number:=0;
lc_fecpro char(10);
ld_finmes date;
lc_hostname varchar2(64);

  cursor sucursal is 
   select * from fst001 where pgcod =1  and   sucurs < 800 or sucurs >= 900;

begin
  begin
    select host_name
      into lc_hostname
      from v$instance;
  end;
  lc_fecpro := to_char(pd_fecpro,'RRRR.MM.DD');  
  
   --elimina informacion de la fecha de proceso
  delete from JAQZ452 j where j.jaqz452fpro = pd_fecpro;
  commit;
 
 
 
    for i in sucursal loop    
          ln_ini := i.sucurs;
          lc_variable := 'begin '||'  pq_cr_contencion.sp_cr_retencion('||ln_ini||',TO_DATE('''||lc_fecpro||''',''RRRR.MM.DD'') );'||' End;';
          ln_job := ln_job +1;
--          if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then             
--          if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
IF SYS.FN_BD_ISRAC='TRUE' THEN
           DBMS_JOB.SUBMIT(job => ln_job, 
                        what => lc_variable,
                        next_date => sysdate+1/(24*60),
                        interval => null,
                        no_parse => false,
                        instance => 2,
                        force => false
                        );
          else
            DBMS_JOB.SUBMIT(job => ln_job, 
                        what => lc_variable,
                        next_date => sysdate+1/(24*60),
                        interval => null,
                        no_parse => false,
                        force => false
                        );
          end if;
          INSERT INTO Tab_jobs (c_Codage,n_Numer1,c_detjob)
          VALUES('PRD',ln_ini,lc_variable);
          COMMIT;

    end loop;          
    
  
end sp_cr_job_retencion;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
procedure sp_cr_valor_retencion(pd_Fecpro in date, pc_analista in char, pn_sucurs in number, pn_baseret out number, pn_retenidos out number, pn_porcentaje out number) is
    -- *****************************************************************
    -- Nombre                     : sp_cr_valor_retencion
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2016.11.14
    -- Autor de Creación          : 
    -- Uso                        : RETORNA BASE RETENCION y RETENIDOS
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************

 ln_base number:= 0;
 ln_retenidos number:= 0;
 lc_analista varchar2(10);
 ln_excedente number:= 0;


 begin

      --lc_analista := rpad(pc_analista, 10, ' ');
      lc_analista := trim(pc_analista);

       pn_baseret := 0;
       pn_retenidos := 0;

       begin
           select count(j.jaqz452cod) BaseRetencion
             into ln_base
             from jaqz452 j 
            where jaqz452fpro = pd_fecpro
              and j.jaqz452ana = lc_analista 
              and j.jaqz452age = pn_sucurs;
       exception when no_Data_found then
            ln_base := 0;         
       end;     


       begin
        select count( distinct jaqz452cli) retenidos
          into ln_retenidos
          from jaqz452 j 
          where jaqz452fpro = pd_fecpro
           and j.jaqz452ana = lc_analista 
           and j.jaqz452age = pn_sucurs
           and j.jaqz452tip = 1389
           and j.jaqz452ind = 1;
       exception when no_Data_found then
            ln_retenidos := 0;         
       end;     

 
       pn_baseret := ln_base;
       pn_retenidos := ln_retenidos;

       if pn_baseret <> 0 then
            pn_porcentaje := round(ln_retenidos * 100/ pn_baseret,2);
       end if;
       
 
 end sp_cr_valor_retencion;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
 
end pq_cr_contencion;
/

