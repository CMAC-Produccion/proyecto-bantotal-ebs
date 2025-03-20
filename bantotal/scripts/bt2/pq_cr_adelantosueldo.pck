create or replace package PQ_CR_ADELANTOSUELDO is

  -- Author  : MPOSTIGOC
  -- Created : 8/05/2021 1:19:05 p. m.
  -- Purpose : 

  procedure sp_cr_cargaAQPB606(ln_digito in varchar2);
  ------------------------------------------------
  procedure sp_cr_cargaAQPB607;
  ----------------------------------------------
  procedure sp_cr_TipoVivienda(ln_pais        in number,
                               ln_tipdoc      in number,
                               lc_numdoc      in varchar2,
                               ln_TipVivienda out number,
                               lc_TipViv      out varchar2);
  --------------------------------------------------
  procedure sp_cr_Sobreendeuda(ln_pais     in number,
                               ln_tipdoc   in number,
                               lc_numdoc   in varchar2,
                               lc_FlgSobre out varchar2);
  --------------------------------------------------
  procedure sp_cr_CredJudicial(ln_pais         in number,
                               ln_tipdoc       in number,
                               lc_numdoc       in varchar2,
                               ln_TieneCredJud out varchar2);
  -------------------------------------------------
  procedure sp_cr_ListasNegras(ln_pais      in number,
                               ln_tdoc      in number,
                               lc_ndoc      in varchar2,
                               lc_ListNegra out varchar2);
  -------------------------------------------------------------
  procedure sp_cr_score(ln_tipdoc in number,
                        lc_ndoc   in varchar2,
                        lc_score  out varchar2);
  -------------------------------------------------
  procedure sp_cr_RatioAdelSueld(ln_Pepais      in number,
                                 ln_Petdoc      in number,
                                 ln_Pendoc      in varchar2,
                                 tipocambio     in number,
                                 ln_pgcod       in number,
                                 ln_modulo      in number,
                                 ln_sucursal    in number,
                                 ln_mda         in number,
                                 ln_papel       in number,
                                 ln_cuenta      in number,
                                 ln_operacion   in number,
                                 ln_suboper     in number,
                                 ln_tipoper     in number,
                                 pd_fecpro      in date,
                                 lc_Usuario     in varchar2,
                                 ln_IngNeto     in number,
                                 ln_mntprop     in number,
                                 ln_nrocuot     in number,
                                 ln_tasa        in number,
                                 lc_TipoCarga   in varchar2,
                                 ln_captotcaja  out number,
                                 saldo_externo  out number,
                                 ln_RatioIngNet out number);
  ---------------------------------------------------
  procedure sp_resolutor(ln_Pepais    in number,
                         ln_Petdoc    in number,
                         ln_Pendoc    in char,
                         ln_pgcod     in number,
                         ln_modulo    in number,
                         ln_sucursal  in number,
                         ln_mda       in number,
                         ln_papel     in number,
                         ln_cuenta    in number,
                         ln_operacion in number,
                         ln_suboper   in number,
                         ln_tipoper   in number,
                         pd_fecpro    in date,
                         ln_pgcod10   in number,
                         ln_mod10     in number,
                         ln_suc10     in number,
                         ln_mda10     in number,
                         ln_pap10     in number,
                         ln_cta10     in number,
                         ln_oper10    in number,
                         ln_sbop10    in number,
                         ln_tope10    in number,
                         ln_peri10    in number,
                         tipocambio   in number,
                         ln_indicador in number,
                         lc_IndCred   in varchar2,
                         lc_Usuario   in varchar2,
                         lc_TipoCarga in varchar2,
                         ln_capacidad out number);
  -------------------------------------------------------------
  procedure sp_cr_CuotaContinCF(ln_pgcod        in number,
                                ln_modulo       in number,
                                ln_sucursal     in number,
                                ln_mda          in number,
                                ln_papel        in number,
                                ln_cuenta       in number,
                                ln_operacion    in number,
                                ln_suboper      in number,
                                ln_tipoper      in number,
                                pd_fecpro       in date,
                                lc_TipCarg      in varchar2,
                                ln_MntCuoCntgCF out number);
  --------------------------------------------------------------------------------
  procedure sp_cr_CuotaContinAval(ln_pgcod          in number,
                                  ln_modulo         in number,
                                  ln_sucursal       in number,
                                  ln_mda            in number,
                                  ln_papel          in number,
                                  ln_cuenta         in number,
                                  ln_operacion      in number,
                                  ln_suboper        in number,
                                  ln_tipoper        in number,
                                  pd_fecpro         in date,
                                  lc_TipoCarg       in varchar2,
                                  ln_MntCuoCntgAval out number);
  ------------------------------------------------
  procedure sp_cr_insertAQPB606(ln_06paid    in number,
                                ln_06tipd    in number,
                                lc_06numd    in varchar2,
                                ld_06fecc    in date,
                                ln_06pgco    in number,
                                ln_06mod     in number,
                                ln_06suc     in number,
                                ln_06mon     in number,
                                ln_06pap     in number,
                                ln_06cta     in number,
                                ln_06ope     in number,
                                ln_06sope    in number,
                                ln_06tipo    in number,
                                lc_06lstn    in varchar2,
                                lc_06abo6    in varchar2,
                                ln_06mntm    in number,
                                ln_06proa    in number,
                                lc_06cal6    in varchar2,
                                lc_06scos    in varchar2,
                                ln_06nroa    in number,
                                lc_06tipv    in varchar2,
                                lc_06sobr    in varchar2,
                                lc_06crej    in varchar2,
                                lc_06traa    in varchar2,
                                lc_06ilet    in varchar2,
                                ln_06salc    in number,
                                lc_06ades    in varchar2,
                                ln_06rat     in number,
                                lc_DsctJudic in varchar2,
                                lc_Tcarga    in varchar2);
  -------------------------------------------------------------
  procedure sp_cr_insertAQPB607(ln_07PAID   in number,
                                ln_07TIPD   in number,
                                lc_07NUMD   in varchar2,
                                ld_07FECC   in date,
                                ln_07PGCO   in number,
                                ln_07MOD    in number,
                                ln_07SUC    in number,
                                ln_07MON    in number,
                                ln_07PAP    in number,
                                ln_07CTA    in number,
                                ln_07OPE    in number,
                                ln_07SOPE   in number,
                                ln_07TIPO   in number,
                                ln_07TIPC   in number,
                                ln_07TASA   in number,
                                ln_07SALC   in number,
                                ln_07RAT    in number,
                                ln_07MOND   in number,
                                ln_07NROC   in number,
                                lc_07EST    in varchar2,
                                ln_mntprop  in number,
                                ln_modcred  in number,
                                ln_topecred in number);
  -----------------------------------------------------------------
  procedure sp_cr_LogRat610(ln_610pai     in number,
                            ln_610tdoc    in number,
                            lc_610ndoc    in varchar2,
                            ln_610pgcod   in number,
                            ln_610mod     in number,
                            ln_610suc     in number,
                            ln_610mda     in number,
                            ln_610pap     in number,
                            ln_610cta     in number,
                            ln_610ope     in number,
                            ln_610sope    in number,
                            ln_610tope    in number,
                            ln_610tcam    in number,
                            ld_610fproc   in date,
                            lc_610user    in varchar2,
                            ln_610mntca   in number,
                            ln_610mntifis in number,
                            ln_610cuopot  in number,
                            ln_610cupcon  in number,
                            ln_610ingnet  in number,
                            ln_610ratio   in number,
                            lc_606tcarg   in varchar2);
  ----------------------------------------------------------------
  procedure sp_cR_LogRat611(ln_611pai       in number,
                            ln_611tdoc      in number,
                            lc_611ndoc      in varchar2,
                            ln_611pgcod     in number,
                            ln_611mod       in number,
                            ln_611suc       in number,
                            ln_611mda       in number,
                            ln_611pap       in number,
                            ln_611cta       in number,
                            ln_611ope       in number,
                            ln_611sope      in number,
                            ln_611tope      in number,
                            ln_611tcam      in number,
                            ld_611fproc     in date,
                            lc_611user      in varchar2,
                            ln_611pgcodcr   in number,
                            ln_611modcr     in number,
                            ln_611succr     in number,
                            ln_611mdacr     in number,
                            ln_611papcr     in number,
                            ln_611ctacr     in number,
                            ln_611opecr     in number,
                            ln_611sopecr    in number,
                            ln_611topecr    in number,
                            ln_611percre    in number,
                            ln_611numcou    in number,
                            ln_611tipsol    in number,
                            lc_611indflucaj in varchar2,
                            ln_611mntmaxpen in number,
                            ln_611segcre    in number,
                            ln_611capflucaj in number,
                            ln_611caplin    in number,
                            ln_611capcuo    in number,
                            lc_611indcre    in varchar2,
                            lc_TipoCarg     in varchar2);
  -------------------------------------------------------------------                                                                                     

  procedure sp_cr_carga;

  ----------------------------------------------------------

  Function fn_cr_verifica_tarea2(P_C_NOMJOB IN VARCHAR2,
                                 P_C_HOSTNA IN VARCHAR2,
                                 pn_paquete in varchar2,
                                 pn_proceso in varchar2) return number;

  procedure sp_cr_job_cargaAQPB606;
  -------------------------------------
  procedure sp_validar_iletrado(ve_pepais in number,
                                ve_petdoc in number,
                                ve_pendoc in varchar2,
                                vo_rpta   out varchar2);
  ------------------------------------------
  procedure sp_cr_val_crd_exist(pepais in number,
                                petdoc in number,
                                pendoc in varchar2,
                                rpta   out varchar2);

  -------------------------------------------
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

end PQ_CR_ADELANTOSUELDO;
/

