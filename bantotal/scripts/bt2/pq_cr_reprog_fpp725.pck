create or replace package PQ_CR_REPROG_FPP725 is

  -- Author  : CHERNANDEZ
  -- Created : 27/07/2020 18:13:50
  -- Modified : DCASTRO - 24/01/2020 creo procedimientos sp_pago_FPP725, sp_retorna_pago_FPP725, sp_anula_jaqz698, sp_actualiza_est_fpp725, sp_actualiza_est_jaqz698

  -- Public type declarations
  procedure sp_ejecucion_bk(pd_fec date);
  Procedure Sp_CR_BACKUP_AQPB011(pn_emp in number,
                                 pn_mod in number,
                                 pn_suc in number,
                                 pn_mda in number,
                                 pn_pap in number,
                                 pn_cta in number,
                                 pn_ope in number,
                                 pn_sbo in number,
                                 pn_top in number,
                                 pd_fec in date,
                                 pn_cor in number);
  Procedure Sp_controlFPP725(pd_Fecpro in date);
  
  procedure sp_pago_FPP725(pd_fec date) ;

  procedure sp_retorna_pago_FPP725(pd_fec date);
  
  procedure sp_anula_jaqz698(pd_fec date) ;
  
  procedure sp_actualiza_est_fpp725(pd_fec date) ;
  
  procedure sp_actualiza_est_jaqz698(pd_fec date) ;
  
end PQ_CR_REPROG_FPP725;
/

