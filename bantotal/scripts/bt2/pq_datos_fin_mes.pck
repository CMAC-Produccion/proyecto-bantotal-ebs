create or replace package pq_datos_fin_mes is
 
  function fn_codsbs (pn_pepais in number,pn_petdoc in number, pc_pendoc in varchar2,pn_cta in number) return varchar2;
  function fn_cod_interno_pqn (pn_mod in number, pn_suc in number, pn_mda in number,
                             pn_pap in number, pn_cta in number, pn_oper in number,
                             pn_sbop in number,pn_top in number, pd_fecpro in date
) return number;
  Procedure sp_job_tipifica_datos (pd_fecpro in varchar2 );
  Procedure sp_job_tipifica_datos_II (pd_fecpro in varchar2 );
  Procedure sp_tipificacion_datos_II (pn_numsuc in number, pd_fecpro in varchar2 ); 
  function fn_ope_sorfy (pn_mod in number, pn_suc in number, pn_mda in number,
                       pn_pap in number, pn_cta in number, pn_oper in number,
                       pn_sbop in number,pn_top in number) return varchar2;
  Procedure sp_tipificacion_datos (pn_numsuc in number, pd_fecpro in varchar2 );

  
  function fn_mto_aprobado (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                        pn_pap in number, pn_cta in number, pn_oper in number,
                        pn_sbop in number,pn_top in number, pn_aoimp in number ) return number ;

  Function fn_pa_instancia(pn_mod in number, pn_suc in number, pn_mda in number,
                         pn_pap in number, pn_cta in number, pn_oper in number,
                         pn_sbop in number,pn_top in number) return number;
  /*Function fn_instancia_original(pn_mod in number, pn_suc in number, pn_mda in number,
                         pn_pap in number, pn_cta in number, pn_oper in number,
                         pn_top in number) return number ;*/
  Procedure sp_job_diasmora_datos (pd_fecpro in varchar2 );
  Procedure sp_diasmora_datos (pn_numsuc in number, pd_fecpro in varchar2 );
  
  Procedure sp_job_tipifica_prueba_datos (pd_fecpro in varchar2 );
  Procedure sp_tipificacion_prueba_datos (pn_numsuc in number, pd_fecpro in varchar2 );
  
  function fn_categoria (pn_emp in number, pn_cta in number, pd_feccat in date, pn_codcat in number ) return varchar2;
  function fn_nro_cuotas (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                        pn_pap in number, pn_cta in number, pn_oper in number,
                        pn_sbop in number,pn_top in number ) return number ;
  function fn_Valor_cuotas (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                        pn_pap in number, pn_cta in number, pn_oper in number,
                        pn_sbop in number,pn_top in number ) return number ;                        
  function fn_Fec_Proximo_vto (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                             pn_pap in number, pn_cta in number, pn_oper in number,
                             pn_sbop in number,pn_top in number, pd_fecpro in date ) return date ;
  function fn_Fec_Ultimo_pago (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                             pn_pap in number, pn_cta in number, pn_oper in number,
                             pn_sbop in number,pn_top in number, pd_fecpro in date ) return date;
  function fn_dias_gracia (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                        pn_pap in number, pn_cta in number, pn_oper in number,
                        pn_sbop in number,pn_top in number ) return number;                       
    

  /*Procedure sp_job_riegos_datos (pd_fecpro in varchar2, pn_tiprep in number );
  Procedure sp_riesgos_datos (pn_numsuc in number, pd_fecpro in varchar2, pn_tiprep in number );*/
  function fn_provincia (pn_pais in number, pn_tdoc in number,pc_ndoc in char ) return varchar2 ;
  function fn_actividad (pn_pais in number, pn_tdoc in number,pc_ndoc in char ) return varchar2 ;
  function fn_cod_activ (pn_pais in number, pn_tdoc in number,pc_ndoc in char ) return number;
  function fn_prides (pn_instancia in number, pn_cta in number, pn_oper  in number,
   pn_suc number, pn_mda number, pn_pap number, pn_mod number, pn_toper in number ) return date ;
  function fn_reprogramado (pn_mod in number, pn_suc in number, pn_mda in number,
                          pn_pap in number, pn_cta in number, pn_oper in number,
                          pn_sbop in number,pn_top in number ) return number ;
  /*Procedure sp_job_rsg_creditos (pd_fecpro in varchar2 );
  Procedure sp_rsg_creditos (pn_numsuc in number, pd_fecpro in varchar2 );           */               
  
  
  
  Procedure sp_job_desgrava_datos (pd_fecpro in varchar2 ) ;
  Procedure sp_desgrava_datos (pn_numsuc in number, pd_fecpro in varchar2 );
  
  Procedure sp_job_desgravamen_II (pd_fecpro in varchar2 );
  Procedure sp_desgravamen_II (pn_numsuc in number, pd_fecpro in varchar2 );
  
  function fn_tipo_rep (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                      pn_pap in number, pn_cta in number, pn_oper in number,pn_sbop in number,
                      pn_top in number, pd_fecpro in date,pn_instancia in number,pd_ffecnac in date,
                      pc_tiper in char, pn_pais in number, pn_tdoc in number, pn_ndoc in number,
                      pd_fecnotit in date) return varchar2 ;      
  function fn_cr_years(P_D_FECPRO in date,P_D_FECNAC in date) return number ;
  function fn_tipcamb(PD_FECPRO in date,PD_LIMITE in NUMBER) return number;
  
  function fn_producto(PD_MOD in number,PD_TOP in NUMBER) return varchar2 ;
  function fn_nomtit(PD_PAIS in number,PD_TDOC in NUMBER, PD_NDOC in number) return varchar2 ;
  function fn_fecnac_nomtit(PD_PAIS in number,PD_TDOC in NUMBER, PD_NDOC in number) return date;
  
  Procedure sp_job_cartera_datos (pd_fecpro in varchar2 );
  Procedure sp_cartera_datos (pn_numsuc in number, pd_fecpro in varchar2 );
  Procedure sp_cartera_datos_II (pn_numsuc in number, pd_fecpro in varchar2 );
  Procedure sp_job_cartera_datos_II (pd_fecpro in varchar2 );
  Procedure sp_job_direcciones_datos(pd_fecpro in varchar2 );
  Procedure sp_direcciones_datos (pn_numsuc in number, pd_fecpro in varchar2 );
  
  Procedure sp_job_adicionales_datos(pd_fecpro in varchar2 );
  Procedure sp_adicionales_datos (pn_numsuc in number, pd_fecpro in varchar2 ) ;
  function fn_importe_garantia (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                             pn_pap in number, pn_cta in number, pn_oper in number,
                             pn_sbop in number,pn_top in number, pn_saldo in number) return number;
  function fn_moneda_garantia (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                             pn_pap in number, pn_cta in number, pn_oper in number,
                             pn_sbop in number,pn_top in number) return number;
  function fn_des_garantia (pn_mod in number,pn_top in number) return varchar2;
                               
  function fn_direccion_N (pn_pais in number, pn_tdoc in number,pc_ndoc in char ) return varchar2 ;
  function fn_ref_N (pn_pais in number, pn_tdoc in number,pc_ndoc in char ) return varchar2 ;
  function fn_provincia_N (pn_pais in number, pn_tdoc in number,pc_ndoc in char ) return varchar2;
  function fn_departamento_N (pn_pais in number, pn_tdoc in number,pc_ndoc in char ) return varchar2 ;
  function fn_distrito_N (pn_pais in number, pn_tdoc in number,pc_ndoc in char ) return varchar2 ;
  function fn_direccion_T (pn_pais in number, pn_tdoc in number,pc_ndoc in char ) return varchar2 ;
  function fn_ref_T (pn_pais in number, pn_tdoc in number,pc_ndoc in char ) return varchar2 ;
  function fn_provincia_T (pn_pais in number, pn_tdoc in number,pc_ndoc in char ) return varchar2 ;
  function fn_departamento_T (pn_pais in number, pn_tdoc in number,pc_ndoc in char ) return varchar2 ;
  function fn_distrito_T (pn_pais in number, pn_tdoc in number,pc_ndoc in char ) return varchar2 ;
  function fn_negocio (pn_pais in number, pn_tdoc in number,pc_ndoc in char ) return varchar2 ;  
  function fn_aval_tdoc (pn_instancia in number) return varchar2 ;
  function fn_aval_ndoc (pn_instancia in number) return number ;
  function fn_aval_nombre (pn_instancia in number) return varchar2 ;
  function fn_conyugue_nombre (pn_instancia in number) return varchar2 ;
  function fn_conyugue_tdoc (pn_instancia in number) return varchar2 ;
  function fn_conyugue_ndoc (pn_instancia in number) return varchar2;
  Procedure sp_job_avales_datos(pd_fecpro in varchar2 ) ;
  Procedure sp_avales_datos (pn_numsuc in number, pd_fecpro in varchar2 );
  function fn_direccion_aval (pn_cta in number) return varchar2 ;
  function fn_ref_aval (pn_cta in number) return varchar2;
  function fn_provincia_aval (pn_cta in number) return varchar2 ;
  function fn_departamento_aval (pn_cta in number) return varchar2;
  function fn_distrito_aval (pn_cta in number) return varchar2;
  
  Procedure sp_job_Equifax_datos (pd_fecpro in varchar2 );
  Procedure sp_equifax_datos (pn_numsuc in number, pd_fecpro in varchar2 );
  Procedure sp_job_equifax_datos_II (pd_fecpro in varchar2 );
  Procedure sp_equifax_datos_II (pn_numsuc in number, pd_fecpro in varchar2 );
  function fn_est_sol (pn_instancia in number) return varchar2;
  function fn_causal (pn_instancia in number) return varchar2;
  function fn_meses (pn_mes in char) return varchar2;
  function fn_cod_analista (pn_instancia in number,pn_pais in number, 
                          pn_tdoc in number,pc_ndoc in char) return varchar2;
  function fn_des_analista (pn_instancia in number,pn_pais in number, 
                          pn_tdoc in number,pc_ndoc in char) return varchar2;
  function fn_monto_solic (pn_instancia in number) return number;
  function fn_pzo_solic (pn_instancia in number) return number;         
  
  
  Procedure sp_job_cambiario_datos (pd_fecpro in varchar2 );
  Procedure sp_cambiario_datos (pn_numsuc in number, pd_fecpro in varchar2 );
  Procedure sp_job_cambiario_datos_II (pd_fecpro in varchar2 );
  Procedure sp_cambiario_datos_II (pn_numsuc in number, pd_fecpro in varchar2 ) ;
  function fn_listas_negras (pn_pais in number, 
                          pn_tdoc in number,pc_ndoc in char) return varchar2;
  function fn_cuotas_pendientes (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                             pn_pap in number, pn_cta in number, pn_oper in number,
                             pn_sbop in number,pn_top in number, pd_fecpro in date ) return number ;
  function fn_riesgo_cambiario (pn_resul_sol in number,pn_resul_dol in number,
                              pn_moneda in number, pn_monto in number,pn_resul_socio_sol in number,
                              pn_resul_socio_dol in number) 
                              return char;                                                       
  
  Procedure sp_job_opinion_datos (pd_fecpro in varchar2 );
  Procedure sp_opinion_datos (pn_numsuc in number, pd_fecpro in varchar2 );
  Procedure sp_job_opinion_datos_II (pd_fecpro in varchar2 );
  Procedure sp_opinion_datos_II (pn_numsuc in number, pd_fecpro in varchar2 );
  Procedure sp_job_opinion_datos_III (pd_fecpro in varchar2 );
  Procedure sp_opinion_datos_III (pn_numsuc in number, pd_fecpro in varchar2 ) ;
  function fn_saldo_a_tomar (pn_tipo_cambio in number) 
                              return number;
  function fn_mda_mto_aprobado (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                        pn_pap in number, pn_cta in number, pn_oper in number,
                        pn_sbop in number,pn_top in number, pn_aoimp in number,pn_aomda in number ) return number;
   
  function fn_evaluacion (pn_instancia in number, pn_codigo in number, pn_tipo in number) 
                       return number;
  Procedure sp_job_evaluacion_datos(pd_fecpro in varchar2 );
  Procedure sp_evaluacion_datos (pn_numsuc in number, pd_fecpro in varchar2 );     
  function fn_ordinal (pn_emp in number, pn_mod in number, pn_suc in number, pn_trn in number,
                     pn_nrel in number, pd_fec in date) return number;
  /*function fn_ordinal (pn_emp in number, pn_mod in number, pn_suc in number, pn_trn in number,
                     pn_nrel in number, pd_fecini in date,pd_fecfin in date) return number;    */ 
  function fn_judicial (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                      pn_pap in number, pn_cta in number, pn_oper in number,
                      pn_sbop in number,pn_top in number) return char;
  function fn_ubigeo_T (pn_pais in number, pn_tdoc in number,pc_ndoc in char ) return number ;
  function fn_cuotas_pagadas (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                             pn_pap in number, pn_cta in number, pn_oper in number,
                             pn_sbop in number,pn_top in number, pd_fecpro in date ) return number;
  function fn_plazo (pn_instancia in number) return number;
  Procedure sp_job_movigas_datos (pd_fecpro in varchar2 ) ;
  Procedure sp_movigas_datos (pn_numsuc in number, pd_fecpro in varchar2 );
  Procedure sp_job_movigas_datos_II (pd_fecpro in varchar2 );
  Procedure sp_movigas_datos_II (pn_numsuc in number, pd_fecpro in varchar2 ) ;   
  
  function fn_promedio (ld_fecfin in varchar2) return number;    
  function fn_marca_vehiculo (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                             pn_pap in number, pn_cta in number, pn_oper in number,
                             pn_sbop in number,pn_top in number) return varchar2;      
                             
  function fn_tiene_evaluacion (instancia in number) return char;
  
function fn_valor_cuota_al_mes (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                                pn_pap in number, pn_cta in number, pn_oper in number,
                                pn_sbop in number,pn_top in number, pd_fecpro in date ) return number;
  function fn_concesionario (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                             pn_pap in number, pn_cta in number, pn_oper in number,
                             pn_sbop in number,pn_top in number) return varchar2;          
                             
  function fn_ordinal_sin_relacion (pn_emp in number, pn_mod in number, pn_suc in number, pn_trn1 in number,
                                  pn_trn2 in number,pd_fec in date) return number;          
  
  Procedure sp_job_riegos_datos (pd_fecpro in varchar2, pn_tiprep in number ) ;
  Procedure sp_riesgos_datos (pn_numsuc in number, pd_fecpro in varchar2, pn_tiprep in number );                                                                                                                                                                                            
  Procedure sp_job_rsg_creditos (pd_fecpro in varchar2 ) ;
  Procedure sp_rsg_creditos (pn_numsuc in number, pd_fecpro in varchar2 );
end pq_datos_fin_mes;
/

create or replace package body pq_datos_fin_mes is

function fn_codsbs (pn_pepais in number,pn_petdoc in number, pc_pendoc in varchar2, pn_cta in number) return varchar2
is
lc_codsbs varchar2(10);
begin
  begin
    
    select lpad(to_char(c.bc739sbs),10,0) 
      into lc_codsbs
      from  fbc739 c
     where c.bc739pais = pn_pepais
       and c.bc739tdoc = pn_petdoc
       and c.bc739ndoc = pc_pendoc
       and c.bc739cta  = pn_cta;
  exception 
      when others then 
         lc_codsbs := null;
  end;   
   return lc_codsbs;
end fn_codsbs;

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

function fn_ope_sorfy (pn_mod in number, pn_suc in number, pn_mda in number,
                       pn_pap in number, pn_cta in number, pn_oper in number,
                       pn_sbop in number,pn_top in number) return varchar2 is
lc_cresor varchar2(17);
begin
  begin
     Select q.bnj096sor 
       into lc_cresor
       from bnj096 q 
      where /*q.bnj096suc = pn_suc
        and*/ q.bnj096mda = pn_mda
        and q.bnj096pap = pn_pap
        and q.bnj096cta = pn_cta
        and q.bnj096ope = pn_oper;
        --and q.bnj096sub = a.hasbop
        --and q.bnj096mod = a.hamod
        --and q.bnj096top = a.hatope
  exception 
      when no_data_found then 
         lc_cresor := null;
      when too_many_rows then
         lc_cresor := '2';
  end;   
   return lc_cresor;
end fn_ope_sorfy;

Procedure sp_job_tipifica_datos (pd_fecpro in varchar2 ) is
  ln_max number;
  ln_inc number;
  ln_ini number;
  ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_coderr varchar2(300);
  lc_hostname varchar2(64);
  cursor sucursal is 
  select sucurs from fst001 where pgcod =1 ;
  begin 
      begin
    select host_name
          into lc_hostname
          from v$instance;
      end;
     execute immediate ('truncate table CARTERAFM');
     delete Tab_jobs where  c_Codage = 'TIPI';
     commit;
     for i in sucursal loop    
        ln_ini := i.sucurs;
        lc_variable := ' begin '|| '  pq_datos_fin_mes.sp_tipificacion_datos('||ln_ini||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
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
        VALUES('TIPI',ln_ini,lc_variable);
        COMMIT;
      end loop; 
  exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'TIPIFI',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

  end;
  
Procedure sp_tipificacion_datos (pn_numsuc in number, pd_fecpro in varchar2 ) is

ld_fecpro date ;
lc_coderr varchar2(300); 
cursor rubro is 
  select rubro
    from fsd014
   where (pcnivc in
         (select modulo
            from fst111
           where dscod = 50
             and modulo not in (29, 120, 144, 33, 200)) --33 castigado , 200 judicial
              or pcnivc in (141, 117))
     and pcimpu = 'S'
     and pmtit <> 9;
ld_fecant date;
begin

  update tab_jobs g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'TIPI';
  commit;
  ld_fecpro := to_date(pd_fecpro,'yyyymmdd');
  ld_fecant := ADD_MONTHS(ld_fecpro,-1);

  for i in rubro loop
     begin 
       insert /*+parallel(CARTERAFM,2,1)*/into CARTERAFM (
              INSTANCIA, BCRUBR,BCSDMN,BCEMP,BCMOD,BCSUC,BCMDA,BCPAP,BCCTA,BCOPER,
              BCSBOP,BCTOP,/*DIAS_MORA,*/BCFVAL,BCFVTO,PEPAIS,PETDOC,PENDOC,C_CODSBS,
              N_TIPPEQ,D_FULEVA,C_NUMCRE,TDNOM,AOIMP,BCFECH,PENOM,BCSDMO,AOPERIOD,
              C_CREDTRAN,C_TIPCALEN,AOSTAT)
       select /*+all_rows parallel(cta,2,1) parallel(tdo,2,1)*/
             pq_datos_fin_mes.fn_pa_instancia (sal.bcmod,sal.bcsuc,sal.bcmda,
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
             /*\**\fn_dias_atraso(ld_fecpro,sal.bcemp,sal.bcmod,sal.bcsuc,sal.bcmda,
             sal.bcpap,sal.bccta,sal.bcoper,sal.bcsbop,sal.bctop,0) dias_mora,*/
             sal.bcfval,
             sal.bcfvto,
             cta.pepais,
             cta.petdoc,
             cta.pendoc, 
             pq_datos_fin_mes.fn_codsbs(cta.pepais,cta.petdoc,cta.pendoc, sal.bccta),
             pq_datos_fin_mes.fn_cod_interno_pqn (sal.bcmod,sal.bcsuc,sal.bcmda,
             sal.bcpap,sal.bccta,sal.bcoper,sal.bcsbop,sal.bctop,ld_fecpro),
             ( select max(f.sng021fec) from SNG021 f 
                 where f.sng021pdoc = cta.pepais 
                   and f.sng021tdoc = cta.petdoc 
                   and f.sng021ndoc = cta.pendoc)Fecult_evaluacion,
             case when sal.bcfval < to_date('20130701','yyyymmdd') then
                       pq_datos_fin_mes.fn_ope_sorfy(sal.bcmod,sal.bcsuc,sal.bcmda,
                       sal.bcpap,sal.bccta,sal.bcoper,sal.bcsbop,sal.bctop)end,
             tdo.tdnom,
             pre.aoimp,
             sal.bcfech,
             nom.penom,
             sal.bcsdmo,
             pre.aoperiod,
             (case
                        when pre.aostat = 33 then 'S'                                            
              end) Creditos_Transados,
              (select case when xllotexto = 1 then 'Fecha Fija'
                           when xllotexto = 2 then 'Plazo Fijo'
                      else 'Otros' end     
                  from x054021 s 
                 where  xllotxtcod   = 5
                    and s.pgcod      = pre.Pgcod
                    and s.xlloaomod  = pre.aomod
                    and s.xlloaosuc  = pre.aosuc
                    and s.xlloaomda  = pre.aomda
                    and s.xlloaopap  = pre.aopap 
                    and s.xlloaocta  = pre.aocta
                    and s.xlloaooper = pre.aooper 
                    and s.xlloaosbop = pre.aosbop
                    and s.xlloaotope = pre.aotope ) Tip_Calendario,
              pre.aostat
        from fsh012 sal, fsr008 cta, fsd010 pre,
             fst014 tdo, fsd001 nom
       where sal.bcemp = 1
         and sal.bcsuc = pn_numsuc
         and sal.bcfech in (ld_fecpro, ld_fecant)
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
           VALUES(0,'TIPIF',i.rubro||lc_coderr, TRUNC(SYSDATE));
           COMMIT;
     end;       
     commit;
  end loop; 
  commit;
  update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'TIPI';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'TIPI';
    commit;
    return;

end sp_tipificacion_datos;  

Procedure sp_job_tipifica_datos_II (pd_fecpro in varchar2 ) is
  ln_max number;
  ln_inc number;
  ln_ini number;
  ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_coderr varchar2(300);
  lc_hostname varchar2(64);
  cursor sucursal is 
  select sucurs from fst001 where pgcod =1 ;
  begin 
      begin
        select host_name
          into lc_hostname
          from v$instance;
      end;
     execute immediate ('truncate table reportes');
     delete Tab_jobs where  c_Codage = 'TIPI';
     commit;
     for i in sucursal loop    
        ln_ini := i.sucurs;
        lc_variable := ' begin '|| '  pq_datos_fin_mes.sp_tipificacion_datos_II('||ln_ini||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
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
        VALUES('TIPI',ln_ini,lc_variable);
        COMMIT;
      end loop; 
  exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'TIPIFI',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

  end;
  
Procedure sp_tipificacion_datos_II (pn_numsuc in number, pd_fecpro in varchar2 ) is

ld_fecpro date;
ld_fecant date ;
lc_coderr varchar2(300); 
cursor rubro is
  select rubro
    from fsd014
   where (pcnivc in
         (select modulo
            from fst111
           where dscod = 50
             and modulo not in (29, 120, 144, 33, 200)) --33 castigado , 200 judicial
              or pcnivc in (141, 117))
     and pcimpu = 'S'
     and pmtit <> 9;
begin

  update tab_jobs g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'TIPI';
  commit;
  ld_fecpro := to_date(pd_fecpro,'yyyymmdd');
  ld_fecant := ADD_MONTHS(ld_fecpro,-1);
    for i in rubro loop
     begin 
     
       insert into reportes (instancia,saldo,bcemp,bcmod,bcsuc,bcmda,bcpap,bccta,
                             bcoper,bcsbop,bctop,dias_mora,bcfval,bcfvto,pepais,
                             petdoc,pendoc,c_codsbs,n_tippeq,d_fuleva,c_numcre,
                             tdnom,aoimp,scnom,rub_ant,rub_act,tipo_credito_sbs,
                             fec_solicitud,fecha_resolucion,nivel_ventas_mn,
                             nivel_ventas_me,tipo_cambio,nro_credito,monto_aprobado,
                             producto,lineas,modalidad_credito,tipo_desembolso,otro)
            select a.INSTANCIA,a.saldo,a.bcemp, a.BCMOD,a.BCSUC,a.BCMDA,a.BCPAP,
                   a.BCCTA,a.BCOPER,a.BCSBOP,a.BCTOP,a.DIAS_MORA,a.BCFVAL,
                   a.BCFVTO,a.PEPAIS,a.PETDOC,a.PENDOC,a.C_CODSBS,a.N_TIPPEQ,
                   a.D_FULEVA,a.C_NUMCRE,a.TDNOM,a.AOIMP,a.scnom,a.rub_ant,
                   a.rub_act,
                   Case When Substr(a.rub_act, 1, 2) = '14' and
                             Substr(a.rub_act, 5, 2) = '02' then 'MICRO'
                        When Substr(a.rub_act, 1, 2) = '14' and
                             Substr(a.rub_act, 5, 2) = '03' then 'CONSUMO'
                        When Substr(a.rub_act, 1, 2) = '14' and
                             Substr(a.rub_act, 5, 2) = '04' then 'HIPOTECARIO'
                        When Substr(a.rub_act, 1, 2) = '14' and
                             Substr(a.rub_act, 5, 2) = '12' then 'MEDIANA'
                        When Substr(a.rub_act, 1, 2) = '14' and
                             Substr(a.rub_act, 5, 2) = '13' then 'PEQUEÑA'
                        When Substr(a.rub_act,1,2) in ('71','72') and 
                             Substr(a.rub_act,7,2) = '02' then 'MICRO'
                        When Substr(a.rub_act,1,2) in ('71','72') and 
                             Substr(a.rub_act,7,2) = '03' then 'CONSUMO'
                        When Substr(a.rub_act,1,2) in ('71','72') and 
                             Substr(a.rub_act,7,2) = '04' then 'HIPOTECARIO'
                        When Substr(a.rub_act,1,2) in ('71','72') and 
                             Substr(a.rub_act,7,2) = '12' then 'MEDIANA'
                        When Substr(a.rub_act,1,2) in ('71','72') and 
                             Substr(a.rub_act,7,2) = '13' then 'PEQUEÑA'     
                        Else ''
                   End Tipo_Credito,
                   (select b.sng001fin
                      from sng001 b
                     where a.instancia = b.sng001inst
                       and rownum = 1) Fec_Solicitud,
                   (select c.sng120fval
                      from sng120 c
                     where a.instancia = c.sng120ins
                       and c.sng120tsk = 'APROBACION'
                       and rownum = 1) Fecha_Resolucion,
                   (select distinct f.sng023mto
                      from sng021 e, sng023 f
                     where e.sng021sol = a.instancia
                       and e.sng021tmod = 13
                       and e.sng021eval = f.sng021eval
                       and f.sng026cod = 73
                       and rownum = 1) Nivel_Ventas_MN,
                   (select distinct f.sng023mto
                      from sng021 e, sng023 f
                     where e.sng021sol = a.instancia
                       and e.sng021tmod = 13
                       and e.sng021eval = f.sng021eval
                       and f.sng026cod = 573
                       and rownum = 1) Nivel_Ventas_ME,
                   (select g.sng120tcbi
                      from sng120 g
                     where g.sng120ins = a.instancia
                       and g.sng120tsk = 'EVALUACION'
                       and rownum = 1) Tipo_Cambio,
                   (lpad(to_char(a.bccta), 9, '0') || lpad(to_char(a.bcmod), 3, '0') ||
                   lpad(to_char(a.bcmda), 3, '0') || lpad(to_char(a.bcoper), 9, '0') ||
                   lpad(to_char(a.bctop), 3, '0')) Nro_Credito,
                   --a.scnom,
                   pq_datos_fin_mes.fn_mto_aprobado (a.bcemp,a.bcmod,a.bcsuc,a.bcmda,a.bcpap,
                                                     a.bccta,a.bcoper,a.bcsbop,a.bctop,a.aoimp
                   )Monto_Aprobado,
                   (select k.tonom
                      from fst004 k
                     where k.modulo = A.BCMOD
                       and k.totope = a.bctop) producto,
                   (select j.mdnom from fst003 j where j.modulo = A.BCMOD) Lineas,
                   (Case
                     When Substr(a.rub_act, 1, 2) = '14' and
                          Substr(a.rub_act, 5, 2) = '04' then 'CREMIVIVI'
                     When Substr(a.rub_act, 1, 2) = '14' and
                          Substr(a.rub_act, 7, 2) = '13' then 'CREPIG'
                     When Substr(a.rub_act, 1, 2) = '14' and
                          Substr(a.rub_act, 9, 2) = '01' then 'CREREV'
                     When Substr(a.rub_act, 1, 2) = '14' then 'CREDIR'
                     Else 'CREIND'
                   End) Modalidad_Credito,
                   (case
                     when a.bcmod = 116 then 'Linea'
                     else 'No Linea'
                   end) Tipo_desembolso,
                   
                   Case
                     When Substr(A.RUB_ANT, 1, 2) = '14' and
                          Substr(A.RUB_ANT, 5, 2) = '02' then 'MICRO'
                     When Substr(A.RUB_ANT, 1, 2) = '14' and
                          Substr(A.RUB_ANT, 5, 2) = '03' then 'CONSUMO'
                     When Substr(A.RUB_ANT, 1, 2) = '14' and
                          Substr(A.RUB_ANT, 5, 2) = '04' then 'HIPOTECARIO'
                     When Substr(A.RUB_ANT, 1, 2) = '14' and
                          Substr(A.RUB_ANT, 5, 2) = '12' then 'MEDIANA'
                     When Substr(A.RUB_ANT, 1, 2) = '14' and
                          Substr(A.RUB_ANT, 5, 2) = '13' then 'PEQUEÑA'
                     Else ''
                   End otro
              from (select INSTANCIA,
                           sum(case
                                 when BCFECH = ld_Fecant then 0
                                 else BCSDMN end) saldo,
                           BCEMP,
                           BCMOD,
                           BCSUC,
                           BCMDA,
                           BCPAP,
                           BCCTA,
                           BCOPER,
                           BCSBOP,
                           BCTOP,
                           DIAS_MORA,
                           BCFVAL,
                           BCFVTO,
                           PEPAIS,
                           PETDOC,
                           PENDOC,
                           C_CODSBS,
                           N_TIPPEQ,
                           D_FULEVA,
                           C_NUMCRE,
                           TDNOM,
                           AOIMP,
                           l.scnom,
                           max(case
                                 when BCFECH = ld_Fecant then
                                  bcrubr
                                 else
                                  null
                               end) rub_ant,
                           max(case
                                 when BCFECH = ld_Fecpro then
                                  bcrubr
                                 else
                                  null
                               end) rub_act
                    
                      from carterafm t, fst001 l
                     where t.bcsuc = pn_numsuc
                       and t.bcrubr = i.rubro
                       and t.bcsuc = l.sucurs
                       and l.pgcod = t.bcemp
                     group by INSTANCIA,
                              BCEMP,
                              BCMOD,
                              BCSUC,
                              BCMDA,
                              BCPAP,
                              BCCTA,
                              BCOPER,
                              BCSBOP,
                              BCTOP,
                              DIAS_MORA,
                              BCFVAL,
                              BCFVTO,
                              PEPAIS,
                              PETDOC,
                              PENDOC,
                              C_CODSBS,
                              N_TIPPEQ,
                              D_FULEVA,
                              C_NUMCRE,
                              TDNOM,
                              AOIMP,
                              l.scnom
                    having sum(case when BCFECH = ld_Fecant then 0 else BCSDMN end) <> 0) a;
         commit;        
     exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'TIPIF',pn_numsuc||lc_coderr, TRUNC(SYSDATE));
           COMMIT;
     end;       
     commit;
  end loop;
  commit;
  update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'TIPI';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'TIPI';
    commit;
    return;

