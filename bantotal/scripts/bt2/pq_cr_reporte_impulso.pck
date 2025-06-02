create or replace package pq_cr_reporte_impulso is

  -- *****************************************************************
  -- Nombre                       : pq_cr_reporte_impulso
  -- Sistema                      : BANTOTAL
  -- Módulo                       : Créditos
  -- Versión                      : 1.0
  -- Fecha de Creación            : 28/08/2023
  -- Autor de Creación            : rmontesr
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Descripción                  : Paquete para generar los reportes de fondo impulso
  
  -- Fecha de Modificación        : 27/12/2023
  -- Autor de Modificación        : rmontesr
  -- Descripción de Modificación  : Se agrego columna tamaño de empresa
  --                                11/07/2024 dcastro se modificó procedimiento sp_cr_csch_impulso
  --                                02/09/2024 dcastro se agregó procedimiento sp_cr_carga_tablas para optimizar proceso sp_cr_impulsoBT
  --                                13/09/2024 dcastro se modificó procedimiento sp_cr_impulsoBT, sp_cr_carga_tablas
  --                                15/10/2024 dcastro se modificó procedmiento sp_Cr_impulsoBT , se modifico llamada a dias de atraso por fn_get_dias_atraso_IMP
  
  -- Fecha de Modificación        : 16/04/2025
  -- Autor de Modificación        : calarconap
  -- Descripción de Modificación  : Se agregó columnas(sp_columnas_extras_2025) 
  --                                •	Tipo prepago
  --                                •	Flag de amortización
  --                                •	Fecha de amortización
  --                                •	TCEA
  --                                •  TEA

  -- Fecha de Modificación        : 29/05/2025
  -- Autor de Modificación        : calarconap
  -- Descripción de Modificación  : Se agrega regla para pagos de cuotas(PC) de meses anteriores (sp_columnas_extras_2025) 
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
  procedure sp_cr_sch_impulso2_ORI(pd_fecpro  in date,
                               pn_suc in number,
                               pn_usuario in varchar2
                               );
  -----------------------------------------------------------------------
  procedure sp_guardar_historico(pn_usuario char, pn_fcorte date);
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
  procedure sp_cr_sch_impulso(pd_fecpro in date, pn_usuario in varchar2);
  -----------------------------------------------------------------------

  procedure sp_cr_sch_impulso2(pd_fecpro  in date,
                               pn_suc in number,
                               pn_usuario in varchar2
                               );

  --------------------------
  procedure sp_cr_impulsoOP(pd_fecpro  in date,
                                 pn_suc in number,
                                 pn_usuario in varchar2
                                 ) ;
                                 
   ------------------------------------------------------------------
  procedure sp_cr_sch_impulsoOP(pd_fecpro  in date,
                                 pn_usuario in varchar2                               
                                 ) ;                              
   ------------------------------------------------------------------ 
  --------------------------
    procedure sp_cr_impulsoBT(pd_fecpro  in date,
                                   pn_suc in number,
                                   pn_usuario in varchar2
                                   ) ;
                                   
     ------------------------------------------------------------------
    procedure sp_cr_sch_impulsoBT(pd_fecpro  in date,
                                   pn_usuario in varchar2                               
                                   ) ;                              
     ------------------------------------------------------------------                                    
     procedure sp_cr_carga_tablas;
     
       procedure sp_columnas_extras_2025(
                                    p_fecha_proceso in date,
                                    p_xwfempresa in number,
                                    p_xwfsucursal in number,
                                    p_xwfmodulo in number,
                                    p_xwfmoneda in number,
                                    p_xwfpapel  in number,
                                    p_xwfcuenta  in number,
                                    p_xwfoperacion in number,
                                    p_xwfsubope in number,
                                    p_xwftipope in number,
                                    
                                    po_aqpc366tiprep out varchar2,
                                    po_aqpc366flgamor out varchar2,
                                    po_aqpc366fecamor out date,
                                    po_aqpc366tcea out number,
                                    po_aqpc366tea2 out number ) ;

end pq_cr_reporte_impulso;
/
create or replace package body pq_cr_reporte_impulso is

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
        select nvl(max(t.aqpc366acor), 0) + 1 into pn_corr from aqpc366a t;
      
        --- Reporte fae texco
        insert into aqpc366a
          (aqpc366acod,
           aqpc366afec,
           aqpc366acor,
           aqpc366aest,
           aqpc366ausr,
           aqpc366afcr,
           aqpc366ahcr)
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
        update aqpc366b t
           set t.aqpc366best  = pn_estado,
               t.aqpc366busu  = pn_usuario,
               t.aqpc366bfedi = to_char(sysdate, 'DD/MM/YYYY'),
               t.aqpc366bhedi = to_char(sysdate, 'HH24:MI:SS')
        
         where t.aqpc366bcod = pn_pgcod
           and t.aqpc366bfec = pn_fecha
           and t.aqpc366bcor = pn_corr
           and t.aqpc366best <> 'D';
        commit;
      
        update aqpc366a t
           set t.aqpc366aest = pn_estado,
               t.aqpc366ausd = pn_usuario,
               t.aqpc366afed = to_char(sysdate, 'DD/MM/YYYY'),
               t.aqpc366ahed = to_char(sysdate, 'HH24:MI:SS')
        
         where t.aqpc366acod = pn_pgcod
           and t.aqpc366afec = pn_fecha
           and t.aqpc366acor = pn_corr;
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
        select nvl(max(t.aqpc366acor), 0) + 1 into pn_corr from aqpc366a t;
      
        --- Reporte fae texco
        insert into aqpc366a
          (aqpc366acod,
           aqpc366afec,
           aqpc366acor,
           aqpc366aest,
           aqpc366ausr,
           aqpc366afcr,
           aqpc366ahcr)
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
      
        update aqpc366a t
           set t.aqpc366aest = pn_estado,
               t.aqpc366ausd = pn_usuario,
               t.aqpc366afed = to_char(sysdate, 'DD/MM/YYYY'),
               t.aqpc366ahed = to_char(sysdate, 'HH24:MI:SS')
        
         where t.aqpc366acod = pn_pgcod
           and t.aqpc366afec = pn_fecha
           and t.aqpc366acor = pn_corr;
        commit;
      
    end case;
  
  end sp_actualizar_pauxiliar;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
 /* procedure sp_cr_sch_impulso_sinjob(pd_fecpro  in date,
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
     pq_cr_reporte_impulso.sp_guardar_historico(pn_usuario, pd_fecpro);
  end sp_cr_sch_impulso_sinjob;*/
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --    
  procedure sp_cr_sch_impulso2_ORI(pd_fecpro  in date,
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
      insert into aqpc366(  aqpc366usur   ,
  aqpc366fproc  ,
  aqpc366ncta   ,
  aqpc366nope   ,
  aqpc366rucc   ,
  aqpc366ncer   ,
  aqpc366nsol   ,
  aqpc366codgar ,
  aqpc366codcob ,
  aqpc366codsub ,
  aqpc366idcof  ,
  aqpc366orifon ,
  aqpc366npre   ,
  aqpc366fdes   ,
  aqpc366fprcu  ,
  aqpc366ffinc  ,
  aqpc366finc   ,
  aqpc366ffnc   ,
  aqpc366tdest  ,
  aqpc366mone  ,
  aqpc366scap   ,
  aqpc366sins   ,
  aqpc366mpre   ,
  aqpc366fclas  ,
  aqpc366cnor   ,
  aqpc366ccpp   ,
  aqpc366cdef   ,
  aqpc366cdud   ,
  aqpc366cper   ,
  aqpc366scon   ,
  aqpc366tpre   ,
  aqpc366atru   ,
  aqpc366rgon   ,
  aqpc366zona   ,
  aqpc366agen   ,
  aqpc366anal   ,
  aqpc366tdoc   ,
  aqpc366ndoc   ,
  aqpc366rsoc   ,
  aqpc366nomc   ,
  aqpc366temp  ,
  aqpc366est  ,
  aqpc366estd   ,
  aqpc366fest   ,
  aqpc366cdes   ,
  aqpc366perio  ,
  aqpc366pgra   ,
  aqpc366ncuod  ,  
  aqpc366cobr   ,
  aqpc366mcob   ,
  aqpc366chon   ,
  aqpc366fhon   ,
  aqpc366mhon   ,
  aqpc366sdocap ,
  aqpc366sdohon ,
  aqpc366crehon ,
  aqpc366datr   ,  
  aqpc366cpen   ,
  aqpc366fvnui  ,
  aqpc366fvnup  ,
  aqpc366fpup   ,
  aqpc366cuop   ,
  aqpc366mcuop  ,
  aqpc366prcap  ,
  aqpc366pinc   ,
  aqpc366pinm   ,
  aqpc366prin   ,
  aqpc366prpn   ,
  aqpc366prseg  ,    
  aqpc366fcsbs  ,
  aqpc366snor   ,
  aqpc366scpp   ,
  aqpc366sdef   ,
  aqpc366sdud   ,
  aqpc366sper   ,
  aqpc366tea    ,
  aqpc366team   ,
  aqpc366ciuu   ,
  aqpc366aeco   ,
  aqpc366tcre   ,  
  aqpc366repro  ,
  aqpc366frpro  ,
  aqpc366nrpro  ,
  aqpc366fprcr  ,
  aqpc366ffnpr  ,
  aqpc366ncuor  ,
  aqpc366grac   ,
  aqpc366ciuo   ,
  aqpc366aecoo  ,
  aqpc366emp    ,
  aqpc366mod    ,
  aqpc366suc    ,
  aqpc366mnda   ,
  aqpc366papl   ,
  aqpc366sbop   ,
  aqpc366tope   ,  
  aqpc366fcr    ,
  aqpc366hcr    ,   
  aqpc366intcom ,
  aqpc366intmor ,
  aqpc366intcov ,
  aqpc366pen    ,
  aqpc366certrn ,
  aqpc366cobren ,
  aqpc366sinsap ,
  aqpc366prpago ,
  aqpc366pagrea ,
  aqpc366pramrt ,
  aqpc366nrccor ,
  aqpc366nrccac ,
  aqpc366vulcpa ,
  aqpc366vcprve ,
  aqpc366fuclpr ,
  aqpc366cuopc   )
             (select rpad(trim(pn_usuario), 10, ' '), --usuario
                    pd_fecpro, --fecha proceso                    
                    t1.aocta, --cuenta
                    t1.aooper, --operacion
                    '20100209641',  --RUC caja
                    t3.aqpc366bncer, --numero certificado
                    t3.aqpc366bnsol, --cod solicitud cofide
                    t3.aqpc366bcodgar, --cod garantia
                    t3.aqpc366bcodcob, --cod cobertura
                    t3.aqpc366bcodsub, --cod subasta
                    t3.aqpc366bidcof, --id cof
                    t3.aqpc366borifon, --orign fondos
                    concat(lpad(to_char(t1.aocta), 9, '0'),concat(lpad(to_char(t1.aomda), 3, '0'),lpad(to_char(t1.aooper), 9, '0'))),-- --numero prestamo
                    t1.aofval, --fecha desembolso
                    t36.v_finior, --fecha primera cuota
                    t1.aofvto, --fecha fin credito, --fecha fin credito
                    t3.aqpc366bfinc,--fecha inicio cofide
                    t3.aqpc366bffnc,-- fecha fin cofide
                    t3.aqpc366btdest, --tipo destino
                    case when t1.aomda = 0 then 'SOLES' else 'DOLARES' end, --moneda desc
                    t4.v_saldo_actual, --saldo capital
                    t5.v_saldo_inso, --saldo insoluto
                    t20.v_monto_prepago, --monto prepago
                    t21.v_deccaj,--fecha clasificacion caja
                    t21.v_califa0, --clasificacion  normal
                    t21.v_califa1, --clasificacion  cpp
                    t21.v_califa2, --clasificacion  deficiente
                    t21.v_califa3, --clasificacion  dudoso
                    t21.v_califa4, --clasificacion  perdida
                    case when t1.aostat = 99 and t1.aofe99 <= pd_fecpro and t1.aofe99 != '01/01/0001' then 'CNC' when t1.aostat = 61 then 'RFN' when substr(t37.v_pcre, 1, 4) = '1411' then 'VGT'
                         when substr(t37.v_pcre, 1, 4) = '1421' then 'VGT' when substr(t37.v_pcre, 1, 4) = '1414' then 'RFN'
                         when substr(t37.v_pcre, 1, 4) = '1424' then 'RFN' when substr(t37.v_pcre, 1, 4) = '1415' then 'VCD'
                         when substr(t37.v_pcre, 1, 4) = '1425' then 'VCD' when substr(t37.v_pcre, 1, 4) = '1416' then 'JDC'
                         when substr(t37.v_pcre, 1, 4) = '1426' then 'JDC' when substr(t37.v_pcre, 1, 2) = '81' then 'CTG'
                         when substr(t37.v_pcre, 1, 4) = '1413' then 'RTR' when substr(t37.v_pcre, 1, 4) = '1423' then 'RTR'  else  '' end ,--aqpb763scon, --situacion contable
                    t18.v_ncre,--aqpb763tpre, -- tipo de prestamo
                    t15.v_diatr, --dias de atraso
                    t9.tp1desc, --region
                    t8.regnom, --zona                 
                    t6.scnom, --agencia
                    t27.v_ase, --analista                           
                    t2.petdoc,--t2.petdoc, --tipo docuemnto
                    t2.pendoc,--t2.pendoc, -- numero documneto
                    trim(substr(t11.pjrazs,0,60)), --razon social
                    substr(concat(trim(t10.pfnom1), concat(' ', concat(trim(t10.pfnom2), concat(' ',concat(trim(t10.pfape1), concat(' ', t10.pfape2)))))),1,60), --nombre del cliente
                    t3.aqpc366btamemp, --tamaño empresa
                    t1.aostat,
                    t28.cenom,--estado del credito
                    case when t30.v_fcest > nvl(t1.aofe99,to_date('01/01/0001','DD/MM/YYYY')) then 
                         (case when t30.v_fcest > nvl(t25.v_fech,to_date('01/01/0001','DD/MM/YYYY')) then t30.v_fcest else t25.v_fech end )
                         else (case when nvl(t25.v_fech,to_date('01/01/0001','DD/MM/YYYY')) > nvl(t1.aofe99,to_date('01/01/0001','DD/MM/YYYY')) then t25.v_fech else t1.aofe99 end )end , --fecha de cuando se realizo cambio de estado
                    t3.AQPC366BMONCOF,--2024.04.15 dcastro t1.aoimp,-- monto desembolsado
                    case when t3.aqpc366bperio is null then (case when t1.aoperiod = 0 then 0 else  round(floor(t1.aopzo/t1.aoperiod),2) end + t31.v_pgra/30) else t3.aqpc366bperio end,--periodo total del crdito
                    case when t3.aqpc366bpgra is null then (t31.v_pgra/30) else t3.aqpc366bpgra end, --periodo de gracia del desembolos
                    case when t3.aqpc366bncuo is null then (case when t1.aoperiod = 0 then 0 else  round(floor(t1.aopzo/t1.aoperiod),2) end) else t3.aqpc366bncuo  end,--numero de cuotas del crdito
                    t3.aqpc366bprccof, --% de cobertura
                    round(t5.v_saldo_inso*t3.aqpc366bprccof,2), --monto de cobertura (saldo isnoluto*%de cobertura)                   
                    case when t22.aqpb434fecr is null then 'N' else 'S' end , --credito honrado(s/n)
                    t22.aqpb434fecr, --fecha de honramiento
                    t22.aqpb434mto,--aqpb763mhon, --monto honrado
                    t4.v_saldo_actual, --saldo capital
                    t24.v_saldo_honrado,-- SALDO HONRADO
                    t4.v_saldo_actual +t24.v_saldo_honrado, -- SALDO CREDITRO HONRADO = saldo actual +saldo honrado
                    
                    t15.v_diatr, --dias de atraso
                    t13.v_ncuopp,--numero de cuota pendientes de pago
                    t14.v_fvenuc,--aqpb763fvnui,--fecha de vencimiento de ultima cuota impaga
                    t12.v_fvenu,--aqpb763fvnup,--fecha de vencimiento de ultima cuota pagada
                    t12.v_fpagu,--v_ufpago,--aqpb763fpup, --fecha de pago de ultmo pago
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
                    case when nvl(t3.aqpc366btea,0) = 0 then t1.aotasa else t3.aqpc366btea end ,--aqpb763tea,  --tea
                    t30.v_tmor,--aqpb763team, --tasa moratoria
                    case when t17.v_ciuu4 <> 0 then t17.v_ciuu4 else (case when t17.v_ciuu6 <> 0 then to_number(substr(to_char(t17.v_ciuu6), 1, 4)) else 0 end) end, -- ciuu
                    case when t17.v_ciuu4 <> 0 then  substr(trim(t23.actnom1), 1, 60) else  '' end, --actividad economica
                     
                    t18.v_pcre,--aqpb763tcre, --tipo de crdito sbs
                    
                    substr(t25.v_flag,1,1),--aqpb763repro,--flag reprogramacion
                    t25.v_fech,--aqpb763frpro,--fecha reprogramacion
                    t25.v_nrep,--aqpb763nrpro,--numero de reprogramaciones
                    t25.v_fpri,--aqpb763fprcr,--fecha de primera cuota reprogramacion
                    t25.v_fult,--aqpb763ffnpr,--fecha fin de credito posterior a reprogramacion
                    t25.v_ncuo,--aqpb763ncuor,--numero de cuotas posterior a reprogramacion
                    t25.v_peri,--aqpb763grac, --periodo de gracia posterior a reprogramacion
                    case when t17.v_ciuu4 <> 0 then t17.v_ciuu4 else (case when t17.v_ciuu6 <> 0 then to_number(substr(to_char(t17.v_ciuu6), 1, 4)) else 0 end) end, -- ciuu
                    case when t17.v_ciuu4 <> 0 then  substr(trim(t23.actnom1), 1, 60) else  '' end, --actividad economica
                    t1.pgcod, --pgcod
                    t1.aomod, -- modulo
                    t1.aosuc, --sucursal
                    t1.aomda, --moneda
                    t1.aopap, --papel
                    t1.aosbop, --suboperacion
                    t1.aotope, --tipo operacion
                    
                    to_char(sysdate, 'DD/MM/YYYY'),
                    to_char(sysdate, 'HH24:MI:SS'),
                                        
                    t35.v_intcom,--aqpb394intcom,                    
                    t35.v_intmor,--aqpb394intmor,
                    t35.v_intcov,--aqpb394intcov,
                    t35.v_penali,--aqpb394penali,
                    --0,--aqpc360pen    ,
                    t3.aqpc366bcertrn,--aqpc360certrn ,
                    t3.aqpc366bcobren,--aqpc360cobren
                    t33.v_saldo_inso, --saldo insoluto antes de prpago
                    t19.v_cuo,--aqpb394prpago,
                    t35.v_pagrea,--aqpb394pagrea,
                    t35.v_pramrt,--aqpb394pramrt,
                    case when t3.aqpc366bperio is null then t35.v_nrccor else t3.aqpc366bperio end,--aqpb394nrccor,
                    t35.v_nrccac,--aqpb394nrccac,
                    t35.v_vulcpa,--aqpb394vulcpa,
                    t35.v_vcprve,--aqpb394vcprve,
                    t35.v_fuclpr,--aqpb394fuclpr,
                    case when (t13.v_ncuopa-(t31.v_pgra/30))< 0 then 0 else t13.v_ncuopa-(t31.v_pgra/30) end--numero de cuotas pagadas capital
                    --t16.v_csbs, --cod sbs 
                    
                    --t32.v_monto_prepago,--prepago total
                    --case when t1.aofe99 > pd_fecpro then null else t1.aofe99 end, --fecha prepago total
                    --CASE WHEN pd_fecpro <= t14.v_fvenuc THEN NULL ELSE t14.v_fvenuc END, --fecha de vencimiento pago mora
                    
                    from aqpc366b t3                     
                    inner join fsd010 t1 on t3.aqpc366bcod = t1.pgcod and t3.aqpc366bcta = t1.aocta and t3.aqpc366bope = t1.aooper
                    left join fsd011 t26 on t26.pgcod = t1.pgcod  and t26.scmda = t1.aomda and t26.scpap = t1.aopap and t26.sccta = t1.aocta and t26.scoper = t1.aooper and t26.scsbop = t1.aosbop and t26.sctope = t1.aotope and t26.scmod = t1.aomod
                    inner join fsr008 t2 on t2.pgcod = t1.pgcod and t2.ctnro = t1.aocta and t2.cttfir = 'T'
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_actual(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t4 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_insoluto_imp(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro,5,t1.aostat,t1.aofe99)) t5 on 1=1
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
                    left join table(pq_cr_reporte_utilitarios.fn_get_pergracia_imp(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t31 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_mprepago_acum(t1.pgcod,t1.aomod,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aotope,pd_fecpro)) t32 on 1=1 
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_insoluto_imp(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,lc_fmant,5,t1.aostat,t1.aofe99)) t33 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_otros_repfondos(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro,3)) t35 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_fec_creorigen2(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope)) t36 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_rubro(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t37 on 1=1
                    where t1.aomod in(101,102,200,33)
                    --and t1.aotope in ()
                    and t1.aostat <>99
                    and t3.aqpc366best <> 'D'
                    and t1.aofval <= pd_fecpro   
                    and t1.aosuc = pn_suc
                    
                    union all
                    
                   select rpad(trim(pn_usuario), 10, ' '), --usuario
                    pd_fecpro, --fecha proceso                    
                    t1.aocta, --cuenta
                    t1.aooper, --operacion
                    '20100209641',  --RUC caja
                    t3.aqpc366bncer, --numero certificado
                    t3.aqpc366bnsol, --cod solicitud cofide
                    t3.aqpc366bcodgar, --cod garantia
                    t3.aqpc366bcodcob, --cod cobertura
                    t3.aqpc366bcodsub, --cod subasta
                    t3.aqpc366bidcof, --id cof
                    t3.aqpc366borifon, --orign fondos
                    concat(lpad(to_char(t1.aocta), 9, '0'),concat(lpad(to_char(t1.aomda), 3, '0'),lpad(to_char(t1.aooper), 9, '0'))),-- --numero prestamo
                    t1.aofval, --fecha desembolso
                    t36.v_finior, --fecha primera cuota
                    t1.aofvto, --fecha fin credito, --fecha fin credito
                    t3.aqpc366bfinc,--fecha inicio cofide
                    t3.aqpc366bffnc,-- fecha fin cofide
                    t3.aqpc366btdest, --tipo destino
                    case when t1.aomda = 0 then 'SOLES' else 'DOLARES' end, --moneda desc
                    t4.v_saldo_actual, --saldo capital
                    t5.v_saldo_inso, --saldo insoluto
                    t20.v_monto_prepago, --monto prepago
                    t21.v_deccaj,--fecha clasificacion caja
                    t21.v_califa0, --clasificacion  normal
                    t21.v_califa1, --clasificacion  cpp
                    t21.v_califa2, --clasificacion  deficiente
                    t21.v_califa3, --clasificacion  dudoso
                    t21.v_califa4, --clasificacion  perdida
                    case when t1.aostat = 99 and t1.aofe99 <= pd_fecpro and t1.aofe99 != '01/01/0001' then 'CNC' when t1.aostat = 61 then 'RFN' when substr(t37.v_pcre, 1, 4) = '1411' then 'VGT'
                         when substr(t37.v_pcre, 1, 4) = '1421' then 'VGT' when substr(t37.v_pcre, 1, 4) = '1414' then 'RFN'
                         when substr(t37.v_pcre, 1, 4) = '1424' then 'RFN' when substr(t37.v_pcre, 1, 4) = '1415' then 'VCD'
                         when substr(t37.v_pcre, 1, 4) = '1425' then 'VCD' when substr(t37.v_pcre, 1, 4) = '1416' then 'JDC'
                         when substr(t37.v_pcre, 1, 4) = '1426' then 'JDC' when substr(t37.v_pcre, 1, 2) = '81' then 'CTG'
                         when substr(t37.v_pcre, 1, 4) = '1413' then 'RTR' when substr(t37.v_pcre, 1, 4) = '1423' then 'RTR'  else  '' end ,--aqpb763scon, --situacion contable
                    t18.v_ncre,--aqpb763tpre, -- tipo de prestamo
                    t15.v_diatr, --dias de atraso
                    t9.tp1desc, --region
                    t8.regnom, --zona                 
                    t6.scnom, --agencia
                    t27.v_ase, --analista                           
                    t2.petdoc,--t2.petdoc, --tipo docuemnto
                    t2.pendoc,--t2.pendoc, -- numero documneto
                    trim(substr(t11.pjrazs,0,60)), --razon social
                    substr(concat(trim(t10.pfnom1), concat(' ', concat(trim(t10.pfnom2), concat(' ',concat(trim(t10.pfape1), concat(' ', t10.pfape2)))))),1,60), --nombre del cliente
                    t3.aqpc366btamemp, --tamaño empresa
                    t1.aostat,
                    t28.cenom,--estado del credito
                    case when t30.v_fcest > nvl(t1.aofe99,to_date('01/01/0001','DD/MM/YYYY')) then 
                         (case when t30.v_fcest > nvl(t25.v_fech,to_date('01/01/0001','DD/MM/YYYY')) then t30.v_fcest else t25.v_fech end )
                         else (case when nvl(t25.v_fech,to_date('01/01/0001','DD/MM/YYYY')) > nvl(t1.aofe99,to_date('01/01/0001','DD/MM/YYYY')) then t25.v_fech else t1.aofe99 end )end , --fecha de cuando se realizo cambio de estado
                    t3.AQPC366BMONCOF,--2024.04.15 dcastro t1.aoimp,-- monto desembolsado
                    case when t3.aqpc366bperio is null then (case when t1.aoperiod = 0 then 0 else  round(floor(t1.aopzo/t1.aoperiod),2) end + t31.v_pgra/30) else t3.aqpc366bperio end,--periodo total del crdito
                    case when t3.aqpc366bpgra is null then (t31.v_pgra/30) else t3.aqpc366bpgra end, --periodo de gracia del desembolos
                    case when t3.aqpc366bncuo is null then (case when t1.aoperiod = 0 then 0 else  round(floor(t1.aopzo/t1.aoperiod),2) end) else t3.aqpc366bncuo  end,--numero de cuotas del crdito
                    t3.aqpc366bprccof, --% de cobertura
                    round(t5.v_saldo_inso*t3.aqpc366bprccof,2), --monto de cobertura (saldo isnoluto*%de cobertura)                   
                    case when t22.aqpb434fecr is null then 'N' else 'S' end , --credito honrado(s/n)
                    t22.aqpb434fecr, --fecha de honramiento
                    t22.aqpb434mto,--aqpb763mhon, --monto honrado
                    t4.v_saldo_actual, --saldo capital
                    t24.v_saldo_honrado,-- SALDO HONRADO
                    t4.v_saldo_actual +t24.v_saldo_honrado, -- SALDO CREDITRO HONRADO = saldo actual +saldo honrado
                    
                    t15.v_diatr, --dias de atraso
                    t13.v_ncuopp,--numero de cuota pendientes de pago
                    t14.v_fvenuc,--aqpb763fvnui,--fecha de vencimiento de ultima cuota impaga
                    t12.v_fvenu,--aqpb763fvnup,--fecha de vencimiento de ultima cuota pagada
                    t12.v_fpagu,--t18.v_ufpago,--aqpb763fpup, --fecha de pago de ultmo pago
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
                    case when nvl(t3.aqpc366btea,0) = 0 then t1.aotasa else t3.aqpc366btea end ,--aqpb763tea,  --tea
                    t30.v_tmor,--aqpb763team, --tasa moratoria
                    case when t17.v_ciuu4 <> 0 then t17.v_ciuu4 else (case when t17.v_ciuu6 <> 0 then to_number(substr(to_char(t17.v_ciuu6), 1, 4)) else 0 end) end, -- ciuu
                    case when t17.v_ciuu4 <> 0 then  substr(trim(t23.actnom1), 1, 60) else  '' end, --actividad economica
                     
                    t18.v_pcre,--aqpb763tcre, --tipo de crdito sbs
                    
                    substr(t25.v_flag,1,1),--aqpb763repro,--flag reprogramacion
                    t25.v_fech,--aqpb763frpro,--fecha reprogramacion
                    t25.v_nrep,--aqpb763nrpro,--numero de reprogramaciones
                    t25.v_fpri,--aqpb763fprcr,--fecha de primera cuota reprogramacion
                    t25.v_fult,--aqpb763ffnpr,--fecha fin de credito posterior a reprogramacion
                    t25.v_ncuo,--aqpb763ncuor,--numero de cuotas posterior a reprogramacion
                    t25.v_peri,--aqpb763grac, --periodo de gracia posterior a reprogramacion
                    case when t17.v_ciuu4 <> 0 then t17.v_ciuu4 else (case when t17.v_ciuu6 <> 0 then to_number(substr(to_char(t17.v_ciuu6), 1, 4)) else 0 end) end, -- ciuu
                    case when t17.v_ciuu4 <> 0 then  substr(trim(t23.actnom1), 1, 60) else  '' end, --actividad economica
                    t1.pgcod, --pgcod
                    t1.aomod, -- modulo
                    t1.aosuc, --sucursal
                    t1.aomda, --moneda
                    t1.aopap, --papel
                    t1.aosbop, --suboperacion
                    t1.aotope, --tipo operacion
                    
                    to_char(sysdate, 'DD/MM/YYYY'),
                    to_char(sysdate, 'HH24:MI:SS'),
                                        
                    t35.v_intcom,--aqpb394intcom,                    
                    t35.v_intmor,--aqpb394intmor,
                    t35.v_intcov,--aqpb394intcov,
                    t35.v_penali,--aqpb394penali,
                    --0,--aqpc360pen    ,
                    t3.aqpc366bcertrn,--aqpc360certrn ,
                    t3.aqpc366bcobren,--aqpc360cobren
                    t33.v_saldo_inso, --saldo insoluto antes de prpago
                    t19.v_cuo,--aqpb394prpago,
                    t35.v_pagrea,--aqpb394pagrea,
                    t35.v_pramrt,--aqpb394pramrt,
                    case when t3.aqpc366bperio is null then t35.v_nrccor else t3.aqpc366bperio end,--aqpb394nrccor,
                    t35.v_nrccac,--aqpb394nrccac,
                    t35.v_vulcpa,--aqpb394vulcpa,
                    t35.v_vcprve,--aqpb394vcprve,
                    t35.v_fuclpr,--aqpb394fuclpr,
                    case when (t13.v_ncuopa-(t31.v_pgra/30))< 0 then 0 else t13.v_ncuopa-(t31.v_pgra/30) end--numero de cuotas pagadas capital
                    --t16.v_csbs, --cod sbs 
                    
                    --t32.v_monto_prepago,--prepago total
                    --case when t1.aofe99 > pd_fecpro then null else t1.aofe99 end, --fecha prepago total
                    --CASE WHEN pd_fecpro <= t14.v_fvenuc THEN NULL ELSE t14.v_fvenuc END, --fecha de vencimiento pago mora
                    
                    from aqpc366b t3                     
                    inner join fsd010 t1 on t3.aqpc366bcod = t1.pgcod and t3.aqpc366bcta = t1.aocta and t3.aqpc366bope = t1.aooper
                    left join fsd011 t26 on t26.pgcod = t1.pgcod  and t26.scmda = t1.aomda and t26.scpap = t1.aopap and t26.sccta = t1.aocta and t26.scoper = t1.aooper and t26.scsbop = t1.aosbop and t26.sctope = t1.aotope and t26.scmod = t1.aomod
                    inner join fsr008 t2 on t2.pgcod = t1.pgcod and t2.ctnro = t1.aocta and t2.cttfir = 'T'
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_actual(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t4 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_insoluto_imp(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro,5,t1.aostat,t1.aofe99)) t5 on 1=1
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
                    left join table(pq_cr_reporte_utilitarios.fn_get_pergracia_imp(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t31 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_mprepago_acum(t1.pgcod,t1.aomod,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aotope,pd_fecpro)) t32 on 1=1 
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_insoluto_imp(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,lc_fmant,5,t1.aostat,t1.aofe99)) t33 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_otros_repfondos(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro,3)) t35 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_fec_creorigen2(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope)) t36 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_rubro(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t37 on 1=1
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
                    and t3.aqpc366best <> 'D'
                    and t1.aofval <= pd_fecpro   
                    and t1.aosuc = pn_suc
                    );                     
                    commit;
   exception when others then null;
     end;
     
  end sp_cr_sch_impulso2_ORI;
  -----------------------------------------------------------------------
  procedure sp_guardar_historico(pn_usuario char,
                                 pn_fcorte  date) is
  
    pn_fcarga date;
    lc_coderr char(100);
    lc_msgerr char(1000);
  
  begin
  
    select t.pgfape into pn_fcarga from fst017 t where t.pgcod = 1;
  
    
      
        delete from aqpc366h t
         where t.aqpc366husur = pn_usuario
           and t.aqpc366hfproc = pn_fcorte
           ;
        commit;
      
        begin
        
          insert into aqpc366h
          (  aqpc366husur   ,
  aqpc366hfproc  ,
  aqpc366hncta   ,
  aqpc366hnope   ,
  aqpc366hrucc   ,
  aqpc366hncer   ,
  aqpc366hnsol   ,
  aqpc366hcodgar ,
  aqpc366hcodcob ,
  aqpc366hcodsub ,
  aqpc366hidcof  ,
  aqpc366horifon ,
  aqpc366hnpre   ,
  aqpc366hfdes   ,
  aqpc366hfprcu  ,
  aqpc366hffinc  ,
  aqpc366hfinc   ,
  aqpc366hffnc   ,
  aqpc366htdest  ,
  aqpc366hmone  ,
  aqpc366hscap   ,
  aqpc366hsins   ,
  aqpc366hmpre   ,
  aqpc366hfclas  ,
  aqpc366hcnor   ,
  aqpc366hccpp   ,
  aqpc366hcdef   ,
  aqpc366hcdud   ,
  aqpc366hcper   ,
  aqpc366hscon   ,
  aqpc366htpre   ,
  aqpc366hatru   ,
  aqpc366hrgon   ,
  aqpc366hzona   ,
  aqpc366hagen   ,
  aqpc366hanal   ,
  aqpc366htdoc   ,
  aqpc366hndoc   ,
  aqpc366hrsoc   ,
  aqpc366hnomc   ,
  aqpc366htemp  ,
  aqpc366hest  ,
  aqpc366hestd   ,
  aqpc366hfest   ,
  aqpc366hcdes   ,
  aqpc366hperio  ,
  aqpc366hpgra   ,
  aqpc366hncuod  ,  
  aqpc366hcobr   ,
  aqpc366hmcob   ,
  aqpc366hchon   ,
  aqpc366hfhon   ,
  aqpc366hmhon   ,
  aqpc366hsdocap ,
  aqpc366hsdohon ,
  aqpc366hcrehon ,
  aqpc366hdatr   ,  
  aqpc366hcpen   ,
  aqpc366hfvnui  ,
  aqpc366hfvnup  ,
  aqpc366hfpup   ,
  aqpc366hcuop   ,
  aqpc366hmcuop  ,
  aqpc366hprcap  ,
  aqpc366hpinc   ,
  aqpc366hpinm   ,
  aqpc366hprin   ,
  aqpc366hprpn   ,
  aqpc366hprseg  ,    
  aqpc366hfcsbs  ,
  aqpc366hsnor   ,
  aqpc366hscpp   ,
  aqpc366hsdef   ,
  aqpc366hsdud   ,
  aqpc366hsper   ,
  aqpc366htea    ,
  aqpc366hteam   ,
  aqpc366hciuu   ,
  aqpc366haeco   ,
  aqpc366htcre   ,  
  aqpc366hrepro  ,
  aqpc366hfrpro  ,
  aqpc366hnrpro  ,
  aqpc366hfprcr  ,
  aqpc366hffnpr  ,
  aqpc366hncuor  ,
  aqpc366hgrac   ,
  aqpc366hciuo   ,
  aqpc366haecoo  ,
  aqpc366hemp    ,
  aqpc366hmod    ,
  aqpc366hsuc    ,
  aqpc366hmnda   ,
  aqpc366hpapl   ,
  aqpc366hsbop   ,
  aqpc366htope   ,  
  aqpc366hfcr    ,
  aqpc366hhcr    ,   
  aqpc366hintcom ,
  aqpc366hintmor ,
  aqpc366hintcov ,
  aqpc366hpen    ,
  aqpc366hcertrn ,
  aqpc366hcobren ,
  aqpc366hsinsap ,
  aqpc366hprpago ,
  aqpc366hpagrea ,
  aqpc366hpramrt ,
  aqpc366hnrccor ,
  aqpc366hnrccac ,
  aqpc366hvulcpa ,
  aqpc366hvcprve ,
  aqpc366hfuclpr ,
  aqpc366hcuopc,
  aqpc366htiprep,
  aqpc366hflgamor,
  aqpc366hfecamor,
  aqpc366htcea,
  aqpc366htea2  
  )
          select   aqpc366usur   ,
  aqpc366fproc  ,
  aqpc366ncta   ,
  aqpc366nope   ,
  aqpc366rucc   ,
  aqpc366ncer   ,
  aqpc366nsol   ,
  aqpc366codgar ,
  aqpc366codcob ,
  aqpc366codsub ,
  aqpc366idcof  ,
  aqpc366orifon ,
  aqpc366npre   ,
  aqpc366fdes   ,
  aqpc366fprcu  ,
  aqpc366ffinc  ,
  aqpc366finc   ,
  aqpc366ffnc   ,
  aqpc366tdest  ,
  aqpc366mone  ,
  aqpc366scap   ,
  aqpc366sins   ,
  aqpc366mpre   ,
  aqpc366fclas  ,
  aqpc366cnor   ,
  aqpc366ccpp   ,
  aqpc366cdef   ,
  aqpc366cdud   ,
  aqpc366cper   ,
  aqpc366scon   ,
  aqpc366tpre   ,
  aqpc366atru   ,
  aqpc366rgon   ,
  aqpc366zona   ,
  aqpc366agen   ,
  aqpc366anal   ,
  aqpc366tdoc   ,
  aqpc366ndoc   ,
  aqpc366rsoc   ,
  aqpc366nomc   ,
  aqpc366temp  ,
  aqpc366est  ,
  aqpc366estd   ,
  aqpc366fest   ,
  aqpc366cdes   ,
  aqpc366perio  ,
  aqpc366pgra   ,
  aqpc366ncuod  ,  
  aqpc366cobr   ,
  aqpc366mcob   ,
  aqpc366chon   ,
  aqpc366fhon   ,
  aqpc366mhon   ,
  aqpc366sdocap ,
  aqpc366sdohon ,
  aqpc366crehon ,
  aqpc366datr   ,  
  aqpc366cpen   ,
  aqpc366fvnui  ,
  aqpc366fvnup  ,
  aqpc366fpup   ,
  aqpc366cuop   ,
  aqpc366mcuop  ,
  aqpc366prcap  ,
  aqpc366pinc   ,
  aqpc366pinm   ,
  aqpc366prin   ,
  aqpc366prpn   ,
  aqpc366prseg  ,    
  aqpc366fcsbs  ,
  aqpc366snor   ,
  aqpc366scpp   ,
  aqpc366sdef   ,
  aqpc366sdud   ,
  aqpc366sper   ,
  aqpc366tea    ,
  aqpc366team   ,
  aqpc366ciuu   ,
  aqpc366aeco   ,
  aqpc366tcre   ,  
  aqpc366repro  ,
  aqpc366frpro  ,
  aqpc366nrpro  ,
  aqpc366fprcr  ,
  aqpc366ffnpr  ,
  aqpc366ncuor  ,
  aqpc366grac   ,
  aqpc366ciuo   ,
  aqpc366aecoo  ,
  aqpc366emp    ,
  aqpc366mod    ,
  aqpc366suc    ,
  aqpc366mnda   ,
  aqpc366papl   ,
  aqpc366sbop   ,
  aqpc366tope   ,  
  aqpc366fcr    ,
  aqpc366hcr    ,   
  aqpc366intcom ,
  aqpc366intmor ,
  aqpc366intcov ,
  aqpc366pen    ,
  aqpc366certrn ,
  aqpc366cobren ,
  aqpc366sinsap ,
  aqpc366prpago ,
  aqpc366pagrea ,
  aqpc366pramrt ,
  aqpc366nrccor ,
  aqpc366nrccac ,
  aqpc366vulcpa ,
  aqpc366vcprve ,
  aqpc366fuclpr ,
  aqpc366cuopc,
  aqpc366tiprep,
  aqpc366flgamor,
  aqpc366fecamor,
  aqpc366tcea,
  aqpc366tea2  
 from aqpc366