create or replace package body PQ_CR_REPROG_FPP725 is
  procedure sp_ejecucion_bk(pd_fec date) is
    cursor creditos is
      select *
        from fpp725 a
       where a.fpp725fep = pd_fec
         and a.fpp725pro = 'I';
    ln_contador number(5);
  begin
    ln_contador := 1;
    for i in creditos loop
      --ln_contador := ln_contador + 1;
      Sp_CR_BACKUP_AQPB011(i.fpp725emp,
                           i.fpp725mod,
                           i.fpp725suc,
                           i.fpp725mda,
                           i.fpp725pap,
                           i.fpp725cta,
                           i.fpp725ope,
                           i.fpp725sop,
                           i.fpp725top,
                           i.fpp725fep,
                           ln_contador);
    end loop;
  end sp_ejecucion_bk;
  Procedure Sp_CR_BACKUP_AQPB011(pn_emp in number,
                                 pn_mod in number,
                                 pn_suc in number,
                                 pn_mda in number,
                                 pn_pap in number,
                                 pn_cta in number,
                                 pn_ope in number,
                                 pn_sbo in number,
                                 pn_top in number,
                                 pd_fec in date,
                                 pn_cor in number) is
  
  begin
    begin
      delete from AQPB011_010C a
       where a.pgcod = pn_emp
         and a.aomod = pn_mod
         and a.aosuc = pn_suc
         and a.aomda = pn_mda
         and a.aopap = pn_pap
         and a.aocta = pn_cta
         and a.aooper = pn_ope
         and a.aosbop = pn_sbo
         and a.aotope = pn_top
         and a.fec = pd_fec
         and a.cor = pn_cor;
    
      delete from AQPB011_011C a
       where a.pgcod = pn_emp
         and a.scmod = pn_mod
         and a.scsuc = pn_suc
         and a.scmda = pn_mda
         and a.scpap = pn_pap
         and a.sccta = pn_cta
         and a.scoper = pn_ope
         and a.scsbop = pn_sbo
         and a.sctope = pn_top
         and a.fec = pd_fec
         and a.cor = pn_cor;
    
      delete from AQPB011_601C a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.fec = pd_fec
         and a.cor = pn_cor;
    
      delete from AQPB011_611C a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.fec = pd_fec
         and a.cor = pn_cor;
    
      delete from AQPB011_602C a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.fec = pd_fec
         and a.cor = pn_cor;
    
      delete from AQPB011_612C a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.fec = pd_fec
         and a.cor = pn_cor;
    
      delete from AQPB011_003C a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.fec = pd_fec
         and a.cor = pn_cor;
    
      delete from AQPB011_002C a
       where a.pgcod = pn_emp
         and a.ppmod = pn_mod
         and a.ppsuc = pn_suc
         and a.ppmda = pn_mda
         and a.pppap = pn_pap
         and a.ppcta = pn_cta
         and a.ppoper = pn_ope
         and a.ppsbop = pn_sbo
         and a.pptope = pn_top
         and a.fec = pd_fec
         and a.cor = pn_cor;
    
      delete from AQPB011_012C a
       where a.pgcod = pn_emp
         and a.aomod = pn_mod
         and a.aosuc = pn_suc
         and a.aomda = pn_mda
         and a.aopap = pn_pap
         and a.aocta = pn_cta
         and a.aooper = pn_ope
         and a.aosbop = pn_sbo
         and a.aotope = pn_top
         and a.fec = pd_fec
         and a.cor = pn_cor;
    
      delete from AQPB011_001C a
       where a.pgcod = pn_emp
         and a.aomod = pn_mod
         and a.aosuc = pn_suc
         and a.aomda = pn_mda
         and a.aopap = pn_pap
         and a.aocta = pn_cta
         and a.aooper = pn_ope
         and a.aosbop = pn_sbo
         and a.aotope = pn_top
         and a.fec = pd_fec
         and a.cor = pn_cor;
    
      insert into AQPB011_010C
        select a.*, pd_fec, pn_cor
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
    
      insert into AQPB011_011C
        select a.*, pd_fec, pn_cor
          from fsd011 a
         where a.pgcod = pn_emp
           and a.scmod = pn_mod
           and a.scsuc = pn_suc
           and a.scmda = pn_mda
           and a.scpap = pn_pap
           and a.sccta = pn_cta
           and a.scoper = pn_ope
           and a.scsbop = pn_sbo
           and a.sctope = pn_top;
    
      insert into AQPB011_601C
        select a.*, pd_fec, pn_cor
          from fsd601 a
         where a.pgcod = pn_emp
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top;
    
      insert into AQPB011_611C
        select a.*, pd_fec, pn_cor
          from fsd611 a
         where a.pgcod = pn_emp
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top;
    
      insert into AQPB011_602C
        select a.*, pd_fec, pn_cor
          from fsd602 a
         where a.pgcod = pn_emp
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top;
    
      insert into AQPB011_612C
        select a.*, pd_fec, pn_cor
          from fsd612 a
         where a.pgcod = pn_emp
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top;
    
      insert into AQPB011_003C
        select a.*, pd_fec, pn_cor
          from fpp003 a
         where a.pgcod = pn_emp
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top;
    
      insert into AQPB011_002C
        select a.*, pd_fec, pn_cor
          from fpp002 a
         where a.pgcod = pn_emp
           and a.ppmod = pn_mod
           and a.ppsuc = pn_suc
           and a.ppmda = pn_mda
           and a.pppap = pn_pap
           and a.ppcta = pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top;
    
      insert into AQPB011_012C
        select a.*, pd_fec, pn_cor
          from fsd012 a
         where a.pgcod = pn_emp
           and a.aomod = pn_mod
           and a.aosuc = pn_suc
           and a.aomda = pn_mda
           and a.aopap = pn_pap
           and a.aocta = pn_cta
           and a.aooper = pn_ope
           and a.aosbop = pn_sbo
           and a.aotope = pn_top;
    
      insert into AQPB011_001C
        select a.*, pd_fec, pn_cor
          from fpp001 a
         where a.pgcod = pn_emp
           and a.aomod = pn_mod
           and a.aosuc = pn_suc
           and a.aomda = pn_mda
           and a.aopap = pn_pap
           and a.aocta = pn_cta
           and a.aooper = pn_ope
           and a.aosbop = pn_sbo
           and a.aotope = pn_top;
      commit;
    exception
      when others then
        null;
    end;
  
  end Sp_CR_BACKUP_AQPB011;

  Procedure Sp_controlFPP725(pd_Fecpro in date) is
  
    cursor creditos is
      select *
        from fpp725 a
       where a.fpp725fep = pd_Fecpro
         and a.fpp725pro = 'I';
  
    ld_fecpxv   date;
    ln_cont     number(10);
    ln_perio    number(5);
    ln_mto      number(17, 2);
    ln_seg      number(17, 2);
    ln_cuo1     number(17, 2);
    ln_cuota    number(17, 2);
    lc_pago     char(1) := 'N';
    lc_flujo    char(1) := 'N';
    ld_fecval   date;
    ln_estado   number(2);
    ln_contador number(10);
    lc_fpp      char(1) := 'N';
    lc_valida   char(1);
  begin
    pq_cr_reprog_fpp725.sp_ejecucion_bk(pd_Fecpro);
  
    for i in creditos loop
      ld_fecpxv   := null;
      ln_cont     := 0;
      ln_perio    := null;
      ln_mto      := 0;
      ln_seg      := 0;
      ln_cuo1     := 0;
      ln_cuota    := 0;
      ld_fecval   := null;
      ln_estado   := null;
      ln_contador := 0;
      lc_pago     := 'N';
      lc_flujo    := 'N';
      lc_fpp      := 'N';
    
      begin
        select 'S'
          into lc_pago
          from fsd602 a
         where a.pgcod = i.fpp725emp
           and a.ppmod = i.fpp725mod
           and a.ppsuc = i.fpp725suc
           and a.ppmda = i.fpp725mda
           and a.pppap = i.fpp725pap
           and a.ppcta = i.fpp725cta
           and a.ppoper = i.fpp725ope
           and a.ppsbop = i.fpp725sop
           and a.pptope = i.fpp725top
           and a.pp1fech >= i.fpp725fep
           and a.d602co = 'S';
      exception
        when others then
          null;
      end;
    
      pq_Cr_tablaJAQA250.sp_cr_flujocaja(ln_emp10  => i.fpp725emp,
                                         ln_mod10  => i.fpp725mod,
                                         ln_suc10  => i.fpp725suc,
                                         ln_mda10  => i.fpp725mda,
                                         ln_pap10  => i.fpp725pap,
                                         ln_cta10  => i.fpp725cta,
                                         ln_oper10 => i.fpp725ope,
                                         ln_sbop10 => i.fpp725sop,
                                         ln_tope10 => i.fpp725top,
                                         ln_flagFC => lc_flujo);
    
      begin
        select 'S'
          into lc_fpp
          from fpp002 a
         where a.pgcod = i.fpp725emp
           and a.ppmod = i.fpp725mod
           and a.ppsuc = i.fpp725suc
           and a.ppmda = i.fpp725mda
           and a.pppap = i.fpp725pap
           and a.ppcta = i.fpp725cta
           and a.ppoper = i.fpp725ope
           and a.ppsbop = i.fpp725sop
           and a.pptope = i.fpp725top
           and rownum = 1;
      
      exception
        when others then
          lc_fpp := 'N';
      end;
    
      begin
        select count(*)
          into ln_contador
          from fsd601 a
         where a.pgcod = i.fpp725emp
           and a.ppmod = i.fpp725mod
           and a.ppsuc = i.fpp725suc
           and a.ppmda = i.fpp725mda
           and a.pppap = i.fpp725pap
           and a.ppcta = i.fpp725cta
           and a.ppoper = i.fpp725ope
           and a.ppsbop = i.fpp725sop
           and a.pptope = i.fpp725top
           and a.d601co = 'S';
      exception
        when others then
          null;
      end;
    
      begin
        select a.aoperiod, a.aostat
          into ln_perio, ln_estado
          from fsd010 a
         where a.pgcod = i.fpp725emp
           and a.aomod = i.fpp725mod
           and a.aosuc = i.fpp725suc
           and a.aomda = i.fpp725mda
           and a.aopap = i.fpp725pap
           and a.aocta = i.fpp725cta
           and a.aooper = i.fpp725ope
           and a.aosbop = i.fpp725sop
           and a.aotope = i.fpp725top;
      exception
        when others then
          null;
      end;
    
      begin
        select min(n.ppfpag)
          into ld_fecpxv
          from fsd601 n
         where n.pgcod = i.fpp725emp
           and n.ppcta = i.fpp725cta
           and n.ppmda = i.fpp725mda
           and n.ppsuc = i.fpp725suc
           and n.pppap = i.fpp725pap
           and n.ppoper = i.fpp725ope
           and n.ppsbop = i.fpp725sop
           and n.pptope = i.fpp725top
           and n.ppmod = i.fpp725mod
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
      
        select count(*)
          into ln_cont
          from fsd601 n
         where n.pgcod = i.fpp725emp
           and n.ppcta = i.fpp725cta
           and n.ppmda = i.fpp725mda
           and n.ppsuc = i.fpp725suc
           and n.pppap = i.fpp725pap
           and n.ppoper = i.fpp725ope
           and n.ppsbop = i.fpp725sop
           and n.pptope = i.fpp725top
           and n.ppmod = i.fpp725mod
           and n.d601co = 'S'
           and (n.ppcap + n.ppint) <> 0
           and n.ppfpag >= ld_fecpxv;
      exception
        when others then
          null;
      end;
    
      if nvl(ln_estado, 99) = 99 or nvl(ln_contador, 0) = 1 or
         nvl(lc_pago, 'N') = 'S' or nvl(lc_flujo, 'N') = 'S' or
         nvl(ln_estado, 33) = 33 or nvl(lc_fpp, 'N') = 'S' OR
         nvl(ln_cont, 0) = 1 then
      
        lc_valida := 'N';
      
        update fpp725 a
           set a.fpp725pro = lc_valida
         where a.fpp725emp = i.fpp725emp
           and a.fpp725mod = i.fpp725mod
           and a.fpp725suc = i.fpp725suc
           and a.fpp725mda = i.fpp725mda
           and a.fpp725pap = i.fpp725pap
           and a.fpp725cta = i.fpp725cta
           and a.fpp725ope = i.fpp725ope
           and a.fpp725sop = i.fpp725sop
           and a.fpp725top = i.fpp725top
           and a.fpp725fep = i.fpp725fep;
      
        commit;
      
      end if;
    end loop;
    commit;
  end Sp_controlFPP725;
