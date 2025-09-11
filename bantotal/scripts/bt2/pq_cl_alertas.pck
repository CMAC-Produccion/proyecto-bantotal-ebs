create or replace package PQ_CL_ALERTAS is

  -- *****************************************************************
  -- Nombre                     : PQ_CL_ALERTAS
  -- Sistema                    : BANTOTAL
  -- M�dulo                     : Pasivas 
  -- Versi�n                    : 1.0
  -- Fecha de Creaci�n          : 28/04/2023 14:57:31
  -- Autor de Creaci�n          : Yrving Lozada
  -- Uso                        : Mensajes Servicio al CLiente
  -- Estado                     : Activo
  -- Acceso                     : P�blico
  -- Par�metros de Entrada      :
  -- Fecha de Modificaci�n      : 25/01/2024 Se actualiz� campo de mensaje
  -- Fecha de Modificaci�n      : 08/04/2024 Se crearon nuevas alertas de creditos
  -- Autor de Modificaci�n      : Yrving Lozada
  -- Fecha de Modificaci�n      : 19/07/2024 Se afinaron alertas y se adicion� control de datos personales
  -- Autor de Modificaci�n      : Yrving Lozada  
  -- Autor de Modificaci�n      : Yrving Lozada
  -- Fecha de Modificaci�n      : 10/07/2025 Se creo la funcion para retornar logica de celular
  -- Autor de Modificaci�n      : Yrving Lozada    
  -- Fecha de Modificaci�n      : 18/08/2025 Se creo procedimiento para deshabilitar alugnos tipo de mensajes.
  -- Autor de Modificaci�n      : rcastro   
  -- *****************************************************************  

  Procedure sp_genera_scheduler;
  procedure sp_cl_genera_afi(P_C_DIGITO1 IN VARCHAR2,
                             P_C_DIGITO2 IN VARCHAR2,
                             ln_ini      in number
                             );  
  procedure sp_cl_alertas(P_N_NUMCTA IN NUMBER,
                          P_D_FECPRO IN DATE,
                          P_C_TIPPRO IN VARCHAR2,
                          P_C_CANAL  IN VARCHAR2,
                          P_C_CODUSU IN VARCHAR2                          
                          );  
procedure sp_cl_alertas_cre(P_N_CODALE IN NUMBER,   --10 NOTIF. DESEMBOLSO,11 NOTIF. CAMBIO ANALISTA,12 NOTIF.PAGO PUNTUAL 13 RENOVAC. DPF
                            P_N_NUMCTA IN NUMBER,   --CUENTA CLIENTE                    
                            P_D_FECPRO IN DATE,     --FECHA DE PROCESO
                            P_C_TIPPRO IN VARCHAR2, --TIPO, A = AHORRO C= CREDITOS
                            P_C_CANAL  IN VARCHAR2, --VENTANILLA, APP
                            P_C_CODUSU IN VARCHAR2, --USUARIO REGISTRO O ANALISTA ORIGEN
                            P_C_VAAUX1 IN VARCHAR2, --ANALISTA NOMBRE Y APELLIDO
                            P_C_VAAUX2 IN VARCHAR2, --CORREO minusculas
                            P_C_VAAUX3 IN VARCHAR2  --CELULAR
                            );
procedure sp_cl_genera_ren;
Function FN_AH_CONCEL(P_N_PAIS   IN NUMBER,
                      P_N_TIPDOC IN NUMBER,
                      P_C_NUMDOC IN VARCHAR2
                     ) return NUMBER;         
Procedure SP_AH_MAIL(P_N_PAIS   IN NUMBER,
                     P_N_TIPDOC IN NUMBER,
                     P_C_NUMDOC IN VARCHAR2,    
                     p_c_correo out varchar2
                    );
                    
