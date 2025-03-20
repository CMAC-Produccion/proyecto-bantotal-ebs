create or replace package PQ_CR_REPROCONV is

  -- Author  : ABERNEDO
  -- Created : 29/03/2017 09:55:29 a.m.
  -- Purpose : 
  -- MODIFCADO : DCASTRO 2017.05.17 SE modifico sp_backup
  
  -- Public type declarations
  Function Fn_esParcial(pn_emp in number,
                      pn_mod in number,
                      pn_suc in number,
                      pn_mda in number,
                      pn_pap in number,
                      pn_cta in number,
                      pn_ope in number,
                      pn_sbo in number,
                      pn_top in number,
                      pc_ind in char) return char;
  Procedure sp_cargaInicial(pd_fecpro in date,pn_grupo in number);
 
  Function Fn_fechaPendiente(pn_emp in number,
                           pn_mod in number,
                           pn_suc in number,
                           pn_mda in number,
                           pn_pap in number,
                           pn_cta in number,
                           pn_ope in number,
                           pn_sbo in number,
                           pn_top in number)return date    ;    
  Procedure Sp_Actualiza_FSD601(pn_grupo in number);
  Procedure Sp_Actualiza_FSD611(pn_grupo in number);
  Procedure Sp_Actualiza_FSD010(pn_grupo in number);
  Procedure Sp_Actualiza_FSD011(pn_grupo in number);
  Procedure Sp_extorno_grupo(pn_grupo in number);     
  Procedure Sp_extorno_cuenta(pn_cta in number,
                            pn_ope in number,
                            pc_usr in char,
                            pd_fec in date,
                            pn_ind out number) ;    
  Procedure Sp_parciales(pn_grupo in number);
  
  Procedure Sp_ActParc_FSD611(pn_grupo in number);
  Procedure Sp_ActParc_FSD601_602_612(pn_grupo in number);
  Procedure Sp_ActParc_FSD010(pn_grupo in number);
  Procedure Sp_ActParc_FSD011(pn_grupo in number);
  Procedure Sp_detallePago(pn_emp in number,
                         pn_mod in number,
                         pn_suc in number,
                         pn_mda in number,
                         pn_pap in number,
                         pn_cta in number,
                         pn_ope in number,
                         pn_sbo in number,
                         pn_top in number,
                         pd_fec in date,
                         pn_cap out number,
                         pn_int out number,
                         pn_mor out number,
                         pn_seg out number);   
  --Procedure Sp_regularizacion;
  Procedure Sp_verificaRepetidos(pn_grupo in number); 
  Procedure Sp_verifica602(pn_emp in number,
                       pn_mod in number,
                       pn_suc in number,
                       pn_mda in number,
                       pn_pap in number,
                       pn_cta in number,
                       pn_ope in number,
                       pn_sbo in number,
                       pn_top in number,
                       pd_fec in date,
                       lc_cambia out char);   
  Procedure Sp_Revierte602_612(pn_emp in number,
                             pn_mod in number,
                             pn_suc in number,
                             pn_mda in number,
                             pn_pap in number,
                             pn_cta in number,
                             pn_ope in number,
                             pn_sbo in number,
                             pn_top in number,
                             pc_usr in char,
                             pd_fec in date);    
  Procedure Sp_ObtieneFechaOri(pn_cta in number,
                             pn_ope in number,
                             pd_fec out date);     
  
  Procedure Sp_backup (pn_emp in number,
                     pn_mod in number,
                     pn_suc in number,
                     pn_mda in number,
                     pn_pap in number,
                     pn_cta in number,
                     pn_ope in number,
                     pn_sbo in number,
                     pn_top in number);   
                     
  Procedure Sp_verifica_Pago(pn_emp in number,
                     pn_mod in number,
                     pn_suc in number,
                     pn_mda in number,
                     pn_pap in number,
                     pn_cta in number,
                     pn_ope in number,
                     pn_sbo in number,
                     pn_top in number,
                     pd_fec in date,
                     lc_cambia out char);     
  Procedure Sp_calculaInteres(pn_grupo in number);  
  Function Fn_NroCuotasPen(pn_emp in number,
                           pn_mod in number,
                           pn_suc in number,
                           pn_mda in number,
                           pn_pap in number,
                           pn_cta in number,
                           pn_ope in number,
                           pn_sbo in number,
                           pn_top in number,
                           pd_fecpro in date)return number;                                                                                                                                                                                        

end PQ_CR_REPROCONV;
/

create or replace package body PQ_CR_REPROCONV is

Function Fn_esParcial(pn_emp in number,
                      pn_mod in number,
                      pn_suc in number,
                      pn_mda in number,
                      pn_pap in number,
                      pn_cta in number,
                      pn_ope in number,
                      pn_sbo in number,
                      pn_top in number,
                      pc_ind in char) return char is
ld_maxpag date;
lc_flg char(1);
lc_stat char(1);
begin
  
     if pc_ind = 'S' then
           begin
                select max(a.ppfpag)
                  into ld_maxpag
                  from fsd602 a
                 where a.pgcod  = pn_emp
                   and a.ppmod  = pn_mod
                   and a.ppsuc  = pn_suc
                   and a.ppmda  = pn_mda
                   and a.pppap  = pn_pap
                   and a.ppcta  = pn_cta
                   and a.ppoper = pn_ope
                   and a.ppsbop = pn_sbo
                   and a.pptope = pn_top
                   and a.d602co = 'S';
           exception 
             when too_many_rows then 
               begin
                    select max(a.ppfpag)
                      into ld_maxpag
                      from fsd602 a
                     where a.pgcod  = pn_emp
                       and a.ppmod  = pn_mod
                       and a.ppsuc  = pn_suc
                       and a.ppmda  = pn_mda
                       and a.pppap  = pn_pap
                       and a.ppcta  = pn_cta
                       and a.ppoper = pn_ope
                       and a.ppsbop = pn_sbo
                       and a.pptope = pn_top
                       and a.d602co = 'S'
                       /*and a.d602re = (select max(aa.d602re)
                                         from fsd602 aa
                                        where aa.pgcod  = a.pgcod 
                                          and aa.ppmod  = a.ppmod 
                                          and aa.ppsuc  = a.ppsuc 
                                          and aa.ppmda  = a.ppmda 
                                          and aa.pppap  = a.pppap 
                                          and aa.ppcta  = a.ppcta 
                                          and aa.ppoper = a.ppoper
                                          and aa.ppsbop = a.ppsbop
                                          and aa.pptope = a.pptope)*/
                       and rownum = 1;
               exception 
                 when others then null;
               end;  
             when others then null;
           end;  
           
           if ld_maxpag is not null then
              begin
                    select 'T'
                      into lc_stat
                      from fsd602 a
                     where a.pgcod   = pn_emp
                       and a.ppmod   = pn_mod
                       and a.ppsuc   = pn_suc
                       and a.ppmda   = pn_mda
                       and a.pppap   = pn_pap
                       and a.ppcta   = pn_cta
                       and a.ppoper  = pn_ope
                       and a.ppsbop  = pn_sbo
                       and a.pptope  = pn_top
                       and a.ppfpag  = ld_maxpag
                       and a.pp1stat = 'T'
                       and a.d602co  = 'S';
               exception 
                 when others then null;
               end;  
               if lc_stat = 'T' then
                  lc_flg := 'S';
                  else
                    lc_flg := 'P';
               end if;
             else
               lc_flg := 'S';
           end if;
           
           else
                lc_flg := pc_ind;
     end if;
     
     return lc_flg;

end Fn_esParcial;

Procedure sp_cargaInicial(pd_fecpro in date,pn_grupo in number)is
cursor creditos_ini is
select * from jaqz519a a where a.jaqz519agrp = pn_grupo  ;
lc_ind char(1);
ld_fec date;
ln_estado number(2);
ln_sdo number(17,2);
ln_rub number(16);
ld_Fvto date;
ln_pdi number(5);
ln_dias number(5);
ln_cuo number(5);
begin
  
  for i in creditos_ini loop
      lc_ind := 'S';
      ln_pdi := 0;
      --fecha pendiente de pago
      ld_fec := pq_cr_reproconv.Fn_fechaPendiente(i.jaqz519aemp,
                                                   i.jaqz519amod,
                                                   i.jaqz519asuc,
                                                   i.jaqz519amda,
                                                   i.jaqz519apap,
                                                   i.jaqz519acta,
                                                   i.jaqz519aope,
                                                   i.jaqz519asbo,
                                                   i.jaqz519atop                                                  
                                                  )  ;
      --estado
      begin
           select aostat,aofvto
             into ln_estado,ld_Fvto
             from fsd010 a
            where a.pgcod = i.jaqz519aemp
              and aomod   = i.jaqz519amod
              and aosuc   = i.jaqz519asuc
              and aomda   = i.jaqz519amda
              and aopap   = i.jaqz519apap
              and aocta   = i.jaqz519acta
              and aooper  = i.jaqz519aope
              and aosbop  = i.jaqz519asbo
              and aotope  = i.jaqz519atop; 
      exception 
              when others then null;
      end ;
      
      --indicador de estado
      if ln_estado=99 then 
         lc_ind := 'C';
      end if;
      
      --saldos, rubro
      begin
          select c.scsdo,c.scrub
            into ln_sdo,ln_rub
            from fsd011 c
           where c.pgcod  = i.jaqz519aemp
             and c.scmod  = i.jaqz519amod
             and c.scsuc  = i.jaqz519asuc
             and c.scmda  = i.jaqz519amda
             and c.scpap  = i.jaqz519apap
             and c.sccta  = i.jaqz519acta
             and c.scoper = i.jaqz519aope
             and c.scsbop = i.jaqz519asbo
             and c.sctope = i.jaqz519atop;
      exception
             when others then null;     
           
      end;
      
      --indicador si es parcial
      lc_ind := pq_cr_reproconv.Fn_esParcial(i.jaqz519aemp,
                                              i.jaqz519amod,
                                              i.jaqz519asuc,
                                              i.jaqz519amda,
                                              i.jaqz519apap,
                                              i.jaqz519acta,
                                              i.jaqz519aope,
                                              i.jaqz519asbo,
                                              i.jaqz519atop,
                                              lc_ind);
      --dias de atraso
      ln_dias := fn_dias_atraso(v_Pgfape => pd_fecpro,
                                v_Pgcod  => i.jaqz519aemp,
                                v_Scmod  => i.jaqz519amod,
                                v_Scsuc  => i.jaqz519asuc,
                                v_Scmda  => i.jaqz519amda,
                                v_Scpap  => i.jaqz519apap,
                                v_Sccta  => i.jaqz519acta,
                                v_Scoper => i.jaqz519aope,
                                v_Scsbop => i.jaqz519asbo,
                                v_Sctope => i.jaqz519atop,
                                v_Scstat => ln_estado,
                                v_fecven => ld_Fvto);
       ln_cuo := nvl(pq_cr_reproconv.Fn_NroCuotasPen(pn_emp    => i.jaqz519aemp,
                                       pn_mod    => i.jaqz519amod,
                                       pn_suc    => i.jaqz519asuc,
                                       pn_mda    => i.jaqz519amda,
                                       pn_pap    => i.jaqz519apap,
                                       pn_cta    => i.jaqz519acta,
                                       pn_ope    => i.jaqz519aope,
                                       pn_sbo    => i.jaqz519asbo,
                                       pn_top    => i.jaqz519atop,
                                       pd_fecpro => pd_fecpro) ,0)     ;                   
       
   
       if to_char(ld_fec,'mm') = '08' then 
          ln_pdi := 3;
       end if;
       
       if to_char(ld_fec,'mm') = '09' then 
          ln_pdi := 2;
       end if;
       
       if to_char(ld_fec,'mm') = '10' then 
          ln_pdi := 2;--1;
       end if;
       
       if to_char(ld_fec,'mm') = '11' then 
          ln_pdi := 1; --mod @abr 20171130
       end if;
       
       if to_char(ld_fec,'mm') = '04' then 
          ln_pdi := 2; --mod @abr 20180430
       end if;
       
       
       if ln_pdi=0 then 
         lc_ind := 'O';
      end if;                             
       
       update jaqz519a a
          set jaqz519aest = ln_estado,
              jaqz519aind = lc_ind,
              jaqz519arub = ln_rub,
              jaqz519asdo = ln_sdo,
              jaqz519afep = pd_fecpro,
              jaqz519afpp = ld_fec,
              a.jaqz519apdi = ln_pdi,
              a.jaqz519adias =ln_dias,
              a.jaqz519acuot = ln_cuo
        where a.jaqz519aemp= i.jaqz519aemp
          and a.jaqz519amod= i.jaqz519amod
          and a.jaqz519asuc= i.jaqz519asuc
          and a.jaqz519amda= i.jaqz519amda
          and a.jaqz519apap= i.jaqz519apap
          and a.jaqz519acta= i.jaqz519acta
          and a.jaqz519aope= i.jaqz519aope
          and a.jaqz519asbo= i.jaqz519asbo
          and a.jaqz519atop= i.jaqz519atop
          and a.jaqz519agrp = pn_grupo--mod@abr 20171031
          ;
          
          commit;
      
  end loop;
  
  commit;
   
end sp_cargaInicial;



Function Fn_fechaPendiente(pn_emp in number,
                           pn_mod in number,
                           pn_suc in number,
                           pn_mda in number,
                           pn_pap in number,
                           pn_cta in number,
                           pn_ope in number,
                           pn_sbo in number,
                           pn_top in number)return date is
                           
  
ld_fecpxv date;
begin
     begin
          select /*+ parallel(n,2,1)*/
               min(n.ppfpag)
          into ld_fecpxv
          from FSD601 n
         where n.pgcod  = pn_emp
           and n.ppcta  = pn_cta
           and n.ppmda  = pn_mda
           and n.ppsuc  = pn_suc
           and n.pppap  = pn_pap
           and n.ppoper = pn_ope
           and n.ppsbop = pn_sbo
           and n.pptope = pn_top
           and n.ppmod  = pn_mod
           and n.d601co = 'S'
           and (n.ppcap+n.ppint)<>0
           and not exists
                    (select /*+ parallel(o,2,1)*/  ppmod, ppcta,ppoper, pptope,ppfpag
                       from fsd602 o
                      where o.pgcod   = n.pgcod
                        and o.ppmod   = n.ppmod
                        and o.ppsuc   = n.ppsuc
                        and o.ppmda   = n.ppmda
                        and o.pppap   = n.pppap
                        and o.ppcta   = n.ppcta
                        and o.ppoper  = n.ppoper
                        and o.ppsbop  = n.ppsbop
                        and o.pptope  = n.pptope
                        and o.ppfpag  = n.ppfpag
                        and o.pp1stat = 'T'
                        and o.d602co  = 'S'
                        and (o.pp1cap+o.pp1int)<>0);
        exception
           when others then null;
        end;
        
        return ld_fecpxv;
end Fn_fechaPendiente;

Procedure Sp_Actualiza_FSD601(pn_grupo in number) is
  cursor creditos is
select a.pgcod,
       a.aomod,
       a.aosuc,
       a.aomda,
       a.aopap,
       a.aocta,
       a.aooper,
       a.aosbop,
       a.aotope,
       b.jaqz519apdi
  from fsd010 a, jaqz519a b
 where a.pgcod  = b.jaqz519aemp
   and a.aomod  = b.jaqz519amod
   and a.aosuc  = b.jaqz519asuc
   and a.aomda  = b.jaqz519amda
   and a.aopap  = b.jaqz519apap
   and a.aocta  = b.jaqz519acta
   and a.aooper = b.jaqz519aope
   and a.aosbop = b.jaqz519asbo
   and a.aotope = b.jaqz519atop
   and a.aomod  in (select modulo from fst111 where dscod = 50)
   and b.jaqz519aind = 'S'
   and b.jaqz519agrp=pn_grupo
