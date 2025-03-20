create or replace package PQ_CL_ALERTAS is

  -- *****************************************************************
  -- Nombre                     : PQ_CL_ALERTAS
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Pasivas 
  -- Versión                    : 1.0
  -- Fecha de Creación          : 28/04/2023 14:57:31
  -- Autor de Creación          : Yrving Lozada
  -- Uso                        : Mensajes Servicio al CLiente
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Parámetros de Entrada      :
  -- Fecha de Modificación      : 25/01/2024 Se actualizó campo de mensaje
  -- Fecha de Modificación      : 08/04/2024 Se crearon nuevas alertas de creditos
  -- Autor de Modificación      : Yrving Lozada
  -- Fecha de Modificación      : 19/07/2024 Se afinaron alertas y se adicionó control de datos personales
  -- Autor de Modificación      : Yrving Lozada  
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
                                comments   => 'AFILIACIÓN CUMPLEAÑOS CLIENTES');
    
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
                                comments   => 'AFILIACIÓN RENOVACIONES DPF CLIENTES');
    
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
           and FN_AH_CONCEL(t.pepais,t.petdoc,t.pendoc,t.dotelfp) = lv_tipo /*in  (Select upper(Substr(trim(x.tp1desc),1,1))
                                                                        from fst198 x
                                                                       where x.tp1cod   = 1
                                                                         and x.tp1cod1  = 10825
                                                                         and x.tp1corr1 = 126
                                                                         and x.tp1corr2 = 6
                                                                      )*/
           order by t.doordp desc
         ) ww where rownum = 1;                                                                          

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
       and g.c_codage = 'CUM';--CUMPLEAÑOS
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
          --DATOS PARA LA AFILIACIÓN  
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
                For k in c_celulares(i.pepais,i.petdoc,i.pendoc,w.tipo) loop
                   BEGIN                          
                        INSERT INTO ichannelalert.CLIENTES_AFILIADOS(codigo_cliente,
                                                                nombre_cliente,
                                                                mail_cliente,
                                                                celular_cliente,
                                                                sexo_cliente,
                                                                enviar_celular,
                                                                enviar_mail)
                                                         values('C@'||lpad(trim(to_char(i.pendoc)),12,'0')||lpad(trim(to_char(k.dotelfp)),9,'0'),--DNI + CELULAR
                                                                lc_nombre,
                                                                '',
                                                                to_number(trim(k.dotelfp)),
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
                   --REGISTRAMOS EN TABLA PARA ENVIÓ DEL MENSAJE
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
                                       k.dotelfp,
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
                End loop; 
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
    union
    Select a.scfcon aofval
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
       and a.scmod = 122
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
  order by 1;  
  
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
           and FN_AH_CONCEL(t.pepais,t.petdoc,t.pendoc,t.dotelfp) = lv_tipo /*in  (Select upper(Substr(trim(x.tp1desc),1,1))
                                                                        from fst198 x
                                                                       where x.tp1cod   = 1
                                                                         and x.tp1cod1  = 10825
                                                                         and x.tp1corr1 = 126
                                                                         and x.tp1corr2 = 6
                                                                      )*/
           order by t.doordp desc
         ) ww where rownum = 1;                                                                    
                                       
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
         End If;
         
         if ln_cont = 2 then
            ld_fecseg := j.scfval;           
            if ld_fecseg = P_D_FECPRO then --es su 2do producto
               ld_fecseg:= P_D_FECPRO; 
            Else
               ld_fecseg := j.scfval;              
            End If;
         End If;
         
         if ln_cont = 3 then
            ld_fecter := j.scfval;           
            if ld_fecter = P_D_FECPRO then --es su 3er producto
               ld_fecter:= P_D_FECPRO; 
            Else
               ld_fecter := j.scfval;              
            End If;
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
      if ld_fecpri = P_D_FECPRO then
          ln_tipo := 1;        
          For z in c_mensaje(ln_tipo) loop
            lv_msg := lv_msg || z.tp1desc;
          End loop;
      End If;
      if ld_fecseg = P_D_FECPRO then
          ln_tipo := 2;        
          For z in c_mensaje(ln_tipo) loop
            lv_msg := lv_msg || z.tp1desc;
          End loop;
      End If;
      if ld_fecter = P_D_FECPRO then
          ln_tipo := 3;        
          For z in c_mensaje(ln_tipo) loop
            lv_msg := lv_msg || z.tp1desc;
          End loop;
      End If;
      
      --SOLO SI APLICA PARA ALGUN PRODUCTO AFILIAMOS
      IF ln_tipo > 0 THEN
          --DATOS PARA LA AFILIACIÓN  
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
              For k in c_celulares(i.pepais,i.petdoc,i.pendoc,w.tipo) loop
                 BEGIN                          
                      INSERT INTO ichannelalert.CLIENTES_AFILIADOS(codigo_cliente,
                                                              nombre_cliente,
                                                              mail_cliente,
                                                              celular_cliente,
                                                              sexo_cliente,
                                                              enviar_celular,
                                                              enviar_mail)
                                                       values('A@'||lpad(trim(to_char(i.pendoc)),12,'0')||lpad(trim(to_char(k.dotelfp)),9,'0'),--DNI + CELULAR
                                                              lc_nombre,
                                                              '',
                                                              to_number(trim(k.dotelfp)),
                                                              lc_sexo,
                                                              'S',
                                                              'N'
                                                              );
                 EXCEPTION
                 WHEN OTHERS THEN  
                   null;
                 END;  
                 --REGISTRAMOS EN TABLA PARA ENVIÓ DEL MENSAJE
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
                                       k.dotelfp,
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
              End loop;
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
           and FN_AH_CONCEL(t.pepais,t.petdoc,t.pendoc,t.dotelfp) = lv_tipo /*in  (Select upper(Substr(trim(x.tp1desc),1,1))
                                                                        from fst198 x
                                                                       where x.tp1cod   = 1
                                                                         and x.tp1cod1  = 10825
                                                                         and x.tp1corr1 = 126
                                                                         and x.tp1corr2 = 6
                                                                      )*/
          order by t.doordp desc
         ) ww where rownum =1;    
                                       
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
  --DATOS PARA LA AFILIACIÓN  
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
        For k in c_celulares(i.pepais,i.petdoc,i.pendoc,w.tipo) loop
           BEGIN                          
                INSERT INTO ichannelalert.CLIENTES_AFILIADOS(codigo_cliente,
                                                        nombre_cliente,
                                                        mail_cliente,
                                                        celular_cliente,
                                                        sexo_cliente,
                                                        enviar_celular,
                                                        enviar_mail)
                                                 values(trim(to_char(P_N_CODALE))||'A@'||lpad(trim(to_char(i.pendoc)),12,'0')||lpad(trim(to_char(k.dotelfp)),9,'0'),--DNI + CELULAR
                                                        lc_nombre,
                                                        '',
                                                        to_number(trim(k.dotelfp)),
                                                        lc_sexo,
                                                        'S',
                                                        'N'
                                                        );
           EXCEPTION
           WHEN OTHERS THEN  
                null;
           END;  
           --REGISTRAMOS EN TABLA PARA ENVIÓ DEL MENSAJE
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
                                       k.dotelfp,
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
        End loop; 
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
                        
end PQ_CL_ALERTAS;
/

