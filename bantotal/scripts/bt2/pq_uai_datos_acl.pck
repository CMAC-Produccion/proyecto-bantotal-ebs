create or replace package PQ_UAI_DATOS_ACL is
  ------------------------------------------------------------------------------------------------- 
  -- Nombre                     : PQ_UAI_DATOS_ACL
  -- Area de Negocio            : Auditoría Interna
  -- Frente                     : Normativo
  -- Versión                    : 1.0
  -- Uso                        : paquete que se maneja el proceso de ACL 
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Autor Modificacion         : APACHECOH
  -- Fecha Modificacion         : 15/02/2024
  -- Descripción Modificacion   : Se agrego un limite por guia para la ejecucion de los jobs
  -------------------------------------------------------------------------------------------------

  procedure sp_uai_jobs_refinanciados;

  procedure sp_uai_refinanciados_suc(p_n_numsuc in number);

  function fn_uai_categoria_a_fecref(p_n_pgcod     number,
                                     p_n_catcta    number,
                                     p_d_catfchdes date) return char;

  function fn_uai_dias_atraso_refina(p_d_bcfval date,
                                     p_n_pgcod  number,
                                     p_n_scmod  number,
                                     p_n_scsuc  number,
                                     p_n_scmda  number,
                                     p_n_scpap  number,
                                     p_n_sccta  number,
                                     p_n_scoper number,
                                     p_n_scsbop number,
                                     p_n_sctope number) return number;

  -------------------------------------------------------------------------------------------------

  procedure sp_uai_convenios;

  -------------------------------------------------------------------------------------------------

  procedure sp_uai_riesgo_cambiario(p_n_period in number);

  -------------------------------------------------------------------------------------------------

  procedure sp_uai_jobs_datos_garantias;

  procedure sp_uai_datos_garantias_mod(p_n_mod_bcmod in number);

  procedure sp_uai_garantia_ppg001(p_n_ppg001cod            in number,
                                   p_n_ppg001suc            in number,
                                   p_n_ppg001mda            in number,
                                   p_n_ppg001pap            in number,
                                   p_n_ppg001cta            in number,
                                   p_n_ppg001ope            in number,
                                   p_n_ppg001sbo            in number,
                                   p_n_ppg001top            in number,
                                   p_c_nromot_ppg001dato    out char,
                                   p_c_modvehicu_ppg001dato out char,
                                   p_c_asigravam_ppg001dato out char,
                                   p_c_nrotitulo_ppg001dato out char,
                                   p_c_tarpropie_ppg001dato out char,
                                   p_c_parcodpre_ppg001dato out char,
                                   p_c_nropoliza_ppg001dato out char,
                                   p_c_refdirecc_ppg001dato out char,
                                   p_c_colorvehi_ppg001dato out char,
                                   p_c_direcc_ppg001dato    out char,
                                   p_c_nroser_ppg001dato    out char,
                                   p_c_mar_ppg001dato       out char,
                                   p_c_nropla_ppg001dato    out char,
                                   p_c_raz_ppg001dato       out char,
                                   p_c_nrorec_ppg001dato    out char,
                                   p_c_nrostn_ppg001dato    out char,
                                   p_c_factur_ppg001dato    out char,
                                   p_c_nrochs_ppg001dato    out char,
                                   p_c_marcav_ppg001dato    out char);

  procedure sp_uai_garantia_ppg003(p_n_ppg003cod            in number,
                                   p_n_ppg003suc            in number,
                                   p_n_ppg003mda            in number,
                                   p_n_ppg003pap            in number,
                                   p_n_ppg003cta            in number,
                                   p_n_ppg003ope            in number,
                                   p_n_ppg003sbo            in number,
                                   p_n_ppg003top            in number,
                                   p_n_anifabric_ppg003dato out number,
                                   p_n_aniconstr_ppg003dato out number,
                                   p_n_codmodveh_ppg003dato out number,
                                   p_n_numepisos_ppg003dato out number,
                                   p_n_numsotano_ppg003dato out number,
                                   p_n_numelotes_ppg003dato out number,
                                   p_n_codmarveh_ppg003dato out number,
                                   p_n_numasient_ppg003dato out number);

  procedure sp_uai_garantia_ppg006(p_n_ppg006cod            in number,
                                   p_n_ppg006suc            in number,
                                   p_n_ppg006mda            in number,
                                   p_n_ppg006pap            in number,
                                   p_n_ppg006cta            in number,
                                   p_n_ppg006ope            in number,
                                   p_n_ppg006sbo            in number,
                                   p_n_ppg006top            in number,
                                   p_c_despatrim_ppg006dato out varchar2,
                                   p_c_comentari_ppg006dato out varchar2,
                                   p_c_observaci_ppg006dato out varchar2,
                                   p_c_regsinies_ppg006dato out varchar2);

  procedure sp_uai_garantia_ppg002(p_n_ppg002cod            in number,
                                   p_n_ppg002suc            in number,
                                   p_n_ppg002mda            in number,
                                   p_n_ppg002pap            in number,
                                   p_n_ppg002cta            in number,
                                   p_n_ppg002ope            in number,
                                   p_n_ppg002sbo            in number,
                                   p_n_ppg002top            in number,
                                   p_d_fecconsti_ppg002dato out date,
                                   p_d_fecdeclar_ppg002dato out date,
                                   p_d_fectasaci_ppg002dato out date,
                                   p_d_fecremnot_ppg002dato out date,
                                   p_d_fecasiaux_ppg002dato out date,
                                   p_d_fecasiasi_ppg002dato out date,
                                   p_d_fecescrit_ppg002dato out date,
                                   p_d_fecprerrp_ppg002dato out date,
                                   p_d_fecinsrrp_ppg002dato out date,
                                   p_d_fecblqnot_ppg002dato out date,
                                   p_d_fecobsrrp_ppg002dato out date,
                                   p_d_fecsubrrp_ppg002dato out date,
                                   p_d_fecremgar_ppg002dato out date,
                                   p_d_fecentcli_ppg002dato out date,
                                   p_d_feciniplz_ppg002dato out date,
                                   p_d_fecfinplz_ppg002dato out date,
                                   p_d_fecsinies_ppg002dato out date);

  procedure sp_uai_garantia_ppg004(p_n_ppg004cod            in number,
                                   p_n_ppg004suc            in number,
                                   p_n_ppg004mda            in number,
                                   p_n_ppg004pap            in number,
                                   p_n_ppg004cta            in number,
                                   p_n_ppg004ope            in number,
                                   p_n_ppg004sbo            in number,
                                   p_n_ppg004top            in number,
                                   p_n_valrealiz_ppg004dato out number,
                                   p_n_valcomerc_ppg004dato out number,
                                   p_n_valedific_ppg004dato out number,
                                   p_n_valreposi_ppg004dato out number,
                                   p_n_valtasaci_ppg004dato out number,
                                   p_n_valterren_ppg004dato out number,
                                   p_n_areterren_ppg004dato out number,
                                   p_n_nrohectar_ppg004dato out number,
                                   p_n_areconstr_ppg004dato out number,
                                   p_n_areexclus_ppg004dato out number,
                                   p_n_aretechad_ppg004dato out number,
                                   p_n_areacomun_ppg004dato out number);

  procedure sp_uai_garantia_ppg007(p_n_ppg007cod         in number,
                                   p_n_ppg007suc         in number,
                                   p_n_ppg007mda         in number,
                                   p_n_ppg007pap         in number,
                                   p_n_ppg007cta         in number,
                                   p_n_ppg007ope         in number,
                                   p_n_ppg007sbo         in number,
                                   p_n_ppg007top         in number,
                                   p_c_garpre_ppg007dato out char,
                                   p_c_decfab_ppg007dato out char,
                                   p_c_prohor_ppg007dato out char,
                                   p_c_artesa_ppg007dato out char,
                                   p_c_nue_ppg007dato    out char,
                                   p_c_compar_ppg007dato out char,
                                   p_c_vigent_ppg007dato out char);

  -------------------------------------------------------------------------------------------------

  procedure sp_uai_garantia_ppg008(p_n_ppg008cod         in number,
                                   p_n_ppg008suc         in number,
                                   p_n_ppg008mda         in number,
                                   p_n_ppg008pap         in number,
                                   p_n_ppg008cta         in number,
                                   p_n_ppg008ope         in number,
                                   p_n_ppg008sbo         in number,
                                   p_n_ppg008top         in number,
                                   p_c_moneda_ppg008desc out char,
                                   p_c_tipdep_ppg008desc out char,
                                   p_c_nroope_ppg008desc out char,
                                   p_c_tipinm_ppg008desc out char,
                                   p_c_tipveh_ppg008desc out char,
                                   p_c_ubigeo_ppg008desc out char,
                                   p_c_tibide_ppg008desc out char,
                                   p_c_uso_ppg008desc    out char,
                                   p_c_perito_ppg008desc out char,
                                   p_c_bideav_ppg008desc out char);

  -------------------------------------------------------------------------------------------------

  procedure sp_uai_jobs_evaluaciones;

  procedure sp_uai_evaluacion_dep(p_n_numsuc in number);

  procedure sp_uai_evaluacion_ind(p_n_numsuc in number);

  -------------------------------------------------------------------------------------------------  

  procedure sp_uai_recuperacion_legal;

end PQ_UAI_DATOS_ACL;
/

