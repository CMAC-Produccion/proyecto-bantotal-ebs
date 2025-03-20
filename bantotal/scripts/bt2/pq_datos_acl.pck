create or replace package PQ_datos_ACL is
  
   -- *****************************************************************
    -- Nombre                     : PQ_datos_ACL
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 17/02/2014 09:37:41 a.m
    -- Autor de Creación          : ABERNEDO
    -- Uso                        : paquete que se maneja el proceso de ACL 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Autor Modificacion         : YYAMPI
    -- Fecha Modificacion         : 19/10/2021
    -- Descripción Modificacion   : Se agrego la funcion fn_Fec_Proximo_vto_bdc
    -- Autor Modificacion         : APACHECOH
    -- Fecha Modificacion         : 15/02/2024
    -- Descripción Modificacion   : Se agrego un limite por guia para la ejecucion de los jobs
    -- *****************************************************************
  
   
  Procedure sp_job_NuevaClave(pd_fecpro in varchar2);
  Procedure SP_NuevaClave(pn_numsuc in number, pd_fecpro in varchar2);

  function fn_ope_sorfy(pn_mda  in number,
                        pn_pap  in number,
                        pn_cta  in number,
                        pn_oper in number) return varchar2;
  Procedure sp_job_acl_datos(Pd_FECmesACT in varchar2,
                             Pd_FECmesANT in varchar2);
  Procedure sp_acl_datos(pn_numsuc    in number,
                         Pd_FECmesACT in varchar2,
                         Pd_FECmesANT in varchar2);
  function fn_rubro_anterior(pn_emp       in number,
                             pn_mod       in number,
                             pn_suc       in number,
                             pn_mda       in number,
                             pn_pap       in number,
                             pn_cta       in number,
                             pn_oper      in number,
                             pn_sbop      in number,
                             pn_top       in number,
                             pd_fecmesant in date) return number;
  function fn_Fec_Proximo_vto(pn_emp    in number,
                              pn_mod    in number,
                              pn_suc    in number,
                              pn_mda    in number,
                              pn_pap    in number,
                              pn_cta    in number,
                              pn_oper   in number,
                              pn_sbop   in number,
                              pn_top    in number,
                              pd_fecpro in date) return date;
                              
  function fn_Fec_Proximo_vto_bdc(pn_emp    in number,
                                  pn_mod    in number,
                                  pn_suc    in number,
                                  pn_mda    in number,
                                  pn_pap    in number,
                                  pn_cta    in number,
                                  pn_oper   in number,
                                  pn_sbop   in number,
                                  pn_top    in number,
                                  pd_fecpro in date) return date;
  
  function fn_Interes_Proximo_vto(pn_emp    in number,
                                  pn_mod    in number,
                                  pn_suc    in number,
                                  pn_mda    in number,
                                  pn_pap    in number,
                                  pn_cta    in number,
                                  pn_oper   in number,
                                  pn_sbop   in number,
                                  pn_top    in number,
                                  pd_fecpro in date) return number;
  function fn_cuotas_pagadas(pn_emp    in number,
                             pn_mod    in number,
                             pn_suc    in number,
                             pn_mda    in number,
                             pn_pap    in number,
                             pn_cta    in number,
                             pn_oper   in number,
                             pn_sbop   in number,
                             pn_top    in number,
                             pd_fecpro in date) return number;
  function fn_monto_pagado(pn_emp    in number,
                           pn_mod    in number,
                           pn_suc    in number,
                           pn_mda    in number,
                           pn_pap    in number,
                           pn_cta    in number,
                           pn_oper   in number,
                           pn_sbop   in number,
                           pn_top    in number,
                           pd_fecpro in date) return number;
  function fn_Fec_Ultimo_pago(pn_emp    in number,
                              pn_mod    in number,
                              pn_suc    in number,
                              pn_mda    in number,
                              pn_pap    in number,
                              pn_cta    in number,
                              pn_oper   in number,
                              pn_sbop   in number,
                              pn_top    in number,
                              pd_fecpro in date) return date;
  function fn_cod_activ(pn_pais in number,
                        pn_tdoc in number,
                        pc_ndoc in char) return number;
  function fn_negocio(pn_pais in number,
                      pn_tdoc in number,
                      pc_ndoc in char) return varchar2;
  function fn_Saldo_relacion(pn_emp    in number,
                             pn_mod    in number,
                             pn_suc    in number,
                             pn_mda    in number,
                             pn_pap    in number,
                             pn_cta    in number,
                             pn_oper   in number,
                             pn_sbop   in number, /*pn_top in number,*/
                             pd_fecpro in date,
                             pn_nrorel in number,
                             pn_rubro  in number) return number;
  Procedure sp_job_solicitud(pd_fecpro in varchar2);
  Procedure sp_solicitud_acl(pn_numsuc in number, pd_fecpro in varchar2);
  Procedure sp_solicitud_acl_II(pd_fecpro in varchar2);
  function fn_Mto_linea(pn_emp  in number,
                        pn_mod  in number,
                        pn_suc  in number,
                        pn_mda  in number,
                        pn_pap  in number,
                        pn_cta  in number,
                        pn_oper in number,
                        pn_sbop in number,
                        pn_top  in number) return number;
  function fn_fec_solitud(pn_instancia in number) return date;
  function fn_tip_credito(pn_instancia in number,
                          pn_pais      in number,
                          pn_tdoc      in number,
                          pc_ndoc      in char,
                          pn_mod       in number) return char;
  function fn_fec_resolucion(pn_instancia in number) return date;
  function fn_fec_digitacion(pn_instancia in number) return date;
  --mod@abr 20170131
  function fn_fec_aprobacion(pn_instancia in number) return date;
  function fn_usu_aprobacion(pn_instancia in number) return char;
  --modabr 20170131
  function fn_usu_desembolso(pn_instancia in number) return char;
  function fn_usu_digitacion(pn_instancia in number) return char;
  function fn_tip_calen(pn_emp  in number,
                        pn_mod  in number,
                        pn_suc  in number,
                        pn_mda  in number,
                        pn_pap  in number,
                        pn_cta  in number,
                        pn_oper in number,
                        pn_sbop in number,
                        pn_top  in number) return char;
  function fn_dias_gracia(pn_emp  in number,
                          pn_mod  in number,
                          pn_suc  in number,
                          pn_mda  in number,
                          pn_pap  in number,
                          pn_cta  in number,
                          pn_oper in number,
                          pn_sbop in number,
                          pn_top  in number) return number;
  function fn_nro_cuotas(pn_emp  in number,
                         pn_mod  in number,
                         pn_suc  in number,
                         pn_mda  in number,
                         pn_pap  in number,
                         pn_cta  in number,
                         pn_oper in number,
                         pn_sbop in number,
                         pn_top  in number) return number;
  function fn_valor_cuotas(pn_ins in number, pn_cta in number) return number;
  function fn_cuotas_calen(pn_emp  in number,
                           pn_mod  in number,
                           pn_suc  in number,
                           pn_mda  in number,
                           pn_pap  in number,
                           pn_cta  in number,
                           pn_oper in number,
                           pn_sbop in number,
                           pn_top  in number) return number;
  function fn_valor_cuota_impaga(pn_emp    in number,
                                 pn_mod    in number,
                                 pn_suc    in number,
                                 pn_mda    in number,
                                 pn_pap    in number,
                                 pn_cta    in number,
                                 pn_oper   in number,
                                 pn_sbop   in number,
                                 pn_top    in number,
                                 pd_fecpro in date) return number;
  function fn_mto_aprobado(pn_emp   in number,
                           pn_mod   in number,
                           pn_suc   in number,
                           pn_mda   in number,
                           pn_pap   in number,
                           pn_cta   in number,
                           pn_oper  in number,
                           pn_sbop  in number,
                           pn_top   in number,
                           pn_aoimp in number) return number;
  function fn_primer_pago(pn_emp    in number,
                          pn_mod    in number,
                          pn_suc    in number,
                          pn_mda    in number,
                          pn_pap    in number,
                          pn_cta    in number,
                          pn_oper   in number,
                          pn_sbop   in number,
                          pn_top    in number,
                          pd_fecpro in date) return date;
  function fn_usu_evaluacion(pn_instancia in number) return char;
  function fn_ind_riesgo_camb(pn_instancia in number) return char;
  function fn_shock_camb(pn_instancia in number) return char;
  Procedure sp_job_Provisiones(pd_fecpro in varchar2);
  Procedure sp_provisiones_acl(pn_numsuc in number, pd_fecpro in varchar2);
  Procedure sp_categoria_acl(pd_fecmesACT in varchar2,
                             pd_fecmesANT in varchar2);
  function fn_categoria(pn_emp    in number,
                        pn_cta    in number,
                        pd_feccat in date,
                        pn_codcat in number) return varchar2;
  function fn_contador_cal_historica(pn_cta in number) return number;
  function fn_calificacion_mesant(pn_cta in number, pd_fecmesANT in date)
    return char;
  Procedure sp_job_garantias(pd_fecpro in varchar2);
  Procedure sp_garantias_acl(pn_numsuc in number, pd_fecpro in varchar2);
  function fn_rubro_gar(pn_emp    in number,
                        pn_mod    in number,
                        pn_suc    in number,
                        pn_mda    in number,
                        pn_pap    in number,
                        pn_cta    in number,
                        pn_oper   in number,
                        pn_sbop   in number,
                        pn_top    in number,
                        pd_fecpro in date) return number;
  function fn_saldo_contable_gar(pn_emp    in number,
                                 pn_mod    in number,
                                 pn_suc    in number,
                                 pn_mda    in number,
                                 pn_pap    in number,
                                 pn_cta    in number,
                                 pn_oper   in number,
                                 pn_sbop   in number,
                                 pn_top    in number,
                                 pd_fecpro in date) return number;
  Procedure SP_Otras_estructuras(pd_fecpro in varchar2);

  function fn_MtoLinea(pn_emp  in number,
                       pn_mod  in number,
                       pn_suc  in number,
                       pn_mda  in number,
                       pn_pap  in number,
                       pn_cta  in number,
                       pn_oper in number,
                       pn_sbop in number,
                       pn_top  in number,
                       pn_rel  in number) return number;
  function fn_MtoDisp_Hist(pn_emp    in number,
                           pn_mod    in number,
                           pn_suc    in number,
                           pn_mda    in number,
                           pn_pap    in number,
                           pn_cta    in number,
                           pn_oper   in number,
                           pn_sbop   in number,
                           pn_top    in number,
                           pd_fecpro in date,
                           pn_rel    in number) return number;
  ---------------------------Modificaciones 2016.01.27---------------------------
  Function Fn_cliente_corp(pn_pai in number,
                           pn_tdo in number,
                           pc_ndo in char) return number;
  Function Fn_monto_aprobado(pn_ins  in number,
                             pn_cta  in number,
                             pn_oper in number) return number;
  Function Fn_promotor(pn_ins in number) return char;
  Function Fn_cuotasParc(pn_emp in number,
                         pn_mod in number,
                         pn_suc in number,
                         pn_mda in number,
                         pn_pap in number,
                         pn_cta in number,
                         pn_ope in number,
                         pn_sbo in number,
                         pn_top in number) return char;
  Function Fn_fecTran116(pn_emp in number,
                         pn_mod in number,
                         pn_suc in number,
                         pn_mda in number,
                         pn_pap in number,
                         pn_cta in number,
                         pn_ope in number,
                         pn_sbo in number,
                         pn_top in number) return date;
  Function Fn_tipo_solicitud(pn_ins in number) return number;
  --mod 20161003@abr
  Procedure Sp_refinanciado(pn_cta  in number,
                            pn_ope  in number,
                            pn_tasa out number);
  Procedure Sp_detalle_deuda(pn_emp    in number,
                             pn_mod    in number,
                             pn_suc    in number,
                             pn_mda    in number,
                             pn_pap    in number,
                             pn_cta    in number,
                             pn_oper   in number,
                             pn_sbop   in number,
                             pn_top    in number,
                             pd_fecpro in date,
                             pn_cap    out number,
                             pn_int    out number,
                             pn_mora   out number,
                             pn_seg    out number,
                             pn_com    out number,
                             pn_mto    out number,
                             pn_mot    out number,
                             pn_sut    out number,
                             pn_trt    out number,
                             pn_rel    out number,
                             pd_fet    out date,
                             pn_mor    out number /*,pc_usi out char*/ --mod@abr 20170131
                             );
  --mod@abr20170317
  Procedure Sp_detalle_deuda_Par(pn_emp    in number,
                                 pn_mod    in number,
                                 pn_suc    in number,
                                 pn_mda    in number,
                                 pn_pap    in number,
                                 pn_cta    in number,
                                 pn_oper   in number,
                                 pn_sbop   in number,
                                 pn_top    in number,
                                 pd_fecpag in date,
                                 pd_pp1fec in date,
                                 pd_fecpro in date,
                                 pn_cap    out number,
                                 pn_int    out number,
                                 pn_mora   out number,
                                 pn_seg    out number,
                                 pn_com    out number,
                                 pn_mto    out number,
                                 pn_mot    out number,
                                 pn_sut    out number,
                                 pn_trt    out number,
                                 pn_rel    out number,
                                 pd_fet    out date,
                                 pn_mor    out number /*,pc_usi out char*/);
  --mod@abr20170317    
  --mod@abr 20170505
  Procedure sp_job_usuario;
  Procedure sp_usuario(pn_numsuc in number);
  Procedure sp_job_usuario_II;
  Procedure sp_usuario_ii(pn_numsuc in number);
  --fin mod@abr 20170505
  --dcstro
  function fn_por_fondo(   pn_cta    in number,
                           pn_oper   in number,
                           pd_fecpro in date) return number;
  function fn_ind_fondo(   pn_cta    in number,
                           pn_oper   in number,
                           pd_fecpro in date) return varchar2;

  --
  ------------------------------------------------------------------
  ---yyampi se agrego la funcion de dias de atraso real BT --------
  function fn_dias_atraso(
                         v_Pgfape in date, --fecha de proceso
                         v_Pgcod  in number,
                         v_Scmod  in number,
                         v_Scsuc  in number,
                         v_Scmda  in number,
                         v_Scpap  in number,
                         v_Sccta  in number,
                         v_Scoper in number,
                         v_Scsbop in number,
                         v_Sctope in number,
                         v_Scstat in number,
                         v_fecven in date
                       ) return number;
  ------------------------------------------------------------------                     
                        
end PQ_datos_ACL;
/

