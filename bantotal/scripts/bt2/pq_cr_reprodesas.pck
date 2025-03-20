create or replace package PQ_CR_REPRODESAS is

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
  Function Fn_Grupo return number;
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

end PQ_CR_REPRODESAS;
/

create or replace package body PQ_CR_REPRODESAS is

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
cursor creditos is
select * from jaqz519 a where a.jaqz519grp=pn_grupo  ;
lc_ind char(1);
--ln_grupo number(9);
begin
  --ln_grupo := pq_cr_reprodesas.Fn_Grupo;
  begin
    insert into jaqz519(jaqz519emp,
                        jaqz519mod,
                        jaqz519suc,
                        jaqz519mda,
                        jaqz519pap,
                        jaqz519cta,
                        jaqz519ope,
                        jaqz519sbo,
                        jaqz519top,
                        jaqz519pzo,
                        jaqz519est,
                        jaqz519ind,
                        jaqz519grp,
                        jaqz519rub,
                        jaqz519sdo,
                        jaqz519pdi,
                        jaqz519fep,
                        jaqz519fpp)
    
        select distinct
               a.pgcod jaqz519emp,
               aomod jaqz519mod,
               aosuc jaqz519suc,
               aomda jaqz519mda,
               aopap jaqz519pap,
               aocta jaqz519cta,
               aooper jaqz519ope,
               aosbop jaqz519sbo,
               aotope jaqz519top,
               b.jaqz519Ppzo jaqz519pzo,
               aostat jaqz519est,
               case when aostat=99 then 'C'
                    when aomod in (107,117,116) then 'M'
                    --when substr(c.scrub,1,4)in('1415','1425') then 'V'
               else 'S'
               end  jaqz519ind,
               pn_grupo,--ln_grupo jaqz519grp,
               c.scrub jaqz519rub,
               c.scsdo jaqz519sdo,
               b.jaqz519Ppzo/30 jaqz519pdi ,
               pd_fecpro,
               pq_cr_reprodesas.Fn_fechaPendiente(a.pgcod,
                                                  aomod,
                                                  aosuc,
                                                  aomda,
                                                  aopap,
                                                  aocta,
                                                  aooper, 
                                                  aosbop ,
                                                  aotope )               
               
          from fsd010 a, JAQZ519PRE b,fsd011 c
        where a.pgcod = 1
          and b.jaqz519Pcta = aocta
          and b.jaqz519Pope = aooper
          and aomod in (select modulo from fst111 where dscod = 50)
          and aostat <> 99
          and a.pgcod  = c.pgcod
          and a.aomod  = c.scmod
          and a.aosuc  = c.scsuc 
          and a.aomda  = c.scmda 
          and a.aopap  = c.scpap 
          and a.aocta  = c.sccta 
          and a.aooper = c.scoper
          and a.aosbop = c.scsbop
          and a.aotope = c.sctope
          and b.jaqz519pfec = pd_fecpro
          and b.jaqz519pgrp = pn_grupo

        ;
        commit;
  end;
  
  for i in creditos loop
      lc_ind := PQ_CR_REPRODESAS.Fn_esParcial(i.jaqz519emp,
                                              i.jaqz519mod,
                                              i.jaqz519suc,
                                              i.jaqz519mda,
                                              i.jaqz519pap,
                                              i.jaqz519cta,
                                              i.jaqz519ope,
                                              i.jaqz519sbo,
                                              i.jaqz519top,
                                              i.jaqz519ind);
         update jaqz519 a
            set a.jaqz519ind = lc_ind
          where a.jaqz519emp = i.jaqz519emp
            and a.jaqz519mod = i.jaqz519mod
            and a.jaqz519suc = i.jaqz519suc
            and a.jaqz519mda = i.jaqz519mda
            and a.jaqz519pap = i.jaqz519pap
            and a.jaqz519cta = i.jaqz519cta
            and a.jaqz519ope = i.jaqz519ope
            and a.jaqz519sbo = i.jaqz519sbo
            and a.jaqz519top = i.jaqz519top;
           
          commit;
  end loop;
   
end sp_cargaInicial;

Function Fn_Grupo return number is
ln_grupo number;
begin
  begin
      select max(a.jaqz519grp)
        into ln_grupo
        from jaqz519 a;
  exception
    when others then null;
  end;
  if ln_grupo is null then
     ln_grupo := 1;
     else
       ln_grupo := ln_grupo + 1;
  end if;
  
  return ln_grupo;
