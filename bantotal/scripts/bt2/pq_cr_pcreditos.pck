create or replace package pq_cr_pcreditos is

  -- Author  : KVALENCIAC
  -- Created : 08/05/2024
  -- Purpose : Devuelve número de creditos con garantia (según los tipos de garantía adicionados a la guía)  
  -- Modificado : KVALENCIAC
  -- Fecha : 26/11/2024
  -- Purpose : Se corrigió par aque devuelva bien para los créditos de líneas
  procedure sp_contador (vn_instancia in  number, vn_ncreditos out number);

end pq_cr_pcreditos;
/

create or replace package body pq_cr_pcreditos is

procedure sp_contador ( vn_instancia number, vn_ncreditos out number)
is  
cursor creditos is
select b.*
          from fsr008 a,fsd010 b,sng001 s
           where 
              s.sng001inst=vn_instancia
             and a.ctnro =s.sng001cta
--             and a.pepais = vn_pepais
--             and a.petdoc = vn_petdoc
--             and a.pendoc = vc_pendoc
             and b.pgcod = a.pgcod
             and b.aocta = a.ctnro
             and b.aostat<>99--no este cancelada
             and b.aomod in (select modulo from fst111 where dscod = 50)
             and a.cttfir = 'T'
             and b.aomod <> 108             
union                       
           select b.*
                from fsr008 a,fsd010 b,fsr002 c,sng001 s
               where  s.sng001inst=vn_instancia
                 and a.ctnro =s.sng001cta
                 --and c.pepais = vn_pepais
                 --and c.petdoc = vn_petdoc
                 --and c.pendoc = vc_pendoc
                 and a.pepais = c.rppais
                 and a.petdoc = c.rptdoc
                 and a.pendoc = c.rpndoc
                 and a.pgcod = b.pgcod
                 and a.ctnro = b.aocta
                 and b.aomod in (select modulo from fst111 where dscod = 50)
                 and b.aomod <> 108 --créditos pignoraticios  
                 and a.cttfir = 'T'
                 and c.rpccyg = 66 
                 and b.aostat<>99; 