PROCEDURE SP_CR_DESHAB_ENVIO_TIPOMSG(P_AQPA142TIM NUMBER, O_FLG_DESHABILT OUT VARCHAR2);                    
end PQ_CL_ALERTAS;
/
create or replace package body PQ_CL_ALERTAS is

  procedure sp_genera_scheduler is
      cursor c_job is               
      Select /*+PARALLEL(T,4)*/
       SUBSTR(trim(x.pfndoc), -1, 1) C_DIGITO1,
       SUBSTR(trim(x.pfndoc), -2, 1) C_DIGITO2
        from fsd002 x
       GROUP BY SUBSTR(trim(x.pfndoc), -1, 1), SUBSTR(trim(x.pfndoc), -2, 1);
         
    lc_variable varchar2(4000);
    ln_job      number := 0;
    ln_ini      number := 0;
  
  begin
  
    --
    -- Barridos de jobs
    --
    execute immediate ('truncate table schedulers');
    execute immediate ('truncate table log_actu_datos');
  
    for job in c_job loop
      ln_ini      := ln_ini + 1;
      lc_variable := ' begin ' ||
                     '  pq_cl_alertas.sp_cl_genera_afi(' || '''' ||
                     job.C_DIGITO1 || '''' || ',' || '''' || job.C_DIGITO2 || '''' || ',' ||
                     ln_ini || ');' || ' End; ';
      ln_job      := ln_job + 1;
    
      dbms_scheduler.create_job(job_name   => 'AFILIA_CUMPLE' ||
                                              LPAD(TO_CHAR(ln_job), 5, '0'),
                                job_type   => 'PLSQL_BLOCK',
                                job_action => lc_variable,
                                start_date => sysdate + 1 / (24 * 180),
                                enabled    => true,
                                auto_drop  => TRUE,
                                comments   => 'AFILIACI�N CUMPLEA�OS CLIENTES');
    
      INSERT INTO Schedulers
        (c_codage, n_Numer1, c_detjob)
      VALUES
        ('CUM', ln_ini, lc_variable);
      COMMIT;
    
    end loop;
    
    --EJECUTAMOS JOB DE RENOVACIONES DE DPF

      lc_variable := ' begin ' ||
                     '  pq_cl_alertas.sp_cl_genera_ren;' || ' End; ';
      ln_job      := 1;
    
      dbms_scheduler.create_job(job_name   => 'AFILIA_REN' ||
                                              LPAD(TO_CHAR(ln_job), 5, '0'),
                                job_type   => 'PLSQL_BLOCK',
                                job_action => lc_variable,
                                start_date => sysdate + 1 / (24 * 180),
                                enabled    => true,
                                auto_drop  => TRUE,
                                comments   => 'AFILIACI�N RENOVACIONES DPF CLIENTES');
    
      INSERT INTO Schedulers
        (c_codage, n_Numer1, c_detjob)
      VALUES
        ('REN', 1, lc_variable);
      COMMIT;    
  exception
  when others then
    null;
  end sp_genera_scheduler;
  procedure sp_cl_genera_afi(P_C_DIGITO1 IN VARCHAR2,
                             P_C_DIGITO2 IN VARCHAR2,
                             ln_ini      in number
                             ) is
  lc_nombre     varchar2(150);        
  lc_sexo       char(1);    
  ln_cont       number(9):=0;
  lv_msg        varchar2(400):='';
  ln_tipo       number(9):= 4;
  lc_msgerr     VARCHAR2(400);
  lc_msgerr2    VARCHAR2(400);
  lv_prinom     varchar2(25):=''; 
  ln_celular    number(9);   
  
  cursor c_personas(P_C_DIGITO1 in varchar2,P_C_DIGITO2 in varchar2) is
  Select x.pfpais pepais,
         x.pftdoc petdoc,
         x.pfndoc pendoc,
         MONTHS_BETWEEN(trunc(SYSDATE),x.pffnac)/12 edad 
    from fsd002  x, 
         aqpa106 y
   where x.pfpais = y.aqpa106pai
     and x.pftdoc = y.aqpa106tpo
     and x.pfndoc = y.aqpa106num
     and y.aqpa106est = 'A'
     and mod(MONTHS_BETWEEN(trunc(SYSDATE),x.pffnac),12) = 0
     and substr(trim(x.pfndoc), -1, 1) = P_C_DIGITO1
     and substr(trim(x.pfndoc), -2, 1) = P_C_DIGITO2;
      
  cursor c_productos(ln_pais in number, ln_tipdoc in number, lv_numdoc in varchar2) is
    Select a.scfval
      from fsd011 a,
           (Select distinct y.pgcod,y.ctnro 
              from fsr008 y 
             where y.pgcod  = 1 
               and y.pepais = ln_pais  
               and y.petdoc = ln_tipdoc
               and y.pendoc = rpad(lv_numdoc,12,' ')
           ) z
     where a.pgcod = z.pgcod
       and a.sccta = z.ctnro
       and a.scmod = 21
       and a.scpap = 0          
       and ((a.scfulm = to_date('1/01/0001','dd/mm/rrrr') and a.scstat <> 99)
            or 
            (a.scfulm is null and a.scstat <> 99)
            or a.scfulm > add_months(trunc(sysdate),-6)
           )
           
    union
    Select a.aofval
      from fsd010 a,
           (Select distinct y.pgcod,y.ctnro 
              from fsr008 y 
             where y.pgcod  = 1 
               and y.pepais = ln_pais  
               and y.petdoc = ln_tipdoc
               and y.pendoc = rpad(lv_numdoc,12,' ')
           ) z      
     where a.pgcod = z.pgcod
       and a.aocta = z.ctnro
       and a.aomod = 22
       and ((a.aofe99 = to_date('1/01/0001','dd/mm/rrrr') and a.aostat <> 99)
            or 
            (a.aofe99 is null and a.aostat <> 99)
            or a.aofe99 > add_months(trunc(sysdate),-6)
           )
    union
    Select a.aofval
      from fsd010 a,
           fst111 b,
           (Select distinct y.pgcod,y.ctnro 
              from fsr008 y 
             where y.pgcod  = 1 
               and y.pepais = ln_pais  
               and y.petdoc = ln_tipdoc
               and y.pendoc = rpad(lv_numdoc,12,' ')
           ) z           
     where a.pgcod = z.pgcod
       and a.aocta = z.ctnro
       and a.aomod = b.modulo
       and b.dscod = 50 
       and ((a.aofe99 = to_date('1/01/0001','dd/mm/rrrr') and a.aostat <> 99)
            or 
            (a.aofe99 is null and a.aostat <> 99)
            or a.aofe99 > add_months(trunc(sysdate),-6)
           )       
  order by 1;  
  /*
  cursor c_celulares(ln_pais in number, ln_tipdoc in number, lv_numdoc in varchar2,lv_tipo in varchar2) is
  select ww.* 
    from (
          select t.doordp,t.dotelfp
           from FSR005 t,
                sngc17 a 
          where a.sngc17pais = t.pepais
            and a.sngc17tdoc = t.petdoc
            and a.sngc17ndoc = t.pendoc
            and a.sngc17dcod = t.docod   
            and a.sngc17corr = t.doordp   
            and t.pepais = ln_pais
            and t.petdoc = ln_tipdoc
            and t.pendoc = rpad(lv_numdoc,12,' ')
            and pq_ah_enviodigital.fn_ah_valida_celular(TRIM(t.dotelfp),1) = 'S'
            and t.docod in (Select x.tp1nro1
                              from fst198 x
                             where x.tp1cod   = 1
                               and x.tp1cod1  = 10825
                               and x.tp1corr1 = 126
                               and x.tp1corr2 = 5
                            )
           --and FN_AH_CONCEL(t.pepais,t.petdoc,t.pendoc,t.dotelfp) = lv_tipo 
           and pq_cl_alertas.FN_AH_CONCEL(t.pepais,t.petdoc,t.pendoc) = to_number(trim(t.dotelfp))
           order by t.doordp desc
         ) ww where rownum = 1;                                                                          
*/
  cursor c_mensaje(ln_codale in number,ln_edad in number) is
    Select x.tp1desc
      from fst198 x,
           fst198 y
     where x.tp1cod   = y.tp1cod
       and x.tp1cod1  = y.tp1cod1
       and x.tp1corr1 = y.tp1corr1
       and x.tp1nro1 = y.tp1nro1
       and x.tp1nro2 = y.tp1nro2
       and x.tp1cod   = 1
       and x.tp1cod1  = 10825
       and x.tp1corr1 = 126
       and x.tp1corr2 = ln_codale
       and y.tp1cod   = 1
       and y.tp1cod1  = 10825
       and y.tp1corr1 = 126
       and y.tp1corr2 = 8
       and ln_edad between y.tp1nro1 and y.tp1nro2
  order by x.tp1corr3;
  
  cursor c_prioridad is 
    Select upper(Substr(trim(x.tp1desc),1,1)) tipo,
           x.tp1nro1 flag
      from fst198 x
     where x.tp1cod   = 1
       and x.tp1cod1  = 10825
       and x.tp1corr1 = 126
       and x.tp1corr2 = 6;                                         
