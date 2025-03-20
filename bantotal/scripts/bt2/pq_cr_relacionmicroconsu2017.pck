create or replace package PQ_CR_RELACIONMICROCONSU2017 is

  -- Author  : CCERPA
  -- Created : 23/10/2017 10:30:00 a.m.
  -- Purpose :
  Procedure Sp_carga_data(pd_fecpro in date) ;
  Procedure Sp_cr_Inserta (pd_fecpro in date,pd_fecini in date);
  Procedure Sp_cr_historial (pn_pai in number,pn_tdo in number,pc_ndo in char,pd_fecini in date,
                           pd_fecpro in date,
                          ln_contador out number,
                          ln_aostat out number,ln_emp out number,ln_mod out number,ln_suc out number,
                          ln_mda out number,ln_pap out number,ln_cta out number,ln_ope out number,
                          ln_sbo out number,ln_top out number,ld_feccan out date);
Function fn_inserta(pn_pai in number,pn_tdo in number,pc_ndo in char,pn_anio in number,pn_mes in number)return number;                          
procedure Sp_carga_data_MENSUAL(pd_fecpro in date) ;
Function Fn_DiaPago(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                    pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                    pn_top in number,pn_est in number,pd_fec in date) return date;
Procedure Sp_cr_Inserta_MENSUAL (pd_fecpro in date,pd_fecini in date);
Procedure Sp_cr_InsNuevo (pn_pais in number,pn_tdo in number,pc_ndo in char,
                          pd_fecpro in date,pd_fecini in date,ln_contador out number) ;
Procedure Sp_cr_histNuevo (pn_pai in number,pn_tdo in number,pc_ndo in char,pd_fecini in date,
                           pd_fecpro in date,
                          ln_contador out number);
Procedure Sp_cr_ReCalcula(pn_pais in number,pn_tdo in number,pc_ndo in char,pd_fecpro in date,
                          ln_contador out number);                          
                          
 end PQ_CR_RELACIONMICROCONSU2017;
/

create or replace package body PQ_CR_RELACIONMICROCONSU2017 is
Procedure Sp_carga_data(pd_fecpro in date) is
ld_fecini date;
ln_vig number(9);
begin

      begin
          select tp1nro1 
            into ln_vig
            from fst198 
           where tp1cod = 1 
             and tp1cod1 = 10899
             and tp1corr1 = 2
             and tp1corr2 = 1;
      exception
             when others then ln_vig := 60;--cambiar en produccion
      
      end;
      
      ld_fecini:=add_months(pd_fecpro,-ln_vig);    
      execute immediate ('truncate table JAQZ741');
      execute immediate ('truncate table JAQZ742');
      begin     
          insert into JAQZ741 (JAQZ741PGCOD,JAQZ741AOMOD,JAQZ741AOSUC,JAQZ741AOMDA,JAQZ741AOPAP,JAQZ741AOCTA,JAQZ741AOOPER,JAQZ741AOSBOP,JAQZ741AOTOPE,JAQZ741AOFVAL,
                                   JAQZ741AOFVTO,JAQZ741AOFE99,JAQZ741AOSTAT,JAQZ741flag)
                    select a.pgcod,
                           a.aomod,
                           a.aosuc,
                           a.aomda,
                           a.aopap,
                           a.aocta,
                           a.aooper,
                           a.aosbop,
                           a.aotope,
                           a.aofval,
                           a.aofvto,
                           PQ_CR_RELACIONMICROCONSU2017.Fn_DiaPago(PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,
                                                          AOSBOP,AOTOPE,aostat,a.aofe99),
                           --a.aofe99,
                           a.aostat,
                           (case when aofe99 = to_date('0001.01.01','yyyy.mm.dd') and aostat = 99 and aofval <ld_fecini then 'N'
                                else 'S'
                           end)
                       from fsd010 a
                       where  (aomod,aotope) in (select fst098.tpnro,fst098.tpimp from fst098 where fst098.tpcod=7722 and fst098.tpcorr>=100 and fst098.tpcorr<200)
                       and (aofe99 >= ld_fecini or aofe99 = to_date('0001.01.01','yyyy.mm.dd'))
                       and  aocta<>999999999;
                                  commit;                      
      end;
      
      begin
      
          insert into JAQZ742 (JAQZ742PGCOD,JAQZ742AOMOD,JAQZ742AOSUC,JAQZ742AOMDA,JAQZ742AOPAP,JAQZ742AOCTA,JAQZ742AOOPER,JAQZ742AOSBOP,JAQZ742AOTOPE,JAQZ742AOFVAL,
                                   JAQZ742AOFVTO,JAQZ742AOFE99,JAQZ742AOSTAT,JAQZ742PEPAIS,JAQZ742PETDOC,JAQZ742PENDOC)
                                   
                      select a.jaqz741pgcod,
                             a.jaqz741aomod,
                             a.jaqz741aosuc,
                             a.jaqz741aomda,
                             a.jaqz741aopap,
                             a.jaqz741aocta,
                             a.jaqz741aooper,
                             a.jaqz741aosbop,
                             a.jaqz741aotope,
                             a.jaqz741aofval,
                             a.jaqz741aofvto,
                             a.jaqz741aofe99,
                             a.jaqz741aostat, 
                             b.pepais,
                             b.petdoc,
                             b.pendoc
                        from JAQZ741 a,
                             fsr008 b
                       where b.ctnro = a.jaqz741aocta
                         and b.cttfir = 'T'
                         AND A.JAQZ741FLAG = 'S';    
                         --and hipo = 'S'         
          commit;
          
      end;

      commit;  
     PQ_CR_RELACIONMICROCONSU2017.Sp_cr_Inserta(pd_fecpro,ld_fecini);
