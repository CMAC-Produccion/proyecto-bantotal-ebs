create or replace package pq_cr_reporte_fond19 is

  -- *****************************************************************
  -- Nombre                       : pq_cr_reporte_fondos
  -- Sistema                      : BANTOTAL
  -- Módulo                       : Créditos
  -- Versión                      : 1.0
  -- Fecha de Creación            : 10/12/2020
  -- Autor de Creación            : jrodriguej
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Descripción                  : Paquete para generar los reportes de fondos
  -- Fecha de Modificación        : 09/03/2021
  -- Autor de Modificación        : jrodriguej
  -- Descripción de Modificación  : Reemplazo de USRREPBI.REP_TOT_REPRO_2020 por AQPB090
  -- Fecha de Modificación        : 17/01/2024
  -- Autor de Modificación        : rmontesr
  -- Descripción de Modificación  : Modificacion de nro jobs ejecutados
  -- *****************************************************************

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  --AQPB065
  procedure sp_reporte_covid19_r1(pn_ffin    in date,
                                  pc_sucurs  in number,
                                  pn_usuario in char,
                                  pn_tip_rep in number --- 1: Semanal, 2: Diario
                                  );
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  -- Verificar cronograma
  procedure sp_guardar_historico(pn_usuario char,
                                 pn_ind     number,
                                 pn_fcorte  date);

  -- Registro de información en plantilla
  procedure sp_insertar_cabecera(pn_pgcod   in number,
                                 pn_usuario in varchar2,
                                 pn_fecha   in date,
                                 pn_tiporep in number,
                                 pn_corr    out number,
                                 pn_flag    out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  -- Actualización de información en plantilla
  procedure sp_actualizar_cabecera(pn_pgcod   in number,
                                   pn_fecha   in date,
                                   pn_corr    in number,
                                   pn_usuario in varchar2,
                                   pn_tiporep in number,
                                   pn_estado  in varchar2,
                                   pn_flag    out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  Function fn_cr_verifica_tarea(P_C_NOMJOB IN VARCHAR2,
                                P_C_HOSTNA IN VARCHAR2) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  Function fn_cr_verifica_tarea2(P_C_NOMJOB IN VARCHAR2,
                                 P_C_HOSTNA IN VARCHAR2,
                                 pn_paquete in varchar2,
                                 pn_proceso in varchar2,
                                 pn_usuario in varchar2) return number;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
  procedure sp_cr_sch_fcovid19(pd_fecpro  in date,
                               pn_usuario in varchar2,
                               pn_tip_rep in number, --- 1: Semanal, 2: Diario
                               pn_flag    out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --     
  procedure sp_plantilla_fcovid(pn_cod   in number,
                                pn_mod   in number,
                                pn_suc   in number,
                                pn_mda   in number,
                                pn_pap   in number,
                                pn_cta   in number,
                                pn_ope   in number,
                                pn_sbo   in number,
                                pn_top   in number,
                                pn_fecha in date,
                                pn_ncer  out aqpb095b.aqpb095bncer%type,
                                pn_fdes  out aqpb095b.aqpb095bfdes%type,
                                pn_mon   out aqpb095b.aqpb095bmon%type,
                                
                                pn_teac  out aqpb095b.aqpb095btea%type,
                                pn_pgrac out aqpb095b.aqpb095bpgra%type,
                                pn_finic out aqpb095b.aqpb095bfini%type,
                                pn_ffinc out aqpb095b.aqpb095bffin%type);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --     
  procedure sp_plantilla_fcovid2(pn_cod   in number,
                                 pn_mod   in number,
                                 pn_suc   in number,
                                 pn_mda   in number,
                                 pn_pap   in number,
                                 pn_cta   in number,
                                 pn_ope   in number,
                                 pn_sbo   in number,
                                 pn_top   in number,
                                 pn_fecha in date,
                                 pn_ncer  out aqpb095b.aqpb095bncer%type,
                                 pn_fdes  out aqpb095b.aqpb095bfdes%type,
                                 pn_mon   out aqpb095b.aqpb095bmon%type,
                                 
                                 pn_teac  out aqpb095b.aqpb095btea%type,
                                 pn_pgrac out aqpb095b.aqpb095bpgra%type,
                                 pn_finic out aqpb095b.aqpb095bfini%type,
                                 pn_ffinc out aqpb095b.aqpb095bffin%type,
                                 pn_prcof out aqpb095b.aqpb095bprcof%type,
                                 pn_ccob  out aqpb095b.aqpb095bccob%type,
                                 pn_cren  out aqpb095b.aqpb095bcren%type,
                                 pn_cobr  out aqpb095b.aqpb095bcobr%type,
                                 pn_chon  out aqpb095b.aqpb095bchon%type);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
  procedure sp_obtener_calf_caja(pn_cod   in number,
                                 pn_mod   in number,
                                 pn_suc   in number,
                                 pn_mda   in number,
                                 pn_pap   in number,
                                 pn_cta   in number,
                                 pn_ope   in number,
                                 pn_sbo   in number,
                                 pn_top   in number,
                                 pn_est   in number,
                                 pn_fecha in date,
                                 --pn_dcla out aqpb067.aqpb067dcla%type,
                                 --pn_ncla out aqpb067.aqpb067ncla%type
                                 pn_calif0a out aqpb067.aqpb067cnoma%type,
                                 pn_calif1a out aqpb067.aqpb067ccppa%type,
                                 pn_calif2a out aqpb067.aqpb067cdefa%type,
                                 pn_calif3a out aqpb067.aqpb067cduda%type,
                                 pn_calif4a out aqpb067.aqpb067cpera%type,
                                 pn_deccaj  out date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                   
  procedure sp_sch_aqpb070a_carga(pd_fecpro  in date,
                                  pn_usuario in char,
                                  pn_indi    in number);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_carga_temp_fcovid(pc_usuario in varchar2,
                                    pc_sucurs  in varchar2,
                                    pc_fecpro  in date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                               
  -- Anulación Individual
  procedure sp_anulacion_individual(pn_pgcod   in number,
                                    pn_fecha   in date,
                                    pn_corr    in number,
                                    pn_usuario in varchar2,
                                    pn_tiporep in number,
                                    pn_estado  in varchar2,
                                    pn_flag    out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                                
  procedure sp_cr_file_covid19_txt(pd_fecpro  in date,
                                   pd_tip_rep in number,
                                   pd_usuario in varchar2,
                                   pd_rpta    out varchar2,
                                   lc_nombre  out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  procedure sp_verificar_genrep(pn_tipo in number,
                                pn_user in varchar2,
                                pn_flag out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_obtener_drefinanciac(pn_cod    in number,
                                    pn_mod    in number,
                                    pn_suc    in number,
                                    pn_mda    in number,
                                    pn_pap    in number,
                                    pn_cta    in number,
                                    pn_ope    in number,
                                    pn_sbo    in number,
                                    pn_top    in number,
                                    pd_fecha  in date,
                                    pc_lrefin out char,
                                    pd_frefin out date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --          
  procedure sp_obtener_sald_insol2_h99(pn_cod   in number,
                                   pn_mod   in number,
                                   pn_suc   in number,
                                   pn_mda   in number,
                                   pn_pap   in number,
                                   pn_cta   in number,
                                   pn_ope   in number,
                                   pn_sbo   in number,
                                   pn_top   in number,
                                   pn_fecha in date,
                                   pn_indi  in number,
                                   pn_stat  in number,
                                   pn_sald  out number); 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --     

end pq_cr_reporte_fond19;
/

create or replace package body pq_cr_reporte_fond19 is

  -- *****************************************************************
  -- Nombre                       : pq_cr_reporte_fond19
  -- Sistema                      : BANTOTAL
  -- Módulo                       : Créditos
  -- Versión                      : 1.0
  -- Fecha de Creación            : 10/12/2020
  -- Autor de Creación            : jrodriguej
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Descripción                  : Paquete para generar los reportes de fondos
  -- Fecha de Modificación        : 09/03/2021
  -- Autor de Modificación        : jrodriguej
  -- Descripción de Modificación  : Reemplazo de USRREPBI.REP_TOT_REPRO_2020 por AQPB090
  -- *****************************************************************

  --TABLA AQPB065
  procedure sp_reporte_covid19_r1(pn_ffin    in date,
                                  pc_sucurs  in number,
                                  pn_usuario in char,
                                  pn_tip_rep in number --- 1: Semanal, 2: Diario
                                  ) is
  
    lc_razon     char(100);
    lc_ncre      char(50);
    lc_pcre      number;
    lc_pcren     char(3);
    lc_pcre_c    char(3);
    lc_fecha_rcc date;
    lc_csbs      char(11);
    lc_fecha     DATE;
    lc_coderr    char(100);
    lc_msgerr    char(1000);
  
    --lc_ciiu number;
    lc_acti char(60);
    lc_inst number(10);
    lc_mda  char(10);
    lc_sdoi number(17, 2);
    lc_pgra number(5);
  
    lx_esf char(11);
  
    lc_calif0 number(5, 2);
    lc_calif1 number(5, 2);
    lc_calif2 number(5, 2);
    lc_calif3 number(5, 2);
    lc_calif4 number(5, 2);
  
    lc_statd char(30);
    lc_lamr  char(2);
    lc_fupag date;
    lc_diat  number;
    lc_regi  number(9);
    lc_zona  number(9);
    lc_ases  char(10);
    lc_nsuc  char(30);
    lc_nzon  char(40);
    lc_nreg  char(30);
  
    lb_ncer  aqpb095b.aqpb095bncer%type;
    lb_fdes  aqpb095b.aqpb095bfdes%type;
    lb_mon   aqpb095b.aqpb095bmon%type;
    lb_teac  aqpb095b.aqpb095btea%type;
    lb_pgrac aqpb095b.aqpb095bpgra%type;
    lb_finic aqpb095b.aqpb095bfini%type;
    lb_ffinc aqpb095b.aqpb095bffin%type;
    lb_prcof aqpb095b.aqpb095bprcof%type;
  
    lc_calif0a   aqpb067.aqpb067cnoma%type;
    lc_calif1a   aqpb067.aqpb067ccppa%type;
    lc_calif2a   aqpb067.aqpb067cdefa%type;
    lc_calif3a   aqpb067.aqpb067cduda%type;
    lc_calif4a   aqpb067.aqpb067cpera%type;
    lc_fecha_caj date;
  
    lc_mtoc  number(17, 2);
    lc_scapc number(17, 2);
  
    lc_lrep  aqpb067.aqpb067lrep%type;
    lc_nrep  aqpb067.aqpb067nrep%type;
    lc_frep  aqpb067.aqpb067frep%type;
    lc_tabla varchar2(50);
    lc_peri2 number;
    lc_ncuo2 number;
    lc_fpri  date;
    lc_fult  date;
  
    lc_ufpag1 date;
    --lc_fupag date;
    lc_fvenup date;
    lc_fvenuc date;
    lc_ncuop  number;
    lc_ncuopg number;
  
    lc_gas  number(16, 2);
    lc_mor  number(16, 2);
    lc_int  number(16, 2);
    lc_cuo  number(16, 2);
    lc_icv  number(16, 2);
    lc_pen  number(16, 2);
    lc_tsum number(16, 2);
  
    lc_feccan date;
    --lc_ciiu4   char(5);
    lc_nro_pre char(20);
    lc_mda_pre char(2);
  
    lx_pepais NUMBER(3);
    lx_petdoc NUMBER(2);
    lx_pendoc CHAR(12);
  
    lc_ciiu6   number(9);
    lc_ciiu4   number(12);
    lc_nro_cuo number(9);
    lc_tea     number(10, 6);
  
    ln_cta number(9);
    ln_ope number(9);
  
    lb_flag_vig  char(1);
    lb_fmax_anu  date;
    lb_flag_back number(3);
    lc_sdoins    number(17, 2);
    lc_nro_mes   number(3);
    lc_flag_dia  number(3);
    lc_dia_bor   number(3);
    lc_sdo_ins   number(17, 2);
  
    lx_fini_cre date;
    lx_ffin_cre date;
    lx_ncuopa   number(5);
    lx_ncuopp   number(5);
    lx_moneda   char(3);
    lx_tip      char(3);
    lx_por_err  number(10, 6);
    lx_tas_ini  number(10, 6);
    lx_sdo_cap  number(17, 2);
  
    lc_tprest  char(30);
    lc_frepro  char(1);
    lc_sqlcode char(100);
    lc_sqlerrm char(100);
  
    lc_eshonr char(1);
    ln_mhonr  number(17, 2);
    ld_fhonr  date;
    ln_sdohon number(17, 2);
  
    --2021.10.01 dcastro
    lc_gas1  number(16, 2);
    lc_mor1  number(16, 2);
    lc_int1  number(16, 2);
    lc_cuo1  number(16, 2);
    lc_icv1  number(16, 2);
    lc_pen1  number(16, 2);
    lc_tsum1 number(16, 2);
    ld_feci1 date;
    lc_mpre  aqpb067.aqpb067mpre%type;
  
    lc_dcon char(4); -- 11. Situación contable
    lc_scon char(20);
  
    ld_cest   date;
    ld_frefin date;
    lc_lrefin char(2);
    lc_tmor   number;
    ln_fcob   number;
    
    lc_ccob varchar2(50);
    lc_cren varchar2(50);
    lc_cobr varchar2(50);
    lc_chon varchar2(50);
    
    lc_cuo_o number;
    lc_cuo_n number;
    lc_fmant date;
    lc_sdoins_mant number(17,2);
    lc_prpago number(17,2);
    lc_pagrea number(17,2);
    lc_pramrt number(17,2);
    lc_pramrtx number(17,2);
    lc_vulcpa number(17,2);
    lc_vcprve number(17,2);
    lc_fuclpr date;
    lc_intcom number(17,2);
    lc_intcov number(17,2);
    lc_intmor number(17,2);
    lc_penali number(17,2);
    lc_gasm   number(17,2);
    lc_morm   number(17,2);
    lc_intm   number(17,2);
    lc_icvm   number(17,2);
    lc_penm   number(17,2);
    lc_tsumm  number(17,2);
    lc_capm   number(17,2);
  
    cursor reporte_covid19 is
    
      select /*+index(s SYS_C00982110) index(t fsd01009)*/t.pgcod,  
             t.aomod,
             t.aosuc,
             t.aomda,
             t.aopap,
             t.aocta,
             t.aooper,
             t.aosbop,
             t.aotope,
             s.pepais,
             s.petdoc,
             s.pendoc,
             concat(lpad(to_char(t.aocta), 9, '0'),
                    concat(lpad(to_char(t.aomda), 3, '0'),
                           lpad(to_char(t.aooper), 9, '0'))) prestamo,
             t.aoimp monto,
             t.aotasa tasa,
             t.aopzo plazo,
             t.aofval,
             t.aofvto,
             t.aostat,
             t.aofe99,
             g.aqpb095bfini,
             t.aotmor,
             substr(r.scrub, 1, 4) dcon
        from --jaqa400 x,
             fsd010 t
        JOIN fsr008 s
          on t.pgcod = s.pgcod
         and t.aocta = s.ctnro
        LEFT JOIN fsd011 r
          on r.pgcod = t.pgcod
         and r.scmod = t.aomod
            --and r.scsuc = t.aosuc -- jrodriguej 28.06.2021
         and r.scmda = t.aomda
         and r.scpap = t.aopap
         and r.sccta = t.aocta
         and r.scoper = t.aooper
      --and r.scsbop = t.aosbop
      --and r.sctope = t.aotope
        join aqpb095b g
          on g.aqpb095bcod = t.pgcod
            --and g.aqpb095bmod = t.aomod
            --and g.aqpb095bsuc = t.aosuc
         and g.aqpb095bmda = t.aomda
         and g.aqpb095bpap = t.aopap
         and g.aqpb095bcta = t.aocta
         and g.aqpb095bope = t.aooper
      --and g.aqpb065bsbo = t.aosbop
      --and g.aqpb095btop = t.aotope
      /*(select distinct u.aqpb095bcod,
                     u.aqpb095bmod,
                     u.aqpb095bsuc,
                     u.aqpb095bmda,
                     u.aqpb095bpap,
                     u.aqpb095bcta,
                     u.aqpb095bope,
                     u.aqpb095bsbo,
                     u.aqpb095btop,
                     u.aqpb095bfini
       from aqpb095b u
      where u.aqpb095bcod = 1
        and u.aqpb095bfec <= pn_ffin
        and u.aqpb095best <> 'D') g*/
       where
      --x.jaqa400emp = t.PGCOD
      --and x.jaqa400mod = t.AOMOD
      ----and x.jaqa400suc = t.AOSUC
      --and x.jaqa400mda = t.AOMDA
      --and x.jaqa400pap = t.AOPAP
      --and x.jaqa400cta = t.AOCTA
      --and x.jaqa400ope = t.AOOPER
      ----x.jaqa400sbo = t.AOSBOP and
      ----and x.jaqa400top = t.AOTOPE
      
      -- AQPB095B // FSD010 
      
      /* and exists (select 'x'
       from jaqa400 x
      where x.jaqa400emp = t.PGCOD
        and x.jaqa400mod = t.AOMOD
           --and x.jaqa400suc = t.AOSUC
        and x.jaqa400mda = t.AOMDA
        and x.jaqa400pap = t.AOPAP
        and x.jaqa400cta = t.AOCTA
        and x.jaqa400ope = t.AOOPER
           --x.jaqa400sbo = t.AOSBOP and
           --and x.jaqa400top = t.AOTOPE
           --and x.jaqa400ac1 in ('U','C')
        and x.jaqa400est in ('C', 'V')
        and x.jaqa400fec <= pn_ffin)*/
       g.aqpb095bfec <= pn_ffin
       and g.aqpb095best <> 'D'
       and t.aomod in (select modulo
                     from fst111
                    where dscod = 50
                      and modulo not in (29, 120, 144))
       and t.aofval <= pn_ffin
      --and t.aostat <> 99
       and (t.aostat <> 99 or (t.aostat = 99 and t.aofe99 > pn_ffin))
      
       and s.ttcod = 1
       and s.cttfir = 'T'
      
       and t.aosuc = pc_sucurs
      
      union
      -- REACTIVA CANCELADOS
      select /*+index(s SYS_C00982110) index(t fsd01011) */t.pgcod,
             t.aomod,
             t.aosuc,
             t.aomda,
             t.aopap,
             t.aocta,
             t.aooper,
             t.aosbop,
             t.aotope,
             s.pepais,
             s.petdoc,
             s.pendoc,
             
             concat(lpad(to_char(t.aocta), 9, '0'),
                    concat(lpad(to_char(t.aomda), 3, '0'),
                           lpad(to_char(t.aooper), 9, '0'))) prestamo,
             t.aoimp monto,
             t.aotasa tasa,
             t.aopzo plazo,
             t.aofval,
             t.aofvto,
             t.aostat,
             t.aofe99,
             g.aqpb095bfini,
             t.aotmor,
             substr(r.scrub, 1, 4) dcon
      --y.xwfprcins
        from --jaqa400 x,
             fsd010 t
        join fsr008 s
          on t.pgcod = s.pgcod
         and t.aocta = s.ctnro
        left join fsd011 r
          on r.pgcod = t.pgcod
         and r.scmod = t.aomod
            --and r.scsuc = t.aosuc -- jrodriguej 28.06.2021
         and r.scmda = t.aomda
         and r.scpap = t.aopap
         and r.sccta = t.aocta
         and r.scoper = t.aooper
      --and r.scsbop = t.aosbop
      --and r.sctope = t.aotope
        join aqpb095b g
          on g.aqpb095bcod = t.pgcod
            --and g.aqpb095bmod = t.aomod
            --and g.aqpb095bsuc = t.aosuc
         and g.aqpb095bmda = t.aomda
         and g.aqpb095bpap = t.aopap
         and g.aqpb095bcta = t.aocta
         and g.aqpb095bope = t.aooper
      --and g.aqpb065bsbo = t.aosbop
      --and g.aqpb095btop = t.aotope
      /*
      (select distinct u.aqpb095bcod,
                       u.aqpb095bmod,
                       u.aqpb095bsuc,
                       u.aqpb095bmda,
                       u.aqpb095bpap,
                       u.aqpb095bcta,
                       u.aqpb095bope,
                       u.aqpb095bsbo,
                       u.aqpb095btop,
                       u.aqpb095bfini
         from aqpb095b u
        where u.aqpb095bcod = 1
          and u.aqpb095bfec <= pn_ffin
          and u.aqpb095best <> 'D') g*/
       where
      --x.jaqa400emp = t.PGCOD
      --and x.jaqa400mod = t.AOMOD
      ----and x.jaqa400suc = t.AOSUC
      --and x.jaqa400mda = t.AOMDA
      --and x.jaqa400pap = t.AOPAP
      --and x.jaqa400cta = t.AOCTA
      --and x.jaqa400ope = t.AOOPER
      ----x.jaqa400sbo = t.AOSBOP and
      ----and x.jaqa400top = t.AOTOPE
      
      -- AQPB095B // FSD010 
      
      /*and exists (select 'x'
       from jaqa400 x
      where x.jaqa400emp = t.PGCOD
        and x.jaqa400mod = t.AOMOD
           --and x.jaqa400suc = t.AOSUC
        and x.jaqa400mda = t.AOMDA
        and x.jaqa400pap = t.AOPAP
        and x.jaqa400cta = t.AOCTA
        and x.jaqa400ope = t.AOOPER
           --x.jaqa400sbo = t.AOSBOP and
           --and x.jaqa400top = t.AOTOPE
           --and x.jaqa400ac1 in ('U','C')
        and x.jaqa400est in ('C', 'V')
        and x.jaqa400fec <= pn_ffin)*/
       g.aqpb095bfec <= pn_ffin
       and g.aqpb095best <> 'D'
       and t.aomod in (select modulo
                     from fst111
                    where dscod = 50
                      and modulo not in (29, 120, 144))
      
       and t.aofval <= pn_ffin
       and t.aostat = 99
      
       and s.ttcod = 1
       and s.cttfir = 'T'
      
       and not exists
       (select 'x'
          from fsd010 l
         where l.pgcod = t.pgcod
           and l.aomda = t.aomda
           and l.aopap = t.aopap
           and l.aocta = t.aocta
           and l.aooper = t.aooper
              
           and l.aomod in (select modulo
                             from fst111
                            where dscod = 50
                              and modulo not in (29, 120, 144))
           and l.aostat <> 99)
      
       and (t.aofe99, t.aosbop) in
       (select max(h.aofe99), max(h.aosbop)
          from fsd010 h
         where h.pgcod = t.pgcod
           and h.aomod = t.aomod
              --and h.aosuc = t.aosuc
           and h.aomda = t.aomda
           and h.aopap = t.aopap
           and h.aocta = t.aocta
           and h.aooper = t.aooper
              --and r.scsbop = t.aosbop
              --and h.aotope = t.aotope
           and h.aofe99 <= pn_ffin
              
           and h.aomod in (select modulo
                             from fst111
                            where dscod = 50
                              and modulo not in (29, 120, 144)))
      
       and t.aosuc = pc_sucurs
      
      ;
  
    cursor verificar_rep_semanal is
      select x.aqpb095usur usur,
             x.aqpb095suc suc,
             x.aqpb095cta cta,
             x.aqpb095ope oper,
             count(*) total
        from aqpb095 x
       where x.aqpb095usur = pn_usuario
         and x.aqpb095suc = pc_sucurs
       group by x.aqpb095usur, x.aqpb095suc, x.aqpb095cta, x.aqpb095ope
      having count(*) > 1;
  
    cursor verificar_rep_diario is
      select x.aqpb096usur usur,
             x.aqpb096suc suc,
             x.aqpb096cta cta,
             x.aqpb096ope oper,
             count(*) total
        from aqpb096 x
       where x.aqpb096usur = pn_usuario
         and x.aqpb096suc = pc_sucurs
       group by x.aqpb096usur, x.aqpb096suc, x.aqpb096cta, x.aqpb096ope
      having count(*) > 1;
  
    cursor datos_diario is
      select *
        from aqpb096 x
       where x.aqpb096usur = pn_usuario
         and x.aqpb096suc = pc_sucurs;
  
  begin
  
    ---delete from aqpb065 t where trim(t.aqpb065usur) = pn_usuario;
    ---commit;
  
    -- 1. Nro meses RCC
    begin
      select x.tp1nro1
        into lc_nro_mes
        from fst198 x
       where x.TP1COD = 1
         and x.TP1COD1 = 11144
         and x.TP1CORR1 = 10
         and x.tp1corr2 = 2
         and x.tp1corr3 = 4;
    exception
      when others then
        lc_nro_mes := 1;
    end;
  
    -- 2. Fecha clasificación SBS 
    select to_date(t.tpnro, 'DDMMYY')
      into lc_fecha_rcc
      from fst098 t
     where t.pgcod = 1
       and t.tpcod = 7647
       and t.tpcorr = 12;
  
    -- 3. Obtener flag para discriminar registros en el reporte diario
    begin
      select x.tp1nro1, x.tp1nro2
        into lc_flag_dia, --- Activación de día
             lc_dia_bor --- Cantidad de días hacia atrás
        from fst198 x
       where x.TP1COD = 1
         and x.TP1COD1 = 11144
         and x.TP1CORR1 = 10
         and x.tp1corr2 = 2
         and x.tp1corr3 = 5;
    exception
      when others then
        lc_flag_dia := 0;
        lc_dia_bor  := 0;
    end;
    --fecha mes anterior
    lc_fmant := trunc(pn_ffin) - (to_number(to_char(pn_ffin, 'DD')));
  
    if pn_ffin <= lc_fecha_rcc then
      lc_fecha_rcc := last_day(add_months(trunc(pn_ffin), -1 * lc_nro_mes));
    end if;
  
    -- Fecha actual
    select t.pgfape into lc_fecha from fst017 t where t.pgcod = 1;
  
    if pn_tip_rep = 1 then
      --- 1: Semanal, 2: Diario
    
      for j in reporte_covid19() loop
      
        ln_cta := j.aocta;
        ln_ope := j.aooper;
      
        -- 1. Información de Plantilla
        begin
          -- Call the procedure
          pq_cr_reporte_fond19.sp_plantilla_fcovid2(pn_cod   => j.pgcod,
                                                    pn_mod   => j.aomod,
                                                    pn_suc   => j.aosuc,
                                                    pn_mda   => j.aomda,
                                                    pn_pap   => j.aopap,
                                                    pn_cta   => j.aocta,
                                                    pn_ope   => j.aooper,
                                                    pn_sbo   => j.aosbop,
                                                    pn_top   => j.aotope,
                                                    pn_fecha => pn_ffin,
                                                    
                                                    pn_ncer  => lb_ncer,
                                                    pn_fdes  => lb_fdes,
                                                    pn_mon   => lb_mon,
                                                    pn_teac  => lb_teac,
                                                    pn_pgrac => lb_pgrac,
                                                    pn_finic => lb_finic,
                                                    pn_ffinc => lb_ffinc,
                                                    pn_prcof => lb_prcof,
                                                    pn_ccob => lc_ccob,
                                                    pn_cren => lc_cren,
                                                    pn_cobr => lc_cobr,
                                                    pn_chon => lc_chon);
        
        exception
          when others then
            lb_ncer  := null;
            lb_fdes  := null;
            lb_mon   := 0;
            lb_teac  := 0;
            lb_pgrac := 0;
            lb_finic := null;
            lb_ffinc := null;
            lb_prcof := 0;
            lc_ccob  := null;
            lc_cren  := null;
            lc_cobr  := null;
            lc_chon  := null;
        end;
      
        -- 2. Nro prestamo
        if j.aomda = 0 then
          lc_mda_pre := '00';
        else
          lc_mda_pre := '01';
        end if;
      
        begin
          lc_nro_pre := concat(lpad(to_char(j.aocta), 9, '0'),
                               concat(lc_mda_pre,
                                      lpad(to_char(j.aooper), 9, '0')));
        exception
          when others then
            lc_nro_pre := '';
        end;
      
        -- 8.Obtener datos de persona
        lx_pepais := j.pepais;
        lx_petdoc := j.petdoc;
        lx_pendoc := j.pendoc;
      
        -- 9. Razón social-Denominación 
        begin
          lc_razon := pq_cr_reporte_fond19_p2.fn_obtener_nombre(lx_pepais,
                                                                lx_petdoc,
                                                                lx_pendoc);
        exception
          when others then
            lc_razon := '';
        end;
      
        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --           
      
        begin
          -- Call the procedure
          pq_cr_reporte_fond19_p2.sp_obtener_calf(pn_tdoc   => lx_petdoc, --j.petdoc,
                                                  pn_ndoc   => lx_pendoc, --j.pendoc,
                                                  pn_fech   => pn_ffin,
                                                  pn_calif0 => lc_calif0,
                                                  pn_calif1 => lc_calif1,
                                                  pn_calif2 => lc_calif2,
                                                  pn_calif3 => lc_calif3,
                                                  pn_calif4 => lc_calif4,
                                                  pn_csbs   => lc_csbs);
        
        exception
          when others then
            lc_calif0 := 100;
            lc_calif1 := 0;
            lc_calif2 := 0;
            lc_calif3 := 0;
            lc_calif4 := 0;
            lc_csbs   := 0;
        end;
      
        lc_csbs := lpad(trim(lc_csbs), 11, '0');
      
        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
        -- 22. Tipo de Crédito SBS
      
        begin
          -- Call the procedure
          pq_cr_reporte_fond19_p2.sp_tipo_credito_sbs_vig(pn_cod     => j.pgcod,
                                                          pn_mod     => j.aomod,
                                                          pn_suc     => j.aosuc,
                                                          pn_mda     => j.aomda,
                                                          pn_pap     => j.aopap,
                                                          pn_cta     => j.aocta,
                                                          pn_ope     => j.aooper,
                                                          pn_sbo     => j.aosbop,
                                                          pn_top     => j.aotope,
                                                          pn_fecha   => pn_ffin,
                                                          pn_usuario => pn_usuario,
                                                          pn_ntipo   => lc_pcre_c,
                                                          pn_nconc   => lc_ncre);
        
        exception
          when others then
            lc_pcre_c := '';
            lc_ncre   := '';
        end;
        -------------------------------------------
        --  Tipo de Prestamo
      
        begin
          -- Call the procedure
          pq_cr_reporte_fond19_p2.sp_tipo_credito_fst004(pn_cod     => j.pgcod,
                                                         pn_mod     => j.aomod,
                                                         pn_suc     => j.aosuc,
                                                         pn_mda     => j.aomda,
                                                         pn_pap     => j.aopap,
                                                         pn_cta     => j.aocta,
                                                         pn_ope     => j.aooper,
                                                         pn_sbo     => j.aosbop,
                                                         pn_top     => j.aotope,
                                                         pn_fecha   => pn_ffin,
                                                         pn_usuario => pn_usuario,
                                                         pn_nconc   => lc_tprest);
        
        exception
          when others then
            lc_tprest := '';
        end;
      
        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --            
        -- 19. Período de Gracia
        begin
          lc_pgra := pq_cr_reporte_fond19_p2.fn_obtener_pgracia3(j.pgcod,
                                                                 j.aomod,
                                                                 j.aosuc,
                                                                 j.aomda,
                                                                 j.aopap,
                                                                 j.aocta,
                                                                 j.aooper,
                                                                 j.aosbop,
                                                                 j.aotope,
                                                                 pn_ffin);
        exception
          when others then
            lc_pgra := 0;
        end;
      
        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
        -- 20. Fecha Inicio, Fecha Fin
        begin
          -- Call the procedure
          pq_cr_reporte_fond19_p2.sp_obtener_actuales(pn_cod   => j.pgcod,
                                                      pn_mod   => j.aomod,
                                                      pn_suc   => j.aosuc,
                                                      pn_mda   => j.aomda,
                                                      pn_pap   => j.aopap,
                                                      pn_cta   => j.aocta,
                                                      pn_ope   => j.aooper,
                                                      pn_sbo   => j.aosbop,
                                                      pn_top   => j.aotope,
                                                      pn_fecha => pn_ffin,
                                                      pn_fini  => lx_fini_cre,
                                                      pn_ffin  => lx_ffin_cre);
        exception
          when others then
            lx_fini_cre := null;
            lx_ffin_cre := null;
        end;
        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
        /*begin
          -- Call the procedure
          pq_cr_reporte_fond19_p2.sp_fecha_ncuotas(pn_cod    => j.pgcod,
                                                   pn_mod    => j.aomod,
                                                   pn_suc    => j.aosuc,
                                                   pn_mda    => j.aomda,
                                                   pn_pap    => j.aopap,
                                                   pn_cta    => j.aocta,
                                                   pn_ope    => j.aooper,
                                                   pn_sbo    => j.aosbop,
                                                   pn_top    => j.aotope,
                                                   pn_fecha  => pn_ffin,
                                                   pn_ncuopp => lx_ncuopp, -- Nro cuotas
                                                   pn_ncuopa => lx_ncuopa); -- Cuotas ya pagadas
        exception
          when others then
            lx_ncuopp := 0;
            lx_ncuopa := 0;
        end;*/
        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
        begin
          -- Call the procedure nro de cuotas con fecha de inicio programa covid
          pq_cr_reporte_fond19_p2.sp_fecha_ncuotas2(pn_cod    => j.pgcod,
                                                    pn_mod    => j.aomod,
                                                    pn_suc    => j.aosuc,
                                                    pn_mda    => j.aomda,
                                                    pn_pap    => j.aopap,
                                                    pn_cta    => j.aocta,
                                                    pn_ope    => j.aooper,
                                                    pn_sbo    => j.aosbop,
                                                    pn_top    => j.aotope,
                                                    pn_fecha  => pn_ffin,
                                                    pn_fcovid => j.aqpb095bfini,
                                                    pn_ncuopp => lx_ncuopp, -- Nro cuotas
                                                    pn_ncuopa => lx_ncuopa); -- Cuotas ya pagadas
        exception
          when others then
            lc_sqlcode := SQLCODE;
            lc_sqlerrm := SQLERRM;
            lx_ncuopp  := 0;
            lx_ncuopa  := 0;
        end;
        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --        
        lx_ncuopp := lx_ncuopp + lc_pgra;
      
        -- 16.1 Saldo Insoluto Real
      
        begin
          pq_cr_reporte_fond19.sp_obtener_sald_insol2_h99(pn_cod   => j.pgcod,
                                                         pn_mod   => j.aomod,
                                                         pn_suc   => j.aosuc,
                                                         pn_mda   => j.aomda,
                                                         pn_pap   => j.aopap,
                                                         pn_cta   => j.aocta,
                                                         pn_ope   => j.aooper,
                                                         pn_sbo   => j.aosbop,
                                                         pn_top   => j.aotope,
                                                         pn_fecha => pn_ffin,
                                                         pn_indi  => 4, -- COVID19
                                                         pn_stat  => j.aostat, -- jrodriguej 07.07.2021
                                                         pn_sald  => lc_sdoins);
        
        exception
          when others then
            lc_sdoins := 0;
        end;
        if j.aostat = 99 then
           lc_sdoins := 0;
        end if;
        
        --------------------------------------
        --  Saldo Insoluto mes anterior
      
        begin
          pq_cr_reporte_fond19.sp_obtener_sald_insol2_h99(pn_cod   => j.pgcod,
                                                         pn_mod   => j.aomod,
                                                         pn_suc   => j.aosuc,
                                                         pn_mda   => j.aomda,
                                                         pn_pap   => j.aopap,
                                                         pn_cta   => j.aocta,
                                                         pn_ope   => j.aooper,
                                                         pn_sbo   => j.aosbop,
                                                         pn_top   => j.aotope,
                                                         pn_fecha => lc_fmant,
                                                         pn_indi  => 4, -- COVID19
                                                         pn_stat  => j.aostat, -- jrodriguej 07.07.2021
                                                         pn_sald  => lc_sdoins_mant);
        
        exception
          when others then
            lc_sdoins_mant := 0;
        end;
        if j.aostat = 99 then
          if j.aofe99 <= lc_fmant then 
            lc_sdoins_mant := 0;
          end if;
        end if;
        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
        -- Tasa de interes
        begin
          -- Call the procedure
          pq_cr_reporte_fond19_p2.sp_obtener_tasa_actual(pn_cod   => j.pgcod,
                                                         pn_mod   => j.aomod,
                                                         pn_suc   => j.aosuc,
                                                         pn_mda   => j.aomda,
                                                         pn_pap   => j.aopap,
                                                         pn_cta   => j.aocta,
                                                         pn_ope   => j.aooper,
                                                         pn_sbo   => j.aosbop,
                                                         pn_top   => j.aotope,
                                                         pn_fecha => pn_ffin,
                                                         pn_tasa  => lc_tea);
        exception
          when others then
            lc_tea := 0;
        end;
        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
        -- Tasa de interes moratoria
        begin
          -- Call the procedure
          pq_cr_reporte_fondos_p3.sp_obtener_tasa_moractual(pn_cod   => j.pgcod,
                                                            pn_mod   => j.aomod,
                                                            pn_suc   => j.aosuc,
                                                            pn_mda   => j.aomda,
                                                            pn_pap   => j.aopap,
                                                            pn_cta   => j.aocta,
                                                            pn_ope   => j.aooper,
                                                            pn_sbo   => j.aosbop,
                                                            pn_top   => j.aotope,
                                                            pn_fecha => pn_ffin,
                                                            pn_tasa  => lc_tmor);
        exception
          when others then
            lc_tmor := 0;
        end;
        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
        -- Tipo de Crédito Programa Covid (*)    
        begin
          -- Call the procedure
          pq_cr_reporte_fond19_p2.sp_obtener_tcredito(pn_cod     => j.pgcod,
                                                      pn_mod     => j.aomod,
                                                      pn_suc     => j.aosuc,
                                                      pn_mda     => j.aomda,
                                                      pn_pap     => j.aopap,
                                                      pn_cta     => j.aocta,
                                                      pn_ope     => j.aooper,
                                                      pn_sbo     => j.aosbop,
                                                      pn_top     => j.aotope,
                                                      pn_fecha   => pn_ffin,
                                                      pn_usuario => pn_usuario,
                                                      pn_tip     => lx_tip);
        exception
          when others then
            lx_tip := '';
        end;
        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
      
        begin
          -- Call the procedure
          pq_cr_reporte_fond19_p2.sp_obtener_iniciales(pn_cod      => j.pgcod,
                                                       pn_mod      => j.aomod,
                                                       pn_suc      => j.aosuc,
                                                       pn_mda      => j.aomda,
                                                       pn_pap      => j.aopap,
                                                       pn_cta      => j.aocta,
                                                       pn_ope      => j.aooper,
                                                       pn_sbo      => j.aosbop,
                                                       pn_top      => j.aotope,
                                                       pn_tasa_ini => lx_tas_ini); --- Tasa inicial
        end;
      
        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --     
        -- Porcentaje de reducción
        /*begin
          lx_por_err := (1 - (lc_tea / lx_tas_ini)) * 100;
        exception
          when others then
            lx_por_err := 0;
        end;*/ --Se lee de plantilla solicitado por Maria Fernandez
      
        lx_por_err := lb_prcof;
      
        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
        -- Saldo Capital 
        begin
          -- Call the function
          lx_sdo_cap := pq_cr_reporte_fond19_p2.fn_obtener_sdocap(pn_cod     => j.pgcod,
                                                                  pn_mod     => j.aomod,
                                                                  pn_suc     => j.aosuc,
                                                                  pn_mda     => j.aomda,
                                                                  pn_pap     => j.aopap,
                                                                  pn_cta     => j.aocta,
                                                                  pn_ope     => j.aooper,
                                                                  pn_sbo     => j.aosbop,
                                                                  pn_top     => j.aotope,
                                                                  pn_fecha   => pn_ffin,
                                                                  pn_usuario => pn_usuario);
        exception
          when others then
            lx_sdo_cap := 0;
        end;
        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
        -- Distribución de pago
        begin
          -- Call the procedure
          pq_cr_reporte_fondos_p3.sp_distribuc_pago_acum(pn_cod   => j.pgcod,
                                                         pn_mod   => j.aomod,
                                                         pn_suc   => j.aosuc,
                                                         pn_mda   => j.aomda,
                                                         pn_pap   => j.aopap,
                                                         pn_cta   => j.aocta,
                                                         pn_ope   => j.aooper,
                                                         pn_sbo   => j.aosbop,
                                                         pn_top   => j.aotope,
                                                         pn_fecha => pn_ffin,
                                                         pn_tsum  => lc_tsum,
                                                         pn_gas   => lc_gas,
                                                         pn_mor   => lc_mor,
                                                         pn_int   => lc_int,
                                                         pn_cuo   => lc_cuo,
                                                         pn_icv   => lc_icv,
                                                         pn_pen   => lc_pen);
        exception
          when others then
          
            lc_tsum := 0;
            lc_gas  := 0;
            lc_mor  := 0;
            lc_int  := 0;
            lc_cuo  := 0;
            lc_icv  := 0;
            lc_pen  := 0;
        end;
      
        --  Fecha de último pago                                              
        begin
        
          pq_cr_reporte_fondos_p3.sp_obtener_datos_ufecha(pn_cod   => j.pgcod,
                                                          pn_mod   => j.aomod,
                                                          pn_suc   => j.aosuc,
                                                          pn_mda   => j.aomda,
                                                          pn_pap   => j.aopap,
                                                          pn_cta   => j.aocta,
                                                          pn_ope   => j.aooper,
                                                          pn_sbo   => j.aosbop,
                                                          pn_top   => j.aotope,
                                                          pn_fecha => pn_ffin,
                                                          pn_fpagu => lc_fupag, -- Fecha de la última cuota pagada: ppfpag
                                                          
                                                          pn_fvenu => lc_fvenup); -- Fecha de vencimiento de la última cuota pagada
        exception
          when others then
            lc_fupag  := null;
            lc_fvenup := null;
        end;
      
        -- Fecha de vencimiento de la próxima cuota impaga
        begin
          -- Call the procedure
          pq_cr_reporte_fondos_p3.sp_obtener_impaga(pn_cod    => j.pgcod,
                                                    pn_mod    => j.aomod,
                                                    pn_suc    => j.aosuc,
                                                    pn_mda    => j.aomda,
                                                    pn_pap    => j.aopap,
                                                    pn_cta    => j.aocta,
                                                    pn_ope    => j.aooper,
                                                    pn_sbo    => j.aosbop,
                                                    pn_top    => j.aotope,
                                                    pn_fecha  => pn_ffin,
                                                    pn_fvenuc => lc_fvenuc);
        exception
          when others then
            lc_fvenuc := null;
        end;
        -----------------------------------------------------------------------
        --  DIAS DE ATRASO DEL CREDITO
        begin
          lc_diat := fn_dias_atraso(pn_ffin, --fecha de proceso
                                    j.pgcod,
                                    j.aomod,
                                    j.aosuc,
                                    j.aomda,
                                    j.aopap,
                                    j.aocta,
                                    j.aooper,
                                    j.aosbop,
                                    j.aotope,
                                    j.aostat,
                                    j.aofvto);
        exception
          when others then
            lc_diat := 0;
        end;
        ---------------------------------------------------------------
        --Flag reprogramado tabla jaqa400
       /* lc_frepro := 'N';
        begin
          select 'S'
            into lc_frepro
            from jaqa400 x
           where x.jaqa400emp = j.pgcod
             --and x.jaqa400mod = j.aomod
                --and x.jaqa400suc = t.AOSUC
             --and x.jaqa400mda = j.aomda
             --and x.jaqa400pap = j.aopap
             and x.jaqa400cta = j.aocta
             and x.jaqa400ope = j.aooper
                --x.jaqa400sbo = t.AOSBOP and
                --and x.jaqa400top = t.AOTOPE
                --and x.jaqa400ac1 in ('U','C')
             and x.jaqa400est in ('C')
             and x.jaqa400fec <= pn_ffin;
        exception
          when others then
            lc_frepro := 'N';
        end;*/
        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
        begin
          -- Call the procedure 
          pq_cr_reporte_fondos_p3.sp_obtener_datoshonrado(pn_cod    => j.pgcod,
                                                          pn_mod    => j.aomod,
                                                          pn_suc    => j.aosuc,
                                                          pn_mda    => j.aomda,
                                                          pn_pap    => j.aopap,
                                                          pn_cta    => j.aocta,
                                                          pn_ope    => j.aooper,
                                                          pn_sbo    => j.aosbop,
                                                          pn_top    => j.aotope,
                                                          pn_rubr   => 9300082050000,
                                                          pd_fecha  => pn_ffin,
                                                          pc_eshonr => lc_eshonr,
                                                          pn_mhonr  => ln_mhonr,
                                                          pd_fhonr  => ld_fhonr,
                                                          pn_sdohon => ln_sdohon);
        exception
          when others then
            lc_eshonr := '';
            ln_mhonr  := 0;
            ld_fhonr  := null;
            ln_sdohon := 0;
        end;
        ------------- ------------- --------------- -------------
        begin
          -- Call the procedure
          pq_cr_reporte_fondos_p3.sp_obtener_sucs(pn_sucs => j.aosuc,
                                                  pn_regi => lc_regi,
                                                  pn_zona => lc_zona,
                                                  pn_nsuc => lc_nsuc,
                                                  pn_nzon => lc_nzon,
                                                  pn_nreg => lc_nreg);
        exception
          when others then
            lc_regi := 0;
            lc_zona := 0;
            lc_nsuc := '';
            lc_nzon := '';
            lc_nreg := '';
        end;
        ----------------------------------------  ANALISTA
        begin
          lc_ases := fn_analista_credito(j.aomod,
                                         j.aosuc,
                                         j.aomda,
                                         j.aopap,
                                         j.aocta,
                                         j.aooper,
                                         j.aosbop,
                                         j.aotope);
        exception
          when others then
            lc_ases := '';
        end;
        ---------------------------------------------------------
        --  ESF RUC CAJA
        lx_esf := '20100209641';
        ----------------------------------------------------------------
        -- ESTADO DEL CREDITO
        begin
          lc_statd := pq_cr_reporte_fondos_p3.fn_estado_desc(j.aostat);
        exception
          when others then
            lc_statd := '';
        end;
        --------------------------------------------------------------
        -- 45. CIUU
        -- 46. Actividad económica
        begin
          -- Call the procedure
          pq_cr_reporte_fondos_p3.sp_ciiu_codigo4(p_pais   => j.pepais,
                                                  p_petdoc => j.petdoc,
                                                  p_pendoc => j.pendoc,
                                                  p_ciuu4  => lc_ciiu4,
                                                  p_ciuu6  => lc_ciiu6);
        exception
          when others then
            lc_ciiu4 := 0;
            lc_ciiu6 := 0;
        end;
      
        -- 10.2 Descripción de CIUU 
        begin
          -- Call the procedure                                    
          if lc_ciiu4 <> 0 then
            pq_cr_reporte_fondos_p3.sp_obtener_ciuu(pn_cciu => lc_ciiu6,
                                                    pn_dciu => lc_acti);
          else
            if lc_ciiu6 <> 0 then
              lc_ciiu4 := to_number(substr(to_char(lc_ciiu6), 1, 4));
            else
              lc_ciiu4 := 0;
            end if;
            lc_acti := '';
          end if;
        
        exception
          when others then
            lc_acti := '';
        end;
        ------------------------------------------------------------------------
        -- 10. Distribución clasificación de riesgo enviado por caja
        begin
          -- Call the procedure
          pq_cr_reporte_fondos_p3.sp_obtener_calf_caja(pn_cod   => j.pgcod,
                                                       pn_mod   => j.aomod,
                                                       pn_suc   => j.aosuc,
                                                       pn_mda   => j.aomda,
                                                       pn_pap   => j.aopap,
                                                       pn_cta   => j.aocta,
                                                       pn_ope   => j.aooper,
                                                       pn_sbo   => j.aosbop,
                                                       pn_top   => j.aotope,
                                                       pn_est   => j.aostat,
                                                       pn_fecha => pn_ffin,
                                                       --pn_dcla => lc_dcla,
                                                       --pn_ncla => lc_ncla
                                                       pn_calif0a => lc_calif0a,
                                                       pn_calif1a => lc_calif1a,
                                                       pn_calif2a => lc_calif2a,
                                                       pn_calif3a => lc_calif3a,
                                                       pn_calif4a => lc_calif4a,
                                                       pn_deccaj  => lc_fecha_caj);
        exception
          when others then
            lc_calif0a   := 100;
            lc_calif1a   := 0;
            lc_calif2a   := 0;
            lc_calif3a   := 0;
            lc_calif4a   := 0;
            lc_fecha_caj := null;
        end;
        -- '53. Flag de re reprogramación';
        -- '54. Número de reprogramaciones';
        -- '55. Fecha de re reprogramación';
        begin
          -- Call the procedure
          pq_cr_reporte_fondos_p3.sp_repro_dato_jaqa400(pn_cod   => j.pgcod,
                                                 pn_cta   => j.aocta,
                                                 pn_ope   => j.aooper,
                                                 pn_fecha => pn_ffin,
                                                 pn_flag  => lc_lrep,
                                                 pn_nrep  => lc_nrep,
                                                 pn_fech  => lc_frep,
                                                 pn_tabla => lc_tabla,
                                                 
                                                 pn_peri => lc_peri2,
                                                 pn_ncuo => lc_ncuo2,
                                                 pn_fpri => lc_fpri,
                                                 pn_fult => lc_fult);
        exception
          when others then
          
            lc_lrep  := 'NO';
            lc_nrep  := 0;
            lc_frep  := null;
            lc_tabla := '';
            lc_peri2 := 0;
            lc_ncuo2 := 0;
            lc_fpri  := null;
            lc_fult  := null;
        end;
        if lc_lrep = 'NO' then
          begin
            -- Call the procedure
            pq_cr_reporte_fondos_p3.sp_repro_dato1(pn_cod   => j.pgcod,
                                                   pn_cta   => j.aocta,
                                                   pn_ope   => j.aooper,
                                                   pn_fecha => pn_ffin,
                                                   pn_flag  => lc_lrep,
                                                   pn_nrep  => lc_nrep,
                                                   pn_fech  => lc_frep,
                                                   pn_tabla => lc_tabla,
                                                   
                                                   pn_peri => lc_peri2,
                                                   pn_ncuo => lc_ncuo2,
                                                   pn_fpri => lc_fpri,
                                                   pn_fult => lc_fult);
          exception
            when others then
            
              lc_lrep  := 'NO';
              lc_nrep  := 0;
              lc_frep  := null;
              lc_tabla := '';
              lc_peri2 := 0;
              lc_ncuo2 := 0;
              lc_fpri  := null;
              lc_fult  := null;
          end;
        end if;
        lc_frepro := substr(trim(lc_lrep),1,1);
        
        
        -- 35. Fecha de cancelación de última cuota pagado
        begin
          lc_ufpag1 := pq_cr_reporte_fondos_p3.fn_fecha_upago(j.pgcod,
                                                              j.aomod,
                                                              j.aosuc,
                                                              j.aomda,
                                                              j.aopap,
                                                              j.aocta,
                                                              j.aooper,
                                                              j.aosbop,
                                                              j.aotope,
                                                              pn_ffin);
        exception
          when others then
            lc_ufpag1 := null;
        end;
      
        -- 24. Estado contable
        begin
          -- Call the procedure
          pq_cr_reporte_fondos_p3.sp_obtener_scond_c(pn_cod   => j.pgcod,
                                                     pn_mod   => j.aomod,
                                                     pn_suc   => j.aosuc,
                                                     pn_mda   => j.aomda,
                                                     pn_pap   => j.aopap,
                                                     pn_cta   => j.aocta,
                                                     pn_ope   => j.aooper,
                                                     pn_sbo   => j.aosbop,
                                                     pn_top   => j.aotope,
                                                     pn_dcon  => j.dcon,
                                                     pn_est   => j.aostat,
                                                     pn_ufech => lc_ufpag1,
                                                     pn_rubr  => lc_dcon,
                                                     pn_resp  => lc_scon);
        exception
          when others then
            lc_dcon := '';
            lc_scon := '';
        end;
        ---------------------------------------------------------
        begin
          pq_cr_reporte_fondos_p200.sp_distribuc_pago_mes(pn_cod   => j.pgcod,
                                                          pn_mod   => j.aomod,
                                                          pn_suc   => j.aosuc,
                                                          pn_mda   => j.aomda,
                                                          pn_pap   => j.aopap,
                                                          pn_cta   => j.aocta,
                                                          pn_ope   => j.aooper,
                                                          pn_sbo   => j.aosbop,
                                                          pn_top   => j.aotope,
                                                          pn_fecha => pn_ffin,
                                                          pn_tsum  => lc_tsum1,
                                                          pn_gas   => lc_gas1,
                                                          pn_mor   => lc_mor1,
                                                          pn_int   => lc_int1,
                                                          pn_cuo   => lc_mpre,
                                                          pn_icv   => lc_icv1,
                                                          pn_pen   => lc_pen1);
        
        exception
          when others then
            lc_mpre := 0;
        end;
        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
        begin
          -- Call the procedure 
          pq_cr_reporte_fondos_p3.sp_obtener_fcamb_estado(pn_cod   => j.pgcod,
                                                          pn_mod   => j.aomod,
                                                          pn_suc   => j.aosuc,
                                                          pn_mda   => j.aomda,
                                                          pn_pap   => j.aopap,
                                                          pn_cta   => j.aocta,
                                                          pn_ope   => j.aooper,
                                                          pn_sbo   => j.aosbop,
                                                          pn_top   => j.aotope,
                                                          pd_fecha => pn_ffin,
                                                          pd_fcest => ld_cest);
        exception
          when others then
            ld_cest := null;
        end;
        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
        begin
          -- Call the procedure 
          pq_cr_reporte_fond19.sp_obtener_drefinanciac(pn_cod    => j.pgcod,
                                                       pn_mod    => j.aomod,
                                                       pn_suc    => j.aosuc,
                                                       pn_mda    => j.aomda,
                                                       pn_pap    => j.aopap,
                                                       pn_cta    => j.aocta,
                                                       pn_ope    => j.aooper,
                                                       pn_sbo    => j.aosbop,
                                                       pn_top    => j.aotope,
                                                       pd_fecha  => pn_ffin,
                                                       pc_lrefin => lc_lrefin,
                                                       pd_frefin => ld_frefin);
        exception
          when others then
            ld_frefin := null;
            lc_lrefin := '';
        end;
        if lc_scon = 'RFN' then
          lc_lrefin := 'S';
        else
          ld_frefin := null;
          lc_lrefin := 'N';
        end if;
        ---------------------------------------------------------------------
        --FACTOR COBERTURA
        begin
          if lc_sdoins = 0 then
            ln_fcob := 0;
          else
          if lx_ncuopa < (lx_ncuopp - lc_pgra) / 3 then
            ln_fcob := 0;
          else
            if lx_ncuopa < (lx_ncuopp - lc_pgra) * 2 / 3 then
              if lx_tip = 'VEH' then
                ln_fcob := 40;
              else
                if lx_tip = 'MYP' then
                  ln_fcob := 40;
                else
                  if lx_tip = 'CCP' then
                    if lc_sdoins <= 5000 then
                      ln_fcob := 60;
                    else
                      if lc_sdoins <= 10000 then
                        ln_fcob := 40;
                      else
                        ln_fcob := 0;
                      end if;
                    end if;
                  else
                    if lx_tip = 'HIP' then
                      ln_fcob := 50;
                    else
                      ln_fcob := 0;
                    end if;
                  end if;
                end if;
              end if;
            else
              if lx_tip = 'VEH' or lx_tip = 'MYP' or lx_tip = 'CCP' or
                 lx_tip = 'HIP' then
                ln_fcob := 80;
              else
                ln_fcob := 0;
              end if;
            end if;
          end if;
          end if;
        end;
        --------------------------------------------------------------------------
      --  Número de cuotas crono actual
            begin
              lc_cuo_n := pq_cr_reporte_fondos_p3.fn_fecha_ncuoa(pn_cod => j.pgcod,
                                                                 pn_mod => j.aomod,
                                                                 pn_suc => j.aosuc,
                                                                 pn_mda => j.aomda,
                                                                 pn_pap => j.aopap,
                                                                 pn_cta => j.aocta,
                                                                 pn_ope => j.aooper,
                                                                 pn_sbo => j.aosbop,
                                                                 pn_top => j.aotope);
            exception
              when others then
                lc_cuo_n := 0;
            end;
      --------------------------------------------------------------------------
      --  Número de cuotas crono original
            begin
              lc_cuo_o := pq_cr_reporte_fondos_p3.fn_fecha_ncuoi(pn_cod => j.pgcod,
                                                                 pn_mod => j.aomod,
                                                                 pn_suc => j.aosuc,
                                                                 pn_mda => j.aomda,
                                                                 pn_pap => j.aopap,
                                                                 pn_cta => j.aocta,
                                                                 pn_ope => j.aooper,
                                                                 pn_sbo => j.aosbop,
                                                                 pn_top => j.aotope);
            exception
              when others then
                lc_cuo_o := 0;
            end;
        --------------------------------------------------------------------------
      --  Pago realizado y principal amortizado
            begin
              pq_cr_reporte_fondos_p3.sp_distribuc_pago_mes_pa(pn_cod => j.pgcod,
                                                                 pn_mod => j.aomod,
                                                                 pn_suc => j.aosuc,
                                                                 pn_mda => j.aomda,
                                                                 pn_pap => j.aopap,
                                                                 pn_cta => j.aocta,
                                                                 pn_ope => j.aooper,
                                                                 pn_sbo => j.aosbop,
                                                                 pn_top => j.aotope,
                                                                 pn_fecha => pn_ffin,
                                                                 pn_tsum => lc_pagrea,
                                                                 pn_gas => lc_gasm,
                                                                 pn_mor => lc_morm,
                                                                 pn_int => lc_intm,
                                                                 pn_cuo => lc_pramrtx,
                                                                 pn_icv => lc_icvm,
                                                                 pn_pen => lc_penm,
                                                                 pn_pamr => lc_pramrt);
            exception
              when others then
                lc_pagrea := 0;
                lc_pramrt := 0;
            end;
      --------------------------------------------------------------------------
      --  Valores cuota pagada y proxima
            begin
              pq_cr_reporte_fondos_p3.sp_obtener_valorcuotas(pn_cod => j.pgcod,
                                                                 pn_mod => j.aomod,
                                                                 pn_suc => j.aosuc,
                                                                 pn_mda => j.aomda,
                                                                 pn_pap => j.aopap,
                                                                 pn_cta => j.aocta,
                                                                 pn_ope => j.aooper,
                                                                 pn_sbo => j.aosbop,
                                                                 pn_top => j.aotope,
                                                                 pn_fecha => pn_ffin,
                                                                 pn_vulcpa => lc_vulcpa,
                                                                 pn_vcprve => lc_vcprve,
                                                                 pn_fuclpa => lc_fuclpr);
            exception
              when others then
                lc_vulcpa := 0;
                lc_vcprve := 0;
                lc_fuclpr := null;
            end;
      --------------------------------------------------------------------------
      --  Pago intereses compe,mora, penalidad reporte mora
            begin
              pq_cr_reporte_fondos_p3.sp_obtener_montos_rmora(pn_cod => j.pgcod,
                                                                 pn_mod => j.aomod,
                                                                 pn_suc => j.aosuc,
                                                                 pn_mda => j.aomda,
                                                                 pn_pap => j.aopap,
                                                                 pn_cta => j.aocta,
                                                                 pn_ope => j.aooper,
                                                                 pn_sbo => j.aosbop,
                                                                 pn_top => j.aotope,
                                                                 pn_fecha => pn_ffin,
                                                                 pn_int => lc_intm,
                                                                 pn_mor => lc_morm,
                                                                 pn_icv => lc_icvm,
                                                                 pn_pen => lc_penm);
            exception
              when others then
                lc_intm := 0;
                lc_icvm := 0;
                lc_morm := 0;
                lc_penm := 0;
            end;
      -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                  
      --  monto prepago
    
      begin
        -- Call the procedure
        pq_cr_reporte_fondos_p3.sp_obtener_mprepago(pn_cod     => j.pgcod,
                                                      pn_mod     => j.aomod,
                                                      pn_suc     => j.aosuc,
                                                      pn_mda     => j.aomda,
                                                      pn_pap     => j.aopap,
                                                      pn_cta     => j.aocta,
                                                      pn_ope     => j.aooper,
                                                      pn_sbo     => j.aosbop,
                                                      pn_top     => j.aotope,
                                                      pn_fecha   => pn_ffin,
                                                      pn_monto   => lc_prpago);
      exception
        when others then
          lc_prpago := 0;
      end;
        ---------------------------------------------------------------------
        begin
          insert into aqpb095
            (aqpb095usur,
             aqpb095pgcod,
             aqpb095mod,
             aqpb095suc,
             aqpb095mda,
             aqpb095pap,
             aqpb095cta,
             aqpb095ope,
             aqpb095sbop,
             aqpb095tope,
             aqpb095ncer, -- 1. N° Certificado 
             aqpb095ndoc, -- 2. Numero Documento
             aqpb095csbs, -- 3. Codigo de Cliente SBS
             aqpb095razn, -- 4. Razon Social
             aqpb095tcrep, -- 5. Tipo credito Programa Garantias-COVID19
             aqpb095pres, -- 6. N° préstamo 
             aqpb095mpre, -- 7. Monto Prestamo reprogramado
             aqpb095sdoi, -- 8. Saldo insoluto del prestamo reprogramado
             aqpb095peri, -- 9. Periodo Total del Crédito Reprogramado (Nro Cuotas + nro Periodo de Gracia)
             aqpb095ncuo, -- 10. Numero cuotas pagadas credito reprogramado
             aqpb095tea, -- 11. TEA reprogramado % (dos decimales)
             
             aqpb095pgra, -- 12. Periodo de Gracia del Crédito Reprogramado (Nro de Periodos) 
             aqpb095fini, -- 13. Fecha Inicio de crédito reprogramado
             aqpb095ffin, -- 14. Fecha fin de crédito reprogramado
             aqpb095tcre, -- 15. Tipo de Creditos SBS
             aqpb095ncre, -- 15.1 Tipo de Creditos SBS - Concepto
             aqpb095fcla, -- 16. Fecha de Calificación Actualizada
             aqpb095cnom, -- 17. Calificacion Crediticia Normal (%)
             aqpb095ccpp, -- 18. Calificacion Crediticia CPP (%)
             aqpb095cdef, -- 19. Calificación Deficiente (%)
             aqpb095cdud, -- 20. Calificación Dudoso (%)
             aqpb095cper, -- 21. Calificación Perdida (%)
             aqpb095rest, -- 22. % de Reducción Estimado según el artículo 11.3 del RO - RM  No 296-2020-EF/15
             
             aqpb095teac, -- 23. Tea Reprogramada Enviada a COFIDE
             aqpb095pgrac, -- 24. Período de Gracia Enviado a COFIDE
             aqpb095finic, -- 25. Fecha de Inicio Según COFIDE
             aqpb095ffinc, -- 26. Fecha de Fin Según COFIDE              
             
             aqpb095stat, -- Estado 
             aqpb095fe99, -- Fecha de cancelación
             aqpb095fproc, -- Fecha de Corte
             aqpb095fcr,
             aqpb095hcr,
             aqpb095tdoc,
             aqpb095mor,
             aqpb095ndmor,
             aqpb095fvenui,
             aqpb095fvenup,
             aqpb095tprest,
             aqpb095int,
             aqpb095frepr,
             aqpb095mhonr,
             aqpb095fhonr,
             aqpb095chonr,
             aqpb095sdocap,
             aqpb095sdohon,
             aqpb095crehon,
             aqpb095reg,
             aqpb095nreg,
             aqpb095nsuc,
             aqpb095ase,
             aqpb095ccong,
             aqpb095esf,
             aqpb095fcober,
             aqpb095statd,
             aqpb095fstat,
             aqpb095tmora,
             aqpb095ciuu,
             aqpb095acteco,
             aqpb095fpag,
             aqpb095gas,
             aqpb095cuo,
             aqpb095icv,
             aqpb095pen,
             aqpb095fclas,
             aqpb095cnoms,
             aqpb095ccpps,
             aqpb095cdefs,
             aqpb095cduds,
             aqpb095cpers,
             aqpb095lrep,
             aqpb095nrep,
             aqpb095frep,
             aqpb095pfec,
             aqpb095ncuop,
             aqpb095pgrap,
             aqpb095pfinp,
             aqpb095lrefin,
             aqpb095frefin,
             aqpb095dcon,
             aqpb095ncon,
             aqpb095mprep,
             aqpb095fprep,
             aqpb095fvenmor,
             aqpb095ccob,
             aqpb095cren,
             aqpb095cobr,
             aqpb095chon,
             aqpb095tercio,
             aqpb095sinsap,
            aqpb095prpago,
            aqpb095pagrea,
            aqpb095pramrt,
            aqpb095nrccor,
            aqpb095nrccac,
            aqpb095vulcpa,
            aqpb095vcprve,
            aqpb095fuclpr,
            aqpb095intcom,
            aqpb095intcov,
            aqpb095intmor,
            aqpb095penali)
          values
            (pn_usuario,
             j.pgcod,
             j.aomod,
             j.aosuc, -- 54. Agencia (Sucursal)
             j.aomda,
             j.aopap,
             j.aocta, -- 56. Nro. de Cuenta
             j.aooper, -- 57. Nro. de Operación  
             j.aosbop,
             j.aotope,
             
             lb_ncer, -- 1. N° Certificado 
             j.pendoc, -- 2. Numero Documento
             lc_csbs, -- 3. Codigo de Cliente SBS
             lc_razon, -- 4. Razon Social
             lx_tip, -- 5. Tipo credito Programa Garantias-COVID19
             lc_nro_pre, -- 6. N° préstamo 
             lb_mon, --j.monto, -- 7. Monto Prestamo reprogramado
             lc_sdoins, --lx_sdo_cap, --lc_sdoins, -- 8. Saldo insoluto del prestamo reprogramado
             lx_ncuopp, -- 9. Periodo Total del Crédito Reprogramado (Nro Cuotas + nro Periodo de Gracia)
             lx_ncuopa, -- 10. Numero cuotas pagadas credito reprogramado
             lc_tea, -- 11. TEA reprogramado % (dos decimales)
             
             lc_pgra, -- 12. Periodo de Gracia del Crédito Reprogramado (Nro de Periodos) 
             lx_fini_cre, -- 13. Fecha Inicio de crédito reprogramado
             lx_ffin_cre, -- 14. Fecha fin de crédito reprogramado
             lc_pcre_c, -- 15. Tipo de Creditos SBS
             substr(trim(lc_ncre), 1, 20), -- 15.1 Tipo de Creditos SBS - Concepto
             lc_fecha_caj, -- 16. Fecha de Calificación Actualizada
             lc_calif0a, -- 10.a Calificación Normal (en números de 100 a 0), reportado por caja al cierre de mes
             lc_calif1a, -- 10.b Calificación CPP (en números de 100 a 0), reportado por caja al cierre de mes
             lc_calif2a, -- 10.c Calificación Deficiente (en números de 100 a 0), reportado por caja al cierre de mes
             lc_calif3a, -- 10.d Calificación Dudoso (en números de 100 a 0), reportado por caja al cierre de mes
             lc_calif4a, -- 10.e Calificación Perdida (en números de 100 a 0), reportado por caja al cierre de mes
             lx_por_err, -- 22. % de Reducción Estimado según el artículo 11.3 del RO - RM  No 296-2020-EF/15
             
             lb_teac, -- 23. Tea Reprogramada Enviada a COFIDE
             lb_pgrac, -- 24. Período de Gracia Enviado a COFIDE
             lb_finic, -- 25. Fecha de Inicio Según COFIDE
             lb_ffinc, -- 26. Fecha de Fin Según COFIDE             
             
             j.aostat, -- Estado
             j.aofe99, -- Fecha de cancelacion
             pn_ffin, -- Fecha de procesamiento
             to_char(sysdate, 'DD/MM/YYYY'), -- aqpb095fcr,
             to_char(sysdate, 'HH24:MI:SS'), -- aqpb095hcr
             j.petdoc,
             lc_mor,
             lc_diat,
             lc_fvenuc,
             lc_fvenup,
             lc_tprest,
             lc_int,
             lc_frepro,
             ln_mhonr, --monto honrado
             ld_fhonr, --fecha honramiento
             lc_eshonr, --es honrado
             lx_sdo_cap,
             ln_sdohon,
             lx_sdo_cap + ln_sdohon,
             lc_regi, -- 52. Región
             substr(trim(lc_nreg), 1, 30), -- 52.1 Región - Nombre               
             substr(trim(lc_nsuc), 1, 30), -- 54.1 Agencia(Sucursal) - Nombre
             substr(trim(lc_ases), 1, 10), -- 55. Analista  
             '', --codigo congelamiento
             lx_esf,
             ln_fcob, --factor cobertura
             --0,
             lc_statd, --estado del credito
             case when
             ld_cest > nvl(j.aofe99, to_date('01/01/0001', 'DD/MM/YYYY'))
             then(case when
                  ld_cest >
                  nvl(lc_frep, to_date('01/01/0001', 'DD/MM/YYYY')) then
                  ld_cest else lc_frep end)
             else(case when
                  nvl(lc_frep, to_date('01/01/0001', 'DD/MM/YYYY')) >
                  nvl(j.aofe99, to_date('01/01/0001', 'DD/MM/YYYY')) then
                  lc_frep else j.aofe99 end) end, --fecha de cambio de estado, -- 44. Fecha del cambio de estado del crédito.
             
             lc_tmor, --tasa moratoria
             lc_ciiu4, -- 50. CIUU
             substr(trim(lc_acti), 1, 60), -- 51. Actividad económica
             lc_fupag, --fecha de pago de ultimo pago
             lc_gas, -- 60. Seguros               
             lc_cuo, -- 63. Capital
             lc_icv, -- 64. Interés compensatorio
             lc_pen, -- 65. Penalidad   
             lc_fecha_rcc, -- 43. Fecha clasificación SBS         
             lc_calif0, -- 44. Calificación Normal (en números de 100 a 0)
             lc_calif1, -- 45. Calificación CPP (en números de 100 a 0)  
             lc_calif2, -- 46. Calificación Deficiente (en números de 100 a 0)
             lc_calif3, -- 47. Calificación Dudoso (en números de 100 a 0)
             lc_calif4, -- 48. Calificación Perdida (en números de 100 a 0     
             lc_frepro, -- 53. Flag de re reprogramación
             lc_nrep, -- 54. Número de reprogramaciones
             lc_frep, -- 55. Fecha de re reprogramación
             lc_fpri, -- 56. Fecha de primera cuota de re reprogramación
             lc_ncuo2, --lc_ncuopg, --Borrar! -- 57. Nro. de cuotas posterior a re reprogramación
             lc_peri2, -- 58. Periodo de gracia posterior a re reprogramación
             lc_fult, -- 59. Fecha de fin de crédito posterior a re reprogramación  
             lc_lrefin, --flag refinanciamiento
             case when lc_scon = 'RFN' then ld_frefin else null end, --fecha refinanciamiento
             substr(trim(lc_dcon), 1, 4), -- 11. Situación contable                
             substr(trim(lc_scon), 1, 20), -- 11.1. Concepto
             lc_mpre, --monto prepago
             j.aofe99, --fecha prepago
             lc_fvenuc, --fecha de venc credito en mora
             lc_ccob,
             lc_cren,
             lc_cobr,
             lc_chon,
             case when lx_ncuopa < (lx_ncuopp-lc_pgra)/3 then 'No apto' else 
               (case when lx_ncuopa < (lx_ncuopp-lc_pgra)*2/3 then '1er Tercio' else '2do tercio' end )end,
            lc_sdoins_mant, --saldo insoluto antes del prepago 
            nvl(lc_sdoins_mant - lc_sdoins,0), --prepago
            lc_pagrea, -- pago realizado
            lc_pramrt, --principal amortizado
            lc_cuo_o, --numero de cuotas creditos original
            lc_cuo_n, --numero ce cuotas credito actual
            lc_vulcpa, --valor ultima cuota pagada
            lc_vcprve, --valor cuota proximo vencimiento
            lc_fuclpr, -- Nueva fecha de la ultima cuota luego del prepago,
            lc_intm, --interes compensatorio
            lc_icvm, --interes compensatorio vencido
            lc_morm, --interes moratorio
            lc_penm --penalidad
             );
        
          commit;
        
        exception
          when others then
          
            lc_coderr := substr(trim(sqlcode), 1, 100);
            lc_msgerr := substr(trim(sqlerrm), 1, 1000);
          
            begin
              insert into AQPB070E
                (aqpb070etab,
                 aqpb070efec,
                 aqpb070esuc,
                 aqpb070eusr,
                 aqpb070ecoe,
                 aqpb070emsge,
                 aqpb070efcr,
                 aqpb070ehcr,
                 aqpb070ecta,
                 aqpb070eope)
              values
                ('AQPB095',
                 pn_ffin,
                 pc_sucurs,
                 substr(trim(pn_usuario), 1, 10),
                 lc_coderr,
                 lc_msgerr,
                 to_char(sysdate, 'DD/MM/YYYY'),
                 to_char(sysdate, 'HH24:MI:SS'),
                 ln_cta,
                 ln_ope);
              commit;
            exception
              when others then
                null;
            end;
          
        end;
      
      end loop;
    
      for z in verificar_rep_semanal() loop
      
        ln_cta := z.cta;
        ln_ope := z.oper;
      
        begin
          select 'S'
            into lb_flag_vig
            from aqpb095 x
           where x.aqpb095usur = pn_usuario
             and x.aqpb095suc = pc_sucurs
             and x.aqpb095cta = z.cta
             and x.aqpb095ope = z.oper
             and x.aqpb095stat <> 99;
        exception
          when others then
            lb_flag_vig := 'N';
        end;
      
        begin
          if lb_flag_vig = 'S' then
            --- Hay vigente, borrar los no vigentes
          
            delete from aqpb095 x
             where x.aqpb095usur = pn_usuario
               and x.aqpb095suc = pc_sucurs
               and x.aqpb095cta = z.cta
               and x.aqpb095ope = z.oper
               and x.aqpb095stat = 99;
            commit;
          
          else
            --- Solo hay cancelados, dejar el crédito con máxima fecha de cancelación
            select max(x.aqpb095fe99)
              into lb_fmax_anu
              from aqpb095 x
             where x.aqpb095usur = pn_usuario
               and x.aqpb095suc = pc_sucurs
               and x.aqpb095cta = z.cta
               and x.aqpb095ope = z.oper
               and x.aqpb095stat = 99;
          
            delete from aqpb095 x
             where x.aqpb095usur = pn_usuario
               and x.aqpb095suc = pc_sucurs
               and x.aqpb095cta = z.cta
               and x.aqpb095ope = z.oper
               and x.aqpb095fe99 <> lb_fmax_anu
               and x.aqpb095stat = 99;
            commit;
          
          end if;
        
        exception
          when others then
          
            lc_coderr := substr(trim(sqlcode), 1, 100);
            lc_msgerr := substr(trim(sqlerrm), 1, 1000);
          
            begin
              insert into AQPB070E
                (aqpb070etab,
                 aqpb070efec,
                 aqpb070esuc,
                 aqpb070eusr,
                 aqpb070ecoe,
                 aqpb070emsge,
                 aqpb070efcr,
                 aqpb070ehcr,
                 aqpb070ecta,
                 aqpb070eope)
              values
                ('AQPB095',
                 pn_ffin,
                 pc_sucurs,
                 substr(trim(pn_usuario), 1, 10),
                 lc_coderr,
                 lc_msgerr,
                 to_char(sysdate, 'DD/MM/YYYY'),
                 to_char(sysdate, 'HH24:MI:SS'),
                 ln_cta,
                 ln_ope);
              commit;
            exception
              when others then
                null;
            end;
          
        end;
      
      end loop;
    
    else
    
      for j in reporte_covid19() loop
      
        ln_cta := j.aocta;
        ln_ope := j.aooper;
      
        -- 1. Información de Plantilla
        begin
          -- Call the procedure
          pq_cr_reporte_fond19.sp_plantilla_fcovid(pn_cod   => j.pgcod,
                                                   pn_mod   => j.aomod,
                                                   pn_suc   => j.aosuc,
                                                   pn_mda   => j.aomda,
                                                   pn_pap   => j.aopap,
                                                   pn_cta   => j.aocta,
                                                   pn_ope   => j.aooper,
                                                   pn_sbo   => j.aosbop,
                                                   pn_top   => j.aotope,
                                                   pn_fecha => pn_ffin,
                                                   
                                                   pn_ncer  => lb_ncer,
                                                   pn_fdes  => lb_fdes,
                                                   pn_mon   => lb_mon,
                                                   pn_teac  => lb_teac,
                                                   pn_pgrac => lb_pgrac,
                                                   pn_finic => lb_finic,
                                                   pn_ffinc => lb_ffinc);
        
        exception
          when others then
            lb_ncer  := null;
            lb_fdes  := null;
            lb_mon   := 0;
            lb_teac  := 0;
            lb_pgrac := 0;
            lb_finic := null;
            lb_ffinc := null;
        end;
      
        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                 
        -- 16.1 Saldo Insoluto Real
      
        begin
          pq_cr_reporte_fond19_p2.sp_obtener_sald_insol2(pn_cod   => j.pgcod,
                                                         pn_mod   => j.aomod,
                                                         pn_suc   => j.aosuc,
                                                         pn_mda   => j.aomda,
                                                         pn_pap   => j.aopap,
                                                         pn_cta   => j.aocta,
                                                         pn_ope   => j.aooper,
                                                         pn_sbo   => j.aosbop,
                                                         pn_top   => j.aotope,
                                                         pn_fecha => pn_ffin,
                                                         pn_indi  => 4, -- COVID19
                                                         pn_stat  => j.aostat, --- jrodriguej 07.07.2021
                                                         pn_sald  => lc_sdoins);
        
        exception
          when others then
            lc_sdoins := 0;
        end;
        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
        lx_moneda := '';
        if j.aomda = 0 then
          lx_moneda := 'PEN';
        else
          lx_moneda := 'USD';
        end if;
        ---                                       
      
        begin
          insert into aqpb096
            (aqpb096usur,
             aqpb096pgcod,
             aqpb096mod,
             aqpb096suc,
             aqpb096mda,
             aqpb096pap,
             aqpb096cta,
             aqpb096ope,
             aqpb096sbop,
             aqpb096tope,
             aqpb096ndoc, -- 1. Numero Documento
             aqpb096ncer, -- 2. N° Certificado 
             aqpb096mone, -- 3. Moneda
             aqpb096sdoi, -- 4. Saldo Insoluto
             aqpb096mpre, -- 5. Monto Prestamo reprogramado
             aqpb096fproc, -- Fecha de procesamiento
             aqpb096stat,
             aqpb096fe99,
             aqpb096fcr,
             aqpb096hcr)
          
          values
            (pn_usuario,
             j.pgcod,
             j.aomod,
             j.aosuc,
             j.aomda,
             j.aopap,
             j.aocta,
             j.aooper, -- 57. Nro. de Operación  
             j.aosbop,
             j.aotope,
             
             j.pendoc, -- 1. Numero Documento
             lb_ncer, -- 2. N° Certificado 
             lx_moneda, -- 3. Moneda
             lc_sdoins, -- 4. Saldo insoluto
             lb_mon, -- 5. Monto Prestamo reprogramado     
             
             pn_ffin,
             j.aostat, -- Estado
             j.aofe99, -- Fecha de cancelacion
             to_char(sysdate, 'DD/MM/YYYY'), -- aqpb095fcr,
             to_char(sysdate, 'HH24:MI:SS') -- aqpb095hcr
             
             );
        
          commit;
        
        exception
          when others then
          
            lc_coderr := substr(trim(sqlcode), 1, 100);
            lc_msgerr := substr(trim(sqlerrm), 1, 1000);
          
            begin
              insert into AQPB070E
                (aqpb070etab,
                 aqpb070efec,
                 aqpb070esuc,
                 aqpb070eusr,
                 aqpb070ecoe,
                 aqpb070emsge,
                 aqpb070efcr,
                 aqpb070ehcr,
                 aqpb070ecta,
                 aqpb070eope)
              values
                ('AQPB096',
                 pn_ffin,
                 pc_sucurs,
                 substr(trim(pn_usuario), 1, 10),
                 lc_coderr,
                 lc_msgerr,
                 to_char(sysdate, 'DD/MM/YYYY'),
                 to_char(sysdate, 'HH24:MI:SS'),
                 ln_cta,
                 ln_ope);
              commit;
            exception
              when others then
                null;
            end;
          
        end;
      
      end loop;
    
      for z in verificar_rep_diario() loop
      
        ln_cta := z.cta;
        ln_ope := z.oper;
      
        begin
          select 'S'
            into lb_flag_vig
            from aqpb096 x
           where x.aqpb096usur = pn_usuario
             and x.aqpb096suc = pc_sucurs
             and x.aqpb096cta = z.cta
             and x.aqpb096ope = z.oper
             and x.aqpb096stat <> 99;
        exception
          when others then
            lb_flag_vig := 'N';
        end;
      
        begin
          if lb_flag_vig = 'S' then
            --- Hay vigente, borrar los no vigentes
          
            delete from aqpb096 x
             where x.aqpb096usur = pn_usuario
               and x.aqpb096suc = pc_sucurs
               and x.aqpb096cta = z.cta
               and x.aqpb096ope = z.oper
               and x.aqpb096stat = 99;
            commit;
          
          else
            --- Solo hay cancelados, dejar el crédito con máxima fecha de cancelación
            select max(x.aqpb096fe99)
              into lb_fmax_anu
              from aqpb096 x
             where x.aqpb096usur = pn_usuario
               and x.aqpb096suc = pc_sucurs
               and x.aqpb096cta = z.cta
               and x.aqpb096ope = z.oper
               and x.aqpb096stat = 99;
          
            delete from aqpb096 x
             where x.aqpb096usur = pn_usuario
               and x.aqpb096suc = pc_sucurs
               and x.aqpb096cta = z.cta
               and x.aqpb096ope = z.oper
               and x.aqpb096fe99 <> lb_fmax_anu
               and x.aqpb096stat = 99;
            commit;
          
          end if;
        
        exception
          when others then
          
            lc_coderr := substr(trim(sqlcode), 1, 100);
            lc_msgerr := substr(trim(sqlerrm), 1, 1000);
          
            begin
              insert into AQPB070E
                (aqpb070etab,
                 aqpb070efec,
                 aqpb070esuc,
                 aqpb070eusr,
                 aqpb070ecoe,
                 aqpb070emsge,
                 aqpb070efcr,
                 aqpb070ehcr,
                 aqpb070ecta,
                 aqpb070eope)
              values
                ('AQPB096',
                 pn_ffin,
                 pc_sucurs,
                 substr(trim(pn_usuario), 1, 10),
                 lc_coderr,
                 lc_msgerr,
                 to_char(sysdate, 'DD/MM/YYYY'),
                 to_char(sysdate, 'HH24:MI:SS'),
                 ln_cta,
                 ln_ope);
              commit;
            exception
              when others then
                null;
            end;
          
        end;
      
      end loop;
    
      --- Borrar registros iguales pasados
    
      if lc_flag_dia = 1 and pn_usuario <> 'BANTPROD' then
        begin
        
          for y in datos_diario() loop
          
            begin
              select f.aqpb096hsdoi
                into lc_sdo_ins
                from (select p.aqpb096hsdoi
                        from aqpb096h p
                       where p.aqpb096husur = y.aqpb096usur
                         and p.aqpb096hpgcod = y.aqpb096pgcod
                         and p.aqpb096hmod = y.aqpb096mod
                         and p.aqpb096hsuc = y.aqpb096suc
                         and p.aqpb096hmda = y.aqpb096mda
                         and p.aqpb096hpap = y.aqpb096pap
                         and p.aqpb096hcta = y.aqpb096cta
                         and p.aqpb096hope = y.aqpb096ope
                         and p.aqpb096hsbop = y.aqpb096sbop
                         and p.aqpb096htope = y.aqpb096tope
                         and p.aqpb096hfproc < pn_ffin
                       order by p.aqpb096hfproc desc) f
               where rownum = 1;
            
            exception
              when others then
                lc_sdo_ins := 0;
              
            end;
          
            -- Verificar si el saldo insoluto es igual al último detectado, Si = eliminar
            if lc_sdo_ins = y.aqpb096sdoi then
            
              delete from aqpb096 x
               where x.aqpb096usur = y.aqpb096usur
                 and x.aqpb096pgcod = y.aqpb096pgcod
                 and x.aqpb096mod = y.aqpb096mod
                 and x.aqpb096suc = y.aqpb096suc
                 and x.aqpb096mda = y.aqpb096mda
                 and x.aqpb096pap = y.aqpb096pap
                 and x.aqpb096cta = y.aqpb096cta
                 and x.aqpb096ope = y.aqpb096ope
                 and x.aqpb096sbop = y.aqpb096sbop
                 and x.aqpb096tope = y.aqpb096tope;
              commit;
            
            end if;
          
          end loop;
        
        end;
      end if;
    
    end if;
  
  exception
    when others then
    
      lc_coderr := substr(trim(sqlcode), 1, 100);
      lc_msgerr := substr(trim(sqlerrm), 1, 1000);
    
      begin
        insert into AQPB070E
          (aqpb070etab,
           aqpb070efec,
           aqpb070esuc,
           aqpb070eusr,
           aqpb070ecoe,
           aqpb070emsge,
           aqpb070efcr,
           aqpb070ehcr,
           aqpb070ecta,
           aqpb070eope)
        values
          ('AQPB095',
           pn_ffin,
           pc_sucurs,
           substr(trim(pn_usuario), 1, 10),
           lc_coderr,
           lc_msgerr,
           to_char(sysdate, 'DD/MM/YYYY'),
           to_char(sysdate, 'HH24:MI:SS'),
           ln_cta,
           ln_ope);
        commit;
      exception
        when others then
          null;
      end;
    
  end sp_reporte_covid19_r1;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

  procedure sp_guardar_historico(pn_usuario char,
                                 pn_ind     number,
                                 pn_fcorte  date) is
  
    pn_fcarga date;
    lc_coderr char(100);
    lc_msgerr char(1000);
  
  begin
  
    select t.pgfape into pn_fcarga from fst017 t where t.pgcod = 1;
  
    --begin
    case
      when pn_ind = 1 then
        -- REP. Semanal
      
        delete from aqpb095h t
         where t.aqpb095husur = pn_usuario
           and t.aqpb095hfproc = pn_fcorte;
        commit;
      
        begin
        
          insert into aqpb095h
            (aqpb095husur,
             aqpb095hpgcod,
             aqpb095hmod,
             aqpb095hsuc,
             aqpb095hmda,
             aqpb095hpap,
             aqpb095hcta,
             aqpb095hope,
             aqpb095hsbop,
             aqpb095htope,
             aqpb095hncer,
             aqpb095hndoc,
             aqpb095hcsbs,
             aqpb095hrazn,
             aqpb095htcrep,
             aqpb095hpres,
             aqpb095hmpre,
             aqpb095hsdoi,
             aqpb095hperi,
             aqpb095hncuo,
             aqpb095htea,
             aqpb095hpgra,
             aqpb095hfini,
             aqpb095hffin,
             aqpb095htcre,
             aqpb095hncre,
             aqpb095hfcla,
             aqpb095hcnom,
             aqpb095hccpp,
             aqpb095hcdef,
             aqpb095hcdud,
             aqpb095hcper,
             aqpb095hrest,
             aqpb095hteac,
             aqpb095hpgrac,
             aqpb095hfinic,
             aqpb095hffinc,
             aqpb095hfproc,
             aqpb095hstat,
             aqpb095hfe99,
             aqpb095hfcr,
             aqpb095hhcr,
             aqpb095hfvenui,
             aqpb095hfvenup,
             aqpb095hmor,
             aqpb095hndmor,
             aqpb095htdoc,
             aqpb095htprest,
             aqpb095hint,
             aqpb095hfrepr,
             aqpb095hmhonr,
             aqpb095hfhonr,
             aqpb095hchonr,
             aqpb095hsdocap,
             aqpb095hsdohon,
             aqpb095hcrehon,
             aqpb095hreg,
             aqpb095hnreg,
             aqpb095hnsuc,
             aqpb095hccong,
             aqpb095hesf,
             aqpb095hfcober,
             aqpb095hstatd,
             aqpb095hfstat,
             aqpb095htmora,
             aqpb095hciuu,
             aqpb095hacteco,
             aqpb095hfpag,
             aqpb095hgas,
             aqpb095hcuo,
             aqpb095hicv,
             aqpb095hpen,
             aqpb095hfclas,
             aqpb095hcnoms,
             aqpb095hccpps,
             aqpb095hcdefs,
             aqpb095hcduds,
             aqpb095hcpers,
             aqpb095hlrep,
             aqpb095hnrep,
             aqpb095hfrep,
             aqpb095hpfec,
             aqpb095hncuop,
             aqpb095hpgrap,
             aqpb095hpfinp,
             aqpb095hlrefin,
             aqpb095hfrefin,
             aqpb095hdcon,
             aqpb095hncon,
             aqpb095hmprep,
             aqpb095hfprep,
             aqpb095hfvenmor,
             aqpb095hase,
             aqpb095hccob,
             aqpb095hcren,
             aqpb095hcobr,
             aqpb095hchon,
             aqpb095htercio,
             aqpb095hsinsap,
            aqpb095hprpago,
            aqpb095hpagrea,
            aqpb095hpramrt,
            aqpb095hnrccor,
            aqpb095hnrccac,
            aqpb095hvulcpa,
            aqpb095hvcprve,
            aqpb095hfuclpr,
            aqpb095hintcom,
            aqpb095hintcov,
            aqpb095hintmor,
            aqpb095hpenali)
          --pn_fcorte,
            select x.aqpb095usur,
                   x.aqpb095pgcod,
                   x.aqpb095mod,
                   x.aqpb095suc,
                   x.aqpb095mda,
                   x.aqpb095pap,
                   x.aqpb095cta,
                   x.aqpb095ope,
                   x.aqpb095sbop,
                   x.aqpb095tope,
                   x.aqpb095ncer,
                   x.aqpb095ndoc,
                   x.aqpb095csbs,
                   x.aqpb095razn,
                   x.aqpb095tcrep,
                   x.aqpb095pres,
                   x.aqpb095mpre,
                   x.aqpb095sdoi,
                   x.aqpb095peri,
                   x.aqpb095ncuo,
                   x.aqpb095tea,
                   x.aqpb095pgra,
                   x.aqpb095fini,
                   x.aqpb095ffin,
                   x.aqpb095tcre,
                   x.aqpb095ncre,
                   x.aqpb095fcla,
                   x.aqpb095cnom,
                   x.aqpb095ccpp,
                   x.aqpb095cdef,
                   x.aqpb095cdud,
                   x.aqpb095cper,
                   x.aqpb095rest,
                   x.aqpb095teac,
                   x.aqpb095pgrac,
                   x.aqpb095finic,
                   x.aqpb095ffinc,
                   x.aqpb095fproc,
                   x.aqpb095stat,
                   x.aqpb095fe99,
                   x.aqpb095fcr,
                   x.aqpb095hcr,
                   x.aqpb095fvenui,
                   x.aqpb095fvenup,
                   x.aqpb095mor,
                   x.aqpb095ndmor,
                   x.aqpb095tdoc,
                   x.aqpb095tprest,
                   x.aqpb095int,
                   x.aqpb095frepr,
                   x.aqpb095mhonr,
                   x.aqpb095fhonr,
                   x.aqpb095chonr,
                   x.aqpb095sdocap,
                   x.aqpb095sdohon,
                   x.aqpb095crehon,
                   x.aqpb095reg,
                   x.aqpb095nreg,
                   x.aqpb095nsuc,
                   x.aqpb095ccong,
                   x.aqpb095esf,
                   x.aqpb095fcober,
                   x.aqpb095statd,
                   x.aqpb095fstat,
                   x.aqpb095tmora,
                   x.aqpb095ciuu,
                   x.aqpb095acteco,
                   x.aqpb095fpag,
                   x.aqpb095gas,
                   x.aqpb095cuo,
                   x.aqpb095icv,
                   x.aqpb095pen,
                   x.aqpb095fclas,
                   x.aqpb095cnoms,
                   x.aqpb095ccpps,
                   x.aqpb095cdefs,
                   x.aqpb095cduds,
                   x.aqpb095cpers,
                   x.aqpb095lrep,
                   x.aqpb095nrep,
                   x.aqpb095frep,
                   x.aqpb095pfec,
                   x.aqpb095ncuop,
                   x.aqpb095pgrap,
                   x.aqpb095pfinp,
                   x.aqpb095lrefin,
                   x.aqpb095frefin,
                   x.aqpb095dcon,
                   x.aqpb095ncon,
                   x.aqpb095mprep,
                   x.aqpb095fprep,
                   x.aqpb095fvenmor,
                   x.aqpb095ase,
                   x.aqpb095ccob,
                   x.aqpb095cren,
                   x.aqpb095cobr,
                   x.aqpb095chon,
                   x.aqpb095tercio,
                   x.aqpb095sinsap,
                    x.aqpb095prpago,
                    x.aqpb095pagrea,
                    x.aqpb095pramrt,
                    x.aqpb095nrccor,
                    x.aqpb095nrccac,
                    x.aqpb095vulcpa,
                    x.aqpb095vcprve,
                    x.aqpb095fuclpr,
                    x.aqpb095intcom,
                    x.aqpb095intcov,
                    x.aqpb095intmor,
                    x.aqpb095penali
              from aqpb095 x
             where x.aqpb095usur = pn_usuario;
          commit;
        
        exception
          when others then
          
            lc_coderr := sqlcode;
            lc_msgerr := trim(sqlerrm);
          
        end;
      
      when pn_ind = 2 then
        -- REP. Diario
      
        delete from aqpb096h t
         where t.aqpb096husur = pn_usuario
           and t.aqpb096hfproc = pn_fcorte;
        commit;
      
        begin
        
          insert into aqpb096h
            (aqpb096husur,
             aqpb096hpgcod,
             aqpb096hmod,
             aqpb096hsuc,
             aqpb096hmda,
             aqpb096hpap,
             aqpb096hcta,
             aqpb096hope,
             aqpb096hsbop,
             aqpb096htope,
             aqpb096hndoc,
             aqpb096hncer,
             aqpb096hmone,
             aqpb096hsdoi,
             aqpb096hmpre,
             aqpb096hfproc,
             aqpb096hstat,
             aqpb096hfe99,
             aqpb096hfcr,
             aqpb096hhcr)
          --pn_fcorte,
            select x.aqpb096usur,
                   x.aqpb096pgcod,
                   x.aqpb096mod,
                   x.aqpb096suc,
                   x.aqpb096mda,
                   x.aqpb096pap,
                   x.aqpb096cta,
                   x.aqpb096ope,
                   x.aqpb096sbop,
                   x.aqpb096tope,
                   x.aqpb096ndoc,
                   x.aqpb096ncer,
                   x.aqpb096mone,
                   x.aqpb096sdoi,
                   x.aqpb096mpre,
                   x.aqpb096fproc,
                   x.aqpb096stat,
                   x.aqpb096fe99,
                   x.aqpb096fcr,
                   x.aqpb096hcr
              from aqpb096 x
             where x.aqpb096usur = pn_usuario;
          commit;
        
        exception
          when others then
          
            lc_coderr := sqlcode;
            lc_msgerr := trim(sqlerrm);
          
        end;
      
    end case;
  
  end sp_guardar_historico;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure sp_insertar_cabecera(pn_pgcod   in number,
                                 pn_usuario in varchar2,
                                 pn_fecha   in date,
                                 pn_tiporep in number,
                                 pn_corr    out number,
                                 pn_flag    out varchar2) is
  
    lc_corr number;
  
  begin
  
    pn_flag := 'N';
    case
    
      when pn_tiporep = 4 then
        -- COVID19
      
        pn_flag := 'S';
      
        --- Obtener el correlativo
        select nvl(max(t.aqpb095acor), 0) + 1 into pn_corr from aqpb095a t;
      
        --- Reporte CRECER
        insert into aqpb095a
          (aqpb095acod,
           aqpb095afec,
           aqpb095acor,
           aqpb095aest,
           aqpb095ausr,
           aqpb095afcr,
           aqpb095ahcr)
        values
          (pn_pgcod,
           pn_fecha,
           pn_corr,
           'I', --INSERTAR
           pn_usuario,
           to_char(sysdate, 'DD/MM/YYYY'),
           to_char(sysdate, 'HH24:MI:SS'));
        commit;
      
    end case;
  
  end sp_insertar_cabecera;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  procedure sp_actualizar_cabecera(pn_pgcod   in number,
                                   pn_fecha   in date,
                                   pn_corr    in number,
                                   pn_usuario in varchar2,
                                   pn_tiporep in number,
                                   pn_estado  in varchar2,
                                   pn_flag    out varchar2) is
  
    pn_est char(1);
  
  begin
  
    pn_flag := 'N';
    case
    
      when pn_tiporep = 4 then
        ---COVID19
      
        pn_flag := 'S';
      
        --Actualización del detalle de la plantilla
        if pn_estado = 'D' then
        
          update aqpb095b t
             set t.aqpb095best = pn_estado,
                 t.aqpb095busd = pn_usuario,
                 t.aqpb095bfed = to_char(sysdate, 'DD/MM/YYYY'),
                 t.aqpb095bhed = to_char(sysdate, 'HH24:MI:SS')
          
           where t.aqpb095bcod = pn_pgcod
             and t.aqpb095bfec = pn_fecha
             and t.aqpb095bcor = pn_corr
             and t.aqpb095best <> 'D';
          commit;
        
        end if;
      
        update aqpb095a t
           set t.aqpb095aest = pn_estado,
               t.aqpb095ausd = pn_usuario,
               t.aqpb095afed = to_char(sysdate, 'DD/MM/YYYY'),
               t.aqpb095ahed = to_char(sysdate, 'HH24:MI:SS')
        
         where t.aqpb095acod = pn_pgcod
           and t.aqpb095afec = pn_fecha
           and t.aqpb095acor = pn_corr;
        commit;
      
    end case;
  
  end sp_actualizar_cabecera;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                 

  Function fn_cr_verifica_tarea(P_C_NOMJOB IN VARCHAR2,
                                P_C_HOSTNA IN VARCHAR2) return number is
    --2019.07.22 DCASTRO se implementaron schedulers para optimizar la carga, creacion guia de proceso para hostname
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
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                 

  Function fn_cr_verifica_tarea2(P_C_NOMJOB IN VARCHAR2,
                                 P_C_HOSTNA IN VARCHAR2,
                                 pn_paquete in varchar2,
                                 pn_proceso in varchar2,
                                 pn_usuario in varchar2) return number is
    --2019.07.22 DCASTRO se implementaron schedulers para optimizar la carga, creacion guia de proceso para hostname
    ln_numjob     number(9) := 0;
    lc_nomusr     varchar2(50);
    lc_pac_nombre varchar2(100);
  
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
      /*
      SELECT COUNT(1)
        INTO ln_numjob
        FROM dba_scheduler_jobs job
       WHERE owner = lc_nomusr
         AND job.job_name LIKE P_C_NOMJOB || '%';
       */
    
      lc_pac_nombre := trim(pn_paquete) || '.' || trim(pn_proceso);
    
      SELECT count(*)
        INTO ln_numjob
        FROM dba_jobs x
       WHERE x.schema_user = lc_nomusr -- 'BANTPROD'
         AND x.what LIKE '%' || trim(lc_pac_nombre) || '%'
         AND x.what LIKE '%' || trim(pn_usuario) || '%';
    
    end;
  
    return ln_numjob;
  end fn_cr_verifica_tarea2;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_cr_sch_fcovid19(pd_fecpro  in date,
                               pn_usuario in varchar2,
                               pn_tip_rep in number, --- 1: Semanal, 2: Diario
                               pn_flag    out varchar2) is
  
    ln_ini      number;
    lc_variable varchar2(4000);
    ln_job      number := 0;
    lc_fecpro   char(10);
    ld_finmes   date;
    lc_hostname varchar2(64);
  
    pi_vc2_nomjob varchar2(65);
    lc_prefjob    varchar2(64);
    ln_numjob     number(9) := 0;
    lc_user       varchar(5);
    lc_prefijo    varchar(10);
    lc_flag       varchar2(1);
    x             number;
    lc_fecha      date;
    lb_njobs      number(3);
  
    lc_paquete    varchar2(50);
    lc_proceso    varchar2(50);
    job_id        number;
    lc_nomusr     varchar2(50);
    lc_pac_nombre varchar2(100);
  
    cursor sucursal is
      select *
        from fst001
       where pgcod = 1
         and sucurs < 800
      --or sucurs >= 900
      ;
  
  begin
  
    begin
      select TRIM(TP1DESC)
        INTO lc_nomusr
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10847
         and tp1corr1 = 999; ---2019.07.22 guia de proceso para hostname
    end;
  
    select x.tp1nro1
      into lb_njobs
      from fst198 x
     where x.TP1COD = 1
       and x.TP1COD1 = 11144
       and x.TP1CORR1 = 10
       and x.tp1corr2 = 2
       and x.tp1corr3 = 3;
  
    begin
      select host_name into lc_hostname from v$instance;
    end;
  
    pn_flag := 'N';
  
    -- Eliminación del registro por usuario
    if pn_tip_rep = 1 then
      delete from aqpb095 t where trim(t.aqpb095usur) = pn_usuario;
      commit;
    else
      delete from aqpb096 t where trim(t.aqpb096usur) = pn_usuario;
      commit;
    end if;
  
    -- 2. Carga de tabla
    begin
      -- Call the procedure
      pq_cr_reporte_fond19.sp_sch_aqpb070a_carga(pd_fecpro  => pd_fecpro,
                                                 pn_usuario => pn_usuario,
                                                 pn_indi    => 1); --- COVID-19
    end;
  
    lc_user       := substr(pn_usuario, 1, 5);
    lc_prefijo    := 'COV19' || lc_user;
    lc_paquete    := 'pq_cr_reporte_fond19';
    lc_proceso    := 'sp_reporte_covid19_r1';
    lc_pac_nombre := trim(lc_paquete) || '.' || trim(lc_proceso);
  
    lc_fecpro := to_char(pd_fecpro, 'RRRR.MM.DD');
  
    ---carga diaria
    for i in sucursal loop
      ln_ini := i.sucurs;
      ln_job := ln_job + 1;
      --lc_prefjob    := 'REA_REP_1';
      lc_prefjob    := lc_prefijo;
      pi_vc2_nomjob := lc_prefjob || to_char(pd_fecpro, 'ddmmrrrr') ||
                       lpad(ln_ini, 3, '0'); ---ln_job
      lc_variable   := 'begin ' ||
                       '  pq_cr_reporte_fond19.sp_reporte_covid19_r1( TO_DATE(''' ||
                       lc_fecpro || ''',''RRRR.MM.DD''),' || ln_ini ||
                       ',''' || pn_usuario || ''',' || pn_tip_rep || ' );' ||
                       ' End;';
    
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
      
        dbms_job.submit(job_id,
                        what      => lc_variable,
                        next_date => sysdate,
                        interval  => null,
                        no_parse  => false,
                      --  instance  => 2, --24/10/2023
                        instance  => 1,
                        force     => false);
      
      Else
      
        dbms_job.submit(job_id,
                        what      => lc_variable,
                        next_date => sysdate,
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      
      End If;
      commit;
    
      SELECT count(*)
        INTO x
        FROM dba_jobs x
       WHERE x.schema_user = lc_nomusr -- 'BANTPROD'
         AND x.what LIKE '%' || trim(lc_pac_nombre) || '%'
         AND x.what LIKE '%' || trim(pn_usuario) || '%';
    
      while x = lb_njobs loop
        --- Parametrizar              BANTPROD
        SELECT count(*)
          INTO x
          FROM dba_jobs x
         WHERE x.schema_user = lc_nomusr -- 'BANTPROD'
           AND x.what LIKE '%' || trim(lc_pac_nombre) || '%'
           AND x.what LIKE '%' || trim(pn_usuario) || '%';
      
      end loop;
    
      INSERT INTO Tab_jobs
        (c_codage, n_Numer1, c_detjob) --VARCHAR(10),NUMBER,VARCHAR(500)
      VALUES
      --('REA_REP_1', ln_ini, lc_variable);
        (lc_prefijo, ln_ini, lc_variable);
      COMMIT;
    
    end loop;
  
    ln_numjob := pq_cr_reporte_fond19.fn_cr_verifica_tarea2(lc_prefjob,
                                                            lc_hostname,
                                                            lc_paquete,
                                                            lc_proceso,
                                                            pn_usuario);
  
    While ln_numjob > 0 loop
      ln_numjob := pq_cr_reporte_fond19.fn_cr_verifica_tarea2(lc_prefjob,
                                                              lc_hostname,
                                                              lc_paquete,
                                                              lc_proceso,
                                                              pn_usuario);
    End loop;
  
    -- Registro de histórico   
    pq_cr_reporte_fond19.sp_guardar_historico(pn_usuario,
                                              pn_tip_rep,
                                              pd_fecpro);
  
    pn_flag := 'S';
  
  exception
    when others then
      pn_flag := 'N';
  end sp_cr_sch_fcovid19;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_plantilla_fcovid(pn_cod   in number,
                                pn_mod   in number,
                                pn_suc   in number,
                                pn_mda   in number,
                                pn_pap   in number,
                                pn_cta   in number,
                                pn_ope   in number,
                                pn_sbo   in number,
                                pn_top   in number,
                                pn_fecha in date,
                                pn_ncer  out aqpb095b.aqpb095bncer%type,
                                pn_fdes  out aqpb095b.aqpb095bfdes%type,
                                pn_mon   out aqpb095b.aqpb095bmon%type,
                                
                                pn_teac  out aqpb095b.aqpb095btea%type,
                                pn_pgrac out aqpb095b.aqpb095bpgra%type,
                                pn_finic out aqpb095b.aqpb095bfini%type,
                                pn_ffinc out aqpb095b.aqpb095bffin%type) is
  
  begin
  
    begin
    
      select g.aqpb095bncer,
             g.aqpb095bfdes,
             g.aqpb095bmon,
             g.aqpb095btea,
             g.aqpb095bpgra,
             g.aqpb095bfini,
             g.aqpb095bffin
        into pn_ncer,
             pn_fdes,
             pn_mon,
             pn_teac,
             pn_pgrac,
             pn_finic,
             pn_ffinc
        from (select t.aqpb095bncer,
                     t.aqpb095bfdes,
                     t.aqpb095bmon,
                     t.aqpb095btea,
                     t.aqpb095bpgra,
                     t.aqpb095bfini,
                     t.aqpb095bffin
                from aqpb095b t
               where t.aqpb095bcod = pn_cod
                 and t.aqpb095bmod = pn_mod
                 and t.aqpb095bsuc = pn_suc
                 and t.aqpb095bmda = pn_mda
                 and t.aqpb095bpap = pn_pap
                 and t.aqpb095bcta = pn_cta
                 and t.aqpb095bope = pn_ope
                    --and t.aqpb073bsbo = pn_sbo
                    --and t.aqpb095btop = pn_top
                 and t.aqpb095bfec <= pn_fecha
                 and t.aqpb095best <> 'D'
               order by t.aqpb095bfec desc, t.aqpb095bcor desc) g
       where rownum = 1;
    
    exception
      when others then
        pn_ncer  := null;
        pn_fdes  := null;
        pn_mon   := null;
        pn_teac  := null;
        pn_pgrac := null;
        pn_finic := null;
        pn_ffinc := null;
    end;
  
  end sp_plantilla_fcovid;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_plantilla_fcovid2(pn_cod   in number,
                                 pn_mod   in number,
                                 pn_suc   in number,
                                 pn_mda   in number,
                                 pn_pap   in number,
                                 pn_cta   in number,
                                 pn_ope   in number,
                                 pn_sbo   in number,
                                 pn_top   in number,
                                 pn_fecha in date,
                                 pn_ncer  out aqpb095b.aqpb095bncer%type,
                                 pn_fdes  out aqpb095b.aqpb095bfdes%type,
                                 pn_mon   out aqpb095b.aqpb095bmon%type,
                                 
                                 pn_teac  out aqpb095b.aqpb095btea%type,
                                 pn_pgrac out aqpb095b.aqpb095bpgra%type,
                                 pn_finic out aqpb095b.aqpb095bfini%type,
                                 pn_ffinc out aqpb095b.aqpb095bffin%type,
                                 pn_prcof out aqpb095b.aqpb095bprcof%type,
                                 pn_ccob  out aqpb095b.aqpb095bccob%type,
                                 pn_cren  out aqpb095b.aqpb095bcren%type,
                                 pn_cobr  out aqpb095b.aqpb095bcobr%type,
                                 pn_chon  out aqpb095b.aqpb095bchon%type) is
  
  begin
  
    begin
    
      select g.aqpb095bncer,
             g.aqpb095bfdes,
             g.aqpb095bmon,
             g.aqpb095btea,
             g.aqpb095bpgra,
             g.aqpb095bfini,
             g.aqpb095bffin,
             g.aqpb095bprcof,
             g.aqpb095bccob,
             g.aqpb095bcren,
             g.aqpb095bcobr,
             g.aqpb095bchon
        into pn_ncer,
             pn_fdes,
             pn_mon,
             pn_teac,
             pn_pgrac,
             pn_finic,
             pn_ffinc,
             pn_prcof,
             pn_ccob,
             pn_cren,
             pn_cobr,
             pn_chon
        from (select t.aqpb095bncer,
                     t.aqpb095bfdes,
                     t.aqpb095bmon,
                     t.aqpb095btea,
                     t.aqpb095bpgra,
                     t.aqpb095bfini,
                     t.aqpb095bffin,
                     t.aqpb095bprcof,
                     t.aqpb095bccob,
                     t.aqpb095bcren,
                     t.aqpb095bcobr,
                     t.aqpb095bchon
                from aqpb095b t
               where t.aqpb095bcod = pn_cod
                    --and t.aqpb095bmod = pn_mod
                    --and t.aqpb095bsuc = pn_suc
                 and t.aqpb095bmda = pn_mda
                 and t.aqpb095bpap = pn_pap
                 and t.aqpb095bcta = pn_cta
                 and t.aqpb095bope = pn_ope
                    --and t.aqpb073bsbo = pn_sbo
                    --and t.aqpb095btop = pn_top
                 and t.aqpb095bfec <= pn_fecha
                 and t.aqpb095best <> 'D'
               order by t.aqpb095bfec desc, t.aqpb095bcor desc) g
       where rownum = 1;
    
    exception
      when others then
        pn_ncer  := null;
        pn_fdes  := null;
        pn_mon   := null;
        pn_teac  := null;
        pn_pgrac := null;
        pn_finic := null;
        pn_ffinc := null;
    end;
  
  end sp_plantilla_fcovid2;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --     
  procedure sp_obtener_calf_caja(pn_cod   in number,
                                 pn_mod   in number,
                                 pn_suc   in number,
                                 pn_mda   in number,
                                 pn_pap   in number,
                                 pn_cta   in number,
                                 pn_ope   in number,
                                 pn_sbo   in number,
                                 pn_top   in number,
                                 pn_est   in number,
                                 pn_fecha in date,
                                 
                                 pn_calif0a out aqpb067.aqpb067cnoma%type,
                                 pn_calif1a out aqpb067.aqpb067ccppa%type,
                                 pn_calif2a out aqpb067.aqpb067cdefa%type,
                                 pn_calif3a out aqpb067.aqpb067cduda%type,
                                 pn_calif4a out aqpb067.aqpb067cpera%type,
                                 pn_deccaj  out date) is
  
    lc_dcla number(14, 2);
    lc_tcla number(4);
    lc_ncla varchar2(10);
  
    lc_distrib   char(15);
    lc_fecha_fin date;
    lc_fecha_pro date;
  
  begin
  
    begin
    
      -- 0: NORMAL
      -- 1: CPP
      -- 2: DEFICIENTE
      -- 3: DUDOSO
      -- 4: PÉRDIDA
    
      lc_fecha_pro := last_day(add_months(trunc(pn_fecha), -1));
    
      select f.catcateg
        into lc_distrib
        from fsd212 f
       where f.catcta = pn_cta
         and f.catfchdes = lc_fecha_pro
         and f.catcod = 4;
    
      lc_tcla := to_number(substr(lc_distrib, 1, 1));
    
      case
        when lc_tcla = 0 then
          -- 0: Normal
          --lc_ncla := 'NORMAL';
          pn_calif0a := 100;
          pn_calif1a := 0;
          pn_calif2a := 0;
          pn_calif3a := 0;
          pn_calif4a := 0;
        
        when lc_tcla = 1 then
          -- 1: CPP
          --lc_ncla := 'CPP';
          pn_calif0a := 0;
          pn_calif1a := 100;
          pn_calif2a := 0;
          pn_calif3a := 0;
          pn_calif4a := 0;
        when lc_tcla = 2 then
          -- 2: Deficiente
          --lc_ncla := 'Deficiente';
          pn_calif0a := 0;
          pn_calif1a := 0;
          pn_calif2a := 100;
          pn_calif3a := 0;
          pn_calif4a := 0;
        when lc_tcla = 3 then
          -- 3: Dudoso
          --lc_ncla := 'Dudoso';
          pn_calif0a := 0;
          pn_calif1a := 0;
          pn_calif2a := 0;
          pn_calif3a := 100;
          pn_calif4a := 0;
        when lc_tcla = 4 then
          -- 4: Pérdida   
          --lc_ncla := 'PÉRDIDA';
          pn_calif0a := 0;
          pn_calif1a := 0;
          pn_calif2a := 0;
          pn_calif3a := 0;
          pn_calif4a := 100;
      end case;
    
    exception
      when others then
      
        pn_calif0a := 100;
        pn_calif1a := 0;
        pn_calif2a := 0;
        pn_calif3a := 0;
        pn_calif4a := 0;
      
    end;
  
    pn_deccaj := lc_fecha_pro;
    --pn_dcla := lc_dcla;
    --pn_ncla := lc_ncla;
  
  end sp_obtener_calf_caja;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_sch_aqpb070a_carga(pd_fecpro  in date,
                                  pn_usuario in char,
                                  pn_indi    in number) is
    --2019.07.22 DCASTRO se implementaron schedulers para optimizar la carga, creacion guia de proceso para hostname
  
    ln_ini        number;
    lc_variable   varchar2(1000);
    ln_job        number := 0;
    lc_fecpro     char(10);
    ld_finmes     date;
    lc_hostname   varchar2(64);
    pi_vc2_nomjob varchar2(65);
    lc_prefjob    varchar2(64);
    ln_numjob     number(9) := 0;
    lc_fecha_sis  date;
    lc_prefijo    varchar(10);
    lc_user       varchar(5);
    job_id        number;
    lc_paquete    varchar2(50);
    lc_proceso    varchar2(50);
    lc_nomusr     varchar2(50);
    lc_pac_nombre varchar2(100);
    x             number;
    lb_njobs      number(9);
    cursor sucursal is
      select *
        from fst001
       where pgcod = 1
         and sucurs < 800
          or sucurs >= 900;
  
  begin
  
    begin
      select host_name into lc_hostname from v$instance;
    end;
  
    begin
      select TRIM(TP1DESC)
        INTO lc_nomusr
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10847
         and tp1corr1 = 999; ---2019.07.22 guia de proceso para hostname
    end;
  
    lc_fecpro := to_char(pd_fecpro, 'RRRR.MM.DD');
  
    --ld_finmes := last_Day(pd_fecpro);
  
    select x.pgfape into lc_fecha_sis from fst017 x where x.pgcod = 1;
  
    --antes de la carga eliminar DATA
    --delete from JAQL600 where JAQL600FPRO = pd_fecpro;
    --commit;
  
    if pd_fecpro <> lc_fecha_sis then
    
      delete from aqpb070a x
       where trim(x.aqpb070ausur) = trim(pn_usuario)
      --and x.AQPB070Atabla = 'REACTIVA'
      --and x.aqpb070aemp = 1
      ;
      --and x.aqpb070asuc = pc_sucurs;
      commit;
    
      ---carga diaria
      --- pn_indi
      case pn_indi
        when 1 then
          --- REACTIVA
          --null;
        
          -- Acondicionamiento nombre
          lc_user    := substr(pn_usuario, 1, 5);
          lc_prefijo := 'COVID' || lc_user;
          lc_paquete := 'pq_cr_reporte_fond19';
          lc_proceso := 'sp_cr_carga_temp_fcovid';
          lc_pac_nombre := trim(lc_paquete) || '.' || trim(lc_proceso);
          for i in sucursal loop
            ln_ini        := i.sucurs;
            ln_job        := ln_job + 1;
            lc_prefjob    := lc_prefijo;
            pi_vc2_nomjob := lc_prefjob || to_char(pd_fecpro, 'ddmmrrrr') ||
                             lpad(ln_ini, 3, '0'); ---ln_job
          
            lc_variable := 'begin ' ||
                           '  pq_cr_reporte_fond19.sp_cr_carga_temp_fcovid(''' ||
                           pn_usuario || ''',
                       ' || ln_ini ||
                           ',TO_DATE(''' || lc_fecpro ||
                           ''',''RRRR.MM.DD'') );' || ' End;';
          
            IF SYS.FN_BD_ISRAC = 'TRUE' THEN
            
              dbms_job.submit(job_id,
                              what      => lc_variable,
                              next_date => sysdate,
                              interval  => null,
                              no_parse  => false,
                              -- instance  => 2, 16/01/2024
                              instance  => 1,
                              force     => false);
            
            Else
            
              dbms_job.submit(job_id,
                              what      => lc_variable,
                              next_date => sysdate,
                              interval  => null,
                              no_parse  => false,
                              force     => false);
            
            End If;
            commit;
            
            SELECT count(*)
              INTO x
              FROM dba_jobs x
             WHERE x.schema_user = lc_nomusr -- 'BANTPROD'
               AND x.what LIKE '%' || trim(lc_pac_nombre) || '%'
               AND x.what LIKE '%' || trim(pn_usuario) || '%';
          
            while x = lb_njobs loop
              --- Parametrizar              BANTPROD
              SELECT count(*)
                INTO x
                FROM dba_jobs x
               WHERE x.schema_user = lc_nomusr -- 'BANTPROD'
                 AND x.what LIKE '%' || trim(lc_pac_nombre) || '%'
                 AND x.what LIKE '%' || trim(pn_usuario) || '%';
            
            end loop;
          
            INSERT INTO Tab_jobs
              (c_codage, n_Numer1, c_detjob)
            VALUES
              ('TEMP_095', ln_ini, lc_variable);
            COMMIT;
          
          end loop;
        
      end case;
    
      ln_numjob := fn_cr_verifica_tarea2(lc_prefjob,
                                         lc_hostname,
                                         lc_paquete,
                                         lc_proceso,
                                         pn_usuario);
    
      While ln_numjob > 0 loop
        ln_numjob := fn_cr_verifica_tarea2(lc_prefjob,
                                           lc_hostname,
                                           lc_paquete,
                                           lc_proceso,
                                           pn_usuario);
      End loop;
    
      -- 3. Aplicar estadisticas
      BEGIN
        DBMS_STATS.GATHER_TABLE_STATS(OWNNAME          => lc_nomusr, --'DESA021118',--'BANTPROD',
                                      TABNAME          => 'AQPB070A',
                                      DEGREE           => 8,
                                      GRANULARITY      => 'ALL',
                                      ESTIMATE_PERCENT => 100,
                                      CASCADE          => TRUE);
      END;
    
    end if;
  
  end sp_sch_aqpb070a_carga;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
  procedure sp_cr_carga_temp_fcovid(pc_usuario in varchar2,
                                    pc_sucurs  in varchar2,
                                    pc_fecpro  in date) is
  
  begin
  
    delete from aqpb070a x
     where trim(x.aqpb070ausur) = pc_usuario
          --and x.AQPB070Atabla = 'REACTIVA'
       and x.aqpb070aemp = 1
       and x.aqpb070asuc = pc_sucurs;
    commit;
  
    insert into aqpb070a
      (aqpb070ausur,
       --aqpb070atabla,
       aqpb070aemp,
       aqpb070asuc,
       aqpb070arubr,
       aqpb070amda,
       aqpb070apap,
       aqpb070acta,
       aqpb070aoper,
       aqpb070asbop,
       aqpb070atop,
       aqpb070afech,
       aqpb070atit,
       aqpb070acap,
       aqpb070apzo,
       aqpb070asist,
       aqpb070amod,
       aqpb070afvto,
       aqpb070afval,
       aqpb070aplaz,
       aqpb070attasa,
       aqpb070atasa,
       aqpb070aclta,
       aqpb070atdia,
       aqpb070atano,
       aqpb070aresi,
       aqpb070acate,
       aqpb070aacti,
       aqpb070aprod,
       aqpb070aticu,
       aqpb070atipp,
       aqpb070afatr,
       aqpb070asdor,
       aqpb070asdmn,
       aqpb070asdus,
       aqpb070asdmo,
       aqpb070aint,
       aqpb070aprev,
       aqpb070agpo,
       AQPB070Afcr,
       AQPB070Ahcr)
      select distinct pc_usuario,
                      --'REACTIVA',
                      j.bcemp,
                      j.bcsuc,
                      j.bcrubr,
                      j.bcmda,
                      j.bcpap,
                      j.bccta,
                      j.bcoper,
                      j.bcsbop,
                      j.bctop,
                      j.bcfech,
                      j.bctit,
                      j.bccap,
                      j.bcpzo,
                      j.bcsist,
                      j.bcmod,
                      j.bcfvto,
                      j.bcfval,
                      j.bcplaz,
                      j.bcttasa,
                      j.bctasa,
                      j.bcclta,
                      j.bctdia,
                      j.bctano,
                      j.bcresi,
                      j.bccate,
                      j.bcacti,
                      j.bcprod,
                      j.bcticu,
                      j.bctipp,
                      j.bcfatr,
                      j.bcsdor,
                      j.bcsdmn,
                      j.bcsdus,
                      j.bcsdmo,
                      j.bcint,
                      j.bcprev,
                      j.bcgpo,
                      to_char(sysdate, 'DD/MM/YYYY'),
                      to_char(sysdate, 'HH24:MI:SS')
        from fsh012 j,
             (select distinct u.aqpb095bcod,
                              u.aqpb095bmod,
                              u.aqpb095bsuc,
                              u.aqpb095bmda,
                              u.aqpb095bpap,
                              u.aqpb095bcta,
                              u.aqpb095bope,
                              u.aqpb095bsbo,
                              u.aqpb095btop
                from aqpb095b u
               where u.aqpb095bcod = 1
                 and u.aqpb095bfec <= pc_fecpro
                 and u.aqpb095best <> 'D') x,
             fsd014 h
       where j.bcemp = 1
         and j.bcsuc = pc_sucurs
         and j.bcfech = pc_fecpro
         and j.bcemp = x.aqpb095bcod
         and j.bcrubr = h.rubro -- jrodriguej 28.06.2021
         and j.bcmod = x.aqpb095bmod
            --and j.bcsuc = x.aqpb095bsuc
         and j.bcmda = x.aqpb095bmda
         and j.bcpap = x.aqpb095bpap
         and j.bccta = x.aqpb095bcta
         and j.bcoper = x.aqpb095bope
            --and j.bcsbop = x.aqpb073bsbo
            --and j.bctop = x.aqpb095btop
         and j.bcmod in (select h.modulo
                           from fst111 h
                          where h.dscod = 50
                            and h.modulo not in (29, 120, 144))
         and h.pcnivc in (select modulo
                            from fst111
                           where dscod = 50
                             and modulo not in (29, 120, 144))
         and h.pcimpu = 'S';
    commit;
  
  end sp_cr_carga_temp_fcovid;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_anulacion_individual(pn_pgcod   in number,
                                    pn_fecha   in date,
                                    pn_corr    in number,
                                    pn_usuario in varchar2,
                                    pn_tiporep in number,
                                    pn_estado  in varchar2,
                                    pn_flag    out varchar2) is
  
    pn_est char(1);
  
  begin
  
    pn_flag := 'N';
    case
    
      when pn_tiporep = 4 then
        ---COVID19
      
        pn_flag := 'S';
      
        select x.aqpb095aest
          into pn_est
          from aqpb095a x
         where x.aqpb095acod = pn_pgcod
           and x.aqpb095afec = pn_fecha
           and x.aqpb095acor = pn_corr;
      
        --Actualización de la cabecera principal
        if pn_est = 'G' then
        
          update aqpb095a t
             set --t.aqpb065aest = pn_estado,
                 t.aqpb095ausd = pn_usuario,
                 t.aqpb095afed = to_char(sysdate, 'DD/MM/YYYY'),
                 t.aqpb095ahed = to_char(sysdate, 'HH24:MI:SS')
          
           where t.aqpb095acod = pn_pgcod
             and t.aqpb095afec = pn_fecha
             and t.aqpb095acor = pn_corr;
          commit;
        
        else
        
          update aqpb095a t
             set t.aqpb095aest = pn_estado,
                 t.aqpb095ausd = pn_usuario,
                 t.aqpb095afed = to_char(sysdate, 'DD/MM/YYYY'),
                 t.aqpb095ahed = to_char(sysdate, 'HH24:MI:SS')
          
           where t.aqpb095acod = pn_pgcod
             and t.aqpb095afec = pn_fecha
             and t.aqpb095acor = pn_corr;
        
          commit;
        end if;
      
        commit;
      
    end case;
  
  end sp_anulacion_individual;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_cr_file_covid19_txt(pd_fecpro  in date,
                                   pd_tip_rep in number, --- 1: Semanal, 2: Diario
                                   pd_usuario in varchar2,
                                   pd_rpta    out varchar2,
                                   lc_nombre  out varchar2) is
    fhandle utl_file.file_type;
    --lc_nombre varchar2(100);
    lc_ruc   varchar2(15);
    lc_fecha varchar2(10);
    --lc_cadena varchar2(200);
    lc_corr   varchar2(10);
    lc_pgcod  number := 1;
    lc_fecpro date;
  
    cursor cur_creditos(pc_usuario varchar2) is
      select t.aqpb095usur,
             t.aqpb095pgcod,
             t.aqpb095mod,
             t.aqpb095suc,
             t.aqpb095mda,
             t.aqpb095pap,
             t.aqpb095cta,
             t.aqpb095ope,
             t.aqpb095sbop,
             t.aqpb095tope,
             t.aqpb095ncer,
             t.aqpb095ndoc,
             t.aqpb095csbs,
             t.aqpb095razn,
             t.aqpb095tcrep,
             t.aqpb095pres,
             t.aqpb095mpre,
             t.aqpb095sdoi,
             t.aqpb095peri,
             t.aqpb095ncuo,
             t.aqpb095tea,
             t.aqpb095pgra,
             t.aqpb095fini,
             t.aqpb095ffin,
             t.aqpb095tcre,
             t.aqpb095fcla,
             t.aqpb095cnom,
             t.aqpb095ccpp,
             t.aqpb095cdef,
             t.aqpb095cdud,
             t.aqpb095cper,
             t.aqpb095rest,
             t.aqpb095fproc,
             t.aqpb095stat,
             t.aqpb095fe99,
             t.aqpb095fcr,
             t.aqpb095hcr
        from aqpb095 t
      ---aqpa460 t
       where trim(t.aqpb095usur) = pc_usuario
       order by t.aqpb095suc, t.aqpb095cta, t.aqpb095ope;
  
    cursor cur_rep_diario(pc_usuario varchar2) is
      select t.aqpb096usur,
             t.aqpb096pgcod,
             t.aqpb096mod,
             t.aqpb096suc,
             t.aqpb096mda,
             t.aqpb096pap,
             t.aqpb096cta,
             t.aqpb096ope,
             t.aqpb096sbop,
             t.aqpb096tope,
             t.aqpb096ndoc,
             t.aqpb096ncer,
             t.aqpb096mone,
             t.aqpb096sdoi,
             t.aqpb096fproc,
             t.aqpb096stat,
             t.aqpb096fe99,
             t.aqpb096fcr,
             t.aqpb096hcr
        from aqpb096 t
       where trim(t.aqpb096usur) = pc_usuario
       order by t.aqpb096suc, t.aqpb096cta, t.aqpb096ope;
  
  begin
  
    lc_fecpro := pd_fecpro;
  
    -----=========================================================
    -- Simple PLSQL to open a file,
    -- write two lines into the file,
    -- and close the file
  
    -- Paso 1: Acondicionamiento de Fecha
    begin
      lc_fecha := to_char(lc_fecpro, 'yyyymmdd');
    end;
  
    -- Paso 3: Generación de archivo txt
    begin
    
      if pd_tip_rep = 1 then
        begin
          ---INICIO: GENERACIÓN TXT
          --aaaammdd- SALDOSEMANAL
          --lc_nombre := lc_ruc || '-BN-' || lc_fecha || '-' || lc_corr || '.txt';
          lc_nombre := lc_fecha || '-SALDOSEMANAL.txt';
        
          fhandle := utl_file.fopen('DT_COVID19_PRG', --'DT_FACT_SEE' DT_COVID19_PRG -- 'UTL_DIR'     -- File location
                                    lc_nombre, --'test_file.txt'  -- File name
                                    'w' -- Open mode: w = write.
                                    );
        
          for fdoc in cur_creditos(pd_usuario) loop
            --utl_file.put(fhandle, lc_nombre|| CHR(10));
            utl_file.put_line(fhandle,
                              --utl_file.put(fhandle, 
                              trim(to_char(fdoc.aqpb095ncer)) || '|' || --         N° CERTIFICADO 
                              trim(to_char(fdoc.aqpb095ndoc)) || '|' || --        NUMERO DOCUMENTO
                              trim(to_char(fdoc.aqpb095csbs)) || '|' || --        CODIGO DE CLIENTE SBS
                              trim(to_char(fdoc.aqpb095razn)) || '|' || --        RAZON SOCIAL
                              trim(to_char(fdoc.aqpb095tcrep)) || '|' || --       TIPO CREDITO PROGRAMA GARANTIAS-COVID19
                              trim(to_char(fdoc.aqpb095pres)) || '|' || --        N° PRÉSTAMO 
                              trim(to_char(fdoc.aqpb095mpre,
                                           'FM99999999990.00')) || '|' || --      MONTO PRESTAMO REPROGRAMADO
                              
                              trim(to_char(fdoc.aqpb095sdoi,
                                           'FM99999999990.00')) || '|' || --- SALDO INSOLUTO DEL PRESTAMO REPROGRAMADO
                              trim(to_char(fdoc.aqpb095peri)) || '|' || ---  PERIODO TOTAL DEL CRÉDITO REPROGRAMADO
                              trim(to_char(fdoc.aqpb095ncuo)) || '|' || ---  NUMERO CUOTAS PAGADAS CREDITO REPROGRAMADO
                              trim(to_char(fdoc.aqpb095tea,
                                           'FM99999999990.00')) || '|' || ---  TEA REPROGRAMADO % 
                              trim(to_char(fdoc.aqpb095pgra)) || '|' || ---  PERIODO DE GRACIA DEL CRÉDITO REPROGRAMADO
                              trim(to_char(fdoc.aqpb095fini, 'dd/mm/yyyy')) || '|' || ---  FECHA INICIO DE CRÉDITO REPROGRAMADO
                              trim(to_char(fdoc.aqpb095ffin, 'dd/mm/yyyy')) || '|' || ---  FECHA FIN DE CRÉDITO REPROGRAMADO
                              trim(to_char(fdoc.aqpb095tcre)) || '|' || ---  TIPO DE CREDITOS SBS
                              trim(to_char(fdoc.aqpb095fcla, 'dd/mm/yyyy')) || '|' || ---  FECHA DE CALIFICACIÓN ACTUALIZADA
                              trim(to_char(fdoc.aqpb095cnom,
                                           'FM99999999990.00')) || '|' || ---  CALIFICACION CREDITICIA NORMAL (%)
                              trim(to_char(fdoc.aqpb095ccpp,
                                           'FM99999999990.00')) || '|' || ---  CALIFICACION CREDITICIA CPP (%)
                              trim(to_char(fdoc.aqpb095cdef,
                                           'FM99999999990.00')) || '|' || ---  CALIFICACIÓN DEFICIENTE (%)
                              trim(to_char(fdoc.aqpb095cdud,
                                           'FM99999999990.00')) || '|' || ---  CALIFICACIÓN DUDOSO (%)
                              trim(to_char(fdoc.aqpb095cper,
                                           'FM99999999990.00')) || '|' || ---  CALIFICACIÓN PERDIDA (%)
                              trim(to_char(fdoc.aqpb095rest,
                                           'FM99999999990.00')) ---  % DE REDUCCIÓN ESTIMADO
                              );
          
          end loop;
        
          utl_file.fclose(fhandle);
          ---FIN: GENERACIÓN TXT    
        end;
      
      else
      
        begin
          ---INICIO: GENERACIÓN TXT
          --aaaammdd- SALDOSEMANAL
          --lc_nombre := lc_ruc || '-BN-' || lc_fecha || '-' || lc_corr || '.txt';
          lc_nombre := lc_fecha || '-SALDODIARIO.txt';
        
          fhandle := utl_file.fopen('DT_COVID19_PRG', --'DT_FACT_SEE' -- 'UTL_DIR'     -- File location
                                    lc_nombre, --'test_file.txt'  -- File name
                                    'w' -- Open mode: w = write.
                                    );
        
          for fdoc in cur_rep_diario(pd_usuario) loop
            --utl_file.put(fhandle, lc_nombre|| CHR(10));
            utl_file.put_line(fhandle,
                              --utl_file.put(fhandle, 
                              trim(to_char(fdoc.aqpb096ndoc)) || '|' || --  NRO DOCUMENTO
                              trim(to_char(fdoc.aqpb096ncer)) || '|' || --  NRO CERTIFICADO
                              trim(to_char(fdoc.aqpb096mone)) || '|' || --  MONEDA
                              trim(to_char(fdoc.aqpb096sdoi,
                                           'FM99999999990.00')) --  SALDO INSOLUTO
                              );
          
          end loop;
        
          utl_file.fclose(fhandle);
          ---FIN: GENERACIÓN TXT    
        end;
      
      end if;
    
      pd_rpta := 'S';
    
    exception
      WHEN NO_DATA_FOUND THEN
        pd_rpta := 'N';
    end;
  
    -----=========================================================
  
  exception
    when others then
      pd_rpta := 'N';
      --dbms_output.put_line('ERROR: ' || SQLCODE || ' - ' || SQLERRM);
  
  end sp_cr_file_covid19_txt;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --   
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_verificar_genrep(pn_tipo in number,
                                pn_user in varchar2,
                                pn_flag out varchar2) is
  
    lc_user    varchar(5);
    lc_prefijo varchar(10);
    lc_cont    number;
    lc_nomusr  varchar2(50);
  
  begin
  
    begin
      select TRIM(TP1DESC)
        INTO lc_nomusr
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10847
         and tp1corr1 = 999; ---2019.07.22 guia de proceso para hostname
    end;
  
    lc_user := substr(pn_user, 1, 5);
  
    --case
    --  when pn_tipo = 1 then
    ---Programa Garantías COVID
    lc_prefijo := 'COV19' || lc_user;
    --end case;
  
    SELECT count(*)
      into lc_cont
      FROM dba_scheduler_jobs x
     where x.owner = lc_nomusr
       and x.job_name like lc_prefijo || '%';
  
    if lc_cont > 0 then
      pn_flag := 'S';
    else
      pn_flag := 'N';
    end if;
  
  end sp_verificar_genrep;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_obtener_drefinanciac(pn_cod    in number,
                                    pn_mod    in number,
                                    pn_suc    in number,
                                    pn_mda    in number,
                                    pn_pap    in number,
                                    pn_cta    in number,
                                    pn_ope    in number,
                                    pn_sbo    in number,
                                    pn_top    in number,
                                    pd_fecha  in date,
                                    pc_lrefin out char,
                                    pd_frefin out date) is
  begin
    begin
      select 'S'
        into pc_lrefin
        from xwf700 t2
       inner join sng001 t1
          on t2.xwfempresa = t1.sng001emp
         and t2.xwfprcins = t1.sng001inst
       where t2.xwfempresa = 1
         and t2.xwfcuenta = pn_cta
         and t2.xwfoperacion = pn_ope
         and t1.sng001ori = 3
         and rownum <= 1;
    exception
      when no_data_found then
        begin
          select 'S'
            into pc_lrefin
            from fsh016 t3
           where t3.pgcod = 1
             and t3.hcta = pn_cta
             and (t3.HCMOD, t3.htran) in
                 (select tp1nro1, tp1nro2
                    from fst198 j
                   where j.TP1COD = 1
                     and j.TP1COD1 = 11144
                     and j.TP1CORR1 = 1
                     and j.tp1corr2 = 9)
             and rownum = 1;
        exception
          when others then
            pc_lrefin := 'N';
        end;
      when others then
        pc_lrefin := 'N';
    end;
    if pc_lrefin = 'S' then
      begin
        select max(hfval)
          into pd_frefin
          from fsh016 t3
         where t3.pgcod = 1
           and t3.hcta = pn_cta
           and t3.hoper = pn_ope
           and (t3.HCMOD, t3.htran) in
               (select tp1nro1, tp1nro2
                  from fst198 j
                 where j.TP1COD = 1
                   and j.TP1COD1 = 11144
                   and j.TP1CORR1 = 1
                   and j.tp1corr2 = 9);
      exception
        when others then
          null;
      end;
    else
      pd_frefin := null;
    end if;
  end sp_obtener_drefinanciac; 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --          
  procedure sp_obtener_sald_insol2_h99(pn_cod   in number,
                                   pn_mod   in number,
                                   pn_suc   in number,
                                   pn_mda   in number,
                                   pn_pap   in number,
                                   pn_cta   in number,
                                   pn_ope   in number,
                                   pn_sbo   in number,
                                   pn_top   in number,
                                   pn_fecha in date,
                                   pn_indi  in number,
                                   pn_stat  in number,
                                   pn_sald  out number) -- saldo insoluto
   is
    -- Saldo insoluto = monto_cofide - sumatorio de pagos
    -- pn_indi = 1 -----> REACTIVA
    -- pn_indi = 2 -----> FAE
    -- pn_indi = 3 -----> CRECER
  
    lx_mcof number(10, 2);
    lx_scap number(17, 2);
    lx_fdes date;
    lc_canc char(1);
    lx_fdia date;
    lx_mext number(17, 2);
    lx_shon number(17, 2);
    lx_shon_ext number(17, 2);
  begin
  
    select x.pgfape into lx_fdia from fst017 x where x.pgcod = 1;
    --validar estado de credito y trx para determinar si es 30/360
    lc_canc := 'N';
  
    begin
    
      select 'S'
        into lc_canc
        from fsd602 t
       where t.pgcod = pn_cod
         and t.ppmod = pn_mod
            --and t.ppsuc = pn_suc --  jrodriguej 28.06.2021
         and t.ppsuc in (select p.sucurs
                           from fst001 p
                          where p.pgcod = 1
                            and p.sucurs < 800)
         and t.ppmda = pn_mda
         and t.pppap = pn_pap
         and t.ppcta = pn_cta
         and t.ppoper = pn_ope
            -- and t.ppsbop = pn_sbo
            -- and t.pptope = pn_top
         and t.pp1stat in ('P', 'T')
         and t.pp1cap > 0
         and (t.d602mo, t.d602tr) in
             (select x.tp1nro1, x.tp1nro2
                from fst198 x
               where x.TP1COD = 1
                 and x.TP1COD1 = 11144
                 and x.TP1CORR1 = 1
                 and x.tp1corr2 = 4 --flag determina si trx se pertenece a cancelacion
                 and x.tp1corr3 > 0)
         and t.d602fc >= lx_fdes
         and t.d602fc <= pn_fecha
         and t.d602co = 'S';
    
    exception
      when others then
        lc_canc := 'N';
    end;
  
    if lc_canc = 'S' then
      pn_sald := 0;
    
    else
      -- a) monto COFIDE
      case
        when pn_indi = 4 then
          -- COVID19
        
          begin
          
            select x.aqpb095bfdes, x.aqpb095bmon
              into lx_fdes, lx_mcof
              from aqpb095b x
             where x.aqpb095bcod = pn_cod
               --and x.aqpb095bmod = pn_mod
                  --and x.aqpb095bsuc = pn_suc
               and x.aqpb095bmda = pn_mda
               and x.aqpb095bpap = pn_pap
               and x.aqpb095bcta = pn_cta
               and x.aqpb095bope = pn_ope
                  -- and x.aqpb065bsbo = pn_sbo
                  -- and x.aqpb065btop = pn_top
               and x.aqpb095bfec <= pn_fecha
               and x.aqpb095best <> 'D';
          
          exception
            when too_many_rows then
            
              begin
              
                select f.aqpb095bfdes, f.aqpb095bmon
                  into lx_fdes, lx_mcof
                  from (select x.aqpb095bfdes, x.aqpb095bmon
                          from aqpb095b x
                         where x.aqpb095bcod = pn_cod
                           --and x.aqpb095bmod = pn_mod
                              --and x.aqpb095bsuc = pn_suc
                           and x.aqpb095bmda = pn_mda
                           and x.aqpb095bpap = pn_pap
                           and x.aqpb095bcta = pn_cta
                           and x.aqpb095bope = pn_ope
                              -- and x.aqpb065bsbo = pn_sbo
                              -- and x.aqpb065btop = pn_top
                           and x.aqpb095bfec <= pn_fecha
                           and x.aqpb095best <> 'D'
                         order by x.aqpb095bfec desc) f
                 where rownum = 1;
              
              exception
                when others then
                  lx_fdes := null;
                  lx_mcof := 0;
              end;
            
            when others then
              lx_fdes := null;
          end;
        
      end case;
    
      --- b) Sumatoria de pagos
      --- Capital
      if lx_mcof <> 0 and pn_fecha >= lx_fdes then
        begin
        
          select nvl(sum(t.pp1cap), 0) --, nvl(sum(t.pp1int), 0)
            into lx_scap
          
            from fsd602 t
           where t.pgcod = pn_cod
             and t.ppmod = pn_mod
                --and t.ppsuc = pn_suc
             and t.ppmda = pn_mda
             and t.pppap = pn_pap
             and t.ppcta = pn_cta
             and t.ppoper = pn_ope
                -- and t.ppsbop = pn_sbo
                -- and t.pptope = pn_top
             and t.pp1stat in ('P', 'T')
             and t.pp1cap > 0
             and (t.d602mo, t.d602tr) in
                 (select x.tp1nro1, x.tp1nro2
                    from fst198 x
                   where x.TP1COD = 1
                     and x.TP1COD1 = 11144
                     and x.TP1CORR1 = 1
                     and x.tp1corr2 = 3
                     and x.tp1corr3 > 0)
             and t.d602fc >= lx_fdes
             and t.d602fc <= pn_fecha
             and t.d602co = 'S';
        
        exception
          when others then
            lx_scap := 0;
        end;
      
        if lx_fdia <> pn_fecha then
        
          begin
            select nvl(x.HCIMP1, 0) --,  x.* 
              into lx_mext
              from fsh016 x, fsh015 t
             where x.PGCOD = t.pgcod
               and x.HCMOD = t.hcmod
               and x.HSUCOR = t.hsucor
               and x.HTRAN = t.htran
               and x.HNREL = t.hnrel
               and x.HFCON = t.hfcon
               and x.PGCOD = pn_cod
               and x.HMODUL = pn_mod
               and x.HSUCUR = pn_suc
               and x.HMDA = pn_mda
               and x.HPAP = pn_pap
               and x.HCTA = pn_cta
               and x.HOPER = pn_ope
               and x.HSUBOP = pn_sbo
               and x.HTOPER = pn_top
               and --- HRUBRO: 1411, 1421, 1414, 1424, 1415,1425,1416, 1426
                   substr(x.HRUBRO, 1, 4) in
                   (1411, 1421, 1414, 1424, 1415, 1425, 1416, 1426)
               and x.HFCON > pn_fecha
               and x.HFVAL <= pn_fecha
               and (x.HCMOD, x.HTRAN) in
                   (select f.tp1nro1 + 500, f.tp1nro2 --obtener trx extornos
                      from fst198 f
                     where f.TP1COD = 1
                       and f.TP1COD1 = 11144
                       and f.TP1CORR1 = 1
                       and f.tp1corr2 = 3
                       and f.tp1corr3 > 0);
          exception
            when others then
              lx_mext := 0;
          end;
        
        else
          lx_mext := 0;
        end if;
        
        --pagos honramiento
        begin
          select sum(x.HCIMP1) into lx_shon
          from   fsh016 x, fsh015 t
             where x.PGCOD = t.pgcod
               and x.HCMOD = t.hcmod
               and x.HSUCOR = t.hsucor
               and x.HTRAN = t.htran
               and x.HNREL = t.hnrel
               and x.HFCON = t.hfcon
               and x.PGCOD = pn_cod
               --and x.HMODUL = 103
               --and x.HSUCUR = 20
               and x.HMDA = pn_mda
               and x.HPAP = pn_pap               
               and x.HCTA = pn_cta
               and x.HOPER = pn_ope
               --and x.HSUBOP = 3
               --and x.HTOPER = 109
               --and x.HFCON > '01/01/2022'
               and x.HFCON <= pn_fecha
               and (x.HCMOD, x.HTRAN,x.hcord) in (
                   select tp1nro1,tp1nro2,tp1nro3 
                   from fst198 
                   where tp1cod = 1 
                   and tp1cod1 = 11164 
                   and tp1corr1 = 4 
                   and tp1corr2 = 1 
                   and tp1corr3 >0);
         exception
            when others then
              lx_shon := 0;
        end;
        --extornos honramiento
        begin
          select sum(x.HCIMP1) into lx_shon_ext
          from   fsh016 x, fsh015 t
             where x.PGCOD = t.pgcod
               and x.HCMOD = t.hcmod
               and x.HSUCOR = t.hsucor
               and x.HTRAN = t.htran
               and x.HNREL = t.hnrel
               and x.HFCON = t.hfcon
               and x.PGCOD = pn_cod
               --and x.HMODUL = 103
               --and x.HSUCUR = 20
               and x.HMDA = pn_mda
               and x.HPAP = pn_pap               
               and x.HCTA = pn_cta
               and x.HOPER = pn_ope
               --and x.HSUBOP = 3
               --and x.HTOPER = 109
               --and x.HFCON > '01/01/2022'
               and x.HFCON <= pn_fecha
               and (x.HCMOD, x.HTRAN,x.hcord) in (
                   select tp1nro1,tp1nro2,tp1nro3 
                   from fst198 
                   where tp1cod = 1 
                   and tp1cod1 = 11164 
                   and tp1corr1 = 4 
                   and tp1corr2 = 2 
                   and tp1corr3 >0);
         exception
            when others then
              lx_shon_ext := 0;
        end;
      
        lx_scap := lx_scap + lx_mext + nvl(lx_shon,0) - nvl(lx_shon_ext,0);
      
      else
        lx_scap := 0;
      end if;
    
      if lx_mcof is null then
        lx_mcof := 0;
      end if;
    
      --- c) Resultado
      pn_sald := lx_mcof - lx_scap;
    
      if pn_sald < 0 then
        pn_sald := 0;
      end if;
    
    end if; 
    
  
  end sp_obtener_sald_insol2_h99;
  ------------------------------------------------------------------------------------
end pq_cr_reporte_fond19;
/

