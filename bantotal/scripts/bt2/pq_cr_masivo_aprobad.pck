create or replace package pq_cr_masivo_aprobad is

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
                               pd_fecPri in date);

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
  Procedure Sp_Cr_aqpa190c(pn_eval in number);
  Procedure Sp_cr_inserta_Aqpa190d(pn_eval in number);

  procedure Sp_cr_actualiza(pn_cor in number,
                            pn_pai in number,
                            pn_tdo in number,
                            pc_ndo in char,
                            pd_fec in date);

  Procedure Sp_baja_solicitud(ln_ins in number);
  Procedure sp_proc_masivo;
  Procedure sp_carga(pc_ase in char);
end pq_cr_masivo_aprobad;
/

create or replace package body pq_cr_masivo_aprobad is
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
                               pd_fecPri in date) is
  
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
    ln_eva       number(10);
    --0 se ejecuta proceso de fintech
    --1 se ejecuta proceso de flujo online
  begin
  
    begin
      select 'S'
        into lc_existe
        from aqpa861 j, jaqm750 k
       where j.aqpa861pai = k.jaqm750pai
         and j.aqpa861tdo = k.jaqm750tdo
         and j.aqpa861ndo = k.jaqm750ndo
         and j.aqpa861suc = k.jaqm750suc
         and j.aqpa861mda = k.jaqm750mda
         and j.aqpa861cta = k.jaqm750cta
         and j.aqpa861mod = k.jaqm750mod
         and j.aqpa861top = k.jaqm750tip
         and j.aqpa861pai = pn_pai
         and j.aqpa861tdo = pn_tdo
         and j.aqpa861ndo = pc_ndo
         and j.aqpa861cor = pn_cor --mod@abr 20191210
         and k.jaqm750fch >= j.aqpa861fep
         and rownum = 1;
    exception
      when others then
        null;
    end;
  
    if nvl(lc_existe, 'N') = 'N' then
    
      --**Verifica si es ampliado**--
      begin
        select a.aqpa861tip,
               a.aqpa861moa,
               a.aqpa861sua,
               a.aqpa861maa,
               a.aqpa861paa,
               a.aqpa861caa,
               a.aqpa861opa,
               a.aqpa861sba,
               a.aqpa861toa
          into lc_flgAmpl,
               ln_mod,
               ln_suc,
               ln_mda,
               ln_pap,
               ln_cta,
               ln_ope,
               ln_sbo,
               ln_top
          from aqpa861 a
         where a.aqpa861pai = pn_pai
           and a.aqpa861tdo = pn_tdo
           and a.aqpa861ndo = pc_ndo
           and a.aqpa861cor = pn_cor
           and a.aqpa861fep = pd_fec;
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
    
      if nvl(lc_flgAmpl, 'N') = 'N' then
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
    
      Pq_Cr_masivo_aprobad.Sp_insert_bandeja2(pn_pai    => pn_pai,
                                              pn_tdo    => pn_tdo,
                                              pc_ndo    => pc_ndo,
                                              pd_Fecpro => pd_fecpro,
                                              pc_ase    => pc_ase,
                                              pn_seg    => pn_moe,
                                              pn_cor    => pn_cor,
                                              pd_fecP   => pd_fec);
    
      begin
        select a.aqpa861eva
          into ln_eva
          from aqpa861 a
         where a.aqpa861pai = pn_pai
           and a.aqpa861tdo = pn_tdo
           and a.aqpa861ndo = pc_ndo
           and a.aqpa861cor = pn_cor
           and a.aqpa861fep = pd_fec;
      exception
        when others then
          null;
      end;
    
      Pq_Cr_masivo_aprobad.Sp_insert_bandeja3(pn_pai  => pn_pai,
                                              pn_tdo  => pn_tdo,
                                              pc_ndo  => pc_ndo,
                                              pn_corr => pn_cor,
                                              pd_fecP => pd_fec,
                                              pn_eva  => ln_eva);
    
      if pn_moe = 14 then
        Pq_Cr_masivo_aprobad.Sp_Cr_aqpa190c(ln_eva);
      end if;
    
      Pq_Cr_masivo_aprobad.Sp_cr_inserta_Aqpa190d(ln_eva);
      Pq_Cr_masivo_aprobad.Sp_cr_actualiza(pn_cor => pn_cor,
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
      select a.aqpa861ind, a.aqpa861eva
        into lc_ind, ln_eva
        from aqpa861 a
       where a.aqpa861pai = pn_pai
         and a.aqpa861tdo = pn_tdo
         and a.aqpa861ndo = pc_ndo
         and a.aqpa861cor = pn_cor
         and a.aqpa861fep = pd_fecP;
    exception
      when others then
        null;
    end;
  
    begin
      select 'S'
        into lc_existe
        from aqpa861 j, Aqpa190a k
       where j.aqpa861pai = k.aqpa190apdoc
         and j.aqpa861tdo = k.aqpa190atdoc
         and j.aqpa861ndo = k.aqpa190andoc
         and j.aqpa861ase = k.aqpa190ausu
         and j.aqpa861pai = pn_pai
         and j.aqpa861tdo = pn_tdo
         and j.aqpa861ndo = pc_ndo
         and j.aqpa861cor = pn_cor --mod@abr 20191210
         and j.aqpa861eva = k.aqpa190aeval
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
      select a.aqpa861eva
        into ln_eva
        from aqpa861 a
       where a.aqpa861pai = pn_pai
         and a.aqpa861tdo = pn_tdo
         and a.aqpa861ndo = pc_ndo
         and a.aqpa861cor = pn_corr
         and a.aqpa861fep = pd_fecP;
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

  Procedure Sp_Cr_aqpa190c(pn_eval in number) is
  begin
    begin
      delete from aqpa190c a where a.aqpa190ceval = pn_eval;
    
      commit;
    
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
         where a.aqpa190ceval = pn_eval;
    
      commit;
    end;
  
  end Sp_Cr_aqpa190c;

  Procedure Sp_cr_inserta_Aqpa190d(pn_eval in number) is
  
  begin
  
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
  procedure Sp_cr_actualiza(pn_cor in number,
                            pn_pai in number,
                            pn_tdo in number,
                            pc_ndo in char,
                            pd_fec in date) is
    ld_fec date;
  begin
  
    begin
      select a.pgfape into ld_fec from fst017 a where pgcod = 1;
    exception
      when others then
        null;
    end;
  
    update aqpa861 a
       set a.aqpa861au5 = 'S', a.aqpa861fan = ld_fec
     where a.aqpa861fep = pd_fec
       and a.aqpa861cor = pn_cor
       and a.aqpa861pai = pn_pai
       and a.aqpa861tdo = pn_tdo
       and a.aqpa861ndo = pc_ndo;
    COMMIT;
  end Sp_cr_actualiza;

  Procedure Sp_baja_solicitud(ln_ins in number) is
  
    ln_id number(10);
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
  
  end Sp_baja_solicitud;

  Procedure sp_proc_masivo is
  
    cursor propuestas(cd_fec in date) is
      select * from aqpa861 a where a.aqpa861fep = cd_fec;
  
    ld_fecBI date;
    ld_fec   date;
  
  begin
  
    begin
      select max(a.aqpa861fep) into ld_fecBI from aqpa861 a;
    exception
      when others then
        null;
    end;
  
    begin
      select a.pgfape into ld_fec from fst017 a where a.pgcod = 1;
    exception
      when others then
        null;
    end;
  
    for i in propuestas(ld_fecBI) loop
    
      pq_cr_masivo_aprobad.Sp_insert_bandeja1(pn_pai    => i.aqpa861pai,
                                              pn_tdo    => i.aqpa861tdo,
                                              pc_ndo    => i.aqpa861ndo,
                                              pn_pzo    => i.aqpa861pzo,
                                              pd_fecpro => ld_fec,
                                              pn_mto    => i.aqpa861mto,
                                              pn_cuo    => i.aqpa861cuo,
                                              pn_cta    => i.aqpa861cta,
                                              pc_ase    => i.aqpa861ase,
                                              pn_mod    => i.aqpa861mod,
                                              pn_top    => i.aqpa861top,
                                              pn_suc    => i.aqpa861suc,
                                              pn_mda    => i.aqpa861mda,
                                              pn_cor    => i.aqpa861cor,
                                              pd_fec    => i.aqpa861fep,
                                              pn_moe    => i.aqpa861moe,
                                              pd_fecPri => i.aqpa861feg);
    
      commit;
    end loop;
    commit;
  
  end sp_proc_masivo;

  Procedure sp_carga(pc_ase in char) is
    cursor suplencia(cd_fecpro in date) is
      select SNG057Usr
        from sng057
       Where SNG057Sup = pc_ase
         and SNG057Ini <= cd_fecpro
         and SNG057Fin >= cd_fecpro;
  
    ld_Fecpro date;
  begin
  
    delete from aqpa862 a where a.aqpa862anp = pc_ase;
    commit;
    begin
      select pgfape into ld_Fecpro from fst017 where pgcod = 1;
    exception
      when others then
        null;
    end;
  
    insert into aqpa862
      select a.wfinsprcid, b.sng001ase, b.sng001ase
        from wfwrkitems a, sng001 b
       where a.wfitemstsact = 1
         and a.wfinsprcid = b.sng001inst
         and b.sng001ase = pc_ase;
    commit;
  
    for i in suplencia(ld_Fecpro) loop
    
      insert into aqpa862
        select a.wfinsprcid, b.sng001ase, pc_ase
          from wfwrkitems a, sng001 b
         where a.wfitemstsact = 1
           and a.wfinsprcid = b.sng001inst
           and b.sng001ase = i.SNG057Usr;
      commit;
    
    end loop;
    commit;
  end sp_carga;

end pq_cr_masivo_aprobad;
/