end Fn_Grupo;

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
       b.jaqz519pdi
  from fsd010 a, jaqz519 b
 where a.pgcod  = b.jaqz519emp
   and a.aomod  = b.jaqz519mod
   and a.aosuc  = b.jaqz519suc
   and a.aomda  = b.jaqz519mda
   and a.aopap  = b.jaqz519pap
   and a.aocta  = b.jaqz519cta
   and a.aooper = b.jaqz519ope
   and a.aosbop = b.jaqz519sbo
   and a.aotope = b.jaqz519top
   and a.aomod  in (select modulo from fst111 where dscod = 50)
   and b.jaqz519ind = 'S'
   and b.jaqz519grp=pn_grupo
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
        ld_fecha := add_months(ld_fecpxv,i.jaqz519pdi);  
              
        if ld_fecha between to_date('2017.03.30','yyyy.mm.dd') and to_date('2017.05.31','yyyy.mm.dd') then
           ln_numpdi := i.jaqz519pdi + 2;
           else
             ln_numpdi := i.jaqz519pdi;
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
                           a.pptipo = 'F'
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
                                       a.pptipo = 'F'
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
          update jaqz519 A
           set a.JAQZ519PRO601 = 'S'
         where a.jaqz519emp =  i.pgcod 
           and a.jaqz519mod =  i.aomod
           and a.jaqz519suc =  i.aosuc
           and a.jaqz519mda =  i.aomda
           and a.jaqz519pap =  i.aopap
           and a.jaqz519cta =  i.aocta
           and a.jaqz519ope =  i.aooper
           and a.jaqz519sbo =  i.aosbop
           and a.jaqz519top =  i.aotope
           and a.jaqz519grp = pn_grupo;
         
        
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
       b.jaqz519pdi
  from fsd010 a, jaqz519 b
 where a.pgcod  = b.jaqz519emp
   and a.aomod  = b.jaqz519mod
   and a.aosuc  = b.jaqz519suc
   and a.aomda  = b.jaqz519mda
   and a.aopap  = b.jaqz519pap
   and a.aocta  = b.jaqz519cta
   and a.aooper = b.jaqz519ope
   and a.aosbop = b.jaqz519sbo
   and a.aotope = b.jaqz519top
   and a.aomod  in (select modulo from fst111 where dscod = 50)
   and b.jaqz519ind = 'S'
   and b.jaqz519grp=pn_grupo
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
        ld_fecha := add_months(ld_fecpxv,i.jaqz519pdi);  
              
        if ld_fecha between to_date('2017.03.30','yyyy.mm.dd') and to_date('2017.05.31','yyyy.mm.dd') then
           ln_numpdi := i.jaqz519pdi + 2;
           else
             ln_numpdi := i.jaqz519pdi;
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
                           a.pptipo='F'
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
                                       a.pptipo='F'
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
        
       update jaqz519 A
           set a.JAQZ519PRO611 = 'S'
         where a.jaqz519emp =  i.pgcod 
           and a.jaqz519mod =  i.aomod
           and a.jaqz519suc =  i.aosuc
           and a.jaqz519mda =  i.aomda
           and a.jaqz519pap =  i.aopap
           and a.jaqz519cta =  i.aocta
           and a.jaqz519ope =  i.aooper
           and a.jaqz519sbo =  i.aosbop
           and a.jaqz519top =  i.aotope
           and a.jaqz519grp = pn_grupo;

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
       b.jaqz519pzo,
       a.aofval
  from fsd010 a, jaqz519 b
 where a.pgcod  = b.jaqz519emp 
   and a.aomod  = b.jaqz519mod 
   and a.aosuc  = b.jaqz519suc 
   and a.aomda  = b.jaqz519mda 
   and a.aopap  = b.jaqz519pap 
   and a.aocta  = b.jaqz519cta 
   and a.aooper = b.jaqz519ope
   and a.aosbop = b.jaqz519sbo
   and a.aotope = b.jaqz519top
   and a.aomod  in (select modulo from fst111 where dscod = 50)
   and b.jaqz519ind = 'S'
   and b.jaqz519grp=pn_grupo;
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
      
      update jaqz519 A
           set a.JAQZ519PRO10 = 'S'
         where a.jaqz519emp =  i.pgcod 
           and a.jaqz519mod =  i.aomod
           and a.jaqz519suc =  i.aosuc
           and a.jaqz519mda =  i.aomda
           and a.jaqz519pap =  i.aopap
           and a.jaqz519cta =  i.aocta
           and a.jaqz519ope =  i.aooper
           and a.jaqz519sbo =  i.aosbop
           and a.jaqz519top =  i.aotope
           and a.jaqz519grp = pn_grupo;
         
        --COMMIT;
        
        
  end loop;
 -- commit;
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
       b.jaqz519pzo,
       a.scfval --mod@abr 20170405
  from fsd011 a,jaqz519 b
 where a.pgcod  = b.jaqz519emp 
   and a.scsuc  = b.jaqz519suc 
   and a.scmda  = b.jaqz519mda  
   and a.scpap  = b.jaqz519pap 
   and a.sccta  = b.jaqz519cta  
   and a.scoper = b.jaqz519ope  
   and a.scsbop = b.jaqz519sbo 
   and a.sctope = b.jaqz519top 
   and a.scmod  = b.jaqz519mod
   and a.scfvto is not null
   and b.jaqz519ind = 'S'
   and b.jaqz519grp=pn_grupo;
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
              
              --commit;  
              
        update jaqz519 A
           set a.JAQZ519PRO11 = 'S'
         where a.jaqz519emp =  i.pgcod 
           and a.jaqz519mod =  i.scmod
           and a.jaqz519suc =  i.scsuc
           and a.jaqz519mda =  i.scmda
           and a.jaqz519pap =  i.scpap
           and a.jaqz519cta =  i.sccta
           and a.jaqz519ope =  i.scoper
           and a.jaqz519sbo =  i.scsbop
           and a.jaqz519top =  i.sctope
           and a.jaqz519grp = pn_grupo;
         
        --COMMIT;
              
                     
   end loop;
   --commit;
end Sp_Actualiza_FSD011;

Procedure Sp_extorno_grupo(pn_grupo in number) is
cursor creditos is
select * 
  from jaqz519 b
 where b.jaqz519ind = 'S'
   and b.jaqz519grp = pn_grupo;  
   
ld_fvto11 date;  
ln_pzo11  number(5);
ld_fvto10 date;  
ln_pzo10  number(5);

begin
    for i in creditos loop
        delete from fsd601 a
         where a.pgcod  = i.jaqz519emp
           and a.ppmod  = i.jaqz519mod
           and a.ppsuc  = i.jaqz519suc
           and a.ppmda  = i.jaqz519mda
           and a.pppap  = i.jaqz519pap
           and a.ppcta  = i.jaqz519cta
           and a.ppoper = i.jaqz519ope
           and a.ppsbop = i.jaqz519sbo
           and a.pptope = i.jaqz519top;
    
        insert into fsd601 a
        select * from jaqz520_601 a--jaqz520_601 a
         where a.pgcod  = i.jaqz519emp
           and a.ppmod  = i.jaqz519mod
           and a.ppsuc  = i.jaqz519suc
           and a.ppmda  = i.jaqz519mda
           and a.pppap  = i.jaqz519pap
           and a.ppcta  = i.jaqz519cta
           and a.ppoper = i.jaqz519ope
           and a.ppsbop = i.jaqz519sbo
           and a.pptope = i.jaqz519top;
           
        delete from fsd611 a
         where a.pgcod  = i.jaqz519emp
           and a.ppmod  = i.jaqz519mod
           and a.ppsuc  = i.jaqz519suc
           and a.ppmda  = i.jaqz519mda
           and a.pppap  = i.jaqz519pap
           and a.ppcta  = i.jaqz519cta
           and a.ppoper = i.jaqz519ope
           and a.ppsbop = i.jaqz519sbo
           and a.pptope = i.jaqz519top;
    
        insert into fsd611 a
        select * from jaqz520_611 a--jaqz520_611 a
         where a.pgcod  = i.jaqz519emp
           and a.ppmod  = i.jaqz519mod
           and a.ppsuc  = i.jaqz519suc
           and a.ppmda  = i.jaqz519mda
           and a.pppap  = i.jaqz519pap
           and a.ppcta  = i.jaqz519cta
           and a.ppoper = i.jaqz519ope
           and a.ppsbop = i.jaqz519sbo
           and a.pptope = i.jaqz519top;
           
        
        select aofvto,
               aopzo
          into ld_fvto10,
               ln_pzo10
          from jaqz520_010 a--jaqz520_010 a
         where a.pgcod  = i.jaqz519emp
           and a.aomod  = i.jaqz519mod
           and a.aosuc  = i.jaqz519suc
           and a.aomda  = i.jaqz519mda
           and a.aopap  = i.jaqz519pap
           and a.aocta  = i.jaqz519cta
           and a.aooper = i.jaqz519ope
           and a.aosbop = i.jaqz519sbo
           and a.aotope = i.jaqz519top;
        
        
        update fsd010 a
           set a.aofvto = ld_fvto10,
               a.aopzo  = ln_pzo10
         where a.pgcod  = i.jaqz519emp
           and a.aomod  = i.jaqz519mod
           and a.aosuc  = i.jaqz519suc
           and a.aomda  = i.jaqz519mda
           and a.aopap  = i.jaqz519pap
           and a.aocta  = i.jaqz519cta
           and a.aooper = i.jaqz519ope
           and a.aosbop = i.jaqz519sbo
           and a.aotope = i.jaqz519top;
    
        select a.scfvto,
               a.scpzo
          into ld_fvto11,
               ln_pzo11
          from jaqz520_011 a--jaqz520_011 a
         where a.pgcod  = i.jaqz519emp
           and a.scmod  = i.jaqz519mod
           and a.scsuc  = i.jaqz519suc
           and a.scmda  = i.jaqz519mda
           and a.scpap  = i.jaqz519pap
           and a.sccta  = i.jaqz519cta
           and a.scoper = i.jaqz519ope
           and a.scsbop = i.jaqz519sbo
           and a.sctope = i.jaqz519top;

        update fsd011 a
           set a.scfvto = ld_fvto11,
               a.scpzo  = ln_pzo11
         where a.pgcod  = i.jaqz519emp
           and a.scmod  = i.jaqz519mod
           and a.scsuc  = i.jaqz519suc
           and a.scmda  = i.jaqz519mda
           and a.scpap  = i.jaqz519pap
           and a.sccta  = i.jaqz519cta
           and a.scoper = i.jaqz519ope
           and a.scsbop = i.jaqz519sbo
           and a.sctope = i.jaqz519top;
    
      
    
    end loop;
    
    delete from jaqz519 b
     where /*b.jaqz519ind = 'S'
       and */b.jaqz519grp = pn_grupo;  
          
