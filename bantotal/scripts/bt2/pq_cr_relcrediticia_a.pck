create or replace package PQ_CR_RELCREDITICIA_A is

      -- *****************************************************************
    -- Nombre                     : PQ_CR_RELCREDITICIA_A
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/01/2022
    -- Autor de Creación          : YYAMPI
    -- Uso                        : procesos de calculo de relacion creditica para ampliaciones
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 
    -- ***************************************************************** 
 
  Procedure Sp_cr_ReCalcula(pn_pais     in number,
                            pn_tdo      in number,
                            pc_ndo      in char,
                            pd_fecpro   in date,
                            ln_contador out number);
  Procedure Sp_cr_InsNuevo(pn_pais     in number,
                           pn_tdo      in number,
                           pc_ndo      in char,
                           pd_fecpro   in date,
                           pd_fecini   in date,
                           ln_contador out number);
  Procedure Sp_cr_histNuevo(pn_pai      in number,
                            pn_tdo      in number,
                            pc_ndo      in char,
                            pd_fecini   in date,
                            pd_fecpro   in date,
                            ln_contador out number);

 
                        
    Function Fn_DiaPago(pn_emp in number,
                      pn_mod in number,
                      pn_suc in number,
                      pn_mda in number,
                      pn_pap in number,
                      pn_cta in number,
                      pn_ope in number,
                      pn_sbo in number,
                      pn_top in number,
                      pn_est in number,
                      pd_fec in date) return date;
   
  
                                 
                                            
  end PQ_CR_RELCREDITICIA_A;
/

create or replace package body PQ_CR_RELCREDITICIA_A is

  
  Procedure Sp_cr_ReCalcula(pn_pais     in number,
                            pn_tdo      in number,
                            pc_ndo      in char,
                            pd_fecpro   in date,
                            ln_contador out number) is
      -- *****************************************************************
    -- Nombre                     : Sp_cr_ReCalcula
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/01/2022
    -- Autor de Creación          : YYAMPI
    -- Uso                        : llena los creditos vinculados de un cliente
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         : 
    -- *****************************************************************                          
  
    ld_fecini date;
    ln_vig    number(9);
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
      when others then
        ln_vig := 60;
      
    end;
  
    ld_fecini := add_months(pd_fecpro, -ln_vig);
    delete from jaqz075 a
     where a.pepais = pn_pais
       and a.petdoc = pn_tdo
       and a.pendoc = pc_ndo;
    commit;
    --execute immediate('truncate table jaqz075');
    begin
    
      insert into jaqz075
        (PGCOD,
         AOMOD,
         AOSUC,
         AOMDA,
         AOPAP,
         AOCTA,
         AOOPER,
         AOSBOP,
         AOTOPE,
         AOFVAL,
         AOFVTO,
         AOFE99,
         AOSTAT,
         PEPAIS,
         PETDOC,
         PENDOC)
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
          from (select a.pgcod,
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
                       PQ_CR_RELCREDITICIA_A.Fn_DiaPago(a.PGCOD,
                                                      AOMOD,
                                                      AOSUC,
                                                      AOMDA,
                                                      AOPAP,
                                                      AOCTA,
                                                      AOOPER,
                                                      AOSBOP,
                                                      AOTOPE,
                                                      aostat,
                                                      a.aofe99) aofe99,
                       a.aostat,
                       b.pepais,
                       b.petdoc,
                       b.pendoc,
                       (case
                         when aofe99 = to_date('0001.01.01', 'yyyy.mm.dd') and
                              aostat = 99 and aofval < ld_fecini then
                          'N'
                         else
                          'S'
                       end) flag,
                       Case
                         when aomod = 110 and
                              aotope not in
                              (select a.tp1nro1
                                 from fst198 a
                                where a.tp1cod = 1
                                  and a.tp1cod1 = 10899
                                  and a.tp1corr1 = 5000
                                  and a.tp1corr2 = 1) then
                          'N'
                         else
                          'S'
                       end hipo
                  from fsr008 b, fsd010 a
                 where b.pgcod = 1
                   and b.pepais = pn_pais
                   and b.petdoc = pn_tdo
                   and b.pendoc = pc_ndo
                   and b.cttfir = 'T'
                   and a.pgcod = b.pgcod
                   and a.aocta = b.ctnro
                   and aomod in
                       (select modulo
                          from fst111
                         where dscod = 50
                           and modulo not in (200, 33, 108, 106, 107))
                      
                   and (aofe99 >= ld_fecini or
                       aofe99 = to_date('0001.01.01', 'yyyy.mm.dd')))
         where flag = 'S'
           and hipo = 'S';
    
      commit;
    
    end;
  
    begin
        
    PQ_CR_RELCREDITICIA_A.Sp_cr_InsNuevo(pn_pais,
                                       pn_tdo,
                                       pc_ndo,
                                       pd_fecpro,
                                       ld_fecini,
                                       ln_contador);
    exception when others then 
       ln_contador := 0;
    end;                                   
  
  end Sp_cr_ReCalcula;