--   and aomod  not in(110,115,104,112)
 --  and a.aocta =1883837
  -- and a.aooper= 2395363
   ;
   
ld_fecpxv date;

cursor calendario(pn_emp in number,
                  pn_mod in number,
                  pn_suc in number,
                  pn_mda in number,
                  pn_pap in number,
                  pn_cta in number,
                  pn_ope in number,
                  pn_sbo in number,
                  pn_top in number,
                  pd_fec in date) is
select * 
  from fsd601 a
 where a.pgcod  = pn_emp
   and a.ppmod  = pn_mod
   and a.ppsuc  = pn_suc
   and a.ppmda  = pn_mda
   and a.pppap  = pn_pap
   and a.ppcta  = pn_cta
   and a.ppoper = pn_ope
   and a.ppsbop = pn_sbo
   and a.pptope = pn_top
   and a.d601co = 'S'
   and (a.ppcap+a.ppint)<>0
   and a.ppfpag >= pd_fec
order by ppfpag desc;

cursor calendario_asc(pn_emp in number,
                  pn_mod in number,
                  pn_suc in number,
                  pn_mda in number,
                  pn_pap in number,
                  pn_cta in number,
                  pn_ope in number,
                  pn_sbo in number,
                  pn_top in number,
                  pd_fec in date) is
select * 
  from fsd601 a
 where a.pgcod  = pn_emp
   and a.ppmod  = pn_mod
   and a.ppsuc  = pn_suc
   and a.ppmda  = pn_mda
   and a.pppap  = pn_pap
   and a.ppcta  = pn_cta
   and a.ppoper = pn_ope
   and a.ppsbop = pn_sbo
   and a.pptope = pn_top
   and a.d601co = 'S'
   and (a.ppcap+a.ppint)<>0
   and a.ppfpag >= pd_fec
order by ppfpag asc;


type c_list is varray (999) of fsd601.ppfpag%type; 
name_list c_list := c_list(); 
counter number :=0; 
ln_cont number;
ln_int number;

ld_ppfpag date;
ld_ppfval date;
ld_ppfvto date;
lc_hab_ppfpag char(1);
lc_hab_ppfval char(1);
lc_hab_ppfvto char(1);
ld_ppfpag_F date;
ld_ppfval_F date;
ld_ppfvto_F date;

ln_countTot number;
ln_contAF number;

--PPFVAL
type c_list_FV is varray (999) of fsd601.ppfval%type; 
name_list_FV c_list_FV := c_list_FV(); 
counter_FV number :=0; 
ln_contFV number;
ln_intFV number;
--PPFVAL

--mod@abr 20170403
ld_fecha date;
ln_numpdi number;
--mod@abr 20170403


BEGIN 
  
for i in creditos loop
        ld_fecpxv := null;
          
        begin
          select /*+ parallel(n,2,1)*/
               min(n.ppfpag)
          into ld_fecpxv
          from fsd601 n
         where n.pgcod  = i.pgcod
           and n.ppcta  = i.aocta
           and n.ppmda  = i.aomda
           and n.ppsuc  = i.aosuc
           and n.pppap  = i.aopap
           and n.ppoper = i.aooper
           and n.ppsbop = i.aosbop
           and n.pptope = i.aotope
           and n.ppmod  = i.aomod
           and n.d601co = 'S'
           and (n.ppcap+n.ppint)<>0
           and not exists
                    (select /*+ parallel(o,2,1)*/  ppmod, ppcta,ppoper, pptope,ppfpag
                       from fsd602 o
                      where o.pgcod   = n.pgcod
                        and o.ppmod   = n.ppmod
                        and o.ppsuc   = n.ppsuc
                        and o.ppmda   = n.ppmda
                        and o.pppap   = n.pppap
                        and o.ppcta   = n.ppcta
                        and o.ppoper  = n.ppoper
                        and o.ppsbop  = n.ppsbop
                        and o.pptope  = n.pptope
                        and o.ppfpag  = n.ppfpag
                        and o.pp1stat = 'T'
                        and o.d602co  = 'S'
                        and (o.pp1cap+o.pp1int)<>0);
        exception
           when others then null;
        end;
        
        counter := 0;
        ln_countTot := 0;
        name_list := c_list(); 
        for j in calendario_asc(i.pgcod,i.aomod,i.aosuc,i.aomda,i.aopap,i.aocta,i.aooper,i.aosbop,i.aotope,ld_fecpxv) loop

                counter := counter + 1; 
                name_list.extend; 
                name_list(counter)  := j.ppfpag; 
                --dbms_output.put_line('Customer('||counter ||'):'||name_list(counter)); 
   
          
        end loop;
        ln_countTot := counter ;
        ln_cont := 0;
        ln_contAF := 0;
        --mod@abr 20170403
        ld_fecha := add_months(ld_fecpxv,i.jaqz519apdi);  
              
        if ld_fecha between to_date('2017.03.30','yyyy.mm.dd') and to_date('2017.05.31','yyyy.mm.dd') then
           ln_numpdi := i.jaqz519apdi + 2;
           else
             ln_numpdi := i.jaqz519apdi;
        end if;
        
        --mod@abr 20170403
        
        for k in calendario(i.pgcod,i.aomod,i.aosuc,i.aomda,i.aopap,i.aocta,i.aooper,i.aosbop,i.aotope,ld_fecpxv) loop
          ln_cont := ln_cont + 1;
          
          if ln_cont < ln_numpdi + 1 then --MOD@ABR 20170403
                ld_ppfpag := add_months(k.ppfpag,ln_numpdi);--MOD@ABR 20170403
                ld_ppfval := add_months(k.ppfval,ln_numpdi);--MOD@ABR 20170403
                ld_ppfvto := add_months(k.ppfvto,ln_numpdi);--MOD@ABR 20170403
                  
                  --verificar si es dia habil
                  begin
                    select a.fhabil
                      into lc_hab_ppfpag
                      from fst028 a,fst001 b
                     where a.calcod=b.calcod
                       and a.ffecha = ld_ppfpag
                       and b.sucurs = i.aosuc;
                  exception
                    when others then null;
                  end;
                  
                  if lc_hab_ppfpag = 'N' then
                     begin
                         select min(a.ffecha)
                           into ld_ppfpag_F
                           from fst028 a,fst001 b
                          where a.calcod = b.calcod
                            and a.ffecha > ld_ppfpag
                            and b.sucurs = i.aosuc
                            and a.fhabil = 'S';
                     exception
                       when others then null;
                     end;
                     
                     else
                       ld_ppfpag_F := ld_ppfpag;
                       
                  end if;
                  
                  begin
                    select a.fhabil
                      into lc_hab_ppfval
                      from fst028 a,fst001 b
                     where a.calcod = b.calcod
                       and a.ffecha = ld_ppfval
                       and b.sucurs = i.aosuc;
                  exception
                    when others then null;
                  end;
                  
                  if lc_hab_ppfval = 'N' then
                     begin
                         select min(a.ffecha)
                           into ld_ppfval_F
                           from fst028 a,fst001 b
                          where a.calcod = b.calcod
                            and a.ffecha > ld_ppfval
                            and b.sucurs = i.aosuc
                            and a.fhabil = 'S';
                     exception
                       when others then null;
                     end;
                     
                     else 
                        ld_ppfval_F := ld_ppfval;
                  end if;
                  
                  begin
                    select a.fhabil
                      into lc_hab_ppfvto
                      from fst028 a,fst001 b
                     where a.calcod=b.calcod
                       and a.ffecha = ld_ppfvto
                       and b.sucurs = i.aosuc;
                  exception
                    when others then null;
                  end;
                  
                  if lc_hab_ppfpag = 'N' then
                     begin
                         select min(a.ffecha)
                           into ld_ppfvto_F
                           from fst028 a,fst001 b
                          where a.calcod = b.calcod
                            and a.ffecha > ld_ppfvto
                            and b.sucurs = i.aosuc
                            and a.fhabil = 'S';
                     exception
                       when others then null;
                     end;
                     
                     else
                         ld_ppfvto_F := ld_ppfvto;
                  end if;
                  --dbms_output.put_line('0-'||k.ppcta||'-'||k.ppoper||'-'||ld_ppfpag_F||'-'||ld_ppfval_F||'-'||ld_ppfvto_F||'-'||k.ppfpag); 
                  begin 
                    update fsd601  a
                       set a.ppfpag = ld_ppfpag_F,
                           a.ppfval = ld_ppfval_F,
                           a.ppfvto = ld_ppfvto_F,
                           a.pptipo = 'F'  --@mod 20170929
                     where a.pgcod  = k.pgcod 
                       and a.ppmod  = k.ppmod 
                       and a.ppsuc  = k.ppsuc 
                       and a.ppmda  = k.ppmda 
                       and a.pppap  = k.pppap 
                       and a.ppcta  = k.ppcta 
                       and a.ppoper = k.ppoper
                       and a.ppsbop = k.ppsbop
                       and a.pptope = k.pptope
                       and a.ppfpag = k.ppfpag;
                  -- exception
                    -- when others then
                     --dbms_output.put_line('1-'||k.ppcta||'-'||k.ppoper||'-'||ld_ppfpag_F||'-'||ld_ppfval_F||'-'||ld_ppfvto_F||'-'||k.ppfpag);
                   end; 
                   
                   
                   else
             
                        ln_contAF := ln_contAF +1 ; 
                        ln_int := counter;
                        
                        while ln_int = counter loop
                              ld_ppfpag_F := name_list(ln_int);
                              ln_int := ln_int - 1;
                              
                              --dbms_output.put_line( '3-'||ln_int||'-'||counter||'-'||ld_ppfpag_F||'-'||k.ppfpag);
                              begin 
                                update fsd601  a
                                   set a.ppfpag = ld_ppfpag_F,
                                       a.ppfvto = ld_ppfpag_F,
                                       a.pptipo = 'F' --@mod 20170929
                                 where a.pgcod  = k.pgcod 
                                   and a.ppmod  = k.ppmod 
                                   and a.ppsuc  = k.ppsuc 
                                   and a.ppmda  = k.ppmda 
                                   and a.pppap  = k.pppap 
                                   and a.ppcta  = k.ppcta 
                                   and a.ppoper = k.ppoper
                                   and a.ppsbop = k.ppsbop
                                   and a.pptope = k.pptope
                                   and a.ppfpag = k.ppfpag;
                               --exception
                                 --when others then
                                   --dbms_output.put_line( '2-'||k.ppcta||'-'||k.ppoper||'-'||ld_ppfpag_F||'-'||ld_ppfval_F||'-'||ld_ppfvto_F||'-'||k.ppfpag);
                               end; 
                        end loop;
                        counter := counter - 1;
                        --dbms_output.put_line( '4-'||counter||'-'||ln_countTot);
                        
                        
                        
                        
                        If (ln_countTot - ln_contAF)=ln_numpdi then --mod@abr 20170403
                           exit;
                        end if;
                        
                    
             end if;
             
        end loop;
        
        --PPFVAL
   
        counter_FV := 0;    
        name_list_FV := c_list_FV();  
        for j in calendario_asc(i.pgcod,i.aomod,i.aosuc,i.aomda,i.aopap,i.aocta,i.aooper,i.aosbop,i.aotope,ld_fecpxv) loop

       
                counter_FV := counter_FV + 1; 
                name_list_FV.extend; 
                name_list_FV(counter_FV)  := j.ppfpag; 

        end loop;
        
        
        ln_contFV  :=0;
       
        ln_intFV := 1;
        For g in calendario_asc(i.pgcod,i.aomod,i.aosuc,i.aomda,i.aopap,i.aocta,i.aooper,i.aosbop,i.aotope,ld_fecpxv)  loop
            ln_contFV := ln_contFV + 1;
            
            if ln_contFV >=2 then
               counter_FV := ln_intFV ;
               --dbms_output.put_line( 'FV1'||ln_intFV||'-'||counter_FV);
               while ln_intFV = counter_FV loop
                     ld_ppfval_F := name_list_FV(ln_intFV);
                     --dbms_output.put_line( 'FV2'||ld_ppfval_F||'-'||ln_intFV);
                     counter_FV := counter_FV - 1;
                     begin 
                        update fsd601  a
                           set a.ppfval = ld_ppfval_F
                         where a.pgcod  = g.pgcod 
                           and a.ppmod  = g.ppmod 
                           and a.ppsuc  = g.ppsuc 
                           and a.ppmda  = g.ppmda 
                           and a.pppap  = g.pppap 
                           and a.ppcta  = g.ppcta 
                           and a.ppoper = g.ppoper
                           and a.ppsbop = g.ppsbop
                           and a.pptope = g.pptope
                           and a.ppfpag = g.ppfpag;
                       --exception
                         --when others then
                         --dbms_output.put_line( '2-'||k.ppcta||'-'||k.ppoper||'-'||ld_ppfpag_F||'-'||ld_ppfval_F||'-'||ld_ppfvto_F||'-'||k.ppfpag);
                       end; 
               
               end loop;
               ln_intFV := ln_intFV + 1;
               --dbms_output.put_line( 'FV2'||ln_intFV);
            end if;
        end loop;
        --PPFVAL
          update jaqz519a A
           set a.JAQZ519aPRO601 = 'S'
         where a.jaqz519aemp =  i.pgcod 
           and a.jaqz519amod =  i.aomod
           and a.jaqz519asuc =  i.aosuc
           and a.jaqz519amda =  i.aomda
           and a.jaqz519apap =  i.aopap
           and a.jaqz519acta =  i.aocta
           and a.jaqz519aope =  i.aooper
           and a.jaqz519asbo =  i.aosbop
           and a.jaqz519atop =  i.aotope
           and a.jaqz519agrp =  pn_grupo;
         
        
   END LOOP; 
END Sp_Actualiza_FSD601; 

Procedure Sp_Actualiza_FSD611(pn_grupo in number) is
  cursor creditos is
select a.pgcod,
       a.aomod,
       a.aosuc,
       a.aomda,
       a.aopap,
       a.aocta,
       a.aooper,
       a.aosbop,
       a.aotope,
       b.jaqz519apdi
  from fsd010 a, jaqz519a b
 where a.pgcod  = b.jaqz519aemp
   and a.aomod  = b.jaqz519amod
   and a.aosuc  = b.jaqz519asuc
   and a.aomda  = b.jaqz519amda
   and a.aopap  = b.jaqz519apap
   and a.aocta  = b.jaqz519acta
   and a.aooper = b.jaqz519aope
   and a.aosbop = b.jaqz519asbo
   and a.aotope = b.jaqz519atop
   and a.aomod  in (select modulo from fst111 where dscod = 50)
   and b.jaqz519aind = 'S'
   and b.jaqz519agrp=pn_grupo
   --and a.aocta = 1883837
   --and a.aooper = 2395363
   ;
   
ld_fecpxv date;

cursor calendario(pn_emp in number,
                  pn_mod in number,
                  pn_suc in number,
                  pn_mda in number,
                  pn_pap in number,
                  pn_cta in number,
                  pn_ope in number,
                  pn_sbo in number,
                  pn_top in number,
                  pd_fec in date) is
select * 
  from fsd611 a
 where a.pgcod  = pn_emp
   and a.ppmod  = pn_mod
   and a.ppsuc  = pn_suc
   and a.ppmda  = pn_mda
   and a.pppap  = pn_pap
   and a.ppcta  = pn_cta
   and a.ppoper = pn_ope
   and a.ppsbop = pn_sbo
   and a.pptope = pn_top
   and a.ppfpag >= pd_fec
order by ppfpag desc;

cursor calendario_asc(pn_emp in number,
                  pn_mod in number,
                  pn_suc in number,
                  pn_mda in number,
                  pn_pap in number,
                  pn_cta in number,
                  pn_ope in number,
                  pn_sbo in number,
                  pn_top in number,
                  pd_fec in date) is