end Sp_extorno_grupo;

Procedure Sp_extorno_cuenta(pn_cta in number,
                            pn_ope in number,
                            pc_usr in char,
                            pd_fec in date,
                            pn_ind out number) is
                            
                            
cursor creditos is
select * 
  from jaqz519 b
 where b.jaqz519ind in('S','P')
   and b.jaqz519cta = pn_cta
   and b.jaqz519ope = pn_ope
   and b.jaqz519pro10  = 'S'
   and b.jaqz519pro11  = 'S'
   and b.jaqz519pro601 = 'S'
   and b.jaqz519pro611 = 'S'
   and b.jaqz519revr   is null
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
  from jaqz520_601 a
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

select * from jaqz522 a
where a.jaqz522emp = pn_emp              
  and a.jaqz522mod = pn_mod
  and a.jaqz522suc = pn_suc
  and a.jaqz522mda = pn_mda
  and a.jaqz522pap = pn_pap
  and a.jaqz522cta = pn_cta
  and a.jaqz522ope = pn_ope
  and a.jaqz522sbo = pn_sbo
  and a.jaqz522top = pn_top;
  
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
            from jaqz519 b
           where b.jaqz519ind in('S','P')
             and b.jaqz519cta = pn_cta
             and b.jaqz519ope = pn_ope
             and b.jaqz519pro10  = 'S'
             and b.jaqz519pro11  = 'S'
             and b.jaqz519pro601 = 'S'
             and b.jaqz519pro611 = 'S'
             and b.jaqz519revr   is null; 
    exception
      when others then 
           pn_ind := 0;
    end;
    
    for i in creditos loop
      
    pq_cr_reprodesas.Sp_verifica602(i.jaqz519emp,
                                    i.jaqz519mod,
                                    i.jaqz519suc,
                                    i.jaqz519mda,
                                    i.jaqz519pap,
                                    i.jaqz519cta,
                                    i.jaqz519ope,
                                    i.jaqz519sbo,
                                    i.jaqz519top,
                                    i.jaqz519fpp,
                                    lc_Spago);
                                    
    pq_cr_reprodesas.Sp_backup(i.jaqz519emp,
                                    i.jaqz519mod,
                                    i.jaqz519suc,
                                    i.jaqz519mda,
                                    i.jaqz519pap,
                                    i.jaqz519cta,
                                    i.jaqz519ope,
                                    i.jaqz519sbo,
                                    i.jaqz519top);
    
    if lc_Spago = 'S' then 
        
                 
        begin
          select count(*)
            into ln_con1
            from fsd601 a
           where a.pgcod  = i.jaqz519emp
             and a.ppmod  = i.jaqz519mod
             and a.ppsuc  = i.jaqz519suc
             and a.ppmda  = i.jaqz519mda
             and a.pppap  = i.jaqz519pap
             and a.ppcta  = i.jaqz519cta
             and a.ppoper = i.jaqz519ope
             and a.ppsbop = i.jaqz519sbo
             and a.pptope = i.jaqz519top 
             and a.d601co = 'S';
        exception
          when others then null;
        end;
        
        begin
          select count(*)
            into ln_con2
            from jaqz520_601 a
           where a.pgcod  = i.jaqz519emp
             and a.ppmod  = i.jaqz519mod
             and a.ppsuc  = i.jaqz519suc
             and a.ppmda  = i.jaqz519mda
             and a.pppap  = i.jaqz519pap
             and a.ppcta  = i.jaqz519cta
             and a.ppoper = i.jaqz519ope
             and a.ppsbop = i.jaqz519sbo
             and a.pptope = i.jaqz519top 
             and a.d601co = 'S';
        exception
          when others then null;
        end;
        
        ln_contador1 := 0;
        ln_contador2 := 0;
        ld_fecAnt    := null;
        
        if ln_con1 = ln_con2 then
              
              
                                    
              for j in calendario_1(i.jaqz519emp,
                                    i.jaqz519mod,
                                    i.jaqz519suc,
                                    i.jaqz519mda,
                                    i.jaqz519pap,
                                    i.jaqz519cta,
                                    i.jaqz519ope,
                                    i.jaqz519sbo,
                                    i.jaqz519top) loop
                  
                  ln_contador1 := ln_contador1 + 1;
                  insert into jaqz522(jaqz522cod,
                                      jaqz522emp,
                                      jaqz522mod,
                                      jaqz522suc,
                                      jaqz522mda,
                                      jaqz522pap,
                                      jaqz522cta,
                                      jaqz522ope,
                                      jaqz522sbo,
                                      jaqz522top,
                                      jaqz522fac,
                                      jaqz522usr,
                                      jaqz522fep)
                  values(ln_contador1,
                         i.jaqz519emp,
                         i.jaqz519mod,
                         i.jaqz519suc,
                         i.jaqz519mda,
                         i.jaqz519pap,
                         i.jaqz519cta,
                         i.jaqz519ope,
                         i.jaqz519sbo,
                         i.jaqz519top,
                         j.ppfpag,
                         pc_usr,
                         pd_fec
                         );
                         
                         commit;
              end loop;
              
              for k in calendario_2(i.jaqz519emp,
                                    i.jaqz519mod,
                                    i.jaqz519suc,
                                    i.jaqz519mda,
                                    i.jaqz519pap,
                                    i.jaqz519cta,
                                    i.jaqz519ope,
                                    i.jaqz519sbo,
                                    i.jaqz519top) loop
                  
                  ln_contador2 := ln_contador2 + 1;
                  insert into jaqz522_aux(jaqz522cod,
                                          jaqz522emp,
                                          jaqz522mod,
                                          jaqz522suc,
                                          jaqz522mda,
                                          jaqz522pap,
                                          jaqz522cta,
                                          jaqz522ope,
                                          jaqz522sbo,
                                          jaqz522top,
                                          jaqz522fan)
                  values(ln_contador2,
                         i.jaqz519emp,
                         i.jaqz519mod,
                         i.jaqz519suc,
                         i.jaqz519mda,
                         i.jaqz519pap,
                         i.jaqz519cta,
                         i.jaqz519ope,
                         i.jaqz519sbo,
                         i.jaqz519top,
                         k.ppfpag
                         );
                         
                         commit;
              end loop;
              
              commit;
              
              
              for m in jaqz522(i.jaqz519emp,
                               i.jaqz519mod,
                               i.jaqz519suc,
                               i.jaqz519mda,
                               i.jaqz519pap,
                               i.jaqz519cta,
                               i.jaqz519ope,
                               i.jaqz519sbo,
                               i.jaqz519top) loop
                  begin
                    select a.jaqz522fan
                      into ld_fecAnt
                      from jaqz522_aux a 
                     where a.jaqz522cod = m.jaqz522cod
                       and a.jaqz522emp = m.jaqz522emp
                       and a.jaqz522mod = m.jaqz522mod
                       and a.jaqz522suc = m.jaqz522suc
                       and a.jaqz522mda = m.jaqz522mda
                       and a.jaqz522pap = m.jaqz522pap
                       and a.jaqz522cta = m.jaqz522cta
                       and a.jaqz522ope = m.jaqz522ope
                       and a.jaqz522sbo = m.jaqz522sbo
                       and a.jaqz522top = m.jaqz522top;
                  exception
                    when others then null;
                  end;
                  
                  update jaqz522 a
                     set a.jaqz522fan = ld_fecAnt
                   where a.jaqz522cod = m.jaqz522cod
                     and a.jaqz522emp = m.jaqz522emp
                     and a.jaqz522mod = m.jaqz522mod
                     and a.jaqz522suc = m.jaqz522suc
                     and a.jaqz522mda = m.jaqz522mda
                     and a.jaqz522pap = m.jaqz522pap
                     and a.jaqz522cta = m.jaqz522cta
                     and a.jaqz522ope = m.jaqz522ope
                     and a.jaqz522sbo = m.jaqz522sbo
                     and a.jaqz522top = m.jaqz522top;
                     
                     commit;
              end loop;
              commit;
              
              pq_cr_reprodesas.Sp_Revierte602_612(i.jaqz519emp,
                                                  i.jaqz519mod,
                                                  i.jaqz519suc,
                                                  i.jaqz519mda,
                                                  i.jaqz519pap,
                                                  i.jaqz519cta,
                                                  i.jaqz519ope,
                                                  i.jaqz519sbo,
                                                  i.jaqz519top,
                                                  pc_usr,
                                                  pd_fec
                                                  );
               --Actualiza si ya pago
               update jaqz519 a
                  set a.jaqz519spag = 'S'
                where a.jaqz519emp = i.jaqz519emp
                 and a.jaqz519mod = i.jaqz519mod
                 and a.jaqz519suc = i.jaqz519suc
                 and a.jaqz519mda = i.jaqz519mda
                 and a.jaqz519pap = i.jaqz519pap
                 and a.jaqz519cta = i.jaqz519cta
                 and a.jaqz519ope = i.jaqz519ope
                 and a.jaqz519sbo = i.jaqz519sbo
                 and a.jaqz519top = i.jaqz519top;
            commit;
           
          end if;    
     end if;
     
        delete from fsd601 a
         where a.pgcod  = i.jaqz519emp
           and a.ppmod  = i.jaqz519mod
           and a.ppsuc  = i.jaqz519suc
           and a.ppmda  = i.jaqz519mda
           and a.pppap  = i.jaqz519pap
           and a.ppcta  = i.jaqz519cta
           and a.ppoper = i.jaqz519ope
           and a.ppsbop = i.jaqz519sbo
           and a.pptope = i.jaqz519top;
    
        insert into fsd601 a
        select * from jaqz520_601 a
         where a.pgcod  = i.jaqz519emp
           and a.ppmod  = i.jaqz519mod
           and a.ppsuc  = i.jaqz519suc
           and a.ppmda  = i.jaqz519mda
           and a.pppap  = i.jaqz519pap
           and a.ppcta  = i.jaqz519cta
           and a.ppoper = i.jaqz519ope
           and a.ppsbop = i.jaqz519sbo
           and a.pptope = i.jaqz519top;
        --Actualiza si se revertio FSD601
        UPDATE jaqz519 a
           set a.jaqz519r601 = 'S'
         where a.jaqz519emp = i.jaqz519emp
           and a.jaqz519mod = i.jaqz519mod
           and a.jaqz519suc = i.jaqz519suc
           and a.jaqz519mda = i.jaqz519mda
           and a.jaqz519pap = i.jaqz519pap
           and a.jaqz519cta = i.jaqz519cta
           and a.jaqz519ope = i.jaqz519ope
           and a.jaqz519sbo = i.jaqz519sbo
           and a.jaqz519top = i.jaqz519top;
         
        delete from fsd611 a
         where a.pgcod  = i.jaqz519emp
           and a.ppmod  = i.jaqz519mod
           and a.ppsuc  = i.jaqz519suc
           and a.ppmda  = i.jaqz519mda
           and a.pppap  = i.jaqz519pap
           and a.ppcta  = i.jaqz519cta
           and a.ppoper = i.jaqz519ope
           and a.ppsbop = i.jaqz519sbo
           and a.pptope = i.jaqz519top;
    
        insert into fsd611 a
        select * from jaqz520_611 a
         where a.pgcod  = i.jaqz519emp
           and a.ppmod  = i.jaqz519mod
           and a.ppsuc  = i.jaqz519suc
           and a.ppmda  = i.jaqz519mda
           and a.pppap  = i.jaqz519pap
           and a.ppcta  = i.jaqz519cta
           and a.ppoper = i.jaqz519ope
           and a.ppsbop = i.jaqz519sbo
           and a.pptope = i.jaqz519top;
           
        --Actualiza si se revertio FSD611
        UPDATE jaqz519 a
           set a.jaqz519r611 = 'S'
         where a.jaqz519emp = i.jaqz519emp
           and a.jaqz519mod = i.jaqz519mod
           and a.jaqz519suc = i.jaqz519suc
           and a.jaqz519mda = i.jaqz519mda
           and a.jaqz519pap = i.jaqz519pap
           and a.jaqz519cta = i.jaqz519cta
           and a.jaqz519ope = i.jaqz519ope
           and a.jaqz519sbo = i.jaqz519sbo
           and a.jaqz519top = i.jaqz519top;
           
        select aofvto,
               aopzo
          into ld_fvto10,
               ln_pzo10
          from jaqz520_010 a
         where a.pgcod  = i.jaqz519emp
           and a.aomod  = i.jaqz519mod
           and a.aosuc  = i.jaqz519suc
           and a.aomda  = i.jaqz519mda
           and a.aopap  = i.jaqz519pap
           and a.aocta  = i.jaqz519cta
           and a.aooper = i.jaqz519ope
           and a.aosbop = i.jaqz519sbo
           and a.aotope = i.jaqz519top;
        
        
        update fsd010 a
           set a.aofvto = ld_fvto10,
               a.aopzo  = ln_pzo10
         where a.pgcod  = i.jaqz519emp
           and a.aomod  = i.jaqz519mod
           and a.aosuc  = i.jaqz519suc
           and a.aomda  = i.jaqz519mda
           and a.aopap  = i.jaqz519pap
           and a.aocta  = i.jaqz519cta
           and a.aooper = i.jaqz519ope
           and a.aosbop = i.jaqz519sbo
           and a.aotope = i.jaqz519top;
    
        --Actualiza si se revertio FSD010
        UPDATE jaqz519 a
           set a.jaqz519r010 = 'S'
         where a.jaqz519emp = i.jaqz519emp
           and a.jaqz519mod = i.jaqz519mod
           and a.jaqz519suc = i.jaqz519suc
           and a.jaqz519mda = i.jaqz519mda
           and a.jaqz519pap = i.jaqz519pap
           and a.jaqz519cta = i.jaqz519cta
           and a.jaqz519ope = i.jaqz519ope
           and a.jaqz519sbo = i.jaqz519sbo
           and a.jaqz519top = i.jaqz519top;
           
        select a.scfvto,
               a.scpzo
          into ld_fvto11,
               ln_pzo11
          from jaqz520_011 a
         where a.pgcod  = i.jaqz519emp
           and a.scmod  = i.jaqz519mod
           and a.scsuc  = i.jaqz519suc
           and a.scmda  = i.jaqz519mda
           and a.scpap  = i.jaqz519pap
           and a.sccta  = i.jaqz519cta
           and a.scoper = i.jaqz519ope
           and a.scsbop = i.jaqz519sbo
           and a.sctope = i.jaqz519top;

        update fsd011 a
           set a.scfvto = ld_fvto11,
               a.scpzo  = ln_pzo11
         where a.pgcod  = i.jaqz519emp
           and a.scmod  = i.jaqz519mod
           and a.scsuc  = i.jaqz519suc
           and a.scmda  = i.jaqz519mda
           and a.scpap  = i.jaqz519pap
           and a.sccta  = i.jaqz519cta
           and a.scoper = i.jaqz519ope
           and a.scsbop = i.jaqz519sbo
           and a.sctope = i.jaqz519top;
    
      --Actualiza si se revertio FSD011
        UPDATE jaqz519 a
           set a.jaqz519r011 = 'S'
         where a.jaqz519emp = i.jaqz519emp
           and a.jaqz519mod = i.jaqz519mod
           and a.jaqz519suc = i.jaqz519suc
           and a.jaqz519mda = i.jaqz519mda
           and a.jaqz519pap = i.jaqz519pap
           and a.jaqz519cta = i.jaqz519cta
           and a.jaqz519ope = i.jaqz519ope
           and a.jaqz519sbo = i.jaqz519sbo
           and a.jaqz519top = i.jaqz519top;
           
     --Actualiza estado, fecha y usario que hizo la reversion
         update jaqz519 a
            set a.jaqz519revr = 'S',
                a.jaqz519feca = pd_fec,
                a.jaqz519usrr = pc_usr
          where a.jaqz519emp = i.jaqz519emp
           and a.jaqz519mod  = i.jaqz519mod
           and a.jaqz519suc  = i.jaqz519suc
           and a.jaqz519mda  = i.jaqz519mda
           and a.jaqz519pap  = i.jaqz519pap
           and a.jaqz519cta  = i.jaqz519cta
           and a.jaqz519ope  = i.jaqz519ope
           and a.jaqz519sbo  = i.jaqz519sbo
           and a.jaqz519top  = i.jaqz519top;
           
                      
          update jaqz856 a
            set a.jaqz856rev = 'S'
          where a.jaqz856emp = i.jaqz519emp
            and a.jaqz856mod = i.jaqz519mod
            and a.jaqz856suc = i.jaqz519suc
            and a.jaqz856mda = i.jaqz519mda
            and a.jaqz856pap = i.jaqz519pap
            and a.jaqz856cta = i.jaqz519cta
            and a.jaqz856ope = i.jaqz519ope
            and a.jaqz856sbo = i.jaqz519sbo
            and a.jaqz856top = i.jaqz519top;
            
            update jaqz857 a
              set a.jaqz857rev = 'S'
             where a.jaqz857emp = i.jaqz519emp
               and a.jaqz857mod = i.jaqz519mod
               and a.jaqz857suc = i.jaqz519suc
               and a.jaqz857mda = i.jaqz519mda
               and a.jaqz857pap = i.jaqz519pap
               and a.jaqz857cta = i.jaqz519cta
               and a.jaqz857ope = i.jaqz519ope
               and a.jaqz857sbo = i.jaqz519sbo
               and a.jaqz857top = i.jaqz519top;
           commit; 
    end loop;
    
 commit;
          
