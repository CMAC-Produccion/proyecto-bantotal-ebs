create or replace package pq_cr_rep_fondos_faeturismo is

  -- Author  : RMONTESR
  -- Created : 6/12/2021 12:34:36
  -- Purpose : Paquete para reporte de fondos Fae Turismo

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
  procedure sp_cr_sch_turismo_sinjob(pd_fecpro in date, pn_usuario in varchar2);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
  procedure sp_cr_sch_turismo2(pd_fecpro  in date,
                               pn_suc in number,
                               pn_usuario in varchar2
                               );
  -----------------------------------------------------------------------
  procedure sp_guardar_historico(pn_usuario char, pn_fcorte date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_cr_sch_turismo(pd_fecpro  in date,
                               pn_usuario in varchar2                               
                               );
end pq_cr_rep_fondos_faeturismo;
/

create or replace package body pq_cr_rep_fondos_faeturismo is

 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
  procedure sp_cr_sch_turismo_sinjob(pd_fecpro  in date,
                               pn_usuario in varchar2
                               ) is
  ld_fecha_rcc date;
  ln_nro_mes number;  
  ld_fecha date;                         
  begin
    begin
      delete from aqpb763 x
       where x.aqpb763usur = rpad(trim(pn_usuario), 10, ' ');
      commit;
    exception
      when others then null;
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
      insert into aqpb763(aqpb763usur,
aqpb763rucc,
aqpb763nsol,
aqpb763ncta,
aqpb763nope,
aqpb763npre,
aqpb763fdes,
aqpb763scap,
aqpb763sins,
aqpb763mpre,
aqpb763fclas,
aqpb763cnor,
aqpb763ccpp,
aqpb763cdef,
aqpb763cdud,
aqpb763cper,
aqpb763scon,
aqpb763atru,
aqpb763rgon,
aqpb763zona,
aqpb763agen,
aqpb763anal,
aqpb763tdoc,
aqpb763ndoc,
aqpb763rsoc,
aqpb763nomc,
aqpb763estd,
aqpb763fest,
aqpb763cdes,
aqpb763ncuod,
aqpb763pgra,
aqpb763cobr,
aqpb763mcob,
aqpb763chon,
aqpb763fhon,
aqpb763mhon,
aqpb763datr,
aqpb763finc,
aqpb763ffnc,
aqpb763cpen,
aqpb763fvnui,
aqpb763fvnup,
aqpb763fpup,
aqpb763cuop,
aqpb763mcuop,
aqpb763prcap,
aqpb763pinc,
aqpb763pinm,
aqpb763prin,
aqpb763prpn,
aqpb763prseg,
aqpb763fcsbs,
aqpb763snor,
aqpb763scpp,
aqpb763sdef,
aqpb763sdud,
aqpb763sper,
aqpb763tea,
aqpb763team,
aqpb763ciuu,
aqpb763aeco,
aqpb763tcre,
aqpb763tpre,
aqpb763repro,
aqpb763frpro,
aqpb763nrpro,
aqpb763fprcr,
aqpb763ffnpr,
aqpb763ncuor,
aqpb763grac,
aqpb763ciuo,
aqpb763aecoo,
aqpb763emp,
aqpb763mod,
aqpb763suc,
aqpb763mnda,
aqpb763papl,
aqpb763sbop,
aqpb763tope,
AQPB763MONE,
AQPB763SDOCAP,
AQPB763SDOHON,
AQPB763CREHON,
AQPB763FCR,
AQPB763HCR,
AQPB763FPROC)
             select rpad(trim(pn_usuario), 10, ' '), --usuario
                    '20100209641',  --RUC caja
                    t3.aqpb762bcsol, --cod solicitud cofide
                    t1.aocta, --cuenta
                    t1.aooper, --operacion
                    concat(lpad(to_char(t1.aocta), 9, '0'),concat(lpad(to_char(t1.aomda), 3, '0'),lpad(to_char(t1.aooper), 9, '0'))),--aqpb763npre, --numero prestamo
                    t1.aofval,--aqpb763fdes, --fecha de desembolso
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
                         when substr(t26.scrub, 1, 4) = '1426' then 'JDC' when substr(t26.scrub, 1, 4) = '81' then 'CTG'
                         when substr(t26.scrub, 1, 4) = '1413' then 'RTR' when substr(t26.scrub, 1, 4) = '1423' then 'RTR'  else  '' end ,--aqpb763scon, --situacion contable
                    t12.v_diatr,--aqpb763atru, --dias atraso ultimacuota pagada
                    t9.tp1desc, --region
                    t8.regnom, --zona
                    
                    t6.scnom, --agencia
                    t27.v_ase, --analista
                    case when t2.petdoc = 21 then 'DNI' else 'RUC' end, --tipo doc
                    t2.pendoc, -- numero doc
                    t11.pjrazs, --razon social
                    substr(concat(trim(t10.pfape1), concat(' ', concat(trim(t10.pfape2), concat(' ',concat(trim(t10.pfnom1), concat(' ', t10.pfnom2)))))),1,70), --apellidos y nombres del cliente
                    t28.cenom,--aqpb763estd, --estado del credito
                    case when t30.v_fcest > nvl(t1.aofe99,to_date('01/01/0001','DD/MM/YYYY')) then 
                         (case when t30.v_fcest > nvl(t25.v_fech,to_date('01/01/0001','DD/MM/YYYY')) then t30.v_fcest else t25.v_fech end )
                         else (case when nvl(t25.v_fech,to_date('01/01/0001','DD/MM/YYYY')) > nvl(t1.aofe99,to_date('01/01/0001','DD/MM/YYYY')) then t25.v_fech else t1.aofe99 end )end ,--aqpb763fest, --fecha de cuando se realizo cambio de estado
                    t1.aoimp,--aqpb763cdes, -- monto desembolsado
                    floor(t1.aopzo/t1.aoperiod),--aqpb763ncuod, -- numero de cuotas del desembolso
                    t3.aqpb762bgrci,--aqpb763pgra, --periodo de gracia del desembolos
                    t3.aqpb762bpcob*100, --% de cobertura
                    round(t5.v_saldo_inso*t3.aqpb762bpcob,2), --monto de cobertura (saldo isnoluto*%de cobertura)
                    case when t22.aqpb434fecr is null then 'N' else 'S' end , --credito honrado(s/n)
                    t22.aqpb434fecr, --fecha de honramiento
                    t22.aqpb434mto,--aqpb763mhon, --monto honrado
                    t15.v_diatr, --dias de atraso
                    t3.aqpb762bfico, --fecha inicio credito original(cofide)
                    t3.aqpb762bffco, --fecha fin credito original(cofide)
                    t13.v_ncuopp,--aqpb763cpen, --numero de cuotas pendientes de pago
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
                    
                    t3.aqpb762bciuo, --ciuu origen
                    substr(trim(t3.aqpb762baeco), 1, 60),--acti economica origen
                    t1.pgcod, --pgcod
                    t1.aomod, -- modulo
                    t1.aosuc, --sucursal
                    t1.aomda, --moneda
                    t1.aopap, --papel
                    t1.aosbop, --suboperacion
                    t1.aotope, --tipo operacion
                    'PEN',--AQPB763MONE,
                    t4.v_saldo_actual, --saldo capital
                    t24.v_saldo_honrado,-- SALDO HONRADO
                    t4.v_saldo_actual + t24.v_saldo_honrado, -- SALDO CREDITRO HONRADO = saldo actual +saldo honrado
                    to_char(sysdate, 'DD/MM/YYYY'),
                    to_char(sysdate, 'HH24:MI:SS'),
                    pd_fecpro --fecha proceso
                    from aqpb762b t3                    
                    inner join fsd010 t1 on t3.aqpb762bcod = t1.pgcod and t3.aqpb762bccta = t1.aocta and t3.aqpb762boper = t1.aooper
                    left join fsd011 t26 on t26.pgcod = t1.pgcod and t26.scmda = t1.aomda and t26.scpap = t1.aopap and t26.sccta = t1.aocta and t26.scoper = t1.aooper and t26.scsbop = t1.aosbop and t26.sctope = t1.aotope and t26.scmod = t1.aomod
                    inner join fsr008 t2 on t2.pgcod = t1.pgcod and t2.ctnro = t1.aocta and t2.cttfir = 'T'
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_actual(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t4 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_insoluto(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro,1,t1.aostat)) t5 on 1=1
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
                    left join fst750 t29 on t29.actcod1 = to_number(nvl(trim(t3.aqpb762bciuo),'0000'))
                    left join table(pq_cr_reporte_utilitarios.fn_get_fcamb_estado(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t30 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_fec_creorigen(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope)) t36 on 1=1
                    where t1.aomod =101
                    and t1.aotope = 355 --fae turismo
                    --and t1.aostat <>99
                    and t3.aqpb762best <> 'D'
                    and t1.aofval <= pd_fecpro   ;                  
                    commit;
                    exception
                        when others then null;
                    end;
     pq_cr_rep_fondos_faeturismo.sp_guardar_historico(pn_usuario, pd_fecpro);
  end sp_cr_sch_turismo_sinjob;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
  procedure sp_cr_sch_turismo2(pd_fecpro  in date,
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
      insert into aqpb763(aqpb763usur,
aqpb763rucc,
aqpb763nsol,
aqpb763ncta,
aqpb763nope,
aqpb763npre,
aqpb763fdes,
aqpb763scap,
aqpb763sins,
aqpb763mpre,
aqpb763fclas,
aqpb763cnor,
aqpb763ccpp,
aqpb763cdef,
aqpb763cdud,
aqpb763cper,
aqpb763scon,
aqpb763atru,
aqpb763rgon,
aqpb763zona,
aqpb763agen,
aqpb763anal,
aqpb763tdoc,
aqpb763ndoc,
aqpb763rsoc,
aqpb763nomc,
aqpb763estd,
aqpb763fest,
aqpb763cdes,
aqpb763ncuod,
aqpb763pgra,
aqpb763cobr,
aqpb763mcob,
aqpb763chon,
aqpb763fhon,
aqpb763mhon,
aqpb763datr,
aqpb763finc,
aqpb763ffnc,
aqpb763cpen,
aqpb763fvnui,
aqpb763fvnup,
aqpb763fpup,
aqpb763cuop,
aqpb763mcuop,
aqpb763prcap,
aqpb763pinc,
aqpb763pinm,
aqpb763prin,
aqpb763prpn,
aqpb763prseg,
aqpb763fcsbs,
aqpb763snor,
aqpb763scpp,
aqpb763sdef,
aqpb763sdud,
aqpb763sper,
aqpb763tea,
aqpb763team,
aqpb763ciuu,
aqpb763aeco,
aqpb763tcre,
aqpb763tpre,
aqpb763repro,
aqpb763frpro,
aqpb763nrpro,
aqpb763fprcr,
aqpb763ffnpr,
aqpb763ncuor,
aqpb763grac,
aqpb763ciuo,
aqpb763aecoo,
aqpb763emp,
aqpb763mod,
aqpb763suc,
aqpb763mnda,
aqpb763papl,
aqpb763sbop,
aqpb763tope,
AQPB763MONE,
AQPB763SDOCAP,
AQPB763SDOHON,
AQPB763CREHON,
AQPB763FCR,
AQPB763HCR,
AQPB763FPROC,
aqpb763NCER,
aqpb763CCOB,
aqpb763CREN,
aqpb763PCOBR,
aqpb763PCHON,
aqpb763CODI,
aqpb763sinsap,
      aqpb763prpago,
      aqpb763pagrea,
      aqpb763pramrt,
      aqpb763nrccor,
      aqpb763nrccac,
      aqpb763vulcpa,
      aqpb763vcprve,
      aqpb763fuclpr,
      aqpb763intcom,
      aqpb763intcov,
      aqpb763intmor,
      aqpb763penali,
      aqpb763ruccer,
	  aqpb763consap,
      aqpb763monrep,
	  aqpb763tintre)
             (select rpad(trim(pn_usuario), 10, ' '), --usuario
                    '20100209641',  --RUC caja
                    t3.aqpb762bcsol, --cod solicitud cofide
                    t1.aocta, --cuenta
                    t1.aooper, --operacion
                    concat(lpad(to_char(t1.aocta), 9, '0'),concat(lpad(to_char(t1.aomda), 3, '0'),lpad(to_char(t1.aooper), 9, '0'))),--aqpb763npre, --numero prestamo
                    t1.aofval,--aqpb763fdes, --fecha de desembolso
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
                    t12.v_diatr,--aqpb763atru, --dias atraso ultimacuota pagada
                    t9.tp1desc, --region
                    t8.regnom, --zona                    
                    t6.scnom, --agencia
                    t27.v_ase, --analista
                    case when t2.petdoc = 21 then 'DNI' else 'RUC' end, --tipo doc
                    t2.pendoc, -- numero doc
                    t11.pjrazs, --razon social
                    substr(concat(trim(t10.pfape1), concat(' ', concat(trim(t10.pfape2), concat(' ',concat(trim(t10.pfnom1), concat(' ', t10.pfnom2)))))),1,70), --apellidos y nombres del cliente
                    t28.cenom,--aqpb763estd, --estado del credito
                    case when t30.v_fcest > nvl(t1.aofe99,to_date('01/01/0001','DD/MM/YYYY')) then 
                         (case when t30.v_fcest > nvl(t25.v_fech,to_date('01/01/0001','DD/MM/YYYY')) then t30.v_fcest else t25.v_fech end )
                         else (case when nvl(t25.v_fech,to_date('01/01/0001','DD/MM/YYYY')) > nvl(t1.aofe99,to_date('01/01/0001','DD/MM/YYYY')) then t25.v_fech else t1.aofe99 end )end ,--aqpb763fest, --fecha de cuando se realizo cambio de estado
                    t38.v_saldo_actual,--aqpb763cdes, -- monto desembolsado
                    case when t1.aoperiod = 0 then 0 else floor(t1.aopzo/t1.aoperiod) end ,--aqpb763ncuod, -- numero de cuotas del desembolso
                    t3.aqpb762bgrci,--aqpb763pgra, --periodo de gracia del desembolos
                    t3.aqpb762bpcob*100, --% de cobertura
                    round(t5.v_saldo_inso*t3.aqpb762bpcob,2), --monto de cobertura (saldo isnoluto*%de cobertura)
                    case when t22.aqpb434fecr is null then 'N' else 'S' end , --credito honrado(s/n)
                    t22.aqpb434fecr, --fecha de honramiento
                    t22.aqpb434mto,--aqpb763mhon, --monto honrado
                    t15.v_diatr, --dias de atraso
                    t37.v_finior, --fecha inicio credito original(cofide)
                    t37.v_ffinor, --fecha fin credito original(cofide)
                    t13.v_ncuopp,--aqpb763cpen, --numero de cuotas pendientes de pago
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
                    
                    t3.aqpb762bciuo, --ciuu origen
                    substr(trim(t3.aqpb762baeco), 1, 60),--acti economica origen
                    t1.pgcod, --pgcod
                    t1.aomod, -- modulo
                    t1.aosuc, --sucursal
                    t1.aomda, --moneda
                    t1.aopap, --papel
                    t1.aosbop, --suboperacion
                    t1.aotope, --tipo operacion
                    'PEN',--AQPB763MONE,
                    t4.v_saldo_actual, --saldo capital
                    t24.v_saldo_honrado,-- SALDO HONRADO
                    t4.v_saldo_actual + t24.v_saldo_honrado, -- SALDO CREDITRO HONRADO = saldo actual +saldo honrado
                    to_char(sysdate, 'DD/MM/YYYY'),
                    to_char(sysdate, 'HH24:MI:SS'),
                    pd_fecpro, --fecha proceso
                    t3.aqpb762bNCER,
                    t3.aqpb762bCCOB,
                    t3.aqpb762bCREN,
                    t3.aqpb762bCOBR,
                    t3.aqpb762bCHON,
                    t3.aqpb762bCODI,
                    t33.v_saldo_inso, --saldo insoluto antes de prpago
                    t35.v_prpago,--aqpb394prpago,
                    t35.v_pagrea,--aqpb394pagrea,
                    t35.v_pramrt,--aqpb394pramrt,
                    t35.v_nrccor,--aqpb394nrccor,
                    t35.v_nrccac,--aqpb394nrccac,
                    t35.v_vulcpa,--aqpb394vulcpa,
                    t35.v_vcprve,--aqpb394vcprve,
                    t35.v_fuclpr,--aqpb394fuclpr,
                    t35.v_intcom,--aqpb394intcom,
                    t35.v_intcov,--aqpb394intcov,
                    t35.v_intmor,--aqpb394intmor,
                    t35.v_penali,--aqpb394penali,
                    t35.v_ruccer,
                    t3.aqpb762bconsap,
                    t36.v_saldo_inso,
                    CASE WHEN substr(t25.v_flag,1,1) = 'N' THEN 0 ELSE t34.v_tear END
                    from aqpb762b t3                    
                    inner join fsd010 t1 on t3.aqpb762bcod = t1.pgcod and t3.aqpb762bccta = t1.aocta and t3.aqpb762boper = t1.aooper
                    left join fsd011 t26 on t26.pgcod = t1.pgcod and t26.scmda = t1.aomda and t26.scpap = t1.aopap and t26.sccta = t1.aocta and t26.scoper = t1.aooper and t26.scsbop = t1.aosbop and t26.sctope = t1.aotope and t26.scmod = t1.aomod
                    inner join fsr008 t2 on t2.pgcod = t1.pgcod and t2.ctnro = t1.aocta and t2.cttfir = 'T'
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_actual(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t4 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_insoluto(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro,1,t1.aostat)) t5 on 1=1
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
                    left join fst750 t29 on t29.actcod1 = to_number(nvl(trim(t3.aqpb762bciuo),'0000'))
                    left join table(pq_cr_reporte_utilitarios.fn_get_fcamb_estado(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t30 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_insoluto(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,lc_fmant,1,t1.aostat)) t33 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_tea_repro(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t34 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_otros_repfondos(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro,1)) t35 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_insoluto(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,t25.v_fech,1,t1.aostat)) t36 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_fec_creorigen(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope)) t37 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_monto_desembolsado(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t38 on 1=1
                    where t1.aomod in  (101,200,33)
                    --and t1.aotope = 355 --fae turismo
                    and t1.aostat <>99
                    and t3.aqpb762best <> 'D'
                    and t1.aofval <= pd_fecpro   
                    and t1.aosuc = pn_suc
                    
                    union all
                    
                    select rpad(trim(pn_usuario), 10, ' '), --usuario
                    '20100209641',  --RUC caja
                    t3.aqpb762bcsol, --cod solicitud cofide
                    t1.aocta, --cuenta
                    t1.aooper, --operacion
                    concat(lpad(to_char(t1.aocta), 9, '0'),concat(lpad(to_char(t1.aomda), 3, '0'),lpad(to_char(t1.aooper), 9, '0'))),--aqpb763npre, --numero prestamo
                    t1.aofval,--aqpb763fdes, --fecha de desembolso
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
                    t12.v_diatr,--aqpb763atru, --dias atraso ultimacuota pagada
                    t9.tp1desc, --region
                    t8.regnom, --zona                   
                    t6.scnom, --agencia
                    t27.v_ase, --analista
                    case when t2.petdoc = 21 then 'DNI' else 'RUC' end, --tipo doc
                    t2.pendoc, -- numero doc
                    t11.pjrazs, --razon social
                    substr(concat(trim(t10.pfape1), concat(' ', concat(trim(t10.pfape2), concat(' ',concat(trim(t10.pfnom1), concat(' ', t10.pfnom2)))))),1,70), --apellidos y nombres del cliente
                    t28.cenom,--aqpb763estd, --estado del credito
                    case when t30.v_fcest > nvl(t1.aofe99,to_date('01/01/0001','DD/MM/YYYY')) then 
                         (case when t30.v_fcest > nvl(t25.v_fech,to_date('01/01/0001','DD/MM/YYYY')) then t30.v_fcest else t25.v_fech end )
                         else (case when nvl(t25.v_fech,to_date('01/01/0001','DD/MM/YYYY')) > nvl(t1.aofe99,to_date('01/01/0001','DD/MM/YYYY')) then t25.v_fech else t1.aofe99 end )end ,--aqpb763fest, --fecha de cuando se realizo cambio de estado
                    t38.v_saldo_actual,--aqpb763cdes, -- monto desembolsado
                     case when t1.aoperiod = 0 then 0 else floor(t1.aopzo/t1.aoperiod) end,--aqpb763ncuod, -- numero de cuotas del desembolso
                    t3.aqpb762bgrci,--aqpb763pgra, --periodo de gracia del desembolos
                    t3.aqpb762bpcob*100, --% de cobertura
                    round(t5.v_saldo_inso*t3.aqpb762bpcob,2), --monto de cobertura (saldo isnoluto*%de cobertura)
                    case when t22.aqpb434fecr is null then 'N' else 'S' end , --credito honrado(s/n)
                    t22.aqpb434fecr, --fecha de honramiento
                    t22.aqpb434mto,--aqpb763mhon, --monto honrado
                    t15.v_diatr, --dias de atraso
                    t37.v_finior, --fecha inicio credito original(cofide)
                    t37.v_ffinor, --fecha fin credito original(cofide)
                    t13.v_ncuopp,--aqpb763cpen, --numero de cuotas pendientes de pago
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
                    
                    t3.aqpb762bciuo, --ciuu origen
                    substr(trim(t3.aqpb762baeco), 1, 60),--acti economica origen
                    t1.pgcod, --pgcod
                    t1.aomod, -- modulo
                    t1.aosuc, --sucursal
                    t1.aomda, --moneda
                    t1.aopap, --papel
                    t1.aosbop, --suboperacion
                    t1.aotope, --tipo operacion
                    'PEN',--AQPB763MONE,
                    t4.v_saldo_actual, --saldo capital
                    t24.v_saldo_honrado,-- SALDO HONRADO
                    t4.v_saldo_actual + t24.v_saldo_honrado, -- SALDO CREDITRO HONRADO = saldo actual +saldo honrado
                    to_char(sysdate, 'DD/MM/YYYY'),
                    to_char(sysdate, 'HH24:MI:SS'),
                    pd_fecpro, --fecha proceso
                    t3.aqpb762bNCER,
                    t3.aqpb762bCCOB,
                    t3.aqpb762bCREN,
                    t3.aqpb762bCOBR,
                    t3.aqpb762bCHON,
                    t3.aqpb762bCODI,
                    t33.v_saldo_inso, --saldo insoluto antes de prpago
                    t35.v_prpago,--aqpb394prpago,
                    t35.v_pagrea,--aqpb394pagrea,
                    t35.v_pramrt,--aqpb394pramrt,
                    t35.v_nrccor,--aqpb394nrccor,
                    t35.v_nrccac,--aqpb394nrccac,
                    t35.v_vulcpa,--aqpb394vulcpa,
                    t35.v_vcprve,--aqpb394vcprve,
                    t35.v_fuclpr,--aqpb394fuclpr,
                    t35.v_intcom,--aqpb394intcom,
                    t35.v_intcov,--aqpb394intcov,
                    t35.v_intmor,--aqpb394intmor,
                    t35.v_penali,--aqpb394penali,
                    t35.v_ruccer,
                    t3.aqpb762bconsap,
                    t36.v_saldo_inso,
                     CASE WHEN substr(t25.v_flag,1,1) = 'N' THEN 0 ELSE t34.v_tear END
                    from aqpb762b t3                    
                    inner join fsd010 t1 on t3.aqpb762bcod = t1.pgcod and t3.aqpb762bccta = t1.aocta and t3.aqpb762boper = t1.aooper
                    left join fsd011 t26 on t26.pgcod = t1.pgcod and t26.scmda = t1.aomda and t26.scpap = t1.aopap and t26.sccta = t1.aocta and t26.scoper = t1.aooper and t26.scsbop = t1.aosbop and t26.sctope = t1.aotope and t26.scmod = t1.aomod
                    inner join fsr008 t2 on t2.pgcod = t1.pgcod and t2.ctnro = t1.aocta and t2.cttfir = 'T'
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_actual(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t4 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_insoluto(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro,1,t1.aostat)) t5 on 1=1
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
                    left join fst750 t29 on t29.actcod1 = to_number(nvl(trim(t3.aqpb762bciuo),'0000'))
                    left join table(pq_cr_reporte_utilitarios.fn_get_fcamb_estado(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t30 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_insoluto(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,lc_fmant,1,t1.aostat)) t33 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_tea_repro(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t34 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_otros_repfondos(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro,1)) t35 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_insoluto(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,t25.v_fech,1,t1.aostat)) t36 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_fec_creorigen(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope)) t37 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_monto_desembolsado(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t38 on 1=1
                    where t1.aomod in  (101,200,33)
                    --and t1.aotope = 355 --fae turismo
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
                            --and h.aosuc = t.aosuc -- 
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
                    and t3.aqpb762best <> 'D'
                    and t1.aofval <= pd_fecpro   
                    and t1.aosuc = pn_suc
                    );                  
                    commit;
     exception
      when others then null;
     end;     
  end sp_cr_sch_turismo2;
  -----------------------------------------------------------------------
  procedure sp_guardar_historico(pn_usuario char,
                                 pn_fcorte  date) is
  
    pn_fcarga date;
    lc_coderr char(100);
    lc_msgerr char(1000);
  
  begin
  
    select t.pgfape into pn_fcarga from fst017 t where t.pgcod = 1;
  
    
      
        delete from aqpb763h t
         where t.aqpb763husur = pn_usuario
           and t.aqpb763hfproc = pn_fcorte
           ;
        commit;
      
        begin
        
          insert into aqpb763h
          (aqpb763husur,
aqpb763hrucc,
aqpb763hnsol,
aqpb763hncta,
aqpb763hnope,
aqpb763hnpre,
aqpb763hfdes,
aqpb763hscap,
aqpb763hsins,
aqpb763hmpre,
aqpb763hfclas,
aqpb763hcnor,
aqpb763hccpp,
aqpb763hcdef,
aqpb763hcdud,
aqpb763hcper,
aqpb763hscon,
aqpb763hatru,
aqpb763hrgon,
aqpb763hzona,
aqpb763hagen,
aqpb763hanal,
aqpb763htdoc,
aqpb763hndoc,
aqpb763hrsoc,
aqpb763hnomc,
aqpb763hestd,
aqpb763hfest,
aqpb763hcdes,
aqpb763hncuod,
aqpb763hpgra,
aqpb763hcobr,
aqpb763hmcob,
aqpb763hchon,
aqpb763hfhon,
aqpb763hmhon,
aqpb763hdatr,
aqpb763hfinc,
aqpb763hffnc,
aqpb763hcpen,
aqpb763hfvnui,
aqpb763hfvnup,
aqpb763hfpup,
aqpb763hcuop,
aqpb763hmcuop,
aqpb763hprcap,
aqpb763hpinc,
aqpb763hpinm,
aqpb763hprin,
aqpb763hprpn,
aqpb763hprseg,
aqpb763hfcsbs,
aqpb763hsnor,
aqpb763hscpp,
aqpb763hsdef,
aqpb763hsdud,
aqpb763hsper,
aqpb763htea,
aqpb763hteam,
aqpb763hciuu,
aqpb763haeco,
aqpb763htcre,
aqpb763htpre,
aqpb763hrepro,
aqpb763hfrpro,
aqpb763hnrpro,
aqpb763hfprcr,
aqpb763hffnpr,
aqpb763hncuor,
aqpb763hgrac,
aqpb763hciuo,
aqpb763haecoo,
aqpb763hemp,
aqpb763hmod,
aqpb763hsuc,
aqpb763hmnda,
aqpb763hpapl,
aqpb763hsbop,
aqpb763htope,
AQPB763HMONE,
AQPB763HSDOCAP,
AQPB763HSDOHON,
AQPB763HCREHON,
AQPB763HFCR,
AQPB763HHCR,
AQPB763HFPROC,
aqpb763hNCER,
aqpb763hCCOB,
aqpb763hCREN,
aqpb763hPCOBR,
aqpb763hPCHON,
aqpb763hCODI,
aqpb763Hsinsap,
      aqpb763Hprpago,
      aqpb763Hpagrea,
      aqpb763Hpramrt,
      aqpb763Hnrccor,
      aqpb763Hnrccac,
      aqpb763Hvulcpa,
      aqpb763Hvcprve,
      aqpb763Hfuclpr,
      aqpb763Hintcom,
      aqpb763Hintcov,
      aqpb763Hintmor,
      aqpb763Hpenali,
      aqpb763Hruccer,
	  aqpb763Hconsap,
      aqpb763Hmonrep,
	  aqpb763Htintre)
          select aqpb763usur,
aqpb763rucc,
aqpb763nsol,
aqpb763ncta,
aqpb763nope,
aqpb763npre,
aqpb763fdes,
aqpb763scap,
aqpb763sins,
aqpb763mpre,
aqpb763fclas,
aqpb763cnor,
aqpb763ccpp,
aqpb763cdef,
aqpb763cdud,
aqpb763cper,
aqpb763scon,
aqpb763atru,
aqpb763rgon,
aqpb763zona,
aqpb763agen,
aqpb763anal,
aqpb763tdoc,
aqpb763ndoc,
aqpb763rsoc,
aqpb763nomc,
aqpb763estd,
aqpb763fest,
aqpb763cdes,
aqpb763ncuod,
aqpb763pgra,
aqpb763cobr,
aqpb763mcob,
aqpb763chon,
aqpb763fhon,
aqpb763mhon,
aqpb763datr,
aqpb763finc,
aqpb763ffnc,
aqpb763cpen,
aqpb763fvnui,
aqpb763fvnup,
aqpb763fpup,
aqpb763cuop,
aqpb763mcuop,
aqpb763prcap,
aqpb763pinc,
aqpb763pinm,
aqpb763prin,
aqpb763prpn,
aqpb763prseg,
aqpb763fcsbs,
aqpb763snor,
aqpb763scpp,
aqpb763sdef,
aqpb763sdud,
aqpb763sper,
aqpb763tea,
aqpb763team,
aqpb763ciuu,
aqpb763aeco,
aqpb763tcre,
aqpb763tpre,
aqpb763repro,
aqpb763frpro,
aqpb763nrpro,
aqpb763fprcr,
aqpb763ffnpr,
aqpb763ncuor,
aqpb763grac,
aqpb763ciuo,
aqpb763aecoo,
aqpb763emp,
aqpb763mod,
aqpb763suc,
aqpb763mnda,
aqpb763papl,
aqpb763sbop,
aqpb763tope,
AQPB763MONE,
AQPB763SDOCAP,
AQPB763SDOHON,
AQPB763CREHON,
AQPB763FCR,
AQPB763HCR,
pn_fcorte,
aqpb763NCER,
aqpb763CCOB,
aqpb763CREN,
aqpb763PCOBR,
aqpb763PCHON,
aqpb763CODI,
aqpb763sinsap,
      aqpb763prpago,
      aqpb763pagrea,
      aqpb763pramrt,
      aqpb763nrccor,
      aqpb763nrccac,
      aqpb763vulcpa,
      aqpb763vcprve,
      aqpb763fuclpr,
      aqpb763intcom,
      aqpb763intcov,
      aqpb763intmor,
      aqpb763penali,
      aqpb763ruccer,
	  aqpb763consap,
      aqpb763monrep,
	  aqpb763tintre from aqpb763
where aqpb763usur = pn_usuario;

commit;
        
        exception
          when others then
          
            lc_coderr := sqlcode;
            lc_msgerr := trim(sqlerrm);
          
        end;
 end sp_guardar_historico;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_cr_sch_turismo(pd_fecpro  in date,
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
      delete from aqpb763 x
       where x.aqpb763usur = rpad(trim(pn_usuario), 10, ' ');
      commit;
    exception
      when others then null;
    end;
    begin
      select TRIM(TP1DESC)
        INTO lc_nomusr
        from fst198
       where tp1cod = 1
         and tp1cod1 = 10847
         and tp1corr1 = 999; ---2019.07.22 guia de proceso para hostname
    exception
      when others then null;
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
    exception
      when others then null;
    end; 
    
  
    lc_user       := substr(pn_usuario, 1, 5);
    lc_prefijo    := 'FAETR' || lc_user;
    lc_paquete    := 'pq_cr_rep_fondos_faeturismo';
    lc_proceso    := 'sp_cr_sch_turismo2';
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
                       '  pq_cr_rep_fondos_faeturismo.sp_cr_sch_turismo2( TO_DATE(''' ||
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
    pq_cr_rep_fondos_faeturismo.sp_guardar_historico(pn_usuario, pd_fecpro);
  
      
  
  end sp_cr_sch_turismo;
end pq_cr_rep_fondos_faeturismo;
/