end Sp_carga_data;
--------------------------------------------------------------------------------------------
Procedure Sp_cr_Inserta (pd_fecpro in date,pd_fecini in date) is

cursor creditos is
select * from JAQZ742 a;
ln_contador number(5);
ln_ins number(1);
ln_anio number(4);
ln_mes number(2);
ln_inserta char(1);
ld_feccan date;
ln_estado number(2);
ln_emp number(3);
ln_mod number(3);
ln_suc number(3);
ln_mda number(4);
ln_pap number(4);
ln_cta number(9);
ln_ope number(9);
ln_sbo number(3);
ln_top number(3);
ld_fecini date;
ld_fec date;
LN_AUX NUMBER(9);

begin

      Begin
            
         ln_anio := to_number(to_char(pd_fecpro,'yyyy'));
         ln_mes := to_number(to_char(pd_fecpro,'mm'));
         
         ld_fecini := to_date(to_char(pd_fecini,'yyyymm')||'01','yyyymmdd')   ;
         for i in creditos loop
             ln_contador := null;
             ln_inserta  := NULL;
             ln_ins := PQ_CR_RELACIONMICROCONSU2017.fn_inserta(i.jaqz742pepais,i.jaqz742petdoc,i.jaqz742pendoc,ln_anio,ln_mes); 
                        
             if ln_ins = 0 then
                --PQ_CR_RELACIONMICROCONSU2017.sp_cr_cancelados(i.pepais,i.petdoc,i.pendoc,pd_fecpro,ln_inserta,
                --                                     ld_feccan);
                --if ln_inserta = 'S' then
                    PQ_CR_RELACIONMICROCONSU2017.Sp_cr_historial(i.jaqz742pepais,i.jaqz742petdoc,i.jaqz742pendoc,ld_fecini,pd_fecpro,
                                                        ln_contador,
                                                        ln_estado,ln_emp,ln_mod,ln_suc,ln_mda,ln_pap,
                                                        ln_cta,ln_ope,ln_sbo,ln_top,ld_fec);
                    
                    insert into jaqz736(JAQZ736PAI,JAQZ736TDO,JAQZ736NDO,JAQZ736ANI,JAQZ736MES,
                                        JAQZ736FEP,JAQZ736his,JAQZ736FCN,JAQZ736est,JAQZ736pgc,
                                        JAQZ736mod,JAQZ736suc,JAQZ736mda,JAQZ736pap,JAQZ736cta,
                                        JAQZ736ope,JAQZ736sbo,JAQZ736top,JAQZ736FEC)
                    
                    values(i.jaqz742pepais,i.jaqz742petdoc,i.jaqz742pendoc,ln_anio,ln_mes,pd_fecpro,ln_contador,ld_feccan,
                           ln_estado,ln_emp,ln_mod,ln_suc,ln_mda,ln_pap,
                                                        ln_cta,ln_ope,ln_sbo,ln_top,ld_fec);
                                                        
                                                       
                    
                    commit;
                    
                    
                --end if;
                
             end if;
             commit;
             
         end loop;
         
         LN_AUX :=to_number(to_char(pd_fecpro,'ddmmyyyy'));
                    UPDATE FST198 set tp1nro1 = LN_AUX
                    where tp1cod1 = 11108
                      and tp1corr1 = 2
                      and tp1corr2 = 1;
                      commit;
                      
         commit;
      end;


end Sp_cr_Inserta;
--------------------------------------------------------------------------------------------
Function fn_inserta(pn_pai in number,pn_tdo in number,pc_ndo in char,pn_anio in number,pn_mes in number)return number is
ln_existe number(1);

begin
    
         begin
              select 1
                into ln_existe
                from jaqz736 a
               where a.jaqz736pai = pn_pai
                 and a.jaqz736tdo = pn_tdo
                 and a.jaqz736ndo = pc_ndo
                 and a.jaqz736ani = pn_anio
                 and a.jaqz736mes = pn_mes;
                 
         exception
                 when others then 
                      ln_existe := 0;
         end;

         if ln_existe is null then
            ln_existe := 0;
         end if;
         return ln_existe;
end fn_inserta;
---------------------------------------------------------------------------------------------
Procedure Sp_cr_historial (pn_pai in number,pn_tdo in number,pc_ndo in char,pd_fecini in date,
                           pd_fecpro in date,
                          ln_contador out number,
                          ln_aostat out number,ln_emp out number,ln_mod out number,ln_suc out number,
                          ln_mda out number,ln_pap out number,ln_cta out number,ln_ope out number,
                          ln_sbo out number,ln_top out number,ld_feccan out date) is
