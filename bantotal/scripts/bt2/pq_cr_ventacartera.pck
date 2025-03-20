create or replace package pq_cr_ventacartera is
-- Author  : KVALENCIAC
  -- Created : 20/04/2022
  -- Purpose : Programa de Venta de Cartera
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure sp_bloqueo(vn_ubuser varchar2                       
                             );
  procedure sp_desbloqueo(vn_ubuser varchar2 ); 
  
  procedure sp_CreaJAQZ509(vn_ubuser varchar2  --P2-01_Indicaciones                     
                             );
  procedure sp_ObtienePagos(FECHA_FIN date --P2-02_Ejecuta_proceso_ObtienePagos                     
                             ); 
  procedure sp_antesventa(vn_ubuser varchar2, FECHA_FIN date --   llama a los procesos P2_01 y P2_02                     
                             );         
  procedure sp_saldos_venta( lc_IND char ); --------------> lc_IND: Colocar "A" si se ejecuta antes de la venta o "D" si se ejecuta despues venta                     
end pq_cr_ventacartera;
/

create or replace package body pq_cr_ventacartera is

  /* ************************************************************************************************************
  -- Author  : KVALENCIAC
  -- Created : 20/04/2021
  -- Purpose : Proceso Venta Cartera
  * *************************************************************************************************************/
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_bloqueo(vn_ubuser varchar2                       
                             ) is
  cursor venta is       
    select b.AQPB749pgc,
           b.AQPB749mod,
           b.AQPB749suc,
           b.AQPB749mda,
           b.AQPB749pap,
           b.AQPB749cta,
           b.AQPB749ope,
           b.AQPB749sbo,
           b.AQPB749top
    from AQPB749 b;
  lc_flag varchar(2);
  contador number;
  ln_R2COD number;
  ln_R2MOD number;
  ln_R2SUC number; 
  ln_R2MDA number;
  ln_R2PAP number;
  ln_R2CTA number;
  ln_R2OPER number;
  ln_R2SBOP number;
  ln_R2TOPE number;  
  ln_scsdo116 number;
  ln_scsdo117 number;
  ln_aostat number;  
  begin 
   -- verifica si hay cancelado  y llena columna de es_caneclado
  update AQPB749 set AQPB749ESCANCELADO ='1' 
  where (AQPB749pgc, AQPB749mod, AQPB749suc,AQPB749mda, AQPB749pap, AQPB749cta,AQPB749ope,AQPB749sbo,AQPB749top) in (select a.AQPB749pgc, a.AQPB749mod, a.AQPB749suc, a.AQPB749mda, a.AQPB749pap, a.AQPB749cta,a.AQPB749ope, a.AQPB749sbo, a.AQPB749top
   from AQPB749 a
   inner join  fsd010 f      
      on f.pgcod     = a.AQPB749pgc
        and f.aomod  = a.AQPB749mod
        and f.aosuc  = a.AQPB749suc
        and f.aomda  = a.AQPB749mda
        and f.aopap  = a.AQPB749pap
        and f.aocta  = a.AQPB749cta
        and f.aooper = a.AQPB749ope
        and f.aosbop = a.AQPB749sbo
        and f.aotope = a.AQPB749top
        and f.aostat = 99);
   commit;
   ----
   ---validaciones    
   update AQPB749 set AQPB749EsFondo=0, 
                      AQPB749TieneSaldo =0,
                      AQPB749EsLineam =0,
                      AQPB749EsJLineam =0,
                      AQPB749EsLineBlq =0;
   commit;
   for f in venta loop           
        contador :=0;
        begin
        select count(*) into contador from fsd011 
        where scrub in (9500095000000,9500092000000,9500093000000,9500094000000)
        and sccta= f.AQPB749cta
        and scoper=f.AQPB749ope;
        exception
                      when no_data_found then
                        contador :=0;
        end;
        if ( contador > 0)  then        
          update AQPB749
          set AQPB749TieneSaldo=1
          where AQPB749cta= f.AQPB749cta
          and AQPB749ope=f.AQPB749ope;
          commit;
          --dbms_output.put_line('Tiene Saldo Pendiente: Cuenta:'||f.aocta||'- Operación:'||f.aooper); 
        end if;     
        --verifica si es de fondo    
        pq_cr_creditos_fondoscovid.sp_verificar_cred_fondo( pn_cod => f.AQPB749pgc,
                                                            pn_mod => f.AQPB749mod,
                                                            pn_suc => f.AQPB749suc,
                                                            pn_mda => f.AQPB749mda,
                                                            pn_pap => f.AQPB749pap,
                                                            pn_cta => f.AQPB749cta,
                                                            pn_ope => f.AQPB749ope,
                                                            pn_sbo => f.AQPB749sbo,
                                                            pn_top => f.AQPB749top,
                                                            pn_flag => lc_flag);
        if ( lc_flag <> 'N' ) then -- si es diferente es de fondo
           update AQPB749
          set AQPB749EsFondo=1
          where AQPB749cta= f.AQPB749cta
          and AQPB749ope=f.AQPB749ope;
          commit;
          --dbms_output.put_line('Es de Fondo: Cuenta:'||f.aocta||'-operacion:'||f.aooper||'-'||lc_flag); 
        end if;
        
        --valida saldo de línea 117 es menot al saldo de linea módulo 116
        if ( f.AQPB749mod = 116 ) then
            ln_scsdo116:=0;
            begin
              select scsdo into ln_scsdo116
              from fsd011
              where PGCOD = f.AQPB749pgc
              and   SCMOD = f.AQPB749mod
              and   SCMDA = f.AQPB749mda 
              and   SCPAP = f.AQPB749pap
              and   SCCTA = f.AQPB749cta 
              and   SCSUC = f.AQPB749suc 
              and   SCOPER= f.AQPB749ope
              and  SCSBOP = f.AQPB749sbo
              and  SCTOPE = f.AQPB749top;
            exception
             when no_data_found then
                        ln_scsdo116 :=0;
            end;
            
          begin 
            select 
                  r.R2COD, 
                  r.R2MOD, 
                  r.R2SUC, 
                  r.R2MDA, 
                  r.R2PAP, 
                  r.R2CTA, 
                  r.R2OPER,
                  r.R2SBOP,
                  r.R2TOPE  
                  into
                  ln_R2COD, 
                  ln_R2MOD, 
                  ln_R2SUC, 
                  ln_R2MDA, 
                  ln_R2PAP, 
                  ln_R2CTA, 
                  ln_R2OPER,
                  ln_R2SBOP,
                  ln_R2TOPE
            from fsr011 r
          where r.R1COD   = f.AQPB749pgc
            and r.R1MOD   = f.AQPB749mod
            and r.R1SUC   = f.AQPB749suc  
            and r.R1MDA   = f.AQPB749mda 
            and r.R1PAP   = f.AQPB749pap  
            and r.R1CTA   = f.AQPB749cta
            and r.R1OPER  = f.AQPB749ope
            and r.R1SBOP  = f.AQPB749sbo
            and r.R1TOPE  = f.AQPB749top
            and r.RELCOD  = 46;
          exception
             when no_data_found then
                        ln_R2CTA :=0;
          end;
          if ( ln_R2CTA > 0 ) then 
            ln_scsdo117:=0;
            begin
              select scsdo,scstat into ln_scsdo117,ln_aostat
              from fsd011
              where PGCOD = ln_R2COD
              and   SCMOD = ln_R2MOD
              and   SCMDA = ln_R2MDA
              and   SCPAP = ln_R2PAP 
              and   SCCTA =  ln_R2CTA
              and   SCSUC = ln_R2SUC 
              and   SCOPER= ln_R2OPER
              and  SCSBOP = ln_R2SBOP
              and  SCTOPE = ln_R2TOPE;
            exception
             when no_data_found then
                        ln_scsdo117 :=0;
                        ln_aostat :=0;
            end;
            if ( ln_scsdo117 < 0 )then
              ln_scsdo117 :=ln_scsdo117*-1;
             end if;
            if ( ln_scsdo116 < 0 )then
              ln_scsdo116 :=ln_scsdo116*-1;
             end if;
            if (ln_aostat = 7 or ln_aostat=9) then
                update AQPB749
                set AQPB749EsLineBlq=1
                where AQPB749cta= f.AQPB749cta
                and AQPB749ope=f.AQPB749ope;
                commit;
            end if ;          
            if ( ln_scsdo117 < ln_scsdo116 ) then-- si saldo de línea es menor al saldo de la línea usada
               update AQPB749
                set AQPB749EsLineam=1
                where AQPB749cta= f.AQPB749cta
                and AQPB749ope=f.AQPB749ope;
                commit;
              end if;
           end if;              
        end if;   
        -- fin de valida saldo de línea si es módulo 116        
        ----valida si su saldo incial de la línea es menor para los tipos operacion 550 y modulo 200
        if ( f.AQPB749mod=200 and f.AQPB749top=550 and f.AQPB749mod=33 ) then
          ln_scsdo116:=0;
            begin
              select scsdo into ln_scsdo116
              from fsd011
              where PGCOD = f.AQPB749pgc
              and   SCMOD = f.AQPB749mod
              and   SCMDA = f.AQPB749mda 
              and   SCPAP = f.AQPB749pap
              and   SCCTA = f.AQPB749cta
              and   SCSUC = f.AQPB749suc
              and   SCOPER= f.AQPB749ope
              and  SCSBOP = f.AQPB749sbo
              and  SCTOPE = f.AQPB749top;
            exception
             when no_data_found then
                        ln_scsdo116 :=0;
            end;
          begin 
            select 
                  r.R1COD, 
                  r.R1MOD, 
                  r.R1SUC, 
                  r.R1MDA, 
                  r.R1PAP, 
                  r.R1CTA, 
                  r.R1OPER,
                  r.R1SBOP,
                  r.R1TOPE  
                  into
                  ln_R2COD, 
                  ln_R2MOD, 
                  ln_R2SUC, 
                  ln_R2MDA, 
                  ln_R2PAP, 
                  ln_R2CTA, 
                  ln_R2OPER,
                  ln_R2SBOP,
                  ln_R2TOPE
            from fsr011 r
          where r.R2COD   = f.AQPB749pgc
            and r.R2MOD   = f.AQPB749mod
            and r.R2SUC   = f.AQPB749suc 
            and r.R2MDA   = f.AQPB749mda 
            and r.R2PAP   = f.AQPB749pap 
            and r.R2CTA   = f.AQPB749cta
            and r.R2OPER  = f.AQPB749ope
            and r.R2SBOP  = f.AQPB749sbo
            and r.R2TOPE  = f.AQPB749top
            and r.RELCOD  = 52;
          exception
             when no_data_found then
                        ln_R2CTA :=0;
          end;         
          if ( ln_R2CTA > 0 ) then 
            ln_scsdo117:=0;
            begin 
                select scsdo,scstat into ln_scsdo117, ln_aostat
                from fsd011  s
                inner join fsr011 d on d.R2COD    = s.pgcod
                                    and d.R2MOD   = s.scmod
                                    and d.R2SUC   = s.scsuc
                                    and d.R2MDA   = s.scmda
                                    and d.R2PAP   = s.scpap
                                    and d.R2CTA   = s.sccta
                                    and d.R2OPER  = s.scoper
                                    and d.R2SBOP  = s.scsbop
                                    and d.R2TOPE  = s.sctope
                where d.R1COD = ln_R2COD
                and d.R1MOD   = ln_R2MOD
                and d.R1SUC   = ln_R2SUC
                and d.R1MDA   = ln_R2MDA
                and d.R1PAP   = ln_R2PAP
                and d.R1CTA   = ln_R2CTA
                and d.R1OPER  = ln_R2OPER
                and d.R1SBOP  = ln_R2SBOP
                and d.R1TOPE  = ln_R2TOPE
                and d.RELCOD  = 46;
             exception
             when no_data_found then
                        ln_scsdo117 :=0;
                        ln_aostat :=0;
            end;
            if ( ln_scsdo117 < 0 )then
              ln_scsdo117 :=ln_scsdo117*-1;
             end if;
            if ( ln_scsdo116 < 0 )then
              ln_scsdo116 :=ln_scsdo116*-1;
             end if;      
            if (ln_aostat = 7 or ln_aostat=9) then
                update AQPB749
                set AQPB749EsLineBlq=1
                where AQPB749cta= f.AQPB749cta
                and AQPB749ope=f.AQPB749ope;
                commit;
            end if ;        
            if ( ln_scsdo117 < ln_scsdo116 ) then-- si saldo de línea es menor al saldo de la línea usada
               update AQPB749
                set AQPB749EsJLineam=1
                where AQPB749cta= f.AQPB749cta
                and AQPB749ope=f.AQPB749ope;
                commit;
            end if;
          end if;
        end if;
  end loop;
  --fin de validaciones
   --inicio bloquea
   for j in venta loop
     update fsd010
        set aostat = 9
      where pgcod  = j.AQPB749pgc
        and aomod  = j.AQPB749mod
        and aosuc  = j.AQPB749suc
        and aomda  = j.AQPB749mda
        and aopap  = j.AQPB749pap
        and aocta  = j.AQPB749cta
        and aooper = j.AQPB749ope
        and aosbop = j.AQPB749sbo
        and aotope = j.AQPB749top
        and aostat <> 99;     
     update fsd011
        set SCstat = 9
      where pgcod  = j.AQPB749pgc
        and scmod  = j.AQPB749mod
        and scsuc  = j.AQPB749suc
        and scmda  = j.AQPB749mda
        and scpap  = j.AQPB749pap
        and sccta  = j.AQPB749cta
        and scoper = j.AQPB749ope
        and scsbop = j.AQPB749sbo
        and sctope = j.AQPB749top
        and scstat <> 99
        and scsdo <>0;
     commit;
   end loop;  
   --fin de bloqueo      
  end sp_bloqueo;