where aqpc366usur = pn_usuario;

commit;
        
        exception
          when others then
          
            lc_coderr := sqlcode;
            lc_msgerr := trim(sqlerrm);
          
        end;
 end sp_guardar_historico;
 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  
  procedure sp_cr_sch_impulso(pd_fecpro  in date,
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
      delete from aqpc366 x
       where x.aqpc366usur = rpad(trim(pn_usuario), 10, ' ');
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
    lc_prefijo    := 'FIMP' || lc_user;
    lc_paquete    := 'pq_cr_reporte_impulso';
    lc_proceso    := 'sp_cr_sch_impulso2';
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
                       '  pq_cr_reporte_impulso.sp_cr_sch_impulso2( TO_DATE(''' ||
                       lc_fecpro || ''',''RRRR.MM.DD''),' || ln_ini ||
                       ',''' || pn_usuario || ''' );' || ' End;';
    
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        
      
        dbms_job.submit(job_id,
                        what      => lc_variable,
                        next_date => sysdate,
                        interval  => null,
                        no_parse  => false,
                       -- instance  => 2,
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
    pq_cr_reporte_impulso.sp_guardar_historico(pn_usuario, pd_fecpro);
  
      
  
  end sp_cr_sch_impulso;

procedure sp_cr_sch_impulso2(pd_fecpro  in date,
                               pn_suc in number,
                               pn_usuario in varchar2
                               ) is
/* ************************************************************************************************************
    -- Nombre                     : sp_cr_sch_impulso2
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Descripción                : Carga data para Reporte impulso en aqpc366b 
    -- Versión                    : 1.0
    -- Fecha de Creación          : 28/08/2023
    -- Autor de Creación          : rmontesr
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 15/04/2024
    -- Autor de Modificación      : DCASTRO
    -- Descripción Modificación   : Se modificó obtencion de campo monto desembolsado de tabla t1.aoimp
                                  : 11/07/2024 DCASTRO  Se modificó el calculo de numero de cuotas de capital pagadas pq_cr_reporte_utilitarios.fn_get_cuota_pagoT (T38)
* *************************************************************************************************************/
                               
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
      insert into aqpc366(  aqpc366usur   ,   --1
                            aqpc366fproc  ,   --2
                            aqpc366ncta   ,   --3
                            aqpc366nope   ,   --4
                            aqpc366rucc   ,   --5
                            aqpc366ncer   ,   --6
                            aqpc366nsol   ,   --7
                            aqpc366codgar ,   --8
                            aqpc366codcob ,   --9
                            aqpc366codsub ,   --10
                            aqpc366idcof  ,   --11
                            aqpc366orifon ,   --12
                            aqpc366npre   ,   --13
                            aqpc366fdes   ,   --14
                            aqpc366fprcu  ,   --15
                            aqpc366ffinc  ,   --16
                            aqpc366finc   ,   --17
                            aqpc366ffnc   ,   --18
                            aqpc366tdest  ,   --19
                            aqpc366mone  ,    --20
                            aqpc366scap   ,   --21
                            aqpc366sins   ,   --22
                            aqpc366mpre   ,   --23
                            aqpc366fclas  ,   --24
                            aqpc366cnor   ,   --25
                            aqpc366ccpp   ,   --26
                            aqpc366cdef   ,   --27
                            aqpc366cdud   ,   --28
                            aqpc366cper   ,   --29
                            aqpc366scon   ,   --30
                            aqpc366tpre   ,   --31
                            aqpc366atru   ,   --32
                            aqpc366rgon   ,   --33
                            aqpc366zona   ,   --34
                            aqpc366agen   ,   --35
                            aqpc366anal   ,   --36
                            aqpc366tdoc   ,   --37
                            aqpc366ndoc   ,   --38
                            aqpc366rsoc   ,   --39
                            aqpc366nomc   ,   --40
                            aqpc366temp  ,    --41
                            aqpc366est  ,     --42
                            aqpc366estd   ,   --43
                            aqpc366fest   ,   --44
                            aqpc366cdes   ,   --45
                            aqpc366perio  ,   --46
                            aqpc366pgra   ,   --47
                            aqpc366ncuod  ,   --48
                            aqpc366cobr   ,   --49
                            aqpc366mcob   ,   --50
                            aqpc366chon   ,   --51
                            aqpc366fhon   ,   --52
                            aqpc366mhon   ,   --53
                            aqpc366sdocap ,   --54
                            aqpc366sdohon ,   --55
                            aqpc366crehon ,   --56
                            aqpc366datr   ,   --57
                            aqpc366cpen   ,   --58
                            aqpc366fvnui  ,   --59
                            aqpc366fvnup  ,   --60
                            aqpc366fpup   ,   --61
                            aqpc366cuop   ,   --62 ---
                            aqpc366mcuop  ,   --63
                            aqpc366prcap  ,   --64
                            aqpc366pinc   ,   --65
                            aqpc366pinm   ,   --66
                            aqpc366prin   ,   --67
                            aqpc366prpn   ,   --68
                            aqpc366prseg  ,   --69 
                            aqpc366fcsbs  ,   --70
                            aqpc366snor   ,   --71
                            aqpc366scpp   ,   --72
                            aqpc366sdef   ,   --73
                            aqpc366sdud   ,   --74
                            aqpc366sper   ,   --75
                            aqpc366tea    ,   --76
                            aqpc366team   ,   --77
                            aqpc366ciuu   ,   --78
                            aqpc366aeco   ,   --79
                            aqpc366tcre   ,   --80
                            aqpc366repro  ,   --81
                            aqpc366frpro  ,   --82
                            aqpc366nrpro  ,   --83
                            aqpc366fprcr  ,   --84
                            aqpc366ffnpr  ,   --85
                            aqpc366ncuor  ,   --86
                            aqpc366grac   ,   --87
                            aqpc366ciuo   ,   --88
                            aqpc366aecoo  ,   --89
                            aqpc366emp    ,   --90
                            aqpc366mod    ,   --91
                            aqpc366suc    ,   --92
                            aqpc366mnda   ,   --93
                            aqpc366papl   ,   --94
                            aqpc366sbop   ,   --95
                            aqpc366tope   ,   --96
                            aqpc366fcr    ,   --97
                            aqpc366hcr    ,   --98
                            aqpc366intcom ,   --99
                            aqpc366intmor ,   --100
                            aqpc366intcov ,   --101
                            aqpc366pen    ,   --102
                            aqpc366certrn ,   --103
                            aqpc366cobren ,   --104
                            aqpc366sinsap ,   --105
                            aqpc366prpago ,   --106
                            aqpc366pagrea ,   --107
                            aqpc366pramrt ,   --108
                            aqpc366nrccor ,   --109
                            aqpc366nrccac ,   --110
                            aqpc366vulcpa ,   --111
                            aqpc366vcprve ,   --112
                            aqpc366fuclpr ,   --113
                            aqpc366cuopc      --114
                          )
             (select rpad(trim(pn_usuario), 10, ' '), --usuario                                                                                                                   --1                                                                                                                                                                                 
                    pd_fecpro, --fecha proceso                                                                                                                                    --2
                    t1.aocta, --cuenta                                                                                                                                            --3
                    t1.aooper, --operacion                                                                                                                                        --4
                    '20100209641',  --RUC caja                                                                                                                                    --5
                    t3.aqpc366bncer, --numero certificado                                                                                                                         --6
                    t3.aqpc366bnsol, --cod solicitud cofide                                                                                                                       --7
                    t3.aqpc366bcodgar, --cod garantia                                                                                                                             --8
                    t3.aqpc366bcodcob, --cod cobertura                                                                                                                            --9
                    t3.aqpc366bcodsub, --cod subasta                                                                                                                              --10
                    t3.aqpc366bidcof, --id cof                                                                                                                                    --11
                    t3.aqpc366borifon, --orign fondos                                                                                                                             --12
                    concat(lpad(to_char(t1.aocta), 9, '0'),concat(lpad(to_char(t1.aomda), 3, '0'),lpad(to_char(t1.aooper), 9, '0'))),-- --numero prestamo                         --13
                    t1.aofval, --fecha desembolso                                                                                                                                 --14
                    t36.v_finior, --fecha primera cuota                                                                                                                           --15
                    t1.aofvto, --fecha fin credito, --fecha fin credito                                                                                                           --16
                    t3.aqpc366bfinc,--fecha inicio cofide                                                                                                                         --17
                    t3.aqpc366bffnc,-- fecha fin cofide                                                                                                                           --18
                    t3.aqpc366btdest, --tipo destino                                                                                                                              --19
                    case when t1.aomda = 0 then 'SOLES' else 'DOLARES' end, --moneda desc                                                                                         --20
                    t4.v_saldo_actual, --saldo capital                                                                                                                            --21
                    t5.v_saldo_inso, --saldo insoluto                                                                                                                             --22
                    t20.v_monto_prepago, --monto prepago                                                                                                                          --23
                    t21.v_deccaj,--fecha clasificacion caja                                                                                                                       --24
                    t21.v_califa0, --clasificacion  normal                                                                                                                        --25
                    t21.v_califa1, --clasificacion  cpp                                                                                                                           --26
                    t21.v_califa2, --clasificacion  deficiente                                                                                                                    --27
                    t21.v_califa3, --clasificacion  dudoso                                                                                                                        --28
                    t21.v_califa4, --clasificacion  perdida                                                                                                                       --29
                    case when t1.aostat = 99 and t1.aofe99 <= pd_fecpro and t1.aofe99 != '01/01/0001' then 'CNC' when t1.aostat = 61 then 'RFN' when substr(t37.v_pcre, 1, 4) = '1411' then 'VGT' 
                         when substr(t37.v_pcre, 1, 4) = '1421' then 'VGT' when substr(t37.v_pcre, 1, 4) = '1414' then 'RFN'                                                      
                         when substr(t37.v_pcre, 1, 4) = '1424' then 'RFN' when substr(t37.v_pcre, 1, 4) = '1415' then 'VCD'                                                      
                         when substr(t37.v_pcre, 1, 4) = '1425' then 'VCD' when substr(t37.v_pcre, 1, 4) = '1416' then 'JDC'                                                      
                         when substr(t37.v_pcre, 1, 4) = '1426' then 'JDC' when substr(t37.v_pcre, 1, 2) = '81' then 'CTG'                                                        
                         when substr(t37.v_pcre, 1, 4) = '1413' then 'RTR' when substr(t37.v_pcre, 1, 4) = '1423' then 'RTR'  else  '' end ,--aqpb763scon, --situacion contable   --30
                    t18.v_ncre,--aqpb763tpre, -- tipo de prestamo     --31                                                                                                            
                    t15.v_diatr, --dias de atraso                     --32                                                                                                            
                    t9.tp1desc, --region                              --33                                                                                                            
                    t8.regnom, --zona                                 --34                                                                                                            
                    t6.scnom, --agencia                               --35                                                                                                            
                    t27.v_ase, --analista                             --36                                                                                                            
                    t2.petdoc,--t2.petdoc, --tipo docuemnto           --37                                                                                                            
                    t2.pendoc,--t2.pendoc, -- numero documneto        --38                                                                                                            
                    trim(substr(t11.pjrazs,0,60)), --razon social     --39                                                                                                            
                    substr(concat(trim(t10.pfnom1), concat(' ', concat(trim(t10.pfnom2), concat(' ',concat(trim(t10.pfape1), concat(' ', t10.pfape2)))))),1,60), --nombre del cliete --40
                    t3.aqpc366btamemp, --tamaño empresa               --41                                                                                                                                         
                    t1.aostat,                                        --42                                                                                                            
                    t28.cenom,--estado del credito                    --43                                                                                                            
                    case when t30.v_fcest > nvl(t1.aofe99,to_date('01/01/0001','DD/MM/YYYY')) then                                                                                
                         (case when t30.v_fcest > nvl(t25.v_fech,to_date('01/01/0001','DD/MM/YYYY')) then t30.v_fcest else t25.v_fech end )                                       
                         else (case when nvl(t25.v_fech,to_date('01/01/0001','DD/MM/YYYY')) > nvl(t1.aofe99,to_date('01/01/0001','DD/MM/YYYY')) then t25.v_fech else t1.aofe99 end)end , --fecha de cuando se realizo cambio de estado --44
                    t3.AQPC366BMONCOF,--2024.04.15 dcastro t1.aoimp,-- monto desembolsado               --45                                                                          
                    case when t3.aqpc366bperio is null then (case when t1.aoperiod = 0 then 0 else  round(floor(t1.aopzo/t1.aoperiod),2) end + t31.v_pgra/30) else t3.aqpc366bperio end,--periodo total del crdito  --46
                    case when t3.aqpc366bpgra is null then (t31.v_pgra/30) else t3.aqpc366bpgra end, --periodo de gracia del desembolos    --47                                       
                    case when t3.aqpc366bncuo is null then (case when t1.aoperiod = 0 then 0 else  round(floor(t1.aopzo/t1.aoperiod),2) end) else t3.aqpc366bncuo  end,--numero decuotas del crdito --48
                    t3.aqpc366bprccof, --% de cobertura                                                                                   --49                                        
                    round(t5.v_saldo_inso*t3.aqpc366bprccof,2), --monto de cobertura (saldo isnoluto*%de cobertura)                       --50                                        
                    case when t22.aqpb434fecr is null then 'N' else 'S' end , --credito honrado(s/n)                                      --51                                        
                    t22.aqpb434fecr, --fecha de honramiento                                                                               --52                                        
                    t22.aqpb434mto,--aqpb763mhon, --monto honrado                                                                         --53                                        
                    t4.v_saldo_actual, --saldo capital                                                                                    --54                                        
                    t24.v_saldo_honrado,-- SALDO HONRADO                                                                                  --55                                        -
                    t4.v_saldo_actual +t24.v_saldo_honrado, -- SALDO CREDITRO HONRADO = saldo actual +saldo honrado                       --56                                        
                                                                                                                                                                                  
                    t15.v_diatr, --dias de atraso                                                                                         --57                                                                                                                
                    t13.v_ncuopp,--numero de cuota pendientes de pago                                                                     --58                                        
                    t14.v_fvenuc,--aqpb763fvnui,--fecha de vencimiento de ultima cuota impaga                                             --59                                        
                    t12.v_fvenu,--aqpb763fvnup,--fecha de vencimiento de ultima cuota pagada                                              --60                                        
                    t12.v_fpagu,--v_ufpago,--aqpb763fpup, --fecha de pago de ultmo pago                                                   --61                                        
                    t13.v_ncuopa,--aqpb763cuop, --numero de cuotas pagadas   --2024.07.11                                                              --62                                        
                    t19.v_tsum,--aqpb763mcuop,--monto de cuotas pagadas     --2024.07.19                                                              --63                                        
                    t19.v_cuo,--pago realizado - capital                    --2024.07.19                                                               --64                                        
                    t19.v_icv, --pago realizado - interes compensatorio     --2024.07.19                                                               --65                                        
                    t19.v_mor, --pago realizado - interese moratorio        --2024.07.19                                                               --66                                        
                    t19.v_int, --pago realizado - interes                   --2024.07.19                                                               --67                                        
                    t19.v_pen, --pago realizado - penalidad                 --2024.07.19                                                               --68                                        
                    t19.v_gas,--pago realizado -seguros                     --2024.07.19                                                               --69                                        
                    ld_fecha_rcc,--aqpb763fcsbs,--fecha clasificacion sbs                                                                 --70                                        
                    t16.v_calif0, --califiacion sbs normal                                                                                --71                                        
                    t16.v_calif1, --califiacion sbs cpp                                                                                   --72                                        
                    t16.v_calif2, --califiacion sbs deficiente                                                                            --73                                        
                    t16.v_calif3, --califiacion sbs dudoso                                                                                --74                                        
                    t16.v_calif4, --califiacion sbs perdida                                                                               --75                                        
                    case when nvl(t3.aqpc366btea,0) = 0 then t1.aotasa else t3.aqpc366btea end ,--aqpb763tea,  --tea                      --76                                        
                    t30.v_tmor,--aqpb763team, --tasa moratoria                                                                            --77                                        
                    case when t17.v_ciuu4 <> 0 then t17.v_ciuu4 else (case when t17.v_ciuu6 <> 0 then to_number(substr(to_char(t17.v_ciuu6), 1, 4)) else 0 end) end, -- ciuu    --78  
                    case when t17.v_ciuu4 <> 0 then  substr(trim(t23.actnom1), 1, 60) else  '' end, --actividad economica                                                       --79  
                                                                                                                                                                                  
                    t18.v_pcre,--aqpb763tcre, --tipo de crdito sbs                                                                        --80                                        
                                                                                                                                                                                  
                    substr(t25.v_flag,1,1),--aqpb763repro,--flag reprogramacion                                                                                                 --81                                        
                    t25.v_fech,--aqpb763frpro,--fecha reprogramacion                                                                                                            --82  
                    t25.v_nrep,--aqpb763nrpro,--numero de reprogramaciones                                                                                                      --83  
                    t25.v_fpri,--aqpb763fprcr,--fecha de primera cuota reprogramacion                                                                                           --84  
                    t25.v_fult,--aqpb763ffnpr,--fecha fin de credito posterior a reprogramacion                                                                                 --85  
                    t25.v_ncuo,--aqpb763ncuor,--numero de cuotas posterior a reprogramacion                                                                                     --86  
                    t25.v_peri,--aqpb763grac, --periodo de gracia posterior a reprogramacion                                                                                    --87  
                    case when t17.v_ciuu4 <> 0 then t17.v_ciuu4 else (case when t17.v_ciuu6 <> 0 then to_number(substr(to_char(t17.v_ciuu6), 1, 4)) else 0 end) end, -- ciuu    --88  
                    case when t17.v_ciuu4 <> 0 then  substr(trim(t23.actnom1), 1, 60) else  '' end, --actividad economica    --89                                                                     
                    t1.pgcod, --pgcod                                                                                        --90                                                     
                    t1.aomod, -- modulo                                                                                      --91                                                     
                    t1.aosuc, --sucursal                                                                                     --92                                                     
                    t1.aomda, --moneda                                                                                       --93                                                     
                    t1.aopap, --papel                                                                                        --94                                                     
                    t1.aosbop, --suboperacion                                                                                --95                                                     
                    t1.aotope, --tipo operacion                                                                              --96                                                     
                                                                                                                                                                                 
                    to_char(sysdate, 'DD/MM/YYYY'),                                                                          --97                                                     
                    to_char(sysdate, 'HH24:MI:SS'),                                                                          --98                                                     
                                                                                                                                                                                  
                    t35.v_intcom,--aqpb394intcom,                                                                            --99                                                      
                    t35.v_intmor,--aqpb394intmor,                                                                            --100                                                     
                    t35.v_intcov,--aqpb394intcov,                                                                            --101                                                     
                    t35.v_penali,--aqpb394penali,                                                                            --102                                                     
                    --0,--aqpc360pen    ,                                                                                    
                    t3.aqpc366bcertrn,--aqpc360certrn ,                                                                      --103
                    t3.aqpc366bcobren,--aqpc360cobren                                                                        --104
                    t33.v_saldo_inso, --saldo insoluto antes de prpago                                                       --105
                    t19.v_cuo,--aqpb394prpago,                                                                               --106
                    t35.v_pagrea,--aqpb394pagrea,                                                                            --107
                    t35.v_pramrt,--aqpb394pramrt,                                                                            --108
                    case when t3.aqpc366bperio is null then t35.v_nrccor else t3.aqpc366bperio end,--aqpb394nrccor,          --109
                    t35.v_nrccac,--aqpb394nrccac,                                                                            --110                
                    t35.v_vulcpa,--aqpb394vulcpa,                                                                            --111
                    t35.v_vcprve,--aqpb394vcprve,                                                                            --112
                    t35.v_fuclpr,--aqpb394fuclpr,                                                                            --113
 --20240711 numero cuotas pagadas capital                  case when (t13.v_ncuopa-(t31.v_pgra/30))< 0 then 0 else t13.v_ncuopa-(t31.v_pgra/30) end--numero de cuotas pagadas capital
                    t38.v_ncuopa               ---20240711                                                                   --114                   
                    --t16.v_csbs, --cod sbs 
                    
                    --t32.v_monto_prepago,--prepago total
                    --case when t1.aofe99 > pd_fecpro then null else t1.aofe99 end, --fecha prepago total
                    --CASE WHEN pd_fecpro <= t14.v_fvenuc THEN NULL ELSE t14.v_fvenuc END, --fecha de vencimiento pago mora
                    
                    from aqpc366b t3                     
                    inner join fsd010 t1 on t3.aqpc366bcod = t1.pgcod and t3.aqpc366bcta = t1.aocta and t3.aqpc366bope = t1.aooper
                    left join fsd011 t26 on t26.pgcod = t1.pgcod  and t26.scmda = t1.aomda and t26.scpap = t1.aopap and t26.sccta = t1.aocta and t26.scoper = t1.aooper and t26.scsbop = t1.aosbop and t26.sctope = t1.aotope and t26.scmod = t1.aomod
                    inner join fsr008 t2 on t2.pgcod = t1.pgcod and t2.ctnro = t1.aocta and t2.cttfir = 'T'
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_actual(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t4 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_insoluto_imp(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro,5,t1.aostat,t1.aofe99)) t5 on 1=1
                    left join fst001 t6 on t6.pgcod = t1.pgcod and t6.sucurs = t1.aosuc 
                    left join fst811 t7 on t7.pgcod = t1.pgcod and t7.oficod = t1.aosuc and t7.regcod < 100 and t7.regcod <> 0
                    left join fst810 t8 on t8.pgcod = t7.pgcod and t8.regcod = t7.regcod
                    left join fst198 t9 on t9.tp1cod = 1 and t9.tp1cod1 = 10872 and t9.tp1corr1 = 11 and t9.tp1nro2 = t7.regcod
                    left join fsd002 t10 on t10.pfpais = t2.pepais and t10.pftdoc = t2.petdoc and t10.pfndoc = t2.pendoc
                    left join fsd003 t11 on t11.pjpais = t2.pepais and t11.pjtdoc = t2.petdoc and t11.pjndoc = t2.pendoc
                    left join table(pq_cr_reporte_utilitarios.fn_get_fechas_pago(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t12 on 1=1
--                    left join table(pq_cr_reporte_utilitarios.fn_get_cuota_pago(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,t12.v_fvenu)) t13 on 1=1 --20240711 original
left join table(pq_cr_reporte_utilitarios.fn_get_cuota_pago_IMP(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,t12.v_fpagu /*t12.v_fvenu*/)) t13 on 1=1 --20240719 modificado
left join table(pq_cr_reporte_utilitarios.fn_get_cuota_pagoT(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,t12.v_fpagu /*t12.v_fvenu*/)) t38 on 1=1 ---20240719
                    left join table(pq_cr_reporte_utilitarios.fn_get_fvcuo_impaga(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t14 on 1=1
--                    left join table(pq_cr_reporte_utilitarios.fn_get_dias_atraso(pd_fecpro,t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,t1.aofvto)) t15 on 1=1   --20240815 original
                    left join table(pq_cr_reporte_utilitarios.fn_get_dias_atraso(pd_fecpro,t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,t1.aofvto)) t15 on 1=1     --20240815 modificado        
                   -- left join table(pq_cr_reporte_utilitarios.fn_get_calif_sbs(t2.petdoc,t2.pendoc,pd_fecpro)) t16 on 1=1
left join table(pq_cr_reporte_utilitarios.fn_get_calif_sbs_IMP(t2.petdoc,t2.pendoc,pd_fecpro)) t16 on 1=1                   
                    left join table(pq_cr_reporte_utilitarios.fn_get_acti_eco(t2.pepais,t2.petdoc,t2.pendoc)) t17 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_tipo_credito_sbs_vig(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t18 on 1=1
--                    left join table(pq_cr_reporte_utilitarios.fn_get_distribuc_pago(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t19 on 1=1 --se comento para impulsa
left join table(pq_cr_reporte_utilitarios.fn_get_distribuc_pago_IMP(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t19 on 1=1 --20240719 se agrego para impulsa
--                    left join table(pq_cr_reporte_utilitarios.fn_get_mprepago(t1.pgcod,t1.aomod,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aotope,pd_fecpro)) t20 on 1=1 ---20240719 se comento para impulsa
                    left join table(pq_cr_reporte_utilitarios.fn_get_mprepago_IMP(t1.pgcod,t1.aomod,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aotope,pd_fecpro)) t20 on 1=1  --20240719 se agrego para impulsa
                    left join table(pq_cr_reporte_utilitarios.fn_get_calf_caja(t1.aocta,pd_fecpro)) t21 on 1=1                      
                    left join aqpb434 t22 on t22.aqpb434cod = t1.pgcod and t22.aqpb434cta = t1.aocta and t22.aqpb434ope = t1.aooper and t22.aqpb434est = 'C' 
                    left join fst750 t23 on t23.actcod1 = t17.v_ciuu6 
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_honrado(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,9300082070000,pd_fecpro)) t24 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_repro_dato1(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t25 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_analista_credito(t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope)) t27 on 1=1
                    left join fst026 t28 on t28.cecod = t1.aostat
                    left join table(pq_cr_reporte_utilitarios.fn_get_fcamb_estado(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t30 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_pergracia_imp(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t31 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_mprepago_acum(t1.pgcod,t1.aomod,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aotope,pd_fecpro)) t32 on 1=1 
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_insoluto_imp(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,lc_fmant,5,t1.aostat,t1.aofe99)) t33 on 1=1
--                    left join table(pq_cr_reporte_utilitarios.fn_get_otros_repfondos(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro,3)) t35 on 1=1 --20240815 original
                    left join table(pq_cr_reporte_utilitarios.fn_get_otros_repfondos_imp(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro,3)) t35 on 1=1 --20240815 modificado
                    
                    left join table(pq_cr_reporte_utilitarios.fn_get_fec_creorigen2(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope)) t36 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_rubro(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t37 on 1=1
                    where t1.aomod in(101,102,200,33)
                    --and t1.aotope in ()
                    and t1.aostat <>99
                    and t3.aqpc366best <> 'D'
                    and t1.aofval <= pd_fecpro   
                    and t1.aosuc = pn_suc
              -----  and t1.aoCTA in ( 3913480,1621440)  and t1.aooper in (16364712,15843595)
                    union all
                    
                   select rpad(trim(pn_usuario), 10, ' '), --usuario
                    pd_fecpro, --fecha proceso                    
                    t1.aocta, --cuenta
                    t1.aooper, --operacion
                    '20100209641',  --RUC caja
                    t3.aqpc366bncer, --numero certificado
                    t3.aqpc366bnsol, --cod solicitud cofide
                    t3.aqpc366bcodgar, --cod garantia
                    t3.aqpc366bcodcob, --cod cobertura
                    t3.aqpc366bcodsub, --cod subasta
                    t3.aqpc366bidcof, --id cof
                    t3.aqpc366borifon, --orign fondos
                    concat(lpad(to_char(t1.aocta), 9, '0'),concat(lpad(to_char(t1.aomda), 3, '0'),lpad(to_char(t1.aooper), 9, '0'))),-- --numero prestamo
                    t1.aofval, --fecha desembolso
                    t36.v_finior, --fecha primera cuota
                    t1.aofvto, --fecha fin credito, --fecha fin credito
                    t3.aqpc366bfinc,--fecha inicio cofide
                    t3.aqpc366bffnc,-- fecha fin cofide
                    t3.aqpc366btdest, --tipo destino
                    case when t1.aomda = 0 then 'SOLES' else 'DOLARES' end, --moneda desc
                    t4.v_saldo_actual, --saldo capital
                    t5.v_saldo_inso, --saldo insoluto
                    t20.v_monto_prepago, --monto prepago
                    t21.v_deccaj,--fecha clasificacion caja
                    t21.v_califa0, --clasificacion  normal
                    t21.v_califa1, --clasificacion  cpp
                    t21.v_califa2, --clasificacion  deficiente
                    t21.v_califa3, --clasificacion  dudoso
                    t21.v_califa4, --clasificacion  perdida
                    case when t1.aostat = 99 and t1.aofe99 <= pd_fecpro and t1.aofe99 != '01/01/0001' then 'CNC' when t1.aostat = 61 then 'RFN' when substr(t37.v_pcre, 1, 4) = '1411' then 'VGT'
                         when substr(t37.v_pcre, 1, 4) = '1421' then 'VGT' when substr(t37.v_pcre, 1, 4) = '1414' then 'RFN'
                         when substr(t37.v_pcre, 1, 4) = '1424' then 'RFN' when substr(t37.v_pcre, 1, 4) = '1415' then 'VCD'
                         when substr(t37.v_pcre, 1, 4) = '1425' then 'VCD' when substr(t37.v_pcre, 1, 4) = '1416' then 'JDC'
                         when substr(t37.v_pcre, 1, 4) = '1426' then 'JDC' when substr(t37.v_pcre, 1, 2) = '81' then 'CTG'
                         when substr(t37.v_pcre, 1, 4) = '1413' then 'RTR' when substr(t37.v_pcre, 1, 4) = '1423' then 'RTR'  else  '' end ,--aqpb763scon, --situacion contable
                    t18.v_ncre,--aqpb763tpre, -- tipo de prestamo
                    t15.v_diatr, --dias de atraso
                    t9.tp1desc, --region
                    t8.regnom, --zona                 
                    t6.scnom, --agencia
                    t27.v_ase, --analista                           
                    t2.petdoc,--t2.petdoc, --tipo docuemnto
                    t2.pendoc,--t2.pendoc, -- numero documneto
                    trim(substr(t11.pjrazs,0,60)), --razon social
                    substr(concat(trim(t10.pfnom1), concat(' ', concat(trim(t10.pfnom2), concat(' ',concat(trim(t10.pfape1), concat(' ', t10.pfape2)))))),1,60), --nombre del cliente
                    t3.aqpc366btamemp, --tamaño empresa
                    t1.aostat,
                    t28.cenom,--estado del credito
                    case when t30.v_fcest > nvl(t1.aofe99,to_date('01/01/0001','DD/MM/YYYY')) then 
                         (case when t30.v_fcest > nvl(t25.v_fech,to_date('01/01/0001','DD/MM/YYYY')) then t30.v_fcest else t25.v_fech end )
                         else (case when nvl(t25.v_fech,to_date('01/01/0001','DD/MM/YYYY')) > nvl(t1.aofe99,to_date('01/01/0001','DD/MM/YYYY')) then t25.v_fech else t1.aofe99 end )end , --fecha de cuando se realizo cambio de estado
                    t3.AQPC366BMONCOF,--2024.04.15 dcastro t1.aoimp,-- monto desembolsado
                    case when t3.aqpc366bperio is null then (case when t1.aoperiod = 0 then 0 else  round(floor(t1.aopzo/t1.aoperiod),2) end + t31.v_pgra/30) else t3.aqpc366bperio end,--periodo total del crdito
                    case when t3.aqpc366bpgra is null then (t31.v_pgra/30) else t3.aqpc366bpgra end, --periodo de gracia del desembolos
                    case when t3.aqpc366bncuo is null then (case when t1.aoperiod = 0 then 0 else  round(floor(t1.aopzo/t1.aoperiod),2) end) else t3.aqpc366bncuo  end,--numero de cuotas del crdito
                    t3.aqpc366bprccof, --% de cobertura
                    round(t5.v_saldo_inso*t3.aqpc366bprccof,2), --monto de cobertura (saldo isnoluto*%de cobertura)                   
                    case when t22.aqpb434fecr is null then 'N' else 'S' end , --credito honrado(s/n)
                    t22.aqpb434fecr, --fecha de honramiento
                    t22.aqpb434mto,--aqpb763mhon, --monto honrado
                    t4.v_saldo_actual, --saldo capital
                    t24.v_saldo_honrado,-- SALDO HONRADO
                    t4.v_saldo_actual +t24.v_saldo_honrado, -- SALDO CREDITRO HONRADO = saldo actual +saldo honrado
                    
                    t15.v_diatr, --dias de atraso
                    t13.v_ncuopp,--numero de cuota pendientes de pago
                    t14.v_fvenuc,--aqpb763fvnui,--fecha de vencimiento de ultima cuota impaga
                    t12.v_fvenu,--aqpb763fvnup,--fecha de vencimiento de ultima cuota pagada
                    t12.v_fpagu,--t18.v_ufpago,--aqpb763fpup, --fecha de pago de ultmo pago
                    t13.v_ncuopa,--aqpb763cuop, --numero de cuotas pagadas ---20240711
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
                    case when nvl(t3.aqpc366btea,0) = 0 then t1.aotasa else t3.aqpc366btea end ,--aqpb763tea,  --tea
                    t30.v_tmor,--aqpb763team, --tasa moratoria
                    case when t17.v_ciuu4 <> 0 then t17.v_ciuu4 else (case when t17.v_ciuu6 <> 0 then to_number(substr(to_char(t17.v_ciuu6), 1, 4)) else 0 end) end, -- ciuu
                    case when t17.v_ciuu4 <> 0 then  substr(trim(t23.actnom1), 1, 60) else  '' end, --actividad economica
                     
                    t18.v_pcre,--aqpb763tcre, --tipo de crdito sbs
                    
                    substr(t25.v_flag,1,1),--aqpb763repro,--flag reprogramacion
                    t25.v_fech,--aqpb763frpro,--fecha reprogramacion
                    t25.v_nrep,--aqpb763nrpro,--numero de reprogramaciones
                    t25.v_fpri,--aqpb763fprcr,--fecha de primera cuota reprogramacion
                    t25.v_fult,--aqpb763ffnpr,--fecha fin de credito posterior a reprogramacion
                    t25.v_ncuo,--aqpb763ncuor,--numero de cuotas posterior a reprogramacion
                    t25.v_peri,--aqpb763grac, --periodo de gracia posterior a reprogramacion
                    case when t17.v_ciuu4 <> 0 then t17.v_ciuu4 else (case when t17.v_ciuu6 <> 0 then to_number(substr(to_char(t17.v_ciuu6), 1, 4)) else 0 end) end, -- ciuu
                    case when t17.v_ciuu4 <> 0 then  substr(trim(t23.actnom1), 1, 60) else  '' end, --actividad economica
                    t1.pgcod, --pgcod
                    t1.aomod, -- modulo
                    t1.aosuc, --sucursal
                    t1.aomda, --moneda
                    t1.aopap, --papel
                    t1.aosbop, --suboperacion
                    t1.aotope, --tipo operacion
                    
                    to_char(sysdate, 'DD/MM/YYYY'),
                    to_char(sysdate, 'HH24:MI:SS'),
                                        
                    t35.v_intcom,--aqpb394intcom,                    
                    t35.v_intmor,--aqpb394intmor,
                    t35.v_intcov,--aqpb394intcov,
                    t35.v_penali,--aqpb394penali,
                    --0,--aqpc360pen    ,
                    t3.aqpc366bcertrn,--aqpc360certrn ,
                    t3.aqpc366bcobren,--aqpc360cobren
                    t33.v_saldo_inso, --saldo insoluto antes de prpago
                    t19.v_cuo,--aqpb394prpago,
                    t35.v_pagrea,--aqpb394pagrea,
                    t35.v_pramrt,--aqpb394pramrt,
                    case when t3.aqpc366bperio is null then t35.v_nrccor else t3.aqpc366bperio end,--aqpb394nrccor,
                    t35.v_nrccac,--aqpb394nrccac,
                    t35.v_vulcpa,--aqpb394vulcpa,
                    t35.v_vcprve,--aqpb394vcprve,
                    t35.v_fuclpr,--aqpb394fuclpr,
                    --case when (t13.v_ncuopa-(t31.v_pgra/30))< 0 then 0 else t13.v_ncuopa-(t31.v_pgra/30) end--numero de cuotas pagadas capital --20240711
                    t38.v_ncuopa --20240711
                    --t16.v_csbs, --cod sbs 
                    
                    --t32.v_monto_prepago,--prepago total
                    --case when t1.aofe99 > pd_fecpro then null else t1.aofe99 end, --fecha prepago total
                    --CASE WHEN pd_fecpro <= t14.v_fvenuc THEN NULL ELSE t14.v_fvenuc END, --fecha de vencimiento pago mora
                    
                    from aqpc366b t3                     
                    inner join fsd010 t1 on t3.aqpc366bcod = t1.pgcod and t3.aqpc366bcta = t1.aocta and t3.aqpc366bope = t1.aooper
                    left join fsd011 t26 on t26.pgcod = t1.pgcod  and t26.scmda = t1.aomda and t26.scpap = t1.aopap and t26.sccta = t1.aocta and t26.scoper = t1.aooper and t26.scsbop = t1.aosbop and t26.sctope = t1.aotope and t26.scmod = t1.aomod
                    inner join fsr008 t2 on t2.pgcod = t1.pgcod and t2.ctnro = t1.aocta and t2.cttfir = 'T'
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_actual(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t4 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_insoluto_imp(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro,5,t1.aostat,t1.aofe99)) t5 on 1=1
                    left join fst001 t6 on t6.pgcod = t1.pgcod and t6.sucurs = t1.aosuc 
                    left join fst811 t7 on t7.pgcod = t1.pgcod and t7.oficod = t1.aosuc and t7.regcod < 100 and t7.regcod <> 0
                    left join fst810 t8 on t8.pgcod = t7.pgcod and t8.regcod = t7.regcod
                    left join fst198 t9 on t9.tp1cod = 1 and t9.tp1cod1 = 10872 and t9.tp1corr1 = 11 and t9.tp1nro2 = t7.regcod
                    left join fsd002 t10 on t10.pfpais = t2.pepais and t10.pftdoc = t2.petdoc and t10.pfndoc = t2.pendoc
                    left join fsd003 t11 on t11.pjpais = t2.pepais and t11.pjtdoc = t2.petdoc and t11.pjndoc = t2.pendoc
                    left join table(pq_cr_reporte_utilitarios.fn_get_fechas_pago(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t12 on 1=1
--                    left join table(pq_cr_reporte_utilitarios.fn_get_cuota_pago(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,t12.v_fvenu)) t13 on 1=1 --20240711 original
left join table(pq_cr_reporte_utilitarios.fn_get_cuota_pago_IMP(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,t12.v_fpagu /*t12.v_fvenu*/)) t13 on 1=1 --20240719 modificado
 left join table(pq_cr_reporte_utilitarios.fn_get_cuota_pagoT(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,t12.v_fpagu /*t12.v_fvenu*/)) t38 on 1=1 ---20240719
                    left join table(pq_cr_reporte_utilitarios.fn_get_fvcuo_impaga(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t14 on 1=1
--                    left join table(pq_cr_reporte_utilitarios.fn_get_dias_atraso(pd_fecpro,t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,t1.aofvto)) t15 on 1=1   --20240816 original
                    left join table(pq_cr_reporte_utilitarios.fn_get_dias_atraso_imp(pd_fecpro,t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,t1.aofvto)) t15 on 1=1     --20240815 modificado        
--                    left join table(pq_cr_reporte_utilitarios.fn_get_calif_sbs(t2.petdoc,t2.pendoc,pd_fecpro)) t16 on 1=1   --original
left join table(pq_cr_reporte_utilitarios.fn_get_calif_sbs_IMP(t2.petdoc,t2.pendoc,pd_fecpro)) t16 on 1=1 -----20240719 modificado
                    left join table(pq_cr_reporte_utilitarios.fn_get_acti_eco(t2.pepais,t2.petdoc,t2.pendoc)) t17 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_tipo_credito_sbs_vig(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t18 on 1=1
--                    left join table(pq_cr_reporte_utilitarios.fn_get_distribuc_pago(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t19 on 1=1 --se comento para impulsa
                    left join table(pq_cr_reporte_utilitarios.fn_get_distribuc_pago_IMP(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t19 on 1=1 --20240719 se agrego para impulsa
--                    left join table(pq_cr_reporte_utilitarios.fn_get_mprepago(t1.pgcod,t1.aomod,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aotope,pd_fecpro)) t20 on 1=1 ---20240719 se comento para impulsa
                    left join table(pq_cr_reporte_utilitarios.fn_get_mprepago_IMP(t1.pgcod,t1.aomod,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aotope,pd_fecpro)) t20 on 1=1  --20240719 se agrego para impulsa
                    left join table(pq_cr_reporte_utilitarios.fn_get_calf_caja(t1.aocta,pd_fecpro)) t21 on 1=1                      
                    left join aqpb434 t22 on t22.aqpb434cod = t1.pgcod and t22.aqpb434cta = t1.aocta and t22.aqpb434ope = t1.aooper and t22.aqpb434est = 'C' 
                    left join fst750 t23 on t23.actcod1 = t17.v_ciuu6 
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_honrado(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,9300082070000,pd_fecpro)) t24 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_repro_dato1(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t25 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_analista_credito(t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope)) t27 on 1=1
                    left join fst026 t28 on t28.cecod = t1.aostat
                    left join table(pq_cr_reporte_utilitarios.fn_get_fcamb_estado(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t30 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_pergracia_imp(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t31 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_mprepago_acum(t1.pgcod,t1.aomod,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aotope,pd_fecpro)) t32 on 1=1 
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_insoluto_imp(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,lc_fmant,5,t1.aostat,t1.aofe99)) t33 on 1=1
--                  left join table(pq_cr_reporte_utilitarios.fn_get_otros_repfondos(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro,3)) t35 on 1=1 --20240815 original
                    left join table(pq_cr_reporte_utilitarios.fn_get_otros_repfondos_imp(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro,3)) t35 on 1=1 --20240815 modificado
                                        
                    left join table(pq_cr_reporte_utilitarios.fn_get_fec_creorigen2(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope)) t36 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_rubro(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t37 on 1=1
                    where t1.aomod in(101,102,200,33)
                    --and t1.aotope in (356,357)
                    and t1.aostat  = 99
              ------ and t1.aoCTA in ( 3913480,1621440)  and t1.aooper in (16364712,15843595)
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
                    and t3.aqpc366best <> 'D'
                    and t1.aofval <= pd_fecpro   
                    and t1.aosuc = pn_suc
            ----    and t1.aoCTA in ( 3913480,1621440)  and t1.aooper in (16364712,15843595)
                    );                     
                    commit;
   exception when others then null;
     end;
     
  end sp_cr_sch_impulso2;
--------------------------
procedure sp_cr_impulsoOP(pd_fecpro  in date,
                               pn_suc in number,
                               pn_usuario in varchar2
                               ) is
/* ************************************************************************************************************
    -- Nombre                     : sp_cr_sch_impulsoOP
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Descripción                : Carga data para Reporte impulso en aqpc366b 
    -- Versión                    : 1.0
    -- Fecha de Creación          : 28/08/2023
    -- Autor de Creación          : rmontesr
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 15/04/2024
    -- Autor de Modificación      : DCASTRO
    -- Descripción Modificación   : Se modificó obtencion de campo monto desembolsado de tabla t1.aoimp
                                  : 11/07/2024 DCASTRO  Se modificó el calculo de numero de cuotas de capital pagadas pq_cr_reporte_utilitarios.fn_get_cuota_pagoT (T38)
* *************************************************************************************************************/
   
cursor creditos(lc_fmant in date) is
select --rpad(trim(pn_usuario), 10, ' ') USUARIO, --usuario                                                                                                                   --1                                                                                                                                                                                 
         --           pd_fecpro, --fecha proceso                                                                                                                                    --2
                    t1.aocta, --cuenta                                                                                                                                            --3
                    t1.aooper, --operacion                                                                                                                                        --4
                    '20100209641' RUC,  --RUC caja                                                                                                                                    --5
                    t3.aqpc366bncer, --numero certificado                                                                                                                         --6
                    t3.aqpc366bnsol, --cod solicitud cofide                                                                                                                       --7
                    t3.aqpc366bcodgar, --cod garantia                                                                                                                             --8
                    t3.aqpc366bcodcob, --cod cobertura                                                                                                                            --9
                    t3.aqpc366bcodsub, --cod subasta                                                                                                                              --10
                    t3.aqpc366bidcof, --id cof                                                                                                                                    --11
                    t3.aqpc366borifon, --orign fondos                                                                                                                             --12
                    concat(lpad(to_char(t1.aocta), 9, '0'),concat(lpad(to_char(t1.aomda), 3, '0'),lpad(to_char(t1.aooper), 9, '0'))) PRESTAMO,-- --numero prestamo                         --13
                    t1.aofval, --fecha desembolso                                                                                                                                 --14
                    t36.v_finior, --fecha primera cuota                                                                                                                           --15
                    t1.aofvto, --fecha fin credito, --fecha fin credito                                                                                                           --16
                    t3.aqpc366bfinc,--fecha inicio cofide                                                                                                                         --17
                    t3.aqpc366bffnc,-- fecha fin cofide                                                                                                                           --18
                    t3.aqpc366btdest, --tipo destino                                                                                                                              --19
                    case when t1.aomda = 0 then 'SOLES' else 'DOLARES' end MONEDA, --moneda desc                                                                                         --20
                    t4.v_saldo_actual, --saldo capital                                                                                                                            --21
                    t5.v_saldo_inso, --saldo insoluto                                                                                                                             --22
                    t20.v_monto_prepago, --monto prepago                                                                                                                          --23
                    t21.v_deccaj,--fecha clasificacion caja                                                                                                                       --24
                    t21.v_califa0, --clasificacion  normal                                                                                                                        --25
                    t21.v_califa1, --clasificacion  cpp                                                                                                                           --26
                    t21.v_califa2, --clasificacion  deficiente                                                                                                                    --27
                    t21.v_califa3, --clasificacion  dudoso                                                                                                                        --28
                    t21.v_califa4
                    , --clasificacion  perdida                                                                                                                       --29
                    case when t1.aostat = 99 and t1.aofe99 <= pd_fecpro and t1.aofe99 != '01/01/0001' then 'CNC' when t1.aostat = 61 then 'RFN' when substr(t37.v_pcre, 1, 4) = '1411' then 'VGT' 
                         when substr(t37.v_pcre, 1, 4) = '1421' then 'VGT' when substr(t37.v_pcre, 1, 4) = '1414' then 'RFN'                                                      
                         when substr(t37.v_pcre, 1, 4) = '1424' then 'RFN' when substr(t37.v_pcre, 1, 4) = '1415' then 'VCD'                                                      
                         when substr(t37.v_pcre, 1, 4) = '1425' then 'VCD' when substr(t37.v_pcre, 1, 4) = '1416' then 'JDC'                                                      
                         when substr(t37.v_pcre, 1, 4) = '1426' then 'JDC' when substr(t37.v_pcre, 1, 2) = '81' then 'CTG'                                                        
                         when substr(t37.v_pcre, 1, 4) = '1413' then 'RTR' when substr(t37.v_pcre, 1, 4) = '1423' then 'RTR'  else  '' end CONTABLE,--aqpb763scon, --situacion contable   --30
                    t18.v_ncre,--aqpb763tpre, -- tipo de prestamo     --31                                                                                                            
                    t15.v_diatr, --dias de atraso                     --32                                                                                                            
                    t9.tp1desc, --region                              --33                                                                                                            
                    t8.regnom, --zona                                 --34                                                                                                            
                    t6.scnom, --agencia                               --35                                                                                                            
                    t27.v_ase, --analista                             --36                                                                                                            
                    t2.petdoc,--t2.petdoc, --tipo docuemnto           --37                                                                                                            
                    t2.pendoc,--t2.pendoc, -- numero documneto        --38                                                                                                            
                    trim(substr(t11.pjrazs,0,60)) RAZON, --razon social     --39                                                                                                            
                    substr(concat(trim(t10.pfnom1), concat(' ', concat(trim(t10.pfnom2), concat(' ',concat(trim(t10.pfape1), concat(' ', t10.pfape2)))))),1,60) NOMCLI , --nombre del cliete --40
                    t3.aqpc366btamemp, --tamaño empresa               --41                                                                                                                                         
                    t1.aostat,                                        --42                                                                                                            
                    t28.cenom,--estado del credito                    --43                                                                                                            
                    case when t30.v_fcest > nvl(t1.aofe99,to_date('01/01/0001','DD/MM/YYYY')) then                                                                                
                         (case when t30.v_fcest > nvl(t25.v_fech,to_date('01/01/0001','DD/MM/YYYY')) then t30.v_fcest else t25.v_fech end )                                       
                         else (case when nvl(t25.v_fech,to_date('01/01/0001','DD/MM/YYYY')) > nvl(t1.aofe99,to_date('01/01/0001','DD/MM/YYYY')) then t25.v_fech else t1.aofe99 end)end FEC_CAMBIO, --fecha de cuando se realizo cambio de estado --44
                    t3.AQPC366BMONCOF,--2024.04.15 dcastro t1.aoimp,-- monto desembolsado               --45                                                                          
                    case when t3.aqpc366bperio is null then (case when t1.aoperiod = 0 then 0 else  round(floor(t1.aopzo/t1.aoperiod),2) end + t31.v_pgra/30) else t3.aqpc366bperio end PERIODO_TOT,--periodo total del crdito  --46
                    case when t3.aqpc366bpgra is null then (t31.v_pgra/30) else t3.aqpc366bpgra end PERIODO_GRACIA, --periodo de gracia del desembolos    --47                                       
                    case when t3.aqpc366bncuo is null then (case when t1.aoperiod = 0 then 0 else  round(floor(t1.aopzo/t1.aoperiod),2) end) else t3.aqpc366bncuo  end NUMERO_CUO,--numero decuotas del crdito --48
                    t3.aqpc366bprccof, --% de cobertura                                                                                   --49                                        
                    round(t5.v_saldo_inso*t3.aqpc366bprccof,2) MONTO_COB, --monto de cobertura (saldo isnoluto*%de cobertura)                       --50                                        
                    case when t22.aqpb434fecr is null then 'N' else 'S' end HONRADO, --credito honrado(s/n)                                      --51                                        
                    t22.aqpb434fecr, --fecha de honramiento                                                                               --52                                        
                    t22.aqpb434mto,--aqpb763mhon, --monto honrado                                                                         --53                                        
                    t4.v_saldo_actual saldo_Capital_Act, --saldo capital                                                                                    --54                                        
                    t24.v_saldo_honrado,-- SALDO HONRADO                                                                                  --55                                        -
                    t4.v_saldo_actual +t24.v_saldo_honrado SALDO_HONRADO, -- SALDO CREDITRO HONRADO = saldo actual +saldo honrado                       --56                                        
                                                                                                                                                                                  
                    t15.v_diatr DIA_ATRASO, --dias de atraso                                                                                         --57                                                                                                                
                    t13.v_ncuopp,--numero de cuota pendientes de pago                                                                     --58                                        
                    t14.v_fvenuc,--aqpb763fvnui,--fecha de vencimiento de ultima cuota impaga                                             --59                                        
                    t12.v_fvenu,--aqpb763fvnup,--fecha de vencimiento de ultima cuota pagada                                              --60                                        
                    t12.v_fpagu,--v_ufpago,--aqpb763fpup, --fecha de pago de ultmo pago                                                   --61                                        
                    t13.v_ncuopa  aqpb763cuop,--aqpb763cuop, --numero de cuotas pagadas   --2024.07.11                                                              --62                                        
                    t19.v_tsum,--aqpb763mcuop,--monto de cuotas pagadas     --2024.07.19                                                              --63                                        
                    t19.v_cuo,--pago realizado - capital                    --2024.07.19                                                               --64                                        
                    t19.v_icv, --pago realizado - interes compensatorio     --2024.07.19                                                               --65                                        
                    t19.v_mor, --pago realizado - interese moratorio        --2024.07.19                                                               --66                                        
                    t19.v_int, --pago realizado - interes                   --2024.07.19                                                               --67                                        
                    t19.v_pen, --pago realizado - penalidad                 --2024.07.19                                                               --68                                        
                    t19.v_gas,--pago realizado -seguros                     --2024.07.19                                                               --69                                        
                    --ld_fecha_rcc,--aqpb763fcsbs,--fecha clasificacion sbs                                                                 --70                                        
                    t16.v_calif0, --califiacion sbs normal                                                                                --71                                        
                    t16.v_calif1, --califiacion sbs cpp                                                                                   --72                                        
                    t16.v_calif2, --califiacion sbs deficiente                                                                            --73                                        
                    t16.v_calif3, --califiacion sbs dudoso                                                                                --74                                        
                    t16.v_calif4, --califiacion sbs perdida                                                                               --75                                        
                    case when nvl(t3.aqpc366btea,0) = 0 then t1.aotasa else t3.aqpc366btea end TEA ,--aqpb763tea,  --tea                      --76                                        
                    t30.v_tmor,--aqpb763team, --tasa moratoria                                                                            --77                                        
                    case when t17.v_ciuu4 <> 0 then t17.v_ciuu4 else (case when t17.v_ciuu6 <> 0 then to_number(substr(to_char(t17.v_ciuu6), 1, 4)) else 0 end) end CIUU, -- ciuu    --78  
                    case when t17.v_ciuu4 <> 0 then  substr(trim(t23.actnom1), 1, 60) else  '' end ACTIVIDAD_ECO, --actividad economica                                                       --79  
                                                                                                                                                                                  
                    t18.v_pcre,--aqpb763tcre, --tipo de crdito sbs                                                                        --80                                        
                                                                                                                                                                                  
                    substr(t25.v_flag,1,1) FLAG_REPRO,--aqpb763repro,--flag reprogramacion                                                                                                 --81                                        
                    t25.v_fech,--aqpb763frpro,--fecha reprogramacion                                                                                                            --82  
                    t25.v_nrep,--aqpb763nrpro,--numero de reprogramaciones                                                                                                      --83  
                    t25.v_fpri,--aqpb763fprcr,--fecha de primera cuota reprogramacion                                                                                           --84  
                    t25.v_fult,--aqpb763ffnpr,--fecha fin de credito posterior a reprogramacion                                                                                 --85  
                    t25.v_ncuo,--aqpb763ncuor,--numero de cuotas posterior a reprogramacion                                                                                     --86  
                    t25.v_peri,--aqpb763grac, --periodo de gracia posterior a reprogramacion                                                                                    --87  
                    case when t17.v_ciuu4 <> 0 then t17.v_ciuu4 else (case when t17.v_ciuu6 <> 0 then to_number(substr(to_char(t17.v_ciuu6), 1, 4)) else 0 end) end CIU4, -- ciuu    --88  
                    case when t17.v_ciuu4 <> 0 then  substr(trim(t23.actnom1), 1, 60) else  '' end ACTIVIDAD4, --actividad economica    --89                                                                     
                    t1.pgcod, --pgcod                                                                                        --90                                                     
                    t1.aomod, -- modulo                                                                                      --91                                                     
                    t1.aosuc, --sucursal                                                                                     --92                                                     
                    t1.aomda, --moneda                                                                                       --93                                                     
                    t1.aopap, --papel                                                                                        --94                                                     
                    t1.aosbop, --suboperacion                                                                                --95                                                     
                    t1.aotope, --tipo operacion                                                                              --96                                                     
                                                                                                                                                                                 
                    to_char(sysdate, 'DD/MM/YYYY') FECHA,                                                                          --97                                                     
                    to_char(sysdate, 'HH24:MI:SS') HORA,                                                                          --98                                                     
                                                                                                                                                                                  
                    t35.v_intcom,--aqpb394intcom,                                                                            --99                                                      
                    t35.v_intmor,--aqpb394intmor,                                                                            --100                                                     
                    t35.v_intcov,--aqpb394intcov,                                                                            --101                                                     
                    t35.v_penali,--aqpb394penali,                                                                            --102                                                     
                    --0,--aqpc360pen    ,                                                                                    
                    t3.aqpc366bcertrn,--aqpc360certrn ,                                                                      --103
                    t3.aqpc366bcobren,--aqpc360cobren                                                                        --104
                    t33.v_saldo_inso SALDO_INSOLUTO, --saldo insoluto antes de prpago                                                       --105
                    t19.v_cuo aqpb394prpago,--aqpb394prpago,                                                                               --106
                    t35.v_pagrea,--aqpb394pagrea,                                                                            --107
                    t35.v_pramrt,--aqpb394pramrt,                                                                            --108
                    case when t3.aqpc366bperio is null then t35.v_nrccor else t3.aqpc366bperio end NRCCOR,--aqpb394nrccor,          --109
                    t35.v_nrccac,--aqpb394nrccac,                                                                            --110                
                    t35.v_vulcpa,--aqpb394vulcpa,                                                                            --111
                    t35.v_vcprve,--aqpb394vcprve,                                                                            --112
                    t35.v_fuclpr,--aqpb394fuclpr,                                                                            --113
 --20240711 numero cuotas pagadas capital                  case when (t13.v_ncuopa-(t31.v_pgra/30))< 0 then 0 else t13.v_ncuopa-(t31.v_pgra/30) end--numero de cuotas pagadas capital
                    t38.v_ncuopa               ---20240711                                                                   --114                   
                    --t16.v_csbs, --cod sbs 
                    
                    --t32.v_monto_prepago,--prepago total
                    --case when t1.aofe99 > pd_fecpro then null else t1.aofe99 end, --fecha prepago total
                    --CASE WHEN pd_fecpro <= t14.v_fvenuc THEN NULL ELSE t14.v_fvenuc END, --fecha de vencimiento pago mora
                    
                    from aqpc366b t3                     
                    inner join fsd010 t1 on t3.aqpc366bcod = t1.pgcod and t3.aqpc366bcta = t1.aocta and t3.aqpc366bope = t1.aooper
                    left join fsd011 t26 on t26.pgcod = t1.pgcod  and t26.scmda = t1.aomda and t26.scpap = t1.aopap and t26.sccta = t1.aocta and t26.scoper = t1.aooper and t26.scsbop = t1.aosbop and t26.sctope = t1.aotope and t26.scmod = t1.aomod
                    inner join fsr008 t2 on t2.pgcod = t1.pgcod and t2.ctnro = t1.aocta and t2.cttfir = 'T'
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_actual(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t4 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_insoluto_imp(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro,5,t1.aostat,t1.aofe99)) t5 on 1=1
                    left join fst001 t6 on t6.pgcod = t1.pgcod and t6.sucurs = t1.aosuc 
                    left join fst811 t7 on t7.pgcod = t1.pgcod and t7.oficod = t1.aosuc and t7.regcod < 100 and t7.regcod <> 0
                    left join fst810 t8 on t8.pgcod = t7.pgcod and t8.regcod = t7.regcod
                    left join fst198 t9 on t9.tp1cod = 1 and t9.tp1cod1 = 10872 and t9.tp1corr1 = 11 and t9.tp1nro2 = t7.regcod
                    left join fsd002 t10 on t10.pfpais = t2.pepais and t10.pftdoc = t2.petdoc and t10.pfndoc = t2.pendoc
                    left join fsd003 t11 on t11.pjpais = t2.pepais and t11.pjtdoc = t2.petdoc and t11.pjndoc = t2.pendoc
                    left join table(pq_cr_reporte_utilitarios.fn_get_fechas_pago(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t12 on 1=1
--                    left join table(pq_cr_reporte_utilitarios.fn_get_cuota_pago(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,t12.v_fvenu)) t13 on 1=1 --20240711 original
left join table(pq_cr_reporte_utilitarios.fn_get_cuota_pago_IMP(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,t12.v_fpagu /*t12.v_fvenu*/)) t13 on 1=1 --20240719 modificado
left join table(pq_cr_reporte_utilitarios.fn_get_cuota_pagoT(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,t12.v_fpagu /*t12.v_fvenu*/)) t38 on 1=1 ---20240719
                    left join table(pq_cr_reporte_utilitarios.fn_get_fvcuo_impaga(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t14 on 1=1
--                    left join table(pq_cr_reporte_utilitarios.fn_get_dias_atraso(pd_fecpro,t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,t1.aofvto)) t15 on 1=1   --20240815 original
                    left join table(pq_cr_reporte_utilitarios.fn_get_dias_atraso(pd_fecpro,t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,t1.aofvto)) t15 on 1=1     --20240815 modificado        
                   -- left join table(pq_cr_reporte_utilitarios.fn_get_calif_sbs(t2.petdoc,t2.pendoc,pd_fecpro)) t16 on 1=1
left join table(pq_cr_reporte_utilitarios.fn_get_calif_sbs_IMP(t2.petdoc,t2.pendoc,pd_fecpro)) t16 on 1=1                   
                    left join table(pq_cr_reporte_utilitarios.fn_get_acti_eco(t2.pepais,t2.petdoc,t2.pendoc)) t17 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_tipo_credito_sbs_vig(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t18 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_distribuc_pago(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t19 on 1=1 --se comento para impulsa
left join table(pq_cr_reporte_utilitarios.fn_get_distribuc_pago_IMP(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t19 on 1=1 --20240719 se agrego para impulsa
                    left join table(pq_cr_reporte_utilitarios.fn_get_mprepago(t1.pgcod,t1.aomod,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aotope,pd_fecpro)) t20 on 1=1 ---20240719 se comento para impulsa
                    left join table(pq_cr_reporte_utilitarios.fn_get_mprepago_IMP(t1.pgcod,t1.aomod,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aotope,pd_fecpro)) t20 on 1=1  --20240719 se agrego para impulsa
                   left join table(pq_cr_reporte_utilitarios.fn_get_calf_caja(t1.aocta,pd_fecpro)) t21 on 1=1                      
                   left join aqpb434 t22 on t22.aqpb434cod = t1.pgcod and t22.aqpb434cta = t1.aocta and t22.aqpb434ope = t1.aooper and t22.aqpb434est = 'C' 
                   left join fst750 t23 on t23.actcod1 = t17.v_ciuu6 
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_honrado(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,9300082070000,pd_fecpro)) t24 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_repro_dato1(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t25 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_analista_credito(t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope)) t27 on 1=1
                    left join fst026 t28 on t28.cecod = t1.aostat
                    left join table(pq_cr_reporte_utilitarios.fn_get_fcamb_estado(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t30 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_pergracia_imp(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t31 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_mprepago_acum_imp(t1.pgcod,t1.aomod,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aotope,pd_fecpro)) t32 on 1=1 
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_insoluto_imp(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,lc_fmant,5,t1.aostat,t1.aofe99)) t33 on 1=1
--                    left join table(pq_cr_reporte_utilitarios.fn_get_otros_repfondos(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro,3)) t35 on 1=1 --20240815 original
                    left join table(pq_cr_reporte_utilitarios.fn_get_otros_repfondos_imp(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro,3)) t35 on 1=1 --20240815 modificado
                    
                    left join table(pq_cr_reporte_utilitarios.fn_get_fec_creorigen2(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope)) t36 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_rubro(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t37 on 1=1
                    where t1.aomod in(101,102,200,33)
                    --and t1.aotope in ()
                    and t1.aostat <>99
                    and t3.aqpc366best <> 'D'
                    and t1.aofval <= pd_fecpro   
                    and t1.aosuc = pn_suc
              -----  and t1.aoCTA in ( 3913480,1621440)  and t1.aooper in (16364712,15843595)
 UNION all
 select --rpad(trim(pn_usuario), 10, ' ') USUARIO, --usuario                                                                                                                   --1                                                                                                                                                                                 
         --           pd_fecpro, --fecha proceso                                                                                                                                    --2
                    t1.aocta, --cuenta                                                                                                                                            --3
                    t1.aooper, --operacion                                                                                                                                        --4
                    '20100209641' RUC,  --RUC caja                                                                                                                                    --5
                    t3.aqpc366bncer, --numero certificado                                                                                                                         --6
                     t3.aqpc366bnsol, --cod solicitud cofide                                                                                                                       --7
                    t3.aqpc366bcodgar, --cod garantia                                                                                                                             --8
                    t3.aqpc366bcodcob, --cod cobertura                                                                                                                            --9
                    t3.aqpc366bcodsub, --cod subasta                                                                                                                              --10
                    t3.aqpc366bidcof, --id cof                                                                                                                                    --11
                    t3.aqpc366borifon, --orign fondos                                                                                                                             --12
                    concat(lpad(to_char(t1.aocta), 9, '0'),concat(lpad(to_char(t1.aomda), 3, '0'),lpad(to_char(t1.aooper), 9, '0'))) PRESTAMO,-- --numero prestamo                         --13
                    t1.aofval, --fecha desembolso                                                                                                                                 --14
                    t36.v_finior, --fecha primera cuota                                                                                                                           --15
                    t1.aofvto, --fecha fin credito, --fecha fin credito                                                                                                           --16
                    t3.aqpc366bfinc,--fecha inicio cofide                                                                                                                         --17
                    t3.aqpc366bffnc,-- fecha fin cofide                                                                                                                           --18
                    t3.aqpc366btdest, --tipo destino                                                                                                                              --19
                    case when t1.aomda = 0 then 'SOLES' else 'DOLARES' end MONEDA, --moneda desc                                                                                         --20
                    t4.v_saldo_actual, --saldo capital                                                                                                                            --21
                    t5.v_saldo_inso, --saldo insoluto                                                                                                                             --22
                    t20.v_monto_prepago, --monto prepago                                                                                                                          --23
                    t21.v_deccaj,--fecha clasificacion caja                                                                                                                       --24
                    t21.v_califa0, --clasificacion  normal                                                                                                                        --25
                    t21.v_califa1, --clasificacion  cpp                                                                                                                           --26
                    t21.v_califa2, --clasificacion  deficiente                                                                                                                    --27
                    t21.v_califa3, --clasificacion  dudoso                                                                                                                        --28
                    t21.v_califa4
                    , --clasificacion  perdida                                                                                                                       --29
                    case when t1.aostat = 99 and t1.aofe99 <= pd_fecpro and t1.aofe99 != '01/01/0001' then 'CNC' when t1.aostat = 61 then 'RFN' when substr(t37.v_pcre, 1, 4) = '1411' then 'VGT' 
                         when substr(t37.v_pcre, 1, 4) = '1421' then 'VGT' when substr(t37.v_pcre, 1, 4) = '1414' then 'RFN'                                                      
                         when substr(t37.v_pcre, 1, 4) = '1424' then 'RFN' when substr(t37.v_pcre, 1, 4) = '1415' then 'VCD'                                                      
                         when substr(t37.v_pcre, 1, 4) = '1425' then 'VCD' when substr(t37.v_pcre, 1, 4) = '1416' then 'JDC'                                                      
                         when substr(t37.v_pcre, 1, 4) = '1426' then 'JDC' when substr(t37.v_pcre, 1, 2) = '81' then 'CTG'                                                        
                         when substr(t37.v_pcre, 1, 4) = '1413' then 'RTR' when substr(t37.v_pcre, 1, 4) = '1423' then 'RTR'  else  '' end CONTABLE,--aqpb763scon, --situacion contable   --30
                    t18.v_ncre,--aqpb763tpre, -- tipo de prestamo     --31                                                                                                            
                    t15.v_diatr, --dias de atraso                     --32                                                                                                            
                    t9.tp1desc, --region                              --33                                                                                                            
                    t8.regnom, --zona                                 --34                                                                                                            
                    t6.scnom, --agencia                               --35                                                                                                            
                    t27.v_ase, --analista                             --36                                                                                                            
                    t2.petdoc,--t2.petdoc, --tipo docuemnto           --37                                                                                                            
                    t2.pendoc,--t2.pendoc, -- numero documneto        --38                                                                                                            
                    trim(substr(t11.pjrazs,0,60)) RAZON, --razon social     --39                                                                                                            
                    substr(concat(trim(t10.pfnom1), concat(' ', concat(trim(t10.pfnom2), concat(' ',concat(trim(t10.pfape1), concat(' ', t10.pfape2)))))),1,60) NOMCLI , --nombre del cliete --40
                    t3.aqpc366btamemp, --tamaño empresa               --41                                                                                                                                         
                    t1.aostat,                                        --42                                                                                                            
                    t28.cenom,--estado del credito                    --43                                                                                                            
                    case when t30.v_fcest > nvl(t1.aofe99,to_date('01/01/0001','DD/MM/YYYY')) then                                                                                
                         (case when t30.v_fcest > nvl(t25.v_fech,to_date('01/01/0001','DD/MM/YYYY')) then t30.v_fcest else t25.v_fech end )                                       
                         else (case when nvl(t25.v_fech,to_date('01/01/0001','DD/MM/YYYY')) > nvl(t1.aofe99,to_date('01/01/0001','DD/MM/YYYY')) then t25.v_fech else t1.aofe99 end)end FEC_CAMBIO, --fecha de cuando se realizo cambio de estado --44
                    t3.AQPC366BMONCOF,--2024.04.15 dcastro t1.aoimp,-- monto desembolsado               --45                                                                          
                    case when t3.aqpc366bperio is null then (case when t1.aoperiod = 0 then 0 else  round(floor(t1.aopzo/t1.aoperiod),2) end + t31.v_pgra/30) else t3.aqpc366bperio end PERIODO_TOT,--periodo total del crdito  --46
                    case when t3.aqpc366bpgra is null then (t31.v_pgra/30) else t3.aqpc366bpgra end PERIODO_GRACIA, --periodo de gracia del desembolos    --47                                       
                    case when t3.aqpc366bncuo is null then (case when t1.aoperiod = 0 then 0 else  round(floor(t1.aopzo/t1.aoperiod),2) end) else t3.aqpc366bncuo  end NUMERO_CUO,--numero decuotas del crdito --48
                    t3.aqpc366bprccof, --% de cobertura                                                                                   --49                                        
                    round(t5.v_saldo_inso*t3.aqpc366bprccof,2) MONTO_COB, --monto de cobertura (saldo isnoluto*%de cobertura)                       --50                                        
                    case when t22.aqpb434fecr is null then 'N' else 'S' end HONRADO, --credito honrado(s/n)                                      --51                                        
                    t22.aqpb434fecr, --fecha de honramiento                                                                               --52                                        
                    t22.aqpb434mto,--aqpb763mhon, --monto honrado                                                                         --53                                        
                    t4.v_saldo_actual saldo_Capital_Act, --saldo capital                                                                                    --54                                        
                    t24.v_saldo_honrado,-- SALDO HONRADO                                                                                  --55                                        -
                    t4.v_saldo_actual +t24.v_saldo_honrado SALDO_HONRADO, -- SALDO CREDITRO HONRADO = saldo actual +saldo honrado                       --56                                        
                                                                                                                                                                                  
                    t15.v_diatr DIA_ATRASO, --dias de atraso                                                                                         --57                                                                                                                
                    t13.v_ncuopp,--numero de cuota pendientes de pago                                                                     --58                                        
                    t14.v_fvenuc,--aqpb763fvnui,--fecha de vencimiento de ultima cuota impaga                                             --59                                        
                    t12.v_fvenu,--aqpb763fvnup,--fecha de vencimiento de ultima cuota pagada                                              --60                                        
                    t12.v_fpagu,--v_ufpago,--aqpb763fpup, --fecha de pago de ultmo pago                                                   --61                                        
                    t13.v_ncuopa  aqpb763cuop,--aqpb763cuop, --numero de cuotas pagadas   --2024.07.11                                                              --62                                        
                    t19.v_tsum,--aqpb763mcuop,--monto de cuotas pagadas     --2024.07.19                                                              --63                                        
                    t19.v_cuo,--pago realizado - capital                    --2024.07.19                                                               --64                                        
                    t19.v_icv, --pago realizado - interes compensatorio     --2024.07.19                                                               --65                                        
                    t19.v_mor, --pago realizado - interese moratorio        --2024.07.19                                                               --66                                        
                    t19.v_int, --pago realizado - interes                   --2024.07.19                                                               --67                                        
                    t19.v_pen, --pago realizado - penalidad                 --2024.07.19                                                               --68                                        
                    t19.v_gas,--pago realizado -seguros                     --2024.07.19                                                               --69                                        
                    --ld_fecha_rcc,--aqpb763fcsbs,--fecha clasificacion sbs                                                                 --70                                        
                    t16.v_calif0, --califiacion sbs normal                                                                                --71                                        
                    t16.v_calif1, --califiacion sbs cpp                                                                                   --72                                        
                    t16.v_calif2, --califiacion sbs deficiente                                                                            --73                                        
                    t16.v_calif3, --califiacion sbs dudoso                                                                                --74                                        
                    t16.v_calif4, --califiacion sbs perdida                                                                               --75                                        
                    case when nvl(t3.aqpc366btea,0) = 0 then t1.aotasa else t3.aqpc366btea end TEA ,--aqpb763tea,  --tea                      --76                                        
                    t30.v_tmor,--aqpb763team, --tasa moratoria                                                                            --77                                        
                    case when t17.v_ciuu4 <> 0 then t17.v_ciuu4 else (case when t17.v_ciuu6 <> 0 then to_number(substr(to_char(t17.v_ciuu6), 1, 4)) else 0 end) end CIUU, -- ciuu    --78  
                    case when t17.v_ciuu4 <> 0 then  substr(trim(t23.actnom1), 1, 60) else  '' end ACTIVIDAD_ECO, --actividad economica                                                       --79  
                                                                                                                                                                                  
                    t18.v_pcre,--aqpb763tcre, --tipo de crdito sbs                                                                        --80                                        
                                                                                                                                                                                  
                    substr(t25.v_flag,1,1) FLAG_REPRO,--aqpb763repro,--flag reprogramacion                                                                                                 --81                                        
                    t25.v_fech,--aqpb763frpro,--fecha reprogramacion                                                                                                            --82  
                    t25.v_nrep,--aqpb763nrpro,--numero de reprogramaciones                                                                                                      --83  
                    t25.v_fpri,--aqpb763fprcr,--fecha de primera cuota reprogramacion                                                                                           --84  
                    t25.v_fult,--aqpb763ffnpr,--fecha fin de credito posterior a reprogramacion                                                                                 --85  
                    t25.v_ncuo,--aqpb763ncuor,--numero de cuotas posterior a reprogramacion                                                                                     --86  
                    t25.v_peri,--aqpb763grac, --periodo de gracia posterior a reprogramacion                                                                                    --87  
                    case when t17.v_ciuu4 <> 0 then t17.v_ciuu4 else (case when t17.v_ciuu6 <> 0 then to_number(substr(to_char(t17.v_ciuu6), 1, 4)) else 0 end) end CIU4, -- ciuu    --88  
                    case when t17.v_ciuu4 <> 0 then  substr(trim(t23.actnom1), 1, 60) else  '' end ACTIVIDAD4, --actividad economica    --89                                                                     
                    t1.pgcod, --pgcod                                                                                        --90                                                     
                    t1.aomod, -- modulo                                                                                      --91                                                     
                    t1.aosuc, --sucursal                                                                                     --92                                                     
                    t1.aomda, --moneda                                                                                       --93                                                     
                    t1.aopap, --papel                                                                                        --94                                                     
                    t1.aosbop, --suboperacion                                                                                --95                                                     
                    t1.aotope, --tipo operacion                                                                              --96                                                     
                                                                                                                                                                                 
                    to_char(sysdate, 'DD/MM/YYYY') FECHA,                                                                          --97                                                     
                    to_char(sysdate, 'HH24:MI:SS') HORA,                                                                          --98                                                     
                                                                                                                                                                                  
                    t35.v_intcom,--aqpb394intcom,                                                                            --99                                                      
                    t35.v_intmor,--aqpb394intmor,                                                                            --100                                                     
                    t35.v_intcov,--aqpb394intcov,                                                                            --101                                                     
                    t35.v_penali,--aqpb394penali,                                                                            --102                                                     
                    --0,--aqpc360pen    ,                                                                                    
                    t3.aqpc366bcertrn,--aqpc360certrn ,                                                                      --103
                    t3.aqpc366bcobren,--aqpc360cobren                                                                        --104
                    t33.v_saldo_inso SALDO_INSOLUTO, --saldo insoluto antes de prpago                                                       --105
                    t19.v_cuo aqpb394prpago,--aqpb394prpago,                                                                               --106
                    t35.v_pagrea,--aqpb394pagrea,                                                                            --107
                    t35.v_pramrt,--aqpb394pramrt,                                                                            --108
                    case when t3.aqpc366bperio is null then t35.v_nrccor else t3.aqpc366bperio end NRCCOR,--aqpb394nrccor,          --109
                    t35.v_nrccac,--aqpb394nrccac,                                                                            --110                
                    t35.v_vulcpa,--aqpb394vulcpa,                                                                            --111
                    t35.v_vcprve,--aqpb394vcprve,                                                                            --112
                    t35.v_fuclpr,--aqpb394fuclpr,                                                                            --113
 --20240711 numero cuotas pagadas capital                  case when (t13.v_ncuopa-(t31.v_pgra/30))< 0 then 0 else t13.v_ncuopa-(t31.v_pgra/30) end--numero de cuotas pagadas capital
                    t38.v_ncuopa               ---20240711                                                                   --114                   
                    --t16.v_csbs, --cod sbs 
                    
                    --t32.v_monto_prepago,--prepago total
                    --case when t1.aofe99 > pd_fecpro then null else t1.aofe99 end, --fecha prepago total
                    --CASE WHEN pd_fecpro <= t14.v_fvenuc THEN NULL ELSE t14.v_fvenuc END, --fecha de vencimiento pago mora
                    
                    from aqpc366b t3  
                    inner join fsd010 t1 on t3.aqpc366bcod = t1.pgcod and t3.aqpc366bcta = t1.aocta and t3.aqpc366bope = t1.aooper
                    left join fsd011 t26 on t26.pgcod = t1.pgcod  and t26.scmda = t1.aomda and t26.scpap = t1.aopap and t26.sccta = t1.aocta and t26.scoper = t1.aooper and t26.scsbop = t1.aosbop and t26.sctope = t1.aotope and t26.scmod = t1.aomod
                    inner join fsr008 t2 on t2.pgcod = t1.pgcod and t2.ctnro = t1.aocta and t2.cttfir = 'T'
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_actual(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t4 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_insoluto_imp(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro,5,t1.aostat,t1.aofe99)) t5 on 1=1
                    left join fst001 t6 on t6.pgcod = t1.pgcod and t6.sucurs = t1.aosuc 
                    left join fst811 t7 on t7.pgcod = t1.pgcod and t7.oficod = t1.aosuc and t7.regcod < 100 and t7.regcod <> 0
                    left join fst810 t8 on t8.pgcod = t7.pgcod and t8.regcod = t7.regcod
                    left join fst198 t9 on t9.tp1cod = 1 and t9.tp1cod1 = 10872 and t9.tp1corr1 = 11 and t9.tp1nro2 = t7.regcod
                    left join fsd002 t10 on t10.pfpais = t2.pepais and t10.pftdoc = t2.petdoc and t10.pfndoc = t2.pendoc
                    left join fsd003 t11 on t11.pjpais = t2.pepais and t11.pjtdoc = t2.petdoc and t11.pjndoc = t2.pendoc
                    left join table(pq_cr_reporte_utilitarios.fn_get_fechas_pago(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t12 on 1=1
--                    left join table(pq_cr_reporte_utilitarios.fn_get_cuota_pago(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,t12.v_fvenu)) t13 on 1=1 --20240711 original
left join table(pq_cr_reporte_utilitarios.fn_get_cuota_pago_IMP(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,t12.v_fpagu /*t12.v_fvenu*/)) t13 on 1=1 --20240719 modificado
 left join table(pq_cr_reporte_utilitarios.fn_get_cuota_pagoT(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,t12.v_fpagu /*t12.v_fvenu*/)) t38 on 1=1 ---20240719
                    left join table(pq_cr_reporte_utilitarios.fn_get_fvcuo_impaga(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t14 on 1=1
--                    left join table(pq_cr_reporte_utilitarios.fn_get_dias_atraso(pd_fecpro,t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,t1.aofvto)) t15 on 1=1   --20240816 original
                    left join table(pq_cr_reporte_utilitarios.fn_get_dias_atraso_imp(pd_fecpro,t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,t1.aofvto)) t15 on 1=1     --20240815 modificado        
--                    left join table(pq_cr_reporte_utilitarios.fn_get_calif_sbs(t2.petdoc,t2.pendoc,pd_fecpro)) t16 on 1=1   --original
left join table(pq_cr_reporte_utilitarios.fn_get_calif_sbs_IMP(t2.petdoc,t2.pendoc,pd_fecpro)) t16 on 1=1 -----20240719 modificado
                    left join table(pq_cr_reporte_utilitarios.fn_get_acti_eco(t2.pepais,t2.petdoc,t2.pendoc)) t17 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_tipo_credito_sbs_vig(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t18 on 1=1
--                    left join table(pq_cr_reporte_utilitarios.fn_get_distribuc_pago(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t19 on 1=1 --se comento para impulsa
                    left join table(pq_cr_reporte_utilitarios.fn_get_distribuc_pago_IMP(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t19 on 1=1 --20240719 se agrego para impulsa
--                    left join table(pq_cr_reporte_utilitarios.fn_get_mprepago(t1.pgcod,t1.aomod,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aotope,pd_fecpro)) t20 on 1=1 ---20240719 se comento para impulsa
                    left join table(pq_cr_reporte_utilitarios.fn_get_mprepago_IMP(t1.pgcod,t1.aomod,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aotope,pd_fecpro)) t20 on 1=1  --20240719 se agrego para impulsa
                    left join table(pq_cr_reporte_utilitarios.fn_get_calf_caja(t1.aocta,pd_fecpro)) t21 on 1=1                      
                    left join aqpb434 t22 on t22.aqpb434cod = t1.pgcod and t22.aqpb434cta = t1.aocta and t22.aqpb434ope = t1.aooper and t22.aqpb434est = 'C' 
                    left join fst750 t23 on t23.actcod1 = t17.v_ciuu6 
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_honrado(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,9300082070000,pd_fecpro)) t24 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_repro_dato1(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t25 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_analista_credito(t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope)) t27 on 1=1
                    left join fst026 t28 on t28.cecod = t1.aostat
                    left join table(pq_cr_reporte_utilitarios.fn_get_fcamb_estado(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t30 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_pergracia_imp(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t31 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_mprepago_acum_imp(t1.pgcod,t1.aomod,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aotope,pd_fecpro)) t32 on 1=1 
                    left join table(pq_cr_reporte_utilitarios.fn_get_saldo_insoluto_imp(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,lc_fmant,5,t1.aostat,t1.aofe99)) t33 on 1=1
--                  left join table(pq_cr_reporte_utilitarios.fn_get_otros_repfondos(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro,3)) t35 on 1=1 --20240815 original
                    left join table(pq_cr_reporte_utilitarios.fn_get_otros_repfondos_imp(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro,3)) t35 on 1=1 --20240815 modificado
                                        
                    left join table(pq_cr_reporte_utilitarios.fn_get_fec_creorigen2(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope)) t36 on 1=1
                    left join table(pq_cr_reporte_utilitarios.fn_get_rubro(t1.pgcod,t1.aomod,t1.aosuc,t1.aomda,t1.aopap,t1.aocta,t1.aooper,t1.aosbop,t1.aotope,pd_fecpro)) t37 on 1=1
                    where t1.aomod in(101,102,200,33)
                    --and t1.aotope in (356,357)
                    and t1.aostat  = 99
              ------ and t1.aoCTA in ( 3913480,1621440)  and t1.aooper in (16364712,15843595)
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
                            and t3.aqpc366best <> 'D'
                            and t1.aofval <= pd_fecpro   
                            and t1.aosuc = pn_suc
                    ----    and t1.aoCTA in ( 3913480,1621440)  and t1.aooper in (16364712,15843595)
                            ;                     
                                    


                            
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
    
    for i in creditos(lc_fmant) loop
    
        begin
          insert into aqpc366(  aqpc366usur   ,   --1
                                aqpc366fproc  ,   --2
                                aqpc366ncta   ,   --3
                                aqpc366nope   ,   --4
                                aqpc366rucc   ,   --5
                                aqpc366ncer   ,   --6
                                aqpc366nsol   ,   --7
                                aqpc366codgar ,   --8
                                aqpc366codcob ,   --9
                                aqpc366codsub ,   --10
                                aqpc366idcof  ,   --11
                                aqpc366orifon ,   --12
                                aqpc366npre   ,   --13
                                aqpc366fdes   ,   --14
                                aqpc366fprcu  ,   --15
                                aqpc366ffinc  ,   --16
                                aqpc366finc   ,   --17
                                aqpc366ffnc   ,   --18
                                aqpc366tdest  ,   --19
                                aqpc366mone  ,    --20
                                aqpc366scap   ,   --21
                                aqpc366sins   ,   --22
                                aqpc366mpre   ,   --23
                                aqpc366fclas  ,   --24
                                aqpc366cnor   ,   --25
                                aqpc366ccpp   ,   --26
                                aqpc366cdef   ,   --27
                                aqpc366cdud   ,   --28
                                aqpc366cper   ,   --29
                                aqpc366scon   ,   --30
                                aqpc366tpre   ,   --31
                                aqpc366atru   ,   --32
                                aqpc366rgon   ,   --33
                                aqpc366zona   ,   --34
                                aqpc366agen   ,   --35
                                aqpc366anal   ,   --36
                                aqpc366tdoc   ,   --37
                                aqpc366ndoc   ,   --38
                                aqpc366rsoc   ,   --39
                                aqpc366nomc   ,   --40
                                aqpc366temp  ,    --41
                                aqpc366est  ,     --42
                                aqpc366estd   ,   --43
                                aqpc366fest   ,   --44
                                aqpc366cdes   ,   --45
                                aqpc366perio  ,   --46
                                aqpc366pgra   ,   --47
                                aqpc366ncuod  ,   --48
                                aqpc366cobr   ,   --49
                                aqpc366mcob   ,   --50
                                aqpc366chon   ,   --51
                                aqpc366fhon   ,   --52
                                aqpc366mhon   ,   --53
                                aqpc366sdocap ,   --54
                                aqpc366sdohon ,   --55
                                aqpc366crehon ,   --56
                                aqpc366datr   ,   --57
                                aqpc366cpen   ,   --58
                                aqpc366fvnui  ,   --59
                                aqpc366fvnup  ,   --60
                                aqpc366fpup   ,   --61
                                aqpc366cuop   ,   --62 ---
                                aqpc366mcuop  ,   --63
                                aqpc366prcap  ,   --64
                                aqpc366pinc   ,   --65
                                aqpc366pinm   ,   --66
                                aqpc366prin   ,   --67
                                aqpc366prpn   ,   --68
                                aqpc366prseg  ,   --69 
                                aqpc366fcsbs  ,   --70
                                aqpc366snor   ,   --71
                                aqpc366scpp   ,   --72
                                aqpc366sdef   ,   --73
                                aqpc366sdud   ,   --74
                                aqpc366sper   ,   --75
                                aqpc366tea    ,   --76
                                aqpc366team   ,   --77
                                aqpc366ciuu   ,   --78
                                aqpc366aeco   ,   --79
                                aqpc366tcre   ,   --80
                                aqpc366repro  ,   --81
                                aqpc366frpro  ,   --82
                                aqpc366nrpro  ,   --83
                                aqpc366fprcr  ,   --84
                                aqpc366ffnpr  ,   --85
                                aqpc366ncuor  ,   --86
                                aqpc366grac   ,   --87
                                aqpc366ciuo   ,   --88
                                aqpc366aecoo  ,   --89
                                aqpc366emp    ,   --90
                                aqpc366mod    ,   --91
                                aqpc366suc    ,   --92
                                aqpc366mnda   ,   --93
                                aqpc366papl   ,   --94
                                aqpc366sbop   ,   --95
                                aqpc366tope   ,   --96
                                aqpc366fcr    ,   --97
                                aqpc366hcr    ,   --98
                                aqpc366intcom ,   --99
                                aqpc366intmor ,   --100
                                aqpc366intcov ,   --101
                                aqpc366pen    ,   --102
                                aqpc366certrn ,   --103
                                aqpc366cobren ,   --104
                                aqpc366sinsap ,   --105
                                aqpc366prpago ,   --106
                                aqpc366pagrea ,   --107
                                aqpc366pramrt ,   --108
                                aqpc366nrccor ,   --109
                                aqpc366nrccac ,   --110
                                aqpc366vulcpa ,   --111
                                aqpc366vcprve ,   --112
                                aqpc366fuclpr ,   --113
                                aqpc366cuopc      --114
                              )
                    values( 
                      rpad(trim(pn_usuario), 10, ' '), --usuario 
                      pd_fecpro, --fecha proceso                                                                                                                                    --2
                      i.aocta, --cuenta                                                                                                                                            --3
                      i.aooper, --operacion                                                                                                                                        --4
                      i.RUC,  --RUC caja                                                                                                                                    --5
                      i.aqpc366bncer, --numero certificado                                                                                                                         --6
                      i.aqpc366bnsol, --cod solicitud cofide                                                                                                                       --7
                      i.aqpc366bcodgar, --cod garantia                                                                                                                             --8
                      i.aqpc366bcodcob, --cod cobertura                                                                                                                            --9
                      i.aqpc366bcodsub, --cod subasta                                                                                                                              --10
                      i.aqpc366bidcof, --id cof                                                                                                                                    --11
                      i.aqpc366borifon, --orign fondos                                                                                                                             --12
                      i.PRESTAMO,-- --numero prestamo                         --13
                      i.aofval, --fecha desembolso                                                                                                                                 --14
                      i.v_finior, --fecha primera cuota                                                                                                                           --15
                      i.aofvto, --fecha fin credito, --fecha fin credito                                                                                                           --16
                      i.aqpc366bfinc,--fecha inicio cofide                                                                                                                         --17
                      i.aqpc366bffnc,-- fecha fin cofide                                                                                                                           --18
                      i.aqpc366btdest, --tipo destino                                                                                                                              --19
                      i.MONEDA, --moneda desc                                                                                         --20
                      i.v_saldo_actual, --saldo capital                                                                                                                            --21
                      i.v_saldo_inso, --saldo insoluto                                                                                                                             --22
                      i.v_monto_prepago, --monto prepago                                                                                                                          --23
                      i.v_deccaj,--fecha clasificacion caja                                                                                                                       --24
                      i.v_califa0, --clasificacion  normal                                                                                                                        --25
                      i.v_califa1, --clasificacion  cpp                                                                                                                           --26
                      i.v_califa2, --clasificacion  deficiente                                                                                                                    --27
                      i.v_califa3, --clasificacion  dudoso                                                                                                                        --28
                      i.v_califa4, --clasificacion  perdida                                                                                                                       --29
                      i.CONTABLE,--aqpb763scon, --situacion contable   --30
                      i.v_ncre,--aqpb763tpre, -- tipo de prestamo     --31                                                                                                            
                      i.v_diatr, --dias de atraso                     --32                                                                                                            
                      i.tp1desc, --region                              --33                                                                                                            
                      i.regnom, --zona                                 --34                                                                                                            
                      i.scnom, --agencia                               --35                                                                                                            
                      i.v_ase, --analista                             --36                                                                                                            
                      i.petdoc,--t2.petdoc, --tipo docuemnto           --37                                                                                                            
                      i.pendoc,--t2.pendoc, -- numero documneto        --38                                                                                                            
                      i.razon, --razon social     --39                                                                                                            
                      i.nomcli, --nombre del cliete --40
                      i.aqpc366btamemp, --tamaño empresa               --41                                                                                                                                         
                      i.aostat,                                        --42                                                                                                            
                      i.cenom,--estado del credito                    --43                                                                                                            
                      i.FEC_CAMBIO, --fecha de cuando se realizo cambio de estado --44
                      i.AQPC366BMONCOF,--2024.04.15 dcastro t1.aoimp,-- monto desembolsado               --45                                                                          
                      i.PERIODO_TOT,--periodo total del crdito  --46
                      i.PERIODO_GRACIA, --periodo de gracia del desembolos    --47                                       
                      i.NUMERO_CUO,--numero decuotas del crdito --48
                      i.aqpc366bprccof, --% de cobertura                                                                                   --49                                        
                      i.MONTO_COB, --monto de cobertura (saldo isnoluto*%de cobertura)                       --50                                        
                      i.HONRADO, --credito honrado(s/n)                                      --51                                        
                      i.aqpb434fecr, --fecha de honramiento                                                                               --52                                        
                      i.aqpb434mto,--aqpb763mhon, --monto honrado                                                                         --53                                        
                      i.saldo_Capital_Act, --saldo capital                                                                                    --54                                        
                      i.v_saldo_honrado,-- SALDO HONRADO                                                                                  --55                                        -
                      i.SALDO_HONRADO, -- SALDO CREDITRO HONRADO = saldo actual +saldo honrado                       --56                                        
                      i.DIA_ATRASO, --dias de atraso                                                                                         --57                                                                                                                
                      i.v_ncuopp,--numero de cuota pendientes de pago                                                                     --58                                        
                      i.v_fvenuc,--aqpb763fvnui,--fecha de vencimiento de ultima cuota impaga                                             --59                                        
                      i.v_fvenu,--aqpb763fvnup,--fecha de vencimiento de ultima cuota pagada                                              --60                                        
                      i.v_fpagu,--v_ufpago,--aqpb763fpup, --fecha de pago de ultmo pago                                                   --61                                        
                      i.aqpb763cuop,--aqpb763cuop, --numero de cuotas pagadas   --2024.07.11                                                              --62                                        
                      i.v_tsum,--aqpb763mcuop,--monto de cuotas pagadas     --2024.07.19                                                              --63                                        
                      i.v_cuo,--pago realizado - capital                    --2024.07.19                                                               --64                                        
                      i.v_icv, --pago realizado - interes compensatorio     --2024.07.19                                                               --65                                        
                      i.v_mor, --pago realizado - interese moratorio        --2024.07.19                                                               --66                                        
                      i.v_int, --pago realizado - interes                   --2024.07.19                                                               --67                                        
                      i.v_pen, --pago realizado - penalidad                 --2024.07.19                                                               --68                                        
                      i.v_gas,--pago realizado -seguros                     --2024.07.19                                                               --69                                        
                      ld_fecha_rcc,--aqpb763fcsbs,--fecha clasificacion sbs                                                                 --70                                        
                      i.v_calif0, --califiacion sbs normal                                                                                --71                                        
                      i.v_calif1, --califiacion sbs cpp                                                                                   --72                                        
                      i.v_calif2, --califiacion sbs deficiente                                                                            --73                                        
                      i.v_calif3, --califiacion sbs dudoso                                                                                --74                                        
                      i.v_calif4, --califiacion sbs perdida                                                                               --75                                        
                      i.TEA ,--aqpb763tea,  --tea                      --76                                        
                      i.v_tmor,--aqpb763team, --tasa moratoria                                                                            --77                                        
                      i.CIUU, -- ciuu    --78  
                      i.ACTIVIDAD_ECO, --actividad economica                                                       --79  
                      i.v_pcre,--aqpb763tcre, --tipo de crdito sbs                                                                        --80                                        
                      i.FLAG_REPRO,--aqpb763repro,--flag reprogramacion                                                                                                 --81                                        
                      i.v_fech,--aqpb763frpro,--fecha reprogramacion                                                                                                            --82  
                      i.v_nrep,--aqpb763nrpro,--numero de reprogramaciones                                                                                                      --83  
                      i.v_fpri,--aqpb763fprcr,--fecha de primera cuota reprogramacion                                                                                           --84  
                      i.v_fult,--aqpb763ffnpr,--fecha fin de credito posterior a reprogramacion                                                                                 --85  
                      i.v_ncuo,--aqpb763ncuor,--numero de cuotas posterior a reprogramacion                                                                                     --86  
                      i.v_peri,--aqpb763grac, --periodo de gracia posterior a reprogramacion                                                                                    --87  
                      i.CIU4, -- ciuu    --88  
                      i.ACTIVIDAD4, --actividad economica    --89                                                                     
                      i.pgcod, --pgcod                                                                                        --90                                                     
                      i.aomod, -- modulo                                                                                      --91                                                     
                      i.aosuc, --sucursal                                                                                     --92                                                     
                      i.aomda, --moneda                                                                                       --93                                                     
                      i.aopap, --papel                                                                                        --94                                                     
                      i.aosbop, --suboperacion                                                                                --95                                                     
                      i.aotope, --tipo operacion                                                                              --96                                                     
                      i.FECHA,                                                                          --97                                                     
                      i.HORA,                                                                          --98                                                     
                      i.v_intcom,--aqpb394intcom,                                                                            --99                                                      
                      i.v_intmor,--aqpb394intmor,                                                                            --100                                                     
                      i.v_intcov,--aqpb394intcov,                                                                            --101                                                     
                      i.v_penali,--aqpb394penali,                                                                            --102                                                     
                      i.aqpc366bcertrn,--aqpc360certrn ,                                                                      --103
                      i.aqpc366bcobren,--aqpc360cobren                                                                        --104
                      i.saldo_insoluto, --saldo insoluto antes de prpago                                                       --105
                      i.aqpb394prpago,--aqpb394prpago,                                                                               --106
                      i.v_pagrea,--aqpb394pagrea,                                                                            --107
                      i.v_pramrt,--aqpb394pramrt,                                                                            --108
                      i.NRCCOR,--aqpb394nrccor,          --109
                      i.v_nrccac,--aqpb394nrccac,                                                                            --110                
                      i.v_vulcpa,--aqpb394vulcpa,                                                                            --111
                      i.v_vcprve,--aqpb394vcprve,                                                                            --112
                      i.v_fuclpr,--aqpb394fuclpr,                                                                            --113
                      i.v_ncuopa               ---20240711                                                                   --114                   
                    ); 
  
                              
                        commit;
       exception when others then null;
         end;
    
   
   end loop;
    
     
  end sp_cr_impulsoOP;
------------------------------------------------------------------
procedure sp_cr_sch_impulsoOP(pd_fecpro  in date,
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

    str varchar2(100);

  
    cursor sucursal is
      select *
        from fst001
       where pgcod = 1
         and sucurs < 800
      ;

  
  begin
  
        ---2024.08.23 se agrego truncate table  
      BEGIN
       str := 'TRUNCATE TABLE AQPC366';
       execute immediate(str);
      exception when others then null; 
      END; 
  
    /* 2024.08.23 se comentó delete
    begin
      delete from aqpc366 x
       where x.aqpc366usur = rpad(trim(pn_usuario), 10, ' ');
      commit;
  exception when others then null;
    end;
    */
    
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
    lc_prefijo    := 'FIMP' || lc_user;
    lc_paquete    := 'pq_cr_reporte_impulso';
    lc_proceso    := 'sp_cr_impulsoOP';
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
                       '  pq_cr_reporte_impulso.sp_cr_impulsoOP( TO_DATE(''' ||
                       lc_fecpro || ''',''RRRR.MM.DD''),' || ln_ini ||
                       ',''' || pn_usuario || ''' );' || ' End;';
    
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        
      
        dbms_job.submit(job_id,
                        what      => lc_variable,
                        next_date => sysdate,
                        interval  => null,
                        no_parse  => false,
                       -- instance  => 2,
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
    pq_cr_reporte_impulso.sp_guardar_historico(pn_usuario, pd_fecpro);
  
      
  
  end sp_cr_sch_impulsoOP;

procedure sp_cr_impulsoBT(pd_fecpro  in date,
                               pn_suc in number,
                               pn_usuario in varchar2
                               ) is
/* ************************************************************************************************************
    -- Nombre                     : sp_cr_sch_impulsoBT
    -- Sistema                    : BANTOTAL
    -- Módulo                     : Creditos
    -- Descripción                : Carga data para Reporte impulso en aqpc366b 
    -- Versión                    : 1.0
    -- Fecha de Creación          : 28/08/2023
    -- Autor de Creación          : rmontesr
    -- Estado                     : Activo
    -- Acceso                     : Público
    -- Fecha de Modificación      : 15/04/2024
    -- Autor de Modificación      : DCASTRO
    -- Descripción Modificación   : Se modificó obtencion de campo monto desembolsado de tabla t1.aoimp
                                  : 11/07/2024 DCASTRO  Se modificó el calculo de numero de cuotas de capital pagadas pq_cr_reporte_utilitarios.fn_get_cuota_pagoT (T38)
                                  : 15/10/2024 DCASTRO  Se modifico llamada a dias de atraso por fn_get_dias_atraso_IMP                                  
* *************************************************************************************************************/
     
cursor listado is
select /*+all_rows*/ *                
    from aqpc366b t3 , fsd010 t1                    
    where t3.aqpc366best <> 'D'
    and t1.pgcod = 1
    and t1.aomod in (select modulo from fst111 where dscod = 50 and modulo not in (29, 120, 144))
    and t1.aosuc = pn_suc
    and t1.aopap = 0
    and t1.aocta = t3.aqpc366bcta
    and t1.aooper = t3.aqpc366bope      
    --and t1.aocta = 3274640	
    --and t1.aooper = 15926062
    and t1.aostat <> 99
    and t1.aofval <= pd_fecpro  
    --and t3.aqpc366bcta = 4240549
    --and t3.aqpc366bope = 19214691
;
     
cursor listadoCA is
select /*+all_rows*/ *                
    from aqpc366b t3 , fsd010 t1                    
    where t3.aqpc366best <> 'D'
    and t1.pgcod = 1
    and t1.aomod in (select modulo from fst111 where dscod = 50 and modulo not in (29, 120, 144))
    and t1.aosuc = pn_suc
    and t1.aopap = 0
    and t1.aocta = t3.aqpc366bcta
    and t1.aooper = t3.aqpc366bope      
/*    and t1.aocta = 73233 --------------------
    and t1.aooper = 16369874------------------*/
    and t1.aostat  = 99
    and t1.aofval <= pd_fecpro   
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
       and  ( t1.aofe99 , t1.aosbop ) in  ---2024.09.13 se agrego t1.aosbop
       (select max(h.aofe99), max(h.aosbop)
          from fsd010 h
         where h.pgcod = t1.pgcod
           and h.aosuc in (select sucurs from fst001 x where x.sucurs < 800) ---2024.09.14 dcastro se agrego sucursal
           and h.aomda = t1.aomda
           and h.aopap = t1.aopap
           and h.aocta = t1.aocta
           and h.aooper = t1.aooper
           and h.aomod in (select modulo
                             from fst111
                            where dscod = 50
                              and modulo not in (29, 120, 144)));
                     
 ---COPIAR AQUI

  RUC varchar2(12);                            
  ld_fecha_rcc date;
  ln_nro_mes number;  
  ld_fecha date;  
  lc_fmant date;                       
  v_saldo_actual number(18,2);
  saldo_Capital_Act   number(18,2);
  v_saldo_inso   number(18,2);
  pepais  number(4); 
  petdoc  number(4); 
  pendoc  char(12);
  scnom  varchar2(50);
  regnom varchar2(50);
  NOMCLI varchar2(100);
  RAZON  varchar2(100);
  v_fvenu date;
  v_fpagu date;
  v_fvenuc date;
  v_ncuopp number; 
  aqpb763cuop number;
  tp1desc varchar2(100);
  v_ncuopa number;
  v_diatr number;
  DIA_ATRASO number; 
  CIUU varchar2(100);
  ACTIVIDAD_ECO varchar2(100);
  v_ncre varchar2(100);
  v_pcre number;
  v_pcre18 number;  
  v_tsum number(18,2);
  v_cuo number(18,2);
  v_icv number(18,2);
  v_mor number(18,2);
  v_int number(18,2);
  v_pen number(18,2);
  v_gas number(18,2);
  aqpb394prpag number(18,2);

  v_monto_prepago number(18,2);
  v_calif0 number(6,2);
  v_calif1 number(6,2);
  v_calif2 number(6,2);
  v_calif3 number(6,2);
  v_calif4 number(6,2);
  v_deccaj  date;
  v_califa0 number(6,2);
  v_califa1 number(6,2);
  v_califa2 number(6,2);
  v_califa3 number(6,2);
  v_califa4 number(6,2);
  HONRADO varchar2(1);
  aqpb434fecr date;
  aqpb434mto number(18,2);

  v_saldo_honrado number(18,2);
  SALDO_HONRADO number(18,2);
  FLAG_REPRO char(1);
  v_fech     date;
  v_nrep     number;
  v_fpri     date;
  v_fult     date;
  v_ncuo     number;
  v_peri     number;
  v_ase      char(10);
  cenom      varchar2(50);
  FEC_CAMBIO date;
  v_fcest  date;
  v_tmor   number(6,2);
  v_pgra   number;
  PERIODO_TOT number;
  PERIODO_GRACIA number;
  NUMERO_CUO number;  
  v_monto_prepagot number(18,2);
  SALDO_INSOLUTO  number(18,2);
  v_intcom number(18,2);
  v_intmor number(18,2); 
  v_intcov number(18,2); 
  v_penali number(18,2); 
  v_pagrea number(18,2); 
  v_pramrt number(18,2);
  v_nrccac number(18,2); 
  v_vulcpa number(18,2); 
  v_vcprve number(18,2); 
  v_fuclpr date; 
  v_nrccor number;
  NRCCOR   number;
  v_finior date;
  CONTABLE varchar2(10);
  PRESTAMO varchar2(30);
  MONEDA VARCHAR2(10);
  MONTO_COB number;
  CIU4 number;
  ACTIVIDAD4  VARCHAR2(100);             
  TEA number(6,2); 
  FECHA varchar2(10);                                                                          --97                                                     
  HORA char(8);
  
  vaqpc366tiprep varchar2(30);
  vaqpc366flgamor varchar2(30);
  vaqpc366fecamor date;
  vaqpc366tcea number(17,2);
  vaqpc366tea2 number(17,2);
  
  --vcantCuotasPagadas number;
 --vultimaFechaPagoProgramado date;
 --vCancelacionAdelantado number;
 --vExisteOtroCredito number; 
 
 vi_cuota_mes_flg char(1);
vi_validar_pago char(2);
vi_validar_pago_total char(1);
vi_estado_cuota_mes char(1);
vi_fecha_real_pago date;
vi_fecha_pago_mes date;
vi_existe_pago number(1);
--pagos_adelantados number;

begin
  
   begin      
    select to_date(t.tpnro, 'DDMMYY')
      into ld_fecha_rcc
      from fst098 t
     where t.pgcod = 1
       and t.tpcod = 7647
       and t.tpcorr = 12;
   exception when others then 
     ld_fecha_rcc := null;    
   end;

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
    
    --RUC caja  
    RUC := '20100209641';

    --LISTADO VIGENTES    
    for i in listado loop
      
        MONEDA := case when i.aomda = 0 then 'SOLES' else 'DOLARES' end ; --moneda desc          --20
        TEA    := case when nvl(i.aqpc366btea,0) = 0 then i.aotasa else i.aqpc366btea end;--aqpb763tea,  --tea                      --76 
        PRESTAMO := concat(lpad(to_char(i.aocta), 9, '0'),concat(lpad(to_char(i.aomda), 3, '0'),lpad(to_char(i.aooper), 9, '0'))) ;-- --numero prestamo                         --13
            
     --PT: Prepago total, cancelación de la totalidad del crédito.
     
     /*
     --NO REALIZO NINGUN PAGO 
     begin    

       select count(1)
         into vcantCuotasPagadas
         from fsd602 b
        where b.pgcod = 1
          and b.ppcta = I.AQPC366BCTA
          and b.ppoper = I.AQPC366BOPE;
     
       if vcantCuotasPagadas = 0 then
         vaqpc366tiprep := '';
       end if;
     
     EXCEPTION
       WHEN OTHERS THEN
         vaqpc366tiprep := 'ERROR NINGUN PAGO';
     END;
     */
      --vaqpc366tiprep := 'gg';

     -----------------------------------------------------------------------------
                
   pq_cr_reporte_impulso.sp_columnas_extras_2025(
                                    p_fecha_proceso => pd_fecpro,
                                    p_xwfempresa => i.PGCOD,
                                    p_xwfsucursal => i.AOSUC,
                                    p_xwfmodulo => i.AOMOD,
                                    p_xwfmoneda => i.AOMDA,
                                    p_xwfpapel => i.AOPAP,
                                    p_xwfcuenta => i.AOCTA,
                                    p_xwfoperacion => i.AOOPER,
                                    p_xwfsubope => i.AOSBOP,
                                    p_xwftipope => i.AOTOPE,                                    
                                    po_aqpc366tiprep => vaqpc366tiprep,
                                    po_aqpc366flgamor => vaqpc366flgamor,
                                    po_aqpc366fecamor => vaqpc366fecamor,
                                    po_aqpc366tcea => vaqpc366tcea,
                                    po_aqpc366tea2 => vaqpc366tea2 ); 
                                                                  
     -----------------------------------------------------------------------------
   
        --fsr008
        begin
          select t2.pepais ,
            t2.petdoc,--t2.petdoc, --tipo docuemnto           --37                                                                                                            
            t2.pendoc--t2.pendoc, -- numero documneto        --38                                                                                                            
           into pepais, petdoc, pendoc         
          from fsr008 t2
          where t2.pgcod = i.pgcod  
            and t2.ctnro = i.aocta
            and t2.cttfir = 'T';
         exception when others then
            pepais := null;
            petdoc := null;
            pendoc := null;
         end;               

         --t4          
         begin
           select   t4.v_saldo_actual, --saldo capital  
                    t4.v_saldo_actual saldo_Capital_Act --saldo capital 
                into  v_saldo_actual,  saldo_Capital_Act
              from pq_cr_reporte_utilitarios.fn_get_saldo_actual(i.pgcod,i.aomod,i.aosuc,i.aomda,i.aopap,
                i.aocta,i.aooper,i.aosbop,i.aotope,pd_fecpro) t4 
           where  1=1;
         exception when others then
           v_saldo_actual := 0;
           saldo_Capital_Act := 0;
         end; 

         --t5
         begin
           select t5.v_saldo_inso --saldo insoluto
            into v_saldo_inso
            from pq_cr_reporte_utilitarios.fn_get_saldo_insoluto_imp(i.pgcod,i.aomod,i.aosuc,i.aomda,i.aopap,i.aocta,
                  i.aooper,i.aosbop,i.aotope,pd_fecpro,5,i.aostat,i.aofe99) t5 ;
           exception when others then
               v_saldo_inso := 0;
           end;

          --t6 
           begin  
           select t6.scnom, t8.regnom , t9.tp1desc
            into scnom, regnom, tp1desc
            from fst001 t6, fst811 t7, fst810 t8 , fst198 t9
           where t6.pgcod = 1
            and t6.sucurs = i.aosuc
            and t7.pgcod = i.pgcod 
            and t7.oficod = t6.sucurs
            and t7.regcod < 100 and t7.regcod <> 0
            and t8.pgcod = t7.pgcod and t8.regcod = t7.regcod 
            and t9.tp1cod = 1 and t9.tp1cod1 = 10872 
            and t9.tp1corr1 = 11 and t9.tp1nro2 = t7.regcod;  
         exception when others then
             scnom := null;
             regnom := null;
         end;   
 

       --t10
       begin
         select substr(concat(trim(t10.pfnom1),
                              concat(' ',
                                     concat(trim(t10.pfnom2),
                                            concat(' ',
                                                   concat(trim(t10.pfape1),
                                                          concat(' ', t10.pfape2)))))),
                       1,
                       60) --nombre del cliete --40
           into NOMCLI
           from fsd002 t10
          where t10.pfpais = pepais
            and t10.pftdoc = petdoc
            and t10.pfndoc = pendoc;
       exception
         when others then
           NOMCLI := null;
       end;
       
       --t11
       begin
         select trim(substr(t11.pjrazs, 0, 60)) --razon social     --39   
           into RAZON
           from fsd003 t11
          where t11.pjpais = pepais
            and t11.pjtdoc = petdoc
            and t11.pjndoc = pendoc;
       exception
         when others then
           RAZON := null;
       end;

       --t12
       begin
           select 
                 t12.v_fvenu,--aqpb763fvnup,--fecha de vencimiento de ultima cuota pagada                                              --60                                        
                 t12.v_fpagu--v_ufpago,--aqpb763fpup, --fecha de pago de ultmo pago                                                   --61                                        
            into v_fvenu, v_fpagu                
           from 
           pq_cr_reporte_utilitarios.fn_get_fechas_pago(i.pgcod,i.aomod,i.aosuc,i.aomda,i.aopap,i.aocta,
           i.aooper,i.aosbop,i.aotope,pd_fecpro) t12 ;
       exception when others then
         v_fvenu := null; 
         v_fpagu := null;
       end;

       --t13
       begin
          select t13.v_ncuopp,--numero de cuota pendientes de pago                                                                     --58                                        
                 t13.v_ncuopa  aqpb763cuop--aqpb763cuop, --numero de cuotas pagadas   --2024.07.11                                                              --62                                        
           into  v_ncuopp, aqpb763cuop    
        from                  
         pq_cr_reporte_utilitarios.fn_get_cuota_pago_IMP(i.pgcod,i.aomod,i.aosuc,i.aomda,
         i.aopap,i.aocta,i.aooper,i.aosbop,i.aotope,v_fpagu ) t13; 
       exception when others then
         v_ncuopp := 0; 
         aqpb763cuop := 0;
       end;

       begin
          select t38.v_ncuopa               ---20240711  
           into  v_ncuopa
        from                  
         pq_cr_reporte_utilitarios.fn_get_cuota_pagoT(i.pgcod,i.aomod,i.aosuc,i.aomda,
         i.aopap,i.aocta,i.aooper,i.aosbop,i.aotope,v_fpagu ) t38; 
       exception when others then
         v_ncuopa := 0; 
       end;
       
       begin
          select t14.v_fvenuc--aqpb763fvnui,--fecha de vencimiento de ultima cuota impaga                                             --59  
           into  v_fvenuc
        from                  
         pq_cr_reporte_utilitarios.fn_get_fvcuo_impaga(i.pgcod,i.aomod,i.aosuc,i.aomda,
         i.aopap,i.aocta,i.aooper,i.aosbop,i.aotope,pd_fecpro) t14; 
       exception when others then
         v_fvenuc := null; 
       end;

       begin
         select t15.v_diatr, --dias de atraso                     --32                                                                                                            
                t15.v_diatr DIA_ATRASO --dias de atraso  
         into v_diatr, DIA_ATRASO
         from
          pq_cr_reporte_utilitarios.fn_get_dias_atraso(pd_fecpro,i.pgcod,i.aomod,i.aosuc,
          i.aomda,i.aopap,i.aocta,i.aooper,i.aosbop,i.aotope,i.aofvto) t15;
         exception when others then
             v_diatr := 0;
             DIA_ATRASO := 0; 
                   
       end;              
       
       begin
         select 
                t16.v_calif0, --calificacion sbs normal                                                                                --71                                        
                t16.v_calif1, --calificacion sbs cpp                                                                                   --72                                        
                t16.v_calif2, --calificacion sbs deficiente                                                                            --73                                        
                t16.v_calif3, --calificacion sbs dudoso                                                                                --74                                        
                t16.v_calif4 --calificacion sbs perdida  
           into  
           v_calif0, v_calif1, v_calif2,v_calif3,v_calif4 
         from
         pq_cr_reporte_utilitarios.fn_get_calif_sbs_IMP(petdoc,pendoc,pd_fecpro) t16;       
       exception when others then
                    v_calif0 := 0;
                    v_calif1 := 0; 
                    v_calif2 := 0;
  
                    v_calif3 := 0;
                    v_calif4 := 0;
       end;


       --17
       begin
         select
              case when t17.v_ciuu4 <> 0 then t17.v_ciuu4 else (case when t17.v_ciuu6 <> 0 then to_number(substr(to_char(t17.v_ciuu6), 1, 4)) else 0 end) end, -- ciuu    --78  
              case when t17.v_ciuu4 <> 0 then  substr(trim(t23.actnom1), 1, 60) else  '' end  --actividad economica                                                       --79  
            into  CIUU, ACTIVIDAD_ECO             
         from   pq_cr_reporte_utilitarios.fn_get_acti_eco(pepais,petdoc,pendoc) t17, fst750 t23
         where t23.actcod1 = t17.v_ciuu6;         
       exception when others then
                CIUU := null; 
                ACTIVIDAD_ECO := null;
       end;            
       
     --------                      case when t17.v_ciuu4 <> 0 then t17.v_ciuu4 else (case when t17.v_ciuu6 <> 0 then to_number(substr(to_char(t17.v_ciuu6), 1, 4)) else 0 end) end CIU4, -- ciuu    --88  
     -------------               case when t17.v_ciuu4 <> 0 then  substr(trim(t23.actnom1), 1, 60) else  '' end ACTIVIDAD4, --actividad economica    --89                                                                     
     CIU4 :=  CIUU; 
     ACTIVIDAD4 := ACTIVIDAD_ECO ;
       
       --18
       begin
           select
                  t18.v_ncre,--aqpb763tpre, -- tipo de prestamo     --31    
                  t18.v_pcre--aqpb763tcre, --tipo de crdito sbs                                                                        --80                                                                                                                                                
           into   v_ncre, v_pcre18                       
           from   pq_cr_reporte_utilitarios.fn_get_tipo_credito_sbs_vig(i.pgcod,i.aomod,i.aosuc,
           i.aomda,i.aopap,i.aocta,i.aooper,i.aosbop,i.aotope,pd_fecpro) t18;        
       exception when others then
         v_ncre := null;
         v_pcre18 := null;
       end;
       --19
       begin
         select 
                    t19.v_tsum,--aqpb763mcuop,--monto de cuotas pagadas     --2024.07.19                                                              --63                                        
                    t19.v_cuo,--pago realizado - capital                    --2024.07.19                                                               --64                                        
                    t19.v_icv, --pago realizado - interes compensatorio     --2024.07.19                                                               --65                                        
                    t19.v_mor, --pago realizado - interese moratorio        --2024.07.19                                                               --66                                        
                    t19.v_int, --pago realizado - interes                   --2024.07.19                                                               --67                                        
                    t19.v_pen, --pago realizado - penalidad                 --2024.07.19                                                               --68                                        
                    t19.v_gas--,--pago realizado -seguros                     --2024.07.19                                                               --69                                        
                    --t19.v_cuo --aqpb394prpago,
           into
           v_tsum,v_cuo,v_icv,v_mor,v_int,v_pen,v_gas--,aqpb394prpag          
         from pq_cr_reporte_utilitarios.fn_get_distribuc_pago_IMP(i.pgcod,i.aomod,i.aosuc,
         i.aomda,i.aopap,i.aocta,i.aooper,i.aosbop,i.aotope,pd_fecpro) t19; --20240719 se agrego para impulsa
       exception when others then
          v_tsum := 0;
          v_cuo  := 0;
          v_icv  := 0;
          v_mor  := 0;
          v_int  := 0;
          v_pen  := 0;
          v_gas  := 0;
          --aqpb394prpag := 0;
       end;

       --20
       begin
         select t20.v_monto_prepago --monto prepago 
         into v_monto_prepago
         from pq_cr_reporte_utilitarios.fn_get_mprepago_IMP(i.pgcod,i.aomod,i.aomda,i.aopap,i.aocta,i.aooper,i.aotope,pd_fecpro) t20 ;
       exception when others then
          v_monto_prepago := 0;       
       end;

       --21       
       begin
          select  
                t21.v_deccaj,--fecha clasificacion caja                                                                                                                       --24
                t21.v_califa0, --clasificacion  normal                                                                                                                        --25
                t21.v_califa1, --clasificacion  cpp                                                                                                                           --26
                t21.v_califa2, --clasificacion  deficiente                                                                                                                    --27
                t21.v_califa3, --clasificacion  dudoso                                                                                                                        --28
                t21.v_califa4 --clasificacion  perdida    
          into  v_deccaj,v_califa0,v_califa1,v_califa2,v_califa3,v_califa4
             from pq_cr_reporte_utilitarios.fn_get_calf_caja(i.aocta,pd_fecpro) t21;                      
       exception when others then
            v_deccaj := null;
            v_califa0 := 0;
            v_califa1 := 0;
            v_califa2 := 0;
            v_califa3 := 0;
            v_califa4 := 0;
       end;
       --22
       begin
       select   
          case when t22.aqpb434fecr is null then 'N' else 'S' end , --credito honrado(s/n)                                      --51                                        
                    t22.aqpb434fecr, --fecha de honramiento                                                                               --52                                        
                    t22.aqpb434mto--aqpb763mhon, --monto honrado                                                                         --53                                        
       into HONRADO,  aqpb434fecr, aqpb434mto
       from aqpb434 t22 where t22.aqpb434cod = i.pgcod and t22.aqpb434cta = i.aocta and t22.aqpb434ope = i.aooper and t22.aqpb434est = 'C' ;
       exception when others then
         HONRADO := 'N';  
         aqpb434fecr := null;
         aqpb434mto  := null;
       end;
       
       --24
       begin
       select t24.v_saldo_honrado-- SALDO HONRADO                                                                                  --55                                        -
        into v_saldo_honrado
        from pq_cr_reporte_utilitarios.fn_get_saldo_honrado(i.pgcod,i.aomod,i.aosuc,i.aomda,i.aopap,i.aocta,i.aooper,i.aosbop,i.aotope,9300082070000,pd_fecpro) t24;
       exception when others then
          v_saldo_honrado := 0;
        end;       
        SALDO_HONRADO := v_saldo_actual + v_saldo_honrado; -- SALDO CREDITRO HONRADO = saldo actual +saldo honrado                       --56                                        
 
        --25   
        begin    
        select
                    substr(t25.v_flag,1,1) FLAG_REPRO,--aqpb763repro,--flag reprogramacion                                                                                                 --81                                        
                    t25.v_fech,--aqpb763frpro,--fecha reprogramacion                                                                                                            --82  
                    t25.v_nrep,--aqpb763nrpro,--numero de reprogramaciones                                                                                                      --83  
                    t25.v_fpri,--aqpb763fprcr,--fecha de primera cuota reprogramacion                                                                                           --84  
                    t25.v_fult,--aqpb763ffnpr,--fecha fin de credito posterior a reprogramacion                                                                                 --85  
                    t25.v_ncuo,--aqpb763ncuor,--numero de cuotas posterior a reprogramacion                                                                                     --86  
                    t25.v_peri--aqpb763grac, --periodo de gracia posterior a reprogramacion                                                                                    --87  
        into FLAG_REPRO, v_fech, v_nrep, v_fpri, v_fult, v_ncuo, v_peri                  
        from pq_cr_reporte_utilitarios.fn_get_repro_dato1(i.pgcod,i.aomod,i.aosuc,i.aomda,i.aopap,i.aocta,i.aooper,i.aosbop,i.aotope,pd_fecpro) t25;
        
        exception when others then
          FLAG_REPRO := null;
          v_fech    := null; 
          v_nrep    := null;
          v_fpri    := null;
          v_fult    := null;
          v_ncuo    := null;
          v_peri    := null;                   
        end;                           
        
        --t27
        begin 
          select t27.v_ase --analista                             --36    
        into v_ase  
        from pq_cr_reporte_utilitarios.fn_get_analista_credito(i.aomod,i.aosuc,i.aomda,i.aopap,i.aocta,i.aooper,i.aosbop,i.aotope) t27;
        exception when others then
          v_ase := null;
        end;
   
        --t28
        begin 
          select t28.cenom--estado del credito                    --43  
            into cenom         
           from fst026 t28 
           where t28.cecod = i.aostat;
        exception when others then
            cenom := null;      
        end;          
        
        --t30
        begin
          select t30.v_fcest,        
                 t30.v_tmor--aqpb763team, --tasa moratoria                                                                            --77                                                           
            into v_fcest, v_tmor
           from pq_cr_reporte_utilitarios.fn_get_fcamb_estado(i.pgcod,i.aomod,i.aosuc,i.aomda,i.aopap,i.aocta,i.aooper,i.aosbop,i.aotope,pd_fecpro) t30;
        exception when others then
          v_fcest := to_date('01/01/0001','DD/MM/YYYY');
          v_tmor := 0;
        end;
        FEC_CAMBIO :=
           case when v_fcest > nvl(i.aofe99,to_date('01/01/0001','DD/MM/YYYY')) then                                                                                
               (case when v_fcest > nvl(v_fech,to_date('01/01/0001','DD/MM/YYYY')) then v_fcest else v_fech end )                                       
               else (case when nvl(v_fech,to_date('01/01/0001','DD/MM/YYYY')) > nvl(i.aofe99,to_date('01/01/0001','DD/MM/YYYY')) then v_fech else i.aofe99 end)end ; --fecha de cuando se realizo cambio de estado --44

       --t31
       begin
           select t31.v_pgra
            into v_pgra   
           from pq_cr_reporte_utilitarios.fn_get_pergracia_imp(i.pgcod,i.aomod,i.aosuc,i.aomda,i.aopap,i.aocta,i.aooper,i.aosbop,i.aotope,pd_fecpro) t31;        
       exception when others then
          v_pgra := 0;
       end;

      PERIODO_TOT := case when i.aqpc366bperio is null then (case when i.aoperiod = 0 then 0 else  round(floor(i.aopzo/i.aoperiod),2) end + v_pgra/30) else i.aqpc366bperio end; --periodo total del crdito  --46
      PERIODO_GRACIA := case when i.aqpc366bpgra is null then (v_pgra/30) else i.aqpc366bpgra end;  --periodo de gracia del desembolos    --47                                       
      NUMERO_CUO := case when i.aqpc366bncuo is null then (case when i.aoperiod = 0 then 0 else  round(floor(i.aopzo/i.aoperiod),2) end) else i.aqpc366bncuo  end ;--numero decuotas del crdito --48

      --t32
      begin
          select t32.v_monto_prepago--prepago total 
          into v_monto_prepagoT             
       from pq_cr_reporte_utilitarios.fn_get_mprepago_acum_imp(i.pgcod,i.aomod,i.aomda,i.aopap,i.aocta,i.aooper,i.aotope,pd_fecpro) t32;
      exception when others then
        v_monto_prepagoT := 0;
      end;

      --t33
      begin
        select t33.v_saldo_inso 
        into SALDO_INSOLUTO --saldo insoluto antes de prpago                           --105
        from pq_cr_reporte_utilitarios.fn_get_saldo_insoluto_imp(i.pgcod,i.aomod,i.aosuc,i.aomda,i.aopap,i.aocta,i.aooper,i.aosbop,i.aotope,lc_fmant,5,i.aostat,i.aofe99) t33;
      exception when others then
         SALDO_INSOLUTO := 0;
      end;  
      
      --t35
      begin
       select t35.v_intcom,--aqpb394intcom,                                                                            --99                                                      
              t35.v_intmor,--aqpb394intmor,                                                                            --100                                                     
              t35.v_intcov,--aqpb394intcov,                                                                            --101                                                     
              t35.v_penali,--aqpb394penali,                                                                            --102                                                     
              t35.v_pagrea,--aqpb394pagrea,                                                                            --107
              t35.v_pramrt,--aqpb394pramrt,                                                                            --108
              t35.v_nrccac,--aqpb394nrccac,                                                                            --110                
              t35.v_vulcpa,--aqpb394vulcpa,                                                                            --111
              t35.v_vcprve,--aqpb394vcprve,                                                                            --112
              t35.v_fuclpr,--aqpb394fuclpr,  
              t35.v_nrccor
        into   
        v_intcom, v_intmor, v_intcov, v_penali, v_pagrea, v_pramrt,
        v_nrccac, v_vulcpa, v_vcprve, v_fuclpr, v_nrccor
       from pq_cr_reporte_utilitarios.fn_get_otros_repfondos_imp(i.pgcod,i.aomod,i.aosuc,i.aomda,i.aopap,i.aocta,i.aooper,i.aosbop,i.aotope,pd_fecpro,3) t35; --20240815 modificado
      exception when others then
        v_intcom := 0;
        v_intmor := 0;
        v_intcov := 0;
        v_penali := 0; 
        v_pagrea := 0;
        v_pramrt := 0;
        v_nrccac := 0; 
        v_vulcpa := 0;
        v_vcprve := 0; 
        v_fuclpr := null;
        v_nrccor := 0;
      end;  
      
      NRCCOR := case when i.aqpc366bperio is null then v_nrccor else i.aqpc366bperio end;--aqpb394nrccor,          --109

      --t36            
      begin
      select t36.v_finior --fecha primera cuota                                                                                                                           --15
        into v_finior            
       from pq_cr_reporte_utilitarios.fn_get_fec_creorigen2(i.pgcod,i.aomod,i.aosuc,i.aomda,i.aopap,i.aocta,i.aooper,i.aosbop,i.aotope) t36;                
      exception when others then
        v_finior := null;
      end;                    
      
      --t37
      begin
        select t37.v_pcre
        into v_pcre
        from pq_cr_reporte_utilitarios.fn_get_rubro(i.pgcod,i.aomod,i.aosuc,i.aomda,i.aopap,i.aocta,i.aooper,i.aosbop,i.aotope,pd_fecpro) t37;
      exception when others then
        v_pcre := 0;
      end;
      
      MONTO_COB := round(v_saldo_inso * i.aqpc366bprccof,2); --monto de cobertura (saldo isnoluto*%de cobertura)                       --50   
      --round(t5.v_saldo_inso*t3.aqpc366bprccof,2) MONTO_COB, --monto de cobertura (saldo isnoluto*%de cobertura)                       --50                                        
      
      CONTABLE :=  case when i.aostat = 99 and i.aofe99 <= pd_fecpro and i.aofe99 != '01/01/0001' then 'CNC' when i.aostat = 61 then 'RFN' when substr(v_pcre, 1, 4) = '1411' then 'VGT' 
                         when substr(v_pcre, 1, 4) = '1421' then 'VGT' when substr(v_pcre, 1, 4) = '1414' then 'RFN'                                                      
                         when substr(v_pcre, 1, 4) = '1424' then 'RFN' when substr(v_pcre, 1, 4) = '1415' then 'VCD'                                                      
                         when substr(v_pcre, 1, 4) = '1425' then 'VCD' when substr(v_pcre, 1, 4) = '1416' then 'JDC'                                                      
                         when substr(v_pcre, 1, 4) = '1426' then 'JDC' when substr(v_pcre, 1, 2) = '81' then 'CTG'                                                        
                         when substr(v_pcre, 1, 4) = '1413' then 'RTR' when substr(v_pcre, 1, 4) = '1423' then 'RTR'  else  '' end;--aqpb763scon, --situacion contable   --30

         FECHA :=   to_char(sysdate, 'DD/MM/YYYY');--97                                                     
         HORA  :=   to_char(sysdate, 'HH24:MI:SS'); --98
         
         BEGIN
          insert into aqpc366(  aqpc366usur   ,   --1
                                aqpc366fproc  ,   --2
                                aqpc366ncta   ,   --3
                                aqpc366nope   ,   --4
                                aqpc366rucc   ,   --5
                                aqpc366ncer   ,   --6
                                aqpc366nsol   ,   --7
                                aqpc366codgar ,   --8
                                aqpc366codcob ,   --9
                                aqpc366codsub ,   --10
                                aqpc366idcof  ,   --11
                                aqpc366orifon ,   --12
                                aqpc366npre   ,   --13
                                aqpc366fdes   ,   --14
                                aqpc366fprcu  ,   --15
                                aqpc366ffinc  ,   --16
                                aqpc366finc   ,   --17
                                aqpc366ffnc   ,   --18
                                aqpc366tdest  ,   --19
                                aqpc366mone  ,    --20
                                aqpc366scap   ,   --21
                                aqpc366sins   ,   --22
                                aqpc366mpre   ,   --23
                                aqpc366fclas  ,   --24
                                aqpc366cnor   ,   --25
                                aqpc366ccpp   ,   --26
                                aqpc366cdef   ,   --27
                                aqpc366cdud   ,   --28
                                aqpc366cper   ,   --29
                                aqpc366scon   ,   --30
                                aqpc366tpre   ,   --31
                                aqpc366atru   ,   --32
                                aqpc366rgon   ,   --33
                                aqpc366zona   ,   --34
                                aqpc366agen   ,   --35
                                aqpc366anal   ,   --36
                                aqpc366tdoc   ,   --37
                                aqpc366ndoc   ,   --38
                                aqpc366rsoc   ,   --39
                                aqpc366nomc   ,   --40
                                aqpc366temp   ,   --41
                                aqpc366est  ,     --42
                                aqpc366estd   ,   --43
                                aqpc366fest   ,   --44
                                aqpc366cdes   ,   --45
                                aqpc366perio  ,   --46
                                aqpc366pgra   ,   --47
                                aqpc366ncuod  ,   --48
                                aqpc366cobr   ,   --49
                                aqpc366mcob   ,   --50
                                aqpc366chon   ,   --51
                                aqpc366fhon   ,   --52
                                aqpc366mhon   ,   --53
                                aqpc366sdocap ,   --54
                                aqpc366sdohon ,   --55
                                aqpc366crehon ,   --56
                                aqpc366datr   ,   --57
                                aqpc366cpen   ,   --58
                                aqpc366fvnui  ,   --59
                                aqpc366fvnup  ,   --60
                                aqpc366fpup   ,   --61
                                aqpc366cuop   ,   --62 ---
                                aqpc366mcuop  ,   --63
                                aqpc366prcap  ,   --64
                                aqpc366pinc   ,   --65
                                aqpc366pinm   ,   --66
                                aqpc366prin   ,   --67
                                aqpc366prpn   ,   --68
                                aqpc366prseg  ,   --69 
                                aqpc366fcsbs  ,   --70
                                aqpc366snor   ,   --71
                                aqpc366scpp   ,   --72
                                aqpc366sdef   ,   --73
                                aqpc366sdud   ,   --74
                                aqpc366sper   ,   --75
                                aqpc366tea    ,   --76
                                aqpc366team   ,   --77
                                aqpc366ciuu   ,   --78
                                aqpc366aeco   ,   --79
                                aqpc366tcre   ,   --80
                                aqpc366repro  ,   --81
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         aqpc366frpro  ,   --82
                                aqpc366nrpro  ,   --83
                                aqpc366fprcr  ,   --84
                                aqpc366ffnpr  ,   --85
                                aqpc366ncuor  ,   --86
                                aqpc366grac   ,   --87
                                aqpc366ciuo   ,   --88
                                aqpc366aecoo  ,   --89
                                aqpc366emp    ,   --90
                                aqpc366mod    ,   --91
                                aqpc366suc    ,   --92
                                aqpc366mnda   ,   --93
                                aqpc366papl   ,   --94
                                aqpc366sbop   ,   --95
                                aqpc366tope   ,   --96
                                aqpc366fcr    ,   --97
                                aqpc366hcr    ,   --98
                                aqpc366intcom ,   --99
                                aqpc366intmor ,   --100
                                aqpc366intcov ,   --101
                                aqpc366pen    ,   --102
                                aqpc366certrn ,   --103
                                aqpc366cobren ,   --104
                                aqpc366sinsap ,   --105
                                aqpc366prpago ,   --106
                                aqpc366pagrea ,   --107
                                aqpc366pramrt ,   --108
                                aqpc366nrccor ,   --109
                                aqpc366nrccac ,   --110
                                aqpc366vulcpa ,   --111
                                aqpc366vcprve ,   --112
                                aqpc366fuclpr ,   --113
                                aqpc366cuopc      --114
                                
                                ,aqpc366tiprep ,   
                                aqpc366flgamor ,   
                                aqpc366fecamor ,  
                                aqpc366tcea ,    
                                aqpc366tea2                                    
                             )
                    values( 
                      rpad(trim(pn_usuario), 10, ' '), --usuario 
                      pd_fecpro, --fecha proceso                                                                                                                                    --2
                      i.aocta, --cuenta                                                                                                                                            --3
                      i.aooper, --operacion                                                                                                                                        --4
                      RUC,  --RUC caja                                                                                                                                    --5
                      i.aqpc366bncer, --numero certificado                                                                                                                         --6
                      i.aqpc366bnsol, --cod solicitud cofide                                                                                                                       --7
                      i.aqpc366bcodgar, --cod garantia                                                                                                                             --8
                      i.aqpc366bcodcob, --cod cobertura                                                                                                                            --9
                      i.aqpc366bcodsub, --cod subasta                                                                                                                              --10
                      i.aqpc366bidcof, --id cof                                                                                                                                    --11
                      i.aqpc366borifon , --orign fondos                                                                                                                             --12
                      PRESTAMO,-- --numero prestamo                         --13
                      i.aofval, --fecha desembolso                                                                                                                                 --14
                      v_finior, --fecha primera cuota                                                                                                                           --15
                      i.aofvto, --fecha fin credito, --fecha fin credito                                                                                                           --16
                      i.aqpc366bfinc,--fecha inicio cofide                                                                                                                         --17
                      i.aqpc366bffnc,-- fecha fin cofide                                                                                                                           --18
                      i.aqpc366btdest, --tipo destino                                                                                                                              --19
                      MONEDA, --moneda desc                                                                                         --20
                      v_saldo_actual, --saldo capital                                                                                                                            --21
                      v_saldo_inso, --saldo insoluto                                                                                                                             --22
                      v_monto_prepago, --monto prepago                                                                                                                          --23
                      v_deccaj,--fecha clasificacion caja                                                                                                                       --24
                      v_califa0, --clasificacion  normal                                                                                                                        --25
                      v_califa1, --clasificacion  cpp                                                                                                                           --26
                      v_califa2, --clasificacion  deficiente                                                                                                                    --27
                      v_califa3, --clasificacion  dudoso                                                                                                                        --28
                      v_califa4, --clasificacion  perdida                                                                                                                       --29
                      CONTABLE,--aqpb763scon, --situacion contable   --30
                      v_ncre,--aqpb763tpre, -- tipo de prestamo     --31                                                                                                            
                      v_diatr, --dias de atraso                     --32                                                                                                            
                      tp1desc, --region                              --33                                                                                                            
                      regnom, --zona                                 --34                                                                                                            
                      scnom, --agencia                               --35                                                                                                            
                      v_ase, --analista                             --36                                                                                                            
                      petdoc,--t2.petdoc, --tipo docuemnto           --37                                                                                                            
                      pendoc,--t2.pendoc, -- numero documneto        --38                                                                                                            
                      razon, --razon social     --39                                                                                                            
                      nomcli, --nombre del cliete --40
                      i.aqpc366btamemp , --tamaño empresa               --41                                                                                                                                         
                      i.aostat,                                        --42                                                                                                            
                      cenom,--estado del credito                    --43                                                                                                            
                      FEC_CAMBIO, --fecha de cuando se realizo cambio de estado --44
                      i.AQPC366BMONCOF,--2024.04.15 dcastro t1.aoimp,-- monto desembolsado               --45                                                                          
                      PERIODO_TOT,--periodo total del crdito  --46
                      PERIODO_GRACIA, --periodo de gracia del desembolos    --47                                       
                      NUMERO_CUO,--numero decuotas del crdito --48
                      i.aqpc366bprccof, --% de cobertura                                                                                   --49                                        
                      MONTO_COB, --monto de cobertura (saldo isnoluto*%de cobertura)                       --50                                        
                      HONRADO ,--credito honrado(s/n)                                      --51                                        
                      aqpb434fecr, --fecha de honramiento                                                                               --52                                        
                      aqpb434mto,--aqpb763mhon, --monto honrado                                                                         --53                                        
                      saldo_Capital_Act, --saldo capital                                                                                    --54                                        
                      v_saldo_honrado,-- SALDO HONRADO                                                                                  --55                                        -
                      SALDO_HONRADO, -- SALDO CREDITRO HONRADO = saldo actual +saldo honrado                       --56                                        
                      DIA_ATRASO, --dias de atraso                                                                                         --57                                                                                                                
                      v_ncuopp,--numero de cuota pendientes de pago                                                                     --58                                        
                      v_fvenuc,--aqpb763fvnui,--fecha de vencimiento de ultima cuota impaga                                             --59                                        
                      v_fvenu,--aqpb763fvnup,--fecha de vencimiento de ultima cuota pagada                                              --60                                        
                      v_fpagu,--v_ufpago,--aqpb763fpup, --fecha de pago de ultmo pago                                                   --61                                        
                      aqpb763cuop,--aqpb763cuop, --numero de cuotas pagadas   --2024.07.11                                                              --62                                        
                      v_tsum,--aqpb763mcuop,--monto de cuotas pagadas     --2024.07.19                                                              --63                                        
                      v_cuo,--pago realizado - capital                    --2024.07.19                                                               --64                                        
                      v_icv, --pago realizado - interes compensatorio     --2024.07.19                                                               --65                                        
                      v_mor, --pago realizado - interese moratorio        --2024.07.19                                                               --66                                        
                      v_int, --pago realizado - interes                   --2024.07.19                                                               --67                                        
                      v_pen, --pago realizado - penalidad                 --2024.07.19                                                               --68                                        
                      v_gas,--pago realizado -seguros                     --2024.07.19                                                               --69                                        
                      ld_fecha_rcc,--aqpb763fcsbs,--fecha clasificacion sbs                                                                 --70                                        
                      v_calif0, --califiacion sbs normal                                                                                --71                                        
                      v_calif1, --califiacion sbs cpp                                                                                   --72                                        
                      v_calif2, --califiacion sbs deficiente                                                                            --73                                        
                      v_calif3, --califiacion sbs dudoso                                                                                --74                                        
                      v_calif4 , --califiacion sbs perdida                                                                               --75                                        
                      TEA ,--aqpb763tea,  --tea                      --76                                        
                      v_tmor,--aqpb763team, --tasa moratoria                                                                            --77                                        
                      CIUU, -- ciuu    --78  
                      ACTIVIDAD_ECO, --actividad economica                                                       --79  
                      v_pcre18,--aqpb763tcre, --tipo de crdito sbs                                                                        --80                                        
                      FLAG_REPRO,--aqpb763repro,--flag reprogramacion                                                                                                 --81                                        
                      v_fech,--aqpb763frpro,--fecha reprogramacion                                                                                                            --82  
                      v_nrep,--aqpb763nrpro,--numero de reprogramaciones                                                                                                      --83  
                      v_fpri,--aqpb763fprcr,--fecha de primera cuota reprogramacion                                                                                           --84  
                      v_fult,--aqpb763ffnpr,--fecha fin de credito posterior a reprogramacion                                                                                 --85  
                      v_ncuo,--aqpb763ncuor,--numero de cuotas posterior a reprogramacion                                                                                     --86  
                      v_peri,--aqpb763grac, --periodo de gracia posterior a reprogramacion                                                                                    --87  
                      CIU4 , -- ciuu    --88  
                      ACTIVIDAD4, --actividad economica    --89                                                                     
                      i.pgcod, --pgcod                                                                                        --90                                                     
                      i.aomod, -- modulo                                                                                      --91                                                     
                      i.aosuc, --sucursal                                                                                     --92                                                     
                      i.aomda, --moneda                                                                                       --93                                                     
                      i.aopap, --papel                                                                                        --94                                                     
                      i.aosbop, --suboperacion                                                                                --95                                                     
                      i.aotope, --tipo operacion                                                                              --96                                                     
                      FECHA,                                                                          --97                                                     
                      HORA,                                                                          --98                                                     
                      v_intcom,--aqpb394intcom,                                                                            --99                                                      
                      v_intmor,--aqpb394intmor,                                                                            --100                                                     
                      v_intcov,--aqpb394intcov,                                                                            --101                                                     
                      v_penali,--aqpb394penali,                                                                            --102                                                     
                      i.aqpc366bcertrn,--aqpc360certrn ,                                                                      --103
                      i.aqpc366bcobren,--aqpc360cobren                                                                        --104
                      saldo_insoluto, --saldo insoluto antes de prpago                                                       --105
                      v_cuo, --aqpb394prpago,                                                                               --106
                      v_pagrea,--aqpb394pagrea,                                                                            --107
                      v_pramrt,--aqpb394pramrt,                                                                            --108
                      NRCCOR,--aqpb394nrccor,          --109
                      v_nrccac,--aqpb394nrccac,                                                                            --110                
                      v_vulcpa,--aqpb394vulcpa,                                                                            --111
                      v_vcprve,--aqpb394vcprve,                                                                            --112
                      v_fuclpr,--aqpb394fuclpr,                                                                            --113
                      v_ncuopa               ---20240711   
                      ,vaqpc366tiprep ,   
                                vaqpc366flgamor ,   
                                vaqpc366fecamor ,  
                                vaqpc366tcea ,    
                                vaqpc366tea2                                                                   --114                   
                    ); 
                        commit;
       exception when others then null;
         end;
   end loop; --LISTADO VIGENTES
   
   --LISTADO CANCELADOS
   for i in listadoCA loop     
   
      -----------------------------------------------------------------------------
                
   pq_cr_reporte_impulso.sp_columnas_extras_2025(
                                    p_fecha_proceso => pd_fecpro,
                                    p_xwfempresa => i.PGCOD,
                                    p_xwfsucursal => i.AOSUC,
                                    p_xwfmodulo => i.AOMOD,
                                    p_xwfmoneda => i.AOMDA,
                                    p_xwfpapel => i.AOPAP,
                                    p_xwfcuenta => i.AOCTA,
                                    p_xwfoperacion => i.AOOPER,
                                    p_xwfsubope => i.AOSBOP,
                                    p_xwftipope => i.AOTOPE,                                    
                                    po_aqpc366tiprep => vaqpc366tiprep,
                                    po_aqpc366flgamor => vaqpc366flgamor,
                                    po_aqpc366fecamor => vaqpc366fecamor,
                                    po_aqpc366tcea => vaqpc366tcea,
                                    po_aqpc366tea2 => vaqpc366tea2 );
                                                                  
     -----------------------------------------------------------------------------
   
   
        MONEDA := case when i.aomda = 0 then 'SOLES' else 'DOLARES' end ; --moneda desc          --20
        TEA    := case when nvl(i.aqpc366btea,0) = 0 then i.aotasa else i.aqpc366btea end;--aqpb763tea,  --tea                      --76 
                PRESTAMO := concat(lpad(to_char(i.aocta), 9, '0'),concat(lpad(to_char(i.aomda), 3, '0'),lpad(to_char(i.aooper), 9, '0'))) ;-- --numero prestamo          
        --fsr008
        begin
          select t2.pepais ,
            t2.petdoc,--t2.petdoc, --tipo docuemnto           --37                                                                                                            
            t2.pendoc--t2.pendoc, -- numero documneto        --38                                                                                                            
           into pepais, petdoc, pendoc         
          from fsr008 t2
          where t2.pgcod = i.pgcod  
            and t2.ctnro = i.aocta
            and t2.cttfir = 'T';
         exception when others then
            pepais := null;
            petdoc := null;
            pendoc := null;
         end;               


         --t4          
         begin
           select   t4.v_saldo_actual, --saldo capital  
                    t4.v_saldo_actual saldo_Capital_Act --saldo capital 
                into  v_saldo_actual,  saldo_Capital_Act
              from pq_cr_reporte_utilitarios.fn_get_saldo_actual(i.pgcod,i.aomod,i.aosuc,i.aomda,i.aopap,
                i.aocta,i.aooper,i.aosbop,i.aotope,pd_fecpro) t4 
           where  1=1;
         exception when others then
           v_saldo_actual := 0;
           saldo_Capital_Act := 0;
         end; 

         begin
           select t5.v_saldo_inso --saldo insoluto
            into v_saldo_inso
            from pq_cr_reporte_utilitarios.fn_get_saldo_insoluto_imp(i.pgcod,i.aomod,i.aosuc,i.aomda,i.aopap,i.aocta,
                  i.aooper,i.aosbop,i.aotope,pd_fecpro,5,i.aostat,i.aofe99) t5 ;
           exception when others then
               v_saldo_inso := 0;
           end;

         begin  
           select t6.scnom, t8.regnom , t9.tp1desc
            into scnom, regnom, tp1desc
            from fst001 t6, fst811 t7, fst810 t8 , fst198 t9
           where t6.pgcod = 1
            and t6.sucurs = i.aosuc
            and t7.pgcod = i.pgcod 
            and t7.oficod = t6.sucurs
            and t7.regcod < 100 and t7.regcod <> 0
            and t8.pgcod = t7.pgcod and t8.regcod = t7.regcod 
            and t9.tp1cod = 1 and t9.tp1cod1 = 10872 
            and t9.tp1corr1 = 11 and t9.tp1nro2 = t7.regcod;  
         exception when others then
             scnom := null;
             regnom := null;
         end;   
 

       
       begin
         select substr(concat(trim(t10.pfnom1),
                              concat(' ',
                                     concat(trim(t10.pfnom2),
                                            concat(' ',
                                                   concat(trim(t10.pfape1),
                                                          concat(' ', t10.pfape2)))))),
                       1,
                       60) --nombre del cliete --40
           into NOMCLI
           from fsd002 t10
          where t10.pfpais = pepais
            and t10.pftdoc = petdoc
            and t10.pfndoc = pendoc;
       exception
         when others then
           NOMCLI := null;
       end;
       
       begin
         select trim(substr(t11.pjrazs, 0, 60)) --razon social     --39   
           into RAZON
           from fsd003 t11
          where t11.pjpais = pepais
            and t11.pjtdoc = petdoc
            and t11.pjndoc = pendoc;
       exception
         when others then
           RAZON := null;
       end;


       begin
           select 
                 t12.v_fvenu,--aqpb763fvnup,--fecha de vencimiento de ultima cuota pagada                                              --60                                        
                 t12.v_fpagu--v_ufpago,--aqpb763fpup, --fecha de pago de ultmo pago                                                   --61                                        
            into v_fvenu, v_fpagu                
           from 
           pq_cr_reporte_utilitarios.fn_get_fechas_pago(i.pgcod,i.aomod,i.aosuc,i.aomda,i.aopap,i.aocta,
           i.aooper,i.aosbop,i.aotope,pd_fecpro) t12 ;
       exception when others then
         v_fvenu := null; 
         v_fpagu := null;
       end;

       begin
          select t13.v_ncuopp,--numero de cuota pendientes de pago                                                                     --58                                        
                 t13.v_ncuopa  aqpb763cuop--aqpb763cuop, --numero de cuotas pagadas   --2024.07.11                                                              --62                                        
           into  v_ncuopp, aqpb763cuop    
        from                  
         pq_cr_reporte_utilitarios.fn_get_cuota_pago_IMP(i.pgcod,i.aomod,i.aosuc,i.aomda,
         i.aopap,i.aocta,i.aooper,i.aosbop,i.aotope,v_fpagu ) t13; 
       exception when others then
         v_ncuopp := 0; 
         aqpb763cuop := 0;
       end;

       begin
          select t38.v_ncuopa               ---20240711  
           into  v_ncuopa
        from                  
         pq_cr_reporte_utilitarios.fn_get_cuota_pagoT(i.pgcod,i.aomod,i.aosuc,i.aomda,
         i.aopap,i.aocta,i.aooper,i.aosbop,i.aotope,v_fpagu ) t38; 
       exception when others then
         v_ncuopa := 0; 
       end;
       
       begin
          select t14.v_fvenuc--aqpb763fvnui,--fecha de vencimiento de ultima cuota impaga                                             --59  
           into  v_fvenuc
        from                  
         pq_cr_reporte_utilitarios.fn_get_fvcuo_impaga(i.pgcod,i.aomod,i.aosuc,i.aomda,
         i.aopap,i.aocta,i.aooper,i.aosbop,i.aotope,pd_fecpro) t14; 
       exception when others then
         v_fvenuc := null; 
       end;

       begin
         select t15.v_diatr, --dias de atraso                     --32                                                                                                            
                t15.v_diatr DIA_ATRASO --dias de atraso  
         into v_diatr, DIA_ATRASO
         from
          pq_cr_reporte_utilitarios.fn_get_dias_atraso_IMP(pd_fecpro,i.pgcod,i.aomod,i.aosuc,--15/10/2024
          i.aomda,i.aopap,i.aocta,i.aooper,i.aosbop,i.aotope,i.aofvto) t15;
         exception when others then
             v_diatr := 0;
             DIA_ATRASO := 0; 
                   
       end;              
       
       begin
         select 
                t16.v_calif0, --calificacion sbs normal                                                                                --71                                        
                t16.v_calif1, --calificacion sbs cpp                                                                                   --72                                        
                t16.v_calif2, --calificacion sbs deficiente                                                                            --73                                        
                t16.v_calif3, --calificacion sbs dudoso                                                                                --74                                        
                t16.v_calif4 --calificacion sbs perdida  
           into  
           v_calif0, v_calif1, v_calif2,v_calif3,v_calif4 
         from
         pq_cr_reporte_utilitarios.fn_get_calif_sbs_IMP(petdoc,pendoc,pd_fecpro) t16;       
       exception when others then
                    v_calif0 := 0;
                    v_calif1 := 0; 
                    v_calif2 := 0;
  
                    v_calif3 := 0;
                    v_calif4 := 0;
       end;


       --17
       begin
         select
              case when t17.v_ciuu4 <> 0 then t17.v_ciuu4 else (case when t17.v_ciuu6 <> 0 then to_number(substr(to_char(t17.v_ciuu6), 1, 4)) else 0 end) end, -- ciuu    --78  
              case when t17.v_ciuu4 <> 0 then  substr(trim(t23.actnom1), 1, 60) else  '' end  --actividad economica                                                       --79  
            into  CIUU, ACTIVIDAD_ECO             
         from   pq_cr_reporte_utilitarios.fn_get_acti_eco(pepais,petdoc,pendoc) t17, fst750 t23
         where t23.actcod1 = t17.v_ciuu6;         
       exception when others then
                CIUU := null; 
                ACTIVIDAD_ECO := null;
       end;            
       
     --------                      case when t17.v_ciuu4 <> 0 then t17.v_ciuu4 else (case when t17.v_ciuu6 <> 0 then to_number(substr(to_char(t17.v_ciuu6), 1, 4)) else 0 end) end CIU4, -- ciuu    --88  
     -------------               case when t17.v_ciuu4 <> 0 then  substr(trim(t23.actnom1), 1, 60) else  '' end ACTIVIDAD4, --actividad economica    --89                                                                     
       CIU4 :=  CIUU; 
       ACTIVIDAD4 := ACTIVIDAD_ECO ;
       
       --18
       begin
           select
                  t18.v_ncre,--aqpb763tpre, -- tipo de prestamo     --31    
                  t18.v_pcre--aqpb763tcre, --tipo de crdito sbs                                                                        --80                                                                                                                                                
           into   v_ncre, v_pcre18                       
           from   pq_cr_reporte_utilitarios.fn_get_tipo_credito_sbs_vig(i.pgcod,i.aomod,i.aosuc,
           i.aomda,i.aopap,i.aocta,i.aooper,i.aosbop,i.aotope,pd_fecpro) t18;        
       exception when others then
         v_ncre := null;
         v_pcre18 := null;
       end;
       --19
       begin
         select 
                    t19.v_tsum,--aqpb763mcuop,--monto de cuotas pagadas     --2024.07.19                                                              --63                                        
                    t19.v_cuo,--pago realizado - capital                    --2024.07.19                                                               --64                                        
                    t19.v_icv, --pago realizado - interes compensatorio     --2024.07.19                                                               --65                                        
                    t19.v_mor, --pago realizado - interese moratorio        --2024.07.19                                                               --66                                        
                    t19.v_int, --pago realizado - interes                   --2024.07.19                                                               --67                                        
                    t19.v_pen, --pago realizado - penalidad                 --2024.07.19                                                               --68                                        
                    t19.v_gas--,--pago realizado -seguros                     --2024.07.19                                                               --69                                        
                    --t19.v_cuo --aqpb394prpago,
           into
           v_tsum,v_cuo,v_icv,v_mor,v_int,v_pen,v_gas--,aqpb394prpag          
         from pq_cr_reporte_utilitarios.fn_get_distribuc_pago_IMP(i.pgcod,i.aomod,i.aosuc,
         i.aomda,i.aopap,i.aocta,i.aooper,i.aosbop,i.aotope,pd_fecpro) t19; --20240719 se agrego para impulsa
       exception when others then
          v_tsum := 0;
          v_cuo  := 0;
          v_icv  := 0;
          v_mor  := 0;
          v_int  := 0;
          v_pen  := 0;
          v_gas  := 0;
          --aqpb394prpag := 0;
       end;

       --20
       begin
         select t20.v_monto_prepago --monto prepago 
         into v_monto_prepago
         from pq_cr_reporte_utilitarios.fn_get_mprepago_IMP(i.pgcod,i.aomod,i.aomda,i.aopap,i.aocta,i.aooper,i.aotope,pd_fecpro) t20 ;
       exception when others then
          v_monto_prepago := 0;       
       end;

       --21       
       begin
          select  
                t21.v_deccaj,--fecha clasificacion caja                                                                                                                       --24
                t21.v_califa0, --clasificacion  normal                                                                                                                        --25
                t21.v_califa1, --clasificacion  cpp                                                                                                                           --26
                t21.v_califa2, --clasificacion  deficiente                                                                                                                    --27
                t21.v_califa3, --clasificacion  dudoso                                                                                                                        --28
                t21.v_califa4 --clasificacion  perdida    
          into  v_deccaj,v_califa0,v_califa1,v_califa2,v_califa3,v_califa4
             from pq_cr_reporte_utilitarios.fn_get_calf_caja(i.aocta,pd_fecpro) t21;                      
       exception when others then
            v_deccaj := null;
            v_califa0 := 0;
            v_califa1 := 0;
            v_califa2 := 0;
            v_califa3 := 0;
            v_califa4 := 0;
       end;
       --22
       begin
       select   
          case when t22.aqpb434fecr is null then 'N' else 'S' end , --credito honrado(s/n)                                      --51                                        
                    t22.aqpb434fecr, --fecha de honramiento                                                                               --52                                        
                    t22.aqpb434mto--aqpb763mhon, --monto honrado                                                                         --53                                        
       into HONRADO,  aqpb434fecr, aqpb434mto
       from aqpb434 t22 where t22.aqpb434cod = i.pgcod and t22.aqpb434cta = i.aocta and t22.aqpb434ope = i.aooper and t22.aqpb434est = 'C' ;
       exception when others then
         HONRADO := 'N';  
         aqpb434fecr := null;
         aqpb434mto  := null;
       end;
       
       --24
       begin
       select t24.v_saldo_honrado-- SALDO HONRADO                                                                                  --55                                        -
        into v_saldo_honrado
        from pq_cr_reporte_utilitarios.fn_get_saldo_honrado(i.pgcod,i.aomod,i.aosuc,i.aomda,i.aopap,i.aocta,i.aooper,i.aosbop,i.aotope,9300082070000,pd_fecpro) t24;
       exception when others then
          v_saldo_honrado := 0;
        end;       
        SALDO_HONRADO := v_saldo_actual + v_saldo_honrado; -- SALDO CREDITRO HONRADO = saldo actual +saldo honrado                       --56                                        
 
        --25   
        begin    
        select
                    substr(t25.v_flag,1,1) FLAG_REPRO,--aqpb763repro,--flag reprogramacion                                                                                                 --81                                        
                    t25.v_fech,--aqpb763frpro,--fecha reprogramacion                                                                                                            --82  
                    t25.v_nrep,--aqpb763nrpro,--numero de reprogramaciones                                                                                                      --83  
                    t25.v_fpri,--aqpb763fprcr,--fecha de primera cuota reprogramacion                                                                                           --84  
                    t25.v_fult,--aqpb763ffnpr,--fecha fin de credito posterior a reprogramacion                                                                                 --85  
                    t25.v_ncuo,--aqpb763ncuor,--numero de cuotas posterior a reprogramacion                                                                                     --86  
                    t25.v_peri--aqpb763grac, --periodo de gracia posterior a reprogramacion                                                                                    --87  
        into FLAG_REPRO, v_fech, v_nrep, v_fpri, v_fult, v_ncuo, v_peri                  
        from pq_cr_reporte_utilitarios.fn_get_repro_dato1(i.pgcod,i.aomod,i.aosuc,i.aomda,i.aopap,i.aocta,i.aooper,i.aosbop,i.aotope,pd_fecpro) t25;
        
        exception when others then
          FLAG_REPRO := null;
          v_fech    := null; 
          v_nrep    := null;
          v_fpri    := null;
          v_fult    := null;
          v_ncuo    := null;
          v_peri    := null;                   
        end;                           
        
        --t27
        begin 
          select t27.v_ase --analista                             --36    
        into v_ase  
        from pq_cr_reporte_utilitarios.fn_get_analista_credito(i.aomod,i.aosuc,i.aomda,i.aopap,i.aocta,i.aooper,i.aosbop,i.aotope) t27;
        exception when others then
          v_ase := null;
        end;
   
        --t28
        begin 
          select t28.cenom--estado del credito                    --43  
            into cenom         
           from fst026 t28 
           where t28.cecod = i.aostat;
        exception when others then
            cenom := null;      
        end;          
        
        --t30
        begin
          select t30.v_fcest,        
                 t30.v_tmor--aqpb763team, --tasa moratoria                                                                            --77                                                           
            into v_fcest, v_tmor
           from pq_cr_reporte_utilitarios.fn_get_fcamb_estado(i.pgcod,i.aomod,i.aosuc,i.aomda,i.aopap,i.aocta,i.aooper,i.aosbop,i.aotope,pd_fecpro) t30;
        exception when others then
          v_fcest := to_date('01/01/0001','DD/MM/YYYY');
          v_tmor := 0;
        end;
        FEC_CAMBIO :=
           case when v_fcest > nvl(i.aofe99,to_date('01/01/0001','DD/MM/YYYY')) then                                                                                
               (case when v_fcest > nvl(v_fech,to_date('01/01/0001','DD/MM/YYYY')) then v_fcest else v_fech end )                                       
               else (case when nvl(v_fech,to_date('01/01/0001','DD/MM/YYYY')) > nvl(i.aofe99,to_date('01/01/0001','DD/MM/YYYY')) then v_fech else i.aofe99 end)end ; --fecha de cuando se realizo cambio de estado --44

       --t31
       begin
           select t31.v_pgra
            into v_pgra   
           from pq_cr_reporte_utilitarios.fn_get_pergracia_imp(i.pgcod,i.aomod,i.aosuc,i.aomda,i.aopap,i.aocta,i.aooper,i.aosbop,i.aotope,pd_fecpro) t31;        
       exception when others then
          v_pgra := 0;
       end;

      PERIODO_TOT := case when i.aqpc366bperio is null then (case when i.aoperiod = 0 then 0 else  round(floor(i.aopzo/i.aoperiod),2) end + v_pgra/30) else i.aqpc366bperio end; --periodo total del crdito  --46
      PERIODO_GRACIA := case when i.aqpc366bpgra is null then (v_pgra/30) else i.aqpc366bpgra end;  --periodo de gracia del desembolos    --47                                       
      NUMERO_CUO := case when i.aqpc366bncuo is null then (case when i.aoperiod = 0 then 0 else  round(floor(i.aopzo/i.aoperiod),2) end) else i.aqpc366bncuo  end ;--numero decuotas del crdito --48

      --t32
      begin
          select t32.v_monto_prepago--prepago total 
          into v_monto_prepagoT             
       from pq_cr_reporte_utilitarios.fn_get_mprepago_acum_imp(i.pgcod,i.aomod,i.aomda,i.aopap,i.aocta,i.aooper,i.aotope,pd_fecpro) t32;
      exception when others then
        v_monto_prepagoT := 0;
      end;

      --t33
      begin
        select t33.v_saldo_inso 
        into SALDO_INSOLUTO --saldo insoluto antes de prpago                           --105
        from pq_cr_reporte_utilitarios.fn_get_saldo_insoluto_imp(i.pgcod,i.aomod,i.aosuc,i.aomda,i.aopap,i.aocta,i.aooper,i.aosbop,i.aotope,lc_fmant,5,i.aostat,i.aofe99) t33;
      exception when others then
         SALDO_INSOLUTO := 0;
      end;  
      
      --t35
      begin
       select t35.v_intcom,--aqpb394intcom,                                                                            --99                                                      
              t35.v_intmor,--aqpb394intmor,                                                                            --100                                                     
              t35.v_intcov,--aqpb394intcov,                                                                            --101                                                     
              t35.v_penali,--aqpb394penali,                                                                            --102                                                     
              t35.v_pagrea,--aqpb394pagrea,                                                                            --107
              t35.v_pramrt,--aqpb394pramrt,                                                                            --108
              t35.v_nrccac,--aqpb394nrccac,                                                                            --110                
              t35.v_vulcpa,--aqpb394vulcpa,                                                                            --111
              t35.v_vcprve,--aqpb394vcprve,                                                                            --112
              t35.v_fuclpr,--aqpb394fuclpr,  
              t35.v_nrccor
        into   
        v_intcom, v_intmor, v_intcov, v_penali, v_pagrea, v_pramrt,
        v_nrccac, v_vulcpa, v_vcprve, v_fuclpr, v_nrccor
       from pq_cr_reporte_utilitarios.fn_get_otros_repfondos_imp(i.pgcod,i.aomod,i.aosuc,i.aomda,i.aopap,i.aocta,i.aooper,i.aosbop,i.aotope,pd_fecpro,3) t35; --20240815 modificado
      exception when others then
        v_intcom := 0;
        v_intmor := 0;
        v_intcov := 0;
        v_penali := 0; 
        v_pagrea := 0;
        v_pramrt := 0;
        v_nrccac := 0; 
        v_vulcpa := 0;
        v_vcprve := 0; 
        v_fuclpr := null;
        v_nrccor := 0;
      end;  
      
      NRCCOR := case when i.aqpc366bperio is null then v_nrccor else i.aqpc366bperio end;--aqpb394nrccor,          --109

      --t36            
      begin
      select t36.v_finior --fecha primera cuota                                                                                                                           --15
        into v_finior            
       from pq_cr_reporte_utilitarios.fn_get_fec_creorigen2(i.pgcod,i.aomod,i.aosuc,i.aomda,i.aopap,i.aocta,i.aooper,i.aosbop,i.aotope) t36;                
      exception when others then
        v_finior := null;
      end;                    
      
      --t37
      begin
        select t37.v_pcre
        into v_pcre
        from pq_cr_reporte_utilitarios.fn_get_rubro(i.pgcod,i.aomod,i.aosuc,i.aomda,i.aopap,i.aocta,i.aooper,i.aosbop,i.aotope,pd_fecpro) t37;
      exception when others then
        v_pcre := 0;
      end;
      
      MONTO_COB := round(v_saldo_inso * i.aqpc366bprccof,2); --monto de cobertura (saldo isnoluto*%de cobertura)                       --50   
      --round(t5.v_saldo_inso*t3.aqpc366bprccof,2) MONTO_COB, --monto de cobertura (saldo isnoluto*%de cobertura)                       --50                                        

      
      CONTABLE :=  case when i.aostat = 99 and i.aofe99 <= pd_fecpro and i.aofe99 != '01/01/0001' then 'CNC' when i.aostat = 61 then 'RFN' when substr(v_pcre, 1, 4) = '1411' then 'VGT' 
                         when substr(v_pcre, 1, 4) = '1421' then 'VGT' when substr(v_pcre, 1, 4) = '1414' then 'RFN'                                                      
                         when substr(v_pcre, 1, 4) = '1424' then 'RFN' when substr(v_pcre, 1, 4) = '1415' then 'VCD'                                                      
                         when substr(v_pcre, 1, 4) = '1425' then 'VCD' when substr(v_pcre, 1, 4) = '1416' then 'JDC'                                                      
                         when substr(v_pcre, 1, 4) = '1426' then 'JDC' when substr(v_pcre, 1, 2) = '81' then 'CTG'                                                        
                         when substr(v_pcre, 1, 4) = '1413' then 'RTR' when substr(v_pcre, 1, 4) = '1423' then 'RTR'  else  '' end;--aqpb763scon, --situacion contable   --30

         FECHA :=   to_char(sysdate, 'DD/MM/YYYY');--97                                                     
         HORA  :=   to_char(sysdate, 'HH24:MI:SS'); --98
         
         BEGIN
          insert into aqpc366(  aqpc366usur   ,   --1
                                aqpc366fproc  ,   --2
                                aqpc366ncta   ,   --3
                                aqpc366nope   ,   --4
                                aqpc366rucc   ,   --5
                                aqpc366ncer   ,   --6
                                aqpc366nsol   ,   --7
                                aqpc366codgar ,   --8
                                aqpc366codcob ,   --9
                                aqpc366codsub ,   --10
                                aqpc366idcof  ,   --11
                                aqpc366orifon ,   --12
                                aqpc366npre   ,   --13
                                aqpc366fdes   ,   --14
                                aqpc366fprcu  ,   --15
                                aqpc366ffinc  ,   --16
                                aqpc366finc   ,   --17
                                aqpc366ffnc   ,   --18
                                aqpc366tdest  ,   --19
                                aqpc366mone  ,    --20
                                aqpc366scap   ,   --21
                                aqpc366sins   ,   --22
                                aqpc366mpre   ,   --23
                                aqpc366fclas  ,   --24
                                aqpc366cnor   ,   --25
                                aqpc366ccpp   ,   --26
                                aqpc366cdef   ,   --27
                                aqpc366cdud   ,   --28
                                aqpc366cper   ,   --29
                                aqpc366scon   ,   --30
                                aqpc366tpre   ,   --31
                                aqpc366atru   ,   --32
                                aqpc366rgon   ,   --33
                                aqpc366zona   ,   --34
                                aqpc366agen   ,   --35
                                aqpc366anal   ,   --36
                                aqpc366tdoc   ,   --37
                                aqpc366ndoc   ,   --38
                                aqpc366rsoc   ,   --39
                                aqpc366nomc   ,   --40
                                aqpc366temp   ,   --41
                                aqpc366est  ,     --42
                                aqpc366estd   ,   --43
                                aqpc366fest   ,   --44
                                aqpc366cdes   ,   --45
                                aqpc366perio  ,   --46
                                aqpc366pgra   ,   --47
                                aqpc366ncuod  ,   --48
                                aqpc366cobr   ,   --49
                                aqpc366mcob   ,   --50
                                aqpc366chon   ,   --51
                                aqpc366fhon   ,   --52
                                aqpc366mhon   ,   --53
                                aqpc366sdocap ,   --54
                                aqpc366sdohon ,   --55
                                aqpc366crehon ,   --56
                                aqpc366datr   ,   --57
                                aqpc366cpen   ,   --58
                                aqpc366fvnui  ,   --59
                                aqpc366fvnup  ,   --60
                                aqpc366fpup   ,   --61
                                aqpc366cuop   ,   --62 ---
                                aqpc366mcuop  ,   --63
                                aqpc366prcap  ,   --64
                                aqpc366pinc   ,   --65
                                aqpc366pinm   ,   --66
                                aqpc366prin   ,   --67
                                aqpc366prpn   ,   --68
                                aqpc366prseg  ,   --69 
                                aqpc366fcsbs  ,   --70
                                aqpc366snor   ,   --71
                                aqpc366scpp   ,   --72
                                aqpc366sdef   ,   --73
                                aqpc366sdud   ,   --74
                                aqpc366sper   ,   --75
                                aqpc366tea    ,   --76
                                aqpc366team   ,   --77
                                aqpc366ciuu   ,   --78
                                aqpc366aeco   ,   --79
                                aqpc366tcre   ,   --80
                                aqpc366repro  ,   --81
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         aqpc366frpro  ,   --82
                                aqpc366nrpro  ,   --83
                                aqpc366fprcr  ,   --84
                                aqpc366ffnpr  ,   --85
                                aqpc366ncuor  ,   --86
                                aqpc366grac   ,   --87
                                aqpc366ciuo   ,   --88
                                aqpc366aecoo  ,   --89
                                aqpc366emp    ,   --90
                                aqpc366mod    ,   --91
                                aqpc366suc    ,   --92
                                aqpc366mnda   ,   --93
                                aqpc366papl   ,   --94
                                aqpc366sbop   ,   --95
                                aqpc366tope   ,   --96
                                aqpc366fcr    ,   --97
                                aqpc366hcr    ,   --98
                                aqpc366intcom ,   --99
                                aqpc366intmor ,   --100
                                aqpc366intcov ,   --101
                                aqpc366pen    ,   --102
                                aqpc366certrn ,   --103
                                aqpc366cobren ,   --104
                                aqpc366sinsap ,   --105
                                aqpc366prpago ,   --106
                                aqpc366pagrea ,   --107
                                aqpc366pramrt ,   --108
                                aqpc366nrccor ,   --109
                                aqpc366nrccac ,   --110
                                aqpc366vulcpa ,   --111
                                aqpc366vcprve ,   --112
                                aqpc366fuclpr ,   --113
                                aqpc366cuopc      --114
                                   ,aqpc366tiprep ,   
                                aqpc366flgamor ,   
                                aqpc366fecamor ,  
                                aqpc366tcea ,    
                                aqpc366tea2  
                             )
                    values( 
                      rpad(trim(pn_usuario), 10, ' '), --usuario 
                      pd_fecpro, --fecha proceso                                                                                                                                    --2
                      i.aocta, --cuenta                                                                                                                                            --3
                      i.aooper, --operacion                                                                                                                                        --4
                      RUC,  --RUC caja                                                                                                                                    --5
                      i.aqpc366bncer, --numero certificado                                                                                                                         --6
                      i.aqpc366bnsol, --cod solicitud cofide                                                                                                                       --7
                      i.aqpc366bcodgar, --cod garantia                                                                                                                             --8
                      i.aqpc366bcodcob, --cod cobertura                                                                                                                            --9
                      i.aqpc366bcodsub, --cod subasta                                                                                                                              --10
                      i.aqpc366bidcof, --id cof                                                                                                                                    --11
                      i.aqpc366borifon , --orign fondos                                                                                                                             --12
                      PRESTAMO,-- --numero prestamo                         --13
                      i.aofval, --fecha desembolso                                                                                                                                 --14
                      v_finior, --fecha primera cuota                                                                                                                           --15
                      i.aofvto, --fecha fin credito, --fecha fin credito                                                                                                           --16
                      i.aqpc366bfinc,--fecha inicio cofide                                                                                                                         --17
                      i.aqpc366bffnc,-- fecha fin cofide                                                                                                                           --18
                      i.aqpc366btdest, --tipo destino                                                                                                                              --19
                      MONEDA, --moneda desc                                                                                         --20
                      v_saldo_actual, --saldo capital                                                                                                                            --21
                      v_saldo_inso, --saldo insoluto                                                                                                                             --22
                      v_monto_prepago, --monto prepago                                                                                                                          --23
                      v_deccaj,--fecha clasificacion caja                                                                                                                       --24
                      v_califa0, --clasificacion  normal                                                                                                                        --25
                      v_califa1, --clasificacion  cpp                                                                                                                           --26
                      v_califa2, --clasificacion  deficiente                                                                                                                    --27
                      v_califa3, --clasificacion  dudoso                                                                                                                        --28
                      v_califa4, --clasificacion  perdida                                                                                                                       --29
                      CONTABLE,--aqpb763scon, --situacion contable   --30
                      v_ncre,--aqpb763tpre, -- tipo de prestamo     --31                                                                                                            
                      v_diatr, --dias de atraso                     --32                                                                                                            
                      tp1desc, --region                              --33                                                                                                            
                      regnom, --zona                                 --34                                                                                                            
                      scnom, --agencia                               --35                                                                                                            
                      v_ase, --analista                             --36                                                                                                            
                      petdoc,--t2.petdoc, --tipo docuemnto           --37                                                                                                            
                      pendoc,--t2.pendoc, -- numero documneto        --38                                                                                                            
                      razon, --razon social     --39                                                                                                            
                      nomcli, --nombre del cliete --40
                      i.aqpc366btamemp , --tamaño empresa               --41                                                                                                                                         
                      i.aostat,                                        --42                                                                                                            
                      cenom,--estado del credito                    --43                                                                                                            
                      FEC_CAMBIO, --fecha de cuando se realizo cambio de estado --44
                      i.AQPC366BMONCOF,--2024.04.15 dcastro t1.aoimp,-- monto desembolsado               --45                                                                          
                      PERIODO_TOT,--periodo total del crdito  --46
                      PERIODO_GRACIA, --periodo de gracia del desembolos    --47                                       
                      NUMERO_CUO,--numero decuotas del crdito --48
                      i.aqpc366bprccof, --% de cobertura                                                                                   --49                                        
                      MONTO_COB, --monto de cobertura (saldo isnoluto*%de cobertura)                       --50                                        
                      HONRADO ,--credito honrado(s/n)                                      --51                                        
                      aqpb434fecr, --fecha de honramiento                                                                               --52                                        
                      aqpb434mto,--aqpb763mhon, --monto honrado                                                                         --53                                        
                      saldo_Capital_Act, --saldo capital                                                                                    --54                                        
                      v_saldo_honrado,-- SALDO HONRADO                                                                                  --55                                        -
                      SALDO_HONRADO, -- SALDO CREDITRO HONRADO = saldo actual +saldo honrado                       --56                                        
                      DIA_ATRASO, --dias de atraso                                                                                         --57                                                                                                                
                      v_ncuopp,--numero de cuota pendientes de pago                                                                     --58                                        
                      v_fvenuc,--aqpb763fvnui,--fecha de vencimiento de ultima cuota impaga                                             --59                                        
                      v_fvenu,--aqpb763fvnup,--fecha de vencimiento de ultima cuota pagada                                              --60                                        
                      v_fpagu,--v_ufpago,--aqpb763fpup, --fecha de pago de ultmo pago                                                   --61                                        
                      aqpb763cuop,--aqpb763cuop, --numero de cuotas pagadas   --2024.07.11                                                              --62                                        
                      v_tsum,--aqpb763mcuop,--monto de cuotas pagadas     --2024.07.19                                                              --63                                        
                      v_cuo,--pago realizado - capital                    --2024.07.19                                                               --64                                        
                      v_icv, --pago realizado - interes compensatorio     --2024.07.19                                                               --65                                        
                      v_mor, --pago realizado - interese moratorio        --2024.07.19                                                               --66                                        
                      v_int, --pago realizado - interes                   --2024.07.19                                                               --67                                        
                      v_pen, --pago realizado - penalidad                 --2024.07.19                                                               --68                                        
                      v_gas,--pago realizado -seguros                     --2024.07.19                                                               --69                                        
                      ld_fecha_rcc,--aqpb763fcsbs,--fecha clasificacion sbs                                                                 --70                                        
                      v_calif0, --califiacion sbs normal                                                                                --71                                        
                      v_calif1, --califiacion sbs cpp                                                                                   --72                                        
                      v_calif2, --califiacion sbs deficiente                                                                            --73                                        
                      v_calif3, --califiacion sbs dudoso                                                                                --74                                        
                      v_calif4 , --califiacion sbs perdida                                                                               --75                                        
                      TEA ,--aqpb763tea,  --tea                      --76                                        
                      v_tmor,--aqpb763team, --tasa moratoria                                                                            --77                                        
                      CIUU, -- ciuu    --78  
                      ACTIVIDAD_ECO, --actividad economica                                                       --79  
                      v_pcre18,--aqpb763tcre, --tipo de crdito sbs                                                                        --80                                        
                      FLAG_REPRO,--aqpb763repro,--flag reprogramacion                                                                                                 --81                                        
                      v_fech,--aqpb763frpro,--fecha reprogramacion                                                                                                            --82  
                      v_nrep,--aqpb763nrpro,--numero de reprogramaciones                                                                                                      --83  
                      v_fpri,--aqpb763fprcr,--fecha de primera cuota reprogramacion                                                                                           --84  
                      v_fult,--aqpb763ffnpr,--fecha fin de credito posterior a reprogramacion                                                                                 --85  
                      v_ncuo,--aqpb763ncuor,--numero de cuotas posterior a reprogramacion                                                                                     --86  
                      v_peri,--aqpb763grac, --periodo de gracia posterior a reprogramacion                                                                                    --87  
                      CIU4 , -- ciuu    --88  
                      ACTIVIDAD4, --actividad economica    --89                                                                     
                      i.pgcod, --pgcod                                                                                        --90                                                     
                      i.aomod, -- modulo                                                                                      --91                                                     
                      i.aosuc, --sucursal                                                                                     --92                                                     
                      i.aomda, --moneda                                                                                       --93                                                     
                      i.aopap, --papel                                                                                        --94                                                     
                      i.aosbop, --suboperacion                                                                                --95                                                     
                      i.aotope, --tipo operacion                                                                              --96                                                     
                      FECHA,                                                                          --97                                                     
                      HORA,                                                                          --98                                                     
                      v_intcom,--aqpb394intcom,                                                                            --99                                                      
                      v_intmor,--aqpb394intmor,                                                                            --100                                                     
                      v_intcov,--aqpb394intcov,                                                                            --101                                                     
                      v_penali,--aqpb394penali,                                                                            --102                                                     
                      i.aqpc366bcertrn,--aqpc360certrn ,                                                                      --103
                      i.aqpc366bcobren,--aqpc360cobren                                                                        --104
                      saldo_insoluto, --saldo insoluto antes de prpago                                                       --105
                      v_cuo, --aqpb394prpago,                                                                               --106
                      v_pagrea,--aqpb394pagrea,                                                                            --107
                      v_pramrt,--aqpb394pramrt,                                                                            --108
                      NRCCOR,--aqpb394nrccor,          --109
                      v_nrccac,--aqpb394nrccac,                                                                            --110                
                      v_vulcpa,--aqpb394vulcpa,                                                                            --111
                      v_vcprve,--aqpb394vcprve,                                                                            --112
                      v_fuclpr,--aqpb394fuclpr,                                                                            --113
                      v_ncuopa               ---20240711                                                                   --114                   
                       ,vaqpc366tiprep ,   
                                vaqpc366flgamor ,   
                                vaqpc366fecamor ,  
                                vaqpc366tcea ,    
                                vaqpc366tea2  
                    ); 
                        commit;
       exception when others then null;
         end;
   end loop; --LISTADO CANCELADOS

    
     
  end sp_cr_impulsoBT;
------------------------------------------------------------------
procedure sp_cr_sch_impulsoBT(pd_fecpro  in date,
                               pn_usuario in varchar2                               
                               ) is
   -- *****************************************************************
  -- Nombre                       : sp_cr_sch_impulsoBT
  -- Sistema                      : BANTOTAL
  -- Módulo                       : Créditos
  -- Versión                      : 1.0
  -- Fecha de Creación            : 02/09/2024
  -- Autor de Creación            : dcastro
  -- Estado                       : Activo
  -- Acceso                       : Público
  -- Descripción                  : Procedimiento optimizado para generar reporte impulsa
  -- Fecha de Modificación        : 
  -- Autor de Modificación        : 
  -- Descripción de Modificación  : 
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --                 
 
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

    str varchar2(100);

  
    cursor sucursal is
      select *
        from fst001
       where pgcod = 1
         and sucurs < 800
      ;
  
  begin
  
  ---carga tablas
 -- begin
 --   pq_cr_reporte_impulso.sp_cr_carga_tablas;
 -- end;
 
    ---CARGA TABLA FSD602, FSD611
    begin
            pq_cr_reporte_impulso.sp_cr_carga_tablas;
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
    lc_prefijo    := 'FIMP' || lc_user;
    lc_paquete    := 'pq_cr_reporte_impulso';
    lc_proceso    := 'sp_cr_impulsoBT';
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
                       '  pq_cr_reporte_impulso.sp_cr_impulsoBT( TO_DATE(''' ||
                       lc_fecpro || ''',''RRRR.MM.DD''),' || ln_ini ||
                       ',''' || pn_usuario || ''' );' || ' End;';
    
      IF SYS.FN_BD_ISRAC = 'TRUE' THEN
        
      
        dbms_job.submit(job_id,
                        what      => lc_variable,
                        next_date => sysdate,
                        interval  => null,
                        no_parse  => false,
                       -- instance  => 2,
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
    pq_cr_reporte_impulso.sp_guardar_historico(pn_usuario, pd_fecpro);
  
      
  
  end sp_cr_sch_impulsoBT;

--------------------------------------------------------------------
procedure sp_cr_carga_tablas  is
  
--                                02/09/2024 dcastro se agregó procedimiento sp_cr_carga_tablas para optimizar proceso sp_cr_impulsoBT
--                                15/10/2024 dcastro se modificó procedimiento para excluir duplicados aqpc366b

    str varchar2(100);
    lc_nomusr     varchar2(50);
        
begin
  
      ---2024.08.23 se agrego truncate table  
      BEGIN
       str := 'TRUNCATE TABLE AQPC366';
       execute immediate(str);
      exception when others then null; 
      END; 
      
      BEGIN
       str := 'TRUNCATE TABLE AQPC366D';--fsd602
       execute immediate(str);
      exception when others then null; 
      END;      

      BEGIN
       str := 'TRUNCATE TABLE AQPC366E';---fsd611
       execute immediate(str);
      exception when others then null; 
      END; 

      ---realizando insert de FSD602 a tabla AQPC366D registros de creditos impulsa
      BEGIN
          insert into AQPC366D
/*            select \*+all_rows*\ f.* 
            from fsd602 f , aqpc366b t3 
            where f.pgcod = t3.aqpc366bcod
            and f.ppsuc in (select sucurs from fst001 where sucurs<800)
            and f.ppmod in (select modulo from fst111 where dscod=50)
            and f.pppap = 0
            and f.ppcta = t3.aqpc366bcta
            and f.ppoper = t3.aqpc366bope
            and t3.aqpc366best <> 'D'; */   
            select /*+all_rows*/ f.* 
            from fsd602 f , (select distinct t3.aqpc366bcod, t3.aqpc366bcta, t3.aqpc366bope from aqpc366b t3 where t3.aqpc366best <> 'D') t
            where f.pgcod = t.aqpc366bcod
            and f.ppsuc in (select sucurs from fst001 where sucurs<800)
            and f.ppmod in (select modulo from fst111 where dscod=50)
            and f.pppap = 0
            and f.ppcta = t.aqpc366bcta
            and f.ppoper = t.aqpc366bope;  
            commit;    
       exception when others then null;      
      END;
 
      begin
        select TRIM(TP1DESC)
          INTO lc_nomusr
          from fst198
         where tp1cod = 1
           and tp1cod1 = 10847
           and tp1corr1 = 999; ---2019.07.22 guia de proceso para hostname
    exception when others then null;
      end;

     
      --aplicando estadisticas tabla AQPC366D 
       begin
                  DBMS_STATS.gather_table_stats(ownname          => lc_nomusr, --'BANTPROD',  
                                                tabname          => 'AQPC366D',
                                                degree           => 1,
                                                granularity      => 'ALL',
                                                estimate_percent => dbms_stats.auto_sample_size,
                                                cascade          => TRUE);
        end;      
  
      ---realizando insert de FSD602 a tabla AQPC366E registros de creditos impulsa
      BEGIN
          insert into AQPC366E
/*            select \*+all_rows*\ f.* 
            from fsd611 f , aqpc366b t3 
            where f.pgcod = t3.aqpc366bcod
            and f.ppsuc in (select sucurs from fst001 where sucurs<800)
            and f.ppmod in (select modulo from fst111 where dscod=50)
            and f.pppap = 0
            and f.ppcta = t3.aqpc366bcta
            and f.ppoper = t3.aqpc366bope
            and t3.aqpc366best <> 'D'; */ 
            
            select /*+all_rows*/f.* 
            from fsd611 f , (select distinct t3.aqpc366bcod, t3.aqpc366bcta, t3.aqpc366bope from aqpc366b t3 where t3.aqpc366best <> 'D') t
            where f.pgcod = t.aqpc366bcod
            and f.ppsuc in (select sucurs from fst001 where sucurs<800)
            and f.ppmod in (select modulo from fst111 where dscod=50)
            and f.pppap = 0
            and f.ppcta = t.aqpc366bcta
            and f.ppoper = t.aqpc366bope;  
              
            commit;    
       exception when others then null;      
      END;
      
      --aplicando estadisticas tabla AQPC366D 
       begin
                  DBMS_STATS.gather_table_stats(ownname          => lc_nomusr, --'BANTPROD',
                                                tabname          => 'AQPC366E',
                                                degree           => 1,
                                                granularity      => 'ALL',
                                                estimate_percent => dbms_stats.auto_sample_size,
                                                cascade          => TRUE);
        end; 
        
end sp_cr_carga_tablas;


  procedure sp_columnas_extras_2025(
                                    p_fecha_proceso in date,
                                    p_xwfempresa in number,
                                    p_xwfsucursal in number,
                                    p_xwfmodulo in number,
                                    p_xwfmoneda in number,
                                    p_xwfpapel  in number,
                                    p_xwfcuenta  in number,
                                    p_xwfoperacion in number,
                                    p_xwfsubope in number,
                                    p_xwftipope in number,                                    
                                    po_aqpc366tiprep out varchar2,
                                    po_aqpc366flgamor out varchar2,
                                    po_aqpc366fecamor out date,
                                    po_aqpc366tcea out number,
                                    po_aqpc366tea2 out number ) is  
                                    
  -- Fecha de Creación            : 16/04/2025
  -- Autor de Creación            : calarconap
  -- Descripción                  : Se obtiene tipo reprogramacion, flag y fecha de amortiizacion, tcea y tca
       

  vCancelacionAdelantado number;
  vExisteOtroCredito number;    
  v_prepago_total char(2) := 'NO';
  vi_fecha_pago_mes date;
  v_prepago_adelantado number;
  v_pago_cuota number;
  v_pago_cuota_anteriores number; 
  v_primer_dia_mes date;
  v_ultimo_dia_mes date;

    begin
      
    po_aqpc366tiprep        := '';   

    begin

      select TRUNC(TO_DATE(p_fecha_proceso, 'DD/MM/RRRR'), 'MM'),
             LAST_DAY(TO_DATE(p_fecha_proceso, 'DD/MM/RRRR'))
        into v_primer_dia_mes, v_ultimo_dia_mes
        from dual;

    exception
      when others then
        v_primer_dia_mes  := null;
        v_ultimo_dia_mes := null;
    end;    
        
    --flag y fecha de amortizacion
         BEGIN
         
           SELECT CASE WHEN COUNT(1) > 0 THEN 'S' ELSE 'N' END, CASE WHEN COUNT(1) > 0 THEN MAX(t.D012FC) ELSE NULL END  
            INTO po_aqpc366flgamor, po_aqpc366fecamor
             FROM fsd012 t
            where t.pgcod = p_xwfempresa --pn_cod
              and t.aomod = p_xwfmodulo --pn_mod
                 --and t.aosuc = pn_suc jrodriguej 28.06.2021
              and t.aomda = p_xwfmoneda--pn_mda
              and t.aopap = p_xwfpapel --pn_pap
              and t.aocta = p_xwfcuenta --pn_cta
              and t.aooper = p_xwfoperacion --pn_ope
                 --and t.aosbop = pn_sbo
              and t.aotope = p_xwftipope --pn_top
              and t.evtipo = 50
              and t.d012co = 'S'
             -- and t.d012fc <= I.AQPC366BFEC -- pn_fecha;
            -- and t.d012fc <= p_fecha_proceso
            and t.d012fc between v_primer_dia_mes and v_ultimo_dia_mes;
                    
         EXCEPTION
           WHEN OTHERS THEN
             po_aqpc366flgamor := 'N';
             po_aqpc366fecamor := '';
         END;
         
    --Tipo prepago
    begin
      --Busca si tiene otro credito
      select count(1)
        into vExisteOtroCredito
        from XWF700 a
       where a.xwfempresa = p_xwfempresa
         and a.xwfsucursal = p_xwfsucursal
         and a.xwfmodulo = p_xwfmodulo
         and a.xwfmoneda = p_xwfmoneda
         and a.xwfpapel = p_xwfpapel
         and a.xwfcuenta = p_xwfcuenta
         and a.xwfoperacion = p_xwfoperacion
         and a.xwfsubope = p_xwfsubope
         and a.xwftipope = p_xwftipope
         and a.XWFCAR3 <> '1';
    
      if vExisteOtroCredito = 0 then
      
        select nvl(sum(case
                         when AOFVTO >= AOFE99 and AOSTAT = 99 then
                          1
                         else
                          0
                       end) + sum(case
                                    when AOSTAT <> 99 then
                                     2
                                    else
                                     0
                                  end),
                   0)
          into vCancelacionAdelantado
          from fsd010 x, fst111 s
         where x.pgcod = 1
           and x.aomod = s.modulo
           and dscod = 50
           and x.aocta = p_xwfcuenta
           and x.aooper = p_xwfoperacion
           and x.aomod = p_xwfmodulo
           and x.aosuc = p_xwfsucursal
           and x.aomda = p_xwfmoneda
           and x.aopap = p_xwfpapel
           and x.aosbop = p_xwfsubope
           and x.aotope = p_xwftipope;
      
        if vCancelacionAdelantado = 1 then
          v_prepago_total  := 'SI';
          po_aqpc366tiprep := 'PT';
        end if;
      
      end if;
    
      if v_prepago_total = 'NO' then
      
        if po_aqpc366flgamor = 'S' THEN
        
          po_aqpc366tiprep := 'PP';
        
        else 
      
        begin
          --primero obtener la fecha de la cuota del mes correspondiente al reporte generado (fin de mes)
          select ppfpag
            INTO vi_fecha_pago_mes
            from fsd601 a
           where a.pgcod = 1
             and a.Ppcta = p_xwfcuenta
             and a.ppoper = p_xwfoperacion
             and a.ppmod = p_xwfmodulo
             and a.ppsuc = p_xwfsucursal
             and a.ppmda = p_xwfmoneda
             and a.pppap = p_xwfpapel
             and a.ppsbop = p_xwfsubope
             and a.pptope = p_xwftipope --PPCAP>0
                --AND A.PPFPAG <= v_ultimo_dia_mes
             and ppfpag between v_primer_dia_mes and v_ultimo_dia_mes;
        EXCEPTION
          WHEN OTHERS THEN
            vi_fecha_pago_mes := null;
        end;
      
        begin
          select count(1)
            into v_prepago_adelantado
            from fsd602 d
           where d.pgcod = 1
             and d.ppcta = p_xwfcuenta
             and d.ppoper = p_xwfoperacion
             and d.ppmod = p_xwfmodulo
             and d.ppsuc = p_xwfsucursal
             and d.ppmda = p_xwfmoneda
             and d.pppap = p_xwfpapel
             and d.ppsbop = p_xwfsubope
             and d.pptope = p_xwftipope             
             and TO_NUMBER(TO_CHAR(D.PPFPAG, 'YYYYMM')) >
                 TO_NUMBER(TO_CHAR(D.PP1FECH, 'YYYYMM'))
             and PP1FECH between v_primer_dia_mes and v_ultimo_dia_mes
             AND D.D602CO = 'S'
             AND D.PP1STAT = 'T' and d.PP1CAP>0;
        EXCEPTION
          WHEN OTHERS THEN
            v_prepago_adelantado:= 0;
        end;
      
        --Pago de mes
        begin
          select COUNT(1)
            INTO v_pago_cuota
            from fsd602 d
           where d.pgcod = 1
             and d.ppcta = p_xwfcuenta
             and d.ppoper = p_xwfoperacion
             and d.ppmod = p_xwfmodulo
             and d.ppsuc = p_xwfsucursal
             and d.ppmda = p_xwfmoneda
             and d.pppap = p_xwfpapel
             and d.ppsbop = p_xwfsubope
             and d.pptope = p_xwftipope    
             and D.PPFPAG = vi_fecha_pago_mes
             AND D602CO = 'S'
             AND D.PP1STAT = 'T'
             and d.PP1CAP > 0;
        EXCEPTION
          WHEN OTHERS THEN
            v_pago_cuota := 0;
            null;
        end;
        
        --Pago cuota de un mes (puede ser mes o meses anteriores)
        begin
          select COUNT(1)
            INTO v_pago_cuota_anteriores
            from fsd602 d
           where d.pgcod = 1
             and d.ppcta = p_xwfcuenta
             and d.ppoper = p_xwfoperacion
             and d.ppmod = p_xwfmodulo
             and d.ppsuc = p_xwfsucursal
             and d.ppmda = p_xwfmoneda
             and d.pppap = p_xwfpapel
             and d.ppsbop = p_xwfsubope
             and d.pptope = p_xwftipope --and D.PPFPAG = vi_fecha_pago_mes
             and PP1FECH between v_primer_dia_mes and p_fecha_proceso --v_ultimo_dia_mes
             AND D602CO = 'S'
             AND D.PP1STAT = 'T'
             and d.PP1CAP > 0;
        EXCEPTION
          WHEN OTHERS THEN
            v_pago_cuota_anteriores := 0;
            null;
        end; 
      
        if v_prepago_adelantado > 0 and vi_fecha_pago_mes is not null then
          po_aqpc366tiprep := 'PA';
        ELSIF (v_pago_cuota > 0 and vi_fecha_pago_mes is not null) or v_pago_cuota_anteriores > 0 then
          po_aqpc366tiprep := 'PC';
        end if;
      
      END IF;
      
      end if;
      
    EXCEPTION
      WHEN OTHERS THEN
        --vaqpc366tiprep := 'ERROR TIPO PREPAGO';
        po_aqpc366tiprep := '.';
    end;  
         
   --TCEA                        
    begin
    
      select b.aqpb161tceawf
        into po_aqpc366tcea
        from aqpb161a b
       where b.aqpb161inst in (select min(x.xwfprcins)
                                 from xwf700 x
                                where -- x.xwfempresa = AQPC366HEMP
                               --and x.xwfsucursal = AQPC366HSUC
                               --and x.xwfmodulo = AQPC366HMOD
                               -- and x.xwfmoneda = AQPC366HMNDA
                               --  and x.xwfpapel = AQPC366HPAPL
                               --and 
                                x.xwfcuenta = p_xwfcuenta
                            and x.xwfoperacion = p_xwfoperacion
                            and x.xwfsubope = 0 --AQPC366HSBOP
                               --and x.xwftipope = AQPC366HTOPE
                            and x.xwfcar3 = '1')
         and b.aqpb161est = 'H';
    
    exception
      when others then
        po_aqpc366tcea := 0;
    end;

    --TEA2         
         begin
         
           select x.XLLTASAP
             into po_aqpc366tea2
             from x054023 x
            where x.xllaocta = p_xwfcuenta
              and x.xllaooper = p_xwfoperacion;
         exception
           when others then
             po_aqpc366tea2 := 0;
         end;

      end sp_columnas_extras_2025;

end pq_cr_reporte_impulso;
/