end Sp_extorno_cuenta;

Procedure Sp_parciales(pn_grupo in number)is
cursor Creditos is
select * from jaqz519 a 
where a.jaqz519ind = 'P'
  and a.jaqz519grp = pn_grupo;

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
          pq_cr_reprodesas.Sp_detallePago(i.jaqz519emp,
                                        i.jaqz519mod,
                                        i.jaqz519suc,
                                        i.jaqz519mda,
                                        i.jaqz519pap,
                                        i.jaqz519cta,
                                        i.jaqz519ope,
                                        i.jaqz519sbo,
                                        i.jaqz519top,
                                        i.jaqz519fpp,
                                        ln_cap,
                                        ln_int,
                                        ln_mor,
                                        ln_seg
                                        );
          
           update jaqz519 a
              set a.jaqz519cap = ln_cap,
                  a.jaqz519int = ln_int,
                  a.jaqz519mor = ln_mor,
                  a.jaqz519seg = ln_seg
            where a.jaqz519emp = i.jaqz519emp
              and a.jaqz519mod = i.jaqz519mod
              and a.jaqz519suc = i.jaqz519suc
              and a.jaqz519mda = i.jaqz519mda
              and a.jaqz519pap = i.jaqz519pap
              and a.jaqz519cta = i.jaqz519cta
              and a.jaqz519ope = i.jaqz519ope
              and a.jaqz519sbo = i.jaqz519sbo
              and a.jaqz519top = i.jaqz519top
              and a.jaqz519grp = pn_grupo;
                  
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
       b.jaqz519pdi
  from fsd010 a, jaqz519 b
 where a.pgcod  = b.jaqz519emp
   and a.aomod  = b.jaqz519mod
   and a.aosuc  = b.jaqz519suc
   and a.aomda  = b.jaqz519mda
   and a.aopap  = b.jaqz519pap
   and a.aocta  = b.jaqz519cta
   and a.aooper = b.jaqz519ope
   and a.aosbop = b.jaqz519sbo
   and a.aotope = b.jaqz519top
   and a.aomod  in (select modulo from fst111 where dscod = 50)
   and b.jaqz519ind = 'P'
   and b.jaqz519grp=pn_grupo
   and b.jaqz519mor = 0
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
        ld_fecha := add_months(ld_fecpxv,i.jaqz519pdi);  
              
        if ld_fecha between to_date('2017.03.30','yyyy.mm.dd') and to_date('2017.05.31','yyyy.mm.dd') then
           ln_numpdi := i.jaqz519pdi + 2;
           else
             ln_numpdi := i.jaqz519pdi;
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
                           a.pptipo='F'
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
                                       a.pptipo='F'
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
        
       update jaqz519 A
           set a.JAQZ519PRO611 = 'S'
         where a.jaqz519emp =  i.pgcod 
           and a.jaqz519mod =  i.aomod
           and a.jaqz519suc =  i.aosuc
           and a.jaqz519mda =  i.aomda
           and a.jaqz519pap =  i.aopap
           and a.jaqz519cta =  i.aocta
           and a.jaqz519ope =  i.aooper
           and a.jaqz519sbo =  i.aosbop
           and a.jaqz519top =  i.aotope
           and a.jaqz519grp = pn_grupo;

   END LOOP; 
