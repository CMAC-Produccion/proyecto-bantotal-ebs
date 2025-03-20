create or replace package PQ_CR_ADELANTO_SUELDO is
  -- *****************************************************************
  -- Nombre                     : PQ_CR_ADELANTO_SUELDO 
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos
  -- Versión                    : 1.0
  -- Fecha de Creación          : 2020.04.04
  -- Autor de Creación          : DCASTOR
  -- Uso                        : PARA GENERACION DIAS DE ATRASO POR EMERGENCIA COV19
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 2021.04.25
  -- Autor de Modificación      : DCASTRO
  -- Descripción de Modificación: 
  --
  --  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  ----------------------------------------------------------------------------------------
  procedure sp_cr_insert_update(v_Pgcod     in number,
                                v_Scmod     in number,
                                v_Scsuc     in number,
                                v_Scmda     in number,
                                v_Scpap     in number,
                                v_Sccta     in number,
                                v_Scoper    in number,
                                v_Scsbop    in number,
                                v_Sctope    in number,
                                v_Pgcoda    in number,
                                v_Scmoda    in number,
                                v_Scsuca    in number,
                                v_Scmdaa    in number,
                                v_Scpapa    in number,
                                v_Scctaa    in number,
                                v_Scopea    in number,
                                v_Scsbopa   in number,
                                v_Sctopea   in number,
                                v_pgcodt    in number,
                                v_suct      in number,
                                v_modt      in number,
                                v_ttran     in number,
                                v_relt      in number,
                                v_itfcon    in date,
                                v_pais      in number,
                                v_tdoc      in number,
                                v_pendoc    in char,
                                v_monto     in number,
                                v_analista  in varchar2,
                                v_fecpri    in date,
                                v_instancia in number,
                                v_cuota     in number,
                                v_rpta      out varchar2);

  ----------------------------------------------------------------------------------------
  procedure sp_cr_validar_oferta(pepais in number,
                                 petdoc in number,
                                 pendoc in varchar2,
                                 rpta   out varchar2,
                                 descri out varchar2);
  ----------------------------------------------------------------------------------------
  procedure sp_validar_iletrado(ve_pepais in number,
                                ve_petdoc in number,
                                ve_pendoc in varchar2,
                                vo_rpta   out varchar2);
  ----------------------------------------------------------------------------------------
  procedure sp_cr_val_crd_exist(pepais in number,
                                petdoc in number,
                                pendoc in varchar2,
                                rpta   out varchar2);
  ----------------------------------------------------------------------------------------
  procedure sp_cr_cargaAQPB606(ve_pepais in number,
                               ve_petdoc in number,
                               ve_pendoc in varchar2);
  -----------------------------------------------------------------------                               
  procedure sp_cr_cargaAQPB607(ve_pepais in number,
                               ve_petdoc in number,
                               ve_pendoc in varchar2,
                               vo_rpta   out varchar);
  -----------------------------------------------------------------------------------------
  FUNCTION RCC_FN_CUO_SF(VE_PEPAIS IN NUMBER,
                         VE_PETDOC IN NUMBER,
                         VE_PENDOC IN VARCHAR2) RETURN NUMBER;
  -----------------------------------------------------------------------------------------
  FUNCTION RCC_FN_MTO_CTA_CTBLE_SC(VE_PC_CODSBS IN VARCHAR2,
                                   VE_PD_FECPRE IN DATE,
                                   VE_PC_CUENTA IN VARCHAR2) RETURN NUMBER;
  -----------------------------------------------------------------------------------------
  FUNCTION RCC_FN_MTO_DEUDA_ENT(PC_CODSBS IN VARCHAR2,
                                PD_FECPRE IN DATE,
                                PC_CODENT IN VARCHAR2) RETURN NUMBER;
  -----------------------------------------------------------------------------------------
  FUNCTION RCC_FN_CUO_PT(VE_PEPAIS IN NUMBER,
                         VE_PETDOC IN NUMBER,
                         VE_PENDOC IN VARCHAR2) return number;
end PQ_CR_ADELANTO_SUELDO;
/