select * 
  from fsd611 a
 where a.pgcod  = pn_emp
   and a.ppmod  = pn_mod
   and a.ppsuc  = pn_suc
   and a.ppmda  = pn_mda
   and a.pppap  = pn_pap
   and a.ppcta  = pn_cta
   and a.ppoper = pn_ope
   and a.ppsbop = pn_sbo
   and a.pptope = pn_top
   and a.ppfpag >= pd_fec
order by ppfpag asc;


type c_list is varray (999) of fsd601.ppfpag%type; 
name_list c_list := c_list(); 
counter number :=0; 
ln_cont number;
ln_int number;

ld_ppfpag date;

lc_hab_ppfpag char(1);

ld_ppfpag_F date;


ln_countTot number;
ln_contAF number;

--mod@abr 20170403
ld_fecha date;
ln_numpdi number;
--mod@abr 20170403

BEGIN 
  
for i in creditos loop
        ld_fecpxv := null;
          
        begin
          select /*+ parallel(n,2,1)*/
               min(n.ppfpag)
          into ld_fecpxv
          from fsd611 n
         where n.pgcod  = i.pgcod
           and n.ppcta  = i.aocta
           and n.ppmda  = i.aomda
           and n.ppsuc  = i.aosuc
           and n.pppap  = i.aopap
           and n.ppoper = i.aooper
           and n.ppsbop = i.aosbop
           and n.pptope = i.aotope
           and n.ppmod  = i.aomod
           --and n.d601co = 'S'
           --and (n.ppcap+n.ppint)<>0
           and not exists
                    (select /*+ parallel(o,2,1)*/  ppmod, ppcta,ppoper, pptope,ppfpag
                       from fsd602 o
                      where o.pgcod   = n.pgcod
                        and o.ppmod   = n.ppmod
                        and o.ppsuc   = n.ppsuc
                        and o.ppmda   = n.ppmda
                        and o.pppap   = n.pppap
                        and o.ppcta   = n.ppcta
                        and o.ppoper  = n.ppoper
                        and o.ppsbop  = n.ppsbop
                        and o.pptope  = n.pptope
                        and o.ppfpag  = n.ppfpag
                        and o.pp1stat = 'T'
                        and o.d602co  = 'S'
                        and (o.pp1cap+o.pp1int)<>0);
        exception
           when others then null;
        end;
        --dbms_output.put_line('ld_fecpxv-'||ld_fecpxv ); 
        counter := 0;
        ln_countTot := 0;
        name_list  := c_list();       
        for j in calendario_asc(i.pgcod,i.aomod,i.aosuc,i.aomda,i.aopap,i.aocta,i.aooper,i.aosbop,i.aotope,ld_fecpxv) loop

                counter := counter + 1; 
                name_list.extend; 
                name_list(counter)  := j.ppfpag; 
                --dbms_output.put_line('Customer('||counter ||'):'||name_list(counter)); 
   
          
        end loop;
        ln_countTot := counter ;
        ln_cont := 0;
        ln_contAF := 0;
        
        --mod@abr 20170403
        ld_fecha := add_months(ld_fecpxv,i.jaqz519apdi);  
              
        if ld_fecha between to_date('2017.03.30','yyyy.mm.dd') and to_date('2017.05.31','yyyy.mm.dd') then
           ln_numpdi := i.jaqz519apdi + 2;
           else
             ln_numpdi := i.jaqz519apdi;
        end if;
        
        --mod@abr 20170403
        
        for k in calendario(i.pgcod,i.aomod,i.aosuc,i.aomda,i.aopap,i.aocta,i.aooper,i.aosbop,i.aotope,ld_fecpxv) loop
          ln_cont := ln_cont + 1;
          
          if ln_cont < ln_numpdi + 1 then --mod@abr 20170403
                
              
                
                ld_ppfpag := add_months(k.ppfpag,ln_numpdi);--mod@abr 20170403
                 
                            
                  --verificar si es dia habil
                  begin
                    select a.fhabil
                      into lc_hab_ppfpag
                      from fst028 a,fst001 b
                     where a.calcod=b.calcod
                       and a.ffecha = ld_ppfpag
                       and b.sucurs = i.aosuc;
                  exception
                    when others then null;
                  end;
                  
                  if lc_hab_ppfpag = 'N' then
                     begin
                         select min(a.ffecha)
                           into ld_ppfpag_F
                           from fst028 a,fst001 b
                          where a.calcod = b.calcod
                            and a.ffecha > ld_ppfpag
                            and b.sucurs = i.aosuc
                            and a.fhabil = 'S';
                     exception
                       when others then null;
                     end;
                     
                     else
                       ld_ppfpag_F := ld_ppfpag;
                       
                  end if;
                  
                 
                  --dbms_output.put_line('0-'||k.ppcta||'-'||k.ppoper||'-'||ld_ppfpag_F||'-'||ld_ppfval_F||'-'||ld_ppfvto_F||'-'||k.ppfpag); 
                 
                  begin 
                    update fsd611  a
                       set a.ppfpag = ld_ppfpag_F,
                           a.pptipo='F'  --@mod 20170929
                     where a.pgcod  = k.pgcod 
                       and a.ppmod  = k.ppmod 
                       and a.ppsuc  = k.ppsuc 
                       and a.ppmda  = k.ppmda 
                       and a.pppap  = k.pppap 
                       and a.ppcta  = k.ppcta 
                       and a.ppoper = k.ppoper
                       and a.ppsbop = k.ppsbop
                       and a.pptope = k.pptope
                       and a.ppfpag = k.ppfpag;
                  -- exception
                    -- when others then
                     --dbms_output.put_line('1-'||k.ppcta||'-'||k.ppoper||'-'||ld_ppfpag_F||'-'||ld_ppfval_F||'-'||ld_ppfvto_F||'-'||k.ppfpag);
                   end; 
                   
                   
                   else
                       
                        ln_contAF := ln_contAF +1 ; 
                        ln_int := counter;
                        
                        while ln_int = counter loop
                              ld_ppfpag_F := name_list(ln_int);
                              ln_int := ln_int - 1;
                              
                             
                              begin 
                                update fsd611  a
                                   set a.ppfpag = ld_ppfpag_F,
                                       a.pptipo='F'  --@mod 20170929
                                 where a.pgcod  = k.pgcod 
                                   and a.ppmod  = k.ppmod 
                                   and a.ppsuc  = k.ppsuc 
                                   and a.ppmda  = k.ppmda 
                                   and a.pppap  = k.pppap 
                                   and a.ppcta  = k.ppcta 
                                   and a.ppoper = k.ppoper
                                   and a.ppsbop = k.ppsbop
                                   and a.pptope = k.pptope
                                   and a.ppfpag = k.ppfpag;
                               
                               end; 
                        end loop;
                        counter := counter - 1;
                      
                        If (ln_countTot - ln_contAF)=ln_numpdi then --mod@abr 20170403
                           exit;
                        end if;
                        
                    
             end if;
             
        end loop;
        
       update jaqz519a A
           set a.JAQZ519aPRO611 = 'S'
         where a.jaqz519aemp =  i.pgcod 
           and a.jaqz519amod =  i.aomod
           and a.jaqz519asuc =  i.aosuc
           and a.jaqz519amda =  i.aomda
           and a.jaqz519apap =  i.aopap
           and a.jaqz519acta =  i.aocta
           and a.jaqz519aope =  i.aooper
           and a.jaqz519asbo =  i.aosbop
           and a.jaqz519atop =  i.aotope
           and a.jaqz519agrp = pn_grupo;

   END LOOP; 
END Sp_Actualiza_FSD611; 

Procedure Sp_Actualiza_FSD010(pn_grupo in number) is
cursor creditos is
select a.pgcod,
       a.aomod,
       a.aosuc,
       a.aomda,
       a.aopap,
       a.aocta,
       a.aooper,
       a.aosbop,
       a.aotope,
       b.jaqz519apzo,
       a.aofval
  from fsd010 a, jaqz519a b
 where a.pgcod  = b.jaqz519aemp 
   and a.aomod  = b.jaqz519amod 
   and a.aosuc  = b.jaqz519asuc 
   and a.aomda  = b.jaqz519amda 
   and a.aopap  = b.jaqz519apap 
   and a.aocta  = b.jaqz519acta 
   and a.aooper = b.jaqz519aope
   and a.aosbop = b.jaqz519asbo
   and a.aotope = b.jaqz519atop
   and a.aomod  in (select modulo from fst111 where dscod = 50)
   and b.jaqz519aind = 'S'
   and b.jaqz519agrp=pn_grupo;
ld_fecvto date;  
begin

  for i in creditos loop
    
      begin
          select max(ppfpag)
            into ld_fecvto
            from fsd601 a
           where a.pgcod  = i.pgcod 
             and a.ppmod  = i.aomod 
             and a.ppsuc  = i.aosuc 
             and a.ppmda  = i.aomda 
             and a.pppap  = i.aopap 
             and a.ppcta  = i.aocta 
             and a.ppoper = i.aooper
             and a.ppsbop = i.aosbop
             and a.pptope = i.aotope
             and d601co = 'S';
      exception 
        when others then null;      
      end;
  
      update fsd010 
         set aofvto = ld_fecvto,
             aopzo  = ld_fecvto - i.aofval --mod@abr20170405
       where pgcod  = i.pgcod 
         and aomod  = i.aomod 
         and aosuc  = i.aosuc 
         and aomda  = i.aomda 
         and aopap  = i.aopap 
         and aocta  = i.aocta 
         and aooper = i.aooper
         and aosbop = i.aosbop
         and aotope = i.aotope ;
      commit;
      
      update jaqz519a A
           set a.JAQZ519aPRO10 = 'S'
         where a.jaqz519aemp =  i.pgcod 
           and a.jaqz519amod =  i.aomod
           and a.jaqz519asuc =  i.aosuc
           and a.jaqz519amda =  i.aomda
           and a.jaqz519apap =  i.aopap
           and a.jaqz519acta =  i.aocta
           and a.jaqz519aope =  i.aooper
           and a.jaqz519asbo =  i.aosbop
           and a.jaqz519atop =  i.aotope
           and a.jaqz519agrp = pn_grupo;
         
        COMMIT;
        
        
  end loop;
  commit;
end Sp_Actualiza_FSD010;  

Procedure Sp_Actualiza_FSD011(pn_grupo in number) is
  cursor creditos is
select a.pgcod,
       a.scsuc,
       a.scmda,
       a.scpap,
       a.sccta,
       a.scoper,
       a.scsbop,
       a.sctope,
       a.scmod,
       b.jaqz519apzo,
       a.scfval --mod@abr 20170405
  from fsd011 a,jaqz519a b
 where a.pgcod  = b.jaqz519aemp 
   and a.scsuc  = b.jaqz519asuc 
   and a.scmda  = b.jaqz519amda  
   and a.scpap  = b.jaqz519apap 
   and a.sccta  = b.jaqz519acta  
   and a.scoper = b.jaqz519aope  
   and a.scsbop = b.jaqz519asbo 
   and a.sctope = b.jaqz519atop 
   and a.scmod  = b.jaqz519amod
   and a.scfvto is not null
   and b.jaqz519aind = 'S'
   and b.jaqz519agrp=pn_grupo;
ld_fecvto date;
   
begin
   for i in creditos loop
       
       begin
          select max(ppfpag)
            into ld_fecvto
            from fsd601 a
           where a.pgcod  = i.pgcod 
             and a.ppmod  = i.scmod 
             and a.ppsuc  = i.scsuc 
             and a.ppmda  = i.scmda 
             and a.pppap  = i.scpap 
             and a.ppcta  = i.sccta 
             and a.ppoper = i.scoper
             and a.ppsbop = i.scsbop
             and a.pptope = i.sctope
             and d601co = 'S';
      exception 
        when others then null;      
      end;
       
       update fsd011
          set scfvto = ld_fecvto,
              scpzo  = ld_fecvto - i.scfval --mod@abr 20170405
        where pgcod  = i.pgcod 
          and scsuc  = i.scsuc 
          and scmda  = i.scmda 
          and scpap  = i.scpap 
          and sccta  = i.sccta 
          and scoper = i.scoper
          and scsbop = i.scsbop
          and sctope = i.sctope
          and scmod  = i.scmod ;
              
              commit;  
              
        update jaqz519a A
           set a.JAQZ519aPRO11 = 'S'
         where a.jaqz519aemp =  i.pgcod 
           and a.jaqz519amod =  i.scmod
           and a.jaqz519asuc =  i.scsuc
           and a.jaqz519amda =  i.scmda
           and a.jaqz519apap =  i.scpap
           and a.jaqz519acta =  i.sccta
           and a.jaqz519aope =  i.scoper
           and a.jaqz519asbo =  i.scsbop
           and a.jaqz519atop =  i.sctope
           and a.jaqz519agrp = pn_grupo;
         
        COMMIT;
              
                     
   end loop;
   commit;
end Sp_Actualiza_FSD011;

Procedure Sp_extorno_grupo(pn_grupo in number) is
cursor creditos is
select * 
  from jaqz519a b
 where b.jaqz519aind = 'S'
   and b.jaqz519agrp = pn_grupo;  
   
ld_fvto11 date;  
ln_pzo11  number(5);
ld_fvto10 date;  
ln_pzo10  number(5);

