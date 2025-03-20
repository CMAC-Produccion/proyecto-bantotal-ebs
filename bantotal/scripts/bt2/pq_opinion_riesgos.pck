create or replace package pq_opinion_riesgos is
 
  function fn_cod_interno_pqn (pn_mod in number, pn_suc in number, pn_mda in number,
                             pn_pap in number, pn_cta in number, pn_oper in number,
                             pn_sbop in number,pn_top in number, pd_fecpro in date
) return number;
  function fn_mto_aprobado (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                        pn_pap in number, pn_cta in number, pn_oper in number,
                        pn_sbop in number,pn_top in number, pn_aoimp in number ) return number ;

  Function fn_pa_instancia(pn_mod in number, pn_suc in number, pn_mda in number,
                         pn_pap in number, pn_cta in number, pn_oper in number,
                         pn_sbop in number,pn_top in number) return number;
  function fn_des_analista (pn_instancia in number,pn_pais in number, 
                          pn_tdoc in number,pc_ndoc in char) return varchar2;
  function fn_monto_solic (pn_instancia in number) return number;
  Procedure sp_job_opinion_datos (pd_fecpro in varchar2 );
  Procedure sp_opinion_datos (pn_numsuc in number, pd_fecpro in varchar2 );
  Procedure sp_job_opinion_datos_II (pd_fecpro in varchar2 );
  Procedure sp_opinion_datos_II (pn_numsuc in number, pd_fecpro in varchar2 );
  function fn_saldo_a_tomar (ld_fecpro in date) 
                              return number;
  function fn_mda_mto_aprobado (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                        pn_pap in number, pn_cta in number, pn_oper in number,
                        pn_sbop in number,pn_top in number, /*pn_aoimp in number,*/pn_aomda in number ) return number;
   
                                                                                                                                                                          
end pq_opinion_riesgos;
/

create or replace package body pq_opinion_riesgos is

function fn_cod_interno_pqn (pn_mod in number, pn_suc in number, pn_mda in number,
                             pn_pap in number, pn_cta in number, pn_oper in number,
                             pn_sbop in number,pn_top in number, pd_fecpro in date
) return number
is
ln_codint number;
begin
  begin
    select /*+all rows*/distinct l.jaql101scl
      into ln_codint
      from jaql101 l 
      where l.jaql101pgc = 1
        and l.jaql101suc = pn_suc
        and l.jaql101mon = pn_mda
        and l.jaql101pap = pn_pap
        and l.jaql101cta = pn_cta
        and l.jaql101ope = pn_oper
        and l.jaql101sop = pn_sbop
        and l.jaql101top = pn_top
        and l.jaql101mod = pn_mod
        and l.jaql101fch = pd_fecpro
        AND l.jaql101cor = (SELECT MAX(jaql101cor) FROM jaql101 WHERE jaql101suc  = l.jaql101suc
        and jaql101mon = l.jaql101mon
        and jaql101pap = l.jaql101pap
        and jaql101cta = l.jaql101cta
        and jaql101ope = l.jaql101ope
        and jaql101sop = l.jaql101sop
        and jaql101top = l.jaql101top
        and jaql101mod = l.jaql101mod 
        AND jaql101fch = l.jaql101fch
        )
        and rownum = 1;
  exception 
      when others then 
         ln_codint := null;
  end;   
   return ln_codint;
end fn_cod_interno_pqn;


function fn_mto_aprobado (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                        pn_pap in number, pn_cta in number, pn_oper in number,
                        pn_sbop in number,pn_top in number, pn_aoimp in number ) return number is
ln_numcuo number;
begin
  begin
    if pn_mod = 108 then 
       ln_numcuo:=pn_aoimp;
    else
        
        select m.xllcapital
          into ln_numcuo
          from X054023 m 
         where m.xllpgcod  = pn_emp  
           and m.xllaocta  = pn_cta  
           and m.xllaooper = pn_oper 
           and m.xllaosbop = pn_sbop 
           and m.xllaotop  = pn_top 
           and m.xllaomod  = pn_mod  
           and m.xllaosuc  = pn_suc
           and m.xllaomda  = pn_mda
           and m.xllaopap  = pn_pap;
     end if;      
  exception 
      when no_data_found then 
        begin 
         select m.xllcapital
          into ln_numcuo
          from X054023 m 
         where m.xllpgcod  = pn_emp  
           and m.xllaocta  = pn_cta  
           and m.xllaooper = pn_oper 
           and m.xllaosuc  = pn_suc
           and m.xllaomda  = pn_mda
           and m.xllaopap  = pn_pap
           and rownum = 1;
        exception 
          when others then 
             ln_numcuo := null;
        end;    
      when too_many_rows then
         ln_numcuo := null;
  end;   
   return ln_numcuo;
