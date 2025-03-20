create or replace package pq_cr_reporte_faetexco is

  -- Author  : RMONTESR
  -- Created : 29/03/2023 16:09:48
  -- Purpose : Procedimientos para reporte Fae Texco
  
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                 
  -- Registro de información en plantilla
  procedure sp_insertar_cabecera(pn_pgcod   in number,
                                 pn_usuario in varchar2,
                                 pn_fecha   in date,
                                 pn_tiporep in number,
                                 pn_corr    out number,
                                 pn_flag    out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  -- Actualización de información en plantilla
  procedure sp_actualizar_cabecera(pn_pgcod   in number,
                                   pn_fecha   in date,
                                   pn_corr    in number,
                                   pn_usuario in varchar2,
                                   pn_tiporep in number,
                                   pn_estado  in varchar2,
                                   pn_flag    out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                   
  
  procedure sp_insertar_pauxiliar(pn_pgcod   in number,
                                  pn_usuario in varchar2,
                                  pn_fecha   in date,
                                  pn_tiporep in number,
                                  pn_corr    out number,
                                  pn_flag    out varchar2);

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                                  
  procedure sp_actualizar_pauxiliar(pn_pgcod   in number,
                                    pn_fecha   in date,
                                    pn_corr    in number,
                                    pn_usuario in varchar2,
                                    pn_tiporep in number,
                                    pn_estado  in varchar2,
                                    pn_flag    out varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
  --procedure sp_cr_sch_faetexco_sinjob(pd_fecpro in date, pn_usuario in varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
  procedure sp_cr_sch_faetexco2(pd_fecpro  in date,
                               pn_suc in number,
                               pn_usuario in varchar2
                               );
  -----------------------------------------------------------------------
  procedure sp_guardar_historico(pn_usuario char, pn_fcorte date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
  procedure sp_cr_sch_faetexco(pd_fecpro in date, pn_usuario in varchar2);
  -----------------------------------------------------------------------

end pq_cr_reporte_faetexco;
/

create or replace package body pq_cr_reporte_faetexco is

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --          
  procedure sp_insertar_cabecera(pn_pgcod   in number,
                                 pn_usuario in varchar2,
                                 pn_fecha   in date,
                                 pn_tiporep in number,
                                 pn_corr    out number,
                                 pn_flag    out varchar2) is
  
    --lc_corr number;
  
  begin
  
    pn_flag := 'N';
    case
    
      when pn_tiporep = 1 then
        -- faex texco
      
        pn_flag := 'S';
      
        --- Obtener el correlativo
        select nvl(max(t.aqpc360acor), 0) + 1 into pn_corr from aqpc360a t;
      
        --- Reporte fae texco
        insert into aqpc360a
          (aqpc360acod,
           aqpc360afec,
           aqpc360acor,
           aqpc360aest,
           aqpc360ausr,
           aqpc360afcr,
           aqpc360ahcr)
        values
          (pn_pgcod,
           pn_fecha,
           pn_corr,
           'I', --INSERTAR
           pn_usuario,
           to_char(sysdate, 'DD/MM/YYYY'),
           to_char(sysdate, 'HH24:MI:SS'));
        commit;
      
    end case;
  
  end sp_insertar_cabecera;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
  procedure sp_actualizar_cabecera(pn_pgcod   in number,
                                   pn_fecha   in date,
                                   pn_corr    in number,
                                   pn_usuario in varchar2,
                                   pn_tiporep in number,
                                   pn_estado  in varchar2,
                                   pn_flag    out varchar2) is
  
    --pn_est char(1);
  
  begin
  
    pn_flag := 'N';
    case
      when pn_tiporep = 1 then
        ---fae texco
      
        pn_flag := 'S';
      
        --Actualización del detalle de la plantilla
        update aqpc360b t
           set t.aqpc360best  = pn_estado,
               t.aqpc360busu  = pn_usuario,
               t.aqpc360bfedi = to_char(sysdate, 'DD/MM/YYYY'),
               t.aqpc360bhedi = to_char(sysdate, 'HH24:MI:SS')
        
         where t.aqpc360bcod = pn_pgcod
           and t.aqpc360bfec = pn_fecha
           and t.aqpc360bcor = pn_corr
           and t.aqpc360best <> 'D';
        commit;
      
        update aqpc360a t
           set t.aqpc360aest = pn_estado,
               t.aqpc360ausd = pn_usuario,
               t.aqpc360afed = to_char(sysdate, 'DD/MM/YYYY'),
               t.aqpc360ahed = to_char(sysdate, 'HH24:MI:SS')
        
         where t.aqpc360acod = pn_pgcod
           and t.aqpc360afec = pn_fecha
           and t.aqpc360acor = pn_corr;
        commit;
      
    end case;
  
  end sp_actualizar_cabecera;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --        
  procedure sp_insertar_pauxiliar(pn_pgcod   in number,
                                  pn_usuario in varchar2,
                                  pn_fecha   in date,
                                  pn_tiporep in number,
                                  pn_corr    out number,
                                  pn_flag    out varchar2) is
  
    -- lc_corr number;
  
  begin
  
    pn_flag := 'N';
    case
    
      when pn_tiporep = 1 then
        -- fae texco
      
        pn_flag := 'S';
      
        --- Obtener el correlativo
        select nvl(max(t.aqpc360acor), 0) + 1 into pn_corr from aqpc360a t;
      
        --- Reporte fae texco
        insert into aqpc360a
          (aqpc360acod,
           aqpc360afec,
           aqpc360acor,
           aqpc360aest,
           aqpc360ausr,
           aqpc360afcr,
           aqpc360ahcr)
        values
          (pn_pgcod,
           pn_fecha,
           pn_corr,
           'I', --INSERTAR
           pn_usuario,
           to_char(sysdate, 'DD/MM/YYYY'),
           to_char(sysdate, 'HH24:MI:SS'));
        commit;
      
    end case;
  
  end sp_insertar_pauxiliar;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --       
  procedure sp_actualizar_pauxiliar(pn_pgcod   in number,
                                    pn_fecha   in date,
                                    pn_corr    in number,
                                    pn_usuario in varchar2,
                                    pn_tiporep in number,
                                    pn_estado  in varchar2,
                                    pn_flag    out varchar2) is
  
  begin
  
    pn_flag := 'N';
    case
      when pn_tiporep = 1 then
        ---fae agro
      
        pn_flag := 'S';
      
        update aqpc360a t
           set t.aqpc360aest = pn_estado,
               t.aqpc360ausd = pn_usuario,
               t.aqpc360afed = to_char(sysdate, 'DD/MM/YYYY'),
               t.aqpc360ahed = to_char(sysdate, 'HH24:MI:SS')
        
         where t.aqpc360acod = pn_pgcod
           and t.aqpc360afec = pn_fecha
           and t.aqpc360acor = pn_corr;
        commit;
      
    end case;
  
  end sp_actualizar_pauxiliar;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
 /* procedure sp_cr_sch_faetexco_sinjob(pd_fecpro  in date,
                               pn_usuario in varchar2
                               ) is
  ld_fecha_rcc date;
  ln_nro_mes number;  
  ld_fecha date;                         
  begin
    begin
      delete from aqpc360 x
       where x.aqpc360usur = rpad(trim(pn_usuario), 10, ' ');
      commit;
    end;
    select to_date(t.tpnro, 'DDMMYY')
      into ld_fecha_rcc
      from fst098 t
     where t.pgcod = 1
       and t.tpcod = 7647
       and t.tpcorr = 12;
  
    -- 1. Nro meses RCC
    begin
      select x.tp1nro1
        into ln_nro_mes
        from fst198 x
       where x.TP1COD = 1
         and x.TP1COD1 = 11144
         and x.TP1CORR1 = 10
         and x.tp1corr2 = 2
         and x.tp1corr3 = 4;
    exception
      when others then
        ln_nro_mes := 1;
    end;
    if pd_fecpro <= ld_fecha_rcc then
      ld_fecha_rcc := last_day(add_months(trunc(pd_fecpro), -1 * ln_nro_mes));
    end if;
  
    -- Fecha actual
    select t.pgfape into ld_fecha from fst017 t where t.pgcod = 1;
    begin
      insert into aqpc360(  aqpc360usur   ,
  aqpc360rucc   ,
  aqpc360nsol   ,
  aqpc360ncta   ,
  aqpc360nope   ,
  aqpc360npre   ,
  aqpc360fdes   ,
  aqpc360scap   ,
  aqpc360sins   ,
  aqpc360mpre   ,
  aqpc360fclas  ,
  aqpc360cnor   ,
  aqpc360ccpp   ,
  aqpc360cdef   ,
  aqpc360cdud   ,
  aqpc360cper   ,
  aqpc360scon   ,
  aqpc360atru   ,
  aqpc360rgon   ,
  aqpc360zona   ,
  aqpc360agen   ,
  aqpc360anal   ,
  aqpc360tdoc   ,
  aqpc360ndoc   ,
  aqpc360rsoc   ,
  aqpc360nomc   ,
  aqpc360estd   ,
  aqpc360fest   ,
  aqpc360cdes   ,
  aqpc360ncuod  ,
  aqpc360pgra   ,
  aqpc360cobr   ,
  aqpc360mcob   ,
  aqpc360chon   ,
  aqpc360fhon   ,
  aqpc360mhon   ,
  aqpc360datr   ,
  aqpc360finc   ,
  aqpc360ffnc   ,
  aqpc360cpen   ,
  aqpc360fvnui  ,
  aqpc360fvnup  ,
  aqpc360fpup   ,
  aqpc360cuop   ,
  aqpc360mcuop  ,
  aqpc360prcap  ,
  aqpc360pinc   ,
  aqpc360pinm   ,
  aqpc360prin   ,
  aqpc360prpn   ,
  aqpc360prseg  ,
  aqpc360fcsbs  ,
  aqpc360snor   ,
  aqpc360scpp   ,
  aqpc360sdef   ,
  aqpc360sdud   ,
  aqpc360sper   ,
  aqpc360tea    ,
  aqpc360team   ,
  aqpc360ciuu   ,
  aqpc360aeco   ,
  aqpc360tcre   ,
  aqpc360tpre   ,
  aqpc360repro  ,
  aqpc360frpro  ,
  aqpc360nrpro  ,
  aqpc360fprcr  ,
  aqpc360ffnpr  ,
  aqpc360ncuor  ,
  aqpc360grac   ,
  aqpc360ciuo   ,
  aqpc360aecoo  ,
  aqpc360emp    ,
  aqpc360mod    ,
  aqpc360suc    ,
  aqpc360mnda   ,
  aqpc360papl   ,
  aqpc360sbop   ,
  aqpc360tope   ,
  aqpc360mone   ,
  aqpc360sdocap ,
  aqpc360sdohon ,
  aqpc360crehon ,
  aqpc360fcr    ,
  aqpc360hcr    ,
  aqpc360fproc  ,
  aqpc360ncert  ,
  aqpc360codgar ,
  aqpc360codcob ,
  aqpc360sdocre ,
  aqpc360intcom ,
  aqpc360intmor ,
  aqpc360intcov ,
  aqpc360pen    ,
  aqpc360certrn ,
  aqpc360cobren )
             select rpad(trim(pn_usuario), 10, ' '), --usuario
                    '20100209641',  --RUC caja
                    t3.aqpb394bcocer, --cod solicitud cofide
                    t1.aocta, --cuenta
                    t1.aooper, --operacion
                    t2.petdoc, --tipo docuemnto
                    t2.pendoc, -- numero documneto
                    t16.v_csbs, --cod sbs
                    nvl(trim(substr(t11.pjrazs,0,60)),substr(concat(trim(t10.pfape1), concat(' ', concat(trim(t10.pfape2), concat(' ',concat(trim(t10.pfnom1), concat(' ', t10.pfnom2)))))),1,60)), --razon social
                    t28.cenom,--aqpb763estd, --estado del credito
                    case when t30.v_fcest > nvl(t1.aofe99,to_date('01/01/0001','DD/MM/YYYY')) then 
                         (case when t30.v_fcest > nvl(t25.v_fech,to_date('01/01/0001','DD/MM/YYYY')) then t30.v_fcest else t25.v_fech end )
                         else (case when nvl(t25.v_fech,to_date('01/01/0001','DD/MM/YYYY')) > nvl(t1.aofe99,to_date('01/01/0001','DD/MM/YYYY')) then t25.v_fech else t1.aofe99 end )end , --fecha de cuando se realizo cambio de estado
                    t18.v_pcre,--aqpb763tcre, --tipo de crdito sbs
                    t18.v_ncre,--aqpb763tpre, -- tipo de prestamo
                    concat(lpad(to_char(t1.aocta), 9, '0'),concat(lpad(to_char(t1.aomda), 3, '0'),lpad(to_char(t1.aooper), 9, '0'))),--aqpb763npre, --numero prestamo
                    t1.aoimp,--aqpb763cdes, -- monto desembolsado
                    t5.v_saldo_inso, --saldo insoluto
                    t20.v_monto_prepago, --monto prepago
                    t3.aqpb394bprccof, --% de cobertura
                    round(t5.v_saldo_inso*t3.aqpb394bprccof,2)/100, --monto de cobertura (saldo isnoluto*%de cobertura)                   
                    
                    t21.v_deccaj,--fecha clasificacion caja
                    t21.v_califa0, --clasificacion  normal
                    t21.v_califa1, --clasificacion  cpp
                    t21.v_califa2, --clasificacion  deficiente
                    t21.v_califa3, --clasificacion  dudoso
                    t21.v_califa4, --clasificacion  perdida
                    t1.aofval, --fecha desembolso
                    t1.aofvto, --fecha fin credito
                    round(floor(t1.aopzo/t1.aoperiod),2),--aqpb763ncuod, --numero de cuotas del crdito
                    0, --periodo de gracia del desembolos
                    t13.v_ncuopa,--aqpb763cuop, --numero de cuotas pagadas
                    t19.v_tsum,--aqpb763mcuop,--monto de cuotas pagadas
                    case when t22.aqpb434fecr is null then 'N' else 'S' end , --credito honrado(s/n)
                    t22.aqpb434fecr, --fecha de honramiento
                    t22.aqpb434mto,--aqpb763mhon, --monto honrado
                    t15.v_diatr, --dias de atraso
                    t1.aotasa,--aqpb763tea,  --tea
                    t30.v_tmor,--aqpb763team, --tasa moratoria
                    case when t17.v_ciuu4 <> 0 then t17.v_ciuu4 else (case when t17.v_ciuu6 <> 0 then to_number(substr(to_char(t17.v_ciuu6), 1, 4)) else 0 end) end, -- ciuu
                    case when t17.v_ciuu4 <> 0 then  substr(trim(t23.actnom1), 1, 60) else  '' end, --actividad economica
                    t14.v_fvenuc,--aqpb763fvnui,--fecha de vencimiento de ultima cuota impaga
                    t12.v_fvenu,--aqpb763fvnup,--fecha de vencimiento de ultima cuota pagada
                    t18.v_ufpago,--aqpb763fpup, --fecha de pago de ultmo pago
                    t19.v_cuo,--pago realizado - capital
                    t19.v_icv, --pago realizado - interes compensatorio
                    t19.v_mor, --pago realizado - interese moratorio
                    t19.v_int, --pago realizado - interes
                    t19.v_pen, --pago realizado - penalidad
                    t19.v_gas,--pago realizado -seguros
                    
                    ld_fecha_rcc,--aqpb763fcsbs,--fecha clasificacion sbs
                    t16.v_calif0, --califiacion sbs normal
                    t16.v_calif1, --califiacion sbs cpp
                    t16.v_calif2, --califiacion sbs deficiente
                    t16.v_calif3, --califiacion sbs dudoso
                    t16.v_calif4, --califiacion sbs perdida
                    
                    substr(t25.v_flag,1,1),--aqpb763repro,--flag reprogramacion
                    t25.v_fech,--aqpb763frpro,--fecha reprogramacion
                    t25.v_nrep,--aqpb763nrpro,--numero de reprogramaciones
                    t25.v_fpri,--aqpb763fprcr,--fecha de primera cuota reprogramacion
                    t25.v_fult,--aqpb763ffnpr,--fecha fin de credito posterior a reprogramacion
                    t25.v_ncuo,--aqpb763ncuor,--numero de cuotas posterior a reprogramacion
                    t25.v_peri,--aqpb763grac, --periodo de gracia posterior a reprogramacion
                    
                    case when t1.aostat = 99 then 'CNC' when t1.aostat = 61 then 'RFN' when substr(t26.scrub, 1, 4) = '1411' then 'VGT'
                         when substr(t26.scrub, 1, 4) = '1421' then 'VGT' when substr(t26.scrub, 1, 4) = '1414' then 'RFN'
                         when substr(t26.scrub, 1, 4) = '1424' then 'RFN' when substr(t26.scrub, 1, 4) = '1415' then 'VCD'
                         when substr(t26.scrub, 1, 4) = '1425' then 'VCD' when substr(t26.scrub, 1, 4) = '1416' then 'JDC'
                         when substr(t26.scrub, 1, 4) = '1426' then 'JDC' when substr(t26.scrub, 1, 4) = '81' then 'CTG'
                         when substr(t26.scrub, 1, 4) = '1413' then 'RTR' when substr(t26.scrub, 1, 4) = '1423' then 'RTR'  else  '' end ,--aqpb763scon, --situacion contable
                    t19.v_cuo,--prepago total
                    case when t1.aofe99 > pd_fecpro then null else t1.aofe99 end, --fecha prepago total
                    CASE WHEN pd_fecpro <= t14.v_fvenuc THEN NULL ELSE t14.v_fvenuc END, --fecha de vencimiento pago mora
                    
                    t1.pgcod, --pgcod
                    t1.aomod, -- modulo
                    t1.aosuc, --sucursal
                    t1.aomda, --moneda
                    t1.aopap, --papel
                    t1.aosbop, --suboperacion
                    t1.aotope, --tipo operacion
                    t8.regnom, --region
                    t9.tp1desc, --zona
                    t6.scnom, --agencia
                    t27.v_ase, --analista
                    t4.v_saldo_actual, --saldo capital
                    t24.v_saldo_honrado,-- SALDO HONRADO
                    t4.v_saldo_actual +t24.v_saldo_honrado, -- SALDO CREDITRO HONRADO = saldo actual +saldo honrado
                    to_char(sysdate, 'DD/MM/YYYY'),
                    to_char(sysdate, 'HH24:MI:SS'),
                    pd_fecpro --fecha proceso
                    from aqpb394b t3                     
                    inner join fsd010 t1 on t3.aqpb394bcod = t1.pgcod and t3.aqpb394bcta = t1.aocta and t3.aqpb394bope = t1.aooper
                    left join fsd011 t26 on t26.pgcod = t1.pgcod  and t26.scmda = t1.aomda and t26.scpap = t1.aopap and t26.sccta = t1.aocta and t26.scoper = t1.aooper and t26.scsbop = t1.aosbop and t26.sctope = t1.aotope and t26.scmod = t1.aomod
                    inner join fsr008 t2 on t2.pgcod = t1.pgcod and t2.ctnro = t1.aocta and t2.cttfir = 'T'
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_actual(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t4 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_insoluto(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro,2,t1.aostat)) t5 on 1=1
                    left join fst001 t6 on t6.pgcod = t1.pgcod and t6.sucurs = t1.aosuc 
                    left join fst811 t7 on t7.pgcod = t1.pgcod and t7.oficod = t1.aosuc and t7.regcod < 100 and t7.regcod <> 0
                    left join fst810 t8 on t8.pgcod = t7.pgcod and t8.regcod = t7.regcod
                    left join fst198 t9 on t9.tp1cod = 1 and t9.tp1cod1 = 10872 and t9.tp1corr1 = 11 and t9.tp1nro2 = t7.regcod
                    left join fsd002 t10 on t10.pfpais = t2.pepais and t10.pftdoc = t2.petdoc and t10.pfndoc = t2.pendoc
                    left join fsd003 t11 on t11.pjpais = t2.pepais and t11.pjtdoc = t2.petdoc and t11.pjndoc = t2.pendoc
                    left join table(pq_cr_reporte_utilitarios.fn_get_fechas_pago(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t12 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_cuota_pago(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,t12.v_fpagu)) t13 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_fvcuo_impaga(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t14 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_dias_atraso(pd_fecpro,t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,t1.aofvto)) t15 on 1=1        
                    left join table(pq_cr_reporte_utilitarios.fn_get_calif_sbs(t2.petdoc,t2.pendoc,pd_fecpro)) t16 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_acti_eco(t2.pepais,t2.petdoc,t2.pendoc)) t17 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_tipo_credito_sbs_vig(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t18 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_distribuc_pago(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t19 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_mprepago(t1.pgcod,t1.aomod,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aotope,pd_fecpro)) t20 on 1=1 
                    left join table(pq_cr_reporte_utilitarios.fn_get_calf_caja(t1.aocta,pd_fecpro)) t21 on 1=1                      
                    left join aqpb434 t22 on t22.aqpb434cod = t1.pgcod and t22.aqpb434mod = t1.aomod and t22.aqpb434suc = t1.aosuc and t22.aqpb434mda = t1.aomda and t22.aqpb434pap = t1.aopap and t22.aqpb434cta = t1.aocta and t22.aqpb434ope = t1.aooper and t22.aqpb434sbo = t1.aosbop and t22.aqpb434top = t1.aotope   
                    left join fst750 t23 on t23.actcod1 = t17.v_ciuu6 
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_honrado(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,9300082070000,pd_fecpro)) t24 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_repro_dato1(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t25 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_analista_credito(t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope)) t27 on 1=1
                    left join fst026 t28 on t28.cecod = t1.aostat
                    left join table(pq_cr_reporte_utilitarios.fn_get_fcamb_estado(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t30 on 1=1
                    where t1.aomod =101
                    and t1.aotope = 356
                    --and t1.aostat <>99
                    and t3.aqpb394best <> 'D'
                    and t1.aofval <= pd_fecpro   ;                     
                    commit;
                    end;
     pq_cr_reporte_faetexco.sp_guardar_historico(pn_usuario, pd_fecpro);
  end sp_cr_sch_faetexco_sinjob;*/
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
  procedure sp_cr_sch_faetexco2(pd_fecpro  in date,
                               pn_suc in number,
                               pn_usuario in varchar2
                               ) is
  ld_fecha_rcc date;
  ln_nro_mes number;  
  ld_fecha date;  
  lc_fmant date;                       
  begin
    
    select to_date(t.tpnro, 'DDMMYY')
      into ld_fecha_rcc
      from fst098 t
     where t.pgcod = 1
       and t.tpcod = 7647
       and t.tpcorr = 12;
  
    -- 1. Nro meses RCC
    begin
      select x.tp1nro1
        into ln_nro_mes
        from fst198 x
       where x.TP1COD = 1
         and x.TP1COD1 = 11144
         and x.TP1CORR1 = 10
         and x.tp1corr2 = 2
         and x.tp1corr3 = 4;
    exception
      when others then
        ln_nro_mes := 1;
    end;
    if pd_fecpro <= ld_fecha_rcc then
      ld_fecha_rcc := last_day(add_months(trunc(pd_fecpro), -1 * ln_nro_mes));
    end if;
    
    --fecha mes anterior
    lc_fmant := trunc(pd_fecpro) - (to_number(to_char(pd_fecpro, 'DD')));
  
    -- Fecha actual
    select t.pgfape into ld_fecha from fst017 t where t.pgcod = 1;
    begin
      insert into aqpc360(  aqpc360usur   ,
  aqpc360rucc   ,
  aqpc360nsol   ,
  aqpc360ncta   ,
  aqpc360nope   ,
  aqpc360npre   ,
  aqpc360fdes   ,
  aqpc360scap   ,
  aqpc360sins   ,
  aqpc360mpre   ,
  aqpc360fclas  ,
  aqpc360cnor   ,
  aqpc360ccpp   ,
  aqpc360cdef   ,
  aqpc360cdud   ,
  aqpc360cper   ,
  aqpc360scon   ,
  aqpc360atru   ,
  aqpc360rgon   ,
  aqpc360zona   ,
  aqpc360agen   ,
  aqpc360anal   ,
  aqpc360tdoc   ,
  aqpc360ndoc   ,
  aqpc360rsoc   ,
  aqpc360nomc   ,
  aqpc360estd   ,
  aqpc360fest   ,
  aqpc360cdes   ,
  aqpc360ncuod  ,
  aqpc360pgra   ,
  aqpc360cobr   ,
  aqpc360mcob   ,
  aqpc360chon   ,
  aqpc360fhon   ,
  aqpc360mhon   ,
  aqpc360datr   ,
  aqpc360finc   ,
  aqpc360ffnc   ,
  aqpc360cpen   ,
  aqpc360fvnui  ,
  aqpc360fvnup  ,
  aqpc360fpup   ,
  aqpc360cuop   ,
  aqpc360mcuop  ,
  aqpc360prcap  ,
  aqpc360pinc   ,
  aqpc360pinm   ,
  aqpc360prin   ,
  aqpc360prpn   ,
  aqpc360prseg  ,
  aqpc360fcsbs  ,
  aqpc360snor   ,
  aqpc360scpp   ,
  aqpc360sdef   ,
  aqpc360sdud   ,
  aqpc360sper   ,
  aqpc360tea    ,
  aqpc360team   ,
  aqpc360ciuu   ,
  aqpc360aeco   ,
  aqpc360tcre   ,
  aqpc360tpre   ,
  aqpc360repro  ,
  aqpc360frpro  ,
  aqpc360nrpro  ,
  aqpc360fprcr  ,
  aqpc360ffnpr  ,
  aqpc360ncuor  ,
  aqpc360grac   ,
  aqpc360ciuo   ,
  aqpc360aecoo  ,
  aqpc360emp    ,
  aqpc360mod    ,
  aqpc360suc    ,
  aqpc360mnda   ,
  aqpc360papl   ,
  aqpc360sbop   ,
  aqpc360tope   ,
  aqpc360mone   ,
  aqpc360sdocap ,
  aqpc360sdohon ,
  aqpc360crehon ,
  aqpc360fcr    ,
  aqpc360hcr    ,
  aqpc360fproc  ,
  aqpc360ncert  ,
  aqpc360codgar ,
  aqpc360codcob ,
  aqpc360sdocre ,
  aqpc360intcom ,
  aqpc360intmor ,
  aqpc360intcov ,
  aqpc360pen    ,
  aqpc360certrn ,
  aqpc360cobren ,
  aqpc360sinsap ,
      aqpc360prpago ,
      aqpc360pagrea ,
      aqpc360pramrt ,
      aqpc360nrccor,
      aqpc360nrccac,
      aqpc360vulcpa,
      aqpc360vcprve,
      aqpc360fuclpr)
             (select rpad(trim(pn_usuario), 10, ' '), --usuario
                    '20100209641',  --RUC caja
                    t3.aqpc360bnsol, --cod solicitud cofide
                    t1.aocta, --cuenta
                    t1.aooper, --operacion
                    concat(lpad(to_char(t1.aocta), 9, '0'),concat(lpad(to_char(t1.aomda), 3, '0'),lpad(to_char(t1.aooper), 9, '0'))),-- --numero prestamo
                    t1.aofval, --fecha desembolso
                    t4.v_saldo_actual, --saldo capital
                    t5.v_saldo_inso, --saldo insoluto
                    t20.v_monto_prepago, --monto prepago
                    t21.v_deccaj,--fecha clasificacion caja
                    t21.v_califa0, --clasificacion  normal
                    t21.v_califa1, --clasificacion  cpp
                    t21.v_califa2, --clasificacion  deficiente
                    t21.v_califa3, --clasificacion  dudoso
                    t21.v_califa4, --clasificacion  perdida
                    case when t1.aostat = 99 then 'CNC' when t1.aostat = 61 then 'RFN' when substr(t26.scrub, 1, 4) = '1411' then 'VGT'
                         when substr(t26.scrub, 1, 4) = '1421' then 'VGT' when substr(t26.scrub, 1, 4) = '1414' then 'RFN'
                         when substr(t26.scrub, 1, 4) = '1424' then 'RFN' when substr(t26.scrub, 1, 4) = '1415' then 'VCD'
                         when substr(t26.scrub, 1, 4) = '1425' then 'VCD' when substr(t26.scrub, 1, 4) = '1416' then 'JDC'
                         when substr(t26.scrub, 1, 4) = '1426' then 'JDC' when substr(t26.scrub, 1, 2) = '81' then 'CTG'
                         when substr(t26.scrub, 1, 4) = '1413' then 'RTR' when substr(t26.scrub, 1, 4) = '1423' then 'RTR'  else  '' end ,--aqpb763scon, --situacion contable
                    t15.v_diatr, --dias de atraso
                    t9.tp1desc, --region
                    t8.regnom, --zona                 
                    t6.scnom, --agencia
                    t27.v_ase, --analista                           
                    case when t3.aqpc360btdocc = 'DNI' then 21 else 9 end,--t2.petdoc, --tipo docuemnto
                    t3.aqpc360bndocc,--t2.pendoc, -- numero documneto
                    trim(substr(t11.pjrazs,0,60)), --razon social
                    substr(concat(trim(t10.pfape1), concat(' ', concat(trim(t10.pfape2), concat(' ',concat(trim(t10.pfnom1), concat(' ', t10.pfnom2)))))),1,60), --nombre del cliente
                    t28.cenom,--estado del credito
                    case when t30.v_fcest > nvl(t1.aofe99,to_date('01/01/0001','DD/MM/YYYY')) then 
                         (case when t30.v_fcest > nvl(t25.v_fech,to_date('01/01/0001','DD/MM/YYYY')) then t30.v_fcest else t25.v_fech end )
                         else (case when nvl(t25.v_fech,to_date('01/01/0001','DD/MM/YYYY')) > nvl(t1.aofe99,to_date('01/01/0001','DD/MM/YYYY')) then t25.v_fech else t1.aofe99 end )end , --fecha de cuando se realizo cambio de estado
                    t1.aoimp,-- monto desembolsado
                    case when t1.aoperiod = 0 then 0 else  round(floor(t1.aopzo/t1.aoperiod),2) end,--numero de cuotas del crdito
                    t31.v_pgra/30, --periodo de gracia del desembolos
                    t3.aqpc360bprccof, --% de cobertura
                    round(t5.v_saldo_inso*t3.aqpc360bprccof,2), --monto de cobertura (saldo isnoluto*%de cobertura)                   
                    case when t22.aqpb434fecr is null then 'N' else 'S' end , --credito honrado(s/n)
                    t22.aqpb434fecr, --fecha de honramiento
                    t22.aqpb434mto,--aqpb763mhon, --monto honrado
                    t15.v_diatr, --dias de atraso
                    t3.aqpc360bfinc,--t36.v_finior,
                    t3.aqpc360bffnc,--t36.v_ffinor,
                    t13.v_ncuopp,--numero de cuota pendientes de pago
                    t14.v_fvenuc,--aqpb763fvnui,--fecha de vencimiento de ultima cuota impaga
                    t12.v_fvenu,--aqpb763fvnup,--fecha de vencimiento de ultima cuota pagada
                    t18.v_ufpago,--aqpb763fpup, --fecha de pago de ultmo pago
                    t13.v_ncuopa,--aqpb763cuop, --numero de cuotas pagadas
                    t19.v_tsum,--aqpb763mcuop,--monto de cuotas pagadas
                    t19.v_cuo,--pago realizado - capital
                    t19.v_icv, --pago realizado - interes compensatorio
                    t19.v_mor, --pago realizado - interese moratorio
                    t19.v_int, --pago realizado - interes
                    t19.v_pen, --pago realizado - penalidad
                    t19.v_gas,--pago realizado -seguros
                    ld_fecha_rcc,--aqpb763fcsbs,--fecha clasificacion sbs
                    t16.v_calif0, --califiacion sbs normal
                    t16.v_calif1, --califiacion sbs cpp
                    t16.v_calif2, --califiacion sbs deficiente
                    t16.v_calif3, --califiacion sbs dudoso
                    t16.v_calif4, --califiacion sbs perdida
                    t1.aotasa,--aqpb763tea,  --tea
                    t30.v_tmor,--aqpb763team, --tasa moratoria
                    case when t17.v_ciuu4 <> 0 then t17.v_ciuu4 else (case when t17.v_ciuu6 <> 0 then to_number(substr(to_char(t17.v_ciuu6), 1, 4)) else 0 end) end, -- ciuu
                    case when t17.v_ciuu4 <> 0 then  substr(trim(t23.actnom1), 1, 60) else  '' end, --actividad economica
                     
                    t18.v_pcre,--aqpb763tcre, --tipo de crdito sbs
                    t18.v_ncre,--aqpb763tpre, -- tipo de prestamo
                    substr(t25.v_flag,1,1),--aqpb763repro,--flag reprogramacion
                    t25.v_fech,--aqpb763frpro,--fecha reprogramacion
                    t25.v_nrep,--aqpb763nrpro,--numero de reprogramaciones
                    t25.v_fpri,--aqpb763fprcr,--fecha de primera cuota reprogramacion
                    t25.v_fult,--aqpb763ffnpr,--fecha fin de credito posterior a reprogramacion
                    t25.v_ncuo,--aqpb763ncuor,--numero de cuotas posterior a reprogramacion
                    t25.v_peri,--aqpb763grac, --periodo de gracia posterior a reprogramacion
                    t3.aqpc360bciuuo, --ciuuo
                    t3.aqpc360bacteco, --actividad economica origen
                    t1.pgcod, --pgcod
                    t1.aomod, -- modulo
                    t1.aosuc, --sucursal
                    t1.aomda, --moneda
                    t1.aopap, --papel
                    t1.aosbop, --suboperacion
                    t1.aotope, --tipo operacion
                    case when t1.aomda = 0 then 'SOLES' else 'DOLARES' end, --moneda desc
                    t4.v_saldo_actual, --saldo capital
                    t24.v_saldo_honrado,-- SALDO HONRADO
                    t4.v_saldo_actual +t24.v_saldo_honrado, -- SALDO CREDITRO HONRADO = saldo actual +saldo honrado
                    to_char(sysdate, 'DD/MM/YYYY'),
                    to_char(sysdate, 'HH24:MI:SS'),
                    pd_fecpro, --fecha proceso
                    t3.aqpc360bncer,
                    t3.aqpc360bcodgar,--aqpc360codgar ,
                    t3.aqpc360bcodcob,--aqpc360codcob ,
                    0,
                    t35.v_intcom,--aqpb394intcom,                    
                    t35.v_intmor,--aqpb394intmor,
                    t35.v_intcov,--aqpb394intcov,
                    t35.v_penali,--aqpb394penali,
                    --0,--aqpc360pen    ,
                    t3.aqpc360bcertrn,--aqpc360certrn ,
                    t3.aqpc360bcobren,--aqpc360cobren
                    t33.v_saldo_inso, --saldo insoluto antes de prpago
                    t35.v_prpago,--aqpb394prpago,
                    t35.v_pagrea,--aqpb394pagrea,
                    t35.v_pramrt,--aqpb394pramrt,
                    t35.v_nrccor,--aqpb394nrccor,
                    t35.v_nrccac,--aqpb394nrccac,
                    t35.v_vulcpa,--aqpb394vulcpa,
                    t35.v_vcprve,--aqpb394vcprve,
                    t35.v_fuclpr--aqpb394fuclpr,
                    --t16.v_csbs, --cod sbs 
                    --t1.aofvto, --fecha fin credito
                    --t32.v_monto_prepago,--prepago total
                    --case when t1.aofe99 > pd_fecpro then null else t1.aofe99 end, --fecha prepago total
                    --CASE WHEN pd_fecpro <= t14.v_fvenuc THEN NULL ELSE t14.v_fvenuc END, --fecha de vencimiento pago mora
                    
                    from aqpc360b t3                     
                    inner join fsd010 t1 on t3.aqpc360bcod = t1.pgcod and t3.aqpc360bcta = t1.aocta and t3.aqpc360bope = t1.aooper
                    left join fsd011 t26 on t26.pgcod = t1.pgcod  and t26.scmda = t1.aomda and t26.scpap = t1.aopap and t26.sccta = t1.aocta and t26.scoper = t1.aooper and t26.scsbop = t1.aosbop and t26.sctope = t1.aotope and t26.scmod = t1.aomod
                    inner join fsr008 t2 on t2.pgcod = t1.pgcod and t2.ctnro = t1.aocta and t2.cttfir = 'T'
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_actual(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t4 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_insoluto(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro,4,t1.aostat)) t5 on 1=1
                    left join fst001 t6 on t6.pgcod = t1.pgcod and t6.sucurs = t1.aosuc 
                    left join fst811 t7 on t7.pgcod = t1.pgcod and t7.oficod = t1.aosuc and t7.regcod < 100 and t7.regcod <> 0
                    left join fst810 t8 on t8.pgcod = t7.pgcod and t8.regcod = t7.regcod
                    left join fst198 t9 on t9.tp1cod = 1 and t9.tp1cod1 = 10872 and t9.tp1corr1 = 11 and t9.tp1nro2 = t7.regcod
                    left join fsd002 t10 on t10.pfpais = t2.pepais and t10.pftdoc = t2.petdoc and t10.pfndoc = t2.pendoc
                    left join fsd003 t11 on t11.pjpais = t2.pepais and t11.pjtdoc = t2.petdoc and t11.pjndoc = t2.pendoc
                    left join table(pq_cr_reporte_utilitarios.fn_get_fechas_pago(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t12 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_cuota_pago(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,t12.v_fvenu)) t13 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_fvcuo_impaga(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t14 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_dias_atraso(pd_fecpro,t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,t1.aofvto)) t15 on 1=1        
                    left join table(pq_cr_reporte_utilitarios.fn_get_calif_sbs(t2.petdoc,t2.pendoc,pd_fecpro)) t16 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_acti_eco(t2.pepais,t2.petdoc,t2.pendoc)) t17 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_tipo_credito_sbs_vig(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t18 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_distribuc_pago(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t19 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_mprepago(t1.pgcod,t1.aomod,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aotope,pd_fecpro)) t20 on 1=1 
                    left join table(pq_cr_reporte_utilitarios.fn_get_calf_caja(t1.aocta,pd_fecpro)) t21 on 1=1                      
                    left join aqpb434 t22 on t22.aqpb434cod = t1.pgcod and t22.aqpb434cta = t1.aocta and t22.aqpb434ope = t1.aooper and t22.aqpb434est = 'C' 
                    left join fst750 t23 on t23.actcod1 = t17.v_ciuu6 
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_honrado(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,9300082070000,pd_fecpro)) t24 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_repro_dato1(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t25 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_analista_credito(t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope)) t27 on 1=1
                    left join fst026 t28 on t28.cecod = t1.aostat
                    left join table(pq_cr_reporte_utilitarios.fn_get_fcamb_estado(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t30 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_pergracia(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t31 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_mprepago_acum(t1.pgcod,t1.aomod,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aotope,pd_fecpro)) t32 on 1=1 
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_insoluto(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,lc_fmant,4,t1.aostat)) t33 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_otros_repfondos(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro,3)) t35 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_fec_creorigen(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope)) t36 on 1=1
                    where t1.aomod in(101,102,200,33)
                    --and t1.aotope in ()
                    and t1.aostat <>99
                    and t3.aqpc360best <> 'D'
                    and t1.aofval <= pd_fecpro   
                    and t1.aosuc = pn_suc
                    
                    union all
                    
                   select rpad(trim(pn_usuario), 10, ' '), --usuario
                    '20100209641',  --RUC caja
                    t3.aqpc360bnsol, --cod solicitud cofide
                    t1.aocta, --cuenta
                    t1.aooper, --operacion
                    concat(lpad(to_char(t1.aocta), 9, '0'),concat(lpad(to_char(t1.aomda), 3, '0'),lpad(to_char(t1.aooper), 9, '0'))),-- --numero prestamo
                    t1.aofval, --fecha desembolso
                    t4.v_saldo_actual, --saldo capital
                    t5.v_saldo_inso, --saldo insoluto
                    t20.v_monto_prepago, --monto prepago
                    t21.v_deccaj,--fecha clasificacion caja
                    t21.v_califa0, --clasificacion  normal
                    t21.v_califa1, --clasificacion  cpp
                    t21.v_califa2, --clasificacion  deficiente
                    t21.v_califa3, --clasificacion  dudoso
                    t21.v_califa4, --clasificacion  perdida
                    case when t1.aostat = 99 then 'CNC' when t1.aostat = 61 then 'RFN' when substr(t26.scrub, 1, 4) = '1411' then 'VGT'
                         when substr(t26.scrub, 1, 4) = '1421' then 'VGT' when substr(t26.scrub, 1, 4) = '1414' then 'RFN'
                         when substr(t26.scrub, 1, 4) = '1424' then 'RFN' when substr(t26.scrub, 1, 4) = '1415' then 'VCD'
                         when substr(t26.scrub, 1, 4) = '1425' then 'VCD' when substr(t26.scrub, 1, 4) = '1416' then 'JDC'
                         when substr(t26.scrub, 1, 4) = '1426' then 'JDC' when substr(t26.scrub, 1, 2) = '81' then 'CTG'
                         when substr(t26.scrub, 1, 4) = '1413' then 'RTR' when substr(t26.scrub, 1, 4) = '1423' then 'RTR'  else  '' end ,--aqpb763scon, --situacion contable
                    t15.v_diatr, --dias de atraso
                    t9.tp1desc, --region
                    t8.regnom, --zona                 
                    t6.scnom, --agencia
                    t27.v_ase, --analista                           
                    case when t3.aqpc360btdocc = 'DNI' then 21 else 9 end,--t2.petdoc, --tipo docuemnto
                    t3.aqpc360bndocc,--t2.pendoc, -- numero documneto
                    trim(substr(t11.pjrazs,0,60)), --razon social
                    substr(concat(trim(t10.pfape1), concat(' ', concat(trim(t10.pfape2), concat(' ',concat(trim(t10.pfnom1), concat(' ', t10.pfnom2)))))),1,60), --nombre del cliente
                    t28.cenom,--estado del credito
                    case when t30.v_fcest > nvl(t1.aofe99,to_date('01/01/0001','DD/MM/YYYY')) then 
                         (case when t30.v_fcest > nvl(t25.v_fech,to_date('01/01/0001','DD/MM/YYYY')) then t30.v_fcest else t25.v_fech end )
                         else (case when nvl(t25.v_fech,to_date('01/01/0001','DD/MM/YYYY')) > nvl(t1.aofe99,to_date('01/01/0001','DD/MM/YYYY')) then t25.v_fech else t1.aofe99 end )end , --fecha de cuando se realizo cambio de estado
                    t1.aoimp,-- monto desembolsado
                    case when t1.aoperiod = 0 then 0 else  round(floor(t1.aopzo/t1.aoperiod),2) end,--numero de cuotas del crdito
                    t31.v_pgra/30, --periodo de gracia del desembolos
                    t3.aqpc360bprccof, --% de cobertura
                    round(t5.v_saldo_inso*t3.aqpc360bprccof,2), --monto de cobertura (saldo isnoluto*%de cobertura)                   
                    case when t22.aqpb434fecr is null then 'N' else 'S' end , --credito honrado(s/n)
                    t22.aqpb434fecr, --fecha de honramiento
                    t22.aqpb434mto,--aqpb763mhon, --monto honrado
                    t15.v_diatr, --dias de atraso
                    t3.aqpc360bfinc,--t36.v_finior,
                    t3.aqpc360bffnc,--t36.v_ffinor,
                    t13.v_ncuopp,--numero de cuota pendientes de pago
                    t14.v_fvenuc,--aqpb763fvnui,--fecha de vencimiento de ultima cuota impaga
                    t12.v_fvenu,--aqpb763fvnup,--fecha de vencimiento de ultima cuota pagada
                    t18.v_ufpago,--aqpb763fpup, --fecha de pago de ultmo pago
                    t13.v_ncuopa,--aqpb763cuop, --numero de cuotas pagadas
                    t19.v_tsum,--aqpb763mcuop,--monto de cuotas pagadas
                    t19.v_cuo,--pago realizado - capital
                    t19.v_icv, --pago realizado - interes compensatorio
                    t19.v_mor, --pago realizado - interese moratorio
                    t19.v_int, --pago realizado - interes
                    t19.v_pen, --pago realizado - penalidad
                    t19.v_gas,--pago realizado -seguros
                    ld_fecha_rcc,--aqpb763fcsbs,--fecha clasificacion sbs
                    t16.v_calif0, --califiacion sbs normal
                    t16.v_calif1, --califiacion sbs cpp
                    t16.v_calif2, --califiacion sbs deficiente
                    t16.v_calif3, --califiacion sbs dudoso
                    t16.v_calif4, --califiacion sbs perdida
                    t1.aotasa,--aqpb763tea,  --tea
                    t30.v_tmor,--aqpb763team, --tasa moratoria
                    case when t17.v_ciuu4 <> 0 then t17.v_ciuu4 else (case when t17.v_ciuu6 <> 0 then to_number(substr(to_char(t17.v_ciuu6), 1, 4)) else 0 end) end, -- ciuu
                    case when t17.v_ciuu4 <> 0 then  substr(trim(t23.actnom1), 1, 60) else  '' end, --actividad economica
                     
                    t18.v_pcre,--aqpb763tcre, --tipo de crdito sbs
                    t18.v_ncre,--aqpb763tpre, -- tipo de prestamo
                    substr(t25.v_flag,1,1),--aqpb763repro,--flag reprogramacion
                    t25.v_fech,--aqpb763frpro,--fecha reprogramacion
                    t25.v_nrep,--aqpb763nrpro,--numero de reprogramaciones
                    t25.v_fpri,--aqpb763fprcr,--fecha de primera cuota reprogramacion
                    t25.v_fult,--aqpb763ffnpr,--fecha fin de credito posterior a reprogramacion
                    t25.v_ncuo,--aqpb763ncuor,--numero de cuotas posterior a reprogramacion
                    t25.v_peri,--aqpb763grac, --periodo de gracia posterior a reprogramacion
                    t3.aqpc360bciuuo, --ciuuo
                    t3.aqpc360bacteco, --actividad economica origen
                    t1.pgcod, --pgcod
                    t1.aomod, -- modulo
                    t1.aosuc, --sucursal
                    t1.aomda, --moneda
                    t1.aopap, --papel
                    t1.aosbop, --suboperacion
                    t1.aotope, --tipo operacion
                    case when t1.aomda = 0 then 'SOLES' else 'DOLARES' end, --moneda desc
                    t4.v_saldo_actual, --saldo capital
                    t24.v_saldo_honrado,-- SALDO HONRADO
                    t4.v_saldo_actual +t24.v_saldo_honrado, -- SALDO CREDITRO HONRADO = saldo actual +saldo honrado
                    to_char(sysdate, 'DD/MM/YYYY'),
                    to_char(sysdate, 'HH24:MI:SS'),
                    pd_fecpro, --fecha proceso
                    t3.aqpc360bncer,
                    t3.aqpc360bcodgar,--aqpc360codgar ,
                    t3.aqpc360bcodcob,--aqpc360codcob ,
                    0,--aqpc360sdocre ,
                    t35.v_intcom,--aqpb394intcom,                    
                    t35.v_intmor,--aqpb394intmor,
                    t35.v_intcov,--aqpb394intcov,
                    t35.v_penali,--aqpb394penali,
                    t3.aqpc360bcertrn,--aqpc360certrn ,
                    t3.aqpc360bcobren,--aqpc360cobren
                    t33.v_saldo_inso, --saldo insoluto antes de prpago
                    t35.v_prpago,--aqpb394prpago,
                    t35.v_pagrea,--aqpb394pagrea,
                    t35.v_pramrt,--aqpb394pramrt,
                    t35.v_nrccor,--aqpb394nrccor,
                    t35.v_nrccac,--aqpb394nrccac,
                    t35.v_vulcpa,--aqpb394vulcpa,
                    t35.v_vcprve,--aqpb394vcprve,
                    t35.v_fuclpr--aqpb394fuclpr,
                    --t16.v_csbs, --cod sbs 
                    --t1.aofvto, --fecha fin credito
                    --t32.v_monto_prepago,--prepago total
                    --case when t1.aofe99 > pd_fecpro then null else t1.aofe99 end, --fecha prepago total
                    --CASE WHEN pd_fecpro <= t14.v_fvenuc THEN NULL ELSE t14.v_fvenuc END, --fecha de vencimiento pago mora
                    
                    from aqpc360b t3                     
                    inner join fsd010 t1 on t3.aqpc360bcod = t1.pgcod and t3.aqpc360bcta = t1.aocta and t3.aqpc360bope = t1.aooper
                    left join fsd011 t26 on t26.pgcod = t1.pgcod  and t26.scmda = t1.aomda and t26.scpap = t1.aopap and t26.sccta = t1.aocta and t26.scoper = t1.aooper and t26.scsbop = t1.aosbop and t26.sctope = t1.aotope and t26.scmod = t1.aomod
                    inner join fsr008 t2 on t2.pgcod = t1.pgcod and t2.ctnro = t1.aocta and t2.cttfir = 'T'
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_actual(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t4 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_insoluto(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro,4,t1.aostat)) t5 on 1=1
                    left join fst001 t6 on t6.pgcod = t1.pgcod and t6.sucurs = t1.aosuc 
                    left join fst811 t7 on t7.pgcod = t1.pgcod and t7.oficod = t1.aosuc and t7.regcod < 100 and t7.regcod <> 0
                    left join fst810 t8 on t8.pgcod = t7.pgcod and t8.regcod = t7.regcod
                    left join fst198 t9 on t9.tp1cod = 1 and t9.tp1cod1 = 10872 and t9.tp1corr1 = 11 and t9.tp1nro2 = t7.regcod
                    left join fsd002 t10 on t10.pfpais = t2.pepais and t10.pftdoc = t2.petdoc and t10.pfndoc = t2.pendoc
                    left join fsd003 t11 on t11.pjpais = t2.pepais and t11.pjtdoc = t2.petdoc and t11.pjndoc = t2.pendoc
                    left join table(pq_cr_reporte_utilitarios.fn_get_fechas_pago(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t12 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_cuota_pago(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,t12.v_fvenu)) t13 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_fvcuo_impaga(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t14 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_dias_atraso(pd_fecpro,t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,t1.aofvto)) t15 on 1=1        
                    left join table(pq_cr_reporte_utilitarios.fn_get_calif_sbs(t2.petdoc,t2.pendoc,pd_fecpro)) t16 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_acti_eco(t2.pepais,t2.petdoc,t2.pendoc)) t17 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_tipo_credito_sbs_vig(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t18 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_distribuc_pago(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t19 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_mprepago(t1.pgcod,t1.aomod,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aotope,pd_fecpro)) t20 on 1=1 
                    left join table(pq_cr_reporte_utilitarios.fn_get_calf_caja(t1.aocta,pd_fecpro)) t21 on 1=1                      
                    left join aqpb434 t22 on t22.aqpb434cod = t1.pgcod and t22.aqpb434cta = t1.aocta and t22.aqpb434ope = t1.aooper and t22.aqpb434est = 'C' 
                    left join fst750 t23 on t23.actcod1 = t17.v_ciuu6 
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_honrado(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,9300082070000,pd_fecpro)) t24 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_repro_dato1(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t25 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_analista_credito(t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope)) t27 on 1=1
                    left join fst026 t28 on t28.cecod = t1.aostat
                    left join table(pq_cr_reporte_utilitarios.fn_get_fcamb_estado(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t30 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_pergracia(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t31 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_mprepago_acum(t1.pgcod,t1.aomod,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aotope,pd_fecpro)) t32 on 1=1 
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_insoluto(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,lc_fmant,4,t1.aostat)) t33 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_otros_repfondos(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro,3)) t35 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_fec_creorigen(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope)) t36 on 1=1
                    where t1.aomod in(101,102,200,33)
                    --and t1.aotope in (356,357)
                    and t1.aostat  = 99
                    and not exists
       (select 'x'
          from fsd010 l
         where l.pgcod = t1.pgcod
           and l.aomda = t1.aomda
           and l.aopap = t1.aopap
           and l.aocta = t1.aocta
           and l.aooper = t1.aooper
              --and l.aomod <> 419
           and l.aomod in (select modulo
                             from fst111
                            where dscod = 50
                              and modulo not in (29, 120, 144))
           and l.aostat <> 99)
      
       and  t1.aofe99 =
       (select max(h.aofe99)
          from fsd010 h
         where h.pgcod = t1.pgcod
           --and h.aomod = t1.aomod
              --and h.aosuc = t.aosuc -- jrodriguej 28.06.2021
           and h.aomda = t1.aomda
           and h.aopap = t1.aopap
           and h.aocta = t1.aocta
           and h.aooper = t1.aooper
              --and r.scsbop = t.aosbop
              --and h.aotope = t.aotope
           --and h.aofe99 <= pd_fecpro  
              --and h.aomod <> 419
           and h.aomod in (select modulo
                             from fst111
                            where dscod = 50
                              and modulo not in (29, 120, 144)))
                    and t3.aqpc360best <> 'D'
                    and t1.aofval <= pd_fecpro   
                    and t1.aosuc = pn_suc
                    );                     
                    commit;
	 exception when others then null;
     end;
     
  end sp_cr_sch_faetexco2;
  -----------------------------------------------------------------------
  procedure sp_guardar_historico(pn_usuario char,
                                 pn_fcorte  date) is
  
    pn_fcarga date;
    lc_coderr char(100);
    lc_msgerr char(1000);
  
  begin
  
    select t.pgfape into pn_fcarga from fst017 t where t.pgcod = 1;
  
    
      
        delete from aqpc360h t
         where t.aqpc360husur = pn_usuario
           and t.aqpc360hfproc = pn_fcorte
           ;
        commit;
      
        begin
        
          insert into aqpc360h
          (  aqpc360husur   ,
  aqpc360hrucc   ,
  aqpc360hnsol   ,
  aqpc360hncta   ,
  aqpc360hnope   ,
  aqpc360hnpre   ,
  aqpc360hfdes   ,
  aqpc360hscap   ,
  aqpc360hsins   ,
  aqpc360hmpre   ,
  aqpc360hfclas  ,
  aqpc360hcnor   ,
  aqpc360hccpp   ,
  aqpc360hcdef   ,
  aqpc360hcdud   ,
  aqpc360hcper   ,
  aqpc360hscon   ,
  aqpc360hatru   ,
  aqpc360hrgon   ,
  aqpc360hzona   ,
  aqpc360hagen   ,
  aqpc360hanal   ,
  aqpc360htdoc   ,
  aqpc360hndoc   ,
  aqpc360hrsoc   ,
  aqpc360hnomc   ,
  aqpc360hestd   ,
  aqpc360hfest   ,
  aqpc360hcdes   ,
  aqpc360hncuod  ,
  aqpc360hpgra   ,
  aqpc360hcobr   ,
  aqpc360hmcob   ,
  aqpc360hchon   ,
  aqpc360hfhon   ,
  aqpc360hmhon   ,
  aqpc360hdatr   ,
  aqpc360hfinc   ,
  aqpc360hffnc   ,
  aqpc360hcpen   ,
  aqpc360hfvnui  ,
  aqpc360hfvnup  ,
  aqpc360hfpup   ,
  aqpc360hcuop   ,
  aqpc360hmcuop  ,
  aqpc360hprcap  ,
  aqpc360hpinc   ,
  aqpc360hpinm   ,
  aqpc360hprin   ,
  aqpc360hprpn   ,
  aqpc360hprseg  ,
  aqpc360hfcsbs  ,
  aqpc360hsnor   ,
  aqpc360hscpp   ,
  aqpc360hsdef   ,
  aqpc360hsdud   ,
  aqpc360hsper   ,
  aqpc360htea    ,
  aqpc360hteam   ,
  aqpc360hciuu   ,
  aqpc360haeco   ,
  aqpc360htcre   ,
  aqpc360htpre   ,
  aqpc360hrepro  ,
  aqpc360hfrpro  ,
  aqpc360hnrpro  ,
  aqpc360hfprcr  ,
  aqpc360hffnpr  ,
  aqpc360hncuor  ,
  aqpc360hgrac   ,
  aqpc360hciuo   ,
  aqpc360haecoo  ,
  aqpc360hemp    ,
  aqpc360hmod    ,
  aqpc360hsuc    ,
  aqpc360hmnda   ,
  aqpc360hpapl   ,
  aqpc360hsbop   ,
  aqpc360htope   ,
  aqpc360hmone   ,
  aqpc360hsdocap ,
  aqpc360hsdohon ,
  aqpc360hcrehon ,
  aqpc360hfcr    ,
  aqpc360hhcr    ,
  aqpc360hfproc  ,
  aqpc360hncert  ,
  aqpc360hcodgar ,
  aqpc360hcodcob ,
  aqpc360hsdocre ,
  aqpc360hintcom ,
  aqpc360hintmor ,
  aqpc360hintcov ,
  aqpc360hpen    ,
  aqpc360hcertrn ,
  aqpc360hcobren ,
  aqpc360hsinsap ,
      aqpc360hprpago ,
      aqpc360hpagrea ,
      aqpc360hpramrt ,
      aqpc360hnrccor,
      aqpc360hnrccac,
      aqpc360hvulcpa,
      aqpc360hvcprve,
      aqpc360hfuclpr)
          select   aqpc360usur   ,
  aqpc360rucc   ,
  aqpc360nsol   ,
  aqpc360ncta   ,
  aqpc360nope   ,
  aqpc360npre   ,
  aqpc360fdes   ,
  aqpc360scap   ,
  aqpc360sins   ,
  aqpc360mpre   ,
  aqpc360fclas  ,
  aqpc360cnor   ,
  aqpc360ccpp   ,
  aqpc360cdef   ,
  aqpc360cdud   ,
  aqpc360cper   ,
  aqpc360scon   ,
  aqpc360atru   ,
  aqpc360rgon   ,
  aqpc360zona   ,
  aqpc360agen   ,
  aqpc360anal   ,
  aqpc360tdoc   ,
  aqpc360ndoc   ,
  aqpc360rsoc   ,
  aqpc360nomc   ,
  aqpc360estd   ,
  aqpc360fest   ,
  aqpc360cdes   ,
  aqpc360ncuod  ,
  aqpc360pgra   ,
  aqpc360cobr   ,
  aqpc360mcob   ,
  aqpc360chon   ,
  aqpc360fhon   ,
  aqpc360mhon   ,
  aqpc360datr   ,
  aqpc360finc   ,
  aqpc360ffnc   ,
  aqpc360cpen   ,
  aqpc360fvnui  ,
  aqpc360fvnup  ,
  aqpc360fpup   ,
  aqpc360cuop   ,
  aqpc360mcuop  ,
  aqpc360prcap  ,
  aqpc360pinc   ,
  aqpc360pinm   ,
  aqpc360prin   ,
  aqpc360prpn   ,
  aqpc360prseg  ,
  aqpc360fcsbs  ,
  aqpc360snor   ,
  aqpc360scpp   ,
  aqpc360sdef   ,
  aqpc360sdud   ,
  aqpc360sper   ,
  aqpc360tea    ,
  aqpc360team   ,
  aqpc360ciuu   ,
  aqpc360aeco   ,
  aqpc360tcre   ,
  aqpc360tpre   ,
  aqpc360repro  ,
  aqpc360frpro  ,
  aqpc360nrpro  ,
  aqpc360fprcr  ,
  aqpc360ffnpr  ,
  aqpc360ncuor  ,
  aqpc360grac   ,
  aqpc360ciuo   ,
  aqpc360aecoo  ,
  aqpc360emp    ,
  aqpc360mod    ,
  aqpc360suc    ,
  aqpc360mnda   ,
  aqpc360papl   ,
  aqpc360sbop   ,
  aqpc360tope   ,
  aqpc360mone   ,
  aqpc360sdocap ,
  aqpc360sdohon ,
  aqpc360crehon ,
  aqpc360fcr    ,
  aqpc360hcr    ,
  aqpc360fproc  ,
  aqpc360ncert  ,
  aqpc360codgar ,
  aqpc360codcob ,
  aqpc360sdocre ,
  aqpc360intcom ,
  aqpc360intmor ,
  aqpc360intcov ,
  aqpc360pen    ,
  aqpc360certrn ,
  aqpc360cobren ,
  aqpc360sinsap ,
      aqpc360prpago ,
      aqpc360pagrea ,
      aqpc360pramrt ,
      aqpc360nrccor,
      aqpc360nrccac,
      aqpc360vulcpa,
      aqpc360vcprve,
      aqpc360fuclpr
 from aqpc360
where aqpc360usur = pn_usuario;

commit;
        
        exception
          when others then
          
            lc_coderr := sqlcode;
            lc_msgerr := trim(sqlerrm);
          
        end;
 end sp_guardar_historico;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_cr_sch_faetexco(pd_fecpro  in date,
                               pn_usuario in varchar2                               
                               ) is
  
    ln_ini      number;
    lc_variable varchar2(4000);
    ln_job      number := 0;
    lc_fecpro   char(10);
    lc_hostname varchar2(64);
  
    pi_vc2_nomjob varchar2(65);
    lc_prefjob    varchar2(64);
    ln_numjob     number(9) := 0;
    lc_user       varchar(5);
    lc_prefijo    varchar(10);
    x             number;
    lb_njobs      number(3);
  
    lc_paquete    varchar2(50);
    lc_proceso    varchar2(50);
    job_id        number;
    lc_nomusr     varchar2(50);
    lc_pac_nombre varchar2(100);
  
    cursor sucursal is
      select *
        from fst001
       where pgcod = 1
         and sucurs < 800
      ;
  
  begin
  
    begin
      delete from aqpc360 x
       where x.aqpc360usur = rpad(trim(pn_usuario), 10, ' ');
      commit;
	exception when others then null;
    end;
    begin
      select TRIM(TP1DESC)
        INTO lc_nomusr
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10847
         and tp1corr1 = 999; ---2019.07.22 guia de proceso para hostname
	exception when others then null;
    end;
  
    select x.tp1nro1
      into lb_njobs
      from fst198 x
     where x.TP1COD = 1
       and x.TP1COD1 = 11144
       and x.TP1CORR1 = 10
       and x.tp1corr2 = 2
       and x.tp1corr3 = 3;
  
    begin
      select host_name into lc_hostname from v$instance;
	exception when others then null;
    end; 
    
  
    lc_user       := substr(pn_usuario, 1, 5);
    lc_prefijo    := 'FTEX' || lc_user;
    lc_paquete    := 'pq_cr_reporte_faetexco';
    lc_proceso    := 'sp_cr_sch_faetexco2';
    lc_pac_nombre := trim(lc_paquete) || '.' || trim(lc_proceso);
  
    lc_fecpro := to_char(pd_fecpro, 'RRRR.MM.DD');
  
    ---carga diaria
    for i in sucursal loop
      ln_ini := i.sucurs;
      ln_job := ln_job + 1;      
      lc_prefjob    := lc_prefijo;
      pi_vc2_nomjob := lc_prefjob || to_char(pd_fecpro, 'ddmmrrrr') ||
                       lpad(ln_ini, 3, '0'); ---ln_job
      lc_variable   := 'begin ' ||
                       '  pq_cr_reporte_faetexco.sp_cr_sch_faetexco2( TO_DATE(''' ||
                       lc_fecpro || ''',''RRRR.MM.DD''),' || ln_ini ||
                       ',''' || pn_usuario || ''' );' || ' End;';
    
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        
      
        dbms_job.submit(job_id,
                        what      => lc_variable,
                        next_date => sysdate,
                        interval  => null,
                        no_parse  => false,
                      --  instance  => 2,
                        instance  => 1,
                        force     => false);
      
      Else
        
        dbms_job.submit(job_id,
                        what      => lc_variable,
                        next_date => sysdate,
                        interval  => null,
                        no_parse  => false,
                        force     => false);
      
      End If;
      commit;
    
      
    
      SELECT count(*)
        INTO x
        FROM dba_jobs x
       WHERE x.schema_user = lc_nomusr -- 'BANTPROD'
         AND x.what LIKE '%' || trim(lc_pac_nombre) || '%'
         AND x.what LIKE '%' || trim(pn_usuario) || '%';
    
      while x = lb_njobs loop
        --- Parametrizar              BANTPROD
        SELECT count(*)
          INTO x
          FROM dba_jobs x
         WHERE x.schema_user = lc_nomusr -- 'BANTPROD'
           AND x.what LIKE '%' || trim(lc_pac_nombre) || '%'
           AND x.what LIKE '%' || trim(pn_usuario) || '%';
      
      end loop;
    
      INSERT INTO Tab_jobs
        (c_codage, n_Numer1, c_detjob) --VARCHAR(10),NUMBER,VARCHAR(500)
      VALUES
      
        (lc_prefijo, ln_ini, lc_variable);
      COMMIT;
    
    end loop;
  
    ln_numjob := pq_cr_reporte_fondos.fn_cr_verifica_tarea2(lc_prefjob,
                                                            lc_hostname,
                                                            lc_paquete,
                                                            lc_proceso,
                                                            pn_usuario);
  
    While ln_numjob > 0 loop
      ln_numjob := pq_cr_reporte_fondos.fn_cr_verifica_tarea2(lc_prefjob,
                                                              lc_hostname,
                                                              lc_paquete,
                                                              lc_proceso,
                                                              pn_usuario);
    End loop;
  
    -- Registro de histórico   
    pq_cr_reporte_faetexco.sp_guardar_historico(pn_usuario, pd_fecpro);
  
      
  
  end sp_cr_sch_faetexco;
end pq_cr_reporte_faetexco;
/