end sp_tipificacion_datos_II;  

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





  Procedure sp_job_diasmora_datos (pd_fecpro in varchar2 ) is
  ln_max number;
  ln_inc number;
  ln_ini number;
  ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_coderr varchar2(300);
  lc_hostname varchar2(64);
  cursor sucursal is 
  select sucurs from fst001 where pgcod =1 ;
  begin 
      begin
    select host_name
      into lc_hostname
      from v$instance;
  end;
  
     execute immediate ('truncate table reportes');
     delete Tab_jobs where  c_Codage = 'DIAM';
     commit;
     for i in sucursal loop    
        ln_ini := i.sucurs;
        lc_variable := ' begin '|| '  pq_datos_fin_mes.sp_diasmora_datos('||ln_ini||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
        ln_job := ln_job +1;
        --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
--  if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then   
--  if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
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
        VALUES('DIAM',ln_ini,lc_variable);
        COMMIT;
      end loop; 
  exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'DIAM',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

  end;
  
Procedure sp_diasmora_datos (pn_numsuc in number, pd_fecpro in varchar2 ) is

ld_fecpro date ;
lc_coderr varchar2(300); 
cursor rubro is
  select rubro
    from fsd014
   where (pcnivc in
         (select modulo
            from fst111
           where dscod = 50
             and modulo not in (29, 120, 144, 33, 200)) --33 castigado , 200 judicial
              or pcnivc in (141, 117))
     and pcimpu = 'S'
     and pmtit <> 9;
begin

  update tab_jobs g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'DIAM';
  commit;
  ld_fecpro := to_date(pd_fecpro,'yyyymmdd');
    for i in rubro loop
     begin 
     
        insert into reportes (
            instancia,saldo,bcemp,bcmod,bcsuc,
            bcmda,bcpap,bccta,bcoper,bcsbop,bctop,
            dias_mora,bcfval,bcfvto,pepais,
            petdoc,pendoc,c_codsbs,c_numcre,
            tdnom,aoimp,scnom,rub_act,penom,
            BCSDMO,TEXT01,TEXT02,
            tipo_credito_sbs,
            nro_credito,
            producto,
            lineas,
            modalidad_credito,
            CATE01,CATE02,
            CATE03,bccate,
            CATE05,CATE06,
            CATE09,
            importe1,importe2,
            fecha1,importe3,fecha2,
            condicion,estado,numer01,bcrubr
            )
                    select INSTANCIA,BCSDMN,BCEMP,BCMOD,BCSUC,
                           BCMDA,BCPAP,BCCTA,BCOPER,BCSBOP,BCTOP,
                           DIAS_MORA,BCFVAL,BCFVTO,PEPAIS,
                           PETDOC,PENDOC,C_CODSBS,C_NUMCRE,
                           TDNOM,AOIMP,l.scnom,bcrubr,t.penom,
                           t.bcsdmo,t.c_credtran,t.c_tipcalen,
                           (Case
                              When Substr(bcrubr,1,2) = '14' and 
                                   Substr(bcrubr,5,2) = '02' then 'MICRO'
                              When Substr(bcrubr,1,2) = '14' and 
                                   Substr(bcrubr,5,2) = '03' then 'CONSUMO'
                              When Substr(bcrubr,1,2) = '14' and 
                                   Substr(bcrubr,5,2) = '04' then 'HIPOTECARIO'
                              When Substr(bcrubr,1,2) = '14' and 
                                   Substr(bcrubr,5,2) = '12' then 'MEDIANA'
                              When Substr(bcrubr,1,2) = '14' and 
                                   Substr(bcrubr,5,2) = '13' then 'PEQUEÑA'
                              When Substr(bcrubr,1,2) in ('71','72') and 
                                   Substr(bcrubr,7,2) = '02' then 'MICRO'
                              When Substr(bcrubr,1,2) in ('71','72') and 
                                   Substr(bcrubr,7,2) = '03' then 'CONSUMO'
                              When Substr(bcrubr,1,2) in ('71','72') and 
                                   Substr(bcrubr,7,2) = '04' then 'HIPOTECARIO'
                              When Substr(bcrubr,1,2) in ('71','72') and 
                                   Substr(bcrubr,7,2) = '12' then 'MEDIANA'
                              When Substr(bcrubr,1,2) in ('71','72') and 
                                   Substr(bcrubr,7,2) = '13' then 'PEQUEÑA'
                              Else null End )Tipo_Credito,
                           (lpad(to_char(bccta), 9, '0') || lpad(to_char(bcmod), 3, '0') ||
                            lpad(to_char(bcmda), 3, '0') || lpad(to_char(bcoper), 9, '0') ||
                            lpad(to_char(bctop), 3, '0')) Nro_Credito,  
                            k.tonom Producto,
                            j.mdnom Linea,
                            (Case
                               When Substr(bcrubr, 1, 2) = '14' and
                                    Substr(bcrubr, 5, 2) = '04' then 'CREMIVIVI'
                               When Substr(bcrubr, 1, 2) = '14' and
                                    Substr(bcrubr, 7, 2) = '13' then 'CREPIG'
                               When Substr(bcrubr, 1, 2) = '14' and
                                    Substr(bcrubr, 9, 2) = '01' then 'CREREV'
                               When Substr(bcrubr, 1, 2) = '14' then 'CREDIR'
                               Else 'CREIND'
                             End) Modalidad_Credito,
                             pq_datos_fin_mes.fn_categoria(bcemp,bccta,ld_fecpro,1),
                             pq_datos_fin_mes.fn_categoria(bcemp,bccta,ld_fecpro,2),
                             pq_datos_fin_mes.fn_categoria(bcemp,bccta,ld_fecpro,3),
                             pq_datos_fin_mes.fn_categoria(bcemp,bccta,ld_fecpro,4),
                             pq_datos_fin_mes.fn_categoria(bcemp,bccta,ld_fecpro,5),
                             pq_datos_fin_mes.fn_categoria(bcemp,bccta,ld_fecpro,6),
                             pq_datos_fin_mes.fn_categoria(bcemp,bccta,ld_fecpro,9),
                             pq_datos_fin_mes.fn_nro_cuotas(bcemp,bcmod,bcsuc,bcmda,bcpap, bccta,bcoper,
                                                            bcsbop,bctop),
                             pq_datos_fin_mes.fn_valor_cuotas(bcemp,bcmod,bcsuc,bcmda,bcpap, bccta,bcoper,
                                                              bcsbop,bctop),
                             pq_datos_fin_mes.fn_Fec_Proximo_vto(bcemp,bcmod,bcsuc,bcmda,bcpap, bccta,bcoper,
                                                                 bcsbop,bctop,ld_fecpro), 
                             pq_datos_fin_mes.fn_dias_gracia(bcemp,bcmod,bcsuc,bcmda,bcpap, bccta,bcoper,
                                                             bcsbop,bctop),                                                                  
                             pq_datos_fin_mes.fn_Fec_Ultimo_pago(bcemp,bcmod,bcsuc,bcmda,bcpap, bccta,bcoper,
                                                                 bcsbop,bctop,ld_fecpro),                                                              
                             
                             (Case
                                When Substr(bcrubr,1,2) = '14' and 
                                     Substr(bcrubr,4,1) = '1' then 'NORMAL'
                                When Substr(bcrubr,1,2) = '14' and 
                                     Substr(bcrubr,4,1) = '4' then 'REFINANCIADO'
                                When Substr(bcrubr,1,2) = '14' and 
                                     Substr(bcrubr,4,1) = '6' then 'JUDICIAL'
                                Else                               'NORMAL'
                              End)Condicion_Credito,
                             (Case
                                When Substr(bcrubr,1,2) = '14' and 
                                     Substr(bcrubr,4,1) = '1' then 'NORMAL'
                                When Substr(bcrubr,1,2) = '14' and 
                                     Substr(bcrubr,4,1) = '3' then 'REPROGRAMADO'
                                When Substr(bcrubr,1,2) = '14' and 
                                     Substr(bcrubr,4,1) = '4' then 'REFINANCIADO'
                                When Substr(bcrubr,1,2) = '14' and 
                                     Substr(bcrubr,4,1) = '5' then 'VENCIDO'
                                When Substr(bcrubr,1,2) = '14' and 
                                     Substr(bcrubr,4,1) = '6' then 'JUDICIAL'
                                Else                                'NORMAL'
                             End)Estado_Contable, t.aoperiod,t.bcrubr                               
                      from carterafm t, fst001 l, fst003 j, fst004 k
                     where t.bcsuc = pn_numsuc
                       and t.bcrubr = i.rubro
                       and t.bcsuc = l.sucurs
                       and l.pgcod = t.bcemp
                       and t.bcfech = ld_fecpro
                       and t.bcmod = j.modulo
                       and j.modulo = k.modulo
                       and t.bcmod = k.modulo
                       and t.bctop = k.totope;
     exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'DIAM',pn_numsuc||lc_coderr, TRUNC(SYSDATE));
           COMMIT;
     end;       
     commit;
  end loop;
  commit;
  update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'DIAM';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'DIAM';
    commit;
    return;

end sp_diasmora_datos;    

Procedure sp_job_tipifica_prueba_datos (pd_fecpro in varchar2 ) is
  ln_max number;
  ln_inc number;
  ln_ini number;
  ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_coderr varchar2(300);
  lc_hostname varchar2(64);
  cursor sucursal is 
  select sucurs from fst001 where pgcod =1 ;
  begin 
      begin
        select host_name
          into lc_hostname
          from v$instance;
      end;
     execute immediate ('truncate table CARTERAFM_TMP');
     delete Tab_jobs where  c_Codage = 'PRU';
     commit;
     for i in sucursal loop    
        ln_ini := i.sucurs;
        lc_variable := ' begin '|| '  pq_datos_fin_mes.sp_tipificacion_prueba_datos('||ln_ini||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
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
        VALUES('PRU',ln_ini,lc_variable);
        COMMIT;
      end loop; 
  exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'PRU',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

  end sp_job_tipifica_prueba_datos;
  
Procedure sp_tipificacion_prueba_datos (pn_numsuc in number, pd_fecpro in varchar2 ) is

ld_fecpro date ;
lc_coderr varchar2(300); 
cursor rubro is
  select rubro
    from fsd014
   where (pcnivc in
         (select modulo
            from fst111
           where dscod = 50
             and modulo not in (29, 120, 144, 33)) --33 castigado , 200 judicial
             )
     and pcimpu = 'S'
     and pmtit <> 9;
--ld_fecant date;
begin

  update tab_jobs g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'PRU';
  commit;
  ld_fecpro := to_date(pd_fecpro,'yyyymmdd');
  --ld_fecant := ADD_MONTHS(ld_fecpro,-1);

  for i in rubro loop
     begin 
       insert /*+parallel(CARTERAFM_TMP,2,1)*/into CARTERAFM (
              BCRUBR,BCSDMN,BCEMP,BCMOD,BCSUC,BCMDA,BCPAP,BCCTA,BCOPER,
              BCSBOP,BCTOP,BCFVAL,BCFVTO,PEPAIS,PETDOC,PENDOC,AOIMP,BCFECH,
              BCSDMO,AOPERIOD,
              C_CREDTRAN,C_TIPCALEN,AOSTAT,AOFVAL)
       select/*+all_rows*/
             
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
             pre.aoimp,
             sal.bcfech,
             sal.bcsdmo,
             pre.aoperiod,
             substr(sal.bcrubr, 5, 2),
             case  when substr(sal.bcrubr, 5, 2) = '02' then 'MICROEMPRESAS'   
                   when substr(sal.bcrubr, 5, 2) = '03' and 
                        substr(sal.bcrubr,11,3)='015' then 'CONSUMO REVOLVENTE' 
                   when substr(sal.bcrubr, 5, 2) = '03' and 
                        substr(sal.bcrubr,11,3)<>'015' then 'CONSUMO NO REVOLVENTE'  
                   when substr(sal.bcrubr, 5, 2) = '04' then 'HIPOTECARIO'
                   when substr(sal.bcrubr, 5, 2) = '12' then 'MEDIANA EMPRESA'
                   when substr(sal.bcrubr, 5, 2) = '13' then 'PEQUEÑA EMPRESA'                                       
             END TIPSBS,
              pre.aostat,
              pre.aofval
        from fsh012 sal, fsr008 cta, fsd010 pre
       where sal.bcemp = 1
         and sal.bcsuc = pn_numsuc
         and sal.bcfech in (ld_fecpro)
         and sal.bcrubr = i.rubro
         and sal.bccta  = cta.ctnro
         and cta.pgcod  = 1
         and cta.cttfir = 'T'
         and cta.ttcod  = 1
         and pre.pgcod  = sal.bcemp
         and pre.aomod  = sal.bcmod
         and pre.aosuc  = sal.bcsuc
         and pre.aomda  = sal.bcmda
         and pre.aopap  = sal.bcpap
         and pre.aocta  = sal.bccta
         and pre.aooper = sal.bcoper
         and pre.aosbop = sal.bcsbop
         and pre.aotope = sal.bctop
         and substr(sal.bcrubr, 5, 2) not in ( '03','04')
       
         ;    
     exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'PRU',i.rubro||lc_coderr, TRUNC(SYSDATE));
           COMMIT;
     end;       
     commit;
  end loop; 
  commit;
  update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'PRU';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'PRU';
    commit;
    return;

end sp_tipificacion_prueba_datos;  

  
function fn_categoria (pn_emp in number, pn_cta in number, pd_feccat in date, pn_codcat in number ) return varchar2 is
lc_categoria varchar2(20);
begin
  begin
    select l.catcateg 
      into lc_categoria
      from fsd212 l 
     where l.pgcod     = pn_emp
       and l.catcta    = pn_cta
       and l.catfchdes = pd_feccat
       and l.catcod    = pn_codcat;
  exception 
      when no_data_found then 
         lc_categoria := null;
      when too_many_rows then
         lc_categoria := null;
  end;   
   return lc_categoria;
end fn_categoria;

function fn_nro_cuotas (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                        pn_pap in number, pn_cta in number, pn_oper in number,
                        pn_sbop in number,pn_top in number ) return number is
ln_numcuo number;
begin
  begin
    if pn_mod = 108 then 
       ln_numcuo:=1;
    else
        
        select m.xllcantcuo 
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
         ln_numcuo := null;
      when too_many_rows then
         ln_numcuo := null;
  end;   
   return ln_numcuo;
end fn_nro_cuotas;
  

function fn_valor_cuotas (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                          pn_pap in number, pn_cta in number, pn_oper in number,
                          pn_sbop in number,pn_top in number ) return number is
ln_valcuo number;
begin
  begin
    select m.xllvalcuo 
      into ln_valcuo
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
  exception 
      when no_data_found then 
         ln_valcuo := -3;
      when too_many_rows then
         ln_valcuo := -4;
  end;   
   return ln_valcuo;
end fn_valor_cuotas;
  
function fn_Fec_Proximo_vto (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                             pn_pap in number, pn_cta in number, pn_oper in number,
                             pn_sbop in number,pn_top in number, pd_fecpro in date ) return date is
ld_fecpxv date;
begin
  begin
    select /*+ parallel(n,2,1)*/  
           min(n.ppfpag) 
      into ld_fecpxv   
      from fsd601 n 
     where n.pgcod  = pn_emp     
       and n.ppcta  = pn_cta     
       and n.ppmda  = pn_mda    
       and n.ppsuc  = pn_suc    
       and n.pppap  = pn_pap    
       and n.ppoper = pn_oper  
       and n.ppsbop = pn_sbop  
       and n.pptope = pn_top  
       and n.ppmod  = pn_mod    
       and n.d601co = 'S'
       and not exists 
                (select ppmod, ppcta,ppoper, pptope,ppfpag 
                   from fsd602 o
                  where o.pgcod   = n.pgcod
                    and o.ppmod   = n.ppmod
                    and o.ppsuc   = n.ppsuc
                    and o.ppmda   = n.ppmda
                    and o.pppap   = n.pppap
                    and o.ppcta   = n.ppcta
                    and o.ppoper  = n.ppoper
                    and o.ppsbop  = n.ppsbop
                    and o.pptope  = n.pptope
                    and o.ppfpag  = n.ppfpag
                    --and o.ppfpag  <= pd_fecpro
                    and o.pp1fech  <= pd_fecpro
                    and o.pp1stat = 'T' 
                    and o.d602co  = 'S');
  exception 
      when no_data_found then 
         ld_fecpxv := null;
      when too_many_rows then
         ld_fecpxv := null;
  end;   
   return ld_fecpxv;
end fn_Fec_Proximo_vto;
  function fn_Fec_Ultimo_pago (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                             pn_pap in number, pn_cta in number, pn_oper in number,
                             pn_sbop in number,pn_top in number, pd_fecpro in date ) return date is
  ld_fecupa date;
  begin
    begin
      select max(o.pp1fech) 
        into ld_fecupa     
        from fsd602 o
       where o.pgcod   = pn_emp 
         and o.ppmod   = pn_mod 
         and o.ppsuc   = pn_suc  
         and o.ppmda   = pn_mda
         and o.pppap   = pn_pap 
         and o.ppcta   = pn_cta 
         and o.ppoper  = pn_oper
         and o.ppsbop  = pn_sbop
         and o.pptope  = pn_top 
         and o.pp1stat = 'T' 
         and o.d602co  = 'S'
         and o.pp1fech <= pd_fecpro ;
    exception 
        when no_data_found then 
           ld_fecupa := null;
        when too_many_rows then
           ld_fecupa := null;
    end;   
     return ld_fecupa;
  end fn_Fec_Ultimo_pago;  

  function fn_dias_gracia (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                        pn_pap in number, pn_cta in number, pn_oper in number,
                        pn_sbop in number,pn_top in number ) return number is
  ln_diagra number;
  begin
    begin
      if pn_TOP = 550 or pn_mod in (200,33) then 
         ln_diagra:= 0;
      else
         select ((select min(n.ppfpag) 
                    from fsd601 n 
                   where m.xllaocta  = n.ppcta
                     and m.xllaooper = n.ppoper
                     and m.xllaosbop = n.ppsbop
                     and m.xllaotop  = n.pptope
                     and m.xllaomod  = n.ppmod
                     and m.xllaosuc  = n.ppsuc
                     and m.xllaomda  = n.ppmda
                     and m.xllaopap  = n.pppap)-m.xllfvalor)-m.xllperiodo 
           into ln_diagra          
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
           ln_diagra := null;
        when too_many_rows then
           ln_diagra := null;
    end;   
     return ln_diagra;
  end fn_dias_gracia;
  


function fn_provincia (pn_pais in number, pn_tdoc in number,pc_ndoc in char ) return varchar2 is
lc_provin varchar2(50);
begin
  begin
  select /*+index_ss(xx)*/xx.locnom
    into lc_provin
    from sngc13 aa, fst070 xx
   where aa.sngc13pais = pn_pais
     and aa.sngc13tdoc = pn_tdoc
     and aa.sngc13ndoc = pc_ndoc
     and aa.sngc13dpto = xx.depcod
     and aa.sngc13prov = xx.loccod
     and aa.docod in (1,3);
  exception 
      when no_data_found then 
         lc_provin := null;
      when too_many_rows then
         begin
          select /*+index_ss(xx)*/xx.locnom
            into lc_provin
            from sngc13 aa, fst070 xx
           where aa.sngc13pais = pn_pais
             and aa.sngc13tdoc = pn_tdoc
             and aa.sngc13ndoc = pc_ndoc
             and aa.sngc13dpto = xx.depcod
             and aa.sngc13prov = xx.loccod
             and aa.docod = 3;
          exception 
              when no_data_found then 
                 lc_provin := null;
              when too_many_rows then
                 lc_provin := null;
          end;   
  end;   
   return lc_provin;
end fn_provincia;
  
function fn_actividad (pn_pais in number, pn_tdoc in number,pc_ndoc in char ) return varchar2 is
lc_activi varchar2(200);
begin
  begin
  select xx.actnom1
    into lc_activi
    from sngc60 aa, fst750 xx
   where aa.sngc60pais = pn_pais
     and aa.sngc60tdoc = pn_tdoc
     and aa.sngc60ndoc = pc_ndoc
     and aa.sngc60corr = 0
     and aa.sngc60acte = xx.actcod1;
  exception 
      when no_data_found then 
         lc_activi := null;
      when too_many_rows then
         lc_activi := 'P';
  end;   
   return lc_activi;
end fn_actividad;

function fn_cod_activ (pn_pais in number, pn_tdoc in number,pc_ndoc in char ) return number is
ln_activi number;
begin
  begin
  select xx.actcod1
    into ln_activi
    from sngc60 aa, fst750 xx
   where aa.sngc60pais = pn_pais
     and aa.sngc60tdoc = pn_tdoc
     and aa.sngc60ndoc = pc_ndoc
     and aa.sngc60corr = 0
     and aa.sngc60acte = xx.actcod1;
  exception 
      when no_data_found then 
         ln_activi := null;
      when too_many_rows then
         ln_activi := null;
  end;   
   return ln_activi;
end fn_cod_activ;


