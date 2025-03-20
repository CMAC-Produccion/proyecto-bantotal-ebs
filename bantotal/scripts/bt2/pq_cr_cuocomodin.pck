create or replace package PQ_CR_CUOCOMODIN is

Procedure Sp_cr_mora (pn_pai in number,
                      pn_tdo in number,
                      pc_ndo in char,
                      pd_fecpro in date,
                      pc_mor out char);

                   

procedure sp_cr_sobreendeudado(ld_fecha  in date,
                               ln_pepais in number,
                               ln_petdoc in number,
                               ln_pendoc in char,
                               lc_fgsob  out char) ;
                               
Procedure Sp_cr_castigado (pn_pai in number,
                           pn_tdo in number,
                           pc_ndo in char,
                           pd_fecpro in date,
                           lc_castigado2 out char);
                           
Procedure Sp_cr_Castigado_CYG (pn_pai in number,
                               pn_tdo in number,
                               pc_ndo in char,
                               pd_fecpro in date,
                               lc_castigado2 out char
                               );
                               
Procedure Sp_cr_Refinanciado (pn_pai in number,
                              pn_tdo in number,
                              pc_ndo in char,
                              pd_fecpro in date,
                              lc_refinan out char
                              );                                                                                         

end PQ_CR_CUOCOMODIN;
/

create or replace package body PQ_CR_CUOCOMODIN is

Procedure Sp_cr_mora (pn_pai in number,
                      pn_tdo in number,
                      pc_ndo in char,
                      pd_fecpro in date,
                      pc_mor out char) is

cursor creditos is
select a.pgcod,
       a.aomod,
       a.aosuc,
       a.aomda,
       a.aopap,
       a.aocta,
       a.aooper,
       a.aosbop,
       a.aotope
  from fsd010 a,fsr008 b
 where a.pgcod = 1
   and a.aostat <> 99
   and a.aomod in (select modulo from fst111 where dscod = 50)
   and a.pgcod = b.pgcod
   and b.ctnro = a.aocta
   and b.pepais = pn_pai
   and b.petdoc = pn_tdo
   and b.pendoc = pc_ndo;
   
cursor creditos_cyg (cn_pai in number,
                     cn_tdo in number,
                     cc_ndo in char) is
select a.pgcod,
       a.aomod,
       a.aosuc,
       a.aomda,
       a.aopap,
       a.aocta,
       a.aooper,
       a.aosbop,
       a.aotope
  from fsd010 a,fsr008 b
 where a.pgcod = 1
   and a.aostat <> 99
   and a.aomod in (select modulo from fst111 where dscod = 50)
   and a.pgcod = b.pgcod
   and b.ctnro = a.aocta
   and b.pepais = cn_pai
   and b.petdoc = cn_tdo
   and b.pendoc = cc_ndo;
   

ln_dias number(7) := 0;
ld_fecmin date;
ln_paiCyg number(3);
ln_tdoCyg number(3);
ln_ndoCyg char(12);