begin         
    update schedulers g
       set g.d_fecini = sysdate
     where g.n_numer1 = ln_ini
       and g.c_codage = 'CUM';--CUMPLEA�OS
    commit;                        
    
    --buscamos todos los integrantes de la cuenta cliente
    for i in c_personas(P_C_DIGITO1,P_C_DIGITO2) loop    
      ln_cont := 0;   
      lv_msg  := '';
      for j in c_productos(i.pepais,i.petdoc,i.pendoc) loop
         ln_cont := ln_cont + 1;
         if ln_cont = 1 then
           Exit;
         End If;             
      end loop;
      
      --SOLO SI APLICA SI TIENE PRODUCTOS VIGENTES O CANCELADOS CON ANTERIORIDAD A 6 MESES
      IF ln_cont > 0 THEN
          --DATOS PARA LA AFILIACI�N  
          BEGIN        
           select trim(upper(x.pfape1))||' '||trim(upper(x.pfape2))||' , '||trim(upper(x.pfnom1))||' '||trim(upper(x.pfnom2)),
                  decode(x.Pfcant,null,'M',x.Pfcant),
                  trim(substr(upper(x.pfnom1),1,12))
             into lc_nombre,
                  lc_sexo,
                  lv_prinom
             from fsd002 x 
            where x.pfpais = i.pepais 
              and x.pftdoc = i.petdoc  
              and x.pfndoc = i.pendoc;                    
          EXCEPTION  
          WHEN OTHERS THEN
            lc_nombre := null;
            lc_sexo := null;
            lv_prinom := null;
          END;   
          --
          --ELIMINAMOS AFILIACIONES ANTERIORES
          --
          begin
            delete from ichannelalert.CLIENTES_AFILIADOS where codigo_cliente like 'C@'||lpad(trim(to_char(i.pendoc)),12,'0')||'%';
            COMMIT;
          exception
          when others then
            null;  
          end;
          --
          --afiliamos a ichannel       
          --          
          For z in c_mensaje(4,i.edad) loop
            lv_msg := lv_msg || z.tp1desc;
          End loop;
          lv_msg := trim(replace(lv_msg,'#NOMBRE',lv_prinom));          

          ln_cont := 0;          
          For w in c_prioridad loop
            if ln_cont = 0 or w.flag = 1 then
                ln_celular := to_number(trim(pq_cl_alertas.FN_AH_CONCEL(i.pepais,i.petdoc,i.pendoc))); 
                --For k in c_celulares(i.pepais,i.petdoc,i.pendoc,w.tipo) loop
                if ln_celular is not null then
                   BEGIN                          
                        INSERT INTO ichannelalert.CLIENTES_AFILIADOS(codigo_cliente,
                                                                nombre_cliente,
                                                                mail_cliente,
                                                                celular_cliente,
                                                                sexo_cliente,
                                                                enviar_celular,
                                                                enviar_mail)
                                                         values('C@'||lpad(trim(to_char(i.pendoc)),12,'0')||lpad(trim(to_char(ln_celular)),9,'0'),--DNI + CELULAR
                                                                lc_nombre,
                                                                '',
                                                                ln_celular,
                                                                lc_sexo,
                                                                'S',
                                                                'N'
                                                                );
                   EXCEPTION
                   WHEN OTHERS THEN  
                      lc_msgerr  := substr(sqlerrm, 1, 50);
                      lc_msgerr2 := substr(sqlerrm, 51, 50);
                      insert into log_actu_datos
                        (jaql63nu01,
                         jaql63ch01,
                         jaql63ch02,
                         jaql63nu02,
                         jaql63ch03,
                         jaql63nu05)
                      values
                        (i.pendoc,
                         lc_msgerr,
                         lc_msgerr2,
                         1,
                         to_char(sysdate, 'HH24:mi:ss'),
                         20);
                      commit;
                   END;  
                   --REGISTRAMOS EN TABLA PARA ENVI� DEL MENSAJE
                   BEGIN
                   INSERT INTO AQPA142(AQPA142TIM,
                                       AQPA142FEC,
                                       AQPA142PAI,
                                       AQPA142TIP,
                                       AQPA142DOC,
                                       AQPA142CEL,
                                       AQPA142HOR,
                                       AQPA142MSG
                                       ) 
                                VALUES(ln_tipo,
                                       trunc(sysdate),
                                       i.pepais,
                                       i.petdoc,
                                       i.pendoc,
                                       ln_celular,
                                       to_char(sysdate,'HH24:mi:ss'),
                                       substr(lv_msg,1,160)                                
                                       );
                   EXCEPTION
                   WHEN OTHERS THEN
                      lc_msgerr  := substr(sqlerrm, 1, 50);
                      lc_msgerr2 := substr(sqlerrm, 51, 50);
                      insert into log_actu_datos
                        (jaql63nu01,
                         jaql63ch01,
                         jaql63ch02,
                         jaql63nu02,
                         jaql63ch03,
                         jaql63nu05)
                      values
                        (i.pendoc,
                         lc_msgerr,
                         lc_msgerr2,
                         2,
                         to_char(sysdate, 'HH24:mi:ss'),
                         20);
                      commit;
                   END; 
                   ln_cont := ln_cont + 1;  
                   commit;  
                End If;   
                --End loop; 
            End If;
          End loop; 
      END IF;
    End loop;
    commit;
    
    update schedulers g
       set g.d_fecfin = sysdate
     where g.n_numer1 = ln_ini
       and g.c_codage = 'CUM';
    commit;                               
exception
when others then  
  lc_msgerr := sqlerrm;
  update schedulers g
     set g.c_inderr = 'S', g.c_deserr = lc_msgerr
   where g.n_numer1 = ln_ini
     and g.c_codage = 'CUM';
  commit;