function fn_prides (pn_instancia in number, pn_cta in number, pn_oper  in number,
pn_suc number, pn_mda number, pn_pap number, pn_mod number, pn_toper in number ) return date is
ld_prides date;
begin
  begin
  select min(d_prides)
    into ld_prides
    from ( select xwffec1 d_prides
             from xwf700 
            where xwfprcins = pn_instancia
            union all 
           select XLLOTXTFCH 
             from X054021 ee 
            where xlloaocta = pn_cta 
              and xlloaooper= pn_oper 
              and ee.xllotxtcod = 12
              and ee.pgcod = 1
              and ee.xlloaosuc = pn_suc
              and ee.xlloaomda = pn_mda
              and ee.xlloaopap = pn_pap
              and ee.XLLOAOMOD = pn_mod
              and ee.XLLOAOTOPE= pn_toper);
  exception 
      when no_data_found then 
         ld_prides := null;
      when too_many_rows then
         ld_prides := null;
  end;   
   return ld_prides;
end fn_prides;

function fn_reprogramado (pn_mod in number, pn_suc in number, pn_mda in number,
                          pn_pap in number, pn_cta in number, pn_oper in number,
                          pn_sbop in number,pn_top in number ) return number is
ln_tiprep number;
begin
  begin
  select max(s.relcod)
    into ln_tiprep
   from fsr011 s
  where relcod in (860,870) 
    and s.r1cod  = 1
    and s.r1mod  = pn_mod
    and s.r1suc  = pn_suc
    and s.r1mda  = pn_mda
    and s.r1pap  = pn_pap
    and s.r1cta  = pn_cta 
    and s.r1oper = pn_oper
    and s.r1sbop = pn_sbop
    and s.r1tope = pn_top
    and s.r011co = 'S';
  exception 
      when no_data_found then 
         ln_tiprep := null;
      when too_many_rows then
         ln_tiprep := null;
  end;   
   return ln_tiprep;
end fn_reprogramado;

/*Procedure sp_job_rsg_creditos (pd_fecpro in varchar2 ) is
  ln_max number;
  ln_inc number;
  ln_ini number;
  ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_coderr varchar2(300);
  cursor sucursal is 
  select sucurs from fst001 where pgcod =1 ;
  begin 
     execute immediate ('truncate table reportes');
     delete Tab_jobs where  c_Codage = 'RSGC';
     commit;
     for i in sucursal loop    
        ln_ini := i.sucurs;
        lc_variable := ' begin '|| '  pq_datos_fin_mes.sp_rsg_creditos('||ln_ini||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
        ln_job := ln_job +1;
        --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
         DBMS_JOB.SUBMIT(job => ln_job, 
                      what => lc_variable,
                      next_date => sysdate+1/(24*180),
                      interval => null,
                      no_parse => false,
                      instance => 2,
                      force => false
                      );
        INSERT INTO Tab_jobs (c_Codage,n_Numer1,c_detjob)
        VALUES('RSGC',ln_ini,lc_variable);
        COMMIT;
      end loop; 
  exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'RSGC',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

  end;
  
Procedure sp_rsg_creditos (pn_numsuc in number, pd_fecpro in varchar2 ) is

ld_fecant date ;
lc_coderr varchar2(300); 
cursor rubro is
  select \*+parallel(fsd014,2,1)*\rubro
    from fsd014
   where (pcnivc in
         (select modulo
            from fst111
           where dscod = 50
             and modulo not in (29, 120, 144\*, 33, 200*\)) --33 castigado , 200 judicial
              or pcnivc in (141, 117))
     and pcimpu = 'S'
     and pmtit <> 9;
begin

  update tab_jobs g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'RSGC';
  commit;
  ld_fecant := to_date(pd_fecpro,'yyyymmdd');
    for i in rubro loop
     begin 
       insert into reportes
       (bccta,tdnom,pendoc,bcoper,bcmda,rub_act,estado,modalidad_credito,
                      tipo_credito_sbs,n_tippeq,saldo,TEA,AOPZO,NUMER02,DIAS_MORA,
                      REGION,BCSUC,PROVINCIA,numer01,Actividad,bccate,IMPORTE1,
                      IMPORTE2, IMPORTE3,IMPORTE4,FECHA2,bcmod,bctop )
        select a.BCCTA Cta_Cliente,
               a.tdnom tip_doc,
               a.pendoc Nro_Doc ,
               a.bcoper Operacion,
               a.bcmda  Moneda,
               a.bcrubr Rubro,
        case when substr(bcrubr,4,1) = 1 then 'VIGENTE'
             when substr(bcrubr,4,1) = 4 then 'REFINANCIADO'
             when substr(bcrubr,4,1) = 5 then 'VENCIDO'
             when substr(bcrubr,4,1) = 6 then 'JUDICIAL' ELSE 'OTROS' END ESTADO,
        case when bcmod = 105 or ( bcmod = 106 and a.bctop in(2,4,6)) then 'PARALELO' 
             when substr(bcrubr,4,1) = 4 and a.aostat = 61 then 'REFINANCIADO'      
             when substr(bcrubr,4,1) = 4 and a.aostat = 61 then 'TRANSADO'
             when pq_datos_fin_mes.fn_reprogramado (a.bcmod,a.bcsuc,a.bcmda,
                     a.bcpap,a.bccta,a.bcoper,a.bcsbop,a.bctop) = 860 then 'REP_CAMBIO_FECHA'
             when  pq_datos_fin_mes.fn_reprogramado (a.bcmod,a.bcsuc,a.bcmda,
                     a.bcpap,a.bccta,a.bcoper,a.bcsbop,a.bctop) = 870 then 'REP_DESASTRES'
             ELSE 'NORMAL' END MODALIDAD,
        case when substr(bcrubr,5,2) = '02' then 'MICRO'
             when substr(bcrubr,5,2) = '03' then 'CONSUMO'
             when substr(bcrubr,5,2) = '04' then 'HIPOTECARIO'
             when substr(bcrubr,5,2) = '12' then 'MEDIANA' 
             when substr(bcrubr,5,2) = '13' then 'PEQUEÑA'
             ELSE 'OTROS' END TIPO_SBS,
             N_TIPPEQ Prod_CMAC,
             BCSDMN Saldo_Capital,
             a.aotas TEA,
             a.aoplzo PLAZO,
             a.aoperiod FREC_PAGO,
             a.DIAS_MORA,
             h.regnom REGION,
             a.BCSUC Sucursal,
             pq_datos_fin_mes.fn_provincia(a.pepais,a.petdoc,a.pendoc)PROVINCIA,
             pq_datos_fin_mes.fn_cod_activ(a.pepais,a.petdoc,a.pendoc)codactiv,
             pq_datos_fin_mes.fn_actividad(a.pepais,a.petdoc,a.pendoc)Actividad,
             a.bccate CATEGORIA,
             a.prvobli Prv_Obligatoria,
             a.prvesp PRV_ESPECIFICA,
             a.prvprc PRV_Prociclica,
             a.prvsbe PRV_SOBRENDEU,
             pq_datos_fin_mes.fn_prides(a.instancia,a.bccta, a.bcoper,a.bcsuc,
             a.bcmda, a.bcpap, a.bcmod, a.bctop
             ) FEC_PRI_DES,
             a.bcmod, a.bctop
         from CARTERAFM a,  fst810 h, fst811 g
         where bcfech = ld_fecant
           and g.pgcod = a.bcemp
           and a.bcrubr = i.rubro
           and a.bcsuc  = pn_numsuc
           and g.oficod =a.bcsuc
           and g.regcod < 100
           and h.pgcod = g.pgcod
           and h.regcod= g.regcod ;
     exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'RSGC',pn_numsuc||lc_coderr, TRUNC(SYSDATE));
           COMMIT;
     end;       
     commit;
  end loop;
  commit;
  update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'RSGC';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'RSGC';
    commit;
    return;

end sp_rsg_creditos;  */


Procedure sp_job_desgrava_datos (pd_fecpro in varchar2 ) is
  ln_max number;
  ln_inc number;
  ln_ini number;
  ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_coderr varchar2(300);
  lc_hostname varchar2(64);
  cursor sucursal is 
  select sucurs from fst001 where pgcod =1 ;
  begin 
      begin
        select host_name
          into lc_hostname
          from v$instance;
      end;
     execute immediate ('truncate table CARTERAFM');
     delete Tab_jobs where  c_Codage = 'DES';
     commit;
     for i in sucursal loop    
        ln_ini := i.sucurs;
        lc_variable := ' begin '|| '  pq_datos_fin_mes.sp_desgrava_datos('||ln_ini||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
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
        VALUES('DES',ln_ini,lc_variable);
        COMMIT;
      end loop; 
  exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'DES',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

end sp_job_desgrava_datos;
  
Procedure sp_desgrava_datos (pn_numsuc in number, pd_fecpro in varchar2 ) is

ld_fecpro date ;
lc_coderr varchar2(300); 
cursor rubro is
  select rubro
    from fsd014
   where (pcnivc in
         (select modulo
            from fst111
           where dscod = 50
             and modulo not in (/*29, 120, 144,*/ 33/*, 200*/)) --33 castigado , 200 judicial
              or pcnivc in (141))
     /*and pcimpu = 'S'
     and pmtit <> 9*/;

begin

  update tab_jobs g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'DES';
  commit;
  ld_fecpro := to_date(pd_fecpro,'yyyymmdd');


  for i in rubro loop
     begin 
       insert /*+parallel(CARTERAFM,2,1)*/into CARTERAFM (
              INSTANCIA, BCRUBR,BCSDMN,BCEMP,BCMOD,BCSUC,BCMDA,BCPAP,BCCTA,BCOPER,
              BCSBOP,BCTOP,BCFVAL,BCFVTO,PEPAIS,PETDOC,PENDOC,TDNOM,AOIMP,BCFECH,
              PENOM,BCSDMO,PETIPO,FECNAC,NOMTIT,FECNOMTIT,Bcgpo)
       select/*+all_rows parallel(pre,2,1) parallel(tdo,2,1)*/
             pq_datos_fin_mes.fn_pa_instancia (sal.bcmod,sal.bcsuc,sal.bcmda,
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
             nom.PETIPO,
             (select nac.pffnac from fsd002 nac where nac.pfpais = cta.pepais
                                                           and nac.pftdoc = cta.petdoc
                                                           and nac.pfndoc = cta.pendoc),
                                                   
             pq_datos_fin_mes.fn_nomtit(cta.pepais,cta.petdoc,cta.pendoc),
             
             pq_datos_fin_mes.fn_fecnac_nomtit(cta.pepais,cta.petdoc,cta.pendoc),
             sal.BCGPO
             
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
         and not exists (select * from fsr011 g where  g.r1cod  = sal.bcemp
                                              and g.r1mod  = sal.bcmod
                                              and g.r1suc  = sal.bcsuc
                                              and g.r1mda  = sal.bcmda
                                              and g.r1pap  = sal.bcpap
                                              and g.r1cta  = sal.bccta
                                              and g.r1oper = sal.bcoper
                                              and g.r1sbop = sal.bcsbop
                                              and g.r1tope = sal.bctop
                                              and g.relcod = 50
                                              and g.r1mod  = 106
                                              and g.r2mod  = 70 
                                              and g.r2tope in (80,85)
                                              and g.r011co = 'S')
         ;    
     exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'DES',i.rubro||lc_coderr, TRUNC(SYSDATE));
           COMMIT;
     end;       
     commit;
  end loop; 
  commit;
  update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'DES';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'DES';
    commit;
    return;

end sp_desgrava_datos;
Procedure sp_job_desgravamen_II (pd_fecpro in varchar2 ) is
  ln_max number;
  ln_inc number;
  ln_ini number;
  ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_coderr varchar2(300);
  lc_hostname varchar2(64);
  cursor sucursal is 
  select sucurs from fst001 where pgcod =1 ;
  begin 
      begin
        select host_name
          into lc_hostname
          from v$instance;
      end;
     execute immediate ('truncate table reportes_tmp');
     delete Tab_jobs where  c_Codage = 'DESGRA';
     commit;
      for i in sucursal loop    
        ln_ini := i.sucurs; 
        lc_variable := ' begin '|| '  pq_datos_fin_mes.sp_desgravamen_II('||ln_ini||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
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
        VALUES('DESGRA',ln_ini,lc_variable);
        COMMIT;
      end loop; 
  exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'DESGRAE',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

end sp_job_desgravamen_II;
  
Procedure sp_desgravamen_II (pn_numsuc in number, pd_fecpro in varchar2 ) is

ld_fecpro date;

lc_coderr varchar2(300); 
cursor rubro is
  select rubro
    from fsd014
   where (pcnivc in
         (select modulo
            from fst111
           where dscod = 50
             and modulo not in (/*29, 120, 144,*/ 33)) --33 castigado , 200 judicial
              or pcnivc in (141))
    /* and pcimpu = 'S'
     and pmtit <> 9*/;
begin

  update tab_jobs g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'DESGRA';
  commit;
  ld_fecpro := to_date(pd_fecpro,'yyyymmdd');

    for i in rubro loop
     begin 
     
       insert into reportes_tmp (instancia,bcemp,bcmod,bcsuc,bcmda,bcpap,bccta,
                             bcoper,bcsbop,bctop,bcfval,bcfvto,pepais,
                             petdoc,pendoc,c_numcre,
                             tdnom,aoimp,scnom,nro_credito,
                             producto,
                             penom,bcsdmo,bcsdmn,petipo,fecnac,fecnomtit,nomtit,tiprep)
            select INSTANCIA,
                   BCEMP,
                   BCMOD,
                   BCSUC,
                   BCMDA,
                   BCPAP,
                   BCCTA,
                   BCOPER,
                   BCSBOP,
                   BCTOP,
                   BCFVAL,
                   BCFVTO,
                   PEPAIS,
                   PETDOC,
                   PENDOC,
                   C_NUMCRE,
                   TDNOM,
                   AOIMP,--monto desembolsado
                   l.scnom,
                           
                   
                   (lpad(to_char(bccta), 9, '0') || lpad(to_char(bcmod), 3, '0') ||
                   lpad(to_char(bcmda), 3, '0') || lpad(to_char(bcoper), 9, '0') ||
                   lpad(to_char(bctop), 3, '0')) Nro_Credito,
                   
                   (select k.tonom
                      from fst004 k
                     where k.modulo = BCMOD
                       and k.totope = bctop) producto,
                   
                     
                   t.penom,
                   t.bcsdmo,
                   t.bcsdmn,
                   t.petipo,
                   t.fecnac,
                   t.fecnomtit,
                   t.nomtit ,
                     
                   pq_datos_fin_mes.fn_tipo_rep(bcemp,bcmod,bcsuc,bcmda,bcpap,bccta,
                                                bcoper,bcsbop,bctop,ld_fecpro,instancia,
                                                fecnac,petipo,pepais,petdoc,pendoc,fecnomtit)                                          
                                                   
             from CARTERAFM t, fst001 l
           where t.bcsuc = pn_numsuc
             and t.bcrubr = i.rubro
             and t.bcsuc = l.sucurs
             and l.pgcod = t.bcemp
             and t.bcfech = ld_fecpro
             --and not exists (select 1 from aojeda.cred_soli CC WHERE CC.C_NUMCRE = t.C_NUMCRE)
         
            
             ;
         commit;        
     exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'DESGRA',pn_numsuc||lc_coderr, TRUNC(SYSDATE));
           COMMIT;
     end;       
     commit;
  end loop;
  commit;
  update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'DESGRA';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'DESGRA';
    commit;
    return;

end sp_desgravamen_II;

/*Procedure sp_job_desgravamen_III (pd_fecpro in varchar2 ) is
  ln_max number;
  ln_inc number;
  ln_ini number;
  ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_coderr varchar2(300);
  cursor sucursal is 
  select sucurs from fst001 where pgcod =1 ;
  begin 
     execute immediate ('truncate table reportes_tmp');
     delete Tab_jobs where  c_Codage = 'DES3';
     commit;
     ---for i in sucursal loop yo lo cambie   
        ln_ini := 1\*i.sucurs*\; --yo
        lc_variable := ' begin '|| '  pq_datos_fin_mes.sp_desgravamen_III('||1\*ln_iniyo*\||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
        ln_job := ln_job +1;
        --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
         DBMS_JOB.SUBMIT(job => ln_job, 
                      what => lc_variable,
                      next_date => sysdate+1/(24*180),
                      interval => null,
                      no_parse => false,
                      instance => 2,
                      force => false
                      );
        INSERT INTO Tab_jobs (c_Codage,n_Numer1,c_detjob)
        VALUES('DES3',ln_ini,lc_variable);
        COMMIT;
      --end loop; yo
  exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'DES3E',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

end sp_job_desgravamen_III;
  
Procedure sp_desgravamen_III (pn_numsuc in number, pd_fecpro in varchar2 ) is

ld_fecpro date;

lc_coderr varchar2(300); 
cursor cartera is 
select INSTANCIA,
                   BCEMP,
                   BCMOD,
                   BCSUC,
                   BCMDA,
                   BCPAP,
                   BCCTA,
                   BCOPER,
                   BCSBOP,
                   BCTOP,
                   BCFVAL,
                   BCFVTO,
                   PEPAIS,
                   PETDOC,
                   PENDOC,
                   C_NUMCRE,
                   TDNOM,
                   AOIMP,--monto desembolsado
                   l.scnom,
                           
                   
                   (lpad(to_char(bccta), 9, '0') || lpad(to_char(bcmod), 3, '0') ||
                   lpad(to_char(bcmda), 3, '0') || lpad(to_char(bcoper), 9, '0') ||
                   lpad(to_char(bctop), 3, '0')) Nro_Credito,
                   
                   (select k.tonom
                      from fst004 k
                     where k.modulo = BCMOD
                       and k.totope = bctop) producto,
                   
                     
                   t.penom,
                   t.bcsdmo,
                   t.bcsdmn,
                   t.petipo,
                   t.fecnac,
                   t.fecnotit,
                   t.nomtit ,
                     
                   pq_datos_fin_mes.fn_tipo_rep(bcemp,bcmod,bcsuc,bcmda,bcpap,bccta,
                                                bcoper,bcsbop,bctop,pd_fecpro,instancia,
                                                fecnac,petipo)
                                                   
             from CARTERAFM_TMP t, fst001 l
           where t.bcsuc = pn_numsuc
             and t.bcrubr = i.rubro
             and t.bcsuc = l.sucurs
             and l.pgcod = t.bcemp
             and t.bcfech = pd_fecpro;
cursor rubro is
  select rubro
    from fsd014
   where (pcnivc in
         (select modulo
            from fst111
           where dscod = 50
             and modulo not in (29, 120, 144, 33)) --33 castigado , 200 judicial
              or pcnivc in (141))
     and pcimpu = 'S'
     and pmtit <> 9;
begin

  update tab_jobs g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'DES3';
  commit;
  ld_fecpro := to_date(pd_fecpro,'yyyymmdd');

    for i in rubro loop
     begin 
     
       insert into reportes_tmp (instancia,bcemp,bcmod,bcsuc,bcmda,bcpap,bccta,
                             bcoper,bcsbop,bctop,bcfval,bcfvto,pepais,
                             petdoc,pendoc,c_numcre,
                             tdnom,aoimp,scnom,nro_credito,
                             producto,
                             penom,bcsdmo,bcsdmn,petipo,fecnac,fecnomtit,nomtit,tiprep)
            
            
             ;
         commit;        
     exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'DES3',pn_numsuc||lc_coderr, TRUNC(SYSDATE));
           COMMIT;
     end;       
     commit;
  end loop;
  commit;
  update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'DES3';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'DES3';
    commit;
    return;

end sp_desgravamen_III;*/

function fn_tipo_rep (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                      pn_pap in number, pn_cta in number, pn_oper in number,pn_sbop in number,
                      pn_top in number, pd_fecpro in date,pn_instancia in number,pd_ffecnac in date,
                      pc_tiper in char, pn_pais in number, pn_tdoc in number, pn_ndoc in number,
                      pd_fecnotit in date) return varchar2 is
lc_tiprep varchar2(20);

cursor rubro1 is
  select rubro
    from fsd014
   where (pcnivc in
         (select modulo
            from fst111
           where dscod = 50
             and modulo not in (/*29,120,144,*/33,110,111,108)) --33 castigado , 200 judicial
              or pcnivc in (141))
      /*        
     and pcimpu = 'S'
     and pmtit <> 9*/;

cursor rubro2 is
  select rubro
    from fsd014
   where (pcnivc in (110,111))
     and pcimpu = 'S'
     and pmtit <> 9;     
     
begin
   --begin
         --for i in rubro1 loop
            begin
            
              select 'SD1'
                into lc_tiprep
                from fsh012 f
               where f.bcemp  = pn_emp   
                 and f.bcsuc  = pn_suc
                 and f.bcmda  = pn_mda
                 and f.bcpap  = pn_pap
                 and f.bccta  = pn_cta
                 and f.bcoper = pn_oper
                 and f.bcsbop = pn_sbop
                 and f.bctop  = pn_top
                 and f.bcmod  = pn_mod
                 and f.bcfech = pd_fecpro
                 and f.bcrubr in (select rubro
                                    from fsd014
                                   where (pcnivc in
                                         (select modulo
                                            from fst111
                                           where dscod = 50
                                             and modulo not in (29,120,144,33,110,111,108)) --33 castigado , 200 judicial
                                              or pcnivc in (141))
                                              
                                     and pcimpu = 'S'
                                     and pmtit <> 9)
                 --and f.bcrubr = i.rubro
                 and pc_tiper = 'F'
                 and abs(f.bcsdmn) >= 8000
                 and pq_datos_fin_mes.fn_cr_years(pq_datos_fin_mes.fn_prides(pn_instancia,bccta,bcoper,
                                                                             bcsuc,bcmda,bcpap,bcmod,bctop),
                                                  pd_ffecnac) between to_number(18) and to_number(70)
                 and pq_datos_fin_mes.fn_cr_years(pd_fecpro,pd_ffecnac) <= to_number(70);
                
            exception 
                when no_data_found then 
                   begin
            
                    select 'SD2'
                      into lc_tiprep
                      from fsh012 f
                     where f.bcemp  = pn_emp   
                       and f.bcsuc  = pn_suc
                       and f.bcmda  = pn_mda
                       and f.bcpap  = pn_pap
                       and f.bccta  = pn_cta
                       and f.bcoper = pn_oper
                       and f.bcsbop = pn_sbop
                       and f.bctop  = pn_top
                       and f.bcmod  = pn_mod
                       and f.bcfech = pd_fecpro
                       and f.bcrubr in (select rubro
                                    from fsd014
                                   where (pcnivc in
                                         (select modulo
                                            from fst111
                                           where dscod = 50
                                             and modulo not in (29,120,144,33,110,111,108)) --33 castigado , 200 judicial
                                              or pcnivc in (141))
                                              
                                     and pcimpu = 'S'
                                     and pmtit <> 9)
                       --and f.bcrubr = i.rubro
                       and pc_tiper = 'F'
                       and abs(f.bcsdmn) >= 8000
                       and pq_datos_fin_mes.fn_cr_years(pq_datos_fin_mes.fn_prides(pn_instancia,bccta,bcoper,
                                                                                   bcsuc,bcmda,bcpap,bcmod,bctop),
                                                        pd_ffecnac) between to_number(18) and to_number(70)
                       and pq_datos_fin_mes.fn_cr_years(pd_fecpro,pd_ffecnac) between to_number(70) and to_number(75);
                  
                  exception 
                      when no_data_found then 
                         begin
                  
                          select 'EIRL'
                            into lc_tiprep
                            from fsh012 f/*, fsd003 j,fsr008 k*/
                           where f.bcemp  = pn_emp   
                             and f.bcsuc  = pn_suc
                             and f.bcmda  = pn_mda
                             and f.bcpap  = pn_pap
                             and f.bccta  = pn_cta
                             and f.bcoper = pn_oper
                             and f.bcsbop = pn_sbop
                             and f.bctop  = pn_top
                             and f.bcmod  = pn_mod
                             and f.bcfech = pd_fecpro
                             and f.bcrubr in (select rubro
                                    from fsd014
                                   where (pcnivc in
                                         (select modulo
                                            from fst111
                                           where dscod = 50
                                             and modulo not in (29,120,144,33,110,111,108)) --33 castigado , 200 judicial
                                              or pcnivc in (141))
                                              
                                     and pcimpu = 'S'
                                     and pmtit <> 9)
                             --and f.bcrubr = i.rubro
                             and pc_tiper = 'J'
                             and exists (select 1 from fsd003 j where j.njcod = 14
                             and j.pjpais = pn_pais 
                             and j.pjtdoc = pn_tdoc 
                             and j.pjndoc = pn_ndoc)
                             
                             and abs(f.bcsdmn) >= 8000
                             and pq_datos_fin_mes.fn_cr_years(pq_datos_fin_mes.fn_prides(pn_instancia,bccta,bcoper,
                                                                                   bcsuc,bcmda,bcpap,bcmod,bctop),
                                                        pd_fecnotit) between to_number(18) and to_number(70);
                        
                        exception 
                            when no_data_found then 
                              begin 
                                 select 'HIPO'
                                    into lc_tiprep
                                    from fsh012 f
                                   where f.bcemp  = pn_emp   
                                     and f.bcsuc  = pn_suc
                                     and f.bcmda  = pn_mda
                                     and f.bcpap  = pn_pap
                                     and f.bccta  = pn_cta
                                     and f.bcoper = pn_oper
                                     and f.bcsbop = pn_sbop
                                     and f.bctop  = pn_top
                                     and f.bcmod  = pn_mod
                                     and f.bcfech = pd_fecpro
                                     and f.bcrubr in (select rubro
                                                        from fsd014
                                                       where (pcnivc in (110,111))
                                                         and pcimpu = 'S'
                                                         and pmtit <> 9)
                                     --and f.bcrubr = j.rubro
                                     and f.bcgpo  = 4
                                     and pc_tiper = 'F'
                                     
                                     and abs(f.bcsdmn) >= to_number(8000)
                                     and pq_datos_fin_mes.fn_cr_years(pq_datos_fin_mes.fn_prides(pn_instancia,bccta,bcoper,
                                                                                                 bcsuc,bcmda,bcpap,bcmod,bctop),
                                                                      pd_ffecnac) between to_number(18) and to_number(70)
                                     and pq_datos_fin_mes.fn_cr_years(pd_fecpro,pd_ffecnac) <= to_number(70);
                              Exception
                               when no_data_found then 
                                   lc_tiprep := null; 
                               when others then
                               lc_tiprep := 'otroh';
                              end;         
                            when others then
                               lc_tiprep := 'otroeir';
                        end; 
                      when others then
                               lc_tiprep := 'otro2';
                  end; 
               when others then
                               lc_tiprep := 'otro1';   
           end; 
            
           return lc_tiprep;  
            
            
            
         /*end loop;
         return lc_tiprep;  
   end;*/
   
   /*begin
   
         for j in rubro2 loop
         
             begin
            
              select 'HIPO'
                into lc_tiprep
                from fsh012 f
               where f.bcemp  = pn_emp   
                 and f.bcsuc  = pn_suc
                 and f.bcmda  = pn_mda
                 and f.bcpap  = pn_pap
                 and f.bccta  = pn_cta
                 and f.bcoper = pn_oper
                 and f.bcsbop = pn_sbop
                 and f.bctop  = pn_top
                 and f.bcmod  = pn_mod
                 and f.bcfech = pd_fecpro
                 and f.bcrubr = j.rubro
                 and pc_tiper = 'F'
                 and abs(f.bcsdmn) >= to_number(0.0001)
                 and pq_datos_fin_mes.fn_cr_years(pq_datos_fin_mes.fn_prides(pn_instancia,bccta,bcoper,
                                                                             bcsuc,bcmda,bcpap,bcmod,bctop),
                                                  pd_ffecnac) between to_number(18) and to_number(70)
                 and pq_datos_fin_mes.fn_cr_years(pd_fecpro,pd_ffecnac) <= to_number(70);
            
            exception 
                when no_data_found then 
                   lc_tiprep := 'nohipo';
                when too_many_rows then
                   lc_tiprep := null;
            end; 
         
         end loop;
   
   
   end;*/
   
   
   --return lc_tiprep;
   