begin
    for i in creditos loop
        delete from fsd601 a
         where a.pgcod  = i.jaqz519aemp
           and a.ppmod  = i.jaqz519amod
           and a.ppsuc  = i.jaqz519asuc
           and a.ppmda  = i.jaqz519amda
           and a.pppap  = i.jaqz519apap
           and a.ppcta  = i.jaqz519acta
           and a.ppoper = i.jaqz519aope
           and a.ppsbop = i.jaqz519asbo
           and a.pptope = i.jaqz519atop;
                                   
        insert into fsd601 a
        select pgcod,
               ppmod,
               ppsuc,
               ppmda,
               pppap,
               ppcta,
               ppoper,
               ppsbop,
               pptope,
               ppfpag,
               pptipo,
               ppfval,
               ppfvto,
               pppzo,
               ppcap,
               ppint,
               ppintmex,
               ppicap,
               ppiint,
               ppstat,
               ppnume,
               ppfinv,
               d601cd,
               d601mo,
               d601su,
               d601tr,
               d601re,
               d601fc,
               d601or,
               d601sb,
               d601co
          from jaqz520a_601 b --jaqz520_601 a
         where b.pgcod = i.jaqz519aemp
           and b.ppmod = i.jaqz519amod
           and b.ppsuc = i.jaqz519asuc
           and b.ppmda = i.jaqz519amda
           and b.pppap = i.jaqz519apap
           and b.ppcta = i.jaqz519acta
           and b.ppoper = i.jaqz519aope
           and b.ppsbop = i.jaqz519asbo
           and b.pptope = i.jaqz519atop
           and b.grupo  = pn_grupo;
                                   
        delete from fsd611 a
         where a.pgcod  = i.jaqz519aemp
           and a.ppmod  = i.jaqz519amod
           and a.ppsuc  = i.jaqz519asuc
           and a.ppmda  = i.jaqz519amda
           and a.pppap  = i.jaqz519apap
           and a.ppcta  = i.jaqz519acta
           and a.ppoper = i.jaqz519aope
           and a.ppsbop = i.jaqz519asbo
           and a.pptope = i.jaqz519atop;
                                   
        insert into fsd611 a
        select pgcod,
                ppmod,
                ppsuc,
                ppmda,
                pppap,
                ppcta,
                ppoper,
                ppsbop,
                pptope,
                ppfpag,
                pptipo,
                ppexte,
                ppimp1,
                ppimp2,
                ppimp3,
                ppimp4,
                ppimp5,
                ppimp6,
                ppimp7,
                ppimp8,
                ppimp9,
                ppimp10,
                ppimp11,
                ppimp12,
                ppimp13,
                ppimp14,
                ppimp15,
                ppimp16,
                ppimp17,
                ppimp18,
                ppimp19,
                ppimp20
          from jaqz520a_611 b--jaqz520_611 a
         where b.pgcod  = i.jaqz519aemp
           and b.ppmod  = i.jaqz519amod
           and b.ppsuc  = i.jaqz519asuc
           and b.ppmda  = i.jaqz519amda
           and b.pppap  = i.jaqz519apap
           and b.ppcta  = i.jaqz519acta
           and b.ppoper = i.jaqz519aope
           and b.ppsbop = i.jaqz519asbo
           and b.pptope = i.jaqz519atop
           and b.grupo  = pn_grupo;
                                   
        
        select aofvto,
               aopzo
          into ld_fvto10,
               ln_pzo10
          from jaqz520a_010 a--jaqz520_010 a
         where a.pgcod  = i.jaqz519aemp
           and a.aomod  = i.jaqz519amod
           and a.aosuc  = i.jaqz519asuc
           and a.aomda  = i.jaqz519amda
           and a.aopap  = i.jaqz519apap
           and a.aocta  = i.jaqz519acta
           and a.aooper = i.jaqz519aope
           and a.aosbop = i.jaqz519asbo
           and a.aotope = i.jaqz519atop
           and a.grupo  = pn_grupo;
                                   
        
        update fsd010 a
           set a.aofvto = ld_fvto10,
               a.aopzo  = ln_pzo10
         where a.pgcod  = i.jaqz519aemp
           and a.aomod  = i.jaqz519amod
           and a.aosuc  = i.jaqz519asuc
           and a.aomda  = i.jaqz519amda
           and a.aopap  = i.jaqz519apap
           and a.aocta  = i.jaqz519acta
           and a.aooper = i.jaqz519aope
           and a.aosbop = i.jaqz519asbo
           and a.aotope = i.jaqz519atop;
                                   
        select a.scfvto,
               a.scpzo
          into ld_fvto11,
               ln_pzo11
          from jaqz520a_011 a--jaqz520_011 a
         where a.pgcod  = i.jaqz519aemp
           and a.scmod  = i.jaqz519amod
           and a.scsuc  = i.jaqz519asuc
           and a.scmda  = i.jaqz519amda
           and a.scpap  = i.jaqz519apap
           and a.sccta  = i.jaqz519acta
           and a.scoper = i.jaqz519aope
           and a.scsbop = i.jaqz519asbo
           and a.sctope = i.jaqz519atop
           and a.grupo  = pn_grupo;
                                   
        update fsd011 a
           set a.scfvto = ld_fvto11,
               a.scpzo  = ln_pzo11
         where a.pgcod  = i.jaqz519aemp
           and a.scmod  = i.jaqz519amod
           and a.scsuc  = i.jaqz519asuc
           and a.scmda  = i.jaqz519amda
           and a.scpap  = i.jaqz519apap
           and a.sccta  = i.jaqz519acta
           and a.scoper = i.jaqz519aope
           and a.scsbop = i.jaqz519asbo
           and a.sctope = i.jaqz519atop;
                                   
      
    
    end loop;
    
    delete from jaqz519a b
     where /*b.jaqz519ind = 'S'
       and */b.jaqz519agrp = pn_grupo;  
          
end Sp_extorno_grupo;

Procedure Sp_extorno_cuenta(pn_cta in number,
                            pn_ope in number,
                            pc_usr in char,
                            pd_fec in date,
                            pn_ind out number) is
                            
                            
cursor creditos is
select * 
  from jaqz519a b
 where b.jaqz519aind in('S','P')
   and b.jaqz519acta = pn_cta
   and b.jaqz519aope = pn_ope
   and b.jaqz519apro10  = 'S'
   and b.jaqz519apro11  = 'S'
   and b.jaqz519apro601 = 'S'
   and b.jaqz519apro611 = 'S'
   and b.jaqz519arevr   is null
   ; 
    
cursor calendario_1(pn_emp in number,
                    pn_mod in number,
                    pn_suc in number,
                    pn_mda in number,
                    pn_pap in number,
                    pn_cta in number,
                    pn_ope in number,
                    pn_sbo in number,
                    pn_top in number
                    ) is
select * 
  from fsd601 a
 where a.pgcod  = pn_emp
   and a.ppmod  = pn_mod
   and a.ppsuc  = pn_suc
   and a.ppmda  = pn_mda
   and a.pppap  = pn_pap
   and a.ppcta  = pn_cta
   and a.ppoper = pn_ope
   and a.ppsbop = pn_sbo
   and a.pptope = pn_top 
   and a.d601co = 'S'
order by ppfpag;
   
cursor calendario_2(pn_emp in number,
                    pn_mod in number,
                    pn_suc in number,
                    pn_mda in number,
                    pn_pap in number,
                    pn_cta in number,
                    pn_ope in number,
                    pn_sbo in number,
                    pn_top in number
                    ) is
select * 
  from jaqz520a_601 a
 where a.pgcod  = pn_emp
   and a.ppmod  = pn_mod
   and a.ppsuc  = pn_suc
   and a.ppmda  = pn_mda
   and a.pppap  = pn_pap
   and a.ppcta  = pn_cta
   and a.ppoper = pn_ope
   and a.ppsbop = pn_sbo
   and a.pptope = pn_top 
   and a.d601co = 'S'
order by ppfpag;  

cursor jaqz522 (pn_emp in number,
                pn_mod in number,
                pn_suc in number,
                pn_mda in number,
                pn_pap in number,
                pn_cta in number,
                pn_ope in number,
                pn_sbo in number,
                pn_top in number)is

select * from jaqz522a a
where a.jaqz522aemp = pn_emp              
  and a.jaqz522amod = pn_mod
  and a.jaqz522asuc = pn_suc
  and a.jaqz522amda = pn_mda
  and a.jaqz522apap = pn_pap
  and a.jaqz522acta = pn_cta
  and a.jaqz522aope = pn_ope
  and a.jaqz522asbo = pn_sbo
  and a.jaqz522atop = pn_top;
  
ld_fvto11 date;  
ln_pzo11  number(5);
ld_fvto10 date;  
ln_pzo10  number(5);
ln_contador1 number(10);
ln_contador2 number(10);
ln_con1 number(10);
ln_con2 number(10);
ld_fecAnt date;
lc_Spago char(1);

begin
    pn_ind := 0;
    begin
          select 1 -- 1 si no se ha revertido aun, 0 si ya se revirtio
            into pn_ind
            from jaqz519a b
           where b.jaqz519aind in('S','P')
             and b.jaqz519acta = pn_cta
             and b.jaqz519aope = pn_ope
             and b.jaqz519apro10  = 'S'
             and b.jaqz519apro11  = 'S'
             and b.jaqz519apro601 = 'S'
             and b.jaqz519apro611 = 'S'
             and b.jaqz519arevr   is null; 
    exception
      when others then 
           pn_ind := 0;
    end;
    
    for i in creditos loop
      
    PQ_CR_REPROCONV.Sp_verifica602(i.jaqz519aemp,
                                    i.jaqz519amod,
                                    i.jaqz519asuc,
                                    i.jaqz519amda,
                                    i.jaqz519apap,
                                    i.jaqz519acta,
                                    i.jaqz519aope,
                                    i.jaqz519asbo,
                                    i.jaqz519atop,
                                    i.jaqz519afpp,
                                    lc_Spago);
                                    
    PQ_CR_REPROCONV.Sp_backup(i.jaqz519aemp,
                                    i.jaqz519amod,
                                    i.jaqz519asuc,
                                    i.jaqz519amda,
                                    i.jaqz519apap,
                                    i.jaqz519acta,
                                    i.jaqz519aope,
                                    i.jaqz519asbo,
                                    i.jaqz519atop);
                                             
    if lc_Spago = 'S' then                   
        
                 
        begin
          select count(*)
            into ln_con1
            from fsd601 a
           where a.pgcod  = i.jaqz519aemp
             and a.ppmod  = i.jaqz519amod
             and a.ppsuc  = i.jaqz519asuc
             and a.ppmda  = i.jaqz519amda
             and a.pppap  = i.jaqz519apap
             and a.ppcta  = i.jaqz519acta
             and a.ppoper = i.jaqz519aope
             and a.ppsbop = i.jaqz519asbo
             and a.pptope = i.jaqz519atop 
             and a.d601co = 'S';     
        exception
          when others then null;
        end;
        
        begin
          select count(*)
            into ln_con2
            from jaqz520a_601 a
           where a.pgcod  = i.jaqz519aemp
             and a.ppmod  = i.jaqz519amod
             and a.ppsuc  = i.jaqz519asuc
             and a.ppmda  = i.jaqz519amda
             and a.pppap  = i.jaqz519apap
             and a.ppcta  = i.jaqz519acta
             and a.ppoper = i.jaqz519aope
             and a.ppsbop = i.jaqz519asbo
             and a.pptope = i.jaqz519atop 
             and a.d601co = 'S';     
        exception
          when others then null;
        end;
        
        ln_contador1 := 0;
        ln_contador2 := 0;
        ld_fecAnt    := null;
        
        if ln_con1 = ln_con2 then
              
              
                                    
              for j in calendario_1(i.jaqz519aemp,
                                    i.jaqz519amod,
                                    i.jaqz519asuc,
                                    i.jaqz519amda,
                                    i.jaqz519apap,
                                    i.jaqz519acta,
                                    i.jaqz519aope,
                                    i.jaqz519asbo,
                                    i.jaqz519atop) loop
                                             
                  ln_contador1 := ln_contador1 + 1;
                  insert into jaqz522a(jaqz522acod,
                                      jaqz522aemp,
                                      jaqz522amod,
                                      jaqz522asuc,
                                      jaqz522amda,
                                      jaqz522apap,
                                      jaqz522acta,
                                      jaqz522aope,
                                      jaqz522asbo,
                                      jaqz522atop,
                                      jaqz522afac,
                                      jaqz522ausr,
                                      jaqz522afep)
                  values(ln_contador1,
                         i.jaqz519aemp,
                         i.jaqz519amod,
                         i.jaqz519asuc,
                         i.jaqz519amda,
                         i.jaqz519apap,
                         i.jaqz519acta,
                         i.jaqz519aope,
                         i.jaqz519asbo,
                         i.jaqz519atop,
                         j.ppfpag,
                         pc_usr,
                         pd_fec
                         );
                         
                         commit;
              end loop;
              
              for k in calendario_2(i.jaqz519aemp,
                                    i.jaqz519amod,
                                    i.jaqz519asuc,
                                    i.jaqz519amda,
                                    i.jaqz519apap,
                                    i.jaqz519acta,
                                    i.jaqz519aope,
                                    i.jaqz519asbo,
                                    i.jaqz519atop) loop
                                             
                  ln_contador2 := ln_contador2 + 1;
                  insert into jaqz522a_aux(jaqz522acod,
                                          jaqz522aemp,
                                          jaqz522amod,
                                          jaqz522asuc,
                                          jaqz522amda,
                                          jaqz522apap,
                                          jaqz522acta,
                                          jaqz522aope,
                                          jaqz522asbo,
                                          jaqz522atop,
                                          jaqz522afan)
                  values(ln_contador2,
                         i.jaqz519aemp,
                         i.jaqz519amod,
                         i.jaqz519asuc,
                         i.jaqz519amda,
                         i.jaqz519apap,
                         i.jaqz519acta,
                         i.jaqz519aope,
                         i.jaqz519asbo,
                         i.jaqz519atop,
                         k.ppfpag 
                         );
                         
                         commit;
              end loop;
              
              commit;
              
              
              for m in jaqz522(i.jaqz519aemp,
                               i.jaqz519amod,
                               i.jaqz519asuc,
                               i.jaqz519amda,
                               i.jaqz519apap,
                               i.jaqz519acta,
                               i.jaqz519aope,
                               i.jaqz519asbo,
                               i.jaqz519atop) loop
                  begin                 
                    select a.jaqz522afan
                      into ld_fecAnt
                      from jaqz522a_aux a 
                     where a.jaqz522acod = m.jaqz522acod
                       and a.jaqz522aemp = m.jaqz522aemp
                       and a.jaqz522amod = m.jaqz522amod
                       and a.jaqz522asuc = m.jaqz522asuc
                       and a.jaqz522amda = m.jaqz522amda
                       and a.jaqz522apap = m.jaqz522apap
                       and a.jaqz522acta = m.jaqz522acta
                       and a.jaqz522aope = m.jaqz522aope
                       and a.jaqz522asbo = m.jaqz522asbo
                       and a.jaqz522atop = m.jaqz522atop;
                  exception
                    when others then null;
                  end;
                  
                  update jaqz522a a
                     set a.jaqz522afan = ld_fecAnt
                   where a.jaqz522acod = m.jaqz522acod
                     and a.jaqz522aemp = m.jaqz522aemp
                     and a.jaqz522amod = m.jaqz522amod
                     and a.jaqz522asuc = m.jaqz522asuc
                     and a.jaqz522amda = m.jaqz522amda
                     and a.jaqz522apap = m.jaqz522apap
                     and a.jaqz522acta = m.jaqz522acta
                     and a.jaqz522aope = m.jaqz522aope
                     and a.jaqz522asbo = m.jaqz522asbo
                     and a.jaqz522atop = m.jaqz522atop;
                     
                     commit;
              end loop;
              commit;
              
              PQ_CR_REPROCONV.Sp_Revierte602_612(i.jaqz519aemp,
                                                  i.jaqz519amod,
                                                  i.jaqz519asuc,
                                                  i.jaqz519amda,
                                                  i.jaqz519apap,
                                                  i.jaqz519acta,
                                                  i.jaqz519aope,
                                                  i.jaqz519asbo,
                                                  i.jaqz519atop,
                                                  pc_usr,  
                                                  pd_fec
                                                  );
               --Actualiza si ya pago
               update jaqz519a a
                  set a.jaqz519aspag = 'S'
                where a.jaqz519aemp =i.jaqz519aemp
                 and a.jaqz519amod = i.jaqz519amod
                 and a.jaqz519asuc = i.jaqz519asuc
                 and a.jaqz519amda = i.jaqz519amda
                 and a.jaqz519apap = i.jaqz519apap
                 and a.jaqz519acta = i.jaqz519acta
                 and a.jaqz519aope = i.jaqz519aope
                 and a.jaqz519asbo = i.jaqz519asbo
                 and a.jaqz519atop = i.jaqz519atop;
            commit;                          
           
          end if;    
     end if;
     
        delete from fsd601 a
         where a.pgcod  = i.jaqz519aemp
           and a.ppmod  = i.jaqz519amod
           and a.ppsuc  = i.jaqz519asuc
           and a.ppmda  = i.jaqz519amda
           and a.pppap  = i.jaqz519apap
           and a.ppcta  = i.jaqz519acta
           and a.ppoper = i.jaqz519aope
           and a.ppsbop = i.jaqz519asbo
           and a.pptope = i.jaqz519atop;
                                   
        insert into fsd601 a
        select pgcod,
               ppmod,
               ppsuc,
               ppmda,
               pppap,
               ppcta,
               ppoper,
               ppsbop,
               pptope,
               ppfpag,
               pptipo,
               ppfval,
               ppfvto,
               pppzo,
               ppcap,
               ppint,
               ppintmex,
               ppicap,
               ppiint,
               ppstat,
               ppnume,
               ppfinv,
               d601cd,
               d601mo,
               d601su,
               d601tr,
               d601re,
               d601fc,
               d601or,
               d601sb,
               d601co
          from jaqz520a_601 b --jaqz520_601 a
         where b.pgcod = i.jaqz519aemp
           and b.ppmod = i.jaqz519amod
           and b.ppsuc = i.jaqz519asuc
           and b.ppmda = i.jaqz519amda
           and b.pppap = i.jaqz519apap
           and b.ppcta = i.jaqz519acta
           and b.ppoper = i.jaqz519aope
           and b.ppsbop = i.jaqz519asbo
           and b.pptope = i.jaqz519atop;
        --Actualiza si se revertio FSD601
        UPDATE jaqz519a a
           set a.jaqz519ar601 = 'S'
         where a.jaqz519aemp = i.jaqz519aemp
           and a.jaqz519amod = i.jaqz519amod
           and a.jaqz519asuc = i.jaqz519asuc
           and a.jaqz519amda = i.jaqz519amda
           and a.jaqz519apap = i.jaqz519apap
           and a.jaqz519acta = i.jaqz519acta
           and a.jaqz519aope = i.jaqz519aope
           and a.jaqz519asbo = i.jaqz519asbo
           and a.jaqz519atop = i.jaqz519atop;
                                       
        delete from fsd611 a
         where a.pgcod  = i.jaqz519aemp
           and a.ppmod  = i.jaqz519amod
           and a.ppsuc  = i.jaqz519asuc
           and a.ppmda  = i.jaqz519amda
           and a.pppap  = i.jaqz519apap
           and a.ppcta  = i.jaqz519acta
           and a.ppoper = i.jaqz519aope
           and a.ppsbop = i.jaqz519asbo
           and a.pptope = i.jaqz519atop;
                                   
        insert into fsd611 a
        select pgcod,
              ppmod,
              ppsuc,
              ppmda,
              pppap,
              ppcta,
              ppoper,
              ppsbop,
              pptope,
              ppfpag,
              pptipo,
              ppexte,
              ppimp1,
              ppimp2,
              ppimp3,
              ppimp4,
              ppimp5,
              ppimp6,
              ppimp7,
              ppimp8,
              ppimp9,
              ppimp10,
              ppimp11,
              ppimp12,
              ppimp13,
              ppimp14,
              ppimp15,
              ppimp16,
              ppimp17,
              ppimp18,
              ppimp19,
              ppimp20
         from jaqz520a_611 a
         where a.pgcod  = i.jaqz519aemp
           and a.ppmod  = i.jaqz519amod
           and a.ppsuc  = i.jaqz519asuc
           and a.ppmda  = i.jaqz519amda
           and a.pppap  = i.jaqz519apap
           and a.ppcta  = i.jaqz519acta
           and a.ppoper = i.jaqz519aope
           and a.ppsbop = i.jaqz519asbo
           and a.pptope = i.jaqz519atop;
                                   
        --Actualiza si se revertio FSD611
        UPDATE jaqz519a a
           set a.jaqz519ar611 = 'S'
         where a.jaqz519aemp = i.jaqz519aemp
           and a.jaqz519amod = i.jaqz519amod
           and a.jaqz519asuc = i.jaqz519asuc
           and a.jaqz519amda = i.jaqz519amda
           and a.jaqz519apap = i.jaqz519apap
           and a.jaqz519acta = i.jaqz519acta
           and a.jaqz519aope = i.jaqz519aope
           and a.jaqz519asbo = i.jaqz519asbo
           and a.jaqz519atop = i.jaqz519atop;
                                       
        select aofvto,
               aopzo
          into ld_fvto10,
               ln_pzo10
          from jaqz520a_010 a
         where a.pgcod  = i.jaqz519aemp
           and a.aomod  = i.jaqz519amod
           and a.aosuc  = i.jaqz519asuc
           and a.aomda  = i.jaqz519amda
           and a.aopap  = i.jaqz519apap
           and a.aocta  = i.jaqz519acta
           and a.aooper = i.jaqz519aope
           and a.aosbop = i.jaqz519asbo
           and a.aotope = i.jaqz519atop;
                                   
        
        update fsd010 a
           set a.aofvto = ld_fvto10,
               a.aopzo  = ln_pzo10
         where a.pgcod  = i.jaqz519aemp
           and a.aomod  = i.jaqz519amod
           and a.aosuc  = i.jaqz519asuc
           and a.aomda  = i.jaqz519amda
           and a.aopap  = i.jaqz519apap
           and a.aocta  = i.jaqz519acta
           and a.aooper = i.jaqz519aope
           and a.aosbop = i.jaqz519asbo
           and a.aotope = i.jaqz519atop;
                                   
        --Actualiza si se revertio FSD010
        UPDATE jaqz519a a
           set a.jaqz519ar010 = 'S'
         where a.jaqz519aemp = i.jaqz519aemp
           and a.jaqz519amod = i.jaqz519amod
           and a.jaqz519asuc = i.jaqz519asuc
           and a.jaqz519amda = i.jaqz519amda
           and a.jaqz519apap = i.jaqz519apap
           and a.jaqz519acta = i.jaqz519acta
           and a.jaqz519aope = i.jaqz519aope
           and a.jaqz519asbo = i.jaqz519asbo
           and a.jaqz519atop = i.jaqz519atop;
                                       
        select a.scfvto,
               a.scpzo
          into ld_fvto11,
               ln_pzo11
          from jaqz520a_011 a
         where a.pgcod  = i.jaqz519aemp
           and a.scmod  = i.jaqz519amod
           and a.scsuc  = i.jaqz519asuc
           and a.scmda  = i.jaqz519amda
           and a.scpap  = i.jaqz519apap
           and a.sccta  = i.jaqz519acta
           and a.scoper = i.jaqz519aope
           and a.scsbop = i.jaqz519asbo
           and a.sctope = i.jaqz519atop;
                                   
        update fsd011 a
           set a.scfvto = ld_fvto11,
               a.scpzo  = ln_pzo11
         where a.pgcod  = i.jaqz519aemp
           and a.scmod  = i.jaqz519amod
           and a.scsuc  = i.jaqz519asuc
           and a.scmda  = i.jaqz519amda
           and a.scpap  = i.jaqz519apap
           and a.sccta  = i.jaqz519acta
           and a.scoper = i.jaqz519aope
           and a.scsbop = i.jaqz519asbo
           and a.sctope = i.jaqz519atop;
                                   
      --Actualiza si se revertio FSD011
        UPDATE jaqz519a a
           set a.jaqz519ar011 = 'S'
         where a.jaqz519aemp = i.jaqz519aemp
           and a.jaqz519amod = i.jaqz519amod
           and a.jaqz519asuc = i.jaqz519asuc
           and a.jaqz519amda = i.jaqz519amda
           and a.jaqz519apap = i.jaqz519apap
           and a.jaqz519acta = i.jaqz519acta
           and a.jaqz519aope = i.jaqz519aope
           and a.jaqz519asbo = i.jaqz519asbo
           and a.jaqz519atop = i.jaqz519atop;
                                       
     --Actualiza estado, fecha y usario que hizo la reversion
         update jaqz519a a
            set a.jaqz519arevr = 'S',
                a.jaqz519afeca = pd_fec,
                a.jaqz519ausrr = pc_usr
          where a.jaqz519aemp = i.jaqz519aemp
           and a.jaqz519amod  = i.jaqz519amod
           and a.jaqz519asuc  = i.jaqz519asuc
           and a.jaqz519amda  = i.jaqz519amda
           and a.jaqz519apap  = i.jaqz519apap
           and a.jaqz519acta  = i.jaqz519acta
           and a.jaqz519aope  = i.jaqz519aope
           and a.jaqz519asbo  = i.jaqz519asbo
           and a.jaqz519atop  = i.jaqz519atop;
                                        
                      
          update jaqz867 a
            set a.jaqz867rev = 'S'
          where a.jaqz867emp = i.jaqz519aemp
            and a.jaqz867mod = i.jaqz519amod
            and a.jaqz867suc = i.jaqz519asuc
            and a.jaqz867mda = i.jaqz519amda
            and a.jaqz867pap = i.jaqz519apap
            and a.jaqz867cta = i.jaqz519acta
            and a.jaqz867ope = i.jaqz519aope
            and a.jaqz867sbo = i.jaqz519asbo
            and a.jaqz867top = i.jaqz519atop;
                                        
            
           commit;                         
    end loop;
    
 commit;
          