-------------------------------------------------------------------------------------------------
  Procedure Sp_cr_InsNuevo(pn_pais     in number,
                           pn_tdo      in number,
                           pc_ndo      in char,
                           pd_fecpro   in date,
                           pd_fecini   in date,
                           ln_contador out number) is
    -- *****************************************************************
    -- Nombre                     : Sp_cr_InsNuevo
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/01/2022
    -- Autor de Creación          : YYAMPI
    -- Uso                        : recorre los creditos vinculados del cliente 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         :                          
    -- ****************************************************************
    cursor creditos is
      select *
        from jaqz075 a
       where a.pepais = pn_pais
         and a.petdoc = pn_tdo
         and a.pendoc = pc_ndo;
  
    --ln_ins number(1);
    --ln_anio number(4);
    --ln_mes number(2);
  begin
  
    Begin
    
      --ln_anio := to_number(to_char(pd_fecpro,'yyyy'));
      --ln_mes := to_number(to_char(pd_fecpro,'mm'));
    
      for i in creditos loop
        ln_contador := null;
        PQ_CR_RELCREDITICIA_A.Sp_cr_histNuevo(i.pepais,
                                            i.petdoc,
                                            i.pendoc,
                                            pd_fecini,
                                            pd_fecpro,
                                            ln_contador);
      
      end loop;
      commit;
    end;
  
  end Sp_cr_InsNuevo;
