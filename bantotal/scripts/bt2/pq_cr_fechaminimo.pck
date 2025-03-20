create or replace package pq_cr_fechaminimo is
 -- Author  : KVALENCIA
  -- Created : 19/03/2019 05:28:00 p.m.
  -- Purpose : Calulo de Fecha de inicio valor de un credito
   -- Modificado  : KVALENCIAC
  -- Fecha : 23/03/2023
  -- Modifiación : Modificación del obtención de la fecha.
   -- Modificado  : KVALENCIAC
  -- Fecha : 05/04/2023
  -- Modifiación : Modificación del obtención de la fecha para los casos de refinanciados.
Procedure Sp_fecha (ln_pgc in number,
                    ln_mda in number,
                    ln_pap in number,
                    ln_tope in number,
                    ln_sbop in number,
                    ln_suc in number,
                    ln_mod in number,--23/03/2023 kvalenciac
                    ln_cta in number,ln_ope in number,ln_FechaDesde in date,ld_fecha out date,ln_continua out number);
Procedure Sp_fechaRTE (ln_pgc in number,ln_mda in number,ln_cta in number,ln_ope in number,ln_FechaDesde in date,ld_fecha out date,ln_continua out number);
end pq_cr_fechaminimo;
/

create or replace package body pq_cr_fechaminimo is