END Sp_ActParc_FSD611; 

Procedure Sp_ActParc_FSD601_602_612(pn_grupo in number)is
cursor creditos is

select a.jaqz519emp pgcod, 
       a.jaqz519mod aomod,
       a.jaqz519suc aosuc,
       a.jaqz519mda aomda,
       a.jaqz519pap aopap,
       a.jaqz519cta aocta,
       a.jaqz519ope aooper,
       a.jaqz519sbo aosbop,
       a.jaqz519top aotope,
       a.jaqz519pdi 
  from jaqz519 a
 where a.jaqz519ind = 'P'
   and a.jaqz519grp = pn_grupo
   and a.jaqz519mor = 0;  

   
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
        ld_fecha := add_months(ld_fecpxv,i.jaqz519pdi);  
              
        if ld_fecha between to_date('2017.03.30','yyyy.mm.dd') and to_date('2017.05.31','yyyy.mm.dd') then
           ln_numpdi := i.jaqz519pdi + 2;
           else
             ln_numpdi := i.jaqz519pdi;
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
                           a.pptipo = 'F'
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
                                       a.pptipo = 'F'
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
        ld_fecpago :=  add_months(ld_fecpxv,i.jaqz519pdi);  
       
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
                      a.pptipo = 'F'
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
                      a.pptipo = 'F'
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
        
           update jaqz519 A
           set a.JAQZ519PRO602 = 'S'
         where a.jaqz519emp =  i.pgcod 
           and a.jaqz519mod =  i.aomod
           and a.jaqz519suc =  i.aosuc
           and a.jaqz519mda =  i.aomda
           and a.jaqz519pap =  i.aopap
           and a.jaqz519cta =  i.aocta
           and a.jaqz519ope =  i.aooper
           and a.jaqz519sbo =  i.aosbop
           and a.jaqz519top =  i.aotope
           and a.jaqz519grp = pn_grupo;
        
          update jaqz519 A
           set a.JAQZ519PRO601 = 'S'
         where a.jaqz519emp =  i.pgcod 
           and a.jaqz519mod =  i.aomod
           and a.jaqz519suc =  i.aosuc
           and a.jaqz519mda =  i.aomda
           and a.jaqz519pap =  i.aopap
           and a.jaqz519cta =  i.aocta
           and a.jaqz519ope =  i.aooper
           and a.jaqz519sbo =  i.aosbop
           and a.jaqz519top =  i.aotope
           and a.jaqz519grp = pn_grupo;
           
            update jaqz519 A
           set a.JAQZ519PRO612 = 'S'
         where a.jaqz519emp =  i.pgcod 
           and a.jaqz519mod =  i.aomod
           and a.jaqz519suc =  i.aosuc
           and a.jaqz519mda =  i.aomda
           and a.jaqz519pap =  i.aopap
           and a.jaqz519cta =  i.aocta
           and a.jaqz519ope =  i.aooper
           and a.jaqz519sbo =  i.aosbop
           and a.jaqz519top =  i.aotope
           and a.jaqz519grp = pn_grupo;
         
        
   END LOOP; 
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
       b.jaqz519pzo,
       a.aofval
  from fsd010 a, jaqz519 b
 where a.pgcod  = b.jaqz519emp 
   and a.aomod  = b.jaqz519mod 
   and a.aosuc  = b.jaqz519suc 
   and a.aomda  = b.jaqz519mda 
   and a.aopap  = b.jaqz519pap 
   and a.aocta  = b.jaqz519cta 
   and a.aooper = b.jaqz519ope
   and a.aosbop = b.jaqz519sbo
   and a.aotope = b.jaqz519top
   and a.aomod  in (select modulo from fst111 where dscod = 50)
   and b.jaqz519ind = 'P'
   and b.jaqz519grp=pn_grupo
   and b.jaqz519mor = 0;
   
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
      
      update jaqz519 A
           set a.JAQZ519PRO10 = 'S'
         where a.jaqz519emp =  i.pgcod 
           and a.jaqz519mod =  i.aomod
           and a.jaqz519suc =  i.aosuc
           and a.jaqz519mda =  i.aomda
           and a.jaqz519pap =  i.aopap
           and a.jaqz519cta =  i.aocta
           and a.jaqz519ope =  i.aooper
           and a.jaqz519sbo =  i.aosbop
           and a.jaqz519top =  i.aotope
           and a.jaqz519grp = pn_grupo;
         
        --COMMIT;
        
        
  end loop;
 -- commit;
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
       b.jaqz519pzo,
       a.scfval 
  from fsd011 a,jaqz519 b
 where a.pgcod  = b.jaqz519emp 
   and a.scsuc  = b.jaqz519suc 
   and a.scmda  = b.jaqz519mda  
   and a.scpap  = b.jaqz519pap 
   and a.sccta  = b.jaqz519cta  
   and a.scoper = b.jaqz519ope  
   and a.scsbop = b.jaqz519sbo 
   and a.sctope = b.jaqz519top 
   and a.scmod  = b.jaqz519mod
   and a.scfvto is not null
   and b.jaqz519ind = 'P'
   and b.jaqz519grp=pn_grupo
   and b.jaqz519mor = 0;
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
              
              --commit;  
              
        update jaqz519 A
           set a.JAQZ519PRO11 = 'S'
         where a.jaqz519emp =  i.pgcod 
           and a.jaqz519mod =  i.scmod
           and a.jaqz519suc =  i.scsuc
           and a.jaqz519mda =  i.scmda
           and a.jaqz519pap =  i.scpap
           and a.jaqz519cta =  i.sccta
           and a.jaqz519ope =  i.scoper
           and a.jaqz519sbo =  i.scsbop
           and a.jaqz519top =  i.sctope
           and a.jaqz519grp = pn_grupo;
         
        --COMMIT;
              
                     
   end loop;
   --commit;
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

