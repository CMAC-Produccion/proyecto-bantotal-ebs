create or replace package PQ_MIGRA_PERSONAS_CREDINKA_II is
    -- *****************************************************************   
    -- Nombre                     : PQ_MIGRA_PERSONAS_LUREN_II
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Ahorros - Pasivas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 26/11/2024
    -- Autor de Creación          : Yrving Lozada Bustamante
    -- Uso                        : Bandejas personas
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : 
    -- Retorno                    : 
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************   
  Procedure sp_MGM_ctacliente;
  Procedure sp_valida_ctacliente(P_N_PAIS    IN NUMBER,
                                 P_N_TIPO    IN NUMBER,
                                 P_C_NUMERO  IN VARCHAR2,
                                 P_C_CADENA  IN VARCHAR2,
                                 P_C_TIPO    IN VARCHAR2,
                                 P_C_EXISTE  out varchar2,                               
                                 P_N_VALOR   out number                                                               
                                );                                                             
  Function Fn_cl_descri(P_C_CONCATENA IN VARCHAR2) return varchar2;
  Procedure sp_bandeja_bjd008;
  /*
  Procedure sp_bandeja_bjd006;
  Procedure sp_bandeja_bjR006;
  Procedure sp_bandeja_bngc13_c;   
  */   
  Procedure sp_bandeja_bje108;        
  Procedure sp_bandeja_bjr008;      
  --Procedure sp_bandeja_bjx008;          
  --Procedure sp_MGM_Exite_ctacliente ;
end PQ_MIGRA_PERSONAS_CREDINKA_II;
/
create or replace package body PQ_MIGRA_PERSONAS_CREDINKA_II is
Procedure sp_MGM_ctacliente is
         
    cursor cliaho is 
    select c_codper,
           nombre,
           c_perpri
          from (select a.c_codper,
                       pq_migra_personas_credinka_II.fn_cl_descri(min(lpad(b.PAIS,3,'0')||lpad(b.TDOC,3,'0')||trim(b.NDOC))) nombre,
                       min(lpad(b.PAIS,3,'0')||lpad(b.TDOC,3,'0')||trim(b.NDOC)) c_perpri
                  from btctaman      a,
                       MIG$CTA_CLI  b
                 where a.c_numcta = b.CUENTA
                   and b.Tit = 1
                   and b.Tipo in ('A','D')
              group by  a.c_codper
              ) b
         where not exists
               (select 1 from btctacli a where a.c_codper = b.c_codper);     
               
    cursor clicre is 
    select c_codper,
           nombre,
           c_perpri
          from (select a.c_codper,
                       pq_migra_personas_credinka_II.fn_cl_descri(min(lpad(b.PAIS,3,'0')||lpad(b.TDOC,3,'0')||trim(b.NDOC))) nombre,
                       min(lpad(b.PAIS,3,'0')||lpad(b.TDOC,3,'0')||trim(b.NDOC)) c_perpri
                  from btctaman      a,
                       MIG$CTA_CLI  b
                 where a.c_numcta = b.CUENTA
                   and b.Tit = 1
                   and b.Tipo = 'C'
              group by  a.c_codper
              ) b
         where not exists
               (select 1 from btctacli a where a.c_codper = b.c_codper);                                                
               
    cursor cligar is 
    select c_codper,
           nombre,
           c_perpri
          from (select a.c_codper,
                       pq_migra_personas_credinka_II.fn_cl_descri(min(lpad(b.PAIS,3,'0')||lpad(b.TDOC,3,'0')||trim(b.NDOC))) nombre,
                       min(lpad(b.PAIS,3,'0')||lpad(b.TDOC,3,'0')||trim(b.NDOC)) c_perpri
                  from btctaman      a,
                       MIG$CTA_CLI  b
                 where a.c_numcta = b.CUENTA
                   and b.Tit = 1
                   and b.Tipo = 'G'
              group by  a.c_codper
              ) b
         where not exists
               (select 1 from btctacli a where a.c_codper = b.c_codper);         

    cursor clifia is 
    select c_codper,
           nombre,
           c_perpri
          from (select a.c_codper,
                       pq_migra_personas_credinka_II.fn_cl_descri(min(lpad(b.PAIS,3,'0')||lpad(b.TDOC,3,'0')||trim(b.NDOC))) nombre,
                       min(lpad(b.PAIS,3,'0')||lpad(b.TDOC,3,'0')||trim(b.NDOC)) c_perpri
                  from btctaman      a,
                       MIG$CTA_CLI  b
                 where a.c_numcta = b.CUENTA
                   and b.Tit = 1
                   and b.Tipo = 'F'
              group by  a.c_codper
              ) b
         where not exists
               (select 1 from btctacli a where a.c_codper = b.c_codper);   
                                     
    cursor cliemp is 
    select c_codper,
           nombre,
           c_perpri
          from (select a.c_codper,
                       pq_migra_personas_credinka_II.fn_cl_descri(min(lpad(b.PAIS,3,'0')||lpad(b.TDOC,3,'0')||trim(b.NDOC))) nombre,
                       min(lpad(b.PAIS,3,'0')||lpad(b.TDOC,3,'0')||trim(b.NDOC)) c_perpri
                  from btctaman      a,
                       MIG$CTA_CLI  b
                 where a.c_numcta = b.CUENTA
                   and b.Tit = 1
                   and b.Tipo = 'E'
              group by  a.c_codper
              ) b
         where not exists
               (select 1 from btctacli a where a.c_codper = b.c_codper);    
               
  ln_cuenta    number(10):= 0;        
  lc_msgerr    varchar2(400);   
  lc_existe    char(1):= 'N';
  ln_pais    number(3); 
  ln_tipo   number(3);
  lc_numero char(12); 
  ln_maxcli number(10); 
  ln_cont   number(10):=0;  
  
  NUM_JOB_PENDIENTES number(10);  
  
  ln_nro    log_carga_bandeja.n_nro%type;
  lc_diffec varchar2(5);
  ld_fecini date;
  ln_tamano number(5,2);
  ln_valor number := 0;
    
  begin
    
   --**********************************************************************************
   -- VALIDA QUE LOS PROCEDIMIENTOS JOB QUE LLENAN LA TABLA btctaman HALLAN TRMINADO
   --**********************************************************************************   
  --1
  NUM_JOB_PENDIENTES := FN_MG_VERIFICA_TAREA(
   pi_vc2_nomjob => 'CTACLI_CUENTAS',
   pi_vc2_nomusr => 'BANDEJAS'
   );

  WHILE NUM_JOB_PENDIENTES >0 LOOP
  
  NUM_JOB_PENDIENTES := FN_MG_VERIFICA_TAREA(
   pi_vc2_nomjob => 'CTACLI_CUENTAS',
   pi_vc2_nomusr => 'BANDEJAS'
   );
 
  END LOOP;   

  --2
  NUM_JOB_PENDIENTES := FN_MG_VERIFICA_TAREA(
   pi_vc2_nomjob => 'CTACLI_CREDITO',
   pi_vc2_nomusr => 'BANDEJAS'
   );

  WHILE NUM_JOB_PENDIENTES >0 LOOP
  
  NUM_JOB_PENDIENTES := FN_MG_VERIFICA_TAREA(
   pi_vc2_nomjob => 'CTACLI_CREDITO',
   pi_vc2_nomusr => 'BANDEJAS'
   );
 
  END LOOP;     

  --3
  NUM_JOB_PENDIENTES := FN_MG_VERIFICA_TAREA(
   pi_vc2_nomjob => 'CTACLI_GARANTIA',
   pi_vc2_nomusr => 'BANDEJAS'
   );

  WHILE NUM_JOB_PENDIENTES >0 LOOP
  
  NUM_JOB_PENDIENTES := FN_MG_VERIFICA_TAREA(
   pi_vc2_nomjob => 'CTACLI_GARANTIA',
   pi_vc2_nomusr => 'BANDEJAS'
   );
 
  END LOOP;       
  
  --4
  NUM_JOB_PENDIENTES := FN_MG_VERIFICA_TAREA(
   pi_vc2_nomjob => 'CTACLI_FIADOR',
   pi_vc2_nomusr => 'BANDEJAS'
   );

  WHILE NUM_JOB_PENDIENTES >0 LOOP
  
  NUM_JOB_PENDIENTES := FN_MG_VERIFICA_TAREA(
   pi_vc2_nomjob => 'CTACLI_FIADOR',
   pi_vc2_nomusr => 'BANDEJAS'
   );
 
  END LOOP;     
  
  --5
  NUM_JOB_PENDIENTES := FN_MG_VERIFICA_TAREA(
   pi_vc2_nomjob => 'CTACLI_EMPLEA',
   pi_vc2_nomusr => 'BANDEJAS'
   );

  WHILE NUM_JOB_PENDIENTES >0 LOOP
  
  NUM_JOB_PENDIENTES := FN_MG_VERIFICA_TAREA(
   pi_vc2_nomjob => 'CTACLI_EMPLEA',
   pi_vc2_nomusr => 'BANDEJAS'
   );
 
  END LOOP;         
  