end fn_tipo_rep;


function fn_cr_years(P_D_FECPRO in date,P_D_FECNAC in date) return number is

  ld_fecpro date;
  ld_fecnac date;
  
  ln_year number;
begin
  -- Datos según Parámetros.
  ld_fecpro := trunc(P_D_FECPRO);
  ld_fecnac := trunc(P_D_FECNAC);
  --
  ln_year := to_number(to_char(ld_fecpro,'yyyy')) - to_number(to_char(ld_fecnac,'yyyy'));
  if (ln_year > 0) then
     if (to_char(ld_fecpro,'mm') < to_char(ld_fecnac,'mm')) then
        ln_year := ln_year - 1;
     else
        if (to_char(ld_fecpro,'mm') = to_char(ld_fecnac,'mm')) and (to_char(ld_fecpro,'dd') < to_char(ld_fecnac,'dd')) then
           ln_year := ln_year - 1;
        end if;
     end if;
  else
     ln_year := null;
  end if;
  return(ln_year);
exception
  when others then
    return(null);
end fn_cr_years;

function fn_tipcamb(PD_FECPRO in date,PD_LIMITE in NUMBER
                                      ) return number is

  ld_fecpro date;
  ln_limite number;
  ln_cotcbi number;
  ln_result number;
begin

  begin
    -- Datos según Parámetros.
    ld_fecpro := trunc(PD_FECPRO);
    ln_limite := trunc(PD_LIMITE);
    --
    select g.cotcbi
      into ln_cotcbi       
      from fsh005 g 
     where g.moneda = 101 
       and g.cofdes = ld_fecpro;
    
    ln_result := PD_LIMITE * ln_cotcbi;

    
  exception
    when others then
      return(null);
  end;
  return(ln_result);
end fn_tipcamb;

function fn_producto(PD_MOD in number,PD_TOP in NUMBER) return varchar2 is

  lc_producto varchar2(20);
begin
  
  begin
    
    select k.tonom
      into lc_producto     
      from fst004 k
     where k.modulo = PD_MOD
       and k.totope = PD_TOP;
   
    
  exception
    when others then
      lc_producto := null;
  end;
  return(lc_producto);
end fn_producto;

function fn_nomtit(PD_PAIS in number,PD_TDOC in NUMBER, PD_NDOC in number) return varchar2 is

  lc_nomtit varchar2(200);

begin  
    begin
      
      select k.penom
        into lc_nomtit     
        from fsd001 k, fsr003 j
       where j.pjpais = PD_PAIS
         and j.pjtdoc = PD_TDOC
         and j.pjndoc = PD_NDOC
         and j.pfpai1 = k.pepais
         and j.pftdo1 = k.petdoc
         and j.pfndo1 = k.pendoc
         and rownum   = 1;
     
      
    exception
      when others then
        lc_nomtit := null;
    end;
    return(lc_nomtit);
end fn_nomtit;

function fn_fecnac_nomtit(PD_PAIS in number,PD_TDOC in NUMBER, PD_NDOC in number) return date is

  ld_fecnac date;
begin   
  begin
    
    select j.pjfcon
      into ld_fecnac     
      from fsd003 j
     where j.pjpais = PD_PAIS
       and j.pjtdoc = PD_TDOC
       and j.pjndoc = PD_NDOC
       and rownum   = 1;
   
    
  exception
    when others then
      ld_fecnac := null;
  end;
  return(ld_fecnac);    
end fn_fecnac_nomtit;

Procedure sp_job_cartera_datos (pd_fecpro in varchar2 ) is
  ln_max number;
  ln_inc number;
  ln_ini number;
  ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_coderr varchar2(300);
  lc_hostname varchar2(64);
  cursor sucursal is 
  select sucurs from fst001 where pgcod =1 ;
  begin 
      begin
        select host_name
          into lc_hostname
          from v$instance;
      end;
     execute immediate ('truncate table CARTERAFM_TMP');
     delete Tab_jobs where  c_Codage = 'CAR';
     commit;
     for i in sucursal loop    
        ln_ini := i.sucurs;
        lc_variable := ' begin '|| '  pq_datos_fin_mes.sp_cartera_datos('||ln_ini||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
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
        VALUES('CAR',ln_ini,lc_variable);
        COMMIT;
      end loop; 
  exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'CAR',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;
end sp_job_cartera_datos;
  
Procedure sp_cartera_datos (pn_numsuc in number, pd_fecpro in varchar2 ) is

ld_fecpro date ;
lc_coderr varchar2(300); 
cursor rubro is
  select rubro
    from fsd014
   where (pcnivc in
         (select modulo
            from fst111
           where dscod = 50
             and modulo not in (29, 120, 144, 33, 200)) --33 castigado , 200 judicial
              or pcnivc in (141, 117))
     and pcimpu = 'S'
     and pmtit <> 9;

begin

  update tab_jobs g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'CAR';
  commit;
  ld_fecpro := to_date(pd_fecpro,'yyyymmdd');
  

  for i in rubro loop
     begin 
       insert /*+parallel(CARTERAFM_TMP,2,1)*/into CARTERAFM (
              INSTANCIA, BCRUBR,BCSDMN,BCEMP,BCMOD,BCSUC,BCMDA,BCPAP,BCCTA,BCOPER,
              BCSBOP,BCTOP,BCFVAL,BCFVTO,PEPAIS,PETDOC,PENDOC,
              N_TIPPEQ,D_FULEVA,C_NUMCRE,TDNOM,AOIMP,BCFECH,PENOM,BCSDMO,AOPERIOD,
              C_TIPCALEN,AOSTAT)
       select/*+all_rows parallel(sal,2,1) parallel(pre,2,1)*/
             pq_datos_fin_mes.fn_pa_instancia (sal.bcmod,sal.bcsuc,sal.bcmda,
             sal.bcpap,sal.bccta,sal.bcoper,sal.bcsbop,sal.bctop),--nro solicitud credito
             sal.bcrubr,--rubro contable
             sal.bcsdmn, --saldo capital en moneda nacional
             sal.BCEMP, -- codigo empresa siempre1
             sal.bcmod,--modulo
             sal.bcsuc,--sucursal
             sal.bcmda,--moneda soles:0 dolares:101
             sal.bcpap,--papel
             sal.bccta,--numero cuenta del cliente
             sal.bcoper,--nro operacion
             sal.bcsbop,--suboperacion
             sal.bctop,--tipo operacion
             sal.bcfval,--fecha valor ..fecha desembolso
             sal.bcfvto,--fecha de vencimiento del credito
             cta.pepais,--pais
             cta.petdoc,--tipo de documento
             cta.pendoc, --numero de docuemnto
             pq_datos_fin_mes.fn_cod_interno_pqn (sal.bcmod,sal.bcsuc,sal.bcmda,
             sal.bcpap,sal.bccta,sal.bcoper,sal.bcsbop,sal.bctop,ld_fecpro),--codigo de sector para pequeña empresa
             ( select max(f.sng021fec) from SNG021 f 
                 where f.sng021pdoc = cta.pepais 
                   and f.sng021tdoc = cta.petdoc 
                   and f.sng021ndoc = cta.pendoc)Fecult_evaluacion,--fecha de su ultima evaluacion
             case when sal.bcfval < to_date('20130701','yyyymmdd') then
                       pq_datos_fin_mes.fn_ope_sorfy(sal.bcmod,sal.bcsuc,sal.bcmda,
                       sal.bcpap,sal.bccta,sal.bcoper,sal.bcsbop,sal.bctop)end,--numero de sorfy
             tdo.tdnom,--descripcion tipo docuemnto
             pre.aoimp,--monto desembolsado
             sal.bcfech,--fecha de proceso
             nom.penom,--nombre del ciente
             sal.bcsdmo,--saldo capital en moneda origen
             pre.aoperiod,--plazo del credito
             
            (select case when xllotexto = 1 then 'Fecha Fija'
                         when xllotexto = 2 then 'Plazo Fijo'
                    else 'Otros' end     
                from x054021 s 
               where  xllotxtcod   = 5
                  and s.pgcod      = pre.Pgcod
                  and s.xlloaomod  = pre.aomod
                  and s.xlloaosuc  = pre.aosuc
                  and s.xlloaomda  = pre.aomda
                  and s.xlloaopap  = pre.aopap 
                  and s.xlloaocta  = pre.aocta
                  and s.xlloaooper = pre.aooper 
                  and s.xlloaosbop = pre.aosbop
                  and s.xlloaotope = pre.aotope ) Tip_Calendario,--forma de pago
              pre.aostat--estado de credito
              
        from fsh012 sal, fsr008 cta, fsd010 pre,
             fst014 tdo, fsd001 nom            
             
             
             
       where sal.bcemp = 1
         and sal.bcsuc = pn_numsuc
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
           VALUES(0,'CAR',i.rubro||lc_coderr, TRUNC(SYSDATE));
           COMMIT;
     end;       
     commit;
  end loop; 
  commit;
  update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'CAR';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'CAR';
    commit;
    return;

end sp_cartera_datos;   

Procedure sp_job_cartera_datos_II (pd_fecpro in varchar2 ) is
  ln_max number;
  ln_inc number;
  ln_ini number;
  ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_coderr varchar2(300);
  lc_hostname varchar2(64);
  cursor sucursal is 
  select sucurs from fst001 where pgcod =1 ;
  begin 
      begin
        select host_name
          into lc_hostname
          from v$instance;
      end;
     execute immediate ('truncate table reportes_tmp');
     delete Tab_jobs where  c_Codage = 'CAR';
     commit;
     for i in sucursal loop    
        ln_ini := i.sucurs;
        lc_variable := ' begin '|| '  pq_datos_fin_mes.sp_cartera_datos_II('||ln_ini||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
        ln_job := ln_job +1;
        --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
--         if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then   
--         if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
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
        VALUES('CAR',ln_ini,lc_variable);
        COMMIT;
      end loop; 
  exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'CAR',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

end sp_job_cartera_datos_II;
  
Procedure sp_cartera_datos_II (pn_numsuc in number, pd_fecpro in varchar2 ) is

ld_fecpro date;

lc_coderr varchar2(300); 
cursor rubro is
  select rubro
    from fsd014
   where (pcnivc in
         (select modulo
            from fst111
           where dscod = 50
             and modulo not in (29, 120, 144, 33, 200)) --33 castigado , 200 judicial
              or pcnivc in (141, 117))
     and pcimpu = 'S'
     and pmtit <> 9;
begin

  update tab_jobs g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'CAR';
  commit;
  ld_fecpro := to_date(pd_fecpro,'yyyymmdd');

    for i in rubro loop
     begin 
     
       insert into reportes_tmp (instancia,bcemp,bcmod,bcsuc,bcmda,bcpap,bccta,
                             bcoper,bcsbop,bctop,bcfval,bcfvto,pepais,
                             petdoc,pendoc,n_tippeq,d_fuleva,c_numcre,
                             tdnom,aoimp,scnom,tipo_credito,nro_credito,
                             monto_aprobado,producto,lineas,estad_cont,
                             nro_cuotas,valor_cuotas,fec_vto,fec_ult_pago,
                             aoperiod,tip_calen,aostat,penom,bcsdmo)
            select INSTANCIA,
                           BCEMP,
                           BCMOD,
                           BCSUC,
                           BCMDA,
                           BCPAP,
                           BCCTA,
                           BCOPER,
                           BCSBOP,
                           BCTOP,
                           BCFVAL,
                           BCFVTO,
                           PEPAIS,
                           PETDOC,
                           PENDOC,
                           N_TIPPEQ,--codigo pequeña empresa
                           D_FULEVA,
                           C_NUMCRE,
                           TDNOM,
                           AOIMP,--monto desembolsado
                           l.scnom,
                           Case When Substr(bcrubr, 1, 2) = '14' and
                                     Substr(bcrubr, 5, 2) = '02' then 'MICRO'
                                When Substr(bcrubr, 1, 2) = '14' and
                                     Substr(bcrubr, 5, 2) = '03' then 'CONSUMO'
                                When Substr(bcrubr, 1, 2) = '14' and
                                     Substr(bcrubr, 5, 2) = '04' then 'HIPOTECARIO'
                                When Substr(bcrubr, 1, 2) = '14' and
                                     Substr(bcrubr, 5, 2) = '12' then 'MEDIANA'
                                When Substr(bcrubr, 1, 2) = '14' and
                                     Substr(bcrubr, 5, 2) = '13' then 'PEQUEÑA'
                                When Substr(bcrubr,1,2) in ('71','72') and 
                                     Substr(bcrubr,7,2) = '02' then 'MICRO'
                                When Substr(bcrubr,1,2) in ('71','72') and 
                                     Substr(bcrubr,7,2) = '03' then 'CONSUMO'
                                When Substr(bcrubr,1,2) in ('71','72') and 
                                     Substr(bcrubr,7,2) = '04' then 'HIPOTECARIO'
                                When Substr(bcrubr,1,2) in ('71','72') and 
                                     Substr(bcrubr,7,2) = '12' then 'MEDIANA'
                                When Substr(bcrubr,1,2) in ('71','72') and 
                                     Substr(bcrubr,7,2) = '13' then 'PEQUEÑA'     
                                Else ''
                            End Tiposbs,
                   
                   (lpad(to_char(bccta), 9, '0') || lpad(to_char(bcmod), 3, '0') ||
                   lpad(to_char(bcmda), 3, '0') || lpad(to_char(bcoper), 9, '0') ||
                   lpad(to_char(bctop), 3, '0')) Nro_Credito,
                   
                   pq_datos_fin_mes.fn_mto_aprobado (bcemp,bcmod,bcsuc,bcmda,bcpap,
                                                     bccta,bcoper,bcsbop,bctop,aoimp),
                   (select k.tonom
                      from fst004 k
                     where k.modulo = BCMOD
                       and k.totope = bctop) producto,
                   (select j.mdnom from fst003 j where j.modulo = BCMOD) Lineas,
                   (Case
                                When Substr(bcrubr,1,2) = '14' and 
                                     Substr(bcrubr,4,1) = '1' then 'NORMAL'
                                When Substr(bcrubr,1,2) = '14' and 
                                     Substr(bcrubr,4,1) = '3' then 'REPROGRAMADO'
                                When Substr(bcrubr,1,2) = '14' and 
                                     Substr(bcrubr,4,1) = '4' then 'REFINANCIADO'
                                When Substr(bcrubr,1,2) = '14' and 
                                     Substr(bcrubr,4,1) = '5' then 'VENCIDO'
                                When Substr(bcrubr,1,2) = '14' and 
                                     Substr(bcrubr,4,1) = '6' then 'JUDICIAL'
                                Else                                'NORMAL'
                    End)Estado_Contable,
                    pq_datos_fin_mes.fn_nro_cuotas(bcemp,bcmod,bcsuc,bcmda,bcpap, bccta,bcoper,
                                                            bcsbop,bctop),
                     pq_datos_fin_mes.fn_valor_cuotas(bcemp,bcmod,bcsuc,bcmda,bcpap, bccta,bcoper,
                                                      bcsbop,bctop),
                     pq_datos_fin_mes.fn_Fec_Proximo_vto(bcemp,bcmod,bcsuc,bcmda,bcpap, bccta,bcoper,
                                                         bcsbop,bctop,ld_fecpro), 
                                                                                
                     pq_datos_fin_mes.fn_Fec_Ultimo_pago(bcemp,bcmod,bcsuc,bcmda,bcpap, bccta,bcoper,
                                                         bcsbop,bctop,ld_fecpro),
                     t.aoperiod ,
                     t.c_tipcalen,
                     t.aostat,
                     t.penom,
                     t.bcsdmo
                                                                              
                           
                    
                      from CARTERAFM_TMP t, fst001 l
                     where t.bcsuc = pn_numsuc
                       and t.bcrubr = i.rubro
                       and t.bcsuc = l.sucurs
                       and l.pgcod = t.bcemp
                       --and t.bcfech = ld_fecpro
                     ;
         commit;        
     exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'CAR',pn_numsuc||lc_coderr, TRUNC(SYSDATE));
           COMMIT;
     end;       
     commit;
  end loop;
  commit;
  update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'CAR';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'CAR';
    commit;
    return;

end sp_cartera_datos_II; 

Procedure sp_job_direcciones_datos(pd_fecpro in varchar2 ) is
  ln_max number;
  ln_inc number;
  ln_ini number;
  ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_coderr varchar2(300);
  lc_hostname varchar2(64);
  cursor sucursal is 
  select sucurs from fst001 where pgcod =1 ;
  begin 
      begin
        select host_name
          into lc_hostname
          from v$instance;
      end;
     execute immediate ('truncate table reportes_tmp');
     delete Tab_jobs where  c_Codage = 'DIRE';
     commit;
     for i in sucursal loop    
        ln_ini := i.sucurs;
        lc_variable := ' begin '|| '  pq_datos_fin_mes.sp_direcciones_datos('||ln_ini||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
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
        VALUES('DIRE',ln_ini,lc_variable);
        COMMIT;
      end loop; 
  exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'DIRE',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

end sp_job_direcciones_datos;
  
Procedure sp_direcciones_datos (pn_numsuc in number, pd_fecpro in varchar2 ) is

ld_fecpro date;

lc_coderr varchar2(300); 
cursor rubro is
  select rubro
    from fsd014
   where (pcnivc in
         (select modulo
            from fst111
           where dscod = 50
             and modulo not in (29, 120, 144, 33, 200)) --33 castigado , 200 judicial
              or pcnivc in (141, 117))
     and pcimpu = 'S'
     and pmtit <> 9;
begin

  update tab_jobs g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'DIRE';
  commit;
  ld_fecpro := to_date(pd_fecpro,'yyyymmdd');

    for i in rubro loop
     begin 
     
       insert into reportes_tmp (instancia,bcemp,bcmod,bcsuc,bcmda,bcpap,bccta,
                             bcoper,bcsbop,bctop,bcfval,bcfvto,pepais,
                             petdoc,pendoc,nro_credito,bcfech,dirneg,depneg,
                             provneg,distneg,refneg,desneg,codciiu,desciiu,
                             dirtit,deptit,provtit,distit,reftit)
            select INSTANCIA,
                   BCEMP,
                   BCMOD,
                   BCSUC,
                   BCMDA,
                   BCPAP,
                   BCCTA,
                   BCOPER,
                   BCSBOP,
                   BCTOP,
                   BCFVAL,
                   BCFVTO,
                   PEPAIS,
                   PETDOC,
                   PENDOC,
                   (lpad(to_char(bccta), 9, '0') || lpad(to_char(bcmod), 3, '0') ||
                   lpad(to_char(bcmda), 3, '0') || lpad(to_char(bcoper), 9, '0') ||
                   lpad(to_char(bctop), 3, '0')) Nro_Credito,
                   bcfech,
                   pq_datos_fin_mes.fn_direccion_N(pepais,petdoc,pendoc),
                   pq_datos_fin_mes.fn_departamento_N(pepais,petdoc,pendoc),
                   pq_datos_fin_mes.fn_provincia_N(pepais,petdoc,pendoc),
                   pq_datos_fin_mes.fn_distrito_N(pepais,petdoc,pendoc),
                   pq_datos_fin_mes.fn_ref_N(pepais,petdoc,pendoc),
                   pq_datos_fin_mes.fn_negocio(pepais,petdoc,pendoc),
                   pq_datos_fin_mes.fn_cod_activ(pepais,petdoc,pendoc),
                   pq_datos_fin_mes.fn_actividad(pepais,petdoc,pendoc),
                   pq_datos_fin_mes.fn_direccion_T(pepais,petdoc,pendoc),
                   pq_datos_fin_mes.fn_departamento_T(pepais,petdoc,pendoc),
                   pq_datos_fin_mes.fn_provincia_T(pepais,petdoc,pendoc),
                   pq_datos_fin_mes.fn_distrito_T(pepais,petdoc,pendoc),
                   pq_datos_fin_mes.fn_ref_T(pepais,petdoc,pendoc)
                   
              from CARTERAFM_TMP t
             where t.bcsuc = pn_numsuc
               and t.bcrubr = i.rubro
               
               --and t.bcfech = ld_fecpro
                     ;
         commit;        
     exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'DIRE',pn_numsuc||lc_coderr, TRUNC(SYSDATE));
           COMMIT;
     end;       
     commit;
  end loop;
  commit;
  update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'DIRE';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'DIRE';
    commit;
    return;

end sp_direcciones_datos; 

Procedure sp_job_adicionales_datos(pd_fecpro in varchar2 ) is
  ln_max number;
  ln_inc number;
  ln_ini number;
  ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_coderr varchar2(300);
  lc_hostname varchar2(64);
  cursor sucursal is 
  select sucurs from fst001 where pgcod =1 ;
  begin 
    
    begin
      select host_name
        into lc_hostname
        from v$instance;
    end;
     execute immediate ('truncate table reportes_tmp');
     delete Tab_jobs where  c_Codage = 'ADI';
     commit;
     for i in sucursal loop    
        ln_ini := i.sucurs;
        lc_variable := ' begin '|| '  pq_datos_fin_mes.sp_adicionales_datos('||ln_ini||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
        ln_job := ln_job +1;
        --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
--     if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then     
--     if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
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
        VALUES('ADI',ln_ini,lc_variable);
        COMMIT;
      end loop; 
  exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'ADI',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

end sp_job_adicionales_datos;
  
Procedure sp_adicionales_datos (pn_numsuc in number, pd_fecpro in varchar2 ) is

ld_fecpro date;

lc_coderr varchar2(300); 
cursor rubro is
  select rubro
    from fsd014
   where (pcnivc in
         (select modulo
            from fst111
           where dscod = 50
             and modulo not in (29, 120, 144, 33, 200)) --33 castigado , 200 judicial
              or pcnivc in (141, 117))
     and pcimpu = 'S'
     and pmtit <> 9;
begin

  update tab_jobs g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'ADI';
  commit;
  ld_fecpro := to_date(pd_fecpro,'yyyymmdd');

    for i in rubro loop
     begin 
     
       insert into reportes_tmp (instancia,bcemp,bcmod,bcsuc,bcmda,bcpap,bccta,
                             bcoper,bcsbop,bctop,bcfval,bcfvto,pepais,
                             petdoc,pendoc,nro_credito,bcfech,cod_ana,des_ana,
                             dias_gracia,fecha_resolucion,importe_gar,moneda_gar,
                             des_garantia)
            select INSTANCIA,
                   BCEMP,
                   BCMOD,
                   BCSUC,
                   BCMDA,
                   BCPAP,
                   BCCTA,
                   BCOPER,
                   BCSBOP,
                   BCTOP,
                   BCFVAL,
                   BCFVTO,
                   PEPAIS,
                   PETDOC,
                   PENDOC,
                   (lpad(to_char(bccta), 9, '0') || lpad(to_char(bcmod), 3, '0') ||
                   lpad(to_char(bcmda), 3, '0') || lpad(to_char(bcoper), 9, '0') ||
                   lpad(to_char(bctop), 3, '0')) Nro_Credito,
                   bcfech,
                   pq_datos_fin_mes.fn_cod_analista(instancia,pepais,petdoc,pendoc),
                   pq_datos_fin_mes.fn_des_analista(instancia,pepais,petdoc,pendoc),
                   pq_datos_fin_mes.fn_dias_gracia(bcemp,bcmod,bcsuc,bcmda,bcpap,bccta,
                                                   bcoper,bcsbop,bctop),
                   (select c.sng120fval
                      from sng120 c
                     where t.instancia = c.sng120ins
                       and c.sng120tsk = 'APROBACION'
                       and rownum = 1) Fecha_Aprobacion,
                    pq_datos_fin_mes.fn_importe_garantia(bcemp,bcmod,bcsuc,bcmda,bcpap,
                                                         bccta,bcoper,bcsbop,bctop,bcsdmo),
                    pq_datos_fin_mes.fn_moneda_garantia(bcemp,bcmod,bcsuc,bcmda,bcpap,
                                                         bccta,bcoper,bcsBop,bctop),
                    pq_datos_fin_mes.fn_des_garantia(bcmod,bctop)                                                                                   
                   
                   
              from CARTERAFM_TMP t
             where t.bcsuc = pn_numsuc
               and t.bcrubr = i.rubro
               
               
               --and t.bcfech = ld_fecpro
                     ;
         commit;        
     exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'ADI',pn_numsuc||lc_coderr, TRUNC(SYSDATE));
           COMMIT;
     end;       
     commit;
  end loop;
  commit;
  update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'ADI';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'ADI';
    commit;
    return;