end Sp_extorno_cuenta;

Procedure Sp_parciales(pn_grupo in number)is
cursor Creditos is
select * from jaqz519a a 
where a.jaqz519aind = 'P'
  and a.jaqz519agrp = pn_grupo;

ln_cap number(17,2);
ln_int number(17,2);
ln_mor number(17,2);
ln_seg number(17,2);

begin
      for i in creditos loop
          ln_cap := 0;
          ln_int := 0;
          ln_mor := 0;
          ln_seg := 0;
          PQ_CR_REPROCONV.Sp_detallePago(i.jaqz519aemp,
                                        i.jaqz519amod,
                                        i.jaqz519asuc,
                                        i.jaqz519amda,
                                        i.jaqz519apap,
                                        i.jaqz519acta,
                                        i.jaqz519aope,
                                        i.jaqz519asbo,
                                        i.jaqz519atop,
                                        i.jaqz519afpp,
                                        ln_cap,  
                                        ln_int,
                                        ln_mor,
                                        ln_seg
                                        );
          
           update jaqz519a a
              set a.jaqz519acap = ln_cap,
                  a.jaqz519aint = ln_int,
                  a.jaqz519amor = ln_mor,
                  a.jaqz519aseg = ln_seg
            where a.jaqz519aemp = i.jaqz519aemp
              and a.jaqz519amod = i.jaqz519amod
              and a.jaqz519asuc = i.jaqz519asuc
              and a.jaqz519amda = i.jaqz519amda
              and a.jaqz519apap = i.jaqz519apap
              and a.jaqz519acta = i.jaqz519acta
              and a.jaqz519aope = i.jaqz519aope
              and a.jaqz519asbo = i.jaqz519asbo
              and a.jaqz519atop = i.jaqz519atop
              and a.jaqz519agrp = pn_grupo;
                  
                  commit;
                               
      end loop;
   commit;
  
     
end Sp_parciales;


Procedure Sp_ActParc_FSD611(pn_grupo in number) is
  cursor creditos is
select a.pgcod,
       a.aomod,
       a.aosuc,
       a.aomda,
       a.aopap,
       a.aocta,
       a.aooper,
       a.aosbop,
       a.aotope,
       b.jaqz519apdi
  from fsd010 a, jaqz519a b
 where a.pgcod  = b.jaqz519aemp
   and a.aomod  = b.jaqz519amod
   and a.aosuc  = b.jaqz519asuc
   and a.aomda  = b.jaqz519amda
   and a.aopap  = b.jaqz519apap
   and a.aocta  = b.jaqz519acta
   and a.aooper = b.jaqz519aope
   and a.aosbop = b.jaqz519asbo
   and a.aotope = b.jaqz519atop
   and a.aomod  in (select modulo from fst111 where dscod = 50)
   and b.jaqz519aind = 'P'
   and b.jaqz519agrp=pn_grupo
   and b.jaqz519amor = 0
   --and a.aocta = 1883837
   --and a.aooper = 2395363
   ;
   
ld_fecpxv date;

cursor calendario(pn_emp in number,
                  pn_mod in number,
                  pn_suc in number,
                  pn_mda in number,
                  pn_pap in number,
                  pn_cta in number,
                  pn_ope in number,
                  pn_sbo in number,
                  pn_top in number,
                  pd_fec in date) is
select * 
  from fsd611 a
 where a.pgcod  = pn_emp
   and a.ppmod  = pn_mod
   and a.ppsuc  = pn_suc
   and a.ppmda  = pn_mda
   and a.pppap  = pn_pap
   and a.ppcta  = pn_cta
   and a.ppoper = pn_ope
   and a.ppsbop = pn_sbo
   and a.pptope = pn_top
   and a.ppfpag >= pd_fec
order by ppfpag desc;

cursor calendario_asc(pn_emp in number,
                  pn_mod in number,
                  pn_suc in number,
                  pn_mda in number,
                  pn_pap in number,
                  pn_cta in number,
                  pn_ope in number,
                  pn_sbo in number,
                  pn_top in number,
                  pd_fec in date) is
select * 
  from fsd611 a
 where a.pgcod  = pn_emp
   and a.ppmod  = pn_mod
   and a.ppsuc  = pn_suc
   and a.ppmda  = pn_mda
   and a.pppap  = pn_pap
   and a.ppcta  = pn_cta
   and a.ppoper = pn_ope
   and a.ppsbop = pn_sbo
   and a.pptope = pn_top
   and a.ppfpag >= pd_fec
order by ppfpag asc;


type c_list is varray (999) of fsd601.ppfpag%type; 
name_list c_list := c_list(); 
counter number :=0; 
ln_cont number;
ln_int number;

ld_ppfpag date;

lc_hab_ppfpag char(1);

ld_ppfpag_F date;


ln_countTot number;
ln_contAF number;

--mod@abr 20170403
ld_fecha date;
ln_numpdi number;
--mod@abr 20170403

BEGIN 
  
