create or replace package PQ_CR_VENTA is

  -- Author  : ABERNEDO
  -- Created : 21/07/2015 05:40:34 p.m.
  -- Purpose : 
  -- Modificación  : Karen Valencia
  -- Created : 06/05/2022
  -- Purpose :  Se adicionó para que busque el tipo de crédito en algunos casos que no estaba encontrando pero se revertió a como estaba anteriormente solo se hizo 
  ---porque se ejecutó sin bloquear un día antes y ejecutaron procesos de pase a judicial donde se cambió su clave de crpedito y por ende ya no lo encontraba en la FSH012 del día anterior con la clave actual

  Procedure Sp_Venta(P_C_DIGITO in varchar2, pd_fecpro in date);
  Procedure Sp_PreVenta(pn_nro in number);
  procedure sp_cr_venta_job(pn_gru IN number, pd_fecpro in date);
  Procedure Sp_Venta_II(pn_nro in number);
  Procedure Sp_cr_desem(pn_emp    in number,
                        pn_mod    in number,
                        pn_suc    in number,
                        pn_mda    in number,
                        pn_pap    in number,
                        pn_cta    in number,
                        pn_ope    in number,
                        pn_sbo    in number,
                        pn_top    in number,
                        ld_fecdes out date,
                        ln_aoimp  out number);
  Procedure Sp_cr_CredIni( /*pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                                                                                                                                                                                                               pn_pap in number,*/pn_cta  in number,
                          pn_ope  in number /*,pn_sbo in number,
                                                                                                                                                                                                               pn_top in number*/,
                          ln_empC out number,
                          ln_modC out number,
                          ln_sucC out number,
                          ln_mdaC out number,
                          ln_papC out number,
                          ln_ctaC out number,
                          ln_opeC out number,
                          ln_sboC out number,
                          ln_topC out number);
  Function Fn_cr_fecult(pn_emp in number,
                        pn_mod in number,
                        pn_suc in number,
                        pn_mda in number,
                        pn_pap in number,
                        pn_cta in number,
                        pn_ope in number,
                        pn_sbo in number,
                        pn_top in number,
                        pn_cti in number,
                        pn_opi in number) return date;
  function fn_cuotas_pagadas(pn_emp  in number,
                             pn_mod  in number,
                             pn_suc  in number,
                             pn_mda  in number,
                             pn_pap  in number,
                             pn_cta  in number,
                             pn_oper in number,
                             pn_sbop in number,
                             pn_top  in number) return number;
  Procedure Sp_cr_Direcciones(pn_pai in number,
                              pn_tdo in number,
                              pc_doc in char,
                              pn_tip in number,
                              pc_dir out char,
                              pv_ref out varchar2,
                              pc_dis out char);
  function fn_codsbs(pn_pepais in number,
                     pn_petdoc in number,
                     pc_pendoc in varchar2,
                     pn_cta    in number) return varchar2;
  function fn_actividad(pn_pais in number,
                        pn_tdoc in number,
                        pc_ndoc in char) return char;
  function fn_categoria(pn_emp    in number,
                        pn_cta    in number,
                        pn_codcat in number) return char;
  function fn_provisiones(pn_emp in number,
                          pn_mod in number,
                          pn_mda in number,
                          pn_pap in number,
                          pn_cta in number,
                          pn_ope in number,
                          pn_sbo in number,
                          pn_top in number) return number;
  function fn_refinanciado(pn_cta in number, pn_oper in number) return char;
  Procedure Sp_cr_fsd010(pn_emp     in number,
                         pn_mod     in number,
                         pn_suc     in number,
                         pn_mda     in number,
                         pn_pap     in number,
                         pn_cta     in number,
                         pn_ope     in number,
                         pn_sbo     in number,
                         pn_top     in number,
                         ld_aofvto  out date,
                         ln_aostat  out number,
                         ld_aofvalJ out date,
                         ld_aofvalC out date);
  Procedure Sp_cr_Avales(pn_ins in number,
                         pn_num out number,
                         pn_pai out number,
                         pn_tdo out number,
                         pc_doc out char,
                         pc_nom out char,
                         pc_tel out char);
  function fn_tipSBS( /*pd_fecpro in date,pn_emp in number,pn_mod in number,pn_suc in number,
                                                                                                                                                                       pn_mda in number,pn_pap in number,*/pn_cta in number,
                     pn_ope in number /*,
                                                                                                                                                                       pn_sbo in number,pn_top in number*/)
    return char;
  Function Fn_cr_GarantiaTipo(pn_mod in number, pn_top in number) return char;
  Function Fn_Garantia_mto(pn_emp in number,
                           pn_mod in number,
                           pn_suc in number,
                           pn_mda in number,
                           pn_pap in number,
                           pn_cta in number,
                           pn_ope in number,
                           pn_sbo in number,
                           pn_top in number) return number;
  function fn_correlativo(pn_prop in number) return number;
  function fn_correlativo_II(pn_prop in number) return number;
  function fn_fechafin(pd_fecha in date) return date;
  function fn_cl_telefonos(lv_pepais in number,
                           lv_petdoc in number,
                           lv_pendoc in char,
                           pn_tip    in number) return varchar2;
  Procedure Sp_Garantias(pn_nro in number,
                         pn_emp in number,
                         pn_mod in number,
                         pn_suc in number,
                         pn_mda in number,
                         pn_pap in number,
                         pn_cta in number,
                         pn_ope in number,
                         pn_sbo in number,
                         pn_top in number);
  Procedure Sp_fechaUltimoPag(pn_cta in number,
                              pn_ope in number,
                              pd_fec out date);

  procedure sp_cr_ubigeo(pn_pai     in number,
                         pn_tdo     in number,
                         pc_doc     in char,
                         P_C_ubigeo out char);

  procedure sp_cr_DPTO_PROV_DIS(pc_ubigeo in char,
                                pc_dpto   out char,
                                pc_prov   out char,
                                pc_dist   out char);

  Procedure Sp_creditoInicial(pn_emp  in number,
                              pn_mod  in number,
                              pn_suc  in number,
                              pn_mda  in number,
                              pn_pap  in number,
                              pn_cta  in number,
                              pn_ope  in number,
                              pn_sbo  in number,
                              pn_top  in number,
                              pn_empI out number,
                              pn_modI out number,
                              pn_sucI out number,
                              pn_mdaI out number,
                              pn_papI out number,
                              pn_ctaI out number,
                              pn_opeI out number,
                              pn_sboI out number,
                              pn_topI out number);

end PQ_CR_VENTA;
/

create or replace package body PQ_CR_VENTA is

  Procedure Sp_PreVenta(pn_nro in number) is
  begin
  
    execute immediate ('truncate table jaqz064_aux');
    begin
      insert into jaqz064_aux
        (JAQY952NRO,
         JAQY953EMP,
         JAQY953MOD,
         JAQY953SUC,
         JAQY953MDA,
         JAQY953PAP,
         JAQY953CTA,
         JAQY953OPE,
         JAQY953SBO,
         JAQY953TOP,
         PEPAIS,
         PETDOC,
         PENDOC,
         JAQY953CAV,
         JAQY953INV,
         JAQY953MOV,
         JAQY953OTV,
         TELLEG,
         TELGES,
         INSTANCIA,
         TIPCRE,
         TOTDEU,
         JAQY953FEV,
         JAQY952GRU,
         TITULAR)
      
        select /*+all_rows */
         a.jaqy952nro,
         a.jaqy953emp,
         a.jaqy953mod,
         a.jaqy953suc,
         a.jaqy953mda,
         a.jaqy953pap,
         a.jaqy953cta,
         a.jaqy953ope,
         a.jaqy953sbo,
         a.jaqy953top,
         b.pepais,
         b.petdoc,
         b.pendoc,
         a.jaqy953cav,
         a.jaqy953inv,
         a.jaqy953mov,
         a.jaqy953otv,
         
         pq_cr_venta.fn_cl_telefonos(b.pepais, b.petdoc, b.pendoc, 1) telLeg,
         pq_cr_venta.fn_cl_telefonos(b.pepais, b.petdoc, b.pendoc, 6) telGes,
         
         fn_instancia_credito(a.jaqy953mod,
                              a.jaqy953suc,
                              a.jaqy953mda,
                              a.jaqy953pap,
                              a.jaqy953cta,
                              a.jaqy953ope,
                              a.jaqy953sbo,
                              a.jaqy953top) instancia,
         case
           when a.jaqy953mod = 200 then
            'JUDICIAL'
           when a.jaqy953mod = 33 then
            'CASTIGADO'
           else
             null
             /*
            --kdvc 06/05/2022            
            (select case
               when f.AOMOD = 200 then
                'JUDICIAL'
               when f.aomod = 33 then
                'CASTIGADO'
               else
                 null
               end
               from fsd010 f 
               where f.aocta=a.jaqy953cta
                     and f.aooper=a.jaqy953ope
                     and f.aomod in (select modulo from fst111 where dscod=50) 
                     and f.aosbop=( select max(d.aosbop) from fsd010 d where d.aocta=a.jaqy953cta and d.aooper=a.jaqy953ope and d.aomod in (select modulo from fst111 where dscod=50)) 
                     and f.aomod<>a.jaqy953mod)
            --kdvc 06/05/2022
            */
         end tipcre,
         (a.jaqy953cav + a.jaqy953inv + a.jaqy953mov + a.jaqy953otv) totdeu,
         g.jaqy952fev,
         g.jaqy952gru,
         (select penom
            from fsd001 T
           where t.pepais = b.pepais
             and t.petdoc = b.petdoc
             and t.pendoc = b.pendoc) titular
        
          from jaqy953 a, fsr008 b, jaqy952 g
         where g.jaqy952gru = pn_nro
           and a.jaqy953vig = 'S'
           and a.jaqy953itc = 'S'
           and a.jaqy952nro = g.jaqy952nro
           and g.jaqy952est = 'V'
           and a.jaqy953cta = b.ctnro
           and b.pgcod = 1
           and b.cttfir = 'T';
    
      commit;
    end;
  end Sp_PreVenta;

  procedure sp_cr_venta_job(pn_gru IN number, pd_fecpro in date) is
  
    cursor c_clientes_job is
      select to_char(substr(trim(j.jaqy953cta), -1, 1)) digito
        from JAQZ064_aux j
       where j.jaqy952gru = pn_gru
       group by to_char(substr(trim(j.jaqy953cta), -1, 1));
  
    lc_variable varchar2(4000);
    ln_job      number := 0;
    lc_hostname varchar2(64);
    ln_cont     number(2) := 0;
    ln_inst     number(1) := 1;
  BEGIN
    begin
      select host_name into lc_hostname from v$instance;
    end;
  
    for job in c_clientes_job loop
      --      lc_variable := ' begin ' || ' PQ_CR_VENTA.Sp_Venta(''' || job.digito ||','||''''||pd_fecpro||
      --26.12.2018
      lc_variable := ' begin ' || ' PQ_CR_VENTA.Sp_Venta(''' || job.digito ||
                     ''',' || '''' || pd_fecpro || ''');' || ' End; ';
    
      ln_cont := ln_cont + 1;
    
      if (ln_cont >= 50) then
        ln_inst := 2;
      end if;
    
      ln_job := ln_job + 1;
    
      --mod@abr 20180907
