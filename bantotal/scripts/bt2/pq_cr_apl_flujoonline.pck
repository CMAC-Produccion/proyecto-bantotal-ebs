CREATE OR REPLACE Package pq_cr_apl_flujoOnline is
  Procedure Sp_Proceso_flujo(pn_pai    in number,
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
                             pd_FecPri in date);

  Procedure Sp_ultima_eva(pn_pai  in number,
                          pn_tdo  in number,
                          pc_ndo  in char,
                          pd_fec  in date,
                          pn_corr in number,
                          p_error out char,
                          pn_eva  out number,
                          pn_moe  out number);

  Procedure Sp_valida(pn_pai      in number,
                      pn_tdo      in number,
                      pc_ndo      in char,
                      pn_cor      in number,
                      pd_fec      in date,
                      pn_mto      in number,
                      pn_cta      in number,
                      pn_cuo      in number,
                      pn_pzo      in number,
                      pn_suc      in number,
                      pc_ase      in varchar2,
                      pn_moe      in number,
                      pd_Fecpro   in date,
                      pd_FecPrim  in date,
                      pc_flag     in char,
                      pn_mtoCuo   out number,
                      pn_CuotaCal out number,
                      pc_err      out varchar2);
  procedure sp_deudaAmpliado(pn_emp in number,
                             pn_mod in number,
                             pn_suc in number,
                             pn_mda in number,
                             pn_pap in number,
                             pn_cta in number,
                             pn_ope in number,
                             pn_sbo in number,
                             pn_top in number,
                             pn_mto out number);
  Procedure Sp_evaluacionAnt(pn_pai       in number,
                             pn_tdo       in number,
                             pc_ndo       in char,
                             pd_Fecpro    in date,
                             pc_err       out char,
                             pn_ActCorr   out number,
                             pn_ActNoCorr out number,
                             pn_Activo    out number,
                             pn_PasNoCorr out number,
                             pn_PasCorr   out number,
                             pn_Pasivo    out number,
                             pn_Patrim    out number,
                             pn_PsPatrim  out number,
                             pn_ventas    out number,
                             pn_utilBruta out number,
                             pn_utilNeta  out number,
                             pn_gasFam    out number,
                             pn_resulNeto out number);
  Procedure Sp_evaluacion(pn_pai        in number,
                          pn_tdo        in number,
                          pc_ndo        in char,
                          pd_Fecpro     in date,
                          pd_FecBI      in date,
                          pn_cor        in number,
                          pc_err        out char,
                          pn_ActCorr    out number,
                          pn_ActNoCorr  out number,
                          pn_Activo     out number,
                          pn_PasNoCorr  out number,
                          pn_PasCorr    out number,
                          pn_Pasivo     out number,
                          pn_Patrim     out number,
                          pn_PsPatrim   out number,
                          pn_ventas     out number,
                          pn_utilBruta  out number,
                          pn_utilNeta   out number,
                          pn_gasFam     out number,
                          pn_resulNeto  out number,
                          pn_gastoFinan out number,
                          pc_act        out char);
  Procedure Sp_evaluacionCons(pn_pai      in number,
                              pn_tdo      in number,
                              pc_ndo      in char,
                              pd_Fecpro   in date,
                              pd_FecBI    in date,
                              pn_cor      in number,
                              pc_err      out char,
                              pn_IngBruto out number,
                              pn_IngNeto  out number,
                              pn_gasFam   out number,
                              pn_gasFin   out number,
                              pn_excMens  out number);
  Procedure Sp_ultima_eva_Consul(pn_pai  in number,
                                 pn_tdo  in number,
                                 pc_ndo  in char,
                                 p_error out char,
                                 pn_eva  out number,
                                 pn_moe  out number);
  Procedure Sp_aprobar(pd_Fec in date, pn_cor in number, pc_res in char);
  --***********************************************************
  Procedure Sp_valida_FlujoReducido(pn_pai      in number,
                                    pn_tdo      in number,
                                    pc_ndo      in char,
                                    pn_cor      in number,
                                    pd_fec      in date,
                                    pn_mto      in number,
                                    pn_cta      in number,
                                    pn_cuo      in number,
                                    pn_pzo      in number,
                                    pn_suc      in number,
                                    pc_ase      in varchar2,
                                    pn_moe      in number,
                                    pd_Fecpro   in date,
                                    pd_FecPrim  in date,
                                    pc_flag     in char,
                                    pn_mtoCuo   out number,
                                    pn_CuotaCal out number,
                                    pc_err      out varchar2);
  --***********************************************************
  Procedure Sp_Proceso_flujoReducido_2(pn_pai    in number,
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
                                       pn_cor    in number,
                                       pd_fec    in date,
                                       pn_moe    in number,
                                       pd_FecPri in date);
  --***********************************************************
  Procedure Sp_flujoReducido(pn_pai    in number,
                             pn_tdo    in number,
                             pc_ndo    in varchar2,
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
                             pd_FecPri in date);

  --***********************************************************
  Procedure Sp_Proceso_flujoReducido(pn_pai    in number,
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
                                     pd_FecPri in date);
end pq_cr_apl_flujoOnline;
/

