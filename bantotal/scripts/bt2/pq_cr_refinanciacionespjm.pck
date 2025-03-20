create or replace package pq_cr_refinanciacionespjm is


  -- ***************************************************************************************************************************
  -- Nombre                     : Paquete para el Módulo de refinanciaciones PJM
  -- Sistema                    : BANTOTAL
  -- Módulo                     : Créditos - Activas
  -- Versión                    : 1.0
  -- Fecha de Creación          : 05/08/2024
  -- Autor de Creación          : KVALENCIAC
  -- Estado                     : Activo
  -- Acceso                     : Público
  -- Fecha de Modificación      : 06/09/2024
  -- Autor de Modificación      : KVALENCIAC
  -- Modifiación                : se modificó sp_tipo para obtener el tipo por guía
  -- Fecha de Modificación      : 12/11/2024
  -- Autor de Modificación      : KVALENCIAC
  -- Modifiación                : se modificó sp_tiempocastigado para obtener el tipo según el tiempo castigado
    -- Fecha de Modificación    : 03/02/2025
  -- Autor de Modificación      : KVALENCIAC
  -- Modifiación                : se modificó sp_tiempocastigado para obtener el tipo según el tiempo castigado
  -- *************************************************************************************************************************** 

procedure sp_porcentajeAmort (v_pgcod   in number,
                             v_Scmod   in number,
                             v_Scsuc   in number,
                             v_Scmda   in number,
                             v_Scpap   in number,
                             v_Sccta   in number,
                             v_Scoper  in number,
                             v_Scsbop  in number,
                             v_Sctope  in number,
                             ln_porcentaje out number                            
                             ) ;
procedure sp_TieneGarantia ( pn_cod  in number,
                             pn_mod  in number,
                             pn_suc  in number,
                             pn_mda  in number,
                             pn_pap  in number,
                             pn_cta  in number,
                             pn_ope  in number,
                             pn_sbo  in number,
                             pn_top  in number,
                             pc_flag out varchar
                             );                             
procedure sp_esreprog_exonerado (vn_Pgcod in number, 
                                   vn_ppmod in number, 
                                   vn_ppsuc in number, 
                                   vn_ppmda in number, 
                                   vn_pppap in number,
                                   vn_ppcta in number, 
                                   vn_ppoper in number,
                                   vn_ppsbop in number, 
                                   vn_pptope in number,
                                   vn_ppfpag in date, 
                                   ln_Indicador out number,
                                   ln_montoexo out number);   
procedure sp_esref_exonerado (vn_Pgcod in number, 
                                   vn_ppmod in number, 
                                   vn_ppsuc in number, 
                                   vn_ppmda in number, 
                                   vn_pppap in number,
                                   vn_ppcta in number, 
                                   vn_ppoper in number,
                                   vn_ppsbop in number, 
                                   vn_pptope in number,
                                   vn_ppfpag in date, 
                                   ln_Indicador out number,
                                   ln_montoexo out number);                                    
procedure sp_ultimacuota ( vn_Pgcod in number, 
                                vn_ppmod in number, 
                                vn_ppsuc in number, 
                                vn_ppmda in number, 
                                vn_pppap in number,
                                vn_ppcta in number, 
                                vn_ppoper in number,
                                vn_ppsbop in number,
                                vn_pptope in number,
                                vn_monto out number); 
                                 
procedure sp_AjusteTasa           (vn_Pgcod in number, 
                                   vn_ppmod in number, 
                                   vn_ppsuc in number, 
                                   vn_ppmda in number, 
                                   vn_pppap in number,
                                   vn_ppcta in number, 
                                   vn_ppoper in number,
                                   vn_ppsbop in number, 
                                   vn_pptope in number,
                                   vn_ppfpag in date, 
                                   ln_Indicador out number,
                                   ln_montotasa out number);  
procedure sp_Esexcepcionado       (vn_Pgcod in number, 
                                   vn_ppmod in number, 
                                   vn_ppsuc in number, 
                                   vn_ppmda in number, 
                                   vn_pppap in number,
                                   vn_ppcta in number, 
                                   vn_ppoper in number,
                                   vn_ppsbop in number, 
                                   vn_pptope in number,
                                   vn_ppfpag in date, 
                                   vn_tipo in number,
                                   ln_Indicador out number);                                                                     