BEGIN EXECUTE IMMEDIATE 'create index XN_BTCTAMANDES_001 on BTCTAMAN (C_CODPER)'; exception when others then null; end;
BEGIN EXECUTE IMMEDIATE 'create index XN_BTCTAMAN_001 on BTCTAMAN (C_NUMCTA)'; exception when others then null; end;
BEGIN EXECUTE IMMEDIATE 'create index XN_BTCTAMAN_002 on BTCTAMAN (C_INDPRO)';  exception when others then null; end;    

    
  -- lanza estadisticas de tabla btxcman
   PQ_MG_CTACLIENTE.sp_mg_gen_estadis 
    (pi_vc2_user       =>'BANDEJAS',
     pi_vc2_nomtab     =>'BTCTAMAN',
     pi_vc2_tarea_wait => 'CTACLI_EMPLEA'
     );
           

BEGIN execute immediate 'drop index XN_BTCTACLI_001 '; EXCEPTION WHEN OTHERS THEN NULL; END;
BEGIN execute immediate 'drop index XN_BTCTACLI_002 '; EXCEPTION WHEN OTHERS THEN NULL; END;
BEGIN execute immediate 'drop index XN_BTCTACLI_003 '; EXCEPTION WHEN OTHERS THEN NULL; END;


 
   --**********************************************************************************
   --**********************************************************************************
  
  
  
    --
    ld_fecini := sysdate;
    select seq_nro_ejecucion.nextval into ln_nro from dual;    
    
    insert into LOG_CARGA_BANDEJA
      (n_nro,c_codbdj,c_cptbdj,d_fecini)
    values
      (ln_nro,
       'BTCTACLI',
       'Tabla de Cuentas Bantotal Generado para los Clientes SORFY_',
       ld_fecini);
    commit;
    
    begin
     select ngnum
       into ln_cuenta
       from fsn999
      where pgcod = 1
        and ngsuc = 11
        and ngtipo = 3;
    Exception
    When others then
        null;           
    end;
               
    for l in cliaho loop
     
      ln_pais := to_number(substr(l.c_perpri,1,3));  
      ln_tipo := to_number(substr(l.c_perpri,4,3));  
      lc_numero := substr(l.c_perpri,7,12);      
             
      pq_migra_personas_credinka_II.sp_valida_ctacliente(p_n_pais   => ln_pais,
                                                      p_n_tipo   => ln_tipo,
                                                      p_c_numero => lc_numero,
                                                      p_c_cadena => l.c_codper,
                                                      p_c_tipo   => 'A',
                                                      p_c_existe => lc_existe,                               
                                                      p_n_valor  => ln_valor
                                                      );      
      If lc_existe = 'N' then --solo generar si no existe en bantotal una integracion
          ln_cuenta  := ln_cuenta + 1 ;            
          begin
              insert into btctacli 
                  (c_codper,c_nomcon,c_perpri,n_ctabtt,c_esprov )
              values (l.c_codper, l.nombre, l.c_perpri, ln_cuenta,'N'); 
                
          exception
          when others then
             lc_msgerr := sqlerrm;
             insert into log_error_bandeja (n_nro,c_codbdj,c_deserr,d_fecerr)
             values (1,'BTCTACLI',lc_msgerr,trunc(sysdate));
          end;
          ln_cont := ln_cont + 1;             
          if mod(ln_cont, 10000) =0 then 
             commit;        
          end if;          
      Else
          begin
              insert into btctacli 
                  (c_codper,c_nomcon,c_perpri,n_ctabtt,c_esprov )
              values (l.c_codper, l.nombre, l.c_perpri, ln_valor,'E'); 
                
          exception
          when others then
             lc_msgerr := sqlerrm;
             insert into log_error_bandeja (n_nro,c_codbdj,c_deserr,d_fecerr)
             values (1,'BTCTACLI',lc_msgerr,trunc(sysdate));
          end;          
      End If;
    end loop;         
    commit;  
    ln_cont := 0;
    for l in clicre loop
     
      ln_pais := to_number(substr(l.c_perpri,1,3));  
      ln_tipo := to_number(substr(l.c_perpri,4,3));  
      lc_numero := substr(l.c_perpri,7,12);      
             
      pq_migra_personas_credinka_II.sp_valida_ctacliente(p_n_pais   => ln_pais,
                                                      p_n_tipo   => ln_tipo,
                                                      p_c_numero => lc_numero,
                                                      p_c_cadena => l.c_codper,
                                                      p_c_tipo   => 'C',
                                                      p_c_existe => lc_existe,                               
                                                      p_n_valor  => ln_valor                                                                    
                                                      );      
      If lc_existe = 'N' then --solo generar si no existe en bantotal una integracion
          ln_cuenta  := ln_cuenta + 1 ;            
          begin
              insert into btctacli
                  (c_codper,c_nomcon,c_perpri,n_ctabtt,c_esprov)
              values (l.c_codper, l.nombre, l.c_perpri, ln_cuenta,'N'); 
                
          exception
          when others then
             lc_msgerr := sqlerrm;
             insert into log_error_bandeja (n_nro,c_codbdj,c_deserr,d_fecerr)
             values (1,'BTCTACLI',lc_msgerr,trunc(sysdate));
          end;
          ln_cont := ln_cont + 1;             
          if mod(ln_cont, 10000) =0 then 
             commit;        
          end if;     
      Else
          begin
              insert into btctacli 
                  (c_codper,c_nomcon,c_perpri,n_ctabtt,c_esprov )
              values (l.c_codper, l.nombre, l.c_perpri, ln_valor,'E'); 
                
          exception
          when others then
             lc_msgerr := sqlerrm;
             insert into log_error_bandeja (n_nro,c_codbdj,c_deserr,d_fecerr)
             values (1,'BTCTACLI',lc_msgerr,trunc(sysdate));
          end;                       
      End If;
    end loop;         
    commit;  
    ln_cont := 0;
    for l in cligar loop
     
      ln_pais := to_number(substr(l.c_perpri,1,3));  
      ln_tipo := to_number(substr(l.c_perpri,4,3));  
      lc_numero := substr(l.c_perpri,7,12);      
             
      pq_migra_personas_credinka_II.sp_valida_ctacliente(p_n_pais   => ln_pais,
                                                      p_n_tipo   => ln_tipo,
                                                      p_c_numero => lc_numero,
                                                      p_c_cadena => l.c_codper,
                                                      p_c_tipo   => 'G',
                                                      p_c_existe => lc_existe,                               
                                                      p_n_valor  => ln_valor                                                                    
                                                      );      
      If lc_existe = 'N' then --solo generar si no existe en bantotal una integracion
          ln_cuenta  := ln_cuenta + 1 ;            
          begin
              insert into btctacli
                  (c_codper,c_nomcon,c_perpri,n_ctabtt,c_esprov)
              values (l.c_codper, l.nombre, l.c_perpri, ln_cuenta,'N'); 
                
          exception
          when others then
             lc_msgerr := sqlerrm;
             insert into log_error_bandeja (n_nro,c_codbdj,c_deserr,d_fecerr)
             values (1,'BTCTACLI',lc_msgerr,trunc(sysdate));
          end;
          ln_cont := ln_cont + 1;             
          if mod(ln_cont, 10000) =0 then 
             commit;        
          end if;            
      Else
          begin
              insert into btctacli 
                  (c_codper,c_nomcon,c_perpri,n_ctabtt,c_esprov )
              values (l.c_codper, l.nombre, l.c_perpri, ln_valor,'E'); 
                
          exception
          when others then
             lc_msgerr := sqlerrm;
             insert into log_error_bandeja (n_nro,c_codbdj,c_deserr,d_fecerr)
             values (1,'BTCTACLI',lc_msgerr,trunc(sysdate));
          end;           
      End If;
    end loop;         
    commit;      
    
    ln_cont := 0;
    for l in clifia loop
     
      ln_pais := to_number(substr(l.c_perpri,1,3));  
      ln_tipo := to_number(substr(l.c_perpri,4,3));  
      lc_numero := substr(l.c_perpri,7,12);      
             
      pq_migra_personas_credinka_II.sp_valida_ctacliente(p_n_pais   => ln_pais,
                                                      p_n_tipo   => ln_tipo,
                                                      p_c_numero => lc_numero,
                                                      p_c_cadena => l.c_codper,
                                                      p_c_tipo   => 'F',
                                                      p_c_existe => lc_existe,                               
                                                      p_n_valor  => ln_valor                                                                    
                                                      );      
      If lc_existe = 'N' then --solo generar si no existe en bantotal una integracion
          ln_cuenta  := ln_cuenta + 1 ;            
          begin
              insert into btctacli
                  (c_codper,c_nomcon,c_perpri,n_ctabtt,c_esprov)
              values (l.c_codper, l.nombre, l.c_perpri, ln_cuenta,'N'); 
                
          exception
          when others then
             lc_msgerr := sqlerrm;
             insert into log_error_bandeja (n_nro,c_codbdj,c_deserr,d_fecerr)
             values (1,'BTCTACLI',lc_msgerr,trunc(sysdate));
          end;
          ln_cont := ln_cont + 1;             
          if mod(ln_cont, 10000) =0 then 
             commit;        
          end if; 
      Else
          begin
              insert into btctacli 
                  (c_codper,c_nomcon,c_perpri,n_ctabtt,c_esprov )
              values (l.c_codper, l.nombre, l.c_perpri, ln_valor,'E'); 
                
          exception
          when others then
             lc_msgerr := sqlerrm;
             insert into log_error_bandeja (n_nro,c_codbdj,c_deserr,d_fecerr)
             values (1,'BTCTACLI',lc_msgerr,trunc(sysdate));
          end;                      
      End If;
    end loop;         
    commit;     
    
    ln_cont := 0;
    for l in cliemp loop
     
      ln_pais := to_number(substr(l.c_perpri,1,3));  
      ln_tipo := to_number(substr(l.c_perpri,4,3));  
      lc_numero := substr(l.c_perpri,7,12);      
             
      pq_migra_personas_credinka_II.sp_valida_ctacliente(p_n_pais   => ln_pais,
                                                      p_n_tipo   => ln_tipo,
                                                      p_c_numero => lc_numero,
                                                      p_c_cadena => l.c_codper,
                                                      p_c_tipo   => 'E',
                                                      p_c_existe => lc_existe,                               
                                                      p_n_valor  => ln_valor                                                                    
                                                      );      
      If lc_existe = 'N' then --solo generar si no existe en bantotal una integracion
          ln_cuenta  := ln_cuenta + 1 ;            
          begin
              insert into btctacli
                  (c_codper,c_nomcon,c_perpri,n_ctabtt,c_esprov)
              values (l.c_codper, l.nombre, l.c_perpri, ln_cuenta,'N'); 
                
          exception
          when others then
             lc_msgerr := sqlerrm;
             insert into log_error_bandeja (n_nro,c_codbdj,c_deserr,d_fecerr)
             values (1,'BTCTACLI',lc_msgerr,trunc(sysdate));
          end;
          ln_cont := ln_cont + 1;             
          if mod(ln_cont, 10000) =0 then 
             commit;        
          end if; 
      Else
          begin
              insert into btctacli 
                  (c_codper,c_nomcon,c_perpri,n_ctabtt,c_esprov )
              values (l.c_codper, l.nombre, l.c_perpri, ln_valor,'E'); 
                
          exception
          when others then
             lc_msgerr := sqlerrm;
             insert into log_error_bandeja (n_nro,c_codbdj,c_deserr,d_fecerr)
             values (1,'BTCTACLI',lc_msgerr,trunc(sysdate));
          end;                      
      End If;
    end loop;         
    commit;               
  begin
     select max(n_ctabtt) 
       into ln_maxcli 
       from btctacli;
  Exception
  When others then           
    null;
  end;             
  
