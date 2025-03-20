create or replace package pq_cr_modulo_campanias is

  /* ************************************************************************************************************
      -- Nombre                     : pq_cr_modulo_campanias
      -- Sistema                    : BANTOTAL
      -- Módulo                     : CREDITOS
      -- Descripción                : 
      -- Versión                    : 1.0
      -- Fecha de Creación          : 
      -- Autor de Creación          : 
      -- Estado                     : Activo
      -- Acceso                     : Público
      -- Fecha de Modificación      : 13/02/2020
      -- Autor de la Modificación   : Cinthya Liz Hernandez Ortega
      -- Descripción de Modificación: se eliminó break al consultar campañas usuarios reemplazo sp_verificar
      --                            : 2024.08.16 dcastro se modifico procedimiento sp_jaqm80_TUN y se agrego llamada a procedimiento SP_CR_UPDATE_FECHA_SNG001 para actualizar sng001fin en flujo reducido cuando sng001fin sea 01/01/0001  
      -- Fecha de Modificación      : 17/10/2024
      -- Autor de la Modificación   : Maria Caridad Postigo Condori
      -- Descripción de Modificación: Se agrego una guia para validar que tipos de docuemtno deben tener desgravamen
    
  * *************************************************************************************************************/
  Procedure Sp_ultima_eva(pn_pai  in number,
                          pn_tdo  in number,
                          pc_ndo  in char,
                          p_error out char,
                          pn_eva  out number,
                          pn_moe  out number);

  Procedure Sp_insert_bandeja1(pn_pai    in number,
                               pn_tdo    in number,
                               pc_ndo    in char,
                               pn_pzo    in number,
                               pd_fecpro in date,
                               pn_mto    in number,
                               pn_cuo    in number,
                               pn_cta    in number,
                               pc_ase    in char,
                               pn_mod    in number,
                               pn_top    in number,
                               pn_suc    in number,
                               pn_mda    in number,
                               pn_cor    in number, --mod@abr 20191210
                               pd_fec    in date,
                               pn_moe    in number,
                               pd_fecPri in date /*,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    pc_etapa  in char*/ -- EFUENTES 2022.05.06
                               );
  Procedure Sp_insert_bandeja2(pn_pai    in number,
                               pn_tdo    in number,
                               pc_ndo    in char,
                               pd_Fecpro in date,
                               pc_ase    in char,
                               pn_seg    in number,
                               pn_cor    in number,
                               pd_fecP   in date);
  Procedure Sp_insert_bandeja3(pn_pai  in number,
                               pn_tdo  in number,
                               pc_ndo  in char,
                               pn_corr in number,
                               pd_fecP in date, --fecha de la carga de BI
                               pn_eva  in number);
  Procedure Sp_Cr_aqpa190c(pn_eva in number);
  Procedure Sp_cr_inserta_Aqpa190d(pn_eval in number --,
                                   -- pn_evaant in number,
                                   --pd_fecpro in date --fecha de sistema
                                   );
  procedure Sp_cr_actualiza(pn_cor in number,
                            pn_pai in number,
                            pn_tdo in number,
                            pc_ndo in char,
                            pd_fec in date);
  procedure sp_cr_VerificaCtnro(pn_cta in number, pc_flg out char);
  Procedure Sp_actualizaInfo(pn_cor     in number,
                             pd_fec     in date,
                             pn_mto     in number,
                             pn_cta     in number,
                             pn_cuo     in number,
                             pn_fre     in number,
                             pn_suc     in number,
                             pn_ase     in char,
                             pn_eva     in number,
                             pd_fecprim in date,
                             pc_flg     in char,
                             pn_mtocuo  out number);
  Procedure Sp_CalculaCuota(pn_cor in number,
                            pd_fec in date,
                            pn_mto in number,
                            --pn_cta    in number,
                            pn_cuo     in number,
                            pn_fre     in number,
                            pn_suc     in number,
                            pd_fecprim in date,
                            pc_flag    in char,
                            pn_cta     in number,
                            --pn_ase    in char,
                            --pn_eva    in number,
                            pn_mtocuo out number,
                            pn_tasa   out number);
  Procedure Sp_cr_mtoCuota(pn_mod     in number,
                           pn_mda     in number,
                           pn_pap     in number,
                           pn_top     in number,
                           pn_suc     in number,
                           pn_mto     in number,
                           pn_cuo     in number,
                           pn_fre     in number,
                           pd_fecpro  in date,
                           pd_Fec     in date,
                           pc_cor     in number,
                           pc_flg     in char,
                           pd_Fecprim in date,
                           pn_cta     in number, --mod@abr 20201115
                           pn_mtoCuo  out number,
                           ln_tasa    out number);
  Procedure sp_Cr_genera_eva(pn_eva out number);
  ----------------------------------------------------
  procedure sp_cr_TasaPorPlazo(ln_cuenta in number,
                               ln_mod    in number,
                               ln_piza   in number,
                               ld_fcha   in date,
                               ln_monto  in number,
                               ln_Plazo  in number,
                               pn_tasa   out number);
  --------------------------------------------------------                               
  Procedure Sp_verificar(pn_pai in number,
                         pn_tdo in number,
                         pc_ndo in char,
                         pc_ase in char,
                         pc_flg out char,
                         pd_fec out date);
  Procedure Sp_actualizaEva(pn_cor in number,
                            pd_fec in date,
                            pn_eva in number);
  Procedure Sp_cr_tipocambio(pd_fecpro in date, pn_tipcam out number);
  Procedure Sp_validac_ampliado(pn_emp    in number,
                                pn_mod    in number,
                                pn_suc    in number,
                                pn_mda    in number,
                                pn_pap    in number,
                                pn_cta    in number,
                                pn_ope    in number,
                                pn_sbo    in number,
                                pn_top    in number,
                                pd_Fecpro in date,
                                pc_flg    out char,
                                pc_flgM   out char,
                                pc_flgVC  out char);
  procedure sp_cr_flujocaja(ln_emp10  in number,
                            ln_mod10  in number,
                            ln_suc10  in number,
                            ln_mda10  in number,
                            ln_pap10  in number,
                            ln_cta10  in number,
                            ln_oper10 in number,
                            ln_sbop10 in number,
                            ln_tope10 in number,
                            ln_flagFC out char);
  procedure sp_CalculoRatio(ln_Pepais        in number,
                            ln_Petdoc        in number,
                            ln_Pendoc        in char,
                            tipocambio       in number,
                            Instancia        in number,
                            pd_fecpro        in date,
                            lc_prgm          in varchar2,
                            ln_Usuario       in varchar2,
                            ln_captotcaja    out number,
                            saldo_externo    out number,
                            ln_ExcdntMensual out number,
                            ln_RatioConsumo  out number);
  Procedure Sp_adicional_panel(pn_mod in number,
                               pn_suc in number,
                               pn_mda in number,
                               pn_pap in number,
                               pn_cta in number,
                               pn_ope in number,
                               pn_sbo in number,
                               pn_top in number,
                               pc_flg out char);
  procedure sp_CalculoRAtioPYME(ln_Pepais     in number,
                                ln_Petdoc     in number,
                                ln_Pendoc     in char,
                                tipocambio    in number,
                                Instancia     in number,
                                pd_fecpro     in date,
                                lc_prgm       in varchar2,
                                lc_Usuario    in varchar2,
                                ln_captotcaja out number,
                                saldo_externo out number,
                                ResultNeto    out number,
                                ln_captotal   out number);
  Procedure Sp_actividadEconomica(pn_pais in number,
                                  pn_tdoc in number,
                                  pc_ndoc in char,
                                  pc_act  out char);
  Procedure sp_resolutorJAQL152(pn_pai   in number,
                                pn_tdo   in number,
                                pc_ndo   in char,
                                pn_cta   in number,
                                pc_flg   out char,
                                pc_error out char);

  procedure sp_cr_familiar_jefe_cmac(pn_pais number,
                                     pn_tdoc number,
                                     pc_ndoc character,
                                     pv_rpta out char);
  Procedure sp_validacion_pols_jaqz697(pd_Fecpro in date);
  Procedure sp_validacion_pols_aqpa861(pd_Fecpro in date);
  Procedure Sp_gasto_Financi(pn_eva in number, pn_mto out number);
  procedure sp_meses(pd_fecini in date,
                     pd_fecfin in date,
                     pn_cont   out number);
  Procedure sp_jaqm80(pd_fecpro in date, pd_fec in date, pn_cor in number);
  Procedure Sp_Cr_tasa(pd_fec    in date,
                       pn_cor    in number,
                       pd_fecpro in date,
                       pn_tas    out number);
  Procedure Sp_Cr_tasa_cta(pd_fec    in date,
                           pn_cor    in number,
                           pd_fecpro in date,
                           pn_cta    in number,
                           pn_tas    out number);
  Procedure Sp_verificaGradiente(pd_Fec in date,
                                 pn_pai in number,
                                 pn_tdo in number,
                                 pn_ndo in char,
                                 pc_flg out char);
  Procedure Sp_rechazar(pd_Fec    in date,
                        pn_cor    in number,
                        pn_pai    in number,
                        pn_tdo    in number,
                        pc_ndo    in char,
                        pd_Fecpro in date,
                        pc_mot    in char);
  Procedure sp_jaqm80_TUN(pd_fecpro in date,
                          pd_fec    in date,
                          pn_cor    in number,
                          pn_ins    in number,
                          pn_cer    in number,
                          pc_der    in char);
  Procedure sp_Procesajaqm80(pd_fecpro in date,
                             pd_fec    in date,
                             pn_cor    in number,
                             pn_ins    in number,
                             pn_cer    in number,
                             pc_der    in char);
  procedure sp_cr_plazoParalelo(pn_mda in number,
                                pn_mod in number,
                                pn_top in number,
                                pn_pzo out number); --mod@abr 17122020  
  Procedure Sp_RetornaTasa(pd_Fec    in date,
                           pn_cor    in number,
                           pd_fecpro in date,
                           pn_tasa   out number);
  Procedure Sp_eliminaDuplicado(pn_ins    in number,
                                pd_fecpro in date,
                                pc_flg    out char);
  procedure sp_TasaReducido(pn_ins  in number,
                            pn_cta  in number,
                            pn_mod  in number,
                            pn_top  in number,
                            pn_mda  in number,
                            pn_mto  in number,
                            pn_tasa out number);
  /*COMENTAR*/
  -----------------------------------------------
  -- mpostigoc 25.04.2022 Segmento del cliente en la cuenta
  procedure sp_segmntcuenta(ln_pais     in number,
                            ln_tdoc     in number,
                            lc_ndoc     in varchar2, --preguntar lc_ndoc     varchar2,
                            ln_cuenta   in number,
                            ln_SegmnCta out number);
  -------------------------------------------------   
  procedure sp_agregatasa(ln_corr in number, ld_fcorr date);
  -------------------------------------------------   
  procedure sp_cr_generar_cupon(ln_corr  in number,
                                ld_fcorr date,
                                pn_pai   in number,
                                pn_tdo   in number,
                                pc_ndo   in varchar2);
  -------------------------------------------------
  procedure Sp_aprobar_cupon(pd_Fec in date,
                             pn_cor in number,
                             pc_res in char);
  ------------------------------------------------------------
  procedure sp_cr_ciuu(ln_pais in number,
                       ln_tdoc in number,
                       lc_ndoc in varchar2,
                       ln_ciiu out number);
  -------------------------------------------------------------
  procedure sp_cr_SegMultiRisk(ln_pais   in number,
                               ln_tdoc   in number,
                               lc_ndoc   in varchar2,
                               ln_moe    in number,
                               ln_mda    in number,
                               ln_frec   in number,
                               pd_fecpro in date,
                               pn_mto    in number,
                               pn_mod    in number,
                               ln_Corr   in number);
  ----------------------------------------------------------

  Procedure Sp_insert_seguros(pn_pai    in number,
                              pn_tdo    in number,
                              pc_ndo    in char,
                              pn_cor    in number,
                              pd_fec    in date,
                              ln_Corr   in number,
                              pd_fecpro in date,
                              pc_flag   out char);

-------------------------------------------------------------
end pq_cr_modulo_campanias;
/