end fn_mto_aprobado;


  

Function fn_pa_instancia(pn_mod in number, pn_suc in number, pn_mda in number,
                         pn_pap in number, pn_cta in number, pn_oper in number,
                         pn_sbop in number,pn_top in number) return number is
    -- *****************************************************************
    -- Nombre                     : 
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Actvias
    -- Versión                    : 1.0
    -- Fecha de Creación          : 
    -- Autor de Creación          : 
    -- Uso                        : Devuelve el tipo de analista
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Parámetros de Entrada      : pc_analista: asesor
    -- Parámetros de Salida       : tipo Analista: Convenio Pyme
    -- Fecha de Modificación      :
    -- Autor de la Modificación   :
    -- Descripción de Modificación:
    -- *****************************************************************
  ln_instancia number;        
  begin
    case when pn_mod = 116 then -- lineas buscar relacion 
            begin 
               select distinct d.xwfprcins 
                 into ln_instancia
                from fsr011 hh, xwf700 d 
                where relcod = 46
                       and hh.r2cod  = d.xwfempresa   
                       and hh.r2mod  = d.xwfmodulo
                       and hh.r2suc  = d.xwfsucursal
                       and hh.r2mda  = d.xwfmoneda
                       and hh.r2pap  = d.xwfpapel
                       and hh.r2cta  = d.xwfcuenta
                       and hh.r2oper = d.xwfoperacion
                       and hh.r2sbop = d.xwfsubope
                       and hh.r2tope = d.xwftipope
                       and hh.r1cod  = 1
                       and hh.r1mod  = pn_mod
                       and hh.r1suc  = pn_suc
                       and hh.r1mda  = pn_mda
                       and hh.r1pap  = pn_pap
                       and hh.r1cta  = pn_cta
                       and hh.r1oper = pn_oper
                       and hh.r1sbop = pn_sbop
                       and hh.r1tope = pn_top;
             exception
                when no_data_found then
                     begin 
                           select distinct d.xwfprcins 
                             into ln_instancia
                            from fsr011 hh, xwf700 d 
                            where relcod = 46
                                   and hh.r2cod  = d.xwfempresa   
                                   and hh.r2mod  = d.xwfmodulo
                                   and hh.r2suc  = d.xwfsucursal
                                   and hh.r2mda  = d.xwfmoneda
                                   and hh.r2pap  = d.xwfpapel
                                   and hh.r2cta  = d.xwfcuenta
                                   and hh.r2oper = d.xwfoperacion
                                   and hh.r2sbop = d.xwfsubope
                                   and hh.r2tope = d.xwftipope
                                   and hh.r1cod  = 1
                                   and hh.r1mod  = pn_mod
                                   and hh.r1suc  = pn_suc
                                   and hh.r1mda  = pn_mda
                                   and hh.r1pap  = pn_pap
                                   and hh.r1cta  = pn_cta
                                   and hh.r1oper = pn_oper
                                   --and hh.r1sbop = pn_sbop
                                   and hh.r1tope = pn_top;
                     exception
                        when no_data_found then
                                ln_instancia := null;
                        when too_many_rows then    
                            begin 
                                 select distinct d.xwfprcins 
                                   into ln_instancia
                                  from fsr011 hh, xwf700 d 
                                  where relcod = 46
                                         and hh.r2cod  = d.xwfempresa   
                                         and hh.r2mod  = d.xwfmodulo
                                         and hh.r2suc  = d.xwfsucursal
                                         and hh.r2mda  = d.xwfmoneda
                                         and hh.r2pap  = d.xwfpapel
                                         and hh.r2cta  = d.xwfcuenta
                                         and hh.r2oper = d.xwfoperacion
                                         and hh.r2sbop = d.xwfsubope
                                         and hh.r2tope = d.xwftipope
                                         and hh.r1cod  = 1
                                         and hh.r1mod  = pn_mod
                                         and hh.r1suc  = pn_suc
                                         and hh.r1mda  = pn_mda
                                         and hh.r1pap  = pn_pap
                                         and hh.r1cta  = pn_cta
                                         and hh.r1oper = pn_oper
                                         --and hh.r1sbop = pn_sbop
                                         and hh.r1tope = pn_top
                                         and rownum = 1;
                           exception
                                  when others then
                                          ln_instancia := null;
                           end; 
                     end; 
                when too_many_rows then    
                     ln_instancia := 0;
             end; 
         when pn_mod in (200,33) then -- cartera judicial, castigados
              begin
               select sol.xwfprcins 
                 into ln_instancia
                 from xwf700 sol   
               where sol.xwfmodulo   = pn_mod    
                 and sol.xwfsucursal = pn_suc 
                 and sol.xwfmoneda   = pn_mda 
                 and sol.xwfpapel    = pn_pap 
                 and sol.xwfcuenta   = pn_cta 
                 and sol.xwfoperacion= pn_oper
                 and sol.xwfsubope   = pn_sbop
                 and sol.xwftipope   = pn_top 
                 and sol.xwfcar3 = '1' ;
            exception
               when no_data_found then
                    begin
                       select xwfprcins 
                         into ln_instancia
                        from xwf700 sol  
                       where sol.xwfsucursal = pn_suc 
                         and sol.xwfmoneda   = pn_mda 
                         and sol.xwfpapel    = pn_pap 
                         and sol.xwfcuenta   = pn_cta 
                         and sol.xwfoperacion= pn_oper
                         and sol.xwfcar3 = '1' ;
                    exception
                       when no_data_found then
                          ln_instancia := null;
                       when too_many_rows then    
                           begin
                             select min(xwfprcins) 
                               into ln_instancia
                              from xwf700 sol  
                             where sol.xwfsucursal = pn_suc 
                               and sol.xwfmoneda   = pn_mda 
                               and sol.xwfpapel    = pn_pap 
                               and sol.xwfcuenta   = pn_cta 
                               and sol.xwfoperacion= pn_oper
                               and sol.xwfcar3 = '1' ;
                          exception
                             when no_data_found then
                                ln_instancia := null;
                             when too_many_rows then    
                                begin
                                   select min(xwfprcins) 
                                     into ln_instancia
                                    from xwf700 sol  
                                   where sol.xwfsucursal = pn_suc 
                                     and sol.xwfmoneda   = pn_mda 
                                     and sol.xwfpapel    = pn_pap 
                                     and sol.xwfcuenta   = pn_cta 
                                     and sol.xwfoperacion= pn_oper
                                     and sol.xwfcar3 = '1' 
                                     and rownum = 1;
                                exception
                                   when others then
                                      ln_instancia := null;
                                end;
                          end;
                    end;   
               
               when too_many_rows then    
                   begin
                     select min(xwfprcins)
                       into ln_instancia
                       from xwf700 sol  
                     where sol.xwfmodulo   = pn_mod    
                       and sol.xwfsucursal = pn_suc 
                       and sol.xwfmoneda   = pn_mda 
                       and sol.xwfpapel    = pn_pap 
                       and sol.xwfcuenta   = pn_cta 
                       and sol.xwfoperacion= pn_oper
                       and sol.xwfsubope   = pn_sbop
                       and sol.xwftipope   = pn_top 
                       and sol.xwfcar3 = '1' ;
                  exception
                     when no_data_found then
                        ln_instancia := null;
                     when too_many_rows then    
                         begin
                           select min(xwfprcins)
                             into ln_instancia
                             from xwf700 sol  
                           where sol.xwfmodulo   = pn_mod    
                             and sol.xwfsucursal = pn_suc 
                             and sol.xwfmoneda   = pn_mda 
                             and sol.xwfpapel    = pn_pap 
                             and sol.xwfcuenta   = pn_cta 
                             and sol.xwfoperacion= pn_oper
                             and sol.xwfsubope   = pn_sbop
                             and sol.xwftipope   = pn_top 
                             and sol.xwfcar3 = '1' 
                             and rownum = 1;
                        exception
                           when others then
                              ln_instancia := null;
                        end;
                  end;
            end;
         
         when pn_top = 550 then -- prejudicial con demanda
            begin
               select xwfprcins 
                 into ln_instancia
                from xwf700 sol  
               where sol.xwfmodulo   = pn_mod    
                 and sol.xwfsucursal = pn_suc 
                 and sol.xwfmoneda   = pn_mda 
                 and sol.xwfpapel    = pn_pap 
                 and sol.xwfcuenta   = pn_cta 
                 and sol.xwfoperacion= pn_oper
                 and sol.xwfsubope   = pn_sbop
                 and sol.xwftipope   = pn_top 
                 and sol.xwfcar3 = '1' ;
            exception
               when no_data_found then
                    begin
                       select xwfprcins 
                         into ln_instancia
                       from xwf700 sol   
                       where sol.xwfmodulo   = pn_mod    
                         and sol.xwfsucursal = pn_suc 
                         and sol.xwfmoneda   = pn_mda 
                         and sol.xwfpapel    = pn_pap 
                         and sol.xwfcuenta   = pn_cta 
                         and sol.xwfoperacion= pn_oper
                         and sol.xwfcar3 = '1' ;
                    exception
                       when no_data_found then
                          ln_instancia := null;
                       when too_many_rows then    
                           begin
                             select min(xwfprcins) 
                               into ln_instancia
                             from xwf700 sol   
                             where sol.xwfmodulo   = pn_mod    
                               and sol.xwfsucursal = pn_suc 
                               and sol.xwfmoneda   = pn_mda 
                               and sol.xwfpapel    = pn_pap 
                               and sol.xwfcuenta   = pn_cta 
                               and sol.xwfoperacion= pn_oper
                               and sol.xwfcar3 = '1' ;
                          exception
                             when no_data_found then
                                ln_instancia := null;
                             when too_many_rows then    
                                begin
                                   select min(xwfprcins) 
                                     into ln_instancia
                                   from xwf700 sol   
                                   where sol.xwfmodulo   = pn_mod    
                                     and sol.xwfsucursal = pn_suc 
                                     and sol.xwfmoneda   = pn_mda 
                                     and sol.xwfpapel    = pn_pap 
                                     and sol.xwfcuenta   = pn_cta 
                                     and sol.xwfoperacion= pn_oper
                                     and sol.xwfcar3 = '1' ;
                                exception
                                   when others then
                                      ln_instancia := null;
                                   
                                end;
                          end;
                    end;   
               
               when too_many_rows then    
                   begin
                     select min(xwfprcins) 
                       into ln_instancia
                      from xwf700 sol  
                     where sol.xwfmodulo   = pn_mod    
                       and sol.xwfsucursal = pn_suc 
                       and sol.xwfmoneda   = pn_mda 
                       and sol.xwfpapel    = pn_pap 
                       and sol.xwfcuenta   = pn_cta 
                       and sol.xwfoperacion= pn_oper
                       and sol.xwfsubope   = pn_sbop
                       and sol.xwftipope   = pn_top 
                       and sol.xwfcar3 = '1' ;
                  exception
                     when no_data_found then
                        ln_instancia := null;
                     when too_many_rows then    
                        begin
                         select min(xwfprcins) 
                           into ln_instancia
                          from xwf700 sol  
                         where sol.xwfmodulo   = pn_mod    
                           and sol.xwfsucursal = pn_suc 
                           and sol.xwfmoneda   = pn_mda 
                           and sol.xwfpapel    = pn_pap 
                           and sol.xwfcuenta   = pn_cta 
                           and sol.xwfoperacion= pn_oper
                           and sol.xwfsubope   = pn_sbop
                           and sol.xwftipope   = pn_top 
                           and sol.xwfcar3 = '1' 
                           and rownum = 1;
                        exception
                          when others then 
                            ln_instancia := null;
                        end;
                  end;
            end;
         
         else -- prestamos normales
            begin
               select xwfprcins 
                 into ln_instancia
                from xwf700 sol  
               where sol.xwfmodulo   = pn_mod    
                 and sol.xwfsucursal = pn_suc 
                 and sol.xwfmoneda   = pn_mda 
                 and sol.xwfpapel    = pn_pap 
                 and sol.xwfcuenta   = pn_cta 
                 and sol.xwfoperacion= pn_oper
                 and sol.xwfsubope   = pn_sbop
                 and sol.xwftipope   = pn_top 
                 and sol.xwfcar3 = '1' ;
            exception
               when no_data_found then
                  begin
                     select xwfprcins 
                       into ln_instancia
                      from xwf700 sol  
                     where sol.xwfmodulo   = pn_mod    
                       and sol.xwfsucursal = pn_suc 
                       and sol.xwfmoneda   = pn_mda 
                       and sol.xwfpapel    = pn_pap 
                       and sol.xwfcuenta   = pn_cta 
                       and sol.xwfoperacion= pn_oper
                       and sol.xwfsubope   = pn_sbop
                       and sol.xwftipope   = pn_top 
                       /*and sol.xwfcar3 = '1'*/ ;
                  exception
                    when others then
                       ln_instancia := null;
                  end;  
            
               when too_many_rows then    
                  begin
                     select min(xwfprcins) 
                       into ln_instancia
                      from xwf700 sol  
                     where sol.xwfmodulo   = pn_mod    
                       and sol.xwfsucursal = pn_suc 
                       and sol.xwfmoneda   = pn_mda 
                       and sol.xwfpapel    = pn_pap 
                       and sol.xwfcuenta   = pn_cta 
                       and sol.xwfoperacion= pn_oper
                       and sol.xwfsubope   = pn_sbop
                       and sol.xwftipope   = pn_top 
                       and sol.xwfcar3 = '1' ;
                  exception
                     when no_data_found then
                        ln_instancia := null;
                     when too_many_rows then    
                        begin
                           select min(xwfprcins) 
                             into ln_instancia
                            from xwf700 sol  
                           where sol.xwfmodulo   = pn_mod    
                             and sol.xwfsucursal = pn_suc 
                             and sol.xwfmoneda   = pn_mda 
                             and sol.xwfpapel    = pn_pap 
                             and sol.xwfcuenta   = pn_cta 
                             and sol.xwfoperacion= pn_oper
                             and sol.xwfsubope   = pn_sbop
                             and sol.xwftipope   = pn_top 
                             and sol.xwfcar3 = '1' 
                             and rownum = 1;
                        exception
                          when others then 
                             ln_instancia := null;
                        end;
                  end;
            end;
        end case;
     
    return ln_instancia;

  end fn_pa_instancia;