--      if UPPER(lc_hostname) in ('SC01ZDBADM010101', 'SC01ZDBADM020101') then
        IF SYS.FN_BD_ISRAC='TRUE' THEN
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 180),
                        interval  => null,
                        no_parse  => false,
                        -- instance  => 2, -- 02/06/2024
                        instance  => 1,
                        force     => false);
      else
        DBMS_JOB.SUBMIT(job       => ln_job,
                        what      => lc_variable,
                        next_date => sysdate + 1 / (24 * 180),
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      end if;
      --mod@abr 20180907
    
      commit;
    
    end loop;
  
  end sp_cr_venta_job;

  Procedure Sp_Venta(P_C_DIGITO in varchar2, pd_fecpro in date) is
  
    cursor creditos is
      select *
        from jaqz064_aux a
       where to_char(substr(trim(a.jaqy953cta), -1, 1)) = P_C_DIGITO;
  
    ln_emp          number(3);
    ln_mod          number(3);
    ln_suc          number(3);
    ln_mda          number(4);
    ln_pap          number(4);
    ln_cta          number(9);
    ln_ope          number(9);
    ln_sbo          number(3);
    ln_top          number(3);
    lc_dirLeg       char(140);
    lv_refLeg       varchar2(140);
    lc_disLeg       char(30);
    lc_dirGes       char(140);
    lv_refGes       varchar2(140);
    lc_disGes       char(30);
    lc_dirNeg       char(140);
    lv_refNeg       varchar2(140);
    lc_disNeg       char(30);
    lv_sbs          varchar2(10);
    lc_actividad    char(60);
    lc_categoria    char(15);
    fec_des         date;
    ln_aoimp        number(17, 2);
    ln_provision    number(14, 8);
    lc_refinan      char(1);
    ld_fecul        date;
    ln_dia          number(5);
    ld_vto          date;
    ld_fvalJ        date;
    ld_fvalC        date;
    ln_stat         number(2);
    ln_cuotas       number(5);
    ln_numaval      number(4);
    ln_paiaval      number(3);
    ln_tipaval      number(2);
    lc_docaval      char(12);
    lc_nomaval      char(30);
    lc_dirLegAv     char(140);
    lv_refLegAv     varchar2(140);
    lc_disLegAv     char(30);
    lc_telaval      char(20);
    lc_tipSBS       char(30);
    ld_fecSBS       date;
    ln_correlativo  number(30);
    lc_coderr       varchar2(300);
    lc_ubigeo       char(6);
    lc_departamento char(20);
    lc_provincia    char(30);
    lc_distrito     char(30);
    ln_insIni       number(10); --mod@abr 20190521
  
  begin
  
    ln_correlativo := 0;
    BEGIN
      For i in creditos loop
        ln_emp          := null;
        ln_mod          := null;
        ln_suc          := null;
        ln_mda          := null;
        ln_pap          := null;
        ln_cta          := null;
        ln_ope          := null;
        ln_sbo          := null;
        ln_top          := null;
        lc_dirLeg       := null;
        lv_refLeg       := null;
        lc_disLeg       := null;
        lc_dirGes       := null;
        lv_refGes       := null;
        lc_disGes       := null;
        lc_dirNeg       := null;
        lv_refNeg       := null;
        lc_disNeg       := null;
        lv_sbs          := null;
        lc_actividad    := null;
        lc_categoria    := null;
        fec_des         := null;
        ln_aoimp        := null;
        ln_provision    := null;
        lc_refinan      := null;
        ld_fecul        := null;
        ln_dia          := null;
        ld_vto          := null;
        ld_fvalC        := null;
        ld_fvalJ        := null;
        ln_stat         := null;
        ln_cuotas       := null;
        ln_numaval      := null;
        ln_paiaval      := null;
        ln_tipaval      := null;
        lc_docaval      := null;
        lc_nomaval      := null;
        lc_dirLegAv     := null;
        lv_refLegAv     := null;
        lc_disLegAv     := null;
        lc_telaval      := null;
        lc_tipSBS       := null;
        ld_fecSBS       := null;
        lc_coderr       := null;
        lc_ubigeo       := null;
        lc_departamento := null;
        lc_provincia    := null;
        lc_distrito     := null;
        ln_insIni       := null;
      
        begin
        
          --pq_cr_venta.sp_cr_credini( i.jaqy953cta,
          --                          i.jaqy953ope, 
          --                          ln_emp,
          --                          ln_mod,
          --                          ln_suc,
          --                          ln_mda,
          --                          ln_pap,
          --                          ln_cta,
          --                          ln_ope,
          --                          ln_sbo,
          --                          ln_top);  --mod@abr 20190521
        
          --mod@abr 20190521
          pq_cr_venta.Sp_creditoInicial(i.jaqy953emp,
                                        i.jaqy953mod,
                                        i.jaqy953suc,
                                        i.jaqy953mda,
                                        i.jaqy953pap,
                                        i.jaqy953cta,
                                        i.jaqy953ope,
                                        i.jaqy953sbo,
                                        i.jaqy953top,
                                        ln_emp,
                                        ln_mod,
                                        ln_suc,
                                        ln_mda,
                                        ln_pap,
                                        ln_cta,
                                        ln_ope,
                                        ln_sbo,
                                        ln_top);
        
          ln_insIni := fn_instancia_credito(ln_mod,
                                            ln_suc,
                                            ln_mda,
                                            ln_pap,
                                            ln_cta,
                                            ln_ope,
                                            ln_sbo,
                                            ln_top);
        
          --mod@abr 20190521                  
        
          --direccion legal
          pq_cr_venta.Sp_cr_Direcciones(i.pepais,
                                        i.petdoc,
                                        i.pendoc,
                                        1,
                                        lc_dirLeg,
                                        lv_refLeg,
                                        lc_disLeg);
          --direccion gestion
          pq_cr_venta.Sp_cr_Direcciones(i.pepais,
                                        i.petdoc,
                                        i.pendoc,
                                        6,
                                        lc_dirGes,
                                        lv_refGes,
                                        lc_disGes);
          --direccion negocio
          pq_cr_venta.Sp_cr_Direcciones(i.pepais,
                                        i.petdoc,
                                        i.pendoc,
                                        3,
                                        lc_dirNeg,
                                        lv_refNeg,
                                        lc_disNeg);
          --actividad
          lc_actividad := pq_cr_venta.fn_actividad(i.pepais,
                                                   i.petdoc,
                                                   i.pendoc);
          --codigo sbs
          lv_sbs := pq_cr_venta.fn_codsbs(i.pepais,
                                          i.petdoc,
                                          i.pendoc,
                                          i.jaqy953cta);
          --categoria sbs
          lc_categoria := pq_cr_venta.fn_categoria(i.jaqy953emp,
                                                   i.jaqy953cta,
                                                   9);
          --fecha y monto de desembolso
          pq_cr_venta.sp_cr_desem(ln_emp,
                                  ln_mod,
                                  ln_suc,
                                  ln_mda,
                                  ln_pap,
                                  ln_cta,
                                  ln_ope,
                                  ln_sbo,
                                  ln_top,
                                  fec_des,
                                  ln_aoimp);
          --provisiones
          ln_provision := 100.00000000;
        
          --refinanciado
          lc_refinan := pq_cr_venta.fn_refinanciado(i.jaqy953cta,
                                                    i.jaqy953ope);
        
          --fecha de ultimo pago
          pq_cr_venta.Sp_fechaUltimoPag(i.jaqy953cta,
                                        i.jaqy953ope,
                                        ld_fecul);
        
          pq_cr_venta.Sp_cr_fsd010(i.jaqy953emp,
                                   i.jaqy953mod,
                                   i.jaqy953suc,
                                   i.jaqy953mda,
                                   i.jaqy953pap,
                                   i.jaqy953cta,
                                   i.jaqy953ope,
                                   i.jaqy953sbo,
                                   i.jaqy953top,
                                   ld_vto,
                                   ln_stat,
                                   ld_fvalJ,
                                   ld_fvalC);
          --dias de atraso
          ln_dia := nvl(fn_dias_atraso( --trunc(sysdate), --mod@abr 20180907 comentar
                                       pd_fecpro,
                                       
                                       i.jaqy953emp,
                                       i.jaqy953mod,
                                       i.jaqy953suc,
                                       i.jaqy953mda,
                                       i.jaqy953pap,
                                       i.jaqy953cta,
                                       i.jaqy953ope,
                                       i.jaqy953sbo,
                                       i.jaqy953top,
                                       ln_stat,
                                       ld_vto),
                        0);
        
          --mod@abr 20190521
        
          if ln_dia = 0 and i.jaqy953top = 550 then
            begin
              select pd_fecpro - a.aofvto
                into ln_dia
                from fsd010 a
               where a.pgcod = i.jaqy953emp
                 and a.aomod = i.jaqy953mod
                 and a.aosuc = i.jaqy953suc
                 and a.aomda = i.jaqy953mda
                 and a.aopap = i.jaqy953pap
                 and a.aocta = i.jaqy953cta
                 and a.aooper = i.jaqy953ope
                 and a.aosbop = i.jaqy953sbo
                 and a.aotope = i.jaqy953top;
            exception
              when others then
                ln_dia := 0;
            end;
          
            If ln_dia < 0 then
              ln_dia := 0;
            End if;
          end if;
          --mod@abr 20190521
        
          --cuotas pagadas
          ln_cuotas := pq_cr_venta.fn_cuotas_pagadas(ln_emp,
                                                     ln_mod,
                                                     ln_suc,
                                                     ln_mda,
                                                     ln_pap,
                                                     ln_cta,
                                                     ln_ope,
                                                     ln_sbo,
                                                     ln_top);
          --numero de avales, aval
          pq_cr_venta.Sp_cr_Avales( --i.instancia,  --mod@abr 20190521
                                   ln_insIni, --mod@abr 20190521
                                   ln_numaval,
                                   ln_paiaval,
                                   ln_tipaval,
                                   lc_docaval,
                                   lc_nomaval,
                                   lc_telaval);
          --direccion legal aval
          pq_cr_venta.Sp_cr_Direcciones(ln_paiaval,
                                        ln_tipaval,
                                        lc_docaval,
                                        1,
                                        lc_dirLegAv,
                                        lv_refLegAv,
                                        lc_disLegAv);
        
          -- /*MOD @MPCA 20180801 SE AGREGO UBIGEO, DEPARTAMENTO PROVINCIA DISTRITO*/ --
        
          --ubigeo
          --departamento
          --provincia
          --distrito
        
          pq_cr_venta.sp_cr_ubigeo(i.pepais, i.petdoc, i.pendoc, lc_ubigeo);
        
          pq_cr_venta.sp_cr_DPTO_PROV_DIS(lc_ubigeo,
                                          lc_departamento,
                                          lc_provincia,
                                          lc_distrito);
        
          -- /*MOD @MPCA 20180801 SE AGREGO UBIGEO, DEPARTAMENTO PROVINCIA DISTRITO*/ --
        
          --tipo SBS
          ld_fecSBS := i.jaqy953fev - 1;
        
          lc_tipSBS := pq_cr_venta.fn_tipSBS(i.jaqy953cta, i.jaqy953ope);
          --correlativo
          ln_correlativo := pq_cr_venta.fn_correlativo(i.jaqy952nro);
          insert into jaqz064
            (JAQZ064NRO,
             JAQZ064PGC,
             JAQZ064MOD,
             JAQZ064SUC,
             JAQZ064MDA,
             JAQZ064PAP,
             JAQZ064CTA,
             JAQZ064OPE,
             JAQZ064SBO,
             JAQZ064TOP,
             JAQZ064PAI,
             JAQZ064TDO,
             JAQZ064NDO,
             JAQZ064CAP,
             JAQZ064MOR,
             JAQZ064INT,
             JAQZ064GAS,
             Jaqz064dil,
             Jaqz064tel,
             JAQZ064FED,
             JAQZ064INS,
             Jaqz064pgi,
             Jaqz064moi,
             Jaqz064sui,
             Jaqz064mdi,
             Jaqz064ppi,
             Jaqz064cti,
             Jaqz064opi,
             Jaqz064sbi,
             Jaqz064toi,
             Jaqz064rel,
             Jaqz064teg,
             Jaqz064dsl,
             Jaqz064dsg,
             Jaqz064dsn,
             Jaqz064dig,
             Jaqz064reg,
             Jaqz064din,
             Jaqz064act,
             Jaqz064sbs,
             Jaqz064cal,
             Jaqz064aoi,
             Jaqz064pro,
             Jaqz064tic,
             Jaqz064tod,
             Jaqz064ref,
             Jaqz064ful,
             Jaqz064fij,
             Jaqz064fic,
             Jaqz064dia,
             Jaqz064cuo,
             Jaqz064nav,
             Jaqz064paa,
             Jaqz064tda,
             Jaqz064nda,
             Jaqz064noa,
             Jaqz064dra,
             Jaqz064rea,
             Jaqz064dsa,
             Jaqz064tea,
             Jaqz064tsb,
             Jaqz064cor,
             Jaqz064gru,
             jaqz064tit,
             jaqz064ubi,
             jaqz064dep,
             jaqz064prv,
             jaqz064dit)
          values
            (i.jaqy952nro,
             i.jaqy953emp,
             i.jaqy953mod,
             i.jaqy953suc,
             i.jaqy953mda,
             i.jaqy953pap,
             i.jaqy953cta,
             i.jaqy953ope,
             i.jaqy953sbo,
             i.jaqy953top,
             i.pepais,
             i.petdoc,
             i.pendoc,
             i.jaqy953cav,
             i.jaqy953inv,
             i.jaqy953mov,
             i.jaqy953otv,
             lc_dirLeg,
             i.telLeg,
             fec_des,
             --i.instancia,  --mod@abr 20190521
             ln_insIni, --mod@abr 20190521
             ln_emp,
             ln_mod,
             ln_suc,
             ln_mda,
             ln_pap,
             ln_cta,
             ln_ope,
             ln_sbo,
             ln_top,
             lv_refLeg,
             i.telGes,
             lc_disLeg,
             lc_disGes,
             lc_disNeg,
             lc_dirGes,
             lv_refGes,
             lc_dirNeg,
             lc_actividad,
             lv_sbs,
             lc_categoria,
             ln_aoimp,
             ln_provision,
             i.tipcre,
             i.totdeu,
             lc_refinan,
             ld_fecul,
             ld_fvalJ,
             ld_fvalC,
             ln_dia,
             ln_cuotas,
             ln_numaval,
             ln_paiaval,
             ln_tipaval,
             lc_docaval,
             lc_nomaval,
             lc_dirLegAv,
             lv_refLegAv,
             lc_disLegAv,
             lc_telaval,
             lc_tipSBS,
             ln_correlativo,
             i.jaqy952gru,
             I.TITULAR,
             lc_ubigeo,
             lc_departamento,
             lc_provincia,
             lc_distrito);
        
          commit;
        
        exception
          when others then
            lc_coderr := sqlerrm;
          
            insert into jaqz064_error
              (jaqz064dig, jaqz064cta, jaqz064ope, jaqz064err)
            values
              (P_C_DIGITO, i.jaqy953cta, i.jaqy953ope, lc_coderr);
            commit;
          
        end;
      end loop;
      commit;
    END;
  
  end Sp_Venta;

  Procedure Sp_Venta_II(pn_nro in number) is
  
    cursor creditos is
      select * from jaqz064 a where a.jaqz064gru = pn_nro;
  
    lc_coderr varchar2(300);
  
  begin
  
    BEGIN
      For i in creditos loop
      
        lc_coderr := null;
        begin
          pq_cr_venta.sp_garantias(i.JAQZ064NRO,
                                   i.JAQZ064PGC,
                                   i.JAQZ064MOD,
                                   i.JAQZ064SUC,
                                   i.JAQZ064MDA,
                                   i.JAQZ064PAP,
                                   i.JAQZ064CTA,
                                   i.JAQZ064OPE,
                                   i.JAQZ064SBO,
                                   i.JAQZ064TOP);
        
        exception
          when others then
            lc_coderr := sqlerrm;
            dbms_output.put_line(i.JAQZ064NRO || '-' || i.JAQZ064CTA || '-' ||
                                 i.JAQZ064OPE || lc_coderr);
          
        end;
        COMMIT;
      end loop;
      COMMIT;
    END;
  
  end Sp_Venta_II;

  Procedure Sp_cr_desem(pn_emp    in number,
                        pn_mod    in number,
                        pn_suc    in number,
                        pn_mda    in number,
                        pn_pap    in number,
                        pn_cta    in number,
                        pn_ope    in number,
                        pn_sbo    in number,
                        pn_top    in number,
                        ld_fecdes out date,
                        ln_aoimp  out number) is
    --ln_sboR1  number(3) := null; --mod@abr 20180907 comentado
    --ln_sboR2  number(3) := null;--mod@abr 20180907 comentado
    --ln_sboMax number(3) := null;--mod@abr 20180907 comentado
    --ln_emp    number(3) := null;--mod@abr 20180907 comentado
    --ln_mod    number(3) := null;--mod@abr 20180907 comentado
    --ln_suc    number(3) := null;--mod@abr 20180907 comentado
    --ln_mda    number(4) := null;--mod@abr 20180907 comentado
    --ln_pap    number(4) := null;--mod@abr 20180907 comentado
    --ln_cta    number(9) := null;--mod@abr 20180907 comentado
    --ln_ope    number(9) := null;--mod@abr 20180907 comentado
    --ln_sbo    number(3) := null;--mod@abr 20180907 comentado
    --ln_top    number(3) := null;--mod@abr 20180907 comentado
  
  begin
    --ln_sboMax := null;  --mod@abr 20180907 comentado
    begin
    
      select a.aofval, a.aoimp
        into ld_fecdes, ln_aoimp
        from FSD010 a
       where a.aomod = pn_mod
         and a.aocta = pn_cta
         and a.aooper = pn_ope
         and a.aosbop = pn_sbo
         and a.pgcod = pn_emp
         and a.aosuc = pn_suc
         and a.aomda = pn_mda
         and a.aopap = pn_pap
         and a.aotope = pn_top
         and rownum = 1;
    
    exception
      when others then
        ld_fecdes := null;
      
    end;
  
    --mod@abr 20180807 se agrego
    if ld_fecdes is null then
      begin
      
        select a.aofval, a.aoimp
          into ld_fecdes, ln_aoimp
          from FSD010 a
         where a.aomod = pn_mod
           and a.aocta = pn_cta
           and a.aooper = pn_ope
           and a.pgcod = pn_emp
           and a.aosuc = pn_suc
           and a.aomda = pn_mda
           and a.aopap = pn_pap
           and a.aotope = pn_top
           and rownum = 1;
      
      exception
        when others then
          ld_fecdes := null;
        
      end;
    end if;
    --mod@abr 20180807 se agrego
  
    --mod@abr 20180907 comentado 
    /* begin
      select max(a.r1sbop)
        into ln_sboR1
        from fsr011 a
       where relcod = 120
         and r1cta = pn_cta
         and a.r1oper = pn_ope
         and r1mod not in (200, 33, 65)
         and a.r1tope <> 550;
    exception
      when no_data_found then
        ln_sboR1 := null;
    end;
    
    begin
      select max(a.r2sbop)
        into ln_sboR2
        from fsr011 a
       where relcod = 120
         and r2cta = pn_cta
         and a.r2oper = pn_ope
         and r2mod not in (200, 33, 65)
         and a.r2tope <> 550;
    exception
      when no_data_found then
        ln_sboR2 := null;
      
    end;
    
    if ln_sboR1 is not null and ln_sboR2 is not null then
      if ln_sboR1 = ln_sboR2 then
        ln_sboMax := ln_sboR1;
        begin
          select a.r1cod,
                 a.r1mod,
                 a.r1suc,
                 a.r1mda,
                 a.r1pap,
                 a.r1cta,
                 a.r1oper,
                 a.r1sbop,
                 a.r1tope
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
           where relcod = 120
             and r1cta = pn_cta
             and a.r1oper = pn_ope
             and a.r1sbop = ln_sboMax
             and r1mod not in (200, 33, 65)
             and a.r1tope <> 550
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
        end;
      end if;
    
      if ln_sboR1 > ln_sboR2 then
        ln_sboMax := ln_sboR1;
        begin
          select a.r1cod,
                 a.r1mod,
                 a.r1suc,
                 a.r1mda,
                 a.r1pap,
                 a.r1cta,
                 a.r1oper,
                 a.r1sbop,
                 a.r1tope
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
           where relcod = 120
             and r1cta = pn_cta
             and a.r1oper = pn_ope
             and a.r1sbop = ln_sboMax
             and r1mod not in (200, 33, 65)
             and a.r1tope <> 550
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
        end;
      Else
        ln_sboMax := ln_sboR2;
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
           where relcod = 120
             and r2cta = pn_cta
             and a.r2oper = pn_ope
             and a.r2sbop = ln_sboMax
             and r2mod not in (200, 33, 65)
             and a.r2tope <> 550
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
        end;
      end if;
    end if;
    
    if ln_sboR1 is null and ln_sboR2 is not null then
      ln_sboMax := ln_sboR2;
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
         where relcod = 120
           and r2cta = pn_cta
           and a.r2oper = pn_ope
           and a.r2sbop = ln_sboMax
           and r2mod not in (200, 33, 65)
           and a.r2tope <> 550
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
      end;
    end if;
    
    if ln_sboR1 is not null and ln_sboR2 is null then
      ln_sboMax := ln_sboR1;
      begin
        select a.r1cod,
               a.r1mod,
               a.r1suc,
               a.r1mda,
               a.r1pap,
               a.r1cta,
               a.r1oper,
               a.r1sbop,
               a.r1tope
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
         where relcod = 120
           and r1cta = pn_cta
           and a.r1oper = pn_ope
           and a.r1sbop = ln_sboMax
           and r1mod not in (200, 33, 65)
           and a.r1tope <> 550
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
      end;
    end if;
    
    if ln_sboMax is not null then
      begin
      
        select a.aofval, a.aoimp
          into ld_fecdes, ln_aoimp
          from \*bantprod.*\ FSD010 a
         where a.aomod = ln_mod
           and a.aocta = ln_cta
           and a.aooper = ln_ope
           and a.aosbop = ln_sbo
           and a.pgcod = ln_emp
           and a.aosuc = ln_suc
           and a.aomda = ln_mda
           and a.aopap = ln_pap
           and a.aotope = ln_top
           and rownum = 1;
      
      exception
        when others then
          ld_fecdes := null;
        
      end;
    end if;*/ --mod@abr 20180907 comentado 
  
  end Sp_cr_desem;

  Procedure Sp_cr_CredIni(pn_cta  in number,
                          pn_ope  in number,
                          ln_empC out number,
                          ln_modC out number,
                          ln_sucC out number,
                          ln_mdaC out number,
                          ln_papC out number,
                          ln_ctaC out number,
                          ln_opeC out number,
                          ln_sboC out number,
                          ln_topC out number) is
    ln_sboR1  number(3);
    ln_sboR2  number(3);
    ln_sboMax number(3);
  
  begin
  
    begin
    
      select a.pgcod,
             a.aomod,
             a.aosuc,
             a.aomda,
             a.aopap,
             a.aocta,
             a.aooper,
             a.aosbop,
             a.aotope
        into ln_empC,
             ln_modC,
             ln_sucC,
             ln_mdaC,
             ln_papC,
             ln_ctaC,
             ln_opeC,
             ln_sboC,
             ln_topC
        from fsd010 a
       where a.aocta = pn_cta
         and a.aooper = pn_ope
         and a.aomod in (select modulo from fst111 where dscod = 50)
         and a.aosbop =
             (select min(aa.aosbop)
                from fsd010 aa
               where aa.aocta = a.aocta
                 and aa.aooper = a.aooper
                 and aa.aomod in
                     (select modulo from fst111 where dscod = 50))
         and a.aofval =
             (select min(aa.aofval)
                from fsd010 aa
               where aa.aocta = a.aocta
                 and aa.aooper = a.aooper
                 and aa.aomod in
                     (select modulo from fst111 where dscod = 50))
         and aomod not in (200, 33, 65)
         and aotope <> 550
         and rownum = 1;
    
    exception
      when no_data_found then
        ln_empC := null;
        ln_modC := null;
        ln_sucC := null;
        ln_mdaC := null;
        ln_papC := null;
        ln_ctaC := null;
        ln_opeC := null;
        ln_sboC := null;
        ln_topC := null;
      
    end;
  
    begin
      select max(a.r1sbop)
        into ln_sboR1
        from fsr011 a
       where relcod = 120
         and r1cta = pn_cta
         and a.r1oper = pn_ope
         and r1mod not in (200, 33, 65) --mod@abr 20180907 se agrego
         and a.r1tope <> 550; --mod@abr 20180907 se agrego
    exception
      when no_data_found then
        ln_sboR1 := null;
    end;
  
    begin
      select max(a.r2sbop)
        into ln_sboR2
        from fsr011 a
       where relcod = 120
         and r2cta = pn_cta
         and a.r2oper = pn_ope
         and r2mod not in (200, 33, 65) --mod@abr 20180907 se agrego
         and a.r2tope <> 550; --mod@abr 20180907 se agrego
    exception
      when no_data_found then
        ln_sboR2 := null;
      
    end;
  
    if ln_sboR1 is not null and ln_sboR2 is not null then
      if ln_sboR1 = ln_sboR2 then
        ln_sboMax := ln_sboR1;
        begin
          select a.r1cod,
                 a.r1mod,
                 a.r1suc,
                 a.r1mda,
                 a.r1pap,
                 a.r1cta,
                 a.r1oper,
                 a.r1sbop,
                 a.r1tope
            into ln_empC,
                 ln_modC,
                 ln_sucC,
                 ln_mdaC,
                 ln_papC,
                 ln_ctaC,
                 ln_opeC,
                 ln_sboC,
                 ln_topC
            from fsr011 a
           where relcod = 120
             and r1cta = pn_cta
             and a.r1oper = pn_ope
             and a.r1sbop = ln_sboMax
             and r1mod not in (200, 33, 65)
             and a.r1tope <> 550
             and rownum = 1;
        exception
          when no_data_found then
            ln_empC := null;
            ln_modC := null;
            ln_sucC := null;
            ln_mdaC := null;
            ln_papC := null;
            ln_ctaC := null;
            ln_opeC := null;
            ln_sboC := null;
            ln_topC := null;
        end;
      end if;
    
      if ln_sboR1 > ln_sboR2 then
        ln_sboMax := ln_sboR1;
        begin
          select a.r1cod,
                 a.r1mod,
                 a.r1suc,
                 a.r1mda,
                 a.r1pap,
                 a.r1cta,
                 a.r1oper,
                 a.r1sbop,
                 a.r1tope
            into ln_empC,
                 ln_modC,
                 ln_sucC,
                 ln_mdaC,
                 ln_papC,
                 ln_ctaC,
                 ln_opeC,
                 ln_sboC,
                 ln_topC
            from fsr011 a
           where relcod = 120
             and r1cta = pn_cta
             and a.r1oper = pn_ope
             and a.r1sbop = ln_sboMax
             and r1mod not in (200, 33, 65)
             and a.r1tope <> 550
             and rownum = 1;
        exception
          when no_data_found then
            ln_empC := null;
            ln_modC := null;
            ln_sucC := null;
            ln_mdaC := null;
            ln_papC := null;
            ln_ctaC := null;
            ln_opeC := null;
            ln_sboC := null;
            ln_topC := null;
        end;
      Else
        ln_sboMax := ln_sboR2;
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
            into ln_empC,
                 ln_modC,
                 ln_sucC,
                 ln_mdaC,
                 ln_papC,
                 ln_ctaC,
                 ln_opeC,
                 ln_sboC,
                 ln_topC
            from fsr011 a
           where relcod = 120
             and r2cta = pn_cta
             and a.r2oper = pn_ope
             and a.r2sbop = ln_sboMax
             and r2mod not in (200, 33, 65)
             and a.r2tope <> 550
             and rownum = 1;
        exception
          when no_data_found then
            ln_empC := null;
            ln_modC := null;
            ln_sucC := null;
            ln_mdaC := null;
            ln_papC := null;
            ln_ctaC := null;
            ln_opeC := null;
            ln_sboC := null;
            ln_topC := null;
        end;
      end if;
    end if;
  
    if ln_sboR1 is null and ln_sboR2 is not null then
      ln_sboMax := ln_sboR2;
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
          into ln_empC,
               ln_modC,
               ln_sucC,
               ln_mdaC,
               ln_papC,
               ln_ctaC,
               ln_opeC,
               ln_sboC,
               ln_topC
          from fsr011 a
         where relcod = 120
           and r2cta = pn_cta
           and a.r2oper = pn_ope
           and a.r2sbop = ln_sboMax
           and r2mod not in (200, 33, 65)
           and a.r2tope <> 550
           and rownum = 1;
      exception
        when no_data_found then
          ln_empC := null;
          ln_modC := null;
          ln_sucC := null;
          ln_mdaC := null;
          ln_papC := null;
          ln_ctaC := null;
          ln_opeC := null;
          ln_sboC := null;
          ln_topC := null;
      end;
    end if;
  
    if ln_sboR1 is not null and ln_sboR2 is null then
      ln_sboMax := ln_sboR1;
      begin
        select a.r1cod,
               a.r1mod,
               a.r1suc,
               a.r1mda,
               a.r1pap,
               a.r1cta,
               a.r1oper,
               a.r1sbop,
               a.r1tope
          into ln_empC,
               ln_modC,
               ln_sucC,
               ln_mdaC,
               ln_papC,
               ln_ctaC,
               ln_opeC,
               ln_sboC,
               ln_topC
          from fsr011 a
         where relcod = 120
           and r1cta = pn_cta
           and a.r1oper = pn_ope
           and a.r1sbop = ln_sboMax
           and r1mod not in (200, 33, 65)
           and a.r1tope <> 550
           and rownum = 1;
      exception
        when no_data_found then
          ln_empC := null;
          ln_modC := null;
          ln_sucC := null;
          ln_mdaC := null;
          ln_papC := null;
          ln_ctaC := null;
          ln_opeC := null;
          ln_sboC := null;
          ln_topC := null;
      end;
    end if;
  
  end Sp_cr_CredIni;

  Function Fn_cr_fecult(pn_emp in number,
                        pn_mod in number,
                        pn_suc in number,
                        pn_mda in number,
                        pn_pap in number,
                        pn_cta in number,
                        pn_ope in number,
                        pn_sbo in number,
                        pn_top in number,
                        pn_cti in number,
                        pn_opi in number) return date is
    ld_fecupa date;
  
  begin
    begin
    
      select max(h.hfcon)
        into ld_fecupa
        from fsh016 h
       inner join fst198 f
          on h.hcmod = f.tp1corr1
         and h.htran = f.tp1corr2
         and h.hcord = f.tp1corr3
       where h.pgcod = pn_emp
         and h.hcta = pn_cti
         and h.hoper = pn_opi
         and f.tp1cod1 = 10876;
    
    exception
      when no_data_found then
        ld_fecupa := null;
      when too_many_rows then
        ld_fecupa := null;
    end;
  
    if ld_fecupa is null then
      begin
      
        select max(o.pp1fech)
          into ld_fecupa
          from fsd602 o
         where o.pgcod = pn_emp
           and o.ppmod = pn_mod
           and o.ppsuc = pn_suc
           and o.ppmda = pn_mda
           and o.pppap = pn_pap
           and o.ppcta = pn_cta
           and o.ppoper = pn_ope
           and o.ppsbop = pn_sbo
           and o.pptope = pn_top
           and o.pp1stat = 'T'
           and o.d602co = 'S';
      exception
        when no_data_found then
          ld_fecupa := null;
        when too_many_rows then
          ld_fecupa := null;
      end;
    
    end if;
    return ld_fecupa;
  
  end Fn_cr_fecult;

  function fn_cuotas_pagadas(pn_emp  in number,
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
         and (d602mo, d602tr) not in (select 300, 390 from dual)
         and (d602mo, d602tr) not in (select 300, 406 from dual)
         and (d602mo, d602tr) not in (select 300, 400 from dual)
            
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
  
    begin
    
      if ln_numcuotas is null then
        ln_numcuotas := 0;
      end if;
    end;
  
    return ln_numcuotas;
  end fn_cuotas_pagadas;

  Procedure Sp_cr_Direcciones(pn_pai in number,
                              pn_tdo in number,
                              pc_doc in char,
                              pn_tip in number,
                              pc_dir out char,
                              pv_ref out varchar2,
                              pc_dis out char) is
  
  begin
    --direccion
    begin
      select aa.sngc13dir
        into pc_dir
        from sngc13 aa
       where aa.sngc13pais = pn_pai
         and aa.sngc13tdoc = pn_tdo
         and aa.sngc13ndoc = pc_doc
         and aa.docod = pn_tip
         and aa.sngc13est = 'H';
    exception
      when no_data_found then
        pc_dir := null;
      when too_many_rows then
        pc_dir := null;
    end;
  
    --referencia
    begin
      select aa.sngc13ref1
        into pv_ref
        from sngc13 aa
       where aa.sngc13pais = pn_pai
         and aa.sngc13tdoc = pn_tdo
         and aa.sngc13ndoc = pc_doc
         and aa.docod = pn_tip
         and aa.sngc13est = 'H'
         and rownum = 1;
    exception
      when no_data_found then
        pv_ref := null;
      when too_many_rows then
        pv_ref := null;
      when others then
        null;
      
    end;
  
    --distrito
  
    begin
      select xx.fst071dsc
        into pc_dis
        from sngc13 aa, fst071 xx
       where aa.sngc13pais = pn_pai
         and aa.sngc13tdoc = pn_tdo
         and aa.sngc13ndoc = pc_doc
         and aa.sngc13pais = xx.fst071pai
         and aa.sngc13dpto = xx.fst071dpt
         and aa.sngc13prov = xx.fst071loc
         and aa.sngc13dist = xx.fst071col
         and aa.sngc13est = 'H'
         and aa.docod = pn_tip;
    exception
      when no_data_found then
        pc_dis := null;
      when too_many_rows then
        pc_dis := null;
    end;
  
  end Sp_cr_Direcciones;

  function fn_codsbs(pn_pepais in number,
                     pn_petdoc in number,
                     pc_pendoc in varchar2,
                     pn_cta    in number) return varchar2 is
    lc_codsbs varchar2(10);
  begin
    begin
    
      select lpad(to_char(c.bc739sbs), 10, 0)
        into lc_codsbs
        from fbc739 c
       where c.bc739pais = pn_pepais
         and c.bc739tdoc = pn_petdoc
         and c.bc739ndoc = pc_pendoc
         and c.bc739cta = pn_cta;
    exception
      when others then
        lc_codsbs := null;
    end;
    return lc_codsbs;
  end fn_codsbs;

  function fn_actividad(pn_pais in number,
                        pn_tdoc in number,
                        pc_ndoc in char) return char is
    lc_activi char(60);
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
        begin
        
          select xxx.actnom1
            into lc_activi
            from sngc11 cc, fst750 xxx
           where cc.sngc11pais = pn_pais
             and cc.sngc11tdoc = pn_tdoc
             and cc.sngc11ndoc = pc_ndoc
             and cc.sngc11act2 = xxx.actcod1;
        exception
          when no_data_found then
            begin
            
              select xxx.actnom1
                into lc_activi
                from fse001 cc, fst750 xxx
               where cc.d511pais = pn_pais
                 and cc.d511tdoc = pn_tdoc
                 and cc.d511ndoc = pc_ndoc
                 and cc.expnins = xxx.actcod1;
            exception
              when others then
                lc_activi := null;
            end;
        end;
      
      when too_many_rows then
        lc_activi := null;
    end;
    return lc_activi;
  end fn_actividad;

  function fn_categoria(pn_emp    in number,
                        pn_cta    in number,
                        pn_codcat in number) return char is
    lc_categoria char(15);
    ld_fecha     date;
  
  begin
  
    --devuelve fecha activa de fin de mes
  
    ld_fecha := pq_cr_venta.fn_fechafin(trunc(sysdate));
  
    begin
      select l.catcateg
        into lc_categoria
        from fsd212 l
       where l.pgcod = pn_emp
         and l.catcta = pn_cta
         and l.catfchdes = ld_fecha
         and l.catcod = pn_codcat;
    exception
      when no_data_found then
        lc_categoria := null;
      when too_many_rows then
        lc_categoria := null;
    end;
    return lc_categoria;
  end fn_categoria;

  function fn_provisiones(pn_emp in number,
                          pn_mod in number,
                          pn_mda in number,
                          pn_pap in number,
                          pn_cta in number,
                          pn_ope in number,
                          pn_sbo in number,
                          pn_top in number) return number is
    ln_provision number(14, 8);
  begin
  
    begin
      select l.ri105coef
        into ln_provision
        from fri105 l
       where l.ri105cod = pn_emp
         and l.ri105mod = pn_mod
         and l.ri105mda = pn_mda
         and l.ri105pap = pn_pap
         and l.ri105cta = pn_cta
         and l.ri105oper = pn_ope
         and l.ri105sbop = pn_sbo
         and l.ri105tope = pn_top;
    exception
      when no_data_found then
        ln_provision := 0;
      when too_many_rows then
        ln_provision := 0;
    end;
  
    if nvl(ln_provision, 0) = 0 then
      ln_provision := 100;
    end if;
    return ln_provision;
  end fn_provisiones;

  function fn_refinanciado(pn_cta in number, pn_oper in number) return char is
    lc_existe char(1);
  begin
    begin
      select 'S'
        into lc_existe
        from fsr011 a
       where a.r1cta = pn_cta
         and a.r1oper = pn_oper
         and relcod = 35
         and a.r011co = 'S'
         and rownum = 1;
    exception
      when no_data_found then
        lc_existe := 'N';
    end;
  
    if lc_existe = 'N' then
      begin
        select 'S'
          into lc_existe
          from fsr011 a
         where a.r1cta = pn_cta
           and a.r1oper = pn_oper
           and relcod = 120
           and a.r011co = 'S'
           and rownum = 1;
      exception
        when no_data_found then
          lc_existe := 'N';
      end;
    
      if lc_existe = 'N' then
        begin
          select 'S'
            into lc_existe
            from fsr011 a
           where a.r2cta = pn_cta
             and a.r2oper = pn_oper
             and relcod = 120
             and a.r011co = 'S'
             and rownum = 1;
        exception
          when no_data_found then
            lc_existe := 'N';
        end;
      
      end if;
    
    end if;
  
    return lc_existe;
  end fn_refinanciado;

  Procedure Sp_cr_fsd010(pn_emp     in number,
                         pn_mod     in number,
                         pn_suc     in number,
                         pn_mda     in number,
                         pn_pap     in number,
                         pn_cta     in number,
                         pn_ope     in number,
                         pn_sbo     in number,
                         pn_top     in number,
                         ld_aofvto  out date,
                         ln_aostat  out number,
                         ld_aofvalJ out date,
                         ld_aofvalC out date) is
  
    ln_cta number(9);
    ln_ope number(9);
    ln_cor number(10);
  
  begin
    begin
    
      IF pn_mod = 33 then
      
        ld_aofvalJ := null;
        begin
        
          select a.aofvto, a.aostat
            into ld_aofvto, ln_aostat
            from fsd010 a
           where a.pgcod = pn_emp
             and a.aomod = pn_mod
             and a.aosuc = pn_suc
             and a.aomda = pn_mda
             and a.aopap = pn_pap
             and a.aocta = pn_cta
             and a.aooper = pn_ope
             and a.aosbop = pn_sbo
             and a.aotope = pn_top;
        
        exception
          when others then
            ld_aofvto := null;
            ln_aostat := null;
          
        end;
      
        begin
          select a.jaql166scfvl
            into ld_aofvalC
            from jaql166 a
           where jaql166nrpag = 0
             and a.jaql166sccta = pn_cta
             and a.jaql166scope = pn_ope
             and a.jaql166scmod = pn_mod;
        exception
          when no_data_found then
            ld_aofvalC := null;
          when too_many_rows then
            begin
              select a.jaql166scfvl
                into ld_aofvalC
                from jaql166 a
               where jaql166nrpag = 0
                 and a.jaql166sccta = pn_cta
                 and a.jaql166scope = pn_ope
                 and a.jaql166scmod = pn_mod
                 and a.jaql166est = 90
                 and rownum = 1;
            exception
              when no_data_found then
                ld_aofvalC := null;
              
            end;
          
        end;
      
        begin
        
          select a.r1cta, a.r1oper
            into ln_cta, ln_ope
            from fsr011 a
           where a.r2mod = pn_mod
             and a.r2cta = pn_cta
             and a.r2oper = pn_ope
             and a.r2sbop = pn_sbo
             and a.r2cod = pn_emp
             and a.r2suc = pn_suc
             and a.r2mda = pn_mda
             and a.r2pap = pn_pap
             and a.r2tope = pn_top
             and a.relcod = 33
             and rownum = 1;
        
        exception
          when others then
            ln_cta := null;
            ln_ope := null;
          
        end;
      
        begin
          select a.jaqm33cor
            into ln_cor
            from jaqm27 a
           where a.jaqm27cta = ln_cta
             and a.jaqm27oper = ln_ope;
        exception
          when no_data_found then
            ln_cor := null;
          when too_many_rows then
            begin
              select a.jaqm33cor
                into ln_cor
                from jaqm27 a
               where a.jaqm27cta = ln_cta
                 and a.jaqm27oper = ln_ope
                 and a.jaqm27chr3 = 'FIRME'
                 and rownum = 1;
            exception
              when no_data_found then
                begin
                  select a.jaqm33cor
                    into ln_cor
                    from jaqm27 a
                   where a.jaqm27cta = ln_cta
                     and a.jaqm27oper = ln_ope
                     and rownum = 1;
                exception
                  when no_data_found then
                    ln_cor := null;
                end;
            end;
        end;
        begin
          select a.jaqm33fdem
            into ld_aofvalJ
            from jaqm33 a
           where a.jaqm33cor = ln_cor
             and rownum = 1;
        exception
          when no_data_found then
            ld_aofvalJ := null;
        end;
      
      End If;
    
      IF pn_mod = 200 then
      
        ld_aofvalC := null;
        begin
        
          select a.aofvto, a.aostat
            into ld_aofvto, ln_aostat
            from fsd010 a
           where a.pgcod = pn_emp
             and a.aomod = pn_mod
             and a.aosuc = pn_suc
             and a.aomda = pn_mda
             and a.aopap = pn_pap
             and a.aocta = pn_cta
             and a.aooper = pn_ope
             and a.aosbop = pn_sbo
             and a.aotope = pn_top;
        
        exception
          when others then
            ld_aofvto := null;
            ln_aostat := null;
          
        end;
      
        begin
          select a.jaqm33cor
            into ln_cor
            from jaqm27 a
           where a.jaqm27cta = pn_cta
             and a.jaqm27oper = pn_ope;
        exception
          when no_data_found then
            ln_cor := null;
          when too_many_rows then
            begin
              select a.jaqm33cor
                into ln_cor
                from jaqm27 a
               where a.jaqm27cta = pn_cta
                 and a.jaqm27oper = pn_ope
                 and a.jaqm27chr3 = 'FIRME'
                 and rownum = 1;
            exception
              when no_data_found then
                begin
                  select a.jaqm33cor
                    into ln_cor
                    from jaqm27 a
                   where a.jaqm27cta = pn_cta
                     and a.jaqm27oper = pn_ope
                     and rownum = 1;
                exception
                  when no_data_found then
                    ln_cor := null;
                end;
            end;
        end;
        begin
          select a.jaqm33fdem
            into ld_aofvalJ
            from jaqm33 a
           where a.jaqm33cor = ln_cor
             and rownum = 1;
        exception
          when no_data_found then
            ld_aofvalJ := null;
        end;
      
      End If;
    
    end;
  
  end Sp_cr_fsd010;

  Procedure Sp_cr_Avales(pn_ins in number,
                         pn_num out number,
                         pn_pai out number,
                         pn_tdo out number,
                         pc_doc out char,
                         pc_nom out char,
                         pc_tel out char) is
  
    ln_cta number(9);
  
  begin
  
    begin
    
      select count(a.sng003cta)
        into pn_num
        from sng003 a
       where a.sng001inst = pn_ins
         and a.sng003pgc = 1;
    exception
      when others then
        pn_num := 0;
    end;
  
    begin
    
      select a.sng003cta
        into ln_cta
        from sng003 a
       where a.sng001inst = pn_ins
         and a.sng003pgc = 1
         and rownum = 1;
    exception
      when others then
        ln_cta := null;
    end;
  
    begin
    
      select a.pepais, a.petdoc, a.pendoc
        into pn_pai, pn_tdo, pc_doc
        from fsr008 a
       where a.pgcod = 1
         and a.ctnro = ln_cta
         and a.cttfir = 'T'; --mod@abr 20190107
    exception
      when others then
        pn_pai := null;
        pn_tdo := null;
        pc_doc := null;
    end;
  
    begin
    
      select a.penom
        into pc_nom
        from fsd001 a
       where a.pepais = pn_pai
         and a.petdoc = pn_tdo
         and a.pendoc = pc_doc;
    exception
      when others then
        pc_nom := null;
      
    end;
  
    begin
    
      select a.dotelfp
        into pc_tel
        from fsr005 a
       where a.pepais = pn_pai
         and a.petdoc = pn_tdo
         and a.pendoc = pc_doc
         and a.docod = 1
         and rownum = 1;
    exception
      when others then
        pc_tel := null;
      
    end;
  
  end Sp_cr_Avales;

  function fn_tipSBS(pn_cta in number, pn_ope in number) return char is
    lc_tipsbs char(30);
    lc_codsbs char(2);
  begin
  
    begin
      select a.jqy470ctip
        into lc_codsbs
        from jaqy470c a
       where a.jqy470ccta = pn_cta
         and a.jqy470cope = pn_ope
         and rownum = 1;
    exception
      when no_data_found then
        lc_codsbs := null;
    end;
  
    begin
      select a.tpdesc
        into lc_tipsbs
        from FST098 a
       where Pgcod = 1
         and Tpcod = 7701
         and Tpcorr > 599
         and Tpcorr < 650
         and tpnro = to_number(lc_codsbs);
    exception
      when no_data_found then
        lc_tipsbs := null;
    end;
  
    return lc_tipsbs;
  end fn_tipSBS;

  Function Fn_cr_GarantiaTipo(pn_mod in number, pn_top in number) return char is
    lc_tip char(20);
  begin
  
    begin
    
      select case
               when a.tp1corr2 = 1 then
                'GARANTIAS INSCRITAS'
               when a.tp1corr2 = 2 then
                'BIENES DECLARADOS'
               when a.tp1corr2 = 3 then
                'AVALES'
               else
                null
             end
        into lc_tip
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10897
         and a.tp1corr1 = 500
         and a.tp1nro1 = pn_mod
         and a.tp1nro2 = pn_top;
    
    exception
      when others then
        lc_tip := null;
      
    end;
    return lc_tip;
  
  end Fn_cr_GarantiaTipo;

  Function Fn_Garantia_mto(pn_emp in number,
                           pn_mod in number,
                           pn_suc in number,
                           pn_mda in number,
                           pn_pap in number,
                           pn_cta in number,
                           pn_ope in number,
                           pn_sbo in number,
                           pn_top in number) return number is
    ln_mtogar number(17, 2);
  
  begin
  
    begin
    
      select a.scsdo
        into ln_mtogar
        from fsd011 a
       where a.pgcod = pn_emp
         and a.scsuc = pn_suc
         and a.scmda = pn_mda
         and a.scpap = pn_pap
         and a.sccta = pn_cta
         and a.scoper = pn_ope
         and a.scsbop = pn_sbo
         and a.sctope = pn_top
         and a.scmod = pn_mod
         and a.scstat = 54;
    exception
      when others then
        ln_mtogar := null;
      
    end;
    return ln_mtogar;
  
  end Fn_Garantia_mto;

  function fn_correlativo(pn_prop in number) return number is
    ln_corr number(30);
  begin
    begin
      select max(a.jaqz064cor)
        into ln_corr
        from jaqz064 a
       where a.jaqz064nro = pn_prop;
    
    exception
      when no_data_found then
        ln_corr := 0;
    end;
    if ln_corr is null then
      ln_corr := 0;
    else
      ln_corr := ln_corr + 1;
    end if;
  
    return ln_corr;
  end fn_correlativo;

  function fn_correlativo_II(pn_prop in number) return number is
    ln_corr number(30);
  begin
    begin
      select max(a.jaqz064cor)
        into ln_corr
        from jaqz064 a
       where a.jaqz064nro = pn_prop;
    
    exception
      when no_data_found then
        ln_corr := 0;
    end;
    if ln_corr is null then
      ln_corr := 0;
    else
      ln_corr := ln_corr + 1;
    end if;
  
    return ln_corr;
  end fn_correlativo_II;

  function fn_fechafin(pd_fecha in date) return date is
  
    ld_finme  date;
    lc_diafm  char(2);
    lc_diaaux char(2);
    ld_fecha  date;
    ln_mes    number(2);
    lc_dia    char(2);
    lc_ani    char(4);
    ln_mesant number(2);
    lc_mesant char(2);
    ld_fec    date;
    ln_ani    number(4);
  
  begin
  
    begin
      ld_finme  := last_day(pd_fecha);
      lc_diafm  := to_char(ld_finme, 'dd');
      lc_diaaux := to_char(pd_fecha, 'dd');
    
      if lc_diaaux = lc_diafm then
        ld_fecha := pd_fecha;
      else
        ln_mes := to_number(to_char(pd_fecha, 'mm'));
        lc_dia := to_char(pd_fecha, 'dd');
        ln_ani := to_number(to_char(pd_fecha, 'yyyy'));
      
        if ln_mes = 1 then
          ln_mesant := 12;
          ln_ani    := ln_ani - 1;
        else
          ln_mesant := ln_mes - 1;
        end if;
      
        lc_mesant := to_char(ln_mesant);
        lc_ani    := to_char(ln_ani);
        ld_fec    := to_date(lc_ani || lc_mesant || lc_dia, 'yyyymmdd');
        ld_fecha  := last_day(ld_fec);
      
      end if;
    
    end;
    return ld_fecha;
  end fn_fechafin;

  function fn_cl_telefonos(lv_pepais in number,
                           lv_petdoc in number,
                           lv_pendoc in char,
                           pn_tip    in number) return varchar2 IS
  
    lv_pendoc2   char(12);
    lv_telefonos varchar2(50);
  
    cursor c_tele_pers is
      select Dotelfp
        from Fsr005
       Where Pepais = lv_pepais
         and Petdoc = lv_petdoc
         and Pendoc = lv_pendoc2
         and Docod = pn_tip;
  
  BEGIN
    lv_pendoc2 := lv_pendoc;
  
    for i in c_tele_pers loop
      lv_telefonos := lv_telefonos || trim(i.Dotelfp) || '|';
    end loop;
    lv_telefonos := substr(lv_telefonos, 1, length(lv_telefonos) - 1);
    return lv_telefonos;
  
  EXCEPTION
    when others then
      return null;
    
  END fn_cl_telefonos;

  Procedure Sp_Garantias(pn_nro in number,
                         pn_emp in number,
                         pn_mod in number,
                         pn_suc in number,
                         pn_mda in number,
                         pn_pap in number,
                         pn_cta in number,
                         pn_ope in number,
                         pn_sbo in number,
                         pn_top in number) is
  
    cursor garantias(pn_emp in number,
                     pn_mod in number,
                     pn_suc in number,
                     pn_mda in number,
                     pn_pap in number,
                     pn_cta in number,
                     pn_ope in number,
                     pn_sbo in number,
                     pn_top in number) is
    
      select (select d.tonom
                from fst004 d
               where d.modulo = a.jaqy954mod1
                 and d.totope = a.jaqy954top1) tipgar,
             pq_cr_venta.Fn_Garantia_mto(a.jaqy954emp1,
                                         a.jaqy954mod1,
                                         a.jaqy954suc1,
                                         a.jaqy954mda1,
                                         a.jaqy954pap1,
                                         a.jaqy954cta1,
                                         a.jaqy954ope1,
                                         a.jaqy954sbo1,
                                         a.jaqy954top1) mtogar
        from jaqy954 a
       where (a.jaqy954est = 'S' OR a.jaqy954est IS NULL)
         and nvl(a.jaqy954vig, 'S') = 'S'
         and jaqy952nro = pn_nro
         and jaqy954emp2 = pn_emp
         and jaqy954suc2 = pn_suc
         and jaqy954cta2 = pn_cta
         and jaqy954pap2 = pn_pap
         and jaqy954ope2 = pn_ope
         and jaqy954sbo2 = pn_sbo
         and jaqy954mda2 = pn_mda
         and jaqy954mod2 = pn_mod
         and jaqy954top2 = pn_top;
    ln_count number(6);
  begin
    ln_count := 0;
  
    begin
    
      for i in garantias(pn_emp,
                         pn_mod,
                         pn_suc,
                         pn_mda,
                         pn_pap,
                         pn_cta,
                         pn_ope,
                         pn_sbo,
                         pn_top) loop
      
        ln_count := ln_count + 1;
      
        if ln_count = 1 and ln_count <= 6 then
        
          update jaqz064 f
             set jaqz064tg1 = i.tipgar, jaqz064mg1 = i.mtogar
           where f.jaqz064pgc = pn_emp
             and f.jaqz064mod = pn_mod
             and f.jaqz064suc = pn_suc
             and f.jaqz064mda = pn_mda
             and f.jaqz064pap = pn_pap
             and f.jaqz064cta = pn_cta
             and f.jaqz064ope = pn_ope
             and f.jaqz064sbo = pn_sbo
             and f.jaqz064top = pn_top;
        
          commit;
        
        end if;
      
        if ln_count = 2 and ln_count <= 6 then
        
          update jaqz064 f
             set jaqz064tg2 = i.tipgar, jaqz064mg2 = i.mtogar
           where f.jaqz064pgc = pn_emp
             and f.jaqz064mod = pn_mod
             and f.jaqz064suc = pn_suc
             and f.jaqz064mda = pn_mda
             and f.jaqz064pap = pn_pap
             and f.jaqz064cta = pn_cta
             and f.jaqz064ope = pn_ope
             and f.jaqz064sbo = pn_sbo
             and f.jaqz064top = pn_top;
        
          commit;
        
        end if;
      
        if ln_count = 3 and ln_count <= 6 then
        
          update jaqz064 f
             set jaqz064tg3 = i.tipgar, jaqz064mg3 = i.mtogar
           where f.jaqz064pgc = pn_emp
             and f.jaqz064mod = pn_mod
             and f.jaqz064suc = pn_suc
             and f.jaqz064mda = pn_mda
             and f.jaqz064pap = pn_pap
             and f.jaqz064cta = pn_cta
             and f.jaqz064ope = pn_ope
             and f.jaqz064sbo = pn_sbo
             and f.jaqz064top = pn_top;
        
          commit;
        
        end if;
      
        if ln_count = 4 and ln_count <= 6 then
        
          update jaqz064 f
             set jaqz064tg4 = i.tipgar, jaqz064mg4 = i.mtogar
           where f.jaqz064pgc = pn_emp
             and f.jaqz064mod = pn_mod
             and f.jaqz064suc = pn_suc
             and f.jaqz064mda = pn_mda
             and f.jaqz064pap = pn_pap
             and f.jaqz064cta = pn_cta
             and f.jaqz064ope = pn_ope
             and f.jaqz064sbo = pn_sbo
             and f.jaqz064top = pn_top;
        
          commit;
        
        end if;
      
        if ln_count = 5 and ln_count <= 6 then
        
          update jaqz064 f
             set jaqz064tg5 = i.tipgar, jaqz064mg5 = i.mtogar
           where f.jaqz064pgc = pn_emp
             and f.jaqz064mod = pn_mod
             and f.jaqz064suc = pn_suc
             and f.jaqz064mda = pn_mda
             and f.jaqz064pap = pn_pap
             and f.jaqz064cta = pn_cta
             and f.jaqz064ope = pn_ope
             and f.jaqz064sbo = pn_sbo
             and f.jaqz064top = pn_top;
        
          commit;
        
        end if;
      
        if ln_count = 6 and ln_count <= 6 then
        
          update jaqz064 f
             set jaqz064tg6 = i.tipgar, jaqz064mg6 = i.mtogar
           where f.jaqz064pgc = pn_emp
             and f.jaqz064mod = pn_mod
             and f.jaqz064suc = pn_suc
             and f.jaqz064mda = pn_mda
             and f.jaqz064pap = pn_pap
             and f.jaqz064cta = pn_cta
             and f.jaqz064ope = pn_ope
             and f.jaqz064sbo = pn_sbo
             and f.jaqz064top = pn_top;
        
          commit;
        
        end if;
      
      end loop;
    
    end;
  
  end Sp_Garantias;

  Procedure Sp_fechaUltimoPag(pn_cta in number,
                              pn_ope in number,
                              pd_fec out date) is
  
    ld_fec date;
  begin
    begin
      select distinct fecha_pago
        into ld_fec
        from (select distinct j.lote,
                              j.cuenta,
                              j.operacion,
                              j.modulo,
                              i.moneda,
                              i.mod,
                              i.trans,
                              i.sucu,
                              i.hnrel,
                              i.fecha_pago,
                              z.hhora,
                              sum(i.pago) pago
                from JAQZ509 j,
                     (select d.hcta,
                             d.hoper,
                             d.mod,
                             d.trans,
                             d.sucu,
                             d.hnrel,
                             d.fecha_pago,
                             q.pago,
                             q.moneda
                        from JAQZ510 q,
                             JAQZ511 w,
                             (select t.hcta,
                                     t.hoper,
                                     t.mod,
                                     t.trans,
                                     t.sucu,
                                     t.hnrel,
                                     t.fecha_pago
                                from JAQZ510 t, JAQZ511 o
                               where t.mod = o.tp1corr1
                                 and t.trans = o.tp1corr2
                                 and o.tp1corr3 = t.ordinal
                                 and o.tp1nro2 = 2
                               group by t.hcta,
                                        t.hoper,
                                        t.mod,
                                        t.trans,
                                        t.sucu,
                                        t.hnrel,
                                        t.fecha_pago
                              minus
                              select t.hcta,
                                     t.hoper,
                                     t.mod,
                                     t.trans,
                                     t.sucu,
                                     t.hnrel,
                                     t.fecha_pago
                                from JAQZ510 t, JAQZ511 o
                               where t.mod = o.tp1corr1
                                 and t.trans = o.tp1corr2
                                 and o.tp1corr3 = t.ordinal
                                 and o.tp1nro2 = 1
                               group by t.hcta,
                                        t.hoper,
                                        t.mod,
                                        t.trans,
                                        t.sucu,
                                        t.hnrel,
                                        t.fecha_pago) d
                       where d.hcta = q.hcta
                         and d.hoper = q.hoper
                         and d.mod = q.mod
                         and d.trans = q.trans
                         and d.sucu = q.sucu
                         and d.hnrel = q.hnrel
                         and d.fecha_pago = q.fecha_pago
                         and w.tp1corr1 = q.mod
                         and w.tp1corr2 = q.trans
                         and w.tp1corr3 = q.ordinal
                         and w.tp1nro2 = 2
                      
                      union
                      select t.hcta,
                             t.hoper,
                             t.mod,
                             t.trans,
                             t.sucu,
                             t.hnrel,
                             t.fecha_pago,
                             t.pago,
                             t.moneda
                        from JAQZ510 t, JAQZ511 o
                       where t.mod = o.tp1corr1
                         and t.trans = o.tp1corr2
                         and o.tp1corr3 = t.ordinal
                         and o.tp1nro2 = 1
                       group by t.hcta,
                                t.hoper,
                                t.mod,
                                t.trans,
                                t.sucu,
                                t.hnrel,
                                t.fecha_pago,
                                t.pago,
                                t.moneda) i,
                     fsh015 z,
                     (select c.lote,
                             c.cuenta,
                             c.operacion,
                             c.modulo,
                             p.moneda,
                             max(p.fecha_pago) ULTIMO_PAGO,
                             sum(p.pago) PAGO
                      
                        from JAQZ509 c,
                             (select d.hcta,
                                     d.hoper,
                                     d.mod,
                                     d.trans,
                                     d.sucu,
                                     d.hnrel,
                                     d.fecha_pago,
                                     q.pago,
                                     q.moneda
                                from JAQZ510 q,
                                     JAQZ511 w,
                                     (select t.hcta,
                                             t.hoper,
                                             t.mod,
                                             t.trans,
                                             t.sucu,
                                             t.hnrel,
                                             t.fecha_pago
                                        from JAQZ510 t, JAQZ511 o
                                       where t.mod = o.tp1corr1
                                         and t.trans = o.tp1corr2
                                         and o.tp1corr3 = t.ordinal
                                         and o.tp1nro2 = 2
                                       group by t.hcta,
                                                t.hoper,
                                                t.mod,
                                                t.trans,
                                                t.sucu,
                                                t.hnrel,
                                                t.fecha_pago
                                      minus
                                      select t.hcta,
                                             t.hoper,
                                             t.mod,
                                             t.trans,
                                             t.sucu,
                                             t.hnrel,
                                             t.fecha_pago
                                        from JAQZ510 t, JAQZ511 o
                                       where t.mod = o.tp1corr1
                                         and t.trans = o.tp1corr2
                                         and o.tp1corr3 = t.ordinal
                                         and o.tp1nro2 = 1
                                       group by t.hcta,
                                                t.hoper,
                                                t.mod,
                                                t.trans,
                                                t.sucu,
                                                t.hnrel,
                                                t.fecha_pago) d
                               where d.hcta = q.hcta
                                 and d.hoper = q.hoper
                                 and d.mod = q.mod
                                 and d.trans = q.trans
                                 and d.sucu = q.sucu
                                 and d.hnrel = q.hnrel
                                 and d.fecha_pago = q.fecha_pago
                                 and w.tp1corr1 = q.mod
                                 and w.tp1corr2 = q.trans
                                 and w.tp1corr3 = q.ordinal
                                 and w.tp1nro2 = 2
                              
                              union
                              select t.hcta,
                                     t.hoper,
                                     t.mod,
                                     t.trans,
                                     t.sucu,
                                     t.hnrel,
                                     t.fecha_pago,
                                     t.pago,
                                     t.moneda
                                from JAQZ510 t, JAQZ511 o
                               where t.mod = o.tp1corr1
                                 and t.trans = o.tp1corr2
                                 and o.tp1corr3 = t.ordinal
                                 and o.tp1nro2 = 1
                               group by t.hcta,
                                        t.hoper,
                                        t.mod,
                                        t.trans,
                                        t.sucu,
                                        t.hnrel,
                                        t.fecha_pago,
                                        t.pago,
                                        t.moneda) p
                       where c.cuenta = p.hcta(+)
                         and c.operacion = p.hoper(+)
                      
                       group by c.lote,
                                c.cuenta,
                                c.operacion,
                                c.modulo,
                                p.moneda
                      
                      ) w
               where w.ULTIMO_PAGO = i.fecha_PAGO(+)
                 and w.cuenta = i.hcta(+)
                 and w.operacion = i.hoper(+)
                 and w.cuenta = j.cuenta
                 and w.operacion = j.operacion
                 and z.pgcod(+) = 1
                 and z.hcmod(+) = i.mod
                 and z.hsucor(+) = i.sucu
                 and z.htran(+) = i.trans
                 and z.hnrel(+) = i.hnrel
                 and z.hfcon(+) = i.fecha_pago
                 and w.cuenta = pn_cta
                 and w.operacion = pn_ope
                 and rownum = 1
               group by j.lote,
                        j.cuenta,
                        j.operacion,
                        j.modulo,
                        i.moneda,
                        i.mod,
                        i.trans,
                        i.sucu,
                        i.hnrel,
                        i.fecha_pago,
                        z.hhora);
    
    exception
      when others then
        null;
    end;
  
    if ld_fec is null then
      begin
        select max(a.hfcon)
          into ld_fec
          from fsh016 a, fsh015 b
         where a.pgcod = 1
           and a.pgcod = b.pgcod
           and a.hcmod = b.hcmod
           and a.hsucor = b.hsucor
           and a.htran = b.htran
           and a.hnrel = b.hnrel
           and a.hfcon = b.hfcon
           and a.hcta = pn_cta
           and a.hoper = pn_ope
           and a.hcmod not in
               (99, 599, 300, 98, 499, 600, 598, 490, 116, 530)
           and a.hcord = 10
           and a.htran not in (360, 951, 950, 351, 360, 931);
      exception
        when too_many_rows then
          begin
            select max(a.hfcon)
              into ld_fec
              from fsh016 a, fsh015 b
             where a.pgcod = 1
               and a.pgcod = b.pgcod
               and a.hcmod = b.hcmod
               and a.hsucor = b.hsucor
               and a.htran = b.htran
               and a.hnrel = b.hnrel
               and a.hfcon = b.hfcon
               and a.hcta = pn_cta
               and a.hoper = pn_ope
               and a.hcmod not in
                   (99, 599, 300, 98, 499, 600, 598, 490, 116, 530)
               and a.hcord = 10
               and a.htran not in (360, 951, 950, 351, 360, 931)
               and rownum = 1;
          exception
            when others then
              null;
          end;
        when others then
          null;
      end;
    end if;
  
    pd_fec := ld_fec;
  
  end Sp_fechaUltimoPag;

  procedure sp_cr_ubigeo(pn_pai     in number,
                         pn_tdo     in number,
                         pc_doc     in char,
                         P_C_ubigeo out char) is
  
  begin
  
    begin
      select trim(s.sngc13ugeo)
        into P_C_ubigeo
        from sngc13 s, fst071 f
       where f.fst071pai = s.sngc13pais
         and f.fst071col = s.sngc13dist
         and s.sngc13pdoc = pn_pai
         and s.sngc13tdoc = pn_tdo
         and s.sngc13ndoc = pc_doc
         and s.docod = 1
         and s.sngc13est = 'H'
         and rownum < 2;
    
    exception
      when others then
      
        P_C_ubigeo := ' ';
      
    end;
  
  end sp_cr_ubigeo;

  procedure sp_cr_DPTO_PROV_DIS(pc_ubigeo in char,
                                pc_dpto   out char,
                                pc_prov   out char,
                                pc_dist   out char) is
  
  begin
  
    begin
      select depnom DPTO, locnom PROVINCIA, fst071dsc DISTRITO
        into pc_dpto, pc_prov, pc_dist
        from fst068 f, fst070 h, fst071 g
       where h.pais = f.pais
         and h.depcod = f.depcod
         and h.loccod = g.fst071loc
         and f.pais = g.fst071pai
         and f.depcod = g.fst071dpt
         and g.fst071col = pc_ubigeo;
    exception
      when others then
        pc_dpto := ' ';
        pc_prov := ' ';
        pc_dist := ' ';
    end;
  
  end sp_cr_DPTO_PROV_DIS;

  Procedure Sp_creditoInicial(pn_emp  in number,
                              pn_mod  in number,
                              pn_suc  in number,
                              pn_mda  in number,
                              pn_pap  in number,
                              pn_cta  in number,
                              pn_ope  in number,
                              pn_sbo  in number,
                              pn_top  in number,
                              pn_empI out number,
                              pn_modI out number,
                              pn_sucI out number,
                              pn_mdaI out number,
                              pn_papI out number,
                              pn_ctaI out number,
                              pn_opeI out number,
                              pn_sboI out number,
                              pn_topI out number) is
  begin
  
    begin
      select a.r1cod,
             a.r1mod,
             a.r1suc,
             a.r1mda,
             a.r1pap,
             a.r1cta,
             a.r1oper,
             a.r1sbop,
             a.r1tope
        into pn_empI,
             pn_modI,
             pn_sucI,
             pn_mdaI,
             pn_papI,
             pn_ctaI,
             pn_opeI,
             pn_sboI,
             pn_topI
        from fsr011 a
       where a.r2cod = pn_emp
         and a.r2mod = pn_mod
         and a.r2suc = pn_suc
         and a.r2mda = pn_mda
         and a.r2pap = pn_pap
         and a.r2cta = pn_cta
         and a.r2oper = pn_ope
         and a.r2sbop = pn_sbo
         and a.r2tope = pn_top
         and a.relcod = 52;
    exception
      when others then
        null;
    end;
  
    if pn_ctaI is null then
      pq_cr_venta.sp_cr_credini(pn_cta,
                                pn_ope,
                                pn_empI,
                                pn_modI,
                                pn_sucI,
                                pn_mdaI,
                                pn_papI,
                                pn_ctaI,
                                pn_opeI,
                                pn_sboI,
                                pn_topI);
    end if;
  
  end Sp_creditoInicial;
end PQ_CR_VENTA;
/

