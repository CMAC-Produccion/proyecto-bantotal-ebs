create or replace package PQ_CR_CONDONACIONES_FSD602 is

  -- Author  : MCANDIA
  -- Created : 14/11/2018  12:51:40 PM.
  -- Purpose : 
  -- Public type declarations

  procedure sp_cr_Condonacion_fsd602(ld_fech_ini in date,
                                     ld_fech_fin in date);

  procedure sp_cr_calcula_condonados(ld_fech_ini in date,
                                     ld_fech_fin in date);

  procedure sp_cr_calcula_cuotas(ld_fech_ini in date, ld_fech_fin in date);

  procedure sp_cr_valida_trax(n_emp      in number,
                              n_mod      in number,
                              n_suc      in number,
                              n_mda      in number,
                              n_pap      in number,
                              n_cta      in number,
                              n_ope      in number,
                              n_sbo      in number,
                              n_top      in number,
                              d_fecuo    in date,
                              Flag_Exist out character);

  procedure sp_cr_carga_jaqz894;

end PQ_CR_CONDONACIONES_FSD602;
/

create or replace package body PQ_CR_CONDONACIONES_FSD602 is

  procedure sp_cr_Condonacion_fsd602(ld_fech_ini in date,
                                     ld_fech_fin in date) is
  
    cursor condonado is
    
      select fsh015.pgcod,
             fsh015.hcmod,
             fsh015.hsucor,
             fsh015.htran,
             fsh015.hnrel,
             fsh015.hfcon,
             fsh015.hhora,
             fsh015.husing
        from fsh015
       where fsh015.pgcod = 1
         and fsh015.hcmod = 30
         and fsh015.htran in (111, 122)
         and fsh015.hfcon between ld_fech_ini and ld_fech_fin
         and fsh015.hccorr <> 99;
  
    ln_emp   number(3);
    ln_mod   number(3);
    ln_suc   number(3);
    ln_mda   number(4);
    ln_pap   number(4);
    ln_cta   number(9);
    ln_ope   number(9);
    ln_sbo   number(3);
    ln_top   number(3);
    ln_ord   number(2);
    ln_rubro number(16);
  begin
  
    for i in condonado loop
      begin
      
        select fsh016.pgcod,
               fsh016.hmodul,
               fsh016.hsucur,
               fsh016.hmda,
               fsh016.hpap,
               fsh016.hcta,
               fsh016.hoper,
               fsh016.hsubop,
               fsh016.htoper,
               fsh016.hcord,
               fsh016.hrubro
          into ln_emp,
               ln_mod,
               ln_suc,
               ln_mda,
               ln_pap,
               ln_cta,
               ln_ope,
               ln_sbo,
               ln_top,
               ln_ord,
               ln_rubro
          from fsh016
         where fsh016.pgcod = i.pgcod
           and fsh016.hcmod = i.hcmod
           and fsh016.hsucor = i.hsucor
           and fsh016.htran = i.htran
           and fsh016.hnrel = i.hnrel
           and fsh016.hfcon = i.hfcon
           and fsh016.hcord = 10;
      
      end;
    
      insert into jaqz893
        (jaqz893pgcod,
         jaqz893ppmod,
         jaqz893ppsuc,
         jaqz893ppmda,
         jaqz893pppap,
         jaqz893ppcta,
         jaqz893ppoper,
         jaqz893ppsbop,
         jaqz893pptope,
         jaqz893d602cd,
         jaqz893d602mo,
         jaqz893d602su,
         jaqz893d602tr,
         jaqz893d602re,
         jaqz893d602fc,
         jaqz893d602hr,
         jaqz893d602us,
         jaqz893d602or,
         jaqz893hrubro)
      values
        (ln_emp,
         ln_mod,
         ln_suc,
         ln_mda,
         ln_pap,
         ln_cta,
         ln_ope,
         ln_sbo,
         ln_top,
         i.pgcod,
         i.hcmod,
         i.hsucor,
         i.htran,
         i.hnrel,
         i.hfcon,
         i.hhora,
         i.husing,
         ln_ord,
         ln_rubro);
      commit;
    end loop;
    commit;
    pq_cr_condonaciones_fsd602.sp_cr_calcula_condonados(ld_fech_ini,
                                                        ld_fech_fin);
  
  end sp_cr_Condonacion_fsd602;

  procedure sp_cr_calcula_condonados(ld_fech_ini in date,
                                     ld_fech_fin in date) is
  
    n_emp      number(3);
    n_mod      number(3);
    n_suc      number(3);
    n_mda      number(4);
    n_pap      number(4);
    n_cta      number(9);
    n_ope      number(9);
    n_sbo      number(3);
    n_top      number(3);
    n_cuota    number(3);
    d_fecuo    date;
    n_capit    number(17, 2);
    n_inter    number(17, 2);
    n_segur    number(17, 2);
    n_icv      number(17, 2);
    n_intmor   number(17, 2);
    n_monto    number(17, 2);
    n_diatr    number(5);
    n_cuot     number(5);
    d_feult    date;
    d_fvto     date;
    refcur     sys_refcursor;
    Flag_Exist character(1);
  
    cursor calculo is
      select *
        from JAQZ893
       where jaqz893.jaqz893d602fc >= ld_fech_ini
         and jaqz893.jaqz893d602fc <= ld_fech_fin;
  
  begin
    for a in calculo loop
      refcur := PQ_CR_CUOTAMORA_COND.Fn_DetalleCuota(a.jaqz893pgcod,
                                                     a.jaqz893ppmod,
                                                     a.jaqz893ppsuc,
                                                     a.jaqz893ppmda,
                                                     a.jaqz893pppap,
                                                     a.jaqz893ppcta,
                                                     a.jaqz893ppoper,
                                                     a.jaqz893ppsbop,
                                                     a.jaqz893pptope,
                                                     a.jaqz893d602cd,
                                                     a.jaqz893d602mo,
                                                     a.jaqz893d602su,
                                                     a.jaqz893d602tr,
                                                     a.jaqz893d602re,
                                                     a.jaqz893d602fc);
    
      LOOP
        fetch refcur
          into n_emp,
               n_mod,
               n_suc,
               n_mda,
               n_pap,
               n_cta,
               n_ope,
               n_sbo,
               n_top,
               n_cuota,
               d_fecuo,
               n_capit,
               n_inter,
               n_segur,
               n_icv,
               n_intmor,
               n_monto,
               n_diatr,
               n_cuot,
               d_feult,
               d_fvto;
      
        exit when refcur%notfound;
      
        pq_cr_condonaciones_fsd602.sp_cr_valida_trax(n_emp,
                                                     n_mod,
                                                     n_suc,
                                                     n_mda,
                                                     n_pap,
                                                     n_cta,
                                                     n_ope,
                                                     n_sbo,
                                                     n_top,
                                                     d_fecuo,
                                                     Flag_Exist);
      
        if Flag_Exist = 'S' then
        
          insert into JAQZ893_aux
            (jaqz893auxpgcod,
             jaqz893auxppmod,
             jaqz893auxppsuc,
             jaqz893auxppmda,
             jaqz893auxpppap,
             jaqz893auxppcta,
             jaqz893auxppoper,
             jaqz893auxppsbop,
             jaqz893auxpptope,
             jaqz893auxcuota,
             jaqz893auxfecuo,
             jaqz893auxcapit,
             jaqz893auxinter,
             jaqz893auxsegur,
             jaqz893auxicv,
             jaqz893auxintmor,
             jaqz893auxmonto,
             jaqz893auxdiatr,
             jaqz893auxcuot,
             jaqz893auxfeult,
             jaqz893auxfvto,
             jaqz893auxpgct,
             jaqz893auxmodt,
             jaqz893auxsuct,
             jaqz893auxtrxt,
             jaqz893auxrelt,
             jaqz893auxfect)
          values
            (n_emp,
             n_mod,
             n_suc,
             n_mda,
             n_pap,
             n_cta,
             n_ope,
             n_sbo,
             n_top,
             n_cuota,
             d_fecuo,
             n_capit,
             n_inter,
             n_segur,
             n_icv,
             n_intmor,
             n_monto,
             n_diatr,
             n_cuot,
             d_feult,
             d_fvto,
             a.jaqz893d602cd,
             a.jaqz893d602mo,
             a.jaqz893d602su,
             a.jaqz893d602tr,
             a.jaqz893d602re,
             a.jaqz893d602fc);
          commit;
        end if;
      END LOOP;
      commit;
      close refcur;
      commit;
    end loop;
  
    pq_cr_condonaciones_fsd602.sp_cr_calcula_cuotas(ld_fech_ini,
                                                    ld_fech_fin);
  end sp_cr_calcula_condonados;

  procedure sp_cr_calcula_cuotas(ld_fech_ini in date, ld_fech_fin in date) is
  
    ln_capi_total  number(17, 2);
    ln_inte_total  number(17, 2);
    ln_mora_total  number(17, 2);
    ln_icv_total   number(17, 2);
    ln_seg_total   number(17, 2);
    ln_icv_cond    number(17, 2);
    ln_mor_cond    number(17, 2);
    ln_stat        number(10);
    ln_dias_atrazo number(5);
    ln_rubro       number(16);
    ln_monto_sumac number(17, 2);
    ln_hor         CHAR(8);
    ln_using       CHAR(10);
    ld_fecha       date;
    lc_usuario     varchar2(50);
    lc_tip_credito char(2);
    Flag_Tipo      char(1);
  
    cursor JAQZ893_aux is
    
      select s.jaqz893auxpgcod,
             s.jaqz893auxppmod,
             s.jaqz893auxppsuc,
             s.jaqz893auxppmda,
             s.jaqz893auxpppap,
             s.jaqz893auxppcta,
             s.jaqz893auxppoper,
             s.jaqz893auxppsbop,
             s.jaqz893auxpptope,
             s.jaqz893auxpgct,
             s.jaqz893auxsuct,
             s.jaqz893auxmodt,
             s.jaqz893auxtrxt,
             s.jaqz893auxrelt,
             s.jaqz893auxfect,
             sum(s.jaqz893auxcapit) jaqz893auxcapit,
             sum(s.jaqz893auxinter) jaqz893auxinter,
             sum(s.jaqz893auxintmor) jaqz893auxintmor,
             sum(s.jaqz893auxicv) jaqz893auxicv,
             sum(s.jaqz893auxsegur) jaqz893auxsegur
        from JAQZ893_aux s
       where s.jaqz893auxfect >= ld_fech_ini
         and s.jaqz893auxfect <= ld_fech_fin
       group by s.jaqz893auxpgcod,
                s.jaqz893auxppmod,
                s.jaqz893auxppsuc,
                s.jaqz893auxppmda,
                s.jaqz893auxpppap,
                s.jaqz893auxppcta,
                s.jaqz893auxppoper,
                s.jaqz893auxppsbop,
                s.jaqz893auxpptope,
                s.jaqz893auxpgct,
                s.jaqz893auxsuct,
                s.jaqz893auxmodt,
                s.jaqz893auxtrxt,
                s.jaqz893auxrelt,
                s.jaqz893auxfect;
  begin
  
    begin
    
      SELECT SysDate, user INTO ld_fecha, lc_usuario FROM dual;
    exception
      when no_data_found then
        ld_fecha   := null;
        lc_usuario := null;
      
    end;
  
    ln_capi_total  := 0.00;
    ln_inte_total  := 0.00;
    ln_mora_total  := 0.00;
    ln_icv_total   := 0.00;
    ln_seg_total   := 0.00;
    ln_icv_cond    := 0.00;
    ln_mor_cond    := 0.00;
    ln_monto_sumac := 0.00;
  
    for f in JAQZ893_aux loop
    
      ln_capi_total := f.jaqz893auxcapit;
      ln_inte_total := f.jaqz893auxinter;
      ln_mora_total := f.jaqz893auxintmor;
      ln_icv_total  := f.jaqz893auxicv;
      ln_seg_total  := f.jaqz893auxsegur;
    
      if f.jaqz893auxtrxt = 111 then
        ln_icv_cond    := f.jaqz893auxicv;
        ln_mor_cond    := f.jaqz893auxintmor;
        ln_monto_sumac := ln_icv_cond + ln_mor_cond;
        Flag_Tipo      := '1';
      
      else
        ln_mor_cond    := f.jaqz893auxintmor;
        ln_icv_cond    := 0.00;
        ln_monto_sumac := ln_icv_cond + ln_mor_cond;
        Flag_Tipo      := '2';
      end if;
    
      begin
      
        select a.jaqy971stat
          into ln_stat
          from jaqy971 a
         where a.jaqy971pgco = f.jaqz893auxpgcod
           and a.jaqy971mod = f.jaqz893auxppmod
           and a.jaqy971sucu = f.jaqz893auxppsuc
           and a.jaqy971mda = f.jaqz893auxppmda
           and a.jaqy971pape = f.jaqz893auxpppap
           and a.jaqy971ncta = f.jaqz893auxppcta
           and a.jaqy971oper = f.jaqz893auxppoper
           and a.jaqy971sbop = f.jaqz893auxppsbop
           and a.jaqy971tope = f.jaqz893auxpptope;
      exception
        when others then
          null;
      end;
    
      begin
        select max(s.jaqz893auxdiatr)
          into ln_dias_atrazo
          from JAQZ893_aux s
         where s.jaqz893auxpgcod = f.jaqz893auxpgcod
           and s.jaqz893auxppmod = f.jaqz893auxppmod
           and s.jaqz893auxppsuc = f.jaqz893auxppsuc
           and s.jaqz893auxppmda = f.jaqz893auxppmda
           and s.jaqz893auxpppap = f.jaqz893auxpppap
           and s.jaqz893auxppcta = f.jaqz893auxppcta
           and s.jaqz893auxppoper = f.jaqz893auxppoper
           and s.jaqz893auxppsbop = f.jaqz893auxppsbop
           and s.jaqz893auxpptope = f.jaqz893auxpptope;
      exception
        when others then
          null;
      end;
    
      begin
      
        select a.jaqz893hrubro,
               a.jaqz893d602hr,
               a.jaqz893d602us,
               substr(a.jaqz893hrubro, 5, 2)
          into ln_rubro, ln_hor, ln_using, lc_tip_credito
          from jaqz893 a
         where a.jaqz893pgcod = f.jaqz893auxpgcod
           and a.jaqz893ppmod = f.jaqz893auxppmod
           and a.jaqz893ppsuc = f.jaqz893auxppsuc
           and a.jaqz893ppmda = f.jaqz893auxppmda
           and a.jaqz893pppap = f.jaqz893auxpppap
           and a.jaqz893ppcta = f.jaqz893auxppcta
           and a.jaqz893ppoper = f.jaqz893auxppoper
           and a.jaqz893ppsbop = f.jaqz893auxppsbop
           and a.jaqz893pptope = f.jaqz893auxpptope;
      exception
        when others then
          null;
      end;
      if Flag_Tipo = '1' then
        insert into aqpa018
          (aqpa018hpgcod,
           aqpa018hmodul,
           aqpa018htoper,
           aqpa018hsucur,
           aqpa018hmda,
           aqpa018hpap,
           aqpa018hcta,
           aqpa018hoper,
           aqpa018hsubop,
           aqpa018mcapitd,
           aqpa018msegud,
           aqpa018motrod,
           aqpa018mpenad,
           aqpa018minmod,
           aqpa018micvd,
           aqpa018mincod,
           aqpa018hrubroc,
           aqpa018mseguc,
           aqpa018motroc,
           aqpa018mpenac,
           aqpa018minmoc,
           aqpa018micvc,
           aqpa018mincoc,
           aqpa018mcapitc,
           aqpa018msumac,
           aqpa018statc,
           aqpa018mcapip,
           aqpa018msegup,
           aqpa018motrop,
           aqpa018mpenap,
           aqpa018minmop,
           aqpa018micvp,
           aqpa018mincop,
           aqpa018tipcre,
           aqpa018diaatr,
           aqpa018fecint,
           aqpa018nroexp,
           aqpa018acupag,
           aqpa018dacupag,
           aqpa018canesp,
           aqpa018ipgcod,
           aqpa018itmod,
           aqpa018itsuc,
           aqpa018ittran,
           aqpa018itnrel,
           aqpa018itfcon,
           aqpa018ithora,
           aqpa018itucnf,
           aqpa018usuact,
           aqpa018fecact,
           aqpa018est)
        values
          (f.jaqz893auxpgcod,
           f.jaqz893auxppmod,
           f.jaqz893auxpptope,
           f.jaqz893auxppsuc,
           f.jaqz893auxppmda,
           f.jaqz893auxpppap,
           f.jaqz893auxppcta,
           f.jaqz893auxppoper,
           f.jaqz893auxppsbop,
           ln_capi_total,
           ln_seg_total,
           0.00,
           0.00,
           ln_mora_total,
           ln_icv_total,
           ln_inte_total,
           ln_rubro,
           0.00,
           0.00,
           0.00,
           ln_mor_cond,
           ln_icv_cond,
           0.00,
           0.00,
           ln_monto_sumac,
           ln_stat,
           ln_capi_total,
           ln_seg_total,
           0.00,
           0.00,
           0.00,
           0.00,
           ln_inte_total,
           lc_tip_credito,
           ln_dias_atrazo,
           null,
           null,
           null,
           null,
           null,
           f.jaqz893auxpgct,
           f.jaqz893auxmodt,
           f.jaqz893auxsuct,
           f.jaqz893auxtrxt,
           f.jaqz893auxrelt,
           f.jaqz893auxfect,
           ln_hor,
           ln_using,
           lc_usuario,
           ld_fecha,
           'C');
        commit;
      else
        insert into aqpa018
          (aqpa018hpgcod,
           aqpa018hmodul,
           aqpa018htoper,
           aqpa018hsucur,
           aqpa018hmda,
           aqpa018hpap,
           aqpa018hcta,
           aqpa018hoper,
           aqpa018hsubop,
           aqpa018mcapitd,
           aqpa018msegud,
           aqpa018motrod,
           aqpa018mpenad,
           aqpa018minmod,
           aqpa018micvd,
           aqpa018mincod,
           aqpa018hrubroc,
           aqpa018mseguc,
           aqpa018motroc,
           aqpa018mpenac,
           aqpa018minmoc,
           aqpa018micvc,
           aqpa018mincoc,
           aqpa018mcapitc,
           aqpa018msumac,
           aqpa018statc,
           aqpa018mcapip,
           aqpa018msegup,
           aqpa018motrop,
           aqpa018mpenap,
           aqpa018minmop,
           aqpa018micvp,
           aqpa018mincop,
           aqpa018tipcre,
           aqpa018diaatr,
           aqpa018fecint,
           aqpa018nroexp,
           aqpa018acupag,
           aqpa018dacupag,
           aqpa018canesp,
           aqpa018ipgcod,
           aqpa018itmod,
           aqpa018itsuc,
           aqpa018ittran,
           aqpa018itnrel,
           aqpa018itfcon,
           aqpa018ithora,
           aqpa018itucnf,
           aqpa018usuact,
           aqpa018fecact,
           aqpa018est)
        values
          (f.jaqz893auxpgcod,
           f.jaqz893auxppmod,
           f.jaqz893auxpptope,
           f.jaqz893auxppsuc,
           f.jaqz893auxppmda,
           f.jaqz893auxpppap,
           f.jaqz893auxppcta,
           f.jaqz893auxppoper,
           f.jaqz893auxppsbop,
           ln_capi_total,
           ln_seg_total,
           0.00,
           0.00,
           ln_mora_total,
           ln_icv_total,
           ln_inte_total,
           ln_rubro,
           0.00,
           0.00,
           0.00,
           ln_mor_cond,
           ln_icv_cond,
           0.00,
           0.00,
           ln_monto_sumac,
           ln_stat,
           ln_capi_total,
           ln_seg_total,
           0.00,
           0.00,
           0.00,
           ln_icv_total,
           ln_inte_total,
           lc_tip_credito,
           ln_dias_atrazo,
           null,
           null,
           null,
           null,
           null,
           f.jaqz893auxpgct,
           f.jaqz893auxmodt,
           f.jaqz893auxsuct,
           f.jaqz893auxtrxt,
           f.jaqz893auxrelt,
           f.jaqz893auxfect,
           ln_hor,
           ln_using,
           lc_usuario,
           ld_fecha,
           'C');
        commit;
      
      end if;
    
    end loop;
    commit;
  end sp_cr_calcula_cuotas;

  procedure sp_cr_valida_trax(n_emp      in number,
                              n_mod      in number,
                              n_suc      in number,
                              n_mda      in number,
                              n_pap      in number,
                              n_cta      in number,
                              n_ope      in number,
                              n_sbo      in number,
                              n_top      in number,
                              d_fecuo    in date,
                              Flag_Exist out character) is
  
    ln_mod   NUMBER(3);
    ln_tranx NUMBER(3);
  
  begin
    begin
      select fsd602.d602mo, fsd602.d602tr
        into ln_mod, ln_tranx
        from fsd602
       where fsd602.pgcod = n_emp
         and fsd602.ppmod = n_mod
         and fsd602.ppsuc = n_suc
         and fsd602.ppmda = n_mda
         and fsd602.pppap = n_pap
         and fsd602.ppcta = n_cta
         and fsd602.ppoper = n_ope
         and fsd602.ppsbop = n_sbo
         and fsd602.pptope = n_top
         and fsd602.ppfpag = d_fecuo
         and fsd602.d602co = 'S'
         and fsd602.pp1stat = 'T';
    
    exception
      when others then
        null;
    end;
  
    if ln_mod = 30 and ln_tranx in (111, 122) then
      Flag_Exist := 'S';
    end if;
  
  end sp_cr_valida_trax;

  procedure sp_cr_carga_jaqz894 is
  
    ln_corr number(10);
    ln_cont number(10);
  
    cursor fsd011 is
      select *
        from fsd011 f
       where f.pgcod = 1
         and f.scmod in (select Tp1nro1
                           from Fst198
                          Where Tp1cod = 1
                            and Tp1cod1 = 11105
                            and Tp1corr1 = 13
                            and Tp1corr2 = 2)
         and f.scsdo <> 0.00;
  
  begin
  
    for j in fsd011 loop
    
      begin
        select count(*) into ln_cont from jaqz894;
      exception
        when others then
          null;
      end;
    
      if ln_cont >= 1 then
        begin
          select max(jaqz894cor) into ln_corr from jaqz894;
        exception
          when others then
            null;
        end;
      
      else
        ln_corr := 0;
      end if;
      ln_corr := ln_corr + 1;
    
      insert into jaqz894
        (jaqz894cor,
         jaqz894emp,
         jaqz894mod,
         jaqz894suc,
         jaqz894mda,
         jaqz894pap,
         jaqz894cta,
         jaqz894ope,
         jaqz894sbo,
         jaqz894top,
         jaqz894est,
         jaqz894rub,
         jaqz894sdo,
         jaqz894fep,
         jaqz894ind,
         jaqz894modulo)
      values
        (ln_corr,
         j.pgcod,
         j.scmod,
         j.scsuc,
         j.scmda,
         j.scpap,
         j.sccta,
         j.scoper,
         j.scsbop,
         j.sctope,
         j.scstat,
         j.scrub,
         j.scsdo,
         j.scfcon,
         '1',
         j.scmod);
      commit;
    
    end loop;
  end sp_cr_carga_jaqz894;

end PQ_CR_CONDONACIONES_FSD602;
/

