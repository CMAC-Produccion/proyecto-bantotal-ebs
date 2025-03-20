create or replace package PQ_CR_RATIO_EVALFLUJO_RTE is

  -- Author  : MPOSTIGOC
  -- Created : 10/04/2019 6:17:17 p. m.
  -- Fecha de Modificación      : 15/03/2024
  -- Autor de la Modificación   :  Maria Postigo
  -- Descripción de Modificación: Se descomento el monto de cuota potencial en el denominador de la formula  
  ------------------------------------------------------

  procedure sp_cr_VerfEvalFlujo(ln_Instancia in number,
                                ln_EvalFlujo out varchar2);
  -----------------------------------------------------------
  procedure sp_cr_InicioRatio(ln_pgcod      in number,
                              ln_itsuc      in number,
                              ln_itmod      in number,
                              ln_ittran     in number,
                              ln_itnrel     in number,
                              ln_itord      in number,
                              ln_itsbor     in number,
                              lc_Usuario    in varchar2,
                              ld_FecProc    in date,
                              ln_capcmac    out number,
                              ln_capifis    out number,
                              ln_capcontgnt out number,
                              ln_capptncl   out number,
                              ln_ResulNeto  out number,
                              ln_Ratio      out number);
  -----------------------------------------------------------------------
  procedure sp_cr_CalcCuentasII(ln_instl      in number,
                                ld_fchEval    in date,
                                ln_inste      in number,
                                ln_pgcod      in number,
                                ln_itsuc      in number,
                                ln_itmod      in number,
                                ln_ittran     in number,
                                ln_itnrel     in number,
                                ln_itord      in number,
                                ln_itsbor     in number,
                                ln_pgcod116   in number,
                                ln_mod116     in number,
                                ln_tope116    in number,
                                ln_suc116     in number,
                                ln_mda116     in number,
                                ln_pap116     in number,
                                ln_cta116     in number,
                                ln_oper116    in number,
                                ln_sbop116    in number,
                                ln_pgcod117   in number,
                                ln_mod117     in number,
                                ln_suc117     in number,
                                ln_mda117     in number,
                                ln_pap117     in number,
                                ln_cta117     in number,
                                ln_oper117    in number,
                                ln_sbop117    in number,
                                ln_tope117    in number,
                                lc_Usuario    in varchar2,
                                ld_FecProc    in date,
                                ln_capcontgnt out number);
  ------------------------------------------------------------------------
  procedure sp_cr_CalcRatio(ln_Instancia in number,
                            ln_inste     in number,
                            ln_pgcod     in number,
                            ln_itsuc     in number,
                            ln_itmod     in number,
                            ln_ittran    in number,
                            ln_itnrel    in number,
                            ln_itord     in number,
                            ln_itsbor    in number,
                            ld_FecProc   in date);
  --------------------------------------------------------------
  procedure sp_cr_DatosRatio(ln_instancia  in number,
                             ln_InsEval    in number,
                             ln_pgcod      in number,
                             ln_itsuc      in number,
                             ln_itmod      in number,
                             ln_ittran     in number,
                             ln_itnrel     in number,
                             ln_itord      in number,
                             ln_itsbor     in number,
                             ld_FecProc    in date,
                             ln_capcaja    out number,
                             ln_capifis    out number,
                             ln_capcontgnt out number,
                             ln_capptncl   out number,
                             ln_ResulNeto  out number,
                             ln_Ratio      out number);
  --------------------------------------------------------------                             
  procedure sp_cr_ActMntCuota(ln_Instancia in number,
                              ln_pgcod     in number,
                              ln_itsuc     in number,
                              ln_itmod     in number,
                              ln_ittran    in number,
                              ln_itnrel    in number,
                              ln_itord     in number,
                              ln_itsbor    in number,
                              ld_fecpro    in date,
                              lc_mesanio   in varchar2);
  ------------------------------------------------------------
  procedure sp_cr_CuotaContinCF(ln_Instancia    in number,
                                ln_InstEval     in number,
                                ld_fchEval      in date,
                                ln_pgcod        in number,
                                ln_itsuc        in number,
                                ln_itmod        in number,
                                ln_ittran       in number,
                                ln_itnrel       in number,
                                ln_itord        in number,
                                ln_itsbor       in number,
                                pd_fecpro       in date,
                                lc_Usuario      in varchar2,
                                ln_MntCuoCntgCF out number);
  -----------------------------------------------------------
  procedure sp_cr_CuotaContinAval(ln_Instancia      in number,
                                  ln_InstEval       in number,
                                  ld_fchEval        in date,
                                  ln_pgcod          in number,
                                  ln_itsuc          in number,
                                  ln_itmod          in number,
                                  ln_ittran         in number,
                                  ln_itnrel         in number,
                                  ln_itord          in number,
                                  ln_itsbor         in number,
                                  pd_fecpro         in date,
                                  lc_Usuario        in varchar2,
                                  ln_MntCuoCntgAval out number);
  ----------------------------------------------------------
  procedure sp_cr_CuotaPotencial(ln_Instancia   in number,
                                 ln_pgcod       in number,
                                 ln_itsuc       in number,
                                 ln_modulo      in number,
                                 ln_trans       in number,
                                 ln_rela        in number,
                                 ld_fcont       in date,
                                 lc_usuario     in varchar2,
                                 ln_MntPotncial out number);
  ------------------------------------------------------------
  procedure sp_cr_fchUltEval(ln_pgcod         in number,
                             ln_itsuc         in number,
                             ln_itmod         in number,
                             ln_ittran        in number,
                             ln_itnrel        in number,
                             ln_itord         in number,
                             ln_itsbor        in number,
                             ln_InstLinea     out number,
                             ld_fchevaluacion out date,
                             ln_InstEval      out number);
  -------------------------------------------------------
  procedure sp_cr_fchUltEvalII(ln_pgcod         in number,
                               ln_itsuc         in number,
                               ln_itmod         in number,
                               ln_ittran        in number,
                               ln_itnrel        in number,
                               ln_itord         in number,
                               ln_itsbor        in number,
                               ln_InstLinea     out number,
                               ld_fchevaluacion out date,
                               ln_InstEval      out number,
                               lc_SacaInfo      out varchar2);
  -----------------------------------------------------------
  procedure sp_cr_LogRatio(ln_Pepais      in number,
                           ln_Petdoc      in number,
                           ln_Pendoc      in varchar2,
                           tipocambio     in number,
                           pd_fecpro      in date,
                           ln_instl       in number,
                           ln_inste       in number,
                           ln_pgcod       in number,
                           ln_itsuc       in number,
                           ln_itmod       in number,
                           ln_ittran      in number,
                           ln_itnrel      in number,
                           ln_itord       in number,
                           ln_itsbor      in number,
                           lc_Usuario     in varchar2,
                           lc_mesanio     in varchar2,
                           ln_captotcaja  in number,
                           ln_ifis        in number,
                           ln_ResultNeto  in number,
                           ln_MntCuoCntg  in number,
                           ln_MntPotncial in number,
                           ln_ratio       in number);
  ---------------------------------------------------------
  procedure sp_cr_LogDetMensualII(ln_Instancia   in number,
                                  ln_pgcod       in number,
                                  ln_itsuc       in number,
                                  ln_itmod       in number,
                                  ln_ittran      in number,
                                  ln_itnrel      in number,
                                  ln_itord       in number,
                                  ln_itsbor      in number,
                                  ld_FecProc     in date,
                                  ln_modulo      in number,
                                  ln_mntcuota    in number,
                                  ld_fchPanel    in date,
                                  ln_NroCuOtorg  in number,
                                  ln_NroCuotCred in number,
                                  lc_Indicador   in varchar2);
  --------------------------------------------------
  procedure sp_cr_LogDetMensPanel(ln_Instancia   in number,
                                  ln_pgcod       in number,
                                  ln_itsuc       in number,
                                  ln_itmod       in number,
                                  ln_ittran      in number,
                                  ln_itnrel      in number,
                                  ln_itord       in number,
                                  ln_itsbor      in number,
                                  ld_FecProc     in date,
                                  ln_modulo      in number,
                                  ln_mntcuota    in number,
                                  ld_fchPanel    in date,
                                  ln_NroCuOtorg  in number,
                                  ln_NroCuotCred in number,
                                  lc_Indicador   in varchar2);
  -------------------------------------------------------
  procedure sp_cr_LogCuentas(ld_fec     in date,
                             lc_user    in varchar2,
                             ln_pais    in number,
                             ln_tdoc    in number,
                             ln_ndoc    in varchar2,
                             ln_tcamb   in number,
                             ln_instl   in number,
                             ln_inste   in number,
                             ln_pgcod   in number,
                             ln_itsuc   in number,
                             ln_itmod   in number,
                             ln_ittran  in number,
                             ln_itnrel  in number,
                             ln_itord   in number,
                             ln_itsbor  in number,
                             ld_feval   in date,
                             ld_fical   in date,
                             ln_emp     in number,
                             ln_mod     in number,
                             ln_suc     in number,
                             ln_mda     in number,
                             ln_pap     in number,
                             ln_cta     in number,
                             ln_ope     in number,
                             ln_sbop    in number,
                             ln_tope    in number,
                             ln_TipoOri in number,
                             ln_NroCuot in number,
                             lc_IndCred in varchar2,
                             ln_SaldCap in number,
                             ln_monto   in number);
  --------------------------------------------------------
  procedure sp_cr_DatosPanelEF(ld_FecPro     in date,
                               ln_instl      in number,
                               ln_inste      in number,
                               ln_pgcod      in number,
                               ln_itsuc      in number,
                               ln_itmod      in number,
                               ln_ittran     in number,
                               ln_itnrel     in number,
                               ln_itord      in number,
                               ln_itsbor     in number,
                               lc_Usuario    in varchar2,
                               ln_capcontgnt in number,
                               lc_SacasInfo  in varchar2);
  -----------------------------------------------------------
  procedure sp_cr_CalFormula(ln_Instancia in number,
                             -- ln_inste     in number,
                             ln_pgcod   in number,
                             ln_itsuc   in number,
                             ln_itmod   in number,
                             ln_ittran  in number,
                             ln_itnrel  in number,
                             ln_itord   in number,
                             ln_itsbor  in number,
                             ld_FecProc in date);
  ----------------------------------------------------------
  Procedure sp_cr_recalculaRN(pn_ins     in number,
                              ln_pgcod   in number,
                              ln_itsuc   in number,
                              ln_itmod   in number,
                              ln_ittran  in number,
                              ln_itnrel  in number,
                              ln_itord   in number,
                              ln_itsbor  in number,
                              ld_FecProc in date);
  ----------------------------------------------------------
  procedure sp_cr_UpRN_AQPA358(ln_instancia in number,
                               ln_pgcod     in number,
                               ln_itsuc     in number,
                               ln_itmod     in number,
                               ln_ittran    in number,
                               ln_itnrel    in number,
                               ln_itord     in number,
                               ln_itsbor    in number,
                               ld_FecProc   in date);
  -------------------------------------------------------------
  procedure sp_cr_UpEstado(ln_pgcod   in number,
                           ln_itsuc   in number,
                           ln_itmod   in number,
                           ln_ittran  in number,
                           ln_itnrel  in number,
                           ln_itord   in number,
                           ln_itsbor  in number,
                           ld_FecProc in date);
  --------------------------------------------------------------
  procedure sp_cr_ExtornarREF(ln_pgcod   in number,
                              ln_itsuc   in number,
                              ln_itmod   in number,
                              ln_ittran  in number,
                              ln_itrel   in number,
                              ln_itord   in number,
                              ln_itsbor  in number,
                              ld_FecProc in date);

------------------------------------------------------------                                  
end PQ_CR_RATIO_EVALFLUJO_RTE;
/