/*  begin
   update fsn999 
      set ngnum = ln_maxcli + 1
    where pgcod = 1 and ngsuc = 11 and ngtipo = 3;  
    commit;      
  Exception
  When others then           
    null;
  end;  */ 
  
       begin execute immediate 'create index XN_BTCTACLI_001 on BTCTACLI (C_CODPER)'; exception when others then null;  end;
       begin execute immediate 'create index XN_BTCTACLI_002 on BTCTACLI (N_CTABTT)'; exception when others then null;  end;
       begin execute immediate 'create index XN_BTCTACLI_003 on BTCTACLI (C_PERPRI)'; exception when others then null;  end;
       dbms_stats.gather_table_stats(
       ownname =>'BANDEJAS' ,
       tabname => 'btctacli'
       );
              
    select ROUND(SUM(BYTES) / 1024 / 1024 / 1024,2)
      into ln_tamano
      from user_segments
     where segment_name = 'BTCTACLI';
    lc_diffec := substr('0' || floor((sysdate - ld_fecini) * 24),-2) || ':' ||
                 substr('0' || round((((sysdate - ld_fecini) * 24) -
                                     (floor((sysdate - ld_fecini) * 24))) * 60,
                                     0),
                        -2);
    update LOG_CARGA_BANDEJA
       set d_fecfin = sysdate,n_sizegb = ln_tamano,c_diffec = lc_diffec
     where n_nro = ln_nro;
    commit;  
  End sp_MGM_ctacliente;  
  Procedure sp_valida_ctacliente(P_N_PAIS    IN NUMBER,
                                 P_N_TIPO    IN NUMBER,
                                 P_C_NUMERO  IN VARCHAR2,
                                 P_C_CADENA  IN VARCHAR2,
                                 P_C_TIPO    IN VARCHAR2,
                                 P_C_EXISTE  out varchar2,                               
                                 P_N_VALOR   out number                               
                                 ) IS
  cursor c_cuentas(lc_numero in varchar2) is      
    select distinct 
           x.ctnro
      from fsr008 x
     where x.pepais = P_N_PAIS
       and x.petdoc = P_N_TIPO
       and x.pendoc = lc_numero
       and not exists (select 1
                         from fse108 y
                        where y.ctxnro = x.ctnro
                          and y.ctxhab = 'N'
                       );       
              
   cursor c_integra(ln_cuenta in number) is
   select case
          when P_C_TIPO in ('A','C') then
            lpad(pepais,3,'0')||lpad(petdoc,3,'0')||lpad(trim(pendoc),12,'0')||decode(CTTFIR,'T',1,0) 
          Else
            lpad(pepais,3,'0')||lpad(petdoc,3,'0')||lpad(trim(pendoc),12,'0')||decode(CTTFIR,'T',1,0) --'0' 
          End ctaint
     from fsr008 
    where Ctnro = ln_cuenta
    order by 1/*pendoc*/;              
                         
  lv_concatena varchar2(400);   
  lc_existe char(1) := 'N';     
  lc_numero char(12):= P_C_NUMERO;   
  ln_valor number:=0;
  lc_msgerr varchar2(400);
  begin 
  begin
   for i in c_cuentas(lc_numero) loop
     for j in c_integra(i.ctnro) loop
       lv_concatena := lv_concatena || j.ctaint;
     End loop;
     If lv_concatena = P_C_CADENA then
        lc_existe := 'S';
        ln_valor  := i.ctnro;
        Exit;
     End If;    
     lv_concatena := null;
   End Loop;
  P_C_EXISTE := lc_existe;
  P_N_VALOR  := ln_valor;
  exception 
     when others then
       lc_msgerr := lc_numero||'-'||sqlerrm; 
       insert into log_error_bandeja (n_nro,c_codbdj,c_deserr,d_fecerr)
             values (1,'BTCTACLI',lc_msgerr,trunc(sysdate));
     commit;
   end;           
  End sp_valida_ctacliente;                                  
  
  
  Function Fn_cl_descri(P_C_CONCATENA IN VARCHAR2) return varchar2 is
  ln_pais    number(3); 
  ln_tipo   number(3);
  lc_numero varchar(12);    
  --lc_msgerr varchar2(400);
  lc_nombre varchar2(100);
  begin
  ln_pais := to_number(substr(P_C_CONCATENA,1,3));  
  ln_tipo := to_number(substr(P_C_CONCATENA,4,3));  
  lc_numero := substr(P_C_CONCATENA,7,12);  
    begin
       select substr(a.Nom,1,100)
         into lc_nombre
         from MIG$CTA_CLI a
        where a.PAIS = ln_pais
          and a.TDOC = ln_tipo
          and a.NDOC = lc_numero
          and rownum = 1;
    return lc_nombre;      
    Exception
    when others then
       --lc_msgerr := sqlerrm;
       return null;
    end;
  End Fn_cl_descri;  
  Procedure sp_bandeja_bjd008 is
    cursor c1 is
    select * from MIG$BJD008@credinka;
  ln_cuenta number(10):=0;  
  lc_error  varchar2(400);
  ln_nro    number := 1;    

  begin
    for i in c1 loop
      
        ln_cuenta := ln_cuenta + 1;          
      begin
         insert /*+ append */ into bandejas.BJD008
          (BD008ECod,
           BD008NCta,
           BD008CNom,
           BD008Resi,
           BD008CCla, 
           BD008FAlt,
           BD008RCor,
           BD008SCod,
           BD008IFin,
           BD008Empl,
           BD008Prov,
           BD008SegM,
           BE008Suc,
           BE008FvClf,
           BD008Est,
           BD008Ctnro)
        values
          (1,
           i.NCta,
           substr(i.CNom,1,35),
           i.Resi,
           i.CCla, --no es obligatorio, y es un GAP
           i.FAlt,
           'S',
           i.SCod,
           i.IFin,
           i.Empl,
           nvl(i.Prov,'N'),
           i.SegM,--no se ingresa
           i.Suc,
           i.FvClf,--DLYA asigna en programa de carga una fecha valida.
           'P',
           nvl(i.CtNro,99)
           );
           
       if mod(ln_cuenta, 10000) =0 then 
        --commit;
        null;
       end if;   
           
      exception
        when others then
          lc_error := sqlerrm;
          --insertar a una tabla generica de excepciones (dato y la bandeja)
          insert into LOG_ERROR_BANDEJA
            (n_nro,c_codbdj,c_deserr,d_fecerr)
          values
            (ln_nro,'BJD008',i.NCta || ' : ' || lc_error,sysdate);
          --commit;
      end;
    end loop;
    commit;  
  end sp_bandeja_bjd008;    
  /*
  Procedure sp_bandeja_bjd006 is
    cursor c1 is
    select * from MIG$BJD006@luren;
  ln_cuenta number(10):=0;  
  lc_error  varchar2(400);
  ln_nro    number := 1;    
  
  begin
    for i in c1 loop
      
        ln_cuenta := ln_cuenta + 1;          
      begin
          insert 
          into bandejas.BJD006
            (BD006ECod,
             BD006NCta,
             BD006DCod,
             BD006Call,
             BD006Nro,
             BD006Apar,
             BD006Ciud, -- codigo de localidad
             BD006Pais,
             BD006CPos,
             BD006CCor,
             BD006Sucu,
             BD006CDep, -- coidgo de departamento
             BD006Dept,
             BD006Est,
             BD006Ref1,
             BD006Ref2,
             BD006APo,
             BD006Upo)
          values
            (1,
             i."NCta",
             i."DCod", --Tipo de domicilio: LEGAL
             substr(i."Call", 1, 35),
             substr(i."Nro", 1, 8),
             substr(i."Apar", 1, 6),
             to_number(substr(i."Ciud", 1, 4)), --lc_desdis,
             i."Pais",
             null,
             null,
             null,
             to_number(substr(i."CDep", 1, 2)),
             substr(i."Dept", 1, 15),
             'P',
             i."Ref1",
             null,
             null,
             null);
           
       if mod(ln_cuenta, 10000) =0 then 
        --commit;
        null;
       end if;   
           
      exception
        when others then
          lc_error := sqlerrm;
          --insertar a una tabla generica de excepciones (dato y la bandeja)
          insert into LOG_ERROR_BANDEJA
            (n_nro,c_codbdj,c_deserr,d_fecerr)
          values
            (ln_nro,'BJD006',i."NCta" || ' : ' || lc_error,sysdate);
          --commit;
      end;
    end loop;
    commit;  
  end sp_bandeja_bjd006;     
  
  Procedure sp_bandeja_bjr006 is
    cursor c1 is
    select * from MIG$BJR006@luren;
  ln_cuenta number(10):=0;  
  lc_error  varchar2(400);
  ln_nro    number := 1;    

  begin
    for i in c1 loop
      
        ln_cuenta := ln_cuenta + 1;          
      begin
          insert 
          into bandejas.BJR006
            (BR006ECod,
             BR006NCta,
             BR006DCod,
             BR006DOrd,
             BR006Telf,
             BR006Tlex,
             BR006Fax,
             BR006Est)
          values
            (1,
             i."NCta",
             i."DCod",
             i."DOrd",
             i."Telf",
             i."Tlex",
             null,
             'P');
           
       if mod(ln_cuenta, 10000) =0 then 
        --commit;
        null;
       end if;   
           
      exception
        when others then
          lc_error := sqlerrm;
          --insertar a una tabla generica de excepciones (dato y la bandeja)
          insert into LOG_ERROR_BANDEJA
            (n_nro,c_codbdj,c_deserr,d_fecerr)
          values
            (ln_nro,'BJR006',i."NCta" || ' : ' || lc_error,sysdate);
          --commit;
      end;
    end loop;
    commit;  
  end sp_bandeja_bjr006;     
  
  Procedure sp_bandeja_bngc13_c is
    cursor c1 is
    select * from MIG$BNGC13_C@luren;
  ln_cuenta number(10):=0;  
  lc_error  varchar2(400);
  ln_nro    number := 1;    

  begin
    for i in c1 loop
      
        ln_cuenta := ln_cuenta + 1;          
      begin
            insert 
            into bandejas.BNGC13
              (BNGC13PAIS,
               BNGC13TDOC,
               BNGC13NDOC,
               DOCOD,
               BNGC13CORR,
               BNGC13PDOC,
               BNGC12VIVC,
               BNGC01ID,
               BNGC02ID,
               BNGC03ID,
               BNGC04ID,
               BNGC05ID,
               BNGC06ID,
               BNGC13DSC1,
               BNGC13DSC2,
               BNGC13DSC3,
               BNGC13DSC4,
               BNGC13DSC5,
               BNGC13DSC6,
               BNGC13UGEO,
               BNGC13DPTO,
               BNGC13PROV,
               BNGC13DIST,
               BNGC13CNEG,
               BNGC13REF,
               BNGC13REF1,
               BNGC13DIR,
               BNGC13RDES,
               BNGC13ARR,
               BNGC13ATEL,
               BNGC13FHAB,
               BNGC13DEST,
               BNGC13EST,
               BNGC13FDIR,
               BNGC13USER,
               BNGC13MEST)
            values
              (0,
               0,
               i."NDOC",
               i."DCod",
               1,
               i."PDoc", -- pais de direccion
               nvl(i."VivC", 6), -- codigo tipo de vivienda 
               nvl(i."ID1", 0), -- codigo tipo de via
               nvl(i."ID2", 0), -- codigo via
               nvl(i."ID3", 0), -- codigo detalle de via 
               nvl(i."ID4", 0),
               nvl(i."ID5", 0),
               nvl(i."ID6", 0),
               substr(i."Dsc1", 1, 30), -- descripcion de via 
               substr(i."Dsc2", 1, 30),
               substr(i."Dsc3", 1, 30),
               substr(i."Dsc4", 1, 30),
               substr(i."Dsc5", 1, 30),
               substr(i."Dsc6", 1, 30),
               substr(i."Ugeo", 1, 6),
               to_number(substr(i."Dpto", 1, 2)),
               to_number(substr(i."Prov", 1, 4)),
               to_number(substr(i."Dist", 1, 6)),
               null,
               null,
               substr(null || ' / ' || i."Ref1", 1, 200), -- referencia
               substr(i."Dir", 1, 140), --null,-- direccion concatenada
               null,
               null,
               null,
               null,
               2,
               'H',
               null,
               null,
               'P');
           
       if mod(ln_cuenta, 10000) =0 then 
        --commit;
        null;
       end if;   
           
      exception
        when others then
          lc_error := sqlerrm;
          --insertar a una tabla generica de excepciones (dato y la bandeja)
          insert into LOG_ERROR_BANDEJA
            (n_nro,c_codbdj,c_deserr,d_fecerr)
          values
            (ln_nro,'BNGC13_C',i."NDOC" || ' : ' || lc_error,sysdate);
          --commit;
      end;
    end loop;
    commit;  
  end sp_bandeja_bngc13_c;     
  */
  Procedure sp_bandeja_bje108 is
    cursor c1 is
    select * from MIG$BJE108@credinka;
  ln_cuenta number(10):=0;  
  lc_error  varchar2(400);
  ln_nro    number := 1;    

  begin
    for i in c1 loop
      
        ln_cuenta := ln_cuenta + 1;          
      begin
        insert /*+ append */ into bandejas.BJE108
          (BE108Cod,
           BE108Cta,
           BE108Fch,
           BE108Hora,
           BE108Usu,
           BE108Wrk,
           BE108Hab,
           BE108Est)
        values
          (1,
           i.NCta,
           i.Fch,--to_date(to_char(i."Fch",'dd/mm/rrrr'),'dd/mm/rrrr'),
           i.Hora,--to_char(i."Hora",'hh24:mi:ss'),
           i.USu,
           substr(i.Wrk,1,10),
           'S',
           'P');
           
       if mod(ln_cuenta, 10000) =0 then 
        --commit;
        null;
       end if;   
           
      exception
        when others then
          lc_error := sqlerrm;
          --insertar a una tabla generica de excepciones (dato y la bandeja)
          insert into LOG_ERROR_BANDEJA
            (n_nro,c_codbdj,c_deserr,d_fecerr)
          values
            (ln_nro,'BJE108',i.NCta || ' : ' || lc_error,sysdate);
          --commit;
      end;
    end loop;
    commit;  
  end sp_bandeja_bje108; 
  
  Procedure sp_bandeja_bjr008 is
    cursor c1 is
    select * from MIG$BJR008@credinka;
  ln_cuenta number(10):=0;  
  lc_error  varchar2(400);
  ln_nro    number := 1;    

  begin
    for i in c1 loop
      
        ln_cuenta := ln_cuenta + 1;          
      begin
       insert /*+ append */ into bandejas.BJR008
              (BR008ECod,
               BR008NCta,
               BR008Pais,
               BR008TDoc,
               BR008NDoc,
               BR008TCod,
               BR008TFir,
               BR008Est)
            values
              (1,
               i.NCta,
               i.PAIS,
               i.TDOC,
               i.NDOC,
               i.TCod,--1,
               i.TFir,
               'P');
           
       if mod(ln_cuenta, 10000) =0 then 
        --commit;
        null;
       end if;   
           
      exception
        when others then
          lc_error := sqlerrm;
          --insertar a una tabla generica de excepciones (dato y la bandeja)
          insert into LOG_ERROR_BANDEJA
            (n_nro,c_codbdj,c_deserr,d_fecerr)
          values
            (ln_nro,'BJR008',i.NCta || ' : ' || lc_error,sysdate);
          --commit;
      end;
    end loop;
    commit;  
  end sp_bandeja_bjr008;     
  /*
  Procedure sp_bandeja_bjx008 is
    cursor c1 is
    select * from MIG$BJX008@luren;
  ln_cuenta number(10):=0;  
  lc_error  varchar2(400);
  ln_nro    number := 1;    

  begin
    for i in c1 loop
      
        ln_cuenta := ln_cuenta + 1;          
      begin
              
        insert  into bandejas.BJX008
          (BX008ECod,
           BX008NCta,
           BX008XCod,
           BX008XRen,
           BX008XTxt,
           BX008XUsu,
           BX008XFch,
           BX008Est)
        values
          (1,
           i.NCta,
           0,   
           i.Ren,
           upper(i.Txt),
           i.USu,
           i.Fch,
           'P');
           
       if mod(ln_cuenta, 10000) =0 then 
        --commit;
        null;
       end if;   
           
      exception
        when others then
          lc_error := sqlerrm;
          --insertar a una tabla generica de excepciones (dato y la bandeja)
          insert into LOG_ERROR_BANDEJA
            (n_nro,c_codbdj,c_deserr,d_fecerr)
          values
            (ln_nro,'BJX008',i."NCta" || ' : ' || lc_error,sysdate);
          --commit;
      end;
    end loop;
    commit;  
  end sp_bandeja_bjx008;    
  */
  
  /*Procedure sp_MGM_Exite_ctacliente is
         
    cursor cliaho is 
    select c_codper,
           nombre,
           c_perpri
          from (select a.c_codper,
                       pq_migra_personas_credinka_II.fn_cl_descri(min(lpad(b.PAIS,3,'0')||lpad(b.TDOC,3,'0')||trim(b.NDOC))) nombre,
                       min(lpad(b.PAIS,3,'0')||lpad(b.TDOC,3,'0')||trim(b.NDOC)) c_perpri
                  from btctaman      a,
                       MIG$CTA_CLI  b
                 where a.c_numcta = b.CUENTA
                   and b.Tit = 1
                   and b.Tipo in ('A','D')
              group by  a.c_codper
              ) b
         where not exists
               (select 1 from btctacli_ex a where a.c_codper = b.c_codper);     
               
    cursor clicre is 
    select c_codper,
           nombre,
           c_perpri
          from (select a.c_codper,
                       pq_migra_personas_credinka_II.fn_cl_descri(min(lpad(b.PAIS,3,'0')||lpad(b.TDOC,3,'0')||trim(b.NDOC))) nombre,
                       min(lpad(b.PAIS,3,'0')||lpad(b.TDOC,3,'0')||trim(b.NDOC)) c_perpri
                  from btctaman      a,
                       MIG$CTA_CLI  b
                 where a.c_numcta = b.CUENTA
                   and b.Tit = 1
                   and b.Tipo = 'C'
              group by  a.c_codper
              ) b
         where not exists
               (select 1 from btctacli_ex a where a.c_codper = b.c_codper);                                                
               
    cursor cligar is 
    select c_codper,
           nombre,
           c_perpri
          from (select a.c_codper,
                       pq_migra_personas_credinka_II.fn_cl_descri(min(lpad(b.PAIS,3,'0')||lpad(b.TDOC,3,'0')||trim(b.NDOC))) nombre,
                       min(lpad(b.PAIS,3,'0')||lpad(b.TDOC,3,'0')||trim(b.NDOC)) c_perpri
                  from btctaman      a,
                       MIG$CTA_CLI  b
                 where a.c_numcta = b.CUENTA
                   and b.Tit = 1
                   and b.Tipo = 'G'
              group by  a.c_codper
              ) b
         where not exists
               (select 1 from btctacli_ex a where a.c_codper = b.c_codper);         

    cursor clifia is 
    select c_codper,
           nombre,
           c_perpri
          from (select a.c_codper,
                       pq_migra_personas_credinka_II.fn_cl_descri(min(lpad(b.PAIS,3,'0')||lpad(b.TDOC,3,'0')||trim(b.NDOC))) nombre,
                       min(lpad(b.PAIS,3,'0')||lpad(b.TDOC,3,'0')||trim(b.NDOC)) c_perpri
                  from btctaman      a,
                       MIG$CTA_CLI  b
                 where a.c_numcta = b.CUENTA
                   and b.Tit = 1
                   and b.Tipo = 'F'
              group by  a.c_codper
              ) b
         where not exists
               (select 1 from btctacli_ex a where a.c_codper = b.c_codper);   
                                     
    cursor cliemp is 
    select c_codper,
           nombre,
           c_perpri
          from (select a.c_codper,
                       pq_migra_personas_credinka_II.fn_cl_descri(min(lpad(b.PAIS,3,'0')||lpad(b.TDOC,3,'0')||trim(b.NDOC))) nombre,
                       min(lpad(b.PAIS,3,'0')||lpad(b.TDOC,3,'0')||trim(b.NDOC)) c_perpri
                  from btctaman      a,
                       MIG$CTA_CLI  b
                 where a.c_numcta = b.CUENTA
                   and b.Tit = 1
                   and b.Tipo = 'E'
              group by  a.c_codper
              ) b
         where not exists
               (select 1 from btctacli_ex a where a.c_codper = b.c_codper);    
               
  ln_cuenta    number(10):= 0;        
  lc_msgerr    varchar2(400);   
  lc_existe    char(1):= 'N';
  ln_pais    number(3); 
  ln_tipo   number(3);
  lc_numero char(12); 
  ln_maxcli number(10); 
  ln_cont   number(10):=0;  
  
  NUM_JOB_PENDIENTES number(10);  
  
  ln_nro    log_carga_bandeja.n_nro%type;
  lc_diffec varchar2(5);
  ld_fecini date;
  ln_tamano number(5,2);
  ln_valor number := 0;
    
  begin
    
   --**********************************************************************************
   -- VALIDA QUE LOS PROCEDIMIENTOS JOB QUE LLENAN LA TABLA btctaman HALLAN TRMINADO
   --**********************************************************************************   
  --1
  NUM_JOB_PENDIENTES := FN_MG_VERIFICA_TAREA(
   pi_vc2_nomjob => 'CTACLI_CUENTAS',
   pi_vc2_nomusr => 'BANDEJAS'
   );

  WHILE NUM_JOB_PENDIENTES >0 LOOP
  
  NUM_JOB_PENDIENTES := FN_MG_VERIFICA_TAREA(
   pi_vc2_nomjob => 'CTACLI_CUENTAS',
   pi_vc2_nomusr => 'BANDEJAS'
   );
 
  END LOOP;   

  --2
  NUM_JOB_PENDIENTES := FN_MG_VERIFICA_TAREA(
   pi_vc2_nomjob => 'CTACLI_CREDITO',
   pi_vc2_nomusr => 'BANDEJAS'
   );

  WHILE NUM_JOB_PENDIENTES >0 LOOP
  
  NUM_JOB_PENDIENTES := FN_MG_VERIFICA_TAREA(
   pi_vc2_nomjob => 'CTACLI_CREDITO',
   pi_vc2_nomusr => 'BANDEJAS'
   );
 
  END LOOP;     

  --3
  NUM_JOB_PENDIENTES := FN_MG_VERIFICA_TAREA(
   pi_vc2_nomjob => 'CTACLI_GARANTIA',
   pi_vc2_nomusr => 'BANDEJAS'
   );

  WHILE NUM_JOB_PENDIENTES >0 LOOP
  
  NUM_JOB_PENDIENTES := FN_MG_VERIFICA_TAREA(
   pi_vc2_nomjob => 'CTACLI_GARANTIA',
   pi_vc2_nomusr => 'BANDEJAS'
   );
 
  END LOOP;       
  
  --4
  NUM_JOB_PENDIENTES := FN_MG_VERIFICA_TAREA(
   pi_vc2_nomjob => 'CTACLI_FIADOR',
   pi_vc2_nomusr => 'BANDEJAS'
   );

  WHILE NUM_JOB_PENDIENTES >0 LOOP
  
  NUM_JOB_PENDIENTES := FN_MG_VERIFICA_TAREA(
   pi_vc2_nomjob => 'CTACLI_FIADOR',
   pi_vc2_nomusr => 'BANDEJAS'
   );
 
  END LOOP;     
  
  --5
  NUM_JOB_PENDIENTES := FN_MG_VERIFICA_TAREA(
   pi_vc2_nomjob => 'CTACLI_EMPLEA',
   pi_vc2_nomusr => 'BANDEJAS'
   );

  WHILE NUM_JOB_PENDIENTES >0 LOOP
  
  NUM_JOB_PENDIENTES := FN_MG_VERIFICA_TAREA(
   pi_vc2_nomjob => 'CTACLI_EMPLEA',
   pi_vc2_nomusr => 'BANDEJAS'
   );
 
  END LOOP;         
  
BEGIN EXECUTE IMMEDIATE 'create index XN_BTCTAMANDES_001 on BTCTAMAN (C_CODPER)'; exception when others then null; end;
BEGIN EXECUTE IMMEDIATE 'create index XN_BTCTAMAN_001 on BTCTAMAN (C_NUMCTA)'; exception when others then null; end;
BEGIN EXECUTE IMMEDIATE 'create index XN_BTCTAMAN_002 on BTCTAMAN (C_INDPRO)';  exception when others then null; end;    

    
  -- lanza estadisticas de tabla btxcman
   PQ_MG_CTACLIENTE.sp_mg_gen_estadis 
    (pi_vc2_user       =>'BANDEJAS',
     pi_vc2_nomtab     =>'BTCTAMAN',
     pi_vc2_tarea_wait => 'CTACLI_EMPLEA'
     );
           

BEGIN execute immediate 'drop index XN_BTCTACLI_001 '; EXCEPTION WHEN OTHERS THEN NULL; END;
BEGIN execute immediate 'drop index XN_BTCTACLI_002 '; EXCEPTION WHEN OTHERS THEN NULL; END;
BEGIN execute immediate 'drop index XN_BTCTACLI_003 '; EXCEPTION WHEN OTHERS THEN NULL; END;


 
   --**********************************************************************************
   --**********************************************************************************
  
  
  
    --
    ld_fecini := sysdate;
    select seq_nro_ejecucion.nextval into ln_nro from dual;    
    
    insert into LOG_CARGA_BANDEJA
      (n_nro,c_codbdj,c_cptbdj,d_fecini)
    values
      (ln_nro,
       'BTCTACLI',
       'Tabla de Cuentas Bantotal Generado para los Clientes SORFY_',
       ld_fecini);
    commit;
    
   \* begin
     select ngnum
       into ln_cuenta
       from fsn999
      where pgcod = 1
        and ngsuc = 11
        and ngtipo = 3;
    Exception
    When others then
        null;           
    end;*\
               
    for l in cliaho loop
     
      ln_pais := to_number(substr(l.c_perpri,1,3));  
      ln_tipo := to_number(substr(l.c_perpri,4,3));  
      lc_numero := substr(l.c_perpri,7,12);      
             
      pq_migra_personas_credinka_II.sp_valida_ctacliente(p_n_pais   => ln_pais,
                                                      p_n_tipo   => ln_tipo,
                                                      p_c_numero => lc_numero,
                                                      p_c_cadena => l.c_codper,
                                                      p_c_tipo   => 'A',
                                                      p_c_existe => lc_existe,                               
                                                      p_n_valor  => ln_valor
                                                      );      
      If lc_existe = 'N' then --solo generar si no existe en bantotal una integracion
          ln_cuenta  := null; --ln_cuenta + 1 ;            
          begin
              insert into btctacli_ex 
                  (c_codper,c_nomcon,c_perpri,n_ctabtt,c_esprov )
              values (l.c_codper, l.nombre, l.c_perpri, ln_cuenta,'N'); 
             commit;    
          exception
          when others then
             lc_msgerr := ln_cuenta||'-'||sqlerrm;
             insert into log_error_bandeja (n_nro,c_codbdj,c_deserr,d_fecerr)
             values (1,'BTCTACLI',lc_msgerr,trunc(sysdate));
             commit;
          end;
          ln_cont := ln_cont + 1;             
          if mod(ln_cont, 10000) =0 then 
             commit;        
          end if;          
      Else
          begin
              insert into btctacli_ex 
                  (c_codper,c_nomcon,c_perpri,n_ctabtt,c_esprov )
              values (l.c_codper, l.nombre, l.c_perpri, ln_valor,'E'); 
              commit;  
          exception
          when others then
             lc_msgerr := ln_valor||'-'||sqlerrm;
             insert into log_error_bandeja (n_nro,c_codbdj,c_deserr,d_fecerr)
             values (1,'BTCTACLI',lc_msgerr,trunc(sysdate));
             commit;
          end;          
      End If;
    end loop;         
    commit;  
    ln_cont := 0;
    for l in clicre loop
     
      ln_pais := to_number(substr(l.c_perpri,1,3));  
      ln_tipo := to_number(substr(l.c_perpri,4,3));  
      lc_numero := substr(l.c_perpri,7,12);      
             
      pq_migra_personas_credinka_II.sp_valida_ctacliente(p_n_pais   => ln_pais,
                                                      p_n_tipo   => ln_tipo,
                                                      p_c_numero => lc_numero,
                                                      p_c_cadena => l.c_codper,
                                                      p_c_tipo   => 'C',
                                                      p_c_existe => lc_existe,                               
                                                      p_n_valor  => ln_valor                                                                    
                                                      );      
      If lc_existe = 'N' then --solo generar si no existe en bantotal una integracion
          ln_cuenta  := null;--ln_cuenta + 1 ;            
          begin
              insert into btctacli_ex
                  (c_codper,c_nomcon,c_perpri,n_ctabtt,c_esprov)
              values (l.c_codper, l.nombre, l.c_perpri, ln_cuenta,'N'); 
                
          exception
          when others then
             lc_msgerr := sqlerrm;
             insert into log_error_bandeja (n_nro,c_codbdj,c_deserr,d_fecerr)
             values (1,'BTCTACLI',lc_msgerr,trunc(sysdate));
          end;
          ln_cont := ln_cont + 1;             
          if mod(ln_cont, 10000) =0 then 
             commit;        
          end if;     
      Else
          begin
              insert into btctacli_ex 
                  (c_codper,c_nomcon,c_perpri,n_ctabtt,c_esprov )
              values (l.c_codper, l.nombre, l.c_perpri, ln_valor,'E'); 
                
          exception
          when others then
             lc_msgerr := sqlerrm;
             insert into log_error_bandeja (n_nro,c_codbdj,c_deserr,d_fecerr)
             values (1,'BTCTACLI',lc_msgerr,trunc(sysdate));
          end;                       
      End If;
    end loop;         
    commit;  
    ln_cont := 0;
    for l in cligar loop
     
      ln_pais := to_number(substr(l.c_perpri,1,3));  
      ln_tipo := to_number(substr(l.c_perpri,4,3));  
      lc_numero := substr(l.c_perpri,7,12);      
             
      pq_migra_personas_credinka_II.sp_valida_ctacliente(p_n_pais   => ln_pais,
                                                      p_n_tipo   => ln_tipo,
                                                      p_c_numero => lc_numero,
                                                      p_c_cadena => l.c_codper,
                                                      p_c_tipo   => 'G',
                                                      p_c_existe => lc_existe,                               
                                                      p_n_valor  => ln_valor                                                                    
                                                      );      
      If lc_existe = 'N' then --solo generar si no existe en bantotal una integracion
          ln_cuenta  := null;--ln_cuenta + 1 ;            
          begin
              insert into btctacli_ex
                  (c_codper,c_nomcon,c_perpri,n_ctabtt,c_esprov)
              values (l.c_codper, l.nombre, l.c_perpri, ln_cuenta,'N'); 
                
          exception
          when others then
             lc_msgerr := sqlerrm;
             insert into log_error_bandeja (n_nro,c_codbdj,c_deserr,d_fecerr)
             values (1,'BTCTACLI',lc_msgerr,trunc(sysdate));
          end;
          ln_cont := ln_cont + 1;             
          if mod(ln_cont, 10000) =0 then 
             commit;        
          end if;            
      Else
          begin
              insert into btctacli_ex 
                  (c_codper,c_nomcon,c_perpri,n_ctabtt,c_esprov )
              values (l.c_codper, l.nombre, l.c_perpri, ln_valor,'E'); 
                
          exception
          when others then
             lc_msgerr := sqlerrm;
             insert into log_error_bandeja (n_nro,c_codbdj,c_deserr,d_fecerr)
             values (1,'BTCTACLI',lc_msgerr,trunc(sysdate));
          end;           
      End If;
    end loop;         
    commit;      
    
    ln_cont := 0;
    for l in clifia loop
     
      ln_pais := to_number(substr(l.c_perpri,1,3));  
      ln_tipo := to_number(substr(l.c_perpri,4,3));  
      lc_numero := substr(l.c_perpri,7,12);      
             
      pq_migra_personas_credinka_II.sp_valida_ctacliente(p_n_pais   => ln_pais,
                                                      p_n_tipo   => ln_tipo,
                                                      p_c_numero => lc_numero,
                                                      p_c_cadena => l.c_codper,
                                                      p_c_tipo   => 'F',
                                                      p_c_existe => lc_existe,                               
                                                      p_n_valor  => ln_valor                                                                    
                                                      );      
      If lc_existe = 'N' then --solo generar si no existe en bantotal una integracion
          ln_cuenta  := null;--ln_cuenta + 1 ;            
          begin
              insert into btctacli_ex
                  (c_codper,c_nomcon,c_perpri,n_ctabtt,c_esprov)
              values (l.c_codper, l.nombre, l.c_perpri, ln_cuenta,'N'); 
                
          exception
          when others then
             lc_msgerr := sqlerrm;
             insert into log_error_bandeja (n_nro,c_codbdj,c_deserr,d_fecerr)
             values (1,'BTCTACLI',lc_msgerr,trunc(sysdate));
          end;
          ln_cont := ln_cont + 1;             
          if mod(ln_cont, 10000) =0 then 
             commit;        
          end if; 
      Else
          begin
              insert into btctacli_ex 
                  (c_codper,c_nomcon,c_perpri,n_ctabtt,c_esprov )
              values (l.c_codper, l.nombre, l.c_perpri, ln_valor,'E'); 
                
          exception
          when others then
             lc_msgerr := sqlerrm;
             insert into log_error_bandeja (n_nro,c_codbdj,c_deserr,d_fecerr)
             values (1,'BTCTACLI',lc_msgerr,trunc(sysdate));
          end;                      
      End If;
    end loop;         
    commit;     
    
    ln_cont := 0;
    for l in cliemp loop
     
      ln_pais := to_number(substr(l.c_perpri,1,3));  
      ln_tipo := to_number(substr(l.c_perpri,4,3));  
      lc_numero := substr(l.c_perpri,7,12);      
             
      pq_migra_personas_credinka_II.sp_valida_ctacliente(p_n_pais   => ln_pais,
                                                      p_n_tipo   => ln_tipo,
                                                      p_c_numero => lc_numero,
                                                      p_c_cadena => l.c_codper,
                                                      p_c_tipo   => 'E',
                                                      p_c_existe => lc_existe,                               
                                                      p_n_valor  => ln_valor                                                                    
                                                      );      
      If lc_existe = 'N' then --solo generar si no existe en bantotal una integracion
          ln_cuenta  := null;--ln_cuenta + 1 ;            
          begin
              insert into btctacli_ex
                  (c_codper,c_nomcon,c_perpri,n_ctabtt,c_esprov)
              values (l.c_codper, l.nombre, l.c_perpri, ln_cuenta,'N'); 
                
          exception
          when others then
             lc_msgerr := sqlerrm;
             insert into log_error_bandeja (n_nro,c_codbdj,c_deserr,d_fecerr)
             values (1,'BTCTACLI',lc_msgerr,trunc(sysdate));
          end;
          ln_cont := ln_cont + 1;             
          if mod(ln_cont, 10000) =0 then 
             commit;        
          end if; 
      Else
          begin
              insert into btctacli_ex 
                  (c_codper,c_nomcon,c_perpri,n_ctabtt,c_esprov )
              values (l.c_codper, l.nombre, l.c_perpri, ln_valor,'E'); 
                
          exception
          when others then
             lc_msgerr := sqlerrm;
             insert into log_error_bandeja (n_nro,c_codbdj,c_deserr,d_fecerr)
             values (1,'BTCTACLI',lc_msgerr,trunc(sysdate));
          end;                      
      End If;
    end loop;         
    commit;               
  \*begin
     select max(n_ctabtt) 
       into ln_maxcli 
       from btctacli;
  Exception
  When others then           
    null;
  end;  *\           
  
\*  begin
   update fsn999 
      set ngnum = ln_maxcli + 1
    where pgcod = 1 and ngsuc = 11 and ngtipo = 3;  
    commit;      
  Exception
  When others then           
    null;
  end;  *\ 
  
       begin execute immediate 'create index XN_BTCTACLI_001 on BTCTACLI (C_CODPER)'; exception when others then null;  end;
       begin execute immediate 'create index XN_BTCTACLI_002 on BTCTACLI (N_CTABTT)'; exception when others then null;  end;
       begin execute immediate 'create index XN_BTCTACLI_003 on BTCTACLI (C_PERPRI)'; exception when others then null;  end;
       dbms_stats.gather_table_stats(
       ownname =>'BANDEJAS' ,
       tabname => 'btctacli'
       );
              
    select ROUND(SUM(BYTES) / 1024 / 1024 / 1024,2)
      into ln_tamano
      from user_segments
     where segment_name = 'BTCTACLI';
    lc_diffec := substr('0' || floor((sysdate - ld_fecini) * 24),-2) || ':' ||
                 substr('0' || round((((sysdate - ld_fecini) * 24) -
                                     (floor((sysdate - ld_fecini) * 24))) * 60,
                                     0),
                        -2);
    update LOG_CARGA_BANDEJA
       set d_fecfin = sysdate,n_sizegb = ln_tamano,c_diffec = lc_diffec
     where n_nro = ln_nro;
    commit;  
  End sp_MGM_Exite_ctacliente;*/
end PQ_MIGRA_PERSONAS_CREDINKA_II;
/