/*Procedure Sp_regularizacion is
cursor creditos is
select * from jaqz519 a where a.jaqz519grp=5
and a.jaqz519cta in(1729528,2011441,285768,1127642,1600416,1729528,1934784,1715939,1784653,1609410,1824871,2050702,1974071,
2043863,1634017,2023369,1357526,158634,313553,185075,940494,1943910,1853261,159629,1897994,1381272,1831810,1916768)
and a.jaqz519ope in(2952091,2922885,2755579,2172351,2911340,3131572,3448104,2766787,3141697,2578103,2798482,3091797,2938177,
3072862,2661473,2976016,1910174,3248150,3193692,3207589,2299973,2622954,2793518,2517050,3144326,1447719,2677301,3022881);

begin
     for i in creditos loop
         delete from fsd601 a
          where a.pgcod  = i.jaqz519emp
            and a.ppmod  = i.jaqz519mod
            and a.ppsuc  = i.jaqz519suc
            and a.ppmda  = i.jaqz519mda
            and a.pppap  = i.jaqz519pap
            and a.ppcta  = i.jaqz519cta
            and a.ppoper = i.jaqz519ope
            and a.ppsbop = i.jaqz519sbo
            and a.pptope = i.jaqz519top;
          
          insert into fsd601 
          select * from \*operador.fsd601_06042017_2 a*\ JAQZ521_601 a
          where a.pgcod  = i.jaqz519emp
            and a.ppmod  = i.jaqz519mod
            and a.ppsuc  = i.jaqz519suc
            and a.ppmda  = i.jaqz519mda
            and a.pppap  = i.jaqz519pap
            and a.ppcta  = i.jaqz519cta
            and a.ppoper = i.jaqz519ope
            and a.ppsbop = i.jaqz519sbo
            and a.pptope = i.jaqz519top;
            
         delete from fsd611 a
          where a.pgcod  = i.jaqz519emp
            and a.ppmod  = i.jaqz519mod
            and a.ppsuc  = i.jaqz519suc
            and a.ppmda  = i.jaqz519mda
            and a.pppap  = i.jaqz519pap
            and a.ppcta  = i.jaqz519cta
            and a.ppoper = i.jaqz519ope
            and a.ppsbop = i.jaqz519sbo
            and a.pptope = i.jaqz519top;
          
          insert into fsd611 
          select * from \*operador.fsd611_06042017_2 a *\JAQZ521_611 a
          where a.pgcod  = i.jaqz519emp
            and a.ppmod  = i.jaqz519mod
            and a.ppsuc  = i.jaqz519suc
            and a.ppmda  = i.jaqz519mda
            and a.pppap  = i.jaqz519pap
            and a.ppcta  = i.jaqz519cta
            and a.ppoper = i.jaqz519ope
            and a.ppsbop = i.jaqz519sbo
            and a.pptope = i.jaqz519top;
            
          delete from fsd602 a
          where a.pgcod  = i.jaqz519emp
            and a.ppmod  = i.jaqz519mod
            and a.ppsuc  = i.jaqz519suc
            and a.ppmda  = i.jaqz519mda
            and a.pppap  = i.jaqz519pap
            and a.ppcta  = i.jaqz519cta
            and a.ppoper = i.jaqz519ope
            and a.ppsbop = i.jaqz519sbo
            and a.pptope = i.jaqz519top;
       
         \* insert into fsd602 
          select * from \*operador.fsd602_06042017_2 a*\ JAQZ521_602 a
          where a.pgcod  = i.jaqz519emp
            and a.ppmod  = i.jaqz519mod
            and a.ppsuc  = i.jaqz519suc
            and a.ppmda  = i.jaqz519mda
            and a.pppap  = i.jaqz519pap
            and a.ppcta  = i.jaqz519cta
            and a.ppoper = i.jaqz519ope
            and a.ppsbop = i.jaqz519sbo
            and a.pptope = i.jaqz519top;
           
             delete from fsd612 a
          where a.pgcod  = i.jaqz519emp
            and a.ppmod  = i.jaqz519mod
            and a.ppsuc  = i.jaqz519suc
            and a.ppmda  = i.jaqz519mda
            and a.pppap  = i.jaqz519pap
            and a.ppcta  = i.jaqz519cta
            and a.ppoper = i.jaqz519ope
            and a.ppsbop = i.jaqz519sbo
            and a.pptope = i.jaqz519top;
          
          insert into fsd612 
          select * from \*operador.fsd612_06042017_2 a*\ JAQZ521_612 a
          where a.pgcod  = i.jaqz519emp
            and a.ppmod  = i.jaqz519mod
            and a.ppsuc  = i.jaqz519suc
            and a.ppmda  = i.jaqz519mda
            and a.pppap  = i.jaqz519pap
            and a.ppcta  = i.jaqz519cta
            and a.ppoper = i.jaqz519ope
            and a.ppsbop = i.jaqz519sbo
            and a.pptope = i.jaqz519top;
            
          commit; 
          *\
         \* update jaqz519 a
             set a.jaqz519ind = 'S'
           where a.jaqz519emp = i.jaqz519emp
             and a.jaqz519mod = i.jaqz519mod
             and a.jaqz519suc = i.jaqz519suc
             and a.jaqz519mda = i.jaqz519mda
             and a.jaqz519pap = i.jaqz519pap
             and a.jaqz519cta = i.jaqz519cta
             and a.jaqz519ope = i.jaqz519ope
             and a.jaqz519sbo = i.jaqz519sbo
             and a.jaqz519top = i.jaqz519top;
             *\
     end loop;  
     commit;
   \*  
     update jaqz519 a
             set a.jaqz519ind = 'S'
           where a.jaqz519emp = 1
             and a.jaqz519mod = 106
             and a.jaqz519suc = 46
             and a.jaqz519mda = 0
             and a.jaqz519pap = 0
             and a.jaqz519cta = 1237025
             and a.jaqz519ope = 3237532
             and a.jaqz519sbo = 0
             and a.jaqz519top = 59;
             
      update jaqz519 a
             set a.jaqz519ind = 'S'
           where a.jaqz519emp = 1
             and a.jaqz519mod = 102
             and a.jaqz519suc = 113
             and a.jaqz519mda = 0
             and a.jaqz519pap = 0
             and a.jaqz519cta = 1856339
             and a.jaqz519ope = 2214772
             and a.jaqz519sbo = 0
             and a.jaqz519top = 107;*\

end Sp_regularizacion;*/