end sp_cl_genera_afi;  
procedure sp_cl_alertas(P_N_NUMCTA IN NUMBER,
                        P_D_FECPRO IN DATE,
                        P_C_TIPPRO IN VARCHAR2,
                        P_C_CANAL  IN VARCHAR2,
                        P_C_CODUSU IN VARCHAR2
                       ) is
   
  lc_codval  char(1):='';  
  ld_fecpri  date;
  ld_fecseg  date;
  ld_fecter  date;
  lc_nombre  varchar2(150);        
  lc_sexo    char(1);    
  ln_cont    number(9):=0;
  lv_msg     varchar2(400):='';
  ln_tipo    number(9):=0;
  lv_prinom  varchar2(25):='';
  lv_fecpro  varchar2(8):='';
  ln_tipcli1 number(9):=0;
  ln_tipcli2 number(9):=0;
  ln_tipcli3 number(9):=0;
  ln_celular number(9);
      
  cursor c_personas(ln_numcta in number) is
  Select * 
    from fsr008  x,
         aqpa106 y
   where x.pepais = y.aqpa106pai
     and x.petdoc = y.aqpa106tpo
     and x.pendoc = y.aqpa106num
     and y.aqpa106est = 'A'
     and x.pgcod = 1 
     and x.ttcod = 1
     and x.cttfir = 'T'
     and x.ctnro = ln_numcta;       
      
  cursor c_productos(ln_pais in number, ln_tipdoc in number, lv_numdoc in varchar2) is
  select distinct zz.scfval, zz.ln_tipcli 
    from (
    Select a.scfval,1 ln_tipcli
        from fsd011 a,
             (Select distinct y.pgcod,y.ctnro 
                from fsr008 y 
               where y.pgcod  = 1 
                 and y.pepais = ln_pais  
                 and y.petdoc = ln_tipdoc
                 and y.pendoc = rpad(lv_numdoc,12,' ')
             ) z
       where a.pgcod = z.pgcod
         and a.sccta = z.ctnro
         and a.scmod = 21
         and a.scpap = 0          
         and ((a.scfulm = to_date('1/01/0001','dd/mm/rrrr') and a.scstat <> 99)
              or 
              (a.scfulm is null and a.scstat <> 99)
              or a.scfulm > add_months(trunc(sysdate),-6)
             )
             
      union
      Select a.aofval,1 ln_tipcli
        from fsd010 a,
             (Select distinct y.pgcod,y.ctnro 
                from fsr008 y 
               where y.pgcod  = 1 
                 and y.pepais = ln_pais  
                 and y.petdoc = ln_tipdoc
                 and y.pendoc = rpad(lv_numdoc,12,' ')
             ) z      
       where a.pgcod = z.pgcod
         and a.aocta = z.ctnro
         and a.aomod = 22
         and ((a.aofe99 = to_date('1/01/0001','dd/mm/rrrr') and a.aostat <> 99)
              or 
              (a.aofe99 is null and a.aostat <> 99)
              or a.aofe99 > add_months(trunc(sysdate),-6)
             )
      union
      Select a.aofval,2 ln_tipcli
        from fsd010 a,
             fst111 b,
             (Select distinct y.pgcod,y.ctnro 
                from fsr008 y 
               where y.pgcod  = 1 
                 and y.pepais = ln_pais  
                 and y.petdoc = ln_tipdoc
                 and y.pendoc = rpad(lv_numdoc,12,' ')
             ) z           
       where a.pgcod = z.pgcod
         and a.aocta = z.ctnro
         and a.aomod = b.modulo
         and b.dscod = 50 
         and ((a.aofe99 = to_date('1/01/0001','dd/mm/rrrr') and a.aostat <> 99)
              or 
              (a.aofe99 is null and a.aostat <> 99)
              or a.aofe99 > add_months(trunc(sysdate),-6)
             )  
         ) zz         
    order by 1,2 desc;  
/*  
  cursor c_celulares(ln_pais in number, ln_tipdoc in number, lv_numdoc in varchar2, lv_tipo in varchar2) is
  select ww.* 
    from (
          select t.doordp,t.dotelfp
           from FSR005 t,
                sngc17 a 
          where a.sngc17pais = t.pepais
            and a.sngc17tdoc = t.petdoc
            and a.sngc17ndoc = t.pendoc
            and a.sngc17dcod = t.docod   
            and a.sngc17corr = t.doordp   
            and t.pepais = ln_pais
            and t.petdoc = ln_tipdoc
            and t.pendoc = rpad(lv_numdoc,12,' ')
            and pq_ah_enviodigital.fn_ah_valida_celular(TRIM(t.dotelfp),1) = 'S'
            and t.docod in (Select x.tp1nro1
                              from fst198 x
                             where x.tp1cod   = 1
                               and x.tp1cod1  = 10825
                               and x.tp1corr1 = 126
                               and x.tp1corr2 = 5
                            )
           --and FN_AH_CONCEL(t.pepais,t.petdoc,t.pendoc,t.dotelfp) = lv_tipo
           and pq_cl_alertas.FN_AH_CONCEL(t.pepais,t.petdoc,t.pendoc) = to_number(trim(t.dotelfp))
           order by t.doordp desc
         ) ww where rownum = 1;    
*/                                                                         
  cursor c_mensaje_camp(ln_codale in number, ln_tipcli in number, lv_fecpro in varchar2) is
      select B.TP1DESC 
        from 
              ( 
                 Select x.*
                    from fst198 x
                   where x.tp1cod   = 1
                     and x.tp1cod1  = 10825
                     and x.tp1corr1 = 126
                     and x.tp1corr2 = 9999
                     and x.tp1nro1  = ln_codale
                     and x.tp1imp2  = ln_tipcli --1 =Ahorro 2 = cr�dito
                     and TO_DATE(lv_fecpro,'rrrrmmdd') between to_date(x.tp1nro2,'rrrrmmdd') and to_date(x.tp1nro3,'rrrrmmdd')
              ) A,
              (
                  Select x.*
                    from fst198 x
                   where x.tp1cod   = 1
                     and x.tp1cod1  = 10825
                     and x.tp1corr1 = 126
                     and x.tp1corr2 = 8888
              )B       
      WHERE A.TP1COD   = B.TP1COD
        AND A.TP1COD1  = B.TP1COD1
        AND A.TP1CORR1 = B.TP1CORR1     
        AND A.TP1IMP1  = B.TP1NRO1  
   ORDER BY B.TP1NRO2;
                                         
  cursor c_mensaje_gen(ln_codale in number) is
    Select x.tp1desc
      from fst198 x
     where x.tp1cod   = 1
       and x.tp1cod1  = 10825
       and x.tp1corr1 = 126
       and x.tp1corr2 = ln_codale
  order by x.tp1corr3;
    
  cursor c_prioridad is 
    Select upper(Substr(trim(x.tp1desc),1,1)) tipo,
           x.tp1nro1 flag
      from fst198 x
     where x.tp1cod   = 1
       and x.tp1cod1  = 10825
       and x.tp1corr1 = 126
       and x.tp1corr2 = 6;    
  