cursor creditos is
 select *
   from JAQZ742 a
  where a.jaqz742pepais = pn_pai
    and a.jaqz742petdoc = pn_tdo
    and a.jaqz742pendoc = pc_ndo
order by jaqz742aofval;

cursor creditos_i is
 select *
   from JAQZ742 a
  where a.JAQZ742pepais = pn_pai
    and a.JAQZ742petdoc = pn_tdo
    and a.JAQZ742pendoc = pc_ndo
order by JAQZ742aostat,JAQZ742aofe99 desc;

--ln_contador number(5);    
ld_fecantD date;
ld_fecantC date;
--ln_aux number(4);
ln_mesac number(2);
ln_aniac number(4);
ln_mesan number(2);
ln_anian number(4);
ln_suma number(5);

ld_aofval date;
ld_aofe99 date;
--ld_dia number(2);

ld_sysdate date;

ln_sw number(1);
begin
      
   begin
    ln_contador := 0;  
    ld_fecantD := null;
    ld_fecantC := to_date('2000.01.01','yyyy.mm.dd');
    ld_sysdate := last_day(pd_fecpro );
    For i in creditos loop
      ln_sw := 0;
      if (i.jaqz742aofe99 is null or i.JAQZ742aofe99 = to_date('0001.01.01','yyyy.mm.dd'))and i.JAQZ742aostat = 99 then
         ln_sw := 1;
      end if;
      if ln_sw = 0 then
      
        ln_mesac := to_number(to_char(i.jaqz742aofval,'mm'));
        ln_aniac := to_number(to_char(i.JAQZ742aofval,'yyyy'));
        ln_suma := null;
        ld_aofval := i.JAQZ742aofval;
        ld_aofe99 := last_day(i.JAQZ742aofe99);
        
        if ld_aofval < pd_fecini then
           ld_aofval := pd_fecini;
        end if;
        
        if ld_fecantD is null then
              if i.JAQZ742aostat = 99 then
                 ln_suma := trunc(months_between(ld_aofe99,ld_aofval))+1;
                 if ln_suma <0 then 
                    ln_suma := 0;
                 end if;
                 ln_contador := ln_contador + ln_suma;
                 else 
                     ln_suma := trunc(months_between(ld_sysdate,ld_aofval))+1;
                     if ln_suma <0 then 
                        ln_suma := 0;
                     end if;
                     ln_contador := ln_contador + ln_suma;
                 
              end if;
              
              Else
                   
                  if ld_aofval = ld_fecantC or (ln_mesac = ln_mesan and ln_aniac = ln_anian) then
                     if i.jaqz742aostat = 99 then
                          ln_suma := trunc(months_between(ld_aofe99,ld_aofval));
                           if ln_suma <0 then 
                              ln_suma := 0;
                           end if;       
                          ln_contador := ln_contador + ln_suma;
                          
                          else
                            ln_suma := trunc(months_between(ld_sysdate,
                                                               ld_aofval));
                             if ln_suma <0 then 
                                ln_suma := 0;
                             end if;          
                            ln_contador := ln_contador + ln_suma;
                      end if;
                      
                      else
                          if ld_aofval < ld_fecantC then
                             --ln_aux := trunc(months_between(ld_fecantC,ld_aofval));  
                             ld_aofval :=  ld_fecantC;
                             if i.jaqz742aostat = 99 then
                                  ln_suma := trunc(months_between(ld_aofe99,ld_aofval));
                                   if ln_suma <0 then 
                                      ln_suma := 0;
                                   end if;  
                                   /*if ln_aux > ln_suma then
                                      ln_suma := 0;
                                      ln_aux  := 0;
                                   end if;*/
                                  ln_contador := ln_contador + ln_suma;-- - ln_aux;
                                  
                                  else
                                    ln_suma := trunc(months_between(ld_sysdate,ld_aofval));
                                     if ln_suma <0 then 
                                        ln_suma := 0;
                                     end if;        
                                     /*if ln_aux > ln_suma then
                                        ln_suma := 0;
                                        ln_aux  := 0;
                                     end if; */   
                                    ln_contador := ln_contador + ln_suma;-- - ln_aux;
                              end if;
                                  
                          
                          
                          end if;
                          
                          if ld_aofval > ld_fecantC then
                             
                             if i.jaqz742aostat= 99 then
                                  ln_suma := trunc(months_between(ld_aofe99,ld_aofval))+1;
                                   if ln_suma <0 then 
                                      ln_suma := 0;
                                   end if;  
                                  ln_contador := ln_contador + ln_suma;
                                  
                                  else
                                    ln_suma := trunc(months_between(ld_sysdate,ld_aofval))+1;
                                     if ln_suma <0 then 
                                        ln_suma := 0;
                                     end if;  
                                    ln_contador := ln_contador + ln_suma;
                              end if;
                                  
                          
                          
                          end if;
                      
                  
                  end if;
              
        end if;
        
        if i.jaqz742aofe99 = to_date('0001.01.01','yyyy.mm.dd') then
           if ld_fecantC > i.jaqz742aofval then
              ld_aofval := ld_fecantC;
           end if;
           ld_fecantC := pd_fecpro;-- trunc(sysdate);
        end if;
        
        if i.jaqz742aofe99 > ld_fecantC then
                    --ld_fecantD := ld_aofval;
                     ld_fecantC := i.jaqz742aofe99;
        
        end if;
        ld_fecantD := ld_aofval;
        
        
        
        
        ln_mesan := to_number(to_char(ld_fecantC,'mm'));
        ln_anian := to_number(to_char(ld_fecantC,'yyyy'));
        
      end if;
    end loop;
    
   
    For j in creditos_i loop
    
       ln_emp := j.jaqz742pgcod;
       ln_mod := j.jaqz742aomod;
       ln_suc := j.jaqz742aosuc;
       ln_mda := j.jaqz742aomda;
       ln_pap := j.jaqz742aopap;
       ln_cta := j.jaqz742aocta;
       ln_ope := j.jaqz742aooper;
       ln_sbo := j.jaqz742aosbop;
       ln_top := j.jaqz742aotope;
       ln_aostat := j.jaqz742aostat;
       ld_feccan := j.jaqz742aofe99;
       exit;
    end loop;
   end;        