procedure sp_desbloqueo( vn_ubuser varchar2   ) is
  cursor venta is       
    select b.AQPB749pgc,
           b.AQPB749mod,
           b.AQPB749suc,
           b.AQPB749mda,
           b.AQPB749pap,
           b.AQPB749cta,
           b.AQPB749ope,
           b.AQPB749sbo,
           b.AQPB749top,
           b.aqpb749sta
    from AQPB749 b;
  begin 
  for j in venta loop
     update fsd010
        set aostat = j.aqpb749sta 
      where pgcod  = j.AQPB749pgc
        and aomod  = j.AQPB749mod
        and aosuc  = j.AQPB749suc
        and aomda  = j.AQPB749mda
        and aopap  = j.AQPB749pap
        and aocta  = j.AQPB749cta
        and aooper = j.AQPB749ope
        and aosbop = j.AQPB749sbo
        and aotope = j.AQPB749top;
     update fsd011
        set SCstat = j.aqpb749sta 
      where pgcod  = j.AQPB749pgc
        and scmod  = j.AQPB749mod
        and scsuc  = j.AQPB749suc
        and scmda  = j.AQPB749mda
        and scpap  = j.AQPB749pap
        and sccta  = j.AQPB749cta
        and scoper = j.AQPB749ope
        and scsbop = j.AQPB749sbo
        and sctope = j.AQPB749top;   
     commit;
  end loop;   
  end sp_desbloqueo;