function fn_des_analista (pn_instancia in number,pn_pais in number, 
                          pn_tdoc in number,pc_ndoc in char) return varchar2 is
lc_desana varchar2(200);
begin
  begin
    select bb.ubnom
      into lc_desana
      from sng001 aa, fst746 bb
     where aa.sng001inst = pn_instancia
       and aa.sng001pais = pn_pais
       and aa.sng001tdoc = pn_tdoc
       and aa.sng001ndoc = pc_ndoc
       and bb.ubuser     = aa.sng001ase;
  exception 
      when too_many_rows then
           lc_desana := '2';
      when no_data_found then 
           lc_desana := null;
        
              
  end;   
    
   return lc_desana;
end fn_des_analista;
  
function fn_monto_solic (pn_instancia in number) return number is
ln_monto number;
begin
  begin
    select aa.sng120mto
      into ln_monto
      from sng120 aa
     where aa.sng120ins = pn_instancia
       and aa.sng120tsk = 'SOLICITUD'
       ;
  exception 
      when too_many_rows then
           ln_monto := null;
            
      when no_data_found then 
         ln_monto := null;
      
  end;   
    
   return ln_monto;
end fn_monto_solic;

Procedure sp_job_opinion_datos (pd_fecpro in varchar2) is
  --ln_max number;
  --ln_inc number;
  ln_ini number;
  --ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_hostname varchar2(64);
  --lc_coderr varchar2(300);
  cursor sucursal is 
  select sucurs from fst001 where pgcod =1 ;
  begin 
      begin
        select host_name
          into lc_hostname
          from v$instance;
      end;
     execute immediate ('truncate table CARTERAFM');
     delete Tab_jobs where  c_Codage = 'OPI';
     commit;
     for i in sucursal loop    
        ln_ini := i.sucurs;
        lc_variable := ' begin '|| '  pq_opinion_riesgos.sp_opinion_datos('||ln_ini||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
        ln_job := ln_job +1;
        --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