Procedure Sp_fecha (ln_pgc in number,
                    ln_mda in number,
                    ln_pap in number, --23/03/2023 kvalenciac
                    ln_tope in number, --23/03/2023 kvalenciac
                    ln_sbop in number, --23/03/2023 kvalenciac
                    ln_suc in number, --23/03/2023 kvalenciac
                    ln_mod in number,--23/03/2023 kvalenciac
                    ln_cta in number, 
                    ln_ope in number,
                    ln_FechaDesde in date,
                    ld_fecha out date,
                    ln_continua out number)is
  ln_pgcod number(3);
  ln_aomod number (3);
  ln_aosuc number(3);
  ln_aomda number(4);
  ln_aopap number(4);
  ln_aocta number(9);
  ln_aooper number(9);
  ln_aosbop number(3);
  ln_aotope number(3);
  ld_aofval date;
  ln_R2cod number(3);
  ln_R2mod number(3);
  ln_R2suc number(3);
  ln_R2mda number(4);
  ln_R2pap number(4);
  ln_R2cta number(9);
  ln_R2oper number(9);
  ln_R2sbop number(3);
  ln_R2tope number(3);
  ln_xllotexto char(60);
  ln_scsdo number(18,2);
  Begin
    Begin
    select f.pgcod,f.scmod,f.scsuc,f.scmda,f.scpap,f.sccta,f.scoper,f.scsbop,f.sctope,f.scfval,f.scsdo
    into 
    ln_pgcod,ln_aomod,ln_aosuc,ln_aomda,ln_aopap,ln_aocta,ln_aooper,ln_aosbop,ln_aotope,ld_aofval,ln_scsdo
    from Fsd011 f
    inner join fst111 t on t.Dscod = 50 and t.modulo=f.scmod and t.modulo not in 120
    Where f.PgCod = ln_pgc
    and f.scmod = ln_mod
    and f.sctope= ln_tope
   -- and ( f.scmod = 200 or f.scmod = 33 or f.sctope=550 )
    and f.scmda = ln_mda
    and f.scpap = ln_pap
    and f.sccta = ln_cta  
    and f.scoper = ln_ope 
    and f.scsbop = ln_sbop
    and f.scsuc = ln_suc
    and sccta not in (999999999)
    --and f.scstat in ( select tp1corr3 from fst198 Where Tp1cod= 1 and Tp1cod1= 10850 and Tp1corr1 = 12 and Tp1corr2 = 1 )
    and (f.scstat<>99);--sea diferente de cancelado o vendido
    exception
      when no_data_found then
        ln_pgcod := 0;
        ln_aomod := 0;
        ln_aosuc := 0;
        ln_aomda := 0;
        ln_aopap := 0;
        ln_aocta := 0;
        ln_aooper := 0;
        ln_aosbop := 0;
        ln_aotope := 0;
        ld_aofval := null;
        ln_scsdo :=0;
   end;
   if ( ln_scsdo<>0 ) then     
     ln_R2cta:=0;
     --inicio kvalenciac 05/04/2023
     --busco si esta refinanciado   esos se considera como su credito original 
     begin
         select R1cod,R1mod,R1suc,R1mda,R1pap,R1cta,R1oper, max(R1sbop),R1tope into 
            ln_R2cod,
            ln_R2mod,
            ln_R2suc, 
            ln_R2mda,
            ln_R2pap,
            ln_R2cta,
            ln_R2oper,
            ln_R2sbop,
            ln_R2tope 
          from FSR011
          where R2cod = ln_pgcod
          and R2mod = ln_aomod 
          and R2suc = ln_aosuc
          and R2mda = ln_aomda 
          and R2pap = ln_aopap 
          and R2cta = ln_aocta  
          and R2oper= ln_aooper 
          and R2sbop= ln_aosbop
          and R2tope= ln_aotope
          and Relcod= 36
          and R011co='S'
          group by R1cod,R1mod,R1suc,R1mda,R1pap,R1cta,R1oper,R1tope;--buscar la clave original si tiene refinanciación
          exception
            when no_data_found then
              ln_R2cta := 0;
     end;
     --busca si clave original si pasó a judicial
     if ( ln_R2cta=0 ) then --si tno tiene refinanciación busco su credito original con la relación de pase a judicial todo relación 52 apunta en r1 la clave original del credito no la anterio
     --fin kvalenciac 05/04/2023
       begin
         select R1cod,R1mod,R1suc,R1mda,R1pap,R1cta,R1oper,R1sbop,R1tope into 
            ln_R2cod,
            ln_R2mod,
            ln_R2suc, 
            ln_R2mda,
            ln_R2pap,
            ln_R2cta,
            ln_R2oper,
            ln_R2sbop,
            ln_R2tope 
          from FSR011
          where R2cod = ln_pgcod
          and R2mod = ln_aomod 
          and R2suc = ln_aosuc
          and R2mda = ln_aomda 
          and R2pap = ln_aopap 
          and R2cta = ln_aocta  
          and R2oper= ln_aooper 
          and R2sbop= ln_aosbop
          and R2tope= ln_aotope
          and Relcod= 52;--buscar la clave original si paso a judicial PJA o castigado
          exception
            when no_data_found then
              ln_R2cta := 0;
     end;
     end if;  -- kvalenciac 05/04/2023
     if ( ln_R2cta>0 ) then
       ln_pgcod := ln_R2cod;
       ln_aomod := ln_R2mod;
       ln_aosuc := ln_R2suc;
       ln_aomda := ln_R2mda;
       ln_aopap := ln_R2pap;
       ln_aocta := ln_R2cta;
       ln_aooper:= ln_R2oper;
       ln_aosbop:= ln_R2sbop;
       ln_aotope:= ln_R2tope;     
     end if;
     ---
     if (ln_aomod=116) then
         ln_R2mod:=0;
         begin
         select R2cod,R2mod,R2suc,R2mda,R2pap,R2cta,R2oper,R2sbop,R2tope into 
            ln_R2cod,
            ln_R2mod,
            ln_R2suc, 
            ln_R2mda,
            ln_R2pap,
            ln_R2cta,
            ln_R2oper,
            ln_R2sbop,
            ln_R2tope 
          from FSR011
          where R1cod = ln_pgcod
          and R1mod = ln_aomod 
          and R1suc = ln_aosuc
          and R1mda = ln_aomda 
          and R1pap = ln_aopap 
          and R1cta = ln_aocta  
          and R1oper= ln_aooper 
          and R1sbop= ln_aosbop
          and R1tope= ln_aotope
          and Relcod= 46;--buscar 117
          exception
            when no_data_found then
              ln_R2mod := 0;
         end;
         if  ln_R2mod = 117 then    
            Begin   
             select  pgcod,aomod,aosuc,aomda,aopap,aocta,aooper,aosbop,aotope,aofval into 
             ln_pgcod,
             ln_aomod,
             ln_aosuc,
             ln_aomda,
             ln_aopap,
             ln_aocta,
             ln_aooper,
             ln_aosbop,
             ln_aotope,
             ld_aofval 
           from fsd010 d
              where pgcod  = ln_r2cod      
              and aomod = ln_r2mod
              and aosuc = ln_r2suc
              and aomda = ln_r2mda
              and aopap = ln_r2pap
              and aocta = ln_r2cta
              and aooper = ln_r2oper
              and aosbop = ln_r2sbop
              and aotope = ln_r2tope;
            exception
              when no_data_found then
                 ld_aofval := ld_aofval;
            end;
          end if;
     end if;
     
     ld_fecha := ld_aofval;    
     ln_continua := 0;
     if ( ld_aofval < ln_FechaDesde ) then
        ln_continua := 1 ;
     else        
          begin
          select  XlloTexto into ln_xllotexto from X054021
           where PgCod    =  ln_pgcod 
           and XlloAomod  =  ln_aomod 
           and XlloAosuc  =  ln_aosuc 
           and XlloAomda  =  ln_aomda 
           and XlloAopap  =  ln_aopap 
           and XlloAocta  =  ln_aocta 
           and XlloAooper =  ln_aooper
           and XlloAosbop =  ln_aosbop
           and XlloAotope =  ln_aotope
           and Xllotxtcod = 250;
           exception
            when no_data_found then
              ln_continua := 1;
           end;
           IF ( ln_xllotexto= 'P' ) then
              ln_continua := 0;  
           ELSE
              ln_continua := 1;
           END IF;        
      END IF;
   ELSE
       ln_continua := 0;  
   END iF;
