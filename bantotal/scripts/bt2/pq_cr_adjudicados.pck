create or replace package PQ_CR_ADJUDICADOS is

  -- Author  : ABERNEDO
  -- Created : 26/05/2015 09:37:50 a.m.
  -- Purpose : 

  Procedure Sp_CargaData(pd_fecpro in date);
  ---------------------------------------------------------------------------------------------------
  Procedure Capital_interes(pn_emp     in number,
                            pn_suc     in number,
                            pd_fec     in date,
                            pn_mod     in number,
                            pn_trn     in number,
                            pn_rel     in number,
                            pn_mto     in number,
                            pd_fecpro  in date,
                            pn_mda     in number,
                            pn_moa     in number, /*pn_sua in number, */
                            pn_pap     in number,
                            pn_cta     in number,
                            pn_ope     in number,
                            pn_sbo     in number,
                            pn_top     in number,
                            pn_capital out number,
                            pn_interes out number);
  ---------------------------------------------------------------------------------------------------
  Procedure Sp_Provisiones(pn_rub    in number,
                           pn_emp    in number,
                           pn_suc    in number,
                           pn_mda    in number,
                           pn_pap    in number,
                           pn_cta    in number,
                           pn_ope    in number,
                           pn_sbo    in number,
                           pd_fecpro in date,
                           pn_ini    out number,
                           pn_men    out number,
                           pn_des    out number);
  ---------------------------------------------------------------------------------------------------
  Procedure Sp_Realizacion(pc_tip    in char,
                           pn_emp    in number,
                           pn_suc    in number,
                           pn_mod    in number,
                           pn_mda    in number,
                           pn_cta    in number,
                           pn_ope    in number,
                           pn_sbo    in number,
                           pn_top    in number,
                           pd_fecpro in date,
                           pd_fecfin in date,
                           pd_fecr   out date,
                           pn_mto    out number,
                           pd_fecven out date);
  ---------------------------------------------------------------------------------------------------
  Function Fn_Monto_Conver(pn_mot in number,
                           pn_mda in number,
                           pn_tip in number) return number;
  ---------------------------------------------------------------------------------------------------
  Procedure Sp_CargaData_B(pd_fecini in date, pd_fecfin in date);
  ---------------------------------------------------------------------------------------------------
  Procedure Sp_ProvisionesB(pn_rub    in number,
                            pn_emp    in number,
                            pn_suc    in number,
                            pn_mda    in number,
                            pn_pap    in number,
                            pn_cta    in number,
                            pn_ope    in number,
                            pn_sbo    in number,
                            pd_fecpro in date,
                            pn_ini    out number,
                            pn_men    out number,
                            pn_des    out number);
  ----------------------------------------------------------------------------------------------------
  Procedure MtoAdj_Prov_30_976(pn_emp    in number,
                               pn_mod    in number,
                               pn_suc    in number,
                               pn_trn    in number,
                               pn_rel    in number,
                               pd_fec    in date,
                               pd_fecpro in date,
                               pn_mtoadj out number,
                               pn_prov   out number);
end PQ_CR_ADJUDICADOS;
/