--        if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then   
--        if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
IF SYS.FN_BD_ISRAC='TRUE' THEN  
       DBMS_JOB.SUBMIT(job => ln_job, 
                      what => lc_variable,
                      next_date => sysdate+1/(24*180),
                      interval => null,
                      no_parse => false,
                      instance => 1,
                      --instance => 2, 01/01/2024
                      force => false
                      );
         else
           DBMS_JOB.SUBMIT(job => ln_job, 
                      what => lc_variable,
                      next_date => sysdate+1/(24*180),
                      interval => null,
                      no_parse => false,
                      force => false
                      );
           end if;
        INSERT INTO Tab_jobs (c_Codage,n_Numer1,c_detjob)
        VALUES('OPI',ln_ini,lc_variable);
        COMMIT;
      end loop; 
  exception
     when others then
           --lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'OPI',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

end sp_job_opinion_datos;
  
Procedure sp_opinion_datos (pn_numsuc in number, pd_fecpro in varchar2 ) is

ld_fecpro date ;
lc_coderr varchar2(300); 
cursor rubro is
  select rubro
    from fsd014
   where (pcnivc in
         (select modulo
            from fst111
           where dscod = 50
             and modulo not in (29, 120, 144,116/*, 33, 200*/)) --33 castigado , 200 judicial
              or pcnivc in (141, 117))
     and pcimpu = 'S'
     and pmtit <> 9;