CREATE OR REPLACE Package body pq_cr_apl_flujoOnline is

  Procedure Sp_Proceso_flujo(pn_pai    in number,
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
                             pd_FecPri in date) is
  
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
    --ln_mtoCuota  number(17, 2);
    --ln_evaIni number(10);
    ln_evaAct   number(10);
    pn_mtoCuo   number(17, 2);
    pc_flag     char(1);
    lc_reactiva char(1) := 'N'; --mod@abr 20200623
    --0 se ejecuta proceso de fintech
    --1 se ejecuta proceso de flujo online
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
         and j.jaqz697fep = pd_fec
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
      ld_Fecaux := pd_FecPri;
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
    
      if nvl(lc_flgAmpl, 'N') = 'N' then
      
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
    
      Pq_Cr_Modulo_campanias.Sp_insert_bandeja2(pn_pai    => pn_pai,
                                                pn_tdo    => pn_tdo,
                                                pc_ndo    => pc_ndo,
                                                pd_Fecpro => pd_fecpro,
                                                pc_ase    => pc_ase,
                                                pn_seg    => pn_moe,
                                                pn_cor    => pn_cor,
                                                pd_fecP   => pd_fec);
    
      begin
        select /*a.jaqz697evn,*/
         a.jaqz697eva
          into /*ln_evaIni,*/ ln_evaAct
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
    
      Pq_Cr_Modulo_campanias.Sp_insert_bandeja3(pn_pai  => pn_pai,
                                                pn_tdo  => pn_tdo,
                                                pc_ndo  => pc_ndo,
                                                pn_corr => pn_cor,
                                                pd_fecP => pd_fec,
                                                pn_eva  => ln_evaAct);
    
      Pq_Cr_Modulo_Campanias.Sp_cr_inserta_Aqpa190d(pn_eval => ln_evaAct --,
                                                    --pn_evaant => ln_evaIni,
                                                    --pd_fecpro => pd_fecpro
                                                    );
      if pn_moe = 14 then
        Pq_Cr_Modulo_Campanias.Sp_Cr_aqpa190c(ln_evaAct);
      end if;
    
      Pq_Cr_Modulo_campanias.Sp_cr_actualiza(pn_cor => pn_cor,
                                             pn_pai => pn_pai,
                                             pn_tdo => pn_tdo,
                                             pc_ndo => pc_ndo,
                                             pd_fec => pd_fec);
    
      pc_flag := 'S';
      pq_cr_modulo_campanias.Sp_actualizaInfo(pn_cor     => pn_cor,
                                              pd_fec     => pd_fec,
                                              pn_mto     => pn_mto,
                                              pn_cta     => pn_cta,
                                              pn_cuo     => pn_cuo,
                                              pn_fre     => pn_pzo,
                                              pn_suc     => pn_suc,
                                              pn_ase     => pc_ase,
                                              pn_eva     => ln_evaAct,
                                              pd_fecprim => pd_FecPrim,
                                              pc_flg     => pc_flag,
                                              pn_mtocuo  => pn_mtoCuo);
    
    end if;
  
  end Sp_Proceso_flujo;

  Procedure Sp_ultima_eva(pn_pai  in number,
                          pn_tdo  in number,
                          pc_ndo  in char,
                          pd_fec  in date,
                          pn_corr in number,
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
  
    update jaqz697 a
       set a.jaqz697evn = pn_eva
     where a.jaqz697fep = pd_fec
       and a.jaqz697cor = pn_corr
       and a.jaqz697pai = pn_pai
       and a.jaqz697tdo = pn_tdo
       and a.jaqz697ndo = pc_ndo;
  
    commit;
  
  end Sp_ultima_eva;

  Procedure Sp_valida(pn_pai      in number,
                      pn_tdo      in number,
                      pc_ndo      in char,
                      pn_cor      in number,
                      pd_fec      in date,
                      pn_mto      in number,
                      pn_cta      in number,
                      pn_cuo      in number,
                      pn_pzo      in number,
                      pn_suc      in number,
                      pc_ase      in varchar2,
                      pn_moe      in number,
                      pd_Fecpro   in date,
                      pd_FecPrim  in date,
                      pc_flag     in char,
                      pn_mtoCuo   out number,
                      pn_CuotaCal out number,
                      pc_err      out varchar2) is
  
    --ln_eva        number(10);
    ln_mtoCuota   number(17, 2);
    lc_error      varchar2(200);
    ln_EvaUlt     number(10);
    ln_moe        number(4);
    ln_tipcambio  number(15, 8);
    ln_cobertura  number(9);
    ln_cuotaCaja  number(17, 2);
    ln_sdoExt     number(18, 2);
    ln_res        number(17, 2);
    ln_ratio      number(10, 6);
    ln_ins        number(10);
    lc_Program    varchar2(10);
    ln_CuotaCal   number(17, 2);
    ln_resul      number(17, 2);
    ln_mtoSoles   number(17, 2);
    ln_mtoDol     number(17, 2);
    ln_empA       number(4);
    ln_modA       number(4);
    ln_sucA       number(4);
    ln_mdaA       number(4);
    ln_papA       number(4);
    ln_ctaA       number(9);
    ln_opeA       number(9);
    ln_sboA       number(3);
    ln_topA       number(3);
    lc_credVigt   char(1);
    lc_Mora       char(1);
    lc_cr         char(1);
    lc_flgAmp     varchar2(30);
    ln_deuda      number(17, 2);
    ln_mtoPro     number(17, 2);
    ln_mod        number(3);
    ln_top        number(3);
    ln_mda        number(3);
    ln_plazo      number(17);
    ln_pzoCal     number(5);
    lc_act        char(1);
    ld_fecPrimPag date;
    ln_gracia     number(5);
    ld_FecSis     date;
    ln_pazoIni    number(5);
    ln_cuoIni     number(10);
    ln_ind        char(1);
    ln_cuotaIni   number(17, 2);
    lc_reactiva   char(1) := 'N'; --mod@abr 20200623
    ln_mesCont    number(10);
    ln_pzoCtrl    number(5);
    ln_quiebre    number(5);
    ln_diasF      number(5);
    --ln_cuotaRat    number(17, 2);
    ln_captotcaja  number(17, 2);
    ln_Saldo       number(17, 2);
    ln_resultneto  number(17, 2);
    ln_mntpotncial number(17, 2);
    ln_mntcuocntg  number(17, 2);
    ln_ratioPyme   number(10, 6);
    ln_cuotaQui    number(17, 2);
    lc_flgRatio    char(1);
    ln_tasa        number(10, 6);
    ln_tasaCtrl    number(10);
    ln_tasaOri     number(10, 6);
    ln_cta         number(9);
    lc_des         char(30);
    ln_tasaVis     number(10, 6);
  
    ln_evn       number(10); --mod@abr 20210617
    ld_fecpriCal date; --mod@abr 20210617
  
  begin
  
    begin
      select a.pgfape into ld_FecSis from fst017 a where a.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    --tasa
    Pq_Cr_Modulo_Campanias.Sp_Cr_tasa(pd_fec    => pd_fec,
                                      pn_cor    => pn_cor,
                                      pd_fecpro => ld_FecSis,
                                      pn_tas    => ln_tasa);
    Pq_Cr_Modulo_Campanias.sp_cr_tasa_cta(pd_fec    => pd_fec,
                                          pn_cor    => pn_cor,
                                          pd_fecpro => ld_FecSis,
                                          pn_cta    => pn_cta,
                                          pn_tas    => ln_tasaOri);
  
    Pq_Cr_Modulo_Campanias.Sp_CalculaCuota(pn_cor     => pn_cor,
                                           pd_fec     => pd_fec,
                                           pn_mto     => pn_mto,
                                           pn_cuo     => pn_cuo,
                                           pn_fre     => pn_pzo,
                                           pn_suc     => pn_suc,
                                           pd_fecprim => pd_fecprim,
                                           pc_flag    => pc_flag,
                                           pn_cta     => pn_cta,
                                           pn_mtocuo  => ln_mtoCuota,
                                           pn_tasa    => ln_tasaVis);
    pn_mtoCuo := ln_mtoCuota;
    Pq_Cr_Modulo_Campanias.Sp_ultima_eva(pn_pai  => pn_pai,
                                         pn_tdo  => pn_tdo,
                                         pc_ndo  => pc_ndo,
                                         p_error => lc_error,
                                         pn_eva  => ln_EvaUlt,
                                         pn_moe  => ln_moe);
  
    begin
      select a.jaqz697mto,
             a.jaqz697mod,
             a.jaqz697top,
             a.jaqz697mda,
             a.jaqz697act,
             a.jaqz697pzo,
             a.jaqz697cuo,
             a.jaqz697moe,
             a.jaqz697eva,
             a.jaqz697cta,
             a.jaqz697des,
             a.jaqz697evn --mod@abr 20210617            
        into ln_mtoPro,
             ln_mod,
             ln_top,
             ln_mda,
             lc_act,
             ln_pazoIni,
             ln_cuoIni,
             ln_moe,
             ln_EvaUlt,
             ln_cta,
             lc_des,
             ln_evn --mod@abr 20210617
      
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
  
    ld_fecpriCal := ld_FecSis + ln_pazoIni; --mod@abr 20210617
  
    --mod@abr 20200623
    begin
      select 'S'
        into lc_reactiva
        from fst198 a
       where a.tp1cod = 1
         and a.TP1COD1 = 11141
         and a.tp1corr1 = 11
         and a.tp1corr2 = 1
         and a.tp1nro1 = ln_mod
         and a.tp1nro2 = ln_top;
    exception
      when others then
        null;
    end;
    --mod@abr 20200623
  
    begin
      select a.tp1nro1
        into ln_quiebre
        from fst198 a
       where a.tp1cod = 1
         and a.TP1COD1 = 11141
         and a.tp1corr1 = 12
         and a.tp1corr2 = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select a.tp1nro1
        into ln_tasaCtrl
        from fst198 a
       where a.tp1cod = 1
         and a.TP1COD1 = 11141
         and a.tp1corr1 = 12
         and a.tp1corr2 = 3;
    exception
      when others then
        null;
    end;
  
    --mod@abr 20210617 
  
    if ld_fecpriCal <> pd_FecPrim and lc_error is null and ln_moe = 13 and
       ln_mod = 117 then
      lc_error := 'No puede modificar la fecha de primer pago para esta oferta';
    end if;
  
    if ln_cuoIni <> pn_cuo and lc_error is null and ln_moe = 13 and
       ln_mod = 117 then
      lc_error := 'No puede modificar el numero de cuotas para esta oferta';
    end if;
  
    if pn_mto >= 999999 and lc_error is null and ln_moe = 13 and ln_evn = 1 then
      lc_error := 'Propuestas con 999999 deben ser procesados por flujo reducido';
    end if;
  
    --mod@abr 20210617
  
    if pn_cta <> ln_cta and lc_error is null and lc_reactiva = 'N' and
       trim(lc_des) <> 'ADICIONAL' and ln_moe = 13 then
      lc_error := 'No puede modificar la cuenta para esta oferta';
    end if;
  
    if (ln_tasa >= ln_tasaCtrl or ln_tasaOri >= ln_tasaCtrl) and
       lc_error is null then
      lc_error := 'La oferta no tiene tasa asociada';
    end if;
  
    if pn_pzo <> 30 and lc_reactiva = 'S' and lc_error is null then
      lc_error := 'No puede escoger una frecuencia diferente a la mensual';
    end if;
  
    if pn_pzo <> 30 and lc_reactiva = 'N' and ln_moe = 13 and
       lc_error is null then
      lc_error := 'La frecuencia de pago debe ser mensual';
    end if; --mpostigoc 03.02.21
  
    if pn_mto < 500 and lc_error is null then
      lc_error := 'El monto ingresado es menor al permitido';
    end if;
  
    if pd_FecPrim < ld_FecSis and lc_error is null then
      lc_error := 'La fecha de primer pago no puede ser menor a la fecha del sistema';
    end if;
  
    if pn_cuo < 1 and lc_error is null then
      lc_error := 'El numero de cuotas es menor al minimo permitido';
    end if;
  
    if pn_moe <> ln_moe and lc_error is null then
      lc_error := 'El segmento del cliente no coincide con el modelo de evaluacion';
    end if;
  
    ln_ind := 'N';
  
    --calculo cuota datos iniciales
    Pq_Cr_Modulo_Campanias.Sp_CalculaCuota(pn_cor     => pn_cor,
                                           pd_fec     => pd_fec,
                                           pn_mto     => ln_mtoPro,
                                           pn_cuo     => ln_cuoIni,
                                           pn_fre     => ln_pazoIni,
                                           pn_suc     => pn_suc,
                                           pd_fecprim => pd_fecprim,
                                           pc_flag    => ln_ind,
                                           pn_cta     => ln_cta,
                                           pn_mtocuo  => ln_cuotaIni,
                                           pn_tasa    => ln_tasaVis);
  
    ln_diasF := (pd_FecPrim - ld_FecSis) - pn_pzo;
  
    if ln_diasF <= ln_quiebre then
      ln_cuotaQui := (ln_cuotaIni / 0.7) * 0.8;
    end if;
  
    if lc_error is null and ln_diasF <= ln_quiebre and
       nvl(lc_reactiva, 'N') = 'N' and pn_moe = 13 and
       ln_mtoCuota > ln_cuotaQui and ln_mod <> 105 then
      -- mpostigoc 04.01.2021 se agrego la validacion del mod 105
      lc_error := 'La nueva cuota supera el 80% de su capacidad de pago';
    end if;
  
    if ln_mod = 105 then
      pq_cr_ratio_paralelo.sp_inicioratio_dten(pn_cor,
                                               pd_fec,
                                               ld_FecSis,
                                               pc_ase,
                                               pn_mto,
                                               ln_Saldo,
                                               ln_resultneto,
                                               ln_ratioPyme);
    else
    
      pq_cr_ratiopyme_dten.sp_calculoratio(pn_pai,
                                           pn_tdo,
                                           pc_ndo,
                                           pn_cor,
                                           pd_fec,
                                           pc_ase,
                                           ln_mtoCuota,
                                           ln_captotcaja,
                                           ln_Saldo,
                                           ln_resultneto,
                                           ln_mntpotncial,
                                           ln_mntcuocntg,
                                           ln_ratioPyme);
    
    end if;
  
    lc_flgRatio := 'N';
  
    if ln_mod = 105 then
      if ln_ratioPyme > 0.8 then
        lc_flgRatio := 'S';
      end if;
    else
      if ln_diasF <= ln_quiebre then
        if ln_ratioPyme > 0.78 then
          --mpostigoc 03.02.21
          lc_flgRatio := 'S';
        end if;
      else
        if ln_ratioPyme > 0.68 then
          --mpostigoc 03.02.21
          lc_flgRatio := 'S';
        end if;
      end if;
    end if;
  
    if lc_error is null then
      if lc_flgRatio = 'S' and nvl(lc_reactiva, 'N') = 'N' and pn_moe = 13 then
        lc_error := 'La nueva cuota supera el ratio';
      end if;
    end if;
  
    if lc_error is null then
      if ln_mtoCuota > ln_cuotaIni and nvl(lc_reactiva, 'N') = 'N' then
        lc_error := 'La cuota supera la cuota propuesta';
      end if;
    end if;
  
    if pn_mto > ln_mtoPro and lc_error is null then
      lc_error := 'No es permitido un monto mayor al propuesto';
    end if;
  
    if lc_error is null then
      begin
        select a.tp1nro1
          into ln_gracia
          from fst198 a
         where a.tp1cod = 1
           and a.tp1cod1 = 10899
           and a.tp1corr1 = 44444
           and a.tp1corr2 = 3
           and a.tp1desc = lc_act;
      exception
        when others then
          null;
      end;
    
      ld_fecPrimPag := ld_FecSis + ln_gracia + pn_pzo;
    
      if pd_FecPrim > ld_fecPrimPag then
        lc_error := 'La fecha de primer pago es mayor a la maxima permitida';
      end if;
    end if;
  
    If lc_error is null then
      If pn_moe = 14 then
        begin
          select Pp028MaxN
            into ln_plazo
            from fpp028
           Where Pp017Par = 103
             and Pp028Mod = ln_mod
             and Pp028Top = ln_top
             and Pp028Mda = ln_mda;
        exception
          when others then
            null;
        end;
      
        If pn_cuo > ln_plazo then
          lc_error := 'El numero de cuotas supera el plazo maximo';
        end if;
      
      Else
      
        ln_pzoCal := pn_cuo * pn_pzo;
      
        begin
          select Pp028MaxN
            into ln_plazo
            from fpp028
           Where Pp017Par = 113
             and Pp028Mod = ln_mod
             and Pp028Top = ln_top
             and Pp028Mda = ln_mda;
        exception
          when others then
            null;
        end;
      
        If ln_pzoCal > ln_plazo and ln_mod <> 105 then
          -- mpostigoc 05.01.2021
          lc_error := 'Supera el plazo maximo';
        end if;
      
      End If;
    end if;
  
    if lc_error is null then
    
      pq_cr_modulo_campanias.sp_meses(ld_FecSis, pd_FecPrim, ln_mesCont);
    
      if ln_mod = 105 then
        -- mpostigoc 05.01.2021
      
        pq_cr_modulo_campanias.sp_cr_plazoparalelo(pn_mda => ln_mda,
                                                   pn_mod => ln_mod,
                                                   pn_top => ln_top,
                                                   pn_pzo => ln_plazo);
      
        if (pn_cuo <= 6 and pn_pzo = 30 and ln_mesCont = 1) or
           (pn_cuo <= 3 and pn_pzo = 60 and ln_mesCont <= 2) or
           (pn_cuo <= 2 and pn_pzo = 90 and ln_mesCont <= 3) or
           (pn_cuo = 1 and pn_pzo = 180 and ln_mesCont <= 6) then
          --mpostigoc 05.01.2021
        
          ln_mesCont := 0;
        end if;
      end if;
    
      ln_pzoCtrl := (ln_mesCont + pn_cuo) * pn_pzo;
    
      If ln_pzoCtrl > ln_plazo and /*lc_reactiva = 'S'*/
         pn_moe = 13 then
        lc_error := 'El plazo mas la gracia supera el maximo permitido';
      end if;
    
    end if;
  
    if lc_error is null then
      --valida ampliados
      begin
        select a.jaqz697tip,
               1,
               a.jaqz697moa,
               a.jaqz697sua,
               a.jaqz697maa,
               a.jaqz697paa,
               a.jaqz697caa,
               a.jaqz697opa,
               a.jaqz697sba,
               a.jaqz697toa
          into lc_flgAmp,
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
         where a.jaqz697pai = pn_pai
           and a.jaqz697tdo = pn_tdo
              --  and a.jaqz697ndo = trim(pc_ndo)
           and a.jaqz697cor = pn_cor
           and a.jaqz697fep = pd_fec;
      exception
        when others then
          null;
      end;
    
      if trim(lc_flgAmp) = 'A' then
        pq_cr_modulo_campanias.sp_validac_ampliado(pn_emp    => ln_empA,
                                                   pn_mod    => ln_modA,
                                                   pn_suc    => ln_sucA,
                                                   pn_mda    => ln_mdaA,
                                                   pn_pap    => ln_papA,
                                                   pn_cta    => ln_ctaA,
                                                   pn_ope    => ln_opeA,
                                                   pn_sbo    => ln_sboA,
                                                   pn_top    => ln_topA,
                                                   pd_Fecpro => pd_Fecpro,
                                                   pc_flg    => lc_credVigt,
                                                   pc_flgM   => lc_Mora,
                                                   pc_flgVC  => lc_cr);
      
        pq_cr_apl_flujoOnline.sp_deudaAmpliado(pn_emp => ln_empA,
                                               pn_mod => ln_modA,
                                               pn_suc => ln_sucA,
                                               pn_mda => ln_mdaA,
                                               pn_pap => ln_papA,
                                               pn_cta => ln_ctaA,
                                               pn_ope => ln_opeA,
                                               pn_sbo => ln_sboA,
                                               pn_top => ln_topA,
                                               pn_mto => ln_deuda);
        If lc_credVigt = 'N' then
          lc_error := 'El credito a ampliar no esta vigente.';
        Else
          --If lc_Mora = 'S' then
          --lc_error := 'El cliente esta en mora.';
          --Else
          --If lc_cr = 'S' then --mod@abr 05062020
          --lc_error := 'El cliente tiene cuotas irregulares.'; --mod@abr 05062020
        
          --else --mod@abr 05062020
          If pn_mto > ln_deuda then
            lc_error := 'El monto de deuda es mayor al monto ingresado.';
          end if;
        
          --End If; --mod@abr 05062020
        
          --End If;
        
        End If;
      
      end if;
    
    end if;
  
    if lc_error is null then
      pq_cr_modulo_campanias.Sp_cr_tipocambio(pd_Fecpro, ln_tipcambio);
    
      if ln_moe = 13 then
        begin
          select a.aqpa190bmto
            into ln_mtoSoles
            from aqpa190b_bdj a
           where a.aqpa190beval = ln_EvaUlt
             and a.aqpa190bcod = 40;
        exception
          when others then
            null;
        end;
      
        begin
          select a.aqpa190bmto
            into ln_mtoDol
            from aqpa190b_bdj a
           where a.aqpa190beval = ln_EvaUlt
             and a.aqpa190bcod = 540;
        exception
          when others then
            null;
        end;
      
        ln_resul := nvl(ln_mtoSoles, 0) +
                    (nvl(ln_mtoDol, 0) / ln_tipcambio);
      
        ln_ins     := 0;
        lc_Program := 'OTROS';
      
        pq_cr_modulo_campanias.sp_CalculoRAtioPYME(ln_Pepais     => pn_pai,
                                                   ln_Petdoc     => pn_tdo,
                                                   ln_Pendoc     => pc_ndo,
                                                   tipocambio    => ln_tipcambio,
                                                   Instancia     => ln_ins,
                                                   pd_fecpro     => pd_fecpro,
                                                   lc_prgm       => lc_Program,
                                                   lc_Usuario    => pc_ase,
                                                   ln_captotcaja => ln_cuotaCaja,
                                                   saldo_externo => ln_sdoExt,
                                                   ResultNeto    => ln_res,
                                                   ln_captotal   => ln_ratio);
      
        ln_resul := nvl(ln_resul, 0) - nvl(ln_cuotaCaja, 0);
      
        begin
          select Tp1nro1
            into ln_cobertura
            from fst198
           Where Tp1cod = 1
             and Tp1cod1 = 10899
             and Tp1corr1 = 99999
             and Tp1corr2 = 11
             and Tp1corr3 = 1;
        exception
          when others then
            null;
        end;
      
        ln_CuotaCal := (ln_resul * ln_cobertura) / 100;
      
      else
      
        begin
          select a.aqpa190bmto
            into ln_mtoSoles
            from aqpa190b_bdj a
           where a.aqpa190beval = ln_EvaUlt
             and a.aqpa190bcod = 27;
        exception
          when others then
            null;
        end;
      
        begin
          select a.aqpa190bmto
            into ln_mtoDol
            from aqpa190b_bdj a
           where a.aqpa190beval = ln_EvaUlt
             and a.aqpa190bcod = 527;
        exception
          when others then
            null;
        end;
      
        ln_resul := nvl(ln_mtoSoles, 0) +
                    (nvl(ln_mtoDol, 0) / ln_tipcambio);
      
        ln_ins     := 0;
        lc_Program := 'OTROS';
        pq_cr_modulo_campanias.sp_calculoratio(ln_Pepais        => pn_pai,
                                               ln_Petdoc        => pn_tdo,
                                               ln_Pendoc        => pc_ndo,
                                               tipocambio       => ln_tipcambio,
                                               Instancia        => ln_ins,
                                               pd_fecpro        => pd_fecpro,
                                               lc_prgm          => lc_Program,
                                               ln_Usuario       => pc_ase,
                                               ln_captotcaja    => ln_cuotaCaja,
                                               saldo_externo    => ln_sdoExt,
                                               ln_ExcdntMensual => ln_res,
                                               ln_RatioConsumo  => ln_ratio);
      
        ln_resul := nvl(ln_resul, 0) - nvl(ln_cuotaCaja, 0);
      
        begin
          select Tp1nro1
            into ln_cobertura
            from fst198
           Where Tp1cod = 1
             and Tp1cod1 = 10899
             and Tp1corr1 = 99999
             and Tp1corr2 = 2
             and Tp1corr3 = 1;
        exception
          when others then
            null;
        end;
      
        ln_CuotaCal := (ln_resul * ln_cobertura) / 100;
      
      end if;
    
      pn_CuotaCal := ln_CuotaCal;
    
    end if;
  
    if lc_error is null then
      if ln_mtoCuota > ln_CuotaCal and nvl(lc_reactiva, 'N') = 'N' then
        lc_error := 'La cuota supera el maximo permitido';
      
        /*else
        begin
          select a.jaqz697eva
            into ln_eva
            from jaqz697 a
           where a.jaqz697pai = pn_pai
             and a.jaqz697tdo = pn_tdo
             and a.jaqz697ndo = pc_ndo
             and a.jaqz697cor = pn_cor
             and a.jaqz697fep = pd_fec;
        exception
          when others then
            null;
        end;*/
      
        /*If ln_eva is null then
          pq_cr_modulo_campanias.sp_Cr_genera_eva(ln_eva);
        
        end if;*/
        /*pq_cr_modulo_campanias.Sp_actualizaInfo(pn_cor     => pn_cor,
        pd_fec     => pd_fec,
        pn_mto     => pn_mto,
        pn_cta     => pn_cta,
        pn_cuo     => pn_cuo,
        pn_fre     => pn_pzo,
        pn_suc     => pn_suc,
        pn_ase     => pc_ase,
        pn_eva     => ln_eva,
        pd_fecprim => pd_FecPrim,
        pc_flg     => pc_flag,
        pn_mtocuo  => pn_mtoCuo);*/
      end if;
    end if;
    pc_err := lc_error;
  end Sp_valida;

  procedure sp_deudaAmpliado(pn_emp in number,
                             pn_mod in number,
                             pn_suc in number,
                             pn_mda in number,
                             pn_pap in number,
                             pn_cta in number,
                             pn_ope in number,
                             pn_sbo in number,
                             pn_top in number,
                             pn_mto out number) is
  
    ln_cap number(17, 2);
    ln_int number(17, 2);
    ln_seg number(17, 2);
  
  begin
  
    begin
      select sum(n.ppcap), sum(n.ppint)
        into ln_cap, ln_int
        from fsd601 n
       where n.pgcod = pn_emp
         and n.ppcta = pn_cta
         and n.ppmda = pn_mda
         and n.ppsuc = pn_suc
         and n.pppap = pn_pap
         and n.ppoper = pn_ope
         and n.ppsbop = pn_sbo
         and n.pptope = pn_top
         and n.ppmod = pn_mod
         and n.d601co = 'S'
         and (n.ppcap + n.ppint) <> 0
         and not exists
      
       (select ppmod, ppcta, ppoper, pptope, ppfpag
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
                 and o.pp1stat = 'T'
                 and o.d602co = 'S'
                 and (o.pp1cap + o.pp1int) <> 0);
    exception
      when others then
        null;
    end;
  
    begin
      select sum(n.ppimp11 + n.ppimp12 + n.ppimp13 + n.ppimp14 + n.ppimp15)
        into ln_seg
        from fsd611 n
       where n.pgcod = pn_emp
         and n.ppcta = pn_cta
         and n.ppmda = pn_mda
         and n.ppsuc = pn_suc
         and n.pppap = pn_pap
         and n.ppoper = pn_ope
         and n.ppsbop = pn_sbo
         and n.pptope = pn_top
         and n.ppmod = pn_mod
         and not exists
      
       (select o.ppmod, o.ppcta, o.ppoper, o.pptope, o.ppfpag
                from fsd602 o, fsd612 a
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
                 and o.pp1stat = 'T'
                 and o.d602co = 'S'
                    --and (o.pp1cap + o.pp1int) <> 0
                 and o.pgcod = a.pgcod
                 and o.ppmod = a.ppmod
                 and o.ppsuc = a.ppsuc
                 and o.ppmda = a.ppmda
                 and o.pppap = a.pppap
                 and o.ppcta = a.ppcta
                 and o.ppoper = a.ppoper
                 and o.ppsbop = a.ppsbop
                 and o.pptope = a.pptope
                 and o.ppfpag = a.ppfpag
                 and o.pp1nump = a.pp1nump);
    exception
      when others then
        null;
    end;
  
    pn_mto := nvl(ln_cap, 0) + nvl(ln_int, 0) + nvl(ln_seg, 0);
  
  end sp_deudaAmpliado;

  Procedure Sp_evaluacionAnt(pn_pai       in number,
                             pn_tdo       in number,
                             pc_ndo       in char,
                             pd_Fecpro    in date,
                             pc_err       out char,
                             pn_ActCorr   out number,
                             pn_ActNoCorr out number,
                             pn_Activo    out number,
                             pn_PasNoCorr out number,
                             pn_PasCorr   out number,
                             pn_Pasivo    out number,
                             pn_Patrim    out number,
                             pn_PsPatrim  out number,
                             pn_ventas    out number,
                             pn_utilBruta out number,
                             pn_utilNeta  out number,
                             pn_gasFam    out number,
                             pn_resulNeto out number) is
  
    ln_eva        number(10);
    ln_moe        number(4);
    lc_err        char(100);
    ln_tipcambio  number(15, 8);
    ln_ActCorrS   number(17, 2);
    ln_ActCorrD   number(17, 2);
    ln_ActNoCorrS number(17, 2);
    ln_ActNoCorrD number(17, 2);
    ln_ActivoS    number(17, 2);
    ln_ActivoD    number(17, 2);
    Ln_PasCorrS   number(17, 2);
    ln_PasCorrD   number(17, 2);
    ln_PasNoCorrS number(17, 2);
    ln_PasNoCorrD number(17, 2);
    ln_PasivoS    number(17, 2);
    ln_PasivoD    number(17, 2);
    ln_PatrimS    number(17, 2);
    ln_PatrimD    number(17, 2);
    ln_PsPatrimS  number(17, 2);
    ln_PsPatrimD  number(17, 2);
    ln_ventasS    number(17, 2);
    ln_ventasD    number(17, 2);
    ln_utilBrutaS number(17, 2);
    ln_utilBrutaD number(17, 2);
    ln_utilNetaS  number(17, 2);
    ln_utilNetaD  number(17, 2);
    ln_gasFamS    number(17, 2);
    ln_gasFamD    number(17, 2);
    ln_resulNetoS number(17, 2);
    ln_resulNetoD number(17, 2);
  
  begin
  
    pq_cr_apl_flujoOnline.Sp_ultima_eva_Consul(pn_pai,
                                               pn_tdo,
                                               pc_ndo,
                                               lc_err,
                                               ln_eva,
                                               ln_moe);
    pq_cr_modulo_campanias.Sp_cr_tipocambio(pd_Fecpro, ln_tipcambio);
  
    if lc_err is null then
      if ln_moe = 14 then
        lc_err := 'La ultima evaluacion del cliente es modelo dependiente';
      else
        --Activo Corriente
        begin
          select a.sng023mto
            into ln_ActCorrS
            from sng023 a
           where a.sng021eval = ln_eva
             and a.sng026cod = 47;
        exception
          when others then
            null;
        end;
      
        begin
          select a.sng023mto
            into ln_ActCorrD
            from sng023 a
           where a.sng021eval = ln_eva
             and a.sng026cod = 547;
        exception
          when others then
            null;
        end;
      
        --Activo No Corriente
      
        begin
          select a.sng023mto
            into ln_ActNoCorrS
            from sng023 a
           where a.sng021eval = ln_eva
             and a.sng026cod = 51;
        exception
          when others then
            null;
        end;
      
        begin
          select a.sng023mto
            into ln_ActNoCorrD
            from sng023 a
           where a.sng021eval = ln_eva
             and a.sng026cod = 551;
        exception
          when others then
            null;
        end;
        --Activo
        begin
          select a.sng023mto
            into ln_ActivoS
            from sng023 a
           where a.sng021eval = ln_eva
             and a.sng026cod = 52;
        exception
          when others then
            null;
        end;
      
        begin
          select a.sng023mto
            into ln_ActivoD
            from sng023 a
           where a.sng021eval = ln_eva
             and a.sng026cod = 552;
        exception
          when others then
            null;
        end;
      
        --Pasivo Corriente
        begin
          select a.sng023mto
            into Ln_PasCorrS
            from sng023 a
           where a.sng021eval = ln_eva
             and a.sng026cod = 59;
        exception
          when others then
            null;
        end;
      
        begin
          select a.sng023mto
            into Ln_PasCorrD
            from sng023 a
           where a.sng021eval = ln_eva
             and a.sng026cod = 559;
        exception
          when others then
            null;
        end;
      
        --Pasivo No Corriente
      
        begin
          select a.sng023mto
            into ln_PasNoCorrS
            from sng023 a
           where a.sng021eval = ln_eva
             and a.sng026cod = 64;
        exception
          when others then
            null;
        end;
      
        begin
          select a.sng023mto
            into ln_PasNoCorrD
            from sng023 a
           where a.sng021eval = ln_eva
             and a.sng026cod = 564;
        exception
          when others then
            null;
        end;
        --Pasivo
        begin
          select a.sng023mto
            into ln_PasivoS
            from sng023 a
           where a.sng021eval = ln_eva
             and a.sng026cod = 65;
        exception
          when others then
            null;
        end;
      
        begin
          select a.sng023mto
            into ln_PasivoD
            from sng023 a
           where a.sng021eval = ln_eva
             and a.sng026cod = 565;
        exception
          when others then
            null;
        end;
      
        --Patrimonio
        begin
          select a.sng023mto
            into ln_PatrimS
            from sng023 a
           where a.sng021eval = ln_eva
             and a.sng026cod = 70;
        exception
          when others then
            null;
        end;
      
        begin
          select a.sng023mto
            into ln_PatrimD
            from sng023 a
           where a.sng021eval = ln_eva
             and a.sng026cod = 570;
        exception
          when others then
            null;
        end;
      
        --Pasivo Patrimonio
        begin
          select a.sng023mto
            into ln_PsPatrimS
            from sng023 a
           where a.sng021eval = ln_eva
             and a.sng026cod = 71;
        exception
          when others then
            null;
        end;
      
        begin
          select a.sng023mto
            into ln_PsPatrimD
            from sng023 a
           where a.sng021eval = ln_eva
             and a.sng026cod = 571;
        exception
          when others then
            null;
        end;
      
        --Ventas
        begin
          select a.sng023mto
            into ln_ventasS
            from sng023 a
           where a.sng021eval = ln_eva
             and a.sng026cod = 73;
        exception
          when others then
            null;
        end;
      
        begin
          select a.sng023mto
            into ln_ventasD
            from sng023 a
           where a.sng021eval = ln_eva
             and a.sng026cod = 573;
        exception
          when others then
            null;
        end;
      
        --Utilidad Bruta
        begin
          select a.sng023mto
            into ln_utilBrutaS
            from sng023 a
           where a.sng021eval = ln_eva
             and a.sng026cod = 75;
        exception
          when others then
            null;
        end;
      
        begin
          select a.sng023mto
            into ln_utilBrutaD
            from sng023 a
           where a.sng021eval = ln_eva
             and a.sng026cod = 575;
        exception
          when others then
            null;
        end;
      
        --Utilidad Neta
        begin
          select a.sng023mto
            into ln_utilNetaS
            from sng023 a
           where a.sng021eval = ln_eva
             and a.sng026cod = 84;
        exception
          when others then
            null;
        end;
      
        begin
          select a.sng023mto
            into ln_utilNetaD
            from sng023 a
           where a.sng021eval = ln_eva
             and a.sng026cod = 584;
        exception
          when others then
            null;
        end;
      
        --Gasto Familiar
        begin
          select a.sng023mto
            into ln_gasFamS
            from sng023 a
           where a.sng021eval = ln_eva
             and a.sng026cod = 54;
        exception
          when others then
            null;
        end;
      
        begin
          select a.sng023mto
            into ln_gasFamD
            from sng023 a
           where a.sng021eval = ln_eva
             and a.sng026cod = 554;
        exception
          when others then
            null;
        end;
      
        --Resultado Neto
        begin
          select a.sng023mto
            into ln_resulNetoS
            from sng023 a
           where a.sng021eval = ln_eva
             and a.sng026cod = 40;
        exception
          when others then
            null;
        end;
      
        begin
          select a.sng023mto
            into ln_resulNetoD
            from sng023 a
           where a.sng021eval = ln_eva
             and a.sng026cod = 540;
        exception
          when others then
            null;
        end;
      
        pn_ActCorr   := ln_ActCorrS + (ln_ActCorrD / ln_tipcambio);
        pn_ActNoCorr := ln_ActNoCorrS + (ln_ActNoCorrD / ln_tipcambio);
        pn_Activo    := ln_ActivoS + (ln_ActivoD / ln_tipcambio);
        pn_PasNoCorr := ln_PasNoCorrS + (ln_PasNoCorrD / ln_tipcambio);
        pn_PasCorr   := Ln_PasCorrS + (Ln_PasCorrD / ln_tipcambio);
        pn_Pasivo    := ln_PasivoS + (ln_PasivoD / ln_tipcambio);
        pn_Patrim    := ln_PatrimS + (ln_PatrimD / ln_tipcambio);
        pn_PsPatrim  := ln_PsPatrimS + (ln_PsPatrimD / ln_tipcambio);
        pn_ventas    := ln_ventasS + (ln_ventasD / ln_tipcambio);
        pn_utilBruta := ln_utilBrutaS + (ln_utilBrutaD / ln_tipcambio);
        pn_utilNeta  := ln_utilNetaS + (ln_utilNetaD / ln_tipcambio);
        pn_gasFam    := ln_gasFamS + (ln_gasFamD / ln_tipcambio);
        pn_resulNeto := ln_resulNetoS + (ln_resulNetoD / ln_tipcambio);
      
      end if;
    end if;
  
    pc_err := lc_err;
  
  end Sp_evaluacionAnt;

  Procedure Sp_evaluacion(pn_pai        in number,
                          pn_tdo        in number,
                          pc_ndo        in char,
                          pd_Fecpro     in date,
                          pd_FecBI      in date,
                          pn_cor        in number,
                          pc_err        out char,
                          pn_ActCorr    out number,
                          pn_ActNoCorr  out number,
                          pn_Activo     out number,
                          pn_PasNoCorr  out number,
                          pn_PasCorr    out number,
                          pn_Pasivo     out number,
                          pn_Patrim     out number,
                          pn_PsPatrim   out number,
                          pn_ventas     out number,
                          pn_utilBruta  out number,
                          pn_utilNeta   out number,
                          pn_gasFam     out number,
                          pn_resulNeto  out number,
                          pn_gastoFinan out number,
                          pc_act        out char) is
  
    ln_eva         number(10);
    ln_moe         number(4);
    lc_err         char(100);
    ln_tipcambio   number(15, 8);
    ln_ActCorrS    number(17, 2);
    ln_ActCorrD    number(17, 2);
    ln_ActNoCorrS  number(17, 2);
    ln_ActNoCorrD  number(17, 2);
    ln_ActivoS     number(17, 2);
    ln_ActivoD     number(17, 2);
    Ln_PasCorrS    number(17, 2);
    ln_PasCorrD    number(17, 2);
    ln_PasNoCorrS  number(17, 2);
    ln_PasNoCorrD  number(17, 2);
    ln_PasivoS     number(17, 2);
    ln_PasivoD     number(17, 2);
    ln_PatrimS     number(17, 2);
    ln_PatrimD     number(17, 2);
    ln_PsPatrimS   number(17, 2);
    ln_PsPatrimD   number(17, 2);
    ln_ventasS     number(17, 2);
    ln_ventasD     number(17, 2);
    ln_utilBrutaS  number(17, 2);
    ln_utilBrutaD  number(17, 2);
    ln_utilNetaS   number(17, 2);
    ln_utilNetaD   number(17, 2);
    ln_gasFamS     number(17, 2);
    ln_gasFamD     number(17, 2);
    ln_resulNetoS  number(17, 2);
    ln_resulNetoD  number(17, 2);
    ln_gastoFinanS number(17, 2);
    ln_gastoFinanD number(17, 2);
  
  begin
  
    /*pq_cr_apl_flujoOnline.Sp_ultima_eva_Consul(pn_pai,
    pn_tdo,
    pc_ndo,
    lc_err,
    ln_eva,
    ln_moe);*/
    pq_cr_modulo_campanias.Sp_cr_tipocambio(pd_Fecpro, ln_tipcambio);
  
    begin
      select a.jaqz697moe, a.jaqz697eva
        into ln_moe, ln_eva
        from jaqz697 a
       where a.jaqz697fep = pd_FecBI
         and a.jaqz697cor = pn_cor
         and a.jaqz697pai = pn_pai
         and a.jaqz697tdo = pn_tdo
         and a.jaqz697ndo = pc_ndo;
    exception
      when too_many_rows then
        begin
          select a.jaqz697moe, a.jaqz697eva
            into ln_moe, ln_eva
            from jaqz697 a
           where a.jaqz697fep = pd_FecBI
             and a.jaqz697cor = pn_cor
             and a.jaqz697pai = pn_pai
             and a.jaqz697tdo = pn_tdo
             and a.jaqz697ndo = pc_ndo
             and rownum = 1;
        exception
        
          when others then
            null;
        end;
      when others then
        null;
    end;
  
    if lc_err is null then
      if ln_moe = 14 then
        lc_err := 'La ultima evaluacion del cliente es modelo dependiente';
      else
        --Activo Corriente
        begin
          select a.aqpa190bmto
            into ln_ActCorrS
            from aqpa190b_bdj a
           where a.aqpa190beval = ln_eva
             and a.aqpa190bcod = 47;
        exception
          when others then
            null;
        end;
      
        begin
          select a.aqpa190bmto
            into ln_ActCorrD
            from aqpa190b_bdj a
           where a.aqpa190beval = ln_eva
             and a.aqpa190bcod = 547;
        exception
          when others then
            null;
        end;
      
        --Activo No Corriente
      
        begin
          select a.aqpa190bmto
            into ln_ActNoCorrS
            from aqpa190b_bdj a
           where a.aqpa190beval = ln_eva
             and a.aqpa190bcod = 51;
        exception
          when others then
            null;
        end;
      
        begin
          select a.aqpa190bmto
            into ln_ActNoCorrD
            from aqpa190b_bdj a
           where a.aqpa190beval = ln_eva
             and a.aqpa190bcod = 551;
        exception
          when others then
            null;
        end;
        --Activo
        begin
          select a.aqpa190bmto
            into ln_ActivoS
            from aqpa190b_bdj a
           where a.aqpa190beval = ln_eva
             and a.aqpa190bcod = 52;
        exception
          when others then
            null;
        end;
      
        begin
          select a.aqpa190bmto
            into ln_ActivoD
            from aqpa190b_bdj a
           where a.aqpa190beval = ln_eva
             and a.aqpa190bcod = 552;
        exception
          when others then
            null;
        end;
      
        --Pasivo Corriente
        begin
          select a.aqpa190bmto
            into Ln_PasCorrS
            from aqpa190b_bdj a
           where a.aqpa190beval = ln_eva
             and a.aqpa190bcod = 59;
        exception
          when others then
            null;
        end;
      
        begin
          select a.aqpa190bmto
            into Ln_PasCorrD
            from aqpa190b_bdj a
           where a.aqpa190beval = ln_eva
             and a.aqpa190bcod = 559;
        exception
          when others then
            null;
        end;
      
        --Pasivo No Corriente
      
        begin
          select a.aqpa190bmto
            into ln_PasNoCorrS
            from aqpa190b_bdj a
           where a.aqpa190beval = ln_eva
             and a.aqpa190bcod = 64;
        exception
          when others then
            null;
        end;
      
        begin
          select a.aqpa190bmto
            into ln_PasNoCorrD
            from aqpa190b_bdj a
           where a.aqpa190beval = ln_eva
             and a.aqpa190bcod = 564;
        exception
          when others then
            null;
        end;
        --Pasivo
        begin
          select a.aqpa190bmto
            into ln_PasivoS
            from aqpa190b_bdj a
           where a.aqpa190beval = ln_eva
             and a.aqpa190bcod = 65;
        exception
          when others then
            null;
        end;
      
        begin
          select a.aqpa190bmto
            into ln_PasivoD
            from aqpa190b_bdj a
           where a.aqpa190beval = ln_eva
             and a.aqpa190bcod = 565;
        exception
          when others then
            null;
        end;
      
        --Patrimonio
        begin
          select a.aqpa190bmto
            into ln_PatrimS
            from aqpa190b_bdj a
           where a.aqpa190beval = ln_eva
             and a.aqpa190bcod = 70;
        exception
          when others then
            null;
        end;
      
        begin
          select a.aqpa190bmto
            into ln_PatrimD
            from aqpa190b_bdj a
           where a.aqpa190beval = ln_eva
             and a.aqpa190bcod = 570;
        exception
          when others then
            null;
        end;
      
        --Pasivo Patrimonio
        begin
          select a.aqpa190bmto
            into ln_PsPatrimS
            from aqpa190b_bdj a
           where a.aqpa190beval = ln_eva
             and a.aqpa190bcod = 71;
        exception
          when others then
            null;
        end;
      
        begin
          select a.aqpa190bmto
            into ln_PsPatrimD
            from aqpa190b_bdj a
           where a.aqpa190beval = ln_eva
             and a.aqpa190bcod = 571;
        exception
          when others then
            null;
        end;
      
        --Ventas
        begin
          select a.aqpa190bmto
            into ln_ventasS
            from aqpa190b_bdj a
           where a.aqpa190beval = ln_eva
             and a.aqpa190bcod = 73;
        exception
          when others then
            null;
        end;
      
        begin
          select a.aqpa190bmto
            into ln_ventasD
            from aqpa190b_bdj a
           where a.aqpa190beval = ln_eva
             and a.aqpa190bcod = 573;
        exception
          when others then
            null;
        end;
      
        --Utilidad Bruta
        begin
          select a.aqpa190bmto
            into ln_utilBrutaS
            from aqpa190b_bdj a
           where a.aqpa190beval = ln_eva
             and a.aqpa190bcod = 75;
        exception
          when others then
            null;
        end;
      
        begin
          select a.aqpa190bmto
            into ln_utilBrutaD
            from aqpa190b_bdj a
           where a.aqpa190beval = ln_eva
             and a.aqpa190bcod = 575;
        exception
          when others then
            null;
        end;
      
        --Utilidad Neta
        begin
          select a.aqpa190bmto
            into ln_utilNetaS
            from aqpa190b_bdj a
           where a.aqpa190beval = ln_eva
             and a.aqpa190bcod = 84;
        exception
          when others then
            null;
        end;
      
        begin
          select a.aqpa190bmto
            into ln_utilNetaD
            from aqpa190b_bdj a
           where a.aqpa190beval = ln_eva
             and a.aqpa190bcod = 584;
        exception
          when others then
            null;
        end;
      
        --Gasto Familiar
        begin
          select a.aqpa190bmto
            into ln_gasFamS
            from aqpa190b_bdj a
           where a.aqpa190beval = ln_eva
             and a.aqpa190bcod = 54;
        exception
          when others then
            null;
        end;
      
        begin
          select a.aqpa190bmto
            into ln_gasFamD
            from aqpa190b_bdj a
           where a.aqpa190beval = ln_eva
             and a.aqpa190bcod = 554;
        exception
          when others then
            null;
        end;
      
        --Resultado Neto
        begin
          select a.aqpa190bmto
            into ln_resulNetoS
            from aqpa190b_bdj a
           where a.aqpa190beval = ln_eva
             and a.aqpa190bcod = 40;
        exception
          when others then
            null;
        end;
      
        begin
          select a.aqpa190bmto
            into ln_resulNetoD
            from aqpa190b_bdj a
           where a.aqpa190beval = ln_eva
             and a.aqpa190bcod = 540;
        exception
          when others then
            null;
        end;
      
        --Gasto Financiero
        begin
          select a.aqpa190bmto
            into ln_gastoFinanS
            from aqpa190b_bdj a
           where a.aqpa190beval = ln_eva
             and a.aqpa190bcod = 79;
        exception
          when others then
            null;
        end;
      
        begin
          select a.aqpa190bmto
            into ln_gastoFinanD
            from aqpa190b_bdj a
           where a.aqpa190beval = ln_eva
             and a.aqpa190bcod = 579;
        exception
          when others then
            null;
        end;
      
        pn_ActCorr    := ln_ActCorrS + (ln_ActCorrD / ln_tipcambio);
        pn_ActNoCorr  := ln_ActNoCorrS + (ln_ActNoCorrD / ln_tipcambio);
        pn_Activo     := ln_ActivoS + (ln_ActivoD / ln_tipcambio);
        pn_PasNoCorr  := ln_PasNoCorrS + (ln_PasNoCorrD / ln_tipcambio);
        pn_PasCorr    := Ln_PasCorrS + (Ln_PasCorrD / ln_tipcambio);
        pn_Pasivo     := ln_PasivoS + (ln_PasivoD / ln_tipcambio);
        pn_Patrim     := ln_PatrimS + (ln_PatrimD / ln_tipcambio);
        pn_PsPatrim   := ln_PsPatrimS + (ln_PsPatrimD / ln_tipcambio);
        pn_ventas     := ln_ventasS + (ln_ventasD / ln_tipcambio);
        pn_utilBruta  := ln_utilBrutaS + (ln_utilBrutaD / ln_tipcambio);
        pn_utilNeta   := ln_utilNetaS + (ln_utilNetaD / ln_tipcambio);
        pn_gasFam     := ln_gasFamS + (ln_gasFamD / ln_tipcambio);
        pn_resulNeto  := ln_resulNetoS + (ln_resulNetoD / ln_tipcambio);
        pn_gastoFinan := ln_gastoFinanS + (ln_gastoFinanD / ln_tipcambio);
      
        --actividad economica
      
        begin
          select xx.actnom1
            into pc_act
            from sngc60 aa, fst750 xx
           where aa.sngc60pais = pn_pai
             and aa.sngc60tdoc = pn_tdo
             and aa.sngc60ndoc = pc_ndo
             and aa.sngc60corr = 0
             and aa.sngc60acte = xx.actcod1;
        exception
          when no_data_found then
            begin
            
              select xxx.actnom1
                into pc_act
                from sngc11 cc, fst750 xxx
               where cc.sngc11pais = pn_pai
                 and cc.sngc11tdoc = pn_tdo
                 and cc.sngc11ndoc = pc_ndo
                 and cc.sngc11act2 = xxx.actcod1;
            exception
              when no_data_found then
                begin
                
                  select xxx.actnom1
                    into pc_act
                    from fse001 cc, fst750 xxx
                   where cc.d511pais = pn_pai
                     and cc.d511tdoc = pn_tdo
                     and cc.d511ndoc = pc_ndo
                     and cc.expnins = xxx.actcod1;
                exception
                  when others then
                    pc_act := null;
                end;
            end;
          
          when others then
            pc_act := null;
        end;
      
      end if;
    end if;
  
    pc_err := lc_err;
  
  end Sp_evaluacion;

  Procedure Sp_evaluacionCons(pn_pai      in number,
                              pn_tdo      in number,
                              pc_ndo      in char,
                              pd_Fecpro   in date,
                              pd_FecBI    in date,
                              pn_cor      in number,
                              pc_err      out char,
                              pn_IngBruto out number,
                              pn_IngNeto  out number,
                              pn_gasFam   out number,
                              pn_gasFin   out number,
                              pn_excMens  out number) is
  
    ln_eva       number(10);
    ln_moe       number(4);
    lc_err       char(100);
    ln_tipcambio number(15, 8);
    ln_IngBrutoS number(17, 2);
    ln_IngBrutoD number(17, 2);
    ln_IngNetoS  number(17, 2);
    ln_IngNetoD  number(17, 2);
    ln_gasFamS   number(17, 2);
    ln_gasFamD   number(17, 2);
    --ln_gasFinS   number(17, 2);
    --ln_gasFinD   number(17, 2);
    ln_excMensS number(17, 2);
    ln_excMensD number(17, 2);
  
  begin
  
    /*pq_cr_apl_flujoOnline.Sp_ultima_eva_Consul(pn_pai,
    pn_tdo,
    pc_ndo,
    lc_err,
    ln_eva,
    ln_moe);*/
    pq_cr_modulo_campanias.Sp_cr_tipocambio(pd_Fecpro, ln_tipcambio);
  
    begin
      select a.jaqz697moe, a.jaqz697eva
        into ln_moe, ln_eva
        from jaqz697 a
       where a.jaqz697fep = pd_FecBI
         and a.jaqz697cor = pn_cor
         and a.jaqz697pai = pn_pai
         and a.jaqz697tdo = pn_tdo
         and a.jaqz697ndo = pc_ndo;
    exception
      when too_many_rows then
        begin
          select a.jaqz697moe, a.jaqz697eva
            into ln_moe, ln_eva
            from jaqz697 a
           where a.jaqz697fep = pd_FecBI
             and a.jaqz697cor = pn_cor
             and a.jaqz697pai = pn_pai
             and a.jaqz697tdo = pn_tdo
             and a.jaqz697ndo = pc_ndo
             and rownum = 1;
        exception
        
          when others then
            null;
        end;
      when others then
        null;
    end;
  
    if lc_err is null then
      if ln_moe = 13 then
        lc_err := 'La ultima evaluacion del cliente es modelo independiente';
      else
        --Ingreso bruto
        begin
          select SUM(a.aqpa190bmto)
            into ln_IngBrutoS
            from aqpa190b_bdj a
           where a.aqpa190beval = ln_eva
             and a.aqpa190bcod in (1, 2, 3, 4, 9, 10, 11, 12);
        exception
          when others then
            null;
        end;
      
        begin
          select SUM(a.aqpa190bmto)
            into ln_IngBrutoD
            from aqpa190b_bdj a
           where a.aqpa190beval = ln_eva
             and a.aqpa190bcod in (501, 502, 503, 504, 509, 510, 511, 512);
        exception
          when others then
            null;
        end;
      
        --Ingreso neto
        begin
          select SUM(a.aqpa190bmto)
            into ln_IngNetoS
            from aqpa190b_bdj a
           where a.aqpa190beval = ln_eva
             and a.aqpa190bcod in (5, 6, 7, 8);
        exception
          when others then
            null;
        end;
      
        begin
          select SUM(a.aqpa190bmto)
            into ln_IngNetoD
            from aqpa190b_bdj a
           where a.aqpa190beval = ln_eva
             and a.aqpa190bcod in (505, 506, 507, 508);
        exception
          when others then
            null;
        end;
      
        --Gasto Familiar
      
        begin
          select SUM(a.aqpa190bmto)
            into ln_gasFamS
            from aqpa190b_bdj a
           where a.aqpa190beval = ln_eva
             and a.aqpa190bcod in (13, 14, 15, 16, 17, 18, 19, 20);
        exception
          when others then
            null;
        end;
      
        begin
          select sum(a.aqpa190bmto)
            into ln_gasFamD
            from aqpa190b_bdj a
           where a.aqpa190beval = ln_eva
             and a.aqpa190bcod in (513, 514, 515, 516, 517, 518, 519, 520);
        exception
          when others then
            null;
        end;
      
        --Gasto financiero
        pq_cr_modulo_campanias.Sp_gasto_Financi(pn_eva => ln_eva,
                                                pn_mto => pn_gasFin);
        /*begin
          select SUM(a.aqpa190bmto)
            into ln_gasFinS
            from aqpa190b_bdj a
           where a.aqpa190beval = ln_eva
             and a.aqpa190bcod = 19;
        exception
          when others then
            null;
        end;
        
        begin
          select SUM(a.aqpa190bmto)
            into ln_gasFinD
            from aqpa190b_bdj a
           where a.aqpa190beval = ln_eva
             and a.aqpa190bcod = 519;
        exception
          when others then
            null;
        end;*/
      
        --Excedente mensual
        begin
          select SUM(a.aqpa190bmto)
            into ln_excMensS
            from aqpa190b_bdj a
           where a.aqpa190beval = ln_eva
             and a.aqpa190bcod = 27;
        exception
          when others then
            null;
        end;
      
        begin
          select SUM(a.aqpa190bmto)
            into ln_excMensD
            from aqpa190b_bdj a
           where a.aqpa190beval = ln_eva
             and a.aqpa190bcod = 527;
        exception
          when others then
            null;
        end;
      
        pn_IngBruto := ln_IngBrutoS + (ln_IngBrutoD / ln_tipcambio);
        pn_IngNeto  := pn_IngBruto -
                       (ln_IngNetoS + (ln_IngNetoD / ln_tipcambio));
        pn_gasFam   := ln_gasFamS + (ln_gasFamD / ln_tipcambio);
        --pn_gasFin   := ln_gasFinS + (ln_gasFinD / ln_tipcambio);
        pn_excMens := ln_excMensS + (ln_excMensD / ln_tipcambio);
      
      end if;
    end if;
  
    pc_err := lc_err;
  
  end Sp_evaluacionCons;

  Procedure Sp_ultima_eva_Consul(pn_pai  in number,
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
  
  end Sp_ultima_eva_Consul;

  Procedure Sp_aprobar(pd_Fec in date, pn_cor in number, pc_res in char) is
    ln_ins number(10);
    ln_id  number(10);
  begin
  
    update jaqz697 a
       set a.jaqz697apr = pc_res
     where a.jaqz697fep = pd_Fec
       and a.jaqz697cor = pn_cor
       and a.jaqz697tca = 'P';
  
    commit;
  
    if pc_res = 'R' then
      Begin
      
        select a.jaqm750ins
          into ln_ins
          from jaqm750 a, jaqz697 b
         where b.jaqz697fep = pd_Fec
           and b.jaqz697cor = pn_cor
           and a.jaqm750pai = b.jaqz697pai
           and a.jaqm750tdo = b.jaqz697tdo
           and a.jaqm750ndo = b.jaqz697ndo
           and a.jaqm750fch >= b.jaqz697fep
           and a.jaqm750imp = b.jaqz697mto
           and b.jaqz697au5 = 'S'
           and a.jaqm750mod = b.jaqz697mod
           and a.jaqm750tip = b.jaqz697top
           and a.jaqm750suc = b.jaqz697suc
           and a.jaqm750mda = b.jaqz697mda;
      exception
        when others then
          null;
      end;
    
      begin
        select a.wfitemid
          into ln_id
          from wfwrkitems a
         where a.wfinsprcid = ln_ins
           and a.wfitemstsact = 1;
      exception
        when others then
          null;
      end;
    
      delete from wfworklist c where c.wfwrklstitemid = ln_id;
    
      commit;
      update wfwrkitems a
         set WFStsCod = 'B', WFItemStsAct = 0, WFItemEnd = sysdate
       where a.wfinsprcid = ln_ins
         and a.wfitemstsact = 1;
    
      commit;
    
      update wfinstprc b
         set WFInsPrcSta = 'B', WFInsPrcOSta = 0, WFInsPrcEnd = sysdate
       where b.wfinsprcid = ln_ins;
    
      commit;
    end if;
  end Sp_aprobar;

  --***********************************************************
  Procedure Sp_valida_FlujoReducido(pn_pai      in number,
                                    pn_tdo      in number,
                                    pc_ndo      in char,
                                    pn_cor      in number,
                                    pd_fec      in date,
                                    pn_mto      in number,
                                    pn_cta      in number,
                                    pn_cuo      in number,
                                    pn_pzo      in number,
                                    pn_suc      in number,
                                    pc_ase      in varchar2,
                                    pn_moe      in number,
                                    pd_Fecpro   in date,
                                    pd_FecPrim  in date,
                                    pc_flag     in char,
                                    pn_mtoCuo   out number,
                                    pn_CuotaCal out number,
                                    pc_err      out varchar2) is
  
    --ln_eva        number(10);
    ln_mtoCuota   number(17, 2);
    lc_error      varchar2(200);
    ln_EvaUlt     number(10);
    ln_moe        number(4);
    ln_tipcambio  number(15, 8);
    ln_CuotaCal   number(17, 2);
    ln_empA       number(3);
    ln_modA       number(3);
    ln_sucA       number(3);
    ln_mdaA       number(4);
    ln_papA       number(4);
    ln_ctaA       number(9);
    ln_opeA       number(9);
    ln_sboA       number(3);
    ln_topA       number(3);
    lc_credVigt   char(1);
    lc_Mora       char(1);
    lc_cr         char(1);
    lc_flgAmp     varchar2(30);
    ln_deuda      number(17, 2);
    ln_mtoPro     number(17, 2);
    ln_mod        number(3);
    ln_top        number(3);
    ln_mda        number(3);
    ln_plazo      number(17);
    ln_pzoCal     number(5);
    lc_act        char(1);
    ld_fecPrimPag date;
    ln_gracia     number(5);
    ld_FecSis     date;
    ln_pazoIni    number(5);
    ln_cuoIni     number(10);
    ln_ind        char(1);
    ln_cuotaIni   number(17, 2);
    lc_reactiva   char(1) := 'N'; --mod@abr 20200623
    ln_mesCont    number(10);
    ln_pzoCtrl    number(5);
    ln_quiebre    number(5);
    ln_diasF      number(5);
    ln_cuotaQui   number(17, 2);
    ln_tasa       number(10, 6);
    ln_tasaCtrl   number(10);
    ln_tasaOri    number(10, 6);
    ln_cta        number(9);
    lc_des        char(30);
    ln_tasaVis    number(10, 6);
  
    ln_evn       number(10); --mod@abr 20210617
    ld_fecpriCal date; --mod@abr 20210617
  
    lv_Tip varchar2(30); -- efuentes 20211207
  begin
  
    begin
      select a.pgfape into ld_FecSis from fst017 a where a.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    --tasa
    Pq_Cr_Modulo_Campanias.Sp_Cr_tasa(pd_fec    => pd_fec,
                                      pn_cor    => pn_cor,
                                      pd_fecpro => ld_FecSis,
                                      pn_tas    => ln_tasa);
  
    Pq_Cr_Modulo_Campanias.sp_cr_tasa_cta(pd_fec    => pd_fec,
                                          pn_cor    => pn_cor,
                                          pd_fecpro => ld_FecSis,
                                          pn_cta    => pn_cta,
                                          pn_tas    => ln_tasaOri);
  
    Pq_Cr_Modulo_Campanias.Sp_CalculaCuota(pn_cor     => pn_cor,
                                           pd_fec     => pd_fec,
                                           pn_mto     => pn_mto,
                                           pn_cuo     => pn_cuo,
                                           pn_fre     => pn_pzo,
                                           pn_suc     => pn_suc,
                                           pd_fecprim => pd_fecprim,
                                           pc_flag    => pc_flag,
                                           pn_cta     => pn_cta,
                                           pn_mtocuo  => ln_mtoCuota,
                                           pn_tasa    => ln_tasaVis);
    pn_mtoCuo := ln_mtoCuota;
    /* --efuente 20211207
    Pq_Cr_Modulo_Campanias.Sp_ultima_eva(pn_pai  => pn_pai,
                                         pn_tdo  => pn_tdo,
                                         pc_ndo  => pc_ndo,
                                         p_error => lc_error,
                                         pn_eva  => ln_EvaUlt,
                                         pn_moe  => ln_moe);
    --efuente 20211207 */
    begin
      select a.jaqz697mto,
             a.jaqz697mod,
             a.jaqz697top,
             a.jaqz697mda,
             a.jaqz697act,
             a.jaqz697pzo,
             a.jaqz697cuo,
             a.jaqz697moe,
             a.jaqz697eva,
             a.jaqz697cta,
             a.jaqz697des,
             a.jaqz697evn, -- mod@abr 20210617
             a.JAQZ697TIP -- efuentes 20211207
        into ln_mtoPro,
             ln_mod,
             ln_top,
             ln_mda,
             lc_act,
             ln_pazoIni,
             ln_cuoIni,
             ln_moe,
             ln_EvaUlt,
             ln_cta,
             lc_des,
             ln_evn, --mod@abr 20210617
             lv_Tip --efuentes 20211207
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
  
    ld_fecpriCal := ld_FecSis + ln_pazoIni; --mod@abr 20210617 
  
    --es reactiva
    --mod@abr 20200623
    begin
      select 'S'
        into lc_reactiva
        from fst198 a
       where a.tp1cod = 1
         and a.TP1COD1 = 11141
         and a.tp1corr1 = 11
         and a.tp1corr2 = 1
         and a.tp1nro1 = ln_mod
         and a.tp1nro2 = ln_top;
    exception
      when others then
        null;
    end;
    --mod@abr 20200623
  
    begin
      select a.tp1nro1
        into ln_quiebre
        from fst198 a
       where a.tp1cod = 1
         and a.TP1COD1 = 11141
         and a.tp1corr1 = 12
         and a.tp1corr2 = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select a.tp1nro1
        into ln_tasaCtrl
        from fst198 a
       where a.tp1cod = 1
         and a.TP1COD1 = 11141
         and a.tp1corr1 = 12
         and a.tp1corr2 = 3;
    exception
      when others then
        null;
    end;
  
    --mod@abr 20210617 
    if ld_fecpriCal <> pd_FecPrim and lc_error is null and ln_moe = 13 and
       ln_mod = 117 then
      lc_error := 'No puede modificar la fecha de primer pago para esta oferta';
    end if;
  
    if ln_cuoIni <> pn_cuo and lc_error is null and ln_moe = 13 and
       ln_mod = 117 then
      lc_error := 'No puede modificar el numero de cuotas para esta oferta';
    end if;
    /* --efuentes 20211207
    if pn_mto >=999999 and lc_error is null and ln_moe = 13 then
      lc_error := 'Propuestas con 999999 deben ser procesados por flujo reducido';
    end if;
    
    if ln_evn = 1 and lc_error is null and ln_moe = 13 then
      lc_error := 'Propuestas con 999999 deben ser procesados por flujo reducido';
    end if;
    */
    --mod@abr 20210617
  
    if pn_cta <> ln_cta and lc_error is null and lc_reactiva = 'N' and
       trim(lc_des) <> 'ADICIONAL' and ln_moe = 13 then
      lc_error := 'No puede modificar la cuenta para esta oferta';
    end if;
  
    if (ln_tasa >= ln_tasaCtrl or ln_tasaOri >= ln_tasaCtrl) and
       lc_error is null then
      lc_error := 'La oferta no tiene tasa asociada';
    end if;
  
    if pn_pzo <> 30 and lc_reactiva = 'S' and lc_error is null then
      lc_error := 'No puede escoger una frecuencia diferente a la mensual';
    end if;
  
    if pn_pzo <> 30 and lc_reactiva = 'N' and ln_moe = 13 and
       lc_error is null then
      lc_error := 'La frecuencia de pago debe ser mensual';
    end if; --mpostigoc 03.02.21
  
    if pn_mto < 500 and lc_error is null then
      lc_error := 'El monto ingresado es menor al permitido';
    end if;
  
    if pd_FecPrim < ld_FecSis and lc_error is null then
      lc_error := 'La fecha de primer pago no puede ser menor a la fecha del sistema';
    end if;
  
    if pn_cuo < 1 and lc_error is null then
      lc_error := 'El numero de cuotas es menor al minimo permitido';
    end if;
  
    /* --efuentes 20211207
    if pn_moe <> ln_moe and lc_error is null then
      lc_error := 'El segmento del cliente no coincide con el modelo de evaluacion';
    end if;
    */
    ln_ind := 'N';
  
    --calculo cuota datos iniciales
    Pq_Cr_Modulo_Campanias.Sp_CalculaCuota(pn_cor     => pn_cor,
                                           pd_fec     => pd_fec,
                                           pn_mto     => ln_mtoPro,
                                           pn_cuo     => ln_cuoIni,
                                           pn_fre     => ln_pazoIni,
                                           pn_suc     => pn_suc,
                                           pd_fecprim => pd_fecprim,
                                           pc_flag    => ln_ind,
                                           pn_cta     => ln_cta,
                                           pn_mtocuo  => ln_cuotaIni,
                                           pn_tasa    => ln_tasaVis);
  
    ln_diasF := (pd_FecPrim - ld_FecSis) - pn_pzo;
  
    if ln_diasF <= ln_quiebre then
      ln_cuotaQui := (ln_cuotaIni / 0.7) * 0.8;
    end if;
  
    if lc_error is null then
      if ln_mtoCuota > ln_cuotaIni and nvl(lc_reactiva, 'N') = 'N' and
         ln_evn <> 1 then
        lc_error := 'La cuota supera la cuota propuesta';
      end if;
    end if;
  
    if pn_mto > ln_mtoPro and lc_error is null then
      lc_error := 'No es permitido un monto mayor al propuesto';
    end if;
  
    if lc_error is null then
      begin
        select a.tp1nro1
          into ln_gracia
          from fst198 a
         where a.tp1cod = 1
           and a.tp1cod1 = 10899
           and a.tp1corr1 = 44444
           and a.tp1corr2 = 3
           and a.tp1desc = lc_act;
      exception
        when others then
          null;
      end;
    
      ld_fecPrimPag := ld_FecSis + ln_gracia + pn_pzo;
    
      if pd_FecPrim > ld_fecPrimPag then
        lc_error := 'La fecha de primer pago es mayor a la maxima permitida';
      end if;
    end if;
  
    If lc_error is null then
      If pn_moe = 14 then
        begin
          select Pp028MaxN
            into ln_plazo
            from fpp028
           Where Pp017Par = 103
             and Pp028Mod = ln_mod
             and Pp028Top = ln_top
             and Pp028Mda = ln_mda;
        exception
          when others then
            null;
        end;
      
        If pn_cuo > ln_plazo then
          lc_error := 'El numero de cuotas supera el plazo maximo';
        end if;
      
      Else
      
        ln_pzoCal := pn_cuo * pn_pzo;
      
        begin
          select Pp028MaxN
            into ln_plazo
            from fpp028
           Where Pp017Par = 113
             and Pp028Mod = ln_mod
             and Pp028Top = ln_top
             and Pp028Mda = ln_mda;
        exception
          when others then
            null;
        end;
      
        If ln_pzoCal > ln_plazo and ln_mod <> 105 then
          -- mpostigoc 05.01.2021
          lc_error := 'Supera el plazo maximo';
        end if;
      
      End If;
    end if;
  
    if lc_error is null then
    
      pq_cr_modulo_campanias.sp_meses(ld_FecSis, pd_FecPrim, ln_mesCont);
    
      if ln_mod = 105 then
        -- mpostigoc 05.01.2021
      
        pq_cr_modulo_campanias.sp_cr_plazoparalelo(pn_mda => ln_mda,
                                                   pn_mod => ln_mod,
                                                   pn_top => ln_top,
                                                   pn_pzo => ln_plazo);
      
        if (pn_cuo <= 6 and pn_pzo = 30 and ln_mesCont = 1) or
           (pn_cuo <= 3 and pn_pzo = 60 and ln_mesCont <= 2) or
           (pn_cuo <= 2 and pn_pzo = 90 and ln_mesCont <= 3) or
           (pn_cuo = 1 and pn_pzo = 180 and ln_mesCont <= 6) then
          --mpostigoc 05.01.2021
        
          ln_mesCont := 0;
        end if;
      end if;
    
      ln_pzoCtrl := (ln_mesCont + pn_cuo) * pn_pzo;
    
      If ln_pzoCtrl > ln_plazo and /*lc_reactiva = 'S'*/
         pn_moe = 13 then
        lc_error := 'El plazo mas la gracia supera el maximo permitido';
      end if;
    
    end if;
  
    if lc_error is null then
      --valida ampliados
      begin
        select a.jaqz697tip,
               1,
               a.jaqz697moa,
               a.jaqz697sua,
               a.jaqz697maa,
               a.jaqz697paa,
               a.jaqz697caa,
               a.jaqz697opa,
               a.jaqz697sba,
               a.jaqz697toa
          into lc_flgAmp,
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
         where a.jaqz697pai = pn_pai
           and a.jaqz697tdo = pn_tdo
           and a.jaqz697ndo = pc_ndo
           and a.jaqz697cor = pn_cor
           and a.jaqz697fep = pd_fec;
      exception
        when others then
          null;
      end;
    
      if trim(lc_flgAmp) = 'A' then
        pq_cr_modulo_campanias.sp_validac_ampliado(pn_emp    => ln_empA,
                                                   pn_mod    => ln_modA,
                                                   pn_suc    => ln_sucA,
                                                   pn_mda    => ln_mdaA,
                                                   pn_pap    => ln_papA,
                                                   pn_cta    => ln_ctaA,
                                                   pn_ope    => ln_opeA,
                                                   pn_sbo    => ln_sboA,
                                                   pn_top    => ln_topA,
                                                   pd_Fecpro => pd_Fecpro,
                                                   pc_flg    => lc_credVigt,
                                                   pc_flgM   => lc_Mora,
                                                   pc_flgVC  => lc_cr);
      
        pq_cr_apl_flujoOnline.sp_deudaAmpliado(pn_emp => ln_empA,
                                               pn_mod => ln_modA,
                                               pn_suc => ln_sucA,
                                               pn_mda => ln_mdaA,
                                               pn_pap => ln_papA,
                                               pn_cta => ln_ctaA,
                                               pn_ope => ln_opeA,
                                               pn_sbo => ln_sboA,
                                               pn_top => ln_topA,
                                               pn_mto => ln_deuda);
        If lc_credVigt = 'N' then
          lc_error := 'El credito a ampliar no esta vigente.';
        Else
          If pn_mto > ln_deuda then
            lc_error := 'El monto de deuda es mayor al monto ingresado.';
          end if;
        End If;
      
      end if;
    
    end if;
  
    if lc_error is null then
      pq_cr_modulo_campanias.Sp_cr_tipocambio(pd_Fecpro, ln_tipcambio);
    
      pn_CuotaCal := ln_mtoCuota;
    
    end if;
  
    /* if lc_error is null then
      if ln_mtoCuota > ln_CuotaCal and nvl(lc_reactiva, 'N') = 'N' then
        lc_error := 'La cuota supera el maximo permitido';
      end if;
    end if;*/
    pc_err := lc_error;
  end Sp_valida_FlujoReducido;

  --***********************************************************
  Procedure Sp_Proceso_flujoReducido_2(pn_pai    in number,
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
                                       pd_FecPri in date) is
  
    lc_flgAmpl char(30) := 'N'; --mod@abr 20200129
    ln_mod     number(3);
    ln_suc     number(3);
    ln_mda     number(4);
    ln_pap     number(4);
    ln_cta     number(9);
    ln_ope     number(9);
    ln_sbo     number(3);
    ln_top     number(3);
  
    lc_reactiva char(1) := 'N'; --mod@abr 20200623
    --0 se ejecuta proceso de fintech
    --1 se ejecuta proceso de flujo online
  
    lv_FlagProcc  varchar(1) := 'N';
    ln_Ctnro_tip  number(9);
    lv_FlgCta     varchar(1);
    ln_CuotaCaja  number(17, 2);
    ln_RatioConsu number(17, 2);
    ln_ModEva     number(4);
    ld_jaqz697fep date;
    ln_NroCuo     number(5);
    ln_MntPreApro number(17, 2);
    ln_plazo      number(5);
    ld_FecPrim    date;
    lv_IndGra     varchar2(2);
    lc_error      varchar2(500);
    ln_Deuda      number(18, 2);
    ln_evaAct     number(10);
  
    my_errm VARCHAR2(32000);
  
    ln_jaqz697suc    number(5);
    ln_Aotasa_mod    number(17, 2);
    ln_dias_Grac     number(10);
    ln_GracQuiebre   number(10);
    ln_MtoCalcQuieb  number(17, 2);
    ln_Tp1nro1       number(10);
    ln_Tp1nro1_Pyme  number(10);
    ln_CuotaCal      number(17, 2);
    ln_nExcMen       number(17, 2);
    ln_ResultadoNeto number(18, 2);
    ln_jaqz697ase    varchar2(12);
    lv_ErrRatio      varchar2(1);
    ln_captotcaja    number(17, 2);
    ln_Saldo_externo number(18, 2);
    ln_resultneto    number(17, 2);
    ln_mntpotncial   number(17, 2);
    ln_mntcuocntg    number(17, 2);
    ln_ratiopyme     number(10, 6);
    lv_valida_ctrl   varchar2(1);
    ln_jaqz697mod    number(3);
    ln_MontoCuota    number(17, 2);
    ln_jaqz697top    number(10);
    ln_jaqz697mda    number(10);
    ln_SNGC60Ocup    number(5);
    ln_Segcod        number(5);
    lv_flgSegCorrec  varchar2(1);
    ln_sng021eval    number(10);
    ln_sng021tmod    number(5);
    lv_FlgEvaCorrec  varchar2(1);
    lv_Flag_credVigt varchar2(1);
    lv_Flag_Mora     varchar2(1);
    lv_flag_cr       varchar2(1);
    lv_VISdetalle    varchar2(1);
    lv_ENFrecuencia  varchar2(1);
    lv_ENCuenta      varchar2(1);
  
    ld_FECHAMax date; --viene como parametro verificar como llega 
    lv_TempEva  varchar2(1);
    cursor for_jaqz697eva(fecmax in date,
                          pais   in number,
                          tdoc   in number,
                          ndoc   in char) is
      select JAQZ697EVA NumEva
        from jaqz697
       Where JAQZ697FEP >= fecmax --&FECHAMax
         and JAQZ697PAI = pais
         and JAQZ697TDO = tdoc
         and JAQZ697NDO = ndoc;
  
    ln_jaqz697eva     number(10);
    lv_existeAQPA190B varchar2(1);
    ln_EvaActual      number(10);
    lv_ENmonto        varchar2(1);
    lv_ENnroCuo       varchar2(1);
    lv_ENFecpri       varchar2(1);
    ln_Cotcbi         number(15, 8);
    lv_ActEco         varchar2(60);
    ln_AQPA190BMTO    number(17, 2);
    ln_AQPA190BCOD    number(4);
  
    cursor for_aqpa190b(EvaluiacionAct in number) is
      select AQPA190BMTO ln_AQPA190BMTO, AQPA190BCOD ln_AQPA190BCOD
        from aqpa190b
       Where AQPA190BEVAL = ln_evaAct;
  
    ln_TempTp1nro1       number(10);
    ln_AQPA190BMTOingsol number(17, 2);
    ln_AQPA190BMTOingdol number(17, 2);
    ln_AQPA190BMTObrusol number(17, 2);
    ln_AQPA190BMTObrudol number(17, 2);
    ln_AQPA190BMTOgfasol number(17, 2);
    ln_AQPA190BMTOgfadol number(17, 2);
    ln_AQPA190BMTOexcsol number(17, 2);
    ln_AQPA190BMTOexcdol number(17, 2);
    ln_GastoFinaC        number(17, 2);
    ln_nIngBruto         number(17, 2);
    ln_nIngNeto          number(17, 2);
    ln_nGasFam           number(17, 2);
    ln_SNG026Cod         number(5);
  
    ln_TotActCorrSOL    number(18, 2);
    ln_TotActCorrDOL    number(18, 2);
    ln_TotActNoCorrSOL  number(18, 2);
    ln_TotActNoCorrDOL  number(18, 2);
    ln_TotActivoSOL     number(18, 2);
    ln_TotActivoDOL     number(18, 2);
    ln_TotPasCorrSOL    number(18, 2);
    ln_TotPasCorrDOL    number(18, 2);
    ln_TotPasNoCorrSOL  number(18, 2);
    ln_TotPasNoCorrDOL  number(18, 2);
    ln_TotPasivoSOL     number(18, 2);
    ln_TotPasivoDOL     number(18, 2);
    ln_TotPatrimonioSOL number(18, 2);
    ln_TotPatrimonioDOL number(18, 2);
    ln_TotPasPatriSOL   number(18, 2);
    ln_TotPasPatriDOL   number(18, 2);
    ln_VentasSOL        number(18, 2);
    ln_VentasDOL        number(18, 2);
    ln_UtiliadaBrutaSOL number(18, 2);
    ln_UtiliadaBrutaDOL number(18, 2);
    ln_UtilidadNetaSOL  number(18, 2);
    ln_UtilidadNetaDOL  number(18, 2);
    ln_GastoFamSOL      number(18, 2);
    ln_GastoFamDOL      number(18, 2);
    ln_ResultadoNetoSOL number(18, 2);
    ln_ResultadoNetoDOL number(18, 2);
    ln_GastoFinaSOL     number(18, 2);
    ln_GastoFinaDOL     number(18, 2);
    ln_SNG001Inst       number(12);
    lv_lcProgram        varchar2(10);
    lv_userFin          varchar2(10);
  
    ln_TotActCorr    number(17, 2);
    ln_TotActNoCorr  number(17, 2);
    ln_TotActivo     number(17, 2);
    ln_TotPasCorr    number(17, 2);
    ln_TotPasNoCorr  number(17, 2);
    ln_TotPasivo     number(17, 2);
    ln_TotPatrimonio number(17, 2);
    ln_TotPasPatri   number(17, 2);
    ln_Ventas        number(17, 2);
    ln_UtiliadaBruta number(17, 2);
    ln_UtilidadNeta  number(17, 2);
    ln_GastoFam      number(17, 2);
    ln_GastoFina     number(17, 2);
    ln_SNG120TCbi    number(15, 8);
    ln_SaldoExtern   number(18, 2);
    ln_excedMensual  number(17, 2);
    lv_VISgradiente  varchar2(1);
    lv_VISRechazo    varchar2(1);
    lv_VISMotivo     varchar2(1);
    ln_JAQZ697EVN    number(10);
    lv_IndicaGrac    varchar2(1);
    lv_VISIngBruto   varchar2(1);
    lv_VISmodific    varchar2(1);
    lv_VISoferPropu  varchar2(1);
    ln_instance      number(10);
    lv_convenio      varchar2(1);
    lv_Vis_Info      varchar2(1);
    lv_VISMto        varchar2(1);
    lv_VISFrec       varchar2(1);
    lv_VISCuo        varchar2(1);
    lv_VISFecPri     varchar2(1);
    lv_VISIngNeto    varchar2(1);
    lv_VISGasFam     varchar2(1);
    lv_VISExcMens    varchar2(1);
    lv_VISGasFinaC   varchar2(1);
    lv_VISdeudaRCC   varchar2(1);
  
  begin
    lc_error       := null;
    lv_valida_ctrl := null;
    --obtener los datos de la propuesta
    begin
      select Distinct j.jaqz697tip,
                      j.jaqz697moa,
                      j.jaqz697sua,
                      j.jaqz697maa,
                      j.jaqz697paa,
                      j.jaqz697caa,
                      j.jaqz697opa,
                      j.jaqz697sba,
                      j.jaqz697toa,
                      j.jaqz697moe,
                      j.jaqz697fep,
                      j.jaqz697cuo,
                      j.jaqz697mto,
                      j.jaqz697pzo,
                      j.jaqz697eva,
                      j.jaqz697suc,
                      j.jaqz697ase,
                      j.jaqz697mod,
                      j.jaqz697top,
                      j.jaqz697mda,
                      j.jaqz697evn
        into lc_flgAmpl,
             ln_mod,
             ln_suc,
             ln_mda,
             ln_pap,
             ln_cta,
             ln_ope,
             ln_sbo,
             ln_top,
             ln_ModEva,
             ld_jaqz697fep,
             ln_NroCuo,
             ln_MntPreApro,
             ln_plazo,
             ln_evaAct,
             ln_jaqz697suc,
             ln_jaqz697ase,
             ln_jaqz697mod,
             ln_jaqz697top,
             ln_jaqz697mda,
             ln_JAQZ697EVN
        from jaqz697 j
       where j.jaqz697pai = pn_pai
         and j.jaqz697tdo = pn_tdo
         and j.jaqz697ndo = pc_ndo
         and j.jaqz697fep = pd_fec
         and j.jaqz697cor = pn_cor;
    exception
      when others then
        my_errm := SQLERRM;
        null;
    end;
  
    --INICIO 'Seleccionar'
    begin
      ld_FecPrim := pd_fecpro + ln_plazo;
    
      --verificar cuenta cliente **NO USAR
      begin
        select Ctnro
          into ln_Ctnro_tip
          from fsr008
         Where Pepais = pn_pai
           and Petdoc = pn_tdo
           and Pendoc = pc_ndo
           and Cttfir = 'T'
           and rownum = 1;
      
        pq_cr_modulo_campanias.sp_cr_VerificaCtnro(ln_Ctnro_tip, lv_FlgCta);
      exception
        when others then
          my_errm := SQLERRM;
          null;
      end;
    
      pq_cr_modulo_campanias.sp_cr_VerificaCtnro(ln_cta, lv_FlgCta);
    
      If ln_ModEva = 14 then
        select Tp1nro1
          into ln_plazo
          from FST198
         Where Tp1cod = 1
           and Tp1cod1 = 10899
           and Tp1corr1 = 99999
           and Tp1corr2 = 1
           and rownum = 1;
      Else
        select Pp028MaxN
          into ln_plazo
          from fpp028
         Where Pp017Par = 113
           and Pp028Mod = ln_jaqz697mod
           and Pp028Top = ln_jaqz697top
           and Pp028Mda = ln_jaqz697mda;
      End If;
    
      begin
        select Segcod
          into ln_Segcod
          from sngc60, sngc07
         Where SNGC60Pais = pn_pai
           and SNGC60Tdoc = pn_tdo
           and SNGC60Ndoc = pc_ndo
           and SNGC60Corr = 0
           and sngc07cod = SNGC60Ocup;
      exception
        when others then
          my_errm := SQLERRM;
          null;
      end;
    
      If ln_Segcod = 1 then
        If ln_ModEva = 13 then
          lv_flgSegCorrec := 'S';
        Else
          lv_flgSegCorrec := 'N';
        End If;
      End If;
    
      If ln_Segcod = 2 then
        If ln_ModEva = 14 then
          lv_flgSegCorrec := 'S';
        Else
          lv_flgSegCorrec := 'N';
        End If;
      End If;
    
      If ln_Segcod = 3 then
        lv_flgSegCorrec := 'N';
      End If;
    
      If lv_flgSegCorrec = 'N' then
        lc_error       := 'El segmento del cliente no coincide con el modelo de evaluacion';
        lv_valida_ctrl := 'S';
      Else
        ln_sng021eval := ln_evaAct;
        ln_sng021tmod := ln_ModEva;
      
        If lv_valida_ctrl is null then
          If ln_Segcod = 1 then
            If ln_sng021tmod = 13 then
              lv_FlgEvaCorrec := 'S';
            Else
              lv_FlgEvaCorrec := 'N';
            End If;
          End If;
          If ln_Segcod = 2 then
            If ln_sng021tmod = 14 then
              lv_FlgEvaCorrec := 'S';
            Else
              lv_FlgEvaCorrec := 'N';
            End If;
          End If;
          If lv_FlgEvaCorrec = 'N' then
            lc_error       := 'El segmento del cliente no coincide con el modelo de evaluacion';
            lv_valida_ctrl := 'S';
          End If;
        End If;
      End If;
    
      If lc_flgAmpl = 'A' then
        pq_cr_modulo_campanias.sp_validac_ampliado(1 --&Pgcod
                                                  ,
                                                   ln_mod --&JAQZ697MOAaux
                                                  ,
                                                   ln_suc --&JAQZ697SUAaux
                                                  ,
                                                   ln_mda --&JAQZ697MAAaux
                                                  ,
                                                   ln_pap --&JAQZ697PAAaux
                                                  ,
                                                   ln_cta --&JAQZ697CAAaux
                                                  ,
                                                   ln_ope --&JAQZ697OPAaux
                                                  ,
                                                   ln_sbo --&JAQZ697SBAaux
                                                  ,
                                                   ln_top --&JAQZ697TOAaux
                                                  ,
                                                   pd_fecpro --&Pgfape
                                                  ,
                                                   lv_Flag_credVigt,
                                                   lv_Flag_Mora,
                                                   lv_flag_cr);
      
        If lv_Flag_credVigt = 'N' then
          lc_error       := 'El credito a ampliar no esta vigente.';
          lv_valida_ctrl := 'S';
        Else
          If lv_flag_cr = 'S' then
            lc_error       := 'El cliente tiene cuotas irregulares.';
            lv_valida_ctrl := 'S';
          End If;
        End If;
      End If;
    
      If lv_valida_ctrl is not null then
        lc_error       := 'Mostrar error.';
        lv_valida_ctrl := 'S';
      Else
        lv_VISdetalle := '1';
        If ln_Segcod = 1 then
          lv_ENFrecuencia := '1';
          lv_ENCuenta     := '1';
        End If;
        If ln_Segcod = 2 then
          lv_ENFrecuencia := '0';
          lv_ENCuenta     := '0';
        End If;
      End If;
    
      begin
        ln_jaqz697eva := null;
        FOR i IN for_jaqz697eva(ld_FECHAMax, pn_pai, pn_tdo, pc_ndo) LOOP
          ln_jaqz697eva := i.NumEva;
          lv_TempEva    := 'N';
          If ln_jaqz697eva is not null then
            lv_TempEva := 'S';
          End If;
          EXIT WHEN lv_TempEva = 'S';
        END LOOP;
      
      exception
        when others then
          my_errm := SQLERRM;
          null;
      end;
    
      If lv_VISdetalle = '1' then
        --&numdoc1 = &Pendoc
        lv_existeAQPA190B := 'N';
        /*
        DESCOMENTAR
        begin
          select 'S' into lv_existeAQPA190B
          from aqpab190b
          Where AQPA190BEVAL = ln_evaAct;--&JAQZ697EVAAux
        exception
          when others then
            lv_existeAQPA190B := 'N';
            my_errm    := SQLERRM;
        end;
        */
      
        If lv_existeAQPA190B = 'N' then
          pq_cr_modulo_campanias.Sp_insert_bandeja3(pn_pai,
                                                    pn_tdo,
                                                    pc_ndo,
                                                    pn_cor --&JAQZ697CORAux
                                                   ,
                                                    pd_fec --&JAQZ697FEPAux
                                                   ,
                                                    ln_evaAct); --&JAQZ697EVAAux);
        
          pq_cr_modulo_campanias.Sp_cr_inserta_Aqpa190d(ln_evaAct); --&JAQZ697EVAAux)
        
          If ln_ModEva = 14 then
            pq_cr_modulo_campanias.Sp_Cr_aqpa190c(ln_evaAct);
          End If;
          --&EvaActual := &JAQZ697EVAAux;
          ln_EvaActual := ln_evaAct;
        Else
          --&EvaActual = &JAQZ697EVAAux
          ln_EvaActual := ln_evaAct;
        End If;
        --&EvaActual = &JAQZ697EVAAux   
        ln_EvaActual := ln_evaAct;
      End If;
    
      --es reactiva
      begin
        select 'S'
          into lc_reactiva
          from fst198 a
         where a.tp1cod = 1
           and a.TP1COD1 = 11141
           and a.tp1corr1 = 11
           and a.tp1corr2 = 1
           and a.tp1nro1 = ln_jaqz697mod
           and a.tp1nro2 = ln_jaqz697top;
      exception
        when others then
          lc_reactiva := 'N';
          my_errm     := SQLERRM;
          null;
      end;
    
      If lc_reactiva = 'S' then
        lv_ENmonto := '0';
      Else
        lv_ENmonto := '1';
      End If;
    
      If ln_jaqz697mod = 117 then
        lv_ENnroCuo := '0';
        lv_ENFecpri := '0';
      Else
        lv_ENnroCuo := '1';
        lv_ENFecpri := '1';
      End If;
    
    end;
    --FIN 'Seleccionar'
  
    --INICIO 'InformacionEvaluacion'
    begin
      pq_cr_modulo_campanias.Sp_cr_tipocambio(pd_fecpro --&Pgfape
                                             ,
                                              ln_Cotcbi);
    
      pq_cr_modulo_campanias.sp_actividadeconomica(pn_pai,
                                                   pn_tdo,
                                                   pc_ndo,
                                                   lv_ActEco);
    
      begin
        ln_AQPA190BMTOingsol := 0;
        ln_AQPA190BMTOingdol := 0;
        ln_AQPA190BMTObrusol := 0;
        ln_AQPA190BMTObrudol := 0;
        ln_AQPA190BMTOgfasol := 0;
        ln_AQPA190BMTOgfadol := 0;
        ln_AQPA190BMTOexcsol := 0;
        ln_AQPA190BMTOexcdol := 0;
        FOR j IN for_aqpa190b(ln_evaAct) LOOP
          ln_AQPA190BCOD := j.ln_AQPA190BCOD;
          ln_AQPA190BMTO := j.ln_AQPA190BMTO;
        
          begin
            --Ingreso bruto soles
            select Tp1nro1
              into ln_TempTp1nro1
              from fst198
             Where Tp1cod = 1
               and Tp1cod1 = 10899
               and Tp1corr1 = 99999
               and Tp1corr2 = 3;
          
            If ln_AQPA190BCOD = ln_TempTp1nro1 then
              ln_AQPA190BMTObrusol := ln_AQPA190BMTObrusol + ln_AQPA190BMTO;
            End If;
          exception
            when others then
              ln_AQPA190BMTObrusol := 0;
              my_errm              := SQLERRM;
              null;
          end;
        
          begin
            --Ingreso bruto dolares
            select Tp1nro1
              into ln_TempTp1nro1
              from fst198
             Where Tp1cod = 1
               and Tp1cod1 = 10899
               and Tp1corr1 = 99999
               and Tp1corr2 = 4;
          
            If ln_AQPA190BCOD = ln_TempTp1nro1 then
              ln_AQPA190BMTObrudol := ln_AQPA190BMTObrudol + ln_AQPA190BMTO;
            End If;
          
          exception
            when others then
              ln_AQPA190BMTObrudol := 0;
              my_errm              := SQLERRM;
              null;
          end;
        
          begin
            --Ingreso neto soles
            select Tp1nro1
              into ln_TempTp1nro1
              from fst198
             Where Tp1cod = 1
               and Tp1cod1 = 10899
               and Tp1corr1 = 99999
               and Tp1corr2 = 5;
          
            If ln_AQPA190BCOD = ln_TempTp1nro1 then
              ln_AQPA190BMTOingsol := ln_AQPA190BMTOingsol + ln_AQPA190BMTO;
            End If;
          exception
            when others then
              ln_AQPA190BMTOingsol := 0;
              my_errm              := SQLERRM;
              null;
          end;
        
          begin
            --Ingreso neto dolares
            select Tp1nro1
              into ln_TempTp1nro1
              from fst198
             Where Tp1cod = 1
               and Tp1cod1 = 10899
               and Tp1corr1 = 99999
               and Tp1corr2 = 6;
          
            If ln_AQPA190BCOD = ln_TempTp1nro1 then
              ln_AQPA190BMTOingdol := ln_AQPA190BMTOingdol + ln_AQPA190BMTO;
            End If;
          exception
            when others then
              ln_AQPA190BMTOingdol := 0;
              my_errm              := SQLERRM;
              null;
          end;
        
          begin
            --gasto familiar soles
            select Tp1nro1
              into ln_TempTp1nro1
              from fst198
             Where Tp1cod = 1
               and Tp1cod1 = 10899
               and Tp1corr1 = 99999
               and Tp1corr2 = 7;
          
            If ln_AQPA190BCOD = ln_TempTp1nro1 then
              ln_AQPA190BMTOgfasol := ln_AQPA190BMTOgfasol + ln_AQPA190BMTO;
            End If;
          
          exception
            when others then
              ln_AQPA190BMTOgfasol := 0;
              my_errm              := SQLERRM;
              null;
          end;
        
          begin
            --gasto familiar dolares
            select Tp1nro1
              into ln_TempTp1nro1
              from fst198
             Where Tp1cod = 1
               and Tp1cod1 = 10899
               and Tp1corr1 = 99999
               and Tp1corr2 = 8;
          
            If ln_AQPA190BCOD = ln_TempTp1nro1 then
              ln_AQPA190BMTOgfadol := ln_AQPA190BMTOgfadol + ln_AQPA190BMTO;
            End If;
          exception
            when others then
              ln_AQPA190BMTOgfadol := 0;
              my_errm              := SQLERRM;
              null;
          end;
        
          begin
            --excedente mensual soles
            select Tp1nro1
              into ln_TempTp1nro1
              from fst198
             Where Tp1cod = 1
               and Tp1cod1 = 10899
               and Tp1corr1 = 99999
               and Tp1corr2 = 9;
          
            If ln_AQPA190BCOD = ln_TempTp1nro1 then
              ln_AQPA190BMTOexcsol := ln_AQPA190BMTOexcsol + ln_AQPA190BMTO;
            End If;
          
          exception
            when others then
              ln_AQPA190BMTOexcsol := 0;
              my_errm              := SQLERRM;
              null;
          end;
        
          begin
            --excedente mensual soles
            select Tp1nro1
              into ln_TempTp1nro1
              from fst198
             Where Tp1cod = 1
               and Tp1cod1 = 10899
               and Tp1corr1 = 99999
               and Tp1corr2 = 10;
          
            If ln_AQPA190BCOD = ln_TempTp1nro1 then
              ln_AQPA190BMTOexcdol := ln_AQPA190BMTOexcdol + ln_AQPA190BMTO;
            End If;
          exception
            when others then
              ln_AQPA190BMTOexcdol := 0;
              my_errm              := SQLERRM;
              null;
          end;
        
        END LOOP;
      exception
        when others then
          my_errm := SQLERRM;
          null;
      end;
    
      pq_cr_modulo_campanias.sp_gasto_financi(ln_evaAct, ln_GastoFinaC);
    
      ln_nIngBruto := ln_AQPA190BMTObrusol +
                      (ln_AQPA190BMTObrudol * ln_Cotcbi);
      ln_nIngNeto  := ln_nIngBruto - (ln_AQPA190BMTOingsol +
                      (ln_AQPA190BMTOingdol * ln_Cotcbi));
      ln_nGasFam   := ln_AQPA190BMTOgfasol +
                      (ln_AQPA190BMTOgfadol * ln_Cotcbi);
      ln_nExcMen   := ln_AQPA190BMTOexcsol +
                      (ln_AQPA190BMTOexcdol * ln_Cotcbi);
    
      --cobertura consumo
      select Tp1nro1
        into ln_Tp1nro1
        from fst198
       Where Tp1cod = 1
         and Tp1cod1 = 10899
         and Tp1corr1 = 99999
         and Tp1corr2 = 2
         and Tp1corr3 = 1;
      --cobertura pyme
      select Tp1nro1
        into ln_Tp1nro1_Pyme
        from fst198
       Where Tp1cod = 1
         and Tp1cod1 = 10899
         and Tp1corr1 = 99999
         and Tp1corr2 = 11
         and Tp1corr3 = 1;
    
      If ln_ModEva = 13 then
        FOR k IN for_aqpa190b(ln_evaAct) LOOP
          ln_SNG026Cod := k.ln_AQPA190BCOD;
          If ln_SNG026Cod = 47 then
            ln_TotActCorrSOL := k.ln_AQPA190BMTO;
          End If;
          If ln_SNG026Cod = 547 then
            ln_TotActCorrDOL := k.ln_AQPA190BMTO;
          End If;
          If ln_SNG026Cod = 51 then
            ln_TotActNoCorrSOL := k.ln_AQPA190BMTO;
          End If;
          If ln_SNG026Cod = 551 then
            ln_TotActNoCorrDOL := k.ln_AQPA190BMTO;
          End If;
          If ln_SNG026Cod = 52 then
            ln_TotActivoSOL := k.ln_AQPA190BMTO;
          End If;
          If ln_SNG026Cod = 552 then
            ln_TotActivoDOL := k.ln_AQPA190BMTO;
          End If;
          If ln_SNG026Cod = 59 then
            ln_TotPasCorrSOL := k.ln_AQPA190BMTO;
          End If;
          If ln_SNG026Cod = 559 then
            ln_TotPasCorrDOL := k.ln_AQPA190BMTO;
          End If;
          If ln_SNG026Cod = 64 then
            ln_TotPasNoCorrSOL := k.ln_AQPA190BMTO;
          End If;
          If ln_SNG026Cod = 564 then
            ln_TotPasNoCorrDOL := k.ln_AQPA190BMTO;
          End If;
          If ln_SNG026Cod = 65 then
            ln_TotPasivoSOL := k.ln_AQPA190BMTO;
          End If;
          If ln_SNG026Cod = 565 then
            ln_TotPasivoDOL := k.ln_AQPA190BMTO;
          End If;
          If ln_SNG026Cod = 70 then
            ln_TotPatrimonioSOL := k.ln_AQPA190BMTO;
          End If;
          If ln_SNG026Cod = 570 then
            ln_TotPatrimonioDOL := k.ln_AQPA190BMTO;
          End If;
          If ln_SNG026Cod = 71 then
            ln_TotPasPatriSOL := k.ln_AQPA190BMTO;
          End If;
          If ln_SNG026Cod = 571 then
            ln_TotPasPatriDOL := k.ln_AQPA190BMTO;
          End If;
          If ln_SNG026Cod = 73 then
            ln_VentasSOL := k.ln_AQPA190BMTO;
          End If;
          If ln_SNG026Cod = 573 then
            ln_VentasDOL := k.ln_AQPA190BMTO;
          End If;
          If ln_SNG026Cod = 75 then
            ln_UtiliadaBrutaSOL := k.ln_AQPA190BMTO;
          End If;
          If ln_SNG026Cod = 575 then
            ln_UtiliadaBrutaDOL := k.ln_AQPA190BMTO;
          End If;
          If ln_SNG026Cod = 84 then
            ln_UtilidadNetaSOL := k.ln_AQPA190BMTO;
          End If;
          If ln_SNG026Cod = 584 then
            ln_UtilidadNetaDOL := k.ln_AQPA190BMTO;
          End If;
          If ln_SNG026Cod = 54 then
            ln_GastoFamSOL := k.ln_AQPA190BMTO;
          End If;
          If ln_SNG026Cod = 554 then
            ln_GastoFamDOL := k.ln_AQPA190BMTO;
          End If;
          If ln_SNG026Cod = 40 then
            ln_ResultadoNetoSOL := k.ln_AQPA190BMTO;
          End If;
          If ln_SNG026Cod = 540 then
            ln_ResultadoNetoDOL := k.ln_AQPA190BMTO;
          End If;
          If ln_SNG026Cod = 79 then
            ln_GastoFinaSOL := k.ln_AQPA190BMTO;
          End If;
          If ln_SNG026Cod = 579 then
            ln_GastoFinaDOL := k.ln_AQPA190BMTO;
          End If;
        END LOOP;
      
        ln_TotActCorr    := ln_TotActCorrSOL +
                            (ln_TotActCorrDOL / ln_Cotcbi);
        ln_TotActNoCorr  := ln_TotActNoCorrSOL +
                            (ln_TotActNoCorrDOL / ln_Cotcbi);
        ln_TotActivo     := ln_TotActivoSOL + (ln_TotActivoDOL / ln_Cotcbi);
        ln_TotPasCorr    := ln_TotPasCorrSOL +
                            (ln_TotPasCorrDOL / ln_Cotcbi);
        ln_TotPasNoCorr  := ln_TotPasNoCorrSOL +
                            (ln_TotPasNoCorrDOL / ln_Cotcbi);
        ln_TotPasivo     := ln_TotPasivoSOL + (ln_TotPasivoDOL / ln_Cotcbi);
        ln_TotPatrimonio := ln_TotPatrimonioSOL +
                            (ln_TotPatrimonioDOL / ln_Cotcbi);
        ln_TotPasPatri   := ln_TotPasPatriSOL +
                            (ln_TotPasPatriDOL / ln_Cotcbi);
        ln_Ventas        := ln_VentasSOL + (ln_VentasDOL / ln_Cotcbi);
        ln_UtiliadaBruta := ln_UtiliadaBrutaSOL +
                            (ln_UtiliadaBrutaDOL / ln_Cotcbi);
        ln_UtilidadNeta  := ln_UtilidadNetaSOL +
                            (ln_UtilidadNetaDOL / ln_Cotcbi);
        ln_GastoFam      := ln_GastoFamSOL + (ln_GastoFamDOL / ln_Cotcbi);
        ln_ResultadoNeto := ln_ResultadoNetoSOL +
                            (ln_ResultadoNetoDOL / ln_Cotcbi);
        ln_GastoFina     := ln_GastoFinaSOL + (ln_GastoFinaDOL / ln_Cotcbi);
      
        ln_CuotaCal   := (ln_ResultadoNeto * ln_Tp1nro1_Pyme) / 100;
        ln_SNG001Inst := 0;
        lv_lcProgram  := 'OTROS';
        lv_userFin    := ln_jaqz697ase;
      
        pq_cr_modulo_campanias.sp_CalculoRAtioPYME(pn_pai,
                                                   pn_tdo,
                                                   pc_ndo,
                                                   ln_SNG120TCbi,
                                                   ln_SNG001Inst,
                                                   pd_fecpro --&Pgfape
                                                  ,
                                                   lv_lcProgram,
                                                   lv_userFin,
                                                   ln_CuotaCaja --**
                                                  ,
                                                   ln_SaldoExtern,
                                                   ln_excedMensual,
                                                   ln_ratioConsu);
      
        ln_ResultadoNeto := ln_ResultadoNeto - ln_CuotaCaja;
      
      Else
        ln_CuotaCal   := (ln_nExcMen * ln_Tp1nro1) / 100;
        ln_SNG001Inst := 0;
        lv_lcProgram  := 'OTROS';
        lv_userFin    := ln_jaqz697ase;
        pq_cr_modulo_campanias.sp_calculoratio(pn_pai,
                                               pn_tdo,
                                               pc_ndo,
                                               ln_Cotcbi,
                                               ln_SNG001Inst,
                                               pd_fecpro --&Pgfape
                                              ,
                                               lv_lcProgram,
                                               lv_lcProgram,
                                               ln_CuotaCaja,
                                               ln_SaldoExtern,
                                               ln_excedMensual,
                                               ln_ratioConsu);
      
        ln_nExcMen := ln_nExcMen - ln_CuotaCaja;
      End If;
    
    end;
    --FIN 'InformacionEvaluacion'
  
    --****INICIO 'Procesar'
    --INICIO 'ValidacionFlujoExpress'
    begin
      lv_IndGra := 'S';
      pq_cr_modulo_campanias.Sp_CalculaCuota(pn_cor -- &JAQZ697CORAux
                                            ,
                                             ld_jaqz697fep -- &JAQZ697FEPAux
                                            ,
                                             ln_MntPreApro --&MtoAprobAux
                                            ,
                                             ln_NroCuo --&NroCuotasAux
                                            ,
                                             ln_plazo --&PlazoCuponAux
                                            ,
                                             ln_jaqz697suc --&JAQZ697SUCAux
                                            ,
                                             ld_FecPrim --&FECHAPrim
                                            ,
                                             lv_IndGra --&IndicaGrac
                                            ,
                                             ln_cta --&CtnroAux
                                            ,
                                             ln_MontoCuota --&MontoCuota
                                            ,
                                             ln_Aotasa_mod -- &Aotasa_mod
                                             );
    
      ln_dias_Grac := (ld_FecPrim - pd_fecpro) - ln_plazo;
      if ln_dias_Grac < 0 then
        ln_dias_Grac := 0;
      End if;
    
      select Tp1nro1
        into ln_GracQuiebre
        from fst198
       Where Tp1cod = 1
         and Tp1cod1 = 11141
         and Tp1corr1 = 12
         and Tp1corr2 = 1;
    
      If ln_dias_Grac <= ln_GracQuiebre then
        ln_MtoCalcQuieb := (ln_MontoCuota / 0.7) * 0.8;
      End If;
    
      select Tp1nro1
        into ln_Tp1nro1
        from fst198
       Where Tp1cod = 1
         and Tp1cod1 = 10899
         and Tp1corr1 = 99999
         and Tp1corr2 = 2
         and Tp1corr3 = 1;
    
      --cobertura pyme
      select Tp1nro1
        into ln_Tp1nro1_Pyme
        from fst198
       Where Tp1cod = 1
         and Tp1cod1 = 10899
         and Tp1corr1 = 99999
         and Tp1corr2 = 11
         and Tp1corr3 = 1;
    
      --FALTA &nExcMen
      --FALTA &ResultadoNeto
      If ln_ModEva = 14 then
        ln_CuotaCal := (ln_nExcMen * ln_Tp1nro1) / 100;
      Else
        ln_CuotaCal := (ln_ResultadoNeto * ln_Tp1nro1) / 100;
      End If;
    
      --calculo ratio
      lv_ErrRatio := 'N';
      pq_cr_ratiopyme_dten.sp_calculoratio(pn_pai --&Pepais
                                          ,
                                           pn_tdo --&Petdoc
                                          ,
                                           pc_ndo --&doc
                                          ,
                                           pn_cor --&JAQZ697CORAux
                                          ,
                                           pd_fec --&JAQZ697FEPaux
                                          ,
                                           ln_jaqz697ase --&usuvar--&JAQZ697ASEAux
                                          ,
                                           ln_MontoCuota --&MontoCuota
                                          ,
                                           ln_captotcaja,
                                           ln_Saldo_externo,
                                           ln_resultneto,
                                           ln_mntpotncial,
                                           ln_mntcuocntg,
                                           ln_ratiopyme);
    
      If ln_dias_Grac <= ln_GracQuiebre then
        If ln_ratiopyme > 0.78 then
          lv_ErrRatio := 'S';
        End If;
      Else
        If ln_ratiopyme > 0.68 then
          lv_ErrRatio := 'S';
        End If;
      End If;
    
      lv_valida_ctrl := 'N';
      --ln_JAQZ697MOEAux = ln_ModEva
      --ln_JAQZ697MTOAux = ln_MntPreApro
      If ln_MontoCuota > ln_CuotaCal And lc_Reactiva = 'N' And
         ln_ModEva = 13 And ln_jaqz697mod <> 105 then
        lc_error       := 'La cuota supera el maximo permitido. Puede continuar por Flujo Regular (Flujo reducido)';
        lv_valida_ctrl := 'S';
      Else
        If ln_MontoCuota > ln_MontoCuota And lc_Reactiva = 'N' And
           ln_ModEva = 14 And ln_jaqz697mod <> 105 then
          lc_error       := 'La cuota supera la cuota propuesta. Puede continuar por Flujo Regular (Flujo reducido)';
          lv_valida_ctrl := 'S';
        Else
          If ln_MontoCuota > ln_MtoCalcQuieb And
             ln_dias_Grac < ln_GracQuiebre And lc_Reactiva = 'N' And
             ln_ModEva = 13 And ln_jaqz697mod <> 105 then
            lc_error       := 'La nueva cuota supera la cuota propuesta. Puede continuar por Flujo Regular (Flujo reducido)';
            lv_valida_ctrl := 'S';
          Else
            If lv_ErrRatio = 'S' And lc_Reactiva = 'N' And ln_ModEva = 13 And
               ln_jaqz697mod <> 105 then
              lc_error       := 'La nueva cuota supera el ratio. Puede continuar por Flujo Regular (Flujo reducido)';
              lv_valida_ctrl := 'S';
            Else
              --If &MtoAprobAux > &JAQZ697MTOAux And &JAQZ697MOEAux=13 And &JAQZ697MODAux <> 105
              If ln_MntPreApro > ln_MntPreApro And ln_ModEva = 13 And
                 ln_jaqz697mod <> 105 then
                lc_error       := 'El monto ingresado no puede superar el monto propuesto. Puede continuar por Flujo Regular (Flujo reducido)';
                lv_valida_ctrl := 'S';
              End If;
            End If;
          End If;
        End If;
      End If;
    end;
    --FIN 'ValidacionFlujoExpress'
  
    lc_reactiva     := 'N';
    lv_VISgradiente := '0';
    lv_VISRechazo   := '0';
    lv_VISMotivo    := '0';
  
    --es reactiva
    begin
      select 'S'
        into lc_reactiva
        from fst198 a
       where a.tp1cod = 1
         and a.TP1COD1 = 11141
         and a.tp1corr1 = 11
         and a.tp1corr2 = 1
         and a.tp1nro1 = ln_jaqz697mod
         and a.tp1nro2 = ln_jaqz697top;
    exception
      when others then
        lc_reactiva := 'N';
        my_errm     := SQLERRM;
        null;
    end;
  
    If lc_reactiva = 'S' then
      lv_ENmonto := '0';
    Else
      lv_ENmonto := '1';
    End If;
  
    If ln_jaqz697mod = 117 then
      lv_ENnroCuo := '0';
      lv_ENFecpri := '0';
    Else
      lv_ENnroCuo := '1';
      lv_ENFecpri := '1';
    End If;
  
    If lc_flgAmpl = 'A' then
      --verifica si monto de ampliacion es cubierto
      --Call(PAQPA862,&pgcod,&JAQZ697MOAaux,&JAQZ697SUAaux,&JAQZ697MAAaux,&JAQZ697PAAaux,&JAQZ697CAAaux,&JAQZ697OPAaux,&JAQZ697SBAaux,&JAQZ697TOAaux,&Deuda)
      ln_Deuda := 0; --VALIDAR
      If ln_MntPreApro < ln_Deuda then
        lc_error       := 'El monto de deuda es mayor al monto ingresado';
        lv_valida_ctrl := 'S';
      End If;
    
    End If;
  
    begin
      select case
               when JAQZ697AU5 = 'S' then
                'S'
               when JAQZ697AU5 = 'G' then
                'S'
               when JAQZ697AU5 = 'D' then
                'S'
               when JAQZ697AU5 = 'R' then
                'S'
               when JAQZ697AU5 = 'Z' then
                'S'
               ELSE
                'N'
             end
        into lv_FlagProcc
        from jaqz697
       Where JAQZ697PAI = pn_pai
         and JAQZ697TDO = pn_tdo
         and JAQZ697NDO = pc_ndo
         and JAQZ697FEP = pd_fec; --&FECHAMax
    exception
      when others then
        lv_FlagProcc := 'N';
        my_errm      := SQLERRM;
        null;
    end;
  
    if lv_FlagProcc = 'S' and lc_error is null then
      lc_error       := 'Cliente ya procesado';
      lv_valida_ctrl := 'S';
    End if;
  
    If ln_MontoCuota = 0 Or ln_MontoCuota is null then
      lc_error       := 'La cuota propuesta no puede estar en cero';
      lv_valida_ctrl := 'S';
    End If;
  
    If ln_MntPreApro >= 999999 Or ln_JAQZ697EVN = 1 then
      lc_error       := 'Propuestas con 999999 deben ser procesados por flujo reducido';
      lv_valida_ctrl := 'S';
    End If;
  
    If lv_FlgEvaCorrec = 'S' And lv_flgSegCorrec = 'S' then
      lv_VISdetalle := '1';
    
      --INICIO 'ModoRCC'
      lv_VISmodific   := '1';
      lv_VISoferPropu := '1';
    
      ln_instance := 0;
      lv_convenio := 'N';
      lv_Vis_Info := '1';
    
      lc_Reactiva := 'N';
      --es reactiva
      begin
        select 'S'
          into lc_reactiva
          from fst198 a
         where a.tp1cod = 1
           and a.TP1COD1 = 11141
           and a.tp1corr1 = 11
           and a.tp1corr2 = 1
           and a.tp1nro1 = ln_jaqz697mod
           and a.tp1nro2 = ln_jaqz697top;
      exception
        when others then
          lc_reactiva := 'N';
          my_errm     := SQLERRM;
          null;
      end;
    
      If lc_Reactiva = 'S' then
        lv_ENmonto := '0';
      Else
        lv_ENmonto := '1';
      End If;
    
      If ln_jaqz697mod = 117 then
        lv_ENnroCuo := '0';
        lv_ENFecpri := '0';
      Else
        lv_ENnroCuo := '1';
        lv_ENFecpri := '1';
      End If;
    
      If lv_FlgEvaCorrec = 'S' And lv_flgSegCorrec = 'S' then
        lv_VISdetalle := '1';
        lv_VISMto     := '1';
        lv_VISFrec    := '1';
        lv_VISCuo     := '1';
        lv_VISFecPri  := '1';
      
        --verificar cuenta cliente **NO USAR
        begin
          select Ctnro
            into ln_Ctnro_tip
            from fsr008
           Where Pepais = pn_pai
             and Petdoc = pn_tdo
             and Pendoc = pc_ndo
             and Cttfir = 'T'
             and rownum = 1;
          pq_cr_modulo_campanias.sp_cr_VerificaCtnro(ln_Ctnro_tip,
                                                     lv_FlgCta);
        exception
          when others then
            my_errm := SQLERRM;
            null;
        end;
      
        pq_cr_modulo_campanias.sp_cr_VerificaCtnro(ln_cta, lv_FlgCta);
      
        If ln_ModEva = 14 then
          lv_VISIngBruto := '1';
          lv_VISIngNeto  := '1';
          lv_VISGasFam   := '1';
          lv_VISExcMens  := '1';
          lv_VISGasFinaC := '1';
          lv_VISdeudaRCC := '1';
        
          select Tp1nro1
            into ln_plazo
            from FST198
           Where Tp1cod = 1
             and Tp1cod1 = 10899
             and Tp1corr1 = 99999
             and Tp1corr2 = 1;
        
        Else
        
          select Pp028MaxN
            into ln_plazo
            from fpp028
           Where Pp017Par = 113
             and Pp028Mod = ln_jaqz697mod
             and Pp028Top = ln_jaqz697top
             and Pp028Mda = ln_jaqz697mda;
        End If;
      
      End If;
      --FIN 'ModoRCC'
    
      If ln_Segcod = 1 then
        lv_ENFrecuencia := '1';
        lv_ENCuenta     := '1';
      End If;
      If ln_Segcod = 2 then
        lv_ENFrecuencia := '0';
        lv_ENCuenta     := '0';
      End If;
    End If;
  
    lv_IndicaGrac := 'S';
  
    If lc_error is null or lc_error = '' or lv_valida_ctrl = '' or
       lv_valida_ctrl = 'N' or lv_valida_ctrl is null then
      lc_error       := 'Mostrar error';
      lv_valida_ctrl := 'S';
    Else
      /*
      pq_cr_modulo_campanias.Sp_actualizaInfo
      (pn_cor--&JAQZ697CORAux
      ,ld_jaqz697fep--&JAQZ697FEPAux
      ,ln_MntPreApro--&MtoAprobAux
      ,ln_cta--&CtnroAux
      ,ln_NroCuo--&NroCuotasAux
      ,ln_plazo--&PlazoCuponAux
      ,ln_jaqz697suc--&JAQZ697SUCAux
      ,ln_jaqz697ase--&Usuario
      ,ln_evaAct--&EvaActual
      ,ld_FecPrim--&FECHAPrim
      ,lv_IndicaGrac
      ,ln_MontoCuota);--**
      */
    
      pq_cr_modulo_campanias.Sp_insert_bandeja1(pn_pai,
                                                pn_tdo,
                                                pc_ndo,
                                                ln_plazo --&PlazoCuponAux
                                               ,
                                                pd_fecpro --&Pgfape
                                               ,
                                                ln_MntPreApro --&MtoAprobAux
                                               ,
                                                ln_NroCuo --&NroCuotasAux
                                               ,
                                                ln_cta --&CtnroAux
                                               ,
                                                ln_jaqz697ase --&Usuario
                                               ,
                                                ln_jaqz697mod --&JAQZ697MODaux
                                               ,
                                                ln_jaqz697top --&JAQZ697TOPaux
                                               ,
                                                ln_jaqz697suc --&JAQZ697SUCaux
                                               ,
                                                ln_jaqz697mda --&jaqz697MDAaux
                                               ,
                                                pn_cor --&JAQZ697CORaux
                                               ,
                                                ld_jaqz697fep --&JAQZ697FEPaux
                                               ,
                                                ln_SNG021TMod,
                                                ld_FecPrim); --&FECHAPrim)
    
      lc_error := 'Se procesaron los creditos.';
      If lv_valida_ctrl = 'S' or lv_valida_ctrl = '' then
        lc_error := 'mostrar error';
      End If;
    End If;
    --****FIN 'Procesar'
  end Sp_Proceso_flujoReducido_2;

  --***********************************************************
  Procedure Sp_flujoReducido(pn_pai    in number,
                             pn_tdo    in number,
                             pc_ndo    in varchar2,
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
                             pd_FecPri in date) is
  
    lc_flgAmpl char(30) := 'N'; --mod@abr 20200129
    ln_mod     number(3);
    ln_suc     number(3);
    ln_mda     number(4);
    ln_pap     number(4);
    ln_cta     number(9);
    ln_ope     number(9);
    ln_sbo     number(3);
    ln_top     number(3);
  
    ln_ModEva     number(4);
    ld_jaqz697fep date;
    ln_NroCuo     number(5);
    ln_MntPreApro number(17, 2);
    ln_plazo      number(5);
  
    ln_CodErrProc  number(5);
    lv_DesErrorVar varchar2(200);
    lc_error       varchar2(500);
    ln_evaAct      number(10);
  
    my_errm VARCHAR2(32000);
  
    ln_jaqz697suc number(5);
  
    ln_jaqz697ase  varchar2(12);
    lv_valida_ctrl varchar2(1);
    ln_jaqz697mod  number(3);
    ln_jaqz697top  number(10);
    ln_jaqz697mda  number(10);
    ln_JAQZ697EVN  number(10);
  
    lv_ExisteGrad varchar2(1);
    ln_OrigenSol  number(5);
    ln_jaqz697pap number(5);
    ln_OrigenCap  number(5);
    lv_DesErrProc varchar2(200);
    ln_sng001ins  number(10);
  
  begin
    lc_error       := null;
    lv_valida_ctrl := null;
    --obtener los datos de la propuesta
    begin
      select Distinct j.jaqz697tip,
                      j.jaqz697moa,
                      j.jaqz697sua,
                      j.jaqz697maa,
                      j.jaqz697paa,
                      j.jaqz697caa,
                      j.jaqz697opa,
                      j.jaqz697sba,
                      j.jaqz697toa,
                      j.jaqz697moe,
                      j.jaqz697fep,
                      j.jaqz697cuo,
                      j.jaqz697mto,
                      j.jaqz697pzo,
                      j.jaqz697eva,
                      j.jaqz697suc,
                      j.jaqz697ase,
                      j.jaqz697mod,
                      j.jaqz697top,
                      j.jaqz697mda,
                      j.jaqz697evn
        into lc_flgAmpl,
             ln_mod,
             ln_suc,
             ln_mda,
             ln_pap,
             ln_cta,
             ln_ope,
             ln_sbo,
             ln_top,
             ln_ModEva,
             ld_jaqz697fep,
             ln_NroCuo,
             ln_MntPreApro,
             ln_plazo,
             ln_evaAct,
             ln_jaqz697suc,
             ln_jaqz697ase,
             ln_jaqz697mod,
             ln_jaqz697top,
             ln_jaqz697mda,
             ln_JAQZ697EVN
        from jaqz697 j
       where j.jaqz697pai = pn_pai
         and j.jaqz697tdo = pn_tdo
         and j.jaqz697ndo = pc_ndo
         and j.jaqz697fep = pd_fec
         and j.jaqz697cor = pn_cor;
    exception
      when others then
        my_errm := SQLERRM;
        null;
    end;
  
    begin
      pq_cr_modulo_campanias.Sp_verificaGradiente(ld_jaqz697fep --&JAQZ697FEPaux
                                                 ,
                                                  pn_pai --&Pepais
                                                 ,
                                                  pn_tdo --&Petdoc
                                                 ,
                                                  pc_ndo --&docGradiente
                                                 ,
                                                  lv_ExisteGrad);
    
    exception
      when others then
        lv_ExisteGrad := 'N';
        my_errm       := SQLERRM;
        null;
    end;
  
    If lc_flgAmpl = 'A' And ln_jaqz697mod <> 117 then
      ln_OrigenSol := 4;
    Else
      If ln_jaqz697mod = 117 then
        ln_OrigenSol := 11;
      Else
        ln_OrigenSol := 0;
      End If;
    End If;
  
    ln_jaqz697pap := 0;
    ln_OrigenCap  := 4;
  
    If ln_jaqz697mod = 105 then
      lc_error       := 'Creditos paralelos no pueden procesarse por Flujo Reducido.';
      lv_valida_ctrl := 'S';
    End If;
  
    If lv_ExisteGrad = 'N' And lc_error is null then
      --&Pgmcall='PJAQM340' 
      --Call(&Pgmcall,&OrigenSol,&Pepais,&Petdoc,&Pendoc,&CtnroAux,&JAQZ697SUCAux,&JAQZ697MODAux,&JAQZ697TOPAux,&JAQZ697MDAaux,&jaqz697pap,&NroCuotasAux,&PlazoCuponAux,&MtoAprobAux,&JAQZ697ASEAux,&OrigenCap,&SdtAvales,&sng001ins,&CodErrProc,&DesErrProc)
    
      lv_DesErrorVar := lv_DesErrProc;
      pq_cr_modulo_campanias.sp_jaqm80_tun(pd_fecpro --&Pgfape
                                          ,
                                           ld_jaqz697fep --&JAQZ697FEPaux
                                          ,
                                           pn_cor --&JAQZ697CORAux
                                          ,
                                           ln_sng001ins,
                                           ln_CodErrProc,
                                           lv_DesErrorVar);
    
      lc_error       := 'Este crédito se derivará al flujo reducido para actualizar evaluacion o cuotas gradientes.';
      lv_valida_ctrl := null;
    
    End If;
  
    If lv_ExisteGrad <> 'N' then
      lc_error       := 'El cliente ya fue procesado';
      lv_valida_ctrl := 'S';
    End If;
  
    If lv_valida_ctrl is not null or lv_valida_ctrl = 'N' then
      lc_error       := 'Mostrar Error';
      lv_valida_ctrl := 'S';
    End If;
  
  end Sp_flujoReducido;

  --***********************************************************
  Procedure Sp_Proceso_flujoReducido(pn_pai    in number,
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
                                     pd_FecPri in date) is
  
    lc_flgAmpl char(30) := 'N'; --mod@abr 20200129
    ln_mod     number(3);
    ln_suc     number(3);
    ln_mda     number(4);
    ln_pap     number(4);
    ln_cta     number(9);
    ln_ope     number(9);
    ln_sbo     number(3);
    ln_top     number(3);
  
    lc_reactiva char(1) := 'N'; --mod@abr 20200623
    --0 se ejecuta proceso de fintech
    --1 se ejecuta proceso de flujo online
  
    lv_FlagProcc   varchar(1) := 'N';
    lv_FlgCta      varchar(1);
    ln_tcbi        number(15, 8);
    ln_ModEva      number(4);
    ld_jaqz697fep  date;
    ln_NroCuo      number(5);
    ln_MntPreApro  number(17, 2);
    ln_plazo       number(5);
    ld_FecPrim     date;
    lv_IndGra      varchar2(2);
    ln_MntCuo      number(17, 2);
    ln_GasFinaC    number(17, 2);
    ln_Instan      number(10);
    ln_CodErrProc  number(5);
    lv_DesErrorVar varchar2(200);
    lc_error       varchar2(500);
    ln_Deuda       number(18, 2);
    ln_evaAct      number(10);
    ln_jaqz697suc  number(10);
    ln_jaqz697ase  varchar2(10);
    ln_jaqz697mod  number(10);
    ln_jaqz697top  number(10);
    ln_jaqz697mda  number(10);
    ln_JAQZ697EVN  number(10);
  
    my_errm VARCHAR2(32000);
  begin
    lc_error := null;
  
    /*obtener los datos de la propuesta*/
    begin
      select Distinct j.jaqz697tip,
                      j.jaqz697moa,
                      j.jaqz697sua,
                      j.jaqz697maa,
                      j.jaqz697paa,
                      j.jaqz697caa,
                      j.jaqz697opa,
                      j.jaqz697sba,
                      j.jaqz697toa,
                      j.jaqz697moe,
                      j.jaqz697fep,
                      j.jaqz697cuo,
                      j.jaqz697mto,
                      j.jaqz697pzo,
                      j.jaqz697eva,
                      j.jaqz697suc,
                      j.jaqz697ase,
                      j.jaqz697mod,
                      j.jaqz697top,
                      j.jaqz697mda,
                      j.jaqz697evn
        into lc_flgAmpl,
             ln_mod,
             ln_suc,
             ln_mda,
             ln_pap,
             ln_cta,
             ln_ope,
             ln_sbo,
             ln_top,
             ln_ModEva,
             ld_jaqz697fep,
             ln_NroCuo,
             ln_MntPreApro,
             ln_plazo,
             ln_evaAct,
             ln_jaqz697suc,
             ln_jaqz697ase,
             ln_jaqz697mod,
             ln_jaqz697top,
             ln_jaqz697mda,
             ln_JAQZ697EVN
        from jaqz697 j
       where j.jaqz697pai = pn_pai
         and j.jaqz697tdo = pn_tdo
         and j.jaqz697ndo = pc_ndo
         and j.jaqz697fep = pd_fec
         and j.jaqz697cor = pn_cor;
    exception
      when others then
        my_errm := SQLERRM;
        null;
    end;
  
    --es reactiva
    begin
      select 'S'
        into lc_reactiva
        from fst198 a
       where a.tp1cod = 1
         and a.TP1COD1 = 11141
         and a.tp1corr1 = 11
         and a.tp1corr2 = 1
         and a.tp1nro1 = ln_jaqz697mod
         and a.tp1nro2 = ln_jaqz697top;
    exception
      when others then
        my_errm := SQLERRM;
        dbms_output.put_line(my_errm);
        null;
    end;
  
    If lc_flgAmpl = 'A' then
      --//verifica si monto de ampliacion es cubierto
      --Call(PAQPA862,&pgcod,&JAQZ697MOAaux,&JAQZ697SUAaux,&JAQZ697MAAaux,&JAQZ697PAAaux,&JAQZ697CAAaux,&JAQZ697OPAaux,&JAQZ697SBAaux,&JAQZ697TOAaux,&Deuda)
      dbms_output.put_line('RRg0524');
      --if &MtoAprobAux < ln_Deuda 
      if ln_MntPreApro < ln_Deuda then
        lc_error := 'El monto de deuda es mayor al monto ingresado';
      else
        lc_error := null;
      End if;
    End If;
  
    --verificar cliente procesado    
    begin
      select case
               when JAQZ697AU5 = 'S' then
                'S'
               when JAQZ697AU5 = 'G' then
                'S'
               when JAQZ697AU5 = 'D' then
                'S'
               when JAQZ697AU5 = 'R' then
                'S'
               when JAQZ697AU5 = 'Z' then
                'S'
               ELSE
                'N'
             end
        into lv_FlagProcc
        from jaqz697
       Where JAQZ697PAI = pn_pai
         and JAQZ697TDO = pn_tdo
         and JAQZ697NDO = pc_ndo
         and JAQZ697FEP = pd_fec; --&FECHAMax
    exception
      when others then
        lv_FlagProcc := 'N';
        my_errm      := SQLERRM;
        null;
    end;
  
    if lv_FlagProcc = 'S' and lc_error is null then
      lc_error := 'Cliente ya procesado';
    else
      lc_error := null;
    End if;
  
    if lc_error is null then
      /*--verificar cuenta cliente - INNECESARIO 
      begin
        select Ctnro
          into ln_Ctnro_tip
          from fsr008
         Where Pepais = pn_pai
           and Petdoc = pn_tdo
           and Pendoc = pc_ndo
           and Cttfir = 'T';
      
        pq_cr_modulo_campanias.sp_cr_VerificaCtnro(ln_Ctnro_tip, lv_FlgCta);
      
      exception
        when others then
          my_errm    := SQLERRM;
          null;
      end;*/
    
      --verificar tipo cuenta cliente
      begin
        pq_cr_modulo_campanias.sp_cr_VerificaCtnro(ln_cta, lv_FlgCta);
      exception
        when others then
          my_errm := SQLERRM;
          dbms_output.put_line(my_errm);
          null;
      end;
    
      --InformacionEvaluacion
      --tipo cambio
      pq_cr_modulo_campanias.Sp_cr_tipocambio(pd_fecpro, ln_tcbi);
    
      /*gasto financiaero*/
      pq_cr_modulo_campanias.sp_gasto_financi(ln_evaAct, ln_GasFinaC);
    
      ld_FecPrim := pd_fecpro + ln_plazo;
      lv_IndGra  := 'S';
      pq_cr_modulo_campanias.Sp_actualizaInfo(pn_cor,
                                              ld_jaqz697fep,
                                              ln_MntPreApro,
                                              pn_cta,
                                              pn_cuo,
                                              pn_pzo,
                                              ln_jaqz697suc,
                                              pc_ase,
                                              ln_evaAct,
                                              ld_FecPrim,
                                              lv_IndGra,
                                              ln_MntCuo);
    
      pq_cr_modulo_campanias.sp_Procesajaqm80(pd_fecpro,
                                              ld_jaqz697fep,
                                              pn_cor,
                                              ln_Instan, --&sng001ins
                                              ln_CodErrProc,
                                              lv_DesErrorVar);
    End if;
  end Sp_Proceso_flujoReducido;

end pq_cr_apl_flujoOnline;
/