create or replace package body PQ_CR_RATIO_EVALFLUJO_RTE is

  --------------------------------------------
  procedure sp_cr_VerfEvalFlujo(ln_Instancia in number,
                                ln_EvalFlujo out varchar2) is
    ln_reg      number := 0;
    ln_regOtorg number := 0;
  begin
  
    begin
      select count(*)
        into ln_regOtorg
        from aqpa410 a
       where a.aqpa410inst = ln_Instancia
         and a.aqpa410esta = 'S';
    exception
      when others then
        ln_regOtorg := 0;
    end;
  
    begin
      select count(*)
        into ln_reg
        from aqpa410a a
       where a.aqpa410ainst = ln_Instancia
         and a.aqpa410aesta = 'S';
    exception
      when others then
        ln_reg := 0;
    end;
  
    if ln_reg > 0 or ln_regOtorg > 0 then
      ln_EvalFlujo := 'S';
    elsif ln_reg <= 0 then
      ln_EvalFlujo := 'N';
    end if;
  
  end sp_cr_VerfEvalFlujo;
  ------------------------------------------------
  procedure sp_cr_InicioRatio(ln_pgcod      in number,
                              ln_itsuc      in number,
                              ln_itmod      in number,
                              ln_ittran     in number,
                              ln_itnrel     in number,
                              ln_itord      in number,
                              ln_itsbor     in number,
                              lc_Usuario    in varchar2,
                              ld_FecProc    in date,
                              ln_capcmac    out number,
                              ln_capifis    out number,
                              ln_capcontgnt out number,
                              ln_capptncl   out number,
                              ln_ResulNeto  out number,
                              ln_Ratio      out number) is
  
    ln_EvalFlujo varchar2(2) := 'N';
    ln_InstLinea number := 0;
    ld_fchEval   date;
    ln_InstEval  number := 0;
    ln_pgcod116  number := 0;
    ln_mod116    number := 0;
    ln_tope116   number := 0;
    ln_suc116    number := 0;
    ln_mda116    number := 0;
    ln_pap116    number := 0;
    ln_cta116    number := 0;
    ln_oper116   number := 0;
    ln_sbop116   number := 0;
    ln_pgcod117  number := 0;
    ln_mod117    number := 0;
    ln_suc117    number := 0;
    ln_mda117    number := 0;
    ln_pap117    number := 0;
    ln_cta117    number := 0;
    ln_oper117   number := 0;
    ln_sbop117   number := 0;
    ln_tope117   number := 0;
    ln_cont      number := 0;
    lc_Excluir   varchar2(2) := 'N';
    lc_SacasInfo varchar2(2) := 'O';
  
  begin
  
    begin
      select f.pgcod,
             f.modulo,
             f.ittope,
             f.itsucd,
             f.moneda,
             f.papel,
             f.ctnro,
             f.itoper,
             f.itsubo
        into ln_pgcod116,
             ln_mod116,
             ln_tope116,
             ln_suc116,
             ln_mda116,
             ln_pap116,
             ln_cta116,
             ln_oper116,
             ln_sbop116
        from fsd016 f
       where f.pgcod = ln_pgcod
         and f.itsuc = ln_itsuc
         and f.itmod = ln_itmod
         and f.ittran = ln_ittran
         and f.itnrel = ln_itnrel
         and f.itord = ln_itord
         and f.itsbor = ln_itsbor;
    exception
      when others then
        ln_pgcod116 := 0;
        ln_mod116   := 0;
        ln_tope116  := 0;
        ln_suc116   := 0;
        ln_mda116   := 0;
        ln_pap116   := 0;
        ln_cta116   := 0;
        ln_oper116  := 0;
        ln_sbop116  := 0;
    end;
  
    begin
      select r2cod,
             r2mod,
             r2suc,
             r2mda,
             r2pap,
             r2cta,
             r2oper,
             r2sbop,
             r2tope
        into ln_pgcod117,
             ln_mod117,
             ln_suc117,
             ln_mda117,
             ln_pap117,
             ln_cta117,
             ln_oper117,
             ln_sbop117,
             ln_tope117
        from fsr011 f
       where f.r1cod = ln_pgcod116
         and f.r1mod = ln_mod116
         and f.r1suc = ln_suc116
         and f.r1cta = ln_cta116
         and f.r1oper = ln_oper116
         and f.r1sbop = ln_sbop116
         and f.r1mda = ln_mda116
         and f.r1pap = ln_pap116
         and f.r1tope = ln_tope116
         and f.relcod = 46;
    exception
      when others then
        ln_pgcod117 := 0;
        ln_mod117   := 0;
        ln_suc117   := 0;
        ln_mda117   := 0;
        ln_pap117   := 0;
        ln_cta117   := 0;
        ln_oper117  := 0;
        ln_sbop117  := 0;
        ln_tope117  := 0;
    end;
  
    begin
      pq_cr_ratio_evalflujo_rte.sp_cr_fchUltEvalII(ln_pgcod         => ln_pgcod,
                                                   ln_itsuc         => ln_itsuc,
                                                   ln_itmod         => ln_itmod,
                                                   ln_ittran        => ln_ittran,
                                                   ln_itnrel        => ln_itnrel,
                                                   ln_itord         => ln_itord,
                                                   ln_itsbor        => ln_itsbor,
                                                   ln_InstLinea     => ln_InstLinea,
                                                   ld_fchevaluacion => ld_fchEval,
                                                   ln_InstEval      => ln_InstEval,
                                                   lc_SacaInfo      => lc_SacasInfo);
    
    end;
  
    ln_InstEval := nvl(ln_InstEval, 0);
  
    begin
      -- Verifica si la instancia esta excluida del calculo del ratio
      select count(*)
        into ln_cont
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 10899
         and f.tp1corr1 = 850
         and f.tp1corr2 = 104
         and f.tp1corr3 > 0
         and f.tp1imp1 = ln_InstLinea;
    exception
      when others then
        ln_cont := 0;
      
    end;
  
    if ln_cont > 0 then
      lc_Excluir := 'S';
    else
      lc_Excluir := 'N';
    end if;
  
    if lc_Excluir = 'N' then
    
      if ln_InstEval > 0 then
      
        begin
          PQ_CR_RATIO_EVALFLUJO_RTE.sp_cr_VerfEvalFlujo(ln_InstEval,
                                                        ln_EvalFlujo);
        end;
      
        if ln_EvalFlujo = 'S' then
        
          --Elimina los registros de la transaccion
          begin
            delete from AQPA357 j
             where j.AQPA357instl = ln_InstLinea
               and j.aqpa357pgcod = ln_pgcod
               and j.aqpa357itsuc = ln_itsuc
               and j.aqpa357itmod = ln_itmod
               and j.aqpa357ittran = ln_ittran
               and j.aqpa357itnrel = ln_itnrel
               and j.aqpa357itord = ln_itord
               and j.aqpa357itsbor = ln_itsbor
               and j.aqpa357fec = ld_FecProc;
            commit;
          end;
        
          begin
            delete from AQPA358 j
             where j.AQPA358instl = ln_InstLinea
               and j.aqpa358pgcod = ln_pgcod
               and j.aqpa358itsuc = ln_itsuc
               and j.aqpa358itmod = ln_itmod
               and j.aqpa358ittran = ln_ittran
               and j.aqpa358itnrel = ln_itnrel
               and j.aqpa358itord = ln_itord
               and j.aqpa358itsbor = ln_itsbor
               and j.aqpa358fec = ld_FecProc;
            commit;
          end;
        
          begin
            delete from AQPA359 j
             where j.AQPA359instl = ln_InstLinea
               and j.aqpa359pgcod = ln_pgcod
               and j.aqpa359itsuc = ln_itsuc
               and j.aqpa359itmod = ln_itmod
               and j.aqpa359ittran = ln_ittran
               and j.aqpa359itnrel = ln_itnrel
               and j.aqpa359itord = ln_itord
               and j.aqpa359itsbor = ln_itsbor
               and j.aqpa359fec = ld_FecProc;
            commit;
          end;
        
          begin
            delete from AQPA360 j
             where j.AQPA360instl = ln_InstLinea
               and j.AQPA360pgcod = ln_pgcod
               and j.AQPA360itsuc = ln_itsuc
               and j.AQPA360itmod = ln_itmod
               and j.AQPA360ittran = ln_ittran
               and j.AQPA360itnrel = ln_itnrel
               and j.AQPA360itord = ln_itord
               and j.AQPA360itsbor = ln_itsbor
               and j.AQPA360fec = ld_FecProc;
            commit;
          end;
        
          ------  
        
          PQ_CR_RATIO_EVALFLUJO_RTE.sp_cr_CalcCuentasII(ln_instl      => ln_InstLinea,
                                                        ld_fchEval    => ld_fchEval,
                                                        ln_inste      => ln_InstEval,
                                                        ln_pgcod      => ln_pgcod,
                                                        ln_itsuc      => ln_itsuc,
                                                        ln_itmod      => ln_itmod,
                                                        ln_ittran     => ln_ittran,
                                                        ln_itnrel     => ln_itnrel,
                                                        ln_itord      => ln_itord,
                                                        ln_itsbor     => ln_itsbor,
                                                        ln_pgcod116   => ln_pgcod116,
                                                        ln_mod116     => ln_mod116,
                                                        ln_tope116    => ln_tope116,
                                                        ln_suc116     => ln_suc116,
                                                        ln_mda116     => ln_mda116,
                                                        ln_pap116     => ln_pap116,
                                                        ln_cta116     => ln_cta116,
                                                        ln_oper116    => ln_oper116,
                                                        ln_sbop116    => ln_sbop116,
                                                        ln_pgcod117   => ln_pgcod117,
                                                        ln_mod117     => ln_mod117,
                                                        ln_suc117     => ln_suc117,
                                                        ln_mda117     => ln_mda117,
                                                        ln_pap117     => ln_pap117,
                                                        ln_cta117     => ln_cta117,
                                                        ln_oper117    => ln_oper117,
                                                        ln_sbop117    => ln_sbop117,
                                                        ln_tope117    => ln_tope117,
                                                        lc_Usuario    => lc_Usuario,
                                                        ld_FecProc    => ld_FecProc,
                                                        ln_capcontgnt => ln_capcontgnt);
        
          pq_cr_ratio_evalflujo_rte.sp_cr_DatosPanelEF(ld_FecPro     => ld_FecProc,
                                                       ln_instl      => ln_InstLinea,
                                                       ln_inste      => ln_InstEval,
                                                       ln_pgcod      => ln_pgcod,
                                                       ln_itsuc      => ln_itsuc,
                                                       ln_itmod      => ln_itmod,
                                                       ln_ittran     => ln_ittran,
                                                       ln_itnrel     => ln_itnrel,
                                                       ln_itord      => ln_itord,
                                                       ln_itsbor     => ln_itsbor,
                                                       lc_Usuario    => lc_Usuario,
                                                       ln_capcontgnt => ln_capcontgnt,
                                                       lc_SacasInfo  => lc_SacasInfo);
        
          PQ_CR_RATIO_EVALFLUJO_RTE.sp_cr_CalcRatio(ln_Instancia => ln_InstLinea,
                                                    ln_inste     => ln_InstEval,
                                                    ln_pgcod     => ln_pgcod,
                                                    ln_itsuc     => ln_itsuc,
                                                    ln_itmod     => ln_itmod,
                                                    ln_ittran    => ln_ittran,
                                                    ln_itnrel    => ln_itnrel,
                                                    ln_itord     => ln_itord,
                                                    ln_itsbor    => ln_itsbor,
                                                    ld_FecProc   => ld_FecProc);
        
          PQ_CR_RATIO_EVALFLUJO_RTE.sp_cr_DatosRatio(ln_instancia  => ln_InstLinea,
                                                     ln_InsEval    => ln_InstEval,
                                                     ln_pgcod      => ln_pgcod,
                                                     ln_itsuc      => ln_itsuc,
                                                     ln_itmod      => ln_itmod,
                                                     ln_ittran     => ln_ittran,
                                                     ln_itnrel     => ln_itnrel,
                                                     ln_itord      => ln_itord,
                                                     ln_itsbor     => ln_itsbor,
                                                     ld_FecProc    => ld_FecProc,
                                                     ln_capcaja    => ln_capcmac,
                                                     ln_capifis    => ln_capifis,
                                                     ln_capcontgnt => ln_capcontgnt,
                                                     ln_capptncl   => ln_capptncl,
                                                     ln_ResulNeto  => ln_ResulNeto,
                                                     ln_Ratio      => ln_Ratio);
        end if;
      end if;
    end if;
  
    ln_capcmac    := nvl(ln_capcmac, 0);
    ln_capifis    := nvl(ln_capifis, 0);
    ln_capcontgnt := nvl(ln_capcontgnt, 0);
    ln_capptncl   := nvl(ln_capptncl, 0);
    ln_ResulNeto  := nvl(ln_ResulNeto, 0);
    ln_Ratio      := nvl(ln_Ratio, 0);
  
  end sp_cr_InicioRatio;
  -----------------------------------------------------------------------
  procedure sp_cr_CalcCuentasII(ln_instl      in number,
                                ld_fchEval    in date,
                                ln_inste      in number,
                                ln_pgcod      in number,
                                ln_itsuc      in number,
                                ln_itmod      in number,
                                ln_ittran     in number,
                                ln_itnrel     in number,
                                ln_itord      in number,
                                ln_itsbor     in number,
                                ln_pgcod116   in number,
                                ln_mod116     in number,
                                ln_tope116    in number,
                                ln_suc116     in number,
                                ln_mda116     in number,
                                ln_pap116     in number,
                                ln_cta116     in number,
                                ln_oper116    in number,
                                ln_sbop116    in number,
                                ln_pgcod117   in number,
                                ln_mod117     in number,
                                ln_suc117     in number,
                                ln_mda117     in number,
                                ln_pap117     in number,
                                ln_cta117     in number,
                                ln_oper117    in number,
                                ln_sbop117    in number,
                                ln_tope117    in number,
                                lc_Usuario    in varchar2,
                                ld_FecProc    in date,
                                ln_capcontgnt out number) is
  
    cursor lista_cuentas is
    
      select distinct f.ctnro ln_cuenta
        from fsr008 f
       where (f.pepais, f.petdoc, f.pendoc) in
             (select f.pepais, f.petdoc, f.pendoc
                from sng001 s, fsr008 f
               where s.sng001inst = ln_instl
                 and s.sng001cta = f.ctnro
              union
              select g.rppais, g.rptdoc, g.rpndoc
                from fsr008 h, sng001 s, fsr002 g
               where s.sng001inst = ln_instl
                 and s.sng001cta = h.ctnro
                 and h.pepais = g.pepais
                 and h.petdoc = g.petdoc
                 and h.pendoc = g.pendoc
                 and g.rpccyg = 66
              union
              select g.pepais, g.petdoc, g.pendoc
                from fsr008 h, sng001 s, fsr002 g
               where s.sng001inst = ln_instl
                 and s.sng001cta = h.ctnro
                 and h.pepais = g.rppais
                 and h.petdoc = g.rptdoc
                 and h.pendoc = g.rpndoc
                 and g.rpccyg = 66);
  
    cursor inserta_vencidos(ln_cuenta number) is
    
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
         and d10.Aocta = ln_cuenta
         and (d10.Aomod in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in (select f.tp1nro3
                                       from fst198 f
                                      where f.tp1cod = 1
                                        and f.tp1cod1 = 10899
                                        and f.tp1corr1 = 850
                                        and f.tp1corr2 = 102
                                        and f.tp1corr3 > 0)))
         and d10.Aostat <> 99
         and d10.aofvto < ld_FecProc;
  
    cursor inserta(ln_cuenta number) is
    
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
         and d10.Aocta = ln_cuenta
         and (d10.Aomod in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in (select f.tp1nro3
                                       from fst198 f
                                      where f.tp1cod = 1
                                        and f.tp1cod1 = 10899
                                        and f.tp1corr1 = 850
                                        and f.tp1corr2 = 102
                                        and f.tp1corr3 > 0)) or
             d10.Aomod = 117)
         and d10.Aostat <> 99
         and d10.aofvto >= ld_FecProc;
  
    cursor vuelo(ln_cuenta number) is
    
      select x.xwfempresa   ln_pgcod10,
             x.xwfmodulo    ln_mod10,
             x.xwfsucursal  ln_suc10,
             x.xwfmoneda    ln_mda10,
             x.xwfpapel     ln_pap10,
             x.xwfcuenta    ln_cta10,
             x.xwfoperacion ln_oper10,
             x.xwfsubope    ln_sbop10,
             x.xwftipope    ln_tope10
        from xwf700 x, wfwrkitems wf
       where x.xwfempresa = 1
         and x.xwfcuenta = ln_cuenta
         and (x.xwfmodulo in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in (select f.tp1nro3
                                       from fst198 f
                                      where f.tp1cod = 1
                                        and f.tp1cod1 = 10899
                                        and f.tp1corr1 = 850
                                        and f.tp1corr2 = 102
                                        and f.tp1corr3 > 0)) or
             x.xwfmodulo = 117)
         and wf.wfinsprcid = x.xwfprcins
         and wf.wfitemstsact = 1
         and x.xwfcar3 = '1';
  
    cursor lineas_ven(ln_cuenta number) is
      select d10.pgcod  ln_pgcod10,
             d10.aomod  ln_mod10,
             d10.aosuc  ln_suc10,
             d10.aomda  ln_mda10,
             d10.aopap  ln_pap10,
             d10.aocta  ln_cta10,
             d10.aooper ln_oper10,
             d10.aosbop ln_sbop10,
             d10.aotope ln_tope10
        from fsd010 d10
       where d10.Pgcod = 1
         and d10.Aocta = ln_cuenta
         and d10.Aomod = 117
         and d10.aofvto < ld_FecProc;
  
    lc_FlgLn          varchar2(2);
    lc_fgAdic         varchar2(1);
    lc_fgAmpl         varchar2(1);
    lc_ven            char(1);
    ln_indicador      number(10);
    lc_fgRefLin       varchar2(1);
    lc_IndCred        varchar2(10);
    ln_TipCamb        number;
    ln_MntCuoCntgCF   number := 0;
    ln_MntCuoCntgAval number := 0;
    ln_TieneCalndario number := 0;
    ln_Pepais         number;
    ln_Petdoc         number;
    ln_Pendoc         varchar2(12);
    --ld_fcheval        date;
    ld_MinFchCred  date;
    ln_InstCred    number;
    ln_TipoOri     number;
    ln_NroCuot     number;
    Tiene_Uso      varchar2(5) := 'N';
    ln_pgcod116Uso number := 0;
    ln_mod116Uso   number := 0;
    ln_sucl116Uso  number := 0;
    ln_mda116Uso   number := 0;
    ln_pap116Uso   number := 0;
    ln_cta116Uso   number := 0;
    ln_ope116Uso   number := 0;
    ln_sbop116Uso  number := 0;
    ln_top116Uso   number := 0;
  
  begin
  
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_Pepais, ln_Petdoc, ln_Pendoc
        from sng001 s
       where s.sng001inst = ln_instl;
    exception
      when others then
        null;
      
    end;
  
    begin
      --Tipo de Cambio
      select s. sng120tcbi
        into ln_TipCamb
        from sng120 s
       where s.sng120ins = ln_instl
         and s.sng120tsk = 'EVALUACION';
    exception
      when others then
        ln_TipCamb := 0;
    end;
  
    begin
      ld_MinFchCred := ADD_MONTHS(last_Day(ld_fcheval), -1) + 1;
    end;
  
    for q in lista_cuentas loop
    
      for i in inserta(q.ln_cuenta) loop
      
        lc_fgAdic    := null;
        lc_fgAmpl    := null;
        ln_indicador := 1;
        lc_IndCred   := 'CredVigent';
        lc_FlgLn     := 'N';
      
        begin
          -- Verifico si el credito vigente tiene cuotas a partir de la primera fecha del panel de evaluacion por flujo
          -- del credito en proceso(primer dia el mes de la primera cuota)
          select count(*)
            into ln_TieneCalndario
            from fsd601 f
           where f.pgcod = i.ln_pgcod10
             and f.ppmod = i.ln_mod10
             and f.ppsuc = i.ln_suc10
             and f.ppmda = i.ln_mda10
             and f.pppap = i.ln_pap10
             and f.ppcta = i.ln_cta10
             and f.ppoper = i.ln_oper10
             and f.ppsbop = i.ln_sbop10
             and f.pptope = i.ln_tope10
             and f.d601co = 'S'
             and f.ppfpag >= ld_MinFchCred;
        exception
          when others then
            ln_TieneCalndario := 0;
        end;
      
        if i.ln_mod10 = 117 then
          ln_TieneCalndario := 1;
        end if;
      
        if ln_TieneCalndario > 0 then
        
          PQ_CR_RATIO_EVALFLUJO.sp_refinanLinea(i.ln_pgcod10,
                                                i.ln_mod10,
                                                i.ln_suc10,
                                                i.ln_mda10,
                                                i.ln_pap10,
                                                i.ln_cta10,
                                                i.ln_oper10,
                                                lc_fgRefLin);
        
          PQ_CR_RATIO_EVALFLUJO.Sp_ampliados_CK(i.ln_pgcod10,
                                                i.ln_mod10,
                                                i.ln_suc10,
                                                i.ln_mda10,
                                                i.ln_pap10,
                                                i.ln_cta10,
                                                i.ln_oper10,
                                                i.ln_sbop10,
                                                i.ln_tope10,
                                                lc_fgAmpl);
        
          PQ_CR_RATIO_EVALFLUJO.sp_cr_VerVincLinea(i.ln_mod10,
                                                   i.ln_suc10,
                                                   i.ln_mda10,
                                                   i.ln_pap10,
                                                   i.ln_cta10,
                                                   i.ln_oper10,
                                                   i.ln_sbop10,
                                                   i.ln_tope10,
                                                   lc_FlgLn);
        
          if /*lc_fgAdic <> 'S' and*/
           lc_fgAmpl <> 'S' and lc_fgRefLin <> 'S' and lc_FlgLn <> 'S' then
          
            ln_InstCred := fn_instancia_credito(i.ln_mod10,
                                                i.ln_suc10,
                                                i.ln_mda10,
                                                i.ln_pap10,
                                                i.ln_cta10,
                                                i.ln_oper10,
                                                i.ln_sbop10,
                                                i.ln_tope10);
          
            PQ_CR_RATIO_EVALFLUJO.sp_cr_TipoSolicitud(ln_InstCred,
                                                      ln_TipoOri);
          
            PQ_CR_RATIO_EVALFLUJO.sp_cr_NroCuOPreseteo(i.ln_pgcod10,
                                                       i.ln_mod10,
                                                       i.ln_suc10,
                                                       i.ln_mda10,
                                                       i.ln_pap10,
                                                       i.ln_cta10,
                                                       i.ln_oper10,
                                                       i.ln_sbop10,
                                                       i.ln_tope10,
                                                       ln_NroCuot);
            if i.ln_mod10 = 117 then
            
              PQ_CR_RATIO_EVALFLUJO.sp_cr_VerfUsoLinea(i.ln_pgcod10,
                                                       i.ln_mod10,
                                                       i.ln_suc10,
                                                       i.ln_mda10,
                                                       i.ln_pap10,
                                                       i.ln_cta10,
                                                       i.ln_oper10,
                                                       i.ln_sbop10,
                                                       i.ln_tope10,
                                                       Tiene_Uso,
                                                       ln_pgcod116Uso,
                                                       ln_mod116Uso,
                                                       ln_sucl116Uso,
                                                       ln_mda116Uso,
                                                       ln_pap116Uso,
                                                       ln_cta116Uso,
                                                       ln_ope116Uso,
                                                       ln_sbop116Uso,
                                                       ln_top116Uso);
            
              if Tiene_Uso = 'S' then
                PQ_CR_RATIO_EVALFLUJO.sp_cr_NroCuOPreseteo(ln_pgcod116Uso,
                                                           ln_mod116Uso,
                                                           ln_sucl116Uso,
                                                           ln_mda116Uso,
                                                           ln_pap116Uso,
                                                           ln_cta116Uso,
                                                           ln_ope116Uso,
                                                           ln_sbop116Uso,
                                                           ln_top116Uso,
                                                           ln_NroCuot);
              
                pq_cr_ratio_evalflujo_rte.sp_cr_LogCuentas(ld_fec     => ld_FecProc,
                                                           lc_user    => lc_Usuario,
                                                           ln_pais    => ln_Pepais,
                                                           ln_tdoc    => ln_Petdoc,
                                                           ln_ndoc    => ln_Pendoc,
                                                           ln_tcamb   => ln_TipCamb,
                                                           ln_instl   => ln_instl,
                                                           ln_inste   => ln_inste,
                                                           ln_pgcod   => ln_pgcod,
                                                           ln_itsuc   => ln_itsuc,
                                                           ln_itmod   => ln_itmod,
                                                           ln_ittran  => ln_ittran,
                                                           ln_itnrel  => ln_itnrel,
                                                           ln_itord   => ln_itord,
                                                           ln_itsbor  => ln_itsbor,
                                                           ld_feval   => ld_fchEval,
                                                           ld_fical   => ld_MinFchCred,
                                                           ln_emp     => ln_pgcod116Uso,
                                                           ln_mod     => ln_mod116Uso,
                                                           ln_suc     => ln_sucl116Uso,
                                                           ln_mda     => ln_mda116Uso,
                                                           ln_pap     => ln_pap116Uso,
                                                           ln_cta     => ln_cta116Uso,
                                                           ln_ope     => ln_ope116Uso,
                                                           ln_sbop    => ln_sbop116Uso,
                                                           ln_tope    => ln_top116Uso,
                                                           ln_TipoOri => ln_TipoOri,
                                                           ln_NroCuot => ln_NroCuot,
                                                           lc_IndCred => lc_IndCred,
                                                           ln_SaldCap => 0.00,
                                                           ln_monto   => 0.00);
              else
                if Tiene_Uso = 'N' then
                  -- Tiene_Uso := 'N';
                
                  begin
                    if i.ln_pgcod10 = ln_pgcod117 and
                       i.ln_mod10 = ln_mod117 and i.ln_suc10 = ln_suc117 and
                       i.ln_mda10 = ln_mda117 and i.ln_pap10 = ln_pap117 and
                       i.ln_cta10 = ln_cta117 and i.ln_oper10 = ln_oper117 and
                       i.ln_sbop10 = ln_sbop117 and
                       i.ln_tope10 = ln_tope117 then
                    
                      PQ_CR_RATIO_EVALFLUJO.sp_cr_NroCuOPreseteo(ln_pgcod116,
                                                                 ln_mod116,
                                                                 ln_tope116,
                                                                 ln_suc116,
                                                                 ln_mda116,
                                                                 ln_pap116,
                                                                 ln_cta116,
                                                                 ln_oper116,
                                                                 ln_sbop116,
                                                                 ln_NroCuot);
                    
                      pq_cr_ratio_evalflujo_rte.sp_cr_LogCuentas(ld_fec     => ld_FecProc,
                                                                 lc_user    => lc_Usuario,
                                                                 ln_pais    => ln_Pepais,
                                                                 ln_tdoc    => ln_Petdoc,
                                                                 ln_ndoc    => ln_Pendoc,
                                                                 ln_tcamb   => ln_TipCamb,
                                                                 ln_instl   => ln_instl,
                                                                 ln_inste   => ln_inste,
                                                                 ln_pgcod   => ln_pgcod,
                                                                 ln_itsuc   => ln_itsuc,
                                                                 ln_itmod   => ln_itmod,
                                                                 ln_ittran  => ln_ittran,
                                                                 ln_itnrel  => ln_itnrel,
                                                                 ln_itord   => ln_itord,
                                                                 ln_itsbor  => ln_itsbor,
                                                                 ld_feval   => ld_fchEval,
                                                                 ld_fical   => ld_MinFchCred,
                                                                 ln_emp     => ln_pgcod116,
                                                                 ln_mod     => ln_mod116,
                                                                 ln_suc     => ln_suc116,
                                                                 ln_mda     => ln_mda116,
                                                                 ln_pap     => ln_pap116,
                                                                 ln_cta     => ln_cta116,
                                                                 ln_ope     => ln_oper116,
                                                                 ln_sbop    => ln_sbop116,
                                                                 ln_tope    => ln_tope116,
                                                                 ln_TipoOri => ln_TipoOri,
                                                                 ln_NroCuot => ln_NroCuot,
                                                                 lc_IndCred => 'DispLinea',
                                                                 ln_SaldCap => 0.00,
                                                                 ln_monto   => 0.00);
                    end if;
                  end;
                end if;
              end if;
            else
              pq_cr_ratio_evalflujo_rte.sp_cr_LogCuentas(ld_fec     => ld_FecProc,
                                                         lc_user    => lc_Usuario,
                                                         ln_pais    => ln_Pepais,
                                                         ln_tdoc    => ln_Petdoc,
                                                         ln_ndoc    => ln_Pendoc,
                                                         ln_tcamb   => ln_TipCamb,
                                                         ln_instl   => ln_instl,
                                                         ln_inste   => ln_inste,
                                                         ln_pgcod   => ln_pgcod,
                                                         ln_itsuc   => ln_itsuc,
                                                         ln_itmod   => ln_itmod,
                                                         ln_ittran  => ln_ittran,
                                                         ln_itnrel  => ln_itnrel,
                                                         ln_itord   => ln_itord,
                                                         ln_itsbor  => ln_itsbor,
                                                         ld_feval   => ld_fchEval,
                                                         ld_fical   => ld_MinFchCred,
                                                         ln_emp     => i.ln_pgcod10,
                                                         ln_mod     => i.ln_mod10,
                                                         ln_suc     => i.ln_suc10,
                                                         ln_mda     => i.ln_mda10,
                                                         ln_pap     => i.ln_pap10,
                                                         ln_cta     => i.ln_cta10,
                                                         ln_ope     => i.ln_oper10,
                                                         ln_sbop    => i.ln_sbop10,
                                                         ln_tope    => i.ln_tope10,
                                                         ln_TipoOri => ln_TipoOri,
                                                         ln_NroCuot => ln_NroCuot,
                                                         lc_IndCred => lc_IndCred,
                                                         ln_SaldCap => 0.00,
                                                         ln_monto   => 0.00);
            end if;
          end if;
        end if;
      
      end loop;
    
      for i in inserta_vencidos(q.ln_cuenta) loop
      
        lc_fgAdic    := null;
        lc_fgAmpl    := null;
        ln_indicador := 1;
        lc_IndCred   := 'CredVencid';
      
        begin
          -- Verifico si el credito vigente tiene cuotas a partir de la primera fecha de pago
          -- del credito
          select count(*)
            into ln_TieneCalndario
            from fsd601 f
           where f.pgcod = i.ln_pgcod10
             and f.ppmod = i.ln_mod10
             and f.ppsuc = i.ln_suc10
             and f.ppmda = i.ln_mda10
             and f.pppap = i.ln_pap10
             and f.ppcta = i.ln_cta10
             and f.ppoper = i.ln_oper10
             and f.ppsbop = i.ln_sbop10
             and f.pptope = i.ln_tope10
             and f.d601co = 'S'
             and f.ppfpag >= ld_MinFchCred;
        exception
          when others then
            ln_TieneCalndario := 0;
        end;
      
        if ln_TieneCalndario > 0 then
        
          PQ_CR_RATIO_EVALFLUJO.sp_refinanLinea(i.ln_pgcod10,
                                                i.ln_mod10,
                                                i.ln_suc10,
                                                i.ln_mda10,
                                                i.ln_pap10,
                                                i.ln_cta10,
                                                i.ln_oper10,
                                                lc_fgRefLin);
        
          PQ_CR_RATIO_EVALFLUJO.Sp_ampliados_CK(i.ln_pgcod10,
                                                i.ln_mod10,
                                                i.ln_suc10,
                                                i.ln_mda10,
                                                i.ln_pap10,
                                                i.ln_cta10,
                                                i.ln_oper10,
                                                i.ln_sbop10,
                                                i.ln_tope10,
                                                lc_fgAmpl);
          PQ_CR_RATIO_EVALFLUJO.sp_cr_VerVincLinea(i.ln_mod10,
                                                   i.ln_suc10,
                                                   i.ln_mda10,
                                                   i.ln_pap10,
                                                   i.ln_cta10,
                                                   i.ln_oper10,
                                                   i.ln_sbop10,
                                                   i.ln_tope10,
                                                   lc_FlgLn);
        
          if /*lc_fgAdic <> 'S' and*/
           lc_fgAmpl <> 'S' and lc_fgRefLin <> 'S' and lc_FlgLn <> 'S' then
            ln_InstCred := fn_instancia_credito(i.ln_mod10,
                                                i.ln_suc10,
                                                i.ln_mda10,
                                                i.ln_pap10,
                                                i.ln_cta10,
                                                i.ln_oper10,
                                                i.ln_sbop10,
                                                i.ln_tope10);
          
            PQ_CR_RATIO_EVALFLUJO.sp_cr_TipoSolicitud(ln_InstCred,
                                                      ln_TipoOri);
          
            PQ_CR_RATIO_EVALFLUJO.sp_cr_NroCuOPreseteo(i.ln_pgcod10,
                                                       i.ln_mod10,
                                                       i.ln_suc10,
                                                       i.ln_mda10,
                                                       i.ln_pap10,
                                                       i.ln_cta10,
                                                       i.ln_oper10,
                                                       i.ln_sbop10,
                                                       i.ln_tope10,
                                                       ln_NroCuot);
          
            pq_cr_ratio_evalflujo_rte.sp_cr_LogCuentas(ld_fec     => ld_FecProc,
                                                       lc_user    => lc_Usuario,
                                                       ln_pais    => ln_Pepais,
                                                       ln_tdoc    => ln_Petdoc,
                                                       ln_ndoc    => ln_Pendoc,
                                                       ln_tcamb   => ln_TipCamb,
                                                       ln_instl   => ln_instl,
                                                       ln_inste   => ln_inste,
                                                       ln_pgcod   => ln_pgcod,
                                                       ln_itsuc   => ln_itsuc,
                                                       ln_itmod   => ln_itmod,
                                                       ln_ittran  => ln_ittran,
                                                       ln_itnrel  => ln_itnrel,
                                                       ln_itord   => ln_itord,
                                                       ln_itsbor  => ln_itsbor,
                                                       ld_feval   => ld_fchEval,
                                                       ld_fical   => ld_MinFchCred,
                                                       ln_emp     => i.ln_pgcod10,
                                                       ln_mod     => i.ln_mod10,
                                                       ln_suc     => i.ln_suc10,
                                                       ln_mda     => i.ln_mda10,
                                                       ln_pap     => i.ln_pap10,
                                                       ln_cta     => i.ln_cta10,
                                                       ln_ope     => i.ln_oper10,
                                                       ln_sbop    => i.ln_sbop10,
                                                       ln_tope    => i.ln_tope10,
                                                       ln_TipoOri => ln_TipoOri,
                                                       ln_NroCuot => ln_NroCuot,
                                                       lc_IndCred => lc_IndCred,
                                                       ln_SaldCap => 0.00,
                                                       ln_monto   => 0.00);
          
          end if;
        end if;
      end loop;
    
      for c in vuelo(q.ln_cuenta) loop
        ln_indicador := 2;
        lc_IndCred   := 'CredVuelo';
      
        begin
          -- Verifico si el credito vigente tiene cuotas a partir de la primera fecha de pago
          -- del credito 
          select count(*)
            into ln_TieneCalndario
            from fsd601 f
           where f.pgcod = c.ln_pgcod10
             and f.ppmod = c.ln_mod10
             and f.ppsuc = c.ln_suc10
             and f.ppmda = c.ln_mda10
             and f.pppap = c.ln_pap10
             and f.ppcta = c.ln_cta10
             and f.ppoper = c.ln_oper10
             and f.ppsbop = c.ln_sbop10
             and f.pptope = c.ln_tope10
             and f.d601co = 'X'
             and f.ppfpag >= ld_MinFchCred;
        exception
          when others then
            ln_TieneCalndario := 0;
        end;
      
        if ln_TieneCalndario > 0 then
        
          ln_InstCred := fn_instancia_credito(c.ln_mod10,
                                              c.ln_suc10,
                                              c.ln_mda10,
                                              c.ln_pap10,
                                              c.ln_cta10,
                                              c.ln_oper10,
                                              c.ln_sbop10,
                                              c.ln_tope10);
        
          PQ_CR_RATIO_EVALFLUJO.sp_cr_TipoSolicitud(ln_InstCred,
                                                    ln_TipoOri);
        
          PQ_CR_RATIO_EVALFLUJO.sp_cr_NroCuOPreseteo(c.ln_pgcod10,
                                                     c.ln_mod10,
                                                     c.ln_suc10,
                                                     c.ln_mda10,
                                                     c.ln_pap10,
                                                     c.ln_cta10,
                                                     c.ln_oper10,
                                                     c.ln_sbop10,
                                                     c.ln_tope10,
                                                     ln_NroCuot);
        
          pq_cr_ratio_evalflujo_rte.sp_cr_LogCuentas(ld_fec     => ld_FecProc,
                                                     lc_user    => lc_Usuario,
                                                     ln_pais    => ln_Pepais,
                                                     ln_tdoc    => ln_Petdoc,
                                                     ln_ndoc    => ln_Pendoc,
                                                     ln_tcamb   => ln_TipCamb,
                                                     ln_instl   => ln_instl,
                                                     ln_inste   => ln_inste,
                                                     ln_pgcod   => ln_pgcod,
                                                     ln_itsuc   => ln_itsuc,
                                                     ln_itmod   => ln_itmod,
                                                     ln_ittran  => ln_ittran,
                                                     ln_itnrel  => ln_itnrel,
                                                     ln_itord   => ln_itord,
                                                     ln_itsbor  => ln_itsbor,
                                                     ld_feval   => ld_fchEval,
                                                     ld_fical   => ld_MinFchCred,
                                                     ln_emp     => c.ln_pgcod10,
                                                     ln_mod     => c.ln_mod10,
                                                     ln_suc     => c.ln_suc10,
                                                     ln_mda     => c.ln_mda10,
                                                     ln_pap     => c.ln_pap10,
                                                     ln_cta     => c.ln_cta10,
                                                     ln_ope     => c.ln_oper10,
                                                     ln_sbop    => c.ln_sbop10,
                                                     ln_tope    => c.ln_tope10,
                                                     ln_TipoOri => ln_TipoOri,
                                                     ln_NroCuot => ln_NroCuot,
                                                     lc_IndCred => lc_IndCred,
                                                     ln_SaldCap => 0.00,
                                                     ln_monto   => 0.00);
        
        end if;
      
      end loop;
    
      for j in lineas_ven(q.ln_cuenta) loop
      
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
      
        PQ_CR_RATIO_EVALFLUJO.sp_refinanLinea(J.ln_pgcod10,
                                              J.ln_mod10,
                                              J.ln_suc10,
                                              J.ln_mda10,
                                              J.ln_pap10,
                                              J.ln_cta10,
                                              J.ln_oper10,
                                              lc_fgRefLin);
      
        PQ_CR_RATIO_EVALFLUJO.sp_cr_VerVincLinea(j.ln_mod10,
                                                 j.ln_suc10,
                                                 j.ln_mda10,
                                                 j.ln_pap10,
                                                 j.ln_cta10,
                                                 j.ln_oper10,
                                                 j.ln_sbop10,
                                                 j.ln_tope10,
                                                 lc_FlgLn);
      
        if lc_ven = 'S' and /*lc_fgAdic <> 'S' and */
           lc_fgRefLin <> 'S' and lc_FlgLn <> 'S' then
        
          ln_InstCred := fn_instancia_credito(j.ln_mod10,
                                              j.ln_suc10,
                                              j.ln_mda10,
                                              j.ln_pap10,
                                              j.ln_cta10,
                                              j.ln_oper10,
                                              j.ln_sbop10,
                                              j.ln_tope10);
        
          PQ_CR_RATIO_EVALFLUJO.sp_cr_TipoSolicitud(ln_InstCred,
                                                    ln_TipoOri);
        
          PQ_CR_RATIO_EVALFLUJO.sp_cr_NroCuOPreseteo(j.ln_pgcod10,
                                                     j.ln_mod10,
                                                     j.ln_suc10,
                                                     j.ln_mda10,
                                                     j.ln_pap10,
                                                     j.ln_cta10,
                                                     j.ln_oper10,
                                                     j.ln_sbop10,
                                                     j.ln_tope10,
                                                     ln_NroCuot);
        
          pq_cr_ratio_evalflujo_rte.sp_cr_LogCuentas(ld_fec     => ld_FecProc,
                                                     lc_user    => lc_Usuario,
                                                     ln_pais    => ln_Pepais,
                                                     ln_tdoc    => ln_Petdoc,
                                                     ln_ndoc    => ln_Pendoc,
                                                     ln_tcamb   => ln_TipCamb,
                                                     ln_instl   => ln_instl,
                                                     ln_inste   => ln_inste,
                                                     ln_pgcod   => ln_pgcod,
                                                     ln_itsuc   => ln_itsuc,
                                                     ln_itmod   => ln_itmod,
                                                     ln_ittran  => ln_ittran,
                                                     ln_itnrel  => ln_itnrel,
                                                     ln_itord   => ln_itord,
                                                     ln_itsbor  => ln_itsbor,
                                                     ld_feval   => ld_fchEval,
                                                     ld_fical   => ld_MinFchCred,
                                                     ln_emp     => j.ln_pgcod10,
                                                     ln_mod     => j.ln_mod10,
                                                     ln_suc     => j.ln_suc10,
                                                     ln_mda     => j.ln_mda10,
                                                     ln_pap     => j.ln_pap10,
                                                     ln_cta     => j.ln_cta10,
                                                     ln_ope     => j.ln_oper10,
                                                     ln_sbop    => j.ln_sbop10,
                                                     ln_tope    => j.ln_tope10,
                                                     ln_TipoOri => ln_TipoOri,
                                                     ln_NroCuot => ln_NroCuot,
                                                     lc_IndCred => lc_IndCred,
                                                     ln_SaldCap => 0.00,
                                                     ln_monto   => 0.00);
        
        end if;
      end loop;
    end loop;
  
    begin
      -- Cuota Contingente  
      PQ_CR_RATIO_EVALFLUJO_RTE.sp_cr_CuotaContinCF(ln_Instancia    => ln_instl,
                                                    ln_InstEval     => ln_inste,
                                                    ld_fchEval      => ld_fchEval,
                                                    ln_pgcod        => ln_pgcod,
                                                    ln_itsuc        => ln_itsuc,
                                                    ln_itmod        => ln_itmod,
                                                    ln_ittran       => ln_ittran,
                                                    ln_itnrel       => ln_itnrel,
                                                    ln_itord        => ln_itord,
                                                    ln_itsbor       => ln_itsbor,
                                                    pd_fecpro       => ld_FecProc,
                                                    lc_Usuario      => lc_Usuario,
                                                    ln_MntCuoCntgCF => ln_MntCuoCntgCF);
    
      PQ_CR_RATIO_EVALFLUJO_RTE.sp_cr_CuotaContinAval(ln_Instancia      => ln_instl,
                                                      ln_InstEval       => ln_inste,
                                                      ld_fchEval        => ld_fchEval,
                                                      ln_pgcod          => ln_pgcod,
                                                      ln_itsuc          => ln_itsuc,
                                                      ln_itmod          => ln_itmod,
                                                      ln_ittran         => ln_ittran,
                                                      ln_itnrel         => ln_itnrel,
                                                      ln_itord          => ln_itord,
                                                      ln_itsbor         => ln_itsbor,
                                                      pd_fecpro         => ld_FecProc,
                                                      lc_Usuario        => lc_Usuario,
                                                      ln_MntCuoCntgAval => ln_MntCuoCntgAval);
    
      ln_capcontgnt := ln_MntCuoCntgCF + ln_MntCuoCntgAval;
    end;
  
  end sp_cr_CalcCuentasII;

  ------------------------------------------------------------------------
  procedure sp_cr_CalcRatio(ln_Instancia in number,
                            ln_inste     in number,
                            ln_pgcod     in number,
                            ln_itsuc     in number,
                            ln_itmod     in number,
                            ln_ittran    in number,
                            ln_itnrel    in number,
                            ln_itord     in number,
                            ln_itsbor    in number,
                            ld_FecProc   in date) is
  
    cursor Lista_OtrosCred(lc_estado varchar2) is
    -- Cursor Creditos que no son Linea (Solo Linea Utilizada) ni Desembolso Parcial
      select a.AQPA357pgcod   ln_pgcod,
             a.AQPA357mod     ln_mod,
             a.AQPA357suc     ln_suc,
             a.AQPA357mda     ln_mda,
             a.AQPA357pap     ln_pap,
             a.AQPA357cta     ln_cta,
             a.AQPA357ope     ln_ope,
             a.AQPA357sbop    ln_sbop,
             a.AQPA357tope    ln_tope,
             a.AQPA357indcred lc_IndCred
        from AQPA357 a
       where a.AQPA357instl = ln_Instancia
         and a.aqpa357pgcod = ln_pgcod
         and a.aqpa357itsuc = ln_itsuc
         and a.aqpa357itmod = ln_itmod
         and a.aqpa357ittran = ln_ittran
         and a.aqpa357itnrel = ln_itnrel
         and a.aqpa357itord = ln_itord
         and a.aqpa357itsbor = ln_itsbor
         and a.aqpa357fec = ld_FecProc
         and a.AQPA357est = lc_estado
         and a.AQPA357mod <> 117 --Excluye Lineas
         and a.AQPA357ori <> 7 --Excluye desembolsos parciales
         and a.AQPA357indcred in ('CredVigent', 'CredVencid', 'CredVuelo');
  
    cursor linea_vuelo(lc_estado varchar2) is
      select a.AQPA357pgcod   ln_pgcod,
             a.AQPA357mod     ln_mod,
             a.AQPA357suc     ln_suc,
             a.AQPA357mda     ln_mda,
             a.AQPA357pap     ln_pap,
             a.AQPA357cta     ln_cta,
             a.AQPA357ope     ln_ope,
             a.AQPA357sbop    ln_sbop,
             a.AQPA357tope    ln_tope,
             a.AQPA357indcred lc_IndCred
        from AQPA357 a
       where a.AQPA357instl = ln_Instancia
         and a.aqpa357pgcod = ln_pgcod
         and a.aqpa357itsuc = ln_itsuc
         and a.aqpa357itmod = ln_itmod
         and a.aqpa357ittran = ln_ittran
         and a.aqpa357itnrel = ln_itnrel
         and a.aqpa357itord = ln_itord
         and a.aqpa357itsbor = ln_itsbor
         and a.aqpa357fec = ld_FecProc
         and a.AQPA357est = lc_estado
         and a.AQPA357indcred = 'CredVuelo'
         and a.AQPA357mod = 117;
  
    cursor linea_vigente(lc_estado varchar2) is
    -- Linea Vigente sin uso
      select a.AQPA357pgcod   ln_pgcod,
             a.AQPA357mod     ln_mod,
             a.AQPA357suc     ln_suc,
             a.AQPA357mda     ln_mda,
             a.AQPA357pap     ln_pap,
             a.AQPA357cta     ln_cta,
             a.AQPA357ope     ln_ope,
             a.AQPA357sbop    ln_sbop,
             a.AQPA357tope    ln_tope,
             a.AQPA357indcred lc_IndCred
        from AQPA357 a
       where a.AQPA357instl = ln_Instancia
         and a.aqpa357pgcod = ln_pgcod
         and a.aqpa357itsuc = ln_itsuc
         and a.aqpa357itmod = ln_itmod
         and a.aqpa357ittran = ln_ittran
         and a.aqpa357itnrel = ln_itnrel
         and a.aqpa357itord = ln_itord
         and a.aqpa357itsbor = ln_itsbor
         and a.aqpa357fec = ld_FecProc
         and a.AQPA357est = lc_estado
         and a.AQPA357indcred = 'CredVigent'
         and a.AQPA357mod = 117;
  
    cursor linea_vencida(lc_estado varchar2) is
      select a.AQPA357pgcod   ln_pgcod,
             a.AQPA357mod     ln_mod,
             a.AQPA357suc     ln_suc,
             a.AQPA357mda     ln_mda,
             a.AQPA357pap     ln_pap,
             a.AQPA357cta     ln_cta,
             a.AQPA357ope     ln_ope,
             a.AQPA357sbop    ln_sbop,
             a.AQPA357tope    ln_tope,
             a.AQPA357indcred lc_IndCred
        from AQPA357 a
       where a.AQPA357instl = ln_Instancia
         and a.aqpa357pgcod = ln_pgcod
         and a.aqpa357itsuc = ln_itsuc
         and a.aqpa357itmod = ln_itmod
         and a.aqpa357ittran = ln_ittran
         and a.aqpa357itnrel = ln_itnrel
         and a.aqpa357itord = ln_itord
         and a.aqpa357itsbor = ln_itsbor
         and a.aqpa357fec = ld_FecProc
         and a.AQPA357est = lc_estado
         and a.AQPA357indcred = 'LineaVencd';
  
    cursor credito_parcial(lc_estado varchar2) is
      select a.AQPA357pgcod   ln_pgcod,
             a.AQPA357mod     ln_mod,
             a.AQPA357suc     ln_suc,
             a.AQPA357mda     ln_mda,
             a.AQPA357pap     ln_pap,
             a.AQPA357cta     ln_cta,
             a.AQPA357ope     ln_ope,
             a.AQPA357sbop    ln_sbop,
             a.AQPA357tope    ln_tope,
             a.AQPA357indcred lc_IndCred
        from AQPA357 a
       where a.AQPA357instl = ln_Instancia
         and a.aqpa357pgcod = ln_pgcod
         and a.aqpa357itsuc = ln_itsuc
         and a.aqpa357itmod = ln_itmod
         and a.aqpa357ittran = ln_ittran
         and a.aqpa357itnrel = ln_itnrel
         and a.aqpa357itord = ln_itord
         and a.aqpa357itsbor = ln_itsbor
         and a.aqpa357fec = ld_FecProc
         and a.AQPA357est = lc_estado
         and a.AQPA357ori = 7
         and a.AQPA357indcred in ('CredVigent', 'CredVencid');
  
    cursor Lista_ParcVuelo(lc_estado varchar2) is
      select a.AQPA357pgcod   ln_pgcod,
             a.AQPA357mod     ln_mod,
             a.AQPA357suc     ln_suc,
             a.AQPA357mda     ln_mda,
             a.AQPA357pap     ln_pap,
             a.AQPA357cta     ln_cta,
             a.AQPA357ope     ln_ope,
             a.AQPA357sbop    ln_sbop,
             a.AQPA357tope    ln_tope,
             a.AQPA357indcred lc_IndCred
        from AQPA357 a
       where a.AQPA357instl = ln_Instancia
         and a.aqpa357pgcod = ln_pgcod
         and a.aqpa357itsuc = ln_itsuc
         and a.aqpa357itmod = ln_itmod
         and a.aqpa357ittran = ln_ittran
         and a.aqpa357itnrel = ln_itnrel
         and a.aqpa357itord = ln_itord
         and a.aqpa357itsbor = ln_itsbor
         and a.aqpa357fec = ld_FecProc
         and a.AQPA357est = lc_estado
         and a.AQPA357ori = 7 -- Desembolsos parciales
         and a.AQPA357indcred = 'CredVuelo';
  
    cursor Linea_Disponer(lc_estado varchar2) is
      select a.AQPA357pgcod   ln_pgcod,
             a.AQPA357mod     ln_mod,
             a.AQPA357suc     ln_suc,
             a.AQPA357mda     ln_mda,
             a.AQPA357pap     ln_pap,
             a.AQPA357cta     ln_cta,
             a.AQPA357ope     ln_ope,
             a.AQPA357sbop    ln_sbop,
             a.AQPA357tope    ln_tope,
             a.AQPA357indcred lc_IndCred
        from AQPA357 a
       where a.AQPA357instl = ln_Instancia
         and a.aqpa357pgcod = ln_pgcod
         and a.aqpa357itsuc = ln_itsuc
         and a.aqpa357itmod = ln_itmod
         and a.aqpa357ittran = ln_ittran
         and a.aqpa357itnrel = ln_itnrel
         and a.aqpa357itord = ln_itord
         and a.aqpa357itsbor = ln_itsbor
         and a.aqpa357fec = ld_FecProc
         and a.AQPA357est = lc_estado
         and a.AQPA357indcred = 'DispLinea';
  
    ld_MaxFchCalnd     date;
    ln_MntCuoMesAux    number(17, 2) := 0;
    ln_MntCuoMes       number(17, 2) := 0;
    ld_fini            date;
    ld_ffin            date;
    ln_TipCamb         number;
    ln_ratiomens       number(10, 6) := 0;
    lc_estado          varchar2(2) := 'I';
    ln_MntCuota        number := 0.00;
    ln_emp             number;
    ln_sucur           number;
    ln_mod             number;
    ln_mda             number;
    ln_pap             number;
    ln_cta             number;
    ln_oper            number;
    ln_sbop            number;
    ln_tipoper         number;
    NroCreOtorg        number;
    ln_NroCuot         number;
    ln_MntDispnb       number(17, 2) := 0.00;
    ln_CuoDisp         number(17, 2) := 0.00;
    ln_mntacumld       number(17, 2) := 0.00;
    ln_newmnt          number(17, 2) := 0.00;
    lc_VerfDesembPendt varchar2(5) := 'T';
    ln_NroDesemblsPact number := 0;
    ln_DesembHechos    number := 0;
    ln_CuotPendt       number(17, 2) := 0.00;
    ld_MaxFechCalnd    date;
    ld_UltDia          date;
    lc_fgAdic          varchar2(2) := 'N';
    ln_MaxPlazAdi      number := 0;
    ln_CuoCapAdi       number(17, 2) := 0.00;
    LC_VerfAdi         varchar2(2) := 'N';
    ln_TieneCalndario  number := 0;
    ln_CapIntMnsl      number(17, 2) := 0.00;
    ln_IntMnsl         number(17, 2) := 0.00;
    ln_pgcod116        number := 0;
    ln_mod116          number := 0;
    ln_tope116         number := 0;
    ln_suc116          number := 0;
    ln_mda116          number := 0;
    ln_pap116          number := 0;
    ln_cta116          number := 0;
    ln_oper116         number := 0;
    ln_sbop116         number := 0;
    ln_cuenta          number := 0;
  
  begin
  
    lc_estado := 'I';
  
    begin
      --Tipo de Cambio
      select s. sng120tcbi
        into ln_TipCamb
        from sng120 s
       where s.sng120ins = ln_Instancia
         and s.sng120tsk = 'EVALUACION';
    exception
      when others then
        ln_TipCamb := 0;
    end;
  
    begin
      begin
        select x.xwfempresa,
               x.xwfsucursal,
               x.xwfmodulo,
               x.xwfmoneda,
               x.xwfpapel,
               x.xwfcuenta,
               x.xwfoperacion,
               x.xwfsubope,
               x.xwftipope
          into ln_emp,
               ln_sucur,
               ln_mod,
               ln_mda,
               ln_pap,
               ln_cta,
               ln_oper,
               ln_sbop,
               ln_tipoper
          from xwf700 x
         where x.xwfprcins = ln_Instancia
           and x.xwfcar3 = '1';
      end;
    
      begin
        if ln_mod <> 117 then
        
          begin
            select months_between(max(f.ppfvto), min(f.ppfval))
              into NroCreOtorg
              from fsd601 f
             where f.pgcod = ln_emp
               and f.ppmod = ln_mod
               and f.ppsuc = ln_sucur
               and f.ppmda = ln_mda
               and f.pppap = ln_pap
               and f.ppcta = ln_cta
               and f.ppoper = ln_oper
               and f.ppsbop = ln_sbop
               and f.pptope = ln_tipoper;
          exception
            when others then
              NroCreOtorg := 0;
          end;
        
        else
          if ln_mod = 117 then
            PQ_CR_RATIO_EVALFLUJO.sp_cr_NroCuOPreseteo(ln_pgcod        => ln_emp,
                                                       ln_modulo       => ln_mod,
                                                       ln_sucursal     => ln_sucur,
                                                       ln_moneda       => ln_mda,
                                                       ln_papel        => ln_pap,
                                                       ln_cuenta       => ln_cta,
                                                       ln_operacion    => ln_oper,
                                                       ln_suboperacion => ln_sbop,
                                                       ln_tipoperacion => ln_tipoper,
                                                       ln_NroCuot      => NroCreOtorg);
          end if;
        end if;
      end;
    
    end;
  
    begin
      select f.pgcod,
             f.modulo,
             f.ittope,
             f.itsucd,
             f.moneda,
             f.papel,
             f.ctnro,
             f.itoper,
             f.itsubo
        into ln_pgcod116,
             ln_mod116,
             ln_tope116,
             ln_suc116,
             ln_mda116,
             ln_pap116,
             ln_cta116,
             ln_oper116,
             ln_sbop116
        from fsd016 f
       where f.pgcod = ln_pgcod
         and f.itsuc = ln_itsuc
         and f.itmod = ln_itmod
         and f.ittran = ln_ittran
         and f.itnrel = ln_itnrel
         and f.itord = ln_itord
         and f.itsbor = ln_itsbor;
    exception
      when others then
        ln_pgcod116 := 0;
        ln_mod116   := 0;
        ln_tope116  := 0;
        ln_suc116   := 0;
        ln_mda116   := 0;
        ln_pap116   := 0;
        ln_cta116   := 0;
        ln_oper116  := 0;
        ln_sbop116  := 0;
    end;
  
    for oc in Lista_OtrosCred(lc_estado) loop
    
      begin
        select min(a.aqpa358fecal)
          into ld_ffin
          from aqpa358 a
         where a.aqpa358instl = ln_Instancia
           and a.aqpa358pgcod = ln_pgcod
           and a.aqpa358itsuc = ln_itsuc
           and a.aqpa358itmod = ln_itmod
           and a.aqpa358ittran = ln_ittran
           and a.aqpa358itnrel = ln_itnrel
           and a.aqpa358itord = ln_itord
           and a.aqpa358itsbor = ln_itsbor
           and a.aqpa358fec = ld_FecProc;
      end;
    
      begin
        select max(a.aqpa358fecal)
          into ld_MaxFchCalnd
          from aqpa358 a
         where a.aqpa358instl = ln_Instancia
           and a.aqpa358pgcod = ln_pgcod
           and a.aqpa358itsuc = ln_itsuc
           and a.aqpa358itmod = ln_itmod
           and a.aqpa358ittran = ln_ittran
           and a.aqpa358itnrel = ln_itnrel
           and a.aqpa358itord = ln_itord
           and a.aqpa358itsbor = ln_itsbor
           and a.aqpa358fec = ld_FecProc;
      end;
    
      begin
        ld_fini := ADD_MONTHS(last_Day(ld_ffin), -1) + 1;
      end;
    
      while ld_ffin <= ld_MaxFchCalnd loop
      
        ln_MntCuoMesAux := 0;
        ln_MntCuoMes    := 0;
        ln_ratiomens    := 0;
      
        if oc.ln_pgcod = ln_pgcod116 and oc.ln_mod = ln_mod116 and
           oc.ln_suc = ln_suc116 and oc.ln_mda = ln_mda116 and
           oc.ln_pap = ln_pap116 and oc.ln_cta = ln_cta116 and
           oc.ln_ope = ln_oper116 and oc.ln_sbop = ln_sbop116 and
           oc.ln_tope = ln_tope116 then
        
          ln_cuenta := 999999999;
        
          PQ_CR_RATIO_EVALFLUJO.sp_cr_CalCuota(oc.ln_pgcod,
                                               oc.ln_mod,
                                               oc.ln_suc,
                                               oc.ln_mda,
                                               oc.ln_pap,
                                               ln_cuenta,
                                               oc.ln_ope,
                                               oc.ln_sbop,
                                               oc.ln_tope,
                                               ld_fini,
                                               ld_ffin,
                                               ln_TipCamb,
                                               ln_NroCuot,
                                               ln_MntCuota);
        
        else
        
          PQ_CR_RATIO_EVALFLUJO.sp_cr_CalCuota(oc.ln_pgcod,
                                               oc.ln_mod,
                                               oc.ln_suc,
                                               oc.ln_mda,
                                               oc.ln_pap,
                                               oc.ln_cta,
                                               oc.ln_ope,
                                               oc.ln_sbop,
                                               oc.ln_tope,
                                               ld_fini,
                                               ld_ffin,
                                               ln_TipCamb,
                                               ln_NroCuot,
                                               ln_MntCuota);
        end if;
      
        begin
          PQ_CR_RATIO_EVALFLUJO_RTE.sp_cr_LogDetMensualII(ln_Instancia   => ln_Instancia,
                                                          ln_pgcod       => ln_pgcod,
                                                          ln_itsuc       => ln_itsuc,
                                                          ln_itmod       => ln_itmod,
                                                          ln_ittran      => ln_ittran,
                                                          ln_itnrel      => ln_itnrel,
                                                          ln_itord       => ln_itord,
                                                          ln_itsbor      => ln_itsbor,
                                                          ld_FecProc     => ld_FecProc,
                                                          ln_modulo      => oc.LN_MOD,
                                                          ln_mntcuota    => ln_MntCuota,
                                                          ld_fchPanel    => ld_ffin,
                                                          ln_NroCuOtorg  => NroCreOtorg,
                                                          ln_NroCuotCred => ln_NroCuot,
                                                          lc_Indicador   => oc.lc_indcred);
        
          Pq_Cr_Ratio_Evalflujo_Rte.sp_cr_LogDetMensPanel(ln_Instancia   => ln_Instancia,
                                                          ln_pgcod       => ln_pgcod,
                                                          ln_itsuc       => ln_itsuc,
                                                          ln_itmod       => ln_itmod,
                                                          ln_ittran      => ln_ittran,
                                                          ln_itnrel      => ln_itnrel,
                                                          ln_itord       => ln_itord,
                                                          ln_itsbor      => ln_itsbor,
                                                          ld_FecProc     => ld_FecProc,
                                                          ln_modulo      => oc.LN_MOD,
                                                          ln_mntcuota    => ln_MntCuota,
                                                          ld_fchPanel    => ld_ffin,
                                                          ln_NroCuOtorg  => NroCreOtorg,
                                                          ln_NroCuotCred => ln_NroCuot,
                                                          lc_Indicador   => oc.lc_indcred);
        end;
      
        ld_fini := add_months(ld_fini, +1);
        ld_ffin := add_months(ld_ffin, +1);
      
      end loop;
    
      if oc.ln_mod = 116 then
      
        if oc.ln_pgcod <> ln_pgcod116 and oc.ln_mod <> ln_mod116 and
           oc.ln_suc <> ln_suc116 and oc.ln_mda <> ln_mda116 and
           oc.ln_pap <> ln_pap116 and oc.ln_cta <> ln_cta116 and
           oc.ln_ope <> ln_oper116 and oc.ln_sbop <> ln_sbop116 and
           oc.ln_tope <> ln_tope116 then
        
          PQ_CR_RATIO_EVALFLUJO.Sp_Adicional_CK(oc.ln_mod,
                                                oc.ln_tope,
                                                lc_fgAdic);
        
          if lc_fgAdic = 'N' then
          
            /* PQ_CR_RATIO_EVALFLUJO.sp_cr_CalcDisponible(oc.ln_pgcod,
                                                       oc.ln_mod,
                                                       oc.ln_suc,
                                                       oc.ln_mda,
                                                       oc.ln_pap,
                                                       oc.ln_cta,
                                                       oc.ln_ope,
                                                       oc.ln_sbop,
                                                       oc.ln_tope,
                                                       ln_MntDispnb);
            
            PQ_CR_RATIO_EVALFLUJO.sp_cr_CalCuotaDispnbl(ln_pgcod        => oc.ln_pgcod,
                                                        ln_suc          => oc.ln_suc,
                                                        ln_mod          => oc.ln_mod,
                                                        ln_mda          => oc.ln_mda,
                                                        ln_pap          => oc.ln_pap,
                                                        ln_cta          => oc.ln_cta,
                                                        ln_oper         => oc.ln_ope,
                                                        ln_sbop         => oc.ln_sbop,
                                                        ln_tope         => oc.ln_tope,
                                                        ln_MntDispnbl   => ln_MntDispnb,
                                                        tipocambio      => ln_TipCamb,
                                                        ln_CuotaDispnbl => ln_CuoDisp);*/
          
            ln_CuoDisp := nvl(ln_CuoDisp, 0);
            ln_CuoDisp := ln_CuoDisp * NroCreOtorg;
          
            if ln_mod = 117 then
            
              begin
                -- Para calculo de ratio           
                begin
                  select a.AQPA358capcaja
                    into ln_mntacumld
                    from AQPA358 a
                   where a.AQPA358instl = ln_Instancia
                     and a.aqpa358pgcod = ln_pgcod
                     and a.aqpa358itsuc = ln_itsuc
                     and a.aqpa358itmod = ln_itmod
                     and a.aqpa358ittran = ln_ittran
                     and a.aqpa358itnrel = ln_itnrel
                     and a.aqpa358itord = ln_itord
                     and a.aqpa358itsbor = ln_itsbor
                     and a.aqpa358fec = ld_FecProc
                     and a.AQPA358corr = NroCreOtorg
                     and a.AQPA358est = lc_estado;
                exception
                  when others then
                    ln_mntacumld := 0.00;
                end;
              
                ln_mntacumld := nvl(ln_mntacumld, 0);
                begin
                  ln_newmnt := ln_mntacumld + ln_CuoDisp;
                  ln_newmnt := nvl(ln_newmnt, 0);
                end;
              
                begin
                  update AQPA358 a
                     set a.AQPA358capcaja = ln_newmnt
                   where a.AQPA358instl = ln_Instancia
                     and a.aqpa358pgcod = ln_pgcod
                     and a.aqpa358itsuc = ln_itsuc
                     and a.aqpa358itmod = ln_itmod
                     and a.aqpa358ittran = ln_ittran
                     and a.aqpa358itnrel = ln_itnrel
                     and a.aqpa358itord = ln_itord
                     and a.aqpa358itsbor = ln_itsbor
                     and a.aqpa358fec = ld_FecProc
                     and a.AQPA358est = lc_estado
                     AND a.AQPA358corr = NroCreOtorg;
                end;
              
              end;
            
              begin
                -- Para actualizar valor caja en nuevo log AE 
                ln_newmnt    := 0.00;
                ln_mntacumld := 0.00;
                begin
                  select a.aqpa360cuoc
                    into ln_mntacumld
                    from AQPA360 a
                   where a.AQPA360instl = ln_Instancia
                     and a.AQPA360pgcod = ln_pgcod
                     and a.AQPA360itsuc = ln_itsuc
                     and a.AQPA360itmod = ln_itmod
                     and a.AQPA360ittran = ln_ittran
                     and a.AQPA360itnrel = ln_itnrel
                     and a.AQPA360itord = ln_itord
                     and a.AQPA360itsbor = ln_itsbor
                     and a.AQPA360fec = ld_FecProc
                     and a.AQPA360corr = NroCreOtorg
                     and a.AQPA360estatr = lc_estado;
                exception
                  when others then
                    ln_mntacumld := 0.00;
                end;
              
                ln_mntacumld := nvl(ln_mntacumld, 0);
                begin
                  ln_newmnt := ln_mntacumld + ln_CuoDisp;
                  ln_newmnt := nvl(ln_newmnt, 0);
                end;
              
                begin
                  update AQPA360 a
                     set a.aqpa360cuoc = ln_newmnt
                   where a.AQPA360instl = ln_Instancia
                     and a.AQPA360pgcod = ln_pgcod
                     and a.AQPA360itsuc = ln_itsuc
                     and a.AQPA360itmod = ln_itmod
                     and a.AQPA360ittran = ln_ittran
                     and a.AQPA360itnrel = ln_itnrel
                     and a.AQPA360itord = ln_itord
                     and a.AQPA360itsbor = ln_itsbor
                     and a.AQPA360fec = ld_FecProc
                     and a.AQPA360estatr = lc_estado
                     AND a.AQPA360corr = NroCreOtorg;
                end;
              
              end;
            
            else
              if ln_mod <> 117 then
              
                begin
                  select max(f.ppfpag)
                    into ld_MaxFechCalnd
                    from fsd601 f
                   where f.pgcod = ln_emp
                     and f.ppmod = ln_mod
                     and f.ppsuc = ln_sucur
                     and f.ppmda = ln_mda
                     and f.pppap = ln_pap
                     and f.ppcta = ln_cta
                     and f.ppoper = ln_oper
                     and f.ppsbop = ln_sbop
                     and f.pptope = ln_tipoper
                     and f.d601co = 'X';
                exception
                  when others then
                    null;
                end;
              
                begin
                  begin
                    ld_UltDia := last_Day(ld_MaxFechCalnd);
                  end;
                end;
              
                begin
                  -- Para Calculo de Ratio
                  begin
                    select a.AQPA358capcaja
                      into ln_mntacumld
                      from AQPA358 a
                     where a.AQPA358instl = ln_Instancia
                       and a.aqpa358pgcod = ln_pgcod
                       and a.aqpa358itsuc = ln_itsuc
                       and a.aqpa358itmod = ln_itmod
                       and a.aqpa358ittran = ln_ittran
                       and a.aqpa358itnrel = ln_itnrel
                       and a.aqpa358itord = ln_itord
                       and a.aqpa358itsbor = ln_itsbor
                       and a.aqpa358fec = ld_FecProc
                       and a.AQPA358fecal = ld_UltDia
                       and a.AQPA358est = lc_estado;
                  exception
                    when others then
                      ln_mntacumld := 0.00;
                  end;
                
                  ln_mntacumld := nvl(ln_mntacumld, 0);
                  begin
                    ln_newmnt := ln_mntacumld + ln_CuoDisp;
                    ln_newmnt := nvl(ln_newmnt, 0);
                  end;
                
                  begin
                    update AQPA358 a
                       set a.AQPA358capcaja = ln_newmnt
                     where a.AQPA358instl = ln_Instancia
                       and a.aqpa358pgcod = ln_pgcod
                       and a.aqpa358itsuc = ln_itsuc
                       and a.aqpa358itmod = ln_itmod
                       and a.aqpa358ittran = ln_ittran
                       and a.aqpa358itnrel = ln_itnrel
                       and a.aqpa358itord = ln_itord
                       and a.aqpa358itsbor = ln_itsbor
                       and a.aqpa358fec = ld_FecProc
                       and a.AQPA358est = lc_estado
                       and a.AQPA358fecal = ld_UltDia;
                  end;
                end;
              
                begin
                  -- Para actualizar valor caja en nuevo log AE 
                  ln_newmnt    := 0.00;
                  ln_mntacumld := 0.00;
                
                  begin
                    select a.aqpa360cuoc
                      into ln_mntacumld
                      from AQPA360 a
                     where a.AQPA360instl = ln_Instancia
                       and a.AQPA360pgcod = ln_pgcod
                       and a.AQPA360itsuc = ln_itsuc
                       and a.AQPA360itmod = ln_itmod
                       and a.AQPA360ittran = ln_ittran
                       and a.AQPA360itnrel = ln_itnrel
                       and a.AQPA360itord = ln_itord
                       and a.AQPA360itsbor = ln_itsbor
                       and a.AQPA360fec = ld_FecProc
                       and a.aqpa360fcon = ld_UltDia
                       and a.AQPA360estatr = lc_estado;
                  exception
                    when others then
                      ln_mntacumld := 0.00;
                  end;
                
                  ln_mntacumld := nvl(ln_mntacumld, 0);
                  begin
                    ln_newmnt := ln_mntacumld + ln_CuoDisp;
                    ln_newmnt := nvl(ln_newmnt, 0);
                  end;
                
                  begin
                    update AQPA360 a
                       set a.aqpa360cuoc = ln_newmnt
                     where a.AQPA360instl = ln_Instancia
                       and a.AQPA360pgcod = ln_pgcod
                       and a.AQPA360itsuc = ln_itsuc
                       and a.AQPA360itmod = ln_itmod
                       and a.AQPA360ittran = ln_ittran
                       and a.AQPA360itnrel = ln_itnrel
                       and a.AQPA360itord = ln_itord
                       and a.AQPA360itsbor = ln_itsbor
                       and a.AQPA360fec = ld_FecProc
                       and a.AQPA360estatr = lc_estado
                       and a.aqpa360fcon = ld_UltDia;
                  end;
                end;
              
              end if;
            end if;
          
          else
            if lc_fgAdic = 'S' then
              ln_newmnt := 0;
            
              PQ_CR_RATIO_EVALFLUJO.sp_CapLineaAdicional(ln_mod10        => oc.ln_mod,
                                                         ln_suc10        => oc.ln_suc,
                                                         ln_mda10        => oc.ln_mda,
                                                         ln_pap10        => oc.ln_pap,
                                                         ln_cta10        => oc.ln_cta,
                                                         ln_oper10       => oc.ln_ope,
                                                         ln_sbop10       => oc.ln_sbop,
                                                         ln_tope10       => oc.ln_tope,
                                                         tipocambio      => ln_TipCamb,
                                                         ln_plazo        => ln_MaxPlazAdi,
                                                         ln_CapAdicional => ln_CuoCapAdi);
            
              ln_MaxPlazAdi := ln_MaxPlazAdi + 1;
            
              begin
                -- Cuotas Caja en Ratio
                begin
                  select a.AQPA358capcaja
                    into ln_mntacumld
                    from AQPA358 a
                   where a.AQPA358instl = ln_Instancia
                     and a.aqpa358pgcod = ln_pgcod
                     and a.aqpa358itsuc = ln_itsuc
                     and a.aqpa358itmod = ln_itmod
                     and a.aqpa358ittran = ln_ittran
                     and a.aqpa358itnrel = ln_itnrel
                     and a.aqpa358itord = ln_itord
                     and a.aqpa358itsbor = ln_itsbor
                     and a.aqpa358fec = ld_FecProc
                     and a.AQPA358corr = ln_MaxPlazAdi
                     and a.AQPA358est = lc_estado;
                exception
                  when others then
                    ln_mntacumld := 0.00;
                end;
              
                ln_mntacumld := nvl(ln_mntacumld, 0);
              
                begin
                  ln_newmnt := ln_mntacumld + ln_CuoCapAdi;
                  ln_newmnt := nvl(ln_newmnt, 0);
                end;
              
                begin
                  update AQPA358 a
                     set a.AQPA358capcaja = ln_newmnt
                   where a.AQPA358instl = ln_Instancia
                     and a.aqpa358pgcod = ln_pgcod
                     and a.aqpa358itsuc = ln_itsuc
                     and a.aqpa358itmod = ln_itmod
                     and a.aqpa358ittran = ln_ittran
                     and a.aqpa358itnrel = ln_itnrel
                     and a.aqpa358itord = ln_itord
                     and a.aqpa358itsbor = ln_itsbor
                     and a.aqpa358fec = ld_FecProc
                     and a.AQPA358est = lc_estado
                     AND a.AQPA358corr = ln_MaxPlazAdi;
                end;
              end;
            
              begin
                -- Cuotas Caja en AE
                ln_mntacumld := 0.00;
                ln_newmnt    := 0.00;
              
                begin
                  select a.aqpa360cuoc
                    into ln_mntacumld
                    from AQPA360 a
                   where a.AQPA360instl = ln_Instancia
                     and a.AQPA360pgcod = ln_pgcod
                     and a.AQPA360itsuc = ln_itsuc
                     and a.AQPA360itmod = ln_itmod
                     and a.AQPA360ittran = ln_ittran
                     and a.AQPA360itnrel = ln_itnrel
                     and a.AQPA360itord = ln_itord
                     and a.AQPA360itsbor = ln_itsbor
                     and a.AQPA360fec = ld_FecProc
                     and a.AQPA360corr = ln_MaxPlazAdi
                     and a.AQPA360estatr = lc_estado;
                exception
                  when others then
                    ln_mntacumld := 0.00;
                end;
              
                ln_mntacumld := nvl(ln_mntacumld, 0);
              
                begin
                  ln_newmnt := ln_mntacumld + ln_CuoCapAdi;
                  ln_newmnt := nvl(ln_newmnt, 0);
                end;
              
                begin
                  update AQPA360 a
                     set a.aqpa360cuoc = ln_newmnt
                   where a.AQPA360instl = ln_Instancia
                     and a.AQPA360pgcod = ln_pgcod
                     and a.AQPA360itsuc = ln_itsuc
                     and a.AQPA360itmod = ln_itmod
                     and a.AQPA360ittran = ln_ittran
                     and a.AQPA360itnrel = ln_itnrel
                     and a.AQPA360itord = ln_itord
                     and a.AQPA360itsbor = ln_itsbor
                     and a.AQPA360fec = ld_FecProc
                     and a.AQPA360estatr = lc_estado
                     AND a.AQPA360corr = ln_MaxPlazAdi;
                end;
              end;
            
            end if;
          end if;
        end if;
      
      end if;
    
    end loop;
  
    for lv in linea_vuelo(lc_estado) loop
    
      PQ_CR_RATIO_EVALFLUJO.sp_cr_CalCuota(lv.ln_pgcod,
                                           lv.ln_mod,
                                           lv.ln_suc,
                                           lv.ln_mda,
                                           lv.ln_pap,
                                           lv.ln_cta,
                                           lv.ln_ope,
                                           lv.ln_sbop,
                                           lv.ln_tope,
                                           ld_fini,
                                           ld_ffin,
                                           ln_TipCamb,
                                           ln_NroCuot,
                                           ln_MntCuota);
    
      begin
        PQ_CR_RATIO_EVALFLUJO_RTE.sp_cr_LogDetMensualII(ln_Instancia   => ln_Instancia,
                                                        ln_pgcod       => ln_pgcod,
                                                        ln_itsuc       => ln_itsuc,
                                                        ln_itmod       => ln_itmod,
                                                        ln_ittran      => ln_ittran,
                                                        ln_itnrel      => ln_itnrel,
                                                        ln_itord       => ln_itord,
                                                        ln_itsbor      => ln_itsbor,
                                                        ld_FecProc     => ld_FecProc,
                                                        ln_modulo      => Lv.LN_MOD,
                                                        ln_mntcuota    => ln_MntCuota,
                                                        ld_fchPanel    => ld_ffin,
                                                        ln_NroCuOtorg  => NroCreOtorg,
                                                        ln_NroCuotCred => ln_NroCuot,
                                                        lc_Indicador   => lv.lc_indcred);
      
        Pq_Cr_Ratio_Evalflujo_Rte.sp_cr_LogDetMensPanel(ln_Instancia   => ln_Instancia,
                                                        ln_pgcod       => ln_pgcod,
                                                        ln_itsuc       => ln_itsuc,
                                                        ln_itmod       => ln_itmod,
                                                        ln_ittran      => ln_ittran,
                                                        ln_itnrel      => ln_itnrel,
                                                        ln_itord       => ln_itord,
                                                        ln_itsbor      => ln_itsbor,
                                                        ld_FecProc     => ld_FecProc,
                                                        ln_modulo      => Lv.LN_MOD,
                                                        ln_mntcuota    => ln_MntCuota,
                                                        ld_fchPanel    => ld_ffin,
                                                        ln_NroCuOtorg  => NroCreOtorg,
                                                        ln_NroCuotCred => ln_NroCuot,
                                                        lc_Indicador   => Lv.lc_indcred);
      
      end;
    
      PQ_CR_RATIO_EVALFLUJO.sp_CapLineaAdiVuel(ln_mod10        => lv.ln_mod,
                                               ln_suc10        => lv.ln_suc,
                                               ln_mda10        => lv.ln_mda,
                                               ln_pap10        => lv.ln_pap,
                                               ln_cta10        => lv.ln_cta,
                                               ln_oper10       => lv.ln_ope,
                                               ln_sbop10       => lv.ln_sbop,
                                               ln_tope10       => lv.ln_tope,
                                               tipocambio      => ln_TipCamb,
                                               ln_plazo        => ln_MaxPlazAdi,
                                               ln_CapAdicional => ln_CuoCapAdi);
    
      ln_MaxPlazAdi := ln_MaxPlazAdi + 1;
    
      if ln_CuoCapAdi > 0 then
      
        begin
          -- Cuota Caja en Ratio
          begin
            select a.AQPA358capcaja
              into ln_mntacumld
              from AQPA358 a
             where a.AQPA358instl = ln_Instancia
               and a.aqpa358pgcod = ln_pgcod
               and a.aqpa358itsuc = ln_itsuc
               and a.aqpa358itmod = ln_itmod
               and a.aqpa358ittran = ln_ittran
               and a.aqpa358itnrel = ln_itnrel
               and a.aqpa358itord = ln_itord
               and a.aqpa358itsbor = ln_itsbor
               and a.aqpa358fec = ld_FecProc
               and a.AQPA358corr = ln_MaxPlazAdi
               and a.AQPA358est = lc_estado;
          exception
            when others then
              ln_mntacumld := 0.00;
          end;
        
          ln_mntacumld := nvl(ln_mntacumld, 0);
        
          begin
            ln_newmnt := ln_mntacumld + ln_CuoCapAdi;
            ln_newmnt := nvl(ln_newmnt, 0);
          end;
        
          begin
            update AQPA358 a
               set a.AQPA358capcaja = ln_newmnt
             where a.AQPA358instl = ln_Instancia
               and a.aqpa358pgcod = ln_pgcod
               and a.aqpa358itsuc = ln_itsuc
               and a.aqpa358itmod = ln_itmod
               and a.aqpa358ittran = ln_ittran
               and a.aqpa358itnrel = ln_itnrel
               and a.aqpa358itord = ln_itord
               and a.aqpa358itsbor = ln_itsbor
               and a.aqpa358fec = ld_FecProc
               and a.AQPA358est = lc_estado
               AND a.AQPA358corr = ln_MaxPlazAdi;
          end;
        end;
      
        begin
          -- Cuota Caja en AE
          ln_mntacumld := 0.00;
          ln_newmnt    := 0.00;
          begin
            select a.aqpa360cuoc
              into ln_mntacumld
              from AQPA360 a
             where a.AQPA360instl = ln_Instancia
               and a.AQPA360pgcod = ln_pgcod
               and a.AQPA360itsuc = ln_itsuc
               and a.AQPA360itmod = ln_itmod
               and a.AQPA360ittran = ln_ittran
               and a.AQPA360itnrel = ln_itnrel
               and a.AQPA360itord = ln_itord
               and a.AQPA360itsbor = ln_itsbor
               and a.AQPA360fec = ld_FecProc
               and a.AQPA360corr = ln_MaxPlazAdi
               and a.AQPA360estatr = lc_estado;
          exception
            when others then
              ln_mntacumld := 0.00;
          end;
        
          ln_mntacumld := nvl(ln_mntacumld, 0);
        
          begin
            ln_newmnt := ln_mntacumld + ln_CuoCapAdi;
            ln_newmnt := nvl(ln_newmnt, 0);
          end;
        
          begin
            update AQPA360 a
               set a.aqpa360cuoc = ln_newmnt
             where a.AQPA360instl = ln_Instancia
               and a.AQPA360pgcod = ln_pgcod
               and a.AQPA360itsuc = ln_itsuc
               and a.AQPA360itmod = ln_itmod
               and a.AQPA360ittran = ln_ittran
               and a.AQPA360itnrel = ln_itnrel
               and a.AQPA360itord = ln_itord
               and a.AQPA360itsbor = ln_itsbor
               and a.AQPA360fec = ld_FecProc
               and a.AQPA360estatr = lc_estado
               AND a.AQPA360corr = ln_MaxPlazAdi;
          end;
        end;
      
      end if;
    
    end loop;
  
    for lg in linea_vigente(lc_estado) loop
    
      PQ_CR_RATIO_EVALFLUJO.Sp_Adicional_CK(pn_mod  => LG.LN_MOD,
                                            pn_top  => LG.LN_TOPE,
                                            Pc_flag => LC_VerfAdi);
    
      if LC_VerfAdi = 'N' then
      
        begin
          pq_cr_resolutor_cappago.sp_capacidadlinea(lg.ln_mod,
                                                    lg.ln_suc,
                                                    lg.ln_mda,
                                                    lg.ln_pap,
                                                    lg.ln_cta,
                                                    lg.ln_ope,
                                                    lg.ln_sbop,
                                                    lg.ln_tope,
                                                    ln_TipCamb,
                                                    ln_MntCuoMesAux);
        
          ln_MntCuota := ln_MntCuoMesAux * NroCreOtorg;
          ln_MntCuota := nvl(ln_MntCuota, 0);
        
        end;
      
        begin
          PQ_CR_RATIO_EVALFLUJO_RTE.sp_cr_LogDetMensualII(ln_Instancia   => ln_Instancia,
                                                          ln_pgcod       => ln_pgcod,
                                                          ln_itsuc       => ln_itsuc,
                                                          ln_itmod       => ln_itmod,
                                                          ln_ittran      => ln_ittran,
                                                          ln_itnrel      => ln_itnrel,
                                                          ln_itord       => ln_itord,
                                                          ln_itsbor      => ln_itsbor,
                                                          ld_FecProc     => ld_FecProc,
                                                          ln_modulo      => Lg.LN_MOD,
                                                          ln_mntcuota    => ln_MntCuota,
                                                          ld_fchPanel    => ld_ffin,
                                                          ln_NroCuOtorg  => NroCreOtorg,
                                                          ln_NroCuotCred => ln_NroCuot,
                                                          lc_Indicador   => lg.lc_indcred);
        
          Pq_Cr_Ratio_Evalflujo_Rte.sp_cr_LogDetMensPanel(ln_Instancia   => ln_Instancia,
                                                          ln_pgcod       => ln_pgcod,
                                                          ln_itsuc       => ln_itsuc,
                                                          ln_itmod       => ln_itmod,
                                                          ln_ittran      => ln_ittran,
                                                          ln_itnrel      => ln_itnrel,
                                                          ln_itord       => ln_itord,
                                                          ln_itsbor      => ln_itsbor,
                                                          ld_FecProc     => ld_FecProc,
                                                          ln_modulo      => lg.LN_MOD,
                                                          ln_mntcuota    => ln_MntCuota,
                                                          ld_fchPanel    => ld_ffin,
                                                          ln_NroCuOtorg  => NroCreOtorg,
                                                          ln_NroCuotCred => ln_NroCuot,
                                                          lc_Indicador   => lg.lc_indcred);
        end;
      
      else
        if LC_VerfAdi = 'S' then
        
          PQ_CR_RATIO_EVALFLUJO.sp_CapLineaAdicional(ln_mod10        => Lg.ln_mod,
                                                     ln_suc10        => Lg.ln_suc,
                                                     ln_mda10        => Lg.ln_mda,
                                                     ln_pap10        => Lg.ln_pap,
                                                     ln_cta10        => Lg.ln_cta,
                                                     ln_oper10       => Lg.ln_ope,
                                                     ln_sbop10       => Lg.ln_sbop,
                                                     ln_tope10       => Lg.ln_tope,
                                                     tipocambio      => ln_TipCamb,
                                                     ln_plazo        => ln_MaxPlazAdi,
                                                     ln_CapAdicional => ln_CuoCapAdi);
        
          ln_MaxPlazAdi := ln_MaxPlazAdi + 1;
        
          if ln_CuoCapAdi > 0 then
          
            begin
              -- Cuota Caja Ratio
              begin
                select a.AQPA358capcaja
                  into ln_mntacumld
                  from AQPA358 a
                 where a.AQPA358instl = ln_Instancia
                   and a.aqpa358pgcod = ln_pgcod
                   and a.aqpa358itsuc = ln_itsuc
                   and a.aqpa358itmod = ln_itmod
                   and a.aqpa358ittran = ln_ittran
                   and a.aqpa358itnrel = ln_itnrel
                   and a.aqpa358itord = ln_itord
                   and a.aqpa358itsbor = ln_itsbor
                   and a.aqpa358fec = ld_FecProc
                   and a.AQPA358corr = ln_MaxPlazAdi
                   and a.AQPA358est = lc_estado;
              exception
                when others then
                  ln_mntacumld := 0.00;
              end;
            
              ln_mntacumld := nvl(ln_mntacumld, 0);
            
              begin
                ln_newmnt := ln_mntacumld + ln_CuoCapAdi;
                ln_newmnt := nvl(ln_newmnt, 0);
              end;
            
              begin
                update AQPA358 a
                   set a.AQPA358capcaja = ln_newmnt
                 where a.AQPA358instl = ln_Instancia
                   and a.aqpa358pgcod = ln_pgcod
                   and a.aqpa358itsuc = ln_itsuc
                   and a.aqpa358itmod = ln_itmod
                   and a.aqpa358ittran = ln_ittran
                   and a.aqpa358itnrel = ln_itnrel
                   and a.aqpa358itord = ln_itord
                   and a.aqpa358itsbor = ln_itsbor
                   and a.aqpa358fec = ld_FecProc
                   and a.AQPA358est = lc_estado
                   AND a.AQPA358corr = ln_MaxPlazAdi;
              end;
            end;
          
            begin
              -- Cuota Caja AE
              ln_mntacumld := 0.00;
              ln_newmnt    := 0.00;
            
              begin
                select a.aqpa360cuoc
                  into ln_mntacumld
                  from AQPA360 a
                 where a.AQPA360instl = ln_Instancia
                   and a.AQPA360pgcod = ln_pgcod
                   and a.AQPA360itsuc = ln_itsuc
                   and a.AQPA360itmod = ln_itmod
                   and a.AQPA360ittran = ln_ittran
                   and a.AQPA360itnrel = ln_itnrel
                   and a.AQPA360itord = ln_itord
                   and a.AQPA360itsbor = ln_itsbor
                   and a.AQPA360fec = ld_FecProc
                   and a.AQPA360corr = ln_MaxPlazAdi
                   and a.AQPA360estatr = lc_estado;
              exception
                when others then
                  ln_mntacumld := 0.00;
              end;
            
              ln_mntacumld := nvl(ln_mntacumld, 0);
            
              begin
                ln_newmnt := ln_mntacumld + ln_CuoCapAdi;
                ln_newmnt := nvl(ln_newmnt, 0);
              end;
            
              begin
                update AQPA360 a
                   set a.aqpa360cuoc = ln_newmnt
                 where a.AQPA360instl = ln_Instancia
                   and a.AQPA360pgcod = ln_pgcod
                   and a.AQPA360itsuc = ln_itsuc
                   and a.AQPA360itmod = ln_itmod
                   and a.AQPA360ittran = ln_ittran
                   and a.AQPA360itnrel = ln_itnrel
                   and a.AQPA360itord = ln_itord
                   and a.AQPA360itsbor = ln_itsbor
                   and a.AQPA360fec = ld_FecProc
                   and a.AQPA360estatr = lc_estado
                   AND a.AQPA360corr = ln_MaxPlazAdi;
              end;
            end;
          
          end if;
        end if;
      end if;
    
    end loop;
  
    for lc in linea_vencida(lc_estado) loop
    
      begin
        select min(a.aqpa358fecal)
          into ld_ffin
          from aqpa358 a
         where a.aqpa358instl = ln_Instancia
           and a.aqpa358pgcod = ln_pgcod
           and a.aqpa358itsuc = ln_itsuc
           and a.aqpa358itmod = ln_itmod
           and a.aqpa358ittran = ln_ittran
           and a.aqpa358itnrel = ln_itnrel
           and a.aqpa358itord = ln_itord
           and a.aqpa358itsbor = ln_itsbor
           and a.aqpa358fec = ld_FecProc;
      end;
    
      begin
        select max(a.aqpa358fecal)
          into ld_MaxFchCalnd
          from aqpa358 a
         where a.aqpa358instl = ln_Instancia
           and a.aqpa358pgcod = ln_pgcod
           and a.aqpa358itsuc = ln_itsuc
           and a.aqpa358itmod = ln_itmod
           and a.aqpa358ittran = ln_ittran
           and a.aqpa358itnrel = ln_itnrel
           and a.aqpa358itord = ln_itord
           and a.aqpa358itsbor = ln_itsbor
           and a.aqpa358fec = ld_FecProc;
      end;
    
      begin
        ld_fini := ADD_MONTHS(last_Day(ld_ffin), -1) + 1;
      end;
    
      while ld_ffin <= ld_MaxFchCalnd loop
      
        ln_MntCuoMesAux := 0;
        ln_MntCuoMes    := 0;
        ln_ratiomens    := 0;
      
        PQ_CR_RATIO_EVALFLUJO.sp_cr_CalCuota(lc.ln_pgcod,
                                             lc.ln_mod,
                                             lc.ln_suc,
                                             lc.ln_mda,
                                             lc.ln_pap,
                                             lc.ln_cta,
                                             lc.ln_ope,
                                             lc.ln_sbop,
                                             lc.ln_tope,
                                             ld_fini,
                                             ld_ffin,
                                             ln_TipCamb,
                                             ln_NroCuot,
                                             ln_MntCuota);
      
        begin
          PQ_CR_RATIO_EVALFLUJO_RTE.sp_cr_LogDetMensualII(ln_Instancia   => ln_Instancia,
                                                          ln_pgcod       => ln_pgcod,
                                                          ln_itsuc       => ln_itsuc,
                                                          ln_itmod       => ln_itmod,
                                                          ln_ittran      => ln_ittran,
                                                          ln_itnrel      => ln_itnrel,
                                                          ln_itord       => ln_itord,
                                                          ln_itsbor      => ln_itsbor,
                                                          ld_FecProc     => ld_FecProc,
                                                          ln_modulo      => Lc.LN_MOD,
                                                          ln_mntcuota    => ln_MntCuota,
                                                          ld_fchPanel    => ld_ffin,
                                                          ln_NroCuOtorg  => NroCreOtorg,
                                                          ln_NroCuotCred => ln_NroCuot,
                                                          lc_Indicador   => Lc.lc_indcred);
        
          PQ_CR_RATIO_EVALFLUJO_RTE.sp_cr_LogDetMensPanel(ln_Instancia   => ln_Instancia,
                                                          ln_pgcod       => ln_pgcod,
                                                          ln_itsuc       => ln_itsuc,
                                                          ln_itmod       => ln_itmod,
                                                          ln_ittran      => ln_ittran,
                                                          ln_itnrel      => ln_itnrel,
                                                          ln_itord       => ln_itord,
                                                          ln_itsbor      => ln_itsbor,
                                                          ld_FecProc     => ld_FecProc,
                                                          ln_modulo      => Lc.LN_MOD,
                                                          ln_mntcuota    => ln_MntCuota,
                                                          ld_fchPanel    => ld_ffin,
                                                          ln_NroCuOtorg  => NroCreOtorg,
                                                          ln_NroCuotCred => ln_NroCuot,
                                                          lc_Indicador   => Lc.lc_indcred);
        
        end;
      
        ld_fini := add_months(ld_fini, +1);
        ld_ffin := add_months(ld_ffin, +1);
      end loop;
    end loop;
  
    for cp in credito_parcial(lc_estado) loop
      PQ_CR_RATIO_EVALFLUJO.sp_cr_VerfDesmbPendiente(cp.ln_pgcod,
                                                     cp.ln_mod,
                                                     cp.ln_suc,
                                                     cp.ln_mda,
                                                     cp.ln_pap,
                                                     cp.ln_cta,
                                                     cp.ln_ope,
                                                     cp.ln_sbop,
                                                     cp.ln_tope,
                                                     lc_VerfDesembPendt,
                                                     ln_NroDesemblsPact,
                                                     ln_DesembHechos);
      if lc_VerfDesembPendt = 'P' then
        -- Con Desembolso Pendiente    
      
        PQ_CR_RATIO_EVALFLUJO.sp_Cr_CalcParcialPend(cp.ln_pgcod,
                                                    cp.ln_mod,
                                                    cp.ln_suc,
                                                    cp.ln_mda,
                                                    cp.ln_pap,
                                                    cp.ln_cta,
                                                    cp.ln_ope,
                                                    cp.ln_sbop,
                                                    cp.ln_tope,
                                                    ln_DesembHechos,
                                                    ln_TipCamb,
                                                    ln_CuotPendt);
      
        begin
          select min(a.aqpa358fecal)
            into ld_ffin
            from aqpa358 a
           where a.aqpa358instl = ln_Instancia
             and a.aqpa358pgcod = ln_pgcod
             and a.aqpa358itsuc = ln_itsuc
             and a.aqpa358itmod = ln_itmod
             and a.aqpa358ittran = ln_ittran
             and a.aqpa358itnrel = ln_itnrel
             and a.aqpa358itord = ln_itord
             and a.aqpa358itsbor = ln_itsbor
             and a.aqpa358fec = ld_FecProc;
        end;
      
        begin
          select max(a.aqpa358fecal)
            into ld_MaxFchCalnd
            from aqpa358 a
           where a.aqpa358instl = ln_Instancia
             and a.aqpa358pgcod = ln_pgcod
             and a.aqpa358itsuc = ln_itsuc
             and a.aqpa358itmod = ln_itmod
             and a.aqpa358ittran = ln_ittran
             and a.aqpa358itnrel = ln_itnrel
             and a.aqpa358itord = ln_itord
             and a.aqpa358itsbor = ln_itsbor
             and a.aqpa358fec = ld_FecProc;
        end;
      
        begin
          ld_fini := ADD_MONTHS(last_Day(ld_ffin), -1) + 1;
        end;
      
        while ld_ffin <= ld_MaxFchCalnd loop
        
          ln_MntCuoMesAux := 0;
          ln_MntCuoMes    := 0;
          ln_ratiomens    := 0;
        
          begin
            -- Verifico si el credito vigente tiene cuotas en el periodo 
            select count(*)
              into ln_TieneCalndario
              from fsd601 f
             where f.pgcod = cp.ln_pgcod
               and f.ppmod = cp.ln_mod
               and f.ppsuc = cp.ln_suc
               and f.ppmda = cp.ln_mda
               and f.pppap = cp.ln_pap
               and f.ppcta = cp.ln_cta
               and f.ppoper = cp.ln_ope
               and f.ppsbop = cp.ln_sbop
               and f.pptope = cp.ln_tope
               and f.d601co = 'S'
               and f.ppfpag between ld_fini and ld_ffin;
          exception
            when others then
              ln_TieneCalndario := 0;
          end;
        
          if ln_TieneCalndario > 0 then
          
            begin
              PQ_CR_RATIO_EVALFLUJO_RTE.sp_cr_LogDetMensualII(ln_Instancia   => ln_Instancia,
                                                              ln_pgcod       => ln_pgcod,
                                                              ln_itsuc       => ln_itsuc,
                                                              ln_itmod       => ln_itmod,
                                                              ln_ittran      => ln_ittran,
                                                              ln_itnrel      => ln_itnrel,
                                                              ln_itord       => ln_itord,
                                                              ln_itsbor      => ln_itsbor,
                                                              ld_FecProc     => ld_FecProc,
                                                              ln_modulo      => cp.LN_MOD,
                                                              ln_mntcuota    => ln_CuotPendt,
                                                              ld_fchPanel    => ld_ffin,
                                                              ln_NroCuOtorg  => NroCreOtorg,
                                                              ln_NroCuotCred => ln_NroCuot,
                                                              lc_Indicador   => cp.lc_indcred);
            
              PQ_CR_RATIO_EVALFLUJO_RTE.sp_cr_LogDetMensPanel(ln_Instancia   => ln_Instancia,
                                                              ln_pgcod       => ln_pgcod,
                                                              ln_itsuc       => ln_itsuc,
                                                              ln_itmod       => ln_itmod,
                                                              ln_ittran      => ln_ittran,
                                                              ln_itnrel      => ln_itnrel,
                                                              ln_itord       => ln_itord,
                                                              ln_itsbor      => ln_itsbor,
                                                              ld_FecProc     => ld_FecProc,
                                                              ln_modulo      => cp.LN_MOD,
                                                              ln_mntcuota    => ln_CuotPendt,
                                                              ld_fchPanel    => ld_ffin,
                                                              ln_NroCuOtorg  => NroCreOtorg,
                                                              ln_NroCuotCred => ln_NroCuot,
                                                              lc_Indicador   => cp.lc_indcred);
            end;
          
          end if;
        
          ld_fini := add_months(ld_fini, +1);
          ld_ffin := add_months(ld_ffin, +1);
        end loop;
      
      else
        if lc_VerfDesembPendt = 'T' then
          -- Con Desembolso Total  
          begin
            select min(a.aqpa358fecal)
              into ld_ffin
              from aqpa358 a
             where a.aqpa358instl = ln_Instancia
               and a.aqpa358pgcod = ln_pgcod
               and a.aqpa358itsuc = ln_itsuc
               and a.aqpa358itmod = ln_itmod
               and a.aqpa358ittran = ln_ittran
               and a.aqpa358itnrel = ln_itnrel
               and a.aqpa358itord = ln_itord
               and a.aqpa358itsbor = ln_itsbor
               and a.aqpa358fec = ld_FecProc;
          end;
        
          begin
            select max(a.aqpa358fecal)
              into ld_MaxFchCalnd
              from aqpa358 a
             where a.aqpa358instl = ln_Instancia
               and a.aqpa358pgcod = ln_pgcod
               and a.aqpa358itsuc = ln_itsuc
               and a.aqpa358itmod = ln_itmod
               and a.aqpa358ittran = ln_ittran
               and a.aqpa358itnrel = ln_itnrel
               and a.aqpa358itord = ln_itord
               and a.aqpa358itsbor = ln_itsbor
               and a.aqpa358fec = ld_FecProc;
          end;
        
          begin
            ld_fini := ADD_MONTHS(last_Day(ld_ffin), -1) + 1;
          end;
        
          while ld_ffin <= ld_MaxFchCalnd loop
          
            ln_MntCuoMesAux := 0;
            ln_MntCuoMes    := 0;
            ln_ratiomens    := 0;
          
            PQ_CR_RATIO_EVALFLUJO.sp_cr_CalCuota(cp.ln_pgcod,
                                                 cp.ln_mod,
                                                 cp.ln_suc,
                                                 cp.ln_mda,
                                                 cp.ln_pap,
                                                 cp.ln_cta,
                                                 cp.ln_ope,
                                                 cp.ln_sbop,
                                                 cp.ln_tope,
                                                 ld_fini,
                                                 ld_ffin,
                                                 ln_TipCamb,
                                                 ln_NroCuot,
                                                 ln_MntCuota);
          
            begin
              PQ_CR_RATIO_EVALFLUJO_RTE.sp_cr_LogDetMensualII(ln_Instancia   => ln_Instancia,
                                                              ln_pgcod       => ln_pgcod,
                                                              ln_itsuc       => ln_itsuc,
                                                              ln_itmod       => ln_itmod,
                                                              ln_ittran      => ln_ittran,
                                                              ln_itnrel      => ln_itnrel,
                                                              ln_itord       => ln_itord,
                                                              ln_itsbor      => ln_itsbor,
                                                              ld_FecProc     => ld_FecProc,
                                                              ln_modulo      => cp.LN_MOD,
                                                              ln_mntcuota    => ln_MntCuota,
                                                              ld_fchPanel    => ld_ffin,
                                                              ln_NroCuOtorg  => NroCreOtorg,
                                                              ln_NroCuotCred => ln_NroCuot,
                                                              lc_Indicador   => cp.lc_indcred);
              PQ_CR_RATIO_EVALFLUJO_RTE.sp_cr_LogDetMensPanel(ln_Instancia   => ln_Instancia,
                                                              ln_pgcod       => ln_pgcod,
                                                              ln_itsuc       => ln_itsuc,
                                                              ln_itmod       => ln_itmod,
                                                              ln_ittran      => ln_ittran,
                                                              ln_itnrel      => ln_itnrel,
                                                              ln_itord       => ln_itord,
                                                              ln_itsbor      => ln_itsbor,
                                                              ld_FecProc     => ld_FecProc,
                                                              ln_modulo      => cp.LN_MOD,
                                                              ln_mntcuota    => ln_MntCuota,
                                                              ld_fchPanel    => ld_ffin,
                                                              ln_NroCuOtorg  => NroCreOtorg,
                                                              ln_NroCuotCred => ln_NroCuot,
                                                              lc_Indicador   => cp.lc_indcred);
            end;
          
            ld_fini := add_months(ld_fini, +1);
            ld_ffin := add_months(ld_ffin, +1);
          
          end loop;
        
        end if;
      end if;
    
    end loop;
  
    for pv in Lista_ParcVuelo(lc_estado) loop
    
      begin
        select min(a.aqpa358fecal)
          into ld_ffin
          from aqpa358 a
         where a.aqpa358instl = ln_Instancia
           and a.aqpa358pgcod = ln_pgcod
           and a.aqpa358itsuc = ln_itsuc
           and a.aqpa358itmod = ln_itmod
           and a.aqpa358ittran = ln_ittran
           and a.aqpa358itnrel = ln_itnrel
           and a.aqpa358itord = ln_itord
           and a.aqpa358itsbor = ln_itsbor
           and a.aqpa358fec = ld_FecProc;
      end;
    
      begin
        select max(a.aqpa358fecal)
          into ld_MaxFchCalnd
          from aqpa358 a
         where a.aqpa358instl = ln_Instancia
           and a.aqpa358pgcod = ln_pgcod
           and a.aqpa358itsuc = ln_itsuc
           and a.aqpa358itmod = ln_itmod
           and a.aqpa358ittran = ln_ittran
           and a.aqpa358itnrel = ln_itnrel
           and a.aqpa358itord = ln_itord
           and a.aqpa358itsbor = ln_itsbor
           and a.aqpa358fec = ld_FecProc;
      end;
    
      begin
        ld_fini := ADD_MONTHS(last_Day(ld_ffin), -1) + 1;
      end;
    
      while ld_ffin <= ld_MaxFchCalnd loop
      
        ln_MntCuoMesAux := 0;
        ln_MntCuoMes    := 0;
        ln_ratiomens    := 0;
      
        PQ_CR_RATIO_EVALFLUJO.sp_cr_CalCuota(pv.ln_pgcod,
                                             pv.ln_mod,
                                             pv.ln_suc,
                                             pv.ln_mda,
                                             pv.ln_pap,
                                             pv.ln_cta,
                                             pv.ln_ope,
                                             pv.ln_sbop,
                                             pv.ln_tope,
                                             ld_fini,
                                             ld_ffin,
                                             ln_TipCamb,
                                             ln_NroCuot,
                                             ln_MntCuota);
      
        begin
          PQ_CR_RATIO_EVALFLUJO_RTE.sp_cr_LogDetMensualII(ln_Instancia   => ln_Instancia,
                                                          ln_pgcod       => ln_pgcod,
                                                          ln_itsuc       => ln_itsuc,
                                                          ln_itmod       => ln_itmod,
                                                          ln_ittran      => ln_ittran,
                                                          ln_itnrel      => ln_itnrel,
                                                          ln_itord       => ln_itord,
                                                          ln_itsbor      => ln_itsbor,
                                                          ld_FecProc     => ld_FecProc,
                                                          ln_modulo      => pv.LN_MOD,
                                                          ln_mntcuota    => ln_MntCuota,
                                                          ld_fchPanel    => ld_ffin,
                                                          ln_NroCuOtorg  => NroCreOtorg,
                                                          ln_NroCuotCred => ln_NroCuot,
                                                          lc_Indicador   => pv.lc_indcred);
        
          PQ_CR_RATIO_EVALFLUJO_RTE.sp_cr_LogDetMensPanel(ln_Instancia   => ln_Instancia,
                                                          ln_pgcod       => ln_pgcod,
                                                          ln_itsuc       => ln_itsuc,
                                                          ln_itmod       => ln_itmod,
                                                          ln_ittran      => ln_ittran,
                                                          ln_itnrel      => ln_itnrel,
                                                          ln_itord       => ln_itord,
                                                          ln_itsbor      => ln_itsbor,
                                                          ld_FecProc     => ld_FecProc,
                                                          ln_modulo      => pv.LN_MOD,
                                                          ln_mntcuota    => ln_MntCuota,
                                                          ld_fchPanel    => ld_ffin,
                                                          ln_NroCuOtorg  => NroCreOtorg,
                                                          ln_NroCuotCred => ln_NroCuot,
                                                          lc_Indicador   => pv.lc_indcred);
        end;
      
        ld_fini := add_months(ld_fini, +1);
        ld_ffin := add_months(ld_ffin, +1);
      
      end loop;
    
    end loop;
  
    for d in Linea_Disponer(lc_estado) loop
      begin
        select min(a.aqpa358fecal)
          into ld_ffin
          from aqpa358 a
         where a.aqpa358instl = ln_Instancia
           and a.aqpa358pgcod = ln_pgcod
           and a.aqpa358itsuc = ln_itsuc
           and a.aqpa358itmod = ln_itmod
           and a.aqpa358ittran = ln_ittran
           and a.aqpa358itnrel = ln_itnrel
           and a.aqpa358itord = ln_itord
           and a.aqpa358itsbor = ln_itsbor
           and a.aqpa358fec = ld_FecProc;
      end;
    
      begin
        select max(a.aqpa358fecal)
          into ld_MaxFchCalnd
          from aqpa358 a
         where a.aqpa358instl = ln_Instancia
           and a.aqpa358pgcod = ln_pgcod
           and a.aqpa358itsuc = ln_itsuc
           and a.aqpa358itmod = ln_itmod
           and a.aqpa358ittran = ln_ittran
           and a.aqpa358itnrel = ln_itnrel
           and a.aqpa358itord = ln_itord
           and a.aqpa358itsbor = ln_itsbor
           and a.aqpa358fec = ld_FecProc;
      end;
    
      begin
        ld_fini := ADD_MONTHS(last_Day(ld_ffin), -1) + 1;
      end;
    
      while ld_ffin <= ld_MaxFchCalnd loop
      
        ln_MntCuoMesAux := 0;
        ln_MntCuoMes    := 0;
        ln_ratiomens    := 0;
      
        begin
          select sum(f.ppcap + f.ppint)
            into ln_CapIntMnsl
            from fsd601 f
           where f.pgcod = d.ln_pgcod
             and f.ppmod = d.ln_mod
             and f.ppsuc = d.ln_suc
             and f.ppmda = d.ln_mda
             and f.pppap = d.ln_pap
             and f.ppcta = d.ln_cta
             and f.ppoper = d.ln_ope
             and f.ppsbop = d.ln_sbop
             and f.pptope = d.ln_tope
             and f.ppfpag between ld_fini and ld_ffin
             and f.d601co = 'E';
        exception
          when others then
            ln_CapIntMnsl := 0.00;
        end;
      
        ln_CapIntMnsl := nvl(ln_CapIntMnsl, 0);
      
        begin
          select sum(f.ppimp11 + f.ppimp12 + f.ppimp13 + f.ppimp14 +
                     f.ppimp15)
            into ln_IntMnsl
            from fsd611 f
           where f.pgcod = d.ln_pgcod
             and f.ppmod = d.ln_mod
             and f.ppsuc = d.ln_suc
             and f.ppmda = d.ln_mda
             and f.pppap = d.ln_pap
             and f.ppcta = d.ln_cta
             and f.ppoper = d.ln_ope
             and f.ppsbop = d.ln_sbop
             and f.pptope = d.ln_tope
             and f.ppfpag between ld_fini and ld_ffin;
        exception
          when others then
            ln_CapIntMnsl := 0.00;
        end;
        ln_IntMnsl  := nvl(ln_IntMnsl, 0);
        ln_MntCuota := ln_CapIntMnsl + ln_IntMnsl;
      
        begin
          PQ_CR_RATIO_EVALFLUJO_RTE.sp_cr_LogDetMensualII(ln_Instancia   => ln_Instancia,
                                                          ln_pgcod       => ln_pgcod,
                                                          ln_itsuc       => ln_itsuc,
                                                          ln_itmod       => ln_itmod,
                                                          ln_ittran      => ln_ittran,
                                                          ln_itnrel      => ln_itnrel,
                                                          ln_itord       => ln_itord,
                                                          ln_itsbor      => ln_itsbor,
                                                          ld_FecProc     => ld_FecProc,
                                                          ln_modulo      => d.LN_MOD,
                                                          ln_mntcuota    => ln_MntCuota,
                                                          ld_fchPanel    => ld_ffin,
                                                          ln_NroCuOtorg  => NroCreOtorg,
                                                          ln_NroCuotCred => ln_NroCuot,
                                                          lc_Indicador   => d.lc_indcred);
        
          PQ_CR_RATIO_EVALFLUJO_RTE.sp_cr_LogDetMensPanel(ln_Instancia   => ln_Instancia,
                                                          ln_pgcod       => ln_pgcod,
                                                          ln_itsuc       => ln_itsuc,
                                                          ln_itmod       => ln_itmod,
                                                          ln_ittran      => ln_ittran,
                                                          ln_itnrel      => ln_itnrel,
                                                          ln_itord       => ln_itord,
                                                          ln_itsbor      => ln_itsbor,
                                                          ld_FecProc     => ld_FecProc,
                                                          ln_modulo      => d.LN_MOD,
                                                          ln_mntcuota    => ln_MntCuota,
                                                          ld_fchPanel    => ld_ffin,
                                                          ln_NroCuOtorg  => NroCreOtorg,
                                                          ln_NroCuotCred => ln_NroCuot,
                                                          lc_Indicador   => d.lc_indcred);
        
        end;
      
        ld_fini := add_months(ld_fini, +1);
        ld_ffin := add_months(ld_ffin, +1);
      
      end loop;
    end loop;
  
    begin
      pq_cr_ratio_evalflujo_rte.sp_cr_recalculaRN(pn_ins     => ln_inste,
                                                  ln_pgcod   => ln_pgcod,
                                                  ln_itsuc   => ln_itsuc,
                                                  ln_itmod   => ln_itmod,
                                                  ln_ittran  => ln_ittran,
                                                  ln_itnrel  => ln_itnrel,
                                                  ln_itord   => ln_itord,
                                                  ln_itsbor  => ln_itsbor,
                                                  ld_FecProc => ld_FecProc);
    end;
  
    begin
      pq_cr_ratio_evalflujo_rte.sp_cr_UpRN_AQPA358(ln_instancia => ln_Instancia,
                                                   ln_pgcod     => ln_pgcod,
                                                   ln_itsuc     => ln_itsuc,
                                                   ln_itmod     => ln_itmod,
                                                   ln_ittran    => ln_ittran,
                                                   ln_itnrel    => ln_itnrel,
                                                   ln_itord     => ln_itord,
                                                   ln_itsbor    => ln_itsbor,
                                                   ld_FecProc   => ld_FecProc);
    end;
  
    begin
      PQ_CR_RATIO_EVALFLUJO_RTE.sp_cr_CalFormula(ln_Instancia => ln_Instancia,
                                                 --ln_inste     => ln_inste,
                                                 ln_pgcod   => ln_pgcod,
                                                 ln_itsuc   => ln_itsuc,
                                                 ln_itmod   => ln_itmod,
                                                 ln_ittran  => ln_ittran,
                                                 ln_itnrel  => ln_itnrel,
                                                 ln_itord   => ln_itord,
                                                 ln_itsbor  => ln_itsbor,
                                                 ld_FecProc => ld_FecProc);
    end;
  
  end sp_cr_CalcRatio;
  ------------------------------------------------------------------------------
  procedure sp_cr_DatosRatio(ln_instancia  in number,
                             ln_InsEval    in number,
                             ln_pgcod      in number,
                             ln_itsuc      in number,
                             ln_itmod      in number,
                             ln_ittran     in number,
                             ln_itnrel     in number,
                             ln_itord      in number,
                             ln_itsbor     in number,
                             ld_FecProc    in date,
                             ln_capcaja    out number,
                             ln_capifis    out number,
                             ln_capcontgnt out number,
                             ln_capptncl   out number,
                             ln_ResulNeto  out number,
                             ln_Ratio      out number) is
  
    ld_fech    date;
    lc_user    varchar2(10);
    ln_pais    number;
    ln_tdoc    number;
    ln_ndoc    varchar2(12);
    ln_tcamb   number;
    ln_inst    number;
    lc_mesanio varchar2(8);
    lc_Estado  varchar2(2) := 'I';
  
  begin
  
    lc_Estado := 'I';
  
    begin
      select a.AQPA358fec,
             a.AQPA358pais,
             a.AQPA358tdoc,
             a.AQPA358ndoc,
             a.AQPA358tcamb,
             a.AQPA358instl,
             a.AQPA358user,
             a.AQPA358mesanio,
             a.AQPA358capcaja,
             a.AQPA358ifis,
             a.AQPA358resneto,
             a.AQPA358ccontg,
             a.AQPA358cpoten,
             a.AQPA358ratio
        into ld_fech,
             ln_pais,
             ln_tdoc,
             ln_ndoc,
             ln_tcamb,
             ln_inst,
             lc_user,
             lc_mesanio,
             ln_capcaja,
             ln_capifis,
             ln_ResulNeto,
             ln_capcontgnt,
             ln_capptncl,
             ln_Ratio
        from AQPA358 a
       where a.AQPA358instl = ln_instancia
         and a.aqpa358pgcod = ln_pgcod
         and a.aqpa358itsuc = ln_itsuc
         and a.aqpa358itmod = ln_itmod
         and a.aqpa358ittran = ln_ittran
         and a.aqpa358itnrel = ln_itnrel
         and a.aqpa358itord = ln_itord
         and a.aqpa358itsbor = ln_itsbor
         and a.aqpa358fec = ld_FecProc
         and a.AQPA358est = lc_Estado
         and a.AQPA358ratio =
             (select max(b.AQPA358ratio)
                from AQPA358 b
               where b.AQPA358instl = ln_instancia
                 and b.aqpa358pgcod = ln_pgcod
                 and b.aqpa358itsuc = ln_itsuc
                 and b.aqpa358itmod = ln_itmod
                 and b.aqpa358ittran = ln_ittran
                 and b.aqpa358itnrel = ln_itnrel
                 and b.aqpa358itord = ln_itord
                 and b.aqpa358itsbor = ln_itsbor
                 and b.aqpa358fec = ld_FecProc
                 and b.AQPA358est = lc_Estado);
    exception
      when too_many_rows then
        begin
          select a.AQPA358fec,
                 a.AQPA358pais,
                 a.AQPA358tdoc,
                 a.AQPA358ndoc,
                 a.AQPA358tcamb,
                 a.AQPA358instl,
                 a.AQPA358user,
                 a.AQPA358mesanio,
                 a.AQPA358capcaja,
                 a.AQPA358ifis,
                 a.AQPA358resneto,
                 a.AQPA358ccontg,
                 a.AQPA358cpoten,
                 a.AQPA358ratio
            into ld_fech,
                 ln_pais,
                 ln_tdoc,
                 ln_ndoc,
                 ln_tcamb,
                 ln_inst,
                 lc_user,
                 lc_mesanio,
                 ln_capcaja,
                 ln_capifis,
                 ln_ResulNeto,
                 ln_capcontgnt,
                 ln_capptncl,
                 ln_Ratio
            from AQPA358 a
           where a.AQPA358instl = ln_instancia
             and a.aqpa358pgcod = ln_pgcod
             and a.aqpa358itsuc = ln_itsuc
             and a.aqpa358itmod = ln_itmod
             and a.aqpa358ittran = ln_ittran
             and a.aqpa358itnrel = ln_itnrel
             and a.aqpa358itord = ln_itord
             and a.aqpa358itsbor = ln_itsbor
             and a.aqpa358fec = ld_FecProc
             and a.AQPA358est = lc_Estado
             and a.AQPA358mesanio =
                 (select min(b.AQPA358mesanio)
                    from AQPA358 b
                   where b.AQPA358instl = ln_instancia
                     and b.aqpa358pgcod = ln_pgcod
                     and b.aqpa358itsuc = ln_itsuc
                     and b.aqpa358itmod = ln_itmod
                     and b.aqpa358ittran = ln_ittran
                     and b.aqpa358itnrel = ln_itnrel
                     and b.aqpa358itord = ln_itord
                     and b.aqpa358itsbor = ln_itsbor
                     and b.aqpa358fec = ld_FecProc
                     and b.AQPA358est = lc_Estado
                     and b.AQPA358ratio =
                         (select max(b.AQPA358ratio)
                            from AQPA358 c
                           where c.AQPA358instl = ln_instancia
                             and c.AQPA358est = lc_Estado));
        exception
          when others then
            null;
        end;
      when no_data_found then
        null;
      
    end;
  
    ln_pais := nvl(ln_pais, 0);
  
    if ln_pais > 0 then
      begin
        PQ_CR_RATIO_EVALFLUJO_RTE.sp_cr_LogRatio(ln_Pepais      => ln_pais,
                                                 ln_Petdoc      => ln_tdoc,
                                                 ln_Pendoc      => ln_ndoc,
                                                 tipocambio     => ln_tcamb,
                                                 pd_fecpro      => ld_fech,
                                                 ln_instl       => ln_instancia,
                                                 ln_inste       => ln_InsEval,
                                                 ln_pgcod       => ln_pgcod,
                                                 ln_itsuc       => ln_itsuc,
                                                 ln_itmod       => ln_itmod,
                                                 ln_ittran      => ln_ittran,
                                                 ln_itnrel      => ln_itnrel,
                                                 ln_itord       => ln_itord,
                                                 ln_itsbor      => ln_itsbor,
                                                 lc_Usuario     => lc_user,
                                                 lc_mesanio     => lc_mesanio,
                                                 ln_captotcaja  => ln_capcaja,
                                                 ln_ifis        => ln_capifis,
                                                 ln_ResultNeto  => ln_ResulNeto,
                                                 ln_MntCuoCntg  => ln_capcontgnt,
                                                 ln_MntPotncial => ln_capptncl,
                                                 ln_ratio       => ln_ratio);
      
        PQ_CR_RATIO_EVALFLUJO_RTE.sp_cr_ActMntCuota(ln_Instancia => ln_instancia,
                                                    ln_pgcod     => ln_pgcod,
                                                    ln_itsuc     => ln_itsuc,
                                                    ln_itmod     => ln_itmod,
                                                    ln_ittran    => ln_ittran,
                                                    ln_itnrel    => ln_itnrel,
                                                    ln_itord     => ln_itord,
                                                    ln_itsbor    => ln_itsbor,
                                                    ld_fecpro    => ld_FecProc,
                                                    lc_mesanio   => lc_mesanio);
      
      end;
    end if;
  
  end sp_cr_DatosRatio;

  -------------------------------------------------------------------------------
  procedure sp_cr_ActMntCuota(ln_Instancia in number,
                              ln_pgcod     in number,
                              ln_itsuc     in number,
                              ln_itmod     in number,
                              ln_ittran    in number,
                              ln_itnrel    in number,
                              ln_itord     in number,
                              ln_itsbor    in number,
                              ld_fecpro    in date,
                              lc_mesanio   in varchar2) is
  
    cursor Lista_OtrosCred(lc_estado varchar2) is
    -- Cursor Creditos que no son Linea (Solo Linea Utilizada) ni Desembolso Parcial
      select a.AQPA357pgcod   ln_pgcod,
             a.AQPA357mod     ln_mod,
             a.AQPA357suc     ln_suc,
             a.AQPA357mda     ln_mda,
             a.AQPA357pap     ln_pap,
             a.AQPA357cta     ln_cta,
             a.AQPA357ope     ln_ope,
             a.AQPA357sbop    ln_sbop,
             a.AQPA357tope    ln_tope,
             a.AQPA357indcred lc_IndCred,
             a.AQPA357tcamb   ln_tipcamb
        from AQPA357 a
       where a.AQPA357instl = ln_Instancia
         and a.aqpa357pgcod = ln_pgcod
         and a.aqpa357itsuc = ln_itsuc
         and a.aqpa357itmod = ln_itmod
         and a.aqpa357ittran = ln_ittran
         and a.aqpa357itnrel = ln_itnrel
         and a.aqpa357itord = ln_itord
         and a.aqpa357itsbor = ln_itsbor
         and a.aqpa357fec = ld_fecpro
         and a.AQPA357est = lc_estado
         and a.AQPA357mod <> 117 --Excluye Lineas
         and a.AQPA357ori <> 7 --Excluye desembolsos parciales
         and a.AQPA357indcred in ('CredVigent', 'CredVencid', 'CredVuelo');
  
    cursor linea_vuelo(lc_estado varchar2) is
      select a.AQPA357pgcod   ln_pgcod,
             a.AQPA357mod     ln_mod,
             a.AQPA357suc     ln_suc,
             a.AQPA357mda     ln_mda,
             a.AQPA357pap     ln_pap,
             a.AQPA357cta     ln_cta,
             a.AQPA357ope     ln_ope,
             a.AQPA357sbop    ln_sbop,
             a.AQPA357tope    ln_tope,
             a.AQPA357indcred lc_IndCred,
             a.AQPA357tcamb   ln_tipcamb
        from AQPA357 a
       where a.AQPA357instl = ln_Instancia
         and a.aqpa357pgcod = ln_pgcod
         and a.aqpa357itsuc = ln_itsuc
         and a.aqpa357itmod = ln_itmod
         and a.aqpa357ittran = ln_ittran
         and a.aqpa357itnrel = ln_itnrel
         and a.aqpa357itord = ln_itord
         and a.aqpa357itsbor = ln_itsbor
         and a.aqpa357fec = ld_fecpro
         and a.AQPA357est = lc_estado
         and a.AQPA357indcred = 'CredVuelo'
         and a.AQPA357mod = 117;
  
    cursor linea_vigente(lc_estado varchar2) is
    -- Linea Vigente sin uso
      select a.AQPA357pgcod   ln_pgcod,
             a.AQPA357mod     ln_mod,
             a.AQPA357suc     ln_suc,
             a.AQPA357mda     ln_mda,
             a.AQPA357pap     ln_pap,
             a.AQPA357cta     ln_cta,
             a.AQPA357ope     ln_ope,
             a.AQPA357sbop    ln_sbop,
             a.AQPA357tope    ln_tope,
             a.AQPA357indcred lc_IndCred,
             a.AQPA357tcamb   ln_tipcamb
        from AQPA357 a
       where a.AQPA357instl = ln_Instancia
         and a.aqpa357pgcod = ln_pgcod
         and a.aqpa357itsuc = ln_itsuc
         and a.aqpa357itmod = ln_itmod
         and a.aqpa357ittran = ln_ittran
         and a.aqpa357itnrel = ln_itnrel
         and a.aqpa357itord = ln_itord
         and a.aqpa357itsbor = ln_itsbor
         and a.aqpa357fec = ld_fecpro
         and a.AQPA357est = lc_estado
         and a.AQPA357indcred = 'CredVigent'
         and a.AQPA357mod = 117;
  
    cursor linea_vencida(lc_estado varchar2) is
      select a.AQPA357pgcod   ln_pgcod,
             a.AQPA357mod     ln_mod,
             a.AQPA357suc     ln_suc,
             a.AQPA357mda     ln_mda,
             a.AQPA357pap     ln_pap,
             a.AQPA357cta     ln_cta,
             a.AQPA357ope     ln_ope,
             a.AQPA357sbop    ln_sbop,
             a.AQPA357tope    ln_tope,
             a.AQPA357indcred lc_IndCred,
             a.AQPA357tcamb   ln_tipcamb
        from AQPA357 a
       where a.AQPA357instl = ln_Instancia
         and a.aqpa357pgcod = ln_pgcod
         and a.aqpa357itsuc = ln_itsuc
         and a.aqpa357itmod = ln_itmod
         and a.aqpa357ittran = ln_ittran
         and a.aqpa357itnrel = ln_itnrel
         and a.aqpa357itord = ln_itord
         and a.aqpa357itsbor = ln_itsbor
         and a.aqpa357fec = ld_fecpro
         and a.AQPA357est = lc_estado
         and a.AQPA357indcred = 'LineaVencd';
  
    cursor credito_parcial(lc_estado varchar2) is
      select a.AQPA357pgcod   ln_pgcod,
             a.AQPA357mod     ln_mod,
             a.AQPA357suc     ln_suc,
             a.AQPA357mda     ln_mda,
             a.AQPA357pap     ln_pap,
             a.AQPA357cta     ln_cta,
             a.AQPA357ope     ln_ope,
             a.AQPA357sbop    ln_sbop,
             a.AQPA357tope    ln_tope,
             a.AQPA357indcred lc_IndCred,
             a.AQPA357tcamb   ln_tipcamb
        from AQPA357 a
       where a.AQPA357instl = ln_Instancia
         and a.aqpa357pgcod = ln_pgcod
         and a.aqpa357itsuc = ln_itsuc
         and a.aqpa357itmod = ln_itmod
         and a.aqpa357ittran = ln_ittran
         and a.aqpa357itnrel = ln_itnrel
         and a.aqpa357itord = ln_itord
         and a.aqpa357itsbor = ln_itsbor
         and a.aqpa357fec = ld_fecpro
         and a.AQPA357est = lc_estado
         and a.AQPA357ori = 7
         and a.AQPA357indcred in ('CredVigent', 'CredVencid');
  
    cursor Lista_ParcVuelo(lc_estado varchar2) is
      select a.AQPA357pgcod   ln_pgcod,
             a.AQPA357mod     ln_mod,
             a.AQPA357suc     ln_suc,
             a.AQPA357mda     ln_mda,
             a.AQPA357pap     ln_pap,
             a.AQPA357cta     ln_cta,
             a.AQPA357ope     ln_ope,
             a.AQPA357sbop    ln_sbop,
             a.AQPA357tope    ln_tope,
             a.AQPA357indcred lc_IndCred,
             a.AQPA357tcamb   ln_tipcamb
        from AQPA357 a
       where a.AQPA357instl = ln_Instancia
         and a.aqpa357pgcod = ln_pgcod
         and a.aqpa357itsuc = ln_itsuc
         and a.aqpa357itmod = ln_itmod
         and a.aqpa357ittran = ln_ittran
         and a.aqpa357itnrel = ln_itnrel
         and a.aqpa357itord = ln_itord
         and a.aqpa357itsbor = ln_itsbor
         and a.aqpa357fec = ld_fecpro
         and a.AQPA357est = lc_estado
         and a.AQPA357ori = 7 -- Desembolsos parciales
         and a.AQPA357indcred = 'CredVuelo';
  
    cursor Linea_Disponer(lc_estado varchar2) is
      select a.AQPA357pgcod   ln_pgcod,
             a.AQPA357mod     ln_mod,
             a.AQPA357suc     ln_suc,
             a.AQPA357mda     ln_mda,
             a.AQPA357pap     ln_pap,
             a.AQPA357cta     ln_cta,
             a.AQPA357ope     ln_ope,
             a.AQPA357sbop    ln_sbop,
             a.AQPA357tope    ln_tope,
             a.AQPA357indcred lc_IndCred
        from AQPA357 a
       where a.AQPA357instl = ln_Instancia
         and a.aqpa357pgcod = ln_pgcod
         and a.aqpa357itsuc = ln_itsuc
         and a.aqpa357itmod = ln_itmod
         and a.aqpa357ittran = ln_ittran
         and a.aqpa357itnrel = ln_itnrel
         and a.aqpa357itord = ln_itord
         and a.aqpa357itsbor = ln_itsbor
         and a.aqpa357fec = ld_fecpro
         and a.AQPA357est = lc_estado
         and a.AQPA357indcred = 'DispLinea';
  
    ld_FchIni       date;
    lc_estado       varchar2(2) := 'I';
    ld_FchFin       date;
    ln_MntCuoMes    number(17, 2) := 0.00;
    ln_emp          number := 0;
    ln_sucur        number := 0;
    ln_mod          number := 0;
    ln_mda          number := 0;
    ln_pap          number := 0;
    ln_cta          number := 0;
    ln_oper         number := 0;
    ln_sbop         number := 0;
    ln_tipoper      number := 0;
    NroCreOtorg     number := 0;
    ln_CuoDisp      number(17, 2) := 0.00;
    ln_MntDispnb    number(17, 2) := 0.00;
    ln_MntCuoMesAux number(17, 2) := 0.00;
    ld_FchCalend    date;
    ln_mntacumld    number(17, 2) := 0.00;
    ld_MaxFechCalnd date;
    ld_UltDia       date;
    --ln_CuoDisp      number(17, 2) := 0.00;
    ln_NroCuot         number;
    lc_VerfDesembPendt varchar2(2) := 'T';
    ln_NroDesemblsPact number := 0;
    ln_DesembHechos    number := 0;
    lc_fgAdic          varchar2(2) := 'N';
    ln_newmnt          number(17, 2) := 0.00;
    ln_MaxPlazAdi      number := 0;
    ln_CuoCapAdi       number(17, 2) := 0.00;
    LC_VerfAdi         varchar2(2) := 'N';
    ln_CapIntMnsl      number(17, 2) := 0.00;
    ln_IntMnsl         number(17, 2) := 0.00;
    ln_MntCuota        number(17, 2) := 0.00;
  
    ln_pgcod116 number := 0;
    ln_mod116   number := 0;
    ln_tope116  number := 0;
    ln_suc116   number := 0;
    ln_mda116   number := 0;
    ln_pap116   number := 0;
    ln_cta116   number := 0;
    ln_oper116  number := 0;
    ln_sbop116  number := 0;
    ln_cuenta   number := 0;
  
  begin
  
    lc_estado := 'I';
  
    begin
      ld_FchIni := to_date(lc_mesanio || '01', 'yyyymmdd');
    
      ld_FchFin := last_day(ld_FchIni);
    end;
  
    begin
      begin
        select x.xwfempresa,
               x.xwfsucursal,
               x.xwfmodulo,
               x.xwfmoneda,
               x.xwfpapel,
               x.xwfcuenta,
               x.xwfoperacion,
               x.xwfsubope,
               x.xwftipope
          into ln_emp,
               ln_sucur,
               ln_mod,
               ln_mda,
               ln_pap,
               ln_cta,
               ln_oper,
               ln_sbop,
               ln_tipoper
          from xwf700 x
         where x.xwfprcins = ln_Instancia
           and x.xwfcar3 = '1';
      end;
    
      begin
        if ln_mod <> 117 then
        
          begin
            select months_between(max(f.ppfvto), min(f.ppfval))
              into NroCreOtorg
              from fsd601 f
             where f.pgcod = ln_emp
               and f.ppmod = ln_mod
               and f.ppsuc = ln_sucur
               and f.ppmda = ln_mda
               and f.pppap = ln_pap
               and f.ppcta = ln_cta
               and f.ppoper = ln_oper
               and f.ppsbop = ln_sbop
               and f.pptope = ln_tipoper;
          exception
            when others then
              NroCreOtorg := 0;
          end;
        
        else
          if ln_mod = 117 then
            PQ_CR_RATIO_EVALFLUJO.sp_cr_NroCuOPreseteo(ln_pgcod        => ln_emp,
                                                       ln_modulo       => ln_mod,
                                                       ln_sucursal     => ln_sucur,
                                                       ln_moneda       => ln_mda,
                                                       ln_papel        => ln_pap,
                                                       ln_cuenta       => ln_cta,
                                                       ln_operacion    => ln_oper,
                                                       ln_suboperacion => ln_sbop,
                                                       ln_tipoperacion => ln_tipoper,
                                                       ln_NroCuot      => NroCreOtorg);
          end if;
        end if;
      end;
    
    end;
  
    begin
      select f.pgcod,
             f.modulo,
             f.ittope,
             f.itsucd,
             f.moneda,
             f.papel,
             f.ctnro,
             f.itoper,
             f.itsubo
        into ln_pgcod116,
             ln_mod116,
             ln_tope116,
             ln_suc116,
             ln_mda116,
             ln_pap116,
             ln_cta116,
             ln_oper116,
             ln_sbop116
        from fsd016 f
       where f.pgcod = ln_pgcod
         and f.itsuc = ln_itsuc
         and f.itmod = ln_itmod
         and f.ittran = ln_ittran
         and f.itnrel = ln_itnrel
         and f.itord = ln_itord
         and f.itsbor = ln_itsbor;
    exception
      when others then
        ln_pgcod116 := 0;
        ln_mod116   := 0;
        ln_tope116  := 0;
        ln_suc116   := 0;
        ln_mda116   := 0;
        ln_pap116   := 0;
        ln_cta116   := 0;
        ln_oper116  := 0;
        ln_sbop116  := 0;
    end;
  
    for oc in Lista_OtrosCred(lc_estado) loop
    
      if oc.ln_pgcod = ln_pgcod116 and oc.ln_mod = ln_mod116 and
         oc.ln_suc = ln_suc116 and oc.ln_mda = ln_mda116 and
         oc.ln_pap = ln_pap116 and oc.ln_cta = ln_cta116 and
         oc.ln_ope = ln_oper116 and oc.ln_sbop = ln_sbop116 and
         oc.ln_tope = ln_tope116 then
      
        ln_cuenta := 999999999;
      
        PQ_CR_RATIO_EVALFLUJO.sp_cr_CalCuota(oc.ln_pgcod,
                                             oc.ln_mod,
                                             oc.ln_suc,
                                             oc.ln_mda,
                                             oc.ln_pap,
                                             ln_cuenta,
                                             oc.ln_ope,
                                             oc.ln_sbop,
                                             oc.ln_tope,
                                             ld_FchIni,
                                             ld_FchFin,
                                             oc.ln_tipcamb,
                                             ln_NroCuot,
                                             ln_MntCuoMes);
      else
      
        PQ_CR_RATIO_EVALFLUJO.sp_cr_CalCuota(oc.ln_pgcod,
                                             oc.ln_mod,
                                             oc.ln_suc,
                                             oc.ln_mda,
                                             oc.ln_pap,
                                             oc.ln_cta,
                                             oc.ln_ope,
                                             oc.ln_sbop,
                                             oc.ln_tope,
                                             ld_FchIni,
                                             ld_FchFin,
                                             oc.ln_tipcamb,
                                             ln_NroCuot,
                                             ln_MntCuoMes);
      end if;
    
      -- if oc.ln_mod <> 117 then
      begin
        update AQPA357 a
           set a.AQPA357naux1 = ln_MntCuoMes
         where a.AQPA357pgcod = oc.ln_pgcod
           and a.AQPA357mod = oc.ln_mod
           and a.AQPA357suc = oc.ln_suc
           and a.AQPA357mda = oc.ln_mda
           and a.AQPA357pap = oc.ln_pap
           and a.AQPA357cta = oc.ln_cta
           and a.AQPA357ope = oc.ln_ope
           and a.AQPA357sbop = oc.ln_sbop
           and a.AQPA357tope = oc.ln_tope
           and a.AQPA357instl = ln_Instancia
           and a.aqpa357pgcod = ln_pgcod
           and a.aqpa357itsuc = ln_itsuc
           and a.aqpa357itmod = ln_itmod
           and a.aqpa357ittran = ln_ittran
           and a.aqpa357itnrel = ln_itnrel
           and a.aqpa357itord = ln_itord
           and a.aqpa357itsbor = ln_itsbor
           and a.aqpa357fec = ld_fecpro
           and a.AQPA357est = lc_estado;
        commit;
      end;
    
      -- end if;
    
      if oc.ln_mod = 116 then
      
        if oc.ln_pgcod <> ln_pgcod116 and oc.ln_mod <> ln_mod116 and
           oc.ln_suc <> ln_suc116 and oc.ln_mda <> ln_mda116 and
           oc.ln_pap <> ln_pap116 and oc.ln_cta <> ln_cta116 and
           oc.ln_ope <> ln_oper116 and oc.ln_sbop <> ln_sbop116 and
           oc.ln_tope <> ln_tope116 then
        
          PQ_CR_RATIO_EVALFLUJO.Sp_Adicional_CK(oc.ln_mod,
                                                oc.ln_tope,
                                                lc_fgAdic);
        
          if lc_fgAdic = 'N' then
          
            ln_CuoDisp := nvl(ln_CuoDisp, 0);
            ln_CuoDisp := ln_CuoDisp * NroCreOtorg;
          
            if ln_mod = 117 then
            
              begin
                select a.AQPA358fecal
                  into ld_FchCalend
                  from AQPA358 a
                 where a.AQPA358instl = ln_Instancia
                   and a.aqpa358pgcod = ln_pgcod
                   and a.aqpa358itsuc = ln_itsuc
                   and a.aqpa358itmod = ln_itmod
                   and a.aqpa358ittran = ln_ittran
                   and a.aqpa358itnrel = ln_itnrel
                   and a.aqpa358itord = ln_itord
                   and a.aqpa358itsbor = ln_itsbor
                   and a.aqpa358fec = ld_fecpro
                   and a.AQPA358corr = NroCreOtorg
                   and a.AQPA358est = lc_estado;
              exception
                when others then
                  ln_mntacumld := 0.00;
              end;
            
              ln_MntCuoMes := nvl(ln_MntCuoMes, 0);
              begin
                ln_MntCuoMes := ln_MntCuoMes + ln_CuoDisp;
                ln_MntCuoMes := nvl(ln_MntCuoMes, 0);
              end;
            
              if ld_FchCalend = ld_FchFin then
              
                begin
                  update AQPA357 a
                     set a.AQPA357naux1 = ln_MntCuoMes
                   where a.AQPA357pgcod = oc.ln_pgcod
                     and a.AQPA357mod = oc.ln_mod
                     and a.AQPA357suc = oc.ln_suc
                     and a.AQPA357mda = oc.ln_mda
                     and a.AQPA357pap = oc.ln_pap
                     and a.AQPA357cta = oc.ln_cta
                     and a.AQPA357ope = oc.ln_ope
                     and a.AQPA357sbop = oc.ln_sbop
                     and a.AQPA357tope = oc.ln_tope
                     and a.AQPA357instl = ln_Instancia
                     and a.aqpa357pgcod = ln_pgcod
                     and a.aqpa357itsuc = ln_itsuc
                     and a.aqpa357itmod = ln_itmod
                     and a.aqpa357ittran = ln_ittran
                     and a.aqpa357itnrel = ln_itnrel
                     and a.aqpa357itord = ln_itord
                     and a.aqpa357itsbor = ln_itsbor
                     and a.aqpa357fec = ld_fecpro
                     and a.AQPA357est = lc_estado;
                  commit;
                end;
              end if;
            
            else
              if ln_mod <> 117 then
              
                begin
                  select max(f.ppfpag)
                    into ld_MaxFechCalnd
                    from fsd601 f
                   where f.pgcod = ln_emp
                     and f.ppmod = ln_mod
                     and f.ppsuc = ln_sucur
                     and f.ppmda = ln_mda
                     and f.pppap = ln_pap
                     and f.ppcta = ln_cta
                     and f.ppoper = ln_oper
                     and f.ppsbop = ln_sbop
                     and f.pptope = ln_tipoper
                     and f.d601co = 'X';
                exception
                  when others then
                    null;
                end;
              
                begin
                  begin
                    ld_UltDia := last_Day(ld_MaxFechCalnd);
                  end;
                end;
              
                if ld_UltDia = ld_FchFin then
                
                  ln_MntCuoMes := nvl(ln_MntCuoMes, 0);
                  begin
                    ln_MntCuoMes := ln_MntCuoMes + ln_CuoDisp;
                    ln_MntCuoMes := nvl(ln_MntCuoMes, 0);
                  end;
                
                  begin
                    update AQPA357 a
                       set a.AQPA357naux1 = ln_MntCuoMes
                     where a.AQPA357pgcod = oc.ln_pgcod
                       and a.AQPA357mod = oc.ln_mod
                       and a.AQPA357suc = oc.ln_suc
                       and a.AQPA357mda = oc.ln_mda
                       and a.AQPA357pap = oc.ln_pap
                       and a.AQPA357cta = oc.ln_cta
                       and a.AQPA357ope = oc.ln_ope
                       and a.AQPA357sbop = oc.ln_sbop
                       and a.AQPA357tope = oc.ln_tope
                       and a.AQPA357instl = ln_Instancia
                       and a.aqpa357pgcod = ln_pgcod
                       and a.aqpa357itsuc = ln_itsuc
                       and a.aqpa357itmod = ln_itmod
                       and a.aqpa357ittran = ln_ittran
                       and a.aqpa357itnrel = ln_itnrel
                       and a.aqpa357itord = ln_itord
                       and a.aqpa357itsbor = ln_itsbor
                       and a.aqpa357fec = ld_fecpro
                       and a.AQPA357est = lc_estado;
                    commit;
                  end;
                
                end if;
              
              end if;
            end if;
          else
            if lc_fgAdic = 'S' then
              ln_newmnt := 0;
            
              PQ_CR_RATIO_EVALFLUJO.sp_CapLineaAdicional(ln_mod10        => oc.ln_mod,
                                                         ln_suc10        => oc.ln_suc,
                                                         ln_mda10        => oc.ln_mda,
                                                         ln_pap10        => oc.ln_pap,
                                                         ln_cta10        => oc.ln_cta,
                                                         ln_oper10       => oc.ln_ope,
                                                         ln_sbop10       => oc.ln_sbop,
                                                         ln_tope10       => oc.ln_tope,
                                                         tipocambio      => oc.ln_tipcamb,
                                                         ln_plazo        => ln_MaxPlazAdi,
                                                         ln_CapAdicional => ln_CuoCapAdi);
            
              ln_MaxPlazAdi := ln_MaxPlazAdi + 1;
            
              begin
                select a.AQPA358fecal
                  into ld_FchCalend
                  from AQPA358 a
                 where a.AQPA358instl = ln_Instancia
                   and a.aqpa358pgcod = ln_pgcod
                   and a.aqpa358itsuc = ln_itsuc
                   and a.aqpa358itmod = ln_itmod
                   and a.aqpa358ittran = ln_ittran
                   and a.aqpa358itnrel = ln_itnrel
                   and a.aqpa358itord = ln_itord
                   and a.aqpa358itsbor = ln_itsbor
                   and a.aqpa358fec = ld_fecpro
                   and a.AQPA358corr = ln_MaxPlazAdi
                   and a.AQPA358est = lc_estado;
              exception
                when others then
                  null;
              end;
            
              if ld_FchCalend = ld_FchFin then
                begin
                  update AQPA357 a
                     set a.AQPA357naux3 = ln_CuoCapAdi
                   where a.AQPA357pgcod = oc.ln_pgcod
                     and a.AQPA357mod = oc.ln_mod
                     and a.AQPA357suc = oc.ln_suc
                     and a.AQPA357mda = oc.ln_mda
                     and a.AQPA357pap = oc.ln_pap
                     and a.AQPA357cta = oc.ln_cta
                     and a.AQPA357ope = oc.ln_ope
                     and a.AQPA357sbop = oc.ln_sbop
                     and a.AQPA357tope = oc.ln_tope
                     and a.AQPA357instl = ln_Instancia
                     and a.aqpa357pgcod = ln_pgcod
                     and a.aqpa357itsuc = ln_itsuc
                     and a.aqpa357itmod = ln_itmod
                     and a.aqpa357ittran = ln_ittran
                     and a.aqpa357itnrel = ln_itnrel
                     and a.aqpa357itord = ln_itord
                     and a.aqpa357itsbor = ln_itsbor
                     and a.aqpa357fec = ld_fecpro
                     and a.AQPA357est = lc_estado;
                  commit;
                end;
              end if;
            end if;
          end if;
        end if;
      end if;
    end loop;
  
    for lv in linea_vuelo(lc_estado) loop
    
      PQ_CR_RATIO_EVALFLUJO.sp_cr_CalCuota(lv.ln_pgcod,
                                           lv.ln_mod,
                                           lv.ln_suc,
                                           lv.ln_mda,
                                           lv.ln_pap,
                                           lv.ln_cta,
                                           lv.ln_ope,
                                           lv.ln_sbop,
                                           lv.ln_tope,
                                           ld_FchIni,
                                           ld_FchFin,
                                           lv.ln_TipCamb,
                                           ln_NroCuot,
                                           ln_MntCuoMes);
    
      begin
        select a.AQPA358fecal
          into ld_FchCalend
          from AQPA358 a
         where a.AQPA358instl = ln_Instancia
           and a.aqpa358pgcod = ln_pgcod
           and a.aqpa358itsuc = ln_itsuc
           and a.aqpa358itmod = ln_itmod
           and a.aqpa358ittran = ln_ittran
           and a.aqpa358itnrel = ln_itnrel
           and a.aqpa358itord = ln_itord
           and a.aqpa358itsbor = ln_itsbor
           and a.aqpa358fec = ld_fecpro
           and a.AQPA358corr = ln_MaxPlazAdi + 1
           and a.AQPA358est = lc_estado;
      exception
        when others then
          null;
      end;
    
      if ld_FchCalend = ld_FchFin then
        begin
          update AQPA357 a
             set a.AQPA357naux3 = ln_CuoCapAdi
           where a.AQPA357pgcod = lv.ln_pgcod
             and a.AQPA357mod = lv.ln_mod
             and a.AQPA357suc = lv.ln_suc
             and a.AQPA357mda = lv.ln_mda
             and a.AQPA357pap = lv.ln_pap
             and a.AQPA357cta = lv.ln_cta
             and a.AQPA357ope = lv.ln_ope
             and a.AQPA357sbop = lv.ln_sbop
             and a.AQPA357tope = lv.ln_tope
             and a.AQPA357instl = ln_Instancia
             and a.aqpa357pgcod = ln_pgcod
             and a.aqpa357itsuc = ln_itsuc
             and a.aqpa357itmod = ln_itmod
             and a.aqpa357ittran = ln_ittran
             and a.aqpa357itnrel = ln_itnrel
             and a.aqpa357itord = ln_itord
             and a.aqpa357itsbor = ln_itsbor
             and a.aqpa357fec = ld_fecpro
             and a.AQPA357est = lc_estado;
          commit;
        end;
      end if;
    
    end loop;
  
    for lg in linea_vigente(lc_estado) loop
    
      PQ_CR_RATIO_EVALFLUJO.Sp_Adicional_CK(pn_mod  => LG.LN_MOD,
                                            pn_top  => LG.LN_TOPE,
                                            Pc_flag => LC_VerfAdi);
    
      if LC_VerfAdi = 'N' then
      
        begin
          pq_cr_resolutor_cappago.sp_capacidadlinea(lg.ln_mod,
                                                    lg.ln_suc,
                                                    lg.ln_mda,
                                                    lg.ln_pap,
                                                    lg.ln_cta,
                                                    lg.ln_ope,
                                                    lg.ln_sbop,
                                                    lg.ln_tope,
                                                    lg.ln_tipcamb,
                                                    ln_MntCuoMesAux);
          ln_MntCuoMesAux := nvl(ln_MntCuoMesAux, 0);
          ln_MntCuoMes    := ln_MntCuoMesAux * NroCreOtorg;
          ln_MntCuoMes    := nvl(ln_MntCuoMes, 0);
        
        end;
      
      else
        if LC_VerfAdi = 'S' then
        
          PQ_CR_RATIO_EVALFLUJO.sp_CapLineaAdicional(ln_mod10        => lg.ln_mod,
                                                     ln_suc10        => lg.ln_suc,
                                                     ln_mda10        => lg.ln_mda,
                                                     ln_pap10        => lg.ln_pap,
                                                     ln_cta10        => lg.ln_cta,
                                                     ln_oper10       => lg.ln_ope,
                                                     ln_sbop10       => lg.ln_sbop,
                                                     ln_tope10       => lg.ln_tope,
                                                     tipocambio      => lg.ln_tipcamb,
                                                     ln_plazo        => ln_MaxPlazAdi,
                                                     ln_CapAdicional => ln_CuoCapAdi);
        end if;
      end if;
    
      begin
        select a.AQPA358fecal
          into ld_FchCalend
          from AQPA358 a
         where a.AQPA358instl = ln_Instancia
           and a.aqpa358pgcod = ln_pgcod
           and a.aqpa358itsuc = ln_itsuc
           and a.aqpa358itmod = ln_itmod
           and a.aqpa358ittran = ln_ittran
           and a.aqpa358itnrel = ln_itnrel
           and a.aqpa358itord = ln_itord
           and a.aqpa358itsbor = ln_itsbor
           and a.aqpa358fec = ld_fecpro
           and a.AQPA358corr = ln_MaxPlazAdi + 1
           and a.AQPA358est = lc_estado;
      exception
        when others then
          null;
      end;
    
      if ld_FchCalend = ld_FchFin then
        begin
          update AQPA357 a
             set a.AQPA357naux3 = ln_CuoCapAdi
           where a.AQPA357pgcod = lg.ln_pgcod
             and a.AQPA357mod = lg.ln_mod
             and a.AQPA357suc = lg.ln_suc
             and a.AQPA357mda = lg.ln_mda
             and a.AQPA357pap = lg.ln_pap
             and a.AQPA357cta = lg.ln_cta
             and a.AQPA357ope = lg.ln_ope
             and a.AQPA357sbop = lg.ln_sbop
             and a.AQPA357tope = lg.ln_tope
             and a.AQPA357instl = ln_Instancia
             and a.aqpa357pgcod = ln_pgcod
             and a.aqpa357itsuc = ln_itsuc
             and a.aqpa357itmod = ln_itmod
             and a.aqpa357ittran = ln_ittran
             and a.aqpa357itnrel = ln_itnrel
             and a.aqpa357itord = ln_itord
             and a.aqpa357itsbor = ln_itsbor
             and a.aqpa357fec = ld_fecpro
             and a.AQPA357est = lc_estado;
          commit;
        end;
      end if;
    
    end loop;
  
    for lc in linea_vencida(lc_estado) loop
    
      PQ_CR_RATIO_EVALFLUJO.sp_cr_CalCuota(lc.ln_pgcod,
                                           lc.ln_mod,
                                           lc.ln_suc,
                                           lc.ln_mda,
                                           lc.ln_pap,
                                           lc.ln_cta,
                                           lc.ln_ope,
                                           lc.ln_sbop,
                                           lc.ln_tope,
                                           ld_FchIni,
                                           ld_FchFin,
                                           lc.ln_tipcamb,
                                           ln_NroCuot,
                                           ln_MntCuoMes);
    
      begin
        update AQPA357 a
           set a.AQPA357naux1 = ln_MntCuoMes
         where a.AQPA357pgcod = lc.ln_pgcod
           and a.AQPA357mod = lc.ln_mod
           and a.AQPA357suc = lc.ln_suc
           and a.AQPA357mda = lc.ln_mda
           and a.AQPA357pap = lc.ln_pap
           and a.AQPA357cta = lc.ln_cta
           and a.AQPA357ope = lc.ln_ope
           and a.AQPA357sbop = lc.ln_sbop
           and a.AQPA357tope = lc.ln_tope
           and a.AQPA357instl = ln_Instancia
           and a.aqpa357pgcod = ln_pgcod
           and a.aqpa357itsuc = ln_itsuc
           and a.aqpa357itmod = ln_itmod
           and a.aqpa357ittran = ln_ittran
           and a.aqpa357itnrel = ln_itnrel
           and a.aqpa357itord = ln_itord
           and a.aqpa357itsbor = ln_itsbor
           and a.aqpa357fec = ld_fecpro
           and a.AQPA357est = lc_estado;
        commit;
      end;
    
    end loop;
  
    for cp in credito_parcial(lc_estado) loop
      PQ_CR_RATIO_EVALFLUJO.sp_cr_VerfDesmbPendiente(cp.ln_pgcod,
                                                     cp.ln_mod,
                                                     cp.ln_suc,
                                                     cp.ln_mda,
                                                     cp.ln_pap,
                                                     cp.ln_cta,
                                                     cp.ln_ope,
                                                     cp.ln_sbop,
                                                     cp.ln_tope,
                                                     lc_VerfDesembPendt,
                                                     ln_NroDesemblsPact,
                                                     ln_DesembHechos);
    
      if lc_VerfDesembPendt = 'P' then
        -- Con Desembolso Pendiente    
      
        PQ_CR_RATIO_EVALFLUJO.sp_Cr_CalcParcialPend(cp.ln_pgcod,
                                                    cp.ln_mod,
                                                    cp.ln_suc,
                                                    cp.ln_mda,
                                                    cp.ln_pap,
                                                    cp.ln_cta,
                                                    cp.ln_ope,
                                                    cp.ln_sbop,
                                                    cp.ln_tope,
                                                    ln_DesembHechos,
                                                    cp.ln_TipCamb,
                                                    ln_MntCuoMes);
      
        begin
          update AQPA357 a
             set a.AQPA357naux1 = ln_MntCuoMes
           where a.AQPA357pgcod = cp.ln_pgcod
             and a.AQPA357mod = cp.ln_mod
             and a.AQPA357suc = cp.ln_suc
             and a.AQPA357mda = cp.ln_mda
             and a.AQPA357pap = cp.ln_pap
             and a.AQPA357cta = cp.ln_cta
             and a.AQPA357ope = cp.ln_ope
             and a.AQPA357sbop = cp.ln_sbop
             and a.AQPA357tope = cp.ln_tope
             and a.AQPA357instl = ln_Instancia
             and a.aqpa357pgcod = ln_pgcod
             and a.aqpa357itsuc = ln_itsuc
             and a.aqpa357itmod = ln_itmod
             and a.aqpa357ittran = ln_ittran
             and a.aqpa357itnrel = ln_itnrel
             and a.aqpa357itord = ln_itord
             and a.aqpa357itsbor = ln_itsbor
             and a.aqpa357fec = ld_fecpro
             and a.AQPA357est = lc_estado;
          commit;
        end;
      
      else
        if lc_VerfDesembPendt = 'T' then
          -- Con Desembolso Total  
        
          PQ_CR_RATIO_EVALFLUJO.sp_cr_CalCuota(cp.ln_pgcod,
                                               cp.ln_mod,
                                               cp.ln_suc,
                                               cp.ln_mda,
                                               cp.ln_pap,
                                               cp.ln_cta,
                                               cp.ln_ope,
                                               cp.ln_sbop,
                                               cp.ln_tope,
                                               ld_FchIni,
                                               ld_FchFin,
                                               cp.ln_TipCamb,
                                               ln_NroCuot,
                                               ln_MntCuoMes);
        
          begin
            update AQPA357 a
               set a.AQPA357naux1 = ln_MntCuoMes
             where a.AQPA357pgcod = cp.ln_pgcod
               and a.AQPA357mod = cp.ln_mod
               and a.AQPA357suc = cp.ln_suc
               and a.AQPA357mda = cp.ln_mda
               and a.AQPA357pap = cp.ln_pap
               and a.AQPA357cta = cp.ln_cta
               and a.AQPA357ope = cp.ln_ope
               and a.AQPA357sbop = cp.ln_sbop
               and a.AQPA357tope = cp.ln_tope
               and a.AQPA357instl = ln_Instancia
               and a.aqpa357pgcod = ln_pgcod
               and a.aqpa357itsuc = ln_itsuc
               and a.aqpa357itmod = ln_itmod
               and a.aqpa357ittran = ln_ittran
               and a.aqpa357itnrel = ln_itnrel
               and a.aqpa357itord = ln_itord
               and a.aqpa357itsbor = ln_itsbor
               and a.aqpa357fec = ld_fecpro
               and a.AQPA357est = lc_estado;
            commit;
          end;
        
        end if;
      end if;
    end loop;
  
    for pv in Lista_ParcVuelo(lc_estado) loop
    
      PQ_CR_RATIO_EVALFLUJO.sp_cr_CalCuota(pv.ln_pgcod,
                                           pv.ln_mod,
                                           pv.ln_suc,
                                           pv.ln_mda,
                                           pv.ln_pap,
                                           pv.ln_cta,
                                           pv.ln_ope,
                                           pv.ln_sbop,
                                           pv.ln_tope,
                                           ld_FchIni,
                                           ld_FchFin,
                                           pv.ln_tipcamb,
                                           ln_NroCuot,
                                           ln_MntCuoMes);
    
      begin
        update AQPA357 a
           set a.AQPA357naux1 = ln_MntCuoMes
         where a.AQPA357pgcod = pv.ln_pgcod
           and a.AQPA357mod = pv.ln_mod
           and a.AQPA357suc = pv.ln_suc
           and a.AQPA357mda = pv.ln_mda
           and a.AQPA357pap = pv.ln_pap
           and a.AQPA357cta = pv.ln_cta
           and a.AQPA357ope = pv.ln_ope
           and a.AQPA357sbop = pv.ln_sbop
           and a.AQPA357tope = pv.ln_tope
           and a.AQPA357instl = ln_Instancia
           and a.aqpa357pgcod = ln_pgcod
           and a.aqpa357itsuc = ln_itsuc
           and a.aqpa357itmod = ln_itmod
           and a.aqpa357ittran = ln_ittran
           and a.aqpa357itnrel = ln_itnrel
           and a.aqpa357itord = ln_itord
           and a.aqpa357itsbor = ln_itsbor
           and a.aqpa357fec = ld_fecpro
           and a.AQPA357est = lc_estado;
        commit;
      end;
    end loop;
  
    for d in Linea_Disponer(lc_estado) loop
    
      begin
        select sum(f.ppcap + f.ppint)
          into ln_CapIntMnsl
          from fsd601 f
         where f.pgcod = d.ln_pgcod
           and f.ppmod = d.ln_mod
           and f.ppsuc = d.ln_suc
           and f.ppmda = d.ln_mda
           and f.pppap = d.ln_pap
           and f.ppcta = d.ln_cta
           and f.ppoper = d.ln_ope
           and f.ppsbop = d.ln_sbop
           and f.pptope = d.ln_tope
           and f.ppfpag between ld_FchIni and ld_FchFin
           and f.d601co = 'E';
      exception
        when others then
          ln_CapIntMnsl := 0.00;
      end;
    
      ln_CapIntMnsl := nvl(ln_CapIntMnsl, 0);
    
      begin
        select sum(f.ppimp11 + f.ppimp12 + f.ppimp13 + f.ppimp14 +
                   f.ppimp15)
          into ln_IntMnsl
          from fsd611 f
         where f.pgcod = d.ln_pgcod
           and f.ppmod = d.ln_mod
           and f.ppsuc = d.ln_suc
           and f.ppmda = d.ln_mda
           and f.pppap = d.ln_pap
           and f.ppcta = d.ln_cta
           and f.ppoper = d.ln_ope
           and f.ppsbop = d.ln_sbop
           and f.pptope = d.ln_tope
           and f.ppfpag between ld_FchIni and ld_FchFin;
      exception
        when others then
          ln_IntMnsl := 0.00;
      end;
    
      ln_IntMnsl  := nvl(ln_IntMnsl, 0);
      ln_MntCuota := ln_CapIntMnsl + ln_IntMnsl;
      ln_MntCuota := nvl(ln_MntCuota, 0);
    
      begin
        update AQPA357 a
           set a.AQPA357naux1 = ln_MntCuota
         where a.AQPA357pgcod = d.ln_pgcod
           and a.AQPA357mod = d.ln_mod
           and a.AQPA357suc = d.ln_suc
           and a.AQPA357mda = d.ln_mda
           and a.AQPA357pap = d.ln_pap
           and a.AQPA357cta = d.ln_cta
           and a.AQPA357ope = d.ln_ope
           and a.AQPA357sbop = d.ln_sbop
           and a.AQPA357tope = d.ln_tope
           and a.AQPA357instl = ln_Instancia
           and a.aqpa357pgcod = ln_pgcod
           and a.aqpa357itsuc = ln_itsuc
           and a.aqpa357itmod = ln_itmod
           and a.aqpa357ittran = ln_ittran
           and a.aqpa357itnrel = ln_itnrel
           and a.aqpa357itord = ln_itord
           and a.aqpa357itsbor = ln_itsbor
           and a.aqpa357fec = ld_fecpro
           and a.AQPA357est = lc_estado;
        commit;
      end;
    
    end loop;
  
  end sp_cr_ActMntCuota;
  ------------------------------------------------------------------------------
  procedure sp_cr_CuotaContinCF(ln_Instancia    in number,
                                ln_InstEval     in number,
                                ld_fchEval      in date,
                                ln_pgcod        in number,
                                ln_itsuc        in number,
                                ln_itmod        in number,
                                ln_ittran       in number,
                                ln_itnrel       in number,
                                ln_itord        in number,
                                ln_itsbor       in number,
                                pd_fecpro       in date,
                                lc_Usuario      in varchar2,
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
         and d10.Aocta in (select Ctnro
                             from sng001 s, fsr008 f
                            where s.sng001inst = ln_Instancia
                              and s.sng001pais = f.pepais
                              and s.sng001tdoc = f.Petdoc
                              and s.sng001ndoc = f.pendoc
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
         and x.xwfcuenta in (select Ctnro
                               from sng001 s, fsr008 f
                              where s.sng001inst = ln_Instancia
                                and s.sng001pais = f.pepais
                                and s.sng001tdoc = f.Petdoc
                                and s.sng001ndoc = f.pendoc
                                and cttfir = 'T')
            
         and x.xwfmodulo = 141
         and x.XWFPRCINS = w.wfinsprcid
         and w.wfitemstsact = 1
         and x.xwfcar3 = '1';
  
    ln_pais          number;
    ln_tdoc          number;
    lc_ndoc          number;
    ln_CuotCntgAux   number;
    ln_SaldCap       number;
    ln_tipocambio    number;
    ld_MinFchCred    date;
    ld_MinFchCredAux date;
    ln_InstCred      number;
    ln_TipoOri       number;
    ln_NroCuot       number;
  
  begin
    ln_MntCuoCntgCF := 0;
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_pais, ln_tdoc, lc_ndoc
        from sng001 s
       where s.sng001inst = ln_Instancia;
    exception
      when others then
        null;
    end;
  
    begin
      select s. sng120tcbi
        into ln_tipocambio
        from sng120 s
       where s.sng120ins = ln_Instancia
         and s.sng120tsk = 'EVALUACION';
    exception
      when others then
        ln_tipocambio := 0;
    end;
  
    begin
      select min(F.PPFPAG)
        into ld_MinFchCredAux
        from xwf700 x, fsd601 f
       where x.xwfprcins = ln_Instancia
         and x.xwfempresa = f.pgcod
         and x.xwfsucursal = f.ppsuc
         and x.xwfmodulo = f.ppmod
         and x.xwfmoneda = f.ppmda
         and x.xwfpapel = f.pppap
         and x.xwfcuenta = f.ppcta
         and x.xwfoperacion = f.ppoper
         and x.xwfsubope = f.ppsbop
         and x.xwftipope = f.pptope
         and x.xwfcar3 = '1'
         and f.d601co = 'X';
    exception
      when others then
        null;
    end;
  
    begin
      ld_MinFchCred := ADD_MONTHS(last_Day(ld_fchEval), -1) + 1;
    end;
  
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
      
        ln_CuotCntgAux := (ln_SaldCap * 2.34) / 100; -- mpostigoc 04/08/2022.
      
        begin
        
          ln_InstCred := fn_instancia_credito(l.ln_mod10,
                                              l.ln_suc10,
                                              l.ln_mda10,
                                              l.ln_pap10,
                                              l.ln_cta10,
                                              l.ln_oper10,
                                              l.ln_sbop10,
                                              l.ln_tope10);
        
          PQ_CR_RATIO_EVALFLUJO.sp_cr_TipoSolicitud(ln_InstCred,
                                                    ln_TipoOri);
        
          PQ_CR_RATIO_EVALFLUJO.sp_cr_NroCuOPreseteo(l.ln_pgcod10,
                                                     l.ln_mod10,
                                                     l.ln_suc10,
                                                     l.ln_mda10,
                                                     l.ln_pap10,
                                                     l.ln_cta10,
                                                     l.ln_oper10,
                                                     l.ln_sbop10,
                                                     l.ln_tope10,
                                                     -- ln_InstCred,
                                                     ln_NroCuot);
        
          PQ_CR_RATIO_EVALFLUJO_RTE.sp_cr_LogCuentas(ld_fec     => pd_fecpro,
                                                     lc_user    => lc_Usuario,
                                                     ln_pais    => ln_pais,
                                                     ln_tdoc    => ln_tdoc,
                                                     ln_ndoc    => lc_ndoc,
                                                     ln_tcamb   => ln_tipocambio,
                                                     ln_instl   => ln_Instancia,
                                                     ln_inste   => ln_InstEval,
                                                     ln_pgcod   => ln_pgcod,
                                                     ln_itsuc   => ln_itsuc,
                                                     ln_itmod   => ln_itmod,
                                                     ln_ittran  => ln_ittran,
                                                     ln_itnrel  => ln_itnrel,
                                                     ln_itord   => ln_itord,
                                                     ln_itsbor  => ln_itsbor,
                                                     ld_feval   => ld_fchEval,
                                                     ld_fical   => ld_MinFchCred,
                                                     ln_emp     => l.ln_pgcod10,
                                                     ln_mod     => l.ln_mod10,
                                                     ln_suc     => l.ln_suc10,
                                                     ln_mda     => l.ln_mda10,
                                                     ln_pap     => l.ln_pap10,
                                                     ln_cta     => l.ln_cta10,
                                                     ln_ope     => l.ln_oper10,
                                                     ln_sbop    => l.ln_sbop10,
                                                     ln_tope    => l.ln_tope10,
                                                     ln_TipoOri => ln_TipoOri,
                                                     ln_NroCuot => ln_NroCuot,
                                                     lc_IndCred => 'CredVgntCF',
                                                     ln_SaldCap => ln_SaldCap,
                                                     ln_monto   => ln_CuotCntgAux);
        
        end;
      
        ln_MntCuoCntgCF := ln_MntCuoCntgCF + ln_CuotCntgAux;
      
      end loop;
    
      for v in lista_CredvueloCF(ln_pais, ln_tdoc, lc_ndoc) loop
      
        begin
          select w.xwfmonto1
            into ln_SaldCap
            from xwf700 w
           where w.xwfprcins = v.ln_InstAvalada
             and w.xwfcar3 = '1';
        exception
          when others then
            ln_SaldCap := 0;
        end;
      
        if v.ln_mda10 = 101 then
        
          ln_SaldCap := ln_SaldCap * ln_tipocambio;
        
        end if;
      
        ln_CuotCntgAux := (ln_SaldCap * 2.34) / 100; -- mpostigoc 04/08/2022.
      
        begin
        
          ln_InstCred := fn_instancia_credito(v.ln_mod10,
                                              v.ln_suc10,
                                              v.ln_mda10,
                                              v.ln_pap10,
                                              v.ln_cta10,
                                              v.ln_oper10,
                                              v.ln_sbop10,
                                              v.ln_tope10);
        
          PQ_CR_RATIO_EVALFLUJO.sp_cr_TipoSolicitud(ln_InstCred,
                                                    ln_TipoOri);
        
          PQ_CR_RATIO_EVALFLUJO.sp_cr_NroCuOPreseteo(v.ln_pgcod10,
                                                     v.ln_mod10,
                                                     v.ln_suc10,
                                                     v.ln_mda10,
                                                     v.ln_pap10,
                                                     v.ln_cta10,
                                                     v.ln_oper10,
                                                     v.ln_sbop10,
                                                     v.ln_tope10,
                                                     -- ln_InstCred,
                                                     ln_NroCuot);
        
          PQ_CR_RATIO_EVALFLUJO_RTE.sp_cr_LogCuentas(ld_fec     => pd_fecpro,
                                                     lc_user    => lc_Usuario,
                                                     ln_pais    => ln_pais,
                                                     ln_tdoc    => ln_tdoc,
                                                     ln_ndoc    => lc_ndoc,
                                                     ln_tcamb   => ln_tipocambio,
                                                     ln_instl   => ln_Instancia,
                                                     ln_inste   => ln_InstEval,
                                                     ln_pgcod   => ln_pgcod,
                                                     ln_itsuc   => ln_itsuc,
                                                     ln_itmod   => ln_itmod,
                                                     ln_ittran  => ln_ittran,
                                                     ln_itnrel  => ln_itnrel,
                                                     ln_itord   => ln_itord,
                                                     ln_itsbor  => ln_itsbor,
                                                     ld_feval   => ld_fchEval,
                                                     ld_fical   => ld_MinFchCred,
                                                     ln_emp     => v.ln_pgcod10,
                                                     ln_mod     => v.ln_mod10,
                                                     ln_suc     => v.ln_suc10,
                                                     ln_mda     => v.ln_mda10,
                                                     ln_pap     => v.ln_pap10,
                                                     ln_cta     => v.ln_cta10,
                                                     ln_ope     => v.ln_oper10,
                                                     ln_sbop    => v.ln_sbop10,
                                                     ln_tope    => v.ln_tope10,
                                                     ln_TipoOri => ln_TipoOri,
                                                     ln_NroCuot => ln_NroCuot,
                                                     lc_IndCred => 'CredVuelCF',
                                                     ln_SaldCap => ln_SaldCap,
                                                     ln_monto   => ln_CuotCntgAux);
        
        end;
      
        ln_MntCuoCntgCF := ln_MntCuoCntgCF + ln_CuotCntgAux;
      
      end loop;
    
    end if;
  
  end sp_cr_CuotaContinCF;
  --------------------------------------------------------------------------------
  procedure sp_cr_CuotaContinAval(ln_Instancia      in number,
                                  ln_InstEval       in number,
                                  ld_fchEval        in date,
                                  ln_pgcod          in number,
                                  ln_itsuc          in number,
                                  ln_itmod          in number,
                                  ln_ittran         in number,
                                  ln_itnrel         in number,
                                  ln_itord          in number,
                                  ln_itsbor         in number,
                                  pd_fecpro         in date,
                                  lc_Usuario        in varchar2,
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
         and x.xwfmodulo in
             (select k.modulo
                from fst111 k
               where k.dscod = 50
                 and k.modulo not in (33, 200))
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
         and x.xwfmodulo in
             (select k.modulo
                from fst111 k
               where k.dscod = 50
                 and k.modulo not in (33, 200))
         and w.wfitemstsact = 1;
  
    ln_pais          number;
    ln_tdoc          number;
    lc_ndoc          varchar2(12);
    ln_paiscy        number;
    ln_tdoccy        number;
    lc_ndoccy        varchar2(12);
    ln_CuotCntgAux   number;
    ln_SaldCap       number;
    ln_tipocambio    number;
    ld_MinFchCred    date;
    ld_MinFchCredAux date;
    ln_InstCred      number;
    ln_TipoOri       number;
    ln_NroCuot       number;
    ln_EsConsd       number;
  
  begin
    ln_MntCuoCntgAval := 0;
  
    begin
      -- Datos del Titular
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_pais, ln_tdoc, lc_ndoc
        from sng001 s
       where s.sng001inst = ln_Instancia;
    exception
      when others then
        null;
    end;
  
    begin
      --- Datos del Cnyuge
      select f.rppais, f.rptdoc, f.rpndoc
        into ln_paiscy, ln_tdoccy, lc_ndoccy
        from fsr002 f
       where f.pepais = ln_pais
         and f.petdoc = ln_tdoc
         and f.pendoc = lc_ndoc
         and f.rpccyg = 66;
    exception
      when no_data_found then
        begin
          select f.rppais, f.rptdoc, f.rpndoc
            into ln_paiscy, ln_tdoccy, lc_ndoccy
            from fsr002 f
           where f.rppais = ln_pais
             and f.rptdoc = ln_tdoc
             and f.rpndoc = lc_ndoc
             and f.rpccyg = 66;
        exception
          when others then
            null;
        end;
      when others then
        null;
      
    end;
  
    begin
      select s. sng120tcbi
        into ln_tipocambio
        from sng120 s
       where s.sng120ins = ln_Instancia
         and s.sng120tsk = 'EVALUACION';
    exception
      when others then
        ln_tipocambio := 0;
    end;
  
    begin
      select min(F.PPFPAG)
        into ld_MinFchCredAux
        from xwf700 x, fsd601 f
       where x.xwfprcins = ln_Instancia
         and x.xwfempresa = f.pgcod
         and x.xwfsucursal = f.ppsuc
         and x.xwfmodulo = f.ppmod
         and x.xwfmoneda = f.ppmda
         and x.xwfpapel = f.pppap
         and x.xwfcuenta = f.ppcta
         and x.xwfoperacion = f.ppoper
         and x.xwfsubope = f.ppsbop
         and x.xwftipope = f.pptope
         and x.xwfcar3 = '1'
         and f.d601co = 'X';
    exception
      when others then
        null;
    end;
  
    begin
      ld_MinFchCred := ADD_MONTHS(last_Day(ld_MinFchCredAux), -1) + 1;
    end;
  
    if ln_pais is not null then
    
      for l in lista_CredVigAval(ln_pais, ln_tdoc, lc_ndoc) loop
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
      
        ln_CuotCntgAux := (ln_SaldCap * 2.34) / 100; -- mpostigoc 04/08/2022.
      
        -- if (lc_flgprg = 'S' or lc_flgprg = 'R') and lc_EjecRatio = 'S' then
        begin
        
          ln_InstCred := fn_instancia_credito(l.ln_mod10,
                                              l.ln_suc10,
                                              l.ln_mda10,
                                              l.ln_pap10,
                                              l.ln_cta10,
                                              l.ln_oper10,
                                              l.ln_sbop10,
                                              l.ln_tope10);
        
          PQ_CR_RATIO_EVALFLUJO.sp_cr_TipoSolicitud(ln_InstCred,
                                                    ln_TipoOri);
        
          PQ_CR_RATIO_EVALFLUJO.sp_cr_NroCuOPreseteo(l.ln_pgcod10,
                                                     l.ln_mod10,
                                                     l.ln_suc10,
                                                     l.ln_mda10,
                                                     l.ln_pap10,
                                                     l.ln_cta10,
                                                     l.ln_oper10,
                                                     l.ln_sbop10,
                                                     l.ln_tope10,
                                                     --  ln_InstCred,
                                                     ln_NroCuot);
        
          PQ_CR_RATIO_EVALFLUJO_RTE.sp_cr_LogCuentas(ld_fec     => pd_fecpro,
                                                     lc_user    => lc_Usuario,
                                                     ln_pais    => ln_pais,
                                                     ln_tdoc    => ln_tdoc,
                                                     ln_ndoc    => lc_ndoc,
                                                     ln_tcamb   => ln_tipocambio,
                                                     ln_instl   => ln_Instancia,
                                                     ln_inste   => ln_InstEval,
                                                     ln_pgcod   => ln_pgcod,
                                                     ln_itsuc   => ln_itsuc,
                                                     ln_itmod   => ln_itmod,
                                                     ln_ittran  => ln_ittran,
                                                     ln_itnrel  => ln_itnrel,
                                                     ln_itord   => ln_itord,
                                                     ln_itsbor  => ln_itsbor,
                                                     ld_feval   => ld_fchEval,
                                                     ld_fical   => ld_MinFchCred,
                                                     ln_emp     => l.ln_pgcod10,
                                                     ln_mod     => l.ln_mod10,
                                                     ln_suc     => l.ln_suc10,
                                                     ln_mda     => l.ln_mda10,
                                                     ln_pap     => l.ln_pap10,
                                                     ln_cta     => l.ln_cta10,
                                                     ln_ope     => l.ln_oper10,
                                                     ln_sbop    => l.ln_sbop10,
                                                     ln_tope    => l.ln_tope10,
                                                     ln_TipoOri => ln_TipoOri,
                                                     ln_NroCuot => ln_NroCuot,
                                                     lc_IndCred => 'CredVgnAvl',
                                                     ln_SaldCap => ln_SaldCap,
                                                     ln_monto   => ln_CuotCntgAux);
        
        end;
        -- end if;
      
        ln_MntCuoCntgAval := ln_MntCuoCntgAval + ln_CuotCntgAux;
      
      end loop;
    
      for v in lista_CredvueloAval(ln_pais, ln_tdoc, lc_ndoc) loop
        ln_SaldCap := 0;
      
        begin
          select w.xwfmonto1
            into ln_SaldCap
            from xwf700 w
           where w.xwfprcins = v.ln_InstanciaAvalada
             and w.xwfcar3 = '1';
        exception
          when others then
            ln_SaldCap := 0;
        end;
        if v.ln_mda10 = 101 then
          ln_SaldCap := ln_SaldCap * ln_tipocambio;
        end if;
      
        ln_CuotCntgAux := (ln_SaldCap * 2.34) / 100; -- mpostigoc 04/08/2022.
      
        -- if (lc_flgprg = 'S' or lc_flgprg = 'R') and lc_EjecRatio = 'S' then
        begin
          ln_InstCred := fn_instancia_credito(v.ln_mod10,
                                              v.ln_suc10,
                                              v.ln_mda10,
                                              v.ln_pap10,
                                              v.ln_cta10,
                                              v.ln_oper10,
                                              v.ln_sbop10,
                                              v.ln_tope10);
        
          PQ_CR_RATIO_EVALFLUJO.sp_cr_TipoSolicitud(ln_InstCred,
                                                    ln_TipoOri);
        
          PQ_CR_RATIO_EVALFLUJO.sp_cr_NroCuOPreseteo(v.ln_pgcod10,
                                                     v.ln_mod10,
                                                     v.ln_suc10,
                                                     v.ln_mda10,
                                                     v.ln_pap10,
                                                     v.ln_cta10,
                                                     v.ln_oper10,
                                                     v.ln_sbop10,
                                                     v.ln_tope10,
                                                     --ln_InstCred,
                                                     ln_NroCuot);
        
          PQ_CR_RATIO_EVALFLUJO_RTE.sp_cr_LogCuentas(ld_fec     => pd_fecpro,
                                                     lc_user    => lc_Usuario,
                                                     ln_pais    => ln_pais,
                                                     ln_tdoc    => ln_tdoc,
                                                     ln_ndoc    => lc_ndoc,
                                                     ln_tcamb   => ln_tipocambio,
                                                     ln_instl   => ln_Instancia,
                                                     ln_inste   => ln_InstEval,
                                                     ln_pgcod   => ln_pgcod,
                                                     ln_itsuc   => ln_itsuc,
                                                     ln_itmod   => ln_itmod,
                                                     ln_ittran  => ln_ittran,
                                                     ln_itnrel  => ln_itnrel,
                                                     ln_itord   => ln_itord,
                                                     ln_itsbor  => ln_itsbor,
                                                     ld_feval   => ld_fchEval,
                                                     ld_fical   => ld_MinFchCred,
                                                     ln_emp     => v.ln_pgcod10,
                                                     ln_mod     => v.ln_mod10,
                                                     ln_suc     => v.ln_suc10,
                                                     ln_mda     => v.ln_mda10,
                                                     ln_pap     => v.ln_pap10,
                                                     ln_cta     => v.ln_cta10,
                                                     ln_ope     => v.ln_oper10,
                                                     ln_sbop    => v.ln_sbop10,
                                                     ln_tope    => v.ln_tope10,
                                                     ln_TipoOri => ln_TipoOri,
                                                     ln_NroCuot => ln_NroCuot,
                                                     lc_IndCred => 'CredVlAval',
                                                     ln_SaldCap => ln_SaldCap,
                                                     ln_monto   => ln_CuotCntgAux);
        
        end;
      
        ln_MntCuoCntgAval := ln_MntCuoCntgAval + ln_CuotCntgAux;
      
      end loop;
    
    end if;
  
    if ln_paiscy is not null then
      for l in lista_CredVigAval(ln_paiscy, ln_tdoccy, lc_ndoccy) loop
      
        begin
          select count(*)
            into ln_EsConsd
            from AQPA357 j
           where j.AQPA357pgcod = l.ln_pgcod10
             and j.AQPA357mod = l.ln_mod10
             and j.AQPA357suc = l.ln_suc10
             and j.AQPA357mda = l.ln_mda10
             and j.AQPA357pap = l.ln_pap10
             and j.AQPA357cta = l.ln_cta10
             and j.AQPA357ope = l.ln_oper10
             and j.AQPA357sbop = l.ln_sbop10
             and j.AQPA357tope = l.ln_tope10
             and j.AQPA357instl = ln_Instancia
             and j.aqpa357pgcod = ln_pgcod
             and j.aqpa357itsuc = ln_itsuc
             and j.aqpa357itmod = ln_itmod
             and j.aqpa357ittran = ln_ittran
             and j.aqpa357itnrel = ln_itnrel
             and j.aqpa357itord = ln_itord
             and j.aqpa357itsbor = ln_itsbor;
        end;
      
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
      
        ln_CuotCntgAux := (ln_SaldCap * 2.34) / 100; -- mpostigoc 04/08/2022.
      
        begin
        
          ln_InstCred := fn_instancia_credito(l.ln_mod10,
                                              l.ln_suc10,
                                              l.ln_mda10,
                                              l.ln_pap10,
                                              l.ln_cta10,
                                              l.ln_oper10,
                                              l.ln_sbop10,
                                              l.ln_tope10);
        
          PQ_CR_RATIO_EVALFLUJO.sp_cr_TipoSolicitud(ln_InstCred,
                                                    ln_TipoOri);
        
          PQ_CR_RATIO_EVALFLUJO.sp_cr_NroCuOPreseteo(l.ln_pgcod10,
                                                     l.ln_mod10,
                                                     l.ln_suc10,
                                                     l.ln_mda10,
                                                     l.ln_pap10,
                                                     l.ln_cta10,
                                                     l.ln_oper10,
                                                     l.ln_sbop10,
                                                     l.ln_tope10,
                                                     -- ln_InstCred,
                                                     ln_NroCuot);
        
          PQ_CR_RATIO_EVALFLUJO_RTE.sp_cr_LogCuentas(ld_fec     => pd_fecpro,
                                                     lc_user    => lc_Usuario,
                                                     ln_pais    => ln_pais,
                                                     ln_tdoc    => ln_tdoc,
                                                     ln_ndoc    => lc_ndoc,
                                                     ln_tcamb   => ln_tipocambio,
                                                     ln_instl   => ln_Instancia,
                                                     ln_inste   => ln_InstEval,
                                                     ln_pgcod   => ln_pgcod,
                                                     ln_itsuc   => ln_itsuc,
                                                     ln_itmod   => ln_itmod,
                                                     ln_ittran  => ln_ittran,
                                                     ln_itnrel  => ln_itnrel,
                                                     ln_itord   => ln_itord,
                                                     ln_itsbor  => ln_itsbor,
                                                     ld_feval   => ld_fchEval,
                                                     ld_fical   => ld_MinFchCred,
                                                     ln_emp     => l.ln_pgcod10,
                                                     ln_mod     => l.ln_mod10,
                                                     ln_suc     => l.ln_suc10,
                                                     ln_mda     => l.ln_mda10,
                                                     ln_pap     => l.ln_pap10,
                                                     ln_cta     => l.ln_cta10,
                                                     ln_ope     => l.ln_oper10,
                                                     ln_sbop    => l.ln_sbop10,
                                                     ln_tope    => l.ln_tope10,
                                                     ln_TipoOri => ln_TipoOri,
                                                     ln_NroCuot => ln_NroCuot,
                                                     lc_IndCred => 'CredVgnAvl',
                                                     ln_SaldCap => ln_SaldCap,
                                                     ln_monto   => ln_CuotCntgAux);
        
        end;
      
        ln_MntCuoCntgAval := ln_MntCuoCntgAval + ln_CuotCntgAux;
      
      end loop;
    
      for v in lista_CredvueloAval(ln_paiscy, ln_tdoccy, lc_ndoccy) loop
      
        ln_SaldCap := 0;
      
        begin
          select w.xwfmonto1
            into ln_SaldCap
            from xwf700 w
           where w.xwfprcins = v.ln_InstanciaAvalada
             and w.xwfcar3 = '1';
        exception
          when others then
            ln_SaldCap := 0;
        end;
      
        if v.ln_mda10 = 101 then
          ln_SaldCap := ln_SaldCap * ln_tipocambio;
        end if;
      
        ln_CuotCntgAux := (ln_SaldCap * 2.34) / 100; -- mpostigoc 04/08/2022.
      
        -- if (lc_flgprg = 'S' or lc_flgprg = 'R') and lc_EjecRatio = 'S' then
        begin
          ln_InstCred := fn_instancia_credito(v.ln_mod10,
                                              v.ln_suc10,
                                              v.ln_mda10,
                                              v.ln_pap10,
                                              v.ln_cta10,
                                              v.ln_oper10,
                                              v.ln_sbop10,
                                              v.ln_tope10);
        
          PQ_CR_RATIO_EVALFLUJO.sp_cr_TipoSolicitud(ln_InstCred,
                                                    ln_TipoOri);
        
          PQ_CR_RATIO_EVALFLUJO.sp_cr_NroCuOPreseteo(v.ln_pgcod10,
                                                     v.ln_mod10,
                                                     v.ln_suc10,
                                                     v.ln_mda10,
                                                     v.ln_pap10,
                                                     v.ln_cta10,
                                                     v.ln_oper10,
                                                     v.ln_sbop10,
                                                     v.ln_tope10,
                                                     --  ln_InstCred,
                                                     ln_NroCuot);
          PQ_CR_RATIO_EVALFLUJO_RTE.sp_cr_LogCuentas(ld_fec     => pd_fecpro,
                                                     lc_user    => lc_Usuario,
                                                     ln_pais    => ln_pais,
                                                     ln_tdoc    => ln_tdoc,
                                                     ln_ndoc    => lc_ndoc,
                                                     ln_tcamb   => ln_tipocambio,
                                                     ln_instl   => ln_Instancia,
                                                     ln_inste   => ln_InstEval,
                                                     ln_pgcod   => ln_pgcod,
                                                     ln_itsuc   => ln_itsuc,
                                                     ln_itmod   => ln_itmod,
                                                     ln_ittran  => ln_ittran,
                                                     ln_itnrel  => ln_itnrel,
                                                     ln_itord   => ln_itord,
                                                     ln_itsbor  => ln_itsbor,
                                                     ld_feval   => ld_fchEval,
                                                     ld_fical   => ld_MinFchCred,
                                                     ln_emp     => v.ln_pgcod10,
                                                     ln_mod     => v.ln_mod10,
                                                     ln_suc     => v.ln_suc10,
                                                     ln_mda     => v.ln_mda10,
                                                     ln_pap     => v.ln_pap10,
                                                     ln_cta     => v.ln_cta10,
                                                     ln_ope     => v.ln_oper10,
                                                     ln_sbop    => v.ln_sbop10,
                                                     ln_tope    => v.ln_tope10,
                                                     ln_TipoOri => ln_TipoOri,
                                                     ln_NroCuot => ln_NroCuot,
                                                     lc_IndCred => 'CredVlAval',
                                                     ln_SaldCap => ln_SaldCap,
                                                     ln_monto   => ln_CuotCntgAux);
        end;
      
        --end if;
      
        ln_MntCuoCntgAval := ln_MntCuoCntgAval + ln_CuotCntgAux;
      
      end loop;
    end if;
  
  end sp_cr_CuotaContinAval;
  --------------------------------------------------------------------------------
  procedure sp_cr_CuotaPotencial(ln_Instancia   in number,
                                 ln_pgcod       in number,
                                 ln_itsuc       in number,
                                 ln_modulo      in number,
                                 ln_trans       in number,
                                 ln_rela        in number,
                                 ld_fcont       in date,
                                 lc_usuario     in varchar2,
                                 ln_MntPotncial out number) is
  
  begin
  
    -- Call the procedure
    pq_cr_cuotapoten.sp_cr_tarjetascredito(ln_instancia => ln_instancia,
                                           ln_pgcod     => ln_pgcod,
                                           ln_itsuc     => ln_itsuc,
                                           ln_modulo    => ln_modulo,
                                           ln_trans     => ln_trans,
                                           ln_rela      => ln_rela,
                                           ld_fcont     => ld_fcont,
                                           lc_usuario   => lc_usuario);
  
    begin
      select nvl(a.aqpa416cptn, 0)
        into ln_MntPotncial
        from aqpa416 a
       where a.aqpa416inst = ln_instancia
         and a.aqpa416pgcod = ln_pgcod
         and a.aqpa416itsuc = ln_itsuc
         and a.aqpa416itmod = ln_modulo
         and a.aqpa416ittra = ln_trans
         and a.aqpa416itnrel = ln_rela
         and a.aqpa416itfcon = ld_fcont;
    end;
  
    ln_MntPotncial := nvl(ln_MntPotncial, 0);
  
  end sp_cR_CuotaPotencial;
  -------------------------------------------------------------------------------
  procedure sp_cr_fchUltEval(ln_pgcod         in number,
                             ln_itsuc         in number,
                             ln_itmod         in number,
                             ln_ittran        in number,
                             ln_itnrel        in number,
                             ln_itord         in number,
                             ln_itsbor        in number,
                             ln_InstLinea     out number,
                             ld_fchevaluacion out date,
                             ln_InstEval      out number) is
  
    cursor lista_creditos(ln_pais number, ln_tdoc number, lc_ndoc varchar2) is
      select x.xwfempresa   ln_pgcod,
             x.xwfsucursal  ln_suc,
             x.xwfmodulo    ln_mod,
             x.xwfmoneda    ln_mda,
             x.xwfpapel     ln_pap,
             x.xwfcuenta    ln_cta,
             x.xwfoperacion ln_ope,
             x.xwfsubope    ln_sbop,
             x.xwftipope    ln_tope,
             x.xwfprcins    ln_InstAux
        from xwf700 x, fsd010 f, sng021 d
       where x.xwfprcins in (select s.sng001inst
                               from sng001 s
                              where s.sng001pais = ln_pais
                                and s.sng001tdoc = ln_tdoc
                                and s.sng001ndoc = lc_ndoc)
         and x.xwfempresa = f.pgcod
         and x.xwfsucursal = f.aosuc
         and x.xwfmodulo = f.aomod
         and x.xwfmoneda = f.aomda
         and x.xwfpapel = f.aopap
         and x.xwfcuenta = f.aocta
         and x.xwfoperacion = f.aooper
         and x.xwfsubope = f.aosbop
         and x.xwftipope = f.aotope
         and x.xwfcar3 = '1'
         and d.sng021sol = x.xwfprcins
         and d.sng021tmod = 13
       order by x.xwfprcins;
  
    ln_pais         number := 0;
    ln_tdoc         number := 0;
    lc_ndoc         varchar2(12);
    ld_MaxFchEva515 date;
    ln_EvalAux      number := 0;
    ln_Eval         number := 0;
    ln_InstaEva     number := 0;
    ln_Ins515       number := 0;
    ld_fcheval120   date;
    ln_pgcod116     number := 0;
    ln_mod116       number := 0;
    ln_tope116      number := 0;
    ln_suc116       number := 0;
    ln_mda116       number := 0;
    ln_pap116       number := 0;
    ln_cta116       number := 0;
    ln_oper116      number := 0;
    ln_sbop116      number := 0;
    ln_mod117       number := 0;
    ln_suc117       number := 0;
    ln_mda117       number := 0;
    ln_pap117       number := 0;
    ln_cta117       number := 0;
    ln_oper117      number := 0;
    ln_sbop117      number := 0;
    ln_tope117      number := 0;
  
  begin
  
    begin
      select f.pgcod,
             f.modulo,
             f.ittope,
             f.itsucd,
             f.moneda,
             f.papel,
             f.ctnro,
             f.itoper,
             f.itsubo
        into ln_pgcod116,
             ln_mod116,
             ln_tope116,
             ln_suc116,
             ln_mda116,
             ln_pap116,
             ln_cta116,
             ln_oper116,
             ln_sbop116
        from fsd016 f
       where f.pgcod = ln_pgcod
         and f.itsuc = ln_itsuc
         and f.itmod = ln_itmod
         and f.ittran = ln_ittran
         and f.itnrel = ln_itnrel
         and f.itord = ln_itord
         and f.itsbor = ln_itsbor;
    exception
      when others then
        ln_pgcod116 := 0;
        ln_mod116   := 0;
        ln_tope116  := 0;
        ln_suc116   := 0;
        ln_mda116   := 0;
        ln_pap116   := 0;
        ln_cta116   := 0;
        ln_oper116  := 0;
        ln_sbop116  := 0;
    end;
  
    begin
      select r2mod, r2suc, r2mda, r2pap, r2cta, r2oper, r2sbop, r2tope
        into ln_mod117,
             ln_suc117,
             ln_mda117,
             ln_pap117,
             ln_cta117,
             ln_oper117,
             ln_sbop117,
             ln_tope117
        from fsr011 f
       where f.r1cod = ln_pgcod116
         and f.r1mod = ln_mod116
         and f.r1suc = ln_suc116
         and f.r1cta = ln_cta116
         and f.r1oper = ln_oper116
         and f.r1sbop = ln_sbop116
         and f.r1mda = ln_mda116
         and f.r1pap = ln_pap116
         and f.r1tope = ln_tope116
         and f.relcod = 46;
    exception
      when others then
        ln_mod117  := 0;
        ln_suc117  := 0;
        ln_mda117  := 0;
        ln_pap117  := 0;
        ln_cta117  := 0;
        ln_oper117 := 0;
        ln_sbop117 := 0;
        ln_tope117 := 0;
    end;
  
    begin
      ln_InstLinea := fn_instancia_credito(v_Scmod  => ln_mod117,
                                           v_Scsuc  => ln_suc117,
                                           v_Scmda  => ln_mda117,
                                           v_Scpap  => ln_pap117,
                                           v_Sccta  => ln_cta117,
                                           v_Scoper => ln_oper117,
                                           v_Scsbop => ln_sbop117,
                                           v_Sctope => ln_tope117);
    end;
  
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_pais, ln_tdoc, lc_ndoc
        from sng001 s
       where s.sng001inst = ln_InstLinea;
    exception
      when others then
        null;
    end;
  
    for l in lista_creditos(ln_pais, ln_tdoc, lc_ndoc) loop
    
      begin
        select d.sng021eval
          into ln_EvalAux
          from sng021 d
         where d.sng021sol = l.ln_instaux;
      exception
        when others then
          ln_EvalAux := 0;
        
      end;
    
      if ln_Eval < ln_EvalAux then
        ln_Eval     := ln_EvalAux;
        ln_InstaEva := l.ln_instaux;
      end if;
    
    end loop;
  
    begin
      select SNG120FPag
        into ld_fcheval120
        from sng120 s
       where s.sng120ins = ln_InstaEva
         and s.sng120tsk = 'EVALUACION';
    exception
      when others then
        null;
    end;
  
    begin
      begin
        select max(j.jaqz515fee)
          into ld_MaxFchEva515
          from jaqz515 j
         where j.jaqz515pai = ln_pais
           and j.jaqz515tdo = ln_tdoc
           and trim(j.jaqz515ndo) = lc_ndoc;
      exception
        when others then
          null;
      end;
    
      begin
        select max(j.jaqz515ins)
          into ln_Ins515
          from jaqz515 j
         where j.jaqz515pai = ln_pais
           and j.jaqz515tdo = ln_tdoc
           and trim(j.jaqz515ndo) = lc_ndoc
           and j.jaqz515fee = ld_MaxFchEva515;
      end;
    
    end;
  
    if ld_fcheval120 is not null and ld_MaxFchEva515 is not null then
    
      if ld_fcheval120 >= ld_MaxFchEva515 then
        ld_fchevaluacion := ld_fcheval120;
        ln_InstEval      := ln_InstaEva;
      else
        if ld_fcheval120 < ld_MaxFchEva515 then
          ld_fchevaluacion := ld_MaxFchEva515;
          ln_InstEval      := ln_Ins515;
        end if;
      end if;
    
    else
      if ld_fcheval120 is null and ld_MaxFchEva515 is not null then
        ld_fchevaluacion := ld_MaxFchEva515;
        ln_InstEval      := ln_Ins515;
      else
        if ld_fcheval120 is not null and ld_MaxFchEva515 is null then
          ld_fchevaluacion := ld_fcheval120;
          ln_InstEval      := ln_InstaEva;
        end if;
      end if;
    end if;
  
    ln_InstEval := nvl(ln_InstEval, 0);
  
  end sp_cr_fchUltEval;
  ------------------------------------------------------------------------------  
  procedure sp_cr_fchUltEvalII(ln_pgcod         in number,
                               ln_itsuc         in number,
                               ln_itmod         in number,
                               ln_ittran        in number,
                               ln_itnrel        in number,
                               ln_itord         in number,
                               ln_itsbor        in number,
                               ln_InstLinea     out number,
                               ld_fchevaluacion out date,
                               ln_InstEval      out number,
                               lc_SacaInfo      out varchar2) is
  
    cursor lista_creditos(ln_pais number, ln_tdoc number, lc_ndoc varchar2) is
      select x.xwfempresa   ln_pgcod,
             x.xwfsucursal  ln_suc,
             x.xwfmodulo    ln_mod,
             x.xwfmoneda    ln_mda,
             x.xwfpapel     ln_pap,
             x.xwfcuenta    ln_cta,
             x.xwfoperacion ln_ope,
             x.xwfsubope    ln_sbop,
             x.xwftipope    ln_tope,
             x.xwfprcins    ln_InstAux
        from xwf700 x, fsd010 f, sng021 d
       where x.xwfprcins in (select s.sng001inst
                               from sng001 s
                              where s.sng001pais = ln_pais
                                and s.sng001tdoc = ln_tdoc
                                and s.sng001ndoc = lc_ndoc)
         and x.xwfempresa = f.pgcod
         and x.xwfsucursal = f.aosuc
         and x.xwfmodulo = f.aomod
         and x.xwfmoneda = f.aomda
         and x.xwfpapel = f.aopap
         and x.xwfcuenta = f.aocta
         and x.xwfoperacion = f.aooper
         and x.xwfsubope = f.aosbop
         and x.xwftipope = f.aotope
         and x.xwfcar3 = '1'
         and d.sng021sol = x.xwfprcins
         and d.sng021tmod = 13
       order by x.xwfprcins;
  
    ln_pais         number := 0;
    ln_tdoc         number := 0;
    lc_ndoc         varchar2(12);
    ld_MaxFchEva515 date;
    ln_EvalAux      number := 0;
    ln_Eval         number := 0;
    ln_InstaEva     number := 0;
    ln_Ins515       number := 0;
    ld_fcheval120   date;
    ln_pgcod116     number := 0;
    ln_mod116       number := 0;
    ln_tope116      number := 0;
    ln_suc116       number := 0;
    ln_mda116       number := 0;
    ln_pap116       number := 0;
    ln_cta116       number := 0;
    ln_oper116      number := 0;
    ln_sbop116      number := 0;
    ln_mod117       number := 0;
    ln_suc117       number := 0;
    ln_mda117       number := 0;
    ln_pap117       number := 0;
    ln_cta117       number := 0;
    ln_oper117      number := 0;
    ln_sbop117      number := 0;
    ln_tope117      number := 0;
    lc_FlgInstLinAE varchar2(2) := 'N';
  
  begin
    lc_SacaInfo := 'O';
  
    begin
      select f.pgcod,
             f.modulo,
             f.ittope,
             f.itsucd,
             f.moneda,
             f.papel,
             f.ctnro,
             f.itoper,
             f.itsubo
        into ln_pgcod116,
             ln_mod116,
             ln_tope116,
             ln_suc116,
             ln_mda116,
             ln_pap116,
             ln_cta116,
             ln_oper116,
             ln_sbop116
        from fsd016 f
       where f.pgcod = ln_pgcod
         and f.itsuc = ln_itsuc
         and f.itmod = ln_itmod
         and f.ittran = ln_ittran
         and f.itnrel = ln_itnrel
         and f.itord = ln_itord
         and f.itsbor = ln_itsbor;
    exception
      when others then
        ln_pgcod116 := 0;
        ln_mod116   := 0;
        ln_tope116  := 0;
        ln_suc116   := 0;
        ln_mda116   := 0;
        ln_pap116   := 0;
        ln_cta116   := 0;
        ln_oper116  := 0;
        ln_sbop116  := 0;
    end;
  
    begin
      select r2mod, r2suc, r2mda, r2pap, r2cta, r2oper, r2sbop, r2tope
        into ln_mod117,
             ln_suc117,
             ln_mda117,
             ln_pap117,
             ln_cta117,
             ln_oper117,
             ln_sbop117,
             ln_tope117
        from fsr011 f
       where f.r1cod = ln_pgcod116
         and f.r1mod = ln_mod116
         and f.r1suc = ln_suc116
         and f.r1cta = ln_cta116
         and f.r1oper = ln_oper116
         and f.r1sbop = ln_sbop116
         and f.r1mda = ln_mda116
         and f.r1pap = ln_pap116
         and f.r1tope = ln_tope116
         and f.relcod = 46;
    exception
      when others then
        ln_mod117  := 0;
        ln_suc117  := 0;
        ln_mda117  := 0;
        ln_pap117  := 0;
        ln_cta117  := 0;
        ln_oper117 := 0;
        ln_sbop117 := 0;
        ln_tope117 := 0;
    end;
  
    begin
      ln_InstLinea := fn_instancia_credito(v_Scmod  => ln_mod117,
                                           v_Scsuc  => ln_suc117,
                                           v_Scmda  => ln_mda117,
                                           v_Scpap  => ln_pap117,
                                           v_Sccta  => ln_cta117,
                                           v_Scoper => ln_oper117,
                                           v_Scsbop => ln_sbop117,
                                           v_Sctope => ln_tope117);
    end;
  
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_pais, ln_tdoc, lc_ndoc
        from sng001 s
       where s.sng001inst = ln_InstLinea;
    exception
      when others then
        null;
    end;
  
    for l in lista_creditos(ln_pais, ln_tdoc, lc_ndoc) loop
      --Instancia desembolsadas para el cliente
      begin
        select d.sng021eval
          into ln_EvalAux
          from sng021 d
         where d.sng021sol = l.ln_instaux;
      exception
        when others then
          ln_EvalAux := 0;
      end;
    
      if ln_Eval < ln_EvalAux then
        ln_Eval     := ln_EvalAux;
        ln_InstaEva := l.ln_instaux;
      end if;
    
    end loop;
  
    begin
    
      pq_cr_ratio_evalflujo.sp_cr_fchevaluacion(ln_instancia     => ln_InstaEva,
                                                ld_fchevaluacion => ld_fcheval120);
    
    end;
  
    begin
      -- Instancias Actualizadas fuera del Flujo, por el Panel de Actualizacion de Evaluacion
      begin
        select max(j.jaqz515fee)
          into ld_MaxFchEva515
          from jaqz515 j
         where j.jaqz515pai = ln_pais
           and j.jaqz515tdo = ln_tdoc
           and trim(j.jaqz515ndo) = trim(lc_ndoc); --23/12/2019 mpostigoc INC2246
      exception
        when others then
          null;
      end;
    
      begin
        select 'S'
          into lc_FlgInstLinAE
          from jaqz515 j
         where j.jaqz515ins = ln_InstLinea
           and j.jaqz515fee = ld_MaxFchEva515;
      exception
        when others then
          lc_FlgInstLinAE := 'N';
      end;
    
      if lc_FlgInstLinAE = 'S' then
        ln_Ins515 := ln_InstLinea;
      else
        if lc_FlgInstLinAE = 'N' then
          begin
            select max(j.jaqz515ins)
              into ln_Ins515
              from jaqz515 j
             where j.jaqz515pai = ln_pais
               and j.jaqz515tdo = ln_tdoc
               and trim(j.jaqz515ndo) = trim(lc_ndoc) --23/12/2019 mpostigoc INC2246
               and j.jaqz515fee = ld_MaxFchEva515;
          end;
        end if;
      end if;
    end;
  
    if ld_fcheval120 is not null and ld_MaxFchEva515 is not null then
    
      if ld_fcheval120 >= ld_MaxFchEva515 then
        ld_fchevaluacion := ld_fcheval120;
        ln_InstEval      := ln_InstaEva;
        lc_SacaInfo      := 'O';
      else
        if ld_fcheval120 < ld_MaxFchEva515 then
          ld_fchevaluacion := ld_MaxFchEva515;
          ln_InstEval      := ln_Ins515;
          lc_SacaInfo      := 'A';
        end if;
      end if;
    
    else
      if ld_fcheval120 is null and ld_MaxFchEva515 is not null then
        ld_fchevaluacion := ld_MaxFchEva515;
        ln_InstEval      := ln_Ins515;
        lc_SacaInfo      := 'A';
      else
        if ld_fcheval120 is not null and ld_MaxFchEva515 is null then
          ld_fchevaluacion := ld_fcheval120;
          ln_InstEval      := ln_InstaEva;
          lc_SacaInfo      := 'O';
        end if;
      end if;
    end if;
  
    ln_InstEval := nvl(ln_InstEval, 0);
  
  end sp_cr_fchUltEvalII;
  -----------------------------------------------------------------------------
  procedure sp_cr_LogRatio(ln_Pepais      in number,
                           ln_Petdoc      in number,
                           ln_Pendoc      in varchar2,
                           tipocambio     in number,
                           pd_fecpro      in date,
                           ln_instl       in number,
                           ln_inste       in number,
                           ln_pgcod       in number,
                           ln_itsuc       in number,
                           ln_itmod       in number,
                           ln_ittran      in number,
                           ln_itnrel      in number,
                           ln_itord       in number,
                           ln_itsbor      in number,
                           lc_Usuario     in varchar2,
                           lc_mesanio     in varchar2,
                           ln_captotcaja  in number,
                           ln_ifis        in number,
                           ln_ResultNeto  in number,
                           ln_MntCuoCntg  in number,
                           ln_MntPotncial in number,
                           ln_ratio       in number) is
  
    ln_corr   number;
    lc_IndEst varchar2(2);
    lc_hora   character(8);
  
    --  ln_Instancia number;
  
  begin
  
    begin
    
      select max(j.AQPA359corr)
        into ln_corr
        from AQPA359 j
       where j.AQPA359fec = pd_fecpro
         and j.AQPA359instl = ln_instl;
    exception
      when others then
        null;
    end;
  
    ln_corr := nvl(ln_corr, 0);
  
    lc_IndEst := 'I';
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    end;
  
    begin
      insert into AQPA359
        (AQPA359CORR,
         AQPA359PAIS,
         AQPA359TDOC,
         AQPA359NDOC,
         AQPA359TCAMB,
         AQPA359FEC,
         AQPA359INSTL,
         AQPA359INSTE,
         AQPA359PGCOD,
         AQPA359ITSUC,
         AQPA359ITMOD,
         AQPA359ITTRAN,
         AQPA359ITNREL,
         AQPA359ITORD,
         AQPA359ITSBOR,
         AQPA359HORA,
         AQPA359USER,
         AQPA359MESANIO,
         AQPA359CAPCAJA,
         AQPA359IFIS,
         AQPA359RESNETO,
         AQPA359CCONTG,
         AQPA359CPOTEN,
         AQPA359RATIO,
         AQPA359EST)
      values
        (ln_corr + 1,
         ln_Pepais,
         ln_Petdoc,
         ln_Pendoc,
         tipocambio,
         pd_fecpro,
         ln_instl,
         ln_inste,
         ln_pgcod,
         ln_itsuc,
         ln_itmod,
         ln_ittran,
         ln_itnrel,
         ln_itord,
         ln_itsbor,
         lc_hora,
         lc_Usuario,
         lc_mesanio,
         ln_captotcaja,
         ln_ifis,
         ln_ResultNeto,
         ln_MntCuoCntg,
         ln_MntPotncial,
         ln_ratio,
         lc_IndEst);
      commit;
    
    end;
  
  end sp_cr_LogRatio;
  ----------------------------------------------------------------------
  procedure sp_cr_LogDetMensualII(ln_Instancia   in number,
                                  ln_pgcod       in number,
                                  ln_itsuc       in number,
                                  ln_itmod       in number,
                                  ln_ittran      in number,
                                  ln_itnrel      in number,
                                  ln_itord       in number,
                                  ln_itsbor      in number,
                                  ld_FecProc     in date,
                                  ln_modulo      in number,
                                  ln_mntcuota    in number,
                                  ld_fchPanel    in date,
                                  ln_NroCuOtorg  in number,
                                  ln_NroCuotCred in number,
                                  lc_Indicador   in varchar2) is
  
    ln_mntacumld number := 0.00;
    ln_newmnt    number := 0.00;
    ln_Estado    varchar2(2) := 'H';
  
  begin
  
    ln_Estado := 'I';
  
    if ln_modulo = 117 then
    
      if lc_Indicador = 'CredVuelo' then
        -- Si la linea es la que se esta otorgando, el monto calculado se coloca 
        -- en la ultima cuota según su máximo plazo de utilización
      
        begin
          select a.AQPA358capcaja
            into ln_mntacumld
            from AQPA358 a
           where a.AQPA358instl = ln_Instancia
             and a.aqpa358pgcod = ln_pgcod
             and a.aqpa358itsuc = ln_itsuc
             and a.aqpa358itmod = ln_itmod
             and a.aqpa358ittran = ln_ittran
             and a.aqpa358itnrel = ln_itnrel
             and a.aqpa358itord = ln_itord
             and a.aqpa358itsbor = ln_itsbor
             and a.aqpa358fec = ld_FecProc
             and a.AQPA358corr = ln_NroCuotCred + 1
             and a.AQPA358est = ln_Estado;
        exception
          when others then
            ln_mntacumld := 0.00;
        end;
      
        begin
          ln_newmnt := ln_mntacumld + ln_mntcuota;
        end;
      
        begin
          update AQPA358 a
             set a.AQPA358capcaja = ln_newmnt
           where a.AQPA358instl = ln_Instancia
             and a.aqpa358pgcod = ln_pgcod
             and a.aqpa358itsuc = ln_itsuc
             and a.aqpa358itmod = ln_itmod
             and a.aqpa358ittran = ln_ittran
             and a.aqpa358itnrel = ln_itnrel
             and a.aqpa358itord = ln_itord
             and a.aqpa358itsbor = ln_itsbor
             and a.aqpa358fec = ld_FecProc
             and a.AQPA358est = ln_Estado
             AND a.AQPA358corr = ln_NroCuotCred + 1;
        end;
      else
        if lc_Indicador = 'CredVigent' then
          begin
            select a.AQPA358capcaja
              into ln_mntacumld
              from AQPA358 a
             where a.AQPA358instl = ln_Instancia
               and a.aqpa358pgcod = ln_pgcod
               and a.aqpa358itsuc = ln_itsuc
               and a.aqpa358itmod = ln_itmod
               and a.aqpa358ittran = ln_ittran
               and a.aqpa358itnrel = ln_itnrel
               and a.aqpa358itord = ln_itord
               and a.aqpa358itsbor = ln_itsbor
               and a.aqpa358fec = ld_FecProc
               and a.AQPA358corr = ln_NroCuOtorg + 1
               and a.AQPA358est = ln_Estado;
          exception
            when others then
              ln_mntacumld := 0.00;
          end;
        
          begin
            ln_newmnt := ln_mntacumld + ln_mntcuota;
          end;
        
          begin
            update AQPA358 a
               set a.AQPA358capcaja = ln_newmnt
             where a.AQPA358instl = ln_Instancia
               and a.aqpa358pgcod = ln_pgcod
               and a.aqpa358itsuc = ln_itsuc
               and a.aqpa358itmod = ln_itmod
               and a.aqpa358ittran = ln_ittran
               and a.aqpa358itnrel = ln_itnrel
               and a.aqpa358itord = ln_itord
               and a.aqpa358itsbor = ln_itsbor
               and a.aqpa358fec = ld_FecProc
               and a.AQPA358est = ln_Estado
               AND a.AQPA358corr = ln_NroCuOtorg + 1;
          end;
        end if;
      end if;
    else
      if ln_modulo <> 117 then
        begin
          select a.AQPA358capcaja
            into ln_mntacumld
            from AQPA358 a
           where a.AQPA358instl = ln_Instancia
             and a.aqpa358pgcod = ln_pgcod
             and a.aqpa358itsuc = ln_itsuc
             and a.aqpa358itmod = ln_itmod
             and a.aqpa358ittran = ln_ittran
             and a.aqpa358itnrel = ln_itnrel
             and a.aqpa358itord = ln_itord
             and a.aqpa358itsbor = ln_itsbor
             and a.aqpa358fec = ld_FecProc
             and a.AQPA358fecal = ld_fchPanel
             and a.AQPA358est = ln_Estado;
        end;
      
        begin
          ln_newmnt := ln_mntacumld + ln_mntcuota;
        end;
      
        begin
          update AQPA358 a
             set a.AQPA358capcaja = ln_newmnt
           where a.AQPA358instl = ln_Instancia
             and a.aqpa358pgcod = ln_pgcod
             and a.aqpa358itsuc = ln_itsuc
             and a.aqpa358itmod = ln_itmod
             and a.aqpa358ittran = ln_ittran
             and a.aqpa358itnrel = ln_itnrel
             and a.aqpa358itord = ln_itord
             and a.aqpa358itsbor = ln_itsbor
             and a.aqpa358fec = ld_FecProc
             and a.AQPA358est = ln_Estado
             AND a.AQPA358fecal = ld_fchPanel;
        end;
      
      end if;
    end if;
    commit;
  
  end sp_cr_LogDetMensualII;
  ------------------------------------------------------------------
  procedure sp_cr_LogDetMensPanel(ln_Instancia   in number,
                                  ln_pgcod       in number,
                                  ln_itsuc       in number,
                                  ln_itmod       in number,
                                  ln_ittran      in number,
                                  ln_itnrel      in number,
                                  ln_itord       in number,
                                  ln_itsbor      in number,
                                  ld_FecProc     in date,
                                  ln_modulo      in number,
                                  ln_mntcuota    in number,
                                  ld_fchPanel    in date,
                                  ln_NroCuOtorg  in number,
                                  ln_NroCuotCred in number,
                                  lc_Indicador   in varchar2) is
  
    ln_mntacumld number := 0.00;
    ln_newmnt    number := 0.00;
  begin
  
    if ln_modulo = 117 then
    
      if lc_Indicador = 'CredVuelo' then
        -- Si la linea es la que se esta otorgando, el monto calculado se coloca 
        -- en la ultima cuota según su máximo plazo de utilización
      
        begin
          select a.aqpa360cuoc
            into ln_mntacumld
            from AQPA360 a
           where a.AQPA360instl = ln_Instancia
             and a.aqpa360pgcod = ln_pgcod
             and a.aqpa360itsuc = ln_itsuc
             and a.aqpa360itmod = ln_itmod
             and a.aqpa360ittran = ln_ittran
             and a.aqpa360itnrel = ln_itnrel
             and a.aqpa360itord = ln_itord
             and a.aqpa360itsbor = ln_itsbor
             and a.aqpa360fec = ld_FecProc
             and a.AQPA360corr = ln_NroCuotCred + 1
             and a.AQPA360estatr = 'I';
        exception
          when others then
            ln_mntacumld := 0.00;
        end;
      
        begin
          ln_newmnt := ln_mntacumld + ln_mntcuota;
        end;
      
        begin
          update AQPA360 a
             set a.aqpa360cuoc = ln_newmnt
           where a.AQPA360instl = ln_Instancia
             and a.aqpa360pgcod = ln_pgcod
             and a.aqpa360itsuc = ln_itsuc
             and a.aqpa360itmod = ln_itmod
             and a.aqpa360ittran = ln_ittran
             and a.aqpa360itnrel = ln_itnrel
             and a.aqpa360itord = ln_itord
             and a.aqpa360itsbor = ln_itsbor
             and a.aqpa360fec = ld_FecProc
             and a.AQPA360estatr = 'I'
             AND a.AQPA360corr = ln_NroCuotCred + 1;
        end;
      
      else
        if lc_Indicador = 'CredVigent' then
          -- Si la linea es vigente, el monto calculado se coloca en la ultima cuota
          -- del credito a otorgar
          begin
            select a.aqpa360cuoc
              into ln_mntacumld
              from AQPA360 a
             where a.AQPA360instl = ln_Instancia
               and a.aqpa360pgcod = ln_pgcod
               and a.aqpa360itsuc = ln_itsuc
               and a.aqpa360itmod = ln_itmod
               and a.aqpa360ittran = ln_ittran
               and a.aqpa360itnrel = ln_itnrel
               and a.aqpa360itord = ln_itord
               and a.aqpa360itsbor = ln_itsbor
               and a.aqpa360fec = ld_FecProc
               and a.AQPA360corr = ln_NroCuOtorg + 1
               and a.AQPA360estatr = 'I';
          exception
            when others then
              ln_mntacumld := 0.00;
          end;
        
          begin
            ln_newmnt := ln_mntacumld + ln_mntcuota;
          end;
        
          begin
            update AQPA360 a
               set a.aqpa360cuoc = ln_newmnt
             where a.AQPA360instl = ln_Instancia
               and a.aqpa360pgcod = ln_pgcod
               and a.aqpa360itsuc = ln_itsuc
               and a.aqpa360itmod = ln_itmod
               and a.aqpa360ittran = ln_ittran
               and a.aqpa360itnrel = ln_itnrel
               and a.aqpa360itord = ln_itord
               and a.aqpa360itsbor = ln_itsbor
               and a.aqpa360fec = ld_FecProc
               and a.AQPA360estatr = 'I'
               AND a.AQPA360corr = ln_NroCuOtorg + 1;
          end;
        end if;
      end if;
    
    else
      if ln_modulo <> 117 then
        begin
          select a.aqpa360cuoc
            into ln_mntacumld
            from AQPA360 a
           where a.AQPA360instl = ln_Instancia
             and a.aqpa360pgcod = ln_pgcod
             and a.aqpa360itsuc = ln_itsuc
             and a.aqpa360itmod = ln_itmod
             and a.aqpa360ittran = ln_ittran
             and a.aqpa360itnrel = ln_itnrel
             and a.aqpa360itord = ln_itord
             and a.aqpa360itsbor = ln_itsbor
             and a.aqpa360fec = ld_FecProc
             and a.aqpa360fcon = ld_fchPanel
             and a.AQPA360estatr = 'I';
        end;
      
        begin
          ln_newmnt := ln_mntacumld + ln_mntcuota;
        end;
      
        begin
          update AQPA360 a
             set a.aqpa360cuoc = ln_newmnt
           where a.AQPA360instl = ln_Instancia
             and a.aqpa360pgcod = ln_pgcod
             and a.aqpa360itsuc = ln_itsuc
             and a.aqpa360itmod = ln_itmod
             and a.aqpa360ittran = ln_ittran
             and a.aqpa360itnrel = ln_itnrel
             and a.aqpa360itord = ln_itord
             and a.aqpa360itsbor = ln_itsbor
             and a.aqpa360fec = ld_FecProc
             and a.AQPA360estatr = 'I'
             AND a.aqpa360fcon = ld_fchPanel;
        end;
      
      end if;
    end if;
  
    commit;
  
  end sp_cr_LogDetMensPanel;

  -------------------------------------------------------------------
  procedure sp_cr_LogCuentas(ld_fec     in date,
                             lc_user    in varchar2,
                             ln_pais    in number,
                             ln_tdoc    in number,
                             ln_ndoc    in varchar2,
                             ln_tcamb   in number,
                             ln_instl   in number,
                             ln_inste   in number,
                             ln_pgcod   in number,
                             ln_itsuc   in number,
                             ln_itmod   in number,
                             ln_ittran  in number,
                             ln_itnrel  in number,
                             ln_itord   in number,
                             ln_itsbor  in number,
                             ld_feval   in date,
                             ld_fical   in date,
                             ln_emp     in number,
                             ln_mod     in number,
                             ln_suc     in number,
                             ln_mda     in number,
                             ln_pap     in number,
                             ln_cta     in number,
                             ln_ope     in number,
                             ln_sbop    in number,
                             ln_tope    in number,
                             ln_TipoOri in number,
                             ln_NroCuot in number,
                             lc_IndCred in varchar2,
                             ln_SaldCap in number,
                             ln_monto   in number) is
  
    ln_corr   number;
    lc_hora   character(8);
    lc_IndEst varchar2(2);
  
  begin
  
    begin
    
      select max(j.AQPA357corr)
        into ln_corr
        from AQPA357 j
       where j.AQPA357fec = ld_fec
         and j.AQPA357instl = ln_instl;
    exception
      when no_data_found then
        ln_corr := 0;
      
    end;
  
    ln_corr := nvl(ln_corr, 0);
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    end;
  
    lc_IndEst := 'I';
  
    begin
      insert into aqpa357
        (aqpa357corr,
         aqpa357fec,
         aqpa357hora,
         aqpa357user,
         aqpa357pais,
         aqpa357tdoc,
         aqpa357ndoc,
         aqpa357tcamb,
         aqpa357instl,
         aqpa357inste,
         aqpa357pgcod,
         aqpa357itsuc,
         aqpa357itmod,
         aqpa357ittran,
         aqpa357itnrel,
         aqpa357itord,
         aqpa357itsbor,
         aqpa357feval,
         aqpa357fical,
         aqpa357emp,
         aqpa357mod,
         aqpa357suc,
         aqpa357mda,
         aqpa357pap,
         aqpa357cta,
         aqpa357ope,
         aqpa357sbop,
         aqpa357tope,
         aqpa357ori,
         aqpa357ncuo,
         aqpa357est,
         aqpa357indcred,
         aqpa357naux1,
         aqpa357naux2)
      
      values
        (ln_corr + 1,
         ld_fec,
         lc_hora,
         lc_user,
         ln_pais,
         ln_tdoc,
         ln_ndoc,
         ln_tcamb,
         ln_instl,
         ln_inste,
         ln_pgcod,
         ln_itsuc,
         ln_itmod,
         ln_ittran,
         ln_itnrel,
         ln_itord,
         ln_itsbor,
         ld_feval,
         ld_fical,
         ln_emp,
         ln_mod,
         ln_suc,
         ln_mda,
         ln_pap,
         ln_cta,
         ln_ope,
         ln_sbop,
         ln_tope,
         ln_TipoOri,
         ln_NroCuot,
         lc_IndEst,
         lc_IndCred,
         ln_SaldCap,
         ln_monto);
      commit;
    end;
  
  end sp_cr_LogCuentas;
  ---------------------------------------------------------------
  procedure sp_cr_DatosPanelEF(ld_FecPro     in date,
                               ln_instl      in number,
                               ln_inste      in number,
                               ln_pgcod      in number,
                               ln_itsuc      in number,
                               ln_itmod      in number,
                               ln_ittran     in number,
                               ln_itnrel     in number,
                               ln_itord      in number,
                               ln_itsbor     in number,
                               lc_Usuario    in varchar2,
                               ln_capcontgnt in number,
                               lc_SacasInfo  in varchar2) is
  
    cursor Cuotas_EvalFlujoOtorg is
      select *
        from aqpa410 a
       where a.aqpa410inst = ln_inste
         and a.aqpa410esta = 'S'
       order by a.aqpa410fcon;
  
    cursor Cuotas_EvalFlujoAE is
      select *
        from aqpa410a a
       where a.aqpa410ainst = ln_inste
         and a.aqpa410aesta = 'S'
       order by a.aqpa410afcon;
  
    lc_aniomescuo  varchar2(8);
    lc_hora        character(8) := '00:00:00';
    ln_Pepais      number;
    ln_Petdoc      number;
    ln_Pendoc      varchar2(12);
    ln_TipCamb     number(14, 8) := 0.00;
    ln_corr        number := 1;
    ln_Estado      varchar2(5) := 'I';
    ln_MntPotncial number(17, 2) := 0.00;
    --ln_regOtorg    number := 0;
    --ln_regAE       number := 0;
    ln_indicador number := 0;
  
  begin
  
    ln_Estado := 'I';
  
    begin
      select to_char(sysdate, 'HH24:MI:SS') into lc_hora from dual;
    end;
  
    begin
      select s.sng001pais, s.sng001tdoc, s.sng001ndoc
        into ln_Pepais, ln_Petdoc, ln_Pendoc
        from sng001 s
       where s.sng001inst = ln_instl;
    exception
      when others then
        null;
    end;
  
    begin
      --Tipo de Cambio
      select s. sng120tcbi
        into ln_TipCamb
        from sng120 s
       where s.sng120ins = ln_instl
         and s.sng120tsk = 'EVALUACION';
    exception
      when others then
        ln_TipCamb := 0;
    end;
  
    begin
      -- Cuota Potencial
      PQ_CR_RATIO_EVALFLUJO_RTE.sp_cR_CuotaPotencial(ln_instl,
                                                     ln_pgcod,
                                                     ln_itsuc,
                                                     ln_itmod,
                                                     ln_ittran,
                                                     ln_itnrel,
                                                     ld_FecPro,
                                                     lc_Usuario,
                                                     ln_MntPotncial);
    
      ln_MntPotncial := nvl(ln_MntPotncial, 0);
    end;
  
    /* begin
      --- Verificar de donde voy a copiar los datos de la evaluacion
      begin
        select count(*)
          into ln_regOtorg
          from aqpa410 a
         where a.aqpa410inst = ln_inste
           and a.aqpa410esta = 'S';
      exception
        when others then
          ln_regOtorg := 0;
      end;
    
      begin
        select count(*)
          into ln_regAE
          from aqpa410a a
         where a.aqpa410ainst = ln_inste
           and a.aqpa410aesta = 'S';
      exception
        when others then
          ln_regAE := 0;
      end;
    
      if ln_regOtorg > 0 and ln_regAE = 0 then
        ln_Indicador := 1; --  saco info de otorgamiento
      else
        if ln_regOtorg = 0 and ln_regAE > 0 then
          ln_Indicador := 2; -- saco info del panel de AE
        else
          if ln_regOtorg > 0 and ln_regAE > 0 then
            ln_Indicador := 1; --  saco info de otorgamiento
          end if;
        end if;
      end if;
    end;*/
  
    if lc_SacasInfo = 'O' then
      ln_indicador := 1; --  saco info de otorgamiento
    
    else
      if lc_SacasInfo = 'A' then
        ln_indicador := 2; -- saco info del panel de AE
      end if;
    end if;
  
    if ln_indicador = 1 then
      for c in Cuotas_EvalFlujoOtorg loop
        begin
          select to_char(c.aqpa410fcon, 'YYYYMM')
            into lc_aniomescuo
            from dual;
        end;
      
        begin
        
          insert into aqpa360
            (aqpa360corr,
             aqpa360fec,
             aqpa360hora,
             aqpa360user,
             aqpa360pais,
             aqpa360tdoc,
             aqpa360ndoc,
             aqpa360tcamb,
             aqpa360instl,
             aqpa360inste,
             aqpa360pgcod,
             aqpa360itsuc,
             aqpa360itmod,
             aqpa360ittran,
             aqpa360itnrel,
             aqpa360itord,
             aqpa360itsbor,
             aqpa360estatr,
             aqpa360neva,
             aqpa360ases,
             aqpa360numc,
             aqpa360feval,
             aqpa360fini,
             aqpa360finf,
             aqpa360fcon,
             aqpa360mesc,
             aqpa360anio,
             aqpa360resn,
             aqpa360ifis,
             aqpa360esta,
             aqpa360flag,
             aqpa360cuoc,
             aqpa360flujo,
             aqpa360ratio,
             aqpa360aux0,
             aqpa360aux1,
             aqpa360aux2,
             aqpa360aux3,
             aqpa360aux4,
             aqpa360aux5,
             aqpa360mso,
             aqpa360efe,
             aqpa360cpo,
             aqpa360cco)
          values
            (ln_corr,
             ld_FecPro,
             lc_hora,
             lc_Usuario,
             ln_Pepais,
             ln_Petdoc,
             ln_Pendoc,
             ln_TipCamb,
             ln_instl,
             ln_inste,
             ln_pgcod,
             ln_itsuc,
             ln_itmod,
             ln_ittran,
             ln_itnrel,
             ln_itord,
             ln_itsbor,
             ln_Estado,
             c.aqpa410neva,
             c.aqpa410ases,
             c.aqpa410numc,
             c.aqpa410feval,
             c.aqpa410fini,
             c.aqpa410finf,
             c.aqpa410fcon,
             c.aqpa410mesc,
             c.aqpa410anio,
             nvl(c.aqpa410resn, 0),
             nvl(c.aqpa410ifis, 0),
             c.aqpa410esta,
             c.aqpa410flag,
             0.00, --c.aqpa410cuoc,
             nvl(c.aqpa410flujo, 0),
             nvl(c.aqpa410ratio, 0),
             c.aqpa410aux0,
             c.aqpa410aux1,
             c.aqpa410aux2,
             c.aqpa410aux3,
             c.aqpa410aux4,
             c.aqpa410aux5,
             c.aqpa410mso,
             nvl(c.aqpa410efe, 0),
             nvl(c.aqpa410cpo, 0),
             nvl(c.aqpa410cco, 0));
        
          insert into AQPA358
            (AQPA358CORR,
             AQPA358FEC,
             AQPA358HORA,
             AQPA358USER,
             AQPA358PAIS,
             AQPA358TDOC,
             AQPA358NDOC,
             AQPA358TCAMB,
             AQPA358INSTL,
             AQPA358INSTE,
             AQPA358PGCOD,
             AQPA358ITSUC,
             AQPA358ITMOD,
             AQPA358ITTRAN,
             AQPA358ITNREL,
             AQPA358ITORD,
             AQPA358ITSBOR,
             AQPA358FEVAL,
             AQPA358FECAL,
             AQPA358MESANIO,
             AQPA358CAPCAJA,
             AQPA358IFIS,
             AQPA358RESNETO,
             AQPA358CCONTG,
             AQPA358CPOTEN,
             AQPA358RATIO,
             AQPA358EST)
          values
            (ln_corr,
             ld_FecPro,
             lc_hora,
             lc_Usuario,
             ln_Pepais,
             ln_Petdoc,
             ln_Pendoc,
             ln_TipCamb,
             ln_instl,
             ln_inste,
             ln_pgcod,
             ln_itsuc,
             ln_itmod,
             ln_ittran,
             ln_itnrel,
             ln_itord,
             ln_itsbor,
             c.aqpa410feval,
             c.aqpa410fcon,
             lc_aniomescuo,
             0.00,
             nvl(c.aqpa410ifis, 0),
             nvl(c.aqpa410resn, 0),
             nvl(c.aqpa410cco, 0), --ln_capcontgnt,
             nvl(c.aqpa410cpo, 0), --ln_MntPotncial,
             0.000000,
             ln_Estado);
          COMMIT;
          ln_corr := ln_corr + 1;
        
        end;
      end loop;
    
    else
      if ln_indicador = 2 then
        for d in Cuotas_EvalFlujoAE loop
          begin
            select to_char(d.aqpa410afcon, 'YYYYMM')
              into lc_aniomescuo
              from dual;
          end;
        
          begin
          
            insert into aqpa360
              (aqpa360corr,
               aqpa360fec,
               aqpa360hora,
               aqpa360user,
               aqpa360pais,
               aqpa360tdoc,
               aqpa360ndoc,
               aqpa360tcamb,
               aqpa360instl,
               aqpa360inste,
               aqpa360pgcod,
               aqpa360itsuc,
               aqpa360itmod,
               aqpa360ittran,
               aqpa360itnrel,
               aqpa360itord,
               aqpa360itsbor,
               aqpa360estatr,
               aqpa360neva,
               aqpa360ases,
               aqpa360numc,
               aqpa360feval,
               aqpa360fini,
               aqpa360finf,
               aqpa360fcon,
               aqpa360mesc,
               aqpa360anio,
               aqpa360resn,
               aqpa360ifis,
               aqpa360esta,
               aqpa360flag,
               aqpa360cuoc,
               aqpa360flujo,
               aqpa360ratio,
               aqpa360aux0,
               aqpa360aux1,
               aqpa360aux2,
               aqpa360aux3,
               aqpa360aux4,
               aqpa360aux5,
               aqpa360mso,
               aqpa360efe,
               aqpa360cpo,
               aqpa360cco)
            values
              (ln_corr,
               ld_FecPro,
               lc_hora,
               lc_Usuario,
               ln_Pepais,
               ln_Petdoc,
               ln_Pendoc,
               ln_TipCamb,
               ln_instl,
               ln_inste,
               ln_pgcod,
               ln_itsuc,
               ln_itmod,
               ln_ittran,
               ln_itnrel,
               ln_itord,
               ln_itsbor,
               ln_Estado,
               d.aqpa410aneva,
               d.aqpa410aases,
               d.aqpa410anumc,
               d.aqpa410afeval,
               d.aqpa410afini,
               d.aqpa410afinf,
               d.aqpa410afcon,
               d.aqpa410amesc,
               d.aqpa410aanio,
               nvl(d.aqpa410aresn, 0),
               nvl(d.aqpa410aifis, 0),
               d.aqpa410aesta,
               d.aqpa410aflag,
               0.00, --d.aqpa410acuoc,
               nvl(d.aqpa410aflujo, 0),
               nvl(d.aqpa410aratio, 0),
               d.aqpa410aaux0,
               d.aqpa410aaux1,
               d.aqpa410aaux2,
               d.aqpa410aaux3,
               d.aqpa410aaux4,
               d.aqpa410aaux5,
               d.aqpa410amso,
               nvl(d.aqpa410aefe, 0),
               nvl(ln_MntPotncial, 0),
               nvl(ln_capcontgnt, 0));
          
            insert into AQPA358
              (AQPA358CORR,
               AQPA358FEC,
               AQPA358HORA,
               AQPA358USER,
               AQPA358PAIS,
               AQPA358TDOC,
               AQPA358NDOC,
               AQPA358TCAMB,
               AQPA358INSTL,
               AQPA358INSTE,
               AQPA358PGCOD,
               AQPA358ITSUC,
               AQPA358ITMOD,
               AQPA358ITTRAN,
               AQPA358ITNREL,
               AQPA358ITORD,
               AQPA358ITSBOR,
               AQPA358FEVAL,
               AQPA358FECAL,
               AQPA358MESANIO,
               AQPA358CAPCAJA,
               AQPA358IFIS,
               AQPA358RESNETO,
               AQPA358CCONTG,
               AQPA358CPOTEN,
               AQPA358RATIO,
               AQPA358EST)
            values
              (ln_corr,
               ld_FecPro,
               lc_hora,
               lc_Usuario,
               ln_Pepais,
               ln_Petdoc,
               ln_Pendoc,
               ln_TipCamb,
               ln_instl,
               ln_inste,
               ln_pgcod,
               ln_itsuc,
               ln_itmod,
               ln_ittran,
               ln_itnrel,
               ln_itord,
               ln_itsbor,
               d.aqpa410afeval,
               d.aqpa410afcon,
               lc_aniomescuo,
               0.00,
               nvl(d.aqpa410aifis, 0),
               nvl(d.aqpa410aresn, 0),
               nvl(ln_capcontgnt, 0), --ln_capcontgnt,
               nvl(ln_MntPotncial, 0), --ln_MntPotncial,
               0.000000,
               ln_Estado);
          
            COMMIT;
            ln_corr := ln_corr + 1;
          
          end;
        end loop;
      end if;
    end if;
  
  end sp_cr_DatosPanelEF;
  -----------------------------------------------------------
  procedure sp_cr_CalFormula(ln_Instancia in number,
                             --ln_inste     in number,
                             ln_pgcod   in number,
                             ln_itsuc   in number,
                             ln_itmod   in number,
                             ln_ittran  in number,
                             ln_itnrel  in number,
                             ln_itord   in number,
                             ln_itsbor  in number,
                             ld_FecProc in date) is
  
    cursor lista_reg(lc_estado varchar2) is
    
      select b.AQPA358capcaja ln_cmac,
             b.AQPA358ifis    ln_ifis,
             b.AQPA358resneto ln_resneto,
             b.AQPA358ccontg  ln_ccontg,
             b.AQPA358cpoten  ln_cpoten,
             b.AQPA358fecal   ld_fcalnd
        from AQPA358 B
       WHERE B.AQPA358INSTl = ln_Instancia
         and B.aqpa358pgcod = ln_pgcod
         and B.aqpa358itsuc = ln_itsuc
         and B.aqpa358itmod = ln_itmod
         and B.aqpa358ittran = ln_ittran
         and B.aqpa358itnrel = ln_itnrel
         and B.aqpa358itord = ln_itord
         and B.aqpa358itsbor = ln_itsbor
         and B.AQPA358FEC = ld_FecProc
         and B.AQPA358est = lc_estado;
  
    --ln_ReslNeto  number(17, 2) := 0.00;
    -- ln_DeudaIFIS number(17, 2) := 0.00;
    ln_ratio     number(12, 6) := 0.000000;
    ln_Estado    varchar2(5) := 'H';
    ln_dividendo number := 0.00;
    ln_divisor   number := 0.00;
    --ln_regOtorg  number := 0;
    --ln_regAE     number := 0;
    --ln_Indicador number := 1;
  
  begin
  
    ln_Estado := 'I';
  
    /* begin
      --- Verificar de donde voy a copiar los datos de la evaluacion
      begin
        select count(*)
          into ln_regOtorg
          from aqpa410 a
         where a.aqpa410inst = ln_inste
           and a.aqpa410esta = 'S';
      exception
        when others then
          ln_regOtorg := 0;
      end;
    
      begin
        select count(*)
          into ln_regAE
          from aqpa410a a
         where a.aqpa410ainst = ln_inste
           and a.aqpa410aesta = 'S';
      exception
        when others then
          ln_regAE := 0;
      end;
    
      if ln_regOtorg > 0 and ln_regAE = 0 then
        ln_Indicador := 1; --  saco info de otorgamiento
      else
        if ln_regOtorg = 0 and ln_regAE > 0 then
          ln_Indicador := 2; -- saco info del panel de AE
        else
          if ln_regOtorg > 0 and ln_regAE > 0 then
            ln_Indicador := 1; --  saco info de otorgamiento
          end if;
        end if;
      end if;
    end;*/
  
    for l in lista_reg(ln_Estado) loop
    
      /*  if ln_Indicador = 1 then
        begin
          select a.aqpa410resn, a.aqpa410ifis
            into ln_ReslNeto, ln_DeudaIFIS
            from aqpa410 a
           where a.aqpa410inst = ln_Instancia
             and a.aqpa410fcon = l.ld_fcalnd
             and a.aqpa410esta = 'S';
        exception
          when others then
            ln_ReslNeto  := 0.00;
            ln_DeudaIFIS := 0.00;
        end;
      
      else
        if ln_Indicador = 2 then
        
          begin
            select a.aqpa410aresn, a.aqpa410aifis
              into ln_ReslNeto, ln_DeudaIFIS
              from aqpa410a a
             where a.aqpa410ainst = ln_Instancia
               and a.aqpa410afcon = l.ld_fcalnd
               and a.aqpa410aesta = 'S';
          exception
            when others then
              ln_ReslNeto  := 0.00;
              ln_DeudaIFIS := 0.00;
          end;
        
        end if;
      end if;*/
    
      ln_dividendo := nvl(l.ln_cmac, 0) + nvl(l.ln_ifis, 0) +
                      nvl(l.ln_ccontg, 0) + nvl(l.ln_cpoten, 0);
      ln_divisor   := nvl(l.ln_ifis, 0) + nvl(l.ln_resneto, 0) +
                      nvl(l.ln_cpoten, 0);
    
      if ln_divisor <> 0 and l.ln_cmac > 0 then
        begin
          ln_ratio := round((ln_dividendo / ln_divisor), 6);
        end;
      else
        ln_ratio := 0.000000;
      end if;
    
      begin
        update AQPA358 a
           set a.AQPA358ratio = ln_ratio
         where a.AQPA358instl = ln_Instancia
           and a.AQPA358fecal = l.ld_fcalnd
           and a.aqpa358pgcod = ln_pgcod
           and a.aqpa358itsuc = ln_itsuc
           and a.aqpa358itmod = ln_itmod
           and a.aqpa358ittran = ln_ittran
           and a.aqpa358itnrel = ln_itnrel
           and a.aqpa358itord = ln_itord
           and a.aqpa358itsbor = ln_itsbor
           and a.AQPA358FEC = ld_FecProc
           and a.AQPA358est = ln_Estado;
      end;
    
    end loop;
  
    commit;
  
  end sp_cr_CalFormula;
  -------------------------------------------------------------------
  Procedure sp_cr_recalculaRN(pn_ins     in number,
                              ln_pgcod   in number,
                              ln_itsuc   in number,
                              ln_itmod   in number,
                              ln_ittran  in number,
                              ln_itnrel  in number,
                              ln_itord   in number,
                              ln_itsbor  in number,
                              ld_FecProc in date) is
  
    cursor registros is
      select *
        from AQPA360 a
       where a.AQPA360inste = pn_ins
         and a.aqpa360pgcod = ln_pgcod
         and a.aqpa360itsuc = ln_itsuc
         and a.aqpa360itmod = ln_itmod
         and a.aqpa360ittran = ln_ittran
         and a.aqpa360itnrel = ln_itnrel
         and a.aqpa360itord = ln_itord
         and a.aqpa360itsbor = ln_itsbor
         and a.aqpa360fec = ld_FecProc
         and a.AQPA360esta = 'S'
       order by a.AQPA360fcon;
  
    lc_flgAct   char(1) := 'N';
    ln_acum     number(17, 2);
    ln_acum_ant number(17, 2) := 0;
    ln_cuo_ant  number(17, 2) := 0;
    ln_ratio    number(17, 6) := 0;
    ln_ratioD   number := 0;
    ln_agro     number(5);
    ln_pecu     number(5);
    ln_corrMin  number(10);
    ln_tipcam   NUMBER(14, 8);
    ln_mtoSol   NUMBER(17, 2);
    ln_mtoDol   NUMBER(17, 2);
    ln_mtoTot   NUMBER(17, 2);
    --ln_cuoPoten NUMBER(17, 2);
    -- ln_cuoCont1 NUMBER(17, 2);
    --ln_cuoCont2 NUMBER(17, 2);
    -- ln_cuoContT NUMBER(17, 2);
    lc_flg char(1);
    ln_mod number(3);
  
  begin
    pq_cr_resolutor_observacion.sp_cr_codactvprecagri(pn_ins,
                                                      ln_agro,
                                                      ln_pecu);
  
    begin
      select a.xwfmodulo
        into ln_mod
        from xwf700 a
       where a.xwfprcins = pn_ins
         and a.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
  
    if ln_agro <> 0 or ln_pecu <> 0 or ln_mod = 104 then
      lc_flgAct := 'S';
    
    end if;
  
    if ln_mod = 117 then
      lc_flgAct := 'N';
    end if;
  
    begin
      select min(a.AQPA360corr)
        into ln_corrMin
        from AQPA360 a
       where a.AQPA360inste = pn_ins
         and a.aqpa360pgcod = ln_pgcod
         and a.aqpa360itsuc = ln_itsuc
         and a.aqpa360itmod = ln_itmod
         and a.aqpa360ittran = ln_ittran
         and a.aqpa360itnrel = ln_itnrel
         and a.aqpa360itord = ln_itord
         and a.aqpa360itsbor = ln_itsbor
         and a.aqpa360fec = ld_FecProc
         and a.AQPA360esta = 'S'
         and a.aqpa360estatr = 'I';
    exception
      when others then
        null;
    end;
  
    begin
      select a.sng120tcbi
        into ln_tipcam
        from sng120 a
       where a.sng120ins = pn_ins
         and a.sng120tsk = 'EVALUACION';
    exception
      when others then
        null;
    end;
  
    begin
      select b.sng023mto
        into ln_mtoSol
        from sng021 a, sng023 b
       where a.sng021sol = pn_ins
         and a.sng021eval = b.sng021eval
         and b.sng026cod = 41;
    exception
      when others then
        null;
    end;
  
    begin
      select b.sng023mto
        into ln_mtoDol
        from sng021 a, sng023 b
       where a.sng021sol = pn_ins
         and a.sng021eval = b.sng021eval
         and b.sng026cod = 541;
    exception
      when others then
        null;
    end;
  
    ln_mtoTot := nvl(ln_mtoSol, 0) + (nvl(ln_mtoDol, 0) * ln_tipcam);
  
    begin
      select a.xwfmonto1
        into ln_mtoSol
        from xwf700 a
       where a.xwfprcins = pn_ins
         and a.xwfcar3 = '1';
    exception
      when others then
        null;
    end;
    lc_flg := 'N';
  
    /*pQ_CR_PANEL_AGROPECUARIO.Sp_cr_cuoPotencial(pn_ins, ln_cuoPoten);
    pq_cr_resolutor_cappago.sp_cr_cuotacontincf(pn_ins,
                                                pd_fecpro,
                                                lc_flg,
                                                ln_cuoCont1);
    pq_cr_resolutor_cappago.sp_cr_cuotacontinaval(pn_ins,
                                                  pd_fecpro,
                                                  lc_flg,
                                                  ln_cuoCont2);
    
    ln_cuoContT := nvl(ln_cuoCont1, 0) + nvl(ln_cuoCont2, 0);*/
  
    if lc_flgAct = 'S' then
      --actividad agro
      for i in registros loop
      
        if i.AQPA360corr = ln_corrMin then
          --primer registro
          ln_acum := nvl(ln_mtoSol, 0) + nvl(ln_mtoTot, 0) +
                     nvl(i.AQPA360flujo, 0);
        else
          ln_acum := nvl(ln_acum_ant, 0) + nvl(i.AQPA360flujo, 0) -
                     nvl(ln_cuo_ant, 0);
        
        end if;
      
        if nvl(i.AQPA360cuoc, 0) <> 0 then
          ln_ratioD := nvl(ln_acum, 0) + nvl(i.AQPA360ifis, 0) +
                       nvl(I.AQPA360CPO, 0);
          if ln_ratioD = 0 then
            ln_ratio := 0;
          else
            ln_ratio := (nvl(i.AQPA360cuoc, 0) + nvl(i.AQPA360ifis, 0) +
                        nvl(I.AQPA360CPO, 0) + nvl(I.AQPA360CCO, 0)) /
                        ln_ratioD;
          
          end if;
        
        else
          ln_ratio := 0;
        
        end if; --descomentar cuando se tenga la cuota caja
      
        update AQPA360 a
           set a.AQPA360resn  = ln_acum,
               a.AQPA360ratio = ln_ratio,
               --  a.AQPA360cpo   = ln_cuoPoten,
               a.AQPA360mso = ln_mtoSol,
               a.AQPA360efe = ln_mtoTot
        --   a.AQPA360cco   = ln_cuoContT
         where a.AQPA360inste = pn_ins
           and a.aqpa360pgcod = ln_pgcod
           and a.aqpa360itsuc = ln_itsuc
           and a.aqpa360itmod = ln_itmod
           and a.aqpa360ittran = ln_ittran
           and a.aqpa360itnrel = ln_itnrel
           and a.aqpa360itord = ln_itord
           and a.aqpa360itsbor = ln_itsbor
           and a.aqpa360fec = ld_FecProc
           and a.AQPA360esta = 'S'
           and a.aqpa360estatr = 'I'
           and a.AQPA360corr = i.AQPA360corr;
        commit;
      
        ln_acum_ant := ln_acum;
        ln_cuo_ant  := i.AQPA360cuoc;
      end loop;
    
    else
    
      for i in registros loop
      
        if i.AQPA360corr = ln_corrMin then
          --primer registro
          ln_acum := nvl(ln_mtoTot, 0) + nvl(i.AQPA360flujo, 0);
        else
          ln_acum := nvl(ln_acum_ant, 0) + nvl(i.AQPA360flujo, 0) -
                     nvl(ln_cuo_ant, 0);
        
        end if;
        if nvl(i.AQPA360cuoc, 0) <> 0 then
          ln_ratioD := nvl(ln_acum, 0) + nvl(i.AQPA360ifis, 0) +
                       nvl(i.aqpa360cpo, 0);
          if ln_ratioD = 0 then
            ln_ratio := 0;
          else
            ln_ratio := (nvl(i.AQPA360cuoc, 0) + nvl(i.AQPA360ifis, 0) +
                        nvl(i.aqpa360cpo, 0) + nvl(i.aqpa360cco, 0)) /
                        ln_ratioD;
          
          end if;
        
        else
          ln_ratio := 0;
        
        end if; --descomentar cuando se tenga la cuota caja
      
        update AQPA360 a
           set a.AQPA360resn  = ln_acum,
               a.AQPA360ratio = ln_ratio,
               --   a.AQPA360cpo   = ln_cuoPoten,
               a.AQPA360mso = ln_mtoSol,
               a.AQPA360efe = ln_mtoTot --,
        --   a.AQPA360cco   = ln_cuoContT
         where a.AQPA360inste = pn_ins
           and a.aqpa360pgcod = ln_pgcod
           and a.aqpa360itsuc = ln_itsuc
           and a.aqpa360itmod = ln_itmod
           and a.aqpa360ittran = ln_ittran
           and a.aqpa360itnrel = ln_itnrel
           and a.aqpa360itord = ln_itord
           and a.aqpa360itsbor = ln_itsbor
           and a.aqpa360fec = ld_FecProc
           and a.AQPA360esta = 'S'
           and a.aqpa360estatr = 'I'
           and a.AQPA360corr = i.AQPA360corr;
      
        commit;
      
        ln_acum_ant := ln_acum;
        ln_cuo_ant  := i.AQPA360cuoc;
      
      end loop;
    
    end if;
  
  end sp_cr_recalculaRN;
  --------------------------------------------------------------------
  procedure sp_cr_UpRN_AQPA358(ln_instancia in number,
                               ln_pgcod     in number,
                               ln_itsuc     in number,
                               ln_itmod     in number,
                               ln_ittran    in number,
                               ln_itnrel    in number,
                               ln_itord     in number,
                               ln_itsbor    in number,
                               ld_FecProc   in date) is
  
    cursor reg_AQPA360 is
      select b.aqpa360fcon LD_fchcalend, b.aqpa360resn ln_NewRN
        from aqpa360 B
       WHERE B.AQPA360INSTL = ln_instancia
         and b.aqpa360pgcod = ln_pgcod
         and b.aqpa360itsuc = ln_itsuc
         and b.aqpa360itmod = ln_itmod
         and b.aqpa360ittran = ln_ittran
         and b.aqpa360itnrel = ln_itnrel
         and b.aqpa360itord = ln_itord
         and b.aqpa360itsbor = ln_itsbor
         and b.aqpa360estatr = 'I'
       order by b.aqpa360fcon;
  
  begin
  
    for r in reg_AQPA360 loop
    
      begin
        update aqpa358 a
           set a.aqpa358resneto = r.ln_newrn
         where a.aqpa358instl = ln_instancia
           and a.aqpa358pgcod = ln_pgcod
           and a.aqpa358itsuc = ln_itsuc
           and a.aqpa358itmod = ln_itmod
           and a.aqpa358ittran = ln_ittran
           and a.aqpa358itnrel = ln_itnrel
           and a.aqpa358itord = ln_itord
           and a.aqpa358itsbor = ln_itsbor
           and a.aqpa358fec = ld_FecProc
           and a.aqpa358fecal = r.ld_fchcalend
           and a.aqpa358est = 'I';
      end;
    
    end loop;
    commit;
  
  end sp_cr_UpRN_AQPA358;

  -------------------------------------------------------------------
  procedure sp_cr_UpEstado(ln_pgcod   in number,
                           ln_itsuc   in number,
                           ln_itmod   in number,
                           ln_ittran  in number,
                           ln_itnrel  in number,
                           ln_itord   in number,
                           ln_itsbor  in number,
                           ld_FecProc in date) is
  
    ln_InstLinea number := 0;
    ln_pgcod116  number := 0;
    ln_mod116    number := 0;
    ln_tope116   number := 0;
    ln_suc116    number := 0;
    ln_mda116    number := 0;
    ln_pap116    number := 0;
    ln_cta116    number := 0;
    ln_oper116   number := 0;
    ln_sbop116   number := 0;
    ln_mod117    number := 0;
    ln_suc117    number := 0;
    ln_mda117    number := 0;
    ln_pap117    number := 0;
    ln_cta117    number := 0;
    ln_oper117   number := 0;
    ln_sbop117   number := 0;
    ln_tope117   number := 0;
  
  begin
  
    begin
      select f.pgcod,
             f.modulo,
             f.ittope,
             f.itsucd,
             f.moneda,
             f.papel,
             f.ctnro,
             f.itoper,
             f.itsubo
        into ln_pgcod116,
             ln_mod116,
             ln_tope116,
             ln_suc116,
             ln_mda116,
             ln_pap116,
             ln_cta116,
             ln_oper116,
             ln_sbop116
        from fsd016 f
       where f.pgcod = ln_pgcod
         and f.itsuc = ln_itsuc
         and f.itmod = ln_itmod
         and f.ittran = ln_ittran
         and f.itnrel = ln_itnrel
         and f.itord = ln_itord
         and f.itsbor = ln_itsbor;
    exception
      when others then
        ln_pgcod116 := 0;
        ln_mod116   := 0;
        ln_tope116  := 0;
        ln_suc116   := 0;
        ln_mda116   := 0;
        ln_pap116   := 0;
        ln_cta116   := 0;
        ln_oper116  := 0;
        ln_sbop116  := 0;
    end;
  
    begin
      select r2mod, r2suc, r2mda, r2pap, r2cta, r2oper, r2sbop, r2tope
        into ln_mod117,
             ln_suc117,
             ln_mda117,
             ln_pap117,
             ln_cta117,
             ln_oper117,
             ln_sbop117,
             ln_tope117
        from fsr011 f
       where f.r1cod = ln_pgcod116
         and f.r1mod = ln_mod116
         and f.r1suc = ln_suc116
         and f.r1cta = ln_cta116
         and f.r1oper = ln_oper116
         and f.r1sbop = ln_sbop116
         and f.r1mda = ln_mda116
         and f.r1pap = ln_pap116
         and f.r1tope = ln_tope116
         and f.relcod = 46;
    exception
      when others then
        ln_mod117  := 0;
        ln_suc117  := 0;
        ln_mda117  := 0;
        ln_pap117  := 0;
        ln_cta117  := 0;
        ln_oper117 := 0;
        ln_sbop117 := 0;
        ln_tope117 := 0;
    end;
  
    begin
      ln_InstLinea := fn_instancia_credito(v_Scmod  => ln_mod117,
                                           v_Scsuc  => ln_suc117,
                                           v_Scmda  => ln_mda117,
                                           v_Scpap  => ln_pap117,
                                           v_Sccta  => ln_cta117,
                                           v_Scoper => ln_oper117,
                                           v_Scsbop => ln_sbop117,
                                           v_Sctope => ln_tope117);
    end;
  
    begin
    
      update aqpa357 a
         set a.aqpa357est = 'H'
       where a.aqpa357fec = ld_FecProc
         and a.aqpa357instl = ln_InstLinea
         and a.aqpa357pgcod = ln_pgcod
         and a.aqpa357itsuc = ln_itsuc
         and a.aqpa357itmod = ln_itmod
         and a.aqpa357ittran = ln_ittran
         and a.aqpa357itnrel = ln_itnrel
         and a.aqpa357itord = ln_itord
         and a.aqpa357itsbor = ln_itsbor
         and a.aqpa357est = 'I';
    
    end;
  
    begin
      update aqpa358 a
         set a.aqpa358est = 'H'
       where a.aqpa358fec = ld_FecProc
         and a.aqpa358instl = ln_InstLinea
         and a.aqpa358pgcod = ln_pgcod
         and a.aqpa358itsuc = ln_itsuc
         and a.aqpa358itmod = ln_itmod
         and a.aqpa358ittran = ln_ittran
         and a.aqpa358itnrel = ln_itnrel
         and a.aqpa358itord = ln_itord
         and a.aqpa358itsbor = ln_itsbor
         and a.aqpa358est = 'I';
    end;
  
    begin
      update aqpa359 a
         set a.aqpa359est = 'H'
       where a.aqpa359fec = ld_FecProc
         and a.aqpa359instl = ln_InstLinea
         and a.aqpa359pgcod = ln_pgcod
         and a.aqpa359itsuc = ln_itsuc
         and a.aqpa359itmod = ln_itmod
         and a.aqpa359ittran = ln_ittran
         and a.aqpa359itnrel = ln_itnrel
         and a.aqpa359itord = ln_itord
         and a.aqpa359itsbor = ln_itsbor
         and a.aqpa359est = 'I';
    end;
  
    begin
    
      update aqpa360 a
         set a.aqpa360estatr = 'H'
       where a.aqpa360fec = ld_FecProc
         and a.aqpa360instl = ln_InstLinea
         and a.aqpa360pgcod = ln_pgcod
         and a.aqpa360itsuc = ln_itsuc
         and a.aqpa360itmod = ln_itmod
         and a.aqpa360ittran = ln_ittran
         and a.aqpa360itnrel = ln_itnrel
         and a.aqpa360itord = ln_itord
         and a.aqpa360itsbor = ln_itsbor
         and a.aqpa360estatr = 'I';
    
    end;
  
  end sp_cr_UpEstado;
  ---------------------------------------------------------
  procedure sp_cr_ExtornarREF(ln_pgcod   in number,
                              ln_itsuc   in number,
                              ln_itmod   in number,
                              ln_ittran  in number,
                              ln_itrel   in number,
                              ln_itord   in number,
                              ln_itsbor  in number,
                              ld_FecProc in date) is
  
    ln_NroRelacion number;
    ln_itmod1      number := ln_itmod + 500;
    ln_InstLinea   number := 0;
    ln_pgcod116    number := 0;
    ln_mod116      number := 0;
    ln_tope116     number := 0;
    ln_suc116      number := 0;
    ln_mda116      number := 0;
    ln_pap116      number := 0;
    ln_cta116      number := 0;
    ln_oper116     number := 0;
    ln_sbop116     number := 0;
    ln_mod117      number := 0;
    ln_suc117      number := 0;
    ln_mda117      number := 0;
    ln_pap117      number := 0;
    ln_cta117      number := 0;
    ln_oper117     number := 0;
    ln_sbop117     number := 0;
    ln_tope117     number := 0;
  
  begin
  
    begin
      select f.pgcod,
             f.modulo,
             f.ittope,
             f.itsucd,
             f.moneda,
             f.papel,
             f.ctnro,
             f.itoper,
             f.itsubo
        into ln_pgcod116,
             ln_mod116,
             ln_tope116,
             ln_suc116,
             ln_mda116,
             ln_pap116,
             ln_cta116,
             ln_oper116,
             ln_sbop116
        from fsd016 f
       where f.pgcod = ln_pgcod
         and f.itsuc = ln_itsuc
         and f.itmod = ln_itmod
         and f.ittran = ln_ittran
         and f.itnrel = ln_itrel
         and f.itord = ln_itord
         and f.itsbor = ln_itsbor;
    exception
      when others then
        ln_pgcod116 := 0;
        ln_mod116   := 0;
        ln_tope116  := 0;
        ln_suc116   := 0;
        ln_mda116   := 0;
        ln_pap116   := 0;
        ln_cta116   := 0;
        ln_oper116  := 0;
        ln_sbop116  := 0;
    end;
  
    begin
      select r2mod, r2suc, r2mda, r2pap, r2cta, r2oper, r2sbop, r2tope
        into ln_mod117,
             ln_suc117,
             ln_mda117,
             ln_pap117,
             ln_cta117,
             ln_oper117,
             ln_sbop117,
             ln_tope117
        from fsr011 f
       where f.r1cod = ln_pgcod116
         and f.r1mod = ln_mod116
         and f.r1suc = ln_suc116
         and f.r1cta = ln_cta116
         and f.r1oper = ln_oper116
         and f.r1sbop = ln_sbop116
         and f.r1mda = ln_mda116
         and f.r1pap = ln_pap116
         and f.r1tope = ln_tope116
         and f.relcod = 46;
    exception
      when others then
        ln_mod117  := 0;
        ln_suc117  := 0;
        ln_mda117  := 0;
        ln_pap117  := 0;
        ln_cta117  := 0;
        ln_oper117 := 0;
        ln_sbop117 := 0;
        ln_tope117 := 0;
    end;
  
    begin
      ln_InstLinea := fn_instancia_credito(v_Scmod  => ln_mod117,
                                           v_Scsuc  => ln_suc117,
                                           v_Scmda  => ln_mda117,
                                           v_Scpap  => ln_pap117,
                                           v_Sccta  => ln_cta117,
                                           v_Scoper => ln_oper117,
                                           v_Scsbop => ln_sbop117,
                                           v_Sctope => ln_tope117);
    end;
  
    begin
      select to_number(Txtext)
        into ln_NroRelacion
        from FSX015
       Where PgCod = ln_pgcod
         and Hcmod = ln_itmod1
         and Hsucor = ln_itsuc
         and Htran = ln_ittran
         and Hnrel = ln_itrel
         and Hfcon = ld_FecProc
         and Txcod = 0
         and Txreng = 1;
    exception
      when others then
        null;
    end;
  
    begin
    
      update aqpa357 a
         set a.aqpa357est = 'E'
       where a.aqpa357fec = ld_FecProc
         and a.aqpa357instl = ln_InstLinea
         and a.aqpa357pgcod = ln_pgcod
         and a.aqpa357itsuc = ln_itsuc
         and a.aqpa357itmod = ln_itmod
         and a.aqpa357ittran = ln_ittran
         and a.aqpa357itnrel = ln_NroRelacion
         and a.aqpa357itord = ln_itord
         and a.aqpa357itsbor = ln_itsbor
         and a.aqpa357est = 'H';
    
    end;
  
    begin
      update aqpa358 a
         set a.aqpa358est = 'E'
       where a.aqpa358fec = ld_FecProc
         and a.aqpa358instl = ln_InstLinea
         and a.aqpa358pgcod = ln_pgcod
         and a.aqpa358itsuc = ln_itsuc
         and a.aqpa358itmod = ln_itmod
         and a.aqpa358ittran = ln_ittran
         and a.aqpa358itnrel = ln_NroRelacion
         and a.aqpa358itord = ln_itord
         and a.aqpa358itsbor = ln_itsbor
         and a.aqpa358est = 'H';
    end;
  
    begin
      update aqpa359 a
         set a.aqpa359est = 'E'
       where a.aqpa359fec = ld_FecProc
         and a.aqpa359instl = ln_InstLinea
         and a.aqpa359pgcod = ln_pgcod
         and a.aqpa359itsuc = ln_itsuc
         and a.aqpa359itmod = ln_itmod
         and a.aqpa359ittran = ln_ittran
         and a.aqpa359itnrel = ln_NroRelacion
         and a.aqpa359itord = ln_itord
         and a.aqpa359itsbor = ln_itsbor
         and a.aqpa359est = 'H';
    end;
  
  end sp_cr_ExtornarREF;
  -------------------------------------------------------------
end PQ_CR_RATIO_EVALFLUJO_RTE;
/