begin
  --VERIFICAMOS SI LA CTA CLIENTE ES DE PN  
  pq_ah_new_comision.sp_ah_tipper(p_n_codpgc => 1,
                                  p_n_numcta => P_N_NUMCTA,
                                  p_c_codval => lc_codval);
                                  
  if lc_codval = 'F' then
    --buscamos todos los integrantes de la cuenta cliente
    for i in c_personas(P_N_NUMCTA) loop
      ld_fecpri := null;
      ld_fecseg := null;
      ld_fecter := null;   
      ln_cont := 0;
      ln_tipo := 0;
      lv_msg  := '';
      for j in c_productos(i.pepais,i.petdoc,i.pendoc) loop
         ln_cont := ln_cont + 1;

         if ln_cont = 1 then
            ld_fecpri := j.scfval;
            if ld_fecpri = P_D_FECPRO then --es su primer producto
               ld_fecpri:= P_D_FECPRO; 
            Else
               ld_fecpri := j.scfval;
            End If;
            ln_tipcli1 := j.ln_tipcli;
         End If;
         
         if ln_cont = 2 then
            ld_fecseg := j.scfval;           
            if ld_fecseg = P_D_FECPRO then --es su 2do producto
               ld_fecseg:= P_D_FECPRO; 
            Else
               ld_fecseg := j.scfval;              
            End If;
            ln_tipcli2 := j.ln_tipcli;
         End If;
         
         if ln_cont = 3 then
            ld_fecter := j.scfval;           
            if ld_fecter = P_D_FECPRO then --es su 3er producto
               ld_fecter:= P_D_FECPRO; 
            Else
               ld_fecter := j.scfval;              
            End If;
            ln_tipcli3 := j.ln_tipcli;
         End If;                   
         if ln_cont > 3 then
           Exit;
         End If;             
      end loop;
      --
      --En caso no tenga productos anteriores
      --
/*      if ln_cont = 0 then
        ld_fecpri := P_D_FECPRO;
      End If;    */  
      
      --Validamos cual de las 3 fechas corresponde para notificar    
      lv_fecpro := to_char(P_D_FECPRO,'rrrrmmdd');  
      if ld_fecpri = P_D_FECPRO then
          ln_tipo := 1;        
          For z in c_mensaje_camp(ln_tipo,ln_tipcli1,lv_fecpro) loop
            lv_msg := lv_msg || z.tp1desc;
          End loop;
          if lv_msg is null then
            For z in c_mensaje_gen(ln_tipo) loop
              lv_msg := lv_msg || z.tp1desc;
            End loop;            
          End If;  
      End If;
      if ld_fecseg = P_D_FECPRO then
          ln_tipo := 2;        
          For z in c_mensaje_camp(ln_tipo,ln_tipcli2,lv_fecpro) loop
            lv_msg := lv_msg || z.tp1desc;
          End loop;
          if lv_msg is null then
            For z in c_mensaje_gen(ln_tipo) loop
              lv_msg := lv_msg || z.tp1desc;
            End loop;            
          End If;            
      End If;
      if ld_fecter = P_D_FECPRO then
          ln_tipo := 3;        
          For z in c_mensaje_camp(ln_tipo,ln_tipcli3,lv_fecpro) loop
            lv_msg := lv_msg || z.tp1desc;
          End loop;
          if lv_msg is null then
            For z in c_mensaje_gen(ln_tipo) loop
              lv_msg := lv_msg || z.tp1desc;
            End loop;            
          End If;            
      End If;
      
      --SOLO SI APLICA PARA ALGUN PRODUCTO AFILIAMOS
      IF ln_tipo > 0 THEN
          --DATOS PARA LA AFILIACI�N  
          BEGIN        
           select trim(upper(x.pfape1))||' '||trim(upper(x.pfape2))||' , '||trim(upper(x.pfnom1))||' '||trim(upper(x.pfnom2)),
                  decode(x.Pfcant,null,'M',x.Pfcant),
                  trim(upper(x.pfnom1))
             into lc_nombre,
                  lc_sexo,
                  lv_prinom
             from fsd002 x 
            where x.pfpais = i.pepais 
              and x.pftdoc = i.petdoc  
              and x.pfndoc = i.pendoc;                    
          EXCEPTION  
          WHEN OTHERS THEN
            lc_nombre := null;
            lc_sexo := null;
            lv_prinom := null;
          END;   
          lv_msg := trim(replace(lv_msg,'#NOMBRE',lv_prinom));
          --
          --ELIMINAMOS AFILIACIONES ANTERIORES
          --
          begin
            delete from ichannelalert.CLIENTES_AFILIADOS where codigo_cliente like 'A@'||lpad(trim(to_char(i.pendoc)),12,'0')||'%';
            COMMIT;
          exception
          when others then
            null;  
          end;
          
          ln_cont := 0;          
          For w in c_prioridad loop
            if ln_cont = 0 or w.flag = 1 then          
              --
              --afiliamos a ichannel       
              --
              ln_celular := to_number(trim(pq_cl_alertas.FN_AH_CONCEL(i.pepais,i.petdoc,i.pendoc))); 
              --For k in c_celulares(i.pepais,i.petdoc,i.pendoc,w.tipo) loop
              if ln_celular is not null then  
                 BEGIN                          
                      INSERT INTO ichannelalert.CLIENTES_AFILIADOS(codigo_cliente,
                                                              nombre_cliente,
                                                              mail_cliente,
                                                              celular_cliente,
                                                              sexo_cliente,
                                                              enviar_celular,
                                                              enviar_mail)
                                                       values('A@'||lpad(trim(to_char(i.pendoc)),12,'0')||lpad(trim(to_char(ln_celular)),9,'0'),--DNI + CELULAR
                                                              lc_nombre,
                                                              '',
                                                              ln_celular,
                                                              lc_sexo,
                                                              'S',
                                                              'N'
                                                              );
                 EXCEPTION
                 WHEN OTHERS THEN  
                   null;
                 END;  
                 --REGISTRAMOS EN TABLA PARA ENVI� DEL MENSAJE
                 BEGIN
                   INSERT INTO AQPA142(AQPA142TIM,
                                       AQPA142FEC,
                                       AQPA142PAI,
                                       AQPA142TIP,
                                       AQPA142DOC,
                                       AQPA142CEL,
                                       AQPA142HOR,
                                       AQPA142MSG,
                                       aqpa142prd,
                                       aqpa142des,
                                       aqpa142uso
                                       ) 
                                VALUES(ln_tipo,
                                       P_D_FECPRO,
                                       i.pepais,
                                       i.petdoc,
                                       i.pendoc,
                                       ln_celular,
                                       to_char(sysdate,'HH24:mi:ss'),
                                       substr(lv_msg,1,160),
                                       P_C_TIPPRO,
                                       P_C_CANAL, 
                                       P_C_CODUSU                                   
                                       );
                 EXCEPTION
                 WHEN OTHERS THEN
                   null;    
                 END;  
                 ln_cont := ln_cont + 1; 
                 commit;
              end if;     
              --End loop;
            End if;
          End loop;  
      END IF;
    End loop;
    commit;
  End If;                                    
exception
when others then  
  null;
