create or replace package pq_cl_clean_ichannel is

   -- *****************************************************************
    -- Nombre                     : pq_cl_clean_ichannel
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Ahorros - Pasivas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 01/04/2024
    -- Autor de Creación          : Yrving Lozada Bustamante
    -- Uso                        : Limpieza Tabla ichannel
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    --
    -- Retorno                    : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- ***************************************************************** 
  Procedure sp_cl_lanza_job;
  Procedure sp_cl_limpia_afi(P_C_DIGITO1 IN VARCHAR2,
                             P_C_DIGITO2 IN VARCHAR2,
                             ln_ini      in number
                            );
end pq_cl_clean_ichannel;
/

create or replace package body pq_cl_clean_ichannel is
  Procedure sp_cl_lanza_job is
       cursor c_job is               
       select  /*+PARALLEL(x,4)*/
              SUBSTR(trim(substr(x.codigo_cliente,1,9)), -1, 1) C_DIGITO1,
              SUBSTR(trim(substr(x.codigo_cliente,1,9)), -2, 1) C_DIGITO2
         from ichannelalert.clientes_afiliados x
        where (x.enviar_celular = 'S' or x.enviar_mail = 'S')
          and ((length(trim(x.codigo_cliente)) = 20 and
              substr(trim(x.codigo_cliente), 10, 3) = '021') or
              (length(trim(x.codigo_cliente)) = 27 and
              substr(trim(x.codigo_cliente), 10, 3) = '022'))
     GROUP BY SUBSTR(trim(substr(x.codigo_cliente,1,9)), -1, 1), 
              SUBSTR(trim(substr(x.codigo_cliente,1,9)), -2, 1);    --1,392,823
           
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
                       '  pq_cl_clean_ichannel.sp_cl_limpia_afi(' || '''' ||
                       job.C_DIGITO1 || '''' || ',' || '''' || job.C_DIGITO2 || '''' || ',' ||
                       ln_ini || ');' || ' End; ';
        ln_job      := ln_job + 1;
      
        dbms_scheduler.create_job(job_name   => 'CLE_ICHANNEL' ||
                                                LPAD(TO_CHAR(ln_job), 5, '0'),
                                  job_type   => 'PLSQL_BLOCK',
                                  job_action => lc_variable,
                                  start_date => sysdate + 1 / (24 * 180),
                                  enabled    => true,
                                  auto_drop  => TRUE,
                                  comments   => 'LIMPIA TABLA DE ICHANNEL');
      
        INSERT INTO Schedulers
          (c_codage, n_Numer1, c_detjob)
        VALUES
          ('CLE', ln_ini, lc_variable);
        COMMIT;      
      end loop;          
  exception
  when others then
   null; 
  end sp_cl_lanza_job;
  procedure sp_cl_limpia_afi(P_C_DIGITO1 IN VARCHAR2,
                               P_C_DIGITO2 IN VARCHAR2,
                               ln_ini      in number
                               ) is
    lc_msgerr     VARCHAR2(400);  
    ln_cel        number(1):=0;
    ln_mail       number(1):=0;
    lv_cel        char(20):='';
    lv_mail       char(65):='';
    ln_pgcod      number(3);
    ln_scsuc      number(3);
    ln_scmda      number(4);
    ln_scpap      number(4);
    ln_sccta      number(9);
    ln_scoper     number(9);
    ln_scsbop     number(3);
    ln_sctope     number(3);
    ln_scmod      number(3);
          
    cursor c_productos(P_C_DIGITO1 in varchar2,P_C_DIGITO2 in varchar2) is  
       select  /*+PARALLEL(x,4)*/
              x.* 
         from ichannelalert.clientes_afiliados x
        where (x.enviar_celular = 'S' or x.enviar_mail = 'S')
          and ((length(trim(x.codigo_cliente)) = 20 and
              substr(trim(x.codigo_cliente), 10, 3) = '021') or
              (length(trim(x.codigo_cliente)) = 27 and
              substr(trim(x.codigo_cliente), 10, 3) = '022'))
          and SUBSTR(trim(substr(x.codigo_cliente,1,9)), -1, 1) = P_C_DIGITO1
          and SUBSTR(trim(substr(x.codigo_cliente,1,9)), -2, 1) = P_C_DIGITO2;
                                   
  begin         
      update schedulers g
         set g.d_fecini = sysdate
       where g.n_numer1 = ln_ini
         and g.c_codage = 'CLE';--LIMPIA
      commit;                        
      
      --buscamos todos los integrantes de la cuenta cliente
      for i in c_productos(P_C_DIGITO1,P_C_DIGITO2) loop          
        if i.enviar_celular = 'S' then
          --validamos celular
          begin
            select 1 
              into ln_cel   --LN_CEL = 1 --CELULAR CORRECTO
              from fsr008 a,
                   fsr005 b
            where a.pgcod = 1
              and a.pepais = b.pepais
              and a.petdoc = b.petdoc
              and a.pendoc = b.pendoc
              and a.ttcod = 1
              and a.cttfir = 'T'
              and a.ctnro = to_number(substr(i.CODIGO_CLIENTE,1,9))
              and b.dotelfp = rpad(to_char(trim(i.celular_cliente)),20,' ')       
              and rownum < 2; 
              
              lv_cel := i.celular_cliente;       
          exception
          when others then
            ln_cel := 0;  --NO ES CORRECTO EL CELULAR SE BUSCA UNO CORRECTO
            begin
              select distinct 
                     b.dotelfp  
                into lv_cel
                from fsr008 a,
                     fsr005 b
              where a.pgcod = 1
                and a.pepais = b.pepais
                and a.petdoc = b.petdoc
                and a.pendoc = b.pendoc
                and a.ttcod = 1
                and a.cttfir = 'T'
                and a.ctnro = to_number(substr(i.CODIGO_CLIENTE,1,9))
                and pq_ah_enviodigital.fn_ah_valida_celular(trim(b.dotelfp),1) = 'S'    
                and rownum < 2;    
            exception
            when others then              
              ln_cel := -1; --NO REGISTRA CELULARES 
              lv_cel := i.celular_cliente;  
            end;               
          end;
        Else
          ln_cel := 1; --NO SE HACE NADA PORQUE TODO ESTA OK
          lv_cel := i.celular_cliente;
        End if;
        
        if i.enviar_mail = 'S' then
          --validamos mail
          begin
            Select 1
              into ln_mail     --ln_mail = 1 MAIL CORRECTO
              from fsr008 a,
                   fsx001 b
             where a.pgcod = 1
               and a.ctnro = to_number(substr(i.CODIGO_CLIENTE,1,9))
               and a.pepais = b.pepais
               and a.petdoc = b.petdoc
               and a.pendoc = b.pendoc
               and a.ttcod  = 1
               and a.cttfir = 'T'
               and b.txcod = 0
               and trim(b.pextxt) is not null
               and upper(trim(substr(b.pextxt,1,instr(b.pextxt,'\')-1))) = upper(TRIM(i.mail_cliente))
               and rownum < 2 ;    
               
               lv_mail := i.mail_cliente;             
          exception
          when others then
            ln_mail := 0;  
            begin
              Select distinct trim(substr(b.pextxt,1,instr(b.pextxt,'\')-1))
                into lv_mail     --ln_mail = 1 MAIL CORRECTO
                from fsr008 a,
                     fsx001 b
               where a.pgcod = 1
                 and a.ctnro = to_number(substr(i.CODIGO_CLIENTE,1,9))
                 and a.pepais = b.pepais
                 and a.petdoc = b.petdoc
                 and a.pendoc = b.pendoc
                 and a.ttcod  = 1
                 and a.cttfir = 'T'
                 and b.txcod = 0
                 and trim(b.pextxt) is not null
                 and pq_ah_enviodigital.fn_ah_valida_mail(trim(substr(b.pextxt,1,instr(b.pextxt,'\')-1))) = 'S'
                 and rownum < 2 ;             
            exception
            when others then
              ln_mail := -1;    --NO REGISTRA CORREOS
              lv_mail := i.mail_cliente;   
            end;    
          end; 
        Else
          ln_mail := 1; --NO SE HACE NADA PORQUE TODO ESTA OK    
          lv_mail := i.mail_cliente;          
        End if;
        --ANALIZAMOS LO ENCONTRADO
            If ln_cel <> 1 or ln_mail <> 1 then  

                begin
                  insert into aqpa148(aqpa148cue,
                                      aqpa148cea,
                                      aqpa148cen,
                                      aqpa148maa,
                                      aqpa148man                                                 
                                      )
                               values(i.codigo_cliente,
                                      i.celular_cliente,
                                      decode(ln_cel,-1,null,0,trim(lv_cel),trim(lv_cel)),                                           
                                      i.mail_cliente,
                                      decode(ln_mail,-1,null,0,trim(lv_mail),trim(lv_mail))                                           
                                      );     
                                      commit;
                Exception                                                                                            
                when others then                                                                       
                  null; 
                end;
              if (trim(i.celular_cliente) <> trim(lv_cel)) or (upper(trim(i.mail_cliente)) <> upper(trim(lv_mail))) then              
                --ACTUALIZAMOS TABLA DE AFILIACION EN BANTOTAL
                if length(trim(i.codigo_cliente)) = 20 then
                  begin
                    select x.pgcod,
                           x.scsuc,
                           x.scmda,
                           x.scpap,
                           x.sccta,
                           x.scoper,
                           x.scsbop,
                           x.sctope,
                           x.scmod
                      into ln_pgcod,
                           ln_scsuc,
                           ln_scmda,
                           ln_scpap,
                           ln_sccta,
                           ln_scoper,
                           ln_scsbop,
                           ln_sctope,
                           ln_scmod
                      from fsd011 x 
                     where x.pgcod  = 1 
                       and x.scmda  = to_number(substr(i.CODIGO_CLIENTE,13,3)) 
                       and x.scpap  = 0 
                       and x.sccta  = to_number(substr(i.CODIGO_CLIENTE,1,9))
                       and x.scoper = 0 
                       and x.scsbop = to_number(substr(i.CODIGO_CLIENTE,16,2)) 
                       and x.sctope = to_number(substr(i.CODIGO_CLIENTE,18,3)) 
                       and x.scmod  = 21;  
                  exception
                  when others then  
                    ln_pgcod := 0;   
                    ln_scsuc := 0;     
                    ln_scmda := 0;  
                    ln_scpap := 0;  
                    ln_sccta := 0;  
                    ln_scoper:= 0;  
                    ln_scsbop:= 0;  
                    ln_sctope:= 0;  
                    ln_scmod := 0;  
                  end;
                Else
                  begin
                   select x.pgcod,
                           x.scsuc,
                           x.scmda,
                           x.scpap,
                           x.sccta,
                           x.scoper,
                           x.scsbop,
                           x.sctope,
                           x.scmod
                      into ln_pgcod,
                           ln_scsuc,
                           ln_scmda,
                           ln_scpap,
                           ln_sccta,
                           ln_scoper,
                           ln_scsbop,
                           ln_sctope,
                           ln_scmod
                      from fsd011 x 
                     where x.pgcod  = 1 
                       and x.scmda  = to_number(substr(i.CODIGO_CLIENTE,13,3)) 
                       and x.scpap  = 0 
                       and x.sccta  = to_number(substr(i.CODIGO_CLIENTE,1,9))
                       and x.scoper = to_number(substr(i.CODIGO_CLIENTE,16,9)) 
                       and x.sctope = to_number(substr(i.CODIGO_CLIENTE,25,3)) 
                       and x.scmod  = 22;                                                        
                  exception
                  when others then  
                    ln_pgcod := 0;   
                    ln_scsuc := 0;     
                    ln_scmda := 0;  
                    ln_scpap := 0;  
                    ln_sccta := 0;  
                    ln_scoper:= 0;  
                    ln_scsbop:= 0;  
                    ln_sctope:= 0;  
                    ln_scmod := 0;  
                  end;                
                End If;  
              

                begin
                 UPDATE JAQY660
                      SET JAQY660FCH = trunc(sysdate),
                          JAQY660USU = 'BANTOTAL',           
                          JAQY660AUX1 = to_number(trim(lv_cel)),
                          JAQY660AFI = lv_mail,
                          JAQY660HRA = TO_CHAR(sysdate,'HH24:mi:ss'),
                          JAQY660SAF = 904                  
                    WHERE JAQY660TIP = 'T'
                      AND JAQY660PGO = ln_pgcod
                      AND JAQY660SUC = ln_scsuc
                      AND JAQY660MOD = ln_scmod
                      AND JAQY660MDA = ln_scmda
                      AND JAQY660CTA = ln_sccta
                      AND JAQY660PAP = ln_scpap
                      AND JAQY660OPE = ln_scoper
                      AND JAQY660SUB = ln_scsbop
                      AND JAQY660TOP = ln_sctope; 
                      commit;               
                exception
                when others then
                  null;
                end;
                --
                --UPDATE CORREO Y CELULAR
                --
                begin
                  update ichannelalert.CLIENTES_AFILIADOS c
                     set c.celular_cliente = trim(lv_cel),
                         c.mail_cliente    = trim(lv_mail)
                   where c.codigo_cliente = i.codigo_cliente;
                   commit;
                exception
                when others then
                  null;  
                end; 
              End If;                
            End If;                  
      end loop;    
      commit;
      
      update schedulers g
         set g.d_fecfin = sysdate
       where g.n_numer1 = ln_ini
         and g.c_codage = 'CLE';
      commit;                               
  exception
  when others then  
    lc_msgerr := sqlerrm;
    update schedulers g
       set g.c_inderr = 'S', g.c_deserr = lc_msgerr
     where g.n_numer1 = ln_ini
       and g.c_codage = 'CLE';
    commit;
  end sp_cl_limpia_afi;
end pq_cl_clean_ichannel;
/

