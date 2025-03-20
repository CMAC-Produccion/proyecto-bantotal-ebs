create or replace package PQ_OP_ASIENTOS_CREDITOS is
 
    -- *****************************************************************
    -- Nombre                     : ASIENTOS - MOVIMIENTOS FSD015 PARA CARGA TABLAS ANTIFRAUDES -  MPLUS 
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2014.10.24
    -- Autor de Creación          : DCASTRO 
    -- Uso                        : OBTENER MOVIMIENTOS PARA ACTUALIZACION REPORTE MORA
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 
    -- Autor de la Modificación   : 
    -- Descripción de Modificación: 
    -- *****************************************************************
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_op_fsd016(  pn_cor in number, --numero correlativo
                           pn_pgcod in number, --pgcod
                           pn_hcmod in number, --hcmod
                           pn_hsucor in number, --hsucor
                           pn_htran in number, --htran
                           pn_hnrel in number, --hnrel         
                           pd_fecpro in date, -- fecha transaccion
                           pc_uing in varchar2, --usuario ingreso
                           pc_hora in varchar2, --hora
                           pc_cont in varchar2,  --estado contable 
                           pn_corr in number--, --itcorr - (99-extornado)
                            );
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
end PQ_OP_ASIENTOS_CREDITOS;
/

create or replace package body PQ_OP_ASIENTOS_CREDITOS is
    -- *****************************************************************
    -- Nombre                     : PQ_OP_ASIENTOS_CREDITOS
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Créditos - Activas
    -- Versión                    : 1.0
    -- Fecha de Creación          : 2014.10.30
    -- Autor de Creación          : DCASTRO
    -- Uso                        : CARGA DATOS OPERACIONES CREDITOS - FSD015-JAQL980A-JAQL980-FSD016
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 2014.11.10
    -- Autor de la Modificación   : DCASTRO
    -- Descripción de Modificación: Se agrego calculo para dias de atraso
    --                              2014.11.12 DCASTRO - Se modifico para obtener dias de atraso y montos pagados fsd602   
    --                              2014.11.19 DCASTRO - Se agrego excepcion a calculo de dias de atraso.
    --                              2014.11.20 DCASTRO - Se agrego variable lc_tippag para determinar pago total o parcial.
    --                              2014.12.09 DCASTRO - Se agrego transacciones pago fecha valor, prendario, ampliaciones.
    --                              2014.12.19 DCASTRO - Se agrego transacciones seguro.    
    --                              2015.03.05 DCASTRO - Se comento eliminacion en tabla JAQL964, solo actualiza saldos a 0.
    --                              2015.05.14 DCASTRO - Se agrego calculo para extornos.
    -- *****************************************************************
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 procedure sp_op_fsd016(  pn_cor in number, --numero correlativo
                           pn_pgcod in number, --pgcod
                           pn_hcmod in number, --hcmod
                           pn_hsucor in number, --hsucor
                           pn_htran in number, --htran
                           pn_hnrel in number, --hnrel         
                           pd_fecpro in date, -- fecha transaccion
                           pc_uing in varchar2, --usuario ingreso
                           pc_hora in varchar2, --hora
                           pc_cont in varchar2,  --estado contable 
                           pn_corr in number --itcorr - (99-extornado)
                           
                            ) is
   
 
 lc_cancelado char(1);
 ln_modulo  fsd010.aomod%type;
 ln_ctnro   fsd010.aocta%type;
 ln_itoper  fsd010.aooper%type;
 ln_moneda  fsd010.aomda%type;
 ln_papel   fsd010.aopap%type;
 ln_ittope  fsd010.aotope%type;
 ln_itsucd  fsd010.aosuc%type;
 ln_itsubo  fsd010.aosbop%type;
 sql_stmt   varchar2(1000);
 ln_capital jaql964.jaql964cuo%type := 0;--number :=0;
 ln_interes jaql964.jaql964int%type := 0;--number :=0;
 ln_mora    jaql964.jaql964mor%type := 0;--number :=0;
 ln_totpago jaql964.jaql964mtd%type := 0; 
 ln_tipcam  number :=0;
 ln_totgas  jaql964.jaql964gas%type := 0; 
 ln_dias number;
 lc_Estado  char(1);
 ln_int_comp_extra number :=0; 
 ln_seguros number :=0; 
 ln_rub_obli number :=0; 
 ln_gastos number :=0;
 ln_capitalmn number :=0;
 ld_fecpag date;
                   
 ln_jaql964sao jaql964.jaql964sao%type := 0;
 ln_jaql964sac jaql964.jaql964sac%type := 0; 
 ln_jaql964cuo jaql964.jaql964cuo%type := 0;
 ln_jaql964int jaql964.jaql964int%type := 0;
 ln_jaql964mor jaql964.jaql964mor%type := 0;
 ln_jaql964gas jaql964.jaql964gas%type := 0; 
 ln_jaql964mtd jaql964.jaql964mtd%type := 0;
 ln_jaql964dia jaql964.jaql964dia%type := 0;
  
 p_c_coderr char(4);
 p_c_msgerr char(200);
 lc_tippag char(1); 
 ln_dia_alerta number; --2015.05.20
 lc_FlgCanc char(1); -----07082015
 ln_d_alerta number; -----07082015
 
 begin
    --FSD016
   if pn_hcmod = 30 and pn_htran = 360 then
     begin     
       select distinct f.modulo, f.ctnro, f.itoper, f.moneda, f.papel, f.ittope, f.itsucd, f.itsubo
         into ln_modulo, ln_ctnro, ln_itoper, ln_moneda, ln_papel, ln_ittope, ln_itsucd, ln_itsubo
         from fsd016 f      
        where f.PGCOD =  pn_pgcod
          and f.ITSUC =  pn_hsucor
          and f.ITMOD =  pn_hcmod
          and f.ITTRAN = pn_htran
          and f.ITNREL = pn_hnrel
          and f.ctnro <> 0
          and f.itoper <> 0
          and f.itimp1 <> 0
          and f.modulo < 400
          and f.itord = 50
          and f.modulo in (select modulo from fst111 where dscod = 50);   
     exception when no_data_found then      
        ln_ctnro := null;
     end;         
    
   
   else
    
      begin 
         select distinct f.modulo, f.ctnro, f.itoper, f.moneda, f.papel, f.ittope, f.itsucd, f.itsubo
           into ln_modulo, ln_ctnro, ln_itoper, ln_moneda, ln_papel, ln_ittope, ln_itsucd, ln_itsubo 
           from fsd016 f      
          where f.PGCOD =  pn_pgcod
            and f.ITSUC =  pn_hsucor
            and f.ITMOD =  pn_hcmod
            and f.ITTRAN = pn_htran
            and f.ITNREL = pn_hnrel
            and f.ctnro <> 0
            and f.itoper <> 0
            and f.itimp1 <> 0
            and f.modulo < 400
            and f.modulo in (select modulo from fst111 where dscod = 50);
      exception 
         when no_data_found then      
            --ln_ctnro := null;
            begin  --cuando no existe capital pagado
               select distinct f.modulo, f.ctnro, f.itoper, f.moneda, f.papel, f.ittope, f.itsucd, f.itsubo
                         into ln_modulo, ln_ctnro, ln_itoper, ln_moneda, ln_papel, ln_ittope, ln_itsucd, ln_itsubo 
                         from fsd016 f      
                        where f.PGCOD =  pn_pgcod
                          and f.ITSUC =  pn_hsucor
                          and f.ITMOD =  pn_hcmod
                          and f.ITTRAN = pn_htran
                          and f.ITNREL = pn_hnrel
                          and f.ctnro <> 0
                          and f.itoper <> 0
                          and f.itimp1 = 0
                          and f.modulo in (select modulo from fst111 where dscod = 50);
              exception when no_data_found then 
                ln_ctnro := null;
              end;
         when too_many_rows then  
           begin     
             select distinct f.modulo, f.ctnro, f.itoper, f.moneda, f.papel, f.ittope, f.itsucd, f.itsubo
               into ln_modulo, ln_ctnro, ln_itoper, ln_moneda, ln_papel, ln_ittope, ln_itsucd, ln_itsubo
               from fsd016 f      
              where f.PGCOD =  pn_pgcod
                and f.ITSUC =  pn_hsucor
                and f.ITMOD =  pn_hcmod
                and f.ITTRAN = pn_htran
                and f.ITNREL = pn_hnrel
                and f.ctnro <> 0
                and f.itoper <> 0
                and f.itimp1 <> 0
                and f.modulo < 400
                and f.itord = 10
                and f.modulo in (select modulo from fst111 where dscod = 50);   
           exception when no_data_found then      
                     ln_ctnro := null;
           end;         
       end; 
   
   end if;   
    
   if ln_ctnro is not null then
       --determinar si credito fue cancelado  - Eliminar de listado 
       begin
         select  'S'
           into lc_cancelado
          from fsd010 f
         where f.pgcod = pn_pgcod
           and f.aomod = ln_modulo
           and f.aomda = ln_moneda
           and f.aopap = ln_papel
           and f.aocta = ln_ctnro
           and f.aooper = ln_itoper
           and f.aosbop = ln_itsubo
           and f.aotope = ln_ittope
           and f.aofe99 = pd_fecpro
           and f.aostat = 99;
       exception when no_data_found then
           lc_cancelado := 'N';
        when others then
           lc_cancelado := 'N';   
       end;    
      
   --------------------------07082015 -- modificacion cancelacion de creditos
     begin
         
     select jaql964sao,jaql964sac,jaql964cuo,jaql964int,jaql964mor,jaql964gas,jaql964mtd, jaql964dia
     into ln_jaql964sao, ln_jaql964sac, ln_jaql964cuo, ln_jaql964int, ln_jaql964mor, ln_jaql964gas, ln_jaql964mtd, ln_jaql964dia
     from jaql964 j
            where j.jaql964cta = ln_ctnro
              and j.jaql964ope = ln_itoper
              and j.jaql964mod = ln_modulo
              and j.jaql964mda = ln_moneda
              and j.jaql964sob = ln_itsubo
              and j.jaql964top = ln_ittope;
      exception when others then
           ln_jaql964sao := 0; 
           ln_jaql964sac := 0;            
      end;   
    --------------------------07082015 -- modificacion cancelacion de creditos  
       if lc_cancelado = 'S' then
       
          --eliminar registro
          /* 2015.03.05
          sql_stmt := 'delete from JAQL964 where jaql964cta = :1 and jaql964ope = :2 and jaql964mod = :3 and jaql964mda = :4 and jaql964sob = :5 and jaql964top = :6';
          EXECUTE IMMEDIATE sql_stmt USING ln_ctnro, ln_itoper, ln_modulo, ln_moneda, ln_itsubo, ln_ittope;
          --commit;
          */
          lc_Estado := 'E';
          
            -- 2015.03.05 actualizar con etado cancelado
            begin    
              --lc_FlgCanc := 'C';      
              update jaql964 j  
                 set j.jaql964num = 1,
                     j.jaql964dia = 0,-------
                     j.jaql964sao = 0,
                     j.jaql964sac = 0,
                     j.jaql964cuo = 0,
                     j.jaql964int = 0,
                     j.jaql964mor = 0,
                     j.jaql964gas = 0,
                     j.jaql964mtd = 0
                     
               where  j.jaql964cta = ln_ctnro
                  and j.jaql964ope = ln_itoper
                  and j.jaql964mod = ln_modulo
                  and j.jaql964mda = ln_moneda
                  and j.jaql964sob = ln_itsubo
                  and j.jaql964top = ln_ittope; 
            end; 
            --
            ln_dia_alerta := ln_jaql964dia; --2015.08.10 Obtener dias de Atraso de Tabla de Creditos
       
       else
       
           If ln_modulo not in (200,33) Then 
             --si no esta cancelado
             
             --2015.05 Si Ordinal es Extornado
             if pn_corr = 99 then
                begin
                  select SUM(PP1CAP), SUM(PP1INT) , SUM(PP1INTM)
                    into ln_capital, ln_interes, ln_mora
                    from fsd602 f
                   where f.d602cd = pn_pgcod
                     and f.d602mo = pn_hcmod
                     and f.d602su = pn_hsucor
                     and f.d602tr = pn_htran
                     and f.d602re = pn_hnrel
                     and f.d602fc = pd_fecpro
                     and f.d602or = 10 --actualizar con ordinal a utilizar de guia proceso
                     and f.d602co = 'E';
                exception when no_Data_found then
                    ln_capital := 0;
                    ln_interes := 0;
                    ln_mora    := 0;      
                end;                       
             
             else
             --2015.05 Si Ordinal es Vigente
                begin
                  select SUM(PP1CAP), SUM(PP1INT) , SUM(PP1INTM)
                    into ln_capital, ln_interes, ln_mora
                    from fsd602 f
                   where f.d602cd = pn_pgcod
                     and f.d602mo = pn_hcmod
                     and f.d602su = pn_hsucor
                     and f.d602tr = pn_htran
                     and f.d602re = pn_hnrel
                     and f.d602fc = pd_fecpro
                     and f.d602or = 10 --actualizar con ordinal a utilizar de guia proceso
                     and f.d602co = 'S';
                exception when no_Data_found then
                    ln_capital := 0;
                    ln_interes := 0;
                    ln_mora    := 0;      
                end;          
             end if; --2015.05   
           else
               begin
                 select scsdo
                   into ln_capital
                  from fsd011 f
                 where f.pgcod = pn_pgcod
                   and f.scmod = ln_modulo
                   and f.scmda = ln_moneda
                   and f.scpap = ln_papel
                   and f.sccta = ln_ctnro
                   and f.scoper = ln_itoper
                   and f.scsbop = ln_itsubo
                   and f.sctope = ln_ittope;
               exception 
                  when no_data_found then
                   ln_capital := 0;
                  when others then 
                   ln_capital := 0;
               end;    
           
           end if; 
         ----
         ln_capital := nvl(ln_capital,0);
         ln_interes := nvl(ln_interes,0);
         ln_mora := nvl(ln_mora,0);
         
         -------
         begin
           select sum(itimp1)
             into ln_seguros
           from fsd016 f      
          where f.PGCOD =  pn_pgcod
            and f.ITSUC =  pn_hsucor
            and f.ITMOD =  pn_hcmod
            and f.ITTRAN = pn_htran
            and f.ITNREL = pn_hnrel
            and f.itord in (17,18,40,41,42,43);
          exception when no_data_found then
             ln_seguros := 0;         
          end;  
          -----
         
         --ln_rub_obli := nvl(ln_rub_obli,0);
         --ln_gastos := nvl(ln_gastos,0);
         ---
               
          --obtener dias de atraso
          If ln_modulo not in (200,33) Then 

        --     ln_dias := pd_fecpro - v_fecven; --obtener fecha vencimiento
          --Else 
            
            begin
                select distinct a.Ppfpag
                   into ld_fecpag                
                  from fsd602 a
                 where a.Pgcod = pn_pgcod
                         and a.Ppmod = ln_modulo
                         and a.Ppsuc = ln_itsucd
                         and a.Ppmda = ln_moneda
                         and a.Pppap = ln_papel
                         and a.Ppcta = ln_ctnro
                         and a.Ppoper = ln_itoper
                         and a.Ppsbop = ln_itsubo
                         and a.Pptope = ln_ittope
                         and a.d602co = 'S'
                         and a.pp1stat = 'T'
                         and a.Ppfpag in (select max(d.Ppfpag)
                                            from fsd602 d
                                           where d.Pgcod = pn_pgcod
                                             and d.Ppmod = ln_modulo
                                             and d.Ppsuc = ln_itsucd
                                             and d.Ppmda = ln_moneda
                                             and d.Pppap = ln_papel
                                             and d.Ppcta = ln_ctnro
                                             and d.Ppoper = ln_itoper
                                             and d.Ppsbop = ln_itsubo
                                             and d.Pptope = ln_ittope
                                             and d.d602co = 'S');
                                        
                 lc_tippag := 'T';                            
            exception 
               when no_data_found then
                    begin
                      select distinct a.Ppfpag
                       into ld_fecpag
                        from fsd602 a
                       where a.Pgcod = pn_pgcod
                               and a.Ppmod = ln_modulo
                               and a.Ppsuc = ln_itsucd
                               and a.Ppmda = ln_moneda
                               and a.Pppap = ln_papel
                               and a.Ppcta = ln_ctnro
                               and a.Ppoper = ln_itoper
                               and a.Ppsbop = ln_itsubo
                               and a.Pptope = ln_ittope
                               and a.d602co = 'S'
                               and a.pp1stat = 'P'
                               and a.Ppfpag in (select 
                                                 max(d.Ppfpag)
                                                  from fsd602 d
                                                 where d.Pgcod = pn_pgcod
                                                   and d.Ppmod = ln_modulo
                                                   and d.Ppsuc = ln_itsucd
                                                   and d.Ppmda = ln_moneda
                                                   and d.Pppap = ln_papel
                                                   and d.Ppcta = ln_ctnro
                                                   and d.Ppoper = ln_itoper
                                                   and d.Ppsbop = ln_itsubo
                                                   and d.Pptope = ln_ittope
                                                   and d.d602co = 'S');
                       lc_tippag := 'P';                            
                    exception 
                      when no_data_found then
                          ld_fecpag := null;
                      when others then
                          ld_fecpag := null; 
                    end; 
               when others then
                    ld_fecpag := null;                                      
            end;
            --------
            if ld_fecpag is not null then
               ln_dias := pd_fecpro - ld_fecpag;
               if lc_tippag = 'T' then

                 if ln_dias>30 then
                   ln_dias := ln_dias - 30;
                 else  
                   ln_dias := 0;
                 end if; 

               end if; 
            end if;              
         End IF;
         --fin dias atraso
          
          if ln_moneda <> 0 then
             --obtener tipo de cambio, convertir Saldo Capital pagado a SOLES y ACTUALIZAR JAQL964SAC
             begin
               select cotcbi
                into ln_tipcam
                from fsh005 
               where moneda = 101        
                 and cofdes = (select max(cofdes) from fsh005 where cofdes <= pd_fecpro );
             exception when no_data_found then
                ln_tipcam := 0;  
              when others then            
                ln_tipcam := 0;
             end;
                 
             ln_capitalmn := round(ln_capital  * ln_tipcam,2);
          else
             ln_capitalmn   := ln_capital;
          end if;  
          

          -------------------------------
          ---calcular dias de atraso
          ------------------------------
          ln_totpago := nvl(ln_capital,0) + nvl(ln_interes,0) + nvl(ln_mora,0) + nvl(ln_seguros,0) /*+ ln_rub_obli + ln_gastos*/;
          ln_totgas  := nvl(ln_seguros,0) /*+ ln_rub_obli + ln_gastos*/;
         
         