create or replace package body pq_datos_ACL is

  Procedure sp_job_NuevaClave(pd_fecpro in varchar2) is
    --ln_max number;
    --ln_inc number;
    ln_ini number;
    --ln_fin number;
    i           number;
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_hostname varchar2(64);
    ln_limit    number := 0;
    ln_numjob   number := 0;
    --lc_coderr varchar2(300);
    cursor sucursal is
      select sucurs from fst001 where pgcod = 1;
  begin
    begin
      select host_name into lc_hostname from v$instance;
    end;
    execute immediate ('truncate table UAI_ACLPROCN');
    delete Tab_jobs where c_Codage = 'NC';
    commit;
    
    --apachecoh 2024.02.09
    --Limite de JOBS parametrizado en guia
    begin
      select tp1nro1
        into ln_limit
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11169
         and tp1corr1 = 11
         and tp1corr2 = 1
         and tp1corr3 = 1;
    exception
      when others then
        ln_limit := 20;
    end;
    
    for i in sucursal loop
      ln_ini      := i.sucurs;
      lc_variable := ' begin ' || '  pq_datos_acl.SP_NuevaClave(' || ln_ini || ',' || '''' ||
                     Pd_FECpro || '''' || ');' || ' End; ';
      ln_job      := ln_job + 1;
      --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
    
      --        if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then  
      --        if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 180),
                        interval  => null,
                        no_parse  => false,
                        instance  => 1,
                        --instance  => 2,  01/01/2024
                        force     => false);
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 180),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      end if;
      
      --apachecoh 2024.02.09  
      BEGIN
        SELECT count(*)
          INTO ln_numjob
          FROM dba_jobs x
         WHERE upper(x.what) LIKE '%PQ_DATOS_ACL.SP_NUEVACLAVE%';
      EXCEPTION
        WHEN OTHERS THEN
          ln_numjob := 0;
      END;
    
      WHILE ln_numjob > ln_limit LOOP
        BEGIN
          SELECT count(*)
            INTO ln_numjob
            FROM dba_jobs x
           WHERE upper(x.what) LIKE
                 '%PQ_DATOS_ACL.SP_NUEVACLAVE%';
        EXCEPTION
          WHEN OTHERS THEN
            ln_numjob := 0;
        END;
      END LOOP;
      
      INSERT INTO Tab_jobs
        (c_Codage, n_Numer1, c_detjob)
      VALUES
        ('NC', ln_ini, lc_variable);
      COMMIT;
    end loop;
  exception
    when others then
      --lc_coderr:=sqlerrm;
      INSERT INTO LOG_ERROR_BANDEJA
        (N_NRO, C_CODBDJ, C_DESERR, D_FECERR)
      VALUES
        (0, 'NC', lc_variable, TRUNC(SYSDATE));
      COMMIT;
      --          p_c_error:=  lc_variable;
  
  end sp_job_NuevaClave;

  Procedure SP_NuevaClave(pn_numsuc in number, pd_fecpro in varchar2) is
  
    ld_fecpro date;
    --ld_fecant date ;
    lc_coderr varchar2(300);
    cursor rubro is
      select rubro
        from fsd014
       where (pcnivc in (select modulo
                           from fst111
                          where dscod = 50
                            and modulo not in (29, 120, 144)) --33 castigado , 200 judicial
             or pcnivc in (141, 117))
         and pcimpu = 'S'
         and pmtit <> 9;
  begin
  
    update tab_jobs g
       set g.d_fecini = sysdate
     where g.n_numer1 = pn_numsuc
       and g.c_codage = 'NC';
    commit;
    ld_fecpro := to_date(pd_fecpro, 'yyyymmdd');
    --ld_fecant := ADD_MONTHS(ld_fecpro,-1);
    for i in rubro loop
      begin
      
        insert into UAI_ACLPROCN
          (N_EMP_BCEMP,
           N_MOD_BCMOD,
           N_SUC_BCSUC,
           N_MDA_BCMDA,
           N_PAP_BCPAP,
           N_CTA_BCCTA,
           N_OPER_BCOPER,
           N_SBOP_BCSBOP,
           N_TOPE_BCTOP,
           N_RUBR_BCRUBR,
           D_FECPRO_BCFECH,
           D_FECVAL_BCFVAL,
           D_FECVEN_BCFVTO,
           N_CODCONT_BCGPO,
           N_CODCOND_BCPROD,
           N_PLAZO_BCPZO,
           N_SALCAP_BCSDMO,
           N_SALMN_BCSDMN)
        
          select h12.bcemp,
                 h12.bcmod,
                 nvl(nvl(aosuc,
                         (select dd10.aosuc
                            from fsd010 dd10
                           where h12.bcemp = dd10.pgcod
                             and h12.bcmod = dd10.aomod
                             and h12.bcmda = dd10.aomda
                             and h12.bcpap = dd10.aopap
                             and h12.bccta = dd10.aocta
                             and h12.bcoper = dd10.aooper
                             and h12.bcsbop = dd10.aosbop
                             and h12.bctop = dd10.aotope)),
                     h12.bcsuc),
                 --nvl(sn130.sng130suds,h12.bcsuc),
                 h12.bcmda,
                 h12.bcpap,
                 h12.bccta,
                 h12.bcoper,
                 h12.bcsbop,
                 h12.bctop,
                 h12.bcrubr,
                 h12.bcfech,
                 h12.bcfval,
                 h12.bcfvto,
                 h12.bcgpo,
                 h12.bcprod,
                 h12.bcplaz,
                 h12.bcsdmo,
                 h12.bcsdmn
            from fsh012 h12, fsd010 d10
          /* left join (sng130 sn130 inner join sng131 sn131 on
          sn131.sng130cor = sn130.sng130cor
          and sn131.sng131mod <> 0
          and sn131.sng131trn <> 0
          and sn131.sng131con = 'S') on (h12.bcemp  = sn131.sng131pgc
          and h12.bcmod  = sn131.sng131mod
          and h12.bcsuc  = sn131.sng131suc
          and h12.bcmda  = sn131.sng131mda
          and h12.bcpap  = sn131.sng131pap
          and h12.bccta  = sn131.sng131cta
          and h12.bcoper = sn131.sng131ope
          and h12.bcsbop = sn131.sng131sbo
          and h12.bctop  = sn131.sng131top )*/
          
           where h12.bcemp = 1
             and h12.bcsuc = pn_numsuc
             and h12.bcrubr = i.rubro
             and h12.bcfech = ld_fecpro
             and h12.bcemp = d10.pgcod(+)
             and h12.bcmod = d10.aomod(+)
             and h12.bcsuc = d10.aosuc(+)
             and h12.bcmda = d10.aomda(+)
             and h12.bcpap = d10.aopap(+)
             and h12.bccta = d10.aocta(+)
             and h12.bcoper = d10.aooper(+)
             and h12.bcsbop = d10.aosbop(+)
             and h12.bctop = d10.aotope(+)
          
          ;
        commit;
      exception
        when others then
          lc_coderr := sqlerrm;
          INSERT INTO LOG_ERROR_BANDEJA
            (N_NRO, C_CODBDJ, C_DESERR, D_FECERR)
          VALUES
            (0, 'NC', pn_numsuc || lc_coderr, TRUNC(SYSDATE));
          COMMIT;
      end;
      commit;
    end loop;
    commit;
    update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 = pn_numsuc
       and g.c_codage = 'NC';
    commit;
  EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm, 1, 200);
      update tab_jobs g
         set g.c_inderr = 'S', g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'NC';
      commit;
      return;
    
  end SP_NuevaClave;

  function fn_ope_sorfy(pn_mda  in number,
                        pn_pap  in number,
                        pn_cta  in number,
                        pn_oper in number) return varchar2 is
    lc_cresor varchar2(17);
  begin
    begin
      Select q.bnj096sor
        into lc_cresor
        from bnj096 q
       where /*q.bnj096suc = pn_suc
                          and*/
       q.bnj096mda = pn_mda
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

  Procedure sp_job_acl_datos(Pd_FECmesACT in varchar2,
                             Pd_FECmesANT in varchar2) is
    --ln_max number;
    --ln_inc number;
    ln_ini number;
    --ln_fin number;
    i           number;
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_hostname varchar2(64);    
    ln_limit    number := 0;
    ln_numjob   number := 0;
    --lc_coderr varchar2(300);
    cursor sucursal is
      select sucurs from fst001 where pgcod = 1;
  begin
    begin
      select host_name into lc_hostname from v$instance;
    end;
    execute immediate ('truncate table UAI_ACLPRE');
    delete Tab_jobs where c_Codage = 'ACL';
    commit;
    
    --apachecoh 2024.02.09
    --Limite de JOBS parametrizado en guia
    begin
      select tp1nro1
        into ln_limit
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11169
         and tp1corr1 = 11
         and tp1corr2 = 1
         and tp1corr3 = 1;
    exception
      when others then
        ln_limit := 20;
    end;
    
    for i in sucursal loop
      ln_ini      := i.sucurs;
      lc_variable := ' begin ' || '  pq_datos_ACL.sp_acl_datos(' || ln_ini || ',' || '''' ||
                     Pd_FECmesACT || '''' || ',' || '''' || Pd_FECmesANT || '''' || ');' ||
                     ' End; ';
      ln_job      := ln_job + 1;
      --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
      --        if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then   
      --        if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 180),
                        interval  => null,
                        no_parse  => false,
                        instance  => 1,
                       -- instance  => 2, 01/01/2024
                        force     => false);
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 180),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      end if;
      
      --apachecoh 2024.02.09  
      BEGIN
        SELECT count(*)
          INTO ln_numjob
          FROM dba_jobs x
         WHERE upper(x.what) LIKE '%PQ_DATOS_ACL.SP_ACL_DATOS%';
      EXCEPTION
        WHEN OTHERS THEN
          ln_numjob := 0;
      END;
    
      WHILE ln_numjob > ln_limit LOOP
        BEGIN
          SELECT count(*)
            INTO ln_numjob
            FROM dba_jobs x
           WHERE upper(x.what) LIKE
                 '%PQ_DATOS_ACL.SP_ACL_DATOS%';
        EXCEPTION
          WHEN OTHERS THEN
            ln_numjob := 0;
        END;
      END LOOP;
      
      INSERT INTO Tab_jobs
        (c_Codage, n_Numer1, c_detjob)
      VALUES
        ('ACL', ln_ini, lc_variable);
      COMMIT;
    end loop;
  exception
    when others then
      --lc_coderr:=sqlerrm;
      INSERT INTO LOG_ERROR_BANDEJA
        (N_NRO, C_CODBDJ, C_DESERR, D_FECERR)
      VALUES
        (0, 'ACL', lc_variable, TRUNC(SYSDATE));
      COMMIT;
      --          p_c_error:=  lc_variable;
  
  end sp_job_acl_datos;

  Procedure sp_acl_datos(pn_numsuc    in number,
                         Pd_FECmesACT in varchar2,
                         Pd_FECmesANT in varchar2) is
  
    ld_fecpro    date;
    ld_fecmesant date;
    lc_coderr    varchar2(300);
    cursor rubro is
      select rubro
        from fsd014
       where (pcnivc in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in (29, 120, 144 /*, 33, 200*/)) --33 castigado , 200 judicial
             or pcnivc in (141, 117))
         and pcimpu = 'S'
         and pmtit <> 9;
    --ld_fecant date;
  begin
  
    update tab_jobs g
       set g.d_fecini = sysdate
     where g.n_numer1 = pn_numsuc
       and g.c_codage = 'ACL';
    commit;
    ld_fecpro    := to_date(Pd_FECmesACT, 'yyyymmdd');
    ld_fecmesant := to_date(Pd_FECmesANT, 'yyyymmdd'); --Para sacar el rubro del mes anterior
    --ld_fecant := ADD_MONTHS(ld_fecpro,-1);
  
    for i in rubro loop
      begin
        insert into UAI_ACLPRE
          (N_EMP_BCEMP,
           N_MOD_BCMOD,
           N_SUC_BCSUC,
           N_MDA_BCMDA,
           N_PAP_BCPAP,
           N_CTA_BCCTA,
           N_OPER_BCOPER,
           N_SBOP_BCSBOP,
           N_TOPE_BCTOP,
           N_RUBR_BCRUBR,
           N_PAIS_PEPAIS,
           N_TDOC_PETDOC,
           C_NDOC_PENDOC,
           C_NUMSOR_BNJ096SOR,
           N_MTODES_AOIMP,
           N_PERIOD_AOPERIOD,
           N_ESTAD_AOSTAT,
           D_FECVAL_BCFVAL,
           D_FECPROXVEN_PPFPAG,
           N_INTCUO_PPINT,
           N_CUOPAG_PPFPAG,
           N_MTOPAG_PP1CAP,
           D_FECULTPAG_PP1FECH,
           C_NUMCRE,
           D_FECREF_BCFVAL,
           D_FECVEN_BCFVTO,
           N_CODCONT_BCGPO,
           C_TIPDES_BCMOD,
           N_CODLINCRED,
           N_CODCOND_BCPROD,
           N_PLAZO_BCPZO,
           N_RUBRANT_BCRUBR,
           N_MTOINTE_DIF_BCSDMO,
           N_MTOGAR_BCSDMO,
           N_MTOLINNOUT_BCSDMO,
           N_MTODEUIND_BCSDMO,
           N_MTODEUDIR_BCSDMO,
           N_SALCAP_BCSDMO,
           N_FECULTRCC_TPNRO,
           N_DIASMORA,
           C_NEG_SNGC60NOME,
           N_ACT_SNGC60ACTE,
           N_INSTANCIA_XWFPRCINS,
           D_FECPRO_BCFECH,
           N_SALMN_BCSDMN,
           n_tipcorp, --mod 2016.01.27
           N_PORFON, -- mod 2021.01.07 dcastro
           C_FONDO,  -- mod 2021.01.07 dcastro
           D_FECPROXVEN_PPFPAG_BDC     --17/10/2021 YYAMPI
           )
        --       select/*+all_rows parallel(sal,2,1)*/
          select /*+all_rows*/
           sal.n_emp_bcemp,
           sal.n_mod_bcmod,
           sal.n_suc_bcsuc,
           sal.n_mda_bcmda,
           sal.n_pap_bcpap,
           sal.n_cta_bccta,
           sal.n_oper_bcoper,
           sal.n_sbop_bcsbop,
           sal.n_tope_bctop,
           sal.n_rubr_bcrubr,
           cta.pepais,
           cta.petdoc,
           cta.pendoc,
           case
             when sal.D_FECVAL_BCFVAL < to_date('20130701', 'yyyymmdd') then
              pq_datos_ACL.fn_ope_sorfy(sal.n_mda_bcmda,
                                        sal.n_pap_bcpap,
                                        sal.n_cta_bccta,
                                        sal.n_oper_bcoper)
           end,
           pre.aoimp,
           pre.aoperiod,
           pre.aostat,
           sal.D_FECVAL_BCFVAL,
           pq_datos_ACL.fn_Fec_Proximo_vto(sal.n_emp_bcemp,
                                           sal.n_mod_bcmod,
                                           sal.n_suc_bcsuc,
                                           sal.n_mda_bcmda,
                                           sal.n_pap_bcpap,
                                           sal.n_cta_bccta,
                                           sal.n_oper_bcoper,
                                           sal.n_sbop_bcsbop,
                                           sal.n_tope_bctop,
                                           ld_fecpro),
           pq_datos_ACL.fn_Interes_Proximo_vto(sal.n_emp_bcemp,
                                               sal.n_mod_bcmod,
                                               sal.n_suc_bcsuc,
                                               sal.n_mda_bcmda,
                                               sal.n_pap_bcpap,
                                               sal.n_cta_bccta,
                                               sal.n_oper_bcoper,
                                               sal.n_sbop_bcsbop,
                                               sal.n_tope_bctop,
                                               ld_fecpro),
           pq_datos_ACL.fn_cuotas_pagadas(sal.n_emp_bcemp,
                                          sal.n_mod_bcmod,
                                          sal.n_suc_bcsuc,
                                          sal.n_mda_bcmda,
                                          sal.n_pap_bcpap,
                                          sal.n_cta_bccta,
                                          sal.n_oper_bcoper,
                                          sal.n_sbop_bcsbop,
                                          sal.n_tope_bctop,
                                          ld_fecpro),
           pq_datos_ACL.fn_monto_pagado(sal.n_emp_bcemp,
                                        sal.n_mod_bcmod,
                                        sal.n_suc_bcsuc,
                                        sal.n_mda_bcmda,
                                        sal.n_pap_bcpap,
                                        sal.n_cta_bccta,
                                        sal.n_oper_bcoper,
                                        sal.n_sbop_bcsbop,
                                        sal.n_tope_bctop,
                                        ld_fecpro),
           pq_datos_ACL.fn_Fec_Ultimo_pago(sal.n_emp_bcemp,
                                           sal.n_mod_bcmod,
                                           sal.n_suc_bcsuc,
                                           sal.n_mda_bcmda,
                                           sal.n_pap_bcpap,
                                           sal.n_cta_bccta,
                                           sal.n_oper_bcoper,
                                           sal.n_sbop_bcsbop,
                                           sal.n_tope_bctop,
                                           ld_fecpro),
           (lpad(to_char(sal.n_cta_bccta), 9, '0') ||
           lpad(to_char(sal.n_mod_bcmod), 3, '0') ||
           lpad(to_char(sal.n_mda_bcmda), 3, '0') ||
           lpad(to_char(sal.n_oper_bcoper), 9, '0') ||
           lpad(to_char(sal.n_tope_bctop), 3, '0')),
           Case
             When Substr(sal.n_rubr_bcrubr, 4, 1) = '4' then
              D_FECVAL_BCFVAL
             When Substr(sal.n_rubr_bcrubr, 4, 1) = '5' and
                  Substr(sal.n_rubr_bcrubr, 7, 2) = '19' then
              D_FECVAL_BCFVAL
             When sal.N_CODCOND_BCPROD in (33, 34, 61) then
              D_FECVAL_BCFVAL
             Else
              null --to_date('01/01/0001','dd/mm/yyyy')
           End,
           sal.D_FECVEN_BCFVTO,
           sal.N_CODCONT_BCGPO,
           Case
             When sal.n_mod_bcmod in (116, 117) then
              'Linea'
             else
              'No linea'
           end,
           sal.n_mod_bcmod || sal.n_tope_bctop,
           sal.N_CODCOND_BCPROD,
           sal.N_PLAZO_BCPZO,
           pq_datos_acl.fn_rubro_anterior(sal.n_emp_bcemp,
                                          sal.n_mod_bcmod,
                                          sal.n_suc_bcsuc,
                                          sal.n_mda_bcmda,
                                          sal.n_pap_bcpap,
                                          sal.n_cta_bccta,
                                          sal.n_oper_bcoper,
                                          sal.n_sbop_bcsbop,
                                          sal.n_tope_bctop,
                                          ld_fecmesant),
           pq_datos_acl.fn_saldo_relacion(sal.n_emp_bcemp,
                                          sal.n_mod_bcmod,
                                          sal.n_suc_bcsuc,
                                          sal.n_mda_bcmda,
                                          sal.n_pap_bcpap,
                                          sal.n_cta_bccta,
                                          sal.n_oper_bcoper,
                                          sal.n_sbop_bcsbop,
                                          ld_fecpro,
                                          430,
                                          sal.n_rubr_bcrubr),
           pq_datos_acl.fn_saldo_relacion(sal.n_emp_bcemp,
                                          sal.n_mod_bcmod,
                                          sal.n_suc_bcsuc,
                                          sal.n_mda_bcmda,
                                          sal.n_pap_bcpap,
                                          sal.n_cta_bccta,
                                          sal.n_oper_bcoper,
                                          sal.n_sbop_bcsbop,
                                          ld_fecpro,
                                          430,
                                          sal.n_rubr_bcrubr) +
           sal.N_SALCAP_BCSDMO,
           pq_datos_acl.fn_saldo_relacion(sal.n_emp_bcemp,
                                          sal.n_mod_bcmod,
                                          sal.n_suc_bcsuc,
                                          sal.n_mda_bcmda,
                                          sal.n_pap_bcpap,
                                          sal.n_cta_bccta,
                                          sal.n_oper_bcoper,
                                          sal.n_sbop_bcsbop,
                                          ld_fecpro,
                                          18,
                                          sal.n_rubr_bcrubr),
           pq_datos_acl.fn_saldo_relacion(sal.n_emp_bcemp,
                                          sal.n_mod_bcmod,
                                          sal.n_suc_bcsuc,
                                          sal.n_mda_bcmda,
                                          sal.n_pap_bcpap,
                                          sal.n_cta_bccta,
                                          sal.n_oper_bcoper,
                                          sal.n_sbop_bcsbop,
                                          ld_fecpro,
                                          18,
                                          sal.n_rubr_bcrubr),
           pq_datos_acl.fn_saldo_relacion(sal.n_emp_bcemp,
                                          sal.n_mod_bcmod,
                                          sal.n_suc_bcsuc,
                                          sal.n_mda_bcmda,
                                          sal.n_pap_bcpap,
                                          sal.n_cta_bccta,
                                          sal.n_oper_bcoper,
                                          sal.n_sbop_bcsbop,
                                          ld_fecpro,
                                          98,
                                          sal.n_rubr_bcrubr),
           sal.N_SALCAP_BCSDMO,
           (select tpnro
              from fst098
             where tpcod = 7647
               and tpcorr = 12),
           pq_datos_acl.fn_dias_atraso(ld_fecpro, --se cambio para llamar a la funcion de dias de atraso 
                          sal.n_emp_bcemp,
                          sal.n_mod_bcmod,
                          sal.n_suc_bcsuc,
                          sal.n_mda_bcmda,
                          sal.n_pap_bcpap,
                          sal.n_cta_bccta,
                          sal.n_oper_bcoper,
                          sal.n_sbop_bcsbop,
                          sal.n_tope_bctop,
                          0,
                          sal.D_FECVEN_BCFVTO),
           pq_datos_ACL.fn_negocio(cta.pepais, cta.petdoc, cta.pendoc),
           pq_datos_ACL.fn_cod_activ(cta.pepais, cta.petdoc, cta.pendoc),
           fn_instancia_credito(sal.n_mod_bcmod,
                                sal.n_suc_bcsuc,
                                sal.n_mda_bcmda,
                                sal.n_pap_bcpap,
                                sal.n_cta_bccta,
                                sal.n_oper_bcoper,
                                sal.n_sbop_bcsbop,
                                sal.n_tope_bctop),
           sal.D_FECPRO_BCFECH,
           sal.N_SALMN_BCSDMN,
           pq_datos_acl.Fn_cliente_corp(cta.pepais, cta.petdoc, cta.pendoc),
           -- mod 2021.01.07 dcastro FONDOS
           pq_datos_acl.fn_por_fondo(sal.n_cta_bccta,sal.n_oper_bcoper, ld_fecpro),
           pq_datos_acl.fn_ind_fondo(sal.n_cta_bccta,sal.n_oper_bcoper, ld_fecpro),
           -- mod 2021.01.07 dcastro
           pq_datos_ACL.fn_Fec_Proximo_vto_bdc(sal.n_emp_bcemp,
                                               sal.n_mod_bcmod,
                                               sal.n_suc_bcsuc,
                                               sal.n_mda_bcmda,
                                               sal.n_pap_bcpap,
                                               sal.n_cta_bccta,
                                               sal.n_oper_bcoper,
                                               sal.n_sbop_bcsbop,
                                               sal.n_tope_bctop,
                                               ld_fecpro) --17/10/2021 YYAMPI
            from UAI_ACLPROCN sal, fsr008 cta, fsd010 pre
           where sal.n_emp_bcemp = 1
             and sal.n_suc_bcsuc = pn_numsuc
             and sal.d_fecpro_bcfech = ld_fecpro
             and sal.n_rubr_bcrubr = i.rubro
             and sal.n_cta_bccta = cta.ctnro
             and cta.pgcod = 1
             and cta.cttfir = 'T'
             and sal.n_emp_bcemp = pre.pgcod(+)
             and sal.n_mod_bcmod = pre.aomod(+)
             and sal.n_suc_bcsuc = pre.aosuc(+)
             and sal.n_mda_bcmda = pre.aomda(+)
             and sal.n_pap_bcpap = pre.aopap(+)
             and sal.n_cta_bccta = pre.aocta(+)
             and sal.n_oper_bcoper = pre.aooper(+)
             and sal.n_sbop_bcsbop = pre.aosbop(+)
             and sal.n_tope_bctop = pre.aotope(+)
          
          ;
      exception
        when others then
          lc_coderr := sqlerrm;
          INSERT INTO LOG_ERROR_BANDEJA
            (N_NRO, C_CODBDJ, C_DESERR, D_FECERR)
          VALUES
            (0, 'ACL', i.rubro || lc_coderr, TRUNC(SYSDATE));
          COMMIT;
      end;
      commit;
    end loop;
    commit;
    update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 = pn_numsuc
       and g.c_codage = 'ACL';
    commit;
  EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm, 1, 200);
      update tab_jobs g
         set g.c_inderr = 'S', g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'ACL';
      commit;
      return;
    
  end sp_acl_datos;

  function fn_rubro_anterior(pn_emp       in number,
                             pn_mod       in number,
                             pn_suc       in number,
                             pn_mda       in number,
                             pn_pap       in number,
                             pn_cta       in number,
                             pn_oper      in number,
                             pn_sbop      in number,
                             pn_top       in number,
                             pd_fecmesant in date) return number is
    ln_rubro number;
  
  begin
    begin
      --    select /*+ parallel(n,2,1)*/
      select /*+index(n FSH01204)*/
       n.BCRUBR
        into ln_rubro
        from fsh012 n
       where n.BCEMP = pn_emp
         and n.BCCTA = pn_cta
         and n.BCMDA = pn_mda
         and n.BCSUC = pn_suc
         and n.bcpap = pn_pap
         and n.bcoper = pn_oper
         and n.bcsbop = pn_sbop
         and n.bctop = pn_top
         and n.bcmod = pn_mod
         and n.BCFECH = pd_fecmesant;
    exception
      when no_data_found then
        ln_rubro := null;
      when too_many_rows then
        ln_rubro := null;
    end;
  
    return ln_rubro;
  end fn_rubro_anterior;

  function fn_Fec_Proximo_vto(pn_emp    in number,
                              pn_mod    in number,
                              pn_suc    in number,
                              pn_mda    in number,
                              pn_pap    in number,
                              pn_cta    in number,
                              pn_oper   in number,
                              pn_sbop   in number,
                              pn_top    in number,
                              pd_fecpro in date) return date is
    ld_fecpxv date;
  begin
    begin
      --    select /*+ parallel(n,2,1)*/
      select /*+index(n FSD60107)*/
       min(n.ppfpag)
        into ld_fecpxv
        from fsd601 n
       where n.pgcod = pn_emp
         and n.ppcta = pn_cta
         and n.ppmda = pn_mda
         and n.ppsuc = pn_suc
         and n.pppap = pn_pap
         and n.ppoper = pn_oper
         and n.ppsbop = pn_sbop
         and n.pptope = pn_top
         and n.ppmod = pn_mod
         and n.d601co = 'S'
         and (n.ppcap + n.ppint) <> 0
         and not exists
      --                (select /*+ parallel(o,2,1)*/  ppmod, ppcta,ppoper, pptope,ppfpag
       (select /*+index(o SYS_C00978743)*/
               ppmod, ppcta, ppoper, pptope, ppfpag
                from fsd602 o
               where o.pgcod = n.pgcod
                 and o.ppmod = n.ppmod
                 and o.ppsuc = n.ppsuc
                 and o.ppmda = n.ppmda
                 and o.pppap = n.pppap
                 and o.ppcta = n.ppcta
                 and o.ppoper = n.ppoper
                 and o.ppsbop = n.ppsbop
                 and o.pptope = n.pptope
                 and o.ppfpag = n.ppfpag
                    --and o.ppfpag  <= pd_fecpro
                 and o.pp1fech <= pd_fecpro
                 and o.pp1stat = 'T'
                 and o.d602co = 'S'
                 and (o.pp1cap + o.pp1int) <> 0);
    exception
      when no_data_found then
        ld_fecpxv := null;
      when too_many_rows then
        ld_fecpxv := null;
    end;
    return ld_fecpxv;
  end fn_Fec_Proximo_vto;

-----------------------------------------------------------------------------------------------

  function fn_Fec_Proximo_vto_bdc(pn_emp    in number,
                                  pn_mod    in number,
                                  pn_suc    in number,
                                  pn_mda    in number,
                                  pn_pap    in number,
                                  pn_cta    in number,
                                  pn_oper   in number,
                                  pn_sbop   in number,
                                  pn_top    in number,
                                  pd_fecpro in date) return date is                                  
 -- *****************************************************************
    -- Nombre                     : fn_Fec_Proximo_vto_bdc
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 19/10/2021
    -- Autor de Creación          : YYAMPI
    -- Uso                        : Retorna la fecha de proximo vecimiento del backup
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 
    -- *****************************************************************
                                     
    ld_fecpxv date;
  begin
    begin
      --    select /*+ parallel(n,2,1)*/
      select /*+index(n AQPB8771)*/
       min(n.ppfpag)
        into ld_fecpxv
        from AQPB877 n --fsd601 n
       where n.pgcod = pn_emp
         and n.ppcta = pn_cta
         and n.ppmda = pn_mda
         and n.ppsuc = pn_suc
         and n.pppap = pn_pap
         and n.ppoper = pn_oper
         and n.ppsbop = pn_sbop
         and n.pptope = pn_top
         and n.ppmod = pn_mod
         and n.d601co = 'S'
         and (n.ppcap + n.ppint) <> 0
         and not exists
      --                (select /*+ parallel(o,2,1)*/  ppmod, ppcta,ppoper, pptope,ppfpag
       (select /*+index(o AQPB8781)*/
               ppmod, ppcta, ppoper, pptope, ppfpag
                from AQPB878 o --fsd602 o
               where o.pgcod = n.pgcod
                 and o.ppmod = n.ppmod
                 and o.ppsuc = n.ppsuc
                 and o.ppmda = n.ppmda
                 and o.pppap = n.pppap
                 and o.ppcta = n.ppcta
                 and o.ppoper = n.ppoper
                 and o.ppsbop = n.ppsbop
                 and o.pptope = n.pptope
                 and o.ppfpag = n.ppfpag
                    --and o.ppfpag  <= pd_fecpro
                 and o.pp1fech <= pd_fecpro
                 and o.pp1stat = 'T'
                 and o.d602co = 'S'
                 and (o.pp1cap + o.pp1int) <> 0);
    exception
      when no_data_found then
        ld_fecpxv := null;
      when too_many_rows then
        ld_fecpxv := null;
    end;
    return ld_fecpxv;
  end fn_Fec_Proximo_vto_bdc;

--------------------------------------------------------------------------------------------

  function fn_Interes_Proximo_vto(pn_emp    in number,
                                  pn_mod    in number,
                                  pn_suc    in number,
                                  pn_mda    in number,
                                  pn_pap    in number,
                                  pn_cta    in number,
                                  pn_oper   in number,
                                  pn_sbop   in number,
                                  pn_top    in number,
                                  pd_fecpro in date) return number is
    ln_interes number;
    ld_fecpxv  date;
  begin
    begin
      select /*+ parallel(n,2,1)*/
       min(n.ppfpag)
        into ld_fecpxv
        from fsd601 n
       where n.pgcod = pn_emp
         and n.ppcta = pn_cta
         and n.ppmda = pn_mda
         and n.ppsuc = pn_suc
         and n.pppap = pn_pap
         and n.ppoper = pn_oper
         and n.ppsbop = pn_sbop
         and n.pptope = pn_top
         and n.ppmod = pn_mod
         and n.d601co = 'S'
         and (n.ppcap + n.ppint) <> 0
         and not exists (select /*+ parallel(o,2,1)*/
               ppmod, ppcta, ppoper, pptope, ppfpag
                from fsd602 o
               where o.pgcod = n.pgcod
                 and o.ppmod = n.ppmod
                 and o.ppsuc = n.ppsuc
                 and o.ppmda = n.ppmda
                 and o.pppap = n.pppap
                 and o.ppcta = n.ppcta
                 and o.ppoper = n.ppoper
                 and o.ppsbop = n.ppsbop
                 and o.pptope = n.pptope
                 and o.ppfpag = n.ppfpag
                    --and o.ppfpag  <= pd_fecpro
                 and o.pp1fech <= pd_fecpro
                 and o.pp1stat = 'T'
                 and o.d602co = 'S'
                 and (o.pp1cap + o.pp1int) <> 0);
    exception
      when no_data_found then
        ld_fecpxv := null;
      when too_many_rows then
        ld_fecpxv := null;
    end;
  
    begin
      select /*+ parallel(n,2,1)*/
       n.ppint
        into ln_interes
        from fsd601 n
       where n.pgcod = pn_emp
         and n.ppcta = pn_cta
         and n.ppmda = pn_mda
         and n.ppsuc = pn_suc
         and n.pppap = pn_pap
         and n.ppoper = pn_oper
         and n.ppsbop = pn_sbop
         and n.pptope = pn_top
         and n.ppmod = pn_mod
         and n.ppfpag = ld_fecpxv
         and n.d601co = 'S';
    exception
      when no_data_found then
        ln_interes := null;
      when too_many_rows then
        ln_interes := null;
    end;
  
    return ln_interes;
  end fn_Interes_Proximo_vto;

  function fn_cuotas_pagadas(pn_emp    in number,
                             pn_mod    in number,
                             pn_suc    in number,
                             pn_mda    in number,
                             pn_pap    in number,
                             pn_cta    in number,
                             pn_oper   in number,
                             pn_sbop   in number,
                             pn_top    in number,
                             pd_fecpro in date) return number is
    ln_numcuotas number;
  begin
    begin
      --    select /*+ parallel(o,2,1)*/
      select /*+index(o SYS_C00978743)*/
       sum(count(*))
        into ln_numcuotas
        from fsd602 o
       where o.pgcod = pn_emp
         and o.ppmod = pn_mod
         and o.ppsuc = pn_suc
         and o.ppmda = pn_mda
         and o.pppap = pn_pap
         and o.ppcta = pn_cta
         and o.ppoper = pn_oper
         and o.ppsbop = pn_sbop
         and o.pptope = pn_top
         and o.pp1fech <= pd_fecpro
         and o.pp1stat = 'T'
         and o.d602co = 'S'
         and (o.pp1cap + o.pp1int) <> 0
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

  function fn_monto_pagado(pn_emp    in number,
                           pn_mod    in number,
                           pn_suc    in number,
                           pn_mda    in number,
                           pn_pap    in number,
                           pn_cta    in number,
                           pn_oper   in number,
                           pn_sbop   in number,
                           pn_top    in number,
                           pd_fecpro in date) return number is
    ln_mto_pagado number;
    ld_fecpxv     date;
  begin
    begin
      select /*+ parallel(n,2,1)*/
       min(n.ppfpag)
        into ld_fecpxv
        from fsd601 n
       where n.pgcod = pn_emp
         and n.ppcta = pn_cta
         and n.ppmda = pn_mda
         and n.ppsuc = pn_suc
         and n.pppap = pn_pap
         and n.ppoper = pn_oper
         and n.ppsbop = pn_sbop
         and n.pptope = pn_top
         and n.ppmod = pn_mod
         and n.d601co = 'S'
         and (n.ppcap + n.ppint) <> 0
         and not exists (select /*+ parallel(o,2,1)*/
               ppmod, ppcta, ppoper, pptope, ppfpag
                from fsd602 o
               where o.pgcod = n.pgcod
                 and o.ppmod = n.ppmod
                 and o.ppsuc = n.ppsuc
                 and o.ppmda = n.ppmda
                 and o.pppap = n.pppap
                 and o.ppcta = n.ppcta
                 and o.ppoper = n.ppoper
                 and o.ppsbop = n.ppsbop
                 and o.pptope = n.pptope
                 and o.ppfpag = n.ppfpag
                    --and o.ppfpag  <= pd_fecpro
                 and o.pp1fech <= pd_fecpro
                 and o.pp1stat = 'T'
                 and o.d602co = 'S'
                 and (o.pp1cap + o.pp1int) <> 0);
    exception
      when no_data_found then
        ld_fecpxv := null;
      when too_many_rows then
        ld_fecpxv := null;
    end;
  
    begin
      select /*+ parallel(n,2,1)*/
       n.ppcap
        into ln_mto_pagado
        from fsd601 n
       where n.pgcod = pn_emp
         and n.ppcta = pn_cta
         and n.ppmda = pn_mda
         and n.ppsuc = pn_suc
         and n.pppap = pn_pap
         and n.ppoper = pn_oper
         and n.ppsbop = pn_sbop
         and n.pptope = pn_top
         and n.ppmod = pn_mod
         and n.ppfpag = ld_fecpxv
         and n.d601co = 'S';
    exception
      when no_data_found then
        ln_mto_pagado := null;
      when too_many_rows then
        ln_mto_pagado := null;
    end;
    return ln_mto_pagado;
  end fn_monto_pagado;

  function fn_Fec_Ultimo_pago(pn_emp    in number,
                              pn_mod    in number,
                              pn_suc    in number,
                              pn_mda    in number,
                              pn_pap    in number,
                              pn_cta    in number,
                              pn_oper   in number,
                              pn_sbop   in number,
                              pn_top    in number,
                              pd_fecpro in date) return date is
    ld_fecupa date;
  begin
    begin
      select /*+ parallel(o,2,1)*/
       max(o.pp1fech)
        into ld_fecupa
        from fsd602 o
       where o.pgcod = pn_emp
         and o.ppmod = pn_mod
         and o.ppsuc = pn_suc
         and o.ppmda = pn_mda
         and o.pppap = pn_pap
         and o.ppcta = pn_cta
         and o.ppoper = pn_oper
         and o.ppsbop = pn_sbop
         and o.pptope = pn_top
         and o.pp1stat = 'T'
         and o.d602co = 'S'
         and (o.pp1cap + o.pp1int) <> 0
         and o.pp1fech <= pd_fecpro;
    exception
      when no_data_found then
        ld_fecupa := null;
      when too_many_rows then
        ld_fecupa := TO_DATE('22221222', 'YYYYMMDD');
        dbms_output.put_line('ld_fecupa: ' || pn_mod || '-' || pn_suc || '-' ||
                             pn_mda || '-' || pn_cta || '-' || pn_oper || '-' ||
                             pn_sbop || '-' || pn_top);
      
    end;
    return ld_fecupa;
  end fn_Fec_Ultimo_pago;

  function fn_cod_activ(pn_pais in number,
                        pn_tdoc in number,
                        pc_ndoc in char) return number is
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
        begin
        
          select xxx.actcod1
            into ln_activi
            from sngc11 cc, fst750 xxx
           where cc.sngc11pais = pn_pais
             and cc.sngc11tdoc = pn_tdoc
             and cc.sngc11ndoc = pc_ndoc
             and cc.sngc11act2 = xxx.actcod1;
        exception
          when no_data_found then
            begin
            
              select xxx.actcod1
                into ln_activi
                from fse001 cc, fst750 xxx
               where cc.d511pais = pn_pais
                 and cc.d511tdoc = pn_tdoc
                 and cc.d511ndoc = pc_ndoc
                 and cc.expnins = xxx.actcod1;
            exception
              when others then
                ln_activi := null;
            end;
        end;
      
      when too_many_rows then
        ln_activi := -1;
    end;
    return ln_activi;
  end fn_cod_activ;

  function fn_negocio(pn_pais in number,
                      pn_tdoc in number,
                      pc_ndoc in char) return varchar2 is
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

  function fn_Saldo_relacion(pn_emp    in number,
                             pn_mod    in number,
                             pn_suc    in number,
                             pn_mda    in number,
                             pn_pap    in number,
                             pn_cta    in number,
                             pn_oper   in number,
                             pn_sbop   in number, /*pn_top in number,*/
                             pd_fecpro in date,
                             pn_nrorel in number,
                             pn_rubro  in number) return number is
    ln_saldo number;
    ln_rubro number;
  begin
    begin
      if pn_nrorel = 35 or pn_nrorel = 635 or pn_nrorel = 35 or
         pn_nrorel = 735 then
      
        if pn_mod = 117 then
          begin
          
            select re.rrrubr
              into ln_rubro
              from fsr014 re
             where re.rubro = pn_rubro
               and re.rrcod = 18;
          exception
            when others then
              ln_rubro := null;
          end;
        
          begin
            select s.bcsdmo
              into ln_saldo
              from fsr014 r, fsh012 s
             where s.bcemp = pn_emp
               and s.bcsuc = pn_suc
               and r.rubro = ln_rubro
               and r.rrrubr = s.bcrubr
               and r.rrcod = pn_nrorel
               and s.bcmda = pn_mda
               and s.bcpap = pn_pap
               and s.bccta = pn_cta
               and s.bcoper = pn_oper
               and s.bcsbop = pn_sbop
                  --and s.bcmod = pn_mod
                  --and s.bctop = pn_top
               and s.bcfech = pd_fecpro;
          exception
            when others then
              ln_saldo := NULL;
          end;
        
        else
        
          begin
            select s.bcsdmo
              into ln_saldo
              from fsr014 r, fsh012 s
             where s.bcemp = pn_emp
               and s.bcsuc = pn_suc
               and r.rubro = pn_rubro
               and r.rrrubr = s.bcrubr
               and r.rrcod = pn_nrorel
               and s.bcmda = pn_mda
               and s.bcpap = pn_pap
               and s.bccta = pn_cta
               and s.bcoper = pn_oper
               and s.bcsbop = pn_sbop
                  --and s.bcmod = pn_mod
                  --and s.bctop = pn_top
               and s.bcfech = pd_fecpro;
          exception
            when others then
              ln_saldo := NULL;
          end;
        end if;
      
      else
        if pn_nrorel = 430 then
          begin
            select s.bcsdmo
              into ln_saldo
              from fsr014 r, fsh012 s
             where s.bcemp = pn_emp
               and s.bcsuc = pn_suc
               and r.rubro = pn_rubro
               and r.rrrubr = s.bcrubr
               and r.rrcod = pn_nrorel
               and s.bcmda = pn_mda
               and s.bcpap = pn_pap
               and s.bccta = pn_cta
               and s.bcoper = pn_oper
               and s.bcsbop = pn_sbop
                  --and s.bcmod = pn_mod
                  --and s.bctop = pn_top
               and s.bcfech = pd_fecpro;
          exception
            when others then
              ln_saldo := NULL;
          end;
          if ln_saldo is null then
            begin
              select s.bcsdmo
                into ln_saldo
                from fsr014 r, fsh012 s
               where s.bcemp = pn_emp
                 and s.bcsuc = pn_suc
                 and r.rubro = pn_rubro
                 and r.rrrubr = s.bcrubr
                 and r.rrcod = 330
                 and s.bcmda = pn_mda
                 and s.bcpap = pn_pap
                 and s.bccta = pn_cta
                 and s.bcoper = pn_oper
                 and s.bcsbop = pn_sbop
                    --and s.bcmod = pn_mod
                    --and s.bctop = pn_top
                 and s.bcfech = pd_fecpro;
            exception
              when others then
                ln_saldo := NULL;
            end;
          end if;
        
        else
          begin
            select s.bcsdmo
              into ln_saldo
              from fsr014 r, fsh012 s
             where s.bcemp = pn_emp
               and s.bcsuc = pn_suc
               and r.rubro = pn_rubro
               and r.rrrubr = s.bcrubr
               and r.rrcod = pn_nrorel
               and s.bcmda = pn_mda
               and s.bcpap = pn_pap
               and s.bccta = pn_cta
               and s.bcoper = pn_oper
               and s.bcsbop = pn_sbop
                  --and s.bcmod = pn_mod
                  --and s.bctop = pn_top
               and s.bcfech = pd_fecpro;
          exception
            when others then
              ln_saldo := NULL;
          end;
        
        end if;
      end if;
    end;
    return ln_saldo;
  end fn_Saldo_relacion;

  function fn_MtoLinea(pn_emp  in number,
                       pn_mod  in number,
                       pn_suc  in number,
                       pn_mda  in number,
                       pn_pap  in number,
                       pn_cta  in number,
                       pn_oper in number,
                       pn_sbop in number,
                       pn_top  in number,
                       pn_rel  in number) return number is
    ln_saldo number(17, 2);
    ln_cod   number(3);
    ln_mod   number(3);
    ln_suc   number(3);
    ln_mda   number(4);
    ln_pap   number(4);
    ln_cta   number(9);
    ln_ope   number(9);
    ln_sbo   number(3);
    ln_top   number(3);
  
  begin
  
    begin
    
      if pn_mod = 116 then
      
        begin
          select s.r2cod,
                 s.r2mod,
                 s.r2suc,
                 s.r2mda,
                 s.r2pap,
                 s.r2cta,
                 s.r2oper,
                 s.r2sbop,
                 s.r2tope
            into ln_cod,
                 ln_mod,
                 ln_suc,
                 ln_mda,
                 ln_pap,
                 ln_cta,
                 ln_ope,
                 ln_sbo,
                 ln_top
            from fsr011 s
           where s.r1cod = pn_emp
             and s.r1mod = pn_mod
             and s.r1suc = pn_suc
             and s.r1mda = pn_mda
             and s.r1pap = pn_pap
             and s.r1cta = pn_cta
             and s.r1oper = pn_oper
             and s.r1sbop = pn_sbop
             and s.r1tope = pn_top
             and s.relcod = pn_rel;
        exception
          when no_data_found then
            begin
              select s.r2cod,
                     s.r2mod,
                     s.r2suc,
                     s.r2mda,
                     s.r2pap,
                     s.r2cta,
                     s.r2oper,
                     s.r2sbop,
                     s.r2tope
                into ln_cod,
                     ln_mod,
                     ln_suc,
                     ln_mda,
                     ln_pap,
                     ln_cta,
                     ln_ope,
                     ln_sbo,
                     ln_top
                from fsr011 s
               where s.r1cod = pn_emp
                 and s.r1mod = pn_mod
                 and s.r1suc = pn_suc
                 and s.r1mda = pn_mda
                 and s.r1pap = pn_pap
                 and s.r1cta = pn_cta
                 and s.r1oper = pn_oper
                    --and s.r1sbop = pn_sbop
                    --and s.r1tope = pn_top
                 and s.relcod = pn_rel;
            exception
              when too_many_rows then
                begin
                  select s.r2cod,
                         s.r2mod,
                         s.r2suc,
                         s.r2mda,
                         s.r2pap,
                         s.r2cta,
                         s.r2oper,
                         s.r2sbop,
                         s.r2tope
                    into ln_cod,
                         ln_mod,
                         ln_suc,
                         ln_mda,
                         ln_pap,
                         ln_cta,
                         ln_ope,
                         ln_sbo,
                         ln_top
                    from fsr011 s
                   where s.r1cod = pn_emp
                     and s.r1mod = pn_mod
                     and s.r1suc = pn_suc
                     and s.r1mda = pn_mda
                     and s.r1pap = pn_pap
                     and s.r1cta = pn_cta
                     and s.r1oper = pn_oper
                        --and s.r1sbop = pn_sbop
                        --and s.r1tope = pn_top
                     and s.relcod = pn_rel
                     and rownum = 1;
                exception
                  when others then
                    ln_cod := null;
                    ln_mod := null;
                    ln_suc := null;
                    ln_mda := null;
                    ln_pap := null;
                    ln_cta := null;
                    ln_ope := null;
                    ln_sbo := null;
                    ln_top := NULL;
                end;
              
              when others then
                ln_cod := null;
                ln_mod := null;
                ln_suc := null;
                ln_mda := null;
                ln_pap := null;
                ln_cta := null;
                ln_ope := null;
                ln_sbo := null;
                ln_top := NULL;
            end;
          when too_many_rows then
          
            begin
              select s.r2cod,
                     s.r2mod,
                     s.r2suc,
                     s.r2mda,
                     s.r2pap,
                     s.r2cta,
                     s.r2oper,
                     s.r2sbop,
                     s.r2tope
                into ln_cod,
                     ln_mod,
                     ln_suc,
                     ln_mda,
                     ln_pap,
                     ln_cta,
                     ln_ope,
                     ln_sbo,
                     ln_top
                from fsr011 s
               where s.r1cod = pn_emp
                 and s.r1mod = pn_mod
                 and s.r1suc = pn_suc
                 and s.r1mda = pn_mda
                 and s.r1pap = pn_pap
                 and s.r1cta = pn_cta
                 and s.r1oper = pn_oper
                 and s.r1sbop = pn_sbop
                 and s.r1tope = pn_top
                 and s.relcod = pn_rel
                 and rownum = 1;
            exception
              when others then
                ln_cod := null;
                ln_mod := null;
                ln_suc := null;
                ln_mda := null;
                ln_pap := null;
                ln_cta := null;
                ln_ope := null;
                ln_sbo := null;
                ln_top := NULL;
            end;
          when others then
            ln_cod := null;
            ln_mod := null;
            ln_suc := null;
            ln_mda := null;
            ln_pap := null;
            ln_cta := null;
            ln_ope := null;
            ln_sbo := null;
            ln_top := NULL;
        end;
      
        begin
        
          select aoimp
            into ln_saldo
            from fsd010
           where pgcod = ln_cod
             and aomod = ln_mod
             and aosuc = ln_suc
             and aomda = ln_mda
             and aopap = ln_pap
             and aocta = ln_cta
             and aooper = ln_ope
             and aosbop = ln_sbo
             and aotope = ln_top;
        exception
          when others then
            ln_saldo := null;
        end;
      
      else
        ln_saldo := null;
      end if;
    end;
    return ln_saldo;
  end fn_MtoLinea;

  function fn_MtoDisp_Hist(pn_emp    in number,
                           pn_mod    in number,
                           pn_suc    in number,
                           pn_mda    in number,
                           pn_pap    in number,
                           pn_cta    in number,
                           pn_oper   in number,
                           pn_sbop   in number,
                           pn_top    in number,
                           pd_fecpro in date,
                           pn_rel    in number) return number is
    ln_saldo number(17, 2);
    ln_cod   number(3);
    ln_mod   number(3);
    ln_suc   number(3);
    ln_mda   number(4);
    ln_pap   number(4);
    ln_cta   number(9);
    ln_ope   number(9);
    ln_sbo   number(3);
    ln_top   number(3);
  
  begin
    begin
      if pn_mod = 116 then
      
        begin
          select s.r2cod,
                 s.r2mod,
                 s.r2suc,
                 s.r2mda,
                 s.r2pap,
                 s.r2cta,
                 s.r2oper,
                 s.r2sbop,
                 s.r2tope
            into ln_cod,
                 ln_mod,
                 ln_suc,
                 ln_mda,
                 ln_pap,
                 ln_cta,
                 ln_ope,
                 ln_sbo,
                 ln_top
            from fsr011 s
           where s.r1cod = pn_emp
             and s.r1mod = pn_mod
             and s.r1suc = pn_suc
             and s.r1mda = pn_mda
             and s.r1pap = pn_pap
             and s.r1cta = pn_cta
             and s.r1oper = pn_oper
             and s.r1sbop = pn_sbop
             and s.r1tope = pn_top
             and s.relcod = pn_rel;
        exception
          when no_data_found then
            begin
              select s.r2cod,
                     s.r2mod,
                     s.r2suc,
                     s.r2mda,
                     s.r2pap,
                     s.r2cta,
                     s.r2oper,
                     s.r2sbop,
                     s.r2tope
                into ln_cod,
                     ln_mod,
                     ln_suc,
                     ln_mda,
                     ln_pap,
                     ln_cta,
                     ln_ope,
                     ln_sbo,
                     ln_top
                from fsr011 s
               where s.r1cod = pn_emp
                 and s.r1mod = pn_mod
                 and s.r1suc = pn_suc
                 and s.r1mda = pn_mda
                 and s.r1pap = pn_pap
                 and s.r1cta = pn_cta
                 and s.r1oper = pn_oper
                    --and s.r1sbop = pn_sbop
                    --and s.r1tope = pn_top
                 and s.relcod = pn_rel;
            exception
              when too_many_rows then
                begin
                  select s.r2cod,
                         s.r2mod,
                         s.r2suc,
                         s.r2mda,
                         s.r2pap,
                         s.r2cta,
                         s.r2oper,
                         s.r2sbop,
                         s.r2tope
                    into ln_cod,
                         ln_mod,
                         ln_suc,
                         ln_mda,
                         ln_pap,
                         ln_cta,
                         ln_ope,
                         ln_sbo,
                         ln_top
                    from fsr011 s
                   where s.r1cod = pn_emp
                     and s.r1mod = pn_mod
                     and s.r1suc = pn_suc
                     and s.r1mda = pn_mda
                     and s.r1pap = pn_pap
                     and s.r1cta = pn_cta
                     and s.r1oper = pn_oper
                        --and s.r1sbop = pn_sbop
                        --and s.r1tope = pn_top
                     and s.relcod = pn_rel
                     and rownum = 1;
                exception
                  when others then
                    ln_cod := null;
                    ln_mod := null;
                    ln_suc := null;
                    ln_mda := null;
                    ln_pap := null;
                    ln_cta := null;
                    ln_ope := null;
                    ln_sbo := null;
                    ln_top := NULL;
                end;
              
              when others then
                ln_cod := null;
                ln_mod := null;
                ln_suc := null;
                ln_mda := null;
                ln_pap := null;
                ln_cta := null;
                ln_ope := null;
                ln_sbo := null;
                ln_top := NULL;
            end;
          when too_many_rows then
          
            begin
              select s.r2cod,
                     s.r2mod,
                     s.r2suc,
                     s.r2mda,
                     s.r2pap,
                     s.r2cta,
                     s.r2oper,
                     s.r2sbop,
                     s.r2tope
                into ln_cod,
                     ln_mod,
                     ln_suc,
                     ln_mda,
                     ln_pap,
                     ln_cta,
                     ln_ope,
                     ln_sbo,
                     ln_top
                from fsr011 s
               where s.r1cod = pn_emp
                 and s.r1mod = pn_mod
                 and s.r1suc = pn_suc
                 and s.r1mda = pn_mda
                 and s.r1pap = pn_pap
                 and s.r1cta = pn_cta
                 and s.r1oper = pn_oper
                 and s.r1sbop = pn_sbop
                 and s.r1tope = pn_top
                 and s.relcod = pn_rel
                 and rownum = 1;
            exception
              when others then
                ln_cod := null;
                ln_mod := null;
                ln_suc := null;
                ln_mda := null;
                ln_pap := null;
                ln_cta := null;
                ln_ope := null;
                ln_sbo := null;
                ln_top := NULL;
            end;
          when others then
            ln_cod := null;
            ln_mod := null;
            ln_suc := null;
            ln_mda := null;
            ln_pap := null;
            ln_cta := null;
            ln_ope := null;
            ln_sbo := null;
            ln_top := NULL;
        end;
      
        begin
        
          select bcsdmo
            into ln_saldo
            from fsh012
           where bcemp = ln_cod
             and bcmod = ln_mod
             and bcsuc = ln_suc
             and bcmda = ln_mda
             and bcpap = ln_pap
             and bccta = ln_cta
             and bcoper = ln_ope
             and bcsbop = ln_sbo
             and bctop = ln_top
             and bcfech = pd_fecpro;
        exception
          when others then
            ln_saldo := null;
        end;
      
      else
        ln_saldo := null;
      end if;
    end;
  
    return ln_saldo;
  end fn_MtoDisp_Hist;

  Procedure sp_job_solicitud(pd_fecpro in varchar2) is
    --ln_max number;
    --ln_inc number;
    ln_ini number;
    --ln_fin number;
    i           number;
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_hostname varchar2(64);    
    ln_limit    number := 0;
    ln_numjob   number := 0;
    --lc_coderr varchar2(300);
    cursor sucursal is
      select sucurs from fst001 where pgcod = 1;
  begin
    begin
      select host_name into lc_hostname from v$instance;
    end;
    execute immediate ('truncate table UAI_ACLSOL_PRE');
    delete Tab_jobs where c_Codage = 'SOLI';
    commit;
    
    --apachecoh 2024.02.09
    --Limite de JOBS parametrizado en guia
    begin
      select tp1nro1
        into ln_limit
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11169
         and tp1corr1 = 11
         and tp1corr2 = 1
         and tp1corr3 = 1;
    exception
      when others then
        ln_limit := 20;
    end;
    
    for i in sucursal loop
      ln_ini      := i.sucurs;
      lc_variable := ' begin ' || '  pq_datos_acl.sp_solicitud_acl(' ||
                     ln_ini || ',' || '''' || Pd_FECpro || '''' || ');' ||
                     ' End; ';
      ln_job      := ln_job + 1;
      --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
      --        if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then   
      --        if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 180),
                        interval  => null,
                        no_parse  => false,
                        instance  => 1,
                       -- instance  => 2, 01/01/2024
                        force     => false);
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 180),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      end if;
      
      --apachecoh 2024.02.09  
      BEGIN
        SELECT count(*)
          INTO ln_numjob
          FROM dba_jobs x
         WHERE upper(x.what) LIKE '%PQ_DATOS_ACL.SP_SOLICITUD_ACL%';
      EXCEPTION
        WHEN OTHERS THEN
          ln_numjob := 0;
      END;
    
      WHILE ln_numjob > ln_limit LOOP
        BEGIN
          SELECT count(*)
            INTO ln_numjob
            FROM dba_jobs x
           WHERE upper(x.what) LIKE
                 '%PQ_DATOS_ACL.SP_SOLICITUD_ACL%';
        EXCEPTION
          WHEN OTHERS THEN
            ln_numjob := 0;
        END;
      END LOOP;
      
      INSERT INTO Tab_jobs
        (c_Codage, n_Numer1, c_detjob)
      VALUES
        ('SOLI', ln_ini, lc_variable);
      COMMIT;
    end loop;
  
  exception
    when others then
      --lc_coderr:=sqlerrm;
      INSERT INTO LOG_ERROR_BANDEJA
        (N_NRO, C_CODBDJ, C_DESERR, D_FECERR)
      VALUES
        (0, 'SOLI', lc_variable, TRUNC(SYSDATE));
      COMMIT;
      --          p_c_error:=  lc_variable;
  
  end sp_job_solicitud;

  Procedure sp_solicitud_acl(pn_numsuc in number, pd_fecpro in varchar2) is
  
    ld_fecpro date;
    --ld_fecant date ;
    lc_coderr varchar2(300);
    cursor rubro is
      select rubro
        from fsd014
       where (pcnivc in (select modulo
                           from fst111
                          where dscod = 50
                            and modulo not in (29, 120, 144)) --33 castigado , 200 judicial
             or pcnivc in (141, 117))
         and pcimpu = 'S'
         and pmtit <> 9;
  begin
  
    update tab_jobs g
       set g.d_fecini = sysdate
     where g.n_numer1 = pn_numsuc
       and g.c_codage = 'SOLI';
    commit;
    ld_fecpro := to_date(pd_fecpro, 'yyyymmdd');
    --ld_fecant := ADD_MONTHS(ld_fecpro,-1);
    for i in rubro loop
      begin
      
        insert into UAI_ACLSOL_PRE
          (N_EMP_BCEMP,
           N_MOD_BCMOD,
           N_SUC_BCSUC,
           N_MDA_BCMDA,
           N_PAP_BCPAP,
           N_CTA_BCCTA,
           N_OPE_BCOPER,
           N_SBOP_BCSBOP,
           N_TOPE_BCTOP,
           C_ANA_SNG001ASE,
           D_FECOSL_SNG001FIN,
           C_TIPCRED_SNG001TPCR,
           D_FECRESOL_SNG120FVAL,
           D_FECDIG_FECDIG,
           C_USUDESEM_WFITEMUSRCOD,
           C_USUDIG_WFITEMUSRCOD,
           C_TIPCAL_XLLOTEXTO,
           N_DIAGRAC,
           N_CUOTAS_XLLCANTCUO,
           N_CUOTASCAL,
           N_MTOAPR_XLLCAPITAL,
           N_VALCUO_XLLVALCUO,
           N_VAL_CALEN,
           N_INSTANCIA_XWFPRCINS,
           D_FECPRI,
           C_ANAEVAL_WFITEMUSRCOD,
           C_INDRIESG_WFATTSVAL,
           N_SHOCK_WFATTSVAL,
           N_AOIMP_MTOLINEA,
           N_MTODISP,
           N_MTO_APR,
           C_PROMOTOR,
           C_CUOPAR,
           D_FECTRAN_LIN,
           N_ORI_TIPSOL,
           C_USUAPRO,
           D_FECAPRO, --mod@abr 20170131
           C_TIPOCREDITO --mod@br 20191129                              
           )
          select distinct pre.n_emp_bcemp,
                          pre.n_mod_bcmod,
                          pre.n_suc_bcsuc,
                          pre.n_mda_bcmda,
                          pre.n_pap_bcpap,
                          pre.n_cta_bccta,
                          pre.n_oper_bcoper,
                          pre.n_sbop_bcsbop,
                          pre.n_tope_bctop,
                          fn_analista_credito(pre.n_mod_bcmod,
                                              pre.n_suc_bcsuc,
                                              pre.n_mda_bcmda,
                                              pre.n_pap_bcpap,
                                              pre.n_cta_bccta,
                                              pre.n_oper_bcoper,
                                              pre.n_sbop_bcsbop,
                                              pre.n_tope_bctop) analista,
                          pq_datos_acl.fn_fec_solitud(pre.n_instancia_xwfprcins) solicitud,
                          pq_datos_acl.fn_tip_credito(pre.n_instancia_xwfprcins,
                                                      pre.n_pais_pepais,
                                                      pre.n_tdoc_petdoc,
                                                      pre.c_ndoc_pendoc,
                                                      pre.n_mod_bcmod) tipcre,
                          pq_datos_acl.fn_fec_resolucion(pre.n_instancia_xwfprcins) fecres,
                          pq_datos_acl.fn_fec_digitacion(pre.n_instancia_xwfprcins) fecdig,
                          pq_datos_acl.fn_usu_desembolso(pre.n_instancia_xwfprcins) usudes,
                          pq_datos_acl.fn_usu_digitacion(pre.n_instancia_xwfprcins) usudig,
                          pq_datos_acl.fn_tip_calen(pre.n_emp_bcemp,
                                                    pre.n_mod_bcmod,
                                                    pre.n_suc_bcsuc,
                                                    pre.n_mda_bcmda,
                                                    pre.n_pap_bcpap,
                                                    pre.n_cta_bccta,
                                                    pre.n_oper_bcoper,
                                                    pre.n_sbop_bcsbop,
                                                    pre.n_tope_bctop) tipcal,
                          pq_datos_acl.fn_dias_gracia(pre.n_emp_bcemp,
                                                      pre.n_mod_bcmod,
                                                      pre.n_suc_bcsuc,
                                                      pre.n_mda_bcmda,
                                                      pre.n_pap_bcpap,
                                                      pre.n_cta_bccta,
                                                      pre.n_oper_bcoper,
                                                      pre.n_sbop_bcsbop,
                                                      pre.n_tope_bctop) diagra,
                          pq_datos_acl.fn_nro_cuotas(pre.n_emp_bcemp,
                                                     pre.n_mod_bcmod,
                                                     pre.n_suc_bcsuc,
                                                     pre.n_mda_bcmda,
                                                     pre.n_pap_bcpap,
                                                     pre.n_cta_bccta,
                                                     pre.n_oper_bcoper,
                                                     pre.n_sbop_bcsbop,
                                                     pre.n_tope_bctop) numcuo,
                          pq_datos_acl.fn_cuotas_calen(pre.n_emp_bcemp,
                                                       pre.n_mod_bcmod,
                                                       pre.n_suc_bcsuc,
                                                       pre.n_mda_bcmda,
                                                       pre.n_pap_bcpap,
                                                       pre.n_cta_bccta,
                                                       pre.n_oper_bcoper,
                                                       pre.n_sbop_bcsbop,
                                                       pre.n_tope_bctop) cuocal,
                          pq_datos_acl.fn_mto_aprobado(pre.n_emp_bcemp,
                                                       pre.n_mod_bcmod,
                                                       pre.n_suc_bcsuc,
                                                       pre.n_mda_bcmda,
                                                       pre.n_pap_bcpap,
                                                       pre.n_cta_bccta,
                                                       pre.n_oper_bcoper,
                                                       pre.n_sbop_bcsbop,
                                                       pre.n_tope_bctop,
                                                       pre.n_mtodes_aoimp) mtoapr,
                          pq_datos_acl.fn_valor_cuotas(pre.n_instancia_xwfprcins,
                                                       pre.n_cta_bccta) valcuo,
                          pq_datos_acl.fn_valor_cuota_impaga(pre.n_emp_bcemp,
                                                             pre.n_mod_bcmod,
                                                             pre.n_suc_bcsuc,
                                                             pre.n_mda_bcmda,
                                                             pre.n_pap_bcpap,
                                                             pre.n_cta_bccta,
                                                             pre.n_oper_bcoper,
                                                             pre.n_sbop_bcsbop,
                                                             pre.n_tope_bctop,
                                                             ld_fecpro) cuoimp,
                          pre.n_instancia_xwfprcins,
                          pq_datos_acl.fn_primer_pago(pre.n_emp_bcemp,
                                                      pre.n_mod_bcmod,
                                                      pre.n_suc_bcsuc,
                                                      pre.n_mda_bcmda,
                                                      pre.n_pap_bcpap,
                                                      pre.n_cta_bccta,
                                                      pre.n_oper_bcoper,
                                                      pre.n_sbop_bcsbop,
                                                      pre.n_tope_bctop,
                                                      ld_fecpro) primpa,
                          pq_datos_acl.fn_usu_evaluacion(pre.n_instancia_xwfprcins) usueva,
                          pq_datos_acl.fn_ind_riesgo_camb(pre.n_instancia_xwfprcins) riesgo,
                          pq_datos_acl.fn_shock_camb(pre.n_instancia_xwfprcins) shock,
                          pq_datos_acl.fn_MtoLinea(pre.n_emp_bcemp,
                                                   pre.n_mod_bcmod,
                                                   pre.n_suc_bcsuc,
                                                   pre.n_mda_bcmda,
                                                   pre.n_pap_bcpap,
                                                   pre.n_cta_bccta,
                                                   pre.n_oper_bcoper,
                                                   pre.n_sbop_bcsbop,
                                                   pre.n_tope_bctop,
                                                   46),
                          
                          pq_datos_acl.fn_MtoDisp_Hist(pre.n_emp_bcemp,
                                                       pre.n_mod_bcmod,
                                                       pre.n_suc_bcsuc,
                                                       pre.n_mda_bcmda,
                                                       pre.n_pap_bcpap,
                                                       pre.n_cta_bccta,
                                                       pre.n_oper_bcoper,
                                                       pre.n_sbop_bcsbop,
                                                       pre.n_tope_bctop,
                                                       ld_fecpro,
                                                       4),
                          pq_datos_acl.Fn_monto_aprobado(pre.n_instancia_xwfprcins,
                                                         pre.n_cta_bccta,
                                                         pre.n_oper_bcoper),
                          
                          pq_datos_acl.Fn_promotor(pre.n_instancia_xwfprcins),
                          pq_datos_acl.Fn_cuotasParc(pre.n_emp_bcemp,
                                                     pre.n_mod_bcmod,
                                                     pre.n_suc_bcsuc,
                                                     pre.n_mda_bcmda,
                                                     pre.n_pap_bcpap,
                                                     pre.n_cta_bccta,
                                                     pre.n_oper_bcoper,
                                                     pre.n_sbop_bcsbop,
                                                     pre.n_tope_bctop),
                          pq_datos_acl.Fn_fecTran116(pre.n_emp_bcemp,
                                                     pre.n_mod_bcmod,
                                                     pre.n_suc_bcsuc,
                                                     pre.n_mda_bcmda,
                                                     pre.n_pap_bcpap,
                                                     pre.n_cta_bccta,
                                                     pre.n_oper_bcoper,
                                                     pre.n_sbop_bcsbop,
                                                     pre.n_tope_bctop),
                          pq_datos_acl.Fn_tipo_solicitud(pre.n_instancia_xwfprcins),
                          pq_datos_acl.fn_usu_aprobacion(pre.n_instancia_xwfprcins), --mod@abr 2017.0131
                          pq_datos_acl.fn_fec_aprobacion(pre.n_instancia_xwfprcins), --mod@abr 2017.0131
                          
                          -- Tipo de Credito en el flujo
                          (select w.wfattsval
                             from wfattsvalues w
                            where w.wfinsprcid = pre.n_instancia_xwfprcins
                              and w.wfattsid = 'TIPO_CREDITO') --mod@abr 20191129
          
            from UAI_ACLPRE pre
           where pre.n_Suc_Bcsuc = pn_numsuc
             and pre.n_Rubr_Bcrubr = i.rubro;
        commit;
      exception
        when others then
          lc_coderr := sqlerrm;
          INSERT INTO LOG_ERROR_BANDEJA
            (N_NRO, C_CODBDJ, C_DESERR, D_FECERR)
          VALUES
            (0, 'SOLI', pn_numsuc || lc_coderr, TRUNC(SYSDATE));
          COMMIT;
      end;
      commit;
    end loop;
  
    commit;
    update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 = pn_numsuc
       and g.c_codage = 'SOLI';
    commit;
  EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm, 1, 200);
      update tab_jobs g
         set g.c_inderr = 'S', g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'SOLI';
      commit;
    
      return;
    
  end sp_solicitud_acl;

  Procedure sp_solicitud_acl_II(pd_fecpro in varchar2) is
  
  begin
    execute immediate ('truncate table UAI_ACLSOL');
  
    Begin
    
      insert into UAI_ACLSOL
        (N_EMP_BCEMP,
         N_MOD_BCMOD,
         N_SUC_BCSUC,
         N_MDA_BCMDA,
         N_PAP_BCPAP,
         N_CTA_BCCTA,
         N_OPE_BCOPER,
         N_SBOP_BCSBOP,
         N_TOPE_BCTOP,
         C_ANA_SNG001ASE,
         D_FECOSL_SNG001FIN,
         C_TIPCRED_SNG001TPCR,
         D_FECRESOL_SNG120FVAL,
         D_FECDIG_FECDIG,
         C_USUDESEM_WFITEMUSRCOD,
         C_USUDIG_WFITEMUSRCOD,
         C_TIPCAL_XLLOTEXTO,
         N_DIAGRAC,
         N_CUOTAS_XLLCANTCUO,
         N_CUOTASCAL,
         N_MTOAPR_XLLCAPITAL,
         N_VALCUO_XLLVALCUO,
         N_VAL_CALEN,
         N_INSTANCIA_XWFPRCINS,
         D_FECPRI,
         C_ANAEVAL_WFITEMUSRCOD,
         C_INDRIESG_WFATTSVAL,
         N_SHOCK_WFATTSVAL,
         N_AOIMP_MTOLINEA,
         N_MTODISP,
         N_MTO_APR,
         C_PROMOTOR,
         C_CUOPAR,
         D_FECTRAN_LIN,
         N_ORI_TIPSOL,
         C_USUAPRO,
         D_FECAPRO, --mod@abr20170131
         C_TIPOCREDITO --mod@abr20191129
         )
      
        SELECT distinct N_EMP_BCEMP,
                        N_MOD_BCMOD,
                        N_SUC_BCSUC,
                        N_MDA_BCMDA,
                        N_PAP_BCPAP,
                        N_CTA_BCCTA,
                        N_OPE_BCOPER,
                        N_SBOP_BCSBOP,
                        N_TOPE_BCTOP,
                        C_ANA_SNG001ASE,
                        D_FECOSL_SNG001FIN,
                        C_TIPCRED_SNG001TPCR,
                        D_FECRESOL_SNG120FVAL,
                        D_FECDIG_FECDIG,
                        C_USUDESEM_WFITEMUSRCOD,
                        C_USUDIG_WFITEMUSRCOD,
                        C_TIPCAL_XLLOTEXTO,
                        N_DIAGRAC,
                        N_CUOTAS_XLLCANTCUO,
                        N_CUOTASCAL,
                        N_MTOAPR_XLLCAPITAL,
                        N_VALCUO_XLLVALCUO,
                        N_VAL_CALEN,
                        N_INSTANCIA_XWFPRCINS,
                        D_FECPRI,
                        C_ANAEVAL_WFITEMUSRCOD,
                        C_INDRIESG_WFATTSVAL,
                        N_SHOCK_WFATTSVAL,
                        N_AOIMP_MTOLINEA,
                        N_MTODISP,
                        N_MTO_APR,
                        C_PROMOTOR,
                        C_CUOPAR,
                        D_FECTRAN_LIN,
                        N_ORI_TIPSOL,
                        C_USUAPRO, --mod@abr20170131
                        D_FECAPRO, --mod@abr20170131
                        C_TIPOCREDITO --mod@abr20191129
          FROM UAI_ACLSOL_PRE;
      COMMIT;
    
    end;
  
  end sp_solicitud_acl_II;

  function fn_Mto_linea(pn_emp  in number,
                        pn_mod  in number,
                        pn_suc  in number,
                        pn_mda  in number,
                        pn_pap  in number,
                        pn_cta  in number,
                        pn_oper in number,
                        pn_sbop in number,
                        pn_top  in number) return number is
    ln_mto number(17, 2);
  begin
    begin
      if pn_mod = 116 then
        begin
          select aoimp
            into ln_mto
            from fsr011, fsd010
           where fsr011.r1cod = pn_emp
             and fsr011.r1mod = pn_mod
             and fsr011.r1suc = pn_suc
             and fsr011.r1mda = pn_mda
             and fsr011.r1pap = pn_pap
             and fsr011.r1cta = pn_cta
             and fsr011.r1oper = pn_oper
             and fsr011.r1sbop = pn_sbop
             and fsr011.r1tope = pn_top
             and fsr011.relcod = 46
             and fsd010.pgcod = fsr011.r2cod
             and fsd010.aomod = fsr011.r2mod
             and fsd010.aosuc = fsr011.r2suc
             and fsd010.aomda = fsr011.r2mda
             and fsd010.aopap = fsr011.r2pap
             and fsd010.aocta = fsr011.r2cta
             and fsd010.aooper = fsr011.r2oper
             and fsd010.aosbop = fsr011.r2sbop
             and fsd010.aotope = fsr011.r2tope;
        exception
          when too_many_rows then
            ln_mto := null;
          when no_data_found then
            ln_mto := null;
          
        end;
      else
        ln_mto := null;
      end if;
    end;
  
    return ln_mto;
  end fn_Mto_linea;

  function fn_fec_solitud(pn_instancia in number) return date is
    ld_fecsol date;
  begin
    begin
      select b.sng001fin
        into ld_fecsol
        from sng001 b
       where b.sng001inst = pn_instancia
         and rownum = 1;
    exception
      when too_many_rows then
        ld_fecsol := null;
      when no_data_found then
        ld_fecsol := null;
      
    end;
  
    return ld_fecsol;
  end fn_fec_solitud;

  function fn_tip_credito(pn_instancia in number,
                          pn_pais      in number,
                          pn_tdoc      in number,
                          pc_ndoc      in char,
                          pn_mod       in number) return char is
    lc_tipcre char(20);
  begin
    begin
      select 'NUEVO'
        into lc_tipcre
        from sng001 aa
       where aa.sng001inst = pn_instancia
         and aa.sng001pais = pn_pais
         and aa.sng001tdoc = pn_tdoc
         and aa.sng001ndoc = pc_ndoc
         AND aa.sng001tpcr = 1;
    exception
      when too_many_rows then
        lc_tipcre := 'error';
      when no_data_found then
        begin
          if pn_mod in (116, 117) then
            lc_tipcre := 'AUTOMATICO';
          else
            lc_tipcre := 'RECURRENTE';
          end if;
        
        end;
      
    end;
  
    return lc_tipcre;
  end fn_tip_credito;

  function fn_fec_resolucion(pn_instancia in number) return date is
    ld_fecreso date;
  begin
    begin
      select b.wfiteminit
        into ld_fecreso
        from wfwrkitems b
       where b.wfinsprcid = pn_instancia
         and b.wftaskcod = 55
         and b.wfstscod = 'C'
         and b.wfitemid = (select max(bb.wfitemid)
                             from wfwrkitems bb
                            where bb.wfinsprcid = b.wfinsprcid
                              and bb.wftaskcod = b.wftaskcod
                              and bb.wfstscod = b.wfstscod)
         and rownum = 1;
    exception
      when too_many_rows then
        ld_fecreso := null;
      when no_data_found then
        ld_fecreso := null;
      
    end;
  
    return ld_fecreso;
  end fn_fec_resolucion;

  function fn_fec_digitacion(pn_instancia in number) return date is
    ld_fecdig date;
  begin
    begin
      select b.WFITEMEND
        into ld_fecdig
        from wfwrkitems b
       where b.wfinsprcid = pn_instancia
         and b.wftaskcod = 3
         and b.wfstscod = 'C'
         and rownum = 1;
    exception
      when too_many_rows then
        ld_fecdig := null;
      when no_data_found then
        ld_fecdig := null;
      
    end;
  
    return ld_fecdig;
  end fn_fec_digitacion;

  --mod@abr 20170131
  function fn_fec_aprobacion(pn_instancia in number) return date is
    ld_fecdig date;
  begin
    begin
      select b.WFITEMEND
        into ld_fecdig
        from wfwrkitems b
       where b.wfinsprcid = pn_instancia
         and b.wftaskcod = 11
         and b.wfstscod = 'C'
         and rownum = 1;
    exception
      when too_many_rows then
        ld_fecdig := null;
      when no_data_found then
        ld_fecdig := null;
      
    end;
  
    return ld_fecdig;
  end fn_fec_aprobacion;

  function fn_usu_aprobacion(pn_instancia in number) return char is
    lc_usudes char(30);
  begin
    begin
      select b.wfitemusrcod
        into lc_usudes
        from wfwrkitems b
       where b.wfinsprcid = pn_instancia
         and b.wftaskcod = 11
         and b.wfstscod = 'C'
         and rownum = 1;
    exception
      when too_many_rows then
        lc_usudes := null;
      when no_data_found then
        lc_usudes := null;
      
    end;
  
    return lc_usudes;
  end fn_usu_aprobacion;

  --mod@abr 20170131

  function fn_usu_desembolso(pn_instancia in number) return char is
    lc_usudes char(30);
  begin
    begin
      select b.wfitemusrcod
        into lc_usudes
        from wfwrkitems b
       where b.wfinsprcid = pn_instancia
         and b.wftaskcod = 55
         and b.wfstscod = 'C'
         and rownum = 1;
    exception
      when too_many_rows then
        lc_usudes := null;
      when no_data_found then
        lc_usudes := null;
      
    end;
  
    return lc_usudes;
  end fn_usu_desembolso;

  function fn_usu_digitacion(pn_instancia in number) return char is
    lc_usudes char(30);
  begin
    begin
      select b.wfitemusrcod
        into lc_usudes
        from wfwrkitems b
       where b.wfinsprcid = pn_instancia
         and b.wftaskcod = 3
         and b.wfstscod = 'C'
         and rownum = 1;
    exception
      when too_many_rows then
        lc_usudes := null;
      when no_data_found then
        lc_usudes := null;
      
    end;
  
    return lc_usudes;
  end fn_usu_digitacion;

  function fn_tip_calen(pn_emp  in number,
                        pn_mod  in number,
                        pn_suc  in number,
                        pn_mda  in number,
                        pn_pap  in number,
                        pn_cta  in number,
                        pn_oper in number,
                        pn_sbop in number,
                        pn_top  in number) return char is
    lc_tipcal char(20);
  begin
    begin
      select case
               when xllotexto = 1 then
                'Fecha Fija'
               when xllotexto = 2 then
                'Plazo Fijo'
               else
                'Otros'
             end
        into lc_tipcal
        from x054021 s
      
       where xllotxtcod = 5
         and s.pgcod = pn_emp
         and s.xlloaomod = pn_mod
         and s.xlloaosuc = pn_suc
         and s.xlloaomda = pn_mda
         and s.xlloaopap = pn_pap
         and s.xlloaocta = pn_cta
         and s.xlloaooper = pn_oper
         and s.xlloaosbop = pn_sbop
         and s.xlloaotope = pn_top;
    exception
      when too_many_rows then
        lc_tipcal := null;
      when no_data_found then
        lc_tipcal := null;
      
    end;
  
    return lc_tipcal;
  end fn_tip_calen;

  function fn_dias_gracia(pn_emp  in number,
                          pn_mod  in number,
                          pn_suc  in number,
                          pn_mda  in number,
                          pn_pap  in number,
                          pn_cta  in number,
                          pn_oper in number,
                          pn_sbop in number,
                          pn_top  in number) return number is
    ln_diagra number;
  begin
    begin
      if pn_TOP = 550 or pn_mod in (200, 33) then
        ln_diagra := 0;
      else
        select ((select min(n.ppfpag)
                   from fsd601 n
                  where m.xllaocta = n.ppcta
                    and m.xllaooper = n.ppoper
                    and m.xllaosbop = n.ppsbop
                    and m.xllaotop = n.pptope
                    and m.xllaomod = n.ppmod
                    and m.xllaosuc = n.ppsuc
                    and m.xllaomda = n.ppmda
                    and m.xllaopap = n.pppap
                    and (n.ppcap + n.ppint) <> 0
                    and n.d601co = 'S') - m.xllfvalor) - m.xllperiodo
          into ln_diagra
          from X054023 m
         where m.xllpgcod = pn_emp
           and m.xllaocta = pn_cta
           and m.xllaooper = pn_oper
           and m.xllaosbop = pn_sbop
           and m.xllaotop = pn_top
           and m.xllaomod = pn_mod
           and m.xllaosuc = pn_suc
           and m.xllaomda = pn_mda
           and m.xllaopap = pn_pap;
      end if;
    exception
      when no_data_found then
        ln_diagra := null;
      when too_many_rows then
        ln_diagra := null;
    end;
    begin
    
      if ln_diagra < 0 then
        ln_diagra := 0;
      end if;
    end;
    return ln_diagra;
  end fn_dias_gracia;

  function fn_nro_cuotas(pn_emp  in number,
                         pn_mod  in number,
                         pn_suc  in number,
                         pn_mda  in number,
                         pn_pap  in number,
                         pn_cta  in number,
                         pn_oper in number,
                         pn_sbop in number,
                         pn_top  in number) return number is
    ln_numcuo number;
  begin
    begin
      if pn_mod = 108 then
        ln_numcuo := 1;
      else
      
        select m.xllcantcuo
          into ln_numcuo
          from X054023 m
         where m.xllpgcod = pn_emp
           and m.xllaocta = pn_cta
           and m.xllaooper = pn_oper
           and m.xllaosbop = pn_sbop
           and m.xllaotop = pn_top
           and m.xllaomod = pn_mod
           and m.xllaosuc = pn_suc
           and m.xllaomda = pn_mda
           and m.xllaopap = pn_pap;
      end if;
    exception
      when no_data_found then
        ln_numcuo := null;
      when too_many_rows then
        ln_numcuo := null;
    end;
    return ln_numcuo;
  end fn_nro_cuotas;

  function fn_valor_cuotas(pn_ins in number, pn_cta in number) return number is
    ln_valcuo number;
  begin
    begin
      select m.sng01icuot
        into ln_valcuo
        from sng001 m
       where m.sng001inst = pn_ins
         and m.sng001emp = 1
         and m.sng001cta = pn_cta;
    exception
      when no_data_found then
        ln_valcuo := null;
      when too_many_rows then
        ln_valcuo := -4;
    end;
    return ln_valcuo;
  end fn_valor_cuotas;

  function fn_cuotas_calen(pn_emp  in number,
                           pn_mod  in number,
                           pn_suc  in number,
                           pn_mda  in number,
                           pn_pap  in number,
                           pn_cta  in number,
                           pn_oper in number,
                           pn_sbop in number,
                           pn_top  in number) return number is
    ln_numcuotas number;
  begin
    begin
      select /*+ parallel(o,2,1)*/
       sum(count(*))
        into ln_numcuotas
        from fsd601 o
       where o.pgcod = pn_emp
         and o.ppmod = pn_mod
         and o.ppsuc = pn_suc
         and o.ppmda = pn_mda
         and o.pppap = pn_pap
         and o.ppcta = pn_cta
         and o.ppoper = pn_oper
         and o.ppsbop = pn_sbop
         and o.pptope = pn_top
         and o.d601co = 'S'
         and (o.ppcap + o.ppint) <> 0
      
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
  end fn_cuotas_calen;

  function fn_valor_cuota_impaga(pn_emp    in number,
                                 pn_mod    in number,
                                 pn_suc    in number,
                                 pn_mda    in number,
                                 pn_pap    in number,
                                 pn_cta    in number,
                                 pn_oper   in number,
                                 pn_sbop   in number,
                                 pn_top    in number,
                                 pd_fecpro in date) return number is
    --saca la cuota del mes de proceso
  
    ln_cuota number;
    --ld_fec_sig date;
    --ld_fec_sig2 date;
    --ld_fec_sig3 date;
  begin
    begin
    
      select /*+ parallel(n,2,1)*/
       sum(p.PPCAP) + sum(p.PPINT)
        into ln_cuota
        from fsd601 p
       where p.pgcod = pn_emp
         and p.ppcta = pn_cta
         and p.ppmda = pn_mda
         and p.ppsuc = pn_suc
         and p.pppap = pn_pap
         and p.ppoper = pn_oper
         and p.ppsbop = pn_sbop
         and p.pptope = pn_top
         and p.ppmod = pn_mod
         and p.d601co = 'S'
         and (p.ppcap + p.ppint) <> 0
         and p.PPFPAG in
             (select /*+ parallel(n,2,1)*/
               min(n.ppfpag)
              
                from fsd601 n
               where n.pgcod = p.pgcod
                 and n.ppcta = p.ppcta
                 and n.ppmda = p.ppmda
                 and n.ppsuc = p.ppsuc
                 and n.pppap = p.pppap
                 and n.ppoper = p.ppoper
                 and n.ppsbop = p.ppsbop
                 and n.pptope = p.pptope
                 and n.ppmod = p.ppmod
                 and n.d601co = 'S'
                 and (n.ppcap + n.ppint) <> 0
                 and not exists
               (select /*+ parallel(o,2,1)*/
                       ppmod, ppcta, ppoper, pptope, ppfpag
                        from fsd602 o
                       where o.pgcod = n.pgcod
                         and o.ppmod = n.ppmod
                         and o.ppsuc = n.ppsuc
                         and o.ppmda = n.ppmda
                         and o.pppap = n.pppap
                         and o.ppcta = n.ppcta
                         and o.ppoper = n.ppoper
                         and o.ppsbop = n.ppsbop
                         and o.pptope = n.pptope
                         and o.ppfpag = n.ppfpag
                            --and o.ppfpag  <= pd_fecpro
                         and o.pp1fech <= pd_fecpro
                         and o.pp1stat = 'T'
                         and o.d602co = 'S'
                         and (o.pp1cap + o.pp1int) <> 0));
    
    exception
      when no_data_found then
        ln_cuota := -1;
      
      when too_many_rows then
        ln_cuota := -2;
      when others then
        ln_cuota := -5;
    end;
    return ln_cuota;
  end fn_valor_cuota_impaga;

  function fn_mto_aprobado(pn_emp   in number,
                           pn_mod   in number,
                           pn_suc   in number,
                           pn_mda   in number,
                           pn_pap   in number,
                           pn_cta   in number,
                           pn_oper  in number,
                           pn_sbop  in number,
                           pn_top   in number,
                           pn_aoimp in number) return number is
    ln_numcuo number;
  begin
    begin
      if pn_mod = 108 then
        ln_numcuo := pn_aoimp;
      else
      
        select m.xllcapital
          into ln_numcuo
          from X054023 m
         where m.xllpgcod = pn_emp
           and m.xllaocta = pn_cta
           and m.xllaooper = pn_oper
           and m.xllaosbop = pn_sbop
           and m.xllaotop = pn_top
           and m.xllaomod = pn_mod
           and m.xllaosuc = pn_suc
           and m.xllaomda = pn_mda
           and m.xllaopap = pn_pap;
      end if;
    exception
      when no_data_found then
        begin
          select m.xllcapital
            into ln_numcuo
            from X054023 m
           where m.xllpgcod = pn_emp
             and m.xllaocta = pn_cta
             and m.xllaooper = pn_oper
                --and m.xllaosuc  = pn_suc
             and m.xllaomda = pn_mda
             and m.xllaopap = pn_pap
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

  function fn_primer_pago(pn_emp    in number,
                          pn_mod    in number,
                          pn_suc    in number,
                          pn_mda    in number,
                          pn_pap    in number,
                          pn_cta    in number,
                          pn_oper   in number,
                          pn_sbop   in number,
                          pn_top    in number,
                          pd_fecpro in date) return date is
    ld_prides date;
  begin
    begin
      select min(d602.pp1fech)
        into ld_prides
        from fsd602 d602
       where d602.pgcod = pn_emp
         and d602.ppmod = pn_mod
         and d602.ppsuc = pn_suc
         and d602.ppmda = pn_mda
         and d602.pppap = pn_pap
         and d602.ppcta = pn_cta
         and d602.ppoper = pn_oper
         and d602.ppsbop = pn_sbop
         and d602.pptope = pn_top
         and d602.pp1stat = 'T'
         and d602.d602co = 'S'
         and (d602.pp1cap + d602.pp1int) <> 0
         and d602.ppfpag < pd_fecpro;
    exception
      when no_data_found then
        ld_prides := null;
      when too_many_rows then
        ld_prides := null;
    end;
    return ld_prides;
  end fn_primer_pago;

  function fn_usu_evaluacion(pn_instancia in number) return char is
    lc_usudes char(30);
  begin
    begin
      select b.wfitemusrcod
        into lc_usudes
        from wfwrkitems b
       where b.wfinsprcid = pn_instancia
         and b.wftaskcod = 7
         and b.wfstscod = 'C'
         and rownum = 1;
    exception
      when too_many_rows then
        lc_usudes := null;
      when no_data_found then
        lc_usudes := null;
      
    end;
  
    return lc_usudes;
  end fn_usu_evaluacion;

  function fn_ind_riesgo_camb(pn_instancia in number) return char is
    lc_indicador char(30);
  begin
    begin
      select wf.wfattsval
        into lc_indicador
        from wfattsvalues wf
       where wf.wfattsid = 'RIESGO_CAMBIARIO'
         and wf.wfinsprcid = pn_instancia
         and rownum = 1;
    exception
      when too_many_rows then
        lc_indicador := 'error';
      when no_data_found then
        lc_indicador := null;
      
    end;
  
    return lc_indicador;
  end fn_ind_riesgo_camb;

  function fn_shock_camb(pn_instancia in number) return char is
    lc_shock char(30);
  begin
    begin
      select wf.wfattsval
        into lc_shock
        from wfattsvalues wf
       where wf.wfattsid = 'SHOCK_CAMBIARIO'
         and wf.wfinsprcid = pn_instancia
         and rownum = 1;
    exception
      when too_many_rows then
        lc_shock := 'error';
      when no_data_found then
        lc_shock := null;
      
    end;
  
    return lc_shock;
  end fn_shock_camb;

  Procedure sp_job_Provisiones(pd_fecpro in varchar2) is
    --ln_max number;
    --ln_inc number;
    ln_ini number;
    --ln_fin number;
    i           number;
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_hostname varchar2(64);
    ln_limit    number := 0;
    ln_numjob   number := 0;
    --lc_coderr varchar2(300);
    cursor sucursal is
      select sucurs from fst001 where pgcod = 1;
  begin
    begin
      select host_name into lc_hostname from v$instance;
    end;
    execute immediate ('truncate table UAI_ACLPROV');
    delete Tab_jobs where c_Codage = 'PROV';
    commit;
    
    --apachecoh 2024.02.09
    --Limite de JOBS parametrizado en guia
    begin
      select tp1nro1
        into ln_limit
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11169
         and tp1corr1 = 11
         and tp1corr2 = 1
         and tp1corr3 = 1;
    exception
      when others then
        ln_limit := 20;
    end;
    
    for i in sucursal loop
      ln_ini      := i.sucurs;
      lc_variable := ' begin ' || '  pq_datos_acl.sp_provisiones_acl(' ||
                     ln_ini || ',' || '''' || Pd_FECpro || '''' || ');' ||
                     ' End; ';
      ln_job      := ln_job + 1;
      --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
      --        if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then   
      --        if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 180),
                        interval  => null,
                        no_parse  => false,
                        instance  => 1,
                        --instance  => 2, 01/01/2024
                        force     => false);
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 180),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      end if;
      
      --apachecoh 2024.02.09  
      BEGIN
        SELECT count(*)
          INTO ln_numjob
          FROM dba_jobs x
         WHERE upper(x.what) LIKE '%PQ_DATOS_ACL.SP_PROVISIONES_ACL%';
      EXCEPTION
        WHEN OTHERS THEN
          ln_numjob := 0;
      END;
    
      WHILE ln_numjob > ln_limit LOOP
        BEGIN
          SELECT count(*)
            INTO ln_numjob
            FROM dba_jobs x
           WHERE upper(x.what) LIKE
                 '%PQ_DATOS_ACL.SP_PROVISIONES_ACL%';
        EXCEPTION
          WHEN OTHERS THEN
            ln_numjob := 0;
        END;
      END LOOP;
      
      INSERT INTO Tab_jobs
        (c_Codage, n_Numer1, c_detjob)
      VALUES
        ('PROV', ln_ini, lc_variable);
      COMMIT;
    end loop;
  exception
    when others then
      --lc_coderr:=sqlerrm;
      INSERT INTO LOG_ERROR_BANDEJA
        (N_NRO, C_CODBDJ, C_DESERR, D_FECERR)
      VALUES
        (0, 'PROV', lc_variable, TRUNC(SYSDATE));
      COMMIT;
      --          p_c_error:=  lc_variable;
  
  end sp_job_Provisiones;

  Procedure sp_provisiones_acl(pn_numsuc in number, pd_fecpro in varchar2) is
  
    ld_fecpro date;
    --ld_fecant date ;
    lc_coderr varchar2(300);
    cursor rubro is
      select rubro
        from fsd014
       where (pcnivc in (select modulo
                           from fst111
                          where dscod = 50
                            and modulo not in (29, 120, 144)) --33 castigado , 200 judicial
             or pcnivc in (141, 117))
         and pcimpu = 'S'
         and pmtit <> 9;
  begin
  
    update tab_jobs g
       set g.d_fecini = sysdate
     where g.n_numer1 = pn_numsuc
       and g.c_codage = 'PROV';
    commit;
    ld_fecpro := to_date(pd_fecpro, 'yyyymmdd');
    --ld_fecant := ADD_MONTHS(ld_fecpro,-1);
    for i in rubro loop
      begin
      
        insert into UAI_ACLPROV
          (N_EMP_BCEMP,
           N_MOD_BCMOD,
           N_SUC_BCSUC,
           N_MDA_BCMDA,
           N_PAP_BCPAP,
           N_CTA_BCCTA,
           N_OPE_BCOPER,
           N_SBOP_BCSBOP,
           N_TOPE_BCTOP,
           N_RUBR_BCRUBR,
           N_PCTJPROV_RI105COEF,
           N_MTOFIJO_BCSDMO,
           N_MTOESPEC_BCSDMO,
           N_MTOPROCIC_BCSDMO,
           N_MTOSOBREE_BCSDMO)
          select distinct pre.n_emp_bcemp,
                          pre.n_mod_bcmod,
                          pre.n_suc_bcsuc,
                          pre.n_mda_bcmda,
                          pre.n_pap_bcpap,
                          pre.n_cta_bccta,
                          pre.n_oper_bcoper,
                          pre.n_sbop_bcsbop,
                          pre.n_tope_bctop,
                          pre.n_rubr_bcrubr,
                          fri.ri105coef,
                          pq_datos_acl.fn_saldo_relacion(pre.n_emp_bcemp,
                                                         pre.n_mod_bcmod,
                                                         pre.n_suc_bcsuc,
                                                         pre.n_mda_bcmda,
                                                         pre.n_pap_bcpap,
                                                         pre.n_cta_bccta,
                                                         pre.n_oper_bcoper,
                                                         pre.n_sbop_bcsbop,
                                                         ld_fecpro,
                                                         35,
                                                         pre.n_rubr_bcrubr),
                          pq_datos_acl.fn_saldo_relacion(pre.n_emp_bcemp,
                                                         pre.n_mod_bcmod,
                                                         pre.n_suc_bcsuc,
                                                         pre.n_mda_bcmda,
                                                         pre.n_pap_bcpap,
                                                         pre.n_cta_bccta,
                                                         pre.n_oper_bcoper,
                                                         pre.n_sbop_bcsbop,
                                                         ld_fecpro,
                                                         335,
                                                         pre.n_rubr_bcrubr),
                          pq_datos_acl.fn_saldo_relacion(pre.n_emp_bcemp,
                                                         pre.n_mod_bcmod,
                                                         pre.n_suc_bcsuc,
                                                         pre.n_mda_bcmda,
                                                         pre.n_pap_bcpap,
                                                         pre.n_cta_bccta,
                                                         pre.n_oper_bcoper,
                                                         pre.n_sbop_bcsbop,
                                                         ld_fecpro,
                                                         635,
                                                         pre.n_rubr_bcrubr),
                          pq_datos_acl.fn_saldo_relacion(pre.n_emp_bcemp,
                                                         pre.n_mod_bcmod,
                                                         pre.n_suc_bcsuc,
                                                         pre.n_mda_bcmda,
                                                         pre.n_pap_bcpap,
                                                         pre.n_cta_bccta,
                                                         pre.n_oper_bcoper,
                                                         pre.n_sbop_bcsbop,
                                                         ld_fecpro,
                                                         735,
                                                         pre.n_rubr_bcrubr)
            from UAI_ACLPRE pre, fri105 fri
           where pre.n_Suc_Bcsuc = pn_numsuc
             and pre.n_Rubr_Bcrubr = i.rubro
             and pre.n_emp_bcemp = fri.ri105cod(+)
             and pre.n_mod_bcmod = fri.ri105mod(+)
             and pre.n_mda_bcmda = fri.ri105mda(+)
             and pre.n_pap_bcpap = fri.ri105pap(+)
             and pre.n_cta_bccta = fri.ri105cta(+)
             and pre.n_oper_bcoper = fri.ri105oper(+)
             and pre.n_sbop_bcsbop = fri.ri105sbop(+)
             and pre.n_tope_bctop = fri.ri105tope(+);
        commit;
      exception
        when others then
          lc_coderr := sqlerrm;
          INSERT INTO LOG_ERROR_BANDEJA
            (N_NRO, C_CODBDJ, C_DESERR, D_FECERR)
          VALUES
            (0, 'PROV', pn_numsuc || lc_coderr, TRUNC(SYSDATE));
          COMMIT;
      end;
      commit;
    end loop;
    commit;
    update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 = pn_numsuc
       and g.c_codage = 'PROV';
    commit;
  EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm, 1, 200);
      update tab_jobs g
         set g.c_inderr = 'S', g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'PROV';
      commit;
      return;
    
  end sp_provisiones_acl;

  Procedure sp_categoria_acl(pd_fecmesACT in varchar2,
                             pd_fecmesANT in varchar2) is
  
    ld_fecmesACT date;
    ld_fecmesANT date;
  
  begin
  
    ld_fecmesACT := to_date(pd_fecmesACT, 'yyyymmdd');
    ld_fecmesANT := to_date(pd_fecmesANT, 'yyyymmdd');
    execute immediate ('truncate table UAI_ACLCAT');
  
    begin
    
      insert into UAI_ACLCAT
        (C_ALIINT_CATCATEG,
         C_CAMBMAN_CATCATEG,
         C_ALIEXT_CATCATEG,
         C_CALCRED_CATCATEG,
         C_CALOBJ_CATCATEG,
         C_CALSUB_CATCATEG,
         C_CALGRP_CATCATEG,
         C_CALREF_CATCATEG,
         C_CALRES_CATCATEG,
         N_NUMCAL,
         C_MESANT_CATCATEG,
         N_CTA_CATCTA,
         d_Fec_Catfchdes)
        select case
                 when cat.catcod = 6 then
                  cat.catcateg
               end,
               case
                 when cat.catcod = 5 then
                  cat.catcateg
               end,
               
               case
                 when cat.catcod = 1 then
                  cat.catcateg
               end,
               case
                 when cat.catcod = 4 then
                  cat.catcateg
               end,
               case
                 when cat.catcod = 2 then
                  cat.catcateg
               end,
               case
                 when cat.catcod = 3 then
                  cat.catcateg
               end,
               case
                 when cat.catcod = 7 then
                  cat.catcateg
               end,
               case
                 when cat.catcod = 8 then
                  cat.catcateg
               end,
               case
                 when cat.catcod = 9 then
                  cat.catcateg
               end,
               pq_datos_acl.fn_contador_cal_historica(cat.catcta),
               pq_datos_acl.fn_calificacion_mesant(cat.catcta, ld_fecmesANT),
               cat.catcta,
               cat.catfchdes
        
          from fsd212 cat
         where cat.catfchdes = ld_fecmesACT
        
        ;
      commit;
    
    end;
    commit;
  
    return;
  
  end sp_categoria_acl;

  function fn_contador_cal_historica(pn_cta in number) return number is
    ln_contador number;
  begin
    begin
    
      select count(m.catcod)
        into ln_contador
        from fsd212 m
       where m.pgcod = 1
         and m.catcta = pn_cta
         and m.catcod in (4, 3);
    
    exception
      when no_data_found then
        ln_contador := null;
      when too_many_rows then
        ln_contador := null;
    end;
    return ln_contador;
  end fn_contador_cal_historica;

  function fn_calificacion_mesant(pn_cta in number, pd_fecmesANT in date)
    return char is
    lc_caliant char(15);
  begin
    begin
    
      select m.catcateg
        into lc_caliant
        from fsd212 m
       where m.pgcod = 1
         and m.catcta = pn_cta
         and m.catcod = 4
         and m.catfchdes = pd_fecmesANT;
    
    exception
      when no_data_found then
        lc_caliant := null;
      when too_many_rows then
        lc_caliant := null;
    end;
    return lc_caliant;
  end fn_calificacion_mesant;

  function fn_categoria(pn_emp    in number,
                        pn_cta    in number,
                        pd_feccat in date,
                        pn_codcat in number) return varchar2 is
    lc_categoria varchar2(20);
  begin
    begin
      select l.catcateg
        into lc_categoria
        from fsd212 l
       where l.pgcod = pn_emp
         and l.catcta = pn_cta
         and l.catfchdes = pd_feccat
         and l.catcod = pn_codcat;
    exception
      when no_data_found then
        lc_categoria := null;
      when too_many_rows then
        lc_categoria := null;
    end;
    return lc_categoria;
  end fn_categoria;

  Procedure sp_job_garantias(pd_fecpro in varchar2) is
    --ln_max number;
    --ln_inc number;
    ln_ini number;
    --ln_fin number;
    i           number;
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_hostname varchar2(64);    
    ln_limit    number := 0;
    ln_numjob   number := 0;
    --lc_coderr varchar2(300);
    cursor sucursal is
      select sucurs from fst001 where pgcod = 1;
  begin
    begin
      select host_name into lc_hostname from v$instance;
    end;
    execute immediate ('truncate table UAI_ACLGAR');
    delete Tab_jobs where c_Codage = 'GAR';
    commit;
    
    --apachecoh 2024.02.09
    --Limite de JOBS parametrizado en guia
    begin
      select tp1nro1
        into ln_limit
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11169
         and tp1corr1 = 11
         and tp1corr2 = 1
         and tp1corr3 = 1;
    exception
      when others then
        ln_limit := 20;
    end;
    
    for i in sucursal loop
      ln_ini      := i.sucurs;
      lc_variable := ' begin ' || '  pq_datos_acl.sp_garantias_acl(' ||
                     ln_ini || ',' || '''' || Pd_FECpro || '''' || ');' ||
                     ' End; ';
      ln_job      := ln_job + 1;
      --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
      --        if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then   
      --        if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 180),
                        interval  => null,
                        no_parse  => false,
                        instance  => 1,
                        --instance  => 2, 01/01/2024
                        force     => false);
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 180),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      end if;
      
      --apachecoh 2024.02.09  
      BEGIN
        SELECT count(*)
          INTO ln_numjob
          FROM dba_jobs x
         WHERE upper(x.what) LIKE '%PQ_DATOS_ACL.SP_GARANTIAS_ACL%';
      EXCEPTION
        WHEN OTHERS THEN
          ln_numjob := 0;
      END;
    
      WHILE ln_numjob > ln_limit LOOP
        BEGIN
          SELECT count(*)
            INTO ln_numjob
            FROM dba_jobs x
           WHERE upper(x.what) LIKE
                 '%PQ_DATOS_ACL.SP_GARANTIAS_ACL%';
        EXCEPTION
          WHEN OTHERS THEN
            ln_numjob := 0;
        END;
      END LOOP;
      
      INSERT INTO Tab_jobs
        (c_Codage, n_Numer1, c_detjob)
      VALUES
        ('GAR', ln_ini, lc_variable);
      COMMIT;
    end loop;
  exception
    when others then
      --lc_coderr:=sqlerrm;
      INSERT INTO LOG_ERROR_BANDEJA
        (N_NRO, C_CODBDJ, C_DESERR, D_FECERR)
      VALUES
        (0, 'GAR', lc_variable, TRUNC(SYSDATE));
      COMMIT;
      --          p_c_error:=  lc_variable;
  
  end sp_job_garantias;

  Procedure sp_garantias_acl(pn_numsuc in number, pd_fecpro in varchar2) is
  
    ld_fecpro date;
    --ld_fecant date ;
    lc_coderr varchar2(300);
    cursor rubro is
      select rubro
        from fsd014
       where (pcnivc in (select modulo
                           from fst111
                          where dscod = 50
                            and modulo not in (29, 120, 144)) --33 castigado , 200 judicial
             or pcnivc in (141, 117))
         and pcimpu = 'S'
         and pmtit <> 9;
  begin
  
    update tab_jobs g
       set g.d_fecini = sysdate
     where g.n_numer1 = pn_numsuc
       and g.c_codage = 'GAR';
    commit;
    ld_fecpro := to_date(pd_fecpro, 'yyyymmdd');
    --ld_fecant := ADD_MONTHS(ld_fecpro,-1);
    for i in rubro loop
      begin
      
        insert into UAI_ACLGAR
          (N_EMP_BCEMP,
           N_MOD_BCMOD,
           N_SUC_BCSUC,
           N_MDA_BCMDA,
           N_PAP_BCPAP,
           N_CTA_BCCTA,
           N_OPE_BCOPER,
           N_SBOP_BCSBOP,
           N_TIP_BCTOP,
           N_EMP_r2cod,
           N_MOD_r2mod,
           N_SUC_r2suc,
           N_MDA_r2mda,
           N_PAP_r2pap,
           N_CTA_r2cta,
           N_OPE_r2oper,
           N_SBO_r2sbop,
           N_TIP_r2tope,
           N_RUBR_BCRUBR,
           N_SALCON_BCSDMO,
           N_MTOGAR_SNG122MTOU,
           N_PRIORI_SNG122PRIO,
           N_INSTANCIA_SNG122INST)
          select /*+ all_rows parallel(pre,2,2) parallel(rel,2,2) */
           pre.n_emp_bcemp,
           pre.n_mod_bcmod,
           pre.n_suc_bcsuc,
           pre.n_mda_bcmda,
           pre.n_pap_bcpap,
           pre.n_cta_bccta,
           pre.n_oper_bcoper,
           pre.n_sbop_bcsbop,
           pre.n_tope_bctop,
           rel.r2cod,
           rel.r2mod,
           rel.r2suc,
           rel.r2mda,
           rel.r2pap,
           rel.r2cta,
           rel.r2oper,
           rel.r2sbop,
           rel.r2tope,
           pq_datos_acl.fn_rubro_gar(rel.r2cod,
                                     rel.r2mod,
                                     rel.r2suc,
                                     rel.r2mda,
                                     rel.r2pap,
                                     rel.r2cta,
                                     rel.r2oper,
                                     rel.r2sbop,
                                     rel.r2tope,
                                     ld_fecpro),
           pq_datos_acl.fn_saldo_contable_gar(rel.r2cod,
                                              rel.r2mod,
                                              rel.r2suc,
                                              rel.r2mda,
                                              rel.r2pap,
                                              rel.r2cta,
                                              rel.r2oper,
                                              rel.r2sbop,
                                              rel.r2tope,
                                              ld_fecpro),
           (select gar.sng122mtou
              from sng122 gar
             where gar.sng122inst = pre.n_instancia_xwfprcins
               and rel.r2cod = gar.sng122pgc
               and rel.r2suc = gar.sng122suc
               and rel.r2mod = gar.sng122mod
               and rel.r2mda = gar.sng122mda
               and rel.r2pap = gar.sng122pap
               and rel.r2cta = gar.sng122cta
               and rel.r2oper = gar.sng122oper
               and rel.r2sbop = gar.sng122sbop
               and rel.r2tope = gar.sng122tope),
           (select gar.sng122pri
              from sng122 gar
             where gar.sng122inst = pre.n_instancia_xwfprcins
               and rel.r2cod = gar.sng122pgc
               and rel.r2suc = gar.sng122suc
               and rel.r2mod = gar.sng122mod
               and rel.r2mda = gar.sng122mda
               and rel.r2pap = gar.sng122pap
               and rel.r2cta = gar.sng122cta
               and rel.r2oper = gar.sng122oper
               and rel.r2sbop = gar.sng122sbop
               and rel.r2tope = gar.sng122tope),
           pre.n_instancia_xwfprcins
          
            from UAI_ACLPRE pre, fsr011 rel
           where pre.n_Suc_Bcsuc = pn_numsuc
             and pre.n_Rubr_Bcrubr = i.rubro
             and rel.r1cod = pre.n_emp_bcemp
             and rel.r1suc = pre.n_suc_bcsuc
             and rel.r1mod = pre.n_mod_bcmod
             and rel.r1mda = pre.n_mda_bcmda
             and rel.r1pap = pre.n_pap_bcpap
             and rel.r1cta = pre.n_cta_bccta
             and rel.r1oper = pre.n_oper_bcoper
             and rel.r1sbop = pre.n_sbop_bcsbop
             and rel.r1tope = pre.n_tope_bctop
             and rel.relcod = 50
          
          /*UNION
          
          
          select \*+ all_rows parallel(pres,2,1) parallel(rels,2,1) *\
            pres.n_emp_bcemp,
            pres.n_mod_bcmod,
            pres.n_suc_bcsuc,
            pres.n_mda_bcmda,
            pres.n_pap_bcpap,
            pres.n_cta_bccta,
            pres.n_oper_bcoper,
            pres.n_sbop_bcsbop,
            pres.n_tope_bctop,
            rels.r2cod,
            rels.r2mod,
            rels.r2suc,
            rels.r2mda,
            rels.r2pap,
            rels.r2cta,
            rels.r2oper,
            rels.r2sbop,
            rels.r2tope,
            pq_datos_acl.fn_rubro_gar(rels.r2cod,rels.r2mod,rels.r2suc,rels.r2mda,
                                               rels.r2pap,rels.r2cta,rels.r2oper,rels.r2sbop,
                                               rels.r2tope,ld_fecpro),
            pq_datos_acl.fn_saldo_contable_gar(rels.r2cod,rels.r2mod,rels.r2suc,rels.r2mda,
                                               rels.r2pap,rels.r2cta,rels.r2oper,rels.r2sbop,
                                               rels.r2tope,ld_fecpro),
            0,
            0,
            0
          
          
               from UAI_ACLPRE pres, fsr011 rels
              where pres.n_Suc_Bcsuc = pn_numsuc
                and pres.n_Rubr_Bcrubr = i.rubro
                and pres.n_mod_bcmod = 108
                and rels.r1cod      = pres.n_emp_bcemp
                and rels.r1suc      = pres.n_suc_bcsuc
                and rels.r1mod      = pres.n_mod_bcmod
                and rels.r1mda      = pres.n_mda_bcmda
                and rels.r1pap      = pres.n_pap_bcpap
                and rels.r1cta      = pres.n_cta_bccta
                and rels.r1oper     = pres.n_oper_bcoper
                and rels.r1sbop     = pres.n_sbop_bcsbop
                and rels.r1tope     = pres.n_tope_bctop
                and rels.relcod     = 50*/
          ;
        commit;
      exception
        when others then
          lc_coderr := sqlerrm;
          INSERT INTO LOG_ERROR_BANDEJA
            (N_NRO, C_CODBDJ, C_DESERR, D_FECERR)
          VALUES
            (0, 'GAR', pn_numsuc || lc_coderr, TRUNC(SYSDATE));
          COMMIT;
      end;
      commit;
    end loop;
    commit;
    update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 = pn_numsuc
       and g.c_codage = 'GAR';
    commit;
  EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm, 1, 200);
      update tab_jobs g
         set g.c_inderr = 'S', g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'GAR';
      commit;
      return;
    
  end sp_garantias_acl;

  function fn_saldo_contable_gar(pn_emp    in number,
                                 pn_mod    in number,
                                 pn_suc    in number,
                                 pn_mda    in number,
                                 pn_pap    in number,
                                 pn_cta    in number,
                                 pn_oper   in number,
                                 pn_sbop   in number,
                                 pn_top    in number,
                                 pd_fecpro in date) return number is
    ln_saldo number;
  
    cursor rubro is
      select rubro
        from fsd014
       where pcnivc = 70
         and pcimpu = 'S'
      /*and pmtit <> 9*/
      ;
  
  begin
  
    for i in rubro loop
    
      begin
        select /*+ parallel(n,2,1)*/
         n.bcsdmo
          into ln_saldo
          from fsh012 n
         where n.bcemp = pn_emp
           and n.bccta = pn_cta
           and n.bcmda = pn_mda
           and n.bcsuc = pn_suc
           and n.bcpap = pn_pap
           and n.bcoper = pn_oper
           and n.bcsbop = pn_sbop
           and n.bctop = pn_top
           and n.bcmod = pn_mod
           and n.bcrubr = i.rubro
           and n.bcfech = pd_fecpro;
      exception
        when no_data_found then
          ln_saldo := null;
        when too_many_rows then
          ln_saldo := null;
      end;
      if ln_saldo <> 0 then
        exit;
      end if;
    
    end loop;
  
    return ln_saldo;
  
  end fn_saldo_contable_gar;

  function fn_rubro_gar(pn_emp    in number,
                        pn_mod    in number,
                        pn_suc    in number,
                        pn_mda    in number,
                        pn_pap    in number,
                        pn_cta    in number,
                        pn_oper   in number,
                        pn_sbop   in number,
                        pn_top    in number,
                        pd_fecpro in date) return number is
    ln_rubro number;
  
    cursor rubro is
      select rubro
        from fsd014
       where pcnivc = 70
         and pcimpu = 'S'
      /*and pmtit <> 9*/
      ;
  
  begin
  
    for i in rubro loop
    
      begin
        select /*+ parallel(n,2,1)*/
         n.bcrubr
          into ln_rubro
          from fsh012 n
         where n.bcemp = pn_emp
           and n.bccta = pn_cta
           and n.bcmda = pn_mda
           and n.bcsuc = pn_suc
           and n.bcpap = pn_pap
           and n.bcoper = pn_oper
           and n.bcsbop = pn_sbop
           and n.bctop = pn_top
           and n.bcmod = pn_mod
           and n.bcrubr = i.rubro
           and n.bcfech = pd_fecpro;
      exception
        when no_data_found then
          ln_rubro := null;
        when too_many_rows then
          ln_rubro := null;
      end;
      if ln_rubro <> 0 then
        exit;
      end if;
    
    end loop;
  
    return ln_rubro;
  
  end fn_rubro_gar;

  Procedure SP_Otras_estructuras(pd_fecpro in varchar2) is
  
    ld_fecpro DATE;
  
    cursor creditos is
      select * from uai_aclsol;
  
    cursor parciales(pn_ins in number) is
      select * from sng002 a where a.sng001inst = pn_ins;
  
    cursor creditos_117 is
      select * from uai_aclprov a where a.n_prov117 is null;
  
    cursor creditos_aclpre is --mod@abr 20161003
      select * from uai_aclpre; --mod@abr 20161003
  
    --MOD@abr 20170317
    --cursor garantias is
    --select * from UAI_ACLGAR;
    --MOD@abr 20170317
  
    --mod@abr 20170410
    --cursor modulo is
    --select tp1nro1 
    --  from fst198 
    -- where tp1cod   = 1 
    --   and tp1cod1  = 11008
    --   and tp1corr1 = 1
    --   and tp1corr2 = 1;
  
    --mod@abr 20170410
  
    ln_monto number(17, 2);
    ln_emp   number(3);
    ln_mod   number(3);
    ln_suc   number(3);
    ln_mda   number(4);
    ln_pap   number(4);
    ln_cta   number(9);
    ln_ope   number(9);
    ln_sbo   number(3);
    ln_top   number(3);
  
    ln_ref    number(10, 6);
    ln_mtoTot number(17, 2);
    ln_mtoCap number(17, 2);
    ln_mtoInt number(17, 2);
    ln_mtoMor number(17, 2);
    ln_mtoSeg number(17, 2);
    ln_mtoCom number(17, 2);
    ln_mot    number(3);
    ln_sut    number(3);
    ln_trt    number(3);
    ln_rel    number(4);
    ld_fet    date;
  
    --mod@abr 20170131
    ln_dia number(10);
    lc_usi char(10);
    --mod@abr 20170131
    --mod@abr 20170316
    --ld_fecpago date;
    cursor cursor_Detalle is
      select * from JAQZ525_PREDET;
    --ln_capP number(17,2);
    --ln_intP number(17,2);
    --ln_moraP number(5);
    --Ln_segP number(17,2);
    --Ln_comP number(17,2);
    Ln_mtoP number(17, 2);
    --Ln_motP number(3);
    --Ln_sutP  number(3);
    --Ln_trtP  number(3);
    --Ln_relP  number(4);
    --Ld_fetP  date;
    --Ln_morP number(10);
    --Lc_usiP  char(10);
    --mod@abr 20170316
  
    --mod@abr 20170410
    --ld_fecini date;
    --ld_fecmes date;
    --mod@abr 20170410
  
  begin
    ld_fecpro := to_date(pd_fecpro, 'yyyymmdd');
    execute immediate ('truncate table UAI_ACLSECT');
    execute immediate ('truncate table UAI_ACLREL');
    execute immediate ('truncate table UAI_ACLDIR');
    execute immediate ('truncate table UAI_ACLFON');
    execute immediate ('truncate table UAI_ACLPERS');
    execute immediate ('truncate table UAI_ACLSBS');
    execute immediate ('truncate table UAI_ACLPPE');
    execute immediate ('truncate table UAI_ACLLINEAS');
    execute immediate ('truncate table uai_acldespar');
    execute immediate ('truncate table JAQZ525_PREDET');
    execute immediate ('truncate table JAQZ525_GARPF');
    --execute immediate ('truncate table JAQZ525_PAGOPRE');--mod@abr 20170410
    --execute immediate ('truncate table JAQZ525_PAGOPRE2');--mod@abr 20170410
    --execute immediate ('truncate table JAQZ525_PAGO');--mod@abr 20170410
  
    ---SECTOR
    -- begin
  
    insert into UAI_ACLSECT
      (N_TIPI_JAQL101SCL,
       N_EMP_JAQL101PGC,
       N_MOD_JAQL101MOD,
       N_SUC_JAQL101SUC,
       N_MDA_JAQL101MON,
       N_PAP_JAQL101PAP,
       N_CTA_JAQL101CTA,
       N_OPE_JAQL101OPE,
       N_SBO_JAQL101SOP,
       N_TOP_JAQL101TOP,
       D_FEC_JAQL101FCH,
       N_COR_JAQL101COR)
    
      select JAQL101SCL n_tipi_JAQL101SCL,
             JAQL101PGC n_emp_JAQL101PGC,
             JAQL101MOD n_mod_JAQL101MOD,
             JAQL101SUC n_suc_JAQL101SUC,
             JAQL101MON n_mda_JAQL101MON,
             JAQL101PAP n_pap_JAQL101PAP,
             JAQL101CTA n_cta_JAQL101CTA,
             JAQL101OPE n_ope_JAQL101OPE,
             JAQL101SOP n_sbo_JAQL101SOP,
             JAQL101TOP n_top_JAQL101TOP,
             JAQL101FCH d_fec_JAQL101FCH,
             JAQL101COR n_cor_JAQL101COR
      
        from jaql101 T
       WHERE T.JAQL101FCH = ld_fecpro
         and t.jaql101cor = (select max(tt.jaql101cor)
                               from jaql101 tt
                              where tt.jaql101pgc = t.jaql101pgc
                                and tt.jaql101mod = t.jaql101mod
                                and tt.jaql101suc = t.jaql101suc
                                and tt.jaql101mon = t.jaql101mon
                                and tt.jaql101pap = t.jaql101pap
                                and tt.jaql101cta = t.jaql101cta
                                and tt.jaql101ope = t.jaql101ope
                                and tt.jaql101sop = t.jaql101sop
                                and tt.jaql101top = t.jaql101top
                                and tt.jaql101fch = t.jaql101fch
                              group by tt.jaql101pgc,
                                       tt.jaql101mod,
                                       tt.jaql101suc,
                                       tt.jaql101mon,
                                       tt.jaql101pap,
                                       tt.jaql101cta,
                                       tt.jaql101ope,
                                       tt.jaql101sop,
                                       tt.jaql101top,
                                       tt.jaql101fch);
    commit;
  
    /*end;
    commit;*/
  
    --RELACIONES
    begin
    
      insert into UAI_ACLREL
        (n_emp_bcemp,
         n_mod_bcmod,
         n_suc_bcsuc,
         n_mda_bcmda,
         n_pap_bcpap,
         n_cta_bccta,
         n_oper_bcoper,
         n_sbop_bcsbop,
         n_tope_bctop,
         n_pais_pepais,
         n_tdoc_petdoc,
         c_ndoc_pendoc,
         C_TIT_CTTFIR,
         n_tiprel_rpccyg,
         C_ORIGEN,
         n_instancia_xwfprcins)
      
        select distinct pre.n_emp_bcemp,
                        pre.n_mod_bcmod,
                        pre.n_suc_bcsuc,
                        pre.n_mda_bcmda,
                        pre.n_pap_bcpap,
                        pre.n_cta_bccta,
                        pre.n_oper_bcoper,
                        pre.n_sbop_bcsbop,
                        pre.n_tope_bctop,
                        b.pepais,
                        b.petdoc,
                        b.pendoc,
                        b.cttfir,
                        (case
                          when b.cttfir <> 'T' then
                           c.RPCCYG
                          else
                           NULL
                        end) Vinculo,
                        'PRESTAMO' ORIGEN,
                        pre.n_instancia_xwfprcins
          from uai_Aclpre pre, fsr008 b, fsr002 c
         where pre.n_cta_bccta = b.ctnro
           and b.pepais = c.rppais(+)
           and b.petdoc = c.rptdoc(+)
           and b.pendoc = c.rpndoc(+)
        --and a.n_cta_bccta= 1281435--53918
        -- and pre.c_ndoc_pendoc = '20102159862'
        
        union
        
        select distinct pres.n_emp_bcemp,
                        pres.n_mod_bcmod,
                        pres.n_suc_bcsuc,
                        pres.n_mda_bcmda,
                        pres.n_pap_bcpap,
                        pres.n_cta_bccta,
                        pres.n_oper_bcoper,
                        pres.n_sbop_bcsbop,
                        pres.n_tope_bctop,
                        f.pepais,
                        f.petdoc,
                        f.pendoc,
                        f.cttfir,
                        (case
                          when f.cttfir <> 'T' then
                           Cc.RPCCYG
                        
                          else
                           NULL
                        end) Vinculo,
                        'AVAL' ORIGEN,
                        pres.n_instancia_xwfprcins
          from uai_Aclpre pres, sng003 d, fsr008 f, fsr002 cc
         where pres.n_instancia_xwfprcins = d.sng001inst
           and f.ctnro = d.sng003cta
           and f.pepais = cc.rppais(+)
           and f.petdoc = cc.rptdoc(+)
           and f.pendoc = cc.rpndoc(+);
      --and e.n_cta_bccta= 1281435
      --and e.c_ndoc_pendoc = '29224308'
      commit;
    
    end;
    commit;
  
    --DIRECCIONES
  
    begin
    
      insert into UAI_ACLDIR
        (n_pais_pepais,
         n_tdoc_petdoc,
         c_ndoc_pendoc,
         n_cta_bccta,
         n_coddir_docod,
         c_dir_sngc13dir,
         c_ref_sngc13ref1,
         n_corr_sngc13corr,
         c_via_sngc13dsc1,
         c_ubi_sngc13ugeo,
         n_dpto_sngc13dpto,
         n_prov_sngc13prov,
         n_dist_sngc13dist)
      
        select distinct dir.sngc13pais  n_pais_pepais,
                        dir.sngc13tdoc  n_tdoc_petdoc,
                        dir.sngc13ndoc  c_ndoc_pendoc,
                        rel.n_cta_bccta n_cta_bccta,
                        dir.docod       n_coddir_docod,
                        dir.sngc13dir   c_dir_sngc13dir,
                        dir.sngc13ref1  c_ref_sngc13ref1,
                        dir.sngc13corr  n_corr_sngc13corr,
                        dir.sngc13dsc1  c_via_sngc13dsc1,
                        dir.sngc13ugeo  c_ubi_sngc13ugeo,
                        dir.sngc13dpto  n_dpto_sngc13dpto,
                        dir.sngc13prov  n_prov_sngc13prov,
                        dir.sngc13dist  n_dist_sngc13dist
        
          from SNGC13 dir, uai_aclrel rel
         where dir.sngc13pais = rel.n_pais_pepais
           and dir.sngc13tdoc = rel.n_tdoc_petdoc
           and dir.sngc13ndoc = rel.c_ndoc_pendoc;
      commit;
    
    end;
    commit;
  
    --FONDEO
  
    begin
    
      insert into UAI_ACLFON
        (n_emp_bcemp,
         n_mod_bcmod,
         n_suc_bcsuc,
         n_mda_bcmda,
         n_pap_bcpap,
         n_cta_bccta,
         n_oper_bcoper,
         n_sbop_bcsbop,
         n_tope_bctop,
         n_fuentefin_r2cta,
         n_linfinan_r2oper,
         n_empfon_r2cod,
         n_modfon_r2mod,
         n_sucfon_r2suc,
         n_mdafon_r2mda,
         n_papfon_r2pap,
         n_sbopfon_r2sbop,
         n_topfon_r2tope,
         c_desfon_ctnom)
      
        select /*+ all_rows parallel(pre,2,2) parallel(fon,2,2) */
         pre.n_emp_bcemp   n_emp_bcemp,
         pre.n_mod_bcmod   n_mod_bcmod,
         pre.n_suc_bcsuc   n_suc_bcsuc,
         pre.n_mda_bcmda   n_mda_bcmda,
         pre.n_pap_bcpap   n_pap_bcpap,
         pre.n_cta_bccta   n_cta_bccta,
         pre.n_oper_bcoper n_oper_bcoper,
         pre.n_sbop_bcsbop n_sbop_bcsbop,
         pre.n_tope_bctop  n_tope_bctop,
         fon.r2cta         n_fuentefin_r2cta,
         fon.r2oper        n_linfinan_r2oper,
         fon.r2cod         n_empfon_r2cod,
         fon.r2mod         n_modfon_r2mod,
         fon.r2suc         n_sucfon_r2suc,
         fon.r2mda         n_mdafon_r2mda,
         fon.r2pap         n_papfon_r2pap,
         fon.r2sbop        n_sbopfon_r2sbop,
         fon.r2tope        n_topfon_r2tope,
         nom.ctnom         c_desfon_ctnom
        
          from fsr011 fon, uai_aclpre pre, fsd008 nom
         where fon.r1cod = pre.n_emp_bcemp
           and fon.r1mod = pre.n_mod_bcmod
           and fon.r1suc = pre.n_suc_bcsuc
           and fon.r1mda = pre.n_mda_bcmda
           and fon.r1pap = pre.n_pap_bcpap
           and fon.r1cta = pre.n_cta_bccta
           and fon.r1oper = pre.n_oper_bcoper
           and fon.r1sbop = pre.n_sbop_bcsbop
           and fon.r1tope = pre.n_tope_bctop
           and fon.relcod = 30
           and nom.pgcod = 1
           and nom.ctnro = fon.r2cta
           and fon.r2cta <> 0;
      commit;
    
    end;
    commit;
  
    --PERSONAS
  
    begin
    
      insert into UAI_ACLPERS
        (n_pais_pepais,
         n_tdoc_petdoc,
         c_ndoc_pendoc,
         c_tiper_petipo,
         c_tit_penom,
         c_codt_pfebco,
         d_fecnac)
      
        select distinct rel.n_pais_pepais,
                        rel.n_tdoc_petdoc,
                        rel.c_ndoc_pendoc,
                        per.petipo c_tiper_petipo,
                        per.penom c_tit_penom,
                        (select pes.pfebco c_codt_pfebco
                           from fsd002 pes
                          where pes.pfpais = per.pepais
                            and pes.pftdoc = per.petdoc
                            and pes.pfndoc = per.pendoc),
                        case
                          when trim(per.petipo) = 'F' then
                           (select pes.pffnac
                              from fsd002 pes
                             where pes.pfpais = per.pepais
                               and pes.pftdoc = per.petdoc
                               and pes.pfndoc = per.pendoc)
                        
                          when trim(per.petipo) = 'J' then
                           (select jur.pjfcon
                              from fsd003 jur
                             where jur.pjpais = per.pepais
                               and jur.pjtdoc = per.petdoc
                               and jur.pjndoc = per.pendoc)
                        end d_fecnac
          from fsd001 per, uai_aclrel rel
         where per.pepais = rel.n_pais_pepais
           and per.petdoc = rel.n_tdoc_petdoc
           and per.pendoc = rel.c_ndoc_pendoc;
      commit;
    
    end;
    commit;
  
    --SBS
  
    begin
    
      insert into UAI_ACLSBS
        (N_CTA_BC739CTA,
         N_PAIS_BC739PAIS,
         N_TDOC_BC739TDOC,
         C_NDOC_BC739NDOC,
         N_SBS_BC739SBS)
      
        select sbs.BC739CTA  n_cta_BC739CTA,
               sbs.BC739PAIS n_pais_BC739PAIS,
               sbs.BC739TDOC n_tdoc_BC739TDOC,
               sbs.BC739NDOC c_ndoc_BC739NDOC,
               sbs.BC739SBS  n_sbs_BC739SBS
          from fbc739 sbs;
      commit;
    
    end;
    commit;
  
    --PPE
  
    begin
    
      insert into UAI_ACLPPE
        (N_EMP_DEPE18COD,
         N_SUC_DEPE18SUc,
         N_MOD_DEPE18MOD,
         N_MDA_DEPE18MDA,
         N_PAP_DEPE18PAP,
         N_CTA_DEPE18CTA,
         N_OPE_DEPE18OPE,
         N_SBO_DEPE18SBO,
         N_TOP_DEPE18TOP,
         N_DIAM_DEPE18PLZ,
         N_CAT_DEPE18CAT,
         N_PROV_DEPE18PRV,
         N_POR_DEPE18POR,
         N_TIPCRE_DEPE18TCR,
         N_CAP_DEPE18CAP,
         N_INT_DEPE18INT,
         N_DEUT_DEPE18DEU,
         N_GAR_DEPE18IGR,
         C_TIPGAR_DEPE18DGR,
         N_PORI_DEPE18PI,
         N_SEVPER_DEPE18LGD,
         N_EXP_DEPE18EAD,
         N_PERES_DEPE18PE,
         N_PROVPE_DEPE18PPE,
         N_NOR_DEPE18PR1,
         N_PE_DEPE18PF,
         N_DIFCA_DEPE18DIf,
         N_RUB_DEPE18RUB,
         D_FECPRO_BCFECH)
      
        SELECT dep.depe18cod n_emp_depe18cod,
               dep.depe18suc n_suc_depe18suc,
               dep.depe18mod n_mod_depe18mod,
               dep.depe18mda n_mda_depe18mda,
               dep.depe18pap n_pap_depe18pap,
               dep.depe18cta n_cta_depe18cta,
               dep.depe18ope n_ope_depe18ope,
               dep.depe18sbo n_sbo_depe18sbo,
               dep.depe18top n_top_depe18top,
               dep.depe18plz n_diam_depe18plz,
               dep.depe18cat n_cat_depe18cat,
               dep.depe18prv n_prov_depe18prv,
               dep.depe18por n_por_depe18por,
               dep.depe18tcr n_tipcre_depe18tcr,
               dep.depe18cap n_cap_depe18cap,
               dep.depe18int n_int_depe18int,
               dep.depe18deu n_deut_depe18deu,
               dep.depe18igr n_gar_depe18igr,
               dep.depe18dgr c_tipgar_depe18dgr,
               dep.depe18pi  n_pori_depe18pi,
               dep.depe18lgd n_sevper_depe18lgd,
               dep.depe18ead n_exp_depe18ead,
               dep.depe18pe  n_peres_depe18pe,
               dep.depe18ppe n_provpe_depe18ppe,
               dep.depe18pr1 n_nor_depe18pr1,
               dep.depe18pf  n_pe_depe18pf,
               dep.depe18dif n_difca_depe18dif,
               dep.depe18rub n_rub_depe18rub,
               ld_fecpro     d_fecpro_bcfech
        
          FROM DEPE18 dep;
      commit;
    
    end;
    commit;
  
    --RELACION LINEA CON LINEA OTORGADA (116 - 117)
    begin
    
      insert into UAI_ACLLINEAS
        (N_EMP_R1COD,
         N_MOD_R1MOD,
         N_SUC_R1SUC,
         N_MDA_R1MDA,
         N_PAP_R1PAP,
         N_CTA_R1CTA,
         N_OPE_R1OPER,
         N_SBOP_R1SBOP,
         N_TOPE_R1TOP,
         N_EMP_R2COD,
         N_MOD_R2MOD,
         N_SUC_R2SUC,
         N_MDA_R2MDA,
         N_PAP_R2PAP,
         N_CTA_R2CTA,
         N_OPE_R2OPER,
         N_SBOP_R2SBOP,
         N_TOPE_R2TOP)
      
        select a.pgcod,
               a.aomod,
               a.aosuc,
               a.aomda,
               a.aopap,
               a.aocta,
               a.aooper,
               a.aosbop,
               a.aotope,
               b.r2cod,
               b.r2mod,
               b.r2suc,
               b.r2mda,
               b.r2pap,
               b.r2cta,
               b.r2oper,
               b.r2sbop,
               b.r2tope
          from Fsd010 a, fsr011 b
         where a.pgcod = b.r1cod
           and a.aomod = b.r1mod
           and a.aosuc = b.r1suc
           and a.aomda = b.r1mda
           and a.aopap = b.r1pap
           and a.aocta = b.r1cta
           and a.aooper = b.r1oper
           and a.aosbop = b.r1sbop
           and a.aotope = b.r1tope
           and b.relcod = 46
           and a.aomod = 116
           and a.aostat <> 99;
      commit;
    
    end;
    commit;
  
    --DESEMBOLSOS PARCIALES
    Begin
      for i in creditos loop
        for j in parciales(i.n_instancia_xwfprcins) loop
          insert into uai_acldespar
            (n_instancia_xwfprcins, n_monto_parcial)
          values
            (i.n_instancia_xwfprcins, j.sng002mon);
          commit;
        end loop;
      
      end loop;
      commit;
    end;
  
    --ACTUALIZA PROVISIONES 117
    Begin
      for i in creditos_117 loop
        begin
          select a.r2cod,
                 a.r2mod,
                 a.r2suc,
                 a.r2mda,
                 a.r2pap,
                 a.r2cta,
                 a.r2oper,
                 a.r2sbop,
                 a.r2tope
            into ln_emp,
                 ln_mod,
                 ln_suc,
                 ln_mda,
                 ln_pap,
                 ln_cta,
                 ln_ope,
                 ln_sbo,
                 ln_top
            from fsr011 a
           where relcod = 46
             and a.r1cod = i.n_emp_bcemp
             and a.r1mod = i.n_mod_bcmod
             and a.r1suc = i.n_suc_bcsuc
             and a.r1mda = i.n_mda_bcmda
             and a.r1pap = i.n_pap_bcpap
             and a.r1cta = i.n_cta_bccta
             and a.r1oper = i.n_ope_bcoper
             and a.r1sbop = i.n_sbop_bcsbop
             and a.r1tope = i.n_tope_bctop
             and rownum = 1;
        exception
          when no_data_found then
            ln_emp := null;
            ln_mod := null;
            ln_suc := null;
            ln_mda := null;
            ln_pap := null;
            ln_cta := null;
            ln_ope := null;
            ln_sbo := null;
            ln_top := null;
          
          WHEN TOO_MANY_ROWS THEN
            dbms_output.put_line('mas de 1: ' || i.n_cta_bccta || '-' ||
                                 i.n_ope_bcoper);
        end;
      
        begin
          select a.n_mtosobree_bcsdmo
            into ln_monto
            from uai_aclprov a
           where a.n_emp_bcemp = ln_emp
             and a.n_mod_bcmod = ln_mod
             and a.n_suc_bcsuc = ln_suc
             and a.n_mda_bcmda = ln_mda
             and a.n_pap_bcpap = ln_pap
             and a.n_cta_bccta = ln_cta
             and a.n_ope_bcoper = ln_ope
             and a.n_sbop_bcsbop = ln_sbo
             and a.n_tope_bctop = ln_top;
             
        exception
          when no_data_found then
            ln_monto := null;
            WHEN TOO_MANY_ROWS THEN
          dbms_output.put_line('mas de 4214: ' || ln_cta || '-' ||
                                ln_ope || '-' ||ln_mod);  
        end;
      
        update uai_aclprov a
           set a.n_prov117 = ln_monto
         where a.n_emp_bcemp = i.n_emp_bcemp
           and a.n_mod_bcmod = i.n_mod_bcmod
           and a.n_suc_bcsuc = i.n_suc_bcsuc
           and a.n_mda_bcmda = i.n_mda_bcmda
           and a.n_pap_bcpap = i.n_pap_bcpap
           and a.n_cta_bccta = i.n_cta_bccta
           and a.n_ope_bcoper = i.n_ope_bcoper
           and a.n_sbop_bcsbop = i.n_sbop_bcsbop
           and a.n_tope_bctop = i.n_tope_bctop;
      
        commit;
      end loop;
      commit;
    end;
  
    --Actualiza tasa refinanciado, detalle de pago --mod@abr 20161003  
    begin
      for i in creditos_aclpre loop
        ln_ref    := null;
        ln_mtoTot := null;
        ln_mtoCap := null;
        ln_mtoInt := null;
        ln_mtoMor := null;
        ln_mtoSeg := null;
        ln_mtoCom := null;
        ln_mot    := null;
        ln_sut    := null;
        ln_trt    := null;
        ln_rel    := null;
        ld_fet    := null;
        ln_dia    := null; --mod@abr 20170130
        lc_usi    := null; --mod@abr 20170130
      
        pq_datos_acl.Sp_refinanciado(i.n_cta_bccta,
                                     i.n_oper_bcoper,
                                     ln_ref);
        pq_datos_acl.Sp_detalle_deuda(i.n_emp_bcemp,
                                      i.n_mod_bcmod,
                                      i.n_suc_bcsuc,
                                      i.n_mda_bcmda,
                                      i.n_pap_bcpap,
                                      i.n_cta_bccta,
                                      i.n_oper_bcoper,
                                      i.n_sbop_bcsbop,
                                      i.n_tope_bctop,
                                      ld_fecpro,
                                      ln_mtoCap,
                                      ln_mtoInt,
                                      ln_mtoMor,
                                      ln_mtoSeg,
                                      ln_mtoCom,
                                      ln_mtoTot,
                                      ln_mot,
                                      ln_sut,
                                      ln_trt,
                                      ln_rel,
                                      ld_fet,
                                      ln_dia --, --mod@abr 20170130
                                      --lc_usi  --mod@abr 20170130
                                      );
      
        update uai_aclpre a
           set N_TASAREFIN = ln_ref,
               N_MTOTOT    = ln_mtoTot,
               N_MTOCAP    = ln_mtoCap,
               N_MTOINT    = ln_mtoInt,
               N_MTOMOR    = ln_mtoMor,
               N_MTOSEG    = ln_mtoSeg,
               N_MTOCOM    = ln_mtoCom,
               a.n_motxt   = ln_mot,
               a.n_suctxt  = ln_sut,
               a.n_trttxt  = ln_trt,
               a.n_reltxt  = ln_rel,
               a.d_fectxt  = ld_fet,
               N_MORAULT   = ln_dia, --mod@abr 20170130
               C_USUTRAN   = lc_usi --mod@abr 20170130
        
         where a.n_emp_bcemp = i.n_emp_bcemp
           and a.n_mod_bcmod = i.n_mod_bcmod
           and a.n_suc_bcsuc = i.n_suc_bcsuc
           and a.n_mda_bcmda = i.n_mda_bcmda
           and a.n_pap_bcpap = i.n_pap_bcpap
           and a.n_cta_bccta = i.n_cta_bccta
           and a.n_oper_bcoper = i.n_oper_bcoper
           and a.n_sbop_bcsbop = i.n_sbop_bcsbop
           and a.n_tope_bctop = i.n_tope_bctop;
        commit;
      
      end loop;
    
    end;
    -- fin mod@abr 20161003
  
    --mod@abr 20170316
    --DETALLE ULTIMA CUOTA
    begin
    
      insert into JAQZ525_PREDET
        (N_EMP_BCEMP,
         N_MOD_BCMOD,
         N_SUC_BCSUC,
         N_MDA_BCMDA,
         N_PAP_BCPAP,
         N_CTA_BCCTA,
         N_OPER_BCOPER,
         N_SBOP_BCSBOP,
         N_TOPE_BCTOP,
         D_FECPAC,
         D_FECREL,
         N_MTOCAP,
         N_MTOINT,
         N_MTOMOR,
         N_MTOSEG,
         N_MTOCOM,
         N_MOTXT,
         N_SUCTXT,
         N_TRTTXT,
         N_RELTXT,
         D_FECTXT,
         N_MORAULT)
      
        select a.n_emp_bcemp,
               a.n_mod_bcmod,
               a.n_suc_bcsuc,
               a.n_mda_bcmda,
               a.n_pap_bcpap,
               a.n_cta_bccta,
               a.n_oper_bcoper,
               a.n_sbop_bcsbop,
               a.n_tope_bctop,
               b.ppfpag,
               b.pp1fech,
               b.pp1cap,
               b.pp1int,
               (select sum((aa.pp1imp2 + aa.pp1imp3)) --mod@abr 25052020
                  from fsd612 aa
                 where aa.pgcod = a.n_emp_bcemp
                   and aa.ppmod = a.n_mod_bcmod
                   and aa.ppsuc = a.n_suc_bcsuc
                   and aa.ppmda = a.n_mda_bcmda
                   and aa.pppap = a.n_pap_bcpap
                   and aa.ppcta = a.n_cta_bccta
                   and aa.ppoper = a.n_oper_bcoper
                   and aa.ppsbop = a.n_sbop_bcsbop
                   and aa.pptope = a.n_tope_bctop
                   and aa.ppfpag = b.ppfpag
                   and aa.pp1nump = b.pp1nump),
               (select sum((aaa.pp1imp11 + aaa.pp1imp12 + aaa.pp1imp13 +
                           aaa.pp1imp14)) --mod@abr 25052020
                  from fsd612 aaa
                 where aaa.pgcod = a.n_emp_bcemp
                   and aaa.ppmod = a.n_mod_bcmod
                   and aaa.ppsuc = a.n_suc_bcsuc
                   and aaa.ppmda = a.n_mda_bcmda
                   and aaa.pppap = a.n_pap_bcpap
                   and aaa.ppcta = a.n_cta_bccta
                   and aaa.ppoper = a.n_oper_bcoper
                   and aaa.ppsbop = a.n_sbop_bcsbop
                   and aaa.pptope = a.n_tope_bctop
                   and aaa.ppfpag = b.ppfpag
                   and aaa.pp1nump = b.pp1nump),
               (select sum(bb.pp003imp) --mod@abr 25052020
                  from fpp003 bb
                 where bb.pgcod = a.n_emp_bcemp
                   and bb.ppmod = a.n_mod_bcmod
                   and bb.ppsuc = a.n_suc_bcsuc
                   and bb.ppmda = a.n_mda_bcmda
                   and bb.pppap = a.n_pap_bcpap
                   and bb.ppcta = a.n_cta_bccta
                   and bb.ppoper = a.n_oper_bcoper
                   and bb.ppsbop = a.n_sbop_bcsbop
                   and bb.pptope = a.n_tope_bctop
                   and bb.ppfpag = b.ppfpag
                   and bb.pp003nump = b.pp1nump),
               b.d602mo,
               b.d602su,
               b.d602tr,
               b.d602re,
               b.d602fc,
               case
                 when b.d602fc - b.ppfpag < 0 then
                  0
                 else
                  b.d602fc - b.ppfpag
               end
        
          from uai_aclpre a, fsd602 b
         where b.pgcod = a.n_emp_bcemp
           and b.ppmod = a.n_mod_bcmod
           and b.ppsuc = a.n_suc_bcsuc
           and b.ppmda = a.n_mda_bcmda
           and b.pppap = a.n_pap_bcpap
           and b.ppcta = a.n_cta_bccta
           and b.ppoper = a.n_oper_bcoper
           and b.ppsbop = a.n_sbop_bcsbop
           and b.pptope = a.n_tope_bctop
           and b.d602co = 'S'
              --and (b.pp1cap+b.pp1int)<>0  --MOD@ABR 20170601
           and b.ppfpag = (select max(bbb.ppfpag)
                             from fsd602 bbb
                            where bbb.pgcod = b.pgcod
                              and bbb.ppmod = b.ppmod
                              and bbb.ppsuc = b.ppsuc
                              and bbb.ppmda = b.ppmda
                              and bbb.pppap = b.pppap
                              and bbb.ppcta = b.ppcta
                              and bbb.ppoper = b.ppoper
                              and bbb.ppsbop = b.ppsbop
                              and bbb.pptope = b.pptope
                              and bbb.pp1stat = 'T'
                              and bbb.d602co = 'S');
    
      commit;
    
    end;
  
    for i in cursor_Detalle loop
    
      --ln_capP := null;
      --ln_intP := null;
      --ln_moraP := null;
      --Ln_segP := null;
      --Ln_comP := null;
    
      --Ln_motP := null;
      --Ln_sutP := null;
      --Ln_trtP := null;
      --Ln_relP := null;
      --Ld_fetP := null;
      --Ln_morP := null;
      --Lc_usiP := null;
    
      Ln_mtoP := nvl(i.N_MTOCAP, 0) + nvl(i.N_MTOINT, 0) +
                 nvl(i.N_MTOMOR, 0) + nvl(i.N_MTOSEG, 0) +
                 nvl(i.N_MTOCOM, 0);
    
      /*Pq_datos_acl.Sp_detalle_deuda_Par(i.N_EMP_BCEMP  ,
      i.N_MOD_BCMOD  ,
      i.N_SUC_BCSUC  ,
      i.N_MDA_BCMDA  ,
      i.N_PAP_BCPAP  ,
      i.N_CTA_BCCTA  ,
      i.N_OPER_BCOPER,
      i.N_SBOP_BCSBOP,
      i.N_TOPE_BCTOP ,
      i.D_FECPAC,
      i.D_FECREL,
      ld_fecpro,
      ln_capP,
      ln_intP,
      ln_moraP,
      Ln_segP ,
      Ln_comP ,
      Ln_mtoP ,
      Ln_motP ,
      Ln_sutP  ,
      Ln_trtP  ,
      Ln_relP  ,
      Ld_fetP  ,
      Ln_morP --,
      --Lc_usiP 
      );*/
      UPDATE JAQZ525_PREDET a
         set a.n_mtotot = Ln_mtoP /*,
                                a.n_mtocap  = ln_capP,
                                a.n_mtoint  = ln_intP,
                                a.n_mtomor  = ln_moraP,
                                a.n_mtoseg  = Ln_segP,
                                a.n_mtocom  = Ln_comP,
                                a.n_motxt   = Ln_motP,
                                a.n_suctxt  = Ln_sutP,
                                a.n_trttxt  = Ln_trtP,
                                a.n_reltxt  = Ln_relP,
                                a.d_fectxt  = Ld_fetP,
                                a.n_morault = Ln_morP,
                                a.c_usutran = Lc_usiP*/
       where a.n_emp_bcemp = i.N_EMP_BCEMP
         and a.n_mod_bcmod = i.N_MOD_BCMOD
         and a.n_suc_bcsuc = i.N_SUC_BCSUC
         and a.n_mda_bcmda = i.N_MDA_BCMDA
         and a.n_pap_bcpap = i.N_PAP_BCPAP
         and a.n_cta_bccta = i.N_CTA_BCCTA
         and a.n_oper_bcoper = i.N_OPER_BCOPER
         and a.n_sbop_bcsbop = i.N_SBOP_BCSBOP
         and a.n_tope_bctop = i.N_TOPE_BCTOP
         and a.d_fecpac = i.D_FECPAC
         and a.d_fecrel = i.D_FECREL;
    
      commit;
    
      Ln_mtoP := null;
    
    end loop;
    commit;
  
    --GARANTIAS PLAZO FIJO
    begin
    
      begin
        insert into JAQZ525_GARPF
          ( --AGREGADO CAMPOS DE INSERCION 10.01.2019
           N_EMP_R2COD,
           N_MOD_R2MOD,
           N_SUC_R2SUC,
           N_MDA_R2MDA,
           N_PAP_R2PAP,
           N_CTA_R2CTA,
           N_OPE_R2OPER,
           N_SBO_R2SBOP,
           N_TIP_R2TOPE,
           N_EMP_PZOFIJ,
           N_MOD_PZOFIJ,
           N_SUC_PZOFIJ,
           N_MDA_PZOFIJ,
           N_PAP_PZOFIJ,
           N_CTA_PZOFIJ,
           N_OPE_PZOFIJ,
           N_SBO_PZOFIJ,
           N_TIP_PZOFIJ
           
           )
          select a.n_emp_bcemp,
                 a.n_mod_bcmod,
                 a.n_suc_bcsuc,
                 a.n_mda_bcmda,
                 a.n_pap_bcpap,
                 a.n_cta_bccta,
                 a.n_ope_bcoper,
                 a.n_sbop_bcsbop,
                 a.n_tip_bctop,
                 b.r1cod,
                 b.r1mod,
                 b.r1suc,
                 b.r1mda,
                 b.r1pap,
                 b.r1cta,
                 b.r1oper,
                 b.r1sbop,
                 b.r1tope
            from uai_aclgar a, fsr011 b
           where a.n_emp_r2cod = b.r2cod
             and a.n_mod_r2mod = b.r2mod
             and a.n_suc_r2suc = b.r2suc
             and a.n_mda_r2mda = b.r2mda
             and a.n_pap_r2pap = b.r2pap
             and a.n_cta_r2cta = b.r2cta
             and a.n_ope_r2oper = b.r2oper
             and a.n_sbo_r2sbop = b.r2sbop
             and a.n_tip_r2tope = b.r2tope
             and relcod = 2;
      end;
    
      commit;
    end;
    --mod@abr 20170316
  
    --mod@abr 20170410
    /*       ld_fecini := to_date('01'||to_char(ld_fecpro,'mmyyyy'),'ddmmyyyy');
    ld_fecmes := add_months(ld_fecpro,-1);
    insert into JAQZ525_PAGOPRE 
    select t_oper.aomod N_MOD_BCMOD,
            t_oper.aomda  N_MDA_BCMDA,
            t_oper.aocta  N_CTA_BCCTA,
            t_oper.aooper N_OPER_BCOPER,
            t_oper.aotope N_TOPE_BCTOP,
            max(t_hist.bcrubr) N_RUBR_BCRUBR,
            t_oper.aofe99 fecha_cancel,
            
            t_oper.pgcod,
            t_oper.aomod,
            t_oper.aosuc,
            t_oper.aomda,
            t_oper.aopap,
            t_oper.aocta,
            t_oper.aooper,
            t_oper.aosbop,
            t_oper.aotope
     from fsd010 t_oper,
          fsh012 t_hist
     where t_oper.aostat = 99
           and (t_oper.aofe99 >= ld_fecini and
                t_oper.aofe99 <= ld_fecpro)
           and t_oper.aocta <> 999999999     
           and (t_oper.aomod >= 101 and t_oper.aomod <= 116)
           
           
           and t_hist.bcemp = t_oper.pgcod
           and t_hist.bcfech = ld_fecmes
           and t_hist.bcsuc = t_oper.aosuc
           and t_hist.bcmda = t_oper.aomda
           and t_hist.bcpap = t_oper.aopap
           and t_hist.bccta = t_oper.aocta
           and t_hist.bcoper = t_oper.aooper
           and t_hist.bcsbop = t_oper.aosbop
           and t_hist.bctop = t_oper.aotope
    
     group by t_oper.pgcod,
            t_oper.aomod,
            t_oper.aosuc,
            t_oper.aomda,
            t_oper.aopap,
            t_oper.aocta,
            t_oper.aooper,
            t_oper.aosbop,
            t_oper.aotope,
            t_oper.aofe99;
            
      commit;
      
      for i in modulo loop 
              INSERT INTO JAQZ525_PAGOPRE2
              select *
                 from fsh016 t_deta
                 where t_deta.pgcod = 1
                       --and t_deta.hcmod in (30, 490, 493, 66, 140, 116)
                       and t_deta.hcmod = i.tp1nro1
                       and t_deta.hfcon > ld_fecmes
                       
                       and exists (select 1
                                   from JAQZ525_PAGOPRE t_bas1
                                   where t_bas1.pgcod = 1
                                         and t_bas1.aocta = t_deta.hcta
                                         and t_bas1.aooper = t_deta.hoper
                                         and t_bas1.AOFE99 = t_deta.hfcon
                                  );
            
            commit;
    end loop;
    commit;
        
    INSERT INTO JAQZ525_PAGO
    select  t_bas1.pgcod,
            t_bas1.aomod,
            t_bas1.aosuc,
            t_bas1.aomda,
            t_bas1.aopap,
            t_bas1.aocta,
            t_bas1.aooper,
            t_bas1.aosbop,
            t_bas1.aotope,
            t_bas1.n_rubr_bcrubr,
            t_bas1.aofe99,
            sum(case when t_bas2.hcimp6 = 0 then t_bas2.hcimp1 + t_bas2.hcimp2 + t_bas2.hcimp3 + t_bas2.hcimp4 + t_bas2.hcimp5
                                        else t_bas2.hcimp6
                                        end)  Monto_cancelado,
            t_bas2.hsucor cod_age,
            t_cabe.husing Usuario,
            t_cabe.hhora
            
     from JAQZ525_PAGOPRE t_bas1,
          JAQZ525_PAGOPRE2 t_bas2,
          fsh015 t_cabe
     where t_bas2.pgcod = t_bas1.pgcod
           and t_bas2.hsucur = t_bas1.aosuc
           and t_bas2.hmodul = t_bas1.aomod
           and t_bas2.hmda = t_bas1.aomda
           and t_bas2.hpap = t_bas1.aopap
           and t_bas2.hcta = t_bas1.aocta
           and t_bas2.hoper = t_bas1.aooper
           and t_bas2.htoper(+) = t_bas1.aotope
           and t_cabe.pgcod = t_bas2.pgcod
           and t_cabe.hcmod = t_bas2.hcmod
           and t_cabe.hsucor = t_bas2.hsucor
           and t_cabe.htran = t_bas2.htran
           and t_cabe.hnrel = t_bas2.hnrel
           and t_cabe.hfcon = t_bas2.hfcon
           and t_cabe.hccorr <> 99
     group by t_bas1.n_mod_bcmod,
            t_bas1.n_mda_bcmda,
            t_bas1.n_cta_bccta,
            t_bas1.n_oper_bcoper,
            t_bas1.n_tope_bctop,
            t_bas1.n_rubr_bcrubr,
            t_bas1.pgcod,
            t_bas1.aomod,
            t_bas1.aosuc,
            t_bas1.aomda,
            t_bas1.aopap,
            t_bas1.aocta,
            t_bas1.aooper,
            t_bas1.aosbop,
            t_bas1.aotope,
            t_bas1.aofe99,
            t_bas2.hsucor,
            t_cabe.husing,
            t_cabe.hhora;
            
            commit;*/
    --mod@abr 20170410      
  end SP_Otras_estructuras;

  ---------------------------Modificaciones 2016.01.27---------------------------
  Function Fn_cliente_corp(pn_pai in number,
                           pn_tdo in number,
                           pc_ndo in char) return number is
    ln_corp number(4);
  begin
  
    begin
      select a.sngc11cmb2
        into ln_corp
        from sngc11 a
       where a.sngc11pais = pn_pai --i.n_pais_pepais
         and a.sngc11tdoc = pn_tdo --i.n_tdoc_petdoc
         and a.sngc11ndoc = pc_ndo --i.c_ndoc_pendoc
         and rownum = 1;
    exception
      when no_data_found then
        ln_corp := null;
    end;
    return ln_corp;
  end Fn_cliente_corp;

  Function Fn_monto_aprobado(pn_ins  in number,
                             pn_cta  in number,
                             pn_oper in number) return number is
    ln_monto number(17, 2);
    ln_mod   number(3);
    ln_suc   number(3);
    ln_mda   number(4);
    ln_pap   number(4);
    ln_cta   number(9);
    ln_ope   number(9);
    ln_sbo   number(3);
    ln_top   number(3);
    ln_ins   number(10);
  begin
    begin
      select a.sng120mto
        into ln_monto
        from sng120 a
       where a.sng120ins = pn_ins --i.n_instancia_xwfprcins
         and a.sng120tsk like 'APROBACION%'
         and rownum = 1;
    exception
      when no_data_found then
        begin
          select distinct a.aomod,
                          a.aosuc,
                          a.aomda,
                          a.aopap,
                          a.aocta,
                          a.aooper,
                          a.aosbop,
                          a.aotope
            into ln_mod,
                 ln_suc,
                 ln_mda,
                 ln_pap,
                 ln_cta,
                 ln_ope,
                 ln_sbo,
                 ln_top
            from fsd010 a
           where a.aocta = pn_cta --i.n_cta_bccta
             and a.aooper = pn_oper --i.n_ope_bcoper
             and a.aomod in (select modulo from fst111 where dscod = 50)
             and a.aosbop =
                 (select min(aa.aosbop)
                    from fsd010 aa
                   where aa.aocta = a.aocta
                     and aa.aooper = a.aooper
                     and aa.aomod in
                         (select modulo from fst111 where dscod = 50)
                     and aa.aomod not in (200, 33, 65, 117)
                     and aotope <> 550)
                /*and a.aofval = (select min(aa.aofval)
                                 from fsd010 aa
                                where aa.aocta  = a.aocta 
                                  and aa.aooper = a.aooper
                                  and aa.aomod in (select modulo from fst111 where dscod = 50))
                */
             and aomod not in (200, 33, 65, 117)
             and aotope <> 550
          --and rownum = 1
          ;
        exception
          when no_data_found then
          
            ln_mod := null;
            ln_suc := null;
            ln_mda := null;
            ln_pap := null;
            ln_cta := null;
            ln_ope := null;
            ln_sbo := null;
            ln_top := null;
        end;
        ln_ins := fn_instancia_credito(ln_mod,
                                       ln_suc,
                                       ln_mda,
                                       ln_pap,
                                       ln_cta,
                                       ln_ope,
                                       ln_sbo,
                                       ln_top);
        begin
          select a.sng120mto
            into ln_monto
            from sng120 a
           where a.sng120ins = ln_ins
             and a.sng120tsk like 'APROBACION%'
             and rownum = 1;
        exception
          when no_data_found then
            ln_monto := null;
        end;
    end;
    return ln_monto;
  end Fn_monto_aprobado;

  Function Fn_promotor(pn_ins in number) return char is
    lc_promotor char(10);
  begin
    begin
      select a.sng001usc
        into lc_promotor
        from sng001 a
       where a.sng001inst = pn_ins --i.n_instancia_xwfprcins
         and a.sng015cod = 1
         and rownum = 1;
    exception
      when no_data_found then
        lc_promotor := null;
    end;
    return lc_promotor;
  end Fn_promotor;

  Function Fn_cuotasParc(pn_emp in number,
                         pn_mod in number,
                         pn_suc in number,
                         pn_mda in number,
                         pn_pap in number,
                         pn_cta in number,
                         pn_ope in number,
                         pn_sbo in number,
                         pn_top in number) return char is
    lc_parcial char(1);
  begin
    begin
      select 'S'
        into lc_parcial
        from fsd602 a
       where a.pgcod = pn_emp --i.n_emp_bcemp
         and a.ppmod = pn_mod --i.n_mod_bcmod
         and a.ppsuc = pn_suc --i.n_suc_bcsuc
         and a.ppmda = pn_mda --i.n_mda_bcmda
         and a.pppap = pn_pap --i.n_pap_bcpap
         and a.ppcta = pn_cta --i.n_cta_bccta
         and a.ppoper = pn_ope --i.n_ope_bcoper
         and a.ppsbop = pn_sbo --i.n_sbop_bcsbop
         and a.pptope = pn_top --i.n_tope_bctop
         and a.d602co = 'S'
         and a.pp1stat <> 'T'
         and a.ppfpag = (select max(aa.ppfpag)
                           from fsd602 aa
                          where aa.pgcod = a.pgcod
                            and aa.ppmod = a.ppmod
                            and aa.ppsuc = a.ppsuc
                            and aa.ppmda = a.ppmda
                            and aa.pppap = a.pppap
                            and aa.ppcta = a.ppcta
                            and aa.ppoper = a.ppoper
                            and aa.ppsbop = a.ppsbop
                            and aa.pptope = a.pptope
                            and rownum = 1)
         and rownum = 1;
    exception
      when no_data_found then
        lc_parcial := 'N';
    end;
    return lc_parcial;
  end Fn_cuotasParc;

  Function Fn_fecTran116(pn_emp in number,
                         pn_mod in number,
                         pn_suc in number,
                         pn_mda in number,
                         pn_pap in number,
                         pn_cta in number,
                         pn_ope in number,
                         pn_sbo in number,
                         pn_top in number) return date is
    ld_fec date;
  begin
    begin
      if pn_mod = 116 then
        begin
        
          select max(a.d602fc)
            into ld_fec
            from fsd602 a
           where a.pgcod = pn_emp --i.n_emp_bcemp  
             and a.ppmod = pn_mod --i.n_mod_bcmod  
             and a.ppsuc = pn_suc --i.n_suc_bcsuc  
             and a.ppmda = pn_mda --i.n_mda_bcmda  
             and a.pppap = pn_pap --i.n_pap_bcpap  
             and a.ppcta = pn_cta --i.n_cta_bccta  
             and a.ppoper = pn_ope --i.n_ope_bcoper 
             and a.ppsbop = pn_sbo --i.n_sbop_bcsbop
             and a.pptope = pn_top --i.n_tope_bctop 
             and a.d602mo = 116
             and a.d602tr = 60
             and a.d602co = 'S'
             and a.d602fc <= to_date('2015.12.31', 'yyyy.mm.dd');
        exception
          when others then
            ld_fec := null;
        end;
      
      else
        ld_fec := null;
      end if;
    end;
    return ld_fec;
  end Fn_fecTran116;

  Function Fn_tipo_solicitud(pn_ins in number) return number is
    ln_ori number(2);
  begin
    begin
      select a.sng001ori
        into ln_ori
        from sng001 a
       where a.sng001inst = pn_ins --i.n_instancia_xwfprcins
         and rownum = 1;
    exception
      when others then
        ln_ori := null;
    end;
    return ln_ori;
  end Fn_tipo_solicitud;

  --mod 20161003@abr
  Procedure Sp_refinanciado(pn_cta  in number,
                            pn_ope  in number,
                            pn_tasa out number) is
    ln_sboMin number(3);
    ld_fva    date;
    ln_emp    number(3);
    ln_mod    number(3);
    ln_suc    number(3);
    ln_mda    number(4);
    ln_pap    number(4);
    ln_cta    number(9);
    ln_ope    number(9);
    ln_sbo    number(3);
    ln_top    number(3);
  
  begin
    begin
      select min(aosbop)
        into ln_sboMin
        from fsd010 a
       where a.aocta = pn_cta
         and a.aooper = pn_ope;
    exception
      when others then
        null;
    end;
  
    begin
      select min(aofval)
        into ld_fva
        from fsd010 a
       where a.aocta = pn_cta
         and a.aooper = pn_ope
         and a.aosbop = ln_sboMin;
    exception
      when others then
        null;
    end;
  
    begin
      select pgcod,
             aomod,
             aosuc,
             aomda,
             aopap,
             aocta,
             aooper,
             aosbop,
             aotope
        into ln_emp,
             ln_mod,
             ln_suc,
             ln_mda,
             ln_pap,
             ln_cta,
             ln_ope,
             ln_sbo,
             ln_top
        from fsd010 a
       where a.aocta = pn_cta
         and a.aooper = pn_ope
         and a.aosbop = ln_sboMin;
    exception
      when others then
        null;
    end;
  
    begin
      select a.aotasa
        into pn_tasa
        from fsd010 a
       where a.pgcod = ln_emp
         and a.aomod = ln_mod
         and a.aosuc = ln_suc
         and a.aomda = ln_mda
         and a.aopap = ln_pap
         and a.aocta = ln_cta
         and a.aooper = ln_ope
         and a.aosbop = ln_sbo
         and a.aotope = ln_top;
    exception
      when others then
        null;
    end;
  
  end Sp_refinanciado;

  Procedure Sp_detalle_deuda(pn_emp    in number,
                             pn_mod    in number,
                             pn_suc    in number,
                             pn_mda    in number,
                             pn_pap    in number,
                             pn_cta    in number,
                             pn_oper   in number,
                             pn_sbop   in number,
                             pn_top    in number,
                             pd_fecpro in date,
                             pn_cap    out number,
                             pn_int    out number,
                             pn_mora   out number,
                             pn_seg    out number,
                             pn_com    out number,
                             pn_mto    out number,
                             pn_mot    out number,
                             pn_sut    out number,
                             pn_trt    out number,
                             pn_rel    out number,
                             pd_fet    out date,
                             pn_mor    out number /*,pc_usi out char*/ --mod@abr 20170131
                             ) is
  
    ld_fecpag date;
    ln_num    number(9);
  
  begin
    begin
      select max(o.ppfpag)
        into ld_fecpag
        from fsd602 o
       where o.pgcod = pn_emp
         and o.ppmod = pn_mod
         and o.ppsuc = pn_suc
         and o.ppmda = pn_mda
         and o.pppap = pn_pap
         and o.ppcta = pn_cta
         and o.ppoper = pn_oper
         and o.ppsbop = pn_sbop
         and o.pptope = pn_top
         and o.pp1fech <= pd_fecpro
         and o.pp1stat = 'T'
         and o.d602co = 'S'
         and (o.pp1cap + o.pp1int) <> 0;
    exception
      when others then
        null;
    end;
  
    begin
      select o.pp1cap,
             o.pp1int,
             o.pp1nump,
             o.d602mo,
             o.d602su,
             o.d602tr,
             o.d602re,
             o.d602fc
        into pn_cap, pn_int, ln_num, pn_mot, pn_sut, pn_trt, pn_rel, pd_fet
        from fsd602 o
       where o.pgcod = pn_emp
         and o.ppmod = pn_mod
         and o.ppsuc = pn_suc
         and o.ppmda = pn_mda
         and o.pppap = pn_pap
         and o.ppcta = pn_cta
         and o.ppoper = pn_oper
         and o.ppsbop = pn_sbop
         and o.pptope = pn_top
         and o.ppfpag = ld_fecpag
         and o.pp1stat = 'T'
         and o.d602co = 'S'
         and (o.pp1cap + o.pp1int) <> 0;
    exception
      when others then
        null;
    end;
  
    --mod@abr 20170131
    --dias de atraso de la ultima cuota pagada
    if ld_fecpag is null then
      pn_mor := 0;
    
    else
      pn_mor := pd_fet - ld_fecpag; --pd_fecpro - ld_fecpag; MOD@ABR 20170601
      if pn_mor < 0 then
        pn_mor := 0;
      end if;
    end if;
  
    --usuario que realizo el pago
  
    /*begin
         select a.husing
           into pc_usi
           from fsh015 a
          where a.pgcod  = 1
            and a.hcmod  = pn_mot
            and a.hsucor = pn_sut
            and a.htran  = pn_trt
            and a.hnrel  = pn_rel
            and a.hfcon  = pd_fet;
    exception
      when others then null;
    end;*/
  
    --mod@abr 20170131    
  
    begin
      select (a.pp1imp2 + a.pp1imp3),
             (a.pp1imp11 + a.pp1imp12 + a.pp1imp13 + a.pp1imp14)
        into pn_mora, pn_seg
        from fsd612 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_oper
         and a.ppsbop = pn_sbop
         and a.pptope = pn_top
         and a.ppfpag = ld_fecpag
         and a.pp1nump = ln_num;
    exception
      when others then
        null;
    end;
  
    begin
      select a.pp003imp
        into pn_com
        from fpp003 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_oper
         and a.ppsbop = pn_sbop
         and a.pptope = pn_top
         and a.ppfpag = ld_fecpag
         and a.pp003nump = ln_num;
    exception
      when others then
        null;
    end;
  
    pn_mto := nvl(pn_cap, 0) + nvl(pn_int, 0) + nvl(pn_mora, 0) +
              nvl(pn_seg, 0) + nvl(pn_com, 0);
  
  end Sp_detalle_deuda;

  --mod@abr 20170317
  Procedure Sp_detalle_deuda_Par(pn_emp    in number,
                                 pn_mod    in number,
                                 pn_suc    in number,
                                 pn_mda    in number,
                                 pn_pap    in number,
                                 pn_cta    in number,
                                 pn_oper   in number,
                                 pn_sbop   in number,
                                 pn_top    in number,
                                 pd_fecpag in date,
                                 pd_pp1fec in date,
                                 pd_fecpro in date,
                                 pn_cap    out number,
                                 pn_int    out number,
                                 pn_mora   out number,
                                 pn_seg    out number,
                                 pn_com    out number,
                                 pn_mto    out number,
                                 pn_mot    out number,
                                 pn_sut    out number,
                                 pn_trt    out number,
                                 pn_rel    out number,
                                 pd_fet    out date,
                                 pn_mor    out number /*,pc_usi out char*/) is
  
    ln_num number(9);
  
  begin
  
    begin
      select o.pp1cap,
             o.pp1int,
             o.pp1nump,
             o.d602mo,
             o.d602su,
             o.d602tr,
             o.d602re,
             o.d602fc
        into pn_cap, pn_int, ln_num, pn_mot, pn_sut, pn_trt, pn_rel, pd_fet
        from fsd602 o
       where o.pgcod = pn_emp
         and o.ppmod = pn_mod
         and o.ppsuc = pn_suc
         and o.ppmda = pn_mda
         and o.pppap = pn_pap
         and o.ppcta = pn_cta
         and o.ppoper = pn_oper
         and o.ppsbop = pn_sbop
         and o.pptope = pn_top
         and o.ppfpag = pd_fecpag
         and o.pp1fech = pd_pp1fec
            --and o.pp1stat = 'T'
         and o.d602co = 'S'
      --and (o.pp1cap+o.pp1int)<>0
      ;
    exception
      when others then
        null;
    end;
  
    --mod@abr 20170131
    --dias de atraso de la ultima cuota pagada
    if pd_fecpag is null then
      pn_mor := 0;
    
    else
      pn_mor := pd_fet - pd_fecpag; --pd_fecpro - pd_fecpag; 20170601
      if pn_mor < 0 then
        pn_mor := 0;
      end if;
    end if;
  
    --usuario que realizo el pago
  
    /*begin
         select a.husing
           into pc_usi
           from fsh015 a
          where a.pgcod  = 1
            and a.hcmod  = pn_mot
            and a.hsucor = pn_sut
            and a.htran  = pn_trt
            and a.hnrel  = pn_rel
            and a.hfcon  = pd_fet;
    exception
      when others then null;
    end;
    */
    --mod@abr 20170131    
  
    begin
      select (a.pp1imp2 + a.pp1imp3),
             (a.pp1imp11 + a.pp1imp12 + a.pp1imp13 + a.pp1imp14)
        into pn_mora, pn_seg
        from fsd612 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_oper
         and a.ppsbop = pn_sbop
         and a.pptope = pn_top
         and a.ppfpag = pd_fecpag
         and a.pp1nump = ln_num;
    exception
      when others then
        null;
    end;
  
    begin
      select a.pp003imp
        into pn_com
        from fpp003 a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_oper
         and a.ppsbop = pn_sbop
         and a.pptope = pn_top
         and a.ppfpag = pd_fecpag;
    exception
      when others then
        null;
    end;
  
    pn_mto := nvl(pn_cap, 0) + nvl(pn_int, 0) + nvl(pn_mora, 0) +
              nvl(pn_seg, 0) + nvl(pn_com, 0);
  
  end Sp_detalle_deuda_Par;
  --mod@abr 20170317

  --mod@abr 20170505
  Procedure sp_job_usuario is
    --ln_max number;
    --ln_inc number;
    ln_ini number;
    --ln_fin number;
    i           number;
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_hostname varchar2(64);
    ln_limit    number := 0;
    ln_numjob   number := 0;
    --lc_coderr varchar2(300);
    cursor sucursal is
      select sucurs from fst001 where pgcod = 1;
  begin
    begin
      select host_name into lc_hostname from v$instance;
    end;
    delete Tab_jobs where c_Codage = 'USU';
    commit;
    
    --apachecoh 2024.02.09
    --Limite de JOBS parametrizado en guia
    begin
      select tp1nro1
        into ln_limit
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11169
         and tp1corr1 = 11
         and tp1corr2 = 1
         and tp1corr3 = 1;
    exception
      when others then
        ln_limit := 20;
    end;
    
    for i in sucursal loop
      ln_ini      := i.sucurs;
      lc_variable := ' begin ' || '  pq_datos_acl.sp_usuario(' || ln_ini || ');' ||
                     ' End; ';
      ln_job      := ln_job + 1;
      --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
      --        if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then   
      --        if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 180),
                        interval  => null,
                        no_parse  => false,
                        instance  => 1,
                        -- instance  => 2, 01/01/2024
                        force     => false);
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 180),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      end if;
      
      --apachecoh 2024.02.09  
      BEGIN
        SELECT count(*)
          INTO ln_numjob
          FROM dba_jobs x
         WHERE upper(x.what) LIKE '%PQ_DATOS_ACL.SP_USUARIO%';
      EXCEPTION
        WHEN OTHERS THEN
          ln_numjob := 0;
      END;
    
      WHILE ln_numjob > ln_limit LOOP
        BEGIN
          SELECT count(*)
            INTO ln_numjob
            FROM dba_jobs x
           WHERE upper(x.what) LIKE
                 '%PQ_DATOS_ACL.SP_USUARIO%';
        EXCEPTION
          WHEN OTHERS THEN
            ln_numjob := 0;
        END;
      END LOOP;
      
      INSERT INTO Tab_jobs
        (c_Codage, n_Numer1, c_detjob)
      VALUES
        ('USU', ln_ini, lc_variable);
      COMMIT;
    end loop;
  
  exception
    when others then
      --lc_coderr:=sqlerrm;
      INSERT INTO LOG_ERROR_BANDEJA
        (N_NRO, C_CODBDJ, C_DESERR, D_FECERR)
      VALUES
        (0, 'USU', lc_variable, TRUNC(SYSDATE));
      COMMIT;
      --          p_c_error:=  lc_variable;
  
  end sp_job_usuario;

  Procedure sp_usuario(pn_numsuc in number) is
  
    lc_coderr varchar2(300);
    cursor creditos is
      select * from uai_aclpre a where a.n_suc_bcsuc = pn_numsuc;
    pc_usi  char(10);
    pc_hora char(8);
    ln_empDes number(3);
    ln_modDes number(3);
    ln_sucDes number(3);
    ln_traDes number(3);
    ln_relDes number(4);
    ln_fecDes date;
    
  begin
  
    update tab_jobs g
       set g.d_fecini = sysdate
     where g.n_numer1 = pn_numsuc
       and g.c_codage = 'USU';
    commit;
  
    for i in creditos loop
      pc_usi := null;
      begin
        select /*+index( a SYS_C00977884)*/
         a.husing--, a.hhora --mod@abr 2010522 --mod@abr 20210625
          into pc_usi--, pc_hora --mod@abr 20210625
          from fsh015 a
         where a.pgcod = 1
           and a.hcmod = i.n_motxt
           and a.hsucor = i.n_suctxt
           and a.htran = i.n_trttxt
           and a.hnrel = i.n_reltxt
           and a.hfcon = i.d_fectxt;
      exception
        when others then
          null;
      end;
      
      begin
        select a.d601cd,a.d601mo,a.d601su,a.d601tr,a.d601re,a.d601fc --mod@abr 20210625
          into ln_empDes,
               ln_modDes,
               ln_sucDes,
               ln_traDes,
               ln_relDes,
               ln_fecDes
          from fsd601 a
         where a.pgcod  = i.n_emp_bcemp
           and a.ppmod  = i.n_mod_bcmod
           and a.ppsuc  = i.n_suc_bcsuc
           and a.ppmda  = i.n_mda_bcmda
           and a.pppap  = i.n_pap_bcpap
           and a.ppcta  = i.n_cta_bccta
           and a.ppoper = i.n_oper_bcoper
           and a.ppsbop = i.n_sbop_bcsbop
           and a.pptope = i.n_tope_bctop
           and a.ppfpag = (select min(a.ppfpag)
                            from fsd601 a
                           where a.pgcod  = i.n_emp_bcemp
                             and a.ppmod  = i.n_mod_bcmod
                             and a.ppsuc  = i.n_suc_bcsuc
                             and a.ppmda  = i.n_mda_bcmda
                             and a.pppap  = i.n_pap_bcpap
                             and a.ppcta  = i.n_cta_bccta
                             and a.ppoper = i.n_oper_bcoper
                             and a.ppsbop = i.n_sbop_bcsbop
                             and a.pptope = i.n_tope_bctop);
      exception
        when others then null;
      end;
      
      begin
        select /*+index( a SYS_C00977884)*/
               a.hhora --mod@abr 20210625
          into pc_hora
          from fsh015 a
         where a.pgcod = ln_empDes
           and a.hcmod = ln_modDes
           and a.hsucor =ln_sucDes
           and a.htran = ln_traDes
           and a.hnrel = ln_relDes
           and a.hfcon = ln_fecDes;
      exception
        when others then
          null;
      end;  
    
      begin
        update uai_aclpre a
           set a.c_usutran = pc_usi, a.c_deshora = pc_hora --mod@abr 2010522
         where a.n_emp_bcemp = i.n_emp_bcemp
           and a.n_mod_bcmod = i.n_mod_bcmod
           and a.n_suc_bcsuc = i.n_suc_bcsuc
           and a.n_mda_bcmda = i.n_mda_bcmda
           and a.n_pap_bcpap = i.n_pap_bcpap
           and a.n_cta_bccta = i.n_cta_bccta
           and a.n_oper_bcoper = i.n_oper_bcoper
           and a.n_sbop_bcsbop = i.n_sbop_bcsbop
           and a.n_tope_bctop = i.n_tope_bctop;
      
        commit;
      exception
        when others then
          lc_coderr := sqlerrm;
          INSERT INTO LOG_ERROR_BANDEJA
            (N_NRO, C_CODBDJ, C_DESERR, D_FECERR)
          VALUES
            (0, 'USU', pn_numsuc || lc_coderr, TRUNC(SYSDATE));
          COMMIT;
      end;
      commit;
    end loop;
  
    commit;
    update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 = pn_numsuc
       and g.c_codage = 'USU';
    commit;
  EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm, 1, 200);
      update tab_jobs g
         set g.c_inderr = 'S', g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'USU';
      commit;
    
      return;
    
  end sp_usuario;

  Procedure sp_job_usuario_II is
    --ln_max number;
    --ln_inc number;
    ln_ini number;
    --ln_fin number;
    i           number;
    lc_variable varchar2(1000);
    ln_job      number := 0;
    lc_hostname varchar2(64);
    ln_limit    number := 0;
    ln_numjob   number := 0;
    --lc_coderr varchar2(300);
    cursor sucursal is
      select sucurs from fst001 where pgcod = 1;
  begin
    begin
      select host_name into lc_hostname from v$instance;
    end; 
    delete Tab_jobs where c_Codage = 'USUV';
    commit;
    
    --apachecoh 2024.02.09
    --Limite de JOBS parametrizado en guia
    begin
      select tp1nro1
        into ln_limit
        from fst198
       where tp1cod = 1
         and tp1cod1 = 11169
         and tp1corr1 = 11
         and tp1corr2 = 1
         and tp1corr3 = 1;
    exception
      when others then
        ln_limit := 20;
    end;
    for i in sucursal loop
      ln_ini      := i.sucurs;
      lc_variable := ' begin ' || '  pq_datos_acl.sp_usuario_ii(' || ln_ini || ');' ||
                     ' End; ';
      ln_job      := ln_job + 1;
      --DBMS_JOB.SUBMIT(ln_job, lc_variable, sysdate+1/(24*180));
      --        if  UPPER(lc_hostname) in ('BTRAC2051','BTRAC2052')  then   
      --        if  UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101')  then
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 180),
                        interval  => null,
                        no_parse  => false,
                        instance  => 1,
                        --instance  => 2, 01/01/2024
                        force     => false);
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 180),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      end if;
      
      --apachecoh 2024.02.09  
      BEGIN
        SELECT count(*)
          INTO ln_numjob
          FROM dba_jobs x
         WHERE upper(x.what) LIKE '%PQ_DATOS_ACL.SP_USUARIO_II%';
      EXCEPTION
        WHEN OTHERS THEN
          ln_numjob := 0;
      END;
    
      WHILE ln_numjob > ln_limit LOOP
        BEGIN
          SELECT count(*)
            INTO ln_numjob
            FROM dba_jobs x
           WHERE upper(x.what) LIKE
                 '%PQ_DATOS_ACL.SP_USUARIO_II%';
        EXCEPTION
          WHEN OTHERS THEN
            ln_numjob := 0;
        END;
      END LOOP;
      
      INSERT INTO Tab_jobs
        (c_Codage, n_Numer1, c_detjob)
      VALUES
        ('USUV', ln_ini, lc_variable);
      COMMIT;
    end loop;
  
  exception
    when others then
      --lc_coderr:=sqlerrm;
      INSERT INTO LOG_ERROR_BANDEJA
        (N_NRO, C_CODBDJ, C_DESERR, D_FECERR)
      VALUES
        (0, 'USUV', lc_variable, TRUNC(SYSDATE));
      COMMIT;
      --          p_c_error:=  lc_variable;
  
  end sp_job_usuario_II;

  Procedure sp_usuario_ii(pn_numsuc in number) is
  
    lc_coderr varchar2(300);
    cursor cursor_Detalle is
      select * from JAQZ525_PREDET A WHERE A.N_SUC_BCSUC = pn_numsuc;
    pc_usi  char(10);
    pc_hora char(8);
  begin
  
    update tab_jobs g
       set g.d_fecini = sysdate
     where g.n_numer1 = pn_numsuc
       and g.c_codage = 'USUV';
    commit;
  
    for i in cursor_Detalle loop
      pc_usi := null;
      begin
        select a.husing, a.hhora
          into pc_usi, pc_hora --mod@abr 2010522
          from fsh015 a
         where a.pgcod = 1
           and a.hcmod = i.n_motxt
           and a.hsucor = i.n_suctxt
           and a.htran = i.n_trttxt
           and a.hnrel = i.n_reltxt
           and a.hfcon = i.d_fectxt;
      exception
        when others then
          null;
      end;
    
      begin
        UPDATE JAQZ525_PREDET a
           set a.c_usutran = pc_usi, a.c_deshora = pc_hora --mod@abr 2010522
         where a.n_emp_bcemp = i.N_EMP_BCEMP
           and a.n_mod_bcmod = i.N_MOD_BCMOD
           and a.n_suc_bcsuc = i.N_SUC_BCSUC
           and a.n_mda_bcmda = i.N_MDA_BCMDA
           and a.n_pap_bcpap = i.N_PAP_BCPAP
           and a.n_cta_bccta = i.N_CTA_BCCTA
           and a.n_oper_bcoper = i.N_OPER_BCOPER
           and a.n_sbop_bcsbop = i.N_SBOP_BCSBOP
           and a.n_tope_bctop = i.N_TOPE_BCTOP
           and a.d_fecpac = i.D_FECPAC
           and a.d_fecrel = i.D_FECREL;
      
        commit;
      exception
        when others then
          lc_coderr := sqlerrm;
          INSERT INTO LOG_ERROR_BANDEJA
            (N_NRO, C_CODBDJ, C_DESERR, D_FECERR)
          VALUES
            (0, 'USUV', pn_numsuc || lc_coderr, TRUNC(SYSDATE));
          COMMIT;
      end;
      commit;
    end loop;
  
    commit;
    update tab_jobs g
       set g.d_fecfin = sysdate
     where g.n_numer1 = pn_numsuc
       and g.c_codage = 'USUV';
    commit;
  EXCEPTION
    when others then
      lc_coderr := substr(sqlerrm, 1, 200);
      update tab_jobs g
         set g.c_inderr = 'S', g.c_deserr = lc_coderr
       where g.n_numer1 = pn_numsuc
         and g.c_codage = 'USUV';
      commit;
    
      return;
    
  end sp_usuario_ii;
  --fin mod @abr 20170505

