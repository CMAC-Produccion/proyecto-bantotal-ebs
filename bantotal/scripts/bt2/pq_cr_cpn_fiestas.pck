create or replace package PQ_CR_CPN_FIESTAS is

  -- Author  : ABERNEDO
  -- Created : 28/06/2017 05:44:23 p.m.
  -- Purpose : 
  
  -- Public type declarations
  /*Procedure Sp_Atraso_Max_deuviv(pn_pai in number,pn_tdo in number,pc_ndo in char,pd_fecpro in date,
                            ln_dia out number);
  Procedure Sp_cr_histDiaAtr_linea (pn_pai in number,pn_tdo in number,pc_ndo in char,pd_fecpro in date,
                           ln_diaTot out number);
  Procedure Sp_cr_histDiaAtr_linea_ii(pn_pai in number,pn_tdo in number,pc_ndo in char,
                                pd_fecor in date,pd_fecpro in date,ln_diafin out number);*/
  Procedure sp_atraso_maximo( pn_pai in number,pn_tdo in number,pc_ndo in char,pd_fecpro in date,
                            pn_moramax out number)     ;
  Procedure Sp_CalculaCuotas(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                           pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                           pn_top in number,pd_fec in date,pd_fecor in date,
                           ln_diafin out number);                                                      

end PQ_CR_CPN_FIESTAS;
/

create or replace package body PQ_CR_CPN_FIESTAS is