begin
   for i in creditos loop
   
       begin
         select min(n.ppfpag)
           into ld_fecmin
           from fsd601 n
          where n.pgcod  = i.pgcod
            and n.ppmod  = i.aomod
            and n.ppsuc  = i.aosuc
            and n.ppmda  = i.aomda
            and n.pppap  = i.aopap
            and n.ppcta  = i.aocta
            and n.ppoper = i.aooper
            and n.ppsbop = i.aosbop
            and n.pptope = i.aotope
            and n.d601co = 'S'
            and (n.ppcap+n.ppint)<>0
            and not exists
                     (select ppmod, ppcta,ppoper, pptope,ppfpag
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
       
       
       ln_dias := pd_fecpro - ld_fecmin;
       
       if ln_dias > 0 then 
          exit;
       end if;
     

   end loop;
   
   if ln_dias > 0 then 
      pc_mor := 'S';
      else
             pc_mor := 'N';
   end if;
   
   if pc_mor = 'N' then
      ---verifica conyugue
      begin
           select a.rppais,
                  a.rptdoc,
                  a.rpndoc
             into ln_paiCyg,
                  ln_tdoCyg,
                  ln_ndoCyg
             from fsr002 a
            where a.pepais = pn_pai
              and a.petdoc = pn_tdo
              and a.pendoc = pc_ndo
              and a.rpccyg = 66;
      exception
          when others then null;
      end;
      
      if ln_ndoCyg is not null then
         for j in creditos_cyg (ln_paiCyg,
                                ln_tdoCyg,
                                ln_ndoCyg) loop
             begin
               select min(n.ppfpag)
                 into ld_fecmin
                 from fsd601 n
                where n.pgcod  = j.pgcod
                  and n.ppmod  = j.aomod
                  and n.ppsuc  = j.aosuc
                  and n.ppmda  = j.aomda
                  and n.pppap  = j.aopap
                  and n.ppcta  = j.aocta
                  and n.ppoper = j.aooper
                  and n.ppsbop = j.aosbop
                  and n.pptope = j.aotope
                  and n.d601co = 'S'
                  and (n.ppcap+n.ppint)<>0
                  and not exists
                           (select ppmod, ppcta,ppoper, pptope,ppfpag
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
             
             
             ln_dias := pd_fecpro - ld_fecmin;
             
             if ln_dias > 0 then 
                exit;
             end if;                   
         end loop;
         
         if ln_dias > 0 then 
            pc_mor := 'S';
            else
                   pc_mor := 'N';
         end if;
   
      end if;
   end if;
   
   
end Sp_cr_mora;  

procedure sp_cr_sobreendeudado(ld_fecha  in date,
                               ln_pepais in number,
                               ln_petdoc in number,
                               ln_pendoc in char,
                               lc_fgsob  out char) is

ln_sobreen  number;
ln_paiCyg   number(3);
ln_tdoCyg   number(3);
ln_ndoCyg   char(12);

begin
  lc_fgsob    := 'N';

 

  begin
    begin
      select jaqy490sob
        into ln_sobreen
        from jaqy490s s
       where s.Jaqy490fec <= ld_fecha 
         and s.Jaqy490pai = ln_pepais 
         and s.Jaqy490tdo = ln_petdoc 
         and s.JAQY490NDO = ln_pendoc 
       order by s.jaqy490fec desc;
    
    exception
      when others then
        null;
    end;
  
    if ln_sobreen = 1 then
      lc_fgsob := 'S';
    
    else
        lc_fgsob := 'N';
    
    end if;
    
    if lc_fgsob = 'N' then
       ---verifica conyugue
      begin
           select a.rppais,
                  a.rptdoc,
                  a.rpndoc
             into ln_paiCyg,
                  ln_tdoCyg,
                  ln_ndoCyg
             from fsr002 a
            where a.pepais = ln_pepais
              and a.petdoc = ln_petdoc
              and a.pendoc = ln_pendoc
              and a.rpccyg = 66;
      exception
          when others then null;
      end;
      
      if ln_ndoCyg is not null then
          begin
            select jaqy490sob
              into ln_sobreen
              from jaqy490s s
             where s.Jaqy490fec <= ld_fecha 
               and s.Jaqy490pai = ln_paiCyg
               and s.Jaqy490tdo = ln_tdoCyg
               and s.JAQY490NDO = ln_ndoCyg
             order by s.jaqy490fec desc;
            
          exception
            when others then
              null;
          end;
          
          if ln_sobreen = 1 then
            lc_fgsob := 'S';
          
          else
              lc_fgsob := 'N';
          
          end if;
      end if;
    end if;
  
  end;

  
end sp_cr_sobreendeudado;

/*Procedure Sp_cr_castigado (pn_pai in number,
                           pn_tdo in number,
                           pc_ndo in char,
                           pd_fecpro in date,
                           lc_castigado out char)is
                           
cursor cuentas is
select a.ctnro
  from fsr008 a
 where a.pepais = pn_pai
   and a.petdoc = pn_tdo
   and a.pendoc = pc_ndo; 

cursor creditos (cn_cta in number,
                 cn_estaCan in number) is

select a.pgcod,
       a.aomod,
       a.aosuc,
       a.aomda,
       a.aopap,
       a.aocta,
       a.aooper,
       a.aosbop,
       a.aotope,
       a.aostat,
       'S'

  from fsd010 a
 where a.pgcod = 1
   and a.aocta = cn_cta
   and (a.aomod in (select modulo 
                     from fst111 b
                    where dscod = 50)
                or aomod = 117)
   and a.aomod not in (select aa.tp1nro1 
                         from fst198 aa 
                        where aa.tp1cod   = 1
                          and aa.tp1cod1  = 11114   
                          and aa.tp1corr1 = 1
                          and aa.tp1corr2 = 2)
   and a.aofval <= pd_fecpro
   and aostat = cn_estaCan;
   
ln_estaCan number(9);
ld_fecrec date;
ln_r1mod number(3);
ln_r1suc number(3);
ln_r1mda number(4);
ln_r1pap number(4);
ln_r1cta number(9);
ln_r1oper number(9);
ln_r1sbop number(3);
ln_r1tope number(3);
ln_evento number(10);
ld_FechaRL date;
ln_paiC number(3);
ln_tdoC number(3);
lc_ndoC char(12);
   
begin

       ----*******CASTIGADOS*****----------
      lc_castigado := 'N';
      ld_FechaRL := null;
      --Estado credito castigado
      begin
      select a.tp1nro1
        into ln_estaCan
        from fst198 a 
       where a.tp1cod = 1
         and a.tp1cod1= 11114 
         and Tp1corr1 = 1 
         and Tp1corr2 = 3
         and tp1corr3 = 1;
      exception
         when no_data_found then
              ln_estaCan := null;
      end;
      
      begin
          for i in cuentas loop
              
              for k in creditos (i.ctnro,
                                 ln_estaCan) loop
                  lc_castigado := 'S';
                  begin
                         select a.r1mod,
                                a.r1suc,
                                a.r1mda,
                                a.r1pap,
                                a.r1cta,
                                a.r1oper,
                                a.r1sbop,
                                a.r1tope
                           into ln_r1mod,  
                                ln_r1suc ,
                                ln_r1mda ,
                                ln_r1pap ,
                                ln_r1cta ,
                                ln_r1oper,
                                ln_r1sbop,
                                ln_r1tope                         
                           from fsr011 a
                          where a.r2cod  = k.pgcod
                            and a.r2mod  = k.aomod
                            and a.r2suc  = k.aosuc
                            and a.r2mda  = k.aomda
                            and a.r2pap  = k.aopap
                            and a.r2cta  = k.aocta
                            and a.r2oper = k.aooper
                            and a.r2sbop = k.aosbop
                            and a.r2tope = k.aotope
                            and a.relcod = 52;
                     exception 
                            when no_data_found then
                                 ln_r1mod  := null;
                                 ln_r1suc  := null;
                                 ln_r1mda  := null;
                                 ln_r1pap  := null;
                                 ln_r1cta  := null;
                                 ln_r1oper := null;
                                 ln_r1sbop := null;
                                 ln_r1tope := null;
                     end;
     
                  
                  if ln_r1oper is null then
                     ln_r1mod  := k.aomod;
                     ln_r1suc  := k.aosuc;
                     ln_r1mda  := k.aomda;
                     ln_r1pap  := k.aopap;
                     ln_r1cta  := k.aocta;
                     ln_r1oper := k.aooper;
                     ln_r1sbop := k.aosbop;
                     ln_r1tope := k.aotope;
                  end if;
                  ln_evento := 1100;
                  while ln_evento<=1101 loop
                        begin
                            select max(SNG410FecG)
                              into ld_fecrec
                              from sng410 a
                             Where SNG400Cod  = 1
                               and SNG400Evto = ln_evento
                               and SNG410Mod  = ln_r1mod
                               and SNG410Top  = ln_r1tope
                               and SNG410Cta  = ln_r1cta
                               and SNG410Suc  = ln_r1suc
                               and SNG410Mda  = ln_r1mda
                               and SNG410Pap  = ln_r1pap
                               and SNG410Op   = ln_r1oper
                               and SNG410Sbop = ln_r1sbop
                               and SNG410Its <> 999;
                        exception 
                               when no_data_found then
                                    ld_fecrec := null;
                        end;
                        
                        
                        ln_evento := ln_evento + 1;
                        If ld_fecrec > ld_FechaRL then
                             ld_FechaRL := ld_fecrec;
                       End If;
                  end loop;
              
                 
             end loop;
             If ld_fecrec > ld_FechaRL then
                   ld_FechaRL := ld_fecrec;
             End If;
              
          end loop; 
          
          if lc_castigado = 'N' then
             begin
                 select 'S'
                   into lc_castigado
                   from jaqy164 a
                  where a.jaqy164pais = pn_pai
                    and a.jaqy164tdoc = pn_tdo
                    and a.jaqy164ndoc = pc_ndo
                    and rownum = 1;
             exception
                    when no_data_found then
                         lc_castigado := 'N';
             end;
          end if;
          --Validacion si ha tenido créditos después
          if lc_castigado = 'S' then
             for j in cuentas loop
                 if ld_FechaRL is not null then
                   begin
                     select 'N'
                       into lc_castigado
                       from fsd010 a
                      where a.pgcod = 1
                        and a.aocta = j.ctnro
                        and (a.aomod in (select modulo from fst111 where dscod = 50) 
                                     or aomod = 117)
                        and a.aomod not in (select aa.tp1nro1 
                                              from fst198 aa 
                                             where aa.tp1cod   = 1
                                               and aa.tp1cod1  = 11114   
                                               and aa.tp1corr1 = 1
                                               and aa.tp1corr2 = 2)
                        and a.aofval <= pd_fecpro
                        and aofval > ld_FechaRL
                        and rownum = 1;
                   exception
                        when no_data_found then
                             lc_castigado := 'S';
                   end;
                   
                   else
                   
                     begin
                       select 'N'
                         into lc_castigado
                         from fsd010 a
                        where a.pgcod = 1
                          and a.aocta = j.ctnro
                          and (a.aomod in (select modulo from fst111 where dscod = 50) 
                                       or aomod = 117)
                          and a.aomod not in (select aa.tp1nro1 
                                                from fst198 aa 
                                               where aa.tp1cod   = 1
                                                 and aa.tp1cod1  = 11114   
                                                 and aa.tp1corr1 = 1
                                                 and aa.tp1corr2 = 2)
                          and a.aofval <= pd_fecpro
                          and aofval >= to_date('01/07/2013','dd/mm/yyyy')
                          and rownum = 1;
                     exception
                          when no_data_found then
                               lc_castigado := 'S';
                     end;
                        
                end if;
                If lc_castigado = 'N' then
                    Exit;
                End If;
             end loop;
          end if;
          
      end;
      
      if lc_castigado = 'N' then
      
         begin
              select a.rppais,
                     a.rptdoc,
                     a.rpndoc
                into ln_paiC,
                     ln_tdoC,
                     lc_ndoC
                from fsr002 a
               where a.pepais = pn_pai
                 and a.petdoc = pn_tdo
                 and a.pendoc = pc_ndo
                 and a.rpccyg = 66;
         exception
                 when others then null;
         end;
         
         if lc_ndoC is not null then
            pq_cr_cuocomodin.Sp_cr_Castigado_CYG(ln_paiC,
                                                 ln_tdoC,
                                                 lc_ndoC,
                                                 pd_fecpro,
                                                 lc_castigado );
         end if;
      
      end if;
      
      
end Sp_cr_castigado;*/

Procedure Sp_cr_castigado (pn_pai in number,
                           pn_tdo in number,
                           pc_ndo in char,
                           pd_fecpro in date,
                           lc_castigado2 out char)is
                           
cursor cuentas is
select a.ctnro
  from fsr008 a
 where a.pepais = pn_pai
   and a.petdoc = pn_tdo
   and a.pendoc = pc_ndo; 


ln_paiC number(3);
ln_tdoC number(3);
lc_ndoC char(12);

lc_castAux char(1);
   
begin

       ----*******CASTIGADOS*****----------
      
     
      begin
          for i in cuentas loop
              lc_castAux := 'N';    
          begin
              select 'S'
                into lc_castAux
                from fsd010 a
               where a.pgcod  = 1
                 and a.aocta  = i.ctnro
                 and a.aomod  = 33
                 and a.aofval <= pd_fecpro
                 and rownum   = 1;
                 
          exception
                 when others then
                      lc_castAux := 'N';
          end;    
          if lc_castAux = 'N' then
             begin
                 select 'S'
                   into lc_castAux
                   from jaqy164 a
                  where a.jaqy164pais = pn_pai
                    and a.jaqy164tdoc = pn_tdo
                    and a.jaqy164ndoc = pc_ndo
                    and rownum = 1;
             exception
                    when no_data_found then
                         lc_castAux := 'N';
             end;
          end if;
          
          if lc_castAux = 'S' then
             exit;
          end if;
          
        end loop; 
      end;    
          
      if lc_castAux = 'N' then
      
         begin
              select a.rppais,
                     a.rptdoc,
                     a.rpndoc
                into ln_paiC,
                     ln_tdoC,
                     lc_ndoC
                from fsr002 a
               where a.pepais = pn_pai
                 and a.petdoc = pn_tdo
                 and a.pendoc = pc_ndo
                 and a.rpccyg = 66;
         exception
                 when others then null;
         end;
         
         if lc_ndoC is not null then
         
            pq_cr_cuocomodin.Sp_cr_Castigado_CYG(ln_paiC,
                                                 ln_tdoC,
                                                 lc_ndoC,
                                                 pd_fecpro,
                                                 lc_castAux );
         end if;
      
      end if;
      
      lc_castigado2 := lc_castAux;
end Sp_cr_castigado;
 
Procedure Sp_cr_Castigado_CYG (pn_pai in number,
                               pn_tdo in number,
                               pc_ndo in char,
                               pd_fecpro in date,
                               lc_castigado2 out char
                               )is
cursor cuentas is
select a.ctnro
  from fsr008 a
 where a.pepais = pn_pai
   and a.petdoc = pn_tdo
   and a.pendoc = pc_ndo; 

lc_castAux char(1);
begin

       ----*******CASTIGADOS*****----------
      
     
      
      begin
          for i in cuentas loop
              lc_castAux := 'N';
              begin
                    select 'S'
                      into lc_castAux
                      from fsd010 a
                     where a.pgcod  = 1
                       and a.aocta  = i.ctnro
                       and a.aomod  = 33
                       and a.aofval <= pd_fecpro
                       and rownum   = 1;
              exception
                       when others then 
                            lc_castAux := 'N';
              end;
              if lc_castAux = 'S' then
                 exit;
              end if;
          end loop;
                        
          if lc_castAux = 'N' then
             begin
                 select 'S'
                   into lc_castAux
                   from jaqy164 a
                  where a.jaqy164pais = pn_pai
                    and a.jaqy164tdoc = pn_tdo
                    and a.jaqy164ndoc = pc_ndo
                    and rownum = 1;
             exception
                    when no_data_found then
                         lc_castAux := 'N';
             end;
          end if;
          
         
          
      end;
      lc_castigado2 := lc_castAux;
      
end Sp_cr_Castigado_CYG;


/*Procedure Sp_cr_Castigado_CYG (pn_pai in number,
                               pn_tdo in number,
                               pc_ndo in char,
                               pd_fecpro in date,
                               lc_castigado out char
                               )is
cursor cuentas is
select a.ctnro
  from fsr008 a
 where a.pepais = pn_pai
   and a.petdoc = pn_tdo
   and a.pendoc = pc_ndo; 

cursor creditos (cn_cta in number,
                 cn_estaCan in number) is

select a.pgcod,
       a.aomod,
       a.aosuc,
       a.aomda,
       a.aopap,
       a.aocta,
       a.aooper,
       a.aosbop,
       a.aotope,
       a.aostat,
       'S'

  from fsd010 a
 where a.pgcod = 1
   and a.aocta = cn_cta
   and (a.aomod in (select modulo 
                     from fst111 b
                    where dscod = 50)
                or aomod = 117)
   and a.aomod not in (select aa.tp1nro1 
                         from fst198 aa 
                        where aa.tp1cod   = 1
                          and aa.tp1cod1  = 11114   
                          and aa.tp1corr1 = 1
                          and aa.tp1corr2 = 2)
   and a.aofval <= pd_fecpro
   and aostat = cn_estaCan;
   
ln_estaCan number(9);
ld_fecrec date;
ln_r1mod number(3);
ln_r1suc number(3);
ln_r1mda number(4);
ln_r1pap number(4);
ln_r1cta number(9);
ln_r1oper number(9);
ln_r1sbop number(3);
ln_r1tope number(3);
ln_evento number(10);
ld_FechaRL date;
   
begin

       ----*******CASTIGADOS*****----------
      lc_castigado := 'N';
      ld_FechaRL := null;
      --Estado credito castigado
      begin
      select a.tp1nro1
        into ln_estaCan
        from fst198 a 
       where a.tp1cod = 1
         and a.tp1cod1= 11114 
         and Tp1corr1 = 1 
         and Tp1corr2 = 3
         and tp1corr3 = 1;
      exception
         when no_data_found then
              ln_estaCan := null;
      end;
      
      begin
          for i in cuentas loop
              
              for k in creditos (i.ctnro,
                                 ln_estaCan) loop
                  lc_castigado := 'S';
                  begin
                         select a.r1mod,
                                a.r1suc,
                                a.r1mda,
                                a.r1pap,
                                a.r1cta,
                                a.r1oper,
                                a.r1sbop,
                                a.r1tope
                           into ln_r1mod,  
                                ln_r1suc ,
                                ln_r1mda ,
                                ln_r1pap ,
                                ln_r1cta ,
                                ln_r1oper,
                                ln_r1sbop,
                                ln_r1tope                         
                           from fsr011 a
                          where a.r2cod  = k.pgcod
                            and a.r2mod  = k.aomod
                            and a.r2suc  = k.aosuc
                            and a.r2mda  = k.aomda
                            and a.r2pap  = k.aopap
                            and a.r2cta  = k.aocta
                            and a.r2oper = k.aooper
                            and a.r2sbop = k.aosbop
                            and a.r2tope = k.aotope
                            and a.relcod = 52;
                     exception 
                            when no_data_found then
                                 ln_r1mod  := null;
                                 ln_r1suc  := null;
                                 ln_r1mda  := null;
                                 ln_r1pap  := null;
                                 ln_r1cta  := null;
                                 ln_r1oper := null;
                                 ln_r1sbop := null;
                                 ln_r1tope := null;
                     end;
     
                  
                  if ln_r1oper is null then
                     ln_r1mod  := k.aomod;
                     ln_r1suc  := k.aosuc;
                     ln_r1mda  := k.aomda;
                     ln_r1pap  := k.aopap;
                     ln_r1cta  := k.aocta;
                     ln_r1oper := k.aooper;
                     ln_r1sbop := k.aosbop;
                     ln_r1tope := k.aotope;
                  end if;
                  ln_evento := 1100;
                  while ln_evento<=1101 loop
                        begin
                            select max(SNG410FecG)
                              into ld_fecrec
                              from sng410 a
                             Where SNG400Cod  = 1
                               and SNG400Evto = ln_evento
                               and SNG410Mod  = ln_r1mod
                               and SNG410Top  = ln_r1tope
                               and SNG410Cta  = ln_r1cta
                               and SNG410Suc  = ln_r1suc
                               and SNG410Mda  = ln_r1mda
                               and SNG410Pap  = ln_r1pap
                               and SNG410Op   = ln_r1oper
                               and SNG410Sbop = ln_r1sbop
                               and SNG410Its <> 999;
                        exception 
                               when no_data_found then
                                    ld_fecrec := null;
                        end;
                        
                        
                        ln_evento := ln_evento + 1;
                        If ld_fecrec > ld_FechaRL then
                             ld_FechaRL := ld_fecrec;
                       End If;
                  end loop;
              
                 
             end loop;
             If ld_fecrec > ld_FechaRL then
                   ld_FechaRL := ld_fecrec;
             End If;
              
          end loop; 
          
          if lc_castigado = 'N' then
             begin
                 select 'S'
                   into lc_castigado
                   from jaqy164 a
                  where a.jaqy164pais = pn_pai
                    and a.jaqy164tdoc = pn_tdo
                    and a.jaqy164ndoc = pc_ndo
                    and rownum = 1;
             exception
                    when no_data_found then
                         lc_castigado := 'N';
             end;
          end if;
          --Validacion si ha tenido créditos después
          if lc_castigado = 'S' then
             for j in cuentas loop
                 if ld_FechaRL is not null then
                   begin
                     select 'N'
                       into lc_castigado
                       from fsd010 a
                      where a.pgcod = 1
                        and a.aocta = j.ctnro
                        and (a.aomod in (select modulo from fst111 where dscod = 50) 
                                     or aomod = 117)
                        and a.aomod not in (select aa.tp1nro1 
                                              from fst198 aa 
                                             where aa.tp1cod   = 1
                                               and aa.tp1cod1  = 11114   
                                               and aa.tp1corr1 = 1
                                               and aa.tp1corr2 = 2)
                        and a.aofval <= pd_fecpro
                        and aofval > ld_FechaRL
                        and rownum = 1;
                   exception
                        when no_data_found then
                             lc_castigado := 'S';
                   end;
                   
                   else
                   
                     begin
                       select 'N'
                         into lc_castigado
                         from fsd010 a
                        where a.pgcod = 1
                          and a.aocta = j.ctnro
                          and (a.aomod in (select modulo from fst111 where dscod = 50) 
                                       or aomod = 117)
                          and a.aomod not in (select aa.tp1nro1 
                                                from fst198 aa 
                                               where aa.tp1cod   = 1
                                                 and aa.tp1cod1  = 11114   
                                                 and aa.tp1corr1 = 1
                                                 and aa.tp1corr2 = 2)
                          and a.aofval <= pd_fecpro
                          and aofval >= to_date('01/07/2013','dd/mm/yyyy')
                          and rownum = 1;
                     exception
                          when no_data_found then
                               lc_castigado := 'S';
                     end;
                        
                end if;
                If lc_castigado = 'N' then
                    Exit;
                End If;
             end loop;
          end if;
          
      end;
      
end Sp_cr_Castigado_CYG;*/

Procedure Sp_cr_Refinanciado (pn_pai in number,
                              pn_tdo in number,
                              pc_ndo in char,
                              pd_fecpro in date,
                              lc_refinan out char
                              )is
ln_paiC number(3);
ln_tdoC number(3);                   
lc_ndoC char(12);                   

begin
          --******REFINANCIADO*******------
           begin
              select 'S'
                into lc_refinan
                from fsr008 a, fsd010 b
               where a.pepais = pn_pai
                 and a.petdoc = pn_tdo
                 and a.pendoc = pc_ndo
                 and b.pgcod  = 1
                 and b.aocta  = a.ctnro
                 and b.aostat in (select aa.tp1nro1
                                    from fst198 aa 
                                   where aa.tp1cod   = 1
                                     and aa.tp1cod1  = 11114   
                                     and aa.tp1corr1 = 1
                                     and aa.tp1corr2 = 4)
                 and aofval <= pd_fecpro
                 and rownum = 1;
           exception
                 when no_data_found then
                      lc_refinan := 'N';
           end;
           
           if lc_refinan = 'N' then
              begin
                    select a.rppais,
                           a.rptdoc,
                           a.rpndoc
                      into ln_paiC,
                           ln_tdoC,
                           lc_ndoC
                      from fsr002 a
                     where a.pepais = pn_pai
                       and a.petdoc = pn_tdo
                       and a.pendoc = pc_ndo
                       and a.rpccyg = 66;
               exception
                       when others then null;
               end;
                 
               if lc_ndoC is not null then
                  begin
                      select 'S'
                        into lc_refinan
                        from fsr008 a, fsd010 b
                       where a.pepais = ln_paiC
                         and a.petdoc = ln_tdoC
                         and a.pendoc = lc_ndoC
                         and b.pgcod  = 1
                         and b.aocta  = a.ctnro
                         and b.aostat in (select aa.tp1nro1
                                            from fst198 aa 
                                           where aa.tp1cod   = 1
                                             and aa.tp1cod1  = 11114   
                                             and aa.tp1corr1 = 1
                                             and aa.tp1corr2 = 4)
                         and aofval <= pd_fecpro
                         and rownum = 1;
                   exception
                         when no_data_found then
                              lc_refinan := 'N';
                   end;
               end if;
           end if;
           
end Sp_cr_Refinanciado;

end PQ_CR_CUOCOMODIN;
/