end Sp_fecha;
Procedure Sp_fechaRTE (ln_pgc in number,ln_mda in number,ln_cta in number,ln_ope in number,ln_FechaDesde in date,ld_fecha out date,ln_continua out number)is
  ln_pgcod number(3);
  ln_aomod number (3);
  ln_aosuc number(3);
  ln_aomda number(4);
  ln_aopap number(4);
  ln_aocta number(9);
  ln_aooper number(9);
  ln_aosbop number(3);
  ln_aotope number(3);
  ld_aofval date;
  ln_R2cod number(3);
  ln_R2mod number(3);
  ln_R2suc number(3);
  ln_R2mda number(4);
  ln_R2pap number(4);
  ln_R2cta number(9);
  ln_R2oper number(9);
  ln_R2sbop number(3);
  ln_R2tope number(3);
  ln_xllotexto char(60);
  Begin
    Begin
    select pgcod,aomod,aosuc,aomda,aopap,aocta,aooper,aosbop,aotope,aofval into 
    ln_pgcod,ln_aomod,ln_aosuc,ln_aomda,ln_aopap,ln_aocta,ln_aooper,ln_aosbop,ln_aotope,ld_aofval 
    from 
    (select pgcod,aomod,aosuc,aomda,aopap,aocta,aooper,aosbop,aotope,aofval from 
    Fsd010 f
    inner join fst111 t on t.Dscod = 50 and t.modulo=f.aomod
    Where f.PgCod = ln_pgc
    and f.Aocta = ln_cta  
    and f.Aooper = ln_ope 
    and f.Aomda = ln_mda
    order by aofval,aosbop)
    where rownum=1;
    exception
      when no_data_found then
        ln_pgcod := 0;
        ln_aomod := 0;
        ln_aosuc := 0;
        ln_aomda := 0;
        ln_aopap := 0;
        ln_aocta := 0;
        ln_aooper := 0;
        ln_aosbop := 0;
        ln_aotope := 0;
        ld_aofval := null;
   end;
   begin
   select R2cod,R2mod,R2suc,R2mda,R2pap,R2cta,R2oper,R2sbop,R2tope into 
      ln_R2cod,
      ln_R2mod,
      ln_R2suc, 
      ln_R2mda,
      ln_R2pap,
      ln_R2cta,
      ln_R2oper,
      ln_R2sbop,
      ln_R2tope 
    from FSR011
    where R1cod = ln_pgcod
    and R1mod = ln_aomod 
    and R1suc = ln_aosuc
    and R1mda = ln_aomda 
    and R1pap = ln_aopap 
    and R1cta = ln_aocta  
    and R1oper= ln_aooper 
    and R1sbop= ln_aosbop
    and R1tope= ln_aotope
    and Relcod= 46;
    exception
      when no_data_found then
        ln_R2mod := 0;
   end;
   if  ln_R2mod = 117 then    
      Begin   
       select  pgcod,aomod,aosuc,aomda,aopap,aocta,aooper,aosbop,aotope,aofval into 
       ln_pgcod,
       ln_aomod,
       ln_aosuc,
       ln_aomda,
       ln_aopap,
       ln_aocta,
       ln_aooper,
       ln_aosbop,
       ln_aotope,
       ld_aofval 
     from fsd010 d
        where pgcod  = ln_r2cod      
        and aomod = ln_r2mod
        and aosuc = ln_r2suc
        and aomda = ln_r2mda
        and aopap = ln_r2pap
        and aocta = ln_r2cta
        and aooper = ln_r2oper
        and aosbop = ln_r2sbop
        and aotope = ln_r2tope;
      exception
        when no_data_found then
           ld_aofval := ld_aofval;
      end;
   end if;
  ld_fecha := ld_aofval;
    
  ln_continua := 0;
  if ( ld_aofval < ln_FechaDesde ) then
    ln_continua := 1 ;
  else
    IF ( ld_aofval >= ln_FechaDesde ) then
      begin
      select  XlloTexto into ln_xllotexto from X054021
       where PgCod    =  ln_pgcod 
       and XlloAomod  =  ln_aomod 
       and XlloAosuc  =  ln_aosuc 
       and XlloAomda  =  ln_aomda 
       and XlloAopap  =  ln_aopap 
       and XlloAocta  =  ln_aocta 
       and XlloAooper =  ln_aooper
       and XlloAosbop =  ln_aosbop
       and XlloAotope =  ln_aotope
       and Xllotxtcod = 250;
       exception
        when no_data_found then
          ln_continua := 1;
       end;
       IF ( ln_xllotexto= 'I' ) then  -- Si es I no debe hacer nada
          ln_continua := 0;  
       End if;
       IF ( ln_xllotexto= 'P' ) then --Si es de penalidad debe devolver 1 para que calule mora segun el coeficiente de los rangos 
          ln_continua := 1;
       END IF;
     END IF;
    END IF;
end Sp_fechaRTE;
end pq_cr_fechaminimo;
/