--------------------------

 procedure sp_pago_FPP725(pd_fec date) is
 
  cursor creditos is
    select *
      from fpp725 f
     where f.fpp725fep = pd_fec --fecha proceso
       and f.fpp725pro = 'I';

  ld_maxpag date;
  lc_stat   char(1);
  lc_flg    char(1);
  ln_cap    number(17, 2);
  lc_flgCap char(1);
  lc_est    char(1);

  cursor cuotas_parc(pn_emp    in number,
                     pn_mod    in number,
                     pn_suc    in number,
                     pn_mda    in number,
                     pn_pap    in number,
                     pn_cta    in number,
                     pn_ope    in number,
                     pn_sbo    in number,
                     pn_top    in number,
                     ld_maxpag in date) is
    select *
      from fsd602 a
     where a.pgcod = pn_emp
       and a.ppmod = pn_mod
       and a.ppsuc = pn_suc
       and a.ppmda = pn_mda
       and a.pppap = pn_pap
       and a.ppcta = pn_cta
       and a.ppoper = pn_ope
       and a.ppsbop = pn_sbo
       and a.pptope = pn_top
       and a.ppfpag = ld_maxpag
       and a.pp1stat = 'P'
       and a.d602co = 'S';
BEGIN

  for i in creditos loop
    --verifica si es parcial
    begin
      select max(a.ppfpag)
        into ld_maxpag
        from fsd602 a
       where a.pgcod = i.fpp725emp
         and a.ppmod = i.fpp725mod
         and a.ppsuc = i.fpp725suc
         and a.ppmda = i.fpp725mda
         and a.pppap = i.fpp725pap
         and a.ppcta = i.fpp725cta
         and a.ppoper = i.fpp725ope
         and a.ppsbop = i.fpp725sop
         and a.pptope = i.fpp725top
         and a.d602co = 'S';
    exception
      when too_many_rows then
        begin
          select max(a.ppfpag)
            into ld_maxpag
            from fsd602 a
           where a.pgcod = i.fpp725emp
             and a.ppmod = i.fpp725mod
             and a.ppsuc = i.fpp725suc
             and a.ppmda = i.fpp725mda
             and a.pppap = i.fpp725pap
             and a.ppcta = i.fpp725cta
             and a.ppoper = i.fpp725ope
             and a.ppsbop = i.fpp725sop
             and a.pptope = i.fpp725top
             and a.d602co = 'S'
             and rownum = 1;
        exception
          when others then
            null;
        end;
      when others then
        null;
    end;
  
    if ld_maxpag is not null then
      begin
        select 'T'
          into lc_stat
          from fsd602 a
         where a.pgcod = i.fpp725emp
           and a.ppmod = i.fpp725mod
           and a.ppsuc = i.fpp725suc
           and a.ppmda = i.fpp725mda
           and a.pppap = i.fpp725pap
           and a.ppcta = i.fpp725cta
           and a.ppoper = i.fpp725ope
           and a.ppsbop = i.fpp725sop
           and a.pptope = i.fpp725top
           and a.ppfpag = ld_maxpag
           and a.pp1stat = 'T'
           and a.d602co = 'S';
      exception
        when others then
          null;
      end;
      if lc_stat = 'T' then
        lc_flg := 'S';
      else
        lc_flg := 'P';
      end if;
    else
      lc_flg := 'S';
    end if;
  
    ---valida si el pago parcial es de capital
    if lc_flg = 'P' then
    
      begin
        select sum(a.pp1cap)
          into ln_cap
          from fsd602 a
         where a.pgcod = i.fpp725emp
           and a.ppmod = i.fpp725mod
           and a.ppsuc = i.fpp725suc
           and a.ppmda = i.fpp725mda
           and a.pppap = i.fpp725pap
           and a.ppcta = i.fpp725cta
           and a.ppoper = i.fpp725ope
           and a.ppsbop = i.fpp725sop
           and a.pptope = i.fpp725top
           and a.ppfpag = ld_maxpag
           and a.pp1stat = 'P'
           and a.d602co = 'S';
      exception
        when others then
          null;
      end;
    
      if nvl(ln_cap, 0) <> 0 then
        lc_flgCap := 'S';
      else
        lc_flgCap := 'N';
      end if;
    end if;
  
    if lc_flg = 'P' and lc_flgCap = 'S' then
      lc_est := 'R';
      ---actualizar lnueva tabla
      update FPP725 a
         set a.fpp725pro = 'R'
       where a.fpp725fep = i.fpp725fep
         and a.fpp725emp = i.fpp725emp
         and a.fpp725mod = i.fpp725mod
         and a.fpp725suc = i.fpp725suc
         and a.fpp725mda = i.fpp725mda
         and a.fpp725pap = i.fpp725pap
         and a.fpp725cta = i.fpp725cta
         and a.fpp725ope = i.fpp725ope
         and a.fpp725sop = i.fpp725sop
         and a.fpp725top = i.fpp725top;
      commit;
    
    end if;
  
    if nvl(lc_flgCap, 'N') = 'N' and lc_flg = 'P' then
      --- pago parcial sin pago de capital
    
      insert into FPP725B
        (FPP725Bemp,
         FPP725Bmod,
         FPP725Bsuc,
         FPP725Bmda,
         FPP725Bpap,
         FPP725Bcta,
         FPP725Bope,
         FPP725Bsop,
         FPP725Btop,
         FPP725Bfep,
         FPP725Best)
      values
        (i.fpp725emp,
         i.fpp725mod,
         i.fpp725suc,
         i.fpp725mda,
         i.fpp725pap,
         i.fpp725cta,
         i.fpp725ope,
         i.fpp725sop,
         i.fpp725top,
         i.fpp725fep,
         'P');
      commit;
    end if;
  
    --actualizo calendario de pago
    delete from JAQZ699B a
     where a.jaqz699_fec = i.fpp725fep
       and a.jaqz699pgcod = i.fpp725emp
       and a.jaqz699mod = i.fpp725mod
       and a.jaqz699suc = i.fpp725suc
       and a.jaqz699mda = i.fpp725mda
       and a.jaqz699pap = i.fpp725pap
       and a.jaqz699cta = i.fpp725cta
       and a.jaqz699oper = i.fpp725ope
       and a.jaqz699sbop = i.fpp725sop
       and a.jaqz699tope = i.fpp725top;
    commit;
    begin
      insert into JAQZ699B
        select i.fpp725fep, 1, a.*
          from fsd602 a
         where a.pgcod = i.fpp725emp
           and a.ppmod = i.fpp725mod
           and a.ppsuc = i.fpp725suc
           and a.ppmda = i.fpp725mda
           and a.pppap = i.fpp725pap
           and a.ppcta = i.fpp725cta
           and a.ppoper = i.fpp725ope
           and a.ppsbop = i.fpp725sop
           and a.pptope = i.fpp725top
           and a.ppfpag = ld_maxpag
           and a.pp1stat = 'P'
           and a.d602co = 'S';
    end;
    commit;
  
  
    for x in cuotas_parc(i.fpp725emp,
                         i.fpp725mod,
                         i.fpp725suc,
                         i.fpp725mda,
                         i.fpp725pap,
                         i.fpp725cta,
                         i.fpp725ope,
                         i.fpp725sop,
                         i.fpp725top,
                         ld_maxpag) loop
    
      update fsd602 a
         set a.d602co = 'E'
       where a.pgcod = x.pgcod
         and a.ppmod = x.ppmod
         and a.ppsuc = x.ppsuc
         and a.ppmda = x.ppmda
         and a.pppap = x.pppap
         and a.ppcta = x.ppcta
         and a.ppoper = x.ppoper
         and a.ppsbop = x.ppsbop
         and a.pptope = x.pptope
         and a.pp1nump = x.pp1nump
         and a.ppfpag = ld_maxpag
         and a.pp1stat = 'P'
         and a.d602co = 'S';
    
      commit;
    
    end loop;
  
  end loop;

   
 end sp_pago_FPP725;