/*

NO SE CONSIDERAN ESTOS 3 PROCEDIMIENTOS, ESTAN DESARROLLADOS PARA ATRASO MAXIMO
EN DEUDA VIVA LA TABLA SERA ELIMINADA SI SE DESEA UTILIZAR CREAR OTRA TABLA CON
LA MISMA ESTRUCTURA DE LA JAQZ081

Procedure Sp_Atraso_Max_deuviv(pn_pai in number,pn_tdo in number,pc_ndo in char,pd_fecpro in date,
                            ln_dia out number)is 

begin


      delete from JAQZ527 a where a.pepais = pn_pai and a.petdoc = pn_tdo 
             and a.pendoc = pc_ndo; 
             commit;
      --execute immediate('truncate table jaqz081');
      begin
        insert into JAQZ527(PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,
                            AOSBOP,AOTOPE,AOFVAL,AOFVTO,AOFE99,AOSTAT,
                            PEPAIS,PETDOC,PENDOC,FEUSO ) 
            select B.PGCOD,
                   b.aomod,
                   b.aosuc,
                   b.aomda,
                   b.aopap,
                   b.aocta,
                   b.aooper,
                   b.aosbop,
                   b.aotope,
                   b.aofval,
                   b.aofvto,
                   pq_cr_relcrediticia.Fn_DiaPago(b.PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,
                                                          AOSBOP,AOTOPE,aostat,aofe99),
      
                   b.aostat,
                   a.pepais,
                   a.petdoc,
                   a.pendoc,
                   (case when aostat <> 99 then aofvto
                   else pq_cr_relcrediticia.Fn_DiaPago(b.PGCOD,AOMOD,AOSUC,AOMDA,AOPAP,AOCTA,AOOPER,
                                                          AOSBOP,AOTOPE,aostat,aofe99) end )FEUSO
                   
                   
              from fsr008 a, fsd010 b,fst198 c
             where a.pgcod = 1
               and a.pepais = pn_pai
               and a.petdoc = pn_tdo
               and a.pendoc = pc_ndo
               and a.cttfir = 'T'
               and b.pgcod = a.pgcod
               and b.aocta = a.ctnro
               and aotope <> 550
               and (b.aomod,b.aotope) in (select tp1nro1,tp1nro2 
                                 from fst198 
                                where tp1cod   = 1
                                  and tp1cod1  = 10998
                                  and tp1corr1 = 3
                                  and tp1corr2 = 1
                                  and tp1corr3 = 1)
               
               ;
               
               commit;
      end;
      
      PQ_CR_CPN_FIESTAS.Sp_cr_histDiaAtr_linea(pn_pai,pn_tdo,pc_ndo,Pd_fecpro,ln_dia);

end Sp_Atraso_Max_deuviv;

Procedure Sp_cr_histDiaAtr_linea (pn_pai in number,pn_tdo in number,pc_ndo in char,pd_fecpro in date,
                           ln_diaTot out number) is

cursor creditos is
 select *
   from jaqz527 a
  where a.pepais = pn_pai
    and a.petdoc = pn_tdo
    and a.pendoc = pc_ndo
order by aostat,aofe99 desc,aofval desc;
 
ld_fecantD date;
ld_fecantC date;
ln_mesac number(2);
ln_aniac number(4);
ln_mesan number(2);
ln_anian number(4);
ln_suma number(5);

ld_aofval date;
ld_aofe99 date;
ld_feccorte date;
ln_auxiliar number(5);
ld_fecdes date;
ld_fecaux date;
lc_fecaux char(6);
ld_sysdate date;

ln_contador number(18);

ln_sw number(1);
ln_tiempo number(5);
begin
      
   begin
    ln_contador := 0;  
    ld_fecantD := null;
    
    --tiempo de analisis
    begin
      select tp1nro1
        into ln_tiempo
        from fst198 a
       where a.tp1cod   = 1
         and a.tp1cod1  = 10998
         and a.tp1corr1 = 3
         and a.tp1corr2 = 2
         and a.tp1corr3 = 1;
    exception
      when others then null;
    end;
    
    For i in creditos loop
    ln_sw := 0;
      if (i.aofe99 is null or i.aofe99 = to_date('0001.01.01','yyyy.mm.dd'))and i.aostat = 99 then
         ln_sw := 1;
      end if;
      if ln_sw = 0 then
      
        ln_mesac := to_number(to_char(i.aofe99,'mm'));
        ln_aniac := to_number(to_char(i.aofe99,'yyyy'));
        ln_suma := null;
        ld_aofval := i.aofval;
        ld_aofe99 := last_day(i.aofe99);
        ld_fecdes := i.aofval;
        ld_sysdate := last_day(pd_fecpro );
 
        
        if i.aostat <> 99 then
           ld_aofe99 := pd_fecpro;
        end if;
        
        if ld_fecantD is null then
              if i.aostat = 99 then
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
                   
                  if ld_aofe99 = ld_fecantD or (ln_mesac = ln_mesan and ln_aniac = ln_anian) then
                     if i.aostat = 99 then
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
                          if ld_aofe99 > ld_fecantD then 
                             ld_aofe99 :=  last_day(ld_fecantD);
                             if i.aostat = 99 then
                                  ln_suma := trunc(months_between(ld_aofe99,ld_aofval));
                                   if ln_suma <0 then 
                                      ln_suma := 0;
                                   end if;  
             
                                  ln_contador := ln_contador + ln_suma;
                                  
                                  else
                                    ln_suma := trunc(months_between(ld_aofe99,ld_aofval));
                                     if ln_suma <0 then 
                                        ln_suma := 0;
                                     end if;        
                             
                                    ln_contador := ln_contador + ln_suma;
                              end if;
                                  
                          
                          
                          end if;
                          
                          if ld_aofe99 < ld_fecantD then
                             
                             if i.aostat = 99 then
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
        
  
        ld_fecantD := ld_aofval;
        ld_fecantC := i.aofe99;
        
        
        
        ln_mesan := to_number(to_char(ld_fecantD,'mm'));
        ln_anian := to_number(to_char(ld_fecantD,'yyyy'));
        
        if ln_contador = ln_tiempo then
           
           lc_fecaux := to_char(ld_aofval,'yyyymm');
           ld_feccorte := to_date((lc_fecaux||'01'),'yyyymmdd');
           exit;
        end if;
        if ln_contador > ln_tiempo then
           ln_auxiliar := ln_contador - ln_tiempo;
           ld_fecaux := add_months(ld_aofval,ln_auxiliar);
           lc_fecaux := to_char(ld_fecaux,'yyyymm');
           ld_feccorte := to_date((lc_fecaux||'01'),'yyyymmdd');
           exit;
        end if;
        ld_feccorte := ld_aofval;
      end if;  
    end loop;
    pq_cr_cpn_fiestas.Sp_cr_histDiaAtr_linea_ii(pn_pai,pn_tdo,pc_ndo,ld_feccorte,pd_fecpro,ln_diaTot);

end;
end Sp_cr_histDiaAtr_linea;

Procedure Sp_cr_histDiaAtr_linea_ii(pn_pai in number,pn_tdo in number,pc_ndo in char,
                              pd_fecor in date,pd_fecpro in date,ln_diafin out number) is

cursor creditos is

select * FROM jaqz527 a
WHERE a.pepais = pn_pai
  and a.petdoc = pn_tdo
  and a.pendoc = pc_ndo
  and a.feuso >=pd_fecor
order by aofval desc;

cursor calendario(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                  pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                  pn_top in number) is
select a.pgcod,
       a.ppmod,
       a.ppsuc,
       a.ppmda,
       a.pppap,
       a.ppcta,
       a.ppoper,
       a.ppsbop,
       a.pptope,
       a.ppfpag--,
       --b.ppfpag pag602,
      -- b.pp1fech
 from fsd601 a--,fsd602 b
where a.pgcod  = pn_emp
  and a.ppmod  = pn_mod
  and a.ppsuc  = pn_suc
  and a.ppmda  = pn_mda
  and a.pppap  = pn_pap
  and a.ppcta  = pn_cta
  and a.ppoper = pn_ope
  and a.ppsbop = pn_sbo
  and a.pptope = pn_top
  and a.ppfpag < pd_fecpro
  and a.d601co = 'S'
  and (a.ppcap+a.ppint)<>0;
ln_dia number(18);
     
begin

      begin
       ln_diafin := 0;
       ln_dia := 0;
         for i in creditos loop
           for j in calendario (i.pgcod,i.aomod,i.aosuc,i.aomda,i.aopap,i.aocta,i.aooper,
                                i.aosbop,i.aotope)loop
             
             ln_dia := pq_cr_relcrediticia.fn_cuotasPag(j.pgcod,j.ppmod,j.ppsuc,j.ppmda,j.pppap,
                                                           j.ppcta,j.ppoper,j.ppsbop,j.pptope,
                                                           j.ppfpag,pd_fecpro);
               if ln_dia > ln_diafin then
                  ln_diafin := ln_dia;
               end if;
               
            end loop; 
         end loop;
         
      end;

end Sp_cr_histDiaAtr_linea_ii;
*/