Procedure Sp_verificaRepetidos(pn_grupo in number) is
cursor creditos is
select * from jaqz519 a where a.jaqz519grp = pn_grupo;
lc_flg char(1);
begin
 for i in creditos loop 
  lc_flg := i.jaqz519ind;
  begin
    select 'R'
      into lc_flg
      from jaqz519 a
     where a.jaqz519emp = i.jaqz519emp
       and a.jaqz519mod = i.jaqz519mod
       and a.jaqz519suc = i.jaqz519suc
       and a.jaqz519mda = i.jaqz519mda
       and a.jaqz519pap = i.jaqz519pap
       and a.jaqz519cta = i.jaqz519cta
       and a.jaqz519ope = i.jaqz519ope
       and a.jaqz519sbo = i.jaqz519sbo
       and a.jaqz519top = i.jaqz519top
       and a.jaqz519grp <> pn_grupo
       ;
  exception
  when others then 
       lc_flg := i.jaqz519ind;
  end;
  
  update jaqz519 a
     set a.jaqz519ind = lc_flg
   where a.jaqz519emp = i.jaqz519emp
     and a.jaqz519mod = i.jaqz519mod
     and a.jaqz519suc = i.jaqz519suc
     and a.jaqz519mda = i.jaqz519mda
     and a.jaqz519pap = i.jaqz519pap
     and a.jaqz519cta = i.jaqz519cta
     and a.jaqz519ope = i.jaqz519ope
     and a.jaqz519sbo = i.jaqz519sbo
     and a.jaqz519top = i.jaqz519top
     and a.jaqz519grp = pn_grupo;
     
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
           select a.jaqz522fan
             into ld_fecant
             from jaqz522 a
            where a.jaqz522emp = i.pgcod  
              and a.jaqz522mod = i.ppmod 
              and a.jaqz522suc = i.ppsuc 
              and a.jaqz522mda = i.ppmda 
              and a.jaqz522pap = i.pppap 
              and a.jaqz522cta = i.ppcta 
              and a.jaqz522ope = i.ppoper
              and a.jaqz522sbo = i.ppsbop
              and a.jaqz522top = i.pptope
              and a.jaqz522fac = i.ppfpag
              and a.jaqz522usr = pc_usr
              and a.jaqz522fep = pd_fec;
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
        UPDATE jaqz519 a
           set a.jaqz519r602 = 'S'
         where a.jaqz519emp = i.pgcod 
           and a.jaqz519mod = i.ppmod 
           and a.jaqz519suc = i.ppsuc 
           and a.jaqz519mda = i.ppmda 
           and a.jaqz519pap = i.pppap 
           and a.jaqz519cta = i.ppcta 
           and a.jaqz519ope = i.ppoper
           and a.jaqz519sbo = i.ppsbop
           and a.jaqz519top = i.pptope;
           
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
        UPDATE jaqz519 a
           set a.jaqz519r612 = 'S'
         where a.jaqz519emp = i.pgcod 
           and a.jaqz519mod = i.ppmod 
           and a.jaqz519suc = i.ppsuc 
           and a.jaqz519mda = i.ppmda 
           and a.jaqz519pap = i.pppap 
           and a.jaqz519cta = i.ppcta 
           and a.jaqz519ope = i.ppoper
           and a.jaqz519sbo = i.ppsbop
           and a.jaqz519top = i.pptope;
          commit; 
     end loop;
     commit;