procedure sp_retorna_pago_FPP725(pd_fec date) is
  
    cursor bk is
      select *
        from JAQZ699B a
       where a.jaqz699_fec = pd_fec;
  
    lc_err char(1) := 'N';
    pd_fecIn date;
    
  begin
  
      for i in bk loop

        begin
          select min(a.ppfpag) 
          into pd_fecIn
          from fsd601 a
           where a.pgcod = i.jaqz699pgcod
             and a.ppmod = i.jaqz699mod
             and a.ppsuc = i.jaqz699suc
             and a.ppmda = i.jaqz699mda
             and a.pppap = i.jaqz699pap
             and a.ppcta = i.jaqz699cta
             and a.ppoper = i.jaqz699oper
             and a.ppsbop = i.jaqz699sbop
             and a.pptope = i.jaqz699tope
             and a.ppfpag >= i.jaqz699fpag;
       exception when others then
           pd_fecIn := null;    
       end;      

      
        begin
          update fsd612 a
             set a.ppfpag = pd_fecIn
           where a.pgcod =  i.jaqz699pgcod
             and a.ppmod =  i.jaqz699mod
             and a.ppsuc =  i.jaqz699suc
             and a.ppmda =  i.jaqz699mda
             and a.pppap =  i.jaqz699pap
             and a.ppcta =  i.jaqz699cta
             and a.ppoper = i.jaqz699oper
             and a.ppsbop = i.jaqz699sbop
             and a.pptope = i.jaqz699tope
             and a.pp1nump = i.jaqz699nump;
        
          commit;
        exception
          when others then
            lc_err := 'S';
          
            update FPP725B a
               set a.fpp725best = 'E' --no se puedo actualizar fsd612
             where a.fpp725bemp = i.jaqz699pgcod
               and a.fpp725bmod = i.jaqz699mod
               and a.fpp725bsuc = i.jaqz699suc
               and a.fpp725bmda = i.jaqz699mda
               and a.fpp725bpap = i.jaqz699pap
               and a.fpp725bcta = i.jaqz699cta
               and a.fpp725bope = i.jaqz699oper
               and a.fpp725bsop = i.jaqz699sbop
               and a.fpp725btop = i.jaqz699tope
               and a.fpp725bfep = i.jaqz699_fec;

            commit;
        end;
        begin
          update fsd602 a
             set a.ppfpag = pd_fecIn, a.d602co = 'S'
           where a.pgcod = i.jaqz699pgcod
             and a.ppmod = i.jaqz699mod
             and a.ppsuc = i.jaqz699suc
             and a.ppmda = i.jaqz699mda
             and a.pppap = i.jaqz699pap
             and a.ppcta = i.jaqz699cta
             and a.ppoper = i.jaqz699oper
             and a.ppsbop = i.jaqz699sbop
             and a.pptope = i.jaqz699tope
             and a.pp1nump = i.jaqz699nump
             and a.d602co = 'E';
        
          commit;
        exception
          when others then
            lc_err := 'S';
          
            update FPP725B a
               set a.fpp725best = 'F' --no se puedo actualizar fsd602
             where a.fpp725bemp = i.jaqz699pgcod
               and a.fpp725bmod = i.jaqz699mod
               and a.fpp725bsuc = i.jaqz699suc
               and a.fpp725bmda = i.jaqz699mda
               and a.fpp725bpap = i.jaqz699pap
               and a.fpp725bcta = i.jaqz699cta
               and a.fpp725bope = i.jaqz699oper
               and a.fpp725bsop = i.jaqz699sbop
               and a.fpp725btop = i.jaqz699tope
               and a.fpp725bfep = i.jaqz699_fec;

          
            commit;
        end;
      end loop;
    commit;