create or replace package body PQ_CR_ADELANTO_SUELDO is

  ----------------------------------------------------------------------
  procedure sp_cr_insert_update(v_Pgcod     in number,
                                v_Scmod     in number,
                                v_Scsuc     in number,
                                v_Scmda     in number,
                                v_Scpap     in number,
                                v_Sccta     in number,
                                v_Scoper    in number,
                                v_Scsbop    in number,
                                v_Sctope    in number,
                                v_Pgcoda    in number,
                                v_Scmoda    in number,
                                v_Scsuca    in number,
                                v_Scmdaa    in number,
                                v_Scpapa    in number,
                                v_Scctaa    in number,
                                v_Scopea    in number,
                                v_Scsbopa   in number,
                                v_Sctopea   in number,
                                v_pgcodt    in number,
                                v_suct      in number,
                                v_modt      in number,
                                v_ttran     in number,
                                v_relt      in number,
                                v_itfcon    in date,
                                v_pais      in number,
                                v_tdoc      in number,
                                v_pendoc    in char,
                                v_monto     in number,
                                v_analista  in varchar2,
                                v_fecpri    in date,
                                v_instancia in number,
                                v_cuota     in number,
                                v_rpta      out varchar2) is
  
    lc_coderr varchar2(1);
    lc_hora   varchar2(8);
    ln_corr   number;
  
  BEGIN
  
    lc_coderr := 'N';
  
    begin
      select count(*)
        into ln_corr
        from fsr601 f
       where f.pp3cod = v_Pgcod
         and f.pp3mod = v_Scmod
         and f.pp3suc = v_Scsuc
         and f.pp3cta = v_Sccta
         and f.pp3mda = v_Scmda
         and f.pp3pap = v_Scpap
         and f.pp3oper = v_Scoper
         and f.pp3sbop = v_Scsbop
         and f.pp3tope = v_Sctope;
    exception
      when others then
        ln_corr := 0;
    end;
  
    ln_corr := ln_corr + 1;
  
    begin
      insert into fsr601
        (pp3cod,
         pp3mod,
         pp3suc,
         pp3cta,
         pp3mda,
         pp3pap,
         pp3oper,
         pp3sbop,
         pp3tope,
         pp3corr,
         pp4cod,
         pp4mod,
         pp4suc,
         pp4cta,
         pp4mda,
         pp4pap,
         pp4oper,
         pp4sbop,
         pp4tope,
         pp4sobr,
         pp4parc)
      values
        (v_Pgcod,
         v_Scmod,
         v_Scsuc,
         v_Sccta,
         v_Scmda,
         v_Scpap,
         v_Scoper,
         v_Scsbop,
         v_Sctope,
         ln_corr,
         v_Pgcoda,
         v_Scmoda,
         v_Scsuca,
         v_Scctaa,
         v_Scmdaa,
         v_Scpapa,
         v_Scopea,
         v_Scsbopa,
         v_Sctopea,
         'N',
         'S');
      lc_coderr := 'S';
      commit;
    exception
      when others then
        lc_coderr := 'N';
    end;
  
    ---obtener hora de trx
    begin
      select f.ithora
        into lc_hora
        from fsd015 f
       where f.pgcod = v_pgcodt
         and f.itsuc = v_suct
         and f.itmod = v_modt
         and f.ittran = v_ttran
         and f.itnrel = v_relt
         and f.itfcon = v_itfcon;
    exception
      when others then
        lc_hora := null;
    end;
  
    /*
    ACTUALIZAR FECHA DE PRIMER PAGO
    ACTUALIZAR ANALISTA
    
    
    */
    ---actualizar en aqpb607
    begin
      update aqpb607 a
         set a.aqpb607pgcoc  = v_Pgcod,
             a.aqpb607succ   = v_Scsuc,
             a.aqpb607monc   = v_Scmda,
             a.aqpb607papc   = v_Scpap,
             a.aqpb607ctac   = v_Sccta,
             a.aqpb607opec   = v_Scoper,
             a.aqpb607sopec  = v_Scsbop,
             a.aqpb607pgcot  = v_pgcodt,
             a.aqpb607itsuc  = v_suct,
             a.aqpb607itmod  = v_modt,
             a.aqpb607ittran = v_ttran,
             a.aqpb607itnrel = v_relt,
             a.aqpb607itfcon = v_itfcon,
             a.aqpb607fecd   = v_itfcon,
             a.aqpb607hord   = lc_hora,
             a.aqpb607fec1   = v_fecpri,
             a.aqpb607ana    = v_analista,
             a.aqpb607ins    = v_instancia,
             a.aqpb607cuo    = v_cuota
       where a.aqpb607pgco = v_Pgcoda
         and a.aqpb607mod = v_Scmoda
         and a.aqpb607suc = v_Scsuca
         and a.aqpb607mon = v_Scmdaa
         and a.aqpb607pap = v_Scpapa
         and a.aqpb607cta = v_Scctaa
         and a.aqpb607ope = v_Scopea
         and a.aqpb607sope = v_Scsbopa
         and a.aqpb607tipo = v_Sctopea
         and a.aqpb607mond = v_monto
         and a.aqpb607est = 'H';
    
      update aqpb606 b
         set b.aqpb606pgcoc = v_Pgcod,
             b.aqpb606modc  = v_Scmod,
             b.aqpb606succ  = v_Scsuc,
             b.aqpb606monc  = v_Scmda,
             b.aqpb606papc  = v_Scpap,
             b.aqpb606ctac  = v_Sccta,
             b.aqpb606opec  = v_Scoper,
             b.aqpb606sopec = v_Scsbop,
             b.aqpb606tipoc = v_Sctope
       where b.aqpb606pgco = v_Pgcoda
         and b.aqpb606mod = v_Scmoda
         and b.aqpb606suc = v_Scsuca
         and b.aqpb606mon = v_Scmdaa
         and b.aqpb606pap = v_Scpapa
         and b.aqpb606cta = v_Scctaa
         and b.aqpb606ope = v_Scopea
         and b.aqpb606sope = v_Scsbopa
         and b.aqpb606tipo = v_Sctopea
         and b.aqpb606est = 'H';
    
      lc_coderr := 'S';
      commit;
    exception
      when others then
        lc_coderr := 'N';
    end;
  
    v_rpta := lc_coderr;
    --        
  END sp_cr_insert_update;
  ------------------------------------------------------------------------------------
  procedure sp_validar_iletrado(ve_pepais in number,
                                ve_petdoc in number,
                                ve_pendoc in varchar2,
                                vo_rpta   out varchar2) IS
    vi_cont number(2);
  BEGIN
    vi_cont := 0;
    BEGIN
      SELECT count(*)
        INTO vi_cont
        FROM FSE002 F
       WHERE F.pfxpais = ve_pepais
         AND F.PFXTDOC = ve_petdoc
         AND F.PFXNDOC = lpad(ve_pendoc, 12, ' ')
         AND F.NINSCOD = 1;
    EXCEPTION
      WHEN OTHERS THEN
        vi_cont := 0;
    END;
    if vi_cont > 0 then
      vo_rpta := 'S';
    else
      vo_rpta := 'N';
    end if;
  
  END;
  --------------------------------------------------------------------
  procedure sp_cr_validar_oferta(pepais in number,
                                 petdoc in number,
                                 pendoc in varchar2,
                                 rpta   out varchar2,
                                 descri out varchar2) is
  BEGIN
    rpta := 'N';
    PQ_CR_ADELANTO_SUELDO.sp_cr_cargaAQPB606(pepais, petdoc, pendoc);
    PQ_CR_ADELANTO_SUELDO.sp_cr_cargaAQPB607(pepais, petdoc, pendoc, rpta);
    --rpta   := 'S';
    descri := null;
  end;

  procedure sp_cr_val_crd_exist(pepais in number,
                                petdoc in number,
                                pendoc in varchar2,
                                rpta   out varchar2) is
  
    CURSOR lst_cuentas(lv_pepais fsr008.pepais%TYPE,
                       lv_petdoc fsr008.petdoc%TYPE,
                       lv_pendoc fsr008.pendoc%TYPE) IS
      select ctnro
        from fsr008
       where pepais = lv_pepais
         and petdoc = lv_petdoc
         and pendoc = lv_pendoc
         and cttfir = 'T';
  
    lvo_ctnro fsr008.ctnro%TYPE; -- cuenta encontrada
  
  begin
    FOR i in lst_cuentas(pepais, petdoc, pendoc) LOOP
    
      begin
        select aocta, 'S'
          into lvo_ctnro, rpta
          from fsd010
         where pgcod = 1
           and aomod = 106 --modulo
           and aotope in (96, 97)
           and aocta = i.ctnro
           and aostat <> 99
           and rownum = 1;
      
        /*DBMS_OUTPUT.PUT_LINE ('****************************************');
        DBMS_OUTPUT.PUT_LINE (lvo_ctnro);
        DBMS_OUTPUT.PUT_LINE (rpta);*/
        if rpta = 'S' then
          exit;
        end if;
      exception
        when others then
          rpta := 'N';
          /*DBMS_OUTPUT.PUT_LINE ('****************************************');
          DBMS_OUTPUT.PUT_LINE (rpta);
          DBMS_OUTPUT.PUT_LINE (sqlerrm);*/
      end;
    END LOOP;
    --DBMS_OUTPUT.PUT_LINE ('SALIMOSSSSS');
  end;
  ----------------------------------------------------------------------
  procedure sp_cr_cargaAQPB606(ve_pepais in number,
                               ve_petdoc in number,
                               ve_pendoc in varchar2) is
  
    ln_pais              number;
    ln_tdoc              number;
    lc_ndoc              varchar2(12);
    ld_FchSist           date;
    ln_TipViv            number;
    lc_FlagTipViv        varchar2(5);
    lc_FlagCredJud       varchar2(5);
    ln_abon_prom         number(17, 2);
    ln_abon_min          number(17, 2);
    ln_prcn_dif          number;
    lv_resp_prom         varchar2(5);
    lv_resp_min          varchar2(5);
    lv_resp_dif          varchar2(5);
    lc_FlgSobreEndeudado varchar2(5);
    lc_ListNegra         varchar2(5);
    lc_Es100N            varchar2(5);
    ln_AtrasoMax         number := 0;
    lc_EsTrabjdor        varchar2(5);
    lc_Iletrado          varchar2(5);
    ln_SaldConsolidado   number(17, 2);
    ln_tipocambio        number(14, 8);
    lc_TnCredAdSueld     varchar2(5);
    lc_IndAbon6M         varchar2(5);
    lc_DescJud           varchar2(5);
    ln_tasa              number(14, 6);
    ln_deudaCMAC         number(17, 2);
    ln_DeudaIFIS         number(17, 2);
    ln_Ratio             number(10, 6);
    ln_maxfech607        date;
    ln_pgcod             number;
    ln_mod               number;
    ln_suc               number;
    ln_mda               number;
    ln_pap               number;
    ln_cta               number;
    ln_ope               number;
    ln_sbop              number;
    ln_tope              number;
    lc_ScoreSeguimiento  varchar2(25);
    ln_ingneto           number(17, 2) := 0.00;
    ln_mntprop           number;
    ln_cuotas            number;
  
  begin
  
    begin
      select max(a.aqpb607fecc) into ln_maxfech607 from aqpb607 a;
    end;
  
    lc_ndoc := trim(ve_pendoc);
  
    begin
      select distinct a.aqpb607pgco,
                      a.aqpb607mod,
                      a.aqpb607suc,
                      a.aqpb607mon,
                      a.aqpb607pap,
                      a.aqpb607cta,
                      a.aqpb607ope,
                      a.aqpb607sope,
                      a.aqpb607tipo
        into ln_pgcod,
             ln_mod,
             ln_suc,
             ln_mda,
             ln_pap,
             ln_cta,
             ln_ope,
             ln_sbop,
             ln_tope
        from aqpb607 a
       where a.aqpb607paid = ve_pepais
         and a.aqpb607tipd = ve_petdoc
            -- and trim(a.aqpb607numd) = ve_pendoc
         and a.aqpb607numd = lc_ndoc
         and a.aqpb607fecc = ln_maxfech607;
    exception
      when others then
        null;
    end;
  
    if ln_cta > 0 then
    
      begin
        select a.aqpb606proa, a.aqpb606mntm, a.aqpb606ilet
          into ln_ingneto, ln_abon_min, lc_Iletrado
          from aqpb606 a
         where a.aqpb606pgco = ln_pgcod
           and a.aqpb606mod = ln_mod
           and a.aqpb606suc = ln_suc
           and a.aqpb606mon = ln_mda
           and a.aqpb606pap = ln_pap
           and a.aqpb606cta = ln_cta
           and a.aqpb606ope = ln_ope
           and a.aqpb606sope = ln_sbop
           and a.aqpb606tipo = ln_tope
           and a.aqpb606fecc = ln_maxfech607
           and a.aqpb606est = 'H'
           and a.aqpb606tcarg = 'M';
      end;
    
      --for i in inicio(jj.ctnro) loop
    
      if ln_cta > 0 then
      
        lc_FlagTipViv        := 'N';
        lc_FlagCredJud       := 'N';
        lc_FlgSobreEndeudado := 'N';
      
        begin
          select f.pgfape into ld_FchSist from fst017 f where f.pgcod = 1;
        end;
      
        begin
          ln_tipocambio := fn_tipo_cambio_fijo(P_FECHA => ld_FchSist);
        end;
      
        begin
        
          pq_cr_adelantosueldo.sp_cr_CredJudicial(ln_pais         => ve_pepais,
                                                  ln_tipdoc       => ve_petdoc,
                                                  lc_numdoc       => ve_pendoc,
                                                  ln_TieneCredJud => lc_FlagCredJud);
        
          pq_cR_adelantosueldo.sp_cr_Sobreendeuda(ln_pais     => ve_pepais,
                                                  ln_tipdoc   => ve_petdoc,
                                                  lc_numdoc   => ve_pendoc,
                                                  lc_FlgSobre => lc_FlgSobreEndeudado);
        
          pq_cr_adelantosueldo.sp_cr_ListasNegras(ve_pepais,
                                                  ve_petdoc,
                                                  ve_pendoc,
                                                  lc_ListNegra);
        
          pq_cr_proc_adelanto_sueldo.sp_cr_calif_rcc_pae(pn_tdoc => ve_petdoc,
                                                         pc_ndoc => ve_pendoc,
                                                         pv_rpta => lc_Es100N);
        
          pq_cr_proc_adelanto_sueldo.sp_cr_maxdias_atraso(pd_fape => ld_FchSist,
                                                          pn_pais => ve_pepais,
                                                          pn_tdoc => ve_petdoc,
                                                          pc_ndoc => ve_pendoc,
                                                          pn_rpta => ln_AtrasoMax);
        
          pq_cr_proc_adelanto_sueldo.sp_cuentas_titular(ln_pepais     => ve_pepais,
                                                        ln_petdoc     => ve_petdoc,
                                                        ln_pendoc     => ve_pendoc,
                                                        tipocambio    => ln_tipocambio,
                                                        instancia     => 0,
                                                        pd_fecpro     => ld_FchSist,
                                                        ln_captotcaja => ln_SaldConsolidado);
        
          PQ_CR_ADELANTO_SUELDO.sp_cr_val_crd_exist(pepais => ve_pepais,
                                                    petdoc => ve_petdoc,
                                                    pendoc => ve_pendoc,
                                                    rpta   => lc_TnCredAdSueld);
        
          Pq_Cr_Adelantosueldo.sp_cr_score(ln_tipdoc => ve_petdoc,
                                           lc_ndoc   => ve_pendoc,
                                           lc_score  => lc_ScoreSeguimiento);
        
          pq_cr_proc_adelanto_sueldo.sp_cr_traba_activocaja(pn_pais => ve_pepais,
                                                            pn_tdoc => ve_petdoc,
                                                            pc_ndoc => ve_pendoc,
                                                            pv_rpta => lc_EsTrabjdor);
        
          Pq_Cr_Var_Adelantosueldo.SP_CR_CUENTA_VIGENTE_Carga(PN_PAIS          => ve_pepais,
                                                              PN_TIPODOCUMENTO => ve_petdoc,
                                                              PC_DOCUMENTO     => ve_pendoc,
                                                              PD_FECHASISTEMA  => ln_maxfech607,
                                                              PV_CUENTAVIGENTE => lc_IndAbon6M,
                                                              PV_DESC_JUD      => lc_DescJud);
        
          pq_cr_adelantosueldo.sp_cr_TipoVivienda(ln_pais        => ve_pepais,
                                                  ln_tipdoc      => ve_petdoc,
                                                  lc_numdoc      => ve_pendoc,
                                                  ln_TipVivienda => ln_TipViv,
                                                  lc_TipViv      => lc_FlagTipViv);
        
        end;
      
        begin
          -- Ratio
        
          if ln_ingneto > 2500 then
            ln_mntprop := 2500;
          else
            if ln_ingneto <= 2500 then
              ln_mntprop := ln_ingneto;
            end if;
          end if;
        
          if lc_EsTrabjdor = 'S' then
            ln_tasa := 1.06;
          else
            if lc_EsTrabjdor = 'N' then
              ln_tasa := 3.1;
            end if;
          end if;
        
          pq_cr_adelantosueldo.sp_cr_RatioAdelSueld(ln_Pepais      => ve_pepais,
                                                    ln_Petdoc      => ve_petdoc,
                                                    ln_Pendoc      => trim(ve_pendoc),
                                                    tipocambio     => ln_tipocambio,
                                                    ln_pgcod       => ln_pgcod,
                                                    ln_modulo      => ln_mod,
                                                    ln_sucursal    => ln_suc,
                                                    ln_mda         => ln_mda,
                                                    ln_papel       => ln_pap,
                                                    ln_cuenta      => ln_cta,
                                                    ln_operacion   => ln_ope,
                                                    ln_suboper     => ln_sbop,
                                                    ln_tipoper     => ln_tope,
                                                    pd_fecpro      => ld_FchSist,
                                                    lc_Usuario     => 'CAJAMOVIL',
                                                    ln_IngNeto     => ln_ingneto,
                                                    ln_mntprop     => ln_mntprop,
                                                    ln_nrocuot     => 4,
                                                    ln_tasa        => ln_tasa,
                                                    lc_TipoCarga   => 'CAJAMOVIL',
                                                    ln_captotcaja  => ln_deudaCMAC,
                                                    saldo_externo  => ln_DeudaIFIS,
                                                    ln_RatioIngNet => ln_Ratio);
        exception
          when others then
            null;
        end;
      
        begin
          pq_cr_adelantosueldo.sp_cr_insertAQPB606(ln_06paid    => ve_pepais,
                                                   ln_06tipd    => ve_petdoc,
                                                   lc_06numd    => ve_pendoc,
                                                   ld_06fecc    => ld_FchSist,
                                                   ln_06pgco    => ln_pgcod,
                                                   ln_06mod     => ln_mod,
                                                   ln_06suc     => ln_suc,
                                                   ln_06mon     => ln_mda,
                                                   ln_06pap     => ln_pap,
                                                   ln_06cta     => ln_cta,
                                                   ln_06ope     => ln_ope,
                                                   ln_06sope    => ln_sbop,
                                                   ln_06tipo    => ln_tope,
                                                   lc_06lstn    => lc_ListNegra, -- Indicador Lista Negra
                                                   lc_06abo6    => lc_IndAbon6M, --Indicador Abono Ult 6 Meses
                                                   ln_06mntm    => ln_abon_min, -- Monto Abono minimo
                                                   ln_06proa    => ln_ingneto, -- Promedio de Abonos
                                                   lc_06cal6    => lc_Es100N, -- Indicador Calificacion Normal
                                                   lc_06scos    => lc_ScoreSeguimiento, -- Score Segmentacion
                                                   ln_06nroa    => ln_AtrasoMax, -- Nro de atraso maximo
                                                   lc_06tipv    => lc_FlagTipViv, -- Tipo de vivienda
                                                   lc_06sobr    => lc_FlgSobreEndeudado, --Sobreendeudado 
                                                   lc_06crej    => lc_FlagCredJud, -- Indicador Cred Judicial
                                                   lc_06traa    => lc_EsTrabjdor, -- Es Trabajado Activo
                                                   lc_06ilet    => lc_Iletrado, -- Es Iletrado
                                                   ln_06salc    => ln_SaldConsolidado, -- Saldo Consolidado
                                                   lc_06ades    => lc_TnCredAdSueld, -- Credito Vigente Adelanto Sueldo
                                                   ln_06rat     => ln_Ratio,
                                                   lc_DsctJudic => lc_DescJud,
                                                   lc_Tcarga    => 'C'); --Ratio
        exception
          when others then
            null;
        end;
      
      end if;
      --end loop;
    end if;
  end sp_cr_cargaAQPB606;
  -----------------------------------------------------------
  procedure sp_cr_cargaAQPB607(ve_pepais in number,
                               ve_petdoc in number,
                               ve_pendoc in varchar2,
                               vo_rpta   out varchar) is
  
    ld_MaxFch606   date;
    ln_tasa        number(5, 4);
    ln_mond        number(17, 2);
    ln_mntprop     number(17, 2);
    ln_aqpb606tipc number;
    ln_montdes     number(17, 2);
    ln_topecred    number;
    lc_ListNegr    varchar2(5);
    lc_Abo6M       varchar2(5);
    ln_MntMin      number(17, 2);
    ln_PromAbo     number(17, 2);
    lc_CalfN6Mss   varchar2(5);
    lc_Score       varchar2(5);
    ln_AtrMax      number;
    lc_TipViv      varchar2(5);
    lc_Sobreend    varchar2(5);
    lc_CredJud     varchar2(5);
    ln_SaldCons    number(17, 2);
    lc_AdlSueldVig varchar2(5);
    ln_Ratio       number(10, 6);
    lc_DscJud      varchar2(5);
    ln_TieneReg    number;
  
  begin
  
    begin
      select count(*)
        into ln_TieneReg
        from aqpb606 a
       where a.aqpb606paid = ve_pepais
         and a.aqpb606tipd = ve_petdoc
         and a.aqpb606numd = ve_pendoc
         and a.aqpb606tcarg = 'C'
         and a.aqpb606est = 'H';
    exception
      when others then
        null;
    end;
  
    ln_TieneReg := nvl(ln_TieneReg, 0);
  
    if ln_TieneReg > 0 then
    
      begin
      
        select a.aqpb606lstn,
               a.aqpb606abo6,
               a.aqpb606mntm,
               a.aqpb606proa,
               a.aqpb606cal6,
               a.aqpb606scos,
               a.aqpb606nroa,
               a.aqpb606tipv,
               a.aqpb606sobr,
               a.aqpb606crej,
               a.aqpb606salc,
               a.aqpb606ades,
               a.aqpb606rat,
               a.aqpb606dscjud
          into lc_ListNegr,
               lc_Abo6M,
               ln_MntMin,
               ln_PromAbo,
               lc_CalfN6Mss,
               lc_Score,
               ln_AtrMax,
               lc_TipViv,
               lc_Sobreend,
               lc_CredJud,
               ln_SaldCons,
               lc_AdlSueldVig,
               ln_Ratio,
               lc_DscJud
          from aqpb606 a
         where a.aqpb606paid = ve_pepais
           and a.aqpb606tipd = ve_petdoc
           and a.aqpb606numd = ve_pendoc
           and a.aqpb606tcarg = 'C'
           and a.aqpb606est = 'H';
      exception
        when others then
          null;
      end;
    
      if lc_ListNegr <> 'N' or lc_Abo6M <> 'S' or ln_MntMin < 400 or
         ln_PromAbo < 400 or lc_CalfN6Mss <> 'S' or
         lc_Score not in ('RIESGO A',
                          'RIESGO B',
                          'RIESGO C',
                          'RIESGO D',
                          'RIESGO E',
                          'RIESGO F',
                          'SINSCORE') or ln_AtrMax > 0 or lc_TipViv <> 'S' or
         lc_Sobreend <> 'N' or lc_CredJud <> 'N' or ln_SaldCons > 100000 or
         lc_AdlSueldVig <> 'N' or ln_Ratio > 0.4 or lc_DscJud <> 'N' then
      
        vo_rpta := 'N';
      
      else
        vo_rpta := 'S';
      
      end if;
    
    else
      if ln_TieneReg = 0 then
        vo_rpta := 'N';
      end if;
    end if;
  
  end sp_cr_cargaAQPB607;
  -------------------------------------------------
  -------------------------------------------------
  FUNCTION RCC_FN_CUO_SF(VE_PEPAIS IN NUMBER,
                         VE_PETDOC IN NUMBER,
                         VE_PENDOC IN VARCHAR2) RETURN NUMBER IS
    LN_CUO_SF    NUMBER;
    PD_FECPRE    DATE;
    PC_CODSBS    VARCHAR(10);
    VE_PENDOCAUX varchar2(12);
  BEGIN
  
    LN_CUO_SF    := 0;
    VE_PENDOCAUX := trim(VE_PENDOC);
  
    BEGIN
      --OBTENER LA FECHA DEL ULTIMO RCC
      select to_date(tpnro, 'dd/mm/yyyy')
        into PD_FECPRE
        from fst098
       where pgcod = 1
         and tpcod = 7647
         and tpcorr = 12;
    exception
      when no_data_found then
        PD_FECPRE := null;
    end;
  
    IF VE_PETDOC = 9 THEN
      --RUC
      BEGIN
        --OBTENER EL CODSBS
        SELECT C_CODSBS
          INTO PC_CODSBS
          FROM CLDRCCI
         WHERE C_DOCTRI = VE_PENDOCAUX
           AND D_FECPRE = PD_FECPRE;
      EXCEPTION
        WHEN OTHERS THEN
          PC_CODSBS := '';
      END;
    ELSE
      --PERSONA NATURAL
      BEGIN
        --OBTENER EL CODSBS
        SELECT C_CODSBS
          INTO PC_CODSBS
          FROM CLDRCCI
         WHERE C_DOCIDE = VE_PENDOCAUX
           AND D_FECPRE = PD_FECPRE;
      EXCEPTION
        WHEN OTHERS THEN
          null;
      END;
    END IF;
  
    if PC_CODSBS is not null then
    
      SELECT (PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                             PD_FECPRE,
                                                             '^14.[1-6]0302') *
              0.044) + (CASE
                WHEN PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]030602') <=
                     30000 THEN
                 PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]030602') *
                 0.0264
                ELSE
                 PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]030602') *
                 0.0222
              END) +
             
              (CASE
                WHEN (PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]0306') -
                     PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]030602') -
                     PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]030611') -
                     PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]030612')) <= 8000 THEN
                 (PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]0306') -
                 PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]030602') -
                 PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]030611') -
                 PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]030612')) *
                 0.0514
                WHEN (PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]0306') -
                     PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]030602') -
                     PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]030611') -
                     PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]030612')) <=
                     15000 THEN
                 (PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]0306') -
                 PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]030602') -
                 PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]030611') -
                 PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]030612')) *
                 0.0356
                WHEN (PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]0306') -
                     PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]030602') -
                     PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]030611') -
                     PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]030612')) <=
                     45000 THEN
                 (PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]0306') -
                 PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]030602') -
                 PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]030611') -
                 PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]030612')) *
                 0.0282
                WHEN (PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]0306') -
                     PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]030602') -
                     PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]030611') -
                     PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]030612')) >
                     45000 THEN
                 (PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]0306') -
                 PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]030602') -
                 PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]030611') -
                 PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]030612')) *
                 0.0222
              END) +
             
              ((PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                              PD_FECPRE,
                                                              '^14.[1-6]030611') +
              PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                              PD_FECPRE,
                                                              '^14.[1-6]030612')) *
              0.088) +
             
              (CASE
                WHEN (PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]030611') +
                     PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]030612')) <=
                     10000 THEN
                 (PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]030611') +
                 PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]030612')) *
                 0.0349
                WHEN (PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]030611') +
                     PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]030612')) <=
                     20000 THEN
                 (PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]030611') +
                 PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]030612')) *
                 0.0248
                WHEN (PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]030611') +
                     PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]030612')) <=
                     30000 THEN
                 (PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]030611') +
                 PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]030612')) *
                 0.0224
                WHEN (PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]030611') +
                     PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]030612')) >
                     30000 THEN
                 (PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]030611') +
                 PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]030612')) *
                 0.0205
              END) +
             
              (PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                             PD_FECPRE,
                                                             '^14.[1-6]04') *
              0.009) +
             
              (CASE
                WHEN (PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]12') +
                     PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]02') +
                     PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]13') -
                     PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]020601') -
                     PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]029901') -
                     PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]0202') -
                     PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]130601') -
                     PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]1302')) <= 8000 THEN
                 (PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]12') +
                 PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]02') +
                 PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]13') -
                 PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]020601') -
                 PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]029901') -
                 PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]0202') -
                 PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]130601') -
                 PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]1302')) *
                 0.0514
                WHEN (PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]12') +
                     PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]02') +
                     PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]13') -
                     PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]020601') -
                     PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]029901') -
                     PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]0202') -
                     PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]130601') -
                     PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]1302')) <=
                     15000 THEN
                 (PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]12') +
                 PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]02') +
                 PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]13') -
                 PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]020601') -
                 PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]029901') -
                 PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]0202') -
                 PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]130601') -
                 PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]1302')) *
                 0.0356
                WHEN (PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]12') +
                     PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]02') +
                     PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]13') -
                     PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]020601') -
                     PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]029901') -
                     PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]0202') -
                     PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]130601') -
                     PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]1302')) <=
                     45000 THEN
                 (PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]12') +
                 PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]02') +
                 PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]13') -
                 PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]020601') -
                 PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]029901') -
                 PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]0202') -
                 PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]130601') -
                 PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]1302')) *
                 0.0282
                WHEN (PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]12') +
                     PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]02') +
                     PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]13') -
                     PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]020601') -
                     PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]029901') -
                     PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]0202') -
                     PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]130601') -
                     PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                    PD_FECPRE,
                                                                    '^14.[1-6]1302')) >
                     45000 THEN
                 (PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]12') +
                 PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]02') +
                 PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]13') -
                 PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]020601') -
                 PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]029901') -
                 PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]0202') -
                 PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]130601') -
                 PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                PD_FECPRE,
                                                                '^14.[1-6]1302')) *
                 0.0222
              END) +
             
              ((PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                              PD_FECPRE,
                                                              '^14.[1-6]020601') +
              PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                              PD_FECPRE,
                                                              '^14.[1-6]029901') +
              PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                              PD_FECPRE,
                                                              '^14.[1-6]0202') +
              PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                              PD_FECPRE,
                                                              '^14.[1-6]130601') +
              PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                              PD_FECPRE,
                                                              '^14.[1-6]1302')) * 0.09) +
             /*
                     ((RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS, PD_FECPRE, '^72.50602')+
                       RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS, PD_FECPRE, '^72.50613'))   * 0.0378) +
             */
              (PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                             PD_FECPRE,
                                                             '^7101') * 0.01)
        INTO LN_CUO_SF
        FROM DUAL;
    end if;
    RETURN LN_CUO_SF;
  
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;
    
  END;

  FUNCTION RCC_FN_MTO_CTA_CTBLE_SC(VE_PC_CODSBS IN VARCHAR2,
                                   VE_PD_FECPRE IN DATE,
                                   VE_PC_CUENTA IN VARCHAR2) RETURN NUMBER IS
    LN_MTO NUMBER;
  BEGIN
    SELECT SUM(CC.N_SALCAP)
      INTO LN_MTO
      FROM CLDRCCS CC
     WHERE CC.C_CODSBS = VE_PC_CODSBS
       AND CC.D_FECPRE = VE_PD_FECPRE
       AND REGEXP_LIKE(CC.C_CUENTA, VE_PC_CUENTA)
       AND CC.C_CODEMP <> '00104';
    RETURN NVL(LN_MTO, 0);
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;
  END;

  FUNCTION RCC_FN_MTO_DEUDA_ENT(PC_CODSBS IN VARCHAR2,
                                PD_FECPRE IN DATE,
                                PC_CODENT IN VARCHAR2) RETURN NUMBER IS
    LN_RPTA NUMBER;
  BEGIN
    SELECT SUM(CC.N_SALCAP)
      INTO LN_RPTA
      FROM CLDRCCS CC
     WHERE CC.C_CODSBS = PC_CODSBS
       AND CC.D_FECPRE = PD_FECPRE
       AND ((SUBSTR(CC.C_CUENTA, 1, 2) = '14' AND
           SUBSTR(CC.C_CUENTA, 4, 1) IN ('1', '3', '4', '5', '6')) --CREDITOS DIRECTOS
           OR (SUBSTR(CC.C_CUENTA, 1, 2) = '71' AND
           SUBSTR(CC.C_CUENTA, 4, 1) IN ('1', '2', '3', '4')) --CREDITOS INDIRECTOS
           OR (SUBSTR(CC.C_CUENTA, 1, 2) = '81' AND
           SUBSTR(CC.C_CUENTA, 4, 3) = '302') --CREDITOS CASTIGADOS
           OR (SUBSTR(CC.C_CUENTA, 1, 2) = '72' AND
           SUBSTR(CC.C_CUENTA, 4, 1) = '5') --LINEAS NO UTILIZADAS Y CREDITOS OTORGADOS NO DESEMBOLSADOS
           )
       AND INSTR(PC_CODENT, CC.C_CODEMP) > 0;
    RETURN LN_RPTA;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;
    
  END;

  FUNCTION RCC_FN_CUO_PT(VE_PEPAIS IN NUMBER,
                         VE_PETDOC IN NUMBER,
                         VE_PENDOC IN VARCHAR2) return number is
  
    CURSOR LISTA(VI_PD_FECPRE DATE, VI_PC_CODSBS VARCHAR2) IS
    
      SELECT RD.C_CODEMP, NVL(SUM(RD.N_SALCAP), 0)
      -- INTO VI_SF_LIN_MTO_TOT
        FROM CLDRCCS RD
       WHERE RD.D_FECPRE = VI_PD_FECPRE --to_date('&rrrrmmdd_rcc','rrrrmmdd')
         AND RD.C_CODSBS = VI_PC_CODSBS
         AND SUBSTR(RD.C_CUENTA, 1, 6) IN ('811923', '812923') -- TARJETA DE CREDITO CONSUMO
         AND RD.N_SALCAP > 0
       GROUP BY RD.C_CODEMP;
  
    VS_CUOTA_PT         number(17, 2);
    VI_SF_LIN_MTO_TOT   NUMBER;
    VI_SF_LIN_MTO_USADO NUMBER;
    VI_PC_CODSBS        varchar(10);
    VI_PD_FECPRE        date;
    VE_PENDOCAUX        varchar2(12);
    VS_CUOTA_PT_AUX     number(17, 2);
  
  BEGIN
  
    VS_CUOTA_PT  := 0.00;
    VE_PENDOCAUX := trim(VE_PENDOC);
  
    BEGIN
      --OBTENER LA FECHA DEL ULTIMO RCC
      select to_date(tpnro, 'dd/mm/yyyy')
        into VI_PD_FECPRE
        from fst098
       where pgcod = 1
         and tpcod = 7647
         and tpcorr = 12;
    exception
      when no_data_found then
        VI_PD_FECPRE := null;
    end;
    IF VE_PETDOC = 9 THEN
      --RUC
      BEGIN
        --OBTENER EL CODSBS
        SELECT C_CODSBS
          INTO VI_PC_CODSBS
          FROM CLDRCCI
         WHERE C_DOCTRI = VE_PENDOCAUX
           AND D_FECPRE = VI_PD_FECPRE;
      EXCEPTION
        WHEN OTHERS THEN
          VI_PC_CODSBS := '';
      END;
    ELSE
      --PERSONA NATURAL
      BEGIN
        --OBTENER EL CODSBS
        SELECT C_CODSBS
          INTO VI_PC_CODSBS
          FROM CLDRCCI
         WHERE C_DOCIDE = VE_PENDOCAUX
           AND D_FECPRE = VI_PD_FECPRE;
      EXCEPTION
        WHEN OTHERS THEN
          null;
      END;
    END IF;
  
    if VI_PC_CODSBS is not null then
    
      /*BEGIN
        --Obtengo el saldo capital de las tarjetas de credito
        SELECT NVL(SUM(RD.N_SALCAP), 0)
          INTO VI_SF_LIN_MTO_TOT
          FROM CLDRCCS RD
         WHERE RD.D_FECPRE = VI_PD_FECPRE --to_date('&rrrrmmdd_rcc','rrrrmmdd')
           AND RD.C_CODSBS = VI_PC_CODSBS
           AND SUBSTR(RD.C_CUENTA, 1, 6) IN ('811923', '812923') -- TARJETA DE CREDITO CONSUMO
           AND RD.N_SALCAP > 0;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;*/
    
      FOR L IN LISTA(VI_PD_FECPRE, VI_PC_CODSBS) LOOP
      
        BEGIN
          --Obtengo el saldo capital de las tarjetas de credito
          SELECT NVL(SUM(RD.N_SALCAP), 0)
            INTO VI_SF_LIN_MTO_USADO
            FROM CLDRCCS RD
           WHERE RD.D_FECPRE = VI_PD_FECPRE --to_date('&rrrrmmdd_rcc','rrrrmmdd')
             AND RD.C_CODSBS = VI_PC_CODSBS
             AND SUBSTR(RD.C_CUENTA, 1, 4) IN
                 ('1411',
                  '1421',
                  '1413',
                  '1423',
                  '1414',
                  '1424',
                  '1415',
                  '1425',
                  '1416',
                  '1426')
             AND SUBSTR(RD.C_CUENTA, 5, 4) = '0302' -- TARJETA DE CREDITO CONSUMO
             AND RD.N_SALCAP > 0;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      
        BEGIN
          --CALCULAR CUOTA POTENCIAL
          SELECT CASE
                   WHEN (CASE
                          WHEN VI_SF_LIN_MTO_TOT > 0 THEN
                           ROUND(VI_SF_LIN_MTO_USADO / VI_SF_LIN_MTO_TOT, 4)
                          ELSE
                           0
                        END) < 0.45 THEN
                    0.03 * NVL(PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_DEUDA_ENT(VI_PC_CODSBS,
                                                                          VI_PD_FECPRE,
                                                                          l.c_codemp),
                               0) * 0.044
                   WHEN (CASE
                          WHEN VI_SF_LIN_MTO_TOT > 0 THEN
                           ROUND(VI_SF_LIN_MTO_USADO / VI_SF_LIN_MTO_TOT, 4)
                          ELSE
                           0
                        END) < 0.65 THEN
                    0.07 * NVL(PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_DEUDA_ENT(VI_PC_CODSBS,
                                                                          VI_PD_FECPRE,
                                                                          l.c_codemp),
                               0) * 0.044
                   WHEN (CASE
                          WHEN VI_SF_LIN_MTO_TOT > 0 THEN
                           ROUND(VI_SF_LIN_MTO_USADO / VI_SF_LIN_MTO_TOT, 4)
                          ELSE
                           0
                        END) < 0.85 THEN
                    0.12 * NVL(PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_DEUDA_ENT(VI_PC_CODSBS,
                                                                          VI_PD_FECPRE,
                                                                          l.c_codemp),
                               0) * 0.044
                   WHEN (CASE
                          WHEN VI_SF_LIN_MTO_TOT > 0 THEN
                           ROUND(VI_SF_LIN_MTO_USADO / VI_SF_LIN_MTO_TOT, 4)
                          ELSE
                           0
                        END) >= 0.85 THEN
                    0.25 * NVL(PQ_CR_ADELANTO_SUELDO.RCC_FN_MTO_DEUDA_ENT(VI_PC_CODSBS,
                                                                          VI_PD_FECPRE,
                                                                          l.c_codemp),
                               0) * 0.044
                 END CUOTA_POTENCIAL
            INTO VS_CUOTA_PT_AUX
            FROM DUAL;
        EXCEPTION
          WHEN OTHERS THEN
            VS_CUOTA_PT_AUX := 0;
        END;
      
        VS_CUOTA_PT := nvl(VS_CUOTA_PT, 0) + nvl(VS_CUOTA_PT_AUX, 0);
      
      END LOOP;
    end if;
    return VS_CUOTA_PT;
  END;
  -----------------------------------------------------------
end PQ_CR_ADELANTO_SUELDO;
/