--dcastro
  function fn_por_fondo(   pn_cta    in number,
                           pn_oper   in number,
                           pd_fecpro in date) return number is
    ln_porfondo number;


  begin

    --reactiva
    begin
      select t.aqpb065bpcob 
        into ln_porfondo
       from aqpb065b t
      where
      t.aqpb065bcta = pn_cta  --677872         3159282
      and t.aqpb065bope = pn_oper  ---9300174   9962117
      and t.aqpb065bmod <> 0
      and t.aqpb065bpcob <> 0
      and t.aqpb065bfec <= pd_fecpro
      and t.aqpb065best <> 'D'
      and t.aqpb065bcor = (select max(j.aqpb065bcor)
                          from aqpb065b j
                         where j.aqpb065bcod = t.aqpb065bcod
                           and j.aqpb065bmod = t.aqpb065bmod
                           and j.aqpb065bsuc = t.aqpb065bsuc
                           and j.aqpb065bmda = t.aqpb065bmda
                           and j.aqpb065bpap = t.aqpb065bpap
                           and j.aqpb065bcta = t.aqpb065bcta
                           and j.aqpb065bope = t.aqpb065bope
                           and j.aqpb065btop = t.aqpb065btop
                           and j.aqpb065bfec <= pd_fecpro
                           and j.aqpb065best <> 'D')
      order by t.aqpb065bfec desc, t.aqpb065bcor desc;      
    exception when others then
       ln_porfondo := null;
    end;
    
    if ln_porfondo is null then
        --fae
      begin  
        select  t.aqpb067bpcob --- Porcentaje cobertura
           into ln_porfondo
          from aqpb067b t
        where t.aqpb067bcta = pn_cta ---2674673
           and t.aqpb067bope = pn_oper ----8552279
           and t.aqpb067bfec <= pd_fecpro
           and t.aqpb067best <> 'D'
           and t.aqpb067bmod <> 0
           and t.aqpb067bpcob <> 0
           and t.aqpb067bcor = (select max(j.aqpb067bcor)
                                  from aqpb067b j
                                 where j.aqpb067bcod = t.aqpb067bcod
                                   and j.aqpb067bmod = t.aqpb067bmod
                                   and j.aqpb067bsuc = t.aqpb067bsuc
                                   and j.aqpb067bmda = t.aqpb067bmda
                                   and j.aqpb067bpap = t.aqpb067bpap
                                   and j.aqpb067bcta = t.aqpb067bcta
                                   and j.aqpb067bope = t.aqpb067bope
                                   and j.aqpb067btop = t.aqpb067btop
                                   and j.aqpb067bfec <= pd_fecpro
                                   and j.aqpb067best <> 'D')
          order by t.aqpb067bfec desc, t.aqpb067bcor desc;
       exception when others then
           ln_porfondo := null;
       end;

       if ln_porfondo is null then

         --crecer
         begin    
          select t.aqpb073bpcob
            into ln_porfondo
            from aqpb073b t
          where 
              t.aqpb073bcta = pn_cta   --- 2521433
              and t.aqpb073bope = pn_oper    ---- 9804842      
             and t.aqpb073bfec <= pd_fecpro
             and t.aqpb073best <> 'D'
             and t.aqpb073bmod <> 0
             and t.aqpb073bpcob <> 0
             and t.aqpb073bcor = (select max(j.aqpb073bcor)
                                    from aqpb073b j
                                   where j.aqpb073bcod = t.aqpb073bcod
                                     and j.aqpb073bmod = t.aqpb073bmod
                                     and j.aqpb073bsuc = t.aqpb073bsuc
                                     and j.aqpb073bmda = t.aqpb073bmda
                                     and j.aqpb073bpap = t.aqpb073bpap
                                     and j.aqpb073bcta = t.aqpb073bcta
                                     and j.aqpb073bope = t.aqpb073bope
                                     and j.aqpb073btop = t.aqpb073btop
                                     and j.aqpb073bfec <= pd_fecpro
                                     and j.aqpb073best <> 'D')
           order by t.aqpb073bfec desc, t.aqpb073bcor desc;
          exception when others then
             ln_porfondo := null;
          end;

       end if;
                
    end if;
       
    return ln_porfondo;
    
  end fn_por_fondo;


  function fn_ind_fondo(   pn_cta    in number,
                           pn_oper   in number,
                           pd_fecpro in date) return varchar2 is
    lc_fondo varchar2(30);


  begin

    --reactiva
    begin
      select 'REACTIVA' 
       into lc_fondo
       from aqpb065b t
      where
      t.aqpb065bcta = pn_cta  
      and t.aqpb065bope = pn_oper  
      and t.aqpb065bmod <> 0
      and t.aqpb065bpcob <> 0
      and t.aqpb065bfec <= pd_fecpro
      and t.aqpb065best <> 'D'
      and t.aqpb065bcor = (select max(j.aqpb065bcor)
                          from aqpb065b j
                         where j.aqpb065bcod = t.aqpb065bcod
                           and j.aqpb065bmod = t.aqpb065bmod
                           and j.aqpb065bsuc = t.aqpb065bsuc
                           and j.aqpb065bmda = t.aqpb065bmda
                           and j.aqpb065bpap = t.aqpb065bpap
                           and j.aqpb065bcta = t.aqpb065bcta
                           and j.aqpb065bope = t.aqpb065bope
                           and j.aqpb065btop = t.aqpb065btop
                           and j.aqpb065bfec <= pd_fecpro
                           and j.aqpb065best <> 'D')
      order by t.aqpb065bfec desc, t.aqpb065bcor desc;      
    exception when others then
       lc_fondo := null;
    end;
    
    if lc_fondo is null then
        --fae
      begin  
        select  'FAE' --- 
           into lc_fondo
          from aqpb067b t
        where t.aqpb067bcta = pn_cta 
           and t.aqpb067bope = pn_oper 
           and t.aqpb067bfec <= pd_fecpro
           and t.aqpb067best <> 'D'
           and t.aqpb067bmod <> 0
           and t.aqpb067bpcob <> 0
           and t.aqpb067bcor = (select max(j.aqpb067bcor)
                                  from aqpb067b j
                                 where j.aqpb067bcod = t.aqpb067bcod
                                   and j.aqpb067bmod = t.aqpb067bmod
                                   and j.aqpb067bsuc = t.aqpb067bsuc
                                   and j.aqpb067bmda = t.aqpb067bmda
                                   and j.aqpb067bpap = t.aqpb067bpap
                                   and j.aqpb067bcta = t.aqpb067bcta
                                   and j.aqpb067bope = t.aqpb067bope
                                   and j.aqpb067btop = t.aqpb067btop
                                   and j.aqpb067bfec <= pd_fecpro
                                   and j.aqpb067best <> 'D')
          order by t.aqpb067bfec desc, t.aqpb067bcor desc;
       exception when others then
           lc_fondo := null;
       end;

      if lc_fondo is null then

       --crecer
       begin    
        select 'CRECER'
          into lc_fondo
          from aqpb073b t
        where 
            t.aqpb073bcta = pn_cta   
            and t.aqpb073bope = pn_oper    
           and t.aqpb073bfec <= pd_fecpro
           and t.aqpb073best <> 'D'
           and t.aqpb073bmod <> 0
           and t.aqpb073bpcob <> 0
           and t.aqpb073bcor = (select max(j.aqpb073bcor)
                                  from aqpb073b j
                                 where j.aqpb073bcod = t.aqpb073bcod
                                   and j.aqpb073bmod = t.aqpb073bmod
                                   and j.aqpb073bsuc = t.aqpb073bsuc
                                   and j.aqpb073bmda = t.aqpb073bmda
                                   and j.aqpb073bpap = t.aqpb073bpap
                                   and j.aqpb073bcta = t.aqpb073bcta
                                   and j.aqpb073bope = t.aqpb073bope
                                   and j.aqpb073btop = t.aqpb073btop
                                   and j.aqpb073bfec <= pd_fecpro
                                   and j.aqpb073best <> 'D')
         order by t.aqpb073bfec desc, t.aqpb073bcor desc;
        exception when others then
           lc_fondo := null;
        end;
      
       end if;
       
    end if;
       
    return nvl(lc_fondo, 'SIN FONDO');
    
  end fn_ind_fondo;