procedure sp_tipo       (vn_Pgcod in number, 
                                   vn_ppmod in number, 
                                   vn_ppsuc in number, 
                                   vn_ppmda in number, 
                                   vn_pppap in number,
                                   vn_ppcta in number, 
                                   vn_ppoper in number,
                                   vn_ppsbop in number, 
                                   vn_pptope in number,
                                   vn_ppfpag in date, 
                                   vn_tipo out number); 
procedure sp_tiempocastigado    (vn_Pgcod in number, 
                                   vn_ppmod in number, 
                                   vn_ppsuc in number, 
                                   vn_ppmda in number, 
                                   vn_pppap in number,
                                   vn_ppcta in number, 
                                   vn_ppoper in number,
                                   vn_ppsbop in number, 
                                   vn_pptope in number,
                                   vn_ppfpag in date, 
                                   vn_tipo out number);  
                                                                                                                                                  
end pq_cr_refinanciacionespjm;
/

create or replace package body pq_cr_refinanciacionespjm is

procedure sp_porcentajeAmort( v_pgcod   in number,
                              v_Scmod   in number,
                              v_Scsuc   in number,
                              v_Scmda   in number,
                              v_Scpap   in number,
                              v_Sccta   in number,
                              v_Scoper  in number,
                              v_Scsbop  in number,
                              v_Sctope  in number,
                              ln_porcentaje out number
                             ) is    