end Sp_cr_historial;

---------------------------------------------------------------------------------------------
procedure Sp_carga_data_MENSUAL(pd_fecpro in date) is
ld_fecini date;
ln_vig number(9);
begin

      begin
          select tp1nro1 
            into ln_vig
            from fst198 
           where tp1cod = 1 
             and tp1cod1 = 10899
             and tp1corr1 = 2
             and tp1corr2 = 1;
      exception
             when others then ln_vig := 60;--cambiar en produccion
      
      end;
      
      ld_fecini:=add_months(pd_fecpro,-ln_vig);    
      execute immediate ('truncate table JAQZ741');
      execute immediate ('truncate table JAQZ742');
      begin
      
          insert into JAQZ741 (JAQZ741PGCOD,JAQZ741AOMOD,JAQZ741AOSUC,JAQZ741AOMDA,JAQZ741AOPAP,JAQZ741AOCTA,JAQZ741AOOPER,JAQZ741AOSBOP,JAQZ741AOTOPE,JAQZ741AOFVAL,
                                   JAQZ741AOFVTO,JAQZ741AOFE99,JAQZ741AOSTAT,JAQZ741flag)
                    select a.pgcod,
                           a.aomod,
                           a.aosuc,
                           a.aomda,
                           a.aopap,
                           a.aocta,
                           a.aooper,
                           a.aosbop,
                           a.aotope,
                           a.aofval,
                           a.aofvto,
                           PQ_CR_RELACIONMICROCONSU2017.Fn_DiaPago(PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,
                                                          AOSBOP,AOTOPE,aostat,a.aofe99),
                           --a.aofe99,
                           a.aostat,
                           (case when aofe99 = to_date('0001.01.01','yyyy.mm.dd') and aostat = 99 and aofval <ld_fecini then 'N'
                                else 'S'
                           end)
                           
                  from fsd010 a
                       where  (aomod,aotope) in (select fst098.tpnro,fst098.tpimp from fst098 where fst098.tpcod=7722 and fst098.tpcorr>=100 and fst098.tpcorr<200)
                       and (aofe99 >= ld_fecini or aofe99 = to_date('0001.01.01','yyyy.mm.dd'))
                       and  aocta<>999999999;
                    
              commit;                
          
      
      end;
      
      begin
      
          insert into JAQZ742 (JAQZ742PGCOD,JAQZ742AOMOD,JAQZ742AOSUC,JAQZ742AOMDA,JAQZ742AOPAP,JAQZ742AOCTA,JAQZ742AOOPER,JAQZ742AOSBOP,JAQZ742AOTOPE,JAQZ742AOFVAL,
                                   JAQZ742AOFVTO,JAQZ742AOFE99,JAQZ742AOSTAT,JAQZ742PEPAIS,JAQZ742PETDOC,JAQZ742PENDOC)
                                   
                      select a.JAQZ741pgcod,
                             a.JAQZ741aomod,
                             a.JAQZ741aosuc,
                             a.JAQZ741aomda,
                             a.JAQZ741aopap,
                             a.JAQZ741aocta,
                             a.JAQZ741aooper,
                             a.JAQZ741aosbop,
                             a.JAQZ741aotope,
                             a.JAQZ741aofval,
                             a.JAQZ741aofvto,
                             a.JAQZ741aofe99,
                             a.JAQZ741aostat, 
                             b.pepais,
                             b.petdoc,
                             b.pendoc
                        from JAQZ741 a,
                             fsr008 b
                       where b.ctnro = a.JAQZ741aocta
                         and b.cttfir = 'T'
                         AND A.JAQZ741FLAG = 'S';             
          commit;
          
      end;

      commit;
      
      PQ_CR_RELACIONMICROCONSU2017.Sp_cr_Inserta_MENSUAL(pd_fecpro,ld_fecini);