create or replace package body PQ_UAI_DATOS_ACL is

  -------------------------------------------------------------------------------------------------

  procedure sp_uai_jobs_refinanciados is
    --
    -- Nombre:                        sp_uai_jobs_refinanciados
    -- Area de Negocio:               Auditoría Interna
    -- Frente:                        Normativo
    --  
  
    lc_sp_refinan varchar2(500);
    ln_job        number;  
    ln_limit      number := 0;
    ln_numjob     number := 0;
    
    cursor lcur_sucursales is
      select distinct n_suc_bcsuc from uai_aclpre;
    lc_hostname varchar2(64); --mod@abr 20170424
  begin
  
    --eliminar datos de tabla de refinanciados
    execute immediate 'truncate table UAI_ACLREFINA';
  
    --eliminar jobs para refinanciados
    delete from TAB_JOBS
     where C_CODAGE = 'ACL'
       and C_DATO2 = 'UAI_ACLREFINA';
  
    commit;
    --mod@abr 20170424
    begin
      select host_name into lc_hostname from v$instance;
    end;
    --mod@abr 20170424
    
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
    
    ln_job := 0;
    for suc in lcur_sucursales loop
    
      --lanzar job para sucursal
      ln_job := ln_job + 1;
    
      lc_sp_refinan := 'PQ_UAI_DATOS_ACL.sp_uai_refinanciados_suc(' ||
                       suc.n_suc_bcsuc || ');';
      --mod@abr 20170424
      --      if UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101') then      
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        dbms_job.submit(ln_job,
                        what      => lc_sp_refinan,
                        next_date => sysdate + 0.5 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        instance  => 1,
                        --instance => 2, 01/01/2024 
                        force => false);
      else
        dbms_job.submit(ln_job,
                        what      => lc_sp_refinan,
                        next_date => sysdate + 0.5 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      end if;
      --DBMS_JOB.SUBMIT(ln_job, lc_sp_refinan, sysdate + 0.5 / (24 * 60), null, false, 2, false);-- HMEV ESTABA EN 0 EN VEZ DE 2
      --mod@abr 20170424
      
      --apachecoh 2024.02.09  
      BEGIN
        SELECT count(*)
          INTO ln_numjob
          FROM dba_jobs x
         WHERE upper(x.what) LIKE '%PQ_UAI_DATOS_ACL.SP_UAI_REFINANCIADOS_SUC%';
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
                 '%PQ_UAI_DATOS_ACL.SP_UAI_REFINANCIADOS_SUC%';
        EXCEPTION
          WHEN OTHERS THEN
            ln_numjob := 0;
        END;
      END LOOP;
      
      --registrar ejecución de job para sucursal
      insert into TAB_JOBS
        (C_CODAGE, C_DETJOB, N_NUMER1, C_DATO2)
      values
        ('ACL', lc_sp_refinan, suc.n_suc_bcsuc, 'UAI_ACLREFINA');
    
      commit;
    
    end loop;
  
  exception
    when others then
      dbms_output.put_line('error');
  end;

  -------------------------------------------------------------------------------------------------

  procedure sp_uai_refinanciados_suc(p_n_numsuc in number) is
    --
    -- Nombre:                        sp_uai_refinanciados_suc
    -- Area de Negocio:               Auditoría Interna
    -- Frente:                        Normativo
    --
  begin
  
    --registrar hora de inicio de ejecución de job
    update TAB_JOBS
       set D_FECINI = sysdate
     where C_CODAGE = 'ACL'
       and N_NUMER1 = p_n_numsuc
       and C_DATO2 = 'UAI_ACLREFINA';
    commit;
  
    --insertar registros de refinanciados para sucursal
    --120  Refinanciación                
    --121  Refinancia Op Cargos Diferidos
    insert into uai_aclrefina
      (N_DIAMOR,
       N_EMP_R1COD,
       N_MOD_R1MOD,
       N_SUC_R1SUC,
       N_MDA_R1MDA,
       N_PAP_R1PAP,
       N_CTA_R1CTA,
       N_OPE_R1OPER,
       N_SBO_R1SBOP,
       N_TOP_R1TOPE,
       D_FECREF_AOFVAL,
       C_CAT_CATCATEG,
       N_TASA --mod@abr 20170411
       )
      select distinct max(fn_uai_dias_atraso_refina(s.d_fecval_bcfval,
                                                    r.r2cod,
                                                    r.r2mod,
                                                    r.r2suc,
                                                    r.r2mda,
                                                    r.r2pap,
                                                    r.r2cta,
                                                    r.r2oper,
                                                    r.r2sbop,
                                                    r.r2tope)) N_DIAMOR,
                      
                      r.r1cod  N_EMP_R1COD,
                      r.r1mod  N_MOD_R1MOD,
                      r.r1suc  N_SUC_R1SUC,
                      r.r1mda  N_MDA_R1MDA,
                      r.r1pap  N_PAP_R1PAP,
                      r.r1cta  N_CTA_R1CTA,
                      r.r1oper N_OPE_R1OPER,
                      r.r1sbop N_SBO_R1SBOP,
                      r.r1tope N_TOP_R1TOPE,
                      
                      s.d_fecval_bcfval D_FECREF_AOFVAL,
                      
                      PQ_UAI_DATOS_ACL.fn_uai_categoria_a_fecref(r.r1cod,
                                                                 r.r1cta,
                                                                 s.d_fecval_bcfval) C_CAT_CATCATEG,
                      max(o.aotasa) N_TASA --mod@abr 20170411
      
        from uai_aclpre s
        left join fsr011 r
          on s.n_emp_bcemp = r.r1cod
         and s.n_suc_bcsuc = r.r1suc
         and s.n_mda_bcmda = r.r1mda
         and s.n_pap_bcpap = r.r1pap
         and s.n_cta_bccta = r.r1cta
         and s.n_oper_bcoper = r.r1oper
         and s.n_sbop_bcsbop = r.r1sbop
         and s.n_tope_bctop = r.r1tope
         and s.n_mod_bcmod = r.r1mod
        left join fsd010 o
          on r.r2cod = o.pgcod
         and r.r2mod = o.aomod
         and r.r2suc = o.aosuc
         and r.r2mda = o.aomda
         and r.r2pap = o.aopap
         and r.r2cta = o.aocta
         and r.r2oper = o.aooper
         and r.r2sbop = o.aosbop
         and r.r2tope = o.aotope
       where r.relcod in (120, 121)
         and s.n_suc_bcsuc = p_n_numsuc
      
       group by r.r1cod,
                r.r1suc,
                r.r1mda,
                r.r1pap,
                r.r1cta,
                r.r1oper,
                r.r1sbop,
                r.r1tope,
                r.r1mod,
                s.d_fecval_bcfval /*,o.aotasa*/
       order by r.r1cod,
                r.r1suc,
                r.r1mda,
                r.r1pap,
                r.r1cta,
                r.r1oper,
                r.r1sbop,
                r.r1tope,
                r.r1mod,
                s.d_fecval_bcfval /*,o.aotasa*/
      ;
  
    --35  Judicial-Refinanciado         
    --36  Refinanciado-Judicial             
    insert into uai_aclrefina
      (N_DIAMOR,
       N_EMP_R1COD,
       N_MOD_R1MOD,
       N_SUC_R1SUC,
       N_MDA_R1MDA,
       N_PAP_R1PAP,
       N_CTA_R1CTA,
       N_OPE_R1OPER,
       N_SBO_R1SBOP,
       N_TOP_R1TOPE,
       D_FECREF_AOFVAL,
       C_CAT_CATCATEG,
       N_TASA --mod@abr 20170411
       )
      select distinct max(fn_uai_dias_atraso_refina(s.d_fecval_bcfval,
                                                    r.r1cod,
                                                    r.r1mod,
                                                    r.r1suc,
                                                    r.r1mda,
                                                    r.r1pap,
                                                    r.r1cta,
                                                    r.r1oper,
                                                    r.r1sbop,
                                                    r.r1tope)) N_DIAMOR,
                      
                      r.r2cod  N_EMP_R1COD,
                      r.r2mod  N_MOD_R1MOD,
                      r.r2suc  N_SUC_R1SUC,
                      r.r2mda  N_MDA_R1MDA,
                      r.r2pap  N_PAP_R1PAP,
                      r.r2cta  N_CTA_R1CTA,
                      r.r2oper N_OPE_R1OPER,
                      r.r2sbop N_SBO_R1SBOP,
                      r.r2tope N_TOP_R1TOPE,
                      
                      s.d_fecval_bcfval D_FECREF_AOFVAL,
                      
                      PQ_UAI_DATOS_ACL.fn_uai_categoria_a_fecref(r.r2cod,
                                                                 r.r2cta,
                                                                 s.d_fecval_bcfval) C_CAT_CATCATEG,
                      max(o.aotasa) N_TASA --mod@abr 20170411
      
        from uai_aclpre s
        left join fsr011 r
          on s.n_emp_bcemp = r.r2cod
         and s.n_suc_bcsuc = r.r2suc
         and s.n_mda_bcmda = r.r2mda
         and s.n_pap_bcpap = r.r2pap
         and s.n_cta_bccta = r.r2cta
         and s.n_oper_bcoper = r.r2oper
         and s.n_sbop_bcsbop = r.r2sbop
         and s.n_tope_bctop = r.r2tope
         and s.n_mod_bcmod = r.r2mod
        left join fsd010 o
          on r.r1cod = o.pgcod
         and r.r1mod = o.aomod
         and r.r1suc = o.aosuc
         and r.r1mda = o.aomda
         and r.r1pap = o.aopap
         and r.r1cta = o.aocta
         and r.r1oper = o.aooper
         and r.r1sbop = o.aosbop
         and r.r1tope = o.aotope
       where r.relcod in (35, 36)
         and s.n_suc_bcsuc = p_n_numsuc
      
       group by r.r2cod,
                r.r2suc,
                r.r2mda,
                r.r2pap,
                r.r2cta,
                r.r2oper,
                r.r2sbop,
                r.r2tope,
                r.r2mod,
                s.d_fecval_bcfval /*,o.aotasa*/
       order by r.r2cod,
                r.r2suc,
                r.r2mda,
                r.r2pap,
                r.r2cta,
                r.r2oper,
                r.r2sbop,
                r.r2tope,
                r.r2mod,
                s.d_fecval_bcfval /*,o.aotasa*/
      ;
  
    commit;
  
    --registrar hora de fin de ejecución de job
    update TAB_JOBS
       set D_FECFIN = sysdate
     where C_CODAGE = 'ACL'
       and N_NUMER1 = p_n_numsuc
       and C_DATO2 = 'UAI_ACLREFINA';
    commit;
  
  end;

  -------------------------------------------------------------------------------------------------

  function fn_uai_categoria_a_fecref(p_n_pgcod     in number,
                                     p_n_catcta    in number,
                                     p_d_catfchdes in date) return char is
    --
    -- Nombre:                        fn_uai_categoria_a_fecref
    -- Area de Negocio:               Auditoría Interna
    -- Frente:                        Normativo
    --
  
    lc_catcateg     fsd212.catcateg%type;
    ld_ultdiamesant date;
  
  begin
  
    --fecha de último día del mes anterior de refinanciación    
    select trunc(last_day(add_months(p_d_catfchdes, -1)))
      into ld_ultdiamesant
      from dual;
  
    --categoría resultante a fecha del mes anterior de refinanciación
    select c.catcateg
      into lc_catcateg
      from fsd212 c
     where c.pgcod = p_n_pgcod
       and c.catcta = p_n_catcta
       and c.catcod = 4
       and c.catfchdes = ld_ultdiamesant
       and rownum = 1;
  
    return lc_catcateg;
  
  end;

  -------------------------------------------------------------------------------------------------

  function fn_uai_dias_atraso_refina(p_d_bcfval date,
                                     p_n_pgcod  number,
                                     p_n_scmod  number,
                                     p_n_scsuc  number,
                                     p_n_scmda  number,
                                     p_n_scpap  number,
                                     p_n_sccta  number,
                                     p_n_scoper number,
                                     p_n_scsbop number,
                                     p_n_sctope number) return number is
    --
    -- Nombre:                        sp_uai_convenios
    -- Area de Negocio:               Auditoría Interna
    -- Frente:                        Normativo
    --
  
    ln_dia_atr number;
    ld_pp1fech date;
    ld_ppfpag  date;
  
    l_n_pgcod  number;
    l_n_scmod  number;
    l_n_scsuc  number;
    l_n_scmda  number;
    l_n_scpap  number;
    l_n_sccta  number;
    l_n_scoper number;
    l_n_scsbop number;
    l_n_sctope number;
  
  begin
  
    l_n_pgcod  := p_n_pgcod;
    l_n_scmod  := p_n_scmod;
    l_n_scsuc  := p_n_scsuc;
    l_n_scmda  := p_n_scmda;
    l_n_scpap  := p_n_scpap;
    l_n_sccta  := p_n_sccta;
    l_n_scoper := p_n_scoper;
    l_n_scsbop := p_n_scsbop;
    l_n_sctope := p_n_sctope;
  
    if p_n_scmod = 200 then
    
      select r.r1cod,
             r.r1mod,
             r.r1suc,
             r.r1mda,
             r.r1pap,
             r.r1cta,
             r.r1oper,
             r.r1sbop,
             r.r1tope
        into l_n_pgcod,
             l_n_scmod,
             l_n_scsuc,
             l_n_scmda,
             l_n_scpap,
             l_n_sccta,
             l_n_scoper,
             l_n_scsbop,
             l_n_sctope
        from fsr011 r
       where r.r2cod = p_n_pgcod
         and r.r2mod = p_n_scmod
         and r.r2suc = p_n_scsuc
         and r.r2mda = p_n_scmda
         and r.r2pap = p_n_scpap
         and r.r2cta = p_n_sccta
         and r.r2oper = p_n_scoper
         and r.r2sbop = p_n_scsbop
         and r.r2tope = p_n_sctope
         and r.relcod = 52;
    
    end if;
  
    select max(b.pp1fech)
      into ld_pp1fech
      from fsd602 b
     where b.Pgcod = l_n_pgcod
       and b.Ppmod = l_n_scmod
       and b.Ppsuc = l_n_scsuc
       and b.Ppmda = l_n_scmda
       and b.Pppap = l_n_scpap
       and b.Ppcta = l_n_sccta
       and b.Ppoper = l_n_scoper
       and b.Ppsbop = l_n_scsbop
       and b.Pptope = l_n_sctope
       and b.Pp1stat = 'T'
       and b.D602co = 'S';
  
    if ld_pp1fech is null then
      select min(a.ppfpag)
        into ld_ppfpag
        from fsd601 a
       where a.pgcod = l_n_pgcod
         and a.ppmod = l_n_scmod
         and a.ppsuc = l_n_scsuc
         and a.ppmda = l_n_scmda
         and a.pppap = l_n_scpap
         and a.ppcta = l_n_sccta
         and a.ppoper = l_n_scoper
         and a.ppsbop = l_n_scsbop
         and a.pptope = l_n_sctope
         and a.d601co = 'S';
    else
      select min(b.ppfpag)
        into ld_ppfpag
        from fsd602 b
       where b.Pgcod = l_n_pgcod
         and b.Ppmod = l_n_scmod
         and b.Ppsuc = l_n_scsuc
         and b.Ppmda = l_n_scmda
         and b.Pppap = l_n_scpap
         and b.Ppcta = l_n_sccta
         and b.Ppoper = l_n_scoper
         and b.Ppsbop = l_n_scsbop
         and b.Pptope = l_n_sctope
         and b.Pp1stat = 'T'
         and b.D602co = 'S'
         and b.pp1fech = ld_pp1fech;
    end if;
  
    ln_dia_atr := p_d_bcfval - ld_ppfpag;
  
    return ln_dia_atr;
  
  exception
    when others then
      return - 1;
  end;

  -------------------------------------------------------------------------------------------------

  procedure sp_uai_convenios is
    --
    -- Nombre:                        sp_uai_convenios
    -- Area de Negocio:               Auditoría Interna
    -- Frente:                        Normativo
    --
  begin
  
    execute immediate 'truncate table UAI_ACLCONVEN';
    commit;
  
    insert into uai_aclconven
      (N_COD_PP102NCART,
       N_EMP_PP102COD,
       N_MOD_PP102MOD,
       N_SUC_PP102SUC,
       N_MDA_PP102MDA,
       N_PAP_PP102PAP,
       N_CTA_PP102CTA,
       N_OPE_PP102OPE,
       N_SBO_PP102SBO,
       N_TOP_PP102TOP)
      select distinct c.pp102ncart,
                      c.pp102cod,
                      c.pp102mod,
                      c.pp102suc,
                      c.pp102mda,
                      c.pp102pap,
                      c.pp102cta,
                      c.pp102ope,
                      c.pp102sbo,
                      c.pp102top
        from uai_aclpre p
       inner join fpp102 c
          on p.n_emp_bcemp = c.pp102cod
         and p.n_mod_bcmod = c.pp102mod
         and p.n_suc_bcsuc = c.pp102suc
         and p.n_mda_bcmda = c.pp102mda
         and p.n_pap_bcpap = c.pp102pap
         and p.n_cta_bccta = c.pp102cta
         and p.n_oper_bcoper = c.pp102ope
         and p.n_sbop_bcsbop = c.pp102sbo
         and p.n_tope_bctop = c.pp102top;
  
    commit;
  
  end;

  -------------------------------------------------------------------------------------------------

  procedure sp_uai_riesgo_cambiario(p_n_period in number) is
    --
    -- Nombre:                        sp_uai_riesgo_cambiario
    -- Area de Negocio:               Auditoría Interna
    -- Frente:                        Normativo
    --  
  begin
  
    execute immediate 'truncate table UAI_ACLRIECAM';
    commit;
  
    insert into uai_aclriecam
      (N_EMP_BC718EMP,
       N_PER_BC718FCH,
       N_CTA_BC718CTA,
       N_PAI_BC718PDOC,
       N_TDO_BC718TDOC,
       N_NDC_BC718NDOC,
       N_EXP_BC718CODC)
      select distinct e.bc718emp,
                      e.bc718fch,
                      e.bc718cta,
                      e.bc718pdoc,
                      e.bc718tdoc,
                      e.bc718ndoc,
                      e.bc718codc
        from uai_aclpre p
       inner join fbc718 e
          on p.n_emp_bcemp = e.bc718emp
         and e.bc718fch = p_n_period
         and p.n_cta_bccta = e.bc718cta
         and p.n_pais_pepais = e.bc718pdoc
         and p.n_tdoc_petdoc = e.bc718tdoc
         and p.c_ndoc_pendoc = e.bc718ndoc;
  
    commit;
  
  end;

  -------------------------------------------------------------------------------------------------

  procedure sp_uai_jobs_datos_garantias is
    --
    -- Nombre:                        sp_uai_jobs_refinanciados
    -- Area de Negocio:               Auditoría Interna
    -- Frente:                        Normativo
    --  
  
    lc_sp_datgar varchar2(500);
    ln_job       number;  
    ln_limit     number := 0;
    ln_numjob    number := 0;
    
    cursor lcur_modulos is
      select distinct n_mod_bcmod from uai_aclpre;
    lc_hostname varchar2(64); --mod@abr 20170424
  begin
  
    --eliminar datos de tabla de refinanciados
    execute immediate 'truncate table uai_acldatgar';
  
    --eliminar jobs para refinanciados
    delete from TAB_JOBS
     where C_CODAGE = 'ACL'
       and C_DATO2 = 'UAI_ACLDATGAR';
  
    commit;
    --mod@abr 20170424
    begin
      select host_name into lc_hostname from v$instance;
    end;
    --mod@abr 20170424
    
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
    
    ln_job := 0;
    for mods in lcur_modulos loop
    
      --lanzar job para sucursal
      ln_job := ln_job + 1;
    
      lc_sp_datgar := 'PQ_UAI_DATOS_ACL.sp_uai_datos_garantias_mod(' ||
                      mods.n_mod_bcmod || ');';
      --mod@abr 20170424
      --      if UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101') then      
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        dbms_job.submit(ln_job,
                        what      => lc_sp_datgar,
                        next_date => sysdate + 0.5 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        instance  => 1,
                        --instance => 2, 01/01/2024 
                        force => false);
      else
        dbms_job.submit(ln_job,
                        what      => lc_sp_datgar,
                        next_date => sysdate + 0.5 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      end if;
      --DBMS_JOB.SUBMIT(ln_job, lc_sp_datgar, sysdate + 0.5 / (24 * 60), null, false, 2, false);--ESTABA EN 1 HMEV
      --mod@abr 20170424
      
      --apachecoh 2024.02.09  
      BEGIN
        SELECT count(*)
          INTO ln_numjob
          FROM dba_jobs x
         WHERE upper(x.what) LIKE '%PQ_UAI_DATOS_ACL.SP_UAI_DATOS_GARANTIAS_MOD%';
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
                 '%PQ_UAI_DATOS_ACL.SP_UAI_DATOS_GARANTIAS_MOD%';
        EXCEPTION
          WHEN OTHERS THEN
            ln_numjob := 0;
        END;
      END LOOP;
      
      --registrar ejecución de job para sucursal
      insert into TAB_JOBS
        (C_CODAGE, C_DETJOB, N_NUMER1, C_DATO2)
      values
        ('ACL', lc_sp_datgar, mods.n_mod_bcmod, 'UAI_ACLDATGAR');
    
      commit;
    
    end loop;
  
  exception
    when others then
      dbms_output.put_line('error');
  end;

  procedure sp_uai_datos_garantias_mod(p_n_mod_bcmod in number) is
    --
    -- Nombre:                        sp_uai_datos_garantia
    -- Area de Negocio:               Auditoría Interna
    -- Frente:                        Normativo
    --  
  
    cursor lcur_garantias is
      select distinct p.n_emp_bcemp   n_emp_bcemp,
                      p.n_mod_bcmod   n_mod_bcmod,
                      p.n_suc_bcsuc   n_suc_bcsuc,
                      p.n_mda_bcmda   n_mda_bcmda,
                      p.n_pap_bcpap   n_pap_bcpap,
                      p.n_cta_bccta   n_cta_bccta,
                      p.n_oper_bcoper n_oper_bcoper,
                      p.n_sbop_bcsbop n_sbop_bcsbop,
                      p.n_tope_bctop  n_tope_bctop,
                      g.ppg000pgc     ppg000pgc,
                      70              ppg000mod,
                      g.ppg000suc     ppg000suc,
                      g.ppg000mda     ppg000mda,
                      g.ppg000pap     ppg000pap,
                      g.ppg000cta     ppg000cta,
                      g.ppg000ope     ppg000ope,
                      g.ppg000sbo     ppg000sbo,
                      g.ppg000top     ppg000top
        from uai_aclpre p
       inner join fsr011 r
          on p.n_emp_bcemp = r.r1cod
         and p.n_mod_bcmod = r.r1mod
         and p.n_suc_bcsuc = r.r1suc
         and p.n_mda_bcmda = r.r1mda
         and p.n_pap_bcpap = r.r1pap
         and p.n_cta_bccta = r.r1cta
         and p.n_oper_bcoper = r.r1oper
         and p.n_sbop_bcsbop = r.r1sbop
         and p.n_tope_bctop = r.r1tope
         and r.relcod = 50
       inner join ppg000 g
          on r.r2cod = g.ppg000pgc
         and r.r2mod in (70, 470)
         and r.r2suc = g.ppg000suc
         and r.r2mda = g.ppg000mda
         and r.r2pap = g.ppg000pap
         and r.r2cta = g.ppg000cta
         and r.r2oper = g.ppg000ope
         and r.r2sbop = g.ppg000sbo
         and r.r2tope = g.ppg000top
       where p.n_emp_bcemp = 1
         and p.n_mod_bcmod = p_n_mod_bcmod
         and g.ppg000tco = 'S';
  
    p_n_anifabric_ppg003dato number(9);
    p_n_aniconstr_ppg003dato number(9);
    p_n_codmodveh_ppg003dato number(9);
    p_n_numepisos_ppg003dato number(9);
    p_n_numsotano_ppg003dato number(9);
    p_n_numelotes_ppg003dato number(9);
    p_n_codmarveh_ppg003dato number(9);
    p_n_numasient_ppg003dato number(9);
    p_c_despatrim_ppg006dato varchar2(500);
    p_c_comentari_ppg006dato varchar2(500);
    p_c_observaci_ppg006dato varchar2(500);
    p_c_regsinies_ppg006dato varchar2(500);
    p_d_fecconsti_ppg002dato date;
    p_d_fecdeclar_ppg002dato date;
    p_d_fectasaci_ppg002dato date;
    p_d_fecremnot_ppg002dato date;
    p_d_fecasiaux_ppg002dato date;
    p_d_fecasiasi_ppg002dato date;
    p_d_fecescrit_ppg002dato date;
    p_d_fecprerrp_ppg002dato date;
    p_d_fecinsrrp_ppg002dato date;
    p_d_fecblqnot_ppg002dato date;
    p_d_fecobsrrp_ppg002dato date;
    p_d_fecsubrrp_ppg002dato date;
    p_d_fecremgar_ppg002dato date;
    p_d_fecentcli_ppg002dato date;
    p_d_feciniplz_ppg002dato date;
    p_d_fecfinplz_ppg002dato date;
    p_d_fecsinies_ppg002dato date;
    p_n_valrealiz_ppg004dato number(17, 2);
    p_n_valcomerc_ppg004dato number(17, 2);
    p_n_valedific_ppg004dato number(17, 2);
    p_n_valreposi_ppg004dato number(17, 2);
    p_n_valtasaci_ppg004dato number(17, 2);
    p_n_valterren_ppg004dato number(17, 2);
    p_n_areterren_ppg004dato number(17, 2);
    p_n_nrohectar_ppg004dato number(17, 2);
    p_n_areconstr_ppg004dato number(17, 2);
    p_n_areexclus_ppg004dato number(17, 2);
    p_n_aretechad_ppg004dato number(17, 2);
    p_n_areacomun_ppg004dato number(17, 2);
    p_c_garpre_ppg007dato    char(1);
    p_c_decfab_ppg007dato    char(1);
    p_c_prohor_ppg007dato    char(1);
    p_c_artesa_ppg007dato    char(1);
    p_c_nue_ppg007dato       char(1);
    p_c_compar_ppg007dato    char(1);
    p_c_vigent_ppg007dato    char(1);
  
    --parámetros para datos de ppg001 -- garantías vehiculares
    p_c_nromot_ppg001dato    char(50);
    p_c_modvehicu_ppg001dato char(50);
    p_c_asigravam_ppg001dato char(50);
    p_c_nrotitulo_ppg001dato char(50);
    p_c_tarpropie_ppg001dato char(50);
    p_c_parcodpre_ppg001dato char(50);
    p_c_nropoliza_ppg001dato char(50);
    p_c_refdirecc_ppg001dato char(50);
    p_c_colorvehi_ppg001dato char(50);
    p_c_direcc_ppg001dato    char(50);
    p_c_nroser_ppg001dato    char(50);
    p_c_mar_ppg001dato       char(50);
    p_c_nropla_ppg001dato    char(50);
    p_c_raz_ppg001dato       char(50);
    p_c_nrorec_ppg001dato    char(50);
    p_c_nrostn_ppg001dato    char(50);
    p_c_factur_ppg001dato    char(50);
    p_c_nrochs_ppg001dato    char(50);
    p_c_marcav_ppg001dato    char(50);
  
    --parámetros para datos de ppg008
    p_c_moneda_ppg008desc char(50);
    p_c_tipdep_ppg008desc char(50);
    p_c_nroope_ppg008desc char(50);
    p_c_tipinm_ppg008desc char(50);
    p_c_tipveh_ppg008desc char(50);
    p_c_ubigeo_ppg008desc char(50);
    p_c_tibide_ppg008desc char(50);
    p_c_uso_ppg008desc    char(50);
    p_c_perito_ppg008desc char(50);
    p_c_bideav_ppg008desc char(50);
  
  begin
  
    --registrar hora de inicio de ejecución de job
    update TAB_JOBS
       set D_FECINI = sysdate
     where C_CODAGE = 'ACL'
       and N_NUMER1 = p_n_mod_bcmod
       and C_DATO2 = 'UAI_ACLDATGAR';
    commit;
  
    for gar in lcur_garantias loop
    
      sp_uai_garantia_ppg003(gar.ppg000pgc,
                             gar.ppg000suc,
                             gar.ppg000mda,
                             gar.ppg000pap,
                             gar.ppg000cta,
                             gar.ppg000ope,
                             gar.ppg000sbo,
                             gar.ppg000top,
                             p_n_anifabric_ppg003dato,
                             p_n_aniconstr_ppg003dato,
                             p_n_codmodveh_ppg003dato,
                             p_n_numepisos_ppg003dato,
                             p_n_numsotano_ppg003dato,
                             p_n_numelotes_ppg003dato,
                             p_n_codmarveh_ppg003dato,
                             p_n_numasient_ppg003dato);
    
      sp_uai_garantia_ppg006(gar.ppg000pgc,
                             gar.ppg000suc,
                             gar.ppg000mda,
                             gar.ppg000pap,
                             gar.ppg000cta,
                             gar.ppg000ope,
                             gar.ppg000sbo,
                             gar.ppg000top,
                             p_c_despatrim_ppg006dato,
                             p_c_comentari_ppg006dato,
                             p_c_observaci_ppg006dato,
                             p_c_regsinies_ppg006dato);
    
      sp_uai_garantia_ppg002(gar.ppg000pgc,
                             gar.ppg000suc,
                             gar.ppg000mda,
                             gar.ppg000pap,
                             gar.ppg000cta,
                             gar.ppg000ope,
                             gar.ppg000sbo,
                             gar.ppg000top,
                             p_d_fecconsti_ppg002dato,
                             p_d_fecdeclar_ppg002dato,
                             p_d_fectasaci_ppg002dato,
                             p_d_fecremnot_ppg002dato,
                             p_d_fecasiaux_ppg002dato,
                             p_d_fecasiasi_ppg002dato,
                             p_d_fecescrit_ppg002dato,
                             p_d_fecprerrp_ppg002dato,
                             p_d_fecinsrrp_ppg002dato,
                             p_d_fecblqnot_ppg002dato,
                             p_d_fecobsrrp_ppg002dato,
                             p_d_fecsubrrp_ppg002dato,
                             p_d_fecremgar_ppg002dato,
                             p_d_fecentcli_ppg002dato,
                             p_d_feciniplz_ppg002dato,
                             p_d_fecfinplz_ppg002dato,
                             p_d_fecsinies_ppg002dato);
    
      sp_uai_garantia_ppg004(gar.ppg000pgc,
                             gar.ppg000suc,
                             gar.ppg000mda,
                             gar.ppg000pap,
                             gar.ppg000cta,
                             gar.ppg000ope,
                             gar.ppg000sbo,
                             gar.ppg000top,
                             p_n_valrealiz_ppg004dato,
                             p_n_valcomerc_ppg004dato,
                             p_n_valedific_ppg004dato,
                             p_n_valreposi_ppg004dato,
                             p_n_valtasaci_ppg004dato,
                             p_n_valterren_ppg004dato,
                             p_n_areterren_ppg004dato,
                             p_n_nrohectar_ppg004dato,
                             p_n_areconstr_ppg004dato,
                             p_n_areexclus_ppg004dato,
                             p_n_aretechad_ppg004dato,
                             p_n_areacomun_ppg004dato);
    
      sp_uai_garantia_ppg007(gar.ppg000pgc,
                             gar.ppg000suc,
                             gar.ppg000mda,
                             gar.ppg000pap,
                             gar.ppg000cta,
                             gar.ppg000ope,
                             gar.ppg000sbo,
                             gar.ppg000top,
                             p_c_garpre_ppg007dato,
                             p_c_decfab_ppg007dato,
                             p_c_prohor_ppg007dato,
                             p_c_artesa_ppg007dato,
                             p_c_nue_ppg007dato,
                             p_c_compar_ppg007dato,
                             p_c_vigent_ppg007dato);
    
      sp_uai_garantia_ppg001(gar.ppg000pgc,
                             gar.ppg000suc,
                             gar.ppg000mda,
                             gar.ppg000pap,
                             gar.ppg000cta,
                             gar.ppg000ope,
                             gar.ppg000sbo,
                             gar.ppg000top,
                             p_c_nromot_ppg001dato,
                             p_c_modvehicu_ppg001dato,
                             p_c_asigravam_ppg001dato,
                             p_c_nrotitulo_ppg001dato,
                             p_c_tarpropie_ppg001dato,
                             p_c_parcodpre_ppg001dato,
                             p_c_nropoliza_ppg001dato,
                             p_c_refdirecc_ppg001dato,
                             p_c_colorvehi_ppg001dato,
                             p_c_direcc_ppg001dato,
                             p_c_nroser_ppg001dato,
                             p_c_mar_ppg001dato,
                             p_c_nropla_ppg001dato,
                             p_c_raz_ppg001dato,
                             p_c_nrorec_ppg001dato,
                             p_c_nrostn_ppg001dato,
                             p_c_factur_ppg001dato,
                             p_c_nrochs_ppg001dato,
                             p_c_marcav_ppg001dato);
    
      sp_uai_garantia_ppg008(gar.ppg000pgc,
                             gar.ppg000suc,
                             gar.ppg000mda,
                             gar.ppg000pap,
                             gar.ppg000cta,
                             gar.ppg000ope,
                             gar.ppg000sbo,
                             gar.ppg000top,
                             p_c_moneda_ppg008desc,
                             p_c_tipdep_ppg008desc,
                             p_c_nroope_ppg008desc,
                             p_c_tipinm_ppg008desc,
                             p_c_tipveh_ppg008desc,
                             p_c_ubigeo_ppg008desc,
                             p_c_tibide_ppg008desc,
                             p_c_uso_ppg008desc,
                             p_c_perito_ppg008desc,
                             p_c_bideav_ppg008desc);
    
      insert into uai_acldatgar
        (n_emppre_bcemp,
         n_modpre_bcmod,
         n_sucpre_bcsuc,
         n_mdapre_bcmda,
         n_pappre_bcpap,
         n_ctapre_bccta,
         n_opepre_bcoper,
         n_sbopre_bcsbop,
         n_toppre_bctop,
         n_empgar_ppg000pgc,
         n_modgar_ppg000mod,
         n_sucgar_ppg000suc,
         n_mdagar_ppg000mda,
         n_papgar_ppg000pap,
         n_ctagar_ppg000cta,
         n_opegar_ppg000ope,
         n_sbogar_ppg000sbo,
         n_topgar_ppg000top,
         n_anifabric_ppg003dato,
         n_aniconstr_ppg003dato,
         n_codmodveh_ppg003dato,
         n_numepisos_ppg003dato,
         n_numsotano_ppg003dato,
         n_numelotes_ppg003dato,
         n_codmarveh_ppg003dato,
         n_numasient_ppg003dato,
         c_despatrim_ppg006dato,
         c_comentari_ppg006dato,
         c_observaci_ppg006dato,
         c_regsinies_ppg006dato,
         d_fecconsti_ppg002dato,
         d_fecdeclar_ppg002dato,
         d_fectasaci_ppg002dato,
         d_fecremnot_ppg002dato,
         d_fecasiaux_ppg002dato,
         d_fecasiasi_ppg002dato,
         d_fecescrit_ppg002dato,
         d_fecprerrp_ppg002dato,
         d_fecinsrrp_ppg002dato,
         d_fecblqnot_ppg002dato,
         d_fecobsrrp_ppg002dato,
         d_fecsubrrp_ppg002dato,
         d_fecremgar_ppg002dato,
         d_fecentcli_ppg002dato,
         d_feciniplz_ppg002dato,
         d_fecfinplz_ppg002dato,
         d_fecsinies_ppg002dato,
         n_valrealiz_ppg004dato,
         n_valcomerc_ppg004dato,
         n_valedific_ppg004dato,
         n_valreposi_ppg004dato,
         n_valtasaci_ppg004dato,
         n_valterren_ppg004dato,
         n_areterren_ppg004dato,
         n_nrohectar_ppg004dato,
         n_areconstr_ppg004dato,
         n_areexclus_ppg004dato,
         n_aretechad_ppg004dato,
         n_areacomun_ppg004dato,
         c_garpre_ppg007dato,
         c_decfab_ppg007dato,
         c_prohor_ppg007dato,
         c_artesa_ppg007dato,
         c_nue_ppg007dato,
         c_compar_ppg007dato,
         c_vigent_ppg007dato,
         c_nromot_ppg001dato,
         c_modvehicu_ppg001dato,
         c_asigravam_ppg001dato,
         c_nrotitulo_ppg001dato,
         c_tarpropie_ppg001dato,
         c_parcodpre_ppg001dato,
         c_nropoliza_ppg001dato,
         c_refdirecc_ppg001dato,
         c_colorvehi_ppg001dato,
         c_direcc_ppg001dato,
         c_nroser_ppg001dato,
         c_mar_ppg001dato,
         c_nropla_ppg001dato,
         c_raz_ppg001dato,
         c_nrorec_ppg001dato,
         c_nrostn_ppg001dato,
         c_factur_ppg001dato,
         c_nrochs_ppg001dato,
         c_marcav_ppg001dato,
         c_moneda_ppg008desc,
         c_tipdep_ppg008desc,
         c_nroope_ppg008desc,
         c_tipinm_ppg008desc,
         c_tipveh_ppg008desc,
         c_ubigeo_ppg008desc,
         c_tibide_ppg008desc,
         c_uso_ppg008desc,
         c_perito_ppg008desc,
         c_bideav_ppg008desc)
      values
        (gar.n_emp_bcemp,
         gar.n_mod_bcmod,
         gar.n_suc_bcsuc,
         gar.n_mda_bcmda,
         gar.n_pap_bcpap,
         gar.n_cta_bccta,
         gar.n_oper_bcoper,
         gar.n_sbop_bcsbop,
         gar.n_tope_bctop,
         gar.ppg000pgc,
         gar.ppg000mod,
         gar.ppg000suc,
         gar.ppg000mda,
         gar.ppg000pap,
         gar.ppg000cta,
         gar.ppg000ope,
         gar.ppg000sbo,
         gar.ppg000top,
         p_n_anifabric_ppg003dato,
         p_n_aniconstr_ppg003dato,
         p_n_codmodveh_ppg003dato,
         p_n_numepisos_ppg003dato,
         p_n_numsotano_ppg003dato,
         p_n_numelotes_ppg003dato,
         p_n_codmarveh_ppg003dato,
         p_n_numasient_ppg003dato,
         p_c_despatrim_ppg006dato,
         p_c_comentari_ppg006dato,
         p_c_observaci_ppg006dato,
         p_c_regsinies_ppg006dato,
         p_d_fecconsti_ppg002dato,
         p_d_fecdeclar_ppg002dato,
         p_d_fectasaci_ppg002dato,
         p_d_fecremnot_ppg002dato,
         p_d_fecasiaux_ppg002dato,
         p_d_fecasiasi_ppg002dato,
         p_d_fecescrit_ppg002dato,
         p_d_fecprerrp_ppg002dato,
         p_d_fecinsrrp_ppg002dato,
         p_d_fecblqnot_ppg002dato,
         p_d_fecobsrrp_ppg002dato,
         p_d_fecsubrrp_ppg002dato,
         p_d_fecremgar_ppg002dato,
         p_d_fecentcli_ppg002dato,
         p_d_feciniplz_ppg002dato,
         p_d_fecfinplz_ppg002dato,
         p_d_fecsinies_ppg002dato,
         p_n_valrealiz_ppg004dato,
         p_n_valcomerc_ppg004dato,
         p_n_valedific_ppg004dato,
         p_n_valreposi_ppg004dato,
         p_n_valtasaci_ppg004dato,
         p_n_valterren_ppg004dato,
         p_n_areterren_ppg004dato,
         p_n_nrohectar_ppg004dato,
         p_n_areconstr_ppg004dato,
         p_n_areexclus_ppg004dato,
         p_n_aretechad_ppg004dato,
         p_n_areacomun_ppg004dato,
         p_c_garpre_ppg007dato,
         p_c_decfab_ppg007dato,
         p_c_prohor_ppg007dato,
         p_c_artesa_ppg007dato,
         p_c_nue_ppg007dato,
         p_c_compar_ppg007dato,
         p_c_vigent_ppg007dato,
         p_c_nromot_ppg001dato,
         p_c_modvehicu_ppg001dato,
         p_c_asigravam_ppg001dato,
         p_c_nrotitulo_ppg001dato,
         p_c_tarpropie_ppg001dato,
         p_c_parcodpre_ppg001dato,
         p_c_nropoliza_ppg001dato,
         p_c_refdirecc_ppg001dato,
         p_c_colorvehi_ppg001dato,
         p_c_direcc_ppg001dato,
         p_c_nroser_ppg001dato,
         p_c_mar_ppg001dato,
         p_c_nropla_ppg001dato,
         p_c_raz_ppg001dato,
         p_c_nrorec_ppg001dato,
         p_c_nrostn_ppg001dato,
         p_c_factur_ppg001dato,
         p_c_nrochs_ppg001dato,
         p_c_marcav_ppg001dato,
         p_c_moneda_ppg008desc,
         p_c_tipdep_ppg008desc,
         p_c_nroope_ppg008desc,
         p_c_tipinm_ppg008desc,
         p_c_tipveh_ppg008desc,
         p_c_ubigeo_ppg008desc,
         p_c_tibide_ppg008desc,
         p_c_uso_ppg008desc,
         p_c_perito_ppg008desc,
         p_c_bideav_ppg008desc);
    
    end loop;
  
    commit;
  
    --registrar hora de fin de ejecución de job
    update TAB_JOBS
       set D_FECFIN = sysdate
     where C_CODAGE = 'ACL'
       and N_NUMER1 = p_n_mod_bcmod
       and C_DATO2 = 'UAI_ACLDATGAR';
    commit;
  
  end;

  procedure sp_uai_garantia_ppg001(p_n_ppg001cod            in number,
                                   p_n_ppg001suc            in number,
                                   p_n_ppg001mda            in number,
                                   p_n_ppg001pap            in number,
                                   p_n_ppg001cta            in number,
                                   p_n_ppg001ope            in number,
                                   p_n_ppg001sbo            in number,
                                   p_n_ppg001top            in number,
                                   p_c_nromot_ppg001dato    out char,
                                   p_c_modvehicu_ppg001dato out char,
                                   p_c_asigravam_ppg001dato out char,
                                   p_c_nrotitulo_ppg001dato out char,
                                   p_c_tarpropie_ppg001dato out char,
                                   p_c_parcodpre_ppg001dato out char,
                                   p_c_nropoliza_ppg001dato out char,
                                   p_c_refdirecc_ppg001dato out char,
                                   p_c_colorvehi_ppg001dato out char,
                                   p_c_direcc_ppg001dato    out char,
                                   p_c_nroser_ppg001dato    out char,
                                   p_c_mar_ppg001dato       out char,
                                   p_c_nropla_ppg001dato    out char,
                                   p_c_raz_ppg001dato       out char,
                                   p_c_nrorec_ppg001dato    out char,
                                   p_c_nrostn_ppg001dato    out char,
                                   p_c_factur_ppg001dato    out char,
                                   p_c_nrochs_ppg001dato    out char,
                                   p_c_marcav_ppg001dato    out char) is
  
    cursor lc_datos_garantia is
      select ppg001cdat, ppg001dato
        from (select ppg001cod,
                     ppg001mod,
                     ppg001suc,
                     ppg001mda,
                     ppg001pap,
                     ppg001cta,
                     ppg001ope,
                     ppg001sbo,
                     ppg001top,
                     ppg001cdat,
                     ppg001frm,
                     ppg001dato,
                     max(ppg001frm) over(partition by ppg001cod, ppg001suc, ppg001mda, ppg001pap, ppg001cta, ppg001ope, ppg001sbo, ppg001top, ppg001cdat) ppg001frm_max
                from ppg001
               where ppg001cod = p_n_ppg001cod
                 and ppg001mod in (70, 470)
                 and ppg001suc = p_n_ppg001suc
                 and ppg001mda = p_n_ppg001mda
                 and ppg001pap = p_n_ppg001pap
                 and ppg001cta = p_n_ppg001cta
                 and ppg001ope = p_n_ppg001ope
                 and ppg001sbo = p_n_ppg001sbo
                 and ppg001top = p_n_ppg001top
                 and ppg001cdat in (15,
                                    124,
                                    142,
                                    159,
                                    28,
                                    129,
                                    155,
                                    116,
                                    27,
                                    41,
                                    13,
                                    14,
                                    23,
                                    143,
                                    157,
                                    117,
                                    74,
                                    26,
                                    122))
       where ppg001frm = ppg001frm_max;
  
  begin
  
    for datgar in lc_datos_garantia loop
    
      if (datgar.ppg001cdat = 15) then
        p_c_nromot_ppg001dato := datgar.ppg001dato;
      end if;
      if (datgar.ppg001cdat = 124) then
        p_c_modvehicu_ppg001dato := datgar.ppg001dato;
      end if;
      if (datgar.ppg001cdat = 142) then
        p_c_asigravam_ppg001dato := datgar.ppg001dato;
      end if;
      if (datgar.ppg001cdat = 159) then
        p_c_nrotitulo_ppg001dato := datgar.ppg001dato;
      end if;
      if (datgar.ppg001cdat = 28) then
        p_c_tarpropie_ppg001dato := datgar.ppg001dato;
      end if;
      if (datgar.ppg001cdat = 129) then
        p_c_parcodpre_ppg001dato := datgar.ppg001dato;
      end if;
      if (datgar.ppg001cdat = 155) then
        p_c_nropoliza_ppg001dato := datgar.ppg001dato;
      end if;
      if (datgar.ppg001cdat = 116) then
        p_c_refdirecc_ppg001dato := datgar.ppg001dato;
      end if;
      if (datgar.ppg001cdat = 27) then
        p_c_colorvehi_ppg001dato := datgar.ppg001dato;
      end if;
      if (datgar.ppg001cdat = 41) then
        p_c_direcc_ppg001dato := datgar.ppg001dato;
      end if;
      if (datgar.ppg001cdat = 13) then
        p_c_nroser_ppg001dato := datgar.ppg001dato;
      end if;
      if (datgar.ppg001cdat = 14) then
        p_c_mar_ppg001dato := datgar.ppg001dato;
      end if;
      if (datgar.ppg001cdat = 23) then
        p_c_nropla_ppg001dato := datgar.ppg001dato;
      end if;
      if (datgar.ppg001cdat = 143) then
        p_c_raz_ppg001dato := datgar.ppg001dato;
      end if;
      if (datgar.ppg001cdat = 157) then
        p_c_nrorec_ppg001dato := datgar.ppg001dato;
      end if;
      if (datgar.ppg001cdat = 117) then
        p_c_nrostn_ppg001dato := datgar.ppg001dato;
      end if;
      if (datgar.ppg001cdat = 74) then
        p_c_factur_ppg001dato := datgar.ppg001dato;
      end if;
      if (datgar.ppg001cdat = 26) then
        p_c_nrochs_ppg001dato := datgar.ppg001dato;
      end if;
      if (datgar.ppg001cdat = 122) then
        p_c_marcav_ppg001dato := datgar.ppg001dato;
      end if;
    
    end loop;
  
  end;

  procedure sp_uai_garantia_ppg003(p_n_ppg003cod            in number,
                                   p_n_ppg003suc            in number,
                                   p_n_ppg003mda            in number,
                                   p_n_ppg003pap            in number,
                                   p_n_ppg003cta            in number,
                                   p_n_ppg003ope            in number,
                                   p_n_ppg003sbo            in number,
                                   p_n_ppg003top            in number,
                                   p_n_anifabric_ppg003dato out number,
                                   p_n_aniconstr_ppg003dato out number,
                                   p_n_codmodveh_ppg003dato out number,
                                   p_n_numepisos_ppg003dato out number,
                                   p_n_numsotano_ppg003dato out number,
                                   p_n_numelotes_ppg003dato out number,
                                   p_n_codmarveh_ppg003dato out number,
                                   p_n_numasient_ppg003dato out number) is
  
    cursor lc_datos_garantia is
      select ppg003cdat, ppg003dato
        from (select ppg003cod,
                     ppg003mod,
                     ppg003suc,
                     ppg003mda,
                     ppg003pap,
                     ppg003cta,
                     ppg003ope,
                     ppg003sbo,
                     ppg003top,
                     ppg003cdat,
                     ppg003frm,
                     ppg003dato,
                     max(ppg003frm) over(partition by ppg003cod, ppg003suc, ppg003mda, ppg003pap, ppg003cta, ppg003ope, ppg003sbo, ppg003top, ppg003cdat) ppg003frm_max
                from ppg003
               where ppg003cod = p_n_ppg003cod
                 and ppg003mod in (70, 470)
                 and ppg003suc = p_n_ppg003suc
                 and ppg003mda = p_n_ppg003mda
                 and ppg003pap = p_n_ppg003pap
                 and ppg003cta = p_n_ppg003cta
                 and ppg003ope = p_n_ppg003ope
                 and ppg003sbo = p_n_ppg003sbo
                 and ppg003top = p_n_ppg003top
                 and ppg003cdat in (70, 76, 125, 84, 75, 135, 123, 24))
       where ppg003frm = ppg003frm_max;
  
  begin
  
    for datgar in lc_datos_garantia loop
    
      if (datgar.ppg003cdat = 70) then
        p_n_anifabric_ppg003dato := datgar.ppg003dato;
      end if;
      if (datgar.ppg003cdat = 76) then
        p_n_aniconstr_ppg003dato := datgar.ppg003dato;
      end if;
      if (datgar.ppg003cdat = 125) then
        p_n_codmodveh_ppg003dato := datgar.ppg003dato;
      end if;
      if (datgar.ppg003cdat = 84) then
        p_n_numepisos_ppg003dato := datgar.ppg003dato;
      end if;
      if (datgar.ppg003cdat = 75) then
        p_n_numsotano_ppg003dato := datgar.ppg003dato;
      end if;
      if (datgar.ppg003cdat = 135) then
        p_n_numelotes_ppg003dato := datgar.ppg003dato;
      end if;
      if (datgar.ppg003cdat = 123) then
        p_n_codmarveh_ppg003dato := datgar.ppg003dato;
      end if;
      if (datgar.ppg003cdat = 24) then
        p_n_numasient_ppg003dato := datgar.ppg003dato;
      end if;
    
    end loop;
  
  end;

  procedure sp_uai_garantia_ppg006(p_n_ppg006cod            in number,
                                   p_n_ppg006suc            in number,
                                   p_n_ppg006mda            in number,
                                   p_n_ppg006pap            in number,
                                   p_n_ppg006cta            in number,
                                   p_n_ppg006ope            in number,
                                   p_n_ppg006sbo            in number,
                                   p_n_ppg006top            in number,
                                   p_c_despatrim_ppg006dato out varchar2,
                                   p_c_comentari_ppg006dato out varchar2,
                                   p_c_observaci_ppg006dato out varchar2,
                                   p_c_regsinies_ppg006dato out varchar2) is
    cursor lc_datos_garantia is
      select ppg006cdat, ppg006dato
        from (select ppg006cod,
                     ppg006mod,
                     ppg006suc,
                     ppg006mda,
                     ppg006pap,
                     ppg006cta,
                     ppg006ope,
                     ppg006sbo,
                     ppg006top,
                     ppg006cdat,
                     ppg006frm,
                     ppg006dato,
                     max(ppg006frm) over(partition by ppg006cod, ppg006suc, ppg006mda, ppg006pap, ppg006cta, ppg006ope, ppg006sbo, ppg006top, ppg006cdat) ppg006frm_max
                from ppg006
               where ppg006cod = p_n_ppg006cod
                 and ppg006mod in (70, 470)
                 and ppg006suc = p_n_ppg006suc
                 and ppg006mda = p_n_ppg006mda
                 and ppg006pap = p_n_ppg006pap
                 and ppg006cta = p_n_ppg006cta
                 and ppg006ope = p_n_ppg006ope
                 and ppg006sbo = p_n_ppg006sbo
                 and ppg006top = p_n_ppg006top
                 and ppg006cdat in (88, 130, 83, 146))
       where ppg006frm = ppg006frm_max;
  
  begin
  
    for datgar in lc_datos_garantia loop
    
      if (datgar.ppg006cdat = 88) then
        p_c_despatrim_ppg006dato := datgar.ppg006dato;
      end if;
      if (datgar.ppg006cdat = 130) then
        p_c_comentari_ppg006dato := datgar.ppg006dato;
      end if;
      if (datgar.ppg006cdat = 83) then
        p_c_observaci_ppg006dato := datgar.ppg006dato;
      end if;
      if (datgar.ppg006cdat = 146) then
        p_c_regsinies_ppg006dato := datgar.ppg006dato;
      end if;
    
    end loop;
  
  end;

  procedure sp_uai_garantia_ppg002(p_n_ppg002cod            in number,
                                   p_n_ppg002suc            in number,
                                   p_n_ppg002mda            in number,
                                   p_n_ppg002pap            in number,
                                   p_n_ppg002cta            in number,
                                   p_n_ppg002ope            in number,
                                   p_n_ppg002sbo            in number,
                                   p_n_ppg002top            in number,
                                   p_d_fecconsti_ppg002dato out date,
                                   p_d_fecdeclar_ppg002dato out date,
                                   p_d_fectasaci_ppg002dato out date,
                                   p_d_fecremnot_ppg002dato out date,
                                   p_d_fecasiaux_ppg002dato out date,
                                   p_d_fecasiasi_ppg002dato out date,
                                   p_d_fecescrit_ppg002dato out date,
                                   p_d_fecprerrp_ppg002dato out date,
                                   p_d_fecinsrrp_ppg002dato out date,
                                   p_d_fecblqnot_ppg002dato out date,
                                   p_d_fecobsrrp_ppg002dato out date,
                                   p_d_fecsubrrp_ppg002dato out date,
                                   p_d_fecremgar_ppg002dato out date,
                                   p_d_fecentcli_ppg002dato out date,
                                   p_d_feciniplz_ppg002dato out date,
                                   p_d_fecfinplz_ppg002dato out date,
                                   p_d_fecsinies_ppg002dato out date) is
    cursor lc_datos_garantia is
      select ppg002cdat, ppg002dato
        from (select ppg002cod,
                     ppg002mod,
                     ppg002suc,
                     ppg002mda,
                     ppg002pap,
                     ppg002cta,
                     ppg002ope,
                     ppg002sbo,
                     ppg002top,
                     ppg002cdat,
                     ppg002frm,
                     ppg002dato,
                     max(ppg002frm) over(partition by ppg002cod, ppg002suc, ppg002mda, ppg002pap, ppg002cta, ppg002ope, ppg002sbo, ppg002top, ppg002cdat) ppg002frm_max
                from ppg002
               where ppg002cod = p_n_ppg002cod
                 and ppg002mod in (70, 470)
                 and ppg002suc = p_n_ppg002suc
                 and ppg002mda = p_n_ppg002mda
                 and ppg002pap = p_n_ppg002pap
                 and ppg002cta = p_n_ppg002cta
                 and ppg002ope = p_n_ppg002ope
                 and ppg002sbo = p_n_ppg002sbo
                 and ppg002top = p_n_ppg002top
                 and ppg002cdat in (127,
                                    38,
                                    77,
                                    90,
                                    91,
                                    92,
                                    93,
                                    94,
                                    95,
                                    96,
                                    97,
                                    98,
                                    99,
                                    100,
                                    101,
                                    102,
                                    148))
       where ppg002frm = ppg002frm_max;
  
  begin
  
    for datgar in lc_datos_garantia loop
    
      if (datgar.ppg002cdat = 127) then
        p_d_fecconsti_ppg002dato := datgar.ppg002dato;
      end if;
      if (datgar.ppg002cdat = 38) then
        p_d_fecdeclar_ppg002dato := datgar.ppg002dato;
      end if;
      if (datgar.ppg002cdat = 77) then
        p_d_fectasaci_ppg002dato := datgar.ppg002dato;
      end if;
      if (datgar.ppg002cdat = 90) then
        p_d_fecremnot_ppg002dato := datgar.ppg002dato;
      end if;
      if (datgar.ppg002cdat = 91) then
        p_d_fecasiaux_ppg002dato := datgar.ppg002dato;
      end if;
      if (datgar.ppg002cdat = 92) then
        p_d_fecasiasi_ppg002dato := datgar.ppg002dato;
      end if;
      if (datgar.ppg002cdat = 93) then
        p_d_fecescrit_ppg002dato := datgar.ppg002dato;
      end if;
      if (datgar.ppg002cdat = 94) then
        p_d_fecprerrp_ppg002dato := datgar.ppg002dato;
      end if;
      if (datgar.ppg002cdat = 95) then
        p_d_fecinsrrp_ppg002dato := datgar.ppg002dato;
      end if;
      if (datgar.ppg002cdat = 96) then
        p_d_fecblqnot_ppg002dato := datgar.ppg002dato;
      end if;
      if (datgar.ppg002cdat = 97) then
        p_d_fecobsrrp_ppg002dato := datgar.ppg002dato;
      end if;
      if (datgar.ppg002cdat = 98) then
        p_d_fecsubrrp_ppg002dato := datgar.ppg002dato;
      end if;
      if (datgar.ppg002cdat = 99) then
        p_d_fecremgar_ppg002dato := datgar.ppg002dato;
      end if;
      if (datgar.ppg002cdat = 100) then
        p_d_fecentcli_ppg002dato := datgar.ppg002dato;
      end if;
      if (datgar.ppg002cdat = 101) then
        p_d_feciniplz_ppg002dato := datgar.ppg002dato;
      end if;
      if (datgar.ppg002cdat = 102) then
        p_d_fecfinplz_ppg002dato := datgar.ppg002dato;
      end if;
      if (datgar.ppg002cdat = 148) then
        p_d_fecsinies_ppg002dato := datgar.ppg002dato;
      end if;
    
    end loop;
  
  end;

  procedure sp_uai_garantia_ppg004(p_n_ppg004cod            in number,
                                   p_n_ppg004suc            in number,
                                   p_n_ppg004mda            in number,
                                   p_n_ppg004pap            in number,
                                   p_n_ppg004cta            in number,
                                   p_n_ppg004ope            in number,
                                   p_n_ppg004sbo            in number,
                                   p_n_ppg004top            in number,
                                   p_n_valrealiz_ppg004dato out number,
                                   p_n_valcomerc_ppg004dato out number,
                                   p_n_valedific_ppg004dato out number,
                                   p_n_valreposi_ppg004dato out number,
                                   p_n_valtasaci_ppg004dato out number,
                                   p_n_valterren_ppg004dato out number,
                                   p_n_areterren_ppg004dato out number,
                                   p_n_nrohectar_ppg004dato out number,
                                   p_n_areconstr_ppg004dato out number,
                                   p_n_areexclus_ppg004dato out number,
                                   p_n_aretechad_ppg004dato out number,
                                   p_n_areacomun_ppg004dato out number) is
    cursor lc_datos_garantia is
      select ppg004cdat, ppg004dato
        from (select ppg004cod,
                     ppg004mod,
                     ppg004suc,
                     ppg004mda,
                     ppg004pap,
                     ppg004cta,
                     ppg004ope,
                     ppg004sbo,
                     ppg004top,
                     ppg004cdat,
                     ppg004frm,
                     ppg004dato,
                     max(ppg004frm) over(partition by ppg004cod, ppg004suc, ppg004mda, ppg004pap, ppg004cta, ppg004ope, ppg004sbo, ppg004top, ppg004cdat) ppg004frm_max
                from ppg004
               where ppg004cod = p_n_ppg004cod
                 and ppg004mod in (70, 470)
                 and ppg004suc = p_n_ppg004suc
                 and ppg004mda = p_n_ppg004mda
                 and ppg004pap = p_n_ppg004pap
                 and ppg004cta = p_n_ppg004cta
                 and ppg004ope = p_n_ppg004ope
                 and ppg004sbo = p_n_ppg004sbo
                 and ppg004top = p_n_ppg004top
                 and ppg004cdat in
                     (136, 63, 67, 64, 103, 62, 137, 126, 139, 140, 138, 141))
       where ppg004frm = ppg004frm_max;
  
  begin
  
    for datgar in lc_datos_garantia loop
    
      if (datgar.ppg004cdat = 136) then
        p_n_valrealiz_ppg004dato := datgar.ppg004dato;
      end if;
      if (datgar.ppg004cdat = 63) then
        p_n_valcomerc_ppg004dato := datgar.ppg004dato;
      end if;
      if (datgar.ppg004cdat = 67) then
        p_n_valedific_ppg004dato := datgar.ppg004dato;
      end if;
      if (datgar.ppg004cdat = 64) then
        p_n_valreposi_ppg004dato := datgar.ppg004dato;
      end if;
      if (datgar.ppg004cdat = 103) then
        p_n_valtasaci_ppg004dato := datgar.ppg004dato;
      end if;
      if (datgar.ppg004cdat = 62) then
        p_n_valterren_ppg004dato := datgar.ppg004dato;
      end if;
      if (datgar.ppg004cdat = 137) then
        p_n_areterren_ppg004dato := datgar.ppg004dato;
      end if;
      if (datgar.ppg004cdat = 126) then
        p_n_nrohectar_ppg004dato := datgar.ppg004dato;
      end if;
      if (datgar.ppg004cdat = 139) then
        p_n_areconstr_ppg004dato := datgar.ppg004dato;
      end if;
      if (datgar.ppg004cdat = 140) then
        p_n_areexclus_ppg004dato := datgar.ppg004dato;
      end if;
      if (datgar.ppg004cdat = 138) then
        p_n_aretechad_ppg004dato := datgar.ppg004dato;
      end if;
      if (datgar.ppg004cdat = 141) then
        p_n_areacomun_ppg004dato := datgar.ppg004dato;
      end if;
    
    end loop;
  
  end;

  procedure sp_uai_garantia_ppg007(p_n_ppg007cod         in number,
                                   p_n_ppg007suc         in number,
                                   p_n_ppg007mda         in number,
                                   p_n_ppg007pap         in number,
                                   p_n_ppg007cta         in number,
                                   p_n_ppg007ope         in number,
                                   p_n_ppg007sbo         in number,
                                   p_n_ppg007top         in number,
                                   p_c_garpre_ppg007dato out char,
                                   p_c_decfab_ppg007dato out char,
                                   p_c_prohor_ppg007dato out char,
                                   p_c_artesa_ppg007dato out char,
                                   p_c_nue_ppg007dato    out char,
                                   p_c_compar_ppg007dato out char,
                                   p_c_vigent_ppg007dato out char) is
    cursor lc_datos_garantia is
      select ppg007cdat, ppg007dato
        from (select ppg007cod,
                     ppg007mod,
                     ppg007suc,
                     ppg007mda,
                     ppg007pap,
                     ppg007cta,
                     ppg007ope,
                     ppg007sbo,
                     ppg007top,
                     ppg007cdat,
                     ppg007frm,
                     ppg007dato,
                     max(ppg007frm) over(partition by ppg007cod, ppg007suc, ppg007mda, ppg007pap, ppg007cta, ppg007ope, ppg007sbo, ppg007top, ppg007cdat) ppg007frm_max
                from ppg007
               where ppg007cod = p_n_ppg007cod
                 and ppg007mod in (70, 470)
                 and ppg007suc = p_n_ppg007suc
                 and ppg007mda = p_n_ppg007mda
                 and ppg007pap = p_n_ppg007pap
                 and ppg007cta = p_n_ppg007cta
                 and ppg007ope = p_n_ppg007ope
                 and ppg007sbo = p_n_ppg007sbo
                 and ppg007top = p_n_ppg007top
                 and ppg007cdat in (158, 48, 49, 50, 51, 113, 145))
       where ppg007frm = ppg007frm_max;
  
  begin
  
    for datgar in lc_datos_garantia loop
    
      if (datgar.ppg007cdat = 158) then
        p_c_garpre_ppg007dato := datgar.ppg007dato;
      end if;
      if (datgar.ppg007cdat = 48) then
        p_c_decfab_ppg007dato := datgar.ppg007dato;
      end if;
      if (datgar.ppg007cdat = 49) then
        p_c_prohor_ppg007dato := datgar.ppg007dato;
      end if;
      if (datgar.ppg007cdat = 50) then
        p_c_artesa_ppg007dato := datgar.ppg007dato;
      end if;
      if (datgar.ppg007cdat = 51) then
        p_c_nue_ppg007dato := datgar.ppg007dato;
      end if;
      if (datgar.ppg007cdat = 113) then
        p_c_compar_ppg007dato := datgar.ppg007dato;
      end if;
      if (datgar.ppg007cdat = 145) then
        p_c_vigent_ppg007dato := datgar.ppg007dato;
      end if;
    
    end loop;
  
  end;

  procedure sp_uai_garantia_ppg008(p_n_ppg008cod         in number,
                                   p_n_ppg008suc         in number,
                                   p_n_ppg008mda         in number,
                                   p_n_ppg008pap         in number,
                                   p_n_ppg008cta         in number,
                                   p_n_ppg008ope         in number,
                                   p_n_ppg008sbo         in number,
                                   p_n_ppg008top         in number,
                                   p_c_moneda_ppg008desc out char,
                                   p_c_tipdep_ppg008desc out char,
                                   p_c_nroope_ppg008desc out char,
                                   p_c_tipinm_ppg008desc out char,
                                   p_c_tipveh_ppg008desc out char,
                                   p_c_ubigeo_ppg008desc out char,
                                   p_c_tibide_ppg008desc out char,
                                   p_c_uso_ppg008desc    out char,
                                   p_c_perito_ppg008desc out char,
                                   p_c_bideav_ppg008desc out char) is
    cursor lc_datos_garantia is
      select ppg008cdat, ppg008desc
        from (select ppg008pgc,
                     ppg008mod,
                     ppg008suc,
                     ppg008mda,
                     ppg008pap,
                     ppg008cta,
                     ppg008ope,
                     ppg008sbo,
                     ppg008top,
                     ppg008cdat,
                     ppg008frm,
                     ppg008desc,
                     max(ppg008frm) over(partition by ppg008pgc, ppg008suc, ppg008mda, ppg008pap, ppg008cta, ppg008ope, ppg008sbo, ppg008top, ppg008cdat) ppg008frm_max
                from ppg008
               where ppg008pgc = p_n_ppg008cod
                 and ppg008mod in (70, 470)
                 and ppg008suc = p_n_ppg008suc
                 and ppg008mda = p_n_ppg008mda
                 and ppg008pap = p_n_ppg008pap
                 and ppg008cta = p_n_ppg008cta
                 and ppg008ope = p_n_ppg008ope
                 and ppg008sbo = p_n_ppg008sbo
                 and ppg008top = p_n_ppg008top
                 and ppg008cdat in
                     (2, 33, 34, 47, 52, 58, 59, 120, 121, 131))
       where ppg008frm = ppg008frm_max;
  
  begin
  
    for datgar in lc_datos_garantia loop
    
      if (datgar.ppg008cdat = 2) then
        p_c_moneda_ppg008desc := datgar.ppg008desc;
      end if;
      if (datgar.ppg008cdat = 33) then
        p_c_tipdep_ppg008desc := datgar.ppg008desc;
      end if;
      if (datgar.ppg008cdat = 34) then
        p_c_nroope_ppg008desc := datgar.ppg008desc;
      end if;
      if (datgar.ppg008cdat = 47) then
        p_c_tipinm_ppg008desc := datgar.ppg008desc;
      end if;
      if (datgar.ppg008cdat = 52) then
        p_c_tipveh_ppg008desc := datgar.ppg008desc;
      end if;
      if (datgar.ppg008cdat = 58) then
        p_c_ubigeo_ppg008desc := datgar.ppg008desc;
      end if;
      if (datgar.ppg008cdat = 59) then
        p_c_tibide_ppg008desc := datgar.ppg008desc;
      end if;
      if (datgar.ppg008cdat = 120) then
        p_c_uso_ppg008desc := datgar.ppg008desc;
      end if;
      if (datgar.ppg008cdat = 121) then
        p_c_perito_ppg008desc := datgar.ppg008desc;
      end if;
      if (datgar.ppg008cdat = 131) then
        p_c_bideav_ppg008desc := datgar.ppg008desc;
      end if;
    
    end loop;
  
  end;

  -------------------------------------------------------------------------------------------------

  procedure sp_uai_jobs_evaluaciones is
    --
    -- Nombre:                        sp_uai_jobs_refinanciados
    -- Area de Negocio:               Auditoría Interna
    -- Frente:                        Normativo
    --  
  
    lc_sp_evalua varchar2(500);
    ln_job       number;  
    ln_limit     number := 0;
    ln_numjob    number := 0;
    
    cursor lcur_sucursales is
      select distinct n_suc_bcsuc from uai_aclpre;
    lc_hostname varchar2(64); --mod@abr 20170424
  begin
  
    --EVALUACIONES CLIENTES DEPENDIENTES
  
    --eliminar datos de tabla de evaluaciones para clientes dependientes
    execute immediate 'truncate table UAI_ACLEVALUADEP';
  
    --eliminar jobs para refinanciados
    delete from TAB_JOBS
     where C_CODAGE = 'ACL'
       and C_DATO2 = 'UAI_ACLEVALUADEP';
  
    commit;
    --mod@abr 20170424
    begin
      select host_name into lc_hostname from v$instance;
    end;
    
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
    
    --mod@abr 20170424
    ln_job := 0;
    for suc in lcur_sucursales loop
    
      --lanzar job para sucursal
      ln_job := ln_job + 1;
    
      lc_sp_evalua := 'PQ_UAI_DATOS_ACL.sp_uai_evaluacion_dep(' ||
                      suc.n_suc_bcsuc || ');';
      --mod@abr 20170424
      --      if UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101') then      
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        dbms_job.submit(ln_job,
                        what      => lc_sp_evalua,
                        next_date => sysdate + 0.5 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        instance  => 1,
                        --instance => 2, 01/01/2024 
                        force => false);
      else
        dbms_job.submit(ln_job,
                        what      => lc_sp_evalua,
                        next_date => sysdate + 0.5 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      end if;
    
      --DBMS_JOB.SUBMIT(ln_job, lc_sp_evalua, sysdate + 0.5 / (24 * 60), null, false, 2, false);
      --mod@abr 20170424
      
      --apachecoh 2024.02.09  
      BEGIN
        SELECT count(*)
          INTO ln_numjob
          FROM dba_jobs x
         WHERE upper(x.what) LIKE '%PQ_UAI_DATOS_ACL.SP_UAI_EVALUACION_DEP%';
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
                 '%PQ_UAI_DATOS_ACL.SP_UAI_EVALUACION_DEP%';
        EXCEPTION
          WHEN OTHERS THEN
            ln_numjob := 0;
        END;
      END LOOP;
      
      --registrar ejecución de job para sucursal
      insert into TAB_JOBS
        (C_CODAGE, C_DETJOB, N_NUMER1, C_DATO2)
      values
        ('ACL', lc_sp_evalua, suc.n_suc_bcsuc, 'UAI_ACLEVALUADEP');    
      commit;
    
    end loop;
  
    --EVALUACIONES CLIENTES INDEPENDIENTES    
  
    --eliminar datos de tabla de evaluaciones para clientes dependientes
    execute immediate 'truncate table UAI_ACLEVALUAIND';
  
    --eliminar jobs para refinanciados
    delete from TAB_JOBS
     where C_CODAGE = 'ACL'
       and C_DATO2 = 'UAI_ACLEVALUAIND';
  
    commit;
  
    ln_job := 0;
    for suc in lcur_sucursales loop
    
      --lanzar job para sucursal
      ln_job := ln_job + 1;
    
      lc_sp_evalua := 'PQ_UAI_DATOS_ACL.sp_uai_evaluacion_ind(' ||
                      suc.n_suc_bcsuc || ');';
      --mod@abr 20170424
      --      if UPPER(lc_hostname) in ('SC01ZDBADM010101','SC01ZDBADM020101') then      
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        dbms_job.submit(ln_job,
                        what      => lc_sp_evalua,
                        next_date => sysdate + 0.5 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        instance  => 1,
                        --instance => 2, 01/01/2024 
                        force => false);
      else
        dbms_job.submit(ln_job,
                        what      => lc_sp_evalua,
                        next_date => sysdate + 0.5 / (24 * 60),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      end if;
    
      --DBMS_JOB.SUBMIT(ln_job, lc_sp_evalua, sysdate + 0.5 / (24 * 60), null, false, 2, false);
      --mod@abr 20170424
      
      --apachecoh 2024.02.09  
      BEGIN
        SELECT count(*)
          INTO ln_numjob
          FROM dba_jobs x
         WHERE upper(x.what) LIKE '%PQ_UAI_DATOS_ACL.SP_UAI_EVALUACION_IND%';
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
                 '%PQ_UAI_DATOS_ACL.SP_UAI_EVALUACION_IND%';
        EXCEPTION
          WHEN OTHERS THEN
            ln_numjob := 0;
        END;
      END LOOP;
      
      --registrar ejecución de job para sucursal
      insert into TAB_JOBS
        (C_CODAGE, C_DETJOB, N_NUMER1, C_DATO2)
      values
        ('ACL', lc_sp_evalua, suc.n_suc_bcsuc, 'UAI_ACLEVALUAIND');
    
      commit;
    
    end loop;
  
  exception
    when others then
      dbms_output.put_line('error');
  end;

  -------------------------------------------------------------------------------------------------

  procedure sp_uai_evaluacion_dep(p_n_numsuc in number) is
    --
    -- Nombre:                        sp_uai_evaluacion_dependiente
    -- Area de Negocio:               Auditoría Interna
    -- Frente:                        Normativo
    --  
  
    cursor lcur_evaluaciones is
      select sng021eval, sng026cod, sng023mto
        from sng023
       where sng021eval in
             (select distinct max(s.sng021eval) over(partition by s.sng021pdoc, s.sng021tdoc, s.sng021ndoc, s.sng021sol) sng021eval_max
                from uai_aclpre p
                left join sng021 s
                  on p.n_instancia_xwfprcins = s.sng021sol
               where s.sng021tmod = 14
                 and p.n_suc_bcsuc = p_n_numsuc)
       order by sng021eval, sng026cod;
  
    ld_fecevalua_sng021fec       UAI_ACLEVALUADEP.d_fecevalua_sng021fec%type;
    ln_tipcam_sng120tcbi         UAI_ACLEVALUADEP.n_tipcam_sng120tcbi%type;
    ln_instan_sng021sol          UAI_ACLEVALUADEP.n_instan_sng021sol%type;
    ln_numeva_sng021eval         UAI_ACLEVALUADEP.n_numeva_sng021eval%type;
    ln_salbrutitsol_sng023mto    UAI_ACLEVALUADEP.n_salbrutitsol_sng023mto%type;
    ln_salbruconsol_sng023mto    UAI_ACLEVALUADEP.n_salbruconsol_sng023mto%type;
    ln_salbrucomsol_sng023mto    UAI_ACLEVALUADEP.n_salbrucomsol_sng023mto%type;
    ln_salbruotrsol_sng023mto    UAI_ACLEVALUADEP.n_salbruotrsol_sng023mto%type;
    ln_apotitsol_sng023mto       UAI_ACLEVALUADEP.n_apotitsol_sng023mto%type;
    ln_apoconsol_sng023mto       UAI_ACLEVALUADEP.n_apoconsol_sng023mto%type;
    ln_apocomsol_sng023mto       UAI_ACLEVALUADEP.n_apocomsol_sng023mto%type;
    ln_apootrsol_sng023mto       UAI_ACLEVALUADEP.n_apootrsol_sng023mto%type;
    ln_otringtitsol_sng023mto    UAI_ACLEVALUADEP.n_otringtitsol_sng023mto%type;
    ln_otringconsol_sng023mto    UAI_ACLEVALUADEP.n_otringconsol_sng023mto%type;
    ln_otringcomsol_sng023mto    UAI_ACLEVALUADEP.n_otringcomsol_sng023mto%type;
    ln_otringotrsol_sng023mto    UAI_ACLEVALUADEP.n_otringotrsol_sng023mto%type;
    ln_alimensol_sng023mto       UAI_ACLEVALUADEP.n_alimensol_sng023mto%type;
    ln_alqvivsol_sng023mto       UAI_ACLEVALUADEP.n_alqvivsol_sng023mto%type;
    ln_transpsol_sng023mto       UAI_ACLEVALUADEP.n_transpsol_sng023mto%type;
    ln_educacsol_sng023mto       UAI_ACLEVALUADEP.n_educacsol_sng023mto%type;
    ln_serpubsol_sng023mto       UAI_ACLEVALUADEP.n_serpubsol_sng023mto%type;
    ln_apofamsol_sng023mto       UAI_ACLEVALUADEP.n_apofamsol_sng023mto%type;
    ln_otrgasgensol_sng023mto    UAI_ACLEVALUADEP.n_otrgasgensol_sng023mto%type;
    ln_imprevsol_sng023mto       UAI_ACLEVALUADEP.n_imprevsol_sng023mto%type;
    ln_totingsol_sng023mto       UAI_ACLEVALUADEP.n_totingsol_sng023mto%type;
    ln_totegrsol_sng023mto       UAI_ACLEVALUADEP.n_totegrsol_sng023mto%type;
    ln_totactsol_sng023mto       UAI_ACLEVALUADEP.n_totactsol_sng023mto%type;
    ln_totpassol_sng023mto       UAI_ACLEVALUADEP.n_totpassol_sng023mto%type;
    ln_totpatsol_sng023mto       UAI_ACLEVALUADEP.n_totpatsol_sng023mto%type;
    ln_cuomndcresol_sng023mto    UAI_ACLEVALUADEP.n_cuomndcresol_sng023mto%type;
    ln_excmensol_sng023mto       UAI_ACLEVALUADEP.n_excmensol_sng023mto%type;
    ln_cobcuocrepersol_sng023mto UAI_ACLEVALUADEP.n_cobcuocrepersol_sng023mto%type;
    ln_moncresolsol_sng023mto    UAI_ACLEVALUADEP.n_moncresolsol_sng023mto%type;
    ln_enddeusol_sng023mto       UAI_ACLEVALUADEP.n_enddeusol_sng023mto%type;
    ln_salbrutitdol_sng023mto    UAI_ACLEVALUADEP.n_salbrutitdol_sng023mto%type;
    ln_salbrucondol_sng023mto    UAI_ACLEVALUADEP.n_salbrucondol_sng023mto%type;
    ln_salbrucomdol_sng023mto    UAI_ACLEVALUADEP.n_salbrucomdol_sng023mto%type;
    ln_salbruotrdol_sng023mto    UAI_ACLEVALUADEP.n_salbruotrdol_sng023mto%type;
    ln_apotitdol_sng023mto       UAI_ACLEVALUADEP.n_apotitdol_sng023mto%type;
    ln_apocondol_sng023mto       UAI_ACLEVALUADEP.n_apocondol_sng023mto%type;
    ln_apocomdol_sng023mto       UAI_ACLEVALUADEP.n_apocomdol_sng023mto%type;
    ln_apootrdol_sng023mto       UAI_ACLEVALUADEP.n_apootrdol_sng023mto%type;
    ln_otringtitdol_sng023mto    UAI_ACLEVALUADEP.n_otringtitdol_sng023mto%type;
    ln_otringcondol_sng023mto    UAI_ACLEVALUADEP.n_otringcondol_sng023mto%type;
    ln_otringcomdol_sng023mto    UAI_ACLEVALUADEP.n_otringcomdol_sng023mto%type;
    ln_otringotrdol_sng023mto    UAI_ACLEVALUADEP.n_otringotrdol_sng023mto%type;
    ln_alimendol_sng023mto       UAI_ACLEVALUADEP.n_alimendol_sng023mto%type;
    ln_alqvivdol_sng023mto       UAI_ACLEVALUADEP.n_alqvivdol_sng023mto%type;
    ln_transpdol_sng023mto       UAI_ACLEVALUADEP.n_transpdol_sng023mto%type;
    ln_educacdol_sng023mto       UAI_ACLEVALUADEP.n_educacdol_sng023mto%type;
    ln_serpubdol_sng023mto       UAI_ACLEVALUADEP.n_serpubdol_sng023mto%type;
    ln_apofamdol_sng023mto       UAI_ACLEVALUADEP.n_apofamdol_sng023mto%type;
    ln_otrgasgendol_sng023mto    UAI_ACLEVALUADEP.n_otrgasgendol_sng023mto%type;
    ln_imprevdol_sng023mto       UAI_ACLEVALUADEP.n_imprevdol_sng023mto%type;
    ln_totingdol_sng023mto       UAI_ACLEVALUADEP.n_totingdol_sng023mto%type;
    ln_totegrdol_sng023mto       UAI_ACLEVALUADEP.n_totegrdol_sng023mto%type;
    ln_totpasdol_sng023mto       UAI_ACLEVALUADEP.n_totpasdol_sng023mto%type;
    ln_cuomndcredol_sng023mto    UAI_ACLEVALUADEP.n_cuomndcredol_sng023mto%type;
    ln_excmendol_sng023mto       UAI_ACLEVALUADEP.n_excmendol_sng023mto%type;
    ln_cobcuocreperdol_sng023mto UAI_ACLEVALUADEP.n_cobcuocreperdol_sng023mto%type;
    ln_moncresoldol_sng023mto    UAI_ACLEVALUADEP.n_moncresoldol_sng023mto%type;
  
  begin
  
    --registrar hora de inicio de ejecución de job
    update TAB_JOBS
       set D_FECINI = sysdate
     where C_CODAGE = 'ACL'
       and N_NUMER1 = p_n_numsuc
       and C_DATO2 = 'UAI_ACLEVALUADEP';
    commit;
  
    ln_numeva_sng021eval := -1;
  
    for eval in lcur_evaluaciones loop
    
      if (eval.sng021eval <> ln_numeva_sng021eval And
         ln_numeva_sng021eval <> -1) then
      
        select sng021fec, sng021sol
          into ld_fecevalua_sng021fec, ln_instan_sng021sol
          from sng021
         where sng021eval = ln_numeva_sng021eval;
      
        select sng120tcbi
          into ln_tipcam_sng120tcbi
          from sng120
         where sng120ins = ln_instan_sng021sol
           and sng120tsk like 'EVALUACION%'
           and sng120mod = 0;
      
        insert into UAI_ACLEVALUADEP
          (n_numeva_sng021eval,
           d_fecevalua_sng021fec,
           n_tipcam_sng120tcbi,
           n_instan_sng021sol,
           n_salbrutitsol_sng023mto,
           n_salbruconsol_sng023mto,
           n_salbrucomsol_sng023mto,
           n_salbruotrsol_sng023mto,
           n_apotitsol_sng023mto,
           n_apoconsol_sng023mto,
           n_apocomsol_sng023mto,
           n_apootrsol_sng023mto,
           n_otringtitsol_sng023mto,
           n_otringconsol_sng023mto,
           n_otringcomsol_sng023mto,
           n_otringotrsol_sng023mto,
           n_alimensol_sng023mto,
           n_alqvivsol_sng023mto,
           n_transpsol_sng023mto,
           n_educacsol_sng023mto,
           n_serpubsol_sng023mto,
           n_apofamsol_sng023mto,
           n_otrgasgensol_sng023mto,
           n_imprevsol_sng023mto,
           n_totingsol_sng023mto,
           n_totegrsol_sng023mto,
           n_totactsol_sng023mto,
           n_totpassol_sng023mto,
           n_totpatsol_sng023mto,
           n_cuomndcresol_sng023mto,
           n_excmensol_sng023mto,
           n_cobcuocrepersol_sng023mto,
           n_moncresolsol_sng023mto,
           n_enddeusol_sng023mto,
           n_salbrutitdol_sng023mto,
           n_salbrucondol_sng023mto,
           n_salbrucomdol_sng023mto,
           n_salbruotrdol_sng023mto,
           n_apotitdol_sng023mto,
           n_apocondol_sng023mto,
           n_apocomdol_sng023mto,
           n_apootrdol_sng023mto,
           n_otringtitdol_sng023mto,
           n_otringcondol_sng023mto,
           n_otringcomdol_sng023mto,
           n_otringotrdol_sng023mto,
           n_alimendol_sng023mto,
           n_alqvivdol_sng023mto,
           n_transpdol_sng023mto,
           n_educacdol_sng023mto,
           n_serpubdol_sng023mto,
           n_apofamdol_sng023mto,
           n_otrgasgendol_sng023mto,
           n_imprevdol_sng023mto,
           n_totingdol_sng023mto,
           n_totegrdol_sng023mto,
           n_totpasdol_sng023mto,
           n_cuomndcredol_sng023mto,
           n_excmendol_sng023mto,
           n_cobcuocreperdol_sng023mto,
           n_moncresoldol_sng023mto)
        values
          (ln_numeva_sng021eval,
           ld_fecevalua_sng021fec,
           ln_tipcam_sng120tcbi,
           ln_instan_sng021sol,
           ln_salbrutitsol_sng023mto,
           ln_salbruconsol_sng023mto,
           ln_salbrucomsol_sng023mto,
           ln_salbruotrsol_sng023mto,
           ln_apotitsol_sng023mto,
           ln_apoconsol_sng023mto,
           ln_apocomsol_sng023mto,
           ln_apootrsol_sng023mto,
           ln_otringtitsol_sng023mto,
           ln_otringconsol_sng023mto,
           ln_otringcomsol_sng023mto,
           ln_otringotrsol_sng023mto,
           ln_alimensol_sng023mto,
           ln_alqvivsol_sng023mto,
           ln_transpsol_sng023mto,
           ln_educacsol_sng023mto,
           ln_serpubsol_sng023mto,
           ln_apofamsol_sng023mto,
           ln_otrgasgensol_sng023mto,
           ln_imprevsol_sng023mto,
           ln_totingsol_sng023mto,
           ln_totegrsol_sng023mto,
           ln_totactsol_sng023mto,
           ln_totpassol_sng023mto,
           ln_totpatsol_sng023mto,
           ln_cuomndcresol_sng023mto,
           ln_excmensol_sng023mto,
           ln_cobcuocrepersol_sng023mto,
           ln_moncresolsol_sng023mto,
           ln_enddeusol_sng023mto,
           ln_salbrutitdol_sng023mto,
           ln_salbrucondol_sng023mto,
           ln_salbrucomdol_sng023mto,
           ln_salbruotrdol_sng023mto,
           ln_apotitdol_sng023mto,
           ln_apocondol_sng023mto,
           ln_apocomdol_sng023mto,
           ln_apootrdol_sng023mto,
           ln_otringtitdol_sng023mto,
           ln_otringcondol_sng023mto,
           ln_otringcomdol_sng023mto,
           ln_otringotrdol_sng023mto,
           ln_alimendol_sng023mto,
           ln_alqvivdol_sng023mto,
           ln_transpdol_sng023mto,
           ln_educacdol_sng023mto,
           ln_serpubdol_sng023mto,
           ln_apofamdol_sng023mto,
           ln_otrgasgendol_sng023mto,
           ln_imprevdol_sng023mto,
           ln_totingdol_sng023mto,
           ln_totegrdol_sng023mto,
           ln_totpasdol_sng023mto,
           ln_cuomndcredol_sng023mto,
           ln_excmendol_sng023mto,
           ln_cobcuocreperdol_sng023mto,
           ln_moncresoldol_sng023mto);
      
        ln_salbrutitsol_sng023mto    := null;
        ln_salbruconsol_sng023mto    := null;
        ln_salbrucomsol_sng023mto    := null;
        ln_salbruotrsol_sng023mto    := null;
        ln_apotitsol_sng023mto       := null;
        ln_apoconsol_sng023mto       := null;
        ln_apocomsol_sng023mto       := null;
        ln_apootrsol_sng023mto       := null;
        ln_otringtitsol_sng023mto    := null;
        ln_otringconsol_sng023mto    := null;
        ln_otringcomsol_sng023mto    := null;
        ln_otringotrsol_sng023mto    := null;
        ln_alimensol_sng023mto       := null;
        ln_alqvivsol_sng023mto       := null;
        ln_transpsol_sng023mto       := null;
        ln_educacsol_sng023mto       := null;
        ln_serpubsol_sng023mto       := null;
        ln_apofamsol_sng023mto       := null;
        ln_otrgasgensol_sng023mto    := null;
        ln_imprevsol_sng023mto       := null;
        ln_totingsol_sng023mto       := null;
        ln_totegrsol_sng023mto       := null;
        ln_totactsol_sng023mto       := null;
        ln_totpassol_sng023mto       := null;
        ln_totpatsol_sng023mto       := null;
        ln_cuomndcresol_sng023mto    := null;
        ln_excmensol_sng023mto       := null;
        ln_cobcuocrepersol_sng023mto := null;
        ln_moncresolsol_sng023mto    := null;
        ln_enddeusol_sng023mto       := null;
        ln_salbrutitdol_sng023mto    := null;
        ln_salbrucondol_sng023mto    := null;
        ln_salbrucomdol_sng023mto    := null;
        ln_salbruotrdol_sng023mto    := null;
        ln_apotitdol_sng023mto       := null;
        ln_apocondol_sng023mto       := null;
        ln_apocomdol_sng023mto       := null;
        ln_apootrdol_sng023mto       := null;
        ln_otringtitdol_sng023mto    := null;
        ln_otringcondol_sng023mto    := null;
        ln_otringcomdol_sng023mto    := null;
        ln_otringotrdol_sng023mto    := null;
        ln_alimendol_sng023mto       := null;
        ln_alqvivdol_sng023mto       := null;
        ln_transpdol_sng023mto       := null;
        ln_educacdol_sng023mto       := null;
        ln_serpubdol_sng023mto       := null;
        ln_apofamdol_sng023mto       := null;
        ln_otrgasgendol_sng023mto    := null;
        ln_imprevdol_sng023mto       := null;
        ln_totingdol_sng023mto       := null;
        ln_totegrdol_sng023mto       := null;
        ln_totpasdol_sng023mto       := null;
        ln_cuomndcredol_sng023mto    := null;
        ln_excmendol_sng023mto       := null;
        ln_cobcuocreperdol_sng023mto := null;
        ln_moncresoldol_sng023mto    := null;
      
      end if;
    
      ln_numeva_sng021eval := eval.sng021eval;
    
      if (eval.sng026cod = 1) then
        ln_salbrutitsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 2) then
        ln_salbruconsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 3) then
        ln_salbrucomsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 4) then
        ln_salbruotrsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 5) then
        ln_apotitsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 6) then
        ln_apoconsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 7) then
        ln_apocomsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 8) then
        ln_apootrsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 9) then
        ln_otringtitsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 10) then
        ln_otringconsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 11) then
        ln_otringcomsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 12) then
        ln_otringotrsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 13) then
        ln_alimensol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 14) then
        ln_alqvivsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 15) then
        ln_transpsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 16) then
        ln_educacsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 17) then
        ln_serpubsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 18) then
        ln_apofamsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 19) then
        ln_otrgasgensol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 20) then
        ln_imprevsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 21) then
        ln_totingsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 22) then
        ln_totegrsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 23) then
        ln_totactsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 24) then
        ln_totpassol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 25) then
        ln_totpatsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 26) then
        ln_cuomndcresol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 27) then
        ln_excmensol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 28) then
        ln_cobcuocrepersol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 29) then
        ln_moncresolsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 30) then
        ln_enddeusol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 501) then
        ln_salbrutitdol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 502) then
        ln_salbrucondol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 503) then
        ln_salbrucomdol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 504) then
        ln_salbruotrdol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 505) then
        ln_apotitdol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 506) then
        ln_apocondol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 507) then
        ln_apocomdol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 508) then
        ln_apootrdol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 509) then
        ln_otringtitdol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 510) then
        ln_otringcondol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 511) then
        ln_otringcomdol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 512) then
        ln_otringotrdol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 513) then
        ln_alimendol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 514) then
        ln_alqvivdol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 515) then
        ln_transpdol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 516) then
        ln_educacdol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 517) then
        ln_serpubdol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 518) then
        ln_apofamdol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 519) then
        ln_otrgasgendol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 520) then
        ln_imprevdol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 521) then
        ln_totingdol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 522) then
        ln_totegrdol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 524) then
        ln_totpasdol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 526) then
        ln_cuomndcredol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 527) then
        ln_excmendol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 528) then
        ln_cobcuocreperdol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 529) then
        ln_moncresoldol_sng023mto := eval.sng023mto;
      end if;
    
    end loop;
  
    if (ln_numeva_sng021eval is not null And ln_numeva_sng021eval <> -1) then
    
      select sng021fec, sng021sol
        into ld_fecevalua_sng021fec, ln_instan_sng021sol
        from sng021
       where sng021eval = ln_numeva_sng021eval;
    
      select sng120tcbi
        into ln_tipcam_sng120tcbi
        from sng120
       where sng120ins = ln_instan_sng021sol
         and sng120tsk like 'EVALUACION%'
         and sng120mod = 0;
    
      insert into UAI_ACLEVALUADEP
        (n_numeva_sng021eval,
         d_fecevalua_sng021fec,
         n_tipcam_sng120tcbi,
         n_instan_sng021sol,
         n_salbrutitsol_sng023mto,
         n_salbruconsol_sng023mto,
         n_salbrucomsol_sng023mto,
         n_salbruotrsol_sng023mto,
         n_apotitsol_sng023mto,
         n_apoconsol_sng023mto,
         n_apocomsol_sng023mto,
         n_apootrsol_sng023mto,
         n_otringtitsol_sng023mto,
         n_otringconsol_sng023mto,
         n_otringcomsol_sng023mto,
         n_otringotrsol_sng023mto,
         n_alimensol_sng023mto,
         n_alqvivsol_sng023mto,
         n_transpsol_sng023mto,
         n_educacsol_sng023mto,
         n_serpubsol_sng023mto,
         n_apofamsol_sng023mto,
         n_otrgasgensol_sng023mto,
         n_imprevsol_sng023mto,
         n_totingsol_sng023mto,
         n_totegrsol_sng023mto,
         n_totactsol_sng023mto,
         n_totpassol_sng023mto,
         n_totpatsol_sng023mto,
         n_cuomndcresol_sng023mto,
         n_excmensol_sng023mto,
         n_cobcuocrepersol_sng023mto,
         n_moncresolsol_sng023mto,
         n_enddeusol_sng023mto,
         n_salbrutitdol_sng023mto,
         n_salbrucondol_sng023mto,
         n_salbrucomdol_sng023mto,
         n_salbruotrdol_sng023mto,
         n_apotitdol_sng023mto,
         n_apocondol_sng023mto,
         n_apocomdol_sng023mto,
         n_apootrdol_sng023mto,
         n_otringtitdol_sng023mto,
         n_otringcondol_sng023mto,
         n_otringcomdol_sng023mto,
         n_otringotrdol_sng023mto,
         n_alimendol_sng023mto,
         n_alqvivdol_sng023mto,
         n_transpdol_sng023mto,
         n_educacdol_sng023mto,
         n_serpubdol_sng023mto,
         n_apofamdol_sng023mto,
         n_otrgasgendol_sng023mto,
         n_imprevdol_sng023mto,
         n_totingdol_sng023mto,
         n_totegrdol_sng023mto,
         n_totpasdol_sng023mto,
         n_cuomndcredol_sng023mto,
         n_excmendol_sng023mto,
         n_cobcuocreperdol_sng023mto,
         n_moncresoldol_sng023mto)
      values
        (ln_numeva_sng021eval,
         ld_fecevalua_sng021fec,
         ln_tipcam_sng120tcbi,
         ln_instan_sng021sol,
         ln_salbrutitsol_sng023mto,
         ln_salbruconsol_sng023mto,
         ln_salbrucomsol_sng023mto,
         ln_salbruotrsol_sng023mto,
         ln_apotitsol_sng023mto,
         ln_apoconsol_sng023mto,
         ln_apocomsol_sng023mto,
         ln_apootrsol_sng023mto,
         ln_otringtitsol_sng023mto,
         ln_otringconsol_sng023mto,
         ln_otringcomsol_sng023mto,
         ln_otringotrsol_sng023mto,
         ln_alimensol_sng023mto,
         ln_alqvivsol_sng023mto,
         ln_transpsol_sng023mto,
         ln_educacsol_sng023mto,
         ln_serpubsol_sng023mto,
         ln_apofamsol_sng023mto,
         ln_otrgasgensol_sng023mto,
         ln_imprevsol_sng023mto,
         ln_totingsol_sng023mto,
         ln_totegrsol_sng023mto,
         ln_totactsol_sng023mto,
         ln_totpassol_sng023mto,
         ln_totpatsol_sng023mto,
         ln_cuomndcresol_sng023mto,
         ln_excmensol_sng023mto,
         ln_cobcuocrepersol_sng023mto,
         ln_moncresolsol_sng023mto,
         ln_enddeusol_sng023mto,
         ln_salbrutitdol_sng023mto,
         ln_salbrucondol_sng023mto,
         ln_salbrucomdol_sng023mto,
         ln_salbruotrdol_sng023mto,
         ln_apotitdol_sng023mto,
         ln_apocondol_sng023mto,
         ln_apocomdol_sng023mto,
         ln_apootrdol_sng023mto,
         ln_otringtitdol_sng023mto,
         ln_otringcondol_sng023mto,
         ln_otringcomdol_sng023mto,
         ln_otringotrdol_sng023mto,
         ln_alimendol_sng023mto,
         ln_alqvivdol_sng023mto,
         ln_transpdol_sng023mto,
         ln_educacdol_sng023mto,
         ln_serpubdol_sng023mto,
         ln_apofamdol_sng023mto,
         ln_otrgasgendol_sng023mto,
         ln_imprevdol_sng023mto,
         ln_totingdol_sng023mto,
         ln_totegrdol_sng023mto,
         ln_totpasdol_sng023mto,
         ln_cuomndcredol_sng023mto,
         ln_excmendol_sng023mto,
         ln_cobcuocreperdol_sng023mto,
         ln_moncresoldol_sng023mto);
    
    end if;
  
    commit;
  
    --registrar hora de fin de ejecución de job
    update TAB_JOBS
       set D_FECFIN = sysdate
     where C_CODAGE = 'ACL'
       and N_NUMER1 = p_n_numsuc
       and C_DATO2 = 'UAI_ACLEVALUADEP';
    commit;
  
  exception
    when others then
      dbms_output.put_line('error');
  end;

  -------------------------------------------------------------------------------------------------

  procedure sp_uai_evaluacion_ind(p_n_numsuc in number) is
    --
    -- Nombre:                        sp_uai_evaluacion_ind
    -- Area de Negocio:               Auditoría Interna
    -- Frente:                        Normativo
    --  
  
    cursor lcur_evaluaciones is
      select sng021eval, sng026cod, sng023mto
        from sng023
       where sng021eval in
             (select distinct max(s.sng021eval) over(partition by s.sng021pdoc, s.sng021tdoc, s.sng021ndoc, s.sng021sol) sng021eval_max
                from uai_aclpre p
                left join sng021 s
                  on p.n_instancia_xwfprcins = s.sng021sol
               where s.sng021tmod = 13
                 and p.n_suc_bcsuc = p_n_numsuc)
       order by sng021eval, sng026cod;
  
    ln_numeva_sng021eval          UAI_ACLEVALUAIND.n_numeva_sng021eval%type;
    ld_fecevalua_sng021fec        UAI_ACLEVALUAIND.d_fecevalua_sng021fec%type;
    ln_tipcam_sng120tcbi          UAI_ACLEVALUAIND.n_tipcam_sng120tcbi%type;
    ln_Instan_sng021sol           UAI_ACLEVALUAIND.n_instan_Sng021sol%type;
    ln_nivvenultanisol_sng023mto  UAI_ACLEVALUAIND.n_nivvenultanisol_sng023mto%type;
    ln_nivvenpenanisol_sng023mto  UAI_ACLEVALUAIND.n_nivvenpenanisol_sng023mto%type;
    ln_resnetsol_sng023mto        UAI_ACLEVALUAIND.n_resnetsol_sng023mto%type;
    ln_cajbansol_sng023mto        UAI_ACLEVALUAIND.n_cajbansol_sng023mto%type;
    ln_cueporcobcomsol_sng023mto  UAI_ACLEVALUAIND.n_cueporcobcomsol_sng023mto%type;
    ln_mercadsol_sng023mto        UAI_ACLEVALUAIND.n_mercadsol_sng023mto%type;
    ln_gaspagporantsol_sng023mto  UAI_ACLEVALUAIND.n_gaspagporantsol_sng023mto%type;
    ln_exiporrecsol_sng023mto     UAI_ACLEVALUAIND.n_exiporrecsol_sng023mto%type;
    ln_otrsol_sng023mto           UAI_ACLEVALUAIND.n_otrsol_sng023mto%type;
    ln_totactcorsol_sng023mto     UAI_ACLEVALUAIND.n_totactcorsol_sng023mto%type;
    ln_muemaqequsol_sng023mto     UAI_ACLEVALUAIND.n_muemaqequsol_sng023mto%type;
    ln_inmuebsol_sng023mto        UAI_ACLEVALUAIND.n_inmuebsol_sng023mto%type;
    ln_otractsol_sng023mto        UAI_ACLEVALUAIND.n_otractsol_sng023mto%type;
    ln_totactfijsol_sng023mto     UAI_ACLEVALUAIND.n_totactfijsol_sng023mto%type;
    ln_totactsol_sng023mto        UAI_ACLEVALUAIND.n_totactsol_sng023mto%type;
    ln_otringsol_sng023mto        UAI_ACLEVALUAIND.n_otringsol_sng023mto%type;
    ln_gasfamsol_sng023mto        UAI_ACLEVALUAIND.n_gasfamsol_sng023mto%type;
    ln_cueporpagsol_sng023mto     UAI_ACLEVALUAIND.n_cueporpagsol_sng023mto%type;
    ln_triporpagsol_sng023mto     UAI_ACLEVALUAIND.n_triporpagsol_sng023mto%type;
    ln_otrpassol_sng023mto        UAI_ACLEVALUAIND.n_otrpassol_sng023mto%type;
    ln_totpascorsol_sng023mto     UAI_ACLEVALUAIND.n_totpascorsol_sng023mto%type;
    ln_cueporpagbansol_sng023mto  UAI_ACLEVALUAIND.n_cueporpagbansol_sng023mto%type;
    ln_bensoctrasol_sng023mto     UAI_ACLEVALUAIND.n_bensoctrasol_sng023mto%type;
    ln_reservsol_sng023mto        UAI_ACLEVALUAIND.n_reservsol_sng023mto%type;
    ln_otrpaslpsol_sng023mto      UAI_ACLEVALUAIND.n_otrpaslpsol_sng023mto%type;
    ln_totpasnoccorsol_sng023mto  UAI_ACLEVALUAIND.n_totpasnoccorsol_sng023mto%type;
    ln_totpassol_sng023mto        UAI_ACLEVALUAIND.n_totpassol_sng023mto%type;
    ln_capitasol_sng023mto        UAI_ACLEVALUAIND.n_capitasol_sng023mto%type;
    ln_resacusol_sng023mto        UAI_ACLEVALUAIND.n_resacusol_sng023mto%type;
    ln_resdelejesol_sng023mto     UAI_ACLEVALUAIND.n_resdelejesol_sng023mto%type;
    ln_otrpatsol_sng023mto        UAI_ACLEVALUAIND.n_otrpatsol_sng023mto%type;
    ln_totpatsol_sng023mto        UAI_ACLEVALUAIND.n_totpatsol_sng023mto%type;
    ln_totpaspatsol_sng023mto     UAI_ACLEVALUAIND.n_totpaspatsol_sng023mto%type;
    ln_cuaactsol_sng023mto        UAI_ACLEVALUAIND.n_cuaactsol_sng023mto%type;
    ln_ventassol_sng023mto        UAI_ACLEVALUAIND.n_ventassol_sng023mto%type;
    ln_cosvensol_sng023mto        UAI_ACLEVALUAIND.n_cosvensol_sng023mto%type;
    ln_utibrusol_sng023mto        UAI_ACLEVALUAIND.n_utibrusol_sng023mto%type;
    ln_gasvensol_sng023mto        UAI_ACLEVALUAIND.n_gasvensol_sng023mto%type;
    ln_gasadmsol_sng023mto        UAI_ACLEVALUAIND.n_gasadmsol_sng023mto%type;
    ln_utiopesol_sng023mto        UAI_ACLEVALUAIND.n_utiopesol_sng023mto%type;
    ln_gasfinsol_sng023mto        UAI_ACLEVALUAIND.n_gasfinsol_sng023mto%type;
    ln_ingfinsol_sng023mto        UAI_ACLEVALUAIND.n_ingfinsol_sng023mto%type;
    ln_gasdivsol_sng023mto        UAI_ACLEVALUAIND.n_gasdivsol_sng023mto%type;
    ln_utiantimpsol_sng023mto     UAI_ACLEVALUAIND.n_utiantimpsol_sng023mto%type;
    ln_impuessol_sng023mto        UAI_ACLEVALUAIND.n_impuessol_sng023mto%type;
    ln_utinetsol_sng023mto        UAI_ACLEVALUAIND.n_utinetsol_sng023mto%type;
    ln_venultanisol_sng023mto     UAI_ACLEVALUAIND.n_venultanisol_sng023mto%type;
    ln_venpenanisol_sng023mto     UAI_ACLEVALUAIND.n_venpenanisol_sng023mto%type;
    ln_resnetdol_sng023mto        UAI_ACLEVALUAIND.n_resnetdol_sng023mto%type;
    ln_cajbandol_sng023mto        UAI_ACLEVALUAIND.n_cajbandol_sng023mto%type;
    ln_cueporcobcomdol_sng023mto  UAI_ACLEVALUAIND.n_cueporcobcomdol_sng023mto%type;
    ln_mercaddol_sng023mto        UAI_ACLEVALUAIND.n_mercaddol_sng023mto%type;
    ln_gaspagporantdol_sng023mto  UAI_ACLEVALUAIND.n_gaspagporantdol_sng023mto%type;
    ln_exiporrecdol_sng023mto     UAI_ACLEVALUAIND.n_exiporrecdol_sng023mto%type;
    ln_otrdol_sng023mto           UAI_ACLEVALUAIND.n_otrdol_sng023mto%type;
    ln_muemaqequdol_sng023mto     UAI_ACLEVALUAIND.n_muemaqequdol_sng023mto%type;
    ln_inmuebdol_sng023mto        UAI_ACLEVALUAIND.n_inmuebdol_sng023mto%type;
    ln_otractfijdol_sng023mto     UAI_ACLEVALUAIND.n_otractfijdol_sng023mto%type;
    ln_otringdol_sng023mto        UAI_ACLEVALUAIND.n_otringdol_sng023mto%type;
    ln_gasfamdol_sng023mto        UAI_ACLEVALUAIND.n_gasfamdol_sng023mto%type;
    ln_cuenporpagbandol_sng023mto UAI_ACLEVALUAIND.n_cuenporpagbandol_sng023mto%type;
    ln_triporpagdol_sng023mto     UAI_ACLEVALUAIND.n_triporpagdol_sng023mto%type;
    ln_otrpasdol_sng023mto        UAI_ACLEVALUAIND.n_otrpasdol_sng023mto%type;
    ln_cuenporpagbanlp_sng023mto  UAI_ACLEVALUAIND.n_cuenporpagbanlpdol_sng023mto%type;
    ln_bensoctradol_sng023mto     UAI_ACLEVALUAIND.n_bensoctradol_sng023mto%type;
    ln_reservdol_sng023mto        UAI_ACLEVALUAIND.n_reservdol_sng023mto%type;
    ln_otrpaslpdol_sng023mto      UAI_ACLEVALUAIND.n_otrpaslpdol_sng023mto%type;
    ln_totpasnocordol_sng023mto   UAI_ACLEVALUAIND.n_totpasnocordol_sng023mto%type;
    ln_totpasdol_sng023mto        UAI_ACLEVALUAIND.n_totpasdol_sng023mto%type;
    ln_capitadol_sng023mto        UAI_ACLEVALUAIND.n_capitadol_sng023mto%type;
    ln_resacudol_sng023mto        UAI_ACLEVALUAIND.n_resacudol_sng023mto%type;
    ln_resejedol_sng023mto        UAI_ACLEVALUAIND.n_resejedol_sng023mto%type;
    ln_otrpatdol_sng023mto        UAI_ACLEVALUAIND.n_otrpatdol_sng023mto%type;
    ln_totpatdol_sng023mto        UAI_ACLEVALUAIND.n_totpatdol_sng023mto%type;
    ln_totpaspatdol_sng023mto     UAI_ACLEVALUAIND.n_totpaspatdol_sng023mto%type;
    ln_cuaactpaspatdol_sng023mto  UAI_ACLEVALUAIND.n_cuaactpaspatdol_sng023mto%type;
    ln_ventasdol_sng023mto        UAI_ACLEVALUAIND.n_ventasdol_sng023mto%type;
    ln_cosvendol_sng023mto        UAI_ACLEVALUAIND.n_cosvendol_sng023mto%type;
    ln_utibrudol_sng023mto        UAI_ACLEVALUAIND.n_utibrudol_sng023mto%type;
    ln_gasvendol_sng023mto        UAI_ACLEVALUAIND.n_gasvendol_sng023mto%type;
    ln_gasadmdol_sng023mto        UAI_ACLEVALUAIND.n_gasadmdol_sng023mto%type;
    ln_utiopedol_sng023mto        UAI_ACLEVALUAIND.n_utiopedol_sng023mto%type;
    ln_gasfindol_sng023mto        UAI_ACLEVALUAIND.n_gasfindol_sng023mto%type;
    ln_ingfindol_sng023mto        UAI_ACLEVALUAIND.n_ingfindol_sng023mto%type;
    ln_gasdivdol_sng023mto        UAI_ACLEVALUAIND.n_gasdivdol_sng023mto%type;
    ln_utiandimpdol_sng023mto     UAI_ACLEVALUAIND.n_utiandimpdol_sng023mto%type;
    ln_impuesdol_sng023mto        UAI_ACLEVALUAIND.n_impuesdol_sng023mto%type;
    ln_utinetdol_sng023mto        UAI_ACLEVALUAIND.n_utinetdol_sng023mto%type;
    ln_cueporpagcomdol_sng023mto  UAI_ACLEVALUAIND.n_cueporpagcomdol_sng023mto%type;
  
  begin
  
    --registrar hora de inicio de ejecución de job
    update TAB_JOBS
       set D_FECINI = sysdate
     where C_CODAGE = 'ACL'
       and N_NUMER1 = p_n_numsuc
       and C_DATO2 = 'UAI_ACLEVALUAIND';
    commit;
  
    ln_numeva_sng021eval := -1;
  
    for eval in lcur_evaluaciones loop
    
      if (eval.sng021eval <> ln_numeva_sng021eval And
         ln_numeva_sng021eval <> -1) then
      
        select sng021fec, sng021sol
          into ld_fecevalua_sng021fec, ln_instan_sng021sol
          from sng021
         where sng021eval = ln_numeva_sng021eval;
      
        select sng120tcbi
          into ln_tipcam_sng120tcbi
          from sng120
         where sng120ins = ln_instan_sng021sol
           and sng120tsk like 'EVALUACION%'
           and sng120mod = 0;
      
        insert into UAI_ACLEVALUAIND
          (n_numeva_sng021eval,
           d_fecevalua_sng021fec,
           n_tipcam_sng120tcbi,
           n_instan_Sng021sol,
           n_nivvenultanisol_sng023mto,
           n_nivvenpenanisol_sng023mto,
           n_resnetsol_sng023mto,
           n_cajbansol_sng023mto,
           n_cueporcobcomsol_sng023mto,
           n_mercadsol_sng023mto,
           n_gaspagporantsol_sng023mto,
           n_exiporrecsol_sng023mto,
           n_otrsol_sng023mto,
           n_totactcorsol_sng023mto,
           n_muemaqequsol_sng023mto,
           n_inmuebsol_sng023mto,
           n_otractsol_sng023mto,
           n_totactfijsol_sng023mto,
           n_totactsol_sng023mto,
           n_otringsol_sng023mto,
           n_gasfamsol_sng023mto,
           n_cueporpagsol_sng023mto,
           n_triporpagsol_sng023mto,
           n_otrpassol_sng023mto,
           n_totpascorsol_sng023mto,
           n_cueporpagbansol_sng023mto,
           n_bensoctrasol_sng023mto,
           n_reservsol_sng023mto,
           n_otrpaslpsol_sng023mto,
           n_totpasnoccorsol_sng023mto,
           n_totpassol_sng023mto,
           n_capitasol_sng023mto,
           n_resacusol_sng023mto,
           n_resdelejesol_sng023mto,
           n_otrpatsol_sng023mto,
           n_totpatsol_sng023mto,
           n_totpaspatsol_sng023mto,
           n_cuaactsol_sng023mto,
           n_ventassol_sng023mto,
           n_cosvensol_sng023mto,
           n_utibrusol_sng023mto,
           n_gasvensol_sng023mto,
           n_gasadmsol_sng023mto,
           n_utiopesol_sng023mto,
           n_gasfinsol_sng023mto,
           n_ingfinsol_sng023mto,
           n_gasdivsol_sng023mto,
           n_utiantimpsol_sng023mto,
           n_impuessol_sng023mto,
           n_utinetsol_sng023mto,
           n_venultanisol_sng023mto,
           n_venpenanisol_sng023mto,
           n_resnetdol_sng023mto,
           n_cajbandol_sng023mto,
           n_cueporcobcomdol_sng023mto,
           n_mercaddol_sng023mto,
           n_gaspagporantdol_sng023mto,
           n_exiporrecdol_sng023mto,
           n_otrdol_sng023mto,
           n_muemaqequdol_sng023mto,
           n_inmuebdol_sng023mto,
           n_otractfijdol_sng023mto,
           n_otringdol_sng023mto,
           n_gasfamdol_sng023mto,
           n_cuenporpagbandol_sng023mto,
           n_triporpagdol_sng023mto,
           n_otrpasdol_sng023mto,
           n_cuenporpagbanlpdol_sng023mto,
           n_bensoctradol_sng023mto,
           n_reservdol_sng023mto,
           n_otrpaslpdol_sng023mto,
           n_totpasnocordol_sng023mto,
           n_totpasdol_sng023mto,
           n_capitadol_sng023mto,
           n_resacudol_sng023mto,
           n_resejedol_sng023mto,
           n_otrpatdol_sng023mto,
           n_totpatdol_sng023mto,
           n_totpaspatdol_sng023mto,
           n_cuaactpaspatdol_sng023mto,
           n_ventasdol_sng023mto,
           n_cosvendol_sng023mto,
           n_utibrudol_sng023mto,
           n_gasvendol_sng023mto,
           n_gasadmdol_sng023mto,
           n_utiopedol_sng023mto,
           n_gasfindol_sng023mto,
           n_ingfindol_sng023mto,
           n_gasdivdol_sng023mto,
           n_utiandimpdol_sng023mto,
           n_impuesdol_sng023mto,
           n_utinetdol_sng023mto,
           n_cueporpagcomdol_sng023mto)
        values
          (ln_numeva_sng021eval,
           ld_fecevalua_sng021fec,
           ln_tipcam_sng120tcbi,
           ln_Instan_sng021sol,
           ln_nivvenultanisol_sng023mto,
           ln_nivvenpenanisol_sng023mto,
           ln_resnetsol_sng023mto,
           ln_cajbansol_sng023mto,
           ln_cueporcobcomsol_sng023mto,
           ln_mercadsol_sng023mto,
           ln_gaspagporantsol_sng023mto,
           ln_exiporrecsol_sng023mto,
           ln_otrsol_sng023mto,
           ln_totactcorsol_sng023mto,
           ln_muemaqequsol_sng023mto,
           ln_inmuebsol_sng023mto,
           ln_otractsol_sng023mto,
           ln_totactfijsol_sng023mto,
           ln_totactsol_sng023mto,
           ln_otringsol_sng023mto,
           ln_gasfamsol_sng023mto,
           ln_cueporpagsol_sng023mto,
           ln_triporpagsol_sng023mto,
           ln_otrpassol_sng023mto,
           ln_totpascorsol_sng023mto,
           ln_cueporpagbansol_sng023mto,
           ln_bensoctrasol_sng023mto,
           ln_reservsol_sng023mto,
           ln_otrpaslpsol_sng023mto,
           ln_totpasnoccorsol_sng023mto,
           ln_totpassol_sng023mto,
           ln_capitasol_sng023mto,
           ln_resacusol_sng023mto,
           ln_resdelejesol_sng023mto,
           ln_otrpatsol_sng023mto,
           ln_totpatsol_sng023mto,
           ln_totpaspatsol_sng023mto,
           ln_cuaactsol_sng023mto,
           ln_ventassol_sng023mto,
           ln_cosvensol_sng023mto,
           ln_utibrusol_sng023mto,
           ln_gasvensol_sng023mto,
           ln_gasadmsol_sng023mto,
           ln_utiopesol_sng023mto,
           ln_gasfinsol_sng023mto,
           ln_ingfinsol_sng023mto,
           ln_gasdivsol_sng023mto,
           ln_utiantimpsol_sng023mto,
           ln_impuessol_sng023mto,
           ln_utinetsol_sng023mto,
           ln_venultanisol_sng023mto,
           ln_venpenanisol_sng023mto,
           ln_resnetdol_sng023mto,
           ln_cajbandol_sng023mto,
           ln_cueporcobcomdol_sng023mto,
           ln_mercaddol_sng023mto,
           ln_gaspagporantdol_sng023mto,
           ln_exiporrecdol_sng023mto,
           ln_otrdol_sng023mto,
           ln_muemaqequdol_sng023mto,
           ln_inmuebdol_sng023mto,
           ln_otractfijdol_sng023mto,
           ln_otringdol_sng023mto,
           ln_gasfamdol_sng023mto,
           ln_cuenporpagbandol_sng023mto,
           ln_triporpagdol_sng023mto,
           ln_otrpasdol_sng023mto,
           ln_cuenporpagbanlp_sng023mto,
           ln_bensoctradol_sng023mto,
           ln_reservdol_sng023mto,
           ln_otrpaslpdol_sng023mto,
           ln_totpasnocordol_sng023mto,
           ln_totpasdol_sng023mto,
           ln_capitadol_sng023mto,
           ln_resacudol_sng023mto,
           ln_resejedol_sng023mto,
           ln_otrpatdol_sng023mto,
           ln_totpatdol_sng023mto,
           ln_totpaspatdol_sng023mto,
           ln_cuaactpaspatdol_sng023mto,
           ln_ventasdol_sng023mto,
           ln_cosvendol_sng023mto,
           ln_utibrudol_sng023mto,
           ln_gasvendol_sng023mto,
           ln_gasadmdol_sng023mto,
           ln_utiopedol_sng023mto,
           ln_gasfindol_sng023mto,
           ln_ingfindol_sng023mto,
           ln_gasdivdol_sng023mto,
           ln_utiandimpdol_sng023mto,
           ln_impuesdol_sng023mto,
           ln_utinetdol_sng023mto,
           ln_cueporpagcomdol_sng023mto);
      
        ln_nivvenultanisol_sng023mto  := null;
        ln_nivvenpenanisol_sng023mto  := null;
        ln_resnetsol_sng023mto        := null;
        ln_cajbansol_sng023mto        := null;
        ln_cueporcobcomsol_sng023mto  := null;
        ln_mercadsol_sng023mto        := null;
        ln_gaspagporantsol_sng023mto  := null;
        ln_exiporrecsol_sng023mto     := null;
        ln_otrsol_sng023mto           := null;
        ln_totactcorsol_sng023mto     := null;
        ln_muemaqequsol_sng023mto     := null;
        ln_inmuebsol_sng023mto        := null;
        ln_otractsol_sng023mto        := null;
        ln_totactfijsol_sng023mto     := null;
        ln_totactsol_sng023mto        := null;
        ln_otringsol_sng023mto        := null;
        ln_gasfamsol_sng023mto        := null;
        ln_cueporpagsol_sng023mto     := null;
        ln_triporpagsol_sng023mto     := null;
        ln_otrpassol_sng023mto        := null;
        ln_totpascorsol_sng023mto     := null;
        ln_cueporpagbansol_sng023mto  := null;
        ln_bensoctrasol_sng023mto     := null;
        ln_reservsol_sng023mto        := null;
        ln_otrpaslpsol_sng023mto      := null;
        ln_totpasnoccorsol_sng023mto  := null;
        ln_totpassol_sng023mto        := null;
        ln_capitasol_sng023mto        := null;
        ln_resacusol_sng023mto        := null;
        ln_resdelejesol_sng023mto     := null;
        ln_otrpatsol_sng023mto        := null;
        ln_totpatsol_sng023mto        := null;
        ln_totpaspatsol_sng023mto     := null;
        ln_cuaactsol_sng023mto        := null;
        ln_ventassol_sng023mto        := null;
        ln_cosvensol_sng023mto        := null;
        ln_utibrusol_sng023mto        := null;
        ln_gasvensol_sng023mto        := null;
        ln_gasadmsol_sng023mto        := null;
        ln_utiopesol_sng023mto        := null;
        ln_gasfinsol_sng023mto        := null;
        ln_ingfinsol_sng023mto        := null;
        ln_gasdivsol_sng023mto        := null;
        ln_utiantimpsol_sng023mto     := null;
        ln_impuessol_sng023mto        := null;
        ln_utinetsol_sng023mto        := null;
        ln_venultanisol_sng023mto     := null;
        ln_venpenanisol_sng023mto     := null;
        ln_resnetdol_sng023mto        := null;
        ln_cajbandol_sng023mto        := null;
        ln_cueporcobcomdol_sng023mto  := null;
        ln_mercaddol_sng023mto        := null;
        ln_gaspagporantdol_sng023mto  := null;
        ln_exiporrecdol_sng023mto     := null;
        ln_otrdol_sng023mto           := null;
        ln_muemaqequdol_sng023mto     := null;
        ln_inmuebdol_sng023mto        := null;
        ln_otractfijdol_sng023mto     := null;
        ln_otringdol_sng023mto        := null;
        ln_gasfamdol_sng023mto        := null;
        ln_cuenporpagbandol_sng023mto := null;
        ln_triporpagdol_sng023mto     := null;
        ln_otrpasdol_sng023mto        := null;
        ln_cuenporpagbanlp_sng023mto  := null;
        ln_bensoctradol_sng023mto     := null;
        ln_reservdol_sng023mto        := null;
        ln_otrpaslpdol_sng023mto      := null;
        ln_totpasnocordol_sng023mto   := null;
        ln_totpasdol_sng023mto        := null;
        ln_capitadol_sng023mto        := null;
        ln_resacudol_sng023mto        := null;
        ln_resejedol_sng023mto        := null;
        ln_otrpatdol_sng023mto        := null;
        ln_totpatdol_sng023mto        := null;
        ln_totpaspatdol_sng023mto     := null;
        ln_cuaactpaspatdol_sng023mto  := null;
        ln_ventasdol_sng023mto        := null;
        ln_cosvendol_sng023mto        := null;
        ln_utibrudol_sng023mto        := null;
        ln_gasvendol_sng023mto        := null;
        ln_gasadmdol_sng023mto        := null;
        ln_utiopedol_sng023mto        := null;
        ln_gasfindol_sng023mto        := null;
        ln_ingfindol_sng023mto        := null;
        ln_gasdivdol_sng023mto        := null;
        ln_utiandimpdol_sng023mto     := null;
        ln_impuesdol_sng023mto        := null;
        ln_utinetdol_sng023mto        := null;
        ln_cueporpagcomdol_sng023mto  := null;
      
      end if;
    
      ln_numeva_sng021eval := eval.sng021eval;
    
      if (eval.sng026cod = 38) then
        ln_nivvenultanisol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 39) then
        ln_nivvenpenanisol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 40) then
        ln_resnetsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 41) then
        ln_cajbansol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 42) then
        ln_cueporcobcomsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 43) then
        ln_mercadsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 44) then
        ln_gaspagporantsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 45) then
        ln_exiporrecsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 46) then
        ln_otrsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 47) then
        ln_totactcorsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 48) then
        ln_muemaqequsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 49) then
        ln_inmuebsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 50) then
        ln_otractsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 51) then
        ln_totactfijsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 52) then
        ln_totactsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 53) then
        ln_otringsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 54) then
        ln_gasfamsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 56) then
        ln_cueporpagsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 57) then
        ln_triporpagsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 58) then
        ln_otrpassol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 59) then
        ln_totpascorsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 60) then
        ln_cueporpagbansol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 61) then
        ln_bensoctrasol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 62) then
        ln_reservsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 63) then
        ln_otrpaslpsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 64) then
        ln_totpasnoccorsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 65) then
        ln_totpassol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 66) then
        ln_capitasol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 67) then
        ln_resacusol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 68) then
        ln_resdelejesol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 69) then
        ln_otrpatsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 70) then
        ln_totpatsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 71) then
        ln_totpaspatsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 72) then
        ln_cuaactsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 73) then
        ln_ventassol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 74) then
        ln_cosvensol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 75) then
        ln_utibrusol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 76) then
        ln_gasvensol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 77) then
        ln_gasadmsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 78) then
        ln_utiopesol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 79) then
        ln_gasfinsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 80) then
        ln_ingfinsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 81) then
        ln_gasdivsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 82) then
        ln_utiantimpsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 83) then
        ln_impuessol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 84) then
        ln_utinetsol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 85) then
        ln_venultanisol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 86) then
        ln_venpenanisol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 540) then
        ln_resnetdol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 541) then
        ln_cajbandol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 542) then
        ln_cueporcobcomdol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 543) then
        ln_mercaddol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 544) then
        ln_gaspagporantdol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 545) then
        ln_exiporrecdol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 546) then
        ln_otrdol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 548) then
        ln_muemaqequdol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 549) then
        ln_inmuebdol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 550) then
        ln_otractfijdol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 553) then
        ln_otringdol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 554) then
        ln_gasfamdol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 556) then
        ln_cuenporpagbandol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 557) then
        ln_triporpagdol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 558) then
        ln_otrpasdol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 560) then
        ln_cuenporpagbanlp_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 561) then
        ln_bensoctradol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 562) then
        ln_reservdol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 563) then
        ln_otrpaslpdol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 564) then
        ln_totpasnocordol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 565) then
        ln_totpasdol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 566) then
        ln_capitadol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 567) then
        ln_resacudol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 568) then
        ln_resejedol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 569) then
        ln_otrpatdol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 570) then
        ln_totpatdol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 571) then
        ln_totpaspatdol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 572) then
        ln_cuaactpaspatdol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 573) then
        ln_ventasdol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 574) then
        ln_cosvendol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 575) then
        ln_utibrudol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 576) then
        ln_gasvendol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 577) then
        ln_gasadmdol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 578) then
        ln_utiopedol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 579) then
        ln_gasfindol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 580) then
        ln_ingfindol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 581) then
        ln_gasdivdol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 582) then
        ln_utiandimpdol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 583) then
        ln_impuesdol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 584) then
        ln_utinetdol_sng023mto := eval.sng023mto;
      end if;
      if (eval.sng026cod = 589) then
        ln_cueporpagcomdol_sng023mto := eval.sng023mto;
      end if;
    
    end loop;
  
    if (ln_numeva_sng021eval is not null And ln_numeva_sng021eval <> -1) then
    
      select sng021fec, sng021sol
        into ld_fecevalua_sng021fec, ln_instan_sng021sol
        from sng021
       where sng021eval = ln_numeva_sng021eval;
    
      select sng120tcbi
        into ln_tipcam_sng120tcbi
        from sng120
       where sng120ins = ln_instan_sng021sol
         and sng120tsk like 'EVALUACION%'
         and sng120mod = 0;
    
      insert into UAI_ACLEVALUAIND
        (n_numeva_sng021eval,
         d_fecevalua_sng021fec,
         n_tipcam_sng120tcbi,
         n_instan_Sng021sol,
         n_nivvenultanisol_sng023mto,
         n_nivvenpenanisol_sng023mto,
         n_resnetsol_sng023mto,
         n_cajbansol_sng023mto,
         n_cueporcobcomsol_sng023mto,
         n_mercadsol_sng023mto,
         n_gaspagporantsol_sng023mto,
         n_exiporrecsol_sng023mto,
         n_otrsol_sng023mto,
         n_totactcorsol_sng023mto,
         n_muemaqequsol_sng023mto,
         n_inmuebsol_sng023mto,
         n_otractsol_sng023mto,
         n_totactfijsol_sng023mto,
         n_totactsol_sng023mto,
         n_otringsol_sng023mto,
         n_gasfamsol_sng023mto,
         n_cueporpagsol_sng023mto,
         n_triporpagsol_sng023mto,
         n_otrpassol_sng023mto,
         n_totpascorsol_sng023mto,
         n_cueporpagbansol_sng023mto,
         n_bensoctrasol_sng023mto,
         n_reservsol_sng023mto,
         n_otrpaslpsol_sng023mto,
         n_totpasnoccorsol_sng023mto,
         n_totpassol_sng023mto,
         n_capitasol_sng023mto,
         n_resacusol_sng023mto,
         n_resdelejesol_sng023mto,
         n_otrpatsol_sng023mto,
         n_totpatsol_sng023mto,
         n_totpaspatsol_sng023mto,
         n_cuaactsol_sng023mto,
         n_ventassol_sng023mto,
         n_cosvensol_sng023mto,
         n_utibrusol_sng023mto,
         n_gasvensol_sng023mto,
         n_gasadmsol_sng023mto,
         n_utiopesol_sng023mto,
         n_gasfinsol_sng023mto,
         n_ingfinsol_sng023mto,
         n_gasdivsol_sng023mto,
         n_utiantimpsol_sng023mto,
         n_impuessol_sng023mto,
         n_utinetsol_sng023mto,
         n_venultanisol_sng023mto,
         n_venpenanisol_sng023mto,
         n_resnetdol_sng023mto,
         n_cajbandol_sng023mto,
         n_cueporcobcomdol_sng023mto,
         n_mercaddol_sng023mto,
         n_gaspagporantdol_sng023mto,
         n_exiporrecdol_sng023mto,
         n_otrdol_sng023mto,
         n_muemaqequdol_sng023mto,
         n_inmuebdol_sng023mto,
         n_otractfijdol_sng023mto,
         n_otringdol_sng023mto,
         n_gasfamdol_sng023mto,
         n_cuenporpagbandol_sng023mto,
         n_triporpagdol_sng023mto,
         n_otrpasdol_sng023mto,
         n_cuenporpagbanlpdol_sng023mto,
         n_bensoctradol_sng023mto,
         n_reservdol_sng023mto,
         n_otrpaslpdol_sng023mto,
         n_totpasnocordol_sng023mto,
         n_totpasdol_sng023mto,
         n_capitadol_sng023mto,
         n_resacudol_sng023mto,
         n_resejedol_sng023mto,
         n_otrpatdol_sng023mto,
         n_totpatdol_sng023mto,
         n_totpaspatdol_sng023mto,
         n_cuaactpaspatdol_sng023mto,
         n_ventasdol_sng023mto,
         n_cosvendol_sng023mto,
         n_utibrudol_sng023mto,
         n_gasvendol_sng023mto,
         n_gasadmdol_sng023mto,
         n_utiopedol_sng023mto,
         n_gasfindol_sng023mto,
         n_ingfindol_sng023mto,
         n_gasdivdol_sng023mto,
         n_utiandimpdol_sng023mto,
         n_impuesdol_sng023mto,
         n_utinetdol_sng023mto,
         n_cueporpagcomdol_sng023mto)
      values
        (ln_numeva_sng021eval,
         ld_fecevalua_sng021fec,
         ln_tipcam_sng120tcbi,
         ln_Instan_sng021sol,
         ln_nivvenultanisol_sng023mto,
         ln_nivvenpenanisol_sng023mto,
         ln_resnetsol_sng023mto,
         ln_cajbansol_sng023mto,
         ln_cueporcobcomsol_sng023mto,
         ln_mercadsol_sng023mto,
         ln_gaspagporantsol_sng023mto,
         ln_exiporrecsol_sng023mto,
         ln_otrsol_sng023mto,
         ln_totactcorsol_sng023mto,
         ln_muemaqequsol_sng023mto,
         ln_inmuebsol_sng023mto,
         ln_otractsol_sng023mto,
         ln_totactfijsol_sng023mto,
         ln_totactsol_sng023mto,
         ln_otringsol_sng023mto,
         ln_gasfamsol_sng023mto,
         ln_cueporpagsol_sng023mto,
         ln_triporpagsol_sng023mto,
         ln_otrpassol_sng023mto,
         ln_totpascorsol_sng023mto,
         ln_cueporpagbansol_sng023mto,
         ln_bensoctrasol_sng023mto,
         ln_reservsol_sng023mto,
         ln_otrpaslpsol_sng023mto,
         ln_totpasnoccorsol_sng023mto,
         ln_totpassol_sng023mto,
         ln_capitasol_sng023mto,
         ln_resacusol_sng023mto,
         ln_resdelejesol_sng023mto,
         ln_otrpatsol_sng023mto,
         ln_totpatsol_sng023mto,
         ln_totpaspatsol_sng023mto,
         ln_cuaactsol_sng023mto,
         ln_ventassol_sng023mto,
         ln_cosvensol_sng023mto,
         ln_utibrusol_sng023mto,
         ln_gasvensol_sng023mto,
         ln_gasadmsol_sng023mto,
         ln_utiopesol_sng023mto,
         ln_gasfinsol_sng023mto,
         ln_ingfinsol_sng023mto,
         ln_gasdivsol_sng023mto,
         ln_utiantimpsol_sng023mto,
         ln_impuessol_sng023mto,
         ln_utinetsol_sng023mto,
         ln_venultanisol_sng023mto,
         ln_venpenanisol_sng023mto,
         ln_resnetdol_sng023mto,
         ln_cajbandol_sng023mto,
         ln_cueporcobcomdol_sng023mto,
         ln_mercaddol_sng023mto,
         ln_gaspagporantdol_sng023mto,
         ln_exiporrecdol_sng023mto,
         ln_otrdol_sng023mto,
         ln_muemaqequdol_sng023mto,
         ln_inmuebdol_sng023mto,
         ln_otractfijdol_sng023mto,
         ln_otringdol_sng023mto,
         ln_gasfamdol_sng023mto,
         ln_cuenporpagbandol_sng023mto,
         ln_triporpagdol_sng023mto,
         ln_otrpasdol_sng023mto,
         ln_cuenporpagbanlp_sng023mto,
         ln_bensoctradol_sng023mto,
         ln_reservdol_sng023mto,
         ln_otrpaslpdol_sng023mto,
         ln_totpasnocordol_sng023mto,
         ln_totpasdol_sng023mto,
         ln_capitadol_sng023mto,
         ln_resacudol_sng023mto,
         ln_resejedol_sng023mto,
         ln_otrpatdol_sng023mto,
         ln_totpatdol_sng023mto,
         ln_totpaspatdol_sng023mto,
         ln_cuaactpaspatdol_sng023mto,
         ln_ventasdol_sng023mto,
         ln_cosvendol_sng023mto,
         ln_utibrudol_sng023mto,
         ln_gasvendol_sng023mto,
         ln_gasadmdol_sng023mto,
         ln_utiopedol_sng023mto,
         ln_gasfindol_sng023mto,
         ln_ingfindol_sng023mto,
         ln_gasdivdol_sng023mto,
         ln_utiandimpdol_sng023mto,
         ln_impuesdol_sng023mto,
         ln_utinetdol_sng023mto,
         ln_cueporpagcomdol_sng023mto);
    
    end if;
  
    commit;
  
    --registrar hora de fin de ejecución de job
    update TAB_JOBS
       set D_FECFIN = sysdate
     where C_CODAGE = 'ACL'
       and N_NUMER1 = p_n_numsuc
       and C_DATO2 = 'UAI_ACLEVALUAIND';
    commit;
  
  exception
    when others then
      dbms_output.put_line('error');
  end;

  -------------------------------------------------------------------------------------------------

  procedure sp_uai_recuperacion_legal is
    --
    -- Nombre:                        sp_uai_recuperacion_legal
    -- Area de Negocio:               Auditoría Interna
    -- Frente:                        Normativo
    --  
  begin
  
    execute immediate 'truncate table UAI_ACLRECLEG';
    commit;
  
    insert into uai_aclrecleg
      (C_NUMEXPJUD_JAQM27CHR1,
       N_EMP_JAQM27PGC,
       N_MOD_JAQM27MOD,
       N_SUC_JAQM27SUC,
       N_MDA_JAQM27MDA,
       N_PAP_JAQM27PAP,
       N_CTA_JAQM27CTA,
       N_OPE_JAQM27OPER,
       N_SBO_JAQM27SBOP,
       N_TOP_JAQM27TOPE,
       N_COR_JAQM33COR,
       D_FECDEMACE_JAQM33FDEM,
       D_FECDEMINT_JAQM33FINT,
       C_NOMABO_JAQM34NOM,
       N_CODABO_JAQM34COD,
       D_FECASIABO_JAQM35TFEC,
       N_TIPPRE_SNG400EVTO,
       D_FECENV_SNG410FECG)
      select r.JAQM27CHR1,
             r.JAQM27PGC,
             r.JAQM27MOD,
             r.JAQM27SUC,
             r.JAQM27MDA,
             r.JAQM27PAP,
             r.JAQM27CTA,
             r.JAQM27OPER,
             r.JAQM27SBOP,
             r.JAQM27TOPE,
             r.JAQM33COR,
             d.JAQM33FDEM,
             d.JAQM33FINT,
             a.JAQM34NOM,
             ra.JAQM34COD,
             ra.JAQM35TFEC,
             e.SNG400EVTO,
             e.SNG410FECG
        from uai_aclpre p
       right outer join jaqm27 r
          on p.n_emp_bcemp = r.jaqm27pgc
         and p.n_mod_bcmod = r.jaqm27mod
         and p.n_suc_bcsuc = r.jaqm27suc
         and p.n_mda_bcmda = r.jaqm27mda
         and p.n_pap_bcpap = r.jaqm27pap
         and p.n_cta_bccta = r.jaqm27cta
         and p.n_oper_bcoper = r.jaqm27oper
         and p.n_sbop_bcsbop = r.jaqm27sbop
         and p.n_tope_bctop = r.jaqm27tope
        left join jaqm33 d
          on d.jaqm33cor = r.jaqm33cor
        left join jaqm35 ra
          on ra.jaqm35pgco = p.n_emp_bcemp
         and ra.jaqm35suc = p.n_suc_bcsuc
         and ra.jaqm35mda = p.n_mda_bcmda
         and ra.jaqm35pap = p.n_pap_bcpap
         and ra.jaqm35cta = p.n_cta_bccta
         and ra.jaqm35oper = p.n_oper_bcoper
        left join jaqm34 a
          on a.jaqm34cod = ra.jaqm34cod
        left join sng410 e
          on e.sng410suc = p.n_suc_bcsuc
         and e.sng410mda = p.n_mda_bcmda
         and e.sng410pap = p.n_pap_bcpap
         and e.sng410cta = p.n_cta_bccta
         and e.sng410op = p.n_oper_bcoper
         and e.sng400evto in (1100, 1101)
         and e.sng410its <> 999;
  
    commit;
  
  end;

end PQ_UAI_DATOS_ACL;
/