for i in creditos loop
        ld_fecpxv := null;
          
        begin
          select /*+ parallel(n,2,1)*/
               min(n.ppfpag)
          into ld_fecpxv
          from fsd611 n
         where n.pgcod  = i.pgcod
           and n.ppcta  = i.aocta
           and n.ppmda  = i.aomda
           and n.ppsuc  = i.aosuc
           and n.pppap  = i.aopap
           and n.ppoper = i.aooper
           and n.ppsbop = i.aosbop
           and n.pptope = i.aotope
           and n.ppmod  = i.aomod
           --and n.d601co = 'S'
           --and (n.ppcap+n.ppint)<>0
           and not exists
                    (select /*+ parallel(o,2,1)*/  ppmod, ppcta,ppoper, pptope,ppfpag
                       from fsd602 o
                      where o.pgcod   = n.pgcod
                        and o.ppmod   = n.ppmod
                        and o.ppsuc   = n.ppsuc
                        and o.ppmda   = n.ppmda
                        and o.pppap   = n.pppap
                        and o.ppcta   = n.ppcta
                        and o.ppoper  = n.ppoper
                        and o.ppsbop  = n.ppsbop
                        and o.pptope  = n.pptope
                        and o.ppfpag  = n.ppfpag
                        and o.pp1stat = 'T'
                        and o.d602co  = 'S'
                        and (o.pp1cap+o.pp1int)<>0);
        exception
           when others then null;
        end;
        --dbms_output.put_line('ld_fecpxv-'||ld_fecpxv ); 
        counter := 0;
        ln_countTot := 0;
        name_list  := c_list();       
        for j in calendario_asc(i.pgcod,i.aomod,i.aosuc,i.aomda,i.aopap,i.aocta,i.aooper,i.aosbop,i.aotope,ld_fecpxv) loop

                counter := counter + 1; 
                name_list.extend; 
                name_list(counter)  := j.ppfpag; 
                --dbms_output.put_line('Customer('||counter ||'):'||name_list(counter)); 
   
          
        end loop;
        ln_countTot := counter ;
        ln_cont := 0;
        ln_contAF := 0;
        
        --mod@abr 20170403
        ld_fecha := add_months(ld_fecpxv,i.jaqz519apdi);  
              
        if ld_fecha between to_date('2017.03.30','yyyy.mm.dd') and to_date('2017.05.31','yyyy.mm.dd') then
           ln_numpdi := i.jaqz519apdi + 2;
           else
             ln_numpdi := i.jaqz519apdi;
        end if;
        
        --mod@abr 20170403
        
        for k in calendario(i.pgcod,i.aomod,i.aosuc,i.aomda,i.aopap,i.aocta,i.aooper,i.aosbop,i.aotope,ld_fecpxv) loop
          ln_cont := ln_cont + 1;
          
          if ln_cont < ln_numpdi + 1 then --mod@abr 20170403
                
              
                
                ld_ppfpag := add_months(k.ppfpag,ln_numpdi);--mod@abr 20170403
                 
                            
                  --verificar si es dia habil
                  begin
                    select a.fhabil
                      into lc_hab_ppfpag
                      from fst028 a,fst001 b
                     where a.calcod=b.calcod
                       and a.ffecha = ld_ppfpag
                       and b.sucurs = i.aosuc;
                  exception
                    when others then null;
                  end;
                  
                  if lc_hab_ppfpag = 'N' then
                     begin
                         select min(a.ffecha)
                           into ld_ppfpag_F
                           from fst028 a,fst001 b
                          where a.calcod = b.calcod
                            and a.ffecha > ld_ppfpag
                            and b.sucurs = i.aosuc
                            and a.fhabil = 'S';
                     exception
                       when others then null;
                     end;
                     
                     else
                       ld_ppfpag_F := ld_ppfpag;
                       
                  end if;
                  
                 
                  --dbms_output.put_line('0-'||k.ppcta||'-'||k.ppoper||'-'||ld_ppfpag_F||'-'||ld_ppfval_F||'-'||ld_ppfvto_F||'-'||k.ppfpag); 
                 
                  begin 
                    update fsd611  a
                       set a.ppfpag = ld_ppfpag_F,
                           a.pptipo='F'  --@mod 20170929
                     where a.pgcod  = k.pgcod 
                       and a.ppmod  = k.ppmod 
                       and a.ppsuc  = k.ppsuc 
                       and a.ppmda  = k.ppmda 
                       and a.pppap  = k.pppap 
                       and a.ppcta  = k.ppcta 
                       and a.ppoper = k.ppoper
                       and a.ppsbop = k.ppsbop
                       and a.pptope = k.pptope
                       and a.ppfpag = k.ppfpag;
                  -- exception
                    -- when others then
                     --dbms_output.put_line('1-'||k.ppcta||'-'||k.ppoper||'-'||ld_ppfpag_F||'-'||ld_ppfval_F||'-'||ld_ppfvto_F||'-'||k.ppfpag);
                   end; 
                   
                   
                   else
                       
                        ln_contAF := ln_contAF +1 ; 
                        ln_int := counter;
                        
                        while ln_int = counter loop
                              ld_ppfpag_F := name_list(ln_int);
                              ln_int := ln_int - 1;
                              
                             
                              begin 
                                update fsd611  a
                                   set a.ppfpag = ld_ppfpag_F,
                                       a.pptipo='F'  --@mod 20170929
                                 where a.pgcod  = k.pgcod 
                                   and a.ppmod  = k.ppmod 
                                   and a.ppsuc  = k.ppsuc 
                                   and a.ppmda  = k.ppmda 
                                   and a.pppap  = k.pppap 
                                   and a.ppcta  = k.ppcta 
                                   and a.ppoper = k.ppoper
                                   and a.ppsbop = k.ppsbop
                                   and a.pptope = k.pptope
                                   and a.ppfpag = k.ppfpag;
                               
                               end; 
                        end loop;
                        counter := counter - 1;
                      
                        If (ln_countTot - ln_contAF)=ln_numpdi then --mod@abr 20170403
                           exit;
                        end if;
                        
                    
             end if;
             
        end loop;
        
       update jaqz519a A
           set a.JAQZ519aPRO611 = 'S'
         where a.jaqz519aemp =  i.pgcod 
           and a.jaqz519amod =  i.aomod
           and a.jaqz519asuc =  i.aosuc
           and a.jaqz519amda =  i.aomda
           and a.jaqz519apap =  i.aopap
           and a.jaqz519acta =  i.aocta
           and a.jaqz519aope =  i.aooper
           and a.jaqz519asbo =  i.aosbop
           and a.jaqz519atop =  i.aotope
           and a.jaqz519agrp = pn_grupo;

   END LOOP; 
END Sp_ActParc_FSD611; 

Procedure Sp_ActParc_FSD601_602_612(pn_grupo in number)is
cursor creditos is

select a.jaqz519aemp pgcod, 
       a.jaqz519amod aomod,
       a.jaqz519asuc aosuc,
       a.jaqz519amda aomda,
       a.jaqz519apap aopap,
       a.jaqz519acta aocta,
       a.jaqz519aope aooper,
       a.jaqz519asbo aosbop,
       a.jaqz519atop aotope,
       a.jaqz519apdi 
  from jaqz519a a
 where a.jaqz519aind = 'P'
   and a.jaqz519agrp = pn_grupo
   and a.jaqz519amor = 0 --@mod 20170928
   ;  

   
ld_fecpxv date;

cursor calendario(pn_emp in number,
                  pn_mod in number,
                  pn_suc in number,
                  pn_mda in number,
                  pn_pap in number,
                  pn_cta in number,
                  pn_ope in number,
                  pn_sbo in number,
                  pn_top in number,
                  pd_fec in date) is
select * 
  from fsd601 a
 where a.pgcod  = pn_emp
   and a.ppmod  = pn_mod
   and a.ppsuc  = pn_suc
   and a.ppmda  = pn_mda
   and a.pppap  = pn_pap
   and a.ppcta  = pn_cta
   and a.ppoper = pn_ope
   and a.ppsbop = pn_sbo
   and a.pptope = pn_top
   and a.d601co = 'S'
   and (a.ppcap+a.ppint)<>0
   and a.ppfpag >= pd_fec
order by ppfpag desc;

cursor calendario_asc(pn_emp in number,
                  pn_mod in number,
                  pn_suc in number,
                  pn_mda in number,
                  pn_pap in number,
                  pn_cta in number,
                  pn_ope in number,
                  pn_sbo in number,
                  pn_top in number,
                  pd_fec in date) is
select * 
  from fsd601 a
 where a.pgcod  = pn_emp
   and a.ppmod  = pn_mod
   and a.ppsuc  = pn_suc
   and a.ppmda  = pn_mda
   and a.pppap  = pn_pap
   and a.ppcta  = pn_cta
   and a.ppoper = pn_ope
   and a.ppsbop = pn_sbo
   and a.pptope = pn_top
   and a.d601co = 'S'
   and (a.ppcap+a.ppint)<>0
   and a.ppfpag >= pd_fec
order by ppfpag asc;


type c_list is varray (999) of fsd601.ppfpag%type; 
name_list c_list := c_list(); 
counter number :=0; 
ln_cont number;
ln_int number;

ld_ppfpag date;
ld_ppfval date;
ld_ppfvto date;
lc_hab_ppfpag char(1);
lc_hab_ppfval char(1);
lc_hab_ppfvto char(1);
ld_ppfpag_F date;
ld_ppfval_F date;
ld_ppfvto_F date;

ln_countTot number;
ln_contAF number;

--PPFVAL
type c_list_FV is varray (999) of fsd601.ppfval%type; 
name_list_FV c_list_FV := c_list_FV(); 
counter_FV number :=0; 
ln_contFV number;
ln_intFV number;
--PPFVAL

--mod@abr 20170403
ld_fecha date;
ln_numpdi number;
--mod@abr 20170403

ld_fecpago date;
ld_fecpagoF date;
lc_hab_fecpago char(1);

BEGIN 
  
for i in creditos loop
        ld_fecpxv := null;
          
        begin
          select /*+ parallel(n,2,1)*/
               min(n.ppfpag)
          into ld_fecpxv
          from fsd601 n
         where n.pgcod  = i.pgcod
           and n.ppcta  = i.aocta
           and n.ppmda  = i.aomda
           and n.ppsuc  = i.aosuc
           and n.pppap  = i.aopap
           and n.ppoper = i.aooper
           and n.ppsbop = i.aosbop
           and n.pptope = i.aotope
           and n.ppmod  = i.aomod
           and n.d601co = 'S'
           and (n.ppcap+n.ppint)<>0
           and not exists
                    (select /*+ parallel(o,2,1)*/  ppmod, ppcta,ppoper, pptope,ppfpag
                       from fsd602 o
                      where o.pgcod   = n.pgcod
                        and o.ppmod   = n.ppmod
                        and o.ppsuc   = n.ppsuc
                        and o.ppmda   = n.ppmda
                        and o.pppap   = n.pppap
                        and o.ppcta   = n.ppcta
                        and o.ppoper  = n.ppoper
                        and o.ppsbop  = n.ppsbop
                        and o.pptope  = n.pptope
                        and o.ppfpag  = n.ppfpag
                        and o.pp1stat = 'T'
                        and o.d602co  = 'S'
                        and (o.pp1cap+o.pp1int)<>0);
        exception
           when others then null;
        end;
        
        counter := 0;
        ln_countTot := 0;
        name_list := c_list(); 
        for j in calendario_asc(i.pgcod,i.aomod,i.aosuc,i.aomda,i.aopap,i.aocta,i.aooper,i.aosbop,i.aotope,ld_fecpxv) loop

                counter := counter + 1; 
                name_list.extend; 
                name_list(counter)  := j.ppfpag; 
                --dbms_output.put_line('Customer('||counter ||'):'||name_list(counter)); 
   
          
        end loop;
        ln_countTot := counter ;
        ln_cont := 0;
        ln_contAF := 0;
        --mod@abr 20170403
        ld_fecha := add_months(ld_fecpxv,i.jaqz519apdi);  
              
        if ld_fecha between to_date('2017.03.30','yyyy.mm.dd') and to_date('2017.05.31','yyyy.mm.dd') then
           ln_numpdi := i.jaqz519apdi + 2;
           else
             ln_numpdi := i.jaqz519apdi;
        end if;
        
        --mod@abr 20170403
        
        for k in calendario(i.pgcod,i.aomod,i.aosuc,i.aomda,i.aopap,i.aocta,i.aooper,i.aosbop,i.aotope,ld_fecpxv) loop
          ln_cont := ln_cont + 1;
          
          if ln_cont < ln_numpdi + 1 then --MOD@ABR 20170403
                ld_ppfpag := add_months(k.ppfpag,ln_numpdi);--MOD@ABR 20170403
                ld_ppfval := add_months(k.ppfval,ln_numpdi);--MOD@ABR 20170403
                ld_ppfvto := add_months(k.ppfvto,ln_numpdi);--MOD@ABR 20170403
                  
                  --verificar si es dia habil
                  begin
                    select a.fhabil
                      into lc_hab_ppfpag
                      from fst028 a,fst001 b
                     where a.calcod=b.calcod
                       and a.ffecha = ld_ppfpag
                       and b.sucurs = i.aosuc;
                  exception
                    when others then null;
                  end;
                  
                  if lc_hab_ppfpag = 'N' then
                     begin
                         select min(a.ffecha)
                           into ld_ppfpag_F
                           from fst028 a,fst001 b
                          where a.calcod = b.calcod
                            and a.ffecha > ld_ppfpag
                            and b.sucurs = i.aosuc
                            and a.fhabil = 'S';
                     exception
                       when others then null;
                     end;
                     
                     else
                       ld_ppfpag_F := ld_ppfpag;
                       
                  end if;
                  
                  begin
                    select a.fhabil
                      into lc_hab_ppfval
                      from fst028 a,fst001 b
                     where a.calcod = b.calcod
                       and a.ffecha = ld_ppfval
                       and b.sucurs = i.aosuc;
                  exception
                    when others then null;
                  end;
                  
                  if lc_hab_ppfval = 'N' then
                     begin
                         select min(a.ffecha)
                           into ld_ppfval_F
                           from fst028 a,fst001 b
                          where a.calcod = b.calcod
                            and a.ffecha > ld_ppfval
                            and b.sucurs = i.aosuc
                            and a.fhabil = 'S';
                     exception
                       when others then null;
                     end;
                     
                     else 
                        ld_ppfval_F := ld_ppfval;
                  end if;
                  
                  begin
                    select a.fhabil
                      into lc_hab_ppfvto
                      from fst028 a,fst001 b
                     where a.calcod=b.calcod
                       and a.ffecha = ld_ppfvto
                       and b.sucurs = i.aosuc;
                  exception
                    when others then null;
                  end;
                  
                  if lc_hab_ppfpag = 'N' then
                     begin
                         select min(a.ffecha)
                           into ld_ppfvto_F
                           from fst028 a,fst001 b
                          where a.calcod = b.calcod
                            and a.ffecha > ld_ppfvto
                            and b.sucurs = i.aosuc
                            and a.fhabil = 'S';
                     exception
                       when others then null;
                     end;
                     
                     else
                         ld_ppfvto_F := ld_ppfvto;
                  end if;
                  --dbms_output.put_line('0-'||k.ppcta||'-'||k.ppoper||'-'||ld_ppfpag_F||'-'||ld_ppfval_F||'-'||ld_ppfvto_F||'-'||k.ppfpag); 
                  begin 
                    update fsd601  a
                       set a.ppfpag = ld_ppfpag_F,
                           a.ppfval = ld_ppfval_F,
                           a.ppfvto = ld_ppfvto_F,
                           a.pptipo = 'F'  --@mod 20170929
                     where a.pgcod  = k.pgcod 
                       and a.ppmod  = k.ppmod 
                       and a.ppsuc  = k.ppsuc 
                       and a.ppmda  = k.ppmda 
                       and a.pppap  = k.pppap 
                       and a.ppcta  = k.ppcta 
                       and a.ppoper = k.ppoper
                       and a.ppsbop = k.ppsbop
                       and a.pptope = k.pptope
                       and a.ppfpag = k.ppfpag;
                  -- exception
                    -- when others then
                     --dbms_output.put_line('1-'||k.ppcta||'-'||k.ppoper||'-'||ld_ppfpag_F||'-'||ld_ppfval_F||'-'||ld_ppfvto_F||'-'||k.ppfpag);
                   end; 
                   
                   
                   else
             
                        ln_contAF := ln_contAF +1 ; 
                        ln_int := counter;
                        
                        while ln_int = counter loop
                              ld_ppfpag_F := name_list(ln_int);
                              ln_int := ln_int - 1;
                              
                              --dbms_output.put_line( '3-'||ln_int||'-'||counter||'-'||ld_ppfpag_F||'-'||k.ppfpag);
                              begin 
                                update fsd601  a
                                   set a.ppfpag = ld_ppfpag_F,
                                       --a.ppfval = ld_ppfval_F,
                                       a.ppfvto = ld_ppfpag_F,
                                       a.pptipo = 'F'  --@mod 20170929
                                 where a.pgcod  = k.pgcod 
                                   and a.ppmod  = k.ppmod 
                                   and a.ppsuc  = k.ppsuc 
                                   and a.ppmda  = k.ppmda 
                                   and a.pppap  = k.pppap 
                                   and a.ppcta  = k.ppcta 
                                   and a.ppoper = k.ppoper
                                   and a.ppsbop = k.ppsbop
                                   and a.pptope = k.pptope
                                   and a.ppfpag = k.ppfpag;
                               --exception
                                 --when others then
                                   --dbms_output.put_line( '2-'||k.ppcta||'-'||k.ppoper||'-'||ld_ppfpag_F||'-'||ld_ppfval_F||'-'||ld_ppfvto_F||'-'||k.ppfpag);
                               end; 
                        end loop;
                        counter := counter - 1;
                        --dbms_output.put_line( '4-'||counter||'-'||ln_countTot);
                        
                        
                        
                        
                        If (ln_countTot - ln_contAF)=ln_numpdi then --mod@abr 20170403
                           exit;
                        end if;
                        
                    
             end if;
             
        end loop;
        
        --PPFVAL
   
        counter_FV := 0;    
        name_list_FV := c_list_FV();  
        for j in calendario_asc(i.pgcod,i.aomod,i.aosuc,i.aomda,i.aopap,i.aocta,i.aooper,i.aosbop,i.aotope,ld_fecpxv) loop

       
                counter_FV := counter_FV + 1; 
                name_list_FV.extend; 
                name_list_FV(counter_FV)  := j.ppfpag; 

        end loop;
        
        
        ln_contFV  :=0;
       
        ln_intFV := 1;
        For g in calendario_asc(i.pgcod,i.aomod,i.aosuc,i.aomda,i.aopap,i.aocta,i.aooper,i.aosbop,i.aotope,ld_fecpxv)  loop
            ln_contFV := ln_contFV + 1;
            
            if ln_contFV >=2 then
               counter_FV := ln_intFV ;
               --dbms_output.put_line( 'FV1'||ln_intFV||'-'||counter_FV);
               while ln_intFV = counter_FV loop
                     ld_ppfval_F := name_list_FV(ln_intFV);
                     --dbms_output.put_line( 'FV2'||ld_ppfval_F||'-'||ln_intFV);
                     counter_FV := counter_FV - 1;
                     begin 
                        update fsd601  a
                           set a.ppfval = ld_ppfval_F
                         where a.pgcod  = g.pgcod 
                           and a.ppmod  = g.ppmod 
                           and a.ppsuc  = g.ppsuc 
                           and a.ppmda  = g.ppmda 
                           and a.pppap  = g.pppap 
                           and a.ppcta  = g.ppcta 
                           and a.ppoper = g.ppoper
                           and a.ppsbop = g.ppsbop
                           and a.pptope = g.pptope
                           and a.ppfpag = g.ppfpag;
                       --exception
                         --when others then
                         --dbms_output.put_line( '2-'||k.ppcta||'-'||k.ppoper||'-'||ld_ppfpag_F||'-'||ld_ppfval_F||'-'||ld_ppfvto_F||'-'||k.ppfpag);
                       end; 
               
               end loop;
               ln_intFV := ln_intFV + 1;
               --dbms_output.put_line( 'FV2'||ln_intFV);
            end if;
        end loop;
        --PPFVAL
        
        --PAGO PARCIAL FSD602 --
        ld_fecpago :=  add_months(ld_fecpxv,i.jaqz519apdi);  
       
         --verificar si es dia habil
                  begin
                    select a.fhabil
                      into lc_hab_fecpago
                      from fst028 a,fst001 b
                     where a.calcod=b.calcod
                       and a.ffecha = ld_fecpago
                       and b.sucurs = i.aosuc;
                  exception
                    when others then null;
                  end;
                  
                  if lc_hab_fecpago = 'N' then
                     begin
                         select min(a.ffecha)
                           into ld_fecpagoF
                           from fst028 a,fst001 b
                          where a.calcod = b.calcod
                            and a.ffecha > ld_fecpago
                            and b.sucurs = i.aosuc
                            and a.fhabil = 'S';
                     exception
                       when others then null;
                     end;
                     
                     else
                       ld_fecpagoF := ld_fecpago;
                       
                  end if;
                  
        begin
               update fsd602 a
                  set a.ppfpag = ld_fecpagoF,
                      a.pptipo = 'F'  --@mod 20170929
                where a.pgcod  = i.pgcod
                  and a.ppmod  = i.aomod
                  and a.ppsuc  = i.aosuc 
                  and a.ppmda  = i.aomda 
                  and a.pppap  = i.aopap 
                  and a.ppcta  = i.aocta 
                  and a.ppoper = i.aooper
                  and a.ppsbop = i.aosbop
                  and a.pptope = i.aotope
                  and a.ppfpag = ld_fecpxv
                  and a.d602co = 'S';
  
        end;
        
        begin
               update fsd612 a
                  set a.ppfpag = ld_fecpagoF,
                      a.pptipo = 'F'  --@mod 20170929
                where a.pgcod  = i.pgcod
                  and a.ppmod  = i.aomod
                  and a.ppsuc  = i.aosuc 
                  and a.ppmda  = i.aomda 
                  and a.pppap  = i.aopap 
                  and a.ppcta  = i.aocta 
                  and a.ppoper = i.aooper
                  and a.ppsbop = i.aosbop
                  and a.pptope = i.aotope
                  and a.ppfpag = ld_fecpxv;
  
        end;
        
           update jaqz519a A
           set a.JAQZ519aPRO602 = 'S',
               a.JAQZ519aPRO601 = 'S',
               a.JAQZ519aPRO612 = 'S'
         where a.jaqz519aemp =  i.pgcod 
           and a.jaqz519amod =  i.aomod
           and a.jaqz519asuc =  i.aosuc
           and a.jaqz519amda =  i.aomda
           and a.jaqz519apap =  i.aopap
           and a.jaqz519acta =  i.aocta
           and a.jaqz519aope =  i.aooper
           and a.jaqz519asbo =  i.aosbop
           and a.jaqz519atop =  i.aotope
           and a.jaqz519agrp = pn_grupo;
        
         commit;
        
   END LOOP; 
   commit;