---------------------------------------------------------------------------------------------------
  Procedure Sp_cr_histNuevo(pn_pai      in number,
                            pn_tdo      in number,
                            pc_ndo      in char,
                            pd_fecini   in date,
                            pd_fecpro   in date,
                            ln_contador out number) is
    -- *****************************************************************
    -- Nombre                     : Sp_cr_histNuevo
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/01/2022
    -- Autor de Creación          : YYAMPI
    -- Uso                        : calcula la relacion creditia por cada credito por cliente 
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         :                          
    -- ****************************************************************                            
  
    cursor creditos is
      select *
        from jaqz075 a
       where a.pepais = pn_pai
         and a.petdoc = pn_tdo
         and a.pendoc = pc_ndo
       order by a.aofval;
  
    --ln_contador number(5);    
    ld_fecantD date; -- puntero de inicio (desembolso)
    ld_fecantC date; -- puntero de fin (cancelacion)
    --ln_aux number(4);
    ln_mesac number(2); --mes actual
    ln_aniac number(4); --ano actual
    ln_mesan number(2); --mes anterior
    ln_anian number(4); --ano anterior
    ln_suma  number(5); --suma de las diferencias en dias
  
    ld_aofval date; --puntero de fecha de alta credito
    ld_aofe99 date; --puntero de fecha de cancelacion
    --ld_dia number(2);
  
    ln_sw      number(1);
    ld_sysdate date; -- puntero de fecha actual
  begin
  
    begin
      ln_contador := 0;
      ld_fecantD  := null;
      ld_fecantC  := to_date('2000.01.01', 'yyyy.mm.dd');
      ld_sysdate  := pd_fecpro; --last_day(pd_fecpro); --
      For i in creditos loop
        ln_sw := 0;
        if i.aofe99 is null and i.aostat = 99 then
          ln_sw := 1;
        end if;
        if ln_sw = 0 then
        
          ln_mesac  := to_number(to_char(i.aofval, 'mm'));
          ln_aniac  := to_number(to_char(i.aofval, 'yyyy'));
          ln_suma   := null;
          ld_aofval := i.aofval;
          ld_aofe99 := i.aofe99; --last_day(i.aofe99);
          
          /*verifica que la fecha de alta no sea menor a la fecha inicial ( 60 meses) */
          if ld_aofval < pd_fecini then
            ld_aofval := pd_fecini;
          end if;
        
          if ld_fecantD is null then
            --en caso de creditos cancelados 
            if i.aostat = 99 then
              --ln_suma := trunc(months_between(ld_aofe99, ld_aofval)) + 1;
              ln_suma := ld_aofe99 - ld_aofval;
              if ln_suma < 0 then
                ln_suma := 0;
              end if;
              ln_contador := ln_contador + ln_suma;
            --  
            else
              --caso de creditos vigentes
              --ln_suma := trunc(months_between(ld_sysdate, ld_aofval)) + 1;
              ln_suma := ld_sysdate - ld_aofval;
              if ln_suma < 0 then
                ln_suma := 0;
              end if;
              ln_contador := ln_contador + ln_suma;
            
            end if;
          
          Else
          
            if ld_aofval = ld_fecantC or
               (ln_mesac = ln_mesan and ln_aniac = ln_anian) then
              if i.aostat = 99 then
                --ln_suma := trunc(months_between(ld_aofe99, ld_aofval));
                ln_suma := ld_aofe99 - ld_aofval;
                if ln_suma < 0 then
                  ln_suma := 0;
                end if;
                ln_contador := ln_contador + ln_suma;
              
              else
                --ln_suma := trunc(months_between(ld_sysdate, ld_aofval));
                ln_suma := ld_sysdate - ld_aofval;
                if ln_suma < 0 then
                  ln_suma := 0;
                end if;
                ln_contador := ln_contador + ln_suma;
              end if;
            
            else
              if ld_aofval < ld_fecantC then
                --ln_aux := trunc(months_between(ld_fecantC,ld_aofval));  
                ld_aofval := ld_fecantC;
                if i.aostat = 99 then
                  --ln_suma := trunc(months_between(ld_aofe99, ld_aofval));
                  ln_suma := ld_aofe99 - ld_aofval;
                  if ln_suma < 0 then
                    ln_suma := 0;
                  end if;
                  /*if ln_aux > ln_suma then
                     ln_suma := 0;
                     ln_aux  := 0;
                  end if;*/
                  ln_contador := ln_contador + ln_suma; -- - ln_aux;
                
                else
                  --ln_suma := trunc(months_between(ld_sysdate, ld_aofval));
                  ln_suma := ld_sysdate - ld_aofval;
                  if ln_suma < 0 then
                    ln_suma := 0;
                  end if;
                  /*if ln_aux > ln_suma then
                     ln_suma := 0;
                     ln_aux  := 0;
                  end if; */
                  ln_contador := ln_contador + ln_suma; -- - ln_aux;
                end if;
              
              end if;
            
              if ld_aofval > ld_fecantC then
              
                if i.aostat = 99 then
                  --ln_suma := trunc(months_between(ld_aofe99, ld_aofval)) + 1;
                  ln_suma := ld_aofe99 - ld_aofval;
                  if ln_suma < 0 then
                    ln_suma := 0;
                  end if;
                  ln_contador := ln_contador + ln_suma;
                
                else
                  --ln_suma := trunc(months_between(ld_sysdate, ld_aofval)) + 1;
                  ln_suma := ld_sysdate - ld_aofval;
                  if ln_suma < 0 then
                    ln_suma := 0;
                  end if;
                  ln_contador := ln_contador + ln_suma;
                end if;
              
              end if;
            
            end if;
          
          end if;
        
          if i.aofe99 = to_date('0001.01.01', 'yyyy.mm.dd') then
            if ld_fecantC > i.aofval then
              ld_aofval := ld_fecantC;
            end if;
            ld_fecantC := pd_fecpro; --trunc(sysdate); --cambio por fecha de consulta
          end if;
        
          if i.aofe99 > ld_fecantC then
            --ld_fecantD := ld_aofval;
            ld_fecantC := i.aofe99;
          
          end if;
          ld_fecantD := ld_aofval;
        
          ln_mesan := to_number(to_char(ld_fecantC, 'mm'));
          ln_anian := to_number(to_char(ld_fecantC, 'yyyy'));
        
        end if;
      end loop;
    
    end;
    /*
    
    begin
     ln_contador := 0;  
     ld_fecantD := null;
     ld_fecantC := to_date('2000.01.01','yyyy.mm.dd');
     
     For i in creditos loop
         ln_mesac := to_number(to_char(i.jaqz075fva,'mm'));
         ln_aniac := to_number(to_char(i.jaqz075fva,'yyyy'));
         ln_suma := null;
         ld_aofval := i.jaqz075fva;
         ld_aofe99 := last_day(i.jaqz075f99);
         
         if ld_fecantD is null then
               if i.jaqz075est = 99 then
                  ln_suma := trunc(months_between(ld_aofe99,ld_aofval))+1;
                  if ln_suma <0 then 
                     ln_suma := 0;
                  end if;
                  ln_contador := ln_contador + ln_suma;
                  else 
                      ln_suma := trunc(months_between(trunc(sysdate),ld_aofval))+1;
                      if ln_suma <0 then 
                         ln_suma := 0;
                      end if;
                      ln_contador := ln_contador + ln_suma;
                  
               end if;
               
               Else
                    
                   if ld_aofval = ld_fecantC or (ln_mesac = ln_mesan and ln_aniac = ln_anian) then
                      if i.jaqz075est = 99 then
                           ln_suma := trunc(months_between(ld_aofe99,ld_aofval));
                            if ln_suma <0 then 
                               ln_suma := 0;
                            end if;       
                           ln_contador := ln_contador + ln_suma;
                           
                           else
                             ln_suma := trunc(months_between(trunc(sysdate),
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
                              if i.jaqz075est = 99 then
                                   ln_suma := trunc(months_between(ld_aofe99,ld_aofval));
                                    if ln_suma <0 then 
                                       ln_suma := 0;
                                    end if;  
                                
                                   ln_contador := ln_contador + ln_suma;-- - ln_aux;
                                   
                                   else
                                     ln_suma := trunc(months_between(trunc(sysdate),ld_aofval));
                                      if ln_suma <0 then 
                                         ln_suma := 0;
                                      end if;        
                                     
                                     ln_contador := ln_contador + ln_suma;-- - ln_aux;
                               end if;
                                   
                           
                           
                           end if;
                           
                           if ld_aofval > ld_fecantC then
                              
                              if i.jaqz075est = 99 then
                                   ln_suma := trunc(months_between(ld_aofe99,ld_aofval))+1;
                                    if ln_suma <0 then 
                                       ln_suma := 0;
                                    end if;  
                                   ln_contador := ln_contador + ln_suma;
                                   
                                   else
                                     ln_suma := trunc(months_between(trunc(sysdate),ld_aofval))+1;
                                      if ln_suma <0 then 
                                         ln_suma := 0;
                                      end if;  
                                     ln_contador := ln_contador + ln_suma;
                               end if;
                                   
                           
                           
                           end if;
                       
                   
                   end if;
               
         end if;
         
         if i.jaqz075f99 = to_date('0001.01.01','yyyy.mm.dd') then
            if ld_fecantC > i.jaqz075fva then
               ld_aofval := ld_fecantC;
            end if;
            ld_fecantC := trunc(sysdate);
         end if;
         
         if i.jaqz075f99 > ld_fecantC then
                      ld_fecantD := ld_aofval;
                      ld_fecantC := i.jaqz075f99;
         
         end if;
         
         
         
         
         
         ln_mesan := to_number(to_char(ld_fecantC,'mm'));
         ln_anian := to_number(to_char(ld_fecantC,'yyyy'));
     end loop;
     
    
    
    end;  */
  exception when others then 
    ln_contador := 0;
    
  end Sp_cr_histNuevo;