begin

  update tab_jobs g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'OPI';
  commit;
  ld_fecpro := to_date(pd_fecpro,'yyyymmdd');


  for i in rubro loop
     begin 
       insert into CARTERAFM (
              INSTANCIA, BCRUBR,BCSDMN,BCEMP,BCMOD,BCSUC,BCMDA,BCPAP,BCCTA,BCOPER,
              BCSBOP,BCTOP,BCFVAL,BCFVTO,PEPAIS,PETDOC,PENDOC,TDNOM,AOIMP,BCFECH,
              PENOM,BCSDMO,AOPERIOD,
              AOSTAT,Bcgpo,BCSDUS,AOMDA)
       select/*+all_rows parallel(sal,2,1)*/ --jflor 23.01.2014
             pq_opinion_riesgos.fn_pa_instancia (sal.bcmod,sal.bcsuc,sal.bcmda,
             sal.bcpap,sal.bccta,sal.bcoper,sal.bcsbop,sal.bctop),
             sal.bcrubr,
             sal.bcsdmn, 
             sal.BCEMP,
             sal.bcmod,
             sal.bcsuc,
             sal.bcmda,
             sal.bcpap,
             sal.bccta,
             sal.bcoper,
             sal.bcsbop,
             sal.bctop,
             
             sal.bcfval,
             sal.bcfvto,
             cta.pepais,
             cta.petdoc,
             cta.pendoc, 
             
             tdo.tdnom,
             pre.aoimp,
             sal.bcfech,
             nom.penom,
             sal.bcsdmo,
             pre.aoperiod,
             pre.aostat,
             sal.bcgpo,
             sal.bcsdus,
             pre.aomda
             
        from fsh012 sal, fsr008 cta, fsd010 pre,
             fst014 tdo, fsd001 nom
       where sal.bcemp  = 1
         and sal.bcsuc  = pn_numsuc
         and sal.bcfech = ld_fecpro
         and sal.bcrubr = i.rubro
         and sal.bccta  = cta.ctnro
         and cta.pgcod  = 1
         and cta.cttfir = 'T'
         and cta.petdoc = tdo.tdocum
         and cta.pepais = nom.pepais
         and cta.petdoc = nom.petdoc
         and cta.pendoc = nom.pendoc
         and sal.bcemp  = pre.pgcod (+)   
         and sal.bcmod  = pre.aomod (+)  
         and sal.bcsuc  = pre.aosuc (+)  
         and sal.bcmda  = pre.aomda (+)   
         and sal.bcpap  = pre.aopap (+)  
         and sal.bccta  = pre.aocta (+)  
         and sal.bcoper = pre.aooper (+) 
         and sal.bcsbop = pre.aosbop (+) 
         and sal.bctop  = pre.aotope (+) 
         
         ;    
     exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'OPI',i.rubro||lc_coderr, TRUNC(SYSDATE));
           COMMIT;
     end;       
     commit;
  end loop; 
  commit;
  update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'OPI';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'OPI';
    commit;
    return;

