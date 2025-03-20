create or replace package pq_cr_rec_ventaf is

  -- Author  : KVALENCIAC
  -- Created : 01/12/2022 
  -- Purpose : proceso mensual para obtener los sadldos al cierre de cada mes de los crèditos de FOCMA  
  --------------------------------------------------------------------------------------------
  procedure GeneraHilos( pn_propuesta number,pd_usuario char,pd_fecha date);
  --------------------------------------------------------------------------------------------
  procedure graba_JAQZ255F(pn_sucursal number,pn_propuesta number, pd_fecha date, pd_usuario char);
  --------------------------------------------------------------------------------------------
  procedure sp_saldos( pn_cod  in number,
                         pn_mod  in number,
                         pn_suc  in number,
                         pn_mda  in number,
                         pn_pap  in number,
                         pn_cta  in number,
                         pn_ope  in number,
                         pn_sbo  in number,
                         pn_top  in number,
                         pn_capital out number,
                         pn_interes out varchar
                         );
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                                                                       
  Function fn_cr_verifica_tarea(P_C_NOMJOB IN VARCHAR2,
                                P_C_HOSTNA IN VARCHAR2) return number;                                                                                                                                      
end pq_cr_rec_ventaf;
/

create or replace package body pq_cr_rec_ventaf is
procedure GeneraHilos(pn_propuesta number,pd_usuario char,pd_fecha date) is
    lc_variable2   varchar2(1000);
    ln_job2       number := 0;    
    lc_fecpro     char(10);
    lc_hostname   varchar2(64);
    pi_vc2_nomjob varchar2(65);
    lc_prefjob2    varchar2(64);   
    ln_numjob2     number(9) := 0;
    ln_suc     number(3);
    n_inst number;      
    cursor sucursal  is
    select *
        from fst001
       where pgcod = 1
         and sucurs < 800
          or sucurs >= 900;                
  begin
    begin
      select host_name into lc_hostname from v$instance;
    end;
    
    lc_fecpro := to_char(pd_fecha, 'RRRR.MM.DD');--  fecha de proceso
    ----------------------------------------------
    ln_job2        := 0;
    for a in sucursal  loop         
      ln_suc := a.sucurs; 
      ln_job2        := ln_job2 + 1;
      lc_prefjob2    := 'CAQPC433';   --  prefijo del nombre
      pi_vc2_nomjob := lc_prefjob2 || to_char(ln_suc) ||
                   'N' || to_char(ln_job2); ---  nombre del job
                  
      lc_variable2 := 'begin ' ||
                   ' pq_cr_rec_ventaf.graba_JAQZ255F('
                   || ln_suc 
                   || ',' 
                   || pn_propuesta
                   || ',TO_DATE(''' || lc_fecpro ||
                   ''',''RRRR.MM.DD''),'''|| pd_usuario ||''' ); ' || ' End;';
         
      --IF SYS.FN_BD_ISRAC = 'TRUE' THEN-- 02/09/2020 kdvc
--    Esta línea lo que hará es consultar si el Nodo 1 esta arriba (es el que se mantiene en la cadena de cierre) te devolverá 1, si no esta arriba preguntará si el Nodo 2 esta arriba y te devolverá 2
      select sys.FN_BD_NODO_CIERRE_JOB into n_inst from dual;--  02/09/2020 kdvc
      if n_inst in (1,2) then   --02/09/2020 kdvc
          dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                    job_type   => 'PLSQL_BLOCK',
                                    job_action => lc_variable2,
                                    start_date => sysdate, -- + 1 / (24 * 180),
                                    enabled    => true,
                                    auto_drop  => TRUE,
                                    comments   => 'Graba_JAQZ255F');
          begin
           -- dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 2);--  02/09/2020 kdvc
            dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', n_inst);--  02/09/2020 kdvc
          end;
       Else         
          dbms_scheduler.create_job(job_name   => pi_vc2_nomjob,
                                    job_type   => 'PLSQL_BLOCK',
                                    job_action => lc_variable2,
                                    start_date => sysdate, -- + 1 / (24 * 180),
                                    enabled    => true,
                                    auto_drop  => TRUE,
                                    comments   => 'Graba_JAQZ255F');
         --En caso la función de verde no devuelva ni 1 ni 2 no asignará un nodo específico para la ejecución: de Jobs, los lanzará en el nodo q encuentre activo, por eso comentar esta línea de asignación.
         /* begin --  02/09/2020 kdvc
            dbms_scheduler.set_attribute(pi_vc2_nomjob, 'instance_id', 1);  --  02/09/2020 kdvc
          end;*/  --  02/09/2020 kdvc
      End If;
      commit;
      
      INSERT INTO Tab_jobs
          (c_codage, c_dato1, c_detjob)
      VALUES
          ('CAQPC433', ln_suc, lc_variable2);
      COMMIT;
      
      end loop;
    ------------------Verificaciones que se haya terminado de ejecutar los jobs.
     ln_numjob2 := fn_cr_verifica_tarea(lc_prefjob2, lc_hostname);  
     While ln_numjob2 > 0 loop
        ln_numjob2 := fn_cr_verifica_tarea(lc_prefjob2, lc_hostname);
     End loop;     
end GeneraHilos;
----------------------------------------------------------------------------------------------------------------------------------------------------------------
procedure graba_JAQZ255F ( pn_sucursal number, pn_propuesta number, pd_fecha date, pd_usuario char ) is
    cursor listado (ln_sucursal in number) is
      select *
        from jaqy953 
        where jaqy952nro=pn_propuesta
        and jaqy953suc = ln_sucursal
        and jaqy953itc='S'; --solo se considera los contabilizados
    pn_emp     number(3);
    ln_EMP     number(3);
    ln_MOD     number(3);
    ln_SUC     number(3);
    ln_MDA     number(4);
    ln_PAP     number(4);
    ln_CTA     number(9);
    ln_OPE     number(9);
    ln_SBO     number(3);
    ln_TOP     number(3);        
    ln_jaqy952gru number;
    ln_periodo char(6);
    ln_jaqy953tdoc number(2);
    lc_tipodoc char(1);
    lc_jaqy953ndoc char(12);
    lc_penom char(30);
    ln_capital number(16,2);
    ln_interes number(9,2);
    ln_total number(16,2);
Begin  
    pn_emp := 1;  
    select concat(extract(year from pd_fecha),(case length(extract(month from pd_fecha)) when 1 then concat('0',extract(month from pd_fecha)) else to_char(extract(month from pd_fecha))end)) into ln_periodo from dual; 
    select jaqy952gru into ln_jaqy952gru from jaqy952 where jaqy952nro=pn_propuesta;
    for b in listado(pn_sucursal) loop
           ln_EMP:= b.jaqy953emp;
           ln_SUC:= b.jaqy953suc;
           ln_MDA:= b.jaqy953mda;
           ln_PAP:= b.jaqy953pap;
           ln_SBO:= b.jaqy953sbo;
           ln_TOP:= b.jaqy953top;
           ln_MOD:= b.jaqy953mod;
           ln_CTA:= b.jaqy953cta;
           ln_OPE:= b.jaqy953ope;
           ln_jaqy953tdoc := b.jaqy953tdoc;
           lc_jaqy953ndoc := b.jaqy953ndoc;
           if ( ln_jaqy953tdoc=21 ) then
             lc_tipodoc := 'D';
           else
             lc_tipodoc := 'R';
           end if;
           begin
             select penom into lc_penom from fsd001 where petdoc=ln_jaqy953tdoc and pendoc=lc_jaqy953ndoc;
           exception 
             when no_data_found then 
               lc_penom:='';
           end;
           --busca saldos         
            pq_cr_rec_ventaf.sp_saldos(     pn_cod => ln_EMP,
                                            pn_mod => ln_MOD ,
                                            pn_suc => ln_SUC ,
                                            pn_mda => ln_MDA ,
                                            pn_pap => ln_PAP ,
                                            pn_cta => ln_CTA ,
                                            pn_ope => ln_OPE,
                                            pn_sbo => ln_SBO ,
                                            pn_top => ln_TOP ,
                                            pn_capital => ln_capital,
                                            pn_interes => ln_interes
                                            );   
            ln_total:=ln_capital+ln_interes;
           insert into JAQZ255F
           ( jaqz255fcodtra,
             jaqz255fcodper,                         
            JAQZ255FNOMCLI,
            JAQZ255FTIPDOC,
            JAQZ255FNRODOC,
            JAQZ255FCTA,   
            JAQZ255FCODOPE,
            JAQZ255FMON,   
            JAQZ255FCAP,  
            JAQZ255FINT,   
            JAQZ255FTOT,   
            JAQZ255FTDOCAA,
            JAQZ255FNDOCAA,
            JAQZ255FDOCTAA,
            JAQZ255FUSR,
            JAQZ255FFECUPD)
            values
            (
            ln_jaqy952gru,
            ln_periodo,
            lc_penom,
            lc_tipodoc,
            lc_jaqy953ndoc,
            ln_CTA,
            ln_OPE,
            ln_MDA,
            ln_capital,
            ln_interes,
            ln_total,
            null,
            null,
            null,
            pd_usuario,
            pd_fecha
            );
            commit;      
      end loop;    
  end graba_JAQZ255F;
--------------------------------------------------------------------------------------------
procedure sp_saldos(     pn_cod  in number,
                         pn_mod  in number,
                         pn_suc  in number,
                         pn_mda  in number,
                         pn_pap  in number,
                         pn_cta  in number,
                         pn_ope  in number,
                         pn_sbo  in number,
                         pn_top  in number,
                         pn_capital out number,
                         pn_interes out varchar
                         )is
ln_Scrub number(16);
ln_RelInt number(9);
ln_interes number(16,2);                       
begin 
    --Capital
    begin 
      select Scsdo,Scrub into pn_capital,ln_Scrub from fsd011
      Where PGCOD  = pn_cod
        and SCCTA  = pn_cta
        and SCMOD  = 65
        and SCMDA  = pn_mda
        and SCPAP  = pn_pap
        and SCOPER = pn_ope
        and SCSBOP = pn_sbo
        and scstat <>99;
     exception
       when no_data_found then
         pn_capital :=0;
         ln_Scrub:=0;
     end;

      if (pn_capital<0) then
        pn_capital:=pn_capital* -1;        
      end if;
      
     --interes
     select Tp1nro1 into ln_RelInt from  FST198--:Guía Especial
     Where Tp1cod  =1
     and Tp1cod1  = 10897
     and Tp1corr1 = 12
	   and Tp1corr2 = 4
	   and Tp1corr3 =1; --Rel.Interés
    
     begin
       select f.Scsdo into ln_interes 
       from FSD011 f
       inner join fsr014 r on r.rrrubr=f.scrub and Rubro = ln_Scrub and Rrcod =ln_RelInt
       Where PgCod  = pn_cod
        --and f.Scrub  in (select Rrrubr from fsr014 where  Rubro = ln_Scrub and Rrcod =ln_RelInt )
        and f.Sccta  = pn_cta
        and f.Scoper = pn_ope
        and f.Scsbop = pn_sbo;
     exception
       when no_data_found then 
         ln_interes:=0;
     end;
      
     if ( ln_interes<0 ) then
       pn_interes:=ln_interes*-1;
     else
       pn_interes:=ln_interes;
     end if;
end sp_saldos;   
-------------------------------------------------------------------------------------------------
  Function fn_cr_verifica_tarea(P_C_NOMJOB IN VARCHAR2,
                                P_C_HOSTNA IN VARCHAR2) return number is                                
    ln_numjob number(9) := 0;
    lc_nomusr varchar2(50);
  
  begin
  
    begin
      select TRIM(TP1DESC)
        INTO lc_nomusr
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10847
         and tp1corr1 = 999; ---2019.07.22 guia de proceso para hostname
    end;
  
    begin
      SELECT COUNT(1)
        INTO ln_numjob
        FROM dba_scheduler_jobs job
       WHERE owner = lc_nomusr
         AND job.job_name LIKE P_C_NOMJOB || '%';
    end;
  
    return ln_numjob;
  end fn_cr_verifica_tarea;
-------------------------------------------------------------------------------------------------
end pq_cr_rec_ventaf;
/