end sp_cl_alertas;
procedure sp_cl_alertas_cre(P_N_CODALE IN NUMBER,   --10 NOTIF. DESEMBOLSO,11 NOTIF. CAMBIO ANALISTA,12 NOTIF.PAGO PUNTUAL 13 RENOVAC. DPF
                            P_N_NUMCTA IN NUMBER,   --CUENTA CLIENTE                    
                            P_D_FECPRO IN DATE,     --FECHA DE PROCESO
                            P_C_TIPPRO IN VARCHAR2, --TIPO, A = AHORRO C= CREDITOS
                            P_C_CANAL  IN VARCHAR2, --VENTANILLA, APP
                            P_C_CODUSU IN VARCHAR2, --USUARIO REGISTRO O ANALISTA ORIGEN
                            P_C_VAAUX1 IN VARCHAR2, --ANALISTA NOMBRE Y APELLIDO
                            P_C_VAAUX2 IN VARCHAR2, --CORREO minusculas
                            P_C_VAAUX3 IN VARCHAR2  --CELULAR
                            ) is
  lc_nombre  varchar2(150);        
  lc_sexo    char(1);    
  ln_cont    number(9):=0;
  lv_msg     varchar2(400):='';
  lv_prinom  varchar2(25):='';
  ln_celular number(9);
                              
  cursor c_personas is
  Select * 
    from fsr008  x,
         aqpa106 y 
   where x.pepais = y.aqpa106pai
     and x.petdoc = y.aqpa106tpo
     and x.pendoc = y.aqpa106num
     and y.aqpa106est = 'A'
     and x.pgcod = 1 
     and x.ctnro = P_N_NUMCTA
     and x.ttcod = 1
     and x.cttfir = 'T';    
     
  /*
  cursor c_celulares(ln_pais in number, ln_tipdoc in number, lv_numdoc in varchar2, lv_tipo in varchar2) is
  select ww.* 
    from (
          select t.doordp,t.dotelfp
           from FSR005 t,
                sngc17 a 
          where a.sngc17pais = t.pepais
            and a.sngc17tdoc = t.petdoc
            and a.sngc17ndoc = t.pendoc
            and a.sngc17dcod = t.docod   
            and a.sngc17corr = t.doordp   
            and t.pepais = ln_pais
            and t.petdoc = ln_tipdoc
            and t.pendoc = rpad(lv_numdoc,12,' ')
            and pq_ah_enviodigital.fn_ah_valida_celular(TRIM(t.dotelfp),1) = 'S'
            and t.docod in (Select x.tp1nro1
                              from fst198 x
                             where x.tp1cod   = 1
                               and x.tp1cod1  = 10825
                               and x.tp1corr1 = 126
                               and x.tp1corr2 = 5
                            )
           --and FN_AH_CONCEL(t.pepais,t.petdoc,t.pendoc,t.dotelfp) = lv_tipo 
           and pq_cl_alertas.FN_AH_CONCEL(t.pepais,t.petdoc,t.pendoc) = to_number(trim(t.dotelfp))
           order by t.doordp desc
         ) ww where rownum =1;    
          */                            
  cursor c_mensaje(ln_codale in number) is
    Select x.tp1desc
      from fst198 x
     where x.tp1cod   = 1
       and x.tp1cod1  = 10825
       and x.tp1corr1 = 126
       and x.tp1corr2 = ln_codale
  order by x.tp1corr3;
    
  cursor c_prioridad is 
    Select upper(Substr(trim(x.tp1desc),1,1)) tipo,
           x.tp1nro1 flag
      from fst198 x
     where x.tp1cod   = 1
       and x.tp1cod1  = 10825
       and x.tp1corr1 = 126
       and x.tp1corr2 = 6;                                     
begin 
--buscamos todos los integrantes de la cuenta cliente
for i in c_personas loop   
  --DATOS PARA LA AFILIACI�N  
  BEGIN        
   select trim(upper(x.pfape1))||' '||trim(upper(x.pfape2))||' , '||trim(upper(x.pfnom1))||' '||trim(upper(x.pfnom2)),
          decode(x.Pfcant,null,'M',x.Pfcant),
          trim(upper(x.pfnom1))
     into lc_nombre,
          lc_sexo,
          lv_prinom
     from fsd002 x 
    where x.pfpais = i.pepais 
      and x.pftdoc = i.petdoc  
      and x.pfndoc = i.pendoc;                    
  EXCEPTION  
  WHEN OTHERS THEN
    lc_nombre := null;
    lc_sexo := null;
    lv_prinom := null;
  END;                                  
  --
  --ELIMINAMOS AFILIACIONES ANTERIORES
  --
  begin
    delete from ichannelalert.CLIENTES_AFILIADOS where codigo_cliente like trim(to_char(P_N_CODALE))||'A@'||lpad(trim(to_char(i.pendoc)),12,'0')||'%';
    COMMIT;
  exception
  when others then
    null;  
  end;
  --
  --afiliamos a ichannel       
  --          
  For z in c_mensaje(P_N_CODALE) loop
    lv_msg := lv_msg || z.tp1desc;
  End loop;
  lv_msg := trim(replace(lv_msg,'#NOMBRE',lv_prinom));          
  lv_msg := trim(replace(lv_msg,'#ANALISTA',trim(P_C_VAAUX1)));    
  lv_msg := trim(replace(lv_msg,'#CORREO',trim(P_C_VAAUX2)));    
  lv_msg := trim(replace(lv_msg,'#CELULAR',trim(P_C_VAAUX3)));      

  ln_cont := 0;          
  For w in c_prioridad loop
    if ln_cont = 0 or w.flag = 1 then
        ln_celular:= to_number(trim(pq_cl_alertas.FN_AH_CONCEL(i.pepais,i.petdoc,i.pendoc))); 
        --For k in c_celulares(i.pepais,i.petdoc,i.pendoc,w.tipo) loop
        if ln_celular is not null then
           BEGIN                          
                INSERT INTO ichannelalert.CLIENTES_AFILIADOS(codigo_cliente,
                                                        nombre_cliente,
                                                        mail_cliente,
                                                        celular_cliente,
                                                        sexo_cliente,
                                                        enviar_celular,
                                                        enviar_mail)
                                                 values(trim(to_char(P_N_CODALE))||'A@'||lpad(trim(to_char(i.pendoc)),12,'0')||lpad(trim(to_char(ln_celular)),9,'0'),--DNI + CELULAR
                                                        lc_nombre,
                                                        '',
                                                        ln_celular,
                                                        lc_sexo,
                                                        'S',
                                                        'N'
                                                        );
           EXCEPTION
           WHEN OTHERS THEN  
                null;
           END;  
           --REGISTRAMOS EN TABLA PARA ENVI� DEL MENSAJE
           BEGIN
                   INSERT INTO AQPA142(AQPA142TIM,
                                       AQPA142FEC,
                                       AQPA142PAI,
                                       AQPA142TIP,
                                       AQPA142DOC,
                                       AQPA142CEL,
                                       AQPA142HOR,
                                       AQPA142MSG,
                                       aqpa142prd,
                                       aqpa142des,
                                       aqpa142uso
                                       ) 
                                VALUES(P_N_CODALE,
                                       P_D_FECPRO,
                                       i.pepais,
                                       i.petdoc,
                                       i.pendoc,
                                       ln_celular,
                                       to_char(sysdate,'HH24:mi:ss'),
                                       substr(lv_msg,1,160),
                                       P_C_TIPPRO,
                                       P_C_CANAL, 
                                       P_C_CODUSU                                   
                                       );
           EXCEPTION
           WHEN OTHERS THEN
             null;
           END; 
           ln_cont := ln_cont + 1;  
           commit;  
        end if;
        --End loop; 
    End If;
  End loop; 