end sp_opinion_datos;  

Procedure sp_job_opinion_datos_II (pd_fecpro in varchar2 ) is
  --ln_max number;
  --ln_inc number;
  ln_ini number;
  --ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_hostname varchar2(64);
  --lc_coderr varchar2(300);
  cursor sucursal is 
  select sucurs from fst001 where pgcod =1 ;
  begin 
        begin
        select host_name
          into lc_hostname
          from v$instance;
      end;
     execute immediate ('truncate table reportes');
     delete Tab_jobs where  c_Codage = 'OPID';
     commit;
     for i in sucursal loop    
        ln_ini := i.sucurs;
        lc_variable := ' begin '|| '  pq_opinion_riesgos.sp_opinion_datos_II('||ln_ini||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
        ln_job := ln_job +1;
        --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
--if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then   
--if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
IF SYS.FN_BD_ISRAC='TRUE' THEN
         DBMS_JOB.SUBMIT(job => ln_job, 
                      what => lc_variable,
                      next_date => sysdate+1/(24*180),
                      interval => null,
                      no_parse => false,
                      instance => 1,
                      --instance => 2, 01/01/2024
                      force => false
                      );
else
   DBMS_JOB.SUBMIT(job => ln_job, 
                      what => lc_variable,
                      next_date => sysdate+1/(24*180),
                      interval => null,
                      no_parse => false,
                      force => false
                      );
  end if;
        INSERT INTO Tab_jobs (c_Codage,n_Numer1,c_detjob)
        VALUES('OPID',ln_ini,lc_variable);
        COMMIT;
      end loop; 
  exception
     when others then
           --lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'OPID',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