procedure sp_CreaJAQZ509( vn_ubuser varchar2   ) is
  cursor presta is       
    select b.AQPB749pgc,
           b.AQPB749mod,
           b.AQPB749suc,
           b.AQPB749mda,
           b.AQPB749pap,
           b.AQPB749cta,
           b.AQPB749ope,
           b.AQPB749sbo,
           b.AQPB749top,
           b.aqpb749sta
    from AQPB749 b;
    x number := 1;  
  begin 
  --Paso 1: Preparar tablas
  --create table operador.jaqz509_20190520 as   --select * from operador.jaqz509_20181126
  --select * from jaqz509;  --tabla que debe llenarse con la informacion de recuperaciones (excel).
  delete from jaqz509;
  commit;
  --Table que se llena en el proceso
  --create table operador.jaqz510_20190520 as
  --select * from jaqz510;  --tabla con pagos se llenara despues de ejecutar el proceso
  delete from jaqz510;
  commit;
  --Paso 2: Ingresar del excel los datos, Lote es el Nnum. de carga: carga 1 C1, carga 2 C2 para un mismo día
  --select * from jaqz509 for update;  
  begin 
    for j in presta loop
       insert into jaqz509 (lote,cuenta,operacion,modulo,nro) values
       ('C1',j.AQPB749cta,j.AQPB749ope,j.AQPB749mod, x ) ;
       commit;
       x:= x+1;
    end loop;  
  end;     

  --select * from jaqz511;  --GUIA DE PROCESO parametrizada con las transacciones que se consideran.   
  end sp_CreaJAQZ509;
  
  procedure sp_ObtienePagos( FECHA_FIN date ) is
    --Modificar FECHA_FIN 
    ln_numjob     number(9) := 0;
    lc_nomusr     varchar2(50);

    lc_prcsobend varchar2(500);
    ln_count number(10);
    ln_limit number(18);

    ln_indpro NUMBER(18);
    LNINI NUMBER ;
    LNFIN NUMBER ;
    lc_fecpro char(10);
    CADENA varchar2(2000);
    ln_job number := 0;
    NROCRE NUMBER  := 5000 ; 
    FECHA_INICIO DATE := '02/01/2002';--No modificar
   -- FECHA_FIN DATE := '21/12/2020';   -------FECHA_FIN Fecha que indican (dia o mes), dia anterior a ejecución
    lc_fecini char(10);
    lc_fecfin char(10);
    lc_variable varchar2(2000);
    lc_hostname varchar2(64);

  begin 
         execute immediate 'ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE';--ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE;
         execute immediate 'ALTER SESSION SET commit_wait=''NOWAIT''';
         execute immediate 'ALTER SESSION SET commit_logging=''BATCH''';

       SELECT max(t.NRO)  INTO ln_limit  FROM JAQZ509 t;  --56412
       
     begin
        select host_name
          into lc_hostname
          from v$instance;
      end;


        LNINI := 1; 
        LNFIN := 1;

       lc_fecini := to_char(FECHA_INICIO,'RRRR.MM.DD'); 
       lc_fecfin := to_char(FECHA_FIN,'RRRR.MM.DD'); 

                     
       FOR i IN 1 .. CEIL(ln_limit/NROCRE) LOOP
          
          LNINI  := LNFIN; 
          LNFIN  := LNFIN + NROCRE;
          ln_job := ln_job +1;
          lc_variable := 'begin          
                     pq_venta.SP_CR_PAGOS('||LNINI||','||LNFIN||',TO_DATE('''||lc_fecini||''',''RRRR.MM.DD'')'||',TO_DATE('''||lc_fecfin||''',''RRRR.MM.DD'') );'||' End;';
         
           
               
                if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
                           DBMS_JOB.SUBMIT(job => ln_job, 
                                        what => lc_variable,
                                        next_date => sysdate,
                                        interval => null,
                                        no_parse => false,
                                        instance => 2,
                                        force => false
                                        );
                      else
                           DBMS_JOB.SUBMIT(job => ln_job, 
                                        what => lc_variable,
                                        next_date => sysdate,
                                        interval => null,
                                        no_parse => false,
                                        force => false
                                        );
                          
                      end if;       
               
                         
         commit;
        END LOOP; 
        
        begin
            select TRIM(TP1DESC)
            INTO lc_nomusr
              from fst198
             where tp1cod = 1
               and tp1cod1 = 10847
               and tp1corr1 = 999 ; ---2019.07.22 guia de proceso para hostname
          end;
        
          begin
                
            SELECT count(*)
              INTO ln_numjob
              FROM dba_jobs x
             WHERE x.schema_user = lc_nomusr -- 'BANTPROD'
               AND upper(x.what) LIKE '%PQ_VENTA.SP_CR_PAGOS%';
          exception when others then
             ln_numjob := 0;
          end;

           While ln_numjob > 0 loop
              begin
                SELECT count(*)
                  INTO ln_numjob
                  FROM dba_jobs x
                 WHERE x.schema_user = lc_nomusr -- 'BANTPROD'
                   AND upper(x.what) LIKE '%PQ_VENTA.SP_CR_PAGOS%';
              exception when others then
                 ln_numjob := 0;
              end;
          End loop;
          
  end sp_ObtienePagos; 
  
  procedure sp_antesventa( vn_ubuser varchar2, FECHA_FIN date  ) is
  begin
    --ejecuta P2_01 
     begin
       -- Call the procedure
      pq_cr_ventacartera.sp_creajaqz509(vn_ubuser => vn_ubuser);
     end;
     --ejecuta P2_02
      begin
        -- Call the procedure
        pq_cr_ventacartera.sp_obtienepagos(fecha_fin => FECHA_FIN);
       end;
  end sp_antesventa;
   
  procedure sp_saldos_venta( lc_IND char ) is  
    --select sysdate, TO_CHAR(sysdate,'HH24') from dual;   
 