End Loop;
exception
when others then
  null;
end sp_cl_alertas_cre;                            
procedure sp_cl_genera_ren is
  cursor c_renova(ln_dias in number) is
  select distinct 
         x.pgcod,
         x.aocta
    from fsd010 x
   where x.pgcod = 1
     and x.aomod = 22
     and x.aosbop > 0
     and x.aostat <> 99
     and x.aofval = trunc(sysdate - ln_dias);
   
  lc_msgerr     VARCHAR2(400);
  ln_dias       number(9):=0;
  lv_indper     char(1):='';
begin  
    update schedulers g
       set g.d_fecini = sysdate
     where g.n_numer1 = 1
       and g.c_codage = 'REN';--RENOVACIONES
    commit;
     
  begin
    Select x.tp1nro1 
      into ln_dias
      from fst198 x
     where x.tp1cod   = 1
       and x.tp1cod1  = 10825
       and x.tp1corr1 = 126
       and x.tp1corr2 = 9;        
  Exception
  When others then     
    ln_dias := 0;
  end;
  for i in c_renova(ln_dias) loop
      
    PQ_AH_NEW_COMISION.sp_ah_tipper(P_N_CODPGC => i.pgcod,
                                    P_N_NUMCTA => i.aocta,
                                    p_c_codval => lv_indper
                                    );
    if lv_indper = 'F' then                                  
      -- Call the procedure
      PQ_CL_ALERTAS.sp_cl_alertas_cre(P_N_CODALE => 13,
                                      P_N_NUMCTA => i.aocta,
                                      P_D_FECPRO => trunc(sysdate),
                                      P_C_TIPPRO => 'A',
                                      P_C_CANAL  => 'VENTANILLA',
                                      P_C_CODUSU => 'BANTOTAL',
                                      P_C_VAAUX1 => NULL,
                                      P_C_VAAUX2 => NULL,
                                      P_C_VAAUX3 => NULL
                                      );
    end if;                                  
  end loop;
  
    update schedulers g
       set g.d_fecfin = sysdate
     where g.n_numer1 = 1
       and g.c_codage = 'REN';
    commit;                              
exception
when others then  
  lc_msgerr := sqlerrm;
  update schedulers g
     set g.c_inderr = 'S', g.c_deserr = lc_msgerr
   where g.n_numer1 = 1
     and g.c_codage = 'REN';
  commit;                           
end sp_cl_genera_ren;    
Function FN_AH_CONCEL(P_N_PAIS   IN NUMBER,
                      P_N_TIPDOC IN NUMBER,
                      P_C_NUMDOC IN VARCHAR2    
                     ) return number is
   -- *****************************************************************
    -- Nombre                     : FN_AH_CONCEL
    -- Sistema                    : BANTOTAL
    -- M�dulo                     : Ahorros - Pasivas
    -- Versi�n                    : 1.0
    -- Fecha de Creaci�n          : 10/06/2025
    -- Autor de Creaci�n          : Yrving Lozada Bustamante
    -- Uso                        : Consulta un celular si esta validado o no de acuerdo a la guia parametrizada
    -- Estado                     : Activo
    -- Acceso                     : P�blico
    -- Par�metros de Entrada      : 
    --
    -- Retorno                    : 
    -- Fecha de Modificaci�n      : 
    -- Autor de la Modificaci�n   : 
    -- Descripci�n de Modificaci�n: 
    -- *****************************************************************                                        

  LN_NUMCEL NUMBER(9) := NULL;
  begin
    begin --si esta afiliado a canales digitales
        select to_number(trim(a.jaqz205celul))
          into LN_NUMCEL
          from JAQZ205 a,
               Z0E478  b
         where a.jaqz205nutar = b.z0e478nro
           and b.z0e478thp = P_N_PAIS
           and b.z0e478tht = P_N_TIPDOC
           and b.z0e478thd = RPAD(P_C_NUMDOC,12,' ')
           and b.z0e463cod in (1,7)  -- tj activ
           and a.jaqz205estok > 0
           and rownum = 1;     
    exception
    when no_data_found then  
        begin --si tiene celular x campa�a         
          select to_number(trim(z.AQPA105NEW))
            into LN_NUMCEL
            from (
                select TO_NUMBER(TRIM(A.AQPA105NEW)) AQPA105NEW,a.AQPA105FEC 
                  from aqpa105 a
                 where a.aqpa105tpo = 2 
                   and a.AQPA105PAI = P_N_PAIS
                   and a.AQPA105TIP = P_N_TIPDOC
                   and a.AQPA105NUM = RPAD(P_C_NUMDOC,65,' ')
              order by a.AQPA105FEC desc
                 ) z
            where rownum = 1;
        exception 
        when no_data_found then  
          begin--si tiene celular validado
            select to_number(trim(z.jaqn2atelf)) 
              into LN_NUMCEL  
              from (   
                  select x.jaqn2atelf,x.jaqn2afeg 
                    from jaqn2a x, 
                         jaqn3a y
                   where x.jaqn2apai  = y.jaqn3apai
                     and x.jaqn2atdoc = y.jaqn3atdoc
                     and x.jaqn2andoc = y.jaqn3andoc
                     and x.jaqn2acor  = y.jaqn3acor
                     and x.jaqn2afeg  = y.jaqn3afeg
                     and x.jaqn2atipv = y.jaqn3atipv
                     and y.jaqn3avig  = 'S'
                     and x.jaqn2apai  = P_N_PAIS
                     and x.jaqn2atdoc = P_N_TIPDOC
                     and x.jaqn2andoc = RPAD(P_C_NUMDOC,12,' ')
                     and trim(x.jaqn2atelf) is not null
                order by x.jaqn2afeg desc
                   ) z
             where rownum = 1;            
          exception
          when no_data_found then
            begin --el ultimo celular x correlativo
              select to_number(trim(w.dotelfp))
                into LN_NUMCEL 
                from (
                      select x.* 
                        from fsr005  x 
                       where x.pepais = P_N_PAIS 
                         and x.petdoc = P_N_TIPDOC 
                         and x.pendoc = RPAD(P_C_NUMDOC,12,' ')
                         and PQ_AH_ENVIODIGITAL.fn_ah_valida_celular(trim(x.dotelfp),1) = 'S'
                         and x.docod in (Select x.tp1nro1
                                           from fst198 x
                                          where x.tp1cod   = 1
                                            and x.tp1cod1  = 10825
                                            and x.tp1corr1 = 126
                                            and x.tp1corr2 = 5
                                         )
                    order by x.doordp desc
                   ) w 
              where rownum = 1;
            exception 
            when others then  
              LN_NUMCEL := null; 
            end;
          when others then   
            LN_NUMCEL := null; 
          end;
        when others then   
          LN_NUMCEL := null; 
        end; 
     when others then
      LN_NUMCEL := null;    
     end;                     
     return LN_NUMCEL;