END Sp_ActParc_FSD601_602_612;

Procedure Sp_ActParc_FSD010(pn_grupo in number) is
cursor creditos is
select a.pgcod,
       a.aomod,
       a.aosuc,
       a.aomda,
       a.aopap,
       a.aocta,
       a.aooper,
       a.aosbop,
       a.aotope,
       b.jaqz519apzo,
       a.aofval
  from fsd010 a, jaqz519a b
 where a.pgcod  = b.jaqz519aemp 
   and a.aomod  = b.jaqz519amod 
   and a.aosuc  = b.jaqz519asuc 
   and a.aomda  = b.jaqz519amda 
   and a.aopap  = b.jaqz519apap 
   and a.aocta  = b.jaqz519acta 
   and a.aooper = b.jaqz519aope
   and a.aosbop = b.jaqz519asbo
   and a.aotope = b.jaqz519atop
   and a.aomod  in (select modulo from fst111 where dscod = 50)
   and b.jaqz519aind = 'P'
   and b.jaqz519agrp=pn_grupo
   and b.jaqz519amor = 0 --@mod 20170928
   ;
   
ld_fecvto date;  
begin

  for i in creditos loop
    
      begin
          select max(ppfpag)
            into ld_fecvto
            from fsd601 a
           where a.pgcod  = i.pgcod 
             and a.ppmod  = i.aomod 
             and a.ppsuc  = i.aosuc 
             and a.ppmda  = i.aomda 
             and a.pppap  = i.aopap 
             and a.ppcta  = i.aocta 
             and a.ppoper = i.aooper
             and a.ppsbop = i.aosbop
             and a.pptope = i.aotope
             and d601co = 'S';
      exception 
        when others then null;      
      end;
  
      update fsd010 
         set aofvto = ld_fecvto,
             aopzo  = ld_fecvto - aofval
       where pgcod  = i.pgcod 
         and aomod  = i.aomod 
         and aosuc  = i.aosuc 
         and aomda  = i.aomda 
         and aopap  = i.aopap 
         and aocta  = i.aocta 
         and aooper = i.aooper
         and aosbop = i.aosbop
         and aotope = i.aotope ;
      commit;
      
      update jaqz519a A
           set a.JAQZ519aPRO10 = 'S'
         where a.jaqz519aemp =  i.pgcod 
           and a.jaqz519amod =  i.aomod
           and a.jaqz519asuc =  i.aosuc
           and a.jaqz519amda =  i.aomda
           and a.jaqz519apap =  i.aopap
           and a.jaqz519acta =  i.aocta
           and a.jaqz519aope =  i.aooper
           and a.jaqz519asbo =  i.aosbop
           and a.jaqz519atop =  i.aotope
           and a.jaqz519agrp = pn_grupo;
         
        COMMIT;
        
        
  end loop;
  commit;
end Sp_ActParc_FSD010;  

Procedure Sp_ActParc_FSD011(pn_grupo in number) is
  cursor creditos is
select a.pgcod,
       a.scsuc,
       a.scmda,
       a.scpap,
       a.sccta,
       a.scoper,
       a.scsbop,
       a.sctope,
       a.scmod,
       b.jaqz519apzo,
       a.scfval 
  from fsd011 a,jaqz519a b
 where a.pgcod  = b.jaqz519aemp 
   and a.scsuc  = b.jaqz519asuc 
   and a.scmda  = b.jaqz519amda  
   and a.scpap  = b.jaqz519apap 
   and a.sccta  = b.jaqz519acta  
   and a.scoper = b.jaqz519aope  
   and a.scsbop = b.jaqz519asbo 
   and a.sctope = b.jaqz519atop 
   and a.scmod  = b.jaqz519amod
   and a.scfvto is not null
   and b.jaqz519aind = 'P'
   and b.jaqz519agrp=pn_grupo
   and b.jaqz519amor = 0 --@mod 20170928
   ;
ld_fecvto date;
   
begin
   for i in creditos loop
       
       begin
          select max(ppfpag)
            into ld_fecvto
            from fsd601 a
           where a.pgcod  = i.pgcod 
             and a.ppmod  = i.scmod 
             and a.ppsuc  = i.scsuc 
             and a.ppmda  = i.scmda 
             and a.pppap  = i.scpap 
             and a.ppcta  = i.sccta 
             and a.ppoper = i.scoper
             and a.ppsbop = i.scsbop
             and a.pptope = i.sctope
             and d601co = 'S';
      exception 
        when others then null;      
      end;
       
       update fsd011
          set scfvto = ld_fecvto,
              scpzo  = ld_fecvto - i.scfval --mod@abr 20170405
        where pgcod  = i.pgcod 
          and scsuc  = i.scsuc 
          and scmda  = i.scmda 
          and scpap  = i.scpap 
          and sccta  = i.sccta 
          and scoper = i.scoper
          and scsbop = i.scsbop
          and sctope = i.sctope
          and scmod  = i.scmod ;
              
              commit;  
              
        update jaqz519a A
           set a.JAQZ519aPRO11 = 'S'
         where a.jaqz519aemp =  i.pgcod 
           and a.jaqz519amod =  i.scmod
           and a.jaqz519asuc =  i.scsuc
           and a.jaqz519amda =  i.scmda
           and a.jaqz519apap =  i.scpap
           and a.jaqz519acta =  i.sccta
           and a.jaqz519aope =  i.scoper
           and a.jaqz519asbo =  i.scsbop
           and a.jaqz519atop =  i.sctope
           and a.jaqz519agrp = pn_grupo;
         
        COMMIT;
              
                     
   end loop;
   commit;
end Sp_ActParc_FSD011;
Procedure Sp_detallePago(pn_emp in number,
                         pn_mod in number,
                         pn_suc in number,
                         pn_mda in number,
                         pn_pap in number,
                         pn_cta in number,
                         pn_ope in number,
                         pn_sbo in number,
                         pn_top in number,
                         pd_fec in date,
                         pn_cap out number,
                         pn_int out number,
                         pn_mor out number,
                         pn_seg out number)is
                         
begin                         
    begin
         select nvl(sum(a.pp1cap),0),
                nvl(sum(a.pp1int),0),
                nvl(sum(a.pp1intm),0)
           into pn_cap,
                pn_int,
                pn_mor
           from fsd602 a
          where a.pgcod  = pn_emp
            and a.ppmod  = pn_mod
            and a.ppsuc  = pn_suc
            and a.ppmda  = pn_mda
            and a.pppap  = pn_pap
            and a.ppcta  = pn_cta
            and a.ppoper = pn_ope
            and a.ppsbop = pn_sbo
            and a.pptope = pn_top
            and a.ppfpag = pd_fec
            and a.d602co = 'S';
    exception
      when others then 
           pn_cap := 0;
           pn_int := 0;
           pn_mor := 0;
    end;  
    
    begin
        select nvl(sum(c.pp1imp11+c.pp1imp12+c.pp1imp13+c.pp1imp14+c.pp1imp15),0)
          into pn_seg
          from fsd602 a,fsd612 c
         where a.pgcod  = pn_emp
           and a.ppmod  = pn_mod
           and a.ppsuc  = pn_suc
           and a.ppmda  = pn_mda
           and a.pppap  = pn_pap
           and a.ppcta  = pn_cta
           and a.ppoper = pn_ope
           and a.ppsbop = pn_sbo
           and a.pptope = pn_top
           and a.ppfpag = pd_fec
           and a.pgcod  = c.pgcod 
           and a.ppmod  = c.ppmod 
           and a.ppsuc  = c.ppsuc 
           and a.ppmda  = c.ppmda 
           and a.pppap  = c.pppap 
           and a.ppcta  = c.ppcta 
           and a.ppoper = c.ppoper
           and a.ppsbop = c.ppsbop
           and a.pptope = c.pptope
           and a.ppfpag = c.ppfpag
           and a.pp1nump = c.pp1nump
           and a.d602co = 'S' ; 
    exception
      when others then 
           pn_seg := 0;
    end;

end Sp_detallePago;


Procedure Sp_verificaRepetidos(pn_grupo in number) is
cursor creditos is
select * from jaqz519a a where a.jaqz519agrp = pn_grupo;
lc_flg char(1);
begin
 for i in creditos loop 
  lc_flg := i.jaqz519aind;
  begin
    select 'R'
      into lc_flg
      from jaqz519a a
     where a.jaqz519aemp = i.jaqz519aemp
       and a.jaqz519amod = i.jaqz519amod
       and a.jaqz519asuc = i.jaqz519asuc
       and a.jaqz519amda = i.jaqz519amda
       and a.jaqz519apap = i.jaqz519apap
       and a.jaqz519acta = i.jaqz519acta
       and a.jaqz519aope = i.jaqz519aope
       and a.jaqz519asbo = i.jaqz519asbo
       and a.jaqz519atop = i.jaqz519atop
       and a.jaqz519agrp <> pn_grupo
       ;
  exception
  when others then 
       lc_flg := i.jaqz519aind;
  end;
  
  update jaqz519a a
     set a.jaqz519aind = lc_flg
   where a.jaqz519aemp = i.jaqz519aemp
     and a.jaqz519amod = i.jaqz519amod
     and a.jaqz519asuc = i.jaqz519asuc
     and a.jaqz519amda = i.jaqz519amda
     and a.jaqz519apap = i.jaqz519apap
     and a.jaqz519acta = i.jaqz519acta
     and a.jaqz519aope = i.jaqz519aope
     and a.jaqz519asbo = i.jaqz519asbo
     and a.jaqz519atop = i.jaqz519atop
     and a.jaqz519agrp = pn_grupo;
     
     commit;
      
 end loop;

end Sp_verificaRepetidos;


Procedure Sp_verifica602(pn_emp in number,
                       pn_mod in number,
                       pn_suc in number,
                       pn_mda in number,
                       pn_pap in number,
                       pn_cta in number,
                       pn_ope in number,
                       pn_sbo in number,
                       pn_top in number,
                       pd_fec in date,
                       lc_cambia out char)is


begin
     lc_cambia := 'N';
     begin
          select 'S'
            into lc_cambia
            from fsd602 a
           where a.pgcod  =  pn_emp
             and a.ppmod  =  pn_mod
             and a.ppsuc  =  pn_suc
             and a.ppmda  =  pn_mda
             and a.pppap  =  pn_pap
             and a.ppcta  =  pn_cta
             and a.ppoper =  pn_ope
             and a.ppsbop =  pn_sbo
             and a.pptope =  pn_top
             and a.ppfpag >= pd_fec 
             and a.pptipo =  'F'
             and rownum =1;
     exception
       when others then 
         lc_cambia := 'N';
     end;
end Sp_verifica602;

Procedure Sp_Revierte602_612(pn_emp in number,
                             pn_mod in number,
                             pn_suc in number,
                             pn_mda in number,
                             pn_pap in number,
                             pn_cta in number,
                             pn_ope in number,
                             pn_sbo in number,
                             pn_top in number,
                             pc_usr in char,
                             pd_fec in date)is

cursor calendario is
select * 
  from fsd602 a
 where a.pgcod  = pn_emp
   and a.ppmod  = pn_mod
   and a.ppsuc  = pn_suc
   and a.ppmda  = pn_mda
   and a.pppap  = pn_pap
   and a.ppcta  = pn_cta
   and a.ppoper = pn_ope
   and a.ppsbop = pn_sbo
   and a.pptope = pn_top 
   and a.d602co = 'S'