end sp_adicionales_datos; 

Procedure sp_job_evaluacion_datos(pd_fecpro in varchar2 ) is
  ln_max number;
  ln_inc number;
  ln_ini number;
  ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_coderr varchar2(300);
  lc_hostname varchar2(64);
  cursor sucursal is 
  select sucurs from fst001 where pgcod =1 ;
  begin 
      begin
      select host_name
        into lc_hostname
        from v$instance;
    end;
     execute immediate ('truncate table reportes_tmp');
     delete Tab_jobs where  c_Codage = 'ADI';
     commit;
     for i in sucursal loop    
        ln_ini := i.sucurs;
        lc_variable := ' begin '|| '  pq_datos_fin_mes.sp_evaluacion_datos('||ln_ini||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
        ln_job := ln_job +1;
        --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
--         if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then   
--         if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
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
        VALUES('ADI',ln_ini,lc_variable);
        COMMIT;
      end loop; 
  exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'ADI',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

end sp_job_evaluacion_datos;
  
Procedure sp_evaluacion_datos (pn_numsuc in number, pd_fecpro in varchar2 ) is

ld_fecpro date;

lc_coderr varchar2(300); 
cursor rubro is
  select rubro
    from fsd014
   where (pcnivc in
         (select modulo
            from fst111
           where dscod = 50
             and modulo not in (29, 120, 144, 33, 200)) --33 castigado , 200 judicial
              or pcnivc in (141, 117))
     and pcimpu = 'S'
     and pmtit <> 9;
begin

  update tab_jobs g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'ADI';
  commit;
  ld_fecpro := to_date(pd_fecpro,'yyyymmdd');

    for i in rubro loop
     begin 
     
       insert into reportes_tmp (instancia,bcemp,bcmod,bcsuc,bcmda,bcpap,bccta,
                             bcoper,bcsbop,bctop,bcfval,bcfvto,pepais,
                             petdoc,pendoc,nro_credito,bcfech,caja_banco,caja_banco_dol,
                             cuentas_cobrar,cuentas_cobrar_dol,mercaderia,mercaderia_dol,ventas,
                             ventas_dol,costos_ventas,costos_ventas_dol,inmuebles,inmuebles_dol,
                             muebles_maq_equi,muebles_maq_equi_dol,gastos_fam,gastos_fam_dol,
                             resul_neto,resul_neto_dol)
            select INSTANCIA,
                   BCEMP,
                   BCMOD,
                   BCSUC,
                   BCMDA,
                   BCPAP,
                   BCCTA,
                   BCOPER,
                   BCSBOP,
                   BCTOP,
                   BCFVAL,
                   BCFVTO,
                   PEPAIS,
                   PETDOC,
                   PENDOC,
                   (lpad(to_char(bccta), 9, '0') || lpad(to_char(bcmod), 3, '0') ||
                   lpad(to_char(bcmda), 3, '0') || lpad(to_char(bcoper), 9, '0') ||
                   lpad(to_char(bctop), 3, '0')) Nro_Credito,
                   bcfech,
                   pq_datos_fin_mes.fn_evaluacion(instancia,41,13)caja_bancos,
                   pq_datos_fin_mes.fn_evaluacion(instancia,541,13)caja_bancos_dol,
                   pq_datos_fin_mes.fn_evaluacion(instancia,42,13)cuentas_cobrar,
                   pq_datos_fin_mes.fn_evaluacion(instancia,542,13)cuentas_cobrar_dol,
                   pq_datos_fin_mes.fn_evaluacion(instancia,43,13)mercaderias,
                   pq_datos_fin_mes.fn_evaluacion(instancia,543,13)mercaderias_Dol,
                   pq_datos_fin_mes.fn_evaluacion(instancia,73,13)ventas,
                   pq_datos_fin_mes.fn_evaluacion(instancia,573,13)ventas_dol,
                   pq_datos_fin_mes.fn_evaluacion(instancia,74,13)costo_ventas,
                   pq_datos_fin_mes.fn_evaluacion(instancia,574,13)costo_ventas_dol,
                   pq_datos_fin_mes.fn_evaluacion(instancia,49,13)inmuebles,
                   pq_datos_fin_mes.fn_evaluacion(instancia,549,13)inmuebles_dol,
                   pq_datos_fin_mes.fn_evaluacion(instancia,48,13)muebles_maq_equ,
                   pq_datos_fin_mes.fn_evaluacion(instancia,548,13)muebles_maq_equ_dol,
                   pq_datos_fin_mes.fn_evaluacion(instancia,54,13)gastos_fam,
                   pq_datos_fin_mes.fn_evaluacion(instancia,554,13)gastos_fam_dol,
                   pq_datos_fin_mes.fn_evaluacion(instancia,40,13)resultado_neto,
                   pq_datos_fin_mes.fn_evaluacion(instancia,540,13)resultado_neto_dol
                                                                                                  
                   
                   
              from CARTERAFM_TMP t
             where t.bcsuc = pn_numsuc
               and t.bcrubr = i.rubro
               
               
               --and t.bcfech = ld_fecpro
                     ;
         commit;        
     exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'ADI',pn_numsuc||lc_coderr, TRUNC(SYSDATE));
           COMMIT;
     end;       
     commit;
  end loop;
  commit;
  update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'ADI';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'ADI';
    commit;
    return;

end sp_evaluacion_datos; 

function fn_evaluacion (pn_instancia in number, pn_codigo in number, pn_tipo in number) 
                       return number is

ln_valor number;
begin
 
  begin
    select distinct f.sng023mto
           into ln_valor
          from sng021 e, sng023 f
         where e.sng021sol = pn_instancia
           and e.sng021tmod = pn_tipo
           and e.sng021eval = f.sng021eval
           and f.sng026cod = pn_codigo
           and rownum = 1
   
       ;
  exception 
      when no_data_found then 
         ln_valor := null;
      when too_many_rows then
         ln_valor := null;
  end;   
  
   return ln_valor;
end fn_evaluacion;

Procedure sp_job_avales_datos(pd_fecpro in varchar2 ) is
  ln_max number;
  ln_inc number;
  ln_ini number;
  ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_coderr varchar2(300);
  lc_hostname varchar2(64);
  cursor sucursal is 
  select sucurs from fst001 where pgcod =1 ;
  begin 
      begin
        select host_name
          into lc_hostname
          from v$instance;
      end;
     execute immediate ('truncate table reportes_tmp');
     delete Tab_jobs where  c_Codage = 'AVL';
     commit;
     for i in sucursal loop    
        ln_ini := i.sucurs;
        lc_variable := ' begin '|| '  pq_datos_fin_mes.sp_avales_datos('||ln_ini||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
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
        VALUES('AVL',ln_ini,lc_variable);
        COMMIT;
      end loop; 
  exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'AVL',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

end sp_job_avales_datos;
  
Procedure sp_avales_datos (pn_numsuc in number, pd_fecpro in varchar2 ) is

ld_fecpro date;

lc_coderr varchar2(300); 
cursor rubro is
  select rubro
    from fsd014
   where (pcnivc in
         (select modulo
            from fst111
           where dscod = 50
             and modulo not in (29, 120, 144, 33, 200)) --33 castigado , 200 judicial
              or pcnivc in (141, 117))
     and pcimpu = 'S'
     and pmtit <> 9;
begin

  update tab_jobs g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'AVL';
  commit;
  ld_fecpro := to_date(pd_fecpro,'yyyymmdd');

    for i in rubro loop
     begin 
     
       insert into reportes_tmp (instancia,bcemp,bcmod,bcsuc,bcmda,bcpap,bccta,
                             bcoper,bcsbop,bctop,bcfval,bcfvto,pepais,
                             petdoc,pendoc,nro_credito,bcfech,aval,avltdoc,
                             avlndoc,avlcony,avlconytdoc,avlconyndoc,dirtit,
                             deptit,provtit,distit,reftit)
            select INSTANCIA,
                   BCEMP,
                   BCMOD,
                   BCSUC,
                   BCMDA,
                   BCPAP,
                   BCCTA,
                   BCOPER,
                   BCSBOP,
                   BCTOP,
                   BCFVAL,
                   BCFVTO,
                   t.PEPAIS,
                   t.PETDOC,
                   t.PENDOC,
                   (lpad(to_char(bccta), 9, '0') || lpad(to_char(bcmod), 3, '0') ||
                   lpad(to_char(bcmda), 3, '0') || lpad(to_char(bcoper), 9, '0') ||
                   lpad(to_char(bctop), 3, '0')) Nro_Credito,
                   bcfech,
                   
                   pq_datos_fin_mes.fn_aval_nombre(instancia),
                   pq_datos_fin_mes.fn_aval_tdoc(instancia),
                   pq_datos_fin_mes.fn_aval_ndoc(instancia),
                   pq_datos_fin_mes.fn_conyugue_nombre(instancia),
                   pq_datos_fin_mes.fn_conyugue_tdoc(instancia),
                   pq_datos_fin_mes.fn_conyugue_ndoc(instancia),
                   pq_datos_fin_mes.fn_direccion_aval(t.bccta),
                   pq_datos_fin_mes.fn_departamento_aval(t.bccta),
                   pq_datos_fin_mes.fn_provincia_aval(t.bccta),
                   pq_datos_fin_mes.fn_distrito_aval(t.bccta),
                   pq_datos_fin_mes.fn_ref_aval(t.bccta)
                   
              from CARTERAFM_TMP t,SNG003 a
             where t.bcsuc      = pn_numsuc
               and t.bcrubr     = i.rubro
               and t.instancia  = a.sng001inst  (+)
               and t.bcemp      = a.sng003pgc   (+)
               
               --and t.bcfech = ld_fecpro
                     ;
         commit;        
     exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'AVL',pn_numsuc||lc_coderr, TRUNC(SYSDATE));
           COMMIT;
     end;       
     commit;
  end loop;
  commit;
  update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'AVL';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'AVL';
    commit;
    return;

end sp_avales_datos; 

function fn_importe_garantia (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                             pn_pap in number, pn_cta in number, pn_oper in number,
                             pn_sbop in number,pn_top in number, pn_saldo in number) return number is
lc_var char(3);
ln_importe number;
begin
 begin
  begin
    select /*+parallel(n,2,1)*/  
           'S' 
      into lc_var   
      from fsr011 n 
     where n.r1cod  = pn_emp     
       and n.r1mod  = pn_mod      
       and n.r1suc  = pn_suc     
       and n.r1mda  = pn_mda    
       and n.r1pap  = pn_pap    
       and n.r1cta  = pn_cta  
       and n.r1oper = pn_oper  
       and n.r1sbop = pn_sbop  
       and n.r1tope = pn_top    
       and n.relcod = 50
       ;
  exception 
      when no_data_found then 
         lc_var := null;
      when too_many_rows then
         lc_var := null;
  end;   
  if lc_var = 'S' then
     ln_importe := pn_saldo;
  end if;
 end;
   return ln_importe;
end fn_importe_garantia;

function fn_moneda_garantia (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                             pn_pap in number, pn_cta in number, pn_oper in number,
                             pn_sbop in number,pn_top in number) return number is

ln_moneda number;
begin
 
  begin
    select /*+parallel(n,2,1)*/  
           n.r1mda 
      into ln_moneda   
      from fsr011 n 
     where n.r1cod  = pn_emp     
       and n.r1mod  = pn_mod      
       and n.r1suc  = pn_suc     
       and n.r1mda  = pn_mda    
       and n.r1pap  = pn_pap    
       and n.r1cta  = pn_cta  
       and n.r1oper = pn_oper  
       and n.r1sbop = pn_sbop  
       and n.r1tope = pn_top    
       and n.relcod = 50
       ;
  exception 
      when no_data_found then 
         ln_moneda := null;
      when too_many_rows then
         ln_moneda := null;
  end;   
  
   return ln_moneda;
end fn_moneda_garantia;

function fn_des_garantia (pn_mod in number,pn_top in number) return varchar2 is

lc_garantia varchar2(70);
begin
 
  begin
    select /*+parallel(n,2,1)*/  
           n.tonom 
      into lc_garantia   
      from fst004 n 
     where n.modulo = pn_mod     
       and n.totope = pn_top  
       and n.modulo = 70    
       
       ;
  exception 
      when no_data_found then 
         lc_garantia := null;
      when too_many_rows then
         lc_garantia := null;
  end;   
  
   return lc_garantia;
end fn_des_garantia;


function fn_direccion_N (pn_pais in number, pn_tdoc in number,pc_ndoc in char ) return varchar2 is
lc_dir varchar2(200);
begin
  begin
  select aa.sngc13dir
    into lc_dir
    from sngc13 aa
   where aa.sngc13pais = pn_pais
     and aa.sngc13tdoc = pn_tdoc
     and aa.sngc13ndoc = pc_ndoc
     and aa.docod = 3;
  exception 
      when no_data_found then 
         lc_dir := null;
      when too_many_rows then
         lc_dir := null;
     end;   
    
   return lc_dir;
end fn_direccion_N;

function fn_ref_N (pn_pais in number, pn_tdoc in number,pc_ndoc in char ) return varchar2 is
lc_ref varchar2(200);
begin
  begin
  select aa.sngc13ref1
    into lc_ref
    from sngc13 aa
   where aa.sngc13pais = pn_pais
     and aa.sngc13tdoc = pn_tdoc
     and aa.sngc13ndoc = pc_ndoc
     and aa.docod = 3;
  exception 
      when no_data_found then 
         lc_ref := null;
      when too_many_rows then
         lc_ref := null;
     end;   
    
   return lc_ref;
end fn_ref_N;


function fn_provincia_N (pn_pais in number, pn_tdoc in number,pc_ndoc in char ) return varchar2 is
lc_provin varchar2(50);
begin
  begin
  select xx.locnom
    into lc_provin
    from sngc13 aa, fst070 xx
   where aa.sngc13pais = pn_pais
     and aa.sngc13tdoc = pn_tdoc
     and aa.sngc13ndoc = pc_ndoc
     and aa.sngc13pais = xx.pais
     and aa.sngc13dpto = xx.depcod
     and aa.sngc13prov = xx.loccod
     and aa.docod = 3;
  exception 
      when no_data_found then 
         lc_provin := null;
      when too_many_rows then
         lc_provin := null;
     end;   
    
   return lc_provin;
end fn_provincia_N;

function fn_departamento_N (pn_pais in number, pn_tdoc in number,pc_ndoc in char ) return varchar2 is
lc_dep varchar2(50);
begin
  begin
  select xx.depnom
    into lc_dep
    from sngc13 aa, fst068 xx
   where aa.sngc13pais = pn_pais
     and aa.sngc13tdoc = pn_tdoc
     and aa.sngc13ndoc = pc_ndoc
     and aa.sngc13pais = xx.pais
     and aa.sngc13dpto = xx.depcod
     and aa.docod = 3;
  exception 
      when no_data_found then 
         lc_dep := null;
      when too_many_rows then
         lc_dep := null;
     end;   
    
   return lc_dep;
end fn_departamento_N;

function fn_distrito_N (pn_pais in number, pn_tdoc in number,pc_ndoc in char ) return varchar2 is
lc_dis varchar2(50);
begin
  begin
  select xx.fst071dsc
    into lc_dis
    from sngc13 aa, fst071 xx
   where aa.sngc13pais = pn_pais
     and aa.sngc13tdoc = pn_tdoc
     and aa.sngc13ndoc = pc_ndoc
     and aa.sngc13pais = xx.fst071pai
     and aa.sngc13dpto = xx.fst071dpt
     and aa.sngc13prov = xx.fst071loc
     and aa.sngc13dist = xx.fst071col
     and aa.docod = 3;
  exception 
      when no_data_found then 
         lc_dis := null;
      when too_many_rows then
         lc_dis := null;
     end;   
    
   return lc_dis;
end fn_distrito_N;


function fn_direccion_T (pn_pais in number, pn_tdoc in number,pc_ndoc in char ) return varchar2 is
lc_dir varchar2(200);
begin
  begin
  select aa.sngc13dir
    into lc_dir
    from sngc13 aa
   where aa.sngc13pais = pn_pais
     and aa.sngc13tdoc = pn_tdoc
     and aa.sngc13ndoc = pc_ndoc
     and aa.docod = 1;
  exception 
      when no_data_found then 
         lc_dir := null;
      when too_many_rows then
         lc_dir := null;
     end;   
    
   return lc_dir;
end fn_direccion_T;

function fn_ref_T (pn_pais in number, pn_tdoc in number,pc_ndoc in char ) return varchar2 is
lc_ref varchar2(200);
begin
  begin
  select aa.sngc13ref1
    into lc_ref
    from sngc13 aa
   where aa.sngc13pais = pn_pais
     and aa.sngc13tdoc = pn_tdoc
     and aa.sngc13ndoc = pc_ndoc
     and aa.docod = 1;
  exception 
      when no_data_found then 
         lc_ref := null;
      when too_many_rows then
         lc_ref := null;
     end;   
    
   return lc_ref;
end fn_ref_T;


function fn_provincia_T (pn_pais in number, pn_tdoc in number,pc_ndoc in char ) return varchar2 is
lc_provin varchar2(50);
begin
  begin
  select xx.locnom
    into lc_provin
    from sngc13 aa, fst070 xx
   where aa.sngc13pais = pn_pais
     and aa.sngc13tdoc = pn_tdoc
     and aa.sngc13ndoc = pc_ndoc
     and aa.sngc13dpto = xx.depcod
     and aa.sngc13prov = xx.loccod
     and aa.docod = 1;
  exception 
      when no_data_found then 
         lc_provin := null;
      when too_many_rows then
         lc_provin := null;
     end;   
    
   return lc_provin;
end fn_provincia_T;

function fn_departamento_T (pn_pais in number, pn_tdoc in number,pc_ndoc in char ) return varchar2 is
lc_dep varchar2(50);
begin
  begin
  select xx.depnom
    into lc_dep
    from sngc13 aa, fst068 xx
   where aa.sngc13pais = pn_pais
     and aa.sngc13tdoc = pn_tdoc
     and aa.sngc13ndoc = pc_ndoc
     and aa.sngc13pais = xx.pais
     and aa.sngc13dpto = xx.depcod
     and aa.docod = 1;
  exception 
      when no_data_found then 
         lc_dep := null;
      when too_many_rows then
         lc_dep := null;
     end;   
    
   return lc_dep;
end fn_departamento_T;

function fn_distrito_T (pn_pais in number, pn_tdoc in number,pc_ndoc in char ) return varchar2 is
lc_dis varchar2(50);
begin
  begin
  select xx.fst071dsc
    into lc_dis
    from sngc13 aa, fst071 xx
   where aa.sngc13pais = pn_pais
     and aa.sngc13tdoc = pn_tdoc
     and aa.sngc13ndoc = pc_ndoc
     and aa.sngc13pais = xx.fst071pai
     and aa.sngc13dpto = xx.fst071dpt
     and aa.sngc13prov = xx.fst071loc
     and aa.sngc13dist = xx.fst071col
     and aa.docod = 1;
  exception 
      when no_data_found then 
         lc_dis := null;
      when too_many_rows then
         lc_dis := null;
     end;   
    
   return lc_dis;
end fn_distrito_T;

function fn_negocio (pn_pais in number, pn_tdoc in number,pc_ndoc in char ) return varchar2 is
lc_negocio varchar2(200);
begin
  begin
  select aa.sngc60nome
    into lc_negocio
    from sngc60 aa
   where aa.sngc60pais = pn_pais
     and aa.sngc60tdoc = pn_tdoc
     and aa.sngc60ndoc = pc_ndoc
     and aa.sngc60corr = 0;
  exception 
      when no_data_found then 
         lc_negocio := null;
      when too_many_rows then
         lc_negocio := null;
  end;   
   return lc_negocio;
end fn_negocio;

function fn_aval_tdoc (pn_instancia in number) return varchar2 is
lc_tdoc varchar2(200);
begin
  begin
  select cc.tdnom
    into lc_tdoc
    from sng003 aa, fsr008 bb,fst014 cc
   where aa.sng001inst = pn_instancia
     and aa.sng003cta  = bb.ctnro    
     and aa.sng003pgc  = bb.pgcod
     and bb.petdoc     = cc.tdocum
     and bb.cttfir     = 'T';
  exception 
      when no_data_found then 
         lc_tdoc := null;
      when too_many_rows then
         lc_tdoc := null;
     end;   
    
   return lc_tdoc;
end fn_aval_tdoc;

function fn_aval_ndoc (pn_instancia in number) return number is
ln_ndoc number;
begin
  begin
  select bb.pendoc
    into ln_ndoc
    from sng003 aa, fsr008 bb
   where aa.sng001inst = pn_instancia
     and aa.sng003cta  = bb.ctnro    
     and aa.sng003pgc  = bb.pgcod
     and bb.cttfir     = 'T';
  exception 
      when no_data_found then 
         ln_ndoc := null;
      when too_many_rows then
         ln_ndoc := null;
     end;   
    
   return ln_ndoc;
end fn_aval_ndoc;

function fn_aval_nombre (pn_instancia in number) return varchar2 is
lc_aval varchar2(200);
begin
  begin
  select dd.penom
    into lc_aval
    from sng003 aa, fsr008 bb,fsd001 dd
   where aa.sng001inst = pn_instancia
     and aa.sng003cta  = bb.ctnro    
     and aa.sng003pgc  = bb.pgcod
     and bb.pepais     = dd.pepais
     and bb.petdoc     = dd.petdoc
     and bb.pendoc     = dd.pendoc
     and bb.cttfir     = 'T';
  exception 
      when no_data_found then 
         lc_aval := null;
      when too_many_rows then
         lc_aval := null;
     end;   
    
   return lc_aval;
end fn_aval_nombre;

function fn_conyugue_nombre (pn_instancia in number) return varchar2 is
lc_cony varchar2(200);
begin
  begin
  select ee.penom
    into lc_cony
    from sng003 aa, fsr008 bb,fsr002 dd, fsd001 ee
   where aa.sng001inst = pn_instancia
     and aa.sng003cta  = bb.ctnro    
     and aa.sng003pgc  = bb.pgcod
     and bb.pepais     = dd.pepais
     and bb.petdoc     = dd.petdoc
     and bb.pendoc     = dd.pendoc
     and rpccyg        = 66
     and dd.rppais     = ee.pepais
     and dd.rptdoc     = ee.petdoc
     and dd.rpndoc     = ee.pendoc
     and bb.cttfir     = 'T';
  exception 
      when no_data_found then 
         lc_cony := null;
      when too_many_rows then
         lc_cony := null;
     end;   
    
   return lc_cony;
end fn_conyugue_nombre;

function fn_conyugue_tdoc (pn_instancia in number) return varchar2 is
lc_tdoc varchar2(20);
begin
  begin
  select ff.tdnom
    into lc_tdoc
    from sng003 aa, fsr008 bb,fsr002 dd, fsd001 ee,
         fst014 ff
   where aa.sng001inst = pn_instancia
     and aa.sng003cta  = bb.ctnro    
     and aa.sng003pgc  = bb.pgcod
     and bb.pepais     = dd.pepais
     and bb.petdoc     = dd.petdoc
     and bb.pendoc     = dd.pendoc
     and rpccyg        = 66
     and dd.rppais     = ee.pepais
     and dd.rptdoc     = ee.petdoc
     and dd.rpndoc     = ee.pendoc
     and ee.petdoc     = ff.tdocum
     and bb.cttfir     = 'T';
  exception 
      when no_data_found then 
         lc_tdoc := null;
      when too_many_rows then
         lc_tdoc := null;
     end;   
    
   return lc_tdoc;
end fn_conyugue_tdoc;

function fn_conyugue_ndoc (pn_instancia in number) return varchar2 is
ln_ndoc number;
begin
  begin
  select ee.pendoc
    into ln_ndoc
    from sng003 aa, fsr008 bb,fsr002 dd, fsd001 ee
   where aa.sng001inst = pn_instancia
     and aa.sng003cta  = bb.ctnro    
     and aa.sng003pgc  = bb.pgcod
     and bb.pepais     = dd.pepais
     and bb.petdoc     = dd.petdoc
     and bb.pendoc     = dd.pendoc
     and rpccyg        = 66
     and dd.rppais     = ee.pepais
     and dd.rptdoc     = ee.petdoc
     and dd.rpndoc     = ee.pendoc
     and bb.cttfir     = 'T';
     
  exception 
      when no_data_found then 
         ln_ndoc := null;
      when too_many_rows then
         ln_ndoc := null;
     end;   
    
   return ln_ndoc;
end fn_conyugue_ndoc;

function fn_direccion_aval (pn_cta in number) return varchar2 is
lc_dir varchar2(200);
begin
  begin
  select aa.sngc13dir
    into lc_dir
    from sngc13 aa,fsr008 bb
   where aa.sngc13pais = bb.pepais
     and aa.sngc13tdoc = bb.petdoc
     and aa.sngc13ndoc = bb.pendoc
     and bb.ctnro      = pn_cta
     and aa.docod = 1
     and bb.cttfir     = 'T';
  exception 
      when no_data_found then 
         lc_dir := null;
      when too_many_rows then
         lc_dir := null;
     end;   
    
   return lc_dir;
end fn_direccion_aval;

function fn_ref_aval (pn_cta in number) return varchar2 is
lc_ref varchar2(200);
begin
  begin
  select aa.sngc13ref1
    into lc_ref
    from sngc13 aa,fsr008 bb
   where aa.sngc13pais = bb.pepais
     and aa.sngc13tdoc = bb.petdoc
     and aa.sngc13ndoc = bb.pendoc
     and bb.ctnro      = pn_cta
     and aa.docod = 1
     and bb.cttfir     = 'T';
  exception 
      when no_data_found then 
         lc_ref := null;
      when too_many_rows then
         lc_ref := null;
     end;   
    
   return lc_ref;
end fn_ref_aval;


