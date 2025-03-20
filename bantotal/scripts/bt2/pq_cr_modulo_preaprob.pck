create or replace package pq_Cr_modulo_preaprob is

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
                               pn_moe    in number); --mod@abr 20191210);
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
                               pd_fecP in date); --fecha de la carga de BI);
  procedure sp_Cr_VerfUltEvaluacion(ln_pais       in number,
                                    ln_tdoc       in number,
                                    lc_ndoc       in char,
                                    ln_NroSolCred out number,
                                    ln_NroEval    out number);
  procedure Sp_cr_actualiza(pn_cor in number,
                            pn_pai in number,
                            pn_tdo in number,
                            pc_ndo in char,
                            pd_fec in date);
  procedure Sp_cr_rechazar(pn_cor in number,
                           pn_pai in number,
                           pn_tdo in number,
                           pc_ndo in char,
                           pd_fec in date);
  Procedure Sp_cr_verificar(pn_pai in number,
                            pn_tdo in number,
                            pc_ndo in char,
                            pc_flg out char);
  Procedure Sp_baja_solicitud(ln_ins in number);
  Procedure Sp_actualizaInfo(pn_cor in number,
                             pd_fec in date,
                             pn_mto in number,
                             pn_cta in number,
                             pn_cuo in number,
                             pn_fre in number);
  procedure sp_cr_VerificaCtnro(pn_cta in number, pc_flg out char);
  Procedure Sp_cr_noInserte(pd_fec in date,
                            pn_cor in number,
                            pc_flg out char);
  Procedure Sp_cr_mtoCuota(pn_mod    in number,
                           pn_mda    in number,
                           pn_pap    in number,
                           pn_top    in number,
                           pn_suc    in number,
                           pn_mto    in number,
                           pn_cuo    in number,
                           pn_fre    in number,
                           pd_fecpro in date,
                           pn_mtoCuo out number);
end pq_Cr_modulo_preaprob;
/