exception
when others then
  LN_NUMCEL := NULL;
  return LN_NUMCEL;
end FN_AH_CONCEL;       
Procedure SP_AH_MAIL(P_N_PAIS   IN NUMBER,
                     P_N_TIPDOC IN NUMBER,
                     P_C_NUMDOC IN VARCHAR2,    
                     p_c_correo out varchar2
                    ) is    
   -- *****************************************************************
    -- Nombre                     : SP_AH_MAIL
    -- Sistema                    : BANTOTAL
    -- M�dulo                     : Ahorros - Pasivas
    -- Versi�n                    : 1.0
    -- Fecha de Creaci�n          : 10/06/2025
    -- Autor de Creaci�n          : Yrving Lozada Bustamante
    -- Uso                        : Consulta un mail si esta validado o no de acuerdo a la guia parametrizada
    -- Estado                     : Activo
    -- Acceso                     : P�blico
    -- Par�metros de Entrada      : 
    --
    -- Retorno                    : 
    -- Fecha de Modificaci�n      : 
    -- Autor de la Modificaci�n   : 
    -- Descripci�n de Modificaci�n: 
    -- *****************************************************************                       
  ln_nummai  number(9):=0;
begin
    begin
    select count(distinct lower(trim(substr(x.pextxt,1,instr(x.pextxt,'\')-1))))
      into ln_nummai 
      from fsx001 x 
     where x.pepais = P_N_PAIS   
       and x.petdoc = P_N_TIPDOC
       and x.pendoc = rpad(P_C_NUMDOC,12,' ')
       and x.txcod = 0
       and trim(x.pextxt) is not null
       and pq_ah_enviodigital.fn_ah_valida_mail(trim(substr(x.pextxt,1,instr(x.pextxt,'\')-1))) = 'S';           
   Exception
   When others then       
     ln_nummai := 0;
   End;
   
   if ln_nummai = 0 then
      p_c_correo := null;      
   Else
        begin--el log mas actual de campa�a
          select trim(lower(z.AQPA105NEW))
            into p_c_correo
            from (
                select TRIM(A.AQPA105NEW) AQPA105NEW,a.AQPA105FEC 
                  from aqpa105 a
                 where a.aqpa105tpo = 1 
                   and a.AQPA105PAI = P_N_PAIS
                   and a.AQPA105TIP = P_N_TIPDOC
                   and a.AQPA105NUM = RPAD(P_C_NUMDOC,65,' ')
              order by a.AQPA105FEC desc
                 ) z
            where rownum = 1;  
        Exception
        When no_data_found then
          begin--el ultimo validado
            select trim(lower(z.jaqn2acorr))
              into p_c_correo
              from (   
                  select x.jaqn2acorr,x.jaqn2afeg
                    from jaqn2a x, 
                         jaqn3a y
                   where x.jaqn2apai  = y.jaqn3apai
                     and x.jaqn2atdoc = y.jaqn3atdoc
                     and x.jaqn2andoc = y.jaqn3andoc
                     and x.jaqn2acor  = y.jaqn3acor
                     and x.jaqn2afeg  = y.jaqn3afeg
                     and x.jaqn2atipv = y.jaqn3atipv
                     and y.jaqn3avig  = 'S'
                     and x.jaqn2apai  = P_N_PAIS
                     and x.jaqn2atdoc = P_N_TIPDOC
                     and x.jaqn2andoc = RPAD(P_C_NUMDOC,12,' ')
                     and trim(x.jaqn2acorr) is not null
                order by x.jaqn2afeg desc
                   ) z
             where rownum = 1; 
          exception
          When no_data_found then 
            begin
              select trim(lower(w.pextxt)) 
                into p_c_correo              
                from (
                      select distinct lower(trim(substr(x.pextxt,1,instr(x.pextxt,'\')-1))) pextxt,x.pexfch
                        from fsx001 x 
                       where x.pepais = P_N_PAIS   
                         and x.petdoc = P_N_TIPDOC
                         and x.pendoc = rpad(P_C_NUMDOC,12,' ')
                         and x.txcod = 0
                         and trim(x.pextxt) is not null
                         and pq_ah_enviodigital.fn_ah_valida_mail(trim(substr(x.pextxt,1,instr(x.pextxt,'\')-1))) = 'S'
                    order by x.pexfch desc
                     ) w
               where rownum = 1;                 
            Exception
            when others then  
              p_c_correo := null;                   
            end;
          When others then
            p_c_correo := null;           
          end; 
        When others then
          p_c_correo := null;         
        End;                     
   End If;     
exception
when others then
  p_c_correo := null;        
end SP_AH_MAIL;    

PROCEDURE SP_CR_DESHAB_ENVIO_TIPOMSG(P_AQPA142TIM NUMBER, O_FLG_DESHABILT OUT VARCHAR2) IS
BEGIN
   BEGIN
      SELECT 'S' INTO O_FLG_DESHABILT  FROM FST198 WHERE 
      Tp1cod = 1           AND  
      Tp1cod1 = 11152      AND
      Tp1corr1 =  312 AND
      Tp1corr2 = 1 AND
      Tp1corr3 > 0 AND
      TP1NRO1 = P_AQPA142TIM ;
   EXCEPTION
     WHEN OTHERS THEN
       O_FLG_DESHABILT := 'N';   
   END;
   
   O_FLG_DESHABILT := NVL(O_FLG_DESHABILT, 'N');

EXCEPTION
WHEN OTHERS THEN
  NULL;  
END;


                             
end PQ_CL_ALERTAS;
/