end Sp_carga_data_MENSUAL;
----------------------------------------------------------------------------------------------
Function Fn_DiaPago(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                    pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                    pn_top in number,pn_est in number,pd_fec in date) return date is
ld_fecpag date;
                   
begin

       begin
          if pn_est = 99 then
             if pd_fec = to_date('01.01.0001','dd.mm.yyyy') or pd_fec is null then
                begin
                     
                          Select max(pp1fech)
                            into ld_fecpag
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
                             and a.d602co = 'S'
                             and (a.pp1cap+a.pp1int)<>0
                             and a.pp1stat = 'T';
                     exception 
                             when no_data_found then
                                  ld_fecpag := to_date('01.01.0001','dd.mm.yyyy'); 
  
                     end;
                     else
                         ld_fecpag := pd_fec;
               end if;
               
               else
                   ld_fecpag := to_date('01.01.0001','dd.mm.yyyy');
          end if;
       end;
       return ld_fecpag;
end Fn_DiaPago;
-------------------------------------------------------------------------------------------
Procedure Sp_cr_Inserta_MENSUAL (pd_fecpro in date,pd_fecini in date) is

cursor creditos is
select * from JAQZ742 a ;
ln_contador number(5);
ln_ins number(1);
ln_anio number(4);
ln_mes number(2);
ln_inserta char(1);
ld_feccan date;
ln_estado number(2);
ln_emp number(3);
ln_mod number(3);
ln_suc number(3);
ln_mda number(4);
ln_pap number(4);
ln_cta number(9);
ln_ope number(9);
ln_sbo number(3);
ln_top number(3);

ld_fecini date;

ld_fec date;
LN_AUX NUMBER(9);

ld_fecguia date;
ln_histAnt number(5);
ln_estAnt number(2);
ln_empAnt number(3);
ln_modAnt number(3);
ln_sucAnt number(3);
ln_mdaAnt number(4);
ln_papAnt number(4);
ln_ctaAnt number(9);
ln_opeAnt number(9);
ln_sboAnt number(3);
ln_topAnt number(3);
ld_fecAnt date;

ln_estPro number(2);
ln_empPro number(3);
ln_modPro number(3);
ln_sucPro number(3);
ln_mdaPro number(4);
ln_papPro number(4);
ln_ctaPro number(9);
ln_opePro number(9);
ln_sboPro number(3);
ln_topPro number(3);
ld_fecPro date;
ln_contPro number(5);

ld_fectmp date;
ld_fecvac date;