end Sp_Revierte602_612;

Procedure Sp_ObtieneFechaOri(pn_cta in number,
                             pn_ope in number,
                             pd_fec out date)is

begin
      begin
          select a.jaqz519fpp
            into pd_fec
            from jaqz519 a
           where a.jaqz519cta = pn_cta
             and a.jaqz519ope = pn_ope ;
      exception
        when too_many_rows then
             begin
                  select a.jaqz519fpp
                    into pd_fec
                    from jaqz519 a
                   where a.jaqz519cta = pn_cta
                     and a.jaqz519ope = pn_ope
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
     insert into jaqz525_010
     select a.*,trunc(sysdate),0,0 from fsd010 a --chernandez 04/04/2020
      where a.pgcod  = pn_emp
        and a.aomod  = pn_mod
        and a.aosuc  = pn_suc
        and a.aomda  = pn_mda
        and a.aopap  = pn_pap
        and a.aocta  = pn_cta
        and a.aooper = pn_ope
        and a.aosbop = pn_sbo
        and a.aotope = pn_top;
        
        
      insert into jaqz525_011
     select a.*,trunc(sysdate),0,0 from fsd011 a --chernandez 04/04/2020
      where a.pgcod  = pn_emp
        and a.scmod  = pn_mod
        and a.scsuc  = pn_suc
        and a.scmda  = pn_mda
        and a.scpap  = pn_pap
        and a.sccta  = pn_cta
        and a.scoper = pn_ope
        and a.scsbop = pn_sbo
        and a.sctope = pn_top;
        
      insert into jaqz525_601
     select a.*,trunc(sysdate),0,0 from fsd601 a --chernandez 04/04/2020
      where a.pgcod  = pn_emp
        and a.ppmod  = pn_mod
        and a.ppsuc  = pn_suc
        and a.ppmda  = pn_mda
        and a.pppap  = pn_pap
        and a.ppcta  = pn_cta
        and a.ppoper = pn_ope
        and a.ppsbop = pn_sbo
        and a.pptope = pn_top;
        
      insert into jaqz525_611
     select a.*,trunc(sysdate),0,0 from fsd611 a --chernandez 04/04/2020
      where a.pgcod  = pn_emp
        and a.ppmod  = pn_mod
        and a.ppsuc  = pn_suc
        and a.ppmda  = pn_mda
        and a.pppap  = pn_pap
        and a.ppcta  = pn_cta
        and a.ppoper = pn_ope
        and a.ppsbop = pn_sbo
        and a.pptope = pn_top;
        
      insert into jaqz525_602
     select a.*,trunc(sysdate),0,0 from fsd602 a --chernandez 04/04/2020
      where a.pgcod  = pn_emp
        and a.ppmod  = pn_mod
        and a.ppsuc  = pn_suc
        and a.ppmda  = pn_mda
        and a.pppap  = pn_pap
        and a.ppcta  = pn_cta
        and a.ppoper = pn_ope
        and a.ppsbop = pn_sbo
        and a.pptope = pn_top;
        
       insert into jaqz525_612
     select a.*,trunc(sysdate),0,0 from fsd612 a --chernandez 04/04/2020
      where a.pgcod  = pn_emp
        and a.ppmod  = pn_mod
        and a.ppsuc  = pn_suc
        and a.ppmda  = pn_mda
        and a.pppap  = pn_pap
        and a.ppcta  = pn_cta
        and a.ppoper = pn_ope
        and a.ppsbop = pn_sbo
        and a.pptope = pn_top;

       insert into jaqz525_519
     select jaqz519emp, jaqz519mod, jaqz519suc, jaqz519mda, jaqz519pap, 
            jaqz519cta, jaqz519ope, jaqz519sbo, jaqz519top, jaqz519pzo, jaqz519est, 
            jaqz519ind, jaqz519grp, jaqz519rub, jaqz519sdo, jaqz519pdi, jaqz519pro10, 
            jaqz519pro11, jaqz519pro601, jaqz519pro611, jaqz519fep, jaqz519fpp, jaqz519vac, 
            jaqz519vac2, jaqz519cap, jaqz519int, jaqz519mor, jaqz519seg, jaqz519pro602, jaqz519pro612, 
            jaqz519feca, jaqz519r010, jaqz519r011, jaqz519r601, jaqz519r611, jaqz519r602, jaqz519r612, 
            jaqz519spag, jaqz519revr, jaqz519usrr, jaqz519fere      
     from jaqz519 a 
      where a.jaqz519emp  = pn_emp
        and a.jaqz519mod  = pn_mod
        and a.jaqz519suc  = pn_suc
        and a.jaqz519mda  = pn_mda
        and a.jaqz519pap  = pn_pap
        and a.jaqz519cta  = pn_cta
        and a.jaqz519ope  = pn_ope
        and a.jaqz519sbo  = pn_sbo
        and a.jaqz519top  = pn_top;
        
        
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
            

end PQ_CR_REPRODESAS;
/