--dcastro

-----------------------------------------------------------------------------------------
function fn_dias_atraso(
                         v_Pgfape in date, --fecha de proceso
                         v_Pgcod  in number,
                         v_Scmod  in number,
                         v_Scsuc  in number,
                         v_Scmda  in number,
                         v_Scpap  in number,
                         v_Sccta  in number,
                         v_Scoper in number,
                         v_Scsbop in number,
                         v_Sctope in number,
                         v_Scstat in number,
                         v_fecven in date
                       ) return number is

    ln_diatr number;
    ln_scstat fsd010.aostat%type;

    LN_DIATR_CNGLD number; --2020.04.07
    
  begin

        --If v_Scstat in (64,90) Then
    If v_Scmod in (200,33,141) Then   --se agrego carta fianza

       ln_diatr := v_Pgfape - v_fecven;

       If ln_diatr < 0 then
          ln_diatr := 0 ;
       End if;

    Else


        --begin

    /*    --judicial y castigado, 200 y 33
        select
                (v_Pgfape - jaql166scfvl)
                into ln_diatr
        from
                JAQL166  --JAQL166:Judicial-Castigo
        Where
                jaql166pgcod = v_Pgcod
            and jaql166scmod = v_Scmod
            and jaql166scsuc = v_Scsuc
            and jaql166scmda = v_Scmda
            and jaql166scpap = v_Scpap
            and jaql166sccta = v_Sccta
            and jaql166scope = v_Scoper
            and jaql166scsbo = v_Scsbop
            and jaql166sctop = v_Sctope
            and jaql166nrpag = 0;
            --and jaql166est   = v_Scstat;*/



    /*     select v_Pgfape - c.aofvto--c.aofvto
           into ln_diatr
           from fsd010 c
           where  c.pgcod  = v_Pgcod
              and c.aomod  = v_Scmod
              and c.aosuc  = v_Scsuc
              and c.aomda  = v_Scmda
              and c.aopap  = v_Scpap
              and c.aocta  = v_Sccta
              and c.aooper = v_Scoper
              and c.aosbop = v_Scsbop
              and c.aotope = v_Sctope
              and c.aostat in (64,\*33,*\90); --judicial o castigado    */

       -- exception
         -- when no_data_found then
        begin
          --vigente y refinanciado
          SELECT (v_Pgfape - min(a.Ppfpag))
            into ln_diatr
            FROM FSD601 a
            left join FSD602 b on b.Pgcod = a.Pgcod
                              and b.Ppmod = a.Ppmod
                              and b.Ppsuc = a.Ppsuc
                              and b.Ppmda = a.Ppmda
                              and b.Pppap = a.Pppap
                              and b.Ppcta = a.Ppcta
                              and b.Ppoper = a.Ppoper
                              and b.Ppsbop = a.Ppsbop
                              and b.Pptope = a.Pptope
                              and b.Ppfpag = a.Ppfpag
                              and b.Pptipo = a.Pptipo
                              and b.Pp1stat = 'T'
                              and b.D602co = 'S'
                                 --and b.pptipo  <> 'K'
                              and b.pp1fech <= v_Pgfape
           where a.Pgcod = v_Pgcod
             and a.Ppmod = v_Scmod
             and a.Ppsuc = v_Scsuc
             and a.Ppmda = v_Scmda
             and a.Pppap = v_Scpap
             and a.Ppcta = v_Sccta
             and a.Ppoper = v_Scoper
             and a.Ppsbop = v_Scsbop
             and a.Pptope = v_Sctope
             and a.Ppfpag <= v_Pgfape
             and a.D601co = 'S'
             and (a.ppcap + a.ppint) > 0 --se agrego por cuotas de gracia 2013.09.06
             and b.D602co is null;
        exception
          when no_data_found then

            Begin
              select (v_Pgfape - min(d.Ppfpag))
                into ln_diatr
                from fsd601 d
               where d.Pgcod = v_Pgcod
                 and d.Ppmod = v_Scmod
                 and d.Ppsuc = v_Scsuc
                 and d.Ppmda = v_Scmda
                 and d.Pppap = v_Scpap
                 and d.Ppcta = v_Sccta
                 and d.Ppoper = v_Scoper
                 and d.Ppsbop = v_Scsbop
                 and d.Pptope = v_Sctope
                 and d.Ppfpag <= v_Pgfape
                 and (d.ppcap + d.ppint) > 0;
            exception
                when no_data_found then
                     ln_diatr := null;
            End;

            --end;
        end;
    End IF;


    ---2020.04.04 dcastro  Modificacion por emergencia covid19 
    /*begin
    -- Call the procedure
    pq_cr_diasatraso_cov19.sp_cr_dias_cov19(pn_cta => v_Sccta,
                                            pn_oper => v_Scoper,
                                            pn_sbop => v_Scsbop,
                                            pn_tope => v_Sctope,
                                            pn_mod => v_Scmod,
                                            pn_dias => LN_DIATR_CNGLD );
    end;


     IF(LN_DIATR_CNGLD < LN_DIATR) and LN_DIATR_CNGLD <> -1  THEN
        LN_DIATR := LN_DIATR_CNGLD;
      END IF;*/
  ---2020.04.04 dcastro  Modificacion por emergencia covid19


  return(NVL(ln_diatr,0));
end fn_dias_atraso;
--------------------------------------------------------------------------------------------

end PQ_datos_ACL;
/