ld_pgfape date;
ln_aoimp number(18,2);
ln_totFSD602 number (18,2);
ln_saldoactual number(18,2);
ln_montojudicial number(18,2);
ln_castigado number(18,2);
ln_castigadot number(18,2);
ln_jaql175emp number(3);
ln_jaql175suc number(3);
ln_jaql175cta number(9);
ln_jaql175pap number(4);
ln_jaql175ope number(9);
ln_jaql175sbo number(3);
ln_jaql175mda number(4);
ln_jaql175mod number(3);
ln_jaql175top number(3);
JAQL175CAC number(18,2);
ln_judicialc number(18,2);
ln_JAQL175CAC number(18,2);
ln_aomod_ori number(3);
begin
  select pgfape into ld_pgfape from fst017 where  pgcod=v_pgcod;
  --capital inicial
  
  begin 
     select  aoimp,aomod into ln_aoimp,ln_aomod_ori
      from fsd010 f
     where f.pgcod  = v_pgcod 
      -- and f.aomod  = v_Scmod 
      -- and f.aosuc  = v_Scsuc 
       and f.aomda  = v_Scmda 
       and f.aopap  = v_Scpap 
       and f.aocta  = v_Sccta 
       and f.aooper = v_Scoper
       and f.aosbop = 0
     --  and f.aotope = v_Sctope;
       and ( aomod in (select modulo from fst111 where dscod=50) and aomod not in (33,200));
      Exception
         when no_data_found then
         ln_aoimp:=0;
   end; 
   --inicio 12/11/2024   03/02/2025
   if (ln_aomod_ori=116) then
     --buscar de la fsd601 suma de  capital de la suboperación 0
       select sum(ppcap) into  ln_aoimp
              from fsd601 
              where  ppcta=v_Sccta 
                 and ppoper=v_Scoper 
                 and ppsbop=0
                 and ppcap>0
                 and d601co='S' ;      
   end if;
   --fin 12/11/2024  03/02/2025
  --saldo actual del crédito
  begin 
     select  abs(scsdo) into ln_saldoactual
      from fsd011 f
     where f.pgcod  = v_pgcod 
       and f.scmod  = v_Scmod 
       and f.scsuc  = v_Scsuc 
       and f.scmda  = v_Scmda 
       and f.scpap  = v_Scpap 
       and f.sccta  = v_Sccta 
       and f.scoper = v_Scoper
       and f.scsbop = v_Scsbop
       and f.sctope = v_Sctope;     
      Exception
         when no_data_found then
         ln_saldoactual:=0;
   end; 
  -- if (ln_saldoactual < ln_aoimp) then    --kvalenciac 05/08/2024
           --capital pagado
           --para todos los casos obtenemos los pagos realizado de la FSD602 cuando el crédito tiene cronograma solo contabilizados y transacciones de pago
           begin
              select sum(pp1cap) into ln_totFSD602 
              from fsd602 
              where  ppcta=v_Sccta 
                 and ppoper=v_Scoper 
                 and d602co='S' 
                 and pp1cap>0 
                 and ((d602mo,d602tr) in (select tp1corr1,tp1corr2 from fst198 where tp1cod1=10876 and tp1corr1<999999 and tp1nro1=1)
                  or (d602mo=0 and d602tr=0));
            Exception 
              when no_data_found then
                ln_totFSD602:=0;
            end;  
  --INICIO kvalencac 06(08/2024
  ln_montojudicial:=0;
  if ( v_Scmod = 200 or v_Scmod=33 ) then
  --buscamos todas las operaciones pagadas
    begin
      select sum(jaqy711cap) into  ln_montojudicial
      from jaqy711
      where jaqy711cod = v_pgcod
      and jaqy711mda =  v_Scmda   
      and jaqy711pap =  v_Scpap 
      and jaqy711cta =  v_Sccta 
      and jaqy711ope =  v_Scoper
      and (jaqy711tmod, jaqy711ttran) in (select tp1nro1,tp1nro2 from fst198 where tp1cod1=11172 and tp1corr1=5 and tp1corr2=2 and tp1corr3>0 and tp1imp1 in (64,90) );
    exception
      when no_data_found then 
      ln_montojudicial:=0;
    end;
    if (ln_montojudicial is null) then
      ln_montojudicial:=0;
    end if;
  end if;
  --fin kvalencac 06(08/2024
           /*   
           --si es módulo 200
           ln_montojudicial:=0;
           if ( v_Scmod = 200 ) then     
             begin 
                    select h.hcimp1 into ln_montojudicial
                      from fsh016 h
                      inner join fsh015 s on s.pgcod=h.pgcod and s.hcmod=h.hcmod and s.hsucor=h.hsucor and s.htran=h.htran and s.hnrel=h.hnrel and s.hfcon=h.hfcon
                    where h.PGCOD = v_pgcod 
                    --and h.HSUCUR= v_Scsuc  
                      and h.HMODUL= v_Scmod
                      and h.HMDA =  v_Scmda 
                      and h.HPAP =  v_Scpap    
                      and h.HCTA =  v_Sccta 
                      and h.HOPER=  v_Scoper
                      and h.HSUBOP= v_Scsbop
                      and h.htoper= v_Sctope
                      --and h.HFCON = ld_fecha
                      and ( h.HCMOD,h.HTRAN,h.HCORD) in (select tp1nro1,tp1nro2,tp1imp1 from fst198 where tp1cod1=11172 and tp1corr1=2 and tp1corr2=1 and tp1corr3>0 and tp1nro3=v_Scmod)--se busca en el ordinal donde esta el crédito que nace de la transacción
                      and s.hccorr=0 --debe estar contabilizado  
                      order by h.PGCOD, h.HCTA;
              Exception
                    when no_data_found then        
                       ln_montojudicial:=0;
              end;
              ln_montojudicial:= ln_saldoactual - ln_montojudicial;---esto es lo pagado en estado judicial
            end if;             
           --si es castigado modulo=33
           ln_jaql175mod:=0;
           ln_castigado:=0;
           ln_judicialc:=0;
           ln_castigadot:=0;
           if ( v_Scmod = 33 ) then 
               begin 
                      select j.jaql175emp,
                             j.jaql175suc,
                             j.jaql175cta,
                             j.jaql175pap,
                             j.jaql175ope,
                             j.jaql175sbo,
                             j.jaql175mda,
                             j.jaql175mod,
                             j.jaql175top,
                             j.JAQL175CAC
                             into 
                             ln_jaql175emp,
                             ln_jaql175suc,
                             ln_jaql175cta,
                             ln_jaql175pap,
                             ln_jaql175ope,
                             ln_jaql175sbo,
                             ln_jaql175mda,
                             ln_jaql175mod,
                             ln_jaql175top,
                             ln_JAQL175CAC
                      from jaql175 j 
                      where j.jaql175emp= v_pgcod
                        and j.jaql175cta= v_Sccta  
                        and j.jaql175pap= v_Scpap 
                        and j.jaql175ope= v_Scoper 
                        and j.jaql175mda= v_Scmda 
                        and j.jaql175itc= 'S';
               Exception
                      when no_data_found then        
                         ln_jaql175mod:=0;
               end; 
               begin 
                      select h.hcimp1 into ln_castigado
                        from fsh016 h
                        inner join fsh015 s on s.pgcod=h.pgcod and s.hcmod=h.hcmod and s.hsucor=h.hsucor and s.htran=h.htran and s.hnrel=h.hnrel and s.hfcon=h.hfcon
                      where h.PGCOD = v_pgcod
                        --and h.HSUCUR= ln_jaql175suc  -- se quita por lo de cambio de agencia que a veces se da
                        and h.HMODUL= v_Scmod
                        and h.HMDA =  v_Scmda  
                        and h.HPAP =  v_Scpap    
                        and h.HCTA =  v_Sccta 
                        and h.HOPER=  v_Scoper
                        and h.HSUBOP= v_Scsbop
                        and h.HTOPER= v_Sctope
                        --and h.HFCON = ld_fecha
                        and ( h.HCMOD,h.HTRAN,h.HCORD) in (select tp1nro1,tp1nro2,tp1imp1 from fst198 where tp1cod1=11172 and tp1corr1=2 and tp1corr2=1 and tp1corr3>0 and tp1nro3=v_Scmod)--se busca en el ordinal donde esta el crédito que nace de la transacción
                        and s.hccorr=0 --debe estar contabilizado  
                        order by h.PGCOD, h.HCTA;
                Exception
                      when no_data_found then        
                         ln_castigado:=0;
                end;                
                if (  ln_jaql175mod=200 ) then -- si antes de castigarlo vino de un judicial hay que buscar su saldo pagado en estado judicial
                   --luego obtengo su saldo pagado en estado judicial
                    begin
                     select h.hcimp1 into ln_judicialc
                        from fsh016 h
                        inner join fsh015 s on s.pgcod=h.pgcod and s.hcmod=h.hcmod and s.hsucor=h.hsucor and s.htran=h.htran and s.hnrel=h.hnrel and s.hfcon=h.hfcon
                      where h.PGCOD = ln_jaql175emp
                        --and h.HSUCUR= ln_jaql175suc  -- se quita por lo de cambio de agencia que a veces se da
                        and h.HMODUL= ln_jaql175mod
                        and h.HMDA =  ln_jaql175mda 
                        and h.HPAP =  ln_jaql175pap    
                        and h.HCTA =  ln_jaql175cta 
                        and h.HOPER=  ln_jaql175ope
                        and h.HSUBOP= ln_jaql175sbo 
                        and h.HTOPER= ln_jaql175top
                        --and h.HFCON = ld_fecha
                        and ( h.HCMOD,h.HTRAN,h.HCORD) in (select tp1nro1,tp1nro2,tp1imp1 from fst198 where tp1cod1=11172 and tp1corr1=2 and tp1corr2=1 and tp1corr3>0 and tp1nro3=ln_jaql175mod)--se busca en el ordinal donde esta el crédito que nace de la transacción
                        and s.hccorr=0 --debe estar contabilizado  
                        order by h.PGCOD, h.HCTA;
                     Exception
                      when no_data_found then        
                         ln_judicialc:=0;
                     end;
                     ln_judicialc:= ln_JAQL175CAC - ln_judicialc;
                 end if;
                 
                 ln_castigadot:= ( ln_castigado - ln_saldoactual )+ ln_judicialc;---esto es lo pagado en estado castigado
           end if;
           */  --comentado 06/09/2024  kvalenciac 
     ln_porcentaje:=0;
     ln_porcentaje := round(((ln_totFSD602+ln_montojudicial)/ ln_aoimp)  * 100,2);     
/*   else
     ln_porcentaje:=0;
   end if; */--kvalenciac 05/08/2024
end sp_porcentajeAmort;
procedure sp_TieneGarantia ( pn_cod  in number,
                             pn_mod  in number,
                             pn_suc  in number,
                             pn_mda  in number,
                             pn_pap  in number,
                             pn_cta  in number,
                             pn_ope  in number,
                             pn_sbo  in number,
                             pn_top  in number,
                             pc_flag out varchar
                             ) is  
   ln_TieneGarantiaR number;
   ln_contador number;
   ln_instancia number;
   ln_instanciaL number;
   ln_eslinea number;
   pn_codl number;
   pn_sucl number;
   pn_modl number;
   pn_mdal number;
   pn_papl number;
   pn_ctal number;
   pn_opel number;
   pn_sbol number;
   pn_topl number;
  begin
    ln_TieneGarantiaR:=0;
    --busco instancia del crédito
    begin
      select max(XWFPRCINS) into ln_instancia
      from xwf700 
      where XWFEMPRESA  = pn_cod
        and XWFSUCURSAL = pn_suc 
        and XWFMODULO   = pn_mod
        and XWFMONEDA   = pn_mda
        and XWFPAPEL    = pn_pap
        and XWFCUENTA   = pn_cta
        and XWFOPERACION= pn_ope
        and XWFSUBOPE   = pn_sbo
        and XWFTIPOPE   = pn_top
        and xwFcar3 = '1';
    exception 
      when no_data_found then
          ln_instancia:=0;
    end;
    begin
      select count(*) into  ln_contador
      from fsr011
      where R1COD = pn_cod
        and R1MOD = pn_mod
        and R1SUC = pn_suc
        and R1MDA = pn_mda
        and R1PAP = pn_pap
        and R1CTA = pn_cta
        and R1OPER= pn_ope
        and R1SBOP= pn_sbo
        and R1TOPE= pn_top
        and RELCOD = 50
        and (R2MOD, R2TOPE) in ( ---tp1nro1=tipo de operación
                                select 70,tp1nro1 from fst198 
                                where tp1cod=1 
                                and tp1cod1=11172 
                                and  tp1corr1=2 
                                and tp1corr2=2 
                                and tp1corr3>0);
                                
     exception
       when no_data_found then
          ln_contador :=0;
     end;
     if (ln_contador=0) then
         begin
          select count(*) into ln_contador
          from sng122
          where sng122inst=ln_instancia
          and (sng122mod,sng122tope) in (select 70,tp1nro1 from fst198 
                                         where tp1cod=1 
                                         and tp1cod1=11172 
                                         and  tp1corr1=2 
                                         and tp1corr2=2 
                                         and tp1corr3>0)
          order by sng122inst;
          exception
             when no_data_found then
               ln_contador:=0;
          end;
     end if;

     if (ln_contador=0) then --si es línea
       begin
       select 1,
              d.R2COD, 
              d.R2MOD,
              d.R2SUC, 
              d.R2MDA, 
              d.R2PAP, 
              d.R2CTA, 
              d.R2OPER,
              d.R2SBOP,
              d.R2TOPE
              into 
              ln_eslinea,
              pn_codl,
              pn_modl,
              pn_sucl,
              pn_mdal,
              pn_papl,
              pn_ctal,
              pn_opel,
              pn_sbol,
              pn_topl                            
        from fsr011 d                                    
        where d.R1COD  = pn_cod
          and d.R1MOD  = pn_mod
          and d.R1SUC  = pn_suc 
          and d.R1MDA  = pn_mda
          and d.R1PAP  = pn_pap
          and d.R1CTA  = pn_cta
          and d.R1OPER = pn_ope
          and d.R1SBOP = pn_sbo
          and d.R1TOPE = pn_top
          and d.RELCOD  = 46
          and rownum=1;
        exception
                 when no_data_found then
                   ln_eslinea :=0;
        end;  
        if (ln_eslinea=1) then
          begin 
          select max(XWFPRCINS) into ln_instanciaL
          from xwf700 
          where XWFEMPRESA  = pn_codl
            and XWFSUCURSAL = pn_sucl
            and XWFMODULO   = pn_modl
            and XWFMONEDA   = pn_mdal
            and XWFPAPEL    = pn_papl
            and XWFCUENTA   = pn_ctal
            and XWFOPERACION= pn_opel
            and XWFSUBOPE   = pn_sbol
            and XWFTIPOPE   = pn_topl
            and xwFcar3 = '1';
          exception
                 when no_data_found then
                   ln_instanciaL :=0;
          end;
           begin
              select count(*) into ln_contador
              from sng122
              where sng122inst=ln_instanciaL
              and (sng122mod,sng122tope) in (select 70,tp1nro1 from fst198 
                                         where tp1cod=1 
                                         and tp1cod1=11172 
                                         and  tp1corr1=2 
                                         and tp1corr2=2 
                                         and tp1corr3>0)
              order by sng122inst;
              exception
                 when no_data_found then
                   ln_contador:=0;
              end;           
               if (ln_contador=0) then
                  begin
                    select count(*) into  ln_contador
                    from fsr011
                    where R1COD = pn_codl
                      and R1MOD = pn_modl
                      and R1SUC = pn_sucl
                      and R1MDA = pn_mdal
                      and R1PAP = pn_papl
                      and R1CTA = pn_ctal
                      and R1OPER= pn_opel
                      and R1SBOP= pn_sbol
                      and R1TOPE= pn_topl
                      and RELCOD = 50
                      and (R2MOD, R2TOPE) in (select 70,tp1nro1 from fst198 
                                         where tp1cod=1 
                                         and tp1cod1=11172 
                                         and  tp1corr1=2 
                                         and tp1corr2=2 
                                         and tp1corr3>0); ---tpnro1=módulo y tp1nro2=tipo de operación
                   exception
                     when no_data_found then
                        ln_contador :=0;
                   end;
               end if;
            end if;
     end if;
     pc_flag:='SG';
      if (ln_contador >0) then
        ln_TieneGarantiaR:=1;
        pc_flag:='CG';
      end if;
     
end sp_TieneGarantia; 
procedure sp_esreprog_exonerado (vn_Pgcod in number, vn_ppmod in number, vn_ppsuc in number, vn_ppmda in number, vn_pppap in number,
   vn_ppcta in number, vn_ppoper in number,vn_ppsbop in number, vn_pptope in number,vn_ppfpag in date, ln_Indicador out number, ln_montoexo out number)
is
begin
  ln_Indicador:=0;
  begin
      select 1,JAQN8ATEX into ln_Indicador,ln_montoexo
      from JAQN8A
      where JAQN8AEMP = vn_Pgcod
       and JAQN8AMOD = vn_ppmod
       and JAQN8ASUC = vn_ppsuc
       and JAQN8AMDA = vn_ppmda
       and JAQN8APAP = vn_pppap
       and JAQN8ACTA = vn_ppcta
       and JAQN8AOPE = vn_ppoper
       and JAQN8ASBO = vn_ppsbop
       and JAQN8ATOP = vn_pptope
       and JAQN8AEST='G';
   exception 
      when others then
        ln_Indicador :=0;
   end;       
end  sp_esreprog_exonerado;

procedure sp_esref_exonerado (vn_Pgcod in number, vn_ppmod in number, vn_ppsuc in number, vn_ppmda in number, vn_pppap in number,
   vn_ppcta in number, vn_ppoper in number,vn_ppsbop in number, vn_pptope in number,vn_ppfpag in date, ln_Indicador out number, ln_montoexo out number)
is
begin
  ln_Indicador:=0;
  begin
      select 1,JAQN8ATEX into ln_Indicador,ln_montoexo
      from JAQN8A
      where JAQN8AEMP = vn_Pgcod
       and JAQN8AMOD = vn_ppmod
       and JAQN8ASUC = vn_ppsuc
       and JAQN8AMDA = vn_ppmda
       and JAQN8APAP = vn_pppap
       and JAQN8ACTA = vn_ppcta
       and JAQN8AOPE = vn_ppoper
       and JAQN8ASBO = vn_ppsbop
       and JAQN8ATOP = vn_pptope
       and JAQN8AEST='C';
   exception 
      when others then
        ln_Indicador :=0;
   end;       
end  sp_esref_exonerado;

procedure sp_ultimacuota ( vn_Pgcod in number, 
                                vn_ppmod in number, 
                                vn_ppsuc in number, 
                                vn_ppmda in number, 
                                vn_pppap in number,
                                vn_ppcta in number, 
                                vn_ppoper in number,
                                vn_ppsbop in number, 
                                vn_pptope in number,
                                vn_monto out number)
is
ln_Pp1nump number;
ln_Ppcap number;
ln_Ppint number;
ln_IntMor number;
ln_Icv number;
ln_Seguro1 number;
ln_Seguro2 number;
ln_Seguro3 number;
ln_Seguro4 number;
ln_Seguro5 number;
ln_penalidad number;
ln_modulo number;
ln_ittope number;
ln_itsucd number;
ln_moneda number;
ln_papel number;
ln_ctnro number;
ln_itoper number;
ln_itsubope number;
ln_total number;
ld_Ppfpag date;
begin
  --obtengo la máxima cuota o última cuota
  begin 
        select max(ppfpag)
        into ld_ppfpag   
        from FSD601 -- --> FSD602: Calendario de Pagos, busca las cuotas pagadas por la transacción
        Where PgCod  = vn_Pgcod 
          and Ppmod  = vn_ppmod 
          and Ppsuc  = vn_ppsuc 
          and Ppmda  = vn_ppmda 
          and Pppap  = vn_pppap 
          and Ppcta  = vn_ppcta 
          and Ppoper = vn_ppoper
          and Ppsbop = vn_ppsbop
          and Pptope = vn_pptope;                                 
   EXCEPTION
       when others then
          ld_ppfpag:= null ; 
   end;
   Begin
       select         
           Ppcap,  --capital
           Ppint   --interes compensatorio          
           into                     
           ln_Ppcap,
           ln_Ppint 
        from FSD601 -- --> FSD601: cronograma de pago se debe sacar de aca porque cuando se apga adelantado los montos en le fSD602 del interes se vuelve cero
        where PgCod  = vn_Pgcod 
          and Ppmod  = vn_ppmod 
          and Ppsuc  = vn_ppsuc 
          and Ppmda  = vn_ppmda 
          and Pppap  = vn_pppap 
          and Ppcta  = vn_ppcta 
          and Ppoper = vn_ppoper
          and Ppsbop = vn_ppsbop
          and Pptope = vn_pptope
          and ppfpag = ld_ppfpag;
        EXCEPTION
        when others then
           ln_Ppcap:= 0;
           ln_Ppint:=0;
        end;
        --obtengo seguros
      ln_Seguro1 :=0;
      ln_Seguro2 :=0; 
      ln_Seguro3 :=0; 
      ln_Seguro4 :=0; 
      ln_Seguro5 :=0;        
       begin
      select  --Pp1imp2,  -- Interes Moratorio
              --Pp1imp3, --obtengo ICV
              Ppimp11, --seguro
              Ppimp12, --seguro
              Ppimp13, --seguro
              Ppimp14, --seguro
              Ppimp15 --seguro
       into
              --ln_IntMor, 
              --ln_Icv,
              ln_Seguro1,
              ln_Seguro2,
              ln_Seguro3,
              ln_Seguro4,
              ln_Seguro5
      from FSD611
      where PgCod = vn_Pgcod 
      and Ppmod   = vn_ppmod 
      and Ppsuc   = vn_ppsuc 
      and Ppmda   = vn_ppmda 
      and Pppap   = vn_pppap 
      and Ppcta   = vn_ppcta 
      and Ppoper  = vn_ppoper
      and Ppsbop  = vn_ppsbop
      and Pptope  = vn_pptope
      and ppfpag  = ld_ppfpag;
      EXCEPTION
      when others then
       -- ln_IntMor :=0; 
       -- ln_Icv :=0; 
        ln_Seguro1:=0; 
        ln_Seguro2 :=0;
        ln_Seguro3:=0;
        ln_Seguro4:=0;
        ln_Seguro5:=0;
      end;
      ln_total:=  ln_Ppcap + ln_Ppint + ln_Seguro1 + ln_Seguro2 + ln_Seguro3 + ln_Seguro4 + ln_Seguro5;
      vn_monto := ln_total;
end sp_ultimacuota;   
procedure sp_AjusteTasa (vn_Pgcod in number, 
                         vn_ppmod in number, 
                         vn_ppsuc in number, 
                         vn_ppmda in number, 
                         vn_pppap in number,
                         vn_ppcta in number, 
                         vn_ppoper in number,
                         vn_ppsbop in number, 
                         vn_pptope in number,
                         vn_ppfpag in date, 
                         ln_Indicador out number, 
                         ln_montotasa out number)
is
begin
  ln_Indicador:=0;
  ln_montotasa:=0;
  begin
      select 1,JAQN8BPTA into ln_Indicador,ln_montotasa
      from JAQN8B
      where JAQN8BEMP = vn_Pgcod
       and JAQN8BMOD = vn_ppmod
       and JAQN8BSUC = vn_ppsuc
       and JAQN8BMDA = vn_ppmda
       and JAQN8BPAP = vn_pppap
       and JAQN8BCTA = vn_ppcta
       and JAQN8BOPE = vn_ppoper
       and JAQN8BSBO = vn_ppsbop
       and JAQN8BTOP = vn_pptope
       and JAQN8BEST='G';
   exception 
      when others then
        ln_Indicador :=0;
        ln_montotasa:=0;
   end;       
end  sp_AjusteTasa;
procedure sp_Esexcepcionado (vn_Pgcod in number, 
                         vn_ppmod in number, 
                         vn_ppsuc in number, 
                         vn_ppmda in number, 
                         vn_pppap in number,
                         vn_ppcta in number, 
                         vn_ppoper in number,
                         vn_ppsbop in number, 
                         vn_pptope in number,
                         vn_ppfpag in date,
                         vn_tipo in number,
                         ln_Indicador out number)
is
begin
  ln_Indicador:=0;
  begin
      select 1 into ln_Indicador
      from AQPB405
      where AQPB405COD = vn_Pgcod
       and AQPB405MOD = vn_ppmod
       and AQPB405SUC = vn_ppsuc
       and AQPB405MDA = vn_ppmda
       and AQPB405PAP = vn_pppap
       and AQPB405CTA = vn_ppcta
       and AQPB405OPE = vn_ppoper
       and AQPB405SBO = vn_ppsbop
       and AQPB405TPO = vn_pptope
       and AQPB405EST = 'A'
       and AQPB405TIPE = vn_tipo;
   exception 
      when others then
        ln_Indicador :=0;      
   end;       
end  sp_Esexcepcionado;
procedure sp_tipo (vn_Pgcod in number, 
                         vn_ppmod in number, 
                         vn_ppsuc in number, 
                         vn_ppmda in number, 
                         vn_pppap in number,
                         vn_ppcta in number, 
                         vn_ppoper in number,
                         vn_ppsbop in number, 
                         vn_pptope in number,
                         vn_ppfpag in date,
                         vn_tipo out number)
is
lc_tipo char(30);
ln_tipo number;
begin
  ln_tipo:=0;
  lc_tipo:='';
  begin
      select substr(AQPD220tipo,1,30)  into lc_tipo
      from AQPD220
     where AQPD220bcemp = vn_Pgcod
       and AQPD220bccta = vn_ppcta 
       and AQPD220bcoper= vn_ppoper
       and AQPD220bcsbop= vn_ppsbop 
       and AQPD220bcmda = vn_ppmda 
       and AQPD220bcpap = vn_pppap
       and AQPD220bcsuc = vn_ppsuc 
       and AQPD220bcmod = vn_ppmod 
       and AQPD220bctop = vn_pptope
       and AQPD220EST  = 'A';                     
   exception 
      when others then
        lc_tipo :='';      
   end;       
   /*if ( lc_tipo ='REPROGRAMACION COVID DEL 1 AL 5' )then
       vn_tipo:=1;
   else
     if (lc_tipo ='REPROGRAMACION CONFLICTO SOCIAL DEL 1 AL 5' )then
        vn_tipo:=2;
     else
       if (lc_tipo ='RESTO' )then
         vn_tipo:=3;
       end if;
     end if;
   end if;*/
   --inicio 06/09/2024 kvalenciac
   begin
      select tp1corr3 into vn_tipo
      from fst198
     where tp1cod = 1
       and tp1cod1 = 8003 
       and tp1corr1= 5
       and tp1desc = lc_tipo;                     
   exception 
      when others then
        vn_tipo :='0';      
   end; 
   --fin 06/09/2024 kvalenciac     
end  sp_tipo;
--inicio 12/11/2024 kvalenciac
procedure sp_tiempocastigado (vn_Pgcod in number, 
                         vn_ppmod in number, 
                         vn_ppsuc in number, 
                         vn_ppmda in number, 
                         vn_pppap in number,
                         vn_ppcta in number, 
                         vn_ppoper in number,
                         vn_ppsbop in number, 
                         vn_pptope in number,
                         vn_ppfpag in date,
                         vn_tipo out number)
is
ln_meses number;
begin
  ln_meses:=0;
  /*begin
      select MONTHS_BETWEEN(vn_ppfpag,jaql175fca) into ln_meses
      from jaql175
     where jaql175emp   = vn_Pgcod
      -- and jaql175suc = vn_ppsuc 
       and jaql175cta   = vn_ppcta 
       and jaql175pap   = vn_pppap
       and jaql175ope   = vn_ppoper
      --and jaql175sbo  = vn_ppsbop 
       and jaql175mda   = vn_ppmda 
      -- and jaql175mod = vn_ppmod 
      -- and jaql175top = vn_pptope
       and jaql175ITC  = 'S';                     
   exception 
      when others then
        ln_meses :='';      
   end; */
     begin
       select MONTHS_BETWEEN(vn_ppfpag,jaql166scfvl) into ln_meses 
       from JAQL166
       Where jaql166pgcod = vn_Pgcod
       and jaql166scmod   = vn_ppmod  
     --  and jaql166scsuc = vn_ppsuc  
       and jaql166scmda   = vn_ppmda 
       and jaql166scpap   = vn_pppap
       and jaql166sccta   = vn_ppcta  
       and jaql166scope   = vn_ppoper  
       and jaql166scsbo   = vn_ppsbop 
       and jaql166sctop   = vn_pptope
       and jaql166nrpag = 0
       and jaql166est=90;         
      exception 
      when others then
        ln_meses :=0;      
      end;

   if ( ln_meses=0 )then
      vn_tipo:=0;
   end if; 
   if ( ln_meses<=12) then
     vn_tipo:=1;
   else
     if ( ln_meses<=24) then
       vn_tipo:=2;
     else
       vn_tipo:=3;
     end if;
   end if;    
   
end  sp_tiempocastigado;
--fin 12/11/2024 kvalenciac
end pq_cr_refinanciacionespjm;
/