create or replace package body pq_Cr_modulo_preaprob is

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
                               pn_moe    in number) is
  
    ld_Fecaux  date;
    lc_hab     char(1) := 'N';
    ln_cont    number(5);
    pd_fecprim date;
    pn_HisNR   number(1);
    ln_Corr    number(9);
    lc_estado  char(1);
    ln_flgProc number(5) := 0;
    ln_seg     number(5);
    ln_Cor751  number(9);
    lc_existe  char(1) := 'N';
    --0 se ejecuta proceso de fintech
    --1 se ejecuta proceso de flujo online
  begin
  
    /* insert into prueba_andrea
      (pn_pai,
       pn_tdo,
       pc_ndo,
       pn_pzo,
       pd_fecpro,
       pn_mto,
       pn_cuo,
       pn_cta,
       pc_ase,
       pn_mod,
       pn_top,
       pn_suc,
       pn_mda,
       pn_cor,
       pd_fec,
       pn_moe,
       INDIC)
    values
      (pn_pai,
       pn_tdo,
       pc_ndo,
       pn_pzo,
       pd_fecpro,
       pn_mto,
       pn_cuo,
       pn_cta,
       pc_ase,
       pn_mod,
       pn_top,
       pn_suc,
       pn_mda,
       pn_cor,
       pd_fec,
       pn_moe,
       '1');
    COMMIT;*/
  
    begin
      select 'S'
        into lc_existe
        from jaqz695 j, jaqm750 k
       where j.jaqz695pai = k.jaqm750pai
         and j.jaqz695tdo = k.jaqm750tdo
         and j.jaqz695ndo = k.jaqm750ndo
         and j.jaqz695suc = k.jaqm750suc
         and j.jaqz695mda = k.jaqm750mda
         and j.jaqz695cta = k.jaqm750cta
         and j.jaqz695mod = k.jaqm750mod
         and j.jaqz695top = k.jaqm750tip
         and j.jaqz695pai = pn_pai
         and j.jaqz695tdo = pn_tdo
         and j.jaqz695ndo = pc_ndo
         and j.jaqz695cor = pn_cor --mod@abr 20191210
         and k.jaqm750fch >= j.jaqz695fep
         and rownum = 1;
    exception
      when others then
        null;
    end
    
    ;
  
    if nvl(lc_existe, 'N') = 'N' then
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
      ld_Fecaux := pd_fecpro + pn_pzo;
    
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
    
      --------------mod@abr-----------------
      --begin
      -- Call the procedure
      --  pq_cr_tasa_campverano.sp_cr_inicio(ln_pais      => pn_pai,
      --                                     ln_tdoc      => pn_tdo,
      --                                     lc_ndoc      => pc_ndo,
      --                                     lc_usuario   => pc_ase,
      --                                     ld_fecpro    => pd_fecpro,
      --                                     ln_nrocuenta => pn_cta,
      --                                     ln_modulo    => pn_mod);
      --end;
    
      --------------mod@abr-----------------
    
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
    
      ---INSERTAR JAQM751 SEGUROS
      begin
        select a.tp1nro1
          into ln_seg
          from fst198 a
         where a.tp1cod = 1
           and a.tp1cod1 = 10899
           and a.tp1corr1 = 77777
           and a.tp1corr2 = 3
           and a.tp1nro2 = pn_pzo;
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
    
      ----mod@abr 20191231
      Pq_Cr_Modulo_Preaprob.Sp_insert_bandeja2(pn_pai    => pn_pai,
                                               pn_tdo    => pn_tdo,
                                               pc_ndo    => pc_ndo,
                                               pd_Fecpro => pd_fecpro,
                                               pc_ase    => pc_ase,
                                               pn_seg    => pn_moe,
                                               pn_cor    => pn_cor,
                                               pd_fecP   => pd_fec);
      pq_cr_modulo_preaprob.Sp_insert_bandeja3(pn_pai  => pn_pai,
                                               pn_tdo  => pn_tdo,
                                               pc_ndo  => pc_ndo,
                                               pn_corr => pn_cor,
                                               pd_fecP => pd_fec);
    
      pq_cr_modulo_preaprob.Sp_cr_actualiza(pn_cor => pn_cor,
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
      select a.jaqz695ind, a.jaqz695eva
        into lc_ind, ln_eva
        from jaqz695 a
       where a.jaqz695pai = pn_pai
         and a.jaqz695tdo = pn_tdo
         and a.jaqz695ndo = pc_ndo
         and a.jaqz695cor = pn_cor
         and a.jaqz695fep = pd_fecP;
    exception
      when others then
        null;
    end;
  
    if nvl(lc_ind, 'A') = 'A' then
      --registros anteriores
      begin
        select 'S'
          into lc_existe
          from jaqz695 j, Aqpa190a k
         where j.jaqz695pai = k.aqpa190apdoc
           and j.jaqz695tdo = k.aqpa190atdoc
           and j.jaqz695ndo = k.aqpa190andoc
           and j.jaqz695ase = k.aqpa190ausu
           and j.jaqz695pai = pn_pai
           and j.jaqz695tdo = pn_tdo
           and j.jaqz695ndo = pc_ndo
           and j.jaqz695cor = pn_cor --mod@abr 20191210
           and rownum = 1;
      exception
        when others then
          null;
      end
      
      ;
    
      if nvl(lc_existe, 'N') = 'N' then
      
        Insert into Aqpa190a
        
        values
          (sq_cn_flujoeval.nextval,
           pn_pai,
           pn_tdo,
           pc_ndo,
           pd_Fecpro,
           pc_ase,
           0,
           pn_seg);
      
        commit;
      end if;
    end if;
  
    if nvl(lc_ind, 'A') <> 'A' then
    
      begin
        select 'S'
          into lc_existe
          from jaqz695 j, Aqpa190a k
         where j.jaqz695pai = k.aqpa190apdoc
           and j.jaqz695tdo = k.aqpa190atdoc
           and j.jaqz695ndo = k.aqpa190andoc
           and j.jaqz695ase = k.aqpa190ausu
           and j.jaqz695pai = pn_pai
           and j.jaqz695tdo = pn_tdo
           and j.jaqz695ndo = pc_ndo
           and j.jaqz695cor = pn_cor --mod@abr 20191210
           and j.jaqz695eva = k.aqpa190aeval
           and rownum = 1;
      exception
        when others then
          null;
      end
      
      ;
    
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
          select a.aqpa190aeval,
                 a.aqpa190apdoc,
                 a.aqpa190atdoc,
                 a.aqpa190andoc,
                 a.aqpa190afec,
                 a.aqpa190ausu,
                 a.aqpa190asol,
                 a.aqpa190atmod
            from aqpa190a_bdj a
           where a.aqpa190apdoc = pn_pai
             and a.aqpa190atdoc = pn_tdo
             and a.aqpa190andoc = pc_ndo
             and a.aqpa190aeval = ln_eva;
      
        commit;
      end if;
    end if;
  
  end Sp_insert_bandeja2;

  Procedure Sp_insert_bandeja3(pn_pai  in number,
                               pn_tdo  in number,
                               pc_ndo  in char,
                               pn_corr in number,
                               pd_fecP in date --fecha de la carga de BI
                               ) is
  
    cursor evaluacion(cn_eva in number) is
      select * from sng023 a where a.sng021eval = cn_eva;
  
    ln_eva    number(10);
    ln_evaMax number(10);
    pn_ins    number(10);
    --lc_existe char(1) := 'N';
    lc_ind   char(1) := 'A'; --anteriores
    ln_evaBI number(10);
  begin
  
    begin
      select a.jaqz695ind, a.jaqz695eva
        into lc_ind, ln_evaBI
        from jaqz695 a
       where a.jaqz695pai = pn_pai
         and a.jaqz695tdo = pn_tdo
         and a.jaqz695ndo = pc_ndo
         and a.jaqz695cor = pn_corr
         and a.jaqz695fep = pd_fecP;
    exception
      when others then
        null;
    end;
    if nvl(lc_ind, 'A') = 'A' then
      --registros anteriores
    
      pq_Cr_modulo_preaprob.sp_Cr_VerfUltEvaluacion(ln_pais       => pn_pai,
                                                    ln_tdoc       => pn_tdo,
                                                    lc_ndoc       => pc_ndo,
                                                    ln_NroSolCred => pn_ins,
                                                    ln_NroEval    => ln_eva);
    
      begin
        select max(aqpa190aeval)
          into ln_evaMax
          from aqpa190a
         where aqpa190andoc = pc_ndo;
      end;
    
      for i in evaluacion(ln_eva) loop
      
        insert into AQPA190b values (ln_evaMax, i.sng026cod, i.sng023mto);
        commit;
      end loop;
    end if;
  
    if nvl(lc_ind, 'A') <> 'A' then
    
      insert into AQPA190b
        (Aqpa190beval, Aqpa190bcod, Aqpa190bmto)
        select a.aqpa190beval, a.aqpa190bcod, a.aqpa190bmto
          from aqpa190b_BDJ a
         where a.aqpa190beval = ln_evaBI;
    
      commit;
    
      if nvl(lc_ind, 'A') = 'S' then
        insert into Aqpa190d
          (Aqpa190dcorr,
           Aqpa190dfech,
           Aqpa190dhora,
           Aqpa190dinst,
           Aqpa190dneva,
           Aqpa190dpais,
           Aqpa190dtdoc,
           Aqpa190dndoc,
           Aqpa190drubr,
           Aqpa190desta,
           Aqpa190denti,
           Aqpa190dtcre,
           Aqpa190dsdeu,
           Aqpa190dplaz,
           Aqpa190dtaza,
           Aqpa190dccalc,
           Aqpa190dgfin,
           Aqpa190dfrcc,
           Aqpa190ddori,
           Aqpa190dchek,
           Aqpa190dpers,
           Aqpa190drela,
           Aqpa190dline,
           Aqpa190daux1,
           Aqpa190daux2,
           Aqpa190daux3,
           Aqpa190daux4,
           Aqpa190daux5,
           Aqpa190daux6,
           Aqpa190daux7,
           Aqpa190daux8,
           Aqpa190daux9,
           Aqpa190dmda,
           Aqpa190dtlin,
           Aqpa190dutil,
           Aqpa190dflin,
           Aqpa190dflguso,
           Aqpa190dcptn,
           Aqpa190dfac1,
           Aqpa190dfac2,
           Aqpa190dfac3,
           Aqpa190dcent)
        
          select jaqy327corr,
                 jaqy327fech,
                 jaqy327hora,
                 jaqy327inst,
                 jaqy327neva,
                 jaqy327pais,
                 jaqy327tdoc,
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
           where a.jaqy327neva = ln_evaBI;
      
        commit;
      end if;
    end if;
  
  end Sp_insert_bandeja3;
  ---------------------------------------------------
  procedure sp_Cr_VerfUltEvaluacion(ln_pais       in number,
                                    ln_tdoc       in number,
                                    lc_ndoc       in char,
                                    ln_NroSolCred out number,
                                    ln_NroEval    out number) is
  
    cursor lista_creditos is
    
      select g.pgcod  ln_pgcod,
             g.aomod  ln_mod,
             g.aosuc  ln_suc,
             g.aomda  ln_mda,
             g.aopap  ln_pap,
             g.aocta  ln_cta,
             g.aooper ln_oper,
             g.aosbop ln_sbop,
             g.aotope ln_tope
        from fsd010 g
       where g.pgcod = 1
         and g.aomda in (0, 101)
         and g.aopap = 0
         and g.aocta in (select f.ctnro
                           from fsr008 f
                          where f.pepais = ln_pais
                            and f.petdoc = ln_tdoc
                            and f.pendoc = lc_ndoc
                            and f.cttfir = 'T')
         and (aomod in (select modulo
                          from fst111
                         where dscod = 50
                           and modulo not in (108, 116)
                            or aomod in (117, 141)));
  
    ln_NroSolCredAux number;
    ld_FchEvalAux    date := null;
    ld_FchEval       date;
    ln_NroEvalAux    number;
  
  begin
  
    ln_NroEval := 0;
  
    for l in lista_creditos loop
    
      begin
        ln_NroSolCredAux := fn_instancia_credito(v_Scmod  => l.ln_mod,
                                                 v_Scsuc  => l.ln_suc,
                                                 v_Scmda  => l.ln_mda,
                                                 v_Scpap  => l.ln_pap,
                                                 v_Sccta  => l.ln_cta,
                                                 v_Scoper => l.ln_oper,
                                                 v_Scsbop => l.ln_sbop,
                                                 v_Sctope => l.ln_tope);
      end;
    
      begin
        select s.sng021eval
          into ln_NroEvalAux
          from sng021 s
         where s.sng021sol = ln_NroSolCredAux
           and s.sng021tmod = 13;
      exception
        when others then
          ln_NroEvalAux := 0;
      end;
    
      if ln_NroEvalAux > 0 then
      
        begin
          select s.sng120fpag
            into ld_FchEvalAux
            from sng120 s
           where s.sng120ins = ln_NroSolCredAux
             and s.sng120tsk = 'EVALUACION';
        end;
      
        if ld_FchEval < ld_FchEvalAux then
          ld_FchEval    := ld_FchEvalAux;
          ln_NroEval    := ln_NroEvalAux;
          ln_NroSolCred := ln_NroSolCredAux;
        else
          if ld_FchEval = ld_FchEvalAux then
            if ln_NroEval < ln_NroEvalAux then
              ln_NroEval    := ln_NroEvalAux;
              ln_NroSolCred := ln_NroSolCredAux;
            end if;
          end if;
        end if;
      
        if ld_FchEval is null then
          ld_FchEval    := ld_FchEvalAux;
          ln_NroEval    := ln_NroEvalAux;
          ln_NroSolCred := ln_NroSolCredAux;
        
        end if;
      end if;
    
    end loop;
  
  end sp_Cr_VerfUltEvaluacion;

  procedure Sp_cr_actualiza(pn_cor in number,
                            pn_pai in number,
                            pn_tdo in number,
                            pc_ndo in char,
                            pd_fec in date) is
  begin
  
    /* insert into prueba_andrea
      (pn_pai, pn_tdo, pc_ndo, pn_cor, pd_fec, INDIC)
    values
      (pn_pai, pn_tdo, pc_ndo, pn_cor, pd_fec, '2');
    COMMIT;*/
    update jaqz695 a
       set a.jaqz695au5 = 'S', A.JAQZ695CHK = '1'
     where a.jaqz695fep = pd_fec
       and a.jaqz695cor = pn_cor
       and a.jaqz695pai = pn_pai
       and a.jaqz695tdo = pn_tdo
       and a.jaqz695ndo = pc_ndo;
    COMMIT;
  end Sp_cr_actualiza;

  procedure Sp_cr_rechazar(pn_cor in number,
                           pn_pai in number,
                           pn_tdo in number,
                           pc_ndo in char,
                           pd_fec in date) is
  begin
  
    update jaqz695 a
       set a.jaqz695au5 = 'R', A.JAQZ695CHK = '1'
     where a.jaqz695fep = pd_fec
       and a.jaqz695cor = pn_cor
       and a.jaqz695pai = pn_pai
       and a.jaqz695tdo = pn_tdo
       and a.jaqz695ndo = pc_ndo;
    COMMIT;
  end Sp_cr_rechazar;

  Procedure Sp_cr_verificar(pn_pai in number,
                            pn_tdo in number,
                            pc_ndo in char,
                            pc_flg out char) is
    lc_flg      char(1) := 'N';
    ln_insErr   number(10);
    ld_fec750   date;
    ln_corr750  number(9);
    lc_flgRatio char(1) := 'N';
  
    cursor errores(cd_fec750 in date, cn_corr750 in number) is
    
      select a.jaqm752dsc
        from jaqm752 a
       where a.jaqm752emp = 1
         and a.jaqm752fch = cd_fec750
         and a.jaqm752reg = cn_corr750;
  
  begin
  
    begin
      select 'S'
        into lc_flg
        from jaqz695 a
       where a.jaqz695pai = pn_pai
         and a.jaqz695tdo = pn_tdo
         and a.jaqz695ndo = pc_ndo
         and a.jaqz695chk = '1'
            --         and a.jaqz695au5 in ('S', 'R')
         and a.jaqz695au5 in ('S')
         and rownum = 1;
    exception
      when others then
        null;
    end;
  
    if nvl(lc_flg, 'N') = 'S' then
      begin
        select k.jaqm750ins, k.jaqm750fch, k.jaqm750reg
          into ln_insErr, ld_fec750, ln_corr750
          from jaqz695 j, jaqm750 k
         where j.jaqz695pai = k.jaqm750pai
           and j.jaqz695tdo = k.jaqm750tdo
           and j.jaqz695ndo = k.jaqm750ndo
           and j.jaqz695suc = k.jaqm750suc
           and j.jaqz695mda = k.jaqm750mda
           and j.jaqz695cta = k.jaqm750cta
           and j.jaqz695mod = k.jaqm750mod
           and j.jaqz695top = k.jaqm750tip
           and j.jaqz695chk = '1'
           and k.jaqm750est = 'E'
           and j.jaqz695pai = pn_pai
           and j.jaqz695tdo = pn_tdo
           and j.jaqz695ndo = pc_ndo
           and j.jaqz695au5 = 'S';
      exception
        when others then
          null;
      end;
    
      if nvl(ln_insErr, 0) <> 0 then
        for i in errores(ld_fec750, ln_corr750) loop
        
          if i.jaqm752dsc = 'xxxx' then
            --colocar error que muestra cuando supera ratio
            lc_flgRatio := 'S';
            exit;
          end if;
        
        end loop;
        lc_flgRatio := 'N'; --se agrego para que nunca se ejecute
        if lc_flgRatio = 'S' then
          --dar de baja solicitud
          pq_Cr_modulo_preaprob.sp_baja_solicitud(ln_insErr);
          pc_flg := 'S'; --puede procesar de nuevo
        else
          pc_flg := 'N'; --no puede procesar de nuevo   
        end if;
      else
        pc_flg := 'N'; --no puede procesar de nuevo
      end if;
    
    else
      pc_flg := 'S'; --puede procesar de nuevo
    
    end if;
  
  end Sp_cr_verificar;
  -----------------------------------------------------------------
  Procedure Sp_baja_solicitud(ln_ins in number) is
  
    ln_id      number(10);
    ld_fc697   date;
    ln_corr697 number := 0;
  
  begin
  
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
  
    -- mpostigoc 02.08.2022
    begin
      select z.jaqz697fep, z.jaqz697cor
        into ld_fc697, ln_corr697
        from jaqm750 j, jaqz697 z
       where j.jaqm750pai = z.jaqz697pai
         and j.jaqm750tdo = z.jaqz697tdo
         and j.jaqm750ndo = z.jaqz697ndo
         and j.jaqm750mod = z.jaqz697mod
         and j.jaqm750tip = z.jaqz697top
         and j.jaqm750suc = z.jaqz697suc
         and j.jaqm750cta = z.jaqz697cta
         and j.jaqm750imp = z.jaqz697mto
         and j.jaqm750ins = ln_ins
         and z.jaqz697fep = (select max(l.jaqz697fep) from jaqz697 l)
         and z.jaqz697tca = 'P';
    exception
      when others then
        null;
    end;
  
    if ln_corr697 > 0 then
    
      update jaqz697 j
         set j.jaqz697apr = 'N'
       where j.jaqz697fep = ld_fc697
         and j.jaqz697cor = ln_corr697;
      commit;
    
    end if;
  
  end Sp_baja_solicitud;
  -------------------------------------------------------
  Procedure Sp_actualizaInfo(pn_cor in number,
                             pd_fec in date,
                             pn_mto in number,
                             pn_cta in number,
                             pn_cuo in number,
                             pn_fre in number) is
  
    ln_suc    number(3);
    ln_mda    number(4);
    ln_pap    number(4);
    ln_mod    number(3);
    ln_top    number(3);
    ln_mto    number(17, 2);
    ln_fre    number(5);
    ln_cuo    number(10);
    ln_mtoCuo number(17, 2);
    ld_Fecpro date;
  begin
  
    begin
      select a.pgfape into ld_Fecpro from fst017 a where a.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    begin
      select a.jaqz695suc,
             a.jaqz695mda,
             0,
             a.jaqz695mod,
             a.jaqz695top,
             a.jaqz695mto,
             a.jaqz695pzo,
             a.jaqz695cuo
        into ln_suc, ln_mda, ln_pap, ln_mod, ln_top, ln_mto, ln_fre, ln_cuo
        from jaqz695 a
       where a.jaqz695fep = pd_fec
         and a.jaqz695cor = pn_cor;
    exception
      when others then
        null;
    end;
  
    pq_Cr_modulo_preaprob.Sp_cr_mtoCuota(ln_mod,
                                         ln_mda,
                                         ln_pap,
                                         ln_top,
                                         ln_suc,
                                         pn_mto,
                                         pn_cuo,
                                         pn_fre,
                                         ld_Fecpro,
                                         ln_mtoCuo);
  
    update jaqz695 a
       set a.jaqz695mto = pn_mto,
           a.jaqz695cta = pn_cta,
           a.jaqz695cuo = pn_cuo,
           a.jaqz695pzo = pn_fre,
           a.jaqz695mcu = ln_mtoCuo
     where a.jaqz695fep = pd_fec
       and a.jaqz695cor = pn_cor;
  
    commit;
  
  end Sp_actualizaInfo;

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

  Procedure Sp_cr_noInserte(pd_fec in date,
                            pn_cor in number,
                            pc_flg out char) is
    lc_flg char(1) := 'N';
  begin
    begin
      select 'S'
        into lc_flg
        from jaqz695 a
       where a.jaqz695fep = pd_fec
         and a.jaqz695cor = pn_cor
         and a.jaqz695chk = '1'
         and a.jaqz695au5 = 'R'
         and rownum = 1;
    exception
      when others then
        lc_flg := 'N';
    end;
    pc_flg := lc_flg;
  
  end Sp_cr_noInserte;

  Procedure Sp_cr_mtoCuota(pn_mod    in number,
                           pn_mda    in number,
                           pn_pap    in number,
                           pn_top    in number,
                           pn_suc    in number,
                           pn_mto    in number,
                           pn_cuo    in number,
                           pn_fre    in number,
                           pd_fecpro in date,
                           pn_mtoCuo out number) is
  
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
  
  begin
  
    ln_mod := pn_mod;
    ln_suc := pn_suc;
    ln_mda := pn_mda;
    ln_pap := pn_pap;
    ln_top := pn_top;
    ln_mto := pn_mto;
  
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
  
    ln_pzo := (pn_cuo * pn_fre) + nvl(ln_aux, 0);
  
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
  
    pn_tasa := nvl(ln_tas, 0) + nvl(ln_tvmpo, 0);
    ln_div  := (1 - power((1 +
                          ((power((1 + (pn_tasa / 100)), (pn_fre / 360))) - 1)),
                          -pn_cuo));
    if ln_div > 0 then
      pn_mtoCuo := (pn_mto *
                   ((power((1 + (pn_tasa / 100)), (pn_fre / 360))) - 1)) /
                   ln_div;
    else
      pn_mtoCuo := 0;
    end if;
  
  end Sp_cr_mtoCuota;

end pq_Cr_modulo_preaprob;
/