ln_hora number;
ln_cant number := 0;
lc_flag char(1);
ln_numjob     number(9) := 0;
lc_nomusr     varchar2(50);
lc_pac_nombre varchar2(100);
--lc_IND  char(1):= 'D'; --------------> Colocar "A" si se ejecuta antes de la venta V o "D" si se ejecuta despues venta

BEGIN
  
  select  TO_CHAR(sysdate,'HH24') into ln_hora from dual;  
  
  lc_flag := '';
  if ln_hora < 7 then
     update fst198 f  set TP1DESC = '06'  --ACTUALIZAR HORA DE LA VENTA
     where f.tp1cod=1 and f.tp1cod1=10872  and f.tp1corr1=14  and f.tp1corr2=1;--1reg
     
      update fst198 f  set TP1DESC = '06' --ACTUALIZAR HORA DE LA VENTA
      where f.tp1cod=1  and f.tp1cod1=10872 and f.tp1corr1=14 and f.tp1corr2=3; --1reg
      lc_flag := 'D'; --dia
      commit;
  else
    
      if ln_hora > 21 then
    
          update fst198 f  set TP1DESC = '23' --ACTUALIZAR HORA DE LA VENTA
          where f.tp1cod=1 and f.tp1cod1=10872 and f.tp1corr1=14 and f.tp1corr2=4 ; --1reg  --hora final para los 7 ultimos dias del mes ( hora 22) (posion en guia es (10872,14,4))
          
          update fst198 f  set TP1DESC = '23' --ACTUALIZAR HORA DE LA VENTA
          where f.tp1cod=1 and f.tp1cod1=10872 and f.tp1corr1=14 and f.tp1corr2=2 ; --1reg  --hora final para las fechas menores a 7 dias del fin del mes( hora 20) (posion en guia es (10872,14,2))
         lc_flag := 'N'; --noche
         commit;
      end if;
  
  end if;    

    ---generar backups
  --B -- PASOS PARA OBTENER SALDOS  ANTES VENTA
  ---->>>>>>>>>>>>>>>>>
      --3--Genera saldos en linea antes de VENTA verificar que no existan jobs ejecutandose
      begin
         select count(*) into ln_cant from JAQL983 where jaql983ffi is null; ---Debe ser igual a 0
      exception when others then
          ln_cant := 0;            
      end;
      
      if ln_cant > 0 then
         delete from JAQL983 where jaql983ffi is null;
         commit;
      end if;

      --3.1- Ejecutar proceso Saldos linea (tiempo estimado de ejecución 5 min máx.)
      begin
        pq_cr_saldos_linea.sp_cr_job_carga(pd_fecpro => trunc(sysdate) );
      end;

      --3.2---validar que culminen los jobs
      --select count(*) from DBA_JOBS where upper(what) like '%PQ_CR_SALDOS_LINEA.SP_CR_CARGA_DATOS_BC%';  --debe ser igual a 0


        begin
            select TRIM(TP1DESC)
            INTO lc_nomusr
              from fst198
             where tp1cod = 1
               and tp1cod1 = 10847
               and tp1corr1 = 999 ; ---2019.07.22 guia de proceso para hostname
          end;
        
          begin
                
            SELECT count(*)
              INTO ln_numjob
              FROM dba_jobs x
             WHERE x.schema_user = lc_nomusr -- 'BANTPROD'
               AND upper(x.what) LIKE '%PQ_CR_SALDOS_LINEA.SP_CR_CARGA_DATOS_BC%';
          exception when others then
             ln_numjob := 0;
          end;

           While ln_numjob > 0 loop
              begin
                SELECT count(*)
                  INTO ln_numjob
                  FROM dba_jobs x
                 WHERE x.schema_user = lc_nomusr -- 'BANTPROD'
                   AND upper(x.what) LIKE '%PQ_CR_SALDOS_LINEA.SP_CR_CARGA_DATOS_BC%';
              exception when others then
                 ln_numjob := 0;
              end;
    End loop;

      --3.4  CONSOLIDADO 
      insert into JAQL982V (jaql982vfec, jaql982vind, jaql982vscap, jaql982vscan, jaql982vscar, jaql982vscav, jaql982vscvp, 
                           jaql982vscvn, jaql982vscvr, jaql982vscaj, jaql982vscac, jaql982vscpv, jaql982vscp1)
      select trunc(sysdate), lc_ind,  sum(j.jaql982scap) CAPITAL, sum(j.jaql982scan), sum(j.jaql982scar), sum(j.jaql982scav) VENCIDO,
      sum(j.jaql982scvp) , sum(j.jaql982scvn), sum(j.jaql982scvr), sum(j.jaql982scaj) JUDICIAL, sum(j.jaql982scac) CASTIGADO,
      sum(j.jaql982scpv), sum(j.jaql982scp1)
       from jaql982 j;   --Cambiar la FECHA DDMMYYYY
      commit; 

     if  lc_flag = 'D' then
         update fst198 f  set TP1DESC = '07' where f.tp1cod=1 and f.tp1cod1=10872  and f.tp1corr1=14  and f.tp1corr2=1;--1reg --hora inicial para las fechas menores a 7 dias del fin del mes( hora 07) (posion en guia es (10872,14,1))         
         update fst198 f  set TP1DESC = '07' where f.tp1cod=1  and f.tp1cod1=10872 and f.tp1corr1=14 and f.tp1corr2=3; --1reg  --hora inicial para los 7 ultimos dias del mes ( hora 07) (posion en guia es (10872,14,3))   
         commit;
     else
        
          if lc_flag = 'N' then
              update fst198 f  set TP1DESC = '20' where f.tp1cod=1 and f.tp1cod1=10872 and f.tp1corr1=14 and f.tp1corr2=2 ; --1reg  --hora final para las fechas menores a 7 dias del fin del mes( hora 20) (posion en guia es (10872,14,2))
              update fst198 f  set TP1DESC = '22' where f.tp1cod=1 and f.tp1cod1=10872 and f.tp1corr1=14 and f.tp1corr2=4 ; --1reg  --hora final para los 7 ultimos dias del mes ( hora 22) (posion en guia es (10872,14,4))
              commit;
          end if;
      
      end if;    
  end sp_saldos_venta;
end pq_cr_ventacartera;
/