create or replace package body PQ_CR_ADJUDICADOS is

  Procedure Sp_CargaData(pd_fecpro in date) is
  
    cursor adjudicado is
    
      select a.jaql169emp,
             a.jaql169moa,
             a.jaql169mda,
             a.jaql169pap,
             a.jaql169suc,
             a.jaql169cta,
             a.jaql169ope,
             a.jaql169sop,
             a.jaql169toa,
             a.jaql169est,
             a.jaql169tip,
             a.jaql169ori,
             a.jaql170sbs,
             a.jaql169emb,
             a.jaql169pos,
             a.jaql169des,
             a.jaql169mad,
             a.jaql169mto,
             a.jaql169rub,
             a.jaql169fec,
             a.jaql169usr,
             a.jaql169hor,
             a.jaql169itm,
             a.jaql169itt,
             a.jaql169itr,
             a.jaql169its,
             a.jaql169fin,
             a.jaql169mod,
             a.jaql169top,
             a.jaql169fpo,
             c.pepais,
             c.petdoc,
             c.pendoc,
             -b.bcsdmn bcsdmn
        from jaql169 a, fsh012 b, fsr008 c
       where a.jaql169fec <= pd_fecpro
         and a.jaql169est in ('P', 'F')
         and b.bcrubr in ( /*1612010200001,
                                                                                                                                                      1612030200001,
                                                                                                                                                      1622030200001,
                                                                                                                                                      1622050100001,
                                                                                                                                                      1612050100001,
                                                                                                                                                      1622050200001,
                                                                                                                                                      1612050200001,
                                                                                                                                                      1612090000001,
                                                                                                                                                      1622090000001*/
                          
                          select Rubro
                            from fsd014 a
                           where a.pcnivc = 79
                             and a.pmtit = 1
                             and a.pmcap = 6)
         and a.jaql169emp = b.bcemp
         and a.jaql169moa = b.bcmod
         and a.jaql169mda = b.bcmda
         and a.jaql169pap = b.bcpap
         and a.jaql169suc = b.bcsuc
         and a.jaql169cta = b.bccta
         and a.jaql169ope = b.bcoper
         and a.jaql169sop = b.bcsbop
         and a.jaql169toa = b.bctop
         and b.bcfech = pd_fecpro
         and a.jaql169emp = c.pgcod
         and a.jaql169cta = c.ctnro
         and c.cttfir = 'T'
      
      union
      
      select a.jaql169emp,
             a.jaql169moa,
             a.jaql169mda,
             a.jaql169pap,
             a.jaql169suc,
             a.jaql169cta,
             a.jaql169ope,
             a.jaql169sop,
             a.jaql169toa,
             a.jaql169est,
             a.jaql169tip,
             a.jaql169ori,
             a.jaql170sbs,
             a.jaql169emb,
             a.jaql169pos,
             a.jaql169des,
             a.jaql169mad,
             a.jaql169mto,
             a.jaql169rub,
             a.jaql169fec,
             a.jaql169usr,
             a.jaql169hor,
             a.jaql169itm,
             a.jaql169itt,
             a.jaql169itr,
             a.jaql169its,
             a.jaql169fin,
             a.jaql169mod,
             a.jaql169top,
             a.jaql169fpo,
             c.pepais,
             c.petdoc,
             c.pendoc,
             -b.bcsdmn bcsdmn
        from jaql169 a, fsh012 b, fsr008 c, jaql172 d
       where a.jaql169fec <= pd_fecpro
         and a.jaql169est = 'V'
         and b.bcrubr in ( /*1612010200001,
                                                                                                                                                         1612030200001,
                                                                                                                                                         1622030200001,
                                                                                                                                                         1622050100001,
                                                                                                                                                         1612050100001,
                                                                                                                                                         1622050200001,
                                                                                                                                                         1612050200001,
                                                                                                                                                         1612090000001,
                                                                                                                                                         1622090000001*/
                          select Rubro
                            from fsd014 a
                           where a.pcnivc = 79
                             and a.pmtit = 1
                             and a.pmcap = 6)
         and a.jaql169emp = b.bcemp
         and a.jaql169moa = b.bcmod
         and a.jaql169mda = b.bcmda
         and a.jaql169pap = b.bcpap
         and a.jaql169suc = b.bcsuc
         and a.jaql169cta = b.bccta
         and a.jaql169ope = b.bcoper
         and a.jaql169sop = b.bcsbop
         and a.jaql169toa = b.bctop
         and b.bcfech = pd_fecpro
         and a.jaql169emp = c.pgcod
         and a.jaql169cta = c.ctnro
         and c.cttfir = 'T'
         and a.jaql169emp = d.jaql172emp
         and a.jaql169moa = d.jaql172mod
         and a.jaql169mda = d.jaql172mda
         and a.jaql169pap = d.jaql172pap
         and a.jaql169cta = d.jaql172cta
         and a.jaql169ope = d.jaql172ope
         and a.jaql169sop = d.jaql172sop
         and a.jaql169toa = d.jaql172top
         and d.jaql172fec > pd_fecpro;
  
    pn_capital   number(17, 2);
    pn_interes   number(17, 2);
    pn_provini   number(17, 2);
    pn_provmen   number(17, 2);
    pn_provdes   number(17, 2);
    pn_provtot   number(17, 2);
    pd_fecrea    date;
    pn_mtorea    number(17, 2);
    pd_fecven    date;
    pn_mtolib    number(17, 2);
    pn_tipcambio number(14, 8);
    pn_mtocon    number(17, 2);
    pn_capfin    number(17, 2);
  begin
    execute immediate ('truncate table JAQZ061');
    update jaqy500 set jaqy500flg = 1 where jaqy500cod = 110;
    COMMIT;
    Begin
    
      select Cotcbi
        into pn_tipcambio
        from fsh005
       where Moneda = 101
         and Cofdes = pd_fecpro;
    Exception
      when no_data_found then
        Begin
        
          select Cotcbi
            into pn_tipcambio
            from fsh005
           where Moneda = 101
             and Cofdes = pd_fecpro - 1;
        Exception
          when others then
            pn_tipcambio := 0;
        end;
    end;
  
    begin
      For i in adjudicado loop
        pn_capital := 0;
        pn_interes := 0;
        pn_provini := 0;
        pn_provmen := 0;
        pn_provdes := 0;
        pn_mtorea  := 0;
      
        pq_cr_adjudicados.Capital_interes(i.jaql169emp,
                                          i.jaql169its,
                                          i.jaql169fec,
                                          i.jaql169itm,
                                          i.jaql169itt,
                                          i.jaql169itr,
                                          i.jaql169mto,
                                          pd_fecpro,
                                          i.jaql169mda,
                                          i.jaql169moa, /*i.jaql169suc,*/
                                          i.jaql169pap,
                                          i.jaql169cta,
                                          i.jaql169ope,
                                          i.jaql169sop,
                                          i.jaql169toa,
                                          pn_capital,
                                          pn_interes);
      
        pq_cr_adjudicados.Sp_Provisiones(i.jaql169rub,
                                         i.jaql169emp,
                                         i.jaql169suc,
                                         i.jaql169mda,
                                         i.jaql169pap,
                                         i.jaql169cta,
                                         i.jaql169ope,
                                         i.jaql169sop,
                                         pd_fecpro,
                                         pn_provini,
                                         pn_provmen,
                                         pn_provdes);
      
        pn_provtot := pn_provini + pn_provmen + pn_provdes;
      
        pq_cr_adjudicados.Sp_Realizacion(i.jaql169tip,
                                         i.jaql169emp,
                                         i.jaql169suc,
                                         i.jaql169moa,
                                         i.jaql169mda,
                                         i.jaql169cta,
                                         i.jaql169ope,
                                         i.jaql169sop,
                                         i.jaql169toa,
                                         pd_fecpro,
                                         i.jaql169fin,
                                         pd_fecrea,
                                         pn_mtorea,
                                         pd_fecven);
        pn_mtocon := pq_cr_adjudicados.Fn_Monto_Conver(i.jaql169mto,
                                                       i.jaql169mda,
                                                       pn_tipcambio);
      
        if i.jaql169itm is null then
          pn_capfin := pn_mtocon;
        else
          pn_capfin := i.bcsdmn;
        end if;
      
        pn_capital := pn_capfin - pn_interes;
        pn_mtolib  := pn_capfin - pn_provtot;
        INSERT INTO JAQZ061
          (JAQZ061EMP,
           JAQZ061MOA,
           JAQZ061MDA,
           JAQZ061PAP,
           JAQZ061SUC,
           JAQZ061CTA,
           JAQZ061OPE,
           JAQZ061SOP,
           JAQZ061TOA,
           JAQZ061EST,
           JAQZ061TIP,
           JAQZ061ORI,
           JAQL170SBS,
           JAQZ061EMB,
           JAQZ061POS,
           JAQZ061FPO,
           JAQZ061DES,
           JAQZ061MAD,
           JAQZ061MTO,
           JAQZ061RUB,
           JAQZ061FEC,
           JAQZ061USR,
           JAQZ061HOR,
           JAQZ061ITM,
           JAQZ061ITT,
           JAQZ061ITR,
           JAQZ061ITS,
           JAQZ061FIN,
           JAQZ061MOD,
           JAQZ061TOP,
           JAQZ061CAP,
           JAQZ061INT,
           JAQZ061PAI,
           JAQZ061TDO,
           JAQZ061NDO,
           JAQZ061PIN,
           JAQZ061PME,
           JAQZ061PDE,
           JAQZ061PTO,
           JAQZ061FRE,
           JAQZ061MRE,
           JAQZ061FVE,
           JAQZ061MLI,
           JAQZ061MMN)
        
        VALUES
          (i.jaql169emp,
           i.jaql169moa,
           i.jaql169mda,
           i.jaql169pap,
           i.jaql169suc,
           i.jaql169cta,
           i.jaql169ope,
           i.jaql169sop,
           i.jaql169toa,
           i.jaql169est,
           i.jaql169tip,
           i.jaql169ori,
           i.jaql170sbs,
           i.jaql169emb,
           i.jaql169pos,
           i.jaql169fpo,
           i.jaql169des,
           i.jaql169mad,
           i.jaql169mto,
           i.jaql169rub,
           i.jaql169fec,
           i.jaql169usr,
           i.jaql169hor,
           i.jaql169itm,
           i.jaql169itt,
           i.jaql169itr,
           i.jaql169its,
           i.jaql169fin,
           i.jaql169mod,
           i.jaql169top,
           pn_capital,
           pn_interes,
           i.pepais,
           i.petdoc,
           i.pendoc,
           pn_provini,
           pn_provmen,
           pn_provdes,
           pn_provtot,
           pd_fecrea,
           pn_mtorea,
           pd_fecven,
           pn_mtolib,
           pn_capfin);
        commit;
      
      end loop;
    
      commit;
    end;
    begin
      update jaqy500 set jaqy500flg = 0 where jaqy500cod = 110;
      COMMIT;
    end;
  end Sp_CargaData;
  ---------------------------------------------------------------------------------------------------
  Procedure Capital_interes(pn_emp     in number,
                            pn_suc     in number,
                            pd_fec     in date,
                            pn_mod     in number,
                            pn_trn     in number,
                            pn_rel     in number,
                            pn_mto     in number,
                            pd_fecpro  in date,
                            pn_mda     in number,
                            pn_moa     in number, /*pn_sua in number,*/
                            pn_pap     in number,
                            pn_cta     in number,
                            pn_ope     in number,
                            pn_sbo     in number,
                            pn_top     in number,
                            pn_capital out number,
                            pn_interes out number) is
    --pn_imp10 number(17,2);--mod@abr 20170801
    --pn_imp12 number(17,2);--mod@abr 20170801
    --pn_existe number(1);--mod@abr 20170801
    --pn_tiptra number(4);--mod@abr 20170801
    --pn_imp number(17,2);--mod@abr 20170801
    pn_tipcambio  number(14, 8);
    ln_mto        number(17, 2);
    ln_existe     number(5) := 0;
    ln_emp        number(3);
    ln_mod        number(3);
    ln_suc        number(3);
    ln_trn        number(3);
    ln_rel        number(4);
    ld_fec        date;
    pn_interesRes number(17, 2);
  begin
  
    Begin
    
      select Cotcbi
        into pn_tipcambio
        from fsh005
       where Moneda = 101
         and Cofdes = pd_fecpro;
    Exception
      when no_data_found then
        Begin
        
          select Cotcbi
            into pn_tipcambio
            from fsh005
           where Moneda = 101
             and Cofdes = pd_fecpro - 1;
        Exception
          when others then
            pn_tipcambio := 0;
        end;
    end;
  
    If pn_mda = 101 then
      ln_mto := round((pn_mto * pn_tipcambio), 2);
    else
      ln_mto := pn_mto;
    end if;
    --mod@abr20170801
    /*If pn_mod = 98 and pn_trn = 301 then
       
       Begin
           select 1,
                  300,
                  case when a.hcord = 10 then (case when a.hmda = 101 then round(sum((a.hcimp1*pn_tipcambio)),2)
                                                    else sum(a.hcimp1)
                                                end) 
                  end,
                  case when a.hcord = 12 then (case when a.hmda = 101 then round(sum((a.hcimp1*pn_tipcambio)),2)
                                                    else sum(a.hcimp1)
                                                end)
                  end
             into pn_existe,
                  pn_tiptra,
                  pn_imp10,
                  pn_imp12
             from fsh016 a
            where a.pgcod  = pn_emp
              and a.hcmod  = pn_mod
              and a.hsucor = pn_suc
              and a.htran  = 300
              --and a.hnrel  = pn_rel
              and a.hfcon  = pd_fec
              and a.hcord  in (10,12)
              group by 1,300,a.hmda,a.hcord;
       Exception 
          when no_data_found then
               Begin
                   select 1,
                          303,
                          (case when a.hmda = 101 then round(SUM((a.hcimp1*pn_tipcambio)),2)
                                else SUM(a.hcimp1)
                            end)
                     into pn_existe,
                          pn_tiptra,
                          pn_imp
                     from fsh016 a
                    where a.pgcod  = pn_emp
                      and a.hcmod  = pn_mod
                      and a.hsucor = pn_suc
                      and a.htran  = 303
                      and a.hfcon  = pd_fec
                      and a.hcord  = 5
                   group by 1,303,a.hmda;
               Exception 
                  when no_data_found then
                       Begin
                           select 1,
                                  305,
                                  (case when a.hmda = 101 then round((a.hcimp1*pn_tipcambio),2)
                                        else a.hcimp1
                                    end)
                             into pn_existe,
                                  pn_tiptra,
                                  pn_imp
                             from fsh016 a
                            where a.pgcod  = pn_emp
                              and a.hcmod  = pn_mod
                              and a.hsucor = pn_suc
                              and a.htran  = 305
                              and a.hfcon  = pd_fec
                              and a.hcord  = 5
                              group by 1,305,a.hmda;
                       Exception 
                          when others then 
                               pn_existe := 0;
                               pn_tiptra := 0;
                               pn_imp    := 0;
                       end;
                  when others then 
                       pn_existe := 0;
                       pn_tiptra := 0;
                       pn_imp    := 0;
               end;
          when others then 
               pn_existe := 0;
               pn_tiptra := 0;
               pn_imp10  := 0;
               pn_imp12  := 0;
       end;
       
    
       
       
       
       if pn_existe = 1 and pn_tiptra = 300 then
          pn_capital := pn_imp10 - pn_imp12;
       end if;
       
       if pn_existe = 1 and pn_tiptra = 303 then
          pn_capital := pn_imp;
       end if;
       
       if pn_existe = 1 and pn_tiptra = 305 then
          pn_capital := pn_imp;
       end if;
       
       pn_interes := ln_mto - pn_capital;
       
    
    End if;
    
    If pn_mod = 30 and pn_trn = 976 then
       
       Begin
           select (case when a.hmda = 101 then round((a.hcimp1*pn_tipcambio),2)
                        else a.hcimp1
                    end)
             into pn_capital
             from fsh016 a
            where a.pgcod  = pn_emp
              and a.hcmod  = pn_mod
              and a.hsucor = pn_suc
              and a.htran  = pn_trn
              and a.hnrel  = pn_rel
              and a.hfcon  = pd_fec
              and a.hcord  = 10;
       Exception 
          when others then 
              pn_capital    := 0;
       end;
       
       pn_interes := ln_mto - pn_capital;
       
    End if;
    
    if pn_capital is null or pn_capital = 0 then 
    
       begin
       
           select case when a.jaql169mda = 101 then round((a.jaql169cap *pn_tipcambio),2)
                       else a.jaql169cap
                  end 
             into pn_capital
             from jaql169 a
            where a.jaql169emp = pn_emp
              and a.jaql169moa = pn_moa
              and a.jaql169mda = pn_mda
              and a.jaql169pap = pn_pap
              and a.jaql169suc = pn_sua
              and a.jaql169cta = pn_cta
              and a.jaql169ope = pn_ope
              and a.jaql169sop = pn_sbo
              and a.jaql169toa = pn_top;
       Exception 
          when others then 
              pn_capital    := 0;
       
       end;
       pn_interes := ln_mto - pn_capital;
    end if;*/
    --fin--mod@abr20170801
  
    --MOD@ABR 20170801
    pn_interes := 0;
    pn_capital := 0;
  
    --verifica si tiene mas de un credito por cuenta
    begin
      select count(*)
        into ln_existe
        from (select a.jaql169cta, a.jaql169ope
                from jaql169 a
               where a.jaql169fec <= pd_fecpro
                 and a.jaql169cta = pn_cta
                 and a.jaql169est in ('P', 'F')
              
              union
              
              select a.jaql169cta, a.jaql169ope
                from jaql169 a, jaql172 d
               where a.jaql169fec <= pd_fecpro
                 and a.jaql169est = 'V'
                 and a.jaql169cta = pn_cta
                 and a.jaql169emp = d.jaql172emp
                 and a.jaql169moa = d.jaql172mod
                 and a.jaql169mda = d.jaql172mda
                 and a.jaql169pap = d.jaql172pap
                 and a.jaql169cta = d.jaql172cta
                 and a.jaql169ope = d.jaql172ope
                 and a.jaql169sop = d.jaql172sop
                 and a.jaql169toa = d.jaql172top
                 and d.jaql172fec > pd_fecpro);
    exception
      when others then
        ln_existe := 0;
    end;
  
    if ln_existe > 1 then
      if pn_top = 7 then
        case
          when pn_mod = 30 and pn_trn = 976 then
            Begin
              select (case
                       when a.hmda = 101 then
                        round((a.hcimp1 * pn_tipcambio), 2)
                       else
                        a.hcimp1
                     end)
                into pn_interes
                from fsh016 a, fsh015 b
               where a.pgcod = pn_emp
                 and a.hcmod = pn_mod
                 and a.htran = pn_trn
                 and a.hsucor = pn_suc
                 and a.hnrel = pn_rel
                 and a.hfcon = pd_fec
                 and a.hcord = 17
                 and a.pgcod = b.pgcod
                 and a.hcmod = b.hcmod
                 and a.htran = b.htran
                 and a.hsucor = b.hsucor
                 and a.hnrel = b.hnrel
                 and a.hfcon = b.hfcon
                 and b.hccorr <> 99;
            Exception
              when others then
                pn_interes := 0;
            end;
          when pn_mod = 98 and pn_trn = 303 then
            Begin
              select (case
                       when a.hmda = 101 then
                        round((a.hcimp1 * pn_tipcambio), 2)
                       else
                        a.hcimp1
                     end)
                into pn_interes
                from fsh016 a, fsh015 b
               where a.pgcod = pn_emp
                 and a.hcmod = pn_mod
                 and a.htran = pn_trn
                 and a.hsucor = pn_suc
                 and a.hnrel = pn_rel
                 and a.hfcon = pd_fec
                 and a.hcord = 75
                 and a.pgcod = b.pgcod
                 and a.hcmod = b.hcmod
                 and a.htran = b.htran
                 and a.hsucor = b.hsucor
                 and a.hnrel = b.hnrel
                 and a.hfcon = b.hfcon
                 and b.hccorr <> 99;
            Exception
              when others then
                pn_interes := 0;
            end;
          when pn_mod = 98 and pn_trn = 305 then
            Begin
              select (case
                       when a.hmda = 101 then
                        round((a.hcimp1 * pn_tipcambio), 2)
                       else
                        a.hcimp1
                     end)
                into pn_interes
                from fsh016 a, fsh015 b
               where a.pgcod = pn_emp
                 and a.hcmod = pn_mod
                 and a.htran = pn_trn
                 and a.hsucor = pn_suc
                 and a.hnrel = pn_rel
                 and a.hfcon = pd_fec
                 and a.hcord = 75
                 and a.pgcod = b.pgcod
                 and a.hcmod = b.hcmod
                 and a.htran = b.htran
                 and a.hsucor = b.hsucor
                 and a.hnrel = b.hnrel
                 and a.hfcon = b.hfcon
                 and b.hccorr <> 99;
            Exception
              when others then
                pn_interes := 0;
            end;
          when pn_mod = 30 and pn_trn = 405 then
            Begin
              select (case
                       when a.hmda = 101 then
                        round((a.hcimp1 * pn_tipcambio), 2)
                       else
                        a.hcimp1
                     end)
                into pn_interes
                from fsh016 a, fsh015 b
               where a.pgcod = pn_emp
                 and a.hcmod = pn_mod
                 and a.htran = pn_trn
                 and a.hsucor = pn_suc
                 and a.hnrel = pn_rel
                 and a.hfcon = pd_fec
                 and a.hcord = 70
                 and a.pgcod = b.pgcod
                 and a.hcmod = b.hcmod
                 and a.htran = b.htran
                 and a.hsucor = b.hsucor
                 and a.hnrel = b.hnrel
                 and a.hfcon = b.hfcon
                 and b.hccorr <> 99;
            Exception
              when others then
                pn_interes := 0;
            end;
          when pn_mod = 30 and pn_trn = 411 then
            Begin
              select (case
                       when a.hmda = 101 then
                        round((a.hcimp1 * pn_tipcambio), 2)
                       else
                        a.hcimp1
                     end)
                into pn_interes
                from fsh016 a, fsh015 b
               where a.pgcod = pn_emp
                 and a.hcmod = pn_mod
                 and a.htran = pn_trn
                 and a.hsucor = pn_suc
                 and a.hnrel = pn_rel
                 and a.hfcon = pd_fec
                 and a.hcord = 70
                 and a.pgcod = b.pgcod
                 and a.hcmod = b.hcmod
                 and a.htran = b.htran
                 and a.hsucor = b.hsucor
                 and a.hnrel = b.hnrel
                 and a.hfcon = b.hfcon
                 and b.hccorr <> 99;
            Exception
              when others then
                pn_interes := 0;
            end;
          when pn_mod = 30 and pn_trn = 977 then
            Begin
              select (case
                       when a.hmda = 101 then
                        round((a.hcimp1 * pn_tipcambio), 2)
                       else
                        a.hcimp1
                     end)
                into pn_interes
                from fsh016 a, fsh015 b
               where a.pgcod = pn_emp
                 and a.hcmod = pn_mod
                 and a.htran = pn_trn
                 and a.hsucor = pn_suc
                 and a.hnrel = pn_rel
                 and a.hfcon = pd_fec
                 and a.hcord = 30
                 and a.pgcod = b.pgcod
                 and a.hcmod = b.hcmod
                 and a.htran = b.htran
                 and a.hsucor = b.hsucor
                 and a.hnrel = b.hnrel
                 and a.hfcon = b.hfcon
                 and b.hccorr <> 99;
            Exception
              when others then
                pn_interes := 0;
            end;
          else
            pn_interes := 0;
        end case;
        --((a.hcmod,a.htran,a.hcord) in (select 30,976,17 from dual)
        --     or (a.hcmod,a.htran,a.hcord) in ( select 98,303,75 from dual)
        --   or (a.hcmod,a.htran,a.hcord) in ( select 98,305,75 from dual)
        --   or (a.hcmod,a.htran,a.hcord) in ( select 30,405,70 from dual)
        --   or (a.hcmod,a.htran,a.hcord) in ( select 30,411,70 from dual)        
        --   or (a.hcmod,a.htran,a.hcord) in ( select 30,977,30 from dual))
      else
        Begin
          select a.pgcod, a.hcmod, a.hsucor, a.htran, a.hnrel, a.hfcon
            into ln_emp, ln_mod, ln_suc, ln_trn, ln_rel, ld_fec
            from fsh016 a, fsh015 b
           where a.pgcod = pn_emp
             and a.hrubro in (1918070000020, 1928070000020)
             and a.hmodul = pn_moa
                --and a.hsucur = pn_sua
             and a.hmda = pn_mda
             and a.hpap = pn_pap
             and a.hcta = pn_cta
             and a.hoper = pn_ope
             and a.hsubop = pn_sbo
             and a.htoper = pn_top
             and a.hfcon = pd_fec
             and (a.hcmod, a.htran) not in
                 (select pn_mod, pn_trn from dual)
             and a.pgcod = b.pgcod
             and a.hcmod = b.hcmod
             and a.htran = b.htran
             and a.hsucor = b.hsucor
             and a.hnrel = b.hnrel
             and a.hfcon = b.hfcon
             and b.hccorr <> 99;
        Exception
          when others then
            null;
        end;
      
        case
          when ln_mod = 30 and ln_trn = 976 then
            Begin
              select (case
                       when a.hmda = 101 then
                        round((a.hcimp1 * pn_tipcambio), 2)
                       else
                        a.hcimp1
                     end)
                into pn_interes
                from fsh016 a, fsh015 b
               where a.pgcod = ln_emp
                 and a.hcmod = ln_mod
                 and a.htran = ln_trn
                 and a.hsucor = ln_suc
                 and a.hnrel = ln_rel
                 and a.hfcon = ld_fec
                 and a.hcord = 17
                 and a.pgcod = b.pgcod
                 and a.hcmod = b.hcmod
                 and a.htran = b.htran
                 and a.hsucor = b.hsucor
                 and a.hnrel = b.hnrel
                 and a.hfcon = b.hfcon
                 and b.hccorr <> 99;
            Exception
              when others then
                pn_interes := 0;
            end;
          when ln_mod = 98 and ln_trn = 303 then
            Begin
              select (case
                       when a.hmda = 101 then
                        round((a.hcimp1 * pn_tipcambio), 2)
                       else
                        a.hcimp1
                     end)
                into pn_interes
                from fsh016 a, fsh015 b
               where a.pgcod = ln_emp
                 and a.hcmod = ln_mod
                 and a.htran = ln_trn
                 and a.hsucor = ln_suc
                 and a.hnrel = ln_rel
                 and a.hfcon = ld_fec
                 and a.hcord = 75
                 and a.pgcod = b.pgcod
                 and a.hcmod = b.hcmod
                 and a.htran = b.htran
                 and a.hsucor = b.hsucor
                 and a.hnrel = b.hnrel
                 and a.hfcon = b.hfcon
                 and b.hccorr <> 99;
            Exception
              when others then
                pn_interes := 0;
            end;
          
            --mod@abr20190411
            Begin
              select (case
                       when a.hmda = 101 then
                        round((a.hcimp1 * pn_tipcambio), 2)
                       else
                        a.hcimp1
                     end)
                into pn_interesRes
                from fsh016 a, fsh015 b
               where a.pgcod = ln_emp
                 and a.hcmod = ln_mod
                 and a.htran = ln_trn
                 and a.hsucor = ln_suc
                 and a.hnrel = ln_rel
                 and a.hfcon = ld_fec
                 and a.hcord = 93
                 and a.pgcod = b.pgcod
                 and a.hcmod = b.hcmod
                 and a.htran = b.htran
                 and a.hsucor = b.hsucor
                 and a.hnrel = b.hnrel
                 and a.hfcon = b.hfcon
                 and b.hccorr <> 99;
            Exception
              when others then
                pn_interesRes := 0;
            end;
            pn_interes := nvl(pn_interes, 0) - nvl(pn_interesRes, 0);
            --mod@abr20190411
        
          when ln_mod = 98 and ln_trn = 305 then
            Begin
              select (case
                       when a.hmda = 101 then
                        round((a.hcimp1 * pn_tipcambio), 2)
                       else
                        a.hcimp1
                     end)
                into pn_interes
                from fsh016 a, fsh015 b
               where a.pgcod = ln_emp
                 and a.hcmod = ln_mod
                 and a.htran = ln_trn
                 and a.hsucor = ln_suc
                 and a.hnrel = ln_rel
                 and a.hfcon = ld_fec
                 and a.hcord = 75
                 and a.pgcod = b.pgcod
                 and a.hcmod = b.hcmod
                 and a.htran = b.htran
                 and a.hsucor = b.hsucor
                 and a.hnrel = b.hnrel
                 and a.hfcon = b.hfcon
                 and b.hccorr <> 99;
            Exception
              when others then
                pn_interes := 0;
            end;
          when ln_mod = 30 and ln_trn = 405 then
            Begin
              select (case
                       when a.hmda = 101 then
                        round((a.hcimp1 * pn_tipcambio), 2)
                       else
                        a.hcimp1
                     end)
                into pn_interes
                from fsh016 a, fsh015 b
               where a.pgcod = ln_emp
                 and a.hcmod = ln_mod
                 and a.htran = ln_trn
                 and a.hsucor = ln_suc
                 and a.hnrel = ln_rel
                 and a.hfcon = ld_fec
                 and a.hcord = 70
                 and a.pgcod = b.pgcod
                 and a.hcmod = b.hcmod
                 and a.htran = b.htran
                 and a.hsucor = b.hsucor
                 and a.hnrel = b.hnrel
                 and a.hfcon = b.hfcon
                 and b.hccorr <> 99;
            Exception
              when others then
                pn_interes := 0;
            end;
          when ln_mod = 30 and ln_trn = 411 then
            Begin
              select (case
                       when a.hmda = 101 then
                        round((a.hcimp1 * pn_tipcambio), 2)
                       else
                        a.hcimp1
                     end)
                into pn_interes
                from fsh016 a, fsh015 b
               where a.pgcod = ln_emp
                 and a.hcmod = ln_mod
                 and a.htran = ln_trn
                 and a.hsucor = ln_suc
                 and a.hnrel = ln_rel
                 and a.hfcon = ld_fec
                 and a.hcord = 70
                 and a.pgcod = b.pgcod
                 and a.hcmod = b.hcmod
                 and a.htran = b.htran
                 and a.hsucor = b.hsucor
                 and a.hnrel = b.hnrel
                 and a.hfcon = b.hfcon
                 and b.hccorr <> 99;
            Exception
              when others then
                pn_interes := 0;
            end;
          when ln_mod = 30 and ln_trn = 977 then
            Begin
              select (case
                       when a.hmda = 101 then
                        round((a.hcimp1 * pn_tipcambio), 2)
                       else
                        a.hcimp1
                     end)
                into pn_interes
                from fsh016 a, fsh015 b
               where a.pgcod = ln_emp
                 and a.hcmod = ln_mod
                 and a.htran = ln_trn
                 and a.hsucor = ln_suc
                 and a.hnrel = ln_rel
                 and a.hfcon = ld_fec
                 and a.hcord = 30
                 and a.pgcod = b.pgcod
                 and a.hcmod = b.hcmod
                 and a.htran = b.htran
                 and a.hsucor = b.hsucor
                 and a.hnrel = b.hnrel
                 and a.hfcon = b.hfcon
                 and b.hccorr <> 99;
            Exception
              when others then
                pn_interes := 0;
            end;
          else
            pn_interes := 0;
        end case;
      
      end if;
    
    else
      begin
        select a.bcsdmn
          into pn_interes
          from fsh012 a
         where a.bcemp = pn_emp
           and a.bcrubr in
               (2911070900002, 2921070900002, 2911070900001, 2921070900001)
           and a.bcpap = pn_pap
           and a.bccta = pn_cta
           and a.bcfech = pd_fecpro;
      exception
        when others then
          null;
      end;
    end if;
  
    pn_capital := ln_mto - pn_interes;
    --FIN MOD@ABR 20170801
  
  end Capital_interes;
  ---------------------------------------------------------------------------------------------------
  Procedure Sp_Provisiones(pn_rub    in number,
                           pn_emp    in number,
                           pn_suc    in number,
                           pn_mda    in number,
                           pn_pap    in number,
                           pn_cta    in number,
                           pn_ope    in number,
                           pn_sbo    in number,
                           pd_fecpro in date,
                           pn_ini    out number,
                           pn_men    out number,
                           pn_des    out number) is
  
    ln_rubini number(16);
    ln_rubmen number(16);
    ln_rubdes number(16);
  Begin
    --Provision inicial
    begin
      begin
      
        select a.rrrubr
          into ln_rubini
          from fsr014 a
         where a.rubro = pn_rub
           and a.rrcod = 75;
      Exception
        when others then
          ln_rubini := null;
      end;
    
      begin
      
        select b.bcsdmn
          into pn_ini
          from fsh012 b
         where b.bcemp = pn_emp
           and b.bcsuc = pn_suc
           and b.bcrubr = ln_rubini
           and b.bcmda = pn_mda
           and b.bcpap = pn_pap
           and b.bccta = pn_cta
           and b.bcoper = pn_ope
           and b.bcsbop = pn_sbo
           and b.bcfech = pd_fecpro;
      Exception
        when others then
          pn_ini := 0;
        
      end;
    end;
  
    --Provision mensual
    begin
      begin
      
        select a.rrrubr
          into ln_rubmen
          from fsr014 a
         where a.rubro = pn_rub
           and a.rrcod = 76;
      Exception
        when others then
          ln_rubmen := null;
      end;
    
      begin
      
        select b.bcsdmn
          into pn_men
          from fsh012 b
         where b.bcemp = pn_emp
           and b.bcsuc = pn_suc
           and b.bcrubr = ln_rubmen
           and b.bcmda = pn_mda
           and b.bcpap = pn_pap
           and b.bccta = pn_cta
           and b.bcoper = pn_ope
           and b.bcsbop = pn_sbo
           and b.bcfech = pd_fecpro;
      Exception
        when others then
          pn_men := 0;
        
      end;
    end;
  
    --Provision Desvalorizacion
    begin
      begin
      
        select a.rrrubr
          into ln_rubdes
          from fsr014 a
         where a.rubro = pn_rub
           and a.rrcod = 74;
      Exception
        when others then
          ln_rubdes := null;
      end;
    
      begin
      
        select b.bcsdmn
          into pn_des
          from fsh012 b
         where b.bcemp = pn_emp
           and b.bcsuc = pn_suc
           and b.bcrubr = ln_rubdes
           and b.bcmda = pn_mda
           and b.bcpap = pn_pap
           and b.bccta = pn_cta
           and b.bcoper = pn_ope
           and b.bcsbop = pn_sbo
           and b.bcfech = pd_fecpro;
      Exception
        when others then
          pn_des := 0;
        
      end;
    end;
  
  end Sp_Provisiones;
  ---------------------------------------------------------------------------------------------------

  Procedure Sp_ProvisionesB(pn_rub    in number,
                            pn_emp    in number,
                            pn_suc    in number,
                            pn_mda    in number,
                            pn_pap    in number,
                            pn_cta    in number,
                            pn_ope    in number,
                            pn_sbo    in number,
                            pd_fecpro in date,
                            pn_ini    out number,
                            pn_men    out number,
                            pn_des    out number) is
  
    ln_rubini number(16);
    ln_rubmen number(16);
    ln_rubdes number(16);
  Begin
    --Provision inicial
    begin
      begin
      
        select a.rrrubr
          into ln_rubini
          from fsr014 a
         where a.rubro = pn_rub
           and a.rrcod = 75;
      Exception
        when others then
          ln_rubini := null;
      end;
    
      begin
      
        select b.bcsdmn
          into pn_ini
          from fsh012 b
         where b.bcemp = pn_emp
           and b.bcsuc = pn_suc
           and b.bcrubr = ln_rubini
           and b.bcmda = pn_mda
           and b.bcpap = pn_pap
           and b.bccta = pn_cta
           and b.bcoper = pn_ope
           and b.bcsbop = pn_sbo
           and b.bcfech = pd_fecpro - 1;
      Exception
        when others then
          pn_ini := 0;
        
      end;
    end;
  
    --Provision mensual
    begin
      begin
      
        select a.rrrubr
          into ln_rubmen
          from fsr014 a
         where a.rubro = pn_rub
           and a.rrcod = 76;
      Exception
        when others then
          ln_rubmen := null;
      end;
    
      begin
      
        select b.bcsdmn
          into pn_men
          from fsh012 b
         where b.bcemp = pn_emp
           and b.bcsuc = pn_suc
           and b.bcrubr = ln_rubmen
           and b.bcmda = pn_mda
           and b.bcpap = pn_pap
           and b.bccta = pn_cta
           and b.bcoper = pn_ope
           and b.bcsbop = pn_sbo
           and b.bcfech = pd_fecpro - 1;
      Exception
        when others then
          pn_men := 0;
        
      end;
    end;
  
    --Provision Desvalorizacion
    begin
      begin
      
        select a.rrrubr
          into ln_rubdes
          from fsr014 a
         where a.rubro = pn_rub
           and a.rrcod = 74;
      Exception
        when others then
          ln_rubdes := null;
      end;
    
      begin
      
        select b.bcsdmn
          into pn_des
          from fsh012 b
         where b.bcemp = pn_emp
           and b.bcsuc = pn_suc
           and b.bcrubr = ln_rubdes
           and b.bcmda = pn_mda
           and b.bcpap = pn_pap
           and b.bccta = pn_cta
           and b.bcoper = pn_ope
           and b.bcsbop = pn_sbo
           and b.bcfech = pd_fecpro - 1;
      Exception
        when others then
          pn_des := 0;
        
      end;
    end;
  
  end Sp_ProvisionesB;
  ---------------------------------------------------------------------------------------------------
  Procedure Sp_Realizacion(pc_tip    in char,
                           pn_emp    in number,
                           pn_suc    in number,
                           pn_mod    in number,
                           pn_mda    in number,
                           pn_cta    in number,
                           pn_ope    in number,
                           pn_sbo    in number,
                           pn_top    in number,
                           pd_fecpro in date,
                           pd_fecfin in date,
                           pd_fecr   out date,
                           pn_mto    out number,
                           pd_fecven out date) is
  
    pn_tipcambio number(14, 8);
  Begin
  
    Begin
    
      Begin
      
        select Cotcbi
          into pn_tipcambio
          from fsh005
         where Moneda = 101
           and Cofdes = pd_fecpro;
      Exception
        when no_data_found then
          Begin
          
            select Cotcbi
              into pn_tipcambio
              from fsh005
             where Moneda = 101
               and Cofdes = pd_fecpro - 1;
          Exception
            when others then
              pn_tipcambio := 0;
          end;
      end;
    
      If pc_tip = 'I' then
      
        begin
        
          select c.jaql171fec,
                 case
                   when JAQL171MDA = 101 then
                    Round((c.jaql171mto * pn_tipcambio), 2)
                   else
                    c.jaql171mto
                 end
            into pd_fecr, pn_mto
            from jaql171 c
           where JAQL171EMP = pn_EMP
             and JAQL171SUC = pn_SUC
             and JAQL171CTA = pn_CTA
             and JAQL171MDA = pn_MDA
             and JAQL171MOD = pn_MOd
             and JAQL171TOP = pn_TOp
             and JAQL171OPE = pn_OPE
             and JAQL171SOP = pn_sbo;
        Exception
          when too_many_rows then
            begin
            
              select c.jaql171fec,
                     case
                       when JAQL171MDA = 101 then
                        Round((c.jaql171mto * pn_tipcambio), 2)
                       else
                        c.jaql171mto
                     end
                into pd_fecr, pn_mto
                from jaql171 c
               where JAQL171EMP = pn_EMP
                 and JAQL171SUC = pn_SUC
                 and JAQL171CTA = pn_CTA
                 and JAQL171MDA = pn_MDA
                 and JAQL171MOD = pn_MOd
                 and JAQL171TOP = pn_TOp
                 and JAQL171OPE = pn_OPE
                 and JAQL171SOP = pn_sbo
                 and JAQL171FEC =
                     (select max(bb.jaql171fec)
                        from jaql171 bb
                       where bb.jaql171emp = c.jaql171emp
                         and bb.jaql171suc = c.jaql171suc
                         and bb.JAQL171CTA = c.JAQL171CTA
                         and bb.JAQL171MDA = c.JAQL171MDA
                         and bb.JAQL171MOD = c.JAQL171MOD
                         and bb.JAQL171TOP = c.JAQL171TOP
                         and bb.JAQL171OPE = c.JAQL171OPE
                         and bb.JAQL171SOP = c.JAQL171SOP);
              /*Exception
              when too_many_rows then
                   dbms_output.put_line(pn_CTA||'-'||pn_ope);*/
            end;
          when others then
            pd_fecr := null;
            pn_mto  := null;
        end;
      
        pd_fecven := pd_fecfin;
      
      Else
      
        begin
        
          select c.jaql171fec,
                 case
                   when JAQL171MDA = 101 then
                    Round((c.jaql171mto * pn_tipcambio), 2)
                   else
                    c.jaql171mto
                 end
            into pd_fecr, pn_mto
            from jaql171 c
           where JAQL171EMP = pn_EMP
             and JAQL171SUC = pn_SUC
             and JAQL171CTA = pn_CTA
             and JAQL171MDA = pn_MDA
             and JAQL171MOD = pn_MOd
             and JAQL171TOP = pn_TOp
             and JAQL171OPE = pn_OPE
             and JAQL171SOP = pn_sbo;
        Exception
          when too_many_rows then
            begin
            
              select c.jaql171fec,
                     case
                       when JAQL171MDA = 101 then
                        Round((c.jaql171mto * pn_tipcambio), 2)
                       else
                        c.jaql171mto
                     end
                into pd_fecr, pn_mto
                from jaql171 c
               where JAQL171EMP = pn_EMP
                 and JAQL171SUC = pn_SUC
                 and JAQL171CTA = pn_CTA
                 and JAQL171MDA = pn_MDA
                 and JAQL171MOD = pn_MOd
                 and JAQL171TOP = pn_TOp
                 and JAQL171OPE = pn_OPE
                 and JAQL171SOP = pn_sbo
                 and JAQL171FEC =
                     (select max(bb.jaql171fec)
                        from jaql171 bb
                       where bb.jaql171emp = c.jaql171emp
                         and bb.jaql171suc = c.jaql171suc
                         and bb.JAQL171CTA = c.JAQL171CTA
                         and bb.JAQL171MDA = c.JAQL171MDA
                         and bb.JAQL171MOD = c.JAQL171MOD
                         and bb.JAQL171TOP = c.JAQL171TOP
                         and bb.JAQL171OPE = c.JAQL171OPE
                         and bb.JAQL171SOP = c.JAQL171SOP);
              /*Exception
              when too_many_rows then
                   dbms_output.put_line(pn_CTA||'-'||pn_ope);*/
            end;
          when others then
            pd_fecr := null;
            pn_mto  := null;
        end;
      
        --pd_fecr := null;
        --pn_mto  := null;
        pd_fecven := null;
      
      end if;
    
    end;
  
  end Sp_Realizacion;
  ---------------------------------------------------------------------------------------------------
  Function Fn_Monto_Conver(pn_mot in number,
                           pn_mda in number,
                           pn_tip in number) return number is
    ln_mto number(17, 2);
  begin
    begin
    
      if pn_mda = 101 then
        ln_mto := round((pn_mot * pn_tip), 2);
      else
        ln_mto := pn_mot;
      end if;
    end;
  
    return ln_mto;
  
  end Fn_Monto_Conver;

  ---------------------------------------------------------------------------------------------------
  Procedure Sp_CargaData_B(pd_fecini in date, pd_fecfin in date) is
  
    cursor adjudicado is
    
      Select a.jaql169emp,
             a.jaql169moa,
             a.jaql169mda,
             a.jaql169pap,
             a.jaql169suc,
             a.jaql169cta,
             a.jaql169ope,
             a.jaql169sop,
             a.jaql169toa,
             a.jaql169est,
             a.jaql169tip,
             a.jaql169ori,
             a.jaql170sbs,
             a.jaql169emb,
             a.jaql169pos,
             a.jaql169des,
             a.jaql169mad,
             a.jaql169mto,
             a.jaql169rub,
             a.jaql169fec,
             a.jaql169usr,
             a.jaql169hor,
             a.jaql169itm,
             a.jaql169itt,
             a.jaql169itr,
             a.jaql169its,
             a.jaql169fin,
             a.jaql169mod,
             a.jaql169top,
             a.jaql169fpo,
             pepais,
             petdoc,
             pendoc,
             jaql172fec,
             jaql172mdv,
             jaql172mto,
             -b.bcsdmn bcsdmn
        from (select a.jaql169emp,
                     a.jaql169moa,
                     a.jaql169mda,
                     a.jaql169pap,
                     a.jaql169suc,
                     a.jaql169cta,
                     a.jaql169ope,
                     a.jaql169sop,
                     a.jaql169toa,
                     a.jaql169est,
                     a.jaql169tip,
                     a.jaql169ori,
                     a.jaql170sbs,
                     a.jaql169emb,
                     a.jaql169pos,
                     a.jaql169des,
                     a.jaql169mad,
                     a.jaql169mto,
                     a.jaql169rub,
                     a.jaql169fec,
                     a.jaql169usr,
                     a.jaql169hor,
                     a.jaql169itm,
                     a.jaql169itt,
                     a.jaql169itr,
                     a.jaql169its,
                     a.jaql169fin,
                     a.jaql169mod,
                     a.jaql169top,
                     a.jaql169fpo,
                     c.pepais,
                     c.petdoc,
                     c.pendoc,
                     b.jaql172fec,
                     b.jaql172mdv,
                     b.jaql172mto --,
              -- b.bcsdmn  bcsdmn
                from jaql169 a, fsr008 c, jaql172 b --,fsh012 b
               where a.jaql169fec <= pd_fecfin
                 and a.jaql169est = 'V'
                 and a.jaql169emp = b.jaql172emp
                 and a.jaql169moa = b.jaql172mod
                 and a.jaql169mda = b.jaql172mda
                 and a.jaql169pap = b.jaql172pap
                 and a.jaql169suc = b.jaql172suc
                 and a.jaql169cta = b.jaql172cta
                 and a.jaql169ope = b.jaql172ope
                 and a.jaql169sop = b.jaql172sop
                 and a.jaql169toa = b.jaql172top
                 and b.JAQL172CNT = 'S'
                 and b.jaql172fec between pd_fecini and pd_fecfin
                 and a.jaql169emp = c.pgcod
                 and a.jaql169cta = c.ctnro
                 and c.cttfir = 'T') a
        left join fsh012 b
          on (b.bcrubr in ( /*1612010200001,
                                                                                                                                                           1612030200001,
                                                                                                                                                           1622030200001,
                                                                                                                                                           1622050100001,
                                                                                                                                                           1612050100001,
                                                                                                                                                           1622050200001,
                                                                                                                                                           1612050200001,
                                                                                                                                                           1612090000001,
                                                                                                                                                           1622090000001*/
                           select Rubro
                             from fsd014 a
                            where a.pcnivc = 79
                              and a.pmtit = 1
                              and a.pmcap = 6) and a.jaql169emp = b.bcemp and
             a.jaql169moa = b.bcmod and a.jaql169mda = b.bcmda and
             a.jaql169pap = b.bcpap and a.jaql169suc = b.bcsuc and
             a.jaql169cta = b.bccta and a.jaql169ope = b.bcoper and
             a.jaql169sop = b.bcsbop and a.jaql169toa = b.bctop and
             b.bcfech = jaql172fec - 1);
  
    pn_capital    number(17, 2);
    pn_interes    number(17, 2);
    pn_provini    number(17, 2);
    pn_provmen    number(17, 2);
    pn_provdes    number(17, 2);
    pn_provtot    number(17, 2);
    pd_fecrea     date;
    pn_mtorea     number(17, 2);
    pd_fecven     date;
    pn_mtolib     number(17, 2);
    pn_tipcambio  number(14, 8);
    pn_mtocon     number(17, 2);
    pn_mtoventamn number(17, 2);
    pn_capfin     number(17, 2);
  begin
    execute immediate ('truncate table JAQZ062');
    update jaqy500 set jaqy500flg = 1 where jaqy500cod = 111;
    COMMIT;
    Begin
    
      select Cotcbi
        into pn_tipcambio
        from fsh005
       where Moneda = 101
         and Cofdes = pd_fecfin;
    Exception
      when no_data_found then
        Begin
        
          select Cotcbi
            into pn_tipcambio
            from fsh005
           where Moneda = 101
             and Cofdes = pd_fecfin - 1;
        Exception
          when others then
            pn_tipcambio := 0;
        end;
    end;
  
    begin
      For i in adjudicado loop
      
        pn_capital := 0;
        pn_interes := 0;
        pn_provini := 0;
        pn_provmen := 0;
        pn_provdes := 0;
        pn_mtorea  := 0;
      
        pq_cr_adjudicados.Capital_interes(i.jaql169emp,
                                          i.jaql169its,
                                          i.jaql169fec,
                                          i.jaql169itm,
                                          i.jaql169itt,
                                          i.jaql169itr,
                                          i.jaql169mto,
                                          pd_fecfin,
                                          i.jaql169mda,
                                          i.jaql169moa, /*i.jaql169suc,*/
                                          i.jaql169pap,
                                          i.jaql169cta,
                                          i.jaql169ope,
                                          i.jaql169sop,
                                          i.jaql169toa,
                                          pn_capital,
                                          pn_interes);
      
        pq_cr_adjudicados.Sp_ProvisionesB(i.jaql169rub,
                                          i.jaql169emp,
                                          i.jaql169suc,
                                          i.jaql169mda,
                                          i.jaql169pap,
                                          i.jaql169cta,
                                          i.jaql169ope,
                                          i.jaql169sop,
                                          i.jaql172fec,
                                          pn_provini,
                                          pn_provmen,
                                          pn_provdes);
      
        pq_cr_adjudicados.Sp_Realizacion(i.jaql169tip,
                                         i.jaql169emp,
                                         i.jaql169suc,
                                         i.jaql169moa,
                                         i.jaql169mda,
                                         i.jaql169cta,
                                         i.jaql169ope,
                                         i.jaql169sop,
                                         i.jaql169toa,
                                         pd_fecfin,
                                         i.jaql169fin,
                                         pd_fecrea,
                                         pn_mtorea,
                                         pd_fecven);
        pn_mtocon := pq_cr_adjudicados.Fn_Monto_Conver(i.jaql169mto,
                                                       i.jaql169mda,
                                                       pn_tipcambio);
      
        if i.jaql169itm is null then
          pn_capfin := pn_mtocon;
        else
          pn_capfin := i.bcsdmn;
        
        end if;
      
        --if (pn_capfin is null or pn_capfin = 0) and i.jaql169itm = 30 and i.jaql169itr =976 then
        if pn_capfin is null and i.jaql169itm = 30 and i.jaql169itt = 976 then
          pq_cr_adjudicados.MtoAdj_Prov_30_976(i.jaql169emp,
                                               i.jaql169itm,
                                               i.jaql169its,
                                               i.jaql169itt,
                                               i.jaql169itr,
                                               i.jaql169fec,
                                               pd_fecfin,
                                               pn_capfin,
                                               pn_provini);
        end if;
        --      end if; 
      
        pn_provtot := pn_provini + pn_provmen + pn_provdes;
        pn_interes := pn_capfin - pn_capital;
        pn_mtolib  := pn_capfin - pn_provtot;
      
        pn_mtoventamn := pq_cr_adjudicados.Fn_Monto_Conver(i.jaql172mto,
                                                           i.jaql172mdv,
                                                           pn_tipcambio);
      
        INSERT INTO JAQZ062
          (JAQZ062EMP,
           JAQZ062MOA,
           JAQZ062MDA,
           JAQZ062PAP,
           JAQZ062SUC,
           JAQZ062CTA,
           JAQZ062OPE,
           JAQZ062SOP,
           JAQZ062TOA,
           JAQZ062EST,
           JAQZ062TIP,
           JAQZ062ORI,
           JAQL170SBS,
           JAQZ062EMB,
           JAQZ062POS,
           JAQZ062FPO,
           JAQZ062DES,
           JAQZ062MAD,
           JAQZ062MTO,
           JAQZ062RUB,
           JAQZ062FEC,
           JAQZ062USR,
           JAQZ062HOR,
           JAQZ062ITM,
           JAQZ062ITT,
           JAQZ062ITR,
           JAQZ062ITS,
           JAQZ062FIN,
           JAQZ062MOD,
           JAQZ062TOP,
           JAQZ062CAP,
           JAQZ062INT,
           JAQZ062PAI,
           JAQZ062TDO,
           JAQZ062NDO,
           JAQZ062PIN,
           JAQZ062PME,
           JAQZ062PDE,
           JAQZ062PTO,
           JAQZ062FRE,
           JAQZ062MRE,
           JAQZ062FVE,
           JAQZ062MLI,
           JAQZ062MMN,
           JAQZ062FVT,
           JAQZ062MDAV,
           JAQZ062MDV,
           JAQZ062MVMN)
        
        VALUES
          (i.jaql169emp,
           i.jaql169moa,
           i.jaql169mda,
           i.jaql169pap,
           i.jaql169suc,
           i.jaql169cta,
           i.jaql169ope,
           i.jaql169sop,
           i.jaql169toa,
           i.jaql169est,
           i.jaql169tip,
           i.jaql169ori,
           i.jaql170sbs,
           i.jaql169emb,
           i.jaql169pos,
           i.jaql169fpo,
           i.jaql169des,
           i.jaql169mad,
           i.jaql169mto,
           i.jaql169rub,
           i.jaql169fec,
           i.jaql169usr,
           i.jaql169hor,
           i.jaql169itm,
           i.jaql169itt,
           i.jaql169itr,
           i.jaql169its,
           i.jaql169fin,
           i.jaql169mod,
           i.jaql169top,
           pn_capital,
           pn_interes,
           i.pepais,
           i.petdoc,
           i.pendoc,
           pn_provini,
           pn_provmen,
           pn_provdes,
           pn_provtot,
           pd_fecrea,
           pn_mtorea,
           pd_fecven,
           pn_mtolib,
           pn_capfin,
           i.jaql172fec,
           i.jaql172mdv,
           i.jaql172mto,
           pn_mtoventamn);
      
        commit;
      
      end loop;
    
      commit;
    end;
    begin
      update jaqy500 set jaqy500flg = 0 where jaqy500cod = 111;
      COMMIT;
    end;
  end Sp_CargaData_B;

  Procedure MtoAdj_Prov_30_976(pn_emp    in number,
                               pn_mod    in number,
                               pn_suc    in number,
                               pn_trn    in number,
                               pn_rel    in number,
                               pd_fec    in date,
                               pd_fecpro in date,
                               pn_mtoadj out number,
                               pn_prov   out number) is
    pn_tipcambio number(14, 8);
  
  begin
  
    Begin
    
      select Cotcbi
        into pn_tipcambio
        from fsh005
       where Moneda = 101
         and Cofdes = pd_fecpro;
    Exception
      when no_data_found then
        Begin
        
          select Cotcbi
            into pn_tipcambio
            from fsh005
           where Moneda = 101
             and Cofdes = pd_fecpro - 1;
        Exception
          when others then
            pn_tipcambio := 0;
        end;
    end;
  
    Begin
      select (case
               when a.hmda = 101 then
                round((a.hcimp1 * pn_tipcambio), 2)
               else
                a.hcimp1
             end)
      
        into pn_mtoadj
        from fsh016 a
       where a.pgcod = pn_emp
         and a.hcmod = pn_mod
         and a.hsucor = pn_suc
         and a.htran = pn_trn
         and a.hnrel = pn_rel
         and a.hfcon = pd_fec
         and a.hcord = 20;
    Exception
      when others then
        pn_mtoadj := 0;
    end;
  
    Begin
      select (case
               when a.hmda = 101 then
                round((a.hcimp1 * pn_tipcambio), 2)
               else
                a.hcimp1
             end)
      
        into pn_prov
        from fsh016 a
       where a.pgcod = pn_emp
         and a.hcmod = pn_mod
         and a.hsucor = pn_suc
         and a.htran = pn_trn
         and a.hnrel = pn_rel
         and a.hfcon = pd_fec
         and a.hcord = 35;
    Exception
      when others then
        pn_prov := 0;
    end;
  
  end MtoAdj_Prov_30_976;

end PQ_CR_ADJUDICADOS;
/