begin

      Begin
            
         ln_anio := to_number(to_char(pd_fecpro,'yyyy'));
         ln_mes := to_number(to_char(pd_fecpro,'mm'));
         
         ld_fecini := to_date(to_char(pd_fecini,'yyyymm')||'01','yyyymmdd')   ;
         
         ld_fectmp := to_date(to_char(add_months(pd_fecpro,-12),'yyyymm')||'01','yyyymmdd');
         ld_fecvac := to_date('0001.01.01','yyyy.mm.dd');
         
          
         begin
             select to_date(a.tp1nro1,'ddmmyyyy')
               into ld_fecguia
               from fst198 a
              where a.tp1cod = 1
                and a.tp1cod1 = 11108
                and a.tp1corr1 = 2
                and a.tp1corr2 = 1; 
         exception 
                when no_data_found then
                     ld_fecguia := null;
         end;
         
                  
         for i in creditos loop
             ln_contador := null;
             ln_inserta  := NULL;
             ln_estado := null;
             ln_emp    := null;
             ln_mod    := null;
             ln_suc    := null;
             ln_mda    := null;
             ln_pap    := null;
             ln_cta    := null;
             ln_ope    := null;
             ln_sbo    := null;
             ln_top    := null;
             ld_feC    := null;
             ln_ins := PQ_CR_RELACIONMICROCONSU2017.fn_inserta(i.jaqz742pepais,i.jaqz742petdoc,i.jaqz742pendoc,ln_anio,ln_mes); 
             
             begin
                    select a.jaqz736his,
                           a.jaqz736est,
                           a.jaqz736pgc,
                           a.jaqz736mod,
                           a.jaqz736suc,
                           a.jaqz736mda,
                           a.jaqz736pap,
                           a.jaqz736cta,
                           a.jaqz736ope,
                           a.jaqz736sbo,
                           a.jaqz736top,
                           a.jaqz736fec
                      into ln_histAnt,
                           ln_estAnt, 
                           ln_empAnt,
                           ln_modAnt,
                           ln_sucAnt,
                           ln_mdaAnt,
                           ln_papAnt,
                           ln_ctaAnt,
                           ln_opeAnt,
                           ln_sboAnt,
                           ln_topAnt,
                           ld_fecAnt
                      from jaqz736 a
                     where a.jaqz736pai = i.jaqz742pepais
                       and a.jaqz736tdo = i.jaqz742petdoc
                       and a.jaqz736ndo = i.jaqz742pendoc
                       and a.jaqz736fep = ld_fecguia;
                       
             exception
                  when no_data_found then
                       ln_histAnt := null;
                       ln_estAnt := null;
             end;
                        
             if ln_ins = 0 then
                --PQ_CR_RELACIONMICROCONSU2017.sp_cr_cancelados(i.pepais,i.petdoc,i.pendoc,pd_fecpro,ln_inserta,
                --                                     ld_feccan);
                --if ln_inserta = 'S' then
                     PQ_CR_RELACIONMICROCONSU2017.Sp_cr_historial(i.jaqz742pepais,i.jaqz742petdoc,i.jaqz742pendoc,ld_fecini,pd_fecpro,
                                                        ln_contPro,
                                                        ln_estPro,ln_empPro,ln_modPro,ln_sucPro,ln_mdaPro,
                                                        ln_papPro,ln_ctaPro,ln_opePro,ln_sboPro,ln_topPro,
                                                        ld_fecPro);
                     if ln_estAnt is not null then     --mod 2016.03.30                              
                       if ln_estAnt <> 99 or ln_estPro <> 99 then
                          ln_contador := ln_histAnt + 1 ;
                          ln_estado := ln_estPro;
                          ln_emp    := ln_empPro;
                          ln_mod    := ln_modPro;
                          ln_suc    := ln_sucPro;
                          ln_mda    := ln_mdaPro;
                          ln_pap    := ln_papPro;
                          ln_cta    := ln_ctaPro;
                          ln_ope    := ln_opePro;
                          ln_sbo    := ln_sboPro;
                          ln_top    := ln_topPro;
                          ld_feC    := ld_fecPro;
                          
                       end if;
                     end if;
                     
                     if ln_estAnt is null then
                        ln_contador := ln_contPro;
                        ln_estado := ln_estPro;
                        ln_emp := ln_empPro;
                        ln_mod := ln_modPro;
                        ln_suc := ln_sucPro;
                        ln_mda := ln_mdaPro;
                        ln_pap := ln_papPro;
                        ln_cta := ln_ctaPro;
                        ln_ope := ln_opePro;
                        ln_sbo := ln_sboPro;
                        ln_top := ln_topPro;
                        ld_feC := ld_fecPro;
                    
                     end if;
                     
                     if ln_estAnt = 99 and ln_estPro = 99 then --mod 2016.03.30
                        if ld_fecvac = ld_fecAnt or ld_fecAnt >= ld_fectmp then
                           ln_contador := ln_histAnt;
                           ln_estado := ln_estPro;
                           ln_emp    := ln_empPro;
                           ln_mod    := ln_modPro;
                           ln_suc    := ln_sucPro;
                           ln_mda    := ln_mdaPro;
                           ln_pap    := ln_papPro;
                           ln_cta    := ln_ctaPro;
                           ln_ope    := ln_opePro;
                           ln_sbo    := ln_sboPro;
                           ln_top    := ln_topPro;   
                           ld_feC    := ld_fecPro;
                           
                           else
                                  ln_contador := ln_contPro;
                                  ln_estado := ln_estPro;
                                  ln_emp := ln_empPro;
                                  ln_mod := ln_modPro;
                                  ln_suc := ln_sucPro;
                                  ln_mda := ln_mdaPro;
                                  ln_pap := ln_papPro;
                                  ln_cta := ln_ctaPro;
                                  ln_ope := ln_opePro;
                                  ln_sbo := ln_sboPro;
                                  ln_top := ln_topPro;   
                                  ld_feC := ld_fecPro;                   
                           
                        end if;
                     end if;
                     
                    
                    insert into jaqz736(jaqz736PAI,jaqz736TDO,jaqz736NDO,jaqz736ANI,jaqz736MES,
                                        jaqz736FEP,jaqz736his,jaqz736FCN,jaqz736est,jaqz736pgc,
                                        jaqz736mod,jaqz736suc,jaqz736mda,jaqz736pap,jaqz736cta,
                                        jaqz736ope,jaqz736sbo,jaqz736top,jaqz736FEC)
                    
                    values(i.jaqz742pepais,i.jaqz742petdoc,i.jaqz742pendoc,ln_anio,ln_mes,pd_fecpro,ln_contador,ld_feccan,
                           ln_estado,ln_emp,ln_mod,ln_suc,ln_mda,ln_pap,
                                                        ln_cta,ln_ope,ln_sbo,ln_top,ld_fec);
                                                        
                                                       
                    
                    commit;
                    
                    
                --end if;
                
             end if;
             commit;
             
         end loop;
                      
         commit;
         
         LN_AUX :=to_number(to_char(pd_fecpro,'ddmmyyyy'));
                    UPDATE FST198 set tp1nro1 = LN_AUX
                   where tp1cod1 = 11108
                      and tp1corr1 = 2
                      and tp1corr2 = 1;
                      commit;
      end;