end sp_retorna_pago_FPP725;


procedure sp_anula_jaqz698(pd_fec date)  is
--Ejecutar este procedimiento para todos los que estan en `E¿ en la jaqz698 con la fecha del proceso

CURSOR CREDITOS IS 
select * from FPP725 F WHERE F.FPP725PRO = 'E' and F.FPP725FEP = pd_fec; --FECHA DE PROCESO


CURSOR TAB_JAQZ698 IS 
select * from JAQZ698 F WHERE F.JAQZ698EST = 'E' and F.JAQZ698FEP = pd_fec; --FECHA DE PROCESO


BEGIN

       for i in creditos loop
           begin
             update jaqz698 j
               SET J.JAQZ698EST = 'E' --NO PROCESAR POR ERROR EN FPP725
              WHERE j.jaqz698fep = i.FPP725FEP
               AND j.jaqz698emp = i.FPP725EMP
               AND j.jaqz698mod = i.FPP725MOD
               AND j.jaqz698suc = i.FPP725SUC
               AND j.jaqz698mda = i.FPP725MDA
               AND j.jaqz698pap = i.FPP725PAP
               AND j.jaqz698cta = i.FPP725CTA
               AND j.jaqz698ope = i.FPP725OPE
               AND j.jaqz698sbo = i.FPP725SOP
               AND j.jaqz698top = i.FPP725TOP;
               
               COMMIT;
           exception when others then
             null;
           end;       
       
       end loop;  
       
       ---extornando cronograma con error
       for i in TAB_JAQZ698 loop
           begin
               SP_CR_ANULREPROMASIVCCAPIT(i.JAQZ698FEP,i.jaqz698cor);
          end;
       
       end loop;
  
end sp_anula_jaqz698;

procedure sp_actualiza_est_fpp725(pd_fec date) is


CURSOR CREDITOS IS 
select * from JAQZ698 F WHERE  F.JAQZ698FEP = pd_fec AND F.JAQZ698EST <> 'C';

BEGIN

       for i in creditos loop
           begin
             update FPP725 j
               SET J.FPP725PRO = 'T' --NO PROCESAR POR ERROR EN JAQZ698
             WHERE J.FPP725FEP = i.jaqz698fep 
               AND J.FPP725EMP = i.jaqz698emp 
               AND J.FPP725MOD = i.jaqz698mod  
               AND J.FPP725SUC = i.jaqz698suc  
               AND J.FPP725MDA = i.jaqz698mda  
               AND J.FPP725PAP = i.jaqz698pap  
               AND J.FPP725CTA = i.jaqz698cta  
               AND J.FPP725OPE = i.jaqz698ope  
               AND J.FPP725SOP = i.jaqz698sbo  
               AND J.FPP725TOP = i.jaqz698top ;
               
               COMMIT;
           exception when others then
             null;
           end;       
       
       end loop;  

end sp_actualiza_est_fpp725;
  
procedure sp_actualiza_est_jaqz698(pd_fec date) is

CURSOR CREDITOS IS 
select * from FPP725 F WHERE F.FPP725PRO = 'N' and F.FPP725FEP = pd_fec; --FECHA DE PROCESO

BEGIN

       for i in creditos loop
           begin
             update jaqz698 j
               SET J.JAQZ698EST = 'T' --NO PROCESAR POR ERROR EN FPP725
              WHERE j.jaqz698fep = i.FPP725FEP
               AND j.jaqz698emp = i.FPP725EMP
               AND j.jaqz698mod = i.FPP725MOD
               AND j.jaqz698suc = i.FPP725SUC
               AND j.jaqz698mda = i.FPP725MDA
               AND j.jaqz698pap = i.FPP725PAP
               AND j.jaqz698cta = i.FPP725CTA
               AND j.jaqz698ope = i.FPP725OPE
               AND j.jaqz698sbo = i.FPP725SOP
               AND j.jaqz698top = i.FPP725TOP;
               
               COMMIT;
           exception when others then
             null;
           end;       
       
       end loop;  

end sp_actualiza_est_jaqz698;


end PQ_CR_REPROG_FPP725;
/