end sp_job_opinion_datos_II;
  
Procedure sp_opinion_datos_II (pn_numsuc in number, pd_fecpro in varchar2 ) is

ld_fecpro date;

lc_coderr varchar2(300); 
cursor rubro is
  select rubro
    from fsd014
   where (pcnivc in
         (select modulo
            from fst111
           where dscod = 50
             and modulo not in (29, 120, 144,116/*, 33, 200*/)) --33 castigado , 200 judicial
              or pcnivc in (141, 117))
     and pcimpu = 'S'
     and pmtit <> 9;
begin

  update tab_jobs g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'OPID';
  commit;
  ld_fecpro := to_date(pd_fecpro,'yyyymmdd');
  
    for i in rubro loop
     begin 
     
       insert into reportes (instancia,bcemp,bcmod,bcsuc,bcmda,bcpap,bccta,
                             bcoper,bcsbop,bctop,bcfval,bcfvto,pepais,
                             petdoc,pendoc,tdnom,aoimp,scnom,des_ana,
                             nro_credito,bcgpo,penom,bcsdmo,n_tippeq,
                             monto_solic,origen,monto_aprobado,bcsdmn,
                             bcsdus,bcrubr,mda_mto_aprob,tipo_credito_sbs)
            select INSTANCIA,bcemp, BCMOD,BCSUC,BCMDA,BCPAP,
                   BCCTA,BCOPER,BCSBOP,BCTOP,BCFVAL,
                   BCFVTO,PEPAIS,PETDOC,PENDOC,TDNOM,AOIMP,scnom,
                   
                   
                   pq_opinion_riesgos.fn_des_analista(instancia,pepais,petdoc,pendoc),
                   
                                    
                   (lpad(to_char(bccta), 9, '0') || lpad(to_char(bcmod), 3, '0') ||
                   lpad(to_char(bcmda), 3, '0') || lpad(to_char(bcoper), 9, '0') ||
                   lpad(to_char(bctop), 3, '0')) Nro_Credito,
                   --a.scnom,
                  
                   t.bcgpo,
                   penom,
                   case 
                       when t.bcmod = 117 then (bcsdmo*-1)
                       else bcsdmo
                   end,
                   pq_opinion_riesgos.fn_cod_interno_pqn(bcmod,bcsuc,bcmda,bcpap,bccta,
                                                       bcoper,bcsbop,bctop,ld_fecpro),
                   pq_opinion_riesgos.fn_monto_solic(instancia),
                   (select m.sng001ori 
                     from sng001 m where m.sng001inst = instancia )  ,
                   pq_opinion_riesgos.fn_mto_aprobado (bcemp,bcmod,bcsuc,bcmda,bcpap,
                                                     bccta,bcoper,bcsbop,bctop,aoimp),
                   case 
                       when t.bcmod = 117 then (t.bcsdmn*-1)
                       else bcsdmn
                   end,
                   case 
                       when t.bcmod = 117 then (t.bcsdus*-1)
                       else bcsdus
                   end,                                 
                   
                   t.bcrubr,
                   pq_opinion_riesgos.fn_mda_mto_aprobado (bcemp,bcmod,bcsuc,bcmda,bcpap,
                                                     bccta,bcoper,bcsbop,bctop,/*aoimp,*/aomda),
                   Case When Substr(t.bcrubr, 1, 2) = '14' and
                             Substr(t.bcrubr, 5, 2) = '02' then 'MICRO'
                        When Substr(t.bcrubr, 1, 2) = '14' and
                             Substr(t.bcrubr, 5, 2) = '03' then 'CONSUMO'
                        When Substr(t.bcrubr, 1, 2) = '14' and
                             Substr(t.bcrubr, 5, 2) = '04' then 'HIPOTECARIO'
                        When Substr(t.bcrubr, 1, 2) = '14' and
                             Substr(t.bcrubr, 5, 2) = '12' then 'MEDIANA'
                        When Substr(t.bcrubr, 1, 2) = '14' and
                             Substr(t.bcrubr, 5, 2) = '13' then 'PEQUEÑA'
                        When Substr(t.bcrubr,1,2) in ('71','72') and 
                             Substr(t.bcrubr,7,2) = '02' then 'MICRO'
                        When Substr(t.bcrubr,1,2) in ('71','72') and 
                             Substr(t.bcrubr,7,2) = '03' then 'CONSUMO'
                        When Substr(t.bcrubr,1,2) in ('71','72') and 
                             Substr(t.bcrubr,7,2) = '04' then 'HIPOTECARIO'
                        When Substr(t.bcrubr,1,2) in ('71','72') and 
                             Substr(t.bcrubr,7,2) = '12' then 'MEDIANA'
                        When Substr(t.bcrubr,1,2) in ('71','72') and 
                             Substr(t.bcrubr,7,2) = '13' then 'PEQUEÑA'     
                        Else ''
                   End                 
                    
                      from carterafm t, fst001 l
                     where t.bcsuc = pn_numsuc
                       and t.bcrubr = i.rubro
                       and t.bcsuc = l.sucurs
                       and l.pgcod = t.bcemp
                    ;
         commit;        
     exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'OPID',pn_numsuc||lc_coderr, TRUNC(SYSDATE));
           COMMIT;
     end;       
     commit;
  end loop;
  commit;
  update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'OPID';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'OPID';
    commit;
    return;