end Sp_cr_Inserta_MENSUAL;
---------------------------------------------------------------------------------------------------
Procedure Sp_cr_ReCalcula(pn_pais in number,pn_tdo in number,pc_ndo in char,pd_fecpro in date,
                          ln_contador out number) is

ld_fecini date;
ln_vig number(9);
begin
     begin
          select tp1nro1 
            into ln_vig
            from fst198 
           where tp1cod = 1 
             and tp1cod1 = 10899
             and tp1corr1 = 2
             and tp1corr2 = 1;
      exception
             when others then ln_vig := 60;
      end;


     ld_fecini :=add_months(pd_fecpro,-ln_vig);    
     delete from  jaqz737 a where a.jaqz737pepais = pn_pais and a.jaqz737petdoc = pn_tdo and a.jaqz737pendoc = pc_ndo;
     commit;
     --execute immediate('truncate table jaqz075');
     begin
     
      insert into jaqz737(jaqz737PGCOD,jaqz737AOMOD,jaqz737AOSUC,jaqz737AOMDA,jaqz737AOPAP,jaqz737AOCTA,jaqz737AOOPER,jaqz737AOSBOP,jaqz737AOTOPE,jaqz737AOFVAL,
                                   jaqz737AOFVTO,jaqz737AOFE99,jaqz737AOSTAT,jaqz737PEPAIS,jaqz737PETDOC,jaqz737PENDOC) 
          select pgcod,
                 aomod,
                 aosuc,
                 aomda,
                 aopap,
                 aocta,
                 aooper,
                 aosbop,
                 aotope,
                 aofval,
                 aofvto,
                 aofe99,
                 aostat, 
                 pepais,
                 petdoc,
                 pendoc
           from (
          select a.pgcod,
                 a.aomod,
                 a.aosuc,
                 a.aomda,
                 a.aopap,
                 a.aocta,
                 a.aooper,
                 a.aosbop,
                 a.aotope,
                 a.aofval,
                 a.aofvto,
                 --a.aofe99,
                 PQ_CR_RELACIONMICROCONSU2017.Fn_DiaPago(a.PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,
                                                          AOSBOP,AOTOPE,aostat,a.aofe99)aofe99,
                 a.aostat, 
                 b.pepais,
                 b.petdoc,
                 b.pendoc,
                 (case when aofe99 = to_date('0001.01.01','yyyy.mm.dd') and aostat = 99 and aofval <ld_fecini then 'N'
                                else 'S'
                  end) flag
                  
            from fsr008 b, fsd010 a
           where b.pgcod = 1
             and b.pepais = pn_pais
             and b.petdoc = pn_tdo
             and b.pendoc = pc_ndo
             and b.cttfir = 'T'
             and a.pgcod = b.pgcod
             and a.aocta = b.ctnro
             and (a.aomod,a.aotope) in (select fst098.tpnro,fst098.tpimp from fst098 where fst098.tpcod=7722 and fst098.tpcorr>=100 and fst098.tpcorr<200)
                  
             and (aofe99 >= ld_fecini or aofe99 = to_date('0001.01.01','yyyy.mm.dd')))
            where flag = 'S';
             
             commit;
     
     end;

     PQ_CR_RELACIONMICROCONSU2017.Sp_cr_InsNuevo(pn_pais,pn_tdo,pc_ndo,pd_fecpro,ld_fecini,ln_contador);
     
     
                                                 
end Sp_cr_ReCalcula;
---------------------------------------------------------------------------------------------------
Procedure Sp_cr_InsNuevo (pn_pais in number,pn_tdo in number,pc_ndo in char,
                          pd_fecpro in date,pd_fecini in date,ln_contador out number) is

cursor creditos is
select * from jaqz737 a
where a.jaqz737pepais = pn_pais
  and a.jaqz737petdoc = pn_tdo
  and a.jaqz737pendoc = pc_ndo;
--ln_ins number(1);
--ln_anio number(4);
--ln_mes number(2);
begin

      Begin
            
         --ln_anio := to_number(to_char(pd_fecpro,'yyyy'));
         --ln_mes := to_number(to_char(pd_fecpro,'mm'));
            
         for i in creditos loop
             ln_contador := null;
             PQ_CR_RELACIONMICROCONSU2017.Sp_cr_histNuevo(i.jaqz737pepais,i.jaqz737petdoc,i.jaqz737pendoc,pd_fecini,pd_fecpro,
                                                 ln_contador);
       
         end loop;
         commit;
      end;


end Sp_cr_InsNuevo;
---------------------------------------------------------------------------------------------------
Procedure Sp_cr_histNuevo (pn_pai in number,pn_tdo in number,pc_ndo in char,pd_fecini in date,
                           pd_fecpro in date,
                          ln_contador out number) is


cursor creditos is
 select *
   from jaqz737 a
  where a.jaqz737pepais = pn_pai
    and a.jaqz737petdoc = pn_tdo
    and a.jaqz737pendoc = pc_ndo
order by a.jaqz737aofval;