create or replace package body PQ_CR_ADELANTOSUELDO is

  procedure sp_cr_cargaAQPB606(ln_digito in varchar2) is
  
    cursor inicio is
      select f.pgcod,
             f.scmod,
             f.scsuc,
             f.scmda,
             f.scpap,
             f.sccta,
             f.scoper,
             f.scsbop,
             f.sctope
        from fsd011 f
       where f.pgcod = 1
         and f.scmda = 0
         and f.scpap = 0
         and f.scmod = 21
         and f.sctope = 6
         and f.scstat = 0
            -- and f.sccta in (1567384);
            --and to_char(substr(trim(f.sccta), -1, 1)) = ln_digito;
         and mod(f.sccta, 50) = ln_digito;
  
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
    ln_tipocambio        number(10, 8);
    lc_TnCredAdSueld     varchar2(5);
    lc_IndAbon6M         varchar2(5);
    lc_DescJud           varchar2(5);
    ln_deudaCMAC         number(17, 2) := 0.00;
    ln_DeudaIFIS         number(17, 2) := 0.00;
    ln_Ratio             number(10, 6) := 0.00;
    lc_ScoreSeguimiento  varchar2(25);
    ln_mntprop           NUMBER(17, 2) := 0.00;
    ln_tasa              number(14, 6) := 0.00;
  
  begin
  
    for i in inicio loop
    
      lc_FlagTipViv        := 'N';
      lc_FlagCredJud       := 'N';
      lc_FlgSobreEndeudado := 'N';
      lc_ListNegra         := 'N';
      lc_Es100N            := 'N';
      lc_EsTrabjdor        := 'N';
      lc_Iletrado          := 'N';
      lc_TnCredAdSueld     := 'N';
      lc_IndAbon6M         := 'N';
      lc_DescJud           := 'N';
      lc_ScoreSeguimiento  := 'N';
      ln_Ratio             := 0.00;
    
      /* delete from aqpb606 a where a.aqpb606cta= i.sccta;
      commit;*/
    
      begin
        select f.pgfape into ld_FchSist from fst017 f where f.pgcod = 1;
      exception
        when others then
          null;
      end;
    
      -- ld_FchSist := to_date('12/01/2021', 'DD/MM/YYYY');
    
      begin
        delete from aqpb606 a
         where a.aqpb606pgco = i.pgcod
           and a.aqpb606mod = i.scmod
           and a.aqpb606suc = i.scsuc
           and a.aqpb606mon = i.scmda
           and a.aqpb606pap = i.scpap
           and a.aqpb606cta = i.sccta
           and a.aqpb606ope = i.scoper
           and a.aqpb606sope = i.scsbop
           and a.aqpb606tipo = i.sctope
           and a.aqpb606fecc = ld_FchSist;
        commit;
      exception
        when others then
          null;
      end;
    
      begin
        select f.pepais, f.petdoc, f.pendoc
          into ln_pais, ln_tdoc, lc_ndoc
          from fsr008 f
         where f.pgcod = 1
           and f.ctnro = i.sccta
           and f.cttfir = 'T';
      exception
        when others then
          null;
      end;
    
      if ln_tdoc = 21 then
      
        begin
          ln_tipocambio := fn_tipo_cambio_fijo(P_FECHA => ld_FchSist);
        exception
          when others then
            null;
        end;
      
        begin
          pq_cr_adelantosueldo.sp_cr_TipoVivienda(ln_pais        => ln_pais,
                                                  ln_tipdoc      => ln_tdoc,
                                                  lc_numdoc      => lc_ndoc,
                                                  ln_TipVivienda => ln_TipViv,
                                                  lc_TipViv      => lc_FlagTipViv);
        
          pq_cr_adelantosueldo.sp_cr_CredJudicial(ln_pais         => ln_pais,
                                                  ln_tipdoc       => ln_tdoc,
                                                  lc_numdoc       => lc_ndoc,
                                                  ln_TieneCredJud => lc_FlagCredJud);
        
          pq_cR_adelantosueldo.sp_cr_Sobreendeuda(ln_pais     => ln_pais,
                                                  ln_tipdoc   => ln_tdoc,
                                                  lc_numdoc   => lc_ndoc,
                                                  lc_FlgSobre => lc_FlgSobreEndeudado);
        
          pq_cr_adelantosueldo.sp_cr_ListasNegras(ln_pais,
                                                  ln_tdoc,
                                                  lc_ndoc,
                                                  lc_ListNegra);
        
          pq_cr_proc_adelanto_sueldo.sp_cr_calif_rcc_pae(pn_tdoc => ln_tdoc,
                                                         pc_ndoc => lc_ndoc,
                                                         pv_rpta => lc_Es100N);
        
          pq_cr_proc_adelanto_sueldo.sp_cr_maxdias_atraso(pd_fape => ld_FchSist,
                                                          pn_pais => ln_pais,
                                                          pn_tdoc => ln_tdoc,
                                                          pc_ndoc => lc_ndoc,
                                                          pn_rpta => ln_AtrasoMax);
        
          pq_cr_proc_adelanto_sueldo.sp_cr_traba_activocaja(pn_pais => ln_pais,
                                                            pn_tdoc => ln_tdoc,
                                                            pc_ndoc => lc_ndoc,
                                                            pv_rpta => lc_EsTrabjdor);
        
          PQ_CR_ADELANTOSUELDO.sp_validar_iletrado(ve_pepais => ln_pais,
                                                   ve_petdoc => ln_tdoc,
                                                   ve_pendoc => lc_ndoc,
                                                   vo_rpta   => lc_Iletrado);
        
          pq_cr_proc_adelanto_sueldo.sp_cuentas_titular(ln_pepais     => ln_pais,
                                                        ln_petdoc     => ln_tdoc,
                                                        ln_pendoc     => lc_ndoc,
                                                        tipocambio    => ln_tipocambio,
                                                        instancia     => 0,
                                                        pd_fecpro     => ld_FchSist,
                                                        ln_captotcaja => ln_SaldConsolidado);
        
          PQ_CR_ADELANTOSUELDO.sp_cr_val_crd_exist(pepais => ln_pais,
                                                   petdoc => ln_tdoc,
                                                   pendoc => lc_ndoc,
                                                   rpta   => lc_TnCredAdSueld);
        
          Pq_Cr_Adelantosueldo.sp_cr_score(ln_tipdoc => ln_tdoc,
                                           lc_ndoc   => lc_ndoc,
                                           lc_score  => lc_ScoreSeguimiento);
        
          --Procedimientos Gary
          pq_cr_var_adelantosueldo.SP_CR_CUENTA_ABONOS(PN_pgcod        => i.pgcod,
                                                       PN_Scmod        => i.scmod,
                                                       PN_Scsuc        => i.scsuc,
                                                       PN_Scmda        => i.scmda,
                                                       PN_Scpap        => i.scpap,
                                                       PN_Sccta        => i.sccta,
                                                       PN_Scoper       => i.scoper,
                                                       PN_Scsbop       => i.scsbop,
                                                       PN_Sctope       => i.sctope,
                                                       PD_FECHASISTEMA => ld_FchSist,
                                                       PN_ABON_PROM    => ln_abon_prom,
                                                       PN_ABON_MIN     => ln_abon_min,
                                                       PN_PRCN_DIF     => ln_prcn_dif,
                                                       PV_RESP_PROM    => lv_resp_prom,
                                                       PV_RESP_MIN     => lv_resp_min,
                                                       PV_RESP_DIF     => lv_resp_dif);
          ln_abon_prom := round(ln_abon_prom, 0);
        
          Pq_Cr_Var_Adelantosueldo.SP_CR_CUENTA_VIGENTE_carga(PN_PAIS          => ln_pais,
                                                              PN_TIPODOCUMENTO => ln_tdoc,
                                                              PC_DOCUMENTO     => lc_ndoc,
                                                              PD_FECHASISTEMA  => ld_FchSist,
                                                              PV_CUENTAVIGENTE => lc_IndAbon6M,
                                                              PV_DESC_JUD      => lc_DescJud);
        
          begin
            -- Ratio
            if ln_abon_prom > 2500 then
              ln_mntprop := 2500;
            else
              if ln_abon_prom <= 2500 then
                ln_mntprop := ln_abon_prom;
              end if;
            end if;
          
            if lc_EsTrabjdor = 'S' then
              ln_tasa := 1.06;
            else
              if lc_EsTrabjdor = 'N' then
                ln_tasa := 3.1;
              end if;
            end if;
          
            pq_cr_adelantosueldo.sp_cr_RatioAdelSueld(ln_Pepais      => ln_pais,
                                                      ln_Petdoc      => ln_tdoc,
                                                      ln_Pendoc      => lc_ndoc,
                                                      tipocambio     => ln_tipocambio,
                                                      ln_pgcod       => i.pgcod,
                                                      ln_modulo      => i.scmod,
                                                      ln_sucursal    => i.scsuc,
                                                      ln_mda         => i.scmda,
                                                      ln_papel       => i.scpap,
                                                      ln_cuenta      => i.sccta,
                                                      ln_operacion   => i.scoper,
                                                      ln_suboper     => i.scsbop,
                                                      ln_tipoper     => i.sctope,
                                                      pd_fecpro      => ld_FchSist,
                                                      lc_Usuario     => 'BANTPROD',
                                                      ln_IngNeto     => ln_abon_prom,
                                                      ln_mntprop     => ln_mntprop,
                                                      ln_nrocuot     => 4,
                                                      ln_tasa        => ln_tasa,
                                                      lc_TipoCarga   => 'MASIVA',
                                                      ln_captotcaja  => ln_deudaCMAC,
                                                      saldo_externo  => ln_DeudaIFIS,
                                                      ln_RatioIngNet => ln_Ratio);
          exception
            when others then
              null;
          end;
        exception
          when others then
            null;
        end;
      
        begin
          pq_cr_adelantosueldo.sp_cr_insertAQPB606(ln_06paid    => ln_pais,
                                                   ln_06tipd    => ln_tdoc,
                                                   lc_06numd    => lc_ndoc,
                                                   ld_06fecc    => ld_FchSist,
                                                   ln_06pgco    => i.pgcod,
                                                   ln_06mod     => i.scmod,
                                                   ln_06suc     => i.scsuc,
                                                   ln_06mon     => i.scmda,
                                                   ln_06pap     => i.scpap,
                                                   ln_06cta     => i.sccta,
                                                   ln_06ope     => i.scoper,
                                                   ln_06sope    => i.scsbop,
                                                   ln_06tipo    => i.sctope,
                                                   lc_06lstn    => lc_ListNegra, -- Indicador Lista Negra
                                                   lc_06abo6    => lc_IndAbon6M, --Indicador Abono Ult 6 Meses
                                                   ln_06mntm    => ln_abon_min, -- Monto Abono minimo
                                                   ln_06proa    => ln_abon_prom, -- Promedio de Abonos
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
                                                   lc_Tcarga    => 'M'); --Ratio
        exception
          when others then
            null;
        end;
      
      end if;
    
    end loop;
  
  end sp_cr_cargaAQPB606;

  -----------------------------------------------------------
  procedure sp_cr_cargaAQPB607 is
  
    cursor lista(ld_Fch606 date) is
      select a.aqpb606paid ln_pais,
             a.aqpb606tipd ln_tdoc,
             a.aqpb606numd lc_ndoc,
             max(a.aqpb606proa) ln_MaxPromAbo
        from aqpb606 a
       where a.aqpb606lstn = 'N'
         and a.aqpb606abo6 = 'S'
         and a.aqpb606mntm >= 400
         and a.aqpb606proa >= 400
         and a.aqpb606cal6 = 'S'
         and a.aqpb606scos in ('RIESGO A',
                               'RIESGO B',
                               'RIESGO C',
                               'RIESGO D',
                               'RIESGO E',
                               'RIESGO F',
                               'SINSCORE')
         and a.aqpb606nroa = 0
         and a.aqpb606tipv = 'S'
         and a.aqpb606sobr = 'N'
         and a.aqpb606crej = 'N'
         and a.aqpb606salc <= 100000
         and a.aqpb606ades = 'N'
         and a.aqpb606dscjud = 'N'
         and a.aqpb606rat <= 0.4
         and a.aqpb606fecc = ld_Fch606
      --  and a.aqpb606cta in (815495,342593,1572360)
       group by a.aqpb606paid, a.aqpb606tipd, a.aqpb606numd;
    -- and a.aqpb606numd= '72237536';
  
    cursor montos is
    
      select f.tp1nro2 ln_porcutil, f.tp1nro3 ln_nrocuot
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 10899
         and f.tp1corr1 = 750
         and f.tp1corr2 = 1;
  
    ld_MaxFch606 date;
    ln_tasa      number(5, 4);
    -- ln_mond        number(17, 2);
    ln_mntprop     number(17, 2);
    ln_aqpb606tipc number;
    ln_montdes     number(17, 2);
    ln_modcre      number;
    ln_tipopecred  number;
    ln_606pgco     number;
    ln_606mod      number;
    ln_606suc      number;
    ln_606mon      number;
    ln_606pap      number;
    ln_606cta      number;
    ln_606ope      number;
    ln_606sope     number;
    ln_606tipo     number;
    lc_606traa     varchar2(5);
    ln_606salc     number;
    lc_606ades     varchar2(5);
    ln_606rat      number;
  
  begin
  
    begin
      select max(a.aqpb606fecc) into ld_MaxFch606 from aqpb606 a;
    exception
      when others then
        null;
    end;
  
    --ld_MaxFch606 := to_date('13/01/2021', 'DD/MM/YYYY');
  
    -- Eliminación del registro VERIFICAR DATA AELIMINAR  - FECHA ?
    --  delete from aqpb607 t where t.aqpb607fecc = ld_MaxFch606;
  
    update aqpb607 a
       set a.aqpb607est = 'I'
     where a.aqpb607est = 'H'
       and a.aqpb607fecc <= ld_MaxFch606;
    commit;
  
    begin
      for l in lista(ld_MaxFch606) loop
      
        begin
          select d.aqpb606pgco,
                 d.aqpb606mod,
                 d.aqpb606suc,
                 d.aqpb606mon,
                 d.aqpb606pap,
                 d.aqpb606cta,
                 d.aqpb606ope,
                 d.aqpb606sope,
                 d.aqpb606tipo,
                 d.aqpb606traa,
                 d.aqpb606salc,
                 d.aqpb606ades,
                 d.aqpb606rat
            into ln_606pgco,
                 ln_606mod,
                 ln_606suc,
                 ln_606mon,
                 ln_606pap,
                 ln_606cta,
                 ln_606ope,
                 ln_606sope,
                 ln_606tipo,
                 lc_606traa,
                 ln_606salc,
                 lc_606ades,
                 ln_606rat
            from aqpb606 d
           where d.aqpb606paid = l.ln_pais
             and d.aqpb606tipd = l.ln_tdoc
             and d.aqpb606numd = l.lc_ndoc
             and d.aqpb606fecc = ld_MaxFch606
             and d.aqpb606proa = l.ln_MaxPromAbo
             and d.aqpb606est = 'H'
             and d.aqpb606tcarg = 'M'
             and rownum = 1;
        exception
          when others then
            null;
        end;
      
        if lc_606traa = 'S' then
          ln_tasa        := 1.06;
          ln_aqpb606tipc := 1;
          ln_modcre      := 106;
          ln_tipopecred  := 97;
        else
          if lc_606traa = 'N' then
            ln_tasa        := 3.1;
            ln_aqpb606tipc := 2;
            ln_modcre      := 106;
            ln_tipopecred  := 96;
          end if;
        end if;
      
        if l.ln_MaxPromAbo > 2500 then
          ln_mntprop := 2500;
        else
          if l.ln_MaxPromAbo <= 2500 then
            ln_mntprop := l.ln_MaxPromAbo;
          end if;
        end if;
      
        for m in montos loop
        
          ln_montdes := 0.00;
          ln_montdes := (ln_mntprop * m.ln_porcutil) / 100;
        
          pq_cr_adelantosueldo.sp_cr_insertAQPB607(ln_07PAID   => l.ln_pais,
                                                   ln_07TIPD   => l.ln_tdoc,
                                                   lc_07NUMD   => l.lc_ndoc,
                                                   ld_07FECC   => ld_MaxFch606,
                                                   ln_07PGCO   => ln_606pgco,
                                                   ln_07MOD    => ln_606mod,
                                                   ln_07SUC    => ln_606suc,
                                                   ln_07MON    => ln_606mon,
                                                   ln_07PAP    => ln_606pap,
                                                   ln_07CTA    => ln_606cta,
                                                   ln_07OPE    => ln_606ope,
                                                   ln_07SOPE   => ln_606sope,
                                                   ln_07TIPO   => ln_606tipo,
                                                   ln_07TIPC   => ln_aqpb606tipc,
                                                   ln_07TASA   => ln_tasa,
                                                   ln_07SALC   => ln_606salc,
                                                   ln_07RAT    => ln_606rat,
                                                   ln_07MOND   => ln_montdes,
                                                   ln_07NROC   => m.ln_nrocuot,
                                                   lc_07EST    => 'H',
                                                   ln_mntprop  => ln_mntprop,
                                                   ln_modcred  => ln_modcre,
                                                   ln_topecred => ln_tipopecred);
        end loop;
      end loop;
    
    exception
      when others then
        null;
    end;
  
  end sp_cr_cargaAQPB607;
  -------------------------------------------------
  procedure sp_cr_TipoVivienda(ln_pais        in number,
                               ln_tipdoc      in number,
                               lc_numdoc      in varchar2,
                               ln_TipVivienda out number,
                               lc_TipViv      out varchar2) is
  
    lc_numdocAux char(12);
  begin
  
    lc_TipViv    := 'N';
    lc_numdocAux := lc_numdoc;
  
    begin
    
      select c.sngc12vivc -- Tipo de Vivienda Legal
        into ln_TipVivienda
        from sngc13 c
       where c.sngc13pais = ln_pais
         and c.sngc13tdoc = ln_tipdoc
         and c.sngc13ndoc = lc_numdocAux
         and c.docod = 1
         and c.sngc13est = 'H';
    exception
      when others then
        null;
      
    end;
  
    if ln_TipVivienda in (1, 6, 7) then
      lc_TipViv := 'S';
    end if;
  
  end sp_cr_TipoVivienda;
  ----------------------------------------------
  procedure sp_cr_Sobreendeuda(ln_pais     in number,
                               ln_tipdoc   in number,
                               lc_numdoc   in varchar2,
                               lc_FlgSobre out varchar2) is
  
    ln_Sobreendeuda number;
    lc_numdocaux    char(12);
    lc_numdocaux1   varchar2(12);
  
  BEGIN
  
    lc_numdocaux1 := trim(lc_numdoc);
    lc_numdocaux  := lc_numdocaux1;
  
    begin
      SELECT J.JAQY490SOB
        INTO ln_Sobreendeuda
        FROM JAQY490S J
       WHERE J.JAQY490PAI = ln_pais
         AND J.JAQY490TDO = ln_tipdoc
         AND J.JAQY490NDO = lc_numdocaux;
    EXCEPTION
      WHEN OTHERS THEN
        null;
    END;
  
    ln_Sobreendeuda := nvl(ln_Sobreendeuda, 0);
  
    if ln_Sobreendeuda = 0 then
      lc_flgSobre := 'N';
    else
      if ln_Sobreendeuda > 0 then
        lc_flgSobre := 'S';
      end if;
    end if;
  
  end sp_cr_Sobreendeuda;

  ------------------------------------------------
  procedure sp_cr_CredJudicial(ln_pais         in number,
                               ln_tipdoc       in number,
                               lc_numdoc       in varchar2,
                               ln_TieneCredJud out varchar2) is
  
    ln_NroCredJud number := 0;
  begin
  
    ln_TieneCredJud := 'N';
  
    begin
      select count(*)
        into ln_NroCredJud
        from fsd010 f
       where f.pgcod = 1
         and f.aomod in (33, 200)
         and f.aostat <> 99
         and f.aocta in (select g.ctnro
                           from fsr008 g
                          where g.pgcod = 1
                            and g.pepais = ln_pais
                            and g.petdoc = ln_tipdoc
                            and g.pendoc = lc_numdoc);
    exception
      when others then
        ln_NroCredJud := 0;
    end;
  
    if ln_NroCredJud > 0 then
      begin
        select count(*)
          into ln_NroCredJud
          from fsd010 f
         where f.pgcod = 1
           and f.aotope = 550
           and f.aostat <> 99
           and f.aocta in (select g.ctnro
                             from fsr008 g
                            where g.pgcod = 1
                              and g.pepais = ln_pais
                              and g.petdoc = ln_tipdoc
                              and g.pendoc = lc_numdoc);
      exception
        when others then
          ln_NroCredJud := 0;
      end;
    end if;
  
    if ln_NroCredJud > 0 then
      ln_TieneCredJud := 'S';
    else
      ln_TieneCredJud := 'N';
    end if;
  
  end sp_cr_CredJudicial;
  ------------------------------------------------
  procedure sp_cr_ListasNegras(ln_pais      in number,
                               ln_tdoc      in number,
                               lc_ndoc      in varchar2,
                               lc_ListNegra out varchar2) is
  
    ln_NroReg  number;
    lc_ndocAux varchar2(12);
    lc_ndocOf  char(25);
  
  begin
  
    lc_ListNegra := 'N';
    lc_ndocAux   := trim(lc_ndoc);
    lc_ndocOf    := lc_ndocAux;
  
    begin
      select count(*)
        into ln_NroReg
        from fsd201 f
       where f.lnpais = ln_pais
         and f.lntdoc = ln_tdoc
         and f.lnndoc = lc_ndocOf;
    exception
      when others then
        null;
    end;
  
    if ln_NroReg = 0 then
      lc_ListNegra := 'N';
    else
      lc_ListNegra := 'S';
    end if;
  
  end sp_cr_ListasNegras;
  -------------------------------------------------------------
  procedure sp_cr_score(ln_tipdoc in number,
                        lc_ndoc   in varchar2,
                        lc_score  out varchar2) is
  begin
  
    begin
      select max(h.jaql640riesg)
        into lc_score
        from criesgos.jaql640 h
       where h.jaql640ptdoc = ln_tipdoc
         and h.jaql640pndoc = lc_ndoc
         and h.jaql640fepre =
             (select max(j.jaql640fepre) from criesgos.jaql640 j);
    exception
      when others then
        lc_score := 'SINSCORE';
    end;
  
    lc_score := nvl(lc_score, 'SINSCORE');
  
  end sp_cr_score;
  ---------------------------------------------------------------------------------
  procedure sp_cr_RatioAdelSueld(ln_Pepais      in number,
                                 ln_Petdoc      in number,
                                 ln_Pendoc      in VARCHAR2,
                                 tipocambio     in number,
                                 ln_pgcod       in number,
                                 ln_modulo      in number,
                                 ln_sucursal    in number,
                                 ln_mda         in number,
                                 ln_papel       in number,
                                 ln_cuenta      in number,
                                 ln_operacion   in number,
                                 ln_suboper     in number,
                                 ln_tipoper     in number,
                                 pd_fecpro      in date,
                                 lc_Usuario     in varchar2,
                                 ln_IngNeto     in number,
                                 ln_mntprop     in number,
                                 ln_nrocuot     in number,
                                 ln_tasa        in number,
                                 lc_TipoCarga   in varchar2,
                                 ln_captotcaja  out number,
                                 saldo_externo  out number,
                                 ln_RatioIngNet out number) is
  
    ln_capacidad number(17, 2);
    ln_cajaext   number(17, 2);
    lc_FlgLn     varchar2(2);
    lc_fgAdic    varchar2(1);
    lc_fgAmpl    varchar2(1);
    lc_ven       char(1);
    ln_indicador number(10);
    lc_fgRefLin  varchar2(1);
    ln_captotal1 number(17, 6);
  
    lc_TieneRL    varchar2(5) := 'N';
    ln_tipocamb   number(14, 8) := 0.00;
    ln_IngNetoAux number(17, 2) := 0.00;
  
    cursor inserta_vencidos is
      select d10.pgcod    ln_pgcod10,
             d10.aomod    ln_mod10,
             d10.aosuc    ln_suc10,
             d10.aomda    ln_mda10,
             d10.aopap    ln_pap10,
             d10.aocta    ln_cta10,
             d10.aooper   ln_oper10,
             d10.aosbop   ln_sbop10,
             d10.aotope   ln_tope10,
             d10.aoperiod ln_peri10
        from fsd010 d10
       where d10.Pgcod = 1
         and d10.Aocta in
             (select Ctnro
                from fsr008
               where pepais = ln_Pepais
                 and Petdoc = ln_Petdoc
                 and pendoc = rpad(ln_Pendoc, 12))
         and (d10.Aomod in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in (29, 33, 200)))
         and d10.Aostat <> 99
         and d10.aofvto < pd_fecpro
      union
      
      select b.pgcod    ln_pgcod10,
             b.aomod    ln_mod10,
             b.aosuc    ln_suc10,
             b.aomda    ln_mda10,
             b.aopap    ln_pap10,
             b.aocta    ln_cta10,
             b.aooper   ln_oper10,
             b.aosbop   ln_sbop10,
             b.aotope   ln_tope10,
             b.aoperiod ln_peri10
        from fsr008 a, fsd010 b, fsr002 c
       where c.pepais = ln_Pepais
         and c.petdoc = ln_Petdoc
         and c.pendoc = rpad(ln_Pendoc, 12)
         and a.pgcod = b.pgcod
         and a.ctnro = b.aocta
         and (b.Aomod in (select modulo
                            from fst111
                           where dscod = 50
                             and modulo not in (29, 33, 200)))
         and b.aostat <> 99
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66
         and b.aofvto < pd_fecpro;
  
    cursor inserta is
      select d10.pgcod    ln_pgcod10,
             d10.aomod    ln_mod10,
             d10.aosuc    ln_suc10,
             d10.aomda    ln_mda10,
             d10.aopap    ln_pap10,
             d10.aocta    ln_cta10,
             d10.aooper   ln_oper10,
             d10.aosbop   ln_sbop10,
             d10.aotope   ln_tope10,
             d10.aoperiod ln_peri10
      
        from fsd010 d10
       where d10.Pgcod = 1
         and d10.Aocta in
             (select Ctnro
                from fsr008
               where pepais = ln_Pepais
                 and Petdoc = ln_Petdoc
                 and pendoc = rpad(ln_Pendoc, 12))
         and (d10.Aomod in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in (29, 33, 200)) or d10.Aomod = 117)
         and d10.Aostat <> 99
         and d10.aofvto >= pd_fecpro
      union
      
      select b.pgcod    ln_pgcod10,
             b.aomod    ln_mod10,
             b.aosuc    ln_suc10,
             b.aomda    ln_mda10,
             b.aopap    ln_pap10,
             b.aocta    ln_cta10,
             b.aooper   ln_oper10,
             b.aosbop   ln_sbop10,
             b.aotope   ln_tope10,
             b.aoperiod ln_peri10
        from fsr008 a, fsd010 b, fsr002 c
       where c.pepais = ln_Pepais
         and c.petdoc = ln_Petdoc
         and c.pendoc = rpad(ln_Pendoc, 12)
         and a.pgcod = b.pgcod
         and a.ctnro = b.aocta
         and (b.Aomod in (select modulo
                            from fst111
                           where dscod = 50
                             and modulo not in (29, 33, 200)) or
             b.Aomod = 117)
         and b.aostat <> 99
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66
         and b.aofvto >= pd_fecpro;
  
    cursor vuelo is
    
      select x.xwfempresa ln_pgcod10,
             x.xwfmodulo ln_mod10,
             x.xwfsucursal ln_suc10,
             x.xwfmoneda ln_mda10,
             x.xwfpapel ln_pap10,
             x.xwfcuenta ln_cta10,
             x.xwfoperacion ln_oper10,
             x.xwfsubope ln_sbop10,
             x.xwftipope ln_tope10,
             max(s.sng120per) ln_peri10
        from xwf700 x, sng120 s
       where x.xwfempresa = 1
         and x.xwfcuenta in
             (select Ctnro
                from fsr008
               where pepais = ln_Pepais
                 and Petdoc = ln_Petdoc
                 and pendoc = rpad(ln_Pendoc, 12))
         and (x.xwfmodulo in
             (select f.modulo
                 from fst111 f
                where f.dscod = 50
                  and modulo not in (29, 33, 200)) or x.xwfmodulo = 117)
            
         and x.XWFPRCINS in
             (select wf.wfinsprcid
                from wfwrkitems wf
               where wf.wfinsprcid = x.xwfprcins
                 and wf.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
                 and wf.wfiteminit =
                     (select max(wfiteminit)
                        from wfwrkitems w
                       where w.wfinsprcid = x.xwfprcins
                         and w.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
                         and w.wfitemstsact = 1
                         and w.wfiteminit >=
                             to_date('2013.07.01', 'yyyy.mm.dd'))
                 and wf.wfiteminit >= to_date('2013.07.01', 'yyyy.mm.dd'))
         and s.sng120ins = XWFPRCINS
         and x.xwfcar3 = '1'
      
       group by x.xwfempresa,
                x.xwfmodulo,
                x.xwfsucursal,
                x.xwfmoneda,
                x.xwfpapel,
                x.xwfcuenta,
                x.xwfoperacion,
                x.xwfsubope,
                x.xwftipope
      union
      select x.xwfempresa ln_pgcod10,
             x.xwfmodulo ln_mod10,
             x.xwfsucursal ln_suc10,
             x.xwfmoneda ln_mda10,
             x.xwfpapel ln_pap10,
             x.xwfcuenta ln_cta10,
             x.xwfoperacion ln_oper10,
             x.xwfsubope ln_sbop10,
             x.xwftipope ln_tope10,
             max(s.sng120per) ln_peri10
        from xwf700 x, sng120 s, fsr002 c, fsr008 a
       where x.xwfempresa = 1
         and c.pepais = ln_Pepais
         and c.petdoc = ln_Petdoc
         and c.pendoc = rpad(ln_Pendoc, 12)
         and a.pgcod = x.xwfempresa
         and a.ctnro = x.xwfcuenta
         and (x.xwfmodulo in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in (29, 33, 200)) or x.xwfmodulo = 117)
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66
         and x.XWFPRCINS in
             (select wf.wfinsprcid
                from wfwrkitems wf
               where wf.wfinsprcid = x.xwfprcins
                 and wf.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
                 and wf.wfiteminit =
                     (select max(wfiteminit)
                        from wfwrkitems w
                       where w.wfinsprcid = x.xwfprcins
                         and w.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
                         and w.wfitemstsact = 1
                         and w.wfiteminit >=
                             to_date('2013.07.01', 'yyyy.mm.dd'))
                 and wf.wfiteminit >= to_date('2013.07.01', 'yyyy.mm.dd'))
         and s.sng120ins = XWFPRCINS
         and x.xwfcar3 = '1'
       group by x.xwfempresa,
                x.xwfmodulo,
                x.xwfsucursal,
                x.xwfmoneda,
                x.xwfpapel,
                x.xwfcuenta,
                x.xwfoperacion,
                x.xwfsubope,
                x.xwftipope;
  
    cursor lineas_ven is
    
      select d10.pgcod    ln_pgcod10,
             d10.aomod    ln_mod10,
             d10.aosuc    ln_suc10,
             d10.aomda    ln_mda10,
             d10.aopap    ln_pap10,
             d10.aocta    ln_cta10,
             d10.aooper   ln_oper10,
             d10.aosbop   ln_sbop10,
             d10.aotope   ln_tope10,
             d10.aoperiod ln_peri10
        from fsd010 d10
       where d10.Pgcod = 1
         and d10.Aocta in
             (select Ctnro
                from fsr008
               where pepais = ln_Pepais
                 and Petdoc = ln_Petdoc
                 and pendoc = rpad(ln_Pendoc, 12))
         and d10.Aomod = 117
         and d10.aofvto < pd_fecpro
      union
      select b.pgcod    ln_pgcod10,
             b.aomod    ln_mod10,
             b.aosuc    ln_suc10,
             b.aomda    ln_mda10,
             b.aopap    ln_pap10,
             b.aocta    ln_cta10,
             b.aooper   ln_oper10,
             b.aosbop   ln_sbop10,
             b.aotope   ln_tope10,
             b.aoperiod ln_peri10
        from fsr008 a, fsd010 b, fsr002 c
       where c.pepais = ln_Pepais
         and c.petdoc = ln_Petdoc
         and c.pendoc = rpad(ln_Pendoc, 12)
         and a.pgcod = b.pgcod
         and a.ctnro = b.aocta
         and b.aomod = 117
         and b.aomod not in (select tp1nro1
                               from fst198 a
                              where a.tp1cod = 1
                                and a.tp1cod1 = 10899
                                and a.tp1corr1 = 200
                                and a.tp1corr2 = 1
                                and a.tp1corr3 > 0)
         and b.aofvto < pd_fecpro
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66;
  
    lc_IndCred        varchar2(10);
    ln_MntCuoCntg     number;
    ln_MntCuoCntgCF   number;
    ln_MntCuoCntgAval number;
    ln_MntPotncial    number;
    ln_periodo        number;
    ln_tope10         number;
    ln_plazo          number;
    ln_tasaAux        number(14, 8);
  
  begin
  
    ln_captotcaja := 0;
  
    if lc_TipoCarga = 'MASIVA' then
      begin
        update aqpb610 a
           set a.aqpb610est = 'I'
         where a.aqpb610pgcod = ln_pgcod
           and a.aqpb610mod = ln_modulo
           and a.aqpb610suc = ln_sucursal
           and a.aqpb610mda = ln_mda
           and a.aqpb610pap = ln_papel
           and a.aqpb610cta = ln_cuenta
           and a.aqpb610ope = ln_operacion
           and a.aqpb610sope = ln_suboper
           and a.aqpb610tope = ln_tipoper
           and a.aqpb610tcarg = 'MASIVA';
      
        update aqpb611 a
           set a.aqpb611est = 'I'
         where a.aqpb611pgcod = ln_pgcod
           and a.aqpb611mod = ln_modulo
           and a.aqpb611suc = ln_sucursal
           and a.aqpb611mda = ln_mda
           and a.aqpb611pap = ln_papel
           and a.aqpb611cta = ln_cuenta
           and a.aqpb611ope = ln_operacion
           and a.aqpb611sope = ln_suboper
           and a.aqpb611tope = ln_tipoper
           and AQPB611TCARG = 'MASIVA';
        commit;
      exception
        when others then
          null;
      end;
    else
      if lc_TipoCarga = 'CAJAMOVIL' then
      
        begin
          update aqpb610 a
             set a.aqpb610est = 'I'
           where a.aqpb610pgcod = ln_pgcod
             and a.aqpb610mod = ln_modulo
             and a.aqpb610suc = ln_sucursal
             and a.aqpb610mda = ln_mda
             and a.aqpb610pap = ln_papel
             and a.aqpb610cta = ln_cuenta
             and a.aqpb610ope = ln_operacion
             and a.aqpb610sope = ln_suboper
             and a.aqpb610tope = ln_tipoper
             and a.aqpb610tcarg = 'CAJAMOVIL';
        
          update aqpb611 a
             set a.aqpb611est = 'I'
           where a.aqpb611pgcod = ln_pgcod
             and a.aqpb611mod = ln_modulo
             and a.aqpb611suc = ln_sucursal
             and a.aqpb611mda = ln_mda
             and a.aqpb611pap = ln_papel
             and a.aqpb611cta = ln_cuenta
             and a.aqpb611ope = ln_operacion
             and a.aqpb611sope = ln_suboper
             and a.aqpb611tope = ln_tipoper
             and a.aqpb611tcarg = 'CAJAMOVIL';
          commit;
        exception
          when others then
            null;
        end;
      
      end if;
    end if;
  
    for i in inserta loop
      begin
        lc_fgAdic    := null;
        lc_fgAmpl    := null;
        ln_indicador := 1;
        lc_IndCred   := 'CredVigent';
        lc_FlgLn     := 'N';
      
        PQ_CR_RATIO_CUOCNSM.sp_refinanLinea(i.ln_pgcod10,
                                            i.ln_mod10,
                                            i.ln_suc10,
                                            i.ln_mda10,
                                            i.ln_pap10,
                                            i.ln_cta10,
                                            i.ln_oper10,
                                            lc_fgRefLin);
      
        PQ_CR_RATIO_CUOCNSM.Sp_Adicional_CK(i.ln_mod10,
                                            i.ln_tope10,
                                            lc_fgAdic);
      
        PQ_CR_RATIO_CUOCNSM.Sp_ampliados_CK(i.ln_pgcod10,
                                            i.ln_mod10,
                                            i.ln_suc10,
                                            i.ln_mda10,
                                            i.ln_pap10,
                                            i.ln_cta10,
                                            i.ln_oper10,
                                            i.ln_sbop10,
                                            i.ln_tope10,
                                            lc_fgAmpl);
      
        pq_cr_resolutor_cappago.sp_cr_VerVincLinea(i.ln_mod10,
                                                   i.ln_suc10,
                                                   i.ln_mda10,
                                                   i.ln_pap10,
                                                   i.ln_cta10,
                                                   i.ln_oper10,
                                                   i.ln_sbop10,
                                                   i.ln_tope10,
                                                   lc_FlgLn);
      
        if lc_fgAdic <> 'S' and lc_fgAmpl <> 'S' and lc_fgRefLin <> 'S' and
           lc_FlgLn <> 'S' and i.ln_tope10 <> 550 then
        
          Pq_Cr_Adelantosueldo.sp_resolutor(ln_Pepais    => ln_Pepais,
                                            ln_Petdoc    => ln_Petdoc,
                                            ln_Pendoc    => ln_Pendoc,
                                            ln_pgcod     => ln_pgcod,
                                            ln_modulo    => ln_modulo,
                                            ln_sucursal  => ln_sucursal,
                                            ln_mda       => ln_mda,
                                            ln_papel     => ln_papel,
                                            ln_cuenta    => ln_cuenta,
                                            ln_operacion => ln_operacion,
                                            ln_suboper   => ln_suboper,
                                            ln_tipoper   => ln_tipoper,
                                            pd_fecpro    => pd_fecpro,
                                            ln_pgcod10   => i.ln_pgcod10,
                                            ln_mod10     => i.ln_mod10,
                                            ln_suc10     => i.ln_suc10,
                                            ln_mda10     => i.ln_mda10,
                                            ln_pap10     => i.ln_pap10,
                                            ln_cta10     => i.ln_cta10,
                                            ln_oper10    => i.ln_oper10,
                                            ln_sbop10    => i.ln_sbop10,
                                            ln_tope10    => i.ln_tope10,
                                            ln_peri10    => i.ln_peri10,
                                            tipocambio   => tipocambio,
                                            ln_indicador => ln_indicador,
                                            lc_IndCred   => lc_IndCred,
                                            lc_Usuario   => lc_Usuario,
                                            lc_TipoCarga => lc_TipoCarga,
                                            ln_capacidad => ln_capacidad);
        
          ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
        
        end if;
      
        if i.ln_tope10 = 550 then
          lc_TieneRL := 'S';
        end if;
      exception
        when others then
          null;
      end;
    end loop;
  
    for i in inserta_vencidos loop
      begin
        lc_fgAdic    := null;
        lc_fgAmpl    := null;
        ln_indicador := 1;
        lc_IndCred   := 'CredVencid';
      
        PQ_CR_RATIO_CUOCNSM.sp_refinanLinea(i.ln_pgcod10,
                                            i.ln_mod10,
                                            i.ln_suc10,
                                            i.ln_mda10,
                                            i.ln_pap10,
                                            i.ln_cta10,
                                            i.ln_oper10,
                                            lc_fgRefLin);
      
        PQ_CR_RATIO_CUOCNSM.Sp_Adicional_CK(i.ln_mod10,
                                            i.ln_tope10,
                                            lc_fgAdic);
        PQ_CR_RATIO_CUOCNSM.Sp_ampliados_CK(i.ln_pgcod10,
                                            i.ln_mod10,
                                            i.ln_suc10,
                                            i.ln_mda10,
                                            i.ln_pap10,
                                            i.ln_cta10,
                                            i.ln_oper10,
                                            i.ln_sbop10,
                                            i.ln_tope10,
                                            lc_fgAmpl);
      
        pq_cr_resolutor_cappago.sp_cr_VerVincLinea(i.ln_mod10,
                                                   i.ln_suc10,
                                                   i.ln_mda10,
                                                   i.ln_pap10,
                                                   i.ln_cta10,
                                                   i.ln_oper10,
                                                   i.ln_sbop10,
                                                   i.ln_tope10,
                                                   lc_FlgLn);
      
        if lc_fgAdic <> 'S' and lc_fgAmpl <> 'S' and lc_fgRefLin <> 'S' and
           lc_FlgLn <> 'S' and i.ln_tope10 <> 550 then
          Pq_Cr_Adelantosueldo.sp_resolutor(ln_Pepais    => ln_Pepais,
                                            ln_Petdoc    => ln_Petdoc,
                                            ln_Pendoc    => ln_Pendoc,
                                            ln_pgcod     => ln_pgcod,
                                            ln_modulo    => ln_modulo,
                                            ln_sucursal  => ln_sucursal,
                                            ln_mda       => ln_mda,
                                            ln_papel     => ln_papel,
                                            ln_cuenta    => ln_cuenta,
                                            ln_operacion => ln_operacion,
                                            ln_suboper   => ln_suboper,
                                            ln_tipoper   => ln_tipoper,
                                            pd_fecpro    => pd_fecpro,
                                            ln_pgcod10   => i.ln_pgcod10,
                                            ln_mod10     => i.ln_mod10,
                                            ln_suc10     => i.ln_suc10,
                                            ln_mda10     => i.ln_mda10,
                                            ln_pap10     => i.ln_pap10,
                                            ln_cta10     => i.ln_cta10,
                                            ln_oper10    => i.ln_oper10,
                                            ln_sbop10    => i.ln_sbop10,
                                            ln_tope10    => i.ln_tope10,
                                            ln_peri10    => i.ln_peri10,
                                            tipocambio   => tipocambio,
                                            ln_indicador => ln_indicador,
                                            lc_IndCred   => lc_IndCred,
                                            lc_Usuario   => lc_Usuario,
                                            lc_TipoCarga => lc_TipoCarga,
                                            ln_capacidad => ln_capacidad);
        
          ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
        
        end if;
      
        if i.ln_tope10 = 550 then
          lc_TieneRL := 'S';
        end if;
      exception
        when others then
          null;
      end;
    end loop;
  
    for c in vuelo loop
      ln_indicador := 2;
      lc_IndCred   := 'CredVuelo';
    
      ln_periodo := c.ln_peri10;
    
      begin
        select tp1imp1
          into ln_periodo
          from fst198 f
         where tp1cod = 1 -- mpostigoc 07.02.2022
           and tp1cod1 = 10801
           and tp1corr1 = 54
           and tp1corr2 = 1
           and tp1corr3 > 0
           and tp1nro2 = c.ln_mod10
           and tp1nro3 = c.ln_tope10;
      exception
        when no_data_found then
          ln_periodo := c.ln_peri10;
      end;
    
      ln_periodo := nvl(ln_periodo, 0);
    
      if ln_periodo = 0 then
        -- mpostigoc 11052020
      
        begin
          select x.xllperiodo
            into ln_periodo
            from x054023 x
           where x.xllpgcod = c.ln_pgcod10
             and x.xllaomod = c.ln_mod10
             and x.xllaosuc = c.ln_suc10
             and x.xllaomda = c.ln_mda10
             and x.xllaopap = c.ln_pap10
             and x.xllaocta = c.ln_cta10
             and x.xllaooper = c.ln_oper10
             and x.xllaosbop = c.ln_sbop10
             and x.xllaotop = c.ln_tope10;
        exception
          when others then
            ln_periodo := 30;
        end;
      end if;
    
      PQ_CR_RATIO_CUOCNSM.Sp_Adicional_CK(c.ln_mod10,
                                          c.ln_tope10,
                                          lc_fgAdic);
    
      if lc_fgAdic <> 'S' then
      
        Pq_Cr_Adelantosueldo.sp_resolutor(ln_Pepais    => ln_Pepais,
                                          ln_Petdoc    => ln_Petdoc,
                                          ln_Pendoc    => ln_Pendoc,
                                          ln_pgcod     => ln_pgcod,
                                          ln_modulo    => ln_modulo,
                                          ln_sucursal  => ln_sucursal,
                                          ln_mda       => ln_mda,
                                          ln_papel     => ln_papel,
                                          ln_cuenta    => ln_cuenta,
                                          ln_operacion => ln_operacion,
                                          ln_suboper   => ln_suboper,
                                          ln_tipoper   => ln_tipoper,
                                          pd_fecpro    => pd_fecpro,
                                          ln_pgcod10   => c.ln_pgcod10,
                                          ln_mod10     => c.ln_mod10,
                                          ln_suc10     => c.ln_suc10,
                                          ln_mda10     => c.ln_mda10,
                                          ln_pap10     => c.ln_pap10,
                                          ln_cta10     => c.ln_cta10,
                                          ln_oper10    => c.ln_oper10,
                                          ln_sbop10    => c.ln_sbop10,
                                          ln_tope10    => c.ln_tope10,
                                          ln_peri10    => c.ln_peri10,
                                          tipocambio   => tipocambio,
                                          ln_indicador => ln_indicador,
                                          lc_IndCred   => lc_IndCred,
                                          lc_Usuario   => lc_Usuario,
                                          lc_TipoCarga => lc_TipoCarga,
                                          ln_capacidad => ln_capacidad);
      
        ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      
      end if;
    
    end loop;
  
    for j in lineas_ven loop
      begin
        lc_IndCred := 'LineaVencd';
      
        ln_indicador := 3;
        begin
          select 'S'
            into lc_ven
            from fsr011 a, fsd010 b
           where a.r2cod = j.ln_pgcod10
             and a.r2mod = j.ln_mod10
             and a.r2suc = j.ln_suc10
             and a.r2mda = j.ln_mda10
             and a.r2pap = j.ln_pap10
             and a.r2cta = j.ln_cta10
             and a.r2oper = j.ln_oper10
             and a.r2sbop = j.ln_sbop10
             and a.r2tope = j.ln_tope10
             and a.r1cod = b.pgcod
             and a.r1mod = b.aomod
             and a.r1suc = b.aosuc
             and a.r1mda = b.aomda
             and a.r1pap = b.aopap
             and a.r1cta = b.aocta
             and a.r1oper = b.aooper
             and a.r1sbop = b.aosbop
             and a.r1tope = b.aotope
             and b.aostat <> 99
             and relcod = 46
             and rownum = 1;
        exception
          when no_data_found then
            lc_ven := 'N';
        end;
      
        lc_fgAdic := null;
      
        PQ_CR_RATIO_CUOCNSM.Sp_Adicional_CK(j.ln_mod10,
                                            j.ln_tope10,
                                            lc_fgAdic);
      
        PQ_CR_RATIO_CUOCNSM.sp_refinanLinea(J.ln_pgcod10,
                                            J.ln_mod10,
                                            J.ln_suc10,
                                            J.ln_mda10,
                                            J.ln_pap10,
                                            J.ln_cta10,
                                            J.ln_oper10,
                                            lc_fgRefLin);
      
        pq_cr_resolutor_cappago.sp_cr_VerVincLinea(j.ln_mod10,
                                                   j.ln_suc10,
                                                   j.ln_mda10,
                                                   j.ln_pap10,
                                                   j.ln_cta10,
                                                   j.ln_oper10,
                                                   j.ln_sbop10,
                                                   j.ln_tope10,
                                                   lc_FlgLn);
      
        if lc_ven = 'S' and lc_fgAdic <> 'S' and lc_fgRefLin <> 'S' and
           lc_FlgLn <> 'S' then
        
          Pq_Cr_Adelantosueldo.sp_resolutor(ln_Pepais    => ln_Pepais,
                                            ln_Petdoc    => ln_Petdoc,
                                            ln_Pendoc    => ln_Pendoc,
                                            ln_pgcod     => ln_pgcod,
                                            ln_modulo    => ln_modulo,
                                            ln_sucursal  => ln_sucursal,
                                            ln_mda       => ln_mda,
                                            ln_papel     => ln_papel,
                                            ln_cuenta    => ln_cuenta,
                                            ln_operacion => ln_operacion,
                                            ln_suboper   => ln_suboper,
                                            ln_tipoper   => ln_tipoper,
                                            pd_fecpro    => pd_fecpro,
                                            ln_pgcod10   => j.ln_pgcod10,
                                            ln_mod10     => j.ln_mod10,
                                            ln_suc10     => j.ln_suc10,
                                            ln_mda10     => j.ln_mda10,
                                            ln_pap10     => j.ln_pap10,
                                            ln_cta10     => j.ln_cta10,
                                            ln_oper10    => j.ln_oper10,
                                            ln_sbop10    => j.ln_sbop10,
                                            ln_tope10    => j.ln_tope10,
                                            ln_peri10    => j.ln_peri10,
                                            tipocambio   => tipocambio,
                                            ln_indicador => ln_indicador,
                                            lc_IndCred   => lc_IndCred,
                                            lc_Usuario   => lc_Usuario,
                                            lc_TipoCarga => lc_TipoCarga,
                                            ln_capacidad => ln_capacidad);
        
          ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
        end if;
      exception
        when others then
          null;
      end;
    end loop;
  
    begin
      ln_plazo := 30;
    
      if ln_tasa = 1.06 then
        ln_tope10 := 97;
      else
        if ln_tasa = 3.1 then
          ln_tope10 := 96;
        end if;
      end if;
    
      begin
      
        ln_tasaAux := ((power(1 + (ln_tasa / 100), (ln_plazo / 360))) - 1) * 100;
      exception
        when others then
          null;
      end;
    
      begin
      
        ln_capacidad := ln_mntprop *
                        (((ln_tasaAux / 100) *
                        (power(1 + (ln_tasaAux / 100), ln_nrocuot))) /
                        (power(1 + (ln_tasaAux / 100), ln_nrocuot) - 1));
      exception
        when others then
          null;
        
      end;
    
      ln_capacidad  := nvl(ln_capacidad, 0);
      ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
    
      Pq_Cr_Adelantosueldo.sp_cR_LogRat611(ln_611pai       => ln_Pepais,
                                           ln_611tdoc      => ln_Petdoc,
                                           lc_611ndoc      => ln_Pendoc,
                                           ln_611pgcod     => ln_pgcod,
                                           ln_611mod       => ln_modulo,
                                           ln_611suc       => ln_sucursal,
                                           ln_611mda       => ln_mda,
                                           ln_611pap       => ln_papel,
                                           ln_611cta       => ln_cuenta,
                                           ln_611ope       => ln_operacion,
                                           ln_611sope      => ln_suboper,
                                           ln_611tope      => ln_tipoper,
                                           ln_611tcam      => tipocambio,
                                           ld_611fproc     => pd_fecpro,
                                           lc_611user      => lc_Usuario,
                                           ln_611pgcodcr   => 1,
                                           ln_611modcr     => 106,
                                           ln_611succr     => ln_sucursal,
                                           ln_611mdacr     => 0,
                                           ln_611papcr     => 0,
                                           ln_611ctacr     => ln_cuenta,
                                           ln_611opecr     => 0,
                                           ln_611sopecr    => 0,
                                           ln_611topecr    => ln_tope10,
                                           ln_611percre    => 30,
                                           ln_611numcou    => ln_nrocuot,
                                           ln_611tipsol    => 0,
                                           lc_611indflucaj => 'N',
                                           ln_611mntmaxpen => ln_capacidad,
                                           ln_611segcre    => 0,
                                           ln_611capflucaj => 0.00,
                                           ln_611caplin    => 0.00,
                                           ln_611capcuo    => ln_capacidad,
                                           lc_611indcre    => 'CredProp',
                                           lc_TipoCarg     => lc_TipoCarga);
    
    exception
      when others then
        null;
    end;
  
    begin
      -- Cuota Contingente 
      pq_cr_adelantosueldo.sp_cr_CuotaContinCF(ln_pgcod        => ln_pgcod,
                                               ln_modulo       => ln_modulo,
                                               ln_sucursal     => ln_sucursal,
                                               ln_mda          => ln_mda,
                                               ln_papel        => ln_papel,
                                               ln_cuenta       => ln_cuenta,
                                               ln_operacion    => ln_operacion,
                                               ln_suboper      => ln_suboper,
                                               ln_tipoper      => ln_tipoper,
                                               pd_fecpro       => pd_fecpro,
                                               lc_TipCarg      => lc_TipoCarga,
                                               ln_MntCuoCntgCF => ln_MntCuoCntgCF);
    
      pq_cr_adelantosueldo.sp_cr_CuotaContinAval(ln_pgcod          => ln_pgcod,
                                                 ln_modulo         => ln_modulo,
                                                 ln_sucursal       => ln_sucursal,
                                                 ln_mda            => ln_mda,
                                                 ln_papel          => ln_papel,
                                                 ln_cuenta         => ln_cuenta,
                                                 ln_operacion      => ln_operacion,
                                                 ln_suboper        => ln_suboper,
                                                 ln_tipoper        => ln_tipoper,
                                                 pd_fecpro         => pd_fecpro,
                                                 lc_TipoCarg       => lc_TipoCarga,
                                                 ln_MntCuoCntgAval => ln_MntCuoCntgAval);
    
      ln_MntCuoCntg := ln_MntCuoCntgCF + ln_MntCuoCntgAval;
    exception
      when others then
        null;
    end;
  
    begin
    
      ln_MntPotncial := Pq_Cr_AdelantoSueldo.RCC_FN_CUO_PT(VE_PEPAIS => ln_pepais,
                                                           VE_PETDOC => ln_Petdoc,
                                                           VE_PENDOC => ln_Pendoc);
    
      saldo_externo := pq_cr_adelantosueldo.RCC_FN_CUO_SF(VE_PEPAIS => ln_Pepais,
                                                          VE_PETDOC => ln_Petdoc,
                                                          VE_PENDOC => ln_Pendoc);
    
      ln_MntPotncial := nvl(ln_MntPotncial, 0);
      saldo_externo  := nvl(saldo_externo, 0);
    exception
      when others then
        null;
    end;
  
    begin
      -- Suma de Deuda Caja y Deuda Externa
    
      ln_cajaext := nvl(ln_captotcaja, 0) + nvl(saldo_externo, 0) +
                    nvl(ln_MntCuoCntg, 0) + nvl(ln_MntPotncial, 0);
    exception
      when others then
        null;
    end;
  
    ln_IngNetoAux := nvl(ln_IngNeto, 0);
  
    if ln_IngNetoAux <> 0 then
      ln_captotal1 := round((nvl(ln_cajaext, 0) / ln_IngNetoAux), 6);
    else
      ln_captotal1 := 0;
    end if;
  
    if lc_TieneRL = 'S' then
      -- MPOSTIGOC 20.09.2020
      ln_RatioIngNet := 550;
    else
      if lc_TieneRL = 'N' then
        ln_RatioIngNet := nvl(ln_captotal1, 0);
      end if;
    end if;
  
    pq_cr_adelantosueldo.sp_cr_LogRat610(ln_610pai     => ln_Pepais,
                                         ln_610tdoc    => ln_Petdoc,
                                         lc_610ndoc    => ln_Pendoc,
                                         ln_610pgcod   => ln_pgcod,
                                         ln_610mod     => ln_modulo,
                                         ln_610suc     => ln_sucursal,
                                         ln_610mda     => ln_mda,
                                         ln_610pap     => ln_papel,
                                         ln_610cta     => ln_cuenta,
                                         ln_610ope     => ln_operacion,
                                         ln_610sope    => ln_suboper,
                                         ln_610tope    => ln_tipoper,
                                         ln_610tcam    => tipocambio,
                                         ld_610fproc   => pd_fecpro,
                                         lc_610user    => lc_Usuario,
                                         ln_610mntca   => ln_captotcaja,
                                         ln_610mntifis => saldo_externo,
                                         ln_610cuopot  => ln_MntPotncial,
                                         ln_610cupcon  => ln_MntCuoCntg,
                                         ln_610ingnet  => ln_IngNetoAux,
                                         ln_610ratio   => ln_RatioIngNet,
                                         lc_606tcarg   => lc_TipoCarga);
  
  end sp_cr_RatioAdelSueld;
  ------------------------------------------------
  procedure sp_resolutor(ln_Pepais    in number,
                         ln_Petdoc    in number,
                         ln_Pendoc    in char,
                         ln_pgcod     in number,
                         ln_modulo    in number,
                         ln_sucursal  in number,
                         ln_mda       in number,
                         ln_papel     in number,
                         ln_cuenta    in number,
                         ln_operacion in number,
                         ln_suboper   in number,
                         ln_tipoper   in number,
                         pd_fecpro    in date,
                         ln_pgcod10   in number,
                         ln_mod10     in number,
                         ln_suc10     in number,
                         ln_mda10     in number,
                         ln_pap10     in number,
                         ln_cta10     in number,
                         ln_oper10    in number,
                         ln_sbop10    in number,
                         ln_tope10    in number,
                         ln_peri10    in number,
                         tipocambio   in number,
                         ln_indicador in number,
                         lc_IndCred   in varchar2,
                         lc_Usuario   in varchar2,
                         lc_TipoCarga in varchar2,
                         ln_capacidad out number) is
  
    ln_nrocuotas  number(17, 2);
    ln_parciales  number(17, 2);
    ln_cuotimp    number(17, 2) := 0;
    ln_seguro     number(17, 2);
    fech_maxcuota date;
    ln_instancia  number;
    --lc_ven        char(1);
    ln_flagFC  varchar2(1) := 'N'; -- 20/12/2016 mpostigoc
    ln_CapFC   number(17, 2);
    CapLinea   number(17, 2);
    ln_cuoparc number(17, 2);
  
  begin
    begin
      ln_CapFC := 0;
      CapLinea := 0;
    
      PQ_CR_RATIO_CUOCNSM.sp_cuotas(ln_pgcod10,
                                    ln_mod10,
                                    ln_suc10,
                                    ln_mda10,
                                    ln_pap10,
                                    ln_cta10,
                                    ln_oper10,
                                    ln_sbop10,
                                    ln_tope10,
                                    ln_nrocuotas);
    
      PQ_CR_RATIO_CUOCNSM.sp_instancia(ln_mod10,
                                       ln_suc10,
                                       ln_mda10,
                                       ln_pap10,
                                       ln_cta10,
                                       ln_oper10,
                                       ln_sbop10,
                                       ln_tope10,
                                       ln_parciales,
                                       ln_instancia);
    
      PQ_CR_RATIO_CUOCNSM.sp_cr_flujocaja(ln_pgcod10,
                                          ln_mod10,
                                          ln_suc10,
                                          ln_mda10,
                                          ln_pap10,
                                          ln_cta10,
                                          ln_oper10,
                                          ln_sbop10,
                                          ln_tope10,
                                          ln_flagFC);
    
      if ln_mod10 <> 117 and ln_flagFC = 'N' then
        if ln_indicador <> 2 then
          PQ_CR_RATIO_CUOCNSM.sp_cuota_impaga(ln_pgcod10,
                                              ln_mod10,
                                              ln_suc10,
                                              ln_mda10,
                                              ln_pap10,
                                              ln_cta10,
                                              ln_oper10,
                                              ln_sbop10,
                                              ln_tope10,
                                              tipocambio,
                                              ln_cuotimp,
                                              fech_maxcuota);
        else
        
          PQ_CR_RATIO_CUOCNSM.sp_cuota_impagavuelo(ln_pgcod10,
                                                   ln_mod10,
                                                   ln_suc10,
                                                   ln_mda10,
                                                   ln_pap10,
                                                   ln_cta10,
                                                   ln_oper10,
                                                   ln_sbop10,
                                                   ln_tope10,
                                                   tipocambio,
                                                   ln_cuotimp,
                                                   fech_maxcuota);
        
        end if;
      
      else
        if ln_mod10 <> 117 and ln_flagFC = 'S' then
          PQ_CR_RATIO_CUOCNSM.sp_cr_capacidadFC(ln_mod10,
                                                ln_suc10,
                                                ln_mda10,
                                                ln_pap10,
                                                ln_cta10,
                                                ln_oper10,
                                                ln_sbop10,
                                                ln_tope10,
                                                tipocambio,
                                                ln_cuotimp);
        
          ln_CapFC := ln_cuotimp;
        
        end if;
      end if;
    
      PQ_CR_RATIO_CUOCNSM.sp_seguro(ln_mod10,
                                    ln_suc10,
                                    ln_mda10,
                                    ln_pap10,
                                    ln_cta10,
                                    ln_oper10,
                                    ln_sbop10,
                                    ln_tope10,
                                    tipocambio,
                                    fech_maxcuota,
                                    ln_seguro);
    
      if ln_mod10 = 117 then
        PQ_CR_RATIO_CUOCNSM.sp_capacidadlinea(ln_mod10,
                                              ln_suc10,
                                              ln_mda10,
                                              ln_pap10,
                                              ln_cta10,
                                              ln_oper10,
                                              ln_sbop10,
                                              ln_tope10,
                                              tipocambio,
                                              ln_capacidad);
      
        CapLinea := ln_capacidad;
      
      end if;
    
      IF ln_parciales = 7 then
      
        PQ_CR_RATIO_CUOCNSM.sp_capacidadpagoparc(ln_nrocuotas,
                                                 ln_parciales,
                                                 ln_seguro,
                                                 ln_mod10,
                                                 0,
                                                 tipocambio,
                                                 ln_suc10,
                                                 ln_mda10,
                                                 ln_pap10,
                                                 ln_cta10,
                                                 ln_oper10,
                                                 ln_sbop10,
                                                 ln_tope10,
                                                 ln_indicador,
                                                 ln_cuoparc,
                                                 ln_capacidad);
      
        ln_cuotimp := ln_cuoparc;
      
      end if;
    
      if ln_mod10 <> 117 and ln_parciales <> 7 then
      
        PQ_CR_RATIO_CUOCNSM.sp_capacidadpago(ln_cuotimp,
                                             ln_nrocuotas,
                                             ln_parciales,
                                             ln_peri10,
                                             ln_seguro,
                                             ln_mod10,
                                             ln_capacidad);
      end if;
    
      if ln_capacidad > 0 then
      
        if ln_CapFC <> 0 then
          ln_cuotimp := 0;
        end if;
      
        Pq_Cr_Adelantosueldo.sp_cR_LogRat611(ln_611pai       => ln_Pepais,
                                             ln_611tdoc      => ln_Petdoc,
                                             lc_611ndoc      => ln_Pendoc,
                                             ln_611pgcod     => ln_pgcod,
                                             ln_611mod       => ln_modulo,
                                             ln_611suc       => ln_sucursal,
                                             ln_611mda       => ln_mda,
                                             ln_611pap       => ln_papel,
                                             ln_611cta       => ln_cuenta,
                                             ln_611ope       => ln_operacion,
                                             ln_611sope      => ln_suboper,
                                             ln_611tope      => ln_tipoper,
                                             ln_611tcam      => tipocambio,
                                             ld_611fproc     => pd_fecpro,
                                             lc_611user      => lc_Usuario,
                                             ln_611pgcodcr   => ln_pgcod10,
                                             ln_611modcr     => ln_mod10,
                                             ln_611succr     => ln_suc10,
                                             ln_611mdacr     => ln_mda10,
                                             ln_611papcr     => ln_pap10,
                                             ln_611ctacr     => ln_cta10,
                                             ln_611opecr     => ln_oper10,
                                             ln_611sopecr    => ln_sbop10,
                                             ln_611topecr    => ln_tope10,
                                             ln_611percre    => ln_peri10,
                                             ln_611numcou    => ln_nrocuotas,
                                             ln_611tipsol    => ln_parciales,
                                             lc_611indflucaj => ln_flagFC,
                                             ln_611mntmaxpen => ln_cuotimp,
                                             ln_611segcre    => ln_seguro,
                                             ln_611capflucaj => ln_CapFC,
                                             ln_611caplin    => CapLinea,
                                             ln_611capcuo    => ln_capacidad,
                                             lc_611indcre    => lc_IndCred,
                                             lc_TipoCarg     => lc_TipoCarga);
      
      end if;
    exception
      when others then
        null;
    end;
  end sp_resolutor;
  -------------------------------------------------------------
  procedure sp_cr_CuotaContinCF(ln_pgcod        in number,
                                ln_modulo       in number,
                                ln_sucursal     in number,
                                ln_mda          in number,
                                ln_papel        in number,
                                ln_cuenta       in number,
                                ln_operacion    in number,
                                ln_suboper      in number,
                                ln_tipoper      in number,
                                pd_fecpro       in date,
                                lc_TipCarg      in varchar2,
                                ln_MntCuoCntgCF out number) is
  
    cursor lista_CredVigCF(ln_pais number,
                           ln_tdoc number,
                           lc_ndoc varchar2) is
    
      select distinct d10.pgcod    ln_pgcod10,
                      d10.aomod    ln_mod10,
                      d10.aosuc    ln_suc10,
                      d10.aomda    ln_mda10,
                      d10.aopap    ln_pap10,
                      d10.aocta    ln_cta10,
                      d10.aooper   ln_oper10,
                      d10.aosbop   ln_sbop10,
                      d10.aotope   ln_tope10,
                      d10.aoperiod ln_peri10
        from fsd010 d10
       where d10.Pgcod = 1
         and d10.aomda in (0, 10)
         and d10.aopap = 0
         and d10.Aocta in (select Ctnro
                             from fsr008 f
                            where f.pgcod = 1
                              and f.pepais = ln_pais
                              and f.petdoc = ln_tdoc
                              and f.pendoc = lc_ndoc
                              and cttfir = 'T')
         and d10.Aomod = 141
         and d10.Aostat <> 99;
  
    cursor lista_CredvueloCF(ln_pais number,
                             ln_tdoc number,
                             lc_ndoc varchar2) is
    
      select distinct x.xwfempresa   ln_pgcod10,
                      x.xwfmodulo    ln_mod10,
                      x.xwfsucursal  ln_suc10,
                      x.xwfmoneda    ln_mda10,
                      x.xwfpapel     ln_pap10,
                      x.xwfcuenta    ln_cta10,
                      x.xwfoperacion ln_oper10,
                      x.xwfsubope    ln_sbop10,
                      x.xwftipope    ln_tope10,
                      x.xwfprcins    ln_InstAvalada
        from xwf700 x, wfwrkitems w
       where x.xwfempresa = 1
         and x.xwfmoneda in (0, 101)
         and x.xwfpapel = 0
         and x.xwfcuenta in (select Ctnro
                               from fsr008 f
                              where f.pgcod = 1
                                and f.pepais = ln_pais
                                and f.petdoc = ln_tdoc
                                and f.pendoc = lc_ndoc
                                and cttfir = 'T')
         and x.xwfmodulo = 141
         and x.XWFPRCINS = w.wfinsprcid
         and w.wfitemstsact = 1
         and x.xwfcar3 = '1';
  
    ln_pais        number;
    ln_tdoc        number;
    lc_ndoc        number;
    ln_CuotCntgAux number;
    ln_SaldCap     number;
    ln_tipocambio  number;
    lc_Usuario     varchar2(10);
    ln_moneda      number;
  
  begin
    ln_MntCuoCntgCF := 0;
  
    begin
      select f.pepais, f.petdoc, f.pendoc
        into ln_pais, ln_tdoc, lc_ndoc
        from fsr008 f
       where f.pgcod = 1
         and f.ctnro = ln_cuenta
         and f.cttfir = 'T';
    exception
      when others then
        null;
    end;
  
    ln_tipocambio := fn_tipo_cambio_fijo(P_FECHA => pd_fecpro);
  
    if ln_pais is not null then
    
      for l in lista_CredVigCF(ln_pais, ln_tdoc, lc_ndoc) loop
        begin
          select f.scsdo * -1
            into ln_SaldCap
            from fsd011 f
           where f.pgcod = l.ln_pgcod10
             and f.scsuc = l.ln_suc10
             and f.scmda = l.ln_mda10
             and f.scpap = l.ln_pap10
             and f.sccta = l.ln_cta10
             and f.scoper = l.ln_oper10
             and f.scsbop = l.ln_sbop10
             and f.sctope = l.ln_tope10;
        exception
          when others then
            ln_SaldCap := 0;
        end;
      
        if l.ln_mda10 = 101 then
          ln_SaldCap := ln_SaldCap * ln_tipocambio;
        end if;
      
        ln_CuotCntgAux := (ln_SaldCap * 2.34) / 100; -- mpostigoc 04.08.2022
      
        begin
        
          Pq_Cr_Adelantosueldo.sp_cR_LogRat611(ln_611pai       => ln_pais,
                                               ln_611tdoc      => ln_tdoc,
                                               lc_611ndoc      => lc_ndoc,
                                               ln_611pgcod     => ln_pgcod,
                                               ln_611mod       => ln_modulo,
                                               ln_611suc       => ln_sucursal,
                                               ln_611mda       => ln_mda,
                                               ln_611pap       => ln_papel,
                                               ln_611cta       => ln_cuenta,
                                               ln_611ope       => ln_operacion,
                                               ln_611sope      => ln_suboper,
                                               ln_611tope      => ln_tipoper,
                                               ln_611tcam      => ln_tipocambio,
                                               ld_611fproc     => pd_fecpro,
                                               lc_611user      => lc_Usuario,
                                               ln_611pgcodcr   => l.ln_pgcod10,
                                               ln_611modcr     => l.ln_mod10,
                                               ln_611succr     => l.ln_suc10,
                                               ln_611mdacr     => l.ln_mda10,
                                               ln_611papcr     => l.ln_pap10,
                                               ln_611ctacr     => l.ln_cta10,
                                               ln_611opecr     => l.ln_oper10,
                                               ln_611sopecr    => l.ln_sbop10,
                                               ln_611topecr    => l.ln_tope10,
                                               ln_611percre    => l.ln_peri10,
                                               ln_611numcou    => 999,
                                               ln_611tipsol    => 0,
                                               lc_611indflucaj => 'N',
                                               ln_611mntmaxpen => ln_SaldCap,
                                               ln_611segcre    => 0,
                                               ln_611capflucaj => 0,
                                               ln_611caplin    => 0,
                                               ln_611capcuo    => ln_CuotCntgAux,
                                               lc_611indcre    => 'CredVgntCF',
                                               lc_TipoCarg     => lc_TipCarg);
        
        exception
          when others then
            null;
        end;
      
        ln_MntCuoCntgCF := ln_MntCuoCntgCF + ln_CuotCntgAux;
      
      end loop;
    
      for v in lista_CredvueloCF(ln_pais, ln_tdoc, lc_ndoc) loop
      
        begin
          select w.xwfmonto1, w.xwfmoneda
            into ln_SaldCap, ln_moneda
            from xwf700 w
           where w.xwfprcins = v.ln_InstAvalada
             and w.xwfcar3 = '1';
        exception
          when others then
            ln_SaldCap := 0;
        end;
      
        if ln_moneda = 101 then
          ln_SaldCap := ln_SaldCap * ln_tipocambio;
        end if;
      
        ln_CuotCntgAux := (ln_SaldCap * 2.34) / 100; -- mpostigoc 04.08.2022
      
        begin
          Pq_Cr_Adelantosueldo.sp_cR_LogRat611(ln_611pai       => ln_pais,
                                               ln_611tdoc      => ln_tdoc,
                                               lc_611ndoc      => lc_ndoc,
                                               ln_611pgcod     => ln_pgcod,
                                               ln_611mod       => ln_modulo,
                                               ln_611suc       => ln_sucursal,
                                               ln_611mda       => ln_mda,
                                               ln_611pap       => ln_papel,
                                               ln_611cta       => ln_cuenta,
                                               ln_611ope       => ln_operacion,
                                               ln_611sope      => ln_suboper,
                                               ln_611tope      => ln_tipoper,
                                               ln_611tcam      => ln_tipocambio,
                                               ld_611fproc     => pd_fecpro,
                                               lc_611user      => lc_Usuario,
                                               ln_611pgcodcr   => v.ln_pgcod10,
                                               ln_611modcr     => v.ln_mod10,
                                               ln_611succr     => v.ln_suc10,
                                               ln_611mdacr     => v.ln_mda10,
                                               ln_611papcr     => v.ln_pap10,
                                               ln_611ctacr     => v.ln_cta10,
                                               ln_611opecr     => v.ln_oper10,
                                               ln_611sopecr    => v.ln_sbop10,
                                               ln_611topecr    => v.ln_tope10,
                                               ln_611percre    => 999,
                                               ln_611numcou    => 0,
                                               ln_611tipsol    => 0,
                                               lc_611indflucaj => 'N',
                                               ln_611mntmaxpen => ln_SaldCap,
                                               ln_611segcre    => 0,
                                               ln_611capflucaj => 0,
                                               ln_611caplin    => 0,
                                               ln_611capcuo    => ln_CuotCntgAux,
                                               lc_611indcre    => 'CredVuelCF',
                                               lc_TipoCarg     => lc_TipCarg);
        exception
          when others then
            null;
        end;
      
        ln_MntCuoCntgCF := ln_MntCuoCntgCF + ln_CuotCntgAux;
      
      end loop;
    
    end if;
  
  end sp_cr_CuotaContinCF;
  --------------------------------------------------------------------------------
  procedure sp_cr_CuotaContinAval(ln_pgcod          in number,
                                  ln_modulo         in number,
                                  ln_sucursal       in number,
                                  ln_mda            in number,
                                  ln_papel          in number,
                                  ln_cuenta         in number,
                                  ln_operacion      in number,
                                  ln_suboper        in number,
                                  ln_tipoper        in number,
                                  pd_fecpro         in date,
                                  lc_TipoCarg       in varchar2,
                                  ln_MntCuoCntgAval out number) is
  
    cursor lista_CredVigAval(ln_pais number,
                             ln_tdoc number,
                             lc_doc  varchar2) is
      select distinct h.pgcod  ln_pgcod10,
                      h.aomod  ln_mod10,
                      h.aosuc  ln_suc10,
                      h.aomda  ln_mda10,
                      h.aopap  ln_pap10,
                      h.aocta  ln_cta10,
                      h.aooper ln_oper10,
                      h.aosbop ln_sbop10,
                      h.aotope ln_tope10
        from sng003 g, xwf700 x, fsd010 h
       where g.sng003cta in (select f.ctnro
                               from fsr008 f
                              where f.pepais = ln_pais
                                and f.petdoc = ln_tdoc
                                and f.pendoc = lc_doc
                                and f.cttfir = 'T')
         and g.sng001inst = x.xwfprcins
         and x.xwfcar3 = '1'
         and x.xwfempresa = h.pgcod
         and x.xwfsucursal = h.aosuc
         and x.xwfmodulo = h.aomod
         and x.xwfmoneda = h.aomda
         and x.xwfpapel = h.aopap
         and x.xwfcuenta = h.aocta
         and x.xwfoperacion = h.aooper
         and x.xwfsubope = h.aosbop
         and x.xwftipope = h.aotope
         and (x.xwfmodulo in
             (select k.modulo
                 from fst111 k
                where k.dscod = 50
                  and k.modulo not in (33, 200)) or
             x.xwfmodulo in (117, 141))
         and h.aostat <> 99;
  
    cursor lista_CredvueloAval(ln_pais number,
                               ln_tdoc number,
                               lc_doc  varchar2) is
    
      select distinct x.xwfempresa   ln_pgcod10,
                      x.xwfsucursal  ln_suc10,
                      x.xwfmodulo    ln_mod10,
                      x.xwfmoneda    ln_mda10,
                      x.xwfpapel     ln_pap10,
                      x.xwfcuenta    ln_cta10,
                      x.xwfoperacion ln_oper10,
                      x.xwfsubope    ln_sbop10,
                      x.xwftipope    ln_tope10,
                      x.xwfprcins    ln_InstanciaAvalada
        from sng003 g, xwf700 x, wfwrkitems w
       where g.sng003cta in (select f.ctnro
                               from fsr008 f
                              where f.pepais = ln_pais
                                and f.petdoc = ln_tdoc
                                and f.pendoc = lc_doc
                                and f.cttfir = 'T')
         and g.sng001inst = x.xwfprcins
         and x.xwfcar3 = '1'
         and x.xwfprcins = w.wfinsprcid
         and (x.xwfmodulo in
             (select k.modulo
                 from fst111 k
                where k.dscod = 50
                  and k.modulo not in (33, 200)) or
             x.xwfmodulo in (117, 141))
         and w.wfitemstsact = 1;
  
    ln_pais number;
    ln_tdoc number;
    lc_ndoc varchar2(12);
  
    ln_CuotCntgAux number;
    ln_SaldCap     number;
    ln_tipocambio  number;
    lc_Usuario     varchar2(10);
    -- pd_fecpro      date;
  
    ln_moneda    number;
    lc_verfamp   varchar2(2) := 'N';
    lc_vrfrefrep varchar2(2) := 'N';
    lc_verfvinc  varchar2(2) := 'N';
  
  begin
    ln_MntCuoCntgAval := 0;
  
    begin
      select f.pepais, f.petdoc, f.pendoc
        into ln_pais, ln_tdoc, lc_ndoc
        from fsr008 f
       where f.pgcod = 1
         and f.ctnro = ln_cuenta
         and f.cttfir = 'T';
    exception
      when others then
        null;
    end;
  
    ln_tipocambio := fn_tipo_cambio_fijo(P_FECHA => pd_fecpro);
  
    if ln_pais is not null then
    
      for l in lista_CredVigAval(ln_pais, ln_tdoc, lc_ndoc) loop
      
        ln_SaldCap := 0;
        begin
          pq_cr_ratio_cuocnsm.Sp_ampliados_CK(ln_emp10  => l.ln_pgcod10,
                                              ln_mod10  => l.ln_mod10,
                                              ln_suc10  => l.ln_suc10,
                                              ln_mda10  => l.ln_mda10,
                                              ln_pap10  => l.ln_pap10,
                                              ln_cta10  => l.ln_cta10,
                                              ln_oper10 => l.ln_oper10,
                                              ln_sbop10 => l.ln_sbop10,
                                              ln_tope10 => l.ln_tope10,
                                              Pc_flag   => lc_verfamp);
        
          pq_cr_ratio_cuocnsm.sp_refinanLinea(ln_pgcod10  => l.ln_pgcod10,
                                              ln_mod10    => l.ln_mod10,
                                              ln_suc10    => l.ln_suc10,
                                              ln_mda10    => l.ln_mda10,
                                              ln_pap10    => l.ln_pap10,
                                              ln_cta10    => l.ln_cta10,
                                              ln_oper10   => l.ln_oper10,
                                              lc_fgRefLin => lc_vrfrefrep);
        
          pq_cr_resolutor_cappago.sp_cr_VerVincLinea(ln_mod10  => l.ln_mod10,
                                                     ln_suc10  => l.ln_suc10,
                                                     ln_mda10  => l.ln_mda10,
                                                     ln_pap10  => l.ln_pap10,
                                                     ln_cta10  => l.ln_cta10,
                                                     ln_oper10 => l.ln_oper10,
                                                     ln_sbop10 => l.ln_sbop10,
                                                     ln_tope10 => l.ln_tope10,
                                                     lc_FlgLn  => lc_verfvinc);
        exception
          when others then
            null;
        end;
        if lc_verfamp = 'N' and lc_vrfrefrep = 'N' and lc_verfvinc = 'N' then
        
          if l.ln_mod10 <> 117 then
            begin
              select f.scsdo
                into ln_SaldCap
                from fsd011 f
               where f.pgcod = l.ln_pgcod10
                 and f.scsuc = l.ln_suc10
                 and f.scmda = l.ln_mda10
                 and f.scpap = l.ln_pap10
                 and f.sccta = l.ln_cta10
                 and f.scoper = l.ln_oper10
                 and f.scsbop = l.ln_sbop10
                 and f.sctope = l.ln_tope10;
            exception
              when others then
                ln_SaldCap := 0;
            end;
          
            if ln_SaldCap < 0 then
              ln_SaldCap := ln_SaldCap * -1;
            end if; --mpostigoc 08/07/2019
          
            if l.ln_mda10 = 101 then
              ln_SaldCap := ln_SaldCap * ln_tipocambio;
            end if;
          
          else
            if l.ln_mod10 = 117 then
              begin
                select x.xwfmonto1
                  into ln_SaldCap
                  from xwf700 x
                 where x.xwfempresa = l.ln_pgcod10
                   and x.xwfsucursal = l.ln_suc10
                   and x.xwfmodulo = l.ln_mod10
                   and x.xwfmoneda = l.ln_mda10
                   and x.xwfpapel = l.ln_pap10
                   and x.xwfcuenta = l.ln_cta10
                   and x.xwfoperacion = l.ln_oper10
                   and x.xwfsubope = l.ln_sbop10
                   and x.xwftipope = l.ln_tope10
                   and x.xwfcar3 = '1';
              exception
                when others then
                  ln_SaldCap := 0;
              end;
            
              if ln_SaldCap < 0 then
                ln_SaldCap := ln_SaldCap * -1;
              end if; --mpostigoc 08/07/2019
            
              if l.ln_mda10 = 101 then
                ln_SaldCap := ln_SaldCap * ln_tipocambio;
              end if;
            end if;
          end if;
        
          ln_CuotCntgAux := (ln_SaldCap * 2.34) / 100; -- mpostigoc 04.08.2022
        
          begin
          
            pq_cr_adelantosueldo.sp_cR_LogRat611(ln_611pai       => ln_pais,
                                                 ln_611tdoc      => ln_tdoc,
                                                 lc_611ndoc      => lc_ndoc,
                                                 ln_611pgcod     => ln_pgcod,
                                                 ln_611mod       => ln_modulo,
                                                 ln_611suc       => ln_sucursal,
                                                 ln_611mda       => ln_mda,
                                                 ln_611pap       => ln_papel,
                                                 ln_611cta       => ln_cuenta,
                                                 ln_611ope       => ln_operacion,
                                                 ln_611sope      => ln_suboper,
                                                 ln_611tope      => ln_tipoper,
                                                 ln_611tcam      => ln_tipocambio,
                                                 ld_611fproc     => pd_fecpro,
                                                 lc_611user      => lc_Usuario,
                                                 ln_611pgcodcr   => l.ln_pgcod10,
                                                 ln_611modcr     => l.ln_mod10,
                                                 ln_611succr     => l.ln_suc10,
                                                 ln_611mdacr     => l.ln_mda10,
                                                 ln_611papcr     => l.ln_pap10,
                                                 ln_611ctacr     => l.ln_cta10,
                                                 ln_611opecr     => l.ln_oper10,
                                                 ln_611sopecr    => l.ln_sbop10,
                                                 ln_611topecr    => l.ln_tope10,
                                                 ln_611percre    => 999,
                                                 ln_611numcou    => 0,
                                                 ln_611tipsol    => 0,
                                                 lc_611indflucaj => 'N',
                                                 ln_611mntmaxpen => ln_SaldCap,
                                                 ln_611segcre    => 0,
                                                 ln_611capflucaj => 0,
                                                 ln_611caplin    => 0,
                                                 ln_611capcuo    => ln_CuotCntgAux,
                                                 lc_611indcre    => 'CredVgnAvl',
                                                 lc_TipoCarg     => lc_TipoCarg);
          
          exception
            when others then
              null;
          end;
        
          ln_MntCuoCntgAval := ln_MntCuoCntgAval + ln_CuotCntgAux;
        end if;
      end loop;
    
      for v in lista_CredvueloAval(ln_pais, ln_tdoc, lc_ndoc) loop
        ln_SaldCap := 0;
      
        begin
          select w.xwfmonto1, w.xwfmoneda
            into ln_SaldCap, ln_moneda
            from xwf700 w
           where w.xwfprcins = v.ln_InstanciaAvalada
             and w.xwfcar3 = '1';
        exception
          when others then
            ln_SaldCap := 0;
        end;
      
        if ln_SaldCap < 0 then
          ln_SaldCap := ln_SaldCap * -1;
        end if; --mpostigoc 08/07/2019
      
        if ln_moneda = 101 then
          ln_SaldCap := ln_SaldCap * ln_tipocambio;
        end if;
      
        ln_CuotCntgAux := (ln_SaldCap * 2.34) / 100; -- mpostigoc 04.08.2022
      
        begin
          pq_cr_adelantosueldo.sp_cR_LogRat611(ln_611pai       => ln_pais,
                                               ln_611tdoc      => ln_tdoc,
                                               lc_611ndoc      => lc_ndoc,
                                               ln_611pgcod     => ln_pgcod,
                                               ln_611mod       => ln_modulo,
                                               ln_611suc       => ln_sucursal,
                                               ln_611mda       => ln_mda,
                                               ln_611pap       => ln_papel,
                                               ln_611cta       => ln_cuenta,
                                               ln_611ope       => ln_operacion,
                                               ln_611sope      => ln_suboper,
                                               ln_611tope      => ln_tipoper,
                                               ln_611tcam      => ln_tipocambio,
                                               ld_611fproc     => pd_fecpro,
                                               lc_611user      => lc_Usuario,
                                               ln_611pgcodcr   => v.ln_pgcod10,
                                               ln_611modcr     => v.ln_mod10,
                                               ln_611succr     => v.ln_suc10,
                                               ln_611mdacr     => v.ln_mda10,
                                               ln_611papcr     => v.ln_pap10,
                                               ln_611ctacr     => v.ln_cta10,
                                               ln_611opecr     => v.ln_oper10,
                                               ln_611sopecr    => v.ln_sbop10,
                                               ln_611topecr    => v.ln_tope10,
                                               ln_611percre    => 999,
                                               ln_611numcou    => 0,
                                               ln_611tipsol    => 0,
                                               lc_611indflucaj => 'N',
                                               ln_611mntmaxpen => ln_SaldCap,
                                               ln_611segcre    => 0,
                                               ln_611capflucaj => 0,
                                               ln_611caplin    => 0,
                                               ln_611capcuo    => ln_CuotCntgAux,
                                               lc_611indcre    => 'CredVlAval',
                                               lc_TipoCarg     => lc_TipoCarg);
        exception
          when others then
            null;
        end;
      
        ln_MntCuoCntgAval := ln_MntCuoCntgAval + ln_CuotCntgAux;
      
      end loop;
    
    end if;
  
  end sp_cr_CuotaContinAval;

  -----------------------------------------------
  procedure sp_cr_insertAQPB606(ln_06paid    in number,
                                ln_06tipd    in number,
                                lc_06numd    in varchar2,
                                ld_06fecc    in date,
                                ln_06pgco    in number,
                                ln_06mod     in number,
                                ln_06suc     in number,
                                ln_06mon     in number,
                                ln_06pap     in number,
                                ln_06cta     in number,
                                ln_06ope     in number,
                                ln_06sope    in number,
                                ln_06tipo    in number,
                                lc_06lstn    in varchar2,
                                lc_06abo6    in varchar2,
                                ln_06mntm    in number,
                                ln_06proa    in number,
                                lc_06cal6    in varchar2,
                                lc_06scos    in varchar2,
                                ln_06nroa    in number,
                                lc_06tipv    in varchar2,
                                lc_06sobr    in varchar2,
                                lc_06crej    in varchar2,
                                lc_06traa    in varchar2,
                                lc_06ilet    in varchar2,
                                ln_06salc    in number,
                                lc_06ades    in varchar2,
                                ln_06rat     in number,
                                lc_DsctJudic in varchar2,
                                lc_Tcarga    in varchar2) is
  
    lc_hora char(8) := '00:00:00';
    lc_code varchar2(100);
    lc_msge varchar2(1000);
    ln_corr number;
  
  begin
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    exception
      when others then
        null;
    end;
  
    begin
      select max(a.aqpb606corr)
        into ln_corr
        from aqpb606 a
       where a.aqpb606fecc = ld_06fecc;
    exception
      when others then
        ln_corr := 0;
    end;
  
    begin
      update aqpb606 a
         set a.aqpb606est = 'I'
       where a.aqpb606pgco = ln_06pgco
         and a.aqpb606mod = ln_06mod
         and a.aqpb606suc = ln_06suc
         and a.aqpb606mon = ln_06mon
         and a.aqpb606pap = ln_06pap
         and a.aqpb606cta = ln_06cta
         and a.aqpb606ope = ln_06ope
         and a.aqpb606sope = ln_06sope
         and a.aqpb606tipo = ln_06tipo
         and a.aqpb606tcarg = 'C';
      commit;
    exception
      when others then
        null;
    end;
  
    ln_corr := nvl(ln_corr, 0);
  
    begin
    
      insert into aqpb606
        (aqpb606corr,
         aqpb606paid,
         aqpb606tipd,
         aqpb606numd,
         aqpb606fecc,
         aqpb606horc,
         aqpb606pgco,
         aqpb606mod,
         aqpb606suc,
         aqpb606mon,
         aqpb606pap,
         aqpb606cta,
         aqpb606ope,
         aqpb606sope,
         aqpb606tipo,
         aqpb606lstn,
         aqpb606abo6,
         aqpb606mntm,
         aqpb606proa,
         aqpb606cal6,
         aqpb606scos,
         aqpb606nroa,
         aqpb606tipv,
         aqpb606sobr,
         aqpb606crej,
         aqpb606traa,
         aqpb606ilet,
         aqpb606salc,
         aqpb606ades,
         aqpb606rat,
         aqpb606tcarg,
         aqpb606est,
         AQPB606DSCJUD)
      values
        (ln_corr + 1,
         ln_06paid,
         ln_06tipd,
         trim(lc_06numd),
         ld_06fecc,
         lc_hora,
         ln_06pgco,
         ln_06mod,
         ln_06suc,
         ln_06mon,
         ln_06pap,
         ln_06cta,
         ln_06ope,
         ln_06sope,
         ln_06tipo,
         lc_06lstn,
         lc_06abo6,
         ln_06mntm,
         ln_06proa,
         lc_06cal6,
         lc_06scos,
         ln_06nroa,
         lc_06tipv,
         lc_06sobr,
         lc_06crej,
         lc_06traa,
         lc_06ilet,
         ln_06salc,
         lc_06ades,
         ln_06rat,
         lc_Tcarga,
         'H',
         lc_DsctJudic);
    exception
      when others then
        lc_code := sqlcode;
        lc_msge := sqlerrm;
    end;
  
    commit;
  end sp_cr_insertAQPB606;

  -------------------------------------------
  procedure sp_cr_insertAQPB607(ln_07PAID   in number,
                                ln_07TIPD   in number,
                                lc_07NUMD   in varchar2,
                                ld_07FECC   in date,
                                ln_07PGCO   in number,
                                ln_07MOD    in number,
                                ln_07SUC    in number,
                                ln_07MON    in number,
                                ln_07PAP    in number,
                                ln_07CTA    in number,
                                ln_07OPE    in number,
                                ln_07SOPE   in number,
                                ln_07TIPO   in number,
                                ln_07TIPC   in number,
                                ln_07TASA   in number,
                                ln_07SALC   in number,
                                ln_07RAT    in number,
                                ln_07MOND   in number,
                                ln_07NROC   in number,
                                lc_07EST    in varchar2,
                                ln_mntprop  in number,
                                ln_modcred  in number,
                                ln_topecred in number) is
  
    lc_07HORC char(8) := '00:00:00';
    ln_07CORR number := 0;
  
  begin
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_07HORC from dual;
    exception
      when others then
        null;
    end;
  
    begin
      select max(a.aqpb607corr)
        into ln_07CORR
        from aqpb607 a
       where a.aqpb607fecc = ld_07FECC;
    exception
      when others then
        ln_07CORR := 0;
    end;
  
    ln_07CORR := nvl(ln_07CORR, 0);
  
    begin
      insert into AQPB607
        (AQPB607CORR,
         AQPB607PAID,
         AQPB607TIPD,
         AQPB607NUMD,
         AQPB607FECC,
         AQPB607HORC,
         AQPB607PGCO,
         AQPB607MOD,
         AQPB607SUC,
         AQPB607MON,
         AQPB607PAP,
         AQPB607CTA,
         AQPB607OPE,
         AQPB607SOPE,
         AQPB607TIPO,
         AQPB607TIPC,
         AQPB607TASA,
         AQPB607SALC,
         AQPB607RAT,
         AQPB607MOND,
         AQPB607NROC,
         AQPB607EST,
         aqpb607tcarg,
         AQPB607MNTPROP,
         AQPB607MODC,
         AQPB607TIPOC,
         AQPB607OFERT)
      values
        (ln_07CORR + 1,
         ln_07PAID,
         ln_07TIPD,
         trim(lc_07NUMD),
         ld_07FECC,
         lc_07HORC,
         ln_07PGCO,
         ln_07MOD,
         ln_07SUC,
         ln_07MON,
         ln_07PAP,
         ln_07CTA,
         ln_07OPE,
         ln_07SOPE,
         ln_07TIPO,
         ln_07TIPC,
         ln_07TASA,
         ln_07SALC,
         ln_07RAT,
         ln_07MOND,
         ln_07NROC,
         lc_07EST,
         'M',
         ln_mntprop,
         ln_modcred,
         ln_topecred,
         'H');
    exception
      when others then
        null;
    end;
    commit;
  
  end sp_cr_insertAQPB607;
  --------------------------------------------
  procedure sp_cr_LogRat610(ln_610pai     in number,
                            ln_610tdoc    in number,
                            lc_610ndoc    in varchar2,
                            ln_610pgcod   in number,
                            ln_610mod     in number,
                            ln_610suc     in number,
                            ln_610mda     in number,
                            ln_610pap     in number,
                            ln_610cta     in number,
                            ln_610ope     in number,
                            ln_610sope    in number,
                            ln_610tope    in number,
                            ln_610tcam    in number,
                            ld_610fproc   in date,
                            lc_610user    in varchar2,
                            ln_610mntca   in number,
                            ln_610mntifis in number,
                            ln_610cuopot  in number,
                            ln_610cupcon  in number,
                            ln_610ingnet  in number,
                            ln_610ratio   in number,
                            lc_606tcarg   in varchar2) is
  
    lc_610est   varchar2(5) := 'H';
    ln_corr     number;
    lc_610hproc char(8) := '00:00:00';
  
  begin
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_610hproc from dual;
    exception
      when others then
        null;
    end;
  
    begin
      select max(a.aqpb610corr)
        into ln_corr
        from aqpb610 a
       where a.aqpb610pai = ln_610pai
         and a.aqpb610tdoc = ln_610tdoc
         and a.aqpb610ndoc = lc_610ndoc
         and a.aqpb610pgcod = ln_610pgcod
         and a.aqpb610mod = ln_610mod
         and a.aqpb610suc = ln_610suc
         and a.aqpb610mda = ln_610mda
         and a.aqpb610pap = ln_610pap
         and a.aqpb610cta = ln_610cta
         and a.aqpb610ope = ln_610ope
         and a.aqpb610sope = ln_610sope
         and a.aqpb610tope = ln_610tope;
    exception
      when others then
        ln_corr := 0;
    end;
    ln_corr := nvl(ln_corr, 0);
  
    begin
    
      insert into aqpb610
        (aqpb610corr,
         aqpb610pai,
         aqpb610tdoc,
         aqpb610ndoc,
         aqpb610pgcod,
         aqpb610mod,
         aqpb610suc,
         aqpb610mda,
         aqpb610pap,
         aqpb610cta,
         aqpb610ope,
         aqpb610sope,
         aqpb610tope,
         aqpb610tcam,
         aqpb610fproc,
         aqpb610hproc,
         aqpb610user,
         aqpb610mntca,
         aqpb610mntifis,
         aqpb610cuopot,
         aqpb610cupcon,
         aqpb610ingnet,
         aqpb610ratio,
         aqpb610est,
         aqpb610tcarg)
      values
        (ln_corr + 1,
         ln_610pai,
         ln_610tdoc,
         lc_610ndoc,
         ln_610pgcod,
         ln_610mod,
         ln_610suc,
         ln_610mda,
         ln_610pap,
         ln_610cta,
         ln_610ope,
         ln_610sope,
         ln_610tope,
         ln_610tcam,
         ld_610fproc,
         lc_610hproc,
         lc_610user,
         ln_610mntca,
         ln_610mntifis,
         ln_610cuopot,
         ln_610cupcon,
         ln_610ingnet,
         ln_610ratio,
         lc_610est,
         lc_606tcarg);
      commit;
    exception
      when others then
        null;
    end;
  
  end sp_cr_LogRat610;
  --------------------------------------------
  procedure sp_cR_LogRat611(ln_611pai       in number,
                            ln_611tdoc      in number,
                            lc_611ndoc      in varchar2,
                            ln_611pgcod     in number,
                            ln_611mod       in number,
                            ln_611suc       in number,
                            ln_611mda       in number,
                            ln_611pap       in number,
                            ln_611cta       in number,
                            ln_611ope       in number,
                            ln_611sope      in number,
                            ln_611tope      in number,
                            ln_611tcam      in number,
                            ld_611fproc     in date,
                            lc_611user      in varchar2,
                            ln_611pgcodcr   in number,
                            ln_611modcr     in number,
                            ln_611succr     in number,
                            ln_611mdacr     in number,
                            ln_611papcr     in number,
                            ln_611ctacr     in number,
                            ln_611opecr     in number,
                            ln_611sopecr    in number,
                            ln_611topecr    in number,
                            ln_611percre    in number,
                            ln_611numcou    in number,
                            ln_611tipsol    in number,
                            lc_611indflucaj in varchar2,
                            ln_611mntmaxpen in number,
                            ln_611segcre    in number,
                            ln_611capflucaj in number,
                            ln_611caplin    in number,
                            ln_611capcuo    in number,
                            lc_611indcre    in varchar2,
                            lc_TipoCarg     in varchar2) is
  
    ln_corr     number;
    lc_611hproc char(8) := '00:00:00';
    lc_611est   varchar2(5);
  
  begin
  
    lc_611est := 'H';
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_611hproc from dual;
    exception
      when others then
        null;
    end;
  
    begin
      select max(a.aqpb611corr)
        into ln_corr
        from aqpb611 a
       where a.aqpb611pai = ln_611pai
         and a.aqpb611tdoc = ln_611tdoc
         and a.aqpb611ndoc = lc_611ndoc
         and a.aqpb611pgcod = ln_611pgcod
         and a.aqpb611mod = ln_611mod
         and a.aqpb611suc = ln_611suc
         and a.aqpb611mda = ln_611mda
         and a.aqpb611pap = ln_611pap
         and a.aqpb611cta = ln_611cta
         and a.aqpb611ope = ln_611ope
         and a.aqpb611sope = ln_611sope
         and a.aqpb611tope = ln_611tope;
    exception
      when others then
        ln_corr := 0;
    end;
    ln_corr := nvl(ln_corr, 0);
  
    begin
      insert into aqpb611
        (aqpb611corr,
         aqpb611pai,
         aqpb611tdoc,
         aqpb611ndoc,
         aqpb611pgcod,
         aqpb611mod,
         aqpb611suc,
         aqpb611mda,
         aqpb611pap,
         aqpb611cta,
         aqpb611ope,
         aqpb611sope,
         aqpb611tope,
         aqpb611tcam,
         aqpb611fproc,
         aqpb611hproc,
         aqpb611user,
         aqpb611pgcodcr,
         aqpb611modcr,
         aqpb611succr,
         aqpb611mdacr,
         aqpb611papcr,
         aqpb611ctacr,
         aqpb611opecr,
         aqpb611sopecr,
         aqpb611topecr,
         aqpb611percre,
         aqpb611numcou,
         aqpb611tipsol,
         aqpb611indflucaj,
         aqpb611mntmaxpen,
         aqpb611segcre,
         aqpb611capflucaj,
         aqpb611caplin,
         aqpb611capcuo,
         aqpb611indcre,
         aqpb611est,
         AQPB611TCARG)
      values
        (ln_corr + 1,
         ln_611pai,
         ln_611tdoc,
         lc_611ndoc,
         ln_611pgcod,
         ln_611mod,
         ln_611suc,
         ln_611mda,
         ln_611pap,
         ln_611cta,
         ln_611ope,
         ln_611sope,
         ln_611tope,
         ln_611tcam,
         ld_611fproc,
         lc_611hproc,
         lc_611user,
         ln_611pgcodcr,
         ln_611modcr,
         ln_611succr,
         ln_611mdacr,
         ln_611papcr,
         ln_611ctacr,
         ln_611opecr,
         ln_611sopecr,
         ln_611topecr,
         ln_611percre,
         ln_611numcou,
         ln_611tipsol,
         lc_611indflucaj,
         ln_611mntmaxpen,
         ln_611segcre,
         ln_611capflucaj,
         ln_611caplin,
         ln_611capcuo,
         lc_611indcre,
         lc_611est,
         lc_TipoCarg);
      commit;
    exception
      when others then
        null;
    end;
  
  end sp_cR_LogRat611;

  --------------------------------------------
  procedure sp_cr_carga is
  
  begin
  
    --carga data inicial  aqpb606
    begin
      pq_cr_adelantosueldo.sp_cr_job_cargaaqpb606;
    exception
      when others then
        null;
    end;
  
    --inserta en aqpb607 data final
    begin
      pq_cr_adelantosueldo.sp_cr_cargaaqpb607;
    exception
      when others then
        null;
    end;
  
  end sp_cr_carga;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  

  Function fn_cr_verifica_tarea2(P_C_NOMJOB IN VARCHAR2,
                                 P_C_HOSTNA IN VARCHAR2,
                                 pn_paquete in varchar2,
                                 pn_proceso in varchar2) return number is
    --2019.07.22 DCASTRO se implementaron jobs para optimizar la carga, creacion guia de proceso para hostname
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
    exception
      when others then
        null;
    end;
  
    begin
    
      lc_pac_nombre := upper(trim(pn_paquete) || '.' || trim(pn_proceso));
    
      SELECT count(*)
        INTO ln_numjob
        FROM dba_jobs x
       WHERE x.schema_user = lc_nomusr -- 'BANTPROD'
         AND upper(x.what) LIKE '%' || trim(lc_pac_nombre) || '%';
    
    exception
      when others then
        null;
    end;
  
    return ln_numjob;
  end fn_cr_verifica_tarea2;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_cr_job_cargaAQPB606 is
  
    ln_ini      number;
    lc_variable varchar2(4000);
    ln_job      number := 0;
    --lc_fecpro   char(10);
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
    ln_cant       number := 0;
  
  begin
  
    begin
      select TRIM(TP1DESC)
        INTO lc_nomusr
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10847
         and tp1corr1 = 999; ---2019.07.22 guia de proceso para hostname
    exception
      when others then
        null;
    end;
  
    begin
      select host_name into lc_hostname from v$instance;
    exception
      when others then
        null;
    end;
  
    -- Eliminación del registro por usuario
    -- delete from aqpb606 t;
    -- commit;
  
    lc_prefijo    := 'SUELDO';
    lc_paquete    := 'pq_cr_adelantosueldo';
    lc_proceso    := 'sp_cr_cargaAQPB606';
    lc_pac_nombre := upper(trim(lc_paquete) || '.' || trim(lc_proceso));
  
    ---carga 
    while ln_cant < 50 loop
      ln_ini        := ln_cant;
      ln_job        := ln_job + 1;
      lc_prefjob    := lc_prefijo;
      pi_vc2_nomjob := lc_prefjob || lpad(ln_ini, 3, '0'); ---ln_job
      lc_variable   := 'begin ' ||
                       '  pq_cr_adelantosueldo.sp_cr_cargaaqpb606( ''' ||
                       ln_ini || ''' );' || ' End;';
      /*
                         '  pq_cr_reporte_fondos.sp_reporte_faemype_r1( TO_DATE(''' ||
                         lc_fecpro || ''',''RRRR.MM.DD''),' || ln_ini ||
                         ',''' || pn_usuario || ''' );' || ' End;';
      */
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        dbms_job.submit(job_id,
                        what      => lc_variable,
                        next_date => sysdate,
                        interval  => null,
                        no_parse  => false,
                        instance  => 2,
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
    
      INSERT INTO Tab_jobs
        (c_codage, n_Numer1, c_detjob)
      VALUES
        (lc_prefijo, ln_ini, lc_variable);
      COMMIT;
    
      ln_cant := ln_cant + 1;
    end loop;
  
    ln_numjob := pq_cr_adelantosueldo.fn_cr_verifica_tarea2(p_c_nomjob => lc_prefjob,
                                                            p_c_hostna => lc_hostname,
                                                            pn_paquete => lc_paquete,
                                                            pn_proceso => lc_proceso);
  
    While ln_numjob > 0 loop
      ln_numjob := pq_cr_adelantosueldo.fn_cr_verifica_tarea2(p_c_nomjob => lc_prefjob,
                                                              p_c_hostna => lc_hostname,
                                                              pn_paquete => lc_paquete,
                                                              pn_proceso => lc_proceso);
    End loop;
  
  end sp_cr_job_cargaAQPB606;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
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
  ------------------------------------

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
           and aomda = 0
           and aopap = 0
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
    
      SELECT (PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                            PD_FECPRE,
                                                            '^14.[1-6]0302') *
              0.044) + (CASE
                WHEN PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                  PD_FECPRE,
                                                                  '^14.[1-6]030602') <=
                     30000 THEN
                 PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                              PD_FECPRE,
                                                              '^14.[1-6]030602') *
                 0.0264
                ELSE
                 PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                              PD_FECPRE,
                                                              '^14.[1-6]030602') *
                 0.0222
              END) +
             
              (CASE
                WHEN (PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]0306') -
                     PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]030602') -
                     PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]030611') -
                     PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]030612')) <= 8000 THEN
                 (PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]0306') -
                 PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]030602') -
                 PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]030611') -
                 PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]030612')) *
                 0.0514
                WHEN (PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]0306') -
                     PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]030602') -
                     PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]030611') -
                     PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]030612')) <=
                     15000 THEN
                 (PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]0306') -
                 PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]030602') -
                 PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]030611') -
                 PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]030612')) *
                 0.0356
                WHEN (PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]0306') -
                     PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]030602') -
                     PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]030611') -
                     PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]030612')) <=
                     45000 THEN
                 (PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]0306') -
                 PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]030602') -
                 PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]030611') -
                 PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]030612')) *
                 0.0282
                WHEN (PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]0306') -
                     PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]030602') -
                     PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]030611') -
                     PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]030612')) >
                     45000 THEN
                 (PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]0306') -
                 PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]030602') -
                 PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]030611') -
                 PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]030612')) *
                 0.0222
              END) +
             
              ((PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                             PD_FECPRE,
                                                             '^14.[1-6]030611') +
              PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                             PD_FECPRE,
                                                             '^14.[1-6]030612')) *
              0.088) +
             
              (CASE
                WHEN (PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]030611') +
                     PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]030612')) <=
                     10000 THEN
                 (PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]030611') +
                 PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]030612')) *
                 0.0349
                WHEN (PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]030611') +
                     PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]030612')) <=
                     20000 THEN
                 (PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]030611') +
                 PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]030612')) *
                 0.0248
                WHEN (PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]030611') +
                     PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]030612')) <=
                     30000 THEN
                 (PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]030611') +
                 PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]030612')) *
                 0.0224
                WHEN (PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]030611') +
                     PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]030612')) >
                     30000 THEN
                 (PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]030611') +
                 PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]030612')) *
                 0.0205
              END) +
             
              (PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                            PD_FECPRE,
                                                            '^14.[1-6]04') *
              0.009) +
             
              (CASE
                WHEN (PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]12') +
                     PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]02') +
                     PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]13') -
                     PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]020601') -
                     PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]029901') -
                     PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]0202') -
                     PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]130601') -
                     PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]1302')) <= 8000 THEN
                 (PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]12') +
                 PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]02') +
                 PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]13') -
                 PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]020601') -
                 PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]029901') -
                 PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]0202') -
                 PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]130601') -
                 PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]1302')) *
                 0.0514
                WHEN (PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]12') +
                     PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]02') +
                     PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]13') -
                     PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]020601') -
                     PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]029901') -
                     PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]0202') -
                     PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]130601') -
                     PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]1302')) <=
                     15000 THEN
                 (PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]12') +
                 PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]02') +
                 PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]13') -
                 PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]020601') -
                 PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]029901') -
                 PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]0202') -
                 PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]130601') -
                 PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]1302')) *
                 0.0356
                WHEN (PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]12') +
                     PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]02') +
                     PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]13') -
                     PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]020601') -
                     PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]029901') -
                     PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]0202') -
                     PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]130601') -
                     PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]1302')) <=
                     45000 THEN
                 (PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]12') +
                 PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]02') +
                 PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]13') -
                 PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]020601') -
                 PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]029901') -
                 PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]0202') -
                 PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]130601') -
                 PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]1302')) *
                 0.0282
                WHEN (PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]12') +
                     PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]02') +
                     PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]13') -
                     PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]020601') -
                     PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]029901') -
                     PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]0202') -
                     PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]130601') -
                     PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                                   PD_FECPRE,
                                                                   '^14.[1-6]1302')) >
                     45000 THEN
                 (PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]12') +
                 PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]02') +
                 PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]13') -
                 PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]020601') -
                 PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]029901') -
                 PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]0202') -
                 PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]130601') -
                 PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                               PD_FECPRE,
                                                               '^14.[1-6]1302')) *
                 0.0222
              END) +
             
              ((PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                             PD_FECPRE,
                                                             '^14.[1-6]020601') +
              PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                             PD_FECPRE,
                                                             '^14.[1-6]029901') +
              PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                             PD_FECPRE,
                                                             '^14.[1-6]0202') +
              PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                             PD_FECPRE,
                                                             '^14.[1-6]130601') +
              PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
                                                             PD_FECPRE,
                                                             '^14.[1-6]1302')) * 0.09) +
             /*
                     ((RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS, PD_FECPRE, '^72.50602')+
                       RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS, PD_FECPRE, '^72.50613'))   * 0.0378) +
             */
              (PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_CTA_CTBLE_SC(PC_CODSBS,
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
                    0.03 * NVL(PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_DEUDA_ENT(VI_PC_CODSBS,
                                                                         VI_PD_FECPRE,
                                                                         l.c_codemp),
                               0) * 0.044
                   WHEN (CASE
                          WHEN VI_SF_LIN_MTO_TOT > 0 THEN
                           ROUND(VI_SF_LIN_MTO_USADO / VI_SF_LIN_MTO_TOT, 4)
                          ELSE
                           0
                        END) < 0.65 THEN
                    0.07 * NVL(PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_DEUDA_ENT(VI_PC_CODSBS,
                                                                         VI_PD_FECPRE,
                                                                         l.c_codemp),
                               0) * 0.044
                   WHEN (CASE
                          WHEN VI_SF_LIN_MTO_TOT > 0 THEN
                           ROUND(VI_SF_LIN_MTO_USADO / VI_SF_LIN_MTO_TOT, 4)
                          ELSE
                           0
                        END) < 0.85 THEN
                    0.12 * NVL(PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_DEUDA_ENT(VI_PC_CODSBS,
                                                                         VI_PD_FECPRE,
                                                                         l.c_codemp),
                               0) * 0.044
                   WHEN (CASE
                          WHEN VI_SF_LIN_MTO_TOT > 0 THEN
                           ROUND(VI_SF_LIN_MTO_USADO / VI_SF_LIN_MTO_TOT, 4)
                          ELSE
                           0
                        END) >= 0.85 THEN
                    0.25 * NVL(PQ_CR_ADELANTOSUELDO.RCC_FN_MTO_DEUDA_ENT(VI_PC_CODSBS,
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

end PQ_CR_ADELANTOSUELDO;
/