end sp_opinion_datos_II; 



function fn_saldo_a_tomar (ld_fecpro in date) 
                              return number is

ln_result number;
ln_cotcbi number;

begin
  
  begin
       begin
          select g.cotcbi
              into ln_cotcbi       
              from fsh005 g 
             where g.moneda = 101 
               and g.cofdes = ld_fecpro; 
       exception 
       
            when others then
                 ln_cotcbi := null;
       end;
  
       if 40000 * ln_cotcbi < 120000 then
             ln_result := 40000;
          else
             ln_result := 120000;
       end if;
          
             
           
  exception 
      when others then
           ln_result := null;
       
      
  end;   
    
   return ln_result;
end fn_saldo_a_tomar;

function fn_mda_mto_aprobado (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                              pn_pap in number, pn_cta in number, pn_oper in number,
                              pn_sbop in number,pn_top in number, /*pn_aoimp in number,*/pn_aomda in number ) return number is
ln_numcuo number;
begin
  begin
    if pn_mod = 108 then 
       ln_numcuo := pn_aomda;
    else
        
        select m.xllaomda
          into ln_numcuo
          from X054023 m 
         where m.xllpgcod  = pn_emp  
           and m.xllaocta  = pn_cta  
           and m.xllaooper = pn_oper 
           and m.xllaosbop = pn_sbop 
           and m.xllaotop  = pn_top 
           and m.xllaomod  = pn_mod  
           and m.xllaosuc  = pn_suc
           and m.xllaomda  = pn_mda
           and m.xllaopap  = pn_pap;
     end if;      
  exception 
      when no_data_found then 
        begin 
         select m.xllaomda
          into ln_numcuo
          from X054023 m 
         where m.xllpgcod  = pn_emp  
           and m.xllaocta  = pn_cta  
           and m.xllaooper = pn_oper 
           and m.xllaosuc  = pn_suc
           and m.xllaomda  = pn_mda
           and m.xllaopap  = pn_pap
           and rownum = 1;
        exception 
          when others then 
             ln_numcuo := null;
        end;    
      when too_many_rows then
         ln_numcuo := null;
  end;   
   return ln_numcuo;
end fn_mda_mto_aprobado;

 

end pq_opinion_riesgos;
/