--ln_contador number(5);    
ld_fecantD date;
ld_fecantC date;
--ln_aux number(4);
ln_mesac number(2);
ln_aniac number(4);
ln_mesan number(2);
ln_anian number(4);
ln_suma number(5);

ld_aofval date;
ld_aofe99 date;
--ld_dia number(2);

ln_sw number(1);
ld_sysdate date;
begin
   
   begin
    ln_contador := 0;  
    ld_fecantD := null;
    ld_fecantC := to_date('2000.01.01','yyyy.mm.dd');
    ld_sysdate := last_day(pd_fecpro );
    For i in creditos loop
      ln_sw := 0;
      if i.jaqz737aofe99 is null and i.jaqz737aostat = 99 then
         ln_sw := 1;
      end if;
      if ln_sw = 0 then
      
        ln_mesac := to_number(to_char(i.jaqz737aofval,'mm'));
        ln_aniac := to_number(to_char(i.jaqz737aofval,'yyyy'));
        ln_suma := null;
        ld_aofval := i.jaqz737aofval;
        ld_aofe99 := last_day(i.jaqz737aofe99);
        
        if ld_aofval < pd_fecini then
           ld_aofval := pd_fecini;
        end if;
        
        if ld_fecantD is null then
              if i.jaqz737aostat = 99 then
                 ln_suma := trunc(months_between(ld_aofe99,ld_aofval))+1;
                 if ln_suma <0 then 
                    ln_suma := 0;
                 end if;
                 ln_contador := ln_contador + ln_suma;
                 else 
                     ln_suma := trunc(months_between(ld_sysdate,ld_aofval))+1;
                     if ln_suma <0 then 
                        ln_suma := 0;
                     end if;
                     ln_contador := ln_contador + ln_suma;
                 
              end if;
              
              Else
                   
                  if ld_aofval = ld_fecantC or (ln_mesac = ln_mesan and ln_aniac = ln_anian) then
                     if i.jaqz737aostat = 99 then
                          ln_suma := trunc(months_between(ld_aofe99,ld_aofval));
                           if ln_suma <0 then 
                              ln_suma := 0;
                           end if;       
                          ln_contador := ln_contador + ln_suma;
                          
                          else
                            ln_suma := trunc(months_between(ld_sysdate,
                                                               ld_aofval));
                             if ln_suma <0 then 
                                ln_suma := 0;
                             end if;          
                            ln_contador := ln_contador + ln_suma;
                      end if;
                      
                      else
                          if ld_aofval < ld_fecantC then
                             --ln_aux := trunc(months_between(ld_fecantC,ld_aofval));  
                             ld_aofval :=  ld_fecantC;
                             if i.jaqz737aostat = 99 then
                                  ln_suma := trunc(months_between(ld_aofe99,ld_aofval));
                                   if ln_suma <0 then 
                                      ln_suma := 0;
                                   end if;  
                                   /*if ln_aux > ln_suma then
                                      ln_suma := 0;
                                      ln_aux  := 0;
                                   end if;*/
                                  ln_contador := ln_contador + ln_suma;-- - ln_aux;
                                  
                                  else
                                    ln_suma := trunc(months_between(ld_sysdate,ld_aofval));
                                     if ln_suma <0 then 
                                        ln_suma := 0;
                                     end if;        
                                     /*if ln_aux > ln_suma then
                                        ln_suma := 0;
                                        ln_aux  := 0;
                                     end if; */   
                                    ln_contador := ln_contador + ln_suma;-- - ln_aux;
                              end if;
                                  
                          
                          
                          end if;
                          
                          if ld_aofval > ld_fecantC then
                             
                             if i.jaqz737aostat = 99 then
                                  ln_suma := trunc(months_between(ld_aofe99,ld_aofval))+1;
                                   if ln_suma <0 then 
                                      ln_suma := 0;
                                   end if;  
                                  ln_contador := ln_contador + ln_suma;
                                  
                                  else
                                    ln_suma := trunc(months_between(ld_sysdate,ld_aofval))+1;
                                     if ln_suma <0 then 
                                        ln_suma := 0;
                                     end if;  
                                    ln_contador := ln_contador + ln_suma;
                              end if;
                                  
                          
                          
                          end if;
                      
                  
                  end if;
              
        end if;
        
        if i.jaqz737aofe99 = to_date('0001.01.01','yyyy.mm.dd') then
           if ld_fecantC > i.jaqz737aofval then
              ld_aofval := ld_fecantC;
           end if;
           ld_fecantC := trunc(sysdate);
        end if;
        
        if i.jaqz737aofe99 > ld_fecantC then
                    --ld_fecantD := ld_aofval;
                     ld_fecantC := i.jaqz737aofe99;
        
        end if;
        ld_fecantD := ld_aofval;
        
        
        
        
        ln_mesan := to_number(to_char(ld_fecantC,'mm'));
        ln_anian := to_number(to_char(ld_fecantC,'yyyy'));
        
      end if;
    end loop;
    
    end;
     

end Sp_cr_histNuevo;
-------------------------------------------------------------------------------------------------------

end PQ_CR_RELACIONMICROCONSU2017;
/