function fn_provincia_aval (pn_cta in number) return varchar2 is
lc_provin varchar2(50);
begin
  begin
  select xx.locnom
    into lc_provin
    from sngc13 aa, fst070 xx,fsr008 bb
   where aa.sngc13pais = bb.pepais
     and aa.sngc13tdoc = bb.petdoc
     and aa.sngc13ndoc = bb.pendoc
     and bb.ctnro      = pn_cta
     and aa.sngc13dpto = xx.depcod
     and aa.sngc13prov = xx.loccod
     and aa.docod = 1
     and bb.cttfir     = 'T';
  exception 
      when no_data_found then 
         lc_provin := null;
      when too_many_rows then
         lc_provin := null;
     end;   
    
   return lc_provin;
end fn_provincia_aval;

function fn_departamento_aval (pn_cta in number) return varchar2 is
lc_dep varchar2(50);
begin
  begin
  select xx.depnom
    into lc_dep
    from sngc13 aa, fst068 xx,fsr008 bb
   where aa.sngc13pais = bb.pepais
     and aa.sngc13tdoc = bb.petdoc
     and aa.sngc13ndoc = bb.pendoc
     and bb.ctnro      = pn_cta
     and aa.sngc13pais = xx.pais
     and aa.sngc13dpto = xx.depcod
     and aa.docod = 1
     and bb.cttfir     = 'T';
  exception 
      when no_data_found then 
         lc_dep := null;
      when too_many_rows then
         lc_dep := null;
     end;   
    
   return lc_dep;
end fn_departamento_aval;

function fn_distrito_aval (pn_cta in number) return varchar2 is
lc_dis varchar2(50);
begin
  begin
  select xx.fst071dsc
    into lc_dis
    from sngc13 aa, fst071 xx,fsr008 bb
   where aa.sngc13pais = bb.pepais
     and aa.sngc13tdoc = bb.petdoc
     and aa.sngc13ndoc = bb.pendoc
     and bb.ctnro      = pn_cta
     and aa.sngc13pais = xx.fst071pai
     and aa.sngc13dpto = xx.fst071dpt
     and aa.sngc13prov = xx.fst071loc
     and aa.sngc13dist = xx.fst071col
     and aa.docod = 1
     and bb.cttfir     = 'T';
  exception 
      when no_data_found then 
         lc_dis := null;
      when too_many_rows then
         lc_dis := null;
     end;   
    
   return lc_dis;
end fn_distrito_aval;

Procedure sp_job_Equifax_datos (pd_fecpro in varchar2 ) is
  ln_max number;
  ln_inc number;
  ln_ini number;
  ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_coderr varchar2(300);
  lc_hostname varchar2(64);
  cursor sucursal is 
  select sucurs from fst001 where pgcod =1 ;
  begin 
      begin
        select host_name
          into lc_hostname
          from v$instance;
      end;
     execute immediate ('truncate table CARTERAFM');
     execute immediate ('alter session set parallel_force_local=TRUE');--JFLOR 2014.01.15     
     delete Tab_jobs where  c_Codage = 'EQFX';
     commit;
     for i in sucursal loop    
        ln_ini := i.sucurs;
        lc_variable := ' begin '|| '  pq_datos_fin_mes.sp_equifax_datos('||ln_ini||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
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
        VALUES('EQFX',ln_ini,lc_variable);
        COMMIT;
      end loop; 
  exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'EQFX',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

end sp_job_Equifax_datos;
  
Procedure sp_equifax_datos (pn_numsuc in number, pd_fecpro in varchar2 ) is

ld_fecpro date ;
lc_coderr varchar2(300); 
cursor rubro is
  select rubro
    from fsd014
   where (pcnivc in
         (select modulo
            from fst111
           where dscod = 50
             and modulo not in (29, 120, 144/*, 33, 200*/)) --33 castigado , 200 judicial
              or pcnivc in (141, 117))
     and pcimpu = 'S'
     and pmtit <> 9;

begin

  update tab_jobs g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'EQFX';
  commit;
  ld_fecpro := to_date(pd_fecpro,'yyyymmdd');
  

  for i in rubro loop
     begin 
       insert /*+parallel(CARTERAFM,2,1)*/into CARTERAFM (
              INSTANCIA, BCRUBR,BCSDMN,BCEMP,BCMOD,BCSUC,BCMDA,BCPAP,BCCTA,BCOPER,
              BCSBOP,BCTOP,BCFVAL,BCFVTO,PEPAIS,PETDOC,PENDOC,
              TDNOM,BCFECH,PENOM,BCSDMO)
       select/*+all_rows parallel(tdo,2,1)*/
             pq_datos_fin_mes.fn_pa_instancia (sal.bcmod,sal.bcsuc,sal.bcmda,
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
             sal.bcfech,
             nom.penom,
             sal.bcsdmo
        from fsh012 sal, fsr008 cta,
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
         
         ;    
     exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'EQFX',i.rubro||lc_coderr, TRUNC(SYSDATE));
           COMMIT;
     end;       
     commit;
  end loop; 
  commit;
  update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'EQFX';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'EQFX';
    commit;
    return;

end sp_equifax_datos;

Procedure sp_job_equifax_datos_II (pd_fecpro in varchar2 ) is
  ln_max number;
  ln_inc number;
  ln_ini number;
  ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_coderr varchar2(300);
  lc_hostname varchar2(64);
  cursor sucursal is 
  select sucurs from fst001 where pgcod =1 ;
  begin 
      begin
        select host_name
          into lc_hostname
          from v$instance;
      end;
     execute immediate ('truncate table reportes');
     execute immediate ('alter session set parallel_force_local=TRUE');--JFLOR 2014.01.15     
     delete Tab_jobs where  c_Codage = 'EQFX2';
     commit;
     for i in sucursal loop    
        ln_ini := i.sucurs;
        lc_variable := ' begin '|| '  pq_datos_fin_mes.sp_equifax_datos_II('||ln_ini||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
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
        VALUES('EQFX2',ln_ini,lc_variable);
        COMMIT;
      end loop; 
  exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'EQFX2',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

end sp_job_equifax_datos_II;
  
Procedure sp_equifax_datos_II (pn_numsuc in number, pd_fecpro in varchar2 ) is

ld_fecpro date;

lc_coderr varchar2(300); 
cursor rubro is
  select rubro
    from fsd014
   where (pcnivc in
         (select modulo
            from fst111
           where dscod = 50
             and modulo not in (29, 120, 144/*, 33, 200*/)) --33 castigado , 200 judicial
              or pcnivc in (141, 117))
     and pcimpu = 'S'
     and pmtit <> 9;
begin

  update tab_jobs g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'EQFX2';
  commit;
  ld_fecpro := to_date(pd_fecpro,'yyyymmdd');

    for i in rubro loop
     begin 
     
       insert into reportes (instancia,bcemp,bcmod,bcsuc,bcmda,bcpap,bccta,
                             bcoper,bcsbop,bctop,bcfval,bcfvto,pepais,
                             petdoc,pendoc,tdnom,scnom,estado_solic,causal,
                             fec_eqfx,anio_eqfx,Mes_Eqfx,des_mes,cod_ana,
                             des_ana,eqfx_accion,monto_solic,pzo_solic,penom,
                             nro_credito,categoria)
            select INSTANCIA,bcemp,BCMOD,BCSUC,BCMDA,BCPAP,
                   BCCTA,BCOPER,BCSBOP,BCTOP,BCFVAL,
                   BCFVTO,PEPAIS,PETDOC,PENDOC,TDNOM,
                   
                   (select k.scnom
                      from xwf700 b, fst001 k
                     where t.instancia = b.xwfprcins
                       and k.pgcod     = b.xwfempresa
                       and k.sucurs    = b.xwfsucursal
                       and rownum = 1) Agencia_Solicitud,
                   pq_datos_fin_mes.fn_est_sol(instancia),
                   pq_datos_fin_mes.fn_causal(instancia),
                   s.jaql11feenv,
                   to_char(s.jaql11feenv,'yyyy'),
                   to_char(s.jaql11feenv,'mm'),
                   pq_datos_fin_mes.fn_meses(to_char(s.jaql11feenv,'mm')),
                   pq_datos_fin_mes.fn_cod_analista(instancia,pepais,petdoc,pendoc),
                   pq_datos_fin_mes.fn_des_analista(instancia,pepais,petdoc,pendoc),
                   s.jaql11accio,
                   pq_datos_fin_mes.fn_monto_solic(instancia),
                   pq_datos_fin_mes.fn_pzo_solic(instancia),
                   penom,
                   (lpad(to_char(bccta), 9, '0') || lpad(to_char(bcmod), 3, '0') ||
                   lpad(to_char(bcmda), 3, '0') || lpad(to_char(bcoper), 9, '0') ||
                   lpad(to_char(bctop), 3, '0')) Nro_Credito,
                   ( select r.CATCATEG from fsd212 r where r.CATFCHDES = ld_fecpro
                       and r.CATCOD = 4
                       and r.CATCTA = t.bccta
                       )
                   
                      from carterafm t, jaql011 s /*,*/
                     where t.bcsuc = pn_numsuc
                       and t.bcrubr = i.rubro
                       and t.instancia = s.jaql11insta
                       and s.JAQL11ESTAD = 'S'
                       and s.jaql11coser = 50
                       and s.jaql11comod in (1,2)
                       
                       
                       
                       
                       
                    
                     ;
         commit;        
     exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'EQFX2',pn_numsuc||lc_coderr, TRUNC(SYSDATE));
           COMMIT;
     end;       
     commit;
  end loop;
  commit;
  update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'EQFX2';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'EQFX2';
    commit;
    return;

end sp_equifax_datos_II;  

function fn_est_sol (pn_instancia in number) return varchar2 is
lc_estado varchar2(50);
begin
  begin
    select aa.sng120tsk
      into lc_estado
      from sng120 aa
     where aa.sng120ins = pn_instancia
       and aa.sng120fval =
           (select max(bb.sng120fval)
              from sng120 bb
             where bb.sng120ins = aa.sng120ins);
  exception 
      when too_many_rows then
        begin
         select aa.sng120tsk
           into lc_estado
           from sng120 aa
          where aa.sng120ins = pn_instancia
            and aa.sng120fval =
                (select max(bb.sng120fval)
                   from sng120 bb
                  where bb.sng120ins = aa.sng120ins)
            and rownum = 1;
        exception
            when no_data_found then 
                 lc_estado := null;
        
        end; 
            
      when no_data_found then 
         lc_estado := null;
      
  end;   
    
   return lc_estado;
end fn_est_sol;


function fn_causal (pn_instancia in number) return varchar2 is


  cursor text (instancia in number) is
    select r.jaql11xmlre 
    from jaql011 r
    where r.jaql11insta = pn_instancia;
    
  salida varchar2(4000);
  --salida clob;
begin  
  begin
    for c in text (pn_instancia)loop
      salida := to_char(substr((substr(c.jaql11xmlre,
                                  instr(c.jaql11xmlre, 'explicacion') + 60,
                                  length(c.jaql11xmlre))),
                          1,
                          instr((substr(c.jaql11xmlre,
                                        instr(c.jaql11xmlre, 'explicacion') + 60,
                                        length(c.jaql11xmlre))),
                                '</Valor>') - 1));
      --        if ( v like '%Nombre_Completo%') then
      /*\*salida*\v := 'text is ' || v;
      dbms_output.put_line(\*salida*\v);
      --        end if;*/
    end loop;
    return salida;
  end;
end fn_causal;

function fn_meses (pn_mes in char) return varchar2 is
lc_mes varchar2(50);
begin
  begin
       if pn_mes = '01' then
          lc_mes := 'ENERO';
       End If;
       if pn_mes = '02' then
          lc_mes := 'FEBRERO';
       End If;
       if pn_mes = '03' then
          lc_mes := 'MARZO';
       End If;
       if pn_mes = '04' then
          lc_mes := 'ABRIL';
       End If;
       if pn_mes = '05' then
          lc_mes := 'MAYO';
       End If;
       if pn_mes = '06' then
          lc_mes := 'JUNIO';
       End If;
       if pn_mes = '07' then
          lc_mes := 'JULIO';
       End If;
       if pn_mes = '08' then
          lc_mes := 'AGOSTO';
       End If;
       if pn_mes = '09' then
          lc_mes := 'SETIEMBRE';
       End If;
       if pn_mes = '10' then
          lc_mes := 'OCTUBRE';
       End If;
       if pn_mes = '11' then
          lc_mes := 'NOVIEMBRE';
       End If;
       if pn_mes = '12' then
          lc_mes := 'DICIEMBRE';
       End If;
       
         
    
  exception 
      when others then
           lc_mes := null;
       
      
  end;   
    
   return lc_mes;
end fn_meses;


function fn_cod_analista (pn_instancia in number,pn_pais in number, 
                          pn_tdoc in number,pc_ndoc in char) return varchar2 is
lc_codana varchar2(20);
begin
  begin
    select aa.sng001ase
      into lc_codana
      from sng001 aa
     where aa.sng001inst = pn_instancia
       and aa.sng001pais = pn_pais
       and aa.sng001tdoc = pn_tdoc
       and aa.sng001ndoc = pc_ndoc
       ;
  exception 
      when too_many_rows then
           lc_codana := '2';
      when no_data_found then 
           lc_codana := null;
        
              
  end;   
    
   return lc_codana;
end fn_cod_analista;


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

function fn_pzo_solic (pn_instancia in number) return number is
ln_pzo number;
begin
  begin
    select aa.sng120pzo
      into ln_pzo
      from sng120 aa
     where aa.sng120ins = pn_instancia
       and aa.sng120tsk = 'SOLICITUD'
       ;
  exception 
      when too_many_rows then
           ln_pzo := null;
            
      when no_data_found then 
         ln_pzo := null;
      
  end;   
    
   return ln_pzo;
end fn_pzo_solic;


Procedure sp_job_cambiario_datos (pd_fecpro in varchar2 ) is
  ln_max number;
  ln_inc number;
  ln_ini number;
  ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_coderr varchar2(300);
  lc_hostname varchar2(64);
  cursor sucursal is 
  select sucurs from fst001 where pgcod =1 ;
  begin 
      begin
        select host_name
          into lc_hostname
          from v$instance;
      end;
--     execute immediate ('truncate table CARTERAFM');
     execute immediate ('truncate table CARTERAFM');
     execute immediate ('alter session set parallel_force_local=TRUE');--JFLOR 2014.01.15
     delete Tab_jobs where  c_Codage = 'CAMB';
     commit;
     for i in sucursal loop    
        ln_ini := i.sucurs;
        lc_variable := ' begin '|| '  pq_datos_fin_mes.sp_cambiario_datos('||ln_ini||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
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
        VALUES('CAMB',ln_ini,lc_variable);
        COMMIT;
      end loop; 
  exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'CAMB',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

end sp_job_cambiario_datos;
  
Procedure sp_cambiario_datos (pn_numsuc in number, pd_fecpro in varchar2 ) is

ld_fecpro date ;
lc_coderr varchar2(300); 
cursor rubro is
  select rubro
    from fsd014
   where (pcnivc in
         (select modulo
            from fst111
           where dscod = 50
             and modulo not in (29, 120, 144/*, 33, 200*/)) --33 castigado , 200 judicial
              or pcnivc in (141, 117))
     and pcimpu = 'S'
     and pmtit <> 9;

begin

  update tab_jobs g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'CAMB';
  commit;
  ld_fecpro := to_date(pd_fecpro,'yyyymmdd');


  for i in rubro loop
     begin 
       insert /*+parallel(CARTERAFM,2,1)*/into CARTERAFM (
              INSTANCIA,INSTANCIA_ORIGINAL, BCRUBR,BCSDMN,BCEMP,BCMOD,BCSUC,BCMDA,BCPAP,BCCTA,BCOPER,
              BCSBOP,BCTOP,BCFVAL,BCFVTO,PEPAIS,PETDOC,PENDOC,TDNOM,AOIMP,BCFECH,
              PENOM,BCSDMO,AOPERIOD,
              AOSTAT,Bcgpo)
       select/*+all_rows parallel(cta,2,1)*/
             pq_datos_fin_mes.fn_pa_instancia (sal.bcmod,sal.bcsuc,sal.bcmda,
             sal.bcpap,sal.bccta,sal.bcoper,sal.bcsbop,sal.bctop),
             pq_datos_fin_mes.fn_pa_instancia (sal.bcmod,sal.bcsuc,sal.bcmda,
             sal.bcpap,sal.bccta,sal.bcoper,0,sal.bctop),
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
             sal.bcgpo
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
         and sal.bcmda  = 101
         ;    
     exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'CAMB',i.rubro||lc_coderr, TRUNC(SYSDATE));
           COMMIT;
     end;       
     commit;
  end loop; 
  commit;
  update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'CAMB';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'CAMB';
    commit;
    return;

end sp_cambiario_datos;  

Procedure sp_job_cambiario_datos_II (pd_fecpro in varchar2 ) is
  ln_max number;
  ln_inc number;
  ln_ini number;
  ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_coderr varchar2(300);
  lc_hostname varchar2(64);
  cursor sucursal is 
  select sucurs from fst001 where pgcod =1 ;
  begin 
      begin
        select host_name
          into lc_hostname
          from v$instance;
      end;
--     execute immediate ('truncate table reportes');
     execute immediate ('truncate table reportes');
     execute immediate ('alter session set parallel_force_local=TRUE');--JFLOR 2014.01.15
     delete Tab_jobs where  c_Codage = 'CAMBD';
     commit;
     for i in sucursal loop    
        ln_ini := i.sucurs;
        lc_variable := ' begin '|| '  pq_datos_fin_mes.sp_cambiario_datos_II('||ln_ini||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
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
        VALUES('CAMBD',ln_ini,lc_variable);
        COMMIT;
      end loop; 
  exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'CAMBD',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

end sp_job_cambiario_datos_II;
  
Procedure sp_cambiario_datos_II (pn_numsuc in number, pd_fecpro in varchar2 ) is

ld_fecpro date;

lc_coderr varchar2(300); 
cursor rubro is
  select rubro
    from fsd014
   where (pcnivc in
         (select modulo
            from fst111
           where dscod = 50
             and modulo not in (29, 120, 144/*, 33, 200*/)) --33 castigado , 200 judicial
              or pcnivc in (141, 117))
     and pcimpu = 'S'
     and pmtit <> 9;
begin

  update tab_jobs g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'CAMBD';
  commit;
  ld_fecpro := to_date(pd_fecpro,'yyyymmdd');
  
    for i in rubro loop
     begin 
     
       insert into reportes (instancia,INSTANCIA_ORIGINAL,bcemp,bcmod,bcsuc,bcmda,bcpap,bccta,
                             bcoper,bcsbop,bctop,bcfval,bcfvto,pepais,
                             petdoc,pendoc,
                             tdnom,aoimp,scnom,aopzo,aostat,valor_cuota,des_ana,estado,
                             tipo_credito_sbs,lista_negra,cuota_pendie,evaluacion,evaluacion_sol,
                             evaluacion_dola,eval_socio_sol,eval_socio_dol,nro_credito,
                             producto,lineas,tipo_desembolso,bcgpo,penom,bcsdmo,Valor_Cuota_Mes,
                             bcrubr,categoria)
            select INSTANCIA,INSTANCIA_ORIGINAL,bcemp, BCMOD,BCSUC,BCMDA,BCPAP,
                   BCCTA,BCOPER,BCSBOP,BCTOP,BCFVAL,
                   BCFVTO,PEPAIS,PETDOC,PENDOC,TDNOM,AOIMP,scnom,t.aoperiod,t.aostat,
                   
                   pq_datos_fin_mes.fn_valor_cuotas(bcemp,bcmod,bcsuc,bcmda,bcpap, bccta,bcoper,
                                                              bcsbop,bctop),
                   pq_datos_fin_mes.fn_des_analista(instancia,pepais,petdoc,pendoc),
                   (Case
                                When Substr(bcrubr,1,2) = '14' and 
                                     Substr(bcrubr,4,1) = '1' then 'NORMAL'
                                When Substr(bcrubr,1,2) = '14' and 
                                     Substr(bcrubr,4,1) = '3' then 'REPROGRAMADO'
                                When Substr(bcrubr,1,2) = '14' and 
                                     Substr(bcrubr,4,1) = '4' then 'REFINANCIADO'
                                When Substr(bcrubr,1,2) = '14' and 
                                     Substr(bcrubr,4,1) = '5' then 'VENCIDO'
                                When Substr(bcrubr,1,2) = '14' and 
                                     Substr(bcrubr,4,1) = '6' then 'JUDICIAL'
                                Else                                'NORMAL'
                   End)Estado_Contable,                                                                 
                   Case When Substr(bcrubr, 1, 2) = '14' and
                             Substr(bcrubr, 5, 2) = '02' then 'MICRO'
                        When Substr(bcrubr, 1, 2) = '14' and
                             Substr(bcrubr, 5, 2) = '03' then 'CONSUMO'
                        When Substr(bcrubr, 1, 2) = '14' and
                             Substr(bcrubr, 5, 2) = '04' then 'HIPOTECARIO'
                        When Substr(bcrubr, 1, 2) = '14' and
                             Substr(bcrubr, 5, 2) = '12' then 'MEDIANA'
                        When Substr(bcrubr, 1, 2) = '14' and
                             Substr(bcrubr, 5, 2) = '13' then 'PEQUEÑA'
                        When Substr(bcrubr,1,2) in ('71','72') and 
                             Substr(bcrubr,7,2) = '02' then 'MICRO'
                        When Substr(bcrubr,1,2) in ('71','72') and 
                             Substr(bcrubr,7,2) = '03' then 'CONSUMO'
                        When Substr(bcrubr,1,2) in ('71','72') and 
                             Substr(bcrubr,7,2) = '04' then 'HIPOTECARIO'
                        When Substr(bcrubr,1,2) in ('71','72') and 
                             Substr(bcrubr,7,2) = '12' then 'MEDIANA'
                        When Substr(bcrubr,1,2) in ('71','72') and 
                             Substr(bcrubr,7,2) = '13' then 'PEQUEÑA'     
                        Else ''
                   End Tipo_Producto,
                   pq_datos_fin_mes.fn_listas_negras(pepais,petdoc,pendoc),
                   pq_datos_fin_mes.fn_cuotas_pendientes(bcemp,bcmod,bcsuc,bcmda,bcpap,
                                                         bccta,bcoper,bcsbop,bctop,ld_fecpro),
                   nvl(pq_datos_fin_mes.fn_tiene_evaluacion(instancia),
                       pq_datos_fin_mes.fn_tiene_evaluacion(instancia_original)),
                   
                   nvl(pq_datos_fin_mes.fn_evaluacion(instancia,40,13),
                       pq_datos_fin_mes.fn_evaluacion(instancia_original,40,13)),
                   nvl(pq_datos_fin_mes.fn_evaluacion(instancia,540,13), 
                       pq_datos_fin_mes.fn_evaluacion(instancia_original,540,13)),
                   nvl(pq_datos_fin_mes.fn_evaluacion(instancia,27,14),
                       pq_datos_fin_mes.fn_evaluacion(instancia_original,27,14)),
                   nvl(pq_datos_fin_mes.fn_evaluacion(instancia,527,14),
                       pq_datos_fin_mes.fn_evaluacion(instancia_original,527,14)),             
                   
                 
                   (lpad(to_char(bccta), 9, '0') || lpad(to_char(bcmod), 3, '0') ||
                   lpad(to_char(bcmda), 3, '0') || lpad(to_char(bcoper), 9, '0') ||
                   lpad(to_char(bctop), 3, '0')) Nro_Credito,
                   --a.scnom,
                   
                   (select k.tonom
                      from fst004 k
                     where k.modulo = BCMOD
                       and k.totope = bctop) producto,
                   (select j.mdnom from fst003 j where j.modulo = BCMOD) Lineas,
                   
                   (case
                     when bcmod = 116 then 'Linea'
                     else 'No Linea'
                   end) Tipo_desembolso,
                   t.bcgpo,
                   penom,
                   bcsdmo,
                   nvl(pq_datos_fin_mes.fn_valor_cuota_al_mes(bcemp,bcmod,bcsuc,bcmda,bcpap,bccta,
                                                          bcoper,bcsbop,bctop,ld_fecpro),
                       pq_datos_fin_mes.fn_valor_cuotas(bcemp,bcmod,bcsuc,bcmda,bcpap, bccta,bcoper,
                                                              bcsbop,bctop)),
                   t.bcrubr ,
                   ( select r.CATCATEG from fsd212 r where r.CATFCHDES = ld_fecpro
                       and r.CATCOD = 4
                       and r.CATCTA = t.bccta
                       )                                                             
                   
                    
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
           VALUES(0,'CAMBD',pn_numsuc||lc_coderr, TRUNC(SYSDATE));
           COMMIT;
     end;       
     commit;
  end loop;
  commit;
  update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'CAMBD';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'CAMBD';
    commit;
    return;

end sp_cambiario_datos_II;  

function fn_listas_negras (pn_pais in number, 
                          pn_tdoc in number,pc_ndoc in char) return varchar2 is
lc_lndes varchar2(200);
begin

  begin
            select y.tlisde
              into lc_lndes 
              from fsd201 x, LN_Priori  y 
             where x.lnpais = pn_pais
               and x.lntdoc = pn_tdoc
               and x.lnndoc = pc_ndoc
               and x.tlis   = y.tlis
               ;
         exception 
           when no_data_found then
              lc_lndes:= null;
           when others then 
            begin 
                select tlisde
                  into lc_lndes 
                  from LN_Priori where prioridad = (
                 select min(y.prioridad)
                  from fsd201 x, LN_Priori  y 
                 where x.lnpais = pn_pais
                   and x.lntdoc = pn_tdoc
                   and x.lnndoc = pc_ndoc
                   and x.tlis   = y.tlis
                   );    
            exception
              when others then 
                  lc_lndes:= null;
            end;          
  
  end;
  
   
    
   return lc_lndes;
end fn_listas_negras;

function fn_cuotas_pendientes (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                             pn_pap in number, pn_cta in number, pn_oper in number,
                             pn_sbop in number,pn_top in number, pd_fecpro in date ) return number is