vn_sng001cta number(10);
vn_pepais number(3);
vn_petdoc number(2);
vc_pendoc char(12);
vn_contcredT number(3);
vn_contcredC number(3);
vn_contcredTCG number(3);
vn_contcredCCG number(3);
vl_Ncreditos number(5);
vl_NcreditosCG number(5);
ln_existe number(1);
begin
  begin
  select sng001cta into vn_sng001cta from sng001 where sng001inst = vn_instancia;
  Exception
          when no_data_found then
            vn_sng001cta := 0;
   end;
   begin     
   select pepais,petdoc,pendoc into vn_pepais,vn_petdoc,vc_pendoc from fsr008 where ctnro =vn_sng001cta and TTCOD=1 and Cttfir= 'T' and rownum = 1;
   Exception
     when no_data_found then
     vn_pepais:=0;
     vn_petdoc:=0;
     vc_pendoc:=0;
   end;
  
          --número de créditos del titular y conyuge a excepción de los pignoráticos (prendario)
          vn_contcredT:=0;
          vn_contcredC:=0;
          begin
          select COUNT(b.aocta) INTO vn_contcredT
          from fsr008 a,fsd010 b
           where a.pepais = vn_pepais
             and a.petdoc = vn_petdoc
             and a.pendoc = vc_pendoc
             and a.pgcod = b.pgcod
             and a.ctnro = b.aocta
             and b.aostat<>99--no este cancelada
             and b.aomod in (select modulo from fst111 where dscod = 50)
             and a.cttfir = 'T'
             and b.aomod <> 108;--créditos pignoraticios             
           Exception
                 when no_data_found then
                      vn_contcredT := 0;               
           end;
           Begin
           select COUNT(b.aocta) INTO vn_contcredC              
                from fsr008 a,fsd010 b,fsr002 c
               where c.pepais = vn_pepais
                 and c.petdoc = vn_petdoc
                 and c.pendoc = vc_pendoc
                 and a.pepais = c.rppais
                 and a.petdoc = c.rptdoc
                 and a.pendoc = c.rpndoc
                 and a.pgcod = b.pgcod
                 and a.ctnro = b.aocta
                 and b.aomod in (select modulo from fst111 where dscod = 50)
                 and b.aomod <> 108 --créditos pignoraticios  
                 and a.cttfir = 'T'
                 and c.rpccyg = 66 
                 and b.aostat<>99; 
            Exception
                 when no_data_found then
                      vn_contcredC := 0;               
            end;
          vl_Ncreditos := vn_contcredT + vn_contcredC;
          --número de créditos con garantía no considerada
          vn_contcredTCG:=0;
          vn_contcredCCG:=0;
          for k in creditos loop
            ln_existe:=0;
            if (k.aomod=116) then
               begin
                select 1 into ln_existe 
                from fsr011 
                where (R1COD, R1MOD, R1SUC, R1MDA, R1PAP, R1CTA, R1OPER, R1SBOP, R1TOPE)in
                 (select  f.R2COD, f.R2MOD, f.R2SUC, f.R2MDA, f.R2PAP, f.R2CTA, f.R2OPER, f.R2SBOP, f.R2TOPE from fsr011 f        
                  where f.r1cod  = k.pgcod
                   and f.r1mod  = k.aomod
                   and f.r1suc  = k.aosuc                 
                   and f.r1mda  = k.aomda
                   and f.r1pap  = k.aopap 
                   and f.r1cta  = k.aocta 
                   and f.r1oper = k.aooper
                   and f.r1sbop = k.aosbop
                   and f.r1tope = k.aotope
                   and f.relcod = 46
                   and f.r011co='S')
                   and r2mod = 70
                   and r2tope in (select tp1imp1 from fst198 where tp1cod1=11116 and tp1corr1=100 and tp1corr2=1 and tp1corr3>0)
                   and r011co='S';        
                exception 
                  when others then
                    ln_existe :=0;
                end;
            else
               begin
                select 1 into ln_existe 
                from fsr011 f        
                where f.r1cod  = k.pgcod
                 and f.r1mod  = k.aomod
                 and f.r1suc  = k.aosuc                 
                 and f.r1mda  = k.aomda
                 and f.r1pap  = k.aopap 
                 and f.r1cta  = k.aocta 
                 and f.r1oper = k.aooper
                 and f.r1sbop = k.aosbop
                 and f.r1tope = k.aotope
                 and f.relcod = 50
                 and f.r2mod = 70
                 and f.r2tope in (select tp1imp1 from fst198 where tp1cod1=11116 and tp1corr1=100 and tp1corr2=1 and tp1corr3>0)
                 and f.r011co='S';        
                exception 
                  when others then
                    ln_existe :=0;
                end;
            end if;
            if (ln_existe>0) then
              vn_contcredTCG := vn_contcredTCG+1;
            end if;
           end loop;
            
         /* begin
          select COUNT(b.aocta) INTO vn_contcredTCG
          from fsr008 a,fsd010 b ,fsr011 f        
           where a.pepais = vn_pepais
             and a.petdoc = vn_petdoc
             and a.pendoc = vc_pendoc
             and a.pgcod = b.pgcod
             and a.ctnro = b.aocta
             and b.aostat<>99--no este cancelada
             and b.aomod in (select modulo from fst111 where dscod = 50)
             and a.cttfir = 'T'
             and b.aomod <> 108 --no considera créditos pignoraticios 
             and b.pgcod = f.r1cod
             and b.aomod = f.r1mod
             and b.aosuc = f.r1suc
             and b.aomda = f.r1mda
             and b.aopap = f.r1pap
             and b.aocta = f.r1cta
             and b.aooper = f.r1oper
             and b.aosbop = f.r1sbop
             and b.aotope = f.r1tope
             and f.relcod = 50
             and f.r2mod = 70
             and f.r2tope in (select tp1imp1 from fst198 where tp1cod1=11116 and tp1corr1=100 and tp1corr2=1 and tp1corr3>0)
             and f.r011co='S';            
           Exception
                 when no_data_found then
                      vn_contcredTCG := 0;               
           end;
           Begin
           select COUNT(b.aocta) INTO vn_contcredCCG              
                from fsr008 a,fsd010 b,fsr002 c, fsr011 f
               where c.pepais = vn_pepais
                 and c.petdoc = vn_petdoc
                 and c.pendoc = vc_pendoc
                 and a.pepais = c.rppais
                 and a.petdoc = c.rptdoc
                 and a.pendoc = c.rpndoc
                 and a.pgcod = b.pgcod
                 and a.ctnro = b.aocta
                 and b.aomod in (select modulo from fst111 where dscod = 50)
                 and b.aomod <> 108 --créditos pignoraticios  
                 and a.cttfir = 'T'
                 and c.rpccyg = 66 
                 and b.aostat<>99
                 and b.pgcod = f.r1cod
                 and b.aomod = f.r1mod
                 and b.aosuc = f.r1suc
                 and b.aomda = f.r1mda
                 and b.aopap = f.r1pap
                 and b.aocta = f.r1cta
                 and b.aooper = f.r1oper
                 and b.aosbop = f.r1sbop
                 and b.aotope = f.r1tope
                 and f.relcod = 50
                 and f.r2mod = 70
                 and f.r2tope  in (select tp1imp1 from fst198 where tp1cod1=11116 and tp1corr1=100 and tp1corr2=1 and tp1corr3>0)
                 and f.r011co='S';  
            Exception
                 when no_data_found then
                      vn_contcredCCG := 0;               
            end;
           vl_NcreditosCG := vn_contcredTCG + vn_contcredCCG;*/
           vl_NcreditosCG:= vn_contcredTCG;
           vn_ncreditos := vl_Ncreditos - vl_NcreditosCG;

end sp_contador;


end pq_cr_pcreditos;
/