Procedure sp_atraso_maximo( pn_pai in number,pn_tdo in number,pc_ndo in char,pd_fecpro in date,
                            pn_moramax out number) is


cursor creditos is
select distinct B.PGCOD,
     b.aomod,
     b.aosuc,
     b.aomda,
     b.aopap,
     b.aocta,
     b.aooper,
     b.aosbop,
     b.aotope,
     b.aofval,
     b.aofvto,

     b.aostat,
     a.pepais,
     a.petdoc,
     a.pendoc,
     aofvto FEUSO
from fsr008 a,fsd010 b
where a.pgcod = 1
 and a.pepais = pn_pai
 and a.petdoc = pn_tdo
 and a.pendoc = pc_ndo
 and a.cttfir = 'T'
 and b.pgcod = a.pgcod
 and b.aocta = a.ctnro
 and aotope <> 550
 and (b.aomod,b.aotope) in (select tp1nro1,tp1nro2 
                                 from fst198 
                                where tp1cod   = 1
                                  and tp1cod1  = 10998
                                  and tp1corr1 = 3
                                  and tp1corr2 = 1
                                  and tp1corr3 = 1)

 
order by aofval desc;


ln_nromeses number(5);

ld_fecorte date;

ln_moramax number(10);
begin

      begin
       
       begin
           select tp1nro1
             into ln_nromeses
             from fst198 
            where tp1cod   = 1
              and tp1cod1  = 10998
              and tp1corr1 = 3
              and tp1corr2 = 2
              and tp1corr3 = 1;
      exception
        when others then 
             ln_nromeses := 0;
      end;
      ld_fecorte := to_date(to_char(add_months(pd_fecpro,-ln_nromeses),'yyyymm')||'01','yyyymmdd');
      ln_moramax := 0;
      pn_moramax := 0;
  
      for i in creditos loop
        
             pq_cr_cpn_fiestas.sp_calculaCuotas(i.pgcod,i.aomod,i.aosuc,i.aomda,i.aopap,i.aocta,
                                                 i.aooper,i.aosbop,i.aotope,pd_fecpro,ld_fecorte,ln_moramax);
               
               --mora maxima
                if ln_moramax > pn_moramax then
                    pn_moramax := ln_moramax;
                 end if;
                --mora maxima
  
      end loop;  
      end;
   