ln_cuotas number;
begin
  begin
    select /*+parallel(n,2,1)*/  
           count(n.ppfpag) 
      into ln_cuotas   
      from fsd601 n 
     where n.pgcod  = pn_emp     
       and n.ppcta  = pn_cta     
       and n.ppmda  = pn_mda    
       and n.ppsuc  = pn_suc    
       and n.pppap  = pn_pap    
       and n.ppoper = pn_oper  
       and n.ppsbop = pn_sbop  
       and n.pptope = pn_top  
       and n.ppmod  = pn_mod    
       and n.d601co = 'S'
       and not exists 
                (select /*+parallel(o,2,1)*/  ppmod, ppcta,ppoper, pptope,ppfpag 
                   from fsd602 o
                  where o.pgcod   = n.pgcod
                    and o.ppmod   = n.ppmod
                    and o.ppsuc   = n.ppsuc
                    and o.ppmda   = n.ppmda
                    and o.pppap   = n.pppap
                    and o.ppcta   = n.ppcta
                    and o.ppoper  = n.ppoper
                    and o.ppsbop  = n.ppsbop
                    and o.pptope  = n.pptope
                    and o.ppfpag  = n.ppfpag
                    --and o.ppfpag  <= pd_fecpro
                    and o.pp1fech  <= pd_fecpro
                    and o.pp1stat = 'T' 
                    and o.d602co  = 'S');
  exception 
      when no_data_found then 
         ln_cuotas := null;
      when too_many_rows then
         ln_cuotas := null;
  end;   
   return ln_cuotas;
end fn_cuotas_pendientes;

function fn_riesgo_cambiario (pn_resul_sol in number,pn_resul_dol in number,
                              pn_moneda in number, pn_monto in number,
                              pn_resul_socio_sol in number,pn_resul_socio_dol in number) 
                              return char is
lc_riesgo char(3);
begin
  begin
       case 
          when pn_resul_sol is not null and pn_moneda = 101 then
               lc_riesgo := 'S';
          when pn_resul_sol is not null and pn_resul_dol is not null and pn_moneda = 101 then
               if pn_resul_dol < pn_monto then
                  lc_riesgo := 'S';
                  else 
                            lc_riesgo := 'N';
               End If;   
          
          when pn_resul_socio_sol is not null and pn_moneda = 101 then
               lc_riesgo := 'S';
          when pn_resul_socio_sol is not null and pn_resul_socio_dol is not null and pn_moneda = 101 then
               if pn_resul_socio_dol < pn_monto then
                  lc_riesgo := 'S';
                  else 
                            lc_riesgo := 'N';
               End If;   
          else lc_riesgo := 'N';
       end case;
      
           
  exception 
      when others then
           lc_riesgo := 'N';
       
      
  end;   
    
   return lc_riesgo;
end fn_riesgo_cambiario;

Procedure sp_job_opinion_datos (pd_fecpro in varchar2) is
  ln_max number;
  ln_inc number;
  ln_ini number;
  ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_coderr varchar2(300);
  lc_hostname varchar2(64);
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
        lc_variable := ' begin '|| '  pq_datos_fin_mes.sp_opinion_datos('||ln_ini||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
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
        VALUES('OPI',ln_ini,lc_variable);
        COMMIT;
      end loop; 
  exception
     when others then
           lc_coderr:=sqlerrm;
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
       insert /*+parallel(CARTERAFM,2,1)*/into CARTERAFM (
              INSTANCIA, BCRUBR,BCSDMN,BCEMP,BCMOD,BCSUC,BCMDA,BCPAP,BCCTA,BCOPER,
              BCSBOP,BCTOP,BCFVAL,BCFVTO,PEPAIS,PETDOC,PENDOC,TDNOM,AOIMP,BCFECH,
              PENOM,BCSDMO,AOPERIOD,
              AOSTAT,Bcgpo,BCSDUS,AOMDA)
       select/*+all_rows parallel(pre,2,1) parallel(tdo,2,1) */
             pq_datos_fin_mes.fn_pa_instancia (sal.bcmod,sal.bcsuc,sal.bcmda,
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
  ln_max number;
  ln_inc number;
  ln_ini number;
  ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_coderr varchar2(300);
  lc_hostname varchar2(64);
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
        lc_variable := ' begin '|| '  pq_datos_fin_mes.sp_opinion_datos_II('||ln_ini||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
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
           lc_coderr:=sqlerrm;
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
                             monto_solic,origen,monto_aprobado,bcsdmn,bcsdus,bcrubr,mda_mto_aprob)
            select INSTANCIA,bcemp, BCMOD,BCSUC,BCMDA,BCPAP,
                   BCCTA,BCOPER,BCSBOP,BCTOP,BCFVAL,
                   BCFVTO,PEPAIS,PETDOC,PENDOC,TDNOM,AOIMP,scnom,
                   
                   
                   pq_datos_fin_mes.fn_des_analista(instancia,pepais,petdoc,pendoc),
                   
                                    
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
                   pq_datos_fin_mes.fn_cod_interno_pqn(bcmod,bcsuc,bcmda,bcpap,bccta,
                                                       bcoper,bcsbop,bctop,ld_fecpro),
                   pq_datos_fin_mes.fn_monto_solic(instancia),
                   (select m.sng001ori 
                     from sng001 m where m.sng001inst = instancia )  ,
                   pq_datos_fin_mes.fn_mto_aprobado (bcemp,bcmod,bcsuc,bcmda,bcpap,
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
                   pq_datos_fin_mes.fn_mda_mto_aprobado (bcemp,bcmod,bcsuc,bcmda,bcpap,
                                                     bccta,bcoper,bcsbop,bctop,aoimp,aomda)                 
                    
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


Procedure sp_job_opinion_datos_III (pd_fecpro in varchar2 ) is
  ln_max number;
  ln_inc number;
  ln_ini number;
  ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_coderr varchar2(300);
  lc_hostname varchar2(64);
  cursor sucursal is 
  select sucurs from fst001 where pgcod =1 ;
  begin 
      begin
        select host_name
          into lc_hostname
          from v$instance;
      end;
     execute immediate ('truncate table opinion_cons');
     delete Tab_jobs where  c_Codage = 'OPIT';
     commit;
     for i in sucursal loop    
        ln_ini := i.sucurs;
        lc_variable := ' begin '|| '  pq_datos_fin_mes.sp_opinion_datos_III('||ln_ini||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
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
        VALUES('OPIT',ln_ini,lc_variable);
        COMMIT;
      end loop; 
  exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'OPIT',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

end sp_job_opinion_datos_III;
  
Procedure sp_opinion_datos_III (pn_numsuc in number, pd_fecpro in varchar2 ) is

ld_fecpro date;
/*ln_valor_comp number;*/
ln_tipcamC number;
ln_tipcamV number;
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
     and g.c_codage = 'OPIT';
  commit;
  
  ld_fecpro := to_date(pd_fecpro,'yyyymmdd');
  begin
    select cotcbi, cotcbv
      into ln_tipcamC, ln_tipcamV
      from fsh005 
     where moneda = 101 
       and cofdes = ld_fecpro;

    exception
       when others then
          ln_tipcamC := null;
          ln_tipcamV := null;
   end;
  
  --ln_valor_comp := pq_datos_fin_mes.fn_saldo_a_tomar(ln_tipcamC);
    for i in rubro loop
     begin 
     
       insert into opinion_cons (pepais,tdnom,petdoc,pendoc,penom,monto_soles,monto_dol)
            select t.pepais,
                   t.tdnom,
                   t.petdoc,
                   t.pendoc,
                   t.penom,
                   
                   sum(t.bcsdmn),
                   sum(t.bcsdus)
                   
                           
                    
                      from reportes t
                     where t.bcsuc          = pn_numsuc
                       and t.bcrubr         = i.rubro
                       --and t.monto_aprobado > 10000
                       and t.origen         not in (3,4,13,14)
                       --and t.bcmod          <> 115
                       and t.n_tippeq       = 1
                       and t.bcgpo          in (2,3,12,13)
                       and t.bcfval         between to_date('20130731','yyyymmdd') and 
                       to_date('20130930','yyyymmdd')
                       
                    group by t.pepais,
                   t.tdnom,
                   t.petdoc,
                   t.pendoc,
                   t.penom
                    ;
         commit;        
     exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'OPIT',pn_numsuc||lc_coderr, TRUNC(SYSDATE));
           COMMIT;
     end;       
     commit;
  end loop;
  commit;
  update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'OPIT';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'OPIT';
    commit;
    return;

end sp_opinion_datos_III; 

function fn_saldo_a_tomar (pn_tipo_cambio in number) 
                              return number is

ln_result number;

begin
    
  begin
  
  
       if 40000 * pn_tipo_cambio < 120000 then
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
                              pn_sbop in number,pn_top in number, pn_aoimp in number,pn_aomda in number ) return number is
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


function fn_ordinal (pn_emp in number, pn_mod in number, pn_suc in number, pn_trn in number,
                     pn_nrel in number, pd_fec in date) return number is
ln_ordinal number;
ln_mod number;
ln_sucor number;
ln_tran number;
ln_nrel number;
ld_hfcon date;
begin
  begin
    select y.HCMOD,
           y.HSUCOR,
           y.HTRAN,
           y.HNREL,
           y.HFCON,
           min(y.HCORD)
        into  ln_mod,ln_sucor,ln_tran,ln_nrel,ld_hfcon,ln_ordinal
        from fsh016 y 
      where y.PGCOD  = pn_emp
        and y.HCMOD  = pn_mod
        and y.HSUCOR =  pn_suc
        and y.HTRAN  = pn_trn 
        and y.HNREL  = pn_nrel
        and y.HFCON  = pd_fec
      group by y.HCMOD,
               y.HSUCOR,
               y.HTRAN,
               y.HNREL,
               y.HFCON;
  exception 
      when no_data_found then 
          ln_ordinal := null;
          
      when too_many_rows then
         ln_ordinal := null;
  end;   
   return ln_ordinal;
end fn_ordinal;


Procedure sp_job_movigas_datos (pd_fecpro in varchar2 ) is
  ln_max number;
  ln_inc number;
  ln_ini number;
  ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_coderr varchar2(300);
  lc_hostname varchar2(64);
  cursor sucursal is 
  select sucurs from fst001 where pgcod =1 ;
  begin 
      begin
        select host_name
          into lc_hostname
          from v$instance;
      end;

     execute immediate ('truncate table CARTERAFM');
     delete Tab_jobs where  c_Codage = 'MOVI';
     commit;
     for i in sucursal loop    
        ln_ini := i.sucurs;
        lc_variable := ' begin '|| '  pq_datos_fin_mes.sp_movigas_datos('||ln_ini||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
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
        VALUES('MOVI',ln_ini,lc_variable);
        COMMIT;
      end loop; 
  exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'MOVI',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;
end sp_job_movigas_datos;
  
Procedure sp_movigas_datos (pn_numsuc in number, pd_fecpro in varchar2 ) is

ld_fecpro date ;
lc_coderr varchar2(300); 
cursor rubro is
  select rubro
    from fsd014
   where pcnivc in (113,200)
     and pcimpu = 'S'
     and pmtit  <> 9;

begin

  update tab_jobs g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'MOVI';
  commit;
  ld_fecpro := to_date(pd_fecpro,'yyyymmdd');
  

  for i in rubro loop
     begin 
       insert /*+parallel(CARTERAFM,2,1)*/into CARTERAFM (
              INSTANCIA, BCRUBR,BCSDMN,BCEMP,BCMOD,BCSUC,BCMDA,BCPAP,BCCTA,BCOPER,
              BCSBOP,BCTOP,DIAS_MORA,BCFVAL,BCFVTO,PEPAIS,PETDOC,PENDOC,
              TDNOM,AOIMP,BCFECH,PENOM,BCSDMO,AOPERIOD,
              C_TIPCALEN,AOSTAT,Pzo_H12,Pzo_D10,TASA)
       select/*+all_rows parallel(pre,2,1) parallel(tdo,2,1)*/
             pq_datos_fin_mes.fn_pa_instancia (sal.bcmod,sal.bcsuc,sal.bcmda,
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
             fn_dias_atraso_mod_2(ld_fecpro,sal.bcemp,sal.bcmod,sal.bcsuc,sal.bcmda,
             sal.bcpap,sal.bccta,sal.bcoper,sal.bcsbop,sal.bctop,0),
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
             
             
              (select case when xllotexto = 1 then 'Fecha Fija'
                           when xllotexto = 2 then 'Plazo Fijo'
                      else 'Otros' end     
                  from x054021 s 
                 where  xllotxtcod   = 5
                    and s.pgcod      = pre.Pgcod
                    and s.xlloaomod  = pre.aomod
                    and s.xlloaosuc  = pre.aosuc
                    and s.xlloaomda  = pre.aomda
                    and s.xlloaopap  = pre.aopap 
                    and s.xlloaocta  = pre.aocta
                    and s.xlloaooper = pre.aooper 
                    and s.xlloaosbop = pre.aosbop
                    and s.xlloaotope = pre.aotope ) Tip_Calendario,
              pre.aostat,
              sal.BCPZO,
              pre.AOPZO,
              sal.BCTASA
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
           VALUES(0,'MOVI',i.rubro||lc_coderr, TRUNC(SYSDATE));
           COMMIT;
     end;       
     commit;
  end loop; 
  commit;
  update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'MOVI';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'MOVI';
    commit;
    return;

end sp_movigas_datos;  

Procedure sp_job_movigas_datos_II (pd_fecpro in varchar2 ) is
  ln_max number;
  ln_inc number;
  ln_ini number;
  ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_coderr varchar2(300);
  lc_hostname varchar2(64);
  cursor sucursal is 
  select sucurs from fst001 where pgcod =1 ;
  begin 
      begin
        select host_name
          into lc_hostname
          from v$instance;
      end;
     execute immediate ('truncate table reportes');
     delete Tab_jobs where  c_Codage = 'MOVID';
     commit;
     for i in sucursal loop    
        ln_ini := i.sucurs;
        lc_variable := ' begin '|| '  pq_datos_fin_mes.sp_movigas_datos_II('||ln_ini||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
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
        VALUES('MOVID',ln_ini,lc_variable);
        COMMIT;
      end loop; 
  exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'MOVID',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;
end sp_job_movigas_datos_II ;
  
Procedure sp_movigas_datos_II (pn_numsuc in number, pd_fecpro in varchar2 ) is

ld_fecpro date;

lc_coderr varchar2(300); 
cursor rubro is
  select rubro
    from fsd014
   where pcnivc in (113,200)
     and pcimpu = 'S'
     and pmtit  <> 9;
begin

  update tab_jobs g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'MOVID';
  commit;
  ld_fecpro := to_date(pd_fecpro,'yyyymmdd');
  
    for i in rubro loop
     begin 
     
       insert into reportes (instancia,bcemp,bcmod,bcsuc,bcmda,bcpap,bccta,
                             bcoper,bcsbop,bctop,dias_mora,bcfval,bcfvto,pepais,
                             petdoc,pendoc,
                             tdnom,aoimp,scnom,tipo_credito_sbs,
                             nro_credito,des_ana,direccion,actividad,producto,ubigeo,
                             nro_cuotas,cuotas_pagadas,pzo_h12,pzo_d10,plazo,dias_gracia,tasa,
                             categoria,es_judicial,monto_aprobado,bcsdmn,bcsdmo,Tip_Calen,penom,
                             concesionario)
            select t.INSTANCIA,t.bcemp, t.BCMOD,t.BCSUC,t.BCMDA,t.BCPAP,
                   t.BCCTA,t.BCOPER,t.BCSBOP,t.BCTOP,t.DIAS_MORA,t.BCFVAL,
                   t.BCFVTO,t.PEPAIS,t.PETDOC,t.PENDOC,t.TDNOM,t.AOIMP,scnom,
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
                   End Tipo_Credito,
                   
                   (lpad(to_char(bccta), 9, '0') || lpad(to_char(bcmod), 3, '0') ||
                   lpad(to_char(bcmda), 3, '0') || lpad(to_char(bcoper), 9, '0') ||
                   lpad(to_char(bctop), 3, '0')) Nro_Credito,
                   --a.scnom,
                   pq_datos_fin_mes.fn_des_analista(instancia,t.pepais,t.petdoc,t.pendoc),
                   pq_datos_fin_mes.fn_direccion_T(t.pepais,t.petdoc,t.pendoc),
                   pq_datos_fin_mes.fn_actividad(t.pepais,t.petdoc,t.pendoc),
                   (select k.tonom
                      from fst004 k
                     where k.modulo = BCMOD
                       and k.totope = bctop) tipo_condicion,
                   pq_datos_fin_mes.fn_ubigeo_T(t.pepais,t.petdoc,t.pendoc),
                   pq_datos_fin_mes.fn_nro_cuotas(bcemp,bcmod,bcsuc,bcmda,bcpap,bccta,bcoper,
                                                  bcsbop,bctop),
                   pq_datos_fin_mes.fn_cuotas_pagadas(bcemp,bcmod,bcsuc,bcmda,bcpap,
                                                      bccta,bcoper,bcsbop,bctop,ld_fecpro),
                   t.pzo_h12,
                   t.pzo_d10,
                   pq_datos_fin_mes.fn_plazo(instancia),
                   pq_datos_fin_mes.fn_dias_gracia(bcemp,bcmod,bcsuc,bcmda,bcpap,
                                                      bccta,bcoper,bcsbop,bctop),
                   t.tasa,
                   ( select r.CATCATEG from fsd212 r where r.CATFCHDES = ld_fecpro
                       and r.CATCOD = 4
                       and r.CATCTA = t.bccta
                       ),
                    pq_datos_fin_mes.fn_judicial(bcemp,bcmod,bcsuc,bcmda,bcpap,
                                                      bccta,bcoper,bcsbop,bctop),
                    pq_datos_fin_mes.fn_mto_aprobado(bcemp,bcmod,bcsuc,bcmda,bcpap,
                                                      bccta,bcoper,bcsbop,bctop,t.aoimp),
                    t.bcsdmn,
                    t.bcsdmo,
                    t.c_tipcalen,
                    t.penom,
                    pq_datos_fin_mes.fn_concesionario(bcemp,bcmod,bcsuc,bcmda,bcpap,
                                                      bccta,bcoper,bcsbop,bctop)
                                                                          /*,
                   (select from sng320)*/
                   
              
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
           VALUES(0,'MOVID',pn_numsuc||lc_coderr, TRUNC(SYSDATE));
           COMMIT;
     end;       
     commit;
  end loop;
  commit;
  update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'MOVID';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'MOVID';
    commit;
    return;

end sp_movigas_datos_II;  

function fn_judicial (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                      pn_pap in number, pn_cta in number, pn_oper in number,
                      pn_sbop in number,pn_top in number) return char is
lc_judicial char(3);
begin
  begin
    if pn_mod = 200 then 
       begin
          select 'S'
              into lc_judicial
              from fsr011 m 
             where m.R2MOD   = pn_mod  
               and m.R2CTA   = pn_cta  
               and m.R2OPER  = pn_oper 
               and m.R2SBOP  = pn_sbop 
               and m.R2COD   = pn_emp 
               and m.R2SUC   = pn_suc   
               and m.R2MDA   = pn_mda 
               and m.R2PAP   = pn_pap 
               and m.R2TOPE  = pn_top
               and m.RELCOD  = 34
               and m.R1MOD   = 113 ;
           
        exception 
            when no_data_found then 
               lc_judicial := null;
        
           end;
        else
          lc_judicial := null;
        
     end if;  
   end; 
   return lc_judicial;
end fn_judicial;


function fn_ubigeo_T (pn_pais in number, pn_tdoc in number,pc_ndoc in char ) return number is
ln_ubigeo number;
begin
  begin
  select aa.SNGC13UGEO
    into ln_ubigeo
    from sngc13 aa
   where aa.sngc13pais = pn_pais
     and aa.sngc13tdoc = pn_tdoc
     and aa.sngc13ndoc = pc_ndoc
     and aa.docod = 1;
  exception 
      when no_data_found then 
         ln_ubigeo := null;
      when too_many_rows then
         ln_ubigeo := null;
     end;   
    
   return ln_ubigeo;
end fn_ubigeo_T;

function fn_cuotas_pagadas (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                             pn_pap in number, pn_cta in number, pn_oper in number,
                             pn_sbop in number,pn_top in number, pd_fecpro in date ) return number is
ln_numcuotas number;
begin
  begin
    select /*+parallel(o,2,1)*/  
            sum(count(*))
       into ln_numcuotas     
       from fsd602 o
      where o.pgcod   = pn_emp
        and o.ppmod   = pn_mod
        and o.ppsuc   = pn_suc 
        and o.ppmda   = pn_mda 
        and o.pppap   = pn_pap 
        and o.ppcta   = pn_cta 
        and o.ppoper  = pn_oper 
        and o.ppsbop  = pn_sbop 
        and o.pptope  = pn_top 
        and o.pp1fech  <= pd_fecpro
        and o.pp1stat = 'T' 
        and o.d602co  = 'S'
      group by o.PGCOD,
           o.PPMOD,
           o.PPSUC,
           o.PPMDA,
           o.PPPAP,
           o.PPCTA,
           o.PPOPER,
           o.PPSBOP,
           o.PPTOPE,
           o.PPFPAG;
  exception 
      when no_data_found then 
         ln_numcuotas := null;
      when too_many_rows then
         ln_numcuotas := -1;
      when others then
         ln_numcuotas := -0;
  end;   
   return ln_numcuotas;
end fn_cuotas_pagadas;


function fn_plazo (pn_instancia in number) return number is
ln_plazo number;
begin
  begin
    select /*+parallel(o,2,1)*/  
            o.XWFPLAZO1	
       into ln_plazo     
       from xwf700 o
      where o.xwfprcins  = pn_instancia
        and o.XWFCAR3	 = '1'

        ;
  exception 
      when no_data_found then 
         ln_plazo := null;
      when too_many_rows then
         ln_plazo := 2;
  end;   
   return ln_plazo;
end fn_plazo;

function fn_promedio (ld_fecfin in varchar2) return number is
ln_promedio number;
ld_fech     date;
begin
  begin
     ld_fech     := to_date(ld_fecfin,'yyyymmdd');
     ln_promedio := to_number(to_char(ld_fech,'dd'));
    
  end;   
   return ln_promedio;
end fn_promedio;

function fn_marca_vehiculo (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                             pn_pap in number, pn_cta in number, pn_oper in number,
                             pn_sbop in number,pn_top in number) return varchar2 is
lc_marca varchar2(50);
begin
  begin
   select b.PPG001DATO 
      into lc_marca
      from fsr011 a, ppg001 b
    where a.R1COD      = pn_emp
      and a.R1MOD      = pn_mod
      and a.R1SUC      = pn_suc
      and a.R1MDA      = pn_mda
      and a.R1PAP      = pn_pap
      and a.R1CTA      = pn_cta
      and a.R1OPER     = pn_oper
      and a.R1SBOP     = pn_sbop
      and a.R1TOPE     = pn_top
      and a.RELCOD     = 50
      and b.PPG001COD  = a.R2COD
      and b.PPG001MOD  = a.R2MOD
      and b.PPG001SUC  = a.R2SUC
      and b.PPG001MDA  = a.R2MDA
      and b.PPG001PAP  = a.R2PAP
      and b.PPG001CTA  = a.R2CTA
      and b.PPG001OPE  = a.R2OPER
      and b.PPG001SBO  = a.R2SBOP
      and b.PPG001TOP  = a.R2TOPE
      and b.ppg001top  = 40
      and b.ppg001cdat = 122
      and rownum       = 1;
  exception 
      when no_data_found then 
         lc_marca := null;
      when too_many_rows then
         lc_marca := '-1';
      when others then
         lc_marca := '-0';
  end;   
   return lc_marca;
end fn_marca_vehiculo;

function fn_concesionario (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                             pn_pap in number, pn_cta in number, pn_oper in number,
                             pn_sbop in number,pn_top in number) return varchar2 is
lc_concesionario varchar2(50);
begin
  begin
   select b.ppg020dit 
       into lc_concesionario
     from ppg008 a , ppg020 b,fsr011 c 
    where ppg008top   = 40 
      and ppg008cdat  = 56
      and b.ppg020ctb = a.ppg008cpu
      and b.ppg020cit = a.ppg008cip
      and c.R1COD     = pn_emp
      and c.R1MOD     = pn_mod
      and c.R1SUC     = pn_suc
      and c.R1MDA     = pn_mda
      and c.R1PAP     = pn_pap
      and c.R1CTA     = pn_cta
      and c.R1OPER    = pn_oper
      and c.R1SBOP    = pn_sbop
      and c.R1TOPE    = pn_top
      and c.RELCOD    = 50
      and c.R2MOD     = a.PPG008MOD
      and c.R2CTA     = a.PPG008CTA
      and c.R2OPER    = a.PPG008OPE
      and c.R2SBOP    = a.PPG008SBO 
      and c.R2COD     = a.PPG008PGC
      and c.R2SUC     = a.PPG008SUC
      and c.R2MDA     = a.PPG008MDA
      and c.R2PAP     = a.PPG008PAP
      and c.R2TOPE    = a.PPG008TOP;
  exception 
      when no_data_found then 
         lc_concesionario := null;
      when too_many_rows then
         lc_concesionario := '-1';
      when others then
         lc_concesionario := '-0';
  end;   
   return lc_concesionario;
end fn_concesionario;


function fn_tiene_evaluacion (instancia in number) return char is
lc_eval char(3);

begin
  begin
     select 'S'
        into lc_eval
        from sng021 e
       where e.sng021sol = instancia
         and rownum = 1;
    exception 
      when no_data_found then
          lc_eval := null;
      when others then
          lc_eval := 'x';
  end;   
   return lc_eval;
end fn_tiene_evaluacion;


function fn_valor_cuota_al_mes (pn_emp in number, pn_mod in number, pn_suc in number, pn_mda in number,
                                pn_pap in number, pn_cta in number, pn_oper in number,
                                pn_sbop in number,pn_top in number, pd_fecpro in date ) return number is
--saca la cuota del mes de proceso

ln_cuota number;
ld_fec_sig date;
ld_fec_sig2 date;
ld_fec_sig3 date;
begin
  begin
    /*ld_fec_sig  := pd_fecpro + 30;
    ld_fec_sig2 := pd_fecpro + 60;
    ld_fec_sig3 := pd_fecpro + 90;*/
  
    select /*+parallel(n,2,1)*/  
           sum(n.PPCAP) + sum(n.PPINT)
      into ln_cuota   
      from fsd601 n 
     where n.pgcod  = pn_emp     
       and n.ppcta  = pn_cta     
       and n.ppmda  = pn_mda    
       and n.ppsuc  = pn_suc    
       and n.pppap  = pn_pap    
       and n.ppoper = pn_oper  
       and n.ppsbop = pn_sbop  
       and n.pptope = pn_top  
       and n.ppmod  = pn_mod    
       and n.d601co = 'S'
       and to_char(ppfpag,'yyyymm')= to_char(pd_fecpro,'yyyymm')
       ;
       if nvl(ln_cuota,0)=0 then
          -- obtener fecha 
          select /*+parallel(n,2,1)*/  
           sum(n.PPCAP) + sum(n.PPINT)
      into ln_cuota   
      from fsd601 n 
     where n.pgcod  = pn_emp     
       and n.ppcta  = pn_cta     
       and n.ppmda  = pn_mda    
       and n.ppsuc  = pn_suc    
       and n.pppap  = pn_pap    
       and n.ppoper = pn_oper  
       and n.ppsbop = pn_sbop  
       and n.pptope = pn_top  
       and n.ppmod  = pn_mod    
       and n.d601co = 'S'
       and to_char(ppfpag,'yyyymm')= (
       select to_char(min (ppfpag),'yyyymm')
            from fsd601 n 
           where n.pgcod  = pn_emp     
             and n.ppcta  = pn_cta     
             and n.ppmda  = pn_mda    
             and n.ppsuc  = pn_suc    
             and n.pppap  = pn_pap    
             and n.ppoper = pn_oper  
             and n.ppsbop = pn_sbop  
             and n.pptope = pn_top  
             and n.ppmod  = pn_mod    
             and n.d601co = 'S'
             and to_char(ppfpag,'yyyymm')> to_char(pd_fecpro,'yyyymm'));
       
       end if;
       
       if nvl(ln_cuota,0)=0 then
          -- obtener fecha 
          select /*+parallel(n,2,1)*/  
           sum(n.PPCAP) + sum(n.PPINT)
      into ln_cuota   
      from fsd601 n 
     where n.pgcod  = pn_emp     
       and n.ppcta  = pn_cta     
       and n.ppmda  = pn_mda    
       and n.ppsuc  = pn_suc    
       and n.pppap  = pn_pap    
       and n.ppoper = pn_oper  
       and n.ppsbop = pn_sbop  
       and n.pptope = pn_top  
       and n.ppmod  = pn_mod    
       and n.d601co = 'S'
       and to_char(ppfpag,'yyyymm')= (
       select to_char(max (ppfpag),'yyyymm')
            from fsd601 n 
           where n.pgcod  = pn_emp     
             and n.ppcta  = pn_cta     
             and n.ppmda  = pn_mda    
             and n.ppsuc  = pn_suc    
             and n.pppap  = pn_pap    
             and n.ppoper = pn_oper  
             and n.ppsbop = pn_sbop  
             and n.pptope = pn_top  
             and n.ppmod  = pn_mod    
             and n.d601co = 'S')
             ;
       
       end if;
       
  exception 
      when no_data_found then 
        ln_cuota := -1;
         
      when too_many_rows then
         ln_cuota := -2;
      when others then
         ln_cuota := -5;
  end;   
   return ln_cuota;
end fn_valor_cuota_al_mes;

function fn_ordinal_sin_relacion (pn_emp in number, pn_mod in number, pn_suc in number, pn_trn1 in number,
                                  pn_trn2 in number,pd_fec in date) return number is
ln_ordinal number;
ln_mod number;
ln_sucor number;
ln_tran number;
ln_nrel number;
ld_hfcon date;
begin
  begin
    select y.HCMOD,
           y.HSUCOR,
           y.HTRAN,
           y.HNREL,
           y.HFCON,
           min(y.HCORD)
        into  ln_mod,ln_sucor,ln_tran,ln_nrel,ld_hfcon,ln_ordinal
        from fsh016 y 
      where y.PGCOD  = pn_emp
        and y.HCMOD  = pn_mod
        and y.HSUCOR =  pn_suc
        and y.HTRAN  in (pn_trn1 ,pn_trn2)
        --and y.HNREL  = pn_nrel
        and y.HFCON  = pd_fec
      group by y.HCMOD,
               y.HSUCOR,
               y.HTRAN,
               y.HNREL,
               y.HFCON;
  exception 
      when no_data_found then 
          ln_ordinal := null;
          
      when too_many_rows then
      
      begin
             select y.HCMOD,
               y.HSUCOR,
               y.HTRAN,
               y.HNREL,
               y.HFCON,
               min(y.HCORD)
            into  ln_mod,ln_sucor,ln_tran,ln_nrel,ld_hfcon,ln_ordinal
            from fsh016 y 
          where y.PGCOD  = pn_emp
            and y.HCMOD  = pn_mod
            and y.HSUCOR =  pn_suc
            and y.HTRAN  in (pn_trn1 , pn_trn2)
            --and y.HNREL  = pn_nrel
            and y.HFCON  = pd_fec
            and rownum   = 1
          group by y.HCMOD,
                   y.HSUCOR,
                   y.HTRAN,
                   y.HNREL,
                   y.HFCON;
      exception
          when others then
               ln_ordinal := null;
     end;
  end;   
   return ln_ordinal;
end fn_ordinal_sin_relacion;

Procedure sp_job_riegos_datos (pd_fecpro in varchar2, pn_tiprep in number ) is
  ln_max number;
  ln_inc number;
  ln_ini number;
  ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_coderr varchar2(300);
  lc_hostname varchar2(64);
  cursor sucursal is
  select sucurs from fst001 where pgcod =1 ;
  begin
    begin
      select host_name
        into lc_hostname
        from v$instance;
    end;

     execute immediate ('truncate table CARTERAFM');
     delete Tab_jobs where  c_Codage = 'RIESGO';
     commit;
     for i in sucursal loop
        ln_ini := i.sucurs;
        lc_variable := ' begin '|| '  pq_datos_fin_mes.sp_riesgos_datos('||ln_ini||','||''''||Pd_FECpro||''''||',' ||pn_tiprep||');'|| ' End; ';
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
        VALUES('RIESGO',ln_ini,lc_variable);
        COMMIT;
      end loop;
  exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'RIESGO',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

  end;