create or replace package body pq_cr_modulo_campanias is

  Procedure Sp_ultima_eva(pn_pai  in number,
                          pn_tdo  in number,
                          pc_ndo  in char,
                          p_error out char,
                          pn_eva  out number,
                          pn_moe  out number) is
    ld_MaxFchDesemb date;
    ln_pgcod        number(3);
    ln_modulo       number(3);
    ln_sucursal     number(3);
    ln_moneda       number(4);
    ln_papel        number(4);
    ln_cuenta       number(9);
    ln_operacion    number(9);
    ln_suboper      number(3);
    ln_tipooper     number(3);
    ln_instORI      number(10);
    L_FECHA         date;
  begin
    begin
      select pgfape into L_FECHA from fst017 where pgcod = 1;
      select max(g.aofval)
        into ld_MaxFchDesemb
        from fsd010 g
       where g.pgcod = 1
         and (g.aomod in (select modulo
                            from fst111
                           where dscod = 50
                             and modulo not in (33, 200, 108)) or
             g.aomod = 117)
         and g.aocta in (select f.ctnro
                           from fsr008 f
                          where f.pepais = pn_pai
                            and f.petdoc = pn_tdo
                            and f.pendoc = pc_ndo
                            and f.cttfir = 'T');
    exception
      when no_data_found then
        p_error := 'No se encontro evaluacion para este cliente';
        return;
    end;
  
    begin
      select g.pgcod,
             g.aomod,
             g.aosuc,
             g.aomda,
             g.aopap,
             g.aocta,
             g.aooper,
             g.aosbop,
             g.aotope
        into ln_pgcod,
             ln_modulo,
             ln_sucursal,
             ln_moneda,
             ln_papel,
             ln_cuenta,
             ln_operacion,
             ln_suboper,
             ln_tipooper
      
        from fsd010 g
       where g.pgcod = 1
         and (g.aomod in (select modulo
                            from fst111
                           where dscod = 50
                             and modulo not in (33, 200, 108)) or
             g.aomod = 117)
         and g.aocta in (select f.ctnro
                           from fsr008 f
                          where f.pepais = pn_pai
                            and f.petdoc = pn_tdo
                            and f.pendoc = pc_ndo
                            and f.cttfir = 'T')
         and g.aofval = ld_MaxFchDesemb
         and rownum = 1;
    exception
      when no_data_found then
        p_error := 'No se encontro evaluacion para este cliente';
        return;
    end;
  
    begin
      ln_instORI := fn_instancia_credito(v_Scmod  => ln_modulo,
                                         v_Scsuc  => ln_sucursal,
                                         v_Scmda  => ln_moneda,
                                         v_Scpap  => ln_papel,
                                         v_Sccta  => ln_cuenta,
                                         v_Scoper => ln_operacion,
                                         v_Scsbop => ln_suboper,
                                         v_Sctope => ln_tipooper);
    exception
      when no_data_found then
        p_error := 'No se encontro evaluacion para este cliente';
        return;
    end;
  
    begin
      select x.sng021eval, x.sng021tmod
        into pn_eva, pn_moe
        from sng021 x
       where x.sng021sol = ln_instORI; --Evaluacion Origen
    exception
      when no_data_found then
        p_error := 'No se encontro evaluacion para este cliente';
        return;
    end;
  
    /*begin
        select
          from sng023 a
         where a.sng021eval =
           and a.sng026cod =;
     exception
      when no_data_found then
        p_error := 'No se encontro evaluacion para este cliente';
        return;
    end;*/
  
  end Sp_ultima_eva;

  Procedure Sp_insert_bandeja1(pn_pai    in number,
                               pn_tdo    in number,
                               pc_ndo    in char,
                               pn_pzo    in number,
                               pd_fecpro in date,
                               pn_mto    in number,
                               pn_cuo    in number,
                               pn_cta    in number,
                               pc_ase    in char,
                               pn_mod    in number,
                               pn_top    in number,
                               pn_suc    in number,
                               pn_mda    in number,
                               pn_cor    in number, --mod@abr 20191210
                               pd_fec    in date,
                               pn_moe    in number, /*,pn_eva    in number*/
                               pd_fecPri in date /*,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    pc_etapa  in char*/) is
    -- EFUENTES 2022.06.09
  
    ld_Fecaux    date;
    lc_hab       char(1) := 'N';
    ln_cont      number(5);
    pd_fecprim   date;
    pn_HisNR     number(1);
    ln_Corr      number(9);
    lc_estado    char(1);
    ln_flgProc   number(5) := 0;
    ln_seg       number(5);
    ln_Cor751    number(9);
    lc_existe    char(1) := 'N';
    lc_flgAmpl   char(30) := 'N'; --mod@abr 20200129
    ln_mod       number(3);
    ln_suc       number(3);
    ln_mda       number(4);
    ln_pap       number(4);
    ln_cta       number(9);
    ln_ope       number(9);
    ln_sbo       number(3);
    ln_top       number(3);
    ln_Cor751Mod number(9);
    ln_Cor751Suc number(9);
    ln_Cor751Mda number(9);
    ln_Cor751Pap number(9);
    ln_Cor751Cta number(9);
    ln_Cor751Ope number(9);
    ln_Cor751Sbo number(9);
    ln_Cor751Top number(9);
    lc_reactiva  char(1) := 'N'; --mod@abr 20200623
  
    pc_flagSeg  char(1);
    ln_CorEtapa number(9);
    my_errm     VARCHAR2(32000);
    --0 se ejecuta proceso de fintech
    --1 se ejecuta proceso de flujo online
  
    ln_OkDesgravmn number := 0;
  
  begin
  
    --mod@abr 20200623
    begin
      select 'S'
        into lc_reactiva
        from fst198 a
       where a.tp1cod = 1
         and a.TP1COD1 = 11141
         and a.tp1corr1 = 11
         and a.tp1corr2 = 1
         and a.tp1nro1 = pn_mod
         and a.tp1nro2 = pn_top;
    exception
      when others then
        null;
    end;
    --mod@abr 20200623
  
    begin
      select 'S'
        into lc_existe
        from jaqz697 j, jaqm750 k
       where j.jaqz697pai = k.jaqm750pai
         and j.jaqz697tdo = k.jaqm750tdo
         and j.jaqz697ndo = k.jaqm750ndo
         and j.jaqz697suc = k.jaqm750suc
         and j.jaqz697mda = k.jaqm750mda
         and j.jaqz697cta = k.jaqm750cta
         and j.jaqz697mod = k.jaqm750mod
         and j.jaqz697top = k.jaqm750tip
         and j.jaqz697pai = pn_pai
         and j.jaqz697tdo = pn_tdo
         and j.jaqz697ndo = pc_ndo
         and j.jaqz697cor = pn_cor --mod@abr 20191210
         and k.jaqm750fch >= j.jaqz697fep
         and rownum = 1;
    exception
      when others then
        null;
    end;
  
    if nvl(lc_existe, 'N') = 'N' then
      --**Verifica si es ampliado**--
      begin
        select a.jaqz697tip,
               a.jaqz697moa,
               a.jaqz697sua,
               a.jaqz697maa,
               a.jaqz697paa,
               a.jaqz697caa,
               a.jaqz697opa,
               a.jaqz697sba,
               a.jaqz697toa
          into lc_flgAmpl,
               ln_mod,
               ln_suc,
               ln_mda,
               ln_pap,
               ln_cta,
               ln_ope,
               ln_sbo,
               ln_top
          from jaqz697 a
         where a.jaqz697pai = pn_pai
           and a.jaqz697tdo = pn_tdo
           and a.jaqz697ndo = pc_ndo
           and a.jaqz697cor = pn_cor
           and a.jaqz697fep = pd_fec;
      exception
        when others then
          null;
      end;
    
      begin
        select a.tp1nro1
          into ln_flgProc
          from fst198 a
         where a.tp1cod = 1
           and a.tp1cod1 = 10899
           and a.tp1corr1 = 77777
           and a.tp1corr2 = 1
           and a.tp1corr3 = 1;
      exception
        when others then
          ln_flgProc := 0;
      end;
    
      if nvl(ln_flgProc, 0) = 0 then
        --flujo express
        begin
          select TRIM(a.tp1desc)
            into lc_estado
            from fst198 a
           where a.tp1cod = 1
             and a.tp1cod1 = 10899
             and a.tp1corr1 = 77777
             and a.tp1corr2 = 2
             and a.tp1corr3 = 2;
        exception
          when others then
            null;
        end;
      else
        --flujo online
        begin
          select trim(a.tp1desc)
            into lc_estado
            from fst198 a
           where a.tp1cod = 1
             and a.tp1cod1 = 10899
             and a.tp1corr1 = 77777
             and a.tp1corr2 = 2
             and a.tp1corr3 = 1;
        exception
          when others then
            null;
        end;
      end if;
    
      ---------FECHA PRIMER PAGO--------------
      --ld_Fecaux := pd_fecpro + pn_pzo;
      ld_Fecaux := pd_fecPri;
      --verificar si es dia habil
      begin
        select a.fhabil
          into lc_hab
          from fst028 a, fst001 b
         where a.calcod = b.calcod
           and a.ffecha = ld_Fecaux
           and b.sucurs = pn_suc;
      exception
        when others then
          null;
      end;
    
      if nvl(lc_hab, 'N') = 'N' then
        begin
          select min(a.ffecha)
            into pd_fecprim
            from fst028 a, fst001 b
           where a.calcod = b.calcod
             and a.ffecha > ld_Fecaux
             and b.sucurs = pn_suc
             and a.fhabil = 'S';
        exception
          when others then
            null;
        end;
      else
        pd_fecprim := ld_Fecaux;
      end if;
    
      ---------------------NUEVO/RECURRENTE-----------------
      Pq_Cr_Relcrediticia.Sp_RelCredi_NR(pn_pai      => pn_pai,
                                         pn_tdo      => pn_tdo,
                                         pc_ndo      => pc_ndo,
                                         pd_Fecpro   => pd_fecpro,
                                         ln_contador => ln_cont);
    
      if ln_cont >= 6 then
        pn_HisNR := 2; --Recurrente
      end if;
    
      if ln_cont < 6 then
        pn_HisNR := 1; --Nuevo
      end if;
    
      if nvl(ln_flgProc, 0) = 0 then
        --proceso fintech
        begin
          select nvl(max(jaqm750reg), 0) + 1
            into ln_Corr
            from jaqm750
           where jaqm750fch = pd_fecpro
             and jaqm750reg < 1000000;
        exception
          when others then
            ln_Corr := null;
        end;
      
        if nvl(ln_Corr, 0) = 0 then
          ln_Corr := 1;
        end if;
      
      else
        --proceso flujo online
        begin
          select nvl(max(jaqm750reg), 0) + 1
            into ln_Corr
            from jaqm750
           where jaqm750fch = pd_fecpro
             and jaqm750reg >= 1000000;
        exception
          when others then
            ln_Corr := null;
        end;
      
        if nvl(ln_Corr, 0) = 1 then
          ln_Corr := 1000000;
        end if;
      
      end if;
      lc_flgAmpl := nvl(lc_flgAmpl, 'N');
      if lc_flgAmpl = 'N' then
        --mod@abr 20210505
        if pn_mod = 117 then
          Insert into JAQM750
          values
            (1,
             pd_fecpro,
             ln_Corr,
             pn_pai,
             pn_tdo,
             pc_ndo,
             0,
             11,
             pn_HisNR,
             pn_mod,
             pn_top,
             pn_suc,
             pn_mda,
             0,
             pn_cta,
             pc_ase,
             2,
             1,
             pd_fecprim,
             pn_mto,
             pn_cuo,
             pn_pzo,
             lc_estado);
        
          commit;
        else
          Insert into JAQM750
          values
            (1,
             pd_fecpro,
             ln_Corr,
             pn_pai,
             pn_tdo,
             pc_ndo,
             0,
             0,
             pn_HisNR,
             pn_mod,
             pn_top,
             pn_suc,
             pn_mda,
             0,
             pn_cta,
             pc_ase,
             2,
             1,
             pd_fecprim,
             pn_mto,
             pn_cuo,
             pn_pzo,
             lc_estado);
        
          commit;
        end if;
        ---INSERTAR JAQM751 SEGUROS
        if nvl(lc_reactiva, 'N') = 'N' then
          --  Registrar seguros adicionales 
          pq_cr_modulo_campanias.Sp_insert_seguros(pn_pai,
                                                   pn_tdo,
                                                   pc_ndo,
                                                   pn_cor,
                                                   pd_fec,
                                                   ln_Corr,
                                                   pd_fecpro,
                                                   pc_flagSeg);
          --MPOSTIGOC 13/10/2022 SE AGREGO MULTIRIESGO
        
          pq_cr_modulo_campanias.sp_cr_SegMultiRisk(ln_pais   => pn_pai,
                                                    ln_tdoc   => pn_tdo,
                                                    lc_ndoc   => pc_ndo,
                                                    ln_moe    => pn_moe,
                                                    ln_mda    => pn_mda,
                                                    ln_frec   => pn_pzo,
                                                    pd_fecpro => pd_fecpro,
                                                    pn_mto    => pn_mto,
                                                    pn_mod    => pn_mod,
                                                    ln_Corr   => ln_Corr);
          --------------------------------------
          --mpostigoc 17/10/2024
          begin
            select count(*)
              into ln_OkDesgravmn
              from fst198 f
             where f.tp1cod = 1
               and f.tp1cod1 = 10899
               and f.tp1corr1 = 137
               and f.tp1corr2 = 1
               and f.tp1corr3 > 0
               and f.tp1nro3 = pn_tdo;
          exception
            when others then
              null;
          end;
        
          ln_OkDesgravmn := nvl(ln_OkDesgravmn, 0);
        
          if ln_OkDesgravmn > 0 then
            begin
              -- Desgravamen
              begin
                select a.tp1nro1
                  into ln_seg
                  from fst198 a
                 where a.tp1cod = 1
                   and a.tp1cod1 = 10899
                   and a.tp1corr1 = 77777
                   and a.tp1corr2 = 3
                   and a.tp1nro2 = pn_pzo
                   and a.tp1nro3 = pn_moe;
              exception
                when others then
                  ln_seg := 0;
              end;
            
              begin
                select nvl(max(a.jaqm751cor), 0) + 1
                  into ln_Cor751
                  from jaqm751 a
                 where a.jaqm751emp = 1
                   and a.jaqm751fch = pd_fecpro
                   and a.jaqm751att = 'SEGCOD'
                   and a.jaqm751reg = ln_Corr;
              exception
                when others then
                  ln_Cor751 := null;
              end;
            
              if nvl(ln_Cor751, 0) = 1 then
                ln_Cor751 := 1;
              end if;
            
              insert into jaqm751
                (jaqm751emp,
                 jaqm751fch,
                 jaqm751reg,
                 jaqm751att,
                 jaqm751cor,
                 jaqm751val)
              values
                (1, pd_fecpro, ln_Corr, 'SEGCOD', ln_Cor751, ln_seg);
              commit;
            end;
          
          end if;
        end if;
      end if;
    
      if lc_flgAmpl = 'A' then
        Insert into JAQM750
        values
          (1,
           pd_fecpro,
           ln_Corr,
           pn_pai,
           pn_tdo,
           pc_ndo,
           0,
           4, --tipo de solicitud ampliacion
           pn_HisNR,
           pn_mod,
           pn_top,
           pn_suc,
           pn_mda,
           0,
           pn_cta,
           pc_ase,
           2,
           1,
           pd_fecprim,
           pn_mto,
           pn_cuo,
           pn_pzo,
           lc_estado);
      
        commit;
      
        ---INSERTAR JAQM751 SEGUROS
        if nvl(lc_reactiva, 'N') = 'N' then
          --  Registrar seguros adicionales 
          pq_cr_modulo_campanias.Sp_insert_seguros(pn_pai,
                                                   pn_tdo,
                                                   pc_ndo,
                                                   pn_cor,
                                                   pd_fec,
                                                   ln_Corr,
                                                   pd_fecpro,
                                                   pc_flagSeg);
          --MPOSTIGOC 13/10/2022 SE AGREGO MULTIRIESGO
        
          pq_cr_modulo_campanias.sp_cr_SegMultiRisk(ln_pais   => pn_pai,
                                                    ln_tdoc   => pn_tdo,
                                                    lc_ndoc   => pc_ndo,
                                                    ln_moe    => pn_moe,
                                                    ln_mda    => pn_mda,
                                                    ln_frec   => pn_pzo,
                                                    pd_fecpro => pd_fecpro,
                                                    pn_mto    => pn_mto,
                                                    pn_mod    => pn_mod,
                                                    ln_Corr   => ln_Corr);
          ---------------------------------------------------------                                                    
          begin
            select a.tp1nro1
              into ln_seg
              from fst198 a
             where a.tp1cod = 1
               and a.tp1cod1 = 10899
               and a.tp1corr1 = 77777
               and a.tp1corr2 = 3
               and a.tp1nro2 = pn_pzo
               and a.tp1nro3 = pn_moe;
          exception
            when others then
              ln_seg := 0;
          end;
        
          begin
            select nvl(max(a.jaqm751cor), 0) + 1
              into ln_Cor751
              from jaqm751 a
             where a.jaqm751emp = 1
               and a.jaqm751fch = pd_fecpro
               and a.jaqm751att = 'SEGCOD'
               and a.jaqm751reg = ln_Corr;
          exception
            when others then
              ln_Cor751 := null;
          end;
        
          if nvl(ln_Cor751, 0) = 1 then
            ln_Cor751 := 1;
          end if;
        
          insert into jaqm751
            (jaqm751emp,
             jaqm751fch,
             jaqm751reg,
             jaqm751att,
             jaqm751cor,
             jaqm751val)
          values
            (1, pd_fecpro, ln_Corr, 'SEGCOD', ln_Cor751, ln_seg);
        
          commit;
        end if;
        ---correlativo modulo
        begin
          select nvl(max(a.jaqm751cor), 0) + 1
            into ln_Cor751Mod
            from jaqm751 a
           where a.jaqm751emp = 1
             and a.jaqm751fch = pd_fecpro
             and a.jaqm751att = 'MODULO'
             and a.jaqm751reg = ln_Corr;
        exception
          when others then
            ln_Cor751Mod := null;
        end;
      
        if nvl(ln_Cor751Mod, 0) = 1 then
          ln_Cor751Mod := 1;
        end if;
      
        insert into jaqm751
          (jaqm751emp,
           jaqm751fch,
           jaqm751reg,
           jaqm751att,
           jaqm751cor,
           jaqm751val)
        values
          (1, pd_fecpro, ln_Corr, 'MODULO', ln_Cor751Mod, ln_mod);
      
        commit;
      
        ---correlativo sucursal
        begin
          select nvl(max(a.jaqm751cor), 0) + 1
            into ln_Cor751Suc
            from jaqm751 a
           where a.jaqm751emp = 1
             and a.jaqm751fch = pd_fecpro
             and a.jaqm751att = 'SUCURS'
             and a.jaqm751reg = ln_Corr;
        exception
          when others then
            ln_Cor751Suc := null;
        end;
      
        if nvl(ln_Cor751Suc, 0) = 1 then
          ln_Cor751Suc := 1;
        end if;
      
        insert into jaqm751
          (jaqm751emp,
           jaqm751fch,
           jaqm751reg,
           jaqm751att,
           jaqm751cor,
           jaqm751val)
        values
          (1, pd_fecpro, ln_Corr, 'SUCURS', ln_Cor751Suc, ln_suc);
      
        commit;
      
        ---correlativo moneda
        begin
          select nvl(max(a.jaqm751cor), 0) + 1
            into ln_Cor751Mda
            from jaqm751 a
           where a.jaqm751emp = 1
             and a.jaqm751fch = pd_fecpro
             and a.jaqm751att = 'MONEDA'
             and a.jaqm751reg = ln_Corr;
        exception
          when others then
            ln_Cor751Mda := null;
        end;
      
        if nvl(ln_Cor751Mda, 0) = 1 then
          ln_Cor751Mda := 1;
        end if;
      
        insert into jaqm751
          (jaqm751emp,
           jaqm751fch,
           jaqm751reg,
           jaqm751att,
           jaqm751cor,
           jaqm751val)
        values
          (1, pd_fecpro, ln_Corr, 'MONEDA', ln_Cor751Mda, ln_mda);
        commit;
        ---correlativo papel
        begin
          select nvl(max(a.jaqm751cor), 0) + 1
            into ln_Cor751Pap
            from jaqm751 a
           where a.jaqm751emp = 1
             and a.jaqm751fch = pd_fecpro
             and a.jaqm751att = 'PAPEL'
             and a.jaqm751reg = ln_Corr;
        exception
          when others then
            ln_Cor751Pap := null;
        end;
      
        if nvl(ln_Cor751Pap, 0) = 1 then
          ln_Cor751Pap := 1;
        end if;
      
        insert into jaqm751
          (jaqm751emp,
           jaqm751fch,
           jaqm751reg,
           jaqm751att,
           jaqm751cor,
           jaqm751val)
        values
          (1, pd_fecpro, ln_Corr, 'PAPEL', ln_Cor751Pap, ln_pap);
      
        commit;
      
        ---correlativo cuenta
        begin
          select nvl(max(a.jaqm751cor), 0) + 1
            into ln_Cor751Cta
            from jaqm751 a
           where a.jaqm751emp = 1
             and a.jaqm751fch = pd_fecpro
             and a.jaqm751att = 'CUENTA'
             and a.jaqm751reg = ln_Corr;
        exception
          when others then
            ln_Cor751Cta := null;
        end;
      
        if nvl(ln_Cor751Cta, 0) = 1 then
          ln_Cor751Cta := 1;
        end if;
      
        insert into jaqm751
          (jaqm751emp,
           jaqm751fch,
           jaqm751reg,
           jaqm751att,
           jaqm751cor,
           jaqm751val)
        values
          (1, pd_fecpro, ln_Corr, 'CUENTA', ln_Cor751Cta, ln_cta);
      
        commit;
      
        ---correlativo operacion
        begin
          select nvl(max(a.jaqm751cor), 0) + 1
            into ln_Cor751Ope
            from jaqm751 a
           where a.jaqm751emp = 1
             and a.jaqm751fch = pd_fecpro
             and a.jaqm751att = 'OPERAC'
             and a.jaqm751reg = ln_Corr;
        exception
          when others then
            ln_Cor751Ope := null;
        end;
      
        if nvl(ln_Cor751Ope, 0) = 1 then
          ln_Cor751Ope := 1;
        end if;
      
        insert into jaqm751
          (jaqm751emp,
           jaqm751fch,
           jaqm751reg,
           jaqm751att,
           jaqm751cor,
           jaqm751val)
        values
          (1, pd_fecpro, ln_Corr, 'OPERAC', ln_Cor751Ope, ln_ope);
      
        commit;
        ---correlativo suboperacion
        begin
          select nvl(max(a.jaqm751cor), 0) + 1
            into ln_Cor751Sbo
            from jaqm751 a
           where a.jaqm751emp = 1
             and a.jaqm751fch = pd_fecpro
             and a.jaqm751att = 'SUBOPE'
             and a.jaqm751reg = ln_Corr;
        exception
          when others then
            ln_Cor751Sbo := null;
        end;
      
        if nvl(ln_Cor751Sbo, 0) = 1 then
          ln_Cor751Sbo := 1;
        end if;
      
        insert into jaqm751
          (jaqm751emp,
           jaqm751fch,
           jaqm751reg,
           jaqm751att,
           jaqm751cor,
           jaqm751val)
        values
          (1, pd_fecpro, ln_Corr, 'SUBOPE', ln_Cor751Sbo, ln_sbo);
        commit;
        ---correlativo tipo operacion
        begin
          select nvl(max(a.jaqm751cor), 0) + 1
            into ln_Cor751Top
            from jaqm751 a
           where a.jaqm751emp = 1
             and a.jaqm751fch = pd_fecpro
             and a.jaqm751att = 'TIPOPE'
             and a.jaqm751reg = ln_Corr;
        exception
          when others then
            ln_Cor751Top := null;
        end;
      
        if nvl(ln_Cor751Top, 0) = 1 then
          ln_Cor751Top := 1;
        end if;
      
        insert into jaqm751
          (jaqm751emp,
           jaqm751fch,
           jaqm751reg,
           jaqm751att,
           jaqm751cor,
           jaqm751val)
        values
          (1, pd_fecpro, ln_Corr, 'TIPOPE', ln_Cor751Top, ln_top);
      
        commit;
      end if;
    
      ---Ini Insert Etapa WorkFlow --EFUENTES 2022.06.09
      /* begin
        select nvl(max(a.jaqm751cor), 0) + 1
          into ln_CorEtapa
          from jaqm751 a
         where a.jaqm751emp = 1
           and a.jaqm751fch = pd_fecpro
           and a.jaqm751att = RPAD('ETAPA', 20, ' ')
           and a.jaqm751reg = ln_Corr;
      exception
        when others then
          null;
      end;
      
      begin
        insert into jaqm751 j
          (j.jaqm751emp,
           j.jaqm751fch,
           j.jaqm751reg,
           j.jaqm751att,
           j.jaqm751cor,
           j.jaqm751val)
        values
          (1, pd_fecpro, ln_Corr, 'ETAPA', ln_CorEtapa, pc_etapa);
        COMMIT;
      exception
        when others then
          my_errm := SQLERRM;
          null;
      end;*/
      ---Fin Insert Etapa WorkFlow --EFUENTES 2022.06.09    
    
      Pq_Cr_Modulo_campanias.Sp_insert_bandeja2(pn_pai    => pn_pai,
                                                pn_tdo    => pn_tdo,
                                                pc_ndo    => pc_ndo,
                                                pd_Fecpro => pd_fecpro,
                                                pc_ase    => pc_ase,
                                                pn_seg    => pn_moe,
                                                pn_cor    => pn_cor,
                                                pd_fecP   => pd_fec);
    
      Pq_Cr_Modulo_campanias.Sp_cr_actualiza(pn_cor => pn_cor,
                                             pn_pai => pn_pai,
                                             pn_tdo => pn_tdo,
                                             pc_ndo => pc_ndo,
                                             pd_fec => pd_fec);
    
    end if;
  end Sp_insert_bandeja1;

  Procedure Sp_insert_bandeja2(pn_pai    in number,
                               pn_tdo    in number,
                               pc_ndo    in char,
                               pd_Fecpro in date,
                               pc_ase    in char,
                               pn_seg    in number,
                               pn_cor    in number,
                               pd_fecP   in date) is
    lc_existe char(1) := 'N';
    lc_ind    char(1) := 'A'; --anteriores
    ln_eva    number(10);
  begin
  
    begin
      select a.jaqz697ind, a.jaqz697eva
        into lc_ind, ln_eva
        from jaqz697 a
       where a.jaqz697pai = pn_pai
         and a.jaqz697tdo = pn_tdo
         and a.jaqz697ndo = pc_ndo
         and a.jaqz697cor = pn_cor
         and a.jaqz697fep = pd_fecP;
    exception
      when others then
        null;
    end;
  
    begin
      select 'S'
        into lc_existe
        from jaqz697 j, Aqpa190a k
       where j.jaqz697pai = k.aqpa190apdoc
         and j.jaqz697tdo = k.aqpa190atdoc
         and j.jaqz697ndo = k.aqpa190andoc
         and j.jaqz697ase = k.aqpa190ausu
         and j.jaqz697pai = pn_pai
         and j.jaqz697tdo = pn_tdo
         and j.jaqz697ndo = pc_ndo
         and j.jaqz697cor = pn_cor --mod@abr 20191210
         and j.jaqz697eva = k.aqpa190aeval
         and rownum = 1;
    exception
      when others then
        null;
    end;
  
    if nvl(lc_existe, 'N') = 'N' then
      Insert into Aqpa190a
        (Aqpa190aeval,
         Aqpa190apdoc,
         Aqpa190atdoc,
         Aqpa190andoc,
         Aqpa190afec,
         Aqpa190ausu,
         Aqpa190asol,
         Aqpa190atmod)
      values
        (ln_eva, pn_pai, pn_tdo, pc_ndo, pd_Fecpro, pc_ase, 0, pn_seg);
    
      commit;
    end if;
  
  end Sp_insert_bandeja2;

  Procedure Sp_insert_bandeja3(pn_pai  in number,
                               pn_tdo  in number,
                               pc_ndo  in char,
                               pn_corr in number,
                               pd_fecP in date, --fecha de la carga de BI
                               pn_eva  in number) is
  
    cursor evaluacion(cn_eva in number) is
      select * from aqpa190b_bdj a where a.aqpa190beval = cn_eva;
  
    ln_eva    number(10);
    lc_existe char(1);
  begin
  
    begin
      select a.jaqz697eva
        into ln_eva
        from jaqz697 a
       where a.jaqz697pai = pn_pai
         and a.jaqz697tdo = pn_tdo
         and a.jaqz697ndo = pc_ndo
         and a.jaqz697cor = pn_corr
         and a.jaqz697fep = pd_fecP;
    exception
      when others then
        null;
    end;
  
    begin
      select 'S'
        into lc_existe
        from AQPA190b a
       where a.aqpa190beval = ln_eva
         and rownum = 1;
    exception
      when others then
        lc_existe := 'N';
    end;
  
    if nvl(lc_existe, 'N') = 'N' then
      for i in evaluacion(pn_eva) loop
      
        insert into AQPA190b values (ln_eva, i.aqpa190bcod, i.aqpa190bmto);
        commit;
      end loop;
    end if;
  
  end Sp_insert_bandeja3;

  Procedure Sp_cr_inserta_Aqpa190d(pn_eval in number --,
                                   --pn_evaant in number,
                                   --pd_fecpro in date
                                   ) is
  
    --ln_instancia number(10);
    --ln_insOri    number(10);
  begin
  
    /*begin
        select a.sng021sol
          into ln_insOri
          from sng021 a
         where a.sng021eval = pn_evaant;
      exception
        when others then
          null;
      end;
    
      begin
        select nvl(max(aqpa190dinst), 0) + 1
          into ln_instancia
          from AQPA190d
         where AQPA190dFech = pd_fecpro;
      exception
        when others then
          null;
      end;
    */
    begin
      delete from aqpa190d where aqpa190dneva = pn_eval;
    
      commit;
    
      insert into aqpa190d
        (aqpa190dcorr,
         aqpa190dfech,
         aqpa190dhora,
         aqpa190dinst,
         aqpa190dneva,
         aqpa190dpais,
         aqpa190dtdoc,
         aqpa190dndoc,
         aqpa190drubr,
         aqpa190desta,
         aqpa190denti,
         aqpa190dtcre,
         aqpa190dsdeu,
         aqpa190dplaz,
         aqpa190dtaza,
         aqpa190dccalc,
         aqpa190dgfin,
         aqpa190dfrcc,
         aqpa190ddori,
         aqpa190dchek,
         aqpa190dpers,
         aqpa190drela,
         aqpa190dline,
         aqpa190daux1,
         aqpa190daux2,
         aqpa190daux3,
         aqpa190daux4,
         aqpa190daux5,
         aqpa190daux6,
         aqpa190daux7,
         aqpa190daux8,
         aqpa190daux9,
         aqpa190dmda,
         aqpa190dtlin,
         aqpa190dutil,
         aqpa190dflin,
         aqpa190dflguso,
         aqpa190dcptn,
         aqpa190dfac1,
         aqpa190dfac2,
         aqpa190dfac3,
         aqpa190dcent)
        select a.jaqy327corr,
               a.jaqy327fech,
               a.jaqy327hora,
               a.jaqy327inst,
               a.jaqy327neva,
               a.jaqy327pais,
               a.jaqy327tdoc,
               jaqy327ndoc,
               jaqy327rubr,
               jaqy327esta,
               jaqy327enti,
               jaqy327tcre,
               jaqy327sdeu,
               jaqy327plaz,
               jaqy327taza,
               jaqy327ccalc,
               jaqy327gfin,
               jaqy327frcc,
               jaqy327dori,
               jaqy327chek,
               jaqy327pers,
               jaqy327rela,
               jaqy327line,
               jaqy327aux1,
               jaqy327aux2,
               jaqy327aux3,
               jaqy327aux4,
               jaqy327aux5,
               jaqy327aux6,
               jaqy327aux7,
               jaqy327aux8,
               jaqy327aux9,
               jaqy327mda,
               jaqy327tlin,
               jaqy327util,
               jaqy327flin,
               'N',
               jaqy327cptn,
               jaqy327fac1,
               jaqy327fac2,
               jaqy327fac3,
               jaqy327cent
          from jaqy327_bdj a
         where a.jaqy327neva = pn_eval;
    exception
      when others then
        --pn_error := 1;
        DBMS_OUTPUT.PUT_LINE(sqlerrm);
    end;
  
    commit;
  
  end Sp_cr_inserta_Aqpa190d;

  Procedure Sp_Cr_aqpa190c(pn_eva in number) is
  
  begin
    begin
    
      insert into aqpa190c
        (aqpa190ceval,
         aqpa190ccod,
         aqpa190clin,
         aqpa190cmto1,
         aqpa190cmto2,
         aqpa190cmto3,
         aqpa190cmto4,
         aqpa190cmda1,
         aqpa190cmda2,
         aqpa190cmda3,
         aqpa190cmda4,
         aqpa190ctxt1,
         aqpa190ctxt2,
         aqpa190ctxt3,
         aqpa190ccon1,
         aqpa190ccon2,
         aqpa190ccon3,
         aqpa190ccan1,
         aqpa190ccan2,
         aqpa190ccan3,
         aqpa190ccan4,
         aqpa190ctxl1,
         aqpa190ctxl2,
         aqpa190ctxl3)
        select aqpa190ceval,
               aqpa190ccod,
               aqpa190clin,
               aqpa190cmto1,
               aqpa190cmto2,
               aqpa190cmto3,
               aqpa190cmto4,
               aqpa190cmda1,
               aqpa190cmda2,
               aqpa190cmda3,
               aqpa190cmda4,
               aqpa190ctxt1,
               aqpa190ctxt2,
               aqpa190ctxt3,
               aqpa190ccon1,
               aqpa190ccon2,
               aqpa190ccon3,
               aqpa190ccan1,
               aqpa190ccan2,
               aqpa190ccan3,
               aqpa190ccan4,
               aqpa190ctxl1,
               aqpa190ctxl2,
               aqpa190ctxl3
          from aqpa190c_bdj a
         where a.aqpa190ceval = pn_eva;
      commit;
    
    end;
  
  end Sp_Cr_aqpa190c;

  procedure Sp_cr_actualiza(pn_cor in number,
                            pn_pai in number,
                            pn_tdo in number,
                            pc_ndo in char,
                            pd_fec in date) is
    ld_fec    date;
    ln_ins    number(10) := 0;
    lc_prog   char(10) := 'OTROS';
    lc_ase    char(10);
    ln_moe    number(4);
    ln_cotcbi number(14, 8);
    ln_caja   number(17, 2);
    ln_sdoex  number(17, 2);
    ln_resul  number(17, 2);
    ln_cap    number(17, 2);
  begin
  
    begin
      select a.pgfape into ld_fec from fst017 a where pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select a.jaqz697ase, a.jaqz697moe
        into lc_ase, ln_moe
        from jaqz697 a
       where a.jaqz697fep = pd_fec
         and a.jaqz697cor = pn_cor
         and a.jaqz697pai = pn_pai
         and a.jaqz697tdo = pn_tdo
         and a.jaqz697ndo = pc_ndo;
    exception
      when others then
        null;
    end;
  
    pq_cr_modulo_campanias.Sp_cr_tipocambio(pd_fecpro => ld_fec,
                                            pn_tipcam => ln_cotcbi);
  
    if ln_moe = 13 then
    
      pq_cr_modulo_campanias.sp_CalculoRAtioPYME(ln_Pepais     => pn_pai,
                                                 ln_Petdoc     => pn_tdo,
                                                 ln_Pendoc     => pc_ndo,
                                                 tipocambio    => ln_cotcbi,
                                                 Instancia     => ln_ins,
                                                 pd_fecpro     => ld_fec,
                                                 lc_prgm       => lc_prog,
                                                 lc_Usuario    => lc_ase,
                                                 ln_captotcaja => ln_caja,
                                                 saldo_externo => ln_sdoex,
                                                 ResultNeto    => ln_resul,
                                                 ln_captotal   => ln_cap);
    
    else
      pq_cr_modulo_campanias.sp_calculoratio(ln_Pepais        => pn_pai,
                                             ln_Petdoc        => pn_tdo,
                                             ln_Pendoc        => pc_ndo,
                                             tipocambio       => ln_cotcbi,
                                             Instancia        => ln_ins,
                                             pd_fecpro        => ld_fec,
                                             lc_prgm          => lc_prog,
                                             ln_Usuario       => lc_ase,
                                             ln_captotcaja    => ln_caja,
                                             saldo_externo    => ln_sdoex,
                                             ln_ExcdntMensual => ln_resul,
                                             ln_RatioConsumo  => ln_cap);
    
    end if;
  
    begin
      update jaqz697 a
         set a.jaqz697au5 = 'Z' --No procesados
       where a.jaqz697fep = pd_fec
         and a.jaqz697pai = pn_pai
         and a.jaqz697tdo = pn_tdo
         and a.jaqz697ndo = pc_ndo;
    end;
    commit;
  
    begin
      update jaqz697 a
         set a.jaqz697au5 = 'S',
             a.jaqz697fan = ld_fec,
             a.jaqz697caj = ln_caja
       where a.jaqz697fep = pd_fec
         and a.jaqz697cor = pn_cor
         and a.jaqz697pai = pn_pai
         and a.jaqz697tdo = pn_tdo
         and a.jaqz697ndo = pc_ndo;
    end;
    COMMIT;
  
  end Sp_cr_actualiza;
  -------------------------------------------------------------------------------
  procedure sp_cr_VerificaCtnro(pn_cta in number, pc_flg out char) is
  
    cursor clientes is
      select *
        from fsr008 a
       where a.ctnro = pn_cta
         and a.cttfir = 'T';
  
    ln_cont   number(3) := 0;
    lc_flg    char(1) := 'N';
    lc_flgCyg char(1) := 'N';
  
  begin
  
    begin
      select count(*) into ln_cont from fsr008 a where a.ctnro = pn_cta;
    exception
      when others then
        ln_cont := 0;
    end;
  
    if nvl(ln_cont, 0) = 1 then
      lc_flg := 'T';
    end if;
  
    if nvl(ln_cont, 0) = 2 then
    
      for i in clientes loop
        begin
          select 'S'
            into lc_flgCyg
            from fsr002 a
           where a.pepais = i.pepais
             and a.petdoc = i.petdoc
             and a.pendoc = i.pendoc
             and a.rpccyg = 66
             and rownum = 1;
        exception
          when others then
            lc_flgCyg := 'N';
        end;
      
        if nvl(lc_flgCyg, 'N') = 'S' then
          exit;
        else
          begin
            select 'S'
              into lc_flgCyg
              from fsr002 a
             where a.rppais = i.pepais
               and a.rptdoc = i.petdoc
               and a.rpndoc = i.pendoc
               and a.rpccyg = 66
               and rownum = 1;
          exception
            when others then
              lc_flgCyg := 'N';
          end;
          if nvl(lc_flgCyg, 'N') = 'S' then
            exit;
          end if;
        
        end if;
      end loop;
    
    end if;
  
    if nvl(lc_flgCyg, 'N') = 'S' then
      lc_flg := 'C';
    end if;
  
    pc_flg := lc_flg;
  
  end sp_cr_VerificaCtnro;
  ---------------------------------------------
  Procedure Sp_actualizaInfo(pn_cor     in number,
                             pd_fec     in date,
                             pn_mto     in number,
                             pn_cta     in number,
                             pn_cuo     in number,
                             pn_fre     in number,
                             pn_suc     in number,
                             pn_ase     in char,
                             pn_eva     in number,
                             pd_fecprim in date,
                             pc_flg     in char,
                             pn_mtocuo  out number) is
  
    ln_mda number(4);
    ln_pap number(4);
    ln_mod number(3);
    ln_top number(3);
    ln_mto number(17, 2);
    --ln_fre      number(5);
    ln_cuo    number(10);
    ln_mtoCuo number(17, 2);
    ld_Fecpro date;
    pn_pai    number;
    pn_tdo    number;
    pc_ndo    char(12);
    ln_tasa   number(11, 6); --mod@abr 20201113
  begin
  
    begin
      select a.pgfape into ld_Fecpro from fst017 a where a.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select a.jaqz697mda,
             0,
             a.jaqz697mod,
             a.jaqz697top,
             a.jaqz697mto,
             --a.jaqz697pzo,
             a.jaqz697cuo,
             a.jaqz697pai,
             a.jaqz697tdo,
             a.jaqz697ndo
        into ln_mda,
             ln_pap,
             ln_mod,
             ln_top,
             ln_mto, /*ln_fre,*/
             ln_cuo,
             pn_pai,
             pn_tdo,
             pc_ndo
        from jaqz697 a
       where a.jaqz697fep = pd_fec
         and a.jaqz697cor = pn_cor;
    exception
      when others then
        null;
    end;
  
    pq_Cr_modulo_Campanias.Sp_cr_mtoCuota(ln_mod,
                                          ln_mda,
                                          ln_pap,
                                          ln_top,
                                          pn_suc,
                                          pn_mto,
                                          pn_cuo,
                                          pn_fre,
                                          ld_Fecpro,
                                          pd_fec,
                                          pn_cor,
                                          pc_flg,
                                          pd_fecprim,
                                          pn_cta,
                                          ln_mtoCuo,
                                          ln_tasa);
  
    update jaqz697 a
       set a.jaqz697mto = pn_mto,
           a.jaqz697cta = pn_cta,
           a.jaqz697cuo = pn_cuo,
           a.jaqz697pzo = pn_fre,
           a.jaqz697mcu = ln_mtoCuo,
           a.jaqz697suc = pn_suc,
           a.jaqz697ase = pn_ase --,
    --a.jaqz697eva = pn_eva
     where a.jaqz697fep = pd_fec
       and a.jaqz697cor = pn_cor;
  
    commit;
  
    pn_mtocuo := ln_mtoCuo;
  
    /* Pq_Cr_Modulo_campanias.Sp_cr_actualiza(pn_cor => pn_cor,
    pn_pai => pn_pai,
    pn_tdo => pn_tdo,
    pc_ndo => pc_ndo,
    pd_fec => pd_fec);*/
  
  end Sp_actualizaInfo;
  -----------------------------------------------------
  Procedure Sp_CalculaCuota(pn_cor in number,
                            pd_fec in date,
                            pn_mto in number,
                            --pn_cta    in number,
                            pn_cuo     in number,
                            pn_fre     in number,
                            pn_suc     in number,
                            pd_fecprim in date,
                            pc_flag    in char,
                            pn_cta     in number,
                            --pn_ase    in char,
                            --pn_eva    in number,
                            pn_mtocuo out number,
                            pn_tasa   out number) is
  
    ln_mda number(4);
    ln_pap number(4);
    ln_mod number(3);
    ln_top number(3);
    ln_mto number(17, 2);
    --ln_fre      number(5);
    ln_cuo    number(10);
    ln_mtoCuo number(17, 2);
    ld_Fecpro date;
    ln_tasa   number(11, 6); --mod@abr 20201113
  begin
  
    begin
      select a.pgfape into ld_Fecpro from fst017 a where a.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select a.jaqz697mda,
             0,
             a.jaqz697mod,
             a.jaqz697top,
             a.jaqz697mto,
             --a.jaqz697pzo,
             a.jaqz697cuo
        into ln_mda, ln_pap, ln_mod, ln_top, ln_mto, /*ln_fre,*/ ln_cuo
        from jaqz697 a
       where a.jaqz697fep = pd_fec
         and a.jaqz697cor = pn_cor;
    exception
      when others then
        null;
    end;
  
    pq_Cr_modulo_Campanias.Sp_cr_mtoCuota(ln_mod,
                                          ln_mda,
                                          ln_pap,
                                          ln_top,
                                          pn_suc,
                                          pn_mto,
                                          pn_cuo,
                                          pn_fre,
                                          ld_Fecpro,
                                          pd_fec,
                                          pn_cor,
                                          pc_flag,
                                          pd_fecprim,
                                          pn_cta,
                                          ln_mtoCuo,
                                          ln_tasa);
  
    pn_mtocuo := ln_mtoCuo;
    pn_tasa   := ln_tasa;
  
  end Sp_CalculaCuota;
  -------------------------------------------------
  Procedure Sp_cr_mtoCuota(pn_mod     in number,
                           pn_mda     in number,
                           pn_pap     in number,
                           pn_top     in number,
                           pn_suc     in number,
                           pn_mto     in number,
                           pn_cuo     in number,
                           pn_fre     in number,
                           pd_fecpro  in date,
                           pd_Fec     in date,
                           pc_cor     in number,
                           pc_flg     in char,
                           pd_Fecprim in date,
                           pn_cta     in number, --mod@abr 20201115
                           pn_mtoCuo  out number,
                           ln_tasa    out number) is
  
    ln_mod   number(3);
    ln_suc   number(3);
    ln_mda   number(4);
    ln_pap   number(4);
    ln_top   number(3);
    ln_mto   number(17, 2);
    ln_pzo   number(5);
    ln_defn  number(17, 2);
    ln_cont  number(5) := 0;
    ln_tas   number(10, 6);
    ln_mtt   number(17, 2);
    ln_fde   date;
    ln_tat   number(7, 4);
    ln_cont2 number(5) := 0;
    ln_tvmpo number(7, 4);
    ln_porc  number(4) := 100;
    ln_aux   number(9);
    pn_tasa  number(10, 6);
    ln_div   number(10, 6);
    /*ln_tip      char(1);
    ln_modA     number(3);
    ln_sucA     number(3);
    ln_mdaA     number(4);
    ln_papA     number(4);
    ln_ctaA     number(9);
    ln_opeA     number(9);
    ln_sboA     number(3);
    ln_topA     number(3);*/
    ld_fecSis   date;
    ln_dife     number(10);
    ln_int      number(17, 2);
    ln_mtoFinal number(17, 2);
    ld_fecAux   date;
    ln_cuo      number;
    ln_pais     number;
    ln_tdoc     number;
    lc_ndoc     varchar2(12);
  
    cursor tasa(cn_defn in number,
                cn_mod  in number,
                cn_mda  in number,
                cn_pap  in number,
                cn_mto  in number,
                cn_pzo  in number,
                cf_fec  in date) is
      select *
        from fsr025 a
       where a.pgcod = 1
         and a.tpizar = cn_defn
         and a.tamod = cn_mod
         and a.tamda = cn_mda
         and a.tapap = cn_pap
         and a.tamto >= cn_mto
         and a.tapzo >= cn_pzo
         and a.tafdes <= cf_fec
         and a.tafdes = (select max(aa.tafdes)
                           from fsr025 aa
                          where aa.pgcod = 1
                            and aa.tpizar = cn_defn
                            and aa.tamod = cn_mod
                            and aa.tamda = cn_mda
                            and aa.tapap = cn_pap
                               --and aa.tamto  >= cn_mto
                               --and aa.tapzo  >= cn_pzo 
                            and aa.tafdes <= cf_fec);
    cursor region(cn_sucR in number) is
      select *
        from fst811 a
       where a.pgcod = 1
         and a.regcod >= 100
         and a.oficod = cn_sucR;
  
    cursor tasa_esp(cn_modE in number,
                    cn_defE in number,
                    cn_papE in number,
                    cn_mdaE in number,
                    cn_mtoE in number,
                    cn_regE in number,
                    cd_fecE in date) is
    
      select *
        from fsd527 a
       where a.pgcod = 1
         and a.tamod = cn_modE
         and a.tpizar = cn_defE
         and a.tapap = cn_papE
         and a.tamda = cn_mdaE
         and a.tvfmon = cn_mtoE
         and a.tvsuc = cn_regE
         and a.tvfdes <= cd_fecE;
  
    ln_Pp028DefN number(17, 2);
    ln_cta       number(9);
    --ln_mtoAUX    NUMBER(17, 2);
  
  begin
  
    ln_mod := pn_mod;
    ln_suc := pn_suc;
    ln_mda := pn_mda;
    ln_pap := pn_pap;
    ln_top := pn_top;
    ln_mto := pn_mto;
    ln_cuo := pn_cuo;
  
    if ln_mod = 117 then
    
      ln_cuo := 24; -- mpostigoc 18.02.2022
    
    end if;
  
    --tasa por cuenta
  
    begin
      select a.jaqz697cta, a.jaqz697pai, a.jaqz697tdo, a.jaqz697ndo
        into ln_cta, ln_pais, ln_tdoc, lc_ndoc
        from jaqz697 a
       where a.jaqz697fep = pd_Fec
         and a.jaqz697cor = pc_cor;
    exception
      when others then
        null;
    end;
  
    ln_cta := pn_cta;
  
    begin
      select Pp028DefN
        into ln_Pp028DefN
        from FPP028
       Where Pp028Emp = 1
         and Pp028Mod = ln_mod
         and Pp028Top = ln_top
         and Pp028Mda = ln_mda
         and Pp028Pap = ln_pap
         and Pp017Par = 17;
    exception
      when others then
        null;
    end;
  
    /*  begin
      select MIN(f.tpmto)
        into ln_mtoAUX
        from fsr027 f
       where f.pgcod = 1
         and f.modulo = ln_mod
         and f.tpizar = ln_Pp028DefN
         and f.ctnro = ln_cta
         and f.moneda = ln_mda
         and f.papel = ln_pap
         and f.tpfdes = pd_Fec
         and f.tpmto >= pn_mto
         and f.tppzo = 99999;
    exception
      when others then
        null;
    end;
    
    begin
      select f.tptasa
        into pn_tasa
        from fsr027 f
       where f.pgcod = 1
         and f.modulo = ln_mod
         and f.tpizar = ln_Pp028DefN
         and f.ctnro = ln_cta
         and f.moneda = ln_mda
         and f.papel = ln_pap
         and f.tpfdes = pd_Fec
         and f.tpmto = ln_mtoAUX
         and f.tppzo = 99999;
    exception
      when others then
        null;
    end;*/
    --calculo de plazo
    begin
      select tp1nro1
        into ln_aux
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10899
         and tp1corr1 = 88888
         and tp1corr2 = 4
         and tp1corr3 = 1;
    exception
      when others then
        null;
    end;
  
    ln_pzo := (ln_cuo * pn_fre) + nvl(ln_aux, 0);
  
    -- mpostigoc 25.07.2022  
    Pq_Cr_Modulo_Campanias.sp_cr_TasaPorPlazo(ln_cuenta => ln_cta,
                                              ln_mod    => ln_mod,
                                              ln_piza   => ln_Pp028DefN,
                                              ld_fcha   => pd_Fec,
                                              ln_monto  => pn_mto,
                                              ln_Plazo  => ln_pzo,
                                              pn_tasa   => pn_tasa);
  
    if nvl(pn_tasa, 0) = 0 then
      /*--obtiene pizarra
      begin
        select Pp028DefN
          into ln_defn
          from fpp028
         where Pp010Prd = 1
           and Pp017Par = 17
           and Pp028Mod = ln_mod
           and Pp028Mda = ln_mda
           and Pp028Pap = ln_pap
           and Pp028Top = ln_top;
      exception
        when others then
          null;
      end;
      
      for i in tasa(ln_defn,
                    ln_mod,
                    ln_mda,
                    ln_pap,
                    ln_mto,
                    ln_pzo,
                    pd_fecpro) loop
      
        ln_tas  := i.Tatasa;
        ln_mtt  := i.Tamto;
        ln_fde  := i.Tafdes;
        ln_tat  := i.Tatol;
        ln_cont := ln_cont + 1;
      
        if ln_cont > 0 then
          exit;
        end if;
      
      end loop;
      
      for j in region(ln_suc) loop
        for k in tasa_esp(ln_mod,
                          ln_defn,
                          ln_pap,
                          ln_mda,
                          ln_mtt, --MOD@ABR 20171018
                          j.regcod,
                          pd_fecpro) loop
        
          ln_tvmpo := k.TvMPorc - ln_porc;
          ln_cont2 := ln_cont2 + 1;
        
          if ln_cont2 > 0 then
            exit;
          end if;
        
        end loop;
      end loop;
      
      pn_tasa := nvl(ln_tas, 0) + nvl(ln_tvmpo, 0);*/ -- mpostigoc 22/12/2022
    
      begin
        -- Call the procedure
        ln_pzo := (ln_cuo * pn_fre);
        pq_cr_tasatarifario_nuevo.sp_cr_tpoten_camp(ln_sng001pais => ln_pais,
                                                    ln_sng001tdoc => ln_tdoc,
                                                    lc_sng001ndoc => lc_ndoc,
                                                    ln_xwfmonto1  => ln_mto,
                                                    ln_xwfplazo1  => ln_pzo,
                                                    ln_xwftipope  => ln_top,
                                                    ln_xwfmodulo  => ln_mod,
                                                    ln_moneda     => ln_mda,
                                                    ln_papel      => ln_pap,
                                                    ln_sucursal   => ln_suc,
                                                    pd_fecha      => pd_Fec,
                                                    pn_tasaf      => pn_tasa);
      
      end;
    
    end if;
  
    if nvl(pc_flg, 'N') = 'S' then
      begin
        select a.pgfape into ld_fecSis from fst017 a where a.pgcod = 1;
      exception
        when others then
          null;
      end;
    
      ld_fecAux := ld_fecSis + pn_fre;
    
      if ld_fecAux <> pd_Fecprim then
        ln_dife := (pd_Fecprim - ld_fecSis) - pn_fre;
      
        if ln_dife < 0 then
          ln_int := 0;
        else
          ln_int := pn_mto *
                    ((power((1 + (pn_tasa / 100)), (ln_dife / 360))) - 1);
        end if;
      
      end if;
    
    end if;
  
    ln_mtoFinal := pn_mto + nvl(ln_int, 0);
  
    ln_div := (1 - power((1 +
                         ((power((1 + (pn_tasa / 100)), (pn_fre / 360))) - 1)),
                         -ln_cuo));
    if ln_div > 0 then
      pn_mtoCuo := (ln_mtoFinal *
                   ((power((1 + (pn_tasa / 100)), (pn_fre / 360))) - 1)) /
                   ln_div;
    else
      pn_mtoCuo := 0;
    end if;
  
    ln_tasa := pn_tasa;
  
  end Sp_cr_mtoCuota;
  --------------------------------------------------------------------
  Procedure sp_Cr_genera_eva(pn_eva out number) is
  
  begin
    pn_eva := sq_cn_flujoeval.nextval;
  
  end sp_Cr_genera_eva;
  -----------------------------------------------------------------
  procedure sp_cr_TasaPorPlazo(ln_cuenta in number,
                               ln_mod    in number,
                               ln_piza   in number,
                               ld_fcha   in date,
                               ln_monto  in number,
                               ln_Plazo  in number,
                               pn_tasa   out number) is
  
    ln_mtoAUX   number;
    ln_plazoAux number;
    ld_fchTasa  date;
    ld_fchSist  date;
    ld_FchVenc  date;
  
  begin
  
    pn_tasa := 0;
  
    begin
      select f.pgfape into ld_fchSist from fst017 f where f.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    /* begin
      select MIN(f.tpmto)
        into ln_mtoAUX
        from fsr027 f
       where f.pgcod = 1
         and f.modulo = ln_mod --ln_mod
         and f.tpizar = ln_piza --ln_Pp028DefN
         and f.ctnro = ln_cuenta
         and f.moneda = 0
         and f.papel = 0
         and f.tpfdes = ld_fcha
         and f.tpmto >= ln_monto;
    exception
      when others then
        ln_mtoAUX := 0;
    end;
    
    begin
      select min(f.tppzo)
        into ln_plazoAux
        from fsr027 f
       where f.pgcod = 1
         and f.modulo = ln_mod --ln_mod
         and f.tpizar = ln_piza --ln_Pp028DefN
         and f.ctnro = ln_cuenta
         and f.moneda = 0
         and f.papel = 0
         and f.tpfdes = ld_fcha
         and f.tpmto = ln_mtoAUX
         and f.tppzo >= ln_Plazo;
    exception
      when others then
        ln_plazoAux := 0;
    end;
    
    begin
      select f.tptasa
        into pn_tasa
        from fsr027 f
       where f.pgcod = 1
         and f.modulo = ln_mod --ln_mod
         and f.tpizar = ln_piza --ln_Pp028DefN
         and f.ctnro = ln_cuenta
         and f.moneda = 0
         and f.papel = 0
         and f.tpfdes = ld_fcha
         and f.tpmto = ln_mtoAUX
         and f.tppzo = ln_plazoAux;
    exception
      when others then
        pn_tasa := 0;
    end;*/
  
    begin
      select min(f.tpmto)
        into ln_mtoAUX
        from fsd027 f
       where f.pgcod = 1
         and f.modulo = ln_mod
         and f.tpizar = ln_piza
         and f.ctnro = ln_cuenta
         and f.moneda = 0
         and f.papel = 0
         and f.tpvig = 'S'
         and f.tpmto > = ln_monto;
    exception
      when others then
        ln_mtoAUX := 0;
    end;
  
    if ln_mtoAUX > 0 then
    
      begin
        select max(f.tpfdes)
          into ld_fchTasa
          from fsd027 f
         where f.pgcod = 1
           and f.modulo = ln_mod
           and f.tpizar = ln_piza
           and f.ctnro = ln_cuenta
           and f.moneda = 0
           and f.papel = 0
           and f.tpvig = 'S'
           and f.tpmto = ln_mtoAUX;
      exception
        when others then
          null;
      end;
    
      begin
        select max(f.vt1fchven)
          into ld_FchVenc
          from fsd327 f
         where f.vt1pgcod = 1
           and f.vt1mod = ln_mod
           and f.vt1tpiz = ln_piza
           and f.vt1ctnr = ln_cuenta
           and f.vt1mon = 0
           and f.vt1pap = 0
           and f.vt1tpfd = ld_fchTasa;
      exception
        when others then
          null;
      end;
    
      if ld_FchVenc >= ld_fchSist then
      
        begin
          select min(f.tppzo)
            into ln_plazoAux
            from fsr027 f
           where f.pgcod = 1
             and f.modulo = ln_mod
             and f.tpizar = ln_piza
             and f.ctnro = ln_cuenta
             and f.moneda = 0
             and f.papel = 0
             and f.tpfdes = ld_fchTasa
             and f.tpmto = ln_mtoAUX
             and f.tppzo >= ln_Plazo;
        exception
          when others then
            ln_plazoAux := 0;
        end;
      
        begin
          select f.tptasa
            into pn_tasa
            from fsr027 f
           where f.pgcod = 1
             and f.modulo = ln_mod
             and f.tpizar = ln_piza
             and f.ctnro = ln_cuenta
             and f.moneda = 0
             and f.papel = 0
             and f.tpfdes = ld_fchTasa
             and f.tpmto = ln_mtoAUX
             and f.tppzo = ln_plazoAux;
        exception
          when others then
            pn_tasa := 0;
        end;
      
      end if;
    else
      pn_tasa := 0;
    end if;
  end sp_cr_TasaPorPlazo;

  ------------------------------------------------------------------
  Procedure Sp_verificar(pn_pai in number,
                         pn_tdo in number,
                         pc_ndo in char,
                         pc_ase in char,
                         pc_flg out char,
                         pd_fec out date) is
    ld_FEcmax   date;
    lc_flg      char(1) := 'N';
    lc_ase      char(10);
    lc_aseAux   char(10);
    ln_suc      number(3);
    ln_sucUsu   number(3);
    ld_sis      date;
    lc_flgSuple char(1) := 'N';
  
    cursor usuarios(pp_ase in char) is
      select SNG057Usr
        from sng057
       Where SNG057Sup = pp_ase
         and SNG057Ini <= ld_sis
         and SNG057Fin >= ld_sis
      union
      select pp_ase
        from dual;
  begin
  
    /*   insert into prueba_andrea
        (pais, tipo, doc, analis, ind)
      values
        (pn_pai, pn_tdo, pc_ndo, pc_ase, 'Sp_verificar');
    */
  
    begin
      select max(a.jaqz697fep) into ld_FEcmax from jaqz697 a;
    exception
      when others then
        null;
    end;
  
    begin
      select a.pgfape into ld_sis from fst017 a where a.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
    
      select 'S'
        into lc_flgSuple
        from sng057
       Where SNG057Sup = pc_ase
         and SNG057Ini <= ld_sis
         and SNG057Fin >= ld_sis
         and rownum = 1;
    exception
      when others then
        lc_flgSuple := 'N';
    end;
  
    if lc_flgSuple = 'N' then
      if nvl(ld_FEcmax, to_date('01/01/0001', 'dd/mm/yyyy')) <>
         to_date('01/01/0001', 'dd/mm/yyyy') then
      
        begin
          select 'S'
            into lc_flg
            from jaqz697 a
           where a.jaqz697fep >= ld_FEcmax
             and a.jaqz697pai = pn_pai
             and a.jaqz697tdo = pn_tdo
             and a.jaqz697ndo = pc_ndo
             and a.jaqz697ase = pc_ase
             and rownum = 1;
        exception
          when others then
            lc_flg := 'N';
        end;
      
        if lc_flg = 'S' then
        
          begin
            select 'N'
              into lc_flg
              from jaqz697 a
             where a.jaqz697fep >= ld_FEcmax
               and a.jaqz697pai = pn_pai
               and a.jaqz697tdo = pn_tdo
               and a.jaqz697ndo = pc_ndo
               and a.jaqz697ase = pc_ase
               and a.jaqz697au5 = 'S'
               and rownum = 1;
          exception
            when others then
              lc_flg := 'S';
          end;
        
        end if;
      
        if lc_flg = 'S' then
          --*-verifica analista
          begin
            select a.jaqz697ase, a.jaqz697suc
              into lc_ase, ln_suc
              from jaqz697 a
             where a.jaqz697fep >= ld_FEcmax
               and a.jaqz697pai = pn_pai
               and a.jaqz697tdo = pn_tdo
               and a.jaqz697ndo = pc_ndo
               and a.jaqz697ase = pc_ase;
          exception
            when too_many_rows then
              begin
                select a.jaqz697ase, a.jaqz697suc
                  into lc_ase, ln_suc
                  from jaqz697 a
                 where a.jaqz697fep >= ld_FEcmax
                   and a.jaqz697pai = pn_pai
                   and a.jaqz697tdo = pn_tdo
                   and a.jaqz697ndo = pc_ndo
                   and a.jaqz697ase = pc_ase
                   and rownum = 1;
              exception
                when others then
                  null;
              end;
            when others then
              null;
          end;
        
          begin
            select a.ubsuc
              into ln_sucUsu
              from fst046 a
             where a.ubuser = lc_ase;
          exception
            when others then
              null;
          end;
        
          if nvl(lc_ase, 'X') <> 'X' and nvl(ln_suc, 0) <> 0 then
          
            if ln_sucUsu <> ln_suc then
              lc_flg := 'N';
            end if;
          
          end if;
          if nvl(lc_ase, 'X') <> 'X' and nvl(ln_suc, 0) = 0 then
            lc_flg := 'N';
          end if;
          if nvl(lc_ase, 'X') = 'X' and nvl(ln_suc, 0) <> 0 then
            lc_flg := 'N';
          end if;
        
        end if;
      
      end if;
      pc_flg := lc_flg;
      pd_fec := nvl(ld_FEcmax, ld_sis);
    
    else
      lc_aseAux := pc_ase;
      for i in usuarios(lc_aseAux) loop
      
        if nvl(ld_FEcmax, to_date('01/01/0001', 'dd/mm/yyyy')) <>
           to_date('01/01/0001', 'dd/mm/yyyy') then
        
          begin
            select 'S'
              into lc_flg
              from jaqz697 a
             where a.jaqz697fep >= ld_FEcmax
               and a.jaqz697pai = pn_pai
               and a.jaqz697tdo = pn_tdo
               and a.jaqz697ndo = pc_ndo
               and a.jaqz697ase = i.SNG057Usr
               and rownum = 1;
          exception
            when others then
              lc_flg := 'N';
          end;
        
          /*if lc_flg = 'N' then
            exit;
          end if;*/
        
          if lc_flg = 'S' then
          
            begin
              select 'N'
                into lc_flg
                from jaqz697 a
               where a.jaqz697fep >= ld_FEcmax
                 and a.jaqz697pai = pn_pai
                 and a.jaqz697tdo = pn_tdo
                 and a.jaqz697ndo = pc_ndo
                 and a.jaqz697ase = i.SNG057Usr
                 and a.jaqz697au5 = 'S'
                 and rownum = 1;
            exception
              when others then
                lc_flg := 'S';
            end;
          
          end if;
        
          if lc_flg = 'S' then
            --*-verifica analista
            begin
              select a.jaqz697ase, a.jaqz697suc
                into lc_ase, ln_suc
                from jaqz697 a
               where a.jaqz697fep >= ld_FEcmax
                 and a.jaqz697pai = pn_pai
                 and a.jaqz697tdo = pn_tdo
                 and a.jaqz697ndo = pc_ndo
                 and a.jaqz697ase = i.SNG057Usr;
            exception
              when too_many_rows then
                begin
                  select a.jaqz697ase, a.jaqz697suc
                    into lc_ase, ln_suc
                    from jaqz697 a
                   where a.jaqz697fep >= ld_FEcmax
                     and a.jaqz697pai = pn_pai
                     and a.jaqz697tdo = pn_tdo
                     and a.jaqz697ndo = pc_ndo
                     and a.jaqz697ase = i.SNG057Usr
                     and rownum = 1;
                exception
                  when others then
                    null;
                end;
              when others then
                null;
            end;
          
            begin
              select a.ubsuc
                into ln_sucUsu
                from fst046 a
               where a.ubuser = lc_ase;
            exception
              when others then
                null;
            end;
          
            if nvl(lc_ase, 'X') <> 'X' and nvl(ln_suc, 0) <> 0 then
            
              if ln_sucUsu <> ln_suc then
                lc_flg := 'N';
              end if;
            
            end if;
            if nvl(lc_ase, 'X') <> 'X' and nvl(ln_suc, 0) = 0 then
              lc_flg := 'N';
            end if;
            if nvl(lc_ase, 'X') = 'X' and nvl(ln_suc, 0) <> 0 then
              lc_flg := 'N';
            end if;
          
          end if;
          if lc_flg = 'S' then
            exit;
          end if;
        
        end if;
      
      end loop;
    
      pc_flg := lc_flg;
      pd_fec := nvl(ld_FEcmax, ld_sis);
    
    end if;
  
  end Sp_verificar;
  --------------------------------------------------------
  Procedure Sp_actualizaEva(pn_cor in number,
                            pd_fec in date,
                            pn_eva in number) is
  
  begin
  
    update jaqz697 a
       set a.jaqz697eva = pn_eva
     where a.jaqz697fep = pd_fec
       and a.jaqz697cor = pn_cor;
  
    commit;
  
  end Sp_actualizaEva;
  ------------------------------------------------------------
  Procedure Sp_cr_tipocambio(pd_fecpro in date, pn_tipcam out number) is
  
  begin
    begin
      select cotcbi
        into pn_tipcam
        from fsh005 f
       where cofdes in (select max(cofdes)
                          from fsh005 g
                         where g.cofdes <= pd_fecpro
                           and moneda = 101)
         and moneda = 101;
    exception
      when no_data_found then
        pn_tipcam := 1;
    end;
  
  end Sp_cr_tipocambio;
  ---------------------------------------------------------
  Procedure Sp_validac_ampliado(pn_emp    in number,
                                pn_mod    in number,
                                pn_suc    in number,
                                pn_mda    in number,
                                pn_pap    in number,
                                pn_cta    in number,
                                pn_ope    in number,
                                pn_sbo    in number,
                                pn_top    in number,
                                pd_Fecpro in date,
                                pc_flg    out char,
                                pc_flgM   out char,
                                pc_flgVC  out char) is
  
    lc_flg     char(1) := 'N';
    ln_pai     number(3);
    ln_tdo     number(3);
    lc_ndo     char(12);
    ln_diatr   number(10);
    lc_flgMora char(1) := 'N';
    lc_flgCV   char(1) := 'N';
  
    cursor creditos(cn_pai in number, cn_tdo in number, cc_ndo in char) is
      select a.pgcod,
             a.aomod,
             a.aosuc,
             a.aomda,
             a.aopap,
             a.aocta,
             a.aooper,
             a.aosbop,
             a.aotope,
             a.aostat,
             a.aofvto
        from fsd010 a
       where a.pgcod = 1
         and a.aocta in (select ctnro
                           from fsr008 b
                          where b.pepais = cn_pai
                            and b.petdoc = cn_tdo
                            and b.pendoc = cc_ndo)
         and aomod in (select modulo from fst111 where dscod = 50)
         and aostat <> 99;
  
  begin
    --**Valida si el credito a ampliar esta vigente**--
    begin
      select 'S'
        into lc_flg
        from fsd010 a
       where a.pgcod = pn_emp
         and a.aomod = pn_mod
         and a.aosuc = pn_suc
         and a.aomda = pn_mda
         and a.aopap = pn_pap
         and a.aocta = pn_cta
         and a.aooper = pn_ope
         and a.aosbop = pn_sbo
         and a.aotope = pn_top
         and a.aostat <> 99
         and rownum = 1;
    exception
      when others then
        lc_flg := 'N';
    end;
  
    pc_flg := nvl(lc_flg, 'N');
  
    --**valida que el cliente no este en mora**--
    begin
      select a.pepais, a.petdoc, a.pendoc
        into ln_pai, ln_tdo, lc_ndo
        from fsr008 a
       where a.ctnro = pn_cta
         and a.cttfir = 'T';
    exception
      when others then
        null;
    end;
  
    for i in creditos(ln_pai, ln_tdo, lc_ndo) loop
      ln_diatr := fn_dias_atraso(v_Pgfape => pd_Fecpro,
                                 v_Pgcod  => i.pgcod,
                                 v_Scmod  => i.aomod,
                                 v_Scsuc  => i.aosuc,
                                 v_Scmda  => i.aomda,
                                 v_Scpap  => i.aopap,
                                 v_Sccta  => i.aocta,
                                 v_Scoper => i.aooper,
                                 v_Scsbop => i.aosbop,
                                 v_Sctope => i.aotope,
                                 v_Scstat => i.aostat,
                                 v_fecven => i.aofvto);
      if ln_diatr > 0 then
        lc_flgMora := 'S';
        exit;
      end if;
    end loop;
  
    for j in creditos(ln_pai, ln_tdo, lc_ndo) loop
      --**Valida flujo de caja **--
      pq_cr_modulo_campanias.sp_Cr_flujocaja(j.pgcod,
                                             j.aomod,
                                             j.aosuc,
                                             j.aomda,
                                             j.aopap,
                                             j.aocta,
                                             j.aooper,
                                             j.aosbop,
                                             j.aotope,
                                             lc_flgCV);
      if lc_flgCV = 'S' then
        exit;
      end if;
    end loop;
    pc_flgM := nvl(lc_flgMora, 'N');
  
    lc_flgCV := 'N'; --mod@abr 05062020
  
    pc_flgVC := nvl(lc_flgCV, 'N');
  
  end Sp_validac_ampliado;
  ------------------------------------------------------
  procedure sp_cr_flujocaja(ln_emp10  in number,
                            ln_mod10  in number,
                            ln_suc10  in number,
                            ln_mda10  in number,
                            ln_pap10  in number,
                            ln_cta10  in number,
                            ln_oper10 in number,
                            ln_sbop10 in number,
                            ln_tope10 in number,
                            ln_flagFC out char) is
  
    ln_fc           number(17, 2);
    ln_nroflujo     number;
    lc_tienecalen   VARCHAR2(2);
    lc_tieneseguros varchar2(2);
    ld_fecamort     date; --mod@abr 17032020
    lc_Amort        char(1) := 'N'; --mod@abr 17032020
  
  begin
  
    begin
      -- verifica si tiene calendario de pago 05/07/2017 mpostigoc
    
      select 'S'
        into lc_tienecalen
        from fsd601 f
       where f.pgcod = ln_emp10
         and f.ppmod = ln_mod10
         and f.ppsuc = ln_suc10
         and f.ppmda = ln_mda10
         and f.pppap = ln_pap10
         and f.ppcta = ln_cta10
         and f.ppoper = ln_oper10
         and f.ppsbop = ln_sbop10
         and f.pptope = ln_tope10
         and rownum = 1;
    exception
      when others then
        lc_tienecalen := 'N';
    end;
  
    begin
      -- Verifica si tiene calendario de Seguros 05/07/2017 mpostigoc
      select 'S'
        into lc_tieneseguros
        from fsd611 f
       where f.pgcod = ln_emp10
         and f.ppmod = ln_mod10
         and f.ppsuc = ln_suc10
         and f.ppmda = ln_mda10
         and f.pppap = ln_pap10
         and f.ppcta = ln_cta10
         and f.ppoper = ln_oper10
         and f.ppsbop = ln_sbop10
         and f.pptope = ln_tope10
         and rownum = 1;
    exception
      when others then
        lc_tieneseguros := 'N';
    end;
  
    --mod@abr 17032020
    ----excluir amortizaciones 
    begin
      select max(a.evfval)
        into ld_fecamort
        from fsd012 a
       where a.pgcod = ln_emp10
         and a.aomod = ln_mod10
         and a.aosuc = ln_suc10
         and a.aomda = ln_mda10
         and a.aopap = ln_pap10
         and a.aocta = ln_cta10
         and a.aooper = ln_oper10
         and a.aosbop = ln_sbop10
         and a.aotope = ln_tope10
         and a.evtipo in (31, 50);
    exception
      when others then
        null;
    end;
  
    if ld_fecamort is not null then
      lc_Amort := 'S';
    else
      lc_Amort := 'N';
    end if;
    --mod@abr 17032020
  
    if lc_Amort = 'S' then
      --mod@abr 17032020
      if lc_tienecalen = 'S' and lc_tieneseguros = 'S' then
        --05/07/2017 mpostigoc
      
        begin
        
          select max(f.ppcap + f.ppint + s.ppimp11 + s.ppimp12 + s.ppimp13 +
                     s.ppimp14 + s.ppimp15) -
                 min(f.ppcap + f.ppint + s.ppimp11 + s.ppimp12 + s.ppimp13 +
                     s.ppimp14 + s.ppimp15)
            into ln_fc
            from fsd601 f, fsd611 s
          
           where f.pgcod = ln_emp10
             and f.ppmod = ln_mod10
             and f.ppsuc = ln_suc10
             and f.ppmda = ln_mda10
             and f.pppap = ln_pap10
             and f.ppcta = ln_cta10
             and f.ppoper = ln_oper10
             and f.ppsbop = ln_sbop10
             and f.pptope = ln_tope10
             and f.pgcod = s.pgcod
             and f.ppmod = s.ppmod
             and f.ppsuc = s.ppsuc
             and f.ppmda = s.ppmda
             and f.pppap = s.pppap
             and f.ppcta = s.ppcta
             and f.ppoper = s.ppoper
             and f.ppsbop = s.ppsbop
             and f.pptope = s.pptope
             and f.ppfpag = s.ppfpag
             and f.ppfpag > ld_fecamort; --mod@abr 17032020
        exception
          when others then
            null;
          
        end;
      
      else
        if lc_tienecalen = 'S' and lc_tieneseguros = 'N' then
          --05/07/2017 mpostigoc
        
          begin
            select max(f.ppcap + f.ppint) - min(f.ppcap + f.ppint)
              into ln_fc
              from fsd601 f
             where f.pgcod = ln_emp10
               and f.ppmod = ln_mod10
               and f.ppsuc = ln_suc10
               and f.ppmda = ln_mda10
               and f.pppap = ln_pap10
               and f.ppcta = ln_cta10
               and f.ppoper = ln_oper10
               and f.ppsbop = ln_sbop10
               and f.pptope = ln_tope10
               and f.ppfpag > ld_fecamort; --mod@abr 17032020
          exception
            when others then
              null;
          end;
        
        end if;
      end if;
    else
      if lc_tienecalen = 'S' and lc_tieneseguros = 'S' then
        --05/07/2017 mpostigoc
      
        begin
        
          select max(f.ppcap + f.ppint + s.ppimp11 + s.ppimp12 + s.ppimp13 +
                     s.ppimp14 + s.ppimp15) -
                 min(f.ppcap + f.ppint + s.ppimp11 + s.ppimp12 + s.ppimp13 +
                     s.ppimp14 + s.ppimp15)
            into ln_fc
            from fsd601 f, fsd611 s
          
           where f.pgcod = ln_emp10
             and f.ppmod = ln_mod10
             and f.ppsuc = ln_suc10
             and f.ppmda = ln_mda10
             and f.pppap = ln_pap10
             and f.ppcta = ln_cta10
             and f.ppoper = ln_oper10
             and f.ppsbop = ln_sbop10
             and f.pptope = ln_tope10
             and f.pgcod = s.pgcod
             and f.ppmod = s.ppmod
             and f.ppsuc = s.ppsuc
             and f.ppmda = s.ppmda
             and f.pppap = s.pppap
             and f.ppcta = s.ppcta
             and f.ppoper = s.ppoper
             and f.ppsbop = s.ppsbop
             and f.pptope = s.pptope
             and f.ppfpag = s.ppfpag;
        exception
          when others then
            null;
          
        end;
      
      else
        if lc_tienecalen = 'S' and lc_tieneseguros = 'N' then
          --05/07/2017 mpostigoc
        
          begin
          
            select max(f.ppcap + f.ppint) - min(f.ppcap + f.ppint)
              into ln_fc
              from fsd601 f
             where f.pgcod = ln_emp10
               and f.ppmod = ln_mod10
               and f.ppsuc = ln_suc10
               and f.ppmda = ln_mda10
               and f.pppap = ln_pap10
               and f.ppcta = ln_cta10
               and f.ppoper = ln_oper10
               and f.ppsbop = ln_sbop10
               and f.pptope = ln_tope10;
          exception
            when others then
              null;
            
          end;
        
        end if;
      end if;
    end if;
  
    begin
    
      select tp1nro1
        into ln_nroflujo
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and tp1corr1 = 13
         and tp1corr2 = 3;
    exception
      when others then
        null;
    end;
  
    if ln_fc is not null then
    
      if ln_fc <= ln_nroflujo then
        ln_flagFC := 'N';
      else
        ln_flagFC := 'S';
      END IF;
    
    else
      if ln_fc is null then
        ln_flagFC := 'N';
      
      end if;
    
    end if;
  end sp_cr_flujocaja;

  procedure sp_CalculoRatio(ln_Pepais        in number,
                            ln_Petdoc        in number,
                            ln_Pendoc        in char,
                            tipocambio       in number,
                            Instancia        in number,
                            pd_fecpro        in date,
                            lc_prgm          in varchar2,
                            ln_Usuario       in varchar2,
                            ln_captotcaja    out number,
                            saldo_externo    out number,
                            ln_ExcdntMensual out number,
                            ln_RatioConsumo  out number) is
  
    ln_capacidad   number(17, 2);
    saldo_extSoles number(17, 2);
    saldo_extDol   number(17, 2);
    ln_cajaext     number(17, 2);
    divisor        number(17, 2);
    lc_FlgLn       varchar2(2);
    lc_fgAdic      varchar2(1); --mod 2016.04.12
    lc_fgAmpl      varchar2(1); --mod 2016.04.12
    lc_ven         char(1); --mod 2016.04.12
    ln_indicador   number(10); --mod 2016.04.12
  
    lc_fgRefLin varchar2(1); -- 28/06/16 mpostigoc
    --ResultNeto1  number(10, 2);
    ln_captotal1 number(17, 6); -- 18/07/2017 MPOSTIGOC  Cambio de longitud de Variable
    evaluacion   number(10);
    mntsoles     number(17, 2);
    mntdolar     number(17, 2);
    lc_flgprg    varchar2(2);
  
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
         and d10.Aocta in (select Ctnro
                             from fsr008
                            where pepais = ln_Pepais
                              and Petdoc = ln_Petdoc
                              and pendoc = ln_Pendoc
                           /*and Ttcod = 1
                           and Cttfir = 'T'*/
                           )
         and (d10.Aomod in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in (29, 33, 200))) --mpostigoc 04/10/18 INC1373
         and d10.Aostat <> 99
         and d10.aofvto < pd_fecpro --mpostigoc  14/12/16
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
         and c.pendoc = ln_Pendoc
            --and a.cttfir = 'T'
         and a.pgcod = b.pgcod
         and a.ctnro = b.aocta
         and (b.Aomod in (select modulo
                            from fst111
                           where dscod = 50
                             and modulo not in (29, 33, 200))) --mpostigoc 04/10/18 INC1373
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
         and d10.Aocta in (select Ctnro
                             from fsr008
                            where pepais = ln_Pepais
                              and Petdoc = ln_Petdoc
                              and pendoc = ln_Pendoc
                           /*and Ttcod = 1
                           and Cttfir = 'T'*/
                           )
         and (d10.Aomod in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in (29, 33, 200)) or --mpostigoc 04/10/18 INC1373
             d10.Aomod = 117)
         and d10.Aostat <> 99
         and d10.aofvto >= pd_fecpro --mpostigoc  14/12/16
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
         and c.pendoc = ln_Pendoc
            --and a.cttfir = 'T'
         and a.pgcod = b.pgcod
         and a.ctnro = b.aocta
         and (b.Aomod in (select modulo
                            from fst111
                           where dscod = 50
                             and modulo not in (29, 33, 200)) or --mpostigoc 04/10/18 INC1373
             b.Aomod = 117) --Agregar guia de proceso para excluir modulos
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
         and x.xwfcuenta in (select Ctnro
                               from fsr008
                              where pepais = ln_Pepais
                                and Petdoc = ln_Petdoc
                                and pendoc = ln_Pendoc
                             /*and Ttcod = 1
                             and Cttfir = 'T'*/
                             )
            
         and (x.xwfmodulo in
             (select f.modulo
                 from fst111 f
                where f.dscod = 50
                  and modulo not in (29, 33, 200)) or x.xwfmodulo = 117) --mpostigoc 04/10/18 INC1373
            
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
                            --and wftaskcod <> 55  --20160623ABR
                         and w.wfiteminit >=
                             to_date('2013.07.01', 'yyyy.mm.dd')) --20160519
                    --and wftaskcod <> 55--20160623ABR
                 and wf.wfiteminit >= to_date('2013.07.01', 'yyyy.mm.dd')) --20160519
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
         and c.pendoc = ln_Pendoc
         and a.pgcod = x.xwfempresa
         and a.ctnro = x.xwfcuenta
         and (x.xwfmodulo in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in (29, 33, 200)) or --mpostigoc 04/10/18 INC1373
             x.xwfmodulo = 117)
            
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
                            --and wftaskcod <> 55--20160623ABR
                         and w.wfitemstsact = 1
                         and w.wfiteminit >=
                             to_date('2013.07.01', 'yyyy.mm.dd')) --20160519
                    --and wftaskcod <> 55--20160623ABR
                 and wf.wfiteminit >= to_date('2013.07.01', 'yyyy.mm.dd')) --20160519
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
         and d10.Aocta in (select Ctnro
                             from fsr008
                            where pepais = ln_Pepais
                              and Petdoc = ln_Petdoc
                              and pendoc = ln_Pendoc
                           /*and Ttcod = 1
                           and Cttfir = 'T'*/
                           )
         and d10.Aomod = 117
         and d10.aofvto < pd_fecpro
      -- and Aostat <> 99
      
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
         and c.pendoc = ln_Pendoc
            --and a.cttfir = 'T'
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
            -- and b.aostat <> 99
         and b.aofvto < pd_fecpro
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66;
  
    lc_IndCred        varchar2(10);
    ln_captotcaja1    number;
    ln_captotcaja2    number;
    ln_Tarea          number;
    lc_EjecRatio      varchar2(5) := 'N';
    ln_MntCuoCntg     number;
    ln_MntCuoCntgCF   number;
    ln_MntCuoCntgAval number;
    ln_MntPotncial    number;
    ln_periodo        number;
    lc_flgAdicPanel   char(1) := 'N';
  
  begin
  
    ln_captotcaja := 0;
  
    begin
      -- Tarea de la solicitud
      select w.wftaskcod
        into ln_Tarea
        from wfwrkitems w
       where w.wfinsprcid = Instancia
         and w.wfitemstsact = 1;
    exception
      when others then
        null;
      
    end;
  
    begin
      -- 24/01/19 Verifica si el ratio 
      select 'S'
        into lc_EjecRatio
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and a.tp1corr1 = 13
         and a.TP1CORR2 = 50
         and a.tp1corr3 > 0
         and trim(a.tp1desc) = trim(lc_prgm)
         and a.tp1nro3 = ln_Tarea;
    exception
      when others then
        lc_EjecRatio := 'N';
    end;
  
    begin
    
      select 'S'
        into lc_flgprg
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and a.tp1corr1 = 200
         and a.tp1corr2 = 2
         and a.tp1corr3 = 1
         and a.tp1nro1 = 1
         and trim(a.tp1desc) = trim(lc_prgm);
    exception
      when others then
        lc_flgprg := 'N';
      
    end;
  
    if lc_prgm = 'RJAQY843' then
      -- 07/09/2017 MPOSTIGOC
    
      lc_flgprg := 'R';
    
      begin
        delete JAQZ822 J
         WHERE J.JAQZ822INST = Instancia
           and j.JAQZ822est = 'R';
      end;
      begin
        delete JAQZ821 J
         WHERE J.JAQZ821INST = Instancia
           and j.JAQZ821est = 'R';
      end;
    
    end if;
  
    if lc_flgprg = 'S' and lc_EjecRatio = 'S' then
      -- 04/09/2017 mpostigoc                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
      begin
        UPDATE JAQZ822 j
           set JAQZ822est = 'I'
         where j.JAQZ822inst = Instancia
           and j.JAQZ822est = 'H';
        commit;
      end;
    
    end if;
  
    for i in inserta loop
    
      lc_fgAdic    := null;
      lc_fgAmpl    := null;
      ln_indicador := 1;
      lc_IndCred   := 'CredVigent';
      lc_FlgLn     := 'N';
      --  if i.ln_mod10 = 117 then
    
      pq_cr_modulo_campanias.Sp_adicional_panel(i.ln_mod10,
                                                i.ln_suc10,
                                                i.ln_mda10,
                                                i.ln_pap10,
                                                i.ln_cta10,
                                                i.ln_oper10,
                                                i.ln_sbop10,
                                                i.ln_tope10,
                                                lc_flgAdicPanel);
    
      PQ_CR_RATIO_CUOCNSM.sp_refinanLinea(i.ln_pgcod10,
                                          i.ln_mod10,
                                          i.ln_suc10,
                                          i.ln_mda10,
                                          i.ln_pap10,
                                          i.ln_cta10,
                                          i.ln_oper10,
                                          lc_fgRefLin);
      --  end if;
    
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
         lc_FlgLn <> 'S' and i.ln_tope10 <> 550 and lc_flgAdicPanel <> 'S' then
        PQ_CR_RATIO_CUOCNSM.sp_resolutor(ln_Pepais,
                                         ln_Petdoc,
                                         ln_Pendoc,
                                         Instancia,
                                         pd_fecpro,
                                         i.ln_pgcod10,
                                         i.ln_mod10,
                                         i.ln_suc10,
                                         i.ln_mda10,
                                         i.ln_pap10,
                                         i.ln_cta10,
                                         i.ln_oper10,
                                         i.ln_sbop10,
                                         i.ln_tope10,
                                         i.ln_peri10,
                                         tipocambio,
                                         ln_indicador,
                                         lc_IndCred,
                                         lc_flgprg,
                                         lc_EjecRatio,
                                         ln_Usuario,
                                         ln_Tarea,
                                         ln_capacidad);
      
        -- ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      
      end if;
    
    end loop;
  
    for i in inserta_vencidos loop
    
      lc_fgAdic    := null;
      lc_fgAmpl    := null;
      ln_indicador := 1;
      lc_IndCred   := 'CredVencid';
    
      --  if i.ln_mod10 = 117 then
    
      pq_cr_modulo_campanias.Sp_adicional_panel(i.ln_mod10,
                                                i.ln_suc10,
                                                i.ln_mda10,
                                                i.ln_pap10,
                                                i.ln_cta10,
                                                i.ln_oper10,
                                                i.ln_sbop10,
                                                i.ln_tope10,
                                                lc_flgAdicPanel);
    
      PQ_CR_RATIO_CUOCNSM.sp_refinanLinea(i.ln_pgcod10,
                                          i.ln_mod10,
                                          i.ln_suc10,
                                          i.ln_mda10,
                                          i.ln_pap10,
                                          i.ln_cta10,
                                          i.ln_oper10,
                                          lc_fgRefLin);
      --  end if;
    
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
         lc_FlgLn <> 'S' and i.ln_tope10 <> 550 and lc_flgAdicPanel <> 'S' then
        PQ_CR_RATIO_CUOCNSM.sp_resolutor(ln_Pepais,
                                         ln_Petdoc,
                                         ln_Pendoc,
                                         Instancia,
                                         pd_fecpro,
                                         i.ln_pgcod10,
                                         i.ln_mod10,
                                         i.ln_suc10,
                                         i.ln_mda10,
                                         i.ln_pap10,
                                         i.ln_cta10,
                                         i.ln_oper10,
                                         i.ln_sbop10,
                                         i.ln_tope10,
                                         i.ln_peri10,
                                         tipocambio,
                                         ln_indicador,
                                         lc_IndCred,
                                         lc_flgprg,
                                         lc_EjecRatio,
                                         ln_Usuario,
                                         ln_Tarea,
                                         ln_capacidad);
      
        --ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      
      end if;
    
    end loop;
  
    for c in vuelo loop
      ln_indicador := 2;
      lc_IndCred   := 'CredVuelo';
    
      ln_periodo := c.ln_peri10;
    
      begin
        select tp1imp1
          into ln_periodo
          from fst198
         where tp1cod = 1
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
        -- mpostigoc 22062020
      
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
      
        PQ_CR_RATIO_CUOCNSM.sp_resolutor(ln_Pepais,
                                         ln_Petdoc,
                                         ln_Pendoc,
                                         Instancia,
                                         pd_fecpro,
                                         c.ln_pgcod10,
                                         c.ln_mod10,
                                         c.ln_suc10,
                                         c.ln_mda10,
                                         c.ln_pap10,
                                         c.ln_cta10,
                                         c.ln_oper10,
                                         c.ln_sbop10,
                                         c.ln_tope10,
                                         ln_periodo,
                                         tipocambio,
                                         ln_indicador,
                                         lc_IndCred,
                                         lc_flgprg,
                                         lc_EjecRatio,
                                         ln_Usuario,
                                         ln_Tarea,
                                         ln_capacidad);
      
        -- ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      
      end if;
    
    end loop;
  
    --mod 2016.04.13
    for j in lineas_ven loop
    
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
        PQ_CR_RATIO_CUOCNSM.sp_resolutor_venc(ln_Pepais,
                                              ln_Petdoc,
                                              ln_Pendoc,
                                              Instancia,
                                              pd_fecpro,
                                              j.ln_pgcod10,
                                              j.ln_mod10,
                                              j.ln_suc10,
                                              j.ln_mda10,
                                              j.ln_pap10,
                                              j.ln_cta10,
                                              j.ln_oper10,
                                              j.ln_sbop10,
                                              j.ln_tope10,
                                              -- j.ln_peri10,
                                              tipocambio,
                                              lc_IndCred,
                                              lc_flgprg,
                                              lc_EjecRatio,
                                              ln_Usuario,
                                              ln_tarea,
                                              ln_capacidad);
      
        -- ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0);
      end if;
    
    end loop;
  
    if lc_prgm = 'RJAQY843' then
    
      begin
        -- mpostigoc INC1373 04/10/18    
        select sum(j.jaqz822capcuo)
          into ln_captotcaja1
          from jaqz822 j
         where j.jaqz822inst = Instancia
           and j.jaqz822est = 'R'
           and (j.jaqz822mod not in
               (select tp1nro1
                   from fst198 a
                  where a.tp1cod = 1
                    and a.tp1cod1 = 10899
                    and a.tp1corr1 = 200
                    and a.tp1corr2 = 1
                    and a.tp1corr3 > 0) and j.jaqz822mod not in 117) --mpostigoc 051118                   
           and j.jaqz822nrcuo > 1
           and j.jaqz822indic in
               ('CredVigent', 'CredVencid', 'CredVuelo', 'LineaVencd');
      exception
        when others then
          ln_captotcaja1 := 0;
      end;
      begin
        -- mpostigoc INC1373 04/10/18    
        select sum(j.jaqz822capcuo)
          into ln_captotcaja2
          from jaqz822 j
         where j.jaqz822inst = Instancia
           and j.jaqz822est = 'R'
           and j.jaqz822mod = 117
           and j.jaqz822indic in
               ('CredVigent', 'CredVencid', 'CredVuelo', 'LineaVencd');
      exception
        when others then
          ln_captotcaja2 := 0;
      end;
    
      ln_captotcaja := nvl(ln_captotcaja1, 0) + nvl(ln_captotcaja2, 0);
    
    else
    
      begin
        -- mpostigoc INC1373 04/10/18    
        select sum(j.jaqz822capcuo)
          into ln_captotcaja1
          from jaqz822 j
         where j.jaqz822inst = Instancia
           and j.jaqz822est = 'H'
           and (j.jaqz822mod not in
               (select tp1nro1
                   from fst198 a
                  where a.tp1cod = 1
                    and a.tp1cod1 = 10899
                    and a.tp1corr1 = 200
                    and a.tp1corr2 = 1
                    and a.tp1corr3 > 0) and j.jaqz822mod not in 117) --mpostigoc 051118 
           and j.jaqz822nrcuo > 1
           and j.jaqz822indic in
               ('CredVigent', 'CredVencid', 'CredVuelo', 'LineaVencd');
      exception
        when others then
          ln_captotcaja1 := 0;
      end;
    
      begin
        -- mpostigoc INC1373 04/10/18    
        select sum(j.jaqz822capcuo)
          into ln_captotcaja2
          from jaqz822 j
         where j.jaqz822inst = Instancia
           and j.jaqz822est = 'H'
           and j.jaqz822mod = 117
           and j.jaqz822indic in
               ('CredVigent', 'CredVencid', 'CredVuelo', 'LineaVencd');
      exception
        when others then
          ln_captotcaja2 := 0;
      end;
    
      ln_captotcaja := nvl(ln_captotcaja1, 0) + nvl(ln_captotcaja2, 0);
    
    end if;
  
    begin
      -- Cuota Contingente PRY1574 
      PQ_CR_RATIO_CUOCNSM.sp_cr_CuotaContinCF(Instancia,
                                              pd_fecpro,
                                              lc_flgprg,
                                              ln_MntCuoCntgCF);
    
      PQ_CR_RATIO_CUOCNSM.sp_cr_CuotaContinAval(Instancia,
                                                pd_fecpro,
                                                lc_flgprg,
                                                ln_MntCuoCntgAval);
    
      ln_MntCuoCntg := ln_MntCuoCntgCF + ln_MntCuoCntgAval;
    end;
  
    /* begin
      -- Cuota Potencial PRY1574
      PQ_CR_RATIO_CUOCNSM.sp_cR_CuotaPotencial(Instancia, ln_MntPotncial);
    end;*/
  
    -- 09/07/2019 mpostigoc
    begin
      pq_cr_resolutor_cappago.sp_cr_CuotaPotencialII(Instancia,
                                                     pd_fecpro,
                                                     ln_Usuario,
                                                     ln_MntPotncial);
    end;
  
    if ln_MntPotncial = 9999 then
      -- 07/03/2019 mpostigoc
      ln_RatioConsumo := 9999;
    
    else
      begin
        -- deuda externa
        begin
          --MPOSTIGOC 04/10/18 INC1373
          -- actualizamos todos los valores que se tienen para la tarea de Evaluacion/Propuesta
          update JAQZ862 j
             set j.JAQZ862aux3 = ''
           where j.JAQZ862inst = Instancia
             and j.JAQZ862aux1 = 7; --Tarea de Evaluacion Propuesta
          commit;
        end;
      
        begin
          --MPOSTIGOC 04/10/18 INC1373
          -- actualizamos los ultimos valores que se tienen para la tarea de Evaluacion/Propuesta contabilizados
          -- con una marca en R
          update JAQZ862 j
             set j.JAQZ862aux3 = 'R'
           where j.JAQZ862inst = Instancia
             and j.JAQZ862esta = 'S'
             and j.JAQZ862chek = '1'
             and j.JAQZ862aux1 = 7; --Tarea de Evaluacion Propuesta
          commit;
        end;
      
        begin
          select sum(j.JAQZ862gfin)
            into saldo_extSoles
            from JAQZ862 j
           where j.JAQZ862inst = Instancia
             and j.JAQZ862esta = 'S'
             and j.JAQZ862chek = '1'
             and j.JAQZ862tcre in
                 ('Pymes S/.', 'Consumo S/.', 'Hipotecario S/.')
             and j.JAQZ862aux3 = 'R' --MPOSTIGOC 04/10/18 INC1373
             and j.JAQZ862aux1 = 7; --MPOSTIGOC 04/10/18 INC1373
        exception
          when others then
            saldo_extSoles := 0;
        end;
      
        begin
          begin
            select sum(j.JAQZ862gfin)
              into saldo_extDol
              from JAQZ862 j
             where j.JAQZ862inst = Instancia
               and j.JAQZ862esta = 'S'
               and j.JAQZ862chek = '1'
               and j.JAQZ862tcre in
                   ('Pymes US$', 'Consumo US$', 'Hipotecario US$')
               and j.JAQZ862aux3 = 'R' --MPOSTIGOC 04/10/18 INC1373
               and j.JAQZ862aux1 = 7; --MPOSTIGOC 04/10/18 INC1373
          exception
            when others then
              saldo_extDol := 0;
          end;
        
          saldo_extDol := nvl(saldo_extDol, 0) * tipocambio;
        
        end;
      
        saldo_externo := nvl(saldo_extDol, 0) + nvl(saldo_extSoles, 0);
      end;
    
      begin
        -- Suma de Deuda Caja y Deuda Externa
      
        ln_cajaext := nvl(ln_captotcaja, 0) + nvl(saldo_externo, 0) +
                      nvl(ln_MntCuoCntg, 0) + nvl(ln_MntPotncial, 0);
      end;
    
      begin
        --- Excedente Mensual
      
        begin
          select a.sng021eval
            into evaluacion
            from sng021 a
           where a.sng021sol = Instancia;
        exception
          when others then
            null;
        end;
      
        begin
          select a.sng023mto
            into mntsoles
            from sng023 a
           where a.sng021eval = evaluacion
             and a.sng026cod = 27;
        exception
          when others then
            null;
        end;
      
        begin
          select a.sng023mto
            into mntdolar
            from sng023 a
           where a.sng021eval = evaluacion
             and a.sng026cod = 527;
        exception
          when others then
            null;
        end;
      
        ln_ExcdntMensual := ((mntdolar * tipocambio) + mntsoles);
        ln_ExcdntMensual := nvl(ln_ExcdntMensual, 0);
      
      end;
    
      begin
      
        Divisor := nvl(ln_ExcdntMensual, 0) + nvl(saldo_externo, 0) /*+
                                                                                                                   nvl(ln_MntPotncial, 0)*/
         ;
      end;
    
      if Divisor <> 0 then
        ln_captotal1 := round((nvl(ln_cajaext, 0) / Divisor), 6);
      else
        ln_captotal1 := 0;
      end if;
    
      ln_RatioConsumo := nvl(ln_captotal1, 0);
    
    end if; -- 07/03/2019 mpostigoc
  
    if (lc_flgprg = 'S' or lc_flgprg = 'R') and lc_EjecRatio = 'S' then
    
      PQ_CR_RATIO_CUOCNSM.sp_cr_LogRatio(ln_Pepais        => ln_Pepais,
                                         ln_Petdoc        => ln_Petdoc,
                                         ln_Pendoc        => ln_Pendoc,
                                         tipocambio       => tipocambio,
                                         Instancia        => Instancia,
                                         pd_fecpro        => pd_fecpro,
                                         ln_captotcaja    => ln_captotcaja,
                                         saldo_externo    => saldo_externo,
                                         ln_ExcdntMensual => ln_ExcdntMensual,
                                         ln_MntCuoCntg    => ln_MntCuoCntg,
                                         ln_MntPotncial   => ln_MntPotncial,
                                         ln_RatioConsumo  => ln_RatioConsumo,
                                         lc_indicador     => 'CS',
                                         lc_flgprg        => lc_flgprg,
                                         lc_Usuario       => ln_Usuario,
                                         ln_Tarea         => ln_Tarea);
    end if;
  
  end sp_CalculoRatio;
  ------------------------------------------------------------------------------------
  Procedure Sp_adicional_panel(pn_mod in number,
                               pn_suc in number,
                               pn_mda in number,
                               pn_pap in number,
                               pn_cta in number,
                               pn_ope in number,
                               pn_sbo in number,
                               pn_top in number,
                               pc_flg out char) is
    lc_flg char(1) := 'N';
  begin
  
    begin
      select 'S'
        into lc_flg
        from jaqz697 a
       where a.jaqz697moa = pn_mod
         and a.jaqz697sua = pn_suc
         and a.jaqz697maa = pn_mda
         and a.jaqz697paa = pn_pap
         and a.jaqz697caa = pn_cta
         and a.jaqz697opa = pn_ope
         and a.jaqz697sba = pn_sbo
         and a.jaqz697toa = pn_top
         and a.jaqz697tip = 'A'
         and rownum = 1;
    exception
      when others then
        lc_flg := 'N';
    end;
  
    pc_flg := nvl(lc_flg, 'N');
  
  end Sp_adicional_panel;

  procedure sp_CalculoRAtioPYME(ln_Pepais     in number,
                                ln_Petdoc     in number,
                                ln_Pendoc     in char,
                                tipocambio    in number,
                                Instancia     in number,
                                pd_fecpro     in date,
                                lc_prgm       in varchar2,
                                lc_Usuario    in varchar2,
                                ln_captotcaja out number,
                                saldo_externo out number,
                                ResultNeto    out number,
                                ln_captotal   out number) is
  
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
         and d10.Aocta in (select Ctnro
                             from fsr008
                            where pepais = ln_Pepais
                              and Petdoc = ln_Petdoc
                              and pendoc = ln_Pendoc
                           /*and Ttcod = 1
                           and Cttfir = 'T'*/
                           )
         and (d10.Aomod in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in (29, 33, 200))) --mpostigoc INC1373 04/10/18
         and d10.Aostat <> 99
         and d10.aofvto < pd_fecpro --mpostigoc  14/12/16
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
         and c.pendoc = ln_Pendoc
            --and a.cttfir = 'T'
         and a.pgcod = b.pgcod
         and a.ctnro = b.aocta
         and (b.Aomod in (select modulo
                            from fst111
                           where dscod = 50
                             and modulo not in (29, 33, 200))) --mpostigoc INC1373 04/10/18
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
         and d10.Aocta in (select Ctnro
                             from fsr008
                            where pepais = ln_Pepais
                              and Petdoc = ln_Petdoc
                              and pendoc = ln_Pendoc
                           /*and Ttcod = 1
                           and Cttfir = 'T'*/
                           )
         and (d10.Aomod in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in (29, 33, 200)) or -- mpostigoc INC1373 04/10/18
             d10.Aomod = 117)
         and d10.Aostat <> 99
         and d10.aofvto >= pd_fecpro --mpostigoc  14/12/16
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
         and c.pendoc = ln_Pendoc
            --and a.cttfir = 'T'
         and a.pgcod = b.pgcod
         and a.ctnro = b.aocta
         and (b.Aomod in (select modulo
                            from fst111
                           where dscod = 50
                             and modulo not in (29, 33, 200)) or -- mpostigoc INC1373 04/10/18
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
         and x.xwfcuenta in (select Ctnro
                               from fsr008
                              where pepais = ln_Pepais
                                and Petdoc = ln_Petdoc
                                and pendoc = ln_Pendoc
                             /*and Ttcod = 1
                             and Cttfir = 'T'*/
                             )
            
         and (x.xwfmodulo in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in (29, 33, 200)) or -- mpostigoc INC1373 04/10/18
             x.xwfmodulo = 117)
            
         and x.XWFPRCINS in
             (select wfinsprcid
                from wfwrkitems wf
               where wf.wfinsprcid = x.xwfprcins
                 and wf.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
                 and wf.wfiteminit =
                     (select max(wfiteminit)
                        from wfwrkitems w
                       where w.wfinsprcid = x.xwfprcins
                         and w.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
                         and w.wfitemstsact = 1
                            --and wftaskcod <> 55  --20160623ABR
                         and w.wfiteminit >=
                             to_date('2013.07.01', 'yyyy.mm.dd')) --20160519
                    --and wftaskcod <> 55--20160623ABR
                 and wf.wfiteminit >= to_date('2013.07.01', 'yyyy.mm.dd')) --20160519
         and s.sng120ins = x.XWFPRCINS
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
         and c.pendoc = ln_Pendoc
         and a.pgcod = x.xwfempresa
         and a.ctnro = x.xwfcuenta
         and (x.xwfmodulo in
             (select modulo
                 from fst111
                where dscod = 50
                  and modulo not in (29, 33, 200)) or -- mpostigoc INC1373 04/10/18
             x.xwfmodulo = 117)
            
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66
         and x.XWFPRCINS in
             (select wfinsprcid
                from wfwrkitems wf
               where wf.wfinsprcid = x.xwfprcins
                 and wf.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
                 and wf.wfiteminit =
                     (select max(wfiteminit)
                        from wfwrkitems w
                       where w.wfinsprcid = x.xwfprcins
                         and w.WFSTSCOD not in ('C', 'D', 'B', 'E', 'T')
                            --and wftaskcod <> 55--20160623ABR
                         and w.wfitemstsact = 1
                         and w.wfiteminit >=
                             to_date('2013.07.01', 'yyyy.mm.dd')) --20160519
                    --and wftaskcod <> 55--20160623ABR
                 and wf.wfiteminit >= to_date('2013.07.01', 'yyyy.mm.dd')) --20160519
         and s.sng120ins = x.XWFPRCINS
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
         and d10.Aocta in (select Ctnro
                             from fsr008
                            where pepais = ln_Pepais
                              and Petdoc = ln_Petdoc
                              and pendoc = ln_Pendoc
                           /*and Ttcod = 1
                           and Cttfir = 'T'*/
                           )
         and d10.Aomod = 117
         and d10.aofvto < pd_fecpro
      -- and Aostat <> 99
      
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
         and c.pendoc = ln_Pendoc
            --and a.cttfir = 'T'
         and a.pgcod = b.pgcod
         and a.ctnro = b.aocta
         and b.aomod = 117
            -- and b.aostat <> 99
         and b.aofvto < pd_fecpro
         and a.pepais = c.rppais
         and a.petdoc = c.rptdoc
         and a.pendoc = c.rpndoc
         and c.rpccyg = 66;
  
    ln_capacidad number(17, 2);
    --saldo_extSoles    number(17, 2);
    --saldo_extDol      number(17, 2);
    divisor           number(17, 2);
    evaluacion        number(17, 2);
    mntsoles          number(17, 2);
    mntdolar          number(17, 2);
    lc_FlgLn          varchar2(2);
    lc_fgAdic         varchar2(1); --mod 2016.04.12
    lc_fgAmpl         varchar2(1); --mod 2016.04.12
    lc_ven            char(1); --mod 2016.04.12
    ln_indicador      number(10); --mod 2016.04.12
    lc_fgRefLin       varchar2(1); -- 28/06/16 mpostigoc
    ln_captotal1      number(10, 6); -- 18/07/2017 MPOSTIGOC  Cambio de longitud de Variable
    lc_flgprg         varchar2(2) := 'N';
    lc_IndCred        varchar2(10);
    ln_tipocambio     number;
    ln_captotcaja1    number;
    ln_captotcaja2    number;
    ln_MntCuoCntgCF   number := 0;
    ln_MntCuoCntgAval number := 0;
    ln_MntCuoCntg     number := 0;
    ln_MntPotncial    number := 0;
    lc_EjecRatio      varchar2(5) := 'N';
    ln_Tarea          number(10);
    ln_Periodo        number;
    lc_TieneInfoPSD   varchar2(2) := 'N';
    ln_NroSolCredME   number;
    ln_NroEvalME      number;
    lc_flgAdicPanel   char(1) := 'N';
  begin
  
    ln_captotcaja := 0;
  
    ln_tipocambio := tipocambio;
  
    begin
      -- Tarea de la solicitud
      select w.wftaskcod
        into ln_Tarea
        from wfwrkitems w
       where w.wfinsprcid = Instancia
         and w.wfitemstsact = 1;
    exception
      when others then
        null;
      
    end;
  
    begin
      -- 24/01/19 Verifica si el ratio 
      select 'S'
        into lc_EjecRatio
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and a.tp1corr1 = 13
         and a.TP1CORR2 = 50
         and a.tp1corr3 > 0
         and trim(a.tp1desc) = trim(lc_prgm)
         and a.tp1nro3 = ln_Tarea;
    exception
      when others then
        lc_EjecRatio := 'N';
    end;
  
    -- 24/01/19 Solo si la tarea y programa stan incluidos en la guia pueden ejecutar el ratio
    -- excepcionado la impresion de ratios
  
    begin
      select 'S'
        into lc_flgprg
        from fst198 a
       where a.tp1cod = 1
         and a.tp1cod1 = 10899
         and a.tp1corr1 = 13
         and a.tp1corr2 = 4
         and a.tp1corr3 = 1
         and a.tp1nro1 = 1
         and trim(a.tp1desc) = trim(lc_prgm);
    exception
      when others then
        lc_flgprg := 'N';
      
    end;
  
    if lc_prgm = 'RJAQY843' then
      -- 07/09/2017 MPOSTIGOC
    
      lc_flgprg := 'R';
    
      begin
        delete JAQY142 J
         WHERE J.JAQY142INST = Instancia
           and j.jaqy142est = 'R';
      end;
      begin
        delete JAQY140 J
         WHERE J.JAQY140INST = Instancia
           and j.jaqy140est = 'R';
      end;
    
    end if;
  
    if lc_flgprg = 'S' and lc_EjecRatio = 'S' then
      -- 04/09/2017 mpostigoc                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
      begin
        UPDATE jaqy142 j
           set jaqy142est = 'I'
         where j.jaqy142inst = Instancia
           and j.jaqy142est = 'H';
        commit;
      end;
    
    end if;
  
    if tipocambio is null or tipocambio <= 0 then
    
      begin
        select s. sng120tcbi
          into ln_tipocambio
          from sng120 s
         where s.sng120ins = Instancia
           and s.sng120tsk = 'EVALUACION';
      exception
        when others then
          ln_tipocambio := 0;
      end;
    
    end if;
  
    for i in inserta loop
    
      lc_fgAdic    := null;
      lc_fgAmpl    := null;
      ln_indicador := 1;
      lc_IndCred   := 'CredVigent';
      lc_FlgLn     := 'N';
      --  if i.ln_mod10 = 117 then
    
      pq_cr_modulo_campanias.Sp_adicional_panel(i.ln_mod10,
                                                i.ln_suc10,
                                                i.ln_mda10,
                                                i.ln_pap10,
                                                i.ln_cta10,
                                                i.ln_oper10,
                                                i.ln_sbop10,
                                                i.ln_tope10,
                                                lc_flgAdicPanel);
    
      pq_cr_resolutor_cappago.sp_refinanLinea(i.ln_pgcod10,
                                              i.ln_mod10,
                                              i.ln_suc10,
                                              i.ln_mda10,
                                              i.ln_pap10,
                                              i.ln_cta10,
                                              i.ln_oper10,
                                              lc_fgRefLin);
      --  end if;
    
      pq_cr_resolutor_cappago.Sp_Adicional_CK(i.ln_mod10,
                                              i.ln_tope10,
                                              lc_fgAdic);
      pq_cr_resolutor_cappago.Sp_ampliados_CK(i.ln_pgcod10,
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
         lc_FlgLn <> 'S' and i.ln_tope10 <> 550 and lc_flgAdicPanel <> 'S' then
        pq_cr_resolutor_cappago.sp_resolutor(ln_Pepais,
                                             ln_Petdoc,
                                             ln_Pendoc,
                                             Instancia,
                                             pd_fecpro,
                                             i.ln_pgcod10,
                                             i.ln_mod10,
                                             i.ln_suc10,
                                             i.ln_mda10,
                                             i.ln_pap10,
                                             i.ln_cta10,
                                             i.ln_oper10,
                                             i.ln_sbop10,
                                             i.ln_tope10,
                                             i.ln_peri10,
                                             ln_tipocambio,
                                             ln_indicador,
                                             lc_IndCred,
                                             lc_flgprg,
                                             lc_EjecRatio,
                                             lc_Usuario,
                                             ln_capacidad,
                                             ln_Tarea);
      
        --  ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0); -- mpostigoc INC1373 04/10/18
      
      end if;
    
    end loop;
  
    for i in inserta_vencidos loop
    
      lc_fgAdic    := null;
      lc_fgAmpl    := null;
      ln_indicador := 1;
      lc_IndCred   := 'CredVencid';
    
      --  if i.ln_mod10 = 117 then
      pq_cr_modulo_campanias.Sp_adicional_panel(i.ln_mod10,
                                                i.ln_suc10,
                                                i.ln_mda10,
                                                i.ln_pap10,
                                                i.ln_cta10,
                                                i.ln_oper10,
                                                i.ln_sbop10,
                                                i.ln_tope10,
                                                lc_flgAdicPanel);
    
      pq_cr_resolutor_cappago.sp_refinanLinea(i.ln_pgcod10,
                                              i.ln_mod10,
                                              i.ln_suc10,
                                              i.ln_mda10,
                                              i.ln_pap10,
                                              i.ln_cta10,
                                              i.ln_oper10,
                                              lc_fgRefLin);
      --  end if;
    
      pq_cr_resolutor_cappago.Sp_Adicional_CK(i.ln_mod10,
                                              i.ln_tope10,
                                              lc_fgAdic);
      pq_cr_resolutor_cappago.Sp_ampliados_CK(i.ln_pgcod10,
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
         lc_FlgLn <> 'S' and i.ln_tope10 <> 550 and lc_flgAdicPanel <> 'S' then
        pq_cr_resolutor_cappago.sp_resolutor(ln_Pepais,
                                             ln_Petdoc,
                                             ln_Pendoc,
                                             Instancia,
                                             pd_fecpro,
                                             i.ln_pgcod10,
                                             i.ln_mod10,
                                             i.ln_suc10,
                                             i.ln_mda10,
                                             i.ln_pap10,
                                             i.ln_cta10,
                                             i.ln_oper10,
                                             i.ln_sbop10,
                                             i.ln_tope10,
                                             i.ln_peri10,
                                             ln_tipocambio,
                                             ln_indicador,
                                             lc_IndCred,
                                             lc_flgprg,
                                             lc_EjecRatio,
                                             lc_Usuario,
                                             ln_capacidad,
                                             ln_Tarea);
      
        --   ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0); -- mpostigoc INC1373 04/10/18
      
      end if;
    
    end loop;
  
    for c in vuelo loop
      ln_indicador := 2;
      lc_IndCred   := 'CredVuelo';
    
      ln_periodo := c.ln_peri10;
    
      begin
        select tp1imp1
          into ln_periodo
          from fst198
         where tp1cod = 1
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
        -- mpostigoc 22062020
      
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
    
      pq_cr_resolutor_cappago.Sp_Adicional_CK(c.ln_mod10,
                                              c.ln_tope10,
                                              lc_fgAdic);
    
      if lc_fgAdic <> 'S' then
      
        pq_cr_resolutor_cappago.sp_resolutor(ln_Pepais,
                                             ln_Petdoc,
                                             ln_Pendoc,
                                             Instancia,
                                             pd_fecpro,
                                             c.ln_pgcod10,
                                             c.ln_mod10,
                                             c.ln_suc10,
                                             c.ln_mda10,
                                             c.ln_pap10,
                                             c.ln_cta10,
                                             c.ln_oper10,
                                             c.ln_sbop10,
                                             c.ln_tope10,
                                             ln_periodo,
                                             ln_tipocambio,
                                             ln_indicador,
                                             lc_IndCred,
                                             lc_flgprg,
                                             lc_EjecRatio,
                                             lc_Usuario,
                                             ln_capacidad,
                                             ln_Tarea);
      
        --   ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0); -- mpostigoc INC1373 04/10/18
      
      end if;
    
    end loop;
  
    --mod 2016.04.13
    for j in lineas_ven loop
    
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
    
      pq_cr_resolutor_cappago.Sp_Adicional_CK(j.ln_mod10,
                                              j.ln_tope10,
                                              lc_fgAdic);
    
      pq_cr_resolutor_cappago.sp_refinanLinea(J.ln_pgcod10,
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
        pq_cr_resolutor_cappago.sp_resolutor_venc(ln_Pepais,
                                                  ln_Petdoc,
                                                  ln_Pendoc,
                                                  Instancia,
                                                  pd_fecpro,
                                                  j.ln_pgcod10,
                                                  j.ln_mod10,
                                                  j.ln_suc10,
                                                  j.ln_mda10,
                                                  j.ln_pap10,
                                                  j.ln_cta10,
                                                  j.ln_oper10,
                                                  j.ln_sbop10,
                                                  j.ln_tope10,
                                                  -- j.ln_peri10,
                                                  ln_tipocambio,
                                                  lc_IndCred,
                                                  lc_flgprg,
                                                  lc_EjecRatio,
                                                  ln_Tarea,
                                                  ln_capacidad);
      
        --ln_captotcaja := nvl(ln_captotcaja, 0) + nvl(ln_capacidad, 0); -- mpostigoc INC1373 04/10/18
      end if;
    
    end loop;
  
    begin
      -- Cuota Contingente PRY1527 
      pq_cr_resolutor_cappago.sp_cr_CuotaContinCF(Instancia,
                                                  pd_fecpro,
                                                  lc_flgprg,
                                                  ln_MntCuoCntgCF);
    
      pq_cr_resolutor_cappago.sp_cr_CuotaContinAval(Instancia,
                                                    pd_fecpro,
                                                    lc_flgprg,
                                                    ln_MntCuoCntgAval);
    
      ln_MntCuoCntg := ln_MntCuoCntgCF + ln_MntCuoCntgAval;
      ln_MntCuoCntg := nvl(ln_MntCuoCntg, 0);
    end;
  
    /*begin
      -- Cuota Potencial PRY1527
      pq_cr_resolutor_cappago.sp_cR_CuotaPotencial(Instancia,
                                                   ln_MntPotncial);
    end;*/
  
    -- 09/07/2019 mpostigoc
    begin
      pq_cr_resolutor_cappago.sp_cr_CuotaPotencialII(Instancia,
                                                     pd_fecpro,
                                                     lc_Usuario,
                                                     ln_MntPotncial);
      ln_MntPotncial := nvl(ln_MntPotncial, 0);
    
    end;
  
    if lc_prgm = 'RJAQY843' then
    
      begin
        -- mpostigoc INC1373 04/10/18
      
        select sum(j.jaqy142capcuo)
          into ln_captotcaja1
          from jaqy142 j
         where j.jaqy142inst = Instancia
           and j.jaqy142est = 'R'
           and (j.jaqy142mod not in
               (select tp1nro1
                   from fst198 a
                  where a.tp1cod = 1
                    and a.tp1cod1 = 10899
                    and a.tp1corr1 = 13
                    and a.tp1corr2 = 1) and j.jaqy142mod not in 117) --mpostigoc 051118
           and j.jaqy142nrcuo > 1
           and j.jaqy142indic in
               ('CredVigent', 'CredVencid', 'CredVuelo', 'LineaVencd');
      exception
        when others then
          ln_captotcaja1 := 0;
      end;
    
      begin
        -- mpostigoc INC1373 04/10/18    
        select sum(j.jaqy142capcuo)
          into ln_captotcaja2
          from jaqy142 j
         where j.jaqy142inst = Instancia
           and j.jaqy142est = 'R'
           and j.jaqy142mod = 117
           and j.jaqy142indic in
               ('CredVigent', 'CredVencid', 'CredVuelo', 'LineaVencd');
      exception
        when others then
          ln_captotcaja2 := 0;
      end;
    
      ln_captotcaja := nvl(ln_captotcaja1, 0) + nvl(ln_captotcaja2, 0);
    
    else
    
      begin
        -- mpostigoc INC1373 04/10/18
      
        select sum(j.jaqy142capcuo)
          into ln_captotcaja1
          from jaqy142 j
         where j.jaqy142inst = Instancia
           and j.jaqy142est = 'H'
           and (j.jaqy142mod not in
               (select tp1nro1
                   from fst198 a
                  where a.tp1cod = 1
                    and a.tp1cod1 = 10899
                    and a.tp1corr1 = 13
                    and a.tp1corr2 = 1) and j.jaqy142mod not in 117) --mpostigoc 051118
           and j.jaqy142nrcuo > 1
           and j.jaqy142indic in
               ('CredVigent', 'CredVencid', 'CredVuelo', 'LineaVencd');
      exception
        when others then
          ln_captotcaja1 := 0;
      end;
    
      begin
        -- mpostigoc INC1373 04/10/18    
        select sum(j.jaqy142capcuo)
          into ln_captotcaja2
          from jaqy142 j
         where j.jaqy142inst = Instancia
           and j.jaqy142est = 'H'
           and j.jaqy142mod = 117
           and j.jaqy142indic in
               ('CredVigent', 'CredVencid', 'CredVuelo', 'LineaVencd');
      exception
        when others then
          ln_captotcaja2 := 0;
      end;
    
      ln_captotcaja := nvl(ln_captotcaja1, 0) + nvl(ln_captotcaja2, 0);
    end if;
  
    if ln_MntPotncial = 9999 then
      -- 07/03/2019 mpostigoc
      ln_captotal := 9999;
    
    else
    
      --mpostigoc 01/08/2019 
      -- DEUDA IFIS
      pq_cr_mantiene_eval.sp_cr_verifPSD(Instancia, lc_TieneInfoPSD);
    
      if lc_TieneInfoPSD = 'S' then
        -- Para instancias que si han registrado informacion en el PSD      
        pq_cr_resolutor_cappago.sp_cr_DeudaIFIS(Instancia,
                                                ln_tipocambio,
                                                saldo_externo);
      
      else
        if lc_TieneInfoPSD = 'N' then
          -- Para instancias que no han registrado informacion en el PSD, se valida si mantienen informacion
          pq_cr_mantiene_eval.sp_cr_inicio(Instancia,
                                           saldo_externo,
                                           ln_NroSolCredME,
                                           ln_NroEvalME);
          if ln_MntPotncial = 0 then
            pq_cr_resolutor_cappago.sp_cR_CuotaPotencial(ln_NroSolCredME,
                                                         ln_MntPotncial);
          
            if ln_MntPotncial = 0 or ln_MntPotncial = 9999 then
            
              pq_cr_resolutor_cappago.sp_cr_CuotaPotencialII(ln_NroSolCredME,
                                                             pd_fecpro,
                                                             lc_Usuario,
                                                             ln_MntPotncial);
            end if;
          
          end if;
        
        end if;
      end if;
    
      begin
        --- Resultado Neto
      
        begin
          select a.sng021eval
            into evaluacion
            from sng021 a
           where a.sng021sol = Instancia;
        exception
          when others then
            null;
        end;
      
        begin
          select a.sng023mto
            into mntsoles
            from sng023 a
           where a.sng021eval = evaluacion
             and a.sng026cod = 40;
        exception
          when others then
            null;
        end;
      
        begin
          select a.sng023mto
            into mntdolar
            from sng023 a
           where a.sng021eval = evaluacion
             and a.sng026cod = 540;
        exception
          when others then
            null;
        end;
      
        ResultNeto := ((mntdolar * ln_tipocambio) + mntsoles);
        ResultNeto := nvl(ResultNeto, 0);
        ResultNeto := round(ResultNeto, 2);
      
      end;
      begin
      
        Divisor := nvl(ResultNeto, 0) + nvl(saldo_externo, 0);
      end;
    
      if Divisor <> 0 then
        --ln_captotal1 := round((nvl(ln_cajaext, 0) / Divisor), 6); --mpostigoc 210218
        ln_captotal1 := round(((ln_captotcaja + saldo_externo +
                              ln_MntCuoCntg + ln_MntPotncial) /
                              (saldo_externo + ResultNeto /*+ ln_MntPotncial*/
                              )),
                              6);
      else
        ln_captotal1 := 0;
      end if;
    
      ln_captotal := nvl(ln_captotal1, 0);
    
    end if;
  
    if (lc_flgprg = 'S' or lc_flgprg = 'R') and lc_EjecRatio = 'S' then
    
      pq_cr_resolutor_cappago.sp_cr_LogRatio(ln_Pepais      => ln_Pepais,
                                             ln_Petdoc      => ln_Petdoc,
                                             ln_Pendoc      => ln_Pendoc,
                                             tipocambio     => ln_tipocambio,
                                             Instancia      => Instancia,
                                             pd_fecpro      => pd_fecpro,
                                             ln_captotcaja  => ln_captotcaja,
                                             saldo_externo  => saldo_externo,
                                             ResultNeto     => ResultNeto,
                                             ln_captotal    => ln_captotal,
                                             lc_indicador   => 'P',
                                             lc_flgprg      => lc_flgprg,
                                             lc_Usuario     => lc_Usuario,
                                             ln_MntCuoCntg  => ln_MntCuoCntg,
                                             ln_MntPotncial => ln_MntPotncial,
                                             ln_Tarea       => ln_Tarea,
                                             ln_InstME      => ln_NroSolCredME,
                                             LN_EvalME      => ln_NroEvalME);
    end if;
  
  end sp_CalculoRAtioPYME;

  Procedure Sp_actividadEconomica(pn_pais in number,
                                  pn_tdoc in number,
                                  pc_ndoc in char,
                                  pc_act  out char) is
  
  begin
    begin
      select xx.actnom1
        into pc_act
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
            into pc_act
            from sngc11 cc, fst750 xxx
           where cc.sngc11pais = pn_pais
             and cc.sngc11tdoc = pn_tdoc
             and cc.sngc11ndoc = pc_ndoc
             and cc.sngc11act2 = xxx.actcod1;
        exception
          when no_data_found then
            begin
            
              select xxx.actnom1
                into pc_act
                from fse001 cc, fst750 xxx
               where cc.d511pais = pn_pais
                 and cc.d511tdoc = pn_tdoc
                 and cc.d511ndoc = pc_ndoc
                 and cc.expnins = xxx.actcod1;
            exception
              when others then
                pc_act := null;
            end;
        end;
      
      when others then
        pc_act := null;
    end;
  
  end Sp_actividadEconomica;
  ------------------------------------------------------
  Procedure sp_resolutorJAQL152(pn_pai   in number,
                                pn_tdo   in number,
                                pc_ndo   in char,
                                pn_cta   in number,
                                pc_flg   out char,
                                pc_error out char) is
  
    lc_bco    char(1) := 'N';
    lc_flg    char(1) := 'N';
    lc_err    char(70) := null;
    ln_cont   number(10);
    ln_cont2  number(10);
    lc_flg2   char(1) := 'N';
    lc_lista1 char(1) := 'N';
    lc_lista2 char(1) := 'N';
    lc_lista3 char(1) := 'N';
    lc_lista4 char(1) := 'N';
    lc_lista5 char(1) := 'N';
  
  begin
  
    begin
      select Pfebco
        into lc_bco
        from fsd002
       where Pfpais = pn_pai
         and Pftdoc = pn_tdo
         and Pfndoc = pc_ndo;
    exception
      when others then
        null;
    End;
  
    if nvl(lc_bco, 'N') = 'S' then
      lc_flg := 'S';
      lc_err := 'Cliente es Empleado de la CMAC Arequipa';
    end if;
  
    if nvl(lc_flg, 'N') = 'N' then
      begin
        select count(*)
          into ln_cont
          from fsr002 a, fsd002 b
         where a.pepais = pn_pai
           and a.petdoc = pn_tdo
           and a.pendoc = pc_ndo
           and a.rpccyg in (select Tp1nro1
                              from fst198
                             Where Tp1cod = 1
                               and Tp1cod1 = 10846
                               and Tp1corr1 = 1
                               and Tp1corr2 = 1)
           and a.rppais = b.pfpais
           and a.rptdoc = b.pftdoc
           and a.rpndoc = b.pfndoc
           and b.pfebco = 'S';
      exception
        when others then
          null;
      end;
    
      begin
        select count(*)
          into ln_cont2
          from fsr002 a, fsd002 b
         where a.rppais = pn_pai
           and a.rptdoc = pn_tdo
           and a.rpndoc = pc_ndo
           and a.rpccyg in (select Tp1nro1
                              from fst198
                             Where Tp1cod = 1
                               and Tp1cod1 = 10846
                               and Tp1corr1 = 1
                               and Tp1corr2 = 1)
           and a.pepais = b.pfpais
           and a.petdoc = b.pftdoc
           and a.pendoc = b.pfndoc
           and b.pfebco = 'S';
      exception
        when others then
          null;
      end;
    
      if nvl(ln_cont2, 0) > 0 or nvl(ln_cont, 0) > 0 then
        lc_flg := 'S';
        lc_err := 'Cliente tiene familiar en Caja Arequipa';
      end if;
    
    end if;
  
    if nvl(lc_flg, 'N') = 'N' then
      Pq_Cr_Modulo_Campanias.sp_cr_familiar_jefe_cmac(pn_pai,
                                                      pn_tdo,
                                                      pc_ndo,
                                                      lc_flg2);
      if nvl(lc_flg2, 'N') = 'S' then
        lc_flg := 'S';
        lc_err := 'Cliente tiene familiar en el banco';
      end if;
    end if;
  
    if nvl(lc_flg, 'N') = 'N' then
      -- Call the procedure
      pq_cr_listas_negras.sp_cr_integrantes(ln_cuenta => pn_cta,
                                            pn_lista1 => lc_lista1,
                                            pn_lista2 => lc_lista2,
                                            pn_lista3 => lc_lista3,
                                            pn_lista4 => lc_lista4,
                                            pn_lista5 => lc_lista5);
      if lc_lista1 = 'S' or lc_lista2 = 'S' or lc_lista3 = 'S' then
        lc_flg := 'S';
        lc_err := 'Cliente en Listas Negras';
      end if;
    end if;
  
    pc_flg   := lc_flg;
    pc_error := lc_err;
  
  end sp_resolutorJAQL152;
  --------------------------------------------------------------
  procedure sp_cr_familiar_jefe_cmac(pn_pais number,
                                     pn_tdoc number,
                                     pc_ndoc character,
                                     pv_rpta out char) is
    contador1 number(5);
    contador2 number(5);
    contador  number(5);
  begin
  
    begin
      select nvl(count(*), 0)
        into contador1
        from fsr002 a
       where Pepais = pn_pais
         and Petdoc = pn_tdoc
         and Pendoc = pc_ndoc
         and a.rpccyg in (select Tp1nro1
                            from fst198
                           Where Tp1cod = 1
                             and Tp1cod1 = 10846
                             and Tp1corr1 = 1
                             and Tp1corr2 = 1)
         and exists (select * --Pfebco--familiar
                from FSD002
               where pfpais = a.rppais
                 and pftdoc = a.rptdoc
                 and pfndoc = a.rpndoc
                 and Pfebco = 'S')
         and exists
       (select *
                from sng057
               where SNG057Usr in
                     (select JAQN002USR
                        from JAQN002
                       where JAQN002PAI = a.rppais
                         and JAQN002TDO = a.rptdoc
                         and JAQN002NDO = a.rpndoc)
                 and SNG055Car in (select Tp1nro1
                                     from fst198
                                    where tp1cod = 1
                                      and Tp1cod1 = 11102
                                      and Tp1corr1 = 1
                                      and Tp1corr2 = 1
                                      and Tp1corr3 > 0));
    exception
      when others then
        contador1 := 0;
      
    end;
  
    begin
      select nvl(count(*), 0)
        into contador2
        from fsr002 a
       where rppais = pn_pais
         and rptdoc = pn_tdoc
         and rpndoc = pc_ndoc
         and a.rpccyg in (select Tp1nro1
                            from fst198
                           Where Tp1cod = 1
                             and Tp1cod1 = 10846
                             and Tp1corr1 = 1
                             and Tp1corr2 = 1)
         and exists (select * --Pfebco--familiar
                from FSD002
               where pfpais = a.Pepais
                 and pftdoc = a.Petdoc
                 and pfndoc = a.pendoc
                 and Pfebco = 'S')
         and exists
       (select *
                from sng057
               where SNG057Usr in
                     (select JAQN002USR
                        from JAQN002
                       where JAQN002PAI = a.Pepais
                         and JAQN002TDO = a.Petdoc
                         and JAQN002NDO = a.Pendoc)
                 and SNG055Car in (select Tp1nro1
                                     from fst198
                                    where tp1cod = 1
                                      and Tp1cod1 = 11102
                                      and Tp1corr1 = 1
                                      and Tp1corr2 = 1
                                      and Tp1corr3 > 0));
    
    exception
      when others then
        contador2 := 0;
    end;
  
    contador := contador1 + contador2;
  
    if contador > 0 then
      pv_rpta := 'S';
    else
      pv_rpta := 'N';
    end if;
  
  end sp_cr_familiar_jefe_cmac;
  ---------------------------------------------------------------------------
  Procedure sp_validacion_pols_jaqz697(pd_Fecpro in date) is
  
    cursor creditos is
      select * from jaqz697 a where a.jaqz697fep = pd_Fecpro;
  
    lc_flg   char(1);
    lc_Error char(100);
  
  begin
  
    for i in creditos loop
      lc_flg   := 'N';
      lc_Error := null;
    
      PQ_CR_MODULO_CAMPANIAS.sp_resolutorJAQL152(pn_pai   => i.jaqz697pai,
                                                 pn_tdo   => i.jaqz697tdo,
                                                 pc_ndo   => i.jaqz697ndo,
                                                 pn_cta   => i.jaqz697cta,
                                                 pc_flg   => lc_flg,
                                                 pc_error => lc_Error);
    
      if nvl(lc_flg, 'N') = 'S' then
        update jaqz697 a
           set a.jaqz697inc = lc_flg,
               a.jaqz697err = lc_Error,
               a.jaqz697au5 = 'E'
         where a.jaqz697fep = i.jaqz697fep
           and a.jaqz697cor = i.jaqz697cor;
        commit;
      
      else
        update jaqz697 a
           set a.jaqz697inc = lc_flg, a.jaqz697err = lc_Error
         where a.jaqz697fep = i.jaqz697fep
           and a.jaqz697cor = i.jaqz697cor;
        commit;
      end if;
    end loop;
    commit;
  
  end sp_validacion_pols_jaqz697;
  ------------------------------------------------------------
  Procedure sp_validacion_pols_aqpa861(pd_Fecpro in date) is
  
    cursor creditos is
      select * from aqpa861 a where a.aqpa861fep = pd_Fecpro;
  
    lc_flg   char(1);
    lc_Error char(100);
  
  begin
  
    for i in creditos loop
      lc_flg   := 'N';
      lc_Error := null;
    
      PQ_CR_MODULO_CAMPANIAS.sp_resolutorJAQL152(pn_pai   => i.aqpa861pai,
                                                 pn_tdo   => i.aqpa861tdo,
                                                 pc_ndo   => i.aqpa861ndo,
                                                 pn_cta   => i.aqpa861cta,
                                                 pc_flg   => lc_flg,
                                                 pc_error => lc_Error);
    
      if nvl(lc_flg, 'N') = 'S' then
        update jaqz697 a
           set a.jaqz697inc = lc_flg,
               a.jaqz697err = lc_Error,
               a.jaqz697au5 = 'E'
         where a.jaqz697fep = i.aqpa861fep
           and a.jaqz697cor = i.aqpa861cor;
        commit;
      
      else
        update jaqz697 a
           set a.jaqz697inc = lc_flg, a.jaqz697err = lc_Error
         where a.jaqz697fep = i.aqpa861fep
           and a.jaqz697cor = i.aqpa861cor;
        commit;
      end if;
    end loop;
    commit;
  
  end sp_validacion_pols_aqpa861;
  -----------------------------------------------------------
  Procedure Sp_gasto_Financi(pn_eva in number, pn_mto out number) is
  
    ln_mto number(17, 2);
  
  begin
  
    begin
      select sum(a.jaqy327gfin)
        into ln_mto
        from jaqy327_bdj a
       where a.jaqy327neva = pn_eva
         and a.jaqy327esta = 'S'
         and a.jaqy327chek = '1';
    exception
      when others then
        null;
    end;
    pn_mto := nvl(ln_mto, 0);
  
  end Sp_gasto_Financi;
  --------------------------------------------------------
  procedure sp_meses(pd_fecini in date,
                     pd_fecfin in date,
                     pn_cont   out number) is
  
  begin
  
    begin
    
      select round(months_between(pd_fecfin, pd_fecini), 0)
        into pn_cont
        from dual;
    exception
      when others then
        null;
    end;
  end sp_meses;
  ----------------------------------------------------------------

  Procedure sp_jaqm80(pd_fecpro in date, pd_fec in date, pn_cor in number) is
  
    ln_corr  number(10);
    ln_pai   number(3);
    ln_tdo   number(2);
    lc_ndo   char(12);
    ln_suc   number(3);
    ln_mda   number(4);
    ln_cta   number(9);
    ln_mod   number(3);
    ln_top   number(3);
    lc_ase   char(10);
    ln_mto   number(17, 2);
    ln_fre   number(4);
    ln_cuo   number(4);
    lc_flgAm char(1);
    ln_ori   number(2);
    ln_empA  number(3);
    ln_modA  number(3);
    ln_sucA  number(3);
    ln_mdaA  number(4);
    ln_papA  number(4);
    ln_ctaA  number(9);
    ln_opeA  number(9);
    ln_sboA  number(3);
    ln_topA  number(3);
    ln_ts    number(4);
  
    cursor tasa(cn_defn in number,
                cn_mod  in number,
                cn_mda  in number,
                cn_pap  in number,
                cn_mto  in number,
                cn_pzo  in number,
                cf_fec  in date) is
      select *
        from fsr025 a
       where a.pgcod = 1
         and a.tpizar = cn_defn
         and a.tamod = cn_mod
         and a.tamda = cn_mda
         and a.tapap = cn_pap
         and a.tamto >= cn_mto
         and a.tapzo >= cn_pzo
         and a.tafdes <= cf_fec
         and a.tafdes = (select max(aa.tafdes)
                           from fsr025 aa
                          where aa.pgcod = 1
                            and aa.tpizar = cn_defn
                            and aa.tamod = cn_mod
                            and aa.tamda = cn_mda
                            and aa.tapap = cn_pap
                               --and aa.tamto  >= cn_mto
                               --and aa.tapzo  >= cn_pzo 
                            and aa.tafdes <= cf_fec);
    cursor region(cn_sucR in number) is
      select *
        from fst811 a
       where a.pgcod = 1
         and a.regcod >= 100
         and a.oficod = cn_sucR;
  
    cursor tasa_esp(cn_modE in number,
                    cn_defE in number,
                    cn_papE in number,
                    cn_mdaE in number,
                    cn_mtoE in number,
                    cn_regE in number,
                    cd_fecE in date) is
    
      select *
        from fsd527 a
       where a.pgcod = 1
         and a.tamod = cn_modE
         and a.tpizar = cn_defE
         and a.tapap = cn_papE
         and a.tamda = cn_mdaE
         and a.tvfmon = cn_mtoE
         and a.tvsuc = cn_regE
         and a.tvfdes <= cd_fecE;
  
    ln_defn      number(17, 2);
    ln_cont      number(5) := 0;
    ln_tas       number(10, 6);
    ln_mtt       number(17, 2);
    ln_fde       date;
    ln_tat       number(7, 4);
    ln_cont2     number(5) := 0;
    ln_tvmpo     number(7, 4);
    ln_porc      number(4) := 100;
    pn_tasa      number(10, 6);
    ln_Pp028DefN number(17, 2);
  
    ln_mtoAUX NUMBER(17, 2);
    ln_pap    number(3);
    ln_cor2   number(10);
  
  begin
  
    begin
      select max(a.jaqm80id) + 1 into ln_corr from jaqm80 a;
    exception
      when others then
        ln_corr := 1;
    end;
  
    if nvl(ln_corr, 0) = 0 then
      ln_corr := 1;
    end if;
  
    begin
      select a.jaqz697pai,
             a.jaqz697tdo,
             a.jaqz697ndo,
             a.jaqz697suc,
             a.jaqz697mda,
             a.jaqz697cta,
             a.jaqz697mod,
             a.jaqz697top,
             a.jaqz697ase,
             a.jaqz697mto,
             a.jaqz697pzo,
             a.jaqz697cuo,
             trim(a.jaqz697tip),
             1,
             a.jaqz697moa,
             a.jaqz697sua,
             a.jaqz697maa,
             a.jaqz697paa,
             a.jaqz697caa,
             a.jaqz697opa,
             a.jaqz697sba,
             a.jaqz697toa
        into ln_pai,
             ln_tdo,
             lc_ndo,
             ln_suc,
             ln_mda,
             ln_cta,
             ln_mod,
             ln_top,
             lc_ase,
             ln_mto,
             ln_fre,
             ln_cuo,
             lc_flgAm,
             ln_empA,
             ln_modA,
             ln_sucA,
             ln_mdaA,
             ln_papA,
             ln_ctaA,
             ln_opeA,
             ln_sboA,
             ln_topA
        from jaqz697 a
       where a.jaqz697fep = pd_fec
         and a.jaqz697cor = pn_cor;
    exception
      when others then
        null;
    end;
  
    update jaqz697 a
       set a.jaqz697au5 = 'D' --cliente con gradiente registros diferentes al procesado mismo dni
     where a.jaqz697fep = pd_fec
       and a.jaqz697pai = ln_pai
       and a.jaqz697tdo = ln_tdo
       and a.jaqz697ndo = lc_ndo;
    commit;
  
    update jaqz697 a
       set a.jaqz697au5 = 'G', --registro procesado con gradiente
           a.jaqz697fan = pd_fecpro
     where a.jaqz697fep = pd_fec
       and a.jaqz697cor = pn_cor;
    commit;
  
    if nvl(lc_flgAm, 'N') = 'A' then
      ln_ori := 4;
      ln_ts  := 0;
    else
      --mod@abr 20210506
      if ln_mod = 117 then
        ln_ori := 11;
        ln_ts  := 0;
      else
        ln_ori := 0;
        ln_ts  := 0;
      end if;
    end if;
  
    --tasa por cuenta
  
    begin
      select Pp028DefN
        into ln_Pp028DefN
        from FPP028
       Where Pp028Emp = 1
         and Pp028Mod = ln_mod
         and Pp028Top = ln_top
         and Pp028Mda = ln_mda
         and Pp028Pap = 0
         and Pp017Par = 17;
    exception
      when others then
        null;
    end;
  
    begin
      select MIN(f.tpmto)
        into ln_mtoAUX
        from fsr027 f
       where f.pgcod = 1
         and f.modulo = ln_mod
         and f.tpizar = ln_Pp028DefN
         and f.ctnro = ln_cta
         and f.moneda = ln_mda
         and f.papel = 0
         and f.tpfdes = pd_Fec
         and f.tpmto >= ln_mto
         and f.tppzo = 99999;
    exception
      when others then
        null;
    end;
  
    begin
      select f.tptasa
        into pn_tasa
        from fsr027 f
       where f.pgcod = 1
         and f.modulo = ln_mod
         and f.tpizar = ln_Pp028DefN
         and f.ctnro = ln_cta
         and f.moneda = ln_mda
         and f.papel = 0
         and f.tpfdes = pd_Fec
         and f.tpmto = ln_mtoAUX
         and f.tppzo = 99999;
    exception
      when others then
        null;
    end;
  
    if nvl(pn_tasa, 0) = 0 then
      --obtiene pizarra
      begin
        select Pp028DefN
          into ln_defn
          from fpp028
         where Pp010Prd = 1
           and Pp017Par = 17
           and Pp028Mod = ln_mod
           and Pp028Mda = ln_mda
           and Pp028Pap = 0
           and Pp028Top = ln_top;
      exception
        when others then
          null;
      end;
    
      ln_pap := 0;
    
      for i in tasa(ln_defn, ln_mod, ln_mda, ln_pap, ln_mto, ln_fre, pd_fecpro) loop
      
        ln_tas  := i.Tatasa;
        ln_mtt  := i.Tamto;
        ln_fde  := i.Tafdes;
        ln_tat  := i.Tatol;
        ln_cont := ln_cont + 1;
      
        if ln_cont > 0 then
          exit;
        end if;
      
      end loop;
    
      for j in region(ln_suc) loop
        for k in tasa_esp(ln_mod, ln_defn, ln_pap, ln_mda, ln_mtt, --MOD@ABR 20171018
         j.regcod, pd_fecpro) loop
        
          ln_tvmpo := k.TvMPorc - ln_porc;
          ln_cont2 := ln_cont2 + 1;
        
          if ln_cont2 > 0 then
            exit;
          end if;
        
        end loop;
      end loop;
    
      pn_tasa := nvl(ln_tas, 0) + nvl(ln_tvmpo, 0);
    end if;
  
    begin
      insert into jaqm80
        (jaqm80id,
         jaqm80fc,
         jaqm80or,
         jaqm80pa,
         jaqm80td,
         jaqm80nd,
         jaqm80ct,
         jaqm80ts,
         jaqm80su,
         jaqm80mo,
         jaqm80tp,
         jaqm80mn,
         jaqm80pp,
         jaqm80cn,
         jaqm80pe,
         jaqm80im,
         jaqm80ta,
         jaqm80as,
         jaqm80og,
         jaqm80es,
         jaqm80so)
      
      values
        (ln_corr,
         pd_fecpro,
         ln_ori,
         ln_pai,
         ln_tdo,
         lc_ndo,
         ln_cta,
         ln_ts,
         ln_suc,
         ln_mod,
         ln_top,
         ln_mda,
         0,
         ln_cuo,
         ln_fre,
         ln_mto,
         pn_tasa,
         lc_ase,
         4,
         'A',
         0);
    exception
      when others then
        null;
    end;
  
    commit;
  
    if nvl(lc_flgAm, 'N') = 'A' then
      begin
        select max(a.aqpa868cor) + 1
          into ln_cor2
          from aqpa868 a
         where a.aqpa868fep = pd_fecpro;
      exception
        when others then
          ln_cor2 := 1;
      end;
    
      if nvl(ln_cor2, 0) = 0 then
        ln_cor2 := 1;
      end if;
    
      begin
        insert into aqpa868
          (aqpa868fep,
           aqpa868cor,
           aqpa868id,
           aqpa868emp,
           aqpa868mod,
           aqpa868suc,
           aqpa868mda,
           aqpa868pap,
           aqpa868cta,
           aqpa868ope,
           aqpa868sbo,
           aqpa868top)
        values
          (pd_fecpro,
           ln_cor2,
           ln_corr,
           ln_empA,
           ln_modA,
           ln_sucA,
           ln_mdaA,
           ln_papA,
           ln_ctaA,
           ln_opeA,
           ln_sboA,
           ln_topA);
      exception
        when others then
          null;
      end;
    
      commit;
    end if;
  end sp_jaqm80;
  ---------------------------------------------------------------
  Procedure Sp_Cr_tasa(pd_fec    in date,
                       pn_cor    in number,
                       pd_fecpro in date,
                       pn_tas    out number) is
  
    cursor tasa(cn_defn in number,
                cn_mod  in number,
                cn_mda  in number,
                cn_pap  in number,
                cn_mto  in number,
                cn_pzo  in number,
                cf_fec  in date) is
      select *
        from fsr025 a
       where a.pgcod = 1
         and a.tpizar = cn_defn
         and a.tamod = cn_mod
         and a.tamda = cn_mda
         and a.tapap = cn_pap
         and a.tamto >= cn_mto
         and a.tapzo >= cn_pzo
         and a.tafdes <= cf_fec
         and a.tafdes = (select max(aa.tafdes)
                           from fsr025 aa
                          where aa.pgcod = 1
                            and aa.tpizar = cn_defn
                            and aa.tamod = cn_mod
                            and aa.tamda = cn_mda
                            and aa.tapap = cn_pap
                               --and aa.tamto  >= cn_mto
                               --and aa.tapzo  >= cn_pzo 
                            and aa.tafdes <= cf_fec);
    cursor region(cn_sucR in number) is
      select *
        from fst811 a
       where a.pgcod = 1
         and a.regcod >= 100
         and a.oficod = cn_sucR;
  
    cursor tasa_esp(cn_modE in number,
                    cn_defE in number,
                    cn_papE in number,
                    cn_mdaE in number,
                    cn_mtoE in number,
                    cn_regE in number,
                    cd_fecE in date) is
    
      select *
        from fsd527 a
       where a.pgcod = 1
         and a.tamod = cn_modE
         and a.tpizar = cn_defE
         and a.tapap = cn_papE
         and a.tamda = cn_mdaE
         and a.tvfmon = cn_mtoE
         and a.tvsuc = cn_regE
         and a.tvfdes <= cd_fecE;
  
    ln_Pp028DefN number(17, 2);
    ln_cta       number(9);
    ln_mtoAUX    NUMBER(17, 2);
    ln_mod       number(3);
    ln_suc       number(3);
    ln_mda       number(4);
    ln_pap       number(4);
    ln_top       number(3);
    ln_mto       number(17, 2);
    ln_pzo       number(5);
    ln_defn      number(17, 2);
    ln_cont      number(5) := 0;
    ln_tas       number(10, 6);
    ln_mtt       number(17, 2);
    ln_fde       date;
    ln_tat       number(7, 4);
    ln_cont2     number(5) := 0;
    ln_tvmpo     number(7, 4);
    ln_porc      number(4) := 100;
  
    pn_tasa number(10, 6);
  
  begin
  
    --tasa por cuenta
    ln_pap := 0;
    begin
      select a.jaqz697cta,
             a.jaqz697suc,
             a.jaqz697mda,
             a.jaqz697mod,
             a.jaqz697top,
             a.jaqz697mto,
             a.jaqz697pzo
        into ln_cta, ln_suc, ln_mda, ln_mod, ln_top, ln_mto, ln_pzo
        from jaqz697 a
       where a.jaqz697fep = pd_Fec
         and a.jaqz697cor = pn_cor;
    exception
      when others then
        null;
    end;
  
    begin
      select Pp028DefN
        into ln_Pp028DefN
        from FPP028
       Where Pp028Emp = 1
         and Pp028Mod = ln_mod
         and Pp028Top = ln_top
         and Pp028Mda = ln_mda
         and Pp028Pap = ln_pap
         and Pp017Par = 17;
    exception
      when others then
        null;
    end;
  
    begin
      select MIN(f.tpmto)
        into ln_mtoAUX
        from fsr027 f
       where f.pgcod = 1
         and f.modulo = ln_mod
         and f.tpizar = ln_Pp028DefN
         and f.ctnro = ln_cta
         and f.moneda = ln_mda
         and f.papel = ln_pap
         and f.tpfdes = pd_Fec
         and f.tpmto >= ln_mto
         and f.tppzo = 99999;
    exception
      when others then
        null;
    end;
  
    begin
      select f.tptasa
        into pn_tasa
        from fsr027 f
       where f.pgcod = 1
         and f.modulo = ln_mod
         and f.tpizar = ln_Pp028DefN
         and f.ctnro = ln_cta
         and f.moneda = ln_mda
         and f.papel = ln_pap
         and f.tpfdes = pd_Fec
         and f.tpmto = ln_mtoAUX
         and f.tppzo = 99999;
    exception
      when others then
        null;
    end;
  
    if nvl(pn_tasa, 0) = 0 then
      --obtiene pizarra
      begin
        select Pp028DefN
          into ln_defn
          from fpp028
         where Pp010Prd = 1
           and Pp017Par = 17
           and Pp028Mod = ln_mod
           and Pp028Mda = ln_mda
           and Pp028Pap = ln_pap
           and Pp028Top = ln_top;
      exception
        when others then
          null;
      end;
    
      for i in tasa(ln_defn, ln_mod, ln_mda, ln_pap, ln_mto, ln_pzo, pd_fecpro) loop
      
        ln_tas  := i.Tatasa;
        ln_mtt  := i.Tamto;
        ln_fde  := i.Tafdes;
        ln_tat  := i.Tatol;
        ln_cont := ln_cont + 1;
      
        if ln_cont > 0 then
          exit;
        end if;
      
      end loop;
    
      for j in region(ln_suc) loop
        for k in tasa_esp(ln_mod, ln_defn, ln_pap, ln_mda, ln_mtt, --MOD@ABR 20171018
         j.regcod, pd_fecpro) loop
        
          ln_tvmpo := k.TvMPorc - ln_porc;
          ln_cont2 := ln_cont2 + 1;
        
          if ln_cont2 > 0 then
            exit;
          end if;
        
        end loop;
      end loop;
    
      pn_tasa := nvl(ln_tas, 0) + nvl(ln_tvmpo, 0);
    end if;
    pn_tas := pn_tasa;
  end Sp_Cr_tasa;
  ----------------------------------------------------------
  Procedure Sp_Cr_tasa_cta(pd_fec    in date,
                           pn_cor    in number,
                           pd_fecpro in date,
                           pn_cta    in number,
                           pn_tas    out number) is
  
    cursor tasa(cn_defn in number,
                cn_mod  in number,
                cn_mda  in number,
                cn_pap  in number,
                cn_mto  in number,
                cn_pzo  in number,
                cf_fec  in date) is
      select *
        from fsr025 a
       where a.pgcod = 1
         and a.tpizar = cn_defn
         and a.tamod = cn_mod
         and a.tamda = cn_mda
         and a.tapap = cn_pap
         and a.tamto >= cn_mto
         and a.tapzo >= cn_pzo
         and a.tafdes <= cf_fec
         and a.tafdes = (select max(aa.tafdes)
                           from fsr025 aa
                          where aa.pgcod = 1
                            and aa.tpizar = cn_defn
                            and aa.tamod = cn_mod
                            and aa.tamda = cn_mda
                            and aa.tapap = cn_pap
                               --and aa.tamto  >= cn_mto
                               --and aa.tapzo  >= cn_pzo 
                            and aa.tafdes <= cf_fec);
    cursor region(cn_sucR in number) is
      select *
        from fst811 a
       where a.pgcod = 1
         and a.regcod >= 100
         and a.oficod = cn_sucR;
  
    cursor tasa_esp(cn_modE in number,
                    cn_defE in number,
                    cn_papE in number,
                    cn_mdaE in number,
                    cn_mtoE in number,
                    cn_regE in number,
                    cd_fecE in date) is
    
      select *
        from fsd527 a
       where a.pgcod = 1
         and a.tamod = cn_modE
         and a.tpizar = cn_defE
         and a.tapap = cn_papE
         and a.tamda = cn_mdaE
         and a.tvfmon = cn_mtoE
         and a.tvsuc = cn_regE
         and a.tvfdes <= cd_fecE;
  
    ln_Pp028DefN number(17, 2);
    --ln_cta       number(9);
    ln_mtoAUX NUMBER(17, 2);
    ln_mod    number(3);
    ln_suc    number(3);
    ln_mda    number(4);
    ln_pap    number(4);
    ln_top    number(3);
    ln_mto    number(17, 2);
    ln_pzo    number(5);
    ln_defn   number(17, 2);
    ln_cont   number(5) := 0;
    ln_tas    number(10, 6);
    ln_mtt    number(17, 2);
    ln_fde    date;
    ln_tat    number(7, 4);
    ln_cont2  number(5) := 0;
    ln_tvmpo  number(7, 4);
    ln_porc   number(4) := 100;
    pn_tasa   number(10, 6);
  
  begin
  
    --tasa por cuenta
    ln_pap := 0;
  
    begin
      select --a.jaqz697cta,
       a.jaqz697suc,
       a.jaqz697mda,
       a.jaqz697mod,
       a.jaqz697top,
       a.jaqz697mto,
       a.jaqz697pzo
        into --ln_cta, 
             ln_suc,
             ln_mda,
             ln_mod,
             ln_top,
             ln_mto,
             ln_pzo
        from jaqz697 a
       where a.jaqz697fep = pd_Fec
         and a.jaqz697cor = pn_cor;
    exception
      when others then
        null;
    end;
  
    begin
      select Pp028DefN
        into ln_Pp028DefN
        from FPP028
       Where Pp028Emp = 1
         and Pp028Mod = ln_mod
         and Pp028Top = ln_top
         and Pp028Mda = ln_mda
         and Pp028Pap = ln_pap
         and Pp017Par = 17;
    exception
      when others then
        null;
    end;
  
    begin
      select MIN(f.tpmto)
        into ln_mtoAUX
        from fsr027 f
       where f.pgcod = 1
         and f.modulo = ln_mod
         and f.tpizar = ln_Pp028DefN
         and f.ctnro = pn_cta
         and f.moneda = ln_mda
         and f.papel = ln_pap
         and f.tpfdes = pd_Fec
         and f.tpmto >= ln_mto
         and f.tppzo = 99999;
    exception
      when others then
        null;
    end;
  
    begin
      select f.tptasa
        into pn_tasa
        from fsr027 f
       where f.pgcod = 1
         and f.modulo = ln_mod
         and f.tpizar = ln_Pp028DefN
         and f.ctnro = pn_cta
         and f.moneda = ln_mda
         and f.papel = ln_pap
         and f.tpfdes = pd_Fec
         and f.tpmto = ln_mtoAUX
         and f.tppzo = 99999;
    exception
      when others then
        null;
    end;
  
    if nvl(pn_tasa, 0) = 0 then
      --obtiene pizarra
      begin
        select Pp028DefN
          into ln_defn
          from fpp028
         where Pp010Prd = 1
           and Pp017Par = 17
           and Pp028Mod = ln_mod
           and Pp028Mda = ln_mda
           and Pp028Pap = ln_pap
           and Pp028Top = ln_top;
      exception
        when others then
          null;
      end;
    
      for i in tasa(ln_defn, ln_mod, ln_mda, ln_pap, ln_mto, ln_pzo, pd_fecpro) loop
      
        ln_tas  := i.Tatasa;
        ln_mtt  := i.Tamto;
        ln_fde  := i.Tafdes;
        ln_tat  := i.Tatol;
        ln_cont := ln_cont + 1;
      
        if ln_cont > 0 then
          exit;
        end if;
      
      end loop;
    
      for j in region(ln_suc) loop
        for k in tasa_esp(ln_mod, ln_defn, ln_pap, ln_mda, ln_mtt, --MOD@ABR 20171018
         j.regcod, pd_fecpro) loop
        
          ln_tvmpo := k.TvMPorc - ln_porc;
          ln_cont2 := ln_cont2 + 1;
        
          if ln_cont2 > 0 then
            exit;
          end if;
        
        end loop;
      end loop;
    
      pn_tasa := nvl(ln_tas, 0) + nvl(ln_tvmpo, 0);
    end if;
    pn_tas := pn_tasa;
  end Sp_Cr_tasa_cta;
  ----------------------------------------------------------
  Procedure Sp_verificaGradiente(pd_Fec in date,
                                 pn_pai in number,
                                 pn_tdo in number,
                                 pn_ndo in char,
                                 pc_flg out char) is
  
    lc_flg char(1) := 'N';
  
  begin
  
    begin
      select 'S'
        into lc_flg
        from jaqz697 a
       where a.jaqz697fep = pd_Fec
         and a.jaqz697pai = pn_pai
         and a.jaqz697tdo = pn_tdo
         and a.jaqz697ndo = pn_ndo
         and a.jaqz697au5 in ('D', 'G', 'S', 'Z', 'X', 'Y')
         and rownum = 1;
    exception
      when others then
        null;
    end;
    pc_flg := nvl(lc_flg, 'N');
  
  end Sp_verificaGradiente;
  -------------------------------------------------
  Procedure Sp_rechazar(pd_Fec    in date,
                        pn_cor    in number,
                        pn_pai    in number,
                        pn_tdo    in number,
                        pc_ndo    in char,
                        pd_Fecpro in date,
                        pc_mot    in char) is
  
  begin
  
    update jaqz697 a
       set a.jaqz697au5 = 'Z' --No procesados
     where a.jaqz697fep = pd_fec
       and a.jaqz697pai = pn_pai
       and a.jaqz697tdo = pn_tdo
       and a.jaqz697ndo = pc_ndo;
    commit;
  
    update jaqz697 a
       set a.jaqz697au5 = 'R',
           a.jaqz697fan = pd_Fecpro,
           a.jaqz697mot = pc_mot
     where a.jaqz697fep = pd_fec
       and a.jaqz697cor = pn_cor;
    COMMIT;
  
    begin
      -- Call the procedure
      pq_cr_tasacampania_cvd.sp_cr_quitapizarra(ln_corr    => pn_cor,
                                                ld_fchcorr => pd_Fec);
    end;
  
  end Sp_rechazar;
  ---------------------------------------------------------
  Procedure sp_jaqm80_TUN(pd_fecpro in date,
                          pd_fec    in date,
                          pn_cor    in number,
                          pn_ins    in number,
                          pn_cer    in number,
                          pc_der    in char) is
  
    -- *****************************************************************
    -- Nombre                       : sp_jaqm80_TUN
    -- Sistema                      : BANTOTAL
    -- Módulo                       : ACTIVAS
    -- Descripción                  : procedimiento para flujo reducido
    -- Versión                      : 1.0
    -- Fecha de Creación            : 
    -- Autor de Creación            : MPOSTIGOC
    -- Estado                       : Activo
    -- Acceso                       : Público
    -- Fecha de Modificación        : 2024.08.16
    -- Autor de Modificación        : dcastro
    -- Descripción de Modificación  : se agrego procedimiento SP_CR_UPDATE_FECHA_SNG001 para actualizar sng001fin en flujo reducido cuando sng001fin sea 01/01/0001
    -- *****************************************************************  
  
    ln_corr  number(10);
    ln_pai   number(3);
    ln_tdo   number(2);
    lc_ndo   char(12);
    ln_suc   number(3);
    ln_mda   number(4);
    ln_cta   number(9);
    ln_mod   number(3);
    ln_top   number(3);
    lc_ase   char(10);
    ln_mto   number(17, 2);
    ln_fre   number(4);
    ln_cuo   number(4);
    lc_flgAm char(1);
    ln_ori   number(2);
    ln_empA  number(3);
    ln_modA  number(3);
    ln_sucA  number(3);
    ln_mdaA  number(4);
    ln_papA  number(4);
    ln_ctaA  number(9);
    ln_opeA  number(9);
    ln_sboA  number(3);
    ln_topA  number(3);
    ln_ts    number(4);
    lc_msg   varchar2(1000);
  
    cursor tasa(cn_defn in number,
                cn_mod  in number,
                cn_mda  in number,
                cn_pap  in number,
                cn_mto  in number,
                cn_pzo  in number,
                cf_fec  in date) is
      select *
        from fsr025 a
       where a.pgcod = 1
         and a.tpizar = cn_defn
         and a.tamod = cn_mod
         and a.tamda = cn_mda
         and a.tapap = cn_pap
         and a.tamto >= cn_mto
         and a.tapzo >= cn_pzo
         and a.tafdes <= cf_fec
         and a.tafdes = (select max(aa.tafdes)
                           from fsr025 aa
                          where aa.pgcod = 1
                            and aa.tpizar = cn_defn
                            and aa.tamod = cn_mod
                            and aa.tamda = cn_mda
                            and aa.tapap = cn_pap
                               --and aa.tamto  >= cn_mto
                               --and aa.tapzo  >= cn_pzo 
                            and aa.tafdes <= cf_fec);
    cursor region(cn_sucR in number) is
      select *
        from fst811 a
       where a.pgcod = 1
         and a.regcod >= 100
         and a.oficod = cn_sucR;
  
    cursor tasa_esp(cn_modE in number,
                    cn_defE in number,
                    cn_papE in number,
                    cn_mdaE in number,
                    cn_mtoE in number,
                    cn_regE in number,
                    cd_fecE in date) is
    
      select *
        from fsd527 a
       where a.pgcod = 1
         and a.tamod = cn_modE
         and a.tpizar = cn_defE
         and a.tapap = cn_papE
         and a.tamda = cn_mdaE
         and a.tvfmon = cn_mtoE
         and a.tvsuc = cn_regE
         and a.tvfdes <= cd_fecE;
  
    ln_defn      number(17, 2);
    ln_cont      number(5) := 0;
    ln_tas       number(10, 6);
    ln_mtt       number(17, 2);
    ln_fde       date;
    ln_tat       number(7, 4);
    ln_cont2     number(5) := 0;
    ln_tvmpo     number(7, 4);
    ln_porc      number(4) := 100;
    pn_tasa      number(10, 6);
    ln_Pp028DefN number(17, 2);
  
    ln_mtoAUX NUMBER(17, 2);
    ln_pap    number(3);
    ln_cor2   number(10);
  begin
  
    begin
      select max(a.jaqm80id) + 1 into ln_corr from jaqm80 a;
    exception
      when others then
        ln_corr := 1;
    end;
  
    if nvl(ln_corr, 0) = 0 then
      ln_corr := 1;
    end if;
  
    begin
      select a.jaqz697pai,
             a.jaqz697tdo,
             a.jaqz697ndo,
             a.jaqz697suc,
             a.jaqz697mda,
             a.jaqz697cta,
             a.jaqz697mod,
             a.jaqz697top,
             a.jaqz697ase,
             a.jaqz697mto,
             a.jaqz697pzo,
             a.jaqz697cuo,
             trim(a.jaqz697tip),
             1,
             a.jaqz697moa,
             a.jaqz697sua,
             a.jaqz697maa,
             a.jaqz697paa,
             a.jaqz697caa,
             a.jaqz697opa,
             a.jaqz697sba,
             a.jaqz697toa
        into ln_pai,
             ln_tdo,
             lc_ndo,
             ln_suc,
             ln_mda,
             ln_cta,
             ln_mod,
             ln_top,
             lc_ase,
             ln_mto,
             ln_fre,
             ln_cuo,
             lc_flgAm,
             ln_empA,
             ln_modA,
             ln_sucA,
             ln_mdaA,
             ln_papA,
             ln_ctaA,
             ln_opeA,
             ln_sboA,
             ln_topA
        from jaqz697 a
       where a.jaqz697fep = pd_fec
         and a.jaqz697cor = pn_cor;
    exception
      when others then
        null;
    end;
  
    update jaqz697 a
       set a.jaqz697au5 = 'D' --cliente con gradiente registros diferentes al procesado mismo dni
     where a.jaqz697fep = pd_fec
       and a.jaqz697pai = ln_pai
       and a.jaqz697tdo = ln_tdo
       and a.jaqz697ndo = lc_ndo;
    commit;
  
    update jaqz697 a
       set a.jaqz697au5 = 'G', --registro procesado con gradiente
           a.jaqz697fan = pd_fecpro
     where a.jaqz697fep = pd_fec
       and a.jaqz697cor = pn_cor;
    commit;
  
    if nvl(lc_flgAm, 'N') = 'A' then
      ln_ori := 4;
      ln_ts  := 0;
    else
      --mod@abr 20210506
      if ln_mod = 117 then
        ln_ori := 11;
        ln_ts  := 0;
      else
        ln_ori := 0;
        ln_ts  := 0;
      end if;
    end if;
  
    --tasa por cuenta
  
    begin
      select Pp028DefN
        into ln_Pp028DefN
        from FPP028
       Where Pp028Emp = 1
         and Pp028Mod = ln_mod
         and Pp028Top = ln_top
         and Pp028Mda = ln_mda
         and Pp028Pap = 0
         and Pp017Par = 17;
    exception
      when others then
        null;
    end;
  
    begin
      select MIN(f.tpmto)
        into ln_mtoAUX
        from fsr027 f
       where f.pgcod = 1
         and f.modulo = ln_mod
         and f.tpizar = ln_Pp028DefN
         and f.ctnro = ln_cta
         and f.moneda = ln_mda
         and f.papel = 0
         and f.tpfdes = pd_Fec
         and f.tpmto >= ln_mto
         and f.tppzo = 99999;
    exception
      when others then
        null;
    end;
  
    begin
      select f.tptasa
        into pn_tasa
        from fsr027 f
       where f.pgcod = 1
         and f.modulo = ln_mod
         and f.tpizar = ln_Pp028DefN
         and f.ctnro = ln_cta
         and f.moneda = ln_mda
         and f.papel = 0
         and f.tpfdes = pd_Fec
         and f.tpmto = ln_mtoAUX
         and f.tppzo = 99999;
    exception
      when others then
        null;
    end;
  
    if nvl(pn_tasa, 0) = 0 then
      --obtiene pizarra
      begin
        select Pp028DefN
          into ln_defn
          from fpp028
         where Pp010Prd = 1
           and Pp017Par = 17
           and Pp028Mod = ln_mod
           and Pp028Mda = ln_mda
           and Pp028Pap = 0
           and Pp028Top = ln_top;
      exception
        when others then
          null;
      end;
    
      ln_pap := 0;
    
      for i in tasa(ln_defn, ln_mod, ln_mda, ln_pap, ln_mto, ln_fre, pd_fecpro) loop
      
        ln_tas  := i.Tatasa;
        ln_mtt  := i.Tamto;
        ln_fde  := i.Tafdes;
        ln_tat  := i.Tatol;
        ln_cont := ln_cont + 1;
      
        if ln_cont > 0 then
          exit;
        end if;
      
      end loop;
    
      for j in region(ln_suc) loop
        for k in tasa_esp(ln_mod, ln_defn, ln_pap, ln_mda, ln_mtt, --MOD@ABR 20171018
         j.regcod, pd_fecpro) loop
        
          ln_tvmpo := k.TvMPorc - ln_porc;
          ln_cont2 := ln_cont2 + 1;
        
          if ln_cont2 > 0 then
            exit;
          end if;
        
        end loop;
      end loop;
    
      pn_tasa := nvl(ln_tas, 0) + nvl(ln_tvmpo, 0);
    end if;
  
    begin
      insert into jaqm80
        (jaqm80id,
         jaqm80fc,
         jaqm80or,
         jaqm80pa,
         jaqm80td,
         jaqm80nd,
         jaqm80ct,
         jaqm80ts,
         jaqm80su,
         jaqm80mo,
         jaqm80tp,
         jaqm80mn,
         jaqm80pp,
         jaqm80cn,
         jaqm80pe,
         jaqm80im,
         jaqm80ta,
         jaqm80as,
         jaqm80og,
         jaqm80es,
         jaqm80so)
      values
        (ln_corr,
         pd_fecpro,
         ln_ori,
         ln_pai,
         ln_tdo,
         lc_ndo,
         ln_cta,
         ln_ts,
         ln_suc,
         ln_mod,
         ln_top,
         ln_mda,
         0,
         ln_cuo,
         ln_fre,
         ln_mto,
         pn_tasa,
         lc_ase,
         4,
         'L',
         pn_ins);
    exception
      when others then
        null;
    end;
  
    commit;
  
    ---2024.08.16 dcastro se agrego procedimiento para actualizar sng001fin en flujo reducido cuando sng001fin sea 01/01/0001
    begin
      SP_CR_UPDATE_FECHA_SNG001(pn_ins, lc_msg);
    end;
    ---2024.08.16
  
    begin
      insert INTO aqpa868_err
        (aqpa868e_ins, aqpa868e_cer, aqpa868e_der)
      values
        (pn_ins, pn_cer, pc_der);
    exception
      when others then
        null;
    end;
    commit;
  
    if nvl(lc_flgAm, 'N') = 'A' then
    
      begin
        select max(a.aqpa868cor) + 1
          into ln_cor2
          from aqpa868 a
         where a.aqpa868fep = pd_fecpro;
      exception
        when others then
          ln_cor2 := 1;
      end;
    
      if nvl(ln_cor2, 0) = 0 then
        ln_cor2 := 1;
      end if;
    
      begin
        insert into aqpa868
          (aqpa868fep,
           aqpa868cor,
           aqpa868id,
           aqpa868emp,
           aqpa868mod,
           aqpa868suc,
           aqpa868mda,
           aqpa868pap,
           aqpa868cta,
           aqpa868ope,
           aqpa868sbo,
           aqpa868top)
        values
          (pd_fecpro,
           ln_cor2,
           ln_corr,
           ln_empA,
           ln_modA,
           ln_sucA,
           ln_mdaA,
           ln_papA,
           ln_ctaA,
           ln_opeA,
           ln_sboA,
           ln_topA);
      exception
        when others then
          null;
      end;
    
      commit;
    end if;
  
  end sp_jaqm80_TUN;
  ----------------------------------------------------
  Procedure sp_Procesajaqm80(pd_fecpro in date,
                             pd_fec    in date,
                             pn_cor    in number,
                             pn_ins    in number,
                             pn_cer    in number,
                             pc_der    in char) is
  
    -- *****************************************************************
    -- Nombre                       : sp_Procesajaqm80
    -- Sistema                      : BANTOTAL
    -- Módulo                       : ACTIVAS
    -- Descripción                  : procedimiento para flujo reducido
    -- Versión                      : 1.0
    -- Fecha de Creación            : 
    -- Autor de Creación            : MPOSTIGOC
    -- Estado                       : Activo
    -- Acceso                       : Público
    -- Fecha de Modificación        : 2024.08.16
    -- Autor de Modificación        : dcastro
    -- Descripción de Modificación  : se agrego procedimiento SP_CR_UPDATE_FECHA_SNG001 para actualizar sng001fin en flujo reducido cuando sng001fin sea 01/01/0001
    -- *****************************************************************  
  
    ln_corr  number(10);
    ln_pai   number(3);
    ln_tdo   number(2);
    lc_ndo   char(12);
    ln_suc   number(3);
    ln_mda   number(4);
    ln_cta   number(9);
    ln_mod   number(3);
    ln_top   number(3);
    lc_ase   char(10);
    ln_mto   number(17, 2);
    ln_fre   number(4);
    ln_cuo   number(4);
    lc_flgAm char(1);
    ln_ori   number(2);
    ln_empA  number(3);
    ln_modA  number(3);
    ln_sucA  number(3);
    ln_mdaA  number(4);
    ln_papA  number(4);
    ln_ctaA  number(9);
    ln_opeA  number(9);
    ln_sboA  number(3);
    ln_topA  number(3);
    lc_msg   varchar2(1000);
  
    cursor tasa(cn_defn in number,
                cn_mod  in number,
                cn_mda  in number,
                cn_pap  in number,
                cn_mto  in number,
                cn_pzo  in number,
                cf_fec  in date) is
      select *
        from fsr025 a
       where a.pgcod = 1
         and a.tpizar = cn_defn
         and a.tamod = cn_mod
         and a.tamda = cn_mda
         and a.tapap = cn_pap
         and a.tamto >= cn_mto
         and a.tapzo >= cn_pzo
         and a.tafdes <= cf_fec
         and a.tafdes = (select max(aa.tafdes)
                           from fsr025 aa
                          where aa.pgcod = 1
                            and aa.tpizar = cn_defn
                            and aa.tamod = cn_mod
                            and aa.tamda = cn_mda
                            and aa.tapap = cn_pap
                               --and aa.tamto  >= cn_mto
                               --and aa.tapzo  >= cn_pzo 
                            and aa.tafdes <= cf_fec);
    cursor region(cn_sucR in number) is
      select *
        from fst811 a
       where a.pgcod = 1
         and a.regcod >= 100
         and a.oficod = cn_sucR;
  
    cursor tasa_esp(cn_modE in number,
                    cn_defE in number,
                    cn_papE in number,
                    cn_mdaE in number,
                    cn_mtoE in number,
                    cn_regE in number,
                    cd_fecE in date) is
    
      select *
        from fsd527 a
       where a.pgcod = 1
         and a.tamod = cn_modE
         and a.tpizar = cn_defE
         and a.tapap = cn_papE
         and a.tamda = cn_mdaE
         and a.tvfmon = cn_mtoE
         and a.tvsuc = cn_regE
         and a.tvfdes <= cd_fecE;
  
    ln_defn      number(17, 2);
    ln_cont      number(5) := 0;
    ln_tas       number(10, 6);
    ln_mtt       number(17, 2);
    ln_fde       date;
    ln_tat       number(7, 4);
    ln_cont2     number(5) := 0;
    ln_tvmpo     number(7, 4);
    ln_porc      number(4) := 100;
    pn_tasa      number(10, 6);
    ln_Pp028DefN number(17, 2);
  
    ln_mtoAUX NUMBER(17, 2);
    ln_pap    number(3);
    ln_cor2   number(10);
  
    ln_ts number(4);
  
  begin
  
    begin
      select max(a.jaqm80id) + 1 into ln_corr from jaqm80 a;
    exception
      when others then
        ln_corr := 1;
    end;
  
    if nvl(ln_corr, 0) = 0 then
      ln_corr := 1;
    end if;
  
    begin
      select a.jaqz697pai,
             a.jaqz697tdo,
             a.jaqz697ndo,
             a.jaqz697suc,
             a.jaqz697mda,
             a.jaqz697cta,
             a.jaqz697mod,
             a.jaqz697top,
             a.jaqz697ase,
             a.jaqz697mto,
             a.jaqz697pzo,
             a.jaqz697cuo,
             trim(a.jaqz697tip),
             1,
             a.jaqz697moa,
             a.jaqz697sua,
             a.jaqz697maa,
             a.jaqz697paa,
             a.jaqz697caa,
             a.jaqz697opa,
             a.jaqz697sba,
             a.jaqz697toa
        into ln_pai,
             ln_tdo,
             lc_ndo,
             ln_suc,
             ln_mda,
             ln_cta,
             ln_mod,
             ln_top,
             lc_ase,
             ln_mto,
             ln_fre,
             ln_cuo,
             lc_flgAm,
             ln_empA,
             ln_modA,
             ln_sucA,
             ln_mdaA,
             ln_papA,
             ln_ctaA,
             ln_opeA,
             ln_sboA,
             ln_topA
        from jaqz697 a
       where a.jaqz697fep = pd_fec
         and a.jaqz697cor = pn_cor;
    exception
      when others then
        null;
    end;
  
    --mod@abr 20201026
    --update jaqz697 a
    --   set a.jaqz697au5 = 'X' --cliente con actividades en marcha registros diferentes al procesado mismo dni
    -- where a.jaqz697fep = pd_fec
    --   and a.jaqz697pai = ln_pai
    --   and a.jaqz697tdo = ln_tdo
    --   and a.jaqz697ndo = lc_ndo;
    --commit;
  
    --mod@abr 20201026
  
    update jaqz697 a
       set a.jaqz697au5 = 'Y', --registro procesado con actividades en marcha
           a.jaqz697fan = pd_fecpro
     where a.jaqz697fep = pd_fec
       and a.jaqz697cor = pn_cor;
    commit;
  
    if nvl(lc_flgAm, 'N') = 'A' then
      ln_ori := 4;
      ln_ts  := 0;
    else
      --mod@abr 20210506
      if ln_mod = 117 then
        ln_ori := 11;
        ln_ts  := 0;
      else
        ln_ori := 0;
        ln_ts  := 0;
      end if;
    end if;
  
    --tasa por cuenta
  
    begin
      select Pp028DefN
        into ln_Pp028DefN
        from FPP028
       Where Pp028Emp = 1
         and Pp028Mod = ln_mod
         and Pp028Top = ln_top
         and Pp028Mda = ln_mda
         and Pp028Pap = 0
         and Pp017Par = 17;
    exception
      when others then
        null;
    end;
  
    begin
      select MIN(f.tpmto)
        into ln_mtoAUX
        from fsr027 f
       where f.pgcod = 1
         and f.modulo = ln_mod
         and f.tpizar = ln_Pp028DefN
         and f.ctnro = ln_cta
         and f.moneda = ln_mda
         and f.papel = 0
         and f.tpfdes = pd_Fec
         and f.tpmto >= ln_mto
         and f.tppzo = 99999;
    exception
      when others then
        null;
    end;
  
    begin
      select f.tptasa
        into pn_tasa
        from fsr027 f
       where f.pgcod = 1
         and f.modulo = ln_mod
         and f.tpizar = ln_Pp028DefN
         and f.ctnro = ln_cta
         and f.moneda = ln_mda
         and f.papel = 0
         and f.tpfdes = pd_Fec
         and f.tpmto = ln_mtoAUX
         and f.tppzo = 99999;
    exception
      when others then
        null;
    end;
  
    if nvl(pn_tasa, 0) = 0 then
      --obtiene pizarra
      begin
        select Pp028DefN
          into ln_defn
          from fpp028
         where Pp010Prd = 1
           and Pp017Par = 17
           and Pp028Mod = ln_mod
           and Pp028Mda = ln_mda
           and Pp028Pap = 0
           and Pp028Top = ln_top;
      exception
        when others then
          null;
      end;
    
      ln_pap := 0;
    
      for i in tasa(ln_defn, ln_mod, ln_mda, ln_pap, ln_mto, ln_fre, pd_fecpro) loop
      
        ln_tas  := i.Tatasa;
        ln_mtt  := i.Tamto;
        ln_fde  := i.Tafdes;
        ln_tat  := i.Tatol;
        ln_cont := ln_cont + 1;
      
        if ln_cont > 0 then
          exit;
        end if;
      
      end loop;
    
      for j in region(ln_suc) loop
        for k in tasa_esp(ln_mod, ln_defn, ln_pap, ln_mda, ln_mtt, --MOD@ABR 20171018
         j.regcod, pd_fecpro) loop
        
          ln_tvmpo := k.TvMPorc - ln_porc;
          ln_cont2 := ln_cont2 + 1;
        
          if ln_cont2 > 0 then
            exit;
          end if;
        
        end loop;
      end loop;
    
      pn_tasa := nvl(ln_tas, 0) + nvl(ln_tvmpo, 0);
    end if;
  
    begin
      insert into jaqm80
        (jaqm80id,
         jaqm80fc,
         jaqm80or,
         jaqm80pa,
         jaqm80td,
         jaqm80nd,
         jaqm80ct,
         jaqm80ts,
         jaqm80su,
         jaqm80mo,
         jaqm80tp,
         jaqm80mn,
         jaqm80pp,
         jaqm80cn,
         jaqm80pe,
         jaqm80im,
         jaqm80ta,
         jaqm80as,
         jaqm80og,
         jaqm80es,
         jaqm80so)
      values
        (ln_corr,
         pd_fecpro,
         ln_ori,
         ln_pai,
         ln_tdo,
         lc_ndo,
         ln_cta,
         ln_ts,
         ln_suc,
         ln_mod,
         ln_top,
         ln_mda,
         0,
         ln_cuo,
         ln_fre,
         ln_mto,
         pn_tasa,
         lc_ase,
         4,
         'L',
         pn_ins);
    exception
      when others then
        null;
    end;
  
    commit;
  
    ---2024.08.16 dcastro se agrego procedimiento para actualizar sng001fin en flujo reducido cuando sng001fin sea 01/01/0001
    begin
      SP_CR_UPDATE_FECHA_SNG001(pn_ins, lc_msg);
    end;
    ---2024.08.16
  
    begin
      insert INTO aqpa868_err
        (aqpa868e_ins, aqpa868e_cer, aqpa868e_der)
      values
        (pn_ins, pn_cer, pc_der);
    exception
      when others then
        null;
    end;
    commit;
  
    if nvl(lc_flgAm, 'N') = 'A' then
      begin
        select max(a.aqpa868cor) + 1
          into ln_cor2
          from aqpa868 a
         where a.aqpa868fep = pd_fecpro;
      exception
        when others then
          ln_cor2 := 1;
      end;
      if nvl(ln_cor2, 0) = 0 then
        ln_cor2 := 1;
      end if;
    
      begin
        insert into aqpa868
          (aqpa868fep,
           aqpa868cor,
           aqpa868id,
           aqpa868emp,
           aqpa868mod,
           aqpa868suc,
           aqpa868mda,
           aqpa868pap,
           aqpa868cta,
           aqpa868ope,
           aqpa868sbo,
           aqpa868top)
        values
          (pd_fecpro,
           ln_cor2,
           ln_corr,
           ln_empA,
           ln_modA,
           ln_sucA,
           ln_mdaA,
           ln_papA,
           ln_ctaA,
           ln_opeA,
           ln_sboA,
           ln_topA);
      exception
        when others then
          null;
      end;
    
      commit;
    end if;
  end sp_Procesajaqm80;
  ----------------------------------------------------------
  procedure sp_cr_plazoParalelo(pn_mda in number,
                                pn_mod in number,
                                pn_top in number,
                                pn_pzo out number) is
  
  begin
  
    begin
      select a.aqpa822plzmax
        into pn_pzo
        from aqpa822 a
       where a.aqpa822mod = pn_mod
         and a.aqpa822top = pn_top
         and a.aqpa822mda = pn_mda;
    exception
      when others then
        pn_pzo := 0;
    end;
  
  end sp_cr_plazoParalelo;
  ---------------------------------------------------------
  Procedure Sp_RetornaTasa(pd_Fec    in date,
                           pn_cor    in number,
                           pd_fecpro in date,
                           pn_tasa   out number) is
  
    ln_pai     number(3);
    ln_tdo     number(2);
    ln_ndo     char(12);
    ln_mod     number(3);
    ln_top     number(3);
    ln_suc     number(3);
    ln_mda     number(4);
    ln_cta     number(9);
    ln_imp     number(17, 2);
    ln_cuo     number(10);
    ln_pzo     number(5);
    ln_mtoAux  number(17, 2);
    ln_PlzAux  number;
    ln_plzdias number;
  
  begin
  
    begin
    
      select a.jaqm750pai,
             a.jaqm750tdo,
             a.jaqm750ndo,
             a.jaqm750mod,
             a.jaqm750tip,
             a.jaqm750suc,
             a.jaqm750mda,
             a.jaqm750cta,
             a.jaqm750imp,
             a.jaqm750cuo,
             a.jaqm750pdo
        into ln_pai,
             ln_tdo,
             ln_ndo,
             ln_mod,
             ln_top,
             ln_suc,
             ln_mda,
             ln_cta,
             ln_imp,
             ln_cuo,
             ln_pzo
        from jaqm750 a
       where a.jaqm750fch = pd_Fec
         and a.jaqm750reg = pn_cor;
    exception
      when others then
        null;
    end;
  
    begin
      select MIN(b.aqpa372im)
        into ln_mtoAux
        from jaqz697 a, aqpa372 b
       where a.jaqz697fan = pd_Fec
         and a.jaqz697pai = ln_pai
         and a.jaqz697tdo = ln_tdo
         and a.jaqz697ndo = ln_ndo
         and a.jaqz697suc = ln_suc
         and a.jaqz697mda = ln_mda
         and a.jaqz697cta = ln_cta
         and a.jaqz697mod = ln_mod
         and a.jaqz697top = ln_top
         and a.jaqz697mto = ln_imp
         and a.jaqz697pzo = ln_pzo
         and a.jaqz697cuo = ln_cuo
         and a.jaqz697cta = b.aqpa372ct
         and a.jaqz697mod = b.aqpa372mo
         and a.jaqz697top = b.aqpa372tp
         and a.jaqz697mda = b.aqpa372mn
         and a.jaqz697fep = b.aqpa372fc
         and b.aqpa372im >= jaqz697mto;
    exception
      when others then
        null;
    end;
  
    begin
      select ln_pzo * ln_cuo into ln_plzdias from dual;
    exception
      when others then
        ln_plzdias := 1;
    end;
  
    begin
      select MIN(b.aqpa372plz)
        into ln_PlzAux
        from jaqz697 a, aqpa372 b
       where a.jaqz697fan = pd_Fec
         and a.jaqz697pai = ln_pai
         and a.jaqz697tdo = ln_tdo
         and a.jaqz697ndo = ln_ndo
         and a.jaqz697suc = ln_suc
         and a.jaqz697mda = ln_mda
         and a.jaqz697cta = ln_cta
         and a.jaqz697mod = ln_mod
         and a.jaqz697top = ln_top
         and a.jaqz697mto = ln_imp
         and a.jaqz697pzo = ln_pzo
         and a.jaqz697cuo = ln_cuo
         and a.jaqz697cta = b.aqpa372ct
         and a.jaqz697mod = b.aqpa372mo
         and a.jaqz697top = b.aqpa372tp
         and a.jaqz697mda = b.aqpa372mn
         and a.jaqz697fep = b.aqpa372fc
         and b.aqpa372im = ln_mtoAux
         and b.aqpa372plz >= ln_plzdias;
    exception
      when others then
        null;
    end;
  
    begin
      select b.aqpa372ta
        into pn_tasa
        from jaqz697 a, aqpa372 b
       where a.jaqz697fan = pd_Fec
         and a.jaqz697pai = ln_pai
         and a.jaqz697tdo = ln_tdo
         and a.jaqz697ndo = ln_ndo
         and a.jaqz697suc = ln_suc
         and a.jaqz697mda = ln_mda
         and a.jaqz697cta = ln_cta
         and a.jaqz697mod = ln_mod
         and a.jaqz697top = ln_top
         and a.jaqz697mto = ln_imp
         and a.jaqz697pzo = ln_pzo
         and a.jaqz697cuo = ln_cuo
         and a.jaqz697cta = b.aqpa372ct
         and a.jaqz697mod = b.aqpa372mo
         and a.jaqz697top = b.aqpa372tp
         and a.jaqz697mda = b.aqpa372mn
         and a.jaqz697fep = b.aqpa372fc
         and b.aqpa372im = ln_mtoAUX
         and b.aqpa372plz = ln_PlzAux;
    exception
      when others then
        null;
    end;
  
  end Sp_RetornaTasa;
  --------------------------------------------------------
  Procedure Sp_eliminaDuplicado(pn_ins    in number,
                                pd_fecpro in date,
                                pc_flg    out char) is
    ln_pai number(3);
    ln_tdo number(2);
    ln_ndo char(12);
    ln_ins number(10);
    --ln_dif number(5);
    lc_flg char(1);
  
    cursor instancias(cn_pai in number, cn_tdo in number, cc_ndo in char) is
      select *
        from sng001 a
       where a.sng001pais = cn_pai
         and a.sng001tdoc = cn_tdo
         and a.sng001ndoc = cc_ndo
       order by a.sng001inst desc;
  
  begin
  
    pc_flg := 'N'; --no dio de baja 
  
    begin
      select a.sng001pais, a.sng001tdoc, a.sng001ndoc
        into ln_pai, ln_tdo, ln_ndo
        from sng001 a
       where a.sng001inst = pn_ins;
    exception
      when others then
        null;
    end;
  
    begin
      select max(a.jaqm750ins)
        into ln_ins
        from jaqm750 a
       where a.jaqm750fch = pd_fecpro
         and a.jaqm750pai = ln_pai
         and a.jaqm750tdo = ln_tdo
         and a.jaqm750ndo = ln_ndo;
    exception
      when others then
        null;
    end;
    --ln_dif:= 0;  
    lc_flg := 'N';
  
    for i in instancias(ln_pai, ln_tdo, ln_ndo) loop
      --ln_dif:= ln_ins - i.sng001inst;
    
      if (ln_ins - i.sng001inst) = 1 then
        begin
          select 'S'
            into lc_flg
            from wfwrkitems a
           where a.wfinsprcid = i.sng001inst
             and a.wfitemstsact = 1
             and rownum = 1;
        exception
          when others then
            lc_flg := 'N';
        end;
      
        if lc_flg = 'S' then
          pc_flg := 'S'; --si dio de baja
          pq_cr_modulo_preaprob.sp_baja_solicitud(ln_ins => i.sng001inst);
        end if;
      
        exit;
      end if;
    end loop;
  
  end Sp_eliminaDuplicado;
  -------------------------------------------------------
  procedure sp_TasaReducido(pn_ins  in number,
                            pn_cta  in number,
                            pn_mod  in number,
                            pn_top  in number,
                            pn_mda  in number,
                            pn_mto  in number,
                            pn_tasa out number) is
  
    ln_pai    number(3);
    ln_tdo    number(2);
    lc_doc    char(12);
    ld_Fec697 date;
    ln_mtoAux number(17, 2);
  
  begin
  
    begin
      select a.sng001pais, a.sng001tdoc, a.sng001ndoc
        into ln_pai, ln_tdo, lc_doc
        from sng001 a
       where a.sng001inst = pn_ins;
    exception
      when others then
        null;
    end;
  
    begin
      select max(a.jaqz697fep)
        into ld_Fec697
        from jaqz697 a
       where a.jaqz697pai = ln_pai
         and a.jaqz697tdo = ln_tdo
         and a.jaqz697ndo = lc_doc;
    exception
      when others then
        null;
    end;
  
    begin
      select MIN(b.aqpa372im)
        into ln_mtoAux
        from aqpa372 b
       where b.aqpa372ct = pn_cta
         and b.aqpa372mo = pn_mod
         and b.aqpa372tp = pn_top
         and b.aqpa372mn = pn_mda
         and b.aqpa372fc = ld_Fec697
         and b.aqpa372im >= pn_mto;
    exception
      when others then
        null;
    end;
  
    begin
      select b.aqpa372ta
        into pn_tasa
        from aqpa372 b
       where b.aqpa372ct = pn_cta
         and b.aqpa372mo = pn_mod
         and b.aqpa372tp = pn_top
         and b.aqpa372mn = pn_mda
         and b.aqpa372fc = ld_Fec697
         and b.aqpa372im = ln_mtoAUX;
    exception
      when others then
        null;
    end;
  
  end sp_TasaReducido;

  /*COMENTAR*/
  --------------------------------------------
  procedure sp_segmntcuenta(ln_pais     in number,
                            ln_tdoc     in number,
                            lc_ndoc     in varchar2,
                            ln_cuenta   in number,
                            ln_SegmnCta out number) is
    my_errm   VARCHAR2(32000);
    lc_numdoc char(12);
  begin
    ln_SegmnCta := 3;
    lc_numdoc   := lc_ndoc;
    /*begin
      select SEGCOD
        into ln_SegmnCta
        from FSE002 f, sngc07 s
       where f.pfxpais = ln_pais
         and f.pfxtdoc = ln_tdoc
         and f.pfxndoc = lc_numdoc
         and f.ocucod = s.sngc07cod;
    exception
      when others then
        my_errm    := SQLERRM;
        ln_SegmnCta := 3;
    end;*/
    /* if ln_tdoc = 9 then
      ln_SegmnCta := 1;
    else
      begin
        select to_number(trim(b.segcod))
          into ln_SegmnCta
          from sngc60 a, sngc07 b
         where a.sngc60pais = ln_pais
           and a.sngc60tdoc = ln_tdoc
           and trim(a.sngc60ndoc) = trim(lc_ndoc)
           and a.sngc60ocup = b.sngc07cod;
      exception
        when too_many_rows then
          begin
            select to_number(trim(b.segcod))
              into ln_SegmnCta
              from sngc60 a, sngc07 b
             where a.sngc60pais = ln_pais
               and a.sngc60tdoc = ln_tdoc
               and trim(a.sngc60ndoc) = trim(lc_ndoc)
               and a.sngc60ocup = b.sngc07cod
               and a.sngc60corr =
                   (select min(a.sngc60corr)
                      from sngc60 a, sngc07 b
                     where a.sngc60pais = ln_pais
                       and a.sngc60tdoc = ln_tdoc
                       and trim(a.sngc60ndoc) = trim(lc_ndoc)
                       and a.sngc60ocup = b.sngc07cod);
          end;
        when others then
          ln_SegmnCta := 0;
        
      end;
    end if;*/
  
    begin
      select f.CTSEGM
        into ln_SegmnCta
        from fsd008 f
       where f.PGCOD = 1
         and f.CTNRO = ln_cuenta;
    exception
      when others then
        ln_SegmnCta := 99;
    end;
  
  end sp_segmntcuenta;
  --------------------------------------------
  procedure sp_agregatasa(ln_corr in number, ld_fcorr date) is
  
    cursor listado is
      select *
        from aqpa372 a
       where a.aqpa372fc = ld_fcorr
         and a.aqpa372cor697 = ln_corr;
  
    vFechahasta   date;
    ln_dia        varchar2(2);
    ln_mes        varchar2(2);
    ln_anio       varchar2(4);
    ld_FchInv     number;
    vTpfinv       number;
    ln_pizarra    number;
    ln_NroRegD027 number;
    ln_NroRegD327 number;
    ln_NroRegR027 number;
  
  begin
  
    begin
      begin
        SELECT ADD_MONTHS(TRUNC(ld_fcorr, 'MM'), 1) + 4
          into vFechahasta
          FROM DUAL;
      exception
        when others then
          null;
      end;
    
      begin
        select to_char(ld_fcorr, 'DD') into ln_dia from dual;
      exception
        when others then
          null;
      end;
      begin
        select to_char(ld_fcorr, 'MM') into ln_mes from dual;
      exception
        when others then
          null;
      end;
      begin
        select to_char(ld_fcorr, 'YYYY') into ln_anio from dual;
      exception
        when others then
          null;
      end;
    
      ld_FchInv := to_number(ln_anio || ln_mes || ln_dia);
    end;
  
    begin
      vTpfinv := 99999999 - ld_FchInv;
    end;
  
    for l in listado loop
    
      begin
        select f.pp028defn
          into ln_pizarra
          from fpp028 f
         where f.pp017par = 17
           and f.pp028emp = 1
           and f.pp028mod = l.aqpa372mo
           and f.pp028top = l.aqpa372tp
           and f.pp028mda = l.aqpa372mn
           and f.pp028pap = l.aqpa372pp;
      exception
        when others then
          ln_pizarra := 0;
      end;
    
      if ln_pizarra > 0 then
        --  FSD027
        begin
          select count(*)
            into ln_NroRegD027
            from fsd027 f
           where f.pgcod = 1
             and f.modulo = l.aqpa372mo
             and f.tpizar = ln_pizarra
             and f.ctnro = l.aqpa372ct
             and f.moneda = l.aqpa372mn
             and f.papel = l.aqpa372pp
             and f.tpfdes = l.aqpa372fc
             and f.tpvig = 'N';
        exception
          when others then
            null;
        end;
      
        if ln_NroRegD027 > 0 then
        
          update fsd027 f
             set f.tpvig = 'S'
           where f.pgcod = 1
             and f.modulo = l.aqpa372mo
             and f.tpizar = ln_pizarra
             and f.ctnro = l.aqpa372ct
             and f.moneda = l.aqpa372mn
             and f.papel = l.aqpa372pp
             and f.tpfdes = l.aqpa372fc
             and f.tpmto = l.aqpa372im
             and f.tpvig = 'S';
        else
          begin
            insert into fsd027
              (pgcod,
               modulo,
               tpizar,
               ctnro,
               moneda,
               papel,
               tpfdes,
               tpmto,
               tpttas,
               tpfinv,
               tpvig)
            values
              (1,
               l.aqpa372mo,
               ln_pizarra,
               l.aqpa372ct,
               l.aqpa372mn,
               l.aqpa372pp,
               l.aqpa372fc,
               l.aqpa372im,
               1,
               vTpfinv,
               'S');
          exception
            when others then
              null;
          end;
        
        end if;
      
        -- FSR027
        begin
          select count(*)
            into ln_NroRegR027
            from fsr027 f
           where f.pgcod = 1
             and f.modulo = l.aqpa372mo
             and f.TPIZAR = ln_pizarra
             and f.CTNRO = l.aqpa372ct
             and f.MONEDA = l.aqpa372mn
             and f.PAPEL = l.aqpa372pp
             and f.TPFDES = l.aqpa372fc
             and f.TPMTO = l.aqpa372im
             and f.TPPZO = l.aqpa372plz;
        exception
          when others then
            null;
        end;
      
        if ln_NroRegR027 = 0 then
          begin
            insert into fsr027
              (pgcod,
               modulo,
               tpizar,
               ctnro,
               moneda,
               papel,
               tpfdes,
               tpmto,
               tppzo,
               tptasa)
            values
              (1,
               l.aqpa372mo,
               ln_pizarra,
               l.aqpa372ct,
               l.aqpa372mn,
               l.aqpa372pp,
               l.aqpa372fc,
               l.aqpa372im,
               l.aqpa372plz,
               l.aqpa372ta);
          exception
            when others then
              null;
          end;
        
        end if;
      
        ------FSD327
      
        begin
          select count(*)
            into ln_NroRegR027
            from fsd327 f
           where f.VT1PGCOD = 1
             and f.VT1MOD = l.aqpa372mo
             and f.VT1TPIZ = ln_pizarra
             and f.VT1CTNR = l.aqpa372ct
             and f.VT1MON = l.aqpa372mn
             and f.VT1PAP = l.aqpa372pp
             and f.VT1TPFD = l.aqpa372fc;
        exception
          when others then
            null;
          
        end;
      
        if ln_NroRegR027 > 0 then
          update fsd327 g
             set g.vt1fchven = vFechahasta
           where g.vt1pgcod = 1
             and g.vt1mod = l.aqpa372mo
             and g.vt1tpiz = ln_pizarra
             and g.vt1ctnr = l.aqpa372ct
             and g.vt1mon = l.aqpa372mn
             and g.vt1pap = l.aqpa372pp
             and g.vt1tpfd = l.aqpa372fc;
        else
          begin
            insert into fsd327
              (vt1pgcod,
               vt1mod,
               vt1tpiz,
               vt1ctnr,
               vt1mon,
               vt1pap,
               vt1tpfd,
               vt1fchven)
            values
              (1,
               l.aqpa372mo,
               ln_pizarra,
               l.aqpa372ct,
               l.aqpa372mn,
               l.aqpa372pp,
               l.aqpa372fc,
               vFechahasta);
          exception
            when others then
              null;
          end;
        end if;
        commit;
      end if;
    
    end loop;
  
  end sp_agregatasa;
  /*COMENTAR*/
  -------------------------------------------------   
  procedure sp_cr_generar_cupon(ln_corr  in number,
                                ld_fcorr date,
                                pn_pai   in number,
                                pn_tdo   in number,
                                pc_ndo   in varchar2) is
  begin
  
    begin
      update jaqz697 a
         set a.jaqz697au5 = 'B'
       where a.jaqz697fep = ld_fcorr
         and a.jaqz697cor = ln_corr
         and a.jaqz697pai = pn_pai
         and a.jaqz697tdo = pn_tdo
         and a.jaqz697ndo = rpad(pc_ndo, 12);
    end;
    commit;
  end sp_cr_generar_cupon;
  -------------------------------------------------
  Procedure Sp_aprobar_cupon(pd_Fec in date,
                             pn_cor in number,
                             pc_res in char) is
    --ln_ins number(10);
    --ln_id  number(10);
  begin
    if pc_res = 'A' then
      begin
        update jaqz697 a
           set a.jaqz697apr = pc_res
         where a.jaqz697fep = pd_Fec
           and a.jaqz697cor = pn_cor
           and a.jaqz697tca = 'P';
      end;
      commit;
    else
      if pc_res = 'R' then
        begin
          update jaqz697 a
             set a.jaqz697apr = pc_res
           where a.jaqz697fep = pd_Fec
             and a.jaqz697cor = pn_cor
             and a.jaqz697tca = 'P';
        end;
        commit;
      end if;
    end if;
  
  end Sp_aprobar_cupon;
  -----------------------------------------------------------
  procedure sp_cr_ciuu(ln_pais in number,
                       ln_tdoc in number,
                       lc_ndoc in varchar2,
                       ln_ciiu out number) is
  begin
  
    if ln_tdoc <> 9 then
      begin
        Select c60.sngc60acte
          Into ln_ciiu
          From sngc60 c60
         Where c60.sngc60pais = ln_pais
           And c60.sngc60tdoc = ln_tdoc
           And c60.sngc60ndoc = rpad(lc_ndoc, 12, ' ')
           And c60.sngc60corr = 0;
      exception
        when others then
          ln_ciiu := 0;
      end;
    
    else
      -- mpostigoc 14.08.2023 INC6394
      if ln_tdoc = 9 or ln_ciiu = 0 then
      
        begin
          select EXPNINS
            Into ln_ciiu
            from FSE001 f
           where f.d511pais = ln_pais
             and f.d511tdoc = ln_tdoc
             and f.d511ndoc = rpad(lc_ndoc, 12, ' ');
        exception
          when others then
            null;
        end;
      
      end if;
    end if;
  
  end sp_cr_ciuu;
  ---------------------------------------------------------
  procedure sp_cr_SegMultiRisk(ln_pais   in number,
                               ln_tdoc   in number,
                               lc_ndoc   in varchar2,
                               ln_moe    in number,
                               ln_mda    in number,
                               ln_frec   in number,
                               pd_fecpro in date,
                               pn_mto    in number,
                               pn_mod    in number,
                               ln_Corr   in number) is
  
    ln_CodSegMultirisk number;
    ln_MntBase         number(17, 2);
    ln_ciiu            number;
    --  ln_Corr            number;
    ln_Cor751    number;
    ln_ModPermit number;
    ln_MaxMntSeg number(17, 2);
  
  begin
  
    --TP1NRO1 Modelo de Evaluacion
    --TP1NRO2 Cod de Seguro
    --TP1NRO3 Moneda
    --TP1DESC Grupo, Permitido o Restringido
    --TP1IMP1 Cod CIIU
    --TP1IMP2 Monto base para seguro soles
    --TP1IMP3 Frecuencia de Pago
  
    begin
      select count(*)
        into ln_ModPermit
        from fst198 f
       where f.tp1cod = 1
         and f.tp1cod1 = 11141
         and f.tp1corr1 = 13
         and f.tp1corr2 = 3
         and f.tp1nro2 = pn_mod;
    exception
      when others then
        ln_ModPermit := 0;
    end;
  
    if ln_ModPermit > 0 then
    
      Pq_Cr_Modulo_Campanias.sp_cr_ciuu(ln_pais, ln_tdoc, lc_ndoc, ln_ciiu);
    
      begin
        select f.tp1nro2, f.tp1imp2
          into ln_CodSegMultirisk, ln_MntBase
          from fst198 f
         where f.tp1cod = 1
           and f.tp1cod1 = 11141
           and f.tp1corr1 = 13
           and f.tp1corr2 in (1, 2)
           and f.tp1nro1 = ln_moe
           and f.tp1nro3 = ln_mda
           and f.tp1imp1 = ln_ciiu
           and f.tp1imp3 = ln_frec;
      exception
        when others then
          ln_CodSegMultirisk := 0;
      end;
    
      if pn_mto > ln_MntBase and ln_CodSegMultirisk > 0 then
      
        --  No asegura créditos mayores a S/ 600.000 o $ 150.000   - Permitido cod 168
        --  No asegura créditos mayores a S/ 100.000 o $ 25.000 ¿ Restringidos cod 188
      
        begin
          select f.tp1imp1
            into ln_MaxMntSeg
            from fst198 f
           where f.tp1cod = 1
             and f.tp1cod1 = 11141
             and f.tp1corr1 = 13
             and f.tp1corr2 = 4
             and f.tp1nro1 = ln_moe
             and f.tp1nro2 = ln_CodSegMultirisk
             and f.tp1nro3 = ln_mda;
        exception
          when others then
            ln_MaxMntSeg := 0.00;
        end;
      
        if pn_mto <= ln_MaxMntSeg then
        
          begin
            select nvl(max(a.jaqm751cor), 0) + 1
              into ln_Cor751
              from jaqm751 a
             where a.jaqm751emp = 1
               and a.jaqm751fch = pd_fecpro
               and a.jaqm751att = 'SEGCOD'
               and a.jaqm751reg = ln_Corr;
          exception
            when others then
              ln_Cor751 := null;
          end;
        
          if nvl(ln_Cor751, 0) = 1 then
            ln_Cor751 := 1;
          end if;
        
          begin
            insert into jaqm751
              (jaqm751emp,
               jaqm751fch,
               jaqm751reg,
               jaqm751att,
               jaqm751cor,
               jaqm751val)
            values
              (1,
               pd_fecpro,
               ln_Corr,
               'SEGCOD',
               ln_Cor751,
               ln_CodSegMultirisk);
          exception
            when others then
              null;
          end;
        
          commit;
        end if;
      end if;
    end if;
  
  end sp_cr_SegMultiRisk;
  -------------------------------------------------   
  -- efuentes 2022.05.18 Registrar seguros
  Procedure Sp_insert_seguros(pn_pai    in number,
                              pn_tdo    in number,
                              pc_ndo    in char,
                              pn_cor    in number, -- correlativo campaña
                              pd_fec    in date,
                              ln_corr   in number, --correlativo 751
                              pd_fecpro in date,
                              pc_flag   out char) is
  
    lc_doc     char(12);
    lc_flexist char(1);
    ln_CorSeg  number;
    my_errm    varchar2(3000);
    lc_flgra   char(1);
    ln_codseg  number;
  
    CURSOR lst_seg(fecha       date,
                   pais        number,
                   tipdoc      number,
                   documento   char,
                   correlativo number) is
    
      select a.aqpc266codsg || '|' || A.AQPC266AUX1 ln_codseg
        from AQPC266 a
       where a.aqpc266fch = fecha
         and a.aqpc266pais = pais
         and a.aqpc266tpdoc = tipdoc
         and RPAD(a.AQPC266DNI, 12, ' ') = RPAD(documento, 12, ' ')
         and a.AQPC266CORR = correlativo;
  
  begin
  
    lc_doc := pc_ndo;
  
    lc_flgra := 'N';
  
    for i in lst_seg(pd_fec, pn_pai, pn_tdo, lc_doc, pn_cor) loop
      begin
        select nvl(max(a.jaqm751cor), 0) + 1
          into ln_CorSeg
          from jaqm751 a
         where a.jaqm751emp = 1
           and a.jaqm751fch = pd_fecpro
           and a.jaqm751att = RPAD('SEGCOD', 20, ' ')
           and a.jaqm751reg = ln_Corr;
      exception
        when others then
          null;
      end;
    
      begin
        insert into jaqm751 j
          (j.jaqm751emp,
           j.jaqm751fch,
           j.jaqm751reg,
           j.jaqm751att,
           j.jaqm751cor,
           j.jaqm751val)
        values
          (1, pd_fecpro, ln_Corr, 'SEGCOD', ln_CorSeg, i.ln_codseg);
        COMMIT;
        lc_flgra := 'S';
      exception
        when others then
          my_errm  := SQLERRM;
          lc_flgra := 'N';
          null;
      end;
      lc_flgra := 'S';
    end loop;
  
  end Sp_insert_seguros;

---------------------------------------------------------  
end pq_cr_modulo_campanias;
/