end sp_atraso_maximo;

Procedure Sp_CalculaCuotas(pn_emp in number,pn_mod in number,pn_suc in number,pn_mda in number,
                           pn_pap in number,pn_cta in number,pn_ope in number,pn_sbo in number,
                           pn_top in number,pd_fec in date,pd_fecor in date,
                           ln_diafin out number)is
cursor creditos is
select a.pgcod,
       a.ppmod,
       a.ppsuc,
       a.ppmda,
       a.pppap,
       a.ppcta,
       a.ppoper,
       a.ppsbop,
       a.pptope,
       a.ppfpag
    
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
  and a.ppfpag < pd_fec
  and a.d601co = 'S'
  and (a.ppcap+a.ppint)<>0
  ;

  
ln_dias number(10);

ld_fecantC date;

ld_fecpago date;

begin
       begin
   
           ld_fecantC := to_date('2000.01.01','yyyy.mm.dd');
           
           ln_diafin := 0;
           ln_dias := 0;
                      
           For i in creditos loop
              
              begin
              
                 select b.pp1fech
                   into ld_fecpago
                   from fsd602 b
                  where b.pgcod = i.pgcod
                    and b.ppmod = i.ppmod
                    and b.ppsuc = i.ppsuc
                    and b.ppmda = i.ppmda
                    and b.pppap = i.pppap
                    and b.ppcta = i.ppcta
                    and b.ppoper = i.ppoper
                    and b.ppsbop = i.ppsbop
                    and b.pptope = i.pptope
                    and b.ppfpag = i.ppfpag
                    and b.pp1stat = 'T'
                    and b.d602co = 'S'
                    and (b.pp1cap+b.pp1int)<>0
                    and rownum=1;
              exception 
                    when no_data_found then
                         ld_fecpago := null;
              end;
              
              if ld_fecpago >=pd_fecor or ld_fecpago is null then
                  
                    if ld_fecantC <> i.ppfpag then
                        
                        ln_dias := pq_cr_relcrediticia.fn_cuotasPag(i.pgcod,i.ppmod,i.ppsuc,i.ppmda,i.pppap,
                                                                    i.ppcta,i.ppoper,i.ppsbop,i.pptope,
                                                                    i.ppfpag,pd_fec);
                        
                        
                        --mora maxima
                        if ln_dias > ln_diafin then
                            ln_diafin := ln_dias;
                         end if;
                        --mora maxima
                    end if;
                    
                    
                    ld_fecantC := i.ppfpag;
               end if;
               
               
               
               
           end loop;
           
          
       end;

end Sp_CalculaCuotas;    


end PQ_CR_CPN_FIESTAS;
/