Procedure sp_riesgos_datos (pn_numsuc in number, pd_fecpro in varchar2, pn_tiprep in number ) is

ld_fecpro date ;
lc_coderr varchar2(300);
cursor rubro  is
--  select /*+parallel(fsd014,2,1)*/rubro
  select rubro
    from fsd014
   where (pcnivc in
         (select modulo
            from fst111
           where dscod = 50
             and modulo not in (29, 120, 144/*, 33, 200*/)) --33 castigado , 200 judicial
              )
     and pcimpu = 'S'
     and pmtit <> 9;

cursor rubro2  is
  select rubro
    from fsd014
   where (pcnivc in (21,22))
     and pcimpu = 'S'
     and pmtit <> 9
     and pcrub <> 281;

cursor rubro3  is
  select rubro
    from fsd014
   where (pcnivc in (21,22))
     and pcimpu = 'S'
     and pmtit <> 9
   union all
--  select /*+parallel(fsd014,2,1)*/rubro
  select rubro
    from fsd014
   where pcnivc in
         (select modulo
            from fst111
           where dscod = 50
             and modulo not in (29, 120, 144 /*33, 200*/)) --33 castigado , 200 judicial
              or pcnivc in (141, 117)
     and pcimpu = 'S'
     and pmtit <> 9;



begin
  execute immediate ('alter session set parallel_force_local=TRUE'); --jflor 2014.01.15
  
  update tab_jobs g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'RIESGO';
  commit;
  ld_fecpro := to_date(pd_fecpro,'yyyymmdd');

  if pn_tiprep = 1 then  -- Creditos
     for i in rubro  loop
       begin
         insert into CARTERAFM (
               INSTANCIA, BCRUBR,BCSDMN,BCEMP,BCMOD,BCSUC,BCMDA,BCPAP,BCCTA,BCOPER,
               BCSBOP,BCTOP,DIAS_MORA,BCFVAL,BCFVTO,PEPAIS,PETDOC,PENDOC,C_CODSBS,
               N_TIPPEQ,D_FULEVA,C_NUMCRE,TDNOM,AOIMP,BCFECH,AOPLZO, AOTAS,BCCATE,
               aoperiod,PRVOBLI,PRVESP,PRVPRC,PRVSBE,aostat, Bcsdmo)
--         select/*+all_rows parallel(tdo,2,1)*/
         select/*+all_rows */
               pq_datos_fin_mes.fn_pa_instancia (sal.bcmod,sal.bcsuc,sal.bcmda,
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
               fn_dias_atraso(ld_fecpro,sal.bcemp,sal.bcmod,sal.bcsuc,sal.bcmda,
               sal.bcpap,sal.bccta,sal.bcoper,sal.bcsbop,sal.bctop,pre.aostat,sal.bcfvto) dias_mora,
               sal.bcfval,
               sal.bcfvto,
               cta.pepais,
               cta.petdoc,
               cta.pendoc,
               pq_datos_fin_mes.fn_codsbs(cta.pepais,cta.petdoc,cta.pendoc,sal.bccta),
               pq_datos_fin_mes.fn_cod_interno_pqn (sal.bcmod,sal.bcsuc,sal.bcmda,
               sal.bcpap,sal.bccta,sal.bcoper,sal.bcsbop,sal.bctop,ld_fecpro),
               ( select max(f.sng021fec) from SNG021 f
                   where f.sng021pdoc = cta.pepais
                     and f.sng021tdoc = cta.petdoc
                     and f.sng021ndoc = cta.pendoc)Fecult_evaluacion,
               pq_datos_fin_mes.fn_ope_sorfy(sal.bcmod,sal.bcsuc,sal.bcmda,
               sal.bcpap,sal.bccta,sal.bcoper,sal.bcsbop,sal.bctop),
               tdo.tdnom,
               pre.aoimp,
               sal.bcfech,
               pre.aopzo,
               sal.bctasa,
               sal.bccate,
               PRE.aoperiod,
               prov.obligatoria,
               prov.Especifica,
               prov.Pro_Ciclica,
               prov.Sob_Endeudamiento,
               pre.aostat,
               sal.bcsdmo
          from fsh012 sal, fsr008 cta, fsd010 pre,
--               fst014 tdo, (select/*+all_rows parallel(sal,2,1)*/
               fst014 tdo, (select/*+all_rows*/
                                           --sal.bcrubr,
                                           sum(case when b.rrcod = 35 then sal.bcsdmn else 0 end) obligatoria,
                                           sum(case when b.rrcod = 335 then sal.bcsdmn else 0 end) Especifica,
                                           sum(case when b.rrcod = 635 then sal.bcsdmn else 0 end) Pro_Ciclica,
                                           sum(case when b.rrcod = 735 then sal.bcsdmn else 0 end) Sob_Endeudamiento,
                                           sal.BCEMP,
                                           --sal.bcmod,
                                           sal.bcsuc,
                                           sal.bcmda,
                                           sal.bcpap,
                                           sal.bccta,
                                           sal.bcoper,
                                           --sal.bcsbop,
                                           sal.bctop,
                                           cta.pepais,
                                           cta.petdoc,
                                           cta.pendoc,
                                           sal.bcfech
                                      from fsh012 sal, fsr008 cta, fsd014  a, fsr014 b
                                     where sal.bcemp = 1
                                       and sal.bcsuc = pn_numsuc
                                       and sal.bcfech = ld_fecpro
                                       and sal.bcrubr = b.rrrubr
                                       and a.pcimpu = 'S'
                                       and a.rubro = b.rubro
                                       and b.rubro = i.rubro
                                       and b.rrcod in (35,635,335,735)
                                       and sal.bccta  = cta.ctnro
                                       and cta.pgcod  = 1
                                       and cta.cttfir = 'T'
                                     group by sal.BCEMP,
                                           --sal.bcmod,
                                           sal.bcsuc,
                                           sal.bcmda,
                                           sal.bcpap,
                                           sal.bccta,
                                           sal.bcoper,
                                           --sal.bcsbop,
                                           sal.bctop,
                                           cta.pepais,
                                           cta.petdoc,
                                           cta.pendoc,
                                           sal.bcfech  ) Prov
         where sal.bcemp = 1
           and sal.bcsuc = pn_numsuc
           and sal.bcfech = ld_fecpro
           and sal.bcrubr = i.rubro
           and sal.bccta  = cta.ctnro
           and cta.pgcod  = 1
           and cta.cttfir = 'T'
           and cta.petdoc = tdo.tdocum
           /*and pre.pgcod  = sal.bcemp
           and pre.aomod  = sal.bcmod
           and pre.aosuc  = sal.bcsuc
           and pre.aomda  = sal.bcmda
           and pre.aopap  = sal.bcpap
           and pre.aocta  = sal.bccta
           and pre.aooper = sal.bcoper
           and pre.aosbop = sal.bcsbop
           and pre.aotope = sal.bctop*/
           and sal.bcemp = pre.pgcod  (+)
           and sal.bcmod = pre.aomod  (+)
           and sal.bcsuc = pre.aosuc  (+)
           and sal.bcmda = pre.aomda  (+)
           and sal.bcpap = pre.aopap  (+)
           and sal.bccta = pre.aocta   (+)
           and sal.bcoper = pre.aooper (+)
           and sal.bcsbop = pre.aosbop (+)
           and sal.bctop = pre.aotope  (+)
           and sal.bcemp = prov.bcemp (+)
           and sal.bcsuc = prov.bcsuc (+)
           and sal.bcmda = prov.bcmda (+)
           and sal.bcpap = prov.bcpap (+)
           and sal.bccta = prov.bccta (+)
           and sal.bcoper = prov.bcoper(+)
           ;
           commit;
       exception
       when others then
             lc_coderr:=sqlerrm;
             INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
             VALUES(1,'RIESG',i.rubro||lc_coderr, TRUNC(SYSDATE));
             COMMIT;
       end;
       commit;
     end loop;
  elsif pn_tiprep = 2 then -- ahorros y DPF
     for i in rubro2  loop
       begin
         insert into CARTERAFM
               (
               BCRUBR,BCSDMN,BCEMP,BCMOD,BCSUC,BCMDA,BCPAP,BCCTA,BCOPER,
               BCSBOP,BCTOP,
               BCFVAL,BCFVTO,PEPAIS,PETDOC,PENDOC,
               C_NUMCRE,TDNOM,
               BCFECH,
               AOTAS,
               bcsdmo
               )
--         select/*+all_rows parallel(tdo,2,1)*/
         select/*+all_rows*/
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
               pq_datos_fin_mes.fn_ope_sorfy(sal.bcmod,sal.bcsuc,sal.bcmda,
               sal.bcpap,sal.bccta,sal.bcoper,sal.bcsbop,sal.bctop),
               tdo.tdnom,
               sal.bcfech,
               sal.bctasa,
               sal.bcsdmo
          from fsh012 sal, fsr008 cta,
               fst014 tdo
         where sal.bcemp = 1
           and sal.bcsuc = pn_numsuc
           and sal.bcfech  = ld_fecpro
           and sal.bcrubr = i.rubro
           and sal.bccta  = cta.ctnro (+)
           and cta.pgcod  = 1
           and cta.cttfir = 'T'
           and cta.petdoc = tdo.tdocum (+) ;
       exception
       when others then
             lc_coderr:=sqlerrm;
             INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
             VALUES(2,'RIESG',i.rubro||lc_coderr, TRUNC(SYSDATE));
             COMMIT;
       end;
       commit;
     end loop;
  else
     for i in rubro3  loop
       begin
         insert into CARTERAFM
               (
               INSTANCIA, BCRUBR,BCSDMN,BCEMP,BCMOD,BCSUC,BCMDA,BCPAP,BCCTA,BCOPER,
               BCSBOP,BCTOP,DIAS_MORA,BCFVAL,BCFVTO,PEPAIS,PETDOC,PENDOC,C_CODSBS,
               N_TIPPEQ,D_FULEVA,C_NUMCRE,TDNOM,AOIMP,BCFECH,AOPLZO, AOTAS,BCCATE,aoperiod )
--         select/*+all_rows parallel(pre,2,1) parallel(tdo,2,1)*/
         select/*+all_rows */
               pq_datos_fin_mes.fn_pa_instancia (sal.bcmod,sal.bcsuc,sal.bcmda,
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
               fn_dias_atraso(ld_fecpro,sal.bcemp,sal.bcmod,sal.bcsuc,sal.bcmda,
               sal.bcpap,sal.bccta,sal.bcoper,sal.bcsbop,sal.bctop,pre.aostat,sal.bcfvto) dias_mora,
               sal.bcfval,
               sal.bcfvto,
               cta.pepais,
               cta.petdoc,
               cta.pendoc,
               pq_datos_fin_mes.fn_codsbs(cta.pepais,cta.petdoc,cta.pendoc,sal.bccta),
               pq_datos_fin_mes.fn_cod_interno_pqn (sal.bcmod,sal.bcsuc,sal.bcmda,
               sal.bcpap,sal.bccta,sal.bcoper,sal.bcsbop,sal.bctop,ld_fecpro),
               ( select max(f.sng021fec) from SNG021 f
                   where f.sng021pdoc = cta.pepais
                     and f.sng021tdoc = cta.petdoc
                     and f.sng021ndoc = cta.pendoc)Fecult_evaluacion,
               pq_datos_fin_mes.fn_ope_sorfy(sal.bcmod,sal.bcsuc,sal.bcmda,
               sal.bcpap,sal.bccta,sal.bcoper,sal.bcsbop,sal.bctop),
               tdo.tdnom,
               pre.aoimp,
               sal.bcfech,
               pre.aopzo,
               sal.bctasa,
               sal.bccate,
               pre.aoperiod
          from fsh012 sal, fsr008 cta, fsd010 pre,
               fst014 tdo
         where sal.bcemp = 1
           and sal.bcsuc = pn_numsuc
           and sal.bcfech  = ld_fecpro
           and sal.bcrubr = i.rubro
           and sal.bccta  = cta.ctnro
           and cta.pgcod  = 1
           and cta.cttfir = 'T'
           and cta.petdoc = tdo.tdocum
           and pre.pgcod  = sal.bcemp
           and pre.aomod  = sal.bcmod
           and pre.aosuc  = sal.bcsuc
           and pre.aomda  = sal.bcmda
           and pre.aopap  = sal.bcpap
           and pre.aocta  = sal.bccta
           and pre.aooper = sal.bcoper
           and pre.aosbop = sal.bcsbop
           and pre.aotope = sal.bctop
           ;
       exception
       when others then
             lc_coderr:=sqlerrm;
             INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
             VALUES(3,'RIESG',i.rubro||lc_coderr, TRUNC(SYSDATE));
             COMMIT;
       end;
       commit;
     end loop;
  end if;
  commit;
  update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'RIESGO';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'RIESGO';
    commit;
    return;

end sp_riesgos_datos;

Procedure sp_job_rsg_creditos (pd_fecpro in varchar2 ) is
  ln_max number;
  ln_inc number;
  ln_ini number;
  ln_fin number;
  i      number;
  lc_variable varchar2(1000);
  ln_job number:=0;
  lc_coderr varchar2(300);
  lc_hostname varchar2(64);
  cursor sucursal is
  select sucurs from fst001 where pgcod =1 ;
  begin
  begin
    select host_name
      into lc_hostname
      from v$instance;
  end;
     execute immediate ('truncate table reportes');
     delete Tab_jobs where  c_Codage = 'RSGC';
     commit;
     for i in sucursal loop
        ln_ini := i.sucurs;
        lc_variable := ' begin '|| '  pq_datos_fin_mes.sp_rsg_creditos('||ln_ini||','||''''||Pd_FECpro||'''' ||');'|| ' End; ';
        ln_job := ln_job +1;
        --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
--     if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then    
--     if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
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
        VALUES('RSGC',ln_ini,lc_variable);
        COMMIT;
      end loop;
  exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'RSGC',lc_variable, TRUNC(SYSDATE));
           COMMIT;
--          p_c_error:=  lc_variable;

  end;

Procedure sp_rsg_creditos (pn_numsuc in number, pd_fecpro in varchar2 ) is

ld_fecant date ;
lc_coderr varchar2(300);
cursor rubro is
--  select /*+parallel(fsd014,2,1)*/rubro
  select rubro
    from fsd014
   where (pcnivc in
         (select modulo
            from fst111
           where dscod = 50
             and modulo not in (29, 120, 144/*, 33, 200*/)) --33 castigado , 200 judicial
              or pcnivc in (141, 117))
     and pcimpu = 'S'
     and pmtit <> 9;
begin

  update tab_jobs g
     set g.d_fecini = sysdate
   where g.n_numer1 = pn_numsuc
     and g.c_codage = 'RSGC';
  commit;
  ld_fecant := to_date(pd_fecpro,'yyyymmdd');
    for i in rubro loop
     begin
       insert into reportes
       (bccta,tdnom,pendoc,bcoper,bcmda,rub_act,estado,modalidad_credito,
                      tipo_credito_sbs,n_tippeq,saldo,TEA,AOPZO,NUMER02,DIAS_MORA,BCFVAL, 
                      REGION,BCSUC,PROVINCIA,numer01,Actividad,bccate,IMPORTE1,
                      IMPORTE2, IMPORTE3,IMPORTE4,FECHA2,bcmod,bctop,TEXT01, aoimp, TEXT02 )
        select a.BCCTA Cta_Cliente,
               a.tdnom tip_doc,
               a.pendoc Nro_Doc ,
               a.bcoper Operacion,
               a.bcmda  Moneda,
               a.bcrubr Rubro,
        case when substr(bcrubr,4,1) = 1 then 'VIGENTE'
             when substr(bcrubr,4,1) = 4 then 'REFINANCIADO'
             when substr(bcrubr,4,1) = 5 then 'VENCIDO'
             when substr(bcrubr,4,1) = 6 then 'JUDICIAL' ELSE 'OTROS' END ESTADO,
        case when bcmod = 105 or ( bcmod = 106 and a.bctop in(2,4,6)) then 'PARALELO'
             when substr(bcrubr,4,1) = 4 and a.aostat = 61 then 'REFINANCIADO'
             when substr(bcrubr,4,1) = 5 and a.aostat = 61 then 'REFINANC_VENCIDO'
             when substr(bcrubr,4,1) = 4 and a.aostat = 33 then 'TRANSADO'
             when substr(bcrubr,4,1) = 5 and a.aostat = 33 then 'TRANSADO_VENCIDO'
             when pq_datos_fin_mes.fn_reprogramado (a.bcmod,a.bcsuc,a.bcmda,
                     a.bcpap,a.bccta,a.bcoper,a.bcsbop,a.bctop) = 860 then 'REP_CAMBIO_FECHA'
             when  pq_datos_fin_mes.fn_reprogramado (a.bcmod,a.bcsuc,a.bcmda,
                     a.bcpap,a.bccta,a.bcoper,a.bcsbop,a.bctop) = 870 then 'REP_DESASTRES'
             ELSE 'NORMAL' END MODALIDAD,
        case when substr(bcrubr,5,2) = '02' then 'MICRO'
             when substr(bcrubr,5,2) = '03' and substr(bcrubr,9,2) = '01' then 'CONSUMO REVOLVENTE'
             when substr(bcrubr,5,2) = '03' and substr(bcrubr,9,2) <> '01' then 'CONSUMO NO REVOLVENTE'
             when substr(bcrubr,5,2) = '04' then 'HIPOTECARIO'
             when substr(bcrubr,5,2) = '12' then 'MEDIANA'
             when substr(bcrubr,5,2) = '13' then 'PEQUEÑA'
             ELSE 'OTROS' END TIPO_SBS,
             N_TIPPEQ Prod_CMAC,
             BCSDMN Saldo_Capital,
             a.aotas TEA,
             a.aoplzo PLAZO,
             a.aoperiod FREC_PAGO,
             a.DIAS_MORA,
             a.bcfval,      
             h.regnom REGION,
             a.BCSUC Sucursal,
             pq_datos_fin_mes.fn_provincia(a.pepais,a.petdoc,a.pendoc)PROVINCIA,
             pq_datos_fin_mes.fn_cod_activ(a.pepais,a.petdoc,a.pendoc)codactiv,
             pq_datos_fin_mes.fn_actividad(a.pepais,a.petdoc,a.pendoc)Actividad,
             a.bccate CATEGORIA,
             a.prvobli Prv_Obligatoria,
             a.prvesp PRV_ESPECIFICA,
             a.prvprc PRV_Prociclica,
             a.prvsbe PRV_SOBRENDEU,
             pq_datos_fin_mes.fn_prides(a.instancia,a.bccta, a.bcoper,a.bcsuc,
             a.bcmda, a.bcpap, a.bcmod, a.bctop
             ) FEC_PRI_DES,
             a.bcmod, a.bctop,
            (select m.scnom from fst001 m where  m.pgcod = a.bcemp
                and m.sucurs = a.bcsuc), 
            a.aoimp,
            (select sng001ase from  sng001 where  sng001inst = a.instancia)
         from CARTERAFM a,  fst810 h, fst811 g
         where bcfech = ld_fecant
           and g.pgcod = a.bcemp
           and a.bcrubr = i.rubro
           and a.bcsuc  = pn_numsuc
           and g.oficod =a.bcsuc
           and g.regcod < 100
           and h.pgcod = g.pgcod
           and h.regcod= g.regcod 
          ;
     exception
     when others then
           lc_coderr:=sqlerrm;
           INSERT INTO LOG_ERROR_BANDEJA(N_NRO,C_CODBDJ,C_DESERR,D_FECERR)
           VALUES(0,'RSGC',pn_numsuc||lc_coderr, TRUNC(SYSDATE));
           COMMIT;
     end;
     commit;
  end loop;
  commit;
  update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 =  pn_numsuc
       and g.c_codage = 'RSGC';
    commit;
 EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm,1,200);
      update tab_jobs g
         set g.c_inderr = 'S',
             g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'RSGC';
    commit;
    return;

end sp_rsg_creditos;

end pq_datos_fin_mes;
/