order by ppfpag;  
ld_fecant date;

begin
     for i in calendario loop
         begin
           select a.jaqz522afan
             into ld_fecant
             from jaqz522A a
            where a.jaqz522aemp = i.pgcod  
              and a.jaqz522amod = i.ppmod 
              and a.jaqz522asuc = i.ppsuc 
              and a.jaqz522amda = i.ppmda 
              and a.jaqz522apap = i.pppap 
              and a.jaqz522acta = i.ppcta 
              and a.jaqz522aope = i.ppoper
              and a.jaqz522asbo = i.ppsbop
              and a.jaqz522atop = i.pptope
              and a.jaqz522afac = i.ppfpag
              and a.jaqz522ausr = pc_usr
              and a.jaqz522afep = pd_fec;
         exception
           when others then null;
         end;
         
         update fsd602 a
            set a.ppfpag = ld_fecant,
                a.pptipo = 'M'
          where a.pgcod  = i.pgcod 
            and a.ppmod  = i.ppmod 
            and a.ppsuc  = i.ppsuc 
            and a.ppmda  = i.ppmda 
            and a.pppap  = i.pppap 
            and a.ppcta  = i.ppcta 
            and a.ppoper = i.ppoper
            and a.ppsbop = i.ppsbop
            and a.pptope = i.pptope
            and a.ppfpag = i.ppfpag
            and a.d602co = 'S' ;
            
         --Actualiza si se revertio FSD602
        UPDATE jaqz519a a
           set a.jaqz519ar602 = 'S'
         where a.jaqz519aemp = i.pgcod 
           and a.jaqz519amod = i.ppmod 
           and a.jaqz519asuc = i.ppsuc 
           and a.jaqz519amda = i.ppmda 
           and a.jaqz519apap = i.pppap 
           and a.jaqz519acta = i.ppcta 
           and a.jaqz519aope = i.ppoper
           and a.jaqz519asbo = i.ppsbop
           and a.jaqz519atop = i.pptope;
           
         update fsd612 a
            set a.ppfpag = ld_fecant,
                a.pptipo = 'M'
          where a.pgcod  = i.pgcod 
            and a.ppmod  = i.ppmod 
            and a.ppsuc  = i.ppsuc 
            and a.ppmda  = i.ppmda 
            and a.pppap  = i.pppap 
            and a.ppcta  = i.ppcta 
            and a.ppoper = i.ppoper
            and a.ppsbop = i.ppsbop
            and a.pptope = i.pptope
            and a.ppfpag = i.ppfpag;
            
         --Actualiza si se revertio FSD612
        UPDATE jaqz519a a
           set a.jaqz519ar612 = 'S'
         where a.jaqz519aemp = i.pgcod 
           and a.jaqz519amod = i.ppmod 
           and a.jaqz519asuc = i.ppsuc 
           and a.jaqz519amda = i.ppmda 
           and a.jaqz519apap = i.pppap 
           and a.jaqz519acta = i.ppcta 
           and a.jaqz519aope = i.ppoper
           and a.jaqz519asbo = i.ppsbop
           and a.jaqz519atop = i.pptope;
          commit; 
     end loop;
     commit;
end Sp_Revierte602_612;

Procedure Sp_ObtieneFechaOri(pn_cta in number,
                             pn_ope in number,
                             pd_fec out date)is

begin
      begin
          select a.jaqz519afpp
            into pd_fec
            from jaqz519a a
           where a.jaqz519acta = pn_cta
             and a.jaqz519aope = pn_ope ;
      exception
        when too_many_rows then
             begin
                  select a.jaqz519afpp
                    into pd_fec
                    from jaqz519a a
                   where a.jaqz519acta = pn_cta
                     and a.jaqz519aope = pn_ope
                     and rownum = 1 ;
              exception
                when others then null;
              end;
        when others then null;
      end;

end Sp_ObtieneFechaOri;

Procedure Sp_backup (pn_emp in number,
                     pn_mod in number,
                     pn_suc in number,
                     pn_mda in number,
                     pn_pap in number,
                     pn_cta in number,
                     pn_ope in number,
                     pn_sbo in number,
                     pn_top in number)is
                     
  -- MODIFCADO : DCASTRO 2017.05.17 Se detallo campos a insertar en JAQZ525_519                     
                     
begin
     insert into jaqz525A_010
     select * from fsd010 a 
      where a.pgcod  = pn_emp
        and a.aomod  = pn_mod
        and a.aosuc  = pn_suc
        and a.aomda  = pn_mda
        and a.aopap  = pn_pap
        and a.aocta  = pn_cta
        and a.aooper = pn_ope
        and a.aosbop = pn_sbo
        and a.aotope = pn_top;
        
        
      insert into jaqz525A_011
     select * from fsd011 a 
      where a.pgcod  = pn_emp
        and a.scmod  = pn_mod
        and a.scsuc  = pn_suc
        and a.scmda  = pn_mda
        and a.scpap  = pn_pap
        and a.sccta  = pn_cta
        and a.scoper = pn_ope
        and a.scsbop = pn_sbo
        and a.sctope = pn_top;
        
      insert into jaqz525A_601
     select * from fsd601 a 
      where a.pgcod  = pn_emp
        and a.ppmod  = pn_mod
        and a.ppsuc  = pn_suc
        and a.ppmda  = pn_mda
        and a.pppap  = pn_pap
        and a.ppcta  = pn_cta
        and a.ppoper = pn_ope
        and a.ppsbop = pn_sbo
        and a.pptope = pn_top;
        
      insert into jaqz525A_611
     select * from fsd611 a 
      where a.pgcod  = pn_emp
        and a.ppmod  = pn_mod
        and a.ppsuc  = pn_suc
        and a.ppmda  = pn_mda
        and a.pppap  = pn_pap
        and a.ppcta  = pn_cta
        and a.ppoper = pn_ope
        and a.ppsbop = pn_sbo
        and a.pptope = pn_top;
        
      insert into jaqz525A_602
     select * from fsd602 a 
      where a.pgcod  = pn_emp
        and a.ppmod  = pn_mod
        and a.ppsuc  = pn_suc
        and a.ppmda  = pn_mda
        and a.pppap  = pn_pap
        and a.ppcta  = pn_cta
        and a.ppoper = pn_ope
        and a.ppsbop = pn_sbo
        and a.pptope = pn_top;
        
       insert into jaqz525A_612
     select * from fsd612 a 
      where a.pgcod  = pn_emp
        and a.ppmod  = pn_mod
        and a.ppsuc  = pn_suc
        and a.ppmda  = pn_mda
        and a.pppap  = pn_pap
        and a.ppcta  = pn_cta
        and a.ppoper = pn_ope
        and a.ppsbop = pn_sbo
        and a.pptope = pn_top;

       insert into jaqz525A_519
     select JAQZ519Aemp, JAQZ519Amod, JAQZ519Asuc, JAQZ519Amda, JAQZ519Apap, 
            JAQZ519Acta, JAQZ519Aope, JAQZ519Asbo, JAQZ519Atop, JAQZ519Apzo, JAQZ519Aest, 
            JAQZ519Aind, JAQZ519Agrp, JAQZ519Arub, JAQZ519Asdo, JAQZ519Apdi, JAQZ519Apro10, 
            JAQZ519Apro11, JAQZ519Apro601, JAQZ519Apro611, JAQZ519Afep, JAQZ519Afpp, JAQZ519Avac, 
            JAQZ519Avac2, JAQZ519Acap, JAQZ519Aint, JAQZ519Amor, JAQZ519Aseg, JAQZ519Apro602, JAQZ519Apro612, 
            JAQZ519Afeca, JAQZ519Ar010, JAQZ519Ar011, JAQZ519Ar601, JAQZ519Ar611, JAQZ519Ar602, JAQZ519Ar612, 
            JAQZ519Aspag, JAQZ519Arevr, JAQZ519Ausrr, JAQZ519Afere,JAQZ519AIDC,JAQZ519ADIAS,
            JAQZ519ACUOT      
     from JAQZ519A a 
      where a.JAQZ519Aemp  = pn_emp
        and a.JAQZ519Amod  = pn_mod
        and a.JAQZ519Asuc  = pn_suc
        and a.JAQZ519Amda  = pn_mda
        and a.JAQZ519Apap  = pn_pap
        and a.JAQZ519Acta  = pn_cta
        and a.JAQZ519Aope  = pn_ope
        and a.JAQZ519Asbo  = pn_sbo
        and a.JAQZ519Atop  = pn_top;
        
        
        commit;
        
end Sp_backup;                   

Procedure Sp_verifica_Pago(pn_emp in number,
                       pn_mod in number,
                       pn_suc in number,
                       pn_mda in number,
                       pn_pap in number,
                       pn_cta in number,
                       pn_ope in number,
                       pn_sbo in number,
                       pn_top in number,
                       pd_fec in date,
                       lc_cambia out char)is


begin
     lc_cambia := 'N';
     begin
          select 'S'
            into lc_cambia
            from fsd602 a
           where a.pgcod  =  pn_emp
             and a.ppmod  =  pn_mod
             and a.ppsuc  =  pn_suc
             and a.ppmda  =  pn_mda
             and a.pppap  =  pn_pap
             and a.ppcta  =  pn_cta
             and a.ppoper =  pn_ope
             and a.ppsbop =  pn_sbo
             and a.pptope =  pn_top
             and a.ppfpag >= pd_fec
             and a.pptipo =  'F'
             and a.pp1stat = 'T'
             and rownum =1;
     exception
       when others then
         lc_cambia := 'N';
     end;
end;
            
Procedure Sp_calculaInteres(pn_grupo in number)is

cursor creditos is
select * from jaqz519a a where a.jaqz519agrp = pn_grupo;

cursor calendario(cn_emp in number,
                  cn_mod in number,
                  cn_suc in number,
                  cn_mda in number,
                  cn_pap in number,
                  cn_cta in number,
                  cn_ope in number,
                  cn_sbo in number,
                  cn_top in number) is
select * 
  from fsd601 a
 where a.pgcod  = cn_emp
   and a.ppmod  = cn_mod
   and a.ppsuc  = cn_suc
   and a.ppmda  = cn_mda
   and a.pppap  = cn_pap
   and a.ppcta  = cn_cta
   and a.ppoper = cn_ope
   and a.ppsbop = cn_sbo
   and a.pptope = cn_top
   and a.d601co = 'S'
   and (a.ppfvto - a.ppfval) > 35
   and (a.ppcap+a.ppint)<>0;

ln_tasa   number(10,6);
ln_tasa12 number(10,6);
ln_pzo    number(5);
ln_cap    number(17,2);
ln_formula number(17,2);
ln_mtodes number(17,2);
begin
       for i in creditos loop
           begin
             select a.aotasa,aoimp
               into ln_tasa,ln_mtodes
               from fsd010 a
              where a.pgcod  = i.jaqz519aemp
                and a.aomod  = i.jaqz519amod
                and a.aosuc  = i.jaqz519asuc
                and a.aomda  = i.jaqz519amda
                and a.aopap  = i.jaqz519apap
                and a.aocta  = i.jaqz519acta
                and a.aooper = i.jaqz519aope
                and a.aosbop = i.jaqz519asbo
                and a.aotope = i.jaqz519atop;
           exception
                when others then null;
           end;
           begin
             select a.evtasa
               into ln_tasa12
               from fsd012 a
              where a.pgcod  = i.jaqz519aemp
                and a.aomod  = i.jaqz519amod
                and a.aosuc  = i.jaqz519asuc
                and a.aomda  = i.jaqz519amda
                and a.aopap  = i.jaqz519apap
                and a.aocta  = i.jaqz519acta
                and a.aooper = i.jaqz519aope
                and a.aosbop = i.jaqz519asbo
                and a.aotope = i.jaqz519atop
                and a.evtipo = 3
                and a.d012co = 'S';
           exception
                when others then null;
           end;
           
           if ln_tasa12 is not null then
              ln_tasa := ln_tasa12;
           end if;
           
           for j in calendario(i.jaqz519aemp,
                               i.jaqz519amod,
                               i.jaqz519asuc,
                               i.jaqz519amda,
                               i.jaqz519apap,
                               i.jaqz519acta,
                               i.jaqz519aope,
                               i.jaqz519asbo,
                               i.jaqz519atop)loop
                       
               ln_pzo := j.ppfvto - j.ppfval ;                
               
               begin
                   select sum(a.ppcap)
                     into ln_cap
                     from fsd601 a
                    where a.pgcod  = i.jaqz519aemp
                      and a.ppmod  = i.jaqz519amod
                      and a.ppsuc  = i.jaqz519asuc
                      and a.ppmda  = i.jaqz519amda
                      and a.pppap  = i.jaqz519apap
                      and a.ppcta  = i.jaqz519acta
                      and a.ppoper = i.jaqz519aope
                      and a.ppsbop = i.jaqz519asbo
                      and a.pptope = i.jaqz519atop
                      and a.ppfpag < j.ppfpag
                      and a.d601co = 'S';
               exception when others then null;
               end;
               ln_cap := ln_mtodes - ln_cap;
               
               ln_formula := power((1 + ln_tasa),ln_pzo/360)*ln_cap;
               
               
               update fsd601 a
                  set a.ppint = ln_formula,
                      a.pppzo = ln_pzo,
                      a.pptipo = 'M'
                where a.pgcod  = j.pgcod 
                  and a.ppmod  = j.ppmod 
                  and a.ppsuc  = j.ppsuc 
                  and a.ppmda  = j.ppmda 
                  and a.pppap  = j.pppap 
                  and a.ppcta  = j.ppcta 
                  and a.ppoper = j.ppoper
                  and a.ppsbop = j.ppsbop
                  and a.pptope = j.pptope
                  and a.ppfpag = j.ppfpag
                  and a.d601co = 'S';
                  
                  commit;
           end loop;
           commit;
           
       end loop;
end Sp_calculaInteres;


Function Fn_NroCuotasPen(pn_emp in number,
                           pn_mod in number,
                           pn_suc in number,
                           pn_mda in number,
                           pn_pap in number,
                           pn_cta in number,
                           pn_ope in number,
                           pn_sbo in number,
                           pn_top in number,
                           pd_fecpro in date)return number is
                           
  
ln_cuotas number(5);
begin
     begin
          select /*+ parallel(n,2,1)*/
               count(*)
          into ln_cuotas
          from FSD601 n
         where n.pgcod  = pn_emp
           and n.ppcta  = pn_cta
           and n.ppmda  = pn_mda
           and n.ppsuc  = pn_suc
           and n.pppap  = pn_pap
           and n.ppoper = pn_ope
           and n.ppsbop = pn_sbo
           and n.pptope = pn_top
           and n.ppmod  = pn_mod
           and n.d601co = 'S'
           and n.ppfpag <= pd_fecpro
           and (n.ppcap+n.ppint)<>0
           and not exists
                    (select /*+ parallel(o,2,1)*/  ppmod, ppcta,ppoper, pptope,ppfpag
                       from fsd602 o
                      where o.pgcod   = n.pgcod
                        and o.ppmod   = n.ppmod
                        and o.ppsuc   = n.ppsuc
                        and o.ppmda   = n.ppmda
                        and o.pppap   = n.pppap
                        and o.ppcta   = n.ppcta
                        and o.ppoper  = n.ppoper
                        and o.ppsbop  = n.ppsbop
                        and o.pptope  = n.pptope
                        and o.ppfpag  = n.ppfpag
                        and o.pp1stat = 'T'
                        and o.d602co  = 'S'
                        and (o.pp1cap+o.pp1int)<>0);
        exception
           when others then null;
        end;
        
        return ln_cuotas;
end Fn_NroCuotasPen;



end PQ_CR_REPROCONV;
/