/*          begin
         
             select jaql964sao,jaql964sac,jaql964cuo,jaql964int,jaql964mor,jaql964gas,jaql964mtd, jaql964dia
             into ln_jaql964sao, ln_jaql964sac, ln_jaql964cuo, ln_jaql964int, ln_jaql964mor, ln_jaql964gas, ln_jaql964mtd, ln_jaql964dia
             from jaql964 j
                    where j.jaql964cta = ln_ctnro
                      and j.jaql964ope = ln_itoper
                      and j.jaql964mod = ln_modulo
                      and j.jaql964mda = ln_moneda
                      and j.jaql964sob = ln_itsubo
                      and j.jaql964top = ln_ittope;
          exception when others then
               ln_jaql964sao := 0; 
               ln_jaql964sac := 0;            
          end;*/
         
          If ln_modulo in (200,33) Then 
             ln_jaql964sao := 0;
             ln_jaql964sac := 0;
          end if;
          
          
          ln_dia_alerta := ln_jaql964dia; --2015.05.20 Obtener dias de Atraso de Tabla de Creditos
          
          if pn_corr = 0 then --2015.05
          
            ln_jaql964sao := NVL(ln_jaql964sao + ln_capital,0);
            ln_jaql964sac := NVL(ln_jaql964sac + ln_capitalmn,0);
          
            ln_jaql964cuo := NVL(ln_jaql964cuo - ln_capital,0);
            ln_jaql964int := NVL(ln_jaql964int - ln_interes,0);
            ln_jaql964mor := NVL(ln_jaql964mor - ln_mora,0);
            ln_jaql964gas := NVL(ln_jaql964gas - ln_totgas,0);
            ln_jaql964mtd := NVL(ln_jaql964mtd - ln_totpago,0);
          else
          
            ln_jaql964sao := NVL(ln_jaql964sao - ln_capital,0);
            ln_jaql964sac := NVL(ln_jaql964sac - ln_capitalmn,0);
          
            ln_jaql964cuo := NVL(ln_jaql964cuo + ln_capital,0);
            ln_jaql964int := NVL(ln_jaql964int + ln_interes,0);
            ln_jaql964mor := NVL(ln_jaql964mor + ln_mora,0);
            ln_jaql964gas := NVL(ln_jaql964gas + ln_totgas,0);
            ln_jaql964mtd := NVL(ln_jaql964mtd + ln_totpago,0);
          
          end if; --2015.05
            
          ln_jaql964dia := nvl(ln_dias, ln_jaql964dia );
         
          if ln_jaql964cuo < 0 then ln_jaql964cuo := 0; end if;
          if ln_jaql964int < 0 then ln_jaql964int := 0; end if;
          if ln_jaql964mor < 0 then ln_jaql964mor := 0; end if;
          if ln_jaql964gas < 0 then ln_jaql964gas := 0; end if;
          
          --actualizar informacion jaql964
           begin  
             /* If lc_Estado = 'E' then          
              update jaql964 j
                 set j.jaql964num = 1,
                     --j.jaql964dia = ln_jaql964dia,
                     j.jaql964dia = 0,
                     j.jaql964sao = ln_jaql964sao,
                     j.jaql964sac = ln_jaql964sac,
                     j.jaql964cuo = ln_jaql964cuo,
                     j.jaql964int = ln_jaql964int,
                     j.jaql964mor = ln_jaql964mor,
                     j.jaql964gas = ln_jaql964gas,
                     j.jaql964mtd = ln_jaql964mtd
                     
               where  j.jaql964cta = ln_ctnro
                  and j.jaql964ope = ln_itoper
                  and j.jaql964mod = ln_modulo
                  and j.jaql964mda = ln_moneda
                  and j.jaql964sob = ln_itsubo
                  and j.jaql964top = ln_ittope; 
              Else*/
                  update jaql964 j
                   set j.jaql964num = 1,
                       j.jaql964dia = ln_jaql964dia,
                       j.jaql964sao = ln_jaql964sao,
                       j.jaql964sac = ln_jaql964sac,
                       j.jaql964cuo = ln_jaql964cuo,
                       j.jaql964int = ln_jaql964int,
                       j.jaql964mor = ln_jaql964mor,
                       j.jaql964gas = ln_jaql964gas,
                       j.jaql964mtd = ln_jaql964mtd
                       
                 where  j.jaql964cta = ln_ctnro
                    and j.jaql964ope = ln_itoper
                    and j.jaql964mod = ln_modulo
                    and j.jaql964mda = ln_moneda
                    and j.jaql964sob = ln_itsubo
                    and j.jaql964top = ln_ittope; 
            -- End IF;
             
             if sql%notfound then
                 p_c_coderr := sqlcode;
                 p_c_msgerr := sqlerrm;
             
             end if;
           
           exception when others then
               null;             
           end;
           
           lc_Estado := 'A';
           ln_seguros := 0;
           
           
         end if;
           
          
         insert into JAQL980
          (JAQL980COR,JAQL980COD,JAQL980SUC,JAQL980MOD,JAQL980TRAN,JAQL980NREL,JAQL980FCON,JAQL980UING,
           JAQL980HORA,JAQL980CONT,JAQL980CORR,JAQL980EST, JAQL980CTA, JAQL980OPE)
         values 
         ( pn_cor,pn_pgcod, pn_hsucor, pn_hcmod,pn_htran,pn_hnrel,pd_fecpro,pc_uing,pc_hora,pc_cont,pn_corr, lc_estado,
           ln_ctnro,ln_itoper);  
        
      

       --verificar si pago es parcial o total
       --solo deberia considerar pago total
        --2015.05.20
        /*Si ln_dias <=0 significa que pago la cuota completa en caso contrario se considera cuota parcial*/
        ln_d_alerta := 0;
                                 --pagos vigentes-  --pagos completos--
        if  ln_dia_alerta > 0 and pn_corr = 0 /*and ln_dias <=0*/ and lc_Estado = 'E' then           
             begin
                pq_op_pagos_creditos.sp_inserta_pagos(pn_cor => pn_cor,
                                                  pn_pgcod => pn_pgcod,
                                                  pn_hcmod => pn_hcmod,
                                                  pn_hsucor => pn_hsucor,
                                                  pn_htran => pn_htran,
                                                  pn_hnrel => pn_hnrel,
                                                  pd_fecpro => pd_fecpro,
                                                  pc_uing => pc_uing,
                                                  pc_hora => pc_hora,
                                                  pn_ctnro => ln_ctnro,
                                                  pn_itoper => ln_itoper,
                                                  pn_modulo => ln_modulo,
                                                  pn_moneda => ln_moneda,
                                                  pn_itsubo => ln_itsubo,
                                                  pn_ittope => ln_ittope,
                                                  pn_totpago => ln_totpago,
                                                  pn_mtogas => ln_totgas,
                                                  pn_mtocap => ln_capital,
                                                  pn_mtoint => ln_interes,
                                                  pn_mtomor => ln_mora,
                                                  pn_dias => ln_d_alerta,
                                                  pn_dias_act => /*ln_dias*/ ln_d_alerta);
             end;
        Else
             if  ln_dia_alerta > 0 and pn_corr = 0 /*and ln_dias <=0*/ then           
             begin
                pq_op_pagos_creditos.sp_inserta_pagos(pn_cor => pn_cor,
                                                  pn_pgcod => pn_pgcod,
                                                  pn_hcmod => pn_hcmod,
                                                  pn_hsucor => pn_hsucor,
                                                  pn_htran => pn_htran,
                                                  pn_hnrel => pn_hnrel,
                                                  pd_fecpro => pd_fecpro,
                                                  pc_uing => pc_uing,
                                                  pc_hora => pc_hora,
                                                  pn_ctnro => ln_ctnro,
                                                  pn_itoper => ln_itoper,
                                                  pn_modulo => ln_modulo,
                                                  pn_moneda => ln_moneda,
                                                  pn_itsubo => ln_itsubo,
                                                  pn_ittope => ln_ittope,
                                                  pn_totpago => ln_totpago,
                                                  pn_mtogas => ln_totgas,
                                                  pn_mtocap => ln_capital,
                                                  pn_mtoint => ln_interes,
                                                  pn_mtomor => ln_mora,
                                                  pn_dias => ln_dia_alerta,
                                                  pn_dias_act => ln_dias);
             end;
            end if; 
        --2015.05.20
             end if;
        
        commit; --se movio commit despues de inserta pagos
               
     end if;        
     
 end sp_op_fsd016;                              
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
end PQ_OP_ASIENTOS_CREDITOS;
/