------------------------------------------------------------------------------------------------
  
  Function Fn_DiaPago(pn_emp in number,
                      pn_mod in number,
                      pn_suc in number,
                      pn_mda in number,
                      pn_pap in number,
                      pn_cta in number,
                      pn_ope in number,
                      pn_sbo in number,
                      pn_top in number,
                      pn_est in number,
                      pd_fec in date) return date is
    
    -- *****************************************************************
    -- Nombre                     : Fn_DiaPago
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 20/01/2022
    -- Autor de Creación          : YYAMPI
    -- Uso                        : calcula la maxima fecha de pago de un credito
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha Modificacion         :                          
    -- ****************************************************************   
                      
    ld_fecpag date;
  
  begin
  
    begin
      if pn_est = 99 then
        if pd_fec = to_date('01.01.0001', 'dd.mm.yyyy') or pd_fec is null then
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
               and (a.pp1cap + a.pp1int) <> 0
               and a.pp1stat = 'T';
          exception
            when no_data_found then
              ld_fecpag := to_date('01.01.0001', 'dd.mm.yyyy');
            
          end;
        else
          ld_fecpag := pd_fec;
        end if;
      
      else
        ld_fecpag := to_date('01.01.0001', 'dd.mm.yyyy');
      end if;
      /*
      if pn_est = 0 then
         ld_fecpag := to_date('01.01.0001','dd.mm.yyyy');
         else
              if pd_fec = to_date('01.01.0001','dd.mm.yyyy') or  then
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
                         and a.pp1stat = 'T';
                 exception 
                         when no_data_found then
                              ld_fecpag := to_date('01.01.0001','dd.mm.yyyy'); 
      
                 end;
                 else
                     ld_fecpag := pd_fec;
              end if;        
      end if;*/
    end;
    return ld_fecpag;
  end Fn_DiaPago;
-------------------------------------------------------------------------------------------


end PQ_CR_RELCREDITICIA_A;
/

